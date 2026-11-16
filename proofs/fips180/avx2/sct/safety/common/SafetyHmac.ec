(*
 * SafetyHmac.ec
 * =============
 *
 * Safety of HMAC-SHA-256 and HMAC-SHA-512 of hmac.jinc: the key
 * block for keys of any length, the inner and outer initial states, the
 * outer hash and the one-shot functions. The hashes enter through
 * SafetySha256 and SafetySha512.
 *)

require import AllCore IntDiv CoreMap List Distr.
from Jasmin require import JWord JUtils JMemory Jcheck JSafety.
require import SafetyEclib.
require import SafetyLib SafetyMask SafetySub SafetyFill SafetyK256 SafetyK512.
require import SafetySha256 SafetySha512.
require import BArray32 BArray64 BArray128 Jsha2_safety.

(* ------------------------------------------------------------------ *)
(* Key block                                                          *)

lemma _hmac_sha256_keyblock_mem_proof _k0 _b_k0 _key _keylen _ms :
  _hmac_sha256_keyblock_mem_spec _k0 _b_k0 _key _keylen _ms.
proof.
rewrite /_hmac_sha256_keyblock_mem_spec; proc; sp.
seq 1 : (valid trace__hmac_sha256_keyblock_mem
         /\ to_uint i <= 64 /\ BArray64.is_init b_k0 0 (to_uint i)).
