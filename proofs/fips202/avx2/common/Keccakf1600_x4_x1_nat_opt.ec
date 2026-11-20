(******************************************************************************
   Keccakf1600_x4_x1_nat_opt.ec:

   Correctness of the interleaved four-way and one-way Keccak-f[1600]
   permutations (keccakf1600x4_x1_nat_opt.jinc).
******************************************************************************)
require import AllCore List Int IntDiv.

from Jasmin require import JModel_x86.

from CryptoSpecs require import FIPS202_Keccakf1600 Keccakf1600_Spec.

require import Keccak1600_avx2x4.

require import Keccak_bindings.

from JazzEC require import Keccak1600_Jazz.
from JazzEC require import Array1 Array24 Array25.

require import Keccakf1600_avx2x4_nat Keccakf1600_opt.

(* the four-way round: the round of __keccakf1600_avx2x4_nat on a stack state *)
lemma x4_round_ll: islossless M.__f1600_x4_round
by islossless.

equiv x4_round_native:
 M.__f1600_x4_round ~ M.__f1600_loopbody_native
 : ={st,i,y10,y14,y8,y15,y9,y13,y3,y7,y2} /\
   rol8{2} = rOL8 /\ rol56{2} = rOL56 /\ rC{2} = kECCAK1600_RC
 ==> ={res}.
proof.
proc; simplify.
(* the constants read as globals on the left, as arguments on the right *)
proc change {1} [97..98] :
  { y15 <- VPBROADCAST_4u64 kECCAK1600_RC.[to_uint (W64.of_int i)]; }; first by auto.
proc change {2} 96 :
  { y15 <- VPBROADCAST_4u64 kECCAK1600_RC.[to_uint (W64.of_int i)]; }; first by auto.
proc change {2} 161 : { y7 <- VPSHUFB_256 y7 rOL8.[0]; }; first by auto.
proc change {2} 209 : { y6 <- VPSHUFB_256 y6 rOL56.[0]; }; first by auto.
kill {1} 1; first by auto.
by sim.
qed.

hoare x4_round_h _st _regs _i _rc:
 M.__f1600_x4_round
 : st=_st /\ (y10,y14,y8,y15,y9,y13,y3,y7,y2)=_regs /\ rc_spec.[i]=_rc /\ i=_i /\ 0 <= _i < 24
 ==> regs_unfetch res.`1 (res.`2,res.`3,res.`4,res.`5,res.`6,res.`7,res.`8,res.`9,res.`10)
     = st4x_map (keccak_round_op _rc) (regs_unfetch _st _regs).
