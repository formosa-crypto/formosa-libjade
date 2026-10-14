(* -------------------------------------------------------------------- *)
require import AllCore CoreUtils List List_extra IntDiv IntMin BitEncoding.

import BitChunking.

(* -------------------------------------------------------------------- *)
from Jasmin require import JWord JModel_x86.

require import Agree.
require import Avx2red.
require import Prefixarray.
require import Rejstream.
require import Warraypack.
require import JArrayExtra.
require import Array2 Array4 Array25 Array32 Array168 Array256 Array848.
require import WArray2 WArray256 WArray848 WArray1024.
require import XArray256.
require import MldsaConstants.
require BaseT Sha3x4.

(* The sampling of the matrix A (ExpandA): the four-lane rejection
   sampler, the same for every set, and the matrix of k * l polynomials,
   sampled four at a time, with a two-polynomial tail when k * l = 2
   (mod 4). *)
abstract theory AexpandT.

clone import BaseT.BaseT as B.
import S R MLDSAParams.
clone import Sha3x4.Sha3x4T as SX with theory P <- S, theory R <- R.
import Shake128x4.
import Array_klpolys.

clone JArrayExtra.PAE as PAK with
      op size <- klpolys,
  theory A    <- Array_klpolys.

(* -------------------------------------------------------------------- *)
hint simplify dvdz0.

(* -------------------------------------------------------------------- *)
op modulus : int = 8380417.

(* -------------------------------------------------------------------- *)
hint simplify b2i0, b2i1.

(* -------------------------------------------------------------------- *)
(* -------------------------------------------------------------------- *)
clone import Prefixarray.PrefixArray as PA_848_168 with
      op sizeB <- 168,
      op sizeS <- 848,
  theory AB    <- Array168,
  theory AS    <- Array848

  rename "'S" as "_848"
         "'B" as "_168"

  proof le_size by done.

(* -------------------------------------------------------------------- *)
clone Warraypack.WArrayPack as WP848 with
      op size <- 848,
  theory A    <- Array848,
  theory WA   <- WArray848
  rename "get" as "WArray848_get"
  proof *.
realize A.WArray848_get_out by exact Array848.get_out.
realize WA.WArray848_get_out by exact WArray848.get_out.
realize WA.WArray848_get16E by exact WArray848.get16E.
realize WA.WArray848_get32E by exact WArray848.get32E.
realize WA.WArray848_get64E by exact WArray848.get64E.
realize WA.WArray848_get128E by exact WArray848.get128E.
realize WA.WArray848_get256E by exact WArray848.get256E.
realize WA.ArrayW8.WArray848_get_out by exact WArray848.ArrayW8.get_out.

clone Warraypack.WArrayPack as WP256 with
      op size <- 256,
  theory A    <- Array256,
  theory WA   <- WArray256
  rename "get" as "WArray256_get"
  proof *.
realize A.WArray256_get_out by exact Array256.get_out.
realize WA.WArray256_get_out by exact WArray256.get_out.
realize WA.WArray256_get16E by exact WArray256.get16E.
realize WA.WArray256_get32E by exact WArray256.get32E.
realize WA.WArray256_get64E by exact WArray256.get64E.
realize WA.WArray256_get128E by exact WArray256.get128E.
realize WA.WArray256_get256E by exact WArray256.get256E.
realize WA.ArrayW8.WArray256_get_out by exact WArray256.ArrayW8.get_out.

import WP848 WP256.

(* -------------------------------------------------------------------- *)
type rho   = W8.t Array32.t.
type wpoly = W32.t Array256.t.
type A     = W32.t Array_klpolys.t.

(* -------------------------------------------------------------------- *)

(* -------------------------------------------------------------------- *)

(* -------------------------------------------------------------------- *)

(* -------------------------------------------------------------------- *)
lemma matrix_A__shake128_absorb_34_4xP
  (rho_ : rho) (ds_ : W16.t Array4.t)
: hoare[
  M.shake128_absorb_34_4x :
      rho = rho_ /\ domain_separators = ds_
    ==>
      let state =
        Array4.map (fun w => mk_absorbed (to_list rho_ ++ W2u8.to_list w)) ds_
      in res \sha3for state
  ].
proof.
proc.
(* state initialization *)
seq 5 : (rho = rho_ /\ domain_separators = ds_ /\
         state \sha3for Array4.init (fun _ => mk_absorbing [])).
- by call state_init_avx2x4_128P; auto.
(* rho is absorbed identically into the four lanes *)
seq 1 : (domain_separators = ds_ /\
         state \sha3for Array4.init (fun _ => mk_absorbing (to_list rho_))).
- by call (absorb_bcast_avx2x4_128P rho_); auto.
(* the four domain separators are marshaled to byte pairs *)
seq 4 : (state \sha3for Array4.init (fun _ => mk_absorbing (to_list rho_))
         /\ to_list d0 = W2u8.to_list ds_.[0]
         /\ to_list d1 = W2u8.to_list ds_.[1]
         /\ to_list d2 = W2u8.to_list ds_.[2]
         /\ to_list d3 = W2u8.to_list ds_.[3]).
