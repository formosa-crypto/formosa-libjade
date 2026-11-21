(*
 * SafetySha256.ec
 * ===============
 *
 * Safety of the streaming and one-shot SHA-224 and SHA-256 of
 * sha256.jinc and sha256_DSIZE.jinc: initial values, absorb,
 * padding and output for both digest sizes, one-shot hashing. The
 * SHA-256 kernel enters through SafetyK256.
 *)

require import AllCore IntDiv CoreMap List Distr.
from Jasmin require import JWord JUtils JMemory Jcheck JSafety.
require import SafetyEclib.
require import SafetyLib SafetyMask SafetyFill SafetyK256.
require import BArray28 BArray32 BArray64 Jsha2_safety.

(* ------------------------------------------------------------------ *)
(* Initial values                                                     *)

lemma __sha256_init_proof _h _b_h : __sha256_init_spec _h _b_h.
proof.
rewrite /__sha256_init_spec; proc.
while (valid trace___sha256_init /\ 0 <= i <= 8 /\ BArray32.is_init b_h 0 (4 * i)).
+ auto => /> &m _ hi0 hi8 hh hlt.
  have hm := mask32_set32 b_h{m} i{m} hh _ _; 1,2: smt().
  by rewrite (mulzC i{m} 4) hm /=; smt().
auto => />; split; 1: by move=> j /#.
by move=> b0 i0 tr0 hlt _ hi0 hi8 hh; have <- : 4 * i0 = 32 by smt().
qed.

lemma __sha224_init_proof _h _b_h : __sha224_init_spec _h _b_h.
proof.
rewrite /__sha224_init_spec; proc.
while (valid trace___sha224_init /\ 0 <= i <= 8 /\ BArray32.is_init b_h 0 (4 * i)).
+ auto => /> &m _ hi0 hi8 hh hlt.
  have hm := mask32_set32 b_h{m} i{m} hh _ _; 1,2: smt().
  by rewrite (mulzC i{m} 4) hm /=; smt().
auto => />; split; 1: by move=> j /#.
by move=> b0 i0 tr0 hlt _ hi0 hi8 hh; have <- : 4 * i0 = 32 by smt().
qed.


(* ------------------------------------------------------------------ *)
(* Absorb                                                             *)

(* The head of an absorb: f bytes are buffered, and n of the l input
   bytes top the buffer up (none when it is empty). *)
lemma absorb_head256 (t l f n : W64.t) :
  f = t `&` W64.of_int 63 =>
  n = (if f = W64.of_int 0 then f
       else if l \ult W64.of_int 64 - f then l else W64.of_int 64 - f) =>
  to_uint f = to_uint t %% 64 /\ to_uint f + to_uint n <= 64
  /\ to_uint n <= to_uint l /\ to_uint (l - n) = to_uint l - to_uint n
  /\ (to_uint f = 0 => to_uint n = 0)
  /\ (to_uint f <> 0 => to_uint f + to_uint n <> 64 => to_uint n = to_uint l).
proof.
move=> hfd ->.
have hf : to_uint f = to_uint t %% 64 by rewrite hfd and63.
have hf64 : to_uint f < 64 by smt(modz_cmp).
have hs : to_uint (W64.of_int 64 - f) = 64 - to_uint f.
+ by rewrite W64.to_uintB 1:W64.uleE; smt(W64.of_uintK).
have hz : (f = W64.of_int 0) <=> to_uint f = 0 by rewrite W64.to_uint_eq.
case: (f = W64.of_int 0) => hf0 /=.
+ have h0 : to_uint f = 0 by rewrite hf0 W64.to_uint0.
  by rewrite W64.to_uintB 1:W64.uleE; smt(W64.to_uint_cmp).
case: (l \ult W64.of_int 64 - f) => hl /=.
+ by move: hl; rewrite W64.ultE hs; smt(W64.to_uint_cmp).
move: hl; rewrite W64.ultE hs => hl.
by rewrite W64.to_uintB 1:W64.uleE 1:hs; smt(W64.to_uint_cmp).
qed.

lemma _sha256_absorb_mem_proof _h _b_h _buf _b_buf _total _in _inlen _ms :
  _sha256_absorb_mem_spec _h _b_h _buf _b_buf _total _in _inlen _ms.
