(**
  This theory connects the extracted implementation code to the
  machine-level specification of the NTT.
*)
require import AllCore CoreUtils List Ring IntDiv BitEncoding.
require import StdRing StdOrder.
from Jasmin require import JWord JArray.
require import JArrayExtra.
require import CircuitBindings.
from Jasmin require import JModel_x86.
require import MldsaConstants.
require Parameters MldsaT.
require import WArray1024.
require import Array4 Array8 Array16 Array256.
require import XArray256.
require import Nttzetas Nttspec Nttlogspec Nttvec.
require import Avx2red Listred.

abstract theory FnttcorrectT.

clone import Parameters.ParamsT as P.
clone import MldsaT.MldsaT as R with theory P <- P.
clone import Avx2red.Avx2redT as AR with theory P <- P, theory R <- R.

(* -------------------------------------------------------------------- *)

import BitChunking.

(* -------------------------------------------------------------------- *)
type wpoly = W32.t Array256.t.

(* ==================================================================== *)
(* Butterflies                                                          *)
(* ==================================================================== *)
(* levels 7 to 3: one register against another *)
lemma ct_butterflyP (q : wpoly) (k j r o o2 : int) :
     0 <= k < 8 => 0 <= j < 2^(7-k) => 0 <= r => r + 8 <= 2^k
  => o = j * 2^(k+1) + r => o2 = o + 2^k
  => hoare[M.polynomial____ct_butterfly :
          a = vec q o /\ b = vec q o2 /\ zetas = W8u32.pack8 (nseq 8 (zj k j))
       ==> res = (vec (reduce_level q k) o, vec (reduce_level q k) o2)].
