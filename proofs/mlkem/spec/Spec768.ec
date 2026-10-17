require import AllCore.
from Spec require Parameters InnerPKE_Op.

(* The ML-KEM-768 parameters *)
clone Parameters.ParamsT as Params768 with
  op kvec = 3,
  op du   = 10,
  op dv   = 4,
  op eta1 = 2,
  op eta2 = 2
proof param_sets by done.

(* The specification and its properties at these parameters *)
clone InnerPKE_Op.InnerPKE_OpT as MLKEM768 with
  op kvec = Params768.kvec,
  op du   = Params768.du,
  op dv   = Params768.dv,
  op eta1 = Params768.eta1,
  op eta2 = Params768.eta2
proof param_sets by exact Params768.param_sets.
