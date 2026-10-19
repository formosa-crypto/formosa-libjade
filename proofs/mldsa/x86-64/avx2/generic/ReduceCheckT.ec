require import AllCore List IntDiv RealExp.
from Jasmin require import JModel_x86.
require import CircuitBindings Bindings MldsaConstants.
from Spec require import GFq Rq Parameters MLDSA_W32_Rep.
require import XArray256 Array256 WArray1024.
require BaseT PolynomialT CommonReduceT.

(* The fused passes of the signing norm tests: an addition (or a
   subtraction), reduce32 and the infinity-norm test of the reduced
   polynomial, in one pass over the coefficients. *)
abstract theory ReduceCheckT.

clone import BaseT.BaseT as B.
import S R.
import Round ZModQ Zq.

clone import PolynomialT.PolynomialT as PL with theory B <- B.
clone import CommonReduceT.CommonReduceT as CR with theory B <- B.

(* ================================================================== *)
(* Coefficient-level facts                                              *)
(* ================================================================== *)

lemma add_reduce32E (_l _r : W32.t Array256.t) (A B : int) :
    wpoly_srng A A _l => wpoly_srng B B _r => A + B <= 2^31 - 2^22 - 1 =>
    let s = BSWA_256u32.init (fun i => reduce32_w (_l.[i] + _r.[i])) in
    lifts_wpoly s = lifts_wpoly _l &+ lifts_wpoly _r /\
    wpoly_srng 6283009 6283008 s.
proof.
rewrite /wpoly_srng !allP => HA HB /= Hab.
have Hc : forall i, 0 <= i < 256 =>
  incoeff (to_sint (reduce32_w (_l.[i] + _r.[i]))) =
    incoeff (to_sint _l.[i]) + incoeff (to_sint _r.[i]) /\
  -6283009 <= to_sint (reduce32_w (_l.[i] + _r.[i])) <= 6283008.
+ move=> i Hi; have /= HAi := HA i Hi; have /= HBi := HB i Hi.
  have Hs : to_sint (_l.[i] + _r.[i]) = to_sint _l.[i] + to_sint _r.[i].
  + by rewrite to_sintD_small 1:/#.
  have [Hv Hr] := reduce32_wE (_l.[i] + _r.[i]) _; 1: smt().
  by rewrite Hv Hs incoeffD.
split.
+ apply Array256.tP => i Hi.
  rewrite /lifts_wpoly /BSWA_256u32.init mapiE 1:/# /= initiE 1:/# /=.
  rewrite poly_addE 1:/# !mapiE 1,2:/# /=.
  by have [-> _] := Hc i Hi.
rewrite allP => i Hi; rewrite /BSWA_256u32.init initiE 1:/# /=.
by have [_ H] := Hc i Hi.
qed.

lemma sub_reduce32E (_l _r : W32.t Array256.t) (A B : int) :
    wpoly_srng A A _l => wpoly_srng B B _r => A + B <= 2^31 - 2^22 - 1 =>
    let s = BSWA_256u32.init (fun i => reduce32_w (_l.[i] - _r.[i])) in
    lifts_wpoly s = lifts_wpoly _l &+ ((&-) (lifts_wpoly _r)) /\
    wpoly_srng 6283009 6283008 s.
proof.
rewrite /wpoly_srng !allP => HA HB /= Hab.
have Hc : forall i, 0 <= i < 256 =>
  incoeff (to_sint (reduce32_w (_l.[i] - _r.[i]))) =
    incoeff (to_sint _l.[i]) - incoeff (to_sint _r.[i]) /\
  -6283009 <= to_sint (reduce32_w (_l.[i] - _r.[i])) <= 6283008.
+ move=> i Hi; have /= HAi := HA i Hi; have /= HBi := HB i Hi.
  have Hs : to_sint (_l.[i] - _r.[i]) = to_sint _l.[i] - to_sint _r.[i].
  + by rewrite to_sintB_small 1:/#.
  have [Hv Hr] := reduce32_wE (_l.[i] - _r.[i]) _; 1: smt().
  by rewrite Hv Hs incoeffB.
split.
+ apply Array256.tP => i Hi.
  rewrite /lifts_wpoly /BSWA_256u32.init mapiE 1:/# /= initiE 1:/# /=.
  rewrite poly_addE 1:/# poly_negE 1:/# !mapiE 1,2:/# /=.
  by have [-> _] := Hc i Hi.
