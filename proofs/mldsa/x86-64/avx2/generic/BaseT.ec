require import AllCore.
require MLDSA MldsaT.

(* The parameter of every generic proof theory of the implementation: the
   specification S at abstract parameters, and the generic model R of the
   implementation at the same parameters. A parameter set instantiates it
   with its specification and its model instance. *)
abstract theory BaseT.

clone import MLDSA.MLDSAT as S.
clone import MldsaT.MldsaT as R with theory P <- S.

end BaseT.
