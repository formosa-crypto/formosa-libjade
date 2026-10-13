require import AllCore IntDiv List.

from Jasmin require import JWord.

require import GFq Rq.
require import Array256.

import Parameters Round ZModQ Zq.

(******************************************************)
(* Representations of polys as 32-bit word arrays     *)
(******************************************************)

type wpoly = W32.t Array256.t.

op liftu_wpoly (pw : wpoly) : poly =
  map (fun w => incoeff (W32.to_uint w)) pw.

op lifts_wpoly (pw : wpoly) : poly =
  map (fun w => incoeff (W32.to_sint w)) pw.

op unlift_poly (p : poly) : wpoly = map (fun c => W32.of_int (asint c)) p.

op poly_urng(b : int, p : poly) = all (fun i => 0 <= asint i < b) p.
op poly_srng(bl bh : int, p : poly) = all (fun i => -bl <= crepr i <= bh) p.

op wpoly_urng(b : int, pw : wpoly) = all (fun i => 0 <= W32.to_uint i < b) pw.
op wpoly_srng(bl bh : int, pw : wpoly) = all (fun i => -bl <= W32.to_sint i <= bh) pw.
op wpoly_infnorm_lt(b : int, pw : wpoly) = wpoly_srng (b-1) (b-1) pw.

(* Monotonicity: tighter wpoly_srng implies wider wpoly_srng *)
lemma wpoly_srng_widen (p : wpoly) (a1 b1 a2 b2 : int) :
  a1 <= a2 => b1 <= b2 => wpoly_srng a1 b1 p => wpoly_srng a2 b2 p.
proof.
rewrite /wpoly_srng !allP => Ha Hb H x Hx.
by have := H x Hx; smt().
qed.

(* ------------------------------------------------------------------ *)
(* Range predicates of the word-level NTT-domain operations.           *)
(*                                                                      *)
(*   ntt_irng  : |x| < q    every caller feeds the NTT reduced inputs  *)
(*   ntt_orng  : |x| < 9q   each of the eight layers costs q           *)
(*   bmul_irng : |x| < 9q   two operands that wide keep the 64-bit     *)
(*                          Montgomery product below 2^31 q, so the    *)
(*                          product is reduced (|x| < q)               *)
(*   intt_irng : |x| <= q   the inverse tree doubles the bound at each *)
(*                          of its eight levels, and 2^8 q < 2^31      *)
(* ------------------------------------------------------------------ *)
op wpoly_ntt_irng  (p : wpoly) = wpoly_srng (q-1) (q-1) p.
op wpoly_ntt_orng  (p : wpoly) = wpoly_srng (9*q-1) (9*q-1) p.
op wpoly_bmul_irng (p : wpoly) = wpoly_srng (9*q-1) (9*q-1) p.
op wpoly_intt_irng (p : wpoly) = wpoly_srng q q p.

(* ------------------------------------------------------------------ *)
(* Output bound of polynomial__invert_ntt_montgomery: the last          *)
(* operation on every coefficient is a Montgomery multiplication by     *)
(* 41978 = 2^64/256 mod q, whence |x| <= (41978 + q)/2.                 *)
(*                                                                      *)
(* It is tight enough that add(_, s2) stays within the tolerance        *)
(* [-q+1, q-1] of conditionally_add_modulus -- as the comment in        *)
(* mldsa-native sign.c (mld_compute_t0_t1_tr...) requires:              *)
(*   "the output of the invntt [must be] small enough such that the     *)
(*    addition of s2 does not result in absolute values >= MLDSA_Q"     *)
(* ------------------------------------------------------------------ *)
op invntt_obound : int = 4211197.


(* ------------------------------------------------------------------ *)
(* Bridge lemmas between the range predicates                          *)
(* ------------------------------------------------------------------ *)
lemma wpoly_ntt_orng_bmul_irng (p : wpoly) : wpoly_ntt_orng p => wpoly_bmul_irng p.
proof. done. qed.

lemma wpoly_bmul_orng_intt_irng (p : wpoly) : wpoly_srng (q-1) (q-1) p => wpoly_intt_irng p.
proof. by apply wpoly_srng_widen. qed.

lemma wpoly_urng_bmul_irng (p : wpoly) : wpoly_urng q p => wpoly_bmul_irng p.
proof.
rewrite /wpoly_urng /wpoly_bmul_irng /wpoly_srng !allP => H x /H /= rgx.
by rewrite W32.to_sintE /smod; smt().
qed.

lemma wpoly_srng_ntt_irng (p : wpoly) : wpoly_srng (q-1) (q-1) p => wpoly_ntt_irng p.
proof. done. qed.

(* ------------------------------------------------------------------ *)
(* Montgomery-form reading of a word polynomial.  The NTT-domain        *)
(* products (pointwise multiplication, dot products) return their      *)
(* result times 2^-32; the inverse NTT multiplies by 2^32.  Reading    *)
(* the former through liftm makes the two factors cancel by           *)
(* construction: liftm res = basemul ..., lifts res' = invntt (liftm *)
(* res).                                                              *)
(* ------------------------------------------------------------------ *)
op mont : coeff = incoeff (2^32).

op liftm_wpoly (pw : wpoly) : poly = scale mont (lifts_wpoly pw).

lemma wpoly_urng_lifts_eq_liftu (p : wpoly) :
  wpoly_urng q p => lifts_wpoly p = liftu_wpoly p.
proof.
rewrite /wpoly_urng /lifts_wpoly /liftu_wpoly allP /= => H.
apply Array256.tP => j jb.
rewrite !mapiE 1,2:/# /=; congr.
have := H j jb => /= Hr.
rewrite W32.to_sintE /smod.
have -> /= : ! (2 ^ (32 - 1) <= to_uint p.[j]) by smt().
done.
qed.

lemma wpoly_infnorm_liftE (b : int) (pw : wpoly) :
    0 < b <= q %/ 2 =>
    wpoly_infnorm_lt b pw => infnorm_lt (lifts_wpoly pw) b.
move => Hb.
rewrite /wpoly_infnorm_lt /infnorm_lt /wpoly_srng /lifts_wpoly !allP /=.
move => H j; rewrite mem_iota /= => Hj; have := H j _; 1: smt().
rewrite mapiE 1:/# /=.
move => [Hl Hr]; have /# := incoeffK_centered (to_sint pw.[j]) _; 1: smt().
qed.

lemma wpoly_infnorm_unliftE (b bl bh : int) (pw : wpoly) :
    0 < b =>
    bl + b <= q => bh + b <= q =>
    wpoly_srng bl bh pw =>
    infnorm_lt (lifts_wpoly pw) b => wpoly_infnorm_lt b pw.
proof.
move => Hb Hbl Hbh Hrng Hinf.
rewrite /wpoly_infnorm_lt /wpoly_srng allP => k Hk.
move: Hinf; rewrite /infnorm_lt /lifts_wpoly allP /= => Hinf.
have /= Hk' := Hinf k _; 1: smt(mem_iota).
rewrite mapiE 1:/# /= in Hk'.
move: Hrng; rewrite /wpoly_srng allP => Hrng.
have /= Hrng_k := Hrng k _; 1: smt().
have Hcong : (crepr (incoeff (to_sint pw.[k]))) %% q = (to_sint pw.[k]) %% q.
+ by rewrite -!incoeffK creprK.
smt().
qed.
