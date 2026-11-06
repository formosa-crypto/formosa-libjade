require import AllCore IntDiv List.
from Jasmin require import JModel_x86.

(* The low 32 bits of a 64-bit word moved into a 256-bit register by
   VMOV_64 are its own low 32 bits. *)
lemma truncateu32_VMOV_64E (x : W64.t) :
  truncateu32 (zeroextu256 (VMOV_64 x)) = truncateu32 x.
proof.
rewrite /truncateu32 to_uint_zeroextu256 /VMOV_64.
have -> : pack2 [x; W64.zero] = W2u64.zeroextu128 x.
+ apply W128.wordP => i hi; rewrite pack2wE //= /zeroextu128 W128.of_intwE hi /= W64.get_to_uint.
  case: (i %/ 64 = 0) => hd /=.
  + rewrite hd get_of_list // /= (_ : i %% 64 = i) 1:/# /int_bit.
    rewrite (_ : 0 <= i < 64) 1:/# /= (pmod_small (to_uint x)); 2: done.
    smt(W64.to_uint_cmp StdOrder.IntOrder.ler_weexpn2l pow2_64).
  rewrite get_of_list 1:/# (_ : i %/ 64 = 1) 1:/# /= /int_bit.
  have hx := W64.to_uint_cmp x; have h64 : 2 ^ 64 <= 2 ^ i by apply StdOrder.IntOrder.ler_weexpn2l => /#.
  rewrite (pmod_small (to_uint x)); 1: smt(pow2_64).
  by rewrite divz_small; smt(pow2_64).
by rewrite to_uint_zeroextu128.
qed.
