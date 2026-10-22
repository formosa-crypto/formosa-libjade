(* -------------------------------------------------------------------- *)
(* Lane-wise facts on the AVX2 instructions of JModel_x86.              *)
(* -------------------------------------------------------------------- *)
require import AllCore List IntDiv.
from Jasmin require import JModel_x86.
require import JWordExtra.

(* -------------------------------------------------------------------- *)
(* Packing with signed saturation (VPACKSS), then VPERMQ                *)
(* -------------------------------------------------------------------- *)

(* the signed saturation of VPACKSS *)
op sat16 (x : W32.t) : W16.t =
  if x \slt W32.of_int W16.min_sint then W16.of_int W16.min_sint
  else if W32.of_int W16.max_sint \sle x then W16.of_int W16.max_sint
  else x \bits16 0.

lemma sat16E (x : W32.t) : -32768 <= W32.to_sint x <= 32767 =>
  W16.to_sint (sat16 x) = W32.to_sint x.
proof.
move=> hx; rewrite /sat16 /(\slt) /(\sle) !W32.of_sintK /= /smod /=.
rewrite ifF 1:/#.
case: (32767 <= to_sint x) => h; 1: by rewrite W16.of_sintK /smod /= /#.
rewrite W2u16.bits16_div // /= W16.of_sintK /smod /=.
move: hx h; rewrite W32.to_sintE /smod /=.
by have := W32.to_uint_cmp x; smt().
qed.

lemma packss_bits16 (a : W128.t) (j : int) : 0 <= j < 4 =>
  packss_4u32 a \bits16 j = sat16 (a \bits32 j).
proof.
move=> hj; rewrite /packss_4u32.
have : j = 0 \/ j = 1 \/ j = 2 \/ j = 3 by smt().
by move=> [|[|[|]]] -> /=; rewrite /sat16 -bits16_32 /=.
qed.

lemma packss8_bits16 (w1 w2 : W256.t) (k : int) : 0 <= k < 16 =>
  VPACKSS_8u32 w1 w2 \bits16 k =
  sat16 ((if k %% 8 < 4 then w1 else w2) \bits32 (4 * (k %/ 8) + k %% 4)).
proof.
move=> hk; rewrite bits16_128 // /VPACKSS_8u32 W2u128.map2bE 1:/# /VPACKSS_4u32.
rewrite bits16_W2u64 (_ : 0 <= k %% 8 < 8) 1:/# /=.
case: (k %% 8 < 4) => h.
+ rewrite (_ : k %% 8 %/ 4 = 0) 1:/# /= packss_bits16 1:/# bits32_128 1:/#.
  by congr; congr; smt().
rewrite (_ : k %% 8 %/ 4 = 1) 1:/# /= packss_bits16 1:/# bits32_128 1:/#.
by congr; congr; smt().
qed.

lemma VPERMQ_216E (w : W256.t) :
  VPERMQ w (W8.of_int 216) = W4u64.pack4 [w \bits64 0; w \bits64 2; w \bits64 1; w \bits64 3].
proof.
by rewrite /VPERMQ /=.
qed.

(* the lanes of the packed polynomial: VPACKSS then VPERMQ 0xD8 *)
lemma packss_permq_bits16 (w1 w2 : W256.t) (k : int) : 0 <= k < 16 =>
  VPERMQ (VPACKSS_8u32 w1 w2) (W8.of_int 216) \bits16 k =
  sat16 (if k < 8 then w1 \bits32 k else w2 \bits32 (k - 8)).
proof.
move=> hk; rewrite VPERMQ_216E.
have : k = 0 \/ k = 1 \/ k = 2 \/ k = 3 \/ k = 4 \/ k = 5 \/ k = 6 \/ k = 7 \/
       k = 8 \/ k = 9 \/ k = 10 \/ k = 11 \/ k = 12 \/ k = 13 \/ k = 14 \/ k = 15 by smt().
