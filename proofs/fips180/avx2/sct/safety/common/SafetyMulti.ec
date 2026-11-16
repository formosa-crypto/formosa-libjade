(*
 * SafetyMulti.ec
 * ==============
 *
 * Safety of the multi-way front ends of sha256_x8.jinc and
 * sha512_x4.jinc: the interleaved initial state, the state taken
 * from a single-way prefix, absorbing equal-length lanes, padding and
 * output, and the one-shot over lanes. The lane kernels enter through
 * SafetyKX8 and SafetyKX4; the buffered head and tail of each lane go
 * through the single-way fill of SafetyFill.
 *)

require import AllCore IntDiv CoreMap List Distr.
from Jasmin require import JWord JUtils JMemory Jcheck JSafety.
require import SafetyEclib.
require import SafetyLib SafetyMask SafetySub SafetyFill SafetyKX8 SafetyKX4.
require import SafetySha256 SafetySha512.
require import BArray32 BArray64 BArray128 BArray256 BArray512 Jsha2_safety.
require import SBArray512_64 SBArray512_128.

(* ------------------------------------------------------------------ *)
(* Lane masks                                                         *)

(* The buffer of n lanes of B bytes holds lane j at bytes B * j to
   B * j + B - 1. A loop over the lanes brings lanes below k to l'
   bytes while the others stay at l bytes. *)
