require import AllCore.
from Spec require InnerPKE_Op.

(* The ML-KEM-768 parameters, with the specification and its properties *)
clone InnerPKE_Op.InnerPKE_OpT as MLKEM768 with
  op kvec = 3,
  op du   = 10,
  op dv   = 4,
  op eta1 = 2,
  op eta2 = 2
proof param_sets by done.
