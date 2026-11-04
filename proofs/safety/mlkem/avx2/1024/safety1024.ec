(* Safety of the ML-KEM-1024 AVX2 implementation: every procedure of the
   safety model meets its contract (`<f>_spec`), i.e. the trace of the
   safety checks of a run from initialised inputs is valid and the outputs
   are initialised.

   The Keccak procedures called by ML-KEM are those of the fips202
   implementation: each one meets its contract by the safety proof of that
   implementation, transferred by an equivalence (sim) between the two
   models; the wrappers are proved from them. KECCAK_PERMUTATION selects the
   reference permutation, so the AVX2 branch of the wrappers is not compiled
   and is discarded (__KECCAK_F_permutation).

   Most scripts are generated: after unrolling the constant-bound loops and
   discharging the callees by their lemmas, the initialisation witnesses are
   closed terms and the goals reduce by the hints of ByteArrayInit; the
   few loops with symbolic bounds or data-dependent conditions keep an
   invariant and hand-written word arithmetic. *)
require import AllCore IntDiv CoreMap List Distr.
from Jasmin require import JModel_x86 Jcheck JSafety.
require import Jkem1024_safety ByteArrayInit.

require import BArray1 BArray2 BArray4 BArray8 BArray16 BArray32 BArray33 BArray40
  BArray64 BArray128 BArray160 BArray192 BArray200 BArray224 BArray256 BArray384 BArray512
  BArray536 BArray800 BArray1410 BArray1536 BArray1568 BArray1600 BArray2048 BArray2144
  BArray3168 BArray8192.
require import SBArray4_1 SBArray8_2 SBArray64_32 SBArray128_128 SBArray536_200
  SBArray1536_384 SBArray1568_160 SBArray1568_1410 SBArray1568_1536 SBArray2048_512
  SBArray2144_536 SBArray3168_32 SBArray3168_1536 SBArray3168_1568 SBArray8192_512
  SBArray8192_2048.
clone ByteArrayInit as BI1 with theory A <- BArray1.
clone ByteArrayInit as BI2 with theory A <- BArray2.
clone ByteArrayInit as BI4 with theory A <- BArray4.
clone ByteArrayInit as BI8 with theory A <- BArray8.
clone ByteArrayInit as BI16 with theory A <- BArray16.
clone ByteArrayInit as BI32 with theory A <- BArray32.
clone ByteArrayInit as BI33 with theory A <- BArray33.
clone ByteArrayInit as BI40 with theory A <- BArray40.
clone ByteArrayInit as BI64 with theory A <- BArray64.
clone ByteArrayInit as BI128 with theory A <- BArray128.
clone ByteArrayInit as BI160 with theory A <- BArray160.
clone ByteArrayInit as BI192 with theory A <- BArray192.
clone ByteArrayInit as BI200 with theory A <- BArray200.
clone ByteArrayInit as BI224 with theory A <- BArray224.
clone ByteArrayInit as BI256 with theory A <- BArray256.
clone ByteArrayInit as BI384 with theory A <- BArray384.
clone ByteArrayInit as BI512 with theory A <- BArray512.
clone ByteArrayInit as BI536 with theory A <- BArray536.
clone ByteArrayInit as BI800 with theory A <- BArray800.
clone ByteArrayInit as BI1410 with theory A <- BArray1410.
clone ByteArrayInit as BI1536 with theory A <- BArray1536.
clone ByteArrayInit as BI1568 with theory A <- BArray1568.
clone ByteArrayInit as BI1600 with theory A <- BArray1600.
clone ByteArrayInit as BI2048 with theory A <- BArray2048.
clone ByteArrayInit as BI2144 with theory A <- BArray2144.
clone ByteArrayInit as BI3168 with theory A <- BArray3168.
clone ByteArrayInit as BI8192 with theory A <- BArray8192.
clone SubByteArrayInit as SBI4_1 with theory SB <- SBArray4_1.
clone SubByteArrayInit as SBI8_2 with theory SB <- SBArray8_2.
clone SubByteArrayInit as SBI64_32 with theory SB <- SBArray64_32.
clone SubByteArrayInit as SBI128_128 with theory SB <- SBArray128_128.
clone SubByteArrayInit as SBI536_200 with theory SB <- SBArray536_200.
clone SubByteArrayInit as SBI1536_384 with theory SB <- SBArray1536_384.
clone SubByteArrayInit as SBI1568_160 with theory SB <- SBArray1568_160.
clone SubByteArrayInit as SBI1568_1410 with theory SB <- SBArray1568_1410.
clone SubByteArrayInit as SBI1568_1536 with theory SB <- SBArray1568_1536.
clone SubByteArrayInit as SBI2048_512 with theory SB <- SBArray2048_512.
clone SubByteArrayInit as SBI2144_536 with theory SB <- SBArray2144_536.
clone SubByteArrayInit as SBI3168_32 with theory SB <- SBArray3168_32.
clone SubByteArrayInit as SBI3168_1536 with theory SB <- SBArray3168_1536.
clone SubByteArrayInit as SBI3168_1568 with theory SB <- SBArray3168_1568.
clone SubByteArrayInit as SBI8192_512 with theory SB <- SBArray8192_512.
clone SubByteArrayInit as SBI8192_2048 with theory SB <- SBArray8192_2048.

(* ---- the Keccak procedures, from the safety proofs of fips202 ---- *)
require Keccak1600_Jazz_safety Keccak1600_common_safety Keccakf1600_safety Keccak1600_safety
  Keccak1600_avx2_safety Keccakf1600x4_safety Keccak1600x4_safety.
require import BArray1 BArray2 BArray32 BArray33 BArray64 BArray128 BArray536 BArray1568 BArray1600.
clone Keccak1600_safety.KeccakArrayRefSafety as KR1568
  with op _ASIZE <- 1568, theory A <- BArray1568 proof _ASIZE_ge0 by done, _ASIZE_u64 by done.
clone Keccak1600_safety.KeccakArrayRefSafety as KR32
  with op _ASIZE <- 32, theory A <- BArray32 proof _ASIZE_ge0 by done, _ASIZE_u64 by done.
clone Keccak1600_safety.KeccakArrayRefSafety as KR33
  with op _ASIZE <- 33, theory A <- BArray33 proof _ASIZE_ge0 by done, _ASIZE_u64 by done.
clone Keccak1600_safety.KeccakArrayRefSafety as KR64
  with op _ASIZE <- 64, theory A <- BArray64 proof _ASIZE_ge0 by done, _ASIZE_u64 by done.
clone Keccak1600x4_safety.KeccakArrayAvx2x4Safety as KX432
  with op _ASIZE <- 32, theory A <- BArray32 proof _ASIZE_ge0 by done, _ASIZE_u64 by done.
clone Keccak1600x4_safety.KeccakArrayAvx2x4Safety as KX42
  with op _ASIZE <- 2, theory A <- BArray2 proof _ASIZE_ge0 by done, _ASIZE_u64 by done.
clone Keccak1600x4_safety.KeccakArrayAvx2x4Safety as KX4536
  with op _ASIZE <- 536, theory A <- BArray536 proof _ASIZE_ge0 by done, _ASIZE_u64 by done.
clone Keccak1600_safety.KeccakArrayRefSafety as KR1
  with op _ASIZE <- 1, theory A <- BArray1 proof _ASIZE_ge0 by done, _ASIZE_u64 by done.
clone Keccak1600_safety.KeccakArrayRefSafety as KR128
  with op _ASIZE <- 128, theory A <- BArray128 proof _ASIZE_ge0 by done, _ASIZE_u64 by done.
clone Keccak1600_safety.KeccakArrayRefSafety as KR1600
  with op _ASIZE <- 1600, theory A <- BArray1600 proof _ASIZE_ge0 by done, _ASIZE_u64 by done.
clone Keccak1600x4_safety.KeccakArrayAvx2x4Safety as KX41
  with op _ASIZE <- 1, theory A <- BArray1 proof _ASIZE_ge0 by done, _ASIZE_u64 by done.
clone Keccak1600x4_safety.KeccakArrayAvx2x4Safety as KX4128
  with op _ASIZE <- 128, theory A <- BArray128 proof _ASIZE_ge0 by done, _ASIZE_u64 by done.

lemma __KECCAK_F_proof _pERMUTATION :
  __KECCAK_F_spec _pERMUTATION.
proof.
have h := Keccak1600_common_safety.__KECCAK_F_proof _pERMUTATION.
have e : equiv [Jkem1024_safety.M.__KECCAK_F ~ Keccak1600_Jazz_safety.M.__KECCAK_F :
  ={arg, Glob.mem, Glob.mem_v} ==> ={res}] by sim.
rewrite /__KECCAK_F_spec; rewrite /Keccak1600_Jazz_safety.__KECCAK_F_spec in h.
by conseq e h => /> /#.
qed.

lemma __state_init_proof _st _b_st :
  __state_init_spec _st _b_st.
proof.
have h := Keccak1600_safety.__state_init_proof _st _b_st.
have e : equiv [Jkem1024_safety.M.__state_init ~ Keccak1600_Jazz_safety.M.__state_init :
  ={arg, Glob.mem, Glob.mem_v} ==> ={res}] by sim.
rewrite /__state_init_spec; rewrite /Keccak1600_Jazz_safety.__state_init_spec in h.
by conseq e h => /> /#.
qed.

lemma aPK____absorb_proof _st _b_st _aT _buf _b_buf __TRAILB __RATE8 :
  aPK____absorb_spec _st _b_st _aT _buf _b_buf __TRAILB __RATE8.
proof.
have h := KR1568.__absorb_proof _st _b_st _aT _buf _b_buf __TRAILB __RATE8.
have e : equiv [Jkem1024_safety.M.aPK____absorb ~ KR1568.MM.__absorb :
  ={arg, Glob.mem, Glob.mem_v} ==> ={res}] by sim.
rewrite /aPK____absorb_spec; rewrite /KR1568.__absorb_spec in h.
by conseq e h => /> /#.
qed.

lemma a32____squeeze_proof _st _b_st _buf _b_buf __RATE8 :
  a32____squeeze_spec _st _b_st _buf _b_buf __RATE8.
proof.
have h := KR32.__squeeze_proof _st _b_st _buf _b_buf __RATE8.
have e : equiv [Jkem1024_safety.M.a32____squeeze ~ KR32.MM.__squeeze :
  ={arg, Glob.mem, Glob.mem_v} ==> ={res}] by sim.
rewrite /a32____squeeze_spec; rewrite /KR32.__squeeze_spec in h.
by conseq e h => /> /#.
qed.

lemma a33____absorb_proof _st _b_st _aT _buf _b_buf __TRAILB __RATE8 :
  a33____absorb_spec _st _b_st _aT _buf _b_buf __TRAILB __RATE8.
proof.
have h := KR33.__absorb_proof _st _b_st _aT _buf _b_buf __TRAILB __RATE8.
have e : equiv [Jkem1024_safety.M.a33____absorb ~ KR33.MM.__absorb :
  ={arg, Glob.mem, Glob.mem_v} ==> ={res}] by sim.
rewrite /a33____absorb_spec; rewrite /KR33.__absorb_spec in h.
by conseq e h => /> /#.
qed.

lemma a64____squeeze_proof _st _b_st _buf _b_buf __RATE8 :
  a64____squeeze_spec _st _b_st _buf _b_buf __RATE8.
proof.
have h := KR64.__squeeze_proof _st _b_st _buf _b_buf __RATE8.
have e : equiv [Jkem1024_safety.M.a64____squeeze ~ KR64.MM.__squeeze :
  ={arg, Glob.mem, Glob.mem_v} ==> ={res}] by sim.
rewrite /a64____squeeze_spec; rewrite /KR64.__squeeze_spec in h.
by conseq e h => /> /#.
qed.

lemma a64____absorb_proof _st _b_st _aT _buf _b_buf __TRAILB __RATE8 :
  a64____absorb_spec _st _b_st _aT _buf _b_buf __TRAILB __RATE8.
proof.
have h := KR64.__absorb_proof _st _b_st _aT _buf _b_buf __TRAILB __RATE8.
have e : equiv [Jkem1024_safety.M.a64____absorb ~ KR64.MM.__absorb :
  ={arg, Glob.mem, Glob.mem_v} ==> ={res}] by sim.
rewrite /a64____absorb_spec; rewrite /KR64.__absorb_spec in h.
by conseq e h => /> /#.
qed.

lemma _keccakf1600_proof _a _b_a :
  _keccakf1600_spec _a _b_a.
proof.
have h := Keccakf1600_safety._keccakf1600_proof _a _b_a.
have e : equiv [Jkem1024_safety.M._keccakf1600 ~ Keccak1600_Jazz_safety.M._keccakf1600 :
  ={arg, Glob.mem, Glob.mem_v} ==> ={res}] by sim.
rewrite /_keccakf1600_spec; rewrite /Keccak1600_Jazz_safety._keccakf1600_spec in h.
by conseq e h => /> /#.
qed.

lemma __state_init_avx2x4_proof _st _b_st :
  __state_init_avx2x4_spec _st _b_st.
proof.
have h := Keccakf1600x4_safety.__state_init_avx2x4_proof _st _b_st.
have e : equiv [Jkem1024_safety.M.__state_init_avx2x4
  ~ Keccak1600_Jazz_safety.M.__state_init_avx2x4 :
  ={arg, Glob.mem, Glob.mem_v} ==> ={res}] by sim.
rewrite /__state_init_avx2x4_spec; rewrite /Keccak1600_Jazz_safety.__state_init_avx2x4_spec in h.
by conseq e h => /> /#.
qed.

lemma a32____absorb_bcast_avx2x4_proof _st _b_st _aT _buf _b_buf __TRAILB __RATE8 :
  a32____absorb_bcast_avx2x4_spec _st _b_st _aT _buf _b_buf __TRAILB __RATE8.
proof.
have h := KX432.__absorb_bcast_avx2x4_proof _st _b_st _aT _buf _b_buf __TRAILB __RATE8.
have e : equiv [Jkem1024_safety.M.a32____absorb_bcast_avx2x4 ~ KX432.MM.__absorb_bcast_avx2x4 :
  ={arg, Glob.mem, Glob.mem_v} ==> ={res}] by sim.
