# Jasmin Keccak Code Package (JKCP)

Jasmin implementation of the Keccak-f[1600] permutation and the FIPS 202
(SHA-3 / SHAKE) sponge construction, organised as a reusable Jasmin library
(`Keccak` namespace, mapped to this directory via `JASMINPATH`).


## Directory layout

```
fips202/
  common/                  Platform-independent definitions
    keccak1600_generic.jinc       Feature flags, standard rates, trail bytes,
                                  utility shifts, keccak_state type (u64[25])
    keccakf1600_generic.jinc      Permutation selection constants, round
                                  constants, rho offsets
    keccakf1600x4_generic.jinc    4-way pack/unpack (u64[25] <-> u256[25]),
                                  ROL8/ROL56 tables
    keccak1600_default.jinc       Default KECCAK_FEATURES and KECCAK_PERMUTATION
    keccak1600_updstate_generic.jinc  keccak_updstate type (u64[26]) and
                                      status-word decoder
    subreadwrite_imem.jinc        Fixed- and variable-length memory read/write
    subreadwrite_ASIZE.jinc       Fixed- and variable-length array read/write
                                  (parameterised by _ASIZE)

  ref/common/              Single-lane (scalar) implementations
    keccakf1600_ref.jinc          Permutation: textbook (feature-gated BMI/BMI2)
    keccakf1600_basic.jinc        Permutation: lane-complementing (s2n-bignum port)
    keccakf1600_opt.jinc          Permutation: clang -O3 of XKCP (BMI+BMI2)
    keccakf1600.jinc              Dispatch (_keccakf1600) by KECCAK_PERMUTATION
    keccak1600.jinc               State init, add-rate-bit
    keccak1600_fixedsizes.jinc    Fixed-size absorb/squeeze (memory-based)
    keccak1600_fixedsizes_ASIZE.jinc  Fixed-size absorb/squeeze (array-based)
    keccak1600_updstate.jinc      Streaming init/absorb/squeeze (memory-based)
    keccak1600_updstate_ASIZE.jinc    Streaming init/absorb/squeeze (array-based)
    keccak1600_updstate_export.jinc   C-ABI exports of updstate (memory-based)
    keccak1600_updstate_ASIZE_export.jinc  C-ABI exports of updstate (array-based)

  avx2/common/             AVX2-accelerated implementations
    keccakf1600.jinc              Single-lane permutation on AVX2 registers
    keccakf1600x4.jinc            4-way dispatch by KECCAK_PERMUTATION
    keccakf1600x4_ref.jinc        4-way permutation: reference
    keccakf1600x4_alt.jinc        4-way permutation: alternative scheduling
    keccakf1600x4_nat.jinc        4-way permutation: native (mlkem-native port)
    keccak1600.jinc               AVX2 register-resident state (u256[7])
    keccak1600x4.jinc             4-way state init, add-rate-bit
    keccak1600_fixedsizes.jinc    Fixed-size absorb/squeeze (memory, AVX2 state)
    keccak1600_fixedsizes_ASIZE.jinc  Fixed-size absorb/squeeze (array, AVX2 state)
    keccak1600x4_fixedsizes.jinc      4-way fixed-size (memory-based)
    keccak1600x4_fixedsizes_ASIZE.jinc  4-way fixed-size (array-based)
    keccak1600x4_updstate.jinc    4-way streaming init/absorb/squeeze
    keccak1600x4_updstate_ASIZE.jinc  4-way streaming (array-based)

  ref/test/  avx2/test/    Standalone .jazz test programs for each permutation
```


## Compile-time configuration

Two `param int` values, normally set before including any Keccak file
(defaults in `common/keccak1600_default.jinc`), control the generated code.

### `KECCAK_FEATURES` -- instruction-set selection

Bitmask that tells the sponge code which x86-64 extensions are available.
The absorb/squeeze loops and the state-init code branch on these flags at
compile time to select wider loads and stores.

| Flag                  | Value  | Effect                                        |
|-----------------------|--------|-----------------------------------------------|
| `KECCAK_FEATURE_BMI`  | `0x01` | Use `ANDN` (BMI1) in the permutation         |
| `KECCAK_FEATURE_BMI2` | `0x02` | Use `RORX` (BMI2) for rotations              |
| `KECCAK_FEATURE_AVX2` | `0x04` | Use 256-bit loads/stores in absorb/squeeze    |

Default: all three (`0x07`).

### `KECCAK_PERMUTATION` -- permutation selection

Packed word: the low byte selects the single-lane permutation, the high byte
selects the four-way permutation.  The single-lane choice applies to
`_keccakf1600`; the four-way choice applies to `_keccakf1600_avx2x4`.

