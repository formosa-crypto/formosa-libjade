require import AllCore IntDiv List.

from Jasmin require import JModel.

from JazzEC require import WArray512 WArray256 WArray128 WArray8 WArray2 WArray32.
from JazzEC require import Array2 Array8 Array16 Array25 Array32 Array33 Array128 Array136 Array768 Array960 Array1024 Array1088 Array2304 Array2144 Array536 Array256.

require import MLKEM_W16_Rep NTT_avx2 NTT_avx2_poly MLKEMFCLib AVX2_Ops MLKEM_Poly_avx2.
require import MLKEM768_prelude.
import MLKEMFCLib768.

require import MLKEM_keccak_avx2.

import NTT_Avx2.

from JazzEC require import Jkem_avx2.

import GFq Rq Sampling Serialization Symmetric VecMat KPKE MLKEM Fq Correctness.
import Symmetric Serialization VecMat PolyMat.
import KMatrix.Matrix.
import MLKEM_PolyAVXVec.

(* Matrix lift/unlift bridge: unlift is a right-inverse of lift, plus the
   coefficient bound.  lift_matrix/unlift_matrix live in MLKEM_W16_Rep. *)
lemma matrix_unlift a :
    lift_matrix (unlift_matrix a) = a /\
    pos_bound2304_cxq (unlift_matrix a) 0 2304 2.
proof.
split.
+ apply eq_polymatP => i j bi bj.
  rewrite /lift_matrix {1}/PolyMat."_.[_]" KMat.initiE 1:/# /=.
  have ->: (i * kvec + j) %/ kvec = i by smt(kvec_val).
  have ->: (i * kvec + j) %% kvec = j by smt(kvec_val).
  rewrite tP => k kb.
  rewrite /subarray256 initiE 1:/# /=.
  rewrite /subarray768 /=.
  rewrite Array768.initiE; first by smt(kvec_val).
  simplify.
  rewrite /lift_array2304 Array2304.mapiE; first by smt(kvec_val).
  simplify.
  rewrite /unlift_matrix Array2304.initiE; first by smt(kvec_val).
  simplify.
  have ->: (768 * i + (256 * j + k)) %/ 768 = i by smt(kvec_val).
  have ->: (768 * i + (256 * j + k)) %% 768 %/ 256 = j by smt(kvec_val).
  have ->: (768 * i + (256 * j + k)) %% 256 = k by smt(kvec_val).
  have ->: W16.to_sint (of_int (Zq.asint a.[i, j].[k])) = Zq.asint a.[i, j].[k].
  + rewrite W16.to_sintE W16.of_uintK /smod /=; smt(Zq.rg_asint qE).
  by rewrite Zq.asintK.
rewrite /unlift_matrix /pos_bound2304_cxq => k kb; rewrite initiE //=.
rewrite W16.to_sintE W16.of_uintK /smod /=; smt(Zq.rg_asint qE).
qed.

(********* MOVED HERE TO AVOID CIRCULAR DEPS ************)

