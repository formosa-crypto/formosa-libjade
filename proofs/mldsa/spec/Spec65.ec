require import AllCore IntDiv List.
require import Parameters.
require MLDSA.

(* The ML-DSA-65 parameters *)
op tau    : int = 49.
op lambda : int = 192.
op gamma1 : int = 2 ^ 19.
op gamma2 : int = (q - 1) %/ 32.
op kvec   : int = 6.
op lvec   : int = 5.
op Eta    : int = 4.
op w_hint : int = 55.

(* The ML-DSA specification at these parameters. kappa_max, the bound on
   the signing attempts, stays abstract, with its axiom. *)
clone MLDSA.MLDSAT as MLDSA65 with
  op tau    <- tau,
  op lambda <- lambda,
  op gamma1 <- gamma1,
  op gamma2 <- gamma2,
  op kvec   <- kvec,
  op lvec   <- lvec,
  op Eta    <- Eta,
  op w_hint <- w_hint
proof param_sets by rewrite /tau /lambda /gamma1 /gamma2 /kvec /lvec /Eta /w_hint.
