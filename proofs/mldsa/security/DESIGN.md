# Design note: pre-image challenges, leakage, and the SelfTargetMSIS reduction

This note explains the central design point of the ML-DSA proof: why the
challenge of the Fiat-Shamir-with-aborts chain is the *pre-image* `ir` of
SampleInBall rather than the ring element `c`, and why the reduction to the
standard SelfTargetMSIS assumption samples a uniform pre-image of a challenge
(`ChallengeFiber`). Follow the life of a challenge through the proof.

## 1. What `SampleInBallEquiv` proves

In the real world the adversary has a XOF `X : (x, i) -> byte` and the scheme
computes `c = SampleInBall(X)(x)` together with its leakage (one `(ctx, j)`
pair per inner-loop iteration). Theorem `adv_xof_roc` states that this world
is perfectly indistinguishable from the following ideal world:

- a random oracle `R : x -> (ir, rej)` where `ir : challenge_ir` (the sign
  bytes and the accepted index bytes) is uniform on `dI`, and `rej` (the
  rejected bytes) is independent of `ir`;
- the scheme uses `ToC(R)`, which returns `(to_c ir, full_leak ir rej)`;
- the adversary's XOF is simulated by `Sim(R)`: on a query `(x, i)` it asks
  `(ir, rej)` to `R`, rebuilds the whole byte stream of `x` and answers.

The key fact is that the byte stream is a *deterministic* function of
`(ir, rej)`, and that `(ir, rej)` has exactly the law induced by a random
stream: "sample the stream byte by byte" and "sample the result, then rebuild
the stream" are the same distribution. This is the `RejectionRO` argument,
in the direction stream -> result; because the ideal output contains all the
bytes read, the reprogrammer is deterministic (no conditional sampling).

## 2. Why the ideal oracle returns `ir` and not `c`

The FS+abort chain (`FSabort`, `ReprogHybrid`, `FSa_CMAtoKOA`) requires a
challenge oracle of the form `(challenge, leakage) <$ dC `*` dLkgRO`: a
uniform challenge and an *independent* leakage (`ReprogHybrid` relies on
this product form throughout, e.g. `dlet_ignore_leakage`, the `Oij_*`
hybrids). With the fine-grained leakage, the leakage reveals the accepted
indices, hence the challenge `c`: `(c, leakage)` is not a product. What is a
product is `(ir, rej)`. Therefore the chain's challenge type is instantiated
with `challenge_t := challenge_ir`, `dC := dI`, `dLkgRO := dLeakRej`, and the
scheme itself (`respond`, `verify`, through `to_c`) derives the ring element.
The chain runs unchanged; it does not even know that its challenge is a
pre-image. The part of the leakage that depends on the challenge (the
accepted indices) goes through the response leakage, the only place where
the chain allows a dependency on `c` (`respond_synthesis sk c d`).

## 3. What comes out at the other end

The KOA reduction (`RedMSIS`) yields an adversary against SelfTargetMSIS
whose oracle returns `ir` values and whose equation involves `to_c ir`: a
SelfTargetMSIS assumption "with pre-image challenges"
(`SelfTargetMSISLeakage`, with `type C`, `to_R`). The standard assumption returns
`c` in the ring directly. To go from one to the other, the reduction must
produce, from a `c` received from the standard oracle, a uniformly random
`ir` with `to_c ir = c`: this is the fibre sampling, `RedStd` with the
`FiberSampler` program of `ChallengeFiber` (backward partial Fisher-Yates,
`O(256 tau)`, lemma `StMSIS_Std`, identity `dfiber_marginal`). The output
of the adversary is unchanged: its last coefficient is `to_c ir = c`.

## 4. Why this cannot be done "inside SampleInBall"

One could want the ideal oracle of `SampleInBallEquiv` to sample
`c <$ dC tau`, then `ir` in the fibre of `c`, and return
`(c, full_leak ir rej)`. Mathematically it is the same distribution. But the
result `(c, leakage)` is correlated again, and the chain in the middle
rejects it. The only two ways out are: generalize the chain to joint
distributions (touching the `ehoare` proofs of `ReprogHybrid`), or do what is
done here, pass `ir` as the challenge and convert at the assumption end. Note
that the first way would not remove the fibre either: a SelfTargetMSIS
assumption "with a correlated leakage revealing `ir`" must also be reduced
to the standard one by a simulator sampling `ir` in the fibre of `c`.

## Summary

The fibre sampler is the price of the leakage model, not of the
architecture: as soon as the leakage reveals the pre-image `ir` while the
standard assumption only provides `c`, somebody has to sample `ir` from `c`.
We chose to do it once, at the boundary with the assumption, with an explicit
program, rather than in the middle of the chain. `SampleInBallEquiv` goes in
the direction "result -> stream" (deterministic); `RedStd` goes in the
direction "ring element -> pre-image" (backward Fisher-Yates). They are the
two halves of the same renaming.

# The model of branch `leakage-fine-tests` (2026-10-16, abstract tests)

