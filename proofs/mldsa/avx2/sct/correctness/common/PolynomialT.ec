require import AllCore List IntDiv RealExp.
from Jasmin require import JModel_x86.
require import CircuitBindings Bindings.
from Spec require import GFq Rq Parameters MLDSA_W32_Rep.
require import XArray256 Array256 WArray1024.
require BaseT.

(* The polynomial routines of the implementation: infinity-norm check,
   addition, subtraction, shift. They do
   not depend on the parameter set; the norm check holds for any threshold
   that fits in 31 bits. *)
abstract theory PolynomialT.

clone import BaseT.BaseT as B.
import S R.
import Round ZModQ Zq.

(* ================================================================== *)
(* polynomial____check_infinity_norm                                    *)
(* ================================================================== *)

op abs32 (w : W32.t) : W32.t = if w \slt W32.zero then - w else w.

op check_inf_norm_w (_a : W32.t Array256.t) (tw : W32.t) : bool =
  all (fun i => !(tw \slt abs32 _a.[i])) (iotared 0 256).

(* The broadcast threshold: the low 32 bits of a 64-bit VMOV. *)
lemma vmov_truncate (x : W64.t) : truncateu32 (zeroextu256 (VMOV_64 x)) = truncateu32 x.
proof.
rewrite /truncateu32 to_uint_zeroextu256 /VMOV_64.
have -> : pack2 [x; W64.zero] = W2u64.zeroextu128 x.
+ apply W128.wordP => i hi; rewrite pack2wE //= /zeroextu128 W128.of_intwE hi /= W64.get_to_uint.
  case: (i %/ 64 = 0) => hd /=.
  + rewrite hd get_of_list // /= (_ : i %% 64 = i) 1:/# /int_bit.
    rewrite (_ : 0 <= i < 64) 1:/# /= (pmod_small (to_uint x)); 2: done.
    smt(W64.to_uint_cmp StdOrder.IntOrder.ler_weexpn2l pow2_64).
  rewrite get_of_list 1:/# (_ : i %/ 64 = 1) 1:/# /= /int_bit.
  have hx := W64.to_uint_cmp x.
  have h64 : 2 ^ 64 <= 2 ^ i by apply StdOrder.IntOrder.ler_weexpn2l => /#.
  rewrite (pmod_small (to_uint x)); 1: smt(pow2_64).
  by rewrite divz_small; smt(pow2_64).
by rewrite to_uint_zeroextu128.
qed.

lemma cin_circuit (_a : W32.t Array256.t) (tw : W32.t) :
  hoare [ M.polynomial____check_infinity_norm :
    polynomial = _a /\ truncateu32 (W64.of_int (threshold - 1)) = tw
    ==> res = zeroextu64 (SETcc (! check_inf_norm_w _a tw)) ].
proof.
proc => /=.
seq 3 : (polynomial = _a /\ threshold_vector = VPBROADCAST_8u32 tw).
+ by auto => /> &hr; rewrite vmov_truncate.
proc change ^while.1 : { coefficients <- if (0 <= offset*8 <= 32*256-256)
                                         then BSWAS_256u32_256.sliceget polynomial (offset*8)
                                         else get256_direct (WArray1024.init32 (fun i => polynomial.[i])) offset; }.
+ auto => /> &2.
  case (0 <= offset{2} * 8 <= 7936); last by auto.
  by move => ?; rewrite BSWAS_256u32_256_slicegetE /#.
proc change 4 : { zf <- exceeds_any = W256.zero; }.
+ by auto => /= &1 &2 ->; rewrite /VPTEST_256 /= /ZF_of W256.andwK.
unroll for ^while.
wp -2.
conseq (: polynomial = _a /\ threshold_vector = VPBROADCAST_8u32 tw ==> zf = check_inf_norm_w _a tw).
+ by move=> &hr _ zf ->.
cfold 130.
wp -1.
by circuit.
qed.

lemma abs32_bnd (x : W32.t) (t : int) :
  1 <= t < 2147483648 => -6283009 <= W32.to_sint x <= 6283008 =>
  (!(W32.of_int (t - 1) \slt abs32 x)) = (-(t - 1) <= W32.to_sint x <= t - 1).
proof.
move=> [ht1 ht2] [hx1 hx2].
have hst : W32.to_sint (W32.of_int (t - 1)) = t - 1.
+ rewrite W32.to_sintE W32.of_uintK /smod (pmod_small (t - 1)) 1:/#.
  by rewrite ifF //; smt().
