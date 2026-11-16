(*
 * SafetyEclib.ec
 * ==============
 *
 * Lemmas on memory ranges and on the initialisation masks of byte arrays
 * that the safety proofs use and that the Jasmin eclib of this toolchain
 * does not state: is_validP, and, for each byte array of the safety model,
 * is_init_one and is_init_cellP, both simplification hints.
 *)

require import AllCore IntDiv.
from Jasmin require import JWord JMemory JByte_array.
require import BArray8 BArray16 BArray28 BArray32 BArray48 BArray64 BArray128 BArray208 BArray256 BArray272 BArray512 BArray640 BArray1280.

lemma is_validP (mod : int) (mem_v : global_mem_v_t) (a : address) (l : int) :
  is_valid mod mem_v a l <=>
  (forall a' l', a <= a' => a' + l' <= a + l => is_valid mod mem_v a' l').
proof. smt(). qed.

abstract theory ByteInit.

clone import ByteArray as A.

lemma is_init_one (t : t) (k : int) : is_init t k 1 = is_init_cell t k.
proof. smt(). qed.

hint simplify is_init_one.

lemma is_init_cellP (t : t) (i j : int) (v : W8.t) :
  is_init_cell t.[i <- v] j =
  if i = j /\ 0 <= i < A.size then v = W8.of_int 255 else is_init_cell t j.
proof. smt(get_set_if). qed.

hint simplify is_init_cellP.

end ByteInit.

clone ByteInit as BInit8 with theory A <= BArray8.

clone ByteInit as BInit16 with theory A <= BArray16.

clone ByteInit as BInit28 with theory A <= BArray28.

clone ByteInit as BInit32 with theory A <= BArray32.

clone ByteInit as BInit48 with theory A <= BArray48.

clone ByteInit as BInit64 with theory A <= BArray64.

clone ByteInit as BInit128 with theory A <= BArray128.

clone ByteInit as BInit208 with theory A <= BArray208.

clone ByteInit as BInit256 with theory A <= BArray256.

clone ByteInit as BInit272 with theory A <= BArray272.

clone ByteInit as BInit512 with theory A <= BArray512.

clone ByteInit as BInit640 with theory A <= BArray640.

clone ByteInit as BInit1280 with theory A <= BArray1280.
