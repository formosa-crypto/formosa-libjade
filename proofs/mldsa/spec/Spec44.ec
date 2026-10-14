require import AllCore IntDiv List.
require import Parameters.
require MLDSA.

(* The ML-DSA-44 parameters. kappa_max, the bound on the signing
   attempts, stays abstract, with its axiom. *)
clone Parameters.ParamsT as Params44 with
  op tau        = 39,
  op lambda     = 128,
  op gamma1_log = 17,
  op gamma2_div = 88,
  op kvec       = 4,
  op lvec       = 4,
  op Eta        = 2,
  op w_hint     = 80
proof param_sets by done.

(* The ML-DSA specification at these parameters *)
clone MLDSA.MLDSAT as MLDSA44 with
  op tau        = Params44.tau,
  op lambda     = Params44.lambda,
  op gamma1_log = Params44.gamma1_log,
  op gamma2_div = Params44.gamma2_div,
  op kvec       = Params44.kvec,
  op lvec       = Params44.lvec,
  op Eta        = Params44.Eta,
  op w_hint     = Params44.w_hint,
  op kappa_max  = Params44.kappa_max
proof param_sets by exact Params44.param_sets,
      kappa_max_bnd by exact Params44.kappa_max_bnd.
