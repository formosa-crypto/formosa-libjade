(*
 * sha256x8, target avx2, profile sct: every entry point of the set meets its
 * contract (<entry point>_spec of the safety model): from initialised
 * inputs, every safety check of the run holds and the outputs are
 * initialised.
 *)

require import AllCore IntDiv CoreMap List Distr.
from Jasmin require import JWord JUtils JMemory Jcheck JSafety.
require import SafetyLib SafetyMask SafetySub SafetyFill SafetyKX8 SafetyKX4 SafetySha256 SafetySha512.
require import SafetyCtx SafetyMulti SafetyCtxX.
require import BArray32 BArray64 BArray112 BArray208 BArray256 BArray512 BArray784.
require import Jsha2_safety.

lemma jade_hash_sha256x8_amd64_avx2_proof _out _b_out _in _b_in _len :
  jade_hash_sha256x8_amd64_avx2_spec _out _b_out _in _b_in _len.
proof.
rewrite /jade_hash_sha256x8_amd64_avx2_spec; proc.
wp; ecall (_sha256_x8_lanes_proof param_2 b_param param_1 (BArray64.init_arr (W8.of_int 255)) param_0 param).
auto => /> *; split; 1: by rewrite !full64_init.
by move=> *; exact (full256_init 0 256).
qed.

lemma jade_hash_sha256x8_amd64_avx2_init_proof _ctx _b_ctx :
  jade_hash_sha256x8_amd64_avx2_init_spec _ctx _b_ctx.
proof.
rewrite /jade_hash_sha256x8_amd64_avx2_init_spec; proc.
wp; ecall (__sha256_x8_ctx_init_proof param b_param).
by auto => /> *; exact (full784_init 0 784).
qed.

lemma jade_hash_sha256x8_amd64_avx2_init_from_proof _ctx _b_ctx _src _b_src :
  jade_hash_sha256x8_amd64_avx2_init_from_spec _ctx _b_ctx _src _b_src.
proof.
rewrite /jade_hash_sha256x8_amd64_avx2_init_from_spec; proc.
wp; ecall (_sha256_x8_ctx_from_proof param_1 b_param param_0 (BArray112.init_arr (W8.of_int 255)) param).
by auto => /> *; exact (full112_init 0 112).
qed.

lemma jade_hash_sha256x8_amd64_avx2_update_proof _ctx _b_ctx _in _b_in _inlen :
  jade_hash_sha256x8_amd64_avx2_update_spec _ctx _b_ctx _in _b_in _inlen.
proof.
rewrite /jade_hash_sha256x8_amd64_avx2_update_spec; proc.
wp; ecall (_sha256_x8_ctx_update_proof param_2 (BArray784.init_arr (W8.of_int 255)) param_1
             (BArray64.init_arr (W8.of_int 255)) param_0 param).
by auto => /> *; rewrite !full64_init full784_init.
qed.

lemma jade_hash_sha256x8_amd64_avx2_final_proof _ctx _b_ctx _out _b_out :
  jade_hash_sha256x8_amd64_avx2_final_spec _ctx _b_ctx _out _b_out.
proof.
rewrite /jade_hash_sha256x8_amd64_avx2_final_spec; proc.
wp; ecall (_sha256_x8_ctx_final_proof param_1 (BArray784.init_arr (W8.of_int 255)) param_0 b_param param).
by auto => /> *; exact (full784_init 0 784).
qed.
