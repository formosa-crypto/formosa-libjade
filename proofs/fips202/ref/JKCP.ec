(******************************************************************************
   JKCP.ec:

   Correctness of the single-lane C-ABI entry points of the Jasmin Keccak
   Code Package (src/fips202/ref/JKCP.jazz).

   One-shot (state on the stack):
     sha3_{224,256,384,512}(out, in, inlen)
       ==> mem = stores mem0 out (SHA3_n (memread mem0 in inlen))
     shake{128,256}(out, outlen, in, inlen)
       ==> mem = stores mem0 out (SHAKEn (memread mem0 in inlen) outlen)
   Incremental (state owned by the caller):
     sha3_{224,256,384,512}_init, shake{128,256}_init
       ==> absorbing_spec r8 ds [] res, with the algorithm's rate and
           domain-separation byte
     keccak_absorb
       absorbing_spec r8 tb l st ==> absorbing_spec r8 tb (l ++ input) res
     keccak_squeeze (finishes the absorption on its first call)
       sponge_spec r8 tb l k st
       ==> output = sqstream r8 (ABSORB1600 tb r8 l) k len
           /\ sponge_spec r8 tb l (k + len) res
   sponge_spec r8 tb l k st holds while st is absorbing l (k = 0, trail byte
   tb <> 0) and once it has squeezed k bytes after absorbing l (trail byte
   0); keccak_squeeze tells the two apart by the trail byte.

   The entry points only fix the rate and the trail byte, so the proofs
   compose the updstate contracts.  Those exclude a zero-length squeeze,
   which the wrapper skips and the one-shot SHAKE covers with
   squeeze_m_updstate_len0_h (such a squeeze writes nothing).
******************************************************************************)
require import AllCore List Int IntDiv.

from Jasmin require import JModel_x86.

from JazzEC require import Keccak1600_Jazz.
from JazzEC require import Array25 Array26.

require import JWordList.
from CryptoSpecs require import FIPS202_SHA3_Spec Keccak1600_Spec.

require import Keccak1600_updstate Keccak1600_updstate_finish Keccak1600_updstate_ref.
require import Keccakf1600.


(* ========================================================================= *)
(* A zero-length squeeze writes nothing                                      *)
(* ========================================================================= *)

hoare squeeze_m_updstate_len0_h _mem:
 M._squeeze_m_updstate
 : Glob.mem = _mem /\ len = 0
 ==> Glob.mem = _mem.
proof.
proc; inline M.__KECCAK_F.
seq 9: (Glob.mem = _mem /\ len = 0 /\ 8 <= r8 <= 200 /\ 0 <= at < r8).
+ by wp; ecall (ststatus_data_bnd_h); auto.
seq 1: (Glob.mem = _mem /\ len = 0 /\ 8 <= r8 <= 200 /\ 0 <= at < r8).
+ if; last by auto.
  by wp; if; [ecall (keccakf1600_h stk) | ecall (keccakf1600_h stk)]; auto.
(* len = at < r8: the loop is skipped and the last dump covers [at, at) *)
rcondf 2; first by auto => /#.
wp; ecall (dump_m_updstate_h Glob.mem stk at buf len); auto => /> &hr *.
split; first smt().
by move=> _; rewrite /sub mkseq0 store0.
qed.


(* ========================================================================= *)
(* One-shot SHA-3                                                            *)
(* ========================================================================= *)

lemma sha3_ll: islossless M.__sha3.
proof.
proc; call squeeze_m_updstate_ll; wp; call finish_updstate_ll.
by call absorb_m_updstate_ll; call init_updstate_ll; auto.
qed.

