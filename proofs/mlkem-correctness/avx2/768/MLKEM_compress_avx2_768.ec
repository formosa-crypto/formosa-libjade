(* The compression kernels of ML-KEM-768, by circuit: d_v = 4, d_u = 10 *)
require import AllCore List Int IntDiv CoreMap Real Number Ring StdOrder BitEncoding.

from Jasmin require import JModel.
from JazzEC require import Array400 Array384 Array256 Array160 Array128 Array64 Array32 Array16
  Array8 Array4 Array2.
from JazzEC require import WArray512 WArray128 WArray384 WArray32 WArray16.
from JazzEC require import Jkem_avx2.

require import AVX2_Ops W16extra.
require import Fq MLKEMFCLib Instances768.
require import Mlkem_bindings CircuitBindings.
require import XWord4 XWord12.
require import XArray8 XArray16 XArray32 XArray128 XArray256.
require import Circuit_semantics Circuit_sem_768.
from Spec require import Spec768 GFq Rq Serialization VecMat Sampling EncDecCorrectness Correctness.

import BitChunking BS2Int.
import Fq.
import MLKEM768.
import GFq Rq Serialization VecMat.
import Zq ZModP.
import MLKEM_PolyAVX.
import W12.
from JazzEC require import Array2304 Array1536 Array1408 Array1152 Array1088 Array1024 Array960
  Array768 Array400 Array384 Array256 Array160 Array128 Array64 Array32 Array16 Array8 Array4
  Array2.
from JazzEC require import WArray1536 WArray1410 WArray1152 WArray1088 WArray960 WArray512 WArray384
  WArray160 WArray128 WArray32 WArray16.
from JazzEC require import Jkem_avx2.
require import Mlkem_bindings CircuitBindings.
require import XWord4 XWord10 XWord12.
require import XArray16 XArray32 XArray256 XArray384 XArray768 XArray960 XArray1088 XArray1152.
import MLKEM_PolyAVXVec PolyVec PolyMat.

abbrev encode4 (a : ipoly) : W8.t Array128.t = Array128.of_list W8.zero (ByteEncode 4 (to_list a)).

lemma poly_decompress_dv4_ll : islossless Jkem_avx2.M._i_poly_decompress_dv4.
 proc; inline *;wp. cfold 9; unroll for ^while;auto.
qed.

lemma poly_decompress_dv4_corr_h (_a : W8.t Array128.t): 
    hoare [Jkem_avx2.M._i_poly_decompress_dv4  :
              arg.`2 = _a
              ==>
             lift_array256 res = decompress_poly 4 (decode4 _a) /\
             pos_bound256_cxq res 0 256 1 ].
proc; inline *.
proc change 4: { q <- BSWAS_16u16_256.sliceget x16p 0;}; 1: by auto; move => &1 &2 ?; rewrite
  BSWAS_16u16_256_slicegetE /#.
proc change 6: { shufbidx <- BSWAS_32u8_256.sliceget x32p 0;}; 1: by auto; move => &1 &2 ?; rewrite
  BSWAS_32u8_256_slicegetE /#.
proc change ^while.1 : { h <- zeroextu128 (if (0 <= (8*i)*8 <= 128*8-64) then
  BSWAS_128u8_64.sliceget a ((8*i)*8) else get64_direct (WArray128.init8 (fun (i_0 : int) =>
  a.[i_0])) (8*i)); };
1: by auto; move => &1 &2 [#] -> ->; case (0 <= (8*i{2})*8 <= 128*8-64); [ move => ?; rewrite
  BSWAS_128u8_64_slicegetE /# | by auto ].
proc change ^while.8 : { rp <- if (0 <= (32*i)*8 <= 256*16-256) then BSWAS_256u16_256.sliceset rp
  ((32*i)*8) f else Array256.init (fun (i1:int) => WArray512.get16 (WArray512.set256
  (WArray512.init16 (fun (i_0 : int) => rp.[i_0])) i f) i1) ; };
1: by auto; move => &1 &2 [#] -> -> ->; case (0 <= (32*i{2})*8 <= 256*16-256); [ move => ?; rewrite
  BSWAS_256u16_256_slicesetE // | by auto ].

cfold 9.
unroll for ^while.
cfold ^i<-.
wp -2.
conseq (: _ ==> rp = BSWA_256u16.init (fun i =>
     decompress4_circuit (W4.init (fun (j : int) => _a.[i %/ 2].[i %% 2 * 4 + j])))); last  by
       circuit.

      
(* We start with some boilerplate *)
move => &hr [#]/= <- rr /= ->.

split.
+ rewrite tP => i ib.
  rewrite /BSWA_256u16.init !mapiE 1,2:/# /= -get_to_list /= initiE 1:/# /=.
  by rewrite  -decompress4_circuit_sem 1:/# /=. 

rewrite /pos_bound256_cxq qE /= => k kb. 
rewrite /BSWA_256u16.init initiE 1:/# /=.
by apply decompress4_circuit_rng.
qed.

(********** END BDEP PROOF OF DECOMPRESS **************)

lemma poly_decompress_dv4_corr (_a : W8.t Array128.t): 
    phoare [Jkem_avx2.M._i_poly_decompress_dv4  :
              arg.`2 = _a
              ==>
             lift_array256 res = decompress_poly 4 (decode4 _a) /\
             pos_bound256_cxq res 0 256 1 ] = 1%r
  by conseq poly_decompress_dv4_ll (poly_decompress_dv4_corr_h _a).

