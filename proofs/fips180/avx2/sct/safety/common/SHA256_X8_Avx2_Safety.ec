(*
 * SHA256_X8_Avx2_Safety.ec
 * ========================
 *
 * Safety of the 8-way SHA-256 AVX2 kernel (sha256_x8_compress.jinc):
 * for each of its functions F,
 * F_proof proves F_spec of the safety model (Jsha2_safety, extracted
 * by jasmin2ec -m safety), the Hoare triple stating that the #[safety]
 * contract's precondition gives its postcondition and that every
 * assertion of F's trace holds (array accesses in bounds and
 * initialised, memory accesses valid).
 *
 * The state v, the window w and the table stay fully initialised, so
 * every array fact is the full mask; what remains are the index bounds
 * (registers (k + 64 - t) mod 8, slots t mod 16, table words) and, for
 * the lanes form, the validity of each lane's 64 n bytes.
 *)

require import AllCore IntDiv CoreMap List Distr.
from Jasmin require import JModel_x86 Jcheck JSafety.
require import SafetyEclib.
require import BArray32 BArray64 BArray256 BArray512 BArray2048.
require import Jsha2_safety Masks Valid.

clone Masks.Masks as X256 with theory A <- BArray256.
clone Masks.Masks as X512 with theory A <- BArray512.

lemma __Sigma0_8x_proof _x : __Sigma0_8x_spec _x.
proof. by rewrite /__Sigma0_8x_spec; proc; auto => />; rewrite /valid. qed.

lemma __Sigma1_8x_proof _x : __Sigma1_8x_spec _x.
proof. by rewrite /__Sigma1_8x_spec; proc; auto => />; rewrite /valid. qed.

lemma __sigma0_8x_proof _x : __sigma0_8x_spec _x.
proof. by rewrite /__sigma0_8x_spec; proc; auto => />; rewrite /valid. qed.

lemma __sigma1_8x_proof _x : __sigma1_8x_spec _x.
proof. by rewrite /__sigma1_8x_spec; proc; auto => />; rewrite /valid. qed.

lemma __sha256_x8_round_proof _v _b_v _wk _cc _t :
  __sha256_x8_round_spec _v _b_v _wk _cc _t.
proof.
rewrite /__sha256_x8_round_spec; proc.
inline *; auto => /> hv.
rewrite X256.full_init /=.
by do ?split; smt(modz_cmp).
qed.

lemma __sha256_x8_schedule_proof _w _b_w _t : __sha256_x8_schedule_spec _w _b_w _t.
proof.
rewrite /__sha256_x8_schedule_spec; proc.
inline *; auto => /> hw.
rewrite X512.full_init /=.
by do ?split; smt(modz_cmp).
qed.

lemma __sha256_x8_transpose_proof _r _b_r _mask : __sha256_x8_transpose_spec _r _b_r _mask.
proof.
rewrite /__sha256_x8_transpose_spec; proc.
unroll for ^while; unroll for ^while.
auto => /> hr.
by do ?split; try (move=> i h1 h2 /=); smt().
qed.

lemma addw (o : W64.t) n : 0 <= n < 4096 => W64.to_uint o <= 2048 =>
  W64.to_uint (o + W64.of_int n) = W64.to_uint o + n.
proof.
move=> hn ho; rewrite W64.to_uintD_small !W64.of_uintK (pmod_small n) //; smt(W64.to_uint_cmp pow2_64).
qed.

(* A 256-bit write of the all-ones word right after an initialised
   prefix extends the prefix. *)
lemma ext256 (m : BArray256.t) i : 0 <= i => BArray256.is_init m 0 (32 * i) =>
  BArray256.is_init
    (BArray256.set256d m (32 * i)
       (W256.of_int 115792089237316195423570985008687907853269984665640564039457584007913129639935))
    0 (32 * i + 32).
proof.
move=> hi hm j hj1 hj2; rewrite BArray256.is_init_cell_set256d.
by case: (j < 32 * i) => hj; [right; apply hm | left] => /#.
qed.

lemma x8s_schedule_true : hoare [M.__sha256_x8_schedule : true ==> true].
proof. by proc; inline *; auto. qed.

lemma _sha256_x8_block_proof _h8 _b_h8 _w _b_w _ms :
  _sha256_x8_block_spec _h8 _b_h8 _w _b_w _ms.
proof.
rewrite /_sha256_x8_block_spec; proc.
(* step 4 *)
wp; while (valid trace__sha256_x8_block /\ 0 <= i <= 8 /\ b_v = X256.full).
+ auto => /> &hr hv hi0 hi1 hi.
  by rewrite !valid_cat hv /valid /= X256.full_init /#.
