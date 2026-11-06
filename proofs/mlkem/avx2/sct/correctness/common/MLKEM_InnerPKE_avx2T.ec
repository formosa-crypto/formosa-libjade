(* -------------------------------------------------------------------- *)
(* The inner PKE of the model against the specification's InnerPKE_Op, *)
(* at abstract parameters: key generation, encryption, decryption.     *)
(* -------------------------------------------------------------------- *)
require import AllCore List Int IntDiv CoreMap Real Number BitEncoding.
from Jasmin require import JModel_x86.
from JazzEC require import Array256 Array128 Array64 Array33 Array32 Array16 Array8 Array4.
from JazzEC require import Array2 Array384 Array1024 Array2144 Array536 Array400.
from JazzEC require import WArray512 WArray128 WArray64 WArray33 WArray32 WArray16.
require import AVX2_Ops W16extra MLKEMFCLib Montgomery16.
require import Mlkem_bindings.
from CryptoSpecs require import FIPS202_SHA3_Spec Keccak1600_Spec Keccakf1600_Spec.
from Spec require import GFq Rq Sampling Serialization Symmetric Correctness EncDecCorrectness.
require import JkemConstants.
require import PreludeT.
require BaseT Fq_avx2T MLKEM_ntt_levelsT MLKEM_ntt_avx2T MLKEM_invntt_levelsT.
require MLKEM_invntt_avx2T MLKEM_basemul_avx2T NTT_avx2_polyT MLKEM_Poly_avx2T.
require MLKEM_Poly_avx2_circuitT NTT_avx2T MLKEM_PolyVec_avx2T MLKEM_PolyVec_avx2_circuitT.
require MLKEM_keccak_avx2T Mlkem_filters_bridgeT MLKEM_sampler_avx2T MLKEM_genmatrix_avx2T.
require MLKEM_getnoise_avx2T MLKEM_compress_avx2T.
require Montgomery.

abstract theory MLKEM_InnerPKE_avx2T.

clone import BaseT.BaseT as B.
import S R.
clone import PreludeT.PreludeT as PR with theory B <- B.
clone import Fq_avx2T.Fq_avx2T as Fq_avx2 with theory B <- B.
clone import MLKEM_ntt_levelsT.MLKEM_ntt_levelsT as MLKEM_ntt_levels with theory B <- B.
clone import MLKEM_ntt_avx2T.MLKEM_ntt_avx2T as MLKEM_ntt_avx2 with
  theory B <- B, theory MLKEM_ntt_levels <- MLKEM_ntt_levels.
clone import MLKEM_invntt_levelsT.MLKEM_invntt_levelsT as MLKEM_invntt_levels with
  theory B <- B, theory MLKEM_ntt_levels <- MLKEM_ntt_levels.
clone import MLKEM_invntt_avx2T.MLKEM_invntt_avx2T as MLKEM_invntt_avx2 with
  theory B <- B, theory MLKEM_ntt_levels <- MLKEM_ntt_levels,
  theory MLKEM_ntt_avx2 <- MLKEM_ntt_avx2, theory MLKEM_invntt_levels <- MLKEM_invntt_levels.
clone import MLKEM_basemul_avx2T.MLKEM_basemul_avx2T as MLKEM_basemul_avx2 with
  theory B <- B, theory MLKEM_ntt_levels <- MLKEM_ntt_levels,
  theory MLKEM_ntt_avx2 <- MLKEM_ntt_avx2.
clone import NTT_avx2_polyT.NTT_avx2_polyT as NTT_avx2_poly with
  theory B <- B, theory MLKEM_ntt_levels <- MLKEM_ntt_levels,
  theory MLKEM_ntt_avx2 <- MLKEM_ntt_avx2, theory MLKEM_invntt_levels <- MLKEM_invntt_levels,
  theory MLKEM_invntt_avx2 <- MLKEM_invntt_avx2, theory MLKEM_basemul_avx2 <- MLKEM_basemul_avx2.
clone import MLKEM_Poly_avx2T.MLKEM_Poly_avx2T as MLKEM_Poly_avx2 with
  theory B <- B, theory Fq_avx2 <- Fq_avx2, theory MLKEM_ntt_levels <- MLKEM_ntt_levels,
  theory MLKEM_ntt_avx2 <- MLKEM_ntt_avx2, theory MLKEM_invntt_levels <- MLKEM_invntt_levels,
  theory MLKEM_invntt_avx2 <- MLKEM_invntt_avx2, theory MLKEM_basemul_avx2 <- MLKEM_basemul_avx2,
  theory NTT_avx2_poly <- NTT_avx2_poly.
clone import MLKEM_Poly_avx2_circuitT.MLKEM_Poly_avx2_circuitT as MLKEM_Poly_avx2_circuit with
  theory B <- B, theory Fq_avx2 <- Fq_avx2, theory MLKEM_ntt_levels <- MLKEM_ntt_levels,
  theory MLKEM_ntt_avx2 <- MLKEM_ntt_avx2, theory MLKEM_invntt_levels <- MLKEM_invntt_levels,
  theory MLKEM_invntt_avx2 <- MLKEM_invntt_avx2, theory MLKEM_basemul_avx2 <- MLKEM_basemul_avx2,
  theory NTT_avx2_poly <- NTT_avx2_poly, theory MLKEM_Poly_avx2 <- MLKEM_Poly_avx2.
clone import NTT_avx2T.NTT_avx2T as NTT_avx2 with
  theory B <- B, theory PR <- PR, theory MLKEM_ntt_levels <- MLKEM_ntt_levels,
  theory MLKEM_ntt_avx2 <- MLKEM_ntt_avx2, theory MLKEM_invntt_levels <- MLKEM_invntt_levels,
  theory MLKEM_invntt_avx2 <- MLKEM_invntt_avx2, theory MLKEM_basemul_avx2 <- MLKEM_basemul_avx2,
  theory NTT_avx2_poly <- NTT_avx2_poly.
clone import MLKEM_PolyVec_avx2T.MLKEM_PolyVec_avx2T as MLKEM_PolyVec_avx2 with
  theory B <- B, theory PR <- PR, theory Fq_avx2 <- Fq_avx2, theory MLKEM_ntt_levels <-
    MLKEM_ntt_levels,
  theory MLKEM_ntt_avx2 <- MLKEM_ntt_avx2, theory MLKEM_invntt_levels <- MLKEM_invntt_levels,
  theory MLKEM_invntt_avx2 <- MLKEM_invntt_avx2, theory MLKEM_basemul_avx2 <- MLKEM_basemul_avx2,
  theory NTT_avx2_poly <- NTT_avx2_poly,
  theory MLKEM_Poly_avx2 <- MLKEM_Poly_avx2.
clone import MLKEM_PolyVec_avx2_circuitT.MLKEM_PolyVec_avx2_circuitT as MLKEM_PolyVec_avx2_circuit
  with
  theory B <- B, theory PR <- PR, theory Fq_avx2 <- Fq_avx2, theory MLKEM_ntt_levels <-
    MLKEM_ntt_levels,
  theory MLKEM_ntt_avx2 <- MLKEM_ntt_avx2, theory MLKEM_invntt_levels <- MLKEM_invntt_levels,
  theory MLKEM_invntt_avx2 <- MLKEM_invntt_avx2, theory MLKEM_basemul_avx2 <- MLKEM_basemul_avx2,
  theory NTT_avx2_poly <- NTT_avx2_poly,
  theory MLKEM_Poly_avx2 <- MLKEM_Poly_avx2, theory MLKEM_Poly_avx2_circuit <-
    MLKEM_Poly_avx2_circuit,
  theory NTT_avx2 <- NTT_avx2.
clone import MLKEM_keccak_avx2T.MLKEM_keccak_avx2T as MLKEM_keccak_avx2 with theory B <- B.
clone import Mlkem_filters_bridgeT.Mlkem_filters_bridgeT as Mlkem_filters_bridge with
  theory B <- B.
clone import MLKEM_sampler_avx2T.MLKEM_sampler_avx2T as MLKEM_sampler_avx2 with
  theory B <- B, theory MLKEM_keccak_avx2 <- MLKEM_keccak_avx2,
  theory Mlkem_filters_bridge <- Mlkem_filters_bridge.
clone import MLKEM_genmatrix_avx2T.MLKEM_genmatrix_avx2T as MLKEM_genmatrix_avx2 with
  theory B <- B, theory PR <- PR, theory Fq_avx2 <- Fq_avx2, theory MLKEM_ntt_levels <-
    MLKEM_ntt_levels,
  theory MLKEM_ntt_avx2 <- MLKEM_ntt_avx2, theory MLKEM_invntt_levels <- MLKEM_invntt_levels,
  theory MLKEM_invntt_avx2 <- MLKEM_invntt_avx2, theory MLKEM_basemul_avx2 <- MLKEM_basemul_avx2,
  theory NTT_avx2_poly <- NTT_avx2_poly,
  theory MLKEM_Poly_avx2 <- MLKEM_Poly_avx2, theory NTT_avx2 <- NTT_avx2,
  theory MLKEM_keccak_avx2 <- MLKEM_keccak_avx2,
  theory Mlkem_filters_bridge <- Mlkem_filters_bridge,
  theory MLKEM_sampler_avx2 <- MLKEM_sampler_avx2.
clone import MLKEM_getnoise_avx2T.MLKEM_getnoise_avx2T as MLKEM_getnoise_avx2 with
  theory B <- B, theory MLKEM_keccak_avx2 <- MLKEM_keccak_avx2.
clone import MLKEM_compress_avx2T.MLKEM_compress_avx2T as MLKEM_compress_avx2 with
  theory B <- B, theory PR <- PR.

import GFq Rq Sampling Serialization Symmetric Correctness.
import PolyVec PolyMat KMatrix Vector.
import Zq ZModP.
import BitChunking BS2Int.
import MLKEM_PolyAVX MLKEM_PolyAVXVec.
import Array_vecn Array_matn Array_polyvec_bytes Array_pk_bytes Array_ct_bytes Array_polyc_bytes.

(* -------------------------------------------------------------------- *)
(* the inner product of two vectors in the NTT domain                   *)
op pacc (A B : polyvec) (n : int) : poly =
  Big.BAdd.bigi predT (fun j => scale (basemul A.[j] B.[j]) (incoeff 169)) 0 n.

lemma nttunpack_add (x y : poly) : nttunpack (x &+ y) = nttunpack x &+ nttunpack y.
proof.
apply Array256.tP => k kb; rewrite /nttunpack /(&+) Array256.initiE //=.
have hk := nttunpack_inbounds k kb.
rewrite Array256.map2iE 1:// /= Array256.map2iE 1:// /=.
smt(Array256.initiE).
qed.

lemma lift_slice (x xr : W16.t Array_vecn.t) j : 0 <= j < kvec =>
  lift_arrayvecn x = nttunpackv (lift_arrayvecn xr) =>
  lift_array256 (subarray256 x j) = nttunpack (lift_polyvec xr).[j].
proof.
move=> jb h; rewrite lift_subarray256 // h subarray256_nttunpackv //.
by rewrite lift_polyvecE // lift_subarray256.
qed.

lemma polyvec_pointwise_acc_corr (a_ref b_ref : W16.t Array_vecn.t) :
  phoare [M.__polyvec_pointwise_acc :
    lift_arrayvecn a = nttunpackv (lift_arrayvecn a_ref) /\
    lift_arrayvecn b = nttunpackv (lift_arrayvecn b_ref) /\
    signed_boundvecn_cxq a 0 vecn 2 /\ signed_boundvecn_cxq b 0 vecn 2 ==>
    lift_array256 res = nttunpack (pacc (lift_polyvec a_ref) (lift_polyvec b_ref) kvec) /\
    signed_bound_cxq res 0 256 kvec] = 1%r.
proof.
pose A := lift_polyvec a_ref; pose B := lift_polyvec b_ref.
proc.
while (1 <= i <= kvec /\ lift_array256 r = nttunpack (pacc A B i) /\
       signed_bound_cxq r 0 256 i /\
       lift_arrayvecn a = nttunpackv (lift_arrayvecn a_ref) /\
       lift_arrayvecn b = nttunpackv (lift_arrayvecn b_ref) /\
       signed_boundvecn_cxq a 0 vecn 2 /\ signed_boundvecn_cxq b 0 vecn 2) (kvec - i).
+ move=> z; exlim i => i0.
  have h0 : (0 <= i0 <= 6) \/ !(0 <= i0 <= 6) by smt().
  move: h0 => [hi|hi]; last by exfalso => &hr; smt(param_sets).
  have hadd := poly_add_corr_avx i0 1 hi _; 1: done.
  wp; call (hadd (nttunpack (pacc A B i0))
                 (nttunpack (scale (basemul A.[i0] B.[i0]) (incoeff 169)))).
  ecall (poly_basemul_avx2_ph A.[i0] B.[i0]).
  auto => &hr [#] <- i1 ik hr hrb ha hb hab hbb ilt vz.
  rewrite -/(subarray256 a{hr} i0) -/(subarray256 b{hr} i0) /=.
  have [sa sb] : signed_bound_cxq (subarray256 a{hr} i0) 0 256 2 /\
                 signed_bound_cxq (subarray256 b{hr} i0) 0 256 2.
  + move/signed_boundvecnP: hab => ha'; move/signed_boundvecnP: hbb => hb'.
    by split; [apply ha' | apply hb']; smt().
  have hla := lift_slice a{hr} a_ref i0 _ ha; 1: smt().
  have hlb := lift_slice b{hr} b_ref i0 _ hb; 1: smt().
  split; 1: by rewrite hla hlb sa sb.
  move=> _ t [ht htb]; split; 1: by rewrite hr ht hrb htb.
  move=> _ r' [hr'b hr']; do split; 1,2,4..9: smt().
  apply Array256.tP => k kb; rewrite /lift_array256 Array256.mapiE //= hr' //.
  by rewrite /pacc (Big.BAdd.big_int_recr i0) 1:/# /= nttunpack_add /(&+) Array256.map2iE.
wp; ecall (poly_basemul_avx2_ph A.[0] B.[0]); auto => &hr [#] ha hb hab hbb.
have e0 : forall (x : W16.t Array_vecn.t), Array256.init (fun i_0 => x.[i_0]) = subarray256 x 0.
+ by move=> x; apply Array256.tP => k kb; rewrite subarray256E // !Array256.initiE.
rewrite !e0.
have hla := lift_slice a{hr} a_ref 0 _ ha; 1: smt(gt0_k).
have hlb := lift_slice b{hr} b_ref 0 _ hb; 1: smt(gt0_k).
move/signed_boundvecnP: (hab) => ha'; move/signed_boundvecnP: (hbb) => hb'.
rewrite hla hlb ha' 1:#smt:(gt0_k) hb' 1:#smt:(gt0_k) /=.
split; 1: done.
move=> _ r [hr hrb]; split.
+ rewrite hr hrb /=; split; 1: smt(gt0_k).
  by rewrite /pacc Big.BAdd.big_int1.
move=> i0 r0; split; 1: smt().
move=> ige [#] i1 ik hr0 hr0b _ _ _ _; have ? : i0 = kvec by smt(). subst i0.
by rewrite hr0 hr0b.
qed.

lemma scale_big (F : int -> poly) c n : 0 <= n =>
  scale (Big.BAdd.bigi predT F 0 n) c = Big.BAdd.bigi predT (fun j => scale (F j) c) 0 n.
proof.
elim/natind: n => [n n0 _ | n n0 ih _].
+ rewrite !Big.BAdd.big_geq 1,2:// /scale; apply Array256.tP => k kb.
  rewrite Array256.mapiE //= /Rq.zero Array256.createiE //; ring.
rewrite !Big.BAdd.big_int_recr 1,2:// /= -ih // /scale /(&+).
apply Array256.tP => k kb; rewrite Array256.mapiE //= !Array256.map2iE //= !Array256.mapiE //=.
ring.
qed.

lemma ntt_dotpw (va vb : polyvec) :
  ntt (dotpw va vb) = Big.BAdd.bigi predT (fun j => basemul (nttv va).[j] (nttv vb).[j]) 0 kvec.
proof.
rewrite dotpwE /dotp ntt_big /range /=.
apply Big.BAdd.eq_big_seq => j /mem_iota jb /=.
by rewrite !poly2algE 1,2:/# mul_comm_ntt !nttvE 1,2:/#.
qed.

lemma polyvec_pointwise_acc_corr_alg_avx (va vb : polyvec) (a_ref b_ref : W16.t Array_vecn.t) :
  phoare [M.__polyvec_pointwise_acc :
    nttv va = lift_polyvec a_ref /\ signed_boundvecn_cxq a_ref 0 vecn 2 /\
    nttv vb = lift_polyvec b_ref /\ signed_boundvecn_cxq b_ref 0 vecn 2 /\
    lift_arrayvecn a = nttunpackv (lift_arrayvecn a_ref) /\
    lift_arrayvecn b = nttunpackv (lift_arrayvecn b_ref) /\
    signed_boundvecn_cxq a 0 vecn 2 /\ signed_boundvecn_cxq b 0 vecn 2 ==>
    signed_bound_cxq res 0 256 kvec /\
    lift_array256 res = nttunpack (scale (ntt (dotpw va vb)) (incoeff 169))] = 1%r.
proof.
conseq (polyvec_pointwise_acc_corr a_ref b_ref) => //.
move=> &hr [#] hva _ hvb _ _ _ _ _ r.
rewrite ntt_dotpw scale_big 1:#smt:(gt0_k) /pacc hva hvb; smt().
qed.

(* -------------------------------------------------------------------- *)
(* bridges between the model's arrays and the specification             *)
lemma lift_arrayvecn_nttunpackv_nttpackv (x : W16.t Array_vecn.t) :
  nttunpackv (lift_arrayvecn (nttpackv x)) = lift_arrayvecn x.
proof. by rewrite -nttpackv_lift packvK. qed.

lemma lift_polyvec_nttpackvE (X : W16.t Array_vecn.t) j : 0 <= j < kvec =>
  (lift_polyvec (nttpackv X)).[j] = nttpack (lift_array256 (subarray256 X j)).
proof. by move=> jb; rewrite lift_polyvecE // subarray256_nttpackv // lift_nttpack. qed.

lemma nttpack_add (x y : poly) : nttpack (x &+ y) = nttpack x &+ nttpack y.
proof.
apply Array256.tP => k kb; rewrite /nttpack /(&+) Array256.initiE //=.
have hk := nttpack_inbounds k kb.
rewrite Array256.map2iE 1:// /= Array256.map2iE 1:// /=.
smt(Array256.initiE).
qed.

(* nttpackv distributes over a pointwise sum *)
lemma lift_polyvec_nttpackv_add (X Y Z : W16.t Array_vecn.t) :
  (forall k, 0 <= k < vecn =>
     (lift_arrayvecn Z).[k] = (lift_arrayvecn X).[k] + (lift_arrayvecn Y).[k]) =>
  lift_polyvec (nttpackv Z) = (lift_polyvec (nttpackv X) + lift_polyvec (nttpackv Y)).
proof.
move=> Hpw; apply KVec.tP => j jb.
rewrite polyvec_addE // !lift_polyvec_nttpackvE // !lift_subarray256 // -nttpack_add.
congr; apply Array256.tP => k kb.
by rewrite /(&+) Array256.map2iE // !subarray256E // Hpw 1:vecn_slice.
qed.

lemma lift_arrayvecn_unlift_ofipolyvec (vi : ipolyvec) :
  all (fun i => 0 <= i < 32768) vi =>
  lift_arrayvecn (unlift_polyvec (ofipolyvec vi)) = Array_vecn.init (fun k => incoeff vi.[k]).
proof.
rewrite IPVec.allP => Hbnd; apply Array_vecn.tP => k kb.
rewrite /lift_arrayvecn /unlift_polyvec /ofipolyvec Array_vecn.mapiE //= Array_vecn.initiE //=.
rewrite KVec.initiE 1:vecn_div // /= Array256.mapiE 1:/# /= /subarray256 Array256.initiE 1:/# /=.
rewrite Array_vecn.initiE //= (mulzC 256) -divz_eq.
rewrite of_sintK smod_small.
+ have := as_sint_range (incoeff vi.[k]); smt(qE).
by rewrite as_sintK.
qed.

lemma ntt_dotp_invnttv (s u : polyvec) :
  ntt (dotpw (invnttv s) u) = ntt_dotp s (nttv u).
proof. by rewrite dotpwE comm_ntt_dotp nttK. qed.

(* the decoding of the 12-bit vector bytes, model and specification views *)
lemma frombytes12_decode_bridge (f : int -> W8.t) :
  Array_vecn.of_list (incoeff 0)
    (map incoeff (ByteDecode 12 (Array_polyvec_bytes.to_list (Array_polyvec_bytes.init f))))
  = Array_vecn.init (fun kk => incoeff (decode12_vec (BytesPKVec.init f)).[kk]).
proof.
have Hbytes : Array_polyvec_bytes.to_list (Array_polyvec_bytes.init f) =
              BytesPKVec.to_list (BytesPKVec.init f).
+ apply (eq_from_nth witness).
  + by rewrite Array_polyvec_bytes.size_to_list BytesPKVec.size_to_list.
  move=> i; rewrite Array_polyvec_bytes.size_to_list => Hi.
  rewrite Array_polyvec_bytes.get_to_list BytesPKVec.get_to_list.
  by rewrite Array_polyvec_bytes.initiE //= BytesPKVec.initiE.
apply Array_vecn.tP => k Hk.
rewrite Array_vecn.get_of_list // (nth_map 0).
+ rewrite Hbytes /ByteDecode size_map size_chunk // size_BytesToBits BytesPKVec.size_to_list.
  by move: Hk; rewrite vecnE; smt().
by rewrite Array_vecn.initiE //= /decode12_vec IPVec.get_of_list // Hbytes.
qed.

(* the encoding side: the spec's encode12_vec and the model's tobytes  *)
lemma encode12_vec_tobytes_bridge (X : W16.t Array_vecn.t) :
  encode12_vec (toipolyvec (lift_polyvec X))
  = BytesPKVec.init (fun i =>
      (Array_polyvec_bytes.of_list W8.zero
         (ByteEncode 12 (Array_vecn.to_list (Array_vecn.map asint (lift_arrayvecn X))))).[i]).
proof.
rewrite /encode12_vec toipolivec_lift.
have -> : IPVec.to_list (IPVec.init (fun (idx : int) => asint (lift_arrayvecn X).[idx]))
        = Array_vecn.to_list (Array_vecn.map asint (lift_arrayvecn X)).
+ apply (eq_from_nth witness).
  + by rewrite IPVec.size_to_list Array_vecn.size_to_list.
  move=> i; rewrite IPVec.size_to_list => Hi.
  rewrite IPVec.get_to_list Array_vecn.get_to_list IPVec.initiE //=.
  smt(Array_vecn.mapiE).
apply BytesPKVec.tP => k Hk.
by rewrite BytesPKVec.get_of_list // BytesPKVec.initiE //= Array_polyvec_bytes.get_of_list.
qed.

(* the entry (i, j) of a matrix in the row i of its unlift *)
lemma lift_polyvec_subarrayvecn_unlift_matrix (a : polymat) (i j : int) :
  0 <= i < kvec => 0 <= j < kvec =>
  (lift_polyvec (subarrayvecn (unlift_matrix a) i)).[j] = a.[(i, j)].
proof.
move=> Hi Hj; rewrite lift_polyvecE // lift_subarray256 //.
apply Array256.tP => k Hk.
rewrite subarray256E // /lift_arrayvecn Array_vecn.mapiE 1:vecn_slice // /=.
rewrite /subarrayvecn Array_vecn.initiE 1:vecn_slice //= /unlift_matrix.
have hb := matn_idx i (256 * j + k) Hi (vecn_slice j k Hj Hk).
rewrite Array_matn.initiE //=.
have rv : 0 <= 256 * j + k < vecn by apply vecn_slice.
rewrite (mulzC vecn) divzMDl 1:#smt:(ge0_vecn gt0_k vecnE) divz_small 1:/# /=.
rewrite modzMDl modz_small 1:/#.
have -> : (256 * j + k) %/ 256 = j by smt().
have -> : (i * vecn + (256 * j + k)) %% 256 = k by rewrite vecnE; smt().
rewrite W16.to_sintE W16.of_uintK /smod /=.
by smt(asintK rg_asint qE).
qed.

lemma frommont_cancels_at_slot (rr0 rr1 : W16.t Array256.t) (X : poly) :
  signed_bound_cxq rr0 0 256 kvec =>
  (forall (k : int), 0 <= k < 256 =>
     to_sint rr1.[k]
     = SignedReductions_W16.SREDC
         (to_sint rr0.[k] * (SignedReductions_W16.R ^ 2 %% q))) =>
  lift_array256 rr0 = nttunpack (scale X (incoeff 169)) =>
  lift_array256 rr1 = nttunpack X.
proof.
move => Hrr0v Hrr1k Hrr0b.
rewrite /lift_array256 tP => k Hk.
rewrite mapiE //=.
rewrite Hrr1k //.
have [? Hredv] :=
  SignedReductions_W16.SREDCp_corr
    (to_sint rr0.[k] * (SignedReductions_W16.R ^ 2 %% q)) _ _.
+ by rewrite /SignedReductions_W16.R; smt(qE).
+ have := Hrr0v k _; 1: smt().
  by rewrite /SignedReductions_W16.R; smt(qE param_sets @SignedReductions_W16).
have ->: incoeff
   (SignedReductions_W16.SREDC
      (to_sint rr0.[k] * (SignedReductions_W16.R ^ 2 %% q)))
       = incoeff
   (to_sint rr0.[k] * (SignedReductions_W16.R ^ 2 %% q) * 169)
  by rewrite -eq_incoeff; apply Hredv.
rewrite !incoeffM.
have Hresk : incoeff (to_sint rr0.[k])
           = (nttunpack (scale X (incoeff 169))).[k].
+ by move: Hrr0b; rewrite /lift_array256 tP => /(_ k _) //; rewrite mapiE //= => ->.
rewrite Hresk.
rewrite /nttunpack initiE //= /scale mapiE //=;
  1: smt(nttunpack_bnd Array256.allP mem_iota).
have ->: incoeff (SignedReductions_W16.R ^ 2 %% q)
       = incoeff SignedReductions_W16.R * incoeff SignedReductions_W16.R.
+ rewrite -incoeffM -eq_incoeff modz_mod.
  have ->: SignedReductions_W16.R ^ 2
         = SignedReductions_W16.R * SignedReductions_W16.R by ring.
  done.
have ->: X.[nttunpack_idx.[k]] * incoeff 169
        * (incoeff SignedReductions_W16.R * incoeff SignedReductions_W16.R)
        * incoeff 169
       = X.[nttunpack_idx.[k]]
        * (incoeff SignedReductions_W16.R * incoeff 169)
        * (incoeff SignedReductions_W16.R * incoeff 169) by ring.
rewrite rrinvcoeff !ZqField.mulr1.
smt(Array256.initiE). 
qed.


(* the slots of a vector against the entries of the target *)
lemma kg_loop_post_to_target (pkpv : W16.t Array_vecn.t) (mm : polyvec) :
  (forall (j : int), 0 <= j < kvec =>
     lift_array256 (subarray256 pkpv j) = nttunpack mm.[j]) =>
  lift_polyvec (nttpackv pkpv) = mm.
proof.
move=> Hslots; apply KVec.tP => j jb.
by rewrite lift_polyvec_nttpackvE // Hslots // nttunpackK.
qed.

lemma nttpackv_subarrayvecn_nttunpackm (M : 'a Array_matn.t) (i : int) :
  0 <= i < kvec =>
  nttpackv (subarrayvecn (nttunpackm M) i) = subarrayvecn M i.
proof.
move=> Hi; rewrite -(unpackvK (subarrayvecn M i)); congr.
apply Array_vecn.tP => kk Hkk.
rewrite /subarrayvecn !Array_vecn.initiE //= /nttunpackm Array_matn.initiE /=.
+ exact (matn_idx _ _ Hi Hkk).
rewrite (mulzC vecn) divzMDl 1:#smt:(ge0_vecn gt0_k vecnE) divz_small 1:/#.
rewrite modzMDl modz_small 1:/# /= /nttunpackv Array_vecn.initiE //.
by rewrite /= /subarrayvecn (mulzC vecn).
qed.

lemma ntt_dotp_row_eq_ntt_mmul (a : polymat) (sv : W16.t Array_vecn.t) (i : int) :
  0 <= i < kvec =>
  ntt (dotpw (invnttv (lift_polyvec
              (nttpackv (subarrayvecn (nttunpackm (unlift_matrix a)) i))))
            (invnttv (lift_polyvec (nttpackv sv))))
  = (ntt_mmul a (lift_polyvec (nttpackv sv))).[i].
proof.
move=> Hi; rewrite ntt_dotp_invnttv nttvK.
rewrite (nttpackv_subarrayvecn_nttunpackm (unlift_matrix a) i _) //=.
rewrite ntt_dotpE /ntt_mmul KVec.initiE 1:// /= nttsum_big /range /=.
apply Big.BAdd.eq_big_seq => j /mem_iota jb /=.
by rewrite (lift_polyvec_subarrayvecn_unlift_matrix a i j _ _); smt().
qed.

lemma poly_add2_avx_ll : islossless M._poly_add2.
proof. proc; while (true) (16 - i); auto; smt(). qed.

lemma poly_basemul_avx_ll : islossless M._poly_basemul.
proof. proc; islossless. qed.

lemma polyvec_pointwise_acc_avx_ll : islossless M.__polyvec_pointwise_acc.
proof.
proc; while (true) (kvec - i).
+ move=> z; wp; call poly_add2_avx_ll; call poly_basemul_avx_ll; auto; smt().
wp; call poly_basemul_avx_ll; auto; smt().
qed.

(* -------------------------------------------------------------------- *)
(* the update of one polynomial of a vector, at any aligned offset      *)
lemma subarray256_upd (r : 'a Array_vecn.t) (a : 'a Array256.t) o j :
  0 <= o => o + 256 <= vecn => o %% 256 = 0 => 0 <= j < kvec =>
  subarray256 (Array_vecn.init (fun k =>
    if o <= k < o + 256 then a.[k - o] else r.[k])) j =
  if j = o %/ 256 then a else subarray256 r j.
proof.
move=> o0 ov om jb; have eo : o = 256 * (o %/ 256) by smt().
have ob : 0 <= o %/ 256 < kvec by move: ov; rewrite vecnE; smt().
by rewrite {1 2 3}eo subarray256_set.
qed.

lemma subarray256_upd_at (r : 'a Array_vecn.t) (x : 'a Array256.t) i j :
  0 <= i < kvec => 0 <= j < kvec =>
  subarray256 (Array_vecn.init (fun k =>
    if i * 256 <= k < i * 256 + 256 then x.[k - i * 256] else r.[k])) j =
  if j = i then x else subarray256 r j.
proof.
move=> ib jb; rewrite subarray256_upd //; 1,2: smt(vecnE).
+ by rewrite modzMl.
by rewrite mulzK.
qed.

lemma unlift_matrix_bnd (A : polymat) k : 0 <= k < matn =>
  bpos16 (unlift_matrix A).[k] (2 * q).
proof.
move=> kb; rewrite /unlift_matrix Array_matn.initiE //= /bpos16.
by rewrite W16.to_sintE W16.of_uintK /smod /=; smt(rg_asint qE).
qed.

lemma nttunpackm_bnd (A : polymat) : pos_boundmatn_cxq (nttunpackm (unlift_matrix A)) 0 matn 2.
proof.
move=> k kb; have hp : 0 <= k %/ 256 < kvec * kvec by move: kb; rewrite matn_blk; smt().
have := blkE (nttunpackm (unlift_matrix A)) (k %/ 256) (k %% 256) _; 1: smt().
rewrite (mulzC 256) -divz_eq => <-; rewrite blk_nttunpackm //.
have : Array256.all (fun w => bpos16 w (2 * q)) (nttunpack (blk (unlift_matrix A) (k %/ 256))).
+ rewrite nttunpack_pred Array256.allP => i ib /=; rewrite blkE //.
  by have := unlift_matrix_bnd A (256 * (k %/ 256) + i) (matn_slice _ _ hp ib).
by rewrite Array256.allP => /(_ (k %% 256) _); 1: smt().
qed.

(* the noise of a vector, polynomial by polynomial *)
lemma lift_polyvec_noise (x : W16.t Array_vecn.t) (f : int -> poly) :
  (forall j, 0 <= j < kvec => lift_array256 (subarray256 x j) = f j) =>
  lift_polyvec x = KVec.init f.
proof. by move=> h; apply KVec.tP => j jb; rewrite lift_polyvecE // h // KVec.initiE. qed.

(* the bounds of the arguments of the slot product *)
lemma nttpackv_signed_bnd (v : W16.t Array_vecn.t) c :
  pos_boundvecn_cxq v 0 vecn c => signed_boundvecn_cxq (nttpackv v) 0 vecn c.
proof.
move=> h; have : Array_vecn.all (fun w => b16 w (c * q)) (nttpackv v).
+ by rewrite nttpackv_pred Array_vecn.allP => k kb /=; have := h k kb; smt().
by rewrite Array_vecn.allP.
qed.

lemma subarrayvecn_bnd (m : W16.t Array_matn.t) c i : 0 <= i < kvec =>
  pos_boundmatn_cxq m 0 matn c => pos_boundvecn_cxq (subarrayvecn m i) 0 vecn c.
proof.
rewrite /pos_boundmatn_cxq => ib h k kb; rewrite /subarrayvecn Array_vecn.initiE //=.
have := h (vecn * i + k) _; last by rewrite /bpos16.
exact (matn_idx _ _ ib kb).
qed.

lemma frommont_bnd (rr0 rr1 : W16.t Array256.t) :
  signed_bound_cxq rr0 0 256 kvec =>
  (forall (k : int), 0 <= k < 256 =>
     to_sint rr1.[k]
     = SignedReductions_W16.SREDC
         (to_sint rr0.[k] * (SignedReductions_W16.R ^ 2 %% q))) =>
  signed_bound_cxq rr1 0 256 1.
proof.
rewrite /signed_bound_cxq => hb hk k kb; rewrite b16E hk //.
have [] := SignedReductions_W16.SREDCp_corr
  (to_sint rr0.[k] * (SignedReductions_W16.R ^ 2 %% q)) _ _.
+ by rewrite /SignedReductions_W16.R; smt(qE).
+ have := hb k _; 1: smt().
  by rewrite /SignedReductions_W16.R; smt(qE param_sets @SignedReductions_W16).
smt().
qed.

lemma pk_seed_offset i : (i + kvec * 384 %/ 8) * 8 = polyvec_bytes + 8 * i.
proof.
have -> : kvec * 384 = kvec * 48 * 8 by ring.
by rewrite mulzK // /polyvec_bytes; ring.
qed.

lemma mlkem_correct_kg_avx2_op :
  equiv [M.__indcpa_keypair ~ InnerPKE_Op.kg_derand :
    randomnessp{1} = coins{2}
    ==>
    let (pk,sk) = res{2} in let (t,rho) = pk in
      sk = BytesPKVec.init (fun i => res{1}.`2.[i]) /\
      t = BytesPKVec.init (fun i => res{1}.`1.[i]) /\
      rho = Array32.init (fun i => res{1}.`1.[polyvec_bytes + i])].
proof.
proc => /=.

(* the seed expansion: G(coins || kvec) splits into rho and the noise seed *)
seq 16 5 : (#pre /\ publicseed{1} = rho{2} /\
            noiseseed{1} = (G_coins_ds coins{2}).`2 /\
            s{2} = (prg_kg_inner coins{2}).`2 /\
            e{2} = (prg_kg_inner coins{2}).`3).
+ (* the coins, copied into the hash input *)
  seq 11 5 : (randomnessp{1} = coins{2} /\
              rho{2} = (G_coins_ds coins{2}).`1 /\
              s{2} = (prg_kg_inner coins{2}).`2 /\
              e{2} = (prg_kg_inner coins{2}).`3 /\
              inc{1} = 4 /\
              (forall k, 0 <= k < 32 => inbuf{1}.[k] = randomnessp{1}.[k])).
  + wp; while {1} (inc{1} = 4 /\ 0 <= i{1} <= 4 /\ randomnessp{1} = coins{2} /\
                   (forall k, 0 <= k < i{1}*8 => inbuf{1}.[k] = randomnessp{1}.[k]))
                  (4 - i{1}).
    + move => &m z; auto => /> &hr Hi0 Hi1 Hbnd Hgi; do split; 1..2,4:smt().
      move => k kbl kbh; rewrite initiE 1:/# /= get8_set64E 1,2:/#.
      case (i{hr}*8 <= k < i{hr}*8+8) => Hk.
      + rewrite ifT 1:/# /get64_direct pack8bE 1:/# initiE 1:/# /=.
        rewrite /init8 initiE 1:/# /=; congr; smt().
      rewrite ifF 1:/# /get8 /init8 initiE 1:/# /=; smt().
    auto => /> /#.
  (* the domain separator kvec, and the hash *)
  seq 2 0 : (randomnessp{1} = coins{2} /\
             rho{2} = (G_coins_ds coins{2}).`1 /\
             s{2} = (prg_kg_inner coins{2}).`2 /\
              e{2} = (prg_kg_inner coins{2}).`3 /\
             inbuf{1} = Array33.init (fun k => if k < 32 then coins{2}.[k]
                                               else W8.of_int kvec) /\
             to_list buf{1} = SHA3_512 (to_list inbuf{1})).
  + wp; ecall {1} (sha3_512A_A33_ph inbuf{1}); auto => />.
    move => &1 &2 Hbnd r Hr; rewrite tP => k kb; rewrite initiE 1:/# /= get_setE 1:/#.
    case (k = 32) => Hk.
    + by rewrite ifF 1:/# ?kvec_val.
    by rewrite ifT 1:/# Hbnd /#.
  sp 2 0; conseq />.
  while {1} (0 <= i{1} <= inc{1} /\ inc{1} = 4 /\
             buf{1} = Array64.init (fun k =>
                if 0 <= k < 32 then rho{2}.[k]
                else (G_coins_ds coins{2}).`2.[k - 32]) /\
             (forall k, 0 <= k < i{1}*8 =>
                publicseed{1}.[k] = rho{2}.[k] /\
                noiseseed{1}.[k] = (G_coins_ds coins{2}).`2.[k]))
            (4 - i{1}); last first.
  + auto => /> &1 &2 Hbuf;do split;2:smt().
    + have <- := Array64.to_listK witness ( buf{1}); rewrite Hbuf.
      rewrite tP => k kb.
      rewrite get_of_list // initiE 1:/# /= /G_coins /SHA3_512_33_64 /=.
      case (0<=k<32) => ?.
      + rewrite get_of_list //.
        rewrite (nth_take W8.zero 32) 1,2:/#.
        rewrite !(nth_change_dfl W8.zero witness);smt(size_SQUEEZE1600).
      rewrite get_of_list 1:/#.
      rewrite (nth_drop W8.zero 32) 1,2:/#.
      rewrite !(nth_change_dfl W8.zero witness);smt(size_SQUEEZE1600).
  + move => ? ns ps;split;1:smt().
    move => ?????;do split; 1,2: by rewrite tP;smt().
  (* the copy of the two halves of the hash *)
  + move => &m z;auto => /> &hr ????;do split;1,2,4:smt().
    move => k kbl kbh;split;rewrite initiE 1:/# get8_set64E 1,2:/#.
    + case (8 * i{hr} <= k < 8 * (i{hr} + 1)) => ?; last first.
      + by rewrite /init8 /get8 initiE 1:/# /#.
      rewrite wordP => ii iib.
      rewrite  /(\bits8) initiE 1:/# /= /get64_direct pack8E initiE 1:/# /=.
      rewrite initiE 1:/# /= initiE 1:/# /= initiE 1:/# /= ifT /#.
    + case (8 * i{hr} <= k < 8 * (i{hr} + 1)) => ?; last first.
      + by rewrite /init8 /get8 initiE 1:/# /#.
      rewrite wordP => ii iib.
      rewrite  /(\bits8) initiE 1:/# /= /get64_direct pack8E initiE 1:/# /=.
      rewrite initiE 1:/# /= initiE 1:/# /= initiE 1:/# /= ifF /#.

seq 2 1 : (#pre /\ aa{1} = nttunpackm (unlift_matrix a{2}) /\
           a{2} = sampleA rho{2} /\ pos_boundmatn_cxq aa{1} 0 matn 2).
+ sp 1 1.
  ecall {1} (_gen_matrix_avx2_sem publicseed{1} false).
  auto => /> &2 ?; rewrite /Mb /=; do split; 1,2: smt(nttmK).
  by apply nttunpackm_bnd.
seq 1 0 : (#pre /\
  (forall j, 0 <= j < kvec =>
     lift_array256 (subarray256 skpv{1} j) =
     samplePolyCBD eta1 (PRF eta1 noiseseed{1} (W8.of_int j))) /\
  (forall j, 0 <= j < kvec =>
     lift_array256 (subarray256 e{1} j) =
     samplePolyCBD eta1 (PRF eta1 noiseseed{1} (W8.of_int (j + kvec)))) /\
  signed_boundvecn_cxq skpv{1} 0 vecn 1 /\ signed_boundvecn_cxq e{1} 0 vecn 1).
+ if{1}.
  + wp; ecall {1} (jkem_getnoise_4x_ph noiseseed{1} (W8.of_int 0)).
    auto => /> &1 &2 _ hk r1 h11 h12 h13 h14 b11 b12 b13 b14.
    have hv : vecn = 512 by rewrite vecnE hk.
    do split.
    + move=> j j0 jk; have : j = 0 \/ j = 1 by smt().
      case=> [->|->]; rewrite !subarray256_upd ?hv ?hk //=;
        rewrite ?(h11, h12, h13, h14) ?hk //.
    + move=> j j0 jk; have : j = 0 \/ j = 1 by smt().
      case=> [->|->]; rewrite !subarray256_upd ?hv ?hk //=;
        rewrite ?(h11, h12, h13, h14) ?hk //.
    + apply signed_boundvecnP => j jb; have : j = 0 \/ j = 1 by smt().
      case=> [->|->]; rewrite !subarray256_upd ?hv ?hk //=;
        by move=> k kb; rewrite /b16 qE; smt().
    apply signed_boundvecnP => j jb; have : j = 0 \/ j = 1 by smt().
    case=> [->|->]; rewrite !subarray256_upd ?hv ?hk //=;
      by move=> k kb; rewrite /b16 qE; smt().
  if{1}.
  + wp; ecall {1} (jkem_getnoise_4x_ph noiseseed{1} (W8.of_int 4)).
    wp; ecall {1} (jkem_getnoise_4x_ph noiseseed{1} (W8.of_int 0)).
    auto => /> &1 &2 _ _ hk r1 h11 h12 h13 h14 b11 b12 b13 b14 r2 h21 h22 h23 h24 b21 b22 b23 b24.
    have hv : vecn = 768 by rewrite vecnE hk.
    do split.
    + move=> j j0 jk; have : j = 0 \/ j = 1 \/ j = 2 by smt().
      case=> [->|[->|->]]; rewrite !subarray256_upd ?hv ?hk //=;
        rewrite ?(h11, h12, h13, h14, h21, h22, h23, h24) ?hk //.
    + move=> j j0 jk; have : j = 0 \/ j = 1 \/ j = 2 by smt().
      case=> [->|[->|->]]; rewrite !subarray256_upd ?hv ?hk //=;
        rewrite ?(h11, h12, h13, h14, h21, h22, h23, h24) ?hk //.
    + apply signed_boundvecnP => j jb; have : j = 0 \/ j = 1 \/ j = 2 by smt().
      case=> [->|[->|->]]; rewrite !subarray256_upd ?hv ?hk //=;
        by move=> k kb; rewrite /b16 qE; smt().
    apply signed_boundvecnP => j jb; have : j = 0 \/ j = 1 \/ j = 2 by smt().
    case=> [->|[->|->]]; rewrite !subarray256_upd ?hv ?hk //=;
      by move=> k kb; rewrite /b16 qE; smt().
  wp; ecall {1} (jkem_getnoise_4x_ph noiseseed{1} (W8.of_int 4)).
  wp; ecall {1} (jkem_getnoise_4x_ph noiseseed{1} (W8.of_int 0)).
  auto => /> &1 &2 _ hk2 hk3 r1 h11 h12 h13 h14 b11 b12 b13 b14 r2 h21 h22 h23 h24
    b21 b22 b23 b24.
  have hk : kvec = 4 by smt(param_sets).
  have hv : vecn = 1024 by rewrite vecnE hk.
  do split.
  + move=> j j0 jk; have : j = 0 \/ j = 1 \/ j = 2 \/ j = 3 by smt().
    case=> [->|[->|[->|->]]]; rewrite !subarray256_upd ?hv ?hk //=;
      rewrite ?(h11, h12, h13, h14, h21, h22, h23, h24) ?hk //.
  + move=> j j0 jk; have : j = 0 \/ j = 1 \/ j = 2 \/ j = 3 by smt().
    case=> [->|[->|[->|->]]]; rewrite !subarray256_upd ?hv ?hk //=;
      rewrite ?(h11, h12, h13, h14, h21, h22, h23, h24) ?hk //.
  + apply signed_boundvecnP => j jb; have : j = 0 \/ j = 1 \/ j = 2 \/ j = 3 by smt().
    case=> [->|[->|[->|->]]]; rewrite !subarray256_upd ?hv ?hk //=;
      by move=> k kb; rewrite /b16 qE; smt().
  apply signed_boundvecnP => j jb; have : j = 0 \/ j = 1 \/ j = 2 \/ j = 3 by smt().
  case=> [->|[->|[->|->]]]; rewrite !subarray256_upd ?hv ?hk //=;
    by move=> k kb; rewrite /b16 qE; smt().
seq 2 2 : (publicseed{1} = rho{2} /\ aa{1} = nttunpackm (unlift_matrix a{2}) /\
           a{2} = sampleA rho{2} /\ pos_boundmatn_cxq aa{1} 0 matn 2 /\
           s{2} = lift_polyvec (nttpackv skpv{1}) /\
           e{2} = lift_polyvec (nttpackv e{1}) /\
           pos_boundvecn_cxq skpv{1} 0 vecn 2 /\ pos_boundvecn_cxq e{1} 0 vecn 2).
+ ecall {1} (polyvec_ntt_avx2_corr e{1}).
  ecall {1} (polyvec_ntt_avx2_corr skpv{1}).
  auto => /> &1 &2 _ hs he bs be.
  have es : lift_polyvec skpv{1} = (prg_kg_inner coins{2}).`2.
  + by rewrite /prg_kg_inner /=; apply lift_polyvec_noise => j jb /=; rewrite hs.
  have ee : lift_polyvec e{1} = (prg_kg_inner coins{2}).`3.
  + by rewrite /prg_kg_inner /=; apply lift_polyvec_noise => j jb /=; rewrite he.
  rewrite -es -ee; split; 1: by move=> k kb; have := bs k kb; smt().
  move=> _ r1 h1 b1; split; 1: by move=> k kb; have := be k kb; smt().
  by move=> _ r2 h2 b2.

seq 7 3 : (publicseed{1} = rho{2} /\
  sv{2} = BytesPKVec.init (fun i => sk{1}.[i]) /\
  tv{2} = BytesPKVec.init (fun i => aux_3{1}.[i])); last first.
+ sp 3 0.
  while {1} (inc{1} = 4 /\ 0 <= i{1} <= 4 /\ publicseed{1} = rho{2} /\
             sv{2} = BytesPKVec.init (fun i => sk{1}.[i]) /\
             tv{2} = BytesPKVec.init (fun i => aux_3{1}.[i]) /\
             (forall k, 0 <= k < polyvec_bytes => pk{1}.[k] = aux_3{1}.[k]) /\
             (forall k, 0 <= k < i{1} * 8 => pk{1}.[polyvec_bytes + k] = publicseed{1}.[k]))
            (4 - i{1}).
  + move=> &m z; auto => /> &hr hi0 hi4 hlo hhi ilt.
    have hpk : pk_bytes = polyvec_bytes + 32 by done.
    rewrite pk_seed_offset; do split; 1,2,5: smt().
    + move=> k k0 kn; rewrite Array_pk_bytes.initiE 1:/# /=.
      rewrite WArray_pk_bytes.get8_set64_directE 1,2:/# ifF 1:/#.
      by rewrite /WArray_pk_bytes.get8 /WArray_pk_bytes.init8 WArray_pk_bytes.initiE 1:/# /= hlo.
    move=> k k0 kn; rewrite Array_pk_bytes.initiE 1:#smt:(ge0_polyvec_bytes) /=.
    rewrite WArray_pk_bytes.get8_set64_directE 1,2:#smt:(ge0_polyvec_bytes).
    case: (polyvec_bytes + 8 * i{hr} <= polyvec_bytes + k < polyvec_bytes + 8 * i{hr} + 8)
      => hk.
    + by rewrite /get64_direct pack8bE 1:/# initiE 1:/# /= /init8 initiE 1:/# /=; congr; smt().
    rewrite /WArray_pk_bytes.get8 /WArray_pk_bytes.init8.
    by rewrite WArray_pk_bytes.initiE 1:#smt:(ge0_polyvec_bytes) /= hhi /#.
  auto => /> &1 &2 pk0; split.
  + split; 2: smt().
    by move=> k k0 kn; rewrite Array_pk_bytes.initiE 1:#smt:(ge0_polyvec_bytes) /= ifT.
  move=> i pk1; split; 1: smt().
  move=> ige i0 i4 hlo hhi.
  split; [apply BytesPKVec.tP | apply Array32.tP] => k kb.
  + by rewrite !BytesPKVec.initiE //= hlo.
  by rewrite Array32.initiE //= hhi /#.

ecall {1} (polyvec_tobytes_corr pkpv{1}).
ecall {1} (polyvec_tobytes_corr skpv{1}).
wp; ecall {1} (polyvec_reduce_corr_avx (lift_arrayvecn pkpv{1})).
ecall {1} (polyvec_add_corr_avx 1 2 _ _ (lift_arrayvecn pkpv{1}) (lift_arrayvecn e{1})) => //.
wp; conseq (: _ ==>
  publicseed{1} = rho{2} /\
  s{2} = lift_polyvec (nttpackv skpv{1}) /\
  e{2} = lift_polyvec (nttpackv e{1}) /\
  pos_boundvecn_cxq skpv{1} 0 vecn 2 /\
  pos_boundvecn_cxq e{1} 0 vecn 2 /\
  lift_polyvec (nttpackv pkpv{1}) = ntt_mmul a{2} s{2} /\
  signed_boundvecn_cxq pkpv{1} 0 vecn 1).
+ move=> /> &1 &2 _ _ be pk hmm _; split; 1: by move=> k kb; have := be k kb; smt().
  move=> _ r _ hrv r1 hr1 _ _.
  have hadd : forall k, 0 <= k < vecn =>
      (lift_arrayvecn r1).[k] = (lift_arrayvecn pk).[k] + (lift_arrayvecn e{1}).[k].
  + by move=> k kb; rewrite -hr1 -hrv // /lift_arrayvecn Array_vecn.mapiE.
  rewrite !encode12_vec_tobytes_bridge -hmm -(lift_polyvec_nttpackv_add pk e{1} r1) //.
  by rewrite encode12_vec_tobytes_bridge.
sp 1 0.

(* the matrix-vector product, row by row: the slots below i are done *)
while {1} (0 <= i{1} <= kvec /\
  publicseed{1} = rho{2} /\
  aa{1} = nttunpackm (unlift_matrix a{2}) /\
  pos_boundmatn_cxq aa{1} 0 matn 2 /\
  s{2} = lift_polyvec (nttpackv skpv{1}) /\
  e{2} = lift_polyvec (nttpackv e{1}) /\
  pos_boundvecn_cxq skpv{1} 0 vecn 2 /\
  pos_boundvecn_cxq e{1} 0 vecn 2 /\
  (forall j, 0 <= j < i{1} =>
     lift_array256 (subarray256 pkpv{1} j) = nttunpack ((ntt_mmul a{2} s{2}).[j]) /\
     signed_bound_cxq (subarray256 pkpv{1} j) 0 256 1)) (kvec - i{1}).
+ move=> &m z.
  wp; ecall (poly_frommont_corr_avx (map W16.to_sint (subarray256 pkpv i))).
  wp; ecall (polyvec_pointwise_acc_corr_alg_avx
               (invnttv (lift_polyvec (nttpackv (subarrayvecn aa i))))
               (invnttv (lift_polyvec (nttpackv skpv)))
               (nttpackv (subarrayvecn aa i))
               (nttpackv skpv)).
  auto => /> &hr i0 ik hm hs he hj ilt.
  have hsub : Array_vecn.init (fun i_0 =>
      (nttunpackm (unlift_matrix a{m})).[i{hr} * (kvec * 256) + i_0]) =
    subarrayvecn (nttunpackm (unlift_matrix a{m})) i{hr}.
  + apply Array_vecn.tP => k kb; rewrite /subarrayvecn !Array_vecn.initiE //= vecnE.
    by congr; ring.
  have hab := subarrayvecn_bnd _ 2 i{hr} _ hm; 1: smt().
  rewrite hsub !nttvK -!nttpackv_lift !packvK /=; split.
  + do split.
    - by apply nttpackv_signed_bnd.
    - by apply nttpackv_signed_bnd.
    - by move=> k kb; have := hab k kb; smt().
    by move=> k kb; have := hs k kb; smt().
  move=> _ _ _ _ r0 hr0b hr0v.
  have hr0 : Array256.init (fun i_0 => (Array_vecn.init (fun k =>
      if i{hr} * 256 <= k < i{hr} * 256 + 256 then r0.[k - i{hr} * 256]
      else pkpv{hr}.[k])).[i{hr} * 256 + i_0]) = r0.
  + apply Array256.tP => k kb; rewrite Array256.initiE //= Array_vecn.initiE 1:#smt:(vecnE) /=.
    by rewrite ifT 1:/#; congr; ring.
  rewrite subarray256_upd_at 1,2:/# /= hr0 /= => r1 hr1.
  have hr1k : forall k, 0 <= k < 256 => to_sint r1.[k] =
    SignedReductions_W16.SREDC (to_sint r0.[k] * (SignedReductions_W16.R ^ 2 %% q)).
  + move=> k kb; move/Array256.tP: hr1 => /(_ k kb).
    by rewrite !Array256.mapiE //= => ->; rewrite expr2.
  do split; 1,2,4: smt().
  move=> j j0 ji; rewrite subarray256_upd_at 1,2:/#.
  case: (j = i{hr}) => [->|ne] /=.
  + split; last by apply (frommont_bnd r0).
    rewrite -(ntt_dotp_row_eq_ntt_mmul a{m} skpv{hr} i{hr}) 1:/#.
    by apply (frommont_cancels_at_slot r0 r1).
  by rewrite subarray256_upd_at 1,2:/# ne /=; apply hj => /#.
+ by call polyvec_pointwise_acc_avx_ll.
auto => /> &1 &2 hm hs he; split; 1: smt(gt0_k).
move=> i pkpv; split; 1: smt().
move=> ige i0 ik hj; have {ige i0 ik} ? : i = kvec by smt(). subst i.
split; last by apply signed_boundvecnP => j jb; case: (hj j jb).
by apply kg_loop_post_to_target => j jb; case: (hj j jb).
qed.

lemma mlkem_correct_kg_avx2 :
  equiv [M.__indcpa_keypair ~ KPKE.keygen :
    randomnessp{1} = coins{2}
    ==>
    let (pk,sk) = res{2} in let (t,rho) = pk in
      sk = BytesPKVec.init (fun i => res{1}.`2.[i]) /\
      t = BytesPKVec.init (fun i => res{1}.`1.[i]) /\
      rho = Array32.init (fun i => res{1}.`1.[polyvec_bytes + i])].
proof.
transitivity InnerPKE_Op.kg_derand
  (randomnessp{1} = coins{2} ==>
     let (pk,sk) = res{2} in let (t,rho) = pk in
       sk = BytesPKVec.init (fun i => res{1}.`2.[i]) /\
       t = BytesPKVec.init (fun i => res{1}.`1.[i]) /\
       rho = Array32.init (fun i => res{1}.`1.[polyvec_bytes + i]))
  (={arg} ==> ={res}).
+ smt().
+ smt().
+ exact mlkem_correct_kg_avx2_op.
by conseq kg_op_eq.
qed.

lemma mlkem_correct_dec :
  equiv [M.__indcpa_dec ~ KPKE.decrypt :
    sk{2} = BytesPKVec.init (fun i => sk{1}.[i]) /\
    let (c1,c2) = cph{2} in
      c1 = BytesCtVec.init (fun i => ct{1}.[i]) /\
      c2 = BytesPoly.init (fun i => ct{1}.[polyvecc_bytes + i])
    ==>
    res{1} = res{2}].
proof.
proc => /=.
seq 5 3 : (sk{2} = BytesPKVec.init (fun i => sk{1}.[i]) /\
           c1{2} = BytesCtVec.init (fun i => ct{1}.[i]) /\
           c2{2} = BytesPoly.init (fun i => ct{1}.[polyvecc_bytes + i])).
+ by auto => /> &1 &2; case: (cph{2}).

(* the decompression of the ciphertext and the decoding of the key *)
seq 3 6 : (u{2} = lift_polyvec bp{1} /\ signed_boundvecn_cxq bp{1} 0 vecn 2 /\
           v{2} = lift_array256 v{1} /\ signed_bound_cxq v{1} 0 256 1 /\
           lift_arrayvecn skpv{1} =
             nttunpackv (Array_vecn.init (fun kk => incoeff (decode12_vec sk{2}).[kk])) /\
           s{2} = ofipolyvec (decode12_vec sk{2}) /\ pos_boundvecn_cxq skpv{1} 0 vecn 2).
+ wp; ecall {1} (polyvec_frombytes_corr sk{1}).
  ecall {1} (poly_decompress_corr (BytesPoly.init (fun i => ct{1}.[polyvecc_bytes + i]))).
  ecall {1} (polyvec_decompress_corr (BytesCtVec.init (fun i => ct{1}.[i]))).
  auto => /> &1 r hrb hr.
  have hpc : kvec * (256 * du %/ 8) = polyvecc_bytes.
  + by rewrite /polyvecc_bytes (: 256 * du = 32 * du * 8) 1:#ring mulzK.
  have hc2 : BytesPoly.init (fun i => (Array_polyc_bytes.init (fun i =>
      ct{1}.[kvec * (256 * du %/ 8) + i])).[i]) =
    BytesPoly.init (fun i => ct{1}.[polyvecc_bytes + i]).
  + apply BytesPoly.tP => k kb; rewrite !BytesPoly.initiE //= Array_polyc_bytes.initiE //=.
    by rewrite hpc.
  rewrite hc2 /= => r0 hr0 hr0b r1 hr1 hr1b; rewrite hr hr0 /=.
  split; 1: by move=> k kb; have := hrb k kb; smt().
  split; 1: by move=> k kb; have := hr0b k kb; smt().
  rewrite hr1; congr.
  have -> : Array_polyvec_bytes.to_list sk{1} =
    Array_polyvec_bytes.to_list (Array_polyvec_bytes.init (fun i => sk{1}.[i])).
  + by congr; apply Array_polyvec_bytes.tP => k kb; rewrite Array_polyvec_bytes.initiE.
  by apply frombytes12_decode_bridge.

(* the NTT of u, and the product with s *)
seq 1 0 : (nttv u{2} = lift_polyvec (nttpackv bp{1}) /\ pos_boundvecn_cxq bp{1} 0 vecn 2 /\
           v{2} = lift_array256 v{1} /\ signed_bound_cxq v{1} 0 256 1 /\
           lift_arrayvecn skpv{1} =
             nttunpackv (Array_vecn.init (fun kk => incoeff (decode12_vec sk{2}).[kk])) /\
           s{2} = ofipolyvec (decode12_vec sk{2}) /\ pos_boundvecn_cxq skpv{1} 0 vecn 2).
+ by ecall {1} (polyvec_ntt_avx2_corr bp{1}); auto => /> /#.
seq 1 0 : (v{2} = lift_array256 v{1} /\ signed_bound_cxq v{1} 0 256 1 /\
           lift_array256 t{1} = nttunpack (scale (ntt_dotp s{2} (nttv u{2})) (incoeff 169)) /\
           signed_bound_cxq t{1} 0 256 kvec).
+ ecall {1} (polyvec_pointwise_acc_corr_alg_avx (invnttv s{2}) u{2}
             (unlift_polyvec s{2}) (nttpackv bp{1})).
  auto => /> &1 &2 hu hb hv hs hsb.
  have [hl hlb] := vector_unlift (ofipolyvec (decode12_vec sk{2})).
  rewrite nttvK hl /=; split.
  + do split.
    - by move=> k kb; have := hlb k kb; smt().
    - by apply nttpackv_signed_bnd.
    - rewrite hs lift_arrayvecn_unlift_ofipolyvec // IPVec.allP => k kb /=.
      by have := decode12_vec_bnd sk{2} k _; smt().
    - by rewrite lift_arrayvecn_nttunpackv_nttpackv.
    - by move=> k kb; have := hsb k kb; smt().
    by move=> k kb; have := hb k kb; smt().
  by move=> _ _ _ _ _ _ r _; rewrite ntt_dotp_invnttv.

(* the inverse NTT, with its Montgomery factor *)
seq 1 0 : (v{2} = lift_array256 v{1} /\ signed_bound_cxq v{1} 0 256 1 /\
           lift_array256 t{1} = invntt (ntt_dotp s{2} (nttv u{2})) /\
           signed_bound_cxq t{1} 0 256 1).
+ ecall {1} (poly_invntt_avx2_corr (nttpack t{1})).
  auto => /> &1 &2 hvb htv htb; split.
  + by move=> k kb; have := htb k kb; smt(gt0_k param_sets).
  move=> _ r hr _; rewrite -hr lift_nttpack htv nttunpackK invntt_scale.
  rewrite /scale tP => k kb; rewrite !mapiE //= ZqField.mulrCA.
  have -> : incoeff 65536 * incoeff 169 = Zq.one by rewrite -rrinvcoeff.
  by ring.

(* v - t, reduced, and the message *)
seq 2 1 : (pos_bound256_cxq mp{1} 0 256 2 /\ lift_array256 mp{1} = mp{2}).
+ ecall {1} (poly_reduce_corr_avx (lift_array256 mp{1})).
  have hsub := poly_sub_corr_avx 1 1 _ _ => //.
  ecall {1} (hsub (lift_array256 v{1}) (lift_array256 t{1})).
  auto => /> &1 &2 hvb htv htb r hrb hrk r1 hr1 hr1b.
  rewrite -htv -hr1 tP => k kb.
  rewrite /ZR.(+) /ZR.([-]) /(&+) /(&-) map2iE 1:// mapiE 1:// /=.
  by rewrite hrk // Array256.mapiE //= (Array256.mapiE Zq.([-])).
ecall {1} (poly_tomsg_corr mp{1}).
by auto => /> /#.
qed.


lemma mlkem_correct_enc_avx2_op _pkp :
  equiv [M.__indcpa_enc ~ InnerPKE_Op.enc_derand :
    msgp{1} = m{2} /\ pk{1} = _pkp /\
    noiseseed{1} = r{2} /\
    pk{2}.`1 = BytesPKVec.init (fun i => pk{1}.[i]) /\
    pk{2}.`2 = Array32.init (fun i => pk{1}.[i + polyvec_bytes])
    ==>
    let (c1,c2) = res{2} in
    c1 = BytesCtVec.init (fun i => res{1}.[i]) /\
    c2 = BytesPoly.init (fun i => res{1}.[i + polyvecc_bytes])].
proof.
proc => /=.

(* the key decoding, the seed and the message *)
seq 14 9 : (#pre /\ publicseed{1} = rho{2} /\
  lift_arrayvecn pkpv{1} =
    nttunpackv (Array_vecn.init (fun kk => incoeff (decode12_vec pk{2}.`1).[kk])) /\
  pos_boundvecn_cxq pkpv{1} 0 vecn 2 /\
  that{2} = ofipolyvec (decode12_vec pk{2}.`1) /\
  lift_array256 k{1} = decompress_poly 1 (decode1 m{2}) /\
  pos_bound256_cxq k{1} 0 256 1 /\
  (rv{2}, e1{2}, e2{2}) = prg_enc_inner r{2}).
+ seq 9 5 : #pre; 1: by auto.
  wp; ecall {1} (poly_frommsg_corr msgp{1}).
  wp; while {1} (0 <= w{1} <= 4 /\ inc{1} = 4 /\ pk{1} = _pkp /\
    (forall k, 0 <= k < w{1} * 8 => publicseed{1}.[k] = pk{1}.[polyvec_bytes + k])) (4 - w{1}).
  + move=> &m z; auto => /> &hr w0 w4 hw wlt.
    rewrite (addzC (kvec * 384 %/ 8)) pk_seed_offset; do split; 1,2,4: smt().
    move=> k k0 kn; rewrite Array32.initiE 1:/# /= get8_set64E 1,2:/#.
    case: (8 * w{hr} <= k < 8 * (w{hr} + 1)) => hk.
    + rewrite /WArray_pk_bytes.get64_direct pack8bE 1:/# initiE 1:/# /=.
      rewrite /WArray_pk_bytes.init8 WArray_pk_bytes.initiE 1:#smt:(ge0_polyvec_bytes) /=.
      by congr; ring.
    by rewrite /get8 /init8 WArray32.initiE 1:/# /= hw /#.
  wp; ecall {1} (polyvec_frombytes_corr (Array_polyvec_bytes.init (fun i => pk{1}.[i]))).
  auto => /> &1 &2 hpk1 hpk2 r hr hrb.
  split; 1: smt().
  move=> ps wl; split; 1: smt().
  move=> wn w0 w4 hps r0 _ _; split.
  + by apply Array32.tP => k kb; rewrite hpk2 Array32.initiE //= hps /#.
  by rewrite hr hpk1; congr; apply frombytes12_decode_bridge.

(* the transposed matrix *)
seq 2 1 : (#pre /\ aat{1} = nttunpackm (unlift_matrix aT{2}) /\
           aT{2} = trmx (sampleA rho{2}) /\ pos_boundmatn_cxq aat{1} 0 matn 2).
+ sp 1 0; ecall {1} (_gen_matrix_avx2_sem publicseed{1} true).
  auto => /> &1 &2 *.
  have ht : nttm (trmx (H rho{2})) = trmx (sampleA rho{2}).
  + apply eq_polymatP => i j ib jb.
    by rewrite nttmE 1,2:/# trmxE 1,2:/# /H invnttmE 1,2:/# nttK trmxE 1,2:/#.
  by rewrite /Mb /= ht nttunpackm_bnd.

(* the noise, by parameter set: nonces 0 .. 2 kvec *)
seq 1 0 : (#pre /\
  (forall j, 0 <= j < kvec =>
     lift_array256 (subarray256 sp_0{1} j) =
     samplePolyCBD eta1 (PRF eta1 noiseseed{1} (W8.of_int j))) /\
  (forall j, 0 <= j < kvec =>
     lift_array256 (subarray256 ep{1} j) =
     samplePolyCBD eta2 (PRF eta2 noiseseed{1} (W8.of_int (j + kvec)))) /\
  lift_array256 epp{1} = samplePolyCBD eta2 (PRF eta2 noiseseed{1} (W8.of_int (2 * kvec))) /\
  signed_boundvecn_cxq sp_0{1} 0 vecn 1 /\ signed_boundvecn_cxq ep{1} 0 vecn 1 /\
  signed_bound_cxq epp{1} 0 256 1).
+ if{1}.
  + wp; ecall {1} (jkem_getnoise_eta2_ph noiseseed{1} (W8.of_int 4)).
    wp; ecall {1} (jkem_getnoise_eta1122_ph noiseseed{1} (W8.of_int 0)).
    auto => /> &1 &2 7? hk r1 h11 h12 h13 h14 b11 b12 b13 b14 r3 h3 b3.
    have hv : vecn = 512 by rewrite vecnE hk.
    do split.
    + move=> j j0 jk; have : j = 0 \/ j = 1 by smt().
      case=> [->|->]; rewrite !subarray256_upd ?hv ?hk //=;
        rewrite ?(h11, h12, h13, h14, h3) ?hk //.
    + move=> j j0 jk; have : j = 0 \/ j = 1 by smt().
      rewrite hk; case=> [->|->]; rewrite !subarray256_upd ?hv ?hk //=;
        rewrite ?(h11, h12, h13, h14, h3) ?hk //.
    + by rewrite hk h3.
    + apply signed_boundvecnP => j jb; have : j = 0 \/ j = 1 by smt().
      case=> [->|->]; rewrite !subarray256_upd ?hv ?hk //=;
        by move=> k kb; rewrite /b16 qE; smt().
    + apply signed_boundvecnP => j jb; have : j = 0 \/ j = 1 by smt().
      case=> [->|->]; rewrite !subarray256_upd ?hv ?hk //=;
        by move=> k kb; rewrite /b16 qE; smt().
    by move=> k kb; rewrite /b16 qE; smt().
  if{1}.
  + wp; ecall {1} (jkem_getnoise_4x_ph noiseseed{1} (W8.of_int 4)).
    wp; ecall {1} (jkem_getnoise_4x_ph noiseseed{1} (W8.of_int 0)).
    auto => /> &1 &2 8? hk r1 h11 h12 h13 h14 b11 b12 b13 b14 r2 h21 h22 h23 h24 b21 b22 b23 b24.
    rewrite (: eta2 = eta1) 1:#smt:(param_sets).
    have hv : vecn = 768 by rewrite vecnE hk.
    do split.
    + move=> j j0 jk; have : j = 0 \/ j = 1 \/ j = 2 by smt().
      case=> [->|[->|->]]; rewrite !subarray256_upd ?hv ?hk //=;
        rewrite ?(h11, h12, h13, h14, h21, h22, h23, h24) ?hk //.
    + move=> j j0 jk; have : j = 0 \/ j = 1 \/ j = 2 by smt().
      rewrite hk; case=> [->|[->|->]]; rewrite !subarray256_upd ?hv ?hk //=;
        rewrite ?(h11, h12, h13, h14, h21, h22, h23, h24) ?hk //.
    + by rewrite hk h23.
    + apply signed_boundvecnP => j jb; have : j = 0 \/ j = 1 \/ j = 2 by smt().
      case=> [->|[->|->]]; rewrite !subarray256_upd ?hv ?hk //=;
        by move=> k kb; rewrite /b16 qE; smt().
    + apply signed_boundvecnP => j jb; have : j = 0 \/ j = 1 \/ j = 2 by smt().
      case=> [->|[->|->]]; rewrite !subarray256_upd ?hv ?hk //=;
        by move=> k kb; rewrite /b16 qE; smt().
    by move=> k kb; rewrite /b16 qE; smt().
  wp; ecall {1} (jkem_getnoise_eta2_ph noiseseed{1} (W8.of_int 8)).
  wp; ecall {1} (jkem_getnoise_4x_ph noiseseed{1} (W8.of_int 4)).
  wp; ecall {1} (jkem_getnoise_4x_ph noiseseed{1} (W8.of_int 0)).
  auto => /> &1 &2 8? hk3 r1 h11 h12 h13 h14 b11 b12 b13 b14 r2 h21 h22 h23 h24 b21 b22 b23 b24
    r3 h3 b3.
  rewrite (: eta2 = eta1) 1:#smt:(param_sets).
  have hk : kvec = 4 by smt(param_sets).
  have hv : vecn = 1024 by rewrite vecnE hk.
  do split.
  + move=> j j0 jk; have : j = 0 \/ j = 1 \/ j = 2 \/ j = 3 by smt().
    case=> [->|[->|[->|->]]]; rewrite !subarray256_upd ?hv ?hk //=;
      rewrite ?(h11, h12, h13, h14, h21, h22, h23, h24, h3) ?hk //.
  + move=> j j0 jk; have : j = 0 \/ j = 1 \/ j = 2 \/ j = 3 by smt().
    rewrite hk; case=> [->|[->|[->|->]]]; rewrite !subarray256_upd ?hv ?hk //=;
      rewrite ?(h11, h12, h13, h14, h21, h22, h23, h24, h3) ?hk //.
  + by rewrite hk h3 (: eta2 = eta1) 1:#smt:(param_sets).
  + apply signed_boundvecnP => j jb; have : j = 0 \/ j = 1 \/ j = 2 \/ j = 3 by smt().
    case=> [->|[->|[->|->]]]; rewrite !subarray256_upd ?hv ?hk //=;
      by move=> k kb; rewrite /b16 qE; smt().
  + apply signed_boundvecnP => j jb; have : j = 0 \/ j = 1 \/ j = 2 \/ j = 3 by smt().
    case=> [->|[->|[->|->]]]; rewrite !subarray256_upd ?hv ?hk //=;
      by move=> k kb; rewrite /b16 qE; smt().
  by move=> k kb; rewrite /b16 qE; smt().

(* the NTT of r; the noise as the specification's vectors *)
seq 1 1 : (
  lift_arrayvecn pkpv{1} =
    nttunpackv (Array_vecn.init (fun kk => incoeff (decode12_vec pk{2}.`1).[kk])) /\
  pos_boundvecn_cxq pkpv{1} 0 vecn 2 /\
  that{2} = ofipolyvec (decode12_vec pk{2}.`1) /\
  lift_array256 k{1} = decompress_poly 1 (decode1 m{2}) /\
  pos_bound256_cxq k{1} 0 256 1 /\
  aat{1} = nttunpackm (unlift_matrix aT{2}) /\ pos_boundmatn_cxq aat{1} 0 matn 2 /\
  rhat{2} = lift_polyvec (nttpackv sp_0{1}) /\ pos_boundvecn_cxq sp_0{1} 0 vecn 2 /\
  lift_polyvec ep{1} = e1{2} /\ signed_boundvecn_cxq ep{1} 0 vecn 1 /\
  lift_array256 epp{1} = e2{2} /\ signed_bound_cxq epp{1} 0 256 1).
+ ecall {1} (polyvec_ntt_avx2_corr sp_0{1}).
  auto => /> &1 &2 ????? hkb ? hs he hepp bs be bepp.
  split; 1: by move=> k kb; have := bs k kb; smt().
  move=> _ r0 hr _; rewrite -hr; split.
  + by congr; apply eq_sym; apply lift_polyvec_noise.
  by apply lift_polyvec_noise.

(* the product with the transposed matrix, row by row *)
seq 2 0 : (#pre /\
  forall j, 0 <= j < kvec =>
    lift_array256 (subarray256 bp{1} j) =
      nttunpack (scale (ntt_mmul aT{2} rhat{2}).[j] (incoeff 169)) /\
    signed_bound_cxq (subarray256 bp{1} j) 0 256 kvec).
+ sp 1 0; while {1} (0 <= w{1} <= kvec /\
    aat{1} = nttunpackm (unlift_matrix aT{2}) /\ pos_boundmatn_cxq aat{1} 0 matn 2 /\
    rhat{2} = lift_polyvec (nttpackv sp_0{1}) /\ pos_boundvecn_cxq sp_0{1} 0 vecn 2 /\
    forall j, 0 <= j < w{1} =>
      lift_array256 (subarray256 bp{1} j) =
        nttunpack (scale (ntt_mmul aT{2} rhat{2}).[j] (incoeff 169)) /\
      signed_bound_cxq (subarray256 bp{1} j) 0 256 kvec) (kvec - w{1}).
  + move=> &m z; wp.
    ecall (polyvec_pointwise_acc_corr_alg_avx
             (invnttv (lift_polyvec (nttpackv (subarrayvecn aat w))))
             (invnttv (lift_polyvec (nttpackv sp_0)))
             (nttpackv (subarrayvecn aat w)) (nttpackv sp_0)).
    auto => /> &hr w0 wk hm hs hj wlt.
    have hsub : Array_vecn.init (fun i_0 =>
        (nttunpackm (unlift_matrix aT{m})).[w{hr} * (kvec * 256) + i_0]) =
      subarrayvecn (nttunpackm (unlift_matrix aT{m})) w{hr}.
    + apply Array_vecn.tP => k kb; rewrite /subarrayvecn !Array_vecn.initiE //= vecnE.
      by congr; ring.
    have hab := subarrayvecn_bnd _ 2 w{hr} _ hm; 1: smt().
    rewrite hsub !nttvK -!nttpackv_lift !packvK /=; split.
    + do split.
      - by apply nttpackv_signed_bnd.
      - by apply nttpackv_signed_bnd.
      - by move=> k kb; have := hab k kb; smt().
      by move=> k kb; have := hs k kb; smt().
    move=> _ _ _ _ r0 hr0b hr0v.
    do split; 1,2,4: smt().
    move=> j j0 jw; rewrite subarray256_upd_at 1,2:/#.
    case: (j = w{hr}) => [->|ne] /=; last by apply hj => /#.
    by rewrite hr0v ntt_dotp_row_eq_ntt_mmul 1:/#.
  auto => /> &1 &2 *; split; 1: smt(gt0_k).
  by move=> bp0 w0; split; [smt() | move=> wn w0' wk hj j j0 jk; apply hj => /#].

(* v = t . r, as the specification's dot product *)
seq 1 0 : (#pre /\
  lift_array256 v{1} = nttunpack (scale (ntt_dotp that{2} rhat{2}) (incoeff 169)) /\
  signed_bound_cxq v{1} 0 256 kvec).
+ ecall {1} (polyvec_pointwise_acc_corr_alg_avx (invnttv that{2}) (invnttv rhat{2})
             (unlift_polyvec that{2}) (nttpackv sp_0{1})).
  auto => /> &1 &2 hp hpb _ _ _ hs *.
  have [hl hlb] := vector_unlift (ofipolyvec (decode12_vec pk{2}.`1)).
  rewrite !nttvK hl /=; split.
  + do split.
    - by move=> k kb; have := hlb k kb; smt().
    - by apply nttpackv_signed_bnd.
    - rewrite hp lift_arrayvecn_unlift_ofipolyvec // IPVec.allP => k kb /=.
      by have := decode12_vec_bnd pk{2}.`1 k _; smt().
    - by rewrite lift_arrayvecn_nttunpackv_nttpackv.
    - by move=> k kb; have := hpb k kb; smt().
    by move=> k kb; have := hs k kb; smt().
  by move=> _ _ _ _ _ _ r _; rewrite ntt_dotp_invnttv nttvK.

(* the inverse NTTs, with their Montgomery factor *)
have hscale : forall (X : poly),
  mul1x256 (incoeff W16.modulus) (invntt (scale X (incoeff 169))) = invntt X.
+ move=> X; rewrite invntt_scale /scale tP => k kb; rewrite !mapiE //= ZqField.mulrCA.
  have -> : incoeff 65536 * incoeff 169 = Zq.one by rewrite -rrinvcoeff.
  by ring.
seq 2 0 : (
  lift_array256 k{1} = decompress_poly 1 (decode1 m{2}) /\ pos_bound256_cxq k{1} 0 256 1 /\
  lift_polyvec ep{1} = e1{2} /\ signed_boundvecn_cxq ep{1} 0 vecn 1 /\
  lift_array256 epp{1} = e2{2} /\ signed_bound_cxq epp{1} 0 256 1 /\
  lift_polyvec bp{1} = invnttv (ntt_mmul aT{2} rhat{2}) /\ signed_boundvecn_cxq bp{1} 0 vecn 1 /\
  lift_array256 v{1} = invntt (ntt_dotp that{2} rhat{2}) /\ signed_bound_cxq v{1} 0 256 1).
+ ecall {1} (poly_invntt_avx2_corr (nttpack v{1})).
  ecall {1} (polyvec_invntt_avx2_corr (nttpackv bp{1})).
  auto => /> &1 &2 _ _ hk hkb _ _ _ _ hj hv hvb.
  have hbp : lift_polyvec (nttpackv bp{1}) =
    KVec.init (fun j => scale (ntt_mmul aT{2} (lift_polyvec (nttpackv sp_0{1}))).[j] (incoeff 169)).
  + by apply kg_loop_post_to_target => j jb; rewrite KVec.initiE //=; case: (hj j jb).
  rewrite nttpackv_lift /=; split.
  + by apply signed_boundvecnP => j jb; have [_ ?] := hj j jb; smt(param_sets).
  move=> _ r hr _; split; 1: by move=> k kb; have := hvb k kb; smt(param_sets).
  move=> _ r0 hr0 _; rewrite -hr -hr0 hbp lift_nttpack hv nttunpackK hscale /=.
  apply KVec.tP => j jb; rewrite /mapv /invnttv !KVec.mapiE //= KVec.initiE //=.
  by rewrite hscale.

(* the noise and the message added, and reduced *)
seq 5 3 : (lift_polyvec bp{1} = u{2} /\ pos_boundvecn_cxq bp{1} 0 vecn 2 /\
           lift_array256 v{1} = v{2} /\ pos_bound256_cxq v{1} 0 256 2).
+ have ha11 := poly_add_corr_avx 1 1 _ _ => //.
  have ha21 := poly_add_corr_avx 2 1 _ _ => //.
  have hva := polyvec_add_corr_avx 1 1 _ _ => //.
  ecall {1} (poly_reduce_corr_avx (lift_array256 v{1})).
  ecall {1} (polyvec_reduce_corr_avx (lift_arrayvecn bp{1})).
  ecall {1} (ha21 (lift_array256 v{1}) (lift_array256 k{1})).
  ecall {1} (ha11 (lift_array256 v{1}) (lift_array256 epp{1})).
  ecall {1} (hva (lift_arrayvecn bp{1}) (lift_arrayvecn ep{1})).
  auto => /> &1 &2 hk hkb heb heppb hbp hbpb hv hvb.
  move=> r1 _ hr1 r2 _ hr2; split; 1: by move=> k kb; have := hkb k kb; smt().
  move=> _ r3 _ hr3 r4 hr4 _ r5 hr5 _; split.
  + apply KVec.tP => j jb; rewrite polyvec_addE // !lift_polyvecE // !lift_subarray256 // -hr4.
    apply Array256.tP => k kb; rewrite /(&+) map2iE // !subarray256E //.
    rewrite -hbp lift_polyvecE // lift_subarray256 // subarray256E //=.
    have hjk := vecn_slice j k jb kb.
    by rewrite {1}/lift_arrayvecn Array_vecn.mapiE //= hr1.
  rewrite -hr5 -hv -hk tP => k kb; rewrite !map2iE //.
  rewrite {1}/lift_array256 Array256.mapiE //= hr3 //.
  by rewrite {1}/lift_array256 Array256.mapiE //= hr2.

(* the compressions, into the ciphertext *)
wp; ecall {1} (i_poly_compress_corr v{1}).
wp; ecall {1} (polyvec_compress_avx2_corr bp{1}).
auto => /> &1 _ _ r hr r0 hr0.
have hpc : kvec * (256 * du %/ 8) = polyvecc_bytes.
+ by rewrite /polyvecc_bytes (: 256 * du = 32 * du * 8) 1:#ring mulzK.
have hpad : polyvecc_bytes <= polyvecc_pad by rewrite /polyvecc_pad; smt(param_sets).
have hct : ct_bytes = polyvecc_bytes + polyc_bytes by done.
rewrite hpc -hr -hr0; split.
+ apply BytesCtVec.tP => k kb; rewrite !BytesCtVec.initiE //=.
  have hk : k < polyvecc_bytes by rewrite /polyvecc_bytes; smt().
  rewrite Array_ct_bytes.initiE 1:#smt:(ge0_polyc_bytes) /= ifF 1:/#.
  by rewrite Array_ct_bytes.initiE 1:#smt:(ge0_polyc_bytes) /= ifT 1:/#.
apply BytesPoly.tP => k kb; rewrite !BytesPoly.initiE //=.
have hk : k < polyc_bytes by rewrite /polyc_bytes; smt().
rewrite Array_ct_bytes.initiE 1:#smt:(ge0_polyvecc_bytes) /= ifT 1:/#.
by congr; ring.
qed.

lemma mlkem_correct_enc_1_avx2 _pkp :
  equiv [M.__indcpa_enc ~ KPKE.encrypt :
    msgp{1} = m{2} /\ pk{1} = _pkp /\
    noiseseed{1} = coins{2} /\
    pk{2}.`1 = BytesPKVec.init (fun i => pk{1}.[i]) /\
    pk{2}.`2 = Array32.init (fun i => pk{1}.[i + polyvec_bytes])
    ==>
    let (c1,c2) = res{2} in
    c1 = BytesCtVec.init (fun i => res{1}.[i]) /\
    c2 = BytesPoly.init (fun i => res{1}.[i + polyvecc_bytes])].
proof.
transitivity InnerPKE_Op.enc_derand
  (msgp{1} = m{2} /\ pk{1} = _pkp /\
   noiseseed{1} = r{2} /\
   pk{2}.`1 = BytesPKVec.init (fun i => pk{1}.[i]) /\
   pk{2}.`2 = Array32.init (fun i => pk{1}.[i + polyvec_bytes])
   ==>
   let (c1,c2) = res{2} in
   c1 = BytesCtVec.init (fun i => res{1}.[i]) /\
   c2 = BytesPoly.init (fun i => res{1}.[i + polyvecc_bytes]))
  (={arg} ==> ={res}).
+ smt().
+ smt().
+ exact (mlkem_correct_enc_avx2_op _pkp).
by conseq enc_op_eq.
qed.

end MLKEM_InnerPKE_avx2T.
