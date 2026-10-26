# Syncing `fips202` with formosa-keccak (branch `proof`)

Status: IN PROGRESS (2026-10-02). This note documents the merge of the current
formosa-keccak state into jasmin-nist's `src/fips202` + `proofs/fips202`, and serves as
the execution plan / record.

## Baseline analysis

jasmin-nist's fips202 (imported by `ae32cc17` "flatten keccak" + `a95f69b9` "flattening
done") is **byte-identical** to formosa-keccak commit `d637dd7` (2026-07-22, "Fixes for
sct") modulo the flattening adaptations listed below. The divergence to port is exactly
three formosa-keccak commits:

| Commit | Date | Content |
|---|---|---|
| `b2e84ce` | Jul 23 | `keccakf1600_opt` loop re-index (counter 0..24 instead of -2..22, RC indices shifted, new `read_regs_opt`/`store_regs_opt` helpers; semantics unchanged, done for provability) + real `Keccakf1600_opt.ec` proof + the 4 dispatcher admits in `ref/Keccakf1600.ec` closed + re-extraction |
| `13218ad` | Jul 25 | `keccakf1600x4_pround*.jinc` → `keccakf1600x4_pround_ref*.jinc` renames, dead `keccakf1600x4_select_native.jinc` deleted, 4x proof theories swapped `_generic/_native/_orig` → `_ref/_nat/_alt` (new `_alt` correctness proof closes `by circuit`), `st4x_get_pack*` lemmas moved into `Keccak1600_avx2x4.ec`. Last verified-green formosa-keccak state. |
| `7204cd0` | Oct 2 | WIP on `ref/Keccak1600_fixedsizes_ref.ec` only (absorb-proof restructuring; admit sites 15→25; not demonstrably elaborating upstream) |

Flattening adaptations (jasmin-nist side) that must be preserved / re-applied:
- `from CryptoSpecs require import JWordList/JWord_extra` → plain `require import ...`
  (those theories live in `proofs/core`); affects the three `fixedsizes_*.ec` files
  being re-ported.
- `common/Keccak1600_subreadwrite.ec:266` proof-line fix for the newer eclib `VPSLL`
  semantics (`by rewrite /VPSLL_4u64 /= !of_uintK !modz_small /#`) — keep jasmin-nist's
  version of that file (formosa-keccak has no committed changes to it).
- Arrays live in `proofs/arrays` (complete + byte-identical coverage); formosa-keccak's
  `extracted/*Array*.ec` are not copied.
- `safety/` is NOT ported (needs `Jasmin.JSafety` + `BArray*`, absent here; the
  `fips202` scenario compiles every `.ec` under this tree).

Blast radius outside fips202:
- `proofs/mlkem-correctness/avx2/{768,1024}/MLKEM_keccak_avx2.ec`: 12 qualified uses of
  `Keccakf1600_avx2x4_generic.st4x_get_pack{0..3}` → requalify to
  `Keccak1600_avx2x4.st4x_get_pack*` (identical statements; theory already imported).
- The mlkem/mldsa extracted models embed the Keccak code and are tied to
  `Keccak1600_Jazz.M` via `by sim` equivs ⇒ re-extract together:
  `proofs/fips202/extracted/Keccak1600_Jazz{,_ASIZE}.ec`,
  `proofs/mlkem-correctness/extraction/avx2/{768,1024}/Jkem_avx2.ec`,
  `proofs/mldsa/x86-64/avx2/ml_dsa_65/ml_dsa_65_avx2.ec`.

Extraction compatibility was verified beforehand: identical toEC entry points and
checkXtr files, same `jasmin2ec --array-model=old` mode, and the committed models
reproduce byte-for-byte under jasmin 2026.03.1 (the repo pin). Extraction must NOT be
run with a dev jasmin build (renders `array` → `array_0` etc.).

## Procedure

0. **Toolchain + baseline**: pinned jasmin 2026.03.1 for extraction; reproducibility
   guard: re-extract all three model sets on the clean tree and require
   `git diff --exit-code`. (NB: never run `make clean` in
   `proofs/mldsa/x86-64/avx2/ml_dsa_65` — it is `rm -f *.ec` and would delete the
   hand-written proofs.) Record the CI state of `f35cc223` as the pre-merge baseline.