rewrite /a32____absorb_bcast_avx2x4_spec; rewrite /KX432.__absorb_bcast_avx2x4_spec in h.
by conseq e h => /> /#.
qed.

lemma a2____absorb_avx2x4_proof _st _b_st _aT _buf0 _b_buf0 _buf1 _b_buf1 _buf2 _b_buf2 _buf3
    _b_buf3 __TRAILB __RATE8 :
  a2____absorb_avx2x4_spec _st _b_st _aT _buf0 _b_buf0 _buf1 _b_buf1 _buf2 _b_buf2 _buf3 _b_buf3
    __TRAILB __RATE8.
proof.
have h := KX42.__absorb_avx2x4_proof _st _b_st _aT _buf0 _b_buf0 _buf1 _b_buf1 _buf2 _b_buf2 _buf3
  _b_buf3 __TRAILB __RATE8.
have e : equiv [Jkem1024_safety.M.a2____absorb_avx2x4 ~ KX42.MM.__absorb_avx2x4 :
  ={arg, Glob.mem, Glob.mem_v} ==> ={res}] by sim.
rewrite /a2____absorb_avx2x4_spec; rewrite /KX42.__absorb_avx2x4_spec in h.
by conseq e h => /> /#.
qed.

lemma _keccakf1600_avx2x4_proof _a _b_a :
  _keccakf1600_avx2x4_spec _a _b_a.
proof.
have h := Keccakf1600x4_safety._keccakf1600_avx2x4_proof _a _b_a.
have e : equiv [Jkem1024_safety.M._keccakf1600_avx2x4
  ~ Keccak1600_Jazz_safety.M._keccakf1600_avx2x4 :
  ={arg, Glob.mem, Glob.mem_v} ==> ={res}] by sim.
rewrite /_keccakf1600_avx2x4_spec; rewrite /Keccak1600_Jazz_safety._keccakf1600_avx2x4_spec in h.
by conseq e h => /> /#.
qed.

lemma aBUFLEN____dumpstate_avx2x4_proof _buf0 _b_buf0 _buf1 _b_buf1 _buf2 _b_buf2 _buf3 _b_buf3
    _offset __LEN _st _b_st :
  aBUFLEN____dumpstate_avx2x4_spec _buf0 _b_buf0 _buf1 _b_buf1 _buf2 _b_buf2 _buf3 _b_buf3 _offset
    __LEN _st _b_st.
proof.
have h := KX4536.__dumpstate_avx2x4_proof _buf0 _b_buf0 _buf1 _b_buf1 _buf2 _b_buf2 _buf3 _b_buf3
  _offset __LEN _st _b_st.
have e : equiv [Jkem1024_safety.M.aBUFLEN____dumpstate_avx2x4 ~ KX4536.MM.__dumpstate_avx2x4 :
  ={arg, Glob.mem, Glob.mem_v} ==> ={res}] by sim.
rewrite /aBUFLEN____dumpstate_avx2x4_spec; rewrite /KX4536.__dumpstate_avx2x4_spec in h.
by conseq e h => /> /#.
qed.

lemma a32____absorb_proof _st _b_st _aT _buf _b_buf __TRAILB __RATE8 :
  a32____absorb_spec _st _b_st _aT _buf _b_buf __TRAILB __RATE8.
proof.
have h := KR32.__absorb_proof _st _b_st _aT _buf _b_buf __TRAILB __RATE8.
have e : equiv [Jkem1024_safety.M.a32____absorb ~ KR32.MM.__absorb :
  ={arg, Glob.mem, Glob.mem_v} ==> ={res}] by sim.
rewrite /a32____absorb_spec; rewrite /KR32.__absorb_spec in h.
by conseq e h => /> /#.
qed.

lemma a1____absorb_proof _st _b_st _aT _buf _b_buf __TRAILB __RATE8 :
  a1____absorb_spec _st _b_st _aT _buf _b_buf __TRAILB __RATE8.
proof.
have h := KR1.__absorb_proof _st _b_st _aT _buf _b_buf __TRAILB __RATE8.
have e : equiv [Jkem1024_safety.M.a1____absorb ~ KR1.MM.__absorb :
  ={arg, Glob.mem, Glob.mem_v} ==> ={res}] by sim.
rewrite /a1____absorb_spec; rewrite /KR1.__absorb_spec in h.
by conseq e h => /> /#.
qed.

lemma a128____squeeze_proof _st _b_st _buf _b_buf __RATE8 :
  a128____squeeze_spec _st _b_st _buf _b_buf __RATE8.
proof.
have h := KR128.__squeeze_proof _st _b_st _buf _b_buf __RATE8.
have e : equiv [Jkem1024_safety.M.a128____squeeze ~ KR128.MM.__squeeze :
  ={arg, Glob.mem, Glob.mem_v} ==> ={res}] by sim.
rewrite /a128____squeeze_spec; rewrite /KR128.__squeeze_spec in h.
by conseq e h => /> /#.
qed.

lemma aZCT____absorb_proof _st _b_st _aT _buf _b_buf __TRAILB __RATE8 :
  aZCT____absorb_spec _st _b_st _aT _buf _b_buf __TRAILB __RATE8.
proof.
have h := KR1600.__absorb_proof _st _b_st _aT _buf _b_buf __TRAILB __RATE8.
have e : equiv [Jkem1024_safety.M.aZCT____absorb ~ KR1600.MM.__absorb :
  ={arg, Glob.mem, Glob.mem_v} ==> ={res}] by sim.
rewrite /aZCT____absorb_spec; rewrite /KR1600.__absorb_spec in h.
by conseq e h => /> /#.
qed.

lemma a1____absorb_avx2x4_proof _st _b_st _aT _buf0 _b_buf0 _buf1 _b_buf1 _buf2 _b_buf2 _buf3
    _b_buf3 __TRAILB __RATE8 :
  a1____absorb_avx2x4_spec _st _b_st _aT _buf0 _b_buf0 _buf1 _b_buf1 _buf2 _b_buf2 _buf3 _b_buf3
    __TRAILB __RATE8.
proof.
have h := KX41.__absorb_avx2x4_proof _st _b_st _aT _buf0 _b_buf0 _buf1 _b_buf1 _buf2 _b_buf2 _buf3
  _b_buf3 __TRAILB __RATE8.
have e : equiv [Jkem1024_safety.M.a1____absorb_avx2x4 ~ KX41.MM.__absorb_avx2x4 :
  ={arg, Glob.mem, Glob.mem_v} ==> ={res}] by sim.
rewrite /a1____absorb_avx2x4_spec; rewrite /KX41.__absorb_avx2x4_spec in h.
by conseq e h => /> /#.
qed.

lemma aETA1____squeeze_avx2x4_proof _st _b_st _buf0 _b_buf0 _buf1 _b_buf1 _buf2 _b_buf2 _buf3
    _b_buf3 __RATE8 :
  aETA1____squeeze_avx2x4_spec _st _b_st _buf0 _b_buf0 _buf1 _b_buf1 _buf2 _b_buf2 _buf3 _b_buf3
    __RATE8.
proof.
have h := KX4128.__squeeze_avx2x4_proof _st _b_st _buf0 _b_buf0 _buf1 _b_buf1 _buf2 _b_buf2 _buf3
  _b_buf3 __RATE8.
have e : equiv [Jkem1024_safety.M.aETA1____squeeze_avx2x4 ~ KX4128.MM.__squeeze_avx2x4 :
  ={arg, Glob.mem, Glob.mem_v} ==> ={res}] by sim.
rewrite /aETA1____squeeze_avx2x4_spec; rewrite /KX4128.__squeeze_avx2x4_spec in h.
by conseq e h => /> /#.
qed.

(* the permutation selected by KECCAK_PERMUTATION (514): the reference one *)
lemma __KECCAK_F_permutation :
  hoare [Jkem1024_safety.M.__KECCAK_F : pERMUTATION = 514 ==> res.`1 = 2 /\ valid res.`2].
proof.
proc; auto => />.
by rewrite (W256.to_uint_and_mod 8 (W256.of_int 514)) // W256.of_uintK.
qed.

lemma _sha3_256A_APK_proof _out _b_out _in _b_in :
  _sha3_256A_APK_spec _out _b_out _in _b_in.
proof.
hint +safety.
rewrite /_sha3_256A_APK_spec; proc.
(* the AVX2 branch is not compiled: KECCAK_PERMUTATION selects the reference one *)
rcondf ^if; 1: by wp; call __KECCAK_F_permutation; wp; skip => /> /#.
auto; ecall (a32____squeeze_proof param_16 (BArray200.init_arr (W8.of_int 255)) param_15 b_param_0
                param_14).
auto; ecall (aPK____absorb_proof param_13 (BArray200.init_arr (W8.of_int 255)) param_12 param_11
                (BArray1568.init_arr (W8.of_int 255)) param_10 param_9).
auto; ecall (__state_init_proof param_8 b_param_1).
auto; ecall (__KECCAK_F_proof param).
by auto => /> /#.
qed.

lemma _sha3_512A_A33_proof _out _b_out _in _b_in :
  _sha3_512A_A33_spec _out _b_out _in _b_in.
proof.
hint +safety.
rewrite /_sha3_512A_A33_spec; proc.
(* the AVX2 branch is not compiled: KECCAK_PERMUTATION selects the reference one *)
rcondf ^if; 1: by wp; call __KECCAK_F_permutation; wp; skip => /> /#.
auto; ecall (a64____squeeze_proof param_16 (BArray200.init_arr (W8.of_int 255)) param_15 b_param_0
                param_14).
auto; ecall (a33____absorb_proof param_13 (BArray200.init_arr (W8.of_int 255)) param_12 param_11
                (BArray33.init_arr (W8.of_int 255)) param_10 param_9).
auto; ecall (__state_init_proof param_8 b_param_1).
auto; ecall (__KECCAK_F_proof param).
by auto => /> /#.
qed.

lemma _sha3_512A_A64_proof _out _b_out _in _b_in :
  _sha3_512A_A64_spec _out _b_out _in _b_in.
proof.
hint +safety.
rewrite /_sha3_512A_A64_spec; proc.
(* the AVX2 branch is not compiled: KECCAK_PERMUTATION selects the reference one *)
rcondf ^if; 1: by wp; call __KECCAK_F_permutation; wp; skip => /> /#.
auto; ecall (a64____squeeze_proof param_16 (BArray200.init_arr (W8.of_int 255)) param_15 b_param_0
                param_14).
auto; ecall (a64____absorb_proof param_13 (BArray200.init_arr (W8.of_int 255)) param_12 param_11
                (BArray64.init_arr (W8.of_int 255)) param_10 param_9).
auto; ecall (__state_init_proof param_8 b_param_1).
auto; ecall (__KECCAK_F_proof param).
by auto => /> /#.
qed.

lemma _shake128_next_state_proof _buf _b_buf :
  _shake128_next_state_spec _buf _b_buf.
proof.
hint +safety.
rewrite /_shake128_next_state_spec; proc.
(* the AVX2 branch is not compiled: KECCAK_PERMUTATION selects the reference one *)
rcondf ^if; 1: by wp; call __KECCAK_F_permutation; wp; skip => /> /#.
auto; ecall (_keccakf1600_proof param_1 b_param_0).
auto; ecall (__KECCAK_F_proof param).
by auto => /> /#.
qed.

lemma _shake128x4_absorb_A32_A2_proof _st _b_st _seed _b_seed _pos _b_pos :
  _shake128x4_absorb_A32_A2_spec _st _b_st _seed _b_seed _pos _b_pos.
proof.
hint +safety.
rewrite /_shake128x4_absorb_A32_A2_spec; proc.
auto; ecall (a2____absorb_avx2x4_proof param_12 (BArray800.init_arr (W8.of_int 255)) param_11
                param_10 b_param_2 param_9 b_param_1 param_8 b_param_0 param_7 b_param param_6
                param_5).
auto; ecall (a32____absorb_bcast_avx2x4_proof param_4 (BArray800.init_arr (W8.of_int 255)) param_3
                param_2 (BArray32.init_arr (W8.of_int 255)) param_1 param_0).
auto; ecall (__state_init_avx2x4_proof param b_param_3).
by auto => /> /#.
qed.

lemma _shake128x4_squeeze3blocks_proof _st _b_st _buf _b_buf :
  _shake128x4_squeeze3blocks_spec _st _b_st _buf _b_buf.
proof.
hint +safety.
rewrite /_shake128x4_squeeze3blocks_spec; proc.
auto; ecall (aBUFLEN____dumpstate_avx2x4_proof param_22 b_param_2 param_21 b_param_1 param_20
                b_param_0 param_19 b_param param_18 param_17 param_16
                (BArray800.init_arr (W8.of_int 255))).
auto; ecall (_keccakf1600_avx2x4_proof param_15 (BArray800.init_arr (W8.of_int 255))).
auto; ecall (aBUFLEN____dumpstate_avx2x4_proof param_14 b_param_6 param_13 b_param_5 param_12
                b_param_4 param_11 b_param_3 param_10 param_9 param_8
                (BArray800.init_arr (W8.of_int 255))).
auto; ecall (_keccakf1600_avx2x4_proof param_7 (BArray800.init_arr (W8.of_int 255))).
auto; ecall (aBUFLEN____dumpstate_avx2x4_proof param_6 b_param_10 param_5 b_param_9 param_4
                b_param_8 param_3 b_param_7 param_2 param_1 param_0
                (BArray800.init_arr (W8.of_int 255))).
auto; ecall (_keccakf1600_avx2x4_proof param (BArray800.init_arr (W8.of_int 255))).
by auto => /> /#.
qed.

lemma _shake256_A128__A32_A1_proof _out _b_out _seed _b_seed _nonce _b_nonce :
  _shake256_A128__A32_A1_spec _out _b_out _seed _b_seed _nonce _b_nonce.
proof.
hint +safety.
rewrite /_shake256_A128__A32_A1_spec; proc.
(* the AVX2 branch is not compiled: KECCAK_PERMUTATION selects the reference one *)
rcondf ^if; 1: by wp; call __KECCAK_F_permutation; wp; skip => /> /#.
auto; ecall (a128____squeeze_proof param_26 (BArray200.init_arr (W8.of_int 255)) param_25
                b_param_0 param_24).