rewrite allP => i Hi; rewrite /BSWA_256u32.init initiE 1:/# /=.
by have [_ H] := Hc i Hi.
qed.

(* reduce32 of every coefficient: the c t0 the rhs pass tests and adds. *)
op reduce32_poly (a : W32.t Array256.t) : W32.t Array256.t =
  BSWA_256u32.init (fun i => reduce32_w a.[i]).

lemma reduce32_polyE (_r : W32.t Array256.t) :
    wpoly_srng (2^31 - 2^22 - 1) (2^31 - 2^22 - 1) _r =>
    lifts_wpoly (reduce32_poly _r) = lifts_wpoly _r /\
    wpoly_srng 6283009 6283008 (reduce32_poly _r).
proof.
rewrite /wpoly_srng !allP => HB; split.
+ apply Array256.tP => i Hi.
  rewrite /lifts_wpoly /reduce32_poly /BSWA_256u32.init !mapiE 1,2:/# /= initiE 1:/# /=.
  by have [-> _] := reduce32_wE _r.[i] (HB i Hi).
move=> i Hi; rewrite /reduce32_poly /BSWA_256u32.init initiE 1:/# /=.
by have [_ H] := reduce32_wE _r.[i] (HB i Hi).
qed.

(* lhs + reduce32(rhs), the output of the rhs pass. *)
lemma add_reduce32_rhsE (_l _r : W32.t Array256.t) (A B : int) :
    wpoly_srng A A _l => wpoly_srng (2^31 - 2^22 - 1) (2^31 - 2^22 - 1) _r =>
    wpoly_srng B B (reduce32_poly _r) => A + B < 2^31 =>
    let s = BSWA_256u32.init (fun i => _l.[i] + reduce32_w _r.[i]) in
    lifts_wpoly s = lifts_wpoly _l &+ lifts_wpoly _r /\ wpoly_srng (A + B) (A + B) s.
proof.
rewrite /wpoly_srng !allP => HA HR HB /= Hab.
have Hc : forall i, 0 <= i < 256 =>
  to_sint (_l.[i] + reduce32_w _r.[i]) = to_sint _l.[i] + to_sint (reduce32_w _r.[i]) /\
  incoeff (to_sint (reduce32_w _r.[i])) = incoeff (to_sint _r.[i]) /\
  -(A + B) <= to_sint _l.[i] + to_sint (reduce32_w _r.[i]) <= A + B.
+ move=> i Hi; have /= HAi := HA i Hi; have /= HRi := HR i Hi; have /= HBi := HB i Hi.
  move: HBi; rewrite /reduce32_poly /BSWA_256u32.init initiE 1:/# /= => HBi.
  split; 1: by rewrite to_sintD_small 1:/#.
  by have [-> _] := reduce32_wE _r.[i] HRi; smt().
split.
+ apply Array256.tP => i Hi.
  rewrite /lifts_wpoly /BSWA_256u32.init mapiE 1:/# /= initiE 1:/# /=.
  rewrite poly_addE 1:/# !mapiE 1,2:/# /=.
  by have [-> [<- _]] := Hc i Hi; rewrite incoeffD.
rewrite allP => i Hi; rewrite /BSWA_256u32.init initiE 1:/# /=.
by have [-> [_ H]] := Hc i Hi.
qed.

(* ================================================================== *)
(* polynomial____add_reduce32_check_infinity_norm                       *)
(* ================================================================== *)

