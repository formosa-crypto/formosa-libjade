require import AllCore List IntDiv RealExp.
from Jasmin require import JModel_x86.
require import CircuitBindings Bindings XArray48 MldsaConstants Nttspec.
from Spec require import GFq Rq Parameters MLDSA_W32_Rep.
require import Array2 Array32 Array48 Array64 Array256 WArray48 WArray1024.
require import BitEncoding.
require import JWordList StdBigop.
(*---*) import Bigint.
require BaseT PreludeT PolynomialT CommonNttT CommonModularT.

abstract theory RowVectorT.

clone import BaseT.BaseT as B.
import S R MLDSAParams.
clone import PreludeT.PreludeT as PR with theory B <- B.
clone import PolynomialT.PolynomialT as PL with theory B <- B.
clone import CommonNttT.CommonNttT as CN with theory B <- B.
clone import CommonModularT.CommonModularT as CM with theory B <- B.
import CR.




                         
import PolyLVec PolyKVec PolyMat.
import Array_lpolys Array_kpolys Array_klpolys.
import Round ZModQ Zq.

import BitChunking.

(* the index of the entry (i, l) of a k x l matrix, row by row *)
lemma mat_idx (i l : int) : 0 <= i < kvec => 0 <= l < lvec => 0 <= i * lvec + l < kvec * lvec.
proof.
move=> hi hl; have : (i + 1) * lvec <= kvec * lvec.
+ by apply StdOrder.IntOrder.ler_wpmul2r; smt().
smt().
qed.

lemma or64_ne0 w1 w2 :
        w1 `|` w2 <> W64.zero <=>
        (w1 <> W64.zero \/ w2 <> W64.zero).
have ? := W64.wordP w1 w2.
have ? := W64.orwE w1 w2.
split => H; 1: by smt(W64.orw0 W64.or0w W64.zerowE).
by elim H; rewrite !wordP /= negb_forall /= /#.
qed.

(* ================================================================== *)
(* row_vector__ntt                                                      *)
(* Applies forward NTT to each of the lvec polynomials.                *)
(* Calls polynomial__ntt in a loop over the vector.                      *)
(* Spec: nttv from VecMat.ec                                            *)
(* ================================================================== *)

lemma row_vector__ntt_ll : islossless M.row_vector__ntt.
proof.
proc.
while (0 <= i <= lvec) (lvec - i); last by auto; smt(gt0_l).
move => *.
wp; call polynomial__ntt_ll.
by auto => /#.
qed.

lemma row_vector__ntt_correct (_v : W32.t Array_lpolys.t) :
    hoare [ M.row_vector__ntt :
        vector = _v /\
        wpolylvec_ntt_irng (lvec_unflatten256 _v)
        ==>
        lifts_wpolylvec (lvec_unflatten256 res) =
          nttv (lifts_wpolylvec (lvec_unflatten256 _v)) /\
        wpolylvec_ntt_orng (lvec_unflatten256 res)
    ].
proof.
have lvec_val := gt0_l.
proc.
while (0 <= i <= lvec /\
       wpolylvec_ntt_irng (lvec_unflatten256 _v) /\
       (forall k, 0 <= k < i =>
         lifts_wpoly (lvec_unflatten256 vector).[k] =
           ntt (lifts_wpoly (lvec_unflatten256 _v).[k]) /\
         wpoly_ntt_orng (lvec_unflatten256 vector).[k]) /\
       (forall k, i <= k < lvec =>
         (lvec_unflatten256 vector).[k] = (lvec_unflatten256 _v).[k])
      ); last first.
+ (* Exit: combine per-component facts into vector-level properties *)
  auto => |> Hrng_pre; split; 1: smt().
  move => i0 v0 Hng Hi1 Hi2 Hdone Huntouched; split.
  + apply LArray.tP => k kb.
    rewrite /lifts_wpolylvec mapiE; 1: smt(gt0_l).
    rewrite /nttv mapiE; 1: smt(gt0_l).
    rewrite mapiE; 1: smt(gt0_l).
    by have /= [-> _] := Hdone k _; smt().
  + by rewrite /wpolylvec_ntt_orng allP => k kb; have [_ ?] := Hdone k _; smt().
wp; ecall (polynomial__ntt_correct
             (Array256.init (fun j => vector.[i * 256 + j]))).
auto => /> &hr Hi1 Hi2 Hrng_pre Hprocessed Huntouched Hguard; split.
+ (* Pre for polynomial__ntt: slice of vector at i is ntt_irng *)
  rewrite -lvec_slice_eq; 1,2: smt().
  have -> : i{hr} * n %/ n = i{hr} by smt().
  rewrite (Huntouched i{hr} _); 1: smt().
  by move: Hrng_pre; rewrite /wpolylvec_ntt_irng LArray.allP => H; apply H; smt().
