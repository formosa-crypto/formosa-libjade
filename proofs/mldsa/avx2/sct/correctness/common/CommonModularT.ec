require import AllCore List IntDiv RealExp.
from Jasmin require import JModel_x86.
require import CircuitBindings Bindings.
from Spec require import GFq Rq Parameters MLDSA_W32_Rep.
require import XArray256 Array256.
require Nttspec.
require import Nttlink.
require BaseT Avx2red Pwmulcorrect CommonReduceT.

(* The Montgomery multiplications, lane- and polynomial-wise. Their proofs
   need Avx2red, whose simplification hints rewrite the AVX2 lane operations
   into pack8 lists that `circuit` does not translate: the circuit proofs of
   the reductions are in CommonReduceT, which does not require it. *)
abstract theory CommonModularT.

clone import BaseT.BaseT as B.
import S R MLDSAParams.
clone import Avx2red.Avx2redT as AR with theory P <- S, theory R <- R.
clone import Pwmulcorrect.PwmulcorrectT as PC with theory P <- S, theory R <- R.
clone import CommonReduceT.CommonReduceT as CR with theory B <- B.

import Round ZModQ Zq.




(* every lane is the Montgomery product of the matching lanes          *)
lemma montgomery_multiply_and_reduce_correct (u v : W256.t) :
    hoare [ M.montgomery_multiply_and_reduce :
        arg = (u, v)
        ==>
        res = W8u32.pack8_t (W8u32.Pack.map2 Nttspec.mmr (W8u32.unpack32 u) (W8u32.unpack32 v))
    ].
proof. exact mmrP. qed.

lemma montgomery_multiply_and_reduce_ph (u v : W256.t) :
    phoare [ M.montgomery_multiply_and_reduce :
        arg = (u, v)
        ==>
        res = W8u32.pack8_t (W8u32.Pack.map2 Nttspec.mmr (W8u32.unpack32 u) (W8u32.unpack32 v))
    ] = 1%r
  by conseq montgomery_multiply_and_reduce_ll
            (montgomery_multiply_and_reduce_correct u v).

lemma polynomial__pointwise_montgomery_multiply_and_reduce_correct
      (_prod : W32.t Array256.t) (_lhs : W32.t Array256.t) (_rhs : W32.t Array256.t) :
    hoare [ M.polynomial__pointwise_montgomery_multiply_and_reduce :
        product = _prod /\ lhs = _lhs /\ rhs = _rhs /\
        wpoly_bmul_irng _lhs /\ wpoly_bmul_irng _rhs
        ==>
        liftm_wpoly res = basemul (lifts_wpoly _lhs) (lifts_wpoly _rhs) /\
        wpoly_srng (q-1) (q-1) res
    ].
proof.
conseq (pwmulP _prod _lhs _rhs); 1: by move=> &hr /> /#.
by move=> &hr /> hl hr; rewrite pwmul_link /=; exact pwmul_rng.
qed.

lemma polynomial__pointwise_montgomery_multiply_and_reduce_ph
      (_prod : W32.t Array256.t) (_lhs : W32.t Array256.t) (_rhs : W32.t Array256.t) :
    phoare [ M.polynomial__pointwise_montgomery_multiply_and_reduce :
        product = _prod /\ lhs = _lhs /\ rhs = _rhs /\
        wpoly_bmul_irng _lhs /\ wpoly_bmul_irng _rhs
        ==>
        liftm_wpoly res = basemul (lifts_wpoly _lhs) (lifts_wpoly _rhs) /\
        wpoly_srng (q-1) (q-1) res
    ] = 1%r
  by conseq polynomial__pointwise_montgomery_multiply_and_reduce_ll
            (polynomial__pointwise_montgomery_multiply_and_reduce_correct _prod _lhs _rhs).

end CommonModularT.
