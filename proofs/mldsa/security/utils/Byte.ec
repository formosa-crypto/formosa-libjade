require import Core Int Distr.

(* A type that describes bytes as unsigned 8-bit integers. *)
(* A uniform distribution on bytes is also provided. *)

type byte. (* subtype byte = { n : int | 0 <= n < 256 }. *)
op to_int : byte -> int. (* natural widening *)
op from_int : int -> byte. (* narrowing with unspecified output for out-of-range integers *)

axiom [explicit] tK : cancel to_int from_int.
axiom [explicit] to_int_in_surj i : 0 <= i < 256 <=> exists b, to_int b = i.

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
