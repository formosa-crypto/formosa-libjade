(* -------------------------------------------------------------------- *)
(* The 12-bit encodings of polynomials and vectors, at abstract         *)
(* parameters: the polynomial ones by circuit, the vector ones          *)
(* polynomial by polynomial.                                            *)
(* -------------------------------------------------------------------- *)
require import AllCore List Int IntDiv CoreMap Real Number Ring StdOrder BitEncoding.
from Jasmin require import JModel_x86.
from JazzEC require import Array384 Array256 Array32 Array16.
from JazzEC require import WArray512 WArray384 WArray32.
require import AVX2_Ops W16extra.
require import Fq MLKEMFCLib.
require import Mlkem_bindings CircuitBindings.
require import XWord12.
require import XArray16 XArray32 XArray256 XArray384.
require import Circuit_semantics.
from Spec require import GFq Rq Serialization Sampling EncDecCorrectness Correctness.
require import JkemConstants.
require import PreludeT.
require BaseT Fq_avx2T MLKEM_ntt_levelsT MLKEM_ntt_avx2T MLKEM_invntt_levelsT.
require MLKEM_invntt_avx2T MLKEM_basemul_avx2T NTT_avx2_polyT MLKEM_Poly_avx2T.
require MLKEM_Poly_avx2_circuitT NTT_avx2T.

abstract theory MLKEM_PolyVec_avx2_circuitT.

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

import BitChunking BS2Int.
import Fq.
import GFq Rq Serialization.
import Zq ZModP.
import MLKEM_PolyAVX.
import W12.

(* -------------------------------------------------------------------- *)
(* the decoding of one polynomial                                       *)
lemma poly_frombytes_ll : islossless M._i_poly_frombytes.
proof. by proc; inline *; cfold 2; unroll for ^while; auto. qed.

lemma pos_bound256_all (x : W16.t Array256.t) c :
  Array256.all (fun w => bpos16 w (c * q)) x => pos_bound256_cxq x 0 256 c.
proof. by move=> /Array256.allP h k kb; apply h. qed.

op nttunpack_16 (rp : W16.t Array256.t) : W16.t Array256.t =
  BSWA_256u16.init (fun (i : int) => rp.[nttunpack_idx.[i]]).

lemma nttunpack_16E v : nttunpack_16 v = nttunpack v.
proof. by rewrite /nttunpack_16 /nttunpack /BSWA_256u16.init. qed.

lemma poly_frombytes_corr_h (_aw : W8.t Array384.t) :
  hoare [M._i_poly_frombytes : ap = _aw ==>
    lift_array256 res = nttunpack (map incoeff (decode12 _aw)) /\
    pos_bound256_cxq res 0 256 2].
proof.
proc; inline *.
proc change 1 : { mask <- BSWAS_16u16_256.sliceget maskx16 0; }.
+ by auto; move=> &1 &2 ?; rewrite BSWAS_16u16_256_slicegetE /#.
proc change ^while.1 : {
  t0 <-
    if (0 <= (192*i)*8 <= 8*384-256) then BSWAS_384u8_256.sliceget ap ((192*i)*8)
    else get256_direct (WArray384.init8 (fun (i_0 : int) => ap.[i_0])) (192*i); }.
