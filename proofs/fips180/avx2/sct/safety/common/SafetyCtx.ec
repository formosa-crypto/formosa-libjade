(*
 * SafetyCtx.ec
 * ============
 *
 * Safety of the incremental contexts of ctx.jinc and its sized
 * instances: the context header, the length room, loading and storing
 * the hash state, update and final for the six hashes, and the HMAC
 * contexts. The hashes enter through SafetySha256, SafetySha512 and
 * SafetyHmac.
 *)

require import AllCore IntDiv CoreMap List Distr.
from Jasmin require import JWord JUtils JMemory Jcheck JSafety.
require import SafetyEclib.
require import SafetyLib SafetyMask SafetySub SafetyFill SafetyK256 SafetyK512.
require import SafetySha256 SafetySha512 SafetyHmac.
require import BArray16 BArray28 BArray32 BArray48 BArray64 BArray112 BArray128.
require import BArray144 BArray208 BArray272 Jsha2_safety.
require import SBArray112_16 SBArray112_32 SBArray112_64 SBArray144_112 SBArray144_16.
require import SBArray208_128 SBArray208_16 SBArray208_64 SBArray272_16 SBArray272_208.

(* ------------------------------------------------------------------ *)
(* Context header and length room                                     *)

lemma __sha2_tag_proof _f : __sha2_tag_spec _f.
proof. by rewrite /__sha2_tag_spec; proc; auto. qed.

lemma __sha2_ctx_open_proof _head _b_head _ms :
  __sha2_ctx_open_spec _head _b_head _ms.
proof.
by rewrite /__sha2_ctx_open_spec; proc; auto.
qed.

lemma __sha2_room_proof _total : __sha2_room_spec _total.
proof. by rewrite /__sha2_room_spec; proc; auto. qed.

(* ------------------------------------------------------------------ *)
(* Hash state                                                         *)

lemma __sha256_ctx_load_proof _h _b_h _buf _b_buf _ctx _b_ctx :
  __sha256_ctx_load_spec _h _b_h _buf _b_buf _ctx _b_ctx.
proof.
rewrite /__sha256_ctx_load_spec; proc.
while (valid trace___sha256_ctx_load /\ 0 <= i <= 8 /\ b_ctx = full112
       /\ BArray32.is_init b_h 0 32 /\ BArray64.is_init b_buf 0 (8 * i)).
+ auto => /> &m _ hi0 hi8 hh hb hlt.
  have hm := mask64_set64 b_buf{m} i{m} hb _ _; 1,2: smt().
  by rewrite hm /=; smt().
wp; while (valid trace___sha256_ctx_load /\ 0 <= i <= 8 /\ b_ctx = full112
           /\ BArray32.is_init b_h 0 (4 * i)).
+ auto => /> &m _ hi0 hi8 hh hlt.
  have hm := mask32_set32 b_h{m} i{m} hh _ _; 1,2: smt().
  by rewrite (mulzC i{m} 4) hm /=; smt().
