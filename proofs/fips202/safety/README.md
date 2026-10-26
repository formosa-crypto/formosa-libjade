# Safety proofs of the Keccak code (`src/fips202`)

This directory proves that the Jasmin implementations in `src/fips202` are
**safe**: every array and memory access is in bounds, no array cell is read
before it is written, no `ui64` arithmetic overflows, and every function meets
the safety contract (`#[safety = { requires, res, ensures }]`) attached to it in
the sources. All implementations are covered: `ref`, `avx2` and `avx2x4`, with
their memory and array (`_ASIZE`) variants, fixed-size absorb/squeeze and the
streaming (`updstate`) API, every Keccak-f[1600] permutation (ref, basic, opt,
avx2; 4-way ref, alt, nat), and the streaming steps on a bare state used by
the ML-DSA hashing boundary (`_absorb_m_state`, `_finish_state`,
`_squeeze_state`).

The proofs come from formosa-keccak (`proof/amd64-barray/safety` at
`6eded33`), whose `src/amd64` is the upstream of `src/fips202`. The sources,
the generator and the generated files are kept in sync with it; see
*jasmin-nist additions* below for what differs, and
`../notes/merge-with-formosa-keccak.md` for the merge.

## Status

Every proof checks, without admits: all procedures of all layers, memory and
array variants, fixed-size and streaming. Run them with

```
make -C proofs check-safety JASMIN_SAFETY_ECLIB=<eclib> JOBS=10
```

(the scenario `fips202-safety` of `proofs/tests.config`; the `fips202`
scenario excludes this directory). CI runs it, and checks that the committed
models are the extraction of the sources (`.github/workflows/proofs.yml`).
Here the whole scenario (48 files) takes 19 min wall-clock with `JOBS=10`
on a 10-core laptop, bounded by the 4-way absorb/squeeze file (2026-10-26,
EasyCrypt `jasmin-nist` branch `df41d3ab`). Per-file times measured in
formosa-keccak on the same kind of machine (two files at a time;
`gen/profile.py` gives the breakdown):

| File | Time |
| --- | --- |
| `common/Keccak1600_common_safety.ec` | 2.5 min |
| `ref/Keccakf1600_safety.ec` | 14 s |
| `ref/Keccak1600_safety.ec` | 3 min |
| `avx2/Keccak1600_avx2_safety.ec` | 4 min |
| `avx2x4/Keccakf1600x4_safety.ec` | 16 s |
| `avx2x4/Keccak1600x4_safety.ec` | 10 min |

What is left is in the 4-way absorb/squeeze file: fourteen closers of the
four-buffer add-state and streaming steps take 20–60 s each (440 s of its
560 s), because with four buffers in context every `smt` call costs about
0.5 s and their goals have 25–60 atoms.

## Toolchain

Two parts of the safety toolchain are not in the Jasmin release the rest of
the repository uses (2026.03.1); both come from Jasmin's `safety-assert2`
branch (jasmin `1e7479a2`, i.e. commit `c1cae60e` of the generated
`jasmin-compiler` repository):

- **the extraction** `jasmin2ec -m safety` (the 2026.03.1 `jasmin2ec` rejects
  `-m safety`). Only needed to re-extract the models (`extracted/Makefile`,
  variable `JASMIN2EC_SAFETY`).
- **its EasyCrypt library** (eclib): `JSafety.ec`, lemmas added to `Jcheck`,
  `JMemory` and `JByte_array`, and the `VPSLL`/`VPSRL`/`VPSRA` shift count of
  `JWord` taken whole (2026.03.1 takes its low 64 bits). Needed to check the
  proofs (`proofs/Makefile`, variable `JASMIN_SAFETY_ECLIB`).

The `jasminc` of that branch is *not* used: it allocates registers
differently from 2026.03.1, which stays the compiler of the assembly and of
the correctness models. The contracts are inert for 2026.03.1.

