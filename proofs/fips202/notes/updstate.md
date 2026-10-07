# Keccak1600 `updstate` proofs

The `updstate` procedures are the streaming interface of the Keccak code: `init`, then any number of `absorb` calls, then `finish`, then any number of `squeeze` calls. They exist in three variants (ref, AVX2, 4-way AVX2), each with memory and array buffers where the source provides them. As of 2026-10-07 all of them are proved, with no admitted lemma.

## What is proved

The state carries one extra 64-bit status word after the Keccak lanes: word 25 for ref and AVX2, word 100 for the 4-way state. Byte 0 is the cursor `at`, byte 1 is `r64 - 1` (so the rate in bytes is `r8 = 8 * r64`), byte 2 is the trail byte.

Every contract is stated with two predicates from `common/Keccak1600_updstate.ec`:

- `absorbing_spec r8 tb l st` says that `st` has absorbed the byte list `l` with rate `r8` and trail byte `tb`.
- `squeezing_spec r8 st0 k st` says that `st` has squeezed `k` bytes from the absorbed state `st0`.

The 4-way file has the lane-wise versions `absorbing_spec4` and `squeezing_spec4`. The contracts read as follows.

| Procedure | Pre | Post |
|---|---|---|
| init | `0 < r64 <= 25` | `absorbing_spec (8*r64) tb [] res` |
| absorb | `absorbing_spec r8 tb l st` | `absorbing_spec r8 tb (l ++ input) res` |
| finish | `absorbing_spec r8 tb l st` | `squeezing_spec r8 (ABSORB1600 tb r8 l) 0 res` |
| squeeze | `squeezing_spec r8 st0 k st`, `0 < len` | output is `sqstream r8 st0 k len`, and `squeezing_spec r8 st0 (k+len) res` |

`sqstream r8 st0 k n` is the slice `[k, k+n)` of the squeezed stream, so chaining squeezes concatenates their outputs. `ABSORB1600` and `SQUEEZE1600` are the spec operators that the fixed-size proofs also use. Each procedure also has a losslessness lemma (`_ll`) and a `phoare` form (`_ph`). The export wrappers get the same contracts, so callers never see the argument order of the internal procedures.

Two behaviours of the code show up in the contracts:

- **A zero-length squeeze is not a no-op.** At a block boundary it permutes the state, which skips a block. The squeeze contracts therefore require `0 < len`.
- **The cursor is stored lazily after a squeeze.** It can equal `r8`. The predicates use the normalised cursor `ststatus_at_norm`, which maps `r8` to 0, exactly as the code's decoder does.

**Checked on 2026-10-07** with `make -C proofs <scenario> JOBS=10`:

| Scenario | Files | Wall |
|---|---:|---:|
| `fips202` | 41/41 | 6m30s |
| `mldsa` | 72/72 | 4m35s |
| `mlkem-avx2-768` | 22/22 | 10m27s |
| `mlkem-avx2-1024` | 22/22 | 10m10s |

## Files

| File | Content |
|---|---|
| `common/Keccak1600_updstate.ec` | Status-word encoding and decoder contracts, the predicates, and the pure lemmas shared by all variants (block arithmetic, absorb steps, squeeze stream slicing). |
| `common/Keccak1600_updstate_finish.ec` | The `finish` and status-export proofs, shared by ref and AVX2. It is a separate file because one `smt` call in the `finish` proof times out when the whole substrate is in scope. |
| `common/Keccak1600_subreadwrite.ec` | The `*_rlen_*_upto8` read/write contracts, now proved, and their bridges to the fixed-size `msubread`/`asubread` steps. |
| `ref/Keccak1600_updstate_ref.ec` | Memory and array procedures, ref variant. Covers both branches of the `HAS_AVX2` dispatch in the add and dump helpers. |
| `avx2/Keccak1600_updstate_avx2.ec` | Memory and array procedures, AVX2 variant. Used by ML-DSA. |
| `avx2/Keccak1600_updstate_avx2x4.ec` | Array procedures of the 4-way variant. The source has no 4-way memory absorb or squeeze. |
| `extracted/Keccak1600_updstate_{ref,avx2,avx2x4}_checkXtr.ec` | `by sim` checks that each hand-written `MM` module equals the extracted code at `_ASIZE = 999`, wrappers included. |

## Design

The proofs follow the fixed-size layout. Memory procedures are proved at top level against `Keccak1600_Jazz.M`. Array procedures are proved in an abstract theory over `_ASIZE`, with a module `MM` that copies the extracted array code and calls the size-independent procedures of `Keccak1600_Jazz.M`.

The proofs share as much as possible with the fixed-size material:

- **Add and dump.** The add helpers are proved with the fixed-size `addstate_spec` invariant and its step lemmas (`addstate_spec_init`, `_fullword`, `_finish`, `_done`). The only new pieces are the bridges from the runtime-length `rlen` reads to `msubread`/`asubread` steps (`msubread_rlen`, `asubread_rlen`). The dump helpers use an overwrite lemma (`stores_overwrite`, `afill_overwrite`) to absorb the junk bytes that a partial first word writes.
- **Absorb.** The loop invariant is `pabsorb_spec` from `Keccak1600_statebytes.ec`, stepped by `pabsorb_fill_at` and `pabsorb_last_at`.
- **4-way variant.** The theory clones the fixed-size `KeccakArrayAvx2x4` and reuses its lane layer: `addstate_spec4` with its step lemmas, `addstate_res4`, `pabsorb4_fill` and `pabsorb4_last`. The `updstate` code addresses lanes by byte offsets (`4*at + 8*k`) instead of word indices, which two lemmas bridge (`st4x_get_xor64x4_at`, `st4x_get64_at`).
- **Proof reuse across variants.** Hypothesis names are the same in all variants, so the array scripts are the memory scripts with the adapters swapped. Several array and broadcast proofs passed on their first assembled run.