auto => /> hc; split; 1: by split; [exact full112E | move=> j /#].
move=> h0 i0 tr0 hlt _ _ hi8 _ hh; split.
+ by split; [have <- : 4 * i0 = 32 by smt() | move=> j /#].
by move=> b0 i1 tr1 hlt1 _ _ hi1 _ hb; have <- : 8 * i1 = 64 by smt().
qed.

lemma __sha512_ctx_load_proof _h _b_h _buf _b_buf _ctx _b_ctx :
  __sha512_ctx_load_spec _h _b_h _buf _b_buf _ctx _b_ctx.
proof.
rewrite /__sha512_ctx_load_spec; proc.
while (valid trace___sha512_ctx_load /\ 0 <= i <= 16 /\ b_ctx = full208
       /\ BArray64.is_init b_h 0 64 /\ BArray128.is_init b_buf 0 (8 * i)).
+ auto => /> &m _ hi0 hi8 hh hb hlt.
  have hm := mask128_set64 b_buf{m} i{m} hb _ _; 1,2: smt().
  by rewrite hm /=; smt().
wp; while (valid trace___sha512_ctx_load /\ 0 <= i <= 8 /\ b_ctx = full208
           /\ BArray64.is_init b_h 0 (8 * i)).
+ auto => /> &m _ hi0 hi8 hh hlt.
  have hm := mask64_set64 b_h{m} i{m} hh _ _; 1,2: smt().
  by rewrite (mulzC i{m} 8) hm /=; smt().
auto => /> hc; split; 1: by split; [exact full208E | move=> j /#].
move=> h0 i0 tr0 hlt _ _ hi8 _ hh; split.
+ by split; [have <- : 8 * i0 = 64 by smt() | move=> j /#].
by move=> b0 i1 tr1 hlt1 _ _ hi1 _ hb; have <- : 8 * i1 = 128 by smt().
qed.

(* A word written at byte offset k into a mask initialised below k.
   The context layouts place words at offsets that are not multiples
   of the word size of the array index, so the byte-offset form is
   the one the stores need. *)
lemma mask112_set32d (m : BArray112.t) k :
  BArray112.is_init m 0 k => 0 <= k => k + 4 <= 112 =>
  BArray112.is_init (BArray112.set32d m k (W32.of_int 4294967295)) 0 (k + 4).
proof.
move=> hm hk hb j hj0 hj; rewrite BArray112.is_init_cell_set32d.
by case: (j < k) => hjk; [right; apply hm | left] => /#.
qed.

lemma mask112_set64d (m : BArray112.t) k :
  BArray112.is_init m 0 k => 0 <= k => k + 8 <= 112 =>
  BArray112.is_init (BArray112.set64d m k (W64.of_int 18446744073709551615)) 0 (k + 8).
proof.
move=> hm hk hb j hj0 hj; rewrite BArray112.is_init_cell_set64d.
by case: (j < k) => hjk; [right; apply hm | left] => /#.
qed.

lemma __sha256_ctx_init_proof _ctx _b_ctx _h _b_h _tag _total :
  __sha256_ctx_init_spec _ctx _b_ctx _h _b_h _tag _total.
proof.
rewrite /__sha256_ctx_init_spec; proc.
while (valid trace___sha256_ctx_init /\ 0 <= i <= 8
       /\ BArray112.is_init b_ctx 0 (48 + 8 * i)).
+ auto => /> &m _ hi0 hi8 hc hlt.
  have hm := mask112_set64d b_ctx{m} (48 + 8 * i{m}) hc _ _; 1,2: smt().
  by rewrite (_ : 48 + 8 * (i{m} + 1) = 48 + 8 * i{m} + 8) 1:/#; smt().
wp; while (valid trace___sha256_ctx_init /\ 0 <= i <= 8
           /\ BArray32.is_init b_h 0 32 /\ BArray112.is_init b_ctx 0 (16 + 4 * i)).
+ auto => /> &m _ hi0 hi8 hh hc hlt.
  have hm := mask112_set32d b_ctx{m} (16 + 4 * i{m}) hc _ _; 1,2: smt().
  rewrite (_ : 16 + 4 * (i{m} + 1) = 16 + 4 * i{m} + 4) 1:/#.
  have hw : BArray32.is_init b_h{m} (i{m} * 4) 4 by move=> j hj0 hj1; apply hh => /#.
  by smt().
auto => /> hh.
have h0 := mask112_set64d _b_ctx 0 _ _ _; 1..3: by move=> // j /#.
have h8 := mask112_set64d _ 8 h0 _ _; 1,2: done.
split; 1: exact h8.
move=> c0 i0 tr0 hlt _ hi0 hi8 hc; split; 1: by have <- : 16 + 4 * i0 = 48 by smt().
by move=> c1 i1 tr1 hlt1 _ hi1 hi18 hc1; have <- : 48 + 8 * i1 = 112 by smt().
qed.

lemma mask208_set64d (m : BArray208.t) k :
  BArray208.is_init m 0 k => 0 <= k => k + 8 <= 208 =>
  BArray208.is_init (BArray208.set64d m k (W64.of_int 18446744073709551615)) 0 (k + 8).
proof.
move=> hm hk hb j hj0 hj; rewrite BArray208.is_init_cell_set64d.
by case: (j < k) => hjk; [right; apply hm | left] => /#.
qed.

lemma __sha512_ctx_init_proof _ctx _b_ctx _h _b_h _tag _total :
  __sha512_ctx_init_spec _ctx _b_ctx _h _b_h _tag _total.
proof.
rewrite /__sha512_ctx_init_spec; proc.
while (valid trace___sha512_ctx_init /\ 0 <= i <= 16
       /\ BArray208.is_init b_ctx 0 (80 + 8 * i)).
+ auto => /> &m _ hi0 hi8 hc hlt.
  have hm := mask208_set64d b_ctx{m} (80 + 8 * i{m}) hc _ _; 1,2: smt().
  by rewrite (_ : 80 + 8 * (i{m} + 1) = 80 + 8 * i{m} + 8) 1:/#; smt().
wp; while (valid trace___sha512_ctx_init /\ 0 <= i <= 8
           /\ BArray64.is_init b_h 0 64 /\ BArray208.is_init b_ctx 0 (16 + 8 * i)).
+ auto => /> &m _ hi0 hi8 hh hc hlt.
  have hm := mask208_set64d b_ctx{m} (16 + 8 * i{m}) hc _ _; 1,2: smt().
  rewrite (_ : 16 + 8 * (i{m} + 1) = 16 + 8 * i{m} + 8) 1:/#.
  have hw : BArray64.is_init b_h{m} (i{m} * 8) 8 by move=> j hj0 hj1; apply hh => /#.
  by smt().
auto => /> hh.
have h0 := mask208_set64d _b_ctx 0 _ _ _; 1..3: by move=> // j /#.
have h8 := mask208_set64d _ 8 h0 _ _; 1,2: done.
split; 1: exact h8.
move=> c0 i0 tr0 hlt _ hi0 hi8 hc; split; 1: by have <- : 16 + 8 * i0 = 80 by smt().
by move=> c1 i1 tr1 hlt1 _ hi1 hi18 hc1; have <- : 80 + 8 * i1 = 208 by smt().
qed.

(* ------------------------------------------------------------------ *)
(* Update                                                             *)

(* The context stores the block buffer whole, so its mask is the full
   mask on entry. The absorb contracts only promise the buffered
   prefix; these lemmas add that a full buffer mask stays full, which
   the stores back into the context need. *)
lemma __fill64_mem_full :
  hoare [M.__fill64_mem : b_buf = full64 ==> res.`2 = full64].
proc; wp; while (b_buf = full64); 1: by auto => /> &m _; rewrite full64_set8.
wp; while (b_buf = full64); 1: by auto => /> &m _; rewrite full64_set64d.
by wp; while (b_buf = full64); auto => /> &m _; rewrite full64_set8.
qed.

lemma _sha256_absorb_mem_fullm :
  hoare [M._sha256_absorb_mem : b_buf = full64 ==> res.`4 = full64].
proof.
proc; sp; seq 1 : (b_result_2 = full64); 1: by call __fill64_mem_full; auto.
sp; seq 1 : (b_buf = full64).
+ by if; [wp; call (: true ==> true) => //; auto | auto].
sp; seq 1 : (b_buf = full64).
+ by if; [wp; call (: true ==> true) => //; auto | auto].
by sp; seq 1 : (b_result = full64); [call __fill64_mem_full; auto | auto].
qed.

lemma _sha256_absorb_mem_full _h _b_h _buf _total _in _inlen _ms :
  hoare [M._sha256_absorb_mem :
    (_ms = ms /\ _inlen = inlen /\ _in = in_0 /\ _total = total /\ full64 = b_buf
     /\ _buf = buf /\ _b_h = b_h /\ _h = h)
    /\ BArray32.is_init _b_h 0 32
    /\ is_valid (2 ^ 64) Glob.mem_v (W64.to_uint _in) (W64.to_uint _inlen)
    ==> res.`2 = full32 /\ res.`4 = full64 /\ res.`5 = _total + _inlen /\ valid res.`7].
proof.
have := _sha256_absorb_mem_proof _h _b_h _buf full64 _total _in _inlen _ms.
rewrite /_sha256_absorb_mem_spec => ha.
conseq ha _sha256_absorb_mem_fullm => />.
+ by move=> &m _ _ _ _ hb *; split; [exact full64_init | rewrite hb].
by move=> &m _ _ _ _ _ _ _ _ _ _ _ _ r h2 *; exact (full32E _ h2).
qed.

lemma set_sub112_32_full o :
  0 <= o => o + 32 <= 112 => SBArray112_32.set_sub full112 o full32 = full112.
proof.
move=> h0 h1; apply full112E => j hj0 hj1; rewrite SBArray112_32.is_init_cell_set.
case: (o <= j < o + 32) => hj.
+ by rewrite ifT 1:/#; apply (full32_init 0 32) => /#.
by rewrite ifF 1:/#; apply (full112_init 0 112).
qed.

lemma set_sub112_64_full o :
  0 <= o => o + 64 <= 112 => SBArray112_64.set_sub full112 o full64 = full112.
proof.
move=> h0 h1; apply full112E => j hj0 hj1; rewrite SBArray112_64.is_init_cell_set.
case: (o <= j < o + 64) => hj.
+ by rewrite ifT 1:/#; apply (full64_init 0 64) => /#.
by rewrite ifF 1:/#; apply (full112_init 0 112).
qed.

lemma _sha256_ctx_update_proof _ctx _b_ctx _in _inlen _expect _ms :
  _sha256_ctx_update_spec _ctx _b_ctx _in _inlen _expect _ms.
proof.
rewrite /_sha256_ctx_update_spec; proc; sp.
seq 1 : (valid trace__sha256_ctx_update /\ valid M.tmp__trace /\ b_ctx = full112
         /\ is_valid (2 ^ 64) Glob.mem_v (W64.to_uint in_0) (W64.to_uint inlen)).
+ ecall (__sha2_ctx_open_proof param_0 b_param_1 param).
  auto => /> &m hc *; rewrite (full112E _ hc) /=.
  by apply (sub112_16_get _ 0 0 16) => //; exact full112_init.
sp; if; last by auto => /> *; exact (full112_init 0 112).
sp; seq 1 : (valid trace__sha256_ctx_update /\ valid M.tmp__trace /\ b_ctx = full112
             /\ is_valid (2 ^ 64) Glob.mem_v (W64.to_uint in_0) (W64.to_uint inlen)).
+ by ecall (__sha2_room_proof param_1); auto.
sp; if; last by auto => /> *; exact (full112_init 0 112).
wp; ecall (_sha256_absorb_mem_full param_7 b_param_0 param_6 param_5 param_4 param_3 param_2).
auto => /> &m tr *.
have h48 : SBArray112_64.get_sub full112 48 = full64.
+ by apply full64E; apply (sub112_64_get _ 48 0 64) => //; exact full112_init.
have h16 : BArray112.is_init full112 (16 + 0) 32 by exact full112_init.
rewrite h48 (sub112_32_get _ 16 0 32 h16) //= => r -> -> -> _.
rewrite set_sub112_32_full // set_sub112_64_full // full112_set64d.
by do !split; [exact (full112_init 0 112) | exact (full32_init 0 32) | exact full64_init].
qed.

(* SHA-512: the same scripts over the 208-byte context. *)

lemma __fill128_mem_full :
  hoare [M.__fill128_mem : b_buf = full128 ==> res.`2 = full128].
proc; wp; while (b_buf = full128); 1: by auto => /> &m _; rewrite full128_set8.
wp; while (b_buf = full128); 1: by auto => /> &m _; rewrite full128_set64d.
by wp; while (b_buf = full128); auto => /> &m _; rewrite full128_set8.
qed.

lemma _sha512_absorb_mem_fullm :
  hoare [M._sha512_absorb_mem : b_buf = full128 ==> res.`4 = full128].
proof.
proc; sp; seq 1 : (b_result_2 = full128); 1: by call __fill128_mem_full; auto.
sp; seq 1 : (b_buf = full128).
+ by if; [wp; call (: true ==> true) => //; auto | auto].
sp; seq 1 : (b_buf = full128).
+ by if; [wp; call (: true ==> true) => //; auto | auto].
by sp; seq 1 : (b_result = full128); [call __fill128_mem_full; auto | auto].
qed.

lemma _sha512_absorb_mem_full _h _b_h _buf _total _in _inlen _ms :
  hoare [M._sha512_absorb_mem :
    (_ms = ms /\ _inlen = inlen /\ _in = in_0 /\ _total = total /\ full128 = b_buf
     /\ _buf = buf /\ _b_h = b_h /\ _h = h)
    /\ BArray64.is_init _b_h 0 64
    /\ is_valid (2 ^ 64) Glob.mem_v (W64.to_uint _in) (W64.to_uint _inlen)
    ==> res.`2 = full64 /\ res.`4 = full128 /\ res.`5 = _total + _inlen /\ valid res.`7].
proof.
have := _sha512_absorb_mem_proof _h _b_h _buf full128 _total _in _inlen _ms.
rewrite /_sha512_absorb_mem_spec => ha.
conseq ha _sha512_absorb_mem_fullm => />.
+ by move=> &m _ _ _ _ hb *; split; [exact full128_init | rewrite hb].
by move=> &m _ _ _ _ _ _ _ _ _ _ _ _ r h2 *; exact (full64E _ h2).
qed.

lemma set_sub208_64_full o :
  0 <= o => o + 64 <= 208 => SBArray208_64.set_sub full208 o full64 = full208.
proof.
move=> h0 h1; apply full208E => j hj0 hj1; rewrite SBArray208_64.is_init_cell_set.
case: (o <= j < o + 64) => hj.
+ by rewrite ifT 1:/#; apply (full64_init 0 64) => /#.
by rewrite ifF 1:/#; apply (full208_init 0 208).
qed.

lemma set_sub208_128_full o :
  0 <= o => o + 128 <= 208 => SBArray208_128.set_sub full208 o full128 = full208.
proof.
move=> h0 h1; apply full208E => j hj0 hj1; rewrite SBArray208_128.is_init_cell_set.
case: (o <= j < o + 128) => hj.
+ by rewrite ifT 1:/#; apply (full128_init 0 128) => /#.
by rewrite ifF 1:/#; apply (full208_init 0 208).
qed.

lemma _sha512_ctx_update_proof _ctx _b_ctx _in _inlen _expect _ms :
  _sha512_ctx_update_spec _ctx _b_ctx _in _inlen _expect _ms.
proof.
rewrite /_sha512_ctx_update_spec; proc; sp.
seq 1 : (valid trace__sha512_ctx_update /\ valid M.tmp__trace /\ b_ctx = full208
         /\ is_valid (2 ^ 64) Glob.mem_v (W64.to_uint in_0) (W64.to_uint inlen)).
+ ecall (__sha2_ctx_open_proof param_0 b_param_1 param).
  auto => /> &m hc *; rewrite (full208E _ hc) /=.
  by apply (sub208_16_get _ 0 0 16) => //; exact full208_init.
sp; if; last by auto => /> *; exact (full208_init 0 208).
sp; seq 1 : (valid trace__sha512_ctx_update /\ valid M.tmp__trace /\ b_ctx = full208
             /\ is_valid (2 ^ 64) Glob.mem_v (W64.to_uint in_0) (W64.to_uint inlen)).
+ by ecall (__sha2_room_proof param_1); auto.
sp; if; last by auto => /> *; exact (full208_init 0 208).
wp; ecall (_sha512_absorb_mem_full param_7 b_param_0 param_6 param_5 param_4 param_3 param_2).
auto => /> &m tr *.
have h48 : SBArray208_128.get_sub full208 80 = full128.
+ by apply full128E; apply (sub208_128_get _ 80 0 128) => //; exact full208_init.
have h16 : BArray208.is_init full208 (16 + 0) 64 by exact full208_init.
rewrite h48 (sub208_64_get _ 16 0 64 h16) //= => r -> -> -> _.
rewrite set_sub208_64_full // set_sub208_128_full // full208_set64d.
by do !split; [exact (full208_init 0 208) | exact (full64_init 0 64) | exact full128_init].
qed.

(* ------------------------------------------------------------------ *)
(* Final                                                              *)

(* A failed final reports status 1, so its digest mask covers nothing. *)
lemma one_neq_zero : W64.one <> W64.zero.
proof. by rewrite W64.to_uint_eq to_uint_one. qed.

lemma ctx112_h : SBArray112_32.get_sub full112 16 = full32.
proof. by apply full32E; apply (sub112_32_get _ 16 0 32) => //; exact full112_init. qed.

lemma ctx112_buf : SBArray112_64.get_sub full112 48 = full64.
proof. by apply full64E; apply (sub112_64_get _ 48 0 64) => //; exact full112_init. qed.

lemma ctx112_store (a : BArray32.t) (b : BArray64.t) :
  BArray32.is_init a 0 32 => BArray64.is_init b 0 64 =>
  SBArray112_64.set_sub (SBArray112_32.set_sub full112 16 a) 48 b = full112.
proof.
move=> ha hb; rewrite (full32E _ ha) (full64E _ hb).
by rewrite set_sub112_32_full // set_sub112_64_full.
qed.

lemma _sha224_ctx____ctx_finalize_proof _ctx _b_ctx _digest _b_digest _total _ms :
  _sha224_ctx____ctx_finalize_spec _ctx _b_ctx _digest _b_digest _total _ms.
proof.
rewrite /_sha224_ctx____ctx_finalize_spec; proc; wp.
ecall (_sha224___sha256_finalize_proof param_3 b_param_1 param_2 b_param_0 param_1 b_param param_0 param).
auto => /> hc; rewrite (full112E _ hc) /= ctx112_h ctx112_buf.
split; 1: by split; [exact full32_init | exact full64_init].
move=> _ _ r *; rewrite (ctx112_store _ _ (full32_init 0 32) (full64_init 0 64)).
by split; [exact (full112_init 0 112) | exact (full28_init 0 28)].
qed.

lemma _sha224_ctx___sha2_ctx_final_proof _ctx _b_ctx _digest _b_digest _expect _ms :
  _sha224_ctx___sha2_ctx_final_spec _ctx _b_ctx _digest _b_digest _expect _ms.
proof.
rewrite /_sha224_ctx___sha2_ctx_final_spec; proc; sp.
seq 1 : (valid trace__sha224_ctx___sha2_ctx_final /\ valid M.tmp__trace /\ b_ctx = full112).
+ ecall (__sha2_ctx_open_proof param_0 b_param_0 param).
  auto => /> hc; rewrite (full112E _ hc) /=.
  by apply (sub112_16_get _ 0 0 16) => //; exact full112_init.
sp; if; last first.
+ auto => /> &m *; split; 1: exact (full112_init 0 112).
  have -> : (W64.one = W64.zero) = false by smt(one_neq_zero).
  by move=> j /#.
sp; seq 1 : (valid trace__sha224_ctx___sha2_ctx_final /\ valid M.tmp__trace
             /\ BArray112.is_init b_result_0 0 112 /\ BArray28.is_init b_result 0 28).
+ ecall (_sha224_ctx____ctx_finalize_proof param_4 full112 param_3 b_param param_2 param_1); auto => /> *.
  exact (full112_init 0 112).
wp; while (valid trace__sha224_ctx___sha2_ctx_final /\ 0 <= i <= 14).
+ by auto => /> &m *; smt().
by auto => /> &m *; split; [exact (full112_init 0 112) | exact (full28_init 0 28)].
qed.

lemma _sha256_ctx____ctx_finalize_proof _ctx _b_ctx _digest _b_digest _total _ms :
  _sha256_ctx____ctx_finalize_spec _ctx _b_ctx _digest _b_digest _total _ms.
proof.
rewrite /_sha256_ctx____ctx_finalize_spec; proc; wp.
ecall (_sha256___sha256_finalize_proof param_3 b_param_1 param_2 b_param_0 param_1 b_param param_0 param).
auto => /> hc; rewrite (full112E _ hc) /= ctx112_h ctx112_buf.
split; 1: by split; [exact full32_init | exact full64_init].
move=> _ _ r *; rewrite (ctx112_store _ _ (full32_init 0 32) (full64_init 0 64)).
by split; [exact (full112_init 0 112) | exact (full32_init 0 32)].
qed.

lemma _sha256_ctx___sha2_ctx_final_proof _ctx _b_ctx _digest _b_digest _expect _ms :
  _sha256_ctx___sha2_ctx_final_spec _ctx _b_ctx _digest _b_digest _expect _ms.
proof.
rewrite /_sha256_ctx___sha2_ctx_final_spec; proc; sp.
seq 1 : (valid trace__sha256_ctx___sha2_ctx_final /\ valid M.tmp__trace /\ b_ctx = full112).
+ ecall (__sha2_ctx_open_proof param_0 b_param_0 param).
  auto => /> hc; rewrite (full112E _ hc) /=.
  by apply (sub112_16_get _ 0 0 16) => //; exact full112_init.
sp; if; last first.
+ auto => /> &m *; split; 1: exact (full112_init 0 112).
  have -> : (W64.one = W64.zero) = false by smt(one_neq_zero).
  by move=> j /#.
sp; seq 1 : (valid trace__sha256_ctx___sha2_ctx_final /\ valid M.tmp__trace
             /\ BArray112.is_init b_result_0 0 112 /\ BArray32.is_init b_result 0 32).
+ ecall (_sha256_ctx____ctx_finalize_proof param_4 full112 param_3 b_param param_2 param_1); auto => /> *.
  exact (full112_init 0 112).
wp; while (valid trace__sha256_ctx___sha2_ctx_final /\ 0 <= i <= 14).
+ by auto => /> &m *; smt().
by auto => /> &m *; split; [exact (full112_init 0 112) | exact (full32_init 0 32)].
qed.

(* SHA-384, SHA-512, SHA-512/224 and SHA-512/256 over the 208-byte context. *)

lemma ctx208_h : SBArray208_64.get_sub full208 16 = full64.
proof. by apply full64E; apply (sub208_64_get _ 16 0 64) => //; exact full208_init. qed.

lemma ctx208_buf : SBArray208_128.get_sub full208 80 = full128.
proof. by apply full128E; apply (sub208_128_get _ 80 0 128) => //; exact full208_init. qed.

lemma ctx208_store (a : BArray64.t) (b : BArray128.t) :
  BArray64.is_init a 0 64 => BArray128.is_init b 0 128 =>
  SBArray208_128.set_sub (SBArray208_64.set_sub full208 16 a) 80 b = full208.
proof.
move=> ha hb; rewrite (full64E _ ha) (full128E _ hb).
by rewrite set_sub208_64_full // set_sub208_128_full.
qed.

lemma _sha384_ctx____ctx_finalize_proof _ctx _b_ctx _digest _b_digest _total _ms :
  _sha384_ctx____ctx_finalize_spec _ctx _b_ctx _digest _b_digest _total _ms.
proof.
rewrite /_sha384_ctx____ctx_finalize_spec; proc; wp.
ecall (_sha384___sha512_finalize_proof param_3 b_param_1 param_2 b_param_0 param_1 b_param param_0 param).
auto => /> hc; rewrite (full208E _ hc) /= ctx208_h ctx208_buf.
split; 1: by split; [exact full64_init | exact full128_init].
move=> _ _ r *; rewrite (ctx208_store _ _ (full64_init 0 64) (full128_init 0 128)).
by split; [exact (full208_init 0 208) | exact (full48_init 0 48)].
qed.

lemma _sha384_ctx___sha2_ctx_final_proof _ctx _b_ctx _digest _b_digest _expect _ms :
  _sha384_ctx___sha2_ctx_final_spec _ctx _b_ctx _digest _b_digest _expect _ms.
proof.
rewrite /_sha384_ctx___sha2_ctx_final_spec; proc; sp.
seq 1 : (valid trace__sha384_ctx___sha2_ctx_final /\ valid M.tmp__trace /\ b_ctx = full208).
+ ecall (__sha2_ctx_open_proof param_0 b_param_0 param).
  auto => /> hc; rewrite (full208E _ hc) /=.
  by apply (sub208_16_get _ 0 0 16) => //; exact full208_init.
sp; if; last first.
+ auto => /> &m *; split; 1: exact (full208_init 0 208).
  have -> : (W64.one = W64.zero) = false by smt(one_neq_zero).
  by move=> j /#.
sp; seq 1 : (valid trace__sha384_ctx___sha2_ctx_final /\ valid M.tmp__trace
             /\ BArray208.is_init b_result_0 0 208 /\ BArray48.is_init b_result 0 48).
+ ecall (_sha384_ctx____ctx_finalize_proof param_4 full208 param_3 b_param param_2 param_1); auto => /> *.
  exact (full208_init 0 208).
wp; while (valid trace__sha384_ctx___sha2_ctx_final /\ 0 <= i <= 26).
+ by auto => /> &m *; smt().
by auto => /> &m *; split; [exact (full208_init 0 208) | exact (full48_init 0 48)].
qed.

lemma _sha512_ctx____ctx_finalize_proof _ctx _b_ctx _digest _b_digest _total _ms :
  _sha512_ctx____ctx_finalize_spec _ctx _b_ctx _digest _b_digest _total _ms.
proof.
rewrite /_sha512_ctx____ctx_finalize_spec; proc; wp.
ecall (_sha512___sha512_finalize_proof param_3 b_param_1 param_2 b_param_0 param_1 b_param param_0 param).
auto => /> hc; rewrite (full208E _ hc) /= ctx208_h ctx208_buf.
split; 1: by split; [exact full64_init | exact full128_init].
move=> _ _ r *; rewrite (ctx208_store _ _ (full64_init 0 64) (full128_init 0 128)).
by split; [exact (full208_init 0 208) | exact (full64_init 0 64)].
qed.

lemma _sha512_ctx___sha2_ctx_final_proof _ctx _b_ctx _digest _b_digest _expect _ms :
  _sha512_ctx___sha2_ctx_final_spec _ctx _b_ctx _digest _b_digest _expect _ms.
proof.
rewrite /_sha512_ctx___sha2_ctx_final_spec; proc; sp.
seq 1 : (valid trace__sha512_ctx___sha2_ctx_final /\ valid M.tmp__trace /\ b_ctx = full208).
+ ecall (__sha2_ctx_open_proof param_0 b_param_0 param).
  auto => /> hc; rewrite (full208E _ hc) /=.
  by apply (sub208_16_get _ 0 0 16) => //; exact full208_init.
sp; if; last first.
+ auto => /> &m *; split; 1: exact (full208_init 0 208).
  have -> : (W64.one = W64.zero) = false by smt(one_neq_zero).
  by move=> j /#.
sp; seq 1 : (valid trace__sha512_ctx___sha2_ctx_final /\ valid M.tmp__trace
             /\ BArray208.is_init b_result_0 0 208 /\ BArray64.is_init b_result 0 64).
+ ecall (_sha512_ctx____ctx_finalize_proof param_4 full208 param_3 b_param param_2 param_1); auto => /> *.
  exact (full208_init 0 208).
wp; while (valid trace__sha512_ctx___sha2_ctx_final /\ 0 <= i <= 26).
+ by auto => /> &m *; smt().
by auto => /> &m *; split; [exact (full208_init 0 208) | exact (full64_init 0 64)].
qed.

lemma _sha512_224_ctx____ctx_finalize_proof _ctx _b_ctx _digest _b_digest _total _ms :
  _sha512_224_ctx____ctx_finalize_spec _ctx _b_ctx _digest _b_digest _total _ms.
proof.
rewrite /_sha512_224_ctx____ctx_finalize_spec; proc; wp.
ecall (_sha512_224___sha512_finalize_proof param_3 b_param_1 param_2 b_param_0 param_1 b_param param_0 param).
auto => /> hc; rewrite (full208E _ hc) /= ctx208_h ctx208_buf.
split; 1: by split; [exact full64_init | exact full128_init].
move=> _ _ r *; rewrite (ctx208_store _ _ (full64_init 0 64) (full128_init 0 128)).
by split; [exact (full208_init 0 208) | exact (full28_init 0 28)].
qed.

lemma _sha512_224_ctx___sha2_ctx_final_proof _ctx _b_ctx _digest _b_digest _expect _ms :
  _sha512_224_ctx___sha2_ctx_final_spec _ctx _b_ctx _digest _b_digest _expect _ms.
proof.
rewrite /_sha512_224_ctx___sha2_ctx_final_spec; proc; sp.
seq 1 : (valid trace__sha512_224_ctx___sha2_ctx_final /\ valid M.tmp__trace /\ b_ctx = full208).
+ ecall (__sha2_ctx_open_proof param_0 b_param_0 param).
  auto => /> hc; rewrite (full208E _ hc) /=.
  by apply (sub208_16_get _ 0 0 16) => //; exact full208_init.
sp; if; last first.
+ auto => /> &m *; split; 1: exact (full208_init 0 208).
  have -> : (W64.one = W64.zero) = false by smt(one_neq_zero).
  by move=> j /#.
sp; seq 1 : (valid trace__sha512_224_ctx___sha2_ctx_final /\ valid M.tmp__trace
             /\ BArray208.is_init b_result_0 0 208 /\ BArray28.is_init b_result 0 28).
+ ecall (_sha512_224_ctx____ctx_finalize_proof param_4 full208 param_3 b_param param_2 param_1); auto => /> *.
  exact (full208_init 0 208).
wp; while (valid trace__sha512_224_ctx___sha2_ctx_final /\ 0 <= i <= 26).
+ by auto => /> &m *; smt().
by auto => /> &m *; split; [exact (full208_init 0 208) | exact (full28_init 0 28)].
qed.

lemma _sha512_256_ctx____ctx_finalize_proof _ctx _b_ctx _digest _b_digest _total _ms :
  _sha512_256_ctx____ctx_finalize_spec _ctx _b_ctx _digest _b_digest _total _ms.
proof.
rewrite /_sha512_256_ctx____ctx_finalize_spec; proc; wp.
ecall (_sha512_256___sha512_finalize_proof param_3 b_param_1 param_2 b_param_0 param_1 b_param param_0 param).
auto => /> hc; rewrite (full208E _ hc) /= ctx208_h ctx208_buf.
split; 1: by split; [exact full64_init | exact full128_init].
move=> _ _ r *; rewrite (ctx208_store _ _ (full64_init 0 64) (full128_init 0 128)).
by split; [exact (full208_init 0 208) | exact (full32_init 0 32)].
qed.

lemma _sha512_256_ctx___sha2_ctx_final_proof _ctx _b_ctx _digest _b_digest _expect _ms :
  _sha512_256_ctx___sha2_ctx_final_spec _ctx _b_ctx _digest _b_digest _expect _ms.
proof.
rewrite /_sha512_256_ctx___sha2_ctx_final_spec; proc; sp.
seq 1 : (valid trace__sha512_256_ctx___sha2_ctx_final /\ valid M.tmp__trace /\ b_ctx = full208).
+ ecall (__sha2_ctx_open_proof param_0 b_param_0 param).
  auto => /> hc; rewrite (full208E _ hc) /=.
  by apply (sub208_16_get _ 0 0 16) => //; exact full208_init.
sp; if; last first.
+ auto => /> &m *; split; 1: exact (full208_init 0 208).
  have -> : (W64.one = W64.zero) = false by smt(one_neq_zero).
  by move=> j /#.
sp; seq 1 : (valid trace__sha512_256_ctx___sha2_ctx_final /\ valid M.tmp__trace
             /\ BArray208.is_init b_result_0 0 208 /\ BArray32.is_init b_result 0 32).
+ ecall (_sha512_256_ctx____ctx_finalize_proof param_4 full208 param_3 b_param param_2 param_1); auto => /> *.
  exact (full208_init 0 208).
wp; while (valid trace__sha512_256_ctx___sha2_ctx_final /\ 0 <= i <= 26).
+ by auto => /> &m *; smt().
by auto => /> &m *; split; [exact (full208_init 0 208) | exact (full32_init 0 32)].
qed.

(* ------------------------------------------------------------------ *)
(* HMAC contexts: the inner hash context, then the outer state        *)

lemma set_sub144_112_full (a : BArray112.t) :
  BArray112.is_init a 0 112 => SBArray144_112.set_sub full144 0 a = full144.
proof.
move=> ha; rewrite (full112E _ ha); apply full144E => j hj0 hj1.
rewrite SBArray144_112.is_init_cell_set; case: (0 <= j < 0 + 112) => hj.
+ by rewrite ifT 1:/#; apply (full112_init 0 112) => /#.
by rewrite ifF 1:/#; apply (full144_init 0 144).
qed.

(* The outer state is stored word by word after the inner context. *)
lemma mask144_set32d (m : BArray144.t) k :
  BArray144.is_init m 0 k => 0 <= k => k + 4 <= 144 =>
  BArray144.is_init (BArray144.set32d m k (W32.of_int 4294967295)) 0 (k + 4).
proof.
move=> hm hk hb j hj0 hj; rewrite BArray144.is_init_cell_set32d.
by case: (j < k) => hjk; [right; apply hm | left] => /#.
qed.

lemma __hmac_sha256_ctx_init_proof _ctx _b_ctx _key _keylen _ms :
  __hmac_sha256_ctx_init_spec _ctx _b_ctx _key _keylen _ms.
proof.
rewrite /__hmac_sha256_ctx_init_spec; proc.
wp; while (valid trace___hmac_sha256_ctx_init /\ 0 <= i <= 8
           /\ BArray144.is_init b_ctx 0 (112 + 4 * i)).
+ auto => /> &m _ hi0 hi8 hc hlt.
  have hm := mask144_set32d b_ctx{m} (112 + 4 * i{m}) hc _ _; 1,2: smt().
  by rewrite (_ : 112 + 4 * (i{m} + 1) = 112 + 4 * i{m} + 4) 1:/#; smt().
wp; ecall (__sha256_ctx_init_proof param_11 b_param param_10 full32 param_9 param_8).
wp; ecall (__sha2_tag_proof param_7).
wp; ecall (__hmac_sha256_init_proof param_6 b_param_1 param_5 b_param_0 param_4 full64 param_3).
wp; ecall (_hmac_sha256_keyblock_mem_proof param_2 b_param_2 param_1 param_0 param).
auto => /> &m _ _ _ r _ _; split; 1: exact (full64_init 0 64).
move=> _ r0 _ _ _ r1 _; split; 1: exact (full32_init 0 32).
move=> _ r2 _ _; split.
+ by have /= := sub144_112_set_in _b_ctx full112 0 0 112 (full112_init 0 112).
by move=> b0 i0 tr hlt _ hi0 hi8 hb; have <- : 112 + 4 * i0 = 144 by smt().
qed.

lemma __hmac_sha256_ctx_final_proof _ctx _b_ctx _out _b_out _ms :
  __hmac_sha256_ctx_final_spec _ctx _b_ctx _out _b_out _ms.
proof.
rewrite /__hmac_sha256_ctx_final_spec; proc; sp.
seq 1 : (valid trace___hmac_sha256_ctx_final /\ valid M.tmp__trace /\ b_ctx = full144).
+ ecall (__sha2_ctx_open_proof param_0 b_param_4 param).
  auto => /> hc; rewrite (full144E _ hc) /=.
  by apply (sub144_16_get _ 0 0 16) => //; exact full144_init.
sp; seq 1 : (valid trace___hmac_sha256_ctx_final /\ valid M.tmp__trace /\ b_ctx = full144).
+ by ecall (__sha2_tag_proof param_1); auto.
sp; if; last first.
+ auto => /> *; split; 1: exact (full144_init 0 144).
  have -> : (W64.one = W64.zero) = false by smt(one_neq_zero).
  by move=> j /#.
wp; while (valid trace___hmac_sha256_ctx_final /\ 0 <= i <= 18
           /\ BArray32.is_init b_out 0 32).
+ by auto => /> &m *; smt().
wp; while (valid trace___hmac_sha256_ctx_final /\ 0 <= i <= 4
           /\ BArray32.is_init b_out 0 (8 * i)).
+ auto => /> &m _ hi0 hi4 hm hlt.
  have hw := mask32_set64 b_out{m} i{m} hm _ _; 1,2: smt().
  by rewrite (mulzC i{m} 8) hw /=; smt().
wp; ecall (__hmac_sha256_finalize_proof param_10 b_param_0 param_9 full32 param_8 full64
             param_7 param_6 b_param param_5).
wp; while (valid trace___hmac_sha256_ctx_final /\ 0 <= i <= 8
           /\ BArray32.is_init b_outer 0 (4 * i)).
+ auto => /> &m _ hi0 hi8 ho hlt.
  have hm := mask32_set32 b_outer{m} i{m} ho _ _; 1,2: smt().
  by rewrite (mulzC i{m} 4) hm /=; smt().
wp; ecall (__sha256_ctx_load_proof param_4 b_param_3 param_3 b_param_2 param_2 b_param_1).
auto => /> &m tr _ _.
have hg : BArray112.is_init (SBArray144_112.get_sub full144 0) 0 112.
+ by apply (sub144_112_get _ 0 0 112) => //; exact full144_init.
split; 1: exact hg.
move=> _ r h3 h4 _; split; 1: by move=> j /#.
move=> o0 i0 tr1 hlt _ hi0 hi8 ho.
have ho32 : BArray32.is_init o0 0 32 by have <- : 4 * i0 = 32 by smt().
split; 1: by split; [split; [exact (full32_init 0 32) | exact full64_init] | done].
move=> _ _ _ r1 _ _; split; 1: by move=> j /#.
move=> b1 i1 tr2 hlt1 _ hj0 hj4 hb.
split; 1: by have <- : 8 * i1 = 32 by smt().
by move=> *; exact (full144_init 0 144).
qed.

lemma set_sub272_208_full (a : BArray208.t) :
  BArray208.is_init a 0 208 => SBArray272_208.set_sub full272 0 a = full272.
proof.
move=> ha; rewrite (full208E _ ha); apply full272E => j hj0 hj1.
rewrite SBArray272_208.is_init_cell_set; case: (0 <= j < 0 + 208) => hj.
+ by rewrite ifT 1:/#; apply (full208_init 0 208) => /#.
by rewrite ifF 1:/#; apply (full272_init 0 272).
qed.

lemma mask272_set64d (m : BArray272.t) k :
  BArray272.is_init m 0 k => 0 <= k => k + 8 <= 272 =>
  BArray272.is_init (BArray272.set64d m k (W64.of_int 18446744073709551615)) 0 (k + 8).
proof.
move=> hm hk hb j hj0 hj; rewrite BArray272.is_init_cell_set64d.
by case: (j < k) => hjk; [right; apply hm | left] => /#.
qed.

lemma __hmac_sha512_ctx_init_proof _ctx _b_ctx _key _keylen _ms :
  __hmac_sha512_ctx_init_spec _ctx _b_ctx _key _keylen _ms.
proof.
rewrite /__hmac_sha512_ctx_init_spec; proc.
wp; while (valid trace___hmac_sha512_ctx_init /\ 0 <= i <= 8
           /\ BArray272.is_init b_ctx 0 (208 + 8 * i)).
+ auto => /> &m _ hi0 hi8 hc hlt.
  have hm := mask272_set64d b_ctx{m} (208 + 8 * i{m}) hc _ _; 1,2: smt().
  by rewrite (_ : 208 + 8 * (i{m} + 1) = 208 + 8 * i{m} + 8) 1:/#; smt().
wp; ecall (__sha512_ctx_init_proof param_11 b_param param_10 full64 param_9 param_8).
wp; ecall (__sha2_tag_proof param_7).
wp; ecall (__hmac_sha512_init_proof param_6 b_param_1 param_5 b_param_0 param_4 full128 param_3).
wp; ecall (_hmac_sha512_keyblock_mem_proof param_2 b_param_2 param_1 param_0 param).
auto => /> &m _ _ _ r _ _; split; 1: exact (full128_init 0 128).
move=> _ r0 _ _ _ r1 _; split; 1: exact (full64_init 0 64).
move=> _ r2 _ _; split.
+ by have /= := sub272_208_set_in _b_ctx full208 0 0 208 (full208_init 0 208).
by move=> b0 i0 tr hlt _ hi0 hi8 hb; have <- : 208 + 8 * i0 = 272 by smt().
qed.

lemma __hmac_sha512_ctx_final_proof _ctx _b_ctx _out _b_out _ms :
  __hmac_sha512_ctx_final_spec _ctx _b_ctx _out _b_out _ms.
proof.
rewrite /__hmac_sha512_ctx_final_spec; proc; sp.
seq 1 : (valid trace___hmac_sha512_ctx_final /\ valid M.tmp__trace /\ b_ctx = full272).
+ ecall (__sha2_ctx_open_proof param_0 b_param_4 param).
  auto => /> hc; rewrite (full272E _ hc) /=.
  by apply (sub272_16_get _ 0 0 16) => //; exact full272_init.
sp; seq 1 : (valid trace___hmac_sha512_ctx_final /\ valid M.tmp__trace /\ b_ctx = full272).
+ by ecall (__sha2_tag_proof param_1); auto.
sp; if; last first.
+ auto => /> *; split; 1: exact (full272_init 0 272).
  have -> : (W64.one = W64.zero) = false by smt(one_neq_zero).
  by move=> j /#.
wp; while (valid trace___hmac_sha512_ctx_final /\ 0 <= i <= 34
           /\ BArray64.is_init b_out 0 64).
+ by auto => /> &m *; smt().
wp; while (valid trace___hmac_sha512_ctx_final /\ 0 <= i <= 8
           /\ BArray64.is_init b_out 0 (8 * i)).
+ auto => /> &m _ hi0 hi4 hm hlt.
  have hw := mask64_set64 b_out{m} i{m} hm _ _; 1,2: smt().
  by rewrite (mulzC i{m} 8) hw /=; smt().
wp; ecall (__hmac_sha512_finalize_proof param_10 b_param_0 param_9 full64 param_8 full128
             param_7 param_6 b_param param_5).
wp; while (valid trace___hmac_sha512_ctx_final /\ 0 <= i <= 8
           /\ BArray64.is_init b_outer 0 (8 * i)).
+ auto => /> &m _ hi0 hi8 ho hlt.
  have hm := mask64_set64 b_outer{m} i{m} ho _ _; 1,2: smt().
  by rewrite (mulzC i{m} 8) hm /=; smt().
wp; ecall (__sha512_ctx_load_proof param_4 b_param_3 param_3 b_param_2 param_2 b_param_1).
auto => /> &m tr _ _.
have hg : BArray208.is_init (SBArray272_208.get_sub full272 0) 0 208.
+ by apply (sub272_208_get _ 0 0 208) => //; exact full272_init.
split; 1: exact hg.
move=> _ r h3 h4 _; split; 1: by move=> j /#.
move=> o0 i0 tr1 hlt _ hi0 hi8 ho.
have ho32 : BArray64.is_init o0 0 64 by have <- : 8 * i0 = 64 by smt().
split; 1: by split; [split; [exact (full64_init 0 64) | exact full128_init] | done].
move=> _ _ _ r1 _ _; split; 1: by move=> j /#.
move=> b1 i1 tr2 hlt1 _ hj0 hj4 hb.
split; 1: by have <- : 8 * i1 = 64 by smt().
by move=> *; exact (full272_init 0 272).
qed.
