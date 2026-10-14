require import AllCore.
require Spec65 Mldsa65I CommonModularT.

(* The Montgomery reductions and multiplications, at ML-DSA-65 *)
clone export CommonModularT.CommonModularT as CommonModular65 with
  theory B.S <= Spec65.MLDSA65,
  theory B.R <= Mldsa65I.Mldsa65I.
export CommonModular65.CR.
