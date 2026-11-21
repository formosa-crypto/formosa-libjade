(*
 * SHA256_Avx2_Safety.ec
 * =====================
 *
 * Safety of the SHA-256 AVX2 kernel (sha256_compress.jinc):
 * for each of its functions F, F_proof proves F_spec of the safety model
 * (Jsha2_safety, extracted by jasmin2ec -m safety), the Hoare triple
 * stating that the #[safety] contract's precondition gives its
 * postcondition and that every assertion of F's trace holds (array
 * accesses in bounds and initialised, memory accesses valid).
 *
 * The working variables v and the schedule window x stay fully
 * initialised. Of m, the round reads the half it was given and writes the
 * other. The W + K table wk is written group by group, and the driver
 * reads only groups already written: groups 0 .. 3 before the rounds,
 * group 4 + t / 4 after round t of the first block (t mod 4 = 2, t < 48).
 *)

require import AllCore IntDiv CoreMap List Distr.
from Jasmin require import JModel_x86 Jcheck JSafety.
require import SafetyEclib.
require import BArray8 BArray32 BArray64 BArray128 BArray256 BArray512.
require import Jsha2_safety Masks Valid.

clone Masks.Masks as K8 with theory A <- BArray8.
clone Masks.Masks as K32 with theory A <- BArray32.
clone Masks.Masks as K64 with theory A <- BArray64.
clone Masks.Masks as K128 with theory A <- BArray128.
clone Masks.Masks as K512 with theory A <- BArray512.

lemma __sha256_avx2_round_proof _v _b_v _m _b_m _s _t _x _b_x _lo _hi _j _ph :
  __sha256_avx2_round_spec _v _b_v _m _b_m _s _t _x _b_x _lo _hi _j _ph.
proof.
rewrite /__sha256_avx2_round_spec; proc.
case (ph = 0).
+ rcondt ^if; first by auto. rcondf ^if; first by auto. rcondf ^if; first by auto.
  rcondt ^if; first by auto. rcondf ^if; first by auto.
  rcondt ^if; first by auto. rcondf ^if; first by auto.
  rcondt ^if; first by auto. rcondf ^if; first by auto.
  rcondt ^if; first by auto. rcondf ^if; first by auto. rcondf ^if; first by auto.
  rcondt ^if; first by auto. rcondf ^if; first by auto.
  rcondt ^if; first by auto.
  auto => /> ht0 ht1 hv hm hx.
  rewrite ?K32.full_init ?K128.full_init /=.
  have h2 := modz_cmp _t 2 _; 1: done.
  have h21 : (_t + 1) %% 2 = 1 - _t %% 2 by smt().
  do ?split; try (move=> k hk1 hk2; rewrite ?BArray8.is_init_cell_set32d); smt().
case (ph = 1).
+ rcondf ^if; first by auto. rcondt ^if; first by auto. rcondf ^if; first by auto.
  rcondf ^if; first by auto. rcondt ^if; first by auto.
  rcondf ^if; first by auto. rcondt ^if; first by auto.
  rcondf ^if; first by auto. rcondt ^if; first by auto.
  rcondf ^if; first by auto. rcondt ^if; first by auto. rcondf ^if; first by auto.
  rcondf ^if; first by auto. rcondt ^if; first by auto.
  rcondf ^if; first by auto.
  auto => /> ht0 ht1 hv hm hx.
  rewrite ?K32.full_init ?K128.full_init /=.
  have h2 := modz_cmp _t 2 _; 1: done.
  have h21 : (_t + 1) %% 2 = 1 - _t %% 2 by smt().
  do ?split; try (move=> k hk1 hk2; rewrite ?BArray8.is_init_cell_set32d); smt().
