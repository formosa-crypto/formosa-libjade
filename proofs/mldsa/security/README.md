# Security proof of the target specification

Proof that the target security specification of ML-DSA (`MLDSATarget.ec`:
the scheme with its leakage, the EF-CMA game with the random oracles and
the query counters) is secure against quantum adversaries in the random
oracle model, by reduction to MLWE and SelfTargetMSIS through the
Fiat-Shamir-with-aborts chain (`MLDSAProof.ec`, theorem `MLDSA_secure`).
The design of the leakage model and of the reduction is described in
`DESIGN.md`. The proof is instantiated on the FIPS 204 ring and parameters
in `../spec/properties/MLDSATargetFIPS.ec` and composed with the reduction
of the FIPS 204 specification to the target in `../spec/properties`.