auto; ecall (a1____absorb_proof param_23 (BArray200.init_arr (W8.of_int 255)) param_22 param_21
                (BArray1.init_arr (W8.of_int 255)) param_20 param_19).
auto; ecall (a32____absorb_proof param_18 (BArray200.init_arr (W8.of_int 255)) param_17 param_16
                (BArray32.init_arr (W8.of_int 255)) param_15 param_14).
auto; ecall (__state_init_proof param_13 b_param_1).
auto; ecall (__KECCAK_F_proof param).
by auto => /> /#.
qed.

lemma _shake256_A32__AZCT_proof _out _b_out _in _b_in :
  _shake256_A32__AZCT_spec _out _b_out _in _b_in.
proof.
hint +safety.
rewrite /_shake256_A32__AZCT_spec; proc.
(* the AVX2 branch is not compiled: KECCAK_PERMUTATION selects the reference one *)
rcondf ^if; 1: by wp; call __KECCAK_F_permutation; wp; skip => /> /#.
auto; ecall (a32____squeeze_proof param_16 (BArray200.init_arr (W8.of_int 255)) param_15 b_param_0
                param_14).
auto; ecall (aZCT____absorb_proof param_13 (BArray200.init_arr (W8.of_int 255)) param_12 param_11
                (BArray1600.init_arr (W8.of_int 255)) param_10 param_9).
auto; ecall (__state_init_proof param_8 b_param_1).
auto; ecall (__KECCAK_F_proof param).
by auto => /> /#.
qed.

lemma _shake256x4_AETA1__A32_A1_proof _out0 _b_out0 _out1 _b_out1 _out2 _b_out2 _out3 _b_out3 _seed
    _b_seed _nonces _b_nonces :
  _shake256x4_AETA1__A32_A1_spec _out0 _b_out0 _out1 _b_out1 _out2 _b_out2 _out3 _b_out3 _seed
    _b_seed _nonces _b_nonces.
proof.
hint +safety.
rewrite /_shake256x4_AETA1__A32_A1_spec; proc.
auto; ecall (aETA1____squeeze_avx2x4_proof param_18 (BArray800.init_arr (W8.of_int 255)) param_17
                b_param_2 param_16 b_param_1 param_15 b_param_0 param_14 b_param param_13).
auto; ecall (a1____absorb_avx2x4_proof param_12 (BArray800.init_arr (W8.of_int 255)) param_11
                param_10 b_param_6 param_9 b_param_5 param_8 b_param_4 param_7 b_param_3 param_6
                param_5).
auto; ecall (a32____absorb_bcast_avx2x4_proof param_4 (BArray800.init_arr (W8.of_int 255)) param_3
                param_2 (BArray32.init_arr (W8.of_int 255)) param_1 param_0).
auto; ecall (__state_init_avx2x4_proof param b_param_7).
by auto => /> /#.
qed.

lemma __shuffle8_proof _a _b : (__shuffle8_spec _a _b).
proof.
hint +safety.
rewrite /__shuffle8_spec; proc.
conseq (_ : _ ==> valid trace___shuffle8).
by auto => /> *.
qed.

lemma __shuffle4_proof _a _b : (__shuffle4_spec _a _b).
proof.
hint +safety.
rewrite /__shuffle4_spec; proc.
conseq (_ : _ ==> valid trace___shuffle4).
by auto => /> *.
qed.

lemma __shuffle2_proof _a _b : (__shuffle2_spec _a _b).
proof.
hint +safety.
rewrite /__shuffle2_spec; proc.
conseq (_ : _ ==> valid trace___shuffle2).
by auto => /> *.
qed.

lemma __shuffle1_proof _a _b : (__shuffle1_spec _a _b).
proof.
hint +safety.
rewrite /__shuffle1_spec; proc.
conseq (_ : _ ==> valid trace___shuffle1).
by auto => /> *.
qed.

lemma __nttunpack128_proof _r0 _r1 _r2 _r3 _r4 _r5 _r6 _r7 :
      (__nttunpack128_spec _r0 _r1 _r2 _r3 _r4 _r5 _r6 _r7).
proof.
hint +safety.
rewrite /__nttunpack128_spec; proc.
conseq (_ : _ ==> valid trace___nttunpack128).
auto; ecall (__shuffle1_proof param_30 param_29).
auto; ecall (__shuffle1_proof param_28 param_27).
auto; ecall (__shuffle1_proof param_26 param_25).
auto; ecall (__shuffle1_proof param_24 param_23).
auto; ecall (__shuffle2_proof param_22 param_21).
auto; ecall (__shuffle2_proof param_20 param_19).
auto; ecall (__shuffle2_proof param_18 param_17).
auto; ecall (__shuffle2_proof param_16 param_15).
auto; ecall (__shuffle4_proof param_14 param_13).
auto; ecall (__shuffle4_proof param_12 param_11).
auto; ecall (__shuffle4_proof param_10 param_9).
auto; ecall (__shuffle4_proof param_8 param_7).
auto; ecall (__shuffle8_proof param_6 param_5).
auto; ecall (__shuffle8_proof param_4 param_3).
auto; ecall (__shuffle8_proof param_2 param_1).
auto; ecall (__shuffle8_proof param_0 param).
by auto => /> *.
qed.

lemma _nttunpack_proof _rp _b_rp : (_nttunpack_spec _rp _b_rp).
proof.
hint +safety.
rewrite /_nttunpack_spec; proc.
conseq (_ :
     b_rp = BArray512.init_arr (W8.of_int 255)
  ==> BArray512.is_init b_rp 0 512
   /\ valid trace__nttunpack).
+ by move=> &hr />; rewrite -!(BI512.is_init_full _ 512) //.
auto; ecall (__nttunpack128_proof param_14 param_13 param_12 param_11 param_10 param_9 param_8 param_7).
auto; ecall (__nttunpack128_proof param_6 param_5 param_4 param_3 param_2 param_1 param_0 param).
by auto => /> *.
qed.

lemma __csubq_proof _r _qx16 : (__csubq_spec _r _qx16).
proof.
hint +safety.
rewrite /__csubq_spec; proc.
conseq (_ : _ ==> valid trace___csubq).
by auto => /> *.
qed.

lemma __red16x_proof _r _qx16 _vx16 : (__red16x_spec _r _qx16 _vx16).
proof.
hint +safety.
rewrite /__red16x_spec; proc.
conseq (_ : _ ==> valid trace___red16x).
by auto => /> *.
qed.

lemma __fqmulprecomp16x_proof _b _al _ah _qx16 :
      (__fqmulprecomp16x_spec _b _al _ah _qx16).
proof.
hint +safety.
rewrite /__fqmulprecomp16x_spec; proc.
conseq (_ : _ ==> valid trace___fqmulprecomp16x).
by auto => /> *.
qed.

lemma __fqmulx16_proof _a _b _qx16 _qinvx16 :
      (__fqmulx16_spec _a _b _qx16 _qinvx16).
proof.
hint +safety.
rewrite /__fqmulx16_spec; proc.
conseq (_ : _ ==> valid trace___fqmulx16).
by auto => /> *.
qed.

lemma _poly_add2_proof _rp _b_rp _bp _b_bp :
      (_poly_add2_spec _rp _b_rp _bp _b_bp).
proof.
hint +safety.
rewrite /_poly_add2_spec; proc.
conseq (_ :
     b_bp = BArray512.init_arr (W8.of_int 255)
  /\ b_rp = BArray512.init_arr (W8.of_int 255)
  ==> BArray512.is_init b_rp 0 512
   /\ valid trace__poly_add2).
+ by move=> &hr />; rewrite -!(BI512.is_init_full _ 512) //.
unroll for ^while.
by auto => /> *.
qed.

lemma _poly_csubq_proof _rp _b_rp : (_poly_csubq_spec _rp _b_rp).
proof.
hint +safety.
rewrite /_poly_csubq_spec; proc.
conseq (_ :
     b_rp = BArray512.init_arr (W8.of_int 255)
  ==> BArray512.is_init b_rp 0 512
   /\ valid trace__poly_csubq).
+ by move=> &hr />; rewrite -!(BI512.is_init_full _ 512) //.
unroll for ^while.
auto; ecall (__csubq_proof param_0 param).
auto; ecall (__csubq_proof param_0 param).
auto; ecall (__csubq_proof param_0 param).
auto; ecall (__csubq_proof param_0 param).
auto; ecall (__csubq_proof param_0 param).
auto; ecall (__csubq_proof param_0 param).
auto; ecall (__csubq_proof param_0 param).
auto; ecall (__csubq_proof param_0 param).
auto; ecall (__csubq_proof param_0 param).
auto; ecall (__csubq_proof param_0 param).
auto; ecall (__csubq_proof param_0 param).
auto; ecall (__csubq_proof param_0 param).
auto; ecall (__csubq_proof param_0 param).
auto; ecall (__csubq_proof param_0 param).
auto; ecall (__csubq_proof param_0 param).
auto; ecall (__csubq_proof param_0 param).
by auto => /> *.
qed.

lemma __w256_interleave_u16_proof _al _ah :
      (__w256_interleave_u16_spec _al _ah).
proof.
hint +safety.
rewrite /__w256_interleave_u16_spec; proc.
conseq (_ : _ ==> valid trace___w256_interleave_u16).
by auto => /> *.
qed.

lemma __w256_deinterleave_u16_proof __zero _a0 _a1 :
      (__w256_deinterleave_u16_spec __zero _a0 _a1).
proof.
hint +safety.
rewrite /__w256_deinterleave_u16_spec; proc.
conseq (_ : _ ==> valid trace___w256_deinterleave_u16).
by auto => /> *.
qed.

lemma __mont_red_proof _lo _hi _qx16 _qinvx16 :
      (__mont_red_spec _lo _hi _qx16 _qinvx16).
proof.
hint +safety.
rewrite /__mont_red_spec; proc.
conseq (_ : _ ==> valid trace___mont_red).
by auto => /> *.
qed.

lemma __wmul_16u16_proof _x _y : (__wmul_16u16_spec _x _y).
proof.
hint +safety.
rewrite /__wmul_16u16_spec; proc.
conseq (_ : _ ==> valid trace___wmul_16u16).
auto; ecall (__w256_interleave_u16_proof param_0 param).
by auto => /> *.
qed.

lemma __schoolbook16x_proof _are _aim _bre _bim _zeta _zetaqinv _qx16 _qinvx16 _sign :
      (__schoolbook16x_spec _are _aim _bre _bim _zeta _zetaqinv _qx16
      _qinvx16 _sign).
proof.
hint +safety.
rewrite /__schoolbook16x_spec; proc.
auto; ecall (__mont_red_proof param_24 param_23 param_22 param_21).
auto; ecall (__mont_red_proof param_20 param_19 param_18 param_17).
auto; ecall (__w256_deinterleave_u16_proof param_16 param_15 param_14).
auto; ecall (__w256_deinterleave_u16_proof param_13 param_12 param_11).
(* the if on sign leaves a side goal to this ecall *)
auto; ecall (__wmul_16u16_proof param_10 param_9).
auto; ecall (__wmul_16u16_proof param_8 param_7).
auto; ecall (__wmul_16u16_proof param_6 param_5).
auto; ecall (__wmul_16u16_proof param_4 param_3).
auto; ecall (__fqmulprecomp16x_proof param_2 param_1 param_0 param).
by auto => /> *.
move=> &hr /> h r0 v0 r1 v1 r2 v2 r3 v3 r4 v4; have := h r0 v0.
by case: (sign{hr} = 0) => _ /= /(_ r1 v1 r2 v2 r3 v3 r4 v4) /#.
qed.

lemma _poly_basemul_proof _rp _b_rp _ap _b_ap _bp _b_bp :
      (_poly_basemul_spec _rp _b_rp _ap _b_ap _bp _b_bp).
proof.
hint +safety.
rewrite /_poly_basemul_spec; proc.
conseq (_ :
     b_ap = BArray512.init_arr (W8.of_int 255)
  /\ b_bp = BArray512.init_arr (W8.of_int 255)
  ==> BArray512.is_init b_rp 0 (32 * 16)
   /\ valid trace__poly_basemul).
+ by move=> &hr />; rewrite -!(BI512.is_init_full _ 512) //.
auto; ecall (__schoolbook16x_proof param_70 param_69 param_68 param_67 param_66 param_65 param_64 param_63 param_62).
auto; ecall (__schoolbook16x_proof param_61 param_60 param_59 param_58 param_57 param_56 param_55 param_54 param_53).
auto; ecall (__schoolbook16x_proof param_52 param_51 param_50 param_49 param_48 param_47 param_46 param_45 param_44).
auto; ecall (__schoolbook16x_proof param_43 param_42 param_41 param_40 param_39 param_38 param_37 param_36 param_35).
auto; ecall (__schoolbook16x_proof param_34 param_33 param_32 param_31 param_30 param_29 param_28 param_27 param_26).
auto; ecall (__schoolbook16x_proof param_25 param_24 param_23 param_22 param_21 param_20 param_19 param_18 param_17).
auto; ecall (__schoolbook16x_proof param_16 param_15 param_14 param_13 param_12 param_11 param_10 param_9 param_8).
auto; ecall (__schoolbook16x_proof param_7 param_6 param_5 param_4 param_3 param_2 param_1 param_0 param).
by auto => /> *.
qed.

lemma _i_poly_frombytes_proof _rp _b_rp _ap _b_ap :
      (_i_poly_frombytes_spec _rp _b_rp _ap _b_ap).
proof.
hint +safety.
rewrite /_i_poly_frombytes_spec; proc.
conseq (_ :
     b_ap = BArray384.init_arr (W8.of_int 255)
  ==> BArray512.is_init b_rp 0 (16 * 32)
   /\ valid trace__i_poly_frombytes).
