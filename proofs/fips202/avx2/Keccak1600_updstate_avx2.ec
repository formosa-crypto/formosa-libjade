(******************************************************************************
   Keccak1600_updstate_avx2.ec:

   Correctness proof for the Keccak1600 (updstate) array-buffer absorb/squeeze
   single-lane AVX2 implementation.

   Modelled on Keccak1600_fixedsizes_avx2.ec — same skeleton (abstract theory
   parameterised on _ASIZE, MM module, lemma stubs) extended for the streaming
   updstate procs. Equivalence between MM here and the concrete extraction at
   _ASIZE=999 is checked by Keccak1600_updstate_avx2_checkXtr.ec.

******************************************************************************)

require import AllCore List Int IntDiv StdOrder.

from Jasmin require import JModel_x86.

from JazzEC require import Keccak1600_Jazz.
from JazzEC require import WArray200 WArray208.
from JazzEC require import Array25 Array26.

require import JWordList.
from CryptoSpecs require import FIPS202_Keccakf1600.
from CryptoSpecs require import FIPS202_SHA3_Spec Keccakf1600_Spec Keccak1600_Spec.

require import Keccak1600_ref Keccakf1600_ref.
require import Keccak1600_avx2 Keccakf1600_avx2.
require import Keccak1600_subreadwrite.
require import Keccak1600_fixedsizes_ref.

import IntOrder.


(* =========================================================================
   Status word operations.
   The updstate status word (st.[25]) encodes:
     - byte 0: current position `at` (0 <= at < r8)
     - byte 1: rate in 64-bit words minus 1 (`r64 - 1`), so r8 = 8*r64
     - byte 2: trail byte
   This matches the encoding in _ststatus_data.
   ========================================================================= *)

op ststatus_r8 (s: W64.t) : int =
 let r64 = W64.to_uint ((s `>>` W8.of_int 8) `&` W64.of_int 255) in
 if 200 < 8 * (r64 + 1) then 200 else 8 * (r64 + 1).

op ststatus_at (s: W64.t) : int =
 W64.to_uint (s `&` W64.of_int 255).

op ststatus_trailb (s: W64.t) : W8.t =
 truncateu8 (s `>>` W8.of_int 16).

(* Normalised `at`: as computed by _ststatus_data (clamps to 0 if r8 <= at) *)
op ststatus_at_norm (s: W64.t) : int =
 let r8 = ststatus_r8 s in
 let at = ststatus_at s in
 if r8 <= at then 0 else at.


(* =========================================================================
   Partial-absorb specification for the updstate type.
   st: W64.t Array26.t  where  st.[0..24] = inner keccak state
                               st.[25]    = status word
   ========================================================================= *)

op pabsorb_spec_updstate_avx2 (l: W8.t list) (st: W64.t Array26.t) : bool =
 let stk = Array25.init (fun i => st.[i]) in
 let r8  = ststatus_r8  st.[25] in
 let at  = ststatus_at_norm st.[25] in
 0 < r8 /\ r8 <= 200 /\
 at = size l %% r8 /\
 pabsorb_spec_ref r8 l stk.

op absorb_spec_updstate_avx2 (tb: int) (l: W8.t list) (st: W64.t Array26.t) : bool =
 let stk = Array25.init (fun i => st.[i]) in
 let r8  = ststatus_r8 st.[25] in
 absorb_spec_ref r8 tb l stk.