lemma ar32_circuit (_l _r : W32.t Array256.t) (tw : W32.t) :
  hoare [ M.polynomial____add_reduce32_check_infinity_norm :
    lhs_pointer = _l /\ rhs_pointer = _r /\ truncateu32 (W64.of_int (threshold - 1)) = tw
    ==> res.`1 = BSWA_256u32.init (fun i => reduce32_w (_l.[i] + _r.[i])) /\
        res.`2 = zeroextu64 (SETcc (! check_inf_norm_w res.`1 tw)) ].
proof.
proc => /=.
swap [1..2] 3.
seq 3 : (lhs_pointer = _l /\ rhs_pointer = _r /\ threshold_vector = VPBROADCAST_8u32 tw).
+ by auto => /> &hr; rewrite vmov_truncate.
proc change ^while.1 : {
  lhs <- if (0 <= offset*8 <= 32*256-256)
         then BSWAS_256u32_256.sliceget lhs_pointer (offset*8)
         else get256_direct (init32 (fun i => lhs_pointer.[i])) offset; }.
+ auto => /> &2; case (0 <= offset{2} * 8 <= 7936); last by auto.
  by move => *; rewrite -BSWAS_256u32_256_slicegetE 1:/#.
proc change ^while.2 : {
  rhs <- if (0 <= offset*8 <= 32*256-256)
         then BSWAS_256u32_256.sliceget rhs_pointer (offset*8)
         else get256_direct (init32 (fun i => rhs_pointer.[i])) offset; }.
+ auto => /> &2; case (0 <= offset{2} * 8 <= 7936); last by auto.
  by move => *; rewrite -BSWAS_256u32_256_slicegetE 1:/#.
proc change ^while.8 : {
  sum_pointer <- if (0 <= offset*8 <= 32*256-256)
         then BSWAS_256u32_256.sliceset sum_pointer (offset*8) sum
         else Array256.init (get32 (set256_direct
                (init32 (fun i => sum_pointer.[i])) offset sum)); }.
+ auto => /> &2; case (0 <= offset{2} * 8 <= 7936); last by auto.
  by move => *; rewrite BSWAS_256u32_256_slicesetE 1:/#.
proc change 7 : { zf <- msb_mask = W32.zero; }.
+ by auto => /= &1 &2 ->; rewrite /TEST_32 /rflags_of_bwop /= /ZF_of /=.
unroll for ^while.
wp -2.
(* The test is stated on the stored polynomial: stating it on the
   reduce32 formula makes circuit compare two forms of the reduction. *)
conseq (: _ ==> sum_pointer = BSWA_256u32.init (fun i => reduce32_w (_l.[i] + _r.[i])) /\
                zf = check_inf_norm_w sum_pointer tw).
+ by move=> &hr _ p z [] -> ->.
kill ^offset<-; 1: by auto.
hoare split; 1: by circuit.
by rewrite /reduce32_w; circuit.
qed.

(* ================================================================== *)
(* polynomial____subtract_reduce32_check_infinity_norm                  *)
(* ================================================================== *)

lemma sr32_circuit (_l _r : W32.t Array256.t) (tw : W32.t) :
  hoare [ M.polynomial____subtract_reduce32_check_infinity_norm :
    lhs_pointer = _l /\ rhs_pointer = _r /\ truncateu32 (W64.of_int (threshold - 1)) = tw
    ==> res.`1 = BSWA_256u32.init (fun i => reduce32_w (_l.[i] - _r.[i])) /\
        res.`2 = zeroextu64 (SETcc (! check_inf_norm_w res.`1 tw)) ].
proof.
proc => /=.
swap [1..2] 3.
seq 3 : (lhs_pointer = _l /\ rhs_pointer = _r /\ threshold_vector = VPBROADCAST_8u32 tw).
+ by auto => /> &hr; rewrite vmov_truncate.
proc change ^while.1 : {
  lhs <- if (0 <= offset*8 <= 32*256-256)
         then BSWAS_256u32_256.sliceget lhs_pointer (offset*8)
         else get256_direct (init32 (fun i => lhs_pointer.[i])) offset; }.
+ auto => /> &2; case (0 <= offset{2} * 8 <= 7936); last by auto.
  by move => *; rewrite -BSWAS_256u32_256_slicegetE 1:/#.
proc change ^while.2 : {
  rhs <- if (0 <= offset*8 <= 32*256-256)
         then BSWAS_256u32_256.sliceget rhs_pointer (offset*8)
         else get256_direct (init32 (fun i => rhs_pointer.[i])) offset; }.
+ auto => /> &2; case (0 <= offset{2} * 8 <= 7936); last by auto.
  by move => *; rewrite -BSWAS_256u32_256_slicegetE 1:/#.
proc change ^while.8 : {
  difference_pointer <- if (0 <= offset*8 <= 32*256-256)
         then BSWAS_256u32_256.sliceset difference_pointer (offset*8) sum
         else Array256.init (get32 (set256_direct
                (init32 (fun i => difference_pointer.[i])) offset sum)); }.
+ auto => /> &2; case (0 <= offset{2} * 8 <= 7936); last by auto.
  by move => *; rewrite BSWAS_256u32_256_slicesetE 1:/#.
