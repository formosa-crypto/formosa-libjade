(*
 * WordSpec.ec
 * ===========
 *
 * Meaning of the word helpers of word.jinc.
 * ArchWord proves that the extracted helpers compute these operators;
 * the hash proofs use only the operators.
 *)

require import AllCore List.
from Jasmin require import JWord.

(* Byte reversal of a 32-bit and a 64-bit word. *)
op bswap32 (x : W32.t) : W32.t = W4u8.pack4 (rev (W4u8.to_list x)).
op bswap64 (x : W64.t) : W64.t = W8u8.pack8 (rev (W8u8.to_list x)).