hoare sha3_h _mem _out _inp _inlen _r64 _outlen:
 M.__sha3
 : Glob.mem = _mem /\ out = _out /\ inp = _inp /\ inlen = _inlen
   /\ _RATE64 = _r64 /\ _OUTLEN = _outlen
   /\ 0 < _r64 <= 25 /\ 0 <= _inlen /\ 0 < _outlen
 ==> Glob.mem
     = stores _mem _out (KECCAK1600 (8 * _r64) (memread _mem _inp _inlen) SHA3_DS_BYTE _outlen).
proof.
proc.
ecall (squeeze_m_updstate_h _mem (8 * _r64)
         (ABSORB1600 SHA3_DS_BYTE (8 * _r64) (memread _mem _inp _inlen)) 0 _out _outlen).
wp; ecall (finish_updstate_h (8 * _r64) SHA3_DS_BYTE (memread _mem _inp _inlen)).
ecall (absorb_m_updstate_h _mem (8 * _r64) SHA3_DS_BYTE [] _inp _inlen).
ecall (init_updstate_h _r64 SHA3_DS_BYTE).
auto => /> *.
by rewrite sqstream0 /KECCAK1600.
qed.

phoare sha3_ph _mem _out _inp _inlen _r64 _outlen:
 [ M.__sha3
 : Glob.mem = _mem /\ out = _out /\ inp = _inp /\ inlen = _inlen
   /\ _RATE64 = _r64 /\ _OUTLEN = _outlen
   /\ 0 < _r64 <= 25 /\ 0 <= _inlen /\ 0 < _outlen
 ==> Glob.mem
     = stores _mem _out (KECCAK1600 (8 * _r64) (memread _mem _inp _inlen) SHA3_DS_BYTE _outlen)
 ] = 1%r.
proof. by conseq sha3_ll (sha3_h _mem _out _inp _inlen _r64 _outlen). qed.

(* ---- the exported functions ---- *)

lemma sha3_224_ll: islossless M.sha3_224.
proof. by proc; call sha3_ll; auto. qed.

hoare sha3_224_h _mem _out _inp _inlen:
 M.sha3_224
 : Glob.mem = _mem /\ out = _out /\ inp = _inp /\ inlen = _inlen /\ 0 <= _inlen
 ==> Glob.mem = stores _mem _out (SHA3_224 (memread _mem _inp _inlen)).
proof. by proc; ecall (sha3_h _mem _out _inp _inlen 18 28); auto. qed.

phoare sha3_224_ph _mem _out _inp _inlen:
 [ M.sha3_224
 : Glob.mem = _mem /\ out = _out /\ inp = _inp /\ inlen = _inlen /\ 0 <= _inlen
 ==> Glob.mem = stores _mem _out (SHA3_224 (memread _mem _inp _inlen))
 ] = 1%r.
proof. by conseq sha3_224_ll (sha3_224_h _mem _out _inp _inlen). qed.

lemma sha3_256_ll: islossless M.sha3_256.
proof. by proc; call sha3_ll; auto. qed.

hoare sha3_256_h _mem _out _inp _inlen:
 M.sha3_256
 : Glob.mem = _mem /\ out = _out /\ inp = _inp /\ inlen = _inlen /\ 0 <= _inlen
 ==> Glob.mem = stores _mem _out (SHA3_256 (memread _mem _inp _inlen)).
proof. by proc; ecall (sha3_h _mem _out _inp _inlen 17 32); auto. qed.

phoare sha3_256_ph _mem _out _inp _inlen:
 [ M.sha3_256
 : Glob.mem = _mem /\ out = _out /\ inp = _inp /\ inlen = _inlen /\ 0 <= _inlen
 ==> Glob.mem = stores _mem _out (SHA3_256 (memread _mem _inp _inlen))
 ] = 1%r.
proof. by conseq sha3_256_ll (sha3_256_h _mem _out _inp _inlen). qed.

lemma sha3_384_ll: islossless M.sha3_384.
proof. by proc; call sha3_ll; auto. qed.