by move=> [|[|[|[|[|[|[|[|[|[|[|[|[|[|[|]]]]]]]]]]]]]]] -> /=; rewrite packss8_bits16.
qed.

(* -------------------------------------------------------------------- *)
(* Extraction and sign extension of a half                              *)
(* -------------------------------------------------------------------- *)

lemma truncateu128_bits128 (w : W256.t) : truncateu128 w = w \bits128 0.
proof. by rewrite /truncateu128 W2u128.bits128_div. qed.

lemma VEXTRACTI128_1 (w : W256.t) : VEXTRACTI128 w (W8.of_int 1) = w \bits128 1.
proof. by rewrite /VEXTRACTI128 /b2i W8.of_intwE. qed.

lemma VPMOVSX_8u16_8u32_bits32 (h : W128.t) (k : int) : 0 <= k < 8 =>
  VPMOVSX_8u16_8u32 h \bits32 k = W32.of_int (W16.to_sint (h \bits16 k)).
proof.
move=> hk; rewrite /VPMOVSX_8u16_8u32 W8u32.get_pack8 1:size_map 1:W8u16.size_to_list //.
rewrite (nth_map W16.zero) 1:W8u16.size_to_list 1:/# /MOVSX_u32s16.
by rewrite W8u16.nth_to_list.
qed.

(* the sign extensions of the two halves of a register of 16-bit lanes *)
lemma VPMOVSX_8u16_8u32_halves (w : W256.t) (k : int) : 0 <= k < 16 =>
  (if k < 8 then VPMOVSX_8u16_8u32 (truncateu128 w) \bits32 k
   else VPMOVSX_8u16_8u32 (VEXTRACTI128 w (W8.of_int 1)) \bits32 (k - 8)) =
  W32.of_int (W16.to_sint (w \bits16 k)).
proof.
move=> hk; rewrite (bits16_128 w k) // truncateu128_bits128 VEXTRACTI128_1.
case: (k < 8) => h.
+ by rewrite VPMOVSX_8u16_8u32_bits32 1:/# (_ : k %/ 8 = 0) 1:/# (_ : k %% 8 = k) 1:/#.
by rewrite VPMOVSX_8u16_8u32_bits32 1:/# (_ : k %/ 8 = 1) 1:/# (_ : k %% 8 = k - 8) 1:/#.
qed.

(* -------------------------------------------------------------------- *)
(* Additions and subtractions, lane by lane                             *)
(* -------------------------------------------------------------------- *)

lemma VPADD_16u16_bits16 (a b : W256.t) (k : int) : 0 <= k < 16 =>
  VPADD_16u16 a b \bits16 k = (a \bits16 k) + (b \bits16 k).
proof. by move=> hk; rewrite /VPADD_16u16 W16u16.map2bE. qed.

lemma VPSUB_16u16_bits16 (a b : W256.t) (k : int) : 0 <= k < 16 =>
  VPSUB_16u16 a b \bits16 k = (a \bits16 k) - (b \bits16 k).
proof. by move=> hk; rewrite /VPSUB_16u16 W16u16.map2bE. qed.

lemma VPADD_8u32_bits32 (a b : W256.t) (k : int) : 0 <= k < 8 =>
  VPADD_8u32 a b \bits32 k = (a \bits32 k) + (b \bits32 k).
proof. by move=> hk; rewrite /VPADD_8u32 W8u32.map2bE. qed.

lemma VPSUB_8u32_bits32 (a b : W256.t) (k : int) : 0 <= k < 8 =>
  VPSUB_8u32 a b \bits32 k = (a \bits32 k) - (b \bits32 k).
proof. by move=> hk; rewrite /VPSUB_8u32 W8u32.map2bE. qed.

(* -------------------------------------------------------------------- *)
(* Comparisons and their masks (MOVEMASK)                               *)
(* -------------------------------------------------------------------- *)

