(******************************************************************************
   Keccak1600_updstate_avx2x4.ec:

   Correctness proof for the Keccak1600 (updstate) array-buffer absorb/squeeze
   4-way AVX2 implementation.

   Modelled on Keccak1600_fixedsizes_avx2x4.ec — same skeleton (abstract theory
   parameterised on _ASIZE, MM module, lemma stubs) extended for the streaming
   updstate procs. Equivalence between MM here and the concrete extraction at
   _ASIZE=999 is checked by Keccak1600_updstate_avx2x4_checkXtr.ec.

******************************************************************************)

require import AllCore List Int IntDiv.

from Jasmin require import JModel_x86.

from JazzEC require import Keccak1600_Jazz.
from JazzEC require import WArray200 WArray800 WArray808.
from JazzEC require import Array25 Array26 Array101.

require import JWordList.
from CryptoSpecs require import FIPS202_Keccakf1600.
from CryptoSpecs require import Keccak1600_Spec Keccakf1600_Spec.

require export Keccak1600_avx2x4 Keccakf1600_avx2x4.
require import Keccak1600_subreadwrite.
require import Keccak1600_ref Keccak1600_fixedsizes_ref Keccak1600_updstate_avx2.


(* =========================================================================
   The x4 updstate: st.[0..99] = packed 4-way keccak state
                    st.[100]   = status word (same encoding as st.[25] in
                                 the 1-way updstate)
   ========================================================================= *)

op A101u64toA25u256 (st: W64.t Array101.t): state4x =
 Array25.init (fun i => WArray808.get256 (WArray808.init64 (fun j => st.[j])) i).

op A25u256toA101u64 (stk: state4x) (s: W64.t): W64.t Array101.t =
 Array101.init (fun i => if i < 100 then stk.[i %/ 4] \bits64 (i %% 4) else s).

op pabsorb_spec_updstate_avx2x4 (l0 l1 l2 l3: W8.t list) (st: W64.t Array101.t) : bool =
 ststatus_at_norm st.[100] = size l0 %% ststatus_r8 st.[100] /\
 pabsorb_spec_avx2x4 (ststatus_r8 st.[100]) l0 l1 l2 l3 (A101u64toA25u256 st).

op init_updstate_avx2x4_spec (r64 : int) (trailb : W8.t) : W64.t Array101.t =
 A25u256toA101u64 st4x0 (encode_ststatus 0 (r64 - 1) (W8.to_uint trailb)).

op finish_updstate_avx2x4_spec (st : W64.t Array101.t) : W64.t Array101.t =
 let (trailb, r8, at) = ststatus_data_spec st.[100] in
 A25u256toA101u64
  (st4x_map (fun s => xor_byte_at_st25 (xor_byte_at_st25 s at trailb) (r8 - 1) (W8.of_int 128))
            (A101u64toA25u256 st))
  (clear_at_trailb st.[100]).


lemma A101u64toA25u256K (stk: state4x) s:
  A101u64toA25u256 (A25u256toA101u64 stk s) = stk.
proof.
apply Array25.tP => i Hi; rewrite /A101u64toA25u256 Array25.initiE //= WArray808.get256E; apply W256.wordP => b Hb.
rewrite W32u8.pack32wE 1:// W32u8.Pack.initiE 1:/# /= /WArray808.init64 WArray808.initiE 1:/# /= /A25u256toA101u64 Array101.initiE 1:/# /= ifT 1:/#.
by rewrite W8u8.bits8iE 1:/# W4u64.bits64iE 1:/# (: (32 * i + b %/ 8) %/ 8 %/ 4 = i) 1:/#; congr; smt().
qed.

lemma pabsorb_spec_avx2x4P r8 l0 l1 l2 l3 st:
  pabsorb_spec_avx2x4 r8 l0 l1 l2 l3 st
  <=> size l1 = size l0 /\ size l2 = size l0 /\ size l3 = size l0
      /\ pabsorb_spec_ref r8 l0 (st4x_get st 0) /\ pabsorb_spec_ref r8 l1 (st4x_get st 1)
      /\ pabsorb_spec_ref r8 l2 (st4x_get st 2) /\ pabsorb_spec_ref r8 l3 (st4x_get st 3).
