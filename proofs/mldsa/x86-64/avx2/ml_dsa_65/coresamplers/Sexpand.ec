(* -------------------------------------------------------------------- *)
require import AllCore CoreUtils List List_extra IntDiv BitEncoding.
import BS2Int.

(* -------------------------------------------------------------------- *)
from Jasmin require import JWord JModel_x86.
from JazzEC require import Ml_dsa_65_avx2.

require import Agree.
require import Avx2red.
require import Errshuffle.
require import Prefixarray.
require import Rejstream.
require import Warraypack.
require import Sha3x4. import Shake256x4.
require import Array4 Array25 Array64 Array136 Array256 Array272 Array1280 Array1536 Array2048.
require import WArray272 WArray1024 WArray2048.

(* -------------------------------------------------------------------- *)
clone import Prefixarray.PrefixArray as PA_272_136 with
      op sizeB <- 136,
      op sizeS <- 272,
  theory AB    <- Array136,
  theory AS    <- Array272

  rename "'S" as "_272"
         "'B" as "_136"

  proof le_size by done.

(* -------------------------------------------------------------------- *)
clone Warraypack.WArrayPack as WP272 with
      op size <- 272,
  theory A    <- Array272,
  theory WA   <- WArray272
  rename "get" as "WArray272_get".

clone Warraypack.WArrayPack as WP2048 with
      op size <- 2048,
  theory A    <- Array2048,
  theory WA   <- WArray2048
  rename "get" as "WArray2048_get".

import WP272 WP2048.

(* -------------------------------------------------------------------- *)
type rho'  = W8.t Array64.t.
type wpoly = W32.t Array256.t.

