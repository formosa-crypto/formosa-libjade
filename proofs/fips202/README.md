# FIPS 202 (SHA-3 / SHAKE) proofs

EasyCrypt proofs that the Jasmin Keccak Code Package (JKCP,
[`src/fips202`](../../src/fips202/README.md)) is functionally correct with respect to
FIPS 202. The Jasmin procedures are extracted to EasyCrypt, and each one is proved to
compute the byte-level sponge operators of `spec/properties/Keccak1600_Spec.ec`. Those
operators are proved equal to a transcription of the standard.

No lemma is admitted. The trusted base (`bind circuit` declarations, abstract-theory
parameters) is listed in [notes/FILES.md](notes/FILES.md#trust-base).

To check everything, run `make -C proofs fips202` from the repository root. This is the
`fips202` scenario of `proofs/tests.config`.


## Layout

```
fips202/
  easycrypt.project   load paths, provers (CVC5, Z3), SMT timeout
  spec/               the specification: FIPS 202 and the forms derived from it
    properties/
  extracted/          models extracted from src/fips202, and their sync checks
  common/             lemmas shared by every implementation
  ref/JKCP.ec         single lane: the C-ABI entry points (src/fips202/ref/JKCP.jazz)
  ref/common/         single lane: permutations, fixed-size and updstate proofs
  avx2/JKCP_avx2x4.ec 4-way: the C-ABI entry points (src/fips202/avx2/JKCP.jazz)
  avx2/common/        AVX2: single-lane and 4-way permutations, fixed-size and
                      updstate proofs
  notes/              timings, trust base, design of the updstate proofs
```

The tree mirrors `src/fips202`. For example, `ref/common/Keccak1600_fixedsizes_ref.ec`
proves `src/fips202/ref/common/keccak1600_fixedsizes{,_ASIZE}.jinc`, and
`ref/JKCP.ec` proves `src/fips202/ref/JKCP.jazz`.

`easycrypt.project` maps `CryptoSpecs` to `spec/` (recursively) and `JazzEC` to
`extracted/` and `../arrays`. It puts `common/`, `ref/common/` and `avx2/common/` on the
include path, so files in those directories require each other by bare name.


## The specification (`spec/`)

The specification has two levels. The files at the top of `spec/` transcribe the
standard as imperative EasyCrypt modules over bit lists. The files in `spec/properties/`
give the same functions as operators, first over bits and then over bytes, and prove
each form equal to the previous one.

| File                                    | Content                                                                                                                                                                                                                                  |
| --------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `FIPS202_Keccakf1600.ec`                | Keccak-f[1600] (FIPS 202 §3). The state type (`W64.t Array25.t`), the bit-string conversions, and the module `Keccakf1600` with the step mappings θ, ρ, π, χ, ι and the permutation.                                                     |
| `FIPS202_SHA3.ec`                       | The sponge (§4, Algorithm 8), `pad10*1` (§5.1), KECCAK[c] (§5.2), SHA3-224/256/384/512 (§6.1), SHAKE128/256 (§6.2) and RawSHAKE128/256 (§6.3), in the module `Keccak1600`.                                                              |
| `Keccak1600_arrays.ec`                  | Array instances and `init_*` operators used by the two files above.                                                                                                                                                                     |
| `properties/Keccakf1600_Spec.ec`        | The operators `keccak_theta_op` … `keccak_f1600_op`, and proofs that the procedures of `Keccakf1600` compute them (`keccak_f1600_h`). Every permutation proof targets `keccak_f1600_op`.                                                 |
| `properties/FIPS202_SHA3_Spec.ec`       | The bit-level operators `keccak1600_op`, `sha3_*_op`, `shake*_op`, `rawshake*_op`, and proofs that the procedures of `Keccak1600` compute them (`sha3_256_h`, …).                                                                         |
| `properties/Keccak1600_Spec.ec`         | The byte-level operators the implementation proofs are stated with: `ABSORB1600`, `SQUEEZE1600`, `KECCAK1600`, `SHA3_224` … `SHAKE256`. The `*_opE` lemmas equate them with the bit-level operators through `bytes_to_bits`.          |
| `properties/Keccakf1600_Perm.ec`        | Keccak-f[1600] is injective, hence periodic on the finite state space.                                                                                                                                                                  |
| `properties/Keccak1600_Orbit.ec`        | For a message shorter than the rate, the SHAKE output contains zero bytes at positions that recur with the period of the permutation (`SHAKE128_zero_run`, `SHAKE256_zero_run`). ML-KEM and ML-DSA use this to show that their rejection samplers terminate. |

Put together, a contract that ends in `SHA3_256 m` (bytes) gives
`sha3_256_op (bytes_to_bits m)` by `sha3_256_opE`. By `sha3_256_h`, that is the output
of the procedure `Keccak1600.sha3_256` of `FIPS202_SHA3.ec`.


## Top-level proof files

The sponge code has two interfaces (see the [JKCP README](../../src/fips202/README.md)):

- **Fixed-size.** All lengths are compile-time constants.
- **updstate.** The streaming interface `init` / `absorb`\* / `finish` / `squeeze`\*,
  with the rate and trail byte kept in a status word appended to the state.

Each interface has two variants:

- **Memory.** Buffers are pointers and lengths.
- **Array.** Buffers are Jasmin arrays of size `_ASIZE`, a compile-time parameter.

Both variants of an interface are proved in the same file:

- The **memory** procedures are proved at the top level of the file, against the
  extracted module `Keccak1600_Jazz.M`.
- The **array** procedures are proved in an **abstract theory** over `_ASIZE`. Its module
  `MM` copies the extracted array code. A client clones the theory once for each size it
  uses, in the same way as the Jasmin code is instantiated once for each size. For
  example, ML-DSA clones `KeccakArrayRef` eight times in
  `mldsa/avx2/sct/correctness/common/HashingT.ec`. The `extracted/*_checkXtr.ec` files
  check that each `MM` equals the extracted code at `_ASIZE = 999`.

| Implementation   | Fixed-size                                                              | updstate                                                                |
| ---------------- | ----------------------------------------------------------------------- | ----------------------------------------------------------------------- |
| Single lane      | `ref/common/Keccak1600_fixedsizes_ref.ec`, array theory `KeccakArrayRef` | `ref/common/Keccak1600_updstate_ref.ec`, array theory `KeccakUpdstateRef` |
| AVX2 single lane | `avx2/common/Keccak1600_fixedsizes_avx2.ec`, array theory `KeccakArrayAvx2` | covered by the single-lane file (see below)                             |
| AVX2 4-way       | `avx2/common/Keccak1600_fixedsizes_avx2x4.ec`, array theory `KeccakArrayAvx2x4` | `avx2/common/Keccak1600_updstate_avx2x4.ec`, array theory `KeccakUpdstateAvx2x4` |

Every procedure has a `hoare` contract (`_h`), a losslessness lemma (`_ll`) and a
`phoare` form (`_ph`). The main contracts are listed below.

### Fixed-size

**`ref/common/Keccak1600_fixedsizes_ref.ec`** (single lane, state `W64.t Array25.t`)

| Variant | Contracts                                                     | What they establish                                                                                                                                                                                                        |
| ------- | ------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Memory  | `absorb_m_h`, `squeeze_m_h` (and `addstate_m_h`, `dumpstate_m_h`) | With a nonzero trail byte, absorb returns `ABSORB1600 tb r8 (l ++ memread mem buf len)`. With trail byte 0, it returns a partial state (`pabsorb_spec_ref`), so that absorption can continue. Squeeze leaves `stores mem buf (SQUEEZE1600 r8 len st)` in memory. |
| Array   | `absorb_h`, `squeeze_h` (and `addstate_h`, `dumpstate_h`)     | The same, with `to_list buf` as the input and `_ASIZE` as the length.                                                                                                                                                     |

**`avx2/common/Keccak1600_fixedsizes_avx2.ec`** (single lane, state in seven `u256`
registers)

| Variant | Contracts                              | What they establish                                                                                                       |
| ------- | -------------------------------------- | ------------------------------------------------------------------------------------------------------------------------- |
| Memory  | `absorb_m_avx2_h`, `squeeze_m_avx2_h`  | The single-lane contracts, read through the conversions `stavx2_to_st25` / `stavx2_from_st25` of the register layout.     |
| Array   | `absorb_avx2_h`, `squeeze_avx2_h`      | Same.                                                                                                                     |

**`avx2/common/Keccak1600_fixedsizes_avx2x4.ec`** (four states, `u256[25]`)

| Variant | Contracts                                                                 | What they establish                                                                                                                                                                                                                  |
| ------- | ------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Memory  | `absorb_m_avx2x4_h`, `absorb_m_bcast_avx2x4_h`, `squeeze_m_avx2x4_h`      | The single-lane contracts for each lane (`absorb_spec_avx2x4`, `pabsorb_spec_avx2x4`). The broadcast absorb feeds one buffer to all lanes. Squeeze leaves the four lanes' `SQUEEZE1600` outputs in memory (`stores4`) and requires the four output buffers not to overlap (`disj4`). |
| Array   | `absorb_avx2x4_h`, `absorb_bcast_avx2x4_h`, `squeeze_avx2x4_h`            | Same.                                                                                                                                                                                                                                |

### updstate

The contracts are stated with the predicates of `common/Keccak1600_updstate.ec`:
`absorbing_spec r8 tb l st` (`st` has absorbed the bytes `l`) and
`squeezing_spec r8 st0 k st` (`st` has squeezed `k` bytes from the absorbed state
`st0`). The 4-way file uses their lane-wise versions `absorbing_spec4` and
`squeezing_spec4`.

| Procedure | Pre                                     | Post                                                                       |
| --------- | --------------------------------------- | -------------------------------------------------------------------------- |
| init      | `0 < r64 <= 25`                         | `absorbing_spec (8*r64) tb [] res`                                         |
| absorb    | `absorbing_spec r8 tb l st`             | `absorbing_spec r8 tb (l ++ input) res`                                    |
| finish    | `absorbing_spec r8 tb l st`             | `squeezing_spec r8 (ABSORB1600 tb r8 l) 0 res`                             |
| squeeze   | `squeezing_spec r8 st0 k st`, `0 < len` | output is `sqstream r8 st0 k len`, and `squeezing_spec r8 st0 (k+len) res` |

`sqstream r8 st0 k n` is the slice `[k, k+n)` of the output stream, so consecutive
squeezes concatenate. A squeeze of length 0 is excluded: at a block boundary it would
permute the state and skip a block.

**`ref/common/Keccak1600_updstate_ref.ec`** (single lane, state `u64[26]`)

| Variant | Contracts                                                                                                         |
| ------- | ----------------------------------------------------------------------------------------------------------------- |
| Memory  | `init_updstate_h`, `absorb_m_updstate_h`, `squeeze_m_updstate_h`, `absorb_m_state_h`, and the exports `*_export_h` |
| Array   | `absorb_updstate_h`, `squeeze_updstate_h`, `squeeze_state_h`, and the exports `*_export_h`                         |

The single-lane `finish` (`finish_updstate_h`, `finish_state_h`) is proved in
`common/Keccak1600_updstate_finish.ec`, a separate file because one of its `smt` calls
times out when the whole development is in scope. The proofs cover every
`KECCAK_PERMUTATION` choice and both branches of the `KECCAK_FEATURE_AVX2` dispatch in
the add and dump helpers. That is why there is no separate AVX2 single-lane updstate
file: the AVX2 build is the single-lane code with `KECCAK_F1600_AVX2` selected. ML-DSA
uses these procedures.

**`avx2/common/Keccak1600_updstate_avx2x4.ec`** (four states, `u64[101]`)

| Variant | Contracts                                                                                                                                                              |
| ------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Memory  | `init_updstate_avx2x4_h`, `absorb_m_updstate_avx2x4_h`, `absorb_m_bcast_updstate_avx2x4_h`, `finish_updstate_avx2x4_h`, `squeeze_m_updstate_avx2x4_h`, and the exports `*_export_h` |
| Array   | `absorb_updstate_avx2x4_h`, `absorb_bcast_updstate_avx2x4_h`, `squeeze_updstate_avx2x4_h`, and the exports `*_export_h`                                                   |

The array theory `KeccakUpdstateAvx2x4` clones `KeccakArrayAvx2x4` to reuse the
fixed-size 4-way lane lemmas. As in the fixed-size file, the memory squeeze requires
`disj4`.

The design of the updstate proofs is described in [notes/updstate.md](notes/updstate.md).

### C-ABI entry points (JKCP)

The exported functions of `src/fips202/{ref,avx2}/JKCP.jazz` fix the rate and the trail
byte and call the memory updstate procedures, so their proofs compose the contracts
above. The incremental API has no separate finalize: the first squeeze finishes the
absorption. The status word's trail byte tells the two modes apart: init sets it to a
nonzero value, and `finish` clears it.

**`ref/JKCP.ec`** (single lane)

| Functions                                  | Contract                                                                                   |
| ------------------------------------------ | ------------------------------------------------------------------------------------------ |
| `sha3_224` … `sha3_512` (`sha3_224_h`, …)  | `Glob.mem = stores mem out (SHA3_224 (memread mem in inlen))`, …                           |
| `shake128`, `shake256` (`shake128_h`, …)   | `Glob.mem = stores mem out (SHAKE128 (memread mem in inlen) outlen)`, for every `outlen >= 0` |
| `sha3_224_init` … `shake256_init`          | `absorbing_spec c448_r8 SHA3_DS_BYTE [] res`, …                                            |
| `keccak_absorb` (`keccak_absorb_h`)        | `absorbing_spec r8 tb l st ==> absorbing_spec r8 tb (l ++ input) res`                      |
| `keccak_squeeze` (`keccak_squeeze_h`)      | `sponge_spec r8 tb l k st ==> output = sqstream r8 (ABSORB1600 tb r8 l) k len /\ sponge_spec r8 tb l (k + len) res`, for every `len >= 0` |

`sponge_spec r8 tb l k st` covers both modes. Either the state is still absorbing
(`k = 0`, `absorbing_spec r8 tb l st`, `tb <> 0`), or it has squeezed `k` bytes since
finishing (`squeezing_spec`, trail byte 0). Two procedure facts link the modes to the
trail byte: `finish_updstate_sponge_h` (finish clears it) and
`squeeze_m_updstate_trailb_h` (a squeeze keeps it). They rest on three status-word
lemmas added to `common/Keccak1600_updstate.ec`: `clear_at_trailb_tb`,
`finish_spec_trailb` and `st26_store_trailb`.

`incremental_sha3_256_h` checks that the contracts compose: `sha3_256_init`, then
`keccak_absorb`, then `keccak_squeeze` with length 32, compute `SHA3_256` of the input.

The one-shot contracts are stated directly with the byte-level operators `SHA3_224` …
`SHAKE256`, so they connect to the standard through the `*_opE` lemmas. The generic
lemmas `sha3_h` and `shake_h` prove the inline helpers `__sha3` and `__shake` for any
rate.

**`avx2/JKCP_avx2x4.ec`** (4-way; incremental only): the same structure, lane-wise.
The six `*x4_init` functions give `absorbing_spec4` with the algorithm's rate and trail
byte, `keccakx4_absorb_bcast` and `keccakx4_absorb` have the 4-way absorb contracts,
and `keccakx4_squeeze_h` is stated with `sponge_spec4`. Its output is
`sqstream r8 (ABSORB1600 tb r8 l_i) k len` in lane `i`, and the output buffers must
not overlap (`disj4`).

A squeeze of length 0 is the one place where these contracts go beyond the updstate
ones, which require `0 < len`:

- In the one-shot SHAKE functions, `squeeze_m_updstate_len0_h` shows that such a
  squeeze writes nothing.
- The wrappers `keccak_squeeze` and `keccakx4_squeeze` skip the call when `len = 0`.
  Without that guard, a zero-length squeeze at a block boundary would permute the state
  and the next squeeze would skip a block. `keccak_squeeze_len0_h` and
  `keccakx4_squeeze_len0_h` show that such a call returns the state unchanged, so the
  state can still absorb.


## Supporting files

The top-level files rest on the following layers.

**Permutations.** Each proof shows that a Jasmin permutation computes `keccak_f1600_op`
(or applies it to each lane, `st4x_map keccak_f1600_op`, for the 4-way ones). Round
bodies are mostly closed by `circuit`.

| File                                                    | Permutation                                                                                     |
| ------------------------------------------------------- | ----------------------------------------------------------------------------------------------- |
| `ref/common/Keccakf1600_ref.ec`                         | `KECCAK_F1600_REF`                                                                              |
| `ref/common/Keccakf1600_basic.ec`                       | `KECCAK_F1600_BASIC`                                                                            |
| `ref/common/Keccakf1600_opt.ec`                         | `KECCAK_F1600_OPT`                                                                              |
| `avx2/common/Keccakf1600_avx2.ec`                       | `KECCAK_F1600_AVX2`                                                                             |
| `ref/common/Keccakf1600.ec`                             | Dispatcher `_keccakf1600`: `keccakf1600_h` for all four single-lane choices.                   |
| `avx2/common/Keccakf1600_avx2x4_{ref,alt,nat}.ec`       | `KECCAK_F1600x4_REF`, `_ALT`, `_NAT`                                                            |
| `avx2/common/Keccakf1600_avx2x4.ec`                     | Dispatcher `_keccakf1600_avx2x4`: `keccakf1600_avx2x4_h` for all three 4-way choices.          |

Because the sponge proofs call the dispatchers' contracts, they hold whatever
`KECCAK_PERMUTATION` selects.

**State helpers.** State initialisation and the rate bit: `ref/common/Keccak1600_ref.ec`,
`avx2/common/Keccak1600_avx2.ec` (AVX2 register layout), `avx2/common/Keccak1600_avx2x4.ec`
(packed 4-way state).

**Shared lemmas (`common/`).**

| File                               | Content                                                                                                                       |
| ---------------------------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| `Keccak1600_statebytes.ec`         | Byte view of the state: XORing a byte list at an offset, the partial-absorb invariant `pabsorb_spec`, squeeze slicing.        |
| `Keccak1600_subreadwrite.ec`       | Contracts of the partial-word reads and writes of `src/fips202/common/subreadwrite_*.jinc`, memory and array (`ReadWriteArray`). |
| `Keccak1600_updstate.ec`           | The updstate status word and its decoder, the predicates `absorbing_spec` / `squeezing_spec`, and lemmas shared by all updstate variants. |
| `Keccak1600_updstate_finish.ec`    | The single-lane `finish` and status export.                                                                                    |
| `keccak_bindings.ec`, `avx2.spec`  | `circuit` bindings of the AVX2 operators (trusted, see [notes/FILES.md](notes/FILES.md#trusted-declarations)).                 |

`avx2/common/kck_bindings.ec`, `kck_abs_bindings.ec` and `Avx2_extra.ec` hold further
AVX2 bindings and circuit-friendly views of the packed states.


## Extraction (`extracted/`)

The models are committed. `make -C proofs extract` regenerates them with the pinned
`jasmin2ec`, and `make -C proofs check-extraction` fails if they differ from the
extraction of the current sources.

| File                                         | Content                                                                                                                       |
| -------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| `toEC_keccak1600.jazz` → `Keccak1600_Jazz.ec` | Memory procedures of every implementation, the permutations, and the JKCP entry points. Module `M`.                          |
| `toEC_keccak1600_ASIZE.jazz` → `Keccak1600_Jazz_ASIZE.ec` | The same plus the array procedures, instantiated at `_ASIZE = 999`.                                              |
| `Keccak1600_*_checkXtr.ec` (six files)       | `by sim` equivalences between each hand-written `MM` of an array theory, cloned at size 999, and the extracted code.          |

`toEC_keccak1600_ASIZE.jazz` requires the per-implementation memory harnesses
`toEC_keccak1600_{ref,avx2,avx2x4}.jazz`. `make extract` uses no other `toEC_*.jazz`
file.


## Related

- [notes/FILES.md](notes/FILES.md): per-file check times, the slow `smt` and `circuit`
  calls, and the trust base.
- [notes/updstate.md](notes/updstate.md): design of the updstate proofs and the source
  fixes they required.
- `../safety/fips202`: the safety proofs of the same code (scenario `fips202-safety`).
- Clients: ML-KEM (`mlkem/avx2/sct/correctness/common/MLKEM_keccak_avx2T.ec`) and ML-DSA
  (`mldsa/avx2/sct/correctness/common/HashingT.ec`, `.../sample/sha3x4.ec`) clone the
  array theories at the sizes they use.
