require import AllCore List IntDiv RealExp.
from Jasmin require import JModel_x86.
from Spec require import GFq Rq Parameters MLDSA_W32_Rep.
require import ArrayExtra.
require import JWord_extra EclibExtra JWordList.
require import Array256.
require BaseT PreludeT.

(* The encoding of the commitment w1, on w1_bits bits per coefficient.
   The code for a polynomial depends on gamma2 (bits4 or bits6 variant) and
   works on the encoding array of each set: its correctness is a hypothesis
   of this theory, proved for each set. *)
abstract theory CommitmentT.

clone import BaseT.BaseT as B.
import S R MLDSAParams.
clone import PreludeT.PreludeT as PR with theory B <= B.

import BitEncoding BitChunking.
import Round ZModQ Zq.
import Array_kpolys Array_w1vec_enc Array_w1_enc.
import VecMat PolyKVec.

(* the coefficients of w1 are in [0, hb_range) *)
axiom commitment_encode_polynomial (_a : W32.t Array256.t) :
   hoare [ M.commitment____encode_polynomial :
       commitment = _a /\ wpoly_urng hb_range _a
     ==>
       to_list res = SimpleBitPack (liftu_wpoly _a) (hb_range - 1) ].

axiom commitment____encode_polynomial_ll : islossless M.commitment____encode_polynomial.

(* the size of a polynomial encoding, as the code computes it *)
lemma w1_encE : w1_bits * n %/ 8 = w1_enc.
proof. by rewrite /w1_enc; smt(). qed.

lemma commitment_encode _a :
    hoare [ M.commitment____encode :
       commitment = _a /\ wpolykvec_urng (kvec_unflatten256 _a) hb_range
     ==>
       w1_unflatten res =
           KArray.map (fun (p : poly) => Array_w1_enc.of_list witness (SimpleBitPack p (hb_range - 1))) (liftu_wpolykvec (kvec_unflatten256 _a))
   ].
proc => /=.
while (0 <= i <= kvec /\ commitment = _a /\
       wpolykvec_urng (kvec_unflatten256 _a) hb_range  /\
       forall k, 0 <= k < i =>
       (w1_unflatten encoded_commitment).[k] =
       (map (fun (p : poly) => Array_w1_enc.of_list witness (SimpleBitPack p (hb_range - 1))) (liftu_wpolykvec (kvec_unflatten256 _a))).[k]);
       last first.
+ auto => /> &hr *; do split; 1,2: smt(gt0_k).
  by move => r0 j0 *; rewrite tP => k kb; smt().
wp; ecall (commitment_encode_polynomial (Array256.init (fun (i_0 : int) => _a.[i * 256 + i_0]))).
auto => /> &hr ?? Hrng H ?;do split.
+ move : Hrng; rewrite /wpolykvec_urng /wpoly_urng !allP /=  => Hrng ii iib.
  have := Hrng i{hr} _; 1:smt().
  rewrite allP /= initiE 1:/# /= => Hrngj.
  have := Hrngj ii _; 1:smt().
  rewrite initiE 1:/# /= initiE 1:/# /= nth_sub 1:/# /#.
move => ? rr Hrr; rewrite !w1_encE; do split;1,2: smt().
move => k kbl kbh.
case(0<=k<i{hr}) => *.
+ have -> : (w1_unflatten
   (Array_w1vec_enc.init
      (fun (i_0 : int) => if i{hr} * w1_enc <= i_0 < i{hr} * w1_enc + w1_enc
                          then rr.[i_0 - i{hr} * w1_enc] else encoded_commitment{hr}.[i_0]))).[k] =
    ((w1_unflatten encoded_commitment{hr})).[k]; last by smt().
  rewrite !initiE 1..2:/# /= /of_list /= tP => kk kkb.
  have hg := gt0_w1_enc; rewrite !initiE 1,2:// !nth_sub 1,2:// initiE /=; 1: smt(mulzDl).
  have : w1_enc * (k + 1) <= w1_enc * i{hr}.
  + by apply StdOrder.IntOrder.ler_wpmul2l; smt().
  by move=> h; rewrite ifF //; smt().
have -> : k = i{hr} by smt().
have hg := gt0_w1_enc.
have -> :
   (w1_unflatten
   (Array_w1vec_enc.init
      (fun (i_0 : int) => if i{hr} * w1_enc <= i_0 < i{hr} * w1_enc + w1_enc
                          then rr.[i_0 - i{hr} * w1_enc] else encoded_commitment{hr}.[i_0]))).[i{hr}] =
    (rr); last first.
+ have <- := Array_w1_enc.to_listK witness rr;rewrite Hrr mapiE 1:/# /=;congr;congr.
  rewrite /liftu_wpolykvec mapiE 1:/#;congr;rewrite initiE 1:/# /=.
  rewrite tP => kk kkb; rewrite !initiE 1,2:/# /= nth_sub /#.
rewrite initiE 1:/# /= tP => ii iib.
rewrite initiE 1:// /= nth_sub 1:// initiE /=.
+ have : w1_enc * (i{hr} + 1) <= w1_enc * kvec.
  + by apply StdOrder.IntOrder.ler_wpmul2l; smt().
  smt().
smt().
qed.





lemma commitment____encode_ll : islossless  M.commitment____encode.
proof.
proc; while (0 <= i <= kvec) (kvec - i); 2: by auto; smt(gt0_k).
by move=> z; wp; call commitment____encode_polynomial_ll; auto => /#.
qed.

lemma commitment_encode_ph _a :
    phoare [ M.commitment____encode :
       commitment = _a /\ wpolykvec_urng (kvec_unflatten256 _a) hb_range
     ==>
       w1_unflatten res =
           KArray.map (fun (p : poly) => Array_w1_enc.of_list witness (SimpleBitPack p (hb_range - 1))) (liftu_wpolykvec (kvec_unflatten256 _a))
   ] = 1%r by conseq commitment____encode_ll (commitment_encode _a).

end CommitmentT.