(* -------------------------------------------------------------------- *)
(* the 2-block squeeze wrapper: each iteration squeezes one 136-byte    *)
(* block into every lane's next window of the 272-byte buffers          *)
lemma error_4x____shake256_squeeze_multiple_blocks_4xP (data : W8.t list Array4.t)
: hoare[
  M.error_4x____shake256_squeeze_multiple_blocks_4x :
      state \sha3for Array4.map (mk_absorbed) data
    ==>
         res.`1 \sha3for Array4.map (mk_read (136 * 2)) data
      /\ (forall i, 0 <= i < 4 =>
            let b = nth witness [res.`2; res.`3; res.`4; res.`5] i in
            Array272.sub b 0 272 = shake256_slice data.[i] 0 272)
  ].
proof.
proc.
sp.
while (0 <= i <= 2
    /\ state \sha3for Array4.map (mk_read (136 * i)) data
    /\ Array272.sub b0 0 (136 * i) = shake256_slice data.[0] 0 (136 * i)
    /\ Array272.sub b1 0 (136 * i) = shake256_slice data.[1] 0 (136 * i)
    /\ Array272.sub b2 0 (136 * i) = shake256_slice data.[2] 0 (136 * i)
    /\ Array272.sub b3 0 (136 * i) = shake256_slice data.[3] 0 (136 * i)).
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
(* entry: nothing is read yet; exit: the two windows cover 272 bytes *)
skip => &hr |> hst; split.
- by do! split; smt(size_shake256_slice size_eq0).
move=> b00 b10 b20 b30 i0 state0 hge2 hi0 hi2 hrel h0 h1 h2 h3.
have ->>: i0 = 2 by smt().
split; first by exact hrel.
move=> j hj0 hj4.
by have [->|[->|[->|->]]] /=: j = 0 \/ j = 1 \/ j = 2 \/ j = 3 by smt().
qed.

(* -------------------------------------------------------------------- *)
(* -------------------------------------------------------------------- *)
(* the abstract nibble-candidate stream: every byte yields TWO          *)
(* candidates, low nibble first; a candidate z is accepted when z < 9   *)
(* and then contributes the signed coefficient 4 - z                    *)

op saccept (z : W8.t) : bool = to_uint z < 9.

op scoeff (z : W8.t) : W32.t = W32.of_int 4 - zeroextu32 z.

op nibbles (b : W8.t) : W8.t list = [b `&` W8.of_int 15; b `>>>` 4].

op [opaque] scands (bs : W8.t list) : W8.t list = flatten (map nibbles bs).

(* -------------------------------------------------------------------- *)
lemma size_nibbles (b : W8.t) : size (nibbles b) = 2.
proof. by rewrite /nibbles. qed.

(* -------------------------------------------------------------------- *)
lemma scands_nil : scands [] = [].
proof. by rewrite /scands. qed.

hint simplify scands_nil.

lemma scands_cons (b : W8.t) (bs : W8.t list) :
  scands (b :: bs) = nibbles b ++ scands bs.
proof. by rewrite /scands /= flatten_cons. qed.

lemma scands_cat (xs ys : W8.t list) :
  scands (xs ++ ys) = scands xs ++ scands ys.
proof. by rewrite /scands map_cat flatten_cat. qed.

lemma size_scands (bs : W8.t list) : size (scands bs) = 2 * size bs.
proof.
elim: bs => [|b bs ih]; first by rewrite scands_nil.
by rewrite scands_cons size_cat size_nibbles ih /#.
qed.

(* -------------------------------------------------------------------- *)
clone Rejstream.RejStream as SRS with
  type cand   <- W8.t,
    op dec1   <- (fun (g : W8.t list) => nibbles (head witness g)),
    op align  <- 1,
    op accept <- saccept,
    op coeff  <- scoeff,
    op rate   <- 136,
    op slice  <- shake256_slice,
  type buf    <- W8.t Array272.t,
    op headb  <- (fun (a : W8.t Array272.t) =>
                    Array136.to_list (PA_272_136.truncatea_136 a))

  rename "reject"    as "sreject"
         "lanes_ok"  as "slanes_ok"
         "blocks_ok" as "sblocks_ok"

  proof gt0_align  by done,
        ge0_rate   by done,
        align_rate by apply dvd1z,
        size_slice by exact size_shake256_slice,
        slice_cat  by exact shake256_slice_cat.

import SRS.

(* the chunked decoder is the nibble stream *)
lemma sdecodeE (bs : W8.t list) : SRS.decode bs = scands bs.
proof.
rewrite /decode chunk1E -map_comp /scands; congr.
by apply eq_map => b @/(\o) /=.
qed.

lemma srejectE (bs : W8.t list) :
  sreject bs = map scoeff (filter saccept (scands bs)).
proof. by rewrite SRS.srejectE sdecodeE. qed.


(* one byte = two candidates, low nibble first *)
lemma sreject1E (b : W8.t) :
  sreject [b]
  = (if saccept (b `&` W8.of_int 15)
     then [scoeff (b `&` W8.of_int 15)] else [])
    ++
    (if saccept (b `>>>` 4)
     then [scoeff (b `>>>` 4)] else []).
proof.
rewrite srejectE /scands /nibbles /= flatten_cons flatten_nil cats0 /=.
by case: (saccept (b `&` W8.of_int 15)); case: (saccept (b `>>>` 4)).
qed.

lemma sreject_cons (b : W8.t) (bs : W8.t list) :
  sreject (b :: bs) = sreject [b] ++ sreject bs.
proof. by rewrite -cat1s sreject_cat 1:dvd1z. qed.

lemma size_sreject_le (bs : W8.t list) :
  size (sreject bs) <= 2 * size bs.
proof.
rewrite srejectE size_map size_filter -size_scands.
by apply/count_size.
qed.

(* -------------------------------------------------------------------- *)
(* splitting the accepted stream at a byte offset of the buffer         *)
lemma sreject_block (a : W8.t Array272.t) (n m : int) :
  0 <= n => 0 <= m =>
  sreject (Array272.sub a 0 (n + m))
  = sreject (Array272.sub a 0 n) ++ sreject (Array272.sub a n m).
proof.
move=> hn hm; rewrite sub_cat_272 // (_ : 0 + n = n) 1:/#.
by rewrite sreject_cat 1:dvd1z.
qed.

(* -------------------------------------------------------------------- *)
(* the candidate stream of a 16-byte window, in decoded order           *)
lemma scands16E (b00 b01 b02 b03 b04 b05 b06 b07 b08 b09 b10 b11 b12 b13 b14 b15 : W8.t) :
  scands [b00; b01; b02; b03; b04; b05; b06; b07; b08; b09; b10; b11; b12; b13; b14; b15]
  = [b00 `&` W8.of_int 15; b00 `>>>` 4;
     b01 `&` W8.of_int 15; b01 `>>>` 4;
     b02 `&` W8.of_int 15; b02 `>>>` 4;
     b03 `&` W8.of_int 15; b03 `>>>` 4;
     b04 `&` W8.of_int 15; b04 `>>>` 4;
     b05 `&` W8.of_int 15; b05 `>>>` 4;
     b06 `&` W8.of_int 15; b06 `>>>` 4;
     b07 `&` W8.of_int 15; b07 `>>>` 4;
     b08 `&` W8.of_int 15; b08 `>>>` 4;
     b09 `&` W8.of_int 15; b09 `>>>` 4;
     b10 `&` W8.of_int 15; b10 `>>>` 4;
     b11 `&` W8.of_int 15; b11 `>>>` 4;
     b12 `&` W8.of_int 15; b12 `>>>` 4;
     b13 `&` W8.of_int 15; b13 `>>>` 4;
     b14 `&` W8.of_int 15; b14 `>>>` 4;
     b15 `&` W8.of_int 15; b15 `>>>` 4].
proof. by rewrite /scands /= /nibbles /=. qed.

(* -------------------------------------------------------------------- *)
(* SIMD decode: the 32 bytes of the result are the 32 nibble candidates *)
(* of the 16 input bytes, in stream order                               *)
lemma error_4x____bytestream_to_coefficientsP (bs_ : W128.t) :
  hoare[ M.error_4x____bytestream_to_coefficients :
    bytestream = bs_ ==> res = W32u8.pack32 (scands (W16u8.to_list bs_)) ].
proof.
proc; wp; skip => &hr |>.
by rewrite scands16E nibble_decodeE.
qed.

(* -------------------------------------------------------------------- *)
(* -------------------------------------------------------------------- *)
(* the coefficient byte of a candidate, as computed by VPSUB_32u8       *)
op cbyte (z : W8.t) : W8.t = W8.of_int 4 - z.

(* -------------------------------------------------------------------- *)
(* writing eight dwords at the end of the agreed prefix extends the     *)
(* agreement by the first k of them                                     *)
lemma agree_fill8 (p : wpoly) (old : W32.t list) (w : W256.t) (k : int) :
  0 <= k <= 8 => size old <= 248 =>
  agree p 0 old =>
  agree (Array256.fill (fun i => w \bits32 (i - size old)) (size old) 8 p)
        0 (old ++ take k (W8u32.Pack.to_list (W8u32.unpack32 w))).
proof.
move=> rgk szold; rewrite /agree => hag i rgi rgibase.
rewrite Array256.filliE 1:/#.
move: rgi; rewrite size_cat size_take 1:/# W8u32.Pack.size_to_list => rgi.
rewrite nth_cat.
case: (i < size old) => hio; last first.
- rewrite ifT 1:/# nth_take 1,2:/#.
  rewrite W8u32.Pack.to_listE nth_mkseq 1:/# /=.
  by rewrite W8u32.get_unpack32 1:/#.
rewrite ifF 1:/#.
by have := hag i _ _ => //#.
qed.

(* -------------------------------------------------------------------- *)
(* the whole compact-sign-extend-store step for one 8-candidate group   *)
lemma sagree_store (p : wpoly) (old : W32.t list) (zs : W8.t list)
                   (x : W128.t) (h : W64.t) :
  take 8 (W16u8.to_list x) = map cbyte zs =>
  size zs = 8 =>
  (forall z, z \in zs => to_uint z < 16) =>
  to_uint h = bs2int (map saccept zs) =>
  size old <= 248 =>
  agree p 0 old =>
  agree (Array256.fill
           (fun i =>
              VPMOVSX_8u8_8u32 (truncateu64 (VPSHUFB_128 x
                (VMOV_64 (W8u8.pack8 (Array2048.sub eRROR_VECTOR_SHUFFLE_TABLE
                   (to_uint (h `<<` W8.of_int 3)) 8)))))
              \bits32 (i - size old))
           (size old) 8 p)
        0 (old ++ map scoeff (filter saccept zs)).
proof.
move=> hx szzs hnib hh szold hag.
have szbits : size (map saccept zs) = 8 by rewrite size_map.
have hm : 0 <= bs2int (map saccept zs) < 256.
- by rewrite bs2int_ge0 /=; have := bs2int_le2Xs (map saccept zs); rewrite szbits.
have hint2bs : int2bs 8 (bs2int (map saccept zs)) = map saccept zs.
- by have := bs2intK (map saccept zs); rewrite szbits.
have hcle : count idfun (map saccept zs) <= 8.
- by have := count_size idfun (map saccept zs); rewrite szbits.
have hVto : forall (w : W64.t),
  W8u32.Pack.to_list (W8u32.unpack32 (VPMOVSX_8u8_8u32 w))
  = map MOVSX_u32s8 (W8u8.to_list w).
- by move=> w; rewrite /VPMOVSX_8u8_8u32 /=.
pose Y := VPSHUFB_128 x
  (VMOV_64 (W8u8.pack8 (Array2048.sub eRROR_VECTOR_SHUFFLE_TABLE
     (to_uint (h `<<` W8.of_int 3)) 8))).
have heq : take (count idfun (map saccept zs))
             (map MOVSX_u32s8 (W8u8.to_list (truncateu64 Y)))
           = map scoeff (filter saccept zs).
- rewrite -map_take -{1}hint2bs /Y (shuffle_slot8 h (map saccept zs)) //.
  rewrite (shuffle_compact8 x (bs2int (map saccept zs))) //.
  rewrite hint2bs hx -map_mask filter_mask' -map_comp.
  apply eq_in_map => z hz /=.
  by rewrite /(\o) /scoeff /cbyte MOVSX_u32s8_subE 1:#smt:(mem_mask).
rewrite -heq -hVto.
by apply agree_fill8 => //; smt(count_ge0).
qed.

(* -------------------------------------------------------------------- *)
section.

hint simplify b2i0, b2i1.

(* --- acceptance bit of each nibble comparison byte --- *)
lemma msb_lo9E (b : W8.t) :
  W8.msb ((b `&` W8.of_int 15) - W8.of_int 9) = saccept (b `&` W8.of_int 15).
proof.
by rewrite msb_sub9E 1:to_uint_lonib_lt16 /saccept.
qed.

lemma msb_hi9E (b : W8.t) :
  W8.msb ((b `>>>` 4) - W8.of_int 9) = saccept (b `>>>` 4).
proof.
by rewrite msb_sub9E 1:to_uint_hinib_lt16 /saccept.
qed.

(* --- the 32-candidate acceptance mask of a 16-byte window --- *)
lemma movemask_scands16E (b00 b01 b02 b03 b04 b05 b06 b07 b08 b09 b10 b11 b12 b13 b14 b15 : W8.t) :
  to_uint (zeroextu64 (MOVEMASK_32u8 (VPSUB_32u8
    (W32u8.pack32 (scands [b00; b01; b02; b03; b04; b05; b06; b07; b08; b09; b10; b11; b12; b13; b14; b15]))
    (VPBROADCAST_32u8 (W8.of_int 9)))))
  = bs2int (map saccept (scands [b00; b01; b02; b03; b04; b05; b06; b07; b08; b09; b10; b11; b12; b13; b14; b15])).
proof.
rewrite scands16E.
rewrite VPBROADCAST_32u8_pack32E VPSUB_32u8E /=.
rewrite /MOVEMASK_32u8 /=.
rewrite ?W32u8.pack32bE // ?W32u8.Pack.get_of_list //=.
rewrite !msb_lo9E !msb_hi9E.
by rewrite to_uint_zeroextu64 W32.to_uintE bits2wK //=.
qed.

end section.

(* -------------------------------------------------------------------- *)
(* the write-out step as a proc spec: one 8-candidate group is          *)
(* compacted, sign-extended and stored; the mask window advances        *)


lemma error_4x____write_out_8_coefficientsP
  (p_ : wpoly) (old : W32.t list) (zs zs' : W8.t list)
  (bf_ go_ : W64.t) (cb_ : W128.t) :
hoare[ M.error_4x____write_out_8_coefficients :
     error = p_ /\ bytes_filled = bf_ /\ good_overall = go_
  /\ coefficient_block = cb_
  /\ take 8 (W16u8.to_list cb_) = map cbyte zs
  /\ size zs = 8
  /\ (forall z, z \in zs => to_uint z < 16)
  /\ to_uint go_ = bs2int (map saccept (zs ++ zs'))
  /\ size old <= 248
  /\ to_uint bf_ = 4 * size old
  /\ agree p_ 0 old
  ==>
     agree res.`1 0 (old ++ map scoeff (filter saccept zs))
  /\ to_uint res.`2 = 4 * size (old ++ map scoeff (filter saccept zs))
  /\ to_uint res.`3 = bs2int (map saccept zs') ].
proof.
proc.
wp; skip => &hr |> hcb szzs hnib hgo szold hbf hag.
have szmap : size (map saccept zs) = 8 by rewrite size_map szzs.
have hand : to_uint (good_overall{hr} `&` W64.of_int 255)
            = bs2int (map saccept zs).
- rewrite (and255_bs2int _ (map saccept (zs ++ zs'))) // map_cat.
  by rewrite (_ : 8 = size (map saccept zs)) 1:szmap // take_size_cat.
have hm : 0 <= bs2int (map saccept zs) < 256.
- by rewrite bs2int_ge0 /=; have := bs2int_le2Xs (map saccept zs); rewrite szmap.
have hidx : to_uint ((good_overall{hr} `&` W64.of_int 255) `<<` W8.of_int 3)
            = 8 * bs2int (map saccept zs).
- by apply (shuffle_slot8 _ (map saccept zs)).
do ! split.
- rewrite WArray2048_get64E 1:hidx 1:/#.
  rewrite wpoly_set256_alignedE 1,2:#smt:(size_ge0).
  rewrite (_ : to_uint bytes_filled{hr} %/ 4 = size old) 1:/#.
  rewrite -truncateu64_128E.
  by apply sagree_store.
- rewrite (popcnt_step8 _ _ (map saccept zs)) // 1:/#.
  rewrite size_cat size_map size_filter.
  rewrite (count_map saccept idfun) hbf /preim /idfun /=.
  by ring.
- rewrite (shr8_bs2int _ (map saccept (zs ++ zs'))) // map_cat.
  by rewrite (_ : 8 = size (map saccept zs)) 1:szmap // drop_size_cat.
qed.

(* ==================================================================== *)
(* The vectorized rejection loop with its integrated scalar tail        *)
(* ==================================================================== *)

lemma sub16E_272 (a : W8.t Array272.t) (k : int) :
  Array272.sub a k 16 = [a.[k]; a.[k + 1]; a.[k + 2]; a.[k + 3]; a.[k + 4]; a.[k + 5]; a.[k + 6]; a.[k + 7]; a.[k + 8]; a.[k + 9]; a.[k + 10]; a.[k + 11]; a.[k + 12]; a.[k + 13]; a.[k + 14]; a.[k + 15]].
proof. by rewrite /sub /mkseq -iotaredE /=. qed.

lemma sub4E_272 (a : W8.t Array272.t) (k : int) :
  Array272.sub a k 4 = [a.[k]; a.[k + 1]; a.[k + 2]; a.[k + 3]].
proof. by rewrite /sub /mkseq -iotaredE /=. qed.


lemma scands_nib (bs : W8.t list) (z : W8.t) :
  z \in scands bs => to_uint z < 16.
proof.
rewrite /scands => /flattenP [l] [] /mapP [b] [_ ->].
rewrite /nibbles /= => -[->|->].
- exact to_uint_lonib_lt16.
- exact to_uint_hinib_lt16.
qed.

op svsampled (b : W8.t Array272.t) (p : wpoly) (bf off : int) =
     off <= 256
  /\ 4 %| off
  /\ bf <= 1020
  /\ bf = 4 * size (sreject (Array272.sub b 0 off))
  /\ agree p 0 (sreject (Array272.sub b 0 off)).

(* -------------------------------------------------------------------- *)
(* a 4-byte window carries 8 candidates, hence at most 8 coefficients   *)
lemma size_window4_le8 (b : W8.t Array272.t) (off : int) :
  size (map scoeff (filter saccept (scands (Array272.sub b off 4)))) <= 8.
proof.
rewrite size_map size_filter.
have := count_size saccept (scands (Array272.sub b off 4)).
by rewrite size_scands Array272.size_sub /#.
qed.

(* consuming one 4-byte window appends its accepted coefficients        *)
lemma sreject_window4 (b : W8.t Array272.t) (off : int) :
  0 <= off => off + 4 <= 272 =>
  sreject (Array272.sub b 0 (off + 4))
  = sreject (Array272.sub b 0 off)
    ++ map scoeff (filter saccept (scands (Array272.sub b off 4))).
proof.
by move=> h1 h2; rewrite sreject_block ~-1:/# -srejectE.
qed.

(* the vectorized advance: writing out one 4-byte window re-establishes *)
(* the loop invariant at the next offset                                *)
lemma svsampled_advance4 (b : W8.t Array272.t) (p : wpoly) (bf off off' : int) :
  off' = off + 4 =>
  0 <= off => off' <= 256 => 4 %| off =>
  4 * size (sreject (Array272.sub b 0 off)) < 992 =>
  bf = 4 * size (sreject (Array272.sub b 0 off)
         ++ map scoeff (filter saccept (scands (Array272.sub b off 4)))) =>
  agree p 0 (sreject (Array272.sub b 0 off)
         ++ map scoeff (filter saccept (scands (Array272.sub b off 4)))) =>
  svsampled b p bf off'.
proof.
move=> -> ge0_off hle hdvd hlt hbf hag.
have hle8 := size_window4_le8 b off.
rewrite /svsampled sreject_window4 ~-1:/#.
split*.
- by smt().
- by smt().
- by smt(size_cat size_ge0).
- exact hbf.
exact hag.
qed.

(* the batch offsets stay below 256, so their bumps do not wrap         *)
lemma to_uintD_small16 (w : W64.t) (n : int) :
  0 <= n <= 16 => to_uint w < 256 =>
  to_uint (w + W64.of_int n) = to_uint w + n.
proof.
by move=> hn hw; rewrite to_uintD_small of_uintK pmod_small /#.
qed.

(* -------------------------------------------------------------------- *)
(* The write-out spec in the vectorized loop's own vocabulary: writing  *)
(* out the 4-byte window at [off] of a buffer whose remaining chunk     *)
(* covers [rest] more bytes advances the sampling state to off + 4.     *)
lemma write_out_windowP (p_ : wpoly) (b : W8.t Array272.t) (off rest : int)
                        (bf_ go_ : W64.t) (cb_ : W128.t) :
hoare[ M.error_4x____write_out_8_coefficients :
     error = p_ /\ bytes_filled = bf_ /\ good_overall = go_
  /\ coefficient_block = cb_
  /\ 0 <= off /\ 4 %| off /\ 0 <= rest
  /\ off + 4 + rest <= 272 /\ off + 4 <= 256
  /\ take 8 (W16u8.to_list cb_) = map cbyte (scands (Array272.sub b off 4))
  /\ to_uint go_ = bs2int (map saccept (scands (Array272.sub b off (4 + rest))))
  /\ to_uint bf_ < 992
  /\ to_uint bf_ = 4 * size (sreject (Array272.sub b 0 off))
  /\ agree p_ 0 (sreject (Array272.sub b 0 off))
  ==>
     svsampled b res.`1 (to_uint res.`2) (off + 4)
  /\ to_uint res.`3 = bs2int (map saccept (scands (Array272.sub b (off + 4) rest))) ].
proof.
proc*.
ecall (error_4x____write_out_8_coefficientsP p_
        (sreject (Array272.sub b 0 off))
        (scands (Array272.sub b off 4))
        (scands (Array272.sub b (off + 4) rest))
        bf_ go_ cb_).
auto=> &hr |> ge0_off hdvd ge0_rest hle hle256 hcb hgo hlt hbf hag.
do ! split.
- by rewrite size_scands size_sub.
- by move=> z /scands_nib.
- by move: hgo; rewrite PA_272_136.sub_cat_272 // scands_cat.
- by smt(size_ge0).
move=> _ _ _ _ result hragree hrsz hrgo.
by apply (svsampled_advance4 _ _ _ off) => //; smt().
qed.


(* -------------------------------------------------------------------- *)
(* the candidate stream contributed by one nibble                       *)
abbrev halfstep (c : W8.t) : W32.t list =
  if saccept c then [scoeff c] else [].

(* the acceptance test and the coefficient as computed by the code      *)
lemma saccept_ultE (n : W8.t) :
  (zeroextu32 n \ult W32.of_int 9) = saccept n.
proof.
rewrite ultE of_uintK /= pmod_small.
- by have /= := W8.to_uint_cmp n; smt().
by rewrite /saccept.
qed.

lemma scoeffE (n : W8.t) :
  - (zeroextu32 n - W32.of_int 4) = scoeff n.
proof. by rewrite /scoeff; ring. qed.

(* -------------------------------------------------------------------- *)
lemma sreject_step272 (a : W8.t Array272.t) (n : int) : 0 <= n =>
  sreject (Array272.sub a 0 (n + 1))
  = sreject (Array272.sub a 0 n)
    ++ (halfstep (a.[n] `&` W8.of_int 15) ++ halfstep (a.[n] `>>>` 4)).
proof.
move=> hn; rewrite sreject_block // sub1E_272.
by rewrite sreject1E.
qed.

lemma zext_and15E (b : W8.t) :
  zeroextu32 b `&` W32.of_int 15 = zeroextu32 (b `&` W8.of_int 15).
proof.
rewrite !zext32_8E.
apply W32.wordP; apply/allP_range.
rewrite /range -iotaredE /=.
rewrite !W32.of_intwE /W32.int_bit /=.
by rewrite !W8.of_intwE /W8.int_bit /=.
qed.

lemma zext_shr4E (b : W8.t) :
  zeroextu32 b `>>` W8.of_int 4 = zeroextu32 (b `>>>` 4).
proof.
rewrite !zext32_8E /(`>>`) of_uintK /=.
apply W32.wordP; apply/allP_range.
rewrite /range -iotaredE /=.
by rewrite ?W32.get_out // ?W8.get_out //= ?orbF; rewrite !W8.get_to_uint /=.
qed.

op ssampled (b : W8.t Array272.t) (p : wpoly) (fl off : int) =
     off <= 272
  /\ fl <= 256
  /\ filled_ok p (sreject (Array272.sub b 0 off)) fl.

lemma error_4x__rejection_sample_multiple_blocksP (buf : W8.t Array272.t)
: hoare[
  M.error_4x__rejection_sample_multiple_blocks :
      randombytes = buf
    ==>
         agree res.`1 0 (sreject (Array272.sub buf 0 272))
      /\ to_uint res.`2 = min 256 (size (sreject (Array272.sub buf 0 272)))
  ].
proof.
proc => /=.
seq 7 : (randombytes = buf
  /\ eta_0 = VPBROADCAST_32u8 (W8.of_int 4)
  /\ bound = VPBROADCAST_32u8 (W8.of_int 9)).
- by auto => &hr |>; rewrite !truncateu8_bcastE.
sp 4.
seq 1 : (
     randombytes = buf
  /\ to_uint bytes_filled <= 1020
  /\ to_uint xof_offset <= 256
  /\ 4 %| to_uint xof_offset
  /\ (to_uint bytes_filled < 992 => to_uint xof_offset = 256)
  /\ to_uint bytes_filled = 4 * size (sreject (Array272.sub buf 0 (to_uint xof_offset)))
  /\ agree error 0 (sreject (Array272.sub buf 0 (to_uint xof_offset)))
).
- while (
       randombytes = buf
    /\ eta_0 = VPBROADCAST_32u8 (W8.of_int 4)
    /\ bound = VPBROADCAST_32u8 (W8.of_int 9)
    /\ svsampled buf error (to_uint bytes_filled) (to_uint xof_offset)
    /\ (to_uint bytes_filled < 992 /\ to_uint xof_offset < 256 =>
          16 %| to_uint xof_offset)
    /\ condition_loop = (stop_sampling <> W64.one)
    /\ stop_sampling = W64.of_int (b2i (!(
            to_uint bytes_filled < 992
         /\ to_uint xof_offset < 256)))
  ); last first.
  - by hoare split; auto=> &hr @/svsampled |> * /=; smt(of_int_b2i_eq1P).
  exlim xof_offset => off0.
  seq 3 : (
       randombytes = buf
    /\ eta_0 = VPBROADCAST_32u8 (W8.of_int 4)
    /\ bound = VPBROADCAST_32u8 (W8.of_int 9)
    /\ svsampled buf error (to_uint bytes_filled) (to_uint xof_offset)
    /\ to_uint bytes_filled < 992
    /\ to_uint off0 < 256
    /\ 16 %| to_uint off0
    /\ xof_offset = off0
    /\ stop_sampling = W64.of_int 0
    /\ coefficients
         = W32u8.pack32 (scands (Array272.sub buf (to_uint off0) 16))
  ).
  - ecall (error_4x____bytestream_to_coefficientsP
             (W16u8.pack16 (Array272.sub buf (to_uint off0) 16))).
    auto=> &hr |> hsv hlt hflag.
    have {hflag} [h992 h256] : to_uint bytes_filled{hr} < 992 /\ to_uint xof_offset{hr} < 256
      by smt(of_int_b2i_eq1P).
    by rewrite WArray272_get128E 1:#smt:(W64.to_uint_cmp) sub16E_272 /= /#.
  seq 5 : (
       randombytes = buf
    /\ eta_0 = VPBROADCAST_32u8 (W8.of_int 4)
    /\ bound = VPBROADCAST_32u8 (W8.of_int 9)
    /\ svsampled buf error (to_uint bytes_filled) (to_uint xof_offset)
    /\ to_uint bytes_filled < 992
    /\ to_uint off0 < 256
    /\ 16 %| to_uint off0
    /\ xof_offset = off0
    /\ stop_sampling = W64.of_int 0
    /\ to_uint good_overall
         = bs2int (map saccept (scands (Array272.sub buf (to_uint off0) 16)))
    /\ coefficients
         = W32u8.pack32 (map cbyte (scands (Array272.sub buf (to_uint off0) 16)))
    /\ coefficient_block = VEXTRACTI128 coefficients W8.zero
  ).
  - auto=> &hr |> hsv h992 h256 h16.
    by rewrite !sub16E_272 movemask_scands16E scands16E VPSUB_bcast4_pack32E /= /cbyte.
  exlim error => p0.
  exlim bytes_filled => bf0.
  exlim good_overall => go0.
  exlim coefficient_block => cb0.
  seq 2 : (
       randombytes = buf
    /\ eta_0 = VPBROADCAST_32u8 (W8.of_int 4)
    /\ bound = VPBROADCAST_32u8 (W8.of_int 9)
    /\ svsampled buf error (to_uint bytes_filled) (to_uint xof_offset)
    /\ xof_offset = off0 + W64.of_int 4
    /\ stop_sampling = W64.of_int 0
    /\ to_uint off0 < 256
    /\ 16 %| to_uint off0
    /\ to_uint good_overall
         = bs2int (map saccept (scands (Array272.sub buf (to_uint off0 + 4) 12)))
    /\ coefficients
         = W32u8.pack32 (map cbyte (scands (Array272.sub buf (to_uint off0) 16)))
    /\ coefficient_block = VEXTRACTI128 coefficients W8.zero
  ).
  - wp; ecall (write_out_windowP p0 buf (to_uint off0) 12 bf0 go0 cb0).
    auto=> &hr |> hsv h992 h256 h16 hgo.
    move: hsv => @/svsampled [#] hoffle hdvd4 hbfle hsz hag.
    do ! split; 1,2,3,4,6: smt(W64.to_uint_cmp).
    - rewrite !sub4E_272 !sub16E_272 scands16E.
      by rewrite /scands /= /nibbles /= /cbyte /=.
    - exact hag.
    move=> *.
    by rewrite (to_uintD_small16 xof_offset{hr} 4) //.
  sp 1; if; last first.
  - auto=> &hr |> hsv hlt h16 hgo hnl.
    rewrite !uleE ?ultE !of_uintK /= !to_uintD_small ?of_uintK /=.
    - by move: hlt => /#.
    move: hnl; rewrite ultE of_uintK /= => hnl.
    by smt().
  seq 1 : (#pre); 1: by auto.
  sp 1.
  exlim error => p1.
  exlim bytes_filled => bf1.
  exlim good_overall => go1.
  exlim coefficient_block => cb1.
  seq 2 : (
       randombytes = buf
    /\ eta_0 = VPBROADCAST_32u8 (W8.of_int 4)
    /\ bound = VPBROADCAST_32u8 (W8.of_int 9)
    /\ svsampled buf error (to_uint bytes_filled) (to_uint xof_offset)
    /\ xof_offset = off0 + W64.of_int 8
    /\ stop_sampling = W64.of_int 0
    /\ to_uint off0 < 256
    /\ 16 %| to_uint off0
    /\ to_uint good_overall
         = bs2int (map saccept (scands (Array272.sub buf (to_uint off0 + 8) 8)))
    /\ coefficients
         = W32u8.pack32 (map cbyte (scands (Array272.sub buf (to_uint off0) 16)))
  ).
  - wp; ecall (write_out_windowP p1 buf (to_uint off0 + 4) 8 bf1 go1 cb1).
    auto=> &hr |> hsv h256o h16 hgo hlt992.
    have hoff4 : to_uint (off0 + W64.of_int 4) = to_uint off0 + 4
      by rewrite (to_uintD_small16 off0 4).
    move: hsv; rewrite hoff4 => @/svsampled [#] hoffle hdvd4 hbfle hsz hag.
    move: hlt992; rewrite ultE of_uintK /= => hlt992.
    do ! split; 1,2,3,4,6: smt(W64.to_uint_cmp).
    - rewrite !sub4E_272 !sub16E_272 scands16E.
      rewrite /scands /= /nibbles /= /cbyte /=.
      by rewrite VEXTRACTI128_0_pack32E VPSRLDQ8_pack16E /=.
    - by smt().
    - exact hag.
    move=> *.
    by smt(to_uintD_small16).
  sp 1; if; last first.
  - auto=> &hr |> hsv h256o h16 hgo hnl.
    rewrite !uleE ?ultE !of_uintK /= !to_uintD_small ?of_uintK /=.
    - by move: h256o => /#.
    move: hnl; rewrite ultE of_uintK /= => hnl.
    by smt().
  seq 1 : (#pre); 1: by auto.
  sp 1.
  exlim error => p2.
  exlim bytes_filled => bf2.
  exlim good_overall => go2.
  exlim coefficient_block => cb2.
  seq 2 : (
       randombytes = buf
    /\ eta_0 = VPBROADCAST_32u8 (W8.of_int 4)
    /\ bound = VPBROADCAST_32u8 (W8.of_int 9)
    /\ svsampled buf error (to_uint bytes_filled) (to_uint xof_offset)
    /\ xof_offset = off0 + W64.of_int 12
    /\ stop_sampling = W64.of_int 0
    /\ to_uint off0 < 256
    /\ 16 %| to_uint off0
    /\ to_uint good_overall
         = bs2int (map saccept (scands (Array272.sub buf (to_uint off0 + 12) 4)))
    /\ coefficients
         = W32u8.pack32 (map cbyte (scands (Array272.sub buf (to_uint off0) 16)))
    /\ coefficient_block = VEXTRACTI128 coefficients W8.one
  ).
  - wp; ecall (write_out_windowP p2 buf (to_uint off0 + 8) 4 bf2 go2 cb2).
    auto=> &hr |> hsv h256o h16 hgo hlt992.
    have hoff8 : to_uint (off0 + W64.of_int 8) = to_uint off0 + 8
      by rewrite (to_uintD_small16 off0 8).
    move: hsv; rewrite hoff8 => @/svsampled [#] hoffle hdvd4 hbfle hsz hag.
    move: hlt992; rewrite ultE of_uintK /= => hlt992.
    do ! split; 1,2,3,4,6: smt(W64.to_uint_cmp).
    - rewrite !sub4E_272 !sub16E_272 scands16E.
      rewrite /scands /= /nibbles /= /cbyte /=.
      by rewrite VEXTRACTI128_1_pack32E /=.
    - by smt().
    - exact hag.
    move=> *.
    by smt(to_uintD_small16).
  sp 1; if; last first.
  - auto=> &hr |> hsv h256o h16 hgo hnl.
    rewrite !uleE ?ultE !of_uintK /= !to_uintD_small ?of_uintK /=.
    - by move: h256o => /#.
    move: hnl; rewrite ultE of_uintK /= => hnl.
    by smt().
  seq 1 : (#pre); 1: by auto.
  sp 1.
  exlim error => p3.
  exlim bytes_filled => bf3.
  exlim good_overall => go3.
  exlim coefficient_block => cb3.
  seq 2 : (
       randombytes = buf
    /\ eta_0 = VPBROADCAST_32u8 (W8.of_int 4)
    /\ bound = VPBROADCAST_32u8 (W8.of_int 9)
    /\ svsampled buf error (to_uint bytes_filled) (to_uint xof_offset)
    /\ xof_offset = off0 + W64.of_int 16
    /\ stop_sampling = W64.of_int 0
    /\ to_uint off0 < 256
    /\ 16 %| to_uint off0
  ).
  - wp; ecall (write_out_windowP p3 buf (to_uint off0 + 12) 0 bf3 go3 cb3).
    auto=> &hr |> hsv h256o h16 hgo hlt992.
    have hoff12 : to_uint (off0 + W64.of_int 12) = to_uint off0 + 12
      by rewrite (to_uintD_small16 off0 12).
    move: hsv; rewrite hoff12 => @/svsampled [#] hoffle hdvd4 hbfle hsz hag.
    move: hlt992; rewrite ultE of_uintK /= => hlt992.
    do ! split; 1,2,3,4,6: smt(W64.to_uint_cmp).
    - rewrite !sub4E_272 !sub16E_272 scands16E.
      rewrite /scands /= /nibbles /= /cbyte /=.
      by rewrite VEXTRACTI128_1_pack32E VPSRLDQ8_pack16E /=.
    - by smt().
    - exact hag.
    move=> *.
    by smt(to_uintD_small16).
  auto=> &hr |> hsv h256o h16.
  rewrite !uleE ?ultE !of_uintK /= !to_uintD_small ?of_uintK /=.
  - by move: h256o => /#.
  by smt(dvdzD dvdzz).
seq < ^while : (
     randombytes = buf
  /\ ssampled buf error (to_uint filled) (to_uint xof_offset)
  /\ condition_loop = (stop_sampling <> W64.one)
  /\ stop_sampling = W64.of_int (b2i (!(
        to_uint xof_offset < 272 /\ to_uint filled < 256)))
).
- auto=> &hr |> hbfle hoffle hdvd himp hsz hag.
  rewrite /ssampled !ultE !to_uint_shr2 !of_uintK /=.
  by smt().
while (
     randombytes = buf
  /\ ssampled buf error (to_uint filled) (to_uint xof_offset)
  /\ condition_loop = (stop_sampling <> W64.one)
  /\ stop_sampling = W64.of_int (b2i (!(
        to_uint xof_offset < 272 /\ to_uint filled < 256)))
); last first.
- skip=> &hr |> _ cl e0 f0 off0x _ hs hstop.
  have @/ssampled [#] hoffle hfle hok := hs.
  have hb : !(to_uint off0x < 272 /\ to_uint f0 < 256).
  - by apply of_int_b2i_eq1P; move: hstop; smt().
  case: (272 <= to_uint off0x) => hoff.
  - move: hok; have -> : to_uint off0x = 272 by smt().
    by move=> @/filled_ok.
  have hf : to_uint f0 = 256 by smt().
  have -> : 272 = to_uint off0x + (272 - to_uint off0x) by ring.
  rewrite sreject_block; 1,2: smt(W64.to_uint_cmp).
  by apply filled_ok_full => //.
seq 5 : (
     randombytes = buf
  /\ ssampled randombytes error (to_uint filled) (to_uint xof_offset)
  /\ to_uint filled < 256
  /\ to_uint xof_offset < 272
  /\ stop_sampling = W64.of_int 0
  /\ coefficient = zeroextu32 (randombytes.[to_uint xof_offset] `&` W8.of_int 15)
  /\ condition = (coefficient \ult W32.of_int 9)
).
- auto=> &hr |> hs hne.
  have [hf256 hoff272] : to_uint filled{hr} < 256 /\ to_uint xof_offset{hr} < 272
    by smt(of_int_b2i_eq1P).
  by rewrite /SLH64.protect_32 zext_and15E /=; smt(of_int_b2i_eq1P).
seq > ^if : (
     randombytes = buf
  /\ to_uint xof_offset < 272
  /\ stop_sampling = W64.of_int 0
  /\ to_uint filled <= 256
  /\ filled_ok error
       (sreject (Array272.sub randombytes 0 (to_uint xof_offset))
        ++ halfstep (randombytes.[to_uint xof_offset] `&` W8.of_int 15))
       (to_uint filled)
).
- if.
  - auto=> &hr |> hs hf256 hoff272.
    have @/ssampled [#] hoffle hfle hok := hs.
    rewrite saccept_ultE scoeffE => hsacc.
    rewrite hsacc /= !to_uintD_small ?of_uintK /=; 1: smt().
    split; 1: smt().
    by apply filled_ok_snoc.
  auto=> &hr |> hs hf256 hoff272.
  have @/ssampled [#] hoffle hfle hok := hs.
  rewrite saccept_ultE => hrej.
  by rewrite ifF 1:/# cats0 /#.
seq > ^if : (
     randombytes = buf
  /\ to_uint xof_offset < 272
  /\ stop_sampling = W64.of_int 0
  /\ ssampled randombytes error (to_uint filled) (to_uint xof_offset + 1)
).
- sp 1; if.
  - seq 1 : (#pre); 1: by auto.
    sp 4; if.
    - auto=> &hr |> hoff272 hfle hok hfu.
      move: hfu; rewrite ultE of_uintK /= => hf256.
      rewrite /SLH64.protect_32 zext_shr4E saccept_ultE scoeffE => hsacc.
      rewrite /ssampled sreject_step272 1:#smt:(W64.to_uint_cmp) hsacc /= catA.
      rewrite !to_uintD_small ?of_uintK /=; 1: smt().
      split*; 1,2: by smt(size_cat size_ge0).
      by apply filled_ok_snoc.
    auto=> &hr |> hoff272 hfle hok hfu.
    move: hfu; rewrite ultE of_uintK /= => hf256.
    rewrite /SLH64.protect_32 zext_shr4E saccept_ultE => hrej.
    have hsrej : saccept (randombytes{hr}.[to_uint xof_offset{hr}] `>>>` 4) = false by smt().
    rewrite /ssampled sreject_step272 1:#smt:(W64.to_uint_cmp) hsrej /= cats0.
    by smt().
  auto=> &hr |> hoff272 hfle hok hnf.
  move: hnf; rewrite ultE of_uintK /= => hnf.
  have hf256 : to_uint filled{hr} = 256 by smt().
  rewrite /ssampled sreject_step272 1:#smt:(W64.to_uint_cmp) catA.
  split*; 1,2: by smt(size_cat size_ge0).
  by apply filled_ok_full => //.
auto=> &hr |> hoff272 hs.
have @/ssampled [#] hoffle hfle hok := hs.
rewrite !uleE !of_uintK /= !to_uintD_small ?of_uintK /=; 1: smt().
by smt().
qed.

(* -------------------------------------------------------------------- *)
(* The one-block scalar sampler: one 136-byte squeezed block extends    *)
(* the accepted stream, with filled capped at 256                       *)


lemma sreject_stepS136 (S : W8.t list) (a : W8.t Array136.t) (n : int) : 0 <= n =>
  sreject (S ++ Array136.sub a 0 (n + 1))
  = sreject (S ++ Array136.sub a 0 n)
    ++ (halfstep (a.[n] `&` W8.of_int 15) ++ halfstep (a.[n] `>>>` 4)).
proof.
move=> hn.
rewrite (PA_272_136.sub_cat_136 a 0 n 1) // (_ : 0 + n = n) 1:/#.
by rewrite catA sreject_cat 1:dvd1z sub1E_136 sreject1E.
qed.

lemma error_4x__rejection_sample_one_blockP (S : W8.t list) (blk : W8.t Array136.t) :
  hoare[ M.error_4x__rejection_sample_one_block :
      randombytes = blk
   /\ to_uint filled < 256
   /\ agree error 0 (sreject S)
   /\ to_uint filled = min 256 (size (sreject S))
   ==>
      agree res.`1 0 (sreject (S ++ Array136.to_list blk))
   /\ to_uint res.`2 = min 256 (size (sreject (S ++ Array136.to_list blk))) ].
proof.
proc.
seq < ^while : (
     randombytes = blk
  /\ to_uint xof_offset <= 136
  /\ filled_ok error
       (sreject (S ++ Array136.sub randombytes 0 (to_uint xof_offset)))
       (to_uint filled)
  /\ condition_loop = (stop_sampling <> W64.one)
  /\ stop_sampling = W64.of_int (b2i (!(
        to_uint xof_offset < 136 /\ to_uint filled < 256)))
).
- by auto=> &hr |> hf256 hag hf; rewrite cats0 /#.
while (
     randombytes = blk
  /\ to_uint xof_offset <= 136
  /\ filled_ok error
       (sreject (S ++ Array136.sub randombytes 0 (to_uint xof_offset)))
       (to_uint filled)
  /\ condition_loop = (stop_sampling <> W64.one)
  /\ stop_sampling = W64.of_int (b2i (!(
        to_uint xof_offset < 136 /\ to_uint filled < 256)))
); last first.
- skip=> &hr |> hoff0 hok0 cl e0 f0 off0x _ hoffle hok hstop.
  have hb : !(to_uint off0x < 136 /\ to_uint f0 < 256).
  - by apply of_int_b2i_eq1P; move: hstop; smt().
  case: (136 <= to_uint off0x) => hoff.
  - move: hok; have -> : to_uint off0x = 136 by smt().
    by rewrite PA_272_136.sub_full_136 => @/filled_ok.
  rewrite (PA_272_136.sub_split_136 randombytes{hr} (to_uint off0x))
    1:#smt:(W64.to_uint_cmp).
  rewrite catA sreject_cat 1:dvd1z.
  by apply filled_ok_full => //; smt().
seq 5 : (
     randombytes = blk
  /\ filled_ok error
       (sreject (S ++ Array136.sub randombytes 0 (to_uint xof_offset)))
       (to_uint filled)
  /\ to_uint filled < 256
  /\ to_uint xof_offset < 136
  /\ stop_sampling = W64.of_int 0
  /\ coefficient = zeroextu32 (randombytes.[to_uint xof_offset] `&` W8.of_int 15)
  /\ condition = (coefficient \ult W32.of_int 9)
).
- auto=> &hr |> hoffle hok hne.
  have [hf256 hoff136] : to_uint filled{hr} < 256 /\ to_uint xof_offset{hr} < 136
    by smt(of_int_b2i_eq1P).
  by rewrite /SLH64.protect_32 zext_and15E /=; smt(of_int_b2i_eq1P).
seq > ^if : (
     randombytes = blk
  /\ to_uint xof_offset < 136
  /\ stop_sampling = W64.of_int 0
  /\ to_uint filled <= 256
  /\ filled_ok error
       (sreject (S ++ Array136.sub randombytes 0 (to_uint xof_offset))
        ++ halfstep (randombytes.[to_uint xof_offset] `&` W8.of_int 15))
       (to_uint filled)
).
- if.
  - auto=> &hr |> hok hf256 hoff136.
    rewrite saccept_ultE scoeffE => hsacc.
    rewrite hsacc /= !to_uintD_small ?of_uintK /=; 1: smt().
    split; 1: smt().
    by apply filled_ok_snoc.
  auto=> &hr |> hok hf256 hoff136.
  rewrite saccept_ultE => hrej.
  by rewrite ifF 1:/# cats0 /#.
seq > ^if : (
     randombytes = blk
  /\ to_uint xof_offset < 136
  /\ stop_sampling = W64.of_int 0
  /\ filled_ok error
       (sreject (S ++ Array136.sub randombytes 0 (to_uint xof_offset + 1)))
       (to_uint filled)
  /\ to_uint filled <= 256
).
- sp 1; if.
  - seq 1 : (#pre); 1: by auto.
    sp 4; if.
    - auto=> &hr |> hoff136 hle256 hok hfu.
      move: hfu; rewrite ultE of_uintK /= => hf256.
      rewrite /SLH64.protect_32 zext_shr4E saccept_ultE scoeffE => hsacc.
      rewrite sreject_stepS136 1:#smt:(W64.to_uint_cmp) hsacc /= catA.
      rewrite !to_uintD_small ?of_uintK /=; 1: smt().
      split; 2: smt().
      by apply filled_ok_snoc.
    auto=> &hr |> hoff136 hle256 hok hfu.
    move: hfu; rewrite ultE of_uintK /= => hf256.
    rewrite /SLH64.protect_32 zext_shr4E saccept_ultE => hrej.
    have hsrej : saccept (randombytes{hr}.[to_uint xof_offset{hr}] `>>>` 4) = false by smt().
    rewrite sreject_stepS136 1:#smt:(W64.to_uint_cmp) hsrej /= cats0.
    by smt().
  auto=> &hr |> hoff136 hle256 hok hnf.
  move: hnf; rewrite ultE of_uintK /= => hnf.
  have hf256 : to_uint filled{hr} = 256 by smt().
  rewrite sreject_stepS136 1:#smt:(W64.to_uint_cmp) catA.
  by apply filled_ok_full => //.
auto=> &hr |> hoff136 hok hle.
rewrite !uleE !of_uintK /= !to_uintD_small ?of_uintK /=; 1: smt().
by smt().
qed.

(* -------------------------------------------------------------------- *)
(* The one-block spec in the staged-lane vocabulary: consuming the      *)
(* block squeezed at index k of a lane's stream advances that lane's    *)
(* sampling state to k + 1.                                             *)
lemma one_block_laneP (nonce : W8.t list) (k : int) (blk : W8.t Array136.t) :
hoare[ M.error_4x__rejection_sample_one_block :
     randombytes = blk
  /\ Array136.to_list blk = shake256_slice nonce (136 * k) 136
  /\ 0 <= k
  /\ to_uint filled < 256
  /\ sreject_ok nonce (136 * k) error (to_uint filled)
  ==>
     sreject_ok nonce (136 * (k + 1)) res.`1 (to_uint res.`2) ].
proof.
proc*.
ecall (error_4x__rejection_sample_one_blockP
        (shake256_slice nonce 0 (136 * k)) blk).
auto=> &hr |> hblk hk hlt hok.
move: hok => @/sreject_ok /= [hag hf].
do ! split => //.
move=> _ _ result hr1 hr2.
have hcat := shake256_slice_cat_block nonce k _ hk hblk.
by rewrite /sreject_ok -hcat.
qed.

(* ==================================================================== *)
(* The staged four-lane sampler and the Spoly isolation axiom           *)
(* ==================================================================== *)
hint simplify b2i0, b2i1.

(* -------------------------------------------------------------------- *)
op Spoly (rho' : W8.t Array64.t) (sep : W16.t) : wpoly.

(* the error polynomial is the first 256 accepted candidates of the     *)
(* lane's XOF stream; well-defined across slice lengths by              *)
(* shake256_slice_cat                                                   *)
axiom SpolyP (rho' : W8.t Array64.t) (sep : W16.t) (m j : int) :
  256 <= size (sreject (shake256_slice
                 (to_list rho' ++ W2u8.to_list sep) 0 m)) =>
  0 <= j < 256 =>
  (Spoly rho' sep).[j]
  = nth W32.zero
      (sreject (shake256_slice (to_list rho' ++ W2u8.to_list sep) 0 m)) j.

(* -------------------------------------------------------------------- *)

(* -------------------------------------------------------------------- *)
lemma error_4x____sample_polynomialsP (rho_ : W8.t Array64.t) (ds0 : W16.t) :
hoare[ M.error_4x____sample_polynomials :
     rho_prime = rho_ /\ starting_domain_separator = ds0
  ==>
     forall i, 0 <= i < 4 =>
       nth witness [res.`1; res.`2; res.`3; res.`4] i
       = Spoly rho_ (ds0 + W16.of_int i) ].
proof.
hint +listred -delta nth.
proc=> /=.
pose stop fs := W64.of_int (b2i (!has (fun (w : W64.t) => w \ult W64.of_int 256) fs)).
proc change [^stop_sampling<- .. ^stop_sampling<- & +1] : {
  stop_sampling <- stop [filled0; filled1; filled2; filled3];
}; first by auto=> &hr @/stop |> *.
pose nonce (i : int) := to_list rho_ ++ W2u8.to_list (ds0 + W16.of_int i).
pose data := Array4.init nonce.

(* initial absorption *)
sp.
seq 1 : (xof_state \sha3for Array4.init (mk_absorbed \o nonce)).
- ecall (shake256_absorb_66_4xP rho_ ds0) => /=.
  auto=> &hr |> rst; apply/sha3for_eqR/Array4.ext_eq=> i ?.
  by rewrite mapiE -1:initiE //= initiE.

(* squeeze the first two blocks *)
seq 1 : (
     xof_state \sha3for Array4.init (mk_read (136 * 2) \o nonce)
  /\ (forall i, 0 <= i < 4 =>
        let b = nth witness [buf0; buf1; buf2; buf3] i in
        Array272.sub b 0 272 = shake256_slice data.[i] 0 272)).
- ecall ->> (error_4x____shake256_squeeze_multiple_blocks_4xP data) => /=.
  - move=> &hr |>; apply: sha3for_eqR.
    by apply: Array4.ext_eq; smt(Array4.mapiE Array4.initiE).
  auto=> |> &hr + ?; apply/sha3for_eqR/Array4.ext_eq.
  by move=> i rgi; rewrite mapiE // !initiE.

(* the four vectorized passes *)
seq ^stop_sampling<- : (#{/~{buf0, buf1, buf2, buf3}}pre /\
  (forall i, 0 <= i < 4 =>
     let p = nth witness [polynomial0; polynomial1; polynomial2; polynomial3] i in
     let f = nth witness [filled0; filled1; filled2; filled3] i in
        sreject_ok data.[i] (136 * 2) p (to_uint f))).
- hoare split; last by conseq |>.
  exlim buf0, buf1, buf2, buf3 => buf0_ buf1_ buf2_ buf3_.
  ecall ->> (error_4x__rejection_sample_multiple_blocksP buf0_) => /= [|>|]; sp.
  seq 0 : (#{/~{filled}}pre /\ to_uint filled0 = min 256 (size (sreject (Array272.sub buf0_ 0 272)))).
  - by auto.
  ecall ->> (error_4x__rejection_sample_multiple_blocksP buf1_) => /= [|>|]; sp.
  seq 0 : (#{/~{filled}}pre /\ to_uint filled1 = min 256 (size (sreject (Array272.sub buf1_ 0 272)))).
  - by auto.
  ecall ->> (error_4x__rejection_sample_multiple_blocksP buf2_) => /= [|>|]; sp.
  seq 0 : (#{/~{filled}}pre /\ to_uint filled2 = min 256 (size (sreject (Array272.sub buf2_ 0 272)))).
  - by auto.
  ecall ->> (error_4x__rejection_sample_multiple_blocksP buf3_) => /= [|>|]; sp.
  seq 0 : (#{/~{filled}}pre /\ to_uint filled3 = min 256 (size (sreject (Array272.sub buf3_ 0 272)))).
  - by auto.
  auto=> &hr |> 5? h 4? i ile ilt; have: 0 <= i < 4 by smt().
  move=> {ile ilt}; apply: allP_range i => /=.
  by with hint +listred (rewrite /= /sreject_ok -!h /=).

while (exists (k : int), (
     2 <= k
  /\ xof_state \sha3for Array4.init (mk_read (136 * k) \o nonce)
  /\ (forall i, 0 <= i < 4 =>
        let p = nth witness [polynomial0; polynomial1; polynomial2; polynomial3] i in
        let f = nth witness [filled0; filled1; filled2; filled3] i in
        sreject_ok data.[i] (136 * k) p (to_uint f))
  /\ (stop_sampling = stop [filled0; filled1; filled2; filled3])
)); last first.
- auto=> &hr |> *; split.
  - by exists 2 => /=.
  move=> f0 f1 f2 f3 p0 p1 p2 p3 xf k hk hxf h hstop.
  have {hstop} hfull : forall f, f \in [f0; f1; f2; f3] => 256 <= to_uint f.
  - move=> f hf; rewrite lezNgt; apply/negP => hlt.
    have hhas : has (fun (w : W64.t) => w \ult W64.of_int 256) [f0; f1; f2; f3].
    - by apply/hasP; exists f; rewrite hf /= ultE of_uintK /=.
    by move: hstop => @/stop; rewrite hhas /=.
  have hbridge : forall (p : wpoly) (f : W64.t) (i : int),
    0 <= i < 4 =>
    agree p 0 (sreject (shake256_slice data.[i] 0 (136 * k))) =>
    to_uint f = min 256 (size (sreject (shake256_slice data.[i] 0 (136 * k)))) =>
    256 <= to_uint f =>
    p = Spoly rho_ (ds0 + W16.of_int i).
  - move=> p f i rgi hag hf hf256.
    have hdata : data.[i] = to_list rho_ ++ W2u8.to_list (ds0 + W16.of_int i).
    - by rewrite /data initiE ~-1://= /nonce.
    have hsz : 256 <= size (sreject (shake256_slice data.[i] 0 (136 * k))) by smt().
    apply Array256.ext_eq => j rgj.
    rewrite (SpolyP rho_ (ds0 + W16.of_int i) (136 * k) j) //; 1: by move: hsz; rewrite hdata.
    rewrite -hdata.
    by move: hag => @/agree hag; smt().
  move=> i ile ilt.
  have /= := h i _; 1: smt().
  rewrite /sreject_ok => -[hag hf].
  by apply (hbridge (nth witness [p0; p1; p2; p3] i)
                    (nth witness [f0; f1; f2; f3] i) i) => //; 1: smt().
elim* => k.
proc rewrite 3 PA_272_136.injecta_272E.
proc rewrite 4 PA_272_136.injecta_272E.
proc rewrite 5 PA_272_136.injecta_272E.
proc rewrite 6 PA_272_136.injecta_272E.
proc change [^stop_sampling<- .. ^stop_sampling<- & +1] : {
  stop_sampling <- stop [filled0; filled1; filled2; filled3];
}; first by auto=> &hr @/stop |>.

(* squeeze one more 136-byte block into each lane *)
seq ^xof_state<- : (
     2 <= k
  /\ (forall i, 0 <= i < 4 =>
        sreject_ok data.[i] (136 * k)
          (nth witness [polynomial0; polynomial1; polynomial2; polynomial3] i)
          (to_uint (nth witness [filled0; filled1; filled2; filled3] i)))
  /\ aux \sha3for Array4.init (mk_read (136 * (k + 1)) \o nonce)
  /\ (forall i, 0 <= i < 4 =>
        Array136.to_list (nth witness [aux_0; aux_1; aux_2; aux_3] i)
        = shake256_slice data.[i] (136 * k) 136)
).
- ecall (shake256_squeezeblock4xP data k).
  auto=> &hr |> hk hxf h hne.
  split.
  - split; 1: smt().
    apply (sha3for_eqR xof_state{hr} (Array4.init (mk_read (136 * k) \o nonce))) => //.
    by apply Array4.ext_eq => i rgi; rewrite mapiE // initiE //= /data initiE.
  move=> _ _ result hr1 hr2.
  apply (sha3for_eqR result.`1 (Array4.map (mk_read (136 * (k + 1))) data)) => //.
  by apply Array4.ext_eq => i rgi; rewrite mapiE // initiE //= /data initiE.

(* install the squeezed blocks *)
seq > ^buf3<- : (
     2 <= k
  /\ slanes_ok data k 0 [polynomial0; polynomial1; polynomial2; polynomial3] [filled0; filled1; filled2; filled3]
  /\ xof_state \sha3for Array4.init (mk_read (136 * (k + 1)) \o nonce)
  /\ sblocks_ok data k [buf0; buf1; buf2; buf3]
).
- auto=> &hr |> hk h hxf hblk; split; first by smt().
  move: (hblk 0) (hblk 1) (hblk 2) (hblk 3) => /= 4?.
  by with hint +listred (rewrite /sblocks_ok; apply/allP_range => /=; rewrite !trunc_inject).


  (* lane 0 *)
  exlim buf0 => b0_.
  seq 1 : (
       2 <= k
    /\ slanes_ok data k 1 [polynomial0; polynomial1; polynomial2; polynomial3] [filled0; filled1; filled2; filled3]
    /\ xof_state \sha3for Array4.init (mk_read (136 * (k + 1)) \o nonce)
    /\ sblocks_ok data k [buf0; buf1; buf2; buf3]
  ).
  - if.
    - sp 1; wp.
      ecall (one_block_laneP data.[0] k (PA_272_136.truncatea_136 b0_)).
      auto=> &hr |> hk2 hln hxf hblk hlt.
      move: hlt; rewrite ultE of_uintK /= => hlt.
      move: (hblk 0 _) (hln 0 _) => // /= hb0 h0.
      move: h0 => @/sreject_ok /= [hag hf].
      do ! split => //; 1: smt().
      move=> _ _ _ _ _ result hok.
      apply slanes_okP => /=.
      - by move: hok => //#.
      - by move: (hln 1 _) => //#.
      - by move: (hln 2 _) => //#.
      by move: (hln 3 _) => //#.
    auto=> &hr |> hk2 hln hxf hblk hge.
    move: hge; rewrite ultE of_uintK /= => hge.
    apply (slanes_ok_advance_full data k 0) => //=; 1:smt().
    by move: (hln 0 _) => // @/sreject_ok /=; smt().

  (* lane 1 *)
  exlim buf1 => b1_.
  seq 1 : (
       2 <= k
    /\ slanes_ok data k 2 [polynomial0; polynomial1; polynomial2; polynomial3] [filled0; filled1; filled2; filled3]
    /\ xof_state \sha3for Array4.init (mk_read (136 * (k + 1)) \o nonce)
    /\ sblocks_ok data k [buf0; buf1; buf2; buf3]
  ).
  - if.
    - sp 1; wp.
      ecall (one_block_laneP data.[1] k (PA_272_136.truncatea_136 b1_)).
      auto=> &hr |> hk2 hln hxf hblk hlt.
      move: hlt; rewrite ultE of_uintK /= => hlt.
      move: (hblk 1 _) (hln 1 _) => // /= hb1 h1.
      move: h1 => @/sreject_ok /= [hag hf].
      do ! split => //; 1: smt().
      move=> _ _ _ _ _ result hok.
      apply slanes_okP => /=.
      - by move: (hln 0 _) => //#.
      - by move: hok => //#.
      - by move: (hln 2 _) => //#.
      by move: (hln 3 _) => //#.
    auto=> &hr |> hk2 hln hxf hblk hge.
    move: hge; rewrite ultE of_uintK /= => hge.
    apply (slanes_ok_advance_full data k 1) => //=; 1:smt().
    by move: (hln 1 _) => // @/sreject_ok /=; smt().

  (* lane 2 *)
  exlim buf2 => b2_.
  seq 1 : (
       2 <= k
    /\ slanes_ok data k 3 [polynomial0; polynomial1; polynomial2; polynomial3] [filled0; filled1; filled2; filled3]
    /\ xof_state \sha3for Array4.init (mk_read (136 * (k + 1)) \o nonce)
    /\ sblocks_ok data k [buf0; buf1; buf2; buf3]
  ).
  - if.
    - sp 1; wp.
      ecall (one_block_laneP data.[2] k (PA_272_136.truncatea_136 b2_)).
      auto=> &hr |> hk2 hln hxf hblk hlt.
      move: hlt; rewrite ultE of_uintK /= => hlt.
      move: (hblk 2 _) (hln 2 _) => // /= hb2 h2.
      move: h2 => @/sreject_ok /= [hag hf].
      do ! split => //; 1: smt().
      move=> _ _ _ _ _ result hok.
      apply slanes_okP => /=.
      - by move: (hln 0 _) => //#.
      - by move: (hln 1 _) => //#.
      - by move: hok => //#.
      by move: (hln 3 _) => //#.
    auto=> &hr |> hk2 hln hxf hblk hge.
    move: hge; rewrite ultE of_uintK /= => hge.
    apply (slanes_ok_advance_full data k 2) => //=; 1:smt().
    by move: (hln 2 _) => // @/sreject_ok /=; smt().

  (* lane 3 *)
  exlim buf3 => b3_.
  seq 1 : (
       2 <= k
    /\ slanes_ok data k 4 [polynomial0; polynomial1; polynomial2; polynomial3] [filled0; filled1; filled2; filled3]
    /\ xof_state \sha3for Array4.init (mk_read (136 * (k + 1)) \o nonce)
    /\ sblocks_ok data k [buf0; buf1; buf2; buf3]
  ).
  - if.
    - sp 1; wp.
      ecall (one_block_laneP data.[3] k (PA_272_136.truncatea_136 b3_)).
      auto=> &hr |> hk2 hln hxf hblk hlt.
      move: hlt; rewrite ultE of_uintK /= => hlt.
      move: (hblk 3 _) (hln 3 _) => // /= hb3 h3.
      move: h3 => @/sreject_ok /= [hag hf].
      do ! split => //; 1: smt().
      move=> _ _ _ _ _ result hok.
      apply slanes_okP => /=.
      - by move: (hln 0 _) => //#.
      - by move: (hln 1 _) => //#.
      - by move: (hln 2 _) => //#.
      by move: hok => //#.
    auto=> &hr |> hk2 hln hxf hblk hge.
    move: hge; rewrite ultE of_uintK /= => hge.
    apply (slanes_ok_advance_full data k 3) => //=; 1:smt().
    by move: (hln 3 _) => // @/sreject_ok /=; smt().

(* the flag re-encodes; the invariant advances to k + 1 *)
auto=> &hr |> hk2 hln hxf hblk.
exists (k + 1); do ! split => //; 1: smt().
by move=> i rgi; move: (slanes_ok_wrap data k _ _ hln i rgi) => /#.
qed.

(* ==================================================================== *)
(* The error-vector assembly: three staged batches fill s1 and s2       *)
(* ==================================================================== *)

(* -------------------------------------------------------------------- *)
clone Prefixarray.PrefixArray as PW_1280_256 with
      op sizeB <- 256,
      op sizeS <- 1280,
  theory AB    <- Array256,
  theory AS    <- Array1280
  proof le_size by done.

clone Prefixarray.PrefixArray as PW_1536_256 with
      op sizeB <- 256,
      op sizeS <- 1536,
  theory AB    <- Array256,
  theory AS    <- Array1536
  proof le_size by done.

abbrev poly_of_s1 (s : W32.t Array1280.t) (r : int) : wpoly =
  PW_1280_256.winof s r.
abbrev poly_of_s2 (s : W32.t Array1536.t) (r : int) : wpoly =
  PW_1536_256.winof s r.

(* -------------------------------------------------------------------- *)
lemma sample____error_vectorsP (rho_ : W8.t Array64.t) :
hoare[ M.sample____error_vectors :
    rho_prime = rho_
  ==>
     (forall r, 0 <= r < 5 =>
        poly_of_s1 res.`1 r = Spoly rho_ (W16.of_int r))
  /\ (forall r, 0 <= r < 6 =>
        poly_of_s2 res.`2 r = Spoly rho_ (W16.of_int (5 + r))) ].
proof.
proc.
sp.
seq 5 : (rho_prime = rho_
  /\ forall r, 0 <= r < 4 => poly_of_s1 s1 r = Spoly rho_ (W16.of_int r)).
- wp; ecall (error_4x____sample_polynomialsP rho_ (W16.of_int 0)).
  auto=> &hr |> result hres r rgr rgr2.
  do 4! (rewrite PW_1280_256.winof_write ~-1:/#).
  by move: (hres 0 _) (hres 1 _) (hres 2 _) (hres 3 _) => //#.
seq 5 : (rho_prime = rho_
  /\ (forall r, 0 <= r < 5 => poly_of_s1 s1 r = Spoly rho_ (W16.of_int r))
  /\ (forall r, 0 <= r < 3 => poly_of_s2 s2 r = Spoly rho_ (W16.of_int (5 + r)))).
- wp; ecall (error_4x____sample_polynomialsP rho_ (W16.of_int 4)).
  auto=> &hr |> h1s result hres.
  split.
  - move=> r rgr rgr2.
    rewrite PW_1280_256.winof_write ~-1:/#.
    by move: (hres 0 _) => //; smt().
  move=> r rgr rgr2.
  do 3! (rewrite PW_1536_256.winof_write ~-1:/#).
  by move: (hres 1 _) (hres 2 _) (hres 3 _) => //#.
wp; ecall (error_4x____sample_polynomialsP rho_ (W16.of_int 8)).
auto=> &hr |> h1s h2s result hres.
move=> r rgr rgr2.
do 3! (rewrite PW_1536_256.winof_write ~-1:/#).
by move: (hres 0 _) (hres 1 _) (hres 2 _) => //#.
qed.
