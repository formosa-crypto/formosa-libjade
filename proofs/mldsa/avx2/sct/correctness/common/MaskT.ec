require import AllCore CoreUtils List List_extra IntDiv StdOrder BitEncoding.
from Jasmin require import JWord JModel_x86.
from Spec require import GFq Rq Parameters MLDSA_W32_Rep.
from CryptoSpecs require import Keccak1600_Spec.
require import Array4 Array25 Array64 Array136 Array256 Array680.
require import Prefixarray.
require BaseT PreludeT Gamma1T Sha3x4.

(* -------------------------------------------------------------------- *)
(* The mask sampler (ExpandMask): each mask polynomial is the gamma1    *)
(* decoding of the first gamma1_enc bytes of its lane's SHAKE256 stream, *)
(* with no rejection. Four lanes are sampled SIMD-interleaved; the code  *)
(* completes l = 1 (mod 4) with the single-lane sponge, and l = 3        *)
(* (mod 4) with a second batch of four lanes, the last one discarded.   *)
(* The decoding is the one of Gamma1T, whose hypotheses are discharged  *)
(* per variant.                                                          *)
(* -------------------------------------------------------------------- *)
abstract theory MaskT.

clone import BaseT.BaseT as B.
import S R MLDSAParams.
clone import PreludeT.PreludeT as PR with theory B <- B.
clone import Gamma1T.Gamma1T as G1 with theory B <- B, theory PR <- PR.
clone import Sha3x4.Sha3x4T as SX with theory P <- S, theory R <- R.
import Shake256x4.

import PolyLVec PolyKVec PolyMat.
import Round ZModQ Zq.
import BS2Int.
import Array_lpolys.

(* -------------------------------------------------------------------- *)
clone import Prefixarray.PrefixArray as PA_680_136 with
      op sizeB <- 136,
      op sizeS <- 680,
  theory AB    <- Array136,
  theory AS    <- Array680

  rename "'S" as "_680"
         "'B" as "_136"

  proof le_size by done.

(* -------------------------------------------------------------------- *)
(* the number of 136-byte blocks squeezed for one polynomial            *)
lemma mask_blocks : (gamma1_bits * n %/ 8 + 135) %/ 136 = 5.
proof. by have [] -> : gamma1_log = 17 \/ gamma1_log = 19 by smt(param_sets). qed.

(* -------------------------------------------------------------------- *)
(* the 5-block squeeze wrapper: each iteration squeezes one 136-byte    *)
(* block into every lane's next window of the 680-byte buffers          *)
lemma shake256_squeeze_multiple_blocks_4xP (data : W8.t list Array4.t)
: hoare[
  M.shake256_squeeze_multiple_blocks_4x :
      state \sha3for Array4.map (mk_absorbed) data
    ==>
         res.`1 \sha3for Array4.map (mk_read (136 * 5)) data
      /\ (forall i, 0 <= i < 4 =>
            let b = nth witness [res.`2; res.`3; res.`4; res.`5] i in
            Array680.sub b 0 680 = shake256_slice data.[i] 0 680)
  ].
proof.
proc.
sp.
while (inc = 5
    /\ 0 <= i <= 5
    /\ state \sha3for Array4.map (mk_read (136 * i)) data
    /\ Array680.sub b0 0 (136 * i) = shake256_slice data.[0] 0 (136 * i)
    /\ Array680.sub b1 0 (136 * i) = shake256_slice data.[1] 0 (136 * i)
    /\ Array680.sub b2 0 (136 * i) = shake256_slice data.[2] 0 (136 * i)
    /\ Array680.sub b3 0 (136 * i) = shake256_slice data.[3] 0 (136 * i)).
- exlim i => i_.
  wp; ecall (shake256_squeezeblock4xP data i_).
  skip => &hr |> hi0 _ hst hs0 hs1 hs2 hs3 hlt r hres hblk /=.
  move: (hblk 0 _) (hblk 1 _) (hblk 2 _) (hblk 3 _) => //= hb0 hb1 hb2 hb3.
  do! split; 1,2: smt().
  - by rewrite sub_window_catE 1:/# hs0
       (shake256_slice_cat_block data.[0] i{hr} r.`2 hi0 hb0).
  - by rewrite sub_window_catE 1:/# hs1
       (shake256_slice_cat_block data.[1] i{hr} r.`3 hi0 hb1).
  - by rewrite sub_window_catE 1:/# hs2
       (shake256_slice_cat_block data.[2] i{hr} r.`4 hi0 hb2).
  by rewrite sub_window_catE 1:/# hs3
     (shake256_slice_cat_block data.[3] i{hr} r.`5 hi0 hb3).
(* entry: nothing is read yet; exit: the five windows cover 680 bytes *)
skip => &hr |> hst; split.
- by rewrite mask_blocks; do! split; smt(size_shake256_slice size_eq0).
rewrite mask_blocks.
move=> b00 b10 b20 b30 i0 state0 hge5 _ hi0 hi5 hrel h0 h1 h2 h3.
have ->>: i0 = 5 by smt().
split; first by exact hrel.
move=> j hj0 hj4.
by have [->|[->|[->|->]]] /=: j = 0 \/ j = 1 \/ j = 2 \/ j = 3 by smt().
qed.

(* ==================================================================== *)
(* The mask polynomial: the decoding of the first gamma1_enc bytes of   *)
(* the lane's SHAKE256 stream                                           *)

lemma gamma1_enc_bnd : 0 < gamma1_enc <= 680.
proof. by rewrite /gamma1_enc; smt(param_sets). qed.

op Mpoly (rho_ : W8.t Array64.t) (sep : W16.t) : poly =
  BitUnpack (shake256_slice (to_list rho_ ++ W2u8.to_list sep) 0 gamma1_enc)
            (gamma1 - 1) gamma1.

(* the decoder reads the first gamma1_enc bytes of a lane's 680         *)
lemma lane_bytes (b : W8.t Array680.t) (n : W8.t list) :
  Array680.sub b 0 680 = shake256_slice n 0 680 =>
  Array_gamma1_enc.to_list (Array_gamma1_enc.init (fun i => b.[i]))
  = shake256_slice n 0 gamma1_enc.
proof.
move=> hsub; have hg := gamma1_enc_bnd.
apply (eq_from_nth witness).
- by rewrite Array_gamma1_enc.size_to_list size_shake256_slice /#.
move=> i; rewrite Array_gamma1_enc.size_to_list => rgi.
rewrite Array_gamma1_enc.get_to_list Array_gamma1_enc.initiE //=.
have := congr1 (fun l => nth witness l i) _ _ hsub => /=.
rewrite /Array680.sub nth_mkseq 1:/# /= => ->.
by rewrite /shake256_slice /Xof.slice !nth_mkseq /#.
qed.

(* a fully squeezed lane buffer decodes to the lane's Mpoly             *)
lemma decode_lane (b : W8.t Array680.t) (n : W8.t list)
                  (rho_ : W8.t Array64.t) (sep : W16.t) :
  Array680.sub b 0 680 = shake256_slice n 0 680 =>
  n = to_list rho_ ++ W2u8.to_list sep =>
  BitUnpack (Array_gamma1_enc.to_list (Array_gamma1_enc.init (fun i => b.[i])))
            (gamma1 - 1) gamma1
  = Mpoly rho_ sep.
proof. by move=> hsub hn; rewrite (lane_bytes _ n) // /Mpoly hn. qed.

(* -------------------------------------------------------------------- *)
(* the four SIMD-interleaved lanes: absorb rho' with consecutive        *)
(* domain separators, squeeze five blocks each, decode each lane        *)
lemma sample_mask_polynomial_4xP (rho_ : W8.t Array64.t) (ds0 : W16.t) :
hoare[ M.__sample_mask_polynomial_4x :
    rho_prime = rho_ /\ starting_domain_separator = ds0
  ==> forall i, 0 <= i < 4 =>
        let p = nth witness [res.`1; res.`2; res.`3; res.`4] i in
        lifts_wpoly p = Mpoly rho_ (ds0 + W16.of_int i)
     /\ wpoly_srng (gamma1 - 1) gamma1 p ].
proof.
proc.
pose nonce (i : int) := to_list rho_ ++ W2u8.to_list (ds0 + W16.of_int i).
pose data := Array4.init nonce.
sp.
(* the four lanes absorb rho' and their consecutive domain separators *)
seq 1 : (xof_state \sha3for Array4.map mk_absorbed data).
- ecall (shake256_absorb_66_4xP rho_ ds0) => /=.
  auto=> &hr |> rst; apply/sha3for_eqR/Array4.ext_eq=> i ?.
  by rewrite !Array4.mapiE ~-1:// !Array4.initiE ~-1:// /=.
(* five squeezed blocks fill every lane's 680-byte buffer *)
seq 1 : (forall i, 0 <= i < 4 =>
           let b = nth witness
                     [mask_encoded0; mask_encoded1;
                      mask_encoded2; mask_encoded3] i in
           Array680.sub b 0 680 = shake256_slice data.[i] 0 680).
- ecall (shake256_squeeze_multiple_blocks_4xP data).
  by auto=> &hr |> hst.
(* each lane decodes to its Mpoly *)
seq 1 : (#pre /\ lifts_wpoly mask0 = Mpoly rho_ (ds0 + W16.of_int 0)
              /\ wpoly_srng (gamma1 - 1) gamma1 mask0).
- ecall (gamma1_decode_to_polynomial
           (Array_gamma1_enc.init (fun i => mask_encoded0.[0 + i]))).
  auto=> &hr |> hblk r -> _.
  have h := decode_lane mask_encoded0{hr} data.[0] rho_ ds0 _ _.
  + by have /= := hblk 0.
  + by rewrite /data initiE //= /nonce.
  exact h.
seq 1 : (#pre /\ lifts_wpoly mask1 = Mpoly rho_ (ds0 + W16.of_int 1)
              /\ wpoly_srng (gamma1 - 1) gamma1 mask1).
- ecall (gamma1_decode_to_polynomial
           (Array_gamma1_enc.init (fun i => mask_encoded1.[0 + i]))).
  auto=> &hr |> hblk _ _ r -> _.
  have h := decode_lane mask_encoded1{hr} data.[1] rho_ (ds0 + W16.of_int 1) _ _.
  + by have /= := hblk 1.
  + by rewrite /data initiE //= /nonce.
  exact h.
seq 1 : (#pre /\ lifts_wpoly mask2 = Mpoly rho_ (ds0 + W16.of_int 2)
              /\ wpoly_srng (gamma1 - 1) gamma1 mask2).
- ecall (gamma1_decode_to_polynomial
           (Array_gamma1_enc.init (fun i => mask_encoded2.[0 + i]))).
  auto=> &hr |> hblk _ _ _ _ r -> _.
  have h := decode_lane mask_encoded2{hr} data.[2] rho_ (ds0 + W16.of_int 2) _ _.
  + by have /= := hblk 2.
  + by rewrite /data initiE //= /nonce.
  exact h.
ecall (gamma1_decode_to_polynomial
         (Array_gamma1_enc.init (fun i => mask_encoded3.[0 + i]))).
auto=> &hr |> hblk h0 s0 h1 s1 h2 s2 r h3 s3.
have h := decode_lane mask_encoded3{hr} data.[3] rho_ (ds0 + W16.of_int 3) _ _.
- by have /= := hblk 3.
- by rewrite /data initiE //= /nonce.
have h3' : lifts_wpoly r = Mpoly rho_ (ds0 + W16.of_int 3) by rewrite h3; exact h.
move=> i rgi rgi2.
by have [->|[->|[->|->]]] /= : i = 0 \/ i = 1 \/ i = 2 \/ i = 3 by smt().
qed.

(* -------------------------------------------------------------------- *)
(* the single lane: the sponge squeezes five blocks and the decoder     *)
(* reads the first gamma1_enc bytes                                     *)
lemma sample_mask_polynomial_1xP (rho_ : W8.t Array64.t) (ds_ : W16.t) :
hoare[ M.__sample_mask_polynomial_1x :
    rho_prime = rho_ /\ domain_separator = ds_
  ==> lifts_wpoly res = Mpoly rho_ ds_ /\ wpoly_srng (gamma1 - 1) gamma1 res ].
proof.
proc.
pose n := to_list rho_ ++ W2u8.to_list ds_.
(* absorb, and set up the block counter *)
seq 5 : (lanes_of state \sha3one mk_read 0 n /\ inc = 5 /\ i = 0).
- by wp; ecall (shake256_absorb_66P rho_ ds_); auto => /> *; rewrite mask_blocks.
(* the loop permutes, then squeezes block i into its 136-byte window *)
seq 1 : (Array680.sub mask_encoded 0 680 = shake256_slice n 0 680).
- while (inc = 5 /\ 0 <= i <= 5
      /\ lanes_of state \sha3one mk_read (136 * i) n
      /\ Array680.sub mask_encoded 0 (136 * i)
         = shake256_slice n 0 (136 * i)).
  + exlim i => i_.
    wp; ecall (shake256_squeezeblockP n i_).
    skip => &hr |> hi0 _ hst hsub hlt [aux aux0] /= _ haux.
    split; 1: smt().
    by rewrite sub_window_catE 1:/# hsub
       (shake256_slice_cat_block n i{hr} aux0 hi0 haux).
  (* entry: nothing squeezed yet; exit: five windows cover 680 bytes *)
  skip => &hr |> hst; split; 1: by smt(size_shake256_slice size_eq0).
  move=> i0 me0 st0 hge5 hi0 hi5 hst0 hsub.
  by rewrite (: 680 = 136 * i0) 1:/# hsub.
(* the decoder reads the first gamma1_enc bytes of the stream *)
ecall (gamma1_decode_to_polynomial
         (Array_gamma1_enc.init (fun j => mask_encoded.[0 + j]))).
wp; skip => &hr |> hsub r -> _.
have h := decode_lane mask_encoded{hr} n rho_ ds_ hsub _ => //.
qed.

(* ==================================================================== *)
(* The mask vector: window r is the mask polynomial at separator ds0+r  *)

(* a window written back into the flattened vector                     *)
lemma lvec_writeback (m : 'a Array_lpolys.t) (f : 'a Array256.t) (b r : int) :
  b %% n = 0 => 0 <= r < lvec =>
  (lvec_unflatten256 (Array_lpolys.init (fun i =>
     if b <= i < b + n then f.[i - b] else m.[i]))).[r]
  = if r = b %/ n then f else (lvec_unflatten256 m).[r].
proof. exact lvec_unflatten256_writeback_iE. qed.

op mask_ok (rho_ : W8.t Array64.t) (ds0 : W16.t) (m : W32.t Array_lpolys.t) (k : int) =
  forall r, 0 <= r < k =>
       lifts_wpoly (lvec_unflatten256 m).[r] = Mpoly rho_ (ds0 + W16.of_int r)
    /\ wpoly_srng (gamma1 - 1) gamma1 (lvec_unflatten256 m).[r].

lemma mask_ok0 rho_ ds0 m : mask_ok rho_ ds0 m 0.
proof. by rewrite /mask_ok => /#. qed.

(* writing window k, at the mask polynomial of separator ds0 + k        *)
lemma mask_ok_write rho_ ds0 m (f : W32.t Array256.t) (b k : int) :
  b = n * k => 0 <= k < lvec =>
  mask_ok rho_ ds0 m k =>
  lifts_wpoly f = Mpoly rho_ (ds0 + W16.of_int k) =>
  wpoly_srng (gamma1 - 1) gamma1 f =>
  mask_ok rho_ ds0
    (Array_lpolys.init (fun i => if b <= i < b + n then f.[i - b] else m.[i])) (k + 1).
proof.
move=> -> rgk hm hf hs; rewrite /mask_ok => r rgr.
rewrite lvec_writeback 1:/# 1:/#.
case: (r = n * k %/ n) => [hr|hr]; first by have -> : r = k by smt().
by have := hm r _; smt().
qed.

lemma sample____maskP (rho_ : W8.t Array64.t) (ds0 : W16.t) :
hoare[ M.sample____mask :
    rho_prime = rho_ /\ domain_separator = ds0
  ==> mask_ok rho_ ds0 res.`1 lvec /\ res.`2 = ds0 + W16.of_int lvec ].
proof.
have hl : lvec = 4 \/ lvec = 5 \/ lvec = 7 by smt(param_sets).
proc.
(* the first batch fills windows 0-3 and advances the separator to ds0+4 *)
seq 8 : (rho_prime = rho_ /\ domain_separator = ds0 + W16.of_int 4
  /\ mask_ok rho_ ds0 mask 4).
- wp; ecall (sample_mask_polynomial_4xP rho_ ds0).
  wp; skip => &hr [h1 h2]; split => // _ r hall.
  split; 1: smt().
  split; 1: smt().
  have := hall 0 _; have := hall 1 _; have := hall 2 _; have := hall 3 _ => //=.
  move=> [r3 s3] [r2 s2] [r1 s1] [r0 s0].
  apply (mask_ok_write _ _ _ _ _ 3) => //; 1: smt(gt0_l param_sets).
  apply (mask_ok_write _ _ _ _ _ 2) => //; 1: smt(gt0_l param_sets).
  apply (mask_ok_write _ _ _ _ _ 1) => //; 1: smt(gt0_l param_sets).
  apply (mask_ok_write _ _ _ _ _ 0) => //; 1: smt(gt0_l param_sets).
  exact mask_ok0.
(* l = 1 (mod 4): the single lane fills window 4 *)
case @[ambient] (lvec = 5) => hl5.
- rcondt 1; 1: by auto => /#.
  rcondf ^if; 1: by conseq (: _ ==> true);
    [smt() | wp; ecall (sample_mask_polynomial_1xP rho_ (ds0 + W16.of_int 4)); auto].
  wp; ecall (sample_mask_polynomial_1xP rho_ (ds0 + W16.of_int 4)).
  wp; skip => &hr [h1 [h2 hm]]; split => // ? r [hr hs].
  split.
  + by rewrite hl5; apply (mask_ok_write _ _ _ _ _ 4) => //; smt().
  by rewrite h2 hl5; ring.
rcondf 1; 1: by auto => /#.
(* l = 3 (mod 4): a second batch fills windows 4-6, its last lane is dropped *)
case @[ambient] (lvec = 7) => hl7.
- rcondt 1; 1: by auto => /#.
  wp; ecall (sample_mask_polynomial_4xP rho_ (ds0 + W16.of_int 4)).
  wp; skip => &hr [h1 [h2 hm]]; split => // ? r hall.
  have := hall 0 _; have := hall 1 _; have := hall 2 _ => //=.
  move=> [r2 s2] [r1 s1] [r0 s0].
  split.
  + rewrite hl7.
    apply (mask_ok_write _ _ _ _ _ 6) => //; 1: smt().
    apply (mask_ok_write _ _ _ _ _ 5) => //; 1: smt().
    by apply (mask_ok_write _ _ _ _ _ 4) => //; smt().
  by rewrite h2 hl7; ring.
(* l = 0 (mod 4): the first batch is the whole mask *)
rcondf 1; 1: by auto => /#.
skip => &hr [h1 [h2 hm]]; have hl4 : lvec = 4 by smt().
by rewrite hl4 h2.
qed.

(* the mask polynomial is the specification's, at the same separator    *)
lemma Mpoly_specE (rho_ : W8.t Array64.t) (sep : W16.t) :
  Mpoly rho_ sep
  = BitUnpack
      (BytesV.to_list (H_v (Bytes66.of_list
         (to_list rho_ ++ IntegerToBytes (W16.to_uint sep) 2))))
      (gamma1 - 1) gamma1.
proof.
have hb : 0 <= W16.to_uint sep < 65536.
- by have := W16.to_uint_cmp sep; have -> : W16.modulus = 65536 by done.
have hg := gamma1_enc_bnd.
have hv : n * (gamma1_log + 1) %/ 8 = gamma1_enc by rewrite -gamma1_encE mulzC.
rewrite /Mpoly shake256_sliceE 1:/# IntegerToBytes2E // W16.to_uintK.
rewrite /H_v Bytes66.of_listK; 1: by rewrite size_cat Array64.size_to_list.
by rewrite hv BytesV.of_listK // size_SHAKE256 /#.
qed.

(* -------------------------------------------------------------------- *)
(* Losslessness                                                         *)
hint solve 0 lossless : gamma1_decode_to_polynomial_ll.

lemma load_shake256_state_ll : islossless M.__load_shake256_state.
proof. by proc; while true (7 - i); auto => /#. qed.
hint solve 0 lossless : load_shake256_state_ll.

lemma store_shake256_state_ll : islossless M.__store_shake256_state.
proof. by proc; while true (7 - i); auto => /#. qed.
hint solve 0 lossless : store_shake256_state_ll.

lemma shake256_squeeze_multiple_blocks_4x_ll :
  islossless M.shake256_squeeze_multiple_blocks_4x.
proof.
proc; while true (inc - i); 2: by auto => /#.
by move=> z; wp; call (: true); [islossless | auto => /#].
qed.
hint solve 0 lossless : shake256_squeeze_multiple_blocks_4x_ll.

lemma sample_mask_polynomial_1x_ll : islossless M.__sample_mask_polynomial_1x.
proof.
proc; islossless; while true (inc - i); 2: by auto => /#.
by move=> z; wp; call (: true); [islossless | auto => /#].
qed.
hint solve 0 lossless : sample_mask_polynomial_1x_ll.

lemma sample____mask_ll : islossless M.sample____mask.
proof. by islossless. qed.

lemma sample____mask_ph (rho_ : W8.t Array64.t) (ds0 : W16.t) :
  phoare [ M.sample____mask : rho_prime = rho_ /\ domain_separator = ds0 ==>
    mask_ok rho_ ds0 res.`1 lvec /\ res.`2 = ds0 + W16.of_int lvec ] = 1%r.
proof. by conseq sample____mask_ll (sample____maskP rho_ ds0). qed.

(* -------------------------------------------------------------------- *)
(* The sampler is the specification's ExpandMask. The 16-bit separator  *)
(* must not wrap: the signing loop keeps it below 65536 - lvec.         *)
lemma mask_correct _seed _dom :
  equiv [ ExpandMask.sample ~ M.sample____mask :
       arg{1}.`1 = Bytes64.of_list (Array64.to_list _seed)
    /\ arg{1}.`2 = W16.to_uint _dom
    /\ arg{2}.`1 = _seed
    /\ arg{2}.`2 = _dom
    /\ W16.to_uint _dom + lvec < 65536
    ==>
       lifts_wpolylvec (lvec_unflatten256 res{2}.`1) = res{1}
    /\ wpolylvec_srng (lvec_unflatten256 res{2}.`1) (gamma1 - 1) gamma1
    /\ W16.to_uint res{2}.`2 = W16.to_uint _dom + lvec
  ].
proof.
proc*.
ecall{1} (ExpandMask_correct (Bytes64.of_list (to_list _seed)) (W16.to_uint _dom)).
ecall{2} (sample____mask_ph _seed _dom).
skip => &1 &2 /> hb r2 hm hsep.
have hM : W16.modulus = 65536 by done.
have hd := W16.to_uint_cmp domain_separator{2}.
split.
- apply LArray.tP => k hk; rewrite /lifts_wpolylvec LArray.mapiE //=.
  have [-> _] := hm k hk.
  rewrite Mpoly_specE /expandMask LArray.initiE //= Bytes64.of_listK.
  - by rewrite Array64.size_to_list.
  by rewrite to_uintD_small of_uintK ?hM ?pmod_small /#.
split.
- by rewrite /wpolylvec_srng LArray.allP => k hk; have [_ ->] := hm k hk.
by rewrite hsep to_uintD_small of_uintK ?hM ?pmod_small; smt(gt0_l).
qed.

end MaskT.