(* rounds 16 .. 63 *)
wp; while (valid trace__sha256_x8_block /\
           more = (W64.to_uint o <= 1536) /\ 512 <= W64.to_uint o <= 2048 /\ b_v = X256.full).
+ wp; while (valid trace__sha256_x8_block /\ 16 <= t <= 32 /\ 512 <= W64.to_uint o <= 1536 /\
             b_v = X256.full).
  + case (t %% 2 = 0).
    + rcondt ^if; 1: by wp; call x8s_schedule_true; auto.
      wp; ecall (__sha256_x8_round_proof param_12 b_param param_11 param_10 param_9).
      wp; ecall (__sha256_x8_schedule_proof param_8 (BArray512.init_arr (W8.of_int 255)) param_7).
      auto => /> &hr hv ht0 ht1 ho0 ho1 ht2 _.
      rewrite X512.full_init X256.full_init /= => r hr0 hvr r1 hr1 hvr1.
      have ho := addw o{hr} (32 * (t{hr} - 16)) _ _; 1,2: smt().
      by rewrite !valid_cat hv hvr hvr1 /valid /= ho; smt().
    rcondf ^if; 1: by wp; call x8s_schedule_true; auto.
    wp; ecall (__sha256_x8_round_proof param_16 b_param_0 param_15 param_14 param_13).
    wp; ecall (__sha256_x8_schedule_proof param_8 (BArray512.init_arr (W8.of_int 255)) param_7).
    auto => /> &hr hv ht0 ht1 ho0 ho1 ht2 _.
    rewrite X512.full_init X256.full_init /= => r hr0 hvr r1 hr1 hvr1.
    have ho := addw o{hr} (32 * (t{hr} - 16)) _ _; 1,2: smt().
    by rewrite !valid_cat hv hvr hvr1 /valid /= ho; smt().
  auto => /> &hr hv ho0 ho1 hmo t0 tr _ _ _ _.
  have ho := addw o{hr} 512 _ _; 1,2: smt().
  by rewrite W64.uleE ho W64.of_uintK /=; smt().
(* rounds 0 .. 15 *)
wp; while (valid trace__sha256_x8_block /\ 0 <= t <= 16 /\ b_v = X256.full).
+ case (t %% 2 = 0).
  + rcondt ^if; 1: by auto.
    wp; ecall (__sha256_x8_round_proof param_2 b_param_1 param_1 param_0 param).
    auto => /> &hr hv ht0 ht1 ht2 hev.
    rewrite X256.full_init /= => r hr0 hvr.
    by rewrite !valid_cat hv hvr /valid /=; smt().
  rcondf ^if; 1: by auto.
  wp; ecall (__sha256_x8_round_proof param_6 b_param_2 param_5 param_4 param_3).
  auto => /> &hr hv ht0 ht1 ht2 hodd.
  rewrite X256.full_init /= => r hr0 hvr.
  by rewrite !valid_cat hv hvr /valid /=; smt().
(* v <- h8 *)
wp; while (valid trace__sha256_x8_block /\ 0 <= i <= 8 /\ BArray256.is_init b_v 0 (32 * i)).
+ auto => /> &hr hv hi0 hi1 hvi hi.
  rewrite !valid_cat hv /valid /= (_: i{hr} * 32 = 32 * i{hr}) 1:/#.
  by rewrite (_: 32 * (i{hr} + 1) = 32 * i{hr} + 32) 1:/# ext256 //; smt().
auto => /> hh hw.
split; 1: by move=> j /#.
move=> vi i0 tr hi hv hi0 hi8 hvi.
have h8 : i0 = 8 by smt().
have hvf : vi = X256.full by apply X256.is_init_full; move: hvi; rewrite h8.
rewrite hvf !valid_cat hv /valid /= !X256.full_init /=.
smt(X512.full_init).
qed.

lemma ext512 (m : BArray512.t) i : 0 <= i => BArray512.is_init m 0 (32 * i) =>
  BArray512.is_init
    (BArray512.set256d m (32 * i)
       (W256.of_int 115792089237316195423570985008687907853269984665640564039457584007913129639935))
    0 (32 * i + 32).
proof.
move=> hi hm j hj1 hj2; rewrite BArray512.is_init_cell_set256d.
by case: (j < 32 * i) => hj; [right; apply hm | left] => /#.
qed.

lemma _sha256_x8_compress_proof _h8 _b_h8 _blocks _b_blocks _ms :
  _sha256_x8_compress_spec _h8 _b_h8 _blocks _b_blocks _ms.