lemma VPCMPGT_8u32_msb (x y : W256.t) (i : int) : 0 <= i < 8 =>
  msb (VPCMPGT_8u32 x y \bits32 i) = (W32.to_sint (y \bits32 i) < W32.to_sint (x \bits32 i)).
proof.
move=> hi; rewrite /VPCMPGT_8u32 W8u32.map2bE // /wcmp /=.
by case: (to_sint (y \bits32 i) < to_sint (x \bits32 i)) => _; rewrite /msb /= ?W32.of_uintK.
qed.

lemma VPCMPEQ_8u32_bits32E (x y : W256.t) (i : int) : 0 <= i < 8 =>
  VPCMPEQ_8u32 x y \bits32 i = if x \bits32 i = y \bits32 i then W32.onew else W32.zero.
proof.
move=> hi; rewrite /VPCMPEQ_8u32 W8u32.map2bE // /wcmp /=.
move: (x \bits32 i) (y \bits32 i) => a b; case: (a = b) => [-> /=|hne].
- by apply W32.to_uint_eq; rewrite W32.of_uintK W32.to_uint_onew.
rewrite ifF // /W32.to_sint /W32.smod /=.
by have := W32.to_uint_eq a b; have := W32.to_uint_cmp a; have := W32.to_uint_cmp b; smt().
qed.

lemma movemask_8u32_bit (x : W256.t) (b : int) :
  (zeroextu64 (MOVEMASK_8u32 x)).[b] = (0 <= b < 8 /\ msb (x \bits32 b)).
proof.
rewrite zeroextu64_bit /MOVEMASK_8u32 /=.
case: (0 <= b < 8) => hb.
+ rewrite (_ : 0 <= b < 32) 1:/# W32.get_bits2w 1:/#.
  have : b = 0 \/ b = 1 \/ b = 2 \/ b = 3 \/ b = 4 \/ b = 5 \/ b = 6 \/ b = 7 by smt().
  by move=> [|[|[|[|[|[|[|]]]]]]] -> /=.
case: (0 <= b < 32) => hb1 //=.
by rewrite W32.get_bits2w 1:/# nth_default /#.
qed.

(* the masks of the positive and of the negative lanes *)
lemma mask_pos (w : W256.t) (b : int) :
  (zeroextu64 (MOVEMASK_8u32 (VPCMPGT_8u32 w W256.zero))).[b] =
  (0 <= b < 8 /\ 0 < W32.to_sint (w \bits32 b)).
proof.
rewrite movemask_8u32_bit; case: (0 <= b < 8) => // hb.
by rewrite VPCMPGT_8u32_msb // W8u32.get_zero to_sint32_0.
qed.

lemma mask_neg (w : W256.t) (b : int) :
  (zeroextu64 (MOVEMASK_8u32 (VPCMPGT_8u32 W256.zero w))).[b] =
  (0 <= b < 8 /\ W32.to_sint (w \bits32 b) < 0).
proof.
rewrite movemask_8u32_bit; case: (0 <= b < 8) => // hb.
by rewrite VPCMPGT_8u32_msb // W8u32.get_zero to_sint32_0.
qed.

(* the mask of the non-zero lanes *)
lemma mask_nz (c : W256.t) (b : int) :
  (zeroextu64 (MOVEMASK_8u32 (VPCMPEQ_8u32 c W256.zero)) `^` W64.of_int 255).[b]
  = (0 <= b < 8 /\ c \bits32 b <> W32.zero).
proof.
rewrite W64.xorwE movemask_8u32_bit (_ : 255 = 2 ^ 8 - 1) // W64.of_int_powm1 //.
case: (0 <= b < 8) => hb /=; last by smt().
rewrite VPCMPEQ_8u32_bits32E // W8u32.get_zero (_ : 0 <= b < 64) 1:/# (_ : b < 8) 1:/# /=.
by case: (c \bits32 b = W32.zero) => _; rewrite /msb ?W32.to_uint_onew ?W32.to_uint0.
qed.
