(* -------------------------------------------------------------------- *)
(* The rejection-sampling stream algebra shared by the ML-DSA samplers: *)
(* a byte stream decodes to candidates, accepted candidates map to      *)
(* coefficients; plus the XOF-slice and staged four-lane layers.        *)
(*                                                                      *)
(* Instances: AexpandT (3-byte candidates, align 3, coeff = idfun) and  *)
(* ErrorSamplerEta4T (nibbles, align 1, coeff = 4 - z).                 *)
(* -------------------------------------------------------------------- *)
require import AllCore List IntDiv IntMin BitEncoding.
import BitChunking.

from Jasmin require import JWord JUtils.

require import Agree.
require import Array4 Array256.

(* -------------------------------------------------------------------- *)
(* the largest k <= K satisfying p (when some i <= K does)               *)
lemma argmax_bounded (p : int -> bool) (K i : int) :
  0 <= i <= K => p i =>
  let m = argmax idfun (fun k => k <= K /\ p k) in
  0 <= m <= K /\ p m /\ i <= m.
proof.
move=> rgi hpi /=; pose q := fun k => k <= K /\ p k.
have hq : q (argmax idfun q) by apply (argmaxP idfun q i (K + 1)) => /#.
have := argmax_max idfun q (K + 1) _ _ i; 1,2: smt().
by smt(ge0_argmax).
qed.

(* -------------------------------------------------------------------- *)
abstract theory RejStream.

type cand.

(* the primitive decoder of one align-sized group of bytes             *)
op dec1  : W8.t list -> cand list.
op align : int.

axiom gt0_align : 0 < align.

op accept : cand -> bool.
op coeff  : cand -> W32.t.

(* decoding is group-local: the candidate stream of a byte stream      *)
op decode (bs : W8.t list) : cand list =
  flatten (map dec1 (chunk align bs)).

lemma decode_nil : decode [] = [].
proof. by rewrite /decode chunk_nil. qed.

lemma decode_cat (xs ys : W8.t list) :
  align %| size xs => decode (xs ++ ys) = decode xs ++ decode ys.
proof.
by move=> h; rewrite /decode chunk_cat // map_cat flatten_cat.
qed.

(* -------------------------------------------------------------------- *)
op [opaque] reject (bs : W8.t list) : W32.t list =
  map coeff (filter accept (decode bs)).

lemma rejectE (bs : W8.t list) :
  reject bs = map coeff (filter accept (decode bs)).
proof. by rewrite /reject. qed.

lemma reject_nil : reject [] = [].
proof. by rewrite rejectE decode_nil. qed.

hint simplify reject_nil.

lemma reject_cat (xs ys : W8.t list) :
  align %| size xs =>
  reject (xs ++ ys) = reject xs ++ reject ys.
proof. by move=> h; rewrite !rejectE decode_cat // filter_cat map_cat. qed.

(* -------------------------------------------------------------------- *)
(* the XOF byte-stream layer                                            *)
op rate  : int.
op slice : W8.t list -> int -> int -> W8.t list.

axiom ge0_rate   : 0 <= rate.
axiom align_rate : align %| rate.

axiom size_slice (n : W8.t list) (i m : int) :
  0 <= m => size (slice n i m) = m.
axiom slice_cat (n : W8.t list) (i m l : int) :
  0 <= m => 0 <= l =>
  slice n i (m + l) = slice n i m ++ slice n (i + m) l.

lemma reject_slice_block (n : W8.t list) (m l : int) :
  0 <= m => 0 <= l => align %| m =>
  reject (slice n 0 (m + l))
  = reject (slice n 0 m) ++ reject (slice n m l).
proof.
move=> hm hl hdvd; rewrite slice_cat //=.
by rewrite reject_cat // size_slice.
qed.

(* a group-incomplete tail decodes to nothing                           *)
lemma reject_short (bs : W8.t list) :
  size bs < align => reject bs = [].
proof.
move=> hsz; rewrite rejectE /decode /chunk.
by rewrite pdiv_small 1:size_ge0 1:// mkseq0.
qed.