1. **src**: overwrite `avx2/keccakf1600x4_{alt,ref}.jinc`, `ref/keccakf1600_opt.jinc`;
   `git mv` the two pround files to `*_pround_ref*`; `git rm
   avx2/keccakf1600x4_select_native.jinc`. Source of truth: `13218ad:src/amd64/...`.
2. **Re-extract** the three model sets with the pinned tool; `Keccak1600_Jazz{,_ASIZE}.ec`
   must equal formosa-keccak's committed models at `13218ad`.
3. **fips202 proofs** (from `13218ad:proof/amd64/...`): overwrite
   `avx2/{Avx2_extra,Keccak1600_avx2x4,Keccakf1600_avx2,Keccakf1600_avx2x4,kck_abs_bindings}.ec`,
   `ref/{Keccakf1600,Keccakf1600_opt}.ec`; overwrite + require-fix
   `avx2/Keccak1600_fixedsizes_avx2{,x4}.ec`; add
   `avx2/Keccakf1600_avx2x4_{ref,nat,alt}.ec`; delete
   `avx2/Keccakf1600_avx2x4_{generic,native,orig}.ec`. Decision (JBA, 2026-10-02):
   also take `ref/Keccak1600_fixedsizes_ref.ec` from `7204cd0` (+ require fix), with
   fallback to the `13218ad` (= current) version if it fails to elaborate.
   **Fallback was taken** — see "7204cd0 WIP: why it was not landed" below.
4. **mlkem-correctness**: the 12 `st4x_get_pack*` requalifications.
5. **Verify**: `fips202` scenario first, then `mlkem-avx2-768`, `mlkem-avx2-1024`,
   `mldsa`, `mlkem`, `core`. Expected proof-status delta: `ref/Keccakf1600.ec` 4→0
   admits, `avx2/Keccakf1600_avx2x4.ec` 1→0, all permutation proofs admit-free;
   `fixedsizes_ref` 15→25 admit sites (WIP, intentional).
6. **Commits** on `formosa-keccak-proof-merge`:
   `fips202: sync src and proofs with formosa-keccak 13218ad` (phases 1–4, one commit),
   then `fips202: WIP absorb-proof restructuring from formosa-keccak 7204cd0`
   (isolated, droppable).

## Risks / contingencies
- formosa-keccak's smt-tuned proofs under this repo's provers (CVC5@1.3/Z3@4.13 vs
  1.0/4.12; timeout 30 vs 2): isolate per file, patch individual `smt()` calls.
- `7204cd0` WIP may not elaborate: separate commit, fallback = drop it.
- mldsa model reproducibility under 2026.03.1 (HANDOFF open item 5): detected by the
  phase-0 guard; fallback = apply the source-delta diff onto the committed model.

## Not ported (deferred to formosa-keccak upstream)
- `proof/amd64/safety/` (needs JSafety + BArray infrastructure).
- Latent bug in `avx2/keccakf1600x4_pround_ref.jinc` (OCaml-style `(**` comment parses
  badly + a call to nonexistent `__keccakf1600_4x_ref_pround`); the file is required by
  nothing and kept byte-identical to upstream.

## 7204cd0 WIP: why it was not landed

The Oct-2 formosa-keccak version of `ref/Keccak1600_fixedsizes_ref.ec` fails to
elaborate (checked with EasyCrypt r2026.07/ec-circuits). Two concrete defects, both in
the mid-edit region of `addstate_m_h`:
- line 564: the `seq 1:` invariant references `len0`, which is not in scope at that
  point (`unknown variable or constant: len0`);
- lines 609–622: a stray proof-script fragment (a ` - ` bullet, `sp; if => //.`,
  admits, and a commented AVX2-branch sketch) sits *after* the `qed.` of the enclosing
  lemma (`cannot process [proof script] outside a proof script`).

The `13218ad` (= previously imported) version of the file is kept instead; it checks
clean, as does its `checkXtr` clone. To land the WIP later: fix the two defects
upstream in formosa-keccak, re-check there, and re-port this single file (re-applying
the `require import JWordList.` edit at line 22).

