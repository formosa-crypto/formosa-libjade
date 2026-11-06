require import AllCore CoreUtils List List_extra IntDiv IntMin BitEncoding.
import BS2Int.
from Jasmin require import JWord JModel_x86.
from Spec require import GFq Rq Parameters MLDSA_W32_Rep.
from CryptoSpecs require import Keccak1600_Spec.
require import MldsaConstants Agree Avx2red Errshuffle Prefixarray Rejstream Warraypack.
require import CircuitBindings Bindings JWordExtra.
require import Array4 Array25 Array64 Array136 Array256 Array272 Array2048.
require import WArray272 WArray1024 WArray2048.
require BaseT PreludeT ErrorVectorsT Sha3x4.

(* -------------------------------------------------------------------- *)
(* The four-lane core of the sampler of s1 and s2: each lane is the     *)
(* RejBoundedPoly of its SHAKE256 stream, the nibbles below rej_bound   *)
(* accepted. A nibble z gives 4 - z for Eta = 4, and 2 - (z mod 5) for  *)
(* Eta = 2, where the code reduces modulo 5. It realizes the hypothesis *)
(* of ErrorVectorsT.                                                    *)
(* -------------------------------------------------------------------- *)
abstract theory ErrorSamplerT.

clone import BaseT.BaseT as B.
import S R MLDSAParams.
clone PreludeT.PreludeT as PR with theory B <- B.
clone import Sha3x4.Sha3x4T as SX with theory P <- S, theory R <- R.
import Shake256x4.

lemma Eta_cases : Eta = 2 \/ Eta = 4 by smt(param_sets).

lemma rej_boundE : rej_bound = if Eta = 2 then 15 else 9 by done.

(* -------------------------------------------------------------------- *)
clone import Prefixarray.PrefixArray as PA_272_136 with
      op sizeB <- 136,
      op sizeS <- 272,
  theory AB    <- Array136,
  theory AS    <- Array272

  rename "'S" as "_272"
         "'B" as "_136"

  proof *.
realize le_size by done.

(* -------------------------------------------------------------------- *)
clone Warraypack.WArrayPack as WP272 with
      op size <- 272,
  theory A    <- Array272,
  theory WA   <- WArray272
  rename "get" as "WArray272_get"
  proof *.
realize A.WArray272_get_out by exact Array272.get_out.
realize WA.WArray272_get_out by exact WArray272.get_out.
realize WA.WArray272_get16E by exact WArray272.get16E.
realize WA.WArray272_get32E by exact WArray272.get32E.
realize WA.WArray272_get64E by exact WArray272.get64E.
realize WA.WArray272_get128E by exact WArray272.get128E.
realize WA.WArray272_get256E by exact WArray272.get256E.
realize WA.ArrayW8.WArray272_get_out by exact WArray272.ArrayW8.get_out.

clone Warraypack.WArrayPack as WP2048 with
      op size <- 2048,
  theory A    <- Array2048,
  theory WA   <- WArray2048
  rename "get" as "WArray2048_get"
  proof *.
realize A.WArray2048_get_out by exact Array2048.get_out.
realize WA.WArray2048_get_out by exact WArray2048.get_out.
realize WA.WArray2048_get16E by exact WArray2048.get16E.
realize WA.WArray2048_get32E by exact WArray2048.get32E.
realize WA.WArray2048_get64E by exact WArray2048.get64E.
realize WA.WArray2048_get128E by exact WArray2048.get128E.
realize WA.WArray2048_get256E by exact WArray2048.get256E.
realize WA.ArrayW8.WArray2048_get_out by exact WArray2048.ArrayW8.get_out.

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
(* candidates, low nibble first; a candidate z is accepted when it is   *)
(* below rej_bound and then contributes the signed coefficient          *)
(* Eta - sred z                                                         *)

op saccept (z : W8.t) : bool = to_uint z < rej_bound.

op sred (z : W8.t) : W8.t = if Eta = 2 then z \umod W8.of_int 5 else z.

op scoeff (z : W8.t) : W32.t = W32.of_int Eta - zeroextu32 (sred z).

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
  type coeff_t <- W32.t,
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

  proof *.
realize gt0_align  by done.
realize ge0_rate   by done.
realize align_rate by apply dvd1z.
realize size_slice by exact size_shake256_slice.
realize slice_cat  by exact shake256_slice_cat.

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
op cbyte (z : W8.t) : W8.t = W8.of_int Eta - z.

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
(* the shuffle of one 8-candidate group: its accepted coefficient bytes *)
(* come first                                                           *)
op shuffled (x : W128.t) (h : W64.t) : W64.t =
  truncateu64 (VPSHUFB_128 x
    (VMOV_64 (W8u8.pack8 (Array2048.sub eRROR_VECTOR_SHUFFLE_TABLE
       (to_uint (h `<<` W8.of_int 3)) 8)))).

lemma shuffledP (zs : W8.t list) (x : W128.t) (h : W64.t) :
  take 8 (W16u8.to_list x) = map cbyte zs =>
  size zs = 8 =>
  to_uint h = bs2int (map saccept zs) =>
  take (count idfun (map saccept zs)) (W8u8.to_list (shuffled x h))
  = map cbyte (filter saccept zs).
proof.
move=> hx szzs hh.
have szbits : size (map saccept zs) = 8 by rewrite size_map.
have hint2bs : int2bs 8 (bs2int (map saccept zs)) = map saccept zs.
- by have := bs2intK (map saccept zs); rewrite szbits.
rewrite -{1}hint2bs /shuffled (shuffle_slot8 h (map saccept zs)) //.
rewrite (shuffle_compact8 x (bs2int (map saccept zs))) //.
- have := bs2int_le2Xs (map saccept zs); rewrite szbits bs2int_ge0 /= => /#.
by rewrite hint2bs hx -map_mask filter_mask'.
qed.

(* -------------------------------------------------------------------- *)
(* the store of one 8-candidate group, whose first dwords are the       *)
(* coefficients of its accepted candidates                              *)
lemma sagree_storeW (p : wpoly) (old : W32.t list) (zs : W8.t list) (w : W256.t) :
  size zs = 8 =>
  take (count idfun (map saccept zs)) (W8u32.Pack.to_list (W8u32.unpack32 w))
  = map scoeff (filter saccept zs) =>
  size old <= 248 =>
  agree p 0 old =>
  agree (Array256.fill (fun i => w \bits32 (i - size old)) (size old) 8 p)
        0 (old ++ map scoeff (filter saccept zs)).
