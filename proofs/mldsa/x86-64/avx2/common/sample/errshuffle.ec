(* -------------------------------------------------------------------- *)
(* The 256-row byte-compaction shuffle table of the ML-DSA error-vector *)
(* sampler: row m compacts the bytes selected by the 8-bit mask m to    *)
(* the front, in order.                                                 *)
(*                                                                      *)
(* shuffle_compact8 is proved by brute force: the property is evaluated *)
(* on all 256 rows of the table at once.                                *)
(* -------------------------------------------------------------------- *)
require import AllCore List List_extra IntDiv BitEncoding.
import BS2Int.

from Jasmin require import JWord JModel_x86.
require import MldsaConstants.

require import Avx2red.
require import Array2048 WArray2048.

(* -------------------------------------------------------------------- *)
lemma truncateu64_128E (w : W128.t) : truncateu64 w = w \bits64 0.
proof.
apply: W64.ext_eq=> i rgi; rewrite bits64iE //=.
rewrite /truncateu64 of_intwE rgi /= /W64.int_bit.
rewrite modz_pow2_div ~-1://# modz_dvd.
- by rewrite -{1}[2]expr1 dvdz_exp2l /#.
- by rewrite -b2i_get /#.
qed.

hint simplify truncateu64_128E.

(* -------------------------------------------------------------------- *)
lemma VMOV_64_pack8E (b0 b1 b2 b3 b4 b5 b6 b7 : W8.t) :
  VMOV_64 (W8u8.pack8 [b0; b1; b2; b3; b4; b5; b6; b7])
  = W16u8.pack16 [b0; b1; b2; b3; b4; b5; b6; b7;
                  W8.zero; W8.zero; W8.zero; W8.zero;
                  W8.zero; W8.zero; W8.zero; W8.zero].
proof.
by apply W128.all_eq_eq; cbv W128.all_eq VMOV_64 W8u8.unpack8 W16u8.unpack8.
qed.

hint simplify VMOV_64_pack8E.

(* -------------------------------------------------------------------- *)
lemma shuffle_compact8 (x : W128.t) (m : int) : 0 <= m < 256 =>
    take (count idfun (int2bs 8 m))
      (W8u8.to_list (truncateu64 (VPSHUFB_128 x
        (VMOV_64 (W8u8.pack8 (Array2048.sub eRROR_VECTOR_SHUFFLE_TABLE (8 * m) 8))))))
  = mask (int2bs 8 m) (take 8 (W16u8.to_list x)).
proof.
move=> rgm.
have h : all (fun m =>
    take (count idfun (int2bs 8 m))
      (W8u8.to_list (truncateu64 (VPSHUFB_128 x
        (VMOV_64 (W8u8.pack8 (Array2048.sub eRROR_VECTOR_SHUFFLE_TABLE (8 * m) 8))))))
  = mask (int2bs 8 m) (take 8 (W16u8.to_list x))) (iota_ 0 256).
- by rewrite -iotaredE /sub /int2bs /mkseq -iotaredE /=.
move: h; rewrite List.allP => /(_ m) /= h; apply: h.
by rewrite mem_iota /#.
qed.