proc change 7 : { zf <- msb_mask = W32.zero; }.
+ by auto => /= &1 &2 ->; rewrite /TEST_32 /rflags_of_bwop /= /ZF_of /=.
unroll for ^while.
wp -2.
(* The test is stated on the stored polynomial: stating it on the
   reduce32 formula makes circuit compare two forms of the reduction. *)
conseq (: _ ==> difference_pointer = BSWA_256u32.init (fun i => reduce32_w (_l.[i] - _r.[i])) /\
                zf = check_inf_norm_w difference_pointer tw).
+ by move=> &hr _ p z [] -> ->.
kill ^offset<-; 1: by auto.
hoare split; 1: by circuit.
by rewrite /reduce32_w; circuit.
qed.

(* ================================================================== *)
(* polynomial____add_reduce32_check_infinity_norm_rhs                   *)
(* ================================================================== *)

(* The two compiled forms of the pass, with the test (tested) and
   without it (untested). tested also stores reduce32(rhs) in red, which
   the extracted pass does not: the circuit for the test is then stated
   on stored values. *)
module RHS = {
  proc tested (sum_pointer lhs_pointer rhs_pointer : W32.t Array256.t, threshold : int) :
              W32.t Array256.t * W32.t Array256.t * W64.t = {
    var two_pow_22, modulus, threshold_vector, exceeds_any : W256.t;
    var rhs, t, lhs, exceeds : W256.t;
    var temp, result : W64.t;
    var msb_mask : W32.t;
    var zf, _0, _1, _2, _3 : bool;
    var res8 : W8.t;
    var offset : int;
    var red : W32.t Array256.t;
    red <- witness;
    two_pow_22 <- tWO_POW_22_VECTOR;
    modulus <- mODULUS_VECTOR;
    temp <- W64.of_int (threshold - 1);
    threshold_vector <- zeroextu256 (VMOV_64 temp);
    threshold_vector <- VPBROADCAST_8u32 (truncateu32 threshold_vector);
    exceeds_any <- set0_256;
    offset <- 0;
    while (offset < 256 * 32 %/ 8) {
      rhs <- get256_direct (WArray1024.init32 (fun i => rhs_pointer.[i])) offset;
      t <- VPADD_8u32 rhs two_pow_22;
      t <- VPSRA_8u32 t (W128.of_int 23);
      t <- VPMULL_8u32 t modulus;
      rhs <- VPSUB_8u32 rhs t;
      red <- Array256.init (WArray1024.get32
               (WArray1024.set256_direct (WArray1024.init32 (fun i => red.[i])) offset rhs));
      lhs <- get256_direct (WArray1024.init32 (fun i => lhs_pointer.[i])) offset;
      lhs <- VPADD_8u32 lhs rhs;
      sum_pointer <- Array256.init (WArray1024.get32
        (WArray1024.set256_direct (WArray1024.init32 (fun i => sum_pointer.[i])) offset lhs));
      rhs <- VPABS_8u32 rhs;
      exceeds <- VPCMPGT_8u32 rhs threshold_vector;
      exceeds_any <- VPOR_256 exceeds_any exceeds;
      offset <- offset + 32;
    }
    msb_mask <- MOVEMASK_8u32 exceeds_any;
    (_0, _1, _2, _3, zf) <- TEST_32 msb_mask msb_mask;
    res8 <- SETcc (! zf);
    result <- zeroextu64 res8;
    return (sum_pointer, red, result);
  }

  proc untested (sum_pointer lhs_pointer rhs_pointer : W32.t Array256.t) :
                W32.t Array256.t = {
    var two_pow_22, modulus, rhs, t, lhs : W256.t;
    var offset : int;
    two_pow_22 <- tWO_POW_22_VECTOR;
    modulus <- mODULUS_VECTOR;
    offset <- 0;
    while (offset < 256 * 32 %/ 8) {
      rhs <- get256_direct (WArray1024.init32 (fun i => rhs_pointer.[i])) offset;
      t <- VPADD_8u32 rhs two_pow_22;
      t <- VPSRA_8u32 t (W128.of_int 23);
      t <- VPMULL_8u32 t modulus;
      rhs <- VPSUB_8u32 rhs t;
      lhs <- get256_direct (WArray1024.init32 (fun i => lhs_pointer.[i])) offset;
      lhs <- VPADD_8u32 lhs rhs;
      sum_pointer <- Array256.init (WArray1024.get32
        (WArray1024.set256_direct (WArray1024.init32 (fun i => sum_pointer.[i])) offset lhs));
      offset <- offset + 32;
    }
    return sum_pointer;
  }
}.