proof.
conseq x4_round_native (loopbody_nat_h _st _regs _i _rc) => [&1 /> * | //].
by exists (st{1}, rOL8, rOL56, kECCAK1600_RC, i{1},
           y10{1}, y14{1}, y8{1}, y15{1}, y9{1}, y13{1}, y3{1}, y7{1}, y2{1}).
qed.

(* an iteration: two rounds of each permutation *)
equiv x4_x1_iteration_opt:
 M.__keccakf1600_x4_x1_nat_opt_iteration ~ M.keccakf1600_opt_loop_body
 : ={rax,rbp,rdi,r13,r10,r11,r8,rsi,r15,rbx,a,e}
 ==> (res{1}.`1,res{1}.`2,res{1}.`3,res{1}.`4,res{1}.`5,res{1}.`6,
      res{1}.`7,res{1}.`8,res{1}.`9,res{1}.`10,res{1}.`11,res{1}.`12) = res{2}.
proof.
proc; simplify.
(* the two four-way rounds first *)
swap {1} [197..198] -191.
seq 7 1 : (={rax,rbp,rdi,r13,r10,r11,r8,rsi,r15,rbx,a,e,rC}).
+ by wp; call {1} x4_round_ll; wp; call {1} x4_round_ll; auto.
by sim.
qed.

lemma x4_x1_iteration_x1 rc1 rc2 (xx:_*(_*_*_*_*_*_*_*_*_)) c:
 rc1 = rc_spec.[to_uint c] => rc2 = rc_spec.[to_uint c + 1] =>
 hoare [
 M.__keccakf1600_x4_x1_nat_opt_iteration
 : rax=c /\ 0 <= to_uint c < 24 /\ (rbp,rdi,r13,r10,r11,r8,rsi,r15,rbx)=xx.`2 /\ a=xx.`1
 ==> res.`1 = c + W64.of_int 2
     /\ store_regs res.`11 (res.`2,res.`3,res.`4,res.`5,res.`6,res.`7,res.`8,res.`9,res.`10)
        = keccak_dround_opt rc1 rc2 xx
 ].
proof.
move=> E1 E2.
conseq x4_x1_iteration_opt (keccakf1600_dround_opt_h rc1 rc2 xx c E1 E2)
  => [&1 /> 2? <- <- | />].
by exists (rax{1},rbp{1},rdi{1},r13{1},r10{1},r11{1},r8{1},rsi{1},r15{1},rbx{1},a{1},e{1}).
qed.

hoare x4_x1_iteration_x4 rc1 rc2 c _st _regs:
 M.__keccakf1600_x4_x1_nat_opt_iteration
 : rc_spec.[to_uint c] = rc1 /\ rc_spec.[to_uint c + 1] = rc2 /\
   rax=c /\ 0 <= to_uint c <= 22 /\ st4=_st /\ (y10,y14,y8,y15,y9,y13,y3,y7,y2)=_regs
 ==> regs_unfetch res.`13
       (res.`14,res.`15,res.`16,res.`17,res.`18,res.`19,res.`20,res.`21,res.`22)
     = st4x_map (keccak_round_op rc2)
         (st4x_map (keccak_round_op rc1) (regs_unfetch _st _regs)).
proof.
proc.
(* the two four-way rounds first: the rest does not touch their state *)
swap [197..198] -191.
seq 7 : (regs_unfetch st4 (y10,y14,y8,y15,y9,y13,y3,y7,y2)
         = st4x_map (keccak_round_op rc2)
             (st4x_map (keccak_round_op rc1) (regs_unfetch _st _regs))).
+ ecall (x4_round_h st4 (y10,y14,y8,y15,y9,y13,y3,y7,y2) i rc2); wp.
  ecall (x4_round_h st4 (y10,y14,y8,y15,y9,y13,y3,y7,y2) i rc1); auto => /> &m *.
  by split => [/# | ? r1 -> /= /#].
by conseq (: true ==> true).
qed.

lemma x4_x1_iteration_h rc1 rc2 c (xx:_*(_*_*_*_*_*_*_*_*_)) _st _regs:
 rc1 = rc_spec.[to_uint c] => rc2 = rc_spec.[to_uint c + 1] =>
 hoare [
 M.__keccakf1600_x4_x1_nat_opt_iteration
 : rax=c /\ 0 <= to_uint c <= 22 /\
   (rbp,rdi,r13,r10,r11,r8,rsi,r15,rbx)=xx.`2 /\ a=xx.`1 /\
   st4=_st /\ (y10,y14,y8,y15,y9,y13,y3,y7,y2)=_regs
 ==> res.`1 = c + W64.of_int 2
     /\ store_regs res.`11 (res.`2,res.`3,res.`4,res.`5,res.`6,res.`7,res.`8,res.`9,res.`10)
        = keccak_dround_opt rc1 rc2 xx
     /\ regs_unfetch res.`13
          (res.`14,res.`15,res.`16,res.`17,res.`18,res.`19,res.`20,res.`21,res.`22)
        = st4x_map (keccak_round_op rc2)
            (st4x_map (keccak_round_op rc1) (regs_unfetch _st _regs))
 ].
proof.
move=> E1 E2.
by conseq (x4_x1_iteration_x1 rc1 rc2 xx c E1 E2) (x4_x1_iteration_x4 rc1 rc2 c _st _regs)
  => /#.
qed.

lemma x4_x1_iteration_ll: islossless M.__keccakf1600_x4_x1_nat_opt_iteration
by islossless.

(* the invariant of the loop: the rounds 0 to c-1 of both permutations done *)
op x4_x1_inv (_a4: W256.t Array25.t) (_a1: W64.t Array25.t) (c: W64.t)
  (a: W64.t Array25.t) regs1 (st4: W256.t Array25.t) regs4 =
 to_uint c <= 24 /\ 2 %| to_uint c /\
 store_regs a regs1 = keccak_round_i (to_uint c) _a1 /\
 regs_unfetch st4 regs4 = st4x_map (keccak_round_i (to_uint c)) _a4.

lemma keccak_round_i2 n st: 0 <= n =>
 keccak_round_i (n + 2) st
 = keccak_round_op rc_spec.[n + 1] (keccak_round_op rc_spec.[n] (keccak_round_i n st)).
proof. by move=> ?; rewrite (: n + 2 = n + 1 + 1) 1:/# !iotaSr 1,2:/# !foldl_rcons. qed.

hoare x4_x1_iteration_inv _a4 _a1:
 M.__keccakf1600_x4_x1_nat_opt_iteration
 : x4_x1_inv _a4 _a1 rax a (rbp,rdi,r13,r10,r11,r8,rsi,r15,rbx) st4
     (y10,y14,y8,y15,y9,y13,y3,y7,y2) /\ to_uint rax < 24
 ==> x4_x1_inv _a4 _a1 res.`1 res.`11
       (res.`2,res.`3,res.`4,res.`5,res.`6,res.`7,res.`8,res.`9,res.`10) res.`13
       (res.`14,res.`15,res.`16,res.`17,res.`18,res.`19,res.`20,res.`21,res.`22).
proof.
proc*.
ecall (x4_x1_iteration_h rc_spec.[to_uint rax] rc_spec.[to_uint rax + 1] rax
         (a,(rbp,rdi,r13,r10,r11,r8,rsi,r15,rbx)) st4 (y10,y14,y8,y15,y9,y13,y3,y7,y2));
 last 2 smt().
auto => /> &m _ Hd H1 H4 ?; have ? := W64.to_uint_cmp rax{m}.
split => [| ?? r -> -> ->]; first smt(dvdzE).
rewrite to_uintD_small 1:/# /= /keccak_dround_opt /= H1 H4 !st4x_map_comp keccak_round_i2 //.
split; first smt().
split; first smt(dvdzE).
split => //; congr; apply fun_ext => s /=.
by rewrite keccak_round_i2.
qed.

lemma st4x_map_id st: st4x_map (fun s => s) st = st.
proof. by rewrite st4x_mapE st4x_unpackK. qed.

hoare __keccakf1600_x4_x1_nat_opt_h _a4 _a1:
 M.__keccakf1600_x4_x1_nat_opt
 : st4 = _a4 /\ a = _a1
 ==> res = (st4x_map keccak_f1600_op _a4, keccak_f1600_op _a1).
proof.
proc.
ecall (store_regs_opt_h a (rbp,rdi,r13,r10,r11,r8,rsi,r15,rbx)).
ecall (regs_unfetch_h st4 (y10,y14,y8,y15,y9,y13,y3,y7,y2)).
while (x4_x1_inv _a4 _a1 rax a (rbp,rdi,r13,r10,r11,r8,rsi,r15,rbx) st4
         (y10,y14,y8,y15,y9,y13,y3,y7,y2)).
+ by call (x4_x1_iteration_inv _a4 _a1); auto => /> &hr 4?; rewrite ultE of_uintK.
call (x4_x1_iteration_inv _a4 _a1); wp.
ecall (read_regs_opt_h a); ecall (regs_fetch_h st4); auto => />.
have E1 := read_regsK _a1; have E4 := regs_fetchK _a4.
split; first split; rewrite iota0 //=.
+ by rewrite /regs_fetch /= st4x_map_id; exact E4.
move=> _ _ _ r _ _ _ _ a0 5? c 14? Hc Hle _ -> ->.
rewrite ultE of_uintK /= in Hc; have -> /= : to_uint c = 24 by smt().
by split.
qed.

phoare x4_x1_iteration_rax c:
 [ M.__keccakf1600_x4_x1_nat_opt_iteration
 : rax = c /\ 0 <= to_uint c < 24 ==> res.`1 = c + W64.of_int 2 ] = 1%r.
proof.
conseq x4_x1_iteration_ll (: rax = c /\ 0 <= to_uint c < 24 ==> res.`1 = c + W64.of_int 2)
  => //.
proc*; ecall (x4_x1_iteration_x1 rc_spec.[to_uint rax] rc_spec.[to_uint rax + 1]
               (a,(rbp,rdi,r13,r10,r11,r8,rsi,r15,rbx)) rax); last 2 smt().
by auto => />.
qed.

lemma __keccakf1600_x4_x1_nat_opt_ll: islossless M.__keccakf1600_x4_x1_nat_opt.
proof.
proc; inline __regs_unfetch store_regs_opt __regs_fetch read_regs_opt.
wp; while true (24 - to_uint rax).
+ move=> z; wp; ecall (x4_x1_iteration_rax rax); auto => /> &m.
  rewrite ultE of_uintK /= => ?; split; first smt(W64.to_uint_cmp).
  by move=> 2? r ->; rewrite to_uintD_small /#.
by wp; call x4_x1_iteration_ll; auto => /> rax ?; rewrite ultE of_uintK /#.
qed.

phoare __keccakf1600_x4_x1_nat_opt_ph _a4 _a1:
 [ M.__keccakf1600_x4_x1_nat_opt
 : st4 = _a4 /\ a = _a1
 ==> res = (st4x_map keccak_f1600_op _a4, keccak_f1600_op _a1)
 ] = 1%r.
proof. by conseq __keccakf1600_x4_x1_nat_opt_ll (__keccakf1600_x4_x1_nat_opt_h _a4 _a1). qed.

(* the subroutine: the copies of both states into its frame and back *)
hoare keccakf1600_x4_x1_nat_opt_h _a4 _a1:
 M._keccakf1600_x4_x1_nat_opt
 : p4 = _a4 /\ p1 = _a1
 ==> res = (st4x_map keccak_f1600_op _a4, keccak_f1600_op _a1).
proof.
proc.
seq 6 : (s4 = _a4 /\ s1 = _a1).
+ while (0 <= j <= 25 /\ p4 = _a4 /\ p1 = _a1 /\
         forall k, 0 <= k < j => s4.[k] = _a4.[k] /\ s1.[k] = _a1.[k]).
  + by auto => /> &m 2? H ?; split => [/# | k ??]; rewrite !get_setE /#.
  by auto => />; split => [/# | j t1 t4 3? H]; split; apply tP => k ?; smt().
seq 3 : (s4 = st4x_map keccak_f1600_op _a4 /\ s1 = keccak_f1600_op _a1).
+ by ecall (__keccakf1600_x4_x1_nat_opt_h s4 s1); auto.
while (0 <= j <= 25 /\ s4 = st4x_map keccak_f1600_op _a4 /\ s1 = keccak_f1600_op _a1 /\
       forall k, 0 <= k < j => p4.[k] = s4.[k] /\ p1.[k] = s1.[k]).
+ by auto => /> &m 2? H ?; split => [/# | k ??]; rewrite !get_setE /#.
by auto => /> *; split => [/# | j t1 t4 3? H]; split; apply tP => k ?; smt().
qed.

lemma keccakf1600_x4_x1_nat_opt_ll: islossless M._keccakf1600_x4_x1_nat_opt.
proof.
proc; wp; while true (25 - j); first by auto => /#.
wp; call __keccakf1600_x4_x1_nat_opt_ll; wp; while true (25 - j); first by auto => /#.
by auto => /#.
qed.

phoare keccakf1600_x4_x1_nat_opt_ph _a4 _a1:
 [ M._keccakf1600_x4_x1_nat_opt
 : p4 = _a4 /\ p1 = _a1
 ==> res = (st4x_map keccak_f1600_op _a4, keccak_f1600_op _a1)
 ] = 1%r.
proof. by conseq keccakf1600_x4_x1_nat_opt_ll (keccakf1600_x4_x1_nat_opt_h _a4 _a1). qed.