proof.
move=> szzs heq szold hag; rewrite -heq.
have hcle : count idfun (map saccept zs) <= 8.
- by have := count_size idfun (map saccept zs); rewrite size_map szzs.
by apply agree_fill8 => //; smt(count_ge0).
qed.

(* for Eta = 4, the coefficient is the sign extension of its byte       *)
lemma sagree_store4 (p : wpoly) (old : W32.t list) (zs : W8.t list)
                    (x : W128.t) (h : W64.t) :
  Eta = 4 =>
  take 8 (W16u8.to_list x) = map cbyte zs =>
  size zs = 8 =>
  (forall z, z \in zs => to_uint z < 16) =>
  to_uint h = bs2int (map saccept zs) =>
  size old <= 248 =>
  agree p 0 old =>
  agree (Array256.fill
           (fun i => VPMOVSX_8u8_8u32 (shuffled x h) \bits32 (i - size old))
           (size old) 8 p)
        0 (old ++ map scoeff (filter saccept zs)).
proof.
move=> heta hx szzs hnib hh szold hag; apply sagree_storeW => //.
rewrite VPMOVSX_8u8_8u32_to_listE -map_take (shuffledP zs) // -map_comp.
apply eq_in_map => z /mem_filter [_ hz] @/(\o) @/scoeff @/cbyte @/sred.
by rewrite heta /= MOVSX_u32s8_subE //; smt(mem_mask).
qed.

(* for Eta = 2, the code reduces the sign extension modulo 5: a dword   *)
(* c = 2 - z with z < 15 becomes 2 - (z mod 5)                          *)
op red5_ok (w r : W256.t) (i : int) =
  (W32.of_int 2 - (w \bits32 i)) \ult W32.of_int 15 =>
  r \bits32 i = W32.of_int 2 - ((W32.of_int 2 - (w \bits32 i)) \umod W32.of_int 5).

lemma reduce_coefficientsP (w : W256.t) :
  hoare[ M.error_4x____reduce_coefficients :
    coefficients = w
    ==>
       red5_ok w res 0 /\ red5_ok w res 1 /\ red5_ok w res 2 /\ red5_ok w res 3
    /\ red5_ok w res 4 /\ red5_ok w res 5 /\ red5_ok w res 6 /\ red5_ok w res 7 ].
proof. by proc; circuit. qed.

lemma reduce_coefficientP (c : W32.t) :
  hoare[ M.error_4x____reduce_coefficient :
    coefficient = c /\ c \ult W32.of_int 15 ==> res = c \umod W32.of_int 5 ].
proof. by proc; circuit. qed.

lemma zext_umod5E (z : W8.t) :
  zeroextu32 z \umod W32.of_int 5 = zeroextu32 (z \umod W8.of_int 5).
proof.
apply W32.to_uint_eq.
by rewrite WE32.to_uintUM !W4u8.to_uint_zeroextu32 WE8.to_uintUM.
qed.

lemma VPMOVSX_8u8_8u32_bitsE (v : W64.t) (i : int) :
  0 <= i < 8 => VPMOVSX_8u8_8u32 v \bits32 i = MOVSX_u32s8 (v \bits8 i).
proof.
move=> hi; rewrite /VPMOVSX_8u8_8u32 /=.
have : i \in iota_ 0 8 by rewrite mem_iota /#.
by rewrite -iotaredE /=; move=> [|[|[|[|[|[|[|]]]]]]] ->.
qed.

lemma sagree_store2 (p : wpoly) (old : W32.t list) (zs : W8.t list)
                    (x : W128.t) (h : W64.t) (r : W256.t) :
  Eta = 2 =>
  take 8 (W16u8.to_list x) = map cbyte zs =>
  size zs = 8 =>
  (forall z, z \in zs => to_uint z < 16) =>
  to_uint h = bs2int (map saccept zs) =>
  (forall i, 0 <= i < 8 => red5_ok (VPMOVSX_8u8_8u32 (shuffled x h)) r i) =>
  size old <= 248 =>
  agree p 0 old =>
  agree (Array256.fill (fun i => r \bits32 (i - size old)) (size old) 8 p)
        0 (old ++ map scoeff (filter saccept zs)).
proof.
move=> heta hx szzs hnib hh hr szold hag; apply sagree_storeW => //.
have hpre := shuffledP zs x h hx szzs hh.
have hcle : count idfun (map saccept zs) <= 8.
- by have := count_size idfun (map saccept zs); rewrite size_map szzs.
have szk : size (map scoeff (filter saccept zs)) = count idfun (map saccept zs).
- by rewrite size_map size_filter count_map.
apply (eq_from_nth W32.zero).
- by rewrite size_take ?count_ge0 W8u32.Pack.size_to_list szk /#.
move=> i; rewrite size_take ?count_ge0 W8u32.Pack.size_to_list => hi.
have hi8 : 0 <= i < 8 by smt().
have hik : i < count idfun (map saccept zs) by smt().
rewrite nth_take ?count_ge0 // W8u32.Pack.to_listE nth_mkseq //= W8u32.get_unpack32 //.
have hb : (shuffled x h) \bits8 i = nth W8.zero (map cbyte (filter saccept zs)) i.
- by rewrite -hpre nth_take ?count_ge0 // W8u8.nth_to_list.
rewrite (nth_map W8.zero) in hb; 1: smt(size_map).
rewrite (nth_map W8.zero); 1: smt(size_map size_filter count_map).
have /mem_filter [hacc hin] : nth W8.zero (filter saccept zs) i \in filter saccept zs.
- by apply mem_nth; smt(size_map size_filter count_map).
move: (nth W8.zero (filter saccept zs) i) hb hacc hin => z hb hacc hin.
have hz : W32.of_int 2 - (VPMOVSX_8u8_8u32 (shuffled x h) \bits32 i) = zeroextu32 z.
- rewrite VPMOVSX_8u8_8u32_bitsE // hb /cbyte heta MOVSX_u32s8_subE //; 1: smt().
  by ring.
