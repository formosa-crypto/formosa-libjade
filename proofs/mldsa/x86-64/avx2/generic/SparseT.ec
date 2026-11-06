require import AllCore List IntDiv RealExp StdBigop.
from Jasmin require import JModel_x86.
from Spec require import GFq Rq Parameters MLDSA_W32_Rep.
require import Array8 Array256 Array512 WArray1024 WArray2048.
require import JWordExtra JModelExtra W16extra.
require BaseT JArrayExtra.

(* ================================================================== *)
(* Products by the challenge in the time domain (arithmetic/sparse.jinc) *)
(*                                                                      *)
(* The challenge c has tau coefficients equal to +1 or -1, the others   *)
(* zero. c * s in R_q = Z_q[X] / (X^256 + 1) is the signed sum of the   *)
(* tau rotations X^p * s, computed exactly on the integers from the     *)
(* doubled polynomial D = [-s | s] (D[t] = -s[t] for t < 256, s[t-256]  *)
(* above): X^p * s = D[256 - p .. 512 - p).                             *)
(* ================================================================== *)

(* the byte views of the polynomials and of the doubled polynomials *)
clone JArrayExtra.PWAE as PW256 with op size <- 256, op wsize <- 1024,
  theory P <- Array256, theory W <- WArray1024 proof wsizeE by done.
clone JArrayExtra.PWAE as PW512 with op size <- 512, op wsize <- 2048,
  theory P <- Array512, theory W <- WArray2048 proof wsizeE by done.

abstract theory SparseT.

clone import BaseT.BaseT as B.
import S R MLDSAParams.

import Round ZModQ Zq.
import Array_tau1.

(* ------------------------------------------------------------------ *)
(* The shape of a challenge and the array of its positions              *)
(* ------------------------------------------------------------------ *)

(* the positions of the coefficient value b in a polynomial, below k and
   in all, increasing *)
abbrev cposp (c : poly) (b : coeff) (k : int) = ipos (fun i => c.[i] = b) k.
abbrev cpos (c : poly) (b : coeff) = cposp c b n.

(* coefficients in {0, 1, -1}, tau of them non-zero *)
op challenge_shape (c : poly) =
  (forall i, 0 <= i < n => c.[i] = Zq.zero \/ c.[i] = Zq.one \/ c.[i] = - Zq.one) /\
  size (cpos c Zq.one) + size (cpos c (- Zq.one)) = tau.

(* the array built by __challenge_positions: the positions of the +1
   in [0, np), those of the -1 in [np, tau), np at index tau. The order
   inside each range is irrelevant to the products. *)
op positions_of (pos : W32.t Array_tau1.t) (c : poly) =
  let np = size (cpos c Zq.one) in
     to_uint pos.[tau] = np
  /\ perm_eq (map (fun m => to_uint pos.[m]) (range 0 np)) (cpos c Zq.one)
  /\ perm_eq (map (fun m => to_uint pos.[m]) (range np tau)) (cpos c (- Zq.one)).

(* ------------------------------------------------------------------ *)
(* The product by a challenge, coefficient by coefficient               *)
(* ------------------------------------------------------------------ *)

(* coefficient i of X^p * s *)
op rotc (s : poly) (p i : int) : coeff =
  if p <= i then s.[i - p] else - s.[256 + i - p].

lemma challenge_mulE (c s : poly) (i : int) : 0 <= i < n =>
  (forall k, 0 <= k < n => c.[k] = Zq.zero \/ c.[k] = Zq.one \/ c.[k] = - Zq.one) =>
  (c &* s).[i] =
    NR.P.BigCf.BCA.big predT (fun p => rotc s p i) (cpos c Zq.one)
  - NR.P.BigCf.BCA.big predT (fun p => rotc s p i) (cpos c (- Zq.one)).
proof.
move=> hi hc; rewrite mulE /NR.negmul initiE //=.
rewrite /ipos !NR.P.BigCf.BCA.big_filter.
rewrite (NR.P.BigCf.BCA.big_mkcond (fun k => c.[k] = Zq.one)).
rewrite (NR.P.BigCf.BCA.big_mkcond (fun k => c.[k] = - Zq.one)) NR.P.BigCf.BCA.sumrB.
apply NR.P.BigCf.BCA.eq_big_seq => k /mem_iota hk /=; rewrite /rotc.
have h01 : Zq.zero <> Zq.one by rewrite eq_sym ZModpField.oner_neq0.
have h0N : Zq.zero <> - Zq.one.
+ by rewrite eq_sym ZModpRing.oppr_eq0 ZModpField.oner_neq0.
have h1N : Zq.one <> - Zq.one by rewrite eq_sym oneN1.
have [|[|]] -> := hc k _; 1: smt().
+ by rewrite h01 h0N /=; case: (k <= i) => _; ring.
+ by rewrite h1N /=; case: (k <= i) => _; ring.
by rewrite oneN1 /=; case: (k <= i) => _; ring.
qed.

(* a challenge of the implementation (coefficients in [-1, 1], l1 norm
   tau) has the shape above *)
lemma challenge_shape_of_l1 (w : W32.t Array256.t) :
  wpoly_srng 1 1 w => l1 (lifts_wpoly w) = tau => challenge_shape (lifts_wpoly w).
proof.
rewrite /wpoly_srng allP => hw hl.
have hv : forall i, 0 <= i < n =>
  (lifts_wpoly w).[i] = Zq.zero \/ (lifts_wpoly w).[i] = Zq.one \/ (lifts_wpoly w).[i] = - Zq.one.
+ move=> i hi; rewrite /lifts_wpoly mapiE //=.
  have /= := hw i hi; move: (to_sint w.[i]) => x hx.
  have [|[|]] -> : x = 0 \/ x = 1 \/ x = -1 by smt().
  + by left; rewrite incoeff0.
  + by right; left; rewrite incoeff1.
  by right; right; rewrite incoeffN incoeff1.
split; 1: done.
have hc : forall (P : int -> bool) s, count P s = StdBigop.Bigint.BIA.big P (fun _ => 1) s.
+ by move=> P s; rewrite StdBigop.Bigint.big_constz.
rewrite -hl /l1 /ipos !size_filter !hc !(StdBigop.Bigint.BIA.big_mkcond _ (fun _ => 1)).
rewrite -StdBigop.Bigint.BIA.big_split.
apply StdBigop.Bigint.BIA.eq_big_seq => k /mem_iota hk /=.
have [|[|]] -> := hv k _; 1: smt().
+ have h01 : Zq.zero <> Zq.one by rewrite eq_sym ZModpField.oner_neq0.
  have h0N : Zq.zero <> - Zq.one.
  + by rewrite eq_sym ZModpRing.oppr_eq0 ZModpField.oner_neq0.
  by rewrite h01 h0N abs_zp_zero.
+ by rewrite (eq_sym Zq.one (- Zq.one)) oneN1 abs_zp_one.
by rewrite oneN1 -abs_zpN abs_zp_one.
qed.

(* ------------------------------------------------------------------ *)
(* The product on the integers, from the array of positions             *)
(* ------------------------------------------------------------------ *)

(* D = [-s | s] on the integers *)
op dint (s : W32.t Array256.t) (t : int) : int =
  if t < 256 then - W32.to_sint s.[t] else W32.to_sint s.[t - 256].

(* the sum of the rotations by the positions of indices [a, b), at j *)
op psum (s : W32.t Array256.t) (pos : W32.t Array_tau1.t) (a b j : int) : int =
  StdBigop.Bigint.BIA.bigi predT (fun m => dint s (256 - to_uint pos.[m] + j)) a b.

lemma dint_rotc (s : W32.t Array256.t) (p j : int) : 0 <= p < 256 => 0 <= j < 256 =>
  incoeff (dint s (256 - p + j)) = rotc (lifts_wpoly s) p j.
proof.
move=> hp hj; rewrite /dint /rotc /lifts_wpoly.
case: (p <= j) => h.
+ by rewrite ifF 1:/# mapiE 1:/# /= (_ : 256 - p + j - 256 = j - p) 1:#ring.
by rewrite ifT 1:/# mapiE 1:/# /= incoeffN (_ : 256 - p + j = 256 + j - p) 1:#ring.
qed.

(* the positions of a sign, as a sum over the array of positions *)
lemma psum_cpos (s : W32.t Array256.t) (pos : W32.t Array_tau1.t) (a b j : int) (l : int list) :
  0 <= j < 256 => (forall p, p \in l => 0 <= p < 256) =>
  perm_eq (map (fun m => to_uint pos.[m]) (range a b)) l =>
  incoeff (psum s pos a b j) = NR.P.BigCf.BCA.big predT (fun p => rotc (lifts_wpoly s) p j) l.
