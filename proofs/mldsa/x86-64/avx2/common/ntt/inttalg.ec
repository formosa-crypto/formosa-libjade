(**
  Algebraic content of the machine-level inverse NTT.

  The code-level proof (`Inttcorrect`) shows that the AVX2 procedure
  computes `iscale (invtree p 8)`: the eight Gentleman-Sande levels of
  the generic tree (`ireduce_level`, instantiated in `Nttspec`), then a
  final scaling.

  Each level contributes a factor 2, so after the 8 levels block j of
  `invtree v 8` is 256 times the input of the forward transform
  (`invtree_cgr`, by `icgr_step`).  The final `iscale` multiplies by
  41978 = 2^64/256 mod q through `mmr` (which divides by 2^32), leaving
  2^32 * p: the procedure returns the inverse transform in Montgomery
  form.

  Bounds: the additive half doubles the coefficient magnitude at each
  level (the mmr half resets to < q), so the assumption is cbnd v B
  with q <= B and 256 * B < 2^31.  For the natural bound B = q this
  fits with a 0.1% margin: 256 * q = 2145386752 < 2^31 = 2147483648.
  In particular the input must be reduced: the raw forward-NTT output
  bound (B + 8q) would overflow.
*)

(* ==================================================================== *)
require import AllCore CoreUtils List Ring IntDiv BitEncoding.
require import StdRing StdOrder StdBigop.
(*---*) import Bigint BIA IntOrder.

(* -------------------------------------------------------------------- *)
from Jasmin require import JUtils JWord.

(* -------------------------------------------------------------------- *)
require import Array256.

(* -------------------------------------------------------------------- *)
require import Nttlogspec Nttspec Nttzetas.

(* ==================================================================== *)
(* The inverse tree, relative to the forward one                        *)
(* ==================================================================== *)
(* If v is congruent to the forward NTT of p, then after k inverse
   levels block j of size 2^k holds 2^k * (the level-k residue of p). *)
lemma invtree_cgr (p v : wpoly) (B k : int) :
  0 <= k <= 8 => q <= B => 2^8 * B < 2^31 => cbnd v B =>
  (forall i, 0 <= i < 256 => sval v.[i] %% q = nttsum p 0 i 0 %% q) =>
  cbnd (invtree v k) (2^k * B) /\ icgr p (invtree v k) k.
proof.
move=> + leqB hB hbnd hv; elim/natind: k => [k le0k rgk | k ge0k ih rgk].
- have ->> /= : k = 0 by smt().
  rewrite invtree0; split; first by move: hbnd => /#.
  by apply icgr_leaves => j t /= rgj rgt; rewrite (: t = 0) 1:/# /= hv /#.
have [ihb ihc] := ih _; first smt().
have rgk8 : 0 <= k < 8 by smt().
have le8 : 2^(k+1) * B <= 2^8 * B.
- apply ler_wpmul2r; first smt(gt0_q).
  by apply ler_weexpn2l => /#.
have hw : forall j t, 0 <= j < 2^(7-k) => 0 <= t < 2^k =>
  (fun _ => 2^k * B) (j * 2^(k+1) + t) + (fun _ => 2^k * B) (j * 2^(k+1) + 2^k + t) < 2^31.
- by move=> j t _ _ /=; move: le8 hB; rewrite exprS //=; smt().
rewrite invtree_step //; split.
- move=> i rgi; have := ireduce_level_bnd (invtree v k) k (fun _ => 2^k * B) rgk8 ihb hw i rgi.
  have : B <= 2^k * B by apply ler_pemull; [smt(gt0_q) | apply exprn_ege1].
  by rewrite /ibnd exprS //=; smt().
by apply icgr_step => //; apply (novf_bnd _ _ (fun _ => 2^k * B)).
qed.

(* ==================================================================== *)
(* Final scaling: mmr by 41978 = 2^64/256 mod q                         *)
(* ==================================================================== *)
lemma iscaleiE (p : wpoly) (i : int) : 0 <= i < 256 =>
  (iscale p).[i] = mmr p.[i] (W32.of_int 41978).
proof.
by move=> rgi; rewrite /iscale mapiE.
qed.

lemma sval41978 : sval (W32.of_int 41978) = 41978.
proof.
rewrite W32.to_sintK_small.
- by rewrite /=.
by done.
qed.

(* 256 * 41978 = 2^64 mod q: the tree factor 256 cancels and one
   Montgomery factor remains *)
lemma iscale_cgr (c : W32.t) (x : int) :
  (sval c) %% q = (256 * x) %% q =>
  sval (mmr c (W32.of_int 41978)) %% q = (2^32 * x) %% q.
proof.
move=> hc.
apply cgr_pow2_cancel.
rewrite mmr_mont sval41978.
rewrite -modzMml hc modzMml.
have -> : 256 * x * 41978 = x * 10746368 by ring.
have -> : 2^32 * (2^32 * x) = x * (2^32 * 2^32) by ring.
have e64 : 10746368 %% q = (2^32 * 2^32) %% q by rewrite /q /=.
by rewrite -(modzMmr x 10746368 q) e64 modzMmr.
qed.

lemma iscale_bnd (c : W32.t) : `|sval (mmr c (W32.of_int 41978))| < q.
proof.
apply mmr_small.
rewrite sval41978.
by rewrite /q.
qed.

(* ==================================================================== *)
(* Endpoint: the roundtrip, output in Montgomery form                   *)
(* ==================================================================== *)
lemma intt_ntt_alg (p v : wpoly) (B : int) :
  q <= B => 2^8 * B < 2^31 => cbnd v B =>
  (forall i, 0 <= i < 256 => sval v.[i] %% q = nttsum p 0 i 0 %% q) =>
     cbnd (iscale (invtree v 8)) q
  /\ forall i, 0 <= i < 256 =>
       sval (iscale (invtree v 8)).[i] %% q = (2^32 * sval p.[i]) %% q.
proof.
move=> leqB hB hbnd hv; have [_ hc] := invtree_cgr p v B 8 _ leqB hB hbnd hv => //.
split=> i rgi; rewrite iscaleiE //; first by smt(iscale_bnd).
by apply/iscale_cgr; have /= := icgr_top p _ i hc rgi.
qed.