proof.
rewrite /_sha256_x8_compress_spec; proc.
wp; ecall (_sha256_x8_block_proof param_3 (BArray256.init_arr (W8.of_int 255)) param_2 b_param param_1).
wp; while (valid trace__sha256_x8_compress /\ 0 <= q <= 2 /\ BArray512.is_init b_w 0 (32 * (8 * q))).
+ wp; while (valid trace__sha256_x8_compress /\ 0 <= k <= 8 /\ 0 <= q < 2 /\
             BArray512.is_init b_w 0 (32 * (8 * q + k))).
  + auto => /> &hr hv hk0 hk1 hq0 hq1 hw hk.
    rewrite !valid_cat hv /valid /= (_: (8 * q{hr} + k{hr}) * 32 = 32 * (8 * q{hr} + k{hr})) 1:/#.
    rewrite (_: 32 * (8 * q{hr} + (k{hr} + 1)) = 32 * (8 * q{hr} + k{hr}) + 32) 1:/# ext512 //; smt().
  wp; ecall (__sha256_x8_transpose_proof param_0 b_param_0 param).
  wp; while (valid trace__sha256_x8_compress /\ 0 <= k <= 8 /\ 0 <= q < 2 /\
             BArray256.is_init b_r 0 (32 * k) /\ BArray512.is_init b_w 0 (32 * (8 * q))).
  + auto => /> &hr hv hk0 hk1 hq0 hq1 hr hw hk.
    rewrite !valid_cat hv /valid /= (_: k{hr} * 32 = 32 * k{hr}) 1:/#.
    rewrite (_: 32 * (k{hr} + 1) = 32 * k{hr} + 32) 1:/# ext256 //; smt().
  auto => /> &hr hv hq0 hq1 hw hq; split; 1: by move=> j /#.
  move=> r0 k0 tr hk hv' hk0 hk1 hri.
  have hk8 : k0 = 8 by smt().
  have hrf : BArray256.is_init r0 0 256 by move: hri; rewrite hk8.
  split; 1: done. move=> _ rr hr2 hr3; split.
  + by rewrite !valid_cat hv' hr3 /valid.
  move=> w1 k1 tr1 hk' hv1 hk10 hk11 hwi.
  have hk18 : k1 = 8 by smt().
  split; 1: smt().
  by move: hwi; rewrite hk18 (_: 8 * q{hr} + 8 = 8 * (q{hr} + 1)) 1:/#.
auto => /> hh hb.
split; 1: by move=> j /#.
move=> wi q0 tr hq hv hq0 hq1 hwi.
have hq2 : q0 = 2 by smt().
have hw : BArray512.is_init wi 0 512 by move: hwi; rewrite hq2.
rewrite X256.full_init hw /= => rr _ _ hr.
by rewrite !valid_cat hv hr /valid.
qed.

lemma mul64 (n : W64.t) : n \ult W64.of_int 288230376151711744 =>
  W64.to_uint (W64.of_int 64 * n) = 64 * W64.to_uint n.
proof.
rewrite W64.ultE W64.of_uintK /= => hn.
by rewrite W64.to_uintM_small W64.of_uintK /=; smt(W64.to_uint_cmp).
qed.

lemma vrows mv (p : W64.t) n : 1 <= n =>
  is_valid ptr_modulus mv (W64.to_uint p) (64 * n) =>
  is_valid ptr_modulus mv (W64.to_uint p) 32 /\
  is_valid ptr_modulus mv (W64.to_uint (p + W64.of_int 32)) 32.
proof.
move=> hn h; split.
+ by move: h; rewrite is_validP => h; apply h => /#.
by apply (valid_sub _ _ _ 32 32 h) => /#.
qed.

(* What the block loop of the lanes form keeps. *)
op lsafe (mv : global_mem_v_t) (in0 : BArray64.t) (off n n0 : W64.t) =
  W64.to_uint n <= W64.to_uint n0 /\ n0 \ult W64.of_int 288230376151711744 /\
  forall L, 0 <= L < 8 =>
    is_valid ptr_modulus mv (W64.to_uint (BArray64.get64 in0 L + off)) (64 * W64.to_uint n).

lemma _sha256_x8_compress_lanes_proof _h8 _b_h8 _in _b_in _off _n _ms :
  _sha256_x8_compress_lanes_spec _h8 _b_h8 _in _b_in _off _n _ms.
