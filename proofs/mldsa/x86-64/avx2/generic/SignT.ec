require import AllCore List IntDiv RealExp.
from Jasmin require import JModel_x86.
from Spec require import GFq Rq Parameters MLDSA_W32_Rep Symmetric.
require import Array2 Array32 Array64 Array128 Array256 Array416 XWord4.
require import BitEncoding JWordList.
require BaseT PreludeT PolynomialT CommonNttT CommonModularT CommonInvertNttT.
require CommonRoundingT RoundingT ErrorPolynomialT RowVectorT ColumnVectorT.
require SignatureT SignNormChecksT MatrixAT MaskT ChallengeT CommitmentT S1T S2T T0T HashingT.

abstract theory SignT.

clone import BaseT.BaseT as B.
import S R MLDSAParams.
clone import PreludeT.PreludeT as PR with theory B <= B.
clone import PolynomialT.PolynomialT as PL with theory B <= B.
clone import CommonNttT.CommonNttT as CN with theory B <= B.
clone import CommonModularT.CommonModularT as CM with theory B <= B.
clone import CommonInvertNttT.CommonInvertNttT as CI with theory B <= B.
clone import CommonRoundingT.CommonRoundingT as CRD with theory B <= B.
clone import RoundingT.RoundingT as RD with theory B <= B.
clone import ErrorPolynomialT.ErrorPolynomialT as EP with theory B <= B.
clone import RowVectorT.RowVectorT as RV with
  theory B <= B, theory PR <= PR, theory PL <= PL, theory CN <= CN, theory CM <= CM.
clone import ColumnVectorT.ColumnVectorT as CV with
  theory B <= B, theory PR <= PR, theory PL <= PL, theory CN <= CN, theory CI <= CI,
  theory CM <= CM, theory CRD <= CRD, theory RD <= RD.
clone import SignatureT.SignatureT as SG with theory B <= B, theory PR <= PR.
clone import SignNormChecksT.SignNormChecksT as SNC with
  theory B <= B, theory PR <= PR, theory PL <= PL, theory CM <= CM, theory CI <= CI,
  theory CRD <= CRD, theory RV <= RV, theory SG <= SG.
clone import MatrixAT.MatrixAT as MA with theory B <= B, theory PR <= PR.
clone import MaskT.MaskT as MK with theory B <= B, theory PR <= PR, theory G1 <= SG.G1.
clone import ChallengeT.ChallengeT as CH with theory B <= B.
clone import CommitmentT.CommitmentT as CMT with theory B <= B, theory PR <= PR.
clone import S1T.S1T as S1E with theory B <= B, theory PR <= PR, theory EP <= EP.
clone import S2T.S2T as S2E with theory B <= B, theory PR <= PR, theory EP <= EP.
clone import T0T.T0T as T0 with theory B <= B, theory PR <= PR.
clone import HashingT.HashingT as HS with theory B <= B.
import CR.

import PolyLVec PolyKVec PolyMat.
import Round ZModQ Zq.
import Array_ctilde Array_sk_enc Array_sig_enc Array_s1_enc Array_s2_enc Array_t0_enc.
import Array_lpolys Array_kpolys Array_w1vec_enc Array_eta_enc.
import BitChunking.

(* -------------------------------------------------------------------- *)
(* Word packing in the byte view of an L-vector, for the copy of the     *)
(* mask into mask_as_ntt.                                                *)
(* -------------------------------------------------------------------- *)

lemma get32_init32 (f : int -> W32.t) (i : int) :
  0 <= i < lpolys =>
  WArray_lpolys_bytes.get32 (WArray_lpolys_bytes.init32 f) i = f i.
proof.
move => Hi; have ? : lpolys_bytes = 4 * lpolys by done.
rewrite /WArray_lpolys_bytes.get32_direct /WArray_lpolys_bytes.init32 /W4u8.pack4_t /=.
apply W32.wordP => k kb.
rewrite W32.initiE 1:/# /= W4u8.Pack.initiE 1:/# /=.
rewrite WArray_lpolys_bytes.initiE 1:/# /=.
rewrite (_: (4 * i + k %/ 8) %/ 4 = i) 1:/#.
rewrite (_: (4 * i + k %/ 8) %% 4 = k %/ 8) 1:/#.
by rewrite W4u8.get_bits8 1:/# /#.
qed.

lemma get32_set256_direct_eq (t : WArray_lpolys_bytes.t) (j i : int) (w : W256.t) :
  0 <= j =>
  j + 32 <= lpolys_bytes =>
  j %% 4 = 0 =>
  0 <= i < lpolys =>
  WArray_lpolys_bytes.get32 (WArray_lpolys_bytes.set256_direct t j w) i =
  if j %/ 4 <= i < j %/ 4 + 8
  then w \bits32 (i - j %/ 4)
  else WArray_lpolys_bytes.get32 t i.
proof.
move => Hj_lo Hj_hi Hj_mod Hi; have ? : lpolys_bytes = 4 * lpolys by done.
rewrite /WArray_lpolys_bytes.get32_direct /=.
apply W32.wordP => k kb.
rewrite /W4u8.pack4_t W32.initiE 1:/# /= W4u8.Pack.initiE 1:/# /=.
rewrite /WArray_lpolys_bytes.set256_direct WArray_lpolys_bytes.initiE 1:/# /=.
case (j %/ 4 <= i < j %/ 4 + 8) => Hi_region.
+ rewrite (_: j <= 4 * i + k %/ 8 < j + 32) 1:/# /=.
  rewrite /W8u32.(\bits32) /W32u8.(\bits8) W32.initiE 1:/# /= W8.initiE 1:/# /=.
  congr; smt().
rewrite (_: !(j <= 4 * i + k %/ 8 < j + 32)) 1:/# /=.
rewrite /WArray_lpolys_bytes.get32_direct /W4u8.pack4_t.
by rewrite W32.initiE 1:/# /= W4u8.Pack.initiE 1:/#.
qed.

lemma get256_direct_init32_bits32 (f : int -> W32.t) (j k : int) :
  0 <= j =>
  j + 32 <= lpolys_bytes =>
  j %% 4 = 0 =>
  0 <= k < 8 =>
  (WArray_lpolys_bytes.get256_direct (WArray_lpolys_bytes.init32 f) j) \bits32 k
  = f (j %/ 4 + k).
proof.
move => Hj_lo Hj_hi Hj_mod Hk.
rewrite /get256_direct /W8u32.(\bits32) /=.
apply W32.wordP => b bb.
rewrite W32.initiE 1:/# /= pack32wE 1:/# W32u8.Pack.initiE 1:/# /=.
rewrite /init32 WArray_lpolys_bytes.initiE 1:/# /=.
rewrite (_: (j + (k * 32 + b) %/ 8) %/ 4 = j %/ 4 + k) 1:/#.
rewrite (_: (j + (k * 32 + b) %/ 8) %% 4 = b %/ 8) 1:/#.
rewrite (_: (k * 32 + b) %% 8 = b %% 8) 1:/#.
by rewrite W4u8.get_bits8 1:/# /#.
qed.

