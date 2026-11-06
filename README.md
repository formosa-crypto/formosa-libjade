# Libjade

Libjade is a formally verified cryptographic library written in the
[Jasmin](https://github.com/jasmin-lang/jasmin) programming language, with
machine-checked proofs in [EasyCrypt](https://github.com/EasyCrypt/easycrypt).
Libjade is part of [Formosa Crypto](https://formosa-crypto.org). Its focus is
high-assurance implementations of the NIST post-quantum standards.

## Assurance

Libjade aims to be on par with other cryptographic libraries with respect to common
validation techniques for basic safety and correctness properties: the CI checks the
code for known-answer tests for correctness/compliance and Valgrind for memory
safety.

We use *high-assurance* to mean that machine-checked proofs come on top of the above
validation steps. [ASSURANCE.md](docs/assurance.md) explains in more detail what
properties the machine-checked proofs establish and under what assumptions (i.e.,
what is the Trusted Code Base).

In particular, [ASSURANCE.md](docs/assurance.md) clarifies the meaning of the
following terms used in this README:

- [Validation](docs/assurance.md#validation): [KAT](docs/assurance.md#kat),
  [Memcheck](docs/assurance.md#memcheck)
- [High assurance](docs/assurance.md#high-assurance)
- [End-to-end proofs](docs/assurance.md#end-to-end-proofs):
  [security of the specification](docs/assurance.md#security-of-the-specification),
  [correctness](docs/assurance.md#correctness),
  [compilation](docs/assurance.md#compilation), [safety](docs/assurance.md#safety),
  [CT and SCT](docs/assurance.md#ct-and-sct), [ProvSec](docs/assurance.md#provsec)
- [Trusted computing base](docs/assurance.md#trusted-computing-base)

## Algorithms

Each algorithm has an EasyCrypt specification of its standard, with the security
theorem of the specification, stated once for all parameter sets and instantiated
for each set it covers:

- ML-KEM (FIPS 203), parameter sets 512, 768 and 1024:
  [MLKEM.ec](proofs/mlkem/spec/MLKEM.ec); IND-CCA in the ROM
  ([MLKEMSecurity.ec](proofs/mlkem/spec/properties/MLKEMSecurity.ec)), for 768
  ([Security768.ec](proofs/mlkem/spec/properties/Security768.ec)) and 1024
  ([Security1024.ec](proofs/mlkem/spec/properties/Security1024.ec));
- ML-DSA (FIPS 204), parameter sets 44, 65 and 87:
  [MLDSA.ec](proofs/mldsa/spec/MLDSA.ec); EUF-CMA in the ROM, hedged signing, with
  leakage ([MLDSA_Security.ec](proofs/mldsa/spec/properties/MLDSA_Security.ec)), for
  44, 65 and 87 (`Security<set>.ec` in the same directory).

SHA-3 (FIPS 202) is available as building blocks under
`src/fips202/<target>/common/`; the self-contained one-shot functions and incremental
APIs are planned but not exported yet.

## Assembly files

Each implementation is a self-contained assembly file and an accompanying C header:

```
asm/<algorithm>/<target>/<algorithm><parameter set>_<target>_<profile>.s
src/include/<algorithm><parameter set>.h
```

The assembly is compiled from
`src/<algorithm>/<target>/<profile>/<parameter set>/` by `make -C src extract-asm`;
CI fails if a committed file differs from the assembly it compiles.

## Implementations

An implementation of an algorithm is fixed by two choices:

- its **target**, the instruction set it runs on: `avx2` is x86-64 with AVX2;
- its **profile**, what it is optimised for beyond computing the right result:
  `sct` is optimised for speed and protected against timing side channels, with
  [CT and SCT](docs/assurance.md#ct-and-sct) countermeasures.

Every algorithm has one implementation, `avx2` / `sct`, with its sources in
`src/<algorithm>/avx2/sct/`.

### Claims

Each parameter set of an implementation states what it guarantees in
`src/<algorithm>/<target>/<profile>/<parameter set>/meta.toml`:

```toml
claims  = ["kat", "memcheck", "ct", "sct", "safety", "correctness"]
provsec = "functional"
```

- `kat`, `memcheck`, `ct` and `sct` are checks: the CI runs each of them on the
  implementations that claim it, and only on them.
- `safety` and `correctness` are proofs: each has its evidence in
  `proofs/<algorithm>/<target>/<profile>/<property>/<parameter set>/meta.toml`, the
  EasyCrypt lemma that proves it for each operation of the algorithm, stated for the
  parameter set in that directory:

  ```toml
  keygen = { file = "correctness65.ec", lemma = "keygen_correct" }
  sign   = { file = "correctness65.ec", lemma = "sign_correct" }
  verify = { file = "correctness65.ec", lemma = "verify_correct" }
  ```

- `provsec` is the [ProvSec](docs/assurance.md#provsec) kind of the implementation.

`scripts/claims.py` checks the claims on every pull request: every entry point of
`src/` has its `meta.toml`, every proved claim has the lemma of each operation, in a
file that the proofs CI checks, and `functional` has the correctness proof and the
instance of the security theorem of the specification for the parameter set.

## API and ABI

The assembly follows the System V AMD64 ABI, in AT&T syntax, for Linux (ELF). Target
`avx2` runs on x86-64 with AVX2.

The API follows libsodium and NaCl: objects are byte arrays passed by pointer, and
the header gives their sizes. The functions take their randomness as an argument.
The exported functions of each algorithm, with `<p>` the parameter set:

- ML-KEM, `jade_kem_mlkem_mlkem<p>_amd64_avx2_<function>`:
  - `keypair_derand`: key generation from 64 bytes of coins (Algorithm 16 in
    FIPS 203). Returns 0.
  - `enc_derand`: modulus check of the public key (Section 7.2 in FIPS 203), then
    encapsulation with 32 bytes of coins (Algorithm 17 in FIPS 203). Returns 0, or
    -1 with an all-zero ciphertext and shared secret when the check fails.
  - `dec`: hash check of the secret key (Section 7.3 in FIPS 203), then
    decapsulation (Algorithm 18 in FIPS 203). Returns 0, or -1 with an all-zero
    shared secret when the check fails.
  - `check_pk`: modulus check of the public key (Section 7.2 in FIPS 203).
    Returns 0, or -1 when the check fails.
  - `check_sk`: hash check of the secret key (Section 7.3 in FIPS 203). Returns
    0, or -1 when the check fails.
- ML-DSA, `ml_dsa_<p>_<function>`:
  - `keygen`: key generation from 32 bytes of randomness (Algorithm 6 in
    FIPS 204). No return value.
  - `sign`: signature of a message with a context and 32 bytes of randomness
    (Algorithm 2 in FIPS 204). Returns 0; -1 when the context is longer than 255
    bytes; -1 with an all-zero signature when the signing loop reaches its
    iteration bound.
  - `verify`: verification of a signature on a message with a context
    (Algorithm 3 in FIPS 204). Returns 0 when the signature verifies, -1 when the
    context is longer than 255 bytes, and a nonzero value otherwise.

The caller may pass unaligned pointers, but must adhere to the following restrictions:
- pass memory regions that do not overlap;
- avoid data races on the memory regions passed to a call.

Jasmin has no global mutable variables, so the code keeps no state between calls, and
concurrent calls are thread safe under the rules above.

The headers are not verified: the proofs are about the Jasmin functions, and the C
declarations of `src/include/` are part of the trusted computing base.

## Validation

CI runs these checks on every pull request and every commit on `main`
([checks.yml](.github/workflows/checks.yml)):

- KAT: the known-answer tests of the parameter set (`bench/vectors/`), from NIST ACVP
  and post-quantum-cryptography/KAT;
- memcheck: Valgrind's memcheck on every operation;
- CT and SCT: `jasmin-ct` on the entry point;
- extraction: the committed EasyCrypt models and assembly are the extraction of
  `src/`, and the claims are consistent (`scripts/claims.py`, see
  [Claims](#claims)).

KAT, memcheck, CT and SCT run on the implementations that claim them
([scripts/checks.py](scripts/checks.py)).

[Checks dashboard](https://formosa-crypto.github.io/formosa-libjade-results/#/checks): the results of
every commit on `main`.

## Performance

[Results dashboard](https://formosa-crypto.github.io/formosa-libjade-results/): proof-checking times
and cycle benchmarks for every commit on `main`.

## Contributors

See [CONTRIBUTORS.md](CONTRIBUTORS.md).
