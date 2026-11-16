(*
 * SafetyCtxX.ec
 * =============
 *
 * Safety of the multi-way incremental contexts of context_x.jinc.
 * Both contexts are 784 bytes: the header (tag and
 * total) in bytes 0 to 15, the interleaved state in bytes 16 to 271
 * and the lane buffers in bytes 272 to 783. The front ends enter
 * through SafetyMulti, the header through SafetyCtx.
 *)

require import AllCore IntDiv CoreMap List Distr.
from Jasmin require import JWord JUtils JMemory Jcheck JSafety.
require import SafetyEclib.
require import SafetyLib SafetyMask SafetySub SafetyFill SafetyKX8 SafetyKX4.
require import SafetySha256 SafetySha512 SafetyCtx SafetyMulti.
require import BArray16 BArray32 BArray64 BArray112 BArray128 BArray208 BArray256 BArray512.
require import BArray784 Jsha2_safety.
require import SBArray112_16 SBArray112_32 SBArray112_64 SBArray208_16 SBArray208_64.
require import SBArray208_128 SBArray512_64 SBArray512_128 SBArray784_16 SBArray784_256.
require import SBArray784_512.

(* ------------------------------------------------------------------ *)
(* Context masks                                                      *)

lemma mask784_set64d (m : BArray784.t) k :
  BArray784.is_init m 0 k => 0 <= k => k + 8 <= 784 =>
  BArray784.is_init (BArray784.set64d m k (W64.of_int 18446744073709551615)) 0 (k + 8).
proof.
move=> hm hk hb j hj0 hj; rewrite BArray784.is_init_cell_set64d.
by case: (j < k) => hjk; [right; apply hm | left] => /#.
qed.

(* A header followed by a whole state and whole buffers. *)
lemma ctx784_store (m : BArray784.t) (a : BArray256.t) (b : BArray512.t) l :
  BArray784.is_init m 0 16 => BArray256.is_init a 0 256 => BArray512.is_init b 0 l =>
  0 <= l <= 512 =>
  BArray784.is_init (SBArray784_512.set_sub (SBArray784_256.set_sub m 16 a) 272 b) 0 (272 + l).
proof.
move=> hm ha hb hl j hj0 hj1; rewrite SBArray784_512.is_init_cell_set.
case: (272 <= j < 272 + 512) => h2; 1: by rewrite ifT 1:/#; apply hb => /#.
rewrite ifF 1:/# SBArray784_256.is_init_cell_set.
case: (16 <= j < 16 + 256) => h1; 1: by rewrite ifT 1:/#; apply ha => /#.
by rewrite ifF 1:/#; apply hm => /#.
qed.

lemma ctx784_hs (m : BArray784.t) (a : BArray256.t) :
  BArray784.is_init m 0 16 => BArray256.is_init a 0 256 =>
  BArray784.is_init (SBArray784_256.set_sub m 16 a) 0 272.
proof.
move=> hm ha j hj0 hj1; rewrite SBArray784_256.is_init_cell_set.
case: (16 <= j < 16 + 256) => h1; 1: by rewrite ifT 1:/#; apply ha => /#.
by rewrite ifF 1:/#; apply hm => /#.
qed.

lemma ctx784_header (m : BArray784.t) :
  BArray784.is_init (BArray784.set64d (BArray784.set64d m 0 (W64.of_int 18446744073709551615)) 8
    (W64.of_int 18446744073709551615)) 0 16.
proof.
have h0 := mask784_set64d m 0 _ _ _; 1..3: by move=> // j /#.
exact (mask784_set64d _ 8 h0 _ _).
qed.

lemma ctx784_h : SBArray784_256.get_sub full784 16 = full256.
proof. by apply full256E; apply (sub784_256_get _ 16 0 256) => //; exact full784_init. qed.

lemma ctx784_buf : SBArray784_512.get_sub full784 272 = full512.
proof. by apply full512E; apply (sub784_512_get _ 272 0 512) => //; exact full784_init. qed.

lemma ctx784_head : BArray16.is_init (SBArray784_16.get_sub full784 0) 0 16.
proof. by apply (sub784_16_get _ 0 0 16) => //; exact full784_init. qed.