(* -------------------------------------------------------------------- *)
(* Loop-body machine-arithmetic helper.                                 *)
(*                                                                      *)
(* At the bottom of the rejection-sampling loop, the Jasmin code        *)
(* increments `domain_separator_for_mask` (a W16 counter advancing by   *)
(* lvec per iteration) and tests whether the loop has run kappa_max     *)
(* times via the xor+TEST_32+SETcc chain:                               *)
(*                                                                      *)
(*   kappa_diff        := zeroextu32 dsep `^` of_int ((2^16-1 - lvec) %/ lvec * lvec) *)
(*   kappa_bit         := SETcc (TEST_32 kappa_diff kappa_diff).`5      *)
(*   kappa_exceeded_R  := kappa_exceeded `|` zeroextu64 kappa_bit       *)
(*                                                                      *)
(* This packages the key invariant the smt() at the end of the loop    *)
(* body needs: that `kappa_exceeded_R` tracks `kappa_max <= kappa+1`    *)
(* exactly, assuming the prior iteration's `kappa_exceeded` tracked    *)
(* `kappa_max <= kappa`, and the counter has advanced by `lvec`.        *)
(* -------------------------------------------------------------------- *)

lemma kappa_bit_update (kappa : int) (kappa_e : W64.t) (dsep : W16.t) :
  0 <= kappa =>
  kappa_max = (65535 - lvec) %/ lvec =>
  W16.to_uint dsep = (kappa + 1) * lvec =>
  (kappa_e = W64.one) = (kappa_max <= kappa) =>
  (kappa_e <> W64.one => kappa_e = W64.zero) =>
  let kappa_diff    = zeroextu32 dsep `^` W32.of_int ((65535 - lvec) %/ lvec * lvec) in
  let kappa_bit     = SETcc (TEST_32 kappa_diff kappa_diff).`5 in
  let kappa_exc_R   = kappa_e `|` zeroextu64 kappa_bit in
  (kappa_exc_R = W64.one) = (kappa_max <= kappa + 1) /\
  (kappa_exc_R <> W64.one => kappa_exc_R = W64.zero).
proof.
move => H0 Hkm Hd Hke Hke01 /=.
have Hl := gt0_l.
have HK0 : 0 <= (65535 - lvec) %/ lvec by apply divz_ge0 => //; smt(param_sets).
have HK1 : (65535 - lvec) %/ lvec * lvec <= 65535 - lvec by apply lez_floor; smt().
have Hdu := W16.to_uint_cmp dsep.
(* the difference is zero exactly when the counter reaches kappa_max * lvec *)
have Hxor : (zeroextu32 dsep `^` W32.of_int ((65535 - lvec) %/ lvec * lvec) = W32.zero) =
            (kappa + 1 = kappa_max).
+ rewrite W32.WRing.addr_eq0 /oppw /= to_uint_eq to_uint_zeroextu32 W32.of_uintK pmod_small.
  + smt().
  rewrite Hd Hkm eq_iff; split => [h | -> //].
  by apply (mulIf lvec); smt().
rewrite /SETcc /TEST_32 /rflags_of_bwop /ZF_of /= Hxor.
case (kappa_max <= kappa) => hk.
+ have -> : kappa_e = W64.one by smt().
  by rewrite (: kappa_max <= kappa + 1) 1:/#; case (kappa + 1 = kappa_max) => _ /=;
     rewrite /zeroextu64 /= ?orw0 ?orwK.
have -> : kappa_e = W64.zero by smt().
case (kappa + 1 = kappa_max) => hK /=.
+ by rewrite (: kappa_max <= kappa + 1) 1:/# /zeroextu64 /= ?or0w.
have -> : zeroextu64 W8.zero = W64.zero by rewrite /zeroextu64 /=.
by rewrite (: !kappa_max <= kappa + 1) 1:/#; smt(W64.to_uint_eq W64.to_uint0 W64.to_uint1).
qed.

(* Companion: the exit-flag update. Given the 0/1 invariant on the norm-check
   result (`ncr`) and on the kappa-exceeded flag (`kappa_exc_R`), the new
   exit flag `ers_R = ncr `^` 1 `|` kappa_exc_R` is zero iff both the norm
   checks passed (`ncr = 1` on Jasmin side is failure, `= 0` is success —
   so a zero exit flag requires `ncr = 1`, i.e. *failure*, and kappa not
   yet exceeded). The branching on `bz`/`bh` in the spec gives exactly
   `zh_L = None <=> ncr = 1` at the call site. *)

lemma exit_loop_update (ncr kappa_exc_R : W64.t) :
  (ncr = W64.zero \/ ncr = W64.one) =>
  (kappa_exc_R = W64.one \/ kappa_exc_R = W64.zero) =>
  let ers_R = ncr `^` W64.one `|` kappa_exc_R in
  (ers_R = W64.zero) = (ncr = W64.one /\ kappa_exc_R = W64.zero).
  proof.
simplify => H H0.
elim H => ->; elim H0 => -> /=;
  smt(W64.to_uint_eq W64.of_uintK W64.to_uintK pow2_64 W64.WRing.addr_eq0).
qed.

(* the sizes of the parts of the signing key, against the specification *)
lemma eta_encE : n * noise_bits %/ 8 = eta_enc.
proof. by rewrite /eta_enc (: n * noise_bits = 32 * noise_bits * 8) 1:#ring mulzK. qed.

lemma s1_bytesE : n * noise_bits * lvec %/ 8 = lvec * eta_enc.
proof.
by rewrite /eta_enc (: n * noise_bits * lvec = lvec * (32 * noise_bits) * 8) 1:#ring mulzK.
qed.

lemma s2_bytesE : n * noise_bits * kvec %/ 8 = kvec * eta_enc.
proof.
by rewrite /eta_enc (: n * noise_bits * kvec = kvec * (32 * noise_bits) * 8) 1:#ring mulzK.
qed.

lemma t0_bytesE : n * d * kvec %/ 8 = kvec * 416.
proof. by rewrite (: n * d * kvec = kvec * 416 * 8) 1:#ring mulzK. qed.

lemma sk_encE : sk_enc = sk_bytes.
proof. by rewrite /sk_enc /s1_enc /s2_enc /t0_enc s1_bytesE s2_bytesE t0_bytesE; ring. qed.

lemma s2_valid_commutes (sk : W8.t Array_sk_enc.t) :
  valid_s2_bytes (Array_s2_enc.init (fun (i : int) => sk.[128 + lvec * eta_enc + i])) =>
  valid_sk_s2 (BytesSK.of_list (to_list sk)).
proof.
have Hnb : ilog 2 (Eta + Eta) + 1 = noise_bits.
+ have [] -> : Eta = 2 \/ Eta = 4 by smt(param_sets).
  + by rewrite (: 2 + 2 = 2 ^ 2) 1:// ilog_powK.
  by rewrite (: 4 + 4 = 2 ^ 3) 1:// ilog_powK.
rewrite /valid_s2_bytes /valid_sk_s2 /valid_eta_bytes Hnb => H k kb i ib.
have := H k kb i ib.
rewrite BytesSK.of_listK; 1: by rewrite size_to_list sk_encE.
rewrite s1_bytesE eta_encE /BitsToInteger /to_uint.
have Hnb0 : 0 < noise_bits by smt().
have Hee : eta_enc = 32 * noise_bits by done.
have Hk : (k + 1) * eta_enc <= kvec * eta_enc.
+ by apply StdOrder.IntOrder.ler_wpmul2r; smt(ge0_eta_enc).
have Hsk : 128 + lvec * eta_enc + kvec * eta_enc <= sk_enc.
+ by rewrite /sk_enc /s1_enc /s2_enc; smt(ge0_t0_enc).
have ? := ge0_eta_enc; have ? : 0 <= lvec * eta_enc by smt(gt0_l).
have ? : 0 <= k * eta_enc by smt().
pose L := take eta_enc (drop (128 + lvec * eta_enc + k * eta_enc) (to_list sk)).
have HL : size L = eta_enc.
+ by rewrite /L size_take 1:// size_drop 1:/# size_to_list; smt().
have HLn : forall p, 0 <= p < eta_enc =>
  nth witness L p = sk.[128 + lvec * eta_enc + k * eta_enc + p].
+ by move=> p hp; rewrite /L nth_take 1,2:/# nth_drop 1,2:/# get_to_list.
have ? : 0 <= noise_bits * i by smt().
have ? : noise_bits * i + noise_bits <= 8 * eta_enc by smt().
rewrite (nth_change_dfl [] witness).
+ by rewrite size_chunk 1:// size_BytesToBits HL; smt().
rewrite nth_chunk //.
+ smt().
+ by rewrite size_BytesToBits HL; smt().
suff -> : take noise_bits (drop (noise_bits * i) (BytesToBits L)) =
  mkseq (fun (j : int) =>
    (Array_eta_enc.init (fun (i0 : int) =>
       (Array_s2_enc.init (fun (i1 : int) => sk.[128 + lvec * eta_enc + i1])).[
          k * eta_enc + i0])).[(noise_bits * i + j) %/ 8].[(noise_bits * i + j) %% 8])
    noise_bits by done.
apply (eq_from_nth false).
+ by rewrite size_mkseq size_take 1:/# size_drop 1:/# size_BytesToBits HL; smt().
move=> j; rewrite size_take 1:/# size_drop 1:/# size_BytesToBits HL => hj.
have hj' : 0 <= j < noise_bits by smt().
have hp : 0 <= (noise_bits * i + j) %/ 8 < eta_enc by smt().
rewrite nth_take 1,2:/# nth_drop 1,2:/# nth_mkseq 1:// /=.
rewrite Array_eta_enc.initiE 1:// /= Array_s2_enc.initiE /=.
+ by rewrite /s2_enc; smt().
rewrite /BytesToBits (nth_flatten false 8).
+ by rewrite allP => ii; rewrite mapP => He /=; elim He => x [# ? ->]; rewrite size_w2bits.
rewrite (nth_map witness); 1: by rewrite HL.
by rewrite get_w2bits HLn // addzA.
qed.


(* Correctness of the AVX2 ML-DSA signing function.
   We prove an equiv between:
     - MLDSA(...).sign_derand(sk, m, coins) on the spec side
     - M.__sign_internal(sig, sk, ctx_ptr, ctx_size, msg_ptr, msg_size, randomness)
       on the Jasmin side

   The _m parameter is a snapshot of Glob.mem so that memread expressions are stable.
   The precondition connects:
     - sk (BytesSK.t) to the Jasmin signing_key (Array_sk_enc)
     - coins via rnd_to_list (abstract rnd_ type) to the Jasmin randomness (Array32)
     - m (W8.t list) to the context-prefixed message read from memory
   The postcondition connects the output signatures byte-for-byte and confirms
   the Jasmin result code is 0 (success, kappa not exceeded). *)

lemma sign_internal_correct _m :
    kappa_max = (65535 - lvec) %/ lvec =>
    equiv [ MLDSA(MLDSA_XOFA, MLDSA_XOFS, MLDSA_XOF_SIB, SIB_RO).sign_derand
            ~ M.__sign_internal :
       Glob.mem{2} = _m
    /\ sk{1} = BytesSK.of_list (to_list signing_key{2})
    /\ rnd_to_list coins{1} = to_list randomness{2}
    /\ 0 <= context_size{2} <= 255
    /\ 0 <= message_size{2}
    /\ 0 <= context_pointer{2} /\ context_pointer{2} + context_size{2} < W64.modulus
    /\ message_pointer{2} + message_size{2} < W64.modulus
    /\ m{1} = [W8.zero; W8.of_int context_size{2}]
              ++ memread _m context_pointer{2} context_size{2}
              ++ memread _m message_pointer{2} message_size{2}
    /\ valid_s1_bytes (Array_s1_enc.init (fun i => signing_key{2}.[128 + i]))
    /\ valid_s2_bytes (Array_s2_enc.init (fun i => signing_key{2}.[128 + lvec * eta_enc + i]))
       ==>
       Glob.mem{2} = _m
    /\ (res{1}.`1 = None <=> res{2}.`2 = -W64.one)
    /\ (res{1}.`1 <> None =>
          BytesSig.to_list (oget res{1}.`1) = to_list res{2}.`1 /\
          res{2}.`2 = W64.zero)
    ].
proof.
move => Hkappa_max.
(* the layout of the signing key *)
have Hsk_bytes : sk_bytes = 128 + lvec * eta_enc + kvec * eta_enc + kvec * 416.
+ by rewrite -sk_encE.
have ? : 0 <= lvec * eta_enc by smt(gt0_l ge0_eta_enc).
have ? : 0 <= kvec * eta_enc by smt(gt0_k ge0_eta_enc).
have ? := gt0_k.
have Hkm0 : 0 < kappa_max by rewrite Hkappa_max; smt(param_sets).
proc*.
transitivity {1} { r <@ MLDSA(MLDSA_XOFA, MLDSA_XOFS, MLDSA_XOF_SIB, SIB_RO).sign_eager(sk,m, coins); }
    (={sk,m,coins, glob MLDSA_XOFA, glob MLDSA_XOFS, glob MLDSA_XOF_SIB, glob SIB_RO}
     /\ valid_sk_s2 sk{1} ==> ={r})
    (   Glob.mem{2} = _m
    /\ sk{1} = BytesSK.of_list (to_list signing_key{2})
    /\ rnd_to_list coins{1} = to_list randomness{2}
    /\ 0 <= context_size{2} <= 255
    /\ 0 <= message_size{2}
    /\ 0 <= context_pointer{2} /\ context_pointer{2} + context_size{2} < W64.modulus
    /\ message_pointer{2} + message_size{2} < W64.modulus
    /\ m{1} = [W8.zero; W8.of_int context_size{2}]
              ++ memread _m context_pointer{2} context_size{2}
              ++ memread _m message_pointer{2} message_size{2}
    /\ valid_s1_bytes (Array_s1_enc.init (fun i => signing_key{2}.[128 + i]))
    /\ valid_s2_bytes (Array_s2_enc.init (fun i => signing_key{2}.[128 + lvec * eta_enc + i]))
       ==>
       Glob.mem{2} = _m
    /\ (r{1}.`1 = None <=> r{2}.`2 = -W64.one)
    /\ (r{1}.`1 <> None =>
          BytesSig.to_list (oget r{1}.`1) = to_list r{2}.`1 /\
          r{2}.`2 = W64.zero)
    ).
+ auto => /> &1 &2 8? H.
  exists (XOFA_state.pos{1}) (XOFA_state.seed{1}) XOFSIB_state.pos{1} XOFSIB_state.seed{1}.
  exists XOFS_state.pos{1} XOFS_state.seed{1}.
  exists coins{1} (zero :: W8.of_int context_size{2} :: (memread _m context_pointer{2} context_size{2} ++ memread _m message_pointer{2} message_size{2})).
  exists (BytesSK.of_list (to_list signing_key{2})).
  simplify;split; last by smt().
  by apply s2_valid_commutes=> /#.
+ smt().
+ by call sign_eager_equiv; auto.
  
call(:  Glob.mem{2} = _m
    /\ sk{1} = BytesSK.of_list (to_list signing_key{2})
    /\ rnd_to_list coins{1} = to_list randomness{2}
    /\ 0 <= context_size{2} <= 255
    /\ 0 <= message_size{2}
    /\ 0 <= context_pointer{2} /\ context_pointer{2} + context_size{2} < W64.modulus
    /\ message_pointer{2} + message_size{2} < W64.modulus
    /\ m{1} = [W8.zero; W8.of_int context_size{2}]
              ++ memread _m context_pointer{2} context_size{2}
              ++ memread _m message_pointer{2} message_size{2}
    /\ valid_s1_bytes (Array_s1_enc.init (fun i => signing_key{2}.[128 + i]))
    /\ valid_s2_bytes (Array_s2_enc.init (fun i => signing_key{2}.[128 + lvec * eta_enc + i]))
       ==>
       Glob.mem{2} = _m
    /\ (res{1}.`1 = None <=> res{2}.`2 = -W64.one)
    /\ (res{1}.`1 <> None =>
          BytesSig.to_list (oget res{1}.`1) = to_list res{2}.`1 /\
          res{2}.`2 = W64.zero)
    ); last by auto.
