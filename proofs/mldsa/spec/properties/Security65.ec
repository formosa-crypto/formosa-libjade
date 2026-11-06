require Spec65 MLDSA_Security.

(* The security of ML-DSA-65: the theorem mldsa_secure of the generic
   theory MLDSA_Security (EUF-CMA in the ROM, hedged signing, with leakage),
   instantiated on the specification MLDSA65 (the instance used by the
   implementation proofs). *)
clone MLDSA_Security.MLDSA_Security as Sec65 with
  theory Spec <- Spec65.MLDSA65.
