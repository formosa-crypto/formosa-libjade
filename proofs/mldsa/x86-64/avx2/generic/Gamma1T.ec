require import AllCore List IntDiv RealExp.
from Jasmin require import JModel_x86.
from Spec require import GFq Rq Parameters MLDSA_W32_Rep.
require import ArrayExtra.
require import JWord_extra EclibExtra JWordList.
require import Array256.
require BaseT PreludeT.

(* The gamma1 encoding of the signer response z. The code for a polynomial
   depends on gamma1 (bits20 or bits18 variant) and works on the encoding
   array of each set: its correctness is a hypothesis of this theory, proved
   for each set. *)
abstract theory Gamma1T.

clone import BaseT.BaseT as B.
import S R MLDSAParams.
clone import PreludeT.PreludeT as PR with theory B <- B.

import BitEncoding BitChunking.
import Round ZModQ Zq.
import Array_lpolys Array_z_enc Array_gamma1_enc.

axiom gamma1_encode_polynomial (_a : W32.t Array256.t) :
   hoare [ M.gamma1____encode_polynomial :
       polynomial = _a /\ wpoly_srng (gamma1 - 1) gamma1 _a
     ==>
       to_list res = BitPack (lifts_wpoly _a) (gamma1 - 1) gamma1 ].

axiom gamma1_decode_to_polynomial (_a : W8.t Array_gamma1_enc.t) :
   hoare [ M.gamma1____decode_to_polynomial :
       bytes = _a
     ==>
       lifts_wpoly res = BitUnpack (to_list _a) (gamma1 - 1) gamma1 /\
       wpoly_srng (gamma1 - 1) gamma1 res ].

axiom gamma1_encode_polynomial_ll : islossless M.gamma1____encode_polynomial.
axiom gamma1_decode_to_polynomial_ll : islossless M.gamma1____decode_to_polynomial.

import VecMat PolyLVec.

(* the size of a polynomial encoding, as the code computes it *)
lemma gamma1_encE : gamma1_bits * n %/ 8 = gamma1_enc.
proof. by rewrite /gamma1_enc; smt(). qed.


lemma gamma1_encode _a :
    hoare [ M.gamma1____encode :
       decoded = _a /\ wpolylvec_srng (lvec_unflatten256 _a) (gamma1-1) gamma1
     ==>
       z_unflatten res =
           LArray.map (fun (p : poly) => Array_gamma1_enc.of_list witness (BitPack p (gamma1-1) gamma1)) (lifts_wpolylvec (lvec_unflatten256 _a))
   ].
proc => /=.
while (0 <= i <= lvec /\ decoded = _a /\
       wpolylvec_srng (lvec_unflatten256 _a) (gamma1-1) gamma1  /\
       forall k, 0 <= k < i =>
       (z_unflatten encoded).[k] =
       (map (fun (p : poly) => Array_gamma1_enc.of_list witness (BitPack p (gamma1-1) gamma1)) (lifts_wpolylvec (lvec_unflatten256 _a))).[k]);
       last first.
+ auto => /> &hr *; do split; 1,2: smt(gt0_l).
  by move => r0 j0 *; rewrite tP => k kb; smt().
wp; ecall (gamma1_encode_polynomial (Array256.init (fun (i_0 : int) => _a.[i * 256 + i_0]))).
auto => /> &hr ?? Hrng H ?;do split.
+ move : Hrng; rewrite /wpolylvec_srng /wpoly_srng !allP /=  => Hrng ii iib.
  have := Hrng i{hr} _; 1:smt().
  rewrite allP /= initiE 1:/# /= => Hrngj.
  have := Hrngj ii _; 1:smt().
  rewrite initiE 1:/# /= initiE 1:/# /= nth_sub 1:/# /#.
