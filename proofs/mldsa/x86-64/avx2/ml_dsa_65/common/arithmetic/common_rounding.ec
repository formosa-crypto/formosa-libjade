require import AllCore.
require Spec65 Mldsa65I CommonRoundingT.

(* make_hint and power2round, at ML-DSA-65 *)
clone export CommonRoundingT.CommonRoundingT as CommonRounding65 with
  theory B.S <= Spec65.MLDSA65,
  theory B.R <= Mldsa65I.Mldsa65I.
