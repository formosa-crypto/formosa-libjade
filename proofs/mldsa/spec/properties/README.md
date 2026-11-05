# Security proof of the ML-DSA specification

`mldsa_euf_cma` (MLDSA_ROSep_Hop18.ec) reduces the EUF-CMA security of the
FIPS 204 scheme with hedged signing, SHAKE256 and SHAKE128 modelled as two
random oracles (`MLDSA_RO`, `MLDSA_ROSep`), to the security of the target
specification `MLDSATarget` (`security/`), through eighteen game hops.
`mldsa_secure` (MLDSA_Security.ec) composes it with the security proof of
the target (`security/MLDSAProof.ec`, instantiated on the FIPS 204 ring
and parameters in MLDSATargetFIPS.ec as `MP`, the target being `MP.T`):
the advantage against the specification is bounded by MLWE,
SelfTargetMSIS, the Fiat-Shamir-with-aborts terms and the collision terms
of the hash functions.

The specification and the hops use the flat leakage model of
`security/utils/Leakage.ec`: the trace of a signing is the `lcat` of the
declassified values (the NTT representation of t0, then per iteration the
pairs (position, byte) of the SampleInBall rejection loop, the NTT
representation of c, and the index of the first failing polynomial of each
rejection test, see spec/MLDSA.ec). The target's trace is the same, so
hops 15 and 16 are plain equalities of leakage.

The proof is generic in the parameter set. Every file is an abstract theory
and the files form a single chain of `clone include`:

    MLDSA_ExpandS -> MLDSATargetFIPS -> MLDSA_RO -> MLDSA_ROSep
                  -> MLDSA_ROSep_Hop1 -> ... -> MLDSA_ROSep_Hop18
                  -> MLDSA_Security

The first link clones the specification as the nested theory `Spec`
(`clone MLDSA.MLDSAT as Spec`): the parameters tau, lambda, gamma1_log,
gamma2_div, kvec, lvec, Eta, w_hint stay abstract, constrained by the axiom
`param_sets` (`Parameters.ec`), and the proofs reason by cases on the three
sets where needed (`gamma1_cases`, `gamma2_cases`, `eta_cases`, ...).

`Security44.ec`, `Security65.ec` and `Security87.ec` instantiate the whole
chain on the specification instances `MLDSA44`, `MLDSA65` and `MLDSA87`
(`Spec44.ec`, ...), the ones the implementation proofs (`x86-64/`) are
stated against:

    clone MLDSA_Security.MLDSA_Security as Sec65 with
      theory Spec <- Spec65.MLDSA65.

Since the chain is one namespace, a name must be defined by one file only;
the few lemmas of `MLDSA_RO` that share a name with lemmas of the
specification carry the suffix `_O` (`SampleInBall_O_ll`, ...).
