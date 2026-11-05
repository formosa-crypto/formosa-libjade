require import Core Int IntDiv Distr.
from Jasmin require import JWord.

(* The byte theory of the security proof (an abstract type with a
   bijection with [0, 256) in the generic development), instantiated here
   on the Jasmin bytes W8.t: the specification and the implementation
   proofs speak of W8.t. The interface (names and statements) is the one
   of the generic theory. *)

type byte = W8.t.
op to_int (b : byte) : int = W8.to_uint b.   (* natural widening *)
op from_int (i : int) : byte = W8.of_int i.  (* narrowing, reduces modulo 256 *)

lemma tK : cancel to_int from_int.
proof. by move=> b; rewrite /to_int /from_int W8.to_uintK. qed.

lemma to_int_in_surj i : 0 <= i < 256 <=> exists b, to_int b = i.
proof.
split => [hi | [b <-]]; 1: by exists (W8.of_int i); rewrite /to_int W8.of_uintK modz_small /#.
by have := W8.to_uint_cmp b.
qed.

lemma to_int_inj : injective to_int by exact (can_inj _ _ tK).

lemma from_int_surj : surjective from_int.
move => b. exists (to_int b). by rewrite tK.
qed.

lemma from_int_in_inj i j :
  0 <= i < 256 => 0 <= j < 256 => from_int i = from_int j => i = j.
proof.
move => /to_int_in_surj [b1 <-] /to_int_in_surj [b2 <-].
by rewrite ! tK.
qed.

lemma tK' i : 0 <= i < 256 => to_int (from_int i) = i.
proof.
move => /to_int_in_surj [b <-]. congr. by rewrite tK. 
qed.

op dB = dmap (drange 0 256) from_int.

lemma dB_ll : is_lossless dB by apply/dmap_ll/drange_ll => //.

lemma dB_uni : is_uniform dB.
proof.
rewrite dmap_uni_in_inj => ??; last by apply drange_uni.
rewrite ! supp_drange. 
by apply from_int_in_inj.
qed.

lemma dB_full : is_full dB.
proof.
move => b.
rewrite -tK.
apply/dmap_supp/supp_drange.
rewrite to_int_in_surj.
by exists b.
qed.

lemma to_int_bnd (b : byte) : 0 <= to_int b < 256.
proof. by apply/to_int_in_surj; exists b. qed.

(* [to_int] maps the uniform distribution on bytes to the uniform
   distribution on [0, 256). *)
lemma dB_to_int : dmap dB to_int = drange 0 256.
proof.
rewrite /dB dmap_comp (eq_dmap_in _ _ idfun) 2:dmap_id //.
by move => ? /supp_drange; apply tK'.
qed.

(* The uniform distribution on bytes is the one of the Jasmin library *)
lemma dB_dword : dB = W8.dword.
proof.
apply eq_funi_ll.
- by apply is_full_funiform; [exact dB_full | exact dB_uni].
- exact dB_ll.
- by apply is_full_funiform; [exact W8.dword_fu | exact W8.dword_uni].
exact W8.dword_ll.
qed.
