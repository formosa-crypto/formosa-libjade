require Spec44 MLDSA_Security.

(* The security of ML-DSA-44: the theorem mldsa_secure of the generic
   theory MLDSA_Security (EUF-CMA in the ROM, hedged signing, with leakage),
   instantiated on the specification MLDSA44 (the instance used by the
   implementation proofs). *)
clone MLDSA_Security.MLDSA_Security as Sec44 with
  theory Spec <- Spec44.MLDSA44.
