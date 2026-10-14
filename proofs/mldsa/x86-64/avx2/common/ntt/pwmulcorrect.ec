(**
  Functional correctness of the AVX2 pointwise (NTT-domain)
  Montgomery multiplication: the procedure writes, into every
  coefficient of the destination, the montgomery-multiplication of
  the matching coefficients of its two operands (`pwmul`).
*)
require import AllCore CoreUtils List Ring IntDiv.
require import StdRing StdOrder.
from Jasmin require import JWord JArray.
require import JArrayExtra CircuitBindings.
from Jasmin require import JModel_x86.
require import MldsaConstants.
require Parameters MldsaT.
require import WArray1024.
require import Array256.
require import XArray256.
require import Nttspec.
require import Avx2red Listred.

abstract theory PwmulcorrectT.

clone import Parameters.ParamsT as P.
clone import MldsaT.MldsaT as R with theory P <- P.
clone import Avx2red.Avx2redT as AR with theory P <= P, theory R <= R.

(* -------------------------------------------------------------------- *)
type wpoly = W32.t Array256.t.

(* ==================================================================== *)
lemma pwmulP (t_ a_ b_ : wpoly) :
  hoare[M.polynomial__pointwise_montgomery_multiply_and_reduce :
    arg = (t_, a_, b_) ==> res = pwmul a_ b_].
proof.
hint +listred.
proc.
sp; while (
     0 <= offset <= 1024
  /\ 64 %| offset
  /\ lhs = a_ /\ rhs = b_
  /\ product = pwmul_partial a_ b_ t_ (offset %/ 4)
); last first.
- skip=> &hr |>; split*.
  - smt().
  - by rewrite pwmul_partial0.
  - move=> off0 *; have ->: off0 %/ 4 = 256 by smt().
    by rewrite pwmul_partial_full.

exlim offset => i_.
case@[ambient]: (0 <= i_ < 1024 /\ 64 %| i_) => *; last first.
- by conseq (_ : false ==> _); [smt() | exfalso].
pose n_ := i_ %/ 4.
have ?: 0 <= n_ < 256 - 15 by smt().
have ?: i_ %% 4 = 0 by smt().

(* first 8-coefficient chunk, at coefficient base n_ *)
seq 2 : (#pre
  /\ lhs_coeffs = pack8 (mkseq (fun k => a_.[n_ + k]) 8)
  /\ rhs_coeffs = pack8 (mkseq (fun k => b_.[n_ + k]) 8)).
- by auto=> &hr |> *; rewrite !wpoly_get256_alignedE ~-1:/#.

seq 1 : (#pre /\
  product_coeffs = pack8 (mkseq (fun k => mmr a_.[n_ + k] b_.[n_ + k]) 8)).
- by ecall (mmrP lhs_coeffs rhs_coeffs); auto.

seq 2 : (
     lhs = a_ /\ rhs = b_
  /\ offset = i_ + 32
  /\ product = pwmul_partial a_ b_ t_ (n_ + 8)).
- auto=> &hr |> *.
  rewrite pwmul_partialS ~-1:/#.
  rewrite (_ : offset{hr} = 4 * n_) 1:/#.
  rewrite wpoly_set256_aligned 1:/# /=.
  rewrite (_ : 4 * n_ %/ 4 = n_) 1:/# /replace_.
  apply fill_congr => //= i0 rgi.
  by rewrite pack8_bits32E 1:/#; smt().

(* second 8-coefficient chunk, at coefficient base n_ + 8 *)
seq 2 : (#pre
  /\ lhs_coeffs = pack8 (mkseq (fun k => a_.[n_ + 8 + k]) 8)
  /\ rhs_coeffs = pack8 (mkseq (fun k => b_.[n_ + 8 + k]) 8)).
- auto=> &hr |> *.
  by rewrite !wpoly_get256_alignedE ~-1:/#; smt().

seq 1 : (#pre /\
  product_coeffs = pack8 (mkseq (fun k => mmr a_.[n_ + 8 + k] b_.[n_ + 8 + k]) 8)).
- by ecall (mmrP lhs_coeffs rhs_coeffs); auto.

auto=> &hr |> *; do! (split=> *); ~-1: smt().
rewrite (_ : (i_ + 64) %/ 4 = n_ + 8 + 8) 1:/#.
rewrite (pwmul_partialS lhs{hr} rhs{hr} t_ (n_ + 8)) ~-1:/#.
rewrite (_ : i_ + 32 = 4 * (n_ + 8)) 1:/#.
rewrite wpoly_set256_aligned 1:/# /=.
apply fill_congr => //= i0 rgi.
by rewrite pack8_bits32E 1:/#; smt().
qed.

end PwmulcorrectT.
