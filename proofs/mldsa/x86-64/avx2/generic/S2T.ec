require import AllCore List IntDiv RealExp.
from Jasmin require import JModel_x86.
require import CircuitBindings Bindings.
from Spec require import GFq Rq Parameters MLDSA_W32_Rep.
require import ArrayExtra.
require import JWord_extra EclibExtra JWordList.
require import Array256.
require BaseT PreludeT ErrorPolynomialT.

abstract theory S2T.

clone import BaseT.BaseT as B.
import S R MLDSAParams.
clone import PreludeT.PreludeT as PR with theory B <= B.
clone import ErrorPolynomialT.ErrorPolynomialT as EP with theory B <= B.

import BitEncoding BitChunking.

import Round ZModQ Zq.




import VecMat PolyKVec.
import Array_kpolys Array_s2_enc Array_eta_enc.

op valid_s2_bytes (a : W8.t Array_s2_enc.t) =
    forall k, 0 <= k < kvec =>
    valid_eta_bytes (Array_eta_enc.init (fun i => a.[k * eta_enc + i])).

lemma s2_encode _a :
    hoare [ M.s2____encode :
       s2 = _a /\ wpolykvec_srng (kvec_unflatten256 _a) Eta Eta
     ==>
       s2_unflatten res =
           KArray.map (fun (p : poly) => Array_eta_enc.of_list witness (BitPack p Eta Eta)) (lifts_wpolykvec (kvec_unflatten256 _a))
       /\ valid_s2_bytes res
   ].
proc => /=.
while (0 <= i <= kvec /\ s2 = _a /\ wpolykvec_srng (kvec_unflatten256 _a) Eta Eta  /\
       (forall k, 0 <= k < i =>
       (s2_unflatten encoded).[k] =
       (map (fun (p : poly) => Array_eta_enc.of_list witness (BitPack p Eta Eta)) (lifts_wpolykvec (kvec_unflatten256 _a))).[k]) /\
       (forall k, 0 <= k < i =>
       valid_eta_bytes (Array_eta_enc.init (fun j => encoded.[k * eta_enc + j]))));
       last first.
+ auto => /> &hr *; do split; 1..3: smt(gt0_k).
  move => r0 j0 ??? H H1; split.
  + rewrite tP => kk Hkk.
    by rewrite mapiE 1:/# /= H 1:/# mapiE 1:/# /=.
  by rewrite /valid_s2_bytes => i ib; apply H1; smt().
wp; ecall (error_polynomial_encode (Array256.init (fun (i_0 : int) => _a.[i * 256 + i_0]))).
auto => /> &hr ?? Hrng H Hval ?;  do split;1:smt().  
+ move : Hrng; rewrite /wpolykvec_srng /wpoly_srng !allP /=  => Hrng ii iib.
  have := Hrng i{hr} _; 1:smt().
  rewrite allP /= initiE 1:/# /= => Hrngj.
  have := Hrngj ii _; 1:smt().
  by rewrite initiE 1:/# /= initiE 1:/# /= nth_sub 1:/# /#.
  
move => ?? rr Hrr Hval_rr; do split; 1,2: smt().
move => k kbl kbh.
case(0<=k<i{hr}) => *.
+
   have -> : (s2_unflatten
   (Array_s2_enc.init
      (fun (i_0 : int) => if eta_enc * i{hr} <= i_0 < eta_enc * i{hr} + eta_enc then rr.[i_0 - eta_enc * i{hr}] else encoded{hr}.[i_0]))).[k] =
    ((s2_unflatten encoded{hr})).[k]; last by smt().
  rewrite !initiE 1..2:/# /= /of_list /= tP => kk kkb.
  rewrite !initiE 1,2:/# !nth_sub 1,2:/# initiE 1:/# /= /#.
