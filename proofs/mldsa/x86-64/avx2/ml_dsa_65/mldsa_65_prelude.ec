require import AllCore List IntDiv.

from Spec require import GFq Rq Parameters MLDSA_W32_Rep.
from Spec require import Spec65.
import MLDSA65.

from JazzEC require import Array256 Array1280 Array1536.

import LArray KArray.

lemma mldsa65_lvec : lvec = 5 by done.
lemma mldsa65_kvec : kvec = 6 by done.
lemma mldsa65_lambda : lambda = 192 by done.
lemma mldsa65_gamma1 : gamma1 = 524288 by done. (* 2**19 *)
lemma mldsa65_Eta : Eta = 4 by done.
lemma mldsa65_tau : tau = 49 by done.
lemma mldsa65_gamma1_log : gamma1_log = 19 by done.
lemma mldsa65_gamma2_div : gamma2_div = 32 by done.
hint simplify mldsa65_gamma1_log, mldsa65_gamma2_div.

op  lvec_unflatten256(a : 'a Array1280.t) =
     LArray.init (fun i => Array256.of_list witness (sub a (256*i) 256)).

op  kvec_unflatten256(a : 'a Array1536.t) =
     KArray.init (fun i => Array256.of_list witness (sub a (256*i) 256)).