proof.
move=> hj hl hp; rewrite /psum incoeff_big.
rewrite (NR.P.BigCf.BCA.eq_big_seq _
  (fun m => (fun p => incoeff (dint s (256 - p + j))) (to_uint pos.[m]))) //.
rewrite -(NR.P.BigCf.BCA.big_map (fun m => to_uint pos.[m]) predT).
rewrite (NR.P.BigCf.BCA.eq_big_perm _ _ _ _ hp).
by apply NR.P.BigCf.BCA.eq_big_seq => p /hl hp' /=; apply dint_rotc.
qed.

lemma sparse_prodE (s : W32.t Array256.t) (pos : W32.t Array_tau1.t) (c : poly) (j : int) :
  0 <= j < 256 => challenge_shape c => positions_of pos c =>
  (c &* lifts_wpoly s).[j] =
  incoeff (psum s pos 0 (to_uint pos.[tau]) j - psum s pos (to_uint pos.[tau]) tau j).
proof.
move=> hj [hc _] [hn [hp hm]]; rewrite challenge_mulE // incoeffB hn.
have hin : forall b p, p \in cpos c b => 0 <= p < 256.
+ by move=> b p; rewrite /ipos mem_filter mem_iota /#.
have e1 := psum_cpos s pos 0 (size (cpos c Zq.one)) j (cpos c Zq.one) hj (hin Zq.one) hp.
have e2 := psum_cpos s pos (size (cpos c Zq.one)) tau j (cpos c (- Zq.one)) hj (hin (- Zq.one)) hm.
by rewrite e1 e2.
qed.