lemma i_poly_compress_dv4_corr_ll : islossless Jkem_avx2.M._i_poly_compress_dv4.
proof.
proc; inline *.
cfold 13.
do 2!(unroll for ^while).
auto.
qed.

lemma i_poly_compress_dv4_corr_h _aw  : 
    hoare [Jkem_avx2.M._i_poly_compress_dv4  :
             pos_bound256_cxq a 0 256 2 /\
             a = _aw
              ==>
             res.`1 = encode4 (compress_poly 4 (lift_array256 _aw)) 
             ].
proof.
proc; inline *.
proc change 3: { qx16 <- BSWAS_16u16_256.sliceget jqx16 0;}; 1: by auto; move => &1 &2 ?; rewrite
  BSWAS_16u16_256_slicegetE /#.
proc change ^while.1: { r <- if (0 <= (32*i0)*8 <= 256*16-256) then BSWAS_256u16_256.sliceget rp0
  ((32*i0)*8) else get256_direct (WArray512.init16 (fun (i_0 : int) => rp0.[i_0])) (32*i0) ; };
1: by auto; move => &1 &2 [#] _ _ -> ->; case (0 <= (32*i0{2})*8 <= 256*16-256); [ move => ?;
  rewrite BSWAS_256u16_256_slicegetE /# | by auto ].
proc change ^while.9: { rp0 <- if (0 <= (32*i0)*8 <= 256*16-256) then BSWAS_256u16_256.sliceset rp0
  ((32*i0)*8) r else Array256.init (fun (i1:int) => WArray512.get16 (WArray512.set256
  (WArray512.init16 (fun (i_0 : int) => rp0.[i_0])) i0 r) i1) ; };
1: by auto; move => &1 &2 [#] _ _ -> -> ->; case (0 <= (32*i0{2})*8 <= 256*16-256); [ move => ?;
  rewrite BSWAS_256u16_256_slicesetE // | by auto ].
proc change 8: { v <- BSWAS_16u16_256.sliceget x16p 0;}; 1: by auto; move => &1 &2 ?; rewrite
  BSWAS_16u16_256_slicegetE /#.
proc change 12: { permidx <- BSWAS_8u32_256.sliceget pc_permidx_s_dv4 0;}; 1: by auto; move => &1 &2
  ?; rewrite BSWAS_8u32_256_slicegetE /#.
proc change ^while{2}.1: { f0 <- if (0 <= (32*(4*i))*8 <= 256*16-256) then BSWAS_256u16_256.sliceget
  a ((32*(4*i))*8) else get256_direct (WArray512.init16 (fun (i_0 : int) => a.[i_0])) (32*(4*i)) ;
  };
1: by auto; move => &1 &2 [#] -> ->; case (0 <= (32*(4*i{2}))*8 <= 256*16-256); [ move => ?; rewrite
  BSWAS_256u16_256_slicegetE /# | by auto ].
proc change ^while{2}.2: { f1 <- if (0 <= (32*(4*i+1))*8 <= 256*16-256) then
  BSWAS_256u16_256.sliceget a ((32*(4*i+1))*8) else get256_direct (WArray512.init16 (fun (i_0 : int)
  => a.[i_0])) (32*(4*i+1)) ; };
1: by auto; move => &1 &2 [#] -> ->; case (0 <= (32*(4*i{2}+1))*8 <= 256*16-256); [ move => ?;
  rewrite BSWAS_256u16_256_slicegetE /# | by auto ].
proc change ^while{2}.3: { f2 <- if (0 <= (32*(4*i+2))*8 <= 256*16-256) then
  BSWAS_256u16_256.sliceget a ((32*(4*i+2))*8) else get256_direct (WArray512.init16 (fun (i_0 : int)
  => a.[i_0])) (32*(4*i+2)) ; };
1: by auto; move => &1 &2 [#] -> ->; case (0 <= (32*(4*i{2}+2))*8 <= 256*16-256); [ move => ?;
  rewrite BSWAS_256u16_256_slicegetE /# | by auto ].
proc change ^while{2}.4: { f3 <- if (0 <= (32*(4*i+3))*8 <= 256*16-256) then
  BSWAS_256u16_256.sliceget a ((32*(4*i+3))*8) else get256_direct (WArray512.init16 (fun (i_0 : int)
  => a.[i_0])) (32*(4*i+3)) ; };
1: by auto; move => &1 &2 [#] -> ->; case (0 <= (32*(4*i{2}+3))*8 <= 256*16-256); [ move => ?;
  rewrite BSWAS_256u16_256_slicegetE /# | by auto ].
proc change ^while{2}.23 : { rp <- if (0 <= 32*i*8 <= 8*128-256) then BSWAS_128u8_256.sliceset rp
  (32*i*8) f0 else Array128.init (WArray128.get8 (WArray128.set256_direct (WArray128.init8 (fun (i_0
  : int) => rp.[i_0])) (32*i) f0)) ; };
1: by auto; move => &1 &2 [#] -> -> ->; case (0 <= 32*i{2}*8 <= 8*128-256); [ move => ?; rewrite
  BSWAS_128u8_256_slicesetE // | by auto ].

cfold 13.
do 2!(unroll for ^while).
cfold ^i0<-.
wp -3.

conseq (: a = _aw /\
   Array256.all (fun bv => W16.zero \sle bv /\ bv \slt (of_int (2 * 3329))) a
   ==> rp = BSWA_128u8.init (fun i =>
     W8.init (fun j =>
       (compress4_circuit _aw.[j %/ 4 + i * 2]).[j %% 4]))); last by circuit.
        
       
(* BDEP pre conseq *)
+ move => &hr />; rewrite /pos_bound256_cxq qE /= /(\sle) /(\slt) allP /=  => Hb i ib /=.
  rewrite /(to_sint W16.zero) /= /(W16.smod 0) /=.
  rewrite /(to_sint (W16.of_int 6658)) /= /(W16.smod 6658) /= /#.
  
(* BDEP post conseq *)

(* We start with some boilerplate *)
move => &hr [#]/= H0 <- rr ->; rewrite /= /BSWA_128u8.init tP => i ib.
rewrite wordP => k kb; rewrite !initiE 1..3:/# /=.
rewrite encode_compress_bits //=.
by apply compress4_circuit_sem.
qed.
(********** END BDEP PROOF OF COMPRESS **************)

lemma i_poly_compress_dv4_corr _aw  : 
    phoare [Jkem_avx2.M._i_poly_compress_dv4  :
             pos_bound256_cxq a 0 256 2 /\
             a = _aw
              ==>
             res.`1 = encode4 (compress_poly 4 (lift_array256 _aw)) 
             ] = 1%r
 by conseq i_poly_compress_dv4_corr_ll (i_poly_compress_dv4_corr_h _aw).

