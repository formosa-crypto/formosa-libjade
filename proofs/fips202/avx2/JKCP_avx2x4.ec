(******************************************************************************
   JKCP_avx2x4.ec:

   Correctness of the 4-way AVX2 C-ABI entry points of the Jasmin Keccak
   Code Package (src/fips202/avx2/JKCP.jazz).  The interface is incremental
   only; the state (W64.t Array101.t) is owned by the caller.

     sha3_{224,256,384,512}x4_init, shake{128,256}x4_init
       ==> absorbing_spec4 r8 ds [] [] [] [] res, with the algorithm's rate
           and domain-separation byte
     keccakx4_absorb_bcast, keccakx4_absorb
       the contracts of the updstate procedures they call
       (avx2/common/Keccak1600_updstate_avx2x4.ec)
     keccakx4_squeeze (finishes the absorption on its first call)
       sponge_spec4 r8 tb l0 l1 l2 l3 k st
       ==> out_i = sqstream r8 (ABSORB1600 tb r8 l_i) k len
           /\ sponge_spec4 r8 tb l0 l1 l2 l3 (k + len) res
   sponge_spec4 is the lane-wise sponge_spec of ref/JKCP.ec: absorbing
   (k = 0, trail byte tb <> 0) or finished (trail byte 0).
******************************************************************************)
require import AllCore List Int IntDiv.

from Jasmin require import JModel_x86.

from JazzEC require import Keccak1600_Jazz.
from JazzEC require import Array25 Array101.

require import JWordList.
from CryptoSpecs require import FIPS202_Keccakf1600 Keccak1600_Spec.

require import Keccak1600_updstate Keccak1600_fixedsizes_avx2x4 Keccak1600_updstate_avx2x4.


(* ========================================================================= *)
(* Per-variant init                                                          *)
(* ========================================================================= *)

lemma keccakx4_init_ll: islossless M.__keccakx4_init.
proof. by proc; call init_updstate_avx2x4_ll; auto. qed.

hoare keccakx4_init_h _r64 _tb:
 M.__keccakx4_init
 : _RATE64 = _r64 /\ _TRAILB = _tb /\ 0 < _r64 <= 25
 ==> absorbing_spec4 (8 * _r64) (W8.of_int _tb) [] [] [] [] res.
proof. by proc; ecall (init_updstate_avx2x4_h _r64 (W8.of_int _tb)); auto. qed.

lemma sha3_224x4_init_ll: islossless M.sha3_224x4_init.
proof. by proc; call keccakx4_init_ll; auto. qed.

hoare sha3_224x4_init_h:
 M.sha3_224x4_init : true ==> absorbing_spec4 c448_r8 SHA3_DS_BYTE [] [] [] [] res.
proof. by proc; ecall (keccakx4_init_h 18 6); auto; rewrite /c448_r8 /SHA3_DS_BYTE. qed.

lemma sha3_256x4_init_ll: islossless M.sha3_256x4_init.
proof. by proc; call keccakx4_init_ll; auto. qed.

hoare sha3_256x4_init_h:
 M.sha3_256x4_init : true ==> absorbing_spec4 c512_r8 SHA3_DS_BYTE [] [] [] [] res.
proof. by proc; ecall (keccakx4_init_h 17 6); auto; rewrite /c512_r8 /SHA3_DS_BYTE. qed.

lemma sha3_384x4_init_ll: islossless M.sha3_384x4_init.
proof. by proc; call keccakx4_init_ll; auto. qed.

hoare sha3_384x4_init_h:
 M.sha3_384x4_init : true ==> absorbing_spec4 c768_r8 SHA3_DS_BYTE [] [] [] [] res.
proof. by proc; ecall (keccakx4_init_h 13 6); auto; rewrite /c768_r8 /SHA3_DS_BYTE. qed.

lemma sha3_512x4_init_ll: islossless M.sha3_512x4_init.
proof. by proc; call keccakx4_init_ll; auto. qed.

hoare sha3_512x4_init_h:
 M.sha3_512x4_init : true ==> absorbing_spec4 c1024_r8 SHA3_DS_BYTE [] [] [] [] res.
proof. by proc; ecall (keccakx4_init_h 9 6); auto; rewrite /c1024_r8 /SHA3_DS_BYTE. qed.

lemma shake128x4_init_ll: islossless M.shake128x4_init.
proof. by proc; call keccakx4_init_ll; auto. qed.

hoare shake128x4_init_h:
 M.shake128x4_init : true ==> absorbing_spec4 c256_r8 SHAKE_DS_BYTE [] [] [] [] res.
