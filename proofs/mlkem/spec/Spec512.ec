require import AllCore.
from Spec require Parameters InnerPKE_Op.

(* The ML-KEM-512 parameters *)
clone Parameters.ParamsT as Params512 with
  op kvec = 2,
  op du   = 10,
  op dv   = 4,
  op eta1 = 3,
  op eta2 = 2
proof param_sets by done.

(* The specification and its properties at these parameters *)
clone InnerPKE_Op.InnerPKE_OpT as MLKEM512 with
  op kvec = Params512.kvec,
  op du   = Params512.du,
  op dv   = Params512.dv,
  op eta1 = Params512.eta1,
  op eta2 = Params512.eta2
proof param_sets by exact Params512.param_sets.