+ if.
  + wp; while (valid trace__hmac_sha256_keyblock_mem /\ 0 <= j <= 4
               /\ BArray64.is_init b_k0 0 (8 * j)).
    + auto => /> &m _ hj0 hj4 hk hlt.
      have hm := mask64_set64 b_k0{m} j{m} hk _ _; 1,2: smt().
      by rewrite (mulzC j{m} 8) hm /=; smt().
    wp; ecall (_sha256_mem_proof param_2 b_param_0 param_1 param_0 param); auto => /> &m.
    by move=> *; split; [move=> j /# | move=> *; smt()].
  wp; ecall (__fill64_mem_proof param_7 b_param_1 param_6 param_5 param_4 param_3); auto => /> &m.
  move=> hv hp0 hpl; rewrite !W64.ultE !W64.uleE /= => hl.
  by split; [do !split => //; try (move=> j /#); smt() | smt()].
wp; ecall (__zero64_proof param_11 b_param param_10 param_9 param_8); auto => /> &m _ hi hk.
by rewrite !W64.uleE /= hi.
qed.
lemma _hmac_sha512_keyblock_mem_proof _k0 _b_k0 _key _keylen _ms :
  _hmac_sha512_keyblock_mem_spec _k0 _b_k0 _key _keylen _ms.
proof.
rewrite /_hmac_sha512_keyblock_mem_spec; proc; sp.
seq 1 : (valid trace__hmac_sha512_keyblock_mem
         /\ to_uint i <= 128 /\ BArray128.is_init b_k0 0 (to_uint i)).
+ if.
  + wp; while (valid trace__hmac_sha512_keyblock_mem /\ 0 <= j <= 8
               /\ BArray128.is_init b_k0 0 (8 * j)).
    + auto => /> &m _ hj0 hj4 hk hlt.
      have hm := mask128_set64 b_k0{m} j{m} hk _ _; 1,2: smt().
      by rewrite (mulzC j{m} 8) hm /=; smt().
    wp; ecall (_sha512_mem_proof param_2 b_param_0 param_1 param_0 param); auto => /> &m.
    by move=> *; split; [move=> j /# | move=> *; smt()].
  wp; ecall (__fill128_mem_proof param_7 b_param_1 param_6 param_5 param_4 param_3); auto => /> &m.
  move=> hv hp0 hpl; rewrite !W64.ultE !W64.uleE /= => hl.
  by split; [do !split => //; try (move=> j /#); smt() | smt()].
wp; ecall (__zero128_proof param_11 b_param param_10 param_9 param_8); auto => /> &m _ hi hk.
by rewrite !W64.uleE /= hi.
qed.

(* ------------------------------------------------------------------ *)
(* Inner and outer initial states                                     *)

lemma __hmac_sha256_init_proof _inner _b_inner _outer _b_outer _k0 _b_k0 _ms :
  __hmac_sha256_init_spec _inner _b_inner _outer _b_outer _k0 _b_k0 _ms.
proof.
rewrite /__hmac_sha256_init_spec; proc.
wp; ecall (_sha256_compress_proof param_6 full32 param_5 b_param param_4).
wp; ecall (__sha256_init_proof param_3 b_param_0).
wp; ecall (_sha256_compress_proof param_2 full32 param_1 b_param_1 param_0).
wp; ecall (__sha256_init_proof param b_param_2).
wp; while (valid trace___hmac_sha256_init /\ 0 <= i <= 8
       /\ BArray64.is_init b_ipad 0 (8 * i) /\ BArray64.is_init b_opad 0 (8 * i)).
+ auto => /> &m _ hi0 hi8 hp ho hlt.
  have h1 := mask64_set64 b_ipad{m} i{m} hp _ _; 1,2: smt().
  have h2 := mask64_set64 b_opad{m} i{m} ho _ _; 1,2: smt().
  by rewrite (mulzC i{m} 8) h1 h2 /=; smt().
auto => /> hk; split; 1: by split; move=> j /#.
move=> ip0 op0 i0 _ hi _ hi0 hi8 hp ho; have e : 8 * i0 = 64 by smt().
move: hp ho; rewrite e => hp ho r _ _.
by split; [split; [exact (full32_init 0 32) | done] | move=> _ _ r1 _ _ r2 _ _; exact ho].
qed.

lemma __hmac_sha512_init_proof _inner _b_inner _outer _b_outer _k0 _b_k0 _ms :
  __hmac_sha512_init_spec _inner _b_inner _outer _b_outer _k0 _b_k0 _ms.
proof.
rewrite /__hmac_sha512_init_spec; proc.
wp; ecall (_sha512_compress_proof param_6 full64 param_5 b_param param_4).
wp; ecall (__sha512_init_proof param_3 b_param_0).
wp; ecall (_sha512_compress_proof param_2 full64 param_1 b_param_1 param_0).
wp; ecall (__sha512_init_proof param b_param_2).
wp; while (valid trace___hmac_sha512_init /\ 0 <= i <= 16
       /\ BArray128.is_init b_ipad 0 (8 * i) /\ BArray128.is_init b_opad 0 (8 * i)).
+ auto => /> &m _ hi0 hi8 hp ho hlt.
  have h1 := mask128_set64 b_ipad{m} i{m} hp _ _; 1,2: smt().
  have h2 := mask128_set64 b_opad{m} i{m} ho _ _; 1,2: smt().
  by rewrite (mulzC i{m} 8) h1 h2 /=; smt().
auto => /> hk; split; 1: by split; move=> j /#.
move=> ip0 op0 i0 _ hi _ hi0 hi8 hp ho; have e : 8 * i0 = 128 by smt().
move: hp ho; rewrite e => hp ho r _ _.
by split; [split; [exact (full64_init 0 64) | done] | move=> _ _ r1 _ _ r2 _ _; exact ho].
qed.

(* ------------------------------------------------------------------ *)
(* Outer hash                                                         *)

lemma __hmac_sha256_outer_proof _inner _b_inner _buf _b_buf _total _outer _b_outer _ms :
  __hmac_sha256_outer_spec _inner _b_inner _buf _b_buf _total _outer _b_outer _ms.
proof.
rewrite /__hmac_sha256_outer_spec; proc.
wp; while (valid trace___hmac_sha256_outer /\ 0 <= i <= 4).
+ by auto => /> &m _ hi0 hi4 hlt; smt().
wp; while (valid trace___hmac_sha256_outer /\ 0 <= i <= 8).
+ by auto => /> &m _ hi0 hi8 hlt; smt().
wp; ecall (_sha256___sha256_finalize_proof param_3 b_param_0 param_2 full32 param_1 b_param
             param_0 param).
auto => /> &m hb _; split; 1: exact (full32_init 0 32).
by move=> *; exact (full64_init 0 32).
qed.

lemma __hmac_sha256_finalize_proof _out _b_out _inner _b_inner _buf _b_buf _total _outer _b_outer _ms :
  __hmac_sha256_finalize_spec _out _b_out _inner _b_inner _buf _b_buf _total _outer _b_outer _ms.
proof.
rewrite /__hmac_sha256_finalize_spec; proc.
wp; ecall (_sha256___sha256_finalize_proof param_8 b_param_0 param_7 full32 param_6 b_param
             param_5 param_4).
wp; ecall (__hmac_sha256_outer_proof param_3 full32 param_2 b_param_1 param_1 param_0 full32 param).
auto => /> &m _ _; split; 1: by split; exact (full32_init 0 32).
move=> _ r _ h4 -> _.
by rewrite umodc // W64.to_uint_small.
qed.

lemma __hmac_sha512_outer_proof _inner _b_inner _buf _b_buf _total _outer _b_outer _ms :
  __hmac_sha512_outer_spec _inner _b_inner _buf _b_buf _total _outer _b_outer _ms.
proof.
rewrite /__hmac_sha512_outer_spec; proc.
wp; while (valid trace___hmac_sha512_outer /\ 0 <= i <= 8).
+ by auto => /> &m _ hi0 hi4 hlt; smt().
wp; while (valid trace___hmac_sha512_outer /\ 0 <= i <= 8).
+ by auto => /> &m _ hi0 hi8 hlt; smt().
wp; ecall (_sha512___sha512_finalize_proof param_3 b_param_0 param_2 full64 param_1 b_param
             param_0 param).
auto => /> &m hb _; split; 1: exact (full64_init 0 64).
by move=> *; exact (full128_init 0 64).
qed.

lemma __hmac_sha512_finalize_proof _out _b_out _inner _b_inner _buf _b_buf _total _outer _b_outer _ms :
  __hmac_sha512_finalize_spec _out _b_out _inner _b_inner _buf _b_buf _total _outer _b_outer _ms.
proof.
rewrite /__hmac_sha512_finalize_spec; proc.
wp; ecall (_sha512___sha512_finalize_proof param_8 b_param_0 param_7 full64 param_6 b_param
             param_5 param_4).
wp; ecall (__hmac_sha512_outer_proof param_3 full64 param_2 b_param_1 param_1 param_0 full64 param).
auto => /> &m _ _; split; 1: by split; exact (full64_init 0 64).
move=> _ r _ h4 -> _.
by rewrite umodc // W64.to_uint_small.
qed.

(* ------------------------------------------------------------------ *)
(* One-shot HMAC                                                      *)

lemma _hmac_sha256_mem_proof _out _b_out _key _keylen _msg _msglen _ms :
  _hmac_sha256_mem_spec _out _b_out _key _keylen _msg _msglen _ms.
proof.
rewrite /_hmac_sha256_mem_spec; proc.
wp; ecall (_sha256___sha256_finalize_proof param_22 b_param_0 param_21 full32 param_20 b_param
             param_19 param_18).
wp; ecall (__hmac_sha256_outer_proof param_17 full32 param_16 b_param_1 param_15 param_14 full32
             param_13).
wp; ecall (_sha256_absorb_mem_proof param_12 full32 param_11 b_param_2 param_10 param_9 param_8
             param_7).
wp; ecall (__hmac_sha256_init_proof param_6 b_param_4 param_5 b_param_3 param_4 full64 param_3).
wp; ecall (_hmac_sha256_keyblock_mem_proof param_2 b_param_5 param_1 param_0 param).
auto => /> &m _ _ _ hm _ _ r _ _; split; 1: exact (full64_init 0 64).
move=> _ r0 _ _ _; rewrite /protect_64 umodc // W64.to_uint_small //=.
split; 1: by split; [split; [exact (full32_init 0 32) | move=> j /#] | move=> j h1 h2; apply hm].
move=> _ _ _ _ _ r1 _ _ _ _ r2 _ h4 -> _.
by rewrite umodc // W64.to_uint_small.
qed.

lemma _hmac_sha512_mem_proof _out _b_out _key _keylen _msg _msglen _ms :
  _hmac_sha512_mem_spec _out _b_out _key _keylen _msg _msglen _ms.
proof.
rewrite /_hmac_sha512_mem_spec; proc.
wp; ecall (_sha512___sha512_finalize_proof param_22 b_param_0 param_21 full64 param_20 b_param
             param_19 param_18).
wp; ecall (__hmac_sha512_outer_proof param_17 full64 param_16 b_param_1 param_15 param_14 full64
             param_13).
wp; ecall (_sha512_absorb_mem_proof param_12 full64 param_11 b_param_2 param_10 param_9 param_8
             param_7).
wp; ecall (__hmac_sha512_init_proof param_6 b_param_4 param_5 b_param_3 param_4 full128 param_3).
wp; ecall (_hmac_sha512_keyblock_mem_proof param_2 b_param_5 param_1 param_0 param).
auto => /> &m _ _ _ hm _ _ r _ _; split; 1: exact (full128_init 0 128).
move=> _ r0 _ _ _; rewrite /protect_64 umodc // W64.to_uint_small //=.
split; 1: by split; [split; [exact (full64_init 0 64) | move=> j /#] | move=> j h1 h2; apply hm].
move=> _ _ _ _ _ r1 _ _ _ _ r2 _ h4 -> _.
by rewrite umodc // W64.to_uint_small.
qed.
