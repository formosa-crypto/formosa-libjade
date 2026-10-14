require import AllCore List IntDiv.
from Jasmin require import JModel_x86.
from Spec require import GFq Rq Parameters MLDSA_W32_Rep.
require import Array64 Array256.
require BaseT PreludeT.

(* -------------------------------------------------------------------- *)
(* The sampler of the secret vectors s1 and s2 (ExpandS). The l + k     *)
(* polynomials are sampled four lanes at a time, at the separators      *)
(* 0, 1, ..., l + k - 1; the last batch drops its unused lanes. The     *)
(* four-lane core depends on Eta: its correctness is a hypothesis of    *)
(* this theory, discharged per variant.                                 *)
(* -------------------------------------------------------------------- *)
abstract theory ErrorVectorsT.

clone import BaseT.BaseT as B.
import S R MLDSAParams.
clone import PreludeT.PreludeT as PR with theory B <= B.

import PolyLVec PolyKVec PolyMat.
import Round ZModQ Zq.
import Array_lpolys Array_kpolys.

(* the polynomial at separator j: the specification's RejBoundedPoly    *)
op Spoly_ok (rho_ : W8.t Array64.t) (j : int) (p : W32.t Array256.t) =
     lifts_wpoly p
     = rejBoundedPoly (Bytes66.of_list (to_list rho_ ++ W2u8.to_list (W16.of_int j)))
  /\ wpoly_srng Eta Eta p.

axiom sample_polynomials_4x (rho_ : W8.t Array64.t) (ds0 : int) :
  phoare [ M.error_4x____sample_polynomials :
      rho_prime = rho_ /\ starting_domain_separator = W16.of_int ds0
    ==>
      forall i, 0 <= i < 4 =>
        Spoly_ok rho_ (ds0 + i) (nth witness [res.`1; res.`2; res.`3; res.`4] i)
  ] = 1%r.

lemma sample_polynomials_4x_ll : islossless M.error_4x____sample_polynomials.
proof.
proc*; exlim rho_prime, starting_domain_separator => rho_ ds.
call (sample_polynomials_4x rho_ (W16.to_uint ds)).
by auto => />; rewrite W16.to_uintK.
qed.
hint solve 0 lossless : sample_polynomials_4x_ll.

lemma sample_polynomials_4xH (rho_ : W8.t Array64.t) (ds0 : int) :
  hoare [ M.error_4x____sample_polynomials :
      rho_prime = rho_ /\ starting_domain_separator = W16.of_int ds0
    ==>
      forall i, 0 <= i < 4 =>
        Spoly_ok rho_ (ds0 + i) (nth witness [res.`1; res.`2; res.`3; res.`4] i) ].
proof. by conseq (sample_polynomials_4x rho_ ds0). qed.

(* -------------------------------------------------------------------- *)
(* The vectors: window r of s1 is the polynomial at separator r, window *)
(* r of s2 the one at separator l + r                                   *)
op s1_ok (rho_ : W8.t Array64.t) (s1 : W32.t Array_lpolys.t) (k : int) =
  forall r, 0 <= r < k => Spoly_ok rho_ r (lvec_unflatten256 s1).[r].

op s2_ok (rho_ : W8.t Array64.t) (s2 : W32.t Array_kpolys.t) (k : int) =
  forall r, 0 <= r < k => Spoly_ok rho_ (lvec + r) (kvec_unflatten256 s2).[r].

lemma s1_ok0 rho_ s1 : s1_ok rho_ s1 0.
proof. by rewrite /s1_ok => /#. qed.

lemma s2_ok0 rho_ s2 : s2_ok rho_ s2 0.
proof. by rewrite /s2_ok => /#. qed.

lemma s1_ok_write rho_ s1 (f : W32.t Array256.t) (b k : int) :
  b = 256 * k => 0 <= k < lvec =>
  s1_ok rho_ s1 k => Spoly_ok rho_ k f =>
  s1_ok rho_
    (Array_lpolys.init (fun i => if b <= i < b + 256 then f.[i - b] else s1.[i])) (k + 1).
proof.
move=> -> rgk hs hf; rewrite /s1_ok => r rgr.
rewrite lvec_unflatten256_writeback_iE 1:/# 1:/#.
case: (r = 256 * k %/ 256) => [hr|hr]; first by have -> : r = k by smt().
by have := hs r _; smt().
qed.

lemma s2_ok_write rho_ s2 (f : W32.t Array256.t) (b k : int) :
  b = 256 * k => 0 <= k < kvec =>
  s2_ok rho_ s2 k => Spoly_ok rho_ (lvec + k) f =>
  s2_ok rho_
    (Array_kpolys.init (fun i => if b <= i < b + 256 then f.[i - b] else s2.[i])) (k + 1).
proof.
move=> -> rgk hs hf; rewrite /s2_ok => r rgr.
rewrite kvec_unflatten256_writeback_iE 1:/# 1:/#.
case: (r = 256 * k %/ 256) => [hr|hr]; first by have -> : r = k by smt().
by have := hs r _; smt().
qed.

(* -------------------------------------------------------------------- *)
(* The batches: l = 4 (k = 4) takes two, l = 5 (k = 6) and l = 7        *)
(* (k = 8) take three and four, the last one dropping its last lane     *)
lemma sample____error_vectorsP (rho_ : W8.t Array64.t) :
  hoare [ M.sample____error_vectors : rho_prime = rho_ ==>
    s1_ok rho_ res.`1 lvec /\ s2_ok rho_ res.`2 kvec ].
proof.
have hp := param_sets.
proc; sp.
case @[ambient] (lvec = 4) => hl4.
- have hk4 : kvec = 4 by smt().
  rcondt 1; 1: by auto.
  seq 10 : (s1_ok rho_ s1 4 /\ s2_ok rho_ s2 4); last first.
  + rcondf 1; 1: by auto => /#.
    rcondf 1; 1: by auto => /#.
    by skip; rewrite hl4 hk4.
  seq 5 : (rho_prime = rho_ /\ s1_ok rho_ s1 4).
  + wp; ecall (sample_polynomials_4xH rho_ 0).
    skip => &hr [_ [_ [_ [_ h]]]]; split => // _ r hall.
    split; 1: smt().
    have := hall 0 _; have := hall 1 _; have := hall 2 _; have := hall 3 _ => //=.
    move=> h3 h2 h1 h0.
    apply (s1_ok_write _ _ _ _ 3) => //; 1: smt().
    apply (s1_ok_write _ _ _ _ 2) => //; 1: smt().
    apply (s1_ok_write _ _ _ _ 1) => //; 1: smt().
    apply (s1_ok_write _ _ _ _ 0) => //; 1: smt().
    exact s1_ok0.
  wp; ecall (sample_polynomials_4xH rho_ 4).
  skip => &hr [-> h]; split => // _ r hall.
  split => //.
  have := hall 0 _; have := hall 1 _; have := hall 2 _; have := hall 3 _ => //=.
  move=> h3 h2 h1 h0.
  apply (s2_ok_write _ _ _ _ 3) => //; 1: smt(); 2: by rewrite hl4.
  apply (s2_ok_write _ _ _ _ 2) => //; 1: smt(); 2: by rewrite hl4.
  apply (s2_ok_write _ _ _ _ 1) => //; 1: smt(); 2: by rewrite hl4.
  apply (s2_ok_write _ _ _ _ 0) => //; 1: smt(); 2: by rewrite hl4.
  exact s2_ok0.
rcondf 1; 1: by auto.
case @[ambient] (lvec = 5) => hl5.
- have hk6 : kvec = 6 by smt().
  rcondt 1; 1: by auto.
  seq 15 : (s1_ok rho_ s1 5 /\ s2_ok rho_ s2 6); last first.
  + by rcondf 1; [auto => /# | skip; rewrite hl5 hk6].
  seq 5 : (rho_prime = rho_ /\ s1_ok rho_ s1 4).
  + wp; ecall (sample_polynomials_4xH rho_ 0).
    skip => &hr [_ [_ [_ [_ ->]]]]; split => // _ r hall.
    have := hall 0 _; have := hall 1 _; have := hall 2 _; have := hall 3 _ => //=.
    move=> h3 h2 h1 h0.
    apply (s1_ok_write _ _ _ _ 3) => //; 1: smt().
    apply (s1_ok_write _ _ _ _ 2) => //; 1: smt().
    apply (s1_ok_write _ _ _ _ 1) => //; 1: smt().
    apply (s1_ok_write _ _ _ _ 0) => //; 1: smt().
    exact s1_ok0.
  seq 5 : (rho_prime = rho_ /\ s1_ok rho_ s1 5 /\ s2_ok rho_ s2 3).
  + wp; ecall (sample_polynomials_4xH rho_ 4).
    skip => &hr [-> h]; split => // _ r hall.
    have := hall 0 _; have := hall 1 _; have := hall 2 _; have := hall 3 _ => //=.
    move=> h3 h2 h1 h0.
    split; 1: by apply (s1_ok_write _ _ _ _ 4) => //; smt().
    apply (s2_ok_write _ _ _ _ 2) => //; 1: smt(); 2: by rewrite hl5.
    apply (s2_ok_write _ _ _ _ 1) => //; 1: smt(); 2: by rewrite hl5.
    apply (s2_ok_write _ _ _ _ 0) => //; 1: smt(); 2: by rewrite hl5.
    exact s2_ok0.
  wp; ecall (sample_polynomials_4xH rho_ 8).
  skip => &hr [-> [h1s h2s]]; split => // _ r hall.
  have := hall 0 _; have := hall 1 _; have := hall 2 _ => //=.
  move=> h2 h1 h0.
  split => //.
  apply (s2_ok_write _ _ _ _ 5) => //; 1: smt(); 2: by rewrite hl5.
  apply (s2_ok_write _ _ _ _ 4) => //; 1: smt(); 2: by rewrite hl5.
  apply (s2_ok_write _ _ _ _ 3) => //; 1: smt().
  by rewrite hl5.
rcondf 1; 1: by auto.
have hl7 : lvec = 7 by smt().
have hk8 : kvec = 8 by smt().
rcondt 1; 1: by auto.
conseq (: _ ==> s1_ok rho_ s1 7 /\ s2_ok rho_ s2 8); 1: by rewrite hl7 hk8.
seq 5 : (rho_prime = rho_ /\ s1_ok rho_ s1 4).
+ wp; ecall (sample_polynomials_4xH rho_ 0).
  skip => &hr [_ [_ [_ [_ ->]]]]; split => // _ r hall.
  have := hall 0 _; have := hall 1 _; have := hall 2 _; have := hall 3 _ => //=.
  move=> h3 h2 h1 h0.
  apply (s1_ok_write _ _ _ _ 3) => //; 1: smt().
  apply (s1_ok_write _ _ _ _ 2) => //; 1: smt().
  apply (s1_ok_write _ _ _ _ 1) => //; 1: smt().
  apply (s1_ok_write _ _ _ _ 0) => //; 1: smt().
  exact s1_ok0.
seq 5 : (rho_prime = rho_ /\ s1_ok rho_ s1 7 /\ s2_ok rho_ s2 1).
+ wp; ecall (sample_polynomials_4xH rho_ 4).
  skip => &hr [-> h]; split => // _ r hall.
  have := hall 0 _; have := hall 1 _; have := hall 2 _; have := hall 3 _ => //=.
  move=> h3 h2 h1 h0.
  split.
  - apply (s1_ok_write _ _ _ _ 6) => //; 1: smt().
    apply (s1_ok_write _ _ _ _ 5) => //; 1: smt().
    by apply (s1_ok_write _ _ _ _ 4) => //; smt().
  apply (s2_ok_write _ _ _ _ 0) => //; 1: smt(); 2: by rewrite hl7.
  exact s2_ok0.
seq 5 : (rho_prime = rho_ /\ s1_ok rho_ s1 7 /\ s2_ok rho_ s2 5).
+ wp; ecall (sample_polynomials_4xH rho_ 8).
  skip => &hr [-> [h1s h2s]]; split => // _ r hall.
  have := hall 0 _; have := hall 1 _; have := hall 2 _; have := hall 3 _ => //=.
  move=> h3 h2 h1 h0.
  split => //.
  apply (s2_ok_write _ _ _ _ 4) => //; 1: smt(); 2: by rewrite hl7.
  apply (s2_ok_write _ _ _ _ 3) => //; 1: smt(); 2: by rewrite hl7.
  apply (s2_ok_write _ _ _ _ 2) => //; 1: smt(); 2: by rewrite hl7.
  apply (s2_ok_write _ _ _ _ 1) => //; 1: smt().
  by rewrite hl7.
wp; ecall (sample_polynomials_4xH rho_ 12).
skip => &hr [-> [h1s h2s]]; split => // _ r hall.
have := hall 0 _; have := hall 1 _; have := hall 2 _ => //=.
move=> h2 h1 h0.
split => //.
apply (s2_ok_write _ _ _ _ 7) => //; 1: smt(); 2: by rewrite hl7.
apply (s2_ok_write _ _ _ _ 6) => //; 1: smt(); 2: by rewrite hl7.
apply (s2_ok_write _ _ _ _ 5) => //; 1: smt().
by rewrite hl7.
qed.

lemma sample____error_vectors_ll : islossless M.sample____error_vectors.
proof. by islossless. qed.

(* -------------------------------------------------------------------- *)
(* The sampler is the specification's ExpandS                           *)
lemma error_vectors_correct _rho :
  phoare [ M.sample____error_vectors : arg = _rho ==>
       lifts_wpolylvec (lvec_unflatten256 res.`1)
         = (expandS (Bytes64.of_list (Array64.to_list _rho))).`1
    /\ wpolylvec_srng (lvec_unflatten256 res.`1) Eta Eta
    /\ lifts_wpolykvec (kvec_unflatten256 res.`2)
         = (expandS (Bytes64.of_list (Array64.to_list _rho))).`2
    /\ wpolykvec_srng (kvec_unflatten256 res.`2) Eta Eta
  ] = 1%r.
proof.
conseq sample____error_vectors_ll (sample____error_vectorsP _rho).
move=> &hr _ r; split => [[_ //] | [_ [h1 h2]]]; split => //.
have hrho : Bytes64.to_list (Bytes64.of_list (to_list _rho)) = to_list _rho.
- by rewrite Bytes64.of_listK // Array64.size_to_list.
have hp := param_sets.
do! split.
- apply LArray.tP => i rgi; rewrite /lifts_wpolylvec LArray.mapiE //=.
  have [-> _] := h1 i rgi.
  by rewrite /expandS /= LArray.initiE //= hrho IntegerToBytes2E 1:/#.
- by rewrite /wpolylvec_srng LArray.allP => i rgi; have [_ ->] := h1 i rgi.
- apply KArray.tP => i rgi; rewrite /lifts_wpolykvec KArray.mapiE //=.
  have [-> _] := h2 i rgi.
  by rewrite /expandS /= KArray.initiE //= hrho IntegerToBytes2E 1:/# addzC.
by rewrite /wpolykvec_srng KArray.allP => i rgi; have [_ ->] := h2 i rgi.
qed.

end ErrorVectorsT.
