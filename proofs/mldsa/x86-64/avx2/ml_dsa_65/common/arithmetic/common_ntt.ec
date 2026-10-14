require import AllCore.
require Spec65 Mldsa65I CommonNttT.

(* The forward NTT, at ML-DSA-65 *)
clone export CommonNttT.CommonNttT as CommonNtt65 with
  theory B.S <= Spec65.MLDSA65,
  theory B.R <= Mldsa65I.Mldsa65I.
