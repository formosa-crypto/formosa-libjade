(* -------------------------------------------------------------------- *)
(* Safety of the interleaved four-way and one-way Keccak-f[1600]
   permutations _keccakf1600_x4_x1_nat_opt (keccakf1600x4_x1_nat_opt.jinc) and
   of the selection _keccakf1600_x4_x1 (keccakf1600x4_x1.jinc).
   Model: ../extracted/Keccak1600_Jazz_safety.ec (jasmin2ec -m safety).   *)
(* -------------------------------------------------------------------- *)
require import AllCore IntDiv CoreMap List Distr.
require import Keccak1600_Jazz_safety Keccak1600_common_safety.
require import Keccak1600_safety_lib Keccakf1600_safety Keccakf1600x4_safety.
from Jasmin require import JModel_x86 Jcheck JSafety.

lemma __f1600_x4_round_proof _st _b_st _i _y10 _y14 _y8 _y15 _y9 _y13 _y3 _y7 _y2 :
  __f1600_x4_round_spec _st _b_st _i _y10 _y14 _y8 _y15 _y9 _y13 _y3 _y7 _y2.
proof.
hint +safety.
rewrite /__f1600_x4_round_spec; proc.
simplify.
wp 300. simplify. wp 290. simplify. wp 280. simplify. wp 270. simplify. wp 260. simplify.
wp 250. simplify. wp 240. simplify. wp 230. simplify. wp 220. simplify. wp 210. simplify.
wp 200. simplify. wp 190. simplify. wp 180. simplify. wp 170. simplify. wp 160. simplify.
wp 150. simplify. wp 140. simplify. wp 130. simplify. wp 120. simplify. wp 110. simplify.
wp 100. simplify. wp 90. simplify. wp 80. simplify. wp 70. simplify. wp 60. simplify.
wp 50. simplify. wp 40. simplify. wp 30. simplify. wp 20. simplify. wp 10. simplify.
wp 0. simplify.
by skip => /> *; (try split);
   smt(W64.of_uintK pow2_64 BI800.is_init_set256d_in BI800.is_init_set256d_out).
qed.

lemma __keccakf1600_x4_x1_nat_opt_iteration_proof _rax _rbp _rdi _r13 _r10 _r11 _r8 _rsi _r15
    _rbx _a _b_a _e _b_e _st4 _b_st4 _y10 _y14 _y8 _y15 _y9 _y13 _y3 _y7 _y2 :
  __keccakf1600_x4_x1_nat_opt_iteration_spec _rax _rbp _rdi _r13 _r10 _r11 _r8 _rsi _r15 _rbx
    _a _b_a _e _b_e _st4 _b_st4 _y10 _y14 _y8 _y15 _y9 _y13 _y3 _y7 _y2.
proof.
hint +safety.
rewrite /__keccakf1600_x4_x1_nat_opt_iteration_spec; proc.
simplify.
wp 490. simplify. wp 480. simplify. wp 470. simplify. wp 460. simplify. wp 450. simplify.
wp 440. simplify. wp 430. simplify. wp 420. simplify. wp 410. simplify. wp 400. simplify.
wp 390. simplify. wp 380. simplify. wp 370. simplify. wp 360. simplify. wp 350. simplify.
wp 340. simplify. wp 330. simplify. wp 320. simplify. wp 310. simplify. wp 300. simplify.
wp 290. simplify. wp 280. simplify. wp 271. simplify.
ecall (__f1600_x4_round_proof param_20 (BArray800.init_arr (W8.of_int 255)) param_19 param_18
       param_17 param_16 param_15 param_14 param_13 param_12 param_11 param_10).
wp 260. simplify. wp 250. simplify. wp 240. simplify. wp 230. simplify. wp 220. simplify.
wp 210. simplify. wp 200. simplify. wp 190. simplify. wp 180. simplify. wp 170. simplify.
wp 160. simplify. wp 150. simplify. wp 140. simplify. wp 130. simplify. wp 120. simplify.
wp 110. simplify. wp 100. simplify. wp 90. simplify. wp 80. simplify. wp 70. simplify.
wp 60. simplify. wp 50. simplify. wp 40. simplify. wp 30. simplify. wp 22. simplify.
ecall (__f1600_x4_round_proof param_9 (BArray800.init_arr (W8.of_int 255)) param_8 param_7
       param_6 param_5 param_4 param_3 param_2 param_1 param_0 param).
wp 0. simplify.
by skip => /> *; (try split);
   smt(W64.uleE W64.to_uintD_small W64.to_uint_cmp W64.of_uintK W64.to_uint1 pow2_64
       BI200.is_init_set64d_in BI200.is_init_set64d_out).
qed.

lemma __keccakf1600_x4_x1_nat_opt_proof _st4 _b_st4 _a _b_a :
  __keccakf1600_x4_x1_nat_opt_spec _st4 _b_st4 _a _b_a.