- by auto=> &hr |> hst; rewrite ?pack2_to_listE.
(* the final absorb completes each lane's stream *)
call (absorb_2_final_avx2x4_128P (to_list rho_) ds_).
by skip => &hr |> hst h0 h1 h2 h3; rewrite Array32.size_to_list.
qed.



(* -------------------------------------------------------------------- *)
lemma matrix_A____shake128_squeeze_multiple_blocks_4xP (data : W8.t list Array4.t)
: hoare[
  M.matrix_A____shake128_squeeze_multiple_blocks_4x :
      state \sha3for Array4.map (mk_absorbed) data
    ==>
         res.`1 \sha3for Array4.map (mk_read (168 * 5)) data
      /\ (forall i, 0 <= i < 4 =>
            let b = nth witness [res.`2; res.`3; res.`4; res.`5] i in
            Array848.sub b 0 840 = shake128_slice data.[i] 0 840)
  ].
proof.
proc.
sp.
(* each iteration squeezes one block into every lane's next window *)
while (0 <= i <= 5
    /\ state \sha3for Array4.map (mk_read (168 * i)) data
    /\ Array848.sub b0 0 (168 * i) = shake128_slice data.[0] 0 (168 * i)
    /\ Array848.sub b1 0 (168 * i) = shake128_slice data.[1] 0 (168 * i)
    /\ Array848.sub b2 0 (168 * i) = shake128_slice data.[2] 0 (168 * i)
    /\ Array848.sub b3 0 (168 * i) = shake128_slice data.[3] 0 (168 * i)).
- exlim i => i_.
  wp; ecall (shake128_squeezeblock4xP data i_).
  skip => &hr |> hi0 _ hst hs0 hs1 hs2 hs3 hlt r hres hblk /=.
  move: (hblk 0 _) (hblk 1 _) (hblk 2 _) (hblk 3 _) => //= hb0 hb1 hb2 hb3.
  do! split; 1,2: smt().
  - by rewrite sub_window_catE 1:/# hs0
       (shake128_slice_cat_block data.[0] i{hr} r.`2 hi0 hb0).
  - by rewrite sub_window_catE 1:/# hs1
       (shake128_slice_cat_block data.[1] i{hr} r.`3 hi0 hb1).
  - by rewrite sub_window_catE 1:/# hs2
       (shake128_slice_cat_block data.[2] i{hr} r.`4 hi0 hb2).
  by rewrite sub_window_catE 1:/# hs3
     (shake128_slice_cat_block data.[3] i{hr} r.`5 hi0 hb3).
(* entry: nothing is read yet; exit: the five windows cover 840 bytes *)
skip => &hr |> hst; split.
- by do! split; smt(size_shake128_slice size_eq0).
move=> b00 b10 b20 b30 i0 state0 hge5 hi0 hi5 hrel h0 h1 h2 h3.
have ->>: i0 = 5 by smt().
split; first by exact hrel.
move=> j hj0 hj4.
by have [->|[->|[->|->]]] /=: j = 0 \/ j = 1 \/ j = 2 \/ j = 3 by smt().
qed.

(* -------------------------------------------------------------------- *)
op MODULUS8u32 =
  W8u32.pack8 (nseq 8 (W32.of_int modulus)).

(* -------------------------------------------------------------------- *)
lemma MODULUS8u32E : mODULUS_VECTOR = MODULUS8u32.
proof.
apply/W8u32.wordP=> i rgi; rewrite pack8bE //= get_of_list //.
rewrite of_int_bits32_div //=.
by with hint +listred (move: i rgi; apply/allP_range => /=).
qed.

(* -------------------------------------------------------------------- *)

(* -------------------------------------------------------------------- *)

(* -------------------------------------------------------------------- *)
lemma W32Array256_set128E (a : W32.t Array256.t) (base : int) (w : W128.t) :
  0 <= base => 4 %| base => base + 16 <= 1024 =>
   Array256.init
      (fun (i : int) =>
         WArray1024.get32
           (WArray1024.set128_direct
              (WArray1024.init32 ("_.[_]" a))
              base w) i)
 = XArray256.PAE.replace_ a (base %/ 4) (to_list (W4u32.unpack32 w)).
proof.
move=> ge0 hdvd hle.
apply Array256.ext_eq => i rgi.
rewrite initiE //=.
rewrite /XArray256.PAE.replace_.
rewrite Array256.filliE 1:// /=.
rewrite get32E.
case: (base %/ 4 <= i < base %/ 4 + 4) => hcase //=.
- have -> : W4u8.Pack.init (fun j => (WArray1024.set128_direct (WArray1024.init32 ("_.[_]" a)) base w).[4*i+j])
          = W4u8.Pack.init (fun j => w \bits8 (4 * (i - base %/ 4) + j)).
  - apply W4u8.Pack.init_ext => j hj /=.
    rewrite set128E WArray1024.initiE 1:/# /= ifT 1:/#.
    by congr; smt().
  pose m := i - base %/ 4.
  have rgm : 0 <= m < 4 by smt().
  apply W4u8.wordP => j hj.
  rewrite pack4bE // initiE //=.
  move: rgm; rewrite -(mema_iota 0 4) -iotaredE /= => -[->|[->|[->|->]]] /=.
  - by rewrite W128_bits32_bits8.
  - by rewrite W128_bits32_bits8.
  - by rewrite W128_bits32_bits8.
  by rewrite W128_bits32_bits8.
have -> : W4u8.Pack.init (fun j => (WArray1024.set128_direct (WArray1024.init32 ("_.[_]" a)) base w).[4*i+j])
        = W4u8.Pack.init (fun j => a.[i] \bits8 j).
- apply W4u8.Pack.init_ext => j hj /=.
  rewrite set128E WArray1024.initiE 1:/# /= ifF 1:/#.
  rewrite /init32 WArray1024.initiE 1:/# /=.
  by rewrite (_ : (4*i+j) %/ 4 = i) 1:/# (_ : (4*i+j) %% 4 = j) 1:/#.
by rewrite -/(W4u8.unpack8 a.[i]) W4u8.unpack8K.
qed.

(* -------------------------------------------------------------------- *)
(* -------------------------------------------------------------------- *)
(* -------------------------------------------------------------------- *)

(* -------------------------------------------------------------------- *)
import BS2Int.

abbrev mask23 = W32.of_int (2 ^ 23 - 1).

op accept (w : W32.t) : bool = to_uint w < modulus.

op cands (bs : W8.t list) : W32.t list =
  map (fun ws => W4u8.pack4 ws `&` mask23) (chunk 3 bs).

clone Rejstream.RejStream as ARS with
  type cand   <- W32.t,
    op dec1   <- (fun (g : W8.t list) => [W4u8.pack4 g `&` mask23]),
    op align  <- 3,
    op accept <- accept,
    op coeff  <- idfun<:W32.t>,
    op rate   <- 168,
    op slice  <- shake128_slice,
  type buf    <- W8.t Array848.t,
    op headb  <- (fun (a : W8.t Array848.t) =>
                    Array168.to_list (PA_848_168.truncatea_168 a))

  proof gt0_align  by done,
        ge0_rate   by done,
        align_rate by smt(),
        size_slice by exact size_shake128_slice,
        slice_cat  by exact shake128_slice_cat.

import ARS.

(* the chunked decoder is the 3-byte candidate stream *)
lemma decodeE (bs : W8.t list) : ARS.decode bs = cands bs.
proof. by rewrite /decode /cands flatten1. qed.

lemma rejectE (bs : W8.t list) : reject bs = filter accept (cands bs).
proof. by rewrite ARS.rejectE decodeE map_id. qed.

lemma size_cands (bs : W8.t list) : size (cands bs) = size bs %/ 3.
proof. by rewrite /cands size_map size_chunk. qed.

lemma cands_uint_lt (bs : W8.t list) (w : W32.t) :
  w \in cands bs => 0 <= to_uint w < 2 ^ 23.
proof.
by move=> /mapP [ws [_ ->]]; rewrite W32.to_uint_and_mod // modz_cmp.
qed.

(* -------------------------------------------------------------------- *)
lemma tosint_small (c : W32.t) : 0 <= to_uint c < 2 ^ 23 =>
  to_sint c = to_uint c.
proof.
move=> bnd; rewrite /to_sint /smod ifF //.
by move: bnd => /=; smt().
qed.

lemma tosint_q : to_sint (W32.of_int modulus) = modulus.
proof. by rewrite /to_sint /smod of_uintK /modulus. qed.

lemma msb_lane (c : W32.t) : 0 <= to_uint c < 2 ^ 23 =>
  W32.msb (W8u32.wcmp Int.(<) c (W32.of_int modulus)) = accept c.
proof.
move=> bnd; rewrite /wcmp tosint_small ~-1:// tosint_q /accept.
by case: (to_uint c < modulus) => _ /=.
qed.

(* acceptance bits: the movemask of the comparison lists the accepted   *)
(* candidates, least significant bit first                              *)
lemma map_msb_cmpE (cs : W32.t list) :
  size cs = 8 => (forall w, w \in cs => 0 <= to_uint w < 2 ^ 23) =>
    map W32.msb (W8u32.to_list (VPCMPGT_8u32 MODULUS8u32 (W8u32.pack8 cs)))
  = map accept cs.
proof.
move=> sz8 bnd.
apply (eq_from_nth witness); 1: by rewrite size_map W8u32.size_to_list size_map sz8.
move=> i; rewrite size_map W8u32.size_to_list => rgi.
rewrite (nth_map witness witness); 1: by rewrite W8u32.size_to_list.
rewrite (nth_map W32.zero witness); 1: by rewrite sz8.
rewrite (nth_change_dfl W32.zero witness); 1: by rewrite W8u32.size_to_list.
rewrite W8u32.nth_to_list /VPCMPGT_8u32 W8u32.map2bE 1://.
have -> : W8u32.pack8 (nseq 8 (W32.of_int modulus)) \bits32 i = W32.of_int modulus.
- by rewrite W8u32.pack8bE 1:// W8u32.Pack.get_of_list 1:// nth_nseq 1:/#.
have -> : W8u32.pack8 cs \bits32 i = nth W32.zero cs i.
- by rewrite W8u32.pack8bE 1:// W8u32.Pack.get_of_list 1://.
rewrite msb_lane; 1: by apply bnd; apply mem_nth; rewrite sz8.
done.
qed.

lemma to_uint_good (cs : W32.t list) :
  size cs = 8 => (forall w, w \in cs => 0 <= to_uint w < 2 ^ 23) =>
    to_uint (zeroextu64 (MOVEMASK_8u32 (VPCMPGT_8u32 MODULUS8u32 (W8u32.pack8 cs))))
  = bs2int (map accept cs).
proof.
move=> sz8 bnd; rewrite to_uint_zeroextu64 /MOVEMASK_8u32 /=.
have /= -> := map_msb_cmpE cs sz8 bnd.
rewrite W32.to_uintE.
have -> : w2bits (W32.bits2w (map accept cs)) = map accept cs ++ nseq 24 false.
- apply (eq_from_nth false).
  - by rewrite W32.size_w2bits size_cat size_map sz8 size_nseq.
  move=> i; rewrite W32.size_w2bits => rgi.
  rewrite w2bitsE nth_mkseq //= W32.get_bits2w // nth_cat size_map sz8.
  case: (i < 8) => hc; 1: by done.
  by rewrite nth_default ?size_map ?sz8 1:/# nth_nseq /#.
by rewrite bs2int_cat bs2int_nseq_false.
qed.

(* -------------------------------------------------------------------- *)
(* the two 128-bit halves of the packed candidates                      *)
lemma extract_lo (cs : W32.t list) : size cs = 8 =>
    W4u32.Pack.to_list (W4u32.unpack32 (VEXTRACTI128 (W8u32.pack8 cs) W8.zero))
  = take 4 cs.
proof.
by case: cs => [|c0 [|c1 [|c2 [|c3 [|c4 [|c5 [|c6 [|c7 [|]]]]]]]]] //=.
qed.

lemma extract_hi (cs : W32.t list) : size cs = 8 =>
    W4u32.Pack.to_list (W4u32.unpack32 (VEXTRACTI128 (W8u32.pack8 cs) W8.one))
  = drop 4 cs.
proof.
case: cs => [|c0 [|c1 [|c2 [|c3 [|c4 [|c5 [|c6 [|c7 [|]]]]]]]]] //=.
rewrite /VEXTRACTI128.
- by have -> : b2i W8.one.[0] = 1 by rewrite W8.get_to_uint.
by smt(size_ge0).
qed.

(* -------------------------------------------------------------------- *)
(* writing four dwords at the end of the agreed prefix extends the      *)
(* agreement by the first k of them                                     *)
lemma agree_replace (p : wpoly) (old l : W32.t list) (k : int) :
  0 <= k <= 4 => size l = 4 =>
  agree p 0 old =>
  agree (XArray256.PAE.replace_ p (size old) l) 0 (old ++ take k l).
proof.
move=> rgk szl; rewrite /agree => hag i rgi rgibase.
rewrite /XArray256.PAE.replace_ Array256.filliE 1:/# szl /=.
move: rgi rgibase; rewrite size_cat size_take 1:/# szl => rgi rgibase.
rewrite nth_cat.
case: (i < size old) => hio; last first.
- rewrite ifT 1:/# nth_take 1,2:/#.
  by rewrite (nth_change_dfl witness W32.zero) 1:/#.
rewrite ifF 1:/#.
by have := hag i _ _ => //#.
qed.

(* -------------------------------------------------------------------- *)
(* -------------------------------------------------------------------- *)
lemma acceptE (w : W32.t) : accept w = (to_uint w < 8380417).
proof. by rewrite /accept /modulus. qed.

(* -------------------------------------------------------------------- *)
lemma reject3E (x y z : W8.t) :
  reject [x; y; z]
  = if accept (W4u8.pack4 [x; y; z] `&` mask23)
    then [W4u8.pack4 [x; y; z] `&` mask23] else [].
proof. by rewrite rejectE /cands /chunk /mkseq -iotaredE /=. qed.

(* -------------------------------------------------------------------- *)

(* -------------------------------------------------------------------- *)

(* -------------------------------------------------------------------- *)
(* the 3-byte candidate read at offset n of the byte stream             *)
op cand (a : W8.t Array848.t) (n : int) : W32.t =
  W4u8.pack4 [a.[n]; a.[n + 1]; a.[n + 2]] `&` mask23.

(* -------------------------------------------------------------------- *)
(* splitting the accepted stream at a 3-aligned offset                  *)
lemma reject_block (a : W8.t Array848.t) (n m : int) :
  0 <= n => 0 <= m => 3 %| n =>
  reject (Array848.sub a 0 (n + m))
  = reject (Array848.sub a 0 n) ++ reject (Array848.sub a n m).
proof.
move=> hn hm hdvd; rewrite sub_cat_848 // (_ : 0 + n = n) 1:/#.
by rewrite reject_cat // size_sub /#.
qed.

(* -------------------------------------------------------------------- *)
(* consuming one candidate extends the accepted prefix by its filter    *)
lemma reject_step (a : W8.t Array848.t) (n : int) :
  0 <= n => 3 %| n =>
  reject (Array848.sub a 0 (n + 3))
  = reject (Array848.sub a 0 n)
    ++ if accept (cand a n) then [cand a n] else [].
proof.
by move=> hn hdvd; rewrite reject_block // sub3E_848 reject3E -/(cand a n).
qed.

(* -------------------------------------------------------------------- *)
(* scalar-loop data invariant: p holds the accepted prefix of the       *)
(* first off bytes of the stream, fl counts it (capped at 256)          *)
op sampled (b : W8.t Array848.t) (p : wpoly) (fl off : int) =
     off <= 840
  /\ 3 %| off
  /\ fl <= 256
  /\ fl = size (reject (Array848.sub b 0 off))
  /\ agree p 0 (reject (Array848.sub b 0 off)).

(* -------------------------------------------------------------------- *)
(* vector-loop data invariant: same accepted prefix, byte count         *)
op vsampled (b : W8.t Array848.t) (p : wpoly) (bf off : int) =
     off <= 840
  /\ 3 %| off
  /\ bf <= 1024
  /\ bf = 4 * size (reject (Array848.sub b 0 off))
  /\ agree p 0 (reject (Array848.sub b 0 off)).

(* -------------------------------------------------------------------- *)
lemma cands_cat (xs ys : W8.t list) : 3 %| size xs =>
  cands (xs ++ ys) = cands xs ++ cands ys.
proof. by move=> h; rewrite /cands chunk_cat // map_cat. qed.

(* -------------------------------------------------------------------- *)
lemma sub_window (a : W8.t Array848.t) (n : int) :
  Array848.sub a n 24 = Array848.sub a n 12 ++ Array848.sub a (n + 12) 12.
proof. by rewrite (_ : 24 = 12 + 12) 1:// sub_cat_848. qed.

(* -------------------------------------------------------------------- *)
(* the two 4-candidate halves of a 24-byte window                       *)
lemma take4_cands_window (a : W8.t Array848.t) (n : int) :
  filter accept (take 4 (cands (Array848.sub a n 24)))
  = reject (Array848.sub a n 12).
proof.
rewrite sub_window cands_cat ?size_sub //.
by rewrite take_size_cat ?size_cands ?size_sub // rejectE.
qed.

(* -------------------------------------------------------------------- *)
lemma drop4_cands_window (a : W8.t Array848.t) (n : int) :
  filter accept (drop 4 (cands (Array848.sub a n 24)))
  = reject (Array848.sub a (n + 12) 12).
proof.
rewrite sub_window cands_cat ?size_sub //.
by rewrite drop_size_cat ?size_cands ?size_sub // rejectE.
qed.

(* -------------------------------------------------------------------- *)
(* the shuffle-table row selected by a 4-bit acceptance mask            *)
lemma shuffle_slot (h : W64.t) (bs : bool list) :
  size bs = 4 => to_uint h = bs2int bs =>
  to_uint (h `<<` W8.of_int 4) = 16 * bs2int bs.
proof.
move=> szbs hh.
have hbnd : 0 <= bs2int bs < 16.
- by rewrite bs2int_ge0 /=; have := bs2int_le2Xs bs; rewrite szbs.
by rewrite /(`<<`) of_uintK /= W64.to_uint_shl // hh pmod_small /#.
qed.

(* -------------------------------------------------------------------- *)
(* byte-counter advance for one half: bf += 4 * popcount h              *)
lemma popcnt_step (bf h : W64.t) (bs : bool list) :
  size bs = 4 => to_uint h = bs2int bs => to_uint bf <= 1024 =>
  to_uint (bf + ((POPCNT_64 h).`6 `<<` W8.of_int 2))
  = to_uint bf + 4 * count idfun bs.
