(* The bundle the generic AVX2 proofs are stated over: the specification
   at abstract parameters (S), and the generic model of the implementation
   at the same parameters (R).  Each parameter set instantiates it with
   its specification instance and its model instance. *)
require import AllCore.
from Spec require InnerPKE_Op.
require JkemT.

abstract theory BaseT.

clone import InnerPKE_Op.InnerPKE_OpT as S.
clone import JkemT.JkemT as R with theory P <- S.

end BaseT.