**Single-lane** (low byte):

| Constant            | Value    | Description                               |
|---------------------|----------|-------------------------------------------|
| `KECCAK_F1600_REF`   | `0x0000` | Textbook; BMI/BMI2-gated                  |
| `KECCAK_F1600_BASIC` | `0x0001` | Lane-complementing (s2n-bignum port)      |
| `KECCAK_F1600_OPT`   | `0x0002` | XKCP clang -O3 transcription (BMI+BMI2)  |
| `KECCAK_F1600_AVX2`  | `0x0003` | AVX2 register-resident permutation        |

**Four-way** (high byte):

| Constant              | Value    | Description                               |
|-----------------------|----------|-------------------------------------------|
| `KECCAK_F1600x4_REF`  | `0x0000` | Reference four-way                        |
| `KECCAK_F1600x4_ALT`  | `0x0100` | Alternative scheduling                    |
| `KECCAK_F1600x4_NAT`  | `0x0200` | AWS/mlkem-native optimised (with proof)   |

Default: `KECCAK_F1600_OPT + KECCAK_F1600x4_NAT`.


## Memory-based vs. array-based interfaces

The sponge construction (absorb, squeeze) is provided in two flavours that
differ in how they receive input and produce output.

### Memory-based (`_imem`)

Input and output are passed as memory pointers (`reg ui64 buf`, `reg ui64
len`).  These functions read from and write to caller-supplied buffers via
ordinary loads and stores.

- Suited for C-ABI exports (see below) and any context where data lives in
  memory.
- Files: `subreadwrite_imem.jinc`, and every `keccak1600_*.jinc` file
  without `_ASIZE` in its name.

### Array-based (`_ASIZE`)

Input and output are Jasmin arrays (`reg ptr u8[_ASIZE]`), where `_ASIZE`
is a compile-time parameter that must be set before including the file.
Because Jasmin arrays carry their size in the type, these files need to be
instantiated for each required size (the generated code is independent of
`_ASIZE`, but the Jasmin type-checker demands the instantiation).

- Suited for intra-Jasmin use, where data already lives in a local or stack
  array and the caller wants to avoid a round-trip through memory.
- Files: `subreadwrite_ASIZE.jinc`, and every file with `_ASIZE` in its name.

Each memory-based file has an array-based counterpart and the two are kept
in sync (noted in the file headers).


## Fixed-size vs. streaming (updstate) interfaces

### Fixed-size

All sizes (input length, rate, trail byte, squeeze length) are compile-time
constants (`inline int`).  The compiler resolves all control flow and unrolls
the absorb/squeeze loops at compilation time.

- **Pros:** the compiler sees the full picture; optimal code for a known
  workload.
- **Cons:** a separate instantiation is needed for each (rate, input-size,
  output-size) triple.  This is the natural fit for intra-Jasmin use inside
  ML-KEM and ML-DSA, where every hash call has statically known parameters.
- Files: `keccak1600_fixedsizes*.jinc`, `keccak1600x4_fixedsizes*.jinc`.

### Streaming (updstate)

Rate and trail byte are stored in the state itself (`keccak_updstate =
u64[26]`; the 26th word packs the rate, the current byte position, and the
trail byte).  Input length is a run-time value.  The interface is
incremental: `init` / `absorb` (called zero or more times) / `finish` /
`squeeze` (called zero or more times).

- **Pros:** a single compiled instance handles every (rate, trail-byte)
  combination and arbitrary input lengths; the interface maps directly to a
  streaming C API.
- **Cons:** run-time overhead from the position tracking and the
  variable-length inner loops.
- Files: `keccak1600_updstate*.jinc`, `keccak1600x4_updstate*.jinc`.

Both flavours are available in memory-based and array-based variants, and
for both single-lane and four-way (x4) states.


## C-ABI exports

The `*_export.jinc` files expose the streaming (updstate) interface as
`export fn` entry points with a C-compatible calling convention.  These are
the building blocks for a standalone FIPS 202 shared library.

Currently exported (memory-based, single-lane):

| Function               | Signature (Jasmin)                                   |
|------------------------|------------------------------------------------------|
| `init_updstate`        | `(st, r64, trailb) -> st`                            |
| `finish_updstate`      | `(st) -> st`                                         |
| `absorb_m_updstate`    | `(st, buf, len) -> st`                               |
| `squeeze_m_updstate`   | `(st, buf, len) -> st`                               |
| `ststatus_updstate`    | `(status, st) -> status`                             |