The nix dev shell (`flake.nix`, `jasminSafety`) builds that Jasmin and sets
`JASMIN2EC_SAFETY` and `JASMIN_SAFETY_ECLIB`. With opam, install it in a
switch of its own (e.g. `jasmin-safety`, pinned to the `safety-assert2`
branch) and pass `JASMIN2EC_SAFETY=~/.opam/jasmin-safety/bin/jasmin2ec` and
`JASMIN_SAFETY_ECLIB=~/.opam/jasmin-safety/lib/easycrypt/jasmin`. EasyCrypt
is the repository's (`jasmin-nist.opam`); upstream checks the same proofs
with EasyCrypt `main`.

The eclib must shadow the one installed with the 2026.03.1 Jasmin, which
EasyCrypt finds through its configuration. An `idirs` of `easycrypt.project`
is searched after it, so `proofs/Makefile` passes the directory in
`EC_IDIRS` instead (searched first). For interactive work, do the same: e.g.
an `.ecbridge.json` (not committed) with
`"args": ["-I", "Jasmin:<eclib>"]`, or `EC_IDIRS=Jasmin:<eclib>` in the
environment of the editor.

## Extraction: same strategy as the correctness proofs

The extraction follows the pattern of the correctness proofs (`../extracted`),
but with the `barray` array model (the correctness proofs use the old one), so
this directory has its own array theories (`extracted/Array*.ec`,
`BArray*.ec`, ...), not `proofs/arrays`:

* **Memory variants** (and everything that does not depend on the array
  size: permutations, helpers, memory absorb/squeeze, streaming API) are
  extracted directly: `extracted/Keccak1600_Jazz_safety.ec`, module `M`
  (`make -C extracted re_extract_mem`, from `toEC_keccak1600.jazz`, which is
  the correctness harness `../extracted/toEC_keccak1600.jazz`).
