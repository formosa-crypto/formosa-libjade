(* -------------------------------------------------------------------- *)
(* Reading a word out of the byte view of a polynomial array: the       *)
(* get*_direct / init8 marshaling used by the extracted samplers,       *)
(* generically over the array size.                                     *)
(* -------------------------------------------------------------------- *)
require import AllCore List IntDiv.

from Jasmin require import JWord JWord_array JUtils JArray.

(* -------------------------------------------------------------------- *)
abstract theory WArrayPack.

op size : int.

clone import PolyArray as A  with op size <- size.
clone import WArray    as WA with op size <- size.

(* -------------------------------------------------------------------- *)
lemma get64E (a : W8.t A.t) (base : int) :
  0 <= base <= size - 8 =>
    WA.get64_direct (WA.init8 ("_.[_]" a)) base
  = W8u8.pack8 (A.sub a base 8).
proof.
move=> rgb; rewrite WA.get64E; congr; apply W8u8.Pack.ext_eq => j hj.
rewrite initiE //= get_of_list //.
rewrite /init8 WA.initiE 1:/# /=.
by rewrite /sub nth_mkseq //=.
qed.

(* -------------------------------------------------------------------- *)
lemma get128E (a : W8.t A.t) (base : int) :
  0 <= base <= size - 16 =>
    WA.get128_direct (WA.init8 ("_.[_]" a)) base
  = W16u8.pack16 (A.sub a base 16).
proof.
move=> rgb; rewrite WA.get128E; congr; apply W16u8.Pack.ext_eq => j hj.
rewrite initiE //= get_of_list //.
rewrite /init8 WA.initiE 1:/# /=.
by rewrite /sub nth_mkseq //=.
qed.

(* -------------------------------------------------------------------- *)
lemma get256E (a : W8.t A.t) (base : int) :
  0 <= base <= size - 32 =>
    WA.get256_direct (WA.init8 ("_.[_]" a)) base
  = W32u8.pack32 (A.sub a base 32).
proof.
move=> rgb; rewrite WA.get256E; congr; apply W32u8.Pack.ext_eq => j hj.
rewrite initiE //= get_of_list //.
rewrite /init8 WA.initiE 1:/# /=.
by rewrite /sub nth_mkseq //=.
qed.

end WArrayPack.