+ by move=> &hr />; rewrite -!(BI384.is_init_full _ 384) //.
unroll for ^while.
auto; ecall (__shuffle1_proof param_22 param_21).
auto; ecall (__shuffle1_proof param_20 param_19).
auto; ecall (__shuffle1_proof param_18 param_17).
auto; ecall (__shuffle2_proof param_16 param_15).
auto; ecall (__shuffle2_proof param_14 param_13).
auto; ecall (__shuffle2_proof param_12 param_11).
auto; ecall (__shuffle4_proof param_10 param_9).
auto; ecall (__shuffle4_proof param_8 param_7).
auto; ecall (__shuffle4_proof param_6 param_5).
auto; ecall (__shuffle8_proof param_4 param_3).
auto; ecall (__shuffle8_proof param_2 param_1).
auto; ecall (__shuffle8_proof param_0 param).
auto; ecall (__shuffle1_proof param_22 param_21).
auto; ecall (__shuffle1_proof param_20 param_19).
auto; ecall (__shuffle1_proof param_18 param_17).
auto; ecall (__shuffle2_proof param_16 param_15).
auto; ecall (__shuffle2_proof param_14 param_13).
auto; ecall (__shuffle2_proof param_12 param_11).
auto; ecall (__shuffle4_proof param_10 param_9).
auto; ecall (__shuffle4_proof param_8 param_7).
auto; ecall (__shuffle4_proof param_6 param_5).
auto; ecall (__shuffle8_proof param_4 param_3).
auto; ecall (__shuffle8_proof param_2 param_1).
auto; ecall (__shuffle8_proof param_0 param).
by auto => /> *.
qed.

lemma _poly_frommont_proof _rp _b_rp : (_poly_frommont_spec _rp _b_rp).
proof.
hint +safety.
rewrite /_poly_frommont_spec; proc.
conseq (_ :
     b_rp = BArray512.init_arr (W8.of_int 255)
  ==> BArray512.is_init b_rp 0 512
   /\ valid trace__poly_frommont).
+ by move=> &hr />; rewrite -!(BI512.is_init_full _ 512) //.
unroll for ^while.
auto; ecall (__fqmulx16_proof param_2 param_1 param_0 param).
auto; ecall (__fqmulx16_proof param_2 param_1 param_0 param).
auto; ecall (__fqmulx16_proof param_2 param_1 param_0 param).
auto; ecall (__fqmulx16_proof param_2 param_1 param_0 param).
auto; ecall (__fqmulx16_proof param_2 param_1 param_0 param).
auto; ecall (__fqmulx16_proof param_2 param_1 param_0 param).
auto; ecall (__fqmulx16_proof param_2 param_1 param_0 param).
auto; ecall (__fqmulx16_proof param_2 param_1 param_0 param).
auto; ecall (__fqmulx16_proof param_2 param_1 param_0 param).
auto; ecall (__fqmulx16_proof param_2 param_1 param_0 param).
auto; ecall (__fqmulx16_proof param_2 param_1 param_0 param).
auto; ecall (__fqmulx16_proof param_2 param_1 param_0 param).
auto; ecall (__fqmulx16_proof param_2 param_1 param_0 param).
auto; ecall (__fqmulx16_proof param_2 param_1 param_0 param).
auto; ecall (__fqmulx16_proof param_2 param_1 param_0 param).
auto; ecall (__fqmulx16_proof param_2 param_1 param_0 param).
by auto => /> *.
qed.

lemma _i_poly_frommsg_proof _rp _b_rp _ap _b_ap :
      (_i_poly_frommsg_spec _rp _b_rp _ap _b_ap).
proof.
hint +safety.
rewrite /_i_poly_frommsg_spec; proc.
conseq (_ :
     b_ap = BArray32.init_arr (W8.of_int 255)
  ==> BArray512.is_init b_rp 0 (16 * 32)
   /\ valid trace__i_poly_frommsg).
+ by move=> &hr />; rewrite -!(BI32.is_init_full _ 32) //.
unroll for ^while.
by auto => /> *.
qed.

lemma __cbd2_proof _rp _b_rp _buf _b_buf :
      (__cbd2_spec _rp _b_rp _buf _b_buf).
proof.
hint +safety.
rewrite /__cbd2_spec; proc.
conseq (_ :
     b_buf = BArray128.init_arr (W8.of_int 255)
  ==> BArray512.is_init b_rp 0 (256 * 2)
   /\ valid trace___cbd2).
+ by move=> &hr />; rewrite -!(BI128.is_init_full _ 128) //.
unroll for ^while.
by auto => /> *.
qed.

lemma __poly_cbd_eta1_proof _rp _b_rp _buf _b_buf :
      (__poly_cbd_eta1_spec _rp _b_rp _buf _b_buf).
proof.
hint +safety.
rewrite /__poly_cbd_eta1_spec; proc.
conseq (_ :
     b_buf = BArray128.init_arr (W8.of_int 255)
  ==> BArray512.is_init b_rp 0 (256 * 2)
   /\ valid trace___poly_cbd_eta1).
+ by move=> &hr />; rewrite -!(BI128.is_init_full _ 128) //.
auto; ecall (__cbd2_proof param_0 b_param_0 param b_param).
by auto => /> *.
qed.

lemma _poly_getnoise_eta2_proof _rp _b_rp _seed _b_seed _nonce :
      (_poly_getnoise_eta2_spec _rp _b_rp _seed _b_seed _nonce).
proof.
hint +safety.
rewrite /_poly_getnoise_eta2_spec; proc.
conseq (_ :
     b_seed = BArray32.init_arr (W8.of_int 255)
  ==> BArray512.is_init b_rp 0 (256 * 2)
   /\ valid trace__poly_getnoise_eta2).
+ by move=> &hr />; rewrite -!(BI32.is_init_full _ 32) //.
auto; ecall (__cbd2_proof param_3 b_param param_2 ((BArray128.init_arr (W8.of_int 255)))).
auto; ecall (_shake256_A128__A32_A1_proof param_1 b_param_1 param_0 ((BArray32.init_arr (W8.of_int 255))) param b_param_0).
by auto => /> *.
qed.

lemma _poly_getnoise_eta1_4x_proof _r0 _b_r0 _r1 _b_r1 _r2 _b_r2 _r3 _b_r3 _seed _b_seed _nonce :
      (_poly_getnoise_eta1_4x_spec _r0 _b_r0 _r1 _b_r1 _r2 _b_r2 _r3 
      _b_r3 _seed _b_seed _nonce).
proof.
hint +safety.
rewrite /_poly_getnoise_eta1_4x_spec; proc.
conseq (_ :
     b_seed = BArray32.init_arr (W8.of_int 255)
  ==> BArray512.is_init b_r0 0 (256 * 2)
   /\ BArray512.is_init b_r1 0 (256 * 2)
   /\ BArray512.is_init b_r2 0 (256 * 2)
   /\ BArray512.is_init b_r3 0 (256 * 2)
   /\ valid trace__poly_getnoise_eta1_4x).
+ by move=> &hr />; rewrite -!(BI32.is_init_full _ 32) //.
+ by move=> />.
auto; ecall (__poly_cbd_eta1_proof param_12 b_param param_11 ((BArray128.init_arr (W8.of_int 255)))).
auto; ecall (__poly_cbd_eta1_proof param_10 b_param_0 param_9 ((BArray128.init_arr (W8.of_int 255)))).
auto; ecall (__poly_cbd_eta1_proof param_8 b_param_1 param_7 ((BArray128.init_arr (W8.of_int 255)))).
auto; ecall (__poly_cbd_eta1_proof param_6 b_param_2 param_5 ((BArray128.init_arr (W8.of_int 255)))).
auto; ecall (_shake256x4_AETA1__A32_A1_proof param_4 b_param_7 param_3 b_param_6 param_2 b_param_5 param_1 b_param_4 param_0 ((BArray32.init_arr (W8.of_int 255))) param b_param_3).
by auto => /> *.
qed.

lemma __invntt___butterfly64x_proof _rl0 _rl1 _rl2 _rl3 _rh0 _rh1 _rh2 _rh3 _zl0 _zl1 _zh0 _zh1 _qx16 :
      (__invntt___butterfly64x_spec _rl0 _rl1 _rl2 _rl3 _rh0 _rh1 _rh2 
      _rh3 _zl0 _zl1 _zh0 _zh1 _qx16).
proof.
hint +safety.
rewrite /__invntt___butterfly64x_spec; proc.
conseq (_ : _ ==> valid trace___invntt___butterfly64x).
by auto => /> *.
qed.

lemma _poly_invntt_proof _rp _b_rp : (_poly_invntt_spec _rp _b_rp).
proof.
hint +safety.
rewrite /_poly_invntt_spec .
proc; auto .
while ((valid trace__poly_invntt) /\ 0<=i /\ b_r6 /\ b_r4 /\ b_r2 /\ b_r0).
auto .
ecall (__fqmulprecomp16x_proof param_161 param_160 param_159 param_158).
auto .
ecall (__fqmulprecomp16x_proof param_157 param_156 param_155 param_154).
auto .
ecall (__fqmulprecomp16x_proof param_153 param_152 param_151 param_150).
auto .
ecall (__fqmulprecomp16x_proof param_149 param_148 param_147 param_146).
auto .
ecall (__invntt___butterfly64x_proof param_145 param_144 param_143 param_142 
       param_141 param_140 param_139 param_138 param_137 param_136 param_135 
       param_134 param_133).
auto .
by move=> &hr /> *; smt().
auto .
while ((valid trace__poly_invntt) /\ 0<= i /\ ((2<=i) ? ((b_r6 /\ b_r4) /\ b_r2 /\ b_r0) : true)).
auto .
ecall (__red16x_proof param_132 param_131 param_130).
auto .
ecall (__invntt___butterfly64x_proof param_129 param_128 param_127 param_126 
       param_125 param_124 param_123 param_122 param_121 param_120 param_119 
       param_118 param_117).
auto .
ecall (__shuffle8_proof param_116 param_115).
auto .
ecall (__shuffle8_proof param_114 param_113).
auto .
ecall (__shuffle8_proof param_112 param_111).
auto .
ecall (__shuffle8_proof param_110 param_109).
auto .
ecall (__red16x_proof param_108 param_107 param_106).
auto .
ecall (__invntt___butterfly64x_proof param_105 param_104 param_103 param_102 
       param_101 param_100 param_99 param_98 param_97 param_96 param_95 
       param_94 param_93).
auto .
ecall (__shuffle4_proof param_92 param_91).
auto .
ecall (__shuffle4_proof param_90 param_89).
auto .
ecall (__shuffle4_proof param_88 param_87).
auto .
ecall (__shuffle4_proof param_86 param_85).
auto .
ecall (__red16x_proof param_84 param_83 param_82).
auto .
ecall (__invntt___butterfly64x_proof param_81 param_80 param_79 param_78 
       param_77 param_76 param_75 param_74 param_73 param_72 param_71 
       param_70 param_69).
auto .
ecall (__shuffle2_proof param_68 param_67).
auto .
ecall (__shuffle2_proof param_66 param_65).
auto .
ecall (__shuffle2_proof param_64 param_63).
auto .
ecall (__shuffle2_proof param_62 param_61).
auto .
ecall (__red16x_proof param_60 param_59 param_58).
auto .
ecall (__invntt___butterfly64x_proof param_57 param_56 param_55 param_54 
       param_53 param_52 param_51 param_50 param_49 param_48 param_47 
       param_46 param_45).
auto .
ecall (__shuffle1_proof param_44 param_43).
auto .
ecall (__shuffle1_proof param_42 param_41).
auto .
ecall (__shuffle1_proof param_40 param_39).
auto .
ecall (__shuffle1_proof param_38 param_37).
auto .
ecall (__invntt___butterfly64x_proof param_36 param_35 param_34 param_33 
       param_32 param_31 param_30 param_29 param_28 param_27 param_26 
       param_25 param_24).
auto .
ecall (__red16x_proof param_23 param_22 param_21).
auto .
ecall (__red16x_proof param_20 param_19 param_18).
auto .
ecall (__red16x_proof param_17 param_16 param_15).
auto .
ecall (__red16x_proof param_14 param_13 param_12).
auto .
ecall (__invntt___butterfly64x_proof param_11 param_10 param_9 param_8 
       param_7 param_6 param_5 param_4 param_3 param_2 param_1 param_0 
       param).
auto => &m /> *. smt(valid_cat).
auto => &m /> *.
smt (BArray512.init_arrP).
qed .

lemma __butterfly64x_proof _rl0 _rl1 _rl2 _rl3 _rh0 _rh1 _rh2 _rh3 _zl0 _zl1 _zh0 _zh1 _qx16 :
      (__butterfly64x_spec _rl0 _rl1 _rl2 _rl3 _rh0 _rh1 _rh2 _rh3 _zl0 
      _zl1 _zh0 _zh1 _qx16).
proof.
hint +safety.
rewrite /__butterfly64x_spec; proc.
conseq (_ : _ ==> valid trace___butterfly64x).
by auto => /> *.
qed.

lemma _poly_ntt_proof _rp _b_rp : (_poly_ntt_spec _rp _b_rp).
proof.
hint +safety.
rewrite /_poly_ntt_spec .
proc; auto .
while ((valid trace__poly_ntt) /\ 0<=i).
auto .
ecall (__red16x_proof param_158 param_157 param_156).
auto .
ecall (__red16x_proof param_155 param_154 param_153).
auto .
ecall (__red16x_proof param_152 param_151 param_150).
auto .
ecall (__red16x_proof param_149 param_148 param_147).
auto .
ecall (__red16x_proof param_146 param_145 param_144).
auto .
ecall (__red16x_proof param_143 param_142 param_141).
auto .
ecall (__red16x_proof param_140 param_139 param_138).
auto .
ecall (__red16x_proof param_137 param_136 param_135).
auto .
ecall (__butterfly64x_proof param_134 param_133 param_132 param_131 param_130 
       param_129 param_128 param_127 param_126 param_125 param_124 param_123 
       param_122).
auto .
ecall (__butterfly64x_proof param_121 param_120 param_119 param_118 param_117 
       param_116 param_115 param_114 param_113 param_112 param_111 param_110 
       param_109).
auto .
ecall (__shuffle1_proof param_108 param_107).
auto .
ecall (__shuffle1_proof param_106 param_105).
auto .
ecall (__shuffle1_proof param_104 param_103).
auto .
ecall (__shuffle1_proof param_102 param_101).
auto .
ecall (__butterfly64x_proof param_100 param_99 param_98 param_97 param_96 
       param_95 param_94 param_93 param_92 param_91 param_90 param_89 
       param_88).