proof.
rewrite /pabsorb_spec_avx2x4 /pabsorb_spec_ref /st4x_match; split; first by move=> [#] Hr0 Hr1 H1 H2 H3 ->; rewrite st4x_get_pack0 st4x_get_pack1 st4x_get_pack2 st4x_get_pack3 /=.
move=> [#] H1 H2 H3 Hr0 Hr1 E0 _ _ E1 _ _ E2 _ _ E3; do ! split => //; by rewrite -E0 -E1 -E2 -E3 -{1}(st4x_unpackK st).
qed.

lemma finish_lane (s: W64.t Array25.t) (w: W64.t) (l: W8.t list):
  ststatus_at_norm w = size l %% ststatus_r8 w =>
  pabsorb_spec_ref (ststatus_r8 w) l s =>
  xor_byte_at_st25 (xor_byte_at_st25 s (ststatus_at_norm w) (ststatus_trailb w)) (ststatus_r8 w - 1) (W8.of_int 128)
  = ABSORB1600 (ststatus_trailb w) (ststatus_r8 w) l.
proof.
move=> Ha Hp; pose S := Array26.init (fun i => if i < 25 then s.[i] else w); have E25 : S.[25] = w by rewrite /S Array26.initiE.
have Es : Array25.init (fun i => S.[i]) = s; first apply Array25.tP => i Hi; rewrite Array25.initiE //.
+ by rewrite /= /S Array26.initiE 1:/# /= ifT 1:/#.
have := finish_absorb S l _; first by rewrite /pabsorb_spec_updstate_avx2 /= E25 Es; move: Hp; rewrite /pabsorb_spec_ref => [#] Hr0 Hr1 Hs; do ! split => //.
rewrite E25 => [[<- _]]; rewrite /finish_updstate_avx2_spec ststatus_data_specE /= E25 Es.
by apply Array25.tP => i Hi; rewrite Array25.initiE // Array26.initiE 1:/# /= ifT 1:/#.
qed.

lemma init_pabsorb_avx2x4 (r64 : int) (trailb : W8.t):
  0 < r64 <= 25 =>
  pabsorb_spec_updstate_avx2x4 [] [] [] [] (init_updstate_avx2x4_spec r64 trailb)
  /\ ststatus_r8     (init_updstate_avx2x4_spec r64 trailb).[100] = r64 * 8
  /\ ststatus_trailb (init_updstate_avx2x4_spec r64 trailb).[100] = trailb.
proof.
move=> Hr; have [Hp [R T]] := init_pabsorb witness r64 trailb Hr.
have E : (init_updstate_avx2_spec witness r64 trailb).[25] = (init_updstate_avx2x4_spec r64 trailb).[100].
+ by rewrite /init_updstate_avx2_spec /init_updstate_avx2x4_spec /A25u256toA101u64 Array26.initiE // Array101.initiE.
move: Hp R T; rewrite /pabsorb_spec_updstate_avx2 /= E => [#] Hr0 Hr1 Hat _ R T; rewrite R T /= /pabsorb_spec_updstate_avx2x4 Hat R /=.
by rewrite /init_updstate_avx2x4_spec A101u64toA25u256K; apply pabsorb_spec_avx2x4_nil; smt().
qed.

lemma finish_absorb_avx2x4 (_st : W64.t Array101.t) l0 l1 l2 l3:
  pabsorb_spec_updstate_avx2x4 l0 l1 l2 l3 _st =>
  A101u64toA25u256 (finish_updstate_avx2x4_spec _st)
    = st4x_pack ( ABSORB1600 (ststatus_trailb _st.[100]) (ststatus_r8 _st.[100]) l0
                , ABSORB1600 (ststatus_trailb _st.[100]) (ststatus_r8 _st.[100]) l1
                , ABSORB1600 (ststatus_trailb _st.[100]) (ststatus_r8 _st.[100]) l2
                , ABSORB1600 (ststatus_trailb _st.[100]) (ststatus_r8 _st.[100]) l3)
  /\ ststatus_r8 (finish_updstate_avx2x4_spec _st).[100] = ststatus_r8 _st.[100].
proof.
rewrite /pabsorb_spec_updstate_avx2x4 pabsorb_spec_avx2x4P => [#] Ha H1 H2 H3 P0 P1 P2 P3.
rewrite /finish_updstate_avx2x4_spec ststatus_data_specE /= A101u64toA25u256K.
split; last by rewrite /A25u256toA101u64 Array101.initiE //= /ststatus_r8 /= clear_at_trailb_r8.
by rewrite st4x_mapE /= (finish_lane _ _ l0) // (finish_lane _ _ l1) 1:H1 // (finish_lane _ _ l2) 1:H2 // (finish_lane _ _ l3) 1:H3.
qed.

lemma finish_at0_avx2x4 (_st : W64.t Array101.t):
  ststatus_at_norm (finish_updstate_avx2x4_spec _st).[100] = 0.
proof.
rewrite /finish_updstate_avx2x4_spec ststatus_data_specE /= /A25u256toA101u64 Array101.initiE //= /ststatus_at_norm /ststatus_at /=.
have -> : clear_at_trailb _st.[100] `&` W64.of_int 255 = W64.zero; last by rewrite W64.to_uint0.
apply W64.wordP => k Hk; rewrite /clear_at_trailb !W64.andwE (: 255 = 2^8 - 1) 1:// W64.of_int_powm1 //=; case: (k < 8) => C //=; have : k \in iota_ 0 8 by rewrite mem_iota /#.
move: k Hk C; rewrite -iotaredE /= => k _ _; rewrite W64.of_intwE /int_bit; by do 7! (case => [-> //= |]); move=> -> //=.
qed.


(* ------------------------------------------------------------------------- *)
(* Size-independent flat layer (x4, 4-way parallel).                         *)
(*                                                                           *)
(* Only `_init_updstate_avx2x4` and `_finish_updstate_avx2x4` are            *)
(* size-independent — `_absorb_m_updstate_avx2x4` internally calls the       *)
(* array-buffer add proc, so the memory variant doesn't extract into         *)
(* `Keccak1600_Jazz` (it lives in the abstract theory's MM via the array     *)
(* `absorb_updstate_avx2x4`). Clients drive 4-way SHA3 / SHAKE via:          *)
(*                                                                           *)
(*   init_updstate_avx2x4                                                    *)
(*   absorb_updstate_avx2x4 (size-dep, in abstract theory)                   *)
(*   finish_updstate_avx2x4                                                  *)
(*   squeeze_updstate_avx2x4 (size-dep, in abstract theory)                  *)
(* ------------------------------------------------------------------------- *)


(* ------------------------------------------------------------------------- *)
(* Flat (size-indep) `_ll` / `_h` / `_ph` triples for init / finish.         *)
(* ------------------------------------------------------------------------- *)

lemma A25u256toA101u64E (stk: state4x) (st: W64.t Array101.t):
  Array101.init (fun i => WArray808.get64 (WArray808.init8 (fun j => if 0 <= j < 800 then WArray800.get8 (WArray800.init256 (fun k => stk.[k])) j else WArray808.get8 (WArray808.init64 (fun k => st.[k])) j)) i)
  = A25u256toA101u64 stk st.[100].
proof.
apply Array101.tP => i Hi; rewrite /A25u256toA101u64 !Array101.initiE //= WArray808.get64E; apply W64.wordP => b Hb.
rewrite W8u8.pack8wE 1:// W8u8.Pack.initiE 1:/# /= WArray808.initiE 1:/# /=.
case: (i < 100) => C; [rewrite ifT 1:/# | rewrite ifF 1:/#].
+ rewrite /WArray800.get8 /WArray800.init256 WArray800.initiE 1:/# /=.
  by rewrite W32u8.bits8iE 1:/# W4u64.bits64iE 1:/# (: (8 * i + b %/ 8) %/ 32 = i %/ 4) 1:/#; congr; smt().
by rewrite /WArray808.get8 /WArray808.init64 WArray808.initiE 1:/# /= W8u8.bits8iE 1:/# (: (8 * i + b %/ 8) %/ 8 = 100) 1:/#; congr; smt().
qed.

lemma init_status (r64: int) (tb: W8.t):
  0 < r64 <= 25 =>
  (zeroextu64 tb `<<` W8.of_int 8) + zeroextu64 (W8.of_int ((r64 - 1) %% 256)) `<<` W8.of_int 8
  = encode_ststatus 0 (r64 - 1) (W8.to_uint tb).
proof.
move=> Hr; have Ht := W8.to_uint_cmp tb; apply W64.to_uint_eq; rewrite /encode_ststatus /= W64.to_uint_shl 1:// W64.to_uintD /= W64.to_uint_shl 1:// !W8u8.to_uint_zeroextu64 /=.
have Ht' : 0 <= to_uint tb < 256 by smt(pow2_8).
by rewrite W64.of_uintK (modz_small ((r64 - 1) %% 256)) 1:/# (modz_small (r64 - 1)) 1:/# !(modz_small _ 18446744073709551616) /#.
qed.

lemma init_updstate_avx2x4_ll: islossless M._init_updstate_avx2x4.
proof. by proc; wp; call state_init_avx2x4_ll; auto. qed.

hoare init_updstate_avx2x4_h _r64 _trailb:
  M._init_updstate_avx2x4
  : r64 = _r64 /\ trailb = _trailb /\ 0 < r64 <= 25
  ==> res = init_updstate_avx2x4_spec _r64 _trailb.
proof.
proc; wp; ecall (state_init_avx2x4_h'); wp; skip => &hr [#] <- <- Hr0 Hr1 /= _ ->.
move: Hr0 Hr1 => /= Hr0 Hr1; rewrite A25u256toA101u64E init_status 1:/# /init_updstate_avx2x4_spec.
by apply Array101.tP => i Hi; rewrite Array101.get_setE // /A25u256toA101u64 !Array101.initiE //; smt().
qed.

phoare init_updstate_avx2x4_ph _r64 _trailb:
  [ M._init_updstate_avx2x4
  : r64 = _r64 /\ trailb = _trailb /\ 0 < r64 <= 25
  ==> res = init_updstate_avx2x4_spec _r64 _trailb
  ] = 1%r.
proof.
by conseq init_updstate_avx2x4_ll
       (init_updstate_avx2x4_h _r64 _trailb).
qed.


lemma A101_xor256 (st: W64.t Array101.t) j (v: W256.t):
  0 <= j < 25 =>
  Array101.init (WArray808.get64 (WArray808.set256_direct (WArray808.init64 (fun i => st.[i])) (32*j) (v `^` WArray808.get256_direct (WArray808.init64 (fun i => st.[i])) (32*j))))
  = A25u256toA101u64 ((A101u64toA25u256 st).[j <- v `^` (A101u64toA25u256 st).[j]]) st.[100].
proof.
move=> Hj; have G : forall (t: WArray808.t) k, t.[k] = WArray808.get8 t k by done.
apply Array101.tP => i Hi; rewrite /A25u256toA101u64 !Array101.initiE //= WArray808.get64E; apply W64.wordP => b Hb.
rewrite W8u8.pack8wE 1:// W8u8.Pack.initiE 1:/# /= G WArray808.get8_set256E 1,2:/#.
have B8 : forall k r, 0 <= k < 808 => 0 <= r < 8 => (WArray808.get8 (WArray808.init64 (fun i => st.[i])) k).[r] = st.[k %/ 8].[k %% 8 * 8 + r].
+ by move=> k r Hk Hr; rewrite /WArray808.get8 /WArray808.init64 WArray808.initiE //= W8u8.bits8iE.
have B256 : forall m c, 0 <= m < 25 => 0 <= c < 256 => (WArray808.get256 (WArray808.init64 (fun i => st.[i])) m).[c] = st.[4 * m + c %/ 64].[c %% 64].
+ by move=> m c Hm Hc; rewrite WArray808.get256E W32u8.pack32wE // W32u8.Pack.initiE 1:/# /= G B8 1,2:/#; congr; smt().
case: (32 * j <= 8 * i + b %/ 8 < 32 * (j + 1)) => C.
+ by rewrite ifT 1:/# Array25.get_setE 1:/# ifT 1:/# W32u8.bits8iE 1:/# W4u64.bits64iE 1:/# /A101u64toA25u256 Array25.initiE 1:/# /=; congr; smt().
rewrite B8 1,2:/# (: (8 * i + b %/ 8) %/ 8 = i) 1:/# (: (8 * i + b %/ 8) %% 8 = b %/ 8) 1:/# -divz_eq; case: (i < 100) => Ci /=; last by rewrite (: i = 100) /#.
by rewrite Array25.get_setE 1:/# ifF 1:/# W4u64.bits64iE 1:/# /A101u64toA25u256 Array25.initiE 1:/# /= B256 1,2:/#; congr; smt().
qed.

lemma A101_clear (X: state4x) s:
  Array101.init (WArray808.get64 (WArray808.set32_direct (WArray808.init64 (fun i => (A25u256toA101u64 X s).[i])) 800 (WArray808.get32_direct (WArray808.init64 (fun i => (A25u256toA101u64 X s).[i])) 800 `&` W32.of_int 4278255360)))
  = A25u256toA101u64 X (clear_at_trailb s).
proof.
apply Array101.tP => i Hi; rewrite Array101.initiE //= WArray808.get64E; apply W64.wordP => b Hb.
rewrite W8u8.pack8wE 1:// W8u8.Pack.initiE 1:/# /= /WArray808.set32_direct WArray808.initiE 1:/# /=.
case: (800 <= 8 * i + b %/ 8 < 804) => C /=; [rewrite /WArray808.get32_direct W4u8.pack4bE 1:/# W4u8.Pack.initiE 1:/# /= | ]; rewrite /WArray808.init64 WArray808.initiE 1:/# /=.
+ have -> /= : i = 100 by smt().
  rewrite (: (800 + b %/ 8) %/ 8 = 100) 1:/# (: (800 + b %/ 8) %% 8 = b %/ 8) 1:/# /A25u256toA101u64 !Array101.initiE //= W8u8.bits8iE 1:/# W4u8.bits8iE 1:/# -divz_eq /clear_at_trailb W64.andwE.
  congr; have : b \in iota_ 0 32 by rewrite mem_iota /#.
  move: b Hb C; rewrite -iotaredE /= => b _ _; rewrite W32.of_intwE W64.of_intwE /int_bit; by do 31! (case => [-> //= |]); move=> -> //=.
rewrite (: (8 * i + b %/ 8) %/ 8 = i) 1:/# (: (8 * i + b %/ 8) %% 8 = b %/ 8) 1:/# W8u8.bits8iE 1:/# -divz_eq /A25u256toA101u64 !Array101.initiE //=; case: (i < 100) => Ci //=.
rewrite /clear_at_trailb W64.andwE; have : b \in iota_ 32 32 by rewrite mem_iota /#.
move: b Hb C; rewrite -iotaredE /= => b _ _; rewrite W64.of_intwE /int_bit; by do 31! (case => [-> //= |]); move=> -> //=.
qed.

lemma ststatus_data_avx2x4P (s: W64.t):
  (s `>>` W8.of_int 8 `>>` W8.of_int 8) `&` W64.of_int 255 = zeroextu64 (ststatus_trailb s)
  /\ to_uint (if W64.of_int 200 \ult (s `>>` W8.of_int 8) `&` W64.of_int 255 + W64.one `<<` W8.of_int 3 then W64.of_int 200
              else (s `>>` W8.of_int 8) `&` W64.of_int 255 + W64.one `<<` W8.of_int 3) = ststatus_r8 s
  /\ to_uint (if (if W64.of_int 200 \ult (s `>>` W8.of_int 8) `&` W64.of_int 255 + W64.one `<<` W8.of_int 3 then W64.of_int 200
                  else (s `>>` W8.of_int 8) `&` W64.of_int 255 + W64.one `<<` W8.of_int 3) \ule s `&` W64.of_int 255 then W64.zero
              else s `&` W64.of_int 255) = ststatus_at_norm s.
proof.
have := ststatus_data_specE s; rewrite /ststatus_data_spec /= => [#] Et Er Ea; rewrite -Er -Ea.
split; first by rewrite -Et; apply W64.to_uint_eq; rewrite (W64.to_uint_and_mod 8) // !W64.shr_div_le // W8u8.to_uint_zeroextu64 W8.of_uintK /= -divzMr // modz_mod.
split; first rewrite /(\ult) of_uintK pmod_small 1:/# shl_shlw 1:/# to_uint_shl 1:/# (W64.and_mod 8) 1:/# shr_shrw 1:/# to_uintD_small.
+ by rewrite to_uint1 of_uintK to_uint_shr /#.
+ rewrite of_uintK to_uint_shr 1:/# to_uint1 !(pmod_small _ W64.modulus) ..3:/# -of_intD shlMP 1:/# /=.
  by case: (200 < (to_uint s %/ 256 %% 256 + 1) * 8) => C; rewrite of_uintK ?(pmod_small _ W64.modulus) /#.
rewrite /(\ult) /(\ule) of_uintK pmod_small 1:/# shl_shlw 1:/# to_uint_shl 1:/# (W64.and_mod 8) 1:/# shr_shrw 1:/# to_uintD_small; first by rewrite to_uint1 of_uintK to_uint_shr /#.
rewrite of_uintK to_uint_shr 1:/# to_uint1 (W64.and_mod 8) 1:/# of_uintK !(pmod_small _ W64.modulus) ..4:/# -of_intD shlMP 1:/# /=.
case: (200 < (to_uint s %/ 256 %% 256 + 1) * 8) => C; rewrite of_uintK (pmod_small _ W64.modulus) 1:/#.
+ by case: (200 <= to_uint s %% 256) => *; rewrite of_uintK /#.
by case: ((to_uint s %/ 256 %% 256 + 1) * 8 <= to_uint s %% 256) => *; rewrite of_uintK /#.
qed.

lemma truncateu64_VMOV_64 (x: W64.t): truncateu64 (VMOV_64 x) = x.
proof. by have := W2u64.bits64_div (VMOV_64 x) 0 _ => //=; rewrite /truncateu64 => <-; rewrite /VMOV_64 W2u64.pack2bE. qed.

lemma finish_updstate_avx2x4_ll: islossless M._finish_updstate_avx2x4.
proof. islossless. qed.

hoare finish_updstate_avx2x4_h _st:
  M._finish_updstate_avx2x4
  : st = _st
  ==> res = finish_updstate_avx2x4_spec _st.
proof.
proc; seq 2 : (st = _st /\ trailb = zeroextu64 (ststatus_trailb _st.[100]) /\ r8 = ststatus_r8 _st.[100] /\ at = ststatus_at_norm _st.[100]).
+ by inline *; auto => />; exact (ststatus_data_avx2x4P _st.[100]).
wp; skip => &hr [#] -> -> -> -> /=.
have S5 : forall x, (x `|>>` 3) `<<` 5 = 32 * (x %/ 8) by move=> x; rewrite /(`|>>`) /(`<<`) /= /#.
have E100 : forall X s, (A25u256toA101u64 X s).[100] = s by move=> X s; rewrite /A25u256toA101u64 Array101.initiE.
have [HA0 [HA1 [HR0 [HR1 HR8]]]] : 0 <= ststatus_at_norm _st.[100] /\ ststatus_at_norm _st.[100] < ststatus_r8 _st.[100]
                                   /\ 8 <= ststatus_r8 _st.[100] /\ ststatus_r8 _st.[100] <= 200 /\ ststatus_r8 _st.[100] %% 8 = 0.
+ by rewrite /ststatus_at_norm /ststatus_r8 /ststatus_at /=; smt(W64.to_uint_cmp).
rewrite !S5 (A101_xor256 _st (ststatus_at_norm _st.[100] %/ 8)) 1:/#.
rewrite (A101_xor256 _ ((ststatus_r8 _st.[100] - 1) %/ 8)) 1:/# A101u64toA25u256K E100 A101_clear /finish_updstate_avx2x4_spec ststatus_data_specE /=.
have T7 : truncateu8 (W64.of_int (ststatus_at_norm _st.[100])) `&` W8.of_int 7 = truncateu8 (W64.of_int (ststatus_at_norm _st.[100] %% 8)).
+ apply W8.to_uint_eq; rewrite (W8.to_uint_and_mod 3) // !to_uint_truncateu8 !W64.of_uintK.
  by rewrite !(modz_small _ ptr_modulus) 1,2:/# !(modz_small _ W8.modulus) 1,2:/#.
have W2 : W64.one `<<` W8.of_int 63 = W64.of_int (W8.to_uint (W8.of_int 128)) `<<` W8.of_int (8 * ((ststatus_r8 _st.[100] - 1) %% 8)).
+ by rewrite (: (ststatus_r8 _st.[100] - 1) %% 8 = 7) 1:/#; apply W64.to_uint_eq; rewrite !W64.to_uint_shl //=.
rewrite !truncateu64_VMOV_64 T7 trunc_shl3_and63 1:/# W2; congr; rewrite st4x_mapE -{1}st4x_unpackK /st4x_unpack /=; congr.
by rewrite !st4x_get_bcast 1..16:/# /xor_byte_at_st25 /zeroextu64.
qed.

phoare finish_updstate_avx2x4_ph _st:
  [ M._finish_updstate_avx2x4
  : st = _st
  ==> res = finish_updstate_avx2x4_spec _st
  ] = 1%r.
proof.
by conseq finish_updstate_avx2x4_ll (finish_updstate_avx2x4_h _st).
qed.


lemma st4x_eqP (a b: state4x):
  (forall k, 0 <= k < 4 => st4x_get a k = st4x_get b k) => a = b.
proof. by move=> H; rewrite -(st4x_unpackK a) -(st4x_unpackK b) /st4x_unpack (H 0) // (H 1) // (H 2) // (H 3). qed.

lemma updwn_xabs st0 at (l: W8.t list) n q (w: W64.t):
 0 <= q < 25 => 8 * q <= n <= 8 * q + 8 =>
 (forall r, 0 <= r < 8 => w \bits8 r = if n <= 8 * q + r then l.[8 * q + r - at] else W8.zero) =>
 (xabs st0 at l n).[q <- (xabs st0 at l n).[q] `^` w] = xabs st0 at l (8 * q + 8).
proof.
move=> Hq Hn Hw; rewrite setw_xor // -(xabs_win st0 at l n (8 * q) 8 (fun i => w \bits8 (i - 8 * q))) //.
by move=> i Hi /=; rewrite Hw 1:/# (: 8 * q + (i - 8 * q) = i) 1:/#.
qed.

op xabs4 (st: state4x) at (l0 l1 l2 l3: W8.t list) n : state4x =
 st4x_pack (xabs (st4x_get st 0) at l0 n, xabs (st4x_get st 1) at l1 n, xabs (st4x_get st 2) at l2 n, xabs (st4x_get st 3) at l3 n).

lemma xabs4_0 st at (l0 l1 l2 l3: W8.t list) n:
 n <= at => xabs4 st at l0 l1 l2 l3 n = st.
proof. by move=> Hn; rewrite /xabs4 !xabs0 //; exact (st4x_unpackK st). qed.

lemma xabs4_addstate_at st at (l0 l1 l2 l3: W8.t list) n:
 at + size l0 <= n => at + size l1 <= n => at + size l2 <= n => at + size l3 <= n =>
 xabs4 st at l0 l1 l2 l3 n
 = st4x_pack (addstate_at (st4x_get st 0) at l0, addstate_at (st4x_get st 1) at l1, addstate_at (st4x_get st 2) at l2, addstate_at (st4x_get st 3) at l3).
proof. by move=> H0 H1 H2 H3; rewrite /xabs4 !xabs_addstate_at. qed.

lemma xabs4_step (st0: state4x) at (l0 l1 l2 l3: W8.t list) n j (t0 t1 t2 t3: W64.t):
 0 <= j < 25 => 8 * j <= n <= 8 * j + 8 =>
 (forall r, 0 <= r < 8 => t0 \bits8 r = if n <= 8 * j + r then l0.[8 * j + r - at] else W8.zero) =>
 (forall r, 0 <= r < 8 => t1 \bits8 r = if n <= 8 * j + r then l1.[8 * j + r - at] else W8.zero) =>
 (forall r, 0 <= r < 8 => t2 \bits8 r = if n <= 8 * j + r then l2.[8 * j + r - at] else W8.zero) =>
 (forall r, 0 <= r < 8 => t3 \bits8 r = if n <= 8 * j + r then l3.[8 * j + r - at] else W8.zero) =>
 st4x_xor64 (st4x_xor64 (st4x_xor64 (st4x_xor64 (xabs4 st0 at l0 l1 l2 l3 n) (4 * j + 0) t0) (4 * j + 1) t1) (4 * j + 2) t2) (4 * j + 3) t3
 = xabs4 st0 at l0 l1 l2 l3 (8 * j + 8).
proof.
move=> Hj Hn H0 H1 H2 H3; apply st4x_eqP => k Hk; rewrite !st4x_get_xor64 //= /xabs4.
have : k = 0 \/ k = 1 \/ k = 2 \/ k = 3 by smt().
case => [->|[->|[->|->]]] /=.
+ by rewrite !st4x_get_pack0 /=; apply updwn_xabs.
+ by rewrite !st4x_get_pack1 /=; apply updwn_xabs.
+ by rewrite !st4x_get_pack2 /=; apply updwn_xabs.
by rewrite !st4x_get_pack3 /=; apply updwn_xabs.
qed.

lemma xabs4_step_bcast (st0: state4x) at (l: W8.t list) n j (t: W64.t):
 0 <= j < 25 => 8 * j <= n <= 8 * j + 8 =>
 (forall r, 0 <= r < 8 => t \bits8 r = if n <= 8 * j + r then l.[8 * j + r - at] else W8.zero) =>
 (xabs4 st0 at l l l l n).[j <- VPBROADCAST_4u64 t `^` (xabs4 st0 at l l l l n).[j]] = xabs4 st0 at l l l l (8 * j + 8).
proof.
move=> Hj Hn Ht; apply st4x_eqP => k Hk; rewrite st4x_get_bcast // /xabs4.
have : k = 0 \/ k = 1 \/ k = 2 \/ k = 3 by smt().
case => [->|[->|[->|->]]] /=.
+ by rewrite !st4x_get_pack0 /=; apply updwn_xabs.
+ by rewrite !st4x_get_pack1 /=; apply updwn_xabs.
+ by rewrite !st4x_get_pack2 /=; apply updwn_xabs.
by rewrite !st4x_get_pack3 /=; apply updwn_xabs.
qed.

lemma pabsorb_spec_avx2x4_block r8 l0 l1 l2 l3 (m0 m1 m2 m3: W8.t list) st:
  pabsorb_spec_avx2x4 r8 l0 l1 l2 l3 st =>
  size l0 %% r8 + size m0 = r8 => size m1 = size m0 => size m2 = size m0 => size m3 = size m0 =>
  pabsorb_spec_avx2x4 r8 (l0 ++ m0) (l1 ++ m1) (l2 ++ m2) (l3 ++ m3)
    (st4x_map keccak_f1600_op (st4x_pack (addstate_at (st4x_get st 0) (size l0 %% r8) m0, addstate_at (st4x_get st 1) (size l0 %% r8) m1,
                                          addstate_at (st4x_get st 2) (size l0 %% r8) m2, addstate_at (st4x_get st 3) (size l0 %% r8) m3))).
proof.
rewrite !pabsorb_spec_avx2x4P => [#] H1 H2 H3 P0 P1 P2 P3 Hs E1 E2 E3.
rewrite !size_cat H1 H2 H3 E1 E2 E3 /= !st4x_get_map // st4x_get_pack0 st4x_get_pack1 st4x_get_pack2 st4x_get_pack3 /=.
split; [exact (pabsorb_spec_ref_block _ _ _ _ P0 Hs) | split; [by rewrite -H1; apply (pabsorb_spec_ref_block _ _ _ _ P1); rewrite H1 E1 | split]].
+ by rewrite -H2; apply (pabsorb_spec_ref_block _ _ _ _ P2); rewrite H2 E2.
by rewrite -H3; apply (pabsorb_spec_ref_block _ _ _ _ P3); rewrite H3 E3.
qed.

lemma pabsorb_spec_avx2x4_add r8 l0 l1 l2 l3 (m0 m1 m2 m3: W8.t list) st:
  pabsorb_spec_avx2x4 r8 l0 l1 l2 l3 st =>
  size l0 %% r8 + size m0 < r8 => size m1 = size m0 => size m2 = size m0 => size m3 = size m0 =>
  pabsorb_spec_avx2x4 r8 (l0 ++ m0) (l1 ++ m1) (l2 ++ m2) (l3 ++ m3)
    (st4x_pack (addstate_at (st4x_get st 0) (size l0 %% r8) m0, addstate_at (st4x_get st 1) (size l0 %% r8) m1,
                addstate_at (st4x_get st 2) (size l0 %% r8) m2, addstate_at (st4x_get st 3) (size l0 %% r8) m3)).
proof.
rewrite !pabsorb_spec_avx2x4P => [#] H1 H2 H3 P0 P1 P2 P3 Hs E1 E2 E3.
rewrite !size_cat H1 H2 H3 E1 E2 E3 /= st4x_get_pack0 st4x_get_pack1 st4x_get_pack2 st4x_get_pack3 /=.
split; [exact (pabsorb_spec_ref_add _ _ _ _ P0 Hs) | split; [by rewrite -H1; apply (pabsorb_spec_ref_add _ _ _ _ P1); rewrite H1 E1 | split]].
+ by rewrite -H2; apply (pabsorb_spec_ref_add _ _ _ _ P2); rewrite H2 E2.
by rewrite -H3; apply (pabsorb_spec_ref_add _ _ _ _ P3); rewrite H3 E3.
qed.

lemma A101_set800 (stk: state4x) s (b: W8.t):
  Array101.init (WArray808.get64 (WArray808.init64 (fun i => (A25u256toA101u64 stk s).[i])).[800 <- b])
  = A25u256toA101u64 stk (W8u8.pack8_t (W8u8.Pack.init (fun j => if j = 0 then b else s \bits8 j))).
proof.
apply Array101.tP => i Hi; rewrite Array101.initiE //= WArray808.get64E; apply W64.wordP => c Hc.
rewrite W8u8.pack8wE 1:// W8u8.Pack.initiE 1:/# /= WArray808.get_setE 1:/#.
rewrite /A25u256toA101u64 Array101.initiE //=; case: (i < 100) => Ci /=.
+ rewrite ifF 1:/# /WArray808.init64 WArray808.initiE 1:/# /= Array101.initiE 1:/# /= (: (8 * i + c %/ 8) %/ 8 = i) 1:/# ifT 1:/# W8u8.bits8iE 1:/#.
  by congr; smt().
have Ei : i = 100 by smt().
rewrite Ei /= W8u8.pack8wE 1:// W8u8.Pack.initiE 1:/# /=; case: (c %/ 8 = 0) => C; first by rewrite C.
rewrite ifF 1:/# /WArray808.init64 WArray808.initiE 1:/# /= Array101.initiE 1:/# /= (: (800 + c %/ 8) %/ 8 = 100) 1:/# /= W8u8.bits8iE 1:/# W8u8.bits8iE 1:/#.
by congr; smt().
qed.

lemma st4x_get64d_bits8 (st: state4x) a k o r:
  0 <= a < 200 => a %% 8 = 0 => 0 <= k < 4 => o = 4 * a + 8 * k => 0 <= r < 8 =>
  WArray800.get64_direct (WArray800.init256 (fun i => st.[i])) o \bits8 r = (stbytes (st4x_get st k)).[a + r].
proof.
move=> Ha Ha8 Hk -> Hr; rewrite (: 4 * a + 8 * k = 32 * (a %/ 8) + 8 * k) 1:/# st4x_get64_direct 1,2:/# stbytes_st4x // 1:/#.
by rewrite (: (a + r) %/ 8 = a %/ 8) 1:/# (: (a + r) %% 8 = r) 1:/#.
qed.


abstract theory KeccakUpdstateAvx2x4.

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

module MM = {
  proc _ststatus_data_avx2x4 (ststatus:W64.t) : W64.t * int * int = {
    var trailb:W64.t;
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
    ststatus <- (ststatus `&` (W64.of_int 255));
    trailb <- ststatus;
    r8_ui <- (W64.to_uint r8);
    at_ui <- (W64.to_uint at);
    return (trailb, r8_ui, at_ui);
  }
  proc _add_updstate_avx2x4 (st:W256.t Array25.t, at:int,
                             buf0:W8.t A.t, buf1:W8.t A.t,
                             buf2:W8.t A.t, buf3:W8.t A.t,
                             off:int, upto:int) : int * int *
                                                  W256.t Array25.t = {
    var at8:W64.t;
    var shval:W8.t;
    var t64:W64.t;
    var sh:W8.t;
    var upto8:W64.t;
    var len:int;
    var off2:int;
    var newat:int;
    var  _0:int;
    var  _1:int;
    var  _2:int;
    var  _3:int;
    var  _4:int;
    var  _5:int;
    at8 <- (W64.of_int at);
    at8 <- (at8 `&` (W64.of_int 7));
    if ((at8 <> (W64.of_int 0))) {
      len <- upto;
      len <- (len - at);
      at <- (at `|>>` 3);
      at <- (at `<<` 3);
      shval <- (truncateu8 at8);
      shval <- (shval `<<` (W8.of_int 3));
      ( _0, t64) <@ RW.MM.__a_rlen_read_upto8 (buf0, off, len);
      sh <- shval;
      t64 <- (t64 `<<` (sh `&` (W8.of_int 63)));
      st <-
      (Array25.init
      (WArray800.get256
      (WArray800.set64_direct (WArray800.init256 (fun i => st.[i]))
      ((4 * at) + 0)
      ((get64_direct (WArray800.init256 (fun i => st.[i])) ((4 * at) + 0)) `^`
      t64))));
      ( _1, t64) <@ RW.MM.__a_rlen_read_upto8 (buf1, off, len);
      sh <- shval;
      t64 <- (t64 `<<` (sh `&` (W8.of_int 63)));
      st <-
      (Array25.init
      (WArray800.get256
      (WArray800.set64_direct (WArray800.init256 (fun i => st.[i]))
      ((4 * at) + 8)
      ((get64_direct (WArray800.init256 (fun i => st.[i])) ((4 * at) + 8)) `^`
      t64))));
      ( _2, t64) <@ RW.MM.__a_rlen_read_upto8 (buf2, off, len);
      sh <- shval;
      t64 <- (t64 `<<` (sh `&` (W8.of_int 63)));
      st <-
      (Array25.init
      (WArray800.get256
      (WArray800.set64_direct (WArray800.init256 (fun i => st.[i]))
      ((4 * at) + 16)
      ((get64_direct (WArray800.init256 (fun i => st.[i])) ((4 * at) + 16)) `^`
      t64))));
      (off2, t64) <@ RW.MM.__a_rlen_read_upto8 (buf3, off, len);
      sh <- shval;
      t64 <- (t64 `<<` (sh `&` (W8.of_int 63)));
      st <-
      (Array25.init
      (WArray800.get256
      (WArray800.set64_direct (WArray800.init256 (fun i => st.[i]))
      ((4 * at) + 24)
      ((get64_direct (WArray800.init256 (fun i => st.[i])) ((4 * at) + 24)) `^`
      t64))));
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
    newat <- (newat + 8);
    while ((newat <= upto)) {
      t64 <- (get64_direct (WA.init8 (fun i => buf0.[i])) off);
      st <-
      (Array25.init
      (WArray800.get256
      (WArray800.set64_direct (WArray800.init256 (fun i => st.[i]))
      ((4 * at) + 0)
      ((get64_direct (WArray800.init256 (fun i => st.[i])) ((4 * at) + 0)) `^`
      t64))));
      t64 <- (get64_direct (WA.init8 (fun i => buf1.[i])) off);
      st <-
      (Array25.init
      (WArray800.get256
      (WArray800.set64_direct (WArray800.init256 (fun i => st.[i]))
      ((4 * at) + 8)
      ((get64_direct (WArray800.init256 (fun i => st.[i])) ((4 * at) + 8)) `^`
      t64))));
      t64 <- (get64_direct (WA.init8 (fun i => buf2.[i])) off);
      st <-
      (Array25.init
      (WArray800.get256
      (WArray800.set64_direct (WArray800.init256 (fun i => st.[i]))
      ((4 * at) + 16)
      ((get64_direct (WArray800.init256 (fun i => st.[i])) ((4 * at) + 16)) `^`
      t64))));
      t64 <- (get64_direct (WA.init8 (fun i => buf3.[i])) off);
      st <-
      (Array25.init
      (WArray800.get256
      (WArray800.set64_direct (WArray800.init256 (fun i => st.[i]))
      ((4 * at) + 24)
      ((get64_direct (WArray800.init256 (fun i => st.[i])) ((4 * at) + 24)) `^`
      t64))));
      at <- newat;
      off <- (off + 8);
      newat <- (newat + 8);
    }
    if ((at < upto)) {
      upto8 <- (W64.of_int upto);
      upto8 <- (upto8 `&` (W64.of_int 7));
      ( _3, t64) <@ RW.MM.__a_rlen_read_upto8 (buf0, off, (W64.to_uint upto8));
      st <-
      (Array25.init
      (WArray800.get256
      (WArray800.set64_direct (WArray800.init256 (fun i => st.[i]))
      ((4 * at) + 0)
      ((get64_direct (WArray800.init256 (fun i => st.[i])) ((4 * at) + 0)) `^`
      t64))));
      ( _4, t64) <@ RW.MM.__a_rlen_read_upto8 (buf1, off, (W64.to_uint upto8));
      st <-
      (Array25.init
      (WArray800.get256
      (WArray800.set64_direct (WArray800.init256 (fun i => st.[i]))
      ((4 * at) + 8)
      ((get64_direct (WArray800.init256 (fun i => st.[i])) ((4 * at) + 8)) `^`
      t64))));
      ( _5, t64) <@ RW.MM.__a_rlen_read_upto8 (buf2, off, (W64.to_uint upto8));
      st <-
      (Array25.init
      (WArray800.get256
      (WArray800.set64_direct (WArray800.init256 (fun i => st.[i]))
      ((4 * at) + 16)
      ((get64_direct (WArray800.init256 (fun i => st.[i])) ((4 * at) + 16)) `^`
      t64))));
      (off, t64) <@ RW.MM.__a_rlen_read_upto8 (buf3, off, (W64.to_uint upto8));
      st <-
      (Array25.init
      (WArray800.get256
      (WArray800.set64_direct (WArray800.init256 (fun i => st.[i]))
      ((4 * at) + 24)
      ((get64_direct (WArray800.init256 (fun i => st.[i])) ((4 * at) + 24)) `^`
      t64))));
    } else {
      
    }
    at <- upto;
    return (at, off, st);
  }
  proc _add_bcast_updstate_avx2x4 (st:W256.t Array25.t, at:int,
                                   buf:W8.t A.t, off:int, upto:int) : 
  int * int * W256.t Array25.t = {
    var at8:W64.t;
    var t64:W64.t;
    var sh:W8.t;
    var t128:W128.t;
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
      t128 <- (VMOV_64 t64);
      t256 <- (VPBROADCAST_4u64 (truncateu64 t128));
      t256 <-
      (t256 `^`
      (get256_direct (WArray800.init256 (fun i => st.[i])) ((4 * at) + 0)));
      st <-
      (Array25.init
      (WArray800.get256
      (WArray800.set256_direct (WArray800.init256 (fun i => st.[i]))
      ((4 * at) + 0) t256)));
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
    newat <- (newat + 8);
    while ((newat <= upto)) {
      t256 <-
      (VPBROADCAST_4u64
      (get64_direct (WA.init8 (fun i => buf.[i])) off));
      t256 <-
      (t256 `^`
      (get256_direct (WArray800.init256 (fun i => st.[i])) (4 * at)));
      st <-
      (Array25.init
      (WArray800.get256
      (WArray800.set256_direct (WArray800.init256 (fun i => st.[i])) 
      (4 * at) t256)));
      at <- newat;
      off <- (off + 8);
      newat <- (newat + 8);
    }
    if ((at < upto)) {
      upto8 <- (W64.of_int upto);
      upto8 <- (upto8 `&` (W64.of_int 7));
      (off, t64) <@ RW.MM.__a_rlen_read_upto8 (buf, off, (W64.to_uint upto8));
      t128 <- (VMOV_64 t64);
      t256 <- (VPBROADCAST_4u64 (truncateu64 t128));
      t256 <-
      (t256 `^`
      (get256_direct (WArray800.init256 (fun i => st.[i])) (4 * at)));
      st <-
      (Array25.init
      (WArray800.get256
      (WArray800.set256_direct (WArray800.init256 (fun i => st.[i])) 
      (4 * at) t256)));
    } else {
      
    }
    at <- upto;
    return (at, off, st);
  }
  proc _absorb_updstate_avx2x4 (st:W64.t Array101.t, buf0:W8.t A.t,
                                buf1:W8.t A.t, buf2:W8.t A.t,
                                buf3:W8.t A.t, len:int) : W64.t Array101.t = {
    var ststatus:W64.t;
    var stk:W256.t Array25.t;
    var r8:int;
    var at:int;
    var off:int;
    var  _0:W64.t;
    var  _1:int;
    stk <- witness;
    ststatus <- st.[(4 * 25)];
    ( _0, r8, at) <@ _ststatus_data_avx2x4 (ststatus);
    stk <-
    (Array25.init
    (fun i => (get256 (WArray808.init64 (fun i => st.[i])) (0 + i))));
    (* Erased call to spill *)
    off <- 0;
    len <- (len + at);
    while ((r8 <= len)) {
      (* Erased call to spill *)
      (at, off, stk) <@ _add_updstate_avx2x4 (stk, at, buf0, buf1, buf2,
      buf3, off, r8);
      (* Erased call to unspill *)
      stk <@ M._keccakf1600_avx2x4 (stk);
      len <- (len - r8);
      at <- 0;
    }
    len <- len;
    (at,  _1, stk) <@ _add_updstate_avx2x4 (stk, at, buf0, buf1, buf2, 
    buf3, off, len);
    (* Erased call to unspill *)
    st <-
    (Array101.init
    (WArray808.get64
    (WArray808.init8
    (fun i => (if ((32 * 0) <= i < ((32 * 0) + 800)) then (WArray800.get8
                                                          (WArray800.init256
                                                          (fun i => stk.[i]))
                                                          (i - (32 * 0))) else 
              (WArray808.get8 (WArray808.init64 (fun i => st.[i])) i)))
    )));
    st <-
    (Array101.init
    (WArray808.get64
    (WArray808.set8_direct (WArray808.init64 (fun i => st.[i])) (32 * 25)
    (truncateu8 (W64.of_int at)))));
    return st;
  }
  proc _absorb_bcast_updstate_avx2x4 (st:W64.t Array101.t,
                                      buf:W8.t A.t, len:int) : 
  W64.t Array101.t = {
    var ststatus:W64.t;
    var stk:W256.t Array25.t;
    var r8:int;
    var at:int;
    var off:int;
    var  _0:W64.t;
    var  _1:int;
    stk <- witness;
    ststatus <- st.[(4 * 25)];
    ( _0, r8, at) <@ _ststatus_data_avx2x4 (ststatus);
    stk <-
    (Array25.init
    (fun i => (get256 (WArray808.init64 (fun i => st.[i])) (0 + i))));
    off <- 0;
    len <- (len + at);
    while ((r8 <= len)) {
      (at, off, stk) <@ _add_bcast_updstate_avx2x4 (stk, at, buf, off, r8);
      stk <@ M._keccakf1600_avx2x4 (stk);
      len <- (len - r8);
      at <- 0;
    }
    len <- len;
    (at,  _1, stk) <@ _add_bcast_updstate_avx2x4 (stk, at, buf, off, len);
    st <-
    (Array101.init
    (WArray808.get64
    (WArray808.init8
    (fun i => (if ((32 * 0) <= i < ((32 * 0) + 800)) then (WArray800.get8
                                                          (WArray800.init256
                                                          (fun i => stk.[i]))
                                                          (i - (32 * 0))) else 
              (WArray808.get8 (WArray808.init64 (fun i => st.[i])) i)))
    )));
    st <-
    (Array101.init
    (WArray808.get64
    (WArray808.set8_direct (WArray808.init64 (fun i => st.[i])) (32 * 25)
    (truncateu8 (W64.of_int at)))));
    return st;
  }
  proc _dump_updstate_avx2x4 (buf0:W8.t A.t, buf1:W8.t A.t,
                              buf2:W8.t A.t, buf3:W8.t A.t,
                              off:int, st:W256.t Array25.t, at:int, upto:int) : 
  int * int * W8.t A.t * W8.t A.t * W8.t A.t *
  W8.t A.t = {
    var at8:W64.t;
    var sh:W8.t;
    var t64:W64.t;
    var upto8:W64.t;
    var len:int;
    var off2:int;
    var newat:int;
    var  _0:int;
    var  _1:int;
    var  _2:int;
    var  _3:int;
    var  _4:int;
    var  _5:int;
    at8 <- (W64.of_int at);
    at8 <- (at8 `&` (W64.of_int 7));
    if ((at8 <> (W64.of_int 0))) {
      len <- upto;
      len <- (len - at);
      at <- (at `|>>` 3);
      at <- (at `<<` 3);
      sh <- (truncateu8 at8);
      sh <- (sh `<<` (W8.of_int 3));
      t64 <-
      (get64_direct (WArray800.init256 (fun i => st.[i])) ((4 * at) + 0));
      t64 <- (t64 `>>` (sh `&` (W8.of_int 63)));
      (buf0,  _0) <@ RW.MM.__a_rlen_write_upto8 (buf0, off, t64, len);
      t64 <-
      (get64_direct (WArray800.init256 (fun i => st.[i])) ((4 * at) + 8));
      t64 <- (t64 `>>` (sh `&` (W8.of_int 63)));
      (buf1,  _1) <@ RW.MM.__a_rlen_write_upto8 (buf1, off, t64, len);
      t64 <-
      (get64_direct (WArray800.init256 (fun i => st.[i])) ((4 * at) + 16));
      t64 <- (t64 `>>` (sh `&` (W8.of_int 63)));
      (buf2,  _2) <@ RW.MM.__a_rlen_write_upto8 (buf2, off, t64, len);
      t64 <-
      (get64_direct (WArray800.init256 (fun i => st.[i])) ((4 * at) + 24));
      t64 <- (t64 `>>` (sh `&` (W8.of_int 63)));
      (buf3, off2) <@ RW.MM.__a_rlen_write_upto8 (buf3, off, t64, len);
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
    newat <- (newat + 8);
    while ((newat <= upto)) {
      t64 <-
      (get64_direct (WArray800.init256 (fun i => st.[i])) ((4 * at) + 0));
      buf0 <-
      (A.init
      (WA.get8
      (WA.set64_direct (WA.init8 (fun i => buf0.[i])) off t64))
      );
      t64 <-
      (get64_direct (WArray800.init256 (fun i => st.[i])) ((4 * at) + 8));
      buf1 <-
      (A.init
      (WA.get8
      (WA.set64_direct (WA.init8 (fun i => buf1.[i])) off t64))
      );
      t64 <-
      (get64_direct (WArray800.init256 (fun i => st.[i])) ((4 * at) + 16));
      buf2 <-
      (A.init
      (WA.get8
      (WA.set64_direct (WA.init8 (fun i => buf2.[i])) off t64))
      );
      t64 <-
      (get64_direct (WArray800.init256 (fun i => st.[i])) ((4 * at) + 24));
      buf3 <-
      (A.init
      (WA.get8
      (WA.set64_direct (WA.init8 (fun i => buf3.[i])) off t64))
      );
      at <- newat;
      off <- (off + 8);
      newat <- (newat + 8);
    }
    if ((at < upto)) {
      upto8 <- (W64.of_int upto);
      upto8 <- (upto8 `&` (W64.of_int 7));
      t64 <-
      (get64_direct (WArray800.init256 (fun i => st.[i])) ((4 * at) + 0));
      (buf0,  _3) <@ RW.MM.__a_rlen_write_upto8 (buf0, off, t64,
      (W64.to_uint upto8));
      t64 <-
      (get64_direct (WArray800.init256 (fun i => st.[i])) ((4 * at) + 8));
      (buf1,  _4) <@ RW.MM.__a_rlen_write_upto8 (buf1, off, t64,
      (W64.to_uint upto8));
      t64 <-
      (get64_direct (WArray800.init256 (fun i => st.[i])) ((4 * at) + 16));
      (buf2,  _5) <@ RW.MM.__a_rlen_write_upto8 (buf2, off, t64,
      (W64.to_uint upto8));
      t64 <-
      (get64_direct (WArray800.init256 (fun i => st.[i])) ((4 * at) + 24));
      (buf3, off) <@ RW.MM.__a_rlen_write_upto8 (buf3, off, t64,
      (W64.to_uint upto8));
    } else {
      
    }
    at <- upto;
    return (at, off, buf0, buf1, buf2, buf3);
  }
  proc _squeeze_updstate_avx2x4 (st:W64.t Array101.t, buf0:W8.t A.t,
                                 buf1:W8.t A.t, buf2:W8.t A.t,
                                 buf3:W8.t A.t, len:int) : W64.t Array101.t *
                                                                  W8.t A.t *
                                                                  W8.t A.t *
                                                                  W8.t A.t *
                                                                  W8.t A.t = {
    var ststatus:W64.t;
    var stk:W256.t Array25.t;
    var r8:int;
    var at:int;
    var off:int;
    var  _0:W64.t;
    var  _1:int;
    stk <- witness;
    ststatus <- st.[(4 * 25)];
    ( _0, r8, at) <@ _ststatus_data_avx2x4 (ststatus);
    stk <-
    (Array25.init
    (fun i => (get256 (WArray808.init64 (fun i => st.[i])) (0 + i))));
    if ((at = 0)) {
      stk <@ M._keccakf1600_avx2x4 (stk);
    } else {
      
    }
    off <- 0;
    len <- (len + at);
    while ((r8 < len)) {
      (at, off, buf0, buf1, buf2, buf3) <@ _dump_updstate_avx2x4 (buf0, 
      buf1, buf2, buf3, off, stk, at, r8);
      stk <@ M._keccakf1600_avx2x4 (stk);
      len <- (len - r8);
      at <- 0;
    }
    len <- len;
    (at,  _1, buf0, buf1, buf2, buf3) <@ _dump_updstate_avx2x4 (buf0, 
    buf1, buf2, buf3, off, stk, at, len);
    st <-
    (Array101.init
    (WArray808.get64
    (WArray808.init8
    (fun i => (if ((32 * 0) <= i < ((32 * 0) + 800)) then (WArray800.get8
                                                          (WArray800.init256
                                                          (fun i => stk.[i]))
                                                          (i - (32 * 0))) else 
              (WArray808.get8 (WArray808.init64 (fun i => st.[i])) i)))
    )));
    st <-
    (Array101.init
    (WArray808.get64
    (WArray808.set8_direct (WArray808.init64 (fun i => st.[i])) (32 * 25)
    (truncateu8 (W64.of_int at)))));
    return (st, buf0, buf1, buf2, buf3);
  }
}.

lemma ststatus_data_avx2x4_ll: islossless MM._ststatus_data_avx2x4.
proof. islossless. qed.

hoare ststatus_data_avx2x4_h _s:
  MM._ststatus_data_avx2x4
  : ststatus = _s
  ==> res = (zeroextu64 (ststatus_trailb _s), ststatus_r8 _s, ststatus_at_norm _s).
proof. by proc; auto => />; exact (ststatus_data_avx2x4P _s). qed.

phoare ststatus_data_avx2x4_ph _s:
  [ MM._ststatus_data_avx2x4
  : ststatus = _s
  ==> res = (zeroextu64 (ststatus_trailb _s), ststatus_r8 _s, ststatus_at_norm _s)
  ] = 1%r.
proof. by conseq ststatus_data_avx2x4_ll (ststatus_data_avx2x4_h _s). qed.

hoare ststatus_data_avx2x4_r8_h: MM._ststatus_data_avx2x4 : true ==> 1 <= res.`2.
proof. by proc; auto => /> &hr; have [_ [-> _]] := ststatus_data_avx2x4P ststatus{hr}; rewrite /ststatus_r8 /=; smt(W64.to_uint_cmp). qed.


(* -----------------------------------------------------------------------
   Correctness of _add_updstate_avx2x4:
   XORs bufk[off..off+(upto-at)-1] into lane k at byte position `at`.
   ----------------------------------------------------------------------- *)

lemma add_updstate_avx2x4_ll: islossless MM._add_updstate_avx2x4.
proof.
proc; seq 3 : true => //; first by sp; if; [wp; do 4! (call RW.a_rlen_read_upto8_ll; wp); auto | auto].
seq 3 : true => //; first by wp; while true (upto + 8 - newat); [move=> z; auto => /# | auto => /#].
by wp; if; [wp; do 4! (call RW.a_rlen_read_upto8_ll; wp); auto | auto].
qed.

hoare add_updstate_avx2x4_h _st _at _b0 _b1 _b2 _b3 _off _upto:
  MM._add_updstate_avx2x4
  : st = _st /\ at = _at /\ buf0 = _b0 /\ buf1 = _b1 /\ buf2 = _b2 /\ buf3 = _b3
    /\ off = _off /\ upto = _upto
    /\ 0 <= _at <= _upto /\ _upto <= 200
    /\ 0 <= _off /\ _off + (_upto - _at) <= _ASIZE
  ==> res.`3 = st4x_pack ( addstate_at (st4x_get _st 0) _at (sub _b0 _off (_upto - _at))
                         , addstate_at (st4x_get _st 1) _at (sub _b1 _off (_upto - _at))
                         , addstate_at (st4x_get _st 2) _at (sub _b2 _off (_upto - _at))
                         , addstate_at (st4x_get _st 3) _at (sub _b3 _off (_upto - _at)))
    /\ res.`1 = _upto
    /\ res.`2 = _off + (_upto - _at).
proof.
proc => /=; pose L0 := sub _b0 _off (_upto - _at); pose L1 := sub _b1 _off (_upto - _at); pose L2 := sub _b2 _off (_upto - _at); pose L3 := sub _b3 _off (_upto - _at).
seq 2 : (#pre /\ W64.to_uint at8 = _at %% 8); first by auto => /> H0 H1 H2 H3 H4; rewrite (W64.to_uint_and_mod 3) // W64.of_uintK; smt(modz_small pow2_64).
seq 1 : (st = xabs4 _st _at L0 L1 L2 L3 at /\ off = _off + (at - _at) /\ _at <= at <= _upto /\ (at %% 8 = 0 \/ at = _upto)
         /\ buf0 = _b0 /\ buf1 = _b1 /\ buf2 = _b2 /\ buf3 = _b3 /\ upto = _upto /\ 0 <= _at /\ _upto <= 200 /\ 0 <= _off /\ _off + (_upto - _at) <= _ASIZE).
+ if; last first; first by skip => /> &hr H1 H2 H3 H4 H5; rewrite xabs4_0 //; left; rewrite -H5.
  wp; ecall (a_rlen_read_upto8_h buf3 off len); wp; ecall (a_rlen_read_upto8_h buf2 off len); wp; ecall (a_rlen_read_upto8_h buf1 off len); wp; ecall (a_rlen_read_upto8_h buf0 off len).
  wp; skip => /> &hr H0 H1 H2 H3 H4 Hk Hnz.
  have Ea8 : at8{hr} = W64.of_int (_at %% 8) by rewrite -Hk W64.to_uintK.
  have Hk0 : _at %% 8 <> 0 by move: Hnz; rewrite Ea8; apply contra => ->.
  have U : forall (t: W64.t) (L: W8.t list), size L = _upto - _at => srspec (u64bytes t) 0 0 L (_upto - _at) 0 =>
           forall r, 0 <= r < 8 => (t `<<` W8.of_int (8 * (_at %% 8))) \bits8 r = if _at <= 8 * (_at %/ 8) + r then L.[8 * (_at %/ 8) + r - _at] else W8.zero.
  + move=> t L HsL Hs r Hr; have B := srspec_u64_bits8 t L (_upto - _at) _ HsL Hs; first smt().
    rewrite W64.shl_shlw 1:/# bits8_u64_shl8 //.
    by case: (r < _at %% 8) => C; [rewrite ifF 1:/# | rewrite ifT 1:/# B 1:/#; congr; smt()].
  rewrite Hk shr3_shl3 Ea8 trunc_shl3_and63 1:/#; split; first smt().
  move=> _ r0 Hs0 Ho0 r1 Hs1 Ho1 r2 Hs2 Ho2 r3 Hs3 Ho3.
  rewrite (: 4 * (8 * (_at %/ 8)) + 8 = 8 * (4 * (_at %/ 8) + 1)) 1:/# (: 4 * (8 * (_at %/ 8)) + 16 = 8 * (4 * (_at %/ 8) + 2)) 1:/#.
  rewrite (: 4 * (8 * (_at %/ 8)) + 24 = 8 * (4 * (_at %/ 8) + 3)) 1:/# (: 4 * (8 * (_at %/ 8)) = 8 * (4 * (_at %/ 8) + 0)) 1:/#.
  have E := xabs4_step _st _at L0 L1 L2 L3 _at (_at %/ 8) (r0.`2 `<<` W8.of_int (8 * (_at %% 8))) (r1.`2 `<<` W8.of_int (8 * (_at %% 8)))
                       (r2.`2 `<<` W8.of_int (8 * (_at %% 8))) (r3.`2 `<<` W8.of_int (8 * (_at %% 8))) _ _ _ _ _ _; 1,2: smt().
  + by apply U; [rewrite size_sub /# | done].
  + by apply U; [rewrite size_sub /# | done].
  + by apply U; [rewrite size_sub /# | done].
  + by apply U; [rewrite size_sub /# | done].
  rewrite xabs4_0 // in E; rewrite E.
  have SL : forall (b: W8.t A.t), size (sub b _off (_upto - _at)) = _upto - _at by move=> b; rewrite size_sub /#.
  split; first by move=> C; smt().
  move=> C; rewrite (xabs4_addstate_at _ _ _ _ _ _ (8 * (_at %/ 8) + 8)) 1..4:/L0 1..4:/L1 1..4:/L2 1..4:/L3 1..4:SL 1..4:/#.
  by rewrite (xabs4_addstate_at _ _ _ _ _ _ _upto) 1..4:/L0 1..4:/L1 1..4:/L2 1..4:/L3 1..4:SL 1..4:/#; smt().
seq 3 : (st = xabs4 _st _at L0 L1 L2 L3 at /\ off = _off + (at - _at) /\ _at <= at <= _upto /\ (at %% 8 = 0 \/ at = _upto) /\ _upto < at + 8
         /\ buf0 = _b0 /\ buf1 = _b1 /\ buf2 = _b2 /\ buf3 = _b3 /\ upto = _upto /\ 0 <= _at /\ _upto <= 200 /\ 0 <= _off /\ _off + (_upto - _at) <= _ASIZE).
+ while (st = xabs4 _st _at L0 L1 L2 L3 at /\ newat = at + 8 /\ off = _off + (at - _at) /\ _at <= at <= _upto /\ (at %% 8 = 0 \/ at = _upto)
         /\ buf0 = _b0 /\ buf1 = _b1 /\ buf2 = _b2 /\ buf3 = _b3 /\ upto = _upto /\ 0 <= _at /\ _upto <= 200 /\ 0 <= _off /\ _off + (_upto - _at) <= _ASIZE); last by auto => /#.
  wp; skip => &hr [#] Est En Eo Ha0 Ha1 Ha8 -> -> -> -> -> H0 H1 H2 H3 Hc /=.
  have A8 : at{hr} %% 8 = 0 by smt().
  rewrite (: 4 * at{hr} + 8 = 8 * (4 * (at{hr} %/ 8) + 1)) 1:/# (: 4 * at{hr} + 16 = 8 * (4 * (at{hr} %/ 8) + 2)) 1:/#.
  rewrite (: 4 * at{hr} + 24 = 8 * (4 * (at{hr} %/ 8) + 3)) 1:/# (: 4 * at{hr} = 8 * (4 * (at{hr} %/ 8) + 0)) 1:/# Est.
  have E := xabs4_step _st _at L0 L1 L2 L3 at{hr} (at{hr} %/ 8) (WA.get64_direct (WA.init8 (fun i => _b0.[i])) off{hr}) (WA.get64_direct (WA.init8 (fun i => _b1.[i])) off{hr})
                       (WA.get64_direct (WA.init8 (fun i => _b2.[i])) off{hr}) (WA.get64_direct (WA.init8 (fun i => _b3.[i])) off{hr}) _ _ _ _ _ _; 1,2: smt().
  + by move=> r Hr; rewrite (wget64_bits8 (fun i => _b0.[i])) 1,2:/# /= ifT 1:/# /L0 nth_sub 1:/# Eo; congr; smt().
  + by move=> r Hr; rewrite (wget64_bits8 (fun i => _b1.[i])) 1,2:/# /= ifT 1:/# /L1 nth_sub 1:/# Eo; congr; smt().
  + by move=> r Hr; rewrite (wget64_bits8 (fun i => _b2.[i])) 1,2:/# /= ifT 1:/# /L2 nth_sub 1:/# Eo; congr; smt().
  + by move=> r Hr; rewrite (wget64_bits8 (fun i => _b3.[i])) 1,2:/# /= ifT 1:/# /L3 nth_sub 1:/# Eo; congr; smt().
  by rewrite E (: 8 * (at{hr} %/ 8) + 8 = at{hr} + 8) 1:/# En /=; smt().
if; last first.
+ wp; skip => &hr [#] -> -> Ha0 Ha1 Ha8 Hlt _ _ _ _ -> H0 H1 H2 H3 Hc /=.
  have SL : forall (b: W8.t A.t), size (sub b _off (_upto - _at)) = _upto - _at by move=> b; rewrite size_sub /#.
  by rewrite xabs4_addstate_at 1..4:/L0 1..4:/L1 1..4:/L2 1..4:/L3 1..4:SL 1..4:/#; smt().
wp; ecall (a_rlen_read_upto8_h buf3 off (W64.to_uint upto8)); wp; ecall (a_rlen_read_upto8_h buf2 off (W64.to_uint upto8)).
wp; ecall (a_rlen_read_upto8_h buf1 off (W64.to_uint upto8)); wp; ecall (a_rlen_read_upto8_h buf0 off (W64.to_uint upto8)).
wp; skip => &hr [#] Est Eo Ha0 Ha1 Ha8 Hlt -> -> -> -> -> H0 H1 H2 H3 Hc /=.
have Eu : W64.to_uint (W64.of_int _upto `&` W64.of_int 7) = _upto - at{hr} by rewrite (W64.to_uint_and_mod 3) // W64.of_uintK; smt(modz_small pow2_64).
rewrite Eu; split; [smt() | move=> _ r0 [Hs0 _]]; split; [smt() | move=> _ r1 [Hs1 _]]; split; [smt() | move=> _ r2 [Hs2 _]]; split; [smt() | move=> _ r3 [Hs3 ->]].
have A8 : at{hr} %% 8 = 0 by smt().
rewrite (: 4 * at{hr} + 8 = 8 * (4 * (at{hr} %/ 8) + 1)) 1:/# (: 4 * at{hr} + 16 = 8 * (4 * (at{hr} %/ 8) + 2)) 1:/#.
rewrite (: 4 * at{hr} + 24 = 8 * (4 * (at{hr} %/ 8) + 3)) 1:/# (: 4 * at{hr} = 8 * (4 * (at{hr} %/ 8) + 0)) 1:/# Est.
have E := xabs4_step _st _at L0 L1 L2 L3 at{hr} (at{hr} %/ 8) r0.`2 r1.`2 r2.`2 r3.`2 _ _ _ _ _ _; 1,2: smt().
+ move=> r Hr; have B := srspec_u64_bits8 r0.`2 _ _ _ _ Hs0; 1,2: rewrite ?size_sub /#.
  rewrite B // ifT 1:/#; case: (r < _upto - at{hr}) => C; [by rewrite /L0 !nth_sub 1,2:/# Eo; congr; smt() | by rewrite !nth_out ?size_sub /#].
+ move=> r Hr; have B := srspec_u64_bits8 r1.`2 _ _ _ _ Hs1; 1,2: rewrite ?size_sub /#.
  rewrite B // ifT 1:/#; case: (r < _upto - at{hr}) => C; [by rewrite /L1 !nth_sub 1,2:/# Eo; congr; smt() | by rewrite !nth_out ?size_sub /#].
+ move=> r Hr; have B := srspec_u64_bits8 r2.`2 _ _ _ _ Hs2; 1,2: rewrite ?size_sub /#.
  rewrite B // ifT 1:/#; case: (r < _upto - at{hr}) => C; [by rewrite /L2 !nth_sub 1,2:/# Eo; congr; smt() | by rewrite !nth_out ?size_sub /#].
+ move=> r Hr; have B := srspec_u64_bits8 r3.`2 _ _ _ _ Hs3; 1,2: rewrite ?size_sub /#.
  rewrite B // ifT 1:/#; case: (r < _upto - at{hr}) => C; [by rewrite /L3 !nth_sub 1,2:/# Eo; congr; smt() | by rewrite !nth_out ?size_sub /#].
have SL : forall (b: W8.t A.t), size (sub b _off (_upto - _at)) = _upto - _at by move=> b; rewrite size_sub /#.
by rewrite E xabs4_addstate_at 1..4:/L0 1..4:/L1 1..4:/L2 1..4:/L3 1..4:SL 1..4:/#; smt().
qed.

phoare add_updstate_avx2x4_ph _st _at _b0 _b1 _b2 _b3 _off _upto:
  [ MM._add_updstate_avx2x4
  : st = _st /\ at = _at /\ buf0 = _b0 /\ buf1 = _b1 /\ buf2 = _b2 /\ buf3 = _b3
    /\ off = _off /\ upto = _upto
    /\ 0 <= _at <= _upto /\ _upto <= 200
    /\ 0 <= _off /\ _off + (_upto - _at) <= _ASIZE
  ==> res.`3 = st4x_pack ( addstate_at (st4x_get _st 0) _at (sub _b0 _off (_upto - _at))
                         , addstate_at (st4x_get _st 1) _at (sub _b1 _off (_upto - _at))
                         , addstate_at (st4x_get _st 2) _at (sub _b2 _off (_upto - _at))
                         , addstate_at (st4x_get _st 3) _at (sub _b3 _off (_upto - _at)))
    /\ res.`1 = _upto
    /\ res.`2 = _off + (_upto - _at)
  ] = 1%r.
proof.
by conseq add_updstate_avx2x4_ll
       (add_updstate_avx2x4_h _st _at _b0 _b1 _b2 _b3 _off _upto).
qed.


(* -----------------------------------------------------------------------
   Correctness of _add_bcast_updstate_avx2x4:
   XORs buf[off..off+(upto-at)-1] into all four lanes at byte position `at`.
   ----------------------------------------------------------------------- *)

lemma add_bcast_updstate_avx2x4_ll: islossless MM._add_bcast_updstate_avx2x4.
proof.
proc; seq 3 : true => //; first by sp; if; [wp; call RW.a_rlen_read_upto8_ll; wp; auto | auto].
seq 3 : true => //; first by wp; while true (upto + 8 - newat); [move=> z; auto => /# | auto => /#].
by wp; if; [wp; call RW.a_rlen_read_upto8_ll; wp; auto | auto].
qed.

hoare add_bcast_updstate_avx2x4_h _st _at _buf _off _upto:
  MM._add_bcast_updstate_avx2x4
  : st = _st /\ at = _at /\ buf = _buf /\ off = _off /\ upto = _upto
    /\ 0 <= _at <= _upto /\ _upto <= 200
    /\ 0 <= _off /\ _off + (_upto - _at) <= _ASIZE
  ==> res.`3 = st4x_map (fun s => addstate_at s _at (sub _buf _off (_upto - _at))) _st
    /\ res.`1 = _upto
    /\ res.`2 = _off + (_upto - _at).
proof.
proc => /=; pose L := sub _buf _off (_upto - _at).
seq 2 : (#pre /\ W64.to_uint at8 = _at %% 8); first by auto => /> H0 H1 H2 H3 H4; rewrite (W64.to_uint_and_mod 3) // W64.of_uintK; smt(modz_small pow2_64).
seq 1 : (st = xabs4 _st _at L L L L at /\ off = _off + (at - _at) /\ _at <= at <= _upto /\ (at %% 8 = 0 \/ at = _upto)
         /\ buf = _buf /\ upto = _upto /\ 0 <= _at /\ _upto <= 200 /\ 0 <= _off /\ _off + (_upto - _at) <= _ASIZE).
+ if; last first; first by skip => /> &hr H1 H2 H3 H4 H5; rewrite xabs4_0 //; left; rewrite -H5.
  wp; ecall (a_rlen_read_upto8_h buf off len); wp; skip => /> &hr H0 H1 H2 H3 H4 Hk Hnz.
  have Ea8 : at8{hr} = W64.of_int (_at %% 8) by rewrite -Hk W64.to_uintK.
  have Hk0 : _at %% 8 <> 0 by move: Hnz; rewrite Ea8; apply contra => ->.
  have U : forall (t: W64.t) (L: W8.t list), size L = _upto - _at => srspec (u64bytes t) 0 0 L (_upto - _at) 0 =>
           forall r, 0 <= r < 8 => (t `<<` W8.of_int (8 * (_at %% 8))) \bits8 r = if _at <= 8 * (_at %/ 8) + r then L.[8 * (_at %/ 8) + r - _at] else W8.zero.
  + move=> t L' HsL Hs r Hr; have B := srspec_u64_bits8 t L' (_upto - _at) _ HsL Hs; first smt().
    rewrite W64.shl_shlw 1:/# bits8_u64_shl8 //.
    by case: (r < _at %% 8) => C; [rewrite ifF 1:/# | rewrite ifT 1:/# B 1:/#; congr; smt()].
  rewrite Hk shr3_shl3 Ea8 trunc_shl3_and63 1:/#; split; first smt().
  move=> _ r0 Hs0 Ho0; rewrite truncateu64_VMOV_64 (: 4 * (8 * (_at %/ 8)) = 32 * (_at %/ 8)) 1:/# st4x_set256 1:/#.
  have E := xabs4_step_bcast _st _at L _at (_at %/ 8) (r0.`2 `<<` W8.of_int (8 * (_at %% 8))) _ _ _; 1,2: smt(); first by apply U; [rewrite size_sub /# | done].
  rewrite xabs4_0 // in E; rewrite E.
  have SL : size L = _upto - _at by rewrite /L size_sub /#.
  split; first by move=> C; smt().
  by move=> C; rewrite (xabs4_addstate_at _ _ _ _ _ _ (8 * (_at %/ 8) + 8)) 1..4:/# (xabs4_addstate_at _ _ _ _ _ _ _upto) 1..4:/#; smt().
seq 3 : (st = xabs4 _st _at L L L L at /\ off = _off + (at - _at) /\ _at <= at <= _upto /\ (at %% 8 = 0 \/ at = _upto) /\ _upto < at + 8
         /\ buf = _buf /\ upto = _upto /\ 0 <= _at /\ _upto <= 200 /\ 0 <= _off /\ _off + (_upto - _at) <= _ASIZE).
+ while (st = xabs4 _st _at L L L L at /\ newat = at + 8 /\ off = _off + (at - _at) /\ _at <= at <= _upto /\ (at %% 8 = 0 \/ at = _upto)
         /\ buf = _buf /\ upto = _upto /\ 0 <= _at /\ _upto <= 200 /\ 0 <= _off /\ _off + (_upto - _at) <= _ASIZE); last by auto => /#.
  wp; skip => &hr [#] Est En Eo Ha0 Ha1 Ha8 -> -> H0 H1 H2 H3 Hc /=.
  have A8 : at{hr} %% 8 = 0 by smt().
  rewrite (: 4 * at{hr} = 32 * (at{hr} %/ 8)) 1:/# st4x_set256 1:/# Est.
  have E := xabs4_step_bcast _st _at L at{hr} (at{hr} %/ 8) (WA.get64_direct (WA.init8 (fun i => _buf.[i])) off{hr}) _ _ _; 1,2: smt().
  + by move=> r Hr; rewrite (wget64_bits8 (fun i => _buf.[i])) 1,2:/# /= ifT 1:/# /L nth_sub 1:/# Eo; congr; smt().
  by rewrite E (: 8 * (at{hr} %/ 8) + 8 = at{hr} + 8) 1:/# En /=; smt().
if; last first.
+ wp; skip => &hr [#] -> -> Ha0 Ha1 Ha8 Hlt _ -> H0 H1 H2 H3 Hc /=.
  have SL : size L = _upto - _at by rewrite /L size_sub /#.
  by rewrite xabs4_addstate_at 1..4:/#; split; [rewrite st4x_mapE | smt()].
wp; ecall (a_rlen_read_upto8_h buf off (W64.to_uint upto8)); wp; skip => &hr [#] Est Eo Ha0 Ha1 Ha8 Hlt -> -> H0 H1 H2 H3 Hc /=.
have Eu : W64.to_uint (W64.of_int _upto `&` W64.of_int 7) = _upto - at{hr} by rewrite (W64.to_uint_and_mod 3) // W64.of_uintK; smt(modz_small pow2_64).
rewrite Eu; split; [smt() | move=> _ r0 [Hs0 ->]].
have A8 : at{hr} %% 8 = 0 by smt().
rewrite truncateu64_VMOV_64 (: 4 * at{hr} = 32 * (at{hr} %/ 8)) 1:/# st4x_set256 1:/# Est.
have E := xabs4_step_bcast _st _at L at{hr} (at{hr} %/ 8) r0.`2 _ _ _; 1,2: smt().
+ move=> r Hr; have B := srspec_u64_bits8 r0.`2 _ _ _ _ Hs0; 1,2: rewrite ?size_sub /#.
  rewrite B // ifT 1:/#; case: (r < _upto - at{hr}) => C; [by rewrite /L !nth_sub 1,2:/# Eo; congr; smt() | by rewrite !nth_out ?size_sub /#].
have SL : size L = _upto - _at by rewrite /L size_sub /#.
by rewrite E xabs4_addstate_at 1..4:/#; split; [rewrite st4x_mapE | smt()].
qed.

phoare add_bcast_updstate_avx2x4_ph _st _at _buf _off _upto:
  [ MM._add_bcast_updstate_avx2x4
  : st = _st /\ at = _at /\ buf = _buf /\ off = _off /\ upto = _upto
    /\ 0 <= _at <= _upto /\ _upto <= 200
    /\ 0 <= _off /\ _off + (_upto - _at) <= _ASIZE
  ==> res.`3 = st4x_map (fun s => addstate_at s _at (sub _buf _off (_upto - _at))) _st
    /\ res.`1 = _upto
    /\ res.`2 = _off + (_upto - _at)
  ] = 1%r.
proof.
by conseq add_bcast_updstate_avx2x4_ll
       (add_bcast_updstate_avx2x4_h _st _at _buf _off _upto).
qed.


lemma absorb_updstate_avx2x4_ll: islossless MM._absorb_updstate_avx2x4.
proof.
proc; seq 3 : (1 <= r8).
+ by inline *; auto.
+ by call (: true ==> 1 <= res.`2); [conseq ststatus_data_avx2x4_ll ststatus_data_avx2x4_r8_h | auto].
+ wp; call add_updstate_avx2x4_ll; wp; while (1 <= r8) len; [move=> z; wp; call keccakf1600_avx2x4_ll; call add_updstate_avx2x4_ll; auto => /# | auto => /#].
+ by hoare; call ststatus_data_avx2x4_r8_h; auto.
done.
qed.

hoare absorb_updstate_avx2x4_h _l0 _l1 _l2 _l3 _b0 _b1 _b2 _b3 _len _st:
  MM._absorb_updstate_avx2x4
  : st = _st /\ buf0 = _b0 /\ buf1 = _b1 /\ buf2 = _b2 /\ buf3 = _b3 /\ len = _len
    /\ pabsorb_spec_updstate_avx2x4 _l0 _l1 _l2 _l3 _st
    /\ 0 <= len <= _ASIZE
  ==> pabsorb_spec_updstate_avx2x4 (_l0 ++ sub _b0 0 _len) (_l1 ++ sub _b1 0 _len)
                                   (_l2 ++ sub _b2 0 _len) (_l3 ++ sub _b3 0 _len) res
    /\ ststatus_r8     res.[100] = ststatus_r8     _st.[100]
    /\ ststatus_trailb res.[100] = ststatus_trailb _st.[100].
proof.
proc => /=; seq 3 : (#pre /\ r8 = ststatus_r8 _st.[100] /\ at = ststatus_at_norm _st.[100]).
+ by ecall (ststatus_data_avx2x4_h ststatus); wp; skip => /> &hr *.
seq 4 : (pabsorb_spec_avx2x4 (ststatus_r8 _st.[100]) (_l0 ++ sub _b0 0 off) (_l1 ++ sub _b1 0 off) (_l2 ++ sub _b2 0 off) (_l3 ++ sub _b3 0 off) stk
         /\ at = (size _l0 + off) %% ststatus_r8 _st.[100] /\ len = _len - off + at /\ 0 <= off <= _len /\ len < r8 /\ r8 = ststatus_r8 _st.[100]
         /\ buf0 = _b0 /\ buf1 = _b1 /\ buf2 = _b2 /\ buf3 = _b3 /\ st = _st /\ 0 < ststatus_r8 _st.[100] <= 200 /\ _len <= _ASIZE).
+ while (pabsorb_spec_avx2x4 (ststatus_r8 _st.[100]) (_l0 ++ sub _b0 0 off) (_l1 ++ sub _b1 0 off) (_l2 ++ sub _b2 0 off) (_l3 ++ sub _b3 0 off) stk
         /\ at = (size _l0 + off) %% ststatus_r8 _st.[100] /\ len = _len - off + at /\ 0 <= off <= _len /\ r8 = ststatus_r8 _st.[100]
         /\ buf0 = _b0 /\ buf1 = _b1 /\ buf2 = _b2 /\ buf3 = _b3 /\ st = _st /\ 0 < ststatus_r8 _st.[100] <= 200 /\ _len <= _ASIZE).
  + wp; ecall (keccakf1600_avx2x4_h stk); ecall (add_updstate_avx2x4_h stk at buf0 buf1 buf2 buf3 off r8).
    skip => &hr [#] Hp Ea El Ho0 Ho1 -> -> -> -> -> -> Hr0 Hr1 HA Hc /=.
    have Hs : size (_l0 ++ sub _b0 0 off{hr}) = size _l0 + off{hr} by rewrite size_cat size_sub.
    split; first smt(modz_ge0 ltz_pmod).
    move=> _ [a o s] [/= Es [_ Eo]] r -> /=; rewrite Es Eo.
    have B := pabsorb_spec_avx2x4_block (ststatus_r8 _st.[100]) (_l0 ++ sub _b0 0 off{hr}) (_l1 ++ sub _b1 0 off{hr}) (_l2 ++ sub _b2 0 off{hr}) (_l3 ++ sub _b3 0 off{hr})
                (sub _b0 off{hr} (ststatus_r8 _st.[100] - at{hr})) (sub _b1 off{hr} (ststatus_r8 _st.[100] - at{hr}))
                (sub _b2 off{hr} (ststatus_r8 _st.[100] - at{hr})) (sub _b3 off{hr} (ststatus_r8 _st.[100] - at{hr})) stk{hr} Hp _ _ _ _.
    + by rewrite Hs size_sub; smt(modz_ge0 ltz_pmod).
    + by rewrite !size_sub //; smt(modz_ge0 ltz_pmod).
    + by rewrite !size_sub //; smt(modz_ge0 ltz_pmod).
    + by rewrite !size_sub //; smt(modz_ge0 ltz_pmod).
    rewrite Hs -Ea -!catA in B.
    rewrite !(sub_split off{hr} _ 0 (off{hr} + (ststatus_r8 _st.[100] - at{hr}))) 1..4:/# /=.
    rewrite (: off{hr} + (ststatus_r8 _st.[100] - at{hr}) - off{hr} = ststatus_r8 _st.[100] - at{hr}) 1:/# B /=.
    have -> : size _l0 + (off{hr} + (ststatus_r8 _st.[100] - at{hr})) = ((size _l0 + off{hr}) %/ ststatus_r8 _st.[100] + 1) * ststatus_r8 _st.[100].
    + by rewrite Ea; smt(divz_eq).
    by rewrite modzMl /=; smt(modz_ge0 ltz_pmod).
  auto => /> &hr Hp H0 H1 H2 H3 HM HL0 HL1.
  have S0 : forall (b: W8.t A.t), sub b 0 0 = [] by move=> b; rewrite -size_eq0 size_sub.
  rewrite !S0 !cats0 /= (: Array25.init (fun i => WArray808.get256 (WArray808.init64 (fun j => _st.[j])) i) = A101u64toA25u256 _st) //.
  split; first by rewrite H1 H2 H3.
  by move=> off0 stk0 Hc *; smt().
seq 2 : (pabsorb_spec_avx2x4 (ststatus_r8 _st.[100]) (_l0 ++ sub _b0 0 _len) (_l1 ++ sub _b1 0 _len) (_l2 ++ sub _b2 0 _len) (_l3 ++ sub _b3 0 _len) stk
         /\ at = (size _l0 + _len) %% ststatus_r8 _st.[100] /\ st = _st /\ 0 < ststatus_r8 _st.[100] <= 200 /\ 0 <= _len <= _ASIZE).
+ wp; ecall (add_updstate_avx2x4_h stk at buf0 buf1 buf2 buf3 off len); wp.
  skip => &hr; move=> [Hp [Ea [El [Ho [Hlt [Er [-> [-> [-> [-> [-> [Hr HA]]]]]]]]]]]] /=.
  split; first smt().
  move=> _ [a o s] [/= -> [-> _]].
  have Hsz : size (_l0 ++ sub _b0 0 off{hr}) = size _l0 + off{hr} by rewrite size_cat size_sub /#.
  have B := pabsorb_spec_avx2x4_add (ststatus_r8 _st.[100]) (_l0 ++ sub _b0 0 off{hr}) (_l1 ++ sub _b1 0 off{hr}) (_l2 ++ sub _b2 0 off{hr}) (_l3 ++ sub _b3 0 off{hr})
              (sub _b0 off{hr} (len{hr} - at{hr})) (sub _b1 off{hr} (len{hr} - at{hr})) (sub _b2 off{hr} (len{hr} - at{hr})) (sub _b3 off{hr} (len{hr} - at{hr})) stk{hr} Hp _ _ _ _.
  + by rewrite Hsz size_sub; smt(modz_ge0 ltz_pmod).
  + by rewrite !size_sub //; smt(modz_ge0 ltz_pmod).
  + by rewrite !size_sub //; smt(modz_ge0 ltz_pmod).
  + by rewrite !size_sub //; smt(modz_ge0 ltz_pmod).
  rewrite Hsz -Ea -!catA in B; rewrite !(sub_split off{hr} _ 0 _len) 1..4:/# /= (: _len - off{hr} = len{hr} - at{hr}) 1:/# B /=.
  have -> : size _l0 + _len = (size _l0 + off{hr}) %/ ststatus_r8 _st.[100] * ststatus_r8 _st.[100] + len{hr}.
  + by rewrite El Ea; have := divz_eq (size _l0 + off{hr}) (ststatus_r8 _st.[100]); smt().
  by rewrite modzMDl modz_small; smt(modz_ge0 ltz_pmod).
seq 1 : (st = A25u256toA101u64 stk _st.[100]
         /\ pabsorb_spec_avx2x4 (ststatus_r8 _st.[100]) (_l0 ++ sub _b0 0 _len) (_l1 ++ sub _b1 0 _len) (_l2 ++ sub _b2 0 _len) (_l3 ++ sub _b3 0 _len) stk
         /\ at = (size _l0 + _len) %% ststatus_r8 _st.[100] /\ 0 < ststatus_r8 _st.[100] <= 200 /\ 0 <= _len <= _ASIZE).
+ by wp; skip => &hr [Hp [Ea [-> H]]] /=; rewrite A25u256toA101u64E.
wp; skip => &hr [-> [Hp [Ea [Hr HL]]]]; rewrite (: 32 * 25 = 800) // A101_set800.
have /= [Wa [Wr Wt]] := ststatus_byte0 (pack8_t (W8u8.Pack.init (fun j => if j = 0 then truncateu8 (W64.of_int at{hr}) else _st.[100] \bits8 j))) _st.[100] (truncateu8 (W64.of_int at{hr})) _.
+ by move=> j Hj; rewrite W8u8.pack8bE // W8u8.Pack.initiE.
have Tb : W8.to_uint (truncateu8 (W64.of_int at{hr})) = at{hr} by rewrite /truncateu8 W8.of_uintK W64.of_uintK; smt(modz_small modz_ge0 ltz_pmod pow2_64).
rewrite /= /A25u256toA101u64 Array101.initiE //= Wr Wt /= /pabsorb_spec_updstate_avx2x4 Array101.initiE //= -/(A25u256toA101u64 stk{hr} _) A101u64toA25u256K /ststatus_at_norm Wa Wr Tb.
by rewrite /= size_cat size_sub 1:/# -Ea ifF //; smt(modz_ge0 ltz_pmod).
qed.

phoare absorb_updstate_avx2x4_ph _l0 _l1 _l2 _l3 _b0 _b1 _b2 _b3 _len _st:
  [ MM._absorb_updstate_avx2x4
  : st = _st /\ buf0 = _b0 /\ buf1 = _b1 /\ buf2 = _b2 /\ buf3 = _b3 /\ len = _len
    /\ pabsorb_spec_updstate_avx2x4 _l0 _l1 _l2 _l3 _st
    /\ 0 <= len <= _ASIZE
  ==> pabsorb_spec_updstate_avx2x4 (_l0 ++ sub _b0 0 _len) (_l1 ++ sub _b1 0 _len)
                                   (_l2 ++ sub _b2 0 _len) (_l3 ++ sub _b3 0 _len) res
    /\ ststatus_r8     res.[100] = ststatus_r8     _st.[100]
    /\ ststatus_trailb res.[100] = ststatus_trailb _st.[100]
  ] = 1%r.
proof.
by conseq absorb_updstate_avx2x4_ll
       (absorb_updstate_avx2x4_h _l0 _l1 _l2 _l3 _b0 _b1 _b2 _b3 _len _st).
qed.


lemma absorb_bcast_updstate_avx2x4_ll: islossless MM._absorb_bcast_updstate_avx2x4.
proof.
proc; seq 3 : (1 <= r8).
+ by inline *; auto.
+ by call (: true ==> 1 <= res.`2); [conseq ststatus_data_avx2x4_ll ststatus_data_avx2x4_r8_h | auto].
+ wp; call add_bcast_updstate_avx2x4_ll; wp; while (1 <= r8) len; [move=> z; wp; call keccakf1600_avx2x4_ll; call add_bcast_updstate_avx2x4_ll; auto => /# | auto => /#].
+ by hoare; call ststatus_data_avx2x4_r8_h; auto.
done.
qed.

hoare absorb_bcast_updstate_avx2x4_h _l0 _l1 _l2 _l3 _buf _len _st:
  MM._absorb_bcast_updstate_avx2x4
  : st = _st /\ buf = _buf /\ len = _len
    /\ pabsorb_spec_updstate_avx2x4 _l0 _l1 _l2 _l3 _st
    /\ 0 <= len <= _ASIZE
  ==> pabsorb_spec_updstate_avx2x4 (_l0 ++ sub _buf 0 _len) (_l1 ++ sub _buf 0 _len)
                                   (_l2 ++ sub _buf 0 _len) (_l3 ++ sub _buf 0 _len) res
    /\ ststatus_r8     res.[100] = ststatus_r8     _st.[100]
    /\ ststatus_trailb res.[100] = ststatus_trailb _st.[100].
proof.
proc => /=; seq 3 : (#pre /\ r8 = ststatus_r8 _st.[100] /\ at = ststatus_at_norm _st.[100]).
+ by ecall (ststatus_data_avx2x4_h ststatus); wp; skip => /> &hr *.
seq 4 : (pabsorb_spec_avx2x4 (ststatus_r8 _st.[100]) (_l0 ++ sub _buf 0 off) (_l1 ++ sub _buf 0 off) (_l2 ++ sub _buf 0 off) (_l3 ++ sub _buf 0 off) stk
         /\ at = (size _l0 + off) %% ststatus_r8 _st.[100] /\ len = _len - off + at /\ 0 <= off <= _len /\ len < r8 /\ r8 = ststatus_r8 _st.[100]
         /\ buf = _buf /\ st = _st /\ 0 < ststatus_r8 _st.[100] <= 200 /\ _len <= _ASIZE).
+ while (pabsorb_spec_avx2x4 (ststatus_r8 _st.[100]) (_l0 ++ sub _buf 0 off) (_l1 ++ sub _buf 0 off) (_l2 ++ sub _buf 0 off) (_l3 ++ sub _buf 0 off) stk
         /\ at = (size _l0 + off) %% ststatus_r8 _st.[100] /\ len = _len - off + at /\ 0 <= off <= _len /\ r8 = ststatus_r8 _st.[100]
         /\ buf = _buf /\ st = _st /\ 0 < ststatus_r8 _st.[100] <= 200 /\ _len <= _ASIZE).
  + wp; ecall (keccakf1600_avx2x4_h stk); ecall (add_bcast_updstate_avx2x4_h stk at buf off r8).
    skip => &hr [#] Hp Ea El Ho0 Ho1 -> -> -> Hr0 Hr1 HA Hc /=.
    have Hs : size (_l0 ++ sub _buf 0 off{hr}) = size _l0 + off{hr} by rewrite size_cat size_sub.
    split; first smt(modz_ge0 ltz_pmod).
    move=> _ [a o s] [/= Es [_ Eo]] r -> /=.
    rewrite Es Eo (st4x_mapE (fun (s0: W64.t Array25.t) => addstate_at s0 at{hr} (sub _buf off{hr} (ststatus_r8 _st.[100] - at{hr})))) /=.
    have B := pabsorb_spec_avx2x4_block (ststatus_r8 _st.[100]) (_l0 ++ sub _buf 0 off{hr}) (_l1 ++ sub _buf 0 off{hr}) (_l2 ++ sub _buf 0 off{hr}) (_l3 ++ sub _buf 0 off{hr})
                (sub _buf off{hr} (ststatus_r8 _st.[100] - at{hr})) (sub _buf off{hr} (ststatus_r8 _st.[100] - at{hr}))
                (sub _buf off{hr} (ststatus_r8 _st.[100] - at{hr})) (sub _buf off{hr} (ststatus_r8 _st.[100] - at{hr})) stk{hr} Hp _ _ _ _ => //.
    + by rewrite Hs size_sub; smt(modz_ge0 ltz_pmod).
    rewrite Hs -Ea -!catA in B.
    rewrite (sub_split off{hr} _buf 0 (off{hr} + (ststatus_r8 _st.[100] - at{hr}))) 1:/# /=.
    rewrite (: off{hr} + (ststatus_r8 _st.[100] - at{hr}) - off{hr} = ststatus_r8 _st.[100] - at{hr}) 1:/# B /=.
    have -> : size _l0 + (off{hr} + (ststatus_r8 _st.[100] - at{hr})) = ((size _l0 + off{hr}) %/ ststatus_r8 _st.[100] + 1) * ststatus_r8 _st.[100].
    + by rewrite Ea; smt(divz_eq).
    by rewrite modzMl /=; smt(modz_ge0 ltz_pmod).
  auto => /> &hr Hp H0 H1 H2 H3 HM HL0 HL1.
  have S0 : forall (b: W8.t A.t), sub b 0 0 = [] by move=> b; rewrite -size_eq0 size_sub.
  rewrite !S0 !cats0 /= (: Array25.init (fun i => WArray808.get256 (WArray808.init64 (fun j => _st.[j])) i) = A101u64toA25u256 _st) //.
  split; first by rewrite H1 H2 H3.
  by move=> off0 stk0 Hc *; smt().
seq 2 : (pabsorb_spec_avx2x4 (ststatus_r8 _st.[100]) (_l0 ++ sub _buf 0 _len) (_l1 ++ sub _buf 0 _len) (_l2 ++ sub _buf 0 _len) (_l3 ++ sub _buf 0 _len) stk
         /\ at = (size _l0 + _len) %% ststatus_r8 _st.[100] /\ st = _st /\ 0 < ststatus_r8 _st.[100] <= 200 /\ 0 <= _len <= _ASIZE).
+ wp; ecall (add_bcast_updstate_avx2x4_h stk at buf off len); wp.
  skip => &hr; move=> [Hp [Ea [El [Ho [Hlt [Er [-> [-> [Hr HA]]]]]]]]] /=.
  split; first smt().
  move=> _ [a o s] [/= -> [-> _]]; rewrite st4x_mapE /=.
  have Hsz : size (_l0 ++ sub _buf 0 off{hr}) = size _l0 + off{hr} by rewrite size_cat size_sub /#.
  have B := pabsorb_spec_avx2x4_add (ststatus_r8 _st.[100]) (_l0 ++ sub _buf 0 off{hr}) (_l1 ++ sub _buf 0 off{hr}) (_l2 ++ sub _buf 0 off{hr}) (_l3 ++ sub _buf 0 off{hr})
              (sub _buf off{hr} (len{hr} - at{hr})) (sub _buf off{hr} (len{hr} - at{hr})) (sub _buf off{hr} (len{hr} - at{hr})) (sub _buf off{hr} (len{hr} - at{hr})) stk{hr} Hp _ _ _ _ => //.
  + by rewrite Hsz size_sub; smt(modz_ge0 ltz_pmod).
  rewrite Hsz -Ea -!catA in B; rewrite (sub_split off{hr} _buf 0 _len) 1:/# /= (: _len - off{hr} = len{hr} - at{hr}) 1:/# B /=.
  have -> : size _l0 + _len = (size _l0 + off{hr}) %/ ststatus_r8 _st.[100] * ststatus_r8 _st.[100] + len{hr}.
  + by rewrite El Ea; have := divz_eq (size _l0 + off{hr}) (ststatus_r8 _st.[100]); smt().
  by rewrite modzMDl modz_small; smt(modz_ge0 ltz_pmod).
seq 1 : (st = A25u256toA101u64 stk _st.[100]
         /\ pabsorb_spec_avx2x4 (ststatus_r8 _st.[100]) (_l0 ++ sub _buf 0 _len) (_l1 ++ sub _buf 0 _len) (_l2 ++ sub _buf 0 _len) (_l3 ++ sub _buf 0 _len) stk
         /\ at = (size _l0 + _len) %% ststatus_r8 _st.[100] /\ 0 < ststatus_r8 _st.[100] <= 200 /\ 0 <= _len <= _ASIZE).
+ by wp; skip => &hr [Hp [Ea [-> H]]] /=; rewrite A25u256toA101u64E.
wp; skip => &hr [-> [Hp [Ea [Hr HL]]]]; rewrite (: 32 * 25 = 800) // A101_set800.
have /= [Wa [Wr Wt]] := ststatus_byte0 (pack8_t (W8u8.Pack.init (fun j => if j = 0 then truncateu8 (W64.of_int at{hr}) else _st.[100] \bits8 j))) _st.[100] (truncateu8 (W64.of_int at{hr})) _.
+ by move=> j Hj; rewrite W8u8.pack8bE // W8u8.Pack.initiE.
have Tb : W8.to_uint (truncateu8 (W64.of_int at{hr})) = at{hr} by rewrite /truncateu8 W8.of_uintK W64.of_uintK; smt(modz_small modz_ge0 ltz_pmod pow2_64).
rewrite /= /A25u256toA101u64 Array101.initiE //= Wr Wt /= /pabsorb_spec_updstate_avx2x4 Array101.initiE //= -/(A25u256toA101u64 stk{hr} _) A101u64toA25u256K /ststatus_at_norm Wa Wr Tb.
by rewrite /= size_cat size_sub 1:/# -Ea ifF //; smt(modz_ge0 ltz_pmod).
qed.

phoare absorb_bcast_updstate_avx2x4_ph _l0 _l1 _l2 _l3 _buf _len _st:
  [ MM._absorb_bcast_updstate_avx2x4
  : st = _st /\ buf = _buf /\ len = _len
    /\ pabsorb_spec_updstate_avx2x4 _l0 _l1 _l2 _l3 _st
    /\ 0 <= len <= _ASIZE
  ==> pabsorb_spec_updstate_avx2x4 (_l0 ++ sub _buf 0 _len) (_l1 ++ sub _buf 0 _len)
                                   (_l2 ++ sub _buf 0 _len) (_l3 ++ sub _buf 0 _len) res
    /\ ststatus_r8     res.[100] = ststatus_r8     _st.[100]
    /\ ststatus_trailb res.[100] = ststatus_trailb _st.[100]
  ] = 1%r.
proof.
by conseq absorb_bcast_updstate_avx2x4_ll
       (absorb_bcast_updstate_avx2x4_h _l0 _l1 _l2 _l3 _buf _len _st).
qed.


op dinv (b b0: W8.t A.t) (F: int -> W8.t) (o n m: int) : bool =
  (forall i, 0 <= i < _ASIZE => !(o <= i < o + n) => b.[i] = b0.[i])
  /\ (forall i, o <= i < o + m => b.[i] = F i).

lemma dinv0 (b0: W8.t A.t) F o n: dinv b0 b0 F o n 0.
proof. by split => // i; smt(). qed.

lemma dinv_fill (b b0: W8.t A.t) F o n m m' k (G: int -> W8.t):
  0 <= o => o + n <= _ASIZE => 0 <= m => 0 <= k => m + k <= n => m <= m' <= m + k =>
  (forall i, o + m <= i < o + m' => G i = F i) =>
  dinv b b0 F o n m => dinv (A.fill G (o + m) k b) b0 F o n m'.
proof.
move=> Ho Hn Hm Hk Hmk Hm' HG [H1 H2]; split => i Hi.
+ by move=> Hni; rewrite A.filliE // ifF 1:/# H1.
by rewrite A.filliE 1:/#; case: (o + m <= i < o + m + k) => C; [rewrite HG /# | rewrite H2 /#].
qed.

lemma dinv_final (b b0: W8.t A.t) F o n:
  0 <= o => o + n <= _ASIZE => dinv b b0 F o n n => b = A.fill F o n b0.
proof.
move=> Ho Hn [H1 H2]; apply A.tP => i Hi; rewrite A.filliE //.
by case: (o <= i < o + n) => C; [exact (H2 i C) | exact (H1 i Hi C)].
qed.

lemma dump_updstate_avx2x4_ll: islossless MM._dump_updstate_avx2x4.
proof.
proc; seq 3 : true => //; first by sp; if; [wp; do 4! (call RW.a_rlen_write_upto8_ll; wp); auto | auto].
seq 3 : true => //; first by wp; while true (upto + 8 - newat); [move=> z; auto => /# | auto => /#].
by wp; if; [wp; do 4! (call RW.a_rlen_write_upto8_ll; wp); auto | auto].
qed.

hoare dump_updstate_avx2x4_h _b0 _b1 _b2 _b3 _off _st _at _upto:
  MM._dump_updstate_avx2x4
  : buf0 = _b0 /\ buf1 = _b1 /\ buf2 = _b2 /\ buf3 = _b3
    /\ off = _off /\ st = _st /\ at = _at /\ upto = _upto
    /\ 0 <= _at <= _upto /\ _upto <= 200
    /\ 0 <= _off /\ _off + (_upto - _at) <= _ASIZE
  ==> res.`3 = A.fill (fun i => (stbytes (st4x_get _st 0)).[i - _off + _at]) _off (_upto - _at) _b0
    /\ res.`4 = A.fill (fun i => (stbytes (st4x_get _st 1)).[i - _off + _at]) _off (_upto - _at) _b1
    /\ res.`5 = A.fill (fun i => (stbytes (st4x_get _st 2)).[i - _off + _at]) _off (_upto - _at) _b2
    /\ res.`6 = A.fill (fun i => (stbytes (st4x_get _st 3)).[i - _off + _at]) _off (_upto - _at) _b3
    /\ res.`1 = _upto
    /\ res.`2 = _off + (_upto - _at).
proof.
proc => /=; pose F0 := fun i => (stbytes (st4x_get _st 0)).[i - _off + _at]; pose F1 := fun i => (stbytes (st4x_get _st 1)).[i - _off + _at].
pose F2 := fun i => (stbytes (st4x_get _st 2)).[i - _off + _at]; pose F3 := fun i => (stbytes (st4x_get _st 3)).[i - _off + _at].
seq 2 : (#pre /\ W64.to_uint at8 = _at %% 8); first by auto => /> H0 H1 H2 H3 H4; rewrite (W64.to_uint_and_mod 3) // W64.of_uintK; smt(modz_small pow2_64).
seq 1 : (off = _off + (at - _at) /\ _at <= at <= _upto /\ (at %% 8 = 0 \/ at = _upto)
         /\ dinv buf0 _b0 F0 _off (_upto - _at) (at - _at) /\ dinv buf1 _b1 F1 _off (_upto - _at) (at - _at)
         /\ dinv buf2 _b2 F2 _off (_upto - _at) (at - _at) /\ dinv buf3 _b3 F3 _off (_upto - _at) (at - _at)
         /\ st = _st /\ upto = _upto /\ 0 <= _at /\ _upto <= 200 /\ 0 <= _off /\ _off + (_upto - _at) <= _ASIZE).
+ if; last first.
  + skip => &hr [#] -> -> -> -> -> -> -> -> H1 H2 H3 H4 H5 Hk Hz /=.
    by rewrite !dinv0 /=; smt(W64.to_uint0).
  wp; ecall (a_rlen_write_upto8_h buf3 off t64 len); wp; ecall (a_rlen_write_upto8_h buf2 off t64 len).
  wp; ecall (a_rlen_write_upto8_h buf1 off t64 len); wp; ecall (a_rlen_write_upto8_h buf0 off t64 len).
  wp; skip => &hr [#] -> -> -> -> -> -> -> -> H0 H1 H2 H3 H4 Hk Hnz /=.
  have Ea8 : at8{hr} = W64.of_int (_at %% 8) by rewrite -Hk W64.to_uintK.
  have Hk0 : _at %% 8 <> 0 by move: Hnz; rewrite Ea8; apply contra => ->.
  rewrite Hk shr3_shl3 Ea8 trunc_shl3_and63 1:/#.
  have Fv : forall k o i, 0 <= k < 4 => o = 4 * (8 * (_at %/ 8)) + 8 * k => _off <= i => i - _off + _at %% 8 < 8 =>
            (u64bytes (WArray800.get64_direct (WArray800.init256 (fun j => _st.[j])) o `>>` W8.of_int (8 * (_at %% 8)))).[i - _off]
            = (stbytes (st4x_get _st k)).[i - _off + _at].
  + move=> k o i Hkk Ho Hi0 Hi1; rewrite get_u64bytes W64.shr_shrw 1:/# bits8_u64_shr8 1,2:/# (st4x_get64d_bits8 _st (8 * (_at %/ 8)) k o) 1..5:/#.
    by congr; smt().
  have D : forall (b: W8.t A.t) F (G: int -> W8.t) m', 0 <= m' <= min 8 (max 0 (_upto - _at)) => (forall i, _off <= i < _off + m' => G i = F i) =>
           dinv (A.fill G _off (min 8 (max 0 (_upto - _at))) b) b F _off (_upto - _at) m'.
  + move=> b F G m' Hm' HG; have /= := dinv_fill b b F _off (_upto - _at) 0 m' (min 8 (max 0 (_upto - _at))) G _ _ _ _ _ _ _ (dinv0 b F _off (_upto - _at)).
    + smt().
    + smt().
    + smt().
    + smt().
    + smt().
    + smt().
    + by move=> i Hi; apply HG => /#.
    done.
  split; [smt() | move=> _ r0 [-> _]]; split; [smt() | move=> _ r1 [-> _]]; split; [smt() | move=> _ r2 [-> _]]; split; [smt() | move=> _ r3 [-> ->]].
  case: (8 <= _upto - _at + _at %% 8) => C /=.
  + do 3! (split; first smt()).
    split; first by apply D; [smt() | move=> i Hi /=; rewrite /F0 /= (Fv 0) 1..4:/#].
    split; first by apply D; [smt() | move=> i Hi /=; rewrite /F1 /= (Fv 1) 1..4:/#].
    split; first by apply D; [smt() | move=> i Hi /=; rewrite /F2 /= (Fv 2) 1..4:/#].
    split; first by apply D; [smt() | move=> i Hi /=; rewrite /F3 /= (Fv 3) 1..4:/#].
    smt().
  do 2! (split; first smt()).
  split; first by apply D; [smt() | move=> i Hi /=; rewrite /F0 /= (Fv 0) 1..4:/#].
  split; first by apply D; [smt() | move=> i Hi /=; rewrite /F1 /= (Fv 1) 1..4:/#].
  split; first by apply D; [smt() | move=> i Hi /=; rewrite /F2 /= (Fv 2) 1..4:/#].
  split; first by apply D; [smt() | move=> i Hi /=; rewrite /F3 /= (Fv 3) 1..4:/#].
  smt().
seq 3 : (off = _off + (at - _at) /\ _at <= at <= _upto /\ (at %% 8 = 0 \/ at = _upto) /\ _upto < at + 8
         /\ dinv buf0 _b0 F0 _off (_upto - _at) (at - _at) /\ dinv buf1 _b1 F1 _off (_upto - _at) (at - _at)
         /\ dinv buf2 _b2 F2 _off (_upto - _at) (at - _at) /\ dinv buf3 _b3 F3 _off (_upto - _at) (at - _at)
         /\ st = _st /\ upto = _upto /\ 0 <= _at /\ _upto <= 200 /\ 0 <= _off /\ _off + (_upto - _at) <= _ASIZE).
+ while (newat = at + 8 /\ off = _off + (at - _at) /\ _at <= at <= _upto /\ (at %% 8 = 0 \/ at = _upto)
         /\ dinv buf0 _b0 F0 _off (_upto - _at) (at - _at) /\ dinv buf1 _b1 F1 _off (_upto - _at) (at - _at)
         /\ dinv buf2 _b2 F2 _off (_upto - _at) (at - _at) /\ dinv buf3 _b3 F3 _off (_upto - _at) (at - _at)
         /\ st = _st /\ upto = _upto /\ 0 <= _at /\ _upto <= 200 /\ 0 <= _off /\ _off + (_upto - _at) <= _ASIZE); last by auto => /#.
  wp; skip => &hr [#] En Eo Ha0 Ha1 Ha8 D0 D1 D2 D3 -> -> H0 H1 H2 H3 Hc /=.
  have /= -> := a_set64_fill buf0{hr} off{hr} (WArray800.get64_direct (WArray800.init256 (fun j => _st.[j])) (4 * at{hr})).
  have /= -> := a_set64_fill buf1{hr} off{hr} (WArray800.get64_direct (WArray800.init256 (fun j => _st.[j])) (4 * at{hr} + 8)).
  have /= -> := a_set64_fill buf2{hr} off{hr} (WArray800.get64_direct (WArray800.init256 (fun j => _st.[j])) (4 * at{hr} + 16)).
  have /= -> := a_set64_fill buf3{hr} off{hr} (WArray800.get64_direct (WArray800.init256 (fun j => _st.[j])) (4 * at{hr} + 24)).
  have DS : forall (b b0: W8.t A.t) F k o, 0 <= k < 4 => o = 4 * at{hr} + 8 * k => (forall i, F i = (stbytes (st4x_get _st k)).[i - _off + _at]) =>
            dinv b b0 F _off (_upto - _at) (at{hr} - _at) =>
            dinv (A.fill (fun i => WArray800.get64_direct (WArray800.init256 (fun j => _st.[j])) o \bits8 (i - off{hr})) off{hr} 8 b) b0 F _off (_upto - _at) (newat{hr} - _at).
  + move=> b b0 F k o Hkk Ho HF D; rewrite Eo En; apply (dinv_fill b b0 F _off (_upto - _at) (at{hr} - _at) (at{hr} + 8 - _at) 8) => //.
    + smt().
    + smt().
    + smt().
    by move=> i Hi /=; rewrite HF (st4x_get64d_bits8 _st at{hr} k o) 1..5:/#; congr; smt().
  do 3! (split; first smt()).
  split; first by apply (DS _ _ _ 0) => //.
  split; first by apply (DS _ _ _ 1) => //.
  split; first by apply (DS _ _ _ 2) => //.
  split; first by apply (DS _ _ _ 3) => //.
  smt().
if; last first.
+ wp; skip => &hr [#] -> Ha0 Ha1 Ha8 Hlt D0 D1 D2 D3 _ -> H0 H1 H2 H3 Hc /=.
  have Eat : at{hr} = _upto by smt().
  move: D0 D1 D2 D3; rewrite Eat => D0 D1 D2 D3.
  by rewrite (dinv_final _ _ F0 _ _ _ _ D0) 1,2:/# (dinv_final _ _ F1 _ _ _ _ D1) 1,2:/# (dinv_final _ _ F2 _ _ _ _ D2) 1,2:/# (dinv_final _ _ F3 _ _ _ _ D3) 1,2:/#.
wp; ecall (a_rlen_write_upto8_h buf3 off t64 (W64.to_uint upto8)); wp; ecall (a_rlen_write_upto8_h buf2 off t64 (W64.to_uint upto8)).
wp; ecall (a_rlen_write_upto8_h buf1 off t64 (W64.to_uint upto8)); wp; ecall (a_rlen_write_upto8_h buf0 off t64 (W64.to_uint upto8)).
wp; skip => &hr [#] Eo Ha0 Ha1 Ha8 Hlt D0 D1 D2 D3 -> -> H0 H1 H2 H3 Hc /=.
have Eu : W64.to_uint (W64.of_int _upto `&` W64.of_int 7) = _upto - at{hr} by rewrite (W64.to_uint_and_mod 3) // W64.of_uintK; smt(modz_small pow2_64).
have A8 : at{hr} %% 8 = 0 by smt().
rewrite Eu (: min 8 (max 0 (_upto - at{hr})) = _upto - at{hr}) 1:/#.
split; [smt() | move=> _ r0 [-> _]]; split; [smt() | move=> _ r1 [-> _]]; split; [smt() | move=> _ r2 [-> _]]; split; [smt() | move=> _ r3 [-> ->]].
have DT : forall (b b0: W8.t A.t) F k o, 0 <= k < 4 => o = 4 * at{hr} + 8 * k => (forall i, F i = (stbytes (st4x_get _st k)).[i - _off + _at]) =>
          dinv b b0 F _off (_upto - _at) (at{hr} - _at) =>
          dinv (A.fill (fun i => (u64bytes (WArray800.get64_direct (WArray800.init256 (fun j => _st.[j])) o)).[i - off{hr}]) off{hr} (_upto - at{hr}) b) b0 F _off (_upto - _at) (_upto - _at).
+ move=> b b0 F k o Hkk Ho HF D; rewrite Eo; apply (dinv_fill b b0 F _off (_upto - _at) (at{hr} - _at) (_upto - _at) (_upto - at{hr})) => //.
  + smt().
  + smt().
  + smt().
  + smt().
  by move=> i Hi /=; rewrite HF get_u64bytes (st4x_get64d_bits8 _st at{hr} k o) 1..5:/#; congr; smt().
have E0 := DT buf0{hr} _b0 F0 0 (4 * at{hr}) _ _ _ D0 => //.
have E1 := DT buf1{hr} _b1 F1 1 (4 * at{hr} + 8) _ _ _ D1 => //.
have E2 := DT buf2{hr} _b2 F2 2 (4 * at{hr} + 16) _ _ _ D2 => //.
have E3 := DT buf3{hr} _b3 F3 3 (4 * at{hr} + 24) _ _ _ D3 => //.
rewrite (dinv_final _ _ _ _ _ _ _ E0) 1,2:/# (dinv_final _ _ _ _ _ _ _ E1) 1,2:/# (dinv_final _ _ _ _ _ _ _ E2) 1,2:/# (dinv_final _ _ _ _ _ _ _ E3) 1,2:/#.
by rewrite /F0 /F1 /F2 /F3 /=; smt().
qed.

phoare dump_updstate_avx2x4_ph _b0 _b1 _b2 _b3 _off _st _at _upto:
  [ MM._dump_updstate_avx2x4
  : buf0 = _b0 /\ buf1 = _b1 /\ buf2 = _b2 /\ buf3 = _b3
    /\ off = _off /\ st = _st /\ at = _at /\ upto = _upto
    /\ 0 <= _at <= _upto /\ _upto <= 200
    /\ 0 <= _off /\ _off + (_upto - _at) <= _ASIZE
  ==> res.`3 = A.fill (fun i => (stbytes (st4x_get _st 0)).[i - _off + _at]) _off (_upto - _at) _b0
    /\ res.`4 = A.fill (fun i => (stbytes (st4x_get _st 1)).[i - _off + _at]) _off (_upto - _at) _b1
    /\ res.`5 = A.fill (fun i => (stbytes (st4x_get _st 2)).[i - _off + _at]) _off (_upto - _at) _b2
    /\ res.`6 = A.fill (fun i => (stbytes (st4x_get _st 3)).[i - _off + _at]) _off (_upto - _at) _b3
    /\ res.`1 = _upto
    /\ res.`2 = _off + (_upto - _at)
  ] = 1%r.
proof.
by conseq dump_updstate_avx2x4_ll
       (dump_updstate_avx2x4_h _b0 _b1 _b2 _b3 _off _st _at _upto).
qed.


lemma squeeze_updstate_avx2x4_ll: islossless MM._squeeze_updstate_avx2x4.
proof.
proc; seq 3 : (1 <= r8).
+ by inline *; auto.
+ by call (: true ==> 1 <= res.`2); [conseq ststatus_data_avx2x4_ll ststatus_data_avx2x4_r8_h | auto].
+ wp; call dump_updstate_avx2x4_ll; wp; while (1 <= r8) len; [move=> z; wp; call keccakf1600_avx2x4_ll; call dump_updstate_avx2x4_ll; auto => /# | wp; sp; if; [wp; call keccakf1600_avx2x4_ll; auto => /# | auto => /#]].
+ by hoare; call ststatus_data_avx2x4_r8_h; auto.
done.
qed.

hoare squeeze_updstate_avx2x4_h _b0 _b1 _b2 _b3 _st _r8 _len:
  MM._squeeze_updstate_avx2x4
  : buf0 = _b0 /\ buf1 = _b1 /\ buf2 = _b2 /\ buf3 = _b3 /\ len = _len /\ st = _st
    /\ ststatus_r8 _st.[100] = _r8 /\ ststatus_at_norm _st.[100] = 0
    /\ 0 < _r8 <= 200 /\ 0 < _len <= _ASIZE
  ==> let stk = A101u64toA25u256 _st in
      res.`2 = A.fill (fun i => (SQUEEZE1600 _r8 _len (st4x_get stk 0)).[i]) 0 _len _b0
    /\ res.`3 = A.fill (fun i => (SQUEEZE1600 _r8 _len (st4x_get stk 1)).[i]) 0 _len _b1
    /\ res.`4 = A.fill (fun i => (SQUEEZE1600 _r8 _len (st4x_get stk 2)).[i]) 0 _len _b2
    /\ res.`5 = A.fill (fun i => (SQUEEZE1600 _r8 _len (st4x_get stk 3)).[i]) 0 _len _b3
    /\ A101u64toA25u256 res.`1 = iter ((_len - 1) %/ _r8 + 1) keccak_f1600_x4 stk
    /\ ststatus_at res.`1.[100] = (_len - 1) %% _r8 + 1
    /\ ststatus_r8 res.`1.[100] = _r8
    /\ ststatus_trailb res.`1.[100] = ststatus_trailb _st.[100].
proof.
proc => /=; seq 3 : (#pre /\ r8 = _r8 /\ at = 0); first by ecall (ststatus_data_avx2x4_h ststatus); wp; skip => /> &hr *.
rcondt 2; first by auto.
seq 5 : (off %% _r8 = 0 /\ stk = iter (off %/ _r8 + 1) keccak_f1600_x4 (A101u64toA25u256 _st) /\ at = 0 /\ len = _len - off /\ 0 < len <= _r8 /\ 0 <= off
         /\ buf0 = A.fill (fun i => (SQUEEZE1600 _r8 _len (st4x_get (A101u64toA25u256 _st) 0)).[i]) 0 off _b0
         /\ buf1 = A.fill (fun i => (SQUEEZE1600 _r8 _len (st4x_get (A101u64toA25u256 _st) 1)).[i]) 0 off _b1
         /\ buf2 = A.fill (fun i => (SQUEEZE1600 _r8 _len (st4x_get (A101u64toA25u256 _st) 2)).[i]) 0 off _b2
         /\ buf3 = A.fill (fun i => (SQUEEZE1600 _r8 _len (st4x_get (A101u64toA25u256 _st) 3)).[i]) 0 off _b3
         /\ r8 = _r8 /\ st = _st /\ ststatus_r8 _st.[100] = _r8 /\ 0 < _r8 <= 200 /\ 0 < _len <= _ASIZE).
+ while (off %% _r8 = 0 /\ stk = iter (off %/ _r8 + 1) keccak_f1600_x4 (A101u64toA25u256 _st) /\ at = 0 /\ len = _len - off /\ 0 < len /\ 0 <= off
         /\ buf0 = A.fill (fun i => (SQUEEZE1600 _r8 _len (st4x_get (A101u64toA25u256 _st) 0)).[i]) 0 off _b0
         /\ buf1 = A.fill (fun i => (SQUEEZE1600 _r8 _len (st4x_get (A101u64toA25u256 _st) 1)).[i]) 0 off _b1
         /\ buf2 = A.fill (fun i => (SQUEEZE1600 _r8 _len (st4x_get (A101u64toA25u256 _st) 2)).[i]) 0 off _b2
         /\ buf3 = A.fill (fun i => (SQUEEZE1600 _r8 _len (st4x_get (A101u64toA25u256 _st) 3)).[i]) 0 off _b3
         /\ r8 = _r8 /\ st = _st /\ ststatus_r8 _st.[100] = _r8 /\ 0 < _r8 <= 200 /\ 0 < _len <= _ASIZE).
  + wp; ecall (keccakf1600_avx2x4_h stk); ecall (dump_updstate_avx2x4_h buf0 buf1 buf2 buf3 off stk at r8).
    skip => &hr [#] Hm -> -> El Hl0 Ho0 -> -> -> -> -> -> Er Hr0 Hr1 Hn0 Hn1 Hc /=.
    split; first smt().
    move=> _ [a o b0 b1 b2 b3] [/= -> [-> [-> [-> [_ ->]]]]] r ->.
    have Ek : off{hr} %/ _r8 * _r8 = off{hr} by have := divz_eq off{hr} _r8; smt().
    have Ed : (off{hr} + _r8) %/ _r8 = off{hr} %/ _r8 + 1 by rewrite divzDr //; smt(divzz).
    have Hk0 : 0 <= off{hr} %/ _r8 by smt(divz_ge0).
    have R : forall k, 0 <= k < 4 => forall (b: W8.t A.t),
             A.fill (fun j => (stbytes (FIPS202_SHA3_Spec.st_i (st4x_get (A101u64toA25u256 _st) k) (off{hr} %/ _r8 + 1))).[j - off{hr}]) off{hr} _r8
                    (A.fill (fun j => (SQUEEZE1600 _r8 _len (st4x_get (A101u64toA25u256 _st) k)).[j]) 0 off{hr} b)
             = A.fill (fun j => (SQUEEZE1600 _r8 _len (st4x_get (A101u64toA25u256 _st) k)).[j]) 0 (off{hr} + _r8) b.
    + move=> k Hk b; have := rsq_step_len (st4x_get (A101u64toA25u256 _st) k) _r8 _len (off{hr} %/ _r8) _r8 b _ _ _ _; [smt() | smt() | smt() | smt() | by rewrite Ek].
    rewrite !st4x_get_iter 1..8:/# !R // Ed iterS 1:/# /keccak_f1600_x4 /=.
    by rewrite (: off{hr} %/ _r8 + 2 = off{hr} %/ _r8 + 1 + 1) 1:// iterS 1:/# iterS 1:/#; smt(modzDr).
  wp; ecall (keccakf1600_avx2x4_h stk); wp; skip => &hr [#] -> -> -> -> -> -> Er Ea Hr0 Hr1 Hl0 Hl1 -> -> /=.
  move=> r ->; have F0 : forall (f: int -> W8.t) (b: W8.t A.t), A.fill f 0 0 b = b by move=> f b; rewrite A.fillE; apply A.tP => k Hk; rewrite A.initiE //= /#.
  by rewrite !F0 iter1 /keccak_f1600_x4 /A101u64toA25u256 /=; smt().
seq 2 : (buf0 = A.fill (fun i => (SQUEEZE1600 _r8 _len (st4x_get (A101u64toA25u256 _st) 0)).[i]) 0 _len _b0
         /\ buf1 = A.fill (fun i => (SQUEEZE1600 _r8 _len (st4x_get (A101u64toA25u256 _st) 1)).[i]) 0 _len _b1
         /\ buf2 = A.fill (fun i => (SQUEEZE1600 _r8 _len (st4x_get (A101u64toA25u256 _st) 2)).[i]) 0 _len _b2
         /\ buf3 = A.fill (fun i => (SQUEEZE1600 _r8 _len (st4x_get (A101u64toA25u256 _st) 3)).[i]) 0 _len _b3
         /\ stk = iter ((_len - 1) %/ _r8 + 1) keccak_f1600_x4 (A101u64toA25u256 _st) /\ at = (_len - 1) %% _r8 + 1
         /\ st = _st /\ ststatus_r8 _st.[100] = _r8 /\ 0 < _r8 <= 200).
+ wp; ecall (dump_updstate_avx2x4_h buf0 buf1 buf2 buf3 off stk at len); wp.
  skip => &hr [#] Hm -> -> El Hl0 Hl1 Ho0 -> -> -> -> Er -> Er8 Hr0 Hr1 Hn0 Hn1 /=.
  split; first smt().
  move=> _ [a o b0 b1 b2 b3] [/= -> [-> [-> [-> [-> _]]]]].
  have Ek : off{hr} %/ _r8 * _r8 = off{hr} by have := divz_eq off{hr} _r8; smt().
  have El1 : _len - 1 = off{hr} %/ _r8 * _r8 + (len{hr} - 1) by smt().
  have Hlr : 0 <= len{hr} - 1 < `|_r8| by smt().
  have Eq : (_len - 1) %/ _r8 = off{hr} %/ _r8 by rewrite El1 divzMDl 1:/# (divz_small _ _ Hlr).
  have Em : (_len - 1) %% _r8 + 1 = len{hr} by rewrite El1 modzMDl (modz_small _ _ Hlr).
  have R : forall k, 0 <= k < 4 => forall (b: W8.t A.t),
           A.fill (fun j => (stbytes (FIPS202_SHA3_Spec.st_i (st4x_get (A101u64toA25u256 _st) k) (off{hr} %/ _r8 + 1))).[j - off{hr}]) off{hr} len{hr}
                  (A.fill (fun j => (SQUEEZE1600 _r8 _len (st4x_get (A101u64toA25u256 _st) k)).[j]) 0 off{hr} b)
           = A.fill (fun j => (SQUEEZE1600 _r8 _len (st4x_get (A101u64toA25u256 _st) k)).[j]) 0 _len b.
  + move=> k Hk b; have := rsq_step_len (st4x_get (A101u64toA25u256 _st) k) _r8 _len (off{hr} %/ _r8) len{hr} b _ _ _ _.
    + smt().
    + smt().
    + smt().
    + smt().
    by rewrite Ek (: off{hr} + len{hr} = _len) 1:/#.
  rewrite !st4x_get_iter 1..8:/# !R // Eq Em /=.
  smt().
seq 1 : (st = A25u256toA101u64 stk _st.[100]
         /\ buf0 = A.fill (fun i => (SQUEEZE1600 _r8 _len (st4x_get (A101u64toA25u256 _st) 0)).[i]) 0 _len _b0
         /\ buf1 = A.fill (fun i => (SQUEEZE1600 _r8 _len (st4x_get (A101u64toA25u256 _st) 1)).[i]) 0 _len _b1
         /\ buf2 = A.fill (fun i => (SQUEEZE1600 _r8 _len (st4x_get (A101u64toA25u256 _st) 2)).[i]) 0 _len _b2
         /\ buf3 = A.fill (fun i => (SQUEEZE1600 _r8 _len (st4x_get (A101u64toA25u256 _st) 3)).[i]) 0 _len _b3
         /\ stk = iter ((_len - 1) %/ _r8 + 1) keccak_f1600_x4 (A101u64toA25u256 _st) /\ at = (_len - 1) %% _r8 + 1
         /\ ststatus_r8 _st.[100] = _r8 /\ 0 < _r8 <= 200).
+ by wp; skip => &hr [#] H0 H1 H2 H3 H4 H5 -> H6 H7 H8 /=; rewrite A25u256toA101u64E.
wp; skip => &hr [-> [H0 [H1 [H2 [H3 [-> [-> [Er [Hr0 Hr1]]]]]]]]]; rewrite (: 32 * 25 = 800) // A101_set800.
have /= [Wa [Wr Wt]] := ststatus_byte0 (pack8_t (W8u8.Pack.init (fun j => if j = 0 then truncateu8 (W64.of_int ((_len - 1) %% _r8 + 1)) else _st.[100] \bits8 j)))
                                       _st.[100] (truncateu8 (W64.of_int ((_len - 1) %% _r8 + 1))) _.
+ by move=> j Hj; rewrite W8u8.pack8bE // W8u8.Pack.initiE.
have Tb : W8.to_uint (truncateu8 (W64.of_int ((_len - 1) %% _r8 + 1))) = (_len - 1) %% _r8 + 1.
+ by rewrite /truncateu8 W8.of_uintK W64.of_uintK; smt(modz_small modz_ge0 ltz_pmod pow2_64).
rewrite /= A101u64toA25u256K /A25u256toA101u64 Array101.initiE //= Wa Wr Wt Tb /=.
by rewrite H0 H1 H2 H3.
qed.

phoare squeeze_updstate_avx2x4_ph _b0 _b1 _b2 _b3 _st _r8 _len:
  [ MM._squeeze_updstate_avx2x4
  : buf0 = _b0 /\ buf1 = _b1 /\ buf2 = _b2 /\ buf3 = _b3 /\ len = _len /\ st = _st
    /\ ststatus_r8 _st.[100] = _r8 /\ ststatus_at_norm _st.[100] = 0
    /\ 0 < _r8 <= 200 /\ 0 < _len <= _ASIZE
  ==> let stk = A101u64toA25u256 _st in
      res.`2 = A.fill (fun i => (SQUEEZE1600 _r8 _len (st4x_get stk 0)).[i]) 0 _len _b0
    /\ res.`3 = A.fill (fun i => (SQUEEZE1600 _r8 _len (st4x_get stk 1)).[i]) 0 _len _b1
    /\ res.`4 = A.fill (fun i => (SQUEEZE1600 _r8 _len (st4x_get stk 2)).[i]) 0 _len _b2
    /\ res.`5 = A.fill (fun i => (SQUEEZE1600 _r8 _len (st4x_get stk 3)).[i]) 0 _len _b3
    /\ A101u64toA25u256 res.`1 = iter ((_len - 1) %/ _r8 + 1) keccak_f1600_x4 stk
    /\ ststatus_at res.`1.[100] = (_len - 1) %% _r8 + 1
    /\ ststatus_r8 res.`1.[100] = _r8
    /\ ststatus_trailb res.`1.[100] = ststatus_trailb _st.[100]
  ] = 1%r.
proof.
by conseq squeeze_updstate_avx2x4_ll
       (squeeze_updstate_avx2x4_h _b0 _b1 _b2 _b3 _st _r8 _len).
qed.

end KeccakUpdstateAvx2x4.