hoare sha3_384_h _mem _out _inp _inlen:
 M.sha3_384
 : Glob.mem = _mem /\ out = _out /\ inp = _inp /\ inlen = _inlen /\ 0 <= _inlen
 ==> Glob.mem = stores _mem _out (SHA3_384 (memread _mem _inp _inlen)).
proof. by proc; ecall (sha3_h _mem _out _inp _inlen 13 48); auto. qed.

phoare sha3_384_ph _mem _out _inp _inlen:
 [ M.sha3_384
 : Glob.mem = _mem /\ out = _out /\ inp = _inp /\ inlen = _inlen /\ 0 <= _inlen
 ==> Glob.mem = stores _mem _out (SHA3_384 (memread _mem _inp _inlen))
 ] = 1%r.
proof. by conseq sha3_384_ll (sha3_384_h _mem _out _inp _inlen). qed.

lemma sha3_512_ll: islossless M.sha3_512.
proof. by proc; call sha3_ll; auto. qed.

hoare sha3_512_h _mem _out _inp _inlen:
 M.sha3_512
 : Glob.mem = _mem /\ out = _out /\ inp = _inp /\ inlen = _inlen /\ 0 <= _inlen
 ==> Glob.mem = stores _mem _out (SHA3_512 (memread _mem _inp _inlen)).
proof. by proc; ecall (sha3_h _mem _out _inp _inlen 9 64); auto. qed.

phoare sha3_512_ph _mem _out _inp _inlen:
 [ M.sha3_512
 : Glob.mem = _mem /\ out = _out /\ inp = _inp /\ inlen = _inlen /\ 0 <= _inlen
 ==> Glob.mem = stores _mem _out (SHA3_512 (memread _mem _inp _inlen))
 ] = 1%r.
proof. by conseq sha3_512_ll (sha3_512_h _mem _out _inp _inlen). qed.


(* ========================================================================= *)
(* One-shot SHAKE                                                            *)
(* ========================================================================= *)

lemma shake_ll: islossless M.__shake.
proof.
proc; call squeeze_m_updstate_ll; call finish_updstate_ll.
by call absorb_m_updstate_ll; call init_updstate_ll; auto.
qed.

hoare shake_h _mem _out _outlen _inp _inlen _r64:
 M.__shake
 : Glob.mem = _mem /\ out = _out /\ outlen = _outlen /\ inp = _inp /\ inlen = _inlen
   /\ _RATE64 = _r64 /\ 0 < _r64 <= 25 /\ 0 <= _inlen /\ 0 <= _outlen
 ==> Glob.mem
     = stores _mem _out (KECCAK1600 (8 * _r64) (memread _mem _inp _inlen) SHAKE_DS_BYTE _outlen).
proof.
proc.
case (_outlen = 0).
+ ecall (squeeze_m_updstate_len0_h _mem).
  ecall (finish_updstate_h (8 * _r64) SHAKE_DS_BYTE (memread _mem _inp _inlen)).
  ecall (absorb_m_updstate_h _mem (8 * _r64) SHAKE_DS_BYTE [] _inp _inlen).
  ecall (init_updstate_h _r64 SHAKE_DS_BYTE).
  auto => /> *.
  by rewrite /KECCAK1600 /SQUEEZE1600 take0 store0.
ecall (squeeze_m_updstate_h _mem (8 * _r64)
         (ABSORB1600 SHAKE_DS_BYTE (8 * _r64) (memread _mem _inp _inlen)) 0 _out _outlen).
ecall (finish_updstate_h (8 * _r64) SHAKE_DS_BYTE (memread _mem _inp _inlen)).
ecall (absorb_m_updstate_h _mem (8 * _r64) SHAKE_DS_BYTE [] _inp _inlen).
ecall (init_updstate_h _r64 SHAKE_DS_BYTE).
auto => /> *.
split; first smt().
by move=> *; rewrite sqstream0 /KECCAK1600.
qed.