+ by auto; move=> &1 &2 [#] -> ->;
  case: (0 <= (192*i{2})*8 <= 8*384-256); [move=> ?; rewrite BSWAS_384u8_256_slicegetE /# | by
    auto].
proc change ^while.2 : {
  t1 <-
    if (0 <= (192*i+32)*8 <= 8*384-256) then BSWAS_384u8_256.sliceget ap ((192*i+32)*8)
    else get256_direct (WArray384.init8 (fun (i_0 : int) => ap.[i_0])) (192*i+32); }.
+ by auto; move=> &1 &2 [#] -> ->;
  case: (0 <= (192*i{2}+32)*8 <= 8*384-256); [move=> ?; rewrite BSWAS_384u8_256_slicegetE /# | by
    auto].
proc change ^while.3 : {
  t2 <-
    if (0 <= (192*i+64)*8 <= 8*384-256) then BSWAS_384u8_256.sliceget ap ((192*i+64)*8)
    else get256_direct (WArray384.init8 (fun (i_0 : int) => ap.[i_0])) (192*i+64); }.
+ by auto; move=> &1 &2 [#] -> ->;
  case: (0 <= (192*i{2}+64)*8 <= 8*384-256); [move=> ?; rewrite BSWAS_384u8_256_slicegetE /# | by
    auto].
proc change ^while.4 : {
  t3 <-
    if (0 <= (192*i+96)*8 <= 8*384-256) then BSWAS_384u8_256.sliceget ap ((192*i+96)*8)
    else get256_direct (WArray384.init8 (fun (i_0 : int) => ap.[i_0])) (192*i+96); }.
+ by auto; move=> &1 &2 [#] -> ->;
  case: (0 <= (192*i{2}+96)*8 <= 8*384-256); [move=> ?; rewrite BSWAS_384u8_256_slicegetE /# | by
    auto].
proc change ^while.5 : {
  t4 <-
    if (0 <= (192*i+128)*8 <= 8*384-256) then BSWAS_384u8_256.sliceget ap ((192*i+128)*8)
    else get256_direct (WArray384.init8 (fun (i_0 : int) => ap.[i_0])) (192*i+128); }.
+ by auto; move=> &1 &2 [#] -> ->;
  case: (0 <= (192*i{2}+128)*8 <= 8*384-256); [move=> ?; rewrite BSWAS_384u8_256_slicegetE /# | by
    auto].
proc change ^while.6 : {
  t5 <-
    if (0 <= (192*i+160)*8 <= 8*384-256) then BSWAS_384u8_256.sliceget ap ((192*i+160)*8)
    else get256_direct (WArray384.init8 (fun (i_0 : int) => ap.[i_0])) (192*i+160); }.
+ by auto; move=> &1 &2 [#] -> ->;
  case: (0 <= (192*i{2}+160)*8 <= 8*384-256); [move=> ?; rewrite BSWAS_384u8_256_slicegetE /# | by
    auto].
proc change ^while.101 : {
  rp <-
    if (0 <= (32*(8*i))*8 <= 256*16-256) then BSWAS_256u16_256.sliceset rp ((32*(8*i))*8) t6
    else Array256.init (fun (i1:int) => WArray512.get16 (WArray512.set256 (WArray512.init16 (fun
      (i_0 : int) => rp.[i_0])) (8*i) t6) i1); }.
+ by auto; move=> &1 &2 [#] -> -> ->;
  case: (0 <= (32*(8*i{2}))*8 <= 256*16-256); [move=> ?; rewrite BSWAS_256u16_256_slicesetE // | by
    auto].
proc change ^while.102 : {
  rp <-
    if (0 <= (32*(8*i+1))*8 <= 256*16-256) then BSWAS_256u16_256.sliceset rp ((32*(8*i+1))*8) t7
    else Array256.init (fun (i1:int) => WArray512.get16 (WArray512.set256 (WArray512.init16 (fun
      (i_0 : int) => rp.[i_0])) (8*i+1) t7) i1); }.
+ by auto; move=> &1 &2 [#] -> -> ->;
  case: (0 <= (32*(8*i{2}+1))*8 <= 256*16-256); [move=> ?; rewrite BSWAS_256u16_256_slicesetE // |
    by auto].
proc change ^while.103 : {
  rp <-
    if (0 <= (32*(8*i+2))*8 <= 256*16-256) then BSWAS_256u16_256.sliceset rp ((32*(8*i+2))*8) t8
    else Array256.init (fun (i1:int) => WArray512.get16 (WArray512.set256 (WArray512.init16 (fun
      (i_0 : int) => rp.[i_0])) (8*i+2) t8) i1); }.
+ by auto; move=> &1 &2 [#] -> -> ->;
  case: (0 <= (32*(8*i{2}+2))*8 <= 256*16-256); [move=> ?; rewrite BSWAS_256u16_256_slicesetE // |
    by auto].
proc change ^while.104 : {
  rp <-
    if (0 <= (32*(8*i+3))*8 <= 256*16-256) then BSWAS_256u16_256.sliceset rp ((32*(8*i+3))*8) t9
    else Array256.init (fun (i1:int) => WArray512.get16 (WArray512.set256 (WArray512.init16 (fun
      (i_0 : int) => rp.[i_0])) (8*i+3) t9) i1); }.
+ by auto; move=> &1 &2 [#] -> -> ->;
  case: (0 <= (32*(8*i{2}+3))*8 <= 256*16-256); [move=> ?; rewrite BSWAS_256u16_256_slicesetE // |
    by auto].
proc change ^while.105 : {
  rp <-
    if (0 <= (32*(8*i+4))*8 <= 256*16-256) then BSWAS_256u16_256.sliceset rp ((32*(8*i+4))*8) t4
    else Array256.init (fun (i1:int) => WArray512.get16 (WArray512.set256 (WArray512.init16 (fun
      (i_0 : int) => rp.[i_0])) (8*i+4) t4) i1); }.
+ by auto; move=> &1 &2 [#] -> -> ->;
  case: (0 <= (32*(8*i{2}+4))*8 <= 256*16-256); [move=> ?; rewrite BSWAS_256u16_256_slicesetE // |
    by auto].
proc change ^while.106 : {
  rp <-
    if (0 <= (32*(8*i+5))*8 <= 256*16-256) then BSWAS_256u16_256.sliceset rp ((32*(8*i+5))*8) t10
    else Array256.init (fun (i1:int) => WArray512.get16 (WArray512.set256 (WArray512.init16 (fun
      (i_0 : int) => rp.[i_0])) (8*i+5) t10) i1); }.
+ by auto; move=> &1 &2 [#] -> -> ->;
  case: (0 <= (32*(8*i{2}+5))*8 <= 256*16-256); [move=> ?; rewrite BSWAS_256u16_256_slicesetE // |
    by auto].
proc change ^while.107 : {
  rp <-
    if (0 <= (32*(8*i+6))*8 <= 256*16-256) then BSWAS_256u16_256.sliceset rp ((32*(8*i+6))*8) t11
    else Array256.init (fun (i1:int) => WArray512.get16 (WArray512.set256 (WArray512.init16 (fun
      (i_0 : int) => rp.[i_0])) (8*i+6) t11) i1); }.
+ by auto; move=> &1 &2 [#] -> -> ->;
  case: (0 <= (32*(8*i{2}+6))*8 <= 256*16-256); [move=> ?; rewrite BSWAS_256u16_256_slicesetE // |
    by auto].
proc change ^while.108 : {
  rp <-
    if (0 <= (32*(8*i+7))*8 <= 256*16-256) then BSWAS_256u16_256.sliceset rp ((32*(8*i+7))*8) tt
    else Array256.init (fun (i1:int) => WArray512.get16 (WArray512.set256 (WArray512.init16 (fun
      (i_0 : int) => rp.[i_0])) (8*i+7) tt) i1); }.
+ by auto; move=> &1 &2 [#] -> -> ->;
  case: (0 <= (32*(8*i{2}+7))*8 <= 256*16-256); [move=> ?; rewrite BSWAS_256u16_256_slicesetE // |
    by auto].
unroll for ^while; cfold ^i<-; wp 217.
conseq (: _ ==> rp = nttunpack_16 (BSWA_256u16.init (fun i =>
  frombytes_circuit (W12.init (fun j =>
    let idx = i * 12 + j in let aidx = idx %/ 8 in let bidx = idx %% 8 in
    _aw.[aidx].[bidx]))))); last by circuit.
move=> &hr <- rr ->; rewrite nttunpack_16E; split.
+ rewrite lift_nttunpack; congr; apply Array256.tP => i ib.
  rewrite /lift_array256 !Array256.mapiE // /BSWA_256u16.init Array256.initiE //=.
  by rewrite frombytes_circuit_sem384.
apply/pos_bound256_all/nttunpack_pred/Array256.allP => i ib /=.
rewrite /BSWA_256u16.init Array256.initiE //= qE /=.
by have := frombytes_circuit_rng384 ap{hr} i; rewrite /bpos16 /#.
qed.

lemma poly_frombytes_corr (_aw : W8.t Array384.t) :
  phoare [M._i_poly_frombytes : ap = _aw ==>
    lift_array256 res = nttunpack (map incoeff (decode12 _aw)) /\
    pos_bound256_cxq res 0 256 2] = 1%r.
proof. by conseq poly_frombytes_ll (poly_frombytes_corr_h _aw). qed.

(* -------------------------------------------------------------------- *)
(* the encoding of one polynomial: the model, with the 12-bit masks     *)
(* that its bounded inputs make no-ops, is proved by circuit            *)
abbrev mask12 = VPBROADCAST_16u16 (W16.of_int 4095).

module AuxToBytes = {
  proc poly_tobytes (rp : W8.t Array384.t, a : W16.t Array256.t) :
    W8.t Array384.t * W16.t Array256.t = {
    var i, t0, t1, t2, t3, t4, t5, t6, t7, tt, ttt, a1, b, t00, r00, t10, r1, a2, b0, t01, r01, t11,
      r10, a3, b1, t02, r02, t12, r11, a4, b2, t03, t13, a5, b3, t04, t14, a6, b4, t05, t15, a7, b5,
      r03, r12, a8, b6, r04, r13, a9, b7, r05, r14, a10, b8, r06, r15, a11, b9, r07, r16, a12, b10,
      r08, r17;
    a <@ M._poly_csubq(a);
    i <- 0;
    while (i < 2) {
      t0 <- get256 (WArray512.init16 (fun (i_0 : int) => a.[i_0])) (8 * i);
      t1 <- get256 (WArray512.init16 (fun (i_0 : int) => a.[i_0])) (8 * i + 1);
      t2 <- get256 (WArray512.init16 (fun (i_0 : int) => a.[i_0])) (8 * i + 2);
      t3 <- get256 (WArray512.init16 (fun (i_0 : int) => a.[i_0])) (8 * i + 3);
      t4 <- get256 (WArray512.init16 (fun (i_0 : int) => a.[i_0])) (8 * i + 4);
      t5 <- get256 (WArray512.init16 (fun (i_0 : int) => a.[i_0])) (8 * i + 5);
      t6 <- get256 (WArray512.init16 (fun (i_0 : int) => a.[i_0])) (8 * i + 6);
      t7 <- get256 (WArray512.init16 (fun (i_0 : int) => a.[i_0])) (8 * i + 7);
      t0 <- t0 `&` mask12;
      t1 <- t1 `&` mask12;
      t2 <- t2 `&` mask12;
      t3 <- t3 `&` mask12;
      t4 <- t4 `&` mask12;
      t5 <- t5 `&` mask12;
      t6 <- t6 `&` mask12;
      t7 <- t7 `&` mask12;
      tt <- VPSLL_16u16 t1 (W128.of_int 12);
      tt <- tt `|` t0;
      t0 <- VPSRL_16u16 t1 (W128.of_int 4);
      t1 <- VPSLL_16u16 t2 (W128.of_int 8);
      t0 <- t0 `|` t1;
      t1 <- VPSRL_16u16 t2 (W128.of_int 8);
      t2 <- VPSLL_16u16 t3 (W128.of_int 4);
      t1 <- t1 `|` t2;
      t2 <- VPSLL_16u16 t5 (W128.of_int 12);
      t2 <- t2 `|` t4;
      t3 <- VPSRL_16u16 t5 (W128.of_int 4);
      t4 <- VPSLL_16u16 t6 (W128.of_int 8);
      t3 <- t3 `|` t4;
      t4 <- VPSRL_16u16 t6 (W128.of_int 8);
      t5 <- VPSLL_16u16 t7 (W128.of_int 4);
      t4 <- t4 `|` t5;
      a1 <- tt;
      b <- t0;
      t00 <- VPSLL_8u32 b (W128.of_int 16);
      r00 <- VPBLENDW_256 a1 t00 (W8.of_int 170);
      t10 <- VPSRL_8u32 a1 (W128.of_int 16);
      r1 <- VPBLENDW_256 t10 b (W8.of_int 170);
      (ttt, t0) <- (r00, r1);
      a2 <- t1;
      b0 <- t2;
      t01 <- VPSLL_8u32 b0 (W128.of_int 16);
      r01 <- VPBLENDW_256 a2 t01 (W8.of_int 170);
      t11 <- VPSRL_8u32 a2 (W128.of_int 16);
      r10 <- VPBLENDW_256 t11 b0 (W8.of_int 170);
      (tt, t2) <- (r01, r10);
      a3 <- t3;
      b1 <- t4;
      t02 <- VPSLL_8u32 b1 (W128.of_int 16);
      r02 <- VPBLENDW_256 a3 t02 (W8.of_int 170);
      t12 <- VPSRL_8u32 a3 (W128.of_int 16);
      r11 <- VPBLENDW_256 t12 b1 (W8.of_int 170);
      (t1, t4) <- (r02, r11);
      a4 <- ttt;
      b2 <- tt;
      t03 <- VMOVSLDUP_256 b2;
      t03 <- VPBLENDD_256 a4 t03 (W8.of_int 170);
      a4 <- VPSRL_4u64 a4 (W128.of_int 32);
      t13 <- VPBLENDD_256 a4 b2 (W8.of_int 170);
      (t3, tt) <- (t03, t13);
      a5 <- t1;
      b3 <- t0;
      t04 <- VMOVSLDUP_256 b3;
      t04 <- VPBLENDD_256 a5 t04 (W8.of_int 170);
      a5 <- VPSRL_4u64 a5 (W128.of_int 32);
      t14 <- VPBLENDD_256 a5 b3 (W8.of_int 170);
      (ttt, t0) <- (t04, t14);
      a6 <- t2;
      b4 <- t4;
      t05 <- VMOVSLDUP_256 b4;
      t05 <- VPBLENDD_256 a6 t05 (W8.of_int 170);
      a6 <- VPSRL_4u64 a6 (W128.of_int 32);
      t15 <- VPBLENDD_256 a6 b4 (W8.of_int 170);
      (t1, t4) <- (t05, t15);
      a7 <- t3;
      b5 <- ttt;
      r03 <- VPUNPCKL_4u64 a7 b5;
      r12 <- VPUNPCKH_4u64 a7 b5;
      (t2, ttt) <- (r03, r12);
      a8 <- t1;
      b6 <- tt;
      r04 <- VPUNPCKL_4u64 a8 b6;
      r13 <- VPUNPCKH_4u64 a8 b6;
      (t3, tt) <- (r04, r13);
      a9 <- t0;
      b7 <- t4;
      r05 <- VPUNPCKL_4u64 a9 b7;
      r14 <- VPUNPCKH_4u64 a9 b7;
      (t1, t4) <- (r05, r14);
      a10 <- t2;
      b8 <- t3;
      r06 <- VPERM2I128 a10 b8 (W8.of_int 32);
      r15 <- VPERM2I128 a10 b8 (W8.of_int 49);
      (t0, t3) <- (r06, r15);
      a11 <- t1;
      b9 <- ttt;
      r07 <- VPERM2I128 a11 b9 (W8.of_int 32) ;
      r16 <- VPERM2I128 a11 b9 (W8.of_int 49) ;
      (t2, ttt) <- (r07, r16);
      a12 <- tt;
      b10 <- t4;
      r08 <- VPERM2I128 a12 b10 (W8.of_int 32);
      r17 <- VPERM2I128 a12 b10 (W8.of_int 49);
      (t1, t4) <- (r08, r17);
      rp <-
        Array384.init
          (WArray384.get8
             (WArray384.set256_direct (WArray384.init8 (fun (i_0 : int) => rp.[i_0])) (192 * i)
               t0));
      rp <-
        Array384.init
          (WArray384.get8
             (WArray384.set256_direct (WArray384.init8 (fun (i_0 : int) => rp.[i_0])) (192 * i + 32)
               t2));
      rp <-
        Array384.init
          (WArray384.get8
             (WArray384.set256_direct (WArray384.init8 (fun (i_0 : int) => rp.[i_0])) (192 * i + 64)
               t1));
      rp <-
        Array384.init
          (WArray384.get8
             (WArray384.set256_direct (WArray384.init8 (fun (i_0 : int) => rp.[i_0])) (192 * i + 96)
               t3));
      rp <-
        Array384.init
          (WArray384.get8
             (WArray384.set256_direct (WArray384.init8 (fun (i_0 : int) => rp.[i_0])) (
                192 * i + 128) ttt));
      rp <-
        Array384.init
          (WArray384.get8
             (WArray384.set256_direct (WArray384.init8 (fun (i_0 : int) => rp.[i_0])) (192 * i +
               160) t4));
      i <- i + 1;
    }
    return (rp, a);
  }
}.

op nttpack_16 (rp : W16.t Array256.t) =
  BSWA_256u16.init (fun (i : int) => rp.[nttpack_idx.[i]]).

lemma nttpack_16E v : nttpack_16 v = nttpack v.
proof. by rewrite /nttpack_16 /BSWA_256u16.init /nttpack. qed.

lemma auxtobytes_corr_h (_aw : W16.t Array256.t) :
  hoare [AuxToBytes.poly_tobytes :
    pos_bound256_cxq a 0 256 2 /\ a = _aw ==>
    res.`1 = encode12 (map asint (lift_array256 (nttpack _aw)))].
proof.
proc; inline *.
proc change 2 : {
  qx16 <- BSWAS_16u16_256.sliceget jqx16 0; }.
+ by auto; move=> &1 &2 ?; rewrite BSWAS_16u16_256_slicegetE /#.
proc change ^while.1 : {
  r <-
    if (0 <= (32*i0)*8 <= 256*16-256) then BSWAS_256u16_256.sliceget rp0 ((32*i0)*8)
    else get256_direct (WArray512.init16 (fun (i_0 : int) => rp0.[i_0])) (32*i0); }.
+ by auto; move=> &1 &2 [#] _ _ -> ->;
  case: (0 <= (32*i0{2})*8 <= 256*16-256); [move=> ?; rewrite BSWAS_256u16_256_slicegetE /# | by
    auto].
proc change ^while.9 : {
  rp0 <-
    if (0 <= (32*i0)*8 <= 256*16-256) then BSWAS_256u16_256.sliceset rp0 ((32*i0)*8) r
    else Array256.init (fun (i1:int) => WArray512.get16 (WArray512.set256 (WArray512.init16 (fun
      (i_0 : int) => rp0.[i_0])) i0 r) i1); }.
+ by auto; move=> &1 &2 [#] _ _ -> -> ->;
  case: (0 <= (32*i0{2})*8 <= 256*16-256); [move=> ?; rewrite BSWAS_256u16_256_slicesetE // | by
    auto].
proc change ^while{2}.1 : {
  t0 <-
    if (0 <= (32*(8*i))*8 <= 256*16-256) then BSWAS_256u16_256.sliceget a ((32*(8*i))*8)
    else get256_direct (WArray512.init16 (fun (i_0 : int) => a.[i_0])) (32*(8*i)); }.
+ by auto; move=> &1 &2 [#] -> ->;
  case: (0 <= (32*(8*i{2}))*8 <= 256*16-256); [move=> ?; rewrite BSWAS_256u16_256_slicegetE /# | by
    auto].
proc change ^while{2}.2 : {
  t1 <-
    if (0 <= (32*(8*i+1))*8 <= 256*16-256) then BSWAS_256u16_256.sliceget a ((32*(8*i+1))*8)
    else get256_direct (WArray512.init16 (fun (i_0 : int) => a.[i_0])) (32*(8*i+1)); }.
+ by auto; move=> &1 &2 [#] -> ->;
  case: (0 <= (32*(8*i{2}+1))*8 <= 256*16-256); [move=> ?; rewrite BSWAS_256u16_256_slicegetE /# |
    by auto].
proc change ^while{2}.3 : {
  t2 <-
    if (0 <= (32*(8*i+2))*8 <= 256*16-256) then BSWAS_256u16_256.sliceget a ((32*(8*i+2))*8)
    else get256_direct (WArray512.init16 (fun (i_0 : int) => a.[i_0])) (32*(8*i+2)); }.
+ by auto; move=> &1 &2 [#] -> ->;
  case: (0 <= (32*(8*i{2}+2))*8 <= 256*16-256); [move=> ?; rewrite BSWAS_256u16_256_slicegetE /# |
    by auto].
proc change ^while{2}.4 : {
  t3 <-
    if (0 <= (32*(8*i+3))*8 <= 256*16-256) then BSWAS_256u16_256.sliceget a ((32*(8*i+3))*8)
    else get256_direct (WArray512.init16 (fun (i_0 : int) => a.[i_0])) (32*(8*i+3)); }.
+ by auto; move=> &1 &2 [#] -> ->;
  case: (0 <= (32*(8*i{2}+3))*8 <= 256*16-256); [move=> ?; rewrite BSWAS_256u16_256_slicegetE /# |
    by auto].
proc change ^while{2}.5 : {
  t4 <-
    if (0 <= (32*(8*i+4))*8 <= 256*16-256) then BSWAS_256u16_256.sliceget a ((32*(8*i+4))*8)
    else get256_direct (WArray512.init16 (fun (i_0 : int) => a.[i_0])) (32*(8*i+4)); }.
+ by auto; move=> &1 &2 [#] -> ->;
  case: (0 <= (32*(8*i{2}+4))*8 <= 256*16-256); [move=> ?; rewrite BSWAS_256u16_256_slicegetE /# |
    by auto].
proc change ^while{2}.6 : {
  t5 <-
    if (0 <= (32*(8*i+5))*8 <= 256*16-256) then BSWAS_256u16_256.sliceget a ((32*(8*i+5))*8)
    else get256_direct (WArray512.init16 (fun (i_0 : int) => a.[i_0])) (32*(8*i+5)); }.
+ by auto; move=> &1 &2 [#] -> ->;
  case: (0 <= (32*(8*i{2}+5))*8 <= 256*16-256); [move=> ?; rewrite BSWAS_256u16_256_slicegetE /# |
    by auto].
proc change ^while{2}.7 : {
  t6 <-
    if (0 <= (32*(8*i+6))*8 <= 256*16-256) then BSWAS_256u16_256.sliceget a ((32*(8*i+6))*8)
    else get256_direct (WArray512.init16 (fun (i_0 : int) => a.[i_0])) (32*(8*i+6)); }.
+ by auto; move=> &1 &2 [#] -> ->;
  case: (0 <= (32*(8*i{2}+6))*8 <= 256*16-256); [move=> ?; rewrite BSWAS_256u16_256_slicegetE /# |
    by auto].
proc change ^while{2}.8 : {
  t7 <-
    if (0 <= (32*(8*i+7))*8 <= 256*16-256) then BSWAS_256u16_256.sliceget a ((32*(8*i+7))*8)
    else get256_direct (WArray512.init16 (fun (i_0 : int) => a.[i_0])) (32*(8*i+7)); }.
+ by auto; move=> &1 &2 [#] -> ->;
  case: (0 <= (32*(8*i{2}+7))*8 <= 256*16-256); [move=> ?; rewrite BSWAS_256u16_256_slicegetE /# |
    by auto].
proc change ^while{2}.105 : {
  rp <-
    if (0 <= (192*i)*8 <= 8*384-256) then BSWAS_384u8_256.sliceset rp ((192*i)*8) t0
    else Array384.init (WArray384.get8 (WArray384.set256_direct (WArray384.init8 (fun (i_0 : int) =>
      rp.[i_0])) (192*i) t0)); }.
+ by auto; move=> &1 &2 [#] -> -> ->;
  case: (0 <= (192*i{2})*8 <= 8*384-256); [move=> ?; rewrite BSWAS_384u8_256_slicesetE // | by
    auto].
proc change ^while{2}.106 : {
  rp <-
    if (0 <= (192*i+32)*8 <= 8*384-256) then BSWAS_384u8_256.sliceset rp ((192*i+32)*8) t2
    else Array384.init (WArray384.get8 (WArray384.set256_direct (WArray384.init8 (fun (i_0 : int) =>
      rp.[i_0])) (192*i+32) t2)); }.
+ by auto; move=> &1 &2 [#] -> -> ->;
  case: (0 <= (192*i{2}+32)*8 <= 8*384-256); [move=> ?; rewrite BSWAS_384u8_256_slicesetE // | by
    auto].
proc change ^while{2}.107 : {
  rp <-
    if (0 <= (192*i+64)*8 <= 8*384-256) then BSWAS_384u8_256.sliceset rp ((192*i+64)*8) t1
    else Array384.init (WArray384.get8 (WArray384.set256_direct (WArray384.init8 (fun (i_0 : int) =>
      rp.[i_0])) (192*i+64) t1)); }.
+ by auto; move=> &1 &2 [#] -> -> ->;
  case: (0 <= (192*i{2}+64)*8 <= 8*384-256); [move=> ?; rewrite BSWAS_384u8_256_slicesetE // | by
    auto].
proc change ^while{2}.108 : {
  rp <-
    if (0 <= (192*i+96)*8 <= 8*384-256) then BSWAS_384u8_256.sliceset rp ((192*i+96)*8) t3
    else Array384.init (WArray384.get8 (WArray384.set256_direct (WArray384.init8 (fun (i_0 : int) =>
      rp.[i_0])) (192*i+96) t3)); }.
+ by auto; move=> &1 &2 [#] -> -> ->;
  case: (0 <= (192*i{2}+96)*8 <= 8*384-256); [move=> ?; rewrite BSWAS_384u8_256_slicesetE // | by
    auto].
proc change ^while{2}.109 : {
  rp <-
    if (0 <= (192*i+128)*8 <= 8*384-256) then BSWAS_384u8_256.sliceset rp ((192*i+128)*8) ttt
    else Array384.init (WArray384.get8 (WArray384.set256_direct (WArray384.init8 (fun (i_0 : int) =>
      rp.[i_0])) (192*i+128) ttt)); }.
+ by auto; move=> &1 &2 [#] -> -> ->;
  case: (0 <= (192*i{2}+128)*8 <= 8*384-256); [move=> ?; rewrite BSWAS_384u8_256_slicesetE // | by
    auto].
proc change ^while{2}.110 : {
  rp <-
    if (0 <= (192*i+160)*8 <= 8*384-256) then BSWAS_384u8_256.sliceset rp ((192*i+160)*8) t4
    else Array384.init (WArray384.get8 (WArray384.set256_direct (WArray384.init8 (fun (i_0 : int) =>
      rp.[i_0])) (192*i+160) t4)); }.
+ by auto; move=> &1 &2 [#] -> -> ->;
  case: (0 <= (192*i{2}+160)*8 <= 8*384-256); [move=> ?; rewrite BSWAS_384u8_256_slicesetE // | by
    auto].
do 2!(unroll for ^while); wp 368; kill 147; 1: by auto.
conseq (: a = _aw /\
  Array256.all (fun bv => W16.zero \sle bv /\ bv \slt (of_int (2 * 3329))) a ==>
  rp = let ret = BSWA_256u12.init (fun j => tobytes_circuit (nttpack_16 _aw).[j]) in
  BSWA_384u8.init (fun i => W8.init (fun j =>
    let idx = i * 8 + j in let aidx = idx %/ 12 in let bidx = idx %% 12 in
    W12."_.[_]" (ret.[aidx]) bidx))); last by circuit.
+ move=> &hr />; rewrite Array256.allP /= /pos_bound256_cxq /(\sle) /(\slt) /= !of_sintK /smod /=.
  by rewrite qE /= => H k ?; move: (H k _) => //=.
move=> &hr [H0 Ha] a0 rr ->; rewrite -Ha /=.
move: H0 => /= H0; rewrite /BSWA_384u8.init /encode12; apply Array384.tP => i ib.
rewrite Array384.initiE 1:/# /= Array384.get_of_list 1:/# /=; apply/W8.wordP => k kb.
rewrite W8.initiE //= /BSWA_256u12.init Array256.initiE 1:/# /=.
have := nttpack_pred a{hr} (fun c => bpos16 c (2 * q)).
rewrite !Array256.allP /= iffE qE /= => [# _ H].
rewrite nttpack_16E to_bytes_circuit_sem //; rewrite /(\ult) /=.
have := H _ ((i * 8 + k) %/ 12) _; 2: smt().
+ by move: H0; rewrite /pos_bound256_cxq /bpos16 qE /#.
by rewrite /to_sint /smod /=; smt(W16.to_uint_cmp).
qed.

lemma auxtobytes_ll : islossless AuxToBytes.poly_tobytes.
proof. by proc; inline *; do 2!(unroll for ^while); auto. qed.

lemma auxtobytes_corr (_aw : W16.t Array256.t) :
  phoare [AuxToBytes.poly_tobytes :
    pos_bound256_cxq a 0 256 2 /\ a = _aw ==>
    res.`1 = encode12 (map asint (lift_array256 (nttpack _aw)))] = 1%r.
proof. by conseq auxtobytes_ll (auxtobytes_corr_h _aw). qed.

(* the 12-bit mask keeps a reduced coefficient *)
lemma get256_mask12 (x : W16.t Array256.t) j :
  pos_bound256_cxq x 0 256 1 => 0 <= j < 16 =>
  get256 (WArray512.init16 ("_.[_]" x)) j `&` mask12 = get256 (WArray512.init16 ("_.[_]" x)) j.
proof.
move=> hb jb.
have hx : forall ii, 0 <= ii < 256 =>
  (get256 (WArray512.init16 ("_.[_]" x)) j).[ii] = x.[16 * j + ii %/ 16].[ii %% 16].
+ move=> ii iib; rewrite get256E /pack32_t initiE 1:/# /= initiE 1:/# /= initiE 1:/# /=.
  by rewrite /(\bits8) initiE 1:/# /=; congr; [congr | ]; smt().
have hm : forall ii, 0 <= ii < 256 => mask12.[ii] = (W16.of_int 4095).[ii %% 16].
+ move=> ii iib; rewrite /VPBROADCAST_16u16 /=.
  by rewrite W16u16.pack16wE 1:// W16u16.Pack.get_of_list 1:/# (nth_map 0) 1:size_iota /#.
have bits : forall kk ii, 0 <= kk < 256 => 12 <= ii < 16 => !x.[kk].[ii].
+ move=> kk ii kkb iib; have := hb kk kkb; rewrite /bpos16 /to_sint /smod /= qE => Hn.
  have Hn1 : !32768 <= to_uint x.[kk] by smt(W16.to_uint_cmp pow2_16).
  move: Hn; rewrite Hn1 /= get_to_uint.
  have ? : 4096 <= 2 ^ ii; last by smt().
  have ? : 4096 = 2 ^ 12 by auto.
  smt(@StdOrder.IntOrder).
have bitsC : forall ii, 0 <= ii < 16 => (W16.of_int 4095).[ii] <=> 0 <= ii < 12.
+ move=> ii iib.
  have : all (fun i => (W16.of_int 4095).[i] <=> 0 <= i < 12) (iota_ 0 16);
    last by rewrite allP => H; move: (H ii _); smt(mem_iota).
  by rewrite -iotaredE /= !get_to_uint /=.
apply W256.wordP => ii iib; rewrite andwE hx // hm //.
case: (ii %% 16 < 12) => h; 1: by rewrite (bitsC (ii %% 16)) 1:/# /#.
by have := bits (16 * j + ii %/ 16) (ii %% 16) _ _; smt().
qed.

(* the masks are no-ops on the 12-bit coefficients that _poly_csubq returns *)
equiv poly_tobytes_aux :
  M._i_poly_tobytes ~ AuxToBytes.poly_tobytes :
  ={arg} /\ pos_bound256_cxq a{1} 0 256 2 ==> ={res}.
proof.
proc => /=.
seq 1 1 : (={rp, a} /\ pos_bound256_cxq a{1} 0 256 1).
+ exists* a{1}; elim* => a1.
  call (: ={rp} /\ rp{1} = a1 /\ pos_bound256_cxq rp{1} 0 256 2 ==>
          ={res} /\ pos_bound256_cxq res{1} 0 256 1); last by auto.
  conseq (: ={rp} ==> ={res}) (poly_csubq_avx2_corr_h a1) (: true ==> true) => //.
  by sim.
while (={rp, a, i} /\ 0 <= i{1} /\ pos_bound256_cxq a{1} 0 256 1); last by auto.
wp -1 -1; conseq (: _ ==> ={rp}); 1: by smt().
inline *; sim; auto => /> &1 i0 hb ib.
by rewrite !get256_mask12 // /#.
qed.

lemma poly_tobytes_corr (_aw : W16.t Array256.t) :
  phoare [M._i_poly_tobytes :
    pos_bound256_cxq a 0 256 2 /\ a = _aw ==>
    res.`1 = encode12 (map asint (lift_array256 (nttpack _aw)))] = 1%r.
proof.
bypr => &m; split => // -[hb ha].
have <- : Pr[AuxToBytes.poly_tobytes(rp{m}, _aw) @ &m :
  res.`1 = encode12 (map asint (lift_array256 (nttpack _aw)))] = 1%r.
+ by byphoare (auxtobytes_corr _aw) => //=; rewrite -ha.
by byequiv poly_tobytes_aux => //; rewrite ha.
qed.

(* -------------------------------------------------------------------- *)
(* the vector encodings, polynomial by polynomial                       *)
import Array_vecn Array_polyvec_bytes.

lemma polyvec_tobytes_corr (_aw : W16.t Array_vecn.t) :
  phoare [M.__i_polyvec_tobytes :
    pos_boundvecn_cxq a 0 vecn 2 /\ a = _aw ==>
    res = Array_polyvec_bytes.of_list W8.zero
      (ByteEncode 12 (Array_vecn.to_list
        (Array_vecn.map asint (lift_arrayvecn (nttpackv _aw)))))] = 1%r.
proof.
proc; sp.
while (0 <= i <= kvec /\
  (forall j, 0 <= j < i =>
     subarray384 r j = encode12 (map asint (lift_array256 (nttpack (subarray256 _aw j))))) /\
  (forall j, i <= j < kvec => subarray256 a j = subarray256 _aw j) /\
  pos_boundvecn_cxq _aw 0 vecn 2) (kvec - i).
+ move=> z; wp; ecall (poly_tobytes_corr (subarray256 a i)).
  auto=> &hr [#] i0 ik ih eq hb ilt vz.
  rewrite -/(subarray256 a{hr} i{hr}) /=; split.
  + by rewrite eq 1:/#; move/pos_boundvecnP: hb => /(_ i{hr} _) /#.
  move=> _ [r1 a1] /= h1; do split; 1,2,5,6: smt().
  + move=> j jb; rewrite subarray384_set 1,2:/#.
    case: (j = i{hr}) => [->|ne] /=; [by rewrite h1 eq 1:/# | by apply ih => /#].
  by move=> j jb; rewrite subarray256_set 1,2:/# ifF 1:/# eq /#.
auto=> &hr /> hb; split; 1: smt(gt0_k).
move=> a0 i r; split; 1: smt().
move=> ige i0 ik ih _ _; have {i0 ik ige} ?: i = kvec by smt(). subst i.
apply/polyvec_bytes_tP => j jb; rewrite ih // /encode12; apply Array384.tP => n nb.
rewrite Array384.get_of_list // subarray384E // Array_polyvec_bytes.get_of_list.
+ by rewrite polyvec_bytesE; smt().
rewrite eq_sym ByteEncode12_sub 1,2:/#; 1: by rewrite Array_vecn.size_to_list vecnE; smt().
by rewrite -to_list_subarray256 // subarray256_map // -lift_subarray256 // subarray256_nttpackv.
qed.

lemma polyvec_frombytes_corr (_aw : W8.t Array_polyvec_bytes.t) :
  phoare [M.__i_polyvec_frombytes : a = _aw ==>
    lift_arrayvecn res = nttunpackv (Array_vecn.map incoeff
      (Array_vecn.of_list 0 (ByteDecode 12 (Array_polyvec_bytes.to_list _aw)))) /\
    pos_boundvecn_cxq res 0 vecn 2] = 1%r.
proof.
proc; sp.
while (0 <= i <= kvec /\ a = _aw /\
  (forall j, 0 <= j < i =>
     lift_array256 (subarray256 r j) = nttunpack (map incoeff (decode12 (subarray384 _aw j))) /\
     pos_bound256_cxq (subarray256 r j) 0 256 2)) (kvec - i).
+ move=> z; wp; ecall (poly_frombytes_corr (subarray384 a i)).
  auto=> &hr [#] i0 ik -> ih ilt vz; rewrite -/(subarray384 _aw i{hr}) /=.
  move=> r1 [h1 h2]; do split; 1,2,4: smt().
  move=> j jb; rewrite subarray256_set 1,2:/#.
  by case: (j = i{hr}) => [->|ne] /=; [rewrite h1 h2 | apply ih => /#].
auto=> &hr />; split; 1: smt(gt0_k).
move=> i r; split; 1: smt().
move=> ige i0 ik ih; have {i0 ik ige} ?: i = kvec by smt(). subst i.
split; last by apply/pos_boundvecnP => j jb; case: (ih j jb).
apply/vecn_tP => j jb; rewrite -lift_subarray256 // subarray256_nttunpackv //.
case: (ih j jb) => -> _; congr.
apply Array256.tP => k kb; rewrite subarray256E // Array_vecn.get_of_list 1:vecn_slice //.
rewrite Array256.mapiE // /decode12 Array256.get_of_list // (nth_map 0).
+ rewrite /ByteDecode size_map size_chunk // size_BytesToBits Array_polyvec_bytes.size_to_list.
  by rewrite polyvec_bytesE; smt().
rewrite ByteDecode12_sub 1,2:/#; 1: by rewrite Array_polyvec_bytes.size_to_list polyvec_bytesE;
  smt().
by rewrite to_list_subarray384.
qed.

lemma polyvec_csubq_avx2_corr (_aw : W16.t Array_vecn.t) :
  phoare [M.__polyvec_csubq :
    r = _aw /\ pos_boundvecn_cxq r 0 vecn 2 ==>
    lift_arrayvecn res = lift_arrayvecn _aw /\
    pos_boundvecn_cxq res 0 vecn 1] = 1%r.
proof.
proc; sp.
while (0 <= i <= kvec /\
  (forall j, 0 <= j < i =>
     lift_array256 (subarray256 r j) = lift_array256 (subarray256 _aw j) /\
     pos_bound256_cxq (subarray256 r j) 0 256 1) /\
  (forall j, i <= j < kvec => subarray256 r j = subarray256 _aw j) /\
  pos_boundvecn_cxq _aw 0 vecn 2) (kvec - i).
+ move=> z; wp; ecall (poly_csubq_avx2_corr (subarray256 r i)).
  auto=> &hr [#] i0 ik ih eq hb ilt vz; rewrite -/(subarray256 r{hr} i{hr}) /=; split.
  + by rewrite eq 1:/#; move/pos_boundvecnP: hb => /(_ i{hr} _) /#.
  move=> _ r1 [h1 h2]; do split; 1,2,5,6: smt().
  + move=> j jb; rewrite subarray256_set 1,2:/#.
    case: (j = i{hr}) => [->|ne] /=; [by rewrite h1 h2 eq 1:/# | by apply ih => /#].
  by move=> j jb; rewrite subarray256_set 1,2:/# ifF 1:/# eq /#.
auto=> &hr /> hb; split; 1: smt(gt0_k).
move=> i r1; split; 1: smt().
move=> ige i0 ik ih _; have {i0 ik ige} ?: i = kvec by smt(). subst i.
split; last by apply/pos_boundvecnP => j jb; case: (ih j jb).
by apply/vecn_tP => j jb; rewrite -!lift_subarray256 //; case: (ih j jb).
qed.

end MLKEM_PolyVec_avx2_circuitT.