auto .
ecall (__shuffle2_proof param_87 param_86).
auto .
ecall (__shuffle2_proof param_85 param_84).
auto .
ecall (__shuffle2_proof param_83 param_82).
auto .
ecall (__shuffle2_proof param_81 param_80).
auto .
ecall (__butterfly64x_proof param_79 param_78 param_77 param_76 param_75 
       param_74 param_73 param_72 param_71 param_70 param_69 param_68 
       param_67).
auto .
ecall (__shuffle4_proof param_66 param_65).
auto .
ecall (__shuffle4_proof param_64 param_63).
auto .
ecall (__shuffle4_proof param_62 param_61).
auto .
ecall (__shuffle4_proof param_60 param_59).
auto .
ecall (__butterfly64x_proof param_58 param_57 param_56 param_55 param_54 
       param_53 param_52 param_51 param_50 param_49 param_48 param_47 
       param_46).
auto .
ecall (__shuffle8_proof param_45 param_44).
auto .
ecall (__shuffle8_proof param_43 param_42).
auto .
ecall (__shuffle8_proof param_41 param_40).
auto .
ecall (__shuffle8_proof param_39 param_38).
auto .
ecall (__butterfly64x_proof param_37 param_36 param_35 param_34 param_33 
       param_32 param_31 param_30 param_29 param_28 param_27 param_26 
       param_25).
auto .
by move=> &hr /> *; smt().
auto .
ecall (__butterfly64x_proof param_24 param_23 param_22 param_21 param_20 
       param_19 param_18 param_17 param_16 param_15 param_14 param_13 
       param_12).
auto .
ecall (__butterfly64x_proof param_11 param_10 param_9 param_8 param_7 
       param_6 param_5 param_4 param_3 param_2 param_1 param_0 param).
auto .
qed .

lemma __poly_reduce_proof _rp _b_rp : (__poly_reduce_spec _rp _b_rp).
proof.
hint +safety.
rewrite /__poly_reduce_spec; proc.
conseq (_ :
     b_rp = BArray512.init_arr (W8.of_int 255)
  ==> BArray512.is_init b_rp 0 512
   /\ valid trace___poly_reduce).
+ by move=> &hr />; rewrite -!(BI512.is_init_full _ 512) //.
unroll for ^while.
auto; ecall (__red16x_proof param_1 param_0 param).
auto; ecall (__red16x_proof param_1 param_0 param).
auto; ecall (__red16x_proof param_1 param_0 param).
auto; ecall (__red16x_proof param_1 param_0 param).
auto; ecall (__red16x_proof param_1 param_0 param).
auto; ecall (__red16x_proof param_1 param_0 param).
auto; ecall (__red16x_proof param_1 param_0 param).
auto; ecall (__red16x_proof param_1 param_0 param).
auto; ecall (__red16x_proof param_1 param_0 param).
auto; ecall (__red16x_proof param_1 param_0 param).
auto; ecall (__red16x_proof param_1 param_0 param).
auto; ecall (__red16x_proof param_1 param_0 param).
auto; ecall (__red16x_proof param_1 param_0 param).
auto; ecall (__red16x_proof param_1 param_0 param).
auto; ecall (__red16x_proof param_1 param_0 param).
auto; ecall (__red16x_proof param_1 param_0 param).
by auto => /> *.
qed.

lemma _poly_sub_proof _rp _b_rp _ap _b_ap _bp _b_bp :
      (_poly_sub_spec _rp _b_rp _ap _b_ap _bp _b_bp).
proof.
hint +safety.
rewrite /_poly_sub_spec; proc.
conseq (_ :
     b_ap = BArray512.init_arr (W8.of_int 255)
  /\ b_bp = BArray512.init_arr (W8.of_int 255)
  ==> BArray512.is_init b_rp 0 (32 * 16)
   /\ valid trace__poly_sub).
+ by move=> &hr />; rewrite -!(BI512.is_init_full _ 512) //.
unroll for ^while.
by auto => /> *.
qed.

lemma _i_poly_tobytes_proof _rp _b_rp _a _b_a :
      (_i_poly_tobytes_spec _rp _b_rp _a _b_a).
proof.
hint +safety.
rewrite /_i_poly_tobytes_spec; proc.
conseq (_ :
     b_a = BArray512.init_arr (W8.of_int 255)
  ==> BArray384.is_init b_rp 0 384
   /\ BArray512.is_init b_a 0 (2 * 256)
   /\ valid trace__i_poly_tobytes).
+ by move=> &hr />; rewrite -!(BI512.is_init_full _ 512) //.
+ by move=> />.
unroll for ^while.
auto; ecall (__shuffle8_proof param_23 param_22).
auto; ecall (__shuffle8_proof param_21 param_20).
auto; ecall (__shuffle8_proof param_19 param_18).
auto; ecall (__shuffle4_proof param_17 param_16).
auto; ecall (__shuffle4_proof param_15 param_14).
auto; ecall (__shuffle4_proof param_13 param_12).
auto; ecall (__shuffle2_proof param_11 param_10).
auto; ecall (__shuffle2_proof param_9 param_8).
auto; ecall (__shuffle2_proof param_7 param_6).
auto; ecall (__shuffle1_proof param_5 param_4).
auto; ecall (__shuffle1_proof param_3 param_2).
auto; ecall (__shuffle1_proof param_1 param_0).
auto; ecall (__shuffle8_proof param_23 param_22).
auto; ecall (__shuffle8_proof param_21 param_20).
auto; ecall (__shuffle8_proof param_19 param_18).
auto; ecall (__shuffle4_proof param_17 param_16).
auto; ecall (__shuffle4_proof param_15 param_14).
auto; ecall (__shuffle4_proof param_13 param_12).
auto; ecall (__shuffle2_proof param_11 param_10).
auto; ecall (__shuffle2_proof param_9 param_8).
auto; ecall (__shuffle2_proof param_7 param_6).
auto; ecall (__shuffle1_proof param_5 param_4).
auto; ecall (__shuffle1_proof param_3 param_2).
auto; ecall (__shuffle1_proof param_1 param_0).
auto; ecall (_poly_csubq_proof param ((BArray512.init_arr (W8.of_int 255)))).
by auto => /> *.
qed.

lemma _i_poly_tomsg_proof _rp _b_rp _a _b_a :
      (_i_poly_tomsg_spec _rp _b_rp _a _b_a).
proof.
hint +safety.
rewrite /_i_poly_tomsg_spec; proc.
conseq (_ :
     b_a = BArray512.init_arr (W8.of_int 255)
  ==> BArray32.is_init b_rp 0 32
   /\ BArray512.is_init b_a 0 (2 * 256)
   /\ valid trace__i_poly_tomsg).
+ by move=> &hr />; rewrite -!(BI512.is_init_full _ 512) //.
+ by move=> />.
unroll for ^while.
auto; ecall (_poly_csubq_proof param ((BArray512.init_arr (W8.of_int 255)))).
by auto => /> *.
qed.

lemma __polyvec_add2_proof _r _b_r _b _b_b :
      (__polyvec_add2_spec _r _b_r _b _b_b).
proof.
hint +safety.
rewrite /__polyvec_add2_spec; proc.
conseq (_ :
     b_b = BArray2048.init_arr (W8.of_int 255)
  /\ b_r = BArray2048.init_arr (W8.of_int 255)
  ==> BArray2048.is_init b_r 0 2048
   /\ valid trace___polyvec_add2).
+ by move=> &hr />; rewrite -!(BI2048.is_init_full _ 2048) //.
unroll for ^while.
auto; ecall (_poly_add2_proof param_0 b_param_0 param b_param).
auto; ecall (_poly_add2_proof param_0 b_param_0 param b_param).
auto; ecall (_poly_add2_proof param_0 b_param_0 param b_param).
auto; ecall (_poly_add2_proof param_0 b_param_0 param b_param).
by auto => /> *.
qed.

lemma __polyvec_csubq_proof _r _b_r : (__polyvec_csubq_spec _r _b_r).
proof.
hint +safety.
rewrite /__polyvec_csubq_spec; proc.
conseq (_ :
     b_r = BArray2048.init_arr (W8.of_int 255)
  ==> BArray2048.is_init b_r 0 2048
   /\ valid trace___polyvec_csubq).
+ by move=> &hr />; rewrite -!(BI2048.is_init_full _ 2048) //.
unroll for ^while.
auto; ecall (_poly_csubq_proof param b_param).
auto; ecall (_poly_csubq_proof param b_param).
auto; ecall (_poly_csubq_proof param b_param).
auto; ecall (_poly_csubq_proof param b_param).
by auto => /> *.
qed.

lemma __polyvec_invntt_proof _r _b_r : (__polyvec_invntt_spec _r _b_r).
proof.
hint +safety.
rewrite /__polyvec_invntt_spec; proc.
conseq (_ :
     b_r = BArray2048.init_arr (W8.of_int 255)
  ==> BArray2048.is_init b_r 0 2048
   /\ valid trace___polyvec_invntt).
+ by move=> &hr />; rewrite -!(BI2048.is_init_full _ 2048) //.
unroll for ^while.
auto; ecall (_poly_invntt_proof param b_param).
auto; ecall (_poly_invntt_proof param b_param).
auto; ecall (_poly_invntt_proof param b_param).
auto; ecall (_poly_invntt_proof param b_param).
by auto => /> *.
qed.

lemma __polyvec_ntt_proof _r _b_r : (__polyvec_ntt_spec _r _b_r).
proof.
hint +safety.
rewrite /__polyvec_ntt_spec; proc.
conseq (_ :
     b_r = BArray2048.init_arr (W8.of_int 255)
  ==> BArray2048.is_init b_r 0 2048
   /\ valid trace___polyvec_ntt).
+ by move=> &hr />; rewrite -!(BI2048.is_init_full _ 2048) //.
unroll for ^while.
auto; ecall (_poly_ntt_proof param b_param).
auto; ecall (_poly_ntt_proof param b_param).
auto; ecall (_poly_ntt_proof param b_param).
auto; ecall (_poly_ntt_proof param b_param).
by auto => /> *.
qed.

lemma __polyvec_reduce_proof _r _b_r : (__polyvec_reduce_spec _r _b_r).
proof.
hint +safety.
rewrite /__polyvec_reduce_spec; proc.
conseq (_ :
     b_r = BArray2048.init_arr (W8.of_int 255)
  ==> BArray2048.is_init b_r 0 2048
   /\ valid trace___polyvec_reduce).
+ by move=> &hr />; rewrite -!(BI2048.is_init_full _ 2048) //.
unroll for ^while.
auto; ecall (__poly_reduce_proof param b_param).
auto; ecall (__poly_reduce_proof param b_param).
auto; ecall (__poly_reduce_proof param b_param).
auto; ecall (__poly_reduce_proof param b_param).
by auto => /> *.
qed.

lemma __i_polyvec_frombytes_proof _a _b_a :
      (__i_polyvec_frombytes_spec _a _b_a).
proof.
hint +safety.
rewrite /__i_polyvec_frombytes_spec; proc.
conseq (_ :
     b_a = BArray1536.init_arr (W8.of_int 255)
  ==> BArray2048.is_init b_r 0 2048
   /\ valid trace___i_polyvec_frombytes).
+ by move=> &hr />; rewrite -!(BI1536.is_init_full _ 1536) //.
unroll for ^while.
auto; ecall (_i_poly_frombytes_proof param_0 b_param_0 param b_param).
auto; ecall (_i_poly_frombytes_proof param_0 b_param_0 param b_param).
auto; ecall (_i_poly_frombytes_proof param_0 b_param_0 param b_param).
auto; ecall (_i_poly_frombytes_proof param_0 b_param_0 param b_param).
by auto => /> *.
qed.

lemma __i_polyvec_tobytes_proof _r _b_r _a _b_a :
      (__i_polyvec_tobytes_spec _r _b_r _a _b_a).
proof.
hint +safety.
rewrite /__i_polyvec_tobytes_spec; proc.
conseq (_ :
     b_a = BArray2048.init_arr (W8.of_int 255)
  ==> BArray1536.is_init b_r 0 (4 * 384)
   /\ valid trace___i_polyvec_tobytes).
+ by move=> &hr />; rewrite -!(BI2048.is_init_full _ 2048) //.
unroll for ^while.
auto; ecall (_i_poly_tobytes_proof param_0 b_param_0 param b_param).
auto; ecall (_i_poly_tobytes_proof param_0 b_param_0 param b_param).
auto; ecall (_i_poly_tobytes_proof param_0 b_param_0 param b_param).
auto; ecall (_i_poly_tobytes_proof param_0 b_param_0 param b_param).
by auto => /> *.
qed.

lemma __polyvec_pointwise_acc_proof _r _b_r _a _b_a _b _b_b :
      (__polyvec_pointwise_acc_spec _r _b_r _a _b_a _b _b_b).
proof.
hint +safety.
rewrite /__polyvec_pointwise_acc_spec; proc.
conseq (_ :
     b_a = BArray2048.init_arr (W8.of_int 255)
  /\ b_b = BArray2048.init_arr (W8.of_int 255)
  ==> BArray512.is_init b_r 0 (256 * 2)
   /\ valid trace___polyvec_pointwise_acc).
+ by move=> &hr />; rewrite -!(BI2048.is_init_full _ 2048) //.
unroll for ^while.
auto; ecall (_poly_add2_proof param_6 ((BArray512.init_arr (W8.of_int 255))) param_5 ((BArray512.init_arr (W8.of_int 255)))).
auto; ecall (_poly_basemul_proof param_4 b_param_1 param_3 b_param_0 param_2 b_param).
auto; ecall (_poly_add2_proof param_6 ((BArray512.init_arr (W8.of_int 255))) param_5 ((BArray512.init_arr (W8.of_int 255)))).
auto; ecall (_poly_basemul_proof param_4 b_param_1 param_3 b_param_0 param_2 b_param).
auto; ecall (_poly_add2_proof param_6 ((BArray512.init_arr (W8.of_int 255))) param_5 ((BArray512.init_arr (W8.of_int 255)))).
auto; ecall (_poly_basemul_proof param_4 b_param_1 param_3 b_param_0 param_2 b_param).
auto; ecall (_poly_basemul_proof param_1 b_param_4 param_0 b_param_3 param b_param_2).
by auto => /> *.
qed.

