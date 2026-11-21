require import AllCore CoreUtils List List_extra IntDiv IntMin BitEncoding.
import BS2Int.
from Jasmin require import JWord JModel_x86.
from Spec require import GFq Rq Parameters MLDSA_W32_Rep.
from CryptoSpecs require import Keccak1600_Spec.
require import MldsaConstants Agree Avx2red Compaction Prefixarray Rejstream Warraypack.
require import CircuitBindings Bindings JWordExtra JModelExtra.
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
    bytestream = bs_ /\ nibble_mask = VPBROADCAST_32u8 (W8.of_int 15)
    ==> res = W32u8.pack32 (scands (W16u8.to_list bs_)) ].
proof.
proc; wp; skip => &hr |>.
by rewrite scands16E -nibble_decodeE truncateu8_bcastE.
qed.

(* -------------------------------------------------------------------- *)
(* -------------------------------------------------------------------- *)
(* the coefficient byte of a candidate, as read in the table of the     *)
(* code: Eta - (z mod (2 Eta + 1)), which is Eta - sred z for an        *)
(* accepted candidate; its sign extension is the coefficient            *)
op cbyte (z : W8.t) : W8.t = W8.of_int Eta - (z \umod W8.of_int (2 * Eta + 1)).

lemma cbyteE (z : W8.t) : saccept z => cbyte z = W8.of_int Eta - sred z.
proof.
rewrite /saccept /cbyte /sred rej_boundE; have [->|->] /= := Eta_cases => // hz.
have -> // : z \umod W8.of_int 9 = z.
by apply W8.to_uint_eq; rewrite WE8.to_uintUM /= pmod_small; smt(W8.to_uint_cmp).
qed.

lemma movsx_cbyteE (z : W8.t) : saccept z => MOVSX_u32s8 (cbyte z) = scoeff z.
proof.
move=> hz; rewrite cbyteE // /scoeff MOVSX_u32s8_subE //; 1: smt(Eta_cases).
rewrite /sred; case: (Eta = 2) => _; last by smt(W8.to_uint_cmp).
by rewrite WE8.to_uintUM /=; smt(W8.to_uint_cmp).
qed.

(* -------------------------------------------------------------------- *)
(* the tables of the code: a lane lists cbyte of the 16 nibbles         *)
op ctable2 : W8.t list =
  [W8.of_int 2; W8.of_int 1; W8.of_int 0; W8.of_int (-1); W8.of_int (-2);
   W8.of_int 2; W8.of_int 1; W8.of_int 0; W8.of_int (-1); W8.of_int (-2);
   W8.of_int 2; W8.of_int 1; W8.of_int 0; W8.of_int (-1); W8.of_int (-2);
   W8.of_int 2].

op ctable4 : W8.t list =
  [W8.of_int 4; W8.of_int 3; W8.of_int 2; W8.of_int 1; W8.of_int 0;
   W8.of_int (-1); W8.of_int (-2); W8.of_int (-3); W8.of_int (-4);
   W8.of_int 4; W8.of_int 3; W8.of_int 2; W8.of_int 1; W8.of_int 0;
   W8.of_int (-1); W8.of_int (-2)].

op ctable : W8.t list = if Eta = 2 then ctable2 else ctable4.

lemma eta2_tableE :
  error_4x__ERROR_COEFFICIENTS_ETA2 = W32u8.pack32 (ctable2 ++ ctable2).