proc => /=.
conseq (: _ ==>
        (zh{1} = None <=> result{2} = - one) /\
  (zh{1} <> None =>
   BytesSig.to_list sigma{1} = to_list signature{2} /\ result{2} = zero)); 1: by smt().
   
seq 4 19 : #pre; 1: by auto.

(* ── Step 1: SkDecode (spec only) ────────────────────────────────────────
   Spec: (rho,_K,tr,s1,s2,t0) <@ SkEncDec.skDecode(sk)
   Jasmin: nothing yet (Jasmin decodes each piece separately below) *)
seq 1 0 : (#pre /\
    rho{1} = Bytes32.of_list (take 32 (BytesSK.to_list sk{1})) /\
    _K{1} = Bytes32.of_list (take 32 (drop 32 (BytesSK.to_list sk{1}))) /\
    tr{1} = Bytes64.of_list (take 64 (drop 64 (BytesSK.to_list sk{1}))) /\
    s1{1} = LArray.init (fun i =>
        BitUnpack (take ((n * noise_bits) %/ 8)
                        (drop (128 + i * ((n * noise_bits) %/ 8)) (BytesSK.to_list sk{1})))
                  Eta Eta) /\
    s2{1} = KArray.init (fun i =>
        BitUnpack (take ((n * noise_bits) %/ 8)
                        (drop (128 + s1_bytes + i * ((n * noise_bits) %/ 8)) (BytesSK.to_list sk{1})))
                  Eta Eta) /\
    t0{1} = KArray.init (fun i =>
        BitUnpack (take ((n * d) %/ 8)
                        (drop (128 + s1_bytes + s2_bytes + i * ((n * d) %/ 8)) (BytesSK.to_list sk{1})))
                  (2^(d-1)-1) (2^(d-1))));
   1: by ecall{1} (skDecode_corr sk{1}); auto => |> *; smt().

(* ── Step 3: ExpandA (spec) ~ sample____matrix_A (Jasmin) ───────────────
   Jasmin: matrix_A <@ sample____matrix_A(seed_for_matrix_A) *)
sp;seq 1 1 : (#pre /\
    liftu_wpolymat (mat_unflatten256 matrix_A{2}) = _A{1} /\
    wpolymat_urng (mat_unflatten256 matrix_A{2}) q).
