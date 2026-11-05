require Spec87 MLDSA_Security.

(* The security proof of ML-DSA-87: the generic chain of spec/properties
   instantiated on the specification MLDSA87 (the instance used by the
   implementation proofs). *)
clone MLDSA_Security.MLDSA_Security as Sec87 with
  theory Spec <- Spec87.MLDSA87.