have -> : k = i{hr} by smt().
+ have -> :
   (s2_unflatten
   (Array_s2_enc.init
      (fun (i_0 : int) => if eta_enc * i{hr} <= i_0 < eta_enc * i{hr} + eta_enc then rr.[i_0 - eta_enc * i{hr}] else encoded{hr}.[i_0]))).[i{hr}]  =
    (rr); last first.
  + have <- := Array_eta_enc.to_listK witness rr;rewrite Hrr mapiE 1:/# /=;congr;congr.
    rewrite /lifts_wpolykvec mapiE 1:/#;congr;rewrite initiE 1:/# /=.
    rewrite tP => kk kkb; rewrite !initiE 1,2:/# /= nth_sub /#.

rewrite initiE 1:/# /= tP => ii iib.
rewrite  initiE 1:/# /= nth_sub 1:/# initiE 1:/# /= /#.
move => k kbl kbh.
case(0<=k<i{hr}) =>? .
+ have -> : valid_eta_bytes
    (Array_eta_enc.init (fun j =>
      (Array_s2_enc.init (fun (i_0 : int) =>
        if eta_enc * i{hr} <= i_0 < eta_enc * i{hr} + eta_enc
        then rr.[i_0 - eta_enc * i{hr}]
        else encoded{hr}.[i_0])).[k * eta_enc + j])) =
    valid_eta_bytes (Array_eta_enc.init (fun j => encoded{hr}.[k * eta_enc + j])); last by apply Hval ; smt().
  by congr; rewrite tP => j jb;  rewrite !initiE 1,2:/# /= initiE 1:/# /= /#.
have -> : k = i{hr} by smt().
have -> : Array_eta_enc.init (fun j =>
    (Array_s2_enc.init (fun (i_0 : int) =>
      if eta_enc * i{hr} <= i_0 < eta_enc * i{hr} + eta_enc
      then rr.[i_0 - eta_enc * i{hr}]
      else encoded{hr}.[i_0])).[i{hr} * eta_enc + j]) = rr.
+ rewrite tP => j jb; rewrite !initiE 1:/# /= initiE 1:/# /= /#.
by exact Hval_rr.
qed.


lemma s2_encode_ll : islossless M.s2____encode.
proof.
proc; while (0 <= i <= kvec) (kvec - i); 2: by auto; smt(gt0_k).
by move=> z; wp; call error_polynomial_encode_ll; auto => /#.
qed.

lemma s2_encode_ph _a :
    phoare [  M.s2____encode :
       s2 = _a /\ wpolykvec_srng (kvec_unflatten256 _a) Eta Eta
     ==>
       s2_unflatten res =
           KArray.map (fun (p : poly) => Array_eta_enc.of_list witness (BitPack p Eta Eta)) (lifts_wpolykvec (kvec_unflatten256 _a))
       /\ valid_s2_bytes res
   ] = 1%r by conseq s2_encode_ll (s2_encode _a).



lemma s2_decode _a :
    hoare [ M.s2____decode :
       encoded = _a
       /\ valid_s2_bytes _a
     ==>
       lifts_wpolykvec (kvec_unflatten256 res) =
           KArray.map (fun (bytes : W8.t Array_eta_enc.t) => BitUnpack (to_list bytes) Eta Eta) (s2_unflatten _a)
       /\ wpolykvec_srng (kvec_unflatten256 res) Eta Eta
   ].
proc => /=.
while (0 <= i <= kvec /\ encoded = _a /\ valid_s2_bytes _a /\
       forall k, 0 <= k < i =>
       (lifts_wpolykvec (kvec_unflatten256 s2)).[k] =
       (map (fun (bytes : W8.t Array_eta_enc.t) => BitUnpack (to_list bytes) Eta Eta) (s2_unflatten _a)).[k]
       /\ wpoly_srng Eta Eta (kvec_unflatten256 s2).[k]);
       last first.
+ auto => /> &hr *; do split; 1,2: smt(gt0_k).
  move => r0 j0 ??? H; split.
  + by rewrite tP => k Hk;have := H k _;smt().
  by rewrite /wpolykvec_srng allP => k kb;have := H k _;smt().
         
