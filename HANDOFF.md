# Handoff notes

State of the repository after setting up the Jasmin build, the EasyCrypt
extraction, and the multi-backend test/bench harness. Written so work can
continue in a fresh session (e.g. after moving to an x86-64 + AVX2 host).

## Layout

- `src/` — curated Jasmin ML-KEM/ML-DSA AVX2 sources (the long-term keep set,
  together with `proofs/`).
  - `src/Makefile` — `.s` generation; `make` builds `_build/{mldsa65,mlkem768,
    mlkem1024}_avx2.s`.
  - `src/include/` — C headers for the derand entry points (all six parameter
    sets; only 65/768/1024 have sources so far).
  - `src/fips202` — in-tree Keccak/FIPS202 sources (Jasmin `Keccak` namespace; flattened from formosa-keccak).
  - `src/tests/kat.py` — single-file ctypes KAT driver for the src build.
- `proofs/` — EasyCrypt development (restored).
- `bench/` — multi-backend KAT + cycle benchmark harness (details below).
- `mlkem/`, `mldsa/` — original subtree imports, still tracked. The end goal is
  to drop them and keep only `src/` + `proofs/`. `mldsa-implementation/` has
  already been removed.

## Toolchain

- Local opam switch at the repo root (`_opam`); `jasmin-nist.opam` pins
  `jasmin = 2026.03.1` and `easycrypt` from git `main`.
- The proofs were originally produced with: ML-KEM = Jasmin **2026.03.0**
  (exact tag), ML-DSA = a `release-2026.03` snapshot dated **2026-03-23**
  (between .0 and .1). We standardized everything on **2026.03.1**. The
  regenerated ML-DSA model differs from the committed one by ~977 lines that
  are **purely jasmin2ec rendering** (`VMOV_64`→`zeroextu128`, an `aT8` index
  simplification) — verified equivalent: the current `src` and the old
  upstream source extract byte-identically under the same tool.

## Key decisions

- **Derand-only ML-KEM entry points**: the non-derand `keypair`/`enc` exports
  were removed from `src/mlkem/avx2/{768,1024}/jmlkem.jazz` (they pulled in the
  `#randombytes` syscall). Entry points expose `keypair_derand`, `enc_derand`,
  `dec`.
- **`src` renames vs upstream** (verified the code is otherwise byte-identical
  to `../formosa-mlkem`): `jkem.jazz`→`jmlkem.jazz`, `kem.jinc`→`mlkem.jinc`,
  `require "../../common/avx2/X"`→`"../common/X"`; ML-DSA `keygen`/`sign` files
  use the non-`_new` names.
- **Architecture**: all AVX2 builds cross-compile on Apple Silicon but only
  *run* on an x86-64 + AVX2 host (Rosetta lacks AVX2). Build locally, run there.

## Building / running

```
# Jasmin .s + shared libs
cd src && make            # .s for mldsa65, mlkem768/1024

# EasyCrypt extraction
make -C proofs/mldsa/x86-64/avx2/ml_dsa_65 ec    # -> ml_dsa_65_avx2.ec + arrays/
make -C proofs/mlkem/extraction                  # -> {768,1024}/Jkem_avx2.ec (no arrays)

# Multi-backend harness (run targets need an x86-64 + AVX2 host)
cd bench
git -C .. submodule update --init bench/third_party/mlkem-native \
    bench/third_party/mldsa-native bench/third_party/kyber \
    bench/third_party/dilithium
    # NB: plain `submodule update --init` aborts on a stale dilithium mapping
    # left in .gitmodules by the old mldsa subtree; name the paths explicitly.
make libs                                        # <backend>_<scheme>.so via common derand ABI
make test                                        # KAT vectors/ for each backend
make compare SCHEME=ML-KEM-768 BACKENDS='jasmin mlkem-native'
make bench   SCHEME=ML-DSA-65                    # rdtsc median cycles
```

KAT vectors in `bench/vectors/` are committed (ML-DSA = pqc hash-based KAT,
ML-KEM = NIST ACVP v1.1.0.41). Regenerate with `bench/tools/import_kat.py`.

## Done (this session, on an x86-64 + AVX2 host)