+ ecall{1} (ExpandA_correct rho{1}).
  ecall{2} (matrix_A_correct seed_for_matrix_A{2}).
  auto => |> &1 &2 H 8? rr -> Hr;congr; rewrite Bytes32.tP => k kb.
  by rewrite !Bytes32.get_of_list // get_to_list initiE 1:/# /= nth_take 1,2:/# /= BytesSK.get_of_list 1:/# get_to_list.

(* ── Step 4: mu = H_mu tr m (spec simple) ───────────────────────────────
   Spec: mu <- H_mu tr m
   Jasmin: nothing (message representative computed next) *)
sp 1 0.
seq 0 2 : #pre; 1: by auto => />; rewrite /SLH64.protect_ptr.

(* ── Step 5: derive_message_representative (Jasmin) ─────────────────────
   Spec: (mu already assigned above)
   Jasmin: message_representative <@ __derive_message_representative(...) *)
seq 0 1 : (#pre /\
    message_representative{2} =
      Array64.of_list witness (Bytes64.to_list mu{1})).
+ ecall{2} (derive_message_representative_ph
              (Array64.init (fun i => signing_key{2}.[64 + i]))
              (memread _m context_pointer{2} context_size{2})
              (memread _m message_pointer{2} message_size{2})).
  wp; skip => |> &1 &2 *; do split.
  + rewrite size_memread; smt(W64.to_uint_cmp). 
  + rewrite size_memread; smt(W64.to_uint_cmp). 
  + rewrite size_memread; smt(W64.to_uint_cmp). 
  + rewrite size_memread; smt(W64.to_uint_cmp). 
  move => 4?; congr;congr;congr.
  + rewrite Bytes64.tP => k kb.
    by rewrite !Bytes64.get_of_list // get_to_list initiE 1:/# /= nth_take 1,2:/# nth_drop 1,2:/# BytesSK.of_listK ?size_to_list /#.
  by rewrite size_memread 1:/# /truncateu8 W64.of_uintK (pmod_small _ W64.modulus) //; smt().

(* ── Step 6: rhopp = H_rhopp _K coins mu (spec simple) ─────────────────
   Spec: rhopp <- H_rhopp _K coins mu *)
sp 1 0.
seq 0 3 : #pre; 1: by auto => />; rewrite /SLH64.protect_ptr.

(* ── Step 7: derive_seed_for_mask (Jasmin) ──────────────────────────────
   Spec: (rhopp already assigned above)
   Jasmin: seed_for_mask <@ derive_seed_for_mask(k, randomness, message_representative) *)
seq 0 1 : (#pre /\
    seed_for_mask{2} = Array64.of_list witness (Bytes64.to_list rhopp{1})).
+ ecall{2} (derive_seed_for_mask_ph
              (Array32.init (fun i => signing_key{2}.[32 + i]))
              randomness{2}
              message_representative{2}
              seed_for_mask{2}).
  wp; skip => |> &1 &2 <- *; rewrite /H_rhopp.
  rewrite !Bytes64.of_listK ?Keccak1600_Spec.size_SHAKE256 //;1,2: by rewrite size_take // size_drop // BytesSK.size_to_list /#.
  rewrite Bytes32.of_listK; 1: by rewrite size_take // size_drop // BytesSK.size_to_list /#.
  rewrite BytesSK.of_listK; 1: by rewrite size_to_list /#.
  congr;congr;congr.
  + congr;apply (eq_from_nth witness); 1: by rewrite size_to_list // size_take // size_drop // size_to_list /#.
    move => i; rewrite size_to_list /= => ib; rewrite nth_take 1,2:/# initiE 1:/# /= nth_drop /#.
    by rewrite of_listK ?Keccak1600_Spec.size_SHAKE256 //.
seq 0 2 : #pre; 1: by auto => />; rewrite /SLH64.protect_ptr.

(* ── Step 9: Decode s1 (Jasmin) ─────────────────────────────────────────
   Jasmin: s1 <@ s1____decode(signing_key[128:128 + s1_enc])
   Spec: (s1 already decoded in Step 1, via skDecode) *)
seq 0 1 : (#pre /\
    lifts_wpolylvec (lvec_unflatten256 s1{2}) = s1{1} /\
    wpolylvec_srng (lvec_unflatten256 s1{2}) Eta Eta).
+ ecall{2} (s1_decode_ph (Array_s1_enc.init (fun i => signing_key{2}.[128 + i]))).
  auto => |> &1 &2 10? rr Hfun Hrng.
  + rewrite Hfun tP => k kb.
    rewrite initiE 1:/# /= mapiE 1:/# /=;do congr.
    apply (eq_from_nth witness).
    + by rewrite size_to_list /= size_take 1:/# size_drop 1:/# BytesSK.size_to_list /#.
    move => i; rewrite size_to_list => ib.
    rewrite get_to_list nth_take 1,2:/# nth_drop 1,2:/#  BytesSK.get_to_list  BytesSK.get_of_list 1:/# get_to_list  initiE 1:/# /= get_of_list 1:/# nth_sub 1:/# /= initiE /#.
    
(* ── Step 10: Decode s2 (Jasmin) ────────────────────────────────────────
   Jasmin: s2 <@ s2____decode(signing_key[128 + s1_enc:128 + s1_enc + s2_enc]) *)
seq 0 1 : (#pre /\
    lifts_wpolykvec (kvec_unflatten256 s2{2}) = s2{1} /\
    wpolykvec_srng (kvec_unflatten256 s2{2}) Eta Eta).
+ ecall{2} (s2_decode_ph (Array_s2_enc.init (fun i => signing_key{2}.[128 + lvec * eta_enc + i]))).
  auto => |> &1 &2 12? rr Hfun Hrng.
  + rewrite Hfun tP => k kb.
    rewrite initiE 1:/# /= mapiE 1:/# /=;do congr.
    rewrite s1_bytesE eta_encE BytesSK.of_listK; 1: by rewrite size_to_list sk_encE.
    have Hk : (k + 1) * eta_enc <= kvec * eta_enc.
    + by apply StdOrder.IntOrder.ler_wpmul2r; smt(ge0_eta_enc).
    have ? := ge0_eta_enc.
    apply (eq_from_nth witness).
    + by rewrite Array_eta_enc.size_to_list size_take // size_drop 1:/# size_to_list; smt().
    move => i; rewrite Array_eta_enc.size_to_list => ib.
    rewrite Array_eta_enc.get_to_list nth_take 1,2:/# nth_drop 1,2:/# get_to_list.
    rewrite /s2_unflatten KArray.initiE 1:// /= Array_eta_enc.get_of_list 1:// Array_s2_enc.nth_sub.
    + by rewrite /s2_enc; smt().
    by rewrite Array_s2_enc.initiE /=; [rewrite /s2_enc; smt() | congr; ring].

(* ── Step 11: Decode t0 (Jasmin) ────────────────────────────────────────
   Jasmin: t0 <@ t0__decode(signing_key[128 + s1_enc + s2_enc:sk_enc]) *)
seq 0 1 : (#pre /\
    lifts_wpolykvec (kvec_unflatten256 t0{2}) = t0{1} /\
    wpolykvec_srng (kvec_unflatten256 t0{2}) (dpow-1) dpow).
+ ecall{2} (t0_decode_ph (Array_t0_enc.init (fun i => signing_key{2}.[128 + lvec * eta_enc + kvec * eta_enc + i]))).
  auto => |> &1 &2 14? rr Hfun Hrng.
  + rewrite Hfun tP => k kb.
    rewrite initiE 1:/# /= mapiE 1:/# /=;do congr; last 2 by smt().
    rewrite s1_bytesE s2_bytesE (: n * d %/ 8 = 416) // BytesSK.of_listK.
    + by rewrite size_to_list sk_encE.
    have Hk : (k + 1) * 416 <= kvec * 416 by smt().
    apply (eq_from_nth witness).
    + by rewrite Array416.size_to_list size_take // size_drop 1:/# size_to_list; smt().
    move => i; rewrite Array416.size_to_list => ib.
    rewrite Array416.get_to_list nth_take 1,2:/# nth_drop 1,2:/# get_to_list.
    rewrite /t0_unflatten KArray.initiE 1:// /= Array416.get_of_list 1:// Array_t0_enc.nth_sub.
    + by rewrite /t0_enc; smt().
    by rewrite Array_t0_enc.initiE /=; [rewrite /t0_enc; smt() | congr; ring].
    
