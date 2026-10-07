# fips202 proofs: per-file compile time and trust base

Measured 2026-10-05/06 on branch `formosa-keccak-proof-merge`, commit `6e98b395`.

**Update 2026-10-06.** The trust base was reduced after these measurements: the admitted lemmas on the fixed-size path are now proved, the `sar_div` copies are replaced by the proved core lemmas, and the checkXtr clones discharge `_ASIZE_u64`. See [Trust base](#trust-base). The timings below predate these changes, which touch only small proofs.

**Update 2026-10-07.** `easycrypt.project` now sets `timeout = 5`. The `smt` calls that stalled or ran close to that limit were rewritten, and no `smt` call passes an `@T` theory hint any more. The full `fips202` check (`make -C proofs fips202`, 10 parallel jobs) passes 37/37 in 6m15s wall-clock; earlier runs of the same check took about 12 minutes. The per-file tables below are still the `timeout = 30` measurements.

**Update 2026-10-07 (updstate).** The `updstate` (streaming) procedures are now proved for ref, AVX2 and 4-way AVX2, with no admitted lemma left in fips202. Four files are new: `common/Keccak1600_updstate.ec`, `common/Keccak1600_updstate_finish.ec`, `ref/Keccak1600_updstate_ref.ec` and `extracted/Keccak1600_updstate_ref_checkXtr.ec`. The two AVX2 `updstate` files were rewritten. The design, the source fixes and an experiment with EasyCrypt's LLM mode are in [updstate.md](updstate.md). Timings for these files are in [updstate files](#updstate-files-2026-10-07); the rows of the table below predate the rewrite. The full `fips202` check (10 parallel jobs) passes 41/41 in 6m30s.

**Setup.**
- 10-core Mac (Darwin 27, 32 GiB), otherwise idle.
- The CI-pinned EasyCrypt on `PATH` (opam switch `jasmin-nist-tools`, `r2026.06-69-gf627dfa`).
- Provers as set by `easycrypt.project`: CVC5 1.3.2 and Z3 4.13.4, `timeout = 30`.
- Each of the 37 `.ec` files was compiled alone, one at a time, with `easycrypt compile -tstats` under `/usr/bin/time -l`.
- The MLKEM/MLDSA scenarios were not run.

**Columns.**
- *Wall* is elapsed time.
- *EasyCrypt CPU* is the user time of the `easycrypt` process. The provers run under a separate `why3server` and are not counted, so *Wall − CPU* is roughly the time spent waiting for provers.
- *Peak RSS* is the peak memory of the `easycrypt` process.
- *30 s stalls* counts `smt` calls that took the full SMT timeout (see below).
- The last column repeats the run with the two `provers =` lines of `easycrypt.project` swapped (Z3 first). It is an experiment, not a recommendation.

**What a file's time covers.**
- `require` loads a theory with proof checking switched off. In `EcScope.Check_mode`, `for_loading` maps `On` to `Off`. So a file's time is its own proofs plus 1–5 s of loading. A slow proof slows down only the file that contains it, not the files that require it.
- `.eco` caches do not make `easycrypt compile` skip anything. The top-level file is always rechecked.
- CI checks all scenarios together with `JOBS=10`, so its per-file times include contention and will differ from these.

## Summary

- All 37 files pass. The sequential total is **35m38s**, of which 17m10s is EasyCrypt CPU.
- **About half of the total is 34 `smt` calls that each take exactly the 30 s timeout.** In each of them one prover proves the goal in under 0.4 s. They are concentrated in the three fixed-size absorb/squeeze proofs and in `avx2/kck_abs_bindings.ec`. See [The 30-second `smt` stalls](#the-30-second-smt-stalls).
- **Most of the remaining CPU time is `circuit` on Keccak round bodies.** The largest are 3m13s for one call in `ref/Keccakf1600_opt.ec` and 2m18s for two calls in `avx2/Keccakf1600_avx2x4_alt.ec`. See [Slow `circuit` calls](#slow-circuit-calls).
- **Peak memory reaches 3.2 GiB**, in the 4-way `alt` permutation and in the AVX2 fixed-size proof.
- **Trust base.** Since 2026-10-07 no lemma is admitted. When these measurements were taken, 42 lemmas in 3 files were admitted, all on the `updstate` path. The `bind circuit` declarations and some unproved clone obligations in the binding files are trusted. See [Trust base](#trust-base).

| File | Wall | EasyCrypt CPU | Peak RSS | 30 s stalls | `circuit` time | Admitted lemmas | Wall, Z3 first (stalls) |
|---|---:|---:|---:|---:|---:|---:|---:|
| `avx2/Keccak1600_fixedsizes_avx2x4.ec` | 8m21s | 1m55s | 1.6 GiB | 12 | - | - | 5m45s (5) |
| `ref/Keccak1600_fixedsizes_ref.ec` | 4m43s | 1m07s | 1.7 GiB | 7 | - | - | 2m13s (2) |
| `avx2/Keccak1600_fixedsizes_avx2.ec` | 3m55s | 1m20s | 3.1 GiB | 5 | 1.0s | - | 3m28s (2) |
| `avx2/kck_abs_bindings.ec` | 3m42s | 9.6s | 0.5 GiB | 7 | - | - | 11.6s (0) |
| `ref/Keccakf1600_opt.ec` | 3m19s | 3m17s | 2.3 GiB | - | 3m13s | - | 3m50s (1) |
| `avx2/Keccakf1600_avx2x4_alt.ec` | 2m39s | 2m37s | 3.2 GiB | - | 2m24s | - | 2m36s (0) |
| `common/Keccak1600_subreadwrite.ec` | 2m34s | 1m55s | 1.9 GiB | 1 | 1.1s | 4 | 2m02s (0) |
| `avx2/Keccak1600_updstate_avx2.ec` | 57.5s | 47.0s | 0.8 GiB | - | - | 15 | 53.9s (0) |
| `common/Keccak1600_statebytes.ec` | 40.8s | 6.4s | 0.4 GiB | 1 | - | - | 10.5s (0) |
| `avx2/kck_bindings.ec` | 35.2s | 29.2s | 0.6 GiB | - | - | - | 36.1s (0) |
| `spec/properties/FIPS202_SHA3_Spec.ec` | 34.7s | 4.0s | 0.3 GiB | 1 | - | - | 4.6s (0) |
| `spec/properties/Keccakf1600_Spec.ec` | 33.3s | 32.2s | 0.5 GiB | - | - | - | 32.5s (0) |
| `avx2/Keccakf1600_avx2x4_nat.ec` | 27.2s | 26.5s | 1.1 GiB | - | 22.1s | - | 27.0s (0) |
| `spec/properties/Keccak1600_Spec.ec` | 15.1s | 12.0s | 0.4 GiB | - | - | - | 14.2s (0) |
| `avx2/Keccakf1600_avx2.ec` | 14.4s | 13.7s | 0.8 GiB | - | 8.1s | - | 14.4s (0) |
| `ref/Keccakf1600_basic.ec` | 13.9s | 13.2s | 0.7 GiB | - | 7.0s | - | 13.4s (0) |
| `avx2/Keccakf1600_avx2x4_ref.ec` | 12.8s | 12.3s | 1.1 GiB | - | 5.4s | - | 12.9s (0) |
| `common/keccak_bindings.ec` | 12.4s | 10.0s | 0.4 GiB | - | - | - | 12.9s (0) |
| `extracted/Keccak1600_fixedsizes_avx2x4_checkXtr.ec` | 8.6s | 8.4s | 0.6 GiB | - | - | - | 8.7s (0) |
| `avx2/Keccak1600_avx2x4.ec` | 8.1s | 7.5s | 0.9 GiB | - | - | - | 8.1s (0) |
| `extracted/Keccak1600_fixedsizes_avx2_checkXtr.ec` | 8.1s | 7.9s | 0.6 GiB | - | - | - | 8.2s (0) |
| `ref/Keccakf1600_ref.ec` | 7.9s | 6.7s | 0.7 GiB | - | - | - | 7.3s (0) |
| `avx2/Keccak1600_avx2.ec` | 7.2s | 6.5s | 1.0 GiB | - | - | - | 6.9s (0) |
| `extracted/Keccak1600_updstate_avx2x4_checkXtr.ec` | 7.2s | 7.0s | 0.6 GiB | - | - | - | 7.1s (0) |
| `extracted/Keccak1600_fixedsizes_ref_checkXtr.ec` | 6.6s | 6.4s | 0.6 GiB | - | - | - | 6.9s (0) |
| `extracted/Keccak1600_updstate_avx2_checkXtr.ec` | 5.0s | 4.8s | 0.6 GiB | - | - | - | 5.0s (0) |
| `avx2/Keccak1600_updstate_avx2x4.ec` | 4.1s | 4.0s | 0.5 GiB | - | - | 23 | 4.2s (0) |
| `avx2/Keccakf1600_avx2x4.ec` | 4.0s | 3.8s | 0.6 GiB | - | - | - | 4.0s (0) |
| `ref/Keccakf1600.ec` | 4.0s | 3.9s | 0.6 GiB | - | - | - | 4.1s (0) |
| `avx2/Avx2_extra.ec` | 3.4s | 3.1s | 0.5 GiB | - | - | - | 3.4s (0) |
| `ref/Keccak1600_ref.ec` | 3.2s | 2.9s | 0.4 GiB | - | - | - | 3.1s (0) |
| `extracted/Keccak1600_subreadwrite_checkXtr.ec` | 3.1s | 3.0s | 0.4 GiB | - | - | - | 3.2s (0) |
| `extracted/Keccak1600_Jazz_ASIZE.ec` | 2.1s | 2.1s | 0.3 GiB | - | - | - | 2.1s (0) |
| `extracted/Keccak1600_Jazz.ec` | 2.1s | 2.0s | 0.3 GiB | - | - | - | 2.0s (0) |
| `spec/FIPS202_SHA3.ec` | 1.2s | 1.1s | 0.2 GiB | - | - | - | 1.6s (0) |
| `spec/FIPS202_Keccakf1600.ec` | 1.2s | 1.1s | 0.2 GiB | - | - | - | 1.2s (0) |
| `spec/Keccak1600_arrays.ec` | 1.2s | 1.0s | 0.2 GiB | - | - | - | 1.1s (0) |
| **Total** | **35m38s** | **17m10s** | | **34** (17m05s) | | | **25m25s** (10, 5m07s) |

"Admitted lemmas" counts lemmas whose proof ends in `admitted` or contains an `admit` tactic, outside comments, after the 2026-10-06 update.

## The 30-second `smt` stalls

**What happens.** Some `smt` calls take exactly the SMT timeout (30.1–30.3 s), although one of the two provers proves the goal almost at once. The prover race in `ecProvers.ml` is meant to return on the first valid answer. What we observe instead is that the call does not return until the first-listed prover has finished or given up. While a call stalls, only a single `cvc5-1.3.2 --tlimit=30000` process is alive; Z3 has already exited.

Minimal reproduction (any directory, with its own `easycrypt.project`):

```
[general]
timeout = 30
provers = CVC5@1.3
provers = Z3@4.13
```

```
require import AllCore IntDiv.
lemma t (i n ii : int): 0 <= ii < n => (i * n + ii) %/ n = i + (ii %/ n).
proof. move=> H. smt(@IntDiv). qed.
```

| Prover configuration | Time of the `smt` call | Result |
|---|---:|---|
| CVC5, then Z3 (as in the repo) | 30.2 s | proved |
| Z3, then CVC5 | 0.24 s | proved |
| Z3 only | 0.19 s | proved |
| CVC5 only | 30 s | fails |
| CVC5, then Z3, with `-max-provers 2` | 30.2 s | proved |
| CVC5, then Z3, with `-max-provers 1` | 0.20 s | proved |

The ec-circuits build (`r2026.07`) behaves the same: 30.2 s.

**Why swapping the order is not a fix.**
- With Z3 first, the total drops from 35m38s to 25m25s.
- But 10 new stalls appear, on goals that CVC5 proves quickly and Z3 does not. They are at `fixedsizes_ref` lines 289 and 299, `fixedsizes_avx2` lines 580 and 593, `fixedsizes_avx2x4` lines 510, 718, 2176, 2541 and 2689, and `Keccakf1600_opt` line 172.
- Other calls get slower without reaching the timeout. Non-stall time grows by about 55 s in `fixedsizes_avx2x4` and 63 s in `fixedsizes_avx2`.
- `-max-provers 1` also just moves the stalls: `kck_abs_bindings` takes 70 s with two different stalls.
- A shorter timeout shrinks each stall in proportion: `kck_abs_bindings` with `-timeout 5` takes 47 s instead of 222 s and still passes. It risks breaking goals that genuinely need more time.

**Options.**
- **Fix the calls themselves.** Many stall sites are the same step copied across the ref, AVX2 and 4-way absorb proofs: `split; first smt(divz_ge0)` and the `have E: (size _l + …) %% _r8 + … = …` equation. Giving those goals precise hints, or proving them as shared lemmas, removes several stalls at once.
- **Report upstream.** The three-line reproduction above shows that the call waits for the first-listed prover even after the other has proved the goal.
- Every `easycrypt.project` under `proofs/` lists CVC5 before Z3, so MLKEM/MLDSA are probably affected too. This was not measured.

Stall sites with the repository's prover order (34):

| File | Line | Lemma | Command |
|---|---:|---|---|
| `spec/properties/FIPS202_SHA3_Spec.ec` | 248 | `keccak1600_absorb_h` | `split; 1:smt(drop0 size_ge0).` |
| `common/Keccak1600_statebytes.ec` | 508 | `SQUEEZE1600_split` | `rewrite ifF 1:/# take_sub200 /#.` |
| `common/Keccak1600_subreadwrite.ec` | 2761 | `asubwrite_squeeze_last` | `by rewrite size_squeezeblocks //; smt(divz_ge0 _ASIZE_ge0).` |
| `avx2/kck_abs_bindings.ec` | 44, 45, 55, 57 | `flatten_ctt_inj` | `have -> : … ; smt(@IntDiv).` (four times) |
| `avx2/kck_abs_bindings.ec` | 207 | `tosintP` | `smt(get_to_uint).` |
| `avx2/kck_abs_bindings.ec` | 297 | `bvsubP` | `realize bvsubP by …; smt(@IntDiv).` |
| `avx2/kck_abs_bindings.ec` | 563 | `W_to_uint_sar_neg` | `by rewrite exprD_nneg 1:/# // /#.` |
| `ref/Keccak1600_fixedsizes_ref.ec` | 309, 351 | `absorb_m_h` | `split; first smt(divz_ge0).`, `have E: …` |
| `ref/Keccak1600_fixedsizes_ref.ec` | 537, 545 | `squeeze_m_h` | `split; first smt().`, `smt().` |
| `ref/Keccak1600_fixedsizes_ref.ec` | 1100, 1137 | `absorb_h` | `split; first smt(divz_ge0).`, `have E: …` |
| `ref/Keccak1600_fixedsizes_ref.ec` | 1326 | `squeeze_h` | `smt(mul_divz_le).` |
| `avx2/Keccak1600_fixedsizes_avx2.ec` | 605, 647 | `absorb_m_avx2_h` | `split; first smt(divz_ge0).`, `have E: …` |
| `avx2/Keccak1600_fixedsizes_avx2.ec` | 892 | `squeeze_m_avx2_h` | `rewrite Est stavx2_from_st25K; split; first smt().` |
| `avx2/Keccak1600_fixedsizes_avx2.ec` | 1627, 1666 | `absorb_avx2_h` | `split; first smt(divz_ge0).`, `have E: …` |
| `avx2/Keccak1600_fixedsizes_avx2x4.ec` | 730, 773 | `absorb_m_avx2x4_h` | `split; first smt(divz_ge0).`, `have E: …` |
| `avx2/Keccak1600_fixedsizes_avx2x4.ec` | 842, 884 | `absorb_m_bcast_avx2x4_h` | `split; first smt(divz_ge0).`, `have E: …` |
| `avx2/Keccak1600_fixedsizes_avx2x4.ec` | 1205 | `squeeze_m_avx2x4_h` | `by apply (disj4_shift _ _ _ _ _len) => //; smt().` |
| `avx2/Keccak1600_fixedsizes_avx2x4.ec` | 1556 | `asqueeze4_last` | `have Hn: 0 <= _ASIZE %/ r8 + 1 by smt(divz_ge0 _ASIZE_ge0).` |
| `avx2/Keccak1600_fixedsizes_avx2x4.ec` | 2399, 2443 | `absorb_bcast_avx2x4_h` | `split; first smt(divz_ge0).`, `have E: …` |
| `avx2/Keccak1600_fixedsizes_avx2x4.ec` | 2564, 2608 | `absorb_avx2x4_h` | `split; first smt(divz_ge0).`, `have E: …` |
| `avx2/Keccak1600_fixedsizes_avx2x4.ec` | 2813, 2815 | `squeeze_avx2x4_h` | `have Hn: … by smt(divz_ge0 _ASIZE_ge0).`, `split; first smt(mul_divz_le).` |

## Slow `circuit` calls

`circuit` runs inside the EasyCrypt process, so its cost appears as EasyCrypt CPU and memory. It is paid only when the file itself is checked.

| File | Line | Lemma | Time |
|---|---:|---|---:|
| `ref/Keccakf1600_opt.ec` | 113 | `keccakf1600_dround_opt_h` | 193.2 s |
| `avx2/Keccakf1600_avx2x4_alt.ec` | 98 | `kernel_even_alt_h` | 69.7 s |
| `avx2/Keccakf1600_avx2x4_alt.ec` | 140 | `kernel_odd_alt_h` | 68.4 s |
| `avx2/Keccakf1600_avx2x4_nat.ec` | 63 | `loopbody_nat_h` | 22.1 s |
| `avx2/Keccakf1600_avx2.ec` | 77 | `keccak_pround_avx2_h` | 8.0 s |
| `avx2/Keccakf1600_avx2x4_alt.ec` | 157 | `kernel_last_alt_h` | 5.7 s |
| `avx2/Keccakf1600_avx2x4_ref.ec` | 32 | `keccak_pround_avx2x4_ref_h'` | 5.4 s |
| `ref/Keccakf1600_basic.ec` | 81 | `keccakf1600_pround_basic_h` | 4.7 s |

Elsewhere `circuit` is cheap. `Keccak1600_fixedsizes_avx2.ec` makes 22 calls in 1.0 s, `Keccak1600_subreadwrite.ec` makes 11 calls in 1.1 s, and `Keccakf1600_basic.ec` makes 33 calls in 7.0 s. Per-call timing can be turned on with `pragma +Circuit:timing.`, which is present but commented out in four permutation files.

## Trust base

### Admitted lemmas

None. Resolved on 2026-10-07:

- **The four `*_rlen_*_upto8_h` contracts** in `common/Keccak1600_subreadwrite.ec` are proved by `conseq` from the proved `ilen` contracts, through equivalences between the two procedure families. Their statements were also fixed: the reads now give the advanced cursor, and the array write fills `min 8 (max 0 len)` bytes instead of `len`.
- **The 15 admitted lemmas of `avx2/Keccak1600_updstate_avx2.ec`** and **the 23 of `avx2/Keccak1600_updstate_avx2x4.ec`** are replaced by proved contracts stated with the predicates `absorbing_spec` and `squeezing_spec`. Some of the old statements were false; for example the AVX2 squeeze contract lacked an `at = 0` premise. `mldsa/x86-64/avx2/ml_dsa_65/hashing.ec` was adapted to the new statements.
- **The ref `updstate` procedures** are proved in the new `ref/Keccak1600_updstate_ref.ec`. They were not extracted before; see [updstate.md](updstate.md).

Resolved on 2026-10-06:

- **`W16_sar_div`, `W32_sar_div`, `W64_sar_div`** were removed from `common/keccak_bindings.ec`. The W16/W32 `bvashrP` realizations now use the proved lemmas of `core/eclib/JWord_extra.ec`, required without import. `W64_sar_div` had no users.
- **`state_init_h`** in `ref/Keccak1600_ref.ec`: the AVX2 branch of `__state_init` is proved with the new helper `get64_set256_zero`, which says a zero 256-bit store clears the 64-bit words it covers. The `circuit` route failed because the extracted `Array25.init` and the `W8u8` packing have no circuit binding.
- **`addratebit_avx2_h`** in `avx2/Keccak1600_avx2.ec`: both branches now go through `addratebitE` and `u64_xorbitE`. The position bounds come from the new lemma `stavx2_pos_bnd`.
- **`state_init_avx2x4_h'` and `state_init_avx2x4_ph'`** in `avx2/Keccak1600_avx2x4.ec`: the store loop is proved with an invariant and the new lemma `init256_set256_direct`, a byte-offset form of `init256_set256`. `ph'` follows from `h'` and losslessness.

Statements are unchanged, so the users of these lemmas in `mlkem-correctness` and `mldsa` need no edits.

### Axioms

- **Abstract-theory parameters.** `_ASIZE_ge0` and `_ASIZE_u64` in `ReadWriteArray`, `KeccakArrayRef`, `KeccakArrayAvx2`, `KeccakArrayAvx2x4`, `KeccakUpdstateRef`, `KeccakUpdstateAvx2` and `KeccakUpdstateAvx2x4`. These are expected. Clones are meant to discharge them.
- **checkXtr clones.** Resolved on 2026-10-06. The `extracted/*_checkXtr.ec` clones, seven since 2026-10-07, now discharge both `_ASIZE_ge0` and `_ASIZE_u64` (`999 < W64.modulus`) `by done`. `print axiom.` lists no axiom left in them.
- **`avx2/kck_abs_bindings.ec`.** The clones `W17` (`BitWordSH` at size 17), `JC17` and `JC2` (`JCircuits2` with `sizeS = sizeB = 17`) leave obligations unproved. These are `JC2.le_size` (`0 <= 17 <= 17`), `JC2.W2.gt0_r`, `JC2.W2.sizeBrS`, plus the definitional axioms of `BitWordSH` and `JC2.W2.Pack`. Nothing outside the file uses these clones; they look like test instantiations.
- **`avx2/kck_bindings.ec`.** The word clones `W4`, `W5`, `W10`, `W11` and `W12`, and the renamed `SHIFT` copies in `JC4` and `JC5`, keep the definitional `BitWordSH` axioms (`addE`, `andE`, …). This is the same pattern as Jasmin's `JWord.W8`–`W256`.
- **Opaque operators.** None since 2026-10-07. The opaque operators of the old `updstate` files, which only admitted lemmas constrained, were removed with them.

### Trusted declarations

- **`bind circuit`.** `common/keccak_bindings.ec` (L1961, 54 operators) and `avx2/kck_bindings.ec` (L2339, 50 operators) map EasyCrypt AVX2 operators to circuits in `common/avx2.spec`. These mappings are not proved. Both blocks list `VPACKSS_16u16` twice and carry a FIXME on `W4u32.VPEXTR_32`. The AVX2 proofs load both blocks: `Keccak_bindings` directly and `Kck_bindings` through `Avx2_extra`.
- **Other `bind` declarations.** The `bind op`, `bind bitstring` and `bind array` obligations are all realized. Since 2026-10-06 the W16/W32 `bvashrP` realizations in `keccak_bindings.ec` use the proved `JWord_extra` lemmas.

## Per-file notes

Times are wall-clock with the repository configuration. "Loading" is the time spent on `require`.

### spec/

- **`spec/Keccak1600_arrays.ec`** takes 1.2 s. Nothing admitted. It re-exports `Array5/24/25/200` and defines `init_*` operators.
- **`spec/FIPS202_Keccakf1600.ec`** takes 1.2 s. Nothing admitted. Definitions only.
- **`spec/FIPS202_SHA3.ec`** takes 1.2 s. Nothing admitted. Definitions only.
- **`spec/properties/Keccakf1600_Spec.ec`** takes 33 s, all EasyCrypt CPU. Nothing admitted. `rc_spec_correct` spends 23.3 s in one command (L477), which evaluates the 24 round constants by unfolding the LFSR. `keccak_rho_h` takes 2.9 s.
- **`spec/properties/FIPS202_SHA3_Spec.ec`** takes 35 s. Nothing admitted. 30 s of it is one stall in `keccak1600_absorb_h` (L248). With Z3 first it takes 4.6 s.
- **`spec/properties/Keccak1600_Spec.ec`** takes 15 s. Nothing admitted. The two `admitted` `bdep` experiments at L304–338 are inside a comment. The largest lemma is `keccak1600_absorb_opE` at 2.9 s.

### extracted/

- **`Keccak1600_Jazz.ec` and `Keccak1600_Jazz_ASIZE.ec`** take 2.1 s each. They are generated models with no proofs.
- **The seven `*_checkXtr.ec` files** take 3–9 s each. Nothing admitted. Each proves `by sim` equivalences between the hand-written `MM` modules at `_ASIZE = 999` and the extracted model. Loading the proof theory is 2–4 s of that. Each clone discharges both `_ASIZE` parameters.

### common/

- **`keccak_bindings.ec`** takes 12 s. Nothing admitted; the `bvashrP` realizations use `JWord_extra`'s proved `sar_div` lemmas. Contains a `bind circuit` block of 54 operators. Time is spread over many `realize` proofs of about 1 s each.
- **`Keccak1600_statebytes.ec`** takes 41 s. Nothing admitted. 30 s of it is one stall in `SQUEEZE1600_split` (L508). With Z3 first it takes 10.5 s.
- **`Keccak1600_subreadwrite.ec`** takes 2m34s, mostly EasyCrypt CPU (1m55s), and peaks at 1.9 GiB. It is the largest file, with 3857 lines and about 2000 timed commands.
  - Nothing admitted since 2026-10-07. The four `*_rlen_*_upto8_h` contracts are proved and the file now holds the `rlen` bridges of the `updstate` proofs. It takes 2m16s with `timeout = 5`.
  - Axioms: the `ReadWriteArray` parameters.
  - One stall, in `asubwrite_squeeze_last` (L2761).
  - The costliest lemma is `a_set256_fill` at 17.5 s. One rewrite chain in it (L2555) takes 13.3 s, unfolding `set256` over 32 bytes.
  - The `*_ilen_*_h` procedure proofs take 3–5 s each.

### ref/

- **`Keccakf1600_ref.ec`** takes 7.9 s. Nothing admitted.
- **`Keccakf1600_basic.ec`** takes 13.9 s. Nothing admitted. It makes 33 `circuit` calls totalling 7.0 s.
- **`Keccakf1600_opt.ec`** takes 3m19s and peaks at 2.3 GiB. Nothing admitted. The `by circuit` that closes `keccakf1600_dround_opt_h` (L113) takes 193 s. It is the most expensive single command in fips202, and covers two rounds of the loop body after `swap`/`cfold`/`proc change` preparation. With Z3 first, a 30 s stall appears in `__keccakf1600_opt_h` (L172).
- **`Keccak1600_ref.ec`** takes 3.2 s. Nothing admitted since 2026-10-06; `state_init_h` is fully proved.
- **`Keccakf1600.ec`** takes 4.0 s, mostly loading. Nothing admitted. It is the permutation dispatcher.
- **`Keccak1600_fixedsizes_ref.ec`** takes 4m43s, of which 1m07s is EasyCrypt CPU. Peak 1.7 GiB.
  - Nothing admitted. Axioms: the `KeccakArrayRef` parameters.
  - Seven stalls account for 3m31s.
  - Without them, the work is in `addstate_m_h` (23 s) and `addstate_h` (20 s). The `apply (addstate_spec_fullword …)` steps take 8–9 s each (L112, L910).
  - Absorb, dump and squeeze take 3–5 s each outside their stalls.

### avx2/

- **`kck_abs_bindings.ec`** takes 3m42s but only 9.6 s of EasyCrypt CPU. 211 s of it is seven stalls. With Z3 first it takes 11.6 s. Nothing admitted. Axioms: the unproved obligations of the `W17`/`JC17`/`JC2` clones.
- **`kck_bindings.ec`** takes 35 s. Nothing admitted. Time is spread over many `realize bvaslice{get,set}P` proofs of about 1 s each. Contains a `bind circuit` block of 50 operators and the `W4`/`W5`/`W10`/`W11`/`W12` word clones.
- **`Avx2_extra.ec`** takes 3.4 s. Nothing admitted.
- **`Keccakf1600_avx2.ec`** takes 14.4 s. Nothing admitted. `circuit` in `keccak_pround_avx2_h` takes 8.0 s.
- **`Keccak1600_avx2.ec`** takes 7.2 s. Nothing admitted since 2026-10-06; `addratebit_avx2_h` is proved. Two `admit`s remain inside a commented-out lemma (L140–141).
- **`Keccak1600_avx2x4.ec`** takes 8.1 s. Nothing admitted since 2026-10-06; `state_init_avx2x4_h'` and `state_init_avx2x4_ph'` are proved.
- **`Keccakf1600_avx2x4_ref.ec`** takes 12.8 s. Nothing admitted. `circuit` on the round takes 5.4 s.
- **`Keccakf1600_avx2x4_nat.ec`** takes 27 s. Nothing admitted. `circuit` in `loopbody_nat_h` takes 22 s.
- **`Keccakf1600_avx2x4_alt.ec`** takes 2m39s and has the highest peak memory, 3.2 GiB. Nothing admitted.
  - Time goes to `kernel_even_alt_h` (70 s), `kernel_odd_alt_h` (68 s) and `kernel_last_alt_h` (5.7 s), all `by circuit`, plus `islossless` in `__keccakf1600_avx2x4_alt_ll` (4.4 s).
  - The banner at L53 still says the kernel contracts are "admitted", but they are proved.
- **`Keccakf1600_avx2x4.ec`** takes 4.0 s. Nothing admitted. It is the 4-way permutation dispatcher.
- **`Keccak1600_fixedsizes_avx2.ec`** takes 3m55s, of which 1m20s is EasyCrypt CPU. Peak 3.1 GiB.
  - Nothing admitted. Axioms: the `KeccakArrayAvx2` parameters.
  - Five stalls account for 2m31s.
  - Without them, the work is in `addstate_avx2_h` (17 s), `addstate_m_avx2_h` (17 s) and `dump_avx2_lanes4` (10.6 s, all in one rewrite at L105).
  - Its 22 `circuit` calls take 1.0 s in total.
  - With Z3 first it takes 3m28s, with two new stalls in `absorb_m_avx2_h` and slower calls elsewhere.
- **`Keccak1600_fixedsizes_avx2x4.ec`** is the slowest file at 8m21s, of which 1m55s is EasyCrypt CPU. Peak 1.6 GiB.
  - Nothing admitted. Axioms: the `KeccakArrayAvx2x4` parameters.
  - Twelve stalls account for 6m02s. Each of the four absorb lemmas has two, so it takes about 72 s instead of about 12 s.
  - Without the stalls, the costliest lemmas are `addstate_m_avx2x4_h` (14 s), `addstate_avx2x4_h` (13 s) and the four absorbs (11–12 s each).
  - With Z3 first it takes 5m45s, with 5 new stalls.
- **`Keccak1600_updstate_avx2.ec`** was rewritten on 2026-10-07. Nothing admitted. It proves the memory and array procedures; `finish` comes from `common/Keccak1600_updstate_finish.ec` by `sim`. See [updstate files](#updstate-files-2026-10-07).
- **`Keccak1600_updstate_avx2x4.ec`** was rewritten on 2026-10-07. Nothing admitted. Its array theory clones the fixed-size `KeccakArrayAvx2x4` to reuse the lane lemmas. See [updstate files](#updstate-files-2026-10-07).

### updstate files (2026-10-07)

Measured on 2026-10-07 with `easycrypt compile -no-eco`, one file at a time, EasyCrypt `r2026.09-90-g598d8bf` and `timeout = 5`. Only wall-clock time was recorded.

| File | Wall | Content |
|---|---:|---|
| `common/Keccak1600_updstate.ec` | 13 s | Status word, predicates, shared absorb and squeeze lemmas. |
| `common/Keccak1600_updstate_finish.ec` | 49 s | `finish` and status export, shared by ref and AVX2. The `finish` proof is kept apart because one of its `smt` calls times out with the whole substrate in scope. |
| `ref/Keccak1600_updstate_ref.ec` | 87 s | Memory and array procedures, both branches of the `HAS_AVX2` dispatch. |
| `avx2/Keccak1600_updstate_avx2.ec` | 70 s | Memory and array procedures. Used by ML-DSA. |
| `avx2/Keccak1600_updstate_avx2x4.ec` | 93 s | Array procedures, 4-buffer and broadcast. |
| `extracted/Keccak1600_updstate_ref_checkXtr.ec` | 7 s | New. |
| `extracted/Keccak1600_updstate_avx2_checkXtr.ec` | 6 s | |
| `extracted/Keccak1600_updstate_avx2x4_checkXtr.ec` | 7 s | |

## Reproducing

From `proofs/fips202` (the project file is looked up from the compiled file's location):

```
/usr/bin/time -l easycrypt compile -tstats out.tstats avx2/Keccak1600_fixedsizes_avx2x4.ec
sort -k3 -n -r out.tstats | head     # each line: start-line:col end-line:col seconds
```

To list every axiom in scope, compile a scratch file that `require`s the theories of interest and ends with `print axiom.`. The project's load paths must be given with `-I`/`-R` when the file lives outside `proofs/fips202`.