proof.
rewrite /_sha256_x8_compress_lanes_spec; proc.
wp; while (valid trace__sha256_x8_compress_lanes /\ more = (n <> W64.zero) /\
           in_0 = _in /\ lsafe Glob.mem_v _in off n _n).
+ unroll for ^while; do 2!(unroll for ^while).
  wp; ecall (_sha256_x8_block_proof param_3 (BArray256.init_arr (W8.of_int 255)) param_2 b_param param_1).
  wp; ecall (__sha256_x8_transpose_proof param_0 b_param_0 param).
  wp; ecall (__sha256_x8_transpose_proof param_0 b_param_0 param).
  auto => /> &hr hv hnn hn hval hnz.
  have hn1 : 1 <= W64.to_uint n{hr}.
  + have : W64.to_uint n{hr} <> 0 by move: hnz; apply contra => h; rewrite W64.to_uint_eq h.
    by smt(W64.to_uint_cmp).
  have := vrows _ _ _ hn1 (hval 0 _); 1: done; rewrite /= => -[a0 b0].
  have := vrows _ _ _ hn1 (hval 1 _); 1: done; rewrite /= => -[a1 b1].
  have := vrows _ _ _ hn1 (hval 2 _); 1: done; rewrite /= => -[a2 b2].
  have := vrows _ _ _ hn1 (hval 3 _); 1: done; rewrite /= => -[a3 b3].
  have := vrows _ _ _ hn1 (hval 4 _); 1: done; rewrite /= => -[a4 b4].
  have := vrows _ _ _ hn1 (hval 5 _); 1: done; rewrite /= => -[a5 b5].
  have := vrows _ _ _ hn1 (hval 6 _); 1: done; rewrite /= => -[a6 b6].
  have := vrows _ _ _ hn1 (hval 7 _); 1: done; rewrite /= => -[a7 b7].
  rewrite /SLH64.protect_64.
  split; 1: by move=> j hj1 hj2; rewrite !BArray256.is_init_cell_set256d; smt().
  move=> _ r1 hr1 hvr1; split; 1: by move=> j hj1 hj2; rewrite !BArray256.is_init_cell_set256d; smt().
  move=> _ r2 hr2 hvr2; split.
  + split; 1: exact (X256.full_init 0 256).
    by move=> j hj1 hj2; rewrite !BArray512.is_init_cell_set256d; smt().
  move=> _ _ r3 hr3a hr3b hvr3.
  rewrite !valid_cat hv hvr1 hvr2 hvr3 /valid /=.
  rewrite a0 a1 a2 a3 a4 a5 a6 a7 b0 b1 b2 b3 b4 b5 b6 b7 /=.
  have hsub : W64.to_uint (n{hr} - W64.one) = W64.to_uint n{hr} - 1.
  + by rewrite W64.to_uintB 1:W64.uleE /= 1:/#.
  rewrite hsub; split; 1: smt().
  move=> L hL0 hL1.
  have := valid_step 64 _ _ _ _ (hval L _) hnz; 1,2: smt().
  move=> [_]; rewrite -addrA /is_valid hsub => -[h1 [h2 h3]].
  by split; [move=> i hi1 hi2; apply h1 => /# | split => //; smt(pow2_64)].
auto => /> &hr _ _ _ _ _ _ _ _ _ _ hn _; rewrite (mul64 _ hn).
move=> v0 v0a v0b v1 v1a v1b v2 v2a v2b v3 v3a v3b v4 v4a v4b v5 v5a v5b v6 v6a v6b v7 v7a v7b; split.
+ move=> L hL0 hL1.
  have [->|[->|[->|[->|[->|[->|[->|->]]]]]]] : L = 0 \/ L = 1 \/ L = 2 \/ L = 3 \/ L = 4 \/ L = 5 \/ L = 6 \/ L = 7 by smt().
  + by rewrite /= v0a v0b /=; move=> i h1 h2; apply v0 => /#.
  + by rewrite /= v1a v1b /=; move=> i h1 h2; apply v1 => /#.
  + by rewrite /= v2a v2b /=; move=> i h1 h2; apply v2 => /#.
  + by rewrite /= v3a v3b /=; move=> i h1 h2; apply v3 => /#.
  + by rewrite /= v4a v4b /=; move=> i h1 h2; apply v4 => /#.
  + by rewrite /= v5a v5b /=; move=> i h1 h2; apply v5 => /#.
  + by rewrite /= v6a v6b /=; move=> i h1 h2; apply v6 => /#.
  + by rewrite /= v7a v7b /=; move=> i h1 h2; apply v7 => /#.
by move=> *; apply (X256.full_init 0 256).
qed.