1. **Ran on AVX2** ✓ — `make libs/test/compare/bench` all pass for jasmin,
   mlkem-native, mldsa-native, and pqcrystals. All KATs pass; all differential
   comparisons AGREE. Two `bench/kat.py` bugs fixed:
   (a) a backend missing a parameter set aborted the whole run -> now skips
   with a notice (jasmin only has mldsa65/mlkem768/1024); (b) output comparison
   was case-sensitive while ML-KEM ACVP vectors are upper-hex and `.hex()` is
   lower -> now case-insensitive (was reporting ~50 false ML-KEM failures).
2. **Third reference backend = pq-crystals reference** ✓ (chose this over
   liboqs). Reason: current liboqs (0.16.0-rc1) wraps mlkem-native/mldsa-native
   for ML-KEM/ML-DSA, so it would not be algorithmically independent of the
   existing native backends. The pq-crystals reference C is the genuinely
   distinct implementation. Added as submodules `bench/third_party/{kyber,
   dilithium}` with adapters in `bench/adapters/pqcrystals/`. Kyber ref already
   has the derand supercop API; Dilithium has no derand keypair, so
   `sig_shim.c` supplies its own `randombytes` (the tree's is excluded from the
   build) to feed keygen the KAT seed, and signs via the `*_internal` entry
   points. The shims include `kem.h`/`sign.h`, so the same source builds two
   backends: `pqcrystals` from the avx2 tree and `pqcrystals-ref` from the
   portable-C tree (no asm). All 6 parameter sets of both build and pass KAT;
   both agree with Jasmin and the native libs.

## Open items / next steps

3. **More Jasmin parameter sets**: `src/` only has mlkem768/1024 and mldsa65.
   The harness/headers already anticipate mlkem512 and mldsa44/87 — drop their
   sources into `src/mlkem/avx2/512` and `src/mldsa/avx2/{44,87}` and they
   build automatically.
4. **MLKEM proof project paths**: `proofs/mlkem/correctness/avx2/*/easycrypt.project`
   still bind `JazzEC`/`Jasmin`/`Keccak` to the removed-subtree paths
   (`../../../../code/jasmin/...`, `../../../../jasmin/eclib`, etc.). Repoint
   them at `src/`-based extraction (`proofs/mlkem/extraction/<param>`) and the
   submodules before the correctness proofs build.
5. **Adapt proofs** to the 2026.03.1 ML-DSA model where the rendering changed.

## Sync log

- 2026-10-02: `src/fips202` and `proofs/fips202` synced with formosa-keccak
  `13218ad` (plus WIP `Keccak1600_fixedsizes_ref.ec` from `352b416`, the
  repaired `7204cd0`); the dependent mlkem/mldsa models re-extracted together.
  Details and rationale: `proofs/fips202/notes/merge-with-formosa-keccak.md`.
- 2026-10-07: `type keccak_updstate` and `fn _ststatus_data` moved into the
  new `src/fips202/common/keccak1600_updstate_generic.jinc`, required by the
  ref and AVX2 updstate files, so the ref updstate procedures are now
  extracted. The `(64ui)at` -> `at8` fix of the two `_ASIZE` absorb files and
  the 4-way status-export fix are applied. All updstate proofs are complete
  and the fips202 and ML-DSA models were re-extracted. `origin/ci-mldsa-sct`
  deletes `src/fips202/ref/keccak1600_updstate*.jinc` and carries other
  updstate proofs, so merging it will conflict on those files. Details:
  `proofs/fips202/notes/updstate.md`.
- 2026-10-07 (later): the AVX2 single-lane updstate
  (`src/fips202/avx2/keccak1600_updstate{,_ASIZE}.jinc`) and its proof were
  removed; it was the ref updstate with the AVX2 permutation hard-wired.
  ML-DSA's `hashing.jinc` now calls the ref procedures, keeping its default
  permutation choice (`KECCAK_F1600_OPT`). The 4-way updstate add/dump now
  return results in the fixed-size order. Models re-extracted. This widens the
  future conflict with `origin/ci-mldsa-sct`, which keeps the AVX2 files (with
  SCT annotations) and deletes the ref ones.
