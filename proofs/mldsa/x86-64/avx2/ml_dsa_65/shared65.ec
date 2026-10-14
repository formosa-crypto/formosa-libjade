require import AllCore.
require Spec65 Mldsa65I.
require Sha3x4.

(* The four-lane SHAKE proofs about the generic model, at the ML-DSA-65
   parameters and model. Mldsa65I.M is Mldsa65.M, so their lemmas apply
   to the procedures of Mldsa65. *)

clone Sha3x4.Sha3x4T as Sha3x4_65 with
  theory P <= Spec65.Params65, theory R <= Mldsa65I.Mldsa65I.