(* ── Step 12: NTT s1/s2/t0 + loop variable inits ───────────────────────
   Jasmin: row_vector__ntt(s1); column_vector__ntt(s2); column_vector__ntt(t0)
           domain_separator_for_mask <- 0
           exit_rejection_sampling_loop <- 0
           kappa_exceeded <- 0
   Spec: (kappa <- 0, zh <- None already done; s1h/s2h/t0h from Step 2 above) *)
seq 0 3 : (#{/~s1{2}}{/~s2{2}}{/~t0{2}}pre /\
    lifts_wpolylvec (lvec_unflatten256 s1{2}) = s1h{1} /\
    lifts_wpolykvec (kvec_unflatten256 s2{2}) = s2h{1} /\
    lifts_wpolykvec (kvec_unflatten256 t0{2}) = t0h{1} /\
    wpolylvec_ntt_orng (lvec_unflatten256 s1{2}) /\
    wpolykvec_ntt_orng (kvec_unflatten256 s2{2}) /\
    wpolykvec_ntt_orng (kvec_unflatten256 t0{2})).
+ wp; ecall{2} (column_vector__ntt_ph t0{2}).
  wp; ecall{2} (column_vector__ntt_ph s2{2}).
  wp; ecall{2} (row_vector__ntt_ph s1{2}).
  auto => |> &1 &2 *.
  split; first by apply wpolylvec_srng_ntt_irng;
    apply (wpolylvec_srng_widen _ Eta Eta (q-1) (q-1)); smt(param_sets).
  move => _ result Hs1_lift Hs1_orng.
  split; first by apply wpolykvec_srng_ntt_irng;
    apply (wpolykvec_srng_widen _ Eta Eta (q-1) (q-1)); smt(param_sets).
  move => _ result0 Hs2_lift Hs2_orng.
  split; first by apply wpolykvec_srng_ntt_irng;
    apply (wpolykvec_srng_widen _ (dpow-1) dpow (q-1) (q-1)); smt().
  move => _ result1 Ht0_lift Ht0_orng.
  by rewrite Hs1_lift Hs2_lift Ht0_lift /#.

(* ── Rejection sampling loop + post-loop ──────────────────────────────── *)

seq 3 5 : (
liftu_wpolymat (mat_unflatten256 matrix_A{2}) = _A{1} /\
    wpolymat_urng (mat_unflatten256 matrix_A{2}) q /\
    seed_for_mask{2} = Array64.of_list witness (Bytes64.to_list rhopp{1}) /\
    message_representative{2} = Array64.of_list witness (Bytes64.to_list mu{1}) /\
    lifts_wpolylvec (lvec_unflatten256 s1{2}) = s1h{1} /\
    lifts_wpolykvec (kvec_unflatten256 s2{2}) = s2h{1} /\
    lifts_wpolykvec (kvec_unflatten256 t0{2}) = t0h{1} /\
    wpolylvec_ntt_orng (lvec_unflatten256 s1{2}) /\
    wpolykvec_ntt_orng (kvec_unflatten256 s2{2}) /\
    wpolykvec_ntt_orng (kvec_unflatten256 t0{2}) /\
    W16.to_uint domain_separator_for_mask{2} = kappa{1} * lvec /\
    (kappa_exceeded{2} = one) = (kappa_max <= kappa{1}) /\
    (kappa_exceeded{2} <> one => kappa_exceeded{2} = zero) /\
    (exit_rejection_sampling_loop{2} = zero) = (zh{1} = None /\ ! (kappa_max <= kappa{1})) /\
    (zh{1} = None => (kappa_max <= kappa{1})) /\
    (zh{1} <> None => last_norm_check_result{2} = W64.zero) /\
    (zh{1} = None /\ kappa_max <= kappa{1} => last_norm_check_result{2} = W64.one) /\
    (zh{1} <> None =>
       (ct{1} = BytesCT.init (fun i => commitment_hash{2}.[i]) /\
       lifts_wpolylvec (lvec_unflatten256 signer_response{2}) =  (oget zh{1}).`1 /\
       liftu_wpolykvec (kvec_unflatten256 hint_0{2}) = (oget zh{1}).`2 /\
       wpolykvec_urng (kvec_unflatten256 hint_0{2}) 2 /\
       count_nonzero_coeffs_kvec (liftu_wpolykvec (kvec_unflatten256 hint_0{2})) <= w_hint /\
       wpolylvec_srng (lvec_unflatten256 signer_response{2}) (gamma1-1) gamma1))
); last first.
(* ── Post-loop goal ─────────────────────────────────────────────────── *)
+ if {1}; last first.
  (* failure: zh = None /\ kappa_max <= kappa, so last_norm_check_result = W64.one *)
  + wp; call {2} (: true ==> true).
    + exact signature____encode_ll.
    auto => |> &1 &2 *.
    have -> : last_norm_check_result{2} = W64.one by smt().
    rewrite wordP => i ib.
    by rewrite minus_one /= /(`<<`) /(`|>>`) /= ib /= sarE initiE 1:/# /= nth_one /#.
  (* success: zh <> None, so last_norm_check_result = W64.zero *)
  wp; ecall (signature_encode commitment_hash{2} signer_response{2} hint_0{2}).
  auto => |> &1 &2 13?; do split; 1..6:smt().
  + move => 6? rr1 rr2 ?.
    have -> : last_norm_check_result{2} = W64.zero by smt().
    split; 1: by rewrite wordP /= minus_one /= /(`<<`) /(`|>>`) /= sarE negb_forall; exists 0 => /=.
    rewrite wordP => i ib.
    by rewrite  /(`<<`) /(`|>>`) /= sarE initiE 1:/# /=. 
     

(* ── Rejection sampling loop  ──────────────────────────────── *)

