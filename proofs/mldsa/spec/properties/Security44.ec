require Spec44 MLDSA_Security.

(* The security proof of ML-DSA-44: the generic chain of spec/properties
   instantiated on the specification MLDSA44 (the instance used by the
   implementation proofs). *)
clone MLDSA_Security.MLDSA_Security as Sec44 with
  theory Spec <- Spec44.MLDSA44.
