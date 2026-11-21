(*
 * sha512x4, target avx2, profile sct: the entry points of the set, stated with
 * the operators of Theorems.ec.
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



(* Each export starts the misspeculation flag with #init_msf and makes
   one call to a layer above (two for the initialising ones: the initial
   hash value, then the fresh context). The statements below are those of
   the layers at the export's own arguments. Status codes: 0 success, 1 a
   context of another function (or an uninitialised one), 2 a total length
   that would reach 2^61 bytes. *)

lemma hash_correct (in0 : BArray32.t) (l0 : W64.t) :
  phoare [M.jade_hash_sha512x4_amd64_avx2 :
           in_0 = in0 /\ len = l0 /\
           (forall q, 0 <= q < 4 =>
              W64.to_uint (BArray32.get64 in0 q) + W64.to_uint l0 < W64.modulus) /\
           W64.to_uint l0 < 2^61 ==>
           forall k, 0 <= k < 4 =>
             take 64 (drop (64 * k) (BArray256.to_list res))
             = SHA512.sha512 (memread Glob.mem (W64.to_uint (BArray32.get64 in0 k)) (W64.to_uint l0))] = 1%r.
proof. by proc; call (sha512_x4_lanes_total in0 l0); auto. qed.

lemma init_correct :
  phoare [M.jade_hash_sha512x4_amd64_avx2_init : true ==> sha512_x4_ctx SHA512.H0_512 (fun _ => []) res] = 1%r.
proof. by proc; call sha512_x4_ctx_init_total; auto. qed.

lemma init_from_correct (c0 : BArray784.t) (s0 : BArray208.t) (h0 : W64.t list) (m : bytes) :
  phoare [M.jade_hash_sha512x4_amd64_avx2_init_from :
           ctx = c0 /\ src = s0 ==>
           (BArray208.get64d s0 0 <> sha2_tag 4 => res.`2 = W64.one /\ res.`1 = c0) /\
           (sha512_ctx (sha2_tag 4) h0 m s0 => res.`2 = W64.zero /\ sha512_x4_ctx h0 (fun _ => m) res.`1)] = 1%r.
proof. by proc; call (sha512_x4_ctx_from_total c0 s0 h0 m); auto. qed.

lemma update_correct (c0 : BArray784.t) (h0 : W64.t list) (ms0 : int -> bytes)
  (in0 : BArray32.t) (l0 : W64.t) :
  phoare [M.jade_hash_sha512x4_amd64_avx2_update :
           ctx = c0 /\ in_0 = in0 /\ inlen = l0 /\
           (forall q, 0 <= q < 4 =>
              W64.to_uint (BArray32.get64 in0 q) + W64.to_uint l0 < W64.modulus) ==>
           (res.`2 <> W64.zero => res.`1 = c0) /\
           (BArray784.get64d c0 0 <> sha2_tag 10 => res.`2 = W64.one) /\
           (sha512_x4_ctx h0 ms0 c0 =>
              if size (ms0 0) + W64.to_uint l0 < 2^61
              then res.`2 = W64.zero /\
                   sha512_x4_ctx h0
                     (fun k => ms0 k ++ memread Glob.mem (W64.to_uint (BArray32.get64 in0 k)) (W64.to_uint l0))
                     res.`1
              else res.`2 = W64.of_int 2)] = 1%r.
proof. by proc; call (sha512_x4_ctx_update_total c0 h0 ms0 in0 l0); auto. qed.

lemma final_correct (c0 : BArray784.t) (d0 : BArray256.t) (h0 : W64.t list) (ms0 : int -> bytes) :
  phoare [M.jade_hash_sha512x4_amd64_avx2_final :
           ctx = c0 /\ out = d0 ==>
           (BArray784.get64d c0 0 <> sha2_tag 10 => res.`3 = W64.one /\ res.`1 = c0 /\ res.`2 = d0) /\
           (sha512_x4_ctx h0 ms0 c0 =>
              res.`3 = W64.zero /\
              (forall k, 0 <= k < 4 =>
                 take 64 (drop (64 * k) (BArray256.to_list res.`2))
                 = flatten (map w64_be (SHA512.hash h0 (ms0 k)))) /\
              forall i, 0 <= i < 784 => BArray784.get8 res.`1 i = W8.zero)] = 1%r.
proof. by proc; call (sha512_x4_ctx_final_total c0 d0 h0 ms0); auto. qed.
