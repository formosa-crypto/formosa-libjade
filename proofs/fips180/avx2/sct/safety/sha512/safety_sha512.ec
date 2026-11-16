(*
 * SHA-512, target avx2, profile sct: the entry point
 * jade_hash_sha512_amd64_avx2 meets its contract
 * (jade_hash_sha512_amd64_avx2_spec of the safety model): from in pointing
 * to inlen valid bytes, every safety check of the run holds and the digest
 * is initialised.
 *)

require import AllCore IntDiv CoreMap List Distr.
from Jasmin require import JWord JUtils JMemory Jcheck JSafety.
require import SafetyLib SafetyMask SafetyFill SafetyK512 SafetySha512.
require import BArray64 Jsha2_safety.

lemma jade_hash_sha512_amd64_avx2_proof _out _b_out _in _inlen :
  jade_hash_sha512_amd64_avx2_spec _out _b_out _in _inlen.
proof.
rewrite /jade_hash_sha512_amd64_avx2_spec; proc.
wp; ecall (_sha512_mem_proof param_2 b_param param_1 param_0 param).
by auto => /> *; exact (full64_init 0 64).
qed.