proof.
move=> szbs hh hbf.
have hcle : count idfun bs <= 4 by have := count_size idfun bs; rewrite szbs.
have hcnt : count idfun (W64.w2bits h) = count idfun bs.
- by apply popcnt_count.
have hp : to_uint ((POPCNT_64 h).`6 `<<` W8.of_int 2) = 4 * count idfun bs.
- rewrite popcnt6E hcnt /(`<<`) of_uintK /= W64.to_uint_shl // of_uintK /ptr_modulus.
  rewrite pmod_small; 1: by move: hcle => /=; smt(count_ge0).
  rewrite pmod_small; 1: by move: hcle => /=; smt(count_ge0).
  by ring.
by rewrite W64.to_uintD_small hp /=; smt(count_ge0).
qed.

(* -------------------------------------------------------------------- *)
(* the whole compact-and-store step for one 4-candidate half            *)
lemma agree_store (p : wpoly) (old cs4 : W32.t list) (x : W128.t) (h : W64.t) :
  W4u32.Pack.to_list (W4u32.unpack32 x) = cs4 =>
  size cs4 = 4 =>
  to_uint h = bs2int (map accept cs4) =>
  agree p 0 old =>
  agree (XArray256.PAE.replace_ p (size old)
          (W4u32.Pack.to_list (W4u32.unpack32 (VPSHUFB_128 x
            (W16u8.pack16 (Array256.sub matrix_A__SHUFFLE_TABLE
               (to_uint (h `<<` W8.of_int 4)) 16))))))
        0 (old ++ filter accept cs4).
proof.
move=> hx szcs4 hh hag.
have szbits4 : size (map accept cs4) = 4 by rewrite size_map.
have hcle : count idfun (map accept cs4) <= 4.
- by have := count_size idfun (map accept cs4); rewrite szbits4.
have hint2bs : int2bs 4 (bs2int (map accept cs4)) = map accept cs4.
- by have := bs2intK (map accept cs4); rewrite szbits4.
have hm : 0 <= bs2int (map accept cs4) < 16.
- by rewrite bs2int_ge0 /=; have := bs2int_le2Xs (map accept cs4); rewrite szbits4.
have heq : take (count idfun (map accept cs4))
             (W4u32.Pack.to_list (W4u32.unpack32 (VPSHUFB_128 x
               (W16u8.pack16 (Array256.sub matrix_A__SHUFFLE_TABLE
                  (to_uint (h `<<` W8.of_int 4)) 16)))))
           = filter accept cs4.
- rewrite (shuffle_slot _ (map accept cs4)) // -{1}hint2bs.
  rewrite shuffle_compact //.
  rewrite hint2bs hx.
  by rewrite filter_mask'.
rewrite -heq; apply agree_replace => //.
by smt(count_ge0).
qed.

(* -------------------------------------------------------------------- *)
(* per-half bounds and call-site adapters: premises match the loop      *)
(* invariant facts, conclusions match the wp-produced goal terms        *)
lemma size_filter_take4 (cs : W32.t list) :
  size cs = 8 => size (filter accept (take 4 cs)) <= 4.
proof.
move=> szcs; rewrite size_filter.
by have := count_size accept (take 4 cs); rewrite size_take // szcs.
qed.

lemma size_filter_drop4 (cs : W32.t list) :
  size cs = 8 => size (filter accept (drop 4 cs)) <= 4.
proof.
move=> szcs; rewrite size_filter.
by have := count_size accept (drop 4 cs); rewrite size_drop // szcs.
qed.

(* -------------------------------------------------------------------- *)
lemma popcnt_step_lo (bf g : W64.t) (cs : W32.t list) :
  size cs = 8 => to_uint g = bs2int (map accept cs) => to_uint bf <= 1024 =>
  to_uint (bf + ((POPCNT_64 (g `&` W64.of_int 15)).`6 `<<` W8.of_int 2))
  = to_uint bf + 4 * size (filter accept (take 4 cs)).
proof.
move=> szcs hg hbf.
rewrite (popcnt_step _ _ (take 4 (map accept cs))) //.
- by rewrite size_take // size_map szcs.
- by rewrite to_uint_and15 hg -(bs2int_mod (map accept cs) 4).
by rewrite size_filter -(count_idfun_map accept) map_take.
qed.

