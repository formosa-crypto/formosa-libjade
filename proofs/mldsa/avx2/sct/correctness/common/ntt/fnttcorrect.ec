(**
  Correctness of the AVX2 forward NTT (`polynomial__ntt`).

  The Cooley-Tukey butterflies on registers, then the two calls that
  keep the coefficients in registers (levels 7 to 5 on a column of
  registers, levels 4 to 0 on a block of 64 coefficients), composed by
  the locality of the levels (`Nttvec`).
*)
require import AllCore CoreUtils List Ring IntDiv BitEncoding.
require import StdRing StdOrder.
from Jasmin require import JWord JArray.
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
type wpoly = W32.t Array256.t.

(* ==================================================================== *)
(* Butterflies                                                          *)
(* ==================================================================== *)
(* levels 7 to 3: one register against another *)
lemma ct_butterflyP (p : wpoly) (k j r o o2 : int) :
     0 <= k < 8 => 0 <= j < 2^(7-k) => 0 <= r => r + 8 <= 2^k
  => o = j * 2^(k+1) + r => o2 = o + 2^k
  => hoare[M.polynomial____ct_butterfly :
          a = vec p o /\ b = vec p o2 /\ zetas = W8u32.pack8 (nseq 8 (zj k j))
       ==> res = (vec (reduce_level p k) o, vec (reduce_level p k) o2)].
