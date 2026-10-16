(**
  The ML-KEM instance of the generic NTT tree: q = 3329, zeta = 17
  (a primitive 256-th root of unity), leaves of size 2 (level 1),
  16-bit words, and the Montgomery multiplication of the AVX2 code
  against a precomputed pair (z * qinv, z) with R = 2^16.
*)

(* ==================================================================== *)
require import AllCore List IntDiv BitEncoding StdOrder StdBigop.
(*---*) import BitReverse BS2Int Bigint IntOrder.

from Jasmin require import JWord.
from JazzEC require import Array256.

require import NttTree Montgomery16.
from Spec require import GFq Rq.
(*---*) import Zq BigDom.

(* ==================================================================== *)
(* Twiddles                                                             *)
(* ==================================================================== *)
(* the Montgomery representative of x, in [0, q) *)
op mrepr (x : int) : int = (x * 2^16) %% 3329.

(* the table entry of a factor x: the pair (z * qinv, z), z = mrepr x   *)
op tw16 (x : int) : W16.t * W16.t =
  (W16.of_int (mrepr x * 62209), W16.of_int (mrepr x)).

(* the product as the code computes it, from the pair                   *)
op mmr16 (u : W16.t) (z : W16.t * W16.t) : W16.t =
  wmulhs z.`2 u - wmulhs (z.`1 * u) (W16.of_int 3329).

(* -------------------------------------------------------------------- *)
lemma mmr16_redc (u : W16.t) (x : int) :
  mmr16 u (tw16 x) = Montgomery16.REDCmul16 u (W16.of_int (mrepr x)).
proof.
rewrite /mmr16 /tw16 /Montgomery16.REDC16 /=.
have -> : wmulhs (W16.of_int (mrepr x)) u = wmulhs u (W16.of_int (mrepr x)).
- by apply/to_sint_eq; rewrite !to_sint_wmulhs mulzC.
rewrite -W16.of_intM /Montgomery16.qinv /Montgomery16.q.
by rewrite W16.WRingA.mulrC W16.WRingA.mulrA.
qed.

