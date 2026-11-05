(* -------------------------------------------------------------------- *)
(* The KEM of the model against the specification's ML-KEM, at abstract *)
(* parameters: key generation, encapsulation, decapsulation.            *)
(* -------------------------------------------------------------------- *)
require import AllCore IntDiv List StdOrder.
from Jasmin require import JModel_x86.
from JazzEC require import Array32 Array64 WArray32 WArray64.
from CryptoSpecs require import FIPS202_SHA3_Spec Keccak1600_Spec Keccakf1600_Spec.
from Spec require import GFq Rq Sampling Serialization Symmetric Correctness.
require import MLKEMFCLib.
require import PreludeT.
require BaseT Fq_avx2T MLKEM_ntt_levelsT MLKEM_ntt_avx2T MLKEM_invntt_levelsT.
require MLKEM_invntt_avx2T MLKEM_basemul_avx2T NTT_avx2_polyT MLKEM_Poly_avx2T.
require MLKEM_Poly_avx2_circuitT NTT_avx2T MLKEM_PolyVec_avx2T MLKEM_PolyVec_avx2_circuitT.
require MLKEM_keccak_avx2T Mlkem_filters_bridgeT MLKEM_sampler_avx2T MLKEM_genmatrix_avx2T.
require MLKEM_getnoise_avx2T MLKEM_compress_avx2T.
require Montgomery.
require MLKEM_InnerPKE_avx2T.

abstract theory MLKEM_KEM_avx2T.

clone import BaseT.BaseT as B.
import S R.
clone import PreludeT.PreludeT as PR with theory B <- B.
clone import Fq_avx2T.Fq_avx2T as Fq_avx2 with theory B <- B.
clone import MLKEM_ntt_levelsT.MLKEM_ntt_levelsT as MLKEM_ntt_levels with theory B <- B.
clone import MLKEM_ntt_avx2T.MLKEM_ntt_avx2T as MLKEM_ntt_avx2 with
  theory B <- B, theory MLKEM_ntt_levels <- MLKEM_ntt_levels.
clone import MLKEM_invntt_levelsT.MLKEM_invntt_levelsT as MLKEM_invntt_levels with
  theory B <- B, theory MLKEM_ntt_levels <- MLKEM_ntt_levels.
clone import MLKEM_invntt_avx2T.MLKEM_invntt_avx2T as MLKEM_invntt_avx2 with
  theory B <- B, theory MLKEM_ntt_levels <- MLKEM_ntt_levels,
  theory MLKEM_ntt_avx2 <- MLKEM_ntt_avx2, theory MLKEM_invntt_levels <- MLKEM_invntt_levels.
clone import MLKEM_basemul_avx2T.MLKEM_basemul_avx2T as MLKEM_basemul_avx2 with
  theory B <- B, theory MLKEM_ntt_levels <- MLKEM_ntt_levels,
  theory MLKEM_ntt_avx2 <- MLKEM_ntt_avx2.
clone import NTT_avx2_polyT.NTT_avx2_polyT as NTT_avx2_poly with
  theory B <- B, theory MLKEM_ntt_levels <- MLKEM_ntt_levels,
  theory MLKEM_ntt_avx2 <- MLKEM_ntt_avx2, theory MLKEM_invntt_levels <- MLKEM_invntt_levels,
  theory MLKEM_invntt_avx2 <- MLKEM_invntt_avx2, theory MLKEM_basemul_avx2 <- MLKEM_basemul_avx2.
clone import MLKEM_Poly_avx2T.MLKEM_Poly_avx2T as MLKEM_Poly_avx2 with
  theory B <- B, theory Fq_avx2 <- Fq_avx2, theory MLKEM_ntt_levels <- MLKEM_ntt_levels,
  theory MLKEM_ntt_avx2 <- MLKEM_ntt_avx2, theory MLKEM_invntt_levels <- MLKEM_invntt_levels,
  theory MLKEM_invntt_avx2 <- MLKEM_invntt_avx2, theory MLKEM_basemul_avx2 <- MLKEM_basemul_avx2,
  theory NTT_avx2_poly <- NTT_avx2_poly.
clone import MLKEM_Poly_avx2_circuitT.MLKEM_Poly_avx2_circuitT as MLKEM_Poly_avx2_circuit with
  theory B <- B, theory Fq_avx2 <- Fq_avx2, theory MLKEM_ntt_levels <- MLKEM_ntt_levels,
  theory MLKEM_ntt_avx2 <- MLKEM_ntt_avx2, theory MLKEM_invntt_levels <- MLKEM_invntt_levels,
  theory MLKEM_invntt_avx2 <- MLKEM_invntt_avx2, theory MLKEM_basemul_avx2 <- MLKEM_basemul_avx2,
  theory NTT_avx2_poly <- NTT_avx2_poly, theory MLKEM_Poly_avx2 <- MLKEM_Poly_avx2.
clone import NTT_avx2T.NTT_avx2T as NTT_avx2 with
  theory B <- B, theory PR <- PR, theory MLKEM_ntt_levels <- MLKEM_ntt_levels,
  theory MLKEM_ntt_avx2 <- MLKEM_ntt_avx2, theory MLKEM_invntt_levels <- MLKEM_invntt_levels,
  theory MLKEM_invntt_avx2 <- MLKEM_invntt_avx2, theory MLKEM_basemul_avx2 <- MLKEM_basemul_avx2,
  theory NTT_avx2_poly <- NTT_avx2_poly.
clone import MLKEM_PolyVec_avx2T.MLKEM_PolyVec_avx2T as MLKEM_PolyVec_avx2 with
  theory B <- B, theory PR <- PR, theory Fq_avx2 <- Fq_avx2, theory MLKEM_ntt_levels <-
    MLKEM_ntt_levels,
  theory MLKEM_ntt_avx2 <- MLKEM_ntt_avx2, theory MLKEM_invntt_levels <- MLKEM_invntt_levels,
  theory MLKEM_invntt_avx2 <- MLKEM_invntt_avx2, theory MLKEM_basemul_avx2 <- MLKEM_basemul_avx2,
  theory NTT_avx2_poly <- NTT_avx2_poly,
  theory MLKEM_Poly_avx2 <- MLKEM_Poly_avx2.
clone import MLKEM_PolyVec_avx2_circuitT.MLKEM_PolyVec_avx2_circuitT as MLKEM_PolyVec_avx2_circuit
  with
  theory B <- B, theory PR <- PR, theory Fq_avx2 <- Fq_avx2, theory MLKEM_ntt_levels <-
    MLKEM_ntt_levels,
  theory MLKEM_ntt_avx2 <- MLKEM_ntt_avx2, theory MLKEM_invntt_levels <- MLKEM_invntt_levels,
  theory MLKEM_invntt_avx2 <- MLKEM_invntt_avx2, theory MLKEM_basemul_avx2 <- MLKEM_basemul_avx2,
  theory NTT_avx2_poly <- NTT_avx2_poly,
  theory MLKEM_Poly_avx2 <- MLKEM_Poly_avx2, theory MLKEM_Poly_avx2_circuit <-
    MLKEM_Poly_avx2_circuit,
  theory NTT_avx2 <- NTT_avx2.
clone import MLKEM_keccak_avx2T.MLKEM_keccak_avx2T as MLKEM_keccak_avx2 with theory B <- B.
clone import Mlkem_filters_bridgeT.Mlkem_filters_bridgeT as Mlkem_filters_bridge with
  theory B <- B.
clone import MLKEM_sampler_avx2T.MLKEM_sampler_avx2T as MLKEM_sampler_avx2 with
  theory B <- B, theory MLKEM_keccak_avx2 <- MLKEM_keccak_avx2,
  theory Mlkem_filters_bridge <- Mlkem_filters_bridge.
clone import MLKEM_genmatrix_avx2T.MLKEM_genmatrix_avx2T as MLKEM_genmatrix_avx2 with
  theory B <- B, theory PR <- PR, theory Fq_avx2 <- Fq_avx2, theory MLKEM_ntt_levels <-
    MLKEM_ntt_levels,
  theory MLKEM_ntt_avx2 <- MLKEM_ntt_avx2, theory MLKEM_invntt_levels <- MLKEM_invntt_levels,
  theory MLKEM_invntt_avx2 <- MLKEM_invntt_avx2, theory MLKEM_basemul_avx2 <- MLKEM_basemul_avx2,
  theory NTT_avx2_poly <- NTT_avx2_poly,
  theory MLKEM_Poly_avx2 <- MLKEM_Poly_avx2, theory NTT_avx2 <- NTT_avx2,
  theory MLKEM_keccak_avx2 <- MLKEM_keccak_avx2,
  theory Mlkem_filters_bridge <- Mlkem_filters_bridge,
  theory MLKEM_sampler_avx2 <- MLKEM_sampler_avx2.
clone import MLKEM_getnoise_avx2T.MLKEM_getnoise_avx2T as MLKEM_getnoise_avx2 with
  theory B <- B, theory MLKEM_keccak_avx2 <- MLKEM_keccak_avx2.
clone import MLKEM_compress_avx2T.MLKEM_compress_avx2T as MLKEM_compress_avx2 with
  theory B <- B, theory PR <- PR.
clone import MLKEM_InnerPKE_avx2T.MLKEM_InnerPKE_avx2T as MLKEM_InnerPKE_avx2 with
  theory B <- B,
  theory PR <- PR,
  theory Fq_avx2 <- Fq_avx2,
  theory MLKEM_ntt_levels <- MLKEM_ntt_levels,
  theory MLKEM_ntt_avx2 <- MLKEM_ntt_avx2,
  theory MLKEM_invntt_levels <- MLKEM_invntt_levels,
  theory MLKEM_invntt_avx2 <- MLKEM_invntt_avx2,
  theory MLKEM_basemul_avx2 <- MLKEM_basemul_avx2,
  theory NTT_avx2_poly <- NTT_avx2_poly,
  theory MLKEM_Poly_avx2 <- MLKEM_Poly_avx2,
  theory MLKEM_Poly_avx2_circuit <- MLKEM_Poly_avx2_circuit,
  theory NTT_avx2 <- NTT_avx2,
  theory MLKEM_PolyVec_avx2 <- MLKEM_PolyVec_avx2,
  theory MLKEM_PolyVec_avx2_circuit <- MLKEM_PolyVec_avx2_circuit,
  theory MLKEM_keccak_avx2 <- MLKEM_keccak_avx2,
  theory Mlkem_filters_bridge <- Mlkem_filters_bridge,
  theory MLKEM_sampler_avx2 <- MLKEM_sampler_avx2,
  theory MLKEM_genmatrix_avx2 <- MLKEM_genmatrix_avx2,
  theory MLKEM_getnoise_avx2 <- MLKEM_getnoise_avx2,
  theory MLKEM_compress_avx2 <- MLKEM_compress_avx2.
import PR MLKEM_keccak_avx2.

import Serialization Symmetric IntOrder.
import Array_pk_bytes Array_sk_bytes Array_ct_bytes Array_zct_bytes Array_polyvec_bytes.

(* -------------------------------------------------------------------- *)
(* the comparison of two ciphertexts, 32 bytes at a time                *)
lemma ct_bytesE : kvec * (256 * du %/ 8) + 256 * dv %/ 8 = ct_bytes.
proof.
rewrite /ct_bytes /polyvecc_bytes /polyc_bytes (: 256 * du = 32 * du * 8) 1:#ring.
by rewrite (: 256 * dv = 32 * dv * 8) 1:#ring !mulzK.
qed.

lemma ct_bytes32 : ct_bytes = 32 * (ct_bytes %/ 32).
proof. by rewrite /ct_bytes /polyvecc_bytes /polyc_bytes; smt(). qed.

lemma orw_eq0 (x y : W256.t) : x `|` y = W256.zero <=> x = W256.zero /\ y = W256.zero.
proof.
split; last by case=> -> ->; rewrite or0w.
by rewrite !wordP => h; split => i ib; have := h i ib; rewrite orwE zerowE /#.
qed.

(* two 256-bit words of bytes xor to zero iff their bytes agree *)
lemma xor0_pack32 (f g : int -> W8.t) :
  pack32_t (W32u8.Pack.init f) `^` pack32_t (W32u8.Pack.init g) = W256.zero <=>
  forall j, 0 <= j < 32 => g j = f j.
proof.
rewrite W256.WRing.addr_eq0 /oppw /=; split => [h j jb | h].
+ have := congr1 W32u8.unpack8 _ _ h; rewrite !pack32K.
  by move/(congr1 (fun (p : W32u8.Pack.pack_t) => p.[j])); rewrite /= !W32u8.Pack.initiE // => ->.
by congr; apply W32u8.Pack.ext_eq => j jb; rewrite !W32u8.Pack.initiE // h.
qed.

lemma get256_ct_xor0 (a b : W8.t Array_ct_bytes.t) i : 0 <= 32 * i => 32 * i + 32 <= ct_bytes =>
  WArray_ct_bytes.get256 (WArray_ct_bytes.init8 ("_.[_]" a)) i `^`
  WArray_ct_bytes.get256 (WArray_ct_bytes.init8 ("_.[_]" b)) i = W256.zero <=>
  forall k, i * 32 <= k < i * 32 + 32 => b.[k] = a.[k].
proof.
move=> h0 h1; rewrite /WArray_ct_bytes.get256_direct xor0_pack32; split => h k kb.
+ by have := h (k - 32 * i) _; rewrite /= ?WArray_ct_bytes.initiE /#.
by rewrite /= !WArray_ct_bytes.initiE 1,2:/# /= h /#.
qed.

lemma verify_correct_h _ct _ct1 :
  hoare [M.__verify :
    ct = _ct /\ ctpc = _ct1 ==>
    (_ct = _ct1 => res = W64.of_int 0) /\ (_ct <> _ct1 => res = W64.of_int 1)].
proof.
have hz : forall (w : W256.t), to_uint w = 0 <=> w = W256.zero.
+ by move=> w; rewrite W256.to_uint_eq.
proc => /=; sp.
wp; while (0 <= i <= ct_bytes %/ 32 /\ inc = ct_bytes %/ 32 /\ ct = _ct /\ ctpc = _ct1 /\
  (to_uint h = 0 <=> forall k, 0 <= k < i * 32 => ct.[k] = ctpc.[k])); last first.
+ auto => />; rewrite ct_bytesE /=; split; 1: smt(ct_bytes32 ge0_ct_bytes).
  move=> h i ilt i0 ii [hl hr]; have {ilt i0 ii} hi : i * 32 = ct_bytes by smt(ct_bytes32).
  move: hl hr; rewrite hi => hl hr; rewrite /VPTEST_256 /ZF_of /=; split.
  + move=> heq; have : to_uint h = 0 by apply hr; rewrite heq.
    by move=> h0; rewrite ifF //=; apply W256.to_uint_eq; rewrite h0.
  move=> neq; rewrite ifT //; move: neq; apply contra => /= heq.
  apply Array_ct_bytes.tP => k kb; apply hl => //.
  by rewrite heq.
auto => /> &hr i0 _ hh ilt; split; 1: smt().
have [hb0 hb1] : 0 <= 32 * i{hr} /\ 32 * i{hr} + 32 <= ct_bytes by smt(ct_bytes32).
rewrite hz orw_eq0 get256_ct_xor0 // -hz hh; smt().
qed.

lemma verify_ll : islossless M.__verify.
proof.
proc; wp; while (0 <= i <= inc) (inc - i); auto => />; smt(ct_bytes32 ge0_ct_bytes ct_bytesE).
qed.

lemma verify_correct _ct _ct1 :
  phoare [M.__verify :
    ct = _ct /\ ctpc = _ct1 ==>
    (_ct = _ct1 => res = W64.of_int 0) /\ (_ct <> _ct1 => res = W64.of_int 1)] = 1%r
by conseq verify_ll (verify_correct_h _ct _ct1).

(* -------------------------------------------------------------------- *)
(* the constant-time selection of the shared secret                     *)
lemma cmov_correct_h _dst _src _cnd :
  hoare [M.__cmov :
    src = _src /\ cnd = _cnd /\ dst = _dst ==>
    (_cnd = W64.of_int 0 => res = _src) /\ (_cnd = W64.of_int 1 => res = _dst)].
proof.
proc => /=.
seq 1 : (#{/~cnd}pre /\ (_cnd = W64.zero => cnd = W64.zero) /\
         (_cnd = W64.one => cnd = W64.onew));
  1: by auto => /> /=; split; [by ring | by rewrite W64.minus_one /=].
have msb1 : forall i, 0 <= i < 8 => msb (W64.onew \bits8 i) = true.
+ move=> i ib; rewrite /msb /=.
  have -> : W64.onew \bits8 i = W8.onew.
  + by rewrite wordP => k kb; rewrite onewE /= kb /= bits8iE //= /#.
  by rewrite to_uint_onew /=.
have msb0 : forall i, 0 <= i < 8 => msb (W64.zero \bits8 i) = false.
+ move=> i ib; rewrite /msb /=.
  have -> : W64.zero \bits8 i = W8.zero.
  + by rewrite wordP => k kb; rewrite zerowE /= bits8iE //= /#.
  by rewrite to_uint0 /=.
auto => /> &hr H H0; split.
+ move=> czero; move: (H czero) => -> /=; rewrite tP => k kb.
  rewrite !initiE //= kb /=.
  have HH : forall ii, 0 <= ii < 32 =>
    BLENDV_32u8 (WArray32.get256_direct (WArray32.init8 ("_.[_]" _src)) 0)
      (get256_direct (WArray32.init8 ("_.[_]" _dst)) 0) (VPBROADCAST_4u64 W64.zero)
      \bits8 ii = _src.[ii]; last by rewrite HH.
  move=> ii iib; rewrite /get256_direct /init8 /= wordP => i ib.
  rewrite /BLENDV_32u8 /VPBROADCAST_4u64 /(\bits8) -iotaredE /= /BLENDV_16u8 /= !msb0 //=.
  by rewrite initiE //= pack32E initiE /= 1:/# /of_list initiE /= /#.
move=> cone; move: (H0 cone) => -> /=; rewrite tP => k kb.
rewrite initiE //= kb /=.
have HH : forall ii, 0 <= ii < 32 =>
  BLENDV_32u8 (WArray32.get256_direct (WArray32.init8 ("_.[_]" _src)) 0)
    (get256_direct (WArray32.init8 ("_.[_]" _dst)) 0) (VPBROADCAST_4u64 W64.onew)
    \bits8 ii = _dst.[ii]; last by rewrite HH.
move=> ii iib; rewrite /get256_direct /init8 /= wordP => i ib.
rewrite /BLENDV_32u8 /VPBROADCAST_4u64 /(\bits8) -iotaredE /= /BLENDV_16u8 /= !msb1 //=.
by rewrite initiE //= pack32E initiE /= 1:/# /of_list !initiE /= /#.
qed.

lemma cmov_ll : islossless M.__cmov by islossless.

lemma cmov_correct _dst _src _cnd :
  phoare [M.__cmov :
    src = _src /\ cnd = _cnd /\ dst = _dst ==>
    (_cnd = W64.of_int 0 => res = _src) /\ (_cnd = W64.of_int 1 => res = _dst)] = 1%r
by conseq cmov_ll (cmov_correct_h _dst _src _cnd).

(* -------------------------------------------------------------------- *)
(* key generation: the secret key is (skcpa, pk, H(pk), z)              *)
lemma mlkem_kem_correct_kg :
  equiv [M.__crypto_kem_keypair_jazz ~ MLKEM.keygen_internal :
    coins{2}.`1 = Array32.init (fun i => randomnessp{1}.[0 + i]) /\
    coins{2}.`2 = Array32.init (fun i => randomnessp{1}.[32 + i])
    ==>
    let (pk,sk) = res{2} in let (t,rho) = pk in
      sk.`1 = BytesPKVec.init (fun i => res{1}.`2.[i]) /\
      sk.`2.`1 = BytesPKVec.init (fun i => res{1}.`2.[i + polyvec_bytes]) /\
      sk.`2.`2 = Array32.init (fun i => res{1}.`2.[i + 2 * polyvec_bytes]) /\
      sk.`3 = Array32.init (fun i => res{1}.`2.[i + 2 * polyvec_bytes + 32]) /\
      sk.`4 = Array32.init (fun i => res{1}.`2.[i + 2 * polyvec_bytes + 64]) /\
      t = BytesPKVec.init (fun i => res{1}.`1.[i]) /\
      rho = Array32.init (fun i => res{1}.`1.[i + polyvec_bytes])].
