require import AllCore List IntDiv RealExp.

from Jasmin require import JModel_x86.

from JazzEC require import Ml_dsa_65_avx2 Mldsa_65_prelude.

require import CircuitBindings Bindings.

from Spec require import GFq Rq Parameters MLDSA_W32_Rep Symmetric Serialization.

import Round ZModQ Zq.

require import XArray256 Array256.

require import WArray1024.

(* FIXME: PY TRY WITH COMPUTATION *)

op check_inf_norm_circuit (_a : W32.t Array256.t) (_threshold : int) : bool =
   all (fun i => (W32.of_int (-_threshold) \slt _a.[i] /\ _a.[i] \slt W32.of_int (_threshold)))  (iotared 0 256).

lemma polynomial____check_infinity_norm_correct (_a : W32.t Array256.t) (_threshold : int) :
   hoare [ M.polynomial____check_infinity_norm :
       (* gamma1-Beta = 524092  or  gamma2-Beta = 261692  or  gamma2 = 261888 *)
       (_threshold = (1 `<<` gamma1m1_bits) - 49 * w1_bits \/
        _threshold = (q - 1) %/ 32 - 49 * w1_bits \/
        _threshold = (q - 1) %/ 32) /\
       polynomial = _a /\ threshold = _threshold /\
       wpoly_srng 6283009 6283008 _a
     ==>
       (wpoly_infnorm_lt _threshold _a => res = W64.zero) /\
       (!wpoly_infnorm_lt _threshold _a => res = W64.one)
   ].
