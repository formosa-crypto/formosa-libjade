(*
 * sha512_224, target avx2, profile sct: the entry points of the set, stated with
 * the operators of Theorems.ec.
 *)

require import AllCore List IntDiv.
require BitEncoding.
import BitEncoding.BitChunking.
from Jasmin require import JWord JUtils JMemory JByte_array.
require import BArray28 BArray32 BArray48 BArray64 BArray112 BArray128 BArray144 BArray208 BArray256.
require import BArray272 BArray512.
require import SBArray112_32 SBArray112_64 SBArray144_112 SBArray208_64 SBArray208_128 SBArray272_208.

require import Jsha2 Theorems.
require import Bytes FIPS180_SHA2 FIPS198_HMAC.
require JWordList.
require StreamSpec State K256 K512 SHA256_Stream SHA512_Stream HMAC_SHA256 HMAC_SHA512 Ctx256 Ctx512 CtxHmac256 CtxHmac512.
require StdOrder.



(* Each export starts the misspeculation flag with #init_msf and makes
   one call to a layer above (two for the initialising ones: the initial
   hash value, then the fresh context). The statements below are those of
   the layers at the export's own arguments. Status codes: 0 success, 1 a
   context of another function (or an uninitialised one), 2 a total length
   that would reach 2^61 bytes. *)

lemma hash_correct (p0 l0 : W64.t) :
  phoare [M.jade_hash_sha512_224_amd64_avx2 :
           in_0 = p0 /\ inlen = l0 /\
           W64.to_uint p0 + W64.to_uint l0 < W64.modulus /\ W64.to_uint l0 < 2^61 ==>
           BArray28.to_list res = SHA512.sha512_224 (memread Glob.mem (W64.to_uint p0) (W64.to_uint l0))] = 1%r.
proof. by proc; call (sha512_224_mem_total p0 l0); auto. qed.
lemma init_correct :
  phoare [M.jade_hash_sha512_224_amd64_avx2_init : true ==> sha512_ctx (sha2_tag 5) SHA512.H0_512_224 [] res] = 1%r.
proof.
conseq (_ : true ==> true) (_ : true ==> sha512_ctx (sha2_tag 5) SHA512.H0_512_224 [] res) => //.
+ conseq (: _ ==> Ctx512.ctx512 (sha2_tag 5) SHA512.H0_512_224 [] res).
  + by move=> &m _ c; rewrite sha512_ctxE.
  proc; ecall (Ctx512.sha512_ctx_init_correct h (sha2_tag 5)).
  wp; ecall (Ctx256.sha2_tag_correct 5).
  by ecall (SHA512_Stream.sha512_224_init_correct); auto => /> h1 ->.
by proc; call Ctx512.ctx_init512_ll; wp; call Ctx256.sha2_tag_ll; call SHA512_Stream.sha512_224_init_ll; auto.
qed.

lemma update_correct (c0 : BArray208.t) (h0 : W64.t list) (m : bytes) (p0 l0 : W64.t) :
  phoare [M.jade_hash_sha512_224_amd64_avx2_update :
           ctx = c0 /\ in_0 = p0 /\ inlen = l0 /\
           W64.to_uint p0 + W64.to_uint l0 < W64.modulus ==>
           (res.`2 <> W64.zero => res.`1 = c0) /\
           (BArray208.get64d c0 0 <> sha2_tag 5 => res.`2 = W64.one) /\
           (sha512_ctx (sha2_tag 5) h0 m c0 =>
              if size m + W64.to_uint l0 < 2^61
              then res.`2 = W64.zero /\
                   sha512_ctx (sha2_tag 5) h0 (m ++ memread Glob.mem (W64.to_uint p0) (W64.to_uint l0)) res.`1
              else res.`2 = W64.of_int 2)] = 1%r.
proof. by proc; call (sha512_ctx_update_total c0 (sha2_tag 5) h0 m p0 l0); inline M.__sha2_tag; auto. qed.

lemma final_correct (c0 : BArray208.t) (h0 : W64.t list) (m : bytes) (d0 : BArray28.t) :
  phoare [M.jade_hash_sha512_224_amd64_avx2_final :
           ctx = c0 /\ out = d0 ==>
           (BArray208.get64d c0 0 <> sha2_tag 5 => res.`3 = W64.one /\ res.`1 = c0 /\ res.`2 = d0) /\
           (sha512_ctx (sha2_tag 5) h0 m c0 =>
              res.`3 = W64.zero /\
              BArray28.to_list res.`2 = take 28 (flatten (map w64_be (SHA512.hash h0 m))) /\
              forall i, 0 <= i < 208 => BArray208.get8 res.`1 i = W8.zero)] = 1%r.
proof. by proc; call (sha512_224_ctx_final_total c0 (sha2_tag 5) h0 m d0); inline M.__sha2_tag; auto. qed.
