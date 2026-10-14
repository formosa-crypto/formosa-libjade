(**
  Algebraic correctness of the AVX2 NTT procedures.

  Combines the code-level functional correctness (`Fnttcorrect`,
  `Inttcorrect`: the procedures compute `reduce_tree` / `invtree` +
  `iscale`) with the algebraic content of those operators (`Fnttalg`),
  yielding end-to-end statements: under a magnitude assumption on the
  input coefficients, the procedures compute the (inverse) NTT of the
  input, coefficient-wise modulo q, with an explicit output bound.
*)
require import AllCore CoreUtils List Ring IntDiv BitEncoding.
require import StdRing StdOrder StdBigop.
from Jasmin require import JWord JArray JModel_x86.
require import MldsaConstants.
require Parameters MldsaT.
require import Array256.
require import Nttlogspec Nttspec Nttzetas Nttalg Fnttalg.
require import Fnttcorrect.

abstract theory FnttalgcorrectT.

clone import Parameters.ParamsT as P.
clone import MldsaT.MldsaT as R with theory P <- P.
clone import Fnttcorrect.FnttcorrectT as FC with theory P <= P, theory R <= R.

(* ==================================================================== *)
(*---*) import Bigint BIA.

(* ==================================================================== *)
(* Forward NTT: multipoint evaluation at the odd powers of zeta_, in    *)
(* bit-reversed order (exponent table E)                                *)
(* ==================================================================== *)
lemma polynomial__ntt_algP (p_ : wpoly) (B : int) :
  0 <= B => B + 8 * q < 2^31 => cbnd p_ B =>
  hoare[M.polynomial__ntt :
       polynomial = p_
    ==>    cbnd res (B + 8 * q)
        /\ forall j, 0 <= j < 256 =>
             sval res.[j] %% q
               = (bigi predT (fun s => zpw (E 0 j * s) * sval p_.[s]) 0 256) %% q].
proof.
move=> ge0B hB hbnd.
have [hb hs] := ntt_alg p_ B ge0B hB hbnd.
by conseq (polynomial__nttP p_) => // /> *.
qed.

end FnttalgcorrectT.