move => ? rr Hrr; rewrite !gamma1_encE; do split;1,2: smt().
move => k kbl kbh.
case(0<=k<i{hr}) => *.
+ have -> : (z_unflatten
   (Array_z_enc.init
      (fun (i_0 : int) => if i{hr} * gamma1_enc <= i_0 < i{hr} * gamma1_enc + gamma1_enc
                          then rr.[i_0 - i{hr} * gamma1_enc] else encoded{hr}.[i_0]))).[k] =
    ((z_unflatten encoded{hr})).[k]; last by smt().
  rewrite !initiE 1..2:/# /= /of_list /= tP => kk kkb.
  have hg := gt0_gamma1_enc; rewrite !initiE 1,2:// !nth_sub 1,2:// initiE /=; 1: smt(mulzDl).
  have : gamma1_enc * (k + 1) <= gamma1_enc * i{hr}.
  + by apply StdOrder.IntOrder.ler_wpmul2l; smt().
  by move=> h; rewrite ifF //; smt().
have -> : k = i{hr} by smt().
have hg := gt0_gamma1_enc.
have -> :
   (z_unflatten
   (Array_z_enc.init
      (fun (i_0 : int) => if i{hr} * gamma1_enc <= i_0 < i{hr} * gamma1_enc + gamma1_enc
                          then rr.[i_0 - i{hr} * gamma1_enc] else encoded{hr}.[i_0]))).[i{hr}] =
    (rr); last first.
+ have <- := Array_gamma1_enc.to_listK witness rr;rewrite Hrr mapiE 1:/# /=;congr;congr.
  rewrite /lifts_wpolylvec mapiE 1:/#;congr;rewrite initiE 1:/# /=.
  rewrite tP => kk kkb; rewrite !initiE 1,2:/# /= nth_sub /#.
rewrite initiE 1:/# /= tP => ii iib.
rewrite initiE 1:// /= nth_sub 1:// initiE /=.
+ have : gamma1_enc * (i{hr} + 1) <= gamma1_enc * lvec.
  + by apply StdOrder.IntOrder.ler_wpmul2l; smt().
  smt().
smt().
qed.





lemma gamma1_encode_ll : islossless  M.gamma1____encode.
proof.
proc; while (0 <= i <= lvec) (lvec - i); 2: by auto; smt(gt0_l).
by move=> z; wp; call gamma1_encode_polynomial_ll; auto => /#.
qed.

lemma gamma1_encode_ph _a :
    phoare [ M.gamma1____encode :
       decoded = _a /\ wpolylvec_srng (lvec_unflatten256 _a) (gamma1-1) gamma1
     ==>
       z_unflatten res =
           LArray.map (fun (p : poly) => Array_gamma1_enc.of_list witness (BitPack p (gamma1-1) gamma1)) (lifts_wpolylvec (lvec_unflatten256 _a))
   ] = 1%r by conseq gamma1_encode_ll (gamma1_encode _a).


lemma gamma1_decode _a :
    hoare [ M.gamma1____decode :
       encoded = _a
     ==>
       lifts_wpolylvec (lvec_unflatten256 res) =
           LArray.map (fun p => BitUnpack (to_list p) (gamma1-1) gamma1) (z_unflatten _a) /\
       wpolylvec_srng (lvec_unflatten256 res) (gamma1-1) gamma1
   ].
proc => /=.
while (0 <= i <= lvec /\ encoded = _a /\
       (forall k, 0 <= k < i =>
           (lifts_wpolylvec (lvec_unflatten256 decoded)).[k] =
           (map (fun (p : W8.t Array_gamma1_enc.t) => BitUnpack (to_list p) (gamma1 - 1) gamma1) (z_unflatten _a)).[k]) /\
       (forall k, 0 <= k < i =>
           wpoly_srng (gamma1-1) gamma1 (lvec_unflatten256 decoded).[k]));
       last first.
+ auto => /> &hr *; do split; 1..3: smt(gt0_l).
  move => r0 k ? r1 i0 Heq Hrng; split; 1: by rewrite tP => /#.
  rewrite /wpolylvec_srng allP => i ib.
  by apply Hrng; smt().
