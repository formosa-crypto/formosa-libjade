require import AllCore List IntDiv BitEncoding.
import BS2Int.
from Jasmin require import JWord.

(* Packing bytes into a 32-bit word: the bits and the value of the word. *)

lemma w2bits_pack4 (b0 b1 b2 b3 : W8.t) :
  W32.w2bits (W4u8.pack4 [b0; b1; b2; b3])
  = W8.w2bits b0 ++ W8.w2bits b1 ++ W8.w2bits b2 ++ W8.w2bits b3.
proof.
apply (eq_from_nth false).
- by rewrite W32.size_w2bits' !size_cat !W8.size_w2bits'.
rewrite W32.size_w2bits' => i rgi.
rewrite W32.get_w2bits.
rewrite (_ : i = i %/ 8 * 8 + i %% 8) 1:/#.
rewrite -W4u8.bits8iE 1:/# W4u8.pack4bE 1:/#.
by (have [->|[->|[->|->]]] /= :
      i %/ 8 = 0 \/ i %/ 8 = 1 \/ i %/ 8 = 2 \/ i %/ 8 = 3 by smt());
   smt(nth_cat size_cat W8.size_w2bits' W8.get_w2bits).
qed.

lemma to_uint_pack4 (b0 b1 b2 b3 : W8.t) :
  to_uint (W4u8.pack4 [b0; b1; b2; b3])
  = bs2int (W8.w2bits b0 ++ W8.w2bits b1 ++ W8.w2bits b2 ++ W8.w2bits b3).
proof. by rewrite W32.to_uintE w2bits_pack4. qed.

lemma to_uint_pack4_3 (b0 b1 b2 : W8.t) :
  to_uint (W4u8.pack4 [b0; b1; b2; W8.zero])
  = bs2int (W8.w2bits b0 ++ W8.w2bits b1 ++ W8.w2bits b2).
proof.
rewrite to_uint_pack4 -!catA !bs2int_cat.
have -> : bs2int (W8.w2bits W8.zero) = 0 by rewrite -W8.to_uintE.
by ring.
qed.