rewrite /(\slt) hst /abs32 /(\slt) /=.
case: (W32.to_sint x < W32.to_sint W32.zero) => hneg.
+ have -> : W32.to_sint (-x) = - W32.to_sint x.
  * move: hx1 hx2; rewrite !W32.to_sintE W32.to_uintN /smod /=.
    have := W32.to_uint_cmp x; smt().
  have h0 : W32.to_sint W32.zero = 0 by rewrite W32.to_sintE /smod.
  smt().
have h0 : W32.to_sint W32.zero = 0 by rewrite W32.to_sintE /smod.
smt().
qed.

(* The threshold the tests broadcast, t - 1, as a 32-bit word. *)
lemma threshold_truncate (t : int) :
  1 <= t < 2147483648 => truncateu32 (W64.of_int (t - 1)) = W32.of_int (t - 1).
proof.
by move=> ht; rewrite /truncateu32 W64.of_uintK (pmod_small (t - 1)) //; smt(pow2_64).
qed.

(* The circuit-level test is the infinity-norm predicate on centred inputs. *)
lemma check_inf_normE (_a : W32.t Array256.t) (t : int) :
  1 <= t < 2147483648 => wpoly_srng 6283009 6283008 _a =>
  check_inf_norm_w _a (W32.of_int (t - 1)) = wpoly_infnorm_lt t _a.
proof.
move=> [ht1 ht2] hrng.
rewrite /check_inf_norm_w /wpoly_infnorm_lt /wpoly_srng iotaredE eq_iff; split.
+ move=> h; rewrite Array256.allP => i hi.
  move: hrng h; rewrite /wpoly_srng Array256.allP List.allP => /(_ i hi) hr /(_ i _).
  + by rewrite mem_iota /#.
  by move: hr => /= hr; rewrite abs32_bnd /#.
move=> h; rewrite List.allP => i /mem_iota hi /=.
move: hrng h; rewrite /wpoly_srng !Array256.allP => hr1 hr2.
have /= h1 := hr1 i _; 1: smt().
have /= h2 := hr2 i _; 1: smt().
by rewrite abs32_bnd /#.
qed.

(* The test result as returned: zero when the norm is below t, one otherwise. *)
lemma check_inf_norm_res (_a : W32.t Array256.t) (t : int) :
  1 <= t < 2147483648 => wpoly_srng 6283009 6283008 _a =>
  (wpoly_infnorm_lt t _a =>
     zeroextu64 (SETcc (! check_inf_norm_w _a (W32.of_int (t - 1)))) = W64.zero) /\
  (!wpoly_infnorm_lt t _a =>
     zeroextu64 (SETcc (! check_inf_norm_w _a (W32.of_int (t - 1)))) = W64.one).
proof.
move=> ht hrng; rewrite check_inf_normE //.
by case: (wpoly_infnorm_lt t _a) => h /=; rewrite /SETcc /= /zeroextu64.
qed.

lemma polynomial____check_infinity_norm_correct (_a : W32.t Array256.t) (_threshold : int) :
   hoare [ M.polynomial____check_infinity_norm :
       1 <= _threshold < 2147483648 /\
       polynomial = _a /\ threshold = _threshold /\
       wpoly_srng 6283009 6283008 _a
     ==>
       (wpoly_infnorm_lt _threshold _a => res = W64.zero) /\
       (!wpoly_infnorm_lt _threshold _a => res = W64.one)
   ].
