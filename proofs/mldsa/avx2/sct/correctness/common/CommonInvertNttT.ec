require import AllCore List IntDiv RealExp.
from Jasmin require import JModel_x86.
from Spec require import GFq Rq Parameters MLDSA_W32_Rep.
require import Nttlink.
require import Array256.
require BaseT Inttcorrect CommonReduceT.

abstract theory CommonInvertNttT.

clone import BaseT.BaseT as B.
import S R MLDSAParams.
clone import Inttcorrect.InttcorrectT as IC with theory P <- S, theory R <- R.
clone import CommonReduceT.CommonReduceT as CR with theory B <- B.

import Round ZModQ Zq.


(* ================================================================== *)
(* polynomial__invert_ntt_montgomery                                    *)
(* Computes the inverse NTT of a polynomial.                           *)
(* Input:  wpoly_intt_irng _a  (|x| <= q)                             *)
(* Output: lifts_wpoly res = invntt (liftm_wpoly _a)                   *)
(*           the input is read in Montgomery form (times 2^32): this   *)
(*           is the factor the NTT-domain products leave out           *)
(*         wpoly_srng invntt_obound invntt_obound res                  *)
(*           (the last level ends with an mmr by 41978 or -3975713)    *)
(* ================================================================== *)

lemma polynomial__invert_ntt_montgomery_ll : islossless M.polynomial__invert_ntt_montgomery.
proof.
proc; while true (4 - i); first by move=> z; wp; call (: true); [islossless | auto=> /#].
by wp; while true (4 - i); [move=> z; wp; call (: true); [islossless | auto=> /#] | auto=> /#].
qed.

lemma polynomial__invert_ntt_montgomery_correct (_a : W32.t Array256.t) :
    hoare [ M.polynomial__invert_ntt_montgomery :
        polynomial = _a /\ wpoly_intt_irng _a
        ==>
        lifts_wpoly res = invntt (liftm_wpoly _a) /\
        wpoly_srng invntt_obound invntt_obound res
    ].
proof.
conseq (polynomial__invert_ntt_montgomeryP _a) => /> hrng.
have [_ ->] // := intt_link _a q _ _ _ => //; 1: by rewrite -srng_cbnd.
by split; [| exact ifinal_rng].
qed.

lemma polynomial__invert_ntt_montgomery_ph (_a : W32.t Array256.t) :
    phoare [ M.polynomial__invert_ntt_montgomery :
        polynomial = _a /\ wpoly_intt_irng _a
        ==>
        lifts_wpoly res = invntt (liftm_wpoly _a) /\
        wpoly_srng invntt_obound invntt_obound res
    ] = 1%r
  by conseq polynomial__invert_ntt_montgomery_ll
            (polynomial__invert_ntt_montgomery_correct _a).

end CommonInvertNttT.
