require import AllCore.
require Spec65 Mldsa65I RoundingT.

(* Decompose and UseHint, at ML-DSA-65 *)
clone export RoundingT.RoundingT as Rounding65 with
  theory B.S <= Spec65.MLDSA65,
  theory B.R <= Mldsa65I.Mldsa65I.