op lanes (m : BArray512.t) (n b k l l' : int) =
  forall j, 0 <= j < n => BArray512.is_init m (b * j) (if j < k then l' else l).

lemma lanes_start (m : BArray512.t) n b l l' :
  lanes m n b n l l => lanes m n b 0 l l'.
proof. by move=> h j hj; have := h j hj; smt(). qed.

lemma lanes_end (m : BArray512.t) n b l l' :
  lanes m n b n l l' => lanes m n b n l' l'.
proof. by move=> h j hj; have := h j hj; smt(). qed.

lemma lanes_le (m : BArray512.t) n b k l l' :
  lanes m n b n l l => l' <= l => lanes m n b k l' l'.
proof.
move=> h hl j hj i hi0 hi1; have := h j hj; rewrite (_ : (if j < n then l else l) = l) 1:/#.
by move=> hm; apply hm; smt().
qed.

lemma lanes_full n b k l l' : lanes full512 n b k l l'.
proof. by move=> j hj; exact full512_init. qed.

lemma lanes0 (m : BArray512.t) n b k : lanes m n b k 0 0.
proof. by move=> j hj i hi0 hi1; smt(). qed.

(* Lane k through the 64-byte sub-array view. *)
lemma lanes64_get (m : BArray512.t) k l l' :
  lanes m 8 64 k l l' => 0 <= k < 8 => 0 <= l <= 64 =>
  BArray64.is_init (SBArray512_64.get_sub m (64 * k)) 0 l.
proof.
move=> h hk hl; apply (sub512_64_get _ _ 0 l) => //; 2..: smt().
by have := h k hk; rewrite ifF 1:/#.
qed.

lemma lanes64_set (m : BArray512.t) (s : BArray64.t) k l l' :
  lanes m 8 64 k l l' => 0 <= k < 8 => 0 <= l <= 64 => 0 <= l' <= 64 =>
  BArray64.is_init s 0 l' => lanes (SBArray512_64.set_sub m (64 * k) s) 8 64 (k + 1) l l'.
proof.
move=> h hk hl hl' hs j hj; case: (j = k) => [->> | hjk].
+ by rewrite ifT 1:/#; apply (sub512_64_set_in _ _ _ 0) => //; smt().
apply sub512_64_set_out; 2: smt().
by have := h j hj; rewrite (_ : (j < k + 1) = (j < k)) 1:/#.
qed.

lemma lanes128_get (m : BArray512.t) k l l' :
  lanes m 4 128 k l l' => 0 <= k < 4 => 0 <= l <= 128 =>
  BArray128.is_init (SBArray512_128.get_sub m (128 * k)) 0 l.
proof.
move=> h hk hl; apply (sub512_128_get _ _ 0 l) => //; 2..: smt().
by have := h k hk; rewrite ifF 1:/#.
qed.

lemma lanes128_set (m : BArray512.t) (s : BArray128.t) k l l' :
  lanes m 4 128 k l l' => 0 <= k < 4 => 0 <= l <= 128 => 0 <= l' <= 128 =>
  BArray128.is_init s 0 l' => lanes (SBArray512_128.set_sub m (128 * k) s) 4 128 (k + 1) l l'.
proof.
move=> h hk hl hl' hs j hj; case: (j = k) => [->> | hjk].
+ by rewrite ifT 1:/#; apply (sub512_128_set_in _ _ _ 0) => //; smt().
apply sub512_128_set_out; 2: smt().
by have := h j hj; rewrite (_ : (j < k + 1) = (j < k)) 1:/#.
qed.

(* The padding byte of lane k, at offset f of the lane, and the length
   word at its end. *)
lemma lanes8_set8 (m : BArray512.t) k f :
  lanes m 8 64 k f (f + 1) => 0 <= k < 8 => 0 <= f < 64 =>
  lanes (BArray512.set8 m (64 * k + f) (W8.of_int 255)) 8 64 (k + 1) f (f + 1).
proof.
move=> h hk hf j hj i hi0 hi1; rewrite BInit512.is_init_cellP /=.
case: (64 * k + f = i) => hi; 1: smt().
by have := h j hj i _ _; [smt() | smt() | smt()].
qed.

lemma lanes8_set64d (m : BArray512.t) k :
  lanes m 8 64 k 56 64 => 0 <= k < 8 =>
  lanes (BArray512.set64d m (64 * k + 56) (W64.of_int 18446744073709551615)) 8 64 (k + 1) 56 64.
proof.
move=> h hk j hj i hi0 hi1; rewrite BArray512.is_init_cell_set64d.
case: (64 * k + 56 <= i < 64 * k + 64) => hi; 1: by left; smt().
by right; have := h j hj i _ _; [smt() | smt() | smt()].
qed.

lemma lanes4_set8 (m : BArray512.t) k f :
  lanes m 4 128 k f (f + 1) => 0 <= k < 4 => 0 <= f < 128 =>
  lanes (BArray512.set8 m (128 * k + f) (W8.of_int 255)) 4 128 (k + 1) f (f + 1).
proof.
move=> h hk hf j hj i hi0 hi1; rewrite BInit512.is_init_cellP /=.
case: (128 * k + f = i) => hi; 1: smt().
by have := h j hj i _ _; [smt() | smt() | smt()].
qed.

lemma lanes4_set64d (m : BArray512.t) k :
  lanes m 4 128 k 120 128 => 0 <= k < 4 =>
  lanes (BArray512.set64d m (128 * k + 120) (W64.of_int 18446744073709551615)) 4 128 (k + 1) 120 128.
proof.
move=> h hk j hj i hi0 hi1; rewrite BArray512.is_init_cell_set64d.
case: (128 * k + 120 <= i < 128 * k + 128) => hi; 1: by left; smt().
by right; have := h j hj i _ _; [smt() | smt() | smt()].
qed.

(* The contracts list the lanes one by one. *)
lemma lanes8I (m : BArray512.t) l :
  BArray512.is_init m 0 l => BArray512.is_init m 64 l => BArray512.is_init m 128 l =>
  BArray512.is_init m 192 l => BArray512.is_init m 256 l => BArray512.is_init m 320 l =>
  BArray512.is_init m 384 l => BArray512.is_init m 448 l => lanes m 8 64 8 l l.
proof.
move=> h0 h1 h2 h3 h4 h5 h6 h7 j hj; rewrite (_ : (if j < 8 then l else l) = l) 1:/#.
have : j = 0 \/ j = 1 \/ j = 2 \/ j = 3 \/ j = 4 \/ j = 5 \/ j = 6 \/ j = 7 by smt().
by case=> [->|[->|[->|[->|[->|[->|[->|->]]]]]]].
qed.

lemma lanes8E (m : BArray512.t) l : lanes m 8 64 8 l l =>
  BArray512.is_init m 0 l /\ BArray512.is_init m 64 l /\ BArray512.is_init m 128 l
  /\ BArray512.is_init m 192 l /\ BArray512.is_init m 256 l /\ BArray512.is_init m 320 l
  /\ BArray512.is_init m 384 l /\ BArray512.is_init m 448 l.
proof. by move=> h; do !split; [have := h 0 | have := h 1 | have := h 2 | have := h 3 | have := h 4 | have := h 5 | have := h 6 | have := h 7]. qed.

lemma lanes8_full (m : BArray512.t) : lanes m 8 64 8 64 64 => m = full512.
proof.
move=> h; apply full512E => i hi0 hi1.
by have := h (i %/ 64) _ i _ _; smt(divz_eq modz_ge0 ltz_pmod).
qed.

lemma lanes_valid8E mv (f : int -> int) l : lanes_valid mv 8 f l =>
  is_valid (2 ^ 64) mv (f 0) l /\ is_valid (2 ^ 64) mv (f 1) l /\ is_valid (2 ^ 64) mv (f 2) l
  /\ is_valid (2 ^ 64) mv (f 3) l /\ is_valid (2 ^ 64) mv (f 4) l /\ is_valid (2 ^ 64) mv (f 5) l
  /\ is_valid (2 ^ 64) mv (f 6) l /\ is_valid (2 ^ 64) mv (f 7) l.
proof. by move=> h; do 7!(split; 1: by apply h); apply h. qed.

(* Integer steps of the absorb proofs. They stand apart so that each SMT
   call sees only its own premises, not the context of a procedure proof. *)
lemma head_lt (a b : int) : a <= b => a <> b => a < b.
proof. smt(). qed.

lemma head_rest (f n l b : int) :
  (f = 0 => n = 0) => (f <> 0 => f + n <> b => n = l) => f + n <> b => f + n <> 0 => n = l.
proof. smt(). qed.

lemma head_mod (f n l t b : int) :
  f = t %% b => (f + n + (l - n)) %% b = (t %% b + l) %% b.
proof. smt(). qed.

lemma rest_small (f l o m b : int) :
  0 <= f < m => f < b => o <= l => l - o < b => (f <> 0 => o = l) => 0 <= f + (l - o) < b.
proof. smt(). qed.

(* ------------------------------------------------------------------ *)
(* Eight-way SHA-256: state                                           *)

(* Word 8 * j + k of the interleaved state is word j of lane k. The
   loops write lane-major within a word index, so after j outer steps
   the first 8 * j words are written. *)
lemma __sha256_x8_init_proof _h _b_h : __sha256_x8_init_spec _h _b_h.
proof.
rewrite /__sha256_x8_init_spec; proc.
while (valid trace___sha256_x8_init /\ 0 <= j <= 8 /\ BArray256.is_init b_h 0 (4 * (8 * j))).
+ wp; while (valid trace___sha256_x8_init /\ 0 <= j < 8 /\ 0 <= k <= 8
             /\ BArray256.is_init b_h 0 (4 * (8 * j + k))).
  + auto => /> &m _ hj0 hj8 hk0 hk8 hh hlt.
    have hm := mask256_set32 b_h{m} (8 * j{m} + k{m}) hh _ _; 1,2: smt().
    rewrite (mulzC (8 * j{m} + k{m}) 4).
    by rewrite (_ : 4 * (8 * j{m} + (k{m} + 1)) = 4 * (8 * j{m} + k{m} + 1)) 1:/#; smt().
  auto => /> &m _ hj0 hj8 hh hlt; split; 1: smt().
  move=> b0 k0 tr0 hlt0 _ hk0 hk8 hh0; split; 1: smt().
  by have <- : 4 * (8 * j{m} + k0) = 4 * (8 * (j{m} + 1)) by smt().
auto => /> *; split; 1: by move=> j /#.
by move=> b0 j0 tr0 hlt _ hj0 hj8 hh; have <- : 4 * (8 * j0) = 256 by smt().
qed.

(* The buffer holds lane k at bytes 64 * k to 64 * k + 63, and is
   written transposed: word i of every lane, then word i + 1. The mask
   invariant is stated per byte, by lane offset c %% 64. *)
lemma __sha256_x8_from_proof _h _b_h _buf _b_buf _hs _b_hs _bs _b_bs :
  __sha256_x8_from_spec _h _b_h _buf _b_buf _hs _b_hs _bs _b_bs.
proof.
rewrite /__sha256_x8_from_spec; proc.
while (valid trace___sha256_x8_from /\ 0 <= i <= 8 /\ BArray256.is_init b_h 0 256
       /\ forall c, 0 <= c < 512 => c %% 64 < 8 * i => BArray512.is_init_cell b_buf c).
+ wp; while (valid trace___sha256_x8_from /\ 0 <= i < 8 /\ 0 <= k <= 8
             /\ BArray256.is_init b_h 0 256
             /\ forall c, 0 <= c < 512 => (c %% 64 < 8 * i \/ c %% 64 < 8 * i + 8 /\ c %/ 64 < k)
                  => BArray512.is_init_cell b_buf c).
  + auto => /> &m _ hi0 hi8 hk0 hk8 hh hb hlt.
    split; 1: smt().
    split; 1: smt().
    move=> c hc0 hc1 hc.
    case: (c %% 64 < 8 * i{m} \/ c %% 64 < 8 * i{m} + 8 /\ c %/ 64 < k{m}) => hcase.
    + by right; apply hb.
    by left; smt(divz_eq modz_ge0 ltz_pmod).
  auto => /> &m _ hi0 hi8 hh hb hlt.
  split.
  + split; 1: smt().
    by move=> c hc0 hc1 [hc|hc]; [apply hb | smt()].
  move=> b0 k0 tr0 hlt0 _ hk0 hk8 hb0; split; 1: smt().
  move=> c hc0 hc1 hc; apply hb0 => //.
  case: (c %% 64 < 8 * i{m}) => hci; [by left | right; smt(divz_eq modz_ge0 ltz_pmod)].
wp; while (valid trace___sha256_x8_from /\ 0 <= j <= 8 /\ BArray256.is_init b_h 0 (4 * (8 * j))).
+ wp; while (valid trace___sha256_x8_from /\ 0 <= j < 8 /\ 0 <= k <= 8
             /\ BArray256.is_init b_h 0 (4 * (8 * j + k))).
  + auto => /> &m _ hj0 hj8 hk0 hk8 hh hlt.
    have hm := mask256_set32 b_h{m} (8 * j{m} + k{m}) hh _ _; 1,2: smt().
    rewrite (mulzC (8 * j{m} + k{m}) 4).
    by rewrite (_ : 4 * (8 * j{m} + (k{m} + 1)) = 4 * (8 * j{m} + k{m} + 1)) 1:/#; smt().
  auto => /> &m _ hj0 hj8 hh hlt; split; 1: smt().
  move=> b0 k0 tr0 hlt0 _ hk0 hk8 hh0; split; 1: smt().
  by have <- : 4 * (8 * j{m} + k0) = 4 * (8 * (j{m} + 1)) by smt().
auto => /> hs hbs; split; 1: by move=> j /#.
move=> b0 j0 tr0 hlt _ hj0 hj8 hh.
have hh256 : BArray256.is_init b0 0 256 by have <- : 4 * (8 * j0) = 256 by smt().
split; 1: by split; [done | smt(modz_ge0)].
by move=> b1 i0 tr1 hlt1 _ hi0 hi8 _ hb c hc0 hc1; apply hb => //; smt(ltz_pmod).
qed.

(* ------------------------------------------------------------------ *)
(* Eight-way SHA-256: absorb                                          *)

(* The lane kernel contract with the per-lane conditions folded. *)
lemma _sha256_x8_compress_lanes_lv _h8 _in _off _n _ms :
  hoare [M._sha256_x8_compress_lanes :
    h8 = _h8 /\ b_h8 = full256 /\ in_0 = _in /\ b_in = full64 /\ off = _off /\ n = _n
    /\ ms = _ms /\ _n \ult W64.of_int 288230376151711744 /\ _off \ult W64.of_int 2305843009213693952
    /\ lanes_valid Glob.mem_v 8 (fun i => to_uint (BArray64.get64 _in i + _off))
         (to_uint (W64.of_int 64 * _n))
    ==> BArray256.is_init res.`2 0 256 /\ valid res.`4].
proof.
have := _sha256_x8_compress_lanes_proof _h8 full256 _in full64 _off _n _ms.
rewrite /_sha256_x8_compress_lanes_spec => h; conseq h => />.
move=> &m _ -> _ -> _ _ _ hn ho hlv; have := lanes_valid8E _ _ _ hlv.
rewrite /is_valid /= => [#] *.
by do !split => //; try apply full64_init; try apply full256_init; move=> i h1 h2; smt().
qed.

(* The single-way absorb of SafetySha256, lane by lane: every lane has
   the same fill f and length, so one head computation serves all. *)
lemma _sha256_x8_absorb_lanes_proof _h _b_h _buf _b_buf _total _in _b_in _inlen _ms :
  _sha256_x8_absorb_lanes_spec _h _b_h _buf _b_buf _total _in _b_in _inlen _ms.
proof.
rewrite /_sha256_x8_absorb_lanes_spec; proc; sp.
seq 1 : (valid trace__sha256_x8_absorb_lanes /\ total = _total + _inlen /\ in_0 = _in
         /\ inlen = _inlen /\ _inlen \ult W64.of_int 2305843009213693952
         /\ to_uint fill = to_uint _total %% 64 /\ to_uint fill + to_uint n <= 64
         /\ to_uint n <= to_uint _inlen /\ (to_uint fill = 0 => to_uint n = 0)
         /\ (to_uint fill <> 0 => to_uint fill + to_uint n <> 64 => to_uint n = to_uint _inlen)
         /\ lanes b_buf 8 64 8 (to_uint fill + to_uint n) (to_uint fill + to_uint n)
         /\ lanes_valid Glob.mem_v 8 (fun i => to_uint (BArray64.get64 _in i)) (to_uint _inlen)).
+ while (valid trace__sha256_x8_absorb_lanes /\ 0 <= k <= 8 /\ total = _total + _inlen
         /\ in_0 = _in /\ inlen = _inlen /\ _inlen \ult W64.of_int 2305843009213693952
         /\ to_uint fill = to_uint _total %% 64 /\ to_uint fill + to_uint n <= 64
         /\ to_uint n <= to_uint _inlen /\ (to_uint fill = 0 => to_uint n = 0)
         /\ (to_uint fill <> 0 => to_uint fill + to_uint n <> 64 => to_uint n = to_uint _inlen)
         /\ lanes b_buf 8 64 k (to_uint fill) (to_uint fill + to_uint n)
         /\ lanes_valid Glob.mem_v 8 (fun i => to_uint (BArray64.get64 _in i)) (to_uint _inlen)).
  + wp; ecall (__fill64_mem_proof param_3 b_param_1 param_2 param_1 param_0 param).
    auto => /> &m _ hk0 hk8 hult hf hfn hnl hf0 hfl hl hlv hlt.
    have := hlv k{m} _; 1: smt().
    rewrite /is_valid /= => -[hv1 [hv2 hv3]].
    have efn : to_uint (fill{m} + n{m}) = to_uint fill{m} + to_uint n{m}.
    + by rewrite W64.to_uintD_small; smt(W64.to_uint_cmp).
    rewrite /protect_64 !W64.uleE /= efn.
    split.
    + split.
      + split; 1: smt(W64.to_uint_cmp).
        by apply (lanes64_get _ _ _ _ hl); smt(W64.to_uint_cmp).
      by split; [move=> i h1 h2; apply hv1 | split]; smt().
    move=> _ _ _ _ _ _ _ r hr _; split; 1: smt().
    split; 1: smt().
    by apply (lanes64_set _ _ _ _ _ hl) => //; smt(W64.to_uint_cmp).
  auto => /> &m _ _ _ _ _ _ _ _ hh hb0 hb1 hb2 hb3 hb4 hb5 hb6 hb7 hult hin.
  move=> v00 v01 v02 v10 v11 v12 v20 v21 v22 v30 v31 v32 v40 v41 v42 v50 v51 v52.
  move=> v60 v61 v62 v70 v71 v72.
  pose f := _total `&` W64.of_int 63.
  pose nn := if f = W64.of_int 0 then f
             else if inlen{m} \ult W64.of_int 64 - f then inlen{m} else W64.of_int 64 - f.
  have [#] hf hfn hnl hln hf0 hfl := absorb_head256 _total inlen{m} f nn _ _ => //.
  have hl8 := lanes8I _ _ hb0 hb1 hb2 hb3 hb4 hb5 hb6 hb7.
  move: hl8; rewrite umodc // -hf => hl8.
  split.
  + do 5!(split; 1: done).
    split; 1: exact (lanes_start _ _ _ _ _ hl8).
    by apply lanes_valid8; rewrite /is_valid /=; do !split => //.
  move=> b0 k0 tr0 hlt _ hk0 hk8 _ _ _ _ _ hb hlv.
  have ->> : k0 = 8 by smt().
  exact (lanes_end _ _ _ _ _ hb).
sp; seq 1 : (valid trace__sha256_x8_absorb_lanes /\ total = _total + _inlen /\ in_0 = _in
             /\ inlen = _inlen /\ _inlen \ult W64.of_int 2305843009213693952
             /\ to_uint fill < 64 /\ lanes b_buf 8 64 8 (to_uint fill) (to_uint fill)
             /\ to_uint off <= to_uint _inlen /\ (to_uint fill <> 0 => to_uint off = to_uint _inlen)
             /\ (to_uint fill + (to_uint _inlen - to_uint off)) %% 64
                = (to_uint _total %% 64 + to_uint _inlen) %% 64
             /\ lanes_valid Glob.mem_v 8 (fun i => to_uint (BArray64.get64 _in i)) (to_uint _inlen)).
+ if.
  + wp; ecall (_sha256_x8_compress_proof param_6 full256 param_5 b_param_0 param_4).
    auto => /> &m f0 _ hult hf hfn hnl hf0 hfl hl hlv hfull.
    have efn : to_uint (f0 + n{m}) = to_uint f0 + to_uint n{m}.
    + by rewrite W64.to_uintD_small; smt(W64.to_uint_cmp).
    have e64 : to_uint f0 + to_uint n{m} = 64 by rewrite -efn hfull.
    move: hl; rewrite e64 => hl; rewrite (lanes8_full _ hl).
    split; 1: by split; [exact (full256_init 0 256) | exact (full512_init 0 512)].
    move=> _ _ r h3 _; split; 1: exact (lanes_full 8 64 8 0 0).
    rewrite /protect_64 (_ : to_uint _total %% 64 + to_uint inlen{m}
                             = (to_uint inlen{m} - to_uint n{m}) + 1 * 64) 1:/#.
    by rewrite modzMDr.
  auto => /> &m f0 _ hult hf hfn hnl hf0 hfl hl hlv hfull.
  have efn : to_uint (f0 + n{m}) = to_uint f0 + to_uint n{m}.
  + by rewrite W64.to_uintD_small; smt(W64.to_uint_cmp).
  have h64 : to_uint f0 + to_uint n{m} <> 64.
  + by move: hfull; rewrite W64.to_uint_eq efn; smt(W64.of_uintK w64_modulus).
  rewrite efn; split; 1: exact (head_lt _ _ hfn h64).
  split; 1: exact hl.
  by split; [exact (head_rest _ _ _ _ hf0 hfl h64) | exact (head_mod _ _ _ _ _ hf)].
sp; seq 1 : (valid trace__sha256_x8_absorb_lanes /\ total = _total + _inlen /\ in_0 = _in
             /\ inlen = _inlen /\ to_uint off <= to_uint _inlen
             /\ to_uint fill + (to_uint _inlen - to_uint off)
                = (to_uint _total %% 64 + to_uint _inlen) %% 64
             /\ lanes b_buf 8 64 8 (to_uint fill) (to_uint fill)
             /\ lanes_valid Glob.mem_v 8 (fun i => to_uint (BArray64.get64 _in i)) (to_uint _inlen)).
+ if.
  + wp; ecall (_sha256_x8_compress_lanes_lv param_11 param_10 param_9 param_8 param_7).
    auto => /> &m _ hult hf hl ho hf0 hm hlv hnz.
    have eLO : to_uint (_inlen - off{m}) = to_uint _inlen - to_uint off{m}.
    + by rewrite W64.to_uintB 1:W64.uleE.
    have hn : to_uint (_inlen - off{m} `>>` W8.of_int 6)
              = (to_uint _inlen - to_uint off{m}) %/ 64.
    + by rewrite -eLO; have := shrc (_inlen - off{m}) 6 _.
    have hn1 := nonzero _ hnz.
    have hdm := divz_eq (to_uint _inlen - to_uint off{m}) 64.
    have hmd := modz_ge0 (to_uint _inlen - to_uint off{m}) 64 _; 1: done.
    have hlt : to_uint _inlen < 2305843009213693952 by move: hult; rewrite W64.ultE.
    have e := mulc_small (_inlen - off{m} `>>` W8.of_int 6) 64 _ _; 1: done.
    + by rewrite hn; smt(W64.to_uint_cmp).
    have hb : to_uint ((_inlen - off{m} `>>` W8.of_int 6) `<<` W8.of_int 6)
              = 64 * ((to_uint _inlen - to_uint off{m}) %/ 64).
    + by rewrite -eLO; have := blocksc (_inlen - off{m}) 6 _.
    split.
    + split; 1: by rewrite W64.ultE hn; smt(W64.to_uint_cmp).
      split; 1: by rewrite W64.ultE; smt(W64.to_uint_cmp).
      move=> k hk; have := hlv k hk; rewrite /is_valid /= => -[hv1 [hv2 hv3]].
      have ep : to_uint (get64d _in (8 * k) + off{m})
                = to_uint (get64d _in (8 * k)) + to_uint off{m}.
      + by rewrite W64.to_uintD_small; smt(W64.to_uint_cmp w64_modulus).
      have hq : 64 * ((to_uint _inlen - to_uint off{m}) %/ 64) <= to_uint _inlen - to_uint off{m}.
      + by rewrite {2}hdm; smt().
      have ho0 := W64.to_uint_cmp off{m}.
      rewrite ep e hn; split.
      + by move=> i [hi0 hi1]; apply hv1; split; smt().
      smt().
    move=> _ _ _ r h3 _; rewrite /protect_64.
    have eo : to_uint (off{m} + ((_inlen - off{m} `>>` W8.of_int 6) `<<` W8.of_int 6))
              = to_uint off{m} + 64 * ((to_uint _inlen - to_uint off{m}) %/ 64).
    + by rewrite W64.to_uintD_small hb; smt(W64.to_uint_cmp).
    rewrite eo.
    have hz : to_uint fill{m} = 0 by smt(W64.to_uint_cmp).
    split; 1: smt().
    split; 2: exact (lanes0 b_buf{m} 8 64 8).
    rewrite (_ : to_uint _inlen - (to_uint off{m} + 64 * ((to_uint _inlen - to_uint off{m}) %/ 64))
                 = (to_uint _inlen - to_uint off{m}) %% 64) 1:/#.
    by move: hm; rewrite hz.
  auto => /> &m _ hult hf hl ho hf0 hm hlv hz.
  have eLO : to_uint (_inlen - off{m}) = to_uint _inlen - to_uint off{m}.
  + by rewrite W64.to_uintB 1:W64.uleE.
  have hn : (to_uint _inlen - to_uint off{m}) %/ 64 = 0.
  + have := shrc (_inlen - off{m}) 6 _; 1: done.
    by rewrite hz W64.to_uint0 eLO => ->.
  have hl64 : to_uint _inlen - to_uint off{m} < 64 by smt(divz_eq modz_ge0 ltz_pmod).
  by rewrite -hm pmod_small //; exact (rest_small _ _ _ _ _ (W64.to_uint_cmp fill{m}) hf ho hl64 hf0).
wp; while (valid trace__sha256_x8_absorb_lanes /\ 0 <= k <= 8 /\ total = _total + _inlen
           /\ in_0 = _in /\ inlen = _inlen
           /\ n = _inlen - off /\ to_uint off <= to_uint _inlen
           /\ to_uint fill + (to_uint _inlen - to_uint off)
              = (to_uint _total %% 64 + to_uint _inlen) %% 64
           /\ lanes b_buf 8 64 k (to_uint fill) (to_uint fill + (to_uint _inlen - to_uint off))
           /\ lanes_valid Glob.mem_v 8 (fun i => to_uint (BArray64.get64 _in i)) (to_uint _inlen)).
+ wp; ecall (__fill64_mem_proof param_16 b_param param_15 param_14 param_13 param_12).
  auto => /> &m _ hk0 hk8 ho hs hl hlv hlt.
  have := hlv k{m} _; 1: smt().
  rewrite /is_valid /= => -[hv1 [hv2 hv3]].
  have eLO : to_uint (_inlen - off{m}) = to_uint _inlen - to_uint off{m}.
  + by rewrite W64.to_uintB 1:W64.uleE.
  have hfl : to_uint fill{m} + (to_uint _inlen - to_uint off{m}) < 64 by rewrite hs; smt(modz_cmp).
  have efn : to_uint (fill{m} + (_inlen - off{m}))
             = to_uint fill{m} + (to_uint _inlen - to_uint off{m}).
  + by rewrite W64.to_uintD_small eLO; smt(W64.to_uint_cmp).
  have ep : to_uint (get64d _in (8 * k{m}) + off{m})
            = to_uint (get64d _in (8 * k{m})) + to_uint off{m}.
  + by rewrite W64.to_uintD_small; smt(W64.to_uint_cmp).
  rewrite /protect_64 !W64.uleE /= efn eLO ep.
  split.
  + split.
    + split; 1: smt(W64.to_uint_cmp).
      by apply (lanes64_get _ _ _ _ hl); smt(W64.to_uint_cmp).
    by split; [move=> i h1 h2; apply hv1 | split]; smt(W64.to_uint_cmp).
  move=> _ _ _ _ _ _ _ r hr _; split; 1: smt().
  split; 1: smt().
  by apply (lanes64_set _ _ _ _ _ hl) => //; smt(W64.to_uint_cmp).
auto => /> &m _ ho hs hl hlv; split; 1: exact (lanes_start _ _ _ _ _ hl).
move=> b0 k0 tr0 hlt _ hk0 hk8 hb.
have ->> : k0 = 8 by smt().
have e4 : to_uint ((_total + _inlen) \umod W64.of_int 64)
          = (to_uint _total %% 64 + to_uint _inlen) %% 64.
+ rewrite umodc // W64.to_uintD w64_modulus.
  by rewrite (modz_dvd _ _ 64) // modzDml.
rewrite e4 -hs.
have [#] h0 h1 h2 h3 h4 h5 h6 h7 := lanes8E _ _ (lanes_end _ _ _ _ _ hb).
by rewrite (full256_init 0 256) h0 h1 h2 h3 h4 h5 h6 h7.
qed.

(* ------------------------------------------------------------------ *)
(* Eight-way SHA-256: padding and output                              *)

lemma _sha256_x8_finalize_proof _out _b_out _h _b_h _buf _b_buf _total _ms :
  _sha256_x8_finalize_spec _out _b_out _h _b_h _buf _b_buf _total _ms.
proof.
rewrite /_sha256_x8_finalize_spec; proc; sp.
seq 1 : (valid trace__sha256_x8_finalize /\ to_uint fill = to_uint total %% 64
         /\ lanes b_buf 8 64 8 (to_uint fill + 1) (to_uint fill + 1)).
+ while (valid trace__sha256_x8_finalize /\ 0 <= k <= 8
         /\ to_uint fill = to_uint total %% 64 /\ to_uint at = to_uint fill + 64 * k
         /\ lanes b_buf 8 64 k (to_uint fill) (to_uint fill + 1)).
  + auto => /> &m _ hk0 hk8 hf ha hl hlt.
    have hf64 : to_uint fill{m} < 64 by smt(modz_cmp).
    split; 1: smt().
    split; 1: smt().
    split; 1: by rewrite W64.to_uintD_small; smt(W64.to_uint_cmp).
    rewrite ha (_ : to_uint fill{m} + 64 * k{m} = 64 * k{m} + to_uint fill{m}) 1:/#.
    by apply (lanes8_set8 _ _ _ hl); smt(W64.to_uint_cmp).
  auto => /> hh hb0 hb1 hb2 hb3 hb4 hb5 hb6 hb7.
  have hf := and63 _total.
  have hl8 := lanes8I _ _ hb0 hb1 hb2 hb3 hb4 hb5 hb6 hb7.
  move: hl8; rewrite umodc // -hf => hl8.
  split; 1: by split; [done | exact (lanes_start _ _ _ _ _ hl8)].
  move=> a0 b0 k0 tr0 hlt _ hk0 hk8 _ ha hb.
  have ->> : k0 = 8 by smt().
  exact (lanes_end _ _ _ _ _ hb).
sp; seq 1 : (valid trace__sha256_x8_finalize /\ to_uint fill <= 56
             /\ lanes b_buf 8 64 8 (to_uint fill) (to_uint fill)).
+ if.
  + wp; ecall (_sha256_x8_compress_proof param_5 full256 param_4 b_param_1 param_3).
    wp; while (valid trace__sha256_x8_finalize /\ 0 <= k <= 8 /\ hi = W64.of_int 64
               /\ to_uint fill <= 64 /\ lanes b_buf 8 64 k (to_uint fill) 64).
    + wp; ecall (__zero64_proof param_2 b_param_2 param_1 param_0 param).
      auto => /> &m _ hk0 hk8 hf hl hlt.
      rewrite W64.uleE /=; split.
      + by split; [smt() | apply (lanes64_get _ _ _ _ hl); smt(W64.to_uint_cmp)].
      move=> _ _ r hr _; split; 1: smt().
      split; 1: smt().
      by apply (lanes64_set _ _ _ _ _ hl) => //; smt(W64.to_uint_cmp).
    auto => /> &m f0 _ hf hl h56.
    have e : to_uint (f0 + W64.one) = to_uint f0 + 1.
    + by rewrite W64.to_uintD_small to_uint_one //; smt(modz_cmp W64.to_uint_cmp).
    rewrite e; split; 1: by split; [smt(modz_cmp) | exact (lanes_start _ _ _ _ _ hl)].
    move=> b0 k0 tr0 hlt _ hk0 hk8 _ hb.
    have ->> : k0 = 8 by smt().
    rewrite (lanes8_full _ (lanes_end _ _ _ _ _ hb)).
    split; 1: by split; [exact (full256_init 0 256) | exact (full512_init 0 512)].
    by move=> _ _ r h3 _; exact (lanes_full 8 64 8 0 0).
  auto => /> &m f0 _ hf hl h56.
  have e : to_uint (f0 + W64.one) = to_uint f0 + 1.
  + by rewrite W64.to_uintD_small to_uint_one //; smt(modz_cmp W64.to_uint_cmp).
  rewrite e; split; 2: done.
  by move: h56; rewrite W64.ultE e; smt().
wp; while (valid trace__sha256_x8_finalize /\ 0 <= k <= 8
           /\ BArray256.is_init b_out 0 (4 * (8 * k))).
+ wp; while (valid trace__sha256_x8_finalize /\ 0 <= k < 8 /\ 0 <= j <= 8
             /\ BArray256.is_init b_out 0 (4 * (8 * k + j))).
  + wp; ecall (__bswap32_proof param_14).
    auto => /> &m _ hk0 hk8 hj0 hj8 ho hlt r _.
    have hm := mask256_set32 b_out{m} (8 * k{m} + j{m}) ho _ _; 1,2: smt().
    rewrite (mulzC (8 * k{m} + j{m}) 4).
    by rewrite (_ : 4 * (8 * k{m} + (j{m} + 1)) = 4 * (8 * k{m} + j{m} + 1)) 1:/#; smt().
  auto => /> &m _ hk0 hk8 ho hlt.
  move=> b0 j0 tr0 hlt0 _ hj0 hj8 ho0; split; 1: smt().
  by have <- : 4 * (8 * k{m} + j0) = 4 * (8 * (k{m} + 1)) by smt().
wp; ecall (_sha256_x8_compress_proof param_13 full256 param_12 b_param param_11).
wp; while (valid trace__sha256_x8_finalize /\ 0 <= k <= 8 /\ lanes b_buf 8 64 k 56 64).
+ auto => /> &m _ hk0 hk8 hl hlt; split; 1: smt().
  split; 1: smt().
  by apply (lanes8_set64d _ _ hl); smt().
wp; ecall (__bswap64_proof param_10).
wp; while (valid trace__sha256_x8_finalize /\ 0 <= k <= 8 /\ hi = W64.of_int 56
           /\ to_uint fill <= 56 /\ lanes b_buf 8 64 k (to_uint fill) 56).
+ wp; ecall (__zero64_proof param_9 b_param_0 param_8 param_7 param_6).
  auto => /> &m _ hk0 hk8 hf hl hlt.
  rewrite W64.uleE /=; split.
  + by split; [smt() | apply (lanes64_get _ _ _ _ hl); smt(W64.to_uint_cmp)].
  move=> _ _ r hr _; split; 1: smt().
  split; 1: smt().
  by apply (lanes64_set _ _ _ _ _ hl) => //; smt(W64.to_uint_cmp).
auto => /> &m _ hf hl; split; 1: exact (lanes_start _ _ _ _ _ hl).
move=> b0 k0 tr0 hlt _ hk0 hk8 hb r _.
have ->> : k0 = 8 by smt().
have hb56 := lanes_end _ _ _ _ _ hb.
split; 1: exact (lanes_start _ _ _ _ _ hb56).
move=> b1 k1 tr1 hlt1 _ hk1 hk18 hb1.
have ->> : k1 = 8 by smt().
rewrite (lanes8_full _ (lanes_end _ _ _ _ _ hb1)).
split; 1: by split; [exact (full256_init 0 256) | exact (full512_init 0 512)].
move=> _ _ r0 h3 _; split; 1: by move=> j /#.
by move=> o0 k2 tr2 hlt2 _ hk2 hk28 ho; have <- : 4 * (8 * k2) = 256 by smt().
qed.

lemma _sha256_x8_lanes_proof _out _b_out _in _b_in _len _ms :
  _sha256_x8_lanes_spec _out _b_out _in _b_in _len _ms.
proof.
rewrite /_sha256_x8_lanes_spec; proc.
wp; ecall (_sha256_x8_finalize_proof param_10 b_param_0 param_9 full256 param_8 b_param
             param_7 param_6).
wp; ecall (_sha256_x8_absorb_lanes_proof param_5 full256 param_4 b_param_1 param_3 param_2
             full64 param_1 param_0).
wp; ecall (__sha256_x8_init_proof param b_param_2).
auto => /> &m *.
have e : to_uint (W64.zero \umod W64.of_int 64) = 0 by rewrite umodc // W64.to_uint0.
rewrite e.
do 8!(split; 1: exact full64_init).
split.
+ by do !split; try exact (full256_init 0 256); move=> j /#.
exact (full64_init 0 64).
qed.

(* ------------------------------------------------------------------ *)
(* Four-way SHA-512: lane masks                                       *)

lemma lanes4I (m : BArray512.t) l :
  BArray512.is_init m 0 l => BArray512.is_init m 128 l => BArray512.is_init m 256 l =>
  BArray512.is_init m 384 l => lanes m 4 128 4 l l.
proof.
move=> h0 h1 h2 h3 j hj; rewrite (_ : (if j < 4 then l else l) = l) 1:/#.
have : j = 0 \/ j = 1 \/ j = 2 \/ j = 3 by smt().
by case=> [->|[->|[->|->]]].
qed.

lemma lanes4E (m : BArray512.t) l : lanes m 4 128 4 l l =>
  BArray512.is_init m 0 l /\ BArray512.is_init m 128 l /\ BArray512.is_init m 256 l
  /\ BArray512.is_init m 384 l.
proof. by move=> h; do !split; [have := h 0 | have := h 1 | have := h 2 | have := h 3]. qed.

lemma lanes4_full (m : BArray512.t) : lanes m 4 128 4 128 128 => m = full512.
proof.
move=> h; apply full512E => i hi0 hi1.
by have := h (i %/ 128) _ i _ _; smt(divz_eq modz_ge0 ltz_pmod).
qed.

lemma lanes_valid4E mv (f : int -> int) l : lanes_valid mv 4 f l =>
  is_valid (2 ^ 64) mv (f 0) l /\ is_valid (2 ^ 64) mv (f 1) l /\ is_valid (2 ^ 64) mv (f 2) l
  /\ is_valid (2 ^ 64) mv (f 3) l.
proof. by move=> h; do 3!(split; 1: by apply h); apply h. qed.

(* The two length words of lane k, at offsets 112 and 120. *)
lemma lanes4_set112 (m : BArray512.t) k :
  lanes m 4 128 k 112 128 => 0 <= k < 4 =>
  lanes (BArray512.set64d (BArray512.set64d m (128 * k + 112) (W64.of_int 18446744073709551615))
           (128 * k + 120) (W64.of_int 18446744073709551615)) 4 128 (k + 1) 112 128.
proof.
move=> h hk j hj i hi0 hi1; rewrite !BArray512.is_init_cell_set64d.
case: (128 * k + 112 <= i < 128 * k + 128) => hi; 1: smt().
by right; right; have := h j hj i _ _; [smt() | smt() | smt()].
qed.

(* The lane kernel contract with the per-lane conditions folded. *)
lemma _sha512_x4_compress_lanes_lv _h4 _in _off _n _ms :
  hoare [M._sha512_x4_compress_lanes :
    h4 = _h4 /\ b_h4 = full256 /\ in_0 = _in /\ b_in = full32 /\ off = _off /\ n = _n
    /\ ms = _ms /\ _n \ult W64.of_int 144115188075855872 /\ _off \ult W64.of_int 2305843009213693952
    /\ lanes_valid Glob.mem_v 4 (fun i => to_uint (BArray32.get64 _in i + _off))
         (to_uint (W64.of_int 128 * _n))
    ==> BArray256.is_init res.`2 0 256 /\ valid res.`4].
proof.
have := _sha512_x4_compress_lanes_proof _h4 full256 _in full32 _off _n _ms.
rewrite /_sha512_x4_compress_lanes_spec => h; conseq h => />.
move=> &m _ -> _ -> _ _ _ hn ho hlv; have := lanes_valid4E _ _ _ hlv.
rewrite /is_valid /= => [#] *.
by do !split => //; try apply full32_init; try apply full256_init; move=> i h1 h2; smt().
qed.

(* ------------------------------------------------------------------ *)
(* Four-way SHA-512: state                                            *)

(* Word 4 * j + k of the interleaved state is word j of lane k. *)
lemma __sha512_x4_init_proof _h _b_h : __sha512_x4_init_spec _h _b_h.
proof.
rewrite /__sha512_x4_init_spec; proc.
while (valid trace___sha512_x4_init /\ 0 <= j <= 8 /\ BArray256.is_init b_h 0 (8 * (4 * j))).
+ wp; while (valid trace___sha512_x4_init /\ 0 <= j < 8 /\ 0 <= k <= 4
             /\ BArray256.is_init b_h 0 (8 * (4 * j + k))).
  + auto => /> &m _ hj0 hj8 hk0 hk8 hh hlt.
    have hm := mask256_set64 b_h{m} (4 * j{m} + k{m}) hh _ _; 1,2: smt().
    rewrite (mulzC (4 * j{m} + k{m}) 8).
    by rewrite (_ : 8 * (4 * j{m} + (k{m} + 1)) = 8 * (4 * j{m} + k{m} + 1)) 1:/#; smt().
  auto => /> &m _ hj0 hj8 hh hlt; split; 1: smt().
  move=> b0 k0 tr0 hlt0 _ hk0 hk8 hh0; split; 1: smt().
  by have <- : 8 * (4 * j{m} + k0) = 8 * (4 * (j{m} + 1)) by smt().
auto => /> *; split; 1: by move=> j /#.
by move=> b0 j0 tr0 hlt _ hj0 hj8 hh; have <- : 8 * (4 * j0) = 256 by smt().
qed.

lemma __sha512_x4_from_proof _h _b_h _buf _b_buf _hs _b_hs _bs _b_bs :
  __sha512_x4_from_spec _h _b_h _buf _b_buf _hs _b_hs _bs _b_bs.
proof.
rewrite /__sha512_x4_from_spec; proc.
while (valid trace___sha512_x4_from /\ 0 <= i <= 16 /\ BArray256.is_init b_h 0 256
       /\ forall c, 0 <= c < 512 => c %% 128 < 8 * i => BArray512.is_init_cell b_buf c).
+ wp; while (valid trace___sha512_x4_from /\ 0 <= i < 16 /\ 0 <= k <= 4
             /\ BArray256.is_init b_h 0 256
             /\ forall c, 0 <= c < 512 => (c %% 128 < 8 * i \/ c %% 128 < 8 * i + 8 /\ c %/ 128 < k)
                  => BArray512.is_init_cell b_buf c).
  + auto => /> &m _ hi0 hi8 hk0 hk8 hh hb hlt.
    split; 1: smt().
    split; 1: smt().
    move=> c hc0 hc1 hc.
    case: (c %% 128 < 8 * i{m} \/ c %% 128 < 8 * i{m} + 8 /\ c %/ 128 < k{m}) => hcase.
    + by right; apply hb.
    by left; smt(divz_eq modz_ge0 ltz_pmod).
  auto => /> &m _ hi0 hi8 hh hb hlt.
  split.
  + split; 1: smt().
    by move=> c hc0 hc1 [hc|hc]; [apply hb | smt()].
  move=> b0 k0 tr0 hlt0 _ hk0 hk8 hb0; split; 1: smt().
  move=> c hc0 hc1 hc; apply hb0 => //.
  case: (c %% 128 < 8 * i{m}) => hci; [by left | right; smt(divz_eq modz_ge0 ltz_pmod)].
wp; while (valid trace___sha512_x4_from /\ 0 <= j <= 8 /\ BArray256.is_init b_h 0 (8 * (4 * j))).
+ wp; while (valid trace___sha512_x4_from /\ 0 <= j < 8 /\ 0 <= k <= 4
             /\ BArray256.is_init b_h 0 (8 * (4 * j + k))).
  + auto => /> &m _ hj0 hj8 hk0 hk8 hh hlt.
    have hm := mask256_set64 b_h{m} (4 * j{m} + k{m}) hh _ _; 1,2: smt().
    rewrite (mulzC (4 * j{m} + k{m}) 8).
    by rewrite (_ : 8 * (4 * j{m} + (k{m} + 1)) = 8 * (4 * j{m} + k{m} + 1)) 1:/#; smt().
  auto => /> &m _ hj0 hj8 hh hlt; split; 1: smt().
  move=> b0 k0 tr0 hlt0 _ hk0 hk8 hh0; split; 1: smt().
  by have <- : 8 * (4 * j{m} + k0) = 8 * (4 * (j{m} + 1)) by smt().
auto => /> hs hbs; split; 1: by move=> j /#.
move=> b0 j0 tr0 hlt _ hj0 hj8 hh.
have hh256 : BArray256.is_init b0 0 256 by have <- : 8 * (4 * j0) = 256 by smt().
split; 1: by split; [done | smt(modz_ge0)].
by move=> b1 i0 tr1 hlt1 _ hi0 hi8 _ hb c hc0 hc1; apply hb => //; smt(ltz_pmod).
qed.

(* ------------------------------------------------------------------ *)
(* Four-way SHA-512: absorb                                           *)

(* The single-way absorb of SafetySha512, lane by lane: every lane has
   the same fill f and length, so one head computation serves all. *)
lemma _sha512_x4_absorb_lanes_proof _h _b_h _buf _b_buf _total _in _b_in _inlen _ms :
  _sha512_x4_absorb_lanes_spec _h _b_h _buf _b_buf _total _in _b_in _inlen _ms.
proof.
rewrite /_sha512_x4_absorb_lanes_spec; proc; sp.
seq 1 : (valid trace__sha512_x4_absorb_lanes /\ total = _total + _inlen /\ in_0 = _in
         /\ inlen = _inlen /\ _inlen \ult W64.of_int 2305843009213693952
         /\ to_uint fill = to_uint _total %% 128 /\ to_uint fill + to_uint n <= 128
         /\ to_uint n <= to_uint _inlen /\ (to_uint fill = 0 => to_uint n = 0)
         /\ (to_uint fill <> 0 => to_uint fill + to_uint n <> 128 => to_uint n = to_uint _inlen)
         /\ lanes b_buf 4 128 4 (to_uint fill + to_uint n) (to_uint fill + to_uint n)
         /\ lanes_valid Glob.mem_v 4 (fun i => to_uint (BArray32.get64 _in i)) (to_uint _inlen)).
+ while (valid trace__sha512_x4_absorb_lanes /\ 0 <= k <= 4 /\ total = _total + _inlen
         /\ in_0 = _in /\ inlen = _inlen /\ _inlen \ult W64.of_int 2305843009213693952
         /\ to_uint fill = to_uint _total %% 128 /\ to_uint fill + to_uint n <= 128
         /\ to_uint n <= to_uint _inlen /\ (to_uint fill = 0 => to_uint n = 0)
         /\ (to_uint fill <> 0 => to_uint fill + to_uint n <> 128 => to_uint n = to_uint _inlen)
         /\ lanes b_buf 4 128 k (to_uint fill) (to_uint fill + to_uint n)
         /\ lanes_valid Glob.mem_v 4 (fun i => to_uint (BArray32.get64 _in i)) (to_uint _inlen)).
  + wp; ecall (__fill128_mem_proof param_3 b_param_1 param_2 param_1 param_0 param).
    auto => /> &m _ hk0 hk8 hult hf hfn hnl hf0 hfl hl hlv hlt.
    have := hlv k{m} _; 1: smt().
    rewrite /is_valid /= => -[hv1 [hv2 hv3]].
    have efn : to_uint (fill{m} + n{m}) = to_uint fill{m} + to_uint n{m}.
    + by rewrite W64.to_uintD_small; smt(W64.to_uint_cmp).
    rewrite /protect_64 !W64.uleE /= efn.
    split.
    + split.
      + split; 1: smt(W64.to_uint_cmp).
        by apply (lanes128_get _ _ _ _ hl); smt(W64.to_uint_cmp).
      by split; [move=> i h1 h2; apply hv1 | split]; smt().
    move=> _ _ _ _ _ _ _ r hr _; split; 1: smt().
    split; 1: smt().
    by apply (lanes128_set _ _ _ _ _ hl) => //; smt(W64.to_uint_cmp).
  auto => /> &m _ _ _ _ hh hb0 hb1 hb2 hb3 hult hin.
  move=> v00 v01 v02 v10 v11 v12 v20 v21 v22 v30 v31 v32.
  pose f := _total `&` W64.of_int 127.
  pose nn := if f = W64.of_int 0 then f
             else if inlen{m} \ult W64.of_int 128 - f then inlen{m} else W64.of_int 128 - f.
  have [#] hf hfn hnl hln hf0 hfl := absorb_head512 _total inlen{m} f nn _ _ => //.
  have hl8 := lanes4I _ _ hb0 hb1 hb2 hb3.
  move: hl8; rewrite umodc // -hf => hl8.
  split.
  + do 5!(split; 1: done).
    split; 1: exact (lanes_start _ _ _ _ _ hl8).
    by apply lanes_valid4; rewrite /is_valid /=; do !split => //.
  move=> b0 k0 tr0 hlt _ hk0 hk8 _ _ _ _ _ hb hlv.
  have ->> : k0 = 4 by smt().
  exact (lanes_end _ _ _ _ _ hb).
sp; seq 1 : (valid trace__sha512_x4_absorb_lanes /\ total = _total + _inlen /\ in_0 = _in
             /\ inlen = _inlen /\ _inlen \ult W64.of_int 2305843009213693952
             /\ to_uint fill < 128 /\ lanes b_buf 4 128 4 (to_uint fill) (to_uint fill)
             /\ to_uint off <= to_uint _inlen /\ (to_uint fill <> 0 => to_uint off = to_uint _inlen)
             /\ (to_uint fill + (to_uint _inlen - to_uint off)) %% 128
                = (to_uint _total %% 128 + to_uint _inlen) %% 128
             /\ lanes_valid Glob.mem_v 4 (fun i => to_uint (BArray32.get64 _in i)) (to_uint _inlen)).
+ if.
  + wp; ecall (_sha512_x4_compress_proof param_6 full256 param_5 b_param_0 param_4).
    auto => /> &m f0 _ hult hf hfn hnl hf0 hfl hl hlv hfull.
    have efn : to_uint (f0 + n{m}) = to_uint f0 + to_uint n{m}.
    + by rewrite W64.to_uintD_small; smt(W64.to_uint_cmp).
    have e64 : to_uint f0 + to_uint n{m} = 128 by rewrite -efn hfull.
    move: hl; rewrite e64 => hl; rewrite (lanes4_full _ hl).
    split; 1: by split; [exact (full256_init 0 256) | exact (full512_init 0 512)].
    move=> _ _ r h3 _; split; 1: exact (lanes_full 4 128 4 0 0).
    rewrite /protect_64 (_ : to_uint _total %% 128 + to_uint inlen{m}
                             = (to_uint inlen{m} - to_uint n{m}) + 1 * 128) 1:/#.
    by rewrite modzMDr.
  auto => /> &m f0 _ hult hf hfn hnl hf0 hfl hl hlv hfull.
  have efn : to_uint (f0 + n{m}) = to_uint f0 + to_uint n{m}.
  + by rewrite W64.to_uintD_small; smt(W64.to_uint_cmp).
  have h64 : to_uint f0 + to_uint n{m} <> 128.
  + by move: hfull; rewrite W64.to_uint_eq efn; smt(W64.of_uintK w64_modulus).
  rewrite efn; split; 1: exact (head_lt _ _ hfn h64).
  split; 1: exact hl.
  by split; [exact (head_rest _ _ _ _ hf0 hfl h64) | exact (head_mod _ _ _ _ _ hf)].
sp; seq 1 : (valid trace__sha512_x4_absorb_lanes /\ total = _total + _inlen /\ in_0 = _in
             /\ inlen = _inlen /\ to_uint off <= to_uint _inlen
             /\ to_uint fill + (to_uint _inlen - to_uint off)
                = (to_uint _total %% 128 + to_uint _inlen) %% 128
             /\ lanes b_buf 4 128 4 (to_uint fill) (to_uint fill)
             /\ lanes_valid Glob.mem_v 4 (fun i => to_uint (BArray32.get64 _in i)) (to_uint _inlen)).
+ if.
  + wp; ecall (_sha512_x4_compress_lanes_lv param_11 param_10 param_9 param_8 param_7).
    auto => /> &m _ hult hf hl ho hf0 hm hlv hnz.
    have eLO : to_uint (_inlen - off{m}) = to_uint _inlen - to_uint off{m}.
    + by rewrite W64.to_uintB 1:W64.uleE.
    have hn : to_uint (_inlen - off{m} `>>` W8.of_int 7)
              = (to_uint _inlen - to_uint off{m}) %/ 128.
    + by rewrite -eLO; have := shrc (_inlen - off{m}) 7 _.
    have hn1 := nonzero _ hnz.
    have hdm := divz_eq (to_uint _inlen - to_uint off{m}) 128.
    have hmd := modz_ge0 (to_uint _inlen - to_uint off{m}) 128 _; 1: done.
    have hlt : to_uint _inlen < 2305843009213693952 by move: hult; rewrite W64.ultE.
    have e := mulc_small (_inlen - off{m} `>>` W8.of_int 7) 128 _ _; 1: done.
    + by rewrite hn; smt(W64.to_uint_cmp).
    have hb : to_uint ((_inlen - off{m} `>>` W8.of_int 7) `<<` W8.of_int 7)
              = 128 * ((to_uint _inlen - to_uint off{m}) %/ 128).
    + by rewrite -eLO; have := blocksc (_inlen - off{m}) 7 _.
    split.
    + split; 1: by rewrite W64.ultE hn; smt(W64.to_uint_cmp).
      split; 1: by rewrite W64.ultE; smt(W64.to_uint_cmp).
      move=> k hk; have := hlv k hk; rewrite /is_valid /= => -[hv1 [hv2 hv3]].
      have ep : to_uint (get64d _in (8 * k) + off{m})
                = to_uint (get64d _in (8 * k)) + to_uint off{m}.
      + by rewrite W64.to_uintD_small; smt(W64.to_uint_cmp w64_modulus).
      have hq : 128 * ((to_uint _inlen - to_uint off{m}) %/ 128) <= to_uint _inlen - to_uint off{m}.
      + by rewrite {2}hdm; smt().
      have ho0 := W64.to_uint_cmp off{m}.
      rewrite ep e hn; split.
      + by move=> i [hi0 hi1]; apply hv1; split; smt().
      smt().
    move=> _ _ _ r h3 _; rewrite /protect_64.
    have eo : to_uint (off{m} + ((_inlen - off{m} `>>` W8.of_int 7) `<<` W8.of_int 7))
              = to_uint off{m} + 128 * ((to_uint _inlen - to_uint off{m}) %/ 128).
    + by rewrite W64.to_uintD_small hb; smt(W64.to_uint_cmp).
    rewrite eo.
    have hz : to_uint fill{m} = 0 by smt(W64.to_uint_cmp).
    split; 1: smt().
    split; 2: exact (lanes0 b_buf{m} 4 128 4).
    rewrite (_ : to_uint _inlen - (to_uint off{m} + 128 * ((to_uint _inlen - to_uint off{m}) %/ 128))
                 = (to_uint _inlen - to_uint off{m}) %% 128) 1:/#.
    by move: hm; rewrite hz.
  auto => /> &m _ hult hf hl ho hf0 hm hlv hz.
  have eLO : to_uint (_inlen - off{m}) = to_uint _inlen - to_uint off{m}.
  + by rewrite W64.to_uintB 1:W64.uleE.
  have hn : (to_uint _inlen - to_uint off{m}) %/ 128 = 0.
  + have := shrc (_inlen - off{m}) 7 _; 1: done.
    by rewrite hz W64.to_uint0 eLO => ->.
  have hl64 : to_uint _inlen - to_uint off{m} < 128 by smt(divz_eq modz_ge0 ltz_pmod).
  by rewrite -hm pmod_small //; exact (rest_small _ _ _ _ _ (W64.to_uint_cmp fill{m}) hf ho hl64 hf0).
wp; while (valid trace__sha512_x4_absorb_lanes /\ 0 <= k <= 4 /\ total = _total + _inlen
           /\ in_0 = _in /\ inlen = _inlen
           /\ n = _inlen - off /\ to_uint off <= to_uint _inlen
           /\ to_uint fill + (to_uint _inlen - to_uint off)
              = (to_uint _total %% 128 + to_uint _inlen) %% 128
           /\ lanes b_buf 4 128 k (to_uint fill) (to_uint fill + (to_uint _inlen - to_uint off))
           /\ lanes_valid Glob.mem_v 4 (fun i => to_uint (BArray32.get64 _in i)) (to_uint _inlen)).
+ wp; ecall (__fill128_mem_proof param_16 b_param param_15 param_14 param_13 param_12).
  auto => /> &m _ hk0 hk8 ho hs hl hlv hlt.
  have := hlv k{m} _; 1: smt().
  rewrite /is_valid /= => -[hv1 [hv2 hv3]].
  have eLO : to_uint (_inlen - off{m}) = to_uint _inlen - to_uint off{m}.
  + by rewrite W64.to_uintB 1:W64.uleE.
  have hfl : to_uint fill{m} + (to_uint _inlen - to_uint off{m}) < 128 by rewrite hs; smt(modz_cmp).
  have efn : to_uint (fill{m} + (_inlen - off{m}))
             = to_uint fill{m} + (to_uint _inlen - to_uint off{m}).
  + by rewrite W64.to_uintD_small eLO; smt(W64.to_uint_cmp).
  have ep : to_uint (get64d _in (8 * k{m}) + off{m})
            = to_uint (get64d _in (8 * k{m})) + to_uint off{m}.
  + by rewrite W64.to_uintD_small; smt(W64.to_uint_cmp).
  rewrite /protect_64 !W64.uleE /= efn eLO ep.
  split.
  + split.
    + split; 1: smt(W64.to_uint_cmp).
      by apply (lanes128_get _ _ _ _ hl); smt(W64.to_uint_cmp).
    by split; [move=> i h1 h2; apply hv1 | split]; smt(W64.to_uint_cmp).
  move=> _ _ _ _ _ _ _ r hr _; split; 1: smt().
  split; 1: smt().
  by apply (lanes128_set _ _ _ _ _ hl) => //; smt(W64.to_uint_cmp).
auto => /> &m _ ho hs hl hlv; split; 1: exact (lanes_start _ _ _ _ _ hl).
move=> b0 k0 tr0 hlt _ hk0 hk8 hb.
have ->> : k0 = 4 by smt().
have e4 : to_uint ((_total + _inlen) \umod W64.of_int 128)
          = (to_uint _total %% 128 + to_uint _inlen) %% 128.
+ rewrite umodc // W64.to_uintD w64_modulus.
  by rewrite (modz_dvd _ _ 128) // modzDml.
rewrite e4 -hs.
have [#] h0 h1 h2 h3 := lanes4E _ _ (lanes_end _ _ _ _ _ hb).
by rewrite (full256_init 0 256) h0 h1 h2 h3.
qed.

(* ------------------------------------------------------------------ *)
(* Four-way SHA-512: padding and output                               *)

lemma _sha512_x4_finalize_proof _out _b_out _h _b_h _buf _b_buf _total _ms :
  _sha512_x4_finalize_spec _out _b_out _h _b_h _buf _b_buf _total _ms.
proof.
rewrite /_sha512_x4_finalize_spec; proc; sp.
seq 1 : (valid trace__sha512_x4_finalize /\ to_uint fill = to_uint total %% 128
         /\ lanes b_buf 4 128 4 (to_uint fill + 1) (to_uint fill + 1)).
+ while (valid trace__sha512_x4_finalize /\ 0 <= k <= 4
         /\ to_uint fill = to_uint total %% 128 /\ to_uint at = to_uint fill + 128 * k
         /\ lanes b_buf 4 128 k (to_uint fill) (to_uint fill + 1)).
  + auto => /> &m _ hk0 hk8 hf ha hl hlt.
    have hf64 : to_uint fill{m} < 128 by smt(modz_cmp).
    split; 1: smt().
    split; 1: smt().
    split; 1: by rewrite W64.to_uintD_small; smt(W64.to_uint_cmp).
    rewrite ha (_ : to_uint fill{m} + 128 * k{m} = 128 * k{m} + to_uint fill{m}) 1:/#.
    by apply (lanes4_set8 _ _ _ hl); smt(W64.to_uint_cmp).
  auto => /> hh hb0 hb1 hb2 hb3.
  have hf := and127 _total.
  have hl8 := lanes4I _ _ hb0 hb1 hb2 hb3.
  move: hl8; rewrite umodc // -hf => hl8.
  split; 1: by split; [done | exact (lanes_start _ _ _ _ _ hl8)].
  move=> a0 b0 k0 tr0 hlt _ hk0 hk8 _ ha hb.
  have ->> : k0 = 4 by smt().
  exact (lanes_end _ _ _ _ _ hb).
sp; seq 1 : (valid trace__sha512_x4_finalize /\ to_uint fill <= 112
             /\ lanes b_buf 4 128 4 (to_uint fill) (to_uint fill)).
+ if.
  + wp; ecall (_sha512_x4_compress_proof param_5 full256 param_4 b_param_1 param_3).
    wp; while (valid trace__sha512_x4_finalize /\ 0 <= k <= 4 /\ hi = W64.of_int 128
               /\ to_uint fill <= 128 /\ lanes b_buf 4 128 k (to_uint fill) 128).
    + wp; ecall (__zero128_proof param_2 b_param_2 param_1 param_0 param).
      auto => /> &m _ hk0 hk8 hf hl hlt.
      rewrite W64.uleE /=; split.
      + by split; [smt() | apply (lanes128_get _ _ _ _ hl); smt(W64.to_uint_cmp)].
      move=> _ _ r hr _; split; 1: smt().
      split; 1: smt().
      by apply (lanes128_set _ _ _ _ _ hl) => //; smt(W64.to_uint_cmp).
    auto => /> &m f0 _ hf hl h56.
    have e : to_uint (f0 + W64.one) = to_uint f0 + 1.
    + by rewrite W64.to_uintD_small to_uint_one //; smt(modz_cmp W64.to_uint_cmp).
    rewrite e; split; 1: by split; [smt(modz_cmp) | exact (lanes_start _ _ _ _ _ hl)].
    move=> b0 k0 tr0 hlt _ hk0 hk8 _ hb.
    have ->> : k0 = 4 by smt().
    rewrite (lanes4_full _ (lanes_end _ _ _ _ _ hb)).
    split; 1: by split; [exact (full256_init 0 256) | exact (full512_init 0 512)].
    by move=> _ _ r h3 _; exact (lanes_full 4 128 4 0 0).
  auto => /> &m f0 _ hf hl h56.
  have e : to_uint (f0 + W64.one) = to_uint f0 + 1.
  + by rewrite W64.to_uintD_small to_uint_one //; smt(modz_cmp W64.to_uint_cmp).
  rewrite e; split; 2: done.
  by move: h56; rewrite W64.ultE e; smt().
wp; while (valid trace__sha512_x4_finalize /\ 0 <= k <= 4
           /\ BArray256.is_init b_out 0 (8 * (8 * k))).
+ wp; while (valid trace__sha512_x4_finalize /\ 0 <= k < 4 /\ 0 <= j <= 8
             /\ BArray256.is_init b_out 0 (8 * (8 * k + j))).
  + wp; ecall (__bswap64_proof param_15).
    auto => /> &m _ hk0 hk8 hj0 hj8 ho hlt r _.
    have hm := mask256_set64 b_out{m} (8 * k{m} + j{m}) ho _ _; 1,2: smt().
    rewrite (mulzC (8 * k{m} + j{m}) 8).
    by rewrite (_ : 8 * (8 * k{m} + (j{m} + 1)) = 8 * (8 * k{m} + j{m} + 1)) 1:/#; smt().
  auto => /> &m _ hk0 hk8 ho hlt.
  move=> b0 j0 tr0 hlt0 _ hj0 hj8 ho0; split; 1: smt().
  by have <- : 8 * (8 * k{m} + j0) = 8 * (8 * (k{m} + 1)) by smt().
wp; ecall (_sha512_x4_compress_proof param_14 full256 param_13 b_param param_12).
wp; while (valid trace__sha512_x4_finalize /\ 0 <= k <= 4 /\ lanes b_buf 4 128 k 112 128).
+ auto => /> &m _ hk0 hk8 hl hlt; split; 1: smt().
  split; 1: smt().
  by apply (lanes4_set112 _ _ hl); smt().
wp; ecall (__bswap64_proof param_11).
wp; ecall (__bswap64_proof param_10).
wp; while (valid trace__sha512_x4_finalize /\ 0 <= k <= 4 /\ hi = W64.of_int 112
           /\ to_uint fill <= 112 /\ lanes b_buf 4 128 k (to_uint fill) 112).
+ wp; ecall (__zero128_proof param_9 b_param_0 param_8 param_7 param_6).
  auto => /> &m _ hk0 hk8 hf hl hlt.
  rewrite W64.uleE /=; split.
  + by split; [smt() | apply (lanes128_get _ _ _ _ hl); smt(W64.to_uint_cmp)].
  move=> _ _ r hr _; split; 1: smt().
  split; 1: smt().
  by apply (lanes128_set _ _ _ _ _ hl) => //; smt(W64.to_uint_cmp).
auto => /> &m _ hf hl; split; 1: exact (lanes_start _ _ _ _ _ hl).
move=> b0 k0 tr0 hlt _ hk0 hk8 hb r _ r1 _.
have ->> : k0 = 4 by smt().
have hb56 := lanes_end _ _ _ _ _ hb.
split; 1: exact (lanes_start _ _ _ _ _ hb56).
move=> b1 k1 tr1 hlt1 _ hk1 hk18 hb1.
have ->> : k1 = 4 by smt().
rewrite (lanes4_full _ (lanes_end _ _ _ _ _ hb1)).
split; 1: by split; [exact (full256_init 0 256) | exact (full512_init 0 512)].
move=> _ _ r0 h3 _; split; 1: by move=> j /#.
by move=> o0 k2 tr2 hlt2 _ hk2 hk28 ho; have <- : 8 * (8 * k2) = 256 by smt().
qed.

lemma _sha512_x4_lanes_proof _out _b_out _in _b_in _len _ms :
  _sha512_x4_lanes_spec _out _b_out _in _b_in _len _ms.
proof.
rewrite /_sha512_x4_lanes_spec; proc.
wp; ecall (_sha512_x4_finalize_proof param_10 b_param_0 param_9 full256 param_8 b_param
             param_7 param_6).
wp; ecall (_sha512_x4_absorb_lanes_proof param_5 full256 param_4 b_param_1 param_3 param_2
             full32 param_1 param_0).
wp; ecall (__sha512_x4_init_proof param b_param_2).
auto => /> &m *.
have e : to_uint (W64.zero \umod W64.of_int 128) = 0 by rewrite umodc // W64.to_uint0.
rewrite e.
do 4!(split; 1: exact full32_init).
split.
+ by do !split; try exact (full256_init 0 256); move=> j /#.
exact (full32_init 0 32).
qed.
