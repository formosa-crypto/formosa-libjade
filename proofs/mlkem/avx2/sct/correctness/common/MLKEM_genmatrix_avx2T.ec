(* -------------------------------------------------------------------- *)
(* The matrix sampling of the model, at abstract parameters: the        *)
(* entries four at a time, the last one alone when kvec is odd, and the *)
(* unpacking of every entry, against the specification's sampleA.       *)
(* -------------------------------------------------------------------- *)
require import AllCore IntDiv List.
from Jasmin require import JModel_x86.
from JazzEC require import WArray512 WArray256 WArray128 WArray8 WArray2 WArray32.
from JazzEC require import Array2 Array8 Array16 Array25 Array32 Array33 Array128 Array136.
from JazzEC require import Array1024 Array2144 Array536 Array256.
require import MLKEMFCLib AVX2_Ops W16extra.
require import EclibExtra JWordList.
from Keccak require import Keccak1600_avx2x4.
from Spec require import GFq Rq Sampling Serialization Symmetric Correctness.
require import JkemConstants.
require import PreludeT.
require BaseT Fq_avx2T MLKEM_ntt_levelsT MLKEM_ntt_avx2T MLKEM_invntt_levelsT.
require MLKEM_invntt_avx2T MLKEM_basemul_avx2T NTT_avx2_polyT MLKEM_Poly_avx2T NTT_avx2T.
require MLKEM_keccak_avx2T Mlkem_filters_bridgeT MLKEM_sampler_avx2T.

abstract theory MLKEM_genmatrix_avx2T.

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
clone import NTT_avx2T.NTT_avx2T as NTT_avx2 with
  theory B <- B, theory PR <- PR, theory MLKEM_ntt_levels <- MLKEM_ntt_levels,
  theory MLKEM_ntt_avx2 <- MLKEM_ntt_avx2, theory MLKEM_invntt_levels <- MLKEM_invntt_levels,
  theory MLKEM_invntt_avx2 <- MLKEM_invntt_avx2, theory MLKEM_basemul_avx2 <- MLKEM_basemul_avx2,
  theory NTT_avx2_poly <- NTT_avx2_poly.
clone import MLKEM_keccak_avx2T.MLKEM_keccak_avx2T as MLKEM_keccak_avx2 with theory B <- B.
clone import Mlkem_filters_bridgeT.Mlkem_filters_bridgeT as Mlkem_filters_bridge with
  theory B <- B.
clone import MLKEM_sampler_avx2T.MLKEM_sampler_avx2T as MLKEM_sampler_avx2 with
  theory B <- B, theory MLKEM_keccak_avx2 <- MLKEM_keccak_avx2,
  theory Mlkem_filters_bridge <- Mlkem_filters_bridge.

import GFq Rq Sampling Serialization Symmetric Fq Correctness.
import PolyVec PolyMat KMatrix.Matrix.
import MLKEM_PolyAVXVec.
import Array_vecn Array_matn Array_idx_table.

(* -------------------------------------------------------------------- *)
(* the unpacking of one entry                                           *)


lemma prod (x:'a*'b) :
 x = (x.`1,x.`2). smt(). qed.

lemma bits8_W32u8 ws i :
  W32u8.pack32_t ws \bits8 i = if 0 <= i < 32 then ws.[i] else W8.zero.
apply W8.wordP => j hj.
case (0 <= i < 32) => hi. rewrite  W32u8.pack32bE //. rewrite get_out //. qed.

lemma ianda a b c : a => (b => c) => ((a => b) => c). smt(). qed.

lemma if_eq (a:bool) (b c d:'a) : (a => (b=d)) => (!a => (c=d)) => (if a then b else c) = d.
move => T F. case a => />. qed.


lemma rng_iotared i n :
  (0 <= i < n) = (i \in iotared 0 n).
rewrite iotaredE mem_iota //= andaE //. qed.

op pack16x8 (x:('a Array16.t)*('a Array16.t)*('a Array16.t)*('a Array16.t)*('a Array16.t)*('a Array16.t)*('a Array16.t)*('a Array16.t)) : 'a Array128.t = Array128.init (fun i =>
 if 0 <= i < 16 then x.`1.[i%%16]
 else if 16 <= i < 32 then x.`2.[i%%16]
 else if 32 <= i < 48 then x.`3.[i%%16]
 else if 48 <= i < 64 then x.`4.[i%%16]
 else if 64 <= i < 80 then x.`5.[i%%16]
 else if 80 <= i < 96 then x.`6.[i%%16]
 else if 96 <= i < 112 then x.`7.[i%%16]
 else x.`8.[i%%16]) axiomatized by pack16x8E.

op unpack16x8 (x:'a Array128.t) : ('a Array16.t)*('a Array16.t)*('a Array16.t)*('a Array16.t)*('a Array16.t)*('a Array16.t)*('a Array16.t)*('a Array16.t) =
 (Array16.init (fun i => x.[i+16*0])
 ,Array16.init (fun i => x.[i+16*1])
 ,Array16.init (fun i => x.[i+16*2])
 ,Array16.init (fun i => x.[i+16*3])
 ,Array16.init (fun i => x.[i+16*4])
 ,Array16.init (fun i => x.[i+16*5])
 ,Array16.init (fun i => x.[i+16*6])
 ,Array16.init (fun i => x.[i+16*7])) axiomatized by unpack16x8E.

lemma unpack16x8K (w:'a Array128.t) :
  pack16x8 (unpack16x8 w) = w.
rewrite pack16x8E unpack16x8E tP => i Hi. rewrite !initiE //=. rewrite !initiE //= 1..8:/#.
smt(). qed.

lemma pack16x8K (w:('a Array16.t)*('a Array16.t)*('a Array16.t)*('a Array16.t)*('a Array16.t)*('a Array16.t)*('a Array16.t)*('a Array16.t)) :
  unpack16x8 (pack16x8 w) = w.
rewrite pack16x8E unpack16x8E => />. rewrite (_:w=(w.`1,w.`2,w.`3,w.`4,w.`5,w.`6,w.`7,w.`8)) => />. smt(). progress.
rewrite tP => i Hi. rewrite !initiE //= /#. 
rewrite tP => i Hi; rewrite !initiE //= !initiE //= /#.
rewrite tP => i Hi. rewrite !initiE //= !initiE //= /#. 
rewrite tP => i Hi. rewrite !initiE //= !initiE //= /#. 
rewrite tP => i Hi. rewrite !initiE //= !initiE //= /#. 
rewrite tP => i Hi. rewrite !initiE //= !initiE //= /#.
rewrite tP => i Hi. rewrite !initiE //= !initiE //= /#.
rewrite tP => i Hi. rewrite !initiE //= !initiE //= /#.
qed.

op pack128x2 (x:'a Array128.t * 'a Array128.t) : 'a Array256.t = Array256.init (fun i =>
  if 0 <= i < 128 then x.`1.[i%%128]
  else x.`2.[i%%128]) axiomatized by pack128x2E.

op unpack128x2 (x:'a Array256.t) : ('a Array128.t * 'a Array128.t) =
 (Array128.init (fun i => x.[i+128*0])
 ,Array128.init (fun i => x.[i+128*1])) axiomatized by unpack128x2E.

lemma unpack128x2K (w:'a Array256.t) :
  pack128x2 (unpack128x2 w) = w.
rewrite pack128x2E unpack128x2E tP => i Hi. rewrite !initiE //=. rewrite !initiE //= 1..2:/#.
smt(). qed.

lemma pack128x2K (w:('a Array128.t)*('a Array128.t)) :
  unpack128x2 (pack128x2 w) = w.
rewrite pack128x2E unpack128x2E => />. rewrite (_:w=(w.`1,w.`2)) => />. smt(). progress.
rewrite tP => i Hi. rewrite !initiE //= /#. 
rewrite tP => i Hi. rewrite !initiE //= !initiE //= /#. 
qed.

abbrev is16u16x8 (x:t16u16*t16u16*t16u16*t16u16*t16u16*t16u16*t16u16*t16u16) (y:vt16u16*vt16u16*vt16u16*vt16u16*vt16u16*vt16u16*vt16u16*vt16u16) = is16u16 x.`1 y.`1 /\ is16u16 x.`2 y.`2 /\ is16u16 x.`3 y.`3 /\ is16u16 x.`4 y.`4 /\ is16u16 x.`5 y.`5 /\ is16u16 x.`6 y.`6 /\ is16u16 x.`7 y.`7 /\ is16u16 x.`8 y.`8.

abbrev nttunpack128x16 ['a] (x:('a Array16.t)*('a Array16.t)*('a Array16.t)*('a Array16.t)*('a Array16.t)*('a Array16.t)*('a Array16.t)*('a Array16.t)) = unpack16x8 (nttunpack128 (pack16x8 x)).

lemma rng_perm_nttunpack128 i :
  0 <= i < 128 => 
  0 <= nth witness perm_nttunpack128 i < 128.
move => *. rewrite perm_nttunpack128E => />. smt(). qed.

lemma nttunpack128x2 (w:'a Array256.t) :
  unpack128x2 (nttunpack w) = (nttunpack128 (unpack128x2 w).`1,nttunpack128 (unpack128x2 w).`2).
rewrite !unpack128x2E /nttunpack128 //=. split.
+ rewrite tP => i Hi. rewrite !initiE //=. rewrite !initiE //=. rewrite rng_perm_nttunpack128 //.
rewrite /nttunpack /perm_nttunpack128 initiE //= 1:/#.
move:Hi. rewrite rng_iotared => />. do 128!(try (move => Hi; case Hi => />)). 
+ rewrite tP => i Hi. rewrite !initiE //=. rewrite !initiE //=. rewrite rng_perm_nttunpack128 //.
rewrite /nttunpack /perm_nttunpack128 initiE //= 1:/#.
move:Hi. rewrite rng_iotared => />. do 128!(try (move => Hi; case Hi => />)). 
qed.

lemma inj_unpack16x8 (x y : 'a Array128.t) :
  (unpack16x8 x = unpack16x8 y) => (x = y).
rewrite -(unpack16x8K x) -(unpack16x8K y). rewrite !pack16x8K => ->. rewrite unpack16x8K //. qed.

lemma inj_unpack128x2 (x y : 'a Array256.t) :
  (unpack128x2 x = unpack128x2 y) => (x = y).
rewrite -(unpack128x2K x) -(unpack128x2K y). rewrite !pack128x2K => ->. rewrite unpack128x2K //. qed.

lemma nttunpack128_corr_h a :
 hoare[ M.__nttunpack128 :
   is16u16x8 a arg ==> is16u16x8 (nttunpack128x16 a) res].
proc.
(*shuffle8*)
pose r0_8 := (shuf8 a.`1 a.`5).`1.
pose r1_8 := (shuf8 a.`2 a.`6).`1.
pose r2_8 := (shuf8 a.`3 a.`7).`1.
pose r3_8 := (shuf8 a.`4 a.`8).`1.
pose r4_8 := (shuf8 a.`1 a.`5).`2.
pose r5_8 := (shuf8 a.`2 a.`6).`2.
pose r6_8 := (shuf8 a.`3 a.`7).`2.
pose r7_8 := (shuf8 a.`4 a.`8).`2.
seq 1 : (is16u16x8 (r0_8,a.`2,a.`3,a.`4,r4_8,a.`6,a.`7,a.`8) (r0,r1,r2,r3,r4,r5,r6,r7)). auto => />. call (avx2_shuffle8_corr_h a.`1 a.`5) => />. auto => />. 
seq 1 : (is16u16x8 (r0_8,r1_8,a.`3,a.`4,r4_8,r5_8,a.`7,a.`8) (r0,r1,r2,r3,r4,r5,r6,r7)). auto => />. call (avx2_shuffle8_corr_h a.`2 a.`6) => />. auto => />.
seq 1 : (is16u16x8 (r0_8,r1_8,r2_8,a.`4,r4_8,r5_8,r6_8,a.`8) (r0,r1,r2,r3,r4,r5,r6,r7)). auto => />. call (avx2_shuffle8_corr_h a.`3 a.`7) => />. auto => />.
seq 1 : (is16u16x8 (r0_8,r1_8,r2_8,r3_8,r4_8,r5_8,r6_8,r7_8) (r0,r1,r2,r3,r4,r5,r6,r7)). auto => />. call (avx2_shuffle8_corr_h a.`4 a.`8) => />. auto => />.
(*shuffle4*)
pose r0_4 := (shuf4 r0_8 r2_8).`1.
pose r1_4 := (shuf4 r1_8 r3_8).`1.
pose r2_4 := (shuf4 r0_8 r2_8).`2.
pose r3_4 := (shuf4 r1_8 r3_8).`2.
pose r4_4 := (shuf4 r4_8 r6_8).`1.
pose r5_4 := (shuf4 r5_8 r7_8).`1.
pose r6_4 := (shuf4 r4_8 r6_8).`2.
pose r7_4 := (shuf4 r5_8 r7_8).`2.
seq 1 : (is16u16x8 (r0_4,r1_8,r2_4,r3_8,r4_8,r5_8,r6_8,r7_8) (r0,r1,r2,r3,r4,r5,r6,r7)). auto => />. call (avx2_shuffle4_corr_h r0_8 r2_8) => />. auto => />.
seq 1 : (is16u16x8 (r0_4,r1_8,r2_4,r3_8,r4_4,r5_8,r6_4,r7_8) (r0,r1,r2,r3,r4,r5,r6,r7)). auto => />. call (avx2_shuffle4_corr_h r4_8 r6_8) => />. auto => />.
seq 1 : (is16u16x8 (r0_4,r1_4,r2_4,r3_4,r4_4,r5_8,r6_4,r7_8) (r0,r1,r2,r3,r4,r5,r6,r7)). auto => />. call (avx2_shuffle4_corr_h r1_8 r3_8) => />. auto => />.
seq 1 : (is16u16x8 (r0_4,r1_4,r2_4,r3_4,r4_4,r5_4,r6_4,r7_4) (r0,r1,r2,r3,r4,r5,r6,r7)). auto => />. call (avx2_shuffle4_corr_h r5_8 r7_8) => />. auto => />.
(*shuffle2*)
pose r0_2 := (shuf2 r0_4 r1_4).`1.
pose r1_2 := (shuf2 r0_4 r1_4).`2.
pose r2_2 := (shuf2 r2_4 r3_4).`1.
pose r3_2 := (shuf2 r2_4 r3_4).`2.
pose r4_2 := (shuf2 r4_4 r5_4).`1.
pose r5_2 := (shuf2 r4_4 r5_4).`2.
pose r6_2 := (shuf2 r6_4 r7_4).`1.
pose r7_2 := (shuf2 r6_4 r7_4).`2.
seq 1 : (is16u16x8 (r0_2,r1_2,r2_4,r3_4,r4_4,r5_4,r6_4,r7_4) (r0,r1,r2,r3,r4,r5,r6,r7)). auto => />. call (avx2_shuffle2_corr_h r0_4 r1_4) => />. auto => />.
seq 1 : (is16u16x8 (r0_2,r1_2,r2_2,r3_2,r4_4,r5_4,r6_4,r7_4) (r0,r1,r2,r3,r4,r5,r6,r7)). auto => />. call (avx2_shuffle2_corr_h r2_4 r3_4) => />. auto => />.
seq 1 : (is16u16x8 (r0_2,r1_2,r2_2,r3_2,r4_2,r5_2,r6_4,r7_4) (r0,r1,r2,r3,r4,r5,r6,r7)). auto => />. call (avx2_shuffle2_corr_h r4_4 r5_4) => />. auto => />.
seq 1 : (is16u16x8 (r0_2,r1_2,r2_2,r3_2,r4_2,r5_2,r6_2,r7_2) (r0,r1,r2,r3,r4,r5,r6,r7)). auto => />. call (avx2_shuffle2_corr_h r6_4 r7_4) => />. auto => />.
(*shuffle1*)
pose r0_1 := (shuf1 r0_2 r4_2).`1.
pose r1_1 := (shuf1 r1_2 r5_2).`1.
pose r2_1 := (shuf1 r2_2 r6_2).`1.
pose r3_1 := (shuf1 r3_2 r7_2).`1.
pose r4_1 := (shuf1 r0_2 r4_2).`2.
pose r5_1 := (shuf1 r1_2 r5_2).`2.
pose r6_1 := (shuf1 r2_2 r6_2).`2.
pose r7_1 := (shuf1 r3_2 r7_2).`2.
seq 1 : (is16u16x8 (r0_1,r1_2,r2_2,r3_2,r4_1,r5_2,r6_2,r7_2) (r0,r1,r2,r3,r4,r5,r6,r7)). auto => />. call (avx2_shuffle1_corr_h r0_2 r4_2) => />. auto => />.
seq 1 : (is16u16x8 (r0_1,r1_1,r2_2,r3_2,r4_1,r5_1,r6_2,r7_2) (r0,r1,r2,r3,r4,r5,r6,r7)). auto => />. call (avx2_shuffle1_corr_h r1_2 r5_2) => />. auto => />.
seq 1 : (is16u16x8 (r0_1,r1_1,r2_1,r3_2,r4_1,r5_1,r6_1,r7_2) (r0,r1,r2,r3,r4,r5,r6,r7)). auto => />. call (avx2_shuffle1_corr_h r2_2 r6_2) => />. auto => />.
seq 1 : (is16u16x8 (r0_1,r1_1,r2_1,r3_1,r4_1,r5_1,r6_1,r7_1) (r0,r1,r2,r3,r4,r5,r6,r7)). auto => />. call (avx2_shuffle1_corr_h r3_2 r7_2) => />. auto => />.
(*end*)
auto => /> &m -> -> -> -> -> -> -> ->. 
do 8!(try split; first by
 apply W16u16.wordP => i Hi; rewrite !bits16_W16u16 // Hi //= !of_listE !list_arr16 !initiE //=; rewrite /to_list !nth_mkseq //=; move:Hi; rewrite rng_iotared => />;
 do 16!(try(move => Hi; case Hi => />); first by rewrite /nttunpack128 /perm_nttunpack128 unpack16x8E pack16x8E => />)).
qed.

lemma __nttunpack128_ll: islossless M.__nttunpack128 by islossless.

phoare nttunpack128_corr a :
 [ M.__nttunpack128 :
   is16u16x8 a arg ==> is16u16x8 (nttunpack128x16 a) res] = 1%r.
conseq __nttunpack128_ll (nttunpack128_corr_h a) => />. qed.

lemma nttunpack_corr_h a :
 hoare[ M._nttunpack : arg = a ==> res = nttunpack a].
proc. sp. 
seq 1 : (rp=a /\ is16u16x8 (nttunpack128x16 (unpack16x8 (unpack128x2 a).`1)) (r0,r1,r2,r3,r4,r5,r6,r7)). auto => />. call (nttunpack128_corr_h (unpack16x8 (unpack128x2 a).`1)) => />. auto => />.
do 8!(try split; first by
 apply W16u16.wordP => i Hi; rewrite bits16_W16u16 // Hi //=; rewrite /get256_direct bits16_W32u8 Hi //=; rewrite unpack16x8E unpack128x2E //=; move :Hi; rewrite rng_iotared;
 do 16!(try (move => Hi; case Hi => />); first by rewrite !initiE //= pack2_bits8 //)).
seq 8 : ((unpack128x2 rp).`2 = (unpack128x2 a).`2 /\ (unpack128x2 rp).`1 = (unpack128x2 (nttunpack a)).`1 ).
wp. skip => /> &m -> -> -> -> -> -> -> ->. rewrite nttunpack128x2. rewrite !unpack128x2E => />. split.
+ rewrite tP => j Hj. rewrite !initiE //=. rewrite !initiE //= 1:/#. rewrite !list_arr16 /=.
  do 8!(rewrite set256_directE 1:/#; rewrite get16_set256E //=; rewrite ifF 1:/#; rewrite get16_init16 1:/#; try(rewrite !initiE //=1:/#)). trivial.
+ rewrite tP => j Hj. rewrite !initiE //= 1:/#. rewrite !list_arr16.
  do 7!(rewrite set256_directE 1:/#; rewrite get16_set256E //=; rewrite get16_init16 1:/#; rewrite initiE //= 1:/#).
  rewrite set256_directE 1:/#. rewrite get16_set256E //=. rewrite get16_init16 1:/#. 
  rewrite !bits16_W16u16. rewrite !unpack16x8K. rewrite !of_listE !initE //= /to_list !nth_mkseq_if //=. rewrite rng_perm_nttunpack128 //=. rewrite !unpack16x8E //=. rewrite !initE //=. rewrite /nttunpack128 !initE //=. rewrite !initE //=. rewrite !rng_perm_nttunpack128 //=. smt().
sp. 
seq 1 : ((unpack128x2 rp).`2 = (unpack128x2 a).`2 /\ (unpack128x2 rp).`1 = (unpack128x2 (nttunpack a)).`1 /\ is16u16x8 (nttunpack128x16 (unpack16x8 (unpack128x2 a).`2)) (r0,r1,r2,r3,r4,r5,r6,r7)). auto => />. call (nttunpack128_corr_h (unpack16x8 (unpack128x2 a).`2)) => />. auto => /> &m <- H2.
do 8!(try split; first by
 apply W16u16.wordP => i Hi; rewrite bits16_W16u16 // Hi //=; rewrite /get256_direct bits16_W32u8 Hi //=; rewrite unpack16x8E unpack128x2E //=; move :Hi; rewrite rng_iotared => />;
 do 16!(try (move => Hi; case Hi => />); first by rewrite !initiE //= pack2_bits8 //)).
auto => /> &m H1 H2 -> -> -> -> -> -> -> ->.
apply inj_unpack128x2 => />. rewrite -(unpack128x2K rp{m}) (prod (unpack128x2 rp{m})). rewrite (prod (unpack128x2 (nttunpack a))). 
move :H1 H2. move => -> ->.
rewrite nttunpack128x2 !unpack16x8K !list_arr16 !unpack128x2E !pack128x2E => />. split.
+ rewrite tP => i Hi.
  rewrite !initiE //= 1:/#. rewrite !initiE //=. rewrite rng_perm_nttunpack128 //.
  do 8!(rewrite set256_directE 1:/# get16_set256E //=; rewrite ifF 1:/#; rewrite get16_init16 1:/#; rewrite !initiE //= 1:/#).
  rewrite ifT //=. rewrite /nttunpack128 !initiE //= 1:/#. rewrite !initiE //=. rewrite rng_perm_nttunpack128 1:/#. smt().
+ rewrite tP => i Hi. rewrite !initiE //=. rewrite !initiE //= 1:/#. rewrite rng_perm_nttunpack128 //.
  do 8!(rewrite set256_directE 1:/# get16_set256E //=; rewrite get16_init16 1:/#; rewrite !initiE //= 1:/#).
  rewrite !bits16_W16u16. rewrite !of_listE !initE //= /to_list !nth_mkseq_if //=. rewrite !unpack16x8E //=. rewrite !initE //=. rewrite /nttunpack128 !initE //=. rewrite !initE //=. rewrite !rng_perm_nttunpack128 //= 1..2:/#.
qed.

lemma _nttunpack_ll: islossless M._nttunpack by islossless.

phoare nttunpack_corr a :
 [ M._nttunpack : arg = a ==> res = nttunpack a] = 1%r.
conseq _nttunpack_ll (nttunpack_corr_h a) => />. qed.




(* -------------------------------------------------------------------- *)
(* the matrix the model samples, entry by entry                         *)
op Mb (sd : W8.t Array32.t) (b : bool) : polymat =
  if b then trmx (sampleA sd) else sampleA sd.

lemma MbE sd b pos : 0 <= pos < kvec * kvec =>
  (Mb sd b).[idx_from_pos pos] = parse sd (pos2ji pos b).`1 (pos2ji pos b).`2.
proof.
move=> rgp; have [h0 h1] : 0 <= pos %/ kvec < kvec /\ 0 <= pos %% kvec < kvec.
+ by split; [split; [smt(divz_ge0 gt0_k) | move=> _; rewrite ltz_divLR; smt(gt0_k)] |
     smt(modz_ge0 ltz_pmod gt0_k)].
rewrite /Mb /pos2ji /=; case: b => _ /=.
+ by rewrite trmxE // sampleAE.
by rewrite sampleAE.
qed.

lemma blk_unlift_matrix (A : polymat) pos : 0 <= pos < kvec * kvec =>
  blk (unlift_matrix A) pos = unlift_polyu A.[idx_from_pos pos].
proof.
move=> rgp; apply Array256.tP => k kb.
rewrite blkE // /unlift_matrix Array_matn.initiE 1:matn_slice // /unlift_polyu.
rewrite Array256.initiE //=.
have e : 256 * pos + k = pos %/ kvec * vecn + (256 * (pos %% kvec) + k).
+ by rewrite vecnE {1}(divz_eq pos kvec); ring.
have rk : 0 <= 256 * (pos %% kvec) + k < vecn.
+ by rewrite vecnE; smt(modz_ge0 ltz_pmod gt0_k).
rewrite e divzMDl; 1: smt(gt0_k vecnE).
rewrite (divz_small (256 * (pos %% kvec) + k)) 1:/# /= modzMDl modz_small 1:/#.
have -> : (256 * (pos %% kvec) + k) %/ 256 = pos %% kvec by smt().
have -> // : (pos %/ kvec * vecn + (256 * (pos %% kvec) + k)) %% 256 = k.
by rewrite vecnE; smt().
qed.

(* -------------------------------------------------------------------- *)
(* four entries at a time                                               *)
op [a] subarray1024 (x : 'a Array_matn.t) (p : int) : 'a Array1024.t =
  Array1024.init (fun (k : int) => x.[1024 * p + k]).

lemma subarray1024_blk (x : 'a Array_matn.t) p : 0 <= p < kvec * kvec %/ 4 =>
  subarray1024 x p = pack4poly (blk x (4 * p), blk x (4 * p + 1),
                                blk x (4 * p + 2), blk x (4 * p + 3)).
proof.
move=> rgp; apply pack4polyP => i rgi.
rewrite /subarray1024 Array1024.initiE //=.
by case: (i < 256) => h0; [|case: (i < 512) => h1; [|case: (i < 768) => h2]];
  rewrite blkE 1:/#; congr; ring.
qed.

(* the index table: entry pos of the matrix, transposed or not, is read *)
(* at 2 * pos + 2^(kvec + 1) * t; it is set-specific                    *)
axiom gen_matrix_indexesP (t : bool) pos : 0 <= pos < 4 * (kvec * kvec %/ 4) =>
  gen_matrix_indexes.[2 * pos + 2 ^ (kvec + 1) * b2i t] = (pos2ji pos t).`1 /\
  gen_matrix_indexes.[2 * pos + 2 ^ (kvec + 1) * b2i t + 1] = (pos2ji pos t).`2.

lemma idx_table_bnd p (t : bool) : 0 <= p < kvec * kvec %/ 4 =>
  0 <= 8 * p + 2 ^ (kvec + 1) * b2i t /\ 8 * p + 2 ^ (kvec + 1) * b2i t + 8 <= idx_table.
proof.
move=> rgp; have : kvec = 2 \/ kvec = 3 \/ kvec = 4 by smt(param_sets).
rewrite /idx_table; case=> [|[|]] hk; move: rgp; rewrite hk /=; case: t; smt().
qed.

hoare gen_matrix_get_indexes_h p (t : bool) :
  M.gen_matrix_get_indexes :
  to_uint b = 8 * p /\ to_uint _t = b2i t /\ 0 <= p < kvec * kvec %/ 4 ==>
  res = W8u8.pack8 (sub gen_matrix_indexes (8 * p + 2 ^ (kvec + 1) * b2i t) 8).
proof.
proc => /=.
seq 5 : (idxs = gen_matrix_indexes /\ to_uint b = 8 * p + 2 ^ (kvec + 1) * b2i t /\
         0 <= p < kvec * kvec %/ 4) => //=.
+ auto => /> &m hb ht hp0 hp1.
  have hk : kvec = 2 \/ kvec = 3 \/ kvec = 4 by smt(param_sets).
  rewrite to_uintD_small to_uint_shl !of_uintK;
    by move: hp1; rewrite ?hb ?ht; case: hk => [|[|]] -> /=; case: t => /=; smt().
auto => /> &m hb hp0 hp1.
have [h0 h1] := idx_table_bnd p t _; 1: done.
rewrite WArray_idx_table.get64E; congr; apply W8u8.Pack.ext_eq => i Hi.
rewrite W8u8.Pack.initiE 1:// W8u8.Pack.get_of_list 1:// /=.
by rewrite WArray_idx_table.initiE 1:/# /sub nth_mkseq 1:// /= hb.
qed.

lemma gen_matrix_get_indexes_ll : islossless M.gen_matrix_get_indexes by islossless.

phoare gen_matrix_get_indexes_ph p (t : bool) :
  [ M.gen_matrix_get_indexes :
    to_uint b = 8 * p /\ to_uint _t = b2i t /\ 0 <= p < kvec * kvec %/ 4 ==>
    res = W8u8.pack8 (sub gen_matrix_indexes (8 * p + 2 ^ (kvec + 1) * b2i t) 8) ] = 1%r.
proof. by conseq gen_matrix_get_indexes_ll (gen_matrix_get_indexes_h p t). qed.

lemma sample_four _sd p b : 0 <= p < kvec * kvec %/ 4 =>
  phoare [ M._gen_matrix_sample_four_polynomials :
    rho = _sd /\ pos_entry = W64.of_int (8 * p) /\ transposed = W64.of_int (b2i b) ==>
    res.`1 = subarray1024 (unlift_matrix (Mb _sd b)) p ] = 1%r.
proof.
move=> rgp.
pose w := W8u8.pack8 (sub gen_matrix_indexes (8 * p + 2 ^ (kvec + 1) * b2i b) 8).
conseq (sample_four_ph _sd (W64.of_int (8 * p)) (W64.of_int (b2i b)) w _) => //.
+ move=> &hr _ r; suff -> : subarray1024 (unlift_matrix (Mb _sd b)) p =
    pack4poly (lane_poly _sd w 0, lane_poly _sd w 1, lane_poly _sd w 2, lane_poly _sd w 3)
    by done.
  (* the index bytes of lane k are the coordinates of entry 4 * p + k *)
  have hw : forall k, 0 <= k < 4 =>
    lane_poly _sd w k = unlift_polyu (Mb _sd b).[idx_from_pos (4 * p + k)].
  + move=> k rgk; rewrite MbE; 1: smt().
    have [h0 h1] := gen_matrix_indexesP b (4 * p + k) _; 1: smt().
    have [hb0 hb1] := idx_table_bnd p b rgp.
    rewrite /w !W8u8.get_pack8 1,2:Array_idx_table.size_sub //.
    rewrite !Array_idx_table.nth_sub 1,2:/#.
    by rewrite -h0 -h1; do 3! congr; ring.
  rewrite subarray1024_blk // !blk_unlift_matrix 1..4:/#.
  by rewrite !hw.
conseq (gen_matrix_get_indexes_ph p b) => &hr /= -> /=.
rewrite !of_uintK; split; 2: by case: b.
have hk : kvec = 2 \/ kvec = 3 \/ kvec = 4 by smt(param_sets).
by move: rgp; case: hk => [|[|]] -> /=; smt().
qed.

(* the last entry alone, when kvec is odd: the diagonal entry, the same *)
(* in the matrix and its transpose                                      *)
phoare sample_last _rho :
 [ M.__gen_matrix_sample_one_polynomial :
   rho = _rho /\ rc = W16.of_int ((kvec - 1) * 257) ==>
   res.`1 = unlift_polyu (sampleA _rho).[(kvec - 1, kvec - 1)] ] = 1%r.
proof.
pose c := W8.of_int (kvec - 1).
pose seed := (_rho, (c, c)).
pose st0 := Keccak1600_Spec.SHAKE128_ABSORB (rejection_seed seed).
conseq (_ : rho = _rho /\ rc = W16.of_int ((kvec - 1) * 257)
        ==> res.`1 = unlift_polyu (parse _rho c c)).
+ by move=> &hr _ r; rewrite sampleAE; smt(gt0_k).
proc; exlim buf => b0.
call (fill_polynomial_ph _rho c c).
call (shake128_squeeze3blocks_ph b0 st0).
wp; call (shake128_absorb_A32_A2_ph _rho (Array2.of_list witness [c; c])).
auto => &hr |> /=.
have hc : Array2.init (WArray2.get8 (WArray2.set16_direct
    (WArray2.init8 ("_.[_]" witness<:W8.t Array2.t>)) 0 (W16.of_int ((kvec - 1) * 257))))
  = Array2.of_list witness [c; c].
+ have hk : kvec = 2 \/ kvec = 3 \/ kvec = 4 by smt(param_sets).
  by rewrite /c; case: hk => [|[|]] -> /=; apply Array2.all_eq_eq; rewrite /all_eq /=.
split; 1: exact hc.
move=> _; split; 1: by rewrite Array2.of_listK.
move=> _ _ r h0 h1 h2 _.
rewrite -(buf_subl_cat r.`2 0 168 504) 1:// -(buf_subl_cat r.`2 168 336 504) 1://.
rewrite !buf_sublE 1..3:// /= h0 h1 h2.
rewrite /expand_seed /squeezeblocks -iotaredE /flatten /= /c256_r8 /st0 /seed.
by rewrite cats0.
qed.

lemma blk_nttunpackm (v : 'a Array_matn.t) pos : 0 <= pos < kvec * kvec =>
  blk (nttunpackm v) pos = nttunpack (blk v pos).
proof.
move=> rgp; apply Array256.tP => k kb.
have e : 256 * pos + k = pos %/ kvec * vecn + (256 * (pos %% kvec) + k).
+ by rewrite vecnE {1}(divz_eq pos kvec); ring.
have rk : 0 <= 256 * (pos %% kvec) + k < vecn.
+ by rewrite vecnE; smt(modz_ge0 ltz_pmod gt0_k).
rewrite blkE // /nttunpackm Array_matn.initiE 1:matn_slice //= e.
rewrite divzMDl; 1: smt(gt0_k vecnE).
rewrite (divz_small (256 * (pos %% kvec) + k)) 1:/# /= modzMDl modz_small 1:/#.
rewrite /nttunpackv Array_vecn.initiE //=.
have -> : (256 * (pos %% kvec) + k) %/ 256 = pos %% kvec by smt().
have -> : (256 * (pos %% kvec) + k) %% 256 = k by smt().
congr; apply Array256.tP => k' kb'.
congr; congr; apply Array256.tP => j jb.
rewrite subarray256E // /subarrayvecn Array_vecn.initiE 1:vecn_slice;
  1,2: smt(modz_ge0 ltz_pmod gt0_k).
rewrite /= blkE //; congr; rewrite vecnE {3}(divz_eq pos kvec); ring.
qed.

lemma Mb_diag sd b : (Mb sd b).[(kvec - 1, kvec - 1)] = (sampleA sd).[(kvec - 1, kvec - 1)].
proof. by rewrite /Mb; case: b => //= _; rewrite trmxE; smt(gt0_k). qed.

(* the matrix with four entries 4 * p .. 4 * p + 3 replaced *)
lemma blk_set4 (r : 'a Array_matn.t) (x : 'a Array1024.t) p pos :
  0 <= p < kvec * kvec %/ 4 => 0 <= pos < kvec * kvec =>
  blk (Array_matn.init (fun k =>
    if p * 4 * 256 <= k < p * 4 * 256 + 1024 then x.[k - p * 4 * 256] else r.[k])) pos =
  if 4 * p <= pos < 4 * p + 4 then Array256.init (fun k => x.[256 * (pos - 4 * p) + k])
  else blk r pos.
proof.
move=> pb posb; apply Array256.tP => k kb.
rewrite blkE // Array_matn.initiE 1:matn_slice //=.
case: (4 * p <= pos < 4 * p + 4) => h /=.
+ by rewrite ifT 1:/# Array256.initiE //=; congr; ring.
by rewrite ifF 2:blkE //; smt().
qed.

phoare _gen_matrix_avx2_sem _sd b :
 [ M._gen_matrix_avx2 : arg.`2 = _sd /\ arg.`3 = W64.of_int (b2i b) ==>
   res = nttunpackm (unlift_matrix (Mb _sd b)) ] = 1%r.
proof.
proc => /=; sp.
pose M0 := unlift_matrix (Mb _sd b).
(* the unpacking of every entry, row by row *)
while (0 <= i <= kvec /\
  (forall pos, 0 <= pos < i * kvec => blk matrix pos = nttunpack (blk M0 pos)) /\
  (forall pos, i * kvec <= pos < kvec * kvec => blk matrix pos = blk M0 pos)) (kvec - i).
+ move=> z; wp.
  while (0 <= i < kvec /\ 0 <= j <= kvec /\
    (forall pos, 0 <= pos < i * kvec + j => blk matrix pos = nttunpack (blk M0 pos)) /\
    (forall pos, i * kvec + j <= pos < kvec * kvec => blk matrix pos = blk M0 pos) /\
    kvec - i = z) (kvec - j).
  + move=> z'; wp; ecall (nttunpack_corr (blk matrix (i * kvec + j))).
    auto => &hr [#] i0 ik j0 jk ih eq vz jlt vz'.
    have e : i{hr} * (kvec * 256) + j{hr} * 256 = 256 * (i{hr} * kvec + j{hr}) by ring.
    rewrite e /=; split.
    + by apply Array256.tP => k kb; rewrite Array256.initiE //= blkE.
    move=> _ r ->; have rgp : 0 <= i{hr} * kvec + j{hr} < kvec * kvec by smt().
    do split; 1..4,7,8: smt().
    + move=> pos posb; rewrite blk_set 1,2:/#.
      by case: (pos = i{hr} * kvec + j{hr}) => [->|ne]; [rewrite eq | apply ih] => /#.
    by move=> pos posb; rewrite blk_set 1,2:/# ifF 1:/# eq /#.
  auto => &hr [#] i0 ik ih eq ilt vz; split; 1: smt(gt0_k).
  move=> j m; split; 1: smt().
  move=> jge [#] _ _ j0 jk ih' eq' _; have {jge j0 jk} ? : j = kvec by smt(). subst j.
  do split; 1,2,5: smt().
  + by move=> pos posb; apply ih' => /#.
  by move=> pos posb; apply eq' => /#.
wp; conseq (_ : _ ==> matrix = M0).
+ move=> &hr _ m; split => [[[_ [_ h]] _] | ->].
  + by apply/matn_tP => pos posb; apply h => /#.
  split; 1: smt(gt0_k).
  move=> i0 m0; split; 1: smt().
  move=> ige [#] i0' ik ih _; have ? : i0 = kvec by smt(). subst i0.
  by apply/matn_tP => pos posb; rewrite blk_nttunpackm // ih.
(* the entries four at a time, then the last one alone when kvec is odd *)
case (kvec * kvec %% 4 = 1).
+ rcondt 2; 1: by conseq (: true ==> true) => //.
  wp; call (sample_last _sd); wp.
  while (0 <= i <= inc /\ inc = kvec * kvec %/ 4 /\ rho = _sd /\
         transposed = W64.of_int (b2i b) /\ kvec * kvec %% 4 = 1 /\
         forall pos, 0 <= pos < 4 * i => blk matrix pos = blk M0 pos) (inc - i).
  + move=> z; exlim i => i0.
    have h0 : (0 <= i0 < kvec * kvec %/ 4) \/ !(0 <= i0 < kvec * kvec %/ 4) by smt().
    move: h0 => [hi0|hi0]; last by exfalso => &hr /#.
    wp; call (sample_four _sd i0 b hi0).
    auto => &hr [#] <- i0' ik hinc hrho htr hx ih ilt vz.
    split; 1: done.
    move=> _ r hr; do split; 1..6,8: smt().
    move=> pos posb; rewrite blk_set4 1,2:/# hr.
    case: (4 * i0 <= pos < 4 * i0 + 4) => h; last by apply ih => /#.
    apply Array256.tP => k kb; rewrite Array256.initiE //= blkE //.
    rewrite /subarray1024 Array1024.initiE 1:/# /=.
    by have -> : 1024 * i0 + (256 * (pos - 4 * i0) + k) = 256 * pos + k by ring.
  auto => &hr /> hodd; split; 1: smt(gt0_k).
  move=> i0 m0; split; 1: smt().
  move=> ige i00 ik ih r ->.
  have ? : i0 = kvec * kvec %/ 4 by smt(). subst i0.
  have e : (kvec * kvec - 1) * 256 = 256 * (kvec * kvec - 1) by ring.
  rewrite e; apply/matn_tP => pos posb; rewrite blk_set 1,2:/#.
  case: (pos = kvec * kvec - 1) => [->|ne]; last by apply ih => /#.
  rewrite blk_unlift_matrix 1:/# /=.
  have e2 : kvec * kvec - 1 = (kvec - 1) * kvec + (kvec - 1) by ring.
  rewrite e2 divzMDl 1:#smt:(gt0_k) divz_small 1:#smt:(gt0_k).
  by rewrite modzMDl modz_small 1:#smt:(gt0_k) /= Mb_diag.
rcondf 2; 1: by conseq (: true ==> true) => //.
while (0 <= i <= inc /\ inc = kvec * kvec %/ 4 /\ rho = _sd /\
       transposed = W64.of_int (b2i b) /\ kvec * kvec = 4 * inc /\
       forall pos, 0 <= pos < 4 * i => blk matrix pos = blk M0 pos) (inc - i).
+ move=> z; exlim i => i0.
  have h0 : (0 <= i0 < kvec * kvec %/ 4) \/ !(0 <= i0 < kvec * kvec %/ 4) by smt().
  move: h0 => [hi0|hi0]; last by exfalso => &hr /#.
  wp; call (sample_four _sd i0 b hi0).
  auto => &hr [#] <- i0' ik hinc hrho htr hx ih ilt vz.
  split; 1: done.
  move=> _ r hr; do split; 1..6,8: smt().
  move=> pos posb; rewrite blk_set4 1,2:/# hr.
  case: (4 * i0 <= pos < 4 * i0 + 4) => h; last by apply ih => /#.
  apply Array256.tP => k kb; rewrite Array256.initiE //= blkE //.
  rewrite /subarray1024 Array1024.initiE 1:/# /=.
  by have -> : 1024 * i0 + (256 * (pos - 4 * i0) + k) = 256 * pos + k by ring.
auto => &hr /> heven; split; 1: smt(gt0_k param_sets).
move=> i0 m0; split; 1: smt().
move=> ige i00 ik hk ih; apply/matn_tP => pos posb; apply ih => /#.
qed.

end MLKEM_genmatrix_avx2T.