proof.
hint +listred.
move=> 5? o2E; proc; wp; ecall (mmrP b zetas); auto => &hr [#] -> -> -> ? ->.
by rewrite o2E (vec_lo p k j r o) // (vec_hi p k j r o) // /vec /=.
qed.

(* level 2: the two halves of each register *)
lemma ct_butterfly_8P (p : wpoly) (jb jb2 o o2 : int) :
  0 <= jb => jb2 = jb + 1 => o = jb * 8 => o2 = o + 8 => o2 + 8 <= 256 =>
  hoare[M.polynomial____ct_butterfly_8 :
       lhs = vec p o /\ rhs = vec p o2
    /\ zetas = W2u128.pack2 [W4u32.pack4 (nseq 4 (zj 2 jb)); W4u32.pack4 (nseq 4 (zj 2 jb2))]
    ==> res = (vec (reduce_level p 2) o, vec (reduce_level p 2) o2)].
proof.
hint +listred.
move=> 5?; proc; wp; ecall (mmrP zeta_products zetas); auto => &hr [#] -> -> -> /= ? ->.
by rewrite (vec_small p 2 jb o) 1..4:/# (vec_small p 2 jb2 o2) 1..4:/# /vec /=.
qed.

(* level 1: the 64-bit quarters *)
lemma ct_butterfly_4P (p : wpoly) (jb jb2 o o2 : int) :
  0 <= jb => jb2 = jb + 2 => o = jb * 4 => o2 = o + 8 => o2 + 8 <= 256 =>
  hoare[M.polynomial____ct_butterfly_4 :
       lhs = vec p o /\ rhs = vec p o2
    /\ zetas = W4u64.pack4 [
         W2u32.pack2 (nseq 2 (zj 1 jb)); W2u32.pack2 (nseq 2 (zj 1 jb2));
         W2u32.pack2 (nseq 2 (zj 1 (jb + 1))); W2u32.pack2 (nseq 2 (zj 1 (jb2 + 1)))]
    ==> res = (vec (reduce_level p 1) o, vec (reduce_level p 1) o2)].
proof.
hint +listred.
move=> 5?; proc; wp; ecall (mmrP zeta_products zetas); auto => &hr [#] -> -> -> /= ? ->.
by rewrite (vec_small p 1 jb o) 1..4:/# (vec_small p 1 jb2 o2) 1..4:/# /vec /=.
qed.

(* level 0: adjacent coefficients, paired by VPSHUFD around level 1 *)
lemma ct_butterfly_2P (p : wpoly) (jb jb2 o o2 : int) :
  0 <= jb => jb2 = jb + 4 => o = jb * 2 => o2 = o + 8 => o2 + 8 <= 256 =>
  hoare[M.polynomial____ct_butterfly_2 :
       lhs = vec p o /\ rhs = vec p o2
    /\ zetas = W8u32.pack8 [
         zj 0 jb; zj 0 (jb + 1); zj 0 jb2; zj 0 (jb2 + 1);
         zj 0 (jb + 2); zj 0 (jb + 3); zj 0 (jb2 + 2); zj 0 (jb2 + 3)]
    ==> res = (vec (reduce_level p 0) o, vec (reduce_level p 0) o2)].
proof.
hint +listred.
move=> 5?; proc; inline M.polynomial____ct_butterfly_4; wp.
ecall (mmrP zeta_products zetas0); auto => &hr [#] -> -> -> /= ? ->.
by rewrite (vec_small p 0 jb o) 1..4:/# (vec_small p 0 jb2 o2) 1..4:/# /vec /=.
qed.

(* ==================================================================== *)
(* Levels 4 to 0, on the block g of 64 coefficients                     *)
(* ==================================================================== *)
lemma ntt_layers_4_to_0P (p : wpoly) (g_ : int) : 0 <= g_ < 4 =>
  hoare[M.polynomial____ntt_layers_4_to_0 :
    arg = (p, g_) ==> res = merge (fun t => t %/ 64 = g_) p (levels p 0 5)].
proof.
move=> rgg; proc.
seq 8 : (polynomial = p /\ g = g_ /\ blk p g_ r0 r1 r2 r3 r4 r5 r6 r7).
- auto => />.
  by rewrite (get256_vecE p _ (64 * g_)) 1,2:/# !(get256_blkE p g_).
pose p4 := reduce_level p 4.
seq 6 : (polynomial = p /\ g = g_ /\ blk p4 g_ r0 r1 r2 r3 r4 r5 r6 r7).
- ecall (ct_butterflyP p 4 (2 * g_ + 1) 8 (64 * g_ + 40) (64 * g_ + 56) _ _ _ _ _ _); 2..7: smt().
  ecall (ct_butterflyP p 4 (2 * g_ + 1) 0 (64 * g_ + 32) (64 * g_ + 48) _ _ _ _ _ _); 2..7: smt().
  wp; ecall (ct_butterflyP p 4 (2 * g_) 8 (64 * g_ + 8) (64 * g_ + 24) _ _ _ _ _ _); 2..7: smt().
  ecall (ct_butterflyP p 4 (2 * g_) 0 (64 * g_ + 0) (64 * g_ + 16) _ _ _ _ _ _); 2..7: smt().
  by auto => />; rewrite !zetas4E 1..2:/#.
pose p3 := reduce_level p4 3.
seq 8 : (polynomial = p /\ g = g_ /\ blk p3 g_ r0 r1 r2 r3 r4 r5 r6 r7).
- ecall (ct_butterflyP p4 3 (4 * g_ + 3) 0 (64 * g_ + 48) (64 * g_ + 56) _ _ _ _ _ _); 2..7: smt().
  wp; ecall (ct_butterflyP p4 3 (4 * g_ + 2) 0 (64 * g_ + 32) (64 * g_ + 40)
        _ _ _ _ _ _); 2..7: smt().
  wp; ecall (ct_butterflyP p4 3 (4 * g_ + 1) 0 (64 * g_ + 16) (64 * g_ + 24)
        _ _ _ _ _ _); 2..7: smt().
  wp; ecall (ct_butterflyP p4 3 (4 * g_) 0 (64 * g_) (64 * g_ + 8) _ _ _ _ _ _); 2..7: smt().
  by auto => />; rewrite !zetas3E 1..4:/#.
pose p2 := reduce_level p3 2.
seq 8 : (polynomial = p /\ g = g_ /\ blk p2 g_ r0 r1 r2 r3 r4 r5 r6 r7).
- ecall (ct_butterfly_8P p3 (8 * g_ + 6) (8 * g_ + 7) (64 * g_ + 48) (64 * g_ + 56)
    _ _ _ _ _); 2..6: smt().
  wp; ecall (ct_butterfly_8P p3 (8 * g_ + 4) (8 * g_ + 5) (64 * g_ + 32) (64 * g_ + 40)
        _ _ _ _ _); 2..6: smt().
  wp; ecall (ct_butterfly_8P p3 (8 * g_ + 2) (8 * g_ + 3) (64 * g_ + 16) (64 * g_ + 24)
        _ _ _ _ _); 2..6: smt().
  wp; ecall (ct_butterfly_8P p3 (8 * g_) (8 * g_ + 1) (64 * g_) (64 * g_ + 8)
        _ _ _ _ _); 2..6: smt().
  auto => />.
  rewrite (zetas2E (4 * g_) (8 * g_) (8 * g_ + 1)) 1..3:/#.
  rewrite (zetas2E (4 * g_ + 1) (8 * g_ + 2) (8 * g_ + 3)) 1..3:/#.
  rewrite (zetas2E (4 * g_ + 2) (8 * g_ + 4) (8 * g_ + 5)) 1..3:/#.
  by rewrite (zetas2E (4 * g_ + 3) (8 * g_ + 6) (8 * g_ + 7)) 1..3:/#.
pose p1 := reduce_level p2 1.
seq 8 : (polynomial = p /\ g = g_ /\ blk p1 g_ r0 r1 r2 r3 r4 r5 r6 r7).
- ecall (ct_butterfly_4P p2 (16 * g_ + 12) (16 * g_ + 14) (64 * g_ + 48) (64 * g_ + 56)
    _ _ _ _ _); 2..6: smt().
  wp; ecall (ct_butterfly_4P p2 (16 * g_ + 8) (16 * g_ + 10) (64 * g_ + 32) (64 * g_ + 40)
        _ _ _ _ _); 2..6: smt().
  wp; ecall (ct_butterfly_4P p2 (16 * g_ + 4) (16 * g_ + 6) (64 * g_ + 16) (64 * g_ + 24)
        _ _ _ _ _); 2..6: smt().
  wp; ecall (ct_butterfly_4P p2 (16 * g_) (16 * g_ + 2) (64 * g_) (64 * g_ + 8)
        _ _ _ _ _); 2..6: smt().
  auto => />.
  rewrite (zetas1E (4 * g_) (16 * g_) (16 * g_ + 2)) 1..3:/#.
  rewrite (zetas1E (4 * g_ + 1) (16 * g_ + 4) (16 * g_ + 6)) 1..3:/#.
  rewrite (zetas1E (4 * g_ + 2) (16 * g_ + 8) (16 * g_ + 10)) 1..3:/#.
  by rewrite (zetas1E (4 * g_ + 3) (16 * g_ + 12) (16 * g_ + 14)) 1..3:/#.
pose p0 := reduce_level p1 0.
seq 8 : (polynomial = p /\ g = g_ /\ blk p0 g_ r0 r1 r2 r3 r4 r5 r6 r7).
- ecall (ct_butterfly_2P p1 (32 * g_ + 24) (32 * g_ + 28) (64 * g_ + 48) (64 * g_ + 56)
    _ _ _ _ _); 2..6: smt().
  wp; ecall (ct_butterfly_2P p1 (32 * g_ + 16) (32 * g_ + 20) (64 * g_ + 32) (64 * g_ + 40)
        _ _ _ _ _); 2..6: smt().
  wp; ecall (ct_butterfly_2P p1 (32 * g_ + 8) (32 * g_ + 12) (64 * g_ + 16) (64 * g_ + 24)
        _ _ _ _ _); 2..6: smt().
  wp; ecall (ct_butterfly_2P p1 (32 * g_) (32 * g_ + 4) (64 * g_) (64 * g_ + 8)
        _ _ _ _ _); 2..6: smt().
  auto => />.
  rewrite (zetas0E (4 * g_) (32 * g_) (32 * g_ + 4)) 1..3:/#.
  rewrite (zetas0E (4 * g_ + 1) (32 * g_ + 8) (32 * g_ + 12)) 1..3:/#.
  rewrite (zetas0E (4 * g_ + 2) (32 * g_ + 16) (32 * g_ + 20)) 1..3:/#.
  by rewrite (zetas0E (4 * g_ + 3) (32 * g_ + 24) (32 * g_ + 28)) 1..3:/#.
by auto => />; rewrite store_blkE // levels0_5E.
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
seq 8 : (polynomial = p /\ j = j_ /\ col p j_ r0 r1 r2 r3 r4 r5 r6 r7).
- auto => />.
  by rewrite (get256_vecE p _ (8 * j_)) 1,2:/# !(get256_colE p j_).
pose p7 := reduce_level p 7.
seq 7 : (polynomial = p /\ j = j_ /\ col p7 j_ r0 r1 r2 r3 r4 r5 r6 r7).
- ecall (ct_butterflyP p 7 0 (8 * j_ + 96) (8 * j_ + 96) (8 * j_ + 224) _ _ _ _ _ _); 2..7: smt().
  ecall (ct_butterflyP p 7 0 (8 * j_ + 64) (8 * j_ + 64) (8 * j_ + 192) _ _ _ _ _ _); 2..7: smt().
  ecall (ct_butterflyP p 7 0 (8 * j_ + 32) (8 * j_ + 32) (8 * j_ + 160) _ _ _ _ _ _); 2..7: smt().
  ecall (ct_butterflyP p 7 0 (8 * j_) (8 * j_) (8 * j_ + 128) _ _ _ _ _ _); 2..7: smt().
  by auto => />; rewrite zj7E.
pose p6 := reduce_level p7 6.
seq 10 : (polynomial = p /\ j = j_ /\ col p6 j_ r0 r1 r2 r3 r4 r5 r6 r7).
- ecall (ct_butterflyP p7 6 1 (8 * j_ + 32) (8 * j_ + 160) (8 * j_ + 224) _ _ _ _ _ _); 2..7: smt().
  ecall (ct_butterflyP p7 6 1 (8 * j_) (8 * j_ + 128) (8 * j_ + 192) _ _ _ _ _ _); 2..7: smt().
  wp; ecall (ct_butterflyP p7 6 0 (8 * j_ + 32) (8 * j_ + 32) (8 * j_ + 96)
        _ _ _ _ _ _); 2..7: smt().
  ecall (ct_butterflyP p7 6 0 (8 * j_) (8 * j_) (8 * j_ + 64) _ _ _ _ _ _); 2..7: smt().
  by auto => />; rewrite !zj6E.
pose p5 := reduce_level p6 5.
seq 8 : (polynomial = p /\ j = j_ /\ col p5 j_ r0 r1 r2 r3 r4 r5 r6 r7).
- ecall (ct_butterflyP p6 5 3 (8 * j_) (8 * j_ + 192) (8 * j_ + 224) _ _ _ _ _ _); 2..7: smt().
  wp; ecall (ct_butterflyP p6 5 2 (8 * j_) (8 * j_ + 128) (8 * j_ + 160) _ _ _ _ _ _); 2..7: smt().
  wp; ecall (ct_butterflyP p6 5 1 (8 * j_) (8 * j_ + 64) (8 * j_ + 96) _ _ _ _ _ _); 2..7: smt().
  wp; ecall (ct_butterflyP p6 5 0 (8 * j_) (8 * j_) (8 * j_ + 32) _ _ _ _ _ _); 2..7: smt().
  wp; skip.
  (* the table, before simplification evaluates its constant indices *)
  by rewrite !zetas5E.
by auto => />; rewrite store_colE // levels5_8E.
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
  - auto => />; split; first by rewrite merge_none 1:/#.
    by move=> i ? 2?; rewrite merge_all 1:/#.
  exlim polynomial, i => p i_.
  case@[ambient]: (0 <= i_ < 4) => rgi; last first.
  - by conseq (_ : false ==> _); [smt() | exfalso].
  wp; call (ntt_layers_7_6_5P p i_ rgi); auto => /> 3?; split; 1: smt().
  apply (merge_step (fun t => t %/ 8 %% 4) (fun p => levels p 5 8)) => p' /= hag.
  by apply (levels_frame _ _ 5 8) => // k rgk; apply closed_col.
(* levels 4 to 0, block by block *)
while (0 <= i <= 4 /\ polynomial = merge (fun t => t %/ 64 < i) R (levels R 0 5)); last first.
- auto => />; split; first by rewrite merge_none 1:/#.
  move=> i ? 2?; rewrite merge_all 1:/# /R levels0_5E levels5_8E.
  by rewrite /reduce_tree /range /= -iotaredE.
exlim polynomial, i => p i_.
case@[ambient]: (0 <= i_ < 4) => rgi; last first.
- by conseq (_ : false ==> _); [smt() | exfalso].
wp; call (ntt_layers_4_to_0P p i_ rgi); auto => /> 3?; split; 1: smt().
apply (merge_step (fun t => t %/ 64) (fun p => levels p 0 5)) => p' /= hag.
by apply (levels_frame _ _ 0 5) => // k rgk; apply closed_blk.
qed.

end FnttcorrectT.
