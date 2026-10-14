require import AllCore.
require Spec65 Mldsa65I CommonInvertNttT.

(* The inverse NTT, at ML-DSA-65 *)
clone export CommonInvertNttT.CommonInvertNttT as CommonInvertNtt65 with
  theory B.S <= Spec65.MLDSA65,
  theory B.R <= Mldsa65I.Mldsa65I.