proof.
hint +listred.
move=> 5? o2E; proc; wp; ecall (mmrP b zetas); auto => &hr [#] -> -> -> ? ->.
by rewrite o2E (vec_lo q k j r o) // (vec_hi q k j r o) // /vec /=.
qed.

(* level 2: the two halves of each register *)
lemma ct_butterfly_8P (q : wpoly) (jb jb2 o o2 : int) :
  0 <= jb => jb2 = jb + 1 => o = jb * 8 => o2 = o + 8 => o2 + 8 <= 256 =>
  hoare[M.polynomial____ct_butterfly_8 :
       lhs = vec q o /\ rhs = vec q o2
    /\ zetas = W2u128.pack2 [W4u32.pack4 (nseq 4 (zj 2 jb)); W4u32.pack4 (nseq 4 (zj 2 jb2))]
    ==> res = (vec (reduce_level q 2) o, vec (reduce_level q 2) o2)].
proof.
hint +listred.
move=> 5?; proc; wp; ecall (mmrP zeta_products zetas); auto => &hr [#] -> -> -> /= ? ->.
by rewrite (vec_small q 2 jb o) 1..4:/# (vec_small q 2 jb2 o2) 1..4:/# /vec /=.
qed.

(* level 1: the 64-bit quarters *)
lemma ct_butterfly_4P (q : wpoly) (jb jb2 o o2 : int) :
  0 <= jb => jb2 = jb + 2 => o = jb * 4 => o2 = o + 8 => o2 + 8 <= 256 =>
  hoare[M.polynomial____ct_butterfly_4 :
       lhs = vec q o /\ rhs = vec q o2
    /\ zetas = W4u64.pack4 [
         W2u32.pack2 (nseq 2 (zj 1 jb)); W2u32.pack2 (nseq 2 (zj 1 jb2));
         W2u32.pack2 (nseq 2 (zj 1 (jb + 1))); W2u32.pack2 (nseq 2 (zj 1 (jb2 + 1)))]
    ==> res = (vec (reduce_level q 1) o, vec (reduce_level q 1) o2)].
proof.
hint +listred.
move=> 5?; proc; wp; ecall (mmrP zeta_products zetas); auto => &hr [#] -> -> -> /= ? ->.
by rewrite (vec_small q 1 jb o) 1..4:/# (vec_small q 1 jb2 o2) 1..4:/# /vec /=.
qed.

(* level 0: adjacent coefficients, paired by VPSHUFD around level 1 *)
lemma ct_butterfly_2P (q : wpoly) (jb jb2 o o2 : int) :
  0 <= jb => jb2 = jb + 4 => o = jb * 2 => o2 = o + 8 => o2 + 8 <= 256 =>
  hoare[M.polynomial____ct_butterfly_2 :
       lhs = vec q o /\ rhs = vec q o2
    /\ zetas = W8u32.pack8 [
         zj 0 jb; zj 0 (jb + 1); zj 0 jb2; zj 0 (jb2 + 1);
         zj 0 (jb + 2); zj 0 (jb + 3); zj 0 (jb2 + 2); zj 0 (jb2 + 3)]
    ==> res = (vec (reduce_level q 0) o, vec (reduce_level q 0) o2)].
proof.
hint +listred.
move=> 5?; proc; inline M.polynomial____ct_butterfly_4; wp.
ecall (mmrP zeta_products zetas0); auto => &hr [#] -> -> -> /= ? ->.
by rewrite (vec_small q 0 jb o) 1..4:/# (vec_small q 0 jb2 o2) 1..4:/# /vec /=.
qed.

(* ==================================================================== *)
(* Levels 4 to 0, on the block g of 64 coefficients                     *)
(* ==================================================================== *)
lemma ntt_layers_4_to_0P (p : wpoly) (g_ : int) : 0 <= g_ < 4 =>
  hoare[M.polynomial____ntt_layers_4_to_0 :
    arg = (p, g_) ==> res = merge (fun t => t %/ 64 = g_) p (levels p 0 5)].
proof.
move=> rgg; proc.
seq 8 : (polynomial = p /\ g = g_ /\
     r0 = vec p (64 * g_ +  0) /\ r1 = vec p (64 * g_ +  8)
  /\ r2 = vec p (64 * g_ + 16) /\ r3 = vec p (64 * g_ + 24)
  /\ r4 = vec p (64 * g_ + 32) /\ r5 = vec p (64 * g_ + 40)
  /\ r6 = vec p (64 * g_ + 48) /\ r7 = vec p (64 * g_ + 56)).
- auto => />.
  by rewrite (get256_vecE p _ (64 * g_)) 1,2:/# !(get256_blkE p g_).
pose q4 := reduce_level p 4.
seq 6 : (polynomial = p /\ g = g_ /\
     r0 = vec q4 (64 * g_ +  0) /\ r1 = vec q4 (64 * g_ +  8)
  /\ r2 = vec q4 (64 * g_ + 16) /\ r3 = vec q4 (64 * g_ + 24)
  /\ r4 = vec q4 (64 * g_ + 32) /\ r5 = vec q4 (64 * g_ + 40)
  /\ r6 = vec q4 (64 * g_ + 48) /\ r7 = vec q4 (64 * g_ + 56)).
- ecall (ct_butterflyP p 4 (2 * g_ + 1) 8 (64 * g_ + 40) (64 * g_ + 56) _ _ _ _ _ _); 2..7: smt().
  ecall (ct_butterflyP p 4 (2 * g_ + 1) 0 (64 * g_ + 32) (64 * g_ + 48) _ _ _ _ _ _); 2..7: smt().
  wp; ecall (ct_butterflyP p 4 (2 * g_) 8 (64 * g_ + 8) (64 * g_ + 24) _ _ _ _ _ _); 2..7: smt().
  ecall (ct_butterflyP p 4 (2 * g_) 0 (64 * g_ + 0) (64 * g_ + 16) _ _ _ _ _ _); 2..7: smt().
  by auto => />; rewrite !zetas4E 1..2:/#.
pose q3 := reduce_level q4 3.
seq 8 : (polynomial = p /\ g = g_ /\
     r0 = vec q3 (64 * g_ +  0) /\ r1 = vec q3 (64 * g_ +  8)
  /\ r2 = vec q3 (64 * g_ + 16) /\ r3 = vec q3 (64 * g_ + 24)
  /\ r4 = vec q3 (64 * g_ + 32) /\ r5 = vec q3 (64 * g_ + 40)
  /\ r6 = vec q3 (64 * g_ + 48) /\ r7 = vec q3 (64 * g_ + 56)).
- ecall (ct_butterflyP q4 3 (4 * g_ + 3) 0 (64 * g_ + 48) (64 * g_ + 56) _ _ _ _ _ _); 2..7: smt().
  wp; ecall (ct_butterflyP q4 3 (4 * g_ + 2) 0 (64 * g_ + 32) (64 * g_ + 40)
    _ _ _ _ _ _); 2..7: smt().
  wp; ecall (ct_butterflyP q4 3 (4 * g_ + 1) 0 (64 * g_ + 16) (64 * g_ + 24)
    _ _ _ _ _ _); 2..7: smt().
  wp; ecall (ct_butterflyP q4 3 (4 * g_) 0 (64 * g_) (64 * g_ + 8) _ _ _ _ _ _); 2..7: smt().
  by auto => />; rewrite !zetas3E 1..4:/#.
pose q2 := reduce_level q3 2.
seq 8 : (polynomial = p /\ g = g_ /\
     r0 = vec q2 (64 * g_ +  0) /\ r1 = vec q2 (64 * g_ +  8)
  /\ r2 = vec q2 (64 * g_ + 16) /\ r3 = vec q2 (64 * g_ + 24)
  /\ r4 = vec q2 (64 * g_ + 32) /\ r5 = vec q2 (64 * g_ + 40)
  /\ r6 = vec q2 (64 * g_ + 48) /\ r7 = vec q2 (64 * g_ + 56)).
- ecall (ct_butterfly_8P q3 (8 * g_ + 6) (8 * g_ + 7) (64 * g_ + 48) (64 * g_ + 56)
    _ _ _ _ _); 2..6: smt().
  wp; ecall (ct_butterfly_8P q3 (8 * g_ + 4) (8 * g_ + 5) (64 * g_ + 32) (64 * g_ + 40)
    _ _ _ _ _); 2..6: smt().
  wp; ecall (ct_butterfly_8P q3 (8 * g_ + 2) (8 * g_ + 3) (64 * g_ + 16) (64 * g_ + 24)
    _ _ _ _ _); 2..6: smt().
  wp; ecall (ct_butterfly_8P q3 (8 * g_) (8 * g_ + 1) (64 * g_) (64 * g_ + 8)
    _ _ _ _ _); 2..6: smt().
  auto => />.
  rewrite (zetas2E (4 * g_) (8 * g_) (8 * g_ + 1)) 1..3:/#.
  rewrite (zetas2E (4 * g_ + 1) (8 * g_ + 2) (8 * g_ + 3)) 1..3:/#.
  rewrite (zetas2E (4 * g_ + 2) (8 * g_ + 4) (8 * g_ + 5)) 1..3:/#.
  by rewrite (zetas2E (4 * g_ + 3) (8 * g_ + 6) (8 * g_ + 7)) 1..3:/#.
pose q1 := reduce_level q2 1.
seq 8 : (polynomial = p /\ g = g_ /\
     r0 = vec q1 (64 * g_ +  0) /\ r1 = vec q1 (64 * g_ +  8)
  /\ r2 = vec q1 (64 * g_ + 16) /\ r3 = vec q1 (64 * g_ + 24)
  /\ r4 = vec q1 (64 * g_ + 32) /\ r5 = vec q1 (64 * g_ + 40)
  /\ r6 = vec q1 (64 * g_ + 48) /\ r7 = vec q1 (64 * g_ + 56)).
- ecall (ct_butterfly_4P q2 (16 * g_ + 12) (16 * g_ + 14) (64 * g_ + 48) (64 * g_ + 56)
    _ _ _ _ _); 2..6: smt().
  wp; ecall (ct_butterfly_4P q2 (16 * g_ + 8) (16 * g_ + 10) (64 * g_ + 32) (64 * g_ + 40)
    _ _ _ _ _); 2..6: smt().
  wp; ecall (ct_butterfly_4P q2 (16 * g_ + 4) (16 * g_ + 6) (64 * g_ + 16) (64 * g_ + 24)
    _ _ _ _ _); 2..6: smt().
  wp; ecall (ct_butterfly_4P q2 (16 * g_) (16 * g_ + 2) (64 * g_) (64 * g_ + 8)
    _ _ _ _ _); 2..6: smt().
  auto => />.
  rewrite (zetas1E (4 * g_) (16 * g_) (16 * g_ + 2)) 1..3:/#.
  rewrite (zetas1E (4 * g_ + 1) (16 * g_ + 4) (16 * g_ + 6)) 1..3:/#.
  rewrite (zetas1E (4 * g_ + 2) (16 * g_ + 8) (16 * g_ + 10)) 1..3:/#.
  by rewrite (zetas1E (4 * g_ + 3) (16 * g_ + 12) (16 * g_ + 14)) 1..3:/#.
pose q0 := reduce_level q1 0.
seq 8 : (polynomial = p /\ g = g_ /\
     r0 = vec q0 (64 * g_ +  0) /\ r1 = vec q0 (64 * g_ +  8)
  /\ r2 = vec q0 (64 * g_ + 16) /\ r3 = vec q0 (64 * g_ + 24)
  /\ r4 = vec q0 (64 * g_ + 32) /\ r5 = vec q0 (64 * g_ + 40)
  /\ r6 = vec q0 (64 * g_ + 48) /\ r7 = vec q0 (64 * g_ + 56)).
- ecall (ct_butterfly_2P q1 (32 * g_ + 24) (32 * g_ + 28) (64 * g_ + 48) (64 * g_ + 56)
    _ _ _ _ _); 2..6: smt().
  wp; ecall (ct_butterfly_2P q1 (32 * g_ + 16) (32 * g_ + 20) (64 * g_ + 32) (64 * g_ + 40)
    _ _ _ _ _); 2..6: smt().
  wp; ecall (ct_butterfly_2P q1 (32 * g_ + 8) (32 * g_ + 12) (64 * g_ + 16) (64 * g_ + 24)
    _ _ _ _ _); 2..6: smt().
  wp; ecall (ct_butterfly_2P q1 (32 * g_) (32 * g_ + 4) (64 * g_) (64 * g_ + 8)
    _ _ _ _ _); 2..6: smt().
  auto => />.
  rewrite (zetas0E (4 * g_) (32 * g_) (32 * g_ + 4)) 1..3:/#.
  rewrite (zetas0E (4 * g_ + 1) (32 * g_ + 8) (32 * g_ + 12)) 1..3:/#.
  rewrite (zetas0E (4 * g_ + 2) (32 * g_ + 16) (32 * g_ + 20)) 1..3:/#.
  by rewrite (zetas0E (4 * g_ + 3) (32 * g_ + 24) (32 * g_ + 28)) 1..3:/#.
auto => />.
rewrite (set256_initE _ _ (64 * g_ + 56)) 1,2:/# (set256_initE _ _ (64 * g_ + 48)) 1,2:/#.
rewrite (set256_initE _ _ (64 * g_ + 40)) 1,2:/# (set256_initE _ _ (64 * g_ + 32)) 1,2:/#.
rewrite (set256_initE _ _ (64 * g_ + 24)) 1,2:/# (set256_initE _ _ (64 * g_ + 16)) 1,2:/#.
rewrite (set256_initE _ _ (64 * g_ + 8)) 1,2:/# (set256_initE _ _ (64 * g_)) 1,2:/#.
apply Array256.tP => t rgt; rewrite /merge Array256.initiE //= levels0_5E.
by rewrite !Array256.filliE //; smt(vec_bits).
qed.

(* ==================================================================== *)
(* Levels 7 to 5, on the column j of registers                          *)
(* ==================================================================== *)
lemma ntt_layers_7_6_5P (p : wpoly) (j_ : int) : 0 <= j_ < 4 =>
  hoare[M.polynomial____ntt_layers_7_6_5 :
    arg = (p, j_) ==> res = merge (fun t => t %/ 8 %% 4 = j_) p (levels p 5 8)].
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
pose q7 := reduce_level p 7.
seq 7 : (polynomial = p /\ j = j_ /\
     r0 = vec q7 (8 * j_ +   0) /\ r1 = vec q7 (8 * j_ +  32)
  /\ r2 = vec q7 (8 * j_ +  64) /\ r3 = vec q7 (8 * j_ +  96)
  /\ r4 = vec q7 (8 * j_ + 128) /\ r5 = vec q7 (8 * j_ + 160)
  /\ r6 = vec q7 (8 * j_ + 192) /\ r7 = vec q7 (8 * j_ + 224)).
- ecall (ct_butterflyP p 7 0 (8 * j_ + 96) (8 * j_ + 96) (8 * j_ + 224) _ _ _ _ _ _); 2..7: smt().
  ecall (ct_butterflyP p 7 0 (8 * j_ + 64) (8 * j_ + 64) (8 * j_ + 192) _ _ _ _ _ _); 2..7: smt().
  ecall (ct_butterflyP p 7 0 (8 * j_ + 32) (8 * j_ + 32) (8 * j_ + 160) _ _ _ _ _ _); 2..7: smt().
  ecall (ct_butterflyP p 7 0 (8 * j_) (8 * j_) (8 * j_ + 128) _ _ _ _ _ _); 2..7: smt().
  by auto => />; rewrite zj7E.
pose q6 := reduce_level q7 6.
seq 10 : (polynomial = p /\ j = j_ /\
     r0 = vec q6 (8 * j_ +   0) /\ r1 = vec q6 (8 * j_ +  32)
  /\ r2 = vec q6 (8 * j_ +  64) /\ r3 = vec q6 (8 * j_ +  96)
  /\ r4 = vec q6 (8 * j_ + 128) /\ r5 = vec q6 (8 * j_ + 160)
  /\ r6 = vec q6 (8 * j_ + 192) /\ r7 = vec q6 (8 * j_ + 224)).
- ecall (ct_butterflyP q7 6 1 (8 * j_ + 32) (8 * j_ + 160) (8 * j_ + 224) _ _ _ _ _ _); 2..7: smt().
  ecall (ct_butterflyP q7 6 1 (8 * j_) (8 * j_ + 128) (8 * j_ + 192) _ _ _ _ _ _); 2..7: smt().
  wp; ecall (ct_butterflyP q7 6 0 (8 * j_ + 32) (8 * j_ + 32) (8 * j_ + 96)
    _ _ _ _ _ _); 2..7: smt().
  ecall (ct_butterflyP q7 6 0 (8 * j_) (8 * j_) (8 * j_ + 64) _ _ _ _ _ _); 2..7: smt().
  by auto => />; rewrite !zj6E.
pose q5 := reduce_level q6 5.
seq 8 : (polynomial = p /\ j = j_ /\
     r0 = vec q5 (8 * j_ +   0) /\ r1 = vec q5 (8 * j_ +  32)
  /\ r2 = vec q5 (8 * j_ +  64) /\ r3 = vec q5 (8 * j_ +  96)
  /\ r4 = vec q5 (8 * j_ + 128) /\ r5 = vec q5 (8 * j_ + 160)
  /\ r6 = vec q5 (8 * j_ + 192) /\ r7 = vec q5 (8 * j_ + 224)).
- (* the opaque table, so that the constant indices are not evaluated *)
  proc rewrite 1 LAYER_5_ZETASE; proc rewrite 3 LAYER_5_ZETASE.
  proc rewrite 5 LAYER_5_ZETASE; proc rewrite 7 LAYER_5_ZETASE.
  ecall (ct_butterflyP q6 5 3 (8 * j_) (8 * j_ + 192) (8 * j_ + 224) _ _ _ _ _ _); 2..7: smt().
  wp; ecall (ct_butterflyP q6 5 2 (8 * j_) (8 * j_ + 128) (8 * j_ + 160) _ _ _ _ _ _); 2..7: smt().
  wp; ecall (ct_butterflyP q6 5 1 (8 * j_) (8 * j_ + 64) (8 * j_ + 96) _ _ _ _ _ _); 2..7: smt().
  wp; ecall (ct_butterflyP q6 5 0 (8 * j_) (8 * j_) (8 * j_ + 32) _ _ _ _ _ _); 2..7: smt().
  by auto => />; rewrite -LAYER_5_ZETASE !zetas5E.
auto => />.
rewrite (set256_initE _ _ (8 * j_ + 224)) 1,2:/# (set256_initE _ _ (8 * j_ + 192)) 1,2:/#.
rewrite (set256_initE _ _ (8 * j_ + 160)) 1,2:/# (set256_initE _ _ (8 * j_ + 128)) 1,2:/#.
rewrite (set256_initE _ _ (8 * j_ + 96)) 1,2:/# (set256_initE _ _ (8 * j_ + 64)) 1,2:/#.
rewrite (set256_initE _ _ (8 * j_ + 32)) 1,2:/# (set256_initE _ _ (8 * j_)) 1,2:/#.
apply Array256.tP => t rgt; rewrite /merge Array256.initiE //= levels5_8E.
by rewrite !Array256.filliE //; smt(vec_bits).
qed.

(* ==================================================================== *)
(* The NTT                                                              *)
(* ==================================================================== *)
lemma polynomial__nttP (p_ : wpoly) :
  hoare[M.polynomial__ntt : polynomial = p_ ==> res = reduce_tree p_ 0].
proof.
proc.
pose R := levels p_ 5 8.
(* levels 7 to 5, column by column *)
seq 2 : (polynomial = R).
- while (0 <= i <= 4 /\ polynomial = merge (fun t => t %/ 8 %% 4 < i) p_ R); last first.
  - auto => />; split.
    - by apply Array256.tP => t rgt; rewrite /merge initiE //= /#.
    move=> i ? 2? @/merge; apply Array256.tP => t rgt.
    by rewrite initiE //= ifT // /#.
  exlim polynomial, i => q i_.
  case@[ambient]: (0 <= i_ < 4) => rgi; last first.
  - by conseq (_ : false ==> _); [smt() | exfalso].
  wp; call (ntt_layers_7_6_5P q i_ rgi); auto => /> 3?; split; 1: smt().
  pose m := merge (fun t => t %/ 8 %% 4 < i_) p_ R.
  apply Array256.tP => t rgt; rewrite /merge !initiE //=.
  case: (t %/ 8 %% 4 = i_) => ht; last by rewrite /m /merge initiE //= /#.
  rewrite ifT 1:/#; apply (levels_frame _ _ 5 8 (fun t => t %/ 8 %% 4 = i_)) => //.
  - move=> k rgk; have : k = 5 \/ k = 6 \/ k = 7 by smt().
    by case=> [->|[->|->]]; rewrite /closed /=; split => u rgu hu _; smt().
  - by move=> u rgu /= hu; rewrite /m /merge initiE //= ifF 1:/#.
(* levels 4 to 0, block by block *)
while (0 <= i <= 4 /\ polynomial = merge (fun t => t %/ 64 < i) R (levels R 0 5)); last first.
- auto => />; split.
  - by apply Array256.tP => t rgt; rewrite /merge initiE //= /#.
  move=> i ? 2? @/merge; apply Array256.tP => t rgt.
  rewrite initiE //= ifT 1:/# /R levels0_5E levels5_8E.
  by rewrite /reduce_tree /range /= -iotaredE.
exlim polynomial, i => q i_.
case@[ambient]: (0 <= i_ < 4) => rgi; last first.
- by conseq (_ : false ==> _); [smt() | exfalso].
wp; call (ntt_layers_4_to_0P q i_ rgi); auto => /> 3?; split; 1: smt().
pose m := merge (fun t => t %/ 64 < i_) R (levels R 0 5).
apply Array256.tP => t rgt; rewrite /merge !initiE //=.
case: (t %/ 64 = i_) => ht; last by rewrite /m /merge initiE //= /#.
rewrite ifT 1:/#; apply (levels_frame _ _ 0 5 (fun t => t %/ 64 = i_)) => //.
- move=> k rgk; have : k = 0 \/ k = 1 \/ k = 2 \/ k = 3 \/ k = 4 by smt().
  by case=> [->|[->|[->|[->|->]]]]; rewrite /closed /=; split => u rgu hu ?; smt().
- by move=> u rgu /= hu; rewrite /m /merge initiE //= ifF 1:/#.
qed.

end FnttcorrectT.
