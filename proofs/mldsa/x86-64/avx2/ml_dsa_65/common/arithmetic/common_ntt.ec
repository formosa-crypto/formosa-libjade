require import AllCore List IntDiv RealExp.

from Jasmin require import JModel_x86.

from JazzEC require import Ml_dsa_65_avx2 Mldsa_65_prelude.

from Spec require import GFq Rq Parameters MLDSA_W32_Rep.
from Spec require import Spec65.
import MLDSA65.

require Fnttcorrect.
require import Nttlink.

import Round ZModQ Zq.

require import Array256.

(* ================================================================== *)
(* polynomial__ntt                                                      *)
(* Computes the forward NTT of a polynomial.                           *)
(* Input:  wpoly_ntt_irng _a  (|x| < q)                               *)
(* Output: lifts_wpoly res = ntt (lifts_wpoly _a)                     *)
(*         wpoly_ntt_orng res (|x| < 9q: each of the 8 layers adds q)  *)
(* ================================================================== *)

lemma polynomial__ntt_round_ll : islossless M.polynomial__ntt_round.
proof.
proc; while true (bound - i); last by auto=> /#.
by move=> z; wp; call (: true); [islossless | auto=> /#].
qed.

lemma polynomial__ntt_ll : islossless M.polynomial__ntt.
proof.
proc; islossless; (while true (16 - i); [
  by move=> z; wp; (call polynomial__ntt_round_ll || (call (: true); 1: by islossless)); auto=> /# |
  by auto=> /#]).
qed.

lemma polynomial__ntt_correct (_a : W32.t Array256.t) :
    hoare [ M.polynomial__ntt :
        polynomial = _a /\ wpoly_ntt_irng _a
        ==>
        lifts_wpoly res = ntt (lifts_wpoly _a) /\
        wpoly_ntt_orng res
    ].
proof.
conseq (Fnttcorrect.polynomial__nttP _a) => /> hrng.
have [hb ->] // := ntt_link _a (q-1) _ _ _ => //; 1: by rewrite -srng_cbnd.
by rewrite /wpoly_ntt_orng srng_cbnd (_ : 9 * q - 1 = q - 1 + 8 * q).
qed.

lemma polynomial__ntt_ph (_a : W32.t Array256.t) :
    phoare [ M.polynomial__ntt :
        polynomial = _a /\ wpoly_ntt_irng _a
        ==>
        lifts_wpoly res = ntt (lifts_wpoly _a) /\
        wpoly_ntt_orng res
    ] = 1%r
  by conseq polynomial__ntt_ll (polynomial__ntt_correct _a).
