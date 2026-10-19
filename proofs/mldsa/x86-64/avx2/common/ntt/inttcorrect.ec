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
require import JArrayExtra CircuitBindings.
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
lemma gs_butterflyP (q : wpoly) (k j r o o2 : int) :
     0 <= k < 8 => 0 <= j < 2^(7-k) => 0 <= r => r + 8 <= 2^k
  => o = j * 2^(k+1) + r => o2 = o + 2^k
  => hoare[M.polynomial____gs_butterfly :
          a = vec q o /\ b = vec q o2 /\ zetas = W8u32.pack8 (nseq 8 (izj k j))
       ==> res = (vec (ireduce_level q k) o, vec (ireduce_level q k) o2)].
proof.
hint +listred.
move=> 5? o2E; proc; ecall (mmrP b_minus_a zetas); auto => &hr [#] -> -> -> /= ? ->.
by rewrite o2E (ivec_lo q k j r o) // (ivec_hi q k j r o) // /vec /=.
qed.

(* level 2: the two halves of each register *)
lemma gs_butterfly_8P (q : wpoly) (jb jb2 o o2 : int) :
  0 <= jb => jb2 = jb + 1 => o = jb * 8 => o2 = o + 8 => o2 + 8 <= 256 =>
  hoare[M.polynomial____gs_butterfly_8 :
       lhs = vec q o /\ rhs = vec q o2
    /\ zetas = W8u32.pack8 [
         izj 2 jb; izj 2 jb; izj 2 jb; izj 2 jb; izj 2 jb2; izj 2 jb2; izj 2 jb2; izj 2 jb2]
    ==> res = (vec (ireduce_level q 2) o, vec (ireduce_level q 2) o2)].
proof.
hint +listred.
move=> 5?; proc; wp; ecall (mmrP differences zetas); auto => &hr [#] -> -> -> /= ? ->.
by rewrite (ivec_small q 2 jb o) 1..4:/# (ivec_small q 2 jb2 o2) 1..4:/# /vec /=.
qed.

(* level 1: the 64-bit quarters *)
lemma gs_butterfly_4P (q : wpoly) (jb jb2 o o2 : int) :
  0 <= jb => jb2 = jb + 2 => o = jb * 4 => o2 = o + 8 => o2 + 8 <= 256 =>
  hoare[M.polynomial____gs_butterfly_4 :
       lhs = vec q o /\ rhs = vec q o2
    /\ zetas = W8u32.pack8 [
         izj 1 jb; izj 1 jb; izj 1 jb2; izj 1 jb2;
         izj 1 (jb + 1); izj 1 (jb + 1); izj 1 (jb2 + 1); izj 1 (jb2 + 1)]
    ==> res = (vec (ireduce_level q 1) o, vec (ireduce_level q 1) o2)].
proof.
hint +listred.
move=> 5?; proc; wp; ecall (mmrP differences zetas); auto => &hr [#] -> -> -> /= ? ->.
by rewrite (ivec_small q 1 jb o) 1..4:/# (ivec_small q 1 jb2 o2) 1..4:/# /vec /=.
qed.

(* level 0: adjacent coefficients, paired by VPSHUFD around level 1 *)
lemma gs_butterfly_2P (q : wpoly) (jb jb2 o o2 : int) :
  0 <= jb => jb2 = jb + 4 => o = jb * 2 => o2 = o + 8 => o2 + 8 <= 256 =>
  hoare[M.polynomial____gs_butterfly_2 :
       lhs = vec q o /\ rhs = vec q o2
    /\ zetas = W8u32.pack8 [
         izj 0 jb; izj 0 (jb + 1); izj 0 jb2; izj 0 (jb2 + 1);
         izj 0 (jb + 2); izj 0 (jb + 3); izj 0 (jb2 + 2); izj 0 (jb2 + 3)]
    ==> res = (vec (ireduce_level q 0) o, vec (ireduce_level q 0) o2)].
proof.
hint +listred.
move=> 5?; proc; inline M.polynomial____gs_butterfly_4; wp.
ecall (mmrP differences zetas0); auto => &hr [#] -> -> -> /= ? ->.
by rewrite (ivec_small q 0 jb o) 1..4:/# (ivec_small q 0 jb2 o2) 1..4:/# /vec /=.
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
seq 8 : (polynomial = p /\ g = g_ /\
     r0 = vec p (64 * g_ +  0) /\ r1 = vec p (64 * g_ +  8)
  /\ r2 = vec p (64 * g_ + 16) /\ r3 = vec p (64 * g_ + 24)
  /\ r4 = vec p (64 * g_ + 32) /\ r5 = vec p (64 * g_ + 40)
  /\ r6 = vec p (64 * g_ + 48) /\ r7 = vec p (64 * g_ + 56)).
- auto => />.
  by rewrite (get256_vecE p _ (64 * g_)) 1,2:/# !(get256_blkE p g_).
pose q0 := ireduce_level p 0.
seq 8 : (polynomial = p /\ g = g_ /\
     r0 = vec q0 (64 * g_ +  0) /\ r1 = vec q0 (64 * g_ +  8)
  /\ r2 = vec q0 (64 * g_ + 16) /\ r3 = vec q0 (64 * g_ + 24)
  /\ r4 = vec q0 (64 * g_ + 32) /\ r5 = vec q0 (64 * g_ + 40)
  /\ r6 = vec q0 (64 * g_ + 48) /\ r7 = vec q0 (64 * g_ + 56)).
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
pose q1 := ireduce_level q0 1.
seq 8 : (polynomial = p /\ g = g_ /\
     r0 = vec q1 (64 * g_ +  0) /\ r1 = vec q1 (64 * g_ +  8)
  /\ r2 = vec q1 (64 * g_ + 16) /\ r3 = vec q1 (64 * g_ + 24)
  /\ r4 = vec q1 (64 * g_ + 32) /\ r5 = vec q1 (64 * g_ + 40)
  /\ r6 = vec q1 (64 * g_ + 48) /\ r7 = vec q1 (64 * g_ + 56)).
- ecall (gs_butterfly_4P q0 (16 * g_ + 12) (16 * g_ + 14) (64 * g_ + 48) (64 * g_ + 56)
    _ _ _ _ _); 2..6: smt().
  wp; ecall (gs_butterfly_4P q0 (16 * g_ + 8) (16 * g_ + 10) (64 * g_ + 32) (64 * g_ + 40)
    _ _ _ _ _); 2..6: smt().
  wp; ecall (gs_butterfly_4P q0 (16 * g_ + 4) (16 * g_ + 6) (64 * g_ + 16) (64 * g_ + 24)
    _ _ _ _ _); 2..6: smt().
  wp; ecall (gs_butterfly_4P q0 (16 * g_) (16 * g_ + 2) (64 * g_) (64 * g_ + 8)
    _ _ _ _ _); 2..6: smt().
  auto => />.
  rewrite (izetas1E (4 * g_) (16 * g_) (16 * g_ + 2)) 1..3:/#.
  rewrite (izetas1E (4 * g_ + 1) (16 * g_ + 4) (16 * g_ + 6)) 1..3:/#.
  rewrite (izetas1E (4 * g_ + 2) (16 * g_ + 8) (16 * g_ + 10)) 1..3:/#.
  by rewrite (izetas1E (4 * g_ + 3) (16 * g_ + 12) (16 * g_ + 14)) 1..3:/#.
pose q2 := ireduce_level q1 2.
seq 8 : (polynomial = p /\ g = g_ /\
     r0 = vec q2 (64 * g_ +  0) /\ r1 = vec q2 (64 * g_ +  8)
  /\ r2 = vec q2 (64 * g_ + 16) /\ r3 = vec q2 (64 * g_ + 24)
  /\ r4 = vec q2 (64 * g_ + 32) /\ r5 = vec q2 (64 * g_ + 40)
  /\ r6 = vec q2 (64 * g_ + 48) /\ r7 = vec q2 (64 * g_ + 56)).
- ecall (gs_butterfly_8P q1 (8 * g_ + 6) (8 * g_ + 7) (64 * g_ + 48) (64 * g_ + 56)
    _ _ _ _ _); 2..6: smt().
  wp; ecall (gs_butterfly_8P q1 (8 * g_ + 4) (8 * g_ + 5) (64 * g_ + 32) (64 * g_ + 40)
    _ _ _ _ _); 2..6: smt().
  wp; ecall (gs_butterfly_8P q1 (8 * g_ + 2) (8 * g_ + 3) (64 * g_ + 16) (64 * g_ + 24)
    _ _ _ _ _); 2..6: smt().
  wp; ecall (gs_butterfly_8P q1 (8 * g_) (8 * g_ + 1) (64 * g_) (64 * g_ + 8)
    _ _ _ _ _); 2..6: smt().
  auto => />.
  rewrite (izetas2E (4 * g_) (8 * g_) (8 * g_ + 1)) 1..3:/#.
  rewrite (izetas2E (4 * g_ + 1) (8 * g_ + 2) (8 * g_ + 3)) 1..3:/#.
  rewrite (izetas2E (4 * g_ + 2) (8 * g_ + 4) (8 * g_ + 5)) 1..3:/#.
  by rewrite (izetas2E (4 * g_ + 3) (8 * g_ + 6) (8 * g_ + 7)) 1..3:/#.
pose q3 := ireduce_level q2 3.
seq 12 : (polynomial = p /\ g = g_ /\
     r0 = vec q3 (64 * g_ +  0) /\ r1 = vec q3 (64 * g_ +  8)
  /\ r2 = vec q3 (64 * g_ + 16) /\ r3 = vec q3 (64 * g_ + 24)
  /\ r4 = vec q3 (64 * g_ + 32) /\ r5 = vec q3 (64 * g_ + 40)
  /\ r6 = vec q3 (64 * g_ + 48) /\ r7 = vec q3 (64 * g_ + 56)).
- ecall (gs_butterflyP q2 3 (4 * g_ + 3) 0 (64 * g_ + 48) (64 * g_ + 56) _ _ _ _ _ _); 2..7: smt().
  ecall (broadcast_zetaP zeta_0); wp.
  ecall (gs_butterflyP q2 3 (4 * g_ + 2) 0 (64 * g_ + 32) (64 * g_ + 40) _ _ _ _ _ _); 2..7: smt().
  ecall (broadcast_zetaP zeta_0); wp.
  ecall (gs_butterflyP q2 3 (4 * g_ + 1) 0 (64 * g_ + 16) (64 * g_ + 24) _ _ _ _ _ _); 2..7: smt().
  ecall (broadcast_zetaP zeta_0); wp.
  ecall (gs_butterflyP q2 3 (4 * g_) 0 (64 * g_) (64 * g_ + 8) _ _ _ _ _ _); 2..7: smt().
  ecall (broadcast_zetaP zeta_0).
  by auto => />; rewrite !izetas3E 1..4:/#.
pose q4 := ireduce_level q3 4.
seq 8 : (polynomial = p /\ g = g_ /\
     r0 = vec q4 (64 * g_ +  0) /\ r1 = vec q4 (64 * g_ +  8)
  /\ r2 = vec q4 (64 * g_ + 16) /\ r3 = vec q4 (64 * g_ + 24)
  /\ r4 = vec q4 (64 * g_ + 32) /\ r5 = vec q4 (64 * g_ + 40)
  /\ r6 = vec q4 (64 * g_ + 48) /\ r7 = vec q4 (64 * g_ + 56)).
- ecall (gs_butterflyP q3 4 (2 * g_ + 1) 8 (64 * g_ + 40) (64 * g_ + 56) _ _ _ _ _ _); 2..7: smt().
  ecall (gs_butterflyP q3 4 (2 * g_ + 1) 0 (64 * g_ + 32) (64 * g_ + 48) _ _ _ _ _ _); 2..7: smt().
  ecall (broadcast_zetaP zeta_0); wp.
  ecall (gs_butterflyP q3 4 (2 * g_) 8 (64 * g_ + 8) (64 * g_ + 24) _ _ _ _ _ _); 2..7: smt().
  ecall (gs_butterflyP q3 4 (2 * g_) 0 (64 * g_) (64 * g_ + 16) _ _ _ _ _ _); 2..7: smt().
  ecall (broadcast_zetaP zeta_0).
  by auto => />; rewrite !izetas4E 1..2:/#.
auto => />.
rewrite (set256_initE _ _ (64 * g_ + 56)) 1,2:/# (set256_initE _ _ (64 * g_ + 48)) 1,2:/#.
rewrite (set256_initE _ _ (64 * g_ + 40)) 1,2:/# (set256_initE _ _ (64 * g_ + 32)) 1,2:/#.
rewrite (set256_initE _ _ (64 * g_ + 24)) 1,2:/# (set256_initE _ _ (64 * g_ + 16)) 1,2:/#.
rewrite (set256_initE _ _ (64 * g_ + 8)) 1,2:/# (set256_initE _ _ (64 * g_)) 1,2:/#.
apply Array256.tP => t rgt; rewrite /merge Array256.initiE //= ilevels0_5E.
by rewrite !Array256.filliE //; smt(vec_bits).
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
seq 8 : (polynomial = p /\ j = j_ /\
     r0 = vec p (8 * j_ +   0) /\ r1 = vec p (8 * j_ +  32)
  /\ r2 = vec p (8 * j_ +  64) /\ r3 = vec p (8 * j_ +  96)
  /\ r4 = vec p (8 * j_ + 128) /\ r5 = vec p (8 * j_ + 160)
  /\ r6 = vec p (8 * j_ + 192) /\ r7 = vec p (8 * j_ + 224)).
- auto => />.
  rewrite (get256_vecE p _ (8 * j_)) 1,2:/# (get256_vecE p _ (8 * j_ + 32)) 1,2:/#.
  rewrite (get256_vecE p _ (8 * j_ + 64)) 1,2:/# (get256_vecE p _ (8 * j_ + 96)) 1,2:/#.
  rewrite (get256_vecE p _ (8 * j_ + 128)) 1,2:/# (get256_vecE p _ (8 * j_ + 160)) 1,2:/#.
  by rewrite (get256_vecE p _ (8 * j_ + 192)) 1,2:/# (get256_vecE p _ (8 * j_ + 224)) 1,2:/#.
pose q5 := ireduce_level p 5.
seq 12 : (polynomial = p /\ j = j_ /\
     r0 = vec q5 (8 * j_ +   0) /\ r1 = vec q5 (8 * j_ +  32)
  /\ r2 = vec q5 (8 * j_ +  64) /\ r3 = vec q5 (8 * j_ +  96)
  /\ r4 = vec q5 (8 * j_ + 128) /\ r5 = vec q5 (8 * j_ + 160)
  /\ r6 = vec q5 (8 * j_ + 192) /\ r7 = vec q5 (8 * j_ + 224)).
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
pose q6 := ireduce_level q5 6.
seq 8 : (polynomial = p /\ j = j_ /\
     r0 = vec q6 (8 * j_ +   0) /\ r1 = vec q6 (8 * j_ +  32)
  /\ r2 = vec q6 (8 * j_ +  64) /\ r3 = vec q6 (8 * j_ +  96)
  /\ r4 = vec q6 (8 * j_ + 128) /\ r5 = vec q6 (8 * j_ + 160)
  /\ r6 = vec q6 (8 * j_ + 192) /\ r7 = vec q6 (8 * j_ + 224)).
- ecall (gs_butterflyP q5 6 1 (8 * j_ + 32) (8 * j_ + 160) (8 * j_ + 224) _ _ _ _ _ _); 2..7: smt().
  ecall (gs_butterflyP q5 6 1 (8 * j_) (8 * j_ + 128) (8 * j_ + 192) _ _ _ _ _ _); 2..7: smt().
  ecall (broadcast_zetaP zeta_0); wp.
  ecall (gs_butterflyP q5 6 0 (8 * j_ + 32) (8 * j_ + 32) (8 * j_ + 96) _ _ _ _ _ _); 2..7: smt().
  ecall (gs_butterflyP q5 6 0 (8 * j_) (8 * j_) (8 * j_ + 64) _ _ _ _ _ _); 2..7: smt().
  ecall (broadcast_zetaP zeta_0); wp; skip.
  by rewrite !izetas6E.
pose q7 := ireduce_level q6 7.
seq 6 : (polynomial = p /\ j = j_ /\
     r0 = vec q7 (8 * j_ +   0) /\ r1 = vec q7 (8 * j_ +  32)
  /\ r2 = vec q7 (8 * j_ +  64) /\ r3 = vec q7 (8 * j_ +  96)
  /\ r4 = vec q7 (8 * j_ + 128) /\ r5 = vec q7 (8 * j_ + 160)
  /\ r6 = vec q7 (8 * j_ + 192) /\ r7 = vec q7 (8 * j_ + 224)).
- ecall (gs_butterflyP q6 7 0 (8 * j_ + 96) (8 * j_ + 96) (8 * j_ + 224) _ _ _ _ _ _); 2..7: smt().
  ecall (gs_butterflyP q6 7 0 (8 * j_ + 64) (8 * j_ + 64) (8 * j_ + 192) _ _ _ _ _ _); 2..7: smt().
  ecall (gs_butterflyP q6 7 0 (8 * j_ + 32) (8 * j_ + 32) (8 * j_ + 160) _ _ _ _ _ _); 2..7: smt().
  ecall (gs_butterflyP q6 7 0 (8 * j_) (8 * j_) (8 * j_ + 128) _ _ _ _ _ _); 2..7: smt().
  ecall (broadcast_zetaP zeta_0).
  by auto => />; rewrite izj7E.
pose s7 := iscale q7.
seq 10 : (polynomial = p /\ j = j_ /\
     r0 = vec s7 (8 * j_ +   0) /\ r1 = vec s7 (8 * j_ +  32)
  /\ r2 = vec s7 (8 * j_ +  64) /\ r3 = vec s7 (8 * j_ +  96)
  /\ r4 = vec s7 (8 * j_ + 128) /\ r5 = vec s7 (8 * j_ + 160)
  /\ r6 = vec s7 (8 * j_ + 192) /\ r7 = vec s7 (8 * j_ + 224)).
- ecall (mmrP r7 zetas); ecall (mmrP r6 zetas); ecall (mmrP r5 zetas); ecall (mmrP r4 zetas).
  ecall (mmrP r3 zetas); ecall (mmrP r2 zetas); ecall (mmrP r1 zetas); ecall (mmrP r0 zetas).
  ecall (broadcast_zetaP zeta_0); auto => />.
  by rewrite /s7 !vec_iscale 1..16:/# /vec /=.
auto => />.
rewrite (set256_initE _ _ (8 * j_ + 224)) 1,2:/# (set256_initE _ _ (8 * j_ + 192)) 1,2:/#.
rewrite (set256_initE _ _ (8 * j_ + 160)) 1,2:/# (set256_initE _ _ (8 * j_ + 128)) 1,2:/#.
rewrite (set256_initE _ _ (8 * j_ + 96)) 1,2:/# (set256_initE _ _ (8 * j_ + 64)) 1,2:/#.
rewrite (set256_initE _ _ (8 * j_ + 32)) 1,2:/# (set256_initE _ _ (8 * j_)) 1,2:/#.
apply Array256.tP => t rgt; rewrite /merge Array256.initiE //= ilevels5_8E.
by rewrite !Array256.filliE //; smt(vec_bits).
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
  - auto => />; split.
    - by apply Array256.tP => t rgt; rewrite /merge initiE //= /#.
    move=> i ? 2? @/merge; apply Array256.tP => t rgt.
    by rewrite initiE //= ifT // /#.
  exlim polynomial, i => q i_.
  case@[ambient]: (0 <= i_ < 4) => rgi; last first.
  - by conseq (_ : false ==> _); [smt() | exfalso].
  wp; call (intt_layers_0_to_4P q i_ rgi); auto => /> 3?; split; 1: smt().
  pose m := merge (fun t => t %/ 64 < i_) p_ R.
  apply Array256.tP => t rgt; rewrite /merge !initiE //=.
  case: (t %/ 64 = i_) => ht; last by rewrite /m /merge initiE //= /#.
  rewrite ifT 1:/#; apply (ilevels_frame _ _ 0 5 (fun t => t %/ 64 = i_)) => //.
  - move=> k rgk; have : k = 0 \/ k = 1 \/ k = 2 \/ k = 3 \/ k = 4 by smt().
    by case=> [->|[->|[->|[->|->]]]]; rewrite /closed /=; split => u rgu hu ?; smt().
  - by move=> u rgu /= hu; rewrite /m /merge initiE //= ifF 1:/#.
(* levels 5 to 7 and the scaling, column by column *)
while (0 <= i <= 4 /\
  polynomial = merge (fun t => t %/ 8 %% 4 < i) R (iscale (ilevels R 5 8))); last first.
- auto => />; split.
  - by apply Array256.tP => t rgt; rewrite /merge initiE //= /#.
  move=> i ? 2? @/merge; apply Array256.tP => t rgt.
  by rewrite initiE //= ifT 1:/# /R invtree8E.
exlim polynomial, i => q i_.
case@[ambient]: (0 <= i_ < 4) => rgi; last first.
- by conseq (_ : false ==> _); [smt() | exfalso].
wp; call (intt_layers_5_6_7P q i_ rgi); auto => /> 3?; split; 1: smt().
pose m := merge (fun t => t %/ 8 %% 4 < i_) R (iscale (ilevels R 5 8)).
apply Array256.tP => t rgt; rewrite /merge !initiE //=.
case: (t %/ 8 %% 4 = i_) => ht; last by rewrite /m /merge initiE //= /#.
rewrite ifT 1:/#; apply (iscale_frame _ _ (fun t => t %/ 8 %% 4 = i_)) => //.
apply (ilevels_frame _ _ 5 8) => //.
- move=> k rgk; have : k = 5 \/ k = 6 \/ k = 7 by smt().
  by case=> [->|[->|->]]; rewrite /closed /=; split => u rgu hu _; smt().
- by move=> u rgu /= hu; rewrite /m /merge initiE //= ifF 1:/#.
qed.

end InttcorrectT.
