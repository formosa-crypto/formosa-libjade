require import AllCore.
from Spec require Parameters InnerPKE_Op.

(* The ML-KEM-1024 parameters *)
clone Parameters.ParamsT as Params1024 with
  op kvec = 4,
  op du   = 11,
  op dv   = 5,
  op eta1 = 2,
  op eta2 = 2
proof param_sets by done.

(* The specification and its properties at these parameters *)
clone InnerPKE_Op.InnerPKE_OpT as MLKEM1024 with
  op kvec = Params1024.kvec,
  op du   = Params1024.du,
  op dv   = Params1024.dv,
  op eta1 = Params1024.eta1,
  op eta2 = Params1024.eta2
proof param_sets by exact Params1024.param_sets.