`MLDSATarget` no longer fixes the rejection tests: they are abstract
operators, and the leakage of the signing loop is a flat sequence of
declassifications written where they happen (no `resp_leak`, no `catFS`):

```
op check_z    : vector -> int option.      (* on z             *)
op check_r0   : vector -> int option.      (* on w0 = w - c s2 *)
op check_hint : hint_t list -> int option. (* on the hint      *)
op check_ct0  : vector -> bool.            (* on c t0          *)
op Mz, Mr0, Mhint : int.                   (* 0 <= M, the failing values are in [0, M) *)

leak <- Seq[leak; t0_leak t0];                       (* once, when sk is unpacked *)
while (...) {
  (c, lc) <@ SIB.SampleInBall(XC).get(ct);
  leak <- Seq[leak; lc; c_leak c];                   (* fine SampleInBall leakage, then c *)
  z_fail <- check_z (y + c ** s1);  leak <- Seq[leak; oileak z_fail];
  if (z_fail = None) {
    r0_fail <- check_r0 (w - c ** s2);  leak <- Seq[leak; oileak r0_fail];
    if (r0_fail = None) {
      hint_fail <- check_hint h;  leak <- Seq[leak; oileak hint_fail];
      ct0_ok <- check_ct0 (c ** t0);                  (* public: c and t0 are leaked *)
      if (ct0_ok /\ hint_fail = None) { response <- Some (z, h); }
    }
  }
}
```

Axioms (the implementation proof instantiates the tests and discharges them):
- range: `check_X v = Some i => 0 <= i < MX`; this is all the plug-and-pray
  argument of `ReprogHybrid` needs, `F = Mz + Mr0 + Mhint + 1` enters the
  bound as `(Mz + Mr0 + Mhint + 2)`;
- exact characterization of success by the norm bounds, for vectors of the
  right size: `check_z z = None <=> ||z|| < gamma1 - beta`,
  `check_r0 w0 = None <=> ||LowBits w0|| < gamma2 - beta`,
  `check_ct0 v <=> ||v|| < gamma2`. Both directions are used: the direct one
  for the recovery of `w1` on the accepted iteration (`hint_recover`), the
  converse because the rejection probability `p_rej` is bounded through
  `bound_low`, which is stated with the norm bounds;
- shift invariance for `z`: for `||v|| <= beta`, `check_z (y + v)` and
  `check_z y` have the same law for a masking vector `y`. The simulator does
  not know `s1`; this is the only distribution property. For the canonical
  instantiation `first_fail z_ok l` (first failing polynomial) it is
  `MLDSATarget.first_fail_z_shift` (realizing `check_z_shift` in
  `ConcreteMLDSA`), proved from the independence of the polynomials of `y`;
  a coefficient-wise test needs the same proof at the level of the
  coefficients (and `dRq_mask` as a product over coefficients, see the TODO
  on its guard in `ConcreteMLDSA`).

The branches and the loop exit are not in the trace: every condition is a
function of values declassified before it (`z_fail`, `r0_fail`, `hint_fail`,
and `ct0_ok` through `c` and `t0`), so the branch leakage of an
implementation is derivable from the trace.

Since the restructuring of 2026-10-17 (branch `proof-restructure`, see the
section "Restructuring" below), `SimplifiedScheme` produces exactly the same
trace: the chain appends per iteration `resp_leak c z_fail r0_fail hint_fail`
(the SampleInBall leakage, `c`, and the test outcomes, built with `lcat`, no
`If`/`While` node, no `t0`), and `RedXOF` only prepends `t0_leak t0` (it
knows `t0` from `pk = (mA, t)`). The convention everywhere is: a trace is a
sequence of declassified items appended with the associative `lcat`
(`leak <- lcat leak item`), never `Seq [leak; item]`.

## What else can be leaked (discussion of 2026-10-16)

Free today, without touching the chain: any deterministic function of
`(pk, t0, c, d)` where `d` is the failing datum of the iteration (bounded by
`F`). This is why `c` is leaked in every iteration, accepted or rejected: in
`ReprogHybrid` the challenge of a rejected iteration is a fresh sample,
independent of `w1`, and the response leakage may be any function of
`(sk, c, d)` (`respond_factorisation`); the HVZK simulator samples `c`
itself; in the real world `c` gives the adversary a test oracle for `w1`
through the hash, but `w1 = HighBits(A y)` keeps its entropy given `c` and
`d`, which is what the `eps_comm` term pays for. The chain already leaked
the support of `c` (the SampleInBall pairs `(ctx, j)`).

Forbidden: `w0`, `z`, `r0` or `w` in an iteration where `z` passed and `r0`
failed. HVZK is not the problem (`(c, z)` is perfectly simulable), the
consistency of the oracle is: `w1 = HighBits(w0 + c s2)` differs from
`HighBits(w0)` only at the coefficients with `|r0| >= gamma2 - beta`, exactly
those that make the test fail (about `256 k beta / gamma2 ~ 1.15` of them
for ML-DSA-65). An adversary knowing `w0` enumerates the few candidates for
`w1`, hashes them, recognizes the right one by comparison with `c`, and
learns at each boundary coefficient whether `w0_ij + (c s2)_ij` crossed the
boundary: a linear inequality on `s2` with a random `c`, in about two thirds
of the iterations where `z` passes. A few thousand signatures plausibly
recover `s2` (order of magnitude, not a computation). Also forbidden for the
same reason: `w`, `y`, `w1` of a rejected iteration, and the value of a
failing coefficient of `z` (its set of reachable values depends on `c s1`).