proof.
rewrite /(`<<`) /=.
proc => /=.
seq 2 : (#pre /\ threshold_vector = W256.of_int (_threshold - 1)).
+ auto => />  Hdisj; elim Hdisj => [-> | [-> | ->]] /= Hrng.
  + rewrite /VMOV_64 /= to_uint_eq to_uint_zeroextu256 of_uintK /=.
    rewrite -(W128.of_uintK 524091); congr; rewrite wordP => i ib.
    rewrite /pack2_t initiE 1:/# /= get_of_list 1:/# /= of_intE /= bits2wE initiE 1:/# /=.
    case (i %/ 64 = 0) => ? /=.
    + rewrite of_intE /= bits2wE initiE 1:/# /=.
      by rewrite /BitEncoding.BS2Int.int2bs nth_mkseq 1:/# /= nth_mkseq 1:/# /= /#.
    rewrite /BitEncoding.BS2Int.int2bs nth_mkseq 1:/# /=.
    rewrite pdiv_small; last by smt().
    smt(StdOrder.IntOrder.ler_lt_trans StdOrder.IntOrder.ler_weexpn2l pow2_64).
  + rewrite /VMOV_64 /= to_uint_eq to_uint_zeroextu256 of_uintK /=.
    rewrite -(W128.of_uintK 261691); congr; rewrite wordP => i ib.
    rewrite /pack2_t initiE 1:/# /= get_of_list 1:/# /= of_intE /= bits2wE initiE 1:/# /=.
    case (i %/ 64 = 0) => ? /=.
    + rewrite of_intE /= bits2wE initiE 1:/# /=.
      by rewrite /BitEncoding.BS2Int.int2bs nth_mkseq 1:/# /= nth_mkseq 1:/# /= /#.
    rewrite /BitEncoding.BS2Int.int2bs nth_mkseq 1:/# /=.
    rewrite pdiv_small; last by smt().
    smt(StdOrder.IntOrder.ler_lt_trans StdOrder.IntOrder.ler_weexpn2l pow2_64).
  + (* gamma2 = 261888, threshold_vector = W256.of_int 261887 *)
    rewrite /VMOV_64 /= to_uint_eq to_uint_zeroextu256 of_uintK /=.
    rewrite -(W128.of_uintK 261887); congr; rewrite wordP => i ib.
    rewrite /pack2_t initiE 1:/# /= get_of_list 1:/# /= of_intE /= bits2wE initiE 1:/# /=.
    case (i %/ 64 = 0) => ? /=.
    + rewrite of_intE /= bits2wE initiE 1:/# /=.
      by rewrite /BitEncoding.BS2Int.int2bs nth_mkseq 1:/# /= nth_mkseq 1:/# /= /#.
    rewrite /BitEncoding.BS2Int.int2bs nth_mkseq 1:/# /=.
    rewrite pdiv_small; last by smt().
    smt(StdOrder.IntOrder.ler_lt_trans StdOrder.IntOrder.ler_weexpn2l pow2_64).

proc change ^while.1 : { coefficients <- if (0 <= offset*8 <= 32*256-256)
                                         then BSWAS_256u32_256.sliceget polynomial (offset*8)
                                         else get256_direct (WArray1024.init32 (fun i => polynomial.[i])) offset; }.
                + auto => /> &2.
                  case (0 <= offset{2} * 8 <= 7936); last by auto.
                  by move => ?; rewrite BSWAS_256u32_256_slicegetE /#.

wp 6.
proc change 6 : { zf <- msb_mask = W32.zero; }.
+ by auto => /= &1 &2 ->; rewrite /TEST_32 /rflags_of_bwop /= /ZF_of  /=.

unroll for ^while.
cfold 131.
wp -1.
conseq (: polynomial = _a /\ threshold_vector = W256.of_int (_threshold - 1) /\
        List.all (fun i => W32.of_int (-6283009) \sle _a.[i]
               /\ _a.[i] \sle  W32.of_int 6283008) (iotared 0 256) /\
          (_threshold = 524092 \/ _threshold = 261692 \/ _threshold = 261888)  ==>
    zf = (check_inf_norm_circuit _a _threshold)).

(*  Connect circuit form to poly_infnorm spec *)
+ move => &1 [#] ? <- ? + ?; rewrite /wpoly_srng iotaredE /(\sle) !of_sintK /smod !allP /=;smt(mem_iota).

move => &hr [#] Hdij <- Ht Hr ? zf  -> /=.
rewrite /check_inf_norm_circuit !allP /SETcc;
split; rewrite iotaredE /= => H4.
+ rewrite ifF /=.
  + rewrite /(\slt) /= !of_sintK /= /smod /=.
    move => x; rewrite mem_iota => ?.
    move : H4; rewrite /wpoly_infnorm_lt /wpoly_srng allP /= /#.
  by rewrite to_uint_eq /=.
rewrite ifT /=.
  + rewrite /(\slt) /= !of_sintK /= /smod /=.
    move : H4; rewrite /wpoly_infnorm_lt /wpoly_srng allP /=; smt(mem_iota).
  by rewrite to_uint_eq /=.

  (* Handle the circuit *)
case (_threshold = 524092).
+ conseq (: polynomial = _a /\ threshold_vector = W256.of_int 524091 /\
       List.all (fun i => W32.of_int (-6283009) \sle _a.[i]
               /\ _a.[i] \sle  W32.of_int 6283008) (iotared 0 256)
          ==>
    zf = (check_inf_norm_circuit _a 524092));
    [ by smt() | by smt() | by simplify;circuit].
case (_threshold = 261692).
+ conseq (: polynomial = _a /\ threshold_vector = W256.of_int 261691 /\
       List.all (fun i => W32.of_int (-6283009) \sle _a.[i]
               /\ _a.[i] \sle  W32.of_int 6283008) (iotared 0 256)
          ==>
    zf = (check_inf_norm_circuit _a 261692));
    [ by smt() | by smt() | by simplify;circuit].
(* gamma2 = 261888: threshold_vector = W256.of_int 261887 *)
+ conseq (: polynomial = _a /\ threshold_vector = W256.of_int 261887 /\
       List.all (fun i => W32.of_int (-6283009) \sle _a.[i]
               /\ _a.[i] \sle  W32.of_int 6283008) (iotared 0 256)
          ==>
    zf = (check_inf_norm_circuit _a 261888));
    [ by smt() | by smt() | by simplify;circuit].
qed.

lemma polynomial____check_infinity_norm_ll : islossless M.polynomial____check_infinity_norm.
proof.
proc.
wp;while (0 <= offset <= 1024 /\ offset %% 32 = 0) (1024 - offset); auto => /> /#.
qed.

lemma polynomial____check_infinity_norm_ph (_a : W32.t Array256.t) (_threshold : int) :
   phoare [ M.polynomial____check_infinity_norm :
       (* gamma1-Beta = 524092  or  gamma2-Beta = 261692  or  gamma2 = 261888 *)
       (_threshold = (1 `<<` gamma1m1_bits) - 49 * w1_bits \/
        _threshold = (q - 1) %/ 32 - 49 * w1_bits \/
        _threshold = (q - 1) %/ 32) /\
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
(* polynomial____zero                                                    *)
(* Sets all 256 coefficients to zero.                                  *)
(* ================================================================== *)

lemma polynomial____zero_ll : islossless M.polynomial____zero.
proof.
proc.
wp; while (0 <= offset <= (256 * 32) %/ 8 /\ offset %% 32 = 0)
         ((256 * 32) %/ 8 - offset); last by auto => /#.
by move => *; auto => /#.
qed.

lemma polynomial____zero_correct (_a : W32.t Array256.t) :
    hoare [ M.polynomial____zero :
        polynomial = _a
        ==>
        (forall i, 0 <= i < 256 => res.[i] = W32.zero) /\
        wpoly_srng 0 0 res
    ].
proof.
proc => /=.
proc change ^while.1 : { polynomial <- if (0 <= offset*8 <= 32*256-256)
                                       then BSWAS_256u32_256.sliceset polynomial (offset*8) zero_u256
                                       else Array256.init (get32 (set256_direct (WArray1024.init32 (fun (i_0 : int) => polynomial.[i_0])) offset zero_u256)); }.
+ auto => /> &2.
  case (0 <= offset{2} * 8 <= 7936); last by auto.
  by move => ?; rewrite BSWAS_256u32_256_slicesetE /#.
unroll for ^while.
cfold 1.
wp 32.
conseq (: polynomial = _a ==> polynomial = BSWA_256u32.init (fun (_:int) => W32.zero)); last by circuit.
move => &hr _ p0 ->; split.
+ by move => i Hi; rewrite /BSWA_256u32.init initiE 1:/#.
+ rewrite /wpoly_srng /BSWA_256u32.init allP => k kb /=.
  rewrite initiE 1:/# /=.
  by rewrite /to_sint /smod /=.
qed.

lemma polynomial____zero_ph (_a : W32.t Array256.t) :
    phoare [ M.polynomial____zero :
        polynomial = _a
        ==>
        (forall i, 0 <= i < 256 => res.[i] = W32.zero) /\
        wpoly_srng 0 0 res
    ] = 1%r
  by conseq polynomial____zero_ll (polynomial____zero_correct _a).

(* ================================================================== *)
(* polynomial____pointwise_add_to_total                                  *)
(* Pointwise addition into accumulator: total += polynomial.           *)
(* Identical semantics to polynomial__add.                             *)
(* ================================================================== *)

lemma polynomial____pointwise_add_to_total_ll :
    islossless M.polynomial____pointwise_add_to_total.
proof.
proc.
wp; while (0 <= offset <= (256 * 32) %/ 8 /\ offset %% 32 = 0)
         ((256 * 32) %/ 8 - offset); last by auto => /#.
by move => *; auto => /#.
qed.

lemma polynomial____pointwise_add_to_total_correct
      (_total : W32.t Array256.t) (_poly : W32.t Array256.t) (A B : int) :
    hoare [ M.polynomial____pointwise_add_to_total :
        total = _total /\ polynomial = _poly /\
        wpoly_srng A A _total /\ wpoly_srng B B _poly /\ A + B < 2^31
        ==>
        lifts_wpoly res = lifts_wpoly _total &+ lifts_wpoly _poly /\
        wpoly_srng (A + B) (A + B) res
    ].
proof.
proc => /=.
proc change ^while.1 : { lhs <- if (0 <= offset*8 <= 32*256-256) then BSWAS_256u32_256.sliceget polynomial (offset*8) else get256_direct (WArray1024.init32 (fun (i_0:int) => polynomial.[i_0])) offset; }.
+ auto => /> &2.
  case (0 <= offset{2} * 8 <= 7936); last by auto.
  by move => Ha _ _ _; rewrite -BSWAS_256u32_256_slicegetE 1:/#.
proc change ^while.2 : { rhs <- if (0 <= offset*8 <= 32*256-256) then BSWAS_256u32_256.sliceget total (offset*8) else get256_direct (WArray1024.init32 (fun (i_0:int) => total.[i_0])) offset; }.
+ auto => /> &2.
  case (0 <= offset{2} * 8 <= 7936); last by auto.
  by move => Ha _ _ _; rewrite -BSWAS_256u32_256_slicegetE 1:/#.
proc change ^while.4 : { total <- if (0 <= offset*8 <= 32*256-256) then BSWAS_256u32_256.sliceset total (offset*8) sum else Array256.init (get32 (set256_direct (WArray1024.init32 (fun (i_0:int) => total.[i_0])) offset sum)); }.
+ auto => /> &2.
  case (0 <= offset{2} * 8 <= 7936); last by auto.
  by move => Ha _ _ _; rewrite BSWAS_256u32_256_slicesetE 1:/#.
unroll for ^while.
wp 128.
conseq (: total = _total /\ polynomial = _poly /\ wpoly_srng A A _total /\ wpoly_srng B B _poly /\ A + B < 2^31 ==> total = BSWA_256u32.init (fun (i:int) => _poly.[i] + _total.[i])); last by circuit.
move => &hr [# _ _ HsA HsB Hab] p0 ->.
move: HsA HsB; rewrite /wpoly_srng !allP => HsA HsB.
split.
+ apply Array256.tP => i Hi.
  rewrite /lifts_wpoly /BSWA_256u32.init mapiE 1:/# /= initiE 1:/# /= poly_addE 1:/# !mapiE 1,2:/# /=.
  have /= HA := HsA i Hi. have /= HB := HsB i Hi.
  rewrite to_sintD_small 1:/#.
  by rewrite incoeffD; ring.
+ move => k kb.
  have /= HA := HsA k kb. have /= HB := HsB k kb.
  rewrite /BSWA_256u32.init initiE 1:/# /=.
  by rewrite to_sintD_small 1:/#; smt().
qed.

lemma polynomial____pointwise_add_to_total_ph
      (_total : W32.t Array256.t) (_poly : W32.t Array256.t) (A B : int) :
    phoare [ M.polynomial____pointwise_add_to_total :
        total = _total /\ polynomial = _poly /\
        wpoly_srng A A _total /\ wpoly_srng B B _poly /\ A + B < 2^31
        ==>
        lifts_wpoly res = lifts_wpoly _total &+ lifts_wpoly _poly /\
        wpoly_srng (A + B) (A + B) res
    ] = 1%r
  by conseq polynomial____pointwise_add_to_total_ll
            (polynomial____pointwise_add_to_total_correct _total _poly A B).

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