lemma psum_bnd (s : W32.t Array256.t) (pos : W32.t Array_tau1.t) (B a b j : int) :
  a <= b => 0 <= j < 256 => wpoly_srng B B s =>
  (forall m, a <= m < b => to_uint pos.[m] < 256) =>
  `|psum s pos a b j| <= (b - a) * B.
proof.
move=> hab hj; rewrite /wpoly_srng allP => hs hp; rewrite /psum.
apply (StdOrder.IntOrder.ler_trans _ _ _ (StdBigop.Bigint.big_normr _ _ _)).
rewrite mulrC -StdBigop.Bigint.bigi_constz //.
apply StdBigop.Bigint.ler_sum_seq => m /mem_range hm _ /=.
have h0 := hp m hm; have h1 := W32.to_uint_cmp pos.[m].
rewrite /dint /=; case: (256 - to_uint pos.[m] + j < 256) => hc.
+ by have /= := hs (256 - to_uint pos.[m] + j) _; smt().
by have /= := hs (256 - to_uint pos.[m] + j - 256) _; smt().
qed.

(* ------------------------------------------------------------------ *)
(* The doubled polynomials                                              *)
(* ------------------------------------------------------------------ *)


(* D = [-s | s] on 16-bit lanes *)
op doubled16_of (d s : W32.t Array256.t) =
  forall t, 0 <= t < 512 =>
    W16.to_sint (PW256.lane16 d t) =
    if t < 256 then - W32.to_sint s.[t] else W32.to_sint s.[t - 256].

(* D = [-s | s] on 32-bit coefficients *)
op doubled32_of (d : W32.t Array512.t) (s : W32.t Array256.t) =
  forall t, 0 <= t < 512 =>
    W32.to_sint d.[t] = if t < 256 then - W32.to_sint s.[t] else W32.to_sint s.[t - 256].



lemma eta_le4 : Eta <= 4 by smt(param_sets).

lemma tau_eta : 0 < Eta /\ 0 < tau /\ tau * Eta <= 240 by smt(param_sets).


(* ------------------------------------------------------------------ *)
(* The positions of a sign below k                                      *)
(* ------------------------------------------------------------------ *)

(* the sign of a coefficient of a challenge of the implementation *)
lemma lifts_signE (w : W32.t Array256.t) (i : int) : wpoly_srng 1 1 w => 0 <= i < 256 =>
     ((lifts_wpoly w).[i] = Zq.one <=> 0 < W32.to_sint w.[i])
  /\ ((lifts_wpoly w).[i] = - Zq.one <=> W32.to_sint w.[i] < 0).
proof.
rewrite /wpoly_srng allP => hw hi; rewrite /lifts_wpoly mapiE //=.
have /= := hw i hi; move: (to_sint w.[i]) => x hx.
have h01 : Zq.zero <> Zq.one by rewrite eq_sym ZModpField.oner_neq0.
have h0N : Zq.zero <> - Zq.one.
+ by rewrite eq_sym ZModpRing.oppr_eq0 ZModpField.oner_neq0.
have [|[|]] -> : x = 0 \/ x = 1 \/ x = -1 by smt().
+ by rewrite incoeff0 h01 h0N.
+ by rewrite incoeff1 (eq_sym Zq.one (- Zq.one)) oneN1.
by rewrite incoeffN incoeff1 oneN1.
qed.

(* the positions of the +1 below k are stored from index 0 up, those of
   the -1 below k from index tau - 1 down *)
op plus_ok (pos : W32.t Array_tau1.t) (c : poly) (k : int) =
  forall m, 0 <= m < size (cposp c Zq.one k) => to_uint pos.[m] = nth 0 (cposp c Zq.one k) m.

op minus_ok (pos : W32.t Array_tau1.t) (c : poly) (k : int) =
  forall i, 0 <= i < size (cposp c (- Zq.one) k) =>
    to_uint pos.[tau - 1 - i] = nth 0 (cposp c (- Zq.one) k) i.

(* ------------------------------------------------------------------ *)
(* __challenge_positions                                                *)
(* ------------------------------------------------------------------ *)

lemma polynomial____challenge_positions_ll : islossless M.polynomial____challenge_positions.
proof.
proc; wp; while (condition_group = (offset < 1024)) (1024 - offset).
+ move=> z; wp.
  while (condition_bit = (mask <> W64.zero)) (to_uint mask).
  + by move=> z'; auto => /> &hr hnz; apply WE64.blsr_lt.
  wp; while (condition_bit = (mask <> W64.zero)) (to_uint mask).
  + by move=> z'; auto => /> &hr hnz; apply WE64.blsr_lt.
  auto => /> &hr _ c m; split; 1: smt(W64.to_uint_eq W64.to_uint0 W64.to_uint_cmp).
  move=> _ _ c' m'; split; 1: smt(W64.to_uint_eq W64.to_uint0 W64.to_uint_cmp).
  smt().
by auto => /#.
qed.

lemma polynomial____challenge_positions_correct (_c : W32.t Array256.t) :
  hoare [ M.polynomial____challenge_positions :
    challenge = _c /\ wpoly_srng 1 1 _c /\ challenge_shape (lifts_wpoly _c)
    ==> positions_of res (lifts_wpoly _c) ].
proof.
proc.
wp; while (0 <= j <= 256 /\ j %% 8 = 0 /\ offset = 4 * j /\ condition_group = (offset < 1024)
  /\ challenge = _c /\ zeros = W256.zero /\ wpoly_srng 1 1 _c /\ challenge_shape (lifts_wpoly _c)
  /\ to_uint n_plus = size (cposp (lifts_wpoly _c) Zq.one j)
  /\ n_minus = tau - size (cposp (lifts_wpoly _c) (- Zq.one) j)
  /\ plus_ok positions (lifts_wpoly _c) j /\ minus_ok positions (lifts_wpoly _c) j).
+ wp; while (0 <= j < 256 /\ j %% 8 = 0 /\ offset = 4 * j
    /\ challenge = _c /\ zeros = W256.zero /\ wpoly_srng 1 1 _c /\ challenge_shape (lifts_wpoly _c)
    /\ to_uint n_plus = size (cposp (lifts_wpoly _c) Zq.one (j + 8))
    /\ plus_ok positions (lifts_wpoly _c) (j + 8)
    /\ condition_bit = (mask <> W64.zero)
    /\ exists t, 0 <= t <= 8
       /\ (forall b, mask.[b] = (t <= b < 8 /\ (lifts_wpoly _c).[j + b] = - Zq.one))
       /\ n_minus = tau - size (cposp (lifts_wpoly _c) (- Zq.one) (j + t))
       /\ minus_ok positions (lifts_wpoly _c) (j + t)).
  + auto => &hr [[#] hj0 hj1 hj8 hoff -> -> hs hcs hnp hpl hcb [t [#] ht0 ht1 hb hnm hmi]] hc /=.
    have hnz : mask{hr} <> W64.zero by rewrite -hcb.
    have /= [[hp1 hp8] [hb' e]] :=
      scan_step (fun i => (lifts_wpoly _c).[i] = - Zq.one) _ _ _ hj0 ht0 hnz hb.
    pose p := to_uint (TZCNT_64 mask{hr}).`6.
    have [_ hsz] := hcs.
    have := size_ipos_mono (fun i => (lifts_wpoly _c).[i] = - Zq.one) (j{hr} + (p + 1)) 256 _.
    + smt().
    have := size_ipos_mono (fun i => (lifts_wpoly _c).[i] = Zq.one) (j{hr} + 8) 256 _; 1: smt().
    rewrite e size_rcons => hsp hsm.
    have hsm0 := size_ge0 (cposp (lifts_wpoly _c) (- Zq.one) (j{hr} + t)).
    have hsp0 := size_ge0 (cposp (lifts_wpoly _c) Zq.one (j{hr} + 8)).
    have htb := tau_bound.
    have hv : to_uint (truncateu32 ((TZCNT_64 mask{hr}).`6 + W64.of_int j{hr})) = j{hr} + p.
    + rewrite W2u32.to_uint_truncateu32 W64.to_uintD_small -/p W64.of_uintK; 1: smt().
      by rewrite !modz_small; smt().
    do 6! (split; 1: smt()).
    split.
    + by rewrite /plus_ok => m hm; rewrite Array_tau1.get_setE 1:/# ifF 1:/#; apply hpl.
    exists (p + 1); split; 1: smt().
    split; 1: exact hb'.
    rewrite -/p e size_rcons; split; 1: by rewrite hnm; ring.
    rewrite /minus_ok e size_rcons => i hi; rewrite Array_tau1.get_setE 1:/# nth_rcons.
    case: (i = size (cposp (lifts_wpoly _c) (- Zq.one) (j{hr} + t))) => [-> /= | hne].
    + by rewrite hnm ifT 1:#ring hv ltzz.
    by rewrite ifF 1:/# ifT 1:/#; apply hmi; smt().
  wp; while (0 <= j < 256 /\ j %% 8 = 0 /\ offset = 4 * j
    /\ challenge = _c /\ zeros = W256.zero /\ wpoly_srng 1 1 _c /\ challenge_shape (lifts_wpoly _c)
    /\ coefficients = get256_direct (WArray1024.init32 (fun i => _c.[i])) offset
    /\ n_minus = tau - size (cposp (lifts_wpoly _c) (- Zq.one) j)
    /\ minus_ok positions (lifts_wpoly _c) j
    /\ condition_bit = (mask <> W64.zero)
    /\ exists t, 0 <= t <= 8
       /\ (forall b, mask.[b] = (t <= b < 8 /\ (lifts_wpoly _c).[j + b] = Zq.one))
       /\ to_uint n_plus = size (cposp (lifts_wpoly _c) Zq.one (j + t))
       /\ plus_ok positions (lifts_wpoly _c) (j + t)).
  + auto => &hr [[#] hj0 hj1 hj8 hoff -> -> hs hcs hcoef hnm hmi hcb
      [t [#] ht0 ht1 hb hnp hpl]] hc /=.
    have hnz : mask{hr} <> W64.zero by rewrite -hcb.
    have /= [[hp1 hp8] [hb' e]] :=
      scan_step (fun i => (lifts_wpoly _c).[i] = Zq.one) _ _ _ hj0 ht0 hnz hb.
    pose p := to_uint (TZCNT_64 mask{hr}).`6.
    have [_ hsz] := hcs.
    have := size_ipos_mono (fun i => (lifts_wpoly _c).[i] = Zq.one) (j{hr} + (p + 1)) 256 _.
    + smt().
    have := size_ipos_mono (fun i => (lifts_wpoly _c).[i] = - Zq.one) j{hr} 256 _; 1: smt().
    rewrite e size_rcons => hsm hsp.
    have hsm0 := size_ge0 (cposp (lifts_wpoly _c) (- Zq.one) j{hr}).
    have hsp0 := size_ge0 (cposp (lifts_wpoly _c) Zq.one (j{hr} + t)).
    have htb := tau_bound.
    have hv : to_uint (truncateu32 ((TZCNT_64 mask{hr}).`6 + W64.of_int j{hr})) = j{hr} + p.
    + rewrite W2u32.to_uint_truncateu32 W64.to_uintD_small -/p W64.of_uintK; 1: smt().
      by rewrite !modz_small; smt().
    do 7! (split; 1: smt()).
    split.
    + by rewrite /minus_ok => i hi; rewrite Array_tau1.get_setE 1:/# ifF 1:/#; apply hmi.
    exists (p + 1); split; 1: smt().
    split; 1: exact hb'.
    rewrite -/p e size_rcons; split; 1: by rewrite -hnp W64.to_uintD_small //; smt().
    rewrite /plus_ok e size_rcons => m hm; rewrite Array_tau1.get_setE 1:/# nth_rcons -hnp.
    case: (m = to_uint n_plus{hr}) => [-> /= | hne]; 1: by rewrite hv.
    by rewrite ifT 1:/#; apply hpl; smt().
  auto => &hr [[#] hj0 hj1 hj8 hoff hcgd -> -> hs hcs hnp hnm hpl hmi] hcg.
  have hj : j{hr} < 256 by smt().
  have [_ hsz] := hcs.
  have hcoef : forall b, 0 <= b < 8 =>
    get256_direct (WArray1024.init32 (fun i => _c.[i])) offset{hr} \bits32 b = _c.[j{hr} + b].
  + by move=> b hb; rewrite PW256.load_bits32 1..4:/#; congr; smt().
  have hmp : forall b, (zeroextu64 (MOVEMASK_8u32 (VPCMPGT_8u32
      (get256_direct (WArray1024.init32 (fun i => _c.[i])) offset{hr}) W256.zero))).[b] =
    (0 <= b < 8 /\ (lifts_wpoly _c).[j{hr} + b] = Zq.one).
  + move=> b; rewrite mask_pos; case: (0 <= b < 8) => // hb.
    by rewrite hcoef // (lifts_signE _c (j{hr} + b) hs _) 1:/#.
  have hmn : forall b, (zeroextu64 (MOVEMASK_8u32 (VPCMPGT_8u32 W256.zero
      (get256_direct (WArray1024.init32 (fun i => _c.[i])) offset{hr})))).[b] =
    (0 <= b < 8 /\ (lifts_wpoly _c).[j{hr} + b] = - Zq.one).
  + move=> b; rewrite mask_neg; case: (0 <= b < 8) => // hb.
    by rewrite hcoef // (lifts_signE _c (j{hr} + b) hs _) 1:/#.
  rewrite /SLH64.protect_256 /=.
  split.
  + do ? (split; 1: smt()).
    by exists 0 => /=; split; [exact hmp | split].
  move=> cb0 mask0 np0 pos0 hcb0 [#] _ _ _ _ _ _ _ hmi0 hcbe [t [#] ht0 ht1 hbt hnp0 hpl0].
  rewrite (_ : mask0 = W64.zero) 1:/# in hbt.
  have e1 := scan_end (fun i => (lifts_wpoly _c).[i] = Zq.one) _ _ _ _ hbt; 1,2: smt().
  have hnp8 : to_uint np0 = size (cposp (lifts_wpoly _c) Zq.one (j{hr} + 8)) by rewrite e1.
  have hpl8 : plus_ok pos0 (lifts_wpoly _c) (j{hr} + 8) by rewrite /plus_ok e1; exact hpl0.
  split.
  + do ? (split; 1: smt()).
    by exists 0 => /=; split; [exact hmn | split].
  move=> cb1 mask2 nm0 pos1 hcb1 [#] _ _ _ _ _ _ hnp1 hpl1 hcbe1 [t' [#] ht0' ht1' hbt' hnm1 hmi1].
  rewrite (_ : mask2 = W64.zero) 1:/# in hbt'.
  have e2 := scan_end (fun i => (lifts_wpoly _c).[i] = - Zq.one) _ _ _ _ hbt'; 1,2: smt().
  have hnm8 : nm0 = tau - size (cposp (lifts_wpoly _c) (- Zq.one) (j{hr} + 8)) by rewrite e2.
  have hmi8 : minus_ok pos1 (lifts_wpoly _c) (j{hr} + 8) by rewrite /minus_ok e2; exact hmi1.
  smt().
auto => &hr [#] -> hs hcs /=.
split.
+ rewrite !ipos0 /= hs hcs /= /plus_ok /minus_ok !ipos0 /=.
  by split => [m | i]; smt().
move=> cg j0 nm0 np0 off0 pos0 hcg [#] hj0 hj1 hj8 hoff hcgd _ _ hnp hnm hpl hmi.
have hj : j0 = 256 by smt().
have [_ hsz] := hcs.
have hP : forall m, 0 <= m < size (cpos (lifts_wpoly _c) Zq.one) =>
  to_uint pos0.[m] = nth 0 (cpos (lifts_wpoly _c) Zq.one) m.
+ by move: hpl; rewrite /plus_ok hj.
have hN : forall i, 0 <= i < size (cpos (lifts_wpoly _c) (- Zq.one)) =>
  to_uint pos0.[tau - 1 - i] = nth 0 (cpos (lifts_wpoly _c) (- Zq.one)) i.
+ by move: hmi; rewrite /minus_ok hj.
have hnpv : to_uint np0 = size (cpos (lifts_wpoly _c) Zq.one) by rewrite hnp hj.
have hs0 := size_ge0 (cpos (lifts_wpoly _c) Zq.one).
have hs1 := size_ge0 (cpos (lifts_wpoly _c) (- Zq.one)).
have ht := tau_bound.
rewrite /positions_of /=.
split.
+ rewrite Array_tau1.get_setE 1:/# /= W2u32.to_uint_truncateu32 hnpv modz_small //.
  smt().
split.
+ have -> : map (fun m => to_uint pos0.[tau <- truncateu32 np0].[m])
              (range 0 (size (cpos (lifts_wpoly _c) Zq.one))) = cpos (lifts_wpoly _c) Zq.one.
  + apply (eq_from_nth 0); 1: by rewrite size_map size_range /#.
    move=> m; rewrite size_map size_range => hm.
    rewrite (nth_map 0) 1:size_range 1:/# nth_range 1:/# /=.
    by rewrite Array_tau1.get_setE 1:/# ifF 1:/# hP /#.
  exact perm_eq_refl.
have -> : map (fun m => to_uint pos0.[tau <- truncateu32 np0].[m])
            (range (size (cpos (lifts_wpoly _c) Zq.one)) tau)
          = rev (cpos (lifts_wpoly _c) (- Zq.one)).
+ apply (eq_from_nth 0); 1: by rewrite size_map size_range size_rev /#.
  move=> m; rewrite size_map size_range => hm.
  rewrite (nth_map 0) 1:size_range 1:/# nth_range 1:/# /= nth_rev 1:/#.
  rewrite Array_tau1.get_setE 1:/# ifF 1:/#.
  have := hN (tau - 1 - (size (cpos (lifts_wpoly _c) Zq.one) + m)) _; 1: smt().
  by rewrite (_ : tau - 1 - (tau - 1 - (size (cpos (lifts_wpoly _c) Zq.one) + m)) =
                  size (cpos (lifts_wpoly _c) Zq.one) + m) 1:#ring => ->; congr; smt().
by apply perm_eq_sym; apply perm_eq_rev.
qed.

lemma polynomial____challenge_positions_ph (_c : W32.t Array256.t) :
  phoare [ M.polynomial____challenge_positions :
    challenge = _c /\ wpoly_srng 1 1 _c /\ challenge_shape (lifts_wpoly _c)
    ==> positions_of res (lifts_wpoly _c) ] = 1%r.
proof.
by conseq polynomial____challenge_positions_ll (polynomial____challenge_positions_correct _c).
qed.

(* ------------------------------------------------------------------ *)
(* __double_16, __double_32                                             *)
(* ------------------------------------------------------------------ *)

lemma polynomial____double_16_ll : islossless M.polynomial____double_16.
proof.
proc; while (inc = 16) (inc - i); 1: by move=> z; auto => /#.
by auto => /#.
qed.

lemma polynomial____double_16_correct (_s : W32.t Array256.t) :
  hoare [ M.polynomial____double_16 :
    polynomial = _s /\ wpoly_srng Eta Eta _s ==> doubled16_of res _s ].
proof.
proc.
while (0 <= i <= 16 /\ inc = 16 /\ zeros = set0_256 /\ polynomial = _s
  /\ wpoly_srng Eta Eta _s
  /\ forall t, 0 <= t < 16 * i =>
          W16.to_sint (PW256.lane16 doubled t) = - W32.to_sint _s.[t]
       /\ W16.to_sint (PW256.lane16 doubled (256 + t)) = W32.to_sint _s.[t]).
+ auto => /> &hr h0 _ hs H hi; split; 1: smt().
  move=> t ht0 ht1.
  pose lo := get256_direct (WArray1024.init32 (fun j => _s.[j])) (64 * i{hr}).
  pose hi' := get256_direct (WArray1024.init32 (fun j => _s.[j])) (64 * i{hr} + 32).
  have hl : forall k, 0 <= k < 16 =>
    VPERMQ (VPACKSS_8u32 lo hi') (W8.of_int 216) \bits16 k = sat16 _s.[16 * i{hr} + k].
  + move=> k hk; rewrite packss_permq_bits16 //.
    by case: (k < 8) => hk8; rewrite PW256.load_bits32 1..4:/#; congr; congr; smt().
  rewrite !PW256.store_lane16 1..12:/#.
  rewrite (_ : (512 + 32 * i{hr}) %/ 2 = 256 + 16 * i{hr}) 1:/#.
  rewrite (_ : 32 * i{hr} %/ 2 = 16 * i{hr}) 1:/#.
  have hsr : forall k, 0 <= k < 256 => -4 <= to_sint _s.[k] <= 4.
  + by move=> k hk; move: hs; rewrite /wpoly_srng allP => /(_ k hk) /=; smt(eta_le4).
  case: (t < 16 * i{hr}) => ht.
  + by rewrite !ifF 1..4:/#; apply H.
  rewrite ifF 1:/# ifT 1:/# ifT 1:/# W16u16.map2bE 1:/# W16u16.get_zero !hl 1,2:/# /=.
  rewrite (_ : 16 * i{hr} + (t - 16 * i{hr}) = t) 1:/#.
  rewrite (_ : 16 * i{hr} + (n + t - (n + 16 * i{hr})) = t) 1:/#.
  have hst : to_sint (sat16 _s.[t]) = to_sint _s.[t] by apply sat16E; smt().
  split; 2: by rewrite hst.
  by rewrite to_sintN 1:/# hst //; smt().
auto => /> &hr _; split => [/# | d i hi0 hi1 hi2 Hd].
rewrite /doubled16_of => t htr.
have hi : i = 16 by smt().
case: (t < 256) => ht; 1: by have [-> _] := Hd t _; smt().
have [_ /=] := Hd (t - 256) _; 1: smt().
done.
qed.

lemma polynomial____double_16_ph (_s : W32.t Array256.t) :
  phoare [ M.polynomial____double_16 :
    polynomial = _s /\ wpoly_srng Eta Eta _s ==> doubled16_of res _s ] = 1%r.
proof. by conseq polynomial____double_16_ll (polynomial____double_16_correct _s). qed.

lemma polynomial____double_32_ll : islossless M.polynomial____double_32.
proof.
proc; while (inc = 32) (inc - i); 1: by move=> z; auto => /#.
by auto => /#.
qed.

lemma polynomial____double_32_correct (_s : W32.t Array256.t) :
  hoare [ M.polynomial____double_32 :
    polynomial = _s /\ wpoly_srng 4095 4096 _s ==> doubled32_of res _s ].
proof.
proc.
while (0 <= i <= 32 /\ inc = 32 /\ zeros = set0_256 /\ polynomial = _s
  /\ wpoly_srng 4095 4096 _s
  /\ forall t, 0 <= t < 8 * i =>
          W32.to_sint doubled.[t] = - W32.to_sint _s.[t]
       /\ W32.to_sint doubled.[256 + t] = W32.to_sint _s.[t]).
+ auto => /> &hr h0 _ hs H hi; split; 1: smt().
  move=> t ht0 ht1.
  rewrite !PW512.store_get 1..16:/#.
  rewrite (_ : (4 * 256 + 32 * i{hr}) %/ 4 = 256 + 8 * i{hr}) 1:/#.
  rewrite (_ : 32 * i{hr} %/ 4 = 8 * i{hr}) 1:/#.
  have hsr : -4095 <= to_sint _s.[t] <= 4096.
  + by move: hs; rewrite /wpoly_srng allP => /(_ t _) /#.
  case: (t < 8 * i{hr}) => ht.
  + by rewrite !ifF 1..4:/#; apply H.
  rewrite ifF 1:/# ifT 1:/# ifT 1:/# W8u32.map2bE 1:/# W8u32.get_zero /=.
  rewrite !PW256.load_bits32 1..8:/# (_ : 32 * i{hr} %/ 4 + (t - 8 * i{hr}) = t) 1:/#.
  rewrite (_ : 32 * i{hr} %/ 4 + (256 + t - (256 + 8 * i{hr})) = t) 1:/# /=.
  rewrite (_ : - _s.[t] = W32.zero - _s.[t]) 1:#ring W32.to_sintB_small /=.
  + by rewrite W32.to_sintE /smod /=; smt().
  by rewrite W32.to_sintE /smod.
auto => /> &hr _; split => [/# | d i hi0 hi1 hi2 Hd].
rewrite /doubled32_of => t htr.
have hi : i = 32 by smt().
case: (t < 256) => ht; 1: by have [-> _] := Hd t _; smt().
have [_ /=] := Hd (t - 256) _; 1: smt().
done.
qed.

lemma polynomial____double_32_ph (_s : W32.t Array256.t) :
  phoare [ M.polynomial____double_32 :
    polynomial = _s /\ wpoly_srng 4095 4096 _s ==> doubled32_of res _s ] = 1%r.
proof. by conseq polynomial____double_32_ll (polynomial____double_32_correct _s). qed.

(* ------------------------------------------------------------------ *)
(* The invariants of the products                                       *)
(* ------------------------------------------------------------------ *)

(* the positions are below 256, at most tau of them are +1 *)
lemma positions_rng (pos : W32.t Array_tau1.t) (c : poly) :
  challenge_shape c => positions_of pos c =>
  to_uint pos.[tau] <= tau /\ forall m, 0 <= m < tau => to_uint pos.[m] < 256.
proof.
move=> [_ hsz] [hn [hp hm]]; split; 1: smt(size_ge0).
move=> m hm0.
have hin : forall b p, p \in cpos c b => p < 256.
+ by move=> b p; rewrite /ipos mem_filter mem_iota /#.
case: (m < size (cpos c Zq.one)) => h.
+ apply (hin Zq.one); rewrite -(perm_eq_mem _ _ hp).
  by apply (map_f (fun m => to_uint pos.[m])); rewrite mem_range /#.
apply (hin (- Zq.one)); rewrite -(perm_eq_mem _ _ hm).
by apply (map_f (fun m => to_uint pos.[m])); rewrite mem_range /#.
qed.

(* the static facts of the 16-bit product *)
op prod_pre (d : W32.t Array256.t) (pos : W32.t Array_tau1.t) (s : W32.t Array256.t) =
     wpoly_srng Eta Eta s /\ doubled16_of d s /\ to_uint pos.[tau] <= tau
  /\ forall m, 0 <= m < tau => to_uint pos.[m] < 256.

(* the coefficients of the product below len are computed *)
op prod_ok (p s : W32.t Array256.t) (pos : W32.t Array_tau1.t) (len : int) =
  forall j, 0 <= j < len =>
    W32.to_sint p.[j] = psum s pos 0 (to_uint pos.[tau]) j - psum s pos (to_uint pos.[tau]) tau j.

(* the running sums of the accumulators of a chunk, after m positions *)
op runsum (s : W32.t Array256.t) (pos : W32.t Array_tau1.t) (m j : int) =
  let np = to_uint pos.[tau] in
  if m <= np then psum s pos 0 m j else psum s pos 0 np j - psum s pos np m j.

(* the 16-bit accumulators of chunk c: the first r after m + 1 positions,
   the others after m *)
op acc16 (acc : W256.t Array8.t) (s : W32.t Array256.t) (pos : W32.t Array_tau1.t)
  (c m r : int) =
  forall r' k, 0 <= r' < 8 => 0 <= k < 16 =>
    W16.to_sint (acc.[r'] \bits16 k) =
    runsum s pos (if r' < r then m + 1 else m) (128 * c + 16 * r' + k).

lemma runsumS (s : W32.t Array256.t) (pos : W32.t Array_tau1.t) (m j : int) :
  0 <= m =>
  runsum s pos (m + 1) j =
  runsum s pos m j + (if m < to_uint pos.[tau] then 1 else -1) * dint s (256 - to_uint pos.[m] + j).
proof.
move=> hm; rewrite /runsum /psum /=.
case: (m < to_uint pos.[tau]) => h.
+ by rewrite ifT 1:/# ifT 1:/# StdBigop.Bigint.BIA.big_int_recr 1:/#.
rewrite ifF 1:/#; case: (m = to_uint pos.[tau]) => [<- | hne].
+ by rewrite lezz /= StdBigop.Bigint.BIA.big_int1; ring.
by rewrite ifF 1:/# StdBigop.Bigint.BIA.big_int_recr 1:/#; ring.
qed.


lemma runsum_bnd (s : W32.t Array256.t) (pos : W32.t Array_tau1.t) (B m j : int) :
  0 <= m <= tau => 0 <= j < 256 => wpoly_srng B B s => to_uint pos.[tau] <= tau =>
  (forall m, 0 <= m < tau => to_uint pos.[m] < 256) =>
  `|runsum s pos m j| <= m * B.
proof.
move=> hm hj hs hn hp; rewrite /runsum /=.
have h0 := W32.to_uint_cmp pos.[tau].
case: (m <= to_uint pos.[tau]) => h.
+ have := psum_bnd s pos B 0 m j _ hj hs _; 1,2: smt().
  by rewrite (_ : m - 0 = m) 1:#ring.
have h1 := psum_bnd s pos B 0 (to_uint pos.[tau]) j _ hj hs _; 1,2: smt().
have h2 := psum_bnd s pos B (to_uint pos.[tau]) m j _ hj hs _; 1,2: smt().
smt().
qed.


(* the 16-bit lanes of an unaligned load from the doubled polynomial *)
lemma load16_dint (d s : W32.t Array256.t) (o k : int) : doubled16_of d s =>
  0 <= o => o + 32 <= 1024 => o %% 2 = 0 => 0 <= k < 16 =>
  W16.to_sint (get256_direct (WArray1024.init32 (fun i => d.[i])) o \bits16 k) =
  dint s (o %/ 2 + k).
proof.
move=> hd h0 h1 h2 hk; rewrite PW256.load_bits16 //.
by have := hd (o %/ 2 + k) _; [smt() | rewrite /dint].
qed.




lemma runsum_tau (s : W32.t Array256.t) (pos : W32.t Array_tau1.t) (j : int) :
  to_uint pos.[tau] <= tau =>
  runsum s pos tau j =
  psum s pos 0 (to_uint pos.[tau]) j - psum s pos (to_uint pos.[tau]) tau j.
proof.
move=> h; rewrite /runsum /=; case: (tau <= to_uint pos.[tau]) => // h'.
rewrite (_ : to_uint pos.[tau] = tau) 1:/#.
by have -> : psum s pos tau tau j = 0 by rewrite /psum StdBigop.Bigint.BIA.big_geq.
qed.




(* the product computed below 256 is c * s, bounded by tau * B *)
lemma prod_okP (p s : W32.t Array256.t) (pos : W32.t Array_tau1.t) (c : poly) (B : int) :
  challenge_shape c => positions_of pos c => wpoly_srng B B s => prod_ok p s pos 256 =>
  lifts_wpoly p = c &* lifts_wpoly s /\ wpoly_srng (tau * B) (tau * B) p.
proof.
move=> hc hp hs hok; have [hn hpr] := positions_rng _ _ hc hp; split.
+ rewrite tP => j hj; rewrite (sparse_prodE s pos c j hj hc hp).
  by rewrite /lifts_wpoly mapiE //= hok.
rewrite /wpoly_srng allP => j hj /=; rewrite hok //.
have := psum_bnd s pos B 0 (to_uint pos.[tau]) j _ hj hs _; 1,2: smt(W32.to_uint_cmp).
have := psum_bnd s pos B (to_uint pos.[tau]) tau j _ hj hs _; 1,2: smt(W32.to_uint_cmp).
smt().
qed.

lemma acc16_zero (acc : W256.t Array8.t) (s : W32.t Array256.t) (pos : W32.t Array_tau1.t)
  (c : int) : (forall r, 0 <= r < 8 => acc.[r] = W256.zero) => acc16 acc s pos c 0 0.
proof.
move=> hz r k hr hk; rewrite hz // W16u16.get_zero to_sint16_0 /runsum /= ifT.
+ smt(W32.to_uint_cmp).
by rewrite ifF 1:/# /psum StdBigop.Bigint.BIA.big_geq.
qed.

lemma acc16_next (acc : W256.t Array8.t) (s : W32.t Array256.t) (pos : W32.t Array_tau1.t)
  (c m : int) : acc16 acc s pos c m 8 => acc16 acc s pos c (m + 1) 0.
proof. by move=> h r k hr hk; rewrite h // ifT 1:/# ifF 1:/#. qed.

(* the rotation by position m, added (m < np) or subtracted, in accumulator r *)
lemma acc16_step (acc : W256.t Array8.t) (d s : W32.t Array256.t) (pos : W32.t Array_tau1.t)
    (c m r : int) :
  prod_pre d pos s => 0 <= c < 2 => 0 <= m < tau => 0 <= r < 8 => acc16 acc s pos c m r =>
  acc16 acc.[r <- (if m < to_uint pos.[tau] then VPADD_16u16 else VPSUB_16u16) acc.[r]
                    (get256_direct (WArray1024.init32 (fun i => d.[i]))
                       (2 * (256 + 128 * c - to_uint pos.[m]) + 32 * r))]
    s pos c m (r + 1).
proof.
move=> [hs [hd [hn hpr]]] hc hm hr hacc r' k hr' hk; rewrite Array8.get_setE 1:/#.
case: (r' = r) => [->> | hne] /=; last by rewrite hacc //; smt().
have := hacc r k hr' hk; rewrite ltzz /= => ha; rewrite (_ : r < r + 1) 1:/# /=.
have hp := hpr m hm; have hp0 := W32.to_uint_cmp pos.[m].
have := load16_dint d s (2 * (256 + 128 * c - to_uint pos.[m]) + 32 * r) k hd _ _ _ hk.
+ smt().
+ smt().
+ smt().
rewrite (_ : (2 * (256 + 128 * c - to_uint pos.[m]) + 32 * r) %/ 2 + k =
             256 - to_uint pos.[m] + (128 * c + 16 * r + k)) 1:/# => hd16.
have hrs := runsumS s pos m (128 * c + 16 * r + k) _; 1: smt().
have hb := runsum_bnd s pos Eta (m + 1) (128 * c + 16 * r + k) _ _ hs hn hpr; 1,2: smt().
have hte := tau_eta.
have hme : (m + 1) * Eta <= tau * Eta by apply StdOrder.IntOrder.ler_wpmul2r; smt().
move: hrs; case: (m < to_uint pos.[tau]) => hlt /= hrs.
+ by rewrite VPADD_16u16_bits16 // W16.to_sintD_small ha hd16; smt().
by rewrite VPSUB_16u16_bits16 // W16.to_sintB_small ha hd16; smt().
qed.

(* ------------------------------------------------------------------ *)
(* __sparse_multiply_16: c * s on 16-bit lanes (|c * s| <= tau * eta)   *)
(* ------------------------------------------------------------------ *)

lemma polynomial____sparse_multiply_16_ll : islossless M.polynomial____sparse_multiply_16.
proof.
proc; while (true) (2 - chunk).
+ move=> z; wp; while (true) (8 - r); 1: by move=> z'; auto => /#.
  wp; while (condition = (m < tau)) (tau - m).
  + move=> z'; wp; while (true) (8 - r); 1: by move=> z''; auto => /#.
    by auto => /#.
  wp; while (condition = (m < to_uint n_plus)) (to_uint n_plus - m).
  + move=> z'; wp; while (true) (8 - r); 1: by move=> z''; auto => /#.
    by auto => /#.
  wp; while (true) (8 - r); 1: by move=> z'; auto => /#.
  by auto => /#.
by auto => /#.
qed.

lemma polynomial____sparse_multiply_16_ok
    (_d : W32.t Array256.t) (_pos : W32.t Array_tau1.t) (_s : W32.t Array256.t) :
  hoare [ M.polynomial____sparse_multiply_16 :
    doubled = _d /\ positions = _pos /\ prod_pre _d _pos _s ==> prod_ok res _s _pos 256 ].
proof.
proc.
seq 6 : (doubled = _d /\ positions = _pos /\ prod_pre _d _pos _s
  /\ to_uint n_plus = to_uint _pos.[tau] /\ chunk = 0).
+ by auto => />; rewrite /SLH64.protect_64 W2u32.to_uint_zeroextu64.
while (0 <= chunk <= 2 /\ doubled = _d /\ positions = _pos /\ prod_pre _d _pos _s
  /\ to_uint n_plus = to_uint _pos.[tau] /\ prod_ok product _s _pos (128 * chunk));
  last by auto => /> &hr *; split => [| c p *]; [rewrite /prod_ok /# | smt()].
(* the stores of the accumulators *)
wp; while (0 <= r <= 8 /\ 0 <= chunk < 2 /\ doubled = _d /\ positions = _pos
  /\ prod_pre _d _pos _s /\ to_uint n_plus = to_uint _pos.[tau]
  /\ acc16 acc _s _pos chunk tau 0 /\ prod_ok product _s _pos (128 * chunk + 16 * r)).
+ auto => &hr [[#] hr0 hr8 hc0 hc1 -> -> hpre hnp hacc hok] hr /=.
  have [hs [hd [hn hpr]]] := hpre.
  do 5! (split; 1: smt()).
  rewrite /prod_ok => j hj.
  pose o := 128 * chunk{hr} + 16 * r{hr}.
  have ho : 0 <= o /\ o + 16 <= 256 /\ 128 * chunk{hr} + 16 * (r{hr} + 1) = o + 16 by smt().
  have hte := tau_eta.
  have hl : forall k, 0 <= k < 16 =>
    W32.to_sint (W32.of_int (W16.to_sint (acc{hr}.[r{hr}] \bits16 k))) =
    psum _s _pos 0 (to_uint _pos.[tau]) (o + k) - psum _s _pos (to_uint _pos.[tau]) tau (o + k).
  + move=> k hk; rewrite hacc 1,2:// /= -runsum_tau //.
    have := runsum_bnd _s _pos Eta tau (o + k) _ _ hs hn hpr; 1,2: smt().
    by move=> hb; rewrite W32.to_sintK_small /#.
  rewrite !PW256.store_get 1..8:/# (_ : 4 * (o + 8) %/ 4 = o + 8) 1:/# (_ : 4 * o %/ 4 = o) 1:/#.
  case: (o <= j < o + 16) => hj16; last by rewrite !ifF 1,2:/#; apply hok; smt().
  have := VPMOVSX_8u16_8u32_halves acc{hr}.[r{hr}] (j - o) _; 1: smt().
  case: (j < o + 8) => hj8.
  + by rewrite ifT 1:/# ifF 1:/# ifT 1:/# => ->; rewrite hl /#.
  by rewrite ifF 1:/# ifT 1:/# (_ : j - o - 8 = j - (o + 8)) 1:/# => ->; rewrite hl /#.
(* the rotations subtracted *)
wp; while (to_uint _pos.[tau] <= m <= tau /\ condition = (m < tau) /\ 0 <= chunk < 2
  /\ doubled = _d /\ positions = _pos /\ prod_pre _d _pos _s
  /\ to_uint n_plus = to_uint _pos.[tau] /\ acc16 acc _s _pos chunk m 0
  /\ prod_ok product _s _pos (128 * chunk)).
+ wp; while (0 <= r <= 8 /\ to_uint _pos.[tau] <= m < tau /\ 0 <= chunk < 2
    /\ doubled = _d /\ positions = _pos /\ prod_pre _d _pos _s
    /\ to_uint n_plus = to_uint _pos.[tau] /\ prod_ok product _s _pos (128 * chunk)
    /\ element = 2 * (256 + 128 * chunk - to_uint _pos.[m]) /\ acc16 acc _s _pos chunk m r).
  + auto => &hr [[#] hr0 hr8 hm0 hm1 hc0 hc1 -> -> hpre hnp hok -> hacc] hr /=.
    have := acc16_step _ _ _ _ _ _ _ hpre _ _ _ hacc; 1..3: smt(W32.to_uint_cmp).
    by rewrite ifF 1:/# => ->; smt().
  auto => &hr [[#] hm0 hm1 -> hc0 hc1 -> -> hpre hnp hacc hok] hc /=.
  rewrite /SLH64.protect_64 W2u32.to_uint_zeroextu64 /(`<<`) /=.
  split; 1: smt().
  by move=> acc0 r0 hr0 [#] *; split; [smt(acc16_next) | smt()].
(* the rotations added *)
wp; while (0 <= m <= to_uint _pos.[tau] /\ condition = (m < to_uint n_plus) /\ 0 <= chunk < 2
  /\ doubled = _d /\ positions = _pos /\ prod_pre _d _pos _s
  /\ to_uint n_plus = to_uint _pos.[tau] /\ acc16 acc _s _pos chunk m 0
  /\ prod_ok product _s _pos (128 * chunk)).
+ wp; while (0 <= r <= 8 /\ 0 <= m < to_uint _pos.[tau] /\ 0 <= chunk < 2
    /\ doubled = _d /\ positions = _pos /\ prod_pre _d _pos _s
    /\ to_uint n_plus = to_uint _pos.[tau] /\ prod_ok product _s _pos (128 * chunk)
    /\ element = 2 * (256 + 128 * chunk - to_uint _pos.[m]) /\ acc16 acc _s _pos chunk m r).
  + auto => &hr [[#] hr0 hr8 hm0 hm1 hc0 hc1 -> -> hpre hnp hok -> hacc] hr /=.
    have := acc16_step _ _ _ _ _ _ _ hpre _ _ _ hacc; 1..3: smt(W32.to_uint_cmp).
    by rewrite ifT 1:/# => ->; smt().
  auto => &hr [[#] hm0 hm1 -> hc0 hc1 -> -> hpre hnp hacc hok] hc /=.
  rewrite /SLH64.protect_64 W2u32.to_uint_zeroextu64 /(`<<`) /=.
  split; 1: smt().
  by move=> acc0 r0 hr0 [#] *; split; [smt(acc16_next) | smt()].
(* the accumulators cleared *)
wp; while (0 <= r <= 8 /\ 0 <= chunk < 2 /\ doubled = _d /\ positions = _pos
  /\ prod_pre _d _pos _s /\ to_uint n_plus = to_uint _pos.[tau]
  /\ prod_ok product _s _pos (128 * chunk) /\ forall r', 0 <= r' < r => acc.[r'] = W256.zero).
+ by auto => /> &hr *; split; [smt() | smt(Array8.get_setE)].
auto => &hr [#] hc0 _ -> -> hpre hnp hok hc2 /=.
have [_ [_ [hn _]]] := hpre.
split; 1: smt().
move=> acc0 r0 hr0 hI0; have h0 := acc16_zero acc0 _s _pos chunk{hr} _; 1: smt().
split; 1: smt(W32.to_uint_cmp).
move=> acc1 c1 m1 hc1' hI1; split; 1: smt().
move=> acc2 c2 m2 hc2' hI2; split; 1: smt().
move=> p0 r1 hr1 hI3.
by rewrite (_ : 128 * (chunk{hr} + 1) = 128 * chunk{hr} + 16 * r1) 1:/#; smt().
qed.

lemma polynomial____sparse_multiply_16_correct
    (_d : W32.t Array256.t) (_pos : W32.t Array_tau1.t) (_s _c : W32.t Array256.t) :
  hoare [ M.polynomial____sparse_multiply_16 :
       doubled = _d /\ positions = _pos
    /\ wpoly_srng Eta Eta _s /\ doubled16_of _d _s
    /\ wpoly_srng 1 1 _c /\ challenge_shape (lifts_wpoly _c)
    /\ positions_of _pos (lifts_wpoly _c)
    ==>
       lifts_wpoly res = lifts_wpoly _c &* lifts_wpoly _s
    /\ wpoly_srng (tau * Eta) (tau * Eta) res ].
proof.
conseq (polynomial____sparse_multiply_16_ok _d _pos _s).
+ by move=> &hr [#] -> -> hs hd _ hc hp /=; have [hn hpr] := positions_rng _ _ hc hp.
by move=> &hr [#] _ _ hs _ _ hc hp p; apply prod_okP.
qed.

lemma polynomial____sparse_multiply_16_ph
    (_d : W32.t Array256.t) (_pos : W32.t Array_tau1.t) (_s _c : W32.t Array256.t) :
  phoare [ M.polynomial____sparse_multiply_16 :
       doubled = _d /\ positions = _pos
    /\ wpoly_srng Eta Eta _s /\ doubled16_of _d _s
    /\ wpoly_srng 1 1 _c /\ challenge_shape (lifts_wpoly _c)
    /\ positions_of _pos (lifts_wpoly _c)
    ==>
       lifts_wpoly res = lifts_wpoly _c &* lifts_wpoly _s
    /\ wpoly_srng (tau * Eta) (tau * Eta) res ] = 1%r.
proof.
by conseq polynomial____sparse_multiply_16_ll
          (polynomial____sparse_multiply_16_correct _d _pos _s _c).
qed.

(* the static facts of the 32-bit product *)
op prod_pre32 (d : W32.t Array512.t) (pos : W32.t Array_tau1.t) (s : W32.t Array256.t) =
     wpoly_srng 4096 4096 s /\ doubled32_of d s /\ to_uint pos.[tau] <= tau
  /\ forall m, 0 <= m < tau => to_uint pos.[m] < 256.

(* the 32-bit accumulators of chunk c: the first r after m + 1 positions,
   the others after m *)
op acc32 (acc : W256.t Array8.t) (s : W32.t Array256.t) (pos : W32.t Array_tau1.t)
  (c m r : int) =
  forall r' k, 0 <= r' < 8 => 0 <= k < 8 =>
    W32.to_sint (acc.[r'] \bits32 k) =
    runsum s pos (if r' < r then m + 1 else m) (64 * c + 8 * r' + k).

(* the 32-bit lanes of an unaligned load from the doubled polynomial *)
lemma load32_dint (d : W32.t Array512.t) (s : W32.t Array256.t) (o k : int) :
  doubled32_of d s => 0 <= o => o + 32 <= 2048 => o %% 4 = 0 => 0 <= k < 8 =>
  W32.to_sint (get256_direct (WArray2048.init32 (fun i => d.[i])) o \bits32 k) =
  dint s (o %/ 4 + k).
proof.
move=> hd h0 h1 h2 hk; rewrite PW512.load_bits32 //.
by have := hd (o %/ 4 + k) _; [smt() | rewrite /dint].
qed.

lemma tau_4096 : 0 < tau /\ tau * 4096 <= 245760 by smt(param_sets).

lemma acc32_zero (acc : W256.t Array8.t) (s : W32.t Array256.t) (pos : W32.t Array_tau1.t)
  (c : int) : (forall r, 0 <= r < 8 => acc.[r] = W256.zero) => acc32 acc s pos c 0 0.
proof.
move=> hz r k hr hk; rewrite hz // W8u32.get_zero to_sint32_0 /runsum /= ifT.
+ smt(W32.to_uint_cmp).
by rewrite ifF 1:/# /psum StdBigop.Bigint.BIA.big_geq.
qed.

lemma acc32_next (acc : W256.t Array8.t) (s : W32.t Array256.t) (pos : W32.t Array_tau1.t)
  (c m : int) : acc32 acc s pos c m 8 => acc32 acc s pos c (m + 1) 0.
proof. by move=> h r k hr hk; rewrite h // ifT 1:/# ifF 1:/#. qed.

(* the rotation by position m, added (m < np) or subtracted, in accumulator r *)
lemma acc32_step (acc : W256.t Array8.t) (d : W32.t Array512.t) (s : W32.t Array256.t)
    (pos : W32.t Array_tau1.t) (c m r : int) :
  prod_pre32 d pos s => 0 <= c < 4 => 0 <= m < tau => 0 <= r < 8 => acc32 acc s pos c m r =>
  acc32 acc.[r <- (if m < to_uint pos.[tau] then VPADD_8u32 else VPSUB_8u32) acc.[r]
                    (get256_direct (WArray2048.init32 (fun i => d.[i]))
                       (4 * (256 + 64 * c - to_uint pos.[m]) + 32 * r))]
    s pos c m (r + 1).
proof.
move=> [hs [hd [hn hpr]]] hc hm hr hacc r' k hr' hk; rewrite Array8.get_setE 1:/#.
case: (r' = r) => [->> | hne] /=; last by rewrite hacc //; smt().
have := hacc r k hr' hk; rewrite ltzz /= => ha; rewrite (_ : r < r + 1) 1:/# /=.
have hp := hpr m hm; have hp0 := W32.to_uint_cmp pos.[m].
have := load32_dint d s (4 * (256 + 64 * c - to_uint pos.[m]) + 32 * r) k hd _ _ _ hk.
+ smt().
+ smt().
+ smt().
rewrite (_ : (4 * (256 + 64 * c - to_uint pos.[m]) + 32 * r) %/ 4 + k =
             256 - to_uint pos.[m] + (64 * c + 8 * r + k)) 1:/# => hd32.
have hrs := runsumS s pos m (64 * c + 8 * r + k) _; 1: smt().
have hb := runsum_bnd s pos 4096 (m + 1) (64 * c + 8 * r + k) _ _ hs hn hpr; 1,2: smt().
have hte := tau_4096.
move: hrs; case: (m < to_uint pos.[tau]) => hlt /= hrs.
+ by rewrite VPADD_8u32_bits32 // W32.to_sintD_small ha hd32; smt().
by rewrite VPSUB_8u32_bits32 // W32.to_sintB_small ha hd32; smt().
qed.

(* ------------------------------------------------------------------ *)
(* __sparse_multiply_32: c * t0 on 32 bits (|c * t0| <= tau * 4096)     *)
(* ------------------------------------------------------------------ *)

lemma polynomial____sparse_multiply_32_ll : islossless M.polynomial____sparse_multiply_32.
proof.
proc; while (true) (4 - chunk).
+ move=> z; wp; while (true) (8 - r); 1: by move=> z'; auto => /#.
  wp; while (condition = (m < tau)) (tau - m).
  + move=> z'; wp; while (true) (8 - r); 1: by move=> z''; auto => /#.
    by auto => /#.
  wp; while (condition = (m < to_uint n_plus)) (to_uint n_plus - m).
  + move=> z'; wp; while (true) (8 - r); 1: by move=> z''; auto => /#.
    by auto => /#.
  wp; while (true) (8 - r); 1: by move=> z'; auto => /#.
  by auto => /#.
by auto => /#.
qed.

lemma polynomial____sparse_multiply_32_ok
    (_d : W32.t Array512.t) (_pos : W32.t Array_tau1.t) (_s : W32.t Array256.t) :
  hoare [ M.polynomial____sparse_multiply_32 :
    doubled = _d /\ positions = _pos /\ prod_pre32 _d _pos _s ==> prod_ok res.`1 _s _pos 256 ].
proof.
proc.
seq 5 : (doubled = _d /\ positions = _pos /\ prod_pre32 _d _pos _s
  /\ to_uint n_plus = to_uint _pos.[tau] /\ chunk = 0).
+ by auto => />; rewrite /SLH64.protect_64 W2u32.to_uint_zeroextu64.
while (0 <= chunk <= 4 /\ doubled = _d /\ positions = _pos /\ prod_pre32 _d _pos _s
  /\ to_uint n_plus = to_uint _pos.[tau] /\ prod_ok product _s _pos (64 * chunk));
  last by auto => /> &hr *; split => [| c ms p *]; [rewrite /prod_ok /# | smt()].
(* the stores of the accumulators *)
wp; while (0 <= r <= 8 /\ 0 <= chunk < 4 /\ doubled = _d /\ positions = _pos
  /\ prod_pre32 _d _pos _s /\ to_uint n_plus = to_uint _pos.[tau]
  /\ acc32 acc _s _pos chunk tau 0 /\ prod_ok product _s _pos (64 * chunk + 8 * r)).
+ auto => &hr [[#] hr0 hr8 hc0 hc1 -> -> hpre hnp hacc hok] hr /=.
  have [hs [hd [hn hpr]]] := hpre.
  do 5! (split; 1: smt()).
  rewrite /prod_ok => j hj.
  rewrite PW256.store_get 1..4:/#.
  rewrite (_ : 4 * (64 * chunk{hr} + 8 * r{hr}) %/ 4 = 64 * chunk{hr} + 8 * r{hr}) 1:/#.
  case: (64 * chunk{hr} + 8 * r{hr} <= j < 64 * chunk{hr} + 8 * r{hr} + 8) => h1.
  + rewrite hacc 1,2:/# ifF 1:/# -runsum_tau //.
    by rewrite (_ : 64 * chunk{hr} + 8 * r{hr} + (j - (64 * chunk{hr} + 8 * r{hr})) = j) 1:#ring.
  by apply hok; smt().
(* the rotations subtracted *)
wp; while (to_uint _pos.[tau] <= m <= tau /\ condition = (m < tau) /\ 0 <= chunk < 4
  /\ doubled = _d /\ positions = _pos /\ prod_pre32 _d _pos _s
  /\ to_uint n_plus = to_uint _pos.[tau] /\ acc32 acc _s _pos chunk m 0
  /\ prod_ok product _s _pos (64 * chunk)).
+ wp; while (0 <= r <= 8 /\ to_uint _pos.[tau] <= m < tau /\ 0 <= chunk < 4
    /\ doubled = _d /\ positions = _pos /\ prod_pre32 _d _pos _s
    /\ to_uint n_plus = to_uint _pos.[tau] /\ prod_ok product _s _pos (64 * chunk)
    /\ element = 4 * (256 + 64 * chunk - to_uint _pos.[m]) /\ acc32 acc _s _pos chunk m r).
  + auto => &hr [[#] hr0 hr8 hm0 hm1 hc0 hc1 -> -> hpre hnp hok -> hacc] hr /=.
    have := acc32_step _ _ _ _ _ _ _ hpre _ _ _ hacc; 1..3: smt(W32.to_uint_cmp).
    by rewrite ifF 1:/# => ->; smt().
  auto => &hr [[#] hm0 hm1 -> hc0 hc1 -> -> hpre hnp hacc hok] hc /=.
  rewrite /SLH64.protect_64 W2u32.to_uint_zeroextu64 /(`<<`) /=.
  split; 1: smt().
  by move=> acc0 r0 hr0 [#] *; split; [smt(acc32_next) | smt()].
(* the rotations added *)
wp; while (0 <= m <= to_uint _pos.[tau] /\ condition = (m < to_uint n_plus) /\ 0 <= chunk < 4
  /\ doubled = _d /\ positions = _pos /\ prod_pre32 _d _pos _s
  /\ to_uint n_plus = to_uint _pos.[tau] /\ acc32 acc _s _pos chunk m 0
  /\ prod_ok product _s _pos (64 * chunk)).
+ wp; while (0 <= r <= 8 /\ 0 <= m < to_uint _pos.[tau] /\ 0 <= chunk < 4
    /\ doubled = _d /\ positions = _pos /\ prod_pre32 _d _pos _s
    /\ to_uint n_plus = to_uint _pos.[tau] /\ prod_ok product _s _pos (64 * chunk)
    /\ element = 4 * (256 + 64 * chunk - to_uint _pos.[m]) /\ acc32 acc _s _pos chunk m r).
  + auto => &hr [[#] hr0 hr8 hm0 hm1 hc0 hc1 -> -> hpre hnp hok -> hacc] hr /=.
    have := acc32_step _ _ _ _ _ _ _ hpre _ _ _ hacc; 1..3: smt(W32.to_uint_cmp).
    by rewrite ifT 1:/# => ->; smt().
  auto => &hr [[#] hm0 hm1 -> hc0 hc1 -> -> hpre hnp hacc hok] hc /=.
  rewrite /SLH64.protect_64 W2u32.to_uint_zeroextu64 /(`<<`) /=.
  split; 1: smt().
  by move=> acc0 r0 hr0 [#] *; split; [smt(acc32_next) | smt()].
(* the accumulators cleared *)
wp; while (0 <= r <= 8 /\ 0 <= chunk < 4 /\ doubled = _d /\ positions = _pos
  /\ prod_pre32 _d _pos _s /\ to_uint n_plus = to_uint _pos.[tau]
  /\ prod_ok product _s _pos (64 * chunk) /\ forall r', 0 <= r' < r => acc.[r'] = W256.zero).
+ by auto => /> &hr *; split; [smt() | smt(Array8.get_setE)].
auto => &hr [#] hc0 _ -> -> hpre hnp hok hc2 /=.
have [_ [_ [hn _]]] := hpre.
split; 1: smt().
move=> acc0 r0 hr0 hI0; have h0 := acc32_zero acc0 _s _pos chunk{hr} _; 1: smt().
split; 1: smt(W32.to_uint_cmp).
move=> acc1 c1 m1 hc1' hI1; split; 1: smt().
move=> acc2 c2 m2 hc2' hI2; split; 1: smt().
move=> p0 r1 hr1 hI3.
by rewrite (_ : 64 * (chunk{hr} + 1) = 64 * chunk{hr} + 8 * r1) 1:/#; smt().
qed.

lemma polynomial____sparse_multiply_32_correct
    (_d : W32.t Array512.t) (_pos : W32.t Array_tau1.t) (_s _c : W32.t Array256.t) :
  hoare [ M.polynomial____sparse_multiply_32 :
       doubled = _d /\ positions = _pos
    /\ wpoly_srng 4095 4096 _s /\ doubled32_of _d _s
    /\ wpoly_srng 1 1 _c /\ challenge_shape (lifts_wpoly _c)
    /\ positions_of _pos (lifts_wpoly _c)
    ==>
       lifts_wpoly res.`1 = lifts_wpoly _c &* lifts_wpoly _s
    /\ wpoly_srng (tau * 4096) (tau * 4096) res.`1 ].
proof.
conseq (polynomial____sparse_multiply_32_ok _d _pos _s).
+ move=> &hr [#] -> -> hs hd _ hc hp /=; have [hn hpr] := positions_rng _ _ hc hp.
  by rewrite /prod_pre32 hd hn /=; split; [apply (wpoly_srng_widen _ 4095 4096) | exact hpr].
move=> &hr [#] _ _ hs _ _ hc hp p; apply prod_okP => //.
by apply (wpoly_srng_widen _ 4095 4096).
qed.

lemma polynomial____sparse_multiply_32_ph
    (_d : W32.t Array512.t) (_pos : W32.t Array_tau1.t) (_s _c : W32.t Array256.t) :
  phoare [ M.polynomial____sparse_multiply_32 :
       doubled = _d /\ positions = _pos
    /\ wpoly_srng 4095 4096 _s /\ doubled32_of _d _s
    /\ wpoly_srng 1 1 _c /\ challenge_shape (lifts_wpoly _c)
    /\ positions_of _pos (lifts_wpoly _c)
    ==>
       lifts_wpoly res.`1 = lifts_wpoly _c &* lifts_wpoly _s
    /\ wpoly_srng (tau * 4096) (tau * 4096) res.`1 ] = 1%r.
proof.
by conseq polynomial____sparse_multiply_32_ll
          (polynomial____sparse_multiply_32_correct _d _pos _s _c).
qed.

end SparseT.