Currently exported (array-based, single-lane):

| Function               | Signature (Jasmin)                                   |
|------------------------|------------------------------------------------------|
| `absorb_updstate`      | `(st, buf, len) -> st`                               |
| `squeeze_updstate`     | `(st, buf) -> (st, buf)`                             |

`r64` is the rate in 8-byte words minus one (e.g. 16 for SHAKE-128, rate
136 = 17*8).  `trailb` is the FIPS 202 trail byte (`0x06` for SHA-3,
`0x1F` for SHAKE).

### Standard FIPS 202 functions (`ref/JKCP.jazz`)

`ref/JKCP.jazz` provides the complete C API for third-party use, wrapping
the updstate internals into standard FIPS 202 functions.

**One-shot** (stack-allocate state internally; single call does the full
hash):

| Function   | Signature (C)                                      |
|------------|----------------------------------------------------|
| `sha3_224` | `(uint8_t *out, const uint8_t *in, uint64_t inlen)` |
| `sha3_256` | `(uint8_t *out, const uint8_t *in, uint64_t inlen)` |
| `sha3_384` | `(uint8_t *out, const uint8_t *in, uint64_t inlen)` |
| `sha3_512` | `(uint8_t *out, const uint8_t *in, uint64_t inlen)` |
| `shake128` | `(uint8_t *out, uint64_t outlen, const uint8_t *in, uint64_t inlen)` |
| `shake256` | `(uint8_t *out, uint64_t outlen, const uint8_t *in, uint64_t inlen)` |

**Incremental** (caller manages a `keccak_updstate`; per-variant init
hardcodes rate and trail byte):

| Function         | Signature (C)                                        |
|------------------|------------------------------------------------------|
| `sha3_224_init`  | `(keccak_updstate st)`                               |
| `sha3_256_init`  | `(keccak_updstate st)`                               |
| `sha3_384_init`  | `(keccak_updstate st)`                               |
| `sha3_512_init`  | `(keccak_updstate st)`                               |
| `shake128_init`  | `(keccak_updstate st)`                               |
| `shake256_init`  | `(keccak_updstate st)`                               |
| `keccak_absorb`  | `(keccak_updstate st, const uint8_t *data, uint64_t len)` |
| `keccak_squeeze` | `(keccak_updstate st, uint8_t *out, uint64_t len)`   |

The incremental flow is: `sha3_NNN_init` (or `shakeNNN_init`) &rarr;
`keccak_absorb` (zero or more times) &rarr; `keccak_squeeze` (once for
SHA-3, or multiple times for SHAKE XOF).  There is no separate finalize:
the first squeeze applies the padding.  The trail byte in the status word
marks the mode: init sets it, and the first squeeze clears it.

### 4-way AVX2 functions (`avx2/JKCP.jazz`)

`avx2/JKCP.jazz` provides the incremental C API for the 4-way (x4) Keccak
sponge.  All four lanes share the same rate and trail byte (set at init).
Absorb comes in two flavours: broadcast (same data to all lanes) and
independent (four separate buffers, same length).

**Incremental init** (per-variant, sets rate and trail byte for all
four lanes):

| Function          | Algorithm  |
|-------------------|------------|
| `sha3_224x4_init` | SHA3-224   |
| `sha3_256x4_init` | SHA3-256   |
| `sha3_384x4_init` | SHA3-384   |
| `sha3_512x4_init` | SHA3-512   |
| `shake128x4_init` | SHAKE-128  |
| `shake256x4_init` | SHAKE-256  |

**Generic operations** (state type: `keccakx4_updstate`, `u64[101]`,
808 bytes):

| Function              | Signature (C)                                                   |
|-----------------------|-----------------------------------------------------------------|
| `keccakx4_absorb_bcast` | `(keccakx4_updstate st, const uint8_t *data, uint64_t len)`  |
| `keccakx4_absorb`       | `(keccakx4_updstate st, const uint8_t *d0, d1, d2, d3, uint64_t len)` |
| `keccakx4_squeeze`      | `(keccakx4_updstate st, uint8_t *o0, o1, o2, o3, uint64_t len)` |

The incremental flow is: `*x4_init` &rarr; `keccakx4_absorb_bcast` and/or
`keccakx4_absorb` (zero or more times, freely mixed) &rarr;
`keccakx4_squeeze` (one or more times; the first one applies the padding).

A squeeze of length 0 (`keccak_squeeze` or `keccakx4_squeeze`) changes
nothing, not even the mode: the state can go on absorbing.  The wrappers
skip the internal squeeze in that case: at a block boundary, the internal
procedure permutes the state even for length 0, which would make the next
squeeze skip a block.

