require import AllCore List.
from Jasmin require import JModel_x86.
from Spec require import GFq Rq Parameters MLDSA_W32_Rep.
require import Array64 Array256.
require BaseT PreludeT.

(* The samplers of the secret vectors, of the mask and of the challenge.
   Their code depends on the set (Eta, gamma1, tau and the sizes of the
   vectors): their correctness is a hypothesis of this theory, proved for
   each set. *)
abstract theory SamplersT.

clone import BaseT.BaseT as B.
import S R MLDSAParams.
clone import PreludeT.PreludeT as PR with theory B <= B.

import PolyLVec PolyKVec PolyMat.
import Round ZModQ Zq.

axiom error_vectors_correct _rho :
  phoare [ M.sample____error_vectors : arg = _rho ==>
       lifts_wpolylvec (lvec_unflatten256 res.`1)
         = (expandS (Bytes64.of_list (Array64.to_list _rho))).`1
    /\ wpolylvec_srng (lvec_unflatten256 res.`1) Eta Eta
    /\ lifts_wpolykvec (kvec_unflatten256 res.`2)
         = (expandS (Bytes64.of_list (Array64.to_list _rho))).`2
    /\ wpolykvec_srng (kvec_unflatten256 res.`2) Eta Eta
  ] = 1%r.

(* The 16-bit separator must not wrap: the signing loop keeps it below
   65536 - lvec. *)
axiom mask_correct _seed _dom :
  equiv [ ExpandMask.sample ~ M.sample____mask :
       arg{1}.`1 = Bytes64.of_list (Array64.to_list _seed)
    /\ arg{1}.`2 = W16.to_uint _dom
    /\ arg{2}.`1 = _seed
    /\ arg{2}.`2 = _dom
    /\ W16.to_uint _dom + lvec < 65536
    ==>
       lifts_wpolylvec (lvec_unflatten256 res{2}.`1) = res{1}
    /\ wpolylvec_srng (lvec_unflatten256 res{2}.`1) (gamma1 - 1) gamma1
    /\ W16.to_uint res{2}.`2 = W16.to_uint _dom + lvec
  ].

axiom sample_challenge_correct :
  equiv [ SampleInBall(MLDSA_XOF_SIB).sample ~ M.sample____challenge :
       arg{1} = BytesCT.of_list (Array_ctilde.to_list arg{2}.`2)
    ==>
       lifts_wpoly res{2} = res{1}.`1 /\ wpoly_srng 1 1 res{2}
  ].

end SamplersT.