The previous AVX2 and 4-way files held 38 admitted lemmas and several opaque operators constrained only by them. Some of those statements were false, for example the AVX2 squeeze contract without an `at = 0` premise. They are all replaced.

## Source changes

The proofs required these source changes, all in `src/fips202`. The fips202 and ML-DSA models were re-extracted with the pinned Jasmin 2026.03.1.

- **Hoisted shared definitions.** `type keccak_updstate` and `fn _ststatus_data` moved to the new `common/keccak1600_updstate_generic.jinc`. Before, the ref and AVX2 files both defined them, so `jasminc` rejected a program that required both, and the ref variant was never extracted.
- **Lost bytes on a misaligned absorb.** `len = len + (64ui)at;` became `len = len + (64ui)at8;` in `avx2/keccak1600_updstate_ASIZE.jinc` and `avx2/keccak1600x4_updstate_ASIZE.jinc`. With an unaligned cursor the array absorb dropped data. The same fix is on `origin/ci-mldsa-sct`.
- **Wrong status word in the 4-way export.** `ststatus_updstate_avx2x4` read the status at word 25 instead of word 100. Comments that said `r64 = 8*r8` were also corrected.

`origin/ci-mldsa-sct` deletes the ref `updstate` sources and has its own AVX2 and 4-way proofs. Merging it will conflict on those files; keep the versions on this branch.

## Experiment: EasyCrypt LLM mode against batch compilation

EasyCrypt `r2026.09` adds an interactive mode for tools: `easycrypt llm` and an MCP server `easycrypt mcp`. We used it for this work and compared it with the batch workflow used for the fixed-size proofs, where each iteration edits the file, runs `easycrypt compile` and reads the first error.

**Setup.** A repo-level `.mcp.json` registers `easycrypt mcp -sessions`. The MCP tools only appear after a session restart, so all the work below used the shell form, which replays a script in a fresh engine on each call:

```
easycrypt llm -eval 'LOAD "avx2/Keccak1600_updstate_avx2x4.ec" 264 -noproof
STRICT ON
proc; wp; skip => /> .
GOALS'
```

`LOAD file N -noproof` loads the file up to line N without checking proofs. In practice N is the line before the lemma's `admit`. `STRICT ON` stops at the first failing tactic and prints the goal at that point.

**Workflow.** Each lemma was stated with `admit`, then developed in the REPL until `No more goals`. A small script pasted the commands in place of the `admit`. A batch compile of the whole file confirmed the result at each milestone.

**Measurements.** The work ran in phases rather than as the matched lemma pairs that were planned. The figures are wall-clock times from the session log.

| Phase | REPL runs | Failing runs | Median REPL run | Batch compiles | Median compile |
|---|---:|---:|---:|---:|---:|
| Substrate (batch-driven) | 38 | 19 | 6 s | 16 | 22 s |
| AVX2 memory | 186 | 79 | 7 s | 11 | 83 s |
| AVX2 array | 47 | 16 | 6 s | 1 | 4 s |
| Shared finish file | 32 | 15 | 12 s | 10 | 47 s |
| ref | 37 | 12 | 14 s | 1 | 8 s |
| 4-way | 110 | 36 | 6.5 s | 8 | 31 s |

The substrate phase was driven by batch compiles, with the REPL only for fixing errors. All later phases were developed in the REPL. A REPL run costs about the same whatever the file size, because it skips the proofs before the loaded line. A batch compile costs the whole file: 1–2 minutes for the AVX2 and ref files, more than 2 minutes for `subreadwrite.ec`.

**Observations.**

- **The REPL loop is roughly ten times shorter.** A failed tactic costs one 5–15 s run instead of a 1–2 minute compile.
- **The REPL shows the goal at the failure point.** A batch error gives only a position and a message, so the batch loop often needs an extra round to see the goal.
- **Batch checks found no problem in REPL-developed proofs.** They caught lemmas written without a REPL run, such as some `_ll` proofs, and slips when pasting a script into the file. They also caught one `smt` call in the `finish` proof, ported from `ci-mldsa-sct`, that timed out with the whole substrate in scope.
- **Large goals need filtering.** The 4-way states print as nested terms of several hundred lines. Showing only the conclusion of the last goal kept the output usable.
- **The input format has sharp edges.** The REPL reads one sentence per line, so a multi-line `seq` or `while` invariant must be wrapped in `<BEGIN>`/`<DONE>`. The `LOAD` line must stop before the `admit`.
- **The shell form replays the whole script on each call.** Each run therefore repeats the `LOAD` and every earlier tactic. A persistent MCP session would avoid that, but was not measured.

**Recommendation.** Use the REPL to develop proofs and keep the batch compile as the final check. Use the MCP server once it is available in the session, because it keeps the engine state between calls.