* **Array variants** are extracted under the dummy size `_ASIZE = 999`:
  `extracted/Keccak1600_Jazz_ASIZE_safety.ec` (`make -C extracted
  re_extract_array`, from `toEC_keccak1600_ASIZE.jazz`). Its harness requires
  the memory one, so that both extractions select the same permutation
  (`KECCAK_PERMUTATION`): the array theories take the size-independent
  callees from the memory model. (The correctness array harness selects
  another permutation, so it is not reused.) This extraction is abstracted
  over the size by textual manipulation (`scripts/asize_transform.py
  --safety`): each layer becomes an abstract theory, parametrised by the
  array (`op _ASIZE`, `clone ByteArray as A`), whose module `MM` holds the
  abstracted procedures (`BArray999` -> `A`, `999` -> `_ASIZE`; callees of
  other layers taken from `RW.MM`, callees that do not depend on the size
  taken from the memory extraction's `M`), followed by their safety
  specifications restated over `MM`, and by the proofs. The layers mirror the
  correctness theories:

  | Theory | File | Procedures |
  | --- | --- | --- |
  | `ReadWriteArraySafety` | `common/Keccak1600_common_safety.ec` | array sub-reads/sub-writes |
  | `KeccakArrayRefSafety` | `ref/Keccak1600_safety.ec` | ref fixed-size array absorb/squeeze |
  | `KeccakUpdstateRefSafety` | `ref/Keccak1600_safety.ec` | ref array streaming API, `_squeeze_state` |
  | `KeccakArrayAvx2Safety` | `avx2/Keccak1600_avx2_safety.ec` | avx2 fixed-size array absorb/squeeze |
  | `KeccakArrayAvx2x4Safety` | `avx2x4/Keccak1600x4_safety.ec` | 4-way fixed-size array absorb/squeeze |
  | `KeccakUpdstateAvx2x4Safety` | `avx2x4/Keccak1600x4_safety.ec` | 4-way array streaming API |

  The theories other than `ReadWriteArraySafety` clone it as `RW`.
* **Sanity checks**: `extracted/<layer>_checkXtr.ec` instantiates each theory
  at `_ASIZE = 999`, `A = BArray999`, proves `M.f ~ MM.f : ={arg} ==> ={res}`
  by `sim` for each procedure of the layer, and transfers each safety lemma of
  the theory to the corresponding specification of the extraction
  (`conseq`). The transfer also checks that the specifications restated over
  `MM` are those of the extraction. They are part of the scenario.
* **Client use** at a given size follows the same steps: clone the theory with
  the concrete array, prove the client's extracted procedure equivalent to
  `MM.f` by `sim`, and transfer the safety lemma with `conseq`.

## Layout

| Path | Content |
| --- | --- |
| `extracted/` | The two models, their array theories, the harnesses, the `*_checkXtr.ec` checks. |
| `common/Keccak1600_common_safety.ec` | Helpers: feature query, shifts, rho offsets, memory sub-reads/sub-writes, 4-way pack/unpack, status-word decoder; bitmap and word lemmas; theory `ReadWriteArraySafety`. |
| `ref/Keccakf1600_safety.ec` | 1-way permutations (ref, basic, opt, avx2) and the dispatcher `_keccakf1600`. |
| `ref/Keccak1600_safety.ec` | ref memory absorb/squeeze, streaming API and bare-state steps; the two ref array theories. |
| `avx2/Keccak1600_avx2_safety.ec` | AVX2 state helpers, memory absorb/squeeze; the avx2 array theory. |
| `avx2x4/Keccakf1600x4_safety.ec` | 4-way permutations (ref, alt, nat), dispatcher, 4-way state init and rate bit. |
| `avx2x4/Keccak1600x4_safety.ec` | 4-way memory absorb/squeeze and streaming API; the two 4-way array theories. |
| `gen/` | The generator of the proof files and of the `*_checkXtr.ec` files. |

## jasmin-nist additions

`src/fips202/ref/keccak1600_updstate{,_ASIZE}.jinc` differ from upstream,
and so do the ref models, `gen/cfg_ref.py` and the generated
`ref/Keccak1600_safety.ec`; the other layers regenerate identically.

- **`if (SPILL)` around the permutation** in the streaming loops (spill to
  MMX unless the permutation is the AVX2 one): the loop body is a conditional
  with calls, so it is cut after the add/dump call (`CUT1` of the absorbs,
  `CUT3` of the squeezes: the loop invariant with `at = r8`). The
  `#declassify`/`#init_msf` statements are plain assignments in the model.
- **Export wrappers** live in `ref/keccak1600_updstate{,_ASIZE}_export.jinc`
  (with their upstream contracts); the harness requires those.
- **Bare-state steps** for the ML-DSA hashing boundary (rate and position
  as arguments instead of the status word), with their own contracts:
  `_absorb_m_state` (memory), `_finish_state` (memory),
  `_squeeze_state` (array; in `KeccakUpdstateRefSafety`, preset
  `updstate_ref` of `scripts/asize_transform.py`).

## How the models and the specifications look

In the models every procedure returns, besides its results, a *trace*: the
list of the safety conditions met along the execution (bounds of each array or
memory access, initialisation of each array read, range of each `ui64`
operation, the callee contracts). For each procedure `f` the extraction
defines

```
op f_spec args = hoare [M.f : args = ... /\ requires ==> ensures /\ valid res.`trace]
```

where `requires`/`ensures` come from the contract of `f` (a function without
contract gets the default one: its array arguments are fully initialised on
entry and on exit). Array initialisation is tracked by byte bitmaps `b_x`
(`BArrayN.is_init b_x k l`), and memory validity by `is_valid ptr_modulus
Glob.mem_v p l`. The lemma `f_proof` proves `f_spec` (about `M.f`, or about
`MM.f` inside an array theory).

## How the proofs are produced

The proof files and the checks are generated: do not edit them, edit
`gen/cfg_<layer>.py` and rerun it (e.g. `python3 gen/cfg_ref.py`). The
generator (`gen/gen.py`) parses the models and builds a proof script for each
procedure:

* the pure helpers (`__HAS_FEATURE`, `__KECCAK_F`, the shifts,
  `__stavx2_pos_avx2`, ...) are inlined;
* conditionals are split forward (`sp n; if`): this version of EasyCrypt's
  `sp` executes through conditionals, and `wp` over a sequence of
  conditionals blows up the goal;
* a conditional followed by a loop or by another conditional with calls is
  proved once, as a step `seq : (JOIN)` whose two branches are closed
  inside it, and the rest of the procedure continues once from `JOIN`
  (otherwise the rest would be proved once per branch, and a sequence of
  such conditionals once per path: the avx2 dump cascade had 200 closers
  for 9 conditionals). `JOIN` is the annotation `MERGE<k>` of the k-th
  conditional, or, when the next loop or conditional follows through
  assignments only, its own `INV<k>`/`CUT<k>`, which describes the same
  point. The generator prints on stderr the formula that would allow a
  further merge (`note: <proc>: a join formula ...`); the per-procedure
  option `MERGE` is `auto` (default), `all` (merge everywhere, missing
  formulas appear as `(* MISSING *)`) or `off`;
* straight-line code is closed backward, calls through the callee lemma
  (`wp; ecall (g_proof args)`, `RW.g_proof` for a subreadwrite callee of an
  array theory), and the remaining goal by a fixed closer: unfold `is_init`
  and `valid`, introduce, then split the conjunction two levels deep and
  call `smt` on each part (the full split, one `smt` call per atom, is the
  fallback: an `smt` call costs 0.2–0.6 s whatever its size, and a goal has
  typically 40–60 atoms, so this is 8–15× faster). The per-procedure option
  `SPLIT` gives the depths to try, default `(2, 'all')`;
* the only manual input is given in `gen/cfg_*.py`, as formulas over the
  program and lemma variables: loop invariants `INV<k>` (k-th `while` of the
  procedure), cuts `CUT<k>` (state before the k-th conditional, when calls
  precede it), joins `MERGE<k>` (state after the k-th conditional) and
  `BEFORE<k>` (state before the k-th call, to split long call chains), and
  extra `smt` hints (`SMT`). For the array procedures they are written for
  the 999 extraction and abstracted like the code. A few procedures with
  word-level reasoning have hand-written proofs (`gen/common_manual.json`).
  Two more options:
  * `STEPWP`, for long straight-line bodies (the permutation rounds): the
    proof reduces the projections of the result tuple right after `proc`, so
    that the word computations become irrelevant to the postcondition, then
    runs `wp` a few instructions at a time with `simplify` in between, so that
    they are dropped as they appear. A single `wp` followed by `/=` would
    substitute the whole chain of `let`s and blow up.
  * `SMT2`, a fallback hint list: the closer ends with `(smt(SMT) || smt(SMT2))`.
    With four buffers in context, `smt` can time out on the full hint list
    where a short one succeeds.

The absorb and squeeze code of the avx2 implementation reads and writes the
state through a cascade of fixed-length sub-reads (resp. sub-writes) at fixed
positions. `gen/cascade.py` describes the state reached after the cascade has
processed the state up to byte `c` (`J c`: position, remaining length, trail
byte and pointer; `W k`: bytes written so far), and each cut is one of these.

After changing a contract or an implementation: re-extract (`make -C
extracted re_extract`, which also writes the `*.skel` files the generator
reads; they are not committed), regenerate every layer (`python3
gen/cfg_common.py`, `cfg_perm.py`, `cfg_ref.py`, `cfg_avx2.py`, `cfg_x4.py`,
`cfg_x4perm.py`), and rerun the checks. The annotations are
keyed by loop/conditional/call ordinals, so they survive changes to the
assertions, but not to the control structure of a procedure.

`python3 gen/profile.py <file.ec>` (with `EC_IDIRS=Jasmin:<eclib>`)
compiles a proof file with EasyCrypt's `-tstats` and reports where the time goes: per command kind, per lemma (with
its number of closers and conditionals), and the slowest commands. The time
is essentially the closers' `smt` calls, so the number of closers (the
merges above) and the number of calls per closer (the split depth) are the
two levers.

## Checking time: findings and workarounds

Measured with `gen/profile.py` on the generated proofs (EasyCrypt r2026.09,
Z3 4.13 and CVC5 1.3 in parallel, 5 s timeout). The status table above has
the resulting times; this section records what was found, since it shapes
the generator.

1. **All the time is in the closers, and a closer is a number of `smt`
   calls.** Every other command (`sp`, `if`, `seq`, `ecall`, `while`,
   declarations) is negligible. After the intros a closer's goal has 40–60
   atoms (mostly the `ui64` range facts of the trace, then bitmap cells and
   the cut formula); one `smt` call costs 0.2–0.6 s whatever the size of
   its goal (0.5–0.9 s with four buffers in context), and only two atoms
   out of 59 were closable without a prover. So the time is (number of
   closers) × (calls per closer) × (cost per call).

2. **Branch duplication.** The generator proved a conditional by duplicating
   the rest of the procedure into both branches, so a sequence of sibling
   conditionals was proved once per path: the avx2 dump cascade, nine
   conditionals, had 200 closers. *Workaround:* the join cuts (`MERGE<k>`,
   or the next `CUT`/`INV`; see above), 19 closers.

3. **Shallow splitting.** One `smt` call on a conjunction of ~15 atoms
   succeeds as often as not and costs the same as one call on an atom, so
   splitting two levels and calling `smt` on each part is 8–15× faster
   than one call per atom. Two caveats. The goal is right-nested, so `do
   2!(split ...)` peels two atoms and leaves everything else as one
   conjunct; that conjunct fails when it holds a hard atom (a pair of
   modular equalities, or, with four buffers, anything once the word-bound
   lemmas `W8/W64.to_uint_cmp` are among the hints), and a failing call
   costs the whole 5 s timeout. *Workaround:* shallow attempt, then the
   full split on what is left (`SPLIT` option, default `(2, 'all')`;
   `('all',)` for the procedures where the attempt always fails, the 1-way
   permutation drivers).

4. **A failing `smt` is not caught by `try` or `||`.** In strict proof mode
   (the default when checking) `smt` fails with an *uncatchable* error
   (`EcLowGoal.t_smt`: `tc_error ~catchable:false "cannot prove goal
   (strict)"`), and `FApi.t_try` rethrows uncatchable errors. The earlier
   `(smt(H) || smt(H2))` fallback therefore never fell back. The tactical
   `try! t` runs `t` in sloppy mode (catchable) and restores the goal on
   failure; it is only legal in strict mode, so it cannot be nested.
   `smt(timeout=...)` does not parse. *Workaround:* the shallow attempt is
   `(try! smt(...))`, the final one a plain strict `smt`.

