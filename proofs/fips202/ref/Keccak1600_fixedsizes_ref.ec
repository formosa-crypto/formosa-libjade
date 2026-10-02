(******************************************************************************
   Keccak1600_fixedsizes_ref.ec:

   Correctness proof for the Keccak (fixed-sized) memory absorb/squeeze
  REF implementation



******************************************************************************)

require import List Real Distr Int IntDiv CoreMap.

from Jasmin require import JModel.

from CryptoSpecs require export Keccakf1600_Spec.

from JazzEC require import Keccak1600_Jazz.

from JazzEC require import WArray200.
from JazzEC require import Array25.

require import JWordList.
from CryptoSpecs require import FIPS202_Keccakf1600.
from CryptoSpecs require import FIPS202_SHA3_Spec Keccakf1600_Spec.


require import Keccak1600_ref Keccakf1600_ref.
require import Keccakf1600.
require import Keccak1600_subreadwrite.

require import StdOrder.
import IntOrder.

require import BitEncoding.
import BitEncoding.BitChunking.

(* ------------------------------------------------------------------------ *)
(* Generic spec / memread helpers.                                          *)
(* Copied verbatim from amd64/avx2/Keccak1600_fixedsizes_avx2.ec (these are *)
(* representation-agnostic: no AVX2 types appear).  `memread_split` is NOT   *)
(* copied — CryptoSpecs JWordList already provides the same statement.       *)
(* ------------------------------------------------------------------------ *)

lemma bytes2state_cat l1 l2:
 bytes2state (l1++l2)
 = addstate (bytes2state l1) (bytes2state (u8zeros (size l1)++l2)).
proof.
rewrite -bytes2stbytesP.
have: bytes2stbytes (l1 ++ l2)
      = stbytes (addstate (bytes2state l1) (bytes2state (u8zeros (size l1) ++ l2))).
 rewrite tP stbytes_addstate => i Hi.
 rewrite /addstbytes map2iE // -!bytes2stbytesP !stwordsK !get_of_list // !nth_cat size_nseq ler_maxr.
  smt(size_ge0).
 case: (i < size l1) => C.
  by rewrite nth_u8zeros.
 by rewrite (nth_out _ l1) 1:/#.
by move => ->; rewrite stbytesK.
qed.

lemma stateabsorb_iblocks_rcons l x st:
 stateabsorb_iblocks (rcons l x) st
 = keccak_f1600_op (stateabsorb (stateabsorb_iblocks l st) x).
proof. by rewrite /stateabsorb_iblocks foldl_rcons /=. qed.

(* ------------------------------------------------------------------------ *)
(* Bridges between the extracted WArray200 word-stores and the abstract       *)
(* addstate_at / addstate operations.  These are what let the memory-based    *)
(* `__addstate_m` proof reason at the byte-list level.                        *)
(* ------------------------------------------------------------------------ *)

(* addstate_at st at l  =  XOR the byte list l into st at byte offset `at`.
   This identifies it with the generic `addstate` of the zero-padded list,
   which is the form the outer absorb proof (and bytes2state_cat) consumes. *)
lemma addstate_atE st at l:
 0 <= at =>
 addstate_at st at l = addstate st (bytes2state (u8zeros at ++ l)).
proof.
move=> Hat.
apply stbytes_inj.
rewrite /addstate_at stwordsK stbytes_addstate.
have ->: stbytes (bytes2state (u8zeros at ++ l)) = bytes2stbytes (u8zeros at ++ l).
 by rewrite -bytes2stbytesP stwordsK.
rewrite /addstbytes tP => i Hi.
rewrite filliE 1:// map2iE 1:// get_of_list 1:// nth_cat size_nseq ler_maxr 1:/# nth_u8zeros.
smt(nth_out nth_change_dfl W8.xorw0).
qed.

lemma u64bits8_xor (a b: W64.t) j:
 (a `^` b) \bits8 j = (a \bits8 j) `^` (b \bits8 j).
proof.
apply W8.wordP => k hk.
by rewrite W8.xorwE !bits8iE //.
qed.

lemma u128bits8_xor (a b: W128.t) j:
 (a `^` b) \bits8 j = (a \bits8 j) `^` (b \bits8 j).
proof.
apply W8.wordP => k hk.
by rewrite W8.xorwE !bits8iE //.
qed.

lemma u256bits8_xor (a b: W256.t) j:
 (a `^` b) \bits8 j = (a \bits8 j) `^` (b \bits8 j).
proof.
apply W8.wordP => k hk.
by rewrite W8.xorwE !bits8iE //.
qed.

lemma get64_bits8 (t: WArray200.t) o j:
 0 <= j < 8 =>
 (get64_direct t o) \bits8 j = t.[o + j].
proof. by move=> hj; rewrite get64E pack8bE 1:/# W8u8.Pack.initiE 1:// /=. qed.

lemma get128_bits8 (t: WArray200.t) o j:
 0 <= j < 16 =>
 (get128_direct t o) \bits8 j = t.[o + j].
proof. by move=> hj; rewrite get128E pack16bE 1:/# W16u8.Pack.initiE 1:// /=. qed.

lemma get256_bits8 (t: WArray200.t) o j:
 0 <= j < 32 =>
 (get256_direct t o) \bits8 j = t.[o + j].
proof. by move=> hj; rewrite get256E pack32bE 1:/# W32u8.Pack.initiE 1:// /=. qed.

