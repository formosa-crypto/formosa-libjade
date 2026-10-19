(**
  Correctness of the AVX2 inverse NTT (`polynomial__invert_ntt_montgomery`).

  Mirror of `fnttcorrect.ec`: the Gentleman-Sande butterflies on
  registers, then the two calls that keep the coefficients in
  registers (levels 0 to 4 on a block of 64 coefficients, levels 5 to 7
  and the final scaling on a column of registers), composed by the
  locality of the levels (`Nttvec`).
*)
require import AllCore CoreUtils List Ring IntDiv BitEncoding.
require import StdRing StdOrder.
from Jasmin require import JWord JArray JModel_x86.
require import MldsaConstants.
require Parameters MldsaT.
require import WArray1024.
require import Array2 Array4 Array8 Array16 Array256.
require import XArray256.
require import Nttzetas Nttspec Nttlogspec Nttvec.
require import Avx2red Listred.

abstract theory InttcorrectT.

clone import Parameters.ParamsT as P.
clone import MldsaT.MldsaT as R with theory P <- P.
clone import Avx2red.Avx2redT as AR with theory P <- P, theory R <- R.

(* -------------------------------------------------------------------- *)
type wpoly = W32.t Array256.t.

(* ==================================================================== *)
(* Butterflies                                                          *)
(* ==================================================================== *)
(* levels 3 to 7: one register against another *)
lemma gs_butterflyP (p : wpoly) (k j r o o2 : int) :
     0 <= k < 8 => 0 <= j < 2^(7-k) => 0 <= r => r + 8 <= 2^k
  => o = j * 2^(k+1) + r => o2 = o + 2^k
  => hoare[M.polynomial____gs_butterfly :
          a = vec p o /\ b = vec p o2 /\ zetas = W8u32.pack8 (nseq 8 (izj k j))
       ==> res = (vec (ireduce_level p k) o, vec (ireduce_level p k) o2)].