lemma rhs_tested_eq :
  equiv [ M.polynomial____add_reduce32_check_infinity_norm_rhs ~ RHS.tested :
    ={sum_pointer, lhs_pointer, rhs_pointer, threshold} /\ threshold{1} <= bound{1}
    ==> res{1} = (res{2}.`1, res{2}.`3) ].
proof.
proc; rcondt{1} ^if; 1: by move=> &2; wp; while (true); auto.
wp; while (={sum_pointer, lhs_pointer, rhs_pointer, offset, exceeds_any, threshold_vector,
             two_pow_22, modulus} /\ threshold{1} <= bound{1}).
+ by rcondt{1} ^if; [move=> &2; auto | auto].
by auto.
qed.

lemma rhs_untested_eq :
  equiv [ M.polynomial____add_reduce32_check_infinity_norm_rhs ~ RHS.untested :
    ={sum_pointer, lhs_pointer, rhs_pointer} /\ !(threshold{1} <= bound{1})
    ==> res{1} = (res{2}, W64.zero) ].
proof.
proc; rcondf{1} ^if; 1: by move=> &2; wp; while (true); auto.
wp; while (={sum_pointer, lhs_pointer, rhs_pointer, offset, two_pow_22, modulus} /\
           !(threshold{1} <= bound{1})).
+ by rcondf{1} ^if; [move=> &2; auto | auto].
by auto.
qed.

lemma rhs_tested_circuit (_l _r : W32.t Array256.t) (tw : W32.t) :
  hoare [ RHS.tested :
    lhs_pointer = _l /\ rhs_pointer = _r /\ truncateu32 (W64.of_int (threshold - 1)) = tw
    ==> res.`2 = BSWA_256u32.init (fun i => reduce32_w _r.[i]) /\
        res.`1 = BSWA_256u32.init (fun i => _l.[i] + reduce32_w _r.[i]) /\
        res.`3 = zeroextu64 (SETcc (! check_inf_norm_w res.`2 tw)) ].
proof.
proc => /=.
swap [2..3] 3.
seq 4 : (lhs_pointer = _l /\ rhs_pointer = _r /\ threshold_vector = VPBROADCAST_8u32 tw).
+ by auto => /> &hr; rewrite vmov_truncate.
proc change ^while.1 : {
  rhs <- if (0 <= offset*8 <= 32*256-256)
         then BSWAS_256u32_256.sliceget rhs_pointer (offset*8)
         else get256_direct (init32 (fun i => rhs_pointer.[i])) offset; }.
+ auto => /> &2; case (0 <= offset{2} * 8 <= 7936); last by auto.
  by move => *; rewrite -BSWAS_256u32_256_slicegetE 1:/#.
proc change ^while.6 : {
  red <- if (0 <= offset*8 <= 32*256-256)
         then BSWAS_256u32_256.sliceset red (offset*8) rhs
         else Array256.init (get32 (set256_direct
                (init32 (fun i => red.[i])) offset rhs)); }.
+ auto => /> &2; case (0 <= offset{2} * 8 <= 7936); last by auto.
  by move => *; rewrite BSWAS_256u32_256_slicesetE 1:/#.
proc change ^while.7 : {
  lhs <- if (0 <= offset*8 <= 32*256-256)
         then BSWAS_256u32_256.sliceget lhs_pointer (offset*8)
         else get256_direct (init32 (fun i => lhs_pointer.[i])) offset; }.
+ auto => /> &2; case (0 <= offset{2} * 8 <= 7936); last by auto.
  by move => *; rewrite -BSWAS_256u32_256_slicegetE 1:/#.
proc change ^while.9 : {
  sum_pointer <- if (0 <= offset*8 <= 32*256-256)
         then BSWAS_256u32_256.sliceset sum_pointer (offset*8) lhs
         else Array256.init (get32 (set256_direct
                (init32 (fun i => sum_pointer.[i])) offset lhs)); }.
+ auto => /> &2; case (0 <= offset{2} * 8 <= 7936); last by auto.
  by move => *; rewrite BSWAS_256u32_256_slicesetE 1:/#.
proc change 7 : { zf <- msb_mask = W32.zero; }.
+ by auto => /= &1 &2 ->; rewrite /TEST_32 /rflags_of_bwop /= /ZF_of /=.
unroll for ^while.
wp -2.
conseq (: _ ==> red = BSWA_256u32.init (fun i => reduce32_w _r.[i]) /\
                sum_pointer = BSWA_256u32.init (fun i => _l.[i] + reduce32_w _r.[i]) /\
                zf = check_inf_norm_w red tw).