**UPDATE (2026-10-02, later):** done. The WIP was repaired upstream as formosa-keccak
`352b416` (structural fixes + an abstract input cursor `(cur0,cur')` added to
`addstate_spec`, so the invariant chain now pins `buf`/`offset` via
`cur' = cur0 + (size l - len')`) and re-ported here with the line-22 require edit.
The file and its `checkXtr` clone compile clean under this repo's configuration;
24 admit sites remain, all genuine proof obligations of the absorb correctness
development (see the lemma-level notes inside the file).

## Outcome (2026-10-02)

Landed as commit "fips202: sync src and proofs with formosa-keccak 13218ad" on branch
`formosa-keccak-proof-merge`. Verification performed locally:

- Extraction reproducibility guard (pristine `f35cc223` worktree, jasmin 2026.03.1):
  all three committed model sets regenerate byte-identically, including the ML-DSA
  model (HANDOFF open item 5 does not affect these models).
- Post-merge models: `Keccak1600_Jazz{,_ASIZE}.ec` byte-match formosa-keccak's
  committed models at `13218ad`; `Jkem_avx2.ec` (768/1024) changed by 57 lines each
  and `ml_dsa_65_avx2.ec` by 8 lines (only the `_pround`→`_pround_ref` rename), all
  confined to keccak procs.
- Jasmin: `make -C src mlkem mldsa ct-mlkem sct-mlkem` passes (jasmin 2026.03.1).
- EasyCrypt (r2026.07/ec-circuits + jasmin-2026.03.1 eclib on the `Jasmin:` namespace,
  CVC5 1.3.2 / Z3 4.13.4): `fips202` scenario 36/36 green; `mlkem-avx2-768`,
  `mlkem-avx2-1024` green (the `by sim` bridges against the new models check);
  mldsa `hashing{,_4x}.ec` green. The full 6-scenario run has 7 failures, all in
  files untouched by this sync (mldsa coresamplers/ntt, mlkem NTT_Fq/Correctness),
  caused by the local EasyCrypt lacking the pinned `jasmin-nist`-branch features
  (`CommAlgebra` from PR 602, newer syntax); they fail identically on the pre-merge
  tree. CI with the pinned toolchain remains the authoritative full check.
- Proof-status delta vs before: `ref/Keccakf1600.ec` 4→0 admits,
  `avx2/Keccakf1600_avx2x4.ec` 1→0 — every Keccak permutation (scalar and 4x,
  including the new unrolled/software-pipelined `alt`) is now proved admit-free.

# Safety proofs (2026-10-26, branch `keccak-safety`)

Merge of formosa-keccak `proof/amd64-barray/safety` (branch `proof`, `6eded33`,
2026-10-23) into `proofs/fips202/safety`, together with the source changes it
depends on. The "safety/ NOT ported" item above is superseded.

## Baseline