proof.
hint +listred.
move=> 5? o2E; proc; ecall (mmrP b_minus_a zetas); auto => &hr [#] -> -> -> /= ? ->.
by rewrite o2E (ivec_lo p k j r o) // (ivec_hi p k j r o) // /vec /=.
qed.

(* level 2: the two halves of each register *)
lemma gs_butterfly_8P (p : wpoly) (jb jb2 o o2 : int) :
  0 <= jb => jb2 = jb + 1 => o = jb * 8 => o2 = o + 8 => o2 + 8 <= 256 =>
  hoare[M.polynomial____gs_butterfly_8 :
       lhs = vec p o /\ rhs = vec p o2
    /\ zetas = W8u32.pack8 [
         izj 2 jb; izj 2 jb; izj 2 jb; izj 2 jb; izj 2 jb2; izj 2 jb2; izj 2 jb2; izj 2 jb2]
    ==> res = (vec (ireduce_level p 2) o, vec (ireduce_level p 2) o2)].
proof.
hint +listred.
move=> 5?; proc; wp; ecall (mmrP differences zetas); auto => &hr [#] -> -> -> /= ? ->.
by rewrite (ivec_small p 2 jb o) 1..4:/# (ivec_small p 2 jb2 o2) 1..4:/# /vec /=.
qed.

(* level 1: the 64-bit quarters *)
lemma gs_butterfly_4P (p : wpoly) (jb jb2 o o2 : int) :
  0 <= jb => jb2 = jb + 2 => o = jb * 4 => o2 = o + 8 => o2 + 8 <= 256 =>
  hoare[M.polynomial____gs_butterfly_4 :
       lhs = vec p o /\ rhs = vec p o2
    /\ zetas = W8u32.pack8 [
         izj 1 jb; izj 1 jb; izj 1 jb2; izj 1 jb2;
         izj 1 (jb + 1); izj 1 (jb + 1); izj 1 (jb2 + 1); izj 1 (jb2 + 1)]
    ==> res = (vec (ireduce_level p 1) o, vec (ireduce_level p 1) o2)].
proof.
hint +listred.
move=> 5?; proc; wp; ecall (mmrP differences zetas); auto => &hr [#] -> -> -> /= ? ->.
by rewrite (ivec_small p 1 jb o) 1..4:/# (ivec_small p 1 jb2 o2) 1..4:/# /vec /=.
qed.

(* level 0: adjacent coefficients, paired by VPSHUFD around level 1 *)
lemma gs_butterfly_2P (p : wpoly) (jb jb2 o o2 : int) :
  0 <= jb => jb2 = jb + 4 => o = jb * 2 => o2 = o + 8 => o2 + 8 <= 256 =>
  hoare[M.polynomial____gs_butterfly_2 :
       lhs = vec p o /\ rhs = vec p o2
    /\ zetas = W8u32.pack8 [
         izj 0 jb; izj 0 (jb + 1); izj 0 jb2; izj 0 (jb2 + 1);
         izj 0 (jb + 2); izj 0 (jb + 3); izj 0 (jb2 + 2); izj 0 (jb2 + 3)]
    ==> res = (vec (ireduce_level p 0) o, vec (ireduce_level p 0) o2)].
proof.
hint +listred.
move=> 5?; proc; inline M.polynomial____gs_butterfly_4; wp.
ecall (mmrP differences zetas0); auto => &hr [#] -> -> -> /= ? ->.
by rewrite (ivec_small p 0 jb o) 1..4:/# (ivec_small p 0 jb2 o2) 1..4:/# /vec /=.
qed.

(* the broadcast of a scalar twiddle *)
lemma broadcast_zetaP (z : W32.t) :
  hoare[M.polynomial____broadcast_zeta : zeta_0 = z ==> res = W8u32.pack8 (nseq 8 z)].
proof. by hint +listred; proc; auto. qed.

(* ==================================================================== *)
(* Levels 0 to 4, on the block g of 64 coefficients                     *)
(* ==================================================================== *)
lemma intt_layers_0_to_4P (p : wpoly) (g_ : int) : 0 <= g_ < 4 =>
  hoare[M.polynomial____invert_ntt_layers_0_to_4 :
    arg = (p, g_) ==> res = merge (fun t => t %/ 64 = g_) p (ilevels p 0 5)].
proof.
move=> rgg; proc.
seq 8 : (polynomial = p /\ g = g_ /\ blk p g_ r0 r1 r2 r3 r4 r5 r6 r7).
- auto => />.
  by rewrite (get256_vecE p _ (64 * g_)) 1,2:/# !(get256_blkE p g_).
pose p0 := ireduce_level p 0.
seq 8 : (polynomial = p /\ g = g_ /\ blk p0 g_ r0 r1 r2 r3 r4 r5 r6 r7).
- ecall (gs_butterfly_2P p (32 * g_ + 24) (32 * g_ + 28) (64 * g_ + 48) (64 * g_ + 56)
    _ _ _ _ _); 2..6: smt().
  wp; ecall (gs_butterfly_2P p (32 * g_ + 16) (32 * g_ + 20) (64 * g_ + 32) (64 * g_ + 40)
        _ _ _ _ _); 2..6: smt().
  wp; ecall (gs_butterfly_2P p (32 * g_ + 8) (32 * g_ + 12) (64 * g_ + 16) (64 * g_ + 24)
        _ _ _ _ _); 2..6: smt().
  wp; ecall (gs_butterfly_2P p (32 * g_) (32 * g_ + 4) (64 * g_) (64 * g_ + 8)
        _ _ _ _ _); 2..6: smt().
  auto => />.
  rewrite (izetas0E (4 * g_) (32 * g_) (32 * g_ + 4)) 1..3:/#.
  rewrite (izetas0E (4 * g_ + 1) (32 * g_ + 8) (32 * g_ + 12)) 1..3:/#.
  rewrite (izetas0E (4 * g_ + 2) (32 * g_ + 16) (32 * g_ + 20)) 1..3:/#.
  by rewrite (izetas0E (4 * g_ + 3) (32 * g_ + 24) (32 * g_ + 28)) 1..3:/#.
pose p1 := ireduce_level p0 1.
seq 8 : (polynomial = p /\ g = g_ /\ blk p1 g_ r0 r1 r2 r3 r4 r5 r6 r7).
- ecall (gs_butterfly_4P p0 (16 * g_ + 12) (16 * g_ + 14) (64 * g_ + 48) (64 * g_ + 56)
    _ _ _ _ _); 2..6: smt().
  wp; ecall (gs_butterfly_4P p0 (16 * g_ + 8) (16 * g_ + 10) (64 * g_ + 32) (64 * g_ + 40)
        _ _ _ _ _); 2..6: smt().
  wp; ecall (gs_butterfly_4P p0 (16 * g_ + 4) (16 * g_ + 6) (64 * g_ + 16) (64 * g_ + 24)
        _ _ _ _ _); 2..6: smt().
  wp; ecall (gs_butterfly_4P p0 (16 * g_) (16 * g_ + 2) (64 * g_) (64 * g_ + 8)
        _ _ _ _ _); 2..6: smt().
  auto => />.
  rewrite (izetas1E (4 * g_) (16 * g_) (16 * g_ + 2)) 1..3:/#.
  rewrite (izetas1E (4 * g_ + 1) (16 * g_ + 4) (16 * g_ + 6)) 1..3:/#.
  rewrite (izetas1E (4 * g_ + 2) (16 * g_ + 8) (16 * g_ + 10)) 1..3:/#.
  by rewrite (izetas1E (4 * g_ + 3) (16 * g_ + 12) (16 * g_ + 14)) 1..3:/#.
pose p2 := ireduce_level p1 2.
seq 8 : (polynomial = p /\ g = g_ /\ blk p2 g_ r0 r1 r2 r3 r4 r5 r6 r7).
- ecall (gs_butterfly_8P p1 (8 * g_ + 6) (8 * g_ + 7) (64 * g_ + 48) (64 * g_ + 56)
    _ _ _ _ _); 2..6: smt().
  wp; ecall (gs_butterfly_8P p1 (8 * g_ + 4) (8 * g_ + 5) (64 * g_ + 32) (64 * g_ + 40)
        _ _ _ _ _); 2..6: smt().
  wp; ecall (gs_butterfly_8P p1 (8 * g_ + 2) (8 * g_ + 3) (64 * g_ + 16) (64 * g_ + 24)
        _ _ _ _ _); 2..6: smt().
  wp; ecall (gs_butterfly_8P p1 (8 * g_) (8 * g_ + 1) (64 * g_) (64 * g_ + 8)
        _ _ _ _ _); 2..6: smt().
  auto => />.
  rewrite (izetas2E (4 * g_) (8 * g_) (8 * g_ + 1)) 1..3:/#.
  rewrite (izetas2E (4 * g_ + 1) (8 * g_ + 2) (8 * g_ + 3)) 1..3:/#.
  rewrite (izetas2E (4 * g_ + 2) (8 * g_ + 4) (8 * g_ + 5)) 1..3:/#.
  by rewrite (izetas2E (4 * g_ + 3) (8 * g_ + 6) (8 * g_ + 7)) 1..3:/#.
pose p3 := ireduce_level p2 3.
seq 12 : (polynomial = p /\ g = g_ /\ blk p3 g_ r0 r1 r2 r3 r4 r5 r6 r7).
- ecall (gs_butterflyP p2 3 (4 * g_ + 3) 0 (64 * g_ + 48) (64 * g_ + 56) _ _ _ _ _ _); 2..7: smt().
  ecall (broadcast_zetaP zeta_0); wp.
  ecall (gs_butterflyP p2 3 (4 * g_ + 2) 0 (64 * g_ + 32) (64 * g_ + 40) _ _ _ _ _ _); 2..7: smt().
  ecall (broadcast_zetaP zeta_0); wp.
  ecall (gs_butterflyP p2 3 (4 * g_ + 1) 0 (64 * g_ + 16) (64 * g_ + 24) _ _ _ _ _ _); 2..7: smt().
  ecall (broadcast_zetaP zeta_0); wp.
  ecall (gs_butterflyP p2 3 (4 * g_) 0 (64 * g_) (64 * g_ + 8) _ _ _ _ _ _); 2..7: smt().
  ecall (broadcast_zetaP zeta_0).
  by auto => />; rewrite !izetas3E 1..4:/#.
pose p4 := ireduce_level p3 4.
seq 8 : (polynomial = p /\ g = g_ /\ blk p4 g_ r0 r1 r2 r3 r4 r5 r6 r7).
- ecall (gs_butterflyP p3 4 (2 * g_ + 1) 8 (64 * g_ + 40) (64 * g_ + 56) _ _ _ _ _ _); 2..7: smt().
  ecall (gs_butterflyP p3 4 (2 * g_ + 1) 0 (64 * g_ + 32) (64 * g_ + 48) _ _ _ _ _ _); 2..7: smt().
  ecall (broadcast_zetaP zeta_0); wp.
  ecall (gs_butterflyP p3 4 (2 * g_) 8 (64 * g_ + 8) (64 * g_ + 24) _ _ _ _ _ _); 2..7: smt().
  ecall (gs_butterflyP p3 4 (2 * g_) 0 (64 * g_) (64 * g_ + 16) _ _ _ _ _ _); 2..7: smt().
  ecall (broadcast_zetaP zeta_0).
  by auto => />; rewrite !izetas4E 1..2:/#.
by auto => />; rewrite store_blkE // ilevels0_5E.
qed.

(* ==================================================================== *)
(* Levels 5 to 7 and the scaling, on the column j of registers          *)
(* ==================================================================== *)
lemma intt_layers_5_6_7P (p : wpoly) (j_ : int) : 0 <= j_ < 4 =>
  hoare[M.polynomial____invert_ntt_layers_5_6_7 :
    arg = (p, j_) ==> res = merge (fun t => t %/ 8 %% 4 = j_) p (iscale (ilevels p 5 8))].
proof.
hint +listred.
move=> rgj; proc.
seq 8 : (polynomial = p /\ j = j_ /\ col p j_ r0 r1 r2 r3 r4 r5 r6 r7).
- auto => />.
  by rewrite (get256_vecE p _ (8 * j_)) 1,2:/# !(get256_colE p j_).
pose p5 := ireduce_level p 5.
seq 12 : (polynomial = p /\ j = j_ /\ col p5 j_ r0 r1 r2 r3 r4 r5 r6 r7).
- ecall (gs_butterflyP p 5 3 (8 * j_) (8 * j_ + 192) (8 * j_ + 224) _ _ _ _ _ _); 2..7: smt().
  ecall (broadcast_zetaP zeta_0); wp.
  ecall (gs_butterflyP p 5 2 (8 * j_) (8 * j_ + 128) (8 * j_ + 160) _ _ _ _ _ _); 2..7: smt().
  ecall (broadcast_zetaP zeta_0); wp.
  ecall (gs_butterflyP p 5 1 (8 * j_) (8 * j_ + 64) (8 * j_ + 96) _ _ _ _ _ _); 2..7: smt().
  ecall (broadcast_zetaP zeta_0); wp.
  ecall (gs_butterflyP p 5 0 (8 * j_) (8 * j_) (8 * j_ + 32) _ _ _ _ _ _); 2..7: smt().
  ecall (broadcast_zetaP zeta_0); wp; skip.
  (* the tables, before simplification evaluates their constant indices *)
  by rewrite !izetas5E.
pose p6 := ireduce_level p5 6.
seq 8 : (polynomial = p /\ j = j_ /\ col p6 j_ r0 r1 r2 r3 r4 r5 r6 r7).
- ecall (gs_butterflyP p5 6 1 (8 * j_ + 32) (8 * j_ + 160) (8 * j_ + 224) _ _ _ _ _ _); 2..7: smt().
  ecall (gs_butterflyP p5 6 1 (8 * j_) (8 * j_ + 128) (8 * j_ + 192) _ _ _ _ _ _); 2..7: smt().
  ecall (broadcast_zetaP zeta_0); wp.
  ecall (gs_butterflyP p5 6 0 (8 * j_ + 32) (8 * j_ + 32) (8 * j_ + 96) _ _ _ _ _ _); 2..7: smt().
  ecall (gs_butterflyP p5 6 0 (8 * j_) (8 * j_) (8 * j_ + 64) _ _ _ _ _ _); 2..7: smt().
  ecall (broadcast_zetaP zeta_0); wp; skip.
  by rewrite !izetas6E.
pose p7 := ireduce_level p6 7.
seq 6 : (polynomial = p /\ j = j_ /\ col p7 j_ r0 r1 r2 r3 r4 r5 r6 r7).
- ecall (gs_butterflyP p6 7 0 (8 * j_ + 96) (8 * j_ + 96) (8 * j_ + 224) _ _ _ _ _ _); 2..7: smt().
  ecall (gs_butterflyP p6 7 0 (8 * j_ + 64) (8 * j_ + 64) (8 * j_ + 192) _ _ _ _ _ _); 2..7: smt().
  ecall (gs_butterflyP p6 7 0 (8 * j_ + 32) (8 * j_ + 32) (8 * j_ + 160) _ _ _ _ _ _); 2..7: smt().
  ecall (gs_butterflyP p6 7 0 (8 * j_) (8 * j_) (8 * j_ + 128) _ _ _ _ _ _); 2..7: smt().
  ecall (broadcast_zetaP zeta_0).
  by auto => />; rewrite izj7E.
pose s7 := iscale p7.
seq 10 : (polynomial = p /\ j = j_ /\ col s7 j_ r0 r1 r2 r3 r4 r5 r6 r7).
- ecall (mmrP r7 zetas); ecall (mmrP r6 zetas); ecall (mmrP r5 zetas); ecall (mmrP r4 zetas).
  ecall (mmrP r3 zetas); ecall (mmrP r2 zetas); ecall (mmrP r1 zetas); ecall (mmrP r0 zetas).
  ecall (broadcast_zetaP zeta_0); auto => />.
  by rewrite /s7 !vec_iscale 1..16:/# /vec /=.
by auto => />; rewrite store_colE // ilevels5_8E.
qed.

(* ==================================================================== *)
(* The inverse NTT                                                      *)
(* ==================================================================== *)
lemma polynomial__invert_ntt_montgomeryP (p_ : wpoly) :
  hoare[M.polynomial__invert_ntt_montgomery :
    polynomial = p_ ==> res = iscale (invtree p_ 8)].
proof.
proc.
pose R := ilevels p_ 0 5.
(* levels 0 to 4, block by block *)
seq 2 : (polynomial = R).
- while (0 <= i <= 4 /\ polynomial = merge (fun t => t %/ 64 < i) p_ R); last first.
  - auto => />; split; first by rewrite merge_none 1:/#.
    by move=> i ? 2?; rewrite merge_all 1:/#.
  exlim polynomial, i => p i_.
  case@[ambient]: (0 <= i_ < 4) => rgi; last first.
  - by conseq (_ : false ==> _); [smt() | exfalso].
  wp; call (intt_layers_0_to_4P p i_ rgi); auto => /> 3?; split; 1: smt().
  apply (merge_step (fun t => t %/ 64) (fun p => ilevels p 0 5)) => p' /= hag.
  by apply (ilevels_frame _ _ 0 5) => // k rgk; apply closed_blk.
(* levels 5 to 7 and the scaling, column by column *)
while (0 <= i <= 4 /\
  polynomial = merge (fun t => t %/ 8 %% 4 < i) R (iscale (ilevels R 5 8))); last first.
- auto => />; split; first by rewrite merge_none 1:/#.
  by move=> i ? 2?; rewrite merge_all 1:/# /R invtree8E.
exlim polynomial, i => p i_.
case@[ambient]: (0 <= i_ < 4) => rgi; last first.
- by conseq (_ : false ==> _); [smt() | exfalso].
wp; call (intt_layers_5_6_7P p i_ rgi); auto => /> 3?; split; 1: smt().
apply (merge_step (fun t => t %/ 8 %% 4) (fun p => iscale (ilevels p 5 8))) => p' /= hag.
apply iscale_frame; apply (ilevels_frame _ _ 5 8) => // k rgk.
by apply closed_col.
qed.

end InttcorrectT.
