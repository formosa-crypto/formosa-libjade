(*
 * SHA-256, target avx2, profile sct: the entry point
 * jade_hash_sha256_amd64_avx2 computes SHA-256 (FIPS 180-4) of the inlen
 * bytes at in, and terminates (total correctness), for a message below
 * 2^61 bytes that does not wrap the address space.
 *)

require import AllCore List IntDiv.
from Jasmin require import JWord JUtils JMemory.
require import BArray32 Jsha2 FIPS180_SHA2.
require JWordList SHA256_Stream.

lemma hash_correct (p0 l0 : W64.t) :
  phoare [M.jade_hash_sha256_amd64_avx2 :
           in_0 = p0 /\ inlen = l0 /\
           W64.to_uint p0 + W64.to_uint l0 < W64.modulus /\ W64.to_uint l0 < 2^61 ==>
           BArray32.to_list res
           = SHA256.sha256 (JWordList.memread Glob.mem (W64.to_uint p0) (W64.to_uint l0))] = 1%r.
proof. by proc; call (SHA256_Stream.sha256_mem_total p0 l0); auto. qed.