lemma reject_slice_trunc (n : W8.t list) (m : int) :
  0 <= m => reject (slice n 0 m) = reject (slice n 0 (align * (m %/ align))).
proof.
move=> hm; have ha := gt0_align.
rewrite {1}(_ : m = align * (m %/ align) + m %% align) 1:#smt:(divz_eq).
rewrite reject_slice_block 1:#smt:(divz_ge0) 1:#smt:(modz_ge0) 1:dvdz_mulr 1:dvdzz.
by rewrite (reject_short (slice _ _ (m %% align))) 1:size_slice 1,2:#smt:(modz_ge0 ltz_pmod) cats0.
qed.

(* longer stream prefixes extend the accepted list                      *)
lemma reject_slice_prefix (n : W8.t list) (m1 m2 : int) :
  0 <= m1 <= m2 =>
  exists l, reject (slice n 0 m2) = reject (slice n 0 m1) ++ l.
proof.
move=> [h1 h12]; have ha := gt0_align.
rewrite (reject_slice_trunc n m1) //; pose a := align * (m1 %/ align).
have [ha0 hle] : 0 <= a <= m2 by smt(divz_ge0 lez_floor).
exists (reject (slice n a (m2 - a))).
have {1}-> : m2 = a + (m2 - a) by ring.
by rewrite reject_slice_block //; smt(dvdz_mulr dvdzz).
qed.

(* -------------------------------------------------------------------- *)
(* the sampled polynomial: the first 256 accepted coefficients of the   *)
(* shortest stream prefix that holds them                               *)
op rfuel (n : W8.t list) : int =
  argmin idfun (fun m => 256 <= size (reject (slice n 0 m))).

op rpoly (n : W8.t list) : W32.t Array256.t =
  Array256.init (fun j => nth W32.zero (reject (slice n 0 (rfuel n))) j).

lemma rpolyP (n : W8.t list) (m j : int) :
  0 <= m => 256 <= size (reject (slice n 0 m)) => 0 <= j < 256 =>
  (rpoly n).[j] = nth W32.zero (reject (slice n 0 m)) j.
proof.
move=> hm hsz rgj; rewrite /rpoly Array256.initiE //=.
pose p := fun m => 256 <= size (reject (slice n 0 m)).
have hf : p (argmin idfun p) by apply (argminP idfun p m).
have hle : argmin idfun p <= m by smt(argmin_min).
have [l ->] := reject_slice_prefix n (argmin idfun p) m _; 1: smt(ge0_argmin).
by rewrite nth_cat; smt().
qed.

(* the termination criterion of a lane: its stream eventually holds 256 *)
(* accepted candidates; [stream_fuel] is the first block count that does *)
op stream_ok (n : W8.t list) =
  exists k, 0 <= k /\ 256 <= size (reject (slice n 0 (rate * k))).

op stream_fuel (n : W8.t list) =
  argmin idfun (fun k => 256 <= size (reject (slice n 0 (rate * k)))).

lemma stream_fuelP (n : W8.t list) (k : int) :
  stream_ok n => stream_fuel n <= k =>
  256 <= size (reject (slice n 0 (rate * k))).
proof.
move=> [k0 [ge0_k0 hk0]] hle; have hr := ge0_rate.
pose p := fun k => 256 <= size (reject (slice n 0 (rate * k))).
have hp : p (stream_fuel n) by apply (argminP idfun p k0).
have [l ->] := reject_slice_prefix n (rate * stream_fuel n) (rate * k) _.
- have h0 : 0 <= stream_fuel n by rewrite /stream_fuel ge0_argmin.
  by split; [smt() | smt(StdOrder.IntOrder.ler_wpmul2l)].
by rewrite size_cat; smt(size_ge0).
qed.

(* -------------------------------------------------------------------- *)
(* a sampled polynomial holds the accepted prefix, count capped at 256  *)
op reject_ok (nonce : W8.t list) (sz : int) (p : W32.t Array256.t) (filled : int) =
     agree p 0 (reject (slice nonce 0 sz))
  /\ filled = min 256 (size (reject (slice nonce 0 sz))).

