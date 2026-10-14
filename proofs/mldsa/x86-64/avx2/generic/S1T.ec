require import AllCore List IntDiv RealExp.
from Jasmin require import JModel_x86.
require import CircuitBindings Bindings.
from Spec require import GFq Rq Parameters MLDSA_W32_Rep.
require import ArrayExtra.
require import JWord_extra EclibExtra JWordList.
require import Array256.
require BaseT PreludeT ErrorPolynomialT.

abstract theory S1T.

clone import BaseT.BaseT as B.
import S R MLDSAParams.
clone import PreludeT.PreludeT as PR with theory B <= B.
clone import ErrorPolynomialT.ErrorPolynomialT as EP with theory B <= B.

import BitEncoding BitChunking.

import Round ZModQ Zq.




import VecMat PolyLVec.
import Array_lpolys Array_s1_enc Array_eta_enc.

op valid_s1_bytes (a : W8.t Array_s1_enc.t) =
    forall k, 0 <= k < lvec =>
    valid_eta_bytes (Array_eta_enc.init (fun i => a.[k * eta_enc + i])).

lemma s1_encode _a :
    hoare [ M.s1____encode :
       s1 = _a /\ wpolylvec_srng (lvec_unflatten256 _a) Eta Eta
     ==>
       s1_unflatten res =
           LArray.map (fun (p : poly) => Array_eta_enc.of_list witness (BitPack p Eta Eta)) (lifts_wpolylvec (lvec_unflatten256 _a))
       /\ valid_s1_bytes res
   ].
proc => /=.
while (0 <= i <= lvec /\ s1 = _a /\ wpolylvec_srng (lvec_unflatten256 _a) Eta Eta  /\
       (forall k, 0 <= k < i =>
       (s1_unflatten encoded).[k] =
       (map (fun (p : poly) => Array_eta_enc.of_list witness (BitPack p Eta Eta)) (lifts_wpolylvec (lvec_unflatten256 _a))).[k]) /\
       (forall k, 0 <= k < i =>
       valid_eta_bytes (Array_eta_enc.init (fun j => encoded.[k * eta_enc + j]))));
       last first.
+ auto => /> &hr *; do split; 1..3: smt(gt0_l).
  move => r0 j0 ??? H H1; split.
  + rewrite tP => kk Hkk.
    by rewrite mapiE 1:/# /= H 1:/# mapiE 1:/# /=.
  by rewrite /valid_s1_bytes => i ib; apply H1; smt().
wp; ecall (error_polynomial_encode (Array256.init (fun (i_0 : int) => _a.[i * 256 + i_0]))).
auto => /> &hr ?? Hrng H Hval ?;  do split;1:smt().  
+ move : Hrng; rewrite /wpolylvec_srng /wpoly_srng !allP /=  => Hrng ii iib.
  have := Hrng i{hr} _; 1:smt().
  rewrite allP /= initiE 1:/# /= => Hrngj.
  have := Hrngj ii _; 1:smt().
  by rewrite initiE 1:/# /= initiE 1:/# /= nth_sub 1:/# /#.
  
move => ?? rr Hrr Hval_rr; do split; 1,2: smt().
move => k kbl kbh.
case(0<=k<i{hr}) => *.
+
   have -> : (s1_unflatten
   (Array_s1_enc.init
      (fun (i_0 : int) => if eta_enc * i{hr} <= i_0 < eta_enc * i{hr} + eta_enc then rr.[i_0 - eta_enc * i{hr}] else encoded{hr}.[i_0]))).[k] =
    ((s1_unflatten encoded{hr})).[k]; last by smt().
  rewrite !initiE 1..2:/# /= /of_list /= tP => kk kkb.
  rewrite !initiE 1,2:/# !nth_sub 1,2:/# initiE 1:/# /= /#.
