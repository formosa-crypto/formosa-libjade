require Spec87 MLDSA_Security.

(* The security of ML-DSA-87: the theorem mldsa_secure of the generic
   theory MLDSA_Security (EUF-CMA in the ROM, hedged signing, with leakage),
   instantiated on the specification MLDSA87 (the instance used by the
   implementation proofs). *)
clone MLDSA_Security.MLDSA_Security as Sec87 with
  theory Spec <- Spec87.MLDSA87.