have := hr i hi8; rewrite /red5_ok hz.
move: hacc; rewrite /saccept rej_boundE heta /= => hacc.
rewrite ultE /= W4u8.to_uint_zeroextu32 hacc /= => ->.
by rewrite zext_umod5E /scoeff /sred heta.
qed.

(* -------------------------------------------------------------------- *)
section.

hint simplify b2i0, b2i1.

(* --- acceptance bit of each nibble comparison byte --- *)
lemma rej_bound_rng : 0 <= rej_bound <= 16.
proof. by rewrite rej_boundE; smt(Eta_cases). qed.

lemma msb_loE (b : W8.t) :
  W8.msb ((b `&` W8.of_int 15) - W8.of_int rej_bound) = saccept (b `&` W8.of_int 15).
proof.
by rewrite msb_subE 1:to_uint_lonib_lt16 1:rej_bound_rng /saccept.
qed.

lemma msb_hiE (b : W8.t) :
  W8.msb ((b `>>>` 4) - W8.of_int rej_bound) = saccept (b `>>>` 4).
proof.
by rewrite msb_subE 1:to_uint_hinib_lt16 1:rej_bound_rng /saccept.
qed.

(* --- the 32-candidate acceptance mask of a 16-byte window --- *)
lemma movemask_scands16E (b00 b01 b02 b03 b04 b05 b06 b07 b08 b09 b10 b11 b12 b13 b14 b15 : W8.t) :
  to_uint (zeroextu64 (MOVEMASK_32u8 (VPSUB_32u8
    (W32u8.pack32 (scands [b00; b01; b02; b03; b04; b05; b06; b07; b08; b09; b10; b11; b12; b13; b14; b15]))
    (VPBROADCAST_32u8 (W8.of_int rej_bound)))))
  = bs2int (map saccept (scands [b00; b01; b02; b03; b04; b05; b06; b07; b08; b09; b10; b11; b12; b13; b14; b15])).
