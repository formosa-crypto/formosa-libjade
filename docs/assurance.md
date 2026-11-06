# Assurance

Libjade aims to be on par with other cryptographic libraries with respect to common
validation techniques for basic safety and correctness properties: the CI checks the
code for known-answer tests for correctness/compliance and Valgrind for memory
safety.

We use *high-assurance* to mean that machine-checked proofs come on top of the above
validation steps. This document explains in more detail what properties the
machine-checked proofs establish and under what assumptions (i.e., what is the
Trusted Code Base).

## Validation

Libjade is a software library. CI validates every implementation with standard
techniques, on every pull request and every commit on `main`, in the `KAT and
memcheck` step of `.github/workflows/checks.yml`.

### KAT

The known-answer tests of `bench/vectors/` run against the assembly of every
parameter set (`bench/tools/import_kat.py` downloads them at a fixed version):

- the NIST ACVP vectors, the ML-KEM encapsulation and decapsulation key checks
  included;
- the KAT files of
  [post-quantum-cryptography/KAT](https://github.com/post-quantum-cryptography/KAT):
  ML-DSA key generation and hedged signing; ML-KEM key generation, encapsulation and
  decapsulation, of a valid and of an invalid ciphertext (implicit rejection).

### Memcheck

Valgrind's memcheck runs every operation of every parameter set on heap buffers of
the exact size of the arguments (`bench/memcheck.c`): memcheck reports any access
outside the arguments, and the driver checks that the outputs are fully initialised.
The inputs cover the paths of the API: decapsulation of a valid and of a modified
ciphertext, the key checks, signing and verification with messages and contexts of
several lengths, and verification of a modified signature.

## High assurance

High assurance means formal methods on top of the validation, to strengthen
confidence in the guarantees of the library.

## End-to-end proofs

Libjade implementations are supported by end-to-end machine-checked proofs that
relate the security of the Jasmin implementation to that of a machine-checked
security proof for the specification. Intuitively, this end-to-end argument is
constructed via several theorems and type-based checks that aim to exclude a wide class
of potential flaws in the generated assembly code, ranging from the interpretation
of the standard to low level side-channel countermeasures:

- the provable security theorem for the standard specification proved in EasyCrypt;
- the safety proof for a model of the Jasmin program in EasyCrypt, which guarantees
  absence of undefined behaviors and applicability of the Jasmin compiler correctness
  theorem;
- the functional correctness proof for the Jasmin code wrt the standard specification
  and a game-based security proof for a model of the Jasmin program in EasyCrypt;
- the Jasmin compiler correctness proof in Rocq;
- the type-based checking for CT and SCT provided by the Jasmin compiler.

Under some assumptions listed below in the [TCB](#trusted-computing-base) section,
these theorems jointly provide assurance that the advantage of an adversary
interacting with the assembly implementation in a well defined game-based model
(possibly including a model of timing leakage) is bounded by a provable security
theorem.

We note that the game-based security model described above is a coarse model of how
assembly code is actually used in practice, which ignores several aspects such as the
encoding into binary code, potential adversarial access to memory, etc., which means
that many practical attacks may circumvent the guarantees provided by the above
end-to-end result.

### Security of the specification

An EasyCrypt theorem bounds the advantage of any adversary against a security notion
of the EasyCrypt specification (for example IND-CCA in the random-oracle model) by
the advantages of adversaries against hardness assumptions (for example MLWE). The
security proof gives confidence that the specification is a sound reading of the
standard, at least with respect to security. For some algorithms, the security game
also gives the adversary a leakage trace of the specification.

### Correctness

For every algorithm entry point, an EasyCrypt equivalence (a pRHL judgement) relates the
model of the Jasmin function, extracted by `jasmin2ec`, to the procedure of the
specification: on inputs that encode the same values, the two procedures return outputs
that encode the same values, and the return code of the Jasmin function matches the
result of the specification (for example the failure of a key check). The precondition
of each equivalence states the assumptions on the inputs, for example the bounds of a
message in memory. The exported functions wrap the Jasmin functions of the equivalences
with the initialisation of the misspeculation flag and, for ML-DSA, the check of the
context length; the correctness proofs do not cover these wrappers.

### Compilation

- The Jasmin compiler preserves the semantics of the source program; the proof is
  checked in Rocq.
- The compiler preserves constant time: control flow and memory accesses that do not
  depend on secrets in the source do not depend on secrets in the assembly (not
  machine-checked for the current compiler version).

### Safety

An EasyCrypt proof that no execution of an exported function accesses memory out of
bounds, reads uninitialised data or reaches undefined behaviour, and that it
initialises its outputs. The proof is a `hoare` judgement on the model extracted by
`jasmin2ec`: it does not cover termination.

### CT and SCT

Constant time (CT): no secret input of a function influences the control flow of an
execution or the addresses of its memory accesses. Values that the code explicitly
declassifies, for example the outcome of a rejection-sampling test, count as public.

Speculative constant time (SCT): CT also holds for executions in which the processor
mispredicts conditional branches (Spectre v1). The code establishes SCT with selective
speculative load hardening: a misspeculation flag, initialised at the entry of each
exported function, masks the values that could leak during misspeculation.

`jasmin-ct` checks the Jasmin source of every exported function for CT and SCT. The
annotations of the exported functions state which arguments are secret. Both checks
run with `--doit`: secret values (for SCT, transient ones too) only reach
instructions of Intel's data operand independent timing (DOIT) list.

### ProvSec

The connection between the Jasmin implementation and the security notion of the
specification. A ProvSec claim is one of three kinds, by increasing order of
guarantees:

- **functional**: the correctness proof of the implementation and the security
  theorem of the specification for the parameter set are stated and proved, but no
  EasyCrypt theorem states that the two imply the security of the Jasmin
  implementation in a game-based model (this is implicit, and so it is possible
  that the functional correctness results may not be capturing the full set
  of behaviors required for a reduction).
- **reduction**: an EasyCrypt theorem states the security of the Jasmin
  implementation in a game-based model (possibly with some carved out idealized
  components) by a reduction from the security of the specification.
- **leakage-aware reduction**: same as reduction, but here the game-based model
  provides to the adversary the constant-time leakage (including declassified data)
  of the implementation.

## Trusted computing base

The high-assurance guarantees libjade provides rely on the following Trusted Code Base
assumptions:

- the EasyCrypt specification of each algorithm, as a faithful transcription of the
  standard;
- soundness of EasyCrypt, the SMT solvers that EasyCrypt calls (Z3, CVC5), and Rocq;
- `jasmin2ec`, which translates the Jasmin code into the EasyCrypt models that the
  correctness and safety proofs refer to;
- the Jasmin EasyCrypt library (`eclib`), which models the Jasmin semantics in EasyCrypt
  and, in particular, the assumption that whatever is proved in EasyCrypt about the
  model of an extracted Jasmin program model wrt `eclib` transfers to the same meaning
  under the Jasmin semantics in Rocq and, consequently, that it transfers to assembly
  code via the Jasmin compiler correctness theorem.
- the parts of the Jasmin compiler outside the Rocq proof (the front end, which parses
  and type-checks the source, and the printer of the assembly text), the assembler and
  the linker are assumed to soundly interact with the formal Rocq theorem;
- the CT and SCT checks performed by `jasmin-ct` are trusted to guarantee that the
  abstract leakage generated by a Jasmin program is independent from secrets; the
  leakage model itself is not assumed to be a faithful model of reality, but good enough
  to guarantee that the best practices in protection against timing attacks are
  correctly deployed.
- the C headers of `src/include/`, which declare the C API of the assembly are assumed
  to correctly expose the Jasmin code entry points;
- the x86-64 semantics of the Jasmin model, with respect to the processor, are assumed
  to be faithful to the functionality of the architecture.
