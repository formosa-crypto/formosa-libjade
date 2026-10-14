require import AllCore IntDiv List.
require import Parameters.
require MLDSA.

(* The ML-DSA-87 parameters. kappa_max, the bound on the signing
   attempts, stays abstract, with its axiom. *)
clone Parameters.ParamsT as Params87 with
  op tau        = 60,
  op lambda     = 256,
  op gamma1_log = 19,
  op gamma2_div = 32,
  op kvec       = 8,
  op lvec       = 7,
  op Eta        = 2,
  op w_hint     = 75
proof param_sets by done.

(* The ML-DSA specification at these parameters *)
clone MLDSA.MLDSAT as MLDSA87 with
  op tau        = Params87.tau,
  op lambda     = Params87.lambda,
  op gamma1_log = Params87.gamma1_log,
  op gamma2_div = Params87.gamma2_div,
  op kvec       = Params87.kvec,
  op lvec       = Params87.lvec,
  op Eta        = Params87.Eta,
  op w_hint     = Params87.w_hint,
  op kappa_max  = Params87.kappa_max
proof param_sets by exact Params87.param_sets,
      kappa_max_bnd by exact Params87.kappa_max_bnd.
