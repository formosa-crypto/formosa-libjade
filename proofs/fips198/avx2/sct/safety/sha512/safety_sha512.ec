(*
 * sha512, target avx2, profile sct: every entry point of HMAC-SHA-512 meets
 * its contract (<entry point>_spec of the safety model): from initialised
 * inputs, every safety check of the run holds and the outputs are
 * initialised.
 *)

require import AllCore IntDiv CoreMap List Distr.
from Jasmin require import JWord JUtils JMemory Jcheck JSafety.
require import SafetyLib SafetyMask SafetySub SafetyFill SafetyK256 SafetyK512 SafetySha256 SafetySha512 SafetyHmac SafetyCtx.
require import BArray16 BArray28 BArray32 BArray48 BArray64 BArray112 BArray128 BArray144 BArray208 BArray256 BArray272 BArray512.
require import SBArray144_112 SBArray272_208.
require import Jsha2_safety.

lemma jade_mac_hmac_sha512_amd64_avx2_proof _out _b_out _key _keylen _msg _msglen :
  jade_mac_hmac_sha512_amd64_avx2_spec _out _b_out _key _keylen _msg _msglen.
proof.
rewrite /jade_mac_hmac_sha512_amd64_avx2_spec; proc.
wp; ecall (_hmac_sha512_mem_proof param_4 b_param param_3 param_2 param_1 param_0 param).
by auto => /> *; exact (full64_init 0 64).
qed.

lemma jade_mac_hmac_sha512_amd64_avx2_init_proof _ctx _b_ctx _key _keylen :
  jade_mac_hmac_sha512_amd64_avx2_init_spec _ctx _b_ctx _key _keylen.
proof.
rewrite /jade_mac_hmac_sha512_amd64_avx2_init_spec; proc.
wp; ecall (__hmac_sha512_ctx_init_proof param_2 b_param param_1 param_0 param).
by auto => /> *; exact (full272_init 0 272).
qed.

(* The inner SHA-512 context is the first 208 bytes of the HMAC context. *)
lemma jade_mac_hmac_sha512_amd64_avx2_update_proof _ctx _b_ctx _in _inlen :
  jade_mac_hmac_sha512_amd64_avx2_update_spec _ctx _b_ctx _in _inlen.
proof.
rewrite /jade_mac_hmac_sha512_amd64_avx2_update_spec; proc.
wp; ecall (_sha512_ctx_update_proof param_4 b_param param_3 param_2 param_1 param_0).
wp; ecall (__sha2_tag_proof param).
auto => /> &m hc *; rewrite (full272E _ hc); split.
+ by apply (sub272_208_get _ 0 0 208) => //; exact full272_init.
by move=> _ r h4 _; rewrite (set_sub272_208_full full208 (full208_init 0 208)); exact (full272_init 0 272).
qed.

lemma jade_mac_hmac_sha512_amd64_avx2_final_proof _ctx _b_ctx _out _b_out :
  jade_mac_hmac_sha512_amd64_avx2_final_spec _ctx _b_ctx _out _b_out.
proof.
rewrite /jade_mac_hmac_sha512_amd64_avx2_final_spec; proc.
wp; ecall (__hmac_sha512_ctx_final_proof param_1 (BArray272.init_arr (W8.of_int 255)) param_0 b_param param).
by auto => /> *; exact (full272_init 0 272).
qed.