case (ph = 2).
+ rcondf ^if; first by auto. rcondf ^if; first by auto. rcondt ^if; first by auto.
  rcondf ^if; first by auto. rcondt ^if; first by auto.
  rcondf ^if; first by auto. rcondt ^if; first by auto.
  rcondf ^if; first by auto. rcondt ^if; first by auto.
  rcondf ^if; first by auto. rcondf ^if; first by auto. rcondt ^if; first by auto.
  rcondf ^if; first by auto. rcondt ^if; first by auto.
  rcondf ^if; first by auto.
  auto => /> ht0 ht1 hv hm hx.
  rewrite ?K32.full_init ?K128.full_init /=.
  have h2 := modz_cmp _t 2 _; 1: done.
  have h21 : (_t + 1) %% 2 = 1 - _t %% 2 by smt().
  do ?split; try (move=> k hk1 hk2; rewrite ?BArray8.is_init_cell_set32d); smt().
do 15!(rcondf ^if; first by auto => /#).
auto => /> ht0 ht1 hv hm hx _ _ _.
rewrite ?K32.full_init ?K128.full_init /=.
have h2 := modz_cmp _t 2 _; 1: done.
have h21 : (_t + 1) %% 2 = 1 - _t %% 2 by smt().
do ?split; try (move=> k hk1 hk2; rewrite ?BArray8.is_init_cell_set32d); smt().
qed.

(* A 256-bit write of the all-ones word right after an initialised
   prefix of the table extends the prefix. *)
lemma wk_ext (m : BArray512.t) n : 0 <= n => BArray512.is_init m 0 (32 * n) =>
  BArray512.is_init
    (BArray512.set256d m (32 * n)
       (W256.of_int 115792089237316195423570985008687907853269984665640564039457584007913129639935))
    0 (32 * n + 32).
proof.
move=> hn hm j hj1 hj2; rewrite BArray512.is_init_cell_set256d.
by case: (j < 32 * n) => hj; [right; apply hm | left] => /#.
qed.

(* The table entry that round t of block l reads. *)
lemma wk_idx t l : 0 <= t < 64 => 0 <= l < 2 =>
  0 <= (8 * (t %/ 4) + 4 * l + t %% 4) * 4 /\
  (8 * (t %/ 4) + 4 * l + t %% 4) * 4 + 4 <= 32 * (if l = 0 /\ t <= 48 then 4 + (t + 1) %/ 4 else 16).
proof.
move=> ht hl; have := modz_cmp t 4; have := divz_eq t 4; have := divz_eq (t + 1) 4.
by have := modz_cmp (t + 1) 4; smt().
qed.

lemma slot_b k : 0 <= k %% 8 * 4 /\ k %% 8 * 4 + 4 <= 32.
proof. by have := modz_cmp k 8; smt(). qed.

lemma wkn_w l t : (l = 0 /\ t < 48) /\ t %% 4 = 2 =>
  32 * (if l = 0 /\ t + 1 <= 48 then 4 + (t + 2) %/ 4 else 16) = 32 * (4 + t %/ 4) + 32 /\
  (if l = 0 /\ t <= 48 then 4 + (t + 1) %/ 4 else 16) = 4 + t %/ 4.
proof.
move=> hc; have := divz_eq t 4; have := divz_eq (t + 1) 4; have := divz_eq (t + 2) 4.
have := modz_cmp (t + 1) 4; have := modz_cmp (t + 2) 4; smt().
qed.

lemma wkn_nw l t : 0 <= t < 64 => !((l = 0 /\ t < 48) /\ t %% 4 = 2) =>
  (if l = 0 /\ t + 1 <= 48 then 4 + (t + 2) %/ 4 else 16)
  = (if l = 0 /\ t <= 48 then 4 + (t + 1) %/ 4 else 16).
proof.
move=> ht hc; have := divz_eq t 4; have := divz_eq (t + 1) 4; have := divz_eq (t + 2) 4.
have := modz_cmp t 4; have := modz_cmp (t + 1) 4; have := modz_cmp (t + 2) 4; smt().
qed.

lemma grp_b t : 0 <= t < 48 =>
  (0 <= (4 + t %/ 4) * 16 /\ (4 + t %/ 4) * 16 + 16 <= 256) /\
  (0 <= (4 + t %/ 4) * 32 /\ (4 + t %/ 4) * 32 + 32 <= 512) /\
  (0 <= t %/ 4 %% 4 * 32 /\ t %/ 4 %% 4 * 32 + 32 <= 128) /\ 0 <= 4 + t %/ 4.
proof. by move=> ht; have := divz_eq t 4; have := modz_cmp t 4; have := modz_cmp (t %/ 4) 4; smt(). qed.

lemma v_ext (m : BArray32.t) i : 0 <= i => BArray32.is_init m 0 (4 * i) =>
  BArray32.is_init (BArray32.set32d m (4 * i) (W32.of_int 4294967295)) 0 (4 * i + 4).
proof.
move=> hi hm j hj1 hj2; rewrite BArray32.is_init_cell_set32d.
by case: (j < 4 * i) => hj; [right; apply hm | left] => /#.
qed.

lemma __sha256_avx2_proof _h _b_h _x _b_x _nb _ms :
  __sha256_avx2_spec _h _b_h _x _b_x _nb _ms.
proof.
rewrite /__sha256_avx2_spec; proc.
wp; while (valid trace___sha256_avx2 /\ 0 <= l /\ 0 <= inc <= 2 /\ b_v = K32.full /\
       BArray512.is_init b_wk 0 (if l = 0 then 128 else 512)).
+ wp; while (valid trace___sha256_avx2 /\ 0 <= l < inc /\ 0 <= inc <= 2 /\ 0 <= i <= 8 /\
             b_v = K32.full /\ BArray512.is_init b_wk 0 512).
  + wp; skip => &hr [[#] hval hl0 hl1 hnb0 hnb1 hi0 hi1 hv hwk] hc.
    rewrite /= hv !K32.full_set32d !K32.full_init !valid_cat hval /valid /= hwk /=.
    by move: hi0 hc hl0 hl1 hnb0 hnb1; clear hval hwk; smt().
  wp; while (valid trace___sha256_avx2 /\ 0 <= l < inc /\ 0 <= inc <= 2 /\ 0 <= t <= 64 /\
             b_v = K32.full /\ BArray8.is_init b_m (4 * (t %% 2)) 4 /\
             BArray512.is_init b_wk 0 (32 * (if l = 0 /\ t <= 48 then 4 + (t + 1) %/ 4 else 16))).
  + sp; seq 1 : (valid trace___sha256_avx2 /\ 0 <= l < inc /\ 0 <= inc <= 2 /\ 0 <= t < 64 /\
                 b_v = K32.full /\ b_m = K8.full /\
                 BArray512.is_init b_wk 0 (32 * (if l = 0 /\ t <= 48 then 4 + (t + 1) %/ 4 else 16))).
    + if.
      + wp; ecall (__sha256_avx2_round_proof param_7 b_param_0 param_6 b_param param_5 param_4 param_3
                     (BArray128.init_arr (W8.of_int 255)) param_2 param_1 param_0 param); wp; skip.
        move=> &hr [[v0 bv0 tr0 [#] htr hbv hv hval hl0 hl1 hnb0 hnb1 ht0 ht1 hbv0 hm hwk ht64] _].
        split; 1: by rewrite /= hbv hbv0 K32.full_set32d K32.full_init K128.full_init /= hm; smt().
        move=> _ r [[[hv' hm'] hx'] hval'].
        have hl2 : 0 <= l{hr} < 2 by move: hl0 hl1 hnb1; clear htr; smt().
        have [hw0 hw1] := wk_idx t{hr} l{hr} _ hl2; 1: by split.
        have hwr : BArray512.is_init b_wk{hr} ((8 * (t{hr} %/ 4) + 4 * l{hr} + t{hr} %% 4) * 4) 4.
        + by apply (K512.is_init_sub _ 0 (32 * (if l{hr} = 0 /\ t{hr} <= 48 then 4 + (t{hr} + 1) %/ 4 else 16))).
        rewrite htr !valid_cat hval hval' /valid /= hbv0 K32.full_init hwr hv' hm' hx' /=.
        rewrite !slot_b hw0 /=.
        split; 1: by move: hw1; clear htr; smt().
        by do ?split => //; move: ht0 ht64; clear htr; smt().
      wp; ecall (__sha256_avx2_round_proof param_16 b_param_2 param_15 b_param_1 param_14 param_13 param_12
                   (BArray128.init_arr (W8.of_int 255)) param_11 param_10 param_9 param_8); wp; skip.
      move=> &hr [[v0 bv0 tr0 [#] htr hbv hv hval hl0 hl1 hnb0 hnb1 ht0 ht1 hbv0 hm hwk ht64] _].
      split; 1: by rewrite /= hbv hbv0 K32.full_set32d K32.full_init K128.full_init /= hm; smt().
      move=> _ r [[[hv' hm'] hx'] hval'].
      have hl2 : 0 <= l{hr} < 2 by move: hl0 hl1 hnb1; clear htr; smt().
      have [hw0 hw1] := wk_idx t{hr} l{hr} _ hl2; 1: by split.
      have hwr : BArray512.is_init b_wk{hr} ((8 * (t{hr} %/ 4) + 4 * l{hr} + t{hr} %% 4) * 4) 4.
      + by apply (K512.is_init_sub _ 0 (32 * (if l{hr} = 0 /\ t{hr} <= 48 then 4 + (t{hr} + 1) %/ 4 else 16))).
      rewrite htr !valid_cat hval hval' /valid /= hbv0 K32.full_init hwr hv' hm' hx' /=.
      rewrite !slot_b hw0 /=.
      split; 1: by move: hw1; clear htr; smt().
      by do ?split => //; move: ht0 ht64; clear htr; smt().
    wp; skip => &hr [#] hval hl0 hl1 hnb0 hnb1 ht0 ht1 hv hm hwk.
    rewrite /= hm K8.full_init /=.
    case: ((l{hr} = 0 /\ t{hr} < 48) /\ t{hr} %% 4 = 2) => hc.
    + have [e1 e2] := wkn_w _ _ hc.
      have [b1 [b2 [b3 b4]]] := grp_b t{hr} _; 1: smt().
      have hw' := wk_ext b_wk{hr} (4 + t{hr} %/ 4) b4 _; 1: by rewrite -e2.
      rewrite !valid_cat hval /valid /= b1 b2 b3.
      rewrite (_: (4 + t{hr} %/ 4) * 32 = 32 * (4 + t{hr} %/ 4)) 1:/# e1 hw' /=.
      by do ?split => //; move: hc ht0; clear hval hwk hw'; smt().
    have e := wkn_nw l{hr} t{hr} _ hc; 1: by split.
    rewrite e hwk /=.
    by do ?split => //; move: ht0 ht1; clear hval hwk; smt().
  wp; skip => &hr [[#] hval hl0 hnb0 hnb1 hv hwk] hl.
  rewrite hv K32.full_init /=; split.
  + have hm0 : forall (m : BArray8.t),
      BArray8.is_init (BArray8.set32d m 0 (W32.of_int 4294967295)) 0 4.
    + by move=> m j hj1 hj2; rewrite BArray8.is_init_cell_set32d; left; smt().
    rewrite !valid_cat hval /valid /= !hm0 K32.full_init /=.
    have hwk0 : BArray512.is_init b_wk{hr} 0 (32 * if l{hr} = 0 then 4 else 16).
    + by move: hwk; case: (l{hr} = 0).
    rewrite hwk0 /=.
    by do ?split => //; move: hl0 hl hnb0 hnb1; clear hval hwk hwk0; smt().
  move=> m0 v0 wk0 t0 tr0 hc [#] hval' _ _ _ _ ht0 ht1 hv' _ hwk'.
  have h64 : t0 = 64 by move: hc ht1; clear hval' hwk'; smt().
  subst t0; move: hwk' => /= hwk'.
  rewrite hv' K32.full_set32d K32.full_init /= hwk' /=.
  split; 1: by rewrite !valid_cat hval' /valid /=; move: hl0 hl hnb0 hnb1; clear hval hval' hwk'; smt().
  move=> v' i' tr' hc' [#] hval'' _ _ _ _ _ _ hv''.
  rewrite hval'' hv'' (_: (l{hr} + 1 = 0) = false) 1:/# /= ?hwk' /=.
  by move: hl0 hnb0 hnb1; clear hval hval' hval''; smt().
wp; while (valid trace___sha256_avx2 /\ 0 <= i <= 8 /\ BArray32.is_init b_v 0 (4 * i) /\
           BArray512.is_init b_wk 0 128).
+ wp; skip => &hr [[#] hval hi0 hi1 hv hwk] hc.
  have hb : 0 <= i{hr} < 8 by split.
  rewrite !valid_cat hval /valid /= (_: i{hr} * 4 = 4 * i{hr}) 1:/#.
  rewrite (_: 4 * (i{hr} + 1) = 4 * i{hr} + 4) 1:/# v_ext // hwk /=.
  by move: hb; clear hval hv hwk; smt().
wp; while (valid trace___sha256_avx2 /\ 0 <= i <= 4 /\ BArray512.is_init b_wk 0 (32 * i)).
+ wp; skip => &hr [[#] hval hi0 hi1 hwk] hc.
  have hb : 0 <= i{hr} < 4 by split.
  rewrite !valid_cat hval /valid /=.
  rewrite (_: i{hr} * 32 = 32 * i{hr}) 1:/# (_: 32 * (i{hr} + 1) = 32 * i{hr} + 32) 1:/#.
  rewrite wk_ext //=.
  by move: hb; clear hval hwk; smt().
wp; skip => /> hnb0 hnb1 hh hx.
split; 1: by move=> j; smt().
move=> wk0 i0 tr0 hc hval hi0 hi1 hwk.
have hi4 : i0 = 4 by smt().
move: hwk; rewrite hi4 /= => hwk.
split; 1: by split; [move=> j; smt() | exact hwk].
move=> v1 i1 tr1 hc' hval' hi0' hi1' hv _.
have hi8' : i1 = 8 by smt().
move: hv; rewrite hi8' /= => hv.
rewrite (K32.is_init_full _ hv) /=.
by move=> wk1 l0 tr2 hc'' hval'' _ _; rewrite K32.full_init.
qed.

(* ------------------------------------------------------------------ *)
(* Entry points                                                        *)

lemma x_ext (m : BArray128.t) i : 0 <= i => BArray128.is_init m 0 (32 * i) =>
  BArray128.is_init
    (BArray128.set256d m (32 * i)
       (W256.of_int 115792089237316195423570985008687907853269984665640564039457584007913129639935))
    0 (32 * i + 32).
proof.
move=> hi hm j hj1 hj2; rewrite BArray128.is_init_cell_set256d.
by case: (j < 32 * i) => hj; [right; apply hm | left] => /#.
qed.

lemma x_here (m : BArray128.t) i :
  BArray128.is_init
    (BArray128.set256d m i
       (W256.of_int 115792089237316195423570985008687907853269984665640564039457584007913129639935))
    i 32.
proof. by move=> j hj1 hj2; rewrite BArray128.is_init_cell_set256d; left. qed.

lemma _sha256_compress_proof _h _b_h _block _b_block _ms :
  _sha256_compress_spec _h _b_h _block _b_block _ms.
proof.
rewrite /_sha256_compress_spec; proc; wp.
ecall (__sha256_avx2_proof param_2 (BArray32.init_arr (W8.of_int 255)) param_1 b_param param_0 param); wp.
while (valid trace__sha256_compress /\ 0 <= i <= 4 /\ BArray128.is_init b_x 0 (32 * i)).
+ wp; skip => &hr [[#] hv hi0 hi1 hxi] hlt.
  rewrite /= !valid_cat hv /valid /= (_: i{hr} * 32 = 32 * i{hr}) 1:/# x_here.
  have h1 := x_ext b_x{hr} i{hr} hi0 hxi.
  have h2 := x_ext _ i{hr} hi0 (K128.is_init_sub _ 0 (32 * i{hr} + 32) 0 (32 * i{hr}) _ _ h1); 1,2: smt().
  rewrite (_: 32 * (i{hr} + 1) = 32 * i{hr} + 32) 1:/# h2 /=.
  by move: hi0 hlt; clear hv h1 h2; smt().
auto => /> hh hb; split; 1: by move=> j /#.
move=> xi i tr hi8 hv hi0 hil hxi.
have e : 32 * i = 128 by smt().
move: hxi; rewrite e => hxi; split; 1: by rewrite K32.full_init.
move=> _ _ r _ hvr.
by rewrite !valid_cat hv hvr /valid.
qed.

lemma _sha256_compress_one_proof _h _b_h _p _ms : _sha256_compress_one_spec _h _b_h _p _ms.
proof.
rewrite /_sha256_compress_one_spec; proc; wp.
ecall (__sha256_avx2_proof param_2 (BArray32.init_arr (W8.of_int 255)) param_1 b_param param_0 param); wp.
while (valid trace__sha256_compress_one /\ 0 <= i <= 4 /\
       is_valid ptr_modulus Glob.mem_v (W64.to_uint p) 64 /\ BArray128.is_init b_x 0 (32 * i)).
+ wp; skip => &hr [[#] hv hi0 hi1 hval hxi] hlt.
  have hm := valid_sub _ _ _ (16 * i{hr}) 16 hval _ _ _; 1..3: smt().
  rewrite /= !valid_cat hv /valid /= hm hval (_: i{hr} * 32 = 32 * i{hr}) 1:/# x_here.
  have h1 := x_ext b_x{hr} i{hr} hi0 hxi.
  have h2 := x_ext _ i{hr} hi0 (K128.is_init_sub _ 0 (32 * i{hr} + 32) 0 (32 * i{hr}) _ _ h1); 1,2: smt().
  rewrite (_: 32 * (i{hr} + 1) = 32 * i{hr} + 32) 1:/# h2 /=.
  by move: hi0 hlt; clear hv h1 h2 hval hm; smt().
auto => /> &hr hh hv1 hv2 hv3; split; 1: by move=> j /#.
move=> xi i tr hi8 hv hi0 hil hxi.
have e : 32 * i = 128 by smt().
move: hxi; rewrite e => hxi; split; 1: by rewrite K32.full_init.
move=> _ _ r _ hvr.
by rewrite !valid_cat hv hvr /valid.
qed.

lemma _sha256_compress_two_proof _h _b_h _p _ms : _sha256_compress_two_spec _h _b_h _p _ms.
proof.
rewrite /_sha256_compress_two_spec; proc; wp.
ecall (__sha256_avx2_proof param_2 (BArray32.init_arr (W8.of_int 255)) param_1 b_param param_0 param); wp.
while (valid trace__sha256_compress_two /\ 0 <= i <= 4 /\
       is_valid ptr_modulus Glob.mem_v (W64.to_uint p) 128 /\ BArray128.is_init b_x 0 (32 * i)).
+ wp; skip => &hr [[#] hv hi0 hi1 hval hxi] hlt.
  have hm := valid_sub _ _ _ (16 * i{hr}) 16 hval _ _ _; 1..3: smt().
  have hm1 := valid_sub _ _ _ 64 64 hval _ _ _; 1..3: smt().
  have hm2 := valid_sub _ _ _ (16 * i{hr}) 16 hm1 _ _ _; 1..3: smt().
  rewrite /= !valid_cat hv /valid /= hm hm2 hval (_: i{hr} * 32 = 32 * i{hr}) 1:/#.
  rewrite !x_here.
  have h1 := x_ext b_x{hr} i{hr} hi0 hxi.
  have h2 := x_ext _ i{hr} hi0 (K128.is_init_sub _ 0 (32 * i{hr} + 32) 0 (32 * i{hr}) _ _ h1); 1,2: smt().
  have h3 := x_ext _ i{hr} hi0 (K128.is_init_sub _ 0 (32 * i{hr} + 32) 0 (32 * i{hr}) _ _ h2); 1,2: smt().
  rewrite (_: 32 * (i{hr} + 1) = 32 * i{hr} + 32) 1:/# h3 /=.
  by move: hi0 hlt; clear hv h1 h2 h3 hval hm hm1 hm2; smt().
auto => /> &hr hh hv1 hv2 hv3; split; 1: by move=> j /#.
move=> xi i tr hi8 hv hi0 hil hxi.
have e : 32 * i = 128 by smt().
move: hxi; rewrite e => hxi; split; 1: by rewrite K32.full_init.
move=> _ _ r _ hvr.
by rewrite !valid_cat hv hvr /valid.
qed.

lemma valid_pre mv (p : W64.t) n l : is_valid ptr_modulus mv (W64.to_uint p) n => 0 <= l <= n =>
  is_valid ptr_modulus mv (W64.to_uint p) l.
proof.
rewrite /is_valid => -[hv [h0 hb]] hl; split; 1: by move=> j hj; apply hv; smt().
by move: h0 hb hl; clear hv; smt().
qed.

lemma ule2s (n : W64.t) : (W64.of_int 2 \ule n) = (2 <= W64.to_uint n).
proof. by rewrite W64.uleE W64.of_uintK pmod_small. qed.

lemma sub2 (n : W64.t) : 2 <= W64.to_uint n => W64.to_uint (n - W64.of_int 2) = W64.to_uint n - 2.
proof.
by move=> h2; rewrite W64.to_uintB 1:ule2s //.
qed.

lemma _sha256_compress_blocks_proof _h _b_h _p _n _ms :
  _sha256_compress_blocks_spec _h _b_h _p _n _ms.
proof.
rewrite /_sha256_compress_blocks_spec; proc.
seq 10 : (valid trace__sha256_compress_blocks /\
          !more /\ more = (2 <= W64.to_uint n) /\
          is_valid ptr_modulus Glob.mem_v (W64.to_uint p) (64 * W64.to_uint n)).
+ while (valid trace__sha256_compress_blocks /\
         more = (2 <= W64.to_uint n) /\
         is_valid ptr_modulus Glob.mem_v (W64.to_uint p) (64 * W64.to_uint n)).
  + wp; ecall (_sha256_compress_two_proof param_1 (BArray32.init_arr (W8.of_int 255)) param_0 param); wp; skip.
    move=> &hr [[#] hv hmore hval] hc.
    have h2 : 2 <= W64.to_uint n{hr} by rewrite -hmore.
    rewrite /= /SLH64.protect_64 K32.full_init (valid_pre _ _ _ 128 hval) /=; 1: by move: h2; clear hval; smt().
    move=> r [hr hvr]; rewrite ule2s sub2 // hr /=.
    rewrite !valid_cat hv hvr /valid /=.
    have := valid_sub _ _ _ 128 (64 * (W64.to_uint n{hr} - 2)) hval _ _ _; 1..3: by move: h2; clear hval; smt().
    by move=> ->.
  wp; skip => &hr /= [#] 5!->> hh hlt hval0.
  have hn : W64.to_uint n{hr} < 288230376151711744.
  + by move: hlt; rewrite W64.ultE W64.to_uint_small.
  have e : W64.to_uint (W64.of_int 64 * n{hr}) = 64 * W64.to_uint n{hr}.
  + rewrite W64.to_uintM_small W64.to_uint_small //.
    by move: hn; smt(W64.to_uint_cmp).
  move: hval0; rewrite e => hval0.
  split; 1: by rewrite /valid /= ule2s hh hlt hval0.
  move=> mo n0 p0 tr hmo [#] hv hmore hval.
  by do 3!(split; 1: assumption); assumption.
sp; if.
+ wp; ecall (_sha256_compress_one_proof param_4 (BArray32.init_arr (W8.of_int 255)) param_3 param_2); wp; skip.
  move=> &hr [[mo0 ms0 [#] _ hmore' hv hmo hmo2 hval] hc].
  have hne : n{hr} <> W64.zero by rewrite -hmore'.
  have hn2 : W64.to_uint n{hr} < 2 by move: hmo; rewrite hmo2; smt().
  have h1 : W64.to_uint n{hr} = 1.
  + case: (W64.to_uint n{hr} = 0) => hz; last by move: hn2 hz; smt(W64.to_uint_cmp).
    by move: hne; rewrite W64.to_uint_eq hz W64.to_uint0.
  split.
  + by rewrite /= K32.full_init (valid_pre _ _ _ 64 hval) // h1.
  move=> _ r [hr3 hvr] /=; rewrite hr3 K32.full_init /=.
  by rewrite !valid_cat hv hvr /valid.
wp; skip => &hr [[mo0 ms0 [#] _ hmore' hv hmo hmo2 hval] hc].
by rewrite /= K32.full_init hv.
qed.