abbrev encode10_vec (a : ipolyvec) : W8.t Array960.t = Array960.of_list W8.zero (ByteEncode 10
  (to_list a)).

lemma polyvec_decompress_du10_ll :
   islossless Jkem_avx2.M.__i_polyvec_decompress_du10.
by proc;inline *;unroll for ^while; do 3!(cfold ^inc<-; unroll for ^while);auto.
qed.
(********** BEGIN BDEP PROOF OF DECOMPRESS **************)

lemma polyvec_decompress_du10_corr_h (_aw : W8.t Array960.t):
    hoare[ Jkem_avx2.M.__i_polyvec_decompress_du10 :
             Array960.init (fun i => rp.[i]) = _aw ==> pos_boundvecn_cxq res 0 768 1 /\ lift_polyvec
               res = decompress_polyvec 10 (decode10_vec _aw)].
proc; inline *.
proc change 2: { shufbidx <- BSWAS_32u8_256.sliceget pvd_shufbdidx_s_du10 0;}; 1: by auto; move =>
  &1 &2 ?; rewrite BSWAS_32u8_256_slicegetE /#.
proc change ^while.^while.1 : {f <- if (0 <= (320*k+20*i)*8 <= 1088*8-256) then
  BSWAS_1088u8_256.sliceget rp ((320*k + 20*i)*8) else get256_direct (WArray1088.init8 (fun (i_0 :
  int) => rp.[i_0])) (320*k+20*i) ;};
