# Keccak1600 `updstate` proofs

The `updstate` procedures are the streaming interface of the Keccak code: `init`, then
any number of `absorb` calls, then `finish`, then any number of `squeeze` calls. They
exist in two variants, each with memory and array buffers:

- **Single lane**, `src/fips202/ref/keccak1600_updstate{,_ASIZE}.jinc`. The permutation
  is chosen at build time through `KECCAK_PERMUTATION`, and the proofs hold for every
  choice.
- **4-way AVX2**, `src/fips202/avx2/keccak1600x4_updstate{,_ASIZE}.jinc`.

As of 2026-10-07 both are proved, with no admitted lemma. Until then there was also an
AVX2 single-lane copy. It was the ref code with the AVX2 permutation hard-wired, and it
was removed (see [Consolidation](#consolidation-2026-10-07)).

## What is proved

The state carries one extra 64-bit status word after the Keccak lanes: word 25 for the
single-lane state, word 100 for the 4-way state. Byte 0 is the cursor `at`, byte 1 is
`r64 - 1` (so the rate in bytes is `r8 = 8 * r64`), byte 2 is the trail byte.

Every contract is stated with two predicates from `common/Keccak1600_updstate.ec`:

- `absorbing_spec r8 tb l st` says that `st` has absorbed the byte list `l` with rate
  `r8` and trail byte `tb`.
- `squeezing_spec r8 st0 k st` says that `st` has squeezed `k` bytes from the absorbed
  state `st0`.

The 4-way file has the lane-wise versions `absorbing_spec4` and `squeezing_spec4`. The
contracts read as follows.

| Procedure | Pre                                     | Post                                                                       |
| --------- | --------------------------------------- | -------------------------------------------------------------------------- |
| init      | `0 < r64 <= 25`                         | `absorbing_spec (8*r64) tb [] res`                                         |
| absorb    | `absorbing_spec r8 tb l st`             | `absorbing_spec r8 tb (l ++ input) res`                                    |
| finish    | `absorbing_spec r8 tb l st`             | `squeezing_spec r8 (ABSORB1600 tb r8 l) 0 res`                             |
| squeeze   | `squeezing_spec r8 st0 k st`, `0 < len` | output is `sqstream r8 st0 k len`, and `squeezing_spec r8 st0 (k+len) res` |

`sqstream r8 st0 k n` is the slice `[k, k+n)` of the squeezed stream, so chaining
squeezes concatenates their outputs. `ABSORB1600` and `SQUEEZE1600` are the spec
operators that the fixed-size proofs also use. Each procedure also has a losslessness
lemma (`_ll`) and a `phoare` form (`_ph`). The export wrappers get the same contracts,
so callers never see the argument order of the internal procedures.

Two behaviours of the code show up in the contracts:

- **A zero-length squeeze is not a no-op.** At a block boundary it permutes the state,
  which skips a block. The squeeze contracts therefore require `0 < len`.
- **The cursor is stored lazily after a squeeze.** It can equal `r8`. The predicates use
  the normalised cursor `ststatus_at_norm`, which maps `r8` to 0, exactly as the code's
  decoder does.
- **The four output buffers of the 4-way memory squeeze must not overlap.** The code
  writes the lanes word by word, interleaved. The memory dump and squeeze therefore
  require `disj4` over the output length, and state the output as `stores4`, the four
  lanes' stores in sequence.

**Checked on 2026-10-07**, after the consolidation, the 4-way memory variant and the
source cleanup, with `make -C proofs <scenario> JOBS=10`:

| Scenario          | Files |   Wall |
| ----------------- | ----: | -----: |
| `fips202`         | 39/39 |  5m34s |
| `mldsa`           | 72/72 |  4m35s |
| `mlkem-avx2-768`  | 22/22 | 10m41s |
| `mlkem-avx2-1024` | 22/22 | 10m49s |

## Files

| File                                                     | Content                                                                                                                                                               |
| -------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `common/Keccak1600_updstate.ec`                          | Status-word encoding and decoder contracts, the predicates, and the pure lemmas shared by all variants (block arithmetic, absorb steps, squeeze stream slicing).      |
| `common/Keccak1600_updstate_finish.ec`                   | The single-lane `finish` and status-export proofs. It is a separate file because one `smt` call in the `finish` proof times out when the whole substrate is in scope. |
| `common/Keccak1600_subreadwrite.ec`                      | The `*_rlen_*_upto8` read/write contracts, now proved, and their bridges to the fixed-size `msubread`/`asubread` steps.                                               |
| `ref/Keccak1600_updstate_ref.ec`                         | Memory and array procedures, single lane. Covers both branches of the `HAS_AVX2` dispatch in the add and dump helpers, and every permutation choice. Used by ML-DSA.  |
| `avx2/Keccak1600_updstate_avx2x4.ec`                     | Memory and array procedures of the 4-way variant, with four buffers and with one broadcast buffer.                                                                    |
| `extracted/Keccak1600_updstate_{ref,avx2x4}_checkXtr.ec` | `by sim` checks that each hand-written `MM` module equals the extracted code at `_ASIZE = 999`, wrappers included.                                                    |

## Design

The proofs follow the fixed-size layout. Memory procedures are proved at top level
against `Keccak1600_Jazz.M`. Array procedures are proved in an abstract theory over
`_ASIZE`, with a module `MM` that copies the extracted array code and calls the
size-independent procedures of `Keccak1600_Jazz.M`.

The proofs share as much as possible with the fixed-size material:

- **Add and dump.** The add helpers are proved with the fixed-size `addstate_spec`
  invariant and its step lemmas (`addstate_spec_init`, `_fullword`, `_finish`, `_done`).
  The only new pieces are the bridges from the runtime-length `rlen` reads to
  `msubread`/`asubread` steps (`msubread_rlen`, `asubread_rlen`). The dump helpers use
  an overwrite lemma (`stores_overwrite`, `afill_overwrite`) to absorb the junk bytes
  that a partial first word writes.
- **Absorb.** The loop invariant is `pabsorb_spec` from `Keccak1600_statebytes.ec`,
  stepped by `pabsorb_fill_at` and `pabsorb_last_at`.
- **4-way variant.** The proofs reuse the 4-way lane layer of
  `Keccak1600_fixedsizes_avx2x4.ec`. The array theory clones `KeccakArrayAvx2x4` for
  `addstate_spec4`, its step lemmas and `addstate_res4`. The memory proofs use the
  top-level twins `addstate_spec4m`, `addstate_res4m`, `stores4` and `disj4`. Both use
  `pabsorb4_fill` and `pabsorb4_last`. The `updstate` code addresses lanes by byte
  offsets (`4*at + 8*k`) instead of word indices, which two lemmas bridge
  (`st4x_get_xor64x4_at`, `st4x_get64_at`). Three small lemmas complete the memory side:
  `stores4_overwrite` and `stores4_sqstream_step` are the memory twins of
  `afill_overwrite` and `afill_sqstream_step`, and `dump_first_take` gives the first
  dumped word as a byte list for both dumps.
- **Every permutation choice at once.** The single-lane code calls the permutation
  through the dispatcher `_keccakf1600`. Its contract `keccakf1600_h`
  (`ref/Keccakf1600.ec`) is proved for all four branches, so the single-lane proofs do
  not depend on `KECCAK_PERMUTATION`.
- **Argument order.** All helpers follow the fixed-size convention: each procedure
  returns the values it modifies, in the order they appear among its arguments. Add
  returns `(st, at, cursor)` and dump returns `(buffers…, cursor, at)`.
- **Proof reuse across variants.** Hypothesis names are the same in all variants, so the
  array scripts are the memory scripts with the adapters swapped. Several array and
  broadcast proofs passed on their first assembled run.

The previous AVX2 and 4-way files held 38 admitted lemmas and several opaque operators
constrained only by them. Some of those statements were false, for example the AVX2
squeeze contract without an `at = 0` premise. They are all replaced.

## Source changes

The proofs required these source changes, all in `src/fips202`. The fips202 and ML-DSA
models were re-extracted with the pinned Jasmin 2026.03.1.

- **Hoisted shared definitions.** `type keccak_updstate` and `fn _ststatus_data` moved
  to the new `common/keccak1600_updstate_generic.jinc`. Before, the ref and AVX2 files
  both defined them, so `jasminc` rejected a program that required both, and the ref
  variant was never extracted.
- **Lost bytes on a misaligned absorb.** `len = len + (64ui)at;` became `len = len +
  (64ui)at8;` in the AVX2 single-lane and 4-way array absorbs. With an unaligned cursor
  the array absorb dropped data. The same fix is on `origin/ci-mldsa-sct`.
- **Wrong status word in the 4-way export.** `ststatus_updstate_avx2x4` read the status
  at word 25 instead of word 100. Comments that said `r64 = 8*r8` were also corrected.

## Consolidation (2026-10-07)

The AVX2 single-lane files `avx2/keccak1600_updstate{,_ASIZE}.jinc` computed exactly
what the ref files compute with `KECCAK_F1600_AVX2` selected. The differences were the
hard-wired permutation, narrower add/dump loops, extra register spills in ref, and names
and argument orders. They and their proof `avx2/Keccak1600_updstate_avx2.ec` were
removed:

- **Sources.** The AVX2 single-lane files are deleted.
  `common/keccak1600_updstate_generic.jinc` keeps the state type and decoder of the
  single-lane code.
- **Argument order.** The 4-way add and dump now return their results in the fixed-size
  order, `(st, at, off)` and `(buf0, …, buf3, off, at)`. The commented-out 4-way memory
  block was reordered the same way. The ref files already followed that order.
- **ML-DSA.** `src/mldsa/avx2/common/hashing.jinc` calls the ref procedures
  (`_init_updstate`, `A66::_absorb_updstate`, `_absorb_m_updstate`, `_finish_updstate`,
  `A64::_squeeze_updstate`). ML-DSA keeps its default permutation choice,
  `KECCAK_F1600_OPT`, the one its other single-lane code uses.
  `proofs/mldsa/x86-64/avx2/ml_dsa_65/hashing.ec` clones `KeccakUpdstateRef` and uses
  the ref lemmas; its bridges to the fips202 model stay `by sim`, because both models
  select the same permutation.
- **Models.** `Keccak1600_Jazz{,_ASIZE}.ec` and `ml_dsa_65_avx2.ec` were re-extracted.
  The ML-KEM models and `proofs/arrays` are unchanged.

`origin/ci-mldsa-sct` went the other way: it deletes the ref `updstate` sources and adds
constant-time annotations to the AVX2 and 4-way files. Merging it will conflict on those
files. Its annotations would need porting to the ref files.

## 4-way memory variant (2026-10-07)

Until then `src/fips202/avx2/keccak1600x4_updstate.jinc` held the 4-way memory
procedures only as a commented-out, half-ported copy of the array code. They are now
implemented and proved: `_add_m[_bcast]_updstate_avx2x4`,
`_absorb_m[_bcast]_updstate_avx2x4`, `_dump_m_updstate_avx2x4`,
`_squeeze_m_updstate_avx2x4` and the three exports. The code mirrors the array file
statement by statement, with pointers in place of the offset. One deliberate difference:
after the first, misaligned word, the array code takes the new offset from lane 3's
read. With four pointers, the memory code instead computes the common advance once and
adds it to each pointer.

Before the revival, every existing memory/array pair was compared after normalising
pointer accesses against offset accesses. The ref, AVX2 and 4-way fixed-size pairs and
the ref `updstate` pair follow the same code, up to two systematic differences:

- **Offset bookkeeping.** The fixed-size array helpers accumulate a compile-time `DELTA`
  and add it to the offset at the end; the memory helpers advance the pointer directly.
- **Lengths.** The fixed-size array absorb and squeeze consume the whole `_ASIZE` array;
  the memory ones take an explicit length.

Small divergences were found, none of them semantic. The last three were resolved the
same day:

- **Ref fixed-size scalar add loop (kept).** The memory version indexes the state by
  byte (`st.[:u64 at]`, step 8), the array version by word (`st[at]`, step 1). The
  squeeze loop counter is also incremented at a different point. Both forms cost the
  same: the scaled index is free in x86 addressing. The scalar branch is not compiled at
  all in the AVX2 builds.
- **16-byte write (aligned).** `__m_ilen_write_upto16` took the low word with a cast,
  `(64u) w`; `__a_ilen_write_upto16` used `#MOVV_64(w)`. Both compile to the same
  `movq`; the memory version now uses `#MOVV_64`, the form used elsewhere in the
  sources.
- **Dead helpers (removed).** `__m_ilen_read_upto8_at2` (memory only) and
  `__a_rlen_read_upto8_noninline` (array only) were never called.
- **Dead files (removed).** `src/fips202/avx2/keccak1600_fixedsizes_ref{,_ASIZE}.jinc`
  were required by nothing, and superseded by `ref/keccak1600_fixedsizes{,_ASIZE}.jinc`.
  The array one required a file that does not exist.

## Experiment: EasyCrypt LLM mode against batch compilation

EasyCrypt `r2026.09` adds an interactive mode for tools: `easycrypt llm` and an MCP
server `easycrypt mcp`. We used it for this work and compared it with the batch workflow
used for the fixed-size proofs, where each iteration edits the file, runs `easycrypt
compile` and reads the first error.

**Setup.** A repo-level `.mcp.json` registers `easycrypt mcp -sessions`. The MCP tools
only appear after a session restart, so all the work below used the shell form, which
replays a script in a fresh engine on each call:

```
easycrypt llm -eval 'LOAD "avx2/Keccak1600_updstate_avx2x4.ec" 264 -noproof
STRICT ON
proc; wp; skip => /> .
GOALS'
```

`LOAD file N -noproof` loads the file up to line N without checking proofs. In practice
N is the line before the lemma's `admit`. `STRICT ON` stops at the first failing tactic
and prints the goal at that point.

**Workflow.** Each lemma was stated with `admit`, then developed in the REPL until `No
more goals`. A small script pasted the commands in place of the `admit`. A batch compile
of the whole file confirmed the result at each milestone.

**Measurements.** The work ran in phases rather than as the matched lemma pairs that
were planned. The figures are wall-clock times from the session log.

| Phase                    | REPL runs | Failing runs | Median REPL run | Batch compiles | Median compile |
| ------------------------ | --------: | -----------: | --------------: | -------------: | -------------: |
| Substrate (batch-driven) |        38 |           19 |             6 s |             16 |           22 s |
| AVX2 memory              |       186 |           79 |             7 s |             11 |           83 s |
| AVX2 array               |        47 |           16 |             6 s |              1 |            4 s |
| Shared finish file       |        32 |           15 |            12 s |             10 |           47 s |
| ref                      |        37 |           12 |            14 s |              1 |            8 s |
| 4-way                    |       110 |           36 |           6.5 s |              8 |           31 s |

The substrate phase was driven by batch compiles, with the REPL only for fixing errors.
All later phases were developed in the REPL. A REPL run costs about the same whatever
the file size, because it skips the proofs before the loaded line. A batch compile costs
the whole file: 1–2 minutes for the AVX2 and ref files, more than 2 minutes for
`subreadwrite.ec`.

**Observations.**

- **The REPL loop is roughly ten times shorter.** A failed tactic costs one 5–15 s run
  instead of a 1–2 minute compile.
- **The REPL shows the goal at the failure point.** A batch error gives only a position
  and a message, so the batch loop often needs an extra round to see the goal.
- **Batch checks found no problem in REPL-developed proofs.** They caught lemmas written
  without a REPL run, such as some `_ll` proofs, and slips when pasting a script into
  the file. They also caught one `smt` call in the `finish` proof, ported from
  `ci-mldsa-sct`, that timed out with the whole substrate in scope.
- **Large goals need filtering.** The 4-way states print as nested terms of several
  hundred lines. Showing only the conclusion of the last goal kept the output usable.
- **The input format has sharp edges.** The REPL reads one sentence per line, so a
  multi-line `seq` or `while` invariant must be wrapped in `<BEGIN>`/`<DONE>`. The
  `LOAD` line must stop before the `admit`.
- **The shell form replays the whole script on each call.** Each run therefore repeats
  the `LOAD` and every earlier tactic. A persistent MCP session would avoid that, but
  was not measured.

**Recommendation.** Use the REPL to develop proofs and keep the batch compile as the
final check. Use the MCP server once it is available in the session, because it keeps
the engine state between calls.