+ by move=> &hr _ r s z [#] -> -> ->.
kill ^offset<-; 1: by auto.
(* One circuit per output: an array and the test together defeat lane
   collapsing. *)
hoare split; 1: hoare split; 1: by circuit.
+ by rewrite /reduce32_w; circuit.
by rewrite /reduce32_w; circuit.
qed.

lemma rhs_untested_circuit (_l _r : W32.t Array256.t) :
  hoare [ RHS.untested :
    lhs_pointer = _l /\ rhs_pointer = _r
    ==> res = BSWA_256u32.init (fun i => _l.[i] + reduce32_w _r.[i]) ].
proof.
proc => /=.
proc change ^while.1 : {
  rhs <- if (0 <= offset*8 <= 32*256-256)
         then BSWAS_256u32_256.sliceget rhs_pointer (offset*8)
         else get256_direct (init32 (fun i => rhs_pointer.[i])) offset; }.
+ auto => /> &2; case (0 <= offset{2} * 8 <= 7936); last by auto.
  by move => *; rewrite -BSWAS_256u32_256_slicegetE 1:/#.
proc change ^while.6 : {
  lhs <- if (0 <= offset*8 <= 32*256-256)
         then BSWAS_256u32_256.sliceget lhs_pointer (offset*8)
         else get256_direct (init32 (fun i => lhs_pointer.[i])) offset; }.
+ auto => /> &2; case (0 <= offset{2} * 8 <= 7936); last by auto.
  by move => *; rewrite -BSWAS_256u32_256_slicegetE 1:/#.
proc change ^while.8 : {
  sum_pointer <- if (0 <= offset*8 <= 32*256-256)
         then BSWAS_256u32_256.sliceset sum_pointer (offset*8) lhs
         else Array256.init (get32 (set256_direct
                (init32 (fun i => sum_pointer.[i])) offset lhs)); }.
+ auto => /> &2; case (0 <= offset{2} * 8 <= 7936); last by auto.
  by move => *; rewrite BSWAS_256u32_256_slicesetE 1:/#.
unroll for ^while.
wp -1.
by rewrite /reduce32_w; circuit.
qed.

(* ================================================================== *)
(* Specifications                                                       *)
(* ================================================================== *)

lemma polynomial____add_reduce32_check_infinity_norm_ll :
  islossless M.polynomial____add_reduce32_check_infinity_norm.
proof.
proc; wp; while (0 <= offset <= 1024 /\ offset %% 32 = 0) (1024 - offset).
+ by move=> z; auto => /#.
by auto => /#.
qed.

lemma polynomial____add_reduce32_check_infinity_norm_correct
      (_s _l _r : W32.t Array256.t) (A B t : int) :
  hoare [ M.polynomial____add_reduce32_check_infinity_norm :
    sum_pointer = _s /\ lhs_pointer = _l /\ rhs_pointer = _r /\ threshold = t /\
    1 <= t < 2147483648 /\
    wpoly_srng A A _l /\ wpoly_srng B B _r /\ A + B <= 2^31 - 2^22 - 1
    ==>
    lifts_wpoly res.`1 = lifts_wpoly _l &+ lifts_wpoly _r /\
    wpoly_srng 6283009 6283008 res.`1 /\
    (wpoly_infnorm_lt t res.`1 => res.`2 = W64.zero) /\
    (!wpoly_infnorm_lt t res.`1 => res.`2 = W64.one) ].
proof.
conseq (ar32_circuit _l _r (W32.of_int (t - 1))).
+ by move=> &hr [#] _ -> -> <- ht1 ht2 *; rewrite threshold_truncate.
move=> &hr [#] _ _ _ _ ht1 ht2 HA HB Hab [s r] /= [-> ->].
have /= [-> Hs] := add_reduce32E _l _r A B HA HB Hab.
split; 1: reflexivity; split; 1: exact Hs.
by apply (check_inf_norm_res _ t).
qed.

lemma polynomial____add_reduce32_check_infinity_norm_ph
      (_s _l _r : W32.t Array256.t) (A B t : int) :
  phoare [ M.polynomial____add_reduce32_check_infinity_norm :
    sum_pointer = _s /\ lhs_pointer = _l /\ rhs_pointer = _r /\ threshold = t /\
    1 <= t < 2147483648 /\
    wpoly_srng A A _l /\ wpoly_srng B B _r /\ A + B <= 2^31 - 2^22 - 1
    ==>
    lifts_wpoly res.`1 = lifts_wpoly _l &+ lifts_wpoly _r /\
    wpoly_srng 6283009 6283008 res.`1 /\
    (wpoly_infnorm_lt t res.`1 => res.`2 = W64.zero) /\
    (!wpoly_infnorm_lt t res.`1 => res.`2 = W64.one) ] = 1%r
  by conseq polynomial____add_reduce32_check_infinity_norm_ll
            (polynomial____add_reduce32_check_infinity_norm_correct _s _l _r A B t).

lemma polynomial____subtract_reduce32_check_infinity_norm_ll :
  islossless M.polynomial____subtract_reduce32_check_infinity_norm.
proof.
proc; wp; while (0 <= offset <= 1024 /\ offset %% 32 = 0) (1024 - offset).
+ by move=> z; auto => /#.
by auto => /#.
qed.

lemma polynomial____subtract_reduce32_check_infinity_norm_correct
      (_d _l _r : W32.t Array256.t) (A B t : int) :
  hoare [ M.polynomial____subtract_reduce32_check_infinity_norm :
    difference_pointer = _d /\ lhs_pointer = _l /\ rhs_pointer = _r /\ threshold = t /\
    1 <= t < 2147483648 /\
    wpoly_srng A A _l /\ wpoly_srng B B _r /\ A + B <= 2^31 - 2^22 - 1
    ==>
    lifts_wpoly res.`1 = lifts_wpoly _l &+ ((&-) (lifts_wpoly _r)) /\
    wpoly_srng 6283009 6283008 res.`1 /\
    (wpoly_infnorm_lt t res.`1 => res.`2 = W64.zero) /\
    (!wpoly_infnorm_lt t res.`1 => res.`2 = W64.one) ].
proof.
conseq (sr32_circuit _l _r (W32.of_int (t - 1))).
+ by move=> &hr [#] _ -> -> <- ht1 ht2 *; rewrite threshold_truncate.
move=> &hr [#] _ _ _ _ ht1 ht2 HA HB Hab [s r] /= [-> ->].
have /= [-> Hs] := sub_reduce32E _l _r A B HA HB Hab.
split; 1: reflexivity; split; 1: exact Hs.
by apply (check_inf_norm_res _ t).
qed.

lemma polynomial____subtract_reduce32_check_infinity_norm_ph
      (_d _l _r : W32.t Array256.t) (A B t : int) :
  phoare [ M.polynomial____subtract_reduce32_check_infinity_norm :
    difference_pointer = _d /\ lhs_pointer = _l /\ rhs_pointer = _r /\ threshold = t /\
    1 <= t < 2147483648 /\
    wpoly_srng A A _l /\ wpoly_srng B B _r /\ A + B <= 2^31 - 2^22 - 1
    ==>
    lifts_wpoly res.`1 = lifts_wpoly _l &+ ((&-) (lifts_wpoly _r)) /\
    wpoly_srng 6283009 6283008 res.`1 /\
    (wpoly_infnorm_lt t res.`1 => res.`2 = W64.zero) /\
    (!wpoly_infnorm_lt t res.`1 => res.`2 = W64.one) ] = 1%r
  by conseq polynomial____subtract_reduce32_check_infinity_norm_ll
            (polynomial____subtract_reduce32_check_infinity_norm_correct _d _l _r A B t).

lemma polynomial____add_reduce32_check_infinity_norm_rhs_ll :
  islossless M.polynomial____add_reduce32_check_infinity_norm_rhs.
proof.
proc; wp; while (0 <= offset <= 1024 /\ offset %% 32 = 0) (1024 - offset).
+ by move=> z; auto => /#.
by auto => /#.
qed.

lemma polynomial____add_reduce32_check_infinity_norm_rhs_correct
      (_s _l _r : W32.t Array256.t) (A t b : int) :
  hoare [ M.polynomial____add_reduce32_check_infinity_norm_rhs :
    sum_pointer = _s /\ lhs_pointer = _l /\ rhs_pointer = _r /\
    threshold = t /\ bound = b /\ 1 <= t < 2147483648 /\
    wpoly_srng A A _l /\ wpoly_srng (2^31 - 2^22 - 1) (2^31 - 2^22 - 1) _r /\
    0 <= A /\ A + 6283009 < 2^31
    ==>
    lifts_wpoly res.`1 = lifts_wpoly _l &+ lifts_wpoly _r /\
    (forall B, 0 <= B <= 6283009 => wpoly_srng B B (reduce32_poly _r) =>
       wpoly_srng (A + B) (A + B) res.`1) /\
    (t <= b => (wpoly_infnorm_lt t (reduce32_poly _r) => res.`2 = W64.zero) /\
               (!wpoly_infnorm_lt t (reduce32_poly _r) => res.`2 = W64.one)) /\
    (!(t <= b) => res.`2 = W64.zero) ].
proof.
(* The ranges are pure facts: moved into the context, since the equivalence
   steps below do not carry the precondition to the postcondition. *)
case: (1 <= t < 2147483648 /\ wpoly_srng A A _l /\
       wpoly_srng (2^31 - 2^22 - 1) (2^31 - 2^22 - 1) _r /\ 0 <= A /\ A + 6283009 < 2^31);
  last by move=> _; exfalso.
move=> [#] ht1 ht2 HA HR hA /= hA2.
have [Hl Hrr] := reduce32_polyE _r HR.
have Hsum : forall B, 0 <= B <= 6283009 => wpoly_srng B B (reduce32_poly _r) =>
  lifts_wpoly (BSWA_256u32.init (fun i => _l.[i] + reduce32_w _r.[i])) =
    lifts_wpoly _l &+ lifts_wpoly _r /\
  wpoly_srng (A + B) (A + B) (BSWA_256u32.init (fun i => _l.[i] + reduce32_w _r.[i])).
+ by move=> B hB HB; apply (add_reduce32_rhsE _l _r A B HA HR HB); smt().
have Hrr' : wpoly_srng 6283009 6283009 (reduce32_poly _r).
+ by apply (wpoly_srng_widen _ 6283009 6283008).
have [Hl1 _] := Hsum 6283009 _ Hrr'; 1: smt().
case: (t <= b) => htb.
+ conseq rhs_tested_eq (rhs_tested_circuit _l _r (W32.of_int (t - 1))).
  + move=> &1 [#] -> -> -> -> -> *.
    by exists (_s, _l, _r, t); rewrite threshold_truncate.
  move=> &1 &2 -> [H2 [H1 H3]] /=.
  rewrite H3 H2 H1 -/(reduce32_poly _r).
  split; 1: exact Hl1; split; 1: by move=> B hB HB; have [_ ?] := Hsum B hB HB.
  by apply (check_inf_norm_res (reduce32_poly _r) t).
conseq rhs_untested_eq (rhs_untested_circuit _l _r).
+ by move=> &1 [#] -> -> -> -> -> *; exists (_s, _l, _r).
move=> &1 &2 -> H /=; rewrite H.
split; 1: exact Hl1.
by move=> B hB HB; have [_ ?] := Hsum B hB HB.
qed.

lemma polynomial____add_reduce32_check_infinity_norm_rhs_ph
      (_s _l _r : W32.t Array256.t) (A t b : int) :
  phoare [ M.polynomial____add_reduce32_check_infinity_norm_rhs :
    sum_pointer = _s /\ lhs_pointer = _l /\ rhs_pointer = _r /\
    threshold = t /\ bound = b /\ 1 <= t < 2147483648 /\
    wpoly_srng A A _l /\ wpoly_srng (2^31 - 2^22 - 1) (2^31 - 2^22 - 1) _r /\
    0 <= A /\ A + 6283009 < 2^31
    ==>
    lifts_wpoly res.`1 = lifts_wpoly _l &+ lifts_wpoly _r /\
    (forall B, 0 <= B <= 6283009 => wpoly_srng B B (reduce32_poly _r) =>
       wpoly_srng (A + B) (A + B) res.`1) /\
    (t <= b => (wpoly_infnorm_lt t (reduce32_poly _r) => res.`2 = W64.zero) /\
               (!wpoly_infnorm_lt t (reduce32_poly _r) => res.`2 = W64.one)) /\
    (!(t <= b) => res.`2 = W64.zero) ] = 1%r
  by conseq polynomial____add_reduce32_check_infinity_norm_rhs_ll
            (polynomial____add_reduce32_check_infinity_norm_rhs_correct _s _l _r A t b).

end ReduceCheckT.
