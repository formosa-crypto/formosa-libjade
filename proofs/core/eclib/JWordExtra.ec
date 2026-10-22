require import AllCore List IntDiv.
require import BitEncoding.
require import StdOrder.

import Ring.IntID.
import IntOrder.
import BS2Int.

from Jasmin require import JModel.

(* misc *)

lemma size_drop' ['a] (s: 'a list) n:
 size (drop n s) = max 0 (size s - max 0 n).
proof.
elim: s n => //=.
 smt().
move=> x xs IH n /=.
by case: (n <= 0) => C; smt(size_ge0).
qed.

lemma size_take' ['a] (s: 'a list) n:
 size (take n s) = min (max 0 n) (size s).
proof.
elim: s n => //=.
 smt().
move=> x xs IH n /=.
by case: (n <= 0) => C; smt(size_ge0).
qed.

(* add to JWord.ec *)

(* W16 *)

(*
lemma W16_to_sint_pos (w: W16.t):
 to_uint w < 2^(W16.size - 1) =>
 to_sint w = to_uint w.
proof.
rewrite to_sintE /smod /= => H.
by rewrite ifF 1:/#.
qed.
*)

lemma W16_get_ule (w: W16.t) k:
 w.[k] => 2^k <= W16.to_uint w.
proof.
rewrite get_to_uint => [[Hk H]].
smt(W16.to_uint_cmp gt0_pow2).
qed.

lemma W16_msbE (w: W16.t):
 msb w <=> w.[W16.size-1].
proof.
rewrite /msb; split; last by apply W16_get_ule.
rewrite get_to_uint => H.
have L0: 0 < to_uint w %/ 2^(W16.size-1).
 move: H; rewrite /=; smt(W16.to_uint_cmp).
have: to_uint w \in range (1 * 2^(W16.size-1)) ((1 + 1) * 2^(W16.size-1)).
 rewrite /range /= mem_iota; split => //=.
 by move: (W16.to_uint_cmp w) => /= /#.
by rewrite -eq_div_range // /#.
qed.

lemma W16_min_sintE:
 W16.of_int W16.min_sint
 = W16.zero.[W16.size-1 <- true].
proof.
rewrite to_uint_eq of_uintK /= to_uint_bits.
rewrite /bits /mkseq -iotaredE /=.
have:= bs2int_pow2 (W16.size-1) 0.
rewrite nseq0 /max -mkseq_nseq /mkseq -iotaredE /= /#.
qed.

lemma W16_msb_sar (w: W16.t) k:
 0 <= k =>
 msb (sar w k) = msb w.
proof.
move=> Hk.
by rewrite !W16_msbE /(`|>>>`) /sar /= /#.
qed.

lemma W16_msb_sign (w: W16.t):
 msb w <=> to_sint w < 0.
proof.
rewrite /msb to_sintE /smod.
by move: (W16.to_uint_cmp w); smt().
qed.

lemma W16_to_sint_neg (w: W16.t):
 msb w =>
 to_sint w  = to_uint w - W16.modulus.
proof.
rewrite /msb to_sintE /smod.
by move: (W16.to_uint_cmp w); smt().
qed.

lemma W16_to_sint_pos (w: W16.t):
 !msb w =>
 to_sint w  = to_uint w.
proof.
rewrite /msb to_sintE /smod.
by move: (W16.to_uint_cmp w); smt().
qed.

lemma W16_sar_pos (w: W16.t) k:
 0 <= k =>
 !msb w =>
 sar w k = w `>>>` k.
proof.
rewrite W16_msbE /= => Hk Hpos.
apply W16.ext_eq => i Hi.
rewrite /(`|>>>`) initiE //=.
rewrite /(`>>>`) Hi /=.
case: (W16.size-1 < (i + k)) => E.
 by rewrite lez_minl 1:/# eq_sym get_out /#.
by rewrite lez_minr 1:/#.
qed.

lemma W16_shl_onew k:
 0 < k =>
 W16.onew `>>>` k
 = W16.of_int (2^(max 0 (W16.size - k)) -1).
proof.
move => Hk.
apply W16.ext_eq => i Hi.
by rewrite /(`>>>`) initiE  //= /#.
qed.

lemma W16_sarE_neg (w: W16.t) k:
 0 <= k =>
 msb w =>
 sar w k 
 = (w `>>>` k) `|` invw (W16.onew `>>>` k).
proof.
rewrite W16_msbE /= => Hk Hmsb.
apply W16.ext_eq => i Hi.
rewrite /(`|>>>`) initiE //=.
rewrite /(`>>>`) !Hi //=.
have ->/=: 0 <= i + k by smt().
case: (i + k < W16.size) => C.
 by rewrite lez_minr 1:/#.
by rewrite lez_minl 1:/# Hmsb.
qed.

lemma W16_to_uint_sar_neg (w: W16.t) k:
 0 <= k =>
 msb w =>
 to_uint (sar w k)
 = W16.modulus + (to_sint w %/ 2^k).
proof.
move=> Hk Hmbs.
have [Hw0 Hw1]:= W16.to_uint_cmp w.
rewrite W16_sarE_neg // W16.to_uint_orw_disjoint.
 apply W16.ext_eq => i Hi.
 rewrite /(`>>`) /(`>>>`) /= !initiE Hi //=.
 have ->/=: 0 <= i + k by smt().
 case: (i + k < W16.size) => C //=.
 by rewrite get_out /#.
case: (k = 0) => Ek0.
 rewrite !Ek0 /= to_uint_shr 1:/#.
 rewrite to_uint_invw to_uint_shr 1:/#.
 by rewrite W16_to_sint_neg // to_uint_onew /#.
case: (W16.size <= k) => Eksz.
 rewrite to_uint_shr 1:/# divz_small /=.
  smt(ler_weexpn2l).
 have ->: to_sint w %/ 2 ^ k = -1.
  rewrite W16_to_sint_neg //.
  have ->: to_uint w - W16.modulus
           = - (W16.modulus - to_uint w) by ring.
  rewrite divNz.
    by rewrite subr_gt0; apply Hw1.
   smt(expr_gt0).
  rewrite divz_small //.
  apply bound_abs; split.
   rewrite /= in Hw1.
   by rewrite /= /#.
  move=> ?.
  apply (ltr_le_trans W16.modulus); first smt().
  by apply ler_weexpn2l => /#.
 rewrite to_uint_invw to_uint_shr 1:/# to_uint_onew divz_small //.
 apply bound_abs; split; first done.
 move=> ?; apply (ltr_le_trans W16.modulus); first smt().
 by apply ler_weexpn2l.
rewrite to_uint_shr; first smt(to_uint_cmp).
rewrite W16_shl_onew; first smt(to_uint_cmp).
rewrite lez_maxr 1:/# to_uint_invw.
rewrite of_uintK modz_small.
 apply bound_abs; split;1: by smt(expr_gt0).
 move => ?.
 have /=?: 2 ^ (W16.size - k) <= W16.modulus.
  by apply ler_weexpn2l => // /#.
 by rewrite /= /#.
have Hkk: W16.modulus = 2^(W16.size-k) * 2^k.
 rewrite -exprD_nneg // 1:/#.
 by rewrite -addzA /=.
have ->: W16.max_uint - (2 ^ (W16.size - k) - 1)
         = W16.modulus - W16.modulus %/ 2^k.
 rewrite {3}Hkk mulzK /#.
rewrite addzC -addzA; congr.
rewrite addzC W16_to_sint_neg //.
have ->: (to_uint w - W16.modulus)
 = to_uint w + (- 2^(W16.size-k)) * 2^k.
 by rewrite Hkk; ring.
rewrite divzMDr 1:/# addzC; congr.
have ->: W16.modulus = 2^(W16.size - k + k).
 by congr; smt().
congr.
by rewrite exprD_nneg 1:/# // /#.
qed.

lemma W16_sar_div (w1 : W16.t) k:
 0 <= k =>
 to_sint (sar w1 k)
 = to_sint w1 %/ 2 ^ k.
proof.
case: (msb w1) => Hk C.
 rewrite W16_to_sint_neg 1:W16_msb_sar //.
 by rewrite W16_to_uint_sar_neg //.
rewrite W16_to_sint_pos 1:W16_msb_sar //.
by rewrite W16_sar_pos // to_uint_shr /#.
qed.


(* W32 *)

lemma W32_get_ule (w: W32.t) k:
 w.[k] => 2^k <= W32.to_uint w.
proof.
rewrite get_to_uint => [[Hk H]].
smt(W32.to_uint_cmp gt0_pow2).
qed.

lemma W32_msbE (w: W32.t):
 msb w <=> w.[W32.size-1].
proof.
rewrite /msb; split; last by apply W32_get_ule.
rewrite get_to_uint => H.
have L0: 0 < to_uint w %/ 2^(W32.size-1).
 move: H; rewrite /=; smt(W32.to_uint_cmp).
have: to_uint w \in range (1 * 2^(W32.size-1)) ((1 + 1) * 2^(W32.size-1)).
 rewrite /range /= mem_iota; split => //=.
 by move: (W32.to_uint_cmp w) => /= /#.
by rewrite -eq_div_range // /#.
qed.

lemma W32_min_sintE:
 W32.of_int W32.min_sint
 = W32.zero.[W32.size-1 <- true].
proof.
rewrite to_uint_eq of_uintK /= to_uint_bits.
rewrite /bits /mkseq -iotaredE /=.
have:= bs2int_pow2 (W32.size-1) 0.
rewrite nseq0 /max -mkseq_nseq /mkseq -iotaredE /= /#.
qed.

lemma W32_msb_sar (w: W32.t) k:
 0 <= k =>
 msb (sar w k) = msb w.
proof.
move=> Hk.
by rewrite !W32_msbE /(`|>>>`) /sar /= /#.
qed.

lemma W32_msb_sign (w: W32.t):
 msb w <=> to_sint w < 0.
proof.
rewrite /msb to_sintE /smod.
by move: (W32.to_uint_cmp w); smt().
qed.

lemma W32_to_sint_neg (w: W32.t):
 msb w =>
 to_sint w  = to_uint w - W32.modulus.
proof.
rewrite /msb to_sintE /smod.
by move: (W32.to_uint_cmp w); smt().
qed.

lemma W32_to_sint_pos (w: W32.t):
 !msb w =>
 to_sint w  = to_uint w.
proof.
rewrite /msb to_sintE /smod.
by move: (W32.to_uint_cmp w); smt().
qed.

lemma W32_sar_pos (w: W32.t) k:
 0 <= k =>
 !msb w =>
 sar w k = w `>>>` k.
proof.
rewrite W32_msbE /= => Hk Hpos.
apply W32.ext_eq => i Hi.
rewrite /(`|>>>`) initiE //=.
rewrite /(`>>>`) Hi /=.
case: (W32.size-1 < (i + k)) => E.
 by rewrite lez_minl 1:/# eq_sym get_out /#.
by rewrite lez_minr 1:/#.
qed.

lemma W32_shl_onew k:
 0 < k =>
 W32.onew `>>>` k
 = W32.of_int (2^(max 0 (W32.size - k)) -1).
proof.
move => Hk.
apply W32.ext_eq => i Hi.
by rewrite /(`>>>`) initiE  //= /#.
qed.

lemma W32_sarE_neg (w: W32.t) k:
 0 <= k =>
 msb w =>
 sar w k 
 = (w `>>>` k) `|` invw (W32.onew `>>>` k).
proof.
rewrite W32_msbE /= => Hk Hmsb.
apply W32.ext_eq => i Hi.
rewrite /(`|>>>`) initiE //=.
rewrite /(`>>>`) !Hi //=.
have ->/=: 0 <= i + k by smt().
case: (i + k < W32.size) => C.
 by rewrite lez_minr 1:/#.
by rewrite lez_minl 1:/# Hmsb.
qed.

lemma W32_to_uint_sar_neg (w: W32.t) k:
 0 <= k =>
 msb w =>
 to_uint (sar w k)
 = W32.modulus + (to_sint w %/ 2^k).
proof.
move=> Hk Hmbs.
have [Hw0 Hw1]:= W32.to_uint_cmp w.
rewrite W32_sarE_neg // W32.to_uint_orw_disjoint.
 apply W32.ext_eq => i Hi.
 rewrite /(`>>`) /(`>>>`) /= !initiE Hi //=.
 have ->/=: 0 <= i + k by smt().
 case: (i + k < W32.size) => C //=.
 by rewrite get_out /#.
case: (k = 0) => Ek0.
 rewrite !Ek0 /= to_uint_shr 1:/#.
 rewrite to_uint_invw to_uint_shr 1:/#.
 by rewrite W32_to_sint_neg // to_uint_onew /#.
case: (W32.size <= k) => Eksz.
 rewrite to_uint_shr 1:/# divz_small /=.
  smt(ler_weexpn2l).
 have ->: to_sint w %/ 2 ^ k = -1.
  rewrite W32_to_sint_neg //.
  have ->: to_uint w - W32.modulus
           = - (W32.modulus - to_uint w) by ring.
  rewrite divNz.
    by rewrite subr_gt0; apply Hw1.
   smt(expr_gt0).
  rewrite divz_small //.
  apply bound_abs; split.
   rewrite /= in Hw1.
   by rewrite /= /#.
  move=> ?.
  apply (ltr_le_trans W32.modulus); first smt().
  by apply ler_weexpn2l => /#.
 rewrite to_uint_invw to_uint_shr 1:/# to_uint_onew divz_small //.
 apply bound_abs; split; first done.
 move=> ?; apply (ltr_le_trans W32.modulus); first smt().
 by apply ler_weexpn2l.
rewrite to_uint_shr; first smt(to_uint_cmp).
rewrite W32_shl_onew; first smt(to_uint_cmp).
rewrite lez_maxr 1:/# to_uint_invw.
rewrite of_uintK modz_small.
 apply bound_abs; split;1:smt(expr_gt0). 
 move => ?.
 have /=?: 2 ^ (W32.size - k) <= W32.modulus.
  by apply ler_weexpn2l => // /#.
 by rewrite /= /#.
have Hkk: W32.modulus = 2^(W32.size-k) * 2^k.
 rewrite -exprD_nneg // 1:/#.
 by rewrite -addzA /=.
have ->: W32.max_uint - (2 ^ (W32.size - k) - 1)
         = W32.modulus - W32.modulus %/ 2^k.
 rewrite {3}Hkk mulzK /#.
rewrite addzC -addzA; congr.
rewrite addzC W32_to_sint_neg //.
have ->: (to_uint w - W32.modulus)
 = to_uint w + (- 2^(W32.size-k)) * 2^k.
 by rewrite Hkk; ring.
rewrite divzMDr 1:/# addzC; congr.
have ->: W32.modulus = 2^(W32.size - k + k).
 by congr; smt().
by rewrite exprD_nneg 1:/# // /#.
qed.

lemma W32_sar_div (w1 : W32.t) k:
 0 <= k =>
 to_sint (sar w1 k)
 = to_sint w1 %/ 2 ^ k.
proof.
case: (msb w1) => Hk C.
 rewrite W32_to_sint_neg 1:W32_msb_sar //.
 by rewrite W32_to_uint_sar_neg //.
rewrite W32_to_sint_pos 1:W32_msb_sar //.
by rewrite W32_sar_pos // to_uint_shr /#.
qed.

(* ==================================================================== *)
(* Circuit-bindings machinery (ported from mldsa JWordExtra.ec).        *)
(* `WE` is the parametric word-extras theory consumed by CircuitBindings *)
(* (BSBW clones it for each word size).                                  *)
(* ==================================================================== *)

(* -------------------------------------------------------------------- *)
lemma w2bits_int2bsE (w : W32.t) : w2bits w = BS2Int.int2bs 32 (W32.to_uint w).
proof. rewrite to_uintE; smt(W32.size_w2bits BS2Int.bs2intK). qed.

(* -------------------------------------------------------------------- *)
lemma lzcnt_decomp (l : bool list) : true \in l =>
  l = nseq (lzcnt l) false ++ true :: drop (lzcnt l + 1) l.
proof.
elim: l => //= b l ih; case: b => /= [_ | hl].
+ by rewrite nseq0 drop0.
move=> hl'; have h0 := lzcnt_size l; rewrite ifF 1:/# addzC nseqS 1:/# /=.
by rewrite -ih.
qed.

(* -------------------------------------------------------------------- *)
abstract theory WE.
  op size : int.

  clone import BitWord as W with op size <- size.

  lemma msbE (w : t): msb w <=> w.[size - 1].
  proof.
  have ? := gt0_size; rewrite /msb /to_uint /w2bits.
  rewrite (mkseqS _ (size - 1)) 1:/# bs2int_rcons /=.
  pose s := mkseq _ _; have := bs2int_le2Xs s.
  rewrite size_mkseq lez_maxr 1:/#; case: w.[_] => /= ?.
  - by rewrite lez_addr bs2int_ge0.
  - by rewrite lezNgt.
  qed.

  lemma to_uintUD (w1 w2: W.t) : to_uint w2 <> 0 =>
    to_uint (w1 \udiv w2) = to_uint w1 %/ to_uint w2.
  proof. move=> @/(\udiv) @/ulift2; smt(to_uint_cmp to_uint_small). qed.

  lemma to_uintUM (w1 w2: W.t) :
    to_uint (w1 \umod w2) = to_uint w1 %% to_uint w2.
  proof.
  rewrite /(\umod) /ulift2; apply to_uint_small.
  smt(to_uint_cmp to_uint_small JUtils.modz_cmp modz0).
  qed.

  lemma set_get (w : W.t) (i : int) : w.[i <- w.[i]] = w.
  proof. by apply/ext_eq=> j ?; rewrite get_set_if /#. qed.

  lemma sarwE (w : W.t) (i j : int) :
    (w `|>>>` i).[j] = (0 <= j < size && w.[min (size - 1) (j + i)]).
  proof. by rewrite sarE initE. qed.

  lemma sar0 (w : W.t) : w `|>>>` 0 = w.
  proof. by apply/ext_eq=> i ?; rewrite sarwE /#. qed.

  lemma sarD (w : W.t) (i j : int) :
    0 <= i => 0 <= j => w `|>>>` (i + j) = (w `|>>>` i) `|>>>` j.
  proof. by move=> *; apply/ext_eq=> k ?; rewrite !sarwE /= /#. qed.

  lemma sarSl (w : W.t) (i : int) :
    0 <= i => w `|>>>` (i + 1) = (w `|>>>` i) `|>>>` 1.
  proof. by move=> *; rewrite sarD. qed.

  lemma sarSr (w : W.t) (i : int) :
    0 <= i => w `|>>>` (i + 1) = (w `|>>>` 1) `|>>>` i.
  proof. by move=> *; rewrite addzC sarD. qed.

  lemma shr0 (w : W.t) : w `>>>` 0 = w.
  proof. by apply/ext_eq=> i ?; rewrite shrwE /#. qed.

  lemma shrD (w : W.t) (i j : int) :
    0 <= i => 0 <= j => w `>>>` (i + j) = (w `>>>` i) `>>>` j.
  proof.
  move=> *; apply/ext_eq=> k ?.
  by rewrite !shrwE /= #smt:(get_out).
  qed.

  lemma shrSl (w : W.t) (i : int) :
    0 <= i => w `>>>` (i + 1) = (w `>>>` i) `>>>` 1.
  proof. by move=> *; rewrite shrD. qed.

  lemma shrSr (w : W.t) (i : int) :
    0 <= i => w `>>>` (i + 1) = (w `>>>` 1) `>>>` i.
  proof. by move=> *; rewrite addzC shrD. qed.

  lemma sar1_shrE (w : W.t) :
    w `|>>>` 1 = (w `>>>` 1).[size - 1 <- msb w].
  proof.
  apply/ext_eq=> i rgi.
  by rewrite msbE sarE get_setE 1:/# !initE /#.
  qed.

  lemma to_uint_sar1 (w : W.t) :
    to_uint (w `|>>>` 1) = to_uint w %/ 2 + (2^(size - 1)) * b2i (msb w).
  proof.
  have ? := gt0_size; rewrite sar1_shrE {1}/W.to_uint.
  rewrite /w2bits (mkseqS _ (size - 1)) 1:/# /=.
  rewrite set_eqiE ~-1://# -(eq_in_mkseq ("_.[_]" (w `>>>` 1))).
  - by move=> i ?; rewrite get_set_if ifF //#.
  rewrite bs2int_rcons /= size_mkseq lez_maxr 1:/#; congr.
  pose s := mkseq _ _; rewrite (_ : bs2int s = bs2int (rcons s false)).
  - by rewrite bs2int_rcons.
  rewrite (_ : false = msb (w `>>>` 1)).
  - by rewrite msbE shrwE /= get_out.
  rewrite msbE /s -mkseqS 1:/# /= -/(W.w2bits (w `>>>` 1)).
  by rewrite -to_uintE to_uint_shr.
  qed.

  lemma to_sint_sar1 (w : W.t) :
    to_sint (w `|>>>` 1) = to_sint w %/ 2.
  proof.
  have ? := gt0_size; have ? := to_uint_cmp.
  rewrite !to_sintE to_uint_sar1; case _: (W.msb _) => /=; last first.
  - move/ltzNge=> ?; rewrite /smod !ifF // lezNgt //=.
    by rewrite b2i0 /= ltz_divLR //#.
  move=> @/msb ?; rewrite {1}/W.smod ifT 1:/#.
  rewrite /smod ifT // -addrA (_ : _ - _ = -2^(size - 1)).
  - by rewrite (Ring.IntID.exprS _ (size - 1)) ~-1:/# #ring.
  rewrite divzDr /=; first by rewrite dvdzN (dvdz_exp2l 2 1) /#.
  rewrite divNz // divzDl 1:(dvdz_exp2l 2 1) ~-1://# /=.
  by rewrite -half_modulus.
  qed.

  lemma to_sint_sar (w : W.t) (i : int) : 0 <= i =>
    to_sint (w `|>>>` i) = to_sint w %/ 2^i.
  proof.
  have ? := gt0_size; have ? := to_uint_cmp.
  elim: i => /= [|n ge0_n ih]; first by rewrite sar0.
  rewrite sarSl // to_sint_sar1 ih.
  rewrite -divz_mulp ~-1:// 1:IntOrder.expr_gt0 ~-1://.
  by rewrite -Ring.IntID.exprSr.
  qed.

  (* ------------------------------------------------------------------ *)
  (* The lowest set bit of a word (TZCNT) and its clearing (BLSR:       *)
  (* w & (w - 1)).                                                       *)
  op lowbit (w : W.t) : int = lzcnt (w2bits w).

  lemma lowbit_in (w : W.t) : w <> W.zero => true \in w2bits w.
  proof.
  move=> hw; case: (true \in w2bits w) => // hn; apply hw; apply W.wordP => q hq.
  have := mem_nth false (w2bits w) q; rewrite W.size_w2bits hq W.get_w2bits /=.
  by case: (w.[q]) => // _ /hn.
  qed.

  lemma lowbitP (w : W.t) : w <> W.zero =>
    0 <= lowbit w < size /\ w.[lowbit w] /\ forall q, q < lowbit w => !w.[q].
  proof.
  move=> /lowbit_in hin; have e := lzcnt_decomp _ hin.
  have hs := lzcnt_size (w2bits w); rewrite /lowbit.
  pose p := lzcnt (w2bits w); pose r := drop (p + 1) (w2bits w).
  have hsz : size (w2bits w) = p + 1 + size r by rewrite {1}e size_cat size_nseq /#.
  have hp : 0 <= p < size by smt(W.size_w2bits size_ge0).
  rewrite hp /=; split.
  + by rewrite -W.get_w2bits e nth_cat size_nseq ifF 1:/# /= /#.
  move=> q hq; rewrite -W.get_w2bits e nth_cat size_nseq.
  by case: (q < max 0 p) => h; [rewrite nth_nseq_if | ]; smt().
  qed.

  lemma tzcntE (w : W.t) : to_uint (W.ALU.TZCNT_XX w).`6 = lowbit w.
  proof.
  have := lzcnt_size (w2bits w); rewrite W.size_w2bits => hs.
  have hlt : forall n, 0 <= n => n < 2 ^ n.
  + by elim => // n hn ih; rewrite exprS //; smt().
  by rewrite /TZCNT_XX /= W.of_uintK /lowbit modz_small; smt(W.gt0_size).
  qed.

  lemma blsrE (w : W.t) (q : int) : w <> W.zero =>
    (w `&` (w - W.one)).[q] = (w.[q] /\ q <> lowbit w).
  proof.
  move=> hw; have e := lzcnt_decomp _ (lowbit_in _ hw).
  have := lowbitP _ hw; rewrite /lowbit.
  pose p := lzcnt (w2bits w); pose r := drop (p + 1) (w2bits w).
  move=> [hp _].
  have hsz : size r = size - 1 - p by rewrite /r size_drop 1:/# W.size_w2bits /#.
  have hm : w - W.one = W.bits2w (nseq p true ++ false :: r).
  + rewrite W.to_uint_eq W.to_uintB.
    + by rewrite W.uleE W.to_uint1; smt(W.to_uint_eq W.to_uint0 W.to_uint_cmp).
    rewrite W.to_uint1 !W.to_uintE W.bits2wK 1:size_cat 1:size_nseq 1:/#.
    rewrite e !bs2int_cat !bs2int_nseq /= !size_nseq !bs2int_cons /b2i /=.
    by rewrite -/p -/r ifT 1:/# (_ : max 0 p = p) 1:/#; ring.
  rewrite W.andwE hm.
  case: (0 <= q < size) => hq; last by rewrite W.get_out.
  rewrite W.get_bits2w // -W.get_w2bits e !nth_cat !size_nseq.
  case: (q < max 0 p) => h; 1: by rewrite !nth_nseq_if /#.
  by case: (q - max 0 p = 0) => h1 /#.
  qed.

  lemma blsr_lt (w : W.t) : w <> W.zero =>
    to_uint (w `&` (w - W.one)) < to_uint w.
  proof.
  move=> hw; have h1 : 1 <= to_uint w by smt(W.to_uint_eq W.to_uint0 W.to_uint_cmp).
  have := W.to_uint_ule_andw (w - W.one) w.
  by rewrite W.andwC W.to_uintB 1:W.uleE 1:W.to_uint1 // W.to_uint1 /#.
  qed.
end WE.

(* -------------------------------------------------------------------- *)
clone WE as WE8 with
  op     size <- 8,
  theory W    <- W8 { rename "_XX" as "_8" }.

(* -------------------------------------------------------------------- *)
clone WE as WE16 with
  op     size <- 16,
  theory W    <- W16 { rename "_XX" as "_16" } .

(* -------------------------------------------------------------------- *)
clone WE as WE32 with
  op     size <- 32,
  theory W    <- W32 { rename "_XX" as "_32" } .

(* -------------------------------------------------------------------- *)
clone WE as WE64 with
  op     size <- 64,
  theory W    <- W64 { rename "_XX" as "_64" } .

(* -------------------------------------------------------------------- *)
clone WE as WE128 with
  op     size <- 128,
  theory W    <- W128 { rename "_XX" as "_128" } .

(* -------------------------------------------------------------------- *)
clone WE as WE256 with
  op     size <- 256,
  theory W    <- W256 { rename "_XX" as "_256" } .

(* -------------------------------------------------------------------- *)
(* the uniform distribution on words of any size                        *)
require import Distr.

abstract theory DWord.
  op size : { int | 0 < size } as gt0_size.
  clone import BitWord as W with op size <- size proof gt0_size by exact gt0_size.

  lemma mu1_dword (w : W.t) : mu1 W.dword w = 1%r / W.modulus%r.
  proof.
  rewrite /W.dword duniform1E W.all_wordsP /= W.all_wordsE undup_id.
  + apply map_inj_in_uniq; 2: by apply iota_uniq.
    move=> a b; rewrite !mema_iota => ha hb /(congr1 W.to_uint).
    by rewrite !W.to_uintK_small.
  by rewrite size_map size_iota StdOrder.IntOrder.ler_maxr // StdOrder.IntOrder.ltrW W.gt0_modulus.
  qed.
end DWord.

clone DWord as DW8 with op size <- 8, theory W <- W8 { rename "_XX" as "_8" }
  proof gt0_size by done.
