require import AllCore IntDiv List IntMin.
from Jasmin require import JByte_array JWord.
require import Array256.
from CryptoSpecs require import Keccak1600_Spec.
from CryptoSpecs require import Keccak1600_Orbit.
require import Parameters GFq Rq.
require import Rejstream.
require import Symmetric.
require import Leakage.

abstract theory SamplingT.

clone include Symmetric.SymmetricT.

import PolyLVec PolyKVec PolyMat.
import Round ZModQ Zq MLDSAParams.

op "_.[_]" : 'a list -> int -> 'a = nth witness.

(* The leakage of SampleInBall: the pairs (stream position after the read,
   byte read) of the rejection loop, declassified (flat leakage model) *)
type sib_leakage = leakage.

module type LeakyRO(XOF : XOF_SIB) = {
   proc init() : unit
   proc get(mu : Bytes64.t, w1 : BytesW1.t) : (BytesCT.t * poly) * sib_leakage
}.

module SampleInBall(XOF : XOF_SIB) = {
   proc sample(rho : BytesCT.t) : poly * sib_leakage = {
      var leak : (int * int) list;
      var ctx : int;
      var s : Bytes8.t;
      var h : bool list;
      var i,j;
      var c : poly;
      leak <- [];
      ctx <- 8;
      c <- poly_zero;
      s <- H_sib rho;
      h <- BytesToBits (Bytes8.to_list s);
      XOF.init(rho);
      i <- 256 - tau;
      while (i < 256) {
          j <@ XOF.next();
          ctx <- ctx + 1;
          leak <- rcons leak (ctx, W8.to_uint j);
          while(i < W8.to_uint j) {
            j <@ XOF.next();
            ctx <- ctx + 1;
            leak <- rcons leak (ctx, W8.to_uint j);
          }
          c.[i] <- c.[W8.to_uint j];
          c.[W8.to_uint j] <- if h.[i+tau-256] then incoeff (-1) else incoeff (1);
          i <- i + 1;
      }
      return (c, pairs_to_leakage leak);
   }
}.

(*************** Begin SampleInBall CORRECTNESS BRIDGE ****************)


(* FIPS 204 Alg. 29 as a function of the XOF stream: bytes 0..7 of
   SHAKE256(ct) are the sign bits, the rejection loop reads the stream
   from position 8 on *)
op sib_byte (ct : BytesCT.t) (t : int) : int =
  W8.to_uint (nth witness (SHAKE256 (BytesCT.to_list ct) (t + 1)) t).

op sib_signs (ct : BytesCT.t) : bool list =
  BytesToBits (Bytes8.to_list (H_sib ct)).

(* the number of bytes index i rejects from stream position p *)
op sib_skip (ct : BytesCT.t) (i p : int) : int =
  argmin idfun (fun k => sib_byte ct (p + k) <= i).

(* one iteration of the outer loop on (c, leaked pairs, stream position):
   the k rejected bytes and the accepted one, read at positions p .. p + k,
   leak the pairs (p + m + 1, byte at p + m) *)
op sib_step (ct : BytesCT.t) (st : poly * (int * int) list * int) (i : int) =
  let k = sib_skip ct i st.`3 in
  let j = sib_byte ct (st.`3 + k) in
  (st.`1.[i <- st.`1.[j]].[j <- if (sib_signs ct).[i + tau - 256]
                                then incoeff (-1) else incoeff 1],
   st.`2 ++ map (fun m => (st.`3 + m + 1, sib_byte ct (st.`3 + m))) (iota_ 0 (k + 1)),
   st.`3 + k + 1).

op sib_iter (ct : BytesCT.t) (n : int) : poly * (int * int) list * int =
  foldl (sib_step ct) (poly_zero, [], 8) (iota_ (256 - tau) n).

op sampleInBall (ct : BytesCT.t) : poly * sib_leakage =
  ((sib_iter ct tau).`1, pairs_to_leakage (sib_iter ct tau).`2).

(* the termination criterion of Alg. 29: every index finds an
   acceptable byte after the current stream position *)
op sib_ok (ct : BytesCT.t) : bool =
  forall n, 0 <= n < tau =>
    exists k, 0 <= k /\ sib_byte ct ((sib_iter ct n).`3 + k) <= 256 - tau + n.

lemma sib_iterS (ct : BytesCT.t) (n : int) : 0 <= n =>
  sib_iter ct (n + 1) = sib_step ct (sib_iter ct n) (256 - tau + n).
proof. by move=> ge0n; rewrite /sib_iter iotaSr // foldl_rcons. qed.


lemma sib_skipP (ct : BytesCT.t) (i p : int) :
  (exists k, 0 <= k /\ sib_byte ct (p + k) <= i) =>
     0 <= sib_skip ct i p
  /\ sib_byte ct (p + sib_skip ct i p) <= i
  /\ forall k, 0 <= k < sib_skip ct i p => i < sib_byte ct (p + k).
proof.
move=> [k0 [ge0k0 hk0]]; pose q := fun k => sib_byte ct (p + k) <= i.
split; 1: by rewrite /sib_skip ge0_argmin.
split; 1: by apply (argminP idfun q k0).
by move=> k rgk; have := argmin_min idfun q k rgk => /#.
qed.

(* partial correctness: after n outer iterations the state (c, leakage,
   XOF position) is sib_iter n; the inner loop rejects exactly the bytes
   before the first acceptable one, i.e. sib_skip of them *)
lemma SampleInBall_h (_ct : BytesCT.t) :
  hoare [ SampleInBall(MLDSA_XOF_SIB).sample : rho = _ct ==> res = sampleInBall _ct ].
proof.
have [ge1t ltau] := tau_bound.
proc; inline MLDSA_XOF_SIB.init.
while (XOFSIB_state.seed = BytesCT.to_list _ct /\ h = sib_signs _ct /\ 256 - tau <= i <= 256
  /\ ctx = XOFSIB_state.pos
  /\ (c, leak, XOFSIB_state.pos) = sib_iter _ct (i - (256 - tau))).
- exlim (sib_iter _ct (i - (256 - tau))) => st.
  inline MLDSA_XOF_SIB.next; wp.
  while (XOFSIB_state.seed = BytesCT.to_list _ct /\ h = sib_signs _ct /\ 256 - tau <= i < 256
     /\ st = sib_iter _ct (i - (256 - tau))
     /\ c = st.`1 /\ 0 <= XOFSIB_state.pos - 1 - st.`3 /\ ctx = XOFSIB_state.pos
     /\ leak = st.`2 ++ map (fun m => (st.`3 + m + 1, sib_byte _ct (st.`3 + m)))
                            (iota_ 0 (XOFSIB_state.pos - st.`3))
     /\ to_uint j = sib_byte _ct (XOFSIB_state.pos - 1)
     /\ forall k, 0 <= k < XOFSIB_state.pos - 1 - st.`3 => i < sib_byte _ct (st.`3 + k)).
  + wp; skip => &hr [#] hs hh rgi lti hst hc ge0 hctx hl hj hmin hg /=.
    do 7! (split; 1: smt()).
    split.
    * rewrite hl (_ : XOFSIB_state.pos{hr} + 1 - st.`3 = (XOFSIB_state.pos{hr} - st.`3) + 1) 1:#ring.
      rewrite iotaSr 1:/# map_rcons -rcons_cat /=.
      rewrite hctx (_ : st.`3 + (XOFSIB_state.pos{hr} - st.`3) = XOFSIB_state.pos{hr}) 1:#ring.
      by rewrite /sib_byte hs.
    split; 1: by rewrite /sib_byte hs.
    move=> k rgk; case: (k = XOFSIB_state.pos{hr} - 1 - st.`3) => [->>|ne]; 2: by apply hmin => /#.
    by rewrite (_ : st.`3 + (XOFSIB_state.pos{hr} - 1 - st.`3) = XOFSIB_state.pos{hr} - 1) 1:#ring -hj.
  wp; skip => &hr [hst [[hs [hh [rg [hctx hcl]]]] hlt]].
  rewrite -hst in hcl.
  have hc : c{hr} = st.`1 by rewrite -hcl.
  have hl : leak{hr} = st.`2 by rewrite -hcl.
  have hp : XOFSIB_state.pos{hr} = st.`3 by rewrite -hcl.
  split.
  - rewrite hp hctx hp; do 7! (split; 1: smt()).
    split.
    + rewrite hl (_ : st.`3 + 1 - st.`3 = 0 + 1) 1:#ring iotaSr //= iota0 //=.
      by rewrite -cats1 /sib_byte hs.
    split; 1: by rewrite /sib_byte hs.
    smt().
  move=> pos ctx0 j0 l0 hge [#] _ _ _ _ _ _ hk0 -> -> hj0 hmin /=.
  have hsk : sib_skip _ct i{hr} st.`3 = pos - 1 - st.`3.
  - rewrite /sib_skip (argmin_eq idfun _ (pos - 1 - st.`3)) //=.
    + by rewrite (_ : st.`3 + (pos - 1 - st.`3) = pos - 1) 1:#ring -hj0 /#.
    by move=> k rgk; have := hmin k _ => /#.
  do 3! (split; 1: smt()).
  rewrite (_ : i{hr} + 1 - (256 - tau) = (i{hr} - (256 - tau)) + 1) 1:#ring sib_iterS 1:/# -hst.
  rewrite (_ : 256 - tau + (i{hr} - (256 - tau)) = i{hr}) 1:#ring /sib_step /= hsk.
  have hj : sib_byte _ct (st.`3 + (pos - 1 - st.`3)) = to_uint j0.
  - by rewrite hj0; congr; ring.
  rewrite hj hc hh /=.
  by split; [do 3! congr; ring | ring].