(* move somewhere else *)

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
 hoare[ Jkem_avx2.M.__nttunpack128 :
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

lemma __nttunpack128_ll: islossless Jkem_avx2.M.__nttunpack128 by islossless.

phoare nttunpack128_corr a :
 [ Jkem_avx2.M.__nttunpack128 :
   is16u16x8 a arg ==> is16u16x8 (nttunpack128x16 a) res] = 1%r.
conseq __nttunpack128_ll (nttunpack128_corr_h a) => />. qed.

lemma nttunpack_corr_h a :
 hoare[ Jkem_avx2.M._nttunpack : arg = a ==> res = nttunpack a].
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

lemma _nttunpack_ll: islossless Jkem_avx2.M._nttunpack by islossless.

phoare nttunpack_corr a :
 [ Jkem_avx2.M._nttunpack : arg = a ==> res = nttunpack a] = 1%r.
conseq _nttunpack_ll (nttunpack_corr_h a) => />. qed.



lemma lift768_nttunpack (v : W16.t Array768.t):
  lift_array768 (nttunpackv v) = nttunpackv (lift_array768 v).
rewrite /lift_array768 /nttunpackv tP => k kb.
rewrite mapiE //= !initiE //=.
case (0<=k <256).
+ move => *; rewrite /subarray256 /nttunpack !initiE //=.
  pose a:=nttunpack_idx.[k].
  rewrite initiE //=. smt(nttunpack_bnd Array256.allP).
  rewrite initiE //=. smt(nttunpack_bnd Array256.allP).
  rewrite mapiE //=. smt(nttunpack_bnd Array256.allP).
case (256<=k <512).
+ move => *; rewrite /subarray256 /nttunpack !initiE //=. smt(). smt().
  pose a:=nttunpack_idx.[k-256].
  rewrite initiE //=. smt(nttunpack_bnd Array256.allP).
  rewrite initiE //=. smt(nttunpack_bnd Array256.allP).
  rewrite mapiE //=. smt(nttunpack_bnd Array256.allP).
move => *; rewrite /subarray256 /nttunpack !initiE //=. smt(). smt().
pose a:=nttunpack_idx.[k-512].
rewrite initiE //=. smt(nttunpack_bnd Array256.allP).
rewrite initiE //=. smt(nttunpack_bnd Array256.allP).
rewrite mapiE //=. smt(nttunpack_bnd Array256.allP).
qed.
(********************************************************)


module HmoduleLow = {
   proc __gen_matrix(sd : W8.t Array32.t, trans : bool) : W16.t Array2304.t = {
       var aa : polymat;
       if (trans) {
          aa <@ Hmodule.sampleAT(sd);
       }
       else {
          aa <@ Hmodule.sampleA(sd);
       }
       return (unlift_matrix aa);
   }
}.

phoare Hmodule_low_sem _sd b :
 [  HmoduleLow.__gen_matrix : arg=(_sd,b) ==> res = if b 
                                             then unlift_matrix (trmx (sampleA _sd)) 
                                             else unlift_matrix (sampleA _sd) ] = 1%r. 
proc;case trans;last first.
+ rcondf 1;1: by auto. 
  by call (sampleA_sem _sd);auto => />.
rcondt 1;1: by auto. 
call (sampleAT_sem _sd);auto => />.
qed.


require import EclibExtra JWordList.
from Keccak require import Keccak1600_avx2x4.
require import MLKEM_keccak_avx2 Mlkem_filters_bridge MLKEM_sampler_avx2.

lemma unlift_polyu_getm (A: polymat) i j:
 0 <= i < 3 =>
 0 <= j < 3 =>
 unlift_polyu A.[(i,j)]%PolyMat
 = subarray256 (subarray768 (unlift_matrix A) i) j.
proof.
move=> Hi Hj.
apply Array256.ext_eq => k Hk.
rewrite initiE 1:/# initiE 1:/# /=.
rewrite initiE 1:/# /=.
rewrite initiE 1:/# /=.
have ->: (768 * i + (256 * j + k)) %/ 768 = i by smt().
have ->: (768 * i + (256 * j + k)) %% 768 %/ 256 = j by smt().
have ->: (768 * i + (256 * j + k)) %% 256 = k by smt().
done.
qed.

hoare gen_matrix_get_indexes_h _pos _transpose:
 Jkem_avx2.M.gen_matrix_get_indexes
 : to_uint b = 2*_pos /\ to_uint _t = b2i _transpose /\ (_pos=0 \/ _pos=4)
 ==>
   res = W8u8.pack8 (sub gen_matrix_indexes (2*_pos+16*b2i _transpose) 8).
proof.
proc => /=.
seq 5: (idxs=gen_matrix_indexes /\ to_uint b = 2*_pos + 16*b2i _transpose /\ (_pos=0 \/ _pos=4)) => //=.
 auto => /> &m Hb Ht Hpos.
 by rewrite to_uintD_small to_uint_shl !of_uintK 1,3:// /#.
auto => /> &m -> Hpos.
rewrite get64E; congr; apply W8u8.Pack.ext_eq => i Hi.
rewrite initiE 1:// get_of_list 1:// /=.
by rewrite initiE 1:/# /sub nth_mkseq 1://.
qed.

lemma gen_matrix_get_indexes_ll: islossless Jkem_avx2.M.gen_matrix_get_indexes
by islossless.

phoare gen_matrix_get_indexes_ph _pos _transpose:
 [ Jkem_avx2.M.gen_matrix_get_indexes
 : to_uint b = 2*_pos /\ to_uint _t = b2i _transpose /\ (_pos=0 \/ _pos=4)
 ==>
   res = W8u8.pack8 (sub gen_matrix_indexes (2*_pos+16*b2i _transpose) 8)
 ] = 1%r.
proof. by conseq gen_matrix_get_indexes_ll (gen_matrix_get_indexes_h _pos _transpose). qed.

lemma sub_gen_matrix_indexes idxs _pos _t _k (_a:WArray8.t):
 (_pos = 0 \/ _pos = 4) =>
 0 <= _k < 4 =>
 idxs = Array8.init
   (get8
      (set64_direct _a 0
         (pack8 (sub gen_matrix_indexes (2 * _pos + 16 * b2i _t) 8)))) =>
 sub idxs (2*_k) 2 = [(pos2ji (_pos+_k) _t).`1; (pos2ji (_pos+_k) _t).`2].
proof.
move=> Hpos Hk ->.
have: _k \in iotared 0 4 by smt().
move: {Hk} _k; apply /List.allP => /=.
by case: _t; case: Hpos; rewrite ?b2i1 ?b2i0 /pos2ji ?kvec_val /sub /mkseq -iotaredE.
qed.

op subarray1024 ['a] (x : 'a Array2304.t) (i : int) : 'a Array1024.t = 
        Array1024.init (fun (k : int) => x.[1024 * i + k]).


op mat4atPos (m: polymat) pos =
 ( m.[idx_from_pos pos]
 , m.[idx_from_pos (pos+1)]
 , m.[idx_from_pos (pos+2)]
 , m.[idx_from_pos (pos+3)]).

lemma pack4poly_subarray1024 (A: polymat) p:
 0 <= p < 2 =>
 pack4poly ( unlift_polyu (mat4atPos A (4*p)).`1
           , unlift_polyu (mat4atPos A (4*p)).`2
           , unlift_polyu (mat4atPos A (4*p)).`3
           , unlift_polyu (mat4atPos A (4*p)).`4
           )
 = subarray1024 (unlift_matrix A) p.
proof.
move=> Hp; apply Array1024.ext_eq => i Hi.
rewrite initiE 1:/# initiE 1:/# /=.
rewrite initiE 1:/# /=.
rewrite -!catA nth_cat size_to_list /=.
case: (i < 256) => Hi1.
 rewrite initiE 1:/# /= /mat4atPos /=.
 by congr; congr; congr; smt(kvec_val).
rewrite nth_cat size_to_list /=.
case: (i-256 < 256) => Hi2.
 rewrite initiE 1:/# /= /mat4atPos /=.
 by congr; congr; congr; smt(kvec_val).
rewrite nth_cat size_to_list /=.
case: (i-512 < 256) => Hi3.
 rewrite initiE 1:/# /= /mat4atPos /=.
 by congr; congr; congr; smt(kvec_val).
rewrite initiE 1:/# /= /mat4atPos /=.
by congr; congr; congr; smt(kvec_val).
qed.

lemma sample_four _sd _rc b :
 (_rc = 0 \/ _rc = 4) =>
 phoare
 [ Jkem_avx2.M._gen_matrix_sample_four_polynomials :
   rho = _sd /\ pos_entry = W64.of_int (2*_rc) /\ transposed = W64.of_int (b2i b) ==> 
   res.`1 = subarray1024 (unlift_matrix (if b then trmx (sampleA _sd) else (sampleA _sd))) (_rc %/ 3) ] = 1%r.
proof.
move=> Hrc.
pose w := W8u8.pack8 (sub gen_matrix_indexes (2*_rc + 16*b2i b) 8).
conseq (sample_four_ph _sd (W64.of_int (2*_rc)) (W64.of_int (b2i b)) w _) => //.
- move=> &hr _ r.
  (* the index bytes of lane k are the coordinates of entry _rc + k *)
  have hw : forall k, 0 <= k < 4 =>
    w \bits8 (2*k) = (pos2ji (_rc+k) b).`1 /\ w \bits8 (2*k+1) = (pos2ji (_rc+k) b).`2.
  + move=> k rgk.
    have := sub_gen_matrix_indexes (idx_of w) _rc b k
              (WArray8.init8 (fun i => (witness<:W8.t Array8.t>).[i])) Hrc rgk _.
    * done.
    by rewrite idx_subE.
  have hM : forall pos, 0 <= pos < 9 =>
    (if b then trmx (sampleA _sd) else sampleA _sd).[idx_from_pos pos]
    = parse _sd (pos2ji pos b).`1 (pos2ji pos b).`2.
  + move=> pos rgp; rewrite /pos2ji /=; case: b => _ /=.
    * by rewrite trmxE 1,2:#smt:(kvec_val) sampleAE 1,2:#smt:(kvec_val).
    by rewrite sampleAE 1,2:#smt:(kvec_val).
  suff -> : subarray1024 (unlift_matrix (if b then trmx (sampleA _sd) else sampleA _sd))
                         (_rc %/ 3)
          = pack4poly (lane_poly _sd w 0, lane_poly _sd w 1,
                       lane_poly _sd w 2, lane_poly _sd w 3) by done.
  rewrite -(pack4poly_subarray1024 _ (_rc %/ 3)) 1:/# (_ : 4 * (_rc %/ 3) = _rc) 1:/#.
  rewrite /mat4atPos /=.
  have [h00 h01] := hw 0 _; 1: done.
  have [h10 h11] := hw 1 _; 1: done.
  have [h20 h21] := hw 2 _; 1: done.
  have [h30 h31] := hw 3 _; 1: done.
  move: h00 h01 h10 h11 h20 h21 h30 h31 => /= -> -> -> -> -> -> -> ->.
  by rewrite !hM 1..4:/#.
conseq (gen_matrix_get_indexes_ph _rc b) => &hr /= ->.
by rewrite /= !of_uintK; case: Hrc => -> /=; case: b.
qed.

phoare sample_last _rho :
 [ Jkem_avx2.M.__gen_matrix_sample_one_polynomial :
   rho = _rho /\ rc = W16.of_int (2*256+2) ==> 
   res.`1 = subarray256 (subarray768 (unlift_matrix (sampleA _rho)) 2) 2 ] = 1%r.
proof.
pose seed := (_rho, (W8.of_int 2, W8.of_int 2)).
pose st0 := SHAKE128_ABSORB (rejection_seed seed).
conseq (_ : rho = _rho /\ rc = W16.of_int 514
        ==> res.`1 = unlift_polyu (parse _rho (W8.of_int 2) (W8.of_int 2))).
- move=> &hr _ r; rewrite -unlift_polyu_getm 1,2:#smt:(kvec_val).
  by rewrite sampleAE 1,2:#smt:(kvec_val).
proc; exlim buf => b0.
call (fill_polynomial_ph _rho (W8.of_int 2) (W8.of_int 2)).
call (shake128_squeeze3blocks_ph b0 st0).
wp; call (shake128_absorb_A32_A2_ph _rho (Array2.of_list witness [W8.of_int 2; W8.of_int 2])).
auto => &hr |> /=.
split; 1: by apply Array2.all_eq_eq; rewrite /all_eq /=.
move=> _; split; 1: by rewrite of_listK.
move=> _ _ r h0 h1 h2 _.
rewrite -(buf_subl_cat r.`2 0 168 504) 1:// -(buf_subl_cat r.`2 168 336 504) 1://.
rewrite !buf_sublE 1..3:// /= h0 h1 h2.
rewrite /expand_seed /squeezeblocks -iotaredE /flatten /= /c256_r8 /st0 /seed.
by rewrite cats0.
qed.

phoare _gen_matrix_avx2_sem _sd b :
 [  Jkem_avx2.M._gen_matrix_avx2 : arg.`2 = _sd /\ arg.`3 = W64.of_int (b2i b)
                                         ==> res = if b 
                                             then nttunpackm (unlift_matrix (trmx (sampleA _sd))) 
                                             else nttunpackm (unlift_matrix (sampleA _sd)) ] = 1%r.
proof.
proc => /=. 
(* K = 3: two batches of four entries, then the last one alone *)
cfold 6; rcondt 8; first by auto.
wp 16.
while (0<=i<=3 /\ rho = _sd /\ 
    ((forall kk, 0 <= kk < i => subarray768 matrix kk = nttunpackv (subarray768 (unlift_matrix (if b then trmx (sampleA _sd) else (sampleA _sd))) kk))) /\
     (forall kk, i <= kk < 3 => subarray768 matrix kk = (subarray768 (unlift_matrix (if b then trmx (sampleA _sd) else (sampleA _sd))) kk))) (kvec-i).
+ move => *;wp => />. move => &hr; smt(kvec_val).
  while (0<=i<3 /\ 0 <= j <= 3 /\ rho = _sd /\
    ((forall kk, 0 <= kk < i => subarray768 matrix kk = nttunpackv (subarray768 (unlift_matrix (if b then trmx (sampleA _sd) else (sampleA _sd))) kk))) /\
     (forall kk, i+1 <= kk < 3 => subarray768 matrix kk = (subarray768 (unlift_matrix (if b then trmx (sampleA _sd) else (sampleA _sd))) kk)) /\
     (forall kk, 0 <= kk < j => subarray256 (subarray768 matrix i) kk = nttunpack (subarray256 (subarray768 (unlift_matrix (if b then trmx (sampleA _sd) else (sampleA _sd))) i) kk)) /\
     (forall kk, j <= kk < 3 => subarray256 (subarray768 matrix i) kk = subarray256 (subarray768 (unlift_matrix (if b then trmx (sampleA _sd) else (sampleA _sd))) i) kk)) (kvec-j); last first.
  + auto => /> &hr ?? H H0 ?;do split;1..3:smt(kvec_val).
    + move => j0 m;do split;1:smt(kvec_val).
      move => ??? H1 H2 H3 H4;do split;1,2,4..:smt(kvec_val). 
      move => kk kkbl kkbh;case(kk=i{hr});2: by smt(kvec_val).
      move => ->;rewrite /nttunpackv /= tP => ii iib.
      rewrite !initiE //=.
      case(0 <= ii && ii < 256).
      + by move => kb;rewrite -H3 1:/# initiE //= initiE /#.
      case(256 <= ii && ii < 512).
      + by  move => ?kb;rewrite -H3 1:/# initiE 1:/# //= initiE /#.
      by  move => ?kb;rewrite -H3 1:/# initiE 1:/# //= initiE /#.
  move => *.
  exlim matrix, i, j => _m _i _j.
  wp;call(nttunpack_corr ((init (fun (i_0 : int) => _m.[_i * (3 * 256) + _j * 256 + i_0]))%Array256)).
  auto => /> ?? H H0 H1 H2 H3 H4 ?;do split; 1,2,7..:smt(kvec_val). 
  + move => ii??. 
    rewrite  tP => kk kkb.
    have -> : (subarray768
   ((init
       (fun (i_0 : int) =>
          if _i * 768 + _j * 256 <= i_0 && i_0 < _i * 768 + _j * 256 + 256 then
            (nttunpack ((init (fun (i_0_0 : int) => _m.[_i * 768 + _j * 256 + i_0_0])))%Array256).[
            i_0 - (_i * 768 + _j * 256)]
          else _m.[i_0])))%Array2304 ii) =
          subarray768 _m ii; last by smt(kvec_val).
     by rewrite tP => jj jjb; rewrite !initiE //= initiE 1:/# /= ifF 1:/#.  
 + move => ii iibl iibh.    
    have -> : (subarray768
   ((init
       (fun (i_0 : int) =>
          if _i * 768 + _j * 256 <= i_0 && i_0 < _i * 768 + _j * 256 + 256 then
            (nttunpack ((init (fun (i_0_0 : int) => _m.[_i * 768 + _j * 256 + i_0_0])))%Array256).[
            i_0 - (_i * 768 + _j * 256)]
          else _m.[i_0])))%Array2304 ii) =
          subarray768 _m ii; last by smt(kvec_val).
     by rewrite tP => jj jjb; rewrite !initiE //= initiE 1:/# /= ifF 1:/#.  
 + move => ii iibl iibh.
   case (ii = _j); last first.  
   + move => iibb;rewrite -H3 1:/#.
     rewrite /subarray256 /subarray768 tP => *.
     by rewrite !initiE 1,2:/# /= !initiE 1:/# /= 1:/# initiE /#.
   move => ->. 
   rewrite /subarray256 /subarray768  tP => *.
   rewrite initiE /= 1:/# initiE 1:/# /= initiE 1:/# /= ifT 1:/#;congr;2:smt(kvec_val).
   congr;rewrite tP => i0 i0b; rewrite !initiE 1,2:/# /= initiE 1:/# /=.
   move : (H4 _j _); 1:smt(kvec_val).
   rewrite tP => H4u. 
   move : (H4u i0 _);1:smt(kvec_val).
   do 6!(rewrite initiE 1:/# /=).
   by smt(kvec_val).

 + move => ii iibl iibh.
   rewrite -H4 1:/#.
   rewrite /subarray256 /subarray768  tP => *.
   by rewrite initiE 1:/# /= initiE 1:/# /= initiE 1:/# /= initiE 1:/# initiE 1:/# /= ifF /#. 

wp 14.
conseq (_:  (forall kk, 0 <= kk < 3 =>  subarray768 matrix kk = (subarray768 (unlift_matrix (if b then trmx (sampleA _sd) else (sampleA _sd))) kk))).
move =>/> m0 H; split;1:smt(kvec_val).
case b => hb.
+ move => i1 m1 *; split;1: smt(kvec_val). 
  move => ???H0 H1. 
  rewrite /nttunpackm tP => k kb; rewrite !initiE //=.
  case (0 <= k && k < 768).
  + by move => kbb;rewrite -H0 1:/# /subarray768 initiE 1:/# /=.  
  case (768 <= k && k < 1536).
  + by move =>? kbb;rewrite -H0 1:/# /subarray768 initiE 1:/# /=.  
  by move =>? kbb;rewrite -H0 1:/# /subarray768 initiE 1:/# /=.
move => i1 m1 *; split;1: smt(kvec_val). 
move => ???H0 H1. 
rewrite /nttunpackm tP => k kb; rewrite !initiE //=.
case (0 <= k && k < 768).
+ by move => kbb;rewrite -H0 1:/# /subarray768 initiE 1:/# /=.  
case (768 <= k && k < 1536).
+ by move =>? kbb;rewrite -H0 1:/# /subarray768 initiE 1:/# /=.  
by move =>? kbb;rewrite -H0 1:/# /subarray768 initiE 1:/# /=.

unroll for 7.
wp;call (sample_last _sd). 
wp;call (sample_four _sd 4 b _).
wp;call (sample_four _sd 0 b _).

auto => /> &hr a -> a0 -> a1 -> row ??.
congr; rewrite tP => kk ?.
pose xx := (unlift_matrix (if b then trmx (sampleA _sd) else sampleA _sd)).[kk].
rewrite initiE 1:/# /=.
case (2048 <= kk && kk < 2304).
+ move => lastpos;rewrite /subarray256 /subarray768 initiE 1:/# /= initiE 1:/# /=.
  rewrite /xx;  case (!(b = true)); 1: by smt(kvec_val).
  move => /= ->;rewrite /unlift_matrix !initiE 1,2:/# /=;congr;congr.
  have kv := kvec_val.
  by rewrite trmxE 1,2:/# /= /#.

move => notlast.
rewrite initiE 1:/# /=.
case (1024 <= kk && kk < 2048).
+ by move => middlepos;rewrite /subarray1024 initiE /#.
move => *;rewrite initiE 1:/# /=.
by rewrite /subarray1024 initiE /#.
qed.