(* ------------------------------------------------------------------ *)
(* Eight-way SHA-256 context                                          *)

lemma __sha256_x8_ctx_init_proof _ctx _b_ctx : __sha256_x8_ctx_init_spec _ctx _b_ctx.
proof.
rewrite /__sha256_x8_ctx_init_spec; proc.
while (valid trace___sha256_x8_ctx_init /\ 0 <= i <= 64
       /\ BArray784.is_init b_ctx 0 (272 + 8 * i)).
+ auto => /> &m _ hi0 hi8 hc hlt.
  have hm := mask784_set64d b_ctx{m} (272 + 8 * i{m}) hc _ _; 1,2: smt().
  by rewrite (_ : 272 + 8 * (i{m} + 1) = 272 + 8 * i{m} + 8) 1:/#; smt().
wp; ecall (__sha256_x8_init_proof param_0 b_param).
wp; ecall (__sha2_tag_proof param).
auto => /> r _ r0 h2 _.
split; 1: exact (ctx784_hs _ _ (ctx784_header _b_ctx) (full256_init 0 256)).
by move=> c i0 tr0 hlt _ hi0 hi8 hc; have <- : 272 + 8 * i0 = 784 by smt().
qed.

(* The state of a single-way SHA-256 context, copied into every lane. *)
lemma _sha256_x8_ctx_from_proof _ctx _b_ctx _src _b_src _ms :
  _sha256_x8_ctx_from_spec _ctx _b_ctx _src _b_src _ms.
proof.
rewrite /_sha256_x8_ctx_from_spec; proc; sp.
seq 1 : (valid trace__sha256_x8_ctx_from /\ valid M.tmp__trace /\ b_src = full112).
+ ecall (__sha2_ctx_open_proof param_0 b_param_3 param).
  auto => /> hc; rewrite (full112E _ hc) /=.
  by apply (sub112_16_get _ 0 0 16) => //; exact full112_init.
sp; seq 1 : (valid trace__sha256_x8_ctx_from /\ valid M.tmp__trace /\ b_src = full112).
+ by ecall (__sha2_tag_proof param_1); auto.
sp; if; last first.
+ by auto => />; smt(one_neq_zero).
wp; ecall (__sha256_x8_from_proof param_6 b_param_2 param_5 b_param_1 param_4 b_param_0
             param_3 b_param).
wp; ecall (__sha2_tag_proof param_2).
auto => /> &m tr _ _ r _; rewrite ctx112_h ctx112_buf.
split; 1: by split; [exact full32_init | exact full64_init].
move=> _ _ r0 h3 h4 _.
exact (ctx784_store _ _ _ 512 (ctx784_header _) (full256_init 0 256) (full512_init 0 512) _).
qed.

(* The context stores the lane buffers whole, so their mask is the full
   mask on entry; the absorb contract only promises the buffered
   prefix of each lane. A full buffer mask stays full. *)
lemma get512_64_full k : 0 <= k < 8 => SBArray512_64.get_sub full512 (64 * k) = full64.
proof.
by move=> hk; apply full64E; apply (sub512_64_get _ _ 0 64) => //;
  [exact full512_init | smt() | smt()].
qed.

lemma set512_64_full k : 0 <= k < 8 => SBArray512_64.set_sub full512 (64 * k) full64 = full512.
proof.
move=> hk; apply full512E => j hj0 hj1; rewrite SBArray512_64.is_init_cell_set.
case: (64 * k <= j < 64 * k + 64) => hj.
+ by rewrite ifT 1:/#; apply (full64_init 0 64) => /#.
by rewrite ifF 1:/#; apply (full512_init 0 512).
qed.