proof. by proc; ecall (keccakx4_init_h 21 31); auto; rewrite /c256_r8 /SHAKE_DS_BYTE. qed.

lemma shake256x4_init_ll: islossless M.shake256x4_init.
proof. by proc; call keccakx4_init_ll; auto. qed.

hoare shake256x4_init_h:
 M.shake256x4_init : true ==> absorbing_spec4 c512_r8 SHAKE_DS_BYTE [] [] [] [] res.
proof. by proc; ecall (keccakx4_init_h 17 31); auto; rewrite /c512_r8 /SHAKE_DS_BYTE. qed.


(* ========================================================================= *)
(* Absorb (broadcast and independent)                                        *)
(* ========================================================================= *)

lemma keccakx4_absorb_bcast_ll: islossless M.keccakx4_absorb_bcast.
proof. by proc; call absorb_m_bcast_updstate_avx2x4_ll; auto. qed.

hoare keccakx4_absorb_bcast_h _mem _r8 _tb _l0 _l1 _l2 _l3 _buf _len:
 M.keccakx4_absorb_bcast
 : Glob.mem = _mem /\ buf = _buf /\ len = _len
   /\ absorbing_spec4 _r8 _tb _l0 _l1 _l2 _l3 st /\ 0 <= _len
 ==> Glob.mem = _mem
   /\ absorbing_spec4 _r8 _tb (_l0 ++ memread _mem _buf _len) (_l1 ++ memread _mem _buf _len)
                              (_l2 ++ memread _mem _buf _len) (_l3 ++ memread _mem _buf _len) res.
proof. by proc; ecall (absorb_m_bcast_updstate_avx2x4_h _mem _r8 _tb _l0 _l1 _l2 _l3 _buf _len); auto. qed.

lemma keccakx4_absorb_ll: islossless M.keccakx4_absorb.
proof. by proc; call absorb_m_updstate_avx2x4_ll; auto. qed.

hoare keccakx4_absorb_h _mem _r8 _tb _l0 _l1 _l2 _l3 _buf0 _buf1 _buf2 _buf3 _len:
 M.keccakx4_absorb
 : Glob.mem = _mem /\ buf0 = _buf0 /\ buf1 = _buf1 /\ buf2 = _buf2 /\ buf3 = _buf3 /\ len = _len
   /\ absorbing_spec4 _r8 _tb _l0 _l1 _l2 _l3 st /\ 0 <= _len
 ==> Glob.mem = _mem
   /\ absorbing_spec4 _r8 _tb (_l0 ++ memread _mem _buf0 _len) (_l1 ++ memread _mem _buf1 _len)
                              (_l2 ++ memread _mem _buf2 _len) (_l3 ++ memread _mem _buf3 _len) res.
proof.
by proc; ecall (absorb_m_updstate_avx2x4_h _mem _r8 _tb _l0 _l1 _l2 _l3 _buf0 _buf1 _buf2 _buf3 _len); auto.
qed.


(* ========================================================================= *)
(* Squeeze (finishes the absorption on its first call)                       *)
(* ========================================================================= *)

(* the packed state after finish *)
abbrev absorbed4 r8 tb (l0 l1 l2 l3: W8.t list) : state4x =
 st4x_pack (ABSORB1600 tb r8 l0, ABSORB1600 tb r8 l1, ABSORB1600 tb r8 l2, ABSORB1600 tb r8 l3).

(* st has absorbed l0..l3 (lane-wise) and squeezed k bytes per lane: either
   still absorbing (k = 0, nonzero trail byte) or finished (trail byte cleared) *)
op sponge_spec4 (r8: int) (tb: W8.t) (l0 l1 l2 l3: W8.t list) (k: int) (st: W64.t Array101.t) =
    (k = 0 /\ absorbing_spec4 r8 tb l0 l1 l2 l3 st /\ tb <> W8.zero)
 \/ (squeezing_spec4 r8 (absorbed4 r8 tb l0 l1 l2 l3) k st /\ ststatus_trailb st.[100] = W8.zero).

lemma absorbing_sponge_spec4 r8 tb l0 l1 l2 l3 st:
 tb <> W8.zero => absorbing_spec4 r8 tb l0 l1 l2 l3 st => sponge_spec4 r8 tb l0 l1 l2 l3 0 st.
proof. by move=> *; left. qed.

lemma sponge_spec4_r8 r8 tb l0 l1 l2 l3 k st:
 sponge_spec4 r8 tb l0 l1 l2 l3 k st => 0 < r8 /\ 0 <= k.