lemma _i_poly_compress_dv5_proof _rp _b_rp _a _b_a :
      (_i_poly_compress_dv5_spec _rp _b_rp _a _b_a).
proof.
hint +safety.
rewrite /_i_poly_compress_dv5_spec; proc.
conseq (_ :
     b_a = BArray512.init_arr (W8.of_int 255)
  ==> BArray160.is_init b_rp 0 ((256 * 5) %/ 8)
   /\ BArray512.is_init b_a 0 (2 * 256)
   /\ valid trace__i_poly_compress_dv5).
+ by move=> &hr />; rewrite -!(BI512.is_init_full _ 512) //.
+ by move=> />.
unroll for ^while.
auto; ecall (_poly_csubq_proof param ((BArray512.init_arr (W8.of_int 255)))).
by auto => /> *.
qed.

lemma _i_poly_decompress_dv5_proof _rp _b_rp _a _b_a :
      (_i_poly_decompress_dv5_spec _rp _b_rp _a _b_a).
proof.
hint +safety.
rewrite /_i_poly_decompress_dv5_spec; proc.
conseq (_ :
     b_a = BArray160.init_arr (W8.of_int 255)
  ==> BArray512.is_init b_rp 0 (2 * 256)
   /\ valid trace__i_poly_decompress_dv5).
+ by move=> &hr />; rewrite -!(BI160.is_init_full _ 160) //.
unroll for ^while.
by auto => /> *.
qed.

lemma __i_polyvec_decompress_du11_proof _r _b_r _rp _b_rp :
      (__i_polyvec_decompress_du11_spec _r _b_r _rp _b_rp).
proof.
hint +safety.
rewrite /__i_polyvec_decompress_du11_spec; proc.
conseq (_ :
     b_rp = BArray1568.init_arr (W8.of_int 255)
  ==> BArray2048.is_init b_r 0 ((4 * 256) * 2)
   /\ valid trace___i_polyvec_decompress_du11).
+ by move=> &hr />; rewrite -!(BI1568.is_init_full _ 1568) //.
do 5! (unroll for ^while).
by auto => /> *.
qed.

lemma __i_polyvec_compress_du11_proof _rp _b_rp _a _b_a :
      (__i_polyvec_compress_du11_spec _rp _b_rp _a _b_a).
proof.
hint +safety.
rewrite /__i_polyvec_compress_du11_spec; proc.
conseq (_ :
     b_a = BArray2048.init_arr (W8.of_int 255)
  ==> BArray1410.is_init b_rp 0 ((4 * ((256 * 11) %/ 8)) + (2 * (11 - 10)))
   /\ valid trace___i_polyvec_compress_du11).
+ by move=> &hr />; rewrite -!(BI2048.is_init_full _ 2048) //.
unroll for ^while.
auto; ecall (__polyvec_csubq_proof param ((BArray2048.init_arr (W8.of_int 255)))).
by auto => /> *.
qed.

lemma _i_poly_compress_proof _rp _b_rp _a _b_a :
      (_i_poly_compress_spec _rp _b_rp _a _b_a).
proof.
hint +safety.
rewrite /_i_poly_compress_spec; proc.
conseq (_ :
     b_a = BArray512.init_arr (W8.of_int 255)
  ==> BArray160.is_init b_rp 0 ((256 * 5) %/ 8)
   /\ BArray512.is_init b_a 0 (2 * 256)
   /\ valid trace__i_poly_compress).
+ by move=> &hr />; rewrite -!(BI512.is_init_full _ 512) //.
+ by move=> />.
auto; ecall (_i_poly_compress_dv5_proof param_0 b_param param ((BArray512.init_arr (W8.of_int 255)))).
by auto => /> *.
qed.

lemma _i_poly_decompress_proof _rp _b_rp _a _b_a :
      (_i_poly_decompress_spec _rp _b_rp _a _b_a).
proof.
hint +safety.
rewrite /_i_poly_decompress_spec; proc.
conseq (_ :
     b_a = BArray160.init_arr (W8.of_int 255)
  ==> BArray512.is_init b_rp 0 (256 * 2)
   /\ valid trace__i_poly_decompress).
+ by move=> &hr />; rewrite -!(BI160.is_init_full _ 160) //.
auto; ecall (_i_poly_decompress_dv5_proof param_0 b_param param ((BArray160.init_arr (W8.of_int 255)))).
by auto => /> *.
qed.

lemma __i_polyvec_compress_proof _rp _b_rp _a _b_a :
      (__i_polyvec_compress_spec _rp _b_rp _a _b_a).
proof.
hint +safety.
rewrite /__i_polyvec_compress_spec; proc.
conseq (_ :
     b_a = BArray2048.init_arr (W8.of_int 255)
  ==> BArray1410.is_init b_rp 0 (4 * ((256 * 11) %/ 8))
   /\ valid trace___i_polyvec_compress).
+ by move=> &hr />; rewrite -!(BI2048.is_init_full _ 2048) //.
auto; ecall (__i_polyvec_compress_du11_proof param_0 b_param param ((BArray2048.init_arr (W8.of_int 255)))).
by auto => /> *.
qed.

lemma __i_polyvec_decompress_proof _r _b_r _rp _b_rp :
      (__i_polyvec_decompress_spec _r _b_r _rp _b_rp).
proof.
hint +safety.
rewrite /__i_polyvec_decompress_spec; proc.
conseq (_ :
     b_rp = BArray1568.init_arr (W8.of_int 255)
  ==> BArray2048.is_init b_r 0 ((4 * 256) * 2)
   /\ valid trace___i_polyvec_decompress).
+ by move=> &hr />; rewrite -!(BI1568.is_init_full _ 1568) //.
auto; ecall (__i_polyvec_decompress_du11_proof param_0 b_param param ((BArray1568.init_arr (W8.of_int 255)))).
by auto => /> *.
qed.

lemma __gen_matrix_buf_rejection_filter48_proof _pol _b_pol _counter _buf _b_buf _buf_offset _load_shuffle _mask _bounds _sst _b_sst _ones _ms :
      (__gen_matrix_buf_rejection_filter48_spec _pol _b_pol _counter 
      _buf _b_buf _buf_offset _load_shuffle _mask _bounds _sst _b_sst 
      _ones _ms).
proof.
hint +safety.
rewrite /__gen_matrix_buf_rejection_filter48_spec .
proc. 
auto => /> *.
have H : forall w,0<= count idfun (W64.w2bits (W64.of_int (W64.to_uint w %% 256))) <= 8.
+ move => w; rewrite count_ge0 /=.
  rewrite w2bitsE (: 64 = 8 + 56) 1://  mkseq_add // count_cat /=.
  have  ->/= : count idfun (mkseq (fun (i : int) => (W64.of_int (to_uint w %% 256)).[8 + i]) 56) = 0 ; last  by smt(size_mkseq count_ge0 count_size).
  rewrite /mkseq count_map /preim /idfun /=;apply count_pred0_eq_in => x; rewrite mem_iota  /= => *.
  rewrite get_to_uint /= (: (0 <= 8 + x < 64)) 1:/# /=.
  rewrite of_uintK /= (modz_small _ 18446744073709551616); 1:smt().
  have /= ? : 2^8 <=  2 ^ (8 + x) <= 2^64; last by smt().
  split; 1: by  apply StdOrder.IntOrder.ler_weexpn2l; smt(). 
  move => ?. 
  by have  := StdOrder.IntOrder.ler_weexpn2l 2 _ (8+x) 64 _;  smt(). 

pose w := ((Jslh.SLH64.protect_64 _)).
have H255 : 255 = 2^8 - 1 by auto.
rewrite H255 !and_mod //=.
  rewrite / POPCNT_64 /rflags_of_popcnt /flags_w /=.

have h : forall w, 0 <=to_uint(W64.of_int (count idfun (w2bits (W64.of_int (W64.to_uint (w) %% 256))))) <=8. move => ?. rewrite !to_uintK_small; smt(). 
rewrite !to_uintM_small => /=. smt(pow2_64). rewrite !to_uintD_small /=; 1..2: smt(to_uintK). rewrite !to_uintD_small /=;1..4:smt(to_uintK). rewrite !to_uintD_small /=;1..8:smt(to_uintK).
rewrite !W64.to_uintD_small /=;1..26:
 smt(W64.of_uintK pow2_64 modz_small).

pose c1 := W64.to_uint (W64.of_int (count idfun (w2bits (W64.of_int (to_uint (w _ms `>>` W8.of_int 8) %% 256))))).
pose c2 := W64.to_uint (W64.of_int (count idfun (w2bits (W64.of_int (to_uint (w _ms `>>` W8.of_int 16) %% 256))))).
pose c3 := W64.to_uint (W64.of_int (count idfun (w2bits (W64.of_int (to_uint (w _ms `>>` W8.of_int 24) %% 256))))).
pose c4 := W64.to_uint(W64.of_int (count idfun (w2bits (W64.of_int (to_uint (w _ms) %% 256))))).
rewrite /is_init /=. split. split. split. smt(). smt(). smt().
split.  smt().
move => *. split. smt().
move => *. split. rewrite to_uintK_small /=; smt().  
move => *. split.  rewrite to_uintK_small /=; smt().  
move => *. split.  rewrite to_uintK_small /=; smt().  
move => *. split.  rewrite to_uintK_small /=; smt().  
move => *. split. smt(). 
move => *. split. split; smt().
move => *. split. split; smt().
split; smt(). 
qed.

lemma __write_u128_boundchk_proof _pol _b_pol _ctr _data _ms :
      (__write_u128_boundchk_spec _pol _b_pol _ctr _data _ms).
proof.
hint +safety.
  rewrite /__write_u128_boundchk_spec .
  proc. sp 3.
  if. auto.  move => &m /> ?. rewrite  W64.uleE /=. rewrite /is_init /= => *. smt(W64.to_uint_cmp). 
  auto. move => &m /> ?. rewrite !uleE /is_init /valid /= => /> *. 
  split. move => *. rewrite !to_uintD_small /=; smt().
  move => *. split. move => *. rewrite !to_uintD_small /=; smt().
  move => *. smt().
qed .

lemma __gen_matrix_buf_rejection_filter24_proof _pol _b_pol _counter _buf _b_buf _buf_offset _load_shuffle _mask _bounds _sst _b_sst _ones _ms :
      (__gen_matrix_buf_rejection_filter24_spec _pol _b_pol _counter 
      _buf _b_buf _buf_offset _load_shuffle _mask _bounds _sst _b_sst 
      _ones _ms).