Possible but not supported by the chain: `w0` (equivalently `z`, hence
everything downstream: `r0`, `c t0`, the hint, its weight at any
granularity) once `r0` passed. Then `w1 = HighBits(w0)` is computable by the
simulator from `(pk, t0, c, z)`, the oracle can be programmed at
`(w1, mu) := c` as for the accepted iteration, and `(c, z, h)` has the right
distribution. This would make the end of the iteration public after the
test on `r0` (`#declassify z` in Jasmin) and reduce `F` to `Mz + Mr0 + 1`.
It needs a third kind of iteration in `ReprogHybrid` ("rejected but
programmed") besides "accepted, programmed" and "rejected, entropy
argument", and the matching HVZK simulation: a structural change.

Grey zone: the full failure pattern of `z` (all coefficients, not only the
first) has a law independent of `s1`, and the failure pattern of `r0`
plausibly leaves its entropy to `w1`; but the chain only handles a finite
guessed `d`, and these patterns make `F` explode. A conditional-entropy
argument would be needed; it does not exist in the repository. The earlier
TODO "sample the failing index of `z` instead of guessing it, `F = 2k + 1`"
is doubtful for the same reason: the index is correlated with `w1` through
`y`, so sampling it does not decouple the leakage from the reprogrammed
point; to be re-examined before investing in it.

## Historical: the first model of the branch (polynomial-granularity cascades)

The first version of the branch fixed the tests to `first_fail` cascades
over the polynomials (`F = l + 2k + 1`); this is now the canonical
instantiation (`ConcreteMLDSA`, `Mz = l`, `Mr0 = Mhint = k`). The analysis
below (`b1..b4`, Jasmin notes) was written for it and still applies, with
`b1 = z`, `b2 = r0`, `b3 = ct0`, `b4 = hint`.

The vector `t0` itself is leaked (`t0_leak`, its coefficients as integers):
the proof treats `t` as known to the adversary (the public key of
`SimplifiedScheme` is `(A, t)`, the MLWE and SelfTargetMSIS assumptions are
on the full `t`, the HVZK simulator and the synthesis of `ReprogHybrid`
recompute `t0 = base2lowbitsV t`), so any function of `(c, t0)` is free.
This covers the `||c t0||_inf < gamma2` test at any granularity and in any
position, and every other computation that only involves `c` and `t0`.

For the implementation (Jasmin): `t0` is typed secret because it comes from
`sk`; one `#declassify` of `t0` when `sk` is unpacked makes `c t0`, `-c t0`
and the test `__apply_ct0_and_check_norm` public-typed, so this test needs no
`#declassify` and no fence in the loop and can use plain branches, at any
place and granularity. The hint computation mixes `c t0` (public) with
`w - c s2` (secret): its weight test remains a declassification, after `z`
and `r0`.

Granularity and the size of `F`. For a short-circuit test, the number of
failure patterns is the number of positions at which it can stop: `l`
patterns for `z` with one boolean per polynomial, `256 l` with one boolean
per coefficient, `255 l` with the 8-lane masks of the current Jasmin code.
Numerically the factor is irrelevant (`eps` is the inverse of the size of
the commitment space); it only matters for the shape of the leakage that the
constant-time proof of the implementation has to match. With the abstract
tests, choosing a granularity is choosing `check_z`, `Mz` and proving the
axioms; no change to the proof.

Earlier exits in the implementation. The proof only constrains the order
(`z` before `r0` and the hint, which are functions of `(pk, c, z)`), not the
granularity of the short-circuits: the implementation may stop the test on
`z` at the first bad polynomial, 8-lane block or coefficient, and likewise
for `r0` and the hint once `z` is accepted; the test on `c t0` is free. The
gain is small (at most the end of one polynomial of additions and
comparisons per rejected iteration, against the NTTs, the product by `A`,
two SHAKE calls and the hints); the real performance lever, `r0` before `z`,
is the one the proof does not justify.

To match the canonical instantiation, the Jasmin implementation must
evaluate `z` before `r0` and declassify one boolean per polynomial
(`result`) instead of the 8-lane mask `exceeds_any` in
`__check_infinity_norm`; declassifying the 8-lane mask is another
instantiation (`Mz = 255 l`, see below).

# Note: fine-grained leakage of the rejection tests b1, b2, b3, b4 (2026-10-16)

This note records the analysis of the `#declassify` annotations of the Jasmin
implementation (`formosa-libjade`, `src/mldsa/avx2/sct/common/sign.jinc`) against the
leakage model of `MLDSATarget`, where one signing iteration leaks
`ite (b1 /\ b2) (ite b3 (ite b4 Empty Empty) Empty) Empty`, i.e. the boolean
`b1 /\ b2`, then `b3`, then `b4`, with

- `b1 = inf_normv z < gamma1 - beta_`                 (z = y + c s1)
- `b2 = inf_normv (lowBitsV (w - c s2)) < gamma2 - beta_`
- `b3 = inf_normv (c t0) < gamma2`
- `b4 = check_hw h` (hint weight)

## What the proof can justify

The response leakage of the FS+abort chain is a function
`respond sk c y` and, for a failing iteration, must factor as
`respond_synthesis sk c d` with `d` in a finite list `failing_data` of size
`F` (`ReprogHybrid`, `respond_factorisation`). `F` enters the bound as the
factor `(F + 1)` of the first term of `reprog_bound`, through a plug-and-pray
over `failing_data`. Independently, the HVZK simulator (`HVZK_Sim_Inst`) must
reproduce the leakage from `pk` only: it samples `z` uniformly in the small
box with probability `|box| / |dy|` (independent of `c` and `s1`, the masking
argument) and nothing otherwise.

Consequences:

- `b1` can be leaked at any granularity (per polynomial, per coefficient,
  8-lane masks): each coefficient `z_i = y_i + (c s1)_i` lands in the small box
  with a probability independent of the secret, and the coefficients are
  independent. Any function of the vector of booleans is simulatable. With a
  short-circuit cascade, the leak is the index of the first failing test
  (linear number of patterns), not the whole vector.
- `b2`, `b4` are functions of `(pk, c, z)` once `z` is known
  (`w - c s2 = A z - c t`): they can be leaked at any granularity PROVIDED
  they are evaluated after `b1` succeeded. Their patterns must be guessed
  (they depend on `z`, unavailable to the synthesis on failure).
- `b3` is a function of `(c, t0)` only: it can be leaked anywhere, at any
  granularity, and its pattern is recomputed by the synthesis (no guess).
  For ML-DSA-65/87 it never fails (`tau * 2^(d-1) < gamma2`); for
  ML-DSA-44 it can, which is why the proof does not assume the bound
  (no `ub_d` axiom) and relies on the explicit test `check_ct0`.
- Leaking `b2` (or `b4`) when `b1` failed is NOT covered: it reveals a
  function of `A y - c s2` for a rejected `y`, whose law depends on `s1`
  once conditioned on `z` leaving the box. This is the "rejected iteration
  leakage"; no argument of the current framework handles it.

## The Jasmin implementation (as of 2026-10-16)

Order of evaluation in the loop: `b2` (rows, early exit), `b3` (rows, early
exit), `b1` (columns, early exit), `b4` (cumulative hint count, early exit);
`__check_infinity_norm` declassifies an 8-lane mask per polynomial. The
likely motivation is performance: `b2` rejects more often than `b1`
(ML-DSA-65: `Pr[b2] ~ 0.32`, `Pr[b1] ~ 0.62`), so testing it first skips the
computation of `z` in most rejected iterations (as in mldsa-native's
`mld_compute_pack_z`). With constant-time flags and a single final
declassification the order is irrelevant; with early exits it is the point
above: the early exit on `b2` before `b1` is not justified by the proof.

Justified orders: `b1, b2, b3, b4` (pq-crystals) or `b3, b1, b2, b4`.
Values of `F` for the justified orders with the current masks
(`F = 255 (k + l) + k + 1`): ML-DSA-44: 2045, ML-DSA-65: 2812,
ML-DSA-87: 3834; with one boolean per polynomial instead of the 8-lane mask:
`F = l + 2k + 1` (18 for ML-DSA-65; the model of branch `leakage-fine-tests`);
with a single OR and no early exit: `F = 2` (model of branch `leakage_model`).

Other points of the implementation:
- Speculative constant-time: the `#init_msf` fences that follow the
  declassifications in the loop (`__check_infinity_norm`, hints, ...) must
  be removed and replaced by `#update_msf` on the branch that consumes the
  declassified boolean and `#protect` on the values used after it, as for any
  public branch in the Jasmin SCT discipline. `#init_msf` is an `lfence`
  (serialising: waits for all in-flight instructions to retire and blocks
  speculation past it) while `#update_msf` is a `cmov` and `#protect` an
  `and`/`or`. There is no documented cost for `lfence`: isolated
  microbenchmarks give a few cycles, but in context (after a vectorised loop
  with outstanding loads and long dependency chains) the drain and the refill
  of the pipeline cost hundreds of cycles; 500 cycles or more per fence is
  plausible and must be measured on the Jasmin code itself (`rdtsc` around
  the loop with and without fences). With ~`2k + l` fences per iteration
  this is a few percent of an iteration, more if the fences sit in inner
  loops (per 8-lane block). Removing them requires
  propagating the msf through the helper functions (`__check_infinity_norm`,
  `__make_hint_vector`, ...) as an argument and a result: an `#init_msf`
  stays necessary where no msf is available (exported entry point, functions
  that do not receive it). With the model of branch `leakage-fine-tests`,
  the test on `c t0` needs none of them (public once `t0` is declassified at
  the unpacking of `sk`).
- `sample_at` declassified in `__challenge`: exactly the fine-grained
  SampleInBall leakage of the model (the sign bytes and `commitment_hash`
  are not declassified, as in the model).
- On exit by `kappa_exceeded`, the code declassifies and encodes
  `signer_response` (a rejected `z`), `hint` and `commitment_hash` of a
  failed iteration; the model returns `None`. Not justified; the fix is a
  public branch on `kappa_exceeded` that skips or zeroes them.
- `y` is derived by SHAKE from `H(K || rnd || mu)` and a nonce, while the
  model samples it uniformly: an extra hop (secret-seeded XOF as a random
  oracle / PRF) is needed before applying `MLDSA_secure`.

## Note on `b3` (`__apply_ct0_and_check_norm`)

`b3 = inf_normv (c ** t0) < gamma2` is the check of `__apply_ct0_and_check_norm`
(threshold `GAMMA2`; `b2` is `__apply_cs2_and_check_norm` with
`GAMMA2 - BETA`, `b1` is `__compute_z_and_check_norm` with `GAMMA1 - BETA`).
Since `||c t0|| <= ||c||_1 * ||t0|| <= tau * 2^(d-1)`, the test can never
fail when `tau * 2^(d-1) < gamma2`:

| parameter set | `tau * 2^(d-1)`    | `gamma2` | `b3` can fail |
| ------------- | ------------------ | -------- | ------------- |
| ML-DSA-44     | 39 * 4096 = 159744 | 95232    | yes           |
| ML-DSA-65     | 49 * 4096 = 200704 | 261888   | no            |
| ML-DSA-87     | 60 * 4096 = 245760 | 261888   | no            |

With the model of branch `leakage-fine-tests`, `t0` itself is leaked
(see above): the test `b3` can be implemented as a public computation with
a single `#declassify` of `t0` at the unpacking of `sk`, and its position
and granularity are irrelevant.

The commitment-recovery lemmas (`recover_correct` in SimplifiedScheme,
`hint_recover` in MLDSAProof) use the outcome of the test `check_ct0`
(part of the acceptance condition) to derive `b3`; no bound on `tau *
2^(d-1)` is assumed, as it fails for ML-DSA-44. For ML-DSA-65/87 an
implementation could drop the norm check (not the computation of `c t0`,
needed for the hints) with identical outputs on every input. The
gain is below 1% of an iteration (`k` vector scans of 256 coefficients and
`2k` `#declassify`/`#init_msf` fences, against the NTTs, the product by `A`,
two SHAKE calls and the hints); the proof is not simplified either (`b3` is
one class of `F` and a constant leak). Not worth deviating from the text of
FIPS 204 unless the Spectre fences matter for another reason. The real
performance lever of the loop is the order `b2` before `b1`, which is the
one the proof does not justify with early exits.

# Restructuring (2026-10-17, branch `proof-restructure`)

Four changes made once the proof was complete, to simplify it and its
presentation (`../doc/proof_overview.tex`).

1. **One leakage format.** The chain (`ReprogHybrid`, `FSa_CMAtoKOA`,
   `FSabort`) only uses `catFS` through the monoid laws of `lcat`
   (`lcatEmpty`, `lcatA`); it never inspects `While`/`If` nodes. So
   `fs_leak` is now flat (`lcat lw (lcat lc lz)`, the boolean is ignored) and
   `ite` is gone. To make the chain's trace *syntactically* the flat trace,
   the challenge of the chain is the whole output of the ideal oracle,
   `challenge_t = SIB.challenge_ir * leakage` (pre-image and rejected-bytes
   leakage), with `dC_t = dI `*` dLeakRej` and no oracle leakage
   (`dunit Empty`): the real SampleInBall leakage `full_leak ir rej`
   (rejected bytes and accepted indices interleaved in time order) is then
   a function of the challenge and goes into the response leakage. The
   chain does not need the challenge to be uniform (the unused `dC_uni`
   requirement was removed). `t0` is not leaked by the chain: `RedXOF`
   prepends it (`conv_sigl pk`). `SelfTargetMSIS` is instantiated with
   `dfiber r = CF.dfiber r `*` dLeakRej` and the program `FiberSamplerRej`.
   Removed: `conv_leak` and its helpers, `idx_leak`, `add_idx`,
   `full_leak_idx`.
2. **`ReprogHybrid` bounded only.** The unbounded mode (`op bounded`,
   `OTrans` with an unbounded loop, the `p^kappa` terms, the limit
   argument) was unused; 3444 -> 2793 lines. Main lemma `GSign_GTrans`,
   target oracle `OTrans`.
3. **One signing loop in `MLDSAProof`.** `MLDSAGen(MG, CG, Hmu)`
   (`MLDSAProof_Games.ec`) is the signing procedure of every game: `MatGen`
   says how the matrix is obtained from `rho`, `ChalGen` how the challenge is
   obtained from `(w1, mu)` (`get` at every iteration; since `c~` is leaked
   at every iteration, branch `mldsa-leak-ctilde`, `get` also returns `c~`
   and the former `final` is gone). The loop is guarded by the counter
   only (the body is skipped once a response exists) so that two instances
   run in lockstep in the up-to-bad step; `sign_G0` relates it to the loop
   of `MLDSATarget.MLDSA`. The hops are oracle swaps (`sim`/`call` on the
   parameter modules), except the up-to-bad step of `hop_collisions` and the
   lockstep with `SD.DilithiumR` in `hop_reduction`.
4. **One generic collision statement** `table_collision` (`TableCollision.eca`:
   a lazily sampled table whose fresh sample hits its own range or a known
   set), instantiated for `Hmu` and for `Hct`/`XC`.
5. **One file per hop**: `MLDSAProof_Games.ec` (clones, `MLDSAGen`, games,
   reductions, bounds), `MLDSAProof_ExpandA.ec` (G0 -> G1),
   `MLDSAProof_Collisions.ec` (G1 -> G2), `MLDSAProof_Reduction.ec`
   (G2 -> G3), `MLDSAProof.ec` (`MLDSA_secure`); each file is an abstract
   theory that `clone include`s the previous one; `ConcreteMLDSA.ec` is
   unchanged.

Cleanup (2026-10-17, after the restructuring): dead code removed (the
`CMAs` variants of `DigitalSignaturesLeakageRO`, the `Imp`/`HVZK` games of
`IDSabort`, `Correctness`/`EF_CMA_U`, the unused parts of `Geometric`, the
canonical rejection tests copied in `SimplifiedScheme`, `ForgetRO`, ...);
lemmas proved once and shared (`LogRO_get_ll` in `RejectionRO`, `foldl_o` in
`utils/FoldlO.ec`, `dB_to_int` in `Byte`, `dlet_dprod`/`dprodA`/
`djoinmap_prod` in `DistrExtras`, `ReprogIndices_ll`/`ReprogChallenge_ll`/
`supp_dI` exported by `SampleInBallEquiv`, `rb_` shared by `ReprogHybrid` and
`FSa_CMAtoKOA`, `supp_keygen`/`norm_cs_le_beta`/`commit_identity` in
`SimplifiedScheme`); the axiom `eps_gt0` of `FSa_CMAtoKOA` became the lemma
`eps_ge0`; the losslessness of the `ReprogHybrid` signing procedures is three
named lemmas registered as `islossless` hints; the invariants pasted in the
MLDSAProof hops are abbreviations (`red_rel`, `relD`, `tcinv`, `tmu`) and the
helpers of one hop are local to it. About 1 200 lines removed, no exported
statement changed.

`SampleInBallEquiv.eca` is split: the encoding definitions (challenge
pre-images, `dI`, `to_challenge`, `dC`, ...) live in `SampleInBallDefs.eca`,
which `SampleInBallEquiv` `clone include`s; `ChallengeFiber` clones only the
definitions (it used to instantiate the whole proof, including the
`RejectionRO.TwoSteps` instance, twice). The factoring of the games `D`,
`Amu`, `Act` of `MLDSAProof_Collisions` into one parametrised game was
examined and rejected: `G2` must stay as it is, the three bodies differ
(counters, `Flush`, `St` and table initialisations, return types imposed by
`RO_LRO_D` and `TableCollision.Game`), and the oracle-case bullets relate
different invariants, so the net saving is below 30 lines while the counting
proofs would need extra `inline`s.

Pre-existing failures outside the proof files (fixed 2026-10-17):
`utils/DistrExtras.ec`, `utils/Geometric.ec`, `utils/ZModFieldExtras.eca` did
not compile on their own with the llm-interactive binary; they are only loaded
as dependencies (proofs of required files are not checked), so they were
effectively admitted. Their proofs were repaired without changing any
statement. `utils/AbstractSampling.eca` failed because `eager` now refuses to
swap a statement that writes `glob S` for an abstract `S` (EasyCrypt soundness
fix); the sampler is now declared stateless, `S <: Sampler {+Empty}`, which
strengthens `lazy_eager`. The restriction propagates to `RejectionRO.ec`
(`S`, `S1`, `S2` declared `{+Empty}`, the distinguisher of `TwoSteps` also
excluded from `SRaw1`/`SRaw2`); the concrete samplers of `SampleInBallEquiv`
and `ExpandAEquiv` are stateless, so their instantiations are unchanged.

# Leaking the commitment hash `c~` (branch `mldsa-leak-ctilde`)

Every signing iteration may declassify `c~ = Hct(w1, mu)`. The bottom of the
stack is changed as follows (the chain `FSabort`, `ReprogHybrid`,
`FSa_CMAtoKOA`, `FSa_CRtoGen`, `IDSabort` is unchanged: it is generic in the
challenge type and only needs `dC` lossless).

- `SampleInBallEquiv`: the leakage of `SampleInBall` also contains the 8 sign
  bytes: `sib_leak ir r = lcat (bytes_leak ir.1) (full_leak ir r)` (and the
  same in the real algorithm). With the pairs `(ctx, j)` it contains every
  byte read on the XOF, in order: `leak_to_streamK : leak_to_stream
  (sib_leak ir r) = stream (ir, r)`. A reduction can therefore rebuild the
  whole consumed XOF stream of a rejected iteration from its leakage.
- `SimplifiedScheme`: abstract `type ctilde`, lossless `dct`, injective
  encoding `ct_enc` (`ct_encK`), `ct_leak ct = [ct_decl ct]` with the
  decoding `ct_of_leak` (`ct_of_leakK`). The challenge of the chain is the
  triple `challenge_t = SIB.challenge_ir * leakage * ctilde`, distributed as
  `dC_t = dmap ((SIB.dI `*` SIB.dLeakRej) `*` dct) flat3`; `c~` is
  independent of the rest, so the fibre of the SelfTargetMSIS reduction is
  `dmap ((CF.dfiber r `*` SIB.dLeakRej) `*` dct) flat3` and
  `FiberSamplerRej` also samples `c~ <$ dct`. The per-iteration leakage
  (`resp_leak`, `DilithiumR.sign`) is the flat target format:
  `ct_leak c~`, the SampleInBall leakage `sib_leak`, `c_leak c`, the test
  outcomes (`t0_leak t0` first, prepended by `RedXOF`).
- The XOF world has one random oracle on a sum type, `xin = XB ((w1, mu), i)
  | XH (w1, mu)` with outputs `OB byte | OH ctilde`; `DilithiumXOF(H) =
  DilithiumR(SampleInBall(XofOf(H)), HctOf(H))`, signatures `SigXOF = ctilde *
  Rq * response_t`, `verify` checks both `c` and `c~`. `CountX` counts the
  distinct points `(w1, mu)` over both kinds of queries. `RedXOF` answers the
  byte queries with `Sim` on the first two components of its random oracle
  and the hash queries with the third, both through a cache (`CacheRO`) so
  that the random oracle of the simplified scheme is queried once per point
  (query bound unchanged).
- `pr_xof_ro` (no bound lost): split of the sum oracle into the XOF and the
  commitment hash `HctRO` (`pr_sum`, an invariant), `adv_xof_roc`, merge of
  the two lazy random oracles `SIB.ROC` and `HctRO` on the same points into
  one random oracle on the product by eager sampling of each at the points
  of the other (`pr_eager`, `PROM.FullEager.RO_LRO_D` twice), and the
  invariant `jrel` with the random oracle of the simplified scheme behind
  the cache (`pr_merge`). This is done inside `SimplifiedScheme` rather than
  in a generic `ROProduct` theory: the eager steps need the distinguisher to
  be the whole game, and the oracles are the existing PROM clones
  (`SIB.ROC`, `HctRO`).

Layers C and D (target model and `MLDSAProof_*`):

- `MLDSATarget`: abstract encoding `ct_enc`/`ct_dec` (`ct_encK`) of `c~`,
  `ct_leak ct = [List (map Int (ct_enc ct))]`; `MLDSA.sign` leaks
  `ct_leak ct` right after `ct <@ Hct.get(w1, mu)`, at every iteration, then
  the SampleInBall leakage (with the sign bytes), `c_leak c` and the
  outcomes. `MLDSAGen` (all the games) does the same, and so does the FIPS
  specification (`spec/MLDSA.ec`: `ctilde_leak ct` right after the
  challenge oracle, which returns the SampleInBall leakage only).
- G2 (`MLDSAProof_Games`): `Hct` is the `XH` part of the random oracle
  `SD.XOF` of `SimplifiedScheme` (`HctT.sample` for the signer, `HctT.get`
  for the adversary, which also records `c~ -> (w1, mu)` in `tinv`); the
  signer (`ChalX`) computes `c~` and `SampleInBall` on `(w1, mu)` at every
  iteration and records the consumed stream in `leakT`; `XCSim(c~, i)`
  answers from `LX` if already asked there, else from the stream of
  `leakT`, else from `SD.XOF` on `tinv[c~]`, else from `LX`. The bad event
  `HctT.bad` is set when a fresh `c~` is already an output or was already
  queried to `LX`. The reduction fills `leakT` by decoding the leakage
  (`upd_leakT`, a state machine `pstep` over the items) and takes `c~` from
  the signature of `SimplifiedScheme`; its query bound is `qHct` points
  (`SD.qH = qHct + 2`).
- G1 -> G2 (`MLDSAProof_Collisions`): both games sample `c~` at the same
  moments, so the step is a direct up-to-bad step on `HctT.bad` (the eager
  sampling and the final flush of the former proof are gone). The invariant
  `rel` relates `Hct` of G1 to the `XH` entries, the XOF of G1 to `LX` and
  the `XB` entries (an `LX` entry on an output of `Hct` is only beyond the
  consumed stream of a `c~` of the signer), and the consumed streams are
  complete (`complete`: SampleInBall stops exactly at their end). When the
  signer runs again on a point already signed, its reads stay inside the
  recorded stream (`sbinv`, `SB_eq`), which replaces a determinism lemma.
  `bound_ct` is obtained by `TableCollision` on G2 directly (`Act`: the
  table is the `XH` part, every `c~` queried to `XC` is put). No new term.
- G2 -> G3 (`MLDSAProof_Reduction`): an exact step up to the bad flags. The
  shared state is equal on both sides (`SD.XOF.m`, `LX`, `tinv`, `leakT`,
  `HmuB`, `ROtr`, `XASim`, `RA`), the reduction returns the leakage of
  `SimplifiedScheme` unchanged (same format), and under `!HctT.bad` the
  invariant `ginv` holds: every output of `Hct` is in `tinv` or `leakT`,
  every `c~` of `leakT` has a preimage whose `mu` was signed, an `LX` entry
  on an output belongs to a `c~` of `leakT`. Hence a fresh forgery has its
  `c~` in `tinv` and no `LX` entry, and `XCSim` on it is the XOF of
  `SimplifiedScheme` on `tinv[c~]` (determinism of SampleInBall, `sib_det`).
  The byte queries of the reduction are on points of `tinv`, already queried
  through `XH`: the reduction queries at most `qHct + 1` points (`B_bound`).
- Bound of `MLDSA_secure`: unchanged except `(qXC + 2)` -> `(qHct + 2)` in the
  FS+abort term (a query to `Hct` alone now tests a candidate `w1` against a
  leaked `c~`). At the FIPS level (`MLDSA_Security`) both `qXC` and `qHct`
  are bounded by the SHAKE query bound `qH`, so the final bound is the same.

# Leaking `rho` and the candidates of ExpandA (branch `mldsa-leak-ctilde`)

The signing procedure of the implementation also declassifies the seed
`rho` of the matrix (`sign.jinc`) and, in ExpandA, every candidate read on
the XOF of ExpandA before the test `v < q` (`rejection_sample.jinc`: the
scalar loops declassify the 23-bit candidate, the AVX2 loop the mask of the
tests on 8 candidates, a function of the candidates). The trace of
`MLDSATarget.MLDSA.sign` starts with these items, once, before `t0`:

```
leak <- rho_leak rho;                  (* [List (map Int (rho_enc rho))] *)
(mA, la) <@ ExpandA(XA).get(rho);      (* la: per entry (r, s), in loop order, *)
leak <- lcat leak la;                  (*   cands_leak vs = [List (map Int vs)] *)
leak <- lcat leak (t0_leak t0);
```

`ExpandA.poly(x)` returns the entry with the list `vs` of all its candidates
(accepted and rejected), `ExpandA.get` the matrix with the `lcat` of the
`cands_leak vs`. `rho_enc` is abstract with a left inverse (`rho_encK`,
realized by the bytes of `rho` in `MLDSATargetFIPS`); the proof does not use
the inverse (the reduction knows `rho`). The leakage is a function of `rho`
(public) and of the XOF of ExpandA, to which the adversary has access, so
no term of the bound changes and `qXA` is unchanged (the signer's queries to
the XOF of ExpandA are not queries of the adversary, and the reduction
answers them without querying SimplifiedScheme).

- `MLDSAGen` (all the games): `MatGen.get` returns the matrix and the
  leakage of ExpandA; the leakage of `rho` and of ExpandA is prepended to the
  trace at the end (`lcat (lcat (rho_leak rho) la) leak`), so that the
  variable `leak` of the loop is still the trace of `SD.DilithiumR`, relayed
  unchanged by the reduction; `sign_G0` relates the two forms (`catA`).
- G1, G2: `MatRA.get` returns `RA.mA` and the leakage of a run of
  `ExpandA(XASim)` on `RA.rho`, the simulated XOF of the adversary.
  `ExpandA_XASim_ll` (MLDSAProof_Games): the first query on an entry
  reprograms its stream, the loop then reads a lazy random oracle on which
  it terminates (`EA.SampleRq_ll`); it gives the termination of the signers
  of G1/G2 and of the reduction.
- G0 -> G1 (MLDSAProof_ExpandA): in the distinguisher of `EA.RS`, the
  signer computes each entry with the sampler and its candidates by a
  second run of the inner loop of ExpandA on the XOF `R` of the adversary
  (`ExpandASL`). On the real side the second run reads the bytes that the
  sampler has just read: `poly_done` (the first run leaves in the map all
  the bytes it read, `pdone`) and `poly_rerun` (a run on such a map returns
  the same result without sampling); no eager or determinism argument on
  the whole game is needed. On the ideal side the second run is the run of
  `MatRA` on the simulated XOF (`poly_ideal`, from `Sim_get`), and the
  entries of the sampler are those of `RA.mA` (`ExpandASL_ideal`).
- G1 -> G2: the signers call `ExpandA(XASim)` in lockstep (`glob XASim` is
  in the invariants).
- G2 -> G3: `SignRed` computes `ExpandA(XASim).get(RA.rho)` (the reduction
  runs `XASim` on `RA.rho` and the matrix of SimplifiedScheme) and returns
  `lcat (lcat (rho_leak RA.rho) la) lk`; `sign_red` carries `la{1} = la{2}`
  and `rho{1} = RA.rho{2}` to the end. `B_bound`, `B_ll`: no new query.
- Bound of `MLDSA_secure`: unchanged.