wp; ecall (gamma1_decode_to_polynomial (Array_gamma1_enc.init (fun (i_0 : int) => _a.[i * (gamma1_bits * n %/ 8) + i_0]))).
auto => /> &hr ?? Heq Hrng  ? rr Hrr1 Hrr2.
move: Hrr1; rewrite gamma1_encE => Hrr1; do split;1,2:smt().
+ move => k kbl kbh.
  case(0<=k<i{hr}) => *.
  + have -> : (lifts_wpolylvec
     (lvec_unflatten256
        (Array_lpolys.init
           (fun (i_0 : int) => if i{hr} * n <= i_0 < i{hr} * n + n then rr.[i_0 - i{hr} * n] else decoded{hr}.[i_0])))).[k] =
      (lifts_wpolylvec (lvec_unflatten256 decoded{hr})).[k]; last by smt().
    rewrite !mapiE 1..2:/# initiE 1:/# /= initiE 1:/# /= tP =>  ii iib.
    rewrite mapiE 1:/# /= initiE 1:/# /= mapiE 1:/# /= initiE 1:/# /= !nth_sub 1,2:/# initiE 1:/# /= /#.
  have -> : k = i{hr} by smt().
  + have -> : (lifts_wpolylvec
     (lvec_unflatten256
        (Array_lpolys.init
           (fun (i_0 : int) => if i{hr} * n <= i_0 < i{hr} * n + n then rr.[i_0 - i{hr} * n] else decoded{hr}.[i_0])))).[i{hr}]  =
      (lifts_wpoly rr); last first.
    + rewrite Hrr1 mapiE 1:/# /=;congr;congr;rewrite  initiE 1:/# /= tP => ii iib.
      have hg := gt0_gamma1_enc.
      have : gamma1_enc * (i{hr} + 1) <= gamma1_enc * lvec.
      + by apply StdOrder.IntOrder.ler_wpmul2l; smt().
      by move=> h; rewrite initiE 1:// get_of_list 1:// /= nth_sub //; smt().
  rewrite mapiE 1:/# /= initiE 1:/# /= tP => ii iib.
  rewrite !mapiE 1,2:/# /= initiE 1:/# /= nth_sub 1:/# initiE 1:/# /= /#.
move => k kbl kbh.
case(0<=k<i{hr}) => *.
+ have -> : (lvec_unflatten256
     (Array_lpolys.init
        (fun (i_0 : int) => if i{hr} * n <= i_0 < i{hr} * n + n then rr.[i_0 - i{hr} * n] else decoded{hr}.[i_0]))).[k] =
    (lvec_unflatten256 decoded{hr}).[k]; last by (apply Hrng; smt()).
  rewrite initiE 1:/# /= tP => ii iib.
  rewrite Array256.get_of_list 1:// /= nth_sub 1:/# initiE 1:/# /=.
  by rewrite /lvec_unflatten256 LArray.initiE 1:/# /= Array256.get_of_list 1:/# nth_sub /#.
have -> : k = i{hr} by smt().
have -> : (lvec_unflatten256
     (Array_lpolys.init
        (fun (i_0 : int) => if i{hr} * n <= i_0 < i{hr} * n + n then rr.[i_0 - i{hr} * n] else decoded{hr}.[i_0]))).[i{hr}] =
    rr.
+ rewrite initiE 1:/# /= tP => ii iib.
  rewrite initiE 1:/# /= nth_sub 1:/# initiE 1:/# /= /#.
exact Hrr2.
qed.





lemma gamma1_decode_ll : islossless  M.gamma1____decode.
proof.
proc; while (0 <= i <= lvec) (lvec - i); 2: by auto; smt(gt0_l).
by move=> z; wp; call gamma1_decode_to_polynomial_ll; auto => /#.
qed.


lemma gamma1_decode_ph _a :
    phoare [ M.gamma1____decode :
       encoded = _a
     ==>
       lifts_wpolylvec (lvec_unflatten256 res) =
           LArray.map (fun p => BitUnpack (to_list p) (gamma1-1) gamma1) (z_unflatten _a) /\
       wpolylvec_srng (lvec_unflatten256 res) (gamma1-1) gamma1
   ] = 1%r
 by conseq gamma1_decode_ll (gamma1_decode _a).

end Gamma1T.