proof.
hint +safety.
rewrite /__gen_matrix_buf_rejection_filter24_spec .
  proc. auto. ecall (__write_u128_boundchk_proof param_6 b_param param_5 param_4 param_3). auto.
  ecall (__write_u128_boundchk_proof param_2 b_param_0 param_1 param_0 param). auto. rewrite /valid  => /> . 
  have H : forall w,0<= count idfun (W64.w2bits (W64.of_int (W64.to_uint w %% 256))) <= 8.
  + move => w; rewrite count_ge0 /=. 
    rewrite w2bitsE (: 64 = 8 + 56) 1://  mkseq_add // count_cat /=.
    have  ->/= : count idfun (mkseq (fun (i : int) => (W64.of_int (to_uint w %% 256)).[8 + i]) 56) = 0 ; last  by smt(size_mkseq count_ge0 count_size).
    rewrite /mkseq count_map /preim /idfun /=;apply count_pred0_eq_in => x; rewrite mem_iota  /= => *.
    rewrite get_to_uint /= (: (0 <= 8 + x < 64)) 1:/# /=.
    rewrite of_uintK /= (modz_small _ 18446744073709551616); 1:smt().
    have /= ? : 2^8 <=  2 ^ (8 + x) <= 2^64; last by smt(). 
    split; 1: by  apply StdOrder.IntOrder.ler_weexpn2l; smt(). 
    move => ?.  by have  := StdOrder.IntOrder.ler_weexpn2l 2 _ (8+x) 64 _;  smt(). 
  have H' : forall w',0<= count idfun (W64.w2bits (W64.of_int (W32.to_uint w' %% 256))) <= 8.
  + move => w'; rewrite count_ge0 /=.   rewrite w2bitsE (: 64 = 8 + 56) 1://  mkseq_add // count_cat /=.
    have  ->/= : count idfun (mkseq (fun (i : int) => (W64.of_int (to_uint w' %% 256)).[8 + i]) 56) = 0 ; last  by smt(size_mkseq count_ge0 count_size).
    rewrite /mkseq count_map /preim /idfun /=;apply count_pred0_eq_in => x; rewrite mem_iota  /= => *.
    rewrite get_to_uint /= (: (0 <= 8 + x < 64)) 1:/# /=.
    rewrite of_uintK /= (modz_small _ 18446744073709551616); 1:smt().
    have /= ? : 2^8 <=  2 ^ (8 + x) <= 2^64; last by smt().
    split; 1: by  apply StdOrder.IntOrder.ler_weexpn2l; smt(). 
    move => ?.  by have  := StdOrder.IntOrder.ler_weexpn2l 2 _ (8+x) 64 _;  smt(). 
  pose w := ((Jslh.SLH64.protect_64 _)). 
  have H255 : 255 = 2^8 - 1 by auto.
  rewrite H255 !and_mod //=.
  rewrite / POPCNT_64 /rflags_of_popcnt /flags_w /=. rewrite uleE /=. have h: W32.modulus < 18446744073709551616. by auto.
  move => *.
  have h2 : forall w, 0 <=to_uint(W64.of_int (count idfun (w2bits (W64.of_int (W64.to_uint (w) %% 256))))) <=8. move => ?. rewrite !to_uintK_small; smt().
  rewrite !to_uintD_small /=;1..4: smt(to_uintK).
  pose c1 := to_uint
        (W64.of_int (count idfun (w2bits (W64.of_int (to_uint (w _ms) %% 256))))).  
  pose c2 := to_uint (W64.of_int (count idfun (w2bits (W64.of_int (to_uint (w _ms `>>` W8.of_int 16) %% 256))))).
  split.  smt(). rewrite /is_init /=.
  move => *.  split. smt().
  move => *. split. split; smt().
  split. smt().
  split. rewrite W64.to_uintK_small /=; smt(). 
  split. rewrite W64.to_uintK_small /=; smt(). 
  by rewrite W64.of_uintK; smt(modz_cmp).
qed.

lemma _gen_matrix_buf_rejection_proof _pol _b_pol _counter _buf _b_buf _buf_offset :
      (_gen_matrix_buf_rejection_spec _pol _b_pol _counter _buf _b_buf _buf_offset).
proof.
hint +safety.
rewrite /_gen_matrix_buf_rejection_spec; proc; auto.
while (valid trace__gen_matrix_buf_rejection /\ 0 <= W64.to_uint counter /\
       BArray512.is_init b_pol 0 (2 * W64.to_uint counter) /\
       (condition_loop => W64.to_uint buf_offset < 481) /\
       W64.to_uint _counter <= W64.to_uint counter).
+ auto; sp; if.
  + auto; ecall (__gen_matrix_buf_rejection_filter24_proof param_18 b_param param_17 param_16
      (BArray536.init_arr (W8.of_int 255)) param_15 param_14 param_13 param_12 param_11
      (BArray2048.init_arr (W8.of_int 255)) param_10 param_9).
    auto => &hr /> *.
    have ? : W64.to_uint counter{hr} < 256.
    + by have := W64.ultE counter{hr} (W64.of_int 256); rewrite W64.of_uintK /= /#.
    split; first smt(W64.to_uint_cmp).
    move=> *; do! split;
      [smt(W64.to_uint_cmp) | by rewrite W64.ultE W64.of_uintK /= | smt(W64.uleE)].
  by auto => /> *.
wp.
while (valid trace__gen_matrix_buf_rejection /\ 0 <= W64.to_uint counter /\
       W64.to_uint counter <= 256 /\ W64.to_uint _counter <= W64.to_uint counter /\
       BArray512.is_init b_pol 0 (2 * W64.to_uint counter) /\
       (W64.to_uint counter < 225 => saved_buf_offset = buf_offset) /\
       (condition_loop => W64.to_uint buf_offset < 457)).
+ auto; sp; if.
  + auto; ecall (__gen_matrix_buf_rejection_filter48_proof param_8 b_param_0 param_7 param_6
      (BArray536.init_arr (W8.of_int 255)) param_5 param_4 param_3 param_2 param_1
      (BArray2048.init_arr (W8.of_int 255)) param_0 param).
    auto => &hr /> *.
    have ? : W64.to_uint counter{hr} < 225.
    + by have := W64.ultE counter{hr} (W64.of_int 225); rewrite W64.of_uintK /= /#.
    split; first smt(W64.to_uint_cmp).
    move=> *; do! split; [smt(W64.to_uint_cmp) | smt() | by rewrite W64.ultE W64.of_uintK /=].
  auto => &hr /> *.
  by have := W64.ultE counter{hr} (W64.of_int 225); rewrite W64.of_uintK /= /#.
auto => &hr /> *.
split; first by split; [smt() | rewrite W64.ultE W64.of_uintK /=].
move=> *; split; first by rewrite W64.ultE W64.of_uintK /=.
by move=> *; rewrite W64.uleE /#.
qed.

lemma gen_matrix_get_indexes_proof _b __t :
      (gen_matrix_get_indexes_spec _b __t).
proof.
hint +safety.
rewrite /gen_matrix_get_indexes_spec.
proc; auto => &hr />.
rewrite !W64.uleE /(`<<`) /= => h1 h2; smt(W64.to_uint_cmp).
qed.

lemma __gen_matrix_fill_polynomial_proof _pol _b_pol _buf _b_buf :
      (__gen_matrix_fill_polynomial_spec _pol _b_pol _buf _b_buf).
proof.
hint +safety.
rewrite /__gen_matrix_fill_polynomial_spec; proc; auto.
while (valid trace___gen_matrix_fill_polynomial /\ 0 <= W64.to_uint counter /\
       W64.to_uint buf_offset = 336 /\
       BArray512.is_init b_pol 0 (W64.to_uint counter * 2) /\
       BArray536.is_init b_buf 0 536).
+ auto; ecall (_gen_matrix_buf_rejection_proof param_7 b_param param_6 param_5
    (BArray536.init_arr (W8.of_int 255)) param_4).
  auto; ecall (_shake128_next_state_proof param_3 (BArray536.init_arr (W8.of_int 255))).
  auto => &hr /> *.
  have ? : W64.to_uint counter{hr} < 256.
  + by have := W64.ultE counter{hr} (W64.of_int 256); rewrite W64.of_uintK /= /#.
  split; first smt().
  by move=> *; smt(W64.to_uint_cmp).
auto; ecall (_gen_matrix_buf_rejection_proof param_2 b_param_0 param_1 param_0
  (BArray536.init_arr (W8.of_int 255)) param).
auto => /> *.
split; first smt(W64.to_uint_cmp).
move=> b c t; rewrite W64.ultE W64.of_uintK /= => *.
by apply (BI512.is_init_sub b 0 (W64.to_uint c * 2) 0 512) => // /#.
qed.

lemma _gen_matrix_sample_four_polynomials_proof _polx4 _b_polx4 _buf _b_buf _rho _b_rho _pos_entry _transposed :
      (_gen_matrix_sample_four_polynomials_spec _polx4 _b_polx4 _buf 
      _b_buf _rho _b_rho _pos_entry _transposed).
proof.
hint +safety.
rewrite /_gen_matrix_sample_four_polynomials_spec; proc.
conseq (_ :
     b_rho = BArray32.init_arr (W8.of_int 255)
  /\ (W64.of_int 0) \ule (pos_entry + (transposed `<<` (W8.of_int (4 + 1))))
  /\ (pos_entry + (transposed `<<` (W8.of_int (4 + 1)))) \ule (W64.of_int ((1 `<<` (4 + 2)) - 8))
  ==> BArray2048.is_init b_polx4 0 2048
   /\ valid trace__gen_matrix_sample_four_polynomials).
+ by move=> &hr />; rewrite -!(BI32.is_init_full _ 32) //.
auto; ecall (__gen_matrix_fill_polynomial_proof param_13 b_param_0 param_12 b_param).
auto; ecall (__gen_matrix_fill_polynomial_proof param_11 b_param_2 param_10 b_param_1).
auto; ecall (__gen_matrix_fill_polynomial_proof param_9 b_param_4 param_8 b_param_3).
auto; ecall (__gen_matrix_fill_polynomial_proof param_7 b_param_6 param_6 b_param_5).
auto; ecall (_shake128x4_squeeze3blocks_proof param_5 ((BArray800.init_arr (W8.of_int 255))) param_4 b_param_7).
auto; ecall (_shake128x4_absorb_A32_A2_proof param_3 b_param_9 param_2 ((BArray32.init_arr (W8.of_int 255))) param_1 b_param_8).
auto; ecall (gen_matrix_get_indexes_proof param_0 param).
by auto => /> *.
qed.

lemma _gen_matrix_avx2_proof _matrix _b_matrix _rho _b_rho _transposed :
      (_gen_matrix_avx2_spec _matrix _b_matrix _rho _b_rho _transposed).
proof.
hint +safety.
rewrite /_gen_matrix_avx2_spec; proc.
conseq (_ :
     b_rho = BArray32.init_arr (W8.of_int 255)
  /\ (W64.of_int 0) \ule transposed
  /\ transposed \ule (W64.of_int 1)
  ==> BArray8192.is_init b_matrix 0 (((4 * 4) * 256) * 2)
   /\ valid trace__gen_matrix_avx2).
+ by move=> &hr />; rewrite -!(BI32.is_init_full _ 32) //.
do 6! (unroll for ^while).
auto; ecall (_nttunpack_proof param_4 b_param).
auto; ecall (_nttunpack_proof param_4 b_param).
auto; ecall (_nttunpack_proof param_4 b_param).
auto; ecall (_nttunpack_proof param_4 b_param).
auto; ecall (_nttunpack_proof param_4 b_param).
auto; ecall (_nttunpack_proof param_4 b_param).
auto; ecall (_nttunpack_proof param_4 b_param).
auto; ecall (_nttunpack_proof param_4 b_param).
auto; ecall (_nttunpack_proof param_4 b_param).
auto; ecall (_nttunpack_proof param_4 b_param).
auto; ecall (_nttunpack_proof param_4 b_param).
auto; ecall (_nttunpack_proof param_4 b_param).
auto; ecall (_nttunpack_proof param_4 b_param).
auto; ecall (_nttunpack_proof param_4 b_param).
auto; ecall (_nttunpack_proof param_4 b_param).
auto; ecall (_nttunpack_proof param_4 b_param).
auto; ecall (_gen_matrix_sample_four_polynomials_proof param_3 b_param_1 param_2 b_param_0 param_1 ((BArray32.init_arr (W8.of_int 255))) param_0 param).
auto; ecall (_gen_matrix_sample_four_polynomials_proof param_3 b_param_1 param_2 b_param_0 param_1 ((BArray32.init_arr (W8.of_int 255))) param_0 param).
auto; ecall (_gen_matrix_sample_four_polynomials_proof param_3 b_param_1 param_2 b_param_0 param_1 ((BArray32.init_arr (W8.of_int 255))) param_0 param).
auto; ecall (_gen_matrix_sample_four_polynomials_proof param_3 b_param_1 param_2 b_param_0 param_1 ((BArray32.init_arr (W8.of_int 255))) param_0 param).
auto => &hr /> h0 h1.
(* transposed is 0 or 1: the entry positions fit in the 64-byte table *)
have ht : W64.to_uint transposed{hr} <= 1.
+ by have := W64.uleE transposed{hr} W64.one; rewrite /#.
have hs : W64.to_uint (transposed{hr} `<<` W8.of_int 5) = 32 * W64.to_uint transposed{hr}.
+ rewrite /(`<<`) W8.of_uintK /= W64.to_uint_shl // /ptr_modulus /= modz_small;
  by smt(W64.to_uint_cmp).
rewrite /JUtils.(`<<`) /= !W64.uleE hs.
by rewrite !W64.of_uintK /= !W64.to_uintD_small ?W64.of_uintK /= ?hs; smt(W64.to_uint_cmp).
qed.

lemma __indcpa_keypair_proof _pk _b_pk _sk _b_sk _randomnessp _b_randomnessp :
      (__indcpa_keypair_spec _pk _b_pk _sk _b_sk _randomnessp _b_randomnessp).
proof.
hint +safety.
rewrite /__indcpa_keypair_spec; proc.
conseq (_ :
     b_randomnessp = BArray32.init_arr (W8.of_int 255)
  ==> BArray1568.is_init b_pk 0 ((4 * 384) + 32)
   /\ BArray1536.is_init b_sk 0 (4 * 384)
   /\ valid trace___indcpa_keypair).
+ by move=> &hr />; rewrite -!(BI32.is_init_full _ 32) //.
+ by move=> />.
do 4! (unroll for ^while).
auto; ecall (__i_polyvec_tobytes_proof param_28 b_param param_27 ((BArray2048.init_arr (W8.of_int 255)))).
auto; ecall (__i_polyvec_tobytes_proof param_26 b_param_0 param_25 ((BArray2048.init_arr (W8.of_int 255)))).
auto; ecall (__polyvec_reduce_proof param_24 ((BArray2048.init_arr (W8.of_int 255)))).
auto; ecall (__polyvec_add2_proof param_23 b_param_1 param_22 ((BArray2048.init_arr (W8.of_int 255)))).
auto; ecall (_poly_frommont_proof param_21 b_param_2).
auto; ecall (__polyvec_pointwise_acc_proof param_20 b_param_4 param_19 b_param_3 param_18 ((BArray2048.init_arr (W8.of_int 255)))).
auto; ecall (_poly_frommont_proof param_21 b_param_2).
auto; ecall (__polyvec_pointwise_acc_proof param_20 b_param_4 param_19 b_param_3 param_18 ((BArray2048.init_arr (W8.of_int 255)))).
auto; ecall (_poly_frommont_proof param_21 b_param_2).
auto; ecall (__polyvec_pointwise_acc_proof param_20 b_param_4 param_19 b_param_3 param_18 ((BArray2048.init_arr (W8.of_int 255)))).
auto; ecall (_poly_frommont_proof param_21 b_param_2).
auto; ecall (__polyvec_pointwise_acc_proof param_20 b_param_4 param_19 b_param_3 param_18 ((BArray2048.init_arr (W8.of_int 255)))).
auto; ecall (__polyvec_ntt_proof param_17 b_param_5).
auto; ecall (__polyvec_ntt_proof param_16 b_param_6).
auto; ecall (_poly_getnoise_eta1_4x_proof param_15 b_param_11 param_14 b_param_10 param_13 b_param_9 param_12 b_param_8 param_11 b_param_7 param_10).
auto; ecall (_poly_getnoise_eta1_4x_proof param_9 b_param_16 param_8 b_param_15 param_7 b_param_14 param_6 b_param_13 param_5 b_param_12 param_4).
auto; ecall (_gen_matrix_avx2_proof param_3 b_param_18 param_2 b_param_17 param_1).
auto; ecall (_sha3_512A_A33_proof param_0 b_param_20 param b_param_19).
by auto => /> *.
qed.

lemma __indcpa_enc_proof _ct _b_ct _msgp _b_msgp _pk _b_pk _noiseseed _b_noiseseed :
      (__indcpa_enc_spec _ct _b_ct _msgp _b_msgp _pk _b_pk _noiseseed
      _b_noiseseed).
proof.
hint +safety.
rewrite /__indcpa_enc_spec; proc.
conseq (_ :
     b_msgp = BArray32.init_arr (W8.of_int 255)
  /\ b_pk = BArray1568.init_arr (W8.of_int 255)
  /\ b_noiseseed = BArray32.init_arr (W8.of_int 255)
  ==> BArray1568.is_init b_ct 0 ((4 * ((256 * 11) %/ 8)) + ((256 * 5) %/ 8))
   /\ valid trace___indcpa_enc).
+ by move=> &hr />; rewrite -!(BI32.is_init_full _ 32) // -!(BI1568.is_init_full _ 1568) //.
do 2! (unroll for ^while).
auto; ecall (_i_poly_compress_proof param_40 b_param param_39 ((BArray512.init_arr (W8.of_int 255)))).
auto; ecall (__i_polyvec_compress_proof param_38 b_param_0 param_37 ((BArray2048.init_arr (W8.of_int 255)))).
auto; ecall (__poly_reduce_proof param_36 ((BArray512.init_arr (W8.of_int 255)))).
auto; ecall (__polyvec_reduce_proof param_35 ((BArray2048.init_arr (W8.of_int 255)))).
auto; ecall (_poly_add2_proof param_34 ((BArray512.init_arr (W8.of_int 255))) param_33 ((BArray512.init_arr (W8.of_int 255)))).
auto; ecall (_poly_add2_proof param_32 ((BArray512.init_arr (W8.of_int 255))) param_31 ((BArray512.init_arr (W8.of_int 255)))).
auto; ecall (__polyvec_add2_proof param_30 ((BArray2048.init_arr (W8.of_int 255))) param_29 b_param_1).
auto; ecall (_poly_invntt_proof param_28 ((BArray512.init_arr (W8.of_int 255)))).
auto; ecall (__polyvec_invntt_proof param_27 b_param_2).
auto; ecall (__polyvec_pointwise_acc_proof param_26 b_param_3 param_25 ((BArray2048.init_arr (W8.of_int 255))) param_24 ((BArray2048.init_arr (W8.of_int 255)))).
auto; ecall (__polyvec_pointwise_acc_proof param_23 b_param_5 param_22 b_param_4 param_21 ((BArray2048.init_arr (W8.of_int 255)))).
auto; ecall (__polyvec_pointwise_acc_proof param_23 b_param_5 param_22 b_param_4 param_21 ((BArray2048.init_arr (W8.of_int 255)))).
auto; ecall (__polyvec_pointwise_acc_proof param_23 b_param_5 param_22 b_param_4 param_21 ((BArray2048.init_arr (W8.of_int 255)))).
auto; ecall (__polyvec_pointwise_acc_proof param_23 b_param_5 param_22 b_param_4 param_21 ((BArray2048.init_arr (W8.of_int 255)))).
auto; ecall (__polyvec_ntt_proof param_20 b_param_6).
auto; ecall (_poly_getnoise_eta2_proof param_19 b_param_7 param_18 ((BArray32.init_arr (W8.of_int 255))) param_17).
auto; ecall (_poly_getnoise_eta1_4x_proof param_16 b_param_11 param_15 b_param_10 param_14 b_param_9 param_13 b_param_8 param_12 ((BArray32.init_arr (W8.of_int 255))) param_11).
auto; ecall (_poly_getnoise_eta1_4x_proof param_10 b_param_15 param_9 b_param_14 param_8 b_param_13 param_7 b_param_12 param_6 ((BArray32.init_arr (W8.of_int 255))) param_5).
auto; ecall (_gen_matrix_avx2_proof param_4 b_param_17 param_3 b_param_16 param_2).
auto; ecall (_i_poly_frommsg_proof param_1 b_param_18 param_0 ((BArray32.init_arr (W8.of_int 255)))).
auto; ecall (__i_polyvec_frombytes_proof param b_param_19).
by auto => /> *.
qed.

lemma __indcpa_dec_proof _msgp _b_msgp _ct _b_ct _sk _b_sk :
      (__indcpa_dec_spec _msgp _b_msgp _ct _b_ct _sk _b_sk).
proof.
hint +safety.
rewrite /__indcpa_dec_spec; proc.
conseq (_ :
     b_ct = BArray1568.init_arr (W8.of_int 255)
  /\ b_sk = BArray1536.init_arr (W8.of_int 255)
  ==> BArray32.is_init b_msgp 0 32
   /\ valid trace___indcpa_dec).
+ by move=> &hr />; rewrite -!(BI1536.is_init_full _ 1536) // -!(BI1568.is_init_full _ 1568) //.
auto; ecall (_i_poly_tomsg_proof param_14 b_param param_13 ((BArray512.init_arr (W8.of_int 255)))).
auto; ecall (__poly_reduce_proof param_12 ((BArray512.init_arr (W8.of_int 255)))).
auto; ecall (_poly_sub_proof param_11 b_param_0 param_10 ((BArray512.init_arr (W8.of_int 255))) param_9 ((BArray512.init_arr (W8.of_int 255)))).
auto; ecall (_poly_invntt_proof param_8 ((BArray512.init_arr (W8.of_int 255)))).
auto; ecall (__polyvec_pointwise_acc_proof param_7 b_param_1 param_6 ((BArray2048.init_arr (W8.of_int 255))) param_5 ((BArray2048.init_arr (W8.of_int 255)))).
auto; ecall (__polyvec_ntt_proof param_4 ((BArray2048.init_arr (W8.of_int 255)))).
auto; ecall (__i_polyvec_frombytes_proof param_3 ((BArray1536.init_arr (W8.of_int 255)))).
auto; ecall (_i_poly_decompress_proof param_2 b_param_3 param_1 b_param_2).
auto; ecall (__i_polyvec_decompress_proof param_0 b_param_4 param ((BArray1568.init_arr (W8.of_int 255)))).
by auto => /> *.
qed.

lemma __verify_proof _ct _b_ct _ctpc _b_ctpc :
      (__verify_spec _ct _b_ct _ctpc _b_ctpc).
proof.
hint +safety.
rewrite /__verify_spec; proc.
conseq (_ :
     b_ctpc = BArray1568.init_arr (W8.of_int 255)
  /\ b_ct = BArray1568.init_arr (W8.of_int 255)
  ==> valid trace___verify).
+ by move=> &hr />; rewrite -!(BI1568.is_init_full _ 1568) //.
unroll for ^while.
(* the comparison result is dead: drop it before wp, whose simplification
   would otherwise unfold the 49 word operations feeding it *)
kill 302 ! 2; first by auto.
by auto => /> *.
qed.

lemma __cmov_proof _dst _b_dst _src _b_src _cnd :
      (__cmov_spec _dst _b_dst _src _b_src _cnd).
proof.
hint +safety.
rewrite /__cmov_spec; proc.
conseq (_ :
     b_src = BArray32.init_arr (W8.of_int 255)
  /\ b_dst = BArray32.init_arr (W8.of_int 255)
  ==> BArray32.is_init b_dst 0 32
   /\ valid trace___cmov).
+ by move=> &hr />; rewrite -!(BI32.is_init_full _ 32) //.
by auto => /> *.
qed.

lemma __crypto_kem_keypair_jazz_proof _pk _b_pk _sk _b_sk _randomnessp _b_randomnessp :
      (__crypto_kem_keypair_jazz_spec _pk _b_pk _sk _b_sk _randomnessp
      _b_randomnessp).
proof.
hint +safety.
rewrite /__crypto_kem_keypair_jazz_spec; proc.
conseq (_ :
     b_randomnessp = BArray64.init_arr (W8.of_int 255)
  ==> BArray1568.is_init b_pk 0 ((4 * 384) + 32)
   /\ BArray3168.is_init b_sk 0 (((4 * 384) + ((4 * 384) + 32)) + (2 * 32))
   /\ valid trace___crypto_kem_keypair_jazz).
+ by move=> &hr />; rewrite -!(BI64.is_init_full _ 64) //.
+ by move=> />.
do 2! (unroll for ^while).
auto; ecall (_sha3_256A_APK_proof param_3 b_param param_2 ((BArray1568.init_arr (W8.of_int 255)))).
auto; ecall (__indcpa_keypair_proof param_1 b_param_2 param_0 b_param_1 param b_param_0).
by auto => /> *.
qed.

lemma __crypto_kem_enc_jazz_proof _ct _b_ct _shk _b_shk _pk _b_pk _randomnessp _b_randomnessp :
      (__crypto_kem_enc_jazz_spec _ct _b_ct _shk _b_shk _pk _b_pk
      _randomnessp _b_randomnessp).
proof.
hint +safety.
rewrite /__crypto_kem_enc_jazz_spec; proc.
conseq (_ :
     b_randomnessp = BArray32.init_arr (W8.of_int 255)
  /\ b_pk = BArray1568.init_arr (W8.of_int 255)
  ==> BArray1568.is_init b_ct 0 ((4 * ((256 * 11) %/ 8)) + ((256 * 5) %/ 8))
   /\ BArray32.is_init b_shk 0 32
   /\ valid trace___crypto_kem_enc_jazz).
+ by move=> &hr />; rewrite -!(BI32.is_init_full _ 32) // -!(BI1568.is_init_full _ 1568) //.
+ by move=> />.
auto; ecall (__indcpa_enc_proof param_6 b_param_1 param_5 b_param_0 param_4 ((BArray1568.init_arr (W8.of_int 255))) param_3 b_param).
auto; ecall (_sha3_512A_A64_proof param_2 b_param_3 param_1 b_param_2).
auto; ecall (_sha3_256A_APK_proof param_0 b_param_4 param ((BArray1568.init_arr (W8.of_int 255)))).
by auto => /> *.
qed.

lemma __crypto_kem_dec_jazz_proof _shk _b_shk _ct _b_ct _sk _b_sk :
      (__crypto_kem_dec_jazz_spec _shk _b_shk _ct _b_ct _sk _b_sk).
proof.
hint +safety.
rewrite /__crypto_kem_dec_jazz_spec; proc.
conseq (_ :
     b_ct = BArray1568.init_arr (W8.of_int 255)
  /\ b_sk = BArray3168.init_arr (W8.of_int 255)
  ==> BArray32.is_init b_shk 0 32
   /\ valid trace___crypto_kem_dec_jazz).
+ by move=> &hr />; rewrite -!(BI1568.is_init_full _ 1568) // -!(BI3168.is_init_full _ 3168) //.
unroll for ^while.
auto; ecall (__cmov_proof param_14 ((BArray32.init_arr (W8.of_int 255))) param_13 b_param param_12).
auto; ecall (_shake256_A32__AZCT_proof param_11 b_param_1 param_10 b_param_0).
auto; ecall (__verify_proof param_9 ((BArray1568.init_arr (W8.of_int 255))) param_8 ((BArray1568.init_arr (W8.of_int 255)))).
auto; ecall (__indcpa_enc_proof param_7 b_param_5 param_6 b_param_4 param_5 b_param_3 param_4 b_param_2).
auto; ecall (_sha3_512A_A64_proof param_3 b_param_7 param_2 b_param_6).
auto; ecall (__indcpa_dec_proof param_1 b_param_9 param_0 ((BArray1568.init_arr (W8.of_int 255))) param b_param_8).
by auto => /> *.
qed.

lemma jade_kem_mlkem_mlkem1024_amd64_avx2_keypair_derand_proof _public_key _b_public_key _secret_key _b_secret_key _coins _b_coins :
      (jade_kem_mlkem_mlkem1024_amd64_avx2_keypair_derand_spec _public_key
      _b_public_key _secret_key _b_secret_key _coins _b_coins).
proof.
hint +safety.
rewrite /jade_kem_mlkem_mlkem1024_amd64_avx2_keypair_derand_spec; proc.
conseq (_ :
     b_coins = BArray64.init_arr (W8.of_int 255)
  ==> BArray1568.is_init b_public_key 0 ((4 * 384) + 32)
   /\ BArray3168.is_init b_secret_key 0 (((4 * 384) + ((4 * 384) + 32)) + (2 * 32))
   /\ valid trace_jade_kem_mlkem_mlkem1024_amd64_avx2_keypair_derand).
+ by move=> &hr />; rewrite -!(BI64.is_init_full _ 64) //.
+ by move=> />.
auto; ecall (__crypto_kem_keypair_jazz_proof param_1 b_param_0 param_0 b_param param ((BArray64.init_arr (W8.of_int 255)))).
by auto => /> *.
qed.

lemma jade_kem_mlkem_mlkem1024_amd64_avx2_enc_derand_proof _ciphertext _b_ciphertext _shared_secret _b_shared_secret _public_key _b_public_key _coins _b_coins :
      (jade_kem_mlkem_mlkem1024_amd64_avx2_enc_derand_spec _ciphertext
      _b_ciphertext _shared_secret _b_shared_secret _public_key _b_public_key
      _coins _b_coins).
proof.
hint +safety.
rewrite /jade_kem_mlkem_mlkem1024_amd64_avx2_enc_derand_spec; proc.
conseq (_ :
     b_coins = BArray32.init_arr (W8.of_int 255)
  /\ b_public_key = BArray1568.init_arr (W8.of_int 255)
  ==> BArray1568.is_init b_ciphertext 0 ((4 * ((256 * 11) %/ 8)) + ((256 * 5) %/ 8))
   /\ BArray32.is_init b_shared_secret 0 32
   /\ valid trace_jade_kem_mlkem_mlkem1024_amd64_avx2_enc_derand).
+ by move=> &hr />; rewrite -!(BI32.is_init_full _ 32) // -!(BI1568.is_init_full _ 1568) //.
+ by move=> />.
auto; ecall (__crypto_kem_enc_jazz_proof param_2 b_param_0 param_1 b_param param_0 ((BArray1568.init_arr (W8.of_int 255))) param ((BArray32.init_arr (W8.of_int 255)))).
by auto => /> *.
qed.

lemma jade_kem_mlkem_mlkem1024_amd64_avx2_dec_proof _shared_secret _b_shared_secret _ciphertext _b_ciphertext _secret_key _b_secret_key :
      (jade_kem_mlkem_mlkem1024_amd64_avx2_dec_spec _shared_secret
      _b_shared_secret _ciphertext _b_ciphertext _secret_key _b_secret_key).
proof.
hint +safety.
rewrite /jade_kem_mlkem_mlkem1024_amd64_avx2_dec_spec; proc.
conseq (_ :
     b_ciphertext = BArray1568.init_arr (W8.of_int 255)
  /\ b_secret_key = BArray3168.init_arr (W8.of_int 255)
  ==> BArray32.is_init b_shared_secret 0 32
   /\ valid trace_jade_kem_mlkem_mlkem1024_amd64_avx2_dec).
+ by move=> &hr />; rewrite -!(BI1568.is_init_full _ 1568) // -!(BI3168.is_init_full _ 3168) //.
auto; ecall (__crypto_kem_dec_jazz_proof param_1 b_param param_0 ((BArray1568.init_arr (W8.of_int 255))) param ((BArray3168.init_arr (W8.of_int 255)))).
by auto => /> *.
qed.