lemma popcnt_step_hi (bf g : W64.t) (cs : W32.t list) :
  size cs = 8 => to_uint g = bs2int (map accept cs) => to_uint bf <= 1024 =>
  to_uint (bf + ((POPCNT_64 (g `>>` W8.of_int 4)).`6 `<<` W8.of_int 2))
  = to_uint bf + 4 * size (filter accept (drop 4 cs)).
proof.
move=> szcs hg hbf.
rewrite (popcnt_step _ _ (drop 4 (map accept cs))) //.
- by rewrite size_drop // size_map szcs.
- by rewrite to_uint_shr4 hg -(bs2int_div 4 (map accept cs)).
by rewrite size_filter -(count_idfun_map accept) map_drop.
qed.

(* -------------------------------------------------------------------- *)
lemma agree_store_lo (p : wpoly) (old cs : W32.t list) (g bf : W64.t) :
  size cs = 8 => to_uint bf = 4 * size old =>
  to_uint g = bs2int (map accept cs) => agree p 0 old =>
  agree (XArray256.PAE.replace_ p (to_uint bf %/ 4)
          (W4u32.Pack.to_list (W4u32.unpack32 (VPSHUFB_128
            (VEXTRACTI128 (W8u32.pack8 cs) W8.zero)
            (W16u8.pack16 (Array256.sub matrix_A__SHUFFLE_TABLE
               (to_uint ((g `&` W64.of_int 15) `<<` W8.of_int 4)) 16))))))
        0 (old ++ filter accept (take 4 cs)).
proof.
move=> szcs hbf hg hag.
have -> : to_uint bf %/ 4 = size old by rewrite hbf /#.
apply (agree_store _ _ _ _ (g `&` W64.of_int 15)) => //.
- by rewrite extract_lo.
- by rewrite size_take // szcs.
by rewrite map_take to_uint_and15 hg -(bs2int_mod (map accept cs) 4).
qed.

lemma agree_store_hi (p : wpoly) (old cs : W32.t list) (g bf : W64.t) :
  size cs = 8 => to_uint bf = 4 * size old =>
  to_uint g = bs2int (map accept cs) => agree p 0 old =>
  agree (XArray256.PAE.replace_ p (to_uint bf %/ 4)
          (W4u32.Pack.to_list (W4u32.unpack32 (VPSHUFB_128
            (VEXTRACTI128 (W8u32.pack8 cs) W8.one)
            (W16u8.pack16 (Array256.sub matrix_A__SHUFFLE_TABLE
               (to_uint ((g `>>` W8.of_int 4) `<<` W8.of_int 4)) 16))))))
        0 (old ++ filter accept (drop 4 cs)).
proof.
move=> szcs hbf hg hag.
have -> : to_uint bf %/ 4 = size old by rewrite hbf /#.
apply (agree_store _ _ _ _ (g `>>` W8.of_int 4)) => //.
- by rewrite extract_hi.
- by rewrite size_drop // szcs.
by rewrite map_drop to_uint_shr4 hg -(bs2int_div 4 (map accept cs)).
qed.


(* -------------------------------------------------------------------- *)
(* the bytestream decoder: the first 24 bytes of the loaded word, as    *)
(* eight 3-byte candidates, zero-extended and masked to 23 bits         *)
lemma matrix_A____bytestream_to_potential_coefficientsP (bs : W8.t list) :
  hoare[ M.matrix_A____bytestream_to_potential_coefficients :
      size bs = 32 /\ bytestream = W32u8.pack32 bs
    ==>
      res = W8u32.pack8
              (map (fun ws => W4u8.pack4 ws `&` W32.of_int (2 ^ 23 - 1))
                 (chunk 3 (take 24 bs))) ].
proof.
proc; wp; skip => &hr [szbs ->].
have -> : take 24 bs = mkseq (nth W8.zero bs) 24.
- by rewrite -{1}(mkseq_nth W8.zero bs) szbs take_mkseq.
by rewrite /chunk /mkseq -!iotaredE /=.
qed.

(* -------------------------------------------------------------------- *)
lemma matrix_A__rejection_sample_multiple_blocksP (buf : W8.t Array848.t)
: hoare[
  M.matrix_A__rejection_sample_multiple_blocks :
      randombytes = buf
    ==>
         agree res.`1 0 (reject (Array848.sub buf 0 840))
      /\ to_uint res.`2 = min 256 (size (reject (Array848.sub buf 0 840)))
  ].
proof.
proc=> /=.
seq 3 : (#pre /\ shuffle_table_pointer = matrix_A__SHUFFLE_TABLE).
- by auto.
sp 5; seq 0 : (#{/~{modulus}}pre /\ modulus = MODULUS8u32).
- by auto=> &hr |>; rewrite MODULUS8u32E.
seq 1: (                        (* FIXME: code position *)
     randombytes = buf
  /\ to_uint bytes_filled <= 1024
  /\ to_uint input_offset <= 5 * 168
  /\ (to_uint bytes_filled < (256 - 8) * 4 => to_uint input_offset = 5 * 168)
  /\ 3 %| to_uint input_offset
  /\ to_uint bytes_filled
       = 4 * size (reject (Array848.sub randombytes 0 (to_uint input_offset)))
  /\ agree polynomial 0 (reject (Array848.sub randombytes 0 (to_uint input_offset)))
).
- while (
       randombytes = buf
    /\ vsampled buf polynomial (to_uint bytes_filled) (to_uint input_offset)
    /\ 24 %| to_uint input_offset
    /\ modulus = MODULUS8u32
    /\ shuffle_table_pointer = matrix_A__SHUFFLE_TABLE
    /\ condition_loop = (stop_sampling <> W64.one)
    /\ (stop_sampling = W64.of_int (b2i (!(
            to_uint bytes_filled < (256 - 8) * 4
         /\ to_uint input_offset < 5 * 168))))
  ); last first.
  - by hoare split; auto=> &hr @/vsampled |> * /=; smt(of_int_b2i_eq1P).
  exlim randombytes => rb.
  proc change <1 : { randombytes <- rb; }; [by auto | cfold 1; wp -1].
  (* one window per iteration; off0 names its offset                   *)
  exlim input_offset => off0.
  (* decode the 32-byte window into its eight masked candidates        *)
  seq > ^potential_coefficients<@ : (#pre /\
    potential_coefficients =
      W8u32.pack8 (cands (Array848.sub randombytes (to_uint input_offset) 24))).
  - ecall (matrix_A____bytestream_to_potential_coefficientsP (Array848.sub randombytes (to_uint input_offset) 32)).
    auto=> &hr |> hs hdvd hne.
    move: hs => @/vsampled [#] hio0 hdvd0 hble hsz hag.
    have hoff840 : to_uint input_offset{hr} < 840 by smt().
    rewrite size_sub //= WArray848_get256E ~-1:#smt:(W64.to_uint_cmp) /=.
    by rewrite /cands take_sub_848 //.
  (* a. the acceptance mask: good lists the accepted candidates,       *)
  (*    least significant bit first                                     *)
  seq > ^good<- : (
       rb = buf
    /\ vsampled buf polynomial (to_uint bytes_filled) (to_uint off0)
    /\ to_uint bytes_filled < 992
    /\ to_uint off0 < 840
    /\ 24 %| to_uint off0
    /\ modulus = MODULUS8u32
    /\ shuffle_table_pointer = matrix_A__SHUFFLE_TABLE
    /\ input_offset = off0 + W64.of_int 24
    /\ potential_coefficients = W8u32.pack8 (cands (Array848.sub buf (to_uint off0) 24))
    /\ to_uint good = bs2int (map accept (cands (Array848.sub buf (to_uint off0) 24)))
  ).
  - auto=> &hr |> hs hdvd hne.
    have {hne} [h1 h2] : to_uint bytes_filled{hr} < 992 /\ to_uint input_offset{hr} < 840 by smt().
    rewrite h1 h2 /=.
    by apply to_uint_good; [by rewrite size_cands size_sub | exact cands_uint_lt].

  (* b. compact-store the accepted low half; bytes_filled counts it    *)
  seq > ^bytes_filled<- : (
       rb = buf
    /\ vsampled buf polynomial (to_uint bytes_filled) (to_uint off0 + 12)
    /\ to_uint bytes_filled <= 1008
    /\ to_uint off0 < 840
    /\ 24 %| to_uint off0
    /\ modulus = MODULUS8u32
    /\ shuffle_table_pointer = matrix_A__SHUFFLE_TABLE
    /\ input_offset = off0 + W64.of_int 24
    /\ potential_coefficients = W8u32.pack8 (cands (Array848.sub buf (to_uint off0) 24))
    /\ to_uint good = bs2int (map accept (cands (Array848.sub buf (to_uint off0) 24)))
  ).
  - auto=> &hr |> hs h992 h840 hdvd hgood.
    move: hs => @/vsampled [#] hio0 hdvd0 hble hsz hag.
    have szcs : size (cands (Array848.sub buf (to_uint off0) 24)) = 8 by rewrite size_cands size_sub.
    have hfle := size_filter_take4 _ szcs.
    have hidx : 0 <= to_uint ((good{hr} `&` W64.of_int 15) `<<` W8.of_int 4) <= 240.
    - rewrite /(`<<`) of_uintK /= W64.to_uint_shl // to_uint_and15.
      by rewrite pmod_small; smt(W64.to_uint_cmp).
    rewrite W32Array256_set128E ~-1:#smt:(W64.to_uint_cmp).
    rewrite WArray256_get128E ~-1:#smt:(W64.to_uint_cmp).
    rewrite /vsampled !(popcnt_step_lo _ _ (cands (Array848.sub buf (to_uint off0) 24))) //.
    rewrite !reject_block ~-1:#smt:(W64.to_uint_cmp) -!take4_cands_window.
    split; last by smt().
    do 3? (split; 1: smt()).
    split; 1: by rewrite size_cat /#.
    by apply agree_store_lo => //.

  (* c. likewise for the high half: the whole window is consumed       *)
  seq > ^bytes_filled<- : (
       rb = buf
    /\ vsampled buf polynomial (to_uint bytes_filled) (to_uint off0 + 24)
    /\ to_uint off0 < 840
    /\ 24 %| to_uint off0
    /\ modulus = MODULUS8u32
    /\ shuffle_table_pointer = matrix_A__SHUFFLE_TABLE
    /\ input_offset = off0 + W64.of_int 24
  ).
  - auto=> &hr |> hs h1008 h840 hdvd hgood.
    move: hs => @/vsampled [#] hio0 hdvd0 hble hsz hag.
    have szcs : size (cands (Array848.sub buf (to_uint off0) 24)) = 8 by rewrite size_cands size_sub.
    have hfle := size_filter_drop4 _ szcs.
    have hglt : bs2int (map accept (cands (Array848.sub buf (to_uint off0) 24))) < 256.
    - by have := bs2int_le2Xs (map accept (cands (Array848.sub buf (to_uint off0) 24))); rewrite size_map szcs.
    have hidx : 0 <= to_uint ((good{hr} `>>` W8.of_int 4) `<<` W8.of_int 4) <= 240.
    - rewrite /(`<<`) of_uintK /= W64.to_uint_shl // to_uint_shr4 hgood.
      by rewrite pmod_small; smt(bs2int_ge0).
    rewrite W32Array256_set128E ~-1:#smt:(W64.to_uint_cmp).
    rewrite WArray256_get128E ~-1:#smt:(W64.to_uint_cmp).
    have hsplit24 : reject (Array848.sub buf 0 (to_uint off0 + 24))
      = reject (Array848.sub buf 0 (to_uint off0 + 12))
        ++ filter accept (drop 4 (cands (Array848.sub buf (to_uint off0) 24))).
    - rewrite (_ : to_uint off0 + 24 = to_uint off0 + 12 + 12); 1: by ring.
      by rewrite reject_block ~-1:#smt:(W64.to_uint_cmp) -drop4_cands_window.
    rewrite /vsampled !(popcnt_step_hi _ _ (cands (Array848.sub buf (to_uint off0) 24))) //.
    rewrite !hsplit24.
    do 3? (split; 1: smt()).
    split; 1: by rewrite size_cat /#.
    by apply agree_store_hi => //.

  (* d. re-encode the stop flag from the new counters                  *)
  auto=> &hr |> hs h840 hdvd.
  by rewrite !uleE !of_uintK /= !to_uintD_small ?of_uintK /#.

(* The scalar tail: candidate-per-candidate rejection sampling         *)
(* entry: filled switches from byte count to coefficient count       *)
(* (bytes_filled / 4) and the stop flag encodes the loop guard        *)
seq < ^while : (
     randombytes = buf
  /\ sampled buf polynomial (to_uint filled) (to_uint input_offset)
  /\ condition_loop = (stop_sampling <> W64.one)
  /\ stop_sampling = W64.of_int (b2i (!(to_uint filled < 256 /\ to_uint input_offset < 838)))
).
- by auto=> &hr |> hbf hio h992 hdvd hsz hag; rewrite /sampled !ultE !to_uint_shr2 !of_uintK /=; smt().

(* each iteration consumes one 3-byte candidate, preserving sampled  *)
while (
     randombytes = buf
  /\ sampled buf polynomial (to_uint filled) (to_uint input_offset)
  /\ condition_loop = (stop_sampling <> W64.one)
  /\ stop_sampling = W64.of_int (b2i (!(to_uint filled < 256 /\ to_uint input_offset < 838)))
); last first.

(* loop exit: either the stream is consumed (offset = 840), or the   *)
(* polynomial is full (filled = 256) and the accepted prefix embeds   *)
(* into the full stream's reject                                      *)
- skip=> &hr |> hs0 cl f off p _ hs hstop.
  move: hs => @/sampled [#] hio hdvd hfle hsz hag.
  have hb : !(to_uint f < 256 /\ to_uint off < 838).
  - by apply of_int_b2i_eq1P; move: hstop; smt().
  case: (838 <= to_uint off) => hoff.
  - move: hsz hag; have -> : to_uint off = 840 by smt().
    by move=> hsz hag; split; [exact hag | smt()].
  have hf : to_uint f = 256 by smt().
  have -> : 840 = to_uint off + (840 - to_uint off) by ring.
  rewrite reject_block; 1,2: smt(W64.to_uint_cmp); 1: exact hdvd.
  rewrite size_cat; split; 1: by apply agree_full; [smt() | exact hag].
  smt(size_ge0).

(* one iteration; off0 names the current candidate's offset          *)
exlim input_offset => off0.

(* 1. load the 3-byte window at off0 into the masked candidate,      *)
(*    advancing the offset past it                                    *)
seq ^if : (
     randombytes = buf
  /\ sampled buf polynomial (to_uint filled) (to_uint off0)
  /\ to_uint filled < 256
  /\ to_uint off0 < 838
  /\ input_offset = off0 + W64.of_int 3
  /\ coeff = cand buf (to_uint off0)
  /\ condition = (coeff \ult W32.of_int 8380417)
).
- auto=> &hr |> hs hne; have {hne} [hf256 hoffb] :
    to_uint filled{hr} < 256 /\ to_uint input_offset{hr} < 838 by smt().
  by rewrite /SLH64.protect_32 /cand !to_uintD_small ?of_uintK /= ~-1:/#.

(* 2. filter: the candidate joins the accepted prefix iff it is      *)
(*    below the field modulus, and filled counts the store            *)
seq > ^if : (
     randombytes = buf
  /\ sampled buf polynomial (to_uint filled) (to_uint input_offset)
).
- if.
  (* accepted: stored at index filled, filled incremented *)
  - auto=> &hr |> hs hf256 hoffb; rewrite ultE of_uintK /= -acceptE => hacc.
    move: hs => @/sampled [#] hio hdvd hfle hsz hag.
    rewrite /sampled !to_uintD_small ?of_uintK /=; 1,2: smt(W64.to_uint_cmp).
    rewrite !reject_step ~-1:#smt:(W64.to_uint_cmp) hacc /= size_cat /=.
    do 4? (split; 1: smt()).
    by rewrite hsz; apply agree_set; [by move: hf256; rewrite hsz | exact hag].
  (* rejected: the filter drops the candidate, state unchanged *)
  auto=> &hr |> hs hf256 hoffb; rewrite ultE of_uintK /= => hacc.
  have {hacc} hacc : accept (cand randombytes{hr} (to_uint off0)) = false.
  - by rewrite acceptE; smt().
  move: hs => @/sampled [#] hio hdvd hfle hsz hag.
  rewrite /sampled !to_uintD_small ?of_uintK /=; 1: smt(W64.to_uint_cmp).
  rewrite !reject_step; 1,2: smt(W64.to_uint_cmp).
  rewrite hacc /= cats0.
  do 3? (split; 1: smt()); split; [exact hsz | exact hag].

(* 3. re-encode the stop flag from the new counters                  *)
by auto=> &hr |> hs; rewrite !uleE !of_uintK /= /#.
qed.

(* ==================================================================== *)
(* Leaf lemmas for the one-block scalar sampler                         *)
(* ==================================================================== *)
(* -------------------------------------------------------------------- *)
(* -------------------------------------------------------------------- *)
(* -------------------------------------------------------------------- *)
op cand168 (a : W8.t Array168.t) (n : int) : W32.t =
  W4u8.pack4 [a.[n]; a.[n + 1]; a.[n + 2]] `&` mask23.

(* -------------------------------------------------------------------- *)
(* consuming one block candidate extends the accepted stream            *)
lemma reject_step168 (S : W8.t list) (a : W8.t Array168.t) (n : int) :
  3 %| size S => 0 <= n => 3 %| n =>
  reject (S ++ Array168.sub a 0 (n + 3))
  = reject (S ++ Array168.sub a 0 n)
    ++ if accept (cand168 a n) then [cand168 a n] else [].
proof.
move=> hS hn hdvd.
rewrite (sub_cat_168 a 0 n 3) // catA.
rewrite reject_cat; 1: by rewrite size_cat size_sub // /#.
by rewrite (_ : 0 + n = n) 1:/# sub3E_168 reject3E -/(cand168 a n).
qed.

(* -------------------------------------------------------------------- *)
(* The one-block scalar sampler: one 168-byte squeezed block extends    *)
(* the accepted stream, with filled capped at 256                       *)
lemma matrix_A__rejection_sample_one_blockP (S : W8.t list) (blk : W8.t Array168.t) :
  hoare[ M.matrix_A__rejection_sample_one_block :
      block = blk
   /\ 3 %| size S
   /\ agree polynomial 0 (reject S)
   /\ to_uint filled = min 256 (size (reject S))
   ==>
      agree res.`1 0 (reject (S ++ Array168.to_list blk))
   /\ to_uint res.`2 = min 256 (size (reject (S ++ Array168.to_list blk))) ].
proof.
proc.
(* entry: nothing consumed yet; the flag encodes the loop guard      *)
seq < ^while : (
     block = blk
  /\ 3 %| size S
  /\ to_uint block_offset <= 168
  /\ 3 %| to_uint block_offset
  /\ agree polynomial 0 (reject (S ++ Array168.sub blk 0 (to_uint block_offset)))
  /\ to_uint filled = min 256 (size (reject (S ++ Array168.sub blk 0 (to_uint block_offset))))
  /\ condition_loop = (stop_sampling <> W8.one)
  /\ stop_sampling = W8.of_int (b2i (!(to_uint filled < 256 /\ to_uint block_offset < 168)))
).
- by auto=> &hr |> hS hag hf; rewrite cats0 !uleE !of_uintK /=; smt().

(* each iteration consumes one 3-byte candidate of the block         *)
while (
     block = blk
  /\ 3 %| size S
  /\ to_uint block_offset <= 168
  /\ 3 %| to_uint block_offset
  /\ agree polynomial 0 (reject (S ++ Array168.sub blk 0 (to_uint block_offset)))
  /\ to_uint filled = min 256 (size (reject (S ++ Array168.sub blk 0 (to_uint block_offset))))
  /\ condition_loop = (stop_sampling <> W8.one)
  /\ stop_sampling = W8.of_int (b2i (!(to_uint filled < 256 /\ to_uint block_offset < 168)))
); last first.
(* loop exit: the block is consumed (offset = 168), or filled capped *)
(* at 256 and the accepted prefix embeds into the full stream         *)
- skip=> &hr |> hS0 hio0 hdvd0 hag0 hf0 off cl f p _ hio hdvd hag hf hstop.
  have hb : !(to_uint f < 256 /\ to_uint off < 168); 1: by apply of_int_b2i_eq1P8; move: hstop; smt().
  case: (168 <= to_uint off) => hoff.
  - move: hag hf; have -> : to_uint off = 168 by smt().
    by rewrite sub_full_168 => hag hf; split => //.
  have hf256 : to_uint f = 256 by smt().
  have hsz : 256 <= size (reject (S ++ Array168.sub block{hr} 0 (to_uint off))) by smt().
  have -> : Array168.to_list block{hr}
    = Array168.sub block{hr} 0 (to_uint off)
      ++ Array168.sub block{hr} (to_uint off) (168 - to_uint off).
  - rewrite -sub_full_168.
    have {1}-> : 168 = to_uint off + (168 - to_uint off) by ring.
    rewrite sub_cat_168; 1,2: smt(W64.to_uint_cmp).
    by rewrite (_ : 0 + to_uint off = to_uint off) 1:/#.
  rewrite catA reject_cat; 1: by rewrite size_cat size_sub; smt(W64.to_uint_cmp).
  rewrite size_cat.
  split; 1: by apply agree_full; [smt() | exact hag].
  smt(size_ge0).
(* one iteration; off0 names the current candidate's offset          *)
exlim block_offset => off0.
(* 1. load and mask the 3-byte candidate at off0                     *)
seq ^if : (
     block = blk
  /\ 3 %| size S
  /\ to_uint off0 < 168
  /\ 3 %| to_uint off0
  /\ to_uint filled < 256
  /\ agree polynomial 0 (reject (S ++ Array168.sub blk 0 (to_uint off0)))
  /\ to_uint filled = min 256 (size (reject (S ++ Array168.sub blk 0 (to_uint off0))))
  /\ block_offset = off0 + W64.of_int 3
  /\ coeff = cand168 blk (to_uint off0)
  /\ condition = (coeff \ult W32.of_int 8380417)
).
- auto=> &hr |> hS hio hdvd hag hf hne.
  have {hne} [hf256 hoffb] : to_uint filled{hr} < 256 /\ to_uint block_offset{hr} < 168 by smt().
  rewrite /SLH64.protect_32 /cand168 !to_uintD_small ?of_uintK /=; 1,2: smt().
  by rewrite hf256 hoffb.

(* 2. filter: the candidate joins the accepted stream iff below q    *)
seq > ^if : (
     block = blk
  /\ 3 %| size S
  /\ to_uint block_offset <= 168
  /\ 3 %| to_uint block_offset
  /\ agree polynomial 0 (reject (S ++ Array168.sub blk 0 (to_uint block_offset)))
  /\ to_uint filled = min 256 (size (reject (S ++ Array168.sub blk 0 (to_uint block_offset))))
).
- if.
  (* accepted: stored at index filled, filled incremented *)
  - auto=> &hr |> hS hoffb hdvd hf256 hag hf; rewrite ultE of_uintK /= -acceptE => hacc.
    rewrite !to_uintD_small ?of_uintK /=; 1,2: smt(W64.to_uint_cmp).
    rewrite !(reject_step168 S); 1,2,3: smt(W64.to_uint_cmp).
    rewrite hacc /= size_cat /=.
    have hsz : size (reject (S ++ Array168.sub block{hr} 0 (to_uint off0))) = to_uint filled{hr} by smt().
    do 2? (split; 1: smt()).
    split; 2: smt().
    rewrite (_ : to_uint filled{hr} = size (reject (S ++ Array168.sub block{hr} 0 (to_uint off0)))) 1:/#.
    by apply agree_set; [smt() | exact hag].
  (* rejected: the filter drops the candidate, state unchanged *)
  auto=> &hr |> hS hoffb hdvd hf256 hag hf; rewrite ultE of_uintK /= => hacc.
  have {hacc} hacc : accept (cand168 block{hr} (to_uint off0)) = false; 1: by rewrite acceptE; smt().
  rewrite !to_uintD_small ?of_uintK /=; 1: smt(W64.to_uint_cmp).
  rewrite !(reject_step168 S); 1,2,3: smt(W64.to_uint_cmp).
  rewrite hacc /= cats0.
  do 2? (split; 1: smt()).
  by split; [exact hag | exact hf].
(* 3. re-encode the stop flag from the new counters                  *)
by auto=> &hr |> hS hio hdvd hag hf; rewrite !uleE !of_uintK /= /#.
qed.

(* -------------------------------------------------------------------- *)
(* losslessness of the sampler's building blocks                        *)
lemma shake128_squeezeblock4x_ll : islossless M.shake128_squeezeblock4x.
proof. by proc; islossless. qed.

lemma matrix_A__shake128_absorb_34_4x_ll : islossless M.shake128_absorb_34_4x.
proof. by proc; islossless. qed.

lemma matrix_A____shake128_squeeze_multiple_blocks_4x_ll :
  islossless M.matrix_A____shake128_squeeze_multiple_blocks_4x.
proof.
proc; while true (5 - i); last by auto=> /#.
by move=> z; wp; call shake128_squeezeblock4x_ll; auto=> /#.
qed.

lemma matrix_A____bytestream_to_potential_coefficients_ll :
  islossless M.matrix_A____bytestream_to_potential_coefficients.
proof. by proc; islossless. qed.

lemma matrix_A__rejection_sample_multiple_blocks_ll :
  islossless M.matrix_A__rejection_sample_multiple_blocks.
proof.
proc.
while (   to_uint input_offset <= 840
       /\ (condition_loop => to_uint input_offset < 838))
      (840 - to_uint input_offset).
- move=> z; auto=> &hr |> hle hlt hc.
  have h3 : to_uint (input_offset{hr} + W64.of_int 3) = to_uint input_offset{hr} + 3.
  - by rewrite to_uintD_small of_uintK /= /#.
  rewrite !to_uintD_small ?of_uintK /=; 1..3: smt().
  by rewrite !uleE h3 /=; smt().
wp.
while (   to_uint input_offset <= 840 /\ 24 %| to_uint input_offset
       /\ (condition_loop => to_uint input_offset < 840))
      (840 - to_uint input_offset).
- move=> z; wp; call matrix_A____bytestream_to_potential_coefficients_ll.
  auto=> &hr |> hle hdvd hlt hc.
  have h816 : to_uint input_offset{hr} <= 816.
  - by move: hdvd (hlt hc) => /dvdzP [q ->] /#.
  have h24 : to_uint (input_offset{hr} + W64.of_int 24) = to_uint input_offset{hr} + 24.
  - by rewrite to_uintD_small of_uintK /= /#.
  have hd : 24 %| (to_uint input_offset{hr} + 24) by smt(dvdzD dvdzz).
  move=> r; rewrite h24 (W64.uleE (W64.of_int 840)) h24 W64.of_uintK /= hd /=.
  by smt().
by auto=> /> bf c io; rewrite !W64.ultE !W64.of_uintK /=; smt().
qed.

lemma matrix_A__rejection_sample_one_block_ll :
  islossless M.matrix_A__rejection_sample_one_block.
proof.
proc.
while (   to_uint block_offset <= 168 /\ 3 %| to_uint block_offset
       /\ (condition_loop => to_uint block_offset < 168))
      (168 - to_uint block_offset).
- move=> z; auto=> &hr |> hle hdvd hlt hc.
  have h165 : to_uint block_offset{hr} <= 165.
  - by move: hdvd (hlt hc) => /dvdzP [q ->] /#.
  have h3 : to_uint (block_offset{hr} + W64.of_int 3) = to_uint block_offset{hr} + 3.
  - by rewrite to_uintD_small of_uintK /= /#.
  rewrite !to_uintD_small ?of_uintK /=; 1..3: smt().
  by rewrite !uleE h3 /=; smt(dvdzD dvdzz).
by auto=> &hr |>; smt().
qed.

(* -------------------------------------------------------------------- *)
op A_ds (rc : int * int) : W16.t =
  W2u8.pack2 [W8.of_int rc.`2; W8.of_int rc.`1].

(* -------------------------------------------------------------------- *)
(* the A-matrix polynomial: the first 256 accepted candidates of the   *)
(* lane's XOF stream                                                    *)
op Apoly (rho : rho) (rc : int * int) : wpoly =
  rpoly (to_list rho ++ W2u8.to_list (A_ds rc)).

lemma ApolyP (rho : rho) (rc : int * int) (m j : int) :
  0 <= m =>
  256 <= size (reject (shake128_slice
                 (to_list rho ++ W2u8.to_list (A_ds rc)) 0 m)) =>
  0 <= j < 256 =>
  (Apoly rho rc).[j]
  = nth W32.zero
      (reject (shake128_slice (to_list rho ++ W2u8.to_list (A_ds rc)) 0 m)) j.
proof. by move=> *; rewrite /Apoly (rpolyP _ m). qed.

(* -------------------------------------------------------------------- *)
op A_rc_of_index (i : int) =
  (i %/ lvec, i %% lvec).

(* -------------------------------------------------------------------- *)
op poly_index_in_A (rc : int * int) : int =
  (lvec * rc.`1 + rc.`2) * 256.

(* -------------------------------------------------------------------- *)
op poly_of_A (A : A) (rc : int * int) =
  Array256.of_list W32.zero (Array_klpolys.sub A (poly_index_in_A rc) 256).

(* -------------------------------------------------------------------- *)
op A_valid_up_to (rho : rho) (A : A) (i : int) =
  forall k, 0 <= k < i =>
    poly_of_A A (A_rc_of_index k) = Apoly rho (A_rc_of_index k).

(* -------------------------------------------------------------------- *)
op update_poly (a : A) (base : int) (p : W32.t Array256.t) =
  PAK.replace_ a (256 * base) (to_list p).

(* -------------------------------------------------------------------- *)
op update_polys (a : A) (base : int) (ps : W32.t Array256.t list) =
  foldl (fun a (ip : _ * _) =>
    update_poly a (base + ip.`1) ip.`2
  ) a (zip (range 0 (size ps)) ps).

(* -------------------------------------------------------------------- *)
lemma update_polys_A_valid_up_to (rho : rho) (a : A) (base : int) (tp : wpoly list) :
     0 <= base => base + size tp <= kvec * lvec =>
     A_valid_up_to rho a base
  => (forall i, 0 <= i < size tp =>
        nth witness tp i = Apoly rho (A_rc_of_index (base + i)))
  => A_valid_up_to rho (update_polys a base tp) (base + size tp).
proof.
hint +listred.
move=> ge0b; elim/last_ind: tp => [|tp t IH] hle hav hnth /=.
- by rewrite /update_polys /=.
move: hle; rewrite size_rcons => hle.
have hstep : update_polys a base (rcons tp t)
           = update_poly (update_polys a base tp) (base + size tp) t.
- rewrite /update_polys size_rcons rangeSr 1:size_ge0.
  rewrite zip_rcons; 1: smt(size_range size_ge0).
  by rewrite foldl_rcons.
rewrite hstep.
have hIH : A_valid_up_to rho (update_polys a base tp) (base + size tp).
- apply IH; 1: smt(); 1: exact hav.
  move=> i rgi; have := hnth i _; 1: smt(size_rcons).
  by rewrite nth_rcons ifT 1:/#.
have pidxE : forall k, poly_index_in_A (A_rc_of_index k) = 256 * k.
- by move=> k; rewrite /poly_index_in_A /A_rc_of_index /= (mulzC lvec) -divz_eq mulzC.
move=> k [ge0k ltk].
case: (k = base + size tp) => hk; last first.
- have hpres : poly_of_A (update_poly (update_polys a base tp) (base + size tp) t) (A_rc_of_index k)
             = poly_of_A (update_polys a base tp) (A_rc_of_index k).
  - rewrite /poly_of_A !pidxE; congr.
    rewrite /sub; apply (eq_in_mkseq _ _ _ _) => m rgm /=.
    rewrite /update_poly /PAK.replace_ Array_klpolys.filliE 1:/# Array256.size_to_list.
    by rewrite ifF 1:/#.
  rewrite hpres; apply hIH => /#.
have hT : t = Apoly rho (A_rc_of_index (base + size tp)).
- have := hnth (size tp) _; 1: smt(size_rcons size_ge0).
  by rewrite nth_rcons ifF 1:/# /=.
rewrite hk -hT.
apply Array256.ext_eq => m rgm.
rewrite /poly_of_A pidxE Array256.get_of_list ~-1://.
rewrite /sub nth_mkseq 1:// /=.
rewrite /update_poly /PAK.replace_ Array_klpolys.filliE 1:/# Array256.size_to_list ifT 1:/#.
by move=> /=; congr; ring.
qed.

(* -------------------------------------------------------------------- *)
lemma replace_256_klE (a : W32.t Array_klpolys.t) (base : int) (b : W32.t Array256.t) :
  Array_klpolys.init
    (fun (i : int) =>
       if base * 256 <= i < base * 256 + 256 then
         b.[i - base * 256]
       else a.[i])
  = update_poly a base b.
proof.
apply Array_klpolys.ext_eq => i rgi.
rewrite initiE // /update_poly /PAK.replace_ Array_klpolys.filliE 1:// Array256.size_to_list /to_list.
case: (base * 256 <= i < base * 256 + 256) => hcase.
- by rewrite nth_mkseq 1:/# /=; smt().
by smt().
qed.

(* -------------------------------------------------------------------- *)

(* -------------------------------------------------------------------- *)

(* -------------------------------------------------------------------- *)

(* -------------------------------------------------------------------- *)
(* Termination of the four-lane sampler                                 *)
(*                                                                      *)
(* A lane terminates once its XOF stream holds 256 accepted candidates  *)
(* ([stream_ok]); [stream_fuel] is the first block count that does. The *)
(* loop variant is [K - kmax], where [kmax] is the largest block count  *)
(* <= K the current state is consistent with: the concrete XOF state     *)
(* need not determine the block count, but any consistent count        *)
(* advances by one per iteration.                                       *)
op a_stop (fs : W64.t list) : W32.t =
  W32.of_int (b2i (!has (fun w => w \ult W64.of_int 256) fs)).

(* the sampling-loop invariant after k squeezed blocks *)
op a_inv (nonce : int -> W8.t list) (k : int) (st : sha3x4)
         (ps : wpoly list) (fs : W64.t list) =
     st \sha3for Array4.init (mk_read (168 * k) \o nonce)
  /\ (forall i, 0 <= i < 4 =>
        let p = nth witness ps i in
        let f = nth witness fs i in
        reject_ok (Array4.init nonce).[i] (168 * k) p (to_uint f)).

(* past every lane's fuel, all lanes are full and the loop stops *)
lemma a_inv_full (nonce : int -> W8.t list) (k : int) st (ps : wpoly list)
  (f0 f1 f2 f3 : W64.t) :
  (forall i, 0 <= i < 4 => stream_ok (nonce i)) =>
  (forall i, 0 <= i < 4 => stream_fuel (nonce i) <= k) =>
  a_inv nonce k st ps [f0; f1; f2; f3] =>
  a_stop [f0; f1; f2; f3] = W32.one.
proof.
move=> hok hfuel [_ hinv].
have hall : forall i, 0 <= i < 4 => 256 <= to_uint (nth witness [f0; f1; f2; f3] i).
- move=> i rgi; have [_ hf] := hinv i rgi; rewrite /= in hf.
  by rewrite hf Array4.initiE //=; smt(stream_fuelP).
move: (hall 0 _) (hall 1 _) (hall 2 _) (hall 3 _) => //=.
by rewrite /a_stop /= !W64.ultE /= => 4?; rewrite !ltzNge /#.
qed.

(* -------------------------------------------------------------------- *)
lemma matrix_A____sample_4_polynomialsP
  (rho_ : rho) (rcs : (int * int) option list)
: (forall ds, stream_ok (to_list rho_ ++ W2u8.to_list ds)) =>
  phoare[
  M.matrix_A____sample_4_polynomials :
         rho = rho_
      /\ (forall i, 0 <= i < 4 =>
           domain_separators.[i] =
             odflt domain_separators.[i] (omap A_ds (nth None rcs i)))
    ==>
         forall i, 0 <= i < 4 =>
           let resi = nth witness [res.`1; res.`2; res.`3; res.`4] i in
           odflt true (omap (fun rc => resi = Apoly rho_ rc) (nth None rcs i))
] = 1%r.
proof.
move=> hok.
hint +listred -delta nth.
proc=> /=.
proc change [^stop_sampling<- .. ^stop_sampling<- & +1] : {
  stop_sampling <- a_stop [filled0; filled1; filled2; filled3];
}; first by auto=> &hr @/a_stop |> *.

exlim domain_separators => ds_.
proc change <1 : { rho<- rho_; domain_separators <- ds_; }; first by auto.
do 2! (cfold 1); wp -2.
pose Ads i := odflt ds_.[i] (omap A_ds (nth None rcs i)).
pose nonce i := to_list rho_ ++ W2u8.to_list ds_.[i].
case@[ambient]: (forall i, 0 <= i < 4 => ds_.[i] = Ads i) => hds_; last first.
- conseq (_ : false ==> _) => //.
  by move=> &hr [#] ->> _ h; apply: hds_ => i rgi; rewrite /Ads -h.
pose data := Array4.init nonce.

(* up to the loop: partial correctness, then losslessness              *)
seq ^while : (true) 1%r 1%r 0%r 0%r
  (a_inv nonce 5 xof_state [polynomial0; polynomial1; polynomial2; polynomial3]
                           [filled0; filled1; filled2; filled3]
   /\ stop_sampling = a_stop [filled0; filled1; filled2; filled3]).
- (* Initial absorption *)
  sp; seq 1 : (xof_state \sha3for Array4.init (mk_absorbed \o nonce)).
  - ecall (matrix_A__shake128_absorb_34_4xP rho_ ds_) => /=.
    auto=> &hr _ rst; apply/sha3for_eqR/Array4.ext_eq=> i ?.
    by rewrite mapiE -1:initiE.

  (* Squeeze first blocks *)
  seq 1: (
       xof_state \sha3for Array4.init (mk_read (168 * 5) \o nonce)
    /\ (forall i, 0 <= i < 4 =>
          let b = nth witness [buf0; buf1; buf2; buf3] i in
          Array848.sub b 0 840 = shake128_slice data.[i] 0 840)).
  - ecall ->> (matrix_A____shake128_squeeze_multiple_blocks_4xP data) => /=.
    - move=> &hr |>; apply: sha3for_eqR.
      by apply: Array4.ext_eq; smt(Array4.mapiE Array4.initiE).
    auto=> |> &hr + ?; apply/sha3for_eqR/Array4.ext_eq.
    by move=> i rgi; rewrite mapiE // !initiE.

  seq ^stop_sampling<- : (#{/~{buf0, buf1, buf2, buf3}}pre /\
    (forall i, 0 <= i < 4 =>
       let p = nth witness [polynomial0; polynomial1; polynomial2; polynomial3] i in
       let f = nth witness [filled0; filled1; filled2; filled3] i in
          reject_ok data.[i] 840 p (to_uint f))).
  - hoare split; last by conseq |>.
    exlim buf0, buf1, buf2, buf3 => buf0_ buf1_ buf2_ buf3_. (* FIXME *)
    ecall ->> (matrix_A__rejection_sample_multiple_blocksP buf0_) => /= [|>|]; sp.
    seq 0 : (#{/~{filled}}pre /\ to_uint filled0 = min 256 (size (reject (sub buf0_ 0 840)))). (* FIXME *)
    - by auto.
    ecall ->> (matrix_A__rejection_sample_multiple_blocksP buf1_) => /= [|>|]; sp.
    seq 0 : (#{/~{filled}}pre /\ to_uint filled1 = min 256 (size (reject (sub buf1_ 0 840)))). (* FIXME *)
    - by auto.
    ecall ->> (matrix_A__rejection_sample_multiple_blocksP buf2_) => /= [|>|]; sp.
    seq 0 : (#{/~{filled}}pre /\ to_uint filled2 = min 256 (size (reject (sub buf2_ 0 840)))). (* FIXME *)
    - by auto.
    ecall ->> (matrix_A__rejection_sample_multiple_blocksP buf3_) => /= [|>|]; sp.
    seq 0 : (#{/~{filled}}pre /\ to_uint filled3 = min 256 (size (reject (sub buf3_ 0 840)))). (* FIXME *)
    - by auto.
    auto=> &hr |> 5? h 4? i ile ilt; have: 0 <= i < 4 by smt().
    move=> {ile ilt}; apply: allP_range i => /=.
    by with hint +listred (rewrite /= /reject_ok -!h /=).
  by auto=> &hr |> hxf h; rewrite /a_inv hxf /=.
- wp; do 4! (call matrix_A__rejection_sample_multiple_blocks_ll; wp).
  call matrix_A____shake128_squeeze_multiple_blocks_4x_ll.
  by call matrix_A__shake128_absorb_34_4x_ll; auto.

(* the sampling loop                                                    *)
- pose K := max 5 (max (max (stream_fuel (nonce 0)) (stream_fuel (nonce 1)))
                       (max (stream_fuel (nonce 2)) (stream_fuel (nonce 3)))).
  have hK : forall i, 0 <= i < 4 => stream_fuel (nonce i) <= K.
  - move=> i rgi; have hi : i = 0 \/ i = 1 \/ i = 2 \/ i = 3 by smt().
    by rewrite /K; case: hi => [->|[->|[->|->]]]; smt().
  have hoks : forall i, 0 <= i < 4 => stream_ok (nonce i) by move=> i _; apply hok.
  while (   (exists k, 0 <= k <= K /\ a_inv nonce k xof_state
                 [polynomial0; polynomial1; polynomial2; polynomial3]
                 [filled0; filled1; filled2; filled3])
         /\ stop_sampling = a_stop [filled0; filled1; filled2; filled3])
        (K - argmax idfun (fun k => k <= K /\ a_inv nonce k xof_state
                 [polynomial0; polynomial1; polynomial2; polynomial3]
                 [filled0; filled1; filled2; filled3])); last first.
  - auto=> &hr [hinv hstop]; split.
    - by split=> //; exists 5; rewrite hinv /=; smt().
    move=> f0 f1 f2 f3 p0 p1 p2 p3 st xf; split.
    (* the variant is exhausted: every lane is full *)
    - move=> [[k [rgk hk]] ->] hv.
      have := argmax_bounded (fun k => a_inv nonce k xf [p0; p1; p2; p3] [f0; f1; f2; f3]) K k rgk hk.
      move=> /= [rgm [hm _]].
      have hmK : argmax idfun (fun k => k <= K /\ a_inv nonce k xf [p0; p1; p2; p3] [f0; f1; f2; f3]) = K by smt().
      move: hm; rewrite hmK => hm.
      by apply (a_inv_full nonce K xf [p0; p1; p2; p3]) => // i rgi; apply hK.
    clear hinv hstop; move=> -> [[k [rgk [hxf h]]] hstop].
    (* the stop flag forces every lane to 256 coefficients *)
    have {hstop} [#] hb0 hb1 hb2 hb3 : 256 <= to_uint f0 /\ 256 <= to_uint f1
                                    /\ 256 <= to_uint f2 /\ 256 <= to_uint f3.
    - move: hstop => @/a_stop /eq_sym; case _: (has _ _) => /=.
      - by move=> _ /(congr1 W32.to_uint); rewrite !of_uintK.
      by rewrite !negb_or !ultE /= -!lezNgt.
    (* a full lane holds the first 256 accepted candidates: Apoly      *)
    have hbridge : forall (p : wpoly) (f : W64.t) (i : int),
      0 <= i < 4 =>
      agree p 0 (reject (shake128_slice data.[i] 0 (168 * k))) =>
      to_uint f = min 256 (size (reject (shake128_slice data.[i] 0 (168 * k)))) =>
      256 <= to_uint f =>
      odflt true (omap (fun rc => p = Apoly rho_ rc) (nth None rcs i)).
    - move=> p f i rgi hag hf hf256.
      case _: (nth None rcs i) => //= rc E.
      have hds : ds_.[i] = A_ds rc.
      - by rewrite hds_ // /Ads E.
      have hdata : data.[i] = to_list rho_ ++ W2u8.to_list (A_ds rc).
      - by rewrite /data initiE ~-1://= /nonce hds.
      have hsz : 256 <= size (reject (shake128_slice data.[i] 0 (168 * k))) by smt().
      apply Array256.ext_eq => j rgj.
      rewrite (ApolyP rho_ rc (168 * k) j) //; 1: smt(); 1: by move: hsz; rewrite hdata.
      rewrite -hdata.
      by move: hag => @/agree hag; smt().
    move=> i; with hint +listred (apply: allP_range i => /=).
    do 3? split.
    - have /= := h 0 _; 1: done.
      rewrite /reject_ok => -[hag hf].
      by apply (hbridge p0 f0 0).
    - have /= := h 1 _; 1: done.
      rewrite /reject_ok => -[hag hf].
      by apply (hbridge p1 f1 1).
    - have /= := h 2 _; 1: done.
      rewrite /reject_ok => -[hag hf].
      by apply (hbridge p2 f2 2).
    have /= := h 3 _; 1: done.
    rewrite /reject_ok => -[hag hf].
    by apply (hbridge p3 f3 3).

  (* one iteration: fix the largest consistent block count k           *)
  move=> z.
  exlim (argmax idfun (fun k => k <= K /\ a_inv nonce k xof_state
            [polynomial0; polynomial1; polynomial2; polynomial3]
            [filled0; filled1; filled2; filled3])) => k.
  case @[ambient]: (0 <= k < K /\ z = K - k) => hkz; last first.
  - conseq (_ : false ==> _) => // &hr [->> [[[[k0 [rgk0 hk0]] hstop] hne] hz]].
    apply: hkz; have := argmax_bounded (fun k => a_inv nonce k xof_state{hr}
       [polynomial0{hr}; polynomial1{hr}; polynomial2{hr}; polynomial3{hr}]
       [filled0{hr}; filled1{hr}; filled2{hr}; filled3{hr}]) K k0 rgk0 hk0.
    move=> /= [rgm [hm _]]; split; 2: smt().
    split; 1: smt().
    move=> _; rewrite ltz_def; split; 2: smt().
    apply/negP => hmK; apply: hne; rewrite hstop.
    apply (a_inv_full nonce K xof_state{hr}
      [polynomial0{hr}; polynomial1{hr}; polynomial2{hr}; polynomial3{hr}]) => //.
    by move: hm; rewrite -hmK.
  seq 20 : (true) 1%r 1%r 0%r 0%r
    (a_inv nonce (k + 1) xof_state
       [polynomial0; polynomial1; polynomial2; polynomial3]
       [filled0; filled1; filled2; filled3]
     /\ stop_sampling = a_stop [filled0; filled1; filled2; filled3]).
  - conseq (_ : (0 <= k
        /\ xof_state \sha3for Array4.init (mk_read (168 * k) \o nonce)
        /\ (forall i, 0 <= i < 4 =>
              let p = nth witness [polynomial0; polynomial1; polynomial2; polynomial3] i in
              let f = nth witness [filled0; filled1; filled2; filled3] i in
              reject_ok data.[i] (168 * k) p (to_uint f))
        /\ stop_sampling = a_stop [filled0; filled1; filled2; filled3])
        /\ stop_sampling <> W32.one ==> _).
    - move=> &hr [->> [[[[k0 [rgk0 hk0]] hstop] hne] _]].
      have := argmax_bounded (fun k => a_inv nonce k xof_state{hr}
         [polynomial0{hr}; polynomial1{hr}; polynomial2{hr}; polynomial3{hr}]
         [filled0{hr}; filled1{hr}; filled2{hr}; filled3{hr}]) K k0 rgk0 hk0.
      by move=> /= [rgm [[hxf h] _]]; do! split => //; smt().
    clear hok hoks hK hkz hds_.

    proc rewrite 3 injecta_848E.
    proc rewrite 4 injecta_848E.
    proc rewrite 5 injecta_848E.
    proc rewrite 6 injecta_848E.

    proc change [^stop_sampling<- .. ^stop_sampling<- & +1] : {
      stop_sampling <- a_stop [filled0; filled1; filled2; filled3];
    }; first by auto=> &hr @/a_stop |>.

    (* squeeze one more 168-byte block into each lane *)
    seq ^xof_state<- : (
         0 <= k
      /\ (forall i, 0 <= i < 4 =>
            reject_ok data.[i] (168 * k)
              (nth witness [polynomial0; polynomial1; polynomial2; polynomial3] i)
              (to_uint (nth witness [filled0; filled1; filled2; filled3] i)))
      /\ aux \sha3for Array4.init (mk_read (168 * (k + 1)) \o nonce)
      /\ (forall i, 0 <= i < 4 =>
            Array168.to_list (nth witness [aux_0; aux_1; aux_2; aux_3] i)
            = shake128_slice data.[i] (168 * k) 168)
    ).
    - ecall (shake128_squeezeblock4xP data k).
      auto=> &hr |> hk hxf h hne.
      split.
      - apply (sha3for_eqR xof_state{hr} (Array4.init (mk_read (168 * k) \o nonce))) => //.
        by apply Array4.ext_eq => i rgi; rewrite mapiE // initiE //= /data initiE.
      move=> _ r hr1 hr2.
      apply (sha3for_eqR r.`1 (Array4.map (mk_read (168 * (k + 1))) data)) => //.
      by apply Array4.ext_eq => i rgi; rewrite mapiE // initiE //= /data initiE.
    (* install the squeezed blocks: lanes_ok enters its staged form *)
    seq > ^buf3<- : (
         0 <= k
      /\ lanes_ok data k 0 [polynomial0; polynomial1; polynomial2; polynomial3]
                           [filled0; filled1; filled2; filled3]
      /\ xof_state \sha3for Array4.init (mk_read (168 * (k + 1)) \o nonce)
      /\ blocks_ok data k [buf0; buf1; buf2; buf3]
    ).
    - auto=> &hr |> hk h hxf hblk; split; first by smt().
      move: (hblk 0) (hblk 1) (hblk 2) (hblk 3) => /= 4?.
      by with hint +listred (rewrite /blocks_ok; apply/allP_range => /=; rewrite !trunc_inject).

    (* each lane samples its fresh block, advancing lanes_ok by one *)
    exlim buf0 => b0_.
    seq > ^filled0<- : (
         0 <= k
      /\ lanes_ok data k 1 [polynomial0; polynomial1; polynomial2; polynomial3]
                           [filled0; filled1; filled2; filled3]
      /\ xof_state \sha3for Array4.init (mk_read (168 * (k + 1)) \o nonce)
      /\ blocks_ok data k [buf0; buf1; buf2; buf3]
    ).
    - wp; ecall (matrix_A__rejection_sample_one_blockP
        (shake128_slice data.[0] 0 (168 * k)) (truncatea_168 b0_)).
      auto=> &hr |> hk h hxf hblk.
      move: (h 0) (hblk 0) => @/reject_ok /= [hag hf] hb0.
      split; first by rewrite !size_shake128_slice /= /#.
      move=> _ _ _ _ r hr1 hr2.
      have hcat := shake128_slice_cat_block data.[0] k _ hk hb0.
      apply lanes_okP => /=.
      - by rewrite /reject_ok /= -hcat.
      - by have := h 1 _.
      - by have := h 2 _.
      by have := h 3 _.

    exlim buf1 => b1_.
    seq > ^filled1<- : (
         0 <= k
      /\ lanes_ok data k 2 [polynomial0; polynomial1; polynomial2; polynomial3]
                           [filled0; filled1; filled2; filled3]
      /\ xof_state \sha3for Array4.init (mk_read (168 * (k + 1)) \o nonce)
      /\ blocks_ok data k [buf0; buf1; buf2; buf3]
    ).
    - wp; ecall (matrix_A__rejection_sample_one_blockP
        (shake128_slice data.[1] 0 (168 * k)) (truncatea_168 b1_)).
      auto=> &hr |> hk h hxf hblk.
      move: (h 1) (hblk 1) => @/reject_ok /= [hag hf] hb1.
      split; first by rewrite !size_shake128_slice /= /#.
      move=> _ _ _ _ r hr1 hr2.
      have hcat := shake128_slice_cat_block data.[1] k _ hk hb1.
      apply lanes_okP => /=.
      - by have := h 0 _.
      - by rewrite /reject_ok /= -hcat.
      - by have := h 2 _.
      by have := h 3 _.

    exlim buf2 => b2_.
    seq > ^filled2<- : (
         0 <= k
      /\ lanes_ok data k 3 [polynomial0; polynomial1; polynomial2; polynomial3]
                           [filled0; filled1; filled2; filled3]
      /\ xof_state \sha3for Array4.init (mk_read (168 * (k + 1)) \o nonce)
      /\ blocks_ok data k [buf0; buf1; buf2; buf3]
    ).
    - wp; ecall (matrix_A__rejection_sample_one_blockP
        (shake128_slice data.[2] 0 (168 * k)) (truncatea_168 b2_)).
      auto=> &hr |> hk h hxf hblk.
      move: (h 2) (hblk 2) => @/reject_ok /= [hag hf] hb2.
      split; first by rewrite !size_shake128_slice /= /#.
      move=> _ _ _ _ r hr1 hr2.
      have hcat := shake128_slice_cat_block data.[2] k _ hk hb2.
      apply lanes_okP => /=.
      - by move: (h 0 _) => //#.
      - by move: (h 1 _) => //#.
      - by smt().
      by move: (h 3 _) => //#.

    exlim buf3 => b3_.
    seq > ^filled3<- : (
         0 <= k
      /\ lanes_ok data k 4 [polynomial0; polynomial1; polynomial2; polynomial3]
                           [filled0; filled1; filled2; filled3]
      /\ xof_state \sha3for Array4.init (mk_read (168 * (k + 1)) \o nonce)
      /\ blocks_ok data k [buf0; buf1; buf2; buf3]
    ).
    - wp; ecall (matrix_A__rejection_sample_one_blockP
        (shake128_slice data.[3] 0 (168 * k)) (truncatea_168 b3_)).
      auto=> &hr |> hk h hxf hblk.
      move: (h 3) (hblk 3) => @/reject_ok /= [hag hf] hb3.
      split; first by rewrite !size_shake128_slice /= /#.
      move=> _ _ _ _ r hr1 hr2.
      have hcat := shake128_slice_cat_block data.[3] k _ hk hb3.
      apply lanes_okP => /=.
      - by move: (h 0 _) => //#.
      - by move: (h 1 _) => //#.
      - by move: (h 2 _) => //#.
      by rewrite /reject_ok /= -hcat /=.

    (* the invariant advances to k + 1 *)
    auto=> &hr |> hk h hxf hblk.
    rewrite /a_inv hxf /= => i rgi; have := h i rgi.
    by rewrite (_ : (i < 4) = true) 1:/# /= /data.
  - wp; do 4! (call matrix_A__rejection_sample_one_block_ll; wp).
    by call shake128_squeezeblock4x_ll; auto.
  (* the variant decreases: k + 1 is consistent *)
  - skip=> &hr [hinv hstop]; split; 1: by split=> //; exists (k + 1); smt().
    have := argmax_bounded (fun k => a_inv nonce k xof_state{hr}
       [polynomial0{hr}; polynomial1{hr}; polynomial2{hr}; polynomial3{hr}]
       [filled0{hr}; filled1{hr}; filled2{hr}; filled3{hr}]) K (k + 1) _ hinv; 1: smt().
    by move=> /= [_ [_ hle]]; smt().
  - by hoare; conseq (: _ ==> true).
  by [].