auto=> />; split; 1: by rewrite /sib_iter iota0 /= /sib_signs; smt().
move=> pos c0 i0 l0 hge _ hle hc0.
have ->> : i0 = 256 by smt().
rewrite (_ : 256 - (256 - tau) = tau) 1:#ring => hc0'.
by rewrite /sampleInBall -hc0'.
qed.

(* termination, under the criterion: the inner variant is sib_skip minus
   the bytes rejected so far, the outer one 256 - i *)
lemma SampleInBall_ll (_ct : BytesCT.t) : sib_ok _ct =>
  phoare [ SampleInBall(MLDSA_XOF_SIB).sample : rho = _ct ==> true ] = 1%r.
proof.
move=> hok; have [ge1t ltau] := tau_bound.
proc; inline MLDSA_XOF_SIB.init.
while (XOFSIB_state.seed = BytesCT.to_list _ct /\ 256 - tau <= i <= 256
  /\ XOFSIB_state.pos = (sib_iter _ct (i - (256 - tau))).`3) (256 - i).
- move=> z; exlim i => i0.
  case @[ambient]: (256 - tau <= i0 < 256) => hi0; last first.
  + by conseq (_ : false ==> _) => // &hr [#] /#.
  have [hs0 [hb0 hm0]] := sib_skipP _ct i0 (sib_iter _ct (i0 - (256 - tau))).`3 _.
  + have := hok (i0 - (256 - tau)) _; 1: smt().
    by rewrite (_ : 256 - tau + (i0 - (256 - tau)) = i0) 1:#ring.
  pose p0 := (sib_iter _ct (i0 - (256 - tau))).`3.
  inline MLDSA_XOF_SIB.next; wp.
  while (XOFSIB_state.seed = BytesCT.to_list _ct /\ i = i0 /\ 256 - i = z
     /\ 0 <= XOFSIB_state.pos - 1 - p0
     /\ to_uint j = sib_byte _ct (XOFSIB_state.pos - 1)
     /\ (forall k, 0 <= k < XOFSIB_state.pos - 1 - p0 => i < sib_byte _ct (p0 + k)))
    (sib_skip _ct i0 p0 - (XOFSIB_state.pos - 1 - p0)).
  + move=> z'; wp; skip => &hr [[[hs [-> [hz [hk [hj hmin]]]]] hg] hz'] /=.
    have hlt : XOFSIB_state.pos{hr} - 1 - p0 < sib_skip _ct i0 p0.
    * rewrite ltzNge; apply/negP => hle.
      case: (XOFSIB_state.pos{hr} - 1 - p0 = sib_skip _ct i0 p0) => heq.
      - by move: hb0 hg; rewrite -/p0 -heq hj (_ : p0 + (XOFSIB_state.pos{hr} - 1 - p0) = XOFSIB_state.pos{hr} - 1) 1:#ring /#.
      by have := hmin (sib_skip _ct i0 p0) _; smt().
    split; 2: smt().
    do 3! (split; 1: smt()).
    split; 1: by rewrite /sib_byte hs.
    move=> k rgk; case: (k = XOFSIB_state.pos{hr} - 1 - p0) => [->>|ne]; 2: by apply hmin => /#.
    by rewrite (_ : p0 + (XOFSIB_state.pos{hr} - 1 - p0) = XOFSIB_state.pos{hr} - 1) 1:#ring -hj.
  wp; skip => &hr [<- [[[hs [rg hp]] hlt] hz]] /=.
  split.
  - rewrite hs hp -/p0 /=; split; 1: smt().
    split; 1: by rewrite /sib_byte.
    smt().
  move=> pos j0; split.
  - move=> [#] _ _ hk hj hmin hv; rewrite hj -lezNgt.
    have -> : pos - 1 = p0 + sib_skip _ct i0 p0.
    + case: (pos - 1 - p0 = sib_skip _ct i0 p0) => [/#|ne].
      by have := hmin (sib_skip _ct i0 p0) _; smt().
    exact hb0.
  move=> hg [#] _ _ hk hj hmin.
  have hpos : pos = p0 + sib_skip _ct i0 p0 + 1.
  - case: (pos - 1 - p0 < sib_skip _ct i0 p0) => hc.
    + by have := hm0 (pos - 1 - p0) _; [smt() | rewrite -/p0 (_ : p0 + (pos - 1 - p0) = pos - 1) 1:#ring -hj /#].
    case: (pos - 1 - p0 = sib_skip _ct i0 p0) => [/#|ne].
    by have := hmin (sib_skip _ct i0 p0) _; smt().
  split; 2: smt().
  do 2! (split; 1: smt()).
  rewrite (_ : i0 + 1 - (256 - tau) = (i0 - (256 - tau)) + 1) 1:#ring sib_iterS 1:/#.
  by rewrite (_ : 256 - tau + (i0 - (256 - tau)) = i0) 1:#ring /sib_step /= hpos.
auto=> />; split; 1: by rewrite /sib_iter iota0 /=; smt().
smt().
qed.

(* -------------------------------------------------------------------- *)
(* Termination: Keccak-f[1600] is a permutation, so the padded block of *)
(* a single-block seed recurs in its SHAKE stream once per period of the *)
(* absorbed state (Keccak1600_Orbit), and its zero bytes are accepted by *)
(* every sampler; [count_grows] turns this into unbounded growth.       *)
(* SampleInBall: a zero byte of the stream lies beyond any position, and
   zero is accepted at every index *)
lemma sib_terminates (ct : BytesCT.t) : sib_ok ct.
proof.
have hsz : size (BytesCT.to_list ct) < 65.
- by rewrite BytesCT.size_to_list; have := param_sets; smt().
have h136 : size (BytesCT.to_list ct) < 136 by apply (StdOrder.IntOrder.ltr_trans 65).
have [L [gt0L hL]] := SHAKE256_zero_run _ h136.
have [ge1t ltau] := tau_bound.
move=> n rgn; pose p := (sib_iter ct n).`3.
pose K := `|p| + 1.
have hK1 : 1 <= K by rewrite /K; smt().
have hKL : K <= K * L.
- by rewrite -{1}(mulz1 K) StdOrder.IntOrder.ler_wpmul2l 1:/# /#.
pose t := (K * L - 1) * 136 + 65.
have ht : p <= t.
- have : (K - 1) * 136 <= (K * L - 1) * 136 by apply StdOrder.IntOrder.ler_wpmul2r => /#.
  rewrite /t /K; smt().
exists (t - p); split; 1: smt().
rewrite (_ : p + (t - p) = t) 1:#ring /sib_byte /t hL //; 1: smt().
smt().
qed.

phoare SampleInBall_correct _ct :
   [ SampleInBall(MLDSA_XOF_SIB).sample : arg = _ct ==> res = sampleInBall _ct] = 1%r.
proof. by conseq (SampleInBall_ll _ct (sib_terminates _ct)) (SampleInBall_h _ct). qed.

(* -------------------------------------------------------------------- *)
(* The challenge polynomial has tau nonzero coefficients, each ±1, so its l1
   norm is at most tau (FIPS 204 Alg. 29 writes tau values ±1, at distinct or
   repeated positions).  This is the bound the |c * s2| <= Beta argument
   needs (VecMat.cs2_norm_bound); |c|_inf < 2 alone does not suffice.
   Each outer iteration moves one coefficient and writes a ±1, so it adds
   at most one to the l1 norm. *)
lemma l1_set (c : poly) (i : int) (v : coeff) : 0 <= i < 256 =>
  l1 c.[i <- v] = l1 c - `|c.[i]| + `|v|.
proof.
move=> rgi; rewrite /l1.
rewrite !(StdBigop.Bigint.BIA.big_cat_int i 0 256) 1..4:/#.
rewrite !(StdBigop.Bigint.BIA.big_cat_int (i + 1) i 256) 1..4:/#.
rewrite !StdBigop.Bigint.BIA.big_int1 /predT /= Array256.get_setE 1:/# /=.
rewrite (StdBigop.Bigint.BIA.eq_big_int 0 i _ (fun k => `|c.[k]|)).
- by move=> k rgk /=; rewrite Array256.get_setE 1:/# ifF 1:/#.
rewrite (StdBigop.Bigint.BIA.eq_big_int (i + 1) 256 _ (fun k => `|c.[k]|)).
- by move=> k rgk /=; rewrite Array256.get_setE 1:/# ifF 1:/#.
by rewrite /predT /=; ring.
qed.

lemma sib_iter_l1 (ct : BytesCT.t) (n : int) : 0 <= n <= tau =>
  l1 (sib_iter ct n).`1 <= n.
proof.
have [ge1t ltau] := tau_bound.
move=> [ge0m]; elim: n ge0m => [|m ge0m ih] lem.
- have -> : (sib_iter ct 0).`1 = poly_zero by rewrite /sib_iter iota0.
  rewrite /l1 (StdBigop.Bigint.BIA.eq_big_int 0 256 _ (fun _ => 0)).
  + by move=> i rgi /=; rewrite /poly_zero Array256.createiE // -incoeff0 abs_incoeff.
  by rewrite StdBigop.Bigint.BIA.big1_eq.
rewrite sib_iterS // /sib_step /=.
pose c := (sib_iter ct m).`1.
pose j := sib_byte ct ((sib_iter ct m).`3 + sib_skip ct (256 - tau + m) (sib_iter ct m).`3).
have rgj : 0 <= j < 256.
- by rewrite /j /sib_byte; move: (nth witness _ _) => w; have /= := W8.to_uint_cmp w.
rewrite l1_set // l1_set 1:/#.
have -> : `|c.[256 - tau + m <- c.[j]].[j]| = `|c.[j]|.
- by rewrite Array256.get_setE 1:/#; case: (j = 256 - tau + m) => [->|].
have -> : `|if (sib_signs ct).[256 - tau + m + tau - 256] then incoeff (-1) else incoeff 1| = 1.
- by case: ((sib_signs ct).[256 - tau + m + tau - 256]) => _; rewrite abs_incoeff.
have := ih _; 1: smt().
smt(ge0_abs_zp).
qed.

lemma sampleInBall_norm (ct : BytesCT.t) :
    l1 (sampleInBall ct).`1 <= tau.
proof. by have [ge1t _] := tau_bound; rewrite /sampleInBall /=; apply sib_iter_l1; smt(). qed.

(* The bound is in fact an equality: the swap of Alg. 29 picks j <= i and the
   coefficients at the indices i, i + 1, ... are still zero, so every outer
   iteration adds exactly one to the l1 norm (needs the termination
   criterion, which always holds: sib_terminates). *)
lemma sib_iter_l1eq (ct : BytesCT.t) (n : int) : 0 <= n <= tau =>
     l1 (sib_iter ct n).`1 = n
  /\ forall k, 256 - tau + n <= k < 256 => (sib_iter ct n).`1.[k] = zero.
proof.
have [ge1t ltau] := tau_bound.
have abs0 : `|Zq.zero| = 0 by rewrite -incoeff0 abs_incoeff.
move=> [ge0m]; elim: n ge0m => [|m ge0m ih] lem.
- have -> : (sib_iter ct 0).`1 = poly_zero by rewrite /sib_iter iota0.
  split=> [|k rgk]; 2: by rewrite /poly_zero Array256.createiE 1:/#.
  rewrite /l1 (StdBigop.Bigint.BIA.eq_big_int 0 256 _ (fun _ => 0)).
  + by move=> i rgi /=; rewrite /poly_zero Array256.createiE.
  by rewrite StdBigop.Bigint.BIA.big1_eq.
have [ihl ihz] := ih _; 1: smt().
have [_ [hj _]] :=
  sib_skipP ct (256 - tau + m) (sib_iter ct m).`3 (sib_terminates ct m _); 1: smt().
rewrite sib_iterS // /sib_step /=.
pose c := (sib_iter ct m).`1.
pose j := sib_byte ct ((sib_iter ct m).`3 + sib_skip ct (256 - tau + m) (sib_iter ct m).`3).
have rgj : 0 <= j < 256.
- by rewrite /j /sib_byte; move: (nth witness _ _) => w; have /= := W8.to_uint_cmp w.
have hji : j <= 256 - tau + m by rewrite /j.
split=> [|k rgk].
- rewrite l1_set // l1_set 1:/#.
  have -> : `|c.[256 - tau + m <- c.[j]].[j]| = `|c.[j]|.
  + by rewrite Array256.get_setE 1:/#; case: (j = 256 - tau + m) => [->|].
  have -> : `|if (sib_signs ct).[256 - tau + m + tau - 256] then incoeff (-1) else incoeff 1| = 1.
  + by case: ((sib_signs ct).[256 - tau + m + tau - 256]) => _; rewrite abs_incoeff.
  by rewrite /c ihz 1:/# abs0 ihl; ring.
rewrite !Array256.get_setE 1,2:/# ifF 1:/# ifF 1:/#.
by apply ihz => /#.
qed.

lemma sampleInBall_l1 (ct : BytesCT.t) : l1 (sampleInBall ct).`1 = tau.
proof.
have [ge1t _] := tau_bound; rewrite /sampleInBall /=.
by have [-> _] := sib_iter_l1eq ct tau _; smt().
qed.

(*************** End SampleInBall CORRECTNESS BRIDGE ****************)


module (SIB_RO : LeakyRO) (XOF : XOF_SIB) = {
   proc init() = {}
   proc get(mu : Bytes64.t, w1 : BytesW1.t): (BytesCT.t * poly) * sib_leakage = {
        var rr;
        var ct <- H_ct mu w1;
        rr <@ SampleInBall(XOF).sample(ct);
        return ((ct,rr.`1),rr.`2);
   }
}.

import Bytes3.
module RejNTTPoly(XOF : XOF_RejNTTPoly) = {
  proc sample(rho : Bytes34.t) : poly = {
    var j, b3, co;
    var c : poly;
    c <- witness;
    XOF.init(rho);
    j <- 0;
    while (j < 256) {
      b3 <@ XOF.next();
      co <- CoeffFromThreeBytes b3.[0] b3.[1] b3.[2];
      if (co <> None) {
         c.[j] <- incoeff (oget co);
         j <- j + 1;
      }
    }
    return c;
  }
}.

(*************** Begin RejNTTPoly CORRECTNESS BRIDGE ****************)

(* Concrete definition is in Symmetric.ec: MLDSA_XOFA *)


(* FIPS 204 Alg. 30 as a function of the XOF stream (Lean: RejStream).
   ntt_cand rho t decodes bytes 3t, 3t+1, 3t+2 of SHAKE128(rho);
   ntt_accepted rho t lists the accepted candidates among the first t;
   rejNTTPoly rho holds the first 256 of them, taken at the least t where
   256 are available. *)
op ntt_cand (rho : Bytes34.t) (t : int) : int option =
  let s = SHAKE128 (Bytes34.to_list rho) (3 * t + 3) in
  CoeffFromThreeBytes (nth witness s (3 * t)) (nth witness s (3 * t + 1))
                      (nth witness s (3 * t + 2)).

op ntt_accepted (rho : Bytes34.t) (t : int) : int list =
  pmap (ntt_cand rho) (iota_ 0 t).

(* the termination criterion of Alg. 30 *)
op rejNTT_ok (rho : Bytes34.t) : bool =
  exists t, 0 <= t /\ 256 <= size (ntt_accepted rho t).

op rejNTT_fuel (rho : Bytes34.t) : int =
  argmin idfun (fun t => 256 <= size (ntt_accepted rho t)).

op rejNTTPoly (rho : Bytes34.t) : poly =
  Array256.init (fun i => incoeff (nth 0 (ntt_accepted rho (rejNTT_fuel rho)) i)).

lemma ntt_acceptedS (rho : Bytes34.t) (t : int) : 0 <= t =>
  ntt_accepted rho (t + 1)
  = ntt_accepted rho t ++ (if ntt_cand rho t = None then [] else [oget (ntt_cand rho t)]).
proof.
by move=> ge0t; rewrite /ntt_accepted iotaSr // -cats1 pmap_cat /=.
qed.

lemma ntt_accepted_mono (rho : Bytes34.t) (t1 t2 : int) : 0 <= t1 <= t2 =>
  size (ntt_accepted rho t1) <= size (ntt_accepted rho t2).
proof.
move=> [ge0 le].
have h : forall k, 0 <= k => size (ntt_accepted rho t1) <= size (ntt_accepted rho (t1 + k)).
- elim/natind => [k le0k ge0k|k ge0k ih _]; 1: by rewrite (_ : k = 0) 1:/#.
  rewrite (_ : t1 + (k + 1) = (t1 + k) + 1) 1:/# ntt_acceptedS 1:/# size_cat.
  by have := ih ge0k; smt(size_ge0).
by have := h (t2 - t1) _; [smt() | rewrite (_ : t1 + (t2 - t1) = t2) 1:/#].
qed.

lemma ntt_accepted_prefix (rho : Bytes34.t) (t1 t2 i : int) : 0 <= t1 <= t2 =>
  0 <= i < size (ntt_accepted rho t1) =>
  nth 0 (ntt_accepted rho t2) i = nth 0 (ntt_accepted rho t1) i.
proof.
move=> [ge0 le] rgi.
have h : forall k, 0 <= k => nth 0 (ntt_accepted rho (t1 + k)) i = nth 0 (ntt_accepted rho t1) i.
- elim/natind => [k le0k ge0k|k ge0k ih _]; 1: by rewrite (_ : k = 0) 1:/#.
  rewrite (_ : t1 + (k + 1) = (t1 + k) + 1) 1:/# ntt_acceptedS 1:/# nth_cat.
  have := ntt_accepted_mono rho t1 (t1 + k) _; 1: smt().
  by move=> hm; rewrite ifT 1:/# ih.
by have := h (t2 - t1) _; [smt() | rewrite (_ : t1 + (t2 - t1) = t2) 1:/#].
qed.

(* the XOF's next block is the next candidate of the stream *)
lemma ntt_cand_next (rho : Bytes34.t) (t : int) : 0 <= t =>
  CoeffFromThreeBytes
    (nth witness (take 3 (drop (3 * t) (SHAKE128 (Bytes34.to_list rho) (3 * t + 3)))) 0)
    (nth witness (take 3 (drop (3 * t) (SHAKE128 (Bytes34.to_list rho) (3 * t + 3)))) 1)
    (nth witness (take 3 (drop (3 * t) (SHAKE128 (Bytes34.to_list rho) (3 * t + 3)))) 2)
  = ntt_cand rho t.
proof.
move=> ge0t; rewrite /ntt_cand /=.
by congr; rewrite nth_take // nth_drop //#.
qed.

(* partial correctness: after t groups, the XOF is at position 3t, j is
   the number of accepted candidates, c holds them; the loop stops at the
   least t with 256 accepted, i.e. at rejNTT_fuel *)
lemma RejNTTPoly_h (_rho : Bytes34.t) :
  hoare [ RejNTTPoly(MLDSA_XOFA).sample : rho = _rho ==> res = rejNTTPoly _rho ].
proof.
proc; inline MLDSA_XOFA.init.
while (XOFA_state.seed = Bytes34.to_list _rho /\ 0 <= XOFA_state.pos /\ XOFA_state.pos %% 3 = 0
  /\ j = size (ntt_accepted _rho (XOFA_state.pos %/ 3)) /\ j <= 256
  /\ (forall i, 0 <= i < j => c.[i] = incoeff (nth 0 (ntt_accepted _rho (XOFA_state.pos %/ 3)) i))
  /\ (forall t, 0 <= t < XOFA_state.pos %/ 3 => size (ntt_accepted _rho t) < 256)).
- inline MLDSA_XOFA.next; wp; skip => &hr [#] -> ge0p hp3 -> hj hc hmin ltj /=.
  pose t := XOFA_state.pos{hr} %/ 3.
  have hpt : XOFA_state.pos{hr} = 3 * t by smt().
  have hnt : (XOFA_state.pos{hr} + 3) %/ 3 = t + 1 by smt().
  rewrite hnt hpt (ntt_cand_next _ t) 1:/# ntt_acceptedS 1:/#.
  move: hj hc hmin ltj; rewrite -/t => hj hc hmin ltj.
  have hminS : forall t0, 0 <= t0 < t + 1 => size (ntt_accepted _rho t0) < 256.
  + by move=> t0 rgt0; case: (t0 = t) => [->> //|ne]; apply hmin; smt().
  case: (ntt_cand _rho t) => [|v] /=.
  + rewrite cats0 /=; do 3! (split; 1: smt()); split; 2: exact hminS.
    by move=> i rgi; rewrite hc.
  rewrite size_cat /=; do 3! (split; 1: smt()); split; 2: exact hminS.
  move=> i rgi; rewrite Array256.get_setE 1:/# nth_cat.
  case: (i = size (ntt_accepted _rho t)) => [->> /=|ne]; 1: done.
  by rewrite ifT 1:/# hc /#.
auto => />; split; first by rewrite /ntt_accepted iota0 //=; smt().
move=> pos c0 ge256 ge0p hp3 le256 hc hmin.
have hf : rejNTT_fuel _rho = pos %/ 3.
- by rewrite /rejNTT_fuel (argmin_eq idfun _ (pos %/ 3)) //= /#.
by apply Array256.tP => i rgi; rewrite hc 1:/# /rejNTTPoly Array256.initiE //= hf.
qed.

(* termination, under the criterion: the variant is rejNTT_fuel - t *)
lemma RejNTTPoly_ll (_rho : Bytes34.t) : rejNTT_ok _rho =>
  phoare [ RejNTTPoly(MLDSA_XOFA).sample : rho = _rho ==> true ] = 1%r.
proof.
move=> hok; have [t0 [ge0t0 h256]] := hok.
have hfuel : 256 <= size (ntt_accepted _rho (rejNTT_fuel _rho)).
- by apply (argminP idfun (fun t => 256 <= size (ntt_accepted _rho t)) t0).
proc; inline MLDSA_XOFA.init.
while (XOFA_state.seed = Bytes34.to_list _rho /\ 0 <= XOFA_state.pos /\ XOFA_state.pos %% 3 = 0
  /\ j = size (ntt_accepted _rho (XOFA_state.pos %/ 3)))
  (rejNTT_fuel _rho - XOFA_state.pos %/ 3).
- move=> z; inline MLDSA_XOFA.next; wp; skip => &hr [#] -> ge0p hp3 -> ltj hz /=.
  pose t := XOFA_state.pos{hr} %/ 3.
  have hpt : XOFA_state.pos{hr} = 3 * t by smt().
  have hnt : (XOFA_state.pos{hr} + 3) %/ 3 = t + 1 by smt().
  rewrite hnt hpt (ntt_cand_next _ t) 1:/# ntt_acceptedS 1:/#.
  by case: (ntt_cand _rho t) => [|v] /=; rewrite ?cats0 ?size_cat /= /#.
auto => />; split; first by rewrite /ntt_accepted iota0.
move=> pos ge0p hp3 hz; apply/negP => lt256.
have := ntt_accepted_mono _rho (rejNTT_fuel _rho) (pos %/ 3) _; 2: smt().
by split; [rewrite /rejNTT_fuel; apply ge0_argmin | smt()].
qed.

(* the termination criterion holds for every seed: SHAKE128's stream
   keeps producing accepted candidates (Keccak-f[1600] is a permutation,
   so the sponge state is periodic and the stream returns to runs of zero
   bytes, and zero is accepted -- Lean: TermSamplers, Total.nonceCrit_all) *)
lemma rejNTT_terminates (rho : Bytes34.t) : rejNTT_ok rho.
proof.
have h168 : size (Bytes34.to_list rho) < 168 by rewrite Bytes34.size_to_list.
have [L [gt0L hL]] := SHAKE128_zero_run _ h168.
(* one aligned all-zero 3-byte group per period, accepted as 0 *)
have := count_grows (fun t => size (ntt_accepted rho t)) (56 * L)
          (fun N => ((N + 1) * L - 1) * 56 + 12) _ _ _ _ 256 _.
- smt().
- by move=> a b rgab /=; apply ntt_accepted_mono.
- move=> N ge0N /=.
  have hNL : N * L <= (N + 1) * L - 1 by smt().
  split; 1: smt().
  split; 1: smt().
  pose g := ((N + 1) * L - 1) * 56 + 12.
  have hz : forall j, 0 <= j < 3 =>
    nth witness (SHAKE128 (Bytes34.to_list rho) (3 * g + 3)) (3 * g + j) = W8.zero.
  + move=> j rgj; rewrite (_ : 3 * g + j = ((N + 1) * L - 1) * 168 + (36 + j)) 1:/g 1:#ring.
    by rewrite hL 1,2:/# /g /#.
  rewrite (_ : g + 1 = g + 1) // ntt_acceptedS 1:/# size_cat /ntt_cand /=.
  by rewrite (hz 0) // (hz 1) // (hz 2) // /CoeffFromThreeBytes /= W8.to_uint0 /=.
- by rewrite /= size_ge0.
- done.
by move=> /= h; exists (56 * L * 256); split => //; smt().
qed.

phoare RejNTTPoly_correct _rho :
   [ RejNTTPoly(MLDSA_XOFA).sample : arg = _rho ==> res = rejNTTPoly _rho] = 1%r.
proof. by conseq (RejNTTPoly_ll _rho (rejNTT_terminates _rho)) (RejNTTPoly_h _rho). qed.
   
(*************** End RejNTTPoly CORRECTNESS BRIDGE ****************)


module RejBoundedPoly(XOF : XOF_RejBPoly) = {
  proc sample(rho : Bytes66.t) : poly = {
    var j,z,z0,z1;
    var a : poly;
    a <- witness;
    XOF.init(rho);
    j <- 0;
    while (j < 256) {
      z <@ XOF.next();
      z0 <- CoeffFromHalfByte (to_uint z %% 16);
      z1 <- CoeffFromHalfByte (to_uint z %/ 16);
      if (z0 <> None) { a.[j] <- incoeff (oget z0); j <- j + 1; }
      if ((z1 <> None) && (j < 256)) { a.[j] <- incoeff (oget z1); j <- j + 1; }
    }
    return a;
  }
}.

(*************** Begin RejBoundedPoly CORRECTNESS BRIDGE ****************)

(* Concrete definition is in Symmetric.ec: MLDSA_XOFS *)


(* FIPS 204 Alg. 31 as a function of the XOF stream: byte t of
   SHAKE256(rho) yields the two half-byte candidates, low nibble first *)
op bounded_cands (rho : Bytes66.t) (t : int) : int option list =
  let z = nth witness (SHAKE256 (Bytes66.to_list rho) (t + 1)) t in
  [CoeffFromHalfByte (to_uint z %% 16); CoeffFromHalfByte (to_uint z %/ 16)].

op bounded_accepted (rho : Bytes66.t) (t : int) : int list =
  pmap idfun (flatten (map (bounded_cands rho) (iota_ 0 t))).

op rejBounded_ok (rho : Bytes66.t) : bool =
  exists t, 0 <= t /\ 256 <= size (bounded_accepted rho t).

op rejBounded_fuel (rho : Bytes66.t) : int =
  argmin idfun (fun t => 256 <= size (bounded_accepted rho t)).

op rejBoundedPoly (rho : Bytes66.t) : poly =
  Array256.init (fun i => incoeff (nth 0 (bounded_accepted rho (rejBounded_fuel rho)) i)).

lemma bounded_acceptedS (rho : Bytes66.t) (t : int) : 0 <= t =>
  bounded_accepted rho (t + 1)
  = bounded_accepted rho t ++ pmap idfun (bounded_cands rho t).
proof.
by move=> ge0t; rewrite /bounded_accepted iotaSr // map_rcons flatten_rcons pmap_cat.
qed.

lemma bounded_accepted_mono (rho : Bytes66.t) (t1 t2 : int) : 0 <= t1 <= t2 =>
  size (bounded_accepted rho t1) <= size (bounded_accepted rho t2).
proof.
move=> [ge0 le].
have h : forall k, 0 <= k => size (bounded_accepted rho t1) <= size (bounded_accepted rho (t1 + k)).
- elim/natind => [k le0k ge0k|k ge0k ih _]; 1: by rewrite (_ : k = 0) 1:/#.
  rewrite (_ : t1 + (k + 1) = (t1 + k) + 1) 1:/# bounded_acceptedS 1:/# size_cat.
  by have := ih ge0k; smt(size_ge0).
by have := h (t2 - t1) _; [smt() | rewrite (_ : t1 + (t2 - t1) = t2) 1:/#].
qed.

(* partial correctness: after t bytes the XOF is at position t,
   j = min 256 (accepted so far) and a holds them; the loop stops at the
   least t with 256 accepted, i.e. at rejBounded_fuel *)
lemma RejBoundedPoly_h (_rho : Bytes66.t) :
  hoare [ RejBoundedPoly(MLDSA_XOFS).sample : rho = _rho ==> res = rejBoundedPoly _rho ].
proof.
proc; inline MLDSA_XOFS.init.
while (XOFS_state.seed = Bytes66.to_list _rho /\ 0 <= XOFS_state.pos
  /\ j = min 256 (size (bounded_accepted _rho XOFS_state.pos))
  /\ (forall i, 0 <= i < j => a.[i] = incoeff (nth 0 (bounded_accepted _rho XOFS_state.pos) i))
  /\ (forall t, 0 <= t < XOFS_state.pos => size (bounded_accepted _rho t) < 256)).
- inline MLDSA_XOFS.next; wp; skip => &hr [#] -> ge0p -> hc hmin ltj /=.
  have hlt : size (bounded_accepted _rho XOFS_state.pos{hr}) < 256 by smt().
  rewrite bounded_acceptedS //.
  have hminS : forall t0, 0 <= t0 < XOFS_state.pos{hr} + 1 =>
    size (bounded_accepted _rho t0) < 256.
  + by move=> t0 rgt0; case: (t0 = XOFS_state.pos{hr}) => [->> //|ne]; apply hmin; smt().
  rewrite /bounded_cands /=.
  pose L := bounded_accepted _rho XOFS_state.pos{hr}.
  have -> : min 256 (size L) = size L by smt().
  move: (CoeffFromHalfByte (to_uint (nth witness<:W8.t> (SHAKE256 (Bytes66.to_list _rho) (XOFS_state.pos{hr} + 1)) XOFS_state.pos{hr}) %% 16))
        (CoeffFromHalfByte (to_uint (nth witness<:W8.t> (SHAKE256 (Bytes66.to_list _rho) (XOFS_state.pos{hr} + 1)) XOFS_state.pos{hr}) %/ 16)) => o0 o1.
  move: hc; rewrite -/L => hc.
  have hc' : forall i, 0 <= i < size L => a{hr}.[i] = incoeff (nth 0 L i) by move=> i ?; apply hc; smt().
  case: o0 => [|v0] /=.
  + case: o1 => [|v1] /=.
    * rewrite cats0; do! split; 1,2: smt(); [by move=> i ?; rewrite hc' | exact hminS].
    rewrite hlt /= size_cat /=; do! split; 1,2: smt(); 2: exact hminS.
    move=> i rgi; rewrite Array256.get_setE 1:/# nth_cat.
    by case: (i = size L) => [->> //|ne]; rewrite ifT 1:/# hc' /#.
  case: o1 => [|v1] /=.
  + rewrite size_cat /=; do! split; 1,2: smt(); 2: exact hminS.
    move=> i rgi; rewrite Array256.get_setE 1:/# nth_cat.
    by case: (i = size L) => [->> //|ne]; rewrite ifT 1:/# hc' /#.
  case: (size L + 1 < 256) => hl /=.
  + rewrite size_cat /=; do! split; 1,2: smt(); 2: exact hminS.
    move=> i rgi; rewrite Array256.get_setE 1:/# nth_cat.
    case: (i = size L + 1) => [->> /=|ne1].
    * by rewrite ifF 1:/# (_ : size L + 1 - size L = 1) 1:/#.
    rewrite Array256.get_setE 1:/#.
    by case: (i = size L) => [->> //|ne]; rewrite ifT 1:/# hc' /#.
  rewrite size_cat /=; do! split; 1,2: smt(); 2: exact hminS.
  move=> i rgi; rewrite Array256.get_setE 1:/# nth_cat.
  by case: (i = size L) => [->> //|ne]; rewrite ifT 1:/# hc' /#.
auto => />; split; first by rewrite /bounded_accepted iota0 //=; smt().
move=> pos a0 ge256 ge0p hc hmin.
have hf : rejBounded_fuel _rho = pos.
- by rewrite /rejBounded_fuel (argmin_eq idfun _ pos) //= /#.
by apply Array256.tP => i rgi; rewrite hc 1:/# /rejBoundedPoly Array256.initiE //= hf.
qed.

(* termination, under the criterion: the variant is rejBounded_fuel - t *)
lemma RejBoundedPoly_ll (_rho : Bytes66.t) : rejBounded_ok _rho =>
  phoare [ RejBoundedPoly(MLDSA_XOFS).sample : rho = _rho ==> true ] = 1%r.
proof.
move=> hok; have [t0 [ge0t0 h256]] := hok.
have hfuel : 256 <= size (bounded_accepted _rho (rejBounded_fuel _rho)).
- by apply (argminP idfun (fun t => 256 <= size (bounded_accepted _rho t)) t0).
proc; inline MLDSA_XOFS.init.
while (XOFS_state.seed = Bytes66.to_list _rho /\ 0 <= XOFS_state.pos
  /\ j = min 256 (size (bounded_accepted _rho XOFS_state.pos)))
  (rejBounded_fuel _rho - XOFS_state.pos).
- move=> z; inline MLDSA_XOFS.next; wp; skip => &hr [#] -> ge0p -> ltj hz /=.
  rewrite bounded_acceptedS // /bounded_cands /=.
  pose L := bounded_accepted _rho XOFS_state.pos{hr}.
  move: (CoeffFromHalfByte (to_uint (nth witness<:W8.t> (SHAKE256 (Bytes66.to_list _rho) (XOFS_state.pos{hr} + 1)) XOFS_state.pos{hr}) %% 16))
        (CoeffFromHalfByte (to_uint (nth witness<:W8.t> (SHAKE256 (Bytes66.to_list _rho) (XOFS_state.pos{hr} + 1)) XOFS_state.pos{hr}) %/ 16)) => o0 o1.
  case: o0 => [|v0] /=.
  + by case: o1 => [|v1] /=; rewrite ?cats0 ?size_cat /= /#.
  by case: o1 => [|v1] /=; rewrite ?cats0 ?size_cat /= /#.
auto => />; split; first by rewrite /bounded_accepted iota0.
move=> pos ge0p hz; apply/negP => lt256.
have := bounded_accepted_mono _rho (rejBounded_fuel _rho) pos _; 2: smt().
by split; [rewrite /rejBounded_fuel; apply ge0_argmin | smt()].
qed.

(* the termination criterion holds for every seed (Keccak permutation
   argument, as for Alg. 30; zero bytes give accepted candidates) *)
lemma rejBounded_terminates (rho : Bytes66.t) : rejBounded_ok rho.
proof.
have h136 : size (Bytes66.to_list rho) < 136 by rewrite Bytes66.size_to_list.
have [L [gt0L hL]] := SHAKE256_zero_run _ h136.
(* one zero byte per period: both of its nibbles are accepted *)
have := count_grows (fun t => size (bounded_accepted rho t)) (136 * L)
          (fun N => ((N + 1) * L - 1) * 136 + 67) _ _ _ _ 256 _.
- smt().
- by move=> a b rgab /=; apply bounded_accepted_mono.
- move=> N ge0N /=.
  have hNL : N * L <= (N + 1) * L - 1 by smt().
  split; 1: smt().
  split; 1: smt().
  rewrite (_ : ((N + 1) * L - 1) * 136 + 68 = (((N + 1) * L - 1) * 136 + 67) + 1) 1:#ring.
  rewrite bounded_acceptedS 1:/# size_cat /bounded_cands /= hL 1,2:/# 1:/#.
  have hc0 : CoeffFromHalfByte 0 <> None by rewrite /CoeffFromHalfByte; have := param_sets; smt().
  rewrite W8.to_uint0 /=; case: (CoeffFromHalfByte 0) hc0 => // v _ /=; smt(size_ge0).
- by rewrite /= size_ge0.
- done.
by move=> /= h; exists (136 * L * 256); split => //; smt().
qed.

phoare RejBoundedPoly_correct _rho :
   [ RejBoundedPoly(MLDSA_XOFS).sample : arg = _rho ==> res = rejBoundedPoly _rho] = 1%r.
proof. by conseq (RejBoundedPoly_ll _rho (rejBounded_terminates _rho)) (RejBoundedPoly_h _rho). qed.
   
(*************** End RejBoundedPoly CORRECTNESS BRIDGE ****************)

module ExpandA(XOF : XOF_RejNTTPoly) = {
   proc sample(rho : Bytes32.t) : polymat = {
      var r,s,rhop,ars;
      var aa : polymat;
      aa <- witness;
      r <- 0;
      while (r < kvec) {
          s <- 0;
          while (s < lvec) {
            rhop <- Bytes34.of_list (Bytes32.to_list rho ++ [W8.of_int s; W8.of_int r]);
            ars <@ RejNTTPoly(XOF).sample(rhop);
            aa <- aa.[(r,s) <- ars];
            s <- s + 1;
          }
          r <- r + 1;
      }
      return aa;
   }
}.

(*************** Begin ExpandA CORRECTNESS BRIDGE ****************)

(* FIPS 204 Alg. 32: entry (r, s) is RejNTTPoly(rho || s || r) *)
op expandA (rho : Bytes32.t) : polymat =
  KLMatrix.init (fun i => rejNTTPoly
    (Bytes34.of_list (Bytes32.to_list rho ++ [W8.of_int (i %% lvec); W8.of_int (i %/ lvec)]))).

phoare ExpandA_correct _rho :
   [ ExpandA(MLDSA_XOFA).sample : arg = _rho ==> res = expandA _rho] = 1%r.
proof.
have gt0l : 0 < lvec by smt(gt0_l).
have gt0k : 0 < kvec by smt(gt0_k).
proc.
while (rho = _rho /\ 0 <= r <= kvec
  /\ forall i, 0 <= i < r * lvec => aa.[i] = (expandA _rho).[i]) (kvec - r).
- move=> z; wp.
  while (rho = _rho /\ 0 <= r < kvec /\ 0 <= s <= lvec /\ kvec - r = z
    /\ forall i, 0 <= i < r * lvec + s => aa.[i] = (expandA _rho).[i]) (lvec - s).
  + move=> z'; wp.
    ecall (RejNTTPoly_correct rhop); auto => &hr |> ge0r ltr ge0s _ hi lts.
    have hb : r{hr} * lvec + s{hr} < kvec * lvec.
    * have : (r{hr} + 1) * lvec <= kvec * lvec by apply StdOrder.IntOrder.ler_wpmul2r; smt().
      smt().
    do! split; 1..2, 4: smt().
    move=> i ge0i lti; rewrite /PolyMat."_.[_<-_]" KLMatrix.get_setE; 1: smt(StdOrder.IntOrder.mulr_ge0).
    case: (i = r{hr} * lvec + s{hr}) => [->> |ne]; last by rewrite hi /#.
    rewrite /expandA KLMatrix.initiE 1:/# /=.
    by rewrite modzMDl pmod_small 1:/# divzMDl 1:/# pdiv_small 1:/#.
  auto => &hr |> ge0r _ hi ltr; split; 1: smt().
  move=> aa0 s0; split; 1: smt().
  move=> ns ge0 les hi'; split; 2: smt().
  split; 1: smt().
  by move=> i ge0i lti; apply hi'; smt().
auto => |>; split; 1: smt().
move=> aa0 r0; split; 1: smt().
move=> nr ge0 ler hi; apply KLMatrix.tP => i rgi.
by rewrite hi; smt().
qed.
   
(*************** End ExpandA CORRECTNESS BRIDGE ****************)

module ExpandS(XOF : XOF_RejBPoly) = {
   proc sample(rho : Bytes64.t) : polylvec * polykvec = {
      var si,r,rhop;
      var s1 : polylvec;
      var s2 : polykvec;
      s1 <- witness;
      s2 <- witness;
      r <- 0;
      while (r < lvec) {
         rhop <- Bytes66.of_list (Bytes64.to_list rho ++ (IntegerToBytes r 2));        
         si <@ RejBoundedPoly(XOF).sample(rhop);
         s1 <- s1.[r <- si];
            r <- r + 1;
      }
      r <- 0;
      while (r < kvec) {
         rhop <- Bytes66.of_list (Bytes64.to_list rho ++ (IntegerToBytes (r+lvec) 2));        
         si <@ RejBoundedPoly(XOF).sample(rhop);
         s2 <- s2.[r <- si];
         r <- r + 1;
      }
      return (s1,s2);
   }
}.

(*************** Begin ExpandS CORRECTNESS BRIDGE ****************)

(* FIPS 204 Alg. 33: s1[r] uses nonce r, s2[r] uses nonce lvec + r *)
op expandS (rho : Bytes64.t) : polylvec * polykvec =
  (LArray.init (fun r => rejBoundedPoly (Bytes66.of_list (Bytes64.to_list rho ++ IntegerToBytes r 2))),
   KArray.init (fun r => rejBoundedPoly (Bytes66.of_list (Bytes64.to_list rho ++ IntegerToBytes (r + lvec) 2)))).

phoare ExpandS_correct _rho :
   [ ExpandS(MLDSA_XOFS).sample : arg = _rho ==> res = expandS _rho] = 1%r.
proof.
proc.
while (rho = _rho /\ 0 <= r <= kvec /\ s1 = (expandS _rho).`1
  /\ forall i, 0 <= i < r => s2.[i] = (expandS _rho).`2.[i]) (kvec - r).
- move=> z; wp; ecall (RejBoundedPoly_correct rhop); auto => &hr |> ge0r _ hi ltr.
  do! split; 1,2,4: smt().
  move=> i ge0i lti; rewrite KArray.get_setE 1:/#.
  case: (i = r{hr}) => [->> /=|ne]; last by rewrite hi /#.
  by rewrite /expandS /= KArray.initiE 1:/#.
wp; while (rho = _rho /\ 0 <= r <= lvec
  /\ forall i, 0 <= i < r => s1.[i] = (expandS _rho).`1.[i]) (lvec - r).
- move=> z; wp; ecall (RejBoundedPoly_correct rhop); auto => &hr |> ge0r _ hi ltr.
  do! split; 1,2,4: smt().
  move=> i ge0i lti; rewrite LArray.get_setE 1:/#.
  case: (i = r{hr}) => [->> /=|ne]; last by rewrite hi /#.
  by rewrite /expandS /= LArray.initiE 1:/#.
auto => |>; split; 1: smt(gt0_l).
move=> r1 s1; split; 1: smt().
move=> nr ge0 ler hi; split.
- split; 1: smt(gt0_k).
  split; 2: smt().
  by apply LArray.tP => i rgi; rewrite hi /#.
move=> r2 s2; split; 1: smt().
move=> nr2 ge02 ler2 hs1 hi2.
have -> : s2 = (expandS _rho).`2 by apply KArray.tP => i rgi; rewrite hi2 /#.
by case: (expandS _rho).
qed.
   
(*************** End ExpandS CORRECTNESS BRIDGE ****************)


module ExpandMask = {
   proc sample(rho : Bytes64.t, mu : int) : polylvec = {
     var r, rhop, v,si;
     var s : polylvec;
     s <- witness;
     r <- 0;
     while (r < lvec) {
        rhop <- Bytes66.of_list (Bytes64.to_list rho ++ (IntegerToBytes (mu+r) 2));        
        v <- H_v rhop;
        si <- BitUnpack (BytesV.to_list v) (gamma1-1) (gamma1);
        s <- s.[r <- si];
        r <- r + 1;
     }
     return s;
   }
}.

(*************** Begin ExpandMask CORRECTNESS BRIDGE ****************)

(* FIPS 204 Alg. 34, functionally: no rejection, entry r is the
   BitUnpack of H(rho || IntegerToBytes(mu + r, 2)) *)
op expandMask (rho : Bytes64.t) (mu : int) : polylvec =
  LArray.init (fun r => BitUnpack
    (BytesV.to_list (H_v (Bytes66.of_list (Bytes64.to_list rho ++ IntegerToBytes (mu + r) 2))))
    (gamma1 - 1) gamma1).

phoare ExpandMask_correct _rho _mu :
   [ ExpandMask.sample : arg = (_rho,_mu) ==> res = expandMask _rho _mu] = 1%r.
proof.
proc; while (rho = _rho /\ mu = _mu /\ 0 <= r <= lvec
  /\ forall i, 0 <= i < r => s.[i] = (expandMask _rho _mu).[i]) (lvec - r).
- move=> z; auto=> |> &hr ge0r _ hs ltr; do! split; 1,2,4: smt().
  move=> i ge0i lti; rewrite LArray.get_setE 1:/#.
  case: (i = r{hr}) => [->> /=|ne]; last by rewrite hs /#.
  by rewrite /expandMask LArray.initiE /#.
auto=> |>; split; 1: smt(gt0_l).
move=> r s; split; 1: smt().
move=> ltr ger ler hs; apply LArray.tP => i rgi.
by rewrite hs /#.
qed.
   
(*************** End ExpandMask CORRECTNESS BRIDGE ****************)

end SamplingT.