have -> : k = i{hr} by smt().
+ have -> :
   (s1_unflatten
   (Array_s1_enc.init
      (fun (i_0 : int) => if eta_enc * i{hr} <= i_0 < eta_enc * i{hr} + eta_enc then rr.[i_0 - eta_enc * i{hr}] else encoded{hr}.[i_0]))).[i{hr}]  =
    (rr); last first.
  + have <- := Array_eta_enc.to_listK witness rr;rewrite Hrr mapiE 1:/# /=;congr;congr.
    rewrite /lifts_wpolylvec mapiE 1:/#;congr;rewrite initiE 1:/# /=.
    rewrite tP => kk kkb; rewrite !initiE 1,2:/# /= nth_sub /#.

rewrite initiE 1:/# /= tP => ii iib.
rewrite  initiE 1:/# /= nth_sub 1:/# initiE 1:/# /= /#.
move => k kbl kbh.
case(0<=k<i{hr}) =>? .
+ have -> : valid_eta_bytes
    (Array_eta_enc.init (fun j =>
      (Array_s1_enc.init (fun (i_0 : int) =>
        if eta_enc * i{hr} <= i_0 < eta_enc * i{hr} + eta_enc
        then rr.[i_0 - eta_enc * i{hr}]
        else encoded{hr}.[i_0])).[k * eta_enc + j])) =
    valid_eta_bytes (Array_eta_enc.init (fun j => encoded{hr}.[k * eta_enc + j])); last by apply Hval ; smt().
  by congr; rewrite tP => j jb;  rewrite !initiE 1,2:/# /= initiE 1:/# /= /#.
have -> : k = i{hr} by smt().
have -> : Array_eta_enc.init (fun j =>
    (Array_s1_enc.init (fun (i_0 : int) =>
      if eta_enc * i{hr} <= i_0 < eta_enc * i{hr} + eta_enc
      then rr.[i_0 - eta_enc * i{hr}]
      else encoded{hr}.[i_0])).[i{hr} * eta_enc + j]) = rr.
+ rewrite tP => j jb; rewrite !initiE 1:/# /= initiE 1:/# /= /#.
by exact Hval_rr.
qed.


lemma s1_encode_ll : islossless M.s1____encode.
proof.
proc; while (0 <= i <= lvec) (lvec - i); 2: by auto; smt(gt0_l).
by move=> z; wp; call error_polynomial_encode_ll; auto => /#.
qed.

lemma s1_encode_ph _a :
    phoare [  M.s1____encode :
       s1 = _a /\ wpolylvec_srng (lvec_unflatten256 _a) Eta Eta
     ==>
       s1_unflatten res =
           LArray.map (fun (p : poly) => Array_eta_enc.of_list witness (BitPack p Eta Eta)) (lifts_wpolylvec (lvec_unflatten256 _a))
       /\ valid_s1_bytes res
   ] = 1%r by conseq s1_encode_ll (s1_encode _a).



lemma s1_decode _a :
    hoare [ M.s1____decode :
       encoded = _a
       /\ valid_s1_bytes _a
     ==>
       lifts_wpolylvec (lvec_unflatten256 res) =
           LArray.map (fun (bytes : W8.t Array_eta_enc.t) => BitUnpack (to_list bytes) Eta Eta) (s1_unflatten _a)
       /\ wpolylvec_srng (lvec_unflatten256 res) Eta Eta
   ].
proc => /=.
while (0 <= i <= lvec /\ encoded = _a /\ valid_s1_bytes _a /\
       forall k, 0 <= k < i =>
       (lifts_wpolylvec (lvec_unflatten256 s1)).[k] =
       (map (fun (bytes : W8.t Array_eta_enc.t) => BitUnpack (to_list bytes) Eta Eta) (s1_unflatten _a)).[k]
       /\ wpoly_srng Eta Eta (lvec_unflatten256 s1).[k]);
       last first.
+ auto => /> &hr *; do split; 1,2: smt(gt0_l).
  move => r0 j0 ??? H; split.
  + by rewrite tP => k Hk;have := H k _;smt().
  by rewrite /wpolylvec_srng allP => k kb;have := H k _;smt().
         