proof.
have hpb : kvec * 384 = polyvec_bytes by rewrite /polyvec_bytes mulzC.
have hpkb : pk_bytes = polyvec_bytes + 32 by done.
have hskb : sk_bytes = 2 * polyvec_bytes + 96 by done.
proc => /=.
seq 9 2 : (#pre /\ s_randomnessp{1} = randomnessp{1} /\ kgs{2} = randomnessp1{1} /\
           z{2} = coins{2}.`2); 1: by auto.
seq 1 1 : (coins{2}.`2 = Array32.init (fun i => randomnessp{1}.[32 + i]) /\
  s_randomnessp{1} = randomnessp{1} /\ z{2} = coins{2}.`2 /\
  sk{2} = BytesPKVec.init (fun i => skcpa{1}.[i]) /\
  pk{2}.`1 = BytesPKVec.init (fun i => pk{1}.[i]) /\
  pk{2}.`2 = Array32.init (fun i => pk{1}.[polyvec_bytes + i])).
+ call mlkem_correct_kg_avx2; auto => /> &1 &2 h1 h2 rl rr /=.
  by case: rr => -[t rho] s /=.

(* the public key, after the secret key of the inner PKE *)
seq 6 0 : (#pre /\
  (forall k, 0 <= k < polyvec_bytes => sk{1}.[k] = skcpa{1}.[k]) /\
  (forall k, 0 <= k < pk_bytes => sk{1}.[polyvec_bytes + k] = pk{1}.[k])).
+ have hi8 : (kvec * 384 + 32) %/ 8 * 8 = pk_bytes.
  + by rewrite (: kvec * 384 + 32 = (kvec * 48 + 4) * 8) 1:#ring mulzK // hpkb /polyvec_bytes; ring.
  sp 5 0; while {1} (coins{2}.`2 = Array32.init (fun i => randomnessp{1}.[32 + i]) /\
    s_randomnessp{1} = randomnessp{1} /\ z{2} = coins{2}.`2 /\
    sk{2} = BytesPKVec.init (fun i => skcpa{1}.[i]) /\
    pk{2}.`1 = BytesPKVec.init (fun i => pk{1}.[i]) /\
    pk{2}.`2 = Array32.init (fun i => pk{1}.[polyvec_bytes + i]) /\
    inc{1} = (kvec * 384 + 32) %/ 8 /\ 0 <= i{1} <= inc{1} /\
    (forall k, 0 <= k < polyvec_bytes => sk{1}.[k] = skcpa{1}.[k]) /\
    (forall k, 0 <= k < 8 * i{1} => sk{1}.[polyvec_bytes + k] = pk{1}.[k])) (inc{1} - i{1}).
  + move=> &m z0; auto => /> &hr _ _ _ i0 ii hlo hhi ilt.
    rewrite (addzC (kvec * 384 %/ 8)) pk_seed_offset; do split; 1,2,5: smt().
    + move=> k k0 kn; rewrite Array_sk_bytes.initiE 1:/# /=.
      rewrite WArray_sk_bytes.get8_set64_directE 1,2:/# ifF 1:/#.
      by rewrite /WArray_sk_bytes.get8 /WArray_sk_bytes.init8 WArray_sk_bytes.initiE 1:/# /= hlo.
    move=> k k0 kn; rewrite Array_sk_bytes.initiE 1:/# /=.
    rewrite WArray_sk_bytes.get8_set64_directE 1,2:/#.
    case: (polyvec_bytes + 8 * i{hr} <= polyvec_bytes + k < polyvec_bytes + 8 * i{hr} + 8)
      => hk.
    + rewrite /WArray_pk_bytes.get64_direct pack8bE 1:/# initiE 1:/# /=.
      by rewrite /WArray_pk_bytes.init8 WArray_pk_bytes.initiE 1:/# /=; congr; ring.
    rewrite /WArray_sk_bytes.get8 /WArray_sk_bytes.init8.
    by rewrite WArray_sk_bytes.initiE 1:/# /= hhi /#.
  auto => /> &1 &2 h2 hp1 hp2; split.
  + split; 1: smt(ge0_polyvec_bytes).
    split; 2: smt().
    by move=> k k0 kn; rewrite Array_sk_bytes.initiE 1:/# /= ifT.
  by move=> i sk0; split; [smt() | move=> ilt i0 _ hlo hhi k k0 kn; apply hhi => /#].

(* the hash of the public key *)
seq 5 1 : (#pre /\
  forall k, 0 <= k < 32 => sk{1}.[2 * polyvec_bytes + 32 + k] = hpk{2}.[k]).
+ wp; ecall {1} (sha3_256A_MPK_ph pk{1}); auto => /> &1 &2 h2 hp1 hp2 hlo hhi.
  have -> : H_pk pk{2} = H_pk (pk{2}.`1, pk{2}.`2) by case: (pk{2}).
  rewrite hp1 hp2 hpb; do split.
  + by move=> k k0 kn; rewrite Array_sk_bytes.initiE 1:/# /= ifF 1:/# hlo.
  + by move=> k k0 kn; rewrite Array_sk_bytes.initiE 1:/# /= ifF 1:/# hhi.
  move=> k k0 kn; rewrite Array_sk_bytes.initiE 1:#smt:(ge0_polyvec_bytes) /= ifT 1:/#.
  by congr; ring.

(* the implicit-rejection seed z *)
have hz8 : forall i, ((kvec * 384 + (kvec * 384 + 32) + 32) %/ 8 + i) * 8 =
  2 * polyvec_bytes + 64 + 8 * i.
+ move=> i; rewrite (: kvec * 384 + (kvec * 384 + 32) + 32 = (kvec * 96 + 8) * 8) 1:#ring.
  by rewrite mulzK // -hpb; ring.
sp 2 0; while {1} (coins{2}.`2 = Array32.init (fun i => randomnessp{1}.[32 + i]) /\
    z{2} = coins{2}.`2 /\
    sk{2} = BytesPKVec.init (fun i => skcpa{1}.[i]) /\
    pk{2}.`1 = BytesPKVec.init (fun i => pk{1}.[i]) /\
    pk{2}.`2 = Array32.init (fun i => pk{1}.[polyvec_bytes + i]) /\
    (forall k, 0 <= k < polyvec_bytes => sk{1}.[k] = skcpa{1}.[k]) /\
    (forall k, 0 <= k < pk_bytes => sk{1}.[polyvec_bytes + k] = pk{1}.[k]) /\
    (forall k, 0 <= k < 32 => sk{1}.[2 * polyvec_bytes + 32 + k] = hpk{2}.[k]) /\
    inc{1} = 4 /\ 0 <= i{1} <= 4 /\
    (forall k, 0 <= k < 8 * i{1} =>
       sk{1}.[2 * polyvec_bytes + 64 + k] = randomnessp{1}.[32 + k]))
  (4 - i{1}).
+ move=> &m z0; auto => /> &hr _ _ _ hlo hhi hh i0 i4 hr ilt; rewrite hz8.
  do split; 4,5,7: smt().
  + move=> k k0 kn; rewrite Array_sk_bytes.initiE 1:/# /=.
    rewrite WArray_sk_bytes.get8_set64_directE 1,2:/# ifF 1:/#.
    by rewrite /WArray_sk_bytes.get8 /WArray_sk_bytes.init8 WArray_sk_bytes.initiE 1:/# /= hlo.
  + move=> k k0 kn; rewrite Array_sk_bytes.initiE 1:/# /=.
    rewrite WArray_sk_bytes.get8_set64_directE 1,2:/# ifF 1:/#.
    by rewrite /WArray_sk_bytes.get8 /WArray_sk_bytes.init8 WArray_sk_bytes.initiE 1:/# /= hhi.
  + move=> k k0 kn; rewrite Array_sk_bytes.initiE 1:#smt:(ge0_polyvec_bytes) /=.
    rewrite WArray_sk_bytes.get8_set64_directE 1,2:#smt:(ge0_polyvec_bytes) ifF 1:/#.
    rewrite /WArray_sk_bytes.get8 /WArray_sk_bytes.init8.
    by rewrite WArray_sk_bytes.initiE 1:#smt:(ge0_polyvec_bytes) /= hh.
  move=> k k0 kn; rewrite Array_sk_bytes.initiE 1:#smt:(ge0_polyvec_bytes) /=.
  rewrite WArray_sk_bytes.get8_set64_directE 1,2:#smt:(ge0_polyvec_bytes).
  case: (2 * polyvec_bytes + 64 + 8 * i{hr} <= 2 * polyvec_bytes + 64 + k <
         2 * polyvec_bytes + 64 + 8 * i{hr} + 8) => hk.
  + rewrite /get64_direct pack8bE 1:/# initiE 1:/# /=.
    by rewrite /init8 WArray64.initiE 1:/# /=; congr; ring.
  rewrite /WArray_sk_bytes.get8 /WArray_sk_bytes.init8.
  by rewrite WArray_sk_bytes.initiE 1:#smt:(ge0_polyvec_bytes) /= hr /#.
auto => /> &1 &2 h2 hp1 hp2 hlo hhi hh; split; 1: smt().
move=> i sk0; split; 1: smt().
move=> ilt hlo' hhi' hh' i0 i4 hr; have {ilt i0 i4} hi : i = 4 by smt().
move=> x1 x2 he; move: hp1 hp2; rewrite he /= => -> ->; rewrite h2; do split.
+ by apply BytesPKVec.tP => k kb; rewrite !BytesPKVec.initiE //= hlo' /#.
+ by apply BytesPKVec.tP => k kb; rewrite !BytesPKVec.initiE //= addzC hhi' /#.
+ apply Array32.tP => k kb; rewrite !Array32.initiE //=.
  rewrite (: k + 2 * polyvec_bytes = polyvec_bytes + (polyvec_bytes + k)) 1:#ring.
  by rewrite hhi' //; smt(ge0_polyvec_bytes).
+ apply Array32.tP => k kb; rewrite !Array32.initiE //=.
  by rewrite (: k + 2 * polyvec_bytes + 32 = 2 * polyvec_bytes + 32 + k) 1:#ring hh'.
+ apply Array32.tP => k kb; rewrite !Array32.initiE //=.
  by rewrite (: k + 2 * polyvec_bytes + 64 = 2 * polyvec_bytes + 64 + k) 1:#ring hr /#.
by apply Array32.tP => k kb; rewrite !Array32.initiE //= addzC.
qed.

(* -------------------------------------------------------------------- *)
(* encapsulation: (K, r) = G(m, H(pk)), and c = Enc(pk, m, r)           *)
lemma mlkem_kem_correct_enc :
  equiv [M.__crypto_kem_enc_jazz ~ MLKEM.encaps_internal :
    randomnessp{1} = coins{2} /\
    pk{2}.`1 = BytesPKVec.init (fun i => pk{1}.[i]) /\
    pk{2}.`2 = Array32.init (fun i => pk{1}.[polyvec_bytes + i])
    ==>
    let (c,k) = res{2} in
    c.`1 = BytesCtVec.init (fun i => res{1}.`1.[i]) /\
    c.`2 = BytesPoly.init (fun i => res{1}.`1.[i + polyvecc_bytes]) /\
    k = res{1}.`2].
proof.
proc => /=.
seq 7 3 : (#pre /\
  Array32.init (fun i => kr{1}.[i]) = _K{2} /\
  Array32.init (fun i => kr{1}.[32 + i]) = r{2} /\
  Array32.init (fun i => buf{1}.[i]) = m{2}).
+ wp; ecall {1} (sha3_512A_A64_ph buf{1}).
  wp; ecall {1} (sha3_256A_MPK_ph pk{1}).
  auto => /> &1 &2 hp1 hp2.
  have -> : H_pk pk{2} = H_pk (pk{2}.`1, pk{2}.`2) by case: (pk{2}).
  rewrite hp1 hp2 /=.
  pose hk := H_pk (BytesPKVec.init ("_.[_]" pk{1}),
                   Array32.init (fun i => pk{1}.[polyvec_bytes + i])).
  pose B := Array64.init (fun i => if 32 <= i < 64 then hk.[i - 32] else
    (Array64.init (WArray64.get8 (WArray64.set256_direct
       (WArray64.init8 ("_.[_]" witness<:W8.t Array64.t>))
       0 (WArray32.get256_direct (WArray32.init8 ("_.[_]" coins{2})) 0)))).[i]).
  have hB1 : Array32.init ("_.[_]" B) = coins{2}.
  + apply Array32.tP => i ib; rewrite Array32.initiE //= /B Array64.initiE 1:/# /= ifF 1:/#.
    rewrite Array64.initiE 1:/# /= ifT // /WArray32.get256_direct pack32bE // initiE //=.
    by rewrite /WArray32.init8 WArray32.initiE.
  have hB2 : Array32.init (fun i => B.[i + 32]) = hk.
  + by apply Array32.tP => i ib; rewrite Array32.initiE //= /B Array64.initiE 1:/# /= ifT /#.
  rewrite hB1 hB2 /G_mhpk /=; split.
  + by apply Array32.tP => i ib; rewrite Array32.initiE //= Array64.initiE 1:/# /= ifT 1:/#.
  by apply Array32.tP => i ib; rewrite Array32.initiE //= Array64.initiE 1:/# /= ifF 1:/#.
wp; ecall (mlkem_correct_enc_1_avx2 pk{1}); auto => /> &1 &2 hp1 hp2.
split; 1: by rewrite hp2; apply Array32.tP => i ib; rewrite !Array32.initiE //= addzC.
move=> _ r1 [c1 c2] /= [-> ->] /=; apply Array32.tP => i ib.
rewrite Array32.initiE //= Array32.initiE //= ifT 1:/#.
by rewrite /WArray64.get256_direct pack32bE // initiE //= /WArray64.init8 WArray64.initiE 1:/#.
qed.

(* -------------------------------------------------------------------- *)
(* decapsulation: re-encryption, and the implicit rejection J(z, c)     *)
lemma mlkem_kem_correct_dec :
  equiv [M.__crypto_kem_dec_jazz ~ MLKEM.decaps_internal :
    sk{2}.`1 = BytesPKVec.init (fun i => sk{1}.[i]) /\
    sk{2}.`2.`1 = BytesPKVec.init (fun i => sk{1}.[i + polyvec_bytes]) /\
    sk{2}.`2.`2 = Array32.init (fun i => sk{1}.[i + 2 * polyvec_bytes]) /\
    sk{2}.`3 = Array32.init (fun i => sk{1}.[i + 2 * polyvec_bytes + 32]) /\
    sk{2}.`4 = Array32.init (fun i => sk{1}.[i + 2 * polyvec_bytes + 64]) /\
    let (c1,c2) = cph{2} in
      c1 = BytesCtVec.init (fun i => ct{1}.[i]) /\
      c2 = BytesPoly.init (fun i => ct{1}.[i + polyvecc_bytes])
    ==> ={res}].
proof.
have hpb : kvec * 384 = polyvec_bytes by rewrite /polyvec_bytes mulzC.
have hskb : sk_bytes = 2 * polyvec_bytes + 96 by done.
proc => /=.
seq 8 1 : (#pre /\ skp{2} = sk{2}.`1 /\ pk{2} = sk{2}.`2 /\ hpk{2} = sk{2}.`3 /\
  z{2} = sk{2}.`4 /\ skp{1} = Array_polyvec_bytes.init (fun i => sk{1}.[i]) /\
  (forall k, 0 <= k < 32 => zp_ct{1}.[k] = sk{1}.[2 * polyvec_bytes + 64 + k])).
+ auto => /> &1 &2 5? hc k0 k00 k0n; rewrite hpb.
  rewrite Array_zct_bytes.initiE 1:#smt:(ge0_ct_bytes) /=.
  rewrite WArray_zct_bytes.get8_set256_directE 1,2:#smt:(ge0_ct_bytes) ifT 1:/#.
  rewrite /WArray_sk_bytes.get256_direct pack32bE 1:/# initiE 1:/# /=.
  rewrite /WArray_sk_bytes.init8 WArray_sk_bytes.initiE 1:#smt:(ge0_polyvec_bytes) /=.
  by congr; ring.

(* the decryption of the ciphertext *)
seq 1 1 : (#pre /\ aux{1} = m{2}).
+ call mlkem_correct_dec; auto => /> &1 &2 h1 h2 h3 h4 h5 hc hz.
  split.
  + rewrite h1; apply BytesPKVec.tP => i ib; rewrite !BytesPKVec.initiE //=.
    by rewrite Array_polyvec_bytes.initiE.
  move=> x1 x2 he; move: hc; rewrite he /= => -[-> ->].
  by split => //; apply BytesPoly.tP => i ib; rewrite !BytesPoly.initiE //= addzC.

(* (K, r) = G(m, H(pk)) *)
seq 4 1 : (#pre /\
  Array32.init (fun i => kr{1}.[i]) = _K{2} /\
  Array32.init (fun i => kr{1}.[32 + i]) = r{2} /\
  Array32.init (fun i => buf{1}.[i]) = m{2}).
+ wp; ecall {1} (sha3_512A_A64_ph buf{1}); auto => /> &1 &2 h1 h2 h3 h4 h5 hc hz.
  rewrite hpb h4.
  pose B := Array64.init (WArray64.get8 (WArray64.set256_direct (WArray64.init8 ("_.[_]"
    (Array64.init (fun i => if 0 <= i < 32 then m{2}.[i] else buf{1}.[i])))) 32
    (WArray_sk_bytes.get256_direct (WArray_sk_bytes.init8 ("_.[_]" sk{1}))
       (polyvec_bytes + (polyvec_bytes + 32))))).
  have hB1 : Array32.init ("_.[_]" B) = m{2}.
  + apply Array32.tP => i ib; rewrite Array32.initiE //= /B Array64.initiE 1:/# /=.
    rewrite ifF 1:/# /WArray64.get8 /WArray64.init8 WArray64.initiE 1:/# /=.
    by rewrite Array64.initiE 1:/# /= ifT.
  have hB2 : Array32.init (fun i => B.[i + 32]) =
             Array32.init (fun i => sk{1}.[i + 2 * polyvec_bytes + 32]).
  + apply Array32.tP => i ib; rewrite !Array32.initiE //= /B Array64.initiE 1:/# /= ifT 1:/#.
    rewrite /WArray_sk_bytes.get256_direct pack32bE 1:/# initiE 1:/# /=.
    rewrite /WArray_sk_bytes.init8 WArray_sk_bytes.initiE 1:#smt:(ge0_polyvec_bytes) /=.
    by congr; ring.
  rewrite /B in hB1; rewrite /B in hB2; rewrite hB1 hB2 /G_mhpk /=; split.
  + by apply Array32.tP => i ib; rewrite Array32.initiE //= Array64.initiE 1:/# /= ifT 1:/#.
  by apply Array32.tP => i ib; rewrite Array32.initiE //= Array64.initiE 1:/# /= ifF 1:/#.

(* the re-encryption *)
swap {2} 1 1.
seq 2 1 : (#pre /\
  c{2}.`1 = BytesCtVec.init (fun i => ctc{1}.[i]) /\
  c{2}.`2 = BytesPoly.init (fun i => ctc{1}.[i + polyvecc_bytes])).
+ wp; ecall (mlkem_correct_enc_1_avx2 (Array_pk_bytes.init (fun i => sk{1}.[kvec * 384 + i]))).
  auto => /> &1 &2 h1 h2 h3 h4 h5 hc hz.
  rewrite hpb; split.
  + split.
    + rewrite h2; apply BytesPKVec.tP => i ib; rewrite !BytesPKVec.initiE //=.
      by rewrite Array_pk_bytes.initiE 1:#smt:(ge0_polyvec_bytes) /= addzC.
    rewrite h3; apply Array32.tP => i ib; rewrite !Array32.initiE //=.
    by rewrite Array_pk_bytes.initiE 1:#smt:(ge0_polyvec_bytes) /=; congr; ring.
  by move=> _ _ r0 [c1 c2] /= [-> ->].

(* the comparison with the received ciphertext *)
have hceq : forall (a b : W8.t Array_ct_bytes.t),
  (BytesCtVec.init (fun i => a.[i]), BytesPoly.init (fun i => a.[i + polyvecc_bytes])) =
  (BytesCtVec.init (fun i => b.[i]), BytesPoly.init (fun i => b.[i + polyvecc_bytes])) <=>
  a = b.
+ move=> a b; split; last by move=> ->.
  have hcb : ct_bytes = kvec * (32 * du) + 32 * dv by done.
  have hpv : polyvecc_bytes = kvec * (32 * du) by done.
  move=> /= [h1 h2]; apply Array_ct_bytes.tP => k kb.
  case: (k < polyvecc_bytes) => hk.
  + by move/BytesCtVec.tP: h1 => /(_ k _); [smt() | rewrite !BytesCtVec.initiE /#].
  by move/BytesPoly.tP: h2 => /(_ (k - polyvecc_bytes) _); [smt() | rewrite !BytesPoly.initiE /#].
seq 2 0 : (#pre /\ (c{2} = cph{2} => cnd{1} = W64.of_int 0) /\
           (c{2} <> cph{2} => cnd{1} = W64.of_int 1)).
+ ecall {1} (verify_correct ct{1} ctc{1}); auto => /> &1 &2 5? hc hz hc1 hc2 r h0 h1.
  have -> : c{2} = (c{2}.`1, c{2}.`2) by case: (c{2}).
  have hcph : cph{2} = (BytesCtVec.init (fun i => ct{1}.[i]),
                        BytesPoly.init (fun i => ct{1}.[i + polyvecc_bytes])).
  + by move: hc; case: (cph{2}) => x1 x2 /= [-> ->].
  rewrite hcph hc1 hc2; have := hceq ctc{1} ct{1}; rewrite /= => ->.
  smt().

(* the implicit-rejection key, and the selection *)
ecall {1} (cmov_correct shk{1} (Array32.init (fun i => kr{1}.[0 + i])) cnd{1}).
wp; ecall {1} (shake256_A32_AZCT_ph zp_ct{1}).
while {1} (#pre /\ inc{1} = ct_bytes %/ 32 /\ 0 <= j{1} <= inc{1} /\
  (forall k, 0 <= k < 32 * j{1} => zp_ct{1}.[32 + k] = ct{1}.[k])) (inc{1} - j{1}).
+ move=> &m z0; auto => /> &hr.
  move=> 6? hz _ _ _ _ j0 jn hj jlt.
  have hzb : zct_bytes = 32 + ct_bytes by done.
  have hb : 32 * j{hr} + 32 <= ct_bytes by smt(ct_bytes32).
  do split; 2,3,5: smt().
  + move=> k k0 kn; rewrite Array_zct_bytes.initiE 1:#smt:(ge0_ct_bytes) /=.
    rewrite WArray_zct_bytes.get8_set256_directE 1,2:#smt:(ge0_ct_bytes) ifF 1:/#.
    by rewrite /WArray_zct_bytes.get8 /WArray_zct_bytes.init8 WArray_zct_bytes.initiE 1:/# /= hz.
  move=> k k0 kn; rewrite Array_zct_bytes.initiE 1:#smt:(ge0_ct_bytes) /=.
  rewrite WArray_zct_bytes.get8_set256_directE 1,2:#smt:(ge0_ct_bytes).
  case: (32 * (1 + j{hr}) <= 32 + k < 32 * (1 + j{hr}) + 32) => hk.
  + rewrite /WArray_ct_bytes.get256_direct pack32bE 1:/# initiE 1:/# /=.
    by rewrite /WArray_ct_bytes.init8 WArray_ct_bytes.initiE 1:/# /=; congr; ring.
  rewrite /WArray_zct_bytes.get8 /WArray_zct_bytes.init8 WArray_zct_bytes.initiE 1:/# /=.
  by rewrite hj /#.
auto => /> &1 &2 h1 h2 h3 h4 h5 hc hz hc1 hc2 hcq hcn; rewrite ct_bytesE.
split; 1: smt(ct_bytes32 ge0_ct_bytes).
move=> j zp; split; 1: smt().
move=> jn hz' _ j0 jle hj; have hj32 : 32 * j = ct_bytes by smt(ct_bytes32).
have hcph : cph{2} = (BytesCtVec.init (fun i => ct{1}.[i]),
                      BytesPoly.init (fun i => ct{1}.[i + polyvecc_bytes])).
+ by move: hc; case: (cph{2}) => x1 x2 /= [-> ->].
have hcb : ct_bytes = kvec * (32 * du) + 32 * dv by done.
have hpv : polyvecc_bytes = kvec * (32 * du) by done.
split => hneq r0 hr0 hr1.
+ rewrite (hr1 (hcn hneq)) h5 hcph; congr.
  + apply Array32.tP => k kb; rewrite !Array32.initiE //= hz' //; congr; ring.
  congr.
  + have hcv : 32 * du * kvec = polyvecc_bytes by rewrite hpv; ring.
    by apply BytesCtVec.tP => k kb; rewrite !BytesCtVec.initiE //= hj; smt(ge0_polyc_bytes).
  apply BytesPoly.tP => k kb; rewrite !BytesPoly.initiE //= -addzA hj.
  + have hpc : polyc_bytes = 32 * dv by done.
    smt(ge0_polyvecc_bytes).
  by congr; ring.
by rewrite (hr0 (hcq hneq)).
qed.

(* -------------------------------------------------------------------- *)
(* the modulus check of the public key: the re-encoding of its decoding *)
lemma check_ek_reencode (_pk : W8.t Array_pk_bytes.t) :
  check_ek (BytesPKVec.init (fun i => _pk.[i]),
            Array32.init (fun i => _pk.[polyvec_bytes + i])) <=>
  forall k, 0 <= k < polyvec_bytes =>
    (Array_polyvec_bytes.of_list W8.zero (ByteEncode 12 (Array_vecn.to_list
       (Array_vecn.map Zq.asint (Array_vecn.init (fun kk =>
          Zq.incoeff (decode12_vec (BytesPKVec.init (fun i => _pk.[i]))).[kk])))))).[k] =
    _pk.[k].
proof.
pose D := decode12_vec (BytesPKVec.init (fun i => _pk.[i])).
rewrite /check_ek /=.
have [hl _] := vector_unlift (ofipolyvec D).
have hX := lift_arrayvecn_unlift_ofipolyvec D _.
+ rewrite IPVec.allP => k kb.
  have := decode12_vec_bnd (BytesPKVec.init (fun i => _pk.[i])) k _; [by rewrite vecnE | smt()].
have -> : decode12_vec (BytesPKVec.init ("_.[_]" _pk)) = D by done.
rewrite -hl encode12_vec_tobytes_bridge hX.
have hpb : polyvec_bytes = 384 * kvec by rewrite /polyvec_bytes.
split => [heq k kb | h].
+ move/(congr1 (fun (x : W8.t BytesPKVec.t) => x.[k])): heq.
  by rewrite /= !BytesPKVec.initiE 1,2:/#.
by apply BytesPKVec.tP => k kb; rewrite !BytesPKVec.initiE //= h /#.
qed.

lemma get256_pk_xor0 (a : W8.t Array_polyvec_bytes.t) (b : W8.t Array_pk_bytes.t) i :
  0 <= 32 * i => 32 * i + 32 <= polyvec_bytes =>
  WArray_polyvec_bytes.get256_direct (WArray_polyvec_bytes.init8 ("_.[_]" a)) (32 * i) `^`
  WArray_pk_bytes.get256_direct (WArray_pk_bytes.init8 ("_.[_]" b)) (32 * i) = W256.zero <=>
  forall k, i * 32 <= k < i * 32 + 32 => b.[k] = a.[k].
proof.
move=> h0 h1; have hpk : pk_bytes = polyvec_bytes + 32 by done.
rewrite /WArray_polyvec_bytes.get256_direct /WArray_pk_bytes.get256_direct xor0_pack32.
split => h k kb.
+ have := h (k - 32 * i) _; 1: smt().
  by rewrite /= WArray_polyvec_bytes.initiE 1:/# WArray_pk_bytes.initiE /#.
by rewrite /= WArray_polyvec_bytes.initiE 1:/# WArray_pk_bytes.initiE 1:/# /= h /#.
qed.

lemma mlkem_kem_check_pk (_pk : W8.t Array_pk_bytes.t) :
  phoare [M.__crypto_kem_check_pk_jazz : pk = _pk ==>
    res = if check_ek (BytesPKVec.init (fun i => _pk.[i]),
                       Array32.init (fun i => _pk.[polyvec_bytes + i]))
          then W64.zero else -W64.one] = 1%r.
proof.
have hpb : kvec * 384 = polyvec_bytes by rewrite /polyvec_bytes mulzC.
have hpb32 : polyvec_bytes %/ 32 = 12 * kvec.
+ by rewrite /polyvec_bytes (: 384 * kvec = 12 * kvec * 32) 1:#ring mulzK.
have hz : forall (w : W256.t), to_uint w = 0 <=> w = W256.zero.
+ by move=> w; rewrite W256.to_uint_eq.
pose E := Array_polyvec_bytes.of_list W8.zero (ByteEncode 12 (Array_vecn.to_list
  (Array_vecn.map Zq.asint (Array_vecn.init (fun kk =>
     Zq.incoeff (decode12_vec (BytesPKVec.init (fun i => _pk.[i]))).[kk]))))).
proc => /=.
wp; while (0 <= i <= inc /\ inc = polyvec_bytes %/ 32 /\ pk = _pk /\ pkb = E /\
  (to_uint h = 0 <=> forall k, 0 <= k < i * 32 => pkb.[k] = pk.[k])) (inc - i).
+ move=> z; auto => /> &hr i0 _ hh ilt.
  have [hb0 hb1] : 0 <= 32 * i{hr} /\ 32 * i{hr} + 32 <= polyvec_bytes by smt().
  rewrite !hz !orw_eq0 !get256_pk_xor0 // -!hz !hh; smt().
wp; ecall (polyvec_tobytes_corr pkpv);
  ecall (polyvec_frombytes_corr (Array_polyvec_bytes.init (fun i_0 => pk.[0 + i_0])));
  auto => /> rr hrr hrb.
have hE : lift_arrayvecn (nttpackv rr) = Array_vecn.init (fun kk =>
  Zq.incoeff (decode12_vec (BytesPKVec.init (fun i => _pk.[i]))).[kk]).
+ by rewrite -nttpackv_lift hrr unpackvK (frombytes12_decode_bridge ("_.[_]" _pk)).
rewrite hE /= -/E.
split; 1: by do split; [smt(gt0_k) | rewrite hpb | smt()].
move=> h0 i0; split; 1: smt().
move=> hni i0p i0le hinc _ hh.
have hi : i0 * 32 = polyvec_bytes by smt().
move: hh; rewrite hi => hh.
have /= -> := check_ek_reencode _pk.
rewrite -/E -hh /VPTEST_256 /ZF_of /= hz.
by case: (h0 = W256.zero) => //= _; ring.
qed.

(* -------------------------------------------------------------------- *)
(* the hash check of the secret key                                     *)
lemma get256_sk_xor0 (a : W8.t Array32.t) (b : W8.t Array_sk_bytes.t) o :
  0 <= o => o + 32 <= sk_bytes =>
  WArray32.get256 (WArray32.init8 ("_.[_]" a)) 0 `^`
  WArray_sk_bytes.get256_direct (WArray_sk_bytes.init8 ("_.[_]" b)) o = W256.zero <=>
  forall k, 0 <= k < 32 => b.[o + k] = a.[k].
proof.
move=> h0 h1; rewrite /WArray32.get256_direct /WArray_sk_bytes.get256_direct xor0_pack32.
by split => h k kb; have := h k kb; rewrite /= WArray32.initiE 1:/# WArray_sk_bytes.initiE 1:/#.
qed.

lemma mlkem_kem_check_sk (_sk : W8.t Array_sk_bytes.t) :
  phoare [M.__crypto_kem_check_sk_jazz : sk = _sk ==>
    res = if H_pk (BytesPKVec.init (fun i => _sk.[i + polyvec_bytes]),
                   Array32.init (fun i => _sk.[i + 2 * polyvec_bytes]))
             = Array32.init (fun i => _sk.[i + 2 * polyvec_bytes + 32])
          then W64.zero else -W64.one] = 1%r.
proof.
have hpb : kvec * 384 = polyvec_bytes by rewrite /polyvec_bytes mulzC.
have hpkb : pk_bytes = polyvec_bytes + 32 by done.
proc => /=.
wp; ecall (sha3_256A_MPK_ph (Array_pk_bytes.init (fun i => sk.[kvec * 384 + i]))).
auto => />.
have -> : BytesPKVec.init ("_.[_]" (Array_pk_bytes.init (fun i => _sk.[kvec * 384 + i]))) =
          BytesPKVec.init (fun i => _sk.[i + polyvec_bytes]).
+ apply BytesPKVec.tP => k kb; rewrite !BytesPKVec.initiE //=.
  by rewrite Array_pk_bytes.initiE 1:/# /= hpb addzC.
have -> : Array32.init (fun i => (Array_pk_bytes.init (fun i0 => _sk.[kvec * 384 + i0])).[
            polyvec_bytes + i]) =
          Array32.init (fun i => _sk.[i + 2 * polyvec_bytes]).
+ apply Array32.tP => k kb; rewrite !Array32.initiE //=.
  by rewrite Array_pk_bytes.initiE 1:#smt:(ge0_polyvec_bytes) /= hpb; congr; ring.
pose hk := H_pk _.
have := get256_sk_xor0 hk _sk (kvec * 384 + (kvec * 384 + 32)) _ _;
  1,2: smt(ge0_polyvec_bytes).
rewrite /= => heq; rewrite /VPTEST_256 /ZF_of /= heq hpb.
case: (hk = Array32.init (fun i => _sk.[i + 2 * polyvec_bytes + 32])) => hc.
+ by rewrite ifF //= => k kb; rewrite hc Array32.initiE //=; congr; ring.
rewrite ifT; 2: ring.
move: hc; apply contra => h; apply Array32.tP => k kb.
by rewrite -h 1:/# Array32.initiE 1:/# /=; congr; ring.
qed.

(* -------------------------------------------------------------------- *)
(* encapsulation after the modulus check: the return code is the check  *)
(* bit; the outputs are the all-zero ones when the check fails          *)
lemma mlkem_kem_correct_encaps :
  equiv [M.__crypto_kem_encaps_derand_jazz ~ MLKEM.encaps_derand :
    randomnessp{1} = coins{2} /\
    pk{2}.`1 = BytesPKVec.init (fun i => pk{1}.[i]) /\
    pk{2}.`2 = Array32.init (fun i => pk{1}.[polyvec_bytes + i])
    ==>
    res{1}.`3 = (if res{2}.`1 then W64.zero else -W64.one) /\
    res{2}.`2.`1 = BytesCtVec.init (fun i => res{1}.`1.[i]) /\
    res{2}.`2.`2 = BytesPoly.init (fun i => res{1}.`1.[i + polyvecc_bytes]) /\
    res{2}.`3 = res{1}.`2].
proof.
have hne : W64.zero <> -W64.one.
+ by rewrite W64.minus_one W64.to_uint_eq W64.to_uint0 W64.to_uint_onew.
proc => /=.
seq 1 1 : (#pre /\ r{1} = (if check_ek pk{2} then W64.zero else -W64.one) /\ b{2} = check_ek pk{2}).
+ ecall {1} (mlkem_kem_check_pk pk{1}); auto => /> &1 &2 hp1 hp2.
  have -> : pk{2} = (pk{2}.`1, pk{2}.`2) by case: (pk{2}).
  by rewrite hp1 hp2.
sp 1 1; if {2}.
+ rcondt {1} 1; 1: by move=> &2; auto => />; smt().
  by wp; call mlkem_kem_correct_enc; auto => /> &1 &2 hp1 hp2 hc [cl kl] [c k] /=; smt().
rcondf {1} 1; 1: by move=> &2; auto => />; smt().
wp; while {1} (inc{1} = ct_bytes %/ 32 /\ 0 <= i{1} <= inc{1} /\ z{1} = W256.zero /\
  forall k, 0 <= k < 32 * i{1} => ct{1}.[k] = W8.zero) (inc{1} - i{1}).
+ move=> &m z0; auto => /> &hr i0 ilt hz ii.
  split; 2: smt().
  split; 1: smt().
  move=> k k0 kn; rewrite Array_ct_bytes.initiE 1:#smt:(ct_bytes32 ge0_ct_bytes) /=.
  rewrite WArray_ct_bytes.get8_set256_directE 1,2:#smt:(ct_bytes32 ge0_ct_bytes).
  case: (32 * i{hr} <= k < 32 * i{hr} + 32) => hk.
  + by apply W8.wordP => j jb; rewrite bits8iE //= zerowE.
  rewrite /WArray_ct_bytes.get8 /WArray_ct_bytes.init8.
  by rewrite WArray_ct_bytes.initiE 1:#smt:(ct_bytes32 ge0_ct_bytes) /= hz /#.
auto => /> &1 &2 hp1 hp2 hc; rewrite ct_bytesE.
split; 1: smt(ct_bytes32 ge0_ct_bytes).
move=> ct0 i0; split; 1: smt().
move=> hi _ i00 ile hz.
have hpv : polyvecc_bytes = kvec * (32 * du) by done.
have hct : ct_bytes = polyvecc_bytes + 32 * dv by rewrite -ct_bytesE hpv; smt().
have hz' : forall k, 0 <= k < ct_bytes => ct0.[k] = W8.zero by smt(ct_bytes32).
rewrite /ct_zero /ss_zero /=; do! split.
+ apply BytesCtVec.tP => k kb; rewrite BytesCtVec.createiE // BytesCtVec.initiE //= hz' //.
  smt(gt0_k gt0_du gt0_dv).
+ apply BytesPoly.tP => k kb; rewrite BytesPoly.createiE // BytesPoly.initiE //= hz' //.
  smt(gt0_k gt0_du gt0_dv).
apply Array32.tP => k kb; rewrite Array32.initiE // Array32.createiE //.
rewrite (WArray32.get8_set256_directE _ 0 k) // ifT 1:/#.
by apply W8.wordP => j jb; rewrite bits8iE //= zerowE.
qed.

(* -------------------------------------------------------------------- *)
(* decapsulation after the hash check: the return code is the check     *)
(* bit; the shared secret is the all-zero one when the check fails      *)
lemma mlkem_kem_correct_decaps :
  equiv [M.__crypto_kem_decaps_jazz ~ MLKEM.decaps :
    sk{2}.`1 = BytesPKVec.init (fun i => sk{1}.[i]) /\
    sk{2}.`2.`1 = BytesPKVec.init (fun i => sk{1}.[i + polyvec_bytes]) /\
    sk{2}.`2.`2 = Array32.init (fun i => sk{1}.[i + 2 * polyvec_bytes]) /\
    sk{2}.`3 = Array32.init (fun i => sk{1}.[i + 2 * polyvec_bytes + 32]) /\
    sk{2}.`4 = Array32.init (fun i => sk{1}.[i + 2 * polyvec_bytes + 64]) /\
    let (c1,c2) = cph{2} in
      c1 = BytesCtVec.init (fun i => ct{1}.[i]) /\
      c2 = BytesPoly.init (fun i => ct{1}.[i + polyvecc_bytes])
    ==>
    res{1}.`2 = (if res{2}.`1 then W64.zero else -W64.one) /\
    res{2}.`2 = res{1}.`1].
proof.
have hne : W64.zero <> -W64.one.
+ by rewrite W64.minus_one W64.to_uint_eq W64.to_uint0 W64.to_uint_onew.
proc => /=.
seq 1 1 : (#pre /\ r{1} = (if check_dk sk{2} then W64.zero else -W64.one) /\ b{2} = check_dk sk{2}).
+ ecall {1} (mlkem_kem_check_sk sk{1}); auto => /> &1 &2 h1 h2 h3 h4 h5 hc.
  rewrite /check_dk.
  have -> : sk{2}.`2 = (sk{2}.`2.`1, sk{2}.`2.`2) by case: (sk{2}.`2).
  by rewrite h2 h3 h4.
sp 1 1; if {2}.
+ rcondt {1} 1; 1: by move=> &2; auto => />; smt().
  wp; call mlkem_kem_correct_dec; auto => /> &1 &2 h1 h2 h3 h4 h5 hc hck r; smt().
rcondf {1} 1; 1: by move=> &2; auto => />; smt().
auto => /> &1 &2 h1 h2 h3 h4 h5 hc hck; rewrite /ss_zero.
apply Array32.tP => k kb; rewrite Array32.initiE // Array32.createiE //.
rewrite (WArray32.get8_set256_directE _ 0 k) // ifT 1:/#.
by apply W8.wordP => j jb; rewrite bits8iE //= zerowE.
qed.

end MLKEM_KEM_avx2T.
