require Spec65 MLDSA_Security.

(* The security proof of ML-DSA-65: the generic chain of spec/properties
   instantiated on the specification MLDSA65 (the instance used by the
   implementation proofs). *)
clone MLDSA_Security.MLDSA_Security as Sec65 with
  theory Spec <- Spec65.MLDSA65.