5. **Goals that are hypotheses.** The alt driver's closers only had to
   match the validity of a trace variable with the hypothesis saying so;
   `smt` took 11 s per closer on these (24 closers), `done` nothing.
   *Workaround:* `try done` before every `smt`.

6. **Long straight-line bodies.** For the `nat` 4-way round (308
   instructions) the symbolic execution before the prover took 54 s and the
   prover 0.3 s: one `wp` followed by `/=` substitutes the whole chain of
   lets. *Workaround:* `STEPWP` (projections first, then `wp` ten
   instructions at a time), as for the `opt` round.

7. **Hint lists.** A short list (no word-bound lemmas) proves in 0.4 s the
   four-buffer conjunct that times out with the full list, but used as the
   default first attempt it tripled the ref file and doubled the 4-way one:
   it fails on most conjuncts, each failure costing the timeout. So `SMT2`
   stays an explicit, per-procedure option (the 4-buffer absorb loop), and
   the atoms always get the full list.

8. **Load.** The same file varies by up to 2× between a quiet and a busy
   machine (each `smt` call starts two provers). Compare times from single runs with care;
   the table above was measured two files at a time.

What remains: the fourteen closers of the four-buffer 4-way add-state and
streaming steps (20–60 s each, 440 s of that file's 560 s). Their cost is
the per-call price of a context holding four buffers' validity and bitmap
facts, times 25–60 atoms; fewer or cheaper calls there need either a
smaller context for the range atoms or bitmap lemmas proved once in the
array theories, neither of which is done.

## Changes to the sources made for the proofs

These changes were made in formosa-keccak (the commits below are
formosa-keccak's) and merged into `src/fips202`. The proofs required one
change to the executable code and several changes to the contracts. None of
them changes what the code computes: the correctness proofs (`../ref`,
`../avx2`, and formosa-keccak's two trees) check against the changed code,
and the Jasmin tests pass.

### Pointer advance in the streaming absorb/dump (commit `16d8a25`)

When a streaming absorb or dump starts in the middle of a state word
(`at8 = at % 8 != 0`) and more words follow, the buffer pointer (memory
variants) or the offset (array variants) must advance by `8 - at8`. The code
did it in two steps; it now adds `8 - at8` in one:

```
// before                // after
buf += 8;                len = 8;
buf -= (64ui) at8;       len -= (64ui) at8;
                         buf += len;
```

In the safety model every `ui64` operation is range-checked. The contracts
only guarantee that the input ends below 2^64 (`is_mem_init(buf, upto - at)`),
so the intermediate `buf + 8` can exceed 2^64-1 by up to 7 although the final
pointer is in range; the same holds for the offset in the abstract array
theories, where `_ASIZE` is any size below 2^64. These range checks cannot be
proved. The one-step sum never exceeds the end of the input. `len` is dead at
that point, the instruction count is the same, and the 4-way memory code
(`_add_m_updstate_avx2x4`, `_dump_m_updstate_avx2x4`) already did this.

| File | Functions |
| --- | --- |
| `src/fips202/ref/keccak1600_updstate.jinc` | `_add_m_updstate`, `_dump_m_updstate` |
| `src/fips202/ref/keccak1600_updstate_ASIZE.jinc` | `_add_updstate`, `_dump_updstate` |
| `src/fips202/avx2/keccak1600x4_updstate.jinc` | `_add_m_bcast_updstate_avx2x4` |
| `src/fips202/avx2/keccak1600x4_updstate_ASIZE.jinc` | `_add_bcast_updstate_avx2x4`, `_add_updstate_avx2x4`, `_dump_updstate_avx2x4` |

On the correctness side, the hand-maintained `MM` blocks of the updstate
theories follow the new code, and a few pointer rewrites changed in
`../ref/Keccak1600_updstate_ref.ec` and `../avx2/Keccak1600_updstate_avx2x4.ec`.

### Length bound on the array streaming contracts (commit `16d8a25`)

The streaming absorb and squeeze loops start with `len += at`, where
`at < r8 <= 200`. The memory contracts require `len <= 0xFFFFFFFFFFFFFF00`
for this; the array contracts only had `len <= _ASIZE`, which does not suffice
in the abstract theories. They now carry the same bound, which any real array
size implies: `_absorb_updstate`, `_squeeze_updstate`, `absorb_updstate`,
`squeeze_updstate` (`ref/keccak1600_updstate_ASIZE.jinc`), their 4-way
counterparts and the two 4-way broadcast absorbs
(`avx2/keccak1600x4_updstate_ASIZE.jinc`).

### Contract fixes and additions (commit `cac4567`)

Contracts only; the correctness models did not change.

* Fixed-size absorb (ref, avx2, avx2x4, memory and array): the contracts
  required `AT + LEN + (TRAILB != 0) < 200` (or only `AT < 200`) and gave the
  final position as `AT + LEN + (TRAILB != 0)`. Both hold only when no
  permutation runs, so they excluded or misdescribed multi-block absorbs. They
  now require `AT < RATE8` and give `(AT + LEN) % RATE8 + (TRAILB != 0)`.
  The add-state helpers bound the position by
  `AT + LEN + (TRAILB != 0) <= 200` (was `< 200`, or only `AT < 200`).
* ref fixed-size absorb/squeeze: the contracts had been copied from avx2 and
  described a 224-byte state (`7*32`); they now describe the 200-byte state.
* Memory sub-reads (`common/subreadwrite_imem.jinc`): they require the whole
  remaining input and state the pointer advance in case form (see the notes
  below). Array sub-reads/sub-writes (`common/subreadwrite_ASIZE.jinc`):
  `0 <= LEN` and case-form ensures.
* New contracts: the streaming functions, the status-word decoders, the 4-way
  `alt` kernels, the `opt` loop body (`rax <=u 22`, final `rax == rax + 2`),
  `__not_lane_basic` (`idx < 25`), `__f1600_loopbody_native` (`i < 24`) and
  `__pround_basic_inlined`.

## Notes on the contracts

* The extractor adds, for every `ui64` subterm of an `ensures`, an unguarded
  range condition. The fixed-length memory sub-reads therefore state the
  pointer advance as `final_buf - buf == (...)` with the case analysis inside
  the right-hand side, so that this condition always holds.
* The fixed-length sub-reads require the whole remaining input
  (`is_mem_init(buf, LEN)`, resp. `is_arr_init(buf, offset+DELTA, min(LEN, W))`),
  which their callers always have.