while (
    0 <= kappa{1} /\
    liftu_wpolymat (mat_unflatten256 matrix_A{2}) = _A{1} /\
    wpolymat_urng (mat_unflatten256 matrix_A{2}) q /\
    seed_for_mask{2} = Array64.of_list witness (Bytes64.to_list rhopp{1}) /\
    message_representative{2} = Array64.of_list witness (Bytes64.to_list mu{1}) /\
    lifts_wpolylvec (lvec_unflatten256 s1{2}) = s1h{1} /\
    lifts_wpolykvec (kvec_unflatten256 s2{2}) = s2h{1} /\
    lifts_wpolykvec (kvec_unflatten256 t0{2}) = t0h{1} /\
    wpolylvec_ntt_orng (lvec_unflatten256 s1{2}) /\
    wpolykvec_ntt_orng (kvec_unflatten256 s2{2}) /\
    wpolykvec_ntt_orng (kvec_unflatten256 t0{2}) /\
    W16.to_uint domain_separator_for_mask{2} = kappa{1} * lvec /\
    (kappa_exceeded{2} = W64.of_int 1) = (kappa_max <= kappa{1}) /\
    (kappa_exceeded{2} <> W64.of_int 1 => kappa_exceeded{2} = W64.zero) /\
    (exit_rejection_sampling_loop{2} = W64.of_int 0) =
      (zh{1} = None /\ ! (kappa_max <= kappa{1})) /\
    (zh{1} <> None => last_norm_check_result{2} = W64.zero) /\
    (zh{1} = None /\ kappa_max <= kappa{1} => last_norm_check_result{2} = W64.one) /\
    (zh{1} <> None =>
       ct{1} = BytesCT.init (fun i => commitment_hash{2}.[i]) /\
       lifts_wpolylvec (lvec_unflatten256 signer_response{2}) = (oget zh{1}).`1 /\
       liftu_wpolykvec (kvec_unflatten256 hint_0{2}) = (oget zh{1}).`2 /\
       wpolykvec_urng (kvec_unflatten256 hint_0{2}) 2 /\
       count_nonzero_coeffs_kvec (liftu_wpolykvec (kvec_unflatten256 hint_0{2})) <= w_hint /\
       wpolylvec_srng (lvec_unflatten256 signer_response{2}) (gamma1-1) gamma1)); last
         by auto => |>  &1 &2 *; rewrite !W64.to_uint_eq /=; do split;smt().

 (* ── Loop body ──────────────────────────────────────────────────────── *)
 seq 1 1 : (#{/~to_uint domain_separator_for_mask{2} = kappa{1} * lvec}pre /\
     lifts_wpolylvec (lvec_unflatten256 mask{2}) = y{1} /\
     wpolylvec_srng (lvec_unflatten256 mask{2}) (gamma1 - 1) gamma1 /\
     W16.to_uint domain_separator_for_mask{2} = (kappa{1} + 1) * lvec).
 + exlim seed_for_mask{2}, domain_separator_for_mask{2} => _seed _dom.
   call (mask_correct _seed _dom).
   auto => |> &1 &2 *; do split.
   + apply Bytes64.tP => k kb.
     + rewrite of_listK; 1: by rewrite Bytes64.size_to_list /=.
       by rewrite Bytes64.to_listK. 
   + by smt().
   + (* the 16-bit separator does not wrap: kappa < kappa_max *)
     have Hl := gt0_l.
     have HK1 : (65535 - lvec) %/ lvec * lvec <= 65535 - lvec by apply lez_floor; smt().
     have Hkl : (kappa{1} + 1) * lvec <= kappa_max * lvec.
     + by apply StdOrder.IntOrder.ler_wpmul2r; smt().
     by smt().
   + by move => _ _ _ result_R _ Hdom; smt().

 sp 3 0.
 seq 0 8 : (#pre /\
     lifts_wpolykvec (kvec_unflatten256 w0{2}) = w0{1} /\
     lifts_wpolykvec (kvec_unflatten256 w1{2}) = w1{1} /\
     wpolykvec_srng (kvec_unflatten256 w0{2}) gamma2 gamma2 /\
     wpolykvec_urng (kvec_unflatten256 w1{2}) ((q-1) %/ (2*gamma2))).
   seq 0 2 : (#pre /\ mask_as_ntt{2} = mask{2}).
   + conseq (_: true ==> mask_as_ntt{2} = mask{2}); 1: smt().
     sp 0 1.
     while{2} (0 <= j{2} <= lpolys_bytes /\ j{2} %% 32 = 0 /\
               (forall i, 0 <= i < j{2} %/ 4 => mask_as_ntt{2}.[i] = mask{2}.[i]))
              (lpolys_bytes - j{2}).
     + move => _ z; auto => |> &hr Hj_lo Hj_hi Hj_mod Hcopied Hguard.
       do split; 1,2,3,5: smt().
       move => i Hi_lo Hi_hi; rewrite Array_lpolys.initiE 1:/# /=.
       rewrite get32_set256_direct_eq 1,2,3,4:/#.
       case (j{hr} %/ 4 <= i < j{hr} %/ 4 + 8) => Hi_region.
       + rewrite get256_direct_init32_bits32 1,2,3,4:/# /= /#.
       rewrite get32_init32 1:/# /=; apply Hcopied; smt().
     skip; move => &1 &2 Hj0; split; 1: smt().
     move => j_R mask_as_ntt_R; split; 1: smt().
     move => Hguard_neg [# Hj_lo Hj_hi Hj_mod Hcopied].
     apply Array_lpolys.tP => k Hk; apply Hcopied; smt().
   wp; ecall{2} (column_vector____decompose_ph w{2}).
   wp; ecall{2} (column_vector____conditionally_add_modulus_ph w{2}).
   wp; ecall{2} (column_vector__invert_ntt_montgomery_ph w{2}).
   wp; ecall{2} (column_vector__reduce32_ph w{2}).
   wp; ecall{2} (row_vector____multiply_with_matrix_A_ph matrix_A{2} mask_as_ntt{2}).
   wp; ecall{2} (row_vector__ntt_ph mask_as_ntt{2}).
   auto => |> &1 &2 *.
   have Hbound := invntt_obound_fits_for_caddq.
   split; first by apply wpolylvec_srng_ntt_irng;
     apply (wpolylvec_srng_widen _ (gamma1-1) gamma1 (q-1) (q-1)); smt(gamma1_cases).
   move => _ result Hntt_eq Hntt_orng.
   move => _ result0 Hmul_eq Hmul_srng.
   split; first by apply (wpolykvec_srng_widen _ (lvec * 8380416) (lvec * 8380416) 2143289343 2143289343); smt(param_sets).
   move => _ result1 Hred_eq Hred_srng.
   split; first by apply wpolykvec_bmul_orng_intt_irng;
     apply (wpolykvec_srng_widen _ 6283009 6283008 (q-1) (q-1)); smt().
   move => _ result2 Hinvntt_eq Hinvntt_srng.
   split;
     first by apply (wpolykvec_srng_widen _ invntt_obound invntt_obound (q-1) (q-1)); smt().
   move => _ result3 Hcond_eq Hcond_urng.
   move => result4 Hw0_eq Hw1_eq Hw0_srng Hw1_urng.
   (* After `auto => |> &1 &2 *`, _A{1} and y{1} have been substituted out;
      goal uses (liftu_wpolymat (mat_unflatten256 matrix_A{2})) and
      (lifts_wpolylvec (lvec_unflatten256 mask{2})) directly. Chain via the
      ecall post equalities, no need for intermediate HA_lift / Hmask_lift. *)
   have Hreachable : lifts_wpolykvec (kvec_unflatten256 result3) =
                     invnttv (ntt_mulmxv (liftu_wpolymat (mat_unflatten256 matrix_A{2}))
                                         (nttv (lifts_wpolylvec (lvec_unflatten256 mask{2})))).
   + by rewrite Hcond_eq Hinvntt_eq (liftm_wpolykvec_lifts _ _ Hred_eq) Hmul_eq Hntt_eq.
   have Heq_liftu_lifts := wpolykvec_urng_lifts_eq_liftu _ Hcond_urng.
   have Hw1_lifts : lifts_wpolykvec (kvec_unflatten256 result4.`2) =
                    liftu_wpolykvec (kvec_unflatten256 result4.`2).
   + apply wpolykvec_urng_lifts_eq_liftu;
     apply (wpolykvec_urng_widen _ ((q-1) %/ (2*gamma2)) q); smt(gamma2_cases).
   rewrite Hw0_eq Hw1_lifts Hw1_eq -Heq_liftu_lifts Hreachable; done.

 seq 3 3 : (#pre /\
     ct{1} = BytesCT.init (fun i => commitment_hash{2}.[i]) /\
     lifts_wpoly verifier_challenge{2} = c{1} /\
     wpoly_ntt_irng verifier_challenge{2}).
 + seq 0 1 : (#pre /\ BytesW1.of_list (to_list commitment_encoded{2}) = w1Encode w1{1}); last first.
   + inline {1} SIB_RO(MLDSA_XOF_SIB).get.
     sp 3 0.
     wp.
     call sample_challenge_correct.
     ecall{2} (derive_commitment_hash_ph message_representative{2} commitment_encoded{2}).
     auto => |> &1 &2 *.
     rewrite Array64.of_listK 1:Bytes64.size_to_list //.
     rewrite Bytes64.to_listK.
     rewrite Array_ctilde.of_listK; 1: by rewrite BytesCT.size_to_list.
     rewrite BytesCT.to_listK.
     split; first by smt().
     move => Hcteq result_L result_R Hrl Hsrng; split.
     + rewrite Hcteq; apply BytesCT.tP => i Hi; rewrite BytesCT.initiE 1:/# /=.
       smt(Array_ctilde.get_of_list BytesCT.size_to_list BytesCT.get_to_list).
     apply wpoly_srng_ntt_irng; apply (wpoly_srng_widen _ 1 1 (q-1) (q-1)); smt().
   (* Step 1: commitment_encode bridge, polynomial by polynomial against w1Encode *)
   ecall{2} (commitment_encode_ph w1{2}).
   auto => |> &1 &2 17? result1 Hunflat.
   rewrite /w1Encode.
   have Hw1eq : liftu_wpolykvec (kvec_unflatten256 w1{2}) =
                lifts_wpolykvec (kvec_unflatten256 w1{2}).
   + rewrite eq_sym; apply wpolykvec_urng_lifts_eq_liftu.
     apply (wpolykvec_urng_widen _ (8380416 %/ (2 * gamma2)) q); smt(gamma2_cases).
   apply BytesW1.tP => k kb.
   rewrite !BytesW1.get_of_list 1,2:/# get_to_list (w1_unflatteniE result1 k) 1:/# Hunflat.
   have Hk : 0 <= k < kvec * w1_enc by move: kb; rewrite -w1vec_encE /w1vec_enc.
   have [Hq Hr] := blk_idx kvec w1_enc k gt0_w1_enc Hk.
   have Hhb : 1 <= hb_range - 1 by rewrite /hb_range; smt(gamma2_cases).
   have Hsz : forall p, size (SimpleBitPack p (hb_range - 1)) = w1_enc.
   + by move=> p; rewrite size_SimpleBitPack // ilog_w1 w1_encE.
   rewrite KArray.mapiE // /= Array_w1_enc.get_of_list ?Hsz //.
   rewrite (BitChunking.nth_flatten witness w1_enc).
   + by rewrite allP => s /mapP [wi [_ ->]] /=; rewrite Hsz.
   rewrite (nth_map witness); 1: by rewrite size_mkseq; smt(gt0_k).
   by rewrite nth_mkseq //= Hw1eq /#.

sp 6 0.
seq 1 0 : #pre; 1: by auto.

 seq 0 1 : (#{~lifts_wpoly verifier_challenge{2} = c{1}}{~wpoly_ntt_irng verifier_challenge{2}}pre /\
     wpoly_ntt_orng verifier_challenge{2} /\
     lifts_wpoly verifier_challenge{2} = ch{1}).
 + ecall{2} (polynomial__ntt_ph verifier_challenge{2}).
   by auto => |> /#.

 (* Jasmin pure: infinity_norm_check_result <- 0 *)
 sp 0 1.

 (* ── Step 1: cs2 norm check ──────────────────────────────── *)
 seq 0 1 : (#{~infinity_norm_check_result{2} = W64.zero}pre /\
     (infinity_norm_check_result{2} = W64.zero \/ infinity_norm_check_result{2} = W64.one) /\
     (infinity_norm_check_result{2} = W64.zero =>
        wpolykvec_infnorm_lt (gamma2 - Beta) (kvec_unflatten256 w0_minus_cs2{2}) /\
        lifts_wpolykvec (kvec_unflatten256 w0_minus_cs2{2}) =
          lifts_wpolykvec (kvec_unflatten256 w0{2}) -
          PolyKVec.invnttv (PolyKVec.ntt_smul
            (lifts_wpoly verifier_challenge{2})
            (lifts_wpolykvec (kvec_unflatten256 s2{2})))) /\
     (infinity_norm_check_result{2} = W64.zero <=>
        PolyKVec.infnorm_lt
          (lifts_wpolykvec (kvec_unflatten256 w0{2}) -
           PolyKVec.invnttv (PolyKVec.ntt_smul
             (lifts_wpoly verifier_challenge{2})
             (lifts_wpolykvec (kvec_unflatten256 s2{2}))))
          (gamma2 - Beta))).
 + ecall{2} (__apply_cs2_and_check_norm_ph
              w0_minus_cs2{2} w0{2} s2{2} verifier_challenge{2}
              W64.zero).
   by auto => |>.

 (* ── Step 2: ct0 norm check ──────────────────────────────── *)
 seq 0 1 : (#{~(infinity_norm_check_result{2} = W64.zero <=>
               PolyKVec.infnorm_lt
                 (lifts_wpolykvec (kvec_unflatten256 w0{2}) -
                  PolyKVec.invnttv (PolyKVec.ntt_smul
                    (lifts_wpoly verifier_challenge{2})
                    (lifts_wpolykvec (kvec_unflatten256 s2{2}))))
                 (gamma2 - Beta))}pre /\
     (infinity_norm_check_result{2} = W64.zero \/ infinity_norm_check_result{2} = W64.one) /\
     (* Conditional range from ct0 add: tightest bound from norm checks. *)
     (infinity_norm_check_result{2} = W64.zero =>
        wpolykvec_srng (kvec_unflatten256 w0_minus_cs2_plus_ct0{2}) (2*gamma2 - Beta - 2) (2*gamma2 - Beta - 2)) /\
     (infinity_norm_check_result{2} = W64.zero =>
        let ct0 = PolyKVec.invnttv (PolyKVec.ntt_smul
                    (lifts_wpoly verifier_challenge{2})
                    (lifts_wpolykvec (kvec_unflatten256 t0{2}))) in
        PolyKVec.infnorm_lt ct0 gamma2 /\
        lifts_wpolykvec (kvec_unflatten256 w0_minus_cs2_plus_ct0{2}) =
          lifts_wpolykvec (kvec_unflatten256 w0_minus_cs2{2}) + ct0) /\
     (infinity_norm_check_result{2} = W64.zero <=>
        PolyKVec.infnorm_lt
          (lifts_wpolykvec (kvec_unflatten256 w0{2}) -
           PolyKVec.invnttv (PolyKVec.ntt_smul
             (lifts_wpoly verifier_challenge{2})
             (lifts_wpolykvec (kvec_unflatten256 s2{2}))))
          (gamma2 - Beta) /\
        PolyKVec.infnorm_lt
          (PolyKVec.invnttv (PolyKVec.ntt_smul
             (lifts_wpoly verifier_challenge{2})
             (lifts_wpolykvec (kvec_unflatten256 t0{2}))))
          gamma2)).
 + ecall{2} (__apply_ct0_and_check_norm_ph
              w0_minus_cs2_plus_ct0{2} w0_minus_cs2{2} t0{2}
              verifier_challenge{2} infinity_norm_check_result{2}).
   by auto => |> &1 &2 *; smt().

 (* ── Step 3: z norm check ──────────────────────────────── *)
 seq 0 2 : (#{~(infinity_norm_check_result{2} = W64.zero <=>
               PolyKVec.infnorm_lt
                 (lifts_wpolykvec (kvec_unflatten256 w0{2}) -
                  PolyKVec.invnttv (PolyKVec.ntt_smul
                    (lifts_wpoly verifier_challenge{2})
                    (lifts_wpolykvec (kvec_unflatten256 s2{2}))))
                 (gamma2 - Beta) /\
               PolyKVec.infnorm_lt
                 (PolyKVec.invnttv (PolyKVec.ntt_smul
                    (lifts_wpoly verifier_challenge{2})
                    (lifts_wpolykvec (kvec_unflatten256 t0{2}))))
                 gamma2)}pre /\
     (infinity_norm_check_result{2} = W64.zero \/ infinity_norm_check_result{2} = W64.one) /\
     (infinity_norm_check_result{2} = W64.zero =>
        wpolylvec_infnorm_lt (gamma1 - Beta) (lvec_unflatten256 signer_response{2}) /\
        lifts_wpolylvec (lvec_unflatten256 signer_response{2}) =
          lifts_wpolylvec (lvec_unflatten256 mask{2}) +
          PolyLVec.invnttv (PolyLVec.ntt_smul
            (lifts_wpoly verifier_challenge{2})
            (lifts_wpolylvec (lvec_unflatten256 s1{2}))) /\
        wpolylvec_srng (lvec_unflatten256 signer_response{2}) (gamma1 - 1) gamma1) /\
     (infinity_norm_check_result{2} = W64.zero <=>
        PolyKVec.infnorm_lt
          (lifts_wpolykvec (kvec_unflatten256 w0{2}) -
           PolyKVec.invnttv (PolyKVec.ntt_smul
             (lifts_wpoly verifier_challenge{2})
             (lifts_wpolykvec (kvec_unflatten256 s2{2}))))
          (gamma2 - Beta) /\
        PolyKVec.infnorm_lt
          (PolyKVec.invnttv (PolyKVec.ntt_smul
             (lifts_wpoly verifier_challenge{2})
             (lifts_wpolykvec (kvec_unflatten256 t0{2}))))
          gamma2 /\
        PolyLVec.infnorm_lt
          (lifts_wpolylvec (lvec_unflatten256 mask{2}) +
           PolyLVec.invnttv (PolyLVec.ntt_smul
             (lifts_wpoly verifier_challenge{2})
             (lifts_wpolylvec (lvec_unflatten256 s1{2}))))
          (gamma1 - Beta))).
 + wp. ecall{2} (__compute_z_and_check_norm_ph
              s1{2} verifier_challenge{2} mask{2} signer_response{2}
              infinity_norm_check_result{2}).
   by auto => |> &1 &2 *; smt().

 (* ── Step 4: make_hint ────────────────────────────────────── *)
 seq 0 2 : (#{~(infinity_norm_check_result{2} = zero <=>
   infnorm_lt
     (lifts_wpolykvec (kvec_unflatten256 w0{2}) -
      invnttv (ntt_smul (lifts_wpoly verifier_challenge{2}) (lifts_wpolykvec (kvec_unflatten256 s2{2}))))
     (gamma2 - Beta) /\
   infnorm_lt (invnttv (ntt_smul (lifts_wpoly verifier_challenge{2}) (lifts_wpolykvec (kvec_unflatten256 t0{2}))))
     gamma2 /\
   infnorm_lt
     (lifts_wpolylvec (lvec_unflatten256 mask{2}) +
      invnttv (ntt_smul (lifts_wpoly verifier_challenge{2}) (lifts_wpolylvec (lvec_unflatten256 s1{2}))))
     (gamma1 - Beta))}pre /\
     (infinity_norm_check_result{2} = W64.zero \/ infinity_norm_check_result{2} = W64.one) /\
     (infinity_norm_check_result{2} = W64.zero =>
          liftu_wpolykvec (kvec_unflatten256 hint_0{2}) =
            MakeHintImpl
              (lifts_wpolykvec (kvec_unflatten256 w1{2}))
              (lifts_wpolykvec (kvec_unflatten256 w0_minus_cs2_plus_ct0{2}))) /\
     (PolyKVec.infnorm_lt
        (lifts_wpolykvec (kvec_unflatten256 w0{2}) -
         PolyKVec.invnttv (PolyKVec.ntt_smul
           (lifts_wpoly verifier_challenge{2})
           (lifts_wpolykvec (kvec_unflatten256 s2{2}))))
        (gamma2 - Beta) /\
      PolyKVec.infnorm_lt
        (PolyKVec.invnttv (PolyKVec.ntt_smul
           (lifts_wpoly verifier_challenge{2})
           (lifts_wpolykvec (kvec_unflatten256 t0{2}))))
        gamma2 /\
      PolyLVec.infnorm_lt
        (lifts_wpolylvec (lvec_unflatten256 mask{2}) +
         PolyLVec.invnttv (PolyLVec.ntt_smul
           (lifts_wpoly verifier_challenge{2})
           (lifts_wpolylvec (lvec_unflatten256 s1{2}))))
        (gamma1 - Beta) =>
      lifts_wpolykvec (kvec_unflatten256 w0_minus_cs2_plus_ct0{2}) =
        (lifts_wpolykvec (kvec_unflatten256 w0{2}) -
         PolyKVec.invnttv (PolyKVec.ntt_smul
           (lifts_wpoly verifier_challenge{2})
           (lifts_wpolykvec (kvec_unflatten256 s2{2})))) +
        PolyKVec.invnttv (PolyKVec.ntt_smul
           (lifts_wpoly verifier_challenge{2})
           (lifts_wpolykvec (kvec_unflatten256 t0{2})))) /\
     (infinity_norm_check_result{2} = W64.zero =>
        wpolykvec_urng (kvec_unflatten256 hint_0{2}) 2) /\
        
     (infinity_norm_check_result{2} = W64.zero <=>
        (PolyKVec.infnorm_lt
          (lifts_wpolykvec (kvec_unflatten256 w0{2}) -
           PolyKVec.invnttv (PolyKVec.ntt_smul
             (lifts_wpoly verifier_challenge{2})
             (lifts_wpolykvec (kvec_unflatten256 s2{2}))))
          (gamma2 - Beta) /\
        PolyKVec.infnorm_lt
          (PolyKVec.invnttv (PolyKVec.ntt_smul
             (lifts_wpoly verifier_challenge{2})
             (lifts_wpolykvec (kvec_unflatten256 t0{2}))))
          gamma2 /\
        PolyLVec.infnorm_lt
          (lifts_wpolylvec (lvec_unflatten256 mask{2}) +
           PolyLVec.invnttv (PolyLVec.ntt_smul
             (lifts_wpoly verifier_challenge{2})
             (lifts_wpolylvec (lvec_unflatten256 s1{2}))))
          (gamma1 - Beta) /\
        PolyKVec.hammw
          (MakeHintImpl
              (lifts_wpolykvec (kvec_unflatten256 w1{2}))
              (lifts_wpolykvec (kvec_unflatten256 w0_minus_cs2_plus_ct0{2})))
          w_hint))).
 + wp. ecall{2} (__make_hint_vector_ph
                   w0_minus_cs2_plus_ct0{2} w1{2} hint_0{2}
                   infinity_norm_check_result{2}).
   auto => |> &1 &2 *;smt().  
 auto => |> &1 &2 23? Hh0 ??Hz.
 (* Instantiate the kappa-counter machine-arithmetic helper. *)
 have Hkbu :=
   kappa_bit_update kappa{1} kappa_exceeded{2} domain_separator_for_mask{2}
     _ Hkappa_max _ _ _; 1..4: smt().
 move : Hkbu => /= [Hkappa_R_one Hkappa_R_dicho].
 (* Goal: wpolykvec_srng w0_minus_cs2_plus_ct0 (gamma2-1) gamma2 /\ (srng => forall result1, ...) *)
 split.
 + move => Hn1 Hn2;split.
   + move => Hn3?.
     have := Hz.
     have -> /= : infnorm_lt
  (lifts_wpolykvec (kvec_unflatten256 w0{2}) -
   invnttv (ntt_smul (lifts_wpoly verifier_challenge{2}) (lifts_wpolykvec (kvec_unflatten256 s2{2})))) (
  gamma2 - Beta) by smt().
  have -> /= : infnorm_lt
  (lifts_wpolylvec (lvec_unflatten256 mask{2}) +
   invnttv (ntt_smul (lifts_wpoly verifier_challenge{2}) (lifts_wpolylvec (lvec_unflatten256 s1{2})))) (
  gamma1 - Beta) by smt().
  have -> : infnorm_lt (invnttv (ntt_smul (lifts_wpoly verifier_challenge{2}) (lifts_wpolykvec (kvec_unflatten256 t0{2})))) gamma2 by smt().
  have -> /=: PolyKVec.hammw
  (MakeHintImpl (lifts_wpolykvec (kvec_unflatten256 w1{2})) (lifts_wpolykvec (kvec_unflatten256 w0_minus_cs2_plus_ct0{2}))) w_hint by smt().

  move => H0.
     do split;1..3,5,6,7,8:smt().
     + rewrite  H0 /=;smt(or64_ne0).
     + by smt(hammw_count_nonzero).
     + by smt().
     + rewrite  H0 /=;smt(or64_ne0).
 + move => Hn3.
   have := Hz.
   have  -> /=: !(infnorm_lt
  (lifts_wpolykvec (kvec_unflatten256 w0{2}) -
   invnttv (ntt_smul (lifts_wpoly verifier_challenge{2}) (lifts_wpolykvec (kvec_unflatten256 s2{2})))) (
  gamma2 - Beta) /\
infnorm_lt (invnttv (ntt_smul (lifts_wpoly verifier_challenge{2}) (lifts_wpolykvec (kvec_unflatten256 t0{2})))) gamma2 /\
infnorm_lt
  (lifts_wpolylvec (lvec_unflatten256 mask{2}) +
   invnttv (ntt_smul (lifts_wpoly verifier_challenge{2}) (lifts_wpolylvec (lvec_unflatten256 s1{2})))) (
  gamma1 - Beta) /\
hammw
  (MakeHintImpl (lifts_wpolykvec (kvec_unflatten256 w1{2})) (lifts_wpolykvec (kvec_unflatten256 w0_minus_cs2_plus_ct0{2})))
  w_hint ) by smt().

  move => H0.
  have H1 : infinity_norm_check_result{2} = one by smt().
   + do split;1..3:smt(). 
     + rewrite  H1 /=;smt(or64_ne0).
     + smt().
     + rewrite  H1 /=;smt(or64_ne0).
     + rewrite  H1 /=;smt(or64_ne0).
       
 + move => Hn3.
   have := Hz.
   have  -> /=: !(infnorm_lt
  (lifts_wpolykvec (kvec_unflatten256 w0{2}) -
   invnttv (ntt_smul (lifts_wpoly verifier_challenge{2}) (lifts_wpolykvec (kvec_unflatten256 s2{2})))) (
  gamma2 - Beta) /\
infnorm_lt (invnttv (ntt_smul (lifts_wpoly verifier_challenge{2}) (lifts_wpolykvec (kvec_unflatten256 t0{2})))) gamma2 /\
infnorm_lt
  (lifts_wpolylvec (lvec_unflatten256 mask{2}) +
   invnttv (ntt_smul (lifts_wpoly verifier_challenge{2}) (lifts_wpolylvec (lvec_unflatten256 s1{2})))) (
  gamma1 - Beta) /\
hammw
  (MakeHintImpl (lifts_wpolykvec (kvec_unflatten256 w1{2})) (lifts_wpolykvec (kvec_unflatten256 w0_minus_cs2_plus_ct0{2})))
  w_hint ) by smt().
  move => H0.
  have H1 : infinity_norm_check_result{2} = one by smt().
   + do split;1..3:smt(). 
     + rewrite  H1 /=;smt(or64_ne0).
     + smt().
     + rewrite  H1 /=;smt(or64_ne0).
     + rewrite  H1 /=;smt(or64_ne0).
qed.

end SignT.