- by hoare; conseq (: _ ==> true).
by [].
qed.

(* -------------------------------------------------------------------- *)
lemma matrix_A____sample_4_polynomialsH
  (rho_ : rho) (rcs : (int * int) option list)
: (forall ds, stream_ok (to_list rho_ ++ W2u8.to_list ds)) =>
  hoare[
  M.matrix_A____sample_4_polynomials :
         rho = rho_
      /\ (forall i, 0 <= i < 4 =>
           domain_separators.[i] =
             odflt domain_separators.[i] (omap A_ds (nth None rcs i)))
    ==>
         forall i, 0 <= i < 4 =>
           let resi = nth witness [res.`1; res.`2; res.`3; res.`4] i in
           odflt true (omap (fun rc => resi = Apoly rho_ rc) (nth None rcs i))
].
proof. by move=> hok; conseq (matrix_A____sample_4_polynomialsP rho_ rcs hok). qed.

lemma matrix_A____sample_4_polynomials_ll :
  (forall (rho_ : rho) ds, stream_ok (to_list rho_ ++ W2u8.to_list ds)) =>
  islossless M.matrix_A____sample_4_polynomials.
proof.
move=> hok; proc*; exlim rho => rho_.
call (matrix_A____sample_4_polynomialsP rho_ [None; None; None; None] (hok rho_)).
by auto=> />; smt().
qed.

