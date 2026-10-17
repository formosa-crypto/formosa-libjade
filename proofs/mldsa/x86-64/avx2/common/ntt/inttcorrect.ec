(**
  Correctness of the AVX2 inverse NTT (`polynomial__invert_ntt_montgomery`).

  Mirrors the forward development in `Nttcorrect`, which it reuses for the
  shared machinery: the AVX2 instruction-semantics `hint simplify` database,
  the montgomery-multiply lemma `mmrP`, and the `wpoly_get256/set256` bridge
  between the coefficient array and the packed-lane vector view.

  Structure (mirror of `nttcorrect.ec`):
    - inverse (Gentleman-Sande) butterfly spec + inverse tree + final scaling;
    - per-layer correctness:
        layers 0/1/2  -- within-vector, shuffles (invert_at_layer_{0,1,2})
        layers 3/4/5/6/7 -- strided round (invert_ntt_round)
    - final scaling by 41978 (n^-1 in Montgomery form);
    - main theorem for `M.polynomial__invert_ntt_montgomery`.
*)
require import AllCore CoreUtils List Ring IntDiv BitEncoding.
require import StdRing StdOrder.
from Jasmin require import JWord JArray JModel_x86.
require import JArrayExtra CircuitBindings.
require import MldsaConstants.
require Parameters MldsaT.
require import WArray1024.
require import Array2 Array4 Array8 Array16 Array256.
require import XArray256.
require import Nttzetas Nttspec Nttlogspec.
require import Avx2red Listred.

abstract theory InttcorrectT.

clone import Parameters.ParamsT as P.
clone import MldsaT.MldsaT as R with theory P <- P.
clone import Avx2red.Avx2redT as AR with theory P <- P, theory R <- R.

