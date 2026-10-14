require import AllCore IntDiv List.
require import Parameters.
require MLDSA.

(* The ML-DSA-65 parameters. kappa_max, the bound on the signing
   attempts, stays abstract, with its axiom. *)
clone Parameters.ParamsT as Params65 with
  op tau        = 49,
  op lambda     = 192,
  op gamma1_log = 19,
  op gamma2_div = 32,
  op kvec       = 6,
  op lvec       = 5,
  op Eta        = 4,
  op w_hint     = 55
proof param_sets by done.

(* The ML-DSA specification at these parameters *)
clone MLDSA.MLDSAT as MLDSA65 with
  op tau        = Params65.tau,
  op lambda     = Params65.lambda,
  op gamma1_log = Params65.gamma1_log,
  op gamma2_div = Params65.gamma2_div,
  op kvec       = Params65.kvec,
  op lvec       = Params65.lvec,
  op Eta        = Params65.Eta,
  op w_hint     = Params65.w_hint,
  op kappa_max  = Params65.kappa_max
proof param_sets by exact Params65.param_sets,
      kappa_max_bnd by exact Params65.kappa_max_bnd.
