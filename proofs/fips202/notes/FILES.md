# fips202 proofs: per-file compile time and trust base

Measured 2026-10-05/06 on branch `formosa-keccak-proof-merge`, commit `6e98b395`.

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
- **Trust base.** 49 lemmas in 7 files are admitted or contain `admit`; 38 of them are in the two `updstate` files. The `bind circuit` declarations and some unproved clone obligations are also trusted. See [Trust base](#trust-base).

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
| `common/keccak_bindings.ec` | 12.4s | 10.0s | 0.4 GiB | - | - | 3 | 12.9s (0) |
| `extracted/Keccak1600_fixedsizes_avx2x4_checkXtr.ec` | 8.6s | 8.4s | 0.6 GiB | - | - | - | 8.7s (0) |
| `avx2/Keccak1600_avx2x4.ec` | 8.1s | 7.5s | 0.9 GiB | - | - | 2 | 8.1s (0) |
| `extracted/Keccak1600_fixedsizes_avx2_checkXtr.ec` | 8.1s | 7.9s | 0.6 GiB | - | - | - | 8.2s (0) |
| `ref/Keccakf1600_ref.ec` | 7.9s | 6.7s | 0.7 GiB | - | - | - | 7.3s (0) |
| `avx2/Keccak1600_avx2.ec` | 7.2s | 6.5s | 1.0 GiB | - | - | 1 | 6.9s (0) |
| `extracted/Keccak1600_updstate_avx2x4_checkXtr.ec` | 7.2s | 7.0s | 0.6 GiB | - | - | - | 7.1s (0) |
| `extracted/Keccak1600_fixedsizes_ref_checkXtr.ec` | 6.6s | 6.4s | 0.6 GiB | - | - | - | 6.9s (0) |
| `extracted/Keccak1600_updstate_avx2_checkXtr.ec` | 5.0s | 4.8s | 0.6 GiB | - | - | - | 5.0s (0) |
| `avx2/Keccak1600_updstate_avx2x4.ec` | 4.1s | 4.0s | 0.5 GiB | - | - | 23 | 4.2s (0) |
| `avx2/Keccakf1600_avx2x4.ec` | 4.0s | 3.8s | 0.6 GiB | - | - | - | 4.0s (0) |
| `ref/Keccakf1600.ec` | 4.0s | 3.9s | 0.6 GiB | - | - | - | 4.1s (0) |
| `avx2/Avx2_extra.ec` | 3.4s | 3.1s | 0.5 GiB | - | - | - | 3.4s (0) |
| `ref/Keccak1600_ref.ec` | 3.2s | 2.9s | 0.4 GiB | - | - | 1 | 3.1s (0) |
| `extracted/Keccak1600_subreadwrite_checkXtr.ec` | 3.1s | 3.0s | 0.4 GiB | - | - | - | 3.2s (0) |
| `extracted/Keccak1600_Jazz_ASIZE.ec` | 2.1s | 2.1s | 0.3 GiB | - | - | - | 2.1s (0) |
| `extracted/Keccak1600_Jazz.ec` | 2.1s | 2.0s | 0.3 GiB | - | - | - | 2.0s (0) |
| `spec/FIPS202_SHA3.ec` | 1.2s | 1.1s | 0.2 GiB | - | - | - | 1.6s (0) |
| `spec/FIPS202_Keccakf1600.ec` | 1.2s | 1.1s | 0.2 GiB | - | - | - | 1.2s (0) |
| `spec/Keccak1600_arrays.ec` | 1.2s | 1.0s | 0.2 GiB | - | - | - | 1.1s (0) |
| **Total** | **35m38s** | **17m10s** | | **34** (17m05s) | | | **25m25s** (10, 5m07s) |

"Admitted lemmas" counts lemmas whose proof ends in `admitted` or contains an `admit` tactic, outside comments.

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
| `avx2/kck_abs_bindings.ec` | 43, 45, 54, 57 | `flatten_ctt_inj` | `have -> : … ; smt(@IntDiv).` (four times) |
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

| File | Lemmas | Notes |
|---|---|---|
| `common/keccak_bindings.ec` | `W16_sar_div` (L212), `W32_sar_div` (L219), `W64_sar_div` (L226) | The first two discharge the W16/W32 `bvashrP` binding obligations (L326, L473). `W64_sar_div` is unused. Proved versions of the W16/W32 lemmas exist in `core/eclib/JWord_extra.ec` (L212, L393, stated with `sar`), and `avx2/kck_bindings.ec` already uses those. |
| `common/Keccak1600_subreadwrite.ec` | `m_rlen_read_upto8_h` (L1880), `m_rlen_write_upto8_h` (L2036), `a_rlen_read_upto8_h` (L3702), `a_rlen_write_upto8_h` (L3720) | No proof uses them yet. The procedures are called from the `updstate` modules. |
| `ref/Keccak1600_ref.ec` | `state_init_h` (L99) | `admit (* circuit *)` on the AVX2 branch of `__state_init`, which zeroes the state with 256-bit stores after a CPU-feature check. The scalar branch is proved. Used by `mlkem-correctness/avx2/{768,1024}/MLKEM_keccak_avx2.ec`. |
| `avx2/Keccak1600_avx2.ec` | `addratebit_avx2_h` (L331) | Five `admit` tactics (L346–367). Used by `Keccak1600_fixedsizes_avx2.ec`, which therefore rests on it. |
| `avx2/Keccak1600_avx2x4.ec` | `state_init_avx2x4_h'` (L365, "BDEP?"), `state_init_avx2x4_ph'` (L374) | `h'` proves `state_init_avx2x4_h`, which is used by `mlkem-correctness/avx2/{768,1024}` and `mldsa/.../hashing_4x.ec`. `ph'` is unused. |
| `avx2/Keccak1600_updstate_avx2.ec` | 15 lemmas | `absorb_msg_init` has three `admit`s. The first is annotated "Wrong unless we have = nseq 25 W64.zero". Also `absorb_msg_absorb_m`, `sponge_state_finish`, `init_pabsorb`, `absorb_m_pabsorb`, `finish_absorb`, `absorb_m_updstate_avx2_h`. In theory `KeccakUpdstateAvx2`: `{add,update,dump,squeeze}_updstate_avx2_ll` (`admit` tactics) and `{add,update,dump,squeeze}_updstate_avx2_h` (`admitted`). Used by `mldsa/x86-64/avx2/ml_dsa_65/hashing.ec`. |
| `avx2/Keccak1600_updstate_avx2x4.ec` | 23 lemmas | Every proof in the file is admitted. It states contracts for the 4-way `updstate` procedures. Nothing outside the file uses them. |

### Axioms

- **Abstract-theory parameters.** `_ASIZE_ge0` and `_ASIZE_u64` in `ReadWriteArray`, `KeccakArrayRef`, `KeccakArrayAvx2`, `KeccakArrayAvx2x4`, `KeccakUpdstateAvx2` and `KeccakUpdstateAvx2x4`. These are expected. Clones are meant to discharge them.
- **checkXtr clones.** The six `extracted/*_checkXtr.ec` clones discharge only `_ASIZE_ge0`. `_ASIZE_u64` (`999 < W64.modulus`) stays an axiom of each clone, as `print axiom.` shows. It is trivially true and can be added to each clone's `proof` clause.
- **`avx2/kck_abs_bindings.ec`.** The clones `W17` (`BitWordSH` at size 17), `JC17` and `JC2` (`JCircuits2` with `sizeS = sizeB = 17`) leave obligations unproved. These are `JC2.le_size` (`0 <= 17 <= 17`), `JC2.W2.gt0_r`, `JC2.W2.sizeBrS`, plus the definitional axioms of `BitWordSH` and `JC2.W2.Pack`. Nothing outside the file uses these clones; they look like test instantiations.
- **`avx2/kck_bindings.ec`.** The word clones `W4`, `W5`, `W10`, `W11` and `W12`, and the renamed `SHIFT` copies in `JC4` and `JC5`, keep the definitional `BitWordSH` axioms (`addE`, `andE`, …). This is the same pattern as Jasmin's `JWord.W8`–`W256`.
- **Opaque operators.** These are constrained only by admitted lemmas, so in effect they are axioms. In `updstate_avx2`: `absorb_m_updstate_avx2_spec`, `absorb_msg`, `sponge_state`. In `updstate_avx2x4`: `absorb_msg_x4`, `sponge_state_x4`, `finish_updstate_avx2x4_spec`, and `{add,add_bcast,absorb,absorb_bcast,dump,squeeze}_updstate_avx2x4_spec`.

### Trusted declarations

- **`bind circuit`.** `common/keccak_bindings.ec` (L1961, 54 operators) and `avx2/kck_bindings.ec` (L2339, 50 operators) map EasyCrypt AVX2 operators to circuits in `common/avx2.spec`. These mappings are not proved. Both blocks list `VPACKSS_16u16` twice and carry a FIXME on `W4u32.VPEXTR_32`. The AVX2 proofs load both blocks: `Keccak_bindings` directly and `Kck_bindings` through `Avx2_extra`.
- **Other `bind` declarations.** The `bind op`, `bind bitstring` and `bind array` obligations are all realized. The W16/W32 `bvashrP` realizations in `keccak_bindings.ec` rely on the admitted `sar_div` lemmas above.

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
- **The six `*_checkXtr.ec` files** take 3–9 s each. Nothing admitted. Each proves `by sim` equivalences between the hand-written `MM` modules at `_ASIZE = 999` and the extracted model. Loading the proof theory is 2–4 s of that. Each leaves `_ASIZE_u64` unproved (see Axioms).

### common/

- **`keccak_bindings.ec`** takes 12 s. Admitted: `W16/W32/W64_sar_div`. Contains a `bind circuit` block of 54 operators. Time is spread over many `realize` proofs of about 1 s each.
- **`Keccak1600_statebytes.ec`** takes 41 s. Nothing admitted. 30 s of it is one stall in `SQUEEZE1600_split` (L508). With Z3 first it takes 10.5 s.
- **`Keccak1600_subreadwrite.ec`** takes 2m34s, mostly EasyCrypt CPU (1m55s), and peaks at 1.9 GiB. It is the largest file, with 3857 lines and about 2000 timed commands.
  - Admitted: the four `*_rlen_*_upto8_h` lemmas.
  - Axioms: the `ReadWriteArray` parameters.
  - One stall, in `asubwrite_squeeze_last` (L2761).
  - The costliest lemma is `a_set256_fill` at 17.5 s. One rewrite chain in it (L2555) takes 13.3 s, unfolding `set256` over 32 bytes.
  - The `*_ilen_*_h` procedure proofs take 3–5 s each.

### ref/

- **`Keccakf1600_ref.ec`** takes 7.9 s. Nothing admitted.
- **`Keccakf1600_basic.ec`** takes 13.9 s. Nothing admitted. It makes 33 `circuit` calls totalling 7.0 s.
- **`Keccakf1600_opt.ec`** takes 3m19s and peaks at 2.3 GiB. Nothing admitted. The `by circuit` that closes `keccakf1600_dround_opt_h` (L113) takes 193 s. It is the most expensive single command in fips202, and covers two rounds of the loop body after `swap`/`cfold`/`proc change` preparation. With Z3 first, a 30 s stall appears in `__keccakf1600_opt_h` (L172).
- **`Keccak1600_ref.ec`** takes 3.2 s. Admitted: `state_init_h` (AVX2 branch).
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
- **`Keccak1600_avx2.ec`** takes 7.2 s. Admitted: `addratebit_avx2_h`.
- **`Keccak1600_avx2x4.ec`** takes 8.1 s. Admitted: `state_init_avx2x4_h'` and `state_init_avx2x4_ph'`.
- **`Keccakf1600_avx2x4_ref.ec`** takes 12.8 s. Nothing admitted. `circuit` on the round takes 5.4 s.
- **`Keccakf1600_avx2x4_nat.ec`** takes 27 s. Nothing admitted. `circuit` in `loopbody_nat_h` takes 22 s.
- **`Keccakf1600_avx2x4_alt.ec`** takes 2m39s and has the highest peak memory, 3.2 GiB. Nothing admitted.
  - Time goes to `kernel_even_alt_h` (70 s), `kernel_odd_alt_h` (68 s) and `kernel_last_alt_h` (5.7 s), all `by circuit`, plus `islossless` in `__keccakf1600_avx2x4_alt_ll` (4.4 s).
  - The banner at L53 still says the kernel contracts are "admitted", but they are proved.
- **`Keccakf1600_avx2x4.ec`** takes 4.0 s. Nothing admitted. It is the 4-way permutation dispatcher.
- **`Keccak1600_fixedsizes_avx2.ec`** takes 3m55s, of which 1m20s is EasyCrypt CPU. Peak 3.1 GiB.
  - Nothing admitted in the file. Axioms: the `KeccakArrayAvx2` parameters. It uses the admitted `addratebit_avx2_h`.
  - Five stalls account for 2m31s.
  - Without them, the work is in `addstate_avx2_h` (17 s), `addstate_m_avx2_h` (17 s) and `dump_avx2_lanes4` (10.6 s, all in one rewrite at L105).
  - Its 22 `circuit` calls take 1.0 s in total.
  - With Z3 first it takes 3m28s, with two new stalls in `absorb_m_avx2_h` and slower calls elsewhere.
- **`Keccak1600_fixedsizes_avx2x4.ec`** is the slowest file at 8m21s, of which 1m55s is EasyCrypt CPU. Peak 1.6 GiB.
  - Nothing admitted. Axioms: the `KeccakArrayAvx2x4` parameters.
  - Twelve stalls account for 6m02s. Each of the four absorb lemmas has two, so it takes about 72 s instead of about 12 s.
  - Without the stalls, the costliest lemmas are `addstate_m_avx2x4_h` (14 s), `addstate_avx2x4_h` (13 s) and the four absorbs (11–12 s each).
  - With Z3 first it takes 5m45s, with 5 new stalls.
- **`Keccak1600_updstate_avx2.ec`** takes 58 s.
  - Admitted: 15 lemmas, and it has opaque operators (see Trust base).
  - `finish_updstate_avx2_h` takes 39 s, spread over about 300 commands with no single slow step. `init_updstate_avx2_h` takes 7.3 s.
- **`Keccak1600_updstate_avx2x4.ec`** takes 4.1 s. Admitted: 23 lemmas, which is every proof in the file.

## Reproducing

From `proofs/fips202` (the project file is looked up from the compiled file's location):

```
/usr/bin/time -l easycrypt compile -tstats out.tstats avx2/Keccak1600_fixedsizes_avx2x4.ec
sort -k3 -n -r out.tstats | head     # each line: start-line:col end-line:col seconds
```

To list every axiom in scope, compile a scratch file that `require`s the theories of interest and ends with `print axiom.`. The project's load paths must be given with `-I`/`-R` when the file lives outside `proofs/fips202`.