+ (* Post: invariant at i+1 *)
  move => _ result Hlifts Hrng; do split; 1,2: smt().
  + (* Processed components k < i+1 *)
    move => k ? Hk.
    have /= Hwb := lvec_unflatten256_writeback_iE vector{hr} result (i{hr} * 256) k _ _;
      1,2: smt().
    case (k = i{hr}) => Hki.
    + subst k; rewrite Hwb ifT; 1: smt().
      split; last exact Hrng.
      rewrite Hlifts; congr.
      have /= <- := Huntouched i{hr} _; 1: smt().
      by rewrite -lvec_slice_eq; smt().
    + rewrite Hwb ifF; 1: smt().
      by have := Hprocessed k _; smt().
  + (* Untouched components k >= i+1 *)
    move => k ? Hk.
    have /= Hwb := lvec_unflatten256_writeback_iE vector{hr} result (i{hr} * 256) k _ _;
      1,2: smt().
    rewrite Hwb ifF; 1: smt().
    by have := Huntouched k _; smt().
qed.

lemma row_vector__ntt_ph (_v : W32.t Array_lpolys.t) :
    phoare [ M.row_vector__ntt :
        vector = _v /\
        wpolylvec_ntt_irng (lvec_unflatten256 _v)
        ==>
        lifts_wpolylvec (lvec_unflatten256 res) =
          nttv (lifts_wpolylvec (lvec_unflatten256 _v)) /\
        wpolylvec_ntt_orng (lvec_unflatten256 res)
    ] = 1%r
  by conseq row_vector__ntt_ll (row_vector__ntt_correct _v).

lemma row_vector____check_infinity_norm_correct (_a : W32.t Array_lpolys.t) (_threshold : int) :
    phoare [ M.row_vector____check_infinity_norm :
       _threshold = gamma1 - Beta /\
       arg.`1 = _a /\ arg.`2 = _threshold /\
       wpolylvec_srng (lvec_unflatten256 _a) (gamma1-1) gamma1 
        ==>
        (wpolylvec_infnorm_lt _threshold (lvec_unflatten256 _a) => res = W64.zero) /\
        (!wpolylvec_infnorm_lt _threshold (lvec_unflatten256 _a) => res <> W64.zero)
    ] = 1%r.
proof.
have Hlvec := gt0_l.
have Hgamma1 := gamma1_cases.
  
rewrite /(`<<`) /=.
proc => /=.
while (0 <= i <= lvec /\ threshold = _threshold /\ vector = _a /\ _threshold = (gamma1 - Beta) /\
       wpolylvec_srng (lvec_unflatten256 _a) (gamma1 - 1) gamma1  /\
       ((forall k, 0<=k<i =>
          wpoly_srng ((gamma1 - Beta)-1) ((gamma1 - Beta)-1) (lvec_unflatten256 _a).[k]) => result = W64.zero) /\
        (! (forall k, 0<=k<i =>
          wpoly_srng ((gamma1 - Beta)-1) ((gamma1 - Beta)-1) (lvec_unflatten256 _a).[k]) => result <> W64.zero)) (lvec - i); last first.
+ auto => |> ?; split;1:smt().
  move => i rr;split;1:smt().
  move => ??? Ht Hf; rewrite /wpolylvec_infnorm_lt /wpolylvec_srng !allP /= /#.

 move => ?.
 exlim i => _i.
 wp; call (polynomial____check_infinity_norm_ph ((lvec_unflatten256 _a).[_i]) _threshold).
 auto => |> &hr ??Hrng Ht Hf ?.
 split.
 + split; 1: by have := beta_gamma1_lt; have := gt0_beta; smt().
   split.
   + rewrite Array256.tP => k kb; rewrite Array256.initiE 1:/# /= /lvec_unflatten256.
     by rewrite initiE 1:/# /= Array256.get_of_list 1:/# Array_lpolys.nth_sub /#.
   move : Hrng; rewrite /wpolylvec_srng /wpoly_srng !allP /= => H.
   have := H _i _;1:smt().
   by rewrite allP; smt(gamma1_cases).
move => 4? rr0 Htp Hfp;do split;1,2,5..:smt().
+ case (result{hr} = W64.zero) => ?; smt(W64.or0w).
case (result{hr} = W64.zero) => HH.
+ move => ?.
  have Hj : !wpoly_srng (gamma1 - Beta - 1) (gamma1 - Beta - 1) (lvec_unflatten256 _a).[_i].
  + by smt().
  move : Hfp; rewrite /wpoly_infnorm_lt /= Hj /= => ->;apply or64_ne0.
  by smt(W64.to_uint_eq W64.of_uintK W64.to_uintK W64.to_uint_cmp pow2_64).