phoare shake_ph _mem _out _outlen _inp _inlen _r64:
 [ M.__shake
 : Glob.mem = _mem /\ out = _out /\ outlen = _outlen /\ inp = _inp /\ inlen = _inlen
   /\ _RATE64 = _r64 /\ 0 < _r64 <= 25 /\ 0 <= _inlen /\ 0 <= _outlen
 ==> Glob.mem
     = stores _mem _out (KECCAK1600 (8 * _r64) (memread _mem _inp _inlen) SHAKE_DS_BYTE _outlen)
 ] = 1%r.
proof. by conseq shake_ll (shake_h _mem _out _outlen _inp _inlen _r64). qed.

(* ---- the exported functions ---- *)

lemma shake128_ll: islossless M.shake128.
proof. by proc; call shake_ll; auto. qed.

hoare shake128_h _mem _out _outlen _inp _inlen:
 M.shake128
 : Glob.mem = _mem /\ out = _out /\ outlen = _outlen /\ inp = _inp /\ inlen = _inlen
   /\ 0 <= _inlen /\ 0 <= _outlen
 ==> Glob.mem = stores _mem _out (SHAKE128 (memread _mem _inp _inlen) _outlen).
proof. by proc; ecall (shake_h _mem _out _outlen _inp _inlen 21); auto. qed.

phoare shake128_ph _mem _out _outlen _inp _inlen:
 [ M.shake128
 : Glob.mem = _mem /\ out = _out /\ outlen = _outlen /\ inp = _inp /\ inlen = _inlen
   /\ 0 <= _inlen /\ 0 <= _outlen
 ==> Glob.mem = stores _mem _out (SHAKE128 (memread _mem _inp _inlen) _outlen)
 ] = 1%r.
proof. by conseq shake128_ll (shake128_h _mem _out _outlen _inp _inlen). qed.

lemma shake256_ll: islossless M.shake256.
proof. by proc; call shake_ll; auto. qed.

hoare shake256_h _mem _out _outlen _inp _inlen:
 M.shake256
 : Glob.mem = _mem /\ out = _out /\ outlen = _outlen /\ inp = _inp /\ inlen = _inlen
   /\ 0 <= _inlen /\ 0 <= _outlen
 ==> Glob.mem = stores _mem _out (SHAKE256 (memread _mem _inp _inlen) _outlen).
proof. by proc; ecall (shake_h _mem _out _outlen _inp _inlen 17); auto. qed.

phoare shake256_ph _mem _out _outlen _inp _inlen:
 [ M.shake256
 : Glob.mem = _mem /\ out = _out /\ outlen = _outlen /\ inp = _inp /\ inlen = _inlen
   /\ 0 <= _inlen /\ 0 <= _outlen
 ==> Glob.mem = stores _mem _out (SHAKE256 (memread _mem _inp _inlen) _outlen)
 ] = 1%r.
proof. by conseq shake256_ll (shake256_h _mem _out _outlen _inp _inlen). qed.


(* ========================================================================= *)
(* Incremental: per-variant init                                             *)
(* ========================================================================= *)

lemma keccak_init_ll: islossless M.__keccak_init.
proof. by proc; call init_updstate_ll; auto. qed.

hoare keccak_init_h _r64 _tb:
 M.__keccak_init
 : _RATE64 = _r64 /\ _TRAILB = _tb /\ 0 < _r64 <= 25
 ==> absorbing_spec (8 * _r64) (W8.of_int _tb) [] res.
proof. by proc; ecall (init_updstate_h _r64 (W8.of_int _tb)); auto. qed.

lemma sha3_224_init_ll: islossless M.sha3_224_init.
proof. by proc; call keccak_init_ll; auto. qed.

hoare sha3_224_init_h:
 M.sha3_224_init : true ==> absorbing_spec c448_r8 SHA3_DS_BYTE [] res.
proof. by proc; ecall (keccak_init_h 18 6); auto; rewrite /c448_r8 /SHA3_DS_BYTE. qed.