proof.
hint +safety.
rewrite /__keccakf1600_x4_x1_nat_opt_spec; proc.
seq 123 : (valid trace___keccakf1600_x4_x1_nat_opt /\ W64.to_uint rax %% 2 = 0 /\
           W64.to_uint rax <= 24).
+ wp; ecall (__keccakf1600_x4_x1_nat_opt_iteration_proof param_22 param_21 param_20 param_19
             param_18 param_17 param_16 param_15 param_14 param_13 param_12
             (BArray200.init_arr (W8.of_int 255)) param_11 b_param param_10
             (BArray800.init_arr (W8.of_int 255)) param_9 param_8 param_7 param_6 param_5
             param_4 param_3 param_2 param_1).
  wp; ecall (read_regs_opt_proof param_0 (BArray200.init_arr (W8.of_int 255))).
  wp; ecall (__regs_fetch_proof param (BArray800.init_arr (W8.of_int 255))).
  by auto => /> *;
     do 3! (try (split; [smt(W64.uleE W64.ultE W64.to_uintD_small W64.to_uint_cmp W64.of_uintK
                             pow2_64) | move=> *]));
     (try split); smt(W64.uleE W64.ultE W64.to_uintD_small W64.to_uint_cmp W64.of_uintK pow2_64).
wp; ecall (store_regs_opt_proof param_42 (BArray200.init_arr (W8.of_int 255)) param_41 param_40
           param_39 param_38 param_37 param_36 param_35 param_34 param_33).
wp; ecall (__regs_unfetch_proof param_32 (BArray800.init_arr (W8.of_int 255)) param_31 param_30
           param_29 param_28 param_27 param_26 param_25 param_24 param_23).
wp; while (valid trace___keccakf1600_x4_x1_nat_opt /\ W64.to_uint rax %% 2 = 0 /\
           W64.to_uint rax <= 24).
+ wp; ecall (__keccakf1600_x4_x1_nat_opt_iteration_proof param_22 param_21 param_20 param_19
             param_18 param_17 param_16 param_15 param_14 param_13 param_12
             (BArray200.init_arr (W8.of_int 255)) param_11 b_param param_10
             (BArray800.init_arr (W8.of_int 255)) param_9 param_8 param_7 param_6 param_5
             param_4 param_3 param_2 param_1).
  by auto => /> *;
     try (split; [smt(W64.uleE W64.ultE W64.to_uintD_small W64.to_uint_cmp W64.of_uintK pow2_64) |
                      move=> *]);
     (try split); smt(W64.uleE W64.ultE W64.to_uintD_small W64.to_uint_cmp W64.of_uintK pow2_64).
by auto => /> *; do 2! (try (split; [smt() | move=> *])); (try split); smt().
qed.

lemma _keccakf1600_x4_x1_nat_opt_proof _p4 _b_p4 _p1 _b_p1 :
  _keccakf1600_x4_x1_nat_opt_spec _p4 _b_p4 _p1 _b_p1.
proof.
hint +safety.
rewrite /_keccakf1600_x4_x1_nat_opt_spec; proc.
wp; while (valid trace__keccakf1600_x4_x1_nat_opt /\ 0 <= j <= 25).
+ by auto => /> *; (try split); smt().
wp; ecall (__keccakf1600_x4_x1_nat_opt_proof param_0 b_param_0 param b_param).
wp; while (valid trace__keccakf1600_x4_x1_nat_opt /\ 0 <= j <= 25 /\
           BArray800.is_init b_s4 0 (j * 32) /\ BArray200.is_init b_s1 0 (j * 8)).
+ by auto => /> *; (try split);
     smt(BI800.is_init_set256d_in BI200.is_init_set64d_in BI800.is_init_le0
         BI200.is_init_le0).
by auto => /> *; do 2! (try (split; [smt() | move=> *])); (try split); smt().
qed.

(* dispatcher *)

lemma _keccakf1600_x4_x1_proof _a4 _b_a4 _a1 _b_a1 :
  _keccakf1600_x4_x1_spec _a4 _b_a4 _a1 _b_a1.
proof.
hint +safety.
rewrite /_keccakf1600_x4_x1_spec; proc.
inline M.__KECCAK_Fx4 M.__KECCAK_F.
sp 29.
if.
+ wp; ecall (_keccakf1600_x4_x1_nat_opt_proof param_2 (BArray800.init_arr (W8.of_int 255))
             param_1 (BArray200.init_arr (W8.of_int 255))).
  by auto => /> *; try (split; [smt() | move=> *]); (try split); smt().
wp; ecall (_keccakf1600_proof param_4 (BArray200.init_arr (W8.of_int 255))).
wp; ecall (_keccakf1600_avx2x4_proof param_3 (BArray800.init_arr (W8.of_int 255))).
by auto => /> *; do 2! (try (split; [smt() | move=> *])); (try split); smt().
qed.