lemma _sha256_x8_absorb_lanes_fullm :
  hoare [M._sha256_x8_absorb_lanes : b_buf = full512 ==> res.`4 = full512].
proof.
proc; sp; seq 1 : (b_buf = full512).
+ while (b_buf = full512 /\ 0 <= k <= 8); 2: by auto.
  wp; call __fill64_mem_full; auto => /> &m hk0 hk8 hlt.
  by rewrite get512_64_full 1:/# /= => r ->; rewrite set512_64_full 1:/#; smt().
sp; seq 1 : (b_buf = full512).
+ by if; [wp; call (: true ==> true) => //; auto | auto].
sp; seq 1 : (b_buf = full512).
+ by if; [wp; call (: true ==> true) => //; auto | auto].
sp; wp; while (b_buf = full512 /\ 0 <= k <= 8); 2: by auto.
wp; call __fill64_mem_full; auto => /> &m hk0 hk8 hlt.
by rewrite get512_64_full 1:/# /= => r ->; rewrite set512_64_full 1:/#; smt().
qed.

lemma _sha256_x8_absorb_lanes_full _h _b_h _buf _total _in _inlen _ms :
  hoare [M._sha256_x8_absorb_lanes :
    (_ms = ms /\ _inlen = inlen /\ full64 = b_in /\ _in = in_0 /\ _total = total
     /\ full512 = b_buf /\ _buf = buf /\ _b_h = b_h /\ _h = h)
    /\ BArray256.is_init _b_h 0 256
    /\ _inlen \ult W64.of_int 2305843009213693952
    /\ lanes_valid Glob.mem_v 8 (fun i => to_uint (BArray64.get64 _in i)) (to_uint _inlen)
    ==> res.`2 = full256 /\ res.`4 = full512 /\ res.`5 = _total + _inlen /\ valid res.`7].
proof.
have := _sha256_x8_absorb_lanes_proof _h _b_h _buf full512 _total _in full64 _inlen _ms.
rewrite /_sha256_x8_absorb_lanes_spec => ha.
conseq ha _sha256_x8_absorb_lanes_fullm => />.
+ move=> &m _ _ _ _ _ hb _ _ _ hh hlt hlv; have := lanes_valid8E _ _ _ hlv.
  rewrite -hb /is_valid /= => [#] *.
  by do !split => //; try apply full64_init; try apply full512_init;
    try (move=> i h1 h2; smt()); smt().
by move=> &m _ _ _ _ _ _ _ _ _ _ _ _ r h2 *; exact (full256E _ h2).
qed.

(* The length room is below 2^61, so an accepted update length is too. *)
lemma __sha2_room_bound :
  hoare [M.__sha2_room : true ==> to_uint res.`1 <= 2305843009213693952 /\ valid res.`2].
proof.
proc; auto => /> &m; case: (total{m} \ult W64.of_int 2305843009213693952) => h; last by rewrite W64.to_uint0.
have hle : W64.to_uint total{m} < 2305843009213693952 by move: h; rewrite W64.ultE.
rewrite W64.to_uintB; 1: by rewrite W64.uleE /= /#.
by smt(W64.to_uint_cmp).
qed.

lemma ctx784_full : SBArray784_512.set_sub (SBArray784_256.set_sub full784 16 full256) 272 full512
                    = full784.
proof. by apply full784E; apply (ctx784_store _ _ _ 512); [exact full784_init | exact full256_init | exact full512_init | done]. qed.

lemma _sha256_x8_ctx_update_proof _ctx _b_ctx _in _b_in _inlen _ms :
  _sha256_x8_ctx_update_spec _ctx _b_ctx _in _b_in _inlen _ms.
proof.
rewrite /_sha256_x8_ctx_update_spec; proc; sp.
seq 1 : (valid trace__sha256_x8_ctx_update /\ valid M.tmp__trace /\ b_ctx = full784
         /\ lanes_valid Glob.mem_v 8 (fun i => to_uint (BArray64.get64 in_0 i)) (to_uint inlen)).
+ ecall (__sha2_ctx_open_proof param_0 b_param_1 param).
  auto => /> &m _ _ _ _ _ _ _ _ hc *.
  rewrite (full784E _ hc) ctx784_head /= => r _.
  by apply lanes_valid8; rewrite /is_valid /=; do !split => //.
sp; seq 1 : (valid trace__sha256_x8_ctx_update /\ valid M.tmp__trace /\ b_ctx = full784
             /\ lanes_valid Glob.mem_v 8 (fun i => to_uint (BArray64.get64 in_0 i)) (to_uint inlen)).
+ by ecall (__sha2_tag_proof param_1); auto.
sp; if; last by auto => />; rewrite ?full784_init.
sp; seq 1 : (valid trace__sha256_x8_ctx_update /\ valid M.tmp__trace /\ b_ctx = full784
             /\ lanes_valid Glob.mem_v 8 (fun i => to_uint (BArray64.get64 in_0 i)) (to_uint inlen)
             /\ to_uint result_2 <= 2305843009213693952).
+ by ecall (__sha2_room_bound); auto.
sp; if; last by auto => />; rewrite ?full784_init.
wp; ecall (_sha256_x8_absorb_lanes_full param_8 b_param_0 param_7 param_6 param_5 param_4 param_3).
auto => /> &m tr _ _ hlv hr hlt; rewrite ctx784_h ctx784_buf /=.
split; 1: by split; [exact full256_init | move: hlt; rewrite !W64.ultE /#].
move=> _ _ r -> -> -> _.
by rewrite ctx784_full full784_set64d full784_init full256_init !full512_init.
qed.

lemma _sha256_x8_ctx_final_proof _ctx _b_ctx _out _b_out _ms :
  _sha256_x8_ctx_final_spec _ctx _b_ctx _out _b_out _ms.
proof.
rewrite /_sha256_x8_ctx_final_spec; proc; sp.
seq 1 : (valid trace__sha256_x8_ctx_final /\ valid M.tmp__trace /\ b_ctx = full784).
+ ecall (__sha2_ctx_open_proof param_0 b_param_2 param).
  by auto => /> hc; rewrite (full784E _ hc) ctx784_head.
sp; seq 1 : (valid trace__sha256_x8_ctx_final /\ valid M.tmp__trace /\ b_ctx = full784).
+ by ecall (__sha2_tag_proof param_1); auto.
sp; if; last by auto => />; smt(one_neq_zero full784_init).
wp; while (valid trace__sha256_x8_ctx_final /\ 0 <= i <= 98
           /\ b_ctx = full784 /\ BArray256.is_init b_out 0 256).
+ by auto => /> &m *; rewrite full784_set64d; smt().
wp; ecall (_sha256_x8_finalize_proof param_6 b_param_1 param_5 b_param_0 param_4 b_param
             param_3 param_2).
auto => /> &m tr _ _; rewrite ctx784_h ctx784_buf.
split; 1: by rewrite !full512_init full256_init.
move=> _ _ _ _ _ _ _ _ _ r h5 h6 h7 _.
by rewrite ctx784_full full256_init /= => *; exact (full784_init 0 784).
qed.

(* ------------------------------------------------------------------ *)
(* Four-way SHA-512 context                                            *)

lemma __sha512_x4_ctx_init_proof _ctx _b_ctx : __sha512_x4_ctx_init_spec _ctx _b_ctx.
proof.
rewrite /__sha512_x4_ctx_init_spec; proc.
while (valid trace___sha512_x4_ctx_init /\ 0 <= i <= 64
       /\ BArray784.is_init b_ctx 0 (272 + 8 * i)).
+ auto => /> &m _ hi0 hi8 hc hlt.
  have hm := mask784_set64d b_ctx{m} (272 + 8 * i{m}) hc _ _; 1,2: smt().
  by rewrite (_ : 272 + 8 * (i{m} + 1) = 272 + 8 * i{m} + 8) 1:/#; smt().
wp; ecall (__sha512_x4_init_proof param_0 b_param).
wp; ecall (__sha2_tag_proof param).
auto => /> r _ r0 h2 _.
split; 1: exact (ctx784_hs _ _ (ctx784_header _b_ctx) (full256_init 0 256)).
by move=> c i0 tr0 hlt _ hi0 hi8 hc; have <- : 272 + 8 * i0 = 784 by smt().
qed.

(* The state of a single-way SHA-512 context, copied into every lane. *)
lemma _sha512_x4_ctx_from_proof _ctx _b_ctx _src _b_src _ms :
  _sha512_x4_ctx_from_spec _ctx _b_ctx _src _b_src _ms.
proof.
rewrite /_sha512_x4_ctx_from_spec; proc; sp.
seq 1 : (valid trace__sha512_x4_ctx_from /\ valid M.tmp__trace /\ b_src = full208).
+ ecall (__sha2_ctx_open_proof param_0 b_param_3 param).
  auto => /> hc; rewrite (full208E _ hc) /=.
  by apply (sub208_16_get _ 0 0 16) => //; exact full208_init.
sp; seq 1 : (valid trace__sha512_x4_ctx_from /\ valid M.tmp__trace /\ b_src = full208).
+ by ecall (__sha2_tag_proof param_1); auto.
sp; if; last first.
+ by auto => />; smt(one_neq_zero).
wp; ecall (__sha512_x4_from_proof param_6 b_param_2 param_5 b_param_1 param_4 b_param_0
             param_3 b_param).
wp; ecall (__sha2_tag_proof param_2).
auto => /> &m tr _ _ r _; rewrite ctx208_h ctx208_buf.
split; 1: by split; [exact full64_init | exact full128_init].
move=> _ _ r0 h3 h4 _.
exact (ctx784_store _ _ _ 512 (ctx784_header _) (full256_init 0 256) (full512_init 0 512) _).
qed.

(* The context stores the lane buffers whole, so their mask is the full
   mask on entry; the absorb contract only promises the buffered
   prefix of each lane. A full buffer mask stays full. *)
lemma get512_128_full k : 0 <= k < 4 => SBArray512_128.get_sub full512 (128 * k) = full128.
proof.
by move=> hk; apply full128E; apply (sub512_128_get _ _ 0 128) => //;
  [exact full512_init | smt() | smt()].
qed.

lemma set512_128_full k : 0 <= k < 4 => SBArray512_128.set_sub full512 (128 * k) full128 = full512.
proof.
move=> hk; apply full512E => j hj0 hj1; rewrite SBArray512_128.is_init_cell_set.
case: (128 * k <= j < 128 * k + 128) => hj.
+ by rewrite ifT 1:/#; apply (full128_init 0 128) => /#.
by rewrite ifF 1:/#; apply (full512_init 0 512).
qed.

lemma _sha512_x4_absorb_lanes_fullm :
  hoare [M._sha512_x4_absorb_lanes : b_buf = full512 ==> res.`4 = full512].