lemma sha3_256_init_ll: islossless M.sha3_256_init.
proof. by proc; call keccak_init_ll; auto. qed.

hoare sha3_256_init_h:
 M.sha3_256_init : true ==> absorbing_spec c512_r8 SHA3_DS_BYTE [] res.
proof. by proc; ecall (keccak_init_h 17 6); auto; rewrite /c512_r8 /SHA3_DS_BYTE. qed.

lemma sha3_384_init_ll: islossless M.sha3_384_init.
proof. by proc; call keccak_init_ll; auto. qed.

hoare sha3_384_init_h:
 M.sha3_384_init : true ==> absorbing_spec c768_r8 SHA3_DS_BYTE [] res.
proof. by proc; ecall (keccak_init_h 13 6); auto; rewrite /c768_r8 /SHA3_DS_BYTE. qed.

lemma sha3_512_init_ll: islossless M.sha3_512_init.
proof. by proc; call keccak_init_ll; auto. qed.

hoare sha3_512_init_h:
 M.sha3_512_init : true ==> absorbing_spec c1024_r8 SHA3_DS_BYTE [] res.
proof. by proc; ecall (keccak_init_h 9 6); auto; rewrite /c1024_r8 /SHA3_DS_BYTE. qed.

lemma shake128_init_ll: islossless M.shake128_init.
proof. by proc; call keccak_init_ll; auto. qed.

hoare shake128_init_h:
 M.shake128_init : true ==> absorbing_spec c256_r8 SHAKE_DS_BYTE [] res.
proof. by proc; ecall (keccak_init_h 21 31); auto; rewrite /c256_r8 /SHAKE_DS_BYTE. qed.

lemma shake256_init_ll: islossless M.shake256_init.
proof. by proc; call keccak_init_ll; auto. qed.

hoare shake256_init_h:
 M.shake256_init : true ==> absorbing_spec c512_r8 SHAKE_DS_BYTE [] res.
proof. by proc; ecall (keccak_init_h 17 31); auto; rewrite /c512_r8 /SHAKE_DS_BYTE. qed.


(* ========================================================================= *)
(* Incremental: absorb / squeeze                                             *)
(* ========================================================================= *)

lemma keccak_absorb_ll: islossless M.keccak_absorb.
proof. by proc; call absorb_m_updstate_ll; auto. qed.

hoare keccak_absorb_h _mem _r8 _tb _l _buf _len:
 M.keccak_absorb
 : Glob.mem = _mem /\ buf = _buf /\ len = _len /\ absorbing_spec _r8 _tb _l st /\ 0 <= _len
 ==> Glob.mem = _mem /\ absorbing_spec _r8 _tb (_l ++ memread _mem _buf _len) res.
proof. by proc; ecall (absorb_m_updstate_h _mem _r8 _tb _l _buf _len); auto. qed.

(* ---- the two modes of the state ---- *)

(* st has absorbed l and squeezed k bytes: either still absorbing (k = 0,
   nonzero trail byte) or finished (trail byte cleared) *)
op sponge_spec (r8: int) (tb: W8.t) (l: W8.t list) (k: int) (st: W64.t Array26.t) =
    (k = 0 /\ absorbing_spec r8 tb l st /\ tb <> W8.zero)
 \/ (squeezing_spec r8 (ABSORB1600 tb r8 l) k st /\ ststatus_trailb st.[25] = W8.zero).

lemma absorbing_sponge_spec r8 tb l st:
 tb <> W8.zero => absorbing_spec r8 tb l st => sponge_spec r8 tb l 0 st.
proof. by move=> *; left. qed.

lemma sponge_spec_r8 r8 tb l k st:
 sponge_spec r8 tb l k st => 0 < r8 /\ 0 <= k.
proof.
case => [[-> [Habs _]] | [Hsq _]]; last by smt().
by have := absorbing_spec_r8 _ _ _ _ Habs; smt().
qed.

