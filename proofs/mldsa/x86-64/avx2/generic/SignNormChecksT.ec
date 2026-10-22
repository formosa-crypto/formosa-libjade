require import AllCore List IntDiv RealExp.
from Jasmin require import JModel_x86.
from Spec require import GFq Rq Parameters MLDSA_W32_Rep.
require import Array256 Array512.
require BaseT PreludeT PolynomialT CommonNttT CommonModularT CommonInvertNttT CommonRoundingT
        RowVectorT SignatureT ReduceCheckT SparseT.

abstract theory SignNormChecksT.

clone import BaseT.BaseT as B.
import S R MLDSAParams.
clone import PreludeT.PreludeT as PR with theory B <- B.
clone import PolynomialT.PolynomialT as PL with theory B <- B.
clone CommonNttT.CommonNttT as CN with theory B <- B.
clone import CommonModularT.CommonModularT as CM with theory B <- B.
clone import CommonInvertNttT.CommonInvertNttT as CI with theory B <- B.
clone import CommonRoundingT.CommonRoundingT as CRD with theory B <- B.
clone import RowVectorT.RowVectorT as RV with
  theory B <- B, theory PR <- PR, theory PL <- PL, theory CN <- CN, theory CM <- CM.
clone import SignatureT.SignatureT as SG with theory B <- B, theory PR <- PR.
clone ReduceCheckT.ReduceCheckT as RC with theory B <- B, theory PL <- PL.
clone import SparseT.SparseT as SP with theory B <- B.
import CR.

(* the bound on Eta the norm checks use *)
lemma eta_bound : 0 < Eta <= 4.
proof. smt(param_sets). qed.

import PolyLVec PolyKVec.
import Round ZModQ Zq.
import Array_kpolys Array_lpolys Array_kpolys2.
import StdBigop.Bigint BIA.



lemma lifts_wpolykvec_slice (v : W32.t Array_kpolys.t) (base : int) :
  base %% 256 = 0 => 0 <= base %/ 256 < kvec =>
  lifts_wpoly (Array256.init (fun i => v.[base + i])) =
  (lifts_wpolykvec (kvec_unflatten256 v)).[base %/ 256].
proof.
move => Hmod Hk.
rewrite /lifts_wpolykvec mapiE 1:/# /=.
by rewrite -kvec_slice_eq.
qed.