proof.
case => [[-> [Habs _]] | [Hsq _]]; last by smt().
by move: Habs; rewrite /absorbing_spec4 /status_spec => [#] _ <- _ _; smt(ststatus_r8_bounds).
qed.

lemma finish_avx2x4_spec_trailb st:
 ststatus_trailb (finish_updstate_avx2x4_spec st).[100] = W8.zero.
proof.
rewrite /finish_updstate_avx2x4_spec; case: (ststatus_data_spec st.[100]) => tb r8 at /=.
by rewrite A25u256toA101u64_100 clear_at_trailb_tb.
qed.

lemma ststatus_set_at_trailb (w: W64.t) at:
 ststatus_trailb (ststatus_set_at w at) = ststatus_trailb w.
proof.
have [_ [_ ->]] // := ststatus_byte0 (ststatus_set_at w at) w (truncateu8 (W64.of_int at)) _.
by move=> j Hj; rewrite W8u8.pack8bE // W8u8.Pack.initiE.
qed.

(* finish clears the trail byte *)
hoare finish_updstate_avx2x4_sponge_h _r8 _tb _l0 _l1 _l2 _l3:
 M._finish_updstate_avx2x4
 : absorbing_spec4 _r8 _tb _l0 _l1 _l2 _l3 st
 ==> squeezing_spec4 _r8 (absorbed4 _r8 _tb _l0 _l1 _l2 _l3) 0 res
   /\ ststatus_trailb res.[100] = W8.zero.
proof.
exlim st => _st.
conseq (finish_updstate_avx2x4_spec_h _st); first by move=> />.
move=> &hr [#] <- Habs r ->.
by split; [apply finish_spec_absorbing4 | apply finish_avx2x4_spec_trailb].
qed.

(* the squeeze keeps the trail byte: st is written once, by the final store *)
hoare squeeze_m_updstate_avx2x4_trailb_h _tb:
 M._squeeze_m_updstate_avx2x4
 : ststatus_trailb st.[100] = _tb
 ==> ststatus_trailb res.[100] = _tb.
proof.
proc.
wp; call (: true ==> true) => //.
conseq (: _ ==> ststatus_trailb st.[100] = _tb).
+ by move=> &hr _ stk0 H r; rewrite A25u256toA101u64E A101_set800 A25u256toA101u64_100 ststatus_set_at_trailb.
wp; while (ststatus_trailb st.[100] = _tb).
+ by wp; call (: true ==> true) => //; call (: true ==> true) => //; auto.
wp; seq 5 : (ststatus_trailb st.[100] = _tb).
+ by wp; call (: true ==> true) => //; auto.
by if; [call (: true ==> true) => //; auto | auto].
qed.

hoare squeeze_m_updstate_avx2x4_sponge_h _mem _r8 _s0 _k _buf0 _buf1 _buf2 _buf3 _len:
 M._squeeze_m_updstate_avx2x4
 : Glob.mem = _mem /\ buf0 = _buf0 /\ buf1 = _buf1 /\ buf2 = _buf2 /\ buf3 = _buf3 /\ len = _len
   /\ squeezing_spec4 _r8 _s0 _k st /\ ststatus_trailb st.[100] = W8.zero
   /\ 0 < _len /\ disj4 _buf0 _buf1 _buf2 _buf3 _len
 ==> Glob.mem = stores4 _mem _buf0 _buf1 _buf2 _buf3
                  (sqstream _r8 (st4x_get _s0 0) _k _len) (sqstream _r8 (st4x_get _s0 1) _k _len)
                  (sqstream _r8 (st4x_get _s0 2) _k _len) (sqstream _r8 (st4x_get _s0 3) _k _len)
   /\ squeezing_spec4 _r8 _s0 (_k + _len) res /\ ststatus_trailb res.[100] = W8.zero.
proof.
by conseq (squeeze_m_updstate_avx2x4_h _mem _r8 _s0 _k _buf0 _buf1 _buf2 _buf3 _len)
          (squeeze_m_updstate_avx2x4_trailb_h W8.zero) => /#.
qed.

lemma keccakx4_squeeze_ll: islossless M.keccakx4_squeeze.
proof.
proc; sp; if; last by auto.
by call squeeze_m_updstate_avx2x4_ll; sp; if; [call finish_updstate_avx2x4_ll|]; auto.
qed.

hoare keccakx4_squeeze_h _mem _r8 _tb _l0 _l1 _l2 _l3 _k _buf0 _buf1 _buf2 _buf3 _len:
 M.keccakx4_squeeze
 : Glob.mem = _mem /\ buf0 = _buf0 /\ buf1 = _buf1 /\ buf2 = _buf2 /\ buf3 = _buf3 /\ len = _len
   /\ sponge_spec4 _r8 _tb _l0 _l1 _l2 _l3 _k st /\ 0 <= _len /\ disj4 _buf0 _buf1 _buf2 _buf3 _len
 ==> Glob.mem = stores4 _mem _buf0 _buf1 _buf2 _buf3
                  (sqstream _r8 (ABSORB1600 _tb _r8 _l0) _k _len) (sqstream _r8 (ABSORB1600 _tb _r8 _l1) _k _len)
                  (sqstream _r8 (ABSORB1600 _tb _r8 _l2) _k _len) (sqstream _r8 (ABSORB1600 _tb _r8 _l3) _k _len)
   /\ sponge_spec4 _r8 _tb _l0 _l1 _l2 _l3 (_k + _len) res.
proof.
proc; sp; if; last first.
+ skip => &hr /= [#] _ Hne1 -> Hb0 Hb1 Hb2 Hb3 Hl Hsp H0 D Hne.
  have [Hr Hk] := sponge_spec4_r8 _ _ _ _ _ _ _ _ Hsp.
  have -> : _len = 0 by smt().
  have E: forall s, sqstream _r8 s _k 0 = [] by move=> s; rewrite -size_eq0 size_sqstream /#.
  by rewrite !E /stores4 !store0.
(* the mode test reads the trail byte (protect_64 is the identity) *)
seq 5 : (Glob.mem = _mem /\ buf0 = _buf0 /\ buf1 = _buf1 /\ buf2 = _buf2 /\ buf3 = _buf3 /\ len = _len
         /\ sponge_spec4 _r8 _tb _l0 _l1 _l2 _l3 _k st /\ 0 < _len /\ disj4 _buf0 _buf1 _buf2 _buf3 _len
         /\ trailb = ststatus_trailb st.[100]).
+ by auto => &hr /= [#] _ -> -> -> -> -> -> -> Hsp H0 D Hne.
case (ststatus_trailb st.[100] = W8.zero).
+ (* already squeezing: an absorbing state has the nonzero trail byte tb *)
  rcondf 1; first by auto => /#.
  ecall (squeeze_m_updstate_avx2x4_sponge_h _mem _r8 (absorbed4 _r8 _tb _l0 _l1 _l2 _l3) _k _buf0 _buf1 _buf2 _buf3 _len).
  skip => &hr [#] -> -> -> -> -> -> Hsp H0 D _ Hz.
  case: Hsp => [[-> [Habs Hnz]] | [Hsq _]].
  + have := Habs; rewrite /absorbing_spec4 /status_spec => [#] _ _ Etb _.
    by move: Hnz; rewrite -Etb Hz.
  rewrite /= Hsq Hz H0 D /= => r m [-> [Hsq2 Hz2]].
  by rewrite st4x_get_pack0 st4x_get_pack1 st4x_get_pack2 st4x_get_pack3 /=; right.
(* still absorbing: finish, then squeeze from the start of the stream *)
rcondt 1; first by auto => /#.
ecall (squeeze_m_updstate_avx2x4_sponge_h _mem _r8 (absorbed4 _r8 _tb _l0 _l1 _l2 _l3) 0 _buf0 _buf1 _buf2 _buf3 _len).
ecall (finish_updstate_avx2x4_sponge_h _r8 _tb _l0 _l1 _l2 _l3).
skip => &hr [#] -> -> -> -> -> -> Hsp H0 D _ Hnz.
case: Hsp => [[-> [Habs _]] | [_ Hz]]; last by move: Hnz; rewrite Hz.
split; first exact Habs.
move=> _ r [Hsq Hz] /=; rewrite Hsq Hz H0 D /= => r2 m [-> [Hsq2 Hz2]].
by rewrite st4x_get_pack0 st4x_get_pack1 st4x_get_pack2 st4x_get_pack3 /=; right.
qed.

(* a zero-length squeeze changes nothing: the state may even go on absorbing *)
hoare keccakx4_squeeze_len0_h _mem _st:
 M.keccakx4_squeeze
 : Glob.mem = _mem /\ st = _st /\ len = 0
 ==> Glob.mem = _mem /\ res = _st.
proof. by proc; sp; rcondf 1; auto. qed.