(* ==================================================================== *)
(* Generic strided round (layers 3..7): one GS butterfly of length      *)
(* 8*stpby coefficients based at 8*offset_. Mirror of Nttcorrect's      *)
(* ntt_roundP.                                                          *)
(* ==================================================================== *)
lemma intt_roundP (p_ : wpoly) (stpby offset_ : int) (z : W32.t) :
     0 <= offset_
  => 1 <= stpby
  => 8 * (offset_ + 2 * stpby) <= 256
  => hoare[M.polynomial__invert_ntt_round :
         arg = (p_, offset_, stpby, z)
       ==>
         res = ireduce p_ (8 * offset_) (8 * stpby) z
     ].
proof.
hint +listred.
move=> ge0off ge1s hlt; proc.
pose bound_ := offset_ + stpby.

seq 2 : (#pre /\ zetas = pack8 [z; z; z; z; z; z; z; z]).
- by auto.

sp; while (
     offset_ <= i
  /\ i <= bound_
  /\ zetas = pack8 [z; z; z; z; z; z; z; z]
  /\ offset = bound_
  /\ step_by = stpby
  /\ polynomial = ireduce_partial p_ (8 * offset_) (8 * stpby) (8 * (i - offset_)) z
); last first.
- skip=> &hr |>; split*.
  - smt().
  - move=> i0 *; have ->: 8 * (i0 - i{hr}) = 8 * step_by{hr} by smt().
    by rewrite ireduce_as_partial //#.

exlim i => i_.
pose uw (j : int) := p_.[8 * i_ + j].
pose vw (j : int) := p_.[8 * (i_ + stpby) + j].

case@[ambient]: (
     (offset_ <= i_)
  /\ (i_ < bound_)
) => [[#] lei gti|]; last first.
- by move=> ?; conseq (_ : false ==> _); [move=> &hr |> /# | exfalso].

have ?: 0 <= 8 * i_ < 256 - 7 by smt().
have ?: 0 <= 8 * (i_ + stpby) < 256 - 7 by smt().

seq 7 : (#pre /\
     index_i = 32 * i_
  /\ index_i_plus_step_by = 32 * (i_ + stpby)
  /\ coeffs_i = W8u32.pack8 (mkseq uw 8)
  /\ coeffs_i_plus_step_by = W8u32.pack8 (mkseq vw 8)).
- hoare split; auto=> &hr |> /= *; do! split; 1,2: smt().
  - rewrite wpoly_get256_alignedE ~-1:/# -(eq_in_mkseq uw) -1://.
    by move=> j rgj /=; rewrite eqexcept_ireduce_partial //#.
  - rewrite wpoly_get256_alignedE ~-1:/# -(eq_in_mkseq vw) -1://.
    by move=> j rgj /=; rewrite eqexcept_ireduce_partial //#.

seq 2 : (#{/~{coeffs_i}}pre /\
     a_minus_b = pack8 (mkseq (fun j => vw j - uw j) 8)
  /\ coeffs_i = pack8 (mkseq (fun j => uw j + vw j) 8)).
- by auto.

seq 1 : (#{/~{coeffs_i_plus_step_by}}pre /\
  coeffs_i_plus_step_by = pack8 (mkseq (fun j => mmr (vw j - uw j) z) 8)).
- by ecall (mmrP a_minus_b zetas); auto.

exlim polynomial => q.

seq 1: (
     (  #{/~{polynomial}}pre
     /\ q = ireduce_partial p_ (8 * offset_) (8 * stpby) (8 * (i - offset_)) z)
  /\ polynomial = replace_ q (8 * i) (to_list coeffs_i)
).
- hoare split; [wp; skip=> &hr [#] -> <- 7? idxE 3? | by auto].
  have ->: W8u32.to_list coeffs_i{hr} =
    mkseq (fun i => coeffs_i{hr} \bits32 i) 8 by done.
  rewrite idxE (_ : 32 * _ = 4 * (8 * i_)) 1:#ring.
  by rewrite wpoly_set256_aligned -1:replace_mkseq.

seq 1: (#{/~{polynomial}}pre /\ polynomial =
  let q0 = replace_ q (8 * i) (to_list coeffs_i) in
  let q0 = replace_ q0 (8 * (i + stpby)) (to_list coeffs_i_plus_step_by) in
  q0
).
- hoare split; [wp; skip=> &hr [#] <- 6? _ idxE 3? ? -> | by auto].
  have ->: W8u32.to_list coeffs_i_plus_step_by{hr} =
    mkseq (fun i => coeffs_i_plus_step_by{hr} \bits32 i) 8 by done.
  move: (replace_ q _ _) => q0; (pose s := mkseq _ _) => /=.
  rewrite /s replace_mkseq idxE.
  rewrite (_ : 32 * _ = 4 * (8 * (i_ + stpby))) 1:#ring.
  by rewrite wpoly_set256_aligned.

wp; skip=> &hr;
  pose c1  := W8u32.to_list _;
  pose c2  := W8u32.to_list _;
  pose bfD := mkseq (fun j => uw j + vw j) 8;
  pose bfB := mkseq (fun j => mmr (vw j - uw j) z) 8;
  move=> |> *; split*; ~-1: smt().

rewrite [_ + 1 - _]addrAC [8*(_+1)]mulrDr /= ireduce_partialD ~-1://#.
(pose r := (ireduce_partial p_ _ _ _ _)) => @/ireduce_partial /=.
case _: (ireduce_coeff _ _ _ _ _) => c'1 c'2 E /=.
suff [#] 2->: c1 = c'1 /\ c2 = c'2.
- by (congr; first congr); rewrite #ring.
move: E; rewrite -(ireduce_coeff_eqon p_).
- by move=> i * @/r; rewrite eqexcept_ireduce_partial //#.
- by move=> i * @/r; rewrite eqexcept_ireduce_partial //#.
have ->: 8 * offset_ + 8 * (i{hr} - offset_) = 8 * i{hr} by ring.
move=> ^ /(congr1 fst) /= <- /(congr1 snd) /= <-; split.
- rewrite ireduce_coeffLE /c1 (_ : W8u32.to_list (pack8 _) = bfD) 1://.
  by apply: eq_mkseq => i /= @/uw @/vw; do! congr => //#.
- rewrite ireduce_coeffRE /c2 (_ : W8u32.to_list (pack8 _) = bfB) 1://.
  by apply: eq_mkseq => i /= @/uw @/vw; do! congr => //#.
qed.

(* ==================================================================== *)
(* Layers 0/1/2: within-vector butterflies (shuffle networks).          *)
(* ==================================================================== *)
lemma INTT_layer0_bf (p : wpoly) (s_ : int) (z : W256.t) :
     0 <= s_ < 32
  => 2 %| s_
  => hoare[M.polynomial__invert_at_layer_0 :
         arg = (p, s_, z)
       ==>
         res = ireduce_n p (8 * s_) 1 (map ((\bits32) z) perm0L)
     ].
proof.
hint +listred.
move=> rgs dvds; proc.
pose uw (i : int) := p.[8 * s_ + i].
pose vw (i : int) := p.[8 * s_ + 8 + i].
pose zw (i : int) := z \bits32 i.
have ?: 0 <= 8 * s_ < 256 - 7 by smt().
have ?: 0 <= 8 * s_ + 8 < 256 - 7 by smt().

seq 8 : (#pre /\
     coeffs_i_start = 32 * s_
  /\ coeffs_i_plus_1_start = 32 * s_ + 32
  /\ coeffs_i = pack8 [uw 0; uw 2; uw 1; uw 3; uw 4; uw 6; uw 5; uw 7]
  /\ coeffs_i_plus_1 = pack8 [vw 0; vw 2; vw 1; vw 3; vw 4; vw 6; vw 5; vw 7]).
- hoare split; auto=> &hr |> /= *; do! split; 1,2: smt().
  - rewrite (_ : start{hr} * 32 = 4 * (8 * start{hr})) 1:#ring.
    by rewrite wpoly_get256_aligned 1:/# /=.
  - rewrite (_ : start{hr} * 32 + 32 = 4 * (8 * start{hr} + 8)) 1:#ring.
    by rewrite wpoly_get256_aligned 1:/# /=.

seq 4 : (#pre /\
     low_values  = pack8 [uw 0; uw 2; vw 0; vw 2; uw 4; uw 6; vw 4; vw 6]
  /\ high_values = pack8 [uw 1; uw 3; vw 1; vw 3; uw 5; uw 7; vw 5; vw 7]
  /\ differences = pack8 [uw 1 - uw 0; uw 3 - uw 2; vw 1 - vw 0; vw 3 - vw 2;
                          uw 5 - uw 4; uw 7 - uw 6; vw 5 - vw 4; vw 7 - vw 6]
  /\ sums        = pack8 [uw 1 + uw 0; uw 3 + uw 2; vw 1 + vw 0; vw 3 + vw 2;
                          uw 5 + uw 4; uw 7 + uw 6; vw 5 + vw 4; vw 7 + vw 6]).
- by auto.

seq 1 : (#{/~{differences}}pre /\
  differences = pack8 [mmr (uw 1 - uw 0) (zw 0); mmr (uw 3 - uw 2) (zw 1);
                       mmr (vw 1 - vw 0) (zw 2); mmr (vw 3 - vw 2) (zw 3);
                       mmr (uw 5 - uw 4) (zw 4); mmr (uw 7 - uw 6) (zw 5);
                       mmr (vw 5 - vw 4) (zw 6); mmr (vw 7 - vw 6) (zw 7)]).
- by ecall (mmrP differences zetas); auto.

seq 4 : (#{/~{coeffs_i, coeffs_i_plus_1}}pre /\
     coeffs_i = pack8 [uw 1 + uw 0; mmr (uw 1 - uw 0) (zw 0);
                       uw 3 + uw 2; mmr (uw 3 - uw 2) (zw 1);
                       uw 5 + uw 4; mmr (uw 5 - uw 4) (zw 4);
                       uw 7 + uw 6; mmr (uw 7 - uw 6) (zw 5)]
  /\ coeffs_i_plus_1 = pack8 [vw 1 + vw 0; mmr (vw 1 - vw 0) (zw 2);
                              vw 3 + vw 2; mmr (vw 3 - vw 2) (zw 3);
                              vw 5 + vw 4; mmr (vw 5 - vw 4) (zw 6);
                              vw 7 + vw 6; mmr (vw 7 - vw 6) (zw 7)]).
- by auto.

seq 2 : (#{/~{polynomial}}pre /\ polynomial =
  let p0 = replace_ p  (8 * s_    ) (to_list coeffs_i) in
  let p1 = replace_ p0 (8 * s_ + 8) (to_list coeffs_i_plus_1) in
  p1).
- hoare split; [wp; skip=> &hr [#] ->> 2? idx1E idx2E 6? | by auto].
  rewrite (replace_mkseq ((\bits32) coeffs_i{hr}) _ _ 8) /=.
  rewrite (replace_mkseq ((\bits32) coeffs_i_plus_1{hr}) _ _ 8) /=.
  rewrite idx1E idx2E.
  rewrite (_ : 32 * s_ + 32 = 4 * (8 * s_ + 8)) 1:#ring.
  rewrite (_ : 32 * s_ = 4 * (8 * s_)) 1:#ring.
  rewrite !wpoly_set256_aligned ~-1:/#.
  by rewrite &(fill_congr) ~-1:/# &(fill_congr) ~-1:/#.

skip=> &hr [#] 2? lE rE sE dE ciE cpE -> /=.
rewrite ciE cpE /= -replace_cat ireduce_nE 1:/#; congr.
rewrite /perm0L /= /ireduce_coeff_flatten /ireduce_coeff /=.
by rewrite /uw /vw /zw /=; do! split; ring.
qed.

(* -------------------------------------------------------------------- *)
lemma INTT_layer1_bf (p : wpoly) (s_ : int) (z1 z2 z3 z4 : W32.t) :
     0 <= s_ < 32
  => 2 %| s_
  => hoare[M.polynomial__invert_at_layer_1 :
         arg = (p, s_, pack4 (map (W2u32.pack2 \o nseq 2) [z1; z2; z3; z4]))
       ==>
         res = ireduce_n p (8 * s_) 2 [z1; z3; z2; z4]
     ].
proof.
hint +listred.
move=> rgs dvds; proc.
pose uw (i : int) := p.[8 * s_ + i].
pose vw (i : int) := p.[8 * s_ + 8 + i].
have ?: 0 <= 8 * s_ < 256 - 7 by smt().
have ?: 0 <= 8 * s_ + 8 < 256 - 7 by smt().

seq 6 : (#pre /\
     coeffs_i_start = 32 * s_
  /\ coeffs_i_plus_1_start = 32 * s_ + 32
  /\ coeffs_i = pack8 [uw 0; uw 1; uw 2; uw 3; uw 4; uw 5; uw 6; uw 7]
  /\ coeffs_i_plus_1 = pack8 [vw 0; vw 1; vw 2; vw 3; vw 4; vw 5; vw 6; vw 7]).
- hoare split; auto=> &hr |> /= *; do! split; 1,2: smt().
  - rewrite (_ : start{hr} * 32 = 4 * (8 * start{hr})) 1:#ring.
    by rewrite wpoly_get256_aligned 1:/# /=.
  - rewrite (_ : start{hr} * 32 + 32 = 4 * (8 * start{hr} + 8)) 1:#ring.
    by rewrite wpoly_get256_aligned 1:/# /=.

seq 4 : (#pre /\
     low_values  = pack8 [uw 0; uw 1; vw 0; vw 1; uw 4; uw 5; vw 4; vw 5]
  /\ high_values = pack8 [uw 2; uw 3; vw 2; vw 3; uw 6; uw 7; vw 6; vw 7]
  /\ differences = pack8 [uw 2 - uw 0; uw 3 - uw 1; vw 2 - vw 0; vw 3 - vw 1;
                          uw 6 - uw 4; uw 7 - uw 5; vw 6 - vw 4; vw 7 - vw 5]
  /\ sums        = pack8 [uw 2 + uw 0; uw 3 + uw 1; vw 2 + vw 0; vw 3 + vw 1;
                          uw 6 + uw 4; uw 7 + uw 5; vw 6 + vw 4; vw 7 + vw 5]).
- by auto.

seq 1 : (#{/~{differences}}pre /\
  differences = pack8 [mmr (uw 2 - uw 0) z1; mmr (uw 3 - uw 1) z1;
                       mmr (vw 2 - vw 0) z2; mmr (vw 3 - vw 1) z2;
                       mmr (uw 6 - uw 4) z3; mmr (uw 7 - uw 5) z3;
                       mmr (vw 6 - vw 4) z4; mmr (vw 7 - vw 5) z4]).
- by ecall (mmrP differences zetas); auto.

seq 2 : (#{/~{coeffs_i, coeffs_i_plus_1}}pre /\
     coeffs_i = pack8 [uw 2 + uw 0; uw 3 + uw 1;
                       mmr (uw 2 - uw 0) z1; mmr (uw 3 - uw 1) z1;
                       uw 6 + uw 4; uw 7 + uw 5;
                       mmr (uw 6 - uw 4) z3; mmr (uw 7 - uw 5) z3]
  /\ coeffs_i_plus_1 = pack8 [vw 2 + vw 0; vw 3 + vw 1;
                              mmr (vw 2 - vw 0) z2; mmr (vw 3 - vw 1) z2;
                              vw 6 + vw 4; vw 7 + vw 5;
                              mmr (vw 6 - vw 4) z4; mmr (vw 7 - vw 5) z4]).
- by auto.

seq 2 : (#{/~{polynomial}}pre /\ polynomial =
  let p0 = replace_ p  (8 * s_    ) (to_list coeffs_i) in
  let p1 = replace_ p0 (8 * s_ + 8) (to_list coeffs_i_plus_1) in
  p1).
- hoare split; [wp; skip=> &hr [#] ->> 2? idx1E idx2E 6? | by auto].
  rewrite (replace_mkseq ((\bits32) coeffs_i{hr}) _ _ 8) /=.
  rewrite (replace_mkseq ((\bits32) coeffs_i_plus_1{hr}) _ _ 8) /=.
  rewrite idx1E idx2E.
  rewrite (_ : 32 * s_ + 32 = 4 * (8 * s_ + 8)) 1:#ring.
  rewrite (_ : 32 * s_ = 4 * (8 * s_)) 1:#ring.
  rewrite !wpoly_set256_aligned ~-1:/#.
  by rewrite &(fill_congr) ~-1:/# &(fill_congr) ~-1:/#.

skip=> &hr [#] 2? lE rE sE dE ciE cpE -> /=.
rewrite ciE cpE /= -replace_cat ireduce_nE 1:/#; congr.
rewrite /= /ireduce_coeff_flatten /ireduce_coeff /=.
by rewrite /uw /vw /=; do! split; ring.
qed.

(* -------------------------------------------------------------------- *)
lemma INTT_layer2_bf (p : wpoly) (s_ : int) (z1 z2 : W32.t) :
     0 <= s_ < 32
  => 2 %| s_
  => hoare[M.polynomial__invert_at_layer_2 :
         arg = (p, s_, pack2 [pack4 (nseq 4 z1); pack4 (nseq 4 z2)])
       ==>
         res = ireduce_n p (8 * s_) 4 [z1; z2]
     ].
proof.
hint +listred.
move=> rgs dvds; proc.
pose uw (i : int) := p.[8 * s_ + i].
pose vw (i : int) := p.[8 * s_ + 8 + i].
have ?: 0 <= 8 * s_ < 256 - 7 by smt().
have ?: 0 <= 8 * s_ + 8 < 256 - 7 by smt().

seq 6 : (#pre /\
     coeffs_i_start = 32 * s_
  /\ coeffs_i_plus_1_start = 32 * s_ + 32
  /\ coeffs_i = pack8 [uw 0; uw 1; uw 2; uw 3; uw 4; uw 5; uw 6; uw 7]
  /\ coeffs_i_plus_1 = pack8 [vw 0; vw 1; vw 2; vw 3; vw 4; vw 5; vw 6; vw 7]).
- hoare split; auto=> &hr |> /= *; do! split; 1,2: smt().
  - rewrite (_ : start{hr} * 32 = 4 * (8 * start{hr})) 1:#ring.
    by rewrite wpoly_get256_aligned 1:/# /=.
  - rewrite (_ : start{hr} * 32 + 32 = 4 * (8 * start{hr} + 8)) 1:#ring.
    by rewrite wpoly_get256_aligned 1:/# /=.

seq 4 : (#pre /\
     low_values  = pack8 [uw 0; uw 1; uw 2; uw 3; vw 0; vw 1; vw 2; vw 3]
  /\ high_values = pack8 [uw 4; uw 5; uw 6; uw 7; vw 4; vw 5; vw 6; vw 7]
  /\ differences = pack8 [uw 4 - uw 0; uw 5 - uw 1; uw 6 - uw 2; uw 7 - uw 3;
                          vw 4 - vw 0; vw 5 - vw 1; vw 6 - vw 2; vw 7 - vw 3]
  /\ sums        = pack8 [uw 4 + uw 0; uw 5 + uw 1; uw 6 + uw 2; uw 7 + uw 3;
                          vw 4 + vw 0; vw 5 + vw 1; vw 6 + vw 2; vw 7 + vw 3]).
- by auto.

seq 1 : (#{/~{differences}}pre /\
  differences = pack8 [mmr (uw 4 - uw 0) z1; mmr (uw 5 - uw 1) z1;
                       mmr (uw 6 - uw 2) z1; mmr (uw 7 - uw 3) z1;
                       mmr (vw 4 - vw 0) z2; mmr (vw 5 - vw 1) z2;
                       mmr (vw 6 - vw 2) z2; mmr (vw 7 - vw 3) z2]).
- by ecall (mmrP differences zetas); auto.

seq 2 : (#{/~{coeffs_i, coeffs_i_plus_1}}pre /\
     coeffs_i = pack8 [uw 4 + uw 0; uw 5 + uw 1; uw 6 + uw 2; uw 7 + uw 3;
                       mmr (uw 4 - uw 0) z1; mmr (uw 5 - uw 1) z1;
                       mmr (uw 6 - uw 2) z1; mmr (uw 7 - uw 3) z1]
  /\ coeffs_i_plus_1 = pack8 [vw 4 + vw 0; vw 5 + vw 1; vw 6 + vw 2; vw 7 + vw 3;
                              mmr (vw 4 - vw 0) z2; mmr (vw 5 - vw 1) z2;
                              mmr (vw 6 - vw 2) z2; mmr (vw 7 - vw 3) z2]).
- by auto.

seq 2 : (#{/~{polynomial}}pre /\ polynomial =
  let p0 = replace_ p  (8 * s_    ) (to_list coeffs_i) in
  let p1 = replace_ p0 (8 * s_ + 8) (to_list coeffs_i_plus_1) in
  p1).
- hoare split; [wp; skip=> &hr [#] ->> 2? idx1E idx2E 6? | by auto].
  rewrite (replace_mkseq ((\bits32) coeffs_i{hr}) _ _ 8) /=.
  rewrite (replace_mkseq ((\bits32) coeffs_i_plus_1{hr}) _ _ 8) /=.
  rewrite idx1E idx2E.
  rewrite (_ : 32 * s_ + 32 = 4 * (8 * s_ + 8)) 1:#ring.
  rewrite (_ : 32 * s_ = 4 * (8 * s_)) 1:#ring.
  rewrite !wpoly_set256_aligned ~-1:/#.
  by rewrite &(fill_congr) ~-1:/# &(fill_congr) ~-1:/#.

skip=> &hr [#] 2? lE rE sE dE ciE cpE -> /=.
rewrite ciE cpE /= -replace_cat ireduce_nE 1:/#; congr.
rewrite /= /ireduce_coeff_flatten /ireduce_coeff /=.
by rewrite /uw /vw /=; do! split; ring.
qed.

lemma polynomial__invert_ntt_at_layer_0P (p_ : wpoly) :
  hoare[M.polynomial__invert_ntt_at_layer_0 :
    polynomial = p_ ==> res = ireduce_level p_ 0].
proof.
hint +listred.
proc.
sp; while (
     0 <= i <= 16
  /\ polynomial = ireduce_n p_ 0 1
       (flatten (map (fun (w : W256.t) => map ((\bits32) w) perm0L)
                     (take i (Array16.to_list zETAS_TO_INVERT_LAYER_0))))
); last first.
- auto=> &hr |> *.
  rewrite take_oversize ?Array16.size_to_list 1://#.
  by rewrite ireduce_levelE // /izetasL /=.
sp; exlim i, zetas => i_ zetas_.
case@[ambient]: (0 <= i_ < 16) => ?; last first.
- by conseq (_ : false ==> _); [smt() | exfalso].
exlim polynomial => q.
wp; call (INTT_layer0_bf q (i_ * 2) zetas_); ~-1: move=> //#.
auto=> &hr |> *; do! (split=> *); ~-1: smt().
rewrite (take_nth witness) ?Array16.size_to_list 1://.
rewrite map_rcons flatten_rcons ireduce_n_cat /=; congr.
by rewrite size_flatten_bl0 size_take_condle ?Array16.size_to_list //#.
qed.

lemma polynomial__invert_ntt_at_layer_1P (p_ : wpoly) :
  hoare[M.polynomial__invert_ntt_at_layer_1 :
    polynomial = p_ ==> res = ireduce_level p_ 1].
proof.
hint +listred.
proc.
sp; while (
     0 <= i <= 16
  /\ polynomial = ireduce_n p_ 0 2
       (flatten (map
          (fun (w : W256.t) => map (fun m => w \bits32 (2 * m)) perm1L)
          (take i (Array16.to_list zETAS_TO_INVERT_LAYER_1))))
); last first.
- auto=> &hr |> *.
  rewrite take_oversize ?Array16.size_to_list 1://#.
  by rewrite ireduce_levelE // /izetasL /=.
sp; exlim i, zetas => i_ zetas_.
case@[ambient]: (0 <= i_ < 16) => ?; last first.
- by conseq (_ : false ==> _); [smt() | exfalso].
exlim polynomial => q.
wp; call (INTT_layer1_bf q (i_ * 2)
  (zetas_ \bits32 0) (zetas_ \bits32 2)
  (zetas_ \bits32 4) (zetas_ \bits32 6)); ~-1: move=> //#.
auto=> &hr |> *; do! (split=> *); 2,3: smt().
- by apply/T1_shape => /#.
rewrite (take_nth witness) ?Array16.size_to_list 1://.
rewrite map_rcons flatten_rcons ireduce_n_cat /=; congr.
- by rewrite size_flatten_bl1 size_take_condle ?Array16.size_to_list //#.
- by rewrite /perm1L.
qed.

lemma polynomial__invert_ntt_at_layer_2P (p_ : wpoly) :
  hoare[M.polynomial__invert_ntt_at_layer_2 :
    polynomial = p_ ==> res = ireduce_level p_ 2].
proof.
hint +listred.
proc.
sp; while (
     0 <= i <= 16
  /\ polynomial = ireduce_n p_ 0 4
       (flatten (map
          (fun (w : W256.t) => [w \bits32 0; w \bits32 4])
          (take i (Array16.to_list zETAS_TO_INVERT_LAYER_2))))
); last first.
- auto=> &hr |> *.
  rewrite take_oversize ?Array16.size_to_list 1://#.
  by rewrite ireduce_levelE // /izetasL /=.
sp; exlim i, zetas => i_ zetas_.
case@[ambient]: (0 <= i_ < 16) => ?; last first.
- by conseq (_ : false ==> _); [smt() | exfalso].
exlim polynomial => q.
wp; call (INTT_layer2_bf q (i_ * 2)
  (zetas_ \bits32 0) (zetas_ \bits32 4)); ~-1: move=> //#.
auto=> &hr |> *; do! (split=> *); 2,3: smt().
- by apply/T2_shape => /#.
rewrite (take_nth witness) ?Array16.size_to_list 1://.
rewrite map_rcons flatten_rcons ireduce_n_cat /=; congr.
by rewrite size_flatten_bl2 size_take_condle ?Array16.size_to_list //#.
qed.

(* ==================================================================== *)
(* Layers 3..7: while-loops over the strided round.                     *)
(* ==================================================================== *)
lemma polynomial__invert_ntt_at_layer_3P (p_ : wpoly) :
  hoare[M.polynomial__invert_ntt_at_layer_3 :
    polynomial = p_ ==> res = ireduce_level p_ 3].
proof.
hint +listred.
proc.
proc change [1..2] : { sTEP <- 8; sTEP_BY <- 1; }; first by auto.
do 2! (cfold 1; kill -1; first by auto).
sp; while (
     0 <= i <= 16
  /\ polynomial = ireduce_n p_ 0 8 (take i (izetasL 3))
); last first.
- auto=> &hr |> *; do! (split=> *).
  - by rewrite take0 ireduce_n0.
  - by rewrite ireduce_levelE // take_oversize ?size_izetasL3 //#.
sp; exlim i, zeta_0 => i_ zeta0_.
case@[ambient]: (0 <= i_ < 16) => ?; last first.
- by conseq (_ : false ==> _); [smt() | exfalso].
exlim polynomial => q.
wp; call (intt_roundP q 1 (2 * i_) zeta0_); ~-1: move=> //#.
auto=> &hr |> *; do! (split=> *); ~-1: smt().
rewrite (take_nth witness) ?size_izetasL3 1://.
rewrite ireduce_rcons /=; congr.
- by rewrite size_take_condle ?size_izetasL3 //#.
- by rewrite /izetasL /=.
qed.

(* -------------------------------------------------------------------- *)
lemma polynomial__invert_ntt_at_layer_4P (p_ : wpoly) :
  hoare[M.polynomial__invert_ntt_at_layer_4 :
    polynomial = p_ ==> res = ireduce_level p_ 4].
proof.
hint +listred.
proc.
proc change [1..2] : { sTEP <- 16; sTEP_BY <- 2; }; first by auto.
do 2! (cfold 1; kill -1; first by auto).
sp; while (
     0 <= i <= 8
  /\ polynomial = ireduce_n p_ 0 16 (take i (izetasL 4))
); last first.
- auto=> &hr |> *; do! (split=> *).
  - by rewrite take0 ireduce_n0.
  - by rewrite ireduce_levelE // take_oversize ?size_izetasL4 //#.
sp; exlim i, zeta_0 => i_ zeta0_.
case@[ambient]: (0 <= i_ < 8) => ?; last first.
- by conseq (_ : false ==> _); [smt() | exfalso].
exlim polynomial => q.
wp; call (intt_roundP q 2 (4 * i_) zeta0_); ~-1: move=> //#.
auto=> &hr |> *; do! (split=> *); ~-1: smt().
rewrite (take_nth witness) ?size_izetasL4 1://.
rewrite ireduce_rcons /=; congr.
- by rewrite size_take_condle ?size_izetasL4 //#.
- by rewrite /izetasL /=.
qed.

(* -------------------------------------------------------------------- *)
lemma polynomial__invert_ntt_at_layer_5P (p_ : wpoly) :
  hoare[M.polynomial__invert_ntt_at_layer_5 :
    polynomial = p_ ==> res = ireduce_level p_ 5].
proof.
hint +listred.
proc.
proc change [1..2] : { sTEP <- 32; sTEP_BY <- 4; }; first by auto.
do 2! (cfold 1; kill -1; first by auto).
sp; while (
     0 <= i <= 4
  /\ polynomial = ireduce_n p_ 0 32 (take i (izetasL 5))
); last first.
- auto=> &hr |> *; do! (split=> *).
  - by rewrite take0 ireduce_n0.
  - by rewrite ireduce_levelE // take_oversize ?size_izetasL5 //#.
sp; exlim i, zeta_0 => i_ zeta0_.
case@[ambient]: (0 <= i_ < 4) => ?; last first.
- by conseq (_ : false ==> _); [smt() | exfalso].
exlim polynomial => q.
wp; call (intt_roundP q 4 (8 * i_) zeta0_); ~-1: move=> //#.
auto=> &hr |> *; do! (split=> *); ~-1: smt().
rewrite (take_nth witness) ?size_izetasL5 1://.
rewrite ireduce_rcons /=; congr.
- by rewrite size_take_condle ?size_izetasL5 //#.
- by rewrite /izetasL /=.
qed.

(* -------------------------------------------------------------------- *)
lemma polynomial__invert_ntt_at_layer_6P (p_ : wpoly) :
  hoare[M.polynomial__invert_ntt_at_layer_6 :
    polynomial = p_ ==> res = ireduce_level p_ 6].
proof.
hint +listred.
proc.
proc change [1..2] : { sTEP <- 64; sTEP_BY <- 8; }; first by auto.
do 2! (cfold 1; kill -1; first by auto).
sp; while (
     0 <= i <= 2
  /\ polynomial = ireduce_n p_ 0 64 (take i (izetasL 6))
); last first.
- auto=> &hr |> *; do! (split=> *).
  - by rewrite take0 ireduce_n0.
  - by rewrite ireduce_levelE // take_oversize ?size_izetasL6 //#.
sp; exlim i, zeta_0 => i_ zeta0_.
case@[ambient]: (0 <= i_ < 2) => ?; last first.
- by conseq (_ : false ==> _); [smt() | exfalso].
exlim polynomial => q.
wp; call (intt_roundP q 8 (16 * i_) zeta0_); ~-1: move=> //#.
auto=> &hr |> *; do! (split=> *); ~-1: smt().
rewrite (take_nth witness) ?size_izetasL6 1://.
rewrite ireduce_rcons /=; congr.
- by rewrite size_take_condle ?size_izetasL6 //#.
- by rewrite /izetasL /=.
qed.

(* -------------------------------------------------------------------- *)
lemma polynomial__invert_ntt_at_layer_7P (p_ : wpoly) :
  hoare[M.polynomial__invert_ntt_at_layer_7 :
    polynomial = p_ ==> res = ireduce_level p_ 7].
proof.
hint +listred.
proc.
proc change [1..2] : { sTEP <- 128; sTEP_BY <- 16; }; first by auto.
do 2! (cfold 1; kill -1; first by auto).
sp; while (
     0 <= i <= 1
  /\ polynomial = ireduce_n p_ 0 128 (take i (izetasL 7))
); last first.
- auto=> &hr |> *; do! (split=> *).
  - by rewrite take0 ireduce_n0.
  - by rewrite ireduce_levelE // take_oversize ?size_izetasL7 //#.
sp; exlim i, zeta_0 => i_ zeta0_.
case@[ambient]: (0 <= i_ < 1) => ?; last first.
- by conseq (_ : false ==> _); [smt() | exfalso].
exlim polynomial => q.
wp; call (intt_roundP q 16 (32 * i_) zeta0_); ~-1: move=> //#.
auto=> &hr |> *; do! (split=> *); ~-1: smt().
rewrite (take_nth witness) ?size_izetasL7 1://.
rewrite ireduce_rcons /=; congr.
- by rewrite size_take_condle ?size_izetasL7 //#.
- by rewrite /izetasL /=; smt().
qed.

(* ==================================================================== *)
(* Main theorem (statement; the per-layer development below fills it).  *)
(* ==================================================================== *)
lemma polynomial__invert_ntt_montgomeryP (p_ : wpoly) :
  hoare[M.polynomial__invert_ntt_montgomery :
    polynomial = p_ ==> res = iscale (invtree p_ 8)].
proof.
hint +listred.
proc.
seq 1 : (polynomial = invtree p_ 1).
- by call (polynomial__invert_ntt_at_layer_0P p_); auto=> &hr |>.
exlim polynomial => q; seq 1 : (polynomial = invtree p_ 2).
- by call (polynomial__invert_ntt_at_layer_1P q); auto=> &hr |>.
exlim polynomial => {q} q; seq 1 : (polynomial = invtree p_ 3).
- by call (polynomial__invert_ntt_at_layer_2P q); auto=> &hr |>.
exlim polynomial => {q} q; seq 1 : (polynomial = invtree p_ 4).
- by call (polynomial__invert_ntt_at_layer_3P q); auto=> &hr |>.
exlim polynomial => {q} q; seq 1 : (polynomial = invtree p_ 5).
- by call (polynomial__invert_ntt_at_layer_4P q); auto=> &hr |>.
exlim polynomial => {q} q; seq 1 : (polynomial = invtree p_ 6).
- by call (polynomial__invert_ntt_at_layer_5P q); auto=> &hr |>.
exlim polynomial => {q} q; seq 1 : (polynomial = invtree p_ 7).
- by call (polynomial__invert_ntt_at_layer_6P q); auto=> &hr |>.
exlim polynomial => {q} q; seq 1 : (polynomial = invtree p_ 8).
- by call (polynomial__invert_ntt_at_layer_7P q); auto=> &hr |>.

exlim polynomial => {q} q.
pose w_ := W32.of_int 41978.

seq 3 : (polynomial = q /\ q = invtree p_ 8 /\
  twiddle_factors = pack8 [w_; w_; w_; w_; w_; w_; w_; w_]).
- by auto.

sp; while (
     0 <= i <= 1024
  /\ 32 %| i
  /\ q = invtree p_ 8
  /\ twiddle_factors = pack8 [w_; w_; w_; w_; w_; w_; w_; w_]
  /\ polynomial = iscale_partial q (i %/ 4)
); last first.
- skip=> &hr |>; split*.
  - smt().
  - by rewrite iscale_partial0.
  - move=> i0 *; have ->: i0 %/ 4 = 256 by smt().
    by rewrite iscale_partial_full.

exlim i => i_.
case@[ambient]: (0 <= i_ < 1024 /\ 32 %| i_) => *; last first.
- by conseq (_ : false ==> _); [smt() | exfalso].
pose n_ := i_ %/ 4.
have ?: 0 <= n_ < 256 - 7 by smt().
have ?: i_ %% 4 = 0 by smt().

seq 1 : (#pre /\ coefficients = pack8 (mkseq (fun k => q.[n_ + k]) 8)).
- auto=> &hr |> *.
  rewrite wpoly_get256_alignedE ~-1:/# /=.
  by rewrite !eqexcept_iscale_partial //#.

seq 1 : (#{/~{coefficients}}pre /\
  coefficients = pack8 (mkseq (fun k => mmr q.[n_ + k] w_) 8)).
- by ecall (mmrP coefficients twiddle_factors); auto.

auto=> &hr |> *; do! (split=> *); ~-1: smt().
rewrite (_ : (i{hr} + 32) %/ 4 = n_ + 8) 1:/#.
rewrite (iscale_partialS (invtree p_ 8) n_) ~-1:/#.
rewrite (_ : i{hr} = 4 * n_) 1:/#.
rewrite wpoly_set256_aligned 1:/# /=.
rewrite (_ : 4 * n_ %/ 4 = n_) 1:/# /replace_.
apply fill_congr => //= i0 rgi.
by rewrite pack8_bits32E 1:/#; smt().
qed.

end InttcorrectT.