(* -------------------------------------------------------------------- *)
(* k * l is 0 (ML-DSA-44, 87) or 2 (ML-DSA-65) modulo 4 *)
lemma klmod4 : kvec * lvec %% 4 = 0 \/ kvec * lvec %% 4 = 2.
proof. smt(param_sets). qed.

(* the domain separator of the entry of index t, as the code computes it *)
lemma ds_entryE (t : int) : 0 <= t < kvec * lvec =>
  W16u16.truncateu16 (W256.of_int (t %/ lvec `<<` 8) `|` W256.of_int (t %% lvec))
  = A_ds (A_rc_of_index t).
proof.
move=> ht; have hl := gt0_l; have hk : kvec <= 8 /\ lvec <= 7 by smt(param_sets).
have hrow : 0 <= t %/ lvec < 256.
+ by split; [apply divz_ge0 => /# | move=> _; rewrite ltz_divLR // /#].
have hcol : 0 <= t %% lvec < lvec by smt(modz_ge0 ltz_pmod).
rewrite /A_ds /A_rc_of_index /=; apply: W2u8.wordP.
move=> k ?; have [#|] ->> /=: k = 0 \/ k = 1 by smt().
- rewrite truncateu16_256E /= w256_shift_wintE; 1: smt().
  rewrite (bits8_256_le_shiftE _ 1 0) //=.
  by rewrite w256_ofint_bits8E //.
rewrite truncateu16_256E /= w256_shift_wintE; 1: smt().
rewrite (bits8_256_shiftE _ 1) //=.
by rewrite !w256_ofint_bits8E; [smt() | smt() | rewrite /= [_ %/ 256]pdiv_small 1:/#].
qed.

(* -------------------------------------------------------------------- *)
lemma sample____matrix_A_P (rho_ : rho) :
  (forall ds, stream_ok (to_list rho_ ++ W2u8.to_list ds)) =>
  hoare[M.sample____matrix_A :
  rho = rho_ ==> A_valid_up_to rho_ res (kvec * lvec)
].
proof.
move=> hok; proc.
seq  5 : #pre  ; first by auto.
seq  2 : (rho = rho_ /\ seed = rho).
- auto => &hr |>; apply Array32.tP => i hi; rewrite initiE //= hi /=.
  rewrite WArray32.WArray32.get256E pack32bE 1:/# W32u8.Pack.initiE 1:/# /=.
  by rewrite /init8 WArray32.WArray32.initiE 1:/#.
(* the chunks of four polynomials *)
seq 3 : (rho = rho_ /\ seed = rho /\ A_valid_up_to rho matrix_A (4 * (kvec * lvec %/ 4))).
- while (rho = rho_ /\ seed = rho /\ inc = kvec * lvec %/ 4
    /\ 0 <= chunk <= inc
    /\ A_valid_up_to rho matrix_A (4 * chunk)
  ); last by auto=> &hr |>; smt(gt0_k gt0_l).
  wp -1 => /=; cfold 1; kill -1; first by auto.
  seq 3 : (#pre
    /\ aux   = Apoly rho (A_rc_of_index (4 * chunk    ))
    /\ aux_0 = Apoly rho (A_rc_of_index (4 * chunk + 1))
    /\ aux_1 = Apoly rho (A_rc_of_index (4 * chunk + 2))
    /\ aux_2 = Apoly rho (A_rc_of_index (4 * chunk + 3))
  ); last first.
  - proc rewrite 1 replace_256_klE.
    proc rewrite 2 replace_256_klE.
    proc rewrite 3 replace_256_klE.
    proc rewrite 4 replace_256_klE.
    do 2! (hoare split; last by auto=> /#); auto=> &hr |> 4?.
    split; 1: smt().
    pose tp i := Apoly rho{hr} (A_rc_of_index (4 * chunk{hr} + i)).
    pose pa := update_polys matrix_A{hr} (4 * chunk{hr}) (mkseq tp 4).
    rewrite (_ : update_poly _ _ _ = pa);
      first by with hint +listred (rewrite /pa /update_polys /=).
    rewrite mulrDr /= {2}(_ : 4 = size (mkseq tp 4)); first by rewrite size_mkseq.
    apply update_polys_A_valid_up_to; 1,3: smt().
    - by rewrite size_mkseq; smt(divz_eq).
    by move=> i; rewrite size_mkseq /= => rgi; rewrite nth_mkseq 1:/# /=.
  seq > ^while : (#pre /\
    (forall i, 0 <= i < 4 =>
       domain_separators.[i] = A_ds (A_rc_of_index (4 * chunk + i)))
  ).
  - hoare split; last by conseq=> |>.
    while (
         0 <= chunk < kvec * lvec %/ 4
      /\ 0 <= lane <= 4
      /\ (forall i, 0 <= i < lane =>
            domain_separators.[i] = A_ds (A_rc_of_index (4 * chunk + i)))
    ); last by auto=> &hr |> /#.
    hoare split; last by auto=> |> /#.
    hoare split; last by auto=> |> /#.
    auto=> &hr |> 4? ih ? i *.
    rewrite ds_entryE; 1: smt(divz_eq).
    by case: (i < lane{hr}) => ?; rewrite get_set_if //#.
  exlim chunk => chunk_.
  call (matrix_A____sample_4_polynomialsH rho_
    (mkseq (fun i => Some (A_rc_of_index (4 * chunk_ + i))) 4) hok
  ).
  - auto=> &hr |> 4? dsE; split.
    - by with hint +listred (apply/allP_range' => /= /#).
    - by with hint +listred (move=> _ r /allP_range /=).
(* the two-polynomial tail, when k * l = 2 (mod 4) *)
if; last first.
+ skip => &hr |> hv hne; have := klmod4; rewrite hne /= => h0.
  by move: hv; rewrite (_ : 4 * (kvec * lvec %/ 4) = kvec * lvec) //; smt(divz_eq).
seq 6 : (A_valid_up_to rho_ matrix_A (kvec * lvec)); last by auto.
seq 1 : (rho = rho_ /\ seed = rho /\ index = kvec * lvec - 2 /\ kvec * lvec %% 4 = 2 /\
         A_valid_up_to rho matrix_A (kvec * lvec - 2)).
+ auto => &hr |> hv h2.
  by move: hv; rewrite (_ : 4 * (kvec * lvec %/ 4) = kvec * lvec - 2) //; smt(divz_eq).
seq > ^while : (#pre /\
  (forall i, 0 <= i < 2 =>
     domain_separators.[i] = A_ds (A_rc_of_index (kvec * lvec - 2 + i)))
).
- hoare split; last by conseq |>.
  while (
       0 <= lane <= 2 /\ index = kvec * lvec - 2
    /\ (forall i, 0 <= i < lane =>
            domain_separators.[i] = A_ds (A_rc_of_index (kvec * lvec - 2 + i)))
  ); last by auto=> &hr |> /#.
  hoare split; last by auto=> |> /#.
  auto=> &hr |> 2? ih ? i *.
  rewrite ds_entryE; 1: smt(param_sets).
  by case: (i < lane{hr}) => ?; rewrite get_set_if //#.
seq 1: (#pre
  /\ aux   = Apoly rho (A_rc_of_index (kvec * lvec - 2))
  /\ aux_0 = Apoly rho (A_rc_of_index (kvec * lvec - 2 + 1))); last first.
- proc rewrite 1 replace_256_klE.
  proc rewrite 2 replace_256_klE.
  auto=> &hr |> 2?.
  pose tp i := Apoly rho{hr} (A_rc_of_index (kvec * lvec - 2 + i)).
  pose pa := update_polys matrix_A{hr} (kvec * lvec - 2) (mkseq tp 2).
  rewrite (_ : update_poly _ _ _ = pa);
    first by with hint +listred (rewrite /pa /update_polys /=).
  move=> _; rewrite (_ : kvec * lvec = kvec * lvec - 2 + size (mkseq tp 2)).
  + by rewrite size_mkseq /#.
  apply update_polys_A_valid_up_to; 1,3: smt(param_sets).
  - by rewrite size_mkseq /#.
  by move=> i; rewrite size_mkseq /= => rgi; rewrite nth_mkseq 1:/# /=.
call (matrix_A____sample_4_polynomialsH rho_
  [Some (A_rc_of_index (kvec * lvec - 2)); Some (A_rc_of_index (kvec * lvec - 2 + 1))] hok
).
auto=> &hr |> ? ? h; split.
- move=> i h0 h4; case: (i = 0) => [->> /= | ne0]; 1: by rewrite h.
  case: (i = 1) => [->> /= | ne1]; 1: by rewrite h //; congr; congr; ring.
  by rewrite ifF 1:/#.
move=> _ r hr; split.
- by have := hr 0.
by have := hr 1.
qed.

(* -------------------------------------------------------------------- *)
lemma sample____matrix_A_ll :
  (forall (rho_ : rho) ds, stream_ok (to_list rho_ ++ W2u8.to_list ds)) =>
  islossless M.sample____matrix_A.
proof.
move=> hok; have hll := matrix_A____sample_4_polynomials_ll hok.
proc; seq 10 : true => //; last first.
+ if; last by auto.
  wp; call hll.
  by while true (2 - lane); [move=> z; auto=> /# | auto => /#].
wp; while true (inc - chunk).
- move=> z; wp; call hll.
  by while true (4 - lane); [move=> z'; auto=> /# | auto=> /#].
by auto=> /#.
qed.

end AexpandT.
