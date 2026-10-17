require import AllCore.
from Spec require InnerPKE_Op.

(* The ML-KEM-1024 parameters, with the specification and its properties *)
clone InnerPKE_Op.InnerPKE_OpT as MLKEM1024 with
  op kvec = 4,
  op du   = 11,
  op dv   = 5,
  op eta1 = 2,
  op eta2 = 2
proof param_sets by done.