wp; ecall (error_polynomial_decode (Array_eta_enc.init (fun (i_0 : int) => _a.[i * eta_enc + i_0]))).
auto => /> &hr ?? Hvalid H ?; do split; 1: smt().
+ by have := (Hvalid i{hr} _); 1: smt().
move => H0 H1 rr  Hrr Hrng; do split; 1,2: smt().
move => k kbl kbh.
case(0<=k<i{hr}) => *.
+ have := H k _;1:smt().
  move => [H00 H10].
  split.
  + have -> : (lifts_wpolykvec
     (kvec_unflatten256
        (Array_kpolys.init
           (fun (i_0 : int) => if i{hr} * n <= i_0 < i{hr} * n + n then rr.[i_0 - i{hr} * n] else s2{hr}.[i_0])))).[k] =
      (lifts_wpolykvec (kvec_unflatten256 s2{hr})).[k]; last by smt().
    rewrite !mapiE 1..2:/# initiE 1:/# /= initiE 1:/# /= tP =>  ii iib.
    rewrite mapiE 1:/# /= initiE 1:/# /= mapiE 1:/# /= initiE 1:/# /= !nth_sub 1,2:/# initiE 1:/# /= /#.
  + have -> : (kvec_unflatten256
      (Array_kpolys.init
         (fun (i_0 : int) => if i{hr} * n <= i_0 < i{hr} * n + n then rr.[i_0 - i{hr} * n] else s2{hr}.[i_0]))).[k] =
      (kvec_unflatten256 s2{hr}).[k]; last by smt().
    by rewrite initiE 1:/# /= tP => ii iib; rewrite initiE 1:/# /= !get_of_list 1,2:/# /= !nth_sub 1,2:/# /= initiE 1:/# /= /#.
have -> : k = i{hr} by smt().
+ split.
  + have -> : (lifts_wpolykvec
     (kvec_unflatten256
        (Array_kpolys.init
           (fun (i_0 : int) => if i{hr} * n <= i_0 < i{hr} * n + n then rr.[i_0 - i{hr} * n] else s2{hr}.[i_0])))).[i{hr}]  =
      (lifts_wpoly rr); last first.
    + rewrite Hrr mapiE 1:/# /=;congr;congr;rewrite initiE 1:/# /= tP => ii iib.
      by rewrite initiE 1:/# get_of_list 1:/# /= nth_sub /#.
    rewrite mapiE 1:/# /= initiE 1:/# /= tP => ii iib.
    rewrite !mapiE 1,2:/# /= initiE 1:/# /= nth_sub 1:/# initiE 1:/# /= /#.
  + have -> : (kvec_unflatten256
      (Array_kpolys.init
         (fun (i_0 : int) => if i{hr} * n <= i_0 < i{hr} * n + n then rr.[i_0 - i{hr} * n] else s2{hr}.[i_0]))).[i{hr}] = rr.
    + rewrite initiE 1:/# /= tP => ii iib; rewrite initiE 1:/# /= nth_sub 1:/# initiE 1:/# /= /#.
    by exact Hrng.
qed.


lemma s2_decode_ll : islossless M.s2____decode.
proof.
proc; while (0 <= i <= kvec) (kvec - i); 2: by auto; smt(gt0_k).
by move=> z; wp; call error_polynomial_decode_ll; auto => /#.
qed.

lemma s2_decode_ph _a :
    phoare [ M.s2____decode :
       encoded = _a
       /\ valid_s2_bytes _a
     ==>
       lifts_wpolykvec (kvec_unflatten256 res) =
           KArray.map (fun (bytes : W8.t Array_eta_enc.t) => BitUnpack (to_list bytes) Eta Eta) (s2_unflatten _a)
       /\ wpolykvec_srng (kvec_unflatten256 res) Eta Eta
   ] = 1%r by conseq s2_decode_ll (s2_decode _a).

end S2T.