proof.
apply W32u8.wordP => i hi; rewrite W32u8.pack32bE // W32u8.bits8_div 1:/# of_uintK /=.
have : i \in iota_ 0 32 by rewrite mem_iota /#.
by rewrite /ctable2 -iotaredE /=; do 31! (case=> [-> // |]); move=> ->.
qed.

lemma eta4_tableE :
  error_4x__ERROR_COEFFICIENTS_ETA4 = W32u8.pack32 (ctable4 ++ ctable4).
proof.
apply W32u8.wordP => i hi; rewrite W32u8.pack32bE // W32u8.bits8_div 1:/# of_uintK /=.
have : i \in iota_ 0 32 by rewrite mem_iota /#.
by rewrite /ctable4 -iotaredE /=; do 31! (case=> [-> // |]); move=> ->.
qed.

(* the lookup of a nibble in a lane of the table *)
lemma ctable_lookup (k : int) : k \in iota_ 0 16 =>
  VPSHUFB_128_B (W16u8.pack16 ctable) (W8.of_int k) = cbyte (W8.of_int k).
proof.
rewrite /ctable /cbyte /ctable2 /ctable4; have [->|->] /= := Eta_cases.
- rewrite -iotaredE /=.
  by move=> [|[|[|[|[|[|[|[|[|[|[|[|[|[|[|]]]]]]]]]]]]]]] ->; rewrite /(\umod) /ulift2 /=.
rewrite -iotaredE /=.
by move=> [|[|[|[|[|[|[|[|[|[|[|[|[|[|[|]]]]]]]]]]]]]]] ->; rewrite /(\umod) /ulift2 /=.
qed.

(* the VPSHUFB of the code maps the candidates to their coefficient     *)
(* bytes                                                                *)
lemma cbyte_lookupE (zs : W8.t list) :
  size zs = 32 => (forall z, z \in zs => to_uint z < 16) =>
  VPSHUFB_256
    (if Eta = 2 then error_4x__ERROR_COEFFICIENTS_ETA2
     else error_4x__ERROR_COEFFICIENTS_ETA4)
    (W32u8.pack32 zs)
  = W32u8.pack32 (map cbyte zs).
proof.
move=> szzs hnib; apply W32u8.wordP => i hi.
rewrite VPSHUFB_256_bits8 // !W32u8.pack32bE // !get_of_list //.
rewrite (nth_map W8.zero) 1:/#.
have -> : (if Eta = 2 then error_4x__ERROR_COEFFICIENTS_ETA2
           else error_4x__ERROR_COEFFICIENTS_ETA4) \bits128 (i %/ 16)
          = W16u8.pack16 ctable.
- rewrite /ctable; case: (Eta = 2) => _.
  - by rewrite eta2_tableE pack32_dup_bits128 // /#.
  by rewrite eta4_tableE pack32_dup_bits128 // /#.
have hz : to_uint (nth W8.zero zs i) < 16 by apply hnib; apply mem_nth => /#.
rewrite -(W8.to_uintK (nth W8.zero zs i)) ctable_lookup //.
by rewrite mem_iota; smt(W8.to_uint_cmp).
qed.

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
(* the shuffle of one 8-candidate group by the row of a mask: the bytes *)
(* selected by the mask come first                                      *)
op shuffled (x : W128.t) (h : W64.t) : W64.t =
  truncateu64 (VPSHUFB_128 x
    (VMOV_64 (W8u8.pack8 (Array2048.sub cOMPACTION_INDEX_TABLE (8 * to_uint h) 8)))).

lemma shuffledP (bs : bool list) (x : W128.t) (h : W64.t) :
  size bs = 8 => to_uint h = bs2int bs =>
  take (count idfun bs) (W8u8.to_list (shuffled x h))
  = mask bs (take 8 (W16u8.to_list x)).
proof.
move=> szbs hh.
have hint2bs : int2bs 8 (bs2int bs) = bs by have := bs2intK bs; rewrite szbs.
rewrite -{1}hint2bs /shuffled hh (shuffle_compact8 x (bs2int bs)).
- by have := bs2int_le2Xs bs; rewrite szbs bs2int_ge0 /= => /#.
by rewrite hint2bs.
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

lemma sagree_store (p : wpoly) (old : W32.t list) (zs : W8.t list)
                   (x : W128.t) (h : W64.t) :
  take 8 (W16u8.to_list x) = map cbyte zs =>
  size zs = 8 =>
  to_uint h = bs2int (map saccept zs) =>
  size old <= 248 =>
  agree p 0 old =>
  agree (Array256.fill
           (fun i => VPMOVSX_8u8_8u32 (shuffled x h) \bits32 (i - size old))
           (size old) 8 p)
        0 (old ++ map scoeff (filter saccept zs)).
proof.
move=> hx szzs hh szold hag; apply sagree_storeW => //.
rewrite VPMOVSX_8u8_8u32_to_listE -map_take (shuffledP (map saccept zs)) ?size_map //.
rewrite hx -map_mask filter_mask' -map_comp -filter_mask'.
by apply eq_in_map => z /mem_filter [hacc _] @/(\o); exact movsx_cbyteE.
qed.

(* the scalar reduction of a candidate modulo 5, for Eta = 2            *)
lemma reduce_coefficientP (c : W32.t) :
  hoare[ M.error_4x____reduce_coefficient :
    coefficient = c /\ c \ult W32.of_int 15 ==> res = c \umod W32.of_int 5 ].
proof. by proc; circuit. qed.

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
lemma popcnt_lea8 (bf h : W64.t) (bs : bool list) :
  size bs = 8 => to_uint h = bs2int bs => to_uint bf <= 1024 =>
  to_uint (LEA_64 (bf + W64.of_int 4 * (POPCNT_64 h).`6))
  = to_uint bf + 4 * count idfun bs.
proof.
move=> szbs hh hbf; rewrite /LEA_64 popcnt6E (popcnt_count8 _ bs) //.
have hcle : count idfun bs <= 8 by have := count_size idfun bs; rewrite szbs.
by rewrite W64.to_uintD_small W64.to_uintM_small !of_uintK /=; smt(count_ge0).
qed.

lemma error_4x____write_out_8_coefficientsP
  (p_ : wpoly) (old : W32.t list) (zs zs' : W8.t list)
  (bf_ go_ : W64.t) (cb_ : W128.t) :
hoare[ M.error_4x____write_out_8_coefficients :
     error = p_ /\ bytes_filled = bf_ /\ good_overall = go_
  /\ coefficient_block = cb_
  /\ shuffle_table_pointer = cOMPACTION_INDEX_TABLE
  /\ take 8 (W16u8.to_list cb_) = map cbyte zs
  /\ size zs = 8
  /\ to_uint go_ = bs2int (map saccept (zs ++ zs'))
  /\ size old <= 248
  /\ to_uint bf_ = 4 * size old
  /\ agree p_ 0 old
  ==>
     agree res.`1 0 (old ++ map scoeff (filter saccept zs))
  /\ to_uint res.`2 = 4 * size (old ++ map scoeff (filter saccept zs))
  /\ to_uint res.`3 = bs2int (map saccept zs') ].
proof.
proc; wp; skip => &hr |> hcb szzs hgo szold hbf hag.
have szmap : size (map saccept zs) = 8 by rewrite size_map szzs.
have hgood : to_uint (zeroextu64 (truncateu8 good_overall{hr}))
             = bs2int (map saccept zs).
- rewrite W8u8.zeroext_truncateu8_and /=.
  rewrite (and255_bs2int _ (map saccept (zs ++ zs'))) // map_cat.
  by rewrite (_ : 8 = size (map saccept zs)) 1:szmap // take_size_cat.
have hm : 0 <= bs2int (map saccept zs) < 256.
- by rewrite bs2int_ge0 /=; have := bs2int_le2Xs (map saccept zs); rewrite szmap.
have hidx : to_uint (W64.of_int 8 * zeroextu64 (truncateu8 good_overall{hr}))
            = 8 * to_uint (zeroextu64 (truncateu8 good_overall{hr})).
- by rewrite W64.to_uintM_small of_uintK //= /#.
do ! split.
- rewrite WArray2048_get64E 1:hidx 1:/#.
  rewrite wpoly_set256_alignedE 1,2:#smt:(size_ge0).
  rewrite (_ : to_uint bytes_filled{hr} %/ 4 = size old) 1:/# hidx.
  rewrite -truncateu64_128E.
  by apply sagree_store.
- rewrite (popcnt_lea8 _ _ (map saccept zs)) // 1:/#.
  rewrite size_cat size_map size_filter.
  rewrite (count_map saccept idfun) hbf /preim /idfun /=.
  by ring.
rewrite (shr8_bs2int _ (map saccept (zs ++ zs'))) // map_cat.
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

(* the vector loops: the first off bytes of the buffer are consumed,   *)
(* the polynomial holds their accepted coefficients, bf bytes of them   *)
op svsampled (b : W8.t Array272.t) (p : wpoly) (bf off : int) =
     off <= 272
  /\ 4 %| off
  /\ bf <= 1024
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
  0 <= off => off' <= 272 => 4 %| off =>
  4 * size (sreject (Array272.sub b 0 off)) <= 992 =>
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

(* the offsets stay below 272, so their bumps do not wrap               *)
lemma to_uintD_small16 (w : W64.t) (n : int) :
  0 <= n <= 16 => to_uint w <= 272 =>
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
  /\ shuffle_table_pointer = cOMPACTION_INDEX_TABLE
  /\ 0 <= off /\ 4 %| off /\ 0 <= rest
  /\ off + 4 + rest <= 272
  /\ take 8 (W16u8.to_list cb_) = map cbyte (scands (Array272.sub b off 4))
  /\ to_uint go_ = bs2int (map saccept (scands (Array272.sub b off (4 + rest))))
  /\ to_uint bf_ <= 992
  /\ to_uint bf_ = 4 * size (sreject (Array272.sub b 0 off))
  /\ agree p_ 0 (sreject (Array272.sub b 0 off))
  ==>
     svsampled b res.`1 (to_uint res.`2) (off + 4)
  /\ to_uint res.`2 <= to_uint bf_ + 32
  /\ to_uint res.`3 = bs2int (map saccept (scands (Array272.sub b (off + 4) rest))) ].
proof.
proc*.
ecall (error_4x____write_out_8_coefficientsP p_
        (sreject (Array272.sub b 0 off))
        (scands (Array272.sub b off 4))
        (scands (Array272.sub b (off + 4) rest))
        bf_ go_ cb_).
auto=> &hr |> ge0_off hdvd ge0_rest hle hcb hgo hlt hbf hag.
do ! split.
- by rewrite size_scands size_sub.
- by move: hgo; rewrite PA_272_136.sub_cat_272 // scands_cat.
- by smt(size_ge0).
move=> _ _ _ result hragree hrsz hrgo.
split; 1: by apply (svsampled_advance4 _ _ _ off) => //; smt().
by rewrite hrsz hbf size_cat; have := size_window4_le8 b off; smt().
qed.

(* -------------------------------------------------------------------- *)
(* writing out the four windows of a 16-byte block                      *)
lemma write_out_blockP (p_ : wpoly) (b : W8.t Array272.t) (off : int)
                       (bf_ go_ : W64.t) (co_ : W256.t) :
hoare[ M.error_4x____write_out_32_coefficients :
     error = p_ /\ bytes_filled = bf_ /\ good_overall = go_ /\ coefficients = co_
  /\ shuffle_table_pointer = cOMPACTION_INDEX_TABLE
  /\ 0 <= off /\ 4 %| off /\ off + 16 <= 272
  /\ co_ = W32u8.pack32 (map cbyte (scands (Array272.sub b off 16)))
  /\ to_uint go_ = bs2int (map saccept (scands (Array272.sub b off 16)))
  /\ to_uint bf_ <= 896
  /\ to_uint bf_ = 4 * size (sreject (Array272.sub b 0 off))
  /\ agree p_ 0 (sreject (Array272.sub b 0 off))
  ==>
     svsampled b res.`1 (to_uint res.`2) (off + 16) ].
proof.
proc.
seq 2 : (
     shuffle_table_pointer = cOMPACTION_INDEX_TABLE /\ coefficients = co_
  /\ 0 <= off /\ 4 %| off /\ off + 16 <= 272
  /\ co_ = W32u8.pack32 (map cbyte (scands (Array272.sub b off 16)))
  /\ to_uint bf_ <= 896
  /\ svsampled b error (to_uint bytes_filled) (off + 4)
  /\ to_uint bytes_filled <= to_uint bf_ + 32
  /\ to_uint good_overall = bs2int (map saccept (scands (Array272.sub b (off + 4) 12)))
  /\ coefficient_block = VEXTRACTI128 co_ W8.zero
).
- ecall (write_out_windowP p_ b off 12 bf_ go_ (VEXTRACTI128 co_ W8.zero)).
  auto=> &hr |> ge0_off hdvd hle hgo hbf896 hbf hag.
  split; last by smt().
  rewrite !sub4E_272 !sub16E_272 scands16E /scands /= /nibbles /=.
  by rewrite VEXTRACTI128_0_pack32E /=.
exlim error, bytes_filled, good_overall => p1 bf1 go1.
seq 2 : (
     shuffle_table_pointer = cOMPACTION_INDEX_TABLE /\ coefficients = co_
  /\ 0 <= off /\ 4 %| off /\ off + 16 <= 272
  /\ co_ = W32u8.pack32 (map cbyte (scands (Array272.sub b off 16)))
  /\ to_uint bf_ <= 896
  /\ svsampled b error (to_uint bytes_filled) (off + 8)
  /\ to_uint bytes_filled <= to_uint bf_ + 64
  /\ to_uint good_overall = bs2int (map saccept (scands (Array272.sub b (off + 8) 8)))
).
- ecall (write_out_windowP p1 b (off + 4) 8 bf1 go1
           (VPSRLDQ_128 (VEXTRACTI128 co_ W8.zero) (W8.of_int 8))).
  auto=> &hr |> ge0_off hdvd hle hbf896 hsv hbf hgo.
  move: hsv => @/svsampled [#] hoffle hdvd4 hbfle hsz hag.
  split; last by smt().
  do ! split; 1,2,4,5,6: smt().
  rewrite !sub4E_272 !sub16E_272 scands16E /scands /= /nibbles /=.
  by rewrite VEXTRACTI128_0_pack32E VPSRLDQ8_pack16E /=.
exlim error, bytes_filled, good_overall => p2 bf2 go2.
seq 2 : (
     shuffle_table_pointer = cOMPACTION_INDEX_TABLE /\ coefficients = co_
  /\ 0 <= off /\ 4 %| off /\ off + 16 <= 272
  /\ co_ = W32u8.pack32 (map cbyte (scands (Array272.sub b off 16)))
  /\ to_uint bf_ <= 896
  /\ svsampled b error (to_uint bytes_filled) (off + 12)
  /\ to_uint bytes_filled <= to_uint bf_ + 96
  /\ to_uint good_overall = bs2int (map saccept (scands (Array272.sub b (off + 12) 4)))
  /\ coefficient_block = VEXTRACTI128 co_ W8.one
).
- ecall (write_out_windowP p2 b (off + 8) 4 bf2 go2 (VEXTRACTI128 co_ W8.one)).
  auto=> &hr |> ge0_off hdvd hle hbf896 hsv hbf hgo.
  move: hsv => @/svsampled [#] hoffle hdvd4 hbfle hsz hag.
  split; last by smt().
  do ! split; 1,2,4,5,6: smt().
  rewrite !sub4E_272 !sub16E_272 scands16E /scands /= /nibbles /=.
  by rewrite VEXTRACTI128_1_pack32E /=.
exlim error, bytes_filled, good_overall => p3 bf3 go3.
ecall (write_out_windowP p3 b (off + 12) 0 bf3 go3
         (VPSRLDQ_128 (VEXTRACTI128 co_ W8.one) (W8.of_int 8))).
auto=> &hr |> ge0_off hdvd hle hbf896 hsv hbf hgo.
move: hsv => @/svsampled [#] hoffle hdvd4 hbfle hsz hag.
do ! split; 1,2,4,5,6: smt().
rewrite !sub4E_272 !sub16E_272 scands16E /scands /= /nibbles /=.
by rewrite VEXTRACTI128_1_pack32E VPSRLDQ8_pack16E /=.
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

(* -------------------------------------------------------------------- *)
(* at most two accepted candidates per byte                             *)
lemma size_sreject_sub (b : W8.t Array272.t) (n : int) :
  0 <= n <= 272 => size (sreject (Array272.sub b 0 n)) <= 2 * n.
proof.
move=> hn; rewrite srejectE size_map size_filter.
by have := count_size saccept (scands (Array272.sub b 0 n)); rewrite size_scands size_sub /#.
qed.

(* -------------------------------------------------------------------- *)
(* the candidate loop: the coefficients of the first n candidates of    *)
(* the buffer                                                           *)
op nsamp (b : W8.t Array272.t) (n : int) : W32.t list =
  map scoeff (filter saccept (take n (scands (Array272.sub b 0 272)))).

lemma nsamp_bytes (b : W8.t Array272.t) (off : int) : 0 <= off <= 272 =>
  nsamp b (2 * off) = sreject (Array272.sub b 0 off).
proof.
move=> hoff; rewrite /nsamp srejectE (_ : 272 = off + (272 - off)) 1:/#.
rewrite PA_272_136.sub_cat_272 1,2:/# scands_cat.
have hsz : size (scands (Array272.sub b 0 off)) = 2 * off.
- by rewrite size_scands size_sub /#.
by rewrite -hsz take_size_cat.
qed.

lemma nsamp_full (b : W8.t Array272.t) :
  nsamp b 544 = sreject (Array272.sub b 0 272).
proof. by rewrite (nsamp_bytes b 272). qed.

(* candidate n: the low nibble of byte n / 2, then its high nibble      *)
lemma nth_scands (b : W8.t Array272.t) (n : int) : 0 <= n < 544 =>
  nth W8.zero (scands (Array272.sub b 0 272)) n
  = if n %% 2 = 0 then b.[n %/ 2] `&` W8.of_int 15 else b.[n %/ 2] `>>>` 4.
proof.
move=> hn; pose k := n %/ 2.
rewrite (_ : 272 = k + (272 - k)) 1:/# PA_272_136.sub_cat_272 1,2:/# scands_cat.
rewrite nth_cat size_scands size_sub 1:/# ifF 1:/#.
rewrite (_ : 272 - k = 1 + (271 - k)) 1:/# PA_272_136.sub_cat_272 1,2:/# scands_cat.
rewrite sub1E_272 /= (_ : scands [b.[k]] = nibbles b.[k]).
- by rewrite /scands /= flatten_cons flatten_nil cats0.
rewrite /nibbles /=; case: (n %% 2 = 0) => hp.
- by rewrite (_ : n - 2 * k = 0) 1:/#.
by rewrite (_ : n - 2 * k = 1) 1:/#.
qed.

lemma nsampS (b : W8.t Array272.t) (n : int) : 0 <= n < 544 =>
  nsamp b (n + 1)
  = nsamp b n ++ halfstep (nth W8.zero (scands (Array272.sub b 0 272)) n).
proof.
move=> hn; rewrite /nsamp (take_nth W8.zero) 1:size_scands 1:size_sub 1:/# 1:/#.
rewrite -cats1 filter_cat map_cat /=.
by case: (saccept (nth W8.zero (scands (Array272.sub b 0 272)) n)).
qed.

(* -------------------------------------------------------------------- *)
(* the candidate of the last loop, and its acceptance bit               *)
lemma cand_extractE (b : W8.t) (n : W64.t) :
  SHRX_32 (zeroextu32 b) ((truncateu32 n `&` W32.one) `<<` W8.of_int 2) `&` W32.of_int 15
  = zeroextu32 (if to_uint n %% 2 = 0 then b `&` W8.of_int 15 else b `>>>` 4).
proof.
have hs : to_uint ((truncateu32 n `&` W32.one) `<<` W8.of_int 2) = 4 * (to_uint n %% 2).
- rewrite /(`<<`) /= W32.to_uint_shl //= (_ : W32.one = W32.of_int (2 ^ 1 - 1)) //.
  rewrite W32.to_uint_and_mod //=.
  rewrite -truncateu32_64E /truncateu32 of_uintK /= modz_dvd //.
  by rewrite pmod_small /#.
rewrite /SHRX_32 hs; case: (to_uint n %% 2 = 0) => hp.
- by rewrite hp /= WE32.shr0 zext_and15E.
have -> /= : to_uint n %% 2 = 1 by smt().
have := zext_shr4E b; rewrite /(`>>`) /= => ->.
rewrite zext_and15E; congr.
apply W8.wordP => i hi; rewrite W8.andwE W8.of_intwE /W8.int_bit /= hi /=.
case: (i < 4) => h4; last by rewrite W8.get_out /#.
have : i \in iota_ 0 4 by rewrite mem_iota /#.
by rewrite -iotaredE /= => -[|[|[|]]] ->.
qed.

lemma accepted_bitE (z : W8.t) : to_uint z < 16 =>
  to_uint (zeroextu64 ((zeroextu32 z - W32.of_int rej_bound) `>>` W8.of_int 31))
  = b2i (saccept z).
proof.
move=> hz; have hb := rej_bound_rng.
have hzK : to_uint (zeroextu32 z) = to_uint z by rewrite W4u8.to_uint_zeroextu32.
have hbK : to_uint (W32.of_int rej_bound) = rej_bound by rewrite of_uintK pmod_small /#.
rewrite to_uint_zeroextu64 /(`>>`) /= WE32.to_uint_shr_msb.
by rewrite WE32.msb_sub ?hzK ?hbK /= 1,2:/#.
qed.

(* ==================================================================== *)
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
proc change ^while{4}.^if : { coefficient <- sred32 coefficient; }.
- by inline *; if{1}; auto => /> &2 h; rewrite /sred32 h.
seq 12 : (
     randombytes = buf
  /\ values = (if Eta = 2 then error_4x__ERROR_COEFFICIENTS_ETA2
               else error_4x__ERROR_COEFFICIENTS_ETA4)
  /\ shuffle_table_pointer = cOMPACTION_INDEX_TABLE
  /\ bound = VPBROADCAST_32u8 (W8.of_int rej_bound)
  /\ nibble_mask = VPBROADCAST_32u8 (W8.of_int 15)
  /\ bytes_filled = W64.zero /\ xof_offset = W64.zero).
- by auto => &hr |>; rewrite !truncateu8_bcastE.
(* the first 8 blocks: at most 2 coefficients per byte so far, hence    *)
(* room for the 32 of the block                                         *)
seq 2 : (
     randombytes = buf
  /\ values = (if Eta = 2 then error_4x__ERROR_COEFFICIENTS_ETA2
               else error_4x__ERROR_COEFFICIENTS_ETA4)
  /\ shuffle_table_pointer = cOMPACTION_INDEX_TABLE
  /\ bound = VPBROADCAST_32u8 (W8.of_int rej_bound)
  /\ nibble_mask = VPBROADCAST_32u8 (W8.of_int 15)
  /\ svsampled buf error (to_uint bytes_filled) (to_uint xof_offset)
  /\ to_uint xof_offset = 128).
- while (
       randombytes = buf
    /\ values = (if Eta = 2 then error_4x__ERROR_COEFFICIENTS_ETA2
                 else error_4x__ERROR_COEFFICIENTS_ETA4)
    /\ shuffle_table_pointer = cOMPACTION_INDEX_TABLE
    /\ bound = VPBROADCAST_32u8 (W8.of_int rej_bound)
    /\ nibble_mask = VPBROADCAST_32u8 (W8.of_int 15)
    /\ svsampled buf error (to_uint bytes_filled) (to_uint xof_offset)
    /\ 16 %| to_uint xof_offset /\ to_uint xof_offset <= 128
    /\ condition_loop = (xof_offset \ult W64.of_int 128)); last first.
  - auto => &hr |>; rewrite /svsampled /=.
    by rewrite !dvdz0 /= => bf cl e off _ _ _ hle; rewrite ultE of_uintK /= /#.
  exlim xof_offset => off0.
  seq 3 : (
       randombytes = buf
    /\ values = (if Eta = 2 then error_4x__ERROR_COEFFICIENTS_ETA2
                 else error_4x__ERROR_COEFFICIENTS_ETA4)
    /\ shuffle_table_pointer = cOMPACTION_INDEX_TABLE
    /\ bound = VPBROADCAST_32u8 (W8.of_int rej_bound)
    /\ nibble_mask = VPBROADCAST_32u8 (W8.of_int 15)
    /\ svsampled buf error (to_uint bytes_filled) (to_uint xof_offset)
    /\ 16 %| to_uint off0 /\ to_uint off0 < 128 /\ xof_offset = off0
    /\ candidates = W32u8.pack32 (scands (Array272.sub buf (to_uint off0) 16))).
  - ecall (error_4x____bytestream_to_coefficientsP
             (W16u8.pack16 (Array272.sub buf (to_uint off0) 16))).
    auto=> &hr |> hsv hdvd hle; rewrite ultE of_uintK /= => hlt.
    by rewrite WArray272_get128E 1:#smt:(W64.to_uint_cmp) sub16E_272 /= /#.
  seq 4 : (#pre
    /\ to_uint good_overall
         = bs2int (map saccept (scands (Array272.sub buf (to_uint off0) 16)))
    /\ coefficients
         = W32u8.pack32 (map cbyte (scands (Array272.sub buf (to_uint off0) 16)))).
  - wp; skip => &hr hpre; split; first exact hpre.
    have [#] hb hv hs hbd hnm hsv hdvd hlt hx hc := hpre.
    rewrite hv hbd hc /SLH64.protect_64; split.
    - by rewrite sub16E_272 movemask_scands16E.
    by rewrite cbyte_lookupE ?size_scands ?size_sub // => z /scands_nib.
  exlim error, bytes_filled, good_overall, coefficients => p0 bf0 go0 co0.
  wp; ecall (write_out_blockP p0 buf (to_uint off0) bf0 go0 co0).
  skip => &hr [#] 4!-> [#] hb hv hs hbd hnm hsv hdvd hlt hx hc hgo hco.
  have @/svsampled [#] hoffle hdvd4 hbfle hsz hag := hsv.
  have hsub := size_sreject_sub buf (to_uint off0) _; first by smt(W64.to_uint_cmp).
  have hoffD : to_uint (off0 + W64.of_int 16) = to_uint off0 + 16.
  - by rewrite (to_uintD_small16 off0 16) // /#.
  move: hoffle hdvd4 hsz hag; rewrite hx => hoffle hdvd4 hsz hag.
  have hle112 : to_uint off0 <= 112 by move: hdvd hlt => /dvdzP [q ->] /#.
  split; first by rewrite /= hs hco hgo hag hdvd4 /=; smt(W64.to_uint_cmp).
  move=> _ result [#] h1 h2 h3 h4 h5 /=.
  rewrite hoffD hb hs hbd hnm h1 h2 h3 h4 h5 /=; split; first exact hv.
  by split; [smt(dvdzD dvdzz) | smt()].
(* whole blocks while 32 more coefficients fit *)
seq 8 : (
     randombytes = buf
  /\ values = (if Eta = 2 then error_4x__ERROR_COEFFICIENTS_ETA2
               else error_4x__ERROR_COEFFICIENTS_ETA4)
  /\ shuffle_table_pointer = cOMPACTION_INDEX_TABLE
  /\ bound = VPBROADCAST_32u8 (W8.of_int rej_bound)
  /\ nibble_mask = VPBROADCAST_32u8 (W8.of_int 15)
  /\ svsampled buf error (to_uint bytes_filled) (to_uint xof_offset)).
- while (
       randombytes = buf
    /\ values = (if Eta = 2 then error_4x__ERROR_COEFFICIENTS_ETA2
                 else error_4x__ERROR_COEFFICIENTS_ETA4)
    /\ shuffle_table_pointer = cOMPACTION_INDEX_TABLE
    /\ bound = VPBROADCAST_32u8 (W8.of_int rej_bound)
    /\ nibble_mask = VPBROADCAST_32u8 (W8.of_int 15)
    /\ svsampled buf error (to_uint bytes_filled) (to_uint xof_offset)
    /\ condition_loop = (to_uint bytes_filled <= 896 /\ to_uint xof_offset <= 256)
  ); last first.
  - wp; skip => &hr [#] hb hv hs hbd hnm hsv _ /=.
    have @/svsampled [#] h1 h2 h3 h4 h5 := hsv.
    by rewrite WE64.sge0_orw !WE64.sge0_sub //=; smt(W64.to_uint_cmp).
  exlim xof_offset => off0.
  seq 3 : (
       randombytes = buf
    /\ values = (if Eta = 2 then error_4x__ERROR_COEFFICIENTS_ETA2
                 else error_4x__ERROR_COEFFICIENTS_ETA4)
    /\ shuffle_table_pointer = cOMPACTION_INDEX_TABLE
    /\ bound = VPBROADCAST_32u8 (W8.of_int rej_bound)
    /\ nibble_mask = VPBROADCAST_32u8 (W8.of_int 15)
    /\ svsampled buf error (to_uint bytes_filled) (to_uint xof_offset)
    /\ to_uint bytes_filled <= 896 /\ to_uint off0 <= 256 /\ xof_offset = off0
    /\ candidates = W32u8.pack32 (scands (Array272.sub buf (to_uint off0) 16))).
  - ecall (error_4x____bytestream_to_coefficientsP
             (W16u8.pack16 (Array272.sub buf (to_uint off0) 16))).
    auto=> &hr |> hsv hbf hle.
    by rewrite WArray272_get128E 1:#smt:(W64.to_uint_cmp) sub16E_272 /= /#.
  seq 4 : (#pre
    /\ to_uint good_overall
         = bs2int (map saccept (scands (Array272.sub buf (to_uint off0) 16)))
    /\ coefficients
         = W32u8.pack32 (map cbyte (scands (Array272.sub buf (to_uint off0) 16)))).
  - wp; skip => &hr hpre; split; first exact hpre.
    have [#] hb hv hs hbd hnm hsv hbf hle hx hc := hpre.
    rewrite hv hbd hc /SLH64.protect_64; split.
    - by rewrite sub16E_272 movemask_scands16E.
    by rewrite cbyte_lookupE ?size_scands ?size_sub // => z /scands_nib.
  exlim error, bytes_filled, good_overall, coefficients => p0 bf0 go0 co0.
  wp; ecall (write_out_blockP p0 buf (to_uint off0) bf0 go0 co0).
  skip => &hr [#] 4!-> [#] hb hv hs hbd hnm hsv hbf hle hx hc hgo hco.
  have @/svsampled [#] hoffle hdvd4 hbfle hsz hag := hsv.
  have hoffD : to_uint (off0 + W64.of_int 16) = to_uint off0 + 16.
  - by rewrite (to_uintD_small16 off0 16) // /#.
  move: hoffle hdvd4 hsz hag; rewrite hx => hoffle hdvd4 hsz hag.
  split; first by rewrite /= hs hco hgo hag hdvd4 /=; smt(W64.to_uint_cmp).
  move=> _ result [#] h1 h2 h3 h4 h5 /=.
  rewrite hoffD hb hs hbd hnm h1 h2 h3 h4 h5 /=; split; first exact hv.
  by rewrite WE64.sge0_orw !WE64.sge0_sub //= ?hoffD; smt(W64.to_uint_cmp).
(* groups of 8 candidates while 8 more coefficients fit *)
seq 8 : (
     randombytes = buf
  /\ svsampled buf error (to_uint bytes_filled) (to_uint xof_offset)).
- while (
       randombytes = buf
    /\ values = (if Eta = 2 then error_4x__ERROR_COEFFICIENTS_ETA2
                 else error_4x__ERROR_COEFFICIENTS_ETA4)
    /\ shuffle_table_pointer = cOMPACTION_INDEX_TABLE
    /\ bound = VPBROADCAST_32u8 (W8.of_int rej_bound)
    /\ nibble_mask = VPBROADCAST_32u8 (W8.of_int 15)
    /\ svsampled buf error (to_uint bytes_filled) (to_uint xof_offset)
    /\ condition_loop = (to_uint bytes_filled <= 992 /\ to_uint xof_offset <= 256)
  ); last first.
  - wp; skip => &hr [#] hb hv hs hbd hnm hsv /=.
    have @/svsampled [#] h1 h2 h3 h4 h5 := hsv.
    by rewrite WE64.sge0_orw !WE64.sge0_sub //=; smt(W64.to_uint_cmp).
  exlim xof_offset => off0.
  seq 3 : (
       randombytes = buf
    /\ values = (if Eta = 2 then error_4x__ERROR_COEFFICIENTS_ETA2
                 else error_4x__ERROR_COEFFICIENTS_ETA4)
    /\ shuffle_table_pointer = cOMPACTION_INDEX_TABLE
    /\ bound = VPBROADCAST_32u8 (W8.of_int rej_bound)
    /\ nibble_mask = VPBROADCAST_32u8 (W8.of_int 15)
    /\ svsampled buf error (to_uint bytes_filled) (to_uint xof_offset)
    /\ to_uint bytes_filled <= 992 /\ to_uint off0 <= 256 /\ xof_offset = off0
    /\ candidates = W32u8.pack32 (scands (Array272.sub buf (to_uint off0) 16))).
  - ecall (error_4x____bytestream_to_coefficientsP
             (W16u8.pack16 (Array272.sub buf (to_uint off0) 16))).
    auto=> &hr |> hsv hbf hle.
    by rewrite WArray272_get128E 1:#smt:(W64.to_uint_cmp) sub16E_272 /= /#.
  seq 5 : (#pre
    /\ to_uint good_overall
         = bs2int (map saccept (scands (Array272.sub buf (to_uint off0) 16)))
    /\ coefficient_block
         = VEXTRACTI128
             (W32u8.pack32 (map cbyte (scands (Array272.sub buf (to_uint off0) 16))))
             W8.zero).
  - wp; skip => &hr hpre; split; first exact hpre.
    have [#] hb hv hs hbd hnm hsv hbf hle hx hc := hpre.
    rewrite hv hbd hc /SLH64.protect_64; split.
    - by rewrite sub16E_272 movemask_scands16E.
    by rewrite cbyte_lookupE ?size_scands ?size_sub // => z /scands_nib.
  exlim error, bytes_filled, good_overall, coefficient_block => p0 bf0 go0 cb0.
  wp; ecall (write_out_windowP p0 buf (to_uint off0) 12 bf0 go0 cb0).
  skip => &hr [#] 4!-> [#] hb hv hs hbd hnm hsv hbf hle hx hc hgo hcb.
  have @/svsampled [#] hoffle hdvd4 hbfle hsz hag := hsv.
  have hoffD : to_uint (off0 + W64.of_int 4) = to_uint off0 + 4.
  - by rewrite (to_uintD_small16 off0 4) // /#.
  move: hoffle hdvd4 hsz hag; rewrite hx => hoffle hdvd4 hsz hag.
  split.
  - rewrite /= hs hgo hag hdvd4 hbf /=; split; first by smt(W64.to_uint_cmp).
    rewrite hcb !sub4E_272 !sub16E_272 scands16E /scands /= /nibbles /=.
    split; first by smt().
    by split; [rewrite VEXTRACTI128_0_pack32E /= | exact hsz].
  move=> _ result [#] h1 h2 h3 h4 h5 h6 h7 /=.
  rewrite hoffD hb hs hbd hnm h1 h2 h3 h4 h5 /=; split; first exact hv.
  by rewrite WE64.sge0_orw !WE64.sge0_sub //= ?hoffD; smt(W64.to_uint_cmp).
(* one candidate at a time while coefficients are missing *)
seq 11 : (
     randombytes = buf
  /\ to_uint candidate_index <= 544
  /\ filled_ok error (nsamp buf (to_uint candidate_index)) (to_uint filled)
  /\ condition_loop = (to_uint filled < 256 /\ to_uint candidate_index < 544)).
- wp; skip => &hr [#] hb hsv /=; have @/svsampled [#] h1 h2 h3 h4 h5 := hsv.
  have hci : to_uint (xof_offset{hr} `<<` W8.one) = 2 * to_uint xof_offset{hr}.
  - by rewrite /(`<<`) /= WE64.to_uint_shl_small //=; smt(W64.to_uint_cmp).
  have hfl : to_uint (bytes_filled{hr} `>>` W8.of_int 2) = to_uint bytes_filled{hr} %/ 4.
  - by rewrite to_uint_shr2.
  rewrite hb WE64.slt0_andw !WE64.slt0_sub //= ?hci ?hfl; 1,2: smt(W64.to_uint_cmp).
  rewrite nsamp_bytes 1:#smt:(W64.to_uint_cmp) /filled_ok h5 /=.
  by smt().
wp; while (
     randombytes = buf
  /\ to_uint candidate_index <= 544
  /\ filled_ok error (nsamp buf (to_uint candidate_index)) (to_uint filled)
  /\ condition_loop = (to_uint filled < 256 /\ to_uint candidate_index < 544)
); last first.
- skip => &hr [#] hb hle hok hcl; split; first by rewrite hb hle hok hcl.
  move=> ci cl e f hncl [#] _ hle' hok' hcl'.
  have hsplit : sreject (Array272.sub buf 0 272)
    = nsamp buf (to_uint ci)
      ++ map scoeff (filter saccept (drop (to_uint ci) (scands (Array272.sub buf 0 272)))).
  - rewrite -nsamp_full /nsamp -map_cat -filter_cat cat_take_drop take_oversize //.
    by rewrite size_scands size_sub.
  have hfull : filled_ok e (sreject (Array272.sub buf 0 272)) (to_uint f).
  - rewrite hsplit; case: (to_uint f = 256) => hf; first by apply filled_ok_full.
    have hci : to_uint ci = 544 by move: hok' => @/filled_ok [_ hmin]; smt().
    rewrite hci drop_oversize /= ?cats0; first by rewrite size_scands size_sub.
    by move: hok'; rewrite hci.
  by move: hfull => @/filled_ok [-> ->].
(* the candidate, its acceptance bit and its coefficient *)
seq 16 : (
     randombytes = buf
  /\ to_uint candidate_index < 544 /\ to_uint filled < 256
  /\ filled_ok error (nsamp buf (to_uint candidate_index)) (to_uint filled)
  /\ to_uint (zeroextu64 accepted)
       = b2i (saccept (nth W8.zero (scands (Array272.sub buf 0 272))
                         (to_uint candidate_index)))
  /\ coefficient
       = - (sred32 (zeroextu32 (nth W8.zero (scands (Array272.sub buf 0 272))
                                  (to_uint candidate_index)))
            - W32.of_int Eta)).
- wp; skip => &hr [#] hb hle hok hcl hc.
  have [hf hn] : to_uint filled{hr} < 256 /\ to_uint candidate_index{hr} < 544 by smt().
  have hsh : to_uint (candidate_index{hr} `>>` W8.one) = to_uint candidate_index{hr} %/ 2.
  - by rewrite /(`>>`) /= W64.to_uint_shr.
  rewrite hsh cand_extractE hb hf hn hok /SLH64.protect_32 /=.
  rewrite nth_scands 1:#smt:(W64.to_uint_cmp) /=.
  apply accepted_bitE.
  by case: (to_uint candidate_index{hr} %% 2 = 0) => _;
       [exact to_uint_lonib_lt16 | exact to_uint_hinib_lt16].
(* the store at the first missing position, which advances if the      *)
(* candidate is accepted                                               *)
wp; skip => &hr [#] hb hn hf hok hacc hco.
pose z := nth W8.zero (scands (Array272.sub buf 0 272)) (to_uint candidate_index{hr}).
have hfD : to_uint (filled{hr} + zeroextu64 accepted{hr})
           = to_uint filled{hr} + b2i (saccept z).
- by rewrite W64.to_uintD_small hacc -/z; smt(W64.to_uint_cmp).
have hnD : to_uint (candidate_index{hr} + W64.one) = to_uint candidate_index{hr} + 1.
- by rewrite W64.to_uintD_small /= /#.
rewrite /= hb WE64.slt0_andw !WE64.slt0_sub //= ?hfD ?hnD; 1,2: smt(W64.to_uint_cmp).
split; first by smt().
rewrite nsampS 1:#smt:(W64.to_uint_cmp) -/z hco -/z.
case: (saccept z) => hz /=.
- by rewrite scoeffE //; exact filled_ok_snoc.
rewrite cats0; move: hok => @/filled_ok [hag hmin]; split => //.
rewrite /agree => i hi hi2.
move: hag => @/agree /(_ i hi hi2) <-.
by rewrite Array256.get_setE 1:/# ifF 1:/#.
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
proc; inline M.error_4x____reduce_coefficient M.error_4x____write_out_32_coefficients
  M.error_4x____write_out_8_coefficients M.error_4x____bytestream_to_coefficients.
wp.
(* one candidate per iteration *)
while (   to_uint candidate_index <= 544
       /\ (condition_loop => to_uint candidate_index < 544))
      (544 - to_uint candidate_index).
- move=> z; auto => &hr |> hle hlt hc.
  have h1 : to_uint (candidate_index{hr} + W64.one) = to_uint candidate_index{hr} + 1.
  - by rewrite to_uintD_small /= /#.
  split; last by rewrite h1 /#.
  split; first by rewrite h1 /#.
  by rewrite WE64.slt0_andw (WE64.slt0_sub (candidate_index{hr} + W64.one)) //= ?h1 /#.
wp.
(* 4 bytes per iteration *)
while (   to_uint xof_offset <= 272
       /\ (condition_loop => to_uint xof_offset <= 256))
      (272 - to_uint xof_offset).
- move=> z; auto => &hr |> hle hlt hc.
  have h1 : to_uint (xof_offset{hr} + W64.of_int 4) = to_uint xof_offset{hr} + 4.
  - by rewrite to_uintD_small /= /#.
  split; last by rewrite h1 /#.
  split; first by rewrite h1 /#.
  by rewrite WE64.sge0_orw (WE64.sge0_sub _ (xof_offset{hr} + W64.of_int 4)) //= ?h1 /#.
wp.
(* 16 bytes per iteration *)
while (   to_uint xof_offset <= 272
       /\ (condition_loop => to_uint xof_offset <= 256))
      (272 - to_uint xof_offset).
- move=> z; auto => &hr |> hle hlt hc.
  have h1 : to_uint (xof_offset{hr} + W64.of_int 16) = to_uint xof_offset{hr} + 16.
  - by rewrite to_uintD_small /= /#.
  split; last by rewrite h1 /#.
  split; first by rewrite h1 /#.
  by rewrite WE64.sge0_orw (WE64.sge0_sub _ (xof_offset{hr} + W64.of_int 16)) //= ?h1 /#.
wp.
while (   16 %| to_uint xof_offset /\ to_uint xof_offset <= 128
       /\ (condition_loop => to_uint xof_offset < 128))
      (128 - to_uint xof_offset).
- move=> z; auto => &hr |> hdvd hle hlt hc.
  have h1 : to_uint (xof_offset{hr} + W64.of_int 16) = to_uint xof_offset{hr} + 16.
  - by rewrite to_uintD_small /= /#.
  have h112 : to_uint xof_offset{hr} <= 112.
  - by have := hlt hc; move: hdvd => /dvdzP [q ->] /#.
  split; last by rewrite h1 /#.
  split; first by rewrite h1; smt(dvdzD dvdzz).
  by split; [rewrite h1 /# | rewrite ultE of_uintK].
(* between the loops: a loop that runs has room in the buffer *)
wp; skip => &hr _ /=.
split; first exact dvdz0.
move=> bf0 cl0 off0; split; first by smt().
move=> _ [#] _ hoff0 _; split.
- split; first by smt().
  by rewrite WE64.sge0_orw (WE64.sge0_sub _ off0) //= /#.
move=> bf1 cl1 off1; split; first by smt().
move=> _ [#] hoff1 _; split.
- by rewrite hoff1 /= WE64.sge0_orw (WE64.sge0_sub _ off1) //= /#.
move=> bf2 cl2 off2; split; first by smt().
move=> _ [#] hoff2 _.
have hsh : to_uint (off2 `<<` W8.one) = 2 * to_uint off2.
- by rewrite /(`<<`) /= WE64.to_uint_shl_small //= /#.
split; last by smt().
split; first by rewrite hsh /#.
by rewrite WE64.slt0_andw (WE64.slt0_sub (off2 `<<` W8.one)) //= ?hsh /#.
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
  rewrite hf Array4.initiE //=.
  by have := stream_fuelP (nonce i) k (hok i rgi) (hfuel i rgi); smt().
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