proof.
rewrite scands16E.
rewrite VPBROADCAST_32u8_pack32E VPSUB_32u8E /=.
rewrite /MOVEMASK_32u8 /=.
rewrite ?W32u8.pack32bE // ?W32u8.Pack.get_of_list //=.
rewrite !msb_loE !msb_hiE.
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
have [heta|heta] := Eta_cases.
(* for Eta = 2, the stored dwords are reduced modulo 5 *)
- rcondt ^if; 1: by auto.
  seq 10 : (error = p_ /\ bytes_filled = bf_ /\ good = go_ `&` W64.of_int 255
    /\ good_overall = go_ `>>` W8.of_int 8
    /\ error_coefficients = VPMOVSX_8u8_8u32 (shuffled cb_ (go_ `&` W64.of_int 255))
    /\ take 8 (W16u8.to_list cb_) = map cbyte zs /\ size zs = 8
    /\ (forall z, z \in zs => to_uint z < 16)
    /\ to_uint go_ = bs2int (map saccept (zs ++ zs'))
    /\ size old <= 248 /\ to_uint bf_ = 4 * size old /\ agree p_ 0 old).
  - auto => &hr [#] 4!-> hcb szzs hnib hgo szold hbf hag /=.
    have szmap : size (map saccept zs) = 8 by rewrite size_map szzs.
    have hand : to_uint (go_ `&` W64.of_int 255) = bs2int (map saccept zs).
    - rewrite (and255_bs2int _ (map saccept (zs ++ zs'))) // map_cat.
      by rewrite (_ : 8 = size (map saccept zs)) 1:szmap // take_size_cat.
    have hm : 0 <= bs2int (map saccept zs) < 256.
    - by rewrite bs2int_ge0 /=; have := bs2int_le2Xs (map saccept zs); rewrite szmap.
    have hidx : to_uint ((go_ `&` W64.of_int 255) `<<` W8.of_int 3)
                = 8 * bs2int (map saccept zs).
    - by apply (shuffle_slot8 _ (map saccept zs)).
    by rewrite /shuffled /= WArray2048_get64E 1:hidx 1:/#.
  wp; ecall (reduce_coefficientsP (VPMOVSX_8u8_8u32 (shuffled cb_ (go_ `&` W64.of_int 255)))).
  skip => &hr [#] 5!-> hcb szzs hnib hgo szold hbf hag r [#] h0 h1 h2 h3 h4 h5 h6 h7 /=.
  have hr : forall i, 0 <= i < 8 =>
    red5_ok (VPMOVSX_8u8_8u32 (shuffled cb_ (go_ `&` W64.of_int 255))) r i.
  - move=> i hi; have : i \in iota_ 0 8 by rewrite mem_iota /#.
    by rewrite -iotaredE /= => -[|[|[|[|[|[|[|]]]]]]] ->.
  have szmap : size (map saccept zs) = 8 by rewrite size_map szzs.
  have hand : to_uint (go_ `&` W64.of_int 255) = bs2int (map saccept zs).
  - rewrite (and255_bs2int _ (map saccept (zs ++ zs'))) // map_cat.
    by rewrite (_ : 8 = size (map saccept zs)) 1:szmap // take_size_cat.
  have hm : 0 <= bs2int (map saccept zs) < 256.
  - by rewrite bs2int_ge0 /=; have := bs2int_le2Xs (map saccept zs); rewrite szmap.
  do ! split.
  - rewrite wpoly_set256_alignedE 1,2:#smt:(size_ge0).
    rewrite (_ : to_uint bf_ %/ 4 = size old) 1:/#.
    by apply (sagree_store2 _ _ _ cb_ (go_ `&` W64.of_int 255) r).
  - rewrite (popcnt_step8 _ _ (map saccept zs)) // 1:/#.
    rewrite size_cat size_map size_filter.
    rewrite (count_map saccept idfun) hbf /preim /idfun /=.
    by ring.
  rewrite (shr8_bs2int _ (map saccept (zs ++ zs'))) // map_cat.
  by rewrite (_ : 8 = size (map saccept zs)) 1:szmap // drop_size_cat.
rcondf ^if; 1: by auto => /#.
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
  by apply sagree_store4.
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

(* the scalar reduction of the code, for Eta = 2                        *)
op sred32 (c : W32.t) : W32.t =
  if Eta = 2 then c - ((c * W32.of_int 205) `>>` W8.of_int 10) * W32.of_int 5 else c.

lemma red5_scalarE (n : W8.t) : to_uint n < 15 =>
  zeroextu32 n - ((zeroextu32 n * W32.of_int 205) `>>` W8.of_int 10) * W32.of_int 5
  = zeroextu32 (n \umod W8.of_int 5).
proof.
move=> hn; have hc := W8.to_uint_cmp n.
have h1 : to_uint (zeroextu32 n * W32.of_int 205) = to_uint n * 205.
- by rewrite W32.to_uintM_small W4u8.to_uint_zeroextu32 /=; smt().
have h2 : to_uint ((zeroextu32 n * W32.of_int 205) `>>` W8.of_int 10)
          = to_uint n * 205 %/ 1024.
- by rewrite /(`>>`) /= W32.to_uint_shr //= h1.
have hq : to_uint n * 205 %/ 1024 <= 2 by smt().
have h3 : to_uint (((zeroextu32 n * W32.of_int 205) `>>` W8.of_int 10) * W32.of_int 5)
          = to_uint n * 205 %/ 1024 * 5.
- by rewrite W32.to_uintM_small h2 /=; smt().
apply W32.to_uint_eq; rewrite W32.to_uintB.
- by rewrite uleE h3 W4u8.to_uint_zeroextu32; smt().
rewrite h3 !W4u8.to_uint_zeroextu32 WE8.to_uintUM /=.
have : to_uint n \in iota_ 0 15 by rewrite mem_iota /#.
move: (to_uint n) => c.
by rewrite -iotaredE /= => -[|[|[|[|[|[|[|[|[|[|[|[|[|[|]]]]]]]]]]]]]] ->.
qed.

(* the acceptance test and the coefficient as computed by the code      *)
lemma saccept_ultE (n : W8.t) :
  (zeroextu32 n \ult W32.of_int rej_bound) = saccept n.
proof.
rewrite ultE W4u8.to_uint_zeroextu32 of_uintK pmod_small //.
by have := rej_bound_rng; smt().
qed.

lemma scoeffE (n : W8.t) : saccept n =>
  - (sred32 (zeroextu32 n) - W32.of_int Eta) = scoeff n.
proof.
move=> hn; rewrite /scoeff /sred32 /sred.
case: (Eta = 2) => heta /=; last by ring.
by move: hn; rewrite /saccept rej_boundE heta /= => hn; rewrite red5_scalarE //; ring.
qed.

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
(* the reduction modulo 5, for Eta = 2, as one assignment *)
proc change ^while{2}.^if.^if : { coefficient <- sred32 coefficient; }.
- by inline *; if{1}; auto => /> &2 h; rewrite /sred32 h.
proc change ^while{2}.^if{2}.^if.^if : { coefficient <- sred32 coefficient; }.
- by inline *; if{1}; auto => /> &2 h; rewrite /sred32 h.
seq 7 : (randombytes = buf
  /\ eta_0 = VPBROADCAST_32u8 (W8.of_int Eta)
  /\ bound = VPBROADCAST_32u8 (W8.of_int rej_bound)).
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
    /\ eta_0 = VPBROADCAST_32u8 (W8.of_int Eta)
    /\ bound = VPBROADCAST_32u8 (W8.of_int rej_bound)
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
    /\ eta_0 = VPBROADCAST_32u8 (W8.of_int Eta)
    /\ bound = VPBROADCAST_32u8 (W8.of_int rej_bound)
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
    /\ eta_0 = VPBROADCAST_32u8 (W8.of_int Eta)
    /\ bound = VPBROADCAST_32u8 (W8.of_int rej_bound)
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
    by rewrite !sub16E_272 movemask_scands16E scands16E VPSUB_bcast_pack32E /= /cbyte.
  exlim error => p0.
  exlim bytes_filled => bf0.
  exlim good_overall => go0.
  exlim coefficient_block => cb0.
  seq 2 : (
       randombytes = buf
    /\ eta_0 = VPBROADCAST_32u8 (W8.of_int Eta)
    /\ bound = VPBROADCAST_32u8 (W8.of_int rej_bound)
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
    /\ eta_0 = VPBROADCAST_32u8 (W8.of_int Eta)
    /\ bound = VPBROADCAST_32u8 (W8.of_int rej_bound)
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
    /\ eta_0 = VPBROADCAST_32u8 (W8.of_int Eta)
    /\ bound = VPBROADCAST_32u8 (W8.of_int rej_bound)
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
    /\ eta_0 = VPBROADCAST_32u8 (W8.of_int Eta)
    /\ bound = VPBROADCAST_32u8 (W8.of_int rej_bound)
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
  /\ condition = (coefficient \ult W32.of_int rej_bound)
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
    rewrite saccept_ultE => hsacc; rewrite (scoeffE _ hsacc).
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
      rewrite /SLH64.protect_32 zext_shr4E saccept_ultE => hsacc; rewrite (scoeffE _ hsacc).
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
(* the reduction modulo 5, for Eta = 2, as one assignment *)
proc change ^while.^if.^if : { coefficient <- sred32 coefficient; }.
- by inline *; if{1}; auto => /> &2 h; rewrite /sred32 h.
proc change ^while.^if{2}.^if.^if : { coefficient <- sred32 coefficient; }.
- by inline *; if{1}; auto => /> &2 h; rewrite /sred32 h.
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
  /\ condition = (coefficient \ult W32.of_int rej_bound)
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
    rewrite saccept_ultE => hsacc; rewrite (scoeffE _ hsacc).
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
      rewrite /SLH64.protect_32 zext_shr4E saccept_ultE => hsacc; rewrite (scoeffE _ hsacc).
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
(* The staged four-lane sampler and the Spoly stream polynomial         *)
(* ==================================================================== *)
hint simplify b2i0, b2i1.

(* -------------------------------------------------------------------- *)
(* losslessness of the sampler's building blocks                        *)
lemma shake256_squeezeblock4x_ll : islossless M.shake256_squeezeblock4x.
proof. by proc; islossless. qed.

lemma shake256_absorb_66_4x_ll : islossless M.shake256_absorb_66_4x.
proof. by proc; islossless. qed.

lemma error_4x____shake256_squeeze_multiple_blocks_4x_ll :
  islossless M.error_4x____shake256_squeeze_multiple_blocks_4x.
proof.
proc; while true (2 - i); last by auto=> /#.
by move=> z; wp; call shake256_squeezeblock4x_ll; auto=> /#.
qed.

lemma error_4x__rejection_sample_one_block_ll :
  islossless M.error_4x__rejection_sample_one_block.
proof.
proc; inline M.error_4x____reduce_coefficient.
while (   to_uint xof_offset <= 136
       /\ (condition_loop => to_uint xof_offset < 136))
      (136 - to_uint xof_offset).
- move=> z; auto=> &hr |> hle hlt hc.
  have h1 : to_uint (xof_offset{hr} + W64.one) = to_uint xof_offset{hr} + 1.
  - by rewrite to_uintD_small /= /#.
  by rewrite !W64.uleE h1 /=; smt().
by auto=> &hr |>; smt().
qed.

lemma error_4x__rejection_sample_multiple_blocks_ll :
  islossless M.error_4x__rejection_sample_multiple_blocks.
proof.
proc; inline M.error_4x____reduce_coefficient.
while (   to_uint xof_offset <= 272
       /\ (condition_loop => to_uint xof_offset < 272))
      (272 - to_uint xof_offset).
- move=> z; auto=> &hr |> hle hlt hc.
  have h1 : to_uint (xof_offset{hr} + W64.one) = to_uint xof_offset{hr} + 1.
  - by rewrite to_uintD_small /= /#.
  by rewrite !W64.uleE h1 /=; smt().
wp.
(* the vectorized loop consumes 4 to 16 bytes per iteration *)
while (   to_uint xof_offset < 272 /\ 4 %| to_uint xof_offset
       /\ (condition_loop => to_uint xof_offset < 256))
      (272 - to_uint xof_offset).
- move=> z; exlim xof_offset => o.
  seq 12 : (true) 1%r 1%r 0%r 0%r
    (to_uint o < 256 /\ 4 %| to_uint o /\ 272 - to_uint o = z /\
     exists j, 1 <= j <= 4 /\ to_uint xof_offset = to_uint o + 4 * j).
  + seq 10 : (to_uint o < 256 /\ 4 %| to_uint o /\ 272 - to_uint o = z /\
              to_uint xof_offset = to_uint o + 4).
    - wp; call (: true); 1: by auto.
      wp; call (: true); 1: by auto.
      auto=> &hr |> h272 hdvd hlt hc.
      by rewrite to_uintD_small /= /#.
    sp; if; last by auto=> &hr |> *; exists 1.
    seq 4 : (to_uint o < 256 /\ 4 %| to_uint o /\ 272 - to_uint o = z /\
             to_uint xof_offset = to_uint o + 8).
    - wp; call (: true); 1: by auto.
      auto=> &hr |> h256 hdvd ho _.
      by rewrite to_uintD_small /= /#.
    sp; if; last by auto=> &hr |> *; exists 2.
    seq 4 : (to_uint o < 256 /\ 4 %| to_uint o /\ 272 - to_uint o = z /\
             to_uint xof_offset = to_uint o + 12).
    - wp; call (: true); 1: by auto.
      auto=> &hr |> h256 hdvd ho _.
      by rewrite to_uintD_small /= /#.
    sp; if; last by auto=> &hr |> *; exists 3.
    wp; call (: true); 1: by auto.
    auto=> &hr |> h256 hdvd ho _.
    by exists 4; rewrite to_uintD_small /= /#.
  + by islossless.
  + auto=> &hr [h256 [hdvd [<- [j [rgj ho]]]]].
    have h252 : to_uint o <= 252 by move: hdvd h256 => /dvdzP [q ->] /#.
    have hd : 4 %| (to_uint o + 4 * j) by rewrite dvdzD // dvdz_mulr.
    rewrite !W64.uleE ho /= hd /=; smt().
  + by hoare; conseq (: _ ==> true).
  + by [].
by auto=> />; smt().
qed.

hint solve 0 lossless : shake256_squeezeblock4x_ll error_4x__rejection_sample_one_block_ll.

(* -------------------------------------------------------------------- *)
(* the error polynomial: the first 256 accepted candidates of the     *)
(* lane's XOF stream                                                    *)
op Spoly (rho' : W8.t Array64.t) (sep : W16.t) : wpoly =
  rpoly (to_list rho' ++ W2u8.to_list sep).

lemma SpolyP (rho' : W8.t Array64.t) (sep : W16.t) (m j : int) :
  0 <= m =>
  256 <= size (sreject (shake256_slice
                 (to_list rho' ++ W2u8.to_list sep) 0 m)) =>
  0 <= j < 256 =>
  (Spoly rho' sep).[j]
  = nth W32.zero
      (sreject (shake256_slice (to_list rho' ++ W2u8.to_list sep) 0 m)) j.
proof. by move=> *; rewrite /Spoly (rpolyP W32.zero _ m). qed.

(* -------------------------------------------------------------------- *)

(* -------------------------------------------------------------------- *)
(* -------------------------------------------------------------------- *)
(* Termination of the four-lane sampler (as in Aexpand): the loop       *)
(* variant is [K - kmax], kmax the largest block count <= K consistent  *)
(* with the state                                                       *)
op s_stop (fs : W64.t list) : W64.t =
  W64.of_int (b2i (!has (fun (w : W64.t) => w \ult W64.of_int 256) fs)).

(* the sampling-loop invariant after k squeezed blocks *)
op s_inv (nonce : int -> W8.t list) (k : int) (st : sha3x4)
         (ps : wpoly list) (fs : W64.t list) =
     st \sha3for Array4.init (mk_read (136 * k) \o nonce)
  /\ (forall i, 0 <= i < 4 =>
        let p = nth witness ps i in
        let f = nth witness fs i in
        sreject_ok (Array4.init nonce).[i] (136 * k) p (to_uint f)).

(* past every lane's fuel, all lanes are full and the loop stops *)
lemma s_inv_full (nonce : int -> W8.t list) (k : int) st (ps : wpoly list)
  (f0 f1 f2 f3 : W64.t) :
  (forall i, 0 <= i < 4 => stream_ok (nonce i)) =>
  (forall i, 0 <= i < 4 => stream_fuel (nonce i) <= k) =>
  s_inv nonce k st ps [f0; f1; f2; f3] =>
  s_stop [f0; f1; f2; f3] = W64.one.
proof.
move=> hok hfuel [_ hinv].
have hall : forall i, 0 <= i < 4 => 256 <= to_uint (nth witness [f0; f1; f2; f3] i).
- move=> i rgi; have [_ hf] := hinv i rgi; rewrite /= in hf.
  by rewrite hf Array4.initiE //=; smt(stream_fuelP).
move: (hall 0 _) (hall 1 _) (hall 2 _) (hall 3 _) => //=.
by rewrite /s_stop /= !W64.ultE /= => 4?; rewrite !ltzNge /#.
qed.

(* -------------------------------------------------------------------- *)
lemma error_4x____sample_polynomialsP (rho_ : W8.t Array64.t) (ds0 : W16.t) :
  (forall ds, stream_ok (to_list rho_ ++ W2u8.to_list ds)) =>
phoare[ M.error_4x____sample_polynomials :
     rho_prime = rho_ /\ starting_domain_separator = ds0
  ==>
     forall i, 0 <= i < 4 =>
       nth witness [res.`1; res.`2; res.`3; res.`4] i
       = Spoly rho_ (ds0 + W16.of_int i) ] = 1%r.
proof.
move=> hok.
hint +listred -delta nth.
proc=> /=.
proc change [^stop_sampling<- .. ^stop_sampling<- & +1] : {
  stop_sampling <- s_stop [filled0; filled1; filled2; filled3];
}; first by auto=> &hr @/s_stop |> *.
pose nonce (i : int) := to_list rho_ ++ W2u8.to_list (ds0 + W16.of_int i).
pose data := Array4.init nonce.

(* up to the loop: partial correctness, then losslessness              *)
seq ^while : (true) 1%r 1%r 0%r 0%r
  (s_inv nonce 2 xof_state [polynomial0; polynomial1; polynomial2; polynomial3]
                           [filled0; filled1; filled2; filled3]
   /\ stop_sampling = s_stop [filled0; filled1; filled2; filled3]).
- (* initial absorption *)
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
  by auto=> &hr |> hxf h; rewrite /s_inv hxf /=.
- wp; do 4! (call error_4x__rejection_sample_multiple_blocks_ll; wp).
  call error_4x____shake256_squeeze_multiple_blocks_4x_ll.
  by call shake256_absorb_66_4x_ll; auto.

(* the sampling loop                                                    *)
- pose K := max 2 (max (max (stream_fuel (nonce 0)) (stream_fuel (nonce 1)))
                       (max (stream_fuel (nonce 2)) (stream_fuel (nonce 3)))).
  have hK : forall i, 0 <= i < 4 => stream_fuel (nonce i) <= K.
  - move=> i rgi; have hi : i = 0 \/ i = 1 \/ i = 2 \/ i = 3 by smt().
    by rewrite /K; case: hi => [->|[->|[->|->]]]; smt().
  have hoks : forall i, 0 <= i < 4 => stream_ok (nonce i) by move=> i _; apply hok.
  while (   (exists k, 2 <= k <= K /\ s_inv nonce k xof_state
                 [polynomial0; polynomial1; polynomial2; polynomial3]
                 [filled0; filled1; filled2; filled3])
         /\ stop_sampling = s_stop [filled0; filled1; filled2; filled3])
        (K - argmax idfun (fun k => k <= K /\ s_inv nonce k xof_state
                 [polynomial0; polynomial1; polynomial2; polynomial3]
                 [filled0; filled1; filled2; filled3])); last first.
  - auto=> &hr [hinv hstop]; split.
    - by split=> //; exists 2; rewrite hinv /=; smt().
    move=> f0 f1 f2 f3 p0 p1 p2 p3 st xf; split.
    (* the variant is exhausted: every lane is full *)
    - move=> [[k [rgk hk]] ->] hv.
      have := argmax_bounded (fun k => s_inv nonce k xf [p0; p1; p2; p3] [f0; f1; f2; f3]) K k _ hk; 1: smt().
      move=> /= [rgm [hm _]].
      have hmK : argmax idfun (fun k => k <= K /\ s_inv nonce k xf [p0; p1; p2; p3] [f0; f1; f2; f3]) = K by smt().
      move: hm; rewrite hmK => hm.
      by apply (s_inv_full nonce K xf [p0; p1; p2; p3]) => // i rgi; apply hK.
    clear hinv hstop; move=> -> [[k [rgk [hxf h]]] hstop].
    (* the stop flag forces every lane to 256 coefficients *)
    have {hstop} hfull : forall f, f \in [f0; f1; f2; f3] => 256 <= to_uint f.
    - move=> f hf; rewrite lezNgt; apply/negP => hlt.
      have hhas : has (fun (w : W64.t) => w \ult W64.of_int 256) [f0; f1; f2; f3].
      - by apply/hasP; exists f; rewrite hf /= ultE of_uintK /=.
      by move: hstop => @/s_stop; rewrite hhas /=.
    (* a full lane holds the first 256 accepted candidates: Spoly      *)
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
      rewrite (SpolyP rho_ (ds0 + W16.of_int i) (136 * k) j) //; 1: smt(); 1: by move: hsz; rewrite hdata.
      rewrite -hdata.
      by apply (agree_nth W32.zero _ _ _ hsz hag rgj).
    move=> i rgi.
    have /= := h i rgi.
    rewrite /sreject_ok => -[hag hf].
    by apply (hbridge (nth witness [p0; p1; p2; p3] i)
                      (nth witness [f0; f1; f2; f3] i) i) => //; 1: smt().

  (* one iteration: fix the largest consistent block count k           *)
  move=> z.
  exlim (argmax idfun (fun k => k <= K /\ s_inv nonce k xof_state
            [polynomial0; polynomial1; polynomial2; polynomial3]
            [filled0; filled1; filled2; filled3])) => k.
  case @[ambient]: (2 <= k < K /\ z = K - k) => hkz; last first.
  - conseq (_ : false ==> _) => // &hr [->> [[[[k0 [rgk0 hk0]] hstop] hne] hz]].
    apply: hkz; have := argmax_bounded (fun k => s_inv nonce k xof_state{hr}
       [polynomial0{hr}; polynomial1{hr}; polynomial2{hr}; polynomial3{hr}]
       [filled0{hr}; filled1{hr}; filled2{hr}; filled3{hr}]) K k0 _ hk0; 1: smt().
    move=> /= [rgm [hm hle]]; split; 2: smt().
    split; 1: smt().
    move=> _; rewrite ltz_def; split; 2: smt().
    apply/negP => hmK; apply: hne; rewrite hstop.
    apply (s_inv_full nonce K xof_state{hr}
      [polynomial0{hr}; polynomial1{hr}; polynomial2{hr}; polynomial3{hr}]) => //.
    by move: hm; rewrite -hmK.
  seq 13 : (true) 1%r 1%r 0%r 0%r
    (s_inv nonce (k + 1) xof_state
       [polynomial0; polynomial1; polynomial2; polynomial3]
       [filled0; filled1; filled2; filled3]
     /\ stop_sampling = s_stop [filled0; filled1; filled2; filled3]).
  - conseq (_ : (2 <= k
        /\ xof_state \sha3for Array4.init (mk_read (136 * k) \o nonce)
        /\ (forall i, 0 <= i < 4 =>
              let p = nth witness [polynomial0; polynomial1; polynomial2; polynomial3] i in
              let f = nth witness [filled0; filled1; filled2; filled3] i in
              sreject_ok data.[i] (136 * k) p (to_uint f))
        /\ stop_sampling = s_stop [filled0; filled1; filled2; filled3])
        /\ stop_sampling <> W64.one ==> _).
    - move=> &hr [->> [[[[k0 [rgk0 hk0]] hstop] hne] _]].
      have := argmax_bounded (fun k => s_inv nonce k xof_state{hr}
         [polynomial0{hr}; polynomial1{hr}; polynomial2{hr}; polynomial3{hr}]
         [filled0{hr}; filled1{hr}; filled2{hr}; filled3{hr}]) K k0 _ hk0; 1: smt().
      by move=> /= [rgm [[hxf h] _]]; do! split => //; smt().
    clear hok hoks hK hkz.
    proc rewrite 3 PA_272_136.injecta_272E.
    proc rewrite 4 PA_272_136.injecta_272E.
    proc rewrite 5 PA_272_136.injecta_272E.
    proc rewrite 6 PA_272_136.injecta_272E.
    proc change [^stop_sampling<- .. ^stop_sampling<- & +1] : {
      stop_sampling <- s_stop [filled0; filled1; filled2; filled3];
    }; first by auto=> &hr @/s_stop |>.

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
      sp 1.

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
    rewrite /s_inv hxf /= => i rgi.
    by move: (slanes_ok_wrap data k _ _ hln i rgi) => /#.
  - by islossless.
  (* the variant decreases: k + 1 is consistent *)
  - skip=> &hr [hinv hstop]; split; 1: by split=> //; exists (k + 1); smt().
    have := argmax_bounded (fun k => s_inv nonce k xof_state{hr}
       [polynomial0{hr}; polynomial1{hr}; polynomial2{hr}; polynomial3{hr}]
       [filled0{hr}; filled1{hr}; filled2{hr}; filled3{hr}]) K (k + 1) _ hinv; 1: smt().
    by move=> /= [_ [_ hle]]; smt().
  - by hoare; conseq (: _ ==> true).
  by [].
- by hoare; conseq (: _ ==> true).
by [].
qed.

(* -------------------------------------------------------------------- *)
lemma error_4x____sample_polynomialsH (rho_ : W8.t Array64.t) (ds0 : W16.t) :
  (forall ds, stream_ok (to_list rho_ ++ W2u8.to_list ds)) =>
hoare[ M.error_4x____sample_polynomials :
     rho_prime = rho_ /\ starting_domain_separator = ds0
  ==>
     forall i, 0 <= i < 4 =>
       nth witness [res.`1; res.`2; res.`3; res.`4] i
       = Spoly rho_ (ds0 + W16.of_int i) ].
proof. by move=> hok; conseq (error_4x____sample_polynomialsP rho_ ds0 hok). qed.

lemma error_4x____sample_polynomials_ll :
  (forall (rho_ : W8.t Array64.t) ds, stream_ok (to_list rho_ ++ W2u8.to_list ds)) =>
  islossless M.error_4x____sample_polynomials.
proof.
move=> hok; proc*; exlim rho_prime, starting_domain_separator => rho_ ds0.
call (error_4x____sample_polynomialsP rho_ ds0 (hok rho_)).
by auto.
qed.


(* ==================================================================== *)
(* The link with the specification                                      *)
(* ==================================================================== *)

(* -------------------------------------------------------------------- *)
(* the coefficient of an accepted candidate, and its range             *)
lemma sredE (c : W8.t) :
  to_uint (sred c) = if Eta = 2 then to_uint c %% 5 else to_uint c.
proof. by rewrite /sred; case: (Eta = 2) => //= _; rewrite WE8.to_uintUM. qed.

lemma sred_rng (c : W8.t) : saccept c => 0 <= to_uint (sred c) <= 2 * Eta.
proof.
rewrite /saccept rej_boundE sredE; have := W8.to_uint_cmp c.
by have [] -> /= := Eta_cases; smt().
qed.

lemma to_sint_scoeff (c : W8.t) : saccept c => to_sint (scoeff c) = Eta - to_uint (sred c).
proof.
move=> /sred_rng h; rewrite /scoeff /zeroextu32.
by rewrite -W32.of_intN -W32.of_intD W32.to_sintK_small //; smt(Eta_cases).
qed.

(* a code candidate is the spec's CoeffFromHalfByte                     *)
lemma halfstep_specE (c : W8.t) :
  to_uint c < 16 =>
  map W32.to_sint (halfstep c) = pmap idfun [CoeffFromHalfByte (to_uint c)].
proof.
move=> hc; rewrite /CoeffFromHalfByte.
case: (saccept c) => hacc /=.
- rewrite to_sint_scoeff // sredE; move: hacc; rewrite /saccept rej_boundE.
  by have [] -> /= := Eta_cases => -> /=.
by move: hacc; rewrite /saccept rej_boundE; have [] -> /= := Eta_cases => -> /=.
qed.

(* one byte, low nibble first, as Alg. 31 reads it                      *)
lemma sreject1_specE (b : W8.t) :
  map W32.to_sint (sreject [b])
  = pmap idfun [CoeffFromHalfByte (to_uint b %% 16); CoeffFromHalfByte (to_uint b %/ 16)].
proof.
have hlo : to_uint (b `&` W8.of_int 15) = to_uint b %% 16.
- by rewrite (W8.to_uint_and_mod 4).
have hhi : to_uint (b `>>>` 4) = to_uint b %/ 16.
- by rewrite W8.to_uint_shr.
have /= hb := W8.to_uint_cmp b.
rewrite sreject1E map_cat !halfstep_specE ?hlo ?hhi.
- smt(modz_cmp).
- smt().
by rewrite -pmap_cat.
qed.

(* the code's accepted stream is the spec's accepted list               *)
lemma sreject_specE (rho : Bytes66.t) (t : int) : 0 <= t =>
  map W32.to_sint (sreject (shake256_slice (Bytes66.to_list rho) 0 t))
  = bounded_accepted rho t.
proof.
elim: t => [|t ge0t ih].
- by rewrite /bounded_accepted /shake256_slice /Xof.slice mkseq0 /= iota0.
rewrite bounded_acceptedS // -ih sreject_slice_block 1,2:// 1:dvd1z map_cat; congr.
have -> : shake256_slice (Bytes66.to_list rho) t 1
          = [nth witness (SHAKE256 (Bytes66.to_list rho) (t + 1)) t].
- by rewrite /shake256_slice /Xof.slice mkseq1 /= /shake256_xof.
by rewrite sreject1_specE /bounded_cands.
qed.

(* -------------------------------------------------------------------- *)
(* termination: the code criterion follows from the spec's              *)
lemma stream_ok_spec (n : W8.t list) : size n = 66 => stream_ok n.
proof.
move=> szn; have [t [ge0t hsz]] := rejBounded_terminates (Bytes66.of_list n).
exists t; split=> //.
have [l ->] := sreject_slice_prefix n t (136 * t) _; 1: smt().
move: hsz; rewrite -sreject_specE // Bytes66.of_listK // size_map size_cat.
smt(size_ge0).
qed.

lemma stream_ok_all (rho_ : W8.t Array64.t) (ds : W16.t) :
  stream_ok (to_list rho_ ++ W2u8.to_list ds).
proof. by apply stream_ok_spec; rewrite size_cat Array64.size_to_list W2u8.size_to_list. qed.

(* -------------------------------------------------------------------- *)
(* the stream polynomial is the spec's RejBoundedPoly                   *)
lemma Spoly_specE (rho_ : W8.t Array64.t) (sep : W16.t) :
  lifts_wpoly (Spoly rho_ sep)
  = rejBoundedPoly (Bytes66.of_list (to_list rho_ ++ W2u8.to_list sep)).
proof.
pose nc := to_list rho_ ++ W2u8.to_list sep.
pose s := Bytes66.of_list nc.
have szn : size nc = 66 by rewrite /nc size_cat Array64.size_to_list W2u8.size_to_list.
have hn : Bytes66.to_list s = nc by rewrite /s Bytes66.of_listK.
pose p := fun t => 256 <= size (bounded_accepted s t).
have [t0 [ge0t0 ht0]] := rejBounded_terminates s.
have hf : p (rejBounded_fuel s) by apply (argminP idfun p t0).
have ge0f : 0 <= rejBounded_fuel s by rewrite /rejBounded_fuel ge0_argmin.
have hsz : 256 <= size (sreject (shake256_slice nc 0 (rejBounded_fuel s))).
- by move: hf; rewrite /p -sreject_specE // hn size_map.
apply Array256.ext_eq => j rgj.
rewrite /lifts_wpoly Array256.mapiE // (SpolyP rho_ sep (rejBounded_fuel s) j) //.
rewrite /rejBoundedPoly Array256.initiE // -sreject_specE // hn.
by rewrite /= (nth_map W32.zero) 1:/#.
qed.

(* its coefficients lie in [-eta, eta]                                  *)
lemma Spoly_srng (rho_ : W8.t Array64.t) (sep : W16.t) : wpoly_srng Eta Eta (Spoly rho_ sep).
proof.
pose nc := to_list rho_ ++ W2u8.to_list sep.
have szn : size nc = 66 by rewrite /nc size_cat Array64.size_to_list W2u8.size_to_list.
have [k [ge0k hk]] := stream_ok_spec nc szn.
rewrite /wpoly_srng Array256.allP => i rgi /=.
rewrite (SpolyP rho_ sep (136 * k) i) 1:/# // -/nc.
have : nth W32.zero (sreject (shake256_slice nc 0 (136 * k))) i
       \in sreject (shake256_slice nc 0 (136 * k)) by apply mem_nth => /#.
move: (nth W32.zero _ i) => w.
rewrite srejectE => /mapP [c [/mem_filter [hc _] ->]].
by rewrite to_sint_scoeff //; have := sred_rng c hc; smt().
qed.

(* -------------------------------------------------------------------- *)

(* -------------------------------------------------------------------- *)
clone ErrorVectorsT.ErrorVectorsT as EV with theory B <- B, theory PR <- PR
proof *.
realize sample_polynomials_4x.
move=> rho_ ds0.
conseq (error_4x____sample_polynomials_ll stream_ok_all)
       (error_4x____sample_polynomialsH rho_ (W16.of_int ds0) (stream_ok_all rho_)).
move=> &hr _ r; split => [[_ //] | [_ h]]; split => // i rgi.
by rewrite /EV.Spoly_ok (h i rgi) -W16.of_intD Spoly_specE Spoly_srng.
qed.

end ErrorSamplerT.
