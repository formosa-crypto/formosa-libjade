require import AllCore.
require Spec65 Mldsa65I.
require Avx2red Fnttcorrect Inttcorrect Pwmulcorrect Sha3x4.

(* The shared proofs about the generic model, at the ML-DSA-65 parameters
   and model. Mldsa65I.M is Mldsa65.M, so their lemmas apply to the
   procedures of Mldsa65. *)

clone Avx2red.Avx2redT as Avx2red65 with
  theory P <= Spec65.Params65, theory R <= Mldsa65I.Mldsa65I.

clone Fnttcorrect.FnttcorrectT as Fnttcorrect65 with
  theory P <= Spec65.Params65, theory R <= Mldsa65I.Mldsa65I.

clone Inttcorrect.InttcorrectT as Inttcorrect65 with
  theory P <= Spec65.Params65, theory R <= Mldsa65I.Mldsa65I.

clone Pwmulcorrect.PwmulcorrectT as Pwmulcorrect65 with
  theory P <= Spec65.Params65, theory R <= Mldsa65I.Mldsa65I.

clone Sha3x4.Sha3x4T as Sha3x4_65 with
  theory P <= Spec65.Params65, theory R <= Mldsa65I.Mldsa65I.