proof.
conseq (cin_circuit _a (W32.of_int (_threshold - 1))).
+ by move=> &hr [#] ht1 ht2 -> -> _ /=; rewrite threshold_truncate.
move=> &hr [#] ht1 ht2 _ _ hrng r ->.
by apply (check_inf_norm_res _a _threshold).
qed.

lemma polynomial____check_infinity_norm_ll : islossless M.polynomial____check_infinity_norm.
proof.
proc.
wp;while (0 <= offset <= 1024 /\ offset %% 32 = 0) (1024 - offset); auto => /> /#.
qed.

lemma polynomial____check_infinity_norm_ph (_a : W32.t Array256.t) (_threshold : int) :
   phoare [ M.polynomial____check_infinity_norm :
       1 <= _threshold < 2147483648 /\
       polynomial = _a /\ threshold = _threshold /\
       wpoly_srng 6283009 6283008 _a
     ==>
       (wpoly_infnorm_lt _threshold _a => res = W64.zero) /\
       (!wpoly_infnorm_lt _threshold _a => res = W64.one)
   ] = 1%r
 by conseq polynomial____check_infinity_norm_ll (polynomial____check_infinity_norm_correct _a _threshold).

(* ================================================================== *)
(* polynomial__add                                                      *)
(* Pointwise addition without reduction.                               *)
(* Spec: lifts_wpoly res = lifts_wpoly _lhs + lifts_wpoly _rhs        *)
(* No range restriction: result may need reduce32 afterwards.          *)
(* ================================================================== *)

lemma polynomial__add_ll : islossless M.polynomial__add.
proof.
proc.
wp; while (0 <= offset <= (256 * 32) %/ 8 /\ offset %% 32 = 0)
         ((256 * 32) %/ 8 - offset); last by auto => /#.
by move => *; auto => /#.
qed.

lemma polynomial__add_correct
      (_sum : W32.t Array256.t) (_lhs : W32.t Array256.t) (_rhs : W32.t Array256.t)
      (A B : int) :
    hoare [ M.polynomial__add :
        sum_pointer = _sum /\ lhs_pointer = _lhs /\ rhs_pointer = _rhs /\
        wpoly_srng A A _lhs /\ wpoly_srng B B _rhs /\ A + B < 2^31
        ==>
        lifts_wpoly res = lifts_wpoly _lhs &+ lifts_wpoly _rhs /\
        wpoly_srng (A + B) (A + B) res
    ].
proof.
proc => /=.
proc change ^while.1 : { lhs <- if (0 <= offset*8 <= 32*256-256) then BSWAS_256u32_256.sliceget lhs_pointer (offset*8) else get256_direct (WArray1024.init32 (fun (i_0:int) => lhs_pointer.[i_0])) offset; }.
+ auto => /> &2.
  case (0 <= offset{2} * 8 <= 7936); last by auto.
  by move => Ha _ _ _; rewrite -BSWAS_256u32_256_slicegetE 1:/#.
proc change ^while.2 : { rhs <- if (0 <= offset*8 <= 32*256-256) then BSWAS_256u32_256.sliceget rhs_pointer (offset*8) else get256_direct (WArray1024.init32 (fun (i_0:int) => rhs_pointer.[i_0])) offset; }.
+ auto => /> &2.
  case (0 <= offset{2} * 8 <= 7936); last by auto.
  by move => Ha _ _ _; rewrite -BSWAS_256u32_256_slicegetE 1:/#.
proc change ^while.4 : { sum_pointer <- if (0 <= offset*8 <= 32*256-256) then BSWAS_256u32_256.sliceset sum_pointer (offset*8) sum else Array256.init (get32 (set256_direct (WArray1024.init32 (fun (i_0:int) => sum_pointer.[i_0])) offset sum)); }.
+ auto => /> &2.
  case (0 <= offset{2} * 8 <= 7936); last by auto.
  by move => Ha _ _ _; rewrite BSWAS_256u32_256_slicesetE 1:/#.
unroll for ^while.
wp 128.
conseq (: sum_pointer = _sum /\ lhs_pointer = _lhs /\ rhs_pointer = _rhs /\ wpoly_srng A A _lhs /\ wpoly_srng B B _rhs /\ A + B < 2^31 ==> sum_pointer = BSWA_256u32.init (fun (i:int) => _lhs.[i] + _rhs.[i])); last by circuit.
move => &hr [# _ _ _ HsA HsB Hab] p0 ->.
move: HsA HsB; rewrite /wpoly_srng !allP => HsA HsB.
split.
+ apply Array256.tP => i Hi.
  rewrite /lifts_wpoly /BSWA_256u32.init mapiE 1:/# /= initiE 1:/# /= poly_addE 1:/# !mapiE 1,2:/# /=.
  have /= HA := HsA i Hi. have /= HB := HsB i Hi.
  rewrite to_sintD_small 1:/#.
  by rewrite incoeffD.
+ move => k kb.
  have /= HA := HsA k kb. have /= HB := HsB k kb.
  rewrite /BSWA_256u32.init initiE 1:/# /=.
  by rewrite to_sintD_small 1:/#; smt().
qed.

lemma polynomial__add_ph
      (_sum : W32.t Array256.t) (_lhs : W32.t Array256.t) (_rhs : W32.t Array256.t)
      (A B : int) :
    phoare [ M.polynomial__add :
        sum_pointer = _sum /\ lhs_pointer = _lhs /\ rhs_pointer = _rhs /\
        wpoly_srng A A _lhs /\ wpoly_srng B B _rhs /\ A + B < 2^31
        ==>
        lifts_wpoly res = lifts_wpoly _lhs &+ lifts_wpoly _rhs /\
        wpoly_srng (A + B) (A + B) res
    ] = 1%r
  by conseq polynomial__add_ll (polynomial__add_correct _sum _lhs _rhs A B).

(* ================================================================== *)
(* polynomial__subtract                                                 *)
(* Pointwise subtraction without reduction.                            *)
(* Spec: lifts_wpoly res = lifts_wpoly _lhs - lifts_wpoly _rhs        *)
(* No range restriction: result may need reduce32 afterwards.          *)
(* ================================================================== *)

lemma polynomial__subtract_ll : islossless M.polynomial__subtract.
proof.
proc.
wp; while (0 <= offset <= (256 * 32) %/ 8 /\ offset %% 32 = 0)
         ((256 * 32) %/ 8 - offset); last by auto => /#.
by move => *; auto => /#.
qed.

lemma polynomial__subtract_correct
      (_diff : W32.t Array256.t) (_lhs : W32.t Array256.t) (_rhs : W32.t Array256.t)
      (A B : int) :
    hoare [ M.polynomial__subtract :
        difference_pointer = _diff /\ lhs_pointer = _lhs /\ rhs_pointer = _rhs /\
        wpoly_srng A A _lhs /\ wpoly_srng B B _rhs /\ A + B < 2^31
        ==>
        lifts_wpoly res = lifts_wpoly _lhs &+ ((&-) (lifts_wpoly _rhs)) /\
        wpoly_srng (A + B) (A + B) res
    ].
proof.
proc => /=.
proc change ^while.1 : { lhs <- if (0 <= offset*8 <= 32*256-256) then BSWAS_256u32_256.sliceget lhs_pointer (offset*8) else get256_direct (WArray1024.init32 (fun (i_0:int) => lhs_pointer.[i_0])) offset; }.
+ auto => /> &2.
  case (0 <= offset{2} * 8 <= 7936); last by auto.
  by move => Ha _ _ _; rewrite -BSWAS_256u32_256_slicegetE 1:/#.
proc change ^while.2 : { rhs <- if (0 <= offset*8 <= 32*256-256) then BSWAS_256u32_256.sliceget rhs_pointer (offset*8) else get256_direct (WArray1024.init32 (fun (i_0:int) => rhs_pointer.[i_0])) offset; }.
+ auto => /> &2.
  case (0 <= offset{2} * 8 <= 7936); last by auto.
  by move => Ha _ _ _; rewrite -BSWAS_256u32_256_slicegetE 1:/#.
proc change ^while.4 : { difference_pointer <- if (0 <= offset*8 <= 32*256-256) then BSWAS_256u32_256.sliceset difference_pointer (offset*8) difference else Array256.init (get32 (set256_direct (WArray1024.init32 (fun (i_0:int) => difference_pointer.[i_0])) offset difference)); }.
+ auto => /> &2.
  case (0 <= offset{2} * 8 <= 7936); last by auto.
  by move => Ha _ _ _; rewrite BSWAS_256u32_256_slicesetE 1:/#.
unroll for ^while.
wp 128.
conseq (: difference_pointer = _diff /\ lhs_pointer = _lhs /\ rhs_pointer = _rhs /\ wpoly_srng A A _lhs /\ wpoly_srng B B _rhs /\ A + B < 2^31 ==> difference_pointer = BSWA_256u32.init (fun (i:int) => _lhs.[i] - _rhs.[i])); last by circuit.
move => &hr [# _ _ _ HsA HsB Hab] p0 ->.
move: HsA HsB; rewrite /wpoly_srng !allP => HsA HsB.
split.
+ apply Array256.tP => i Hi.
  rewrite /lifts_wpoly /BSWA_256u32.init mapiE 1:/# /= initiE 1:/# /= poly_addE 1:/#.
  have /= HA := HsA i Hi. have /= HB := HsB i Hi.
  rewrite poly_negE 1:/# !mapiE 1,2:/# /= to_sintB_small 1:/#.
  by rewrite incoeffB.
+ move => k kb.
  have /= HA := HsA k kb. have /= HB := HsB k kb.
  rewrite /BSWA_256u32.init initiE 1:/# /=.
  by rewrite to_sintB_small 1:/#; smt().
qed.

lemma polynomial__subtract_ph
      (_diff : W32.t Array256.t) (_lhs : W32.t Array256.t) (_rhs : W32.t Array256.t)
      (A B : int) :
    phoare [ M.polynomial__subtract :
        difference_pointer = _diff /\ lhs_pointer = _lhs /\ rhs_pointer = _rhs /\
        wpoly_srng A A _lhs /\ wpoly_srng B B _rhs /\ A + B < 2^31
        ==>
        lifts_wpoly res = lifts_wpoly _lhs &+ ((&-) (lifts_wpoly _rhs)) /\
        wpoly_srng (A + B) (A + B) res
    ] = 1%r
  by conseq polynomial__subtract_ll (polynomial__subtract_correct _diff _lhs _rhs A B).

(* ================================================================== *)
(* polynomial____shift_coefficients_left                                 *)
(* Left-shifts all coefficients by d = 13 bits.                        *)
(* Used in verify to reconstruct t1 * 2^d.                            *)
(* ================================================================== *)

lemma polynomial____shift_coefficients_left_ll :
    islossless M.polynomial____shift_coefficients_left.
proof.
proc.
wp; while (0 <= offset <= (256 * 32) %/ 8 /\ offset %% 32 = 0)
         ((256 * 32) %/ 8 - offset); last by auto => /#.
by move => *; auto => /#.
qed.

(* Pre/post tightened 2026-04-17: pre from wpoly_urng (2^10+1) = values ≤ 2^10    *)
(* to wpoly_urng (2^10) = values ≤ 2^10 - 1 (matches t1_decode's output bound     *)
(* b_t1 + 1 = 2^10). Post from wpoly_srng (2^10 * 2^d) ≥ q bound to                *)
(* wpoly_srng (q-1) (q-1): tight since (2^10 - 1) * 2^d = q - 1 exactly.          *)
lemma polynomial____shift_coefficients_left_correct (_a : W32.t Array256.t) :
    hoare [ M.polynomial____shift_coefficients_left :
        polynomial = _a /\
        wpoly_urng (2^10) _a       (* t1 range: [0, 2^10 - 1] = [0, b_t1] *)
        ==>
        (forall i, 0 <= i < 256 =>
            W32.to_sint res.[i] = W32.to_uint _a.[i] * 2^d) /\
        wpoly_srng (q-1) (q-1) res
    ].
proof.
proc => /=.
proc change ^while.1 : { coefficients <- if (0 <= offset*8 <= 32*256-256) then BSWAS_256u32_256.sliceget polynomial (offset*8) else get256_direct (WArray1024.init32 (fun (i_0:int) => polynomial.[i_0])) offset; }; first (auto => /> &2; case (0 <= offset{2} * 8 <= 7936); [by move => *; rewrite -BSWAS_256u32_256_slicegetE 1:/# | by auto]).
proc change ^while.3 : { polynomial <- if (0 <= offset*8 <= 32*256-256) then BSWAS_256u32_256.sliceset polynomial (offset*8) coefficients else Array256.init (get32 (set256_direct (WArray1024.init32 (fun (i_0:int) => polynomial.[i_0])) offset coefficients)); }; first (auto => /> &2; case (0 <= offset{2} * 8 <= 7936); [by move => *; rewrite BSWAS_256u32_256_slicesetE 1:/# | by auto]).
unroll for ^while.
wp 96.
conseq (: polynomial = _a /\ wpoly_urng 1024 _a ==> polynomial = BSWA_256u32.init (fun (i:int) => _a.[i] * (W32.of_int 8192))); last by circuit.
move => &hr [# _ H2] p0 ->; move: H2; rewrite /wpoly_urng !allP => H2; split.
+ move => i Hi; have /= Hb := H2 i Hi; rewrite /BSWA_256u32.init initiE 1:/# /=.
  by rewrite to_sintE to_uintM of_uintK /smod /=; smt().
rewrite /wpoly_srng allP => k kb; have /= Hbk := H2 k kb; rewrite /BSWA_256u32.init initiE 1:/# /= to_sintE to_uintM of_uintK /smod /=; smt().
qed.

lemma polynomial____shift_coefficients_left_ph (_a : W32.t Array256.t) :
    phoare [ M.polynomial____shift_coefficients_left :
        polynomial = _a /\
        wpoly_urng (2^10) _a
        ==>
        (forall i, 0 <= i < 256 =>
            W32.to_sint res.[i] = W32.to_uint _a.[i] * 2^d) /\
        wpoly_srng (q-1) (q-1) res
    ] = 1%r
  by conseq polynomial____shift_coefficients_left_ll
            (polynomial____shift_coefficients_left_correct _a).

end PolynomialT.