proof.
rewrite /_sha256_absorb_mem_spec; proc; sp.
seq 1 : (valid trace__sha256_absorb_mem /\ valid M.tmp__trace
         /\ BArray64.is_init b_result_2 0 (to_uint (param_2 + param_0))
         /\ total = _total + _inlen
         /\ to_uint fill + to_uint n <= 64
         /\ BArray64.is_init b_result_2 0 (to_uint fill + to_uint n)
         /\ (to_uint fill = 0 => to_uint n = 0)
         /\ (to_uint fill <> 0 => to_uint fill + to_uint n <> 64 => to_uint inlen = 0)
         /\ to_uint fill + to_uint n + to_uint inlen = to_uint _total %% 64 + to_uint _inlen
         /\ is_valid (2 ^ 64) Glob.mem_v (to_uint in_0) (to_uint n + to_uint inlen)).
+ ecall (__fill64_mem_proof param_3 b_param_1 param_2 param_1 param_0 param).
  auto => /> &m hh hb hv hp0 hpl.
  pose f := _total `&` W64.of_int 63.
  pose n := if f = W64.of_int 0 then f
            else if _inlen \ult W64.of_int 64 - f then _inlen else W64.of_int 64 - f.
  have [#] hf hfn hnl hln hf0 hfl := absorb_head256 _total _inlen f n _ _ => //.
  have hfn' : to_uint (f + n) = to_uint f + to_uint n.
  + by rewrite W64.to_uintD_small; smt().
  rewrite !W64.uleE /= hfn' hln; move: hb; rewrite umodc // -hf => hb.
  split; 2: move=> _ _ _ _ _ _ _ r hr _.
  + by do !split => //; try (move=> i h1 h2; apply hv => /#); smt().
  by do !split => //; try (move=> i h1 h2; apply hv => /#); smt().
sp; seq 1 : (valid trace__sha256_absorb_mem /\ total = _total + _inlen
             /\ to_uint fill < 64
             /\ BArray64.is_init b_buf 0 (to_uint fill)
             /\ (to_uint fill <> 0 => to_uint inlen = 0)
             /\ (to_uint fill + to_uint inlen) %% 64
                = (to_uint _total %% 64 + to_uint _inlen) %% 64
             /\ is_valid (2 ^ 64) Glob.mem_v (to_uint in_0) (to_uint inlen)).
+ if.
  + wp; ecall (_sha256_compress_proof param_6 (BArray32.init_arr (W8.of_int 255))
                 param_5 b_param_0 param_4).
    auto => /> &m in0 f0 tr0 _ hT _ hfn hb hf0 hfl hsum hv hp0 hpl hfull.
    have e64 : to_uint f0 + to_uint n{m} = 64.
    + by rewrite -W64.to_uintD_small 1:/# hfull W64.to_uint_small.
    have ein : to_uint (in0 + n{m}) = to_uint in0 + to_uint n{m}.
    + by rewrite W64.to_uintD_small; smt(W64.to_uint_cmp).
    move: hb; rewrite e64 => hb; split; 1: by split; [exact (full32_init 0 32) | exact hb].
    move=> _ _ r _ _; rewrite /protect_64 ein.
    have hm : to_uint inlen{m} %% 64 = (to_uint _total %% 64 + to_uint _inlen) %% 64.
    + by rewrite (_ : to_uint _total %% 64 + to_uint _inlen = to_uint inlen{m} + 1 * 64)
        1:/# modzMDr.
    split; 1: by move=> j /#.
    do !split => //; try (move=> i h1 h2; apply hv); smt(W64.to_uint_cmp).
  auto => /> &m in0 f0 tr0 _ hT _ hfn hb hf0 hfl hsum hv hp0 hpl hfull.
  have efn : to_uint (f0 + n{m}) = to_uint f0 + to_uint n{m}.
  + by rewrite W64.to_uintD_small; smt(W64.to_uint_cmp).
  have ein : to_uint (in0 + n{m}) = to_uint in0 + to_uint n{m}.
  + by rewrite W64.to_uintD_small; smt(W64.to_uint_cmp).
  have h64 : to_uint f0 + to_uint n{m} <> 64.
  + by move: hfull; rewrite W64.to_uint_eq efn; smt(W64.of_uintK w64_modulus).
  rewrite efn ein; split; 1: smt().
  split; 1: exact hb.
  split; 1: smt().
  split; 1: by rewrite hsum.
  split; 1: by move=> i h1 h2; apply hv; smt().
  smt(W64.to_uint_cmp).
sp; seq 1 : (valid trace__sha256_absorb_mem /\ total = _total + _inlen
             /\ to_uint off <= to_uint inlen
             /\ to_uint fill + (to_uint inlen - to_uint off)
                = (to_uint _total %% 64 + to_uint _inlen) %% 64
             /\ BArray64.is_init b_buf 0 (to_uint fill)
             /\ is_valid (2 ^ 64) Glob.mem_v (to_uint in_0) (to_uint inlen)).
+ if.
  + wp; ecall (_sha256_compress_blocks_proof param_10 (BArray32.init_arr (W8.of_int 255))
                 param_9 param_8 param_7).
    auto => /> &m _ hf hb hf0 hm hv hp0 hpl hnz.
    have hn : to_uint (inlen{m} `>>` W8.of_int 6) = to_uint inlen{m} %/ 64.
    + by have := shrc inlen{m} 6 _.
    have ho : to_uint ((inlen{m} `>>` W8.of_int 6) `<<` W8.of_int 6)
              = 64 * (to_uint inlen{m} %/ 64).
    + by have := blocksc inlen{m} 6 _.
    have hn1 := nonzero _ hnz.
    have e := mulc_small (inlen{m} `>>` W8.of_int 6) 64 _ _; 1,2: smt(W64.to_uint_cmp).
    have hdm := divz_eq (to_uint inlen{m}) 64.
    have hz : to_uint fill{m} = 0 by smt(W64.to_uint_cmp).
    rewrite /protect_64 e ho hn W64.ultE hn W64.to_uint_small //=.
    split; 1: by do !split; try exact (full32_init 0 32); try (move=> i h1 h2; apply hv);
      smt(modz_ge0 W64.to_uint_cmp).
    move=> _ _ _ _ _ r _ _; split; 1: smt(modz_ge0).
    split; 1: by move: hm; rewrite hz /=; smt().
    split; 1: by move=> j /#.
    by move=> i h1 h2; apply hv.
  auto => /> &m _ hf hb hf0 hm hv hp0 hpl hz.
  have hn : to_uint inlen{m} %/ 64 = 0.
  + have := shrc inlen{m} 6 _; 1: done.
    by rewrite hz W64.to_uint0 => ->.
  have hl : to_uint inlen{m} < 64 by smt(divz_eq modz_ge0 ltz_pmod W64.to_uint_cmp).
  by rewrite -hm pmod_small; smt(W64.to_uint_cmp).
wp; ecall (__fill64_mem_proof param_15 b_param param_14 param_13 param_12 param_11).
auto => /> &m _ ho hs hb hv hp0 hpl.
have e1 : to_uint (inlen{m} - off{m}) = to_uint inlen{m} - to_uint off{m}.
+ by rewrite W64.to_uintB 1:W64.uleE.
have e2 : to_uint (in_0{m} + off{m}) = to_uint in_0{m} + to_uint off{m}.
+ by rewrite W64.to_uintD_small; smt(W64.to_uint_cmp).
have e3 : to_uint (fill{m} + (inlen{m} - off{m}))
          = to_uint fill{m} + (to_uint inlen{m} - to_uint off{m}).
+ by rewrite W64.to_uintD_small e1; smt(W64.to_uint_cmp modz_cmp).
have e4 : to_uint ((_total + _inlen) \umod W64.of_int 64)
          = (to_uint _total %% 64 + to_uint _inlen) %% 64.
+ rewrite umodc // W64.to_uintD w64_modulus.
  by rewrite (modz_dvd _ _ 64) // modzDml.
have hlt : to_uint fill{m} + (to_uint inlen{m} - to_uint off{m}) < 64.
+ by rewrite hs; smt(modz_cmp).
rewrite !W64.uleE /= e1 e2 e3 e4 -hs.
split; 1: by do !split; try (move=> i h1 h2; apply hv); smt(W64.to_uint_cmp).
by move=> _ _ _ _ _ _ r h _; split; [exact (full32_init 0 32) | exact h].
qed.

(* ------------------------------------------------------------------ *)
(* Padding and output                                                 *)

(* sha256_DSIZE.jinc is compiled twice, for 28 and 32 output bytes.
   The two safety proofs differ only in the output loop bound and the
   output mask theory, so the short script is repeated per instance. *)

lemma _sha256___sha256_finalize_proof _out _b_out _h _b_h _buf _b_buf _total _ms :
  _sha256___sha256_finalize_spec _out _b_out _h _b_h _buf _b_buf _total _ms.
proof.
rewrite /_sha256___sha256_finalize_spec; proc; sp.
seq 1 : (valid trace__sha256___sha256_finalize /\ to_uint fill <= 56
         /\ BArray64.is_init b_buf 0 (to_uint fill)).
+ if.
  + wp; ecall (_sha256_compress_proof param_5 (BArray32.init_arr (W8.of_int 255))
                 param_4 b_param_1 param_3); wp.
    ecall (__zero64_proof param_2 b_param_2 param_1 param_0 param); auto => /> &m hh hb _.
    have hf := and63 total{m}.
    have e : to_uint (total{m} `&` W64.of_int 63 + W64.one) = to_uint total{m} %% 64 + 1.
    + by rewrite addone_small hf //; smt(modz_cmp).
    move: hb; rewrite umodc // => hb.
    have hs := mask64_set8 _b_buf (to_uint total{m} %% 64) hb _; 1: smt(modz_cmp).
    rewrite W64.uleE e hf /=; split; 1: by split; [smt(modz_cmp) | exact hs].
    move=> _ _ r _ _; split; 1: exact (full32_init 0 32).
    by move=> _ r0 _ _; split; [smt(modz_cmp) | move=> j /#].
  auto => /> &m hh hb.
  have hf := and63 total{m}.
  have e : to_uint (total{m} `&` W64.of_int 63 + W64.one) = to_uint total{m} %% 64 + 1.
  + by rewrite addone_small hf //; smt(modz_cmp).
  move: hb; rewrite umodc // => hb.
  have hs := mask64_set8 _b_buf (to_uint total{m} %% 64) hb _; 1: smt(modz_cmp).
  rewrite W64.ultE e hf /= => h56.
  by do !split => //; smt(modz_cmp).
wp; while (valid trace__sha256___sha256_finalize /\ 0 <= i <= 8
           /\ BArray64.is_init b_buf 0 64
           /\ BArray32.is_init b_out 0 (4 * i)).
+ wp; ecall (__bswap32_proof param_14); auto => /> &m _ hi0 hi8 hb ho hlt.
  have hm := mask32_set32 b_out{m} i{m} ho _ _; 1,2: smt().
  by rewrite (mulzC i{m} 4) hm /=; smt().
wp; ecall (_sha256_compress_proof param_13 (BArray32.init_arr (W8.of_int 255))
             param_12 b_param param_11); wp.
ecall (__bswap64_proof param_10); wp.
ecall (__zero64_proof param_9 b_param_0 param_8 param_7 param_6); auto => /> &m _ hf hb.
rewrite W64.uleE /= hf /= => r hr _ _ _.
have hp := mask64_put64 r.`2 56 hr _ _ => //=.
rewrite hp /=; split; 1: exact (full32_init 0 32).
move=> _ r1 h1 _; split; 1: by move=> j /#.
move=> o0 i0 _ hi _ hi0 hi8 ho.
by have <- : 4 * i0 = 32 by smt().
qed.

lemma _sha224___sha256_finalize_proof _out _b_out _h _b_h _buf _b_buf _total _ms :
  _sha224___sha256_finalize_spec _out _b_out _h _b_h _buf _b_buf _total _ms.
proof.
rewrite /_sha224___sha256_finalize_spec; proc; sp.
seq 1 : (valid trace__sha224___sha256_finalize /\ to_uint fill <= 56
         /\ BArray64.is_init b_buf 0 (to_uint fill)).
+ if.
  + wp; ecall (_sha256_compress_proof param_5 (BArray32.init_arr (W8.of_int 255))
                 param_4 b_param_1 param_3); wp.
    ecall (__zero64_proof param_2 b_param_2 param_1 param_0 param); auto => /> &m hh hb _.
    have hf := and63 total{m}.
    have e : to_uint (total{m} `&` W64.of_int 63 + W64.one) = to_uint total{m} %% 64 + 1.
    + by rewrite addone_small hf //; smt(modz_cmp).
    move: hb; rewrite umodc // => hb.
    have hs := mask64_set8 _b_buf (to_uint total{m} %% 64) hb _; 1: smt(modz_cmp).
    rewrite W64.uleE e hf /=; split; 1: by split; [smt(modz_cmp) | exact hs].
    move=> _ _ r _ _; split; 1: exact (full32_init 0 32).
    by move=> _ r0 _ _; split; [smt(modz_cmp) | move=> j /#].
  auto => /> &m hh hb.
  have hf := and63 total{m}.
  have e : to_uint (total{m} `&` W64.of_int 63 + W64.one) = to_uint total{m} %% 64 + 1.
  + by rewrite addone_small hf //; smt(modz_cmp).
  move: hb; rewrite umodc // => hb.
  have hs := mask64_set8 _b_buf (to_uint total{m} %% 64) hb _; 1: smt(modz_cmp).
  rewrite W64.ultE e hf /= => h56.
  by do !split => //; smt(modz_cmp).
wp; while (valid trace__sha224___sha256_finalize /\ 0 <= i <= 7
           /\ BArray64.is_init b_buf 0 64
           /\ BArray28.is_init b_out 0 (4 * i)).
+ wp; ecall (__bswap32_proof param_14); auto => /> &m _ hi0 hi8 hb ho hlt.
  have hm := mask28_set32 b_out{m} i{m} ho _ _; 1,2: smt().
  by rewrite (mulzC i{m} 4) hm /=; smt().
wp; ecall (_sha256_compress_proof param_13 (BArray32.init_arr (W8.of_int 255))
             param_12 b_param param_11); wp.
ecall (__bswap64_proof param_10); wp.
ecall (__zero64_proof param_9 b_param_0 param_8 param_7 param_6); auto => /> &m _ hf hb.
rewrite W64.uleE /= hf /= => r hr _ _ _.
have hp := mask64_put64 r.`2 56 hr _ _ => //=.
rewrite hp /=; split; 1: exact (full32_init 0 32).
move=> _ r1 h1 _; split; 1: by move=> j /#.
move=> o0 i0 _ hi _ hi0 hi8 ho.
by have <- : 4 * i0 = 28 by smt().
qed.

(* ------------------------------------------------------------------ *)
(* One-shot hashing                                                   *)

lemma _sha256____sha256_mem_from_proof _out _b_out _h _b_h _in _inlen _ms :
  _sha256____sha256_mem_from_spec _out _b_out _h _b_h _in _inlen _ms.
proof.
rewrite /_sha256____sha256_mem_from_spec; proc.
wp; ecall (_sha256___sha256_finalize_proof param_9 b_param_0 param_8
             (BArray32.init_arr (W8.of_int 255)) param_7 b_param param_6 param_5).
wp; ecall (_sha256_absorb_mem_proof param_4 (BArray32.init_arr (W8.of_int 255))
             param_3 b_param_1 param_2 param_1 param_0 param).
auto => /> &m _ _ _ _; split; 1: exact (full32_init 0 32).
move=> j h1 h2.
by have := umodc W64.zero 64 _; rewrite // W64.to_uint0 /=; smt().
qed.

lemma _sha224____sha256_mem_from_proof _out _b_out _h _b_h _in _inlen _ms :
  _sha224____sha256_mem_from_spec _out _b_out _h _b_h _in _inlen _ms.
proof.
rewrite /_sha224____sha256_mem_from_spec; proc.
wp; ecall (_sha224___sha256_finalize_proof param_9 b_param_0 param_8
             (BArray32.init_arr (W8.of_int 255)) param_7 b_param param_6 param_5).
wp; ecall (_sha256_absorb_mem_proof param_4 (BArray32.init_arr (W8.of_int 255))
             param_3 b_param_1 param_2 param_1 param_0 param).
auto => /> &m _ _ _ _; split; 2: by move=> *; exact (full28_init 0 28).
split; 1: exact (full32_init 0 32).
move=> j h1 h2.
by have := umodc W64.zero 64 _; rewrite // W64.to_uint0 /=; smt().
qed.

lemma _sha256_mem_proof _out _b_out _in _inlen _ms :
  _sha256_mem_spec _out _b_out _in _inlen _ms.
proof.
rewrite /_sha256_mem_spec; proc.
wp; ecall (_sha256____sha256_mem_from_proof param_4 b_param param_3
             (BArray32.init_arr (W8.of_int 255)) param_2 param_1 param_0).
wp; ecall (__sha256_init_proof param b_param_0).
auto => &m /= [#] _ <- <- _ _ hv r [h1 h2].
have hf := full32_init 0 32; have ho := full32_init 0 32.
split; 1: by rewrite hf hv.
by move=> _ r1 [h3 h4]; rewrite ?hf ?ho hv h1 h2 h3 h4.
qed.

lemma _sha224_mem_proof _out _b_out _in _inlen _ms :
  _sha224_mem_spec _out _b_out _in _inlen _ms.
proof.
rewrite /_sha224_mem_spec; proc.
wp; ecall (_sha224____sha256_mem_from_proof param_4 b_param param_3
             (BArray32.init_arr (W8.of_int 255)) param_2 param_1 param_0).
wp; ecall (__sha224_init_proof param b_param_0).
auto => &m /= [#] _ <- <- _ _ hv r [h1 h2].
have hf := full32_init 0 32; have ho := full28_init 0 28.
split; 1: by rewrite hf hv.
by move=> _ r1 [h3 h4]; rewrite ?hf ?ho hv h1 h2 h3 h4.
qed.