move => ?; move : HH.
by smt(or64_ne0).
qed.

(* the coefficient c of a polynomial after a 256-bit store at the byte
   offset o of its byte view *)
lemma wpoly_set256_lane (p : W32.t Array256.t) (o : int) (w : W256.t) (c : int) :
  0 <= o => o + 32 <= 1024 => o %% 4 = 0 => 0 <= c < 256 =>
  (Array256.init (fun i => WArray1024.get32
     (WArray1024.set256_direct (WArray1024.init32 (fun j => p.[j])) o w) i)).[c]
  = if o %/ 4 <= c < o %/ 4 + 8 then w \bits32 (c - o %/ 4) else p.[c].
proof.
move => Ho0 Ho1 Hom Hc; rewrite Array256.initiE 1:// /=.
rewrite /WArray1024.get32_direct /=.
apply W32.wordP => k kb.
rewrite /W4u8.pack4_t W32.initiE 1:/# /= W4u8.Pack.initiE 1:/# /=.
rewrite /WArray1024.set256_direct WArray1024.initiE 1:/# /=.
case (o %/ 4 <= c < o %/ 4 + 8) => Hi_region.
+ rewrite (_: o <= 4 * c + k %/ 8 < o + 32) 1:/# /=.
  rewrite /W8u32.(\bits32) /W32u8.(\bits8) W32.initiE 1:/# /= W8.initiE 1:/# /=.
  congr; smt().
rewrite (_: !(o <= 4 * c + k %/ 8 < o + 32)) 1:/# /=.
rewrite /WArray1024.init32 WArray1024.initiE 1:/# /=.
rewrite (_: (4 * c + k %/ 8) %/ 4 = c) 1:/# (_: (4 * c + k %/ 8) %% 4 = k %/ 8) 1:/#.
by rewrite W4u8.get_bits8 1:/# /#.
qed.

(* ================================================================== *)
(* row_vector____dot_product                                            *)
(* output = sum_i lhs_i * rhs_i, pointwise in the Montgomery domain:    *)
(* the lvec products of each coefficient are summed on 64 bits and the  *)
(* sum is Montgomery-reduced once (mred).                               *)
(* Spec: ntt_dotp from VecMat.ec                                       *)
(* ================================================================== *)

(* the final Montgomery reduction of the two accumulators: even lanes in
   al, odd lanes in ah *)
lemma dot_reduceE (al ah : W256.t) :
    VPBLENDD_256
      (VMOVSHDUP_256 (VPSUB_4u64 al
         (VPMUL_256 (VPMUL_256 al iNVERSE_OF_MODULUS_MOD_MONTGOMERY_R_VECTOR) mODULUS_VECTOR)))
      (VPSUB_4u64 ah
         (VPMUL_256 (VPMUL_256 ah iNVERSE_OF_MODULUS_MOD_MONTGOMERY_R_VECTOR) mODULUS_VECTOR))
      (W8.of_int 170)
  = W8u32.pack8 [mred (al \bits64 0); mred (ah \bits64 0); mred (al \bits64 1);
                 mred (ah \bits64 1); mred (al \bits64 2); mred (ah \bits64 2);
                 mred (al \bits64 3); mred (ah \bits64 3)].