(* the k-th doubled polynomial of a doubled K-vector (512-element windows) *)
op kvec_slice512 (d : 'a Array_kpolys2.t) (k : int) : 'a Array512.t =
  Array512.init (fun i => d.[512 * k + i]).

(* a writeback of the window at 512 i changes the i-th doubled polynomial only *)
lemma kvec_slice512_writeback_iE (arr : 'a Array_kpolys2.t) (f : 'a Array512.t) (i k : int) :
  0 <= i < kvec => 0 <= k < kvec =>
  kvec_slice512 (Array_kpolys2.init (fun j =>
    if i * 2 * 256 <= j < i * 2 * 256 + 512 then f.[j - i * 2 * 256] else arr.[j])) k =
  if k = i then f else kvec_slice512 arr k.
proof.
move=> hi hk; rewrite /kvec_slice512; apply Array512.tP => j hj.
rewrite Array512.initiE 1:// /= Array_kpolys2.initiE 1:/kpolys2 1:/kpolys 1:/# /=.
case (k = i) => [->> | hne] /=; 1: by rewrite ifT 1:/#; congr; ring.
by rewrite ifF 1:/# Array512.initiE.
qed.

lemma lifts_wpolylvec_slice (v : W32.t Array_lpolys.t) (base : int) :
  base %% 256 = 0 => 0 <= base %/ 256 < lvec =>
  lifts_wpoly (Array256.init (fun i => v.[base + i])) =
  (lifts_wpolylvec (lvec_unflatten256 v)).[base %/ 256].
proof.
move => Hmod Hk.
rewrite /lifts_wpolylvec mapiE 1:/# /=.
by rewrite -lvec_slice_eq.
qed.

lemma __apply_cs2_and_check_norm_ll : islossless M.__apply_cs2_and_check_norm.
proof.
proc.
wp; while (0 <= base <= kvec * n /\ base %% n = 0) (kvec * n - base); last by auto; smt(gt0_k).
move => ?.
wp; call RC.polynomial____subtract_reduce32_check_infinity_norm_ll.
wp; call polynomial____sparse_multiply_16_ll.
by auto => /#.
qed.

(* ================================================================== *)
(* __compute_signer_response_element                                    *)
(* Computes one column of z = mask + c*s1:                             *)
(*   cs1 = c * s1_element, exact (|.| <= tau Eta), by the sparse       *)
(*   product on the doubled s1_element and the positions of c          *)
(*   result = reduce32(mask_element + cs1), with its norm test against *)
(*   gamma1 - Beta, in one pass                                         *)
(* ================================================================== *)

lemma __compute_signer_response_element_ll : islossless M.__compute_signer_response_element.
proof.
proc.
wp; call RC.polynomial____add_reduce32_check_infinity_norm_ll.
wp; call polynomial____sparse_multiply_16_ll.
by auto.
qed.

lemma __compute_signer_response_element_correct
      (_s1d _s1e : W32.t Array256.t) (_c : W32.t Array256.t) (_pos : W32.t Array_tau1.t)
      (_mask_e : W32.t Array256.t) (_sre : W32.t Array256.t) :
    hoare [ M.__compute_signer_response_element :
        s1_doubled = _s1d /\ challenge_positions = _pos /\
        mask_element = _mask_e /\ signer_response_element = _sre /\
        wpoly_srng Eta Eta _s1e /\ doubled16_of _s1d _s1e /\
        wpoly_srng 1 1 _c /\ challenge_shape (lifts_wpoly _c) /\
        positions_of _pos (lifts_wpoly _c) /\
        wpoly_srng gamma1 gamma1 _mask_e
        ==>
        (* z = mask + c * s1 coefficient-wise *)
        lifts_wpoly res.`1 =
          lifts_wpoly _mask_e &+ (lifts_wpoly _s1e &* lifts_wpoly _c) /\
        (* output is reduced to centered representatives *)
        wpoly_srng 6283009 6283008 res.`1 /\
        (* the flag is the norm test of the output *)
        (wpoly_infnorm_lt (gamma1 - Beta) res.`1 => res.`2 = W64.zero) /\
        (!wpoly_infnorm_lt (gamma1 - Beta) res.`1 => res.`2 = W64.one)
    ].
proof.
have hg1 : (1 `<<` gamma1m1_bits) = gamma1.
+ by rewrite /(`<<`) /gamma1m1_bits /gamma1 ifT; [smt(param_sets) | ring].
proc.
ecall (RC.polynomial____add_reduce32_check_infinity_norm_correct
         signer_response_element cs1 mask_element (tau * Eta) gamma1 (gamma1 - Beta)).
ecall (polynomial____sparse_multiply_16_correct s1_doubled challenge_positions _s1e _c).
auto => |> Hs1e Hd Hc Hsh Hpos Hmask result Hres_eq Hres_rng.
split.
+ split; 1: by rewrite hg1 /Beta.
  split; 1: smt(gamma1_cases beta_gamma1_lt gt0_beta).
  by have := beta_gamma1_lt; rewrite /Beta; smt(gamma1_cases).
move => _ _ _ _ r1 Hr1_eq _ _ _.
by rewrite Hr1_eq Hres_eq Rq_addC Rq_mulC.
qed.

lemma __compute_signer_response_element_ph
      (_s1d _s1e : W32.t Array256.t) (_c : W32.t Array256.t) (_pos : W32.t Array_tau1.t)
      (_mask_e : W32.t Array256.t) (_sre : W32.t Array256.t) :
    phoare [ M.__compute_signer_response_element :
        s1_doubled = _s1d /\ challenge_positions = _pos /\
        mask_element = _mask_e /\ signer_response_element = _sre /\
        wpoly_srng Eta Eta _s1e /\ doubled16_of _s1d _s1e /\
        wpoly_srng 1 1 _c /\ challenge_shape (lifts_wpoly _c) /\
        positions_of _pos (lifts_wpoly _c) /\
        wpoly_srng gamma1 gamma1 _mask_e
        ==>
        (* z = mask + c * s1 coefficient-wise *)
        lifts_wpoly res.`1 =
          lifts_wpoly _mask_e &+ (lifts_wpoly _s1e &* lifts_wpoly _c) /\
        (* output is reduced to centered representatives *)
        wpoly_srng 6283009 6283008 res.`1 /\
        (* the flag is the norm test of the output *)
        (wpoly_infnorm_lt (gamma1 - Beta) res.`1 => res.`2 = W64.zero) /\
        (!wpoly_infnorm_lt (gamma1 - Beta) res.`1 => res.`2 = W64.one)
    ] = 1%r
  by conseq __compute_signer_response_element_ll
            (__compute_signer_response_element_correct _s1d _s1e _c _pos _mask_e _sre).

lemma __apply_cs2_and_check_norm_correct
      (_w0mc : W32.t Array_kpolys.t) (_w0 : W32.t Array_kpolys.t)
      (_s2d _s2 : W32.t Array_kpolys.t) (_c : W32.t Array256.t)
      (_pos : W32.t Array_tau1.t) (_incr : W64.t)
      :
    hoare [ M.__apply_cs2_and_check_norm :
        w0_minus_cs2 = _w0mc /\ w0 = _w0 /\ s2_doubled = _s2d /\
        challenge_positions = _pos /\ infinity_norm_check_result = _incr /\
        (_incr = W64.zero \/ _incr = W64.one) /\
        wpoly_srng 1 1 _c /\ challenge_shape (lifts_wpoly _c) /\
        positions_of _pos (lifts_wpoly _c) /\
        wpolykvec_srng (kvec_unflatten256 _s2) Eta Eta /\
        (forall k, 0 <= k < kvec =>
           doubled16_of (kvec_unflatten256 _s2d).[k] (kvec_unflatten256 _s2).[k]) /\
        (* w0 = LowBits(Ay), coefficients in [-gamma2, gamma2] *)
        wpolykvec_srng (kvec_unflatten256 _w0) gamma2 gamma2
        ==>
        (res.`2 = W64.zero \/ res.`2 = W64.one) /\
        (* Biconditional: failure bit is zero iff no prior failure AND
           the abstract cs2-norm check holds. *)
        (res.`2 = W64.zero <=>
           _incr = W64.zero /\
           PolyKVec.infnorm_lt
             (lifts_wpolykvec (kvec_unflatten256 _w0) -
              PolyKVec.psmul (lifts_wpoly _c) (lifts_wpolykvec (kvec_unflatten256 _s2)))
             (gamma2 - Beta)) /\
        (res.`2 = W64.zero =>
           (* ||w0 - cs2||_inf < gamma2 - Beta *)
           wpolykvec_infnorm_lt (gamma2 - Beta) (kvec_unflatten256 res.`1) /\
           lifts_wpolykvec (kvec_unflatten256 res.`1) =
             (lifts_wpolykvec (kvec_unflatten256 _w0)) -
             (PolyKVec.psmul (lifts_wpoly _c) (lifts_wpolykvec (kvec_unflatten256 _s2))))
    ].
proof.
have kvec_val := gt0_k.
have gamma2_val := gamma2_cases.
have tau_val := tau_bound.
have eta_val := eta_bound.
proc => /=.
case (infinity_norm_check_result <> zero).
+ rcondt ^if;1: by auto.
  rcondf ^while;1: by auto.
  by auto => /#.
  
conseq (: _ ==>
  (infinity_norm_check_result = zero \/ infinity_norm_check_result = one) /\
  (infinity_norm_check_result = zero <=>
   PolyKVec.infnorm_lt
     (lifts_wpolykvec (kvec_unflatten256 _w0) -
      PolyKVec.psmul (lifts_wpoly _c) (lifts_wpolykvec (kvec_unflatten256 _s2)))
     (gamma2 - Beta)) /\
  (infinity_norm_check_result = zero =>
   (wpolykvec_infnorm_lt (gamma2 - Beta) (kvec_unflatten256 w0_minus_cs2) /\
   lifts_wpolykvec (kvec_unflatten256 w0_minus_cs2) =
   lifts_wpolykvec (kvec_unflatten256 _w0) -
   PolyKVec.psmul (lifts_wpoly _c) (lifts_wpolykvec (kvec_unflatten256 _s2)))));
 1: by move => |> &hr ?? infncr rr *; rewrite H_incr /=;
       smt(W64.to_uint_eq pow2_64 W64.to_uintK W64.of_uintK).

rcondf ^if; 1: by auto.
while (#{/~_incr}{~infinity_norm_check_result}{~w0_minus_cs2}pre /\
       _incr = W64.zero /\
       (infinity_norm_check_result = zero \/ infinity_norm_check_result = one) /\
       0 <= base <= kvec * n /\ base %% n = 0 /\
       (infinity_norm_check_result <> zero => base = kvec * n) /\
       (infinity_norm_check_result <> zero =>
         ! PolyKVec.infnorm_lt
             (lifts_wpolykvec (kvec_unflatten256 _w0) -
              PolyKVec.psmul (lifts_wpoly _c) (lifts_wpolykvec (kvec_unflatten256 _s2)))
             (gamma2 - Beta)) /\
      (
       infinity_norm_check_result = zero =>
       ((forall k, 0 <= k < base %/ n =>
           wpoly_srng (gamma2 - Beta - 1) (gamma2 - Beta - 1) ((kvec_unflatten256 w0_minus_cs2)).[k]) /\
       (forall k, 0 <= k < base %/ n =>
         (lifts_wpolykvec (kvec_unflatten256 w0_minus_cs2)).[k] =
         (lifts_wpolykvec (kvec_unflatten256 _w0) -
         PolyKVec.psmul (lifts_wpoly _c) (lifts_wpolykvec (kvec_unflatten256 _s2))).[k]))
      )
      ); last first.

+ auto => /> H_incr' H01 *; do split; 1..3: smt().
  move =>  ?? bs ?????? H_fail H_srng ; do split; 2: by smt().
  +   move => Hzero.
      have [Hsrng Hlifts] := H_srng Hzero.
      have Hwpkv : wpolykvec_infnorm_lt (gamma2 - Beta) (kvec_unflatten256 bs)
        by rewrite /wpolykvec_infnorm_lt /wpolykvec_srng allP => *; smt(gt0_k).
      have Hleq : lifts_wpolykvec (kvec_unflatten256 bs) =
          lifts_wpolykvec (kvec_unflatten256 _w0) -
          PolyKVec.psmul (lifts_wpoly _c) (lifts_wpolykvec (kvec_unflatten256 _s2))
        by apply KArray.tP => *; smt(gt0_k).
      rewrite -Hleq.
      by apply (wpolykvec_infnorm_liftE (gamma2 - Beta)); smt(gamma2_cases beta_gamma2_lt gt0_beta).

  +   move => Hzero.
      have [Hsrng Hlifts] := H_srng Hzero.
      have Hwpkv : wpolykvec_infnorm_lt (gamma2 - Beta) (kvec_unflatten256 bs)
        by rewrite /wpolykvec_infnorm_lt /wpolykvec_srng allP => *; smt(gt0_k).
      have Hleq : lifts_wpolykvec (kvec_unflatten256 bs) =
          lifts_wpolykvec (kvec_unflatten256 _w0) -
          PolyKVec.psmul (lifts_wpoly _c) (lifts_wpolykvec (kvec_unflatten256 _s2))
        by apply KArray.tP => *; smt(gt0_k).
      rewrite -Hleq.
      by smt().

(* ── Loop body: one row at index i = base %/ n ──────────────────────── *)

seq 3 : (#pre /\
    lifts_wpoly (Array256.init (fun i => w0_minus_cs2.[base + i])) =
      (lifts_wpolykvec (kvec_unflatten256 _w0) -
       PolyKVec.psmul (lifts_wpoly _c) (lifts_wpolykvec (kvec_unflatten256 _s2))).[base %/ n] /\
    (* coefficients are centered representatives: to_sint = crepr *)
    wpoly_srng 6283009 6283008
               (Array256.init (fun i => w0_minus_cs2.[base + i])) /\
    (wpoly_infnorm_lt (gamma2 - Beta) (Array256.init (fun i => w0_minus_cs2.[base + i])) =>
       aux_0 = W64.zero) /\
    (!wpoly_infnorm_lt (gamma2 - Beta) (Array256.init (fun i => w0_minus_cs2.[base + i])) =>
       aux_0 = W64.one)).
+ (* Loop body: sparse product → subtract, reduce32 and test → writeback. *)
  wp.
  ecall (RC.polynomial____subtract_reduce32_check_infinity_norm_correct
           (Array256.init (fun i => w0_minus_cs2.[base + i]))
           (Array256.init (fun i => w0.[base + i]))
           cs2 gamma2 (tau * Eta) (gamma2 - Beta)).
  ecall (polynomial____sparse_multiply_16_correct
           (Array256.init (fun i => s2_doubled.[base + i]))
           challenge_positions
           (Array256.init (fun i => _s2.[base + i]))
           _c).
  auto => |> &hr Hc Hsh Hpos Hs2_rng Hs2d Hw0_srng ?????? HH*.
  have Hkb : 0 <= base{hr} %/ n < kvec by smt(gt0_k).
  have Heq_s2 : (kvec_unflatten256 _s2).[base{hr} %/ n] =
                Array256.init (fun i => _s2.[base{hr} + i]).
  + by apply kvec_slice_eq; smt(gt0_k).
  have Heq_s2d : (kvec_unflatten256 _s2d).[base{hr} %/ n] =
                 Array256.init (fun i => _s2d.[base{hr} + i]).
  + by apply kvec_slice_eq; smt(gt0_k).
  split.
  (* ── sparse product pre: s2 slice range and doubling ── *)
  + rewrite -Heq_s2 -Heq_s2d; split; last by apply Hs2d.
    by move: Hs2_rng; rewrite /wpolykvec_srng allP => H; apply H.
  move => _ _ result Hres_eq Hres_rng.
  (* ── fused pass pre: w0 slice range ── *)
  have Heq_w0 : (kvec_unflatten256 _w0).[base{hr} %/ n] =
                Array256.init (fun i => _w0.[base{hr} + i]).
  + by apply kvec_slice_eq; smt(gt0_k).
  have Hw0_slice : wpoly_srng gamma2 gamma2 (Array256.init (fun i => _w0.[base{hr} + i])).
  + rewrite -Heq_w0; move: Hw0_srng; rewrite /wpolykvec_srng allP => H.
    move: (H (base{hr} %/ n) _); 1: smt(gt0_k).
    rewrite /wpoly_srng !allP => H2 j Hj; have := H2 j Hj; smt(gamma2_cases beta_gamma2_lt gt0_beta).
  split.
  + split; 1: smt(gamma2_cases beta_gamma2_lt gt0_beta).
    split; 1: exact Hw0_slice.
    by have := beta_gamma2_lt; rewrite /Beta; smt(gamma2_cases).
  move => _ _ _ _ _ r1 Hr1_eq Hr1_rng Hpass Hfail.
  (* The writeback slice simplifies to the pass output *)
  have Hwb_slice : (Array256.init (fun i =>
      (Array_kpolys.init (fun i0 =>
        if base{hr} <= i0 < base{hr} + n then r1.`1.[i0 - base{hr}]
        else w0_minus_cs2{hr}.[i0])).[base{hr} + i])) = r1.`1.
  + by apply kvec_writeback_slice_eq; smt().
  do split.
  - (* invariant: old rows preserved for k < base/n *)
    move => Hinfz; have [HH1 HH2] := HH _; 1: smt().
    have Hmod : base{hr} %% 256 = 0 by smt().
    have Hslice_eq : forall k, 0 <= k < base{hr} %/ n =>
        (kvec_unflatten256 (Array_kpolys.init (fun (i : int) =>
          if base{hr} <= i < base{hr} + n then r1.`1.[i - base{hr}]
          else w0_minus_cs2{hr}.[i]))).[k] =
        (kvec_unflatten256 w0_minus_cs2{hr}).[k].
    + move => k [hk0 hk1]; have Hk : 0 <= k < kvec by smt(gt0_k).
      by rewrite (kvec_unflatten256_writeback_iE w0_minus_cs2{hr} r1.`1 base{hr} k Hmod Hk) ifF //#.
    split; move => k hk1 hk2.
    + have Hk_eq := Hslice_eq k _; 1: smt().
      have HH1k := HH1 k _; 1: smt().
      by rewrite Hk_eq; exact HH1k.
    + have Hk_eq := Hslice_eq k _; 1: smt().
      have HH2k := HH2 k _; 1: smt().
      rewrite /lifts_wpolykvec !mapiE 1:/# /= Hk_eq.
      by rewrite -(HH2k) /lifts_wpolykvec !mapiE 1:/# /=; smt(gt0_k).
  - (* new row: lifts = spec *)
    rewrite Hwb_slice Hr1_eq Hres_eq.
    rewrite polykvec_sub_iE 1:/#.
    have Hw0_kvec : lifts_wpoly (Array256.init (fun i => _w0.[base{hr} + i])) =
        (lifts_wpolykvec (kvec_unflatten256 _w0)).[base{hr} %/ 256].
    + by apply lifts_wpolykvec_slice; smt(gt0_k).
    have Hs2_kvec : lifts_wpoly (Array256.init (fun i => _s2.[base{hr} + i])) =
        (lifts_wpolykvec (kvec_unflatten256 _s2)).[base{hr} %/ 256].
    + by apply lifts_wpolykvec_slice; smt(gt0_k).
    by rewrite -Hw0_kvec /PolyKVec.psmul KArray.mapiE 1:/# /= -Hs2_kvec Rq_mulC.
  - by rewrite Hwb_slice.
  - by rewrite Hwb_slice.
  - by rewrite Hwb_slice.

(* ── The flag and the base update ── *)
wp; skip => |> &hr 11? H H0 H1 H2 H3 Ht Hf.
move: (aux_0{hr}) Ht Hf => rr Ht Hf.
case (rr = W64.zero) => Hrr /=.
+ (* norm passed: rr = zero, new_incr = zero, update invariant *)
  do split; 1..3: smt().
  + move => k ??; case (k < base{hr} %/ n) => ?;1: by smt().
    have : wpoly_infnorm_lt (gamma2 - Beta)
             (init (fun (i : int) => w0_minus_cs2{hr}.[base{hr} + i]))
      by smt(W64.to_uint_eq W64.of_uintK W64.to_uintK pow2_64).
    rewrite /wpoly_infnorm_lt  /wpoly_srng !allP /= /kvec_unflatten256 => Hr kk kkb.
    rewrite initiE 1:/# /= get_of_list 1:/# /= nth_sub 1:/# /=.
    have := Hr kk _;1:smt().
    by rewrite initiE 1:/# /= /#.
  + move => k kb ?; case (k < base{hr} %/ n) => ?;1: by smt().
    have -> : k = base{hr} %/ n by smt().
    rewrite -H2 /lifts_wpolykvec mapiE 1:/#;congr;rewrite initiE 1:/# /= tP => j jb.
    by rewrite get_of_list 1:/# nth_sub 1:/# initiE 1:/# /= /#.
(* norm failed: rr = one, propagate (!infnorm_lt) *)
have Hnwpoly : !wpoly_infnorm_lt (gamma2 - Beta)
    (init (fun (i : int) => w0_minus_cs2{hr}.[base{hr} + i]))
  by apply /negP => Hwpoly; smt().
have Hninfnorm : !infnorm_lt
    (lifts_wpoly (init (fun (i : int) => w0_minus_cs2{hr}.[base{hr} + i])))
    (gamma2 - Beta).
+ apply /negP => Hcontra; apply Hnwpoly.
  apply (wpoly_infnorm_unliftE (gamma2 - Beta) 6283009 6283008
           (Array256.init (fun (i : int) => w0_minus_cs2{hr}.[base{hr} + i]))).
  + smt(gamma2_cases beta_gamma2_lt gt0_beta).
  + smt().
  + smt().
  + exact H3.
  + exact Hcontra.
split; 1: smt().
split; 1: smt(gt0_k).
split; 1: by rewrite modzMl.
apply /negP => Hkvec; apply Hninfnorm; rewrite H2.
move: Hkvec; rewrite /infnorm_lt allP => Hk.
apply (Hk (base{hr} %/ n)).
by rewrite mem_iota /=; smt(gt0_k).
qed.

lemma __apply_cs2_and_check_norm_ph
      (_w0mc : W32.t Array_kpolys.t) (_w0 : W32.t Array_kpolys.t)
      (_s2d _s2 : W32.t Array_kpolys.t) (_c : W32.t Array256.t)
      (_pos : W32.t Array_tau1.t) (_incr : W64.t)
      :
    phoare [ M.__apply_cs2_and_check_norm :
        w0_minus_cs2 = _w0mc /\ w0 = _w0 /\ s2_doubled = _s2d /\
        challenge_positions = _pos /\ infinity_norm_check_result = _incr /\
        (_incr = W64.zero \/ _incr = W64.one) /\
        wpoly_srng 1 1 _c /\ challenge_shape (lifts_wpoly _c) /\
        positions_of _pos (lifts_wpoly _c) /\
        wpolykvec_srng (kvec_unflatten256 _s2) Eta Eta /\
        (forall k, 0 <= k < kvec =>
           doubled16_of (kvec_unflatten256 _s2d).[k] (kvec_unflatten256 _s2).[k]) /\
        (* w0 = LowBits(Ay), coefficients in [-gamma2, gamma2] *)
        wpolykvec_srng (kvec_unflatten256 _w0) gamma2 gamma2
        ==>
        (res.`2 = W64.zero \/ res.`2 = W64.one) /\
        (* Biconditional: failure bit is zero iff no prior failure AND
           the abstract cs2-norm check holds. *)
        (res.`2 = W64.zero <=>
           _incr = W64.zero /\
           PolyKVec.infnorm_lt
             (lifts_wpolykvec (kvec_unflatten256 _w0) -
              PolyKVec.psmul (lifts_wpoly _c) (lifts_wpolykvec (kvec_unflatten256 _s2)))
             (gamma2 - Beta)) /\
        (res.`2 = W64.zero =>
           (* ||w0 - cs2||_inf < gamma2 - Beta *)
           wpolykvec_infnorm_lt (gamma2 - Beta) (kvec_unflatten256 res.`1) /\
           lifts_wpolykvec (kvec_unflatten256 res.`1) =
             (lifts_wpolykvec (kvec_unflatten256 _w0)) -
             (PolyKVec.psmul (lifts_wpoly _c) (lifts_wpolykvec (kvec_unflatten256 _s2))))
    ] = 1%r.
proof.
by conseq __apply_cs2_and_check_norm_ll
          (__apply_cs2_and_check_norm_correct _w0mc _w0 _s2d _s2 _c _pos _incr).
qed.

(* The compile-time guard of the c t0 test: the test is only compiled when
   tau 2^(d-1) can reach gamma2 (ML-DSA-44); the model keeps it as a test on
   the parameters. *)
(* |c * v|_inf <= ||c||_1 * ||v||_inf (convolution theorem + conv_coeff_bnd),
   the generalisation of VecMat.cs2_norm_bound used for c t0: with
   |t0|_inf <= 2^(d-1) the product is below tau 2^(d-1), which is below gamma2
   for ML-DSA-65 and ML-DSA-87 (the test on c t0 is not compiled there). *)
lemma smul_norm_bound (c : poly) (v : polykvec) (B : int) :
    0 <= B => l1 c <= tau =>
    PolyKVec.infnorm_lt v (B + 1) =>
    PolyKVec.infnorm_lt (PolyKVec.psmul c v) (tau * B + 1).
proof.
move=> hB hc hv; rewrite -PolyKVec.invnttv_ntt_smul /PolyKVec.infnorm_lt allP => k /mem_iota rgk /=.
rewrite allP => j /mem_iota rgj /=.
rewrite PolyKVec.invnttv_ntt_smul_k 1:/# /PolyKVec.nttv mapiE 1:/# /= conv Rq_mulC.
have hvk : forall i, 0 <= i < 256 => `|v.[k].[i]| <= B.
- move=> i rgi; move: hv; rewrite /PolyKVec.infnorm_lt allP => /(_ k _); 1: by rewrite mem_iota /#.
  by rewrite /= allP => /(_ i _) /=; [rewrite mem_iota /# | smt()].
have := conv_coeff_bnd c v.[k] B j _ hvk; 1: smt().
have : l1 c * B <= tau * B by apply StdOrder.IntOrder.ler_wpmul2r.
smt().
qed.

(* ================================================================== *)
(* __apply_ct0_and_check_norm                                          *)
(* Called third; incr = result of the z and cs2 checks (0 or 1).     *)
(* Computes ct0 per row (kvec rows), adds it to w0_minus_cs2 in every *)
(* case, and checks infnorm < gamma2 only when the test is compiled    *)
(* (gamma2 <= tau 2^(d-1), ML-DSA-44). Returns the ct0 flag alone.     *)
(* Spec: ct0 = invnttv (ntt_smul ch t0h) = psmul c t0;               *)
(* output = w0mc + ct0                                                *)
(* ================================================================== *)

lemma __apply_ct0_and_check_norm_ll : islossless M.__apply_ct0_and_check_norm.
proof.
proc.
wp; while (0 <= base <= kvec * n /\ base %% n = 0) (kvec * n - base); last by auto; smt(gt0_k).
move => ?.
wp; call RC.polynomial____add_reduce32_check_infinity_norm_rhs_ll.
wp; call polynomial____sparse_multiply_32_ll.
by auto => /#.
qed.

lemma __apply_ct0_and_check_norm_correct
      (_r : W32.t Array_kpolys.t) (_w0mc : W32.t Array_kpolys.t)
      (_t0d : W32.t Array_kpolys2.t) (_t0 : W32.t Array_kpolys.t)
      (_c : W32.t Array256.t) (_pos : W32.t Array_tau1.t)
      (_incr : W64.t)
      :
    hoare [ M.__apply_ct0_and_check_norm :
        w0_minus_cs2_plus_ct0 = _r /\ w0_minus_cs2 = _w0mc /\
        t0_doubled = _t0d /\ challenge_positions = _pos /\
        infinity_norm_check_result = _incr /\
        (_incr = W64.zero \/ _incr = W64.one) /\
        wpoly_srng 1 1 _c /\ challenge_shape (lifts_wpoly _c) /\
        positions_of _pos (lifts_wpoly _c) /\
        (* t0 = Power2Round's low part, in (-2^(d-1), 2^(d-1)] *)
        wpolykvec_srng (kvec_unflatten256 _t0) 4095 4096 /\
        (forall k, 0 <= k < kvec =>
           doubled32_of (kvec_slice512 _t0d k) (kvec_unflatten256 _t0).[k]) /\
        (* only needed when _incr = 0 (loop runs): w0mc passed cs2 norm check *)
        (_incr = W64.zero =>
          wpolykvec_infnorm_lt (gamma2 - Beta) (kvec_unflatten256 _w0mc))
        ==>
        (res.`2 = W64.zero \/ res.`2 = W64.one) /\
        (* skipped after a prior failure: nothing computed, flag 0 *)
        (_incr <> W64.zero => res.`2 = W64.zero /\ res.`1 = _r) /\
        (_incr = W64.zero =>
           let ct0 = PolyKVec.psmul (lifts_wpoly _c) (lifts_wpolykvec (kvec_unflatten256 _t0)) in
           (* The flag is the abstract ct0-norm check when the test is
              compiled (gamma2 <= tau 2^(d-1)), and 0 otherwise. *)
           (res.`2 = W64.zero <=>
              (tau * 4096 < gamma2 \/ PolyKVec.infnorm_lt ct0 gamma2)) /\
           (* c t0 is always added to w0 - c s2 (the hint needs it) *)
           lifts_wpolykvec (kvec_unflatten256 res.`1) =
             (lifts_wpolykvec (kvec_unflatten256 _w0mc)) + ct0 /\
           (* word-level range: reduce32 output plus the cs2 range... *)
           wpolykvec_srng (kvec_unflatten256 res.`1)
             (gamma2 - Beta - 1 + 6283009) (gamma2 - Beta - 1 + 6283009) /\
           (* ... and the tight range when ||c t0||_inf < gamma2 *)
           (PolyKVec.infnorm_lt ct0 gamma2 =>
              wpolykvec_srng (kvec_unflatten256 res.`1)
                (2*gamma2 - Beta - 2) (2*gamma2 - Beta - 2)))
    ].
proof.
have kvec_val := gt0_k.
have gamma2_val := gamma2_cases.
have tau_val  := tau_bound.
have eta_val  := eta_bound.
proc => /=.
case (infinity_norm_check_result <> zero).
+ rcondt ^if; 1: by auto.
  rcondf ^while; 1: by auto.
  by auto => /#.
rcondf ^if; 1: by auto.
wp.
while (
  _incr = zero /\ w0_minus_cs2 = _w0mc /\ t0_doubled = _t0d /\ challenge_positions = _pos /\
  wpoly_srng 1 1 _c /\ challenge_shape (lifts_wpoly _c) /\ positions_of _pos (lifts_wpoly _c) /\
  wpolykvec_srng (kvec_unflatten256 _t0) 4095 4096 /\
  (forall k, 0 <= k < kvec =>
     doubled32_of (kvec_slice512 _t0d k) (kvec_unflatten256 _t0).[k]) /\
  wpolykvec_infnorm_lt (gamma2 - Beta) (kvec_unflatten256 _w0mc) /\
  (ct0_norm_check_result = zero \/ ct0_norm_check_result = one) /\
  0 <= base <= kvec * n /\ base %% n = 0 /\
  (let ct0 = PolyKVec.psmul (lifts_wpoly _c) (lifts_wpolykvec (kvec_unflatten256 _t0)) in
   (ct0_norm_check_result = zero <=>
      (tau * 4096 < gamma2 \/ forall k, 0 <= k < base %/ n => infnorm_lt ct0.[k] gamma2)) /\
   (forall k, 0 <= k < base %/ n =>
      wpoly_srng (gamma2 - Beta + 6283008) (gamma2 - Beta + 6283008)
                 (kvec_unflatten256 w0_minus_cs2_plus_ct0).[k]) /\
   (forall k, 0 <= k < base %/ n => infnorm_lt ct0.[k] gamma2 =>
      wpoly_srng (2*gamma2 - Beta - 2) (2*gamma2 - Beta - 2)
                 (kvec_unflatten256 w0_minus_cs2_plus_ct0).[k]) /\
   (forall k, 0 <= k < base %/ n =>
      (lifts_wpolykvec (kvec_unflatten256 w0_minus_cs2_plus_ct0)).[k] =
      (lifts_wpolykvec (kvec_unflatten256 _w0mc)).[k] &+ ct0.[k]))
); last first.
(* ── Initialisation and loop exit ──────────────────────────────── *)
+ auto => /> *; split; 1: smt().
  move => bs r w0 Hexit Hw0mc Hbit Hb0 Hb1 Hbmod Hiff Hwide Htight Heq.
  have Hbs : bs %/ n = kvec by smt().
  do split.
  + move => Hz; case (tau * 4096 < gamma2) => //= Hg.
    have := Hiff; rewrite Hz /= Hg /= => Hall.
    rewrite /infnorm_lt allP => k Hk; have := Hall k _; 1: smt(mem_iota gt0_k).
    by rewrite /infnorm_lt.
  + move => [Hg | Hall]; 1: smt().
    rewrite Hiff; right => k Hk.
    move: Hall; rewrite /infnorm_lt allP => H; have := H k _; 1: smt(mem_iota gt0_k).
    by rewrite /infnorm_lt.
  + apply KArray.tP => ii iib.
    have -> := Heq ii _; 1: smt().
    by rewrite polykvec_add_iE 1:/#.
  + rewrite /wpolykvec_srng allP => k kb.
    by apply Hwide; smt().
  + move => Hinf; rewrite /wpolykvec_srng allP => k kb.
    apply Htight; 1: smt().
    move: Hinf; rewrite /infnorm_lt allP => H; have := H k _; 1: smt(mem_iota gt0_k).
    by rewrite /infnorm_lt.

(* ── Loop body: one column at index base %/ n ──────────────────────── *)
(* Jasmin: sparse product c t0 on the doubled t0 slice (exact)
           → one pass: w0mc_slice + reduce32(ct0), with the norm test of
             reduce32(ct0) when compiled → writeback
           → if (compiled) { flag |= row } → base += 256                     *)

(* ══ Phase 1: ct0 = c t0 by the sparse product ══ *)
seq 2 : (#pre /\
    lifts_wpoly ct0 =
      (PolyKVec.psmul (lifts_wpoly _c) (lifts_wpolykvec (kvec_unflatten256 _t0))).[base %/ n] /\
    wpoly_srng (tau * 4096) (tau * 4096) ct0).
+ ecall (polynomial____sparse_multiply_32_correct
           (Array512.init (fun i => t0_doubled.[base * 2 + i]))
           challenge_positions
           (Array256.init (fun i => _t0.[base + i]))
           _c).
  auto => |> &hr Hc Hsh Hpos Ht0 Ht0d *.
  have Hkb : 0 <= base{hr} %/ n < kvec by smt(gt0_k).
  have Heq_t0 : (kvec_unflatten256 _t0).[base{hr} %/ n] =
                Array256.init (fun i => _t0.[base{hr} + i]).
  + by apply kvec_slice_eq; smt(gt0_k).
  have Heq_t0d : Array512.init (fun i => _t0d.[base{hr} * 2 + i]) =
                 kvec_slice512 _t0d (base{hr} %/ n).
  + by rewrite /kvec_slice512 (_ : 512 * (base{hr} %/ n) = base{hr} * 2) 1:/#.
  split.
  + rewrite Heq_t0d -Heq_t0; split; last by apply Ht0d.
    by move: Ht0; rewrite /wpolykvec_srng allP => H; apply H.
  move => _ _ result Hres_eq _.
  rewrite Hres_eq /PolyKVec.psmul KArray.mapiE 1:/# /=.
  by rewrite -(lifts_wpolykvec_slice _t0 base{hr}) 1:/# 1:/# Rq_mulC.

(* ══ Phase 2: the fused pass, then the guarded flag update ══ *)
wp.
ecall (RC.polynomial____add_reduce32_check_infinity_norm_rhs_correct
         (Array256.init (fun i => w0_minus_cs2_plus_ct0.[base + i]))
         (Array256.init (fun i => w0_minus_cs2.[base + i]))
         ct0 (gamma2 - Beta - 1) gamma2 (tau * 4096)).
auto => |> &hr.
move=> Hc Hsh Hpos Ht0 Ht0d Hw0mc Hbit Hb0 Hb1 Hbmod Hiff Hwide Htight Heq Hbl Hct0eq Hct0rng.
have Hct0w : wpoly_srng 2143289343 2143289343 ct0{hr}.
+ by apply (wpoly_srng_widen _ (tau * 4096) (tau * 4096)); 3: exact Hct0rng; smt(tau_bound).
have [Hred_eq Hred_rng] := RC.reduce32_polyE ct0{hr} Hct0w.
have Hkb : 0 <= base{hr} %/ 256 < kvec by smt(gt0_k).
have Hw0slice : wpoly_srng (gamma2 - Beta - 1) (gamma2 - Beta - 1)
                  (Array256.init (fun i => _w0mc.[base{hr} + i])).
+ have Heq_slice : (kvec_unflatten256 _w0mc).[base{hr} %/ n] =
                   Array256.init (fun i => _w0mc.[base{hr} + i]).
  + by apply kvec_slice_eq; smt(gt0_k).
  move: Hw0mc; rewrite /wpolykvec_infnorm_lt /wpolykvec_srng allP => H.
  by rewrite -Heq_slice; apply H.
split.
+ do split; 1,2,5,6: smt(gamma2_cases beta_gamma2_lt gt0_beta).
  + exact Hw0slice.
  exact Hct0w.
move=> Hg2 Hbnd _ _ _ _ _ _ r Hr_eq Hr_rng Htested Huntested.
rewrite Hg2 Hbnd.
(* the test of the reduced c t0 is the abstract one on the column *)
have Hinf : wpoly_infnorm_lt gamma2 (RC.reduce32_poly ct0{hr}) <=>
            infnorm_lt (PolyKVec.psmul (lifts_wpoly _c) (lifts_wpolykvec (kvec_unflatten256 _t0))).[base{hr} %/ n] gamma2.
+ split => H.
  + rewrite -Hct0eq -Hred_eq.
    by apply (wpoly_infnorm_liftE gamma2 _); [smt(gamma2_cases) | exact H].
  apply (wpoly_infnorm_unliftE gamma2 6283009 6283008 _); 1..3: smt(gamma2_cases).
  + exact Hred_rng.
  by rewrite Hred_eq Hct0eq.
have Hmod : base{hr} %% 256 = 0 by smt().
have Hbn : (base{hr} + n) %/ n = base{hr} %/ n + 1 by smt().
have Hwb := kvec_unflatten256_writeback_iE w0_minus_cs2_plus_ct0{hr} r.`1 base{hr}.
(* the columns after the writeback: wide range, tight range, value *)
have Hcw : forall k, 0 <= k => k < (base{hr} + n) %/ n =>
    wpoly_srng (gamma2 - Beta + 6283008) (gamma2 - Beta + 6283008)
      (kvec_unflatten256 (Array_kpolys.init (fun i =>
         if base{hr} <= i < base{hr} + n then r.`1.[i - base{hr}]
         else w0_minus_cs2_plus_ct0{hr}.[i]))).[k].
+ move=> k hk0 hk1; have Hk : 0 <= k < kvec by smt(gt0_k).
  rewrite (Hwb k Hmod Hk); case (k = base{hr} %/ n) => Hkk /=; last by apply Hwide; smt().
  have := Hr_rng 6283009 _ _; 1: smt().
  + by apply (wpoly_srng_widen _ 6283009 6283008).
  by rewrite (_ : gamma2 - Beta - 1 + 6283009 = gamma2 - Beta + 6283008) 1:/#.
have Hct : forall k, 0 <= k => k < (base{hr} + n) %/ n =>
    infnorm_lt (PolyKVec.psmul (lifts_wpoly _c) (lifts_wpolykvec (kvec_unflatten256 _t0))).[k] gamma2 =>
    wpoly_srng (2 * gamma2 - Beta - 2) (2 * gamma2 - Beta - 2)
      (kvec_unflatten256 (Array_kpolys.init (fun i =>
         if base{hr} <= i < base{hr} + n then r.`1.[i - base{hr}]
         else w0_minus_cs2_plus_ct0{hr}.[i]))).[k].
+ move=> k hk0 hk1 Hki; have Hk : 0 <= k < kvec by smt(gt0_k).
  rewrite (Hwb k Hmod Hk); case (k = base{hr} %/ n) => Hkk /=; last by apply Htight; smt().
  have Hrw : wpoly_infnorm_lt gamma2 (RC.reduce32_poly ct0{hr}) by rewrite Hinf -Hkk.
  have := Hr_rng (gamma2 - 1) _ Hrw; 1: smt(gamma2_cases).
  by rewrite (_ : gamma2 - Beta - 1 + (gamma2 - 1) = 2 * gamma2 - Beta - 2) 1:/#.
have Hcl : forall k, 0 <= k => k < (base{hr} + n) %/ n =>
    (lifts_wpolykvec (kvec_unflatten256 (Array_kpolys.init (fun i =>
         if base{hr} <= i < base{hr} + n then r.`1.[i - base{hr}]
         else w0_minus_cs2_plus_ct0{hr}.[i])))).[k] =
    (lifts_wpolykvec (kvec_unflatten256 _w0mc)).[k] &+
    (PolyKVec.psmul (lifts_wpoly _c) (lifts_wpolykvec (kvec_unflatten256 _t0))).[k].
+ move=> k hk0 hk1; have Hk : 0 <= k < kvec by smt(gt0_k).
  rewrite /lifts_wpolykvec mapiE 1:/# /= (Hwb k Hmod Hk).
  case (k = base{hr} %/ n) => Hkk /=.
  + rewrite Hr_eq (lifts_wpolykvec_slice _w0mc base{hr}) 1:/# 1:/#.
    by rewrite Hct0eq Hkk /lifts_wpolykvec mapiE 1:/#.
  have := Heq k _; 1: smt().
  by rewrite /lifts_wpolykvec !mapiE 1,2:/#.
split => Hguard.
+ (* the test is compiled: gamma2 <= tau 2^(d-1) *)
  have [Hp Hf] := Htested Hguard.
  have Hrow : (r.`2 = zero) <=>
      infnorm_lt (PolyKVec.psmul (lifts_wpoly _c) (lifts_wpolykvec (kvec_unflatten256 _t0))).[base{hr} %/ n] gamma2.
  + rewrite -Hinf; case: (wpoly_infnorm_lt gamma2 (RC.reduce32_poly ct0{hr})) => H.
    + by rewrite (Hp H).
    by rewrite (Hf H) /=.
  have Hr01 : r.`2 = zero \/ r.`2 = one by smt().
  have Hor0 : (ct0_norm_check_result{hr} `|` r.`2 = zero) <=>
              (ct0_norm_check_result{hr} = zero /\ r.`2 = zero) by smt(or64_ne0).
  do split; 2..4: smt().
  + smt(W64.or0w W64.orw0 W64.orwK).
  + rewrite Hor0 => -[H0 Hr0]; right => k Hk.
    case (k = base{hr} %/ n) => Hkk; 1: by rewrite Hkk -Hrow.
    have := Hiff; rewrite H0 /= => -[|Hall]; 1: smt().
    by apply Hall; smt().
  + move => Hall; rewrite Hor0; split.
    + rewrite Hiff; right => k Hk; case Hall => [|H]; 1: smt(); by apply H; smt().
    + rewrite Hrow; case Hall => [|H]; 1: smt(); by apply H; smt().
  + exact Hcw.
  + exact Hct.
  exact Hcl.
(* the test is not compiled: tau 2^(d-1) < gamma2, the flag stays 0 *)
do split; 1..3: smt().
+ by move=> _; left; smt().
+ by move=> _; rewrite Hiff; left; smt().
+ exact Hcw.
+ exact Hct.
exact Hcl.
qed.

lemma __apply_ct0_and_check_norm_ph
      (_r : W32.t Array_kpolys.t) (_w0mc : W32.t Array_kpolys.t)
      (_t0d : W32.t Array_kpolys2.t) (_t0 : W32.t Array_kpolys.t)
      (_c : W32.t Array256.t) (_pos : W32.t Array_tau1.t)
      (_incr : W64.t)
      :
    phoare [ M.__apply_ct0_and_check_norm :
        w0_minus_cs2_plus_ct0 = _r /\ w0_minus_cs2 = _w0mc /\
        t0_doubled = _t0d /\ challenge_positions = _pos /\
        infinity_norm_check_result = _incr /\
        (_incr = W64.zero \/ _incr = W64.one) /\
        wpoly_srng 1 1 _c /\ challenge_shape (lifts_wpoly _c) /\
        positions_of _pos (lifts_wpoly _c) /\
        (* t0 = Power2Round's low part, in (-2^(d-1), 2^(d-1)] *)
        wpolykvec_srng (kvec_unflatten256 _t0) 4095 4096 /\
        (forall k, 0 <= k < kvec =>
           doubled32_of (kvec_slice512 _t0d k) (kvec_unflatten256 _t0).[k]) /\
        (* only needed when _incr = 0 (loop runs): w0mc passed cs2 norm check *)
        (_incr = W64.zero =>
          wpolykvec_infnorm_lt (gamma2 - Beta) (kvec_unflatten256 _w0mc))
        ==>
        (res.`2 = W64.zero \/ res.`2 = W64.one) /\
        (* skipped after a prior failure: nothing computed, flag 0 *)
        (_incr <> W64.zero => res.`2 = W64.zero /\ res.`1 = _r) /\
        (_incr = W64.zero =>
           let ct0 = PolyKVec.psmul (lifts_wpoly _c) (lifts_wpolykvec (kvec_unflatten256 _t0)) in
           (* The flag is the abstract ct0-norm check when the test is
              compiled (gamma2 <= tau 2^(d-1)), and 0 otherwise. *)
           (res.`2 = W64.zero <=>
              (tau * 4096 < gamma2 \/ PolyKVec.infnorm_lt ct0 gamma2)) /\
           (* c t0 is always added to w0 - c s2 (the hint needs it) *)
           lifts_wpolykvec (kvec_unflatten256 res.`1) =
             (lifts_wpolykvec (kvec_unflatten256 _w0mc)) + ct0 /\
           (* word-level range: reduce32 output plus the cs2 range... *)
           wpolykvec_srng (kvec_unflatten256 res.`1)
             (gamma2 - Beta - 1 + 6283009) (gamma2 - Beta - 1 + 6283009) /\
           (* ... and the tight range when ||c t0||_inf < gamma2 *)
           (PolyKVec.infnorm_lt ct0 gamma2 =>
              wpolykvec_srng (kvec_unflatten256 res.`1)
                (2*gamma2 - Beta - 2) (2*gamma2 - Beta - 2)))
    ] = 1%r.
proof.
by conseq __apply_ct0_and_check_norm_ll (__apply_ct0_and_check_norm_correct _r _w0mc _t0d _t0 _c _pos _incr).
qed.

lemma __compute_z_and_check_norm_ll : islossless M.__compute_z_and_check_norm.
proof.
proc.
wp; while (0 <= base <= lvec * n /\ base %% n = 0) (lvec * n - base); last by auto; smt(gt0_l).
move => ?.
wp; call __compute_signer_response_element_ll.
by auto => /#.
qed.

lemma __compute_z_and_check_norm_correct
      (_s1d _s1 : W32.t Array_lpolys.t) (_c : W32.t Array256.t)
      (_pos : W32.t Array_tau1.t)
      (_mask : W32.t Array_lpolys.t) (_z0 : W32.t Array_lpolys.t)
      (_incr : W64.t)
      :
    hoare [ M.__compute_z_and_check_norm :
        s1_doubled = _s1d /\ challenge_positions = _pos /\
        mask = _mask /\ signer_response = _z0 /\
        infinity_norm_check_result = _incr /\
        (_incr = W64.zero \/ _incr = W64.one) /\
        wpoly_srng 1 1 _c /\ challenge_shape (lifts_wpoly _c) /\
        positions_of _pos (lifts_wpoly _c) /\
        wpolylvec_srng (lvec_unflatten256 _s1) Eta Eta /\
        (forall k, 0 <= k < lvec =>
           doubled16_of (lvec_unflatten256 _s1d).[k] (lvec_unflatten256 _s1).[k]) /\
        (* only needed when _incr = 0 (loop runs): mask from ExpandMask *)
        (_incr = W64.zero =>
          wpolylvec_srng (lvec_unflatten256 _mask) (gamma1 - 1) gamma1)
        ==>
        (res.`2 = W64.zero \/ res.`2 = W64.one) /\
        (* Biconditional: failure bit is zero iff no prior failure AND
           the abstract z-norm check holds. *)
        (res.`2 = W64.zero <=>
           _incr = W64.zero /\
           PolyLVec.infnorm_lt
             ((lifts_wpolylvec (lvec_unflatten256 _mask)) +
              (PolyLVec.psmul (lifts_wpoly _c) (lifts_wpolylvec (lvec_unflatten256 _s1))))
             (gamma1 - Beta)) /\
        (_incr = W64.zero =>
           res.`2 = W64.zero =>
           (* ||z||_inf < gamma1 - Beta *)
           wpolylvec_infnorm_lt (gamma1 - Beta) (lvec_unflatten256 res.`1) /\
           lifts_wpolylvec (lvec_unflatten256 res.`1) =
             (lifts_wpolylvec (lvec_unflatten256 _mask)) +
             (PolyLVec.psmul (lifts_wpoly _c) (lifts_wpolylvec (lvec_unflatten256 _s1))) /\
           wpolylvec_srng (lvec_unflatten256 res.`1) (gamma1 - 1) gamma1)
    ].
proof.
have lvec_val  := gt0_l.
have gamma1_val := gamma1_cases.
have tau_val   := tau_bound.
have eta_val   := eta_bound.
proc => /=.
case (infinity_norm_check_result <> zero).
+ rcondt ^if; 1: by auto.
  rcondf ^while; 1: by auto.
  by auto => /#.

conseq (: _ ==>
  (infinity_norm_check_result = zero \/ infinity_norm_check_result = one) /\
  (infinity_norm_check_result = zero <=>
   PolyLVec.infnorm_lt
     (lifts_wpolylvec (lvec_unflatten256 _mask) +
      PolyLVec.psmul (lifts_wpoly _c) (lifts_wpolylvec (lvec_unflatten256 _s1)))
     (gamma1 - Beta)) /\
  (infinity_norm_check_result = zero =>
  (wpolylvec_infnorm_lt (gamma1 - Beta) (lvec_unflatten256 signer_response) /\
   lifts_wpolylvec (lvec_unflatten256 signer_response) =
     lifts_wpolylvec (lvec_unflatten256 _mask) +
     PolyLVec.psmul (lifts_wpoly _c) (lifts_wpolylvec (lvec_unflatten256 _s1)) /\
   wpolylvec_srng (lvec_unflatten256 signer_response) (gamma1 - 1) gamma1)));
 1: by move => |> &hr ?? infncr rr *; smt(W64.to_uint_eq pow2_64 W64.to_uintK W64.of_uintK).
rcondf ^if; 1: by auto.
while (#{/~_incr}{~infinity_norm_check_result}{~signer_response}pre /\
       (infinity_norm_check_result = zero \/ infinity_norm_check_result = one) /\
       0 <= base <= lvec * n /\ base %% n = 0 /\
       (infinity_norm_check_result <> zero => base = lvec * n) /\
       wpolylvec_srng (lvec_unflatten256 _mask) (gamma1 - 1) gamma1 /\
       (infinity_norm_check_result <> zero =>
          ! PolyLVec.infnorm_lt
              (lifts_wpolylvec (lvec_unflatten256 _mask) +
               PolyLVec.psmul (lifts_wpoly _c) (lifts_wpolylvec (lvec_unflatten256 _s1)))
              (gamma1 - Beta)) /\
       (infinity_norm_check_result = zero =>
         (forall k, 0 <= k < base %/ n =>
           wpoly_srng (gamma1 - Beta - 1) (gamma1 - Beta - 1)
                      (lvec_unflatten256 signer_response).[k]) /\
         (forall k, 0 <= k < base %/ n =>
           (lifts_wpolylvec (lvec_unflatten256 signer_response)).[k] =
           (lifts_wpolylvec (lvec_unflatten256 _mask) +
            PolyLVec.psmul (lifts_wpoly _c) (lifts_wpolylvec (lvec_unflatten256 _s1))).[k]))
      ); last first.
(* ── Loop exit ────────────────────────────────────────────────── *)
+ auto => /> 9?; split; 1: smt().
  move => bs inr srs ??????? H_fail H_srng; do split; 2: smt().
  (* biconditional ⇒: srs = zero => infnorm_lt *)
  + move => Hzero.
    have [# H1 H2] := H_srng Hzero.
    have Hwplv : wpolylvec_infnorm_lt (gamma1 - Beta) (lvec_unflatten256 srs)
      by rewrite /wpolylvec_infnorm_lt /wpolylvec_srng LArray.allP => *; smt(gt0_l).
    have Hleq : lifts_wpolylvec (lvec_unflatten256 srs) =
        lifts_wpolylvec (lvec_unflatten256 _mask) +
        PolyLVec.psmul (lifts_wpoly _c) (lifts_wpolylvec (lvec_unflatten256 _s1))
      by apply LArray.tP => *; smt(gt0_l).
    rewrite -Hleq.
    by apply (wpolylvec_infnorm_liftE (gamma1 - Beta)); smt(gamma1_cases beta_gamma1_lt gt0_beta).
  (* conditional: srs = zero => triple *)
  + move => Hzero.
    have [# H1 H2] := H_srng Hzero.
    do split.
    + rewrite /wpolylvec_infnorm_lt /wpolylvec_srng LArray.allP => i ib.
      by have := H1 i _; smt(gt0_l).
    + apply LArray.tP => ii iib.
      have -> := H2 ii _;1:smt(gt0_l).
      by rewrite polylvec_add_iE 1:/#.
    + rewrite /wpolylvec_srng LArray.allP => ii iib.
      have := H1 ii _;1:smt(gt0_l).
      rewrite /wpoly_srng !allP => Hrng j jb.
      by have := Hrng j _; smt(gt0_beta).

(* ── Loop body: one column at index base %/ n ──────────────────── *)
(* Jasmin: compute_signer_response_element(signer_response_element, s1_slice, c, mask_slice)
           → writeback signer_response[base..base+n] = result
           → check_infinity_norm(result, gamma1-Beta)
           → base += n; if(fail){ base = lvec * n }                    *)

(* ══ Phase 1: compute z and its norm test via ecall + writeback ══ *)
seq 2 : (#pre /\
    lifts_wpoly (Array256.init (fun i => signer_response.[base + i])) =
      (lifts_wpolylvec (lvec_unflatten256 _mask) +
       PolyLVec.psmul (lifts_wpoly _c) (lifts_wpolylvec (lvec_unflatten256 _s1))).[base %/ n] /\
    wpoly_srng 6283009 6283008
               (Array256.init (fun i => signer_response.[base + i])) /\
    (wpoly_infnorm_lt (gamma1 - Beta) (Array256.init (fun i => signer_response.[base + i])) =>
       aux_0 = W64.zero) /\
    (!wpoly_infnorm_lt (gamma1 - Beta) (Array256.init (fun i => signer_response.[base + i])) =>
       aux_0 = W64.one)).
+ wp.
  ecall (__compute_signer_response_element_correct
           (Array256.init (fun i => s1_doubled.[base + i]))
           (Array256.init (fun i => _s1.[base + i]))
           _c
           challenge_positions
           (Array256.init (fun i => mask.[base + i]))
           (Array256.init (fun i => signer_response.[base + i]))).
  auto => |> &hr Hc Hsh Hpos Hs1_rng Hs1d *.
  have Heq_s1 : (lvec_unflatten256 _s1).[base{hr} %/ n] = Array256.init (fun i => _s1.[base{hr} + i]).
  + by apply lvec_slice_eq; smt(gt0_l).
  have Heq_s1d : (lvec_unflatten256 _s1d).[base{hr} %/ n] = Array256.init (fun i => _s1d.[base{hr} + i]).
  + by apply lvec_slice_eq; smt(gt0_l).
  do split => /=.
  - (* s1 slice range *)
    rewrite -Heq_s1.
    by move: Hs1_rng; rewrite /wpolylvec_srng LArray.allP => H; apply H; smt(gt0_l).
  - (* s1 slice doubling *)
    by rewrite -Heq_s1 -Heq_s1d; apply Hs1d; smt(gt0_l).
  - (* mask slice range: wpoly_srng gamma1 gamma1 from wpolylvec_srng (gamma1-1) gamma1 *)
    have Hmask_rng : wpolylvec_srng (lvec_unflatten256 _mask) (gamma1 - 1) gamma1 by smt().
    have Heq_mask : (lvec_unflatten256 _mask).[base{hr} %/ n] = Array256.init (fun i => _mask.[base{hr} + i]).
    + by apply lvec_slice_eq; smt(gt0_l).
    rewrite -Heq_mask.
    move: Hmask_rng; rewrite /wpolylvec_srng LArray.allP => H.
    have := H (base{hr} %/ n) _; 1: smt(gt0_l).
    rewrite /wpoly_srng !allP => Hk j jb.
    by have := Hk j _; smt().
  move => _ _ _ result Hres_eq Hres_rng Hpass Hfail.
  (* The writeback slice (init (fun i => (init ...).[base+i])) simplifies to result *)
  have Hwb_slice : (Array256.init (fun i =>
      (Array_lpolys.init (fun i0 =>
        if base{hr} <= i0 < base{hr} + n then result.`1.[i0 - base{hr}]
        else signer_response{hr}.[i0])).[base{hr} + i])) = result.`1.
  + apply Array256.tP => j jb.
    rewrite Array256.initiE 1:/# /= Array_lpolys.initiE; by smt().
  do split.
  - (* invariant: old columns preserved for k < base/n *)
    move => ?; split.
    + move => k kb Hlt.
      have Hmod : base{hr} %% 256 = 0 by smt().
      have Hlvec : 0 <= k < lvec by smt(gt0_l).
      have /= Hwb :=
        lvec_unflatten256_writeback_iE signer_response{hr} result.`1 base{hr} k Hmod Hlvec.
      by rewrite Hwb ifF; smt().
    + move => k kb Hlt.
      have Hmod : base{hr} %% 256 = 0 by smt().
      have Hlvec : 0 <= k < lvec by smt(gt0_l).
      have /= Hwb :=
        lvec_unflatten256_writeback_iE signer_response{hr} result.`1 base{hr} k Hmod Hlvec.
      have Hk_eq : (lvec_unflatten256 (Array_lpolys.init (fun i =>
            if base{hr} <= i < base{hr} + n then result.`1.[i - base{hr}]
            else signer_response{hr}.[i]))).[k] =
          (lvec_unflatten256 signer_response{hr}).[k]
        by rewrite Hwb ifF; smt().
      have /= HH2k : (lifts_wpolylvec (lvec_unflatten256 signer_response{hr})).[k] =
          (lifts_wpolylvec (lvec_unflatten256 _mask) +
           PolyLVec.psmul (lifts_wpoly _c) (lifts_wpolylvec (lvec_unflatten256 _s1))).[k]
        by smt().
      by rewrite -HH2k /lifts_wpolylvec mapiE 1:/# mapiE 1:/# /= Hk_eq.
  - (* new column: lifts = spec *)
    rewrite Hwb_slice Hres_eq.
    rewrite (lifts_wpolylvec_slice _mask base{hr}) 1:/#; 1: smt(gt0_l).
    rewrite (lifts_wpolylvec_slice _s1 base{hr}) 1:/#; 1: smt(gt0_l).
    by rewrite polylvec_add_iE 1:/# /PolyLVec.psmul (LArray.mapiE (fun (p : poly) => p &* lifts_wpoly _c)) 1:/#.
  - (* new column: range *)
    by rewrite Hwb_slice.
  - (* new column: the flag is its norm test *)
    by rewrite Hwb_slice.
  - by rewrite Hwb_slice.

(* ══ Phase 2: the flag and the base update ══ *)
wp; skip => |> &hr 16? Hpass Hfail.
move: (aux_0{hr}) Hpass Hfail => rr Hpass Hfail.
case (rr = W64.zero) => Hrr /=.
+ (* norm passed: rr = zero, update invariant *)
  do split; 1..3: by smt().
  + move => k kbl kbh.
    case (k < base{hr} %/ n) => ?; 1: by smt().
    have -> : k = base{hr} %/ n by smt().
    have Hinfnorm : wpoly_infnorm_lt (gamma1 - Beta)
      (Array256.init (fun i => signer_response{hr}.[base{hr} + i]))
      by smt(W64.to_uint_eq W64.of_uintK W64.to_uintK pow2_64).
    move: Hinfnorm; rewrite /wpoly_infnorm_lt /wpoly_srng !allP => Hr j jb.
    have /= := Hr j _; 1: smt().
    by rewrite /lvec_unflatten256 initiE 1:/# /= initiE 1:/# /= get_of_list 1:/# /= nth_sub 1:/# /= ; smt().
  + move => k kb ?; case (k < base{hr} %/ n) => ?; 1: by smt().
    have -> : k = base{hr} %/ n by smt().
    rewrite -(lifts_wpolylvec_slice signer_response{hr} base{hr}) 1:/#; 1: smt(gt0_l).
    by smt().
(* norm failed: rr = one, propagate (!infnorm_lt) *)
have Hnwpoly : !wpoly_infnorm_lt (gamma1 - Beta)
    (Array256.init (fun i => signer_response{hr}.[base{hr} + i]))
  by apply /negP => Hwpoly; smt().
have Hninfnorm : !infnorm_lt
    (lifts_wpoly (Array256.init (fun i => signer_response{hr}.[base{hr} + i])))
    (gamma1 - Beta).
+ apply /negP => Hcontra; apply Hnwpoly.
  apply (wpoly_infnorm_unliftE (gamma1 - Beta) 6283009 6283008
           (Array256.init (fun i => signer_response{hr}.[base{hr} + i]))).
  + smt(gamma1_cases beta_gamma1_lt gt0_beta).
  + smt().
  + smt().
  + by smt().
  + exact Hcontra.

split; 1: smt().
split; 1: smt(gt0_l).
split; 1: by rewrite modzMl.
apply /negP => Hkvec; apply Hninfnorm.
move: Hkvec; rewrite /PolyLVec.infnorm_lt allP => Hk.
have /= Hk_at := Hk (base{hr} %/ n) _; 1: by rewrite mem_iota /=; smt(gt0_l).
have Heq : lifts_wpoly (init (fun (i : int) => signer_response{hr}.[base{hr} + i])) =
    (lifts_wpolylvec (lvec_unflatten256 _mask) +
     PolyLVec.psmul (lifts_wpoly _c) (lifts_wpolylvec (lvec_unflatten256 _s1))).[base{hr} %/ n]
  by smt().
by rewrite /infnorm_lt Heq; exact Hk_at.
qed.

lemma __compute_z_and_check_norm_ph
      (_s1d _s1 : W32.t Array_lpolys.t) (_c : W32.t Array256.t)
      (_pos : W32.t Array_tau1.t)
      (_mask : W32.t Array_lpolys.t) (_z0 : W32.t Array_lpolys.t)
      (_incr : W64.t)
      :
    phoare [ M.__compute_z_and_check_norm :
        s1_doubled = _s1d /\ challenge_positions = _pos /\
        mask = _mask /\ signer_response = _z0 /\
        infinity_norm_check_result = _incr /\
        (_incr = W64.zero \/ _incr = W64.one) /\
        wpoly_srng 1 1 _c /\ challenge_shape (lifts_wpoly _c) /\
        positions_of _pos (lifts_wpoly _c) /\
        wpolylvec_srng (lvec_unflatten256 _s1) Eta Eta /\
        (forall k, 0 <= k < lvec =>
           doubled16_of (lvec_unflatten256 _s1d).[k] (lvec_unflatten256 _s1).[k]) /\
        (_incr = W64.zero =>
          wpolylvec_srng (lvec_unflatten256 _mask) (gamma1 - 1) gamma1)
        ==>
        (res.`2 = W64.zero \/ res.`2 = W64.one) /\
        (* Biconditional: failure bit is zero iff no prior failure AND
           the abstract z-norm check holds. *)
        (res.`2 = W64.zero <=>
           _incr = W64.zero /\
           PolyLVec.infnorm_lt
             ((lifts_wpolylvec (lvec_unflatten256 _mask)) +
              (PolyLVec.psmul (lifts_wpoly _c) (lifts_wpolylvec (lvec_unflatten256 _s1))))
             (gamma1 - Beta)) /\
        (res.`2 = W64.zero =>
           wpolylvec_infnorm_lt (gamma1 - Beta) (lvec_unflatten256 res.`1) /\
           lifts_wpolylvec (lvec_unflatten256 res.`1) =
             (lifts_wpolylvec (lvec_unflatten256 _mask)) +
             (PolyLVec.psmul (lifts_wpoly _c) (lifts_wpolylvec (lvec_unflatten256 _s1))) /\
           wpolylvec_srng (lvec_unflatten256 res.`1) (gamma1 - 1) gamma1)
    ] = 1%r.
proof.
by conseq __compute_z_and_check_norm_ll
          (__compute_z_and_check_norm_correct _s1d _s1 _c _pos _mask _z0 _incr) => /#.
qed.

(* ================================================================== *)
(* __make_hint_vector                                                  *)
(* Called fourth; incr = result of the z and cs2 checks (0 or 1); the  *)
(* flag of the (public) c t0 test joins the result in __sign_internal.  *)
(* Computes h = MakeHintImpl(-ct0, w-cs2+ct0) per row (kvec rows).            *)
(* Checks total hint count <= omega = w_hint.                         *)
(* Note: ct0 at spec level is passed as parameter by the caller.      *)
(* ================================================================== *)

lemma __make_hint_vector_ll : islossless M.__make_hint_vector.
proof.
proc.
wp. (* post-loop: SETcc + OR *)
while (0 <= base <= kvec * n /\ base %% n = 0) (kvec * n - base); last by auto; smt(gt0_k).
move => ?.
wp. (* total_ones_in_hint += ones_in_hint *)
wp. (* hint_0 writeback *)
call polynomial____make_hint_ll.
wp. (* hint_element <- Array256.init *)
by auto => /#.
qed.

(* The flag of the hint test is a bit whatever the ranges of the inputs:
   __sign_internal runs the hint test even when the (public) test on c t0
   failed, and then nothing else is known about w0 - c s2 + c t0. *)
lemma __make_hint_vector_bit (_incr : W64.t) :
    hoare [ M.__make_hint_vector :
        infinity_norm_check_result = _incr /\ (_incr = W64.zero \/ _incr = W64.one)
        ==> (res.`2 = W64.zero \/ res.`2 = W64.one) /\
            (_incr <> W64.zero => res.`2 = _incr) ].
proof.
proc => /=.
case (infinity_norm_check_result <> zero).
+ rcondt ^if; 1: by auto.
  rcondf ^while; 1: by auto.
  by auto.
rcondf ^if; 1: by auto.
while ((infinity_norm_check_result = W64.zero \/ infinity_norm_check_result = W64.one) /\ _incr = W64.zero); last by auto => /#.
wp; call (: true ==> true); 1: by conseq (: _ ==> true) => //; proc; inline *; wp; while (true); auto.
auto => /> &hr H result r; rewrite /SETcc; case (w_hint < total_ones_in_hint{hr} + r.`2) => _ /=; case H => ->;
  by smt(W64.or0w W64.orw0 W64.orwK W64.to_uint_eq to_uint_zeroextu64 W8.to_uint1 W8.to_uint0 W64.to_uint1 W64.to_uint0).
qed.

(* When all coefficients of the hint vector are 0 or 1 (wpolykvec_urng v 2),
   hammw and count_nonzero_coeffs_kvec measure the same thing:
   c <> Zq.zero <=> c = Zq.one for 0/1-valued coefficients. *)
lemma hammw_count_nonzero (v : wpolykvec) (bound : int) :
  wpolykvec_urng v 2 =>
  hammw (liftu_wpolykvec v) bound =>
  count_nonzero_coeffs_kvec (liftu_wpolykvec v) <= bound.
proof.
rewrite /wpolykvec_urng allP => Hrng.
rewrite /hammw /count_nonzero_coeffs /count_nonzero_coeffs_kvec /count_nonzero_coeffs /=.
rewrite /to_list /mkseq StdBigop.Bigint.BIA.big_map /(\o) /=.
suff: StdBigop.Bigint.BIA.big predT<:int>
  (fun (ii : int) => count (fun (jj : int) => (liftu_wpolykvec v).[ii].[jj] <> Zq.zero) (iota_ 0 n)) (
  iota_ 0 kvec) =
 StdBigop.Bigint.BIA.big (fun (x : int) => predT (liftu_wpolykvec v).[x])
  (fun (x : int) => count (fun (c : coeff) => c = Zq.one) (map ("_.[_]" (liftu_wpolykvec v).[x]) (iota_ 0 n)))
  (iota_ 0 kvec) by smt().
apply StdBigop.Bigint.BIA.eq_big_seq => x; rewrite mem_iota => /= *.
rewrite count_map;apply eq_in_count => k; rewrite mem_iota => /= *.
rewrite /preim /=.
have := Hrng x _; 1:smt().
rewrite /wpoly_urng allP => /= Hrngx.
have := Hrngx k _;1:smt().
move => H.
rewrite /liftu_wpolykvec !mapiE 1,2:/# /=.
smt(@Zq).
qed.


lemma __make_hint_vector_correct
      (_r : W32.t Array_kpolys.t) (_w1 : W32.t Array_kpolys.t)
      (_h : W32.t Array_kpolys.t) (_incr : W64.t)
      :
    hoare [ M.__make_hint_vector :
        w0_minus_cs2_plus_ct0 = _r /\ w1 = _w1 /\ hint_0 = _h /\
        infinity_norm_check_result = _incr /\
        (_incr = W64.zero \/ _incr = W64.one) /\
        (_incr = W64.zero =>
          wpolykvec_srng (kvec_unflatten256 _r) (2*gamma2 - Beta - 2) (2*gamma2 - Beta - 2)) /\
        wpolykvec_urng (kvec_unflatten256 _w1) ((q - 1) %/ (2 * gamma2))
        ==>
        (res.`2 = W64.zero \/ res.`2 = W64.one) /\
        (* Biconditional: failure bit is zero iff no prior failure AND
           the abstract hint-weight check holds. Hints are always 0/1 by
           construction — the spec-level condition is just hammw. *)
        (res.`2 = W64.zero =>
             liftu_wpolykvec (kvec_unflatten256 res.`1) =
               MakeHintImpl (lifts_wpolykvec (kvec_unflatten256 _w1))
                             (lifts_wpolykvec (kvec_unflatten256 _r))) /\
        (res.`2 = W64.zero <=>
           _incr = W64.zero /\
           PolyKVec.hammw
             (MakeHintImpl (lifts_wpolykvec (kvec_unflatten256 _w1))
                          (lifts_wpolykvec (kvec_unflatten256 _r))) w_hint) /\
        (res.`2 = W64.zero =>
           (* Hint coefficients are 0 or 1, so the kvec is unsigned-range 2. *)
           wpolykvec_urng (kvec_unflatten256 res.`1) 2)
    ].
proof.
have kvec_val  := gt0_k.
have w_hint_val : 0 < w_hint by smt(param_sets).
proc => /=.
case (infinity_norm_check_result <> zero).
+ rcondt ^if; 1: by auto.
  rcondf ^while; 1: by auto.
  auto => /> *; do split; smt().

rcondf ^if; 1: by auto.
wp.  (* absorb post-loop: SETcc + zeroextu64 + OR *)
while (#{/~_incr}{~infinity_norm_check_result}{~hint_0}{~total_ones_in_hint}pre /\
       (infinity_norm_check_result = zero \/ infinity_norm_check_result = one) /\
       0 <= base <= kvec * n /\ base %% n = 0 /\
       (infinity_norm_check_result <> zero => base = kvec * n) /\
       wpolykvec_srng (kvec_unflatten256 _r) (2*gamma2 - Beta - 2) (2*gamma2 - Beta - 2) /\
       wpolykvec_urng (kvec_unflatten256 _w1) ((q - 1) %/ (2 * gamma2)) /\
       0 <= total_ones_in_hint /\
       (infinity_norm_check_result = zero =>
         (forall k, 0 <= k < base %/ n =>
           liftu_wpoly (kvec_unflatten256 hint_0).[k] =
             poly_MakeHintImpl (lifts_wpoly (kvec_unflatten256 _w1).[k])
                           (lifts_wpoly (kvec_unflatten256 _r).[k]))) /\
       (infinity_norm_check_result = zero =>
         (forall k, 0 <= k < base %/ n =>
           wpoly_urng 2 ((kvec_unflatten256 hint_0).[k]))) /\
       (infinity_norm_check_result = zero <=>
         _incr = zero /\
         big predT (fun ii =>
             count (fun jj => (MakeHintImpl (lifts_wpolykvec (kvec_unflatten256 _w1))
                             (lifts_wpolykvec (kvec_unflatten256 _r))).[ii].[jj] <> Zq.zero)
                   (iota_ 0 256)) (iota_ 0 (base %/ n)) <= w_hint
         ) /\
        (infinity_norm_check_result = zero =>
         total_ones_in_hint =
           big predT (fun ii =>
             count (fun jj => (MakeHintImpl (lifts_wpolykvec (kvec_unflatten256 _w1))
                             (lifts_wpolykvec (kvec_unflatten256 _r))).[ii].[jj] <> Zq.zero)
                   (iota_ 0 256)) (iota_ 0 (base %/ n)))
      ); last first.
(* ── Loop exit (combined with initialization) ─────────────────── *)
+ auto => /> ??.
  do split; 1..3:smt().
  + by rewrite (iota0 0 0) //= big_nil /#.
  + by rewrite (iota0 0 0) //= big_nil /#.
  (* exit condition: INV /\ !guard => post *)
  move => bs h0 inf0 toi0 ? Hbin ? ?? Hexit ? Hcond Hmhp Hmhp0 Hmhp1 Hmhp2.
  do split.
  + move => Hi.
    have HH := Hmhp Hi.
    rewrite tP => k kb.
    rewrite mapiE 1:/# HH 1:/# /MakeHintImpl map2iE 1:/# mapiE 1:/#; smt(KArray.mapiE).
  + move => Hi; rewrite /hammw.
    have -> : kvec = bs %/ n by smt().
    by have := Hmhp1; rewrite Hi /= => ->.
  + move => Hh.
    move: Hh; rewrite /hammw => Hh.
    have Hk : kvec = bs %/ n by smt().
    have := Hmhp1; by rewrite -Hk Hh.
  + move => Hi; rewrite /wpolykvec_urng allP; smt().
    
    
(* ── Loop body ────────────────────────────────────────────────── *)
(* Statements: 6.1 read slice, 6.2 ecall make_hint, 6.3 writeback,
               6.4 accumulate count, 6.5 base+=n,
               6.6 declassify (no-op), 6.7 if(fail){base=kvec*n} *)
seq 3 : (#pre /\
    liftu_wpoly (Array256.init (fun i => hint_0.[base + i])) =
      poly_MakeHintImpl (lifts_wpoly (kvec_unflatten256 _w1).[base %/ n])
                    (lifts_wpoly (kvec_unflatten256 _r).[base %/ n]) /\
      wpoly_urng 2 (Array256.init (fun i => hint_0.[base + i]))  /\
    ones_in_hint =
      count (fun i => (liftu_wpoly (Array256.init (fun j => hint_0.[base + j]))).[i] <> Zq.zero)
            (iota_ 0 256)).
+ wp.
  ecall (polynomial____make_hint_correct
           (Array256.init (fun i => hint_0.[base + i]))
           (Array256.init (fun i => w0_minus_cs2_plus_ct0.[base + i]))
           (Array256.init (fun i => w1.[base + i]))).
  auto => |> &hr *.
  do split => /=.
  - (* r slice range: wpoly_srng (2*gamma2-Beta-2) from wpolykvec_srng *)
    have Hr : wpolykvec_srng (kvec_unflatten256 _r) (2*gamma2 - Beta - 2) (2*gamma2 - Beta - 2) by smt().
    have /= Heq : (kvec_unflatten256 _r).[base{hr} %/ n] = Array256.init (fun i => _r.[base{hr} + i])
      by apply kvec_slice_eq; smt(gt0_k).
    rewrite -Heq.
    by move: Hr; rewrite /wpolykvec_srng KArray.allP => H; apply H; smt(gt0_k).
  - (* w1 slice range: wpoly_urng from wpolykvec_urng *)
    have Hw : wpolykvec_urng (kvec_unflatten256 _w1) ((q - 1) %/ (2 * gamma2)) by smt().
    have /= Heq : (kvec_unflatten256 _w1).[base{hr} %/ n] = Array256.init (fun i => _w1.[base{hr} + i])
      by apply kvec_slice_eq; smt(gt0_k).
    rewrite -Heq.
    by move: Hw; rewrite /wpolykvec_urng KArray.allP => H; apply H; smt(gt0_k).
  move => ? ? result Hres_eq Hres_cnt.
  (* writeback slice reads back as result.`1 *)
  have Hwb_slice : (Array256.init (fun i =>
      (Array_kpolys.init (fun i0 =>
        if base{hr} <= i0 < base{hr} + n then result.`1.[i0 - base{hr}]
        else hint_0{hr}.[i0])).[base{hr} + i])) = result.`1.
  + apply Array256.tP => j jb.
    rewrite Array256.initiE 1:/# /= Array_kpolys.initiE; first by smt().
    by rewrite /= ifT 1:/# /= /#.
  have /= Hr_eq := kvec_slice_eq _r base{hr} _ _; 1,2: smt(gt0_k).
  have /= Hw1_eq := kvec_slice_eq _w1 base{hr} _ _; 1,2: smt(gt0_k).
  rewrite Hwb_slice Hres_eq Hr_eq Hw1_eq /=.
  move => Rv.

(* ── Phase 2: accumulate + base++ + declassify + conditional exit ── *)
do split;3..:smt().
move => Hinf.
have Hfork : forall k, 0 <= k < base{hr} %/ n =>
      liftu_wpoly (kvec_unflatten256 hint_0{hr}).[k] =
      poly_MakeHintImpl (lifts_wpoly (kvec_unflatten256 _w1).[k]) (lifts_wpoly (kvec_unflatten256 _r).[k])
  by move => k [Hk0 Hkn]; smt().
+ (* forall k < base/n: writeback preserves old columns *)
  move => k kb Hlt.
  have /= Hmod : base{hr} %% 256 = 0 by smt().
  have Hkvec : 0 <= k < kvec by smt(gt0_k).
  have /= Hwb := kvec_unflatten256_writeback_iE hint_0{hr} result.`1 base{hr} k Hmod Hkvec.
  by rewrite Hwb ifF; smt().
+ move => Hzero k Hk0 Hklt.
  have /= Hmod : base{hr} %% 256 = 0 by smt().
  have Hkvec : 0 <= k < kvec by smt(gt0_k).
  have /= Hwb := kvec_unflatten256_writeback_iE hint_0{hr} result.`1 base{hr} k Hmod Hkvec.
  by rewrite Hwb ifF;smt().

auto => /> &hr ???????????Hcount H??; split. 
+ rewrite /SETcc.
  pose p := w_hint <
      total_ones_in_hint{hr} +
      count (fun (i : int) => (liftu_wpoly (init (fun (j : int) => hint_0{hr}.[base{hr} + j]))).[i] <> Zq.zero)
        (iota_ 0 n).
  move => Hf; rewrite modzMl mulzK 1:// /=; do split;2,3:smt(count_ge0 gt0_k).
  + case p => Hp; case (infinity_norm_check_result{hr} = zero) => H0; 2,4:smt(W64.to_uint_eq W64.of_uintK W64.to_uintK pow2_64 or64_ne0); rewrite H0 /= to_uint_eq  to_uint_zeroextu64 //=;  by have := Hf;rewrite Hp H0 /= to_uint_eq /= to_uint_zeroextu64 //=.
  + case (_incr = zero); last by smt().
    move => Hi0 /=.
    case (infinity_norm_check_result{hr} = zero) => Hin0; last by smt().
    move : Hf; rewrite Hin0 /= to_uint_eq /= to_uint_zeroextu64 => ?.
    have  : p by smt(W8.to_uint_eq W8.of_uintK W8.to_uintK pow2_8).
    rewrite /p Hcount // => Hpp.
    have -> : kvec = base{hr} %/n + 1 + (kvec - base{hr} %/n  - 1) by ring.
    rewrite iota_add;1,2:smt(gt0_k).
    rewrite iota_add;1,2:smt(gt0_k).
    simplify.
    rewrite iota1 !big_cat big_cons /= big_nil /= /(predT (base{hr} %/ n)) /=.
    (* Goal: !(big(0..base/n) + (MakeHintImpl w1 r)[base/n]-count + big(base/n+1..kvec) <= w_hint)
       Strategy: rewrite the middle count via Heq, then arithmetic from Hpp+Htail *)
    have Heq : (MakeHintImpl (lifts_wpolykvec (kvec_unflatten256 _w1))
                   (lifts_wpolykvec (kvec_unflatten256 _r))).[base{hr} %/ n] =
               liftu_wpoly (init (fun (i : int) => hint_0{hr}.[base{hr} + i]))
      by rewrite /PolyKVec.MakeHintImpl map2iE 1:/# /lifts_wpolykvec mapiE 1:/# mapiE 1:/#; smt().
    rewrite Heq.
    have Htail : 0 <= big predT
        (fun (ii : int) => count (fun (jj : int) =>
           (MakeHintImpl (lifts_wpolykvec (kvec_unflatten256 _w1))
              (lifts_wpolykvec (kvec_unflatten256 _r))).[ii].[jj] <> Zq.zero) (iota_ 0 n))
        (iota_ (base{hr} %/ n + 1) (kvec - base{hr} %/ n - 1))
      by apply sumr_ge0_seq => ??; smt( count_ge0).
    move: Hpp Htail; pose c := big _ _ (iota_ (base{hr} %/ n + 1) _).
    pose a := big _ _ (iota_ 0 (base{hr} %/ n)); pose b := count _ (iota_ 0 n).
    smt().

  move => Hn; do split;1..5: smt(count_ge0).
  + (* MakeHintImpl forall: extend from k < base/n to k < (base+n)/n *)
    move => _ k Hk0 Hklt.
    have Hinf0 : infinity_norm_check_result{hr} = zero
      by smt(or64_ne0 W64.to_uint_eq W64.of_uintK W64.to_uintK pow2_64).
    have /= Hslice := kvec_slice_eq hint_0{hr} base{hr} _ _; 1,2: smt(gt0_k).
    have Hkdec : k < base{hr} %/ n \/ k = base{hr} %/ n by smt().
    elim Hkdec => [Hklt2|->].
    + by smt().
    + by rewrite Hslice; smt().
  + (* wpoly_urng forall: extend from k < base/n to k < (base+n)/n *)
    move => _ k Hk0 Hklt.
    have Hinf0 : infinity_norm_check_result{hr} = zero
      by smt(or64_ne0 W64.to_uint_eq W64.of_uintK W64.to_uintK pow2_64).
    have /= Hslice := kvec_slice_eq hint_0{hr} base{hr} _ _; 1,2: smt(gt0_k).
    have Hkdec : k < base{hr} %/ n \/ k = base{hr} %/ n by smt().
    elim Hkdec => [Hklt2|->].
    + by smt().
    + by rewrite Hslice; smt().
  + (* Biconditional: inf_new = zero <=> _incr = zero /\ big(0..(base+n)/n) <= w_hint *)
    move => ?.
    have Hinf0 : infinity_norm_check_result{hr} = zero
      by smt(or64_ne0 W64.to_uint_eq W64.of_uintK W64.to_uintK pow2_64).
    pose p := w_hint <
      total_ones_in_hint{hr} +
      count (fun (i : int) => (liftu_wpoly (init (fun (j : int) => hint_0{hr}.[base{hr} + j]))).[i] <> Zq.zero)
        (iota_ 0 n).
    have Hnp : !p
      by smt(W8.to_uint_eq W8.of_uintK W8.to_uintK pow2_8
             W64.to_uint_eq W64.of_uintK W64.to_uintK pow2_64 or64_ne0).
    split; 1: smt().
    have -> : (base{hr} + n) %/ n = base{hr} %/ n + 1 by smt().
    rewrite iota_add; 1,2: smt().
    rewrite iota1 big_cat big_cons /= big_nil /=.
    have Heq2 : (MakeHintImpl (lifts_wpolykvec (kvec_unflatten256 _w1))
                   (lifts_wpolykvec (kvec_unflatten256 _r))).[base{hr} %/ n] =
                 liftu_wpoly (init (fun (i : int) => hint_0{hr}.[base{hr} + i]))
      by rewrite /PolyKVec.MakeHintImpl map2iE 1:/# /lifts_wpolykvec mapiE 1:/# mapiE 1:/#; smt().
    rewrite Heq2.
    have Hcnt : count (fun (jj : int) => (liftu_wpoly (init (fun (i : int) => hint_0{hr}.[base{hr} + i]))).[jj] <> Zq.zero) (iota_ 0 n) =
                count (fun (i : int) => (liftu_wpoly (init (fun (j : int) => hint_0{hr}.[base{hr} + j]))).[i] <> Zq.zero) (iota_ 0 n)
      by done.
    rewrite Hcnt -(Hcount Hinf0); smt().
  + (* count equality: inf_new = zero => total_new = big(0..(base+n)/n) *)
    move => _.
    have Hinf0 : infinity_norm_check_result{hr} = zero
      by smt(or64_ne0 W64.to_uint_eq W64.of_uintK W64.to_uintK pow2_64).
    have -> : (base{hr} + n) %/ n = base{hr} %/ n + 1 by smt().
    rewrite iota_add; 1,2: smt().
    rewrite iota1 big_cat big_cons /= big_nil /=.
    have Heq2 : (MakeHintImpl (lifts_wpolykvec (kvec_unflatten256 _w1))
                   (lifts_wpolykvec (kvec_unflatten256 _r))).[base{hr} %/ n] =
                 liftu_wpoly (init (fun (i : int) => hint_0{hr}.[base{hr} + i]))
      by rewrite /PolyKVec.MakeHintImpl map2iE 1:/# /lifts_wpolykvec mapiE 1:/# mapiE 1:/#; smt().
    rewrite Heq2.
    have Hcnt : count (fun (jj : int) => (liftu_wpoly (init (fun (i : int) => hint_0{hr}.[base{hr} + i]))).[jj] <> Zq.zero) (iota_ 0 n) =
                count (fun (i : int) => (liftu_wpoly (init (fun (j : int) => hint_0{hr}.[base{hr} + j]))).[i] <> Zq.zero) (iota_ 0 n)
      by done.
    rewrite Hcnt -(Hcount Hinf0).
    ring.
qed.

lemma __make_hint_vector_ph
      (_r : W32.t Array_kpolys.t) (_w1 : W32.t Array_kpolys.t)
      (_h : W32.t Array_kpolys.t) (_incr : W64.t)
      :
    phoare [ M.__make_hint_vector :
        w0_minus_cs2_plus_ct0 = _r /\ w1 = _w1 /\ hint_0 = _h /\
        infinity_norm_check_result = _incr /\
        (_incr = W64.zero \/ _incr = W64.one) /\
        (_incr = W64.zero =>
          wpolykvec_srng (kvec_unflatten256 _r) (2*gamma2 - Beta - 2) (2*gamma2 - Beta - 2)) /\
        wpolykvec_urng (kvec_unflatten256 _w1) ((q - 1) %/ (2 * gamma2))
        ==>
        (res.`2 = W64.zero \/ res.`2 = W64.one) /\
        (* Biconditional: failure bit is zero iff no prior failure AND
           the abstract hint-weight check holds. Hints are always 0/1 by
           construction — the spec-level condition is just hammw. *)
        (res.`2 = W64.zero =>
             liftu_wpolykvec (kvec_unflatten256 res.`1) =
               MakeHintImpl (lifts_wpolykvec (kvec_unflatten256 _w1))
                             (lifts_wpolykvec (kvec_unflatten256 _r))) /\
        (res.`2 = W64.zero <=>
           _incr = W64.zero /\
           PolyKVec.hammw
             (MakeHintImpl (lifts_wpolykvec (kvec_unflatten256 _w1))
                          (lifts_wpolykvec (kvec_unflatten256 _r))) w_hint) /\
        (res.`2 = W64.zero =>
           (* Hint coefficients are 0 or 1, so the kvec is unsigned-range 2. *)
           wpolykvec_urng (kvec_unflatten256 res.`1) 2)
    ] = 1%r.
proof. by conseq __make_hint_vector_ll (__make_hint_vector_correct _r _w1 _h _incr). 
qed.

(* The hint test with the range of w0 - c s2 + c t0 as a hypothesis of the
   conclusions rather than of the call: in __sign_internal the range is only
   known when the test on c t0 passed. *)
lemma __make_hint_vector_correct_anyrange
      (_r : W32.t Array_kpolys.t) (_w1 : W32.t Array_kpolys.t)
      (_h : W32.t Array_kpolys.t) (_incr : W64.t)
      :
    hoare [ M.__make_hint_vector :
        w0_minus_cs2_plus_ct0 = _r /\ w1 = _w1 /\ hint_0 = _h /\
        infinity_norm_check_result = _incr /\
        (_incr = W64.zero \/ _incr = W64.one) /\
        wpolykvec_urng (kvec_unflatten256 _w1) ((q - 1) %/ (2 * gamma2))
        ==>
        (res.`2 = W64.zero \/ res.`2 = W64.one) /\
        (_incr <> W64.zero => res.`2 = _incr) /\
        (wpolykvec_srng (kvec_unflatten256 _r) (2*gamma2 - Beta - 2) (2*gamma2 - Beta - 2) =>
           (res.`2 = W64.zero =>
              liftu_wpolykvec (kvec_unflatten256 res.`1) =
                MakeHintImpl (lifts_wpolykvec (kvec_unflatten256 _w1))
                             (lifts_wpolykvec (kvec_unflatten256 _r))) /\
           (res.`2 = W64.zero <=>
              _incr = W64.zero /\
              PolyKVec.hammw
                (MakeHintImpl (lifts_wpolykvec (kvec_unflatten256 _w1))
                             (lifts_wpolykvec (kvec_unflatten256 _r))) w_hint) /\
           (res.`2 = W64.zero =>
              wpolykvec_urng (kvec_unflatten256 res.`1) 2))
    ].
proof.
case (wpolykvec_srng (kvec_unflatten256 _r) (2*gamma2 - Beta - 2) (2*gamma2 - Beta - 2)) => Hr.
+ by conseq (__make_hint_vector_correct _r _w1 _h _incr) => /> /#.
+ by conseq (__make_hint_vector_bit _incr) => /> /#.
qed.

lemma __make_hint_vector_ph_anyrange
      (_r : W32.t Array_kpolys.t) (_w1 : W32.t Array_kpolys.t)
      (_h : W32.t Array_kpolys.t) (_incr : W64.t)
      :
    phoare [ M.__make_hint_vector :
        w0_minus_cs2_plus_ct0 = _r /\ w1 = _w1 /\ hint_0 = _h /\
        infinity_norm_check_result = _incr /\
        (_incr = W64.zero \/ _incr = W64.one) /\
        wpolykvec_urng (kvec_unflatten256 _w1) ((q - 1) %/ (2 * gamma2))
        ==>
        (res.`2 = W64.zero \/ res.`2 = W64.one) /\
        (_incr <> W64.zero => res.`2 = _incr) /\
        (wpolykvec_srng (kvec_unflatten256 _r) (2*gamma2 - Beta - 2) (2*gamma2 - Beta - 2) =>
           (res.`2 = W64.zero =>
              liftu_wpolykvec (kvec_unflatten256 res.`1) =
                MakeHintImpl (lifts_wpolykvec (kvec_unflatten256 _w1))
                             (lifts_wpolykvec (kvec_unflatten256 _r))) /\
           (res.`2 = W64.zero <=>
              _incr = W64.zero /\
              PolyKVec.hammw
                (MakeHintImpl (lifts_wpolykvec (kvec_unflatten256 _w1))
                             (lifts_wpolykvec (kvec_unflatten256 _r))) w_hint) /\
           (res.`2 = W64.zero =>
              wpolykvec_urng (kvec_unflatten256 res.`1) 2))
    ] = 1%r.
proof. by conseq __make_hint_vector_ll (__make_hint_vector_correct_anyrange _r _w1 _h _incr). qed.

end SignNormChecksT.
