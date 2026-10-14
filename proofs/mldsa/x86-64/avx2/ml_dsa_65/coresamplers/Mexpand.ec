(* -------------------------------------------------------------------- *)
(* Correctness of the AVX2 mask sampler (ExpandMask, gamma1 = 2^19):    *)
(* each mask polynomial is the 20-bit gamma1-decode of the first 640    *)
(* bytes of its lane's SHAKE256 stream -- no rejection.  Four lanes are *)
(* sampled SIMD-interleaved, the fifth by the single-lane sponge.       *)
(* [Mpoly] is that decode, by definition; the stream is the spec's      *)
(* SHAKE256 (Sha3x4.shake256_sliceE).                                   *)
(* -------------------------------------------------------------------- *)
require import AllCore CoreUtils List List_extra IntDiv StdOrder BitEncoding.
import BS2Int.

(* -------------------------------------------------------------------- *)
from Jasmin require import JWord JModel_x86.
require import Mldsa65.

require import Prefixarray.
require import Warraypack.
require import Avx2red.
require import Sha3x4 Shared65. import Sha3x4_65 Shake256x4.
require import Array2 Array4 Array7 Array25 Array64 Array136 Array256 Array640 Array680 Array1280.
require import WArray640 WArray1024.

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
type rho'  = W8.t Array64.t.
type wpoly = W32.t Array256.t.

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
- by do! split; smt(size_shake256_slice size_eq0).
move=> b00 b10 b20 b30 i0 state0 hge5 hi0 hi5 hrel h0 h1 h2 h3.
have ->>: i0 = 5 by smt().
split; first by exact hrel.
move=> j hj0 hj4.
by have [->|[->|[->|->]]] /=: j = 0 \/ j = 1 \/ j = 2 \/ j = 3 by smt().
qed.

(* ==================================================================== *)
(* The gamma1 bit-decode: coefficient i is gamma1 minus the i-th        *)
(* 20-bit little-endian field of the byte stream                        *)

op gamma1 : int = 2 ^ 19.

op mbits (bs : W8.t list) (i : int) : int =
  bs2int (take 20 (drop (20 * i) (flatten (map W8.w2bits bs)))).

op mcoeff (bs : W8.t list) (i : int) : W32.t =
  W32.of_int gamma1 - W32.of_int (mbits bs i).

op mdecode (bs : W8.t list) : wpoly =
  Array256.init (mcoeff bs).

(* -------------------------------------------------------------------- *)
(* dropping n bytes drops 8n bits                                       *)
lemma drop_bits8 (bs : W8.t list) (n : int) : 0 <= n =>
  drop (8 * n) (flatten (map W8.w2bits bs)) = flatten (map W8.w2bits (drop n bs)).
proof.
elim: bs n => [|b bs ih] n hn; 1: by rewrite /= flatten_nil /=.
case: (n = 0) => [->|nz]; 1: by rewrite drop0.
rewrite /= flatten_cons drop_cat W8.size_w2bits.
rewrite (_ : (8 * n < 8) = false) 1:/# /=.
rewrite (_ : 8 * n - 8 = 8 * (n - 1)) 1:#ring ih 1:/#.
by rewrite ifF 1:/#.
qed.

lemma take_bits8 (bs : W8.t list) (n : int) : 0 <= n =>
  take (8 * n) (flatten (map W8.w2bits bs)) = flatten (map W8.w2bits (take n bs)).
proof.
elim: bs n => [|b bs ih] n hn; 1: by rewrite /= flatten_nil /=.
case: (n = 0) => [->|nz]; 1: by rewrite /= take0 flatten_nil.
rewrite /= flatten_cons take_cat W8.size_w2bits.
rewrite (_ : (8 * n < 8) = false) 1:/# /=.
rewrite (_ : 8 * n - 8 = 8 * (n - 1)) 1:#ring ih 1:/#.
by rewrite ifF 1:/# /= flatten_cons.
qed.

(* -------------------------------------------------------------------- *)
(* a packed 4-byte window, as 32 consecutive bits of the byte stream    *)
lemma w2bits_pack4 (b0 b1 b2 b3 : W8.t) :
  W32.w2bits (W4u8.pack4 [b0; b1; b2; b3])
  = W8.w2bits b0 ++ W8.w2bits b1 ++ W8.w2bits b2 ++ W8.w2bits b3.
proof.
apply (eq_from_nth false).
- by rewrite W32.size_w2bits !size_cat !W8.size_w2bits.
rewrite W32.size_w2bits => i rgi.
rewrite W32.get_w2bits.
rewrite (_ : i = i %/ 8 * 8 + i %% 8) 1:/#.
rewrite -W4u8.bits8iE 1:/# W4u8.pack4bE 1:/#.
by (have [->|[->|[->|->]]] /= :
      i %/ 8 = 0 \/ i %/ 8 = 1 \/ i %/ 8 = 2 \/ i %/ 8 = 3 by smt());
   smt(nth_cat size_cat W8.size_w2bits W8.get_w2bits).
qed.

lemma to_uint_pack4 (b0 b1 b2 b3 : W8.t) :
  to_uint (W4u8.pack4 [b0; b1; b2; b3])
  = bs2int (W8.w2bits b0 ++ W8.w2bits b1 ++ W8.w2bits b2 ++ W8.w2bits b3).
proof. by rewrite W32.to_uintE w2bits_pack4. qed.

(* -------------------------------------------------------------------- *)
(* ==================================================================== *)
(* The mask polynomial: the decoding of the first 640 bytes of the      *)
(* lane's SHAKE256 stream (no rejection)                                *)
op Mpoly (rho_ : rho') (sep : W16.t) : wpoly =
  mdecode (shake256_slice (to_list rho_ ++ W2u8.to_list sep) 0 640).

lemma MpolyP (rho_ : rho') (sep : W16.t) :
  Mpoly rho_ sep
  = mdecode (shake256_slice (to_list rho_ ++ W2u8.to_list sep) 0 640).
proof. by done. qed.

(* -------------------------------------------------------------------- *)
(* the SIMD decoder gathers only 3 bytes per slot (a shifted 20-bit     *)
(* field spans at most 24 bits); the top byte is forced to zero         *)
lemma to_uint_pack4_3 (b0 b1 b2 : W8.t) :
  to_uint (W4u8.pack4 [b0; b1; b2; W8.zero])
  = bs2int (W8.w2bits b0 ++ W8.w2bits b1 ++ W8.w2bits b2).
proof.
rewrite to_uint_pack4 -!catA !bs2int_cat.
have -> : bs2int (W8.w2bits W8.zero) = 0 by rewrite -W8.to_uintE.
by ring.
qed.

lemma window3 (bs : W8.t list) (c : int) :
  0 <= c => c + 3 <= size bs =>
  to_uint (W4u8.pack4 [nth witness bs c; nth witness bs (c + 1);
                       nth witness bs (c + 2); W8.zero])
  = bs2int (take 24 (drop (8 * c) (flatten (map W8.w2bits bs)))).
proof.
move=> hc hsz.
rewrite to_uint_pack4_3 drop_bits8 // (_ : 24 = 8 * 3) 1:// take_bits8 //.
have -> : take 3 (drop c bs)
        = [nth witness bs c; nth witness bs (c + 1); nth witness bs (c + 2)].
- have hsz3 : size (take 3 (drop c bs)) = 3
    by smt(size_take size_drop size_ge0).
  apply (eq_from_nth witness); 1: by rewrite hsz3.
  rewrite hsz3 => j rgj.
  rewrite nth_take ~-1:/# nth_drop ~-1:/#.
  by have [->|[->|->]] /= : j = 0 \/ j = 1 \/ j = 2 by smt().
by rewrite /= !flatten_cons flatten_nil cats0 !catA.
qed.

(* the j-th field through a 3-byte window: the SIMD slot layout         *)
lemma mbits_at3 (bs : W8.t list) (j c s : int) :
  0 <= c => c + 3 <= size bs => 20 * j = 8 * c + s => 0 <= s <= 4 =>
  mbits bs j
  = to_uint (W4u8.pack4 [nth witness bs c; nth witness bs (c + 1);
                         nth witness bs (c + 2); W8.zero])
    %/ 2 ^ s %% 2 ^ 20.
proof.
move=> hc hsz hjs hs.
rewrite window3 // /mbits hjs.
rewrite bs2int_div 1:/# bs2int_mod //.
congr.
rewrite drop_take ~-1:/# take_take ifT 1:/#.
by rewrite drop_drop ~-1:/# (_ : 8 * c + s = s + 8 * c) 1:#ring.
qed.

(* -------------------------------------------------------------------- *)
(* one decoded slot: shift, mask, subtract from gamma1                  *)
lemma mcoeff_slotE (bs : W8.t list) (j c s : int) :
  0 <= c => c + 3 <= size bs => 20 * j = 8 * c + s => 0 <= s <= 4 =>
  W32.of_int gamma1
  - (W4u8.pack4 [nth witness bs c; nth witness bs (c + 1);
                 nth witness bs (c + 2); W8.zero]
     `>>>` s) `&` W32.of_int (2 ^ 20 - 1)
  = mcoeff bs j.
proof.
move=> hc hsz hjs hs.
rewrite W32.and_mod // W32.to_uint_shr 1:/#.
by rewrite /mcoeff (mbits_at3 bs j c s).
qed.

(* ==================================================================== *)
(* The SIMD gamma1 decoder                                              *)

clone Warraypack.WArrayPack as WP640 with
      op size <- 640,
  theory A    <- Array640,
  theory WA   <- WArray640
  rename "get" as "WArray640_get".

import WP640.

lemma sub16E_640 (a : W8.t Array640.t) (k : int) :
  Array640.sub a k 16
  = [a.[k]; a.[k + 1]; a.[k + 2]; a.[k + 3]; a.[k + 4]; a.[k + 5];
     a.[k + 6]; a.[k + 7]; a.[k + 8]; a.[k + 9]; a.[k + 10]; a.[k + 11];
     a.[k + 12]; a.[k + 13]; a.[k + 14]; a.[k + 15]].
proof. by rewrite /sub /mkseq -iotaredE /=. qed.

(* -------------------------------------------------------------------- *)
(* the decoding tables, in the shapes the symbolic execution exposes:   *)
(* per-lane byte gathers (three source bytes + a forced zero per slot)  *)
(* and the alternating in-slot shifts                                   *)
lemma shuffle_loE :
  (W256.of_int
     115366376096492768164844321449898653011859597303583218241719758451187166347520)
    \bits128 0
  = W16u8.pack16
      [W8.of_int 0; W8.of_int 1; W8.of_int 2; W8.of_int 255;
       W8.of_int 2; W8.of_int 3; W8.of_int 4; W8.of_int 255;
       W8.of_int 5; W8.of_int 6; W8.of_int 7; W8.of_int 255;
       W8.of_int 7; W8.of_int 8; W8.of_int 9; W8.of_int 255].
proof.
by rewrite W2u128.of_int_bits128_div_red ~-1:// /= W16u8.of_uint_pack16 -iotaredE /=.
qed.

lemma shuffle_hiE :
  (W256.of_int
     115366376096492768164844321449898653011859597303583218241719758451187166347520)
    \bits128 1
  = W16u8.pack16
      [W8.of_int 6; W8.of_int 7; W8.of_int 8; W8.of_int 255;
       W8.of_int 8; W8.of_int 9; W8.of_int 10; W8.of_int 255;
       W8.of_int 11; W8.of_int 12; W8.of_int 13; W8.of_int 255;
       W8.of_int 13; W8.of_int 14; W8.of_int 15; W8.of_int 255].
proof.
by rewrite W2u128.of_int_bits128_div_red ~-1:// /= W16u8.of_uint_pack16 -iotaredE /=.
qed.

lemma eshiftsE :
  error_polynomial__SHIFTS
  = W8u32.pack8 [W32.of_int 0; W32.of_int 4; W32.of_int 0; W32.of_int 4;
                 W32.of_int 0; W32.of_int 4; W32.of_int 0; W32.of_int 4].
proof. by rewrite W8u32.of_uint_pack8 -iotaredE /=. qed.

(* -------------------------------------------------------------------- *)
(* the SIMD decoder: 32 iterations, each turning a 20-byte input group  *)
(* into eight coefficients                                              *)
lemma gamma1____decode_to_polynomialP_bits20 (bytes_ : W8.t Array640.t) :
hoare[ M.gamma1____decode_to_polynomial_bits20 :
    bytes = bytes_
  ==> res = mdecode (Array640.to_list bytes_) ].
proof.
proc.
(* the broadcast constants gamma1 and 2 * gamma1 - 1, the zeroed        *)
(* accumulator and both running offsets                                 *)
seq 9 : (bytes = bytes_
      /\ gamma1 = VPBROADCAST_8u32 (W32.of_int 524288)
      /\ gamma1_times_2_mask = VPBROADCAST_8u32 (W32.of_int 1048575)
      /\ input_offset = 0 /\ output_offset = 0).
- by auto.
(* each iteration decodes the 20-byte group at input_offset into the    *)
(* eight coefficients at output_offset                                  *)
while (bytes = bytes_
    /\ gamma1 = VPBROADCAST_8u32 (W32.of_int 524288)
    /\ gamma1_times_2_mask = VPBROADCAST_8u32 (W32.of_int 1048575)
    /\ 0 <= output_offset <= 1024
    /\ 32 %| output_offset
    /\ input_offset = 5 * output_offset %/ 8
    /\ (forall j, 0 <= j < output_offset %/ 4 =>
          polynomial.[j] = mcoeff (Array640.to_list bytes_) j)); last first.
(* entry: nothing is decoded yet; exit: all 256 coefficients are *)
- skip=> &hr |> ; split; 1: by do! split => //; smt().
  move=> oo0 poly0 hge hoo1 hoo2 hdvd hcov.
  apply Array256.ext_eq => j rgj.
  rewrite /mdecode initiE //=.
  by apply hcov => /#.
auto=> &hr |> hoo1 hoo2 hdvd hcov hlt.
(* the group index: this iteration decodes 20-byte group k of 32 *)
have [k [hk rgk]] : exists k, output_offset{hr} = 32 * k /\ 0 <= k < 32.
- by exists (output_offset{hr} %/ 32) => /#.
(* normalize the tables, the two 16-byte loads, and the slot pipeline *)
rewrite !eshiftsE !shuffle_loE !shuffle_hiE /=.
rewrite WArray640_get128E 1:/# WArray640_get128E 1:/# !sub16E_640 /=.
rewrite hk (: 5 * (32 * k) %/ 8 = 20 * k) 1:/#.
split; first by smt().
split; first by smt().
split; first by smt().
(* the store covers coefficients 8k .. 8k+7 *)
move=> j hj0 hjlt.
rewrite (: 32 * k = 4 * (8 * k)) 1:#ring (wpoly_set256_aligned (8 * k)) 1:/#.
rewrite filliE 1:/#.
case: (8 * k <= j < 8 * k + 8) => hcase; last first.
- by apply hcov => /#.
(* the eight freshly decoded slots, one per in-group coefficient *)
have [t [-> rgt]] : exists t, j = 8 * k + t /\ 0 <= t < 8.
- by exists (j - 8 * k) => /#.
rewrite (: 8 * k + t - 8 * k = t) 1:#ring.
have [->|[->|[->|[->|[->|[->|[->|->]]]]]]] :
  t = 0 \/ t = 1 \/ t = 2 \/ t = 3 \/ t = 4 \/ t = 5 \/ t = 6 \/ t = 7
  by smt().
- by rewrite W8u32.pack8bE // -!Array640.get_to_list
     (mcoeff_slotE (to_list bytes{hr}) (8 * k + 0) (20 * k) 0)
     ~-1:#smt:(Array640.size_to_list).
- by rewrite W8u32.pack8bE // -!Array640.get_to_list
     (mcoeff_slotE (to_list bytes{hr}) (8 * k + 1) (20 * k + 2) 4)
     ~-1:#smt:(Array640.size_to_list).
- by rewrite W8u32.pack8bE // -!Array640.get_to_list
     (mcoeff_slotE (to_list bytes{hr}) (8 * k + 2) (20 * k + 5) 0)
     ~-1:#smt:(Array640.size_to_list).
- by rewrite W8u32.pack8bE // -!Array640.get_to_list
     (mcoeff_slotE (to_list bytes{hr}) (8 * k + 3) (20 * k + 7) 4)
     ~-1:#smt:(Array640.size_to_list).
- by rewrite W8u32.pack8bE // -!Array640.get_to_list
     (mcoeff_slotE (to_list bytes{hr}) (8 * k + 4) (20 * k + 10) 0)
     ~-1:#smt:(Array640.size_to_list).
- by rewrite W8u32.pack8bE // -!Array640.get_to_list
     (mcoeff_slotE (to_list bytes{hr}) (8 * k + 5) (20 * k + 12) 4)
     ~-1:#smt:(Array640.size_to_list).
- by rewrite W8u32.pack8bE // -!Array640.get_to_list
     (mcoeff_slotE (to_list bytes{hr}) (8 * k + 6) (20 * k + 15) 0)
     ~-1:#smt:(Array640.size_to_list).
by rewrite W8u32.pack8bE // -!Array640.get_to_list
   (mcoeff_slotE (to_list bytes{hr}) (8 * k + 7) (20 * k + 17) 4)
   ~-1:#smt:(Array640.size_to_list).
qed.

lemma gamma1____decode_to_polynomialP (bytes_ : W8.t Array640.t) :
hoare[ M.gamma1____decode_to_polynomial :
    bytes = bytes_
  ==> res = mdecode (Array640.to_list bytes_) ].
proof. by proc; rcondf 1; [auto | call (gamma1____decode_to_polynomialP_bits20 bytes_); auto]. qed.

(* ==================================================================== *)
(* The lane samplers against the Mpoly oracle                           *)

(* the decoder consumes the first 640 of a lane's 680 squeezed bytes    *)
lemma to_list_init640 (b : W8.t Array680.t) :
  Array640.to_list (Array640.init ("_.[_]" b))
  = Array680.sub b 0 640.
proof.
rewrite /to_list /sub; apply eq_in_mkseq => i rgi /=.
by rewrite initiE.
qed.

lemma slice640_of_680 (n : W8.t list) :
  take 640 (shake256_slice n 0 680) = shake256_slice n 0 640.
proof.
rewrite (: 680 = 640 + 40) 1:// shake256_slice_cat //.
by rewrite take_size_cat // size_shake256_slice.
qed.

(* a fully squeezed lane buffer decodes to the lane's Mpoly             *)
lemma mdecode_lane (b : W8.t Array680.t) (n : W8.t list)
                   (rho_ : rho') (sep : W16.t) :
  Array680.sub b 0 680 = shake256_slice n 0 680 =>
  n = to_list rho_ ++ W2u8.to_list sep =>
  mdecode (Array640.to_list (Array640.init ("_.[_]" b)))
  = Mpoly rho_ sep.
proof.
move=> hsub hn.
rewrite to_list_init640 -(take_sub_680 b 0 640 680) 1://.
by rewrite hsub slice640_of_680 MpolyP hn.
qed.

(* -------------------------------------------------------------------- *)
(* the four SIMD-interleaved lanes: absorb rho' with consecutive        *)
(* domain separators, squeeze five blocks each, decode each lane        *)
lemma sample_mask_polynomial_4xP (rho_ : rho') (ds0 : W16.t) :
hoare[ M.__sample_mask_polynomial_4x :
    rho_prime = rho_ /\ starting_domain_separator = ds0
  ==> forall i, 0 <= i < 4 =>
        nth witness [res.`1; res.`2; res.`3; res.`4] i
        = Mpoly rho_ (ds0 + W16.of_int i) ].
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
(* lane 0 decodes to its Mpoly *)
seq 1 : (#pre /\ mask0 = Mpoly rho_ (ds0 + W16.of_int 0)).
- ecall (gamma1____decode_to_polynomialP
           (Array640.init (fun i => mask_encoded0.[0 + i]))).
  auto=> &hr |> hblk.
  move: (hblk 0 _) => //= hb0.
  by rewrite (mdecode_lane _ data.[0] rho_ ds0) 1:hb0;
     first by rewrite /data initiE.
(* lane 1 *)
seq 1 : (#pre /\ mask1 = Mpoly rho_ (ds0 + W16.of_int 1)).
- ecall (gamma1____decode_to_polynomialP
           (Array640.init (fun i => mask_encoded1.[0 + i]))).
  auto=> &hr |> hblk.
  move: (hblk 1 _) => //= hb1.
  by rewrite (mdecode_lane _ data.[1] rho_ (ds0 + W16.of_int 1)) 1:hb1;
     first by rewrite /data initiE.
(* lane 2 *)
seq 1 : (#pre /\ mask2 = Mpoly rho_ (ds0 + W16.of_int 2)).
- ecall (gamma1____decode_to_polynomialP
           (Array640.init (fun i => mask_encoded2.[0 + i]))).
  auto=> &hr |> hblk.
  move: (hblk 2 _) => //= hb2.
  by rewrite (mdecode_lane _ data.[2] rho_ (ds0 + W16.of_int 2)) 1:hb2;
     first by rewrite /data initiE.
(* lane 3, and the four lanes assemble *)
ecall (gamma1____decode_to_polynomialP
         (Array640.init (fun i => mask_encoded3.[0 + i]))).
auto=> &hr |> hblk.
move: (hblk 3 _) => //= hb3.
rewrite (mdecode_lane _ data.[3] rho_ (ds0 + W16.of_int 3)) 1:hb3 //.
move=> i rgi rgi2.
by have [->|[->|[->|->]]] /= : i = 0 \/ i = 1 \/ i = 2 \/ i = 3 by smt().
qed.

(* -------------------------------------------------------------------- *)
(* the fifth lane: the single-lane sponge squeezes five blocks and the  *)
(* decoder reads the first 640 bytes                                    *)
lemma sample_mask_polynomial_1xP (rho_ : rho') (ds_ : W16.t) :
hoare[ M.__sample_mask_polynomial_1x :
    rho_prime = rho_ /\ domain_separator = ds_
  ==> res = Mpoly rho_ ds_ ].
proof.
proc.
pose n := to_list rho_ ++ W2u8.to_list ds_.
(* absorb, and set up the block counter *)
seq 5 : (lanes_of state \sha3one mk_read 0 n /\ inc = 5 /\ i = 0).
- by wp; ecall (shake256_absorb_66P rho_ ds_); auto.
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
(* the decoder reads the first 640 bytes of the stream *)
ecall (gamma1____decode_to_polynomialP
         (Array640.init (fun j => mask_encoded.[0 + j]))).
wp; skip => &hr |> hsub.
by rewrite (mdecode_lane _ n rho_ ds_) 1:hsub.
qed.

(* ==================================================================== *)
(* The mask-vector assembly: one 4x batch plus one single lane          *)
(* ==================================================================== *)

(* -------------------------------------------------------------------- *)
clone Prefixarray.PrefixArray as PW_1280_256 with
      op sizeB <- 256,
      op sizeS <- 1280,
  theory AB    <- Array256,
  theory AS    <- Array1280
  proof le_size by done.

abbrev poly_of_mask (s : W32.t Array1280.t) (r : int) : wpoly =
  PW_1280_256.winof s r.

(* -------------------------------------------------------------------- *)
lemma sample____maskP (rho_ : rho') (ds0 : W16.t) :
hoare[ M.sample____mask :
    rho_prime = rho_ /\ domain_separator = ds0
  ==>
     (forall r, 0 <= r < 5 =>
        poly_of_mask res.`1 r = Mpoly rho_ (ds0 + W16.of_int r))
  /\ res.`2 = ds0 + W16.of_int 5 ].
proof.
proc.
(* the 4x batch fills windows 0-3 and advances the separator to ds0+4 *)
seq 8 : (rho_prime = rho_ /\ domain_separator = ds0 + W16.of_int 4
  /\ forall r, 0 <= r < 4 =>
       poly_of_mask mask r = Mpoly rho_ (ds0 + W16.of_int r)).
- wp; ecall (sample_mask_polynomial_4xP rho_ ds0).
  auto=> &hr |> result hres r rgr rgr2.
  do 4! (rewrite PW_1280_256.winof_write ~-1:/#).
  by move: (hres 0 _) (hres 1 _) (hres 2 _) (hres 3 _) => //#.
(* L = 1 (mod 4): the single lane fills window 4 and advances the separator
   to ds0+5 *)
rcondt 1; 1: by auto.
rcondf ^if; 1: by auto.
wp; ecall (sample_mask_polynomial_1xP rho_ (ds0 + W16.of_int 4)).
auto=> &hr |> hmask r rgr rgr2.
rewrite PW_1280_256.winof_write ~-1:/#.
case: (256 * r = 1024) => [heq|hne].
- by have -> : r = 4 by smt().
by move: (hmask r) => /#.
qed.