proof.
proc; sp; seq 1 : (b_buf = full512).
+ while (b_buf = full512 /\ 0 <= k <= 4); 2: by auto.
  wp; call __fill128_mem_full; auto => /> &m hk0 hk8 hlt.
  by rewrite get512_128_full 1:/# /= => r ->; rewrite set512_128_full 1:/#; smt().
sp; seq 1 : (b_buf = full512).
+ by if; [wp; call (: true ==> true) => //; auto | auto].
sp; seq 1 : (b_buf = full512).
+ by if; [wp; call (: true ==> true) => //; auto | auto].
sp; wp; while (b_buf = full512 /\ 0 <= k <= 4); 2: by auto.
wp; call __fill128_mem_full; auto => /> &m hk0 hk8 hlt.
by rewrite get512_128_full 1:/# /= => r ->; rewrite set512_128_full 1:/#; smt().
qed.

lemma _sha512_x4_absorb_lanes_full _h _b_h _buf _total _in _inlen _ms :
  hoare [M._sha512_x4_absorb_lanes :
    (_ms = ms /\ _inlen = inlen /\ full32 = b_in /\ _in = in_0 /\ _total = total
     /\ full512 = b_buf /\ _buf = buf /\ _b_h = b_h /\ _h = h)
    /\ BArray256.is_init _b_h 0 256
    /\ _inlen \ult W64.of_int 2305843009213693952
    /\ lanes_valid Glob.mem_v 4 (fun i => to_uint (BArray32.get64 _in i)) (to_uint _inlen)
    ==> res.`2 = full256 /\ res.`4 = full512 /\ res.`5 = _total + _inlen /\ valid res.`7].
proof.
have := _sha512_x4_absorb_lanes_proof _h _b_h _buf full512 _total _in full32 _inlen _ms.
rewrite /_sha512_x4_absorb_lanes_spec => ha.
conseq ha _sha512_x4_absorb_lanes_fullm => />.
+ move=> &m _ _ _ _ _ hb _ _ _ hh hlt hlv; have := lanes_valid4E _ _ _ hlv.
  rewrite -hb /is_valid /= => [#] *.
  by do !split => //; try apply full32_init; try apply full512_init;
    try (move=> i h1 h2; smt()); smt().
by move=> &m _ _ _ _ _ _ _ _ _ _ _ _ r h2 *; exact (full256E _ h2).
qed.

lemma _sha512_x4_ctx_update_proof _ctx _b_ctx _in _b_in _inlen _ms :
  _sha512_x4_ctx_update_spec _ctx _b_ctx _in _b_in _inlen _ms.
proof.
rewrite /_sha512_x4_ctx_update_spec; proc; sp.
seq 1 : (valid trace__sha512_x4_ctx_update /\ valid M.tmp__trace /\ b_ctx = full784
         /\ lanes_valid Glob.mem_v 4 (fun i => to_uint (BArray32.get64 in_0 i)) (to_uint inlen)).
+ ecall (__sha2_ctx_open_proof param_0 b_param_1 param).
  auto => /> &m _ _ _ _ hc *.
  rewrite (full784E _ hc) ctx784_head /= => r _.
  by apply lanes_valid4; rewrite /is_valid /=; do !split => //.
sp; seq 1 : (valid trace__sha512_x4_ctx_update /\ valid M.tmp__trace /\ b_ctx = full784
             /\ lanes_valid Glob.mem_v 4 (fun i => to_uint (BArray32.get64 in_0 i)) (to_uint inlen)).
+ by ecall (__sha2_tag_proof param_1); auto.
sp; if; last by auto => />; rewrite ?full784_init.
sp; seq 1 : (valid trace__sha512_x4_ctx_update /\ valid M.tmp__trace /\ b_ctx = full784
             /\ lanes_valid Glob.mem_v 4 (fun i => to_uint (BArray32.get64 in_0 i)) (to_uint inlen)
             /\ to_uint result_2 <= 2305843009213693952).
+ by ecall (__sha2_room_bound); auto.
sp; if; last by auto => />; rewrite ?full784_init.
wp; ecall (_sha512_x4_absorb_lanes_full param_8 b_param_0 param_7 param_6 param_5 param_4 param_3).
auto => /> &m tr _ _ hlv hr hlt; rewrite ctx784_h ctx784_buf /=.
split; 1: by split; [exact full256_init | move: hlt; rewrite !W64.ultE /#].
move=> _ _ r -> -> -> _.
by rewrite ctx784_full full784_set64d full784_init full256_init !full512_init.
qed.

lemma _sha512_x4_ctx_final_proof _ctx _b_ctx _out _b_out _ms :
  _sha512_x4_ctx_final_spec _ctx _b_ctx _out _b_out _ms.
proof.
rewrite /_sha512_x4_ctx_final_spec; proc; sp.
seq 1 : (valid trace__sha512_x4_ctx_final /\ valid M.tmp__trace /\ b_ctx = full784).
+ ecall (__sha2_ctx_open_proof param_0 b_param_2 param).
  by auto => /> hc; rewrite (full784E _ hc) ctx784_head.
sp; seq 1 : (valid trace__sha512_x4_ctx_final /\ valid M.tmp__trace /\ b_ctx = full784).
+ by ecall (__sha2_tag_proof param_1); auto.
sp; if; last by auto => />; smt(one_neq_zero full784_init).
wp; while (valid trace__sha512_x4_ctx_final /\ 0 <= i <= 98
           /\ b_ctx = full784 /\ BArray256.is_init b_out 0 256).
+ by auto => /> &m *; rewrite full784_set64d; smt().
wp; ecall (_sha512_x4_finalize_proof param_6 b_param_1 param_5 b_param_0 param_4 b_param
             param_3 param_2).
auto => /> &m tr _ _; rewrite ctx784_h ctx784_buf.
split; 1: by rewrite !full512_init full256_init.
move=> _ _ _ _ _ r h5 h6 h7 _.
by rewrite ctx784_full full256_init /= => *; exact (full784_init 0 784).
qed.
