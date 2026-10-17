(**
  Algebraic correctness of the AVX2 inverse NTT procedure.

  Combines the code-level functional correctness (`Inttcorrect`: the
  procedure computes `iscale (invtree polynomial 8)`) with the
  algebraic content of those operators (`Inttalg`), yielding the
  end-to-end statement: on a reduced input congruent to the forward
  NTT of p, the procedure returns 2^32 * p coefficient-wise mod q
  (the inverse transform in Montgomery form), with all coefficients
  bounded by q.
*)
require import AllCore CoreUtils List Ring IntDiv BitEncoding.
require import StdRing StdOrder StdBigop.
from Jasmin require import JWord JArray JModel_x86.
require import MldsaConstants.
require Parameters MldsaT.
require import Array256.
require import Nttlogspec Nttspec Nttzetas Inttalg.
require import Inttcorrect.

abstract theory InttalgcorrectT.

clone import Parameters.ParamsT as P.
clone import MldsaT.MldsaT as R with theory P <- P.
clone import Inttcorrect.InttcorrectT as IC with theory P <- P, theory R <- R.

(* ==================================================================== *)
(*---*) import Bigint BIA.

(* ==================================================================== *)
(* Inverse NTT: on a reduced input congruent to the forward NTT of p,   *)
(* the procedure returns 2^32 * p (Montgomery form), reduced            *)
(* ==================================================================== *)
lemma polynomial__invert_ntt_montgomery_algP (p_ v_ : wpoly) (B : int) :
  q <= B => 2^8 * B < 2^31 => cbnd v_ B =>
  (forall i, 0 <= i < 256 => sval v_.[i] %% q = nttsum p_ 0 i 0 %% q) =>
  hoare[M.polynomial__invert_ntt_montgomery :
       polynomial = v_
    ==>    cbnd res q
        /\ forall i, 0 <= i < 256 =>
             sval res.[i] %% q = (2^32 * sval p_.[i]) %% q].
proof.
move=> leqB hB hbnd hv.
have [hb hs] := intt_ntt_alg p_ v_ B leqB hB hbnd hv.
conseq (polynomial__invert_ntt_montgomeryP v_) => //.
move=> &hr _ r ->.
split.
- by apply hb.
by apply hs.
qed.

end InttalgcorrectT.