1: by auto; move => &1 &2 [#] -> -> ->; case (0 <= (320*k{2}+20*i{2})*8 <= 1088*8-256); [ move => ?;
  rewrite BSWAS_1088u8_256_slicegetE /# | by auto ].
proc change ^while.^while.8 : {r <- if (0 <= (32*(16*k+i))*8 <= 16*768-256) then
  BSWAS_768u16_256.sliceset r ((32*(16*k+i))*8) f else Array768.init (fun (i0:int) =>
  WArray1536.get16 (WArray1536.set256 (WArray1536.init16 (fun (i_0 : int) => r.[i_0])) (16*k+i) f)
  i0) ;};
1: by auto; move => &1 &2 [#] -> -> -> ->; case (0 <= (32*(16*k{2}+i{2}))*8 <= 16*768-256); [ move
  => ?; rewrite BSWAS_768u16_256_slicesetE // | by auto ].
unroll for ^while.
cfold ^inc<-.
do 3!(unroll for ^while).
cfold ^i<-.
wp -3.

conseq (: rp = BSWA_1088u8.init (fun i => if i < 960 then _aw.[i] else rp.[i])
        ==>
   r = BSWA_768u16.init (fun i =>
     decompress10_circuit (W10.init (fun (j : int) => _aw.[(i*10 + j) %/ 8].[(i*10 + j) %%
       8]))));last  circuit.
     
(* We start with some boilerplate *)
move => &hr /=;rewrite !tP  => H i ib.
by rewrite initE ib /=; case (i < 960) => // ?; rewrite -H 1:/# initiE 1:/#.

move => &hr <- rr ->; split; last first.
+ rewrite KVec.tP => k kb.
  rewrite tP => i ib.
  rewrite /lift_polyvec /BSWA_768u16.init KVec.initiE 1:/# /= !mapiE 1:/# /= -get_to_list /= initiE
    1:/# /= initiE 1:/# /=.
  rewrite initiE; 1: by smt(kvec_val).
  simplify.
  rewrite mapiE 1:/#.
  rewrite /subarray256 initiE 1:/#.
  simplify.
  rewrite decompress10_circuit_sem; 1: by smt(kvec_val).
  done.

  
rewrite /pos_boundvecn_cxq qE /= => k kb. 
rewrite /BSWA_768u16.init initiE 1:/# /=.
by apply decompress10_circuit_rng.
qed.

lemma polyvec_decompress_du10_corr (_aw : W8.t Array960.t):
    phoare[ Jkem_avx2.M.__i_polyvec_decompress_du10 :
             Array960.init (fun i => rp.[i]) = _aw ==> pos_boundvecn_cxq res 0 768 1 /\ lift_polyvec
               res = decompress_polyvec 10 (decode10_vec _aw)] = 1%r
 by conseq polyvec_decompress_du10_ll (polyvec_decompress_du10_corr_h _aw).

(********** BEGIN BDEP PROOF OF COMPRESS  **************)

module AuxCompress10 = {

proc __i_polyvec_compress(rp : W8.t Array960.t, a : W16.t Array768.t) : W8.t Array960.t = {
    var inc : int;
    var x16p : W16.t Array16.t;
    var v : W256.t;
    var v8 : W256.t;
    var off : W256.t;
    var shift1 : W256.t;
    var mask : W256.t;
    var shift2 : W256.t;
    var sllvdidx : W256.t;
    var shufbidx : W256.t;
    var i : int;
    var f0 : W256.t;
    var f1 : W256.t;
    var f2 : W256.t;
    var t0 : W128.t;
    var t1 : W128.t;
    x16p <- witness;
    a <@ M.__polyvec_csubq(a);
    x16p <- jvx16;
    v <- get256 (WArray32.init16 (fun (i_0 : int) => x16p.[i_0])) 0;
    v8 <- VPSLL_16u16 v (W128.of_int 3);
    off <- VPBROADCAST_16u16 pvc_off_s_du10;
    shift1 <- VPBROADCAST_16u16 pvc_shift1_s_du10;
    mask <- VPBROADCAST_16u16 pvc_mask_s_du10;
    shift2 <- VPBROADCAST_4u64 pvc_shift2_s_du10;
    sllvdidx <- VPBROADCAST_4u64 pvc_sllvdidx_s_du10;
    shufbidx <- get256 (WArray32.init8 (fun (i_0 : int) => pvc_shufbidx_s_du10.[i_0])) 0;
    inc <- 3 * 256 %/ 16;
    i <- 0;
    while (i < inc){
      f0 <- get256 (WArray1536.init16 (fun (i_0 : int) => a.[i_0])) i;
      f1 <- VPMULL_16u16 f0 v8;
      f2 <- VPADD_16u16 f0 off;
      f0 <- VPSLL_16u16 f0 (W128.of_int 3);
      f0 <- VPMULH_16u16 f0 v;
      f2 <- VPSUB_16u16 f1 f2;
      f1 <- invw f1 `&` f2;
      f1 <- VPSRL_16u16 f1 (W128.of_int 15);
      f0 <- VPSUB_16u16 f0 f1;
      f0 <- VPMULHRS_16u16 f0 shift1;
      f0 <- f0 `&` mask;
      f0 <- VPMADDWD_alt f0 shift2;
      f0 <- VPSLLV_8u32 f0 sllvdidx;
      f0 <- VPSRL_4u64 f0 (W128.of_int 12);
      f0 <- VPSHUFB_256 f0 shufbidx;
      t0 <- truncateu128 f0;
      t1 <- VEXTRACTI128 f0 W8.one;
      t0 <- VPBLENDW_128 t0 t1 (W8.of_int 224);
      rp <-
        Array960.init
          (WArray960.get8
             (WArray960.set128_direct (WArray960.init8 (fun (i_0 : int) => rp.[i_0])) (20 * i) t0));
      rp <-
        Array960.init
          (WArray960.get8
             (WArray960.set32_direct (WArray960.init8 (fun (i_0 : int) => rp.[i_0])) (
                20 * i + 16) (VPEXTR_32 t1 W8.zero)));
      i <- i + 1;
    }
    
    return rp;
  }
}.

lemma auxcompress10_ll : islossless AuxCompress10.__i_polyvec_compress.
proc. cfold 12. unroll for ^while; wp => /=. 
inline *;unroll for ^while; do 3!(unroll for ^while);auto.
qed.

lemma auxcompress10_corr_h (_aw : W16.t Array768.t):
    hoare[ AuxCompress10.__i_polyvec_compress  :
             a = _aw /\
             pos_boundvecn_cxq a 0 768 2 ==> 
      res = encode10_vec (compress_polyvec 10 (lift_polyvec _aw))].
proof.
proc; inline *.
proc change ^while.1: { rp0 <- BSWA_256u16.init (fun i => r.[256*i0+i]);};1: by auto.
proc change ^while.2: { qx16 <- BSWAS_16u16_256.sliceget jqx16 0;}; 1: by auto; move => &1 &2 ?;
  rewrite BSWAS_16u16_256_slicegetE /#.
proc change ^while.^while.1: {r0 <- if (0 <= (32*i1)*8 <= 256*16-256) then BSWAS_256u16_256.sliceget
  rp0 ((32*i1)*8) else get256_direct (WArray512.init16 (fun (i_0 : int) => rp0.[i_0])) (32*i1) ;};
1: by auto; move => &1 &2 [#] _ _ -> ->; case (0 <= (32*i1{2})*8 <= 256*16-256); [ move => ?;
  rewrite BSWAS_256u16_256_slicegetE /# | by auto ].
proc change ^while.^while.9: { rp0 <- if (0 <= (32*i1)*8 <= 256*16-256) then
  BSWAS_256u16_256.sliceset rp0 ((32*i1)*8) r0 else Array256.init (fun (i2:int) => WArray512.get16
  (WArray512.set256 (WArray512.init16 (fun (i_0 : int) => rp0.[i_0])) i1 r0) i2) ;};
1: by auto; move => &1 &2 [#] _ _ -> -> ->; case (0 <= (32*i1{2})*8 <= 256*16-256); [ move => ?;
  rewrite BSWAS_256u16_256_slicesetE // | by auto ].
proc change ^while.6: { r <- BSWA_768u16.init (fun (i_0 : int) => if 256 * i0 <= i_0 < 256 * i0 +
  256 then aux.[i_0 - 256 * i0] else r.[i_0]);};1: by auto.
proc change 7: { v <- BSWAS_16u16_256.sliceget x16p 0;}; 1: by auto; move => &1 &2 ?; rewrite
  BSWAS_16u16_256_slicegetE /#.
proc change ^while{2}.1: {f0 <- if (0 <= (32*i)*8 <= 768*16-256) then BSWAS_768u16_256.sliceget a
  ((32*i)*8) else get256_direct (WArray1536.init16 (fun (i_0 : int) => a.[i_0])) (32*i) ;};
1: by auto; move => &1 &2 [#] -> ->; case (0 <= (32*i{2})*8 <= 768*16-256); [ move => ?; rewrite
  BSWAS_768u16_256_slicegetE /# | by auto ].
proc change 14: { shufbidx <- BSWAS_32u8_256.sliceget pvc_shufbidx_s_du10 0;}; 1: by auto; move =>
  &1 &2 ?; rewrite BSWAS_32u8_256_slicegetE /#.
proc change ^while{2}.19 : { rp <- if (0 <= 20*i*8 <= 8*960-128) then BSWAS_960u8_128.sliceset rp
  (20*i*8) t0 else Array960.init (WArray960.get8 (WArray960.set128_direct (WArray960.init8 (fun (i_0
  : int) => rp.[i_0])) (20*i) t0)) ;};
1: by auto; move => &1 &2 [#] -> -> ->; case (0 <= 20*i{2}*8 <= 8*960-128); [ move => ?; rewrite
  BSWAS_960u8_128_slicesetE // | by auto ].
proc change ^while{2}.20 : { rp <- if (0 <= (20*i+16)*8 <= 8*960-32) then BSWAS_960u8_32.sliceset rp
  ((20*i+16)*8) (truncateu32 t1) else Array960.init (WArray960.get8 (WArray960.set32_direct
  (WArray960.init8 (fun (i_0 : int) => rp.[i_0])) (20*i+16) (VPEXTR_32 t1 W8.zero))) ;};
1: by auto; move => &1 &2 [#] -> -> ->; case (0 <= (20*i{2}+16)*8 <= 8*960-32); [ move => ?; suff h:
  truncateu32 t1{2} = VPEXTR_32 t1{2} W8.zero; [ by rewrite h BSWAS_960u8_32_slicesetE /# | by
  rewrite /VPEXTR_32 /truncateu32 to_uint_eq /= bits32_div // ] | by auto ].
unroll for ^while.
do 3!(unroll for ^while).
cfold ^inc<-.
unroll for ^while.
cfold ^i0<-. 
cfold ^i1<-. 
wp -4.

conseq (: a = _aw /\
   Array768.all (fun bv => W16.zero \sle bv /\ bv \slt (of_int (2 * 3329))) a
   ==> rp = BSWA_960u8.init (fun i =>
     W8.init (fun j =>
       (compress10_circuit _aw.[(i*8+j) %/ 10]).[(i*8+j) %% 10]))); last by circuit.

      
(* BDEP pre conseq *)
+ move => &hr />; rewrite /pos_boundvecn_cxq qE /= /(\sle) /(\slt) allP /=  => Hb i ib /=.
  rewrite /(to_sint W16.zero) /= /(W16.smod 0) /=.
  rewrite /(to_sint (W16.of_int 6658)) /= /(W16.smod 6658) /= /#.
  
(* BDEP post conseq *)

(* We start with some boilerplate *)
move => &hr [#]/= -> H0 rr; rewrite /= /BSWA_960u8.init !tP => H i ib.
rewrite H // initiE 1:/# /=.
rewrite wordP => k kb; rewrite !initiE /= 1,2:/#.
rewrite encode_vec_compress_bits //=.
by apply compress10_circuit_sem.
qed.

(********** END BDEP PROOF OF COMPRESS **************)

lemma auxcompress10_corr (_aw : W16.t Array768.t):
    phoare[ AuxCompress10.__i_polyvec_compress  :
             a = _aw /\
             pos_boundvecn_cxq a 0 768 2 ==> 
      res  = encode10_vec (compress_polyvec 10 (lift_polyvec _aw))] = 1%r 
  by conseq auxcompress10_ll (auxcompress10_corr_h _aw).

lemma polyvec_compress_du10_ll : islossless Jkem_avx2.M.__i_polyvec_compress_du10.
proc. cfold 12. unroll for ^while; wp => /=. 
inline *;unroll for ^while; do 3!(unroll for ^while);auto.
qed.

lemma polyvec_compress_du10_corr (_aw : W16.t Array768.t):
    phoare[ Jkem_avx2.M.__i_polyvec_compress_du10  :
             a = _aw /\
             pos_boundvecn_cxq a 0 768 2 ==> 
      res  = encode10_vec (compress_polyvec 10 (lift_polyvec _aw))] = 1%r.
bypr => &m; split => //; move=> [->?].
have <- : Pr[ AuxCompress10.__i_polyvec_compress(rp{m}, _aw) @ &m :
   res = encode10_vec (compress_polyvec 10 (lift_polyvec _aw))] = 1%r
   by byphoare (auxcompress10_corr _aw)  =>/=;1:smt().
byequiv (: ={arg} /\ a{1} = _aw /\
             pos_boundvecn_cxq a{1} 0 768 2 ==> ={res}) => //.
proc.
seq 2 2 : (={rp,a} /\ pos_boundvecn_cxq a{1} 0 768 1).
+ ecall {1} (polyvec_csubq_avx2_corr a{1}). 
  ecall {2} (polyvec_csubq_avx2_corr a{2}). 
  auto => />; rewrite /pos_boundvecn_cxq /lift_arrayvecn /= qE /= => ? _ rr1.
  rewrite !tP;move =>  Hrr11 Hrr12 rr2.
  rewrite !tP;move =>  Hrr21 Hrr22.
  move => i ib. 
  have := Hrr11 i ib; rewrite !mapiE 1,2:/# /=. 
  have := Hrr12 i ib.  
  have := Hrr21 i ib; rewrite !mapiE 1,2:/# /=. 
  have := Hrr22 i ib.  
  rewrite /to_sint /smod /=. 
  move => Hrr11i Hrr12i Hrr21i Hrr22i.
  have Hn1 : !(32768 <= to_uint rr2.[i]) by smt(W16.to_uint_cmp pow2_16).
  have Hn2 : !(32768 <= to_uint rr1.[i]) by smt(W16.to_uint_cmp pow2_16).
  have Hn3 : !(32768 <= to_uint _aw.[i]) by smt(W16.to_uint_cmp pow2_16).
  move : Hrr11i Hrr12i Hrr21i Hrr22i; rewrite Hn1 Hn2 Hn3 /=.
  move => Hrr11i Hrr12i Hrr21i Hrr22i.
  move : Hrr12i; rewrite -Hrr22i -eq_incoeff.  
  by rewrite !modz_small ?qE /= 1,2:/# to_uint_eq /#.

cfold {1} ^inc<-. 
cfold {2} ^inc<-. 
sp 9 9.
wp;while (#pre /\ ={i} /\ 0 <= i{1} <=64); last by auto.
wp -1 -1; conseq (: _ ==> ={rp}); 1: by auto => /#.
sim;conseq />.
seq 10 10 : (#pre /\ ={f0}); 1: by conseq />;sim.
auto => /> &1;rewrite vpmaddwd_alt_corr; last by rewrite /VPMADDWD_alt /=.
move => i ib /=; rewrite /VPBROADCAST_16u16 /=.
rewrite Montgomery16.bits16_W16u16 ib /= get_of_list 1:/# /= (nth_map witness) /=;1:smt(size_iota).
have -> : 1023 = 2^10 -1 by auto.
rewrite and_mod 1:/# of_sintK /= /= /smod /=  /smod /#. 
qed.