(* a finished lane satisfies the invariant at any longer prefix         *)
lemma reject_ok_full (nonce : W8.t list) (m l : int) (p : W32.t Array256.t) :
  0 <= m => 0 <= l => align %| m =>
  reject_ok nonce m p 256 =>
  reject_ok nonce (m + l) p 256.
proof.
move=> hm hl hdvd @/reject_ok [hag hf].
rewrite reject_slice_block //; split.
- by apply agree_full; [smt(size_ge0) | exact hag].
by smt(size_cat size_ge0).
qed.

(* -------------------------------------------------------------------- *)
(* the four sampling lanes, staged: lanes below j are one block ahead   *)
op lanes_ok (data : W8.t list Array4.t) (k j : int)
            (ps : W32.t Array256.t list) (fs : W64.t list) =
  forall i, 0 <= i < 4 =>
    reject_ok data.[i] (rate * (k + b2i (i < j)))
      (nth witness ps i) (to_uint (nth witness fs i)).

(* the intro rule: one goal per lane, no case analysis at use sites     *)
lemma lanes_okP (data : W8.t list Array4.t) (k j : int) p0 p1 p2 p3 f0 f1 f2 f3 :
  reject_ok data.[0] (rate * (k + b2i (0 < j))) p0 (to_uint f0) =>
  reject_ok data.[1] (rate * (k + b2i (1 < j))) p1 (to_uint f1) =>
  reject_ok data.[2] (rate * (k + b2i (2 < j))) p2 (to_uint f2) =>
  reject_ok data.[3] (rate * (k + b2i (3 < j))) p3 (to_uint f3) =>
  lanes_ok data k j [p0; p1; p2; p3] [f0; f1; f2; f3].
proof.
move=> h0 h1 h2 h3 i rgi.
by have [->|[->|[->|->]]] /=: i = 0 \/ i = 1 \/ i = 2 \/ i = 3 by smt().
qed.

(* staging advances one lane at a time: only lane j's prefix grows      *)
lemma lanes_ok_advance (data : W8.t list Array4.t) (k j : int) ps fs :
  0 <= j < 4 =>
  lanes_ok data k j ps fs =>
  reject_ok data.[j] (rate * (k + 1))
    (nth witness ps j) (to_uint (nth witness fs j)) =>
  lanes_ok data k (j + 1) ps fs.
proof.
move=> rgj hln hj i rgi; case: (i = j) => [->|ne_ij].
- by rewrite (_ : b2i (j < j + 1) = 1) 1:/#.
by rewrite (_ : b2i (i < j + 1) = b2i (i < j)) 1:/#; apply hln.
qed.

(* a full lane advances for free                                        *)
lemma lanes_ok_advance_full (data : W8.t list Array4.t) (k j : int) ps fs :
  0 <= k => 0 <= j < 4 =>
  lanes_ok data k j ps fs =>
  to_uint (nth witness fs j) = 256 =>
  lanes_ok data k (j + 1) ps fs.
proof.
move=> hk rgj hln hfull; apply lanes_ok_advance => //.
move: (hln j rgj); rewrite hfull (_ : b2i (j < j) = 0) 1:/# /= => hok.
rewrite (_ : rate * (k + 1) = rate * k + rate) 1:#ring.
apply reject_ok_full => //; 1,2:smt(ge0_rate).
by apply dvdz_mulr; apply align_rate.
qed.

(* all four lanes staged means the next block index starts unstaged     *)
lemma lanes_ok_wrap (data : W8.t list Array4.t) (k : int) ps fs :
  lanes_ok data k 4 ps fs => lanes_ok data (k + 1) 0 ps fs.
proof.
move=> hln i rgi; move: (hln i rgi).
by rewrite (_ : b2i (i < 4) = 1) 1:/# (_ : b2i (i < 0) = 0) 1:/# /#.
qed.

(* -------------------------------------------------------------------- *)
(* each lane buffer starts with the block squeezed at offset rate * k   *)
type buf.

op headb : buf -> W8.t list.

op blocks_ok (data : W8.t list Array4.t) (k : int) (bs : buf list) =
  forall i, 0 <= i < 4 =>
    headb (nth witness bs i) = slice data.[i] (rate * k) rate.

end RejStream.