The two source trees share an exact base: formosa-keccak `09c2220` ("merge
changes from jasmin-nist", 2026-10-07) is byte-identical to jasmin-nist
`97a7c959` (`src/amd64` vs `src/fips202`). Since then:

- formosa-keccak `7fe1a51`, `cac4567`, `16d8a25` (20 files): safety contracts
  completed and fixed on every layer; the one code change, the streaming
  add/dump steps advancing `buf`/`off` past a partial first word in one step
  (`len = 8; len -= at8; buf += len`, was `buf += 8; buf -= at8`) in 8
  functions; `len <= 0xFFFFFFFFFFFFFF00` on the array streaming contracts; the
  two `*_test.jazz` fixed.
- jasmin-nist `156dc6a3`, `fd96b511`, `999ca22f` (4 files, ref updstate only):
  `#[spill_to_mmx]`, `#declassify`/`#init_msf`, `if (SPILL)` around the
  permutation, export wrappers moved to `*_export.jinc`, and the bare-state
  steps `_absorb_m_state`, `_finish_state`, `_squeeze_state` (ML-DSA hashing
  boundary).

## Procedure

1. Sources: upstream `09c2220..6eded33` applied to the 18 files jasmin-nist
   had not touched (`git apply -p3 --directory=src/fips202`; they are now
   byte-identical to upstream); the two ref updstate files merged three-way
   (base `97a7c959`): upstream's pointer-advance hunks and contracts, kept
   jasmin-nist's code; the export wrappers' contracts put in the two
   `*_export.jinc` files; new contracts for the three bare-state steps.
2. Correctness side (jasmin 2026.03.1): models re-extracted
   (`proofs/fips202/extracted`, `proofs/mldsa/extraction` and `generic`;
   ML-KEM unchanged), upstream `16d8a25`'s proof adaptation applied
   (`ref/Keccak1600_updstate_ref.ec`, `avx2/Keccak1600_updstate_avx2x4.ec`).
3. Safety tree copied (the committed files of upstream's directory) with
   `scripts/asize_transform.py`; harnesses, `extracted/Makefile` and
   `easycrypt.project` adapted; models re-extracted from `src/fips202` with the
   `safety-assert2` `jasmin2ec`; proofs regenerated with `gen/`.
4. Scenario `fips202-safety` (`make -C proofs check-safety`), the flake's
   `jasminSafety`, and two CI steps (proof check, model reproducibility).

Toolchain facts that shaped this (checked locally):

- jasmin 2026.03.1 accepts the contracts (they do not change code generation)
  but has no `-m safety`; the `safety-assert2` snapshot (jasmin `1e7479a2`,
  jasmin-compiler `c1cae60e`) has it, but its `jasminc` allocates registers
  differently (mldsa65: 1944 lines of assembly differ), so it is used only for
  the safety extraction and its eclib.
- The snapshot eclib is the 2026.03.1 one plus `JSafety.ec`, lemmas added to
  `Jcheck`/`JMemory`/`JByte_array`, and the whole-count `VPSLL`/`VPSRL`/`VPSRA`
  of `JWord`. It is not vendored: `JASMIN_SAFETY_ECLIB` points at it, and
  `proofs/Makefile` passes it in `EC_IDIRS`, which EasyCrypt searches before
  the installed eclib (an `easycrypt.project` `idirs` comes after it).
- The safety array harness requires the memory one (same permutation
  selection, as upstream); jasmin-nist's correctness array harness selects
  the AVX2 permutation and cannot be reused.

## Adaptations found while checking

- The ref array theory's `MM` block contains jasmin-nist's `init_msf`
  (from `SLH64`), which the model imports but the generated proof header did
  not: `gen/cfg_ref.py` adds `import SLH64.`.
- `_squeeze_state`: the join of its `if (at == 0)` keeps only the loop
  invariant, so the invariant carries `r8 = _r8` (the postcondition bounds
  the final position by the rate argument).

## Outcome (2026-10-26)

Local checks (EasyCrypt `jasmin-nist` branch `df41d3ab`, CVC5 1.3.2, Z3
4.13.4; jasmin 2026.03.1 for compilation and the correctness models; the
`safety-assert2` snapshot for the safety models and eclib):

- `make -C src` and `make -C src ct sct`: pass. Assembly diff against the
  pre-merge build: only the pointer advance (two sites per ML-DSA set, modulo
  register names); ML-KEM unchanged.
- Correctness models: pre-merge models reproduced byte-for-byte; after the
  merge, `Keccak1600_Jazz{,_ASIZE}.ec`, `Mldsa{44,65,87}.ec` and
  `generic/MldsaT.ec` change only in the add/dump procedures, ML-KEM models
  unchanged.
- `fips202` 41/41; ML-DSA `HashingT.ec` (the `sim` bridges to
  `Keccak1600_Jazz.M`) passes. The run of `fips202 mldsa mlkem-avx2-768
  mlkem-avx2-1024` has 20 failures (ML-DSA `variants/*T.ec`, `instances*`,
  `correctness*`; ML-KEM 768/1024 `instances`, `correctness`, `circuit_sem`,
  `MLKEM_compress`), all "unknown symbol ...t" clone errors that reproduce
  identically on a pristine checkout of `ca229a00` with the same EasyCrypt,
  so they predate this merge (likely the local EasyCrypt lagging the pin).
  CI is authoritative for them.
- Safety models: every specification of a procedure shared with upstream is
  identical; procedure bodies differ only in the SPILL conditional,
  `init_msf` and the three bare-state steps. All layers but ref regenerate
  byte-identically to upstream.
- `make -C proofs check-safety`: 48/48, 19 min wall-clock with 10 jobs; no
  admit in `proofs/fips202/safety`.
- `flake.nix`: evaluates; the existing package keeps the same input
  derivations; `packages.jasmin-safety` resolves (not built locally).
