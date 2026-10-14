(**
  Closing the loop: polynomial multiplication through the AVX2 NTT
  pipeline.

  We define a procedure that multiplies two polynomials (given as
  word arrays) the way ML-DSA does: convert both operands to the NTT
  domain (`polynomial__ntt`), multiply pointwise
  (`polynomial__pointwise_montgomery_multiply_and_reduce`), and come
  back (`polynomial__invert_ntt_montgomery`).

  The theorem: if the inputs represent the polynomials u and v (via
  `pofw`), with coefficients bounded so that the intermediate
  Montgomery products cannot overflow, then the output represents
  u * v modulo X^256 + 1.  No Montgomery factor is left in the
  statement: the 2^-32 of the pointwise step and the 2^32 of the
  inverse transform cancel exactly.
*)
require import AllCore CoreUtils List Ring IntDiv.
require import StdRing StdOrder.
from Jasmin require import JWord JArray JModel_x86.
require import MldsaConstants.
require Parameters MldsaT.
require import Array256.
require import Nttlogspec Nttspec Nttzetas Nttalg Fnttalg Inttalg.
require import Crspoly.
require import Nttpoly.
require import Fnttcorrect Inttcorrect Pwmulcorrect.

abstract theory PwmultestT.

clone import Parameters.ParamsT as P.
clone import MldsaT.MldsaT as R with theory P <- P.
clone import Fnttcorrect.FnttcorrectT as FC with theory P <- P, theory R <- R.
clone import Inttcorrect.InttcorrectT as IC with theory P <- P, theory R <- R.
clone import Pwmulcorrect.PwmulcorrectT as PC with theory P <- P, theory R <- R.

(* -------------------------------------------------------------------- *)
(*---*) import Zq ZqP.

(* ==================================================================== *)
(* The multiplication pipeline, calling the AVX2 routines               *)
(* ==================================================================== *)
module PolyMul = {
  proc mul (a b : W32.t Array256.t) : W32.t Array256.t = {
    var na, nb, w, r : W32.t Array256.t;

    na <@ M.polynomial__ntt(a);
    nb <@ M.polynomial__ntt(b);
    w  <@ M.polynomial__pointwise_montgomery_multiply_and_reduce(witness, na, nb);
    r  <@ M.polynomial__invert_ntt_montgomery(w);
    return r;
  }
}.

(* ==================================================================== *)
(* Correctness: the output represents the product modulo X^256 + 1.     *)
(* The input coefficients are bounded by B, constrained so that the     *)
(* NTT-domain values (bounded by B + 8q) keep the 64-bit Montgomery     *)
(* products in range.                                                   *)
(* ==================================================================== *)
lemma mul_polyP (a_ b_ : wpoly) (B : int) :
  0 <= B => B + 8 * q < 2^31 =>
  (B + 8 * q) * (B + 8 * q) <= 2^31 * q =>
  cbnd a_ B => cbnd b_ B =>
  hoare[PolyMul.mul :
    arg = (a_, b_) ==>
    peqm (exp X 256 + poly1) (pofw res) (pofw a_ * pofw b_)].
proof.
move=> ge0B hltB hsqB hba hbb.
proc.
seq 1 : (b = b_ /\ na = reduce_tree a_ 0).
- by call (polynomial__nttP a_); auto.
seq 1 : (na = reduce_tree a_ 0 /\ nb = reduce_tree b_ 0).
- by call (polynomial__nttP b_); auto.
seq 1 : (w = pwmul (reduce_tree a_ 0) (reduce_tree b_ 0)).
- by call (pwmulP witness (reduce_tree a_ 0) (reduce_tree b_ 0)); auto.
call (polynomial__invert_ntt_montgomeryP
        (pwmul (reduce_tree a_ 0) (reduce_tree b_ 0))).
skip=> &hr -> r ->.
have [hbna _] := ntt_alg a_ B ge0B hltB hba.
have [hbnb _] := ntt_alg b_ B ge0B hltB hbb.
apply (intt_pwmul_polyP a_ b_
         (reduce_tree a_ 0) (reduce_tree b_ 0)
         (B + 8 * q) (B + 8 * q)) => //.
- move=> j rgj.
  by rewrite (ntt_evalP a_ B j).
move=> j rgj.
by rewrite (ntt_evalP b_ B j).
qed.

(* -------------------------------------------------------------------- *)
(* Concrete instance: reduced inputs (coefficients bounded by q)        *)
(* -------------------------------------------------------------------- *)
lemma mul_poly_redP (a_ b_ : wpoly) :
  cbnd a_ q => cbnd b_ q =>
  hoare[PolyMul.mul :
    arg = (a_, b_) ==>
    peqm (exp X 256 + poly1) (pofw res) (pofw a_ * pofw b_)].
proof.
move=> hba hbb.
by apply (mul_polyP a_ b_ q).
qed.

end PwmultestT.