proof.
rewrite /mred /=; congr; congr.
by do 8! (congr; 1: by rewrite -shr_shrw 1://; circuit).
qed.

(* the integer sum of the products of the coefficient c of the first m
   polynomials of two L-vectors *)
op dot_lane (lhs rhs : W32.t Array_lpolys.t) (m c : int) : int =
  BIA.bigi predT (fun i => to_sint lhs.[256 * i + c] * to_sint rhs.[256 * i + c]) 0 m.

(* an accumulator of the loop: the 64-bit sums of the coefficients
   c0, c0 + 2, c0 + 4, c0 + 6 *)
op dot_acc (lhs rhs : W32.t Array_lpolys.t) (m c0 : int) : W256.t =
  W4u64.pack4 [W64.of_int (dot_lane lhs rhs m c0); W64.of_int (dot_lane lhs rhs m (c0 + 2));
               W64.of_int (dot_lane lhs rhs m (c0 + 4)); W64.of_int (dot_lane lhs rhs m (c0 + 6))].

lemma dot_lane0 (lhs rhs : W32.t Array_lpolys.t) (c : int) : dot_lane lhs rhs 0 c = 0.
proof. by rewrite /dot_lane BIA.big_geq. qed.

lemma dot_laneS (lhs rhs : W32.t Array_lpolys.t) (m c : int) : 0 <= m =>
  dot_lane lhs rhs (m + 1) c
  = dot_lane lhs rhs m c + to_sint lhs.[256 * m + c] * to_sint rhs.[256 * m + c].
proof. by move=> hm; rewrite /dot_lane BIA.big_int_recr. qed.

lemma sxE (x y : W32.t) : x \sx y = W64.of_int (to_sint x * to_sint y).
proof. by rewrite /(\sx) /sigextu64 W64.of_intM. qed.

(* one step of the inner loop: the products of the polynomial i, even
   lanes from VPMUL_256, odd lanes after VMOVSHDUP_256, added to the
   accumulators (the first step sets them) *)
lemma dot_acc_step (lhs rhs : W32.t Array_lpolys.t) (i c0 : int) (lc rc : W256.t) :
  0 <= i =>
  (forall l, 0 <= l < 8 => lc \bits32 l = lhs.[256 * i + c0 + l]) =>
  (forall l, 0 <= l < 8 => rc \bits32 l = rhs.[256 * i + c0 + l]) =>
  (if i = 0 then VPMUL_256 lc rc else VPADD_4u64 (dot_acc lhs rhs i c0) (VPMUL_256 lc rc))
    = dot_acc lhs rhs (i + 1) c0 /\
  (if i = 0 then VPMUL_256 (VMOVSHDUP_256 lc) (VMOVSHDUP_256 rc)
   else VPADD_4u64 (dot_acc lhs rhs i (c0 + 1))
          (VPMUL_256 (VMOVSHDUP_256 lc) (VMOVSHDUP_256 rc)))
    = dot_acc lhs rhs (i + 1) (c0 + 1).
proof.
move=> hi hl hr.
rewrite /dot_acc !dot_laneS // /= !sxE.
rewrite (hl 0) // (hl 1) // (hl 2) // (hl 3) // (hl 4) // (hl 5) // (hl 6) // (hl 7) //.
rewrite (hr 0) // (hr 1) // (hr 2) // (hr 3) // (hr 4) // (hr 5) // (hr 6) // (hr 7) //.
rewrite !addzA /=; case: (i = 0) => [->|_] /=.
+ by rewrite !dot_lane0.
done.
qed.

(* the coefficients of an L-vector in the base-multiplication range *)
lemma dot_coeff_bnd (v : W32.t Array_lpolys.t) (i c : int) :
  wpolylvec_bmul_irng (lvec_unflatten256 v) => 0 <= i < lvec => 0 <= c < 256 =>
  `|to_sint v.[256 * i + c]| <= 9 * q - 1.
proof.
rewrite /wpolylvec_bmul_irng LArray.allP => H hi hc.
have := H i hi; have -> : (lvec_unflatten256 v).[i] = Array256.init (fun j => v.[256 * i + j]).
+ by have := lvec_slice_eq v (256 * i) _ _; [smt() | smt() | rewrite (_ : 256 * i %/ 256 = i) 1:/#].
rewrite /wpoly_bmul_irng /wpoly_srng Array256.allP => Hs.
by have /= := Hs c hc; rewrite Array256.initiE //=; smt().
qed.

lemma dot_lane_bnd (lhs rhs : W32.t Array_lpolys.t) (m c : int) :
  wpolylvec_bmul_irng (lvec_unflatten256 lhs) =>
  wpolylvec_bmul_irng (lvec_unflatten256 rhs) =>
  0 <= m <= lvec => 0 <= c < 256 =>
  `|dot_lane lhs rhs m c| <= m * ((9 * q - 1) * (9 * q - 1)).
proof.
move=> hl hr; elim/natind: m => [m hm0 hm1 hc|m hm0 ih hm1 hc].
+ have -> : m = 0 by smt().
  by rewrite dot_lane0.
rewrite dot_laneS //.
have hx := dot_coeff_bnd lhs m c hl _ hc; 1: smt().
have hy := dot_coeff_bnd rhs m c hr _ hc; 1: smt().
have hd := ih _ hc; 1: smt().
have hxy : `|to_sint lhs.[256 * m + c] * to_sint rhs.[256 * m + c]|
           <= (9 * q - 1) * (9 * q - 1).
+ by rewrite StdOrder.IntOrder.normrM; apply StdOrder.IntOrder.ler_pmul; smt().
smt().
qed.

(* the abstract partial dot product, coefficient by coefficient *)
lemma dotp_partial_lane (lhs rhs : W32.t Array_lpolys.t) (m c : int) :
  0 <= m <= lvec => 0 <= c < 256 =>
  (dotp_partial (lifts_wpolylvec (lvec_unflatten256 lhs))
                (lifts_wpolylvec (lvec_unflatten256 rhs)) m).[c]
  = incoeff (dot_lane lhs rhs m c).
proof.
elim/natind: m => [m hm0 hm1 hc|m hm0 ih hm1 hc].
+ have -> : m = 0 by smt().
  by rewrite dot_lane0 /dotp_partial iota0 //= poly_zeroE.
rewrite dotp_partialS // poly_addE // ih 1,2:/# dot_laneS // incoeffD.
rewrite /basemul Array256.initiE //= /lifts_wpolylvec !LArray.mapiE 1,2:/# /=.
rewrite /lifts_wpoly !Array256.mapiE 1,2:/# /=.
have Hs : forall (v : W32.t Array_lpolys.t),
  (lvec_unflatten256 v).[m].[c] = v.[256 * m + c].
+ move=> v; have := lvec_slice_eq v (256 * m) _ _; 1,2: smt().
  by rewrite (_ : 256 * m %/ 256 = m) 1:/# => ->; rewrite Array256.initiE.
by rewrite !Hs incoeffM; ring.
qed.

(* the stored coefficients mred (sum) are the abstract dot product, in
   the base-multiplication output range *)
lemma dot_spec (lhs rhs : W32.t Array_lpolys.t) (out : W32.t Array256.t) :
  wpolylvec_bmul_irng (lvec_unflatten256 lhs) =>
  wpolylvec_bmul_irng (lvec_unflatten256 rhs) =>
  (forall c, 0 <= c < 256 => out.[c] = mred (W64.of_int (dot_lane lhs rhs lvec c))) =>
  liftm_wpoly out = ntt_dotp (lifts_wpolylvec (lvec_unflatten256 lhs))
                             (lifts_wpolylvec (lvec_unflatten256 rhs)) /\
  wpoly_srng (lvec * (q - 1)) (lvec * (q - 1)) out.
proof.
move=> hl hr Hout.
have hlv : lvec = 4 \/ lvec = 5 \/ lvec = 7 by smt(param_sets).
have HS : forall c, 0 <= c < 256 =>
  `|dot_lane lhs rhs lvec c| <= lvec * ((9 * q - 1) * (9 * q - 1)) /\
  to_sint (W64.of_int (dot_lane lhs rhs lvec c)) = dot_lane lhs rhs lvec c.
+ move=> c hc; have Hb := dot_lane_bnd lhs rhs lvec c hl hr _ hc; 1: smt(gt0_l).
  split; 1: exact Hb.
  by apply W64.to_sintK_small; move: Hb; rewrite /q; smt().
split.
+ apply Array256.tP => c hc.
  rewrite /liftm_wpoly scaleE // /lifts_wpoly mapiE //= Hout //.
  rewrite -dotp_partial_ntt_dotp dotp_partial_lane //.
  have [Hb hS] := HS c hc.
  have := mred_mont (W64.of_int (dot_lane lhs rhs lvec c)) _.
  + by rewrite hS; move: Hb; rewrite /q; smt().
  rewrite hS => hm.
  by rewrite /mont -incoeffM; apply incoeffP; rewrite incoeffK hm.
rewrite /wpoly_srng Array256.allP => c hc /=; rewrite Hout //.
have [Hb hS] := HS c hc.
have := mred_bnd (W64.of_int (dot_lane lhs rhs lvec c)) (lvec * ((9 * q - 1) * (9 * q - 1))) _ _.
+ by rewrite hS.
+ by move: hlv; rewrite /q; smt().
by move: hlv; rewrite /q; smt().
qed.

lemma row_vector____dot_product_ll : islossless M.row_vector____dot_product.
proof.
proc; while (0 <= offset <= 1024 /\ offset %% 32 = 0) (1024 - offset); last by auto => /#.
move=> z; wp; while (0 <= i <= lvec) (lvec - i); last by auto; smt(gt0_l).
by move=> z'; auto => /#.
qed.

lemma row_vector____dot_product_correct
      (_out : W32.t Array256.t)
      (_lhs : W32.t Array_lpolys.t) (_rhs : W32.t Array_lpolys.t) :
    hoare [ M.row_vector____dot_product :
        output = _out /\ lhs = _lhs /\ rhs = _rhs /\
        wpolylvec_bmul_irng (lvec_unflatten256 _lhs) /\
        wpolylvec_bmul_irng (lvec_unflatten256 _rhs)
        ==>
        liftm_wpoly res = ntt_dotp (lifts_wpolylvec (lvec_unflatten256 _lhs))
                                    (lifts_wpolylvec (lvec_unflatten256 _rhs)) /\
        wpoly_srng (lvec * (q-1)) (lvec * (q-1)) res
    ].
proof.
proc.
while (lhs = _lhs /\ rhs = _rhs /\ 0 <= offset <= 1024 /\ offset %% 32 = 0 /\
       qinv = iNVERSE_OF_MODULUS_MOD_MONTGOMERY_R_VECTOR /\ modulus = mODULUS_VECTOR /\
       forall c, 0 <= c < offset %/ 4 =>
         output.[c] = mred (W64.of_int (dot_lane _lhs _rhs lvec c))).
+ wp.
  while (lhs = _lhs /\ rhs = _rhs /\ 0 <= offset < 1024 /\ offset %% 32 = 0 /\
         qinv = iNVERSE_OF_MODULUS_MOD_MONTGOMERY_R_VECTOR /\ modulus = mODULUS_VECTOR /\
         (forall c, 0 <= c < offset %/ 4 =>
            output.[c] = mred (W64.of_int (dot_lane _lhs _rhs lvec c))) /\
         0 <= i <= lvec /\
         (0 < i => acc_low = dot_acc _lhs _rhs i (offset %/ 4) /\
                   acc_high = dot_acc _lhs _rhs i (offset %/ 4 + 1))).
  + (* one product per polynomial, added to the accumulators *)
    wp; skip => &hr [#] -> -> ho0 ho1 hom -> -> Hout hi0 hi1 Hacc hil.
    have hlb : lpolys_bytes = 1024 * lvec by rewrite /lpolys_bytes /lpolys; ring.
    have Hl : forall l, 0 <= l < 8 =>
      (WArray_lpolys_bytes.get256_direct (WArray_lpolys_bytes.init32 (fun i0 => _lhs.[i0]))
         (offset{hr} + i{hr} * 1024)) \bits32 l = _lhs.[256 * i{hr} + offset{hr} %/ 4 + l].
    + move=> l hl; rewrite WAE_lpolys_bytes.get256_direct_init32_bits32 // 1..3:/#.
      have -> : (offset{hr} + i{hr} * 1024) %/ 4 = offset{hr} %/ 4 + n * i{hr}.
      + by rewrite addzC (_ : i{hr} * 1024 = n * i{hr} * 4) 1:/# divzMDl //; ring.
      by rewrite /=; congr; ring.
    have Hr : forall l, 0 <= l < 8 =>
      (WArray_lpolys_bytes.get256_direct (WArray_lpolys_bytes.init32 (fun i0 => _rhs.[i0]))
         (offset{hr} + i{hr} * 1024)) \bits32 l = _rhs.[256 * i{hr} + offset{hr} %/ 4 + l].
    + move=> l hl; rewrite WAE_lpolys_bytes.get256_direct_init32_bits32 // 1..3:/#.
      have -> : (offset{hr} + i{hr} * 1024) %/ 4 = offset{hr} %/ 4 + n * i{hr}.
      + by rewrite addzC (_ : i{hr} * 1024 = n * i{hr} * 4) 1:/# divzMDl //; ring.
      by rewrite /=; congr; ring.
    have [H1 H2] := dot_acc_step _lhs _rhs i{hr} (offset{hr} %/ 4) _ _ hi0 Hl Hr.
    move: H1 H2; case: (i{hr} = 0) => hiz /= H1 H2.
    + by rewrite hiz /=; rewrite hiz /= in H1; rewrite hiz /= in H2; rewrite H1 H2 /=; smt().
    have [Hal Hah] := Hacc _; 1: smt().
    by rewrite Hal Hah H1 H2 /=; smt().
  (* the reduction of the accumulators and the store of 8 coefficients *)
  wp; skip => &hr [#] -> -> ho0 ho1 hom -> -> Hout hol.
  split; 1: by rewrite /= ho0 hom /=; smt(gt0_l).
  move=> ah al i0 hi0 [#] _ _ _ _ _ _ _ _ hi1 hi2 Hacc.
  have hil : i0 = lvec by smt().
  have [Hal Hah] := Hacc _; 1: smt(gt0_l).
  rewrite hil in Hal; rewrite hil in Hah.
  rewrite dot_reduceE Hal Hah /dot_acc /=.
  split; 1: smt().
  split; 1: smt().
  move=> c [hc0 hc1]; rewrite wpoly_set256_lane // 1..3:/#.
  case: (offset{hr} %/ 4 <= c < offset{hr} %/ 4 + 8) => hc; last by apply Hout; smt().
  have : c - offset{hr} %/ 4 = 0 \/ c - offset{hr} %/ 4 = 1 \/ c - offset{hr} %/ 4 = 2 \/
         c - offset{hr} %/ 4 = 3 \/ c - offset{hr} %/ 4 = 4 \/ c - offset{hr} %/ 4 = 5 \/
         c - offset{hr} %/ 4 = 6 \/ c - offset{hr} %/ 4 = 7 by smt().
  by case=> [|[|[|[|[|[|[|]]]]]]] hk; rewrite hk /=; do 3! congr; smt().
auto => /> hl hr; split; 1: smt().
move=> off out hoff _ hoff1 hom Hout.
by apply dot_spec => // c hc; apply Hout; smt().
qed.

lemma row_vector____dot_product_ph
      (_out : W32.t Array256.t)
      (_lhs : W32.t Array_lpolys.t) (_rhs : W32.t Array_lpolys.t) :
    phoare [ M.row_vector____dot_product :
        output = _out /\ lhs = _lhs /\ rhs = _rhs /\
        wpolylvec_bmul_irng (lvec_unflatten256 _lhs) /\
        wpolylvec_bmul_irng (lvec_unflatten256 _rhs)
        ==>
        liftm_wpoly res = ntt_dotp (lifts_wpolylvec (lvec_unflatten256 _lhs))
                                    (lifts_wpolylvec (lvec_unflatten256 _rhs)) /\
        wpoly_srng (lvec * (q-1)) (lvec * (q-1)) res
    ] = 1%r
  by conseq row_vector____dot_product_ll
            (row_vector____dot_product_correct _out _lhs _rhs).

(* ================================================================== *)
(* row_vector____multiply_with_matrix_A                                 *)
(* Computes A * v where A is a k x l matrix and v an l-element vector. *)
(* Calls row_vector____dot_product in a loop over the rows.             *)
(* Spec: ntt_mulmxv from VecMat.ec                                     *)
(* ================================================================== *)

lemma row_vector____multiply_with_matrix_A_ll :
    islossless M.row_vector____multiply_with_matrix_A.
proof.
proc.
while (0 <= i <= kvec) (kvec - i); last by auto; smt(gt0_k).
move => *.
wp; call row_vector____dot_product_ll.
by auto => /#.
qed.

lemma row_vector____multiply_with_matrix_A_correct
      (_mat : W32.t Array_klpolys.t) (_vec : W32.t Array_lpolys.t) :
    hoare [ M.row_vector____multiply_with_matrix_A :
        matrix_A = _mat /\ vector = _vec /\
        wpolymat_urng (mat_unflatten256 _mat) q /\
        wpolylvec_bmul_irng (lvec_unflatten256 _vec)
        ==>
        liftm_wpolykvec (kvec_unflatten256 res) =
          ntt_mulmxv (liftu_wpolymat (mat_unflatten256 _mat))
                     (lifts_wpolylvec (lvec_unflatten256 _vec)) /\
        wpolykvec_srng (kvec_unflatten256 res) (lvec * (q-1)) (lvec * (q-1))
    ].
proof.
have lvec_val := gt0_l.
have kvec_val := gt0_k.
proc.
while (0 <= i <= kvec /\ matrix_A = _mat /\ vector = _vec /\
       wpolymat_urng (mat_unflatten256 _mat) q /\
       wpolylvec_bmul_irng (lvec_unflatten256 _vec) /\
       (forall k, 0 <= k < i =>
          (liftm_wpolykvec (kvec_unflatten256 out)).[k] =
          ntt_dotp (row (lifts_wpolymat (mat_unflatten256 _mat)) k)
                   (lifts_wpolylvec (lvec_unflatten256 _vec)) /\
          wpoly_srng (lvec * (q-1)) (lvec * (q-1)) (kvec_unflatten256 out).[k])
      ); last first.
+ (* Exit + pre-loop *)
  auto => /> Hmurng Hvbmul; split; 1: smt().
  move => i out Hng Hi1 Hi2 Hinv; have {Hi2} Hi2 : i = kvec by smt().
  subst i.
  (* lifts_wpolymat = liftu_wpolymat under urng q *)
  have Hlifts_eq_liftu :
      lifts_wpolymat (mat_unflatten256 _mat) = liftu_wpolymat (mat_unflatten256 _mat).
  + rewrite /lifts_wpolymat /liftu_wpolymat.
    apply KLMatrix.tP => j jb.
    rewrite !mapiE 1,2:/# /=.
    move: Hmurng; rewrite /wpolymat_urng KLMatrix.allP => Hj.
    apply wpoly_urng_lifts_eq_liftu.
    by apply (Hj j _); smt().
  split.
  + rewrite /ntt_mulmxv; apply KArray.tP => k kb.
    rewrite KArray.initiE 1:/# /= -Hlifts_eq_liftu.
    by have /= [-> _] := Hinv k _; smt().
  + rewrite /wpolykvec_srng KArray.allP => k kb.
    by have /= [_ ?] := Hinv k _; smt().

(* Loop body *)
wp; ecall (row_vector____dot_product_correct
            (Array256.init (fun j => out.[256 * i + j]))
            (Array_lpolys.init (fun j => matrix_A.[lvec * 256 * i + j]))
            vector).
auto => /> &hr Hi1 Hi2 Hmurng Hvbmul Hinv Hguard.
split.
+ (* wpolylvec_bmul_irng on row slice: each element is urng q and hence bmul_irng *)
  rewrite /wpolylvec_bmul_irng LArray.allP => l lb.
  have /= -> := mat_row_slice_unflatten _mat i{hr} l _ _; 1,2: smt().
  apply wpoly_urng_bmul_irng.
  move: Hmurng; rewrite /wpolymat_urng KLMatrix.allP => Hj.
  by apply (Hj (i{hr}*lvec + l)); smt(mat_idx).
+ (* Post-call: establish invariant at i+1 *)
  move => _ aux Haux Hrng.
  do split; 1,2: smt().
  move => k kl ku.
  have /= Hwb :=
    kvec_unflatten256_writeback_iE out{hr} aux (256 * i{hr}) k _ _; 1,2: smt().
  split.
  + (* Lifts equality *)
    rewrite /liftm_wpolykvec mapiE; 1: smt(gt0_k).
    rewrite Hwb.
    case (k = i{hr}) => Hki.
    + subst k.
      have -> : 256 * i{hr} %/ 256 = i{hr} by smt().
      rewrite ifT // Haux.
      have -> : (Array_lpolys.init (fun j => _mat.[lvec * 256 * i{hr} + j])) =
                (Array_lpolys.init (fun j => _mat.[lpolys * i{hr} + j])).
      + by apply Array_lpolys.tP => j jb; rewrite !Array_lpolys.initiE 1,2:/# /= /#.
      congr.
      apply LArray.tP => l lb.
      rewrite /lifts_wpolylvec mapiE 1:/# /=.
      have /= -> := mat_row_slice_unflatten _mat i{hr} l _ _; 1,2: smt().
      rewrite /row LArray.initiE 1:/# /=.
      by rewrite /lifts_wpolymat mapiE //; smt(mat_idx).
    + have -> : (k = 256 * i{hr} %/ 256) = false by smt().
      rewrite /=.
      have /= [Heq _] := Hinv k _; 1: smt().
      move: Heq; rewrite /liftm_wpolykvec mapiE 1:/# /=.
      by move => ->.
  + (* Range *)
    rewrite Hwb.
    case (k = i{hr}) => Hki.
    + subst k; have -> : 256 * i{hr} %/ 256 = i{hr} by smt().
      by rewrite ifT //.
    + have -> : (k = 256 * i{hr} %/ 256) = false by smt().
      by have /= [_ ?] := Hinv k _; smt().
qed.

lemma row_vector____multiply_with_matrix_A_ph
      (_mat : W32.t Array_klpolys.t) (_vec : W32.t Array_lpolys.t) :
    phoare [ M.row_vector____multiply_with_matrix_A :
        matrix_A = _mat /\ vector = _vec /\
        wpolymat_urng (mat_unflatten256 _mat) q /\
        wpolylvec_bmul_irng (lvec_unflatten256 _vec)
        ==>
        liftm_wpolykvec (kvec_unflatten256 res) =
          ntt_mulmxv (liftu_wpolymat (mat_unflatten256 _mat))
                     (lifts_wpolylvec (lvec_unflatten256 _vec)) /\
        wpolykvec_srng (kvec_unflatten256 res) (lvec * (q-1)) (lvec * (q-1))
    ] = 1%r
  by conseq row_vector____multiply_with_matrix_A_ll
            (row_vector____multiply_with_matrix_A_correct _mat _vec).

(* The accumulators of the dot product are written at the first
   iteration of its inner loop, before being read: [sim] cannot see it,
   hence these equivalences for the callers. *)
lemma row_vector____dot_product_eq : equiv[
  M.row_vector____dot_product ~ M.row_vector____dot_product : ={arg} ==> ={res}].
proof.
proc; while (={offset, output, lhs, rhs, qinv, modulus}); last by auto.
wp; while (={offset, lhs, rhs, i} /\ 0 <= i{1} /\ (0 < i{1} => ={acc_low, acc_high})).
+ by auto => /> /#.
auto => /> &2 _ 4? i hi _ _ /(_ _); 1: smt(gt0_l).
by case=> -> ->.
qed.

lemma row_vector____multiply_with_matrix_A_eq : equiv[
  M.row_vector____multiply_with_matrix_A ~ M.row_vector____multiply_with_matrix_A :
  ={arg} ==> ={res}].
proof.
proc; while (={i, out, matrix_A, vector}); last by auto.
by wp; call row_vector____dot_product_eq; auto.
qed.

end RowVectorT.