(* the trail bytes of SHA-3 and SHAKE are nonzero *)
lemma SHA3_DS_BYTE_nz: SHA3_DS_BYTE <> W8.zero.
proof. by rewrite /SHA3_DS_BYTE W8.to_uint_eq W8.of_uintK W8.to_uint0. qed.

lemma SHAKE_DS_BYTE_nz: SHAKE_DS_BYTE <> W8.zero.
proof. by rewrite /SHAKE_DS_BYTE W8.to_uint_eq W8.of_uintK W8.to_uint0. qed.

(* finish clears the trail byte *)
hoare finish_updstate_sponge_h _r8 _tb _l:
 M._finish_updstate
 : absorbing_spec _r8 _tb _l st
 ==> squeezing_spec _r8 (ABSORB1600 _tb _r8 _l) 0 res /\ ststatus_trailb res.[25] = W8.zero.
proof.
exlim st => _st.
conseq (finish_updstate_spec_h _st); first by move=> />.
move=> &hr [#] <- Habs r ->.
by split; [apply finish_spec_absorbing | apply finish_spec_trailb].
qed.

(* the squeeze keeps the trail byte: st is written once, by the final store *)
hoare squeeze_m_updstate_trailb_h _tb:
 M._squeeze_m_updstate
 : ststatus_trailb st.[25] = _tb
 ==> ststatus_trailb res.[25] = _tb.
proof.
proc; inline M.__KECCAK_F.
wp; call (: true ==> true) => //.
conseq (: _ ==> ststatus_trailb st.[25] = _tb).
+ by move=> &hr _ stk0 H r; rewrite st26_storeE st26_store_trailb.
wp; while (ststatus_trailb st.[25] = _tb).
+ seq 1 : (ststatus_trailb st.[25] = _tb); first by call (: true ==> true) => //; auto.
  by if; (wp; call (: true ==> true) => //; auto).
wp; seq 9 : (ststatus_trailb st.[25] = _tb).
+ by wp; call (: true ==> true) => //; auto.
by if; [wp; if; (call (: true ==> true) => //; auto) | auto].
qed.

hoare squeeze_m_updstate_sponge_h _mem _r8 _st0 _k _buf _len:
 M._squeeze_m_updstate
 : Glob.mem = _mem /\ buf = _buf /\ len = _len /\ squeezing_spec _r8 _st0 _k st
   /\ ststatus_trailb st.[25] = W8.zero /\ 0 < _len
 ==> Glob.mem = stores _mem _buf (sqstream _r8 _st0 _k _len)
   /\ squeezing_spec _r8 _st0 (_k + _len) res /\ ststatus_trailb res.[25] = W8.zero.
proof.
by conseq (squeeze_m_updstate_h _mem _r8 _st0 _k _buf _len) (squeeze_m_updstate_trailb_h W8.zero) => /#.
qed.

(* ---- the merged squeeze ---- *)

lemma keccak_squeeze_ll: islossless M.keccak_squeeze.
proof.
proc; sp; if; last by auto.
by call squeeze_m_updstate_ll; sp; if; [call finish_updstate_ll|]; auto.
qed.

hoare keccak_squeeze_h _mem _r8 _tb _l _k _buf _len:
 M.keccak_squeeze
 : Glob.mem = _mem /\ buf = _buf /\ len = _len /\ sponge_spec _r8 _tb _l _k st /\ 0 <= _len
 ==> Glob.mem = stores _mem _buf (sqstream _r8 (ABSORB1600 _tb _r8 _l) _k _len)
   /\ sponge_spec _r8 _tb _l (_k + _len) res.
proof.
proc; sp; if; last first.
+ skip => &hr /= [#] _ Hne1 -> Hb Hl Hsp H0 Hne.
  have [Hr Hk] := sponge_spec_r8 _ _ _ _ _ Hsp.
  have -> : _len = 0 by smt().
  have -> : sqstream _r8 (ABSORB1600 _tb _r8 _l) _k 0 = [] by rewrite -size_eq0 size_sqstream /#.
  by rewrite store0.
(* the mode test reads the trail byte (protect_64 is the identity) *)
seq 5 : (Glob.mem = _mem /\ buf = _buf /\ len = _len /\ sponge_spec _r8 _tb _l _k st /\ 0 < _len
         /\ trailb = ststatus_trailb st.[25]).
+ by auto => &hr /= [#] _ -> -> -> -> Hsp H0 Hne.
case (ststatus_trailb st.[25] = W8.zero).
+ (* already squeezing: an absorbing state has the nonzero trail byte tb *)
  rcondf 1; first by auto => /#.
  ecall (squeeze_m_updstate_sponge_h _mem _r8 (ABSORB1600 _tb _r8 _l) _k _buf _len).
  skip => &hr [#] -> -> -> Hsp H0 _ Hz.
  case: Hsp => [[-> [Habs Hnz]] | [Hsq _]].
  + have := Habs; rewrite /absorbing_spec /status_spec => [#] _ _ Etb _.
    by move: Hnz; rewrite -Etb Hz.
  by rewrite /= Hsq Hz H0 /= => r m [-> [Hsq2 Hz2]]; split => //; right.
(* still absorbing: finish, then squeeze from the start of the stream *)
rcondt 1; first by auto => /#.
ecall (squeeze_m_updstate_sponge_h _mem _r8 (ABSORB1600 _tb _r8 _l) 0 _buf _len).
ecall (finish_updstate_sponge_h _r8 _tb _l).
skip => &hr [#] -> -> -> Hsp H0 _ Hnz.
case: Hsp => [[-> [Habs _]] | [_ Hz]]; last by move: Hnz; rewrite Hz.
split; first exact Habs.
by move=> _ r [Hsq Hz] /=; rewrite Hsq Hz H0 /= => r2 m [-> [Hsq2 Hz2]]; split => //; right.
qed.

(* a zero-length squeeze changes nothing: the state may even go on absorbing *)
hoare keccak_squeeze_len0_h _mem _st:
 M.keccak_squeeze
 : Glob.mem = _mem /\ st = _st /\ len = 0
 ==> Glob.mem = _mem /\ res = _st.
proof. by proc; sp; rcondf 1; auto. qed.


(* ========================================================================= *)
(* The incremental API composes to the hash functions: SHA3-256              *)
(* ========================================================================= *)

module IncrementalSHA3_256 = {
  proc main(out inp inlen: int) : unit = {
    var st: W64.t Array26.t;
    st <- witness;
    st <@ M.sha3_256_init(st);
    st <@ M.keccak_absorb(st, inp, inlen);
    st <@ M.keccak_squeeze(st, out, 32);
  }
}.

hoare incremental_sha3_256_h _mem _out _inp _inlen:
 IncrementalSHA3_256.main
 : Glob.mem = _mem /\ out = _out /\ inp = _inp /\ inlen = _inlen /\ 0 <= _inlen
 ==> Glob.mem = stores _mem _out (SHA3_256 (memread _mem _inp _inlen)).
proof.
proc.
ecall (keccak_squeeze_h _mem c512_r8 SHA3_DS_BYTE (memread _mem _inp _inlen) 0 _out 32).
ecall (keccak_absorb_h _mem c512_r8 SHA3_DS_BYTE [] _inp _inlen).
ecall (sha3_256_init_h).
auto => &hr [#] -> -> -> -> H0 st0 Hst0 /=.
split; first done.
move=> _ st1 Hst1 /=.
split; first by apply absorbing_sponge_spec => //; exact SHA3_DS_BYTE_nz.
by move=> _ st2 m [-> _]; rewrite sqstream0 /SHA3_256.
qed.
