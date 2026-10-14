require import AllCore.
require Spec65 Mldsa65I PolynomialT.

(* The polynomial arithmetic and the infinity-norm check, at ML-DSA-65 *)
clone export PolynomialT.PolynomialT as Polynomial65 with
  theory B.S <= Spec65.MLDSA65,
  theory B.R <= Mldsa65I.Mldsa65I.