**Speculative constant time.**  Both `ref/JKCP.jazz` and `avx2/JKCP.jazz`
pass `jasmin-ct --sct --doit`.  Their exports carry `#[sct]` signatures
(state contents secret, pointers and lengths public).  The ones that take
the state start with `#init_msf` (an LFENCE), and the mode test in the
squeeze masks the status word with `#protect` instead of fencing again.
The status word is public: it depends only on the rate and the trail byte,
set by init, and on the lengths absorbed and squeezed.  The updstate
procedures declassify it where they read it, then fence before branching
on it; their reads and writes of it carry a note saying so.  The
declassification works around a limitation of the SCT type system, which
gives all the entries of an array the same security type: the status word
shares its array with the secret Keccak state.  A one-absorb,
one-squeeze hash pays 6 LFENCEs (one per call, plus one inside each of
absorb, finish and squeeze), against 7 with a separate finalize.

Both files are proved correct in EasyCrypt against FIPS 202:
`proofs/fips202/ref/JKCP.ec` and `proofs/fips202/avx2/JKCP_avx2x4.ec`
(see [the proofs README](../../proofs/fips202/README.md)).

**CI.**  Together they are the `fips202` implementation of the claims
(`src/fips202/meta.toml`, an implementation of every parameter set of
`proofs/fips202/spec/meta.toml`), which claims `kat`, `memcheck`, `ct` and
`sct`:

- `make -C src fips202` builds `_build/fips202x1_avx2.s` (single lane) and
  `_build/fips202x4_avx2.s` (4-way); `make -C src extract-asm` commits them
  for Linux as `asm/fips202/avx2/fips202x{1,4}_avx2_sct.s`.
- `make -C src ct-fips202 sct-fips202` checks both programs with
  `jasmin-ct --doit` and `--sct --doit`.
- `bench/` links both into `jasmin_fips202.so`.  `bench/kat.py` runs every
  test of `bench/vectors/fips202-*.json` (NIST ACVP, byte-aligned messages)
  through the one-shot function, the incremental API (the message absorbed
  in three parts, the output squeezed in two, with zero-length squeezes) and
  the 4-way API (broadcast and four-buffer absorbs, every lane).
- `bench/memcheck.c` (scheme `FIPS-202`) runs every function on exact-size
  heap buffers, empty ones included, through the three APIs, under
  Valgrind's memcheck.


## Standard rates and trail bytes

Defined in `common/keccak1600_generic.jinc`:

| Constant | Bytes | Used by                                          |
|----------|-------|--------------------------------------------------|
| `R72`    | 72    | SHA3-512 (rate = 1600 - 2*512 = 576 bits)       |
| `R104`   | 104   | SHA3-384 (rate = 1600 - 2*384 = 832 bits)       |
| `R136`   | 136   | SHA3-256 / SHAKE-256 (rate = 1600 - 2*256)      |
| `R144`   | 144   | SHA3-224 (rate = 1600 - 2*224 = 1152 bits)      |
| `R168`   | 168   | SHAKE-128 (rate = 1600 - 2*128 = 1344 bits)     |

| Constant   | Value  | Meaning                            |
|------------|--------|------------------------------------|
| `UNFINISHED` | `0x00` | No trail byte (absorb-only state)  |
| `SHA3`       | `0x06` | SHA-3 domain separation            |
| `RAWSHAKE`   | `0x07` | RawSHAKE domain separation         |
| `SHAKE`      | `0x1F` | SHAKE domain separation            |


## Usage from Jasmin

### Internal (fixed-size, array-based)

This is how ML-KEM and ML-DSA use the Keccak code.  The caller sets
`KECCAK_FEATURES`, `KECCAK_PERMUTATION`, and `_ASIZE`, then includes the
appropriate `_fixedsizes_ASIZE.jinc`.  All parameters are compile-time
constants:

```jasmin
param int KECCAK_FEATURES = KECCAK_FEATURE_BMI + KECCAK_FEATURE_BMI2 + KECCAK_FEATURE_AVX2;
param int KECCAK_PERMUTATION = KECCAK_F1600_OPT + KECCAK_F1600x4_NAT;

param int _ASIZE = 64;
from Keccak require "ref/common/keccak1600_fixedsizes_ASIZE.jinc"
```

### External (streaming, memory-based)

For a standalone library, compile `ref/common/keccak1600_updstate_export.jinc`
(which pulls in the full dependency chain) after setting `KECCAK_FEATURES`
and `KECCAK_PERMUTATION`.
