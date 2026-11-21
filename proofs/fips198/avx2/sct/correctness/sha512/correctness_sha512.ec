(*
 * sha512, target avx2, profile sct: the entry points of HMAC-SHA-512 (FIPS
 * 198-1), stated with the operators of Theorems.ec of the SHA-2 proofs.
 *)

require import AllCore List IntDiv.
require BitEncoding.
import BitEncoding.BitChunking.
from Jasmin require import JWord JUtils JMemory JByte_array.
require import BArray28 BArray32 BArray48 BArray64 BArray112 BArray128 BArray144 BArray208 BArray256.
require import BArray272 BArray512 BArray784.
require import SBArray112_32 SBArray112_64 SBArray144_112 SBArray208_64 SBArray208_128 SBArray272_208.
require import SBArray512_64 SBArray512_128 SBArray784_256 SBArray784_512.
require import Jsha2 Theorems.
require import Bytes FIPS180_SHA2 FIPS198_HMAC.
require JWordList.
require StreamSpec State K256 K512 SHA256_Stream SHA512_Stream HMAC_SHA256 HMAC_SHA512 Ctx256 Ctx512 CtxHmac256 CtxHmac512.
require Lanes SHA256_X8 SHA512_X4 CtxX8 CtxX4 StdOrder.
require Exports.

(* Each entry point starts the misspeculation flag with #init_msf and makes
   one call to a layer of the SHA-2 proofs; update absorbs into the inner
   context through a sub-array view (Exports.ec). The statements below are
   those of the layers at the entry point's own arguments. Status codes: 0
   success, 1 a context of another function (or an uninitialised one), 2 an
   inner message that would reach 2^61 bytes. *)

lemma mac_correct (pk lk pm lm : W64.t) :
  phoare [M.jade_mac_hmac_sha512_amd64_avx2 :
           key = pk /\ keylen = lk /\ msg = pm /\ msglen = lm /\
           W64.to_uint pk + W64.to_uint lk < W64.modulus /\ W64.to_uint lk < 2^61 /\
           W64.to_uint pm + W64.to_uint lm < W64.modulus /\ 128 + W64.to_uint lm < 2^61 ==>
           BArray64.to_list res
           = hmac_sha512 (memread Glob.mem (W64.to_uint pk) (W64.to_uint lk))
                  (memread Glob.mem (W64.to_uint pm) (W64.to_uint lm))] = 1%r.
proof. by proc; call (hmac_sha512_mem_total pk lk pm lm); auto. qed.

lemma init_correct (pk lk : W64.t) :
  phoare [M.jade_mac_hmac_sha512_amd64_avx2_init :
           key = pk /\ keylen = lk /\
           W64.to_uint pk + W64.to_uint lk < W64.modulus /\ W64.to_uint lk < 2^61 ==>
           hmac512_ctx hmac512_tag (memread Glob.mem (W64.to_uint pk) (W64.to_uint lk)) [] res] = 1%r.
proof. by proc; call (hmac_sha512_ctx_init_total pk lk); auto. qed.

lemma update_correct (c0 : BArray272.t) (k text : bytes) (p0 l0 : W64.t) :
  phoare [M.jade_mac_hmac_sha512_amd64_avx2_update :
           ctx = c0 /\ in_0 = p0 /\ inlen = l0 /\
           W64.to_uint p0 + W64.to_uint l0 < W64.modulus ==>
           (res.`2 <> W64.zero => res.`1 = c0) /\
           (BArray208.get64d (SBArray272_208.get_sub8 c0 0) 0 <> hmac512_tag => res.`2 = W64.one) /\
           (hmac512_ctx hmac512_tag k text c0 =>
              if size text + W64.to_uint l0 < 2^61 - 128
              then res.`2 = W64.zero /\
                   hmac512_ctx hmac512_tag k (text ++ memread Glob.mem (W64.to_uint p0) (W64.to_uint l0)) res.`1
              else res.`2 = W64.of_int 2)] = 1%r.
proof.
conseq (_ : W64.to_uint p0 + W64.to_uint l0 < W64.modulus ==> true)
       (Exports.hmac_sha512_update_correct c0 k text p0 l0) => //.
+ by move=> &m _ r; rewrite !hmac512_ctxE hmac512_tagE.
proc; wp; call Ctx512.sha512_ctx_update_ll; call Ctx256.sha2_tag_ll; auto.
qed.

lemma final_correct (c0 : BArray272.t) (o0 : BArray64.t) (k text : bytes) :
  phoare [M.jade_mac_hmac_sha512_amd64_avx2_final :
           ctx = c0 /\ out = o0 ==>
           (BArray208.get64d (SBArray272_208.get_sub8 c0 0) 0 <> hmac512_tag =>
              res.`3 = W64.one /\ res.`1 = c0 /\ res.`2 = o0) /\
           (hmac512_ctx hmac512_tag k text c0 =>
              res.`3 = W64.zero /\ BArray64.to_list res.`2 = hmac_sha512 k text /\
              forall i, 0 <= i < 272 => BArray272.get8 res.`1 i = W8.zero)] = 1%r.
proof. by proc; call (hmac_sha512_ctx_final_total c0 o0 k text); auto. qed.