(* ------------------------------------------------------------------------- *)
(* Size-independent flat layer (memory-buffer / setup procs).                *)
(*                                                                           *)
(* The procs _init_updstate_avx2, _finish_updstate_avx2,                     *)
(* _absorb_m_updstate_avx2 use only Array26 and don't depend on _ASIZE, so   *)
(* they live outside the abstract theory and reference M directly.           *)
(* ------------------------------------------------------------------------- *)


(* ststatus encoding: low byte = at, next = r8/8 - 1, next = trailb,
   high bytes don't-care. *)

op encode_ststatus (at r8m1 trailb : int) : W64.t =
  W64.of_int (at + 256 * r8m1 + 65536 * trailb).

(* Decoder, mirroring _ststatus_data: clamps r8 to 200 and at to [0, r8). *)
op ststatus_data_spec (s : W64.t) : W8.t * int * int =
  let raw_at  = W64.to_uint s %% 256 in
  let raw_r8  = (((W64.to_uint s %/ 256) %% 256) + 1) * 8 in
  let r8      = if 200 < raw_r8 then 200 else raw_r8 in
  let at      = if r8 <= raw_at then 0 else raw_at in
  let trailb  = W8.of_int ((W64.to_uint s %/ 65536) %% 256) in
  (trailb, r8, at).


(* Helpers used by finish: byte-XOR into the keccak state, and the
   `[:u32 8*25] &= 0xFF00FF00` byte-clear on st[25] (preserves r8-1 byte,
   clears at and trailb bytes). *)

op xor_byte_at_st25 (stk : W64.t Array25.t) (pos : int) (b : W8.t)
  : W64.t Array25.t =
  let w = pos %/ 8 in
  let m = W64.of_int (W8.to_uint b) `<<` W8.of_int (8 * (pos %% 8)) in
  stk.[w <- stk.[w] `^` m].

op clear_at_trailb (s : W64.t) : W64.t =
  s `&` W64.of_int 18446744073692839680. (*0xFFFFFFFFFF00FF00*)


(* Concrete spec for init: zeros 25 keccak words, packs (at=0, r8-1=r64-1,
   trailb) into st[25]. Input state is fully overwritten. *)
op init_updstate_avx2_spec
    (_st : W64.t Array26.t) (r64 : int) (trailb : W8.t)
  : W64.t Array26.t =
  Array26.init (fun i =>
    if i < 25 then W64.zero
    else encode_ststatus 0 (r64 - 1) (W8.to_uint trailb)).

(* Concrete spec for finish: applies the FIPS-202 multi-rate padding:
   XOR trailb at byte position `at`, XOR 0x80 at byte position r8-1,
   then clear the at and trailb bytes of st[25]. *)
op finish_updstate_avx2_spec (st : W64.t Array26.t) : W64.t Array26.t =
  let (trailb, r8, at) = ststatus_data_spec st.[25] in
  let stk0 = Array25.init (fun i => st.[i]) in
  let stk1 = xor_byte_at_st25 stk0 at trailb in
  let stk2 = xor_byte_at_st25 stk1 (r8 - 1) (W8.of_int 128) in
  Array26.init (fun i =>
    if i < 25 then stk2.[i] else clear_at_trailb st.[25]).


(* ------------------------------------------------------------------------- *)
(* Bridge lemmas: composition rules for the partial-absorb predicate         *)
(* `pabsorb_spec_updstate_avx2`. These let a client chain                    *)
(*   init → update → absorb_m → finish → squeeze.                            *)
(* ------------------------------------------------------------------------- *)

(* (B1) Init produces the empty-message predicate. *)
lemma init_pabsorb (_st : W64.t Array26.t) (r64 : int) (trailb : W8.t):
  0 < r64 <= 25 =>
  pabsorb_spec_updstate_avx2 [] (init_updstate_avx2_spec _st r64 trailb)
  /\ ststatus_r8     (init_updstate_avx2_spec _st r64 trailb).[25] = r64 * 8
  /\ ststatus_trailb (init_updstate_avx2_spec _st r64 trailb).[25] = trailb.
proof.
move=> Hr; have Ht := W8.to_uint_cmp trailb; pose s := encode_ststatus 0 (r64 - 1) (W8.to_uint trailb); have Es : (init_updstate_avx2_spec _st r64 trailb).[25] = s by rewrite /init_updstate_avx2_spec Array26.initiE.
have Ht' : 0 <= to_uint trailb < 256 by smt(W8.to_uint_cmp pow2_8).
have Us : W64.to_uint s = 256 * (r64 - 1) + 65536 * to_uint trailb by rewrite /s /encode_ststatus of_uintK pmod_small; smt(pow2_64).
have R8 : W64.to_uint ((s `>>` W8.of_int 8) `&` W64.of_int 255) = r64 - 1.
+ rewrite (W64.to_uint_and_mod 8) //.
  rewrite W64.shr_div_le // Us /= (: 256 * (r64 - 1) + 65536 * to_uint trailb = (r64 - 1 + 256 * to_uint trailb) * 256) 1:/#.
  by rewrite mulzK // (: r64 - 1 + 256 * to_uint trailb = (r64 - 1) + to_uint trailb * 256) 1:/# modzMDr modz_small /#.
have AT : W64.to_uint (s `&` W64.of_int 255) = 0 by rewrite (W64.to_uint_and_mod 8) // Us (: 256 * (r64 - 1) + 65536 * to_uint trailb = (r64 - 1 + 256 * to_uint trailb) * 256) 1:/# /= modzMl.
have TB : truncateu8 (s `>>` W8.of_int 16) = trailb.
+ rewrite /truncateu8 W64.shr_div_le // Us (: 256 * (r64 - 1) + 65536 * to_uint trailb = 256 * (r64 - 1) + to_uint trailb * 65536) 1:/# /= divzMDr // divz_small 1:/# /=.
  done.
have Er8 : ststatus_r8 s = r64 * 8 by rewrite /ststatus_r8 /= R8; smt().
have Eat : ststatus_at_norm s = 0 by rewrite /ststatus_at_norm /ststatus_at /= AT; smt().
rewrite /pabsorb_spec_updstate_avx2 /= Es Er8 Eat /ststatus_trailb TB /=; split; first smt().
split; first smt().
rewrite (: Array25.init (fun i => (init_updstate_avx2_spec _st r64 trailb).[i]) = st0); last by apply pabsorb_spec_ref_nil; smt().
apply Array25.tP => i Hi; rewrite Array25.initiE //=.
by rewrite /init_updstate_avx2_spec Array26.initiE 1:/# /= (: i < 25) 1:/# /= /st0 Array25.initiE.
qed.


(* (B3) finish lands the first 25 words of the state at ABSORB1600 of the
       accumulated message, and preserves the rate byte. This is the bridge
       to the squeeze contract, which reads `Array25.init (fun i => _st.[i])`
       directly. *)
lemma ststatus_data_specE s:
  ststatus_data_spec s = (ststatus_trailb s, ststatus_r8 s, ststatus_at_norm s).
proof.
rewrite /ststatus_data_spec /ststatus_trailb /ststatus_r8 /ststatus_at_norm /ststatus_r8 /ststatus_at /= (W64.to_uint_and_mod 8) // (W64.to_uint_and_mod 8) // !W64.shr_div_le // /truncateu8 W64.shr_div_le //=.
rewrite (mulzC _ 8) /=.
by rewrite -(W8.of_int_mod (to_uint s %/ 65536)).
qed.

lemma zext_bits8 (b: W8.t) j:
  0 <= j < 8 => W64.of_int (W8.to_uint b) \bits8 j = if j = 0 then b else W8.zero.
proof.
move=> Hj; have Hb := W8.to_uint_cmp b; rewrite W8u8.bits8_div 1:/# of_uintK (pmod_small (to_uint b)); first smt(pow2_8 pow2_64).
case: (j = 0) => C; first by rewrite C /=.
have P : 256 <= 2 ^ (8 * j) by rewrite (: 8 * j = 8 + 8 * (j - 1)) 1:/# exprD_nneg 1,2:/#; smt(expr_gt0).
by rewrite divz_small //; smt(pow2_8).
qed.

lemma xor_byte_at_st25E stk pos b:
  0 <= pos < 200 =>
  xor_byte_at_st25 stk pos b = stwords ((stbytes stk).[pos <- (stbytes stk).[pos] `^` b]).
proof.
move=> Hp; apply stbytes_inj; rewrite stwordsK; apply WArray200.tP => i Hi; rewrite /xor_byte_at_st25 /= stbytes_get // WArray200.get_setE // Array25.get_setE 1:/#.
rewrite !stbytes_get //; case: (i %/ 8 = pos %/ 8) => C; last by rewrite ifF 1:/#.
rewrite W8u8.xorb8E shl_shlw 1:/# bits8_u64_shl8 1:/# -C.
case: (i = pos) => E; first by rewrite -E /= zext_bits8.
by case: (i %% 8 < pos %% 8) => C2; [ | rewrite zext_bits8 1:/# ifF 1:/#]; rewrite W8.xorw0.
qed.

lemma clear_at_trailb_r8 s:
  (clear_at_trailb s `>>` W8.of_int 8) `&` W64.of_int 255 = (s `>>` W8.of_int 8) `&` W64.of_int 255.
proof.
apply W64.wordP => k Hk; rewrite /clear_at_trailb !shr_shrw // !W64.andwE !W64.shrwE (: 255 = 2^8 - 1) 1:// W64.of_int_powm1 //=.
case: (k < 8) => C //=; have : k \in iota_ 0 8 by rewrite mem_iota /#.
move: k Hk C; rewrite -iotaredE /= => k _ _; rewrite W64.of_intwE /int_bit.
by do 7! (case => [-> //= |]); move=> -> //=.
qed.

lemma finish_absorb (_st : W64.t Array26.t) (_l : W8.t list):
  pabsorb_spec_updstate_avx2 _l _st =>
  Array25.init (fun i => (finish_updstate_avx2_spec _st).[i])
    = ABSORB1600 (ststatus_trailb _st.[25]) (ststatus_r8 _st.[25]) _l
  /\ ststatus_r8 (finish_updstate_avx2_spec _st).[25] = ststatus_r8 _st.[25].
proof.
rewrite /pabsorb_spec_updstate_avx2 /= => [#] Hr0 Hr1 Hat [_ Est]; rewrite /finish_updstate_avx2_spec ststatus_data_specE /=.
split; last by rewrite /ststatus_r8 /= clear_at_trailb_r8.
pose r8 := ststatus_r8 _st.[25]; pose tb := ststatus_trailb _st.[25]; pose at := ststatus_at_norm _st.[25]; pose I := stateabsorb_iblocks (BitEncoding.BitChunking.chunk r8 _l) st0; pose CR := chunkremains r8 _l.
have E : xor_byte_at_st25 (xor_byte_at_st25 (Array25.init (fun i => _st.[i])) at tb) (r8 - 1) (W8.of_int 128) = ABSORB1600 tb r8 _l; last first.
+ by apply Array25.tP => i Hi; rewrite Array25.initiE // Array26.initiE 1:/# /= ifT 1:/# E.
have Hsz : size CR = at by rewrite /CR size_chunkremains /at Hat.
have Hat2 : 0 <= at < r8 by rewrite /at Hat; smt(modz_ge0 ltz_pmod).
rewrite xor_byte_at_st25E 1:/# xor_byte_at_st25E 1:/# stwordsK /ABSORB1600 /stateabsorb_last /addratebit /addratebit8 /stateabsorb.
have K : (stbytes (Array25.init (fun i => _st.[i]))).[at <- (stbytes (Array25.init (fun i => _st.[i]))).[at] `^` tb] = stbytes (addstate I (bytes2state (rcons CR tb))); last by rewrite K.
rewrite Est; apply WArray200.tP => i Hi; rewrite WArray200.get_setE 1:/# !stbytes_addstate /addstbytes !WArray200.map2iE //.
+ smt().
rewrite -(bytes2stbytesP (chunkremains (ststatus_r8 _st.[25]) _l)) -(bytes2stbytesP (rcons CR tb)) !stwordsK.
rewrite !WArray200.get_of_list 1..3:/# nth_rcons -/CR -/I Hsz; case: (i = at) => C.
+ by rewrite C /= (nth_out _ CR) 1:/# W8.xorw0.
by case: (i < at) => C2 //; rewrite (nth_out _ CR) 1:/#.
qed.

lemma finish_at0 (_st : W64.t Array26.t):
  ststatus_at_norm (finish_updstate_avx2_spec _st).[25] = 0.
proof.
rewrite /finish_updstate_avx2_spec ststatus_data_specE /= /ststatus_at_norm /ststatus_at /=.
have -> : clear_at_trailb _st.[25] `&` W64.of_int 255 = W64.zero.
+ apply W64.wordP => k Hk; rewrite /clear_at_trailb !W64.andwE (: 255 = 2^8 - 1) 1:// W64.of_int_powm1 //=.
  case: (k < 8) => C //=; have : k \in iota_ 0 8 by rewrite mem_iota /#.
  move: k Hk C; rewrite -iotaredE /= => k _ _; rewrite W64.of_intwE /int_bit.
  by do 7! (case => [-> //= |]); move=> -> //=.
by rewrite W64.to_uint0.
qed.

hoare ststatus_data_h _s:
 M._ststatus_data : ststatus = _s ==> res = ststatus_data_spec _s.
proof.
proc; auto => />; rewrite /ststatus_data_spec /=; do split.
+ by rewrite /truncateu8 !to_uint_shr ..2:/# of_uintK pmod_small 1:/# of_int_mod /#.
+ rewrite /(\ult) of_uintK pmod_small 1:/# shl_shlw 1:/# to_uint_shl 1:/# (W64.and_mod 8) 1:/# shr_shrw 1:/# to_uintD_small.
  + by rewrite to_uint1 of_uintK to_uint_shr /#.
  rewrite of_uintK to_uint_shr 1:/# to_uint1 !(pmod_small _ W64.modulus) ..3:/# -of_intD shlMP 1:/# /=.
  by case: (200 < (to_uint _s %/ 256 %% 256 + 1) * 8) => C; rewrite of_uintK ?(pmod_small _ W64.modulus) /#.
rewrite /(\ult) /(\ule) of_uintK pmod_small 1:/# shl_shlw 1:/# to_uint_shl 1:/# (W64.and_mod 8) 1:/# shr_shrw 1:/# to_uintD_small.
+ by rewrite to_uint1 of_uintK to_uint_shr /#.
rewrite of_uintK to_uint_shr 1:/# to_uint1 (W64.and_mod 8) 1:/# of_uintK !(pmod_small _ W64.modulus) ..4:/# -of_intD shlMP 1:/# /=.
case: (200 < (to_uint _s %/ 256 %% 256 + 1) * 8) => C; rewrite of_uintK (pmod_small _ W64.modulus) 1:/#.
+ by case: (200 <= to_uint _s %% 256) => *; rewrite of_uintK /#.
by case: ((to_uint _s %/ 256 %% 256 + 1) * 8 <= to_uint _s %% 256) => *; rewrite of_uintK /#.
qed.

lemma st26_set8_bits8 (s: W64.t Array26.t) (b: W8.t) i j:
 0 <= i < 26 => 0 <= j < 8 =>
 WArray208.get64 (WArray208.init64 (fun i0 => s.[i0])).[200 <- b] i \bits8 j
 = if 8 * i + j = 200 then b else s.[i] \bits8 j.
proof.
move=> Hi Hj; rewrite WArray208.get64E W8u8.pack8bE // W8u8.Pack.initiE //= WArray208.get_setE 1:/#.
by case: (8 * i + j = 200) => C //; rewrite /init64 WArray208.initiE 1:/# /=; congr; smt().
qed.

lemma ststatus_byte0 (w' w: W64.t) (b: W8.t):
 (forall j, 0 <= j < 8 => w' \bits8 j = if j = 0 then b else w \bits8 j) =>
 ststatus_at w' = W8.to_uint b /\ ststatus_r8 w' = ststatus_r8 w /\ ststatus_trailb w' = ststatus_trailb w.
proof.
move=> H; have Hb : forall k, 0 <= k < 64 => w'.[k] = if k < 8 then b.[k] else w.[k].
+ move=> k Hk; rewrite (W8u8.get_bits8 w' k) // (W8u8.get_bits8 w k) // H 1:/#.
  by case: (k < 8) => C; [rewrite ifT 1:/# (: k %% 8 = k) 1:/# | rewrite ifF 1:/#].
have S : forall n, 8 <= n < 64 => w' `>>` W8.of_int n = w `>>` W8.of_int n.
+ move=> n Hn; apply W64.wordP => k Hk; rewrite !W64.shr_shrw 1,2:/# /=.
  by rewrite Hk /=; case: (k + n < 64) => C; [rewrite Hb /# | rewrite !W64.get_out /#].
rewrite /ststatus_r8 /ststatus_trailb (S 8) // (S 16) //=.
rewrite /ststatus_at -W8u8.to_uint_zeroextu64; congr; apply W64.wordP => k Hk.
by rewrite W64.andwE W8u8.zeroextu64_bit (: 255 = 2^8 - 1) 1:// W64.of_int_powm1 // Hb //; case: (k < 8) => C /=; smt().
qed.


lemma init_updstate_avx2_ll: islossless M._init_updstate_avx2.
proof. by proc; sp; wp; while(0 <= i <= 6) (6-i); auto => /#. qed.

import BitEncoding.BS2Int. 

hoare init_updstate_avx2_h _st _r64 _trailb:
  M._init_updstate_avx2
  : st = _st /\ r64 = _r64 /\ trailb = _trailb /\ 0 < r64 <= 25
  ==> res = init_updstate_avx2_spec _st _r64 _trailb.
proof.  
proc; sp; wp. while(0 <= i <= 6 /\ r256 = W256.zero /\ 0 < r64 <= 25 /\
                    forall x, 0 <= x < i * 4 => st.[x] = W64.zero).
auto => /> &1 H0 H1 ?? H2 H3. do split; ..2:smt().
+ rewrite mulrSl => x x_min x_max. rewrite initE ifT 1:/# /=.
  rewrite /get64_direct /pack8_t (W64.ext_eq _ W64.zero) 2:/#. move => x0 x0_bnd.
  + rewrite initE ifT 1:/# /= initE ifT 1:/# /= /set256_direct initE ifT 1:/# /(\bits8) /=.
    case(32 * i{1} <= 8 * x + x0 %/ 8 < 32 * i{1} + 32) => cT; 1:rewrite initE /#. 
    + rewrite initE ifT 1:/# /(\bits8) initE /= (Ring.IntID.mulrC 8) JUtils.modz_cmp 1:/#.
      rewrite andaE andTb divzMDl 1:/# -divzMr ..2:/# pdiv_small 1:/# H2 /#.
auto => /> H0 H1. split. smt().
move => i0 st0. rewrite -lezNgt => H2 H3 H4. have->: i0 = 6 by smt(). move => H5.
rewrite (Array26.ext_eq _ (init_updstate_avx2_spec _st _r64 _trailb)) 2:/#. move => x x_bnd.
case(x < 25) => body; 2:rewrite get_setE 1:/# ifT 1:/#.
+ case(x < 24) => lower_body; rewrite /init_updstate_avx2_spec get_setE 1:/# ifF 1:/#.
  + rewrite get_setE 1:/# ifF 1:/# initE ifT 1:/# /= ifT /#.
  + rewrite get_setE 1:/# ifT 1:/# initE ifT 1:/# /= ifT /#.
+ rewrite /init_updstate_avx2_spec /encode_ststatus initE ifT 1:/# /= ifF 1:/#.
  rewrite (W64.ext_eq _ (W64.of_int (256 * (_r64 - 1) + 65536 * to_uint _trailb))) 2:/#.
  move => x0 x0_bnd.
  rewrite /zeroextu64 !shl_shlw ..2:/# of_uintK !pmod_small ..3:/# shlMP 1:/# -orw_disjoint.
  rewrite (W64.ext_eq _ W64.zero) 2:/#. move => x1 x1_bnd. 
  case(x1 < 8) => H /=. 
  + rewrite {1}/W64.of_int get_bits2w 1:/# (int2bs_cat 8 64) 1:/# nth_cat size_int2bs ifT 1:/#.
    rewrite pmod_small; 1: by move: (W8.to_uint_cmp  _trailb); smt().
    rewrite mulrC (int2bs_mulr_pow2 8) 1:/# nth_cat size_nseq ifT 1:/# nth_nseq /#.
  + rewrite andbC {1}/W64.of_int get_bits2w 1:/# pmod_small 1:/# (int2bs_cat 8 64) 1:/#.
    rewrite nth_cat size_int2bs ifF 1:/# /= pdiv_small 1:/# int2bs0 nth_nseq /#.
  rewrite -shlw_or ! shlMP ..2:/# /=.
  have->: 256 * (_r64 - 1) + 65536 * to_uint _trailb = 
          256 * ((_r64 - 1) + 256 * to_uint _trailb) by smt().
  case(x0 < 8) => w0.
  + rewrite /of_int !get_bits2w ..3:/# !(int2bs_cat 8 64) ..3:/# !nth_cat !size_int2bs.
    rewrite !ifT ..3:/# !pmod_small; ..3: by move: (W8.to_uint_cmp  _trailb); smt().
    rewrite mulrC (int2bs_mulr_pow2 8) 1:/# nth_cat size_nseq ifT 1:/# nth_nseq 1:/#.
    rewrite mulrC (int2bs_mulr_pow2 8) 1:/# nth_cat size_nseq ifT 1:/# nth_nseq 1:/#.
    rewrite (int2bs_mulr_pow2 8) 1:/# nth_cat size_nseq ifT 1:/# nth_nseq /#.  
  case(x0 < 16) => w1. move: w0. rewrite -lezNgt => w0.
  + rewrite /of_int !get_bits2w ..3:/# !(int2bs_cat 16 64) ..3:/# !nth_cat !size_int2bs.
    rewrite !ifT ..3:/# !pmod_small; ..3: by move: (W8.to_uint_cmp  _trailb); smt().
    rewrite mulrC (int2bs_mulr_pow2 8) 1:/# nth_cat size_nseq ifF 1:/#.
    rewrite mulrC (int2bs_mulr_pow2 8) 1:/# nth_cat size_nseq ifT 1:/# nth_nseq 1:/# orFb.
    rewrite mulrC !(int2bs_mulr_pow2 8) ..2:/# !nth_cat !size_nseq !ifF ..2:/#.
    rewrite eq_sym -int2bs_mod dvdz_modzDr 1:/# int2bs_mod /#.
  case(x0 < 24) => w2. move: w0 w1. rewrite -!lezNgt => w0 w1.
  + rewrite orbC /of_int !get_bits2w ..3:/# !(int2bs_cat 24 64) ..3:/# !nth_cat !size_int2bs.
    rewrite !ifT ..3:/# !pmod_small; ..3: by move: (W8.to_uint_cmp  _trailb); smt().
    rewrite !(int2bs_cat 16 24) ..3:/# !nth_cat !size_int2bs !ifF ..3:/# pdiv_small 1:/#.
    rewrite int2bs0 nth_nseq 1:/# orFb /=. 
    have->: 256 * (_r64 - 1 + 256 * to_uint _trailb) = 
            256 * (_r64 - 1) + 65536 * to_uint _trailb by smt().
    rewrite (Ring.IntID.mulrC 65536) divzMDr 1:/# eq_sym pdiv_small /#.
   move: w0 w1 w2. rewrite -!lezNgt => w0 w1 w2.
   + rewrite /of_int !get_bits2w ..3:/# !(int2bs_cat 24 64) ..3:/# !nth_cat !size_int2bs.
     rewrite !ifF ..3:/# !pmod_small; ..3: by move: (W8.to_uint_cmp  _trailb); smt().
     rewrite !pdiv_small; by move: (W8.to_uint_cmp  _trailb); smt().
qed.


phoare init_updstate_avx2_ph _st _r64 _trailb:
  [ M._init_updstate_avx2
  : st = _st /\ r64 = _r64 /\ trailb = _trailb /\ 0 < r64 <= 25
  ==> res = init_updstate_avx2_spec _st _r64 _trailb
  ] = 1%r.
proof.
by conseq init_updstate_avx2_ll
       (init_updstate_avx2_h _st _r64 _trailb).
qed.


lemma finish_updstate_avx2_ll: islossless M._finish_updstate_avx2.
proof. islossless. qed.

lemma shl0:
    forall (x: W64.t), x `<<<` 0 = x.
  move => x. rewrite -(W64.to_uintK x) shlMP /#. qed. 

lemma shr0:
    forall (x: W64.t), x `>>>` 0 = x.
proof.
  move => x. rewrite -(W64.to_uintK x) shrDP 1:/# expr0 pmod_small.
  rewrite to_uint_cmp. rewrite divz1 /#. 
qed. 


hoare finish_updstate_avx2_h _st:
  M._finish_updstate_avx2
  : st = _st
    ==> res = finish_updstate_avx2_spec _st.
proof.
proc. inline.
seq 19: (st = _st /\ 
         (trailb, r8, at) = ststatus_data_spec st.[25]). 
+ auto => />; rewrite /ststatus_data_spec /=; do split. 
  + rewrite /truncateu8 !to_uint_shr ..2:/# of_uintK pmod_small 1:/# of_int_mod /#.
  + rewrite /(\ult) of_uintK pmod_small 1:/# shl_shlw 1:/# to_uint_shl 1:/#.
    rewrite (W64.and_mod 8) 1:/# shr_shrw 1:/# to_uintD_small.
    + rewrite to_uint1 of_uintK to_uint_shr /#.
    rewrite of_uintK to_uint_shr 1:/# to_uint1 !(pmod_small _ W64.modulus) ..3:/#.
    rewrite -of_intD shlMP 1:/# /=. 
    case(200 < (to_uint _st.[25] %/ 256 %% 256 + 1) * 8);
      rewrite of_uintK ?(pmod_small _ W64.modulus) /#. 
  + rewrite /(\ult) /(\ule) of_uintK pmod_small 1:/# shl_shlw 1:/# to_uint_shl 1:/#.
    rewrite (W64.and_mod 8) 1:/# shr_shrw 1:/# to_uintD_small.
    + rewrite to_uint1 of_uintK to_uint_shr /#.
    rewrite of_uintK to_uint_shr 1:/# to_uint1 (W64.and_mod 8) 1:/# of_uintK .
    rewrite !(pmod_small _ W64.modulus) ..4:/#.
    rewrite -of_intD shlMP 1:/# /=.
    case(200 < (to_uint _st.[25] %/ 256 %% 256 + 1) * 8).
    + rewrite of_uintK (pmod_small _ W64.modulus) 1:/#. 
      case(200 <= to_uint _st.[25] %% 256 ) => *; rewrite of_uintK /#.
    + rewrite of_uintK (pmod_small _ W64.modulus) 1:/#. 
      case((to_uint _st.[25]%/256%%256+1)*8 <= to_uint _st.[25]%%256)=> *; rewrite of_uintK /#.
(* Finishing *)
wp. skip. move => &hr /= [#] H0 H1.
rewrite (Array26.ext_eq _ (finish_updstate_avx2_spec _st)) 2:/#. move => x x_bnd.
rewrite initE ifT 1:/# /get64_direct /pack8_t /finish_updstate_avx2_spec -!H0 -H1 /=.
move: H1. rewrite /ststatus_data_spec /= => [#] H1 H2 H3.
case(x < 25) => state_eq /=.
+ rewrite initE ifT 1:/# /= ifT 1:/#.
 pose a:= (xor_byte_at_st25
   (xor_byte_at_st25 (init ("_.[_]" st{hr})) at{hr} trailb{hr}) (r8{hr} - 1)
   (of_int 128)).[x].
+ rewrite (W64.ext_eq _ a) 2:/# => x0 x0_bnd.
  rewrite /a initE ifT 1:/# /= initE ifT 1:/# /set32_direct /= initE ifT 1:/# /=.
  rewrite initE ifF 1:/# ifT 1:/# /= initE ifT 1:/# /(\bits8) /= initE ifT 1:/# /=.
  rewrite initE ifT 1:/# /= initE ifT 1:/# /init64 /(\bits8) /= get_setE H2 1:/# /=.
  rewrite mulrC (Ring.IntID.mulrC _ x) modzMDl !divzMDl ..2:/# pdiv_small 1:/#.
  rewrite (pdiv_small (x0 %% 8)) 1:/# !addr0.
  case(200 < (to_uint st{hr}.[25] %/ 256 %% 256 + 1) * 8) => H.
  + case(x * 8 + x0 %/ 8 %% 8 = 200 - 1) => H'.
    rewrite /get8 initE ifT 1:/# /= initE ifT 1:/# /= initE ifT 1:/# /= initE ifT 1:/# /=.
    rewrite initE ifT 1:/# /= -modzDm -modzMm modz_mod modzMm modzDm -divz_eq /=.
    have->: 56 = 7 * 8 by smt(). rewrite divzMDl 1:/# modzMDl modz_mod addrA /= H3 H /=.
    rewrite get_setE 1:/#. have->: x = 24 by smt().
    case(200 <= to_uint st{hr}.[25] %% 256) => H''.
    + rewrite /= ifF 1:/# initE ifT 1:/# /= initE ifT 1:/# (pdiv_small (x0 %% 8)) 1:/# /=.
      rewrite /xor_byte_at_st25 /= shl_shlw 1:/# /= x0_bnd. 
      have->: 56 + x0 %% 8 = x0 by smt(). have->: x0 %% 8 = x0 - 56 by smt().
      rewrite /=. rewrite /of_int !get_bits2w ..2:/# (int2bs_cat 8 64) 1:/#.
      rewrite !pmod_small ..2:/# pdiv_small 1:/# int2bs0 nth_cat size_int2bs ifT /#.
    + rewrite pdiv_small 1:/# addr0.
      + case(199 = to_uint st{hr}.[25] %% 256) => H'''.
        + rewrite /= initE ifT 1:/# /= -H''' /=.
          rewrite /xor_byte_at_st25 /=  shl_shlw 1:/# /= x0_bnd.
          rewrite /= !shl_shlw 1:/# !shlMP 1:/# /of_int !get_bits2w ..3:/#.
          rewrite eq_sym !int2bs_mod (int2bs_cat 8 64) 1:/# (int2bs_cat 56 64) 1:/# mulrC.
          rewrite nth_cat !size_int2bs ifT 1:/# mulrC mulzK 1:/# mulrC. 
          rewrite int2bs_mulr_pow2 1:/# nth_cat size_cat size_nseq size_int2bs ifF 1:/#.
          rewrite !lez_maxr ..2:/# /=. have->: x0 %% 8 = x0 - 56 by smt().
          rewrite addrA. congr; congr; 1:smt(). rewrite eq_sym -{1}(W8.to_uintK trailb{hr}).
          rewrite /of_int get_bits2w 1:/# pmod_small 2:/#. rewrite H1 of_uintK /#.
        + rewrite /= initE ifT 1:/# /=. case(24 = to_uint st{hr}.[25] %% 256 %/ 8) => H''''.
          + rewrite /xor_byte_at_st25 /= get_setE 1:/# H'''' /= initE ifT 1:/# /=.
            rewrite /= !shl_shlw ..2:/# !shlMP ..2:/# /of_int !get_bits2w ..3:/#.
            rewrite eq_sym !int2bs_mod !(int2bs_cat 56 64) ..2:/# mulrC int2bs_mulr_pow2 1:/#.
            rewrite nth_cat size_cat size_nseq size_int2bs ifF 1:/# mulrC mulzK 1:/# mulrC. 
            rewrite (pdiv_small _ (2^56)). split. rewrite mulr_ge0. rewrite expr_ge0 /#.
            + move: (W8.to_uint_cmp trailb{hr}) => [??]. smt(). move =>*.
            + have->: 2^56 = 2^48 * 2^8 by smt().
              rewrite (ler_lt_trans (2^48 * to_uint trailb{hr})) 1:ler_wpmul2r. 
              + move: (W8.to_uint_cmp trailb{hr}) => /#. rewrite ler_weexpn2l /#. 
                rewrite ltr_pmul2l 1:/#. move: (W8.to_uint_cmp trailb{hr}) => /#.
            rewrite int2bs0 !lez_maxr..2:/# (Ring.IntID.mulrC _ (2^56)) int2bs_mulr_pow2 1:/#.
            rewrite nth_cat size_cat size_nseq size_int2bs ifF 1:/# !lez_maxr ..2:/#.
            rewrite nth_nseq 1:/# /=.
            have->: 56 + x0 %% 8 = x0 by smt(). have->: x0 %% 8 = x0 - 56 by smt(). smt().
          + rewrite /xor_byte_at_st25 /= get_setE 1:/# H'''' /=.
            rewrite /= shl_shlw 1:/# shlMP 1:/# /of_int !get_bits2w ..2:/# !int2bs_mod mulrC.
            rewrite int2bs_mulr_pow2 1:/#nth_cat size_nseq /#.
    + rewrite initE ifT 1:/# /= initE ifT 1:/# /= initE ifT 1:/# /= initE ifT 1:/# /=.
      rewrite initE ifT 1:/# /= divzMDl 1:/# pdiv_small 1:/# !modzMDl divzMDl 1:/# !modz_mod.
      rewrite (pdiv_small (x0 %% 8)) 1:/# /get8 /= get_setE 1:/#.
      case(8 * x + x0 %/ 8 %% 8 = at{hr}) => H''. 
      + rewrite initE ifT 1:/# /=initE ifT 1:/# /=.
        rewrite /xor_byte_at_st25 /= shl_shlw 1:/# /= initE ifT 1:/# /= !get_setE ..3:/#.
        case(x = 24) => x24.
        + rewrite initE ifT 1:/# /= x0_bnd /=. have->: at{hr} %% 8 * 8 + x0 %% 8 = x0 by smt().
          rewrite shl_shlw 1:/# shlMP 1:/# (Ring.IntID.mulrC _ (2^56)) /of_int int2bs_mod.
          have->: x0 - 8 * (at{hr} %% 8) = x0 %% 8 by smt(). 
          have->: (W64.bits2w (int2bs 64 (2 ^ 56 * 128 %% W64.modulus))).[x0] = false.
          rewrite int2bs_mod int2bs_mulr_pow2 1:/# get_bits2w 1:/# nth_cat nth_nseq 1:/#.
          rewrite size_nseq ifT /#. 
          rewrite /= -{1}(W8.to_uintK trailb{hr}) /of_int (int2bs_cat 8 64) 1:/#.
          rewrite (pdiv_small (W8.to_uint _)) 1:H1 1:/# int2bs0 get_bits2w 1:/# nth_cat.
          rewrite size_int2bs ifT 1:/# int2bs_mod get_bits2w /#.
        + rewrite ifT 1:/# shlMP 1:/# (Ring.IntID.mulrC _ (2^_)) /of_int int2bs_mod /=.
          have->: at{hr} %% 8 * 8 + x0 %% 8 = x0 by smt(). congr. 
          rewrite -H'' (Ring.IntID.mulrC _ x) modzMDl modz_mod int2bs_mulr_pow2 1:/#.
          rewrite get_bits2w 1:/# nth_cat size_nseq ifF 1:/# lez_maxr 1:/#. 
          have->: x0 - 8 * (x0 %/ 8 %% 8) = x0 %% 8 by smt(). 
          rewrite (int2bs_cat 8) 1:/# nth_cat size_int2bs ifT 1:/#.
          rewrite -{1}(to_uintK) /of_int get_bits2w 1:/# int2bs_mod /#.
      + rewrite initE ifT 1:/# /= initE ifT 1:/# /= mulrC divzMDl 1:/# pdiv_small 1:/#.
        rewrite modzMDl modz_mod pmod_small 1:/# -divz_eq /=.
        rewrite /xor_byte_at_st25 /=  shl_shlw 1:/# /=.
        rewrite /= !shl_shlw 1:/# !shlMP ..2:/# initE ifT 1:/# !get_setE ..3:/#.
        case(x = 24) => x24.
        + case(24 = at{hr} %/ 8) => H'''. 
          + rewrite -H''' -x24 (Ring.IntID.mulrC _ (2^56)) {2}/W64.of_int int2bs_mod.
            rewrite int2bs_mulr_pow2 1:/# /=.
            have->: (W64.of_int (to_uint trailb{hr} * 2 ^ (8 * (at{hr} %% 8)))).[x0] = false.
            + rewrite /of_int int2bs_mod get_bits2w 1:/# mulrC int2bs_mulr_pow2 1:/# nth_cat.
              rewrite size_nseq lez_maxr 1:/#. case( x0 < 8 * (at{hr} %% 8)) => Hx. 
              + rewrite nth_nseq /#. rewrite (int2bs_cat 8) 1:/# nth_cat size_int2bs ifF 1:/#.
                rewrite pdiv_small 1:H1 1:/# int2bs0 nth_nseq /#.
            have->: (W64.bits2w (nseq 56 false ++ int2bs 8 128)).[x0] = false. 
            + rewrite get_bits2w 1:/# nth_cat size_nseq ifT 1:/# nth_nseq /#. smt().
          + rewrite initE ifT 1:/# mulrC  /of_int int2bs_mod int2bs_mulr_pow2 1:/# /=.
          +  have->: (W64.bits2w (nseq 56 false ++ int2bs 8 128)).[x0] = false. 
            + rewrite get_bits2w 1:/# nth_cat size_nseq ifT 1:/# nth_nseq /#. smt().
        + case(24 = at{hr} %/ 8) => H'''; 1:rewrite -H''' ifF 1:/# initE ifT /#.
          case(x = at{hr} %/ 8) => ?. rewrite mulrC /of_int int2bs_mod int2bs_mulr_pow2 1:/#/=.
          + rewrite get_bits2w 1:/# nth_cat size_nseq lez_maxr 1:/#. 
            case( x0 < 8 * (at{hr} %% 8)) => Hx.
              + rewrite nth_nseq /#. rewrite (int2bs_cat 8) 1:/# nth_cat size_int2bs ifF 1:/#.
                rewrite (pdiv_small (to_uint trailb{hr})) 1:H1 1:/# int2bs0 nth_nseq /#.
            rewrite initE ifT /#.
  + case(x * 8 + x0 %/ 8 %% 8 = (to_uint st{hr}.[25] %/ 256 %% 256 + 1) * 8 - 1) => H'. 
    + rewrite /get8 initE ifT 1:/# /= initE ifT 1:/# /= initE ifT 1:/# /= initE ifT 1:/# /=.
      rewrite initE ifT 1:/# !divzMDl ..2:/# modzMDl (pmod_small (x0 %/ 8)) 1:/# -divz_eq /=.
      have->: 56 = 7 * 8 by smt(). rewrite addrA /= H3 H /=.
      rewrite get_setE 1:/#.
      case((to_uint st{hr}.[25] %/ 256 %% 256 + 1) * 8 <= to_uint st{hr}.[25] %% 256) => H''.
      + rewrite /= ifF 1:/# initE ifT 1:/# /= initE ifT 1:/# (pdiv_small (x0 %% 8)) 1:/# /=.
        rewrite /xor_byte_at_st25 /= shl_shlw 1:/# /=. 
        have->: 56 + x0 %% 8 = x0 by smt(). have->: x0 %% 8 = x0 - 56 by smt().
        rewrite shl0  shl_shlw 1:/# shlMP 1:/# mulrC !modzMDl divzMDl 1:/# eq_sym.
        rewrite (Ring.IntID.mulrC _ (2^(8*((-1) %% 8)))) {3}/W64.of_int int2bs_mod.
        rewrite int2bs_mulr_pow2 1:/# /= get_setE 1:/# -H' ifT 1:/# /= get_setE 1:/#.
        rewrite divzMDl 1:/# divz_small 1:/# addr0. 
        have->: to_uint st{hr}.[25] %/ 256 %% 256 = x by smt().
        case(x = 0) => H'''.
        + rewrite /=. have->: (W64.of_int (to_uint trailb{hr})).[x0] = false.
          rewrite /of_int int2bs_mod get_bits2w 1:/# (int2bs_cat 8) 1:/# nth_cat size_int2bs.
          rewrite ifF 1:/# pdiv_small 1:H1 1:/# int2bs0 nth_nseq /#.
          rewrite /of_int /= !get_bits2w ..2:/# nth_cat size_nseq ifF /#.
        + rewrite initE ifT 1:/# /of_int /= !get_bits2w ..2:/# nth_cat size_nseq ifF /#.
      + rewrite (pdiv_small (x0 %% 8)) 1:/# addr0.
        case(8 * (to_uint st{hr}.[25] %/ 256 %% 256) + 7 = to_uint st{hr}.[25] %% 256) => H'''.
        + rewrite initE ifT 1:/# /= initE ifT 1:/# /=. have->: 56 = 7 * 8 by smt(). 
          rewrite modzMDl modz_mod (modz_dvd_pow 3 8 _ 2) 1:/#.
          rewrite /xor_byte_at_st25 /=  shl_shlw 1:/# /=.
            rewrite /= !shl_shlw 1:/# !shlMP ..2:/# initE ifT 1:/# /= !get_setE ..3:/#.
            rewrite !ifT ..2:/# /= eq_sym modzMDl (modz_dvd_pow 3 8 _ 2) 1:/#. 
            rewrite (Ring.IntID.mulrC (to_uint trailb{hr}))  (Ring.IntID.mulrC 128).
            rewrite {1 2}/W64.of_int !int2bs_mod !int2bs_mulr_pow2 ..2:/# !get_bits2w ..2:/#.
            rewrite nth_cat size_nseq ifF 1:/# (int2bs_cat 8) 1:/# nth_cat size_int2bs ifT 1:/#.
            rewrite lez_maxr 1:/#. have->:x0 - 8 * (to_uint st{hr}.[25]%%2^3) = x0 %% 8 by smt().
            rewrite nth_cat size_nseq ifF 1:/# (int2bs_cat 8) 1:/# nth_cat size_int2bs ifT 1:/#.
            rewrite lez_maxr 1:/# /=. have->:x0 - 56 = x0 %% 8 by smt().
            have->: to_uint st{hr}.[25] %% 8 * 8 + x0 %% 8 = x0 by smt().
            rewrite eq_sym -{1}(W8.to_uintK (trailb{hr})) /of_int !get_bits2w ..2:/#.
            rewrite !int2bs_mod /#.
        + rewrite initE ifT 1:/# /= initE ifT 1:/# /=. have->: 56 = 7 * 8 by smt(). 
          rewrite modzMDl modz_mod mulrC divzMDl 1:/# modzMDl /=.
          rewrite /xor_byte_at_st25 /= shl_shlw 1:/# /= !shl_shlw 1:/# !shlMP ..2:/#.
          rewrite initE ifT 1:/# /= !get_setE ..3:/# divzMDl 1:/# /=.
          rewrite ifT 1:/#. have->: 56 + x0 %% 8 = x0 by smt().
          case(to_uint st{hr}.[25] %/ 256 %% 256 = to_uint st{hr}.[25] %% 256 %/ 8) => H''''.
          + rewrite/= eq_sym modzMDl (modz_dvd_pow 3 8 _ 2) 1:/#. 
            rewrite (Ring.IntID.mulrC (to_uint trailb{hr}))  (Ring.IntID.mulrC 128) H''''.
            rewrite {1 2}/W64.of_int !int2bs_mod !int2bs_mulr_pow2 ..2:/# !get_bits2w ..2:/#.
            rewrite nth_cat size_nseq ifF 1:/# (int2bs_cat 8) 1:/# nth_cat size_int2bs ifF 1:/#.
            rewrite (pdiv_small (to_uint trailb{hr})) 1:H1 1:/# int2bs0 nth_cat size_nseq ifF 1:/# nth_nseq 1:/#.
            rewrite (int2bs_cat 8) 1:/# nth_cat size_int2bs ifT 1:/# /= /of_int get_bits2w 1:/#.
            rewrite !int2bs_mod /#.
          + rewrite/= eq_sym modzMDl initE ifT 1:/# /of_int !get_bits2w ..2:/# !int2bs_mod.
            rewrite mulrC int2bs_mulr_pow2 1:/# nth_cat size_nseq ifF 1:/# (int2bs_cat 8) 1:/#.
            rewrite nth_cat size_int2bs ifT /#. 
    + rewrite initE ifT 1:/# /= initE ifT 1:/# /= initE ifT 1:/# /= initE ifT 1:/# /=.
      rewrite initE ifT 1:/# /= !get_setE 1:/# divzMDl 1:/# divz_small 1:/# !modzMDl.
      rewrite divzMDl 1:/# !modz_mod (pdiv_small (x0%%8)) 1:/# !addr0.
      case(8 * x + x0 %/ 8 %% 8 = at{hr}) => H''.
      + rewrite /get8 initE ifT 1:/# /= initE ifT 1:/# /=.
        have->: at{hr} %% 8 * 8 + x0 %% 8 = x0 by smt().
        rewrite /xor_byte_at_st25 /=  shl_shlw 1:/# /=.
        rewrite /= !shl_shlw 1:/# !shlMP ..2:/# initE ifT 1:/# /= !get_setE ..3:/#.
        rewrite divzMDl 1:/# modzMDl.
        case(x = ((to_uint st{hr}.[25] %/ 256 %% 256 + 1) * 8 - 1) %/ 8) => H''''.
        + rewrite !ifT ..2:/# /of_int mulrC (Ring.IntID.mulrC _ (2^(8 * ((-1) %% 8)))).
          rewrite !int2bs_mod !int2bs_mulr_pow2 ..2:/# /= !get_bits2w ..2:/# !nth_cat.
          rewrite size_nseq ifF 1:/# size_nseq (int2bs_cat 8) 1:/# nth_cat size_int2bs.
          rewrite ifT 1:/# !lez_maxr ..2:/#. have->: x0 - 8*(at{hr}%%8) = x0%%8 by smt(). 
          rewrite ifT 1:/# nth_nseq 1:/# -{1}(W8.to_uintK) /of_int get_bits2w 1:/#.
          rewrite int2bs_mod /#.
        + rewrite ifF 1:/# ifT 1:/# /of_int mulrC int2bs_mod int2bs_mulr_pow2 1:/# /=.
          rewrite get_bits2w 1:/# nth_cat size_nseq ifF 1:/# (int2bs_cat 8) 1:/#.
          rewrite nth_cat size_int2bs ifT 1:/# lez_maxr 1:/#  -{1}(W8.to_uintK) /of_int.
          rewrite get_bits2w 1:/# int2bs_mod /#.
      + rewrite initE ifT 1:/# /= initE ifT 1:/# /= mulrC divzMDl 1:/# pdiv_small 1:/#.
        rewrite modzMDl modz_mod pmod_small 1:/# -divz_eq addr0 /xor_byte_at_st25 /=.
        rewrite shl_shlw 1:/# /= !shl_shlw 1:/# !shlMP ..2:/# initE ifT 1:/# /=.
        rewrite !get_setE ..3:/# divzMDl 1:/# modzMDl divNz ..2:/# div0z add0r -addrA subrr.
        case(x = to_uint st{hr}.[25] %/ 256 %% 256) => H'''.
        + rewrite ifT 1:/#. case(to_uint st{hr}.[25] %/ 256 %% 256 = at{hr} %/ 8) => H''''.
          + rewrite ifT 1:/# /of_int !int2bs_mod mulrC (Ring.IntID.mulrC _ (2^(8*((-1)%%8)))).
            rewrite !int2bs_mulr_pow2 ..2:/# /= !get_bits2w ..2:/# !nth_cat !size_nseq.
            rewrite !lez_maxr ..2:/#. case(x0 < 8 * (at{hr} %% 8)) =>*; rewrite ifT 1:/# /=.            
            + rewrite !nth_nseq /#. rewrite (int2bs_cat 8) 1:/# nth_cat size_int2bs ifF 1:/#.
              rewrite (pdiv_small (to_uint trailb{hr})) 1:H1 1:/# int2bs0 !nth_nseq /#.
          + rewrite initE ifF 1:/# ifT 1:/# mulrC /of_int int2bs_mod int2bs_mulr_pow2 1:/# /=.
            rewrite get_bits2w 1:/# !nth_cat !size_nseq ifT 1:/# nth_nseq /#.
        + rewrite ifF 1:/#. case(x = at{hr} %/ 8) => H''''.
          + rewrite /of_int !int2bs_mod mulrC int2bs_mulr_pow2 1:/# /= get_bits2w 1:/#.
            rewrite nth_cat size_nseq lez_maxr 1:/#. case(x0 < 8 * (at{hr} %% 8)) =>*.            
            + rewrite !nth_nseq /#. rewrite (int2bs_cat 8) 1:/# nth_cat size_int2bs ifF 1:/#.
              rewrite (pdiv_small (to_uint trailb{hr})) 1:H1 1:/# int2bs0 !nth_nseq /#.
          + rewrite initE ifT /#.
move: state_eq. have->: (! x < 25) = (x = 25) by smt(). move => w_eq.
rewrite initE ifT 1:/# /= ifF 1:/#.
+ rewrite (W64.ext_eq _ (clear_at_trailb st{hr}.[25])) 2:/# => x0 x0_bnd.
  rewrite initE ifT 1:/# /= initE ifT 1:/# /= /set32_direct initE ifT 1:/# /=.
  case(x0 < 32) => x0_small. 
  + rewrite ifT 1:/# /get32_direct /pack4_t /(\bits8) /= initE ifT 1:/# /=. 
    rewrite initE ifT 1:/# /= initE ifT 1:/# /= initE ifT 1:/# /= initE ifT 1:/# /=.
    rewrite initE ifT 1:/# /= /(\bits8) initE ifT 1:/# /= initE ifT 1:/# /=.
    rewrite initE ifT 1:/# /= /init64 /= get_setE 1:/# ifF 1:/# initE ifT 1:/# /=.
    rewrite initE ifT 1:/# /=. rewrite /(\bits8) initE ifT 1:/# /= initE ifT 1:/# /=.
    rewrite initE ifT 1:/# /= get_setE 1:/# ifF 1:/# initE ifT 1:/# /=.
    rewrite initE ifT 1:/# /= mulrC !modzMDl !divzMDl ..4:/# mulrC divzMDl 1:/#.
    have->: 200 = 25 * 8 by smt(). rewrite divzMDl 1:/# !modzMDl mulrC -addrA w_eq /=.
    rewrite !modz_mod !(pdiv_small (x0%%8)) 1:/# pdiv_small 1:/# !addr0 pdiv_small 1:/#.
    rewrite pdiv_small 1:/# !modz_mod pmod_small 1:/# -divz_eq /=.
    rewrite /clear_at_trailb /of_int int2bs_mod /=. congr. 
    rewrite !get_bits2w ..2:/# (int2bs_cat 32 64) 1:/# nth_cat size_int2bs ifT 1:/#.
    congr. rewrite eq_sym -int2bs_mod /#.
  + rewrite ifF 1:/# /get32_direct /pack4_t /(\bits8) /= initE ifT 1:/# /=. 
    rewrite initE ifT 1:/# /= /(\bits8) initE ifT 1:/# /= initE ifT 1:/# /=.
    rewrite initE ifT 1:/# /= /init64 /(\bits8) get_setE 1:/# ifF 1:/# initE ifT 1:/# /=.
    rewrite initE ifT 1:/# /=. rewrite /(\bits8) initE ifT 1:/# /= initE ifT 1:/# /=.
    rewrite initE ifT 1:/# /= get_setE 1:/# ifF 1:/# initE ifT 1:/# /=.
    rewrite initE ifT 1:/# /= mulrC !modzMDl !divzMDl ..3:/# mulrC divzMDl 1:/#.
    rewrite !modzMDl mulrC divzMDl 1:/# pdiv_small 1:/# !modzMDl !modz_mod.
    rewrite !(pdiv_small (x0%%8)) 1:/# /= pdiv_small 1:/# modz_mod pdiv_small 1:/#.
    rewrite modz_mod w_eq pmod_small 1:/# -divz_eq /=.
    rewrite /clear_at_trailb /of_int int2bs_mod /=. 
    rewrite !get_bits2w 1:/# (int2bs_cat 32 64) 1:/# nth_cat size_int2bs ifF 1:/#.
    rewrite /=. rewrite (int2bs_cat_nseq_true_false 32) 1:/# nseq0 cats0 nth_nseq /#.
qed.

phoare finish_updstate_avx2_ph _st:
  [ M._finish_updstate_avx2
  : st = _st
  ==> res = finish_updstate_avx2_spec _st
  ] = 1%r.
proof.
by conseq finish_updstate_avx2_ll (finish_updstate_avx2_h _st).
qed.


lemma absorb_m_updstate_avx2_ll: islossless M._absorb_m_updstate_avx2.
proof.
proc. inline 9. wp. seq 7: (true) => //=.
seq 6: (1 <= r8) => //=; inline; last first.
+ hoare. auto => />. rewrite /(\ult) of_uintK pmod_small 1:/#.
  move => &hr. rewrite /(\ule). 
  case(200 < to_uint ((st{hr}.[25] `>>` of_int 8) `&` of_int 255 + one `<<` of_int 3)) => H. 
  + rewrite  of_uintK pmod_small /#.
  + rewrite shl_shlw 1:/# to_uint_shl 1:/# to_uintD_small (W64.to_uint_and_mod 8) ..2:/# 1:/# to_uint1 /#.
+ auto => />. rewrite /(\ult) of_uintK pmod_small 1:/#.
  move => &hr. rewrite /(\ule). 
  case(200 < to_uint ((st{hr}.[25] `>>` of_int 8) `&` of_int 255 + one `<<` of_int 3)) => H. 
  + rewrite  of_uintK pmod_small /#.
  + rewrite shl_shlw 1:/# to_uint_shl 1:/# to_uintD_small (W64.to_uint_and_mod 8) ..2:/# 1:/# to_uint1 /#.
case(len < r8).
rcondf 1. auto => /#. auto => /#.
while(0 <= len /\ 1 <= r8) (len) => //=; last first. auto => /#. move => z.
+ wp. simplify. seq 8: (#pre) => //=; 1: auto => /#; last by hoare; wp; auto => /#.
  seq 2: (#pre) => //=; last first. 
  + hoare. sp. case(upto0 < newat0) => //=. rcondf 1; auto => /#.
    while (((0 <= len /\ 1 <= r8) /\ r8 <= len) /\ len = z). auto => /#. auto => /#.
    + sp. while(0 <= len /\ r8 <= len /\ len = z) (upto0 + 8 - newat0) => //=. auto => /#. auto => /#.
    + seq 6: (#pre) => //=. auto => /#.
      seq 138:(#pre /\ r0 = 1) => //=.
    + wp; skip; move => &hr H0*; rewrite H0. trivial.
    wp. while(r0 <= 24) (24 - r0) => //=. move => z0. wp. skip.
    move => &hr H0 * /=. rewrite opprD /=. rewrite -H0.
    split. rewrite -ltzS ltr_le_add. rewrite H0. trivial. rewrite addrC ltr_le_sub. trivial. trivial. auto => /#.
  + hoare. wp. skip. move => &hr H0 * /=. rewrite H0.
  + hoare. wp. auto => /#.

(* Last Step *)
islossless.
while(true) (upto + 8 - newat) => //=. move => z.
+ auto => /#. auto => /#.
qed.

lemma shr3_shl3 (x: int): (x `|>>` 3) `<<` 3 = 8 * (x %/ 8).
proof. by rewrite /(`|>>`) /(`<<`) /= /#. qed.

lemma trunc_shl3_and63 k:
 0 <= k < 8 =>
 (truncateu8 (W64.of_int k) `<<` W8.of_int 3) `&` W8.of_int 63 = W8.of_int (8 * k).
proof.
move=> Hk0; rewrite /truncateu8 W64.of_uintK /W8.(`<<`) W8.of_uintK /= -(W8.to_uintK (W8.of_int (k %% W64.modulus))).
by rewrite W8.shlMP // (W8.and_mod 6) // !W8.of_uintK; smt(modz_small pow2_64).
qed.

hoare add_m_updstate_avx2_h _mem _st _at _buf _upto:
  M._add_m_updstate_avx2
  : Glob.mem = _mem /\ st = _st /\ at = _at /\ buf = _buf /\ upto = _upto
    /\ 0 <= _at <= _upto /\ _upto <= 200
  ==> Glob.mem = _mem
    /\ res.`1 = addstate_at _st _at (memread _mem _buf (_upto - _at))
    /\ res.`2 = _upto
    /\ res.`3 = _buf + (_upto - _at).
proof.
proc => /=; pose L := memread _mem _buf (_upto - _at).
seq 2 : (#pre /\ W64.to_uint at8 = _at %% 8).
+ by auto => /> H0 H1 H2; rewrite (W64.to_uint_and_mod 3) // W64.of_uintK; smt(modz_small pow2_64).
seq 1 : (st = xabs _st _at L at /\ buf = _buf + (at - _at) /\ _at <= at <= _upto /\ (at %% 8 = 0 \/ at = _upto)
         /\ Glob.mem = _mem /\ upto = _upto /\ 0 <= _at /\ _upto <= 200).
+ if; last first.
  + by skip => /> &hr H1 H2 H3; rewrite xabs0 //; left; rewrite -H3.
  wp; ecall (m_rlen_read_upto8_h buf len); wp; skip => /> &hr H0 H1 H2 Hk Hnz.
  have Ea8 : at8{hr} = W64.of_int (_at %% 8) by rewrite -Hk W64.to_uintK.
  have Hk0 : _at %% 8 <> 0 by move: Hnz; rewrite Ea8; apply contra => ->.
  rewrite Hk shr3_shl3 Ea8 trunc_shl3_and63 1:/#; split; first smt().
  move=> _ [o2 t] /= Hs Ho2.
  have U := upd64_xabs _st _at L _at (8 * (_at %/ 8)) (t `<<` W8.of_int (8 * (_at %% 8))) _ _.
  + smt().
  + move=> r Hr; have B := srspec_u64_bits8 t (memread _mem _buf (_upto - _at)) (_upto - _at) _ _ Hs; 1,2: rewrite ?size_memread /#.
    rewrite W64.shl_shlw 1:/# bits8_u64_shl8 //.
    by case: (r < _at %% 8) => C; [rewrite ifF 1:/# | rewrite ifT 1:/# B 1:/# /L; congr; smt()].
  rewrite (xabs0 _st _at L _at) // in U; rewrite U /=.
  have SL : size L = _upto - _at by rewrite /L size_memread /#.
  by split; [smt() | move=> C; rewrite !xabs_addstate_at 1,2:/#; smt()].
seq 3 : (st = xabs _st _at L at /\ buf = _buf + (at - _at) /\ _at <= at <= _upto /\ (at %% 8 = 0 \/ at = _upto) /\ _upto < at + 8
         /\ Glob.mem = _mem /\ upto = _upto /\ 0 <= _at /\ _upto <= 200).
+ while (st = xabs _st _at L at /\ newat = at + 8 /\ buf = _buf + (at - _at) /\ _at <= at <= _upto /\ (at %% 8 = 0 \/ at = _upto)
         /\ Glob.mem = _mem /\ upto = _upto /\ 0 <= _at /\ _upto <= 200); last by auto => /#.
  wp; skip => &hr [#] Est En Eo Ha0 Ha1 Ha8 Em -> H0 H1 Hc /=.
  rewrite Est (upd64_xabs _st _at L at{hr} at{hr}) 1:/#; last by rewrite En /=; smt().
  by move=> r Hr; rewrite loadW64_bits8 // ifT 1:/# /L nth_memread 1:/# Em Eo; congr; ring.
seq 1 : (st = addstate_at _st _at L /\ buf = _buf + (_upto - _at) /\ upto = _upto /\ Glob.mem = _mem); last by auto.
if; last by skip => &hr [#] -> -> Ha0 Ha1 Ha8 Hlt Em -> H0 H1 Hc /=; rewrite xabs_addstate_at; [rewrite /L size_memread /# | smt()].
wp; ecall (m_rlen_read_upto8_h buf (W64.to_uint upto8)); wp; skip => &hr [#] Est Eo Ha0 Ha1 Ha8 Hlt Em -> H0 H1 Hc /=.
have Eu : W64.to_uint (W64.of_int _upto `&` W64.of_int 7) = _upto - at{hr}.
+ by rewrite (W64.to_uint_and_mod 3) // W64.of_uintK; smt(modz_small pow2_64).
rewrite Eu Em; split; first smt().
move=> _ [o t] /= [Hs ->]; have B := srspec_u64_bits8 t (memread _mem buf{hr} (_upto - at{hr})) (_upto - at{hr}) _ _ Hs; 1,2: rewrite ?size_memread /#.
have SL : size L = _upto - _at by rewrite /L size_memread /#.
rewrite Est (upd64_xabs _st _at L at{hr} at{hr}) 1:/#; last by rewrite xabs_addstate_at /#.
move=> r Hr; rewrite B // ifT 1:/#; case: (r < _upto - at{hr}) => C; first by rewrite /L !nth_memread 1,2:/# Eo; congr; ring.
by rewrite !nth_out ?size_memread /#.
qed.

hoare absorb_m_updstate_avx2_h _l _mem _st _buf _len:
  M._absorb_m_updstate_avx2
  : Glob.mem = _mem /\ st = _st /\ buf = _buf /\ len = _len
    /\ pabsorb_spec_updstate_avx2 _l _st /\ 0 <= _len /\ _buf + _len < W64.modulus
  ==> pabsorb_spec_updstate_avx2 (_l ++ memread _mem _buf _len) res
    /\ ststatus_r8     res.[25] = ststatus_r8     _st.[25]
    /\ ststatus_trailb res.[25] = ststatus_trailb _st.[25].
proof.
proc => /=.
seq 4 : (#pre /\ r8 = ststatus_r8 _st.[25] /\ at = ststatus_at_norm _st.[25]).
+ by ecall (ststatus_data_h st.[25]); wp; skip => /> &hr *; rewrite ststatus_data_specE.
seq 3 : (pabsorb_spec_ref (ststatus_r8 _st.[25]) (_l ++ memread _mem _buf (buf - _buf)) stk
         /\ at = (size _l + (buf - _buf)) %% ststatus_r8 _st.[25] /\ len = _len - (buf - _buf) + at /\ 0 <= buf - _buf <= _len
         /\ len < r8 /\ r8 = ststatus_r8 _st.[25] /\ Glob.mem = _mem /\ st = _st /\ 0 < ststatus_r8 _st.[25] <= 200).
+ while (pabsorb_spec_ref (ststatus_r8 _st.[25]) (_l ++ memread _mem _buf (buf - _buf)) stk
         /\ at = (size _l + (buf - _buf)) %% ststatus_r8 _st.[25] /\ len = _len - (buf - _buf) + at /\ 0 <= buf - _buf <= _len
         /\ r8 = ststatus_r8 _st.[25] /\ Glob.mem = _mem /\ st = _st /\ 0 < ststatus_r8 _st.[25] <= 200).
  + wp; ecall (keccakf1600_st25_avx2_h stk); ecall (add_m_updstate_avx2_h Glob.mem stk at buf r8).
    skip => &hr [#] Hp Ea El Ho0 Ho1 -> -> -> Hr0 Hr1 Hc /=.
    have Hs : size (_l ++ memread _mem _buf (buf{hr} - _buf)) = size _l + (buf{hr} - _buf) by rewrite size_cat size_memread.
    split; first smt(modz_ge0 ltz_pmod).
    move=> _ [s a o] [/= Es [_ Eo]] r -> /=; rewrite Es Eo.
    have B := pabsorb_spec_ref_block (ststatus_r8 _st.[25]) (_l ++ memread _mem _buf (buf{hr} - _buf)) (memread _mem buf{hr} (ststatus_r8 _st.[25] - at{hr})) stk{hr} Hp _.
    + by rewrite Hs size_memread; smt(modz_ge0 ltz_pmod).
    rewrite Hs -Ea -catA in B.
    rewrite (: buf{hr} + (ststatus_r8 _st.[25] - at{hr}) - _buf = (buf{hr} - _buf) + (ststatus_r8 _st.[25] - at{hr})) 1:/#.
    rewrite memread_add 1,2:/# (: _buf + (buf{hr} - _buf) = buf{hr}) 1:/# B /=.
    have -> : size _l + (buf{hr} - _buf + (ststatus_r8 _st.[25] - at{hr})) = ((size _l + (buf{hr} - _buf)) %/ ststatus_r8 _st.[25] + 1) * ststatus_r8 _st.[25].
    + by rewrite Ea; have := divz_eq (size _l + (buf{hr} - _buf)) (ststatus_r8 _st.[25]); smt().
    by rewrite modzMl /=; smt(modz_ge0 ltz_pmod).
  auto => /> &hr; rewrite /pabsorb_spec_updstate_avx2 /= => [#] Hr0 Hr1 Hat Hp H0 H1.
  by move=> HA; split; [rewrite cats0 | smt()].
seq 3 : (pabsorb_spec_ref (ststatus_r8 _st.[25]) (_l ++ memread _mem _buf _len) (Array25.init (fun i => st.[i]))
         /\ at = (size _l + _len) %% ststatus_r8 _st.[25] /\ st.[25] = _st.[25] /\ 0 < ststatus_r8 _st.[25] <= 200 /\ 0 <= _len).
+ wp; ecall (add_m_updstate_avx2_h Glob.mem stk at buf len); wp; skip => &hr [#] Hp Ea El Ho0 Ho1 Hlt Er -> -> Hr0 Hr1 /=.
  split; first smt().
  move=> _ [s a o] [/= Es [Ea2 _]].
  have -> : Array25.init ("_.[_]" (Array26.init (fun i => if 0 <= i < 25 then s.[i] else _st.[i]))) = s.
  + by apply Array25.tP => i Hi; rewrite Array25.initiE // Array26.initiE /#.
  have Hs : size (_l ++ memread _mem _buf (buf{hr} - _buf)) = size _l + (buf{hr} - _buf) by rewrite size_cat size_memread.
  have B := pabsorb_spec_ref_add (ststatus_r8 _st.[25]) (_l ++ memread _mem _buf (buf{hr} - _buf)) (memread _mem buf{hr} (len{hr} - at{hr})) stk{hr} Hp _.
  + by rewrite Hs size_memread; smt(modz_ge0 ltz_pmod).
  rewrite Hs -Ea -catA in B; rewrite Es Ea2 (: _len = (buf{hr} - _buf) + (len{hr} - at{hr})) 1:/#.
  rewrite memread_add 1,2:/# (: _buf + (buf{hr} - _buf) = buf{hr}) 1:/# B /=.
  have -> : size _l + (buf{hr} - _buf + (len{hr} - at{hr})) = (size _l + (buf{hr} - _buf)) %/ ststatus_r8 _st.[25] * ststatus_r8 _st.[25] + len{hr}.
  + by rewrite Ea; have := divz_eq (size _l + (buf{hr} - _buf)) (ststatus_r8 _st.[25]); smt().
  by rewrite modzMDl modz_small; smt(modz_ge0 ltz_pmod).
wp; skip => &hr [#] Hp Ea E25 Hr0 Hr1 H0.
have /= [Wa [Wr Wt]] := ststatus_byte0 (WArray208.get64 (WArray208.init64 (fun i0 => st{hr}.[i0])).[200 <- truncateu8 (W64.of_int at{hr})] 25) st{hr}.[25] (truncateu8 (W64.of_int at{hr})) _.
+ by move=> j Hj; rewrite st26_set8_bits8 //; smt().
rewrite Wr Wt E25 /= /pabsorb_spec_updstate_avx2 /ststatus_at_norm /= Wr Wa E25.
have Tb : W8.to_uint (truncateu8 (W64.of_int at{hr})) = at{hr}.
+ by rewrite /truncateu8 W8.of_uintK W64.of_uintK; smt(modz_small modz_ge0 ltz_pmod pow2_64).
have Ei : Array25.init ("_.[_]" (Array26.init (fun i => WArray208.get64 (WArray208.init64 ("_.[_]" st{hr})).[200 <- truncateu8 (W64.of_int at{hr})] i)))
          = Array25.init (fun i => st{hr}.[i]).
+ by apply Array25.tP => i Hi; rewrite !Array25.initiE // Array26.initiE 1:/# /=; apply W8u8.wordP => j Hj; rewrite st26_set8_bits8 1,2:/#; smt().
by rewrite Tb Ei size_cat size_memread //; do ! split => //; smt(modz_ge0 ltz_pmod).
qed.

phoare absorb_m_updstate_avx2_ph _l _mem _st _buf _len:
  [ M._absorb_m_updstate_avx2
  : Glob.mem = _mem /\ st = _st /\ buf = _buf /\ len = _len
    /\ pabsorb_spec_updstate_avx2 _l _st /\ 0 <= _len /\ _buf + _len < W64.modulus
  ==> pabsorb_spec_updstate_avx2 (_l ++ memread _mem _buf _len) res
    /\ ststatus_r8     res.[25] = ststatus_r8     _st.[25]
    /\ ststatus_trailb res.[25] = ststatus_trailb _st.[25]
  ] = 1%r.
proof.
by conseq absorb_m_updstate_avx2_ll
       (absorb_m_updstate_avx2_h _l _mem _st _buf _len).
qed.


abstract theory KeccakUpdstateAvx2.

op _ASIZE: int.

axiom _ASIZE_ge0: 0 <= _ASIZE.
axiom _ASIZE_u64: _ASIZE < W64.modulus.

clone import PolyArray as A
 with op size <- _ASIZE
      proof ge0_size by exact _ASIZE_ge0.

clone import WArray as WA
 with op size <- _ASIZE.

clone import ReadWriteArray as RW
 with op _ASIZE <- _ASIZE,
      theory A <- A,
      theory WA <- WA
      proof _ASIZE_ge0 by exact _ASIZE_ge0
      proof _ASIZE_u64 by exact _ASIZE_u64.


(* -----------------------------------------------------------------------
   Module MM: the extracted procedures, with Array999 replaced by A.t and
   WArray999 / WArray999.xxx replaced by WA.xxx.
   ----------------------------------------------------------------------- *)

module MM = {
  proc _ststatus_data (ststatus:W64.t) : W8.t * int * int = {
    var trailb:W8.t;
    var at:W64.t;
    var r8:W64.t;
    var c_200:W64.t;
    var c_0:W64.t;
    var r8_ui:int;
    var at_ui:int;
    at <- ststatus;
    at <- (at `&` (W64.of_int 255));
    ststatus <- (ststatus `>>` (W8.of_int 8));
    r8 <- ststatus;
    r8 <- (r8 `&` (W64.of_int 255));
    r8 <- (r8 + (W64.of_int 1));
    r8 <- (r8 `<<` (W8.of_int 3));
    c_200 <- (W64.of_int 200);
    r8 <- (((W64.of_int 200) \ult r8) ? c_200 : r8);
    c_0 <- (W64.of_int 0);
    at <- ((r8 \ule at) ? c_0 : at);
    ststatus <- (ststatus `>>` (W8.of_int 8));
    trailb <- (truncateu8 ststatus);
    r8_ui <- (W64.to_uint r8);
    at_ui <- (W64.to_uint at);
    return (trailb, r8_ui, at_ui);
  }

  proc _add_updstate_avx2 (st:W64.t Array25.t, at:int, buf:W8.t A.t,
                           off:int, upto:int) : int * int * W64.t Array25.t = {
    var at8:W64.t;
    var t64:W64.t;
    var sh:W8.t;
    var r256:W256.t;
    var t256:W256.t;
    var upto8:W64.t;
    var len:int;
    var off2:int;
    var newat:int;
    at8 <- (W64.of_int at);
    at8 <- (at8 `&` (W64.of_int 7));
    if ((at8 <> (W64.of_int 0))) {
      len <- upto;
      len <- (len - at);
      at <- (at `|>>` 3);
      at <- (at `<<` 3);
      (off2, t64) <@ RW.MM.__a_rlen_read_upto8 (buf, off, len);
      len <- (len + (W64.to_uint at8));
      sh <- (truncateu8 at8);
      sh <- (sh `<<` (W8.of_int 3));
      t64 <- (t64 `<<` (sh `&` (W8.of_int 63)));
      st <-
      (Array25.init
      (WArray200.get64
      (WArray200.set64_direct (WArray200.init64 (fun i => st.[i])) at
      ((get64_direct (WArray200.init64 (fun i => st.[i])) at) `^` t64))));
      if ((8 <= len)) {
        off <- (off + 8);
        off <- (off - (W64.to_uint at8));
        at <- (at + 8);
      } else {
        off <- off2;
        at <- upto;
      }
    } else {
    }
    newat <- at;
    newat <- (newat + 32);
    while ((newat <= upto)) {
      r256 <- (get256_direct (WArray200.init64 (fun i => st.[i])) at);
      t256 <- (get256_direct (WA.init8 (fun i => buf.[i])) off);
      r256 <- (r256 `^` t256);
      st <-
      (Array25.init
      (WArray200.get64
      (WArray200.set256_direct (WArray200.init64 (fun i => st.[i])) at r256))
      );
      at <- newat;
      off <- (off + 32);
      newat <- (newat + 32);
    }
    newat <- at;
    newat <- (newat + 8);
    while ((newat <= upto)) {
      t64 <- (get64_direct (WA.init8 (fun i => buf.[i])) off);
      st <-
      (Array25.init
      (WArray200.get64
      (WArray200.set64_direct (WArray200.init64 (fun i => st.[i])) at
      ((get64_direct (WArray200.init64 (fun i => st.[i])) at) `^` t64))));
      at <- newat;
      off <- (off + 8);
      newat <- (newat + 8);
    }
    if ((at < upto)) {
      upto8 <- (W64.of_int upto);
      upto8 <- (upto8 `&` (W64.of_int 7));
      (off, t64) <@ RW.MM.__a_rlen_read_upto8 (buf, off, (W64.to_uint upto8));
      st <-
      (Array25.init
      (WArray200.get64
      (WArray200.set64_direct (WArray200.init64 (fun i => st.[i])) at
      ((get64_direct (WArray200.init64 (fun i => st.[i])) at) `^` t64))));
    } else {
    }
    at <- upto;
    return (at, off, st);
  }

  (* Absorb `len` bytes from `buf` into the updstate `st`.
     The parameter `len` is the number of new bytes; internally the function
     reads `at` from the status word to resume partial blocks. *)
  proc _update_updstate_avx2 (st:W64.t Array26.t, buf:W8.t A.t,
                              len:int) : W64.t Array26.t = {
    var ststatus:W64.t;
    var stk:W64.t Array25.t;
    var r8:int;
    var at:int;
    var  _0:W8.t;
    var  _1:int;
    var off:int;
    stk <- witness;
    ststatus <- st.[25];
    ( _0, r8, at) <@ M._ststatus_data (ststatus);
    stk <- (Array25.init (fun i => st.[(0 + i)]));
    off <- 0;
    len <- (len + at);
    while ((r8 <= len)) {
      (at, off, stk) <@ _add_updstate_avx2 (stk, at, buf, off, r8);
      stk <@ M._keccakf1600_st25_avx2 (stk);
      len <- (len - r8);
      at <- 0;
    }
    len <- len;
    (at,  _1, stk) <@ _add_updstate_avx2 (stk, at, buf, off, len);
    st <-
    (Array26.init
    (fun i => (if (0 <= i < (0 + 25)) then stk.[(i - 0)] else st.[i])));
    st <-
    (Array26.init
    (WArray208.get64
    (WArray208.set8_direct (WArray208.init64 (fun i => st.[i])) (8 * 25)
    (truncateu8 (W64.of_int at)))));
    return st;
  }

  (* Copy bytes `st[at..upto-1]` to `buf[off .. off+upto-at-1]`.
     Returns (new_at, new_off, new_buf).  new_at = upto. *)
  proc _dump_updstate_avx2 (buf:W8.t A.t, off:int, st:W64.t Array25.t,
                            at:int, upto:int) : int * int * W8.t A.t = {
    var at8:W64.t;
    var t64:W64.t;
    var sh:W8.t;
    var t256:W256.t;
    var upto8:W64.t;
    var len:int;
    var off2:int;
    var newat:int;
    at8 <- (W64.of_int at);
    at8 <- (at8 `&` (W64.of_int 7));
    if ((at8 <> (W64.of_int 0))) {
      len <- upto;
      len <- (len - at);
      at <- (at `|>>` 3);
      at <- (at `<<` 3);
      t64 <- (get64_direct (WArray200.init64 (fun i => st.[i])) at);
      sh <- (truncateu8 at8);
      sh <- (sh `<<` (W8.of_int 3));
      t64 <- (t64 `>>` (sh `&` (W8.of_int 63)));
      (buf, off2) <@ RW.MM.__a_rlen_write_upto8 (buf, off, t64, len);
      len <- (len + (W64.to_uint at8));
      if ((8 <= len)) {
        off <- (off + 8);
        off <- (off - (W64.to_uint at8));
        at <- (at + 8);
      } else {
        off <- off2;
        at <- upto;
      }
    } else {
    }
    newat <- at;
    newat <- (newat + 32);
    while ((newat <= upto)) {
      t256 <- (get256_direct (WArray200.init64 (fun i => st.[i])) at);
      buf <-
      (A.init
      (WA.get8
      (WA.set256_direct (WA.init8 (fun i => buf.[i])) off t256)
      ));
      at <- newat;
      off <- (off + 32);
      newat <- (newat + 32);
    }
    newat <- at;
    newat <- (newat + 8);
    while ((newat <= upto)) {
      t64 <- (get64_direct (WArray200.init64 (fun i => st.[i])) at);
      buf <-
      (A.init
      (WA.get8
      (WA.set64_direct (WA.init8 (fun i => buf.[i])) off t64)));
      at <- newat;
      off <- (off + 8);
      newat <- (newat + 8);
    }
    if ((at < upto)) {
      upto8 <- (W64.of_int upto);
      upto8 <- (upto8 `&` (W64.of_int 7));
      t64 <- (get64_direct (WArray200.init64 (fun i => st.[i])) at);
      (buf, off) <@ RW.MM.__a_rlen_write_upto8 (buf, off, t64,
      (W64.to_uint upto8));
    } else {
    }
    at <- upto;
    return (at, off, buf);
  }

  (* Squeeze `len` bytes from the updstate into `buf`.
     Reads `at` and `r8` from status word; applies permutation when at=0. *)
  proc _squeeze_updstate_avx2 (st:W64.t Array26.t, buf:W8.t A.t,
                               len:int) : W64.t Array26.t * W8.t A.t = {
    var ststatus:W64.t;
    var stk:W64.t Array25.t;
    var r8:int;
    var at:int;
    var off:int;
    var  _0:W8.t;
    var  _1:int;
    stk <- witness;
    ststatus <- st.[25];
    ( _0, r8, at) <@ M._ststatus_data (ststatus);
    stk <- (Array25.init (fun i => st.[(0 + i)]));
    (* Erased call to spill *)
    if ((at = 0)) {
      stk <@ M._keccakf1600_st25_avx2 (stk);
      at <- 0;
    } else {
    }
    off <- 0;
    len <- (len + at);
    while ((r8 < len)) {
      (at, off, buf) <@ _dump_updstate_avx2 (buf, off, stk, at, r8);
      stk <@ M._keccakf1600_st25_avx2 (stk);
      len <- (len - r8);
      at <- 0;
    }
    len <- len;
    (at,  _1, buf) <@ _dump_updstate_avx2 (buf, off, stk, at, len);
    (* Erased call to unspill *)
    st <-
    (Array26.init
    (fun i => (if (0 <= i < (0 + 25)) then stk.[(i - 0)] else st.[i])));
    st <-
    (Array26.init
    (WArray208.get64
    (WArray208.set8_direct (WArray208.init64 (fun i => st.[i])) (8 * 25)
    (truncateu8 (W64.of_int at)))));
    return (st, buf);
  }

  (* Exported absorb entry point *)
  proc absorb_updstate_avx2 (st:W64.t Array26.t, buf:W8.t A.t, len:int) :
  W64.t Array26.t = {
    st <- st;
    buf <- buf;
    st <@ _update_updstate_avx2 (st, buf, len);
    return st;
  }

  (* Exported squeeze entry point *)
  proc squeeze_updstate_avx2 (st:W64.t Array26.t, buf:W8.t A.t,
                              len:int) : W64.t Array26.t * W8.t A.t = {
    st <- st;
    buf <- buf;
    len <- len;
    (st, buf) <@ _squeeze_updstate_avx2 (st, buf, len);
    return (st, buf);
  }
}.


(* -----------------------------------------------------------------------
   Losslessness lemmas
   ----------------------------------------------------------------------- *)

lemma add_updstate_avx2_ll: islossless MM._add_updstate_avx2.
proof.
proc; seq 3 : true.
+ sp; if; last by auto.
  by inline *; auto.
+ by inline *; auto.
seq 6 : true.
+ by while true; auto; while true; auto.
+ while true (upto + 8 - newat); first by move=> z; auto => /#.
  by wp; while true (upto + 32 - newat); [move=> z; auto => /# | auto => /#].
+ by inline *; auto.
+ by hoare; while true; auto; while true; auto.
+ done.
+ by hoare; inline *; auto.
done.
qed.

hoare ststatus_data_r8_h: M._ststatus_data : true ==> 1 <= res.`2.
proof.
proc; auto => /> &hr.
pose X := (((ststatus{hr} `>>` W8.of_int 8) `&` W64.of_int 255) + W64.one) `<<` W8.of_int 3.
case: (W64.of_int 200 \ult X) => C /=.
+ done.
by rewrite /X shl_shlw 1:/# to_uint_shl 1:/# to_uintD_small (W64.to_uint_and_mod 8) ..2:/# 1:/# to_uint1 /#.
qed.

lemma ststatus_data_ll: islossless M._ststatus_data by islossless.

lemma update_updstate_avx2_ll: islossless MM._update_updstate_avx2.
proof.
proc; seq 3 : (1 <= r8).
+ by inline *; auto.
+ call (: true ==> 1 <= res.`2); first by conseq ststatus_data_ll ststatus_data_r8_h.
  by auto.
+ wp; call add_updstate_avx2_ll; wp; while (1 <= r8) len; [move=> z; wp; call keccakf1600_st25_avx2_ll; call add_updstate_avx2_ll; auto => /# | auto => /#].
+ by hoare; call ststatus_data_r8_h; auto.
done.
qed.

lemma dump_updstate_avx2_ll: islossless MM._dump_updstate_avx2.
proof.
proc; seq 3 : true.
+ by inline *; auto.
+ by inline *; auto.
+ seq 6 : true.
  + by while true; auto; while true; auto.
  + while true (upto + 8 - newat); first by move=> z; auto => /#.
    by wp; while true (upto + 32 - newat); [move=> z; auto => /# | auto => /#].
  + by inline *; auto.
  + by hoare; while true; auto; while true; auto.
  + done.
+ by hoare; inline *; auto.
done.
qed.

lemma squeeze_updstate_avx2_ll: islossless MM._squeeze_updstate_avx2.
proof.
proc; seq 3 : (1 <= r8).
+ by inline *; auto.
+ call (: true ==> 1 <= res.`2); first by conseq ststatus_data_ll ststatus_data_r8_h.
  by auto.
+ wp; call dump_updstate_avx2_ll; wp; while (1 <= r8) len; [move=> z; wp; call keccakf1600_st25_avx2_ll; call dump_updstate_avx2_ll; auto => /# | wp; sp; if; [wp; call keccakf1600_st25_avx2_ll; auto => /# | auto => /#]].
+ by hoare; call ststatus_data_r8_h; auto.
done.
qed.

lemma absorb_updstate_avx2_ll: islossless MM.absorb_updstate_avx2.
proof. proc; call update_updstate_avx2_ll; by auto. qed.

lemma squeeze_updstate_avx2_outer_ll: islossless MM.squeeze_updstate_avx2.
proof. proc; call squeeze_updstate_avx2_ll; by auto. qed.


(* -----------------------------------------------------------------------
   Correctness of _add_updstate_avx2:
   XORs buf[off..off+(upto-at)-1] into state at byte position `at`.
   ----------------------------------------------------------------------- *)

hoare add_updstate_avx2_h _st _at _buf _off _upto:
 MM._add_updstate_avx2
 : st=_st /\ at=_at /\ buf=_buf /\ off=_off /\ upto=_upto
 /\ 0 <= _at <= _upto /\ _upto <= 200
 /\ 0 <= _off /\ _off + (_upto - _at) <= _ASIZE
 ==> let l = sub _buf _off (_upto - _at)
     in res.`3 = addstate_at _st _at l
     /\ res.`1 = _upto
     /\ res.`2 = _off + (_upto - _at).
proof.
proc => /=; pose L := sub _buf _off (_upto - _at).
seq 2 : (#pre /\ W64.to_uint at8 = _at %% 8).
+ auto => /> H0 H1 H2 H3 H4; rewrite (W64.to_uint_and_mod 3) // W64.of_uintK; smt(modz_small pow2_64).
seq 1 : (st = xabs _st _at L at /\ off = _off + (at - _at) /\ _at <= at <= _upto /\ (at %% 8 = 0 \/ at = _upto)
         /\ buf = _buf /\ upto = _upto /\ 0 <= _at /\ _upto <= 200 /\ 0 <= _off /\ _off + (_upto - _at) <= _ASIZE).
+ if; last first.
  + by skip => /> &hr H1 H2 H3 H4 H5; rewrite xabs0 //; left; rewrite -H5.
  wp; ecall (a_rlen_read_upto8_h buf off len); wp; skip => /> &hr H0 H1 H2 H3 H4 Hk Hnz.
  have Ea8 : at8{hr} = W64.of_int (_at %% 8) by rewrite -Hk W64.to_uintK.
  have Hk0 : _at %% 8 <> 0 by move: Hnz; rewrite Ea8; apply contra => ->.
  rewrite Hk shr3_shl3 Ea8 trunc_shl3_and63 1:/#; split; first smt().
  move=> _ [o2 t] /= Hs Ho2.
  have U := upd64_xabs _st _at L _at (8 * (_at %/ 8)) (t `<<` W8.of_int (8 * (_at %% 8))) _ _.
  + smt().
  + move=> r Hr; have B := srspec_u64_bits8 t (sub _buf _off (_upto - _at)) (_upto - _at) _ _ Hs; 1,2: rewrite ?size_sub /#.
    rewrite W64.shl_shlw 1:/# bits8_u64_shl8 //.
    by case: (r < _at %% 8) => C; [rewrite ifF 1:/# | rewrite ifT 1:/# B 1:/# /L; congr; smt()].
  rewrite (xabs0 _st _at L _at) // in U; rewrite U /=.
  have SL : size L = _upto - _at by rewrite /L size_sub /#.
  by split; [smt() | move=> C; rewrite !xabs_addstate_at 1,2:/#; smt()].
seq 3 : (st = xabs _st _at L at /\ off = _off + (at - _at) /\ _at <= at <= _upto /\ (at %% 8 = 0 \/ at = _upto) /\ _upto < at + 32
         /\ buf = _buf /\ upto = _upto /\ 0 <= _at /\ _upto <= 200 /\ 0 <= _off /\ _off + (_upto - _at) <= _ASIZE).
+ while (st = xabs _st _at L at /\ newat = at + 32 /\ off = _off + (at - _at) /\ _at <= at <= _upto /\ (at %% 8 = 0 \/ at = _upto)
         /\ buf = _buf /\ upto = _upto /\ 0 <= _at /\ _upto <= 200 /\ 0 <= _off /\ _off + (_upto - _at) <= _ASIZE); last by auto => /#.
  wp; skip => &hr [#] Est En Eo Ha0 Ha1 Ha8 -> -> H0 H1 H2 H3 Hc /=.
  have SL : size L = _upto - _at by rewrite /L size_sub /#.
  rewrite W256.xorwC Est (upd256_xabs _st _at L at{hr} at{hr}) 1:/#.
  + by move=> r Hr; rewrite wget256_bits8 // 1:/# ifT 1:/# /L nth_sub 1:/# Eo; congr; ring.
  by rewrite En /=; smt().
seq 3 : (st = xabs _st _at L at /\ off = _off + (at - _at) /\ _at <= at <= _upto /\ (at %% 8 = 0 \/ at = _upto) /\ _upto < at + 8
         /\ buf = _buf /\ upto = _upto /\ 0 <= _at /\ _upto <= 200 /\ 0 <= _off /\ _off + (_upto - _at) <= _ASIZE).
+ while (st = xabs _st _at L at /\ newat = at + 8 /\ off = _off + (at - _at) /\ _at <= at <= _upto /\ (at %% 8 = 0 \/ at = _upto)
         /\ buf = _buf /\ upto = _upto /\ 0 <= _at /\ _upto <= 200 /\ 0 <= _off /\ _off + (_upto - _at) <= _ASIZE); last by auto => /#.
  wp; skip => &hr [#] Est En Eo Ha0 Ha1 Ha8 -> -> H0 H1 H2 H3 Hc /=.
  rewrite Est (upd64_xabs _st _at L at{hr} at{hr}) 1:/#; last by rewrite En /=; smt().
  by move=> r Hr; rewrite wget64_bits8 // 1:/# ifT 1:/# /L nth_sub 1:/# Eo; congr; ring.
seq 1 : (st = addstate_at _st _at L /\ off = _off + (_upto - _at) /\ upto = _upto); last by auto.
if; last by skip => &hr [#] -> -> Ha0 Ha1 Ha8 Hlt Hb -> H0 H1 H2 H3 Hc /=; rewrite xabs_addstate_at; [rewrite /L size_sub /# | smt()].
wp; ecall (a_rlen_read_upto8_h buf off (W64.to_uint upto8)); wp; skip => &hr [#] Est Eo Ha0 Ha1 Ha8 Hlt -> -> H0 H1 H2 H3 Hc /=.
have Eu : W64.to_uint (W64.of_int _upto `&` W64.of_int 7) = _upto - at{hr}.
+ by rewrite (W64.to_uint_and_mod 3) // W64.of_uintK; smt(modz_small pow2_64).
rewrite Eu; split; first smt().
move=> _ [o t] /= [Hs ->]; have B := srspec_u64_bits8 t (sub _buf off{hr} (_upto - at{hr})) (_upto - at{hr}) _ _ Hs; 1,2: rewrite ?size_sub /#.
have SL : size L = _upto - _at by rewrite /L size_sub /#.
rewrite Est (upd64_xabs _st _at L at{hr} at{hr}) 1:/#; last by rewrite xabs_addstate_at /#.
move=> r Hr; rewrite B // ifT 1:/#; case: (r < _upto - at{hr}) => C; first by rewrite /L !nth_sub 1,2:/# Eo; congr; ring.
by rewrite !nth_out ?size_sub /#.
qed.

phoare add_updstate_avx2_ph _st _at _buf _off _upto:
 [ MM._add_updstate_avx2
 : st=_st /\ at=_at /\ buf=_buf /\ off=_off /\ upto=_upto
 /\ 0 <= _at <= _upto /\ _upto <= 200
 /\ 0 <= _off /\ _off + (_upto - _at) <= _ASIZE
 ==> let l = sub _buf _off (_upto - _at)
     in res.`3 = addstate_at _st _at l
     /\ res.`1 = _upto
     /\ res.`2 = _off + (_upto - _at)
 ] = 1%r.
proof.
by conseq add_updstate_avx2_ll (add_updstate_avx2_h _st _at _buf _off _upto).
qed.


(* -----------------------------------------------------------------------
   Correctness of _update_updstate_avx2 (internal absorb):
   Absorbs `len` new bytes from `buf[0..len-1]` into the updstate.
   ----------------------------------------------------------------------- *)

hoare update_updstate_avx2_h _l _buf _len _st:
 MM._update_updstate_avx2
 : st=_st /\ buf=_buf /\ len=_len /\ pabsorb_spec_updstate_avx2 _l _st
 /\ 0 <= len <= _ASIZE
 ==> pabsorb_spec_updstate_avx2 (_l ++ sub _buf 0 _len) res
  /\ ststatus_r8     res.[25] = ststatus_r8     _st.[25]
  /\ ststatus_trailb res.[25] = ststatus_trailb _st.[25].
proof.
proc => /=.
seq 3 : (#pre /\ r8 = ststatus_r8 _st.[25] /\ at = ststatus_at_norm _st.[25]).
+ by ecall (ststatus_data_h st.[25]); wp; skip => /> &hr *; rewrite ststatus_data_specE.
seq 4 : (pabsorb_spec_ref (ststatus_r8 _st.[25]) (_l ++ sub _buf 0 off) stk /\ at = (size _l + off) %% ststatus_r8 _st.[25]
         /\ len = _len - off + at /\ 0 <= off <= _len /\ len < r8 /\ r8 = ststatus_r8 _st.[25] /\ buf = _buf /\ st = _st
         /\ 0 < ststatus_r8 _st.[25] <= 200 /\ _len <= _ASIZE).
+ while (pabsorb_spec_ref (ststatus_r8 _st.[25]) (_l ++ sub _buf 0 off) stk /\ at = (size _l + off) %% ststatus_r8 _st.[25]
         /\ len = _len - off + at /\ 0 <= off <= _len /\ r8 = ststatus_r8 _st.[25] /\ buf = _buf /\ st = _st
         /\ 0 < ststatus_r8 _st.[25] <= 200 /\ _len <= _ASIZE).
  + wp; ecall (keccakf1600_st25_avx2_h stk); ecall (add_updstate_avx2_h stk at buf off r8).
    skip => &hr [#] Hp Ea El Ho0 Ho1 -> -> -> Hr0 Hr1 HA Hc /=.
    have Hs : size (_l ++ sub _buf 0 off{hr}) = size _l + off{hr} by rewrite size_cat size_sub.
    split; first smt(modz_ge0 ltz_pmod).
    move=> _ [a o s] [/= Es [_ Eo]] r -> /=; rewrite Es Eo.
    have B := pabsorb_spec_ref_block (ststatus_r8 _st.[25]) (_l ++ sub _buf 0 off{hr}) (sub _buf off{hr} (ststatus_r8 _st.[25] - at{hr})) stk{hr} Hp _.
    + by rewrite Hs size_sub; smt(modz_ge0 ltz_pmod).
    rewrite Hs -Ea -catA in B; rewrite (sub_split off{hr} _buf 0 (off{hr} + (ststatus_r8 _st.[25] - at{hr}))) 1:/# /=.
    rewrite (: off{hr} + (ststatus_r8 _st.[25] - at{hr}) - off{hr} = ststatus_r8 _st.[25] - at{hr}) 1:/# B /=.
    have -> : size _l + (off{hr} + (ststatus_r8 _st.[25] - at{hr})) = ((size _l + off{hr}) %/ ststatus_r8 _st.[25] + 1) * ststatus_r8 _st.[25].
    + by rewrite Ea; smt(divz_eq).
    by rewrite modzMl /=; smt(modz_ge0 ltz_pmod).
  auto => /> &hr; rewrite /pabsorb_spec_updstate_avx2 /= => [#] Hr0 Hr1 Hat Hp H0 H1.
  by move=> HA; split; [rewrite (: sub _buf 0 0 = []) 1:-size_eq0 1:size_sub // cats0 | smt()].
seq 3 : (pabsorb_spec_ref (ststatus_r8 _st.[25]) (_l ++ sub _buf 0 _len) (Array25.init (fun i => st.[i]))
         /\ at = (size _l + _len) %% ststatus_r8 _st.[25] /\ st.[25] = _st.[25] /\ 0 < ststatus_r8 _st.[25] <= 200 /\ 0 <= _len <= _ASIZE).
+ wp; ecall (add_updstate_avx2_h stk at buf off len); wp; skip => &hr [#] Hp Ea El Ho0 Ho1 Hlt Er -> -> Hr0 Hr1 HA /=.
  split; first smt().
  move=> _ [a o s] [/= Es [Ea2 _]].
  have -> : Array25.init ("_.[_]" (Array26.init (fun i => if 0 <= i < 25 then s.[i] else _st.[i]))) = s.
  + by apply Array25.tP => i Hi; rewrite Array25.initiE // Array26.initiE /#.
  have Hs : size (_l ++ sub _buf 0 off{hr}) = size _l + off{hr} by rewrite size_cat size_sub.
  have B := pabsorb_spec_ref_add (ststatus_r8 _st.[25]) (_l ++ sub _buf 0 off{hr}) (sub _buf off{hr} (len{hr} - at{hr})) stk{hr} Hp _.
  + by rewrite Hs size_sub; smt(modz_ge0 ltz_pmod).
  rewrite Hs -Ea -catA in B; rewrite Es Ea2 (sub_split off{hr} _buf 0 _len) 1:/# /= (: _len - off{hr} = len{hr} - at{hr}) 1:/# B /=.
  have -> : size _l + _len = (size _l + off{hr}) %/ ststatus_r8 _st.[25] * ststatus_r8 _st.[25] + len{hr}.
  + by rewrite El Ea; have := divz_eq (size _l + off{hr}) (ststatus_r8 _st.[25]); smt().
  by rewrite modzMDl modz_small; smt(modz_ge0 ltz_pmod).
wp; skip => &hr [#] Hp Ea E25 Hr0 Hr1 H0 HA.
have /= [Wa [Wr Wt]] := ststatus_byte0 (WArray208.get64 (WArray208.init64 (fun i0 => st{hr}.[i0])).[200 <- truncateu8 (W64.of_int at{hr})] 25) st{hr}.[25] (truncateu8 (W64.of_int at{hr})) _.
+ by move=> j Hj; rewrite st26_set8_bits8 //; smt().
rewrite Wr Wt E25 /= /pabsorb_spec_updstate_avx2 /ststatus_at_norm /= Wr Wa E25.
have Tb : W8.to_uint (truncateu8 (W64.of_int at{hr})) = at{hr}.
+ by rewrite /truncateu8 W8.of_uintK W64.of_uintK; smt(modz_small modz_ge0 ltz_pmod pow2_64).
have Ei : Array25.init ("_.[_]" (Array26.init (fun i => WArray208.get64 (WArray208.init64 ("_.[_]" st{hr})).[200 <- truncateu8 (W64.of_int at{hr})] i)))
          = Array25.init (fun i => st{hr}.[i]).
+ by apply Array25.tP => i Hi; rewrite !Array25.initiE // Array26.initiE 1:/# /=; apply W8u8.wordP => j Hj; rewrite st26_set8_bits8 1,2:/#; smt().
by rewrite Tb Ei size_cat size_sub //; do ! split => //; smt(modz_ge0 ltz_pmod).
qed.

phoare update_updstate_avx2_ph _l _buf _len _st:
 [ MM._update_updstate_avx2
 : st=_st /\ buf=_buf /\ len=_len /\ pabsorb_spec_updstate_avx2 _l _st
 /\ 0 <= len <= _ASIZE
 ==> pabsorb_spec_updstate_avx2 (_l ++ sub _buf 0 _len) res
  /\ ststatus_r8     res.[25] = ststatus_r8     _st.[25]
  /\ ststatus_trailb res.[25] = ststatus_trailb _st.[25]
 ] = 1%r.
proof.
by conseq update_updstate_avx2_ll (update_updstate_avx2_h _l _buf _len _st).
qed.


(* -----------------------------------------------------------------------
   Correctness of absorb_updstate_avx2 (exported entry point)
   ----------------------------------------------------------------------- *)

hoare absorb_updstate_avx2_h _l _buf _len _st:
 MM.absorb_updstate_avx2
 : st=_st /\ buf=_buf /\ len=_len /\ pabsorb_spec_updstate_avx2 _l _st
 /\ 0 <= len <= _ASIZE
 ==> pabsorb_spec_updstate_avx2 (_l ++ sub _buf 0 _len) res
  /\ ststatus_r8     res.[25] = ststatus_r8     _st.[25]
  /\ ststatus_trailb res.[25] = ststatus_trailb _st.[25].
proof.
proc.
call (update_updstate_avx2_h _l _buf _len _st).
by auto => />.
qed.

phoare absorb_updstate_avx2_ph _l _buf _len _st:
 [ MM.absorb_updstate_avx2
 : st=_st /\ buf=_buf /\ len=_len /\ pabsorb_spec_updstate_avx2 _l _st
 /\ 0 <= len <= _ASIZE
 ==> pabsorb_spec_updstate_avx2 (_l ++ sub _buf 0 _len) res
  /\ ststatus_r8     res.[25] = ststatus_r8     _st.[25]
  /\ ststatus_trailb res.[25] = ststatus_trailb _st.[25]
 ] = 1%r.
proof.
by conseq absorb_updstate_avx2_ll (absorb_updstate_avx2_h _l _buf _len _st).
qed.


(* -----------------------------------------------------------------------
   Correctness of _dump_updstate_avx2:
   Copies state bytes [at..upto-1] into buf[off..off+(upto-at)-1].
   ----------------------------------------------------------------------- *)

hoare dump_updstate_avx2_h _buf _off _st _at _upto:
 MM._dump_updstate_avx2
 : buf=_buf /\ off=_off /\ st=_st /\ at=_at /\ upto=_upto
 /\ 0 <= _at <= _upto /\ _upto <= 200
 /\ 0 <= _off /\ _off + (_upto - _at) <= _ASIZE
 ==> res.`3 = A.fill (fun i => (stbytes _st).[i - _off + _at]) _off (_upto - _at) _buf
     /\ res.`1 = _upto
     /\ res.`2 = _off + (_upto - _at).
proof.
proc => /=; pose F := fun i => (stbytes _st).[i - _off + _at].
seq 2 : (#pre /\ W64.to_uint at8 = _at %% 8).
+ by auto => /> H0 H1 H2 H3 H4; rewrite (W64.to_uint_and_mod 3) // W64.of_uintK; smt(modz_small pow2_64).
seq 1 : (off = _off + (at - _at) /\ _at <= at <= _upto /\ (at %% 8 = 0 \/ at = _upto)
         /\ (forall i, 0 <= i < _ASIZE => !(_off <= i < _off + (_upto - _at)) => buf.[i] = _buf.[i])
         /\ (forall i, _off <= i < _off + (at - _at) => buf.[i] = F i)
         /\ st = _st /\ upto = _upto /\ 0 <= _at /\ _upto <= 200 /\ 0 <= _off /\ _off + (_upto - _at) <= _ASIZE).
+ if; last by skip => /> &hr H1 H2 H3 H4 H5; split; [rewrite -H5 | smt()].
  wp; ecall (a_rlen_write_upto8_h buf off t64 len); wp; skip => /> &hr H0 H1 H2 H3 H4 Hk Hnz.
  have Ea8 : at8{hr} = W64.of_int (_at %% 8) by rewrite -Hk W64.to_uintK.
  have Hk0 : _at %% 8 <> 0 by move: Hnz; rewrite Ea8; apply contra => ->.
  rewrite Hk shr3_shl3 Ea8 trunc_shl3_and63 1:/#; split; first smt().
  have Fv : forall i, _off <= i => i - _off + _at %% 8 < 8 =>
            (u64bytes (WArray200.get64_direct (stbytes _st) (8 * (_at %/ 8)) `>>` W8.of_int (8 * (_at %% 8)))).[i - _off] = F i.
  + by move=> i Hi0 Hi1; rewrite get_u64bytes W64.shr_shrw 1:/# bits8_u64_shr8 1,2:/# get64d_bits8 1:/# /F; congr; smt().
  move=> _ [b o] /= -> ->; split => C.
  + do 3! (split; first smt()); split => i Hi0 Hi1; first by move=> Hn; rewrite A.filliE 1:/# ifF 1:/#.
    by rewrite A.filliE 1:/# ifT 1:/# /= Fv /#.
  split; first smt().
  by split => i Hi0 Hi1; [move=> Hn; rewrite A.filliE 1:/# ifF 1:/# | rewrite A.filliE 1:/# ifT 1:/# /= Fv /#].
seq 3 : (off = _off + (at - _at) /\ _at <= at <= _upto /\ (at %% 8 = 0 \/ at = _upto) /\ _upto < at + 32
         /\ (forall i, 0 <= i < _ASIZE => !(_off <= i < _off + (_upto - _at)) => buf.[i] = _buf.[i])
         /\ (forall i, _off <= i < _off + (at - _at) => buf.[i] = F i)
         /\ st = _st /\ upto = _upto /\ 0 <= _at /\ _upto <= 200 /\ 0 <= _off /\ _off + (_upto - _at) <= _ASIZE).
+ while (newat = at + 32 /\ off = _off + (at - _at) /\ _at <= at <= _upto /\ (at %% 8 = 0 \/ at = _upto)
         /\ (forall i, 0 <= i < _ASIZE => !(_off <= i < _off + (_upto - _at)) => buf.[i] = _buf.[i])
         /\ (forall i, _off <= i < _off + (at - _at) => buf.[i] = F i)
         /\ st = _st /\ upto = _upto /\ 0 <= _at /\ _upto <= 200 /\ 0 <= _off /\ _off + (_upto - _at) <= _ASIZE); last by auto => /#.
  wp; skip => &hr [#] En Eo Ha0 Ha1 Ha8 Hout Hin -> -> H0 H1 H2 H3 Hc /=.
  have /= -> := a_set256_fill buf{hr} off{hr} (WArray200.get256_direct (stbytes _st) at{hr}).
  do 3! (split; first smt()); split; first by move=> i Hi Hn; rewrite A.filliE 1:/# ifF 1:/# Hout /#.
  split; last smt().
  move=> i Hi; rewrite A.filliE 1:/#; case: (off{hr} <= i < off{hr} + 32) => C /=; last by apply Hin => /#.
  by rewrite get256d_bits8 1:/# /F; congr; smt().
seq 3 : (off = _off + (at - _at) /\ _at <= at <= _upto /\ (at %% 8 = 0 \/ at = _upto) /\ _upto < at + 8
         /\ (forall i, 0 <= i < _ASIZE => !(_off <= i < _off + (_upto - _at)) => buf.[i] = _buf.[i])
         /\ (forall i, _off <= i < _off + (at - _at) => buf.[i] = F i)
         /\ st = _st /\ upto = _upto /\ 0 <= _at /\ _upto <= 200 /\ 0 <= _off /\ _off + (_upto - _at) <= _ASIZE).
+ while (newat = at + 8 /\ off = _off + (at - _at) /\ _at <= at <= _upto /\ (at %% 8 = 0 \/ at = _upto)
         /\ (forall i, 0 <= i < _ASIZE => !(_off <= i < _off + (_upto - _at)) => buf.[i] = _buf.[i])
         /\ (forall i, _off <= i < _off + (at - _at) => buf.[i] = F i)
         /\ st = _st /\ upto = _upto /\ 0 <= _at /\ _upto <= 200 /\ 0 <= _off /\ _off + (_upto - _at) <= _ASIZE); last by auto => /#.
  wp; skip => &hr [#] En Eo Ha0 Ha1 Ha8 Hout Hin -> -> H0 H1 H2 H3 Hc /=.
  have /= -> := a_set64_fill buf{hr} off{hr} (WArray200.get64_direct (stbytes _st) at{hr}).
  do 3! (split; first smt()); split; first by move=> i Hi Hn; rewrite A.filliE 1:/# ifF 1:/# Hout /#.
  split; last smt().
  move=> i Hi; rewrite A.filliE 1:/#; case: (off{hr} <= i < off{hr} + 8) => C /=; last by apply Hin => /#.
  by rewrite get64d_bits8 1:/# /F; congr; smt().
seq 1 : ((forall i, 0 <= i < _ASIZE => !(_off <= i < _off + (_upto - _at)) => buf.[i] = _buf.[i])
         /\ (forall i, _off <= i < _off + (_upto - _at) => buf.[i] = F i) /\ off = _off + (_upto - _at) /\ upto = _upto).
+ if; last by skip => &hr [#] -> Ha0 Ha1 Ha8 Hlt Hout Hin _ -> H0 H1 H2 H3 Hc /=; smt().
  wp; ecall (a_rlen_write_upto8_h buf off t64 (W64.to_uint upto8)); wp; skip => &hr [#] Eo Ha0 Ha1 Ha8 Hlt Hout Hin -> -> H0 H1 H2 H3 Hc /=.
  have Eu : W64.to_uint (W64.of_int _upto `&` W64.of_int 7) = _upto - at{hr}.
  + by rewrite (W64.to_uint_and_mod 3) // W64.of_uintK; smt(modz_small pow2_64).
  rewrite Eu; split; first smt().
  move=> _ [b o] /= [-> ->]; split; first by move=> i Hi Hn; rewrite A.filliE 1:/# ifF 1:/# Hout /#.
  split; last smt().
  move=> i Hi; rewrite A.filliE 1:/#; case: (off{hr} <= i < off{hr} + min 8 (max 0 (_upto - at{hr}))) => C /=; last by apply Hin => /#.
  by rewrite get_u64bytes get64d_bits8 1:/# /F; congr; smt().
auto => /> &hr Hout Hin; apply A.tP => i Hi; rewrite A.filliE //.
by case: (_off <= i < _off + (_upto - _at)) => C; [exact (Hin i C) | exact (Hout i Hi C)].
qed.

phoare dump_updstate_avx2_ph _buf _off _st _at _upto:
 [ MM._dump_updstate_avx2
 : buf=_buf /\ off=_off /\ st=_st /\ at=_at /\ upto=_upto
 /\ 0 <= _at <= _upto /\ _upto <= 200
 /\ 0 <= _off /\ _off + (_upto - _at) <= _ASIZE
 ==> res.`3 = A.fill (fun i => (stbytes _st).[i - _off + _at]) _off (_upto - _at) _buf
     /\ res.`1 = _upto
     /\ res.`2 = _off + (_upto - _at)
 ] = 1%r.
proof.
by conseq dump_updstate_avx2_ll (dump_updstate_avx2_h _buf _off _st _at _upto).
qed.


(* -----------------------------------------------------------------------
   Correctness of _squeeze_updstate_avx2:
   Squeezes _ASIZE bytes from the state into buf.
   ----------------------------------------------------------------------- *)

hoare squeeze_updstate_avx2_h _buf _st _r8 _len:
 MM._squeeze_updstate_avx2
 : buf=_buf /\ len=_len /\ st=_st /\ ststatus_r8 _st.[25] = _r8 /\ ststatus_at_norm _st.[25] = 0
 /\ 0 < _r8 <= 200 /\ 0 < _len <= _ASIZE
 ==> let stk = Array25.init (fun i => _st.[i]) in
     res.`2 = A.fill (fun i => (SQUEEZE1600 _r8 _len stk).[i]) 0 _len _buf
     /\ Array25.init (fun i => res.`1.[i]) = st_i stk ((_len - 1) %/ _r8 + 1)
     /\ ststatus_at res.`1.[25] = (_len - 1) %% _r8 + 1
     /\ ststatus_r8 res.`1.[25] = _r8
     /\ ststatus_trailb res.`1.[25] = ststatus_trailb _st.[25].
proof.
proc => /=; seq 3 : (#pre /\ r8 = _r8 /\ at = 0).
+ by ecall (ststatus_data_h st.[25]); wp; skip => /> &hr *; rewrite ststatus_data_specE.
rcondt 2; first by auto.
seq 6 : (off %% _r8 = 0 /\ stk = st_i (Array25.init (fun i => _st.[i])) (off %/ _r8 + 1) /\ at = 0 /\ len = _len - off /\ 0 < len <= _r8
         /\ 0 <= off /\ buf = A.fill (fun i => (SQUEEZE1600 _r8 _len (Array25.init (fun i => _st.[i]))).[i]) 0 off _buf
         /\ r8 = _r8 /\ st = _st /\ ststatus_r8 _st.[25] = _r8 /\ 0 < _r8 <= 200 /\ 0 < _len <= _ASIZE).
+ while (off %% _r8 = 0 /\ stk = st_i (Array25.init (fun i => _st.[i])) (off %/ _r8 + 1) /\ at = 0 /\ len = _len - off /\ 0 < len
         /\ 0 <= off /\ buf = A.fill (fun i => (SQUEEZE1600 _r8 _len (Array25.init (fun i => _st.[i]))).[i]) 0 off _buf
         /\ r8 = _r8 /\ st = _st /\ ststatus_r8 _st.[25] = _r8 /\ 0 < _r8 <= 200 /\ 0 < _len <= _ASIZE).
  + wp; ecall (keccakf1600_st25_avx2_h stk); ecall (dump_updstate_avx2_h buf off stk at r8).
    skip => &hr [#] Hm -> -> El Hl0 Ho0 -> -> -> Er Hr0 Hr1 Hn0 Hn1 Hc /=.
    split; first smt().
    move=> _ [a o b] [/= Eb [_ Eo]] r ->; rewrite Eb Eo /=.
    have Ek : off{hr} %/ _r8 * _r8 = off{hr} by have := divz_eq off{hr} _r8; smt().
    have R := rsq_step_len (Array25.init (fun i => _st.[i])) _r8 _len (off{hr} %/ _r8) _r8 _buf _ _ _ _; 1..4: smt(divz_ge0).
    rewrite Ek in R.
    split; first by rewrite modzDr.
    have Ed : (off{hr} + _r8) %/ _r8 = off{hr} %/ _r8 + 1 by rewrite divzDr //; smt(divzz).
    have Hk0 : 0 <= off{hr} %/ _r8 + 1 by smt(divz_ge0).
    move: R => /= ->; rewrite Ed /st_i iterS //=.
    + smt(divz_ge0).
    have Ek2 : 0 <= off{hr} %/ _r8 by smt(divz_ge0).
    by rewrite (: off{hr} %/ _r8 + 2 = off{hr} %/ _r8 + 1 + 1) 1:/# iterS 1:/# iterS //; clear Eb Ek Ed; smt().
  wp; ecall (keccakf1600_st25_avx2_h stk); wp; skip => /> &hr H0 H1 H2 H3.
  by split; [split; [by rewrite /st_i iter1 | by rewrite A.fillE; apply A.tP => k Hk; rewrite A.initiE //= /#] | smt()].
seq 3 : (buf = A.fill (fun i => (SQUEEZE1600 _r8 _len (Array25.init (fun i => _st.[i]))).[i]) 0 _len _buf
         /\ Array25.init (fun i => st.[i]) = st_i (Array25.init (fun i => _st.[i])) ((_len - 1) %/ _r8 + 1)
         /\ at = (_len - 1) %% _r8 + 1 /\ st.[25] = _st.[25] /\ ststatus_r8 _st.[25] = _r8 /\ 0 < _r8 <= 200).
+ wp; ecall (dump_updstate_avx2_h buf off stk at len); wp; skip => &hr [#] Hm -> -> El Hl0 Hl1 Ho0 -> Er -> Er8 Hr0 Hr1 Hn0 Hn1 /=.
  split; first smt().
  move=> _ [a o b] [/= Eb [Ea Eo]]; have Ek : off{hr} %/ _r8 * _r8 = off{hr} by have := divz_eq off{hr} _r8; smt().
  have El1 : _len - 1 = off{hr} %/ _r8 * _r8 + (len{hr} - 1) by smt().
  have Hlr : 0 <= len{hr} - 1 < `|_r8| by smt().
  have Eq : (_len - 1) %/ _r8 = off{hr} %/ _r8 by rewrite El1 divzMDl 1:/# (divz_small _ _ Hlr).
  have Em : (_len - 1) %% _r8 + 1 = len{hr} by rewrite El1 modzMDl (modz_small _ _ Hlr).
  have R := rsq_step_len (Array25.init (fun i => _st.[i])) _r8 _len (off{hr} %/ _r8) len{hr} _buf _ _ _ _; 1..4: smt(divz_ge0).
  rewrite Ek (: off{hr} + len{hr} = _len) 1:/# in R.
  rewrite Eb Ea Eq Em; move: R => /= ->; rewrite Er8 /=.
  split; last smt().
  by apply Array25.tP => i Hi; rewrite !Array25.initiE // Array26.initiE 1:/# /= ifT 1:/#.
wp; skip => &hr [#] Eb Est Ea E25 Er8 Hr0 Hr1.
have /= [Wa [Wr Wt]] := ststatus_byte0 (WArray208.get64 (WArray208.init64 (fun i0 => st{hr}.[i0])).[200 <- truncateu8 (W64.of_int at{hr})] 25) st{hr}.[25] (truncateu8 (W64.of_int at{hr})) _.
+ by move=> j Hj; rewrite st26_set8_bits8 //; smt().
have Tb : W8.to_uint (truncateu8 (W64.of_int at{hr})) = at{hr}.
+ by rewrite /truncateu8 W8.of_uintK W64.of_uintK; smt(modz_small modz_ge0 ltz_pmod pow2_64).
have Ei : Array25.init ("_.[_]" (Array26.init (fun i => WArray208.get64 (WArray208.init64 ("_.[_]" st{hr})).[200 <- truncateu8 (W64.of_int at{hr})] i)))
          = Array25.init (fun i => st{hr}.[i]).
+ by apply Array25.tP => i Hi; rewrite !Array25.initiE // Array26.initiE 1:/# /=; apply W8u8.wordP => j Hj; rewrite st26_set8_bits8 1,2:/#; smt().
rewrite Wa Wr Wt Tb Ei Est Ea E25 Er8 /=.
by move: Eb => /=.
qed.

phoare squeeze_updstate_avx2_ph _buf _st _r8 _len:
 [ MM._squeeze_updstate_avx2
 : buf=_buf /\ len=_len /\ st=_st /\ ststatus_r8 _st.[25] = _r8 /\ ststatus_at_norm _st.[25] = 0
 /\ 0 < _r8 <= 200 /\ 0 < _len <= _ASIZE
 ==> let stk = Array25.init (fun i => _st.[i]) in
     res.`2 = A.fill (fun i => (SQUEEZE1600 _r8 _len stk).[i]) 0 _len _buf
     /\ Array25.init (fun i => res.`1.[i]) = st_i stk ((_len - 1) %/ _r8 + 1)
     /\ ststatus_at res.`1.[25] = (_len - 1) %% _r8 + 1
     /\ ststatus_r8 res.`1.[25] = _r8
     /\ ststatus_trailb res.`1.[25] = ststatus_trailb _st.[25]
 ] = 1%r.
proof.
by conseq squeeze_updstate_avx2_ll (squeeze_updstate_avx2_h _buf _st _r8 _len).
qed.


(* -----------------------------------------------------------------------
   Correctness of squeeze_updstate_avx2 (exported entry point)
   ----------------------------------------------------------------------- *)

hoare squeeze_updstate_avx2_outer_h _buf _st _r8 _len:
 MM.squeeze_updstate_avx2
 : buf=_buf /\ len=_len /\ st=_st /\ ststatus_r8 _st.[25] = _r8 /\ ststatus_at_norm _st.[25] = 0
 /\ 0 < _r8 <= 200 /\ 0 < _len <= _ASIZE
 ==> let stk = Array25.init (fun i => _st.[i]) in
     res.`2 = A.fill (fun i => (SQUEEZE1600 _r8 _len stk).[i]) 0 _len _buf
     /\ Array25.init (fun i => res.`1.[i]) = st_i stk ((_len - 1) %/ _r8 + 1)
     /\ ststatus_at res.`1.[25] = (_len - 1) %% _r8 + 1
     /\ ststatus_r8 res.`1.[25] = _r8
     /\ ststatus_trailb res.`1.[25] = ststatus_trailb _st.[25].
proof.
proc.
call (squeeze_updstate_avx2_h _buf _st _r8 _len).
by auto => />.
qed.

phoare squeeze_updstate_avx2_outer_ph _buf _st _r8 _len:
 [ MM.squeeze_updstate_avx2
 : buf=_buf /\ len=_len /\ st=_st /\ ststatus_r8 _st.[25] = _r8 /\ ststatus_at_norm _st.[25] = 0
 /\ 0 < _r8 <= 200 /\ 0 < _len <= _ASIZE
 ==> let stk = Array25.init (fun i => _st.[i]) in
     res.`2 = A.fill (fun i => (SQUEEZE1600 _r8 _len stk).[i]) 0 _len _buf
     /\ Array25.init (fun i => res.`1.[i]) = st_i stk ((_len - 1) %/ _r8 + 1)
     /\ ststatus_at res.`1.[25] = (_len - 1) %% _r8 + 1
     /\ ststatus_r8 res.`1.[25] = _r8
     /\ ststatus_trailb res.`1.[25] = ststatus_trailb _st.[25]
 ] = 1%r.
proof.
by conseq squeeze_updstate_avx2_outer_ll (squeeze_updstate_avx2_outer_h _buf _st _r8 _len).
qed.

end KeccakUpdstateAvx2.
