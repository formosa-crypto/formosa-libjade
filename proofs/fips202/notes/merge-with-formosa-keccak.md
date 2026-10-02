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