(* Single u64 store bridge: XORing a word into stbytes at offset o (the shape
   emitted by the extractor: `stwords (set64_direct (stbytes st) o (get64 .. ^ w))`)
   equals adding the word's 8 bytes at offset o. *)
lemma set64_addstate_at st o w:
 0 <= o => (*o + 8 <= 200 =>*)
 stwords (set64_direct (stbytes st) o (get64_direct (stbytes st) o `^` w))
 = addstate_at st o (u64bytes w).
proof.
move=> H0 (*H1*); apply stbytes_inj; rewrite stwordsK /addstate_at stwordsK tP => i Hi.
have Hsz: size (u64bytes w) = 8 by rewrite /u64bytes size_to_list.
rewrite set64E initiE 1:// filliE 1:// Hsz.
case: (o <= i < o + 8) => C; last by rewrite iffalse 1:/#.
rewrite iftrue 1://.
by rewrite get_u64bytes u64bits8_xor get64_bits8 1:/# (:o + (i-o) = i) 1:/#.
qed.

lemma set128_addstate_at st o w:
 0 <= o => (*o + 16 <= 200 =>*)
 stwords (set128_direct (stbytes st) o (get128_direct (stbytes st) o `^` w))
 = addstate_at st o (u128bytes w).
proof.
move => Ho1 (*Ho2*); apply stbytes_inj; rewrite stwordsK /addstate_at stwordsK tP => i Hi.
have Hsz: size (u128bytes w) = 16 by rewrite /u128bytes size_to_list.
rewrite set128E initiE 1:// filliE 1:// Hsz.
case: (o <= i < o + 16) => C; last by rewrite iffalse 1:/#.
rewrite iftrue 1://.
by rewrite get_u128bytes u128bits8_xor get128_bits8 1:/# (:o + (i-o) = i) 1:/#.
qed.

lemma set256_addstate_at st o w:
 0 <= o => (*o + 32 <= 200 =>*)
 stwords (set256_direct (stbytes st) o (get256_direct (stbytes st) o `^` w))
 = addstate_at st o (u256bytes w).
proof.
move => Ho1 (*Ho2*); apply stbytes_inj; rewrite stwordsK /addstate_at stwordsK tP => i Hi.
have Hsz: size (u256bytes w) = 32 by rewrite /u256bytes size_to_list.
rewrite set256E initiE 1:// filliE 1:// Hsz.
case: (o <= i < o + 32) => C; last by rewrite iffalse 1:/#.
rewrite iftrue 1://.
by rewrite get_u256bytes u256bits8_xor get256_bits8 1:/# (:o + (i-o) = i) 1:/#.
qed.

(* Append/decomposition of addstate_at: XORing (l1 ++ l2) at offset `at` is
   XORing l1 at `at` then l2 at `at + size l1`.  Drives the loop invariants in
   `addstate_m_h`.  ADMIT — STRATEGY: rewrite all three occurrences with
   `addstate_atE`, then `bytes2state_cat` + `addstateA`; the position bookkeeping
   `u8zeros at ++ l1 ++ l2` vs `u8zeros (at+size l1) ++ l2` matches after
   `size_cat`/`size_nseq`.  (Alternatively prove directly by WArray200.filliE
   byte-wise, three-way split i<at / window / after.) *)
(* word-indexed XOR of a u64 into the state (array variant's scalar loop) *)
lemma setw_addstate_at (st: W64.t Array25.t) k w:
 0 <= k < 25 =>
 st.[k <- st.[k] `^` w] = addstate_at st (8*k) (u64bytes w).
proof.
move=> Hk; rewrite -set64_addstate_at 1:/#.
have E: forall i, 0 <= i < 25 => WArray200.get64 (stbytes st) i = st.[i].
 by move=> i Hi; rewrite -{2}(stbytesK st) initiE.
rewrite tP => i Hi; rewrite get_setE // initiE //= WArray200.get_set64E 1,2:/#.
by rewrite !E.
qed.

lemma addstate_at_cat st at l1 l2:
 0 <= at =>
(* at + size l1 + size l2 <= 200 =>*)
 addstate_at st at (l1 ++ l2)
 = addstate_at (addstate_at st at l1) (at + size l1) l2.
proof.
move=> H0 (*H1*); rewrite !addstate_atE; 1..3:smt(size_cat size_ge0).
rewrite catA bytes2state_cat addstateA; congr.
by rewrite size_cat size_nseq; congr; congr; congr; congr; smt().
qed.

(*
   ONE-SHOT (FIXED-SIZE) MEMORY ABSORB
   ===================================
*)

lemma addstate_m_ll: islossless M.__addstate_m.
proof.
(* This proof script is independent of selected `KECCAK_FEATURES` *)
proc.
swap 1 1.
seq 1: true => />; 1:auto; 1:islossless; last by hoare; auto.
seq 1: #pre => //; first inline*; auto.
if => //.
 seq 3: true => />; 1,4:auto; 2: islossless.
 while true (_LEN %/ 32 - i).
  by move=> z; auto; smt().
 by auto; smt().
seq 2: true => />; 1,4:auto; 2: islossless.
while true (aT + _LEN %/ 8 *8 - at).
 by move=> z; auto; smt().
by auto => /> /#.
qed.

(* (cur0,cur') is an abstract input cursor (memory pointer `buf` / array
   `offset`): the consumed count is recoverable from the remaining data, so
   the cursor is pinned by `cur' = cur0 + (size l - len')`. *)
op addstate_spec st at l tb sz cur0 cur' st' at' len' tb' =
 0 <= at
 /\ st' = addstate st (bytes2state (take sz (u8zeros at ++ l ++[of_int tb])))
 /\ len' = (if at < sz then max 0 (at + size l - sz) else size l)
 /\ at' = max at (min sz (at + size l + b2i (tb<>0)))
 /\ tb' = (if at+size l < sz then 0 else tb)
 /\ cur' = cur0 + (size l - len').


(*
H: msubread _mem (u64bytes w0) (8 * (_at %/ 8)) _at _buf _len _tb at0 buf0
     len0 tb0
------------------------------------------------------------------------
addstate_AT base (8 * b2i true) _st _at (memread _mem _buf _len) _tb
  (stwords
     (set64 (stbytes _st) (_at %/ 8) (get64 (stbytes _st) (_at %/ 8) `^` w0)))
  at0 len0 tb0
*)

lemma addstate_spec_init st at l tb sz cur0 cur1 st1 at1 len1 tb1:
 0 <= sz <= at =>
 cur1=cur0 => st1=st => at1=at => len1=size l => tb1=tb =>
 addstate_spec st at l tb sz cur0 cur1 st1 at1 len1 tb1.
proof.
move => Hsz />; split; first smt().
split.
 rewrite -catA take_cat' size_nseq ifT 1:/# take_nseq -cat0s bytes2state_zext bytes2state0.
 by rewrite addstateC addstate_st0.
smt(size_ge0).
qed.
 
lemma addstate_spec_len st at l tb sz cur0 cur1 st1 at1 len1 tb1:
 addstate_spec st at l tb sz cur0 cur1 st1 at1 len1 tb1 =>
 0 <= len1 <= size l.
proof. move=> />; smt(size_ge0). qed.

lemma addstate_spec_cur st at l tb sz cur0 cur1 st1 at1 len1 tb1:
 addstate_spec st at l tb sz cur0 cur1 st1 at1 len1 tb1 =>
 cur1 = cur0 + (size l - len1).
proof. by move=> />. qed.

lemma addstate_spec_sz st at l tb sz cur0 cur1 st1 at1 len1 tb1:
 at <= sz =>
 (0 < len1 \/ tb1<>0) =>
 addstate_spec st at l tb sz cur0 cur1 st1 at1 len1 tb1 =>
 at1 = sz.
proof. by move => />* /#. qed.

lemma addstate_spec_finished st at l tb sz cur0 cur1 st1 at1 len1 tb1:
 len1=0 => tb1=0 =>
 addstate_spec st at l tb sz cur0 cur1 st1 at1 len1 tb1 =>
 st1 = addstate_at st at (l++[of_int tb]) /\ at1 = at+size l+b2i (tb<>0).
proof.
move => /> Hat.
case: (at<sz) => C1.
 move => ?.
 have ?: at+size l <= sz by smt(size_ge0).
 case: (at + size l = sz) => C2 ?.
  have ->: tb=0 by smt(size_ge0).
  rewrite addstate_atE 1:/#.
  split; last smt().
  rewrite take_cat' size_cat size_nseq ler_maxr 1:/# C2 /= take_oversize.
   by rewrite size_cat size_nseq ler_maxr /#.
  by rewrite catA -nseq1 bytes2state_zext.
 rewrite take_oversize.
  by rewrite !size_cat size_nseq /= /#.
 by rewrite addstate_atE 1:/# catA; smt(size_ge0).
rewrite eq_sym => /size_eq0 -> /=.
rewrite C1 /= => <-; split; last smt(size_ge0).
rewrite addstate_atE 1:/# cats0 take_cat' size_nseq ifT 1:/# take_nseq -nseq1 bytes2state_zext.
by rewrite -cat0s bytes2state_zext bytes2state0 -cat0s bytes2state_zext bytes2state0.
qed.

lemma bytes2state_nthE l1 l2:
 (forall i, 0 <= i < 200 => nth W8.zero l1 i = nth W8.zero l2 i) =>
 bytes2state l1 = bytes2state l2.
proof.
move=> H; rewrite -!bytes2stbytesP; apply stbytes_inj; rewrite !stwordsK tP => i Hi.
by rewrite !get_of_list 1..2:// H.
qed.

(* A word read by `srspec` at offset `cur` is the `size lw`-byte window of the
   padded stream `u8zeros at ++ l ++ [tb]` starting at `cur` (generic in the
   word size: reused for the u64/u128/u256 reads). *)
lemma srspec_window lw cur at l len tb:
 srpre cur at l len tb =>
 srspec lw cur at l len tb =>
 bytes2state (u8zeros cur ++ lw)
 = bytes2state (take (cur + size lw) (u8zeros at ++ l ++ [W8.of_int tb])).
proof.
move=> Hpre Hspec; have [_ /u8prefAbsorbP Hp] := Hspec Hpre.
move: Hpre; rewrite /srpre => |> Hcur Hat Htb0 Htb1 Hor.
apply bytes2state_nthE => i Hi.
rewrite nth_cat size_nseq ler_maxr // nth_nseq_if cats1.
case: (i < cur + size lw) => C.
 rewrite nth_take; 1,2: smt(size_ge0).
 rewrite nth_rcons size_cat size_nseq ler_maxr // nth_cat size_nseq ler_maxr // nth_nseq_if Hp.
 by case: Hor => [Hle|[-> ->]]; smt(nth_out size_ge0).
rewrite nth_out; first smt(size_take size_ge0).
rewrite nth_out; first smt(size_take size_ge0).
by case: (i < cur).
qed.

(* ------------------------------------------------------------------
   SHARED read-step layer (list-generic: used by the memory and the array
   variants; the input is an abstract byte list `l` and the data still to be
   read is `drop (size l - len0) l`).
   ------------------------------------------------------------------ *)

(* A full in-data word read at the aligned position (any trailing byte). *)
lemma srspec_full lw cur l len tb:
 size lw <= size l =>
 u8prefAt lw 0 l =>
 srspec lw cur cur l len tb.
proof.
move=> Hsz Hw Hpre; split; first by apply srpre_next => //; apply size_ge0.
by rewrite (_: cur - cur = 0) 1:// u8prefAbsorbW.
qed.

(* One read step of an arbitrary word `lw` (srspec at offset `cur`): `stc` is the
   state after the first `cur` bytes; the word is XORed into it at `cur`. *)
lemma addstate_spec_step (l lw: W8.t list) cur st at tb stc c0 c at0 len0 tb0 cur1 c1 at1 len1 tb1:
 0 <= at => 0 <= tb < 256 =>
 0 <= cur <= at0 < cur + size lw =>
 cur1 = cur + size lw =>
 at1 = srat (size lw) cur at0 len0 tb0 =>
 c1 = c + srincr (size lw) cur at0 len0 =>
 len1 = srlen (size lw) cur at0 len0 =>
 tb1 = srtb (size lw) cur at0 len0 tb0 =>
 addstate_spec st at l tb cur c0 c stc at0 len0 tb0 =>
 srspec lw cur at0 (drop (size l - len0) l) len0 tb0 =>
 addstate_spec st at l tb cur1 c0 c1 (addstate_at stc cur lw) at1 len1 tb1.
proof.
move => |> Hat Htb0 Htb1 Hcur Hat0_1 Hat0_2; rewrite /addstate_spec addstate_atE // Hat /= => [#].
move => Hst0 ->> ->> ->> ->> Hspec.
split.
 rewrite Hst0 -addstateA; congr.
 rewrite (srspec_window _ _ _ _ _ _ _ Hspec); first by rewrite /srpre size_drop; smt(size_ge0).
 pose S := u8zeros at ++ l ++ [W8.of_int tb].
 have Hsz: size (take cur S) = cur.
  by rewrite size_take // /S !size_cat size_nseq /=; move: Hat0_1; rewrite /b2i; smt(size_ge0).
 rewrite (takeD S cur (size lw)) 1:/# 1:size_ge0 bytes2state_cat Hsz; congr.
 apply bytes2state_nthE => i Hi.
 have nthT: forall (s: W8.t list) n j, 0 <= n => nth W8.zero (take n s) j = if j < n then nth W8.zero s j else W8.zero.
  move=> s n j Hn; case: (j < n) => C; first by rewrite nth_take.
  by rewrite nth_out //; smt(size_take size_ge0).
 have nthD: forall k j, 0 <= k => nth W8.zero (drop k l) j = if 0 <= j then nth W8.zero l (k + j) else W8.zero.
  move=> k j Hk; case: (0 <= j) => C; first by rewrite nth_drop.
  by rewrite nth_neg 1:/#.
 move: Hat0_1 Hat0_2; rewrite /b2i => Hat0_1 Hat0_2.
 rewrite nthT 1:/# (nth_cat _ (u8zeros cur)) size_nseq (_: max 0 cur = cur) 1:/# nth_nseq_if.
 case: (i < cur) => C1 /=.
  by rewrite ifT 1:/# -catA (nth_cat _ (u8zeros _)) size_nseq ifT 1:/# nth_nseq_if /#.
 rewrite nthT 1:size_ge0 nth_drop 1,2:/# /S (_: cur + (i - cur) = i) 1:/#.
 case: (i < cur + size lw) => C2; last by rewrite ifF 1:/#.
 rewrite (_: (i - cur < size lw) = true) 1:/# /=.
 have Hk: 0 <= size l - (if at < cur then max 0 (at + size l - cur) else size l) by smt(size_ge0).
 rewrite !cats1 !nth_rcons !size_cat !size_nseq !size_drop // !nth_cat !size_nseq !nth_nseq_if !nthD //.
 smt(nth_out size_ge0).
do 3! (split; first by rewrite /srincr /srfnsh /b2i /=; smt(size_ge0)).
by rewrite /srincr /srfnsh /b2i /=; smt(size_ge0).
qed.

(* While data remains, the absorbed position plus the remaining length is the end of the input. *)
lemma addstate_spec_fit st at l tb sz c0 c st' at' len' tb':
 at <= sz => 0 < len' =>
 addstate_spec st at l tb sz c0 c st' at' len' tb' =>
 at' + len' = at + size l.
proof. by move=> Hsz Hl; rewrite /addstate_spec => [#] _ _ El Ea _ _; smt(size_ge0). qed.

(* One aligned, full in-data word (any size): the shared step of every plain load. *)
lemma addstate_spec_fullword (l lw: W8.t list) sz st at tb stc c0 c at0 len0 tb0 sz1 c1 at1 len1:
 0 <= at => 0 <= tb < 256 => at <= sz => 0 < size lw <= len0 =>
 sz1 = sz + size lw => c1 = c + size lw => at1 = at0 + size lw => len1 = len0 - size lw =>
 addstate_spec st at l tb sz c0 c stc at0 len0 tb0 =>
 u8prefAt lw 0 (drop (size l - len0) l) =>
 addstate_spec st at l tb sz1 c0 c1 (addstate_at stc at0 lw) at1 len1 tb0.
proof.
move=> Hat Htb Hsz Hlw -> -> -> -> H Hw.
have Ea: at0 = sz by apply (addstate_spec_sz _ _ _ _ _ _ _ _ _ _ _ Hsz _ H); smt().
move: H; rewrite Ea => H.
have [Hl0 Hl1] := addstate_spec_len _ _ _ _ _ _ _ _ _ _ _ H.
apply (addstate_spec_step l lw sz st at tb stc c0 c sz len0 tb0) => //.
+ smt().
+ by rewrite /srincr /srfnsh /b2i /=; smt().
+ by rewrite /srincr; smt().
+ by rewrite /srincr; smt().
+ by rewrite /srfnsh; smt().
by apply srspec_full => //; rewrite size_drop; smt().
qed.

(* The trailing byte is absorbed only when non-zero (a zero byte is a no-op). *)
lemma addstate_at_trail st at l tb:
 0 <= at =>
 addstate_at st at (l ++ [W8.of_int tb])
 = addstate_at st at (l ++ if tb <> 0 then [W8.of_int tb] else []).
proof.
move=> Hat; case: (tb <> 0) => // /= ->.
by rewrite cats0 !addstate_atE // catA -nseq1 bytes2state_zext.
qed.

(* The addstate_at postcondition in additive form, with the trailing byte explicit. *)
lemma addstate_at_bytes st at l tb:
 0 <= at =>
 addstate_at st at (l ++ if tb <> 0 then [W8.of_int tb] else [])
 = addstate st (bytes2state (u8zeros at ++ l ++ [W8.of_int tb])).
proof. by move=> Hat; rewrite -addstate_at_trail // addstate_atE // catA. qed.

(* Finishing with the last (aligned, partial) word read at at0. *)
lemma addstate_spec_finish (l lw: W8.t list) n sz st at tb stc c0 c at0 len0 tb0 at1 c1:
 size l = n => 0 <= at => 0 <= tb < 256 => at <= sz => size lw = 8 => len0 < 8 =>
 (0 < len0 \/ tb0 <> 0) =>
 at1 = srat 8 at0 at0 len0 tb0 => c1 = c + srincr 8 at0 at0 len0 =>
 addstate_spec st at l tb sz c0 c stc at0 len0 tb0 =>
 srspec lw at0 at0 (drop (size l - len0) l) len0 tb0 =>
 addstate_at stc at0 lw = addstate_at st at (l ++ if tb <> 0 then [W8.of_int tb] else [])
 /\ at1 = at + n + b2i (tb <> 0) /\ c1 = c0 + n.
proof.
move=> <- Hat Htb Hsz Hlw Hl Hg -> -> H Hsr.
have Ea: at0 = sz by apply (addstate_spec_sz _ _ _ _ _ _ _ _ _ _ _ Hsz _ H).
move: H; rewrite -Ea => H.
have [Hl0 _] := addstate_spec_len _ _ _ _ _ _ _ _ _ _ _ H.
have H': addstate_spec st at l tb (at0 + 8) c0 (c + srincr 8 at0 at0 len0) (addstate_at stc at0 lw)
          (srat 8 at0 at0 len0 tb0) (srlen 8 at0 at0 len0) (srtb 8 at0 at0 len0 tb0).
 by apply (addstate_spec_step l lw at0 st at tb stc c0 c at0 len0 tb0) => //; rewrite ?Hlw //; smt().
have [Hf1 Hf2]: srlen 8 at0 at0 len0 = 0 /\ srtb 8 at0 at0 len0 tb0 = 0 by rewrite /srincr /srfnsh /=; smt().
have [Hst Hat1] := addstate_spec_finished _ _ _ _ _ _ _ _ _ _ _ Hf1 Hf2 H'.
have Hc := addstate_spec_cur _ _ _ _ _ _ _ _ _ _ _ H'.
by rewrite Hst addstate_at_trail // Hat1 Hc Hf1.
qed.

(* Nothing left to read: the stream (and the trailing byte) is already absorbed. *)
lemma addstate_spec_done (l: W8.t list) n sz st at tb stc c0 c at0 tb0:
 size l = n => 0 <= at => 0 <= tb < 256 => tb0 %% 256 = 0 =>
 addstate_spec st at l tb sz c0 c stc at0 0 tb0 =>
 stc = addstate_at st at (l ++ if tb <> 0 then [W8.of_int tb] else [])
 /\ at0 = at + n + b2i (tb <> 0) /\ c = c0 + n.
proof.
move=> <- Hat Htb Hm H.
have Ht: tb0 = 0 by move: H; rewrite /addstate_spec => [#] _ _ _ _ Etb _; smt().
have [Hst Hat1] := addstate_spec_finished _ _ _ _ _ _ _ _ _ _ _ (eq_refl 0) Ht H.
have Hc := addstate_spec_cur _ _ _ _ _ _ _ _ _ _ _ H.
by rewrite Hst addstate_at_trail // Hat1 Hc.
qed.

(* MEMORY instance: the remaining data of the input is the memread at the cursor. *)
lemma addstate_spec_drop_memread st at mem b len tb sz c st' at' len' tb':
 0 <= len =>
 addstate_spec st at (memread mem b len) tb sz b c st' at' len' tb' =>
 drop (size (memread mem b len) - len') (memread mem b len) = memread mem c len'.
proof.
move=> Hlen H.
have Hc := addstate_spec_cur _ _ _ _ _ _ _ _ _ _ _ H.
have [Hl0 Hl1] := addstate_spec_len _ _ _ _ _ _ _ _ _ _ _ H.
move: Hc Hl1; rewrite size_memread // => Hc Hl1.
by rewrite drop_memread 1:/# Hc; congr; ring.
qed.

(* MEMORY instance of the absorb input: the memread at _buf, read through memread. *)
lemma take_memread' mem b len k:
 0 <= k <= len => take k (memread mem b len) = memread mem b k.
proof. by move=> Hk; rewrite take_memread 1:/#; congr; smt(). qed.

lemma slice_memread mem b len k n:
 0 <= k => 0 <= n => k + n <= len =>
 take n (drop k (memread mem b len)) = memread mem (b + k) n.
proof. by move=> Hk Hn Hkn; rewrite drop_memread 1:/# take_memread //; congr; smt(). qed.
lemma drop_memread_cur mem b len c:
 b <= c <= b + len =>
 drop (c - b) (memread mem b len) = memread mem c (len - (c - b)).
proof. by move=> Hc; rewrite drop_memread 1:/#; congr; ring. qed.

(* One u64 msubread step (prefix and last word of the memory absorb). *)
lemma addstate_msubread_u64 mem w cur st at buf len tb stc at0 buf0 len0 tb0 cur1 at1 buf1 len1 tb1:
 0 <= at => 0 <= len => 0 <= tb < 256 =>
 0 <= cur <= at0 < cur+8 =>
 cur1 = cur + 8 =>
 addstate_spec st at (memread mem buf len) tb cur buf buf0 stc at0 len0 tb0 =>
 msubread mem (u64bytes w) cur at0 buf0 len0 tb0 at1 buf1 len1 tb1 =>
 addstate_spec st at (memread mem buf len) tb cur1 buf buf1 (addstate_at stc cur (u64bytes w)) at1 len1 tb1.
proof.
have Hs: size (u64bytes w) = 8 by rewrite /u64bytes size_to_list.
move=> Hat Hlen Htb Hc Hc1 Hspec; rewrite /msubread => [#] Hsr Eat Ebuf Elen Etb.
apply (addstate_spec_step (memread mem buf len) (u64bytes w) cur st at tb stc buf buf0 at0 len0 tb0 cur1 buf1 at1 len1 tb1); rewrite ?Hs //.
by rewrite (addstate_spec_drop_memread _ _ _ _ _ _ _ _ _ _ _ _ Hlen Hspec).
qed.



hoare addstate_m_h _mem _st _at _buf _len _tb:
 M.__addstate_m
 : Glob.mem=_mem /\ st=_st /\ aT=_at /\ buf=_buf /\ _LEN=_len /\ _TRAILB=_tb
 /\ 0 <= _at <= 200
 /\ 0 <= _len
 /\ _at+_len <= 200 - b2i (_tb<>0)
 /\ _buf + _len < W64.modulus
 /\ 0 <= _tb < 256
 ==> let l = memread _mem _buf _len ++ if _tb<>0 then [W8.of_int _tb] else []
     in Glob.mem=_mem
        /\ res.`1 = addstate_at _st _at l
        /\ res.`2 = _at + _len + b2i (_tb<>0)
        /\ res.`3 = _buf + _len.
proof.
(* On the shared read-step layer (input `memread _mem _buf _len`, cursor `buf`):
   the alignment prefix and the final word are addstate_msubread_u64 /
   addstate_spec_finish steps, every plain load is one addstate_spec_fullword
   step.  The array addstate_h has the same structure. *)
proc; simplify.
(* stmts 1-2 : __HAS_FEATURE (hAS_AVX2 kept symbolic) + the alignment prefix. *)
pose base:= 8 * (_at %/ 8).
pose nbase:= 8 * ((_at-1) %/ 8 + 1).
seq 2: (Glob.mem=_mem /\ 0 <= _tb < 256 /\ 0 <= _at <= 200
       /\ 0 <= _len /\ _at + _len <= 200 - b2i (_tb<>0) /\ _buf + _len < W64.modulus
       /\ addstate_spec _st _at (memread _mem _buf _len) _tb nbase _buf buf st aT _LEN _TRAILB).
+ seq 1: (#pre); first by inline*; auto.
  if => //.
   wp; ecall (m_ilen_read_upto8_at_h buf _LEN _TRAILB aT8 aT); auto => |> &m ???????.
   move=> [buf0 len0 tb0 at0 w0] /=.
   move => H; rewrite set64_addstate_at 1:/#.
(* prefix word = one step from the initial spec at base; nbase = base + 8
   since _at is not 8-aligned in this branch. *)
   apply (addstate_msubread_u64 _mem w0 (8 * (_at %/ 8)) _st _at _buf _len _tb _st _at _buf _len _tb nbase at0 buf0 len0 tb0) => //;
    [smt() | by rewrite /nbase; smt() | by apply addstate_spec_init => //; smt(size_memread)].
  auto => |> *.
  have ->@/base: nbase = base by smt().
  by apply addstate_spec_init; smt(size_memread).
(* stmt 3 : if hAS_AVX2 — both branches consume `8*(_LEN%/8)` further aligned bytes. *)
seq 1: (Glob.mem=_mem /\ 0 <= _tb < 256 /\ 0 <= _at <= 200
       /\ 0 <= _len /\ _at + _len <= 200 - b2i (_tb<>0) /\ _buf + _len < W64.modulus
       /\ addstate_spec _st _at (memread _mem _buf _len) _tb (nbase+8*(_LEN%/8)) _buf buf st (aT+8*(_LEN%/8)) (_LEN-8*(_LEN%/8)) _TRAILB /\ 0 <= _LEN).
 if => //.
 - seq 3: (Glob.mem=_mem /\ 0 <= _tb < 256 /\ 0 <= _at <= 200
       /\ 0 <= _len /\ _at + _len <= 200 - b2i (_tb<>0) /\ _buf + _len < W64.modulus
       /\ addstate_spec _st _at (memread _mem _buf _len) _tb (nbase+32*(_LEN%/32)) _buf buf st (aT+32*(_LEN%/32)) (_LEN-32*(_LEN%/32)) _TRAILB /\ 0 <= _LEN).
   while (#[/1:8]pre /\ inc = _LEN%/32 /\
          0 <= i <= _LEN%/32 /\ 
          addstate_spec _st _at (memread _mem _buf _len) _tb (nbase+32*i) _buf buf st (aT+32*i) (_LEN-32*i) _TRAILB).
    auto => |> &m ????????? IH Hb; split; first smt().
    rewrite xorwC set256_addstate_at 1:/#.
    (* u256 step: one shared full-word step. *)
    apply (addstate_spec_fullword _ _ (nbase + 32 * i{m}) _st _at _tb st{m} _buf buf{m} (aT{m} + 32 * i{m}) (_LEN{m} - 32 * i{m}) _TRAILB{m}) => //; rewrite ?size_to_list; 1..5: smt().
    by rewrite (addstate_spec_drop_memread _ _ _ _ _ _ _ _ _ _ _ _ _ IH) //; apply loadW256_memread; smt().
   auto => |> &m ??????? H ?; split. 
have ?: 0<= _LEN{m}.
 move: H; rewrite /addstate_spec => />. smt(size_ge0).
    smt().
   move => buf1 i st1 ???; have ->: i=_LEN{m} %/ 32 by smt().
   by move=> Hs; split => //; smt().
   seq 1: (Glob.mem=_mem /\ 0 <= _tb < 256 /\ 0 <= _at <= 200
       /\ 0 <= _len /\ _at + _len <= 200 - b2i (_tb<>0) /\ _buf + _len < W64.modulus
       /\ addstate_spec _st _at (memread _mem _buf _len) _tb (nbase+16*(_LEN%/16)) _buf buf st (aT+16*(_LEN%/16)) (_LEN-16*(_LEN%/16)) _TRAILB /\ 0 <= _LEN).
   if => //.
     auto => |> &m ??????? IH HL Hb.
     (* u128 16-tail step: one shared full-word step. *)
     rewrite xorwC set128_addstate_at 1:/# (_: aT{m} + _LEN{m} %/ 32 * 32 = aT{m} + 32 * (_LEN{m} %/ 32)) 1:/#.
     apply (addstate_spec_fullword _ _ (nbase + 32 * (_LEN{m} %/ 32)) _st _at _tb st{m} _buf buf{m} (aT{m} + 32 * (_LEN{m} %/ 32)) (_LEN{m} - 32 * (_LEN{m} %/ 32)) _TRAILB{m}) => //; rewrite ?size_to_list; 1..5: smt().
     by rewrite (addstate_spec_drop_memread _ _ _ _ _ _ _ _ _ _ _ _ _ IH) //; apply loadW128_memread; smt().
    auto => |> ??????? H Hb HL.
    (* 16-tail skipped: 16*(_LEN%/16) = 32*(_LEN%/32) when _LEN%%32 < 16. *)
    move => Hc; have E: forall n, !16 <= n %% 32 => 16 * (n %/ 16) = 32 * (n %/ 32) by smt().
    by rewrite !(E _ Hc); exact Hb.
   if => //.
     (* u64 8-tail step: one shared full-word step. *)
     auto => |> &m ??????? H HL Hb.
     rewrite set64_addstate_at 1:/# (_: aT{m} + _LEN{m} %/ 16 * 16 = aT{m} + 16 * (_LEN{m} %/ 16)) 1:/#.
     have Hs: size (u64bytes (loadW64 _mem buf{m})) = 8 by rewrite /u64bytes size_to_list.
     apply (addstate_spec_fullword _ _ (nbase + 16 * (_LEN{m} %/ 16)) _st _at _tb st{m} _buf buf{m} (aT{m} + 16 * (_LEN{m} %/ 16)) (_LEN{m} - 16 * (_LEN{m} %/ 16)) _TRAILB{m}) => //; rewrite ?Hs; 1..5: smt().
     by rewrite (addstate_spec_drop_memread _ _ _ _ _ _ _ _ _ _ _ _ _ H) //; apply loadW64_memread; smt().
    auto => |> ???????? H HL Hb.
    (* 8-tail skipped: 8*(_LEN%/8) = 16*(_LEN%/16) when _LEN%%16 < 8. *)
    have E: forall n, !8 <= n %% 16 => 8 * (n %/ 8) = 16 * (n %/ 16) by smt().
    by rewrite !(E _ Hb); exact H.
 - (* scalar branch: invariant = spec advanced by the (at - aT) bytes consumed. *)
   while (#[/1:8]pre /\ 0 <= _LEN /\ aT <= at <= aT + _LEN %/ 8 * 8 /\ (at - aT) %% 8 = 0 /\
           addstate_spec _st _at (memread _mem _buf _len) _tb (nbase + (at - aT)) _buf buf st at (_LEN - (at - aT)) _TRAILB).
   + auto => |> &m ??????? HL H1 H2 Hm H Hb.
     split; first smt().
     split; first smt().
     (* u64 scalar step: one shared full-word step. *)
     rewrite set64_addstate_at 1:/#.
     have Hs: size (u64bytes (loadW64 _mem buf{m})) = 8 by rewrite /u64bytes size_to_list.
     apply (addstate_spec_fullword _ _ (nbase + (at{m} - aT{m})) _st _at _tb st{m} _buf buf{m} at{m} (_LEN{m} - (at{m} - aT{m})) _TRAILB{m}) => //; rewrite ?Hs; 1..4: smt().
     by rewrite (addstate_spec_drop_memread _ _ _ _ _ _ _ _ _ _ _ _ _ H) //; apply loadW64_memread; smt().
   + auto => |> &m ??????? H Hn.
     have HL: 0 <= _LEN{m} by have := addstate_spec_len _ _ _ _ _ _ _ _ _ _ _ H; smt().
     split; first smt().
     move=> at0 buf0 st0 Hex _ H1 H2 Hm Hs.
     have E: at0 = aT{m} + 8 * (_LEN{m} %/ 8) by smt().
     by move: Hs; rewrite E (_: aT{m} + 8 * (_LEN{m} %/ 8) - aT{m} = 8 * (_LEN{m} %/ 8)) 1:/#.
(* stmts 4-5 : aT += 8*(_LEN/8); _LEN %%= 8 -- pure bookkeeping, the spec carries
   over with sz = nbase + 8*(_LEN/8) (kept existential: not expressible in the new
   _LEN).  stmt 6: the final word is one more step that finishes the stream. *)
seq 2: (Glob.mem=_mem /\ 0 <= _tb < 256 /\ 0 <= _at <= 200
       /\ 0 <= _len /\ _at + _len <= 200 - b2i (_tb<>0) /\ _buf + _len < W64.modulus
       /\ 0 <= _LEN < 8
       /\ exists sz, _at <= sz /\ addstate_spec _st _at (memread _mem _buf _len) _tb sz _buf buf st aT _LEN _TRAILB).
+ auto => |> &m ??????? H HL.
  split; first smt().
  exists (nbase + 8 * (_LEN{m} %/ 8)); split; first smt().
  by rewrite (_: _LEN{m} %% 8 = _LEN{m} - 8 * (_LEN{m} %/ 8)) 1:/#.
if.
+ (* final word: one shared finishing step *)
  wp; ecall (m_ilen_read_upto8_at_h buf _LEN _TRAILB aT aT); auto => |> &m ??????? HL0 HL1 sz Hsz H Hg [buf1 len1 tb1 at1 w] /= Hsub.
  have Hs: size (u64bytes w) = 8 by rewrite /u64bytes size_to_list.
  have Ha: 0 <= aT{m} by move: H; rewrite /addstate_spec => [#] _ _ _ Ea _ _; smt().
  rewrite set64_addstate_at //.
  move: Hsub; rewrite /msubread Hs => [#] Hsr Eat Ebuf _ _.
  apply (addstate_spec_finish (memread _mem _buf _len) (u64bytes w) _len sz _st _at _tb st{m} _buf buf{m} aT{m} _LEN{m} _TRAILB{m} at1 buf1) => //.
  + by rewrite size_memread.
  + smt().
  by rewrite (addstate_spec_drop_memread _ _ _ _ _ _ _ _ _ _ _ _ _ H).
(* nothing left: the stream and the trailing byte are already absorbed *)
auto => |> &m ??????? HL0 HL1 sz Hsz H Hg.
have Hl: _LEN{m} = 0 by smt().
move: H; rewrite Hl => H.
by apply (addstate_spec_done (memread _mem _buf _len) _len sz _st _at _tb st{m} _buf buf{m} aT{m} _TRAILB{m}) => //; [rewrite size_memread | smt()].
qed.

phoare addstate_m_ph _mem _st _at _buf _len _tb:
 [ M.__addstate_m
 : Glob.mem=_mem /\ st=_st /\ aT=_at /\ buf=_buf /\ _LEN=_len /\ _TRAILB=_tb
 /\ 0 <= _at <= 200
 /\ 0 <= _len
 /\ _at+_len <= 200 - b2i (_tb<>0)
 /\ _buf + _len < W64.modulus
 /\ 0 <= _tb < 256 
 ==> let l = memread _mem _buf _len ++ if _tb<>0 then [W8.of_int _tb] else []
     in Glob.mem=_mem
        /\ res.`1 = addstate_at _st _at l
        /\ res.`2 = _at + size l
        /\ res.`3 = _buf + _len
 ] = 1%r.
proof.
by conseq addstate_m_ll (addstate_m_h _mem _st _at _buf _len _tb) => />; smt(size_memread size_cat).
qed.

lemma absorb_m_ll: islossless M.__absorb_m.
proof.
proc; simplify.
seq 2: true => //.
 call addstate_m_ll.
 if => //.
 wp; while true (iTERS-i).
  move=> z; auto.
  call keccakf1600_ll.
  call addstate_m_ll.
  by auto => /#.
 wp; call keccakf1600_ll.
 wp; call addstate_m_ll.
 by auto => /#.
if => //.
by call addratebit_ll.
qed.

(* ------------------------------------------------------------------
   SHARED absorb algebra (list-generic: the input is an abstract list M of
   which the first k bytes are already absorbed; used by the memory and the
   array absorbs).
   ------------------------------------------------------------------ *)

(* Complete the current block: absorb the r8 - a bytes that follow (a is the
   position in the block) and permute.  Covers the first (partial) block
   (k = 0) and every full block (a = 0). *)
lemma pabsorb_fill r8 (l M: W8.t list) k st:
 0 <= k => k + (r8 - (size l + k) %% r8) <= size M =>
 pabsorb_spec_ref r8 (l ++ take k M) st =>
 pabsorb_spec_ref r8 (l ++ take (k + (r8 - (size l + k) %% r8)) M)
   (keccak_f1600_op
     (addstate st (bytes2state (u8zeros ((size l + k) %% r8)
                                ++ take (r8 - (size l + k) %% r8) (drop k M) ++ [W8.zero])))).
proof.
move=> Hk Hfit; rewrite /pabsorb_spec_ref => [[Hr8 Est]]; split => //.
have Ha0: 0 <= (size l + k) %% r8 < r8 by smt(modz_ge0 ltz_pmod).
have HsL: size (l ++ take k M) = size l + k by rewrite size_cat size_take //; smt().
have HsB: size (take (r8 - (size l + k) %% r8) (drop k M)) = r8 - (size l + k) %% r8.
 by rewrite size_take 1:/# size_drop //; smt().
rewrite (takeD M k (r8 - (size l + k) %% r8)) 1,2:/# catA.
pose L := l ++ take k M.
pose B := take (r8 - (size l + k) %% r8) (drop k M).
rewrite (chunk_cat' L) 1:/# (chunk_size _ (chunkremains r8 L ++ B)) 1:/#.
 by rewrite size_cat size_chunkremains HsL HsB; smt().
rewrite (chunkremains_nil r8 (L ++ B)) 1:/#.
 rewrite size_cat HsL HsB; apply dvdzP; exists ((size l + k) %/ r8 + 1); smt(divz_eq).
rewrite (cats1 (chunk r8 L)) stateabsorb_iblocks_rcons bytes2state0 (addstateC _ st0) addstate_st0 /stateabsorb Est.
congr; rewrite -addstateA; congr; first by rewrite /L.
by rewrite /L -nseq1 bytes2state_zext (bytes2state_cat (chunkremains r8 (l ++ take k M))) size_chunkremains HsL.
qed.

(* The final partial block (shorter than a block, so it fits with the trailing
   byte): closes the absorb (tb <> 0) or extends the partial absorb (tb = 0). *)
lemma pabsorb_last r8 (l M: W8.t list) k st tb:
 0 <= k <= size M =>
 (size l + k) %% r8 + (size M - k) < r8 =>
 pabsorb_spec_ref r8 (l ++ take k M) st =>
 (tb <> 0 =>
  addratebit r8 (addstate st (bytes2state (u8zeros ((size l + k) %% r8) ++ drop k M ++ [W8.of_int tb])))
  = ABSORB1600 (W8.of_int tb) r8 (l ++ M))
 /\ (tb = 0 =>
  pabsorb_spec_ref r8 (l ++ M)
    (addstate st (bytes2state (u8zeros ((size l + k) %% r8) ++ drop k M ++ [W8.of_int tb])))).
proof.
move=> Hk Hfit; rewrite /pabsorb_spec_ref => [[Hr8 Est]].
have HsL: size (l ++ take k M) = size l + k by rewrite size_cat size_take //; smt().
have HsR: size (drop k M) = size M - k by rewrite size_drop //; smt().
have EM: l ++ M = (l ++ take k M) ++ drop k M by rewrite -catA cat_take_drop.
have Hsm: size (chunkremains r8 (l ++ take k M) ++ drop k M) < r8.
 by rewrite size_cat size_chunkremains HsL HsR.
have Hch: chunk r8 (l ++ M) = chunk r8 (l ++ take k M).
 by rewrite EM (chunk_cat' (l ++ take k M)) 1:/# (chunk0 r8 (chunkremains r8 (l ++ take k M) ++ drop k M)) // cats0.
have Hcr: chunkremains r8 (l ++ M) = chunkremains r8 (l ++ take k M) ++ drop k M.
 by rewrite EM (chunkremains_cat (l ++ take k M)) 1:/# chunkremains_small.
have Hcat: forall x, bytes2state (chunkremains r8 (l ++ take k M) ++ drop k M ++ [x])
          = addstate (bytes2state (chunkremains r8 (l ++ take k M)))
                     (bytes2state (u8zeros ((size l + k) %% r8) ++ drop k M ++ [x])).
 by move=> x; rewrite -catA bytes2state_cat size_chunkremains HsL catA.
split => Htb.
 rewrite /ABSORB1600 /stateabsorb_last /stateabsorb Hch Hcr -cats1 Hcat Est -addstateA; congr.
split => //; rewrite Hch Hcr Est -addstateA; congr.
by rewrite Htb /= -nseq1 bytes2state_zext (bytes2state_cat (chunkremains r8 (l ++ take k M))) size_chunkremains HsL.
qed.

(* addstate_m_h in the shape of addstate_m_avx2_h (trailing byte always present). *)
hoare addstate_m_h2 _mem _st _at _buf _len _tb:
 M.__addstate_m
 : Glob.mem=_mem /\ st=_st /\ aT=_at /\ buf=_buf /\ _LEN=_len /\ _TRAILB=_tb
 /\ 0 <= _at <= 200
 /\ 0 <= _len
 /\ _at+_len <= 200 - b2i (_tb<>0)
 /\ _buf + _len < W64.modulus
 /\ 0 <= _tb < 256
 ==> Glob.mem=_mem
     /\ res.`1 = addstate _st (bytes2state (u8zeros _at ++ memread _mem _buf _len ++ [W8.of_int _tb]))
     /\ res.`2 = _at + _len + b2i (_tb<>0)
     /\ res.`3 = _buf + _len.
proof.
conseq (addstate_m_h _mem _st _at _buf _len _tb) => /> &m ??????? r -> _ _.
rewrite addstate_atE // catA; case: (_TRAILB{m} <> 0) => [//|/= ->].
by rewrite cats0 -nseq1 bytes2state_zext.
qed.

hoare absorb_m_h _l _mem _buf _len _tb _r8:
 M.__absorb_m
 : Glob.mem=_mem /\ aT=size _l %% _r8 /\ buf=_buf /\ _LEN=_len /\ _RATE8=_r8 /\ _TRAILB=_tb
 /\ pabsorb_spec_ref _r8 _l st
 /\ 0 <= _tb < 256
 /\ 0 <= _len
 /\ _buf + _len < W64.modulus
 ==> Glob.mem = _mem
  /\ if _tb <> 0
     then res.`1 = ABSORB1600 (W8.of_int _tb) _r8 (_l ++ memread _mem _buf _len)
       /\ res.`3 = _buf + _len
     else pabsorb_spec_ref _r8 (_l ++ memread _mem _buf _len) res.`1
       /\ res.`2 = (size _l + _len) %% _r8
       /\ res.`3 = _buf + _len.
proof.
(* `buf - _buf` bytes of the input are absorbed; each block is closed by the shared
   pabsorb_fill and the last one by pabsorb_last (as in absorb_h). *)
proc => /=.
seq 1: (Glob.mem = _mem /\ _RATE8 = _r8 /\ _TRAILB = _tb /\ 0 <= _tb < 256 /\ 0 < _r8 <= 200
       /\ 0 <= _len /\ _buf + _len < W64.modulus
       /\ _buf <= buf <= _buf + _len /\ _LEN = _len - (buf - _buf)
       /\ aT = (size _l + (buf - _buf)) %% _r8 /\ aT + _LEN < _r8
       /\ pabsorb_spec_ref _r8 (_l ++ take (buf - _buf) (memread _mem _buf _len)) st).
+ if => //; last first.
   auto => |> &m.
   move=> H Htb0 Htb1 Hlen Hbuf Hg.
   have Hr8: 0 < _r8 <= 200 by move: H; rewrite /pabsorb_spec_ref => [#].
   split; first smt().
   split; first smt().
   split; first smt().
   by rewrite take0 cats0.
  wp; while (Glob.mem = _mem /\ _RATE8 = _r8 /\ _TRAILB = _tb /\ 0 <= _tb < 256 /\ 0 < _r8 <= 200 /\
             0 <= _len /\ _buf + _len < W64.modulus /\
             iTERS = (_len - (_r8 - size _l %% _r8)) %/ _r8 /\ 0 <= i <= iTERS /\
             buf = _buf + (_r8 - size _l %% _r8 + i * _r8) /\
             pabsorb_spec_ref _r8 (_l ++ take (_r8 - size _l %% _r8 + i * _r8) (memread _mem _buf _len)) st).
  + wp; ecall (keccakf1600_h st); ecall (addstate_m_h2 Glob.mem st 0 buf _RATE8 0); auto => |> &m.
    move=> Htb0 Htb1 Hr0 Hr1 Hlen Hbuf Hi0 Hi1 IH Hb.
    have Hm: 0 <= i{m} * _r8 by apply mulr_ge0 => /#.
    have Hat: 0 <= size _l %% _r8 < _r8 by smt(modz_ge0 ltz_pmod).
    have h1: (i{m} + 1) * _r8 <= (_len - (_r8 - size _l %% _r8)) %/ _r8 * _r8 by rewrite ler_pmul2r 1:/#; smt().
    have h2:= lez_floor (_len - (_r8 - size _l %% _r8)) _r8 _; first smt().
    split; first smt().
    move=> ??? [st' at' buf'] /= Est _ Ebuf.
    split; first smt().
    split; first smt().
    have Ed: size _l = size _l %/ _r8 * _r8 + size _l %% _r8 by exact divz_eq.
    have Ha0: (size _l + (_r8 - size _l %% _r8 + i{m} * _r8)) %% _r8 = 0.
     by rewrite (_: size _l + (_r8 - size _l %% _r8 + i{m} * _r8) = (size _l %/ _r8 + i{m} + 1) * _r8) 1:/# modzMl.
    have Hf := pabsorb_fill _r8 _l (memread _mem _buf _len) (_r8 - size _l %% _r8 + i{m} * _r8) st{m}.
    move: Hf; rewrite Ha0 /= => Hf.
    rewrite (_: _r8 - size _l %% _r8 + (i{m} + 1) * _r8 = _r8 - size _l %% _r8 + i{m} * _r8 + _r8) 1:/#.
    rewrite Est -(slice_memread _mem _buf _len (_r8 - size _l %% _r8 + i{m} * _r8) _r8) 1..3:/#.
    by apply Hf => //; rewrite ?size_memread //; smt().
  wp; ecall (keccakf1600_h st); wp; ecall (addstate_m_h2 Glob.mem st aT buf (_RATE8 - aT) 0); auto => |> &m.
  move=> H Htb0 Htb1 Hlen Hbuf Hg.
  have Hr8: 0 < _r8 <= 200 by move: H; rewrite /pabsorb_spec_ref => [#].
  have Hat: 0 <= size _l %% _r8 < _r8 by smt(modz_ge0 ltz_pmod).
  split; first smt().
  move=> ????? [st' at' buf'] /= Est _ Ebuf.
  split.
   split; first smt().
   split; first smt(divz_ge0).
   have Hf := pabsorb_fill _r8 _l (memread _mem _buf _len) 0 st{m}.
   move: Hf => /=; rewrite take0 drop0 cats0 => Hf.
   rewrite Est -(take_memread' _mem _buf _len (_r8 - size _l %% _r8)) 1:/#.
   by apply Hf => //; rewrite ?size_memread //; smt().
  move=> i0 st0 Hex _ _ Hi0 Hi1 Hs.
  have Ei: i0 = (_len - (_r8 - size _l %% _r8)) %/ _r8 by smt().
  have Ed: _len - (_r8 - size _l %% _r8) = (_len - (_r8 - size _l %% _r8)) %/ _r8 * _r8 + (_len - (_r8 - size _l %% _r8)) %% _r8 by exact divz_eq.
  have Ed2: size _l = size _l %/ _r8 * _r8 + size _l %% _r8 by exact divz_eq.
  have Hq: 0 <= (_len - (_r8 - size _l %% _r8)) %/ _r8 by smt(divz_ge0).
  have Hqm: 0 <= (_len - (_r8 - size _l %% _r8)) %/ _r8 * _r8 by apply mulr_ge0 => /#.
  have Hmd: 0 <= (_len - (_r8 - size _l %% _r8)) %% _r8 < _r8 by smt(modz_ge0 ltz_pmod).
  move: Hs; rewrite Ei => Hs.
  rewrite (_: _buf + (_r8 - size _l %% _r8 + (_len - (_r8 - size _l %% _r8)) %/ _r8 * _r8) - _buf = _r8 - size _l %% _r8 + (_len - (_r8 - size _l %% _r8)) %/ _r8 * _r8) 1:/#.
  split; first smt().
  split; first smt().
  split.
   by rewrite (_: size _l + (_r8 - size _l %% _r8 + (_len - (_r8 - size _l %% _r8)) %/ _r8 * _r8) = (size _l %/ _r8 + 1 + (_len - (_r8 - size _l %% _r8)) %/ _r8) * _r8) 1:/# modzMl.
  by split; first smt().
case: (_TRAILB <> 0).
+ rcondt 2; first by call (: true ==> true) => //.
  ecall (addratebit_h _RATE8 st); ecall (addstate_m_h2 Glob.mem st aT buf _LEN _TRAILB); auto => |> &m.
  move=> Htb0 Htb1 Hr0 Hr1 Hlen Hbuf Hb0 Hb1 Hfit H Htb.
  split; first smt().
  move=> ????? [st' at' buf'] /= Est _ Ebuf.
  have Hk: 0 <= buf{m} - _buf <= size (memread _mem _buf _len) by rewrite size_memread //; smt().
  have Hfit': (size _l + (buf{m} - _buf)) %% _r8 + (size (memread _mem _buf _len) - (buf{m} - _buf)) < _r8 by rewrite size_memread.
  have [Hl1 _] := pabsorb_last _r8 _l (memread _mem _buf _len) (buf{m} - _buf) st{m} _tb Hk Hfit' H.
  split; last smt().
  by rewrite Est -(drop_memread_cur _mem _buf _len buf{m}) 1:/# Hl1.
rcondf 2; first by call (: true ==> true) => //.
ecall (addstate_m_h2 Glob.mem st aT buf _LEN _TRAILB); auto => |> &m.
move=> Hr0 Hr1 Hlen Hbuf Hb0 Hb1 Hfit H.
split; first smt().
move=> ????? [st' at' buf'] /= Est Eat Ebuf.
have Hk: 0 <= buf{m} - _buf <= size (memread _mem _buf _len) by rewrite size_memread //; smt().
have Hfit': (size _l + (buf{m} - _buf)) %% _r8 + (size (memread _mem _buf _len) - (buf{m} - _buf)) < _r8 by rewrite size_memread.
have [_ Hl0] := pabsorb_last _r8 _l (memread _mem _buf _len) (buf{m} - _buf) st{m} 0 Hk Hfit' H.
split.
 by move: (Hl0 (eq_refl 0)) => /=; rewrite Est -(drop_memread_cur _mem _buf _len buf{m}) 1:/#.
split; last smt().
rewrite Eat b2i0 /=.
have E: (size _l + (buf{m} - _buf)) %% _r8 + (_len - (buf{m} - _buf)) = (size _l + _len) + (- (size _l + (buf{m} - _buf)) %/ _r8) * _r8 by smt(divz_eq).
rewrite -(modz_small ((size _l + (buf{m} - _buf)) %% _r8 + (_len - (buf{m} - _buf))) _r8); first smt(modz_ge0).
by rewrite E modzMDr.
qed.

phoare absorb_m_ph _l _mem _buf _len _tb _r8:
 [ M.__absorb_m
 : Glob.mem=_mem /\ aT=size _l %% _r8 /\ buf=_buf /\ _LEN=_len /\ _RATE8=_r8 /\ _TRAILB=_tb
 /\ pabsorb_spec_ref _r8 _l st
 /\ 0 <= _tb < 256
 /\ 0 <= _len
 /\ _buf + _len < W64.modulus
 ==> Glob.mem = _mem
  /\ if _tb <> 0
     then res.`1 = ABSORB1600 (W8.of_int _tb) _r8 (_l ++ memread _mem _buf _len)
       /\ res.`3 = _buf + (max 0 _len)
     else pabsorb_spec_ref _r8 (_l ++ memread _mem _buf _len) res.`1
       /\ res.`2 = (size _l + _len) %% _r8
       /\ res.`3 = _buf + _len
 ] = 1%r.
proof.
by conseq absorb_m_ll (absorb_m_h _l _mem _buf _len _tb _r8) => /> /#.
qed.

(*
   ONE-SHOT (FIXED-SIZE) MEMORY SQUEEZE
   ====================================
*)

lemma dumpstate_m_ll: islossless M.__dumpstate_m.
proof.
(* This proof script is independent of selected `KECCAK_FEATURES` *)
proc => /=.
seq 1: #pre => //; first by inline*; auto.
if => //.
 seq 3: true => //.
  wp; while true (inc - j).
   by move=> z; auto => /#.
  by auto => /#.
 by islossless.
seq 2: true => //.
 while true (_LEN %/ 8 - i).
  by move=> z; auto => /#.
 by auto => /#.
by islossless.
qed.

hoare dumpstate_m_h _mem _buf _len _st:
 M.__dumpstate_m
 : Glob.mem=_mem /\ buf=_buf /\ _LEN=_len /\ st=_st
 /\ 0 <= _len <= 200
 /\ _buf + _len < W64.modulus
 ==> Glob.mem = stores _mem _buf (sub (stbytes _st) 0 _len)
  /\ res = _buf + _len.
proof.
proc => /=.
admitted.

phoare dumpstate_m_ph _mem _buf _len _st:
 [ M.__dumpstate_m
 : Glob.mem=_mem /\ buf=_buf /\ _LEN=_len /\ st=_st
 /\ 0 <= _len <= 200
 /\ _buf + _len < W64.modulus
 ==> Glob.mem = stores _mem _buf (sub (stbytes _st) 0 _len)
  /\ res = _buf + _len
 ] = 1%r.
proof.
by conseq dumpstate_m_ll (dumpstate_m_h _mem _buf _len _st).
qed.

lemma squeeze_m_ll: islossless M.__squeeze_m.
proof.
proc; simplify.
seq 2: true => //.
 while true (_LEN %/ _RATE8 - i).
  move => z; auto => />.
  call dumpstate_m_ll.
  call keccakf1600_ll.
  by auto => /#.
 by auto => /#.
if => //.
call dumpstate_m_ll.
call keccakf1600_ll.
by auto => /#.
qed.

hoare squeeze_m_h _mem _buf _len _st _r8:
 M.__squeeze_m
 : Glob.mem=_mem /\ buf=_buf /\ _LEN=_len /\ st=_st /\ _RATE8=_r8
 /\ 0 <= _len
 /\ 0 < _r8 <= 200
 /\ _buf + _len < W64.modulus
 ==> Glob.mem = stores _mem _buf (SQUEEZE1600 _r8 _len _st)
     /\ res.`1 = st_i _st ((_len-1) %/ _r8 + 1)
     /\ res.`2 = _buf + _len.
proof.
proc.
admitted.

phoare squeeze_m_ph _mem _buf _len _st _r8:
 [ M.__squeeze_m
 : Glob.mem=_mem /\ buf=_buf /\ _LEN=_len /\ st=_st /\ _RATE8=_r8
 /\ 0 <= _len
 /\ 0 < _r8 <= 200
 /\ _buf + _len < W64.modulus
 ==> Glob.mem = stores _mem _buf (SQUEEZE1600 _r8 _len _st)
     /\ res.`1 = st_i _st ((_len-1) %/ _r8 + 1)
     /\ res.`2 = _buf + _len
 ] = 1%r.
proof.
by conseq squeeze_m_ll (squeeze_m_h _mem _buf _len _st _r8).
qed.



abstract theory KeccakArrayRef.

op _ASIZE: int.

axiom _ASIZE_ge0: 0 <= _ASIZE.
axiom _ASIZE_u64: _ASIZE < W64.modulus.

(*
module type MParam = {
  proc keccakf1600_ref (a:W64.t Array25.t) : W64.t Array25.t
  proc state_init_ref (st:W64.t Array25.t) : W64.t Array25.t
  proc addratebit_ref (st:W64.t Array25.t, _RATE8:int) : W64.t Array25.t
}.
*)

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
  proc __addstate (st:W64.t Array25.t, aT:int, buf:W8.t A.t,
                   offset:int, _LEN:int, _TRAILB:int) : W64.t Array25.t *
                                                        int * int = {
    var inc:int;
    var hAS_AVX2:bool;
    var dELTA:int;
    var aT8:int;
    var w:W64.t;
    var t256:W256.t;
    var i:int;
    var t128:W128.t;
    var at:int;
    hAS_AVX2 <@ M.__HAS_FEATURE (4, 1+2+4);
    dELTA <- 0;
    if (((aT %% 8) <> 0)) {
      aT8 <- (8 * (aT %/ 8));
      (dELTA, _LEN, _TRAILB, aT, w) <@ RW.MM.__a_ilen_read_upto8_at (buf, offset,
      dELTA, _LEN, _TRAILB, aT8, aT);
      st <-
      (Array25.init
      (WArray200.get64
      (WArray200.set64_direct (WArray200.init64 (fun i_0 => st.[i_0]))
      aT8 ((get64_direct (WArray200.init64 (fun i_0 => st.[i_0])) aT8) `^` w)
      )));
    } else {

    }
    if (hAS_AVX2) {
      inc <- (_LEN %/ 32);
      i <- 0;
      while ((i < inc)) {
        t256 <-
        (get256_direct (WA.init8 (fun i_0 => buf.[i_0]))
        (offset + dELTA));
        dELTA <- (dELTA + 32);
        t256 <-
        (t256 `^`
        (get256_direct (WArray200.init64 (fun i_0 => st.[i_0]))
        (aT + (32 * i))));
        st <-
        (Array25.init
        (WArray200.get64
        (WArray200.set256_direct (WArray200.init64 (fun i_0 => st.[i_0]))
        (aT + (32 * i)) t256)));
        i <- (i + 1);
      }
      if ((16 <= (_LEN %% 32))) {
        t128 <-
        (get128_direct (WA.init8 (fun i_0 => buf.[i_0]))
        (offset + dELTA));
        dELTA <- (dELTA + 16);
        t128 <-
        (t128 `^`
        (get128_direct (WArray200.init64 (fun i_0 => st.[i_0]))
        (aT + ((_LEN %/ 32) * 32))));
        st <-
        (Array25.init
        (WArray200.get64
        (WArray200.set128_direct (WArray200.init64 (fun i_0 => st.[i_0]))
        (aT + ((_LEN %/ 32) * 32)) t128)));
      } else {

      }
      if ((8 <= (_LEN %% 16))) {
        w <-
        (get64_direct (WA.init8 (fun i_0 => buf.[i_0]))
        (offset + dELTA));
        dELTA <- (dELTA + 8);
        st <-
        (Array25.init
        (WArray200.get64
        (WArray200.set64_direct (WArray200.init64 (fun i_0 => st.[i_0]))
        (aT + ((_LEN %/ 16) * 16))
        ((get64_direct (WArray200.init64 (fun i_0 => st.[i_0]))
         (aT + ((_LEN %/ 16) * 16))) `^`
        w))));
      } else {

      }
    } else {
      at <- (aT %/ 8);
      offset <- (offset + dELTA);
      dELTA <- 0;
      while ((at < ((aT %/ 8) + (_LEN %/ 8)))) {
        w <- (get64_direct (WA.init8 (fun i_0 => buf.[i_0])) offset);
        offset <- (offset + 8);
        st.[at] <- (st.[at] `^` w);
        at <- (at + 1);
      }
    }
    aT <- (aT + (8 * (_LEN %/ 8)));
    _LEN <- (_LEN %% 8);
    if (((0 < _LEN) \/ ((_TRAILB %% 256) <> 0))) {
      aT8 <- aT;
      (dELTA, _LEN, _TRAILB, aT, w) <@ RW.MM.__a_ilen_read_upto8_at (buf, offset,
      dELTA, _LEN, _TRAILB, aT, aT);
      st <-
      (Array25.init
      (WArray200.get64
      (WArray200.set64_direct (WArray200.init64 (fun i_0 => st.[i_0]))
      aT8 ((get64_direct (WArray200.init64 (fun i_0 => st.[i_0])) aT8) `^` w)
      )));
    } else {

    }
    offset <- (offset + dELTA);
    return (st, aT, offset);
  }
  proc __absorb (st:W64.t Array25.t, aT:int, buf:W8.t A.t,
                 _TRAILB:int, _RATE8:int) : W64.t Array25.t * int = {
    var _LEN:int;
    var iTERS:int;
    var offset:int;
    var i:int;
    var  _0:int;
    var  _1:int;
    var  _2:int;
    offset <- 0;
    _LEN <- _ASIZE;
    if ((_RATE8 <= (aT + _LEN))) {
      (st,  _0, offset) <@ __addstate (st, aT, buf, offset, (_RATE8 - aT),
      0);
      _LEN <- (_LEN - (_RATE8 - aT));
      aT <- 0;
      (* Erased call to spill *)
      st <@ M._keccakf1600 (st);
      (* Erased call to unspill *)
      iTERS <- (_LEN %/ _RATE8);
      i <- 0;
      while ((i < iTERS)) {
        (st,  _1, offset) <@ __addstate (st, 0, buf, offset, _RATE8, 0);
        (* Erased call to spill *)
        st <@ M._keccakf1600 (st);
        (* Erased call to unspill *)
        i <- (i + 1);
      }
      _LEN <- (_LEN %% _RATE8);
    } else {

    }
    (st, aT,  _2) <@ __addstate (st, aT, buf, offset, _LEN, _TRAILB);
    if ((_TRAILB <> 0)) {
      st <@ M.__addratebit (st, _RATE8);
    } else {

    }
    return (st, aT);
  }
  proc __dumpstate (buf:W8.t A.t, offset:int, _LEN:int,
                    st:W64.t Array25.t) : W8.t A.t * int = {
    var inc:int;
    var hAS_AVX2:bool;
    var dELTA:int;
    var t:W64.t;
    var j:int;
    var t256:W256.t;
    var t128:W128.t;
    var i:int;
    var  _0:int;
    hAS_AVX2 <@ M.__HAS_FEATURE (4, 1+2+4);
    dELTA <- 0;
    if (hAS_AVX2) {
      inc <- (_LEN %/ 32);
      j <- 0;
      while ((j < inc)) {
        t256 <-
        (get256_direct (WArray200.init64 (fun i_0 => st.[i_0])) (32 * j));
        buf <-
        (A.init
        (WA.get8
        (WA.set256_direct (WA.init8 (fun i_0 => buf.[i_0]))
        (offset + dELTA) t256)));
        dELTA <- (dELTA + 32);
        j <- (j + 1);
      }
      if ((16 <= (_LEN %% 32))) {
        t128 <-
        (get128_direct (WArray200.init64 (fun i_0 => st.[i_0]))
        ((_LEN %/ 32) * 32));
        buf <-
        (A.init
        (WA.get8
        (WA.set128_direct (WA.init8 (fun i_0 => buf.[i_0]))
        (offset + dELTA) t128)));
        dELTA <- (dELTA + 16);
      } else {

      }
      if ((8 <= (_LEN %% 16))) {
        t <-
        (get64_direct (WArray200.init64 (fun i_0 => st.[i_0]))
        ((_LEN %/ 16) * 16));
        buf <-
        (A.init
        (WA.get8
        (WA.set64_direct (WA.init8 (fun i_0 => buf.[i_0]))
        (offset + dELTA) t)));
        dELTA <- (dELTA + 8);
      } else {

      }
    } else {
      i <- 0;
      while ((i < (_LEN %/ 8))) {
        t <- st.[i];
        buf <-
        (A.init
        (WA.get8
        (WA.set64_direct (WA.init8 (fun i_0 => buf.[i_0]))
        offset t)));
        offset <- (offset + 8);
        i <- (i + 1);
      }
    }
    if ((0 < (_LEN %% 8))) {
      t <- st.[(_LEN %/ 8)];
      (buf, dELTA,  _0) <@ RW.MM.__a_ilen_write_upto8 (buf, offset, dELTA,
      (_LEN %% 8), t);
    } else {

    }
    offset <- (offset + dELTA);
    return (buf, offset);
  }
  proc __squeeze (st:W64.t Array25.t, buf:W8.t A.t, _RATE8:int) :
  W64.t Array25.t * W8.t A.t = {
    var offset:int;
    var i:int;
    offset <- 0;
    i <- 0;
    while ((i < (_ASIZE %/ _RATE8))) {
      i <- (i + 1);
      (* Erased call to spill *)
      st <@ M._keccakf1600 (st);
      (* Erased call to unspill *)
      (buf, offset) <@ __dumpstate (buf, offset, _RATE8, st);
    }
    if ((0 < (_ASIZE %% _RATE8))) {
      (* Erased call to spill *)
      st <@ M._keccakf1600 (st);
      (* Erased call to unspill *)
      (buf, offset) <@ __dumpstate (buf, offset, (_ASIZE %% _RATE8), st);
    } else {

    }
    return (st, buf);
  }
}.

(* ARRAY instance: the remaining data of the input is the sub-array at the cursor
   (with the bounds the array loads need). *)
lemma addstate_spec_sub_rem st at (buf: W8.t A.t) off len tb sz c st' at' len' tb':
 0 <= off => 0 <= len => off + len <= _ASIZE =>
 addstate_spec st at (sub buf off len) tb sz off c st' at' len' tb' =>
 drop (size (sub buf off len) - len') (sub buf off len) = sub buf c len'
 /\ off <= c /\ c + len' = off + len.
proof.
move=> Hoff Hlen Hsz H.
have Hc := addstate_spec_cur _ _ _ _ _ _ _ _ _ _ _ H.
have [Hl0 Hl1] := addstate_spec_len _ _ _ _ _ _ _ _ _ _ _ H.
move: Hc Hl1; rewrite size_sub // => Hc Hl1.
split; last smt().
by rewrite drop_sub; congr; smt().
qed.

(* One u64 asubread step (prefix and last word of the array absorb). *)
lemma addstate_asubread_u64 (buf: W8.t A.t) w cur st at off len tb stc at0 dlt len0 tb0 cur1 at1 dlt1 len1 tb1:
 0 <= at => 0 <= len => 0 <= tb < 256 => 0 <= off => off + len <= _ASIZE =>
 0 <= cur <= at0 < cur+8 =>
 cur1 = cur + 8 =>
 addstate_spec st at (sub buf off len) tb cur off (off + dlt) stc at0 len0 tb0 =>
 asubread buf off (u64bytes w) cur at0 dlt len0 tb0 at1 dlt1 len1 tb1 =>
 addstate_spec st at (sub buf off len) tb cur1 off (off + dlt1) (addstate_at stc cur (u64bytes w)) at1 len1 tb1.
proof.
have Hs: size (u64bytes w) = 8 by rewrite /u64bytes size_to_list.
move=> Hat Hlen Htb Hoff Hsz Hc Hc1 Hspec; rewrite /asubread => [#] Hsr Eat Edlt Elen Etb.
have [Erem [Hc0 Hc2]] := addstate_spec_sub_rem _ _ _ _ _ _ _ _ _ _ _ _ Hoff Hlen Hsz Hspec.
apply (addstate_spec_step (sub buf off len) (u64bytes w) cur st at tb stc off (off + dlt) at0 len0 tb0 cur1 (off + dlt1) at1 len1 tb1); rewrite ?Hs //.
+ smt().
by rewrite Erem; apply Hsr; smt().
qed.

lemma addstate_ll: islossless MM.__addstate.
proof.
(* This proof script is independent of selected `KECCAK_FEATURES` *)
proc.
seq 4: true => //; last by islossless.
seq 2: true => //; first by inline*; auto.
seq 1: true => //; first by islossless.
if => //.
 seq 3: true => //; last by islossless.
 wp; while true (inc - i).
  by move=> z; auto => /#.
 by auto => /#.
while true ((aT %/ 8) + (_LEN %/ 8) - at).
 by move=> z; auto => /#.
by auto => /#.
qed.

hoare addstate_h _st _at _buf _off _len _tb:
 MM.__addstate
 : st=_st /\ aT=_at /\ buf=_buf /\ offset=_off /\ _LEN=_len /\ _TRAILB=_tb
 /\ 0 <= _at <= 200
 /\ 0 <= _len
 /\ _at + _len <= 200 - b2i (_tb<>0)
 /\ 0 <= _off /\ _off + _len <= _ASIZE
 /\ 0 <= _tb < 256
 ==> let l = sub _buf _off _len ++ if _tb <> 0 then [W8.of_int _tb] else []
     in res.`1 = addstate_at _st _at l
     /\ res.`2 = _at + _len + b2i (_tb<>0)
     /\ res.`3 = _off + _len.
proof.
(* Same structure as addstate_m_h, on the shared read-step layer: the input is
   `sub _buf _off _len` and the cursor is `offset + dELTA`. *)
proc => /=.
pose base:= 8 * (_at %/ 8).
pose nbase:= 8 * ((_at-1) %/ 8 + 1).
(* stmts 1-3 : __HAS_FEATURE, dELTA <- 0 and the alignment prefix. *)
seq 3: (buf = _buf /\ 0 <= _tb < 256 /\ 0 <= _at <= 200
       /\ 0 <= _len /\ _at + _len <= 200 - b2i (_tb<>0) /\ 0 <= _off /\ _off + _len <= _ASIZE
       /\ addstate_spec _st _at (sub _buf _off _len) _tb nbase _off (offset + dELTA) st aT _LEN _TRAILB
       /\ 0 <= offset /\ 0 <= dELTA).
+ seq 2: (#pre /\ dELTA = 0); first by inline*; auto.
  if => //.
   wp; ecall (a_ilen_read_upto8_at_h buf offset dELTA _LEN _TRAILB aT8 aT); auto => |> &m ????????.
   move=> [dlt0 len0 tb0 at0 w0] /=.
   move => H; rewrite set64_addstate_at 1:/#.
   split; last by move: H; rewrite /asubread => [#] _ _ -> _ _; rewrite /srincr; smt(size_ge0).
   apply (addstate_asubread_u64 _buf w0 (8 * (_at %/ 8)) _st _at _off _len _tb _st _at 0 _len _tb nbase at0 dlt0 len0 tb0) => //;
    [smt() | by rewrite /nbase; smt() | by apply addstate_spec_init => //; smt(size_sub')].
  auto => |> *.
  have ->@/base: nbase = base by smt().
  by apply addstate_spec_init; smt(size_sub').
(* stmt 3 : if hAS_AVX2 — both branches consume `8*(_LEN%/8)` further aligned bytes. *)
seq 1: (buf = _buf /\ 0 <= _tb < 256 /\ 0 <= _at <= 200
       /\ 0 <= _len /\ _at + _len <= 200 - b2i (_tb<>0) /\ 0 <= _off /\ _off + _len <= _ASIZE
       /\ addstate_spec _st _at (sub _buf _off _len) _tb (nbase+8*(_LEN%/8)) _off (offset + dELTA) st (aT+8*(_LEN%/8)) (_LEN-8*(_LEN%/8)) _TRAILB /\ 0 <= _LEN /\ 0 <= offset /\ 0 <= dELTA).
 if => //.
 - seq 3: (buf = _buf /\ 0 <= _tb < 256 /\ 0 <= _at <= 200
       /\ 0 <= _len /\ _at + _len <= 200 - b2i (_tb<>0) /\ 0 <= _off /\ _off + _len <= _ASIZE
       /\ addstate_spec _st _at (sub _buf _off _len) _tb (nbase+32*(_LEN%/32)) _off (offset + dELTA) st (aT+32*(_LEN%/32)) (_LEN-32*(_LEN%/32)) _TRAILB /\ 0 <= _LEN /\ 0 <= offset /\ 0 <= dELTA).
   while (#[/1:9]pre /\ inc = _LEN%/32 /\
          0 <= i <= _LEN%/32 /\ 0 <= dELTA /\
          addstate_spec _st _at (sub _buf _off _len) _tb (nbase+32*i) _off (offset + dELTA) st (aT+32*i) (_LEN-32*i) _TRAILB).
    auto => |> &m Htb0 Htb1 Hat0 Hat1 Hlen Hal Hoff Hosz ?? Hd IH Hb; split; first smt().
    split; first smt().
    rewrite xorwC set256_addstate_at 1:/#.
    have [Erem [Hc0 Hc1]] := addstate_spec_sub_rem _ _ _ _ _ _ _ _ _ _ _ _ Hoff Hlen Hosz IH.
    apply (addstate_spec_fullword _ _ (nbase + 32 * i{m}) _st _at _tb st{m} _off (offset{m} + dELTA{m}) (aT{m} + 32 * i{m}) (_LEN{m} - 32 * i{m}) _TRAILB{m}) => //; rewrite ?size_to_list; 1..6: smt().
    by rewrite Erem; apply getW256_bytearray; smt().
   auto => |> &m ???????? H Ho Hd Hh; split.
    have ?: 0<= _LEN{m}.
     move: H; rewrite /addstate_spec => />. smt(size_ge0).
    smt().
   move => dlt1 i st1 ????; have ->: i=_LEN{m} %/ 32 by smt().
   by move=> Hs; split => //; smt().
   seq 1: (buf = _buf /\ 0 <= _tb < 256 /\ 0 <= _at <= 200
       /\ 0 <= _len /\ _at + _len <= 200 - b2i (_tb<>0) /\ 0 <= _off /\ _off + _len <= _ASIZE
       /\ addstate_spec _st _at (sub _buf _off _len) _tb (nbase+16*(_LEN%/16)) _off (offset + dELTA) st (aT+16*(_LEN%/16)) (_LEN-16*(_LEN%/16)) _TRAILB /\ 0 <= _LEN /\ 0 <= offset /\ 0 <= dELTA).
   if => //.
     auto => |> &m Htb0 Htb1 Hat0 Hat1 Hlen Hal Hoff Hosz IH HL Ho Hd Hb.
     split; last smt().
     rewrite xorwC set128_addstate_at 1:/# (_: aT{m} + _LEN{m} %/ 32 * 32 = aT{m} + 32 * (_LEN{m} %/ 32)) 1:/#.
     have [Erem [Hc0 Hc1]] := addstate_spec_sub_rem _ _ _ _ _ _ _ _ _ _ _ _ Hoff Hlen Hosz IH.
     apply (addstate_spec_fullword _ _ (nbase + 32 * (_LEN{m} %/ 32)) _st _at _tb st{m} _off (offset{m} + dELTA{m}) (aT{m} + 32 * (_LEN{m} %/ 32)) (_LEN{m} - 32 * (_LEN{m} %/ 32)) _TRAILB{m}) => //; rewrite ?size_to_list; 1..6: smt().
     by rewrite Erem; apply getW128_bytearray; smt().
    auto => |> ???????? H Hb HL Ho Hd.
    move => Hc; have E: forall n, !16 <= n %% 32 => 16 * (n %/ 16) = 32 * (n %/ 32) by smt().
    by rewrite !(E _ Hc); exact Hb.
   if => //.
     auto => |> &m Htb0 Htb1 Hat0 Hat1 Hlen Hal Hoff Hosz H HL Ho Hd Hb.
     split; last smt().
     rewrite set64_addstate_at 1:/# (_: aT{m} + _LEN{m} %/ 16 * 16 = aT{m} + 16 * (_LEN{m} %/ 16)) 1:/#.
     have Hs: size (u64bytes (get64_direct (WA.init8 ("_.[_]" _buf)) (offset{m} + dELTA{m}))) = 8 by rewrite /u64bytes size_to_list.
     have [Erem [Hc0 Hc1]] := addstate_spec_sub_rem _ _ _ _ _ _ _ _ _ _ _ _ Hoff Hlen Hosz H.
     apply (addstate_spec_fullword _ _ (nbase + 16 * (_LEN{m} %/ 16)) _st _at _tb st{m} _off (offset{m} + dELTA{m}) (aT{m} + 16 * (_LEN{m} %/ 16)) (_LEN{m} - 16 * (_LEN{m} %/ 16)) _TRAILB{m}) => //; rewrite ?Hs; 1..6: smt().
     by rewrite Erem; apply getW64_bytearray; smt().
    auto => |> ????????? H HL Ho Hd Hb.
    have E: forall n, !8 <= n %% 16 => 8 * (n %/ 8) = 16 * (n %/ 16) by smt().
    by rewrite !(E _ Hb); exact H.
 - (* scalar branch: word-indexed loop; the spec is advanced by 8*(at - aT%/8) bytes. *)
   while (#[/1:9]pre /\ 0 <= _LEN /\ dELTA = 0 /\ 0 <= offset /\ aT %/ 8 <= at <= aT %/ 8 + _LEN %/ 8 /\
          addstate_spec _st _at (sub _buf _off _len) _tb (nbase + 8 * (at - aT %/ 8)) _off offset st (aT + 8 * (at - aT %/ 8)) (_LEN - 8 * (at - aT %/ 8)) _TRAILB).
   + auto => |> &m Htb0 Htb1 Hat0 Hat1 Hlen Hal Hoff Hosz HL Ho H1 H2 H Hb.
     split; first smt().
     split; first smt().
     have Ea: aT{m} + 8 * (at{m} - aT{m} %/ 8) = nbase + 8 * (at{m} - aT{m} %/ 8).
      by apply (addstate_spec_sz _st _at (sub _buf _off _len) _tb (nbase + 8 * (at{m} - aT{m} %/ 8)) _off offset{m} st{m} (aT{m} + 8 * (at{m} - aT{m} %/ 8)) (_LEN{m} - 8 * (at{m} - aT{m} %/ 8)) _TRAILB{m}) => //; smt().
     have Hal8: aT{m} + 8 * (at{m} - aT{m} %/ 8) = 8 * at{m} by move: Ea; rewrite /nbase; smt().
     have Hfit: aT{m} + 8 * (at{m} - aT{m} %/ 8) + (_LEN{m} - 8 * (at{m} - aT{m} %/ 8)) = _at + size (sub _buf _off _len).
      by apply (addstate_spec_fit _st _at (sub _buf _off _len) _tb (nbase + 8 * (at{m} - aT{m} %/ 8)) _off offset{m} st{m} (aT{m} + 8 * (at{m} - aT{m} %/ 8)) (_LEN{m} - 8 * (at{m} - aT{m} %/ 8)) _TRAILB{m}) => //; smt().
     rewrite setw_addstate_at; first smt(size_sub').
     rewrite -Hal8.
     have Hs: size (u64bytes (get64_direct (WA.init8 ("_.[_]" _buf)) offset{m})) = 8 by rewrite /u64bytes size_to_list.
     have [Erem [Hc0 Hc1]] := addstate_spec_sub_rem _ _ _ _ _ _ _ _ _ _ _ _ Hoff Hlen Hosz H.
     apply (addstate_spec_fullword _ _ (nbase + 8 * (at{m} - aT{m} %/ 8)) _st _at _tb st{m} _off offset{m} (aT{m} + 8 * (at{m} - aT{m} %/ 8)) (_LEN{m} - 8 * (at{m} - aT{m} %/ 8)) _TRAILB{m}) => //; rewrite ?Hs; 1..5: smt().
     by rewrite Erem; apply getW64_bytearray; smt().
   + auto => |> &m Htb0 Htb1 Hat0 Hat1 Hlen Hal Hoff Hosz H Ho Hd Hn.
     have HL: 0 <= _LEN{m} by have := addstate_spec_len _ _ _ _ _ _ _ _ _ _ _ H; smt().
     split; first smt().
     move=> at0 off0 st0 Hex _ _ H1 H2 Hs.
     have E: at0 = aT{m} %/ 8 + _LEN{m} %/ 8 by smt().
     by move: Hs; rewrite E (_: aT{m} %/ 8 + _LEN{m} %/ 8 - aT{m} %/ 8 = _LEN{m} %/ 8) 1:/#.
(* stmts 4-5 : bookkeeping (existential sz, as in addstate_m_h); stmt 6 and the
   final `offset <- offset + dELTA`: the shared finishing step. *)
seq 2: (buf = _buf /\ 0 <= _tb < 256 /\ 0 <= _at <= 200
       /\ 0 <= _len /\ _at + _len <= 200 - b2i (_tb<>0) /\ 0 <= _off /\ _off + _len <= _ASIZE
       /\ 0 <= _LEN < 8 /\ 0 <= offset /\ 0 <= dELTA
       /\ exists sz, _at <= sz /\ addstate_spec _st _at (sub _buf _off _len) _tb sz _off (offset + dELTA) st aT _LEN _TRAILB).
+ auto => |> &m ???????? H HL Ho Hd.
  split; first smt().
  exists (nbase + 8 * (_LEN{m} %/ 8)); split; first smt().
  by rewrite (_: _LEN{m} %% 8 = _LEN{m} - 8 * (_LEN{m} %/ 8)) 1:/#.
wp; if.
+ wp; ecall (a_ilen_read_upto8_at_h buf offset dELTA _LEN _TRAILB aT aT); auto => |> &m Htb0 Htb1 Hat0 Hat1 Hlen Hal Hoff Hosz HL0 HL1 Ho Hd sz Hsz H Hg [dlt1 len1 tb1 at1 w] /= Hsub.
  have Hs: size (u64bytes w) = 8 by rewrite /u64bytes size_to_list.
  have Ha: 0 <= aT{m} by move: H; rewrite /addstate_spec => [#] _ _ _ Ea _ _; smt().
  rewrite set64_addstate_at //.
  have [Erem [Hc0 Hc1]] := addstate_spec_sub_rem _ _ _ _ _ _ _ _ _ _ _ _ Hoff Hlen Hosz H.
  move: Hsub; rewrite /asubread Hs => [#] Hsr Eat Edlt _ _.
  apply (addstate_spec_finish (sub _buf _off _len) (u64bytes w) _len sz _st _at _tb st{m} _off (offset{m} + dELTA{m}) aT{m} _LEN{m} _TRAILB{m} at1 (offset{m} + dlt1)) => //.
  + by rewrite size_sub.
  + smt().
  + smt().
  by rewrite Erem; apply Hsr; smt().
(* nothing left: the stream and the trailing byte are already absorbed *)
auto => |> &m ???????? HL0 HL1 Ho Hd sz Hsz H Hg.
have Hl: _LEN{m} = 0 by smt().
move: H; rewrite Hl => H.
by apply (addstate_spec_done (sub _buf _off _len) _len sz _st _at _tb st{m} _off (offset{m} + dELTA{m}) aT{m} _TRAILB{m}) => //; [rewrite size_sub | smt()].
qed.

phoare addstate_ph _st _at _buf _off _len _tb:
 [ MM.__addstate
   : st=_st /\ aT=_at /\ buf=_buf /\ offset=_off /\ _LEN=_len /\ _TRAILB=_tb
   /\ 0 <= _at <= 200
   /\ 0 <= _len
   /\ _at + _len <= 200 - b2i (_tb<>0)
   /\ 0 <= _off /\ _off + _len <= _ASIZE
   /\ 0 <= _tb < 256
   ==> let l = sub _buf _off _len ++ if _tb <> 0 then [W8.of_int _tb] else []
       in res.`1 = addstate_at _st _at l
       /\ res.`2 = _at + _len + b2i (_tb<>0)
       /\ res.`3 = _off + _len] = 1%r.
proof.
by conseq addstate_ll (addstate_h _st _at _buf _off _len _tb).
qed.

(* ARRAY instance of the absorb input: the whole array, read through sub. *)
lemma to_list_sub (buf: W8.t A.t): to_list buf = sub buf 0 _ASIZE.
proof. by rewrite /to_list /sub; apply eq_mkseq => i /=. qed.

lemma take_to_list (buf: W8.t A.t) k:
 0 <= k <= _ASIZE => take k (to_list buf) = sub buf 0 k.
proof. by move=> Hk; rewrite to_list_sub take_sub /#. qed.

lemma slice_to_list (buf: W8.t A.t) k n:
 0 <= k => 0 <= n => k + n <= _ASIZE =>
 take n (drop k (to_list buf)) = sub buf k n.
proof. by move=> Hk Hn Hkn; rewrite to_list_sub drop_sub take_sub; congr; smt(). qed.

lemma drop_to_list (buf: W8.t A.t) k:
 0 <= k <= _ASIZE => drop k (to_list buf) = sub buf k (_ASIZE - k).
proof. by move=> Hk; rewrite to_list_sub drop_sub; congr; smt(). qed.

(* addstate_h with the trailing byte made explicit (the shape used by absorb_h). *)
hoare addstate_h2 _st _at _buf _off _len _tb:
 MM.__addstate
 : st=_st /\ aT=_at /\ buf=_buf /\ offset=_off /\ _LEN=_len /\ _TRAILB=_tb
 /\ 0 <= _at <= 200
 /\ 0 <= _len
 /\ _at + _len <= 200 - b2i (_tb<>0)
 /\ 0 <= _off /\ _off + _len <= _ASIZE
 /\ 0 <= _tb < 256
 ==> res.`1 = addstate _st (bytes2state (u8zeros _at ++ sub _buf _off _len ++ [W8.of_int _tb]))
     /\ res.`2 = _at + _len + b2i (_tb<>0)
     /\ res.`3 = _off + _len.
proof.
conseq (addstate_h _st _at _buf _off _len _tb) => /> &m ???????? r -> _ _.
by rewrite addstate_at_bytes.
qed.

lemma absorb_ll: islossless MM.__absorb.
proof.
proc; simplify.
seq 4: true => //.
 call addstate_ll.
 sp 2; if => //.
 wp; while true (iTERS-i).
  move=> z; auto.
  call keccakf1600_ll.
  call addstate_ll.
  by auto => /#.
 wp; call keccakf1600_ll.
 wp; call addstate_ll.
 by auto => /#.
if => //.
by call addratebit_ll.
qed.

hoare absorb_h _l _buf _tb _r8:
 MM.__absorb
 : aT=size _l %% _r8 /\ buf=_buf /\ _RATE8=_r8 /\ _TRAILB=_tb
 /\ pabsorb_spec_ref _r8 _l st
 /\ 0 <= _tb < 256
 ==> if _tb <> 0
     then res.`1 = ABSORB1600 (W8.of_int _tb) _r8 (_l ++ to_list _buf)
     else pabsorb_spec_ref _r8 (_l ++ to_list _buf) res.`1
       /\ res.`2 = (size _l + _ASIZE) %% _r8.
proof.
(* `offset` bytes of the input are absorbed; each block is closed by the shared
   pabsorb_fill and the last one by pabsorb_last (as in absorb_m_h). *)
proc => /=.
have HA := _ASIZE_ge0.
seq 3: (buf = _buf /\ _RATE8 = _r8 /\ _TRAILB = _tb /\ 0 <= _tb < 256 /\ 0 < _r8 <= 200
       /\ 0 <= offset <= _ASIZE /\ _LEN = _ASIZE - offset
       /\ aT = (size _l + offset) %% _r8 /\ aT + _LEN < _r8
       /\ pabsorb_spec_ref _r8 (_l ++ take offset (to_list _buf)) st).
+ sp; if => //; last first.
   auto => |> &m.
   move=> H Htb0 Htb1 Hg.
   have Hr8: 0 < _r8 <= 200 by move: H; rewrite /pabsorb_spec_ref => [#].
   split; first smt().
   split; first smt().
   by rewrite take0 cats0.
  wp; while (buf = _buf /\ _RATE8 = _r8 /\ _TRAILB = _tb /\ 0 <= _tb < 256 /\ 0 < _r8 <= 200 /\
             iTERS = (_ASIZE - (_r8 - size _l %% _r8)) %/ _r8 /\ 0 <= i <= iTERS /\
             offset = _r8 - size _l %% _r8 + i * _r8 /\
             pabsorb_spec_ref _r8 (_l ++ take offset (to_list _buf)) st).
  + wp; ecall (keccakf1600_h st); ecall (addstate_h2 st 0 buf offset _RATE8 0); auto => |> &m.
    move=> Htb0 Htb1 Hr0 Hr1 Hi0 Hi1 IH Hb.
    have Hm: 0 <= i{m} * _r8 by apply mulr_ge0 => /#.
    have Hat: 0 <= size _l %% _r8 < _r8 by smt(modz_ge0 ltz_pmod).
    have h1: (i{m} + 1) * _r8 <= (_ASIZE - (_r8 - size _l %% _r8)) %/ _r8 * _r8 by rewrite ler_pmul2r 1:/#; smt().
    have h2:= lez_floor (_ASIZE - (_r8 - size _l %% _r8)) _r8 _; first smt().
    split; first smt().
    move=> ???? [st' at' off'] /= Est _ Eoff.
    split; first smt().
    split; first smt().
    have Ed: size _l = size _l %/ _r8 * _r8 + size _l %% _r8 by exact divz_eq.
    have Ha0: (size _l + (_r8 - size _l %% _r8 + i{m} * _r8)) %% _r8 = 0.
     by rewrite (_: size _l + (_r8 - size _l %% _r8 + i{m} * _r8) = (size _l %/ _r8 + i{m} + 1) * _r8) 1:/# modzMl.
    have Hf := pabsorb_fill _r8 _l (to_list _buf) (_r8 - size _l %% _r8 + i{m} * _r8) st{m}.
    move: Hf; rewrite Ha0 /= => Hf.
    rewrite Eoff Est -(slice_to_list _buf (_r8 - size _l %% _r8 + i{m} * _r8) _r8) 1..3:/#.
    by apply Hf => //; rewrite ?size_to_list; smt().
  wp; ecall (keccakf1600_h st); wp; ecall (addstate_h2 st aT buf offset (_RATE8 - aT) 0); auto => |> &m.
  move=> H Htb0 Htb1 Hg.
  have Hr8: 0 < _r8 <= 200 by move: H; rewrite /pabsorb_spec_ref => [#].
  have Hat: 0 <= size _l %% _r8 < _r8 by smt(modz_ge0 ltz_pmod).
  split; first smt().
  move=> ????? [st' at' off'] /= Est _ Eoff.
  split.
   split; first smt().
   split; first smt(divz_ge0).
   have Hf := pabsorb_fill _r8 _l (to_list _buf) 0 st{m}.
   move: Hf => /=; rewrite take0 drop0 cats0 => Hf.
   rewrite Eoff Est -(take_to_list _buf (_r8 - size _l %% _r8)) 1:/#.
   by apply Hf => //; rewrite ?size_to_list; smt().
  move=> i0 st0 Hex _ _ Hi0 Hi1 Hs.
  have Ei: i0 = (_ASIZE - (_r8 - size _l %% _r8)) %/ _r8 by smt().
  have Ed: _ASIZE - (_r8 - size _l %% _r8) = (_ASIZE - (_r8 - size _l %% _r8)) %/ _r8 * _r8 + (_ASIZE - (_r8 - size _l %% _r8)) %% _r8 by exact divz_eq.
  have Ed2: size _l = size _l %/ _r8 * _r8 + size _l %% _r8 by exact divz_eq.
  have Hq: 0 <= (_ASIZE - (_r8 - size _l %% _r8)) %/ _r8 by smt(divz_ge0).
  have Hqm: 0 <= (_ASIZE - (_r8 - size _l %% _r8)) %/ _r8 * _r8 by apply mulr_ge0 => /#.
  have Hmd: 0 <= (_ASIZE - (_r8 - size _l %% _r8)) %% _r8 < _r8 by smt(modz_ge0 ltz_pmod).
  rewrite Ei; split; first smt().
  split; first smt().
  split; last smt().
  by rewrite (_: size _l + (_r8 - size _l %% _r8 + (_ASIZE - (_r8 - size _l %% _r8)) %/ _r8 * _r8) = (size _l %/ _r8 + 1 + (_ASIZE - (_r8 - size _l %% _r8)) %/ _r8) * _r8) 1:/# modzMl.
case: (_TRAILB <> 0).
+ rcondt 2; first by call (: true ==> true) => //.
  ecall (addratebit_h _RATE8 st); ecall (addstate_h2 st aT buf offset _LEN _TRAILB); auto => |> &m.
  move=> Htb0 Htb1 Hr0 Hr1 Ho0 Ho1 Hfit H Htb.
  split; first smt().
  move=> ????? [st' at' off'] /= Est _ _.
  have Hk: 0 <= offset{m} <= size (to_list _buf) by rewrite size_to_list.
  have Hfit': (size _l + offset{m}) %% _r8 + (size (to_list _buf) - offset{m}) < _r8 by rewrite size_to_list.
  have [Hl1 _] := pabsorb_last _r8 _l (to_list _buf) offset{m} st{m} _tb Hk Hfit' H.
  by rewrite Est -(drop_to_list _buf offset{m}) 1:/# Hl1.
rcondf 2; first by call (: true ==> true) => //.
ecall (addstate_h2 st aT buf offset _LEN _TRAILB); auto => |> &m.
move=> Hr0 Hr1 Ho0 Ho1 Hfit H.
split; first smt().
move=> ????? [st' at' off'] /= Est Eat _.
have Hk: 0 <= offset{m} <= size (to_list _buf) by rewrite size_to_list.
have Hfit': (size _l + offset{m}) %% _r8 + (size (to_list _buf) - offset{m}) < _r8 by rewrite size_to_list.
have [_ Hl0] := pabsorb_last _r8 _l (to_list _buf) offset{m} st{m} 0 Hk Hfit' H.
split.
 by move: (Hl0 (eq_refl 0)) => /=; rewrite Est -(drop_to_list _buf offset{m}) 1:/#.
rewrite Eat b2i0 /=.
have E: (size _l + offset{m}) %% _r8 + (_ASIZE - offset{m}) = (size _l + _ASIZE) + (- (size _l + offset{m}) %/ _r8) * _r8 by smt(divz_eq).
rewrite -(modz_small ((size _l + offset{m}) %% _r8 + (_ASIZE - offset{m})) _r8); first smt(modz_ge0).
by rewrite E modzMDr.
qed.

phoare absorb_ph _l _buf _tb _r8:
 [ MM.__absorb
 : aT=size _l %% _r8 /\ buf=_buf /\ _RATE8=_r8 /\ _TRAILB=_tb
 /\ pabsorb_spec_ref _r8 _l st
 /\ 0 <= _tb < 256
 ==> if _tb <> 0
     then res.`1 = ABSORB1600 (W8.of_int _tb) _r8 (_l ++ to_list _buf)
     else pabsorb_spec_ref _r8 (_l ++ to_list _buf) res.`1
       /\ res.`2 = (size _l + _ASIZE) %% _r8
 ] = 1%r.
proof.
by conseq absorb_ll (absorb_h _l _buf _tb _r8); smt(ge0_size).
qed.

(*
   ONE-SHOT (FIXED-SIZE) MEMORY SQUEEZE
   ====================================
*)

lemma dumpstate_ll: islossless MM.__dumpstate.
proof.
(* This proof script is independent of selected `KECCAK_FEATURES` *)
proc => /=.
seq 2: true => //; first by inline*; auto.
if => //.
 seq 3: true => //; last by islossless.
 wp; while true (inc - j).
  by move=> z; auto => /#.
 by auto => /#.
seq 2: true => //; last by islossless.
while true (_LEN %/ 8 - i).
 by move=> z; auto => /#.
by auto => /#.
qed.

hoare dumpstate_h _buf _off _len _st:
 MM.__dumpstate
 : buf=_buf /\ offset=_off /\ _LEN=_len /\ st=_st
 /\ 0 <= _len <= 200
 /\ _off + _len <= _ASIZE
 ==> res.`1 = A.fill (fun i=>(stbytes _st).[i-_off]) _off _len _buf
  /\ res.`2 = _off + _len.
proof.
proc.
admitted.

phoare dumpstate_ph _buf _off _len _st:
 [ MM.__dumpstate
 : buf=_buf /\ offset=_off /\ _LEN=_len /\ st=_st
 /\ 0 <= _len <= 200
 /\ _off + _len <= _ASIZE
 ==> res.`1 = A.fill (fun i=>(stbytes _st).[i-_off]) _off _len _buf
  /\ res.`2 = _off + _len
 ] = 1%r.
proof.
by conseq dumpstate_ll (dumpstate_h _buf _off _len _st).
qed.

lemma squeeze_ll: islossless MM.__squeeze.
proof.
proc; simplify.
seq 3: true => //.
 while true (_ASIZE %/ _RATE8 - i).
  move => z.
  call dumpstate_ll.
  call keccakf1600_ll.
  by auto => /#.
 by auto => /#.
if => //.
call dumpstate_ll.
call keccakf1600_ll.
by auto => /#.
qed.

hoare squeeze_h _buf _st _r8:
 MM.__squeeze
 : buf=_buf /\ st=_st /\ _RATE8=_r8
 /\ 0 < _r8 <= 200
 ==> res.`1 = st_i _st ((_ASIZE-1) %/ _r8 + 1)
     /\ to_list res.`2 = (SQUEEZE1600 _r8 _ASIZE _st).
proof.
proc.
admitted.

phoare squeeze_ph _buf _st _r8:
 [ MM.__squeeze
 : buf=_buf /\ st=_st /\ _RATE8=_r8
 /\ 0 < _r8 <= 200
 ==> res.`1 = st_i _st ((_ASIZE-1) %/ _r8 + 1)
     /\ to_list res.`2 = (SQUEEZE1600 _r8 _ASIZE _st)
 ] = 1%r.
proof.
by conseq squeeze_ll (squeeze_h _buf _st _r8).
qed.

end KeccakArrayRef.