wp; ecall (error_polynomial_decode (Array_eta_enc.init (fun (i_0 : int) => _a.[i * eta_enc + i_0]))).
auto => /> &hr ?? Hvalid H ?; do split; 1: smt().
+ by have := (Hvalid i{hr} _); 1: smt().
move => H0 H1 rr  Hrr Hrng; do split; 1,2: smt().
move => k kbl kbh.
case(0<=k<i{hr}) => *.
+ have := H k _;1:smt().
  move => [H00 H10].
  split.
  + have -> : (lifts_wpolylvec
     (lvec_unflatten256
        (Array_lpolys.init
           (fun (i_0 : int) => if i{hr} * n <= i_0 < i{hr} * n + n then rr.[i_0 - i{hr} * n] else s1{hr}.[i_0])))).[k] =
      (lifts_wpolylvec (lvec_unflatten256 s1{hr})).[k]; last by smt().
    rewrite !mapiE 1..2:/# initiE 1:/# /= initiE 1:/# /= tP =>  ii iib.
    rewrite mapiE 1:/# /= initiE 1:/# /= mapiE 1:/# /= initiE 1:/# /= !nth_sub 1,2:/# initiE 1:/# /= /#.
  + have -> : (lvec_unflatten256
      (Array_lpolys.init
         (fun (i_0 : int) => if i{hr} * n <= i_0 < i{hr} * n + n then rr.[i_0 - i{hr} * n] else s1{hr}.[i_0]))).[k] =
      (lvec_unflatten256 s1{hr}).[k]; last by smt().
    by rewrite initiE 1:/# /= tP => ii iib; rewrite initiE 1:/# /= !get_of_list 1,2:/# /= !nth_sub 1,2:/# /= initiE 1:/# /= /#.
have -> : k = i{hr} by smt().
+ split.
  + have -> : (lifts_wpolylvec
     (lvec_unflatten256
        (Array_lpolys.init
           (fun (i_0 : int) => if i{hr} * n <= i_0 < i{hr} * n + n then rr.[i_0 - i{hr} * n] else s1{hr}.[i_0])))).[i{hr}]  =
      (lifts_wpoly rr); last first.
    + rewrite Hrr mapiE 1:/# /=;congr;congr;rewrite initiE 1:/# /= tP => ii iib.
      by rewrite initiE 1:/# get_of_list 1:/# /= nth_sub /#.
    rewrite mapiE 1:/# /= initiE 1:/# /= tP => ii iib.
    rewrite !mapiE 1,2:/# /= initiE 1:/# /= nth_sub 1:/# initiE 1:/# /= /#.
  + have -> : (lvec_unflatten256
      (Array_lpolys.init
         (fun (i_0 : int) => if i{hr} * n <= i_0 < i{hr} * n + n then rr.[i_0 - i{hr} * n] else s1{hr}.[i_0]))).[i{hr}] = rr.
    + rewrite initiE 1:/# /= tP => ii iib; rewrite initiE 1:/# /= nth_sub 1:/# initiE 1:/# /= /#.
    by exact Hrng.
qed.


lemma s1_decode_ll : islossless M.s1____decode.
proof.
proc; while (0 <= i <= lvec) (lvec - i); 2: by auto; smt(gt0_l).
by move=> z; wp; call error_polynomial_decode_ll; auto => /#.
qed.

lemma s1_decode_ph _a :
    phoare [ M.s1____decode :
       encoded = _a
       /\ valid_s1_bytes _a
     ==>
       lifts_wpolylvec (lvec_unflatten256 res) =
           LArray.map (fun (bytes : W8.t Array_eta_enc.t) => BitUnpack (to_list bytes) Eta Eta) (s1_unflatten _a)
       /\ wpolylvec_srng (lvec_unflatten256 res) Eta Eta
   ] = 1%r by conseq s1_decode_ll (s1_decode _a).

end S1T.