lemma mmr16_correct (u : W16.t) (x : int) :
     W16.to_sint (mmr16 u (tw16 x)) %% 3329 = (W16.to_sint u * x) %% 3329
  /\ `|W16.to_sint (mmr16 u (tw16 x))| < 3329.
proof.
have rgm : 0 <= mrepr x < 3329 by rewrite /mrepr; smt(modz_ge0 ltz_pmod).
have hz : W16.to_sint (W16.of_int (mrepr x)) = mrepr x.
- by rewrite W16.to_sintK_small //=; smt().
have [hc hb] := Montgomery16.REDCmul16_correct u (W16.of_int (mrepr x)) _.
- by rewrite /sint_bnd hz /Montgomery16.q /#.
rewrite mmr16_redc; split; last by move: hb; rewrite /sint_bnd /Montgomery16.q /#.
rewrite hc hz /Montgomery16.q /Montgomery16.Rinv /mrepr.
pose c := x * 65536 %/ 3329.
have -> : x * Montgomery16.R %% 3329 = x * 65536 - c * 3329 by rewrite /c modzE.
have -> : W16.to_sint u * (x * 65536 - c * 3329) * 169
        = W16.to_sint u * x * (65536 * 169) + (- W16.to_sint u * c * 169) * 3329 by ring.
by rewrite modzMDr -modzMmr.
qed.

(* ==================================================================== *)
(* The instance                                                         *)
(* ==================================================================== *)
clone include NttTreeT with
  op q      <- 3329,
  op s      <- 1,
  op zeta_  <- 17,
  type w    <- W16.t,
  op sval   <- W16.to_sint,
  op wmax   <- 2^15,
  op ( + )  <- W16.( + ),
  op ( - )  <- fun (a b : W16.t) => a - b,
  type tw   <- W16.t * W16.t,
  op tw_of  <- tw16,
  op mmr    <- mmr16,
  op isub   <- fun (a b : W16.t) => a - b,
  op isgn   <- -1
proof *.

realize gt1_q by done.
realize odd_q by done.
realize rg_s by done.
realize zeta_half by done.

realize svalD.
proof. by move=> a b /= h; apply W16.to_sintD_small => /#. qed.

realize svalB.
proof. by move=> a b /= h; apply W16.to_sintB_small => /#. qed.

realize mmr_cgr by move=> u x; have [] := mmr16_correct u x.
realize mmr_bnd by move=> u x; have [] := mmr16_correct u x.

realize isgnP by done.

realize svalI.
proof. by move=> a b /= h; rewrite W16.to_sintB_small /#. qed.

(* ==================================================================== *)
(* The link with the specification                                      *)
(* ==================================================================== *)
(* the field elements read from 16-bit words *)
op liftw (p : wpoly) : poly = Array256.map (fun x => incoeff (W16.to_sint x)) p.

lemma liftwE (p : wpoly) (i : int) :
  0 <= i < 256 => (liftw p).[i] = incoeff (W16.to_sint p.[i]).
proof. by move=> rgi; rewrite /liftw mapiE. qed.

lemma incoeff_sum (f : int -> int) (a b : int) :
  incoeff (BIA.bigi predT f a b) = BAdd.bigi predT (fun i => incoeff (f i)) a b.
proof.
elim: (range a b) => [|x xs ih]; first by rewrite BIA.big_nil BAdd.big_nil.
by rewrite BIA.big_consT BAdd.big_consT incoeffD ih.
qed.

lemma incoeff_zpw (e : int) : 0 <= e => incoeff (zpw e) = ZqRing.exp zroot e.
proof.
move=> ge0e; rewrite /zroot exp_incoeff // ifT //.
apply/eq_incoeff; rewrite /zpw /=.
by have := zexp_modE e ge0e => /= @/coeffcgr; rewrite qE.
qed.

(* the implementation evaluates at exactly the specification's points *)
lemma bitrev_br (j : int) : bitrev j = br j.
proof. by rewrite /bitrev /br /bsrev. qed.

lemma ntt_link (p : wpoly) (B : int) :
  0 <= B => B + 7 * 3329 < 2^15 => cbnd p B =>
     cbnd (reduce_tree p 1) (B + 7 * 3329)
  /\ liftw (reduce_tree p 1) = ntt (liftw p).
proof.
move=> ge0B hB hbnd; have [hb hs] := ntt_alg p B ge0B _ hbnd => //.
split => //; apply/Array256.ext_eq => i rgi.
have [ii t [-> [rgii rgt]]] : exists ii t, i = ii * 2 + t /\ 0 <= ii < 128 /\ 0 <= t < 2.
- by exists (i %/ 2) (i %% 2); smt().
rewrite liftwE 1:/# nttE initiE 1:/# /=.
have /= h := hs ii t _ _ => //.
rewrite (_ : incoeff (W16.to_sint _) = incoeff (nttsum p 1 ii t)).
- by apply/eq_incoeff; rewrite /coeffcgr qE.
rewrite /nttsum E_leaf // bitrev_br incoeff_sum.
have -> : (ii * 2 + t) %/ 2 = ii by smt().
have -> : (ii * 2 + t) %% 2 = t by smt().
have hbr : 0 <= br ii.
- by rewrite /br /bsrev bs2int_ge0.
case: (t = 0) => [->> | ne0t] /=; apply: BAdd.eq_big_int => j rgj /=;
  rewrite incoeffM incoeff_zpw 1:mulr_ge0 1,2:/# ZqRing.mulrC;
  rewrite liftwE 1:/#; do 3! congr; smt().
qed.

(* the leaves of the inverse tree: the forward transform of p          *)
lemma intt_leaves (p v : wpoly) (B : int) :
  0 <= B => B + 7 * 3329 < 2^15 => cbnd p B => liftw v = ntt (liftw p) => icgr p v 1.
proof.
move=> ge0B hB hbnd hv; have [_ hl] := ntt_link p B ge0B hB hbnd.
have [_ hs] := ntt_alg p B ge0B _ hbnd => //.
apply icgr_leaves => j t rgj rgt; rewrite -hs //.
have [e7 e1] : 2^(8-1) = 128 /\ 2^1 = 2 by done.
have : (liftw v).[j * 2^1 + t] = (liftw (reduce_tree p 1)).[j * 2^1 + t] by rewrite hl hv.
by rewrite !liftwE 1,2:/# => /eq_incoeff; rewrite /coeffcgr qE.
qed.
