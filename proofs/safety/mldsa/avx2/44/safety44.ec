(* Safety of the ML-DSA-44 AVX2 implementation: every procedure of the
   safety model meets its contract (`<f>_spec`), i.e. the trace of the
   safety checks of a run from initialised inputs is valid and the outputs
   are initialised.

   The Keccak wrappers called by ML-DSA are assumed (axioms below), to be
   discharged by the safety proofs of the fips202 implementation.

   Most scripts are generated: after unrolling the constant-bound loops and
   discharging the callees by their lemmas, the initialisation witnesses are
   closed terms and the goals reduce by the hints of ByteArrayInit; the
   few loops with symbolic bounds or data-dependent conditions keep an
   invariant and hand-written word arithmetic. *)
require import AllCore IntDiv CoreMap List Distr.
from Jasmin require import JModel_x86 Jcheck JSafety.
require import Jmldsa44_safety ByteArrayInit.

require import BArray2 BArray8 BArray16 BArray32 BArray40 BArray64 BArray66 BArray84
  BArray96 BArray128 BArray136 BArray160 BArray168 BArray192 BArray200 BArray224 BArray256
  BArray272 BArray320 BArray384 BArray416 BArray512 BArray576 BArray680 BArray768
  BArray800 BArray848 BArray1024 BArray1280 BArray1312 BArray1664 BArray2048 BArray2304
  BArray2420 BArray2560 BArray4096 BArray16384.
require import SBArray128_32 SBArray128_64 SBArray224_200 SBArray272_136 SBArray384_96
  SBArray680_136 SBArray680_576 SBArray768_192 SBArray848_168 SBArray1280_320
  SBArray1312_32 SBArray1312_1280 SBArray1664_416 SBArray2304_576 SBArray2420_32
  SBArray2420_84 SBArray2420_2304 SBArray2560_32 SBArray2560_64 SBArray2560_384
  SBArray2560_1664 SBArray4096_1024 SBArray16384_1024 SBArray16384_4096.
clone ByteArrayInit as BI2 with theory A <- BArray2.
clone ByteArrayInit as BI8 with theory A <- BArray8.
clone ByteArrayInit as BI16 with theory A <- BArray16.
clone ByteArrayInit as BI32 with theory A <- BArray32.
clone ByteArrayInit as BI40 with theory A <- BArray40.
clone ByteArrayInit as BI64 with theory A <- BArray64.
clone ByteArrayInit as BI66 with theory A <- BArray66.
clone ByteArrayInit as BI84 with theory A <- BArray84.
clone ByteArrayInit as BI96 with theory A <- BArray96.
clone ByteArrayInit as BI128 with theory A <- BArray128.
clone ByteArrayInit as BI136 with theory A <- BArray136.
clone ByteArrayInit as BI160 with theory A <- BArray160.
clone ByteArrayInit as BI168 with theory A <- BArray168.
clone ByteArrayInit as BI192 with theory A <- BArray192.
clone ByteArrayInit as BI200 with theory A <- BArray200.
clone ByteArrayInit as BI224 with theory A <- BArray224.
clone ByteArrayInit as BI256 with theory A <- BArray256.
clone ByteArrayInit as BI272 with theory A <- BArray272.
clone ByteArrayInit as BI320 with theory A <- BArray320.
clone ByteArrayInit as BI384 with theory A <- BArray384.
clone ByteArrayInit as BI416 with theory A <- BArray416.
clone ByteArrayInit as BI512 with theory A <- BArray512.
clone ByteArrayInit as BI576 with theory A <- BArray576.
clone ByteArrayInit as BI680 with theory A <- BArray680.
clone ByteArrayInit as BI768 with theory A <- BArray768.
clone ByteArrayInit as BI800 with theory A <- BArray800.
clone ByteArrayInit as BI848 with theory A <- BArray848.
clone ByteArrayInit as BI1024 with theory A <- BArray1024.
clone ByteArrayInit as BI1280 with theory A <- BArray1280.
clone ByteArrayInit as BI1312 with theory A <- BArray1312.
clone ByteArrayInit as BI1664 with theory A <- BArray1664.
clone ByteArrayInit as BI2048 with theory A <- BArray2048.
clone ByteArrayInit as BI2304 with theory A <- BArray2304.
clone ByteArrayInit as BI2420 with theory A <- BArray2420.
clone ByteArrayInit as BI2560 with theory A <- BArray2560.
clone ByteArrayInit as BI4096 with theory A <- BArray4096.
clone ByteArrayInit as BI16384 with theory A <- BArray16384.
clone SubByteArrayInit as SBI128_32 with theory SB <- SBArray128_32.
clone SubByteArrayInit as SBI128_64 with theory SB <- SBArray128_64.
clone SubByteArrayInit as SBI224_200 with theory SB <- SBArray224_200.
clone SubByteArrayInit as SBI272_136 with theory SB <- SBArray272_136.
clone SubByteArrayInit as SBI384_96 with theory SB <- SBArray384_96.
clone SubByteArrayInit as SBI680_136 with theory SB <- SBArray680_136.
clone SubByteArrayInit as SBI680_576 with theory SB <- SBArray680_576.
clone SubByteArrayInit as SBI768_192 with theory SB <- SBArray768_192.
clone SubByteArrayInit as SBI848_168 with theory SB <- SBArray848_168.
clone SubByteArrayInit as SBI1280_320 with theory SB <- SBArray1280_320.
clone SubByteArrayInit as SBI1312_32 with theory SB <- SBArray1312_32.
clone SubByteArrayInit as SBI1312_1280 with theory SB <- SBArray1312_1280.
clone SubByteArrayInit as SBI1664_416 with theory SB <- SBArray1664_416.
clone SubByteArrayInit as SBI2304_576 with theory SB <- SBArray2304_576.
clone SubByteArrayInit as SBI2420_32 with theory SB <- SBArray2420_32.
clone SubByteArrayInit as SBI2420_84 with theory SB <- SBArray2420_84.
clone SubByteArrayInit as SBI2420_2304 with theory SB <- SBArray2420_2304.
clone SubByteArrayInit as SBI2560_32 with theory SB <- SBArray2560_32.
clone SubByteArrayInit as SBI2560_64 with theory SB <- SBArray2560_64.
clone SubByteArrayInit as SBI2560_384 with theory SB <- SBArray2560_384.
clone SubByteArrayInit as SBI2560_1664 with theory SB <- SBArray2560_1664.
clone SubByteArrayInit as SBI4096_1024 with theory SB <- SBArray4096_1024.
clone SubByteArrayInit as SBI16384_1024 with theory SB <- SBArray16384_1024.
clone SubByteArrayInit as SBI16384_4096 with theory SB <- SBArray16384_4096.

(* ---- assumed: the Keccak wrappers ---- *)
axiom __derive_commitment_hash_proof _commitment_hash _b_commitment_hash _message_representative _b_message_representative _encoded_commitment _b_encoded_commitment : (__derive_commitment_hash_spec _commitment_hash _b_commitment_hash _message_representative _b_message_representative _encoded_commitment _b_encoded_commitment).
axiom __derive_message_representative_proof _message_representative _b_message_representative _verification_key_hash _b_verification_key_hash _context_pointer _context_size _message_pointer _message_size : (__derive_message_representative_spec _message_representative _b_message_representative _verification_key_hash _b_verification_key_hash _context_pointer _context_size _message_pointer _message_size).
axiom _shake256_A128__A32_A2_proof _out _b_out _seed _b_seed _extra _b_extra : (_shake256_A128__A32_A2_spec _out _b_out _seed _b_seed _extra _b_extra).
axiom _shake256_A64__A128_proof _out _b_out _in _b_in : (_shake256_A64__A128_spec _out _b_out _in _b_in).
axiom hash_verification_key_proof _verification_key_hash _b_verification_key_hash _verification_key _b_verification_key : (hash_verification_key_spec _verification_key_hash _b_verification_key_hash _verification_key _b_verification_key).
axiom shake128_absorb_34_4x_proof _state _b_state _rho _b_rho _domain_separators _b_domain_separators : (shake128_absorb_34_4x_spec _state _b_state _rho _b_rho _domain_separators _b_domain_separators).
axiom shake128_squeezeblock4x_proof _state _b_state _h0 _b_h0 _h1 _b_h1 _h2 _b_h2 _h3 _b_h3 : (shake128_squeezeblock4x_spec _state _b_state _h0 _b_h0 _h1 _b_h1  _h2 _b_h2 _h3 _b_h3).
axiom shake256_absorb_66_4x_proof _state _b_state _rho_prime _b_rho_prime _starting_domain_separator : (shake256_absorb_66_4x_spec _state _b_state _rho_prime _b_rho_prime _starting_domain_separator).
axiom shake256_absorb_commitment_hash_proof _st _b_st _commitment_hash _b_commitment_hash : (shake256_absorb_commitment_hash_spec _st _b_st _commitment_hash _b_commitment_hash).
axiom shake256_squeezeblock_proof _st _b_st _block _b_block : (shake256_squeezeblock_spec _st _b_st _block _b_block).
axiom shake256_squeezeblock4x_proof _state _b_state _h0 _b_h0 _h1 _b_h1 _h2 _b_h2 _h3 _b_h3 : (shake256_squeezeblock4x_spec _state _b_state _h0 _b_h0 _h1 _b_h1  _h2 _b_h2 _h3 _b_h3).

lemma error_polynomial__encode_eta2_proof _encoded _b_encoded _polynomial _b_polynomial :
      (error_polynomial__encode_eta2_spec _encoded _b_encoded _polynomial
      _b_polynomial).
proof.
hint +safety.
rewrite /error_polynomial__encode_eta2_spec; proc.
conseq (_ :
     b_polynomial = BArray1024.init_arr (W8.of_int 255)
  ==> BArray96.is_init b_encoded 0 96
   /\ valid trace_error_polynomial__encode_eta2).
+ by move=> &hr />; rewrite -!(BI1024.is_init_full _ 1024) //.
do 2! (unroll for ^while).
by auto => /> *.
qed.

lemma error_polynomial__decode_eta2_proof _polynomial _b_polynomial _encoded _b_encoded :
      (error_polynomial__decode_eta2_spec _polynomial _b_polynomial _encoded
      _b_encoded).
proof.
hint +safety.
rewrite /error_polynomial__decode_eta2_spec; proc.
conseq (_ :
     b_encoded = BArray96.init_arr (W8.of_int 255)
  ==> BArray1024.is_init b_polynomial 0 (4 * 256)
   /\ valid trace_error_polynomial__decode_eta2).
+ by move=> &hr />; rewrite -!(BI96.is_init_full _ 96) //.
swap 4 1.
unroll for ^while.
cfold* ^eTA_BITS_MASK<-.
cfold* ^out_offset<-.
by auto => /> *.
qed.

lemma error_polynomial__encode_proof _encoded _b_encoded _polynomial _b_polynomial :
      (error_polynomial__encode_spec _encoded _b_encoded _polynomial
      _b_polynomial).
proof.
hint +safety.
rewrite /error_polynomial__encode_spec; proc.
conseq (_ :
     b_polynomial = BArray1024.init_arr (W8.of_int 255)
  ==> BArray96.is_init b_encoded 0 96
   /\ valid trace_error_polynomial__encode).
+ by move=> &hr />; rewrite -!(BI1024.is_init_full _ 1024) //.
auto; ecall (error_polynomial__encode_eta2_proof param_0 b_param param ((BArray1024.init_arr (W8.of_int 255)))).
by auto => /> *.
qed.

lemma error_polynomial__decode_proof _decoded _b_decoded _encoded _b_encoded :
      (error_polynomial__decode_spec _decoded _b_decoded _encoded _b_encoded).
proof.
hint +safety.
rewrite /error_polynomial__decode_spec; proc.
conseq (_ :
     b_encoded = BArray96.init_arr (W8.of_int 255)
  ==> BArray1024.is_init b_decoded 0 (4 * 256)
   /\ valid trace_error_polynomial__decode).
+ by move=> &hr />; rewrite -!(BI96.is_init_full _ 96) //.
auto; ecall (error_polynomial__decode_eta2_proof param_0 b_param param ((BArray96.init_arr (W8.of_int 255)))).
by auto => /> *.
qed.

lemma gamma1__coefficients_to_bytestream_bits18_proof _gamma1 _coefficients :
      (gamma1__coefficients_to_bytestream_bits18_spec _gamma1 _coefficients).
proof.
hint +safety.
rewrite /gamma1__coefficients_to_bytestream_bits18_spec; proc.
conseq (_ : _ ==> valid trace_gamma1__coefficients_to_bytestream_bits18).
by auto => /> *.
qed.

lemma gamma1____encode_polynomial_bits18_proof _output _b_output _polynomial _b_polynomial :
      (gamma1____encode_polynomial_bits18_spec _output _b_output _polynomial
      _b_polynomial).
proof.
hint +safety.
rewrite /gamma1____encode_polynomial_bits18_spec; proc.
conseq (_ :
     b_polynomial = BArray1024.init_arr (W8.of_int 255)
  ==> BArray576.is_init b_output 0 ((18 * 256) %/ 8)
   /\ valid trace_gamma1____encode_polynomial_bits18).
+ by move=> &hr />; rewrite -!(BI1024.is_init_full _ 1024) //.
swap 9 1.
do 2! (unroll for ^while).
cfold* ^output_offset<-.
auto; ecall (gamma1__coefficients_to_bytestream_bits18_proof param_2 param_1).
auto; ecall (gamma1__coefficients_to_bytestream_bits18_proof param_0 param).
auto; ecall (gamma1__coefficients_to_bytestream_bits18_proof param_0 param).
auto; ecall (gamma1__coefficients_to_bytestream_bits18_proof param_0 param).
auto; ecall (gamma1__coefficients_to_bytestream_bits18_proof param_0 param).
auto; ecall (gamma1__coefficients_to_bytestream_bits18_proof param_0 param).
auto; ecall (gamma1__coefficients_to_bytestream_bits18_proof param_0 param).
auto; ecall (gamma1__coefficients_to_bytestream_bits18_proof param_0 param).
auto; ecall (gamma1__coefficients_to_bytestream_bits18_proof param_0 param).
auto; ecall (gamma1__coefficients_to_bytestream_bits18_proof param_0 param).
auto; ecall (gamma1__coefficients_to_bytestream_bits18_proof param_0 param).
auto; ecall (gamma1__coefficients_to_bytestream_bits18_proof param_0 param).
auto; ecall (gamma1__coefficients_to_bytestream_bits18_proof param_0 param).
auto; ecall (gamma1__coefficients_to_bytestream_bits18_proof param_0 param).
auto; ecall (gamma1__coefficients_to_bytestream_bits18_proof param_0 param).
auto; ecall (gamma1__coefficients_to_bytestream_bits18_proof param_0 param).
auto; ecall (gamma1__coefficients_to_bytestream_bits18_proof param_0 param).
auto; ecall (gamma1__coefficients_to_bytestream_bits18_proof param_0 param).
auto; ecall (gamma1__coefficients_to_bytestream_bits18_proof param_0 param).
auto; ecall (gamma1__coefficients_to_bytestream_bits18_proof param_0 param).
auto; ecall (gamma1__coefficients_to_bytestream_bits18_proof param_0 param).
auto; ecall (gamma1__coefficients_to_bytestream_bits18_proof param_0 param).
auto; ecall (gamma1__coefficients_to_bytestream_bits18_proof param_0 param).
auto; ecall (gamma1__coefficients_to_bytestream_bits18_proof param_0 param).
auto; ecall (gamma1__coefficients_to_bytestream_bits18_proof param_0 param).
auto; ecall (gamma1__coefficients_to_bytestream_bits18_proof param_0 param).
auto; ecall (gamma1__coefficients_to_bytestream_bits18_proof param_0 param).
auto; ecall (gamma1__coefficients_to_bytestream_bits18_proof param_0 param).
auto; ecall (gamma1__coefficients_to_bytestream_bits18_proof param_0 param).
auto; ecall (gamma1__coefficients_to_bytestream_bits18_proof param_0 param).
auto; ecall (gamma1__coefficients_to_bytestream_bits18_proof param_0 param).
auto; ecall (gamma1__coefficients_to_bytestream_bits18_proof param_0 param).
by auto => /> *.
qed.

lemma gamma1____decode_to_polynomial_bits18_proof _polynomial _b_polynomial _bytes _b_bytes :
      (gamma1____decode_to_polynomial_bits18_spec _polynomial _b_polynomial
      _bytes _b_bytes).
proof.
hint +safety.
rewrite /gamma1____decode_to_polynomial_bits18_spec; proc.
conseq (_ :
     b_bytes = BArray576.init_arr (W8.of_int 255)
  ==> BArray1024.is_init b_polynomial 0 (4 * 256)
   /\ valid trace_gamma1____decode_to_polynomial_bits18).
+ by move=> &hr />; rewrite -!(BI576.is_init_full _ 576) //.
unroll for ^while.
cfold* ^input_offset<-.
by auto => /> *.
qed.

lemma gamma1____encode_polynomial_proof _output _b_output _polynomial _b_polynomial :
      (gamma1____encode_polynomial_spec _output _b_output _polynomial
      _b_polynomial).
proof.
hint +safety.
rewrite /gamma1____encode_polynomial_spec; proc.
conseq (_ :
     b_polynomial = BArray1024.init_arr (W8.of_int 255)
  ==> BArray576.is_init b_output 0 ((18 * 256) %/ 8)
   /\ valid trace_gamma1____encode_polynomial).
+ by move=> &hr />; rewrite -!(BI1024.is_init_full _ 1024) //.
auto; ecall (gamma1____encode_polynomial_bits18_proof param_0 b_param param ((BArray1024.init_arr (W8.of_int 255)))).
by auto => /> *.
qed.

lemma gamma1____decode_to_polynomial_proof _polynomial _b_polynomial _bytes _b_bytes :
      (gamma1____decode_to_polynomial_spec _polynomial _b_polynomial 
      _bytes _b_bytes).
proof.
hint +safety.
rewrite /gamma1____decode_to_polynomial_spec; proc.
conseq (_ :
     b_bytes = BArray576.init_arr (W8.of_int 255)
  ==> BArray1024.is_init b_polynomial 0 (4 * 256)
   /\ valid trace_gamma1____decode_to_polynomial).
+ by move=> &hr />; rewrite -!(BI576.is_init_full _ 576) //.
auto; ecall (gamma1____decode_to_polynomial_bits18_proof param_0 b_param param ((BArray576.init_arr (W8.of_int 255)))).
by auto => /> *.
qed.

lemma gamma1____encode_proof _encoded _b_encoded _decoded _b_decoded :
      (gamma1____encode_spec _encoded _b_encoded _decoded _b_decoded).
proof.
hint +safety.
rewrite /gamma1____encode_spec; proc.
conseq (_ :
     b_decoded = BArray4096.init_arr (W8.of_int 255)
  ==> BArray2304.is_init b_encoded 0 (4 * ((18 * 256) %/ 8))
   /\ valid trace_gamma1____encode).
+ by move=> &hr />; rewrite -!(BI4096.is_init_full _ 4096) //.
unroll for ^while.
auto; ecall (gamma1____encode_polynomial_proof param_0 b_param_0 param b_param).
auto; ecall (gamma1____encode_polynomial_proof param_0 b_param_0 param b_param).
auto; ecall (gamma1____encode_polynomial_proof param_0 b_param_0 param b_param).
auto; ecall (gamma1____encode_polynomial_proof param_0 b_param_0 param b_param).
by auto => /> *.
qed.

lemma gamma1____decode_proof _decoded _b_decoded _encoded _b_encoded :
      (gamma1____decode_spec _decoded _b_decoded _encoded _b_encoded).
proof.
hint +safety.
rewrite /gamma1____decode_spec; proc.
conseq (_ :
     b_encoded = BArray2304.init_arr (W8.of_int 255)
  ==> BArray4096.is_init b_decoded 0 (4 * (4 * 256))
   /\ valid trace_gamma1____decode).
+ by move=> &hr />; rewrite -!(BI2304.is_init_full _ 2304) //.
unroll for ^while.
auto; ecall (gamma1____decode_to_polynomial_proof param_0 b_param_0 param b_param).
auto; ecall (gamma1____decode_to_polynomial_proof param_0 b_param_0 param b_param).
auto; ecall (gamma1____decode_to_polynomial_proof param_0 b_param_0 param b_param).
auto; ecall (gamma1____decode_to_polynomial_proof param_0 b_param_0 param b_param).
by auto => /> *.
qed.

lemma polynomial__decompose_gamma2_88_proof _lows _b_lows _highs _b_highs _polynomial _b_polynomial :
      (polynomial__decompose_gamma2_88_spec _lows _b_lows _highs _b_highs
      _polynomial _b_polynomial).
proof.
hint +safety.
rewrite /polynomial__decompose_gamma2_88_spec; proc.
conseq (_ :
     b_polynomial = BArray1024.init_arr (W8.of_int 255)
  ==> BArray1024.is_init b_lows 0 (4 * 256)
   /\ BArray1024.is_init b_highs 0 (4 * 256)
   /\ valid trace_polynomial__decompose_gamma2_88).
+ by move=> &hr />; rewrite -!(BI1024.is_init_full _ 1024) //.
+ by move=> />.
unroll for ^while.
by auto => /> *.
qed.

lemma polynomial__use_hints_gamma2_88_proof _commitment _b_commitment _hint_polynomial _b_hint_polynomial :
      (polynomial__use_hints_gamma2_88_spec _commitment _b_commitment
      _hint_polynomial _b_hint_polynomial).
proof.
hint +safety.
rewrite /polynomial__use_hints_gamma2_88_spec; proc.
conseq (_ :
     b_hint_polynomial = BArray1024.init_arr (W8.of_int 255)
  /\ b_commitment = BArray1024.init_arr (W8.of_int 255)
  ==> BArray1024.is_init b_commitment 0 1024
   /\ valid trace_polynomial__use_hints_gamma2_88).
+ by move=> &hr />; rewrite -!(BI1024.is_init_full _ 1024) //.
unroll for ^while.
auto; ecall (polynomial__decompose_gamma2_88_proof param_1 b_param_0 param_0 b_param param ((BArray1024.init_arr (W8.of_int 255)))).
by auto => /> *.
qed.

lemma polynomial__decompose_proof _lows _b_lows _highs _b_highs _polynomial _b_polynomial :
      (polynomial__decompose_spec _lows _b_lows _highs _b_highs _polynomial
      _b_polynomial).
proof.
hint +safety.
rewrite /polynomial__decompose_spec; proc.
conseq (_ :
     b_polynomial = BArray1024.init_arr (W8.of_int 255)
  ==> BArray1024.is_init b_lows 0 (4 * 256)
   /\ BArray1024.is_init b_highs 0 (4 * 256)
   /\ valid trace_polynomial__decompose).
+ by move=> &hr />; rewrite -!(BI1024.is_init_full _ 1024) //.
+ by move=> />.
auto; ecall (polynomial__decompose_gamma2_88_proof param_1 b_param_0 param_0 b_param param ((BArray1024.init_arr (W8.of_int 255)))).
by auto => /> *.
qed.

lemma polynomial__use_hints_proof _commitment _b_commitment _hint_polynomial _b_hint_polynomial :
      (polynomial__use_hints_spec _commitment _b_commitment _hint_polynomial
      _b_hint_polynomial).
proof.
hint +safety.
rewrite /polynomial__use_hints_spec; proc.
conseq (_ :
     b_hint_polynomial = BArray1024.init_arr (W8.of_int 255)
  /\ b_commitment = BArray1024.init_arr (W8.of_int 255)
  ==> BArray1024.is_init b_commitment 0 1024
   /\ valid trace_polynomial__use_hints).
+ by move=> &hr />; rewrite -!(BI1024.is_init_full _ 1024) //.
auto; ecall (polynomial__use_hints_gamma2_88_proof param_0 ((BArray1024.init_arr (W8.of_int 255))) param ((BArray1024.init_arr (W8.of_int 255)))).
by auto => /> *.
qed.

lemma polynomial____make_hint_proof _hints _b_hints _low_coefficients _b_low_coefficients
    _high_coefficients _b_high_coefficients :
  polynomial____make_hint_spec _hints _b_hints _low_coefficients _b_low_coefficients
    _high_coefficients _b_high_coefficients.
proof.
hint +safety.
rewrite /polynomial____make_hint_spec; proc.
conseq (_ :
     b_low_coefficients = BArray1024.init_arr (W8.of_int 255)
  /\ b_high_coefficients = BArray1024.init_arr (W8.of_int 255)
  ==> 0 <= weight
   /\ weight <= 18446744073709551615
   /\ 0 <= 256
   /\ 256 <= 18446744073709551615
   /\ BArray1024.is_init b_hints 0 (4 * 256)
   /\ weight <= 256
   /\ valid trace_polynomial____make_hint).
+ by move=> &hr />; rewrite -!(BI1024.is_init_full _ 1024) //.
+ by move=> />.
(* the hint weight grows by at most one per coefficient: eight per block *)
while (b_low_coefficients = BArray1024.init_arr (W8.of_int 255)
    /\ b_high_coefficients = BArray1024.init_arr (W8.of_int 255)
    /\ 0 <= offset <= 1024 /\ offset %% 32 = 0 /\ 0 <= weight /\ 4 * weight <= offset
    /\ BArray1024.is_init b_hints 0 offset /\ valid trace_polynomial____make_hint).
+ auto => /> &hr h0 h1024 hmod hw0 hw hinit hvalid hlt.
  rewrite BI1024.is_init_set256d_in 1,2:/# /= hinit //=.
  have h32 : offset{hr} + 32 <= 1024 by smt().
  have hm : (offset{hr} + 32) %% 32 = 0 by smt().
  smt(to_uint_popcnt64_movemask8).
auto => /> b_hints0 offset0 tr w0 hge h0 h1024 hmod hw0 hw hinit hvalid.
have := hinit; have -> : offset0 = 1024 by smt().
by move=> -> /=; smt().
qed.

lemma polynomial____power2round_proof _highbits _b_highbits _lowbits _b_lowbits _polynomial _b_polynomial :
      (polynomial____power2round_spec _highbits _b_highbits _lowbits
      _b_lowbits _polynomial _b_polynomial).
proof.
hint +safety.
rewrite /polynomial____power2round_spec; proc.
conseq (_ :
     b_polynomial = BArray1024.init_arr (W8.of_int 255)
  ==> BArray1024.is_init b_highbits 0 (4 * 256)
   /\ BArray1024.is_init b_lowbits 0 (4 * 256)
   /\ valid trace_polynomial____power2round).
+ by move=> &hr />; rewrite -!(BI1024.is_init_full _ 1024) //.
+ by move=> />.
unroll for ^while.
by auto => /> *.
qed.

lemma montgomery_multiply_and_reduce_proof _lhs _rhs :
      (montgomery_multiply_and_reduce_spec _lhs _rhs).
proof.
hint +safety.
rewrite /montgomery_multiply_and_reduce_spec; proc.
conseq (_ : _ ==> valid trace_montgomery_multiply_and_reduce).
by auto => /> *.
qed.

lemma polynomial__pointwise_montgomery_multiply_and_reduce_proof _product _b_product _lhs _b_lhs
    _rhs _b_rhs :
  polynomial__pointwise_montgomery_multiply_and_reduce_spec _product _b_product _lhs _b_lhs
    _rhs _b_rhs.
proof.
hint +safety.
rewrite /polynomial__pointwise_montgomery_multiply_and_reduce_spec; proc.
conseq (_ :
     b_lhs = BArray1024.init_arr (W8.of_int 255)
  /\ b_rhs = BArray1024.init_arr (W8.of_int 255)
  ==> BArray1024.is_init b_product 0 (4 * 256)
   /\ valid trace_polynomial__pointwise_montgomery_multiply_and_reduce).
+ by move=> &hr />; rewrite -!(BI1024.is_init_full _ 1024) //.
(* two blocks of eight coefficients per iteration *)
while (b_lhs = BArray1024.init_arr (W8.of_int 255) /\ b_rhs = BArray1024.init_arr (W8.of_int 255)
    /\ 0 <= offset <= 1024 /\ offset %% 64 = 0 /\ BArray1024.is_init b_product 0 offset
    /\ valid trace_polynomial__pointwise_montgomery_multiply_and_reduce).
+ auto; ecall (montgomery_multiply_and_reduce_proof param_2 param_1).
  auto; ecall (montgomery_multiply_and_reduce_proof param_0 param).
  auto => /> &hr h0 h1024 hmod hinit hvalid hlt r0 hv0 r1 hv1.
  rewrite BI1024.is_init_set256d_in 1,2:/# /= BI1024.is_init_set256d_in 1,2:/# /= hinit /=.
  smt().
auto => /> b_product0 offset0 tr hge h0 h1024 hmod hinit hvalid.
by have := hinit; have -> : offset0 = 1024 by smt().
qed.

lemma polynomial__conditionally_add_modulus_proof _polynomial _b_polynomial :
      (polynomial__conditionally_add_modulus_spec _polynomial _b_polynomial).
proof.
hint +safety.
rewrite /polynomial__conditionally_add_modulus_spec; proc.
conseq (_ :
     b_polynomial = BArray1024.init_arr (W8.of_int 255)
  ==> BArray1024.is_init b_polynomial 0 1024
   /\ valid trace_polynomial__conditionally_add_modulus).
+ by move=> &hr />; rewrite -!(BI1024.is_init_full _ 1024) //.
unroll for ^while.
by auto => /> *.
qed.

lemma polynomial__reduce32_proof _polynomial _b_polynomial :
      (polynomial__reduce32_spec _polynomial _b_polynomial).
proof.
hint +safety.
rewrite /polynomial__reduce32_spec; proc.
conseq (_ :
     b_polynomial = BArray1024.init_arr (W8.of_int 255)
  ==> BArray1024.is_init b_polynomial 0 1024
   /\ valid trace_polynomial__reduce32).
+ by move=> &hr />; rewrite -!(BI1024.is_init_full _ 1024) //.
unroll for ^while.
by auto => /> *.
qed.

lemma polynomial____ct_butterfly_proof _a _b _zetas :
      (polynomial____ct_butterfly_spec _a _b _zetas).
proof.
hint +safety.
rewrite /polynomial____ct_butterfly_spec; proc.
conseq (_ : _ ==> valid trace_polynomial____ct_butterfly).
auto; ecall (montgomery_multiply_and_reduce_proof param_0 param).
by auto => /> *.
qed.

lemma polynomial____ct_butterfly_8_proof _lhs _rhs _zetas :
      (polynomial____ct_butterfly_8_spec _lhs _rhs _zetas).
proof.
hint +safety.
rewrite /polynomial____ct_butterfly_8_spec; proc.
conseq (_ : _ ==> valid trace_polynomial____ct_butterfly_8).
auto; ecall (montgomery_multiply_and_reduce_proof param_0 param).
by auto => /> *.
qed.

lemma polynomial____ct_butterfly_4_proof _lhs _rhs _zetas :
      (polynomial____ct_butterfly_4_spec _lhs _rhs _zetas).
proof.
hint +safety.
rewrite /polynomial____ct_butterfly_4_spec; proc.
conseq (_ : _ ==> valid trace_polynomial____ct_butterfly_4).
auto; ecall (montgomery_multiply_and_reduce_proof param_0 param).
by auto => /> *.
qed.

lemma polynomial____ct_butterfly_2_proof _lhs _rhs _zetas :
      (polynomial____ct_butterfly_2_spec _lhs _rhs _zetas).
proof.
hint +safety.
rewrite /polynomial____ct_butterfly_2_spec; proc.
conseq (_ : _ ==> valid trace_polynomial____ct_butterfly_2).
auto; ecall (polynomial____ct_butterfly_4_proof param_1 param_0 param).
by auto => /> *.
qed.

lemma polynomial____ntt_layers_7_6_5_proof _polynomial _b_polynomial _j :
      (polynomial____ntt_layers_7_6_5_spec _polynomial _b_polynomial _j).
proof.
hint +safety.
rewrite /polynomial____ntt_layers_7_6_5_spec; proc.
conseq (_ :
     0 <= j
  /\ j <= 3
  /\ b_polynomial = BArray1024.init_arr (W8.of_int 255)
  ==> BArray1024.is_init b_polynomial 0 (4 * 256)
   /\ valid trace_polynomial____ntt_layers_7_6_5).
+ by move=> &hr />; rewrite -!(BI1024.is_init_full _ 1024) //.
auto; ecall (polynomial____ct_butterfly_proof param_34 param_33 param_32).
auto; ecall (polynomial____ct_butterfly_proof param_31 param_30 param_29).
auto; ecall (polynomial____ct_butterfly_proof param_28 param_27 param_26).
auto; ecall (polynomial____ct_butterfly_proof param_25 param_24 param_23).
auto; ecall (polynomial____ct_butterfly_proof param_22 param_21 param_20).
auto; ecall (polynomial____ct_butterfly_proof param_19 param_18 param_17).
auto; ecall (polynomial____ct_butterfly_proof param_16 param_15 param_14).
auto; ecall (polynomial____ct_butterfly_proof param_13 param_12 param_11).
auto; ecall (polynomial____ct_butterfly_proof param_10 param_9 param_8).
auto; ecall (polynomial____ct_butterfly_proof param_7 param_6 param_5).
auto; ecall (polynomial____ct_butterfly_proof param_4 param_3 param_2).
auto; ecall (polynomial____ct_butterfly_proof param_1 param_0 param).
case (j = 0); first by auto => /> *.
case (j = 1); first by auto => /> *.
case (j = 2); first by auto => /> *.
conseq (_ : j = 3 /\ b_polynomial = BArray1024.init_arr (W8.of_int 255) ==> _).
+ by move=> &hr /#.
by auto => /> *.
qed.

lemma polynomial____ntt_layers_4_to_0_proof _polynomial _b_polynomial _g :
      (polynomial____ntt_layers_4_to_0_spec _polynomial _b_polynomial _g).
proof.
hint +safety.
rewrite /polynomial____ntt_layers_4_to_0_spec; proc.
conseq (_ :
     0 <= g
  /\ g <= 3
  /\ b_polynomial = BArray1024.init_arr (W8.of_int 255)
  ==> BArray1024.is_init b_polynomial 0 (4 * 256)
   /\ valid trace_polynomial____ntt_layers_4_to_0).
+ by move=> &hr />; rewrite -!(BI1024.is_init_full _ 1024) //.
auto; ecall (polynomial____ct_butterfly_2_proof param_58 param_57 param_56).
auto; ecall (polynomial____ct_butterfly_2_proof param_55 param_54 param_53).
auto; ecall (polynomial____ct_butterfly_2_proof param_52 param_51 param_50).
auto; ecall (polynomial____ct_butterfly_2_proof param_49 param_48 param_47).
auto; ecall (polynomial____ct_butterfly_4_proof param_46 param_45 param_44).
auto; ecall (polynomial____ct_butterfly_4_proof param_43 param_42 param_41).
auto; ecall (polynomial____ct_butterfly_4_proof param_40 param_39 param_38).
auto; ecall (polynomial____ct_butterfly_4_proof param_37 param_36 param_35).
auto; ecall (polynomial____ct_butterfly_8_proof param_34 param_33 param_32).
auto; ecall (polynomial____ct_butterfly_8_proof param_31 param_30 param_29).
auto; ecall (polynomial____ct_butterfly_8_proof param_28 param_27 param_26).
auto; ecall (polynomial____ct_butterfly_8_proof param_25 param_24 param_23).
auto; ecall (polynomial____ct_butterfly_proof param_22 param_21 param_20).
auto; ecall (polynomial____ct_butterfly_proof param_19 param_18 param_17).
auto; ecall (polynomial____ct_butterfly_proof param_16 param_15 param_14).
auto; ecall (polynomial____ct_butterfly_proof param_13 param_12 param_11).
auto; ecall (polynomial____ct_butterfly_proof param_10 param_9 param_8).
auto; ecall (polynomial____ct_butterfly_proof param_7 param_6 param_5).
auto; ecall (polynomial____ct_butterfly_proof param_4 param_3 param_2).
auto; ecall (polynomial____ct_butterfly_proof param_1 param_0 param).
case (g = 0); first by auto => /> *.
case (g = 1); first by auto => /> *.
case (g = 2); first by auto => /> *.
conseq (_ : g = 3 /\ b_polynomial = BArray1024.init_arr (W8.of_int 255) ==> _).
+ by move=> &hr /#.
by auto => /> *.
qed.

lemma polynomial__ntt_proof _polynomial _b_polynomial :
      (polynomial__ntt_spec _polynomial _b_polynomial).
proof.
hint +safety.
rewrite /polynomial__ntt_spec; proc.
conseq (_ :
     b_polynomial = BArray1024.init_arr (W8.of_int 255)
  ==> BArray1024.is_init b_polynomial 0 1024
   /\ valid trace_polynomial__ntt).
+ by move=> &hr />; rewrite -!(BI1024.is_init_full _ 1024) //.
do 2! (unroll for ^while).
auto; ecall (polynomial____ntt_layers_4_to_0_proof param_2 ((BArray1024.init_arr (W8.of_int 255))) param_1).
auto; ecall (polynomial____ntt_layers_4_to_0_proof param_2 ((BArray1024.init_arr (W8.of_int 255))) param_1).
auto; ecall (polynomial____ntt_layers_4_to_0_proof param_2 ((BArray1024.init_arr (W8.of_int 255))) param_1).
auto; ecall (polynomial____ntt_layers_4_to_0_proof param_2 ((BArray1024.init_arr (W8.of_int 255))) param_1).
auto; ecall (polynomial____ntt_layers_7_6_5_proof param_0 ((BArray1024.init_arr (W8.of_int 255))) param).
auto; ecall (polynomial____ntt_layers_7_6_5_proof param_0 ((BArray1024.init_arr (W8.of_int 255))) param).
auto; ecall (polynomial____ntt_layers_7_6_5_proof param_0 ((BArray1024.init_arr (W8.of_int 255))) param).
auto; ecall (polynomial____ntt_layers_7_6_5_proof param_0 ((BArray1024.init_arr (W8.of_int 255))) param).
by auto => /> *.
qed.

lemma polynomial____gs_butterfly_proof _a _b _zetas :
      (polynomial____gs_butterfly_spec _a _b _zetas).
proof.
hint +safety.
rewrite /polynomial____gs_butterfly_spec; proc.
conseq (_ : _ ==> valid trace_polynomial____gs_butterfly).
auto; ecall (montgomery_multiply_and_reduce_proof param_0 param).
by auto => /> *.
qed.

lemma polynomial____gs_butterfly_4_proof _lhs _rhs _zetas :
      (polynomial____gs_butterfly_4_spec _lhs _rhs _zetas).
proof.
hint +safety.
rewrite /polynomial____gs_butterfly_4_spec; proc.
conseq (_ : _ ==> valid trace_polynomial____gs_butterfly_4).
auto; ecall (montgomery_multiply_and_reduce_proof param_0 param).
by auto => /> *.
qed.

lemma polynomial____gs_butterfly_2_proof _lhs _rhs _zetas :
      (polynomial____gs_butterfly_2_spec _lhs _rhs _zetas).
proof.
hint +safety.
rewrite /polynomial____gs_butterfly_2_spec; proc.
conseq (_ : _ ==> valid trace_polynomial____gs_butterfly_2).
auto; ecall (polynomial____gs_butterfly_4_proof param_1 param_0 param).
by auto => /> *.
qed.

lemma polynomial____gs_butterfly_8_proof _lhs _rhs _zetas :
      (polynomial____gs_butterfly_8_spec _lhs _rhs _zetas).
proof.
hint +safety.
rewrite /polynomial____gs_butterfly_8_spec; proc.
conseq (_ : _ ==> valid trace_polynomial____gs_butterfly_8).
auto; ecall (montgomery_multiply_and_reduce_proof param_0 param).
by auto => /> *.
qed.

lemma polynomial____gs_butterfly_scaled_proof _a _b _zetas_f _f :
      (polynomial____gs_butterfly_scaled_spec _a _b _zetas_f _f).
proof.
hint +safety.
rewrite /polynomial____gs_butterfly_scaled_spec; proc.
conseq (_ : _ ==> valid trace_polynomial____gs_butterfly_scaled).
auto; ecall (montgomery_multiply_and_reduce_proof param_2 param_1).
auto; ecall (montgomery_multiply_and_reduce_proof param_0 param).
by auto => /> *.
qed.

lemma polynomial____broadcast_zeta_proof _zeta :
      (polynomial____broadcast_zeta_spec _zeta).
proof.
hint +safety.
rewrite /polynomial____broadcast_zeta_spec; proc.
conseq (_ : _ ==> valid trace_polynomial____broadcast_zeta).
by auto => /> *.
qed.

lemma polynomial____invert_ntt_layers_0_to_4_proof _polynomial _b_polynomial _g :
      (polynomial____invert_ntt_layers_0_to_4_spec _polynomial _b_polynomial
      _g).
proof.
hint +safety.
rewrite /polynomial____invert_ntt_layers_0_to_4_spec; proc.
conseq (_ :
     0 <= g
  /\ g <= 3
  /\ b_polynomial = BArray1024.init_arr (W8.of_int 255)
  ==> BArray1024.is_init b_polynomial 0 (4 * 256)
   /\ valid trace_polynomial____invert_ntt_layers_0_to_4).
+ by move=> &hr />; rewrite -!(BI1024.is_init_full _ 1024) //.
auto; ecall (polynomial____gs_butterfly_proof param_64 param_63 param_62).
auto; ecall (polynomial____gs_butterfly_proof param_61 param_60 param_59).
auto; ecall (polynomial____broadcast_zeta_proof param_58).
auto; ecall (polynomial____gs_butterfly_proof param_57 param_56 param_55).
auto; ecall (polynomial____gs_butterfly_proof param_54 param_53 param_52).
auto; ecall (polynomial____broadcast_zeta_proof param_51).
auto; ecall (polynomial____gs_butterfly_proof param_50 param_49 param_48).
auto; ecall (polynomial____broadcast_zeta_proof param_47).
auto; ecall (polynomial____gs_butterfly_proof param_46 param_45 param_44).
auto; ecall (polynomial____broadcast_zeta_proof param_43).
auto; ecall (polynomial____gs_butterfly_proof param_42 param_41 param_40).
auto; ecall (polynomial____broadcast_zeta_proof param_39).
auto; ecall (polynomial____gs_butterfly_proof param_38 param_37 param_36).
auto; ecall (polynomial____broadcast_zeta_proof param_35).
auto; ecall (polynomial____gs_butterfly_8_proof param_34 param_33 param_32).
auto; ecall (polynomial____gs_butterfly_8_proof param_31 param_30 param_29).
auto; ecall (polynomial____gs_butterfly_8_proof param_28 param_27 param_26).
auto; ecall (polynomial____gs_butterfly_8_proof param_25 param_24 param_23).
auto; ecall (polynomial____gs_butterfly_4_proof param_22 param_21 param_20).
auto; ecall (polynomial____gs_butterfly_4_proof param_19 param_18 param_17).
auto; ecall (polynomial____gs_butterfly_4_proof param_16 param_15 param_14).
auto; ecall (polynomial____gs_butterfly_4_proof param_13 param_12 param_11).
auto; ecall (polynomial____gs_butterfly_2_proof param_10 param_9 param_8).
auto; ecall (polynomial____gs_butterfly_2_proof param_7 param_6 param_5).
auto; ecall (polynomial____gs_butterfly_2_proof param_4 param_3 param_2).
auto; ecall (polynomial____gs_butterfly_2_proof param_1 param_0 param).
case (g = 0); first by auto => /> *.
case (g = 1); first by auto => /> *.
case (g = 2); first by auto => /> *.
conseq (_ : g = 3 /\ b_polynomial = BArray1024.init_arr (W8.of_int 255) ==> _).
+ by move=> &hr /#.
by auto => /> *.
qed.

lemma polynomial____invert_ntt_layers_5_6_7_proof _polynomial _b_polynomial _j :
      (polynomial____invert_ntt_layers_5_6_7_spec _polynomial _b_polynomial
      _j).
proof.
hint +safety.
rewrite /polynomial____invert_ntt_layers_5_6_7_spec; proc.
conseq (_ :
     0 <= j
  /\ j <= 3
  /\ b_polynomial = BArray1024.init_arr (W8.of_int 255)
  ==> BArray1024.is_init b_polynomial 0 (4 * 256)
   /\ valid trace_polynomial____invert_ntt_layers_5_6_7).
+ by move=> &hr />; rewrite -!(BI1024.is_init_full _ 1024) //.
auto; ecall (polynomial____gs_butterfly_scaled_proof param_46 param_45 param_44 param_43).
auto; ecall (polynomial____gs_butterfly_scaled_proof param_42 param_41 param_40 param_39).
auto; ecall (polynomial____gs_butterfly_scaled_proof param_38 param_37 param_36 param_35).
auto; ecall (polynomial____gs_butterfly_scaled_proof param_34 param_33 param_32 param_31).
auto; ecall (polynomial____broadcast_zeta_proof param_30).
auto; ecall (polynomial____broadcast_zeta_proof param_29).
auto; ecall (polynomial____gs_butterfly_proof param_28 param_27 param_26).
auto; ecall (polynomial____gs_butterfly_proof param_25 param_24 param_23).
auto; ecall (polynomial____broadcast_zeta_proof param_22).
auto; ecall (polynomial____gs_butterfly_proof param_21 param_20 param_19).
auto; ecall (polynomial____gs_butterfly_proof param_18 param_17 param_16).
auto; ecall (polynomial____broadcast_zeta_proof param_15).
auto; ecall (polynomial____gs_butterfly_proof param_14 param_13 param_12).
auto; ecall (polynomial____broadcast_zeta_proof param_11).
auto; ecall (polynomial____gs_butterfly_proof param_10 param_9 param_8).
auto; ecall (polynomial____broadcast_zeta_proof param_7).
auto; ecall (polynomial____gs_butterfly_proof param_6 param_5 param_4).
auto; ecall (polynomial____broadcast_zeta_proof param_3).
auto; ecall (polynomial____gs_butterfly_proof param_2 param_1 param_0).
auto; ecall (polynomial____broadcast_zeta_proof param).
case (j = 0); first by auto => /> *.
case (j = 1); first by auto => /> *.
case (j = 2); first by auto => /> *.
conseq (_ : j = 3 /\ b_polynomial = BArray1024.init_arr (W8.of_int 255) ==> _).
+ by move=> &hr /#.
by auto => /> *.
qed.

lemma polynomial__invert_ntt_montgomery_proof _polynomial _b_polynomial :
      (polynomial__invert_ntt_montgomery_spec _polynomial _b_polynomial).
proof.
hint +safety.
rewrite /polynomial__invert_ntt_montgomery_spec; proc.
conseq (_ :
     b_polynomial = BArray1024.init_arr (W8.of_int 255)
  ==> BArray1024.is_init b_polynomial 0 1024
   /\ valid trace_polynomial__invert_ntt_montgomery).
+ by move=> &hr />; rewrite -!(BI1024.is_init_full _ 1024) //.
do 2! (unroll for ^while).
auto; ecall (polynomial____invert_ntt_layers_5_6_7_proof param_2 ((BArray1024.init_arr (W8.of_int 255))) param_1).
auto; ecall (polynomial____invert_ntt_layers_5_6_7_proof param_2 ((BArray1024.init_arr (W8.of_int 255))) param_1).
auto; ecall (polynomial____invert_ntt_layers_5_6_7_proof param_2 ((BArray1024.init_arr (W8.of_int 255))) param_1).
auto; ecall (polynomial____invert_ntt_layers_5_6_7_proof param_2 ((BArray1024.init_arr (W8.of_int 255))) param_1).
auto; ecall (polynomial____invert_ntt_layers_0_to_4_proof param_0 ((BArray1024.init_arr (W8.of_int 255))) param).
auto; ecall (polynomial____invert_ntt_layers_0_to_4_proof param_0 ((BArray1024.init_arr (W8.of_int 255))) param).
auto; ecall (polynomial____invert_ntt_layers_0_to_4_proof param_0 ((BArray1024.init_arr (W8.of_int 255))) param).
auto; ecall (polynomial____invert_ntt_layers_0_to_4_proof param_0 ((BArray1024.init_arr (W8.of_int 255))) param).
by auto => /> *.
qed.

lemma matrix_A____bytestream_to_potential_coefficients_proof _bytestream :
      (matrix_A____bytestream_to_potential_coefficients_spec _bytestream).
proof.
hint +safety.
rewrite /matrix_A____bytestream_to_potential_coefficients_spec; proc.
conseq (_ : _ ==> valid trace_matrix_A____bytestream_to_potential_coefficients).
by auto => /> *.
qed.

lemma matrix_A__rejection_sample_multiple_blocks_proof _polynomial _b_polynomial _randombytes
    _b_randombytes :
  matrix_A__rejection_sample_multiple_blocks_spec _polynomial _b_polynomial _randombytes
    _b_randombytes.
proof.
hint +safety.
rewrite /matrix_A__rejection_sample_multiple_blocks_spec; proc.
conseq (_ :
     b_randombytes = BArray848.init_arr (W8.of_int 255)
  ==> BArray1024.is_init b_polynomial 0 (W64.to_uint ((W64.of_int 4) * filled))
   /\ filled \ule (W64.of_int 256)
   /\ valid trace_matrix_A__rejection_sample_multiple_blocks).
+ by move=> &hr />; rewrite -!(BI848.is_init_full _ 848) //.
+ by move=> />.
have h01 : W64.zero <> W64.one by rewrite W64.to_uint_eq.
(* second phase: one candidate coefficient per three bytes *)
while (b_randombytes = BArray848.init_arr (W8.of_int 255)
    /\ to_uint filled <= 256 /\ BArray1024.is_init b_polynomial 0 (4 * to_uint filled)
    /\ to_uint input_offset <= 840
    /\ condition_loop = (to_uint filled < 256 /\ to_uint input_offset < 838)
    /\ valid trace_matrix_A__rejection_sample_multiple_blocks).
+ auto => /> &hr hle hinit hio hvalid hlt hlt2.
  have hf0 := W64.to_uint_cmp filled{hr}; have hi0 := W64.to_uint_cmp input_offset{hr}.
  have hi1 : to_uint (input_offset{hr} + W64.one) = to_uint input_offset{hr} + 1.
  + by rewrite W64.to_uintD_small /= /#.
  have hi2 : to_uint (input_offset{hr} + W64.of_int 2) = to_uint input_offset{hr} + 2.
  + by rewrite W64.to_uintD_small W64.of_uintK /= /#.
  have hi3 : to_uint (input_offset{hr} + W64.of_int 3) = to_uint input_offset{hr} + 3.
  + by rewrite W64.to_uintD_small W64.of_uintK /= /#.
  have hf1 : to_uint (filled{hr} + W64.one) = to_uint filled{hr} + 1.
  + by rewrite W64.to_uintD_small /= /#.
  have hs : BArray1024.is_init
      (BArray1024.set32d b_polynomial{hr} (to_uint filled{hr} * 4) (W32.of_int 4294967295))
      0 (4 * (to_uint filled{hr} + 1)).
  + by rewrite BI1024.is_init_set32d_in 1,2:/# /=; smt(BI1024.is_init_le0).
  rewrite ?W64.uleE ?W64.ultE hi1 hi2 hi3 hf1 /=.
  smt().
(* first phase: eight candidates per 24 bytes, the good ones packed by a
   shuffle, at most four per half *)
wp.
while (b_randombytes = BArray848.init_arr (W8.of_int 255)
    /\ to_uint bytes_filled <= 1024 /\ to_uint bytes_filled %% 4 = 0
    /\ BArray1024.is_init b_polynomial 0 (to_uint bytes_filled)
    /\ to_uint input_offset %% 24 = 0 /\ to_uint input_offset <= 840
    /\ condition_loop = (to_uint bytes_filled < 992 /\ to_uint input_offset < 840)
    /\ valid trace_matrix_A__rejection_sample_multiple_blocks).
+ auto; ecall (matrix_A____bytestream_to_potential_coefficients_proof param).
  auto => /> &hr hle hmod hinit himod hio hvalid hlt hlt2 r hv.
  rewrite /SLH64.protect_64.
  (* the vector terms are abstracted: only their bounds matter *)
  have hg : to_uint (zeroextu64 (MOVEMASK_8u32 (VPCMPGT_8u32 modulus{hr} r.`1))) < 256.
  + rewrite /zeroextu64 W64.of_uintK.
    by have := to_uint_movemask8 (VPCMPGT_8u32 modulus{hr} r.`1);
       have := W32.to_uint_cmp (MOVEMASK_8u32 (VPCMPGT_8u32 modulus{hr} r.`1)); smt().
  move: (zeroextu64 (MOVEMASK_8u32 (VPCMPGT_8u32 modulus{hr} r.`1))) hg => g hg.
  have hgl : to_uint (g `&` W64.of_int 15) < 16.
  + have -> : W64.of_int 15 = W64.of_int (2 ^ 4 - 1) by done.
    by rewrite W64.to_uint_and_mod //; smt(modz_cmp).
  have hgu : to_uint (g `>>` W8.of_int 4) < 16.
  + by rewrite W64.shr_div W8.of_uintK /= /#.
  have hgl0 := W64.to_uint_cmp (g `&` W64.of_int 15).
  have hgu0 := W64.to_uint_cmp (g `>>` W8.of_int 4).
  have hp1 := to_uint_popcnt64_nibble _ hgl.
  have hp2 := to_uint_popcnt64_nibble _ hgu.
  move: (POPCNT_64 (g `&` W64.of_int 15)).`6 hp1 => p1 hp1.
  move: (POPCNT_64 (g `>>` W8.of_int 4)).`6 hp2 => p2 hp2.
  have hb0 := W64.to_uint_cmp bytes_filled{hr}.
  have hi0 := W64.to_uint_cmp input_offset{hr}.
  have hio3 : to_uint input_offset{hr} + 32 <= 848 by smt().
  have hbf1 : to_uint bytes_filled{hr} + 4 * to_uint p1 + 16 <= 1024 by smt().
  have hs1 : to_uint (p1 `<<` W8.of_int 2) = 4 * to_uint p1.
  + by rewrite /(`<<`) /= W64.to_uint_shl // /ptr_modulus /= modz_small /#.
  have hs2 : to_uint (p2 `<<` W8.of_int 2) = 4 * to_uint p2.
  + by rewrite /(`<<`) /= W64.to_uint_shl // /ptr_modulus /= modz_small /#.
  have hb1 : to_uint (bytes_filled{hr} + (p1 `<<` W8.of_int 2))
             = to_uint bytes_filled{hr} + 4 * to_uint p1.
  + by rewrite W64.to_uintD_small hs1 /#.
  have hb2 : to_uint (bytes_filled{hr} + (p1 `<<` W8.of_int 2) + (p2 `<<` W8.of_int 2))
             = to_uint bytes_filled{hr} + 4 * to_uint p1 + 4 * to_uint p2.
  + by rewrite W64.to_uintD_small hb1 hs2 /#.
  have hsh1 : to_uint (g `&` W64.of_int 15 `<<` W8.of_int 4) = 16 * to_uint (g `&` W64.of_int 15).
  + by rewrite /(`<<`) /= W64.to_uint_shl // /ptr_modulus /= modz_small /#.
  have hsh2 : to_uint (g `>>` W8.of_int 4 `<<` W8.of_int 4) = 16 * to_uint (g `>>` W8.of_int 4).
  + by rewrite /(`<<`) /= W64.to_uint_shl // /ptr_modulus /= modz_small /#.
  have hin : to_uint (input_offset{hr} + W64.of_int 24) = to_uint input_offset{hr} + 24.
  + by rewrite W64.to_uintD_small W64.of_uintK /= /#.
  (* the two half-blocks written *)
  have hA : BArray1024.is_init (BArray1024.set128d b_polynomial{hr} (to_uint bytes_filled{hr})
                                  (W128.of_int 340282366920938463463374607431768211455))
              0 (to_uint bytes_filled{hr} + 16).
  + by rewrite BI1024.is_init_set128d_in 1,2:/# /= hinit /=; smt(BI1024.is_init_le0).
  have hB : BArray1024.is_init (BArray1024.set128d b_polynomial{hr} (to_uint bytes_filled{hr})
                                  (W128.of_int 340282366920938463463374607431768211455))
              0 (to_uint bytes_filled{hr} + 4 * to_uint p1).
  + by apply (BI1024.is_init_sub _ 0 (to_uint bytes_filled{hr} + 16)) => // /#.
  have hC : BArray1024.is_init
      (BArray1024.set128d (BArray1024.set128d b_polynomial{hr} (to_uint bytes_filled{hr})
                             (W128.of_int 340282366920938463463374607431768211455))
         (to_uint bytes_filled{hr} + 4 * to_uint p1)
         (W128.of_int 340282366920938463463374607431768211455))
      0 (to_uint bytes_filled{hr} + 4 * to_uint p1 + 16).
  + by rewrite BI1024.is_init_set128d_in 1,2:/# /= hB /=; smt(BI1024.is_init_le0).
  have hD : BArray1024.is_init
      (BArray1024.set128d (BArray1024.set128d b_polynomial{hr} (to_uint bytes_filled{hr})
                             (W128.of_int 340282366920938463463374607431768211455))
         (to_uint bytes_filled{hr} + 4 * to_uint p1)
         (W128.of_int 340282366920938463463374607431768211455))
      0 (to_uint bytes_filled{hr} + 4 * to_uint p1 + 4 * to_uint p2).
  + by apply (BI1024.is_init_sub _ 0 (to_uint bytes_filled{hr} + 4 * to_uint p1 + 16)) => // /#.
  rewrite ?W64.uleE ?W64.ultE hb1 hb2 hin hsh1 hsh2 /=.
  smt().
(* between the phases: the count of coefficients is the count of bytes over
   four, and the second loop runs when the polynomial and the input allow *)
auto => />; split; first smt().
move=> b0 bf0 cl0 io0 tr0 hcl hle hmod hinit himod hio hfalse hv.
rewrite !W64.ultE ?W64.uleE !W64.shr_div !W64.of_uintK W8.of_uintK /=.
have hbf : 4 * (to_uint bf0 %/ 4) = to_uint bf0 by smt().
rewrite hbf.
have hexit : forall (b1 : BArray1024.t) (f0 : W64.t), to_uint f0 <= 256 =>
    BArray1024.is_init b1 0 (4 * to_uint f0) =>
    BArray1024.is_init b1 0 (to_uint (W64.of_int 4 * f0)) /\ (f0 \ule W64.of_int 256).
+ by move=> b1 f0 hf hb; rewrite to_uint_mul4 1:/# W64.uleE /=.
smt().
qed.

lemma matrix_A__rejection_sample_one_block_proof _polynomial _b_polynomial _filled _block _b_block :
  matrix_A__rejection_sample_one_block_spec _polynomial _b_polynomial _filled _block _b_block.
proof.
hint +safety.
rewrite /matrix_A__rejection_sample_one_block_spec; proc.
conseq (_ :
     b_block = BArray168.init_arr (W8.of_int 255)
  /\ BArray1024.is_init b_polynomial 0 (4 * to_uint filled)
  /\ to_uint filled <= 256
  ==> BArray1024.is_init b_polynomial 0 (W64.to_uint ((W64.of_int 4) * filled))
   /\ filled \ule (W64.of_int 256)
   /\ valid trace_matrix_A__rejection_sample_one_block).
+ move=> &hr /> hb hinit hle.
  move: hle hinit; rewrite W64.uleE /= => hle; rewrite to_uint_mul4 1:/# => hinit.
  by rewrite -(BI168.is_init_full _ 168) // hb.
+ by move=> />.
(* coefficients are read three bytes at a time from the block and kept when
   below the modulus, until the polynomial is full or the block exhausted *)
while (b_block = BArray168.init_arr (W8.of_int 255)
    /\ to_uint filled <= 256 /\ BArray1024.is_init b_polynomial 0 (4 * to_uint filled)
    /\ to_uint block_offset %% 3 = 0 /\ to_uint block_offset <= 168
    /\ condition_loop = (to_uint filled < 256 /\ to_uint block_offset < 168)
    /\ valid trace_matrix_A__rejection_sample_one_block).
+ auto => /> &hr hle hinit hmod hbo hvalid hlt hlt2.
  have hf0 := W64.to_uint_cmp filled{hr}; have hb0 := W64.to_uint_cmp block_offset{hr}.
  have h1 : to_uint (block_offset{hr} + W64.of_int 1) = to_uint block_offset{hr} + 1.
  + by rewrite W64.to_uintD_small W64.of_uintK /= /#.
  have h2 : to_uint (block_offset{hr} + W64.of_int 1 + W64.of_int 1) = to_uint block_offset{hr} + 2.
  + by rewrite W64.to_uintD_small h1 W64.of_uintK /= /#.
  have h3 : to_uint (block_offset{hr} + W64.of_int 1 + W64.of_int 1 + W64.of_int 1)
            = to_uint block_offset{hr} + 3.
  + by rewrite W64.to_uintD_small h2 W64.of_uintK /= /#.
  have hf : to_uint (filled{hr} + W64.of_int 1) = to_uint filled{hr} + 1.
  + by rewrite W64.to_uintD_small W64.of_uintK /= /#.
  rewrite ?W64.uleE ?W64.ultE ?h1 ?h2 ?h3 ?hf /=.
  rewrite BI1024.is_init_set32d_in 1,2:/# /=.
  have h01 : W8.zero <> W8.one by rewrite W8.to_uint_eq.
  smt(BI1024.is_init_le0).
auto => /> &hr hle hinit.
have h01 : W8.zero <> W8.one by rewrite W8.to_uint_eq.
rewrite ?W64.uleE /= to_uint_mul4 1:/#.
by split => hc; (split; first smt()); move=> *; rewrite to_uint_mul4 1:/# W64.uleE /= /#.
qed.

lemma matrix_A____shake128_squeeze_multiple_blocks_4x_proof _state _b_state _b0 _b_b0 _b1 _b_b1 _b2 _b_b2 _b3 _b_b3 :
      (matrix_A____shake128_squeeze_multiple_blocks_4x_spec _state _b_state
      _b0 _b_b0 _b1 _b_b1 _b2 _b_b2 _b3 _b_b3).
proof.
hint +safety.
rewrite /matrix_A____shake128_squeeze_multiple_blocks_4x_spec; proc.
conseq (_ :
     b_state = BArray800.init_arr (W8.of_int 255)
  ==> BArray800.is_init b_state 0 (32 * 25)
   /\ BArray848.is_init b_b0 0 ((5 * 168) + 8)
   /\ BArray848.is_init b_b1 0 ((5 * 168) + 8)
   /\ BArray848.is_init b_b2 0 ((5 * 168) + 8)
   /\ BArray848.is_init b_b3 0 ((5 * 168) + 8)
   /\ valid trace_matrix_A____shake128_squeeze_multiple_blocks_4x).
+ by move=> &hr />; rewrite -!(BI800.is_init_full _ 800) //.
+ by move=> />.
unroll for ^while.
auto; ecall (shake128_squeezeblock4x_proof param_3 ((BArray800.init_arr (W8.of_int 255))) param_2 b_param_2 param_1 b_param_1 param_0 b_param_0 param b_param).
auto; ecall (shake128_squeezeblock4x_proof param_3 ((BArray800.init_arr (W8.of_int 255))) param_2 b_param_2 param_1 b_param_1 param_0 b_param_0 param b_param).
auto; ecall (shake128_squeezeblock4x_proof param_3 ((BArray800.init_arr (W8.of_int 255))) param_2 b_param_2 param_1 b_param_1 param_0 b_param_0 param b_param).
auto; ecall (shake128_squeezeblock4x_proof param_3 ((BArray800.init_arr (W8.of_int 255))) param_2 b_param_2 param_1 b_param_1 param_0 b_param_0 param b_param).
auto; ecall (shake128_squeezeblock4x_proof param_3 ((BArray800.init_arr (W8.of_int 255))) param_2 b_param_2 param_1 b_param_1 param_0 b_param_0 param b_param).
by auto => /> *.
qed.

lemma matrix_A____sample_4_polynomials_proof _rho _b_rho _domain_separators _b_domain_separators :
  matrix_A____sample_4_polynomials_spec _rho _b_rho _domain_separators _b_domain_separators.
proof.
hint +safety.
rewrite /matrix_A____sample_4_polynomials_spec; proc.
have h01 : W32.zero <> W32.one by rewrite W32.to_uint_eq.
(* a polynomial is complete once its count of coefficients reaches 256 *)
have hfull : forall (b : BArray1024.t) (f : W64.t),
    BArray1024.is_init b 0 (to_uint (W64.of_int 4 * f)) => f \ule W64.of_int 256 =>
    !(f \ult W64.of_int 256) => BArray1024.is_init b 0 1024.
+ move=> b f hb; rewrite W64.uleE W64.ultE /= => hle hlt.
  by move: hb; rewrite to_uint_mul4 1:/# => hb; smt().
(* the first five blocks of each buffer are squeezed at once *)
seq 159 : (b_buf0 = BArray848.init_arr (W8.of_int 255) /\ b_buf1 = BArray848.init_arr (W8.of_int 255)
    /\ b_buf2 = BArray848.init_arr (W8.of_int 255) /\ b_buf3 = BArray848.init_arr (W8.of_int 255)
    /\ valid trace_matrix_A____sample_4_polynomials).
+ conseq (_ : _ ==> BArray848.is_init b_buf0 0 848 /\ BArray848.is_init b_buf1 0 848
             /\ BArray848.is_init b_buf2 0 848 /\ BArray848.is_init b_buf3 0 848
             /\ valid trace_matrix_A____sample_4_polynomials).
  + by move=> /> *; rewrite -!(BI848.is_init_full _ 848) //.
  auto; ecall (matrix_A____shake128_squeeze_multiple_blocks_4x_proof param_6
                (BArray800.init_arr (W8.of_int 255)) param_5 b_param_18 param_4 b_param_17
                param_3 b_param_16 param_2 b_param_15).
  auto; ecall (shake128_absorb_34_4x_proof param_1 b_param_19 param_0
                (BArray32.init_arr (W8.of_int 255)) param (BArray8.init_arr (W8.of_int 255))).
  by auto => /> *; smt().
(* the loop squeezes one more block per polynomial and extends each one; it
   stops when the four are complete *)
while (b_buf0 = BArray848.init_arr (W8.of_int 255) /\ b_buf1 = BArray848.init_arr (W8.of_int 255)
    /\ b_buf2 = BArray848.init_arr (W8.of_int 255) /\ b_buf3 = BArray848.init_arr (W8.of_int 255)
    /\ BArray1024.is_init b_polynomial0 0 (to_uint (W64.of_int 4 * filled0))
    /\ filled0 \ule W64.of_int 256
    /\ BArray1024.is_init b_polynomial1 0 (to_uint (W64.of_int 4 * filled1))
    /\ filled1 \ule W64.of_int 256
    /\ BArray1024.is_init b_polynomial2 0 (to_uint (W64.of_int 4 * filled2))
    /\ filled2 \ule W64.of_int 256
    /\ BArray1024.is_init b_polynomial3 0 (to_uint (W64.of_int 4 * filled3))
    /\ filled3 \ule W64.of_int 256
    /\ (stop_sampling = W32.zero \/ stop_sampling = W32.one)
    /\ (stop_sampling = W32.one =>
          !(filled0 \ult W64.of_int 256) /\ !(filled1 \ult W64.of_int 256)
          /\ !(filled2 \ult W64.of_int 256) /\ !(filled3 \ult W64.of_int 256))
    /\ valid trace_matrix_A____sample_4_polynomials).
+ seq 31 : (b_buf0 = BArray848.init_arr (W8.of_int 255) /\ b_buf1 = BArray848.init_arr (W8.of_int 255)
      /\ b_buf2 = BArray848.init_arr (W8.of_int 255) /\ b_buf3 = BArray848.init_arr (W8.of_int 255)
      /\ BArray1024.is_init b_polynomial0 0 (to_uint (W64.of_int 4 * filled0))
      /\ filled0 \ule W64.of_int 256
      /\ BArray1024.is_init b_polynomial1 0 (to_uint (W64.of_int 4 * filled1))
      /\ filled1 \ule W64.of_int 256
      /\ BArray1024.is_init b_polynomial2 0 (to_uint (W64.of_int 4 * filled2))
      /\ filled2 \ule W64.of_int 256
      /\ BArray1024.is_init b_polynomial3 0 (to_uint (W64.of_int 4 * filled3))
      /\ filled3 \ule W64.of_int 256
      /\ valid trace_matrix_A____sample_4_polynomials).
  + auto; ecall (shake128_squeezeblock4x_proof param_19 (BArray800.init_arr (W8.of_int 255))
                   param_18 b_param_10 param_17 b_param_9 param_16 b_param_8 param_15 b_param_7).
    by auto => /> *; smt().
  seq 16 : (b_buf0 = BArray848.init_arr (W8.of_int 255) /\ b_buf1 = BArray848.init_arr (W8.of_int 255)
      /\ b_buf2 = BArray848.init_arr (W8.of_int 255) /\ b_buf3 = BArray848.init_arr (W8.of_int 255)
      /\ BArray1024.is_init b_polynomial0 0 (to_uint (W64.of_int 4 * filled0))
      /\ filled0 \ule W64.of_int 256
      /\ BArray1024.is_init b_polynomial1 0 (to_uint (W64.of_int 4 * filled1))
      /\ filled1 \ule W64.of_int 256
      /\ BArray1024.is_init b_polynomial2 0 (to_uint (W64.of_int 4 * filled2))
      /\ filled2 \ule W64.of_int 256
      /\ BArray1024.is_init b_polynomial3 0 (to_uint (W64.of_int 4 * filled3))
      /\ filled3 \ule W64.of_int 256
      /\ valid trace_matrix_A____sample_4_polynomials).
  + auto; ecall (matrix_A__rejection_sample_one_block_proof param_22 b_param_6 param_21 param_20 b_param_5).
    by auto => /> *; rewrite SBI848_168.get_sub_init_arr //=; smt().
  seq 16 : (b_buf0 = BArray848.init_arr (W8.of_int 255) /\ b_buf1 = BArray848.init_arr (W8.of_int 255)
      /\ b_buf2 = BArray848.init_arr (W8.of_int 255) /\ b_buf3 = BArray848.init_arr (W8.of_int 255)
      /\ BArray1024.is_init b_polynomial0 0 (to_uint (W64.of_int 4 * filled0))
      /\ filled0 \ule W64.of_int 256
      /\ BArray1024.is_init b_polynomial1 0 (to_uint (W64.of_int 4 * filled1))
      /\ filled1 \ule W64.of_int 256
      /\ BArray1024.is_init b_polynomial2 0 (to_uint (W64.of_int 4 * filled2))
      /\ filled2 \ule W64.of_int 256
      /\ BArray1024.is_init b_polynomial3 0 (to_uint (W64.of_int 4 * filled3))
      /\ filled3 \ule W64.of_int 256
      /\ valid trace_matrix_A____sample_4_polynomials).
  + auto; ecall (matrix_A__rejection_sample_one_block_proof param_25 b_param_4 param_24 param_23 b_param_3).
    by auto => /> *; rewrite SBI848_168.get_sub_init_arr //=; smt().
  seq 16 : (b_buf0 = BArray848.init_arr (W8.of_int 255) /\ b_buf1 = BArray848.init_arr (W8.of_int 255)
      /\ b_buf2 = BArray848.init_arr (W8.of_int 255) /\ b_buf3 = BArray848.init_arr (W8.of_int 255)
      /\ BArray1024.is_init b_polynomial0 0 (to_uint (W64.of_int 4 * filled0))
      /\ filled0 \ule W64.of_int 256
      /\ BArray1024.is_init b_polynomial1 0 (to_uint (W64.of_int 4 * filled1))
      /\ filled1 \ule W64.of_int 256
      /\ BArray1024.is_init b_polynomial2 0 (to_uint (W64.of_int 4 * filled2))
      /\ filled2 \ule W64.of_int 256
      /\ BArray1024.is_init b_polynomial3 0 (to_uint (W64.of_int 4 * filled3))
      /\ filled3 \ule W64.of_int 256
      /\ valid trace_matrix_A____sample_4_polynomials).
  + auto; ecall (matrix_A__rejection_sample_one_block_proof param_28 b_param_2 param_27 param_26 b_param_1).
    by auto => /> *; rewrite SBI848_168.get_sub_init_arr //=; smt().
  auto; ecall (matrix_A__rejection_sample_one_block_proof param_31 b_param_0 param_30 param_29 b_param).
  by auto => /> *; rewrite SBI848_168.get_sub_init_arr //=; smt().
(* the first blocks are consumed in full *)
auto; ecall (matrix_A__rejection_sample_multiple_blocks_proof param_14 b_param_11 param_13
               (BArray848.init_arr (W8.of_int 255))).
auto; ecall (matrix_A__rejection_sample_multiple_blocks_proof param_12 b_param_12 param_11
               (BArray848.init_arr (W8.of_int 255))).
auto; ecall (matrix_A__rejection_sample_multiple_blocks_proof param_10 b_param_13 param_9
               (BArray848.init_arr (W8.of_int 255))).
auto; ecall (matrix_A__rejection_sample_multiple_blocks_proof param_8 b_param_14 param_7
               (BArray848.init_arr (W8.of_int 255))).
by auto => /> *; smt().
qed.

lemma sample____challenge_proof _output_challenge _b_output_challenge _seed _b_seed :
  sample____challenge_spec _output_challenge _b_output_challenge _seed _b_seed.
proof.
hint +safety.
rewrite /sample____challenge_spec; proc.
have hz0 : to_uint W64.zero = 0 by done.
have h8 : to_uint (W64.of_int 8) = 8 by rewrite W64.of_uintK /=.
have h217 : to_uint (W64.of_int 217) = 217 by rewrite W64.of_uintK /=.
have h136 : to_uint (W64.of_int 136) = 136 by rewrite W64.of_uintK /=.
(* a coefficient write inside a fully initialised polynomial keeps it so *)
have hset : forall (b : BArray1024.t) (j : int), 0 <= j => j + 4 <= 1024 =>
    BArray1024.is_init b 0 1024 =>
    BArray1024.is_init (BArray1024.set32d b j (W32.of_int 4294967295)) 0 1024.
+ move=> b j hj0 hj1 hb; rewrite BI1024.is_init_set32d_in // /=.
  by split; apply (BI1024.is_init_sub _ 0 1024) => // /#.
(* the main loop swaps the coefficient at i with the one at a sampled
   position; the polynomial is fully initialised from the start *)
while (217 <= to_uint i /\ to_uint i <= 256 /\ condition_loop = (to_uint i < 256)
    /\ to_uint xof_offset <= 136
    /\ BArray1024.is_init b_output_challenge 0 1024 /\ valid trace_sample____challenge).
+ (* refill the block when exhausted *)
  seq 3 : (217 <= to_uint i /\ to_uint i < 256 /\ to_uint xof_offset < 136
      /\ BArray1024.is_init b_output_challenge 0 1024 /\ valid trace_sample____challenge).
  + seq 2 : (217 <= to_uint i /\ to_uint i < 256 /\ to_uint xof_offset <= 136
        /\ condition_refill = (W64.of_int 136 \ule xof_offset)
        /\ BArray1024.is_init b_output_challenge 0 1024 /\ valid trace_sample____challenge).
    + by auto => /> /#.
    if.
    + auto; ecall (shake256_squeezeblock_proof param_4 (BArray224.init_arr (W8.of_int 255))
                     param_3 (BArray136.init_arr (W8.of_int 255))).
      by auto => /> *; smt().
    by auto => /> &hr hi1 hi2 hxo hinit hv; rewrite W64.uleE h136 /= => hlt /#.
  (* read one byte *)
  seq 5 : (217 <= to_uint i /\ to_uint i < 256 /\ to_uint xof_offset <= 136
      /\ to_uint sample_at < 256
      /\ BArray1024.is_init b_output_challenge 0 1024 /\ valid trace_sample____challenge).
  + auto => /> &hr hi1 hi2 hxo hinit hv.
    have hx1 : to_uint (xof_offset{hr} + W64.one) = to_uint xof_offset{hr} + 1.
    + by rewrite W64.to_uintD_small /= /#.
    rewrite /SLH64.protect_64 /zeroextu64 W64.of_uintK hx1 /=.
    have := W64.to_uint_cmp xof_offset{hr}.
    by have /= := W8.to_uint_cmp xof_block{hr}.[to_uint xof_offset{hr}]; smt().
  (* resample while the position exceeds i *)
  seq 1 : (217 <= to_uint i /\ to_uint i < 256 /\ to_uint xof_offset <= 136
      /\ to_uint sample_at < 256
      /\ BArray1024.is_init b_output_challenge 0 1024 /\ valid trace_sample____challenge).
  + while (217 <= to_uint i /\ to_uint i < 256 /\ to_uint xof_offset <= 136
        /\ to_uint sample_at < 256
        /\ BArray1024.is_init b_output_challenge 0 1024 /\ valid trace_sample____challenge).
    + seq 3 : (217 <= to_uint i /\ to_uint i < 256 /\ to_uint xof_offset < 136
          /\ BArray1024.is_init b_output_challenge 0 1024 /\ valid trace_sample____challenge).
      + seq 2 : (217 <= to_uint i /\ to_uint i < 256 /\ to_uint xof_offset <= 136
            /\ condition_refill = (W64.of_int 136 \ule xof_offset)
            /\ BArray1024.is_init b_output_challenge 0 1024 /\ valid trace_sample____challenge).
        + by auto => /> /#.
        if.
        + auto; ecall (shake256_squeezeblock_proof param_4 (BArray224.init_arr (W8.of_int 255))
                         param_3 (BArray136.init_arr (W8.of_int 255))).
          by auto => /> *; smt().
        by auto => /> &hr hi1 hi2 hxo hinit hv; rewrite W64.uleE h136 /= => hlt /#.
      auto => /> &hr hi1 hi2 hxo hinit hv.
      have hx1 : to_uint (xof_offset{hr} + W64.one) = to_uint xof_offset{hr} + 1.
      + by rewrite W64.to_uintD_small /= /#.
      rewrite /SLH64.protect_64 /zeroextu64 W64.of_uintK hx1 /=.
      have := W64.to_uint_cmp xof_offset{hr}.
      by have /= := W8.to_uint_cmp xof_block{hr}.[to_uint xof_offset{hr}]; smt().
    by auto => /> /#.
  (* the swap *)
  auto => /> &hr hi1 hi2 hxo hsa hinit hv.
  have hsa0 := W64.to_uint_cmp sample_at{hr}.
  have hi : to_uint (i{hr} + W64.one) = to_uint i{hr} + 1 by rewrite W64.to_uintD_small /= /#.
  have hs1 : BArray1024.is_init
      (BArray1024.set32d b_output_challenge{hr} (to_uint i{hr} * 4) (W32.of_int 4294967295))
      0 1024.
  + by apply hset => // /#.
  have hs2 : BArray1024.is_init
      (BArray1024.set32d
         (BArray1024.set32d b_output_challenge{hr} (to_uint i{hr} * 4) (W32.of_int 4294967295))
         (to_uint sample_at{hr} * 4) (W32.of_int 4294967295))
      0 1024.
  + by apply hset => // /#.
  have hs3 : BArray1024.is_init b_output_challenge{hr} (to_uint sample_at{hr} * 4) 4.
  + by apply (BI1024.is_init_sub _ 0 1024) => // /#.
  rewrite W64.ultE hi /=.
  smt(W64.to_uint_cmp).
(* absorb the seed, squeeze the first block *)
auto; ecall (shake256_squeezeblock_proof param_2 (BArray224.init_arr (W8.of_int 255)) param_1 b_param).
auto; ecall (shake256_absorb_commitment_hash_proof param_0 b_param_0 param
               (BArray32.init_arr (W8.of_int 255))).
(* the polynomial is zeroed 32 bytes at a time *)
wp.
while (to_uint i <= 1024 /\ to_uint i %% 32 = 0
    /\ BArray1024.is_init b_output_challenge 0 (to_uint i) /\ valid trace_sample____challenge).
+ auto => /> &hr hle hmod hinit hv hlt.
  move: hlt; rewrite W64.ultE /= => hlt.
  have hi0 := W64.to_uint_cmp i{hr}.
  have hi : to_uint (i{hr} + W64.of_int 32) = to_uint i{hr} + 32.
  + by rewrite W64.to_uintD_small W64.of_uintK /= /#.
  have hs : BArray1024.is_init
      (BArray1024.set256d b_output_challenge{hr} (to_uint i{hr})
         (W256.of_int 115792089237316195423570985008687907853269984665640564039457584007913129639935))
      0 (to_uint i{hr} + 32).
  + by rewrite BI1024.is_init_set256d_in 1,2:/# /=; smt(BI1024.is_init_le0).
  rewrite hi /=; smt(W64.to_uint_cmp).
(* at the exit of the zeroing loop the polynomial is complete *)
auto => /> hseed b0 i0 tr0 hge hle hmod hinit hv r0 _ _ r1 _ _ _.
by move: hge; rewrite W64.ultE /= => hge; smt().
qed.

lemma shake256_squeeze_multiple_blocks_4x_proof _state _b_state _b0 _b_b0 _b1 _b_b1 _b2 _b_b2 _b3 _b_b3 :
      (shake256_squeeze_multiple_blocks_4x_spec _state _b_state _b0 _b_b0 
      _b1 _b_b1 _b2 _b_b2 _b3 _b_b3).
proof.
hint +safety.
rewrite /shake256_squeeze_multiple_blocks_4x_spec; proc.
conseq (_ :
     b_state = BArray800.init_arr (W8.of_int 255)
  ==> BArray800.is_init b_state 0 (32 * 25)
   /\ BArray680.is_init b_b0 0 ((((((18 * 256) %/ 8) + 136) - 1) %/ 136) * 136)
   /\ BArray680.is_init b_b1 0 ((((((18 * 256) %/ 8) + 136) - 1) %/ 136) * 136)
   /\ BArray680.is_init b_b2 0 ((((((18 * 256) %/ 8) + 136) - 1) %/ 136) * 136)
   /\ BArray680.is_init b_b3 0 ((((((18 * 256) %/ 8) + 136) - 1) %/ 136) * 136)
   /\ valid trace_shake256_squeeze_multiple_blocks_4x).
+ by move=> &hr />; rewrite -!(BI800.is_init_full _ 800) //.
+ by move=> />.
unroll for ^while.
auto; ecall (shake256_squeezeblock4x_proof param_3 ((BArray800.init_arr (W8.of_int 255))) param_2 b_param_2 param_1 b_param_1 param_0 b_param_0 param b_param).
auto; ecall (shake256_squeezeblock4x_proof param_3 ((BArray800.init_arr (W8.of_int 255))) param_2 b_param_2 param_1 b_param_1 param_0 b_param_0 param b_param).
auto; ecall (shake256_squeezeblock4x_proof param_3 ((BArray800.init_arr (W8.of_int 255))) param_2 b_param_2 param_1 b_param_1 param_0 b_param_0 param b_param).
auto; ecall (shake256_squeezeblock4x_proof param_3 ((BArray800.init_arr (W8.of_int 255))) param_2 b_param_2 param_1 b_param_1 param_0 b_param_0 param b_param).
auto; ecall (shake256_squeezeblock4x_proof param_3 ((BArray800.init_arr (W8.of_int 255))) param_2 b_param_2 param_1 b_param_1 param_0 b_param_0 param b_param).
by auto => /> *.
qed.

lemma __sample_mask_polynomial_4x_proof _rho_prime _b_rho_prime _starting_domain_separator :
      (__sample_mask_polynomial_4x_spec _rho_prime _b_rho_prime
      _starting_domain_separator).
proof.
hint +safety.
rewrite /__sample_mask_polynomial_4x_spec; proc.
conseq (_ :
     b_rho_prime = BArray64.init_arr (W8.of_int 255)
  ==> BArray1024.is_init b_mask3 0 1024
   /\ BArray1024.is_init b_mask2 0 1024
   /\ BArray1024.is_init b_mask1 0 1024
   /\ BArray1024.is_init b_mask0 0 1024
   /\ valid trace___sample_mask_polynomial_4x).
+ by move=> &hr />; rewrite -!(BI64.is_init_full _ 64) //.
+ by move=> />.
auto; ecall (gamma1____decode_to_polynomial_proof param_14 b_param_0 param_13 b_param).
auto; ecall (gamma1____decode_to_polynomial_proof param_12 b_param_2 param_11 b_param_1).
auto; ecall (gamma1____decode_to_polynomial_proof param_10 b_param_4 param_9 b_param_3).
auto; ecall (gamma1____decode_to_polynomial_proof param_8 b_param_6 param_7 b_param_5).
auto; ecall (shake256_squeeze_multiple_blocks_4x_proof param_6 ((BArray800.init_arr (W8.of_int 255))) param_5 b_param_10 param_4 b_param_9 param_3 b_param_8 param_2 b_param_7).
auto; ecall (shake256_absorb_66_4x_proof param_1 b_param_11 param_0 ((BArray64.init_arr (W8.of_int 255))) param).
by auto => /> *.
qed.

lemma polynomial__add_proof _sum_pointer _b_sum_pointer _lhs_pointer _b_lhs_pointer _rhs_pointer _b_rhs_pointer :
      (polynomial__add_spec _sum_pointer _b_sum_pointer _lhs_pointer
      _b_lhs_pointer _rhs_pointer _b_rhs_pointer).
proof.
hint +safety.
rewrite /polynomial__add_spec; proc.
conseq (_ :
     b_lhs_pointer = BArray1024.init_arr (W8.of_int 255)
  /\ b_rhs_pointer = BArray1024.init_arr (W8.of_int 255)
  ==> BArray1024.is_init b_sum_pointer 0 (4 * 256)
   /\ valid trace_polynomial__add).
+ by move=> &hr />; rewrite -!(BI1024.is_init_full _ 1024) //.
unroll for ^while.
by auto => /> *.
qed.

lemma polynomial__subtract_proof _difference_pointer _b_difference_pointer _lhs_pointer _b_lhs_pointer _rhs_pointer _b_rhs_pointer :
      (polynomial__subtract_spec _difference_pointer _b_difference_pointer
      _lhs_pointer _b_lhs_pointer _rhs_pointer _b_rhs_pointer).
proof.
hint +safety.
rewrite /polynomial__subtract_spec; proc.
conseq (_ :
     b_lhs_pointer = BArray1024.init_arr (W8.of_int 255)
  /\ b_rhs_pointer = BArray1024.init_arr (W8.of_int 255)
  ==> BArray1024.is_init b_difference_pointer 0 (4 * 256)
   /\ valid trace_polynomial__subtract).
+ by move=> &hr />; rewrite -!(BI1024.is_init_full _ 1024) //.
unroll for ^while.
by auto => /> *.
qed.

lemma polynomial____check_infinity_norm_proof _polynomial _b_polynomial _threshold :
      (polynomial____check_infinity_norm_spec _polynomial _b_polynomial
      _threshold).
proof.
hint +safety.
rewrite /polynomial____check_infinity_norm_spec; proc.
conseq (_ :
     b_polynomial = BArray1024.init_arr (W8.of_int 255)
  ==> valid trace_polynomial____check_infinity_norm).
+ by move=> &hr />; rewrite -!(BI1024.is_init_full _ 1024) //.
unroll for ^while.
by auto => /> *.
qed.

lemma polynomial____add_reduce32_check_infinity_norm_proof _sum_pointer _b_sum_pointer _lhs_pointer _b_lhs_pointer _rhs_pointer _b_rhs_pointer _threshold :
      (polynomial____add_reduce32_check_infinity_norm_spec _sum_pointer
      _b_sum_pointer _lhs_pointer _b_lhs_pointer _rhs_pointer _b_rhs_pointer
      _threshold).
proof.
hint +safety.
rewrite /polynomial____add_reduce32_check_infinity_norm_spec; proc.
conseq (_ :
     b_lhs_pointer = BArray1024.init_arr (W8.of_int 255)
  /\ b_rhs_pointer = BArray1024.init_arr (W8.of_int 255)
  ==> BArray1024.is_init b_sum_pointer 0 (4 * 256)
   /\ valid trace_polynomial____add_reduce32_check_infinity_norm).
+ by move=> &hr />; rewrite -!(BI1024.is_init_full _ 1024) //.
unroll for ^while.
by auto => /> *.
qed.

lemma polynomial____subtract_reduce32_check_infinity_norm_proof _difference_pointer _b_difference_pointer _lhs_pointer _b_lhs_pointer _rhs_pointer _b_rhs_pointer _threshold :
      (polynomial____subtract_reduce32_check_infinity_norm_spec
      _difference_pointer _b_difference_pointer _lhs_pointer _b_lhs_pointer
      _rhs_pointer _b_rhs_pointer _threshold).
proof.
hint +safety.
rewrite /polynomial____subtract_reduce32_check_infinity_norm_spec; proc.
conseq (_ :
     b_lhs_pointer = BArray1024.init_arr (W8.of_int 255)
  /\ b_rhs_pointer = BArray1024.init_arr (W8.of_int 255)
  ==> BArray1024.is_init b_difference_pointer 0 (4 * 256)
   /\ valid trace_polynomial____subtract_reduce32_check_infinity_norm).
+ by move=> &hr />; rewrite -!(BI1024.is_init_full _ 1024) //.
unroll for ^while.
by auto => /> *.
qed.

lemma polynomial____add_reduce32_check_infinity_norm_rhs_proof _sum_pointer _b_sum_pointer _lhs_pointer _b_lhs_pointer _rhs_pointer _b_rhs_pointer _threshold _bound :
      (polynomial____add_reduce32_check_infinity_norm_rhs_spec _sum_pointer
      _b_sum_pointer _lhs_pointer _b_lhs_pointer _rhs_pointer _b_rhs_pointer
      _threshold _bound).
proof.
hint +safety.
rewrite /polynomial____add_reduce32_check_infinity_norm_rhs_spec; proc.
conseq (_ :
     b_lhs_pointer = BArray1024.init_arr (W8.of_int 255)
  /\ b_rhs_pointer = BArray1024.init_arr (W8.of_int 255)
  ==> BArray1024.is_init b_sum_pointer 0 (4 * 256)
   /\ valid trace_polynomial____add_reduce32_check_infinity_norm_rhs).
+ by move=> &hr />; rewrite -!(BI1024.is_init_full _ 1024) //.
unroll for ^while.
case (threshold <= bound).
do 33! (rcondt ^if; first by auto).
by auto => /> *.
do 33! (rcondf ^if; first by auto).
by auto => /> *.
qed.

lemma polynomial____shift_coefficients_left_proof _polynomial _b_polynomial :
      (polynomial____shift_coefficients_left_spec _polynomial _b_polynomial).
proof.
hint +safety.
rewrite /polynomial____shift_coefficients_left_spec; proc.
conseq (_ :
     b_polynomial = BArray1024.init_arr (W8.of_int 255)
  ==> BArray1024.is_init b_polynomial 0 1024
   /\ valid trace_polynomial____shift_coefficients_left).
+ by move=> &hr />; rewrite -!(BI1024.is_init_full _ 1024) //.
unroll for ^while.
by auto => /> *.
qed.

lemma row_vector__ntt_proof _vector _b_vector :
      (row_vector__ntt_spec _vector _b_vector).
proof.
hint +safety.
rewrite /row_vector__ntt_spec; proc.
conseq (_ :
     b_vector = BArray4096.init_arr (W8.of_int 255)
  ==> BArray4096.is_init b_vector 0 4096
   /\ valid trace_row_vector__ntt).
+ by move=> &hr />; rewrite -!(BI4096.is_init_full _ 4096) //.
unroll for ^while.
auto; ecall (polynomial__ntt_proof param b_param).
auto; ecall (polynomial__ntt_proof param b_param).
auto; ecall (polynomial__ntt_proof param b_param).
auto; ecall (polynomial__ntt_proof param b_param).
by auto => /> *.
qed.

lemma row_vector____dot_product_proof _output _b_output _lhs _b_lhs _rhs _b_rhs :
      (row_vector____dot_product_spec _output _b_output _lhs _b_lhs _rhs
      _b_rhs).
proof.
hint +safety.
rewrite /row_vector____dot_product_spec; proc.
conseq (_ :
     b_lhs = BArray4096.init_arr (W8.of_int 255)
  /\ b_rhs = BArray4096.init_arr (W8.of_int 255)
  ==> BArray1024.is_init b_output 0 (4 * 256)
   /\ valid trace_row_vector____dot_product).
+ by move=> &hr />; rewrite -!(BI4096.is_init_full _ 4096) //.
do 33! (unroll for ^while).
do 128! ((rcondf ^if; first by auto) || (rcondt ^if; first by auto)).
by auto => /> *.
qed.

lemma row_vector____multiply_with_matrix_A_proof _matrix_A _b_matrix_A _vector _b_vector :
      (row_vector____multiply_with_matrix_A_spec _matrix_A _b_matrix_A
      _vector _b_vector).
proof.
hint +safety.
rewrite /row_vector____multiply_with_matrix_A_spec; proc.
conseq (_ :
     b_vector = BArray4096.init_arr (W8.of_int 255)
  /\ b_matrix_A = BArray16384.init_arr (W8.of_int 255)
  ==> BArray4096.is_init b_out 0 4096
   /\ valid trace_row_vector____multiply_with_matrix_A).
+ by move=> &hr />; rewrite -!(BI4096.is_init_full _ 4096) // -!(BI16384.is_init_full _ 16384) //.
unroll for ^while.
auto; ecall (row_vector____dot_product_proof param_1 b_param_0 param_0 b_param param ((BArray4096.init_arr (W8.of_int 255)))).
auto; ecall (row_vector____dot_product_proof param_1 b_param_0 param_0 b_param param ((BArray4096.init_arr (W8.of_int 255)))).
auto; ecall (row_vector____dot_product_proof param_1 b_param_0 param_0 b_param param ((BArray4096.init_arr (W8.of_int 255)))).
auto; ecall (row_vector____dot_product_proof param_1 b_param_0 param_0 b_param param ((BArray4096.init_arr (W8.of_int 255)))).
by auto => /> *.
qed.

lemma row_vector____check_infinity_norm_proof _vector _b_vector _threshold :
      (row_vector____check_infinity_norm_spec _vector _b_vector _threshold).
proof.
hint +safety.
rewrite /row_vector____check_infinity_norm_spec; proc.
conseq (_ :
     b_vector = BArray4096.init_arr (W8.of_int 255)
  ==> valid trace_row_vector____check_infinity_norm).
+ by move=> &hr />; rewrite -!(BI4096.is_init_full _ 4096) //.
unroll for ^while.
auto; ecall (polynomial____check_infinity_norm_proof param_0 b_param param).
auto; ecall (polynomial____check_infinity_norm_proof param_0 b_param param).
auto; ecall (polynomial____check_infinity_norm_proof param_0 b_param param).
auto; ecall (polynomial____check_infinity_norm_proof param_0 b_param param).
by auto => /> *.
qed.

lemma column_vector__reduce32_proof _vector _b_vector :
      (column_vector__reduce32_spec _vector _b_vector).
proof.
hint +safety.
rewrite /column_vector__reduce32_spec; proc.
conseq (_ :
     b_vector = BArray4096.init_arr (W8.of_int 255)
  ==> BArray4096.is_init b_vector 0 4096
   /\ valid trace_column_vector__reduce32).
+ by move=> &hr />; rewrite -!(BI4096.is_init_full _ 4096) //.
unroll for ^while.
auto; ecall (polynomial__reduce32_proof param b_param).
auto; ecall (polynomial__reduce32_proof param b_param).
auto; ecall (polynomial__reduce32_proof param b_param).
auto; ecall (polynomial__reduce32_proof param b_param).
by auto => /> *.
qed.

lemma column_vector__ntt_proof _vector _b_vector :
      (column_vector__ntt_spec _vector _b_vector).
proof.
hint +safety.
rewrite /column_vector__ntt_spec; proc.
conseq (_ :
     b_vector = BArray4096.init_arr (W8.of_int 255)
  ==> BArray4096.is_init b_vector 0 4096
   /\ valid trace_column_vector__ntt).
+ by move=> &hr />; rewrite -!(BI4096.is_init_full _ 4096) //.
unroll for ^while.
auto; ecall (polynomial__ntt_proof param b_param).
auto; ecall (polynomial__ntt_proof param b_param).
auto; ecall (polynomial__ntt_proof param b_param).
auto; ecall (polynomial__ntt_proof param b_param).
by auto => /> *.
qed.

lemma column_vector__invert_ntt_montgomery_proof _vector _b_vector :
      (column_vector__invert_ntt_montgomery_spec _vector _b_vector).
proof.
hint +safety.
rewrite /column_vector__invert_ntt_montgomery_spec; proc.
conseq (_ :
     b_vector = BArray4096.init_arr (W8.of_int 255)
  ==> BArray4096.is_init b_vector 0 4096
   /\ valid trace_column_vector__invert_ntt_montgomery).
+ by move=> &hr />; rewrite -!(BI4096.is_init_full _ 4096) //.
unroll for ^while.
auto; ecall (polynomial__invert_ntt_montgomery_proof param b_param).
auto; ecall (polynomial__invert_ntt_montgomery_proof param b_param).
auto; ecall (polynomial__invert_ntt_montgomery_proof param b_param).
auto; ecall (polynomial__invert_ntt_montgomery_proof param b_param).
by auto => /> *.
qed.

lemma column_vector____power2round_proof _vector _b_vector :
      (column_vector____power2round_spec _vector _b_vector).
proof.
hint +safety.
rewrite /column_vector____power2round_spec; proc.
conseq (_ :
     b_vector = BArray4096.init_arr (W8.of_int 255)
  ==> BArray4096.is_init b_t0 0 4096
   /\ BArray4096.is_init b_t1 0 4096
   /\ valid trace_column_vector____power2round).
+ by move=> &hr />; rewrite -!(BI4096.is_init_full _ 4096) //.
+ by move=> />.
unroll for ^while.
auto; ecall (polynomial____power2round_proof param_1 b_param_1 param_0 b_param_0 param b_param).
auto; ecall (polynomial____power2round_proof param_1 b_param_1 param_0 b_param_0 param b_param).
auto; ecall (polynomial____power2round_proof param_1 b_param_1 param_0 b_param_0 param b_param).
auto; ecall (polynomial____power2round_proof param_1 b_param_1 param_0 b_param_0 param b_param).
by auto => /> *.
qed.

lemma column_vector____add_proof _lhs _b_lhs _rhs _b_rhs :
      (column_vector____add_spec _lhs _b_lhs _rhs _b_rhs).
proof.
hint +safety.
rewrite /column_vector____add_spec; proc.
conseq (_ :
     b_rhs = BArray4096.init_arr (W8.of_int 255)
  /\ b_lhs = BArray4096.init_arr (W8.of_int 255)
  ==> BArray4096.is_init b_sum 0 4096
   /\ valid trace_column_vector____add).
+ by move=> &hr />; rewrite -!(BI4096.is_init_full _ 4096) //.
unroll for ^while.
auto; ecall (polynomial__add_proof param_1 b_param_1 param_0 b_param_0 param b_param).
auto; ecall (polynomial__add_proof param_1 b_param_1 param_0 b_param_0 param b_param).
auto; ecall (polynomial__add_proof param_1 b_param_1 param_0 b_param_0 param b_param).
auto; ecall (polynomial__add_proof param_1 b_param_1 param_0 b_param_0 param b_param).
by auto => /> *.
qed.

lemma column_vector____conditionally_add_modulus_proof _vector _b_vector :
      (column_vector____conditionally_add_modulus_spec _vector _b_vector).
proof.
hint +safety.
rewrite /column_vector____conditionally_add_modulus_spec; proc.
conseq (_ :
     b_vector = BArray4096.init_arr (W8.of_int 255)
  ==> BArray4096.is_init b_vector 0 4096
   /\ valid trace_column_vector____conditionally_add_modulus).
+ by move=> &hr />; rewrite -!(BI4096.is_init_full _ 4096) //.
unroll for ^while.
auto; ecall (polynomial__conditionally_add_modulus_proof param b_param).
auto; ecall (polynomial__conditionally_add_modulus_proof param b_param).
auto; ecall (polynomial__conditionally_add_modulus_proof param b_param).
auto; ecall (polynomial__conditionally_add_modulus_proof param b_param).
by auto => /> *.
qed.

lemma column_vector____decompose_proof _vector _b_vector :
      (column_vector____decompose_spec _vector _b_vector).
proof.
hint +safety.
rewrite /column_vector____decompose_spec; proc.
conseq (_ :
     b_vector = BArray4096.init_arr (W8.of_int 255)
  ==> BArray4096.is_init b_high 0 4096
   /\ BArray4096.is_init b_low 0 4096
   /\ valid trace_column_vector____decompose).
+ by move=> &hr />; rewrite -!(BI4096.is_init_full _ 4096) //.
+ by move=> />.
unroll for ^while.
auto; ecall (polynomial__decompose_proof param_1 b_param_1 param_0 b_param_0 param b_param).
auto; ecall (polynomial__decompose_proof param_1 b_param_1 param_0 b_param_0 param b_param).
auto; ecall (polynomial__decompose_proof param_1 b_param_1 param_0 b_param_0 param b_param).
auto; ecall (polynomial__decompose_proof param_1 b_param_1 param_0 b_param_0 param b_param).
by auto => /> *.
qed.

lemma t0__coefficients_to_bytestream_proof _coefficients :
      (t0__coefficients_to_bytestream_spec _coefficients).
proof.
hint +safety.
rewrite /t0__coefficients_to_bytestream_spec; proc.
conseq (_ : _ ==> valid trace_t0__coefficients_to_bytestream).
by auto => /> *.
qed.

lemma t0__encode_polynomial_proof _t0_encoded _b_t0_encoded _t0 _b_t0 :
      (t0__encode_polynomial_spec _t0_encoded _b_t0_encoded _t0 _b_t0).
proof.
hint +safety.
rewrite /t0__encode_polynomial_spec; proc.
conseq (_ :
     b_t0 = BArray1024.init_arr (W8.of_int 255)
  ==> BArray416.is_init b_t0_encoded 0 ((13 * 256) %/ 8)
   /\ valid trace_t0__encode_polynomial).
+ by move=> &hr />; rewrite -!(BI1024.is_init_full _ 1024) //.
do 2! (unroll for ^while).
cfold* ^output_offset<-.
auto; ecall (t0__coefficients_to_bytestream_proof param_0).
auto; ecall (t0__coefficients_to_bytestream_proof param).
auto; ecall (t0__coefficients_to_bytestream_proof param).
auto; ecall (t0__coefficients_to_bytestream_proof param).
auto; ecall (t0__coefficients_to_bytestream_proof param).
auto; ecall (t0__coefficients_to_bytestream_proof param).
auto; ecall (t0__coefficients_to_bytestream_proof param).
auto; ecall (t0__coefficients_to_bytestream_proof param).
auto; ecall (t0__coefficients_to_bytestream_proof param).
auto; ecall (t0__coefficients_to_bytestream_proof param).
auto; ecall (t0__coefficients_to_bytestream_proof param).
auto; ecall (t0__coefficients_to_bytestream_proof param).
auto; ecall (t0__coefficients_to_bytestream_proof param).
auto; ecall (t0__coefficients_to_bytestream_proof param).
auto; ecall (t0__coefficients_to_bytestream_proof param).
auto; ecall (t0__coefficients_to_bytestream_proof param).
auto; ecall (t0__coefficients_to_bytestream_proof param).
auto; ecall (t0__coefficients_to_bytestream_proof param).
auto; ecall (t0__coefficients_to_bytestream_proof param).
auto; ecall (t0__coefficients_to_bytestream_proof param).
auto; ecall (t0__coefficients_to_bytestream_proof param).
auto; ecall (t0__coefficients_to_bytestream_proof param).
auto; ecall (t0__coefficients_to_bytestream_proof param).
auto; ecall (t0__coefficients_to_bytestream_proof param).
auto; ecall (t0__coefficients_to_bytestream_proof param).
auto; ecall (t0__coefficients_to_bytestream_proof param).
auto; ecall (t0__coefficients_to_bytestream_proof param).
auto; ecall (t0__coefficients_to_bytestream_proof param).
auto; ecall (t0__coefficients_to_bytestream_proof param).
auto; ecall (t0__coefficients_to_bytestream_proof param).
auto; ecall (t0__coefficients_to_bytestream_proof param).
auto; ecall (t0__coefficients_to_bytestream_proof param).
by auto => /> *.
qed.

lemma t0____encode_proof _encoded _b_encoded _t0 _b_t0 :
      (t0____encode_spec _encoded _b_encoded _t0 _b_t0).
proof.
hint +safety.
rewrite /t0____encode_spec; proc.
conseq (_ :
     b_t0 = BArray4096.init_arr (W8.of_int 255)
  ==> BArray1664.is_init b_encoded 0 (4 * ((13 * 256) %/ 8))
   /\ valid trace_t0____encode).
+ by move=> &hr />; rewrite -!(BI4096.is_init_full _ 4096) //.
unroll for ^while.
auto; ecall (t0__encode_polynomial_proof param_0 b_param_0 param b_param).
auto; ecall (t0__encode_polynomial_proof param_0 b_param_0 param b_param).
auto; ecall (t0__encode_polynomial_proof param_0 b_param_0 param b_param).
auto; ecall (t0__encode_polynomial_proof param_0 b_param_0 param b_param).
by auto => /> *.
qed.

lemma t0__bytestream_to_coefficients_proof _bytestream :
      (t0__bytestream_to_coefficients_spec _bytestream).
proof.
hint +safety.
rewrite /t0__bytestream_to_coefficients_spec; proc.
conseq (_ : _ ==> valid trace_t0__bytestream_to_coefficients).
by auto => /> *.
qed.

lemma t0____decode_polynomial_proof _t0 _b_t0 _t0_encoded _b_t0_encoded :
      (t0____decode_polynomial_spec _t0 _b_t0 _t0_encoded _b_t0_encoded).
proof.
hint +safety.
rewrite /t0____decode_polynomial_spec; proc.
conseq (_ :
     b_t0_encoded = BArray416.init_arr (W8.of_int 255)
  ==> BArray1024.is_init b_t0 0 (4 * 256)
   /\ valid trace_t0____decode_polynomial).
+ by move=> &hr />; rewrite -!(BI416.is_init_full _ 416) //.
unroll for ^while.
cfold* ^output_offset<-.
auto; ecall (t0__bytestream_to_coefficients_proof param_0).
auto; ecall (t0__bytestream_to_coefficients_proof param).
auto; ecall (t0__bytestream_to_coefficients_proof param).
auto; ecall (t0__bytestream_to_coefficients_proof param).
auto; ecall (t0__bytestream_to_coefficients_proof param).
auto; ecall (t0__bytestream_to_coefficients_proof param).
auto; ecall (t0__bytestream_to_coefficients_proof param).
auto; ecall (t0__bytestream_to_coefficients_proof param).
auto; ecall (t0__bytestream_to_coefficients_proof param).
auto; ecall (t0__bytestream_to_coefficients_proof param).
auto; ecall (t0__bytestream_to_coefficients_proof param).
auto; ecall (t0__bytestream_to_coefficients_proof param).
auto; ecall (t0__bytestream_to_coefficients_proof param).
auto; ecall (t0__bytestream_to_coefficients_proof param).
auto; ecall (t0__bytestream_to_coefficients_proof param).
auto; ecall (t0__bytestream_to_coefficients_proof param).
auto; ecall (t0__bytestream_to_coefficients_proof param).
auto; ecall (t0__bytestream_to_coefficients_proof param).
auto; ecall (t0__bytestream_to_coefficients_proof param).
auto; ecall (t0__bytestream_to_coefficients_proof param).
auto; ecall (t0__bytestream_to_coefficients_proof param).
auto; ecall (t0__bytestream_to_coefficients_proof param).
auto; ecall (t0__bytestream_to_coefficients_proof param).
auto; ecall (t0__bytestream_to_coefficients_proof param).
auto; ecall (t0__bytestream_to_coefficients_proof param).
auto; ecall (t0__bytestream_to_coefficients_proof param).
auto; ecall (t0__bytestream_to_coefficients_proof param).
auto; ecall (t0__bytestream_to_coefficients_proof param).
auto; ecall (t0__bytestream_to_coefficients_proof param).
auto; ecall (t0__bytestream_to_coefficients_proof param).
auto; ecall (t0__bytestream_to_coefficients_proof param).
auto; ecall (t0__bytestream_to_coefficients_proof param).
by auto => /> *.
qed.

lemma t0__decode_proof _t0 _b_t0 _encoded _b_encoded :
      (t0__decode_spec _t0 _b_t0 _encoded _b_encoded).
proof.
hint +safety.
rewrite /t0__decode_spec; proc.
conseq (_ :
     b_encoded = BArray1664.init_arr (W8.of_int 255)
  ==> BArray4096.is_init b_t0 0 (4 * (4 * 256))
   /\ valid trace_t0__decode).
+ by move=> &hr />; rewrite -!(BI1664.is_init_full _ 1664) //.
unroll for ^while.
auto; ecall (t0____decode_polynomial_proof param_0 b_param_0 param b_param).
auto; ecall (t0____decode_polynomial_proof param_0 b_param_0 param b_param).
auto; ecall (t0____decode_polynomial_proof param_0 b_param_0 param b_param).
auto; ecall (t0____decode_polynomial_proof param_0 b_param_0 param b_param).
by auto => /> *.
qed.

lemma t1__coefficients_to_bytestream_proof _coefficients :
      (t1__coefficients_to_bytestream_spec _coefficients).
proof.
hint +safety.
rewrite /t1__coefficients_to_bytestream_spec; proc.
conseq (_ : _ ==> valid trace_t1__coefficients_to_bytestream).
by auto => /> *.
qed.

lemma t1__encode_polynomial_proof _t1_encoded _b_t1_encoded _t1 _b_t1 :
      (t1__encode_polynomial_spec _t1_encoded _b_t1_encoded _t1 _b_t1).
proof.
hint +safety.
rewrite /t1__encode_polynomial_spec; proc.
conseq (_ :
     b_t1 = BArray1024.init_arr (W8.of_int 255)
  ==> BArray320.is_init b_t1_encoded 0 (((23 - 13) * 256) %/ 8)
   /\ valid trace_t1__encode_polynomial).
+ by move=> &hr />; rewrite -!(BI1024.is_init_full _ 1024) //.
do 2! (unroll for ^while).
cfold* ^output_offset<-.
auto; ecall (t1__coefficients_to_bytestream_proof param_0).
auto; ecall (t1__coefficients_to_bytestream_proof param).
auto; ecall (t1__coefficients_to_bytestream_proof param).
auto; ecall (t1__coefficients_to_bytestream_proof param).
auto; ecall (t1__coefficients_to_bytestream_proof param).
auto; ecall (t1__coefficients_to_bytestream_proof param).
auto; ecall (t1__coefficients_to_bytestream_proof param).
auto; ecall (t1__coefficients_to_bytestream_proof param).
auto; ecall (t1__coefficients_to_bytestream_proof param).
auto; ecall (t1__coefficients_to_bytestream_proof param).
auto; ecall (t1__coefficients_to_bytestream_proof param).
auto; ecall (t1__coefficients_to_bytestream_proof param).
auto; ecall (t1__coefficients_to_bytestream_proof param).
auto; ecall (t1__coefficients_to_bytestream_proof param).
auto; ecall (t1__coefficients_to_bytestream_proof param).
auto; ecall (t1__coefficients_to_bytestream_proof param).
auto; ecall (t1__coefficients_to_bytestream_proof param).
auto; ecall (t1__coefficients_to_bytestream_proof param).
auto; ecall (t1__coefficients_to_bytestream_proof param).
auto; ecall (t1__coefficients_to_bytestream_proof param).
auto; ecall (t1__coefficients_to_bytestream_proof param).
auto; ecall (t1__coefficients_to_bytestream_proof param).
auto; ecall (t1__coefficients_to_bytestream_proof param).
auto; ecall (t1__coefficients_to_bytestream_proof param).
auto; ecall (t1__coefficients_to_bytestream_proof param).
auto; ecall (t1__coefficients_to_bytestream_proof param).
auto; ecall (t1__coefficients_to_bytestream_proof param).
auto; ecall (t1__coefficients_to_bytestream_proof param).
auto; ecall (t1__coefficients_to_bytestream_proof param).
auto; ecall (t1__coefficients_to_bytestream_proof param).
auto; ecall (t1__coefficients_to_bytestream_proof param).
auto; ecall (t1__coefficients_to_bytestream_proof param).
by auto => /> *.
qed.

lemma t1____encode_proof _encoded _b_encoded _t1 _b_t1 :
      (t1____encode_spec _encoded _b_encoded _t1 _b_t1).
proof.
hint +safety.
rewrite /t1____encode_spec; proc.
conseq (_ :
     b_t1 = BArray4096.init_arr (W8.of_int 255)
  ==> BArray1280.is_init b_encoded 0 (4 * (((23 - 13) * 256) %/ 8))
   /\ valid trace_t1____encode).
+ by move=> &hr />; rewrite -!(BI4096.is_init_full _ 4096) //.
unroll for ^while.
auto; ecall (t1__encode_polynomial_proof param_0 b_param_0 param b_param).
auto; ecall (t1__encode_polynomial_proof param_0 b_param_0 param b_param).
auto; ecall (t1__encode_polynomial_proof param_0 b_param_0 param b_param).
auto; ecall (t1__encode_polynomial_proof param_0 b_param_0 param b_param).
by auto => /> *.
qed.

lemma t1__decode_polynomial_proof _t1 _b_t1 _t1_encoded _b_t1_encoded :
      (t1__decode_polynomial_spec _t1 _b_t1 _t1_encoded _b_t1_encoded).
proof.
hint +safety.
rewrite /t1__decode_polynomial_spec; proc.
conseq (_ :
     b_t1_encoded = BArray320.init_arr (W8.of_int 255)
  ==> BArray1024.is_init b_t1 0 (4 * 256)
   /\ valid trace_t1__decode_polynomial).
+ by move=> &hr />; rewrite -!(BI320.is_init_full _ 320) //.
unroll for ^while.
cfold* ^input_offset<-.
by auto => /> *.
qed.

lemma signature____encode_hint_proof _signature _b_signature _hint _b_hint :
  signature____encode_hint_spec _signature _b_signature _hint _b_hint.
proof.
hint +safety.
rewrite /signature____encode_hint_spec; proc.
conseq (_ :
     b_hint = BArray4096.init_arr (W8.of_int 255)
  /\ BArray2420.is_init b_signature 0 2336
  ==> BArray2420.is_init b_signature 0 ((32 + (4 * ((18 * 256) %/ 8))) + (80 + 4))
   /\ valid trace_signature____encode_hint).
+ by move=> &hr />; rewrite -!(BI4096.is_init_full _ 4096) //.
do 2! (unroll for ^while).
(* the hint section of the signature is zeroed first, then written in place:
   the signature stays initialised throughout the three nested loops *)
while (b_hint = BArray4096.init_arr (W8.of_int 255) /\ BArray2420.is_init b_signature 0 2420
    /\ 0 <= hints_written <= 80 /\ 0 <= i <= 4 /\ condition_row = (i < 4)
    /\ valid trace_signature____encode_hint).
+ wp.
  while (b_hint = BArray4096.init_arr (W8.of_int 255) /\ BArray2420.is_init b_signature 0 2420
      /\ 0 <= hints_written <= 80 /\ 0 <= i < 4 /\ 0 <= j /\ 4 * j = offset - i * 1024
      /\ 0 <= offset /\ offset %% 32 = 0 /\ offset <= bound /\ bound = i * 1024 + 1024
      /\ condition_group = (offset < bound) /\ valid trace_signature____encode_hint).
  + wp.
    while (b_hint = BArray4096.init_arr (W8.of_int 255) /\ BArray2420.is_init b_signature 0 2420
        /\ 0 <= hints_written <= 80 /\ 0 <= i < 4 /\ 0 <= j /\ 4 * j = offset - i * 1024
        /\ 0 <= offset /\ offset %% 32 = 0 /\ offset < bound /\ bound = i * 1024 + 1024
        /\ valid trace_signature____encode_hint).
    + auto => /> &hr hinit hw0 hw hi0 hi hj0 hj ho0 hmod hob hvalid hbit.
      split; last smt().
      move=> hroom.
      rewrite BI2420.is_init_set8_in 1,2:/# /=.
      split; last smt().
      smt(BI2420.is_init_sub).
    auto => /> &hr hinit hw0 hw hi0 hi hj0 hj ho0 hmod hob hvalid hlt.
    smt().
  auto => /> &hr hinit hw0 hw hi0 hi hvalid hlt.
  rewrite /JUtils.(`<<`) /=.
  split; first smt().
  move=> b_sig hw' offset0 cg hinit' hw0' hw'' ho0 hmod hob hvalid'.
  rewrite BI2420.is_init_set8_in 1,2:/# /=.
  smt(BI2420.is_init_sub).
by auto => /> &hr hinit.
qed.

lemma signature____zero_proof _signature _b_signature :
  signature____zero_spec _signature _b_signature.
proof.
hint +safety.
rewrite /signature____zero_spec; proc.
(* the bytes of the signature are written one after the other *)
while (0 <= i <= 2420 /\ BArray2420.is_init b_signature 0 i /\ valid trace_signature____zero).
+ auto => /> &hr hi0 hi hinit hvalid hlt.
  by rewrite BI2420.is_init_set8_in 1,2:/# /=; smt(BI2420.is_init_le0).
by auto => /> *; smt().
qed.

lemma signature____encode_proof _signature _b_signature _commitment_hash _b_commitment_hash _signer_response _b_signer_response _hint _b_hint :
      (signature____encode_spec _signature _b_signature _commitment_hash
      _b_commitment_hash _signer_response _b_signer_response _hint _b_hint).
proof.
hint +safety.
rewrite /signature____encode_spec; proc.
conseq (_ :
     b_commitment_hash = BArray32.init_arr (W8.of_int 255)
  /\ b_signer_response = BArray4096.init_arr (W8.of_int 255)
  /\ b_hint = BArray4096.init_arr (W8.of_int 255)
  ==> BArray2420.is_init b_signature 0 ((32 + (4 * ((18 * 256) %/ 8))) + (80 + 4))
   /\ valid trace_signature____encode).
+ by move=> &hr />; rewrite -!(BI32.is_init_full _ 32) // -!(BI4096.is_init_full _ 4096) //.
unroll for ^while.
auto; ecall (signature____encode_hint_proof param_2 b_param param_1 ((BArray4096.init_arr (W8.of_int 255)))).
auto; ecall (gamma1____encode_proof param_0 b_param_0 param ((BArray4096.init_arr (W8.of_int 255)))).
by auto => /> *.
qed.

lemma signature____decode_hint_proof _hints _b_hints _hint_encoded _b_hint_encoded :
  signature____decode_hint_spec _hints _b_hints _hint_encoded _b_hint_encoded.
proof.
hint +safety.
rewrite /signature____decode_hint_spec; proc.
conseq (_ :
     b_hint_encoded = BArray84.init_arr (W8.of_int 255)
  ==> (!(ill_formed_hint = W64.zero) \/ (BArray4096.is_init b_hints 0 (4 * (4 * 256))))
   /\ valid trace_signature____decode_hint).
+ by move=> &hr />; rewrite -!(BI84.is_init_full _ 84) //.
have h10 : W64.one <> W64.zero by rewrite W64.to_uint_eq.
(* the hints are decoded row by row: a row is zeroed, then the positions of
   its hints are read from the encoding and set, until the encoding is found
   ill-formed; the padding of the encoding is checked last *)
wp.
while (b_hint_encoded = BArray84.init_arr (W8.of_int 255)
    /\ (ill_formed_hint = W64.zero \/ ill_formed_hint = W64.one)
    /\ 0 <= encoded_offset <= 80
    /\ not_done3 = (encoded_offset < 80 /\ ill_formed_hint = W64.zero)
    /\ (ill_formed_hint = W64.zero => BArray4096.is_init b_hints 0 4096)
    /\ valid trace_signature____decode_hint).
+ by auto => /> *; rewrite !setcc_or_eq0 //=; smt().
wp.
while (b_hint_encoded = BArray84.init_arr (W8.of_int 255)
    /\ (ill_formed_hint = W64.zero \/ ill_formed_hint = W64.one)
    /\ 0 <= encoded_offset <= 4 /\ 0 <= previous_true_hints_seen <= 80
    /\ not_done1 = (encoded_offset < 4 /\ ill_formed_hint = W64.zero)
    /\ (ill_formed_hint = W64.zero => BArray4096.is_init b_hints 0 (1024 * encoded_offset))
    /\ valid trace_signature____decode_hint).
+ (* a row: zeroed first *)
  seq 14 : (b_hint_encoded = BArray84.init_arr (W8.of_int 255)
      /\ ill_formed_hint = W64.zero /\ 0 <= encoded_offset < 4
      /\ 0 <= previous_true_hints_seen <= 80 /\ decoded_offset = 256 * encoded_offset
      /\ BArray4096.is_init b_hints 0 (1024 * (encoded_offset + 1))
      /\ 0 <= current_true_hints_seen < 256
      /\ condition_decreasing = (current_true_hints_seen < previous_true_hints_seen)
      /\ valid trace_signature____decode_hint).
  + wp.
    while (b_hint_encoded = BArray84.init_arr (W8.of_int 255)
        /\ ill_formed_hint = W64.zero /\ 0 <= encoded_offset < 4
        /\ 0 <= previous_true_hints_seen <= 80 /\ decoded_offset = 256 * encoded_offset
        /\ 0 <= j <= 256 /\ condition_zero = (j < 256)
        /\ BArray4096.is_init b_hints 0 (1024 * encoded_offset + 4 * j)
        /\ valid trace_signature____decode_hint).
    + auto => /> *.
      rewrite BI4096.is_init_set32d_in 1,2:/# /=.
      smt(BI4096.is_init_sub).
    auto => /> *.
    rewrite /JUtils.(`<<`) /SLH64.protect_64 /=.
    split; first smt().
    move=> *; rewrite ?W8u8.to_uint_zeroextu64; smt(to_uint_W8_lt256).
  (* then the hints of the row *)
  wp.
  if.
  + by auto => /> *; rewrite !setcc_or_eq0 //=; smt().
  sp.
  if.
  + by auto => /> *; rewrite !setcc_or_eq0 //=; smt().
  wp.
  while (b_hint_encoded = BArray84.init_arr (W8.of_int 255)
      /\ (ill_formed_hint = W64.zero \/ ill_formed_hint = W64.one)
      /\ 0 <= encoded_offset < 4 /\ decoded_offset = 256 * encoded_offset
      /\ 0 <= previous_true_hints_seen <= 80 /\ 0 <= current_true_hints_seen <= 80
      /\ previous_true_hints_seen <= j <= current_true_hints_seen
      /\ not_done2 = (j < current_true_hints_seen /\ ill_formed_hint = W64.zero)
      /\ BArray4096.is_init b_hints 0 (1024 * (encoded_offset + 1))
      /\ valid trace_signature____decode_hint).
  + auto => /> &hr *.
    rewrite /SLH64.protect_64 !W8u8.to_uint_zeroextu64 !setcc_or_eq0 //=.
    have hb := to_uint_W8_lt256 hint_encoded{hr}.[j{hr}].
    rewrite BI4096.is_init_set32d_in 1,2:/# /=.
    smt(BI4096.is_init_sub).
  auto => /> *; rewrite !setcc_or_eq0 //=.
  split; first smt().
  by move=> *; rewrite !setcc_or_eq0 //=; smt().
auto => /> *; rewrite !setcc_or_eq0 //=.
split; first smt().
(* the result is negated on return: 0 stays 0, 1 becomes all ones *)
move=> eo1 ill1 nd3 tr1 hnd hill h0 h80 hf hinit hv.
case: hill => hz; [right; exact (hinit hz) | left].
by rewrite hz W64.to_uint_eq W64.to_uintN /=.
qed.

lemma signature____decode_proof _signer_response _b_signer_response _hints _b_hints _signature_encoded _b_signature_encoded :
      (signature____decode_spec _signer_response _b_signer_response _hints
      _b_hints _signature_encoded _b_signature_encoded).
proof.
hint +safety.
rewrite /signature____decode_spec; proc.
conseq (_ :
     b_signature_encoded = BArray2420.init_arr (W8.of_int 255)
  ==> BArray4096.is_init b_signer_response 0 (4 * (4 * 256))
   /\ ((result <> (W64.of_int 0)) \/ (BArray4096.is_init b_hints 0 (4 * (4 * 256))))
   /\ valid trace_signature____decode).
+ by move=> &hr />; rewrite -!(BI2420.is_init_full _ 2420) //.
+ by move=> />.
auto; ecall (signature____decode_hint_proof param_2 b_param_0 param_1 b_param).
auto; ecall (gamma1____decode_proof param_0 b_param_2 param b_param_1).
by auto => /> *.
qed.

lemma s1____encode_proof _encoded _b_encoded _s1 _b_s1 :
      (s1____encode_spec _encoded _b_encoded _s1 _b_s1).
proof.
hint +safety.
rewrite /s1____encode_spec; proc.
conseq (_ :
     b_s1 = BArray4096.init_arr (W8.of_int 255)
  ==> BArray384.is_init b_encoded 0 (4 * 96)
   /\ valid trace_s1____encode).
+ by move=> &hr />; rewrite -!(BI4096.is_init_full _ 4096) //.
unroll for ^while.
auto; ecall (error_polynomial__encode_proof param_0 b_param_0 param b_param).
auto; ecall (error_polynomial__encode_proof param_0 b_param_0 param b_param).
auto; ecall (error_polynomial__encode_proof param_0 b_param_0 param b_param).
auto; ecall (error_polynomial__encode_proof param_0 b_param_0 param b_param).
by auto => /> *.
qed.

lemma s1____decode_proof _s1 _b_s1 _encoded _b_encoded :
      (s1____decode_spec _s1 _b_s1 _encoded _b_encoded).
proof.
hint +safety.
rewrite /s1____decode_spec; proc.
conseq (_ :
     b_encoded = BArray384.init_arr (W8.of_int 255)
  ==> BArray4096.is_init b_s1 0 (4 * (4 * 256))
   /\ valid trace_s1____decode).
+ by move=> &hr />; rewrite -!(BI384.is_init_full _ 384) //.
unroll for ^while.
auto; ecall (error_polynomial__decode_proof param_0 b_param_0 param b_param).
auto; ecall (error_polynomial__decode_proof param_0 b_param_0 param b_param).
auto; ecall (error_polynomial__decode_proof param_0 b_param_0 param b_param).
auto; ecall (error_polynomial__decode_proof param_0 b_param_0 param b_param).
by auto => /> *.
qed.

lemma s2____encode_proof _encoded _b_encoded _s2 _b_s2 :
      (s2____encode_spec _encoded _b_encoded _s2 _b_s2).
proof.
hint +safety.
rewrite /s2____encode_spec; proc.
conseq (_ :
     b_s2 = BArray4096.init_arr (W8.of_int 255)
  ==> BArray384.is_init b_encoded 0 (4 * 96)
   /\ valid trace_s2____encode).
+ by move=> &hr />; rewrite -!(BI4096.is_init_full _ 4096) //.
unroll for ^while.
auto; ecall (error_polynomial__encode_proof param_0 b_param_0 param b_param).
auto; ecall (error_polynomial__encode_proof param_0 b_param_0 param b_param).
auto; ecall (error_polynomial__encode_proof param_0 b_param_0 param b_param).
auto; ecall (error_polynomial__encode_proof param_0 b_param_0 param b_param).
by auto => /> *.
qed.

lemma s2____decode_proof _s2 _b_s2 _encoded _b_encoded :
      (s2____decode_spec _s2 _b_s2 _encoded _b_encoded).
proof.
hint +safety.
rewrite /s2____decode_spec; proc.
conseq (_ :
     b_encoded = BArray384.init_arr (W8.of_int 255)
  ==> BArray4096.is_init b_s2 0 (4 * (4 * 256))
   /\ valid trace_s2____decode).
+ by move=> &hr />; rewrite -!(BI384.is_init_full _ 384) //.
unroll for ^while.
auto; ecall (error_polynomial__decode_proof param_0 b_param_0 param b_param).
auto; ecall (error_polynomial__decode_proof param_0 b_param_0 param b_param).
auto; ecall (error_polynomial__decode_proof param_0 b_param_0 param b_param).
auto; ecall (error_polynomial__decode_proof param_0 b_param_0 param b_param).
by auto => /> *.
qed.

lemma error_4x____bytestream_to_coefficients_proof _bytestream :
      (error_4x____bytestream_to_coefficients_spec _bytestream).
proof.
hint +safety.
rewrite /error_4x____bytestream_to_coefficients_spec; proc.
conseq (_ : _ ==> valid trace_error_4x____bytestream_to_coefficients).
by auto => /> *.
qed.

lemma error_4x____reduce_coefficients_proof _coefficients :
      (error_4x____reduce_coefficients_spec _coefficients).
proof.
hint +safety.
rewrite /error_4x____reduce_coefficients_spec; proc.
conseq (_ : _ ==> valid trace_error_4x____reduce_coefficients).
by auto => /> *.
qed.

lemma error_4x____reduce_coefficient_proof _coefficient :
      (error_4x____reduce_coefficient_spec _coefficient).
proof.
hint +safety.
rewrite /error_4x____reduce_coefficient_spec; proc.
conseq (_ : _ ==> valid trace_error_4x____reduce_coefficient).
by auto => /> *.
qed.

lemma error_4x____write_out_8_coefficients_proof _error _b_error _bytes_filled _good_overall
    _coefficient_block :
  error_4x____write_out_8_coefficients_spec _error _b_error _bytes_filled _good_overall
    _coefficient_block.
proof.
hint +safety.
rewrite /error_4x____write_out_8_coefficients_spec; proc.
inline error_4x____reduce_coefficients.
conseq (_ : _
  ==> (W64.to_uint (W64.of_int 4)) <> 0
   /\ BArray1024.is_init b_error 0 (W64.to_uint bytes_filled)
   /\ bytes_filled \ule (W64.of_int (4 * 256))
   /\ (bytes_filled \umod (W64.of_int 4)) = (W64.of_int 0)
   /\ valid trace_error_4x____write_out_8_coefficients).
+ by move=> />.
(* eight coefficients (32 bytes) are written at bytes_filled, then bytes_filled
   advances by four bytes per accepted coefficient (at most eight) *)
auto => /> hinit hle hmod.
have hgood : to_uint (_good_overall `&` W64.of_int 255) < 256.
+ have -> : W64.of_int 255 = W64.of_int (2 ^ 8 - 1) by done.
  by rewrite W64.to_uint_and_mod //; smt(modz_cmp).
have hpop := to_uint_popcnt64_byte _ hgood.
have hle' : to_uint _bytes_filled <= 992 by move: hle; rewrite W64.uleE /= /#.
have hcmp := W64.to_uint_cmp _bytes_filled.
have hmod' : to_uint _bytes_filled %% 4 = 0.
+ by move: hmod; rewrite W64.umodE /ulift2 W64.to_uint_eq !W64.of_uintK /= /#.
have hsh3 : to_uint (_good_overall `&` W64.of_int 255 `<<` W8.of_int 3)
            = 8 * to_uint (_good_overall `&` W64.of_int 255).
+ by rewrite /(`<<`) /= W64.to_uint_shl // /ptr_modulus /= modz_small; smt(W64.to_uint_cmp).
have hsh2 : to_uint ((POPCNT_64 (_good_overall `&` W64.of_int 255)).`6 `<<` W8.of_int 2)
            = 4 * to_uint (POPCNT_64 (_good_overall `&` W64.of_int 255)).`6.
+ by rewrite /(`<<`) /= W64.to_uint_shl // /ptr_modulus /= modz_small; smt(W64.to_uint_cmp).
have hfinal : BArray1024.is_init
    (BArray1024.set256d _b_error (to_uint _bytes_filled)
       (W256.of_int 115792089237316195423570985008687907853269984665640564039457584007913129639935))
    0 (to_uint _bytes_filled + 4 * to_uint (POPCNT_64 (_good_overall `&` W64.of_int 255)).`6).
+ apply (BI1024.is_init_sub _ 0 (to_uint _bytes_filled + 32)) => //; last smt(W64.to_uint_cmp).
  by rewrite BI1024.is_init_set256d_in 1,2:/# /= hinit.
rewrite hsh3 W64.to_uintD_small hsh2 1:/# W64.uleE W64.umodE /ulift2 W64.to_uint_eq.
rewrite W64.to_uintD_small hsh2 1:/# !W64.of_uintK /=.
smt(W64.to_uint_cmp).
qed.

lemma error_4x__rejection_sample_multiple_blocks_proof _error _b_error _randombytes _b_randombytes :
  error_4x__rejection_sample_multiple_blocks_spec _error _b_error _randombytes _b_randombytes.
proof.
hint +safety.
rewrite /error_4x__rejection_sample_multiple_blocks_spec; proc.
inline error_4x____reduce_coefficient.
conseq (_ :
     b_randombytes = BArray272.init_arr (W8.of_int 255)
  ==> BArray1024.is_init b_error 0 (W64.to_uint ((W64.of_int 4) * filled))
   /\ filled \ule (W64.of_int 256)
   /\ valid trace_error_4x__rejection_sample_multiple_blocks).
+ by move=> &hr />; rewrite -!(BI272.is_init_full _ 272) //.
+ by move=> />.
have h01 : W64.zero <> W64.one by rewrite W64.to_uint_eq.
have hz0 : to_uint W64.zero = 0 by done.
(* second phase: two candidate coefficients per byte; the stop flag is only
   raised inside the loops *)
while (b_randombytes = BArray272.init_arr (W8.of_int 255)
    /\ to_uint filled <= 256 /\ BArray1024.is_init b_error 0 (4 * to_uint filled)
    /\ to_uint xof_offset <= 272
    /\ (stop_sampling = W64.zero \/ stop_sampling = W64.one)
    /\ condition_loop = (stop_sampling <> W64.one)
    /\ (stop_sampling = W64.zero => to_uint xof_offset < 272 /\ to_uint filled < 256)
    /\ valid trace_error_4x__rejection_sample_multiple_blocks).
+ auto => /> &hr hle hinit hxo hstop hbnd hvalid hne.
  have hz : stop_sampling{hr} = W64.zero by smt().
  have [hlt hlt2] := hbnd hz.
  have hf0 := W64.to_uint_cmp filled{hr}; have hx0 := W64.to_uint_cmp xof_offset{hr}.
  have hx1 : to_uint (xof_offset{hr} + W64.of_int 1) = to_uint xof_offset{hr} + 1.
  + by rewrite W64.to_uintD_small W64.of_uintK /= /#.
  have hf1 : to_uint (filled{hr} + W64.of_int 1) = to_uint filled{hr} + 1.
  + by rewrite W64.to_uintD_small W64.of_uintK /= /#.
  have hf2 : to_uint (filled{hr} + W64.of_int 1 + W64.of_int 1) = to_uint filled{hr} + 2.
  + by rewrite W64.to_uintD_small hf1 W64.of_uintK /= /#.
  have hs1 : BArray1024.is_init
      (BArray1024.set32d b_error{hr} (to_uint filled{hr} * 4) (W32.of_int 4294967295))
      0 (4 * (to_uint filled{hr} + 1)).
  + by rewrite BI1024.is_init_set32d_in 1,2:/# /=; smt(BI1024.is_init_le0).
  have hs2 : BArray1024.is_init
      (BArray1024.set32d
         (BArray1024.set32d b_error{hr} (to_uint filled{hr} * 4) (W32.of_int 4294967295))
         ((to_uint filled{hr} + 1) * 4) (W32.of_int 4294967295))
      0 (4 * (to_uint filled{hr} + 2)).
  + by rewrite BI1024.is_init_set32d_in 1,2:/# /=; smt(BI1024.is_init_le0).
  rewrite ?W64.uleE ?W64.ultE ?hx1 ?hf1 ?hf2 /=.
  smt().
(* first phase: 32 candidates per 16 bytes, written eight at a time by
   write_out, each call after the first guarded by the room left *)
wp.
while (b_randombytes = BArray272.init_arr (W8.of_int 255)
    /\ to_uint bytes_filled <= 1024 /\ to_uint bytes_filled %% 4 = 0
    /\ BArray1024.is_init b_error 0 (to_uint bytes_filled)
    /\ to_uint xof_offset <= 272
    /\ (stop_sampling = W64.zero \/ stop_sampling = W64.one)
    /\ condition_loop = (stop_sampling <> W64.one)
    /\ (stop_sampling = W64.zero => to_uint bytes_filled < 992 /\ to_uint xof_offset < 256)
    /\ valid trace_error_4x__rejection_sample_multiple_blocks).
+ wp.
  seq 30 : (b_randombytes = BArray272.init_arr (W8.of_int 255)
      /\ to_uint bytes_filled <= 1024 /\ to_uint bytes_filled %% 4 = 0
      /\ BArray1024.is_init b_error 0 (to_uint bytes_filled)
      /\ to_uint xof_offset <= 260 /\ stop_sampling = W64.zero
      /\ condition = (to_uint bytes_filled < 992)
      /\ valid trace_error_4x__rejection_sample_multiple_blocks).
  + auto; ecall (error_4x____write_out_8_coefficients_proof param_3 b_param_2 param_2 param_1 param_0).
    auto; ecall (error_4x____bytestream_to_coefficients_proof param).
    auto => /> &hr hle hmod hinit hxo hstop hbnd hvalid hne.
    have hz : stop_sampling{hr} = W64.zero by smt().
    have [hlt hlt2] := hbnd hz.
    have hx0 := W64.to_uint_cmp xof_offset{hr}; have hb0 := W64.to_uint_cmp bytes_filled{hr}.
    have hx4 : to_uint (xof_offset{hr} + W64.of_int 4) = to_uint xof_offset{hr} + 4.
    + by rewrite W64.to_uintD_small W64.of_uintK /= /#.
    rewrite ?W64.uleE ?W64.ultE ?W64.umodE /ulift2 ?W64.to_uint_eq ?W64.of_uintK hx4 /=.
    move=> r hv; (split; first smt()); move=> _ _ r1 hinit1 hle1 hmod1 hv1.
    move: hle1 hmod1; rewrite W64.uleE W64.to_uint_eq !W64.of_uintK /= => hle1 hmod1.
    by rewrite W64.ultE /=; do ! (split; first smt()); smt().
  if; last by auto => /> *; rewrite ?W64.uleE ?W64.ultE ?W64.of_uintK /=; smt().
  seq 20 : (b_randombytes = BArray272.init_arr (W8.of_int 255)
      /\ to_uint bytes_filled <= 1024 /\ to_uint bytes_filled %% 4 = 0
      /\ BArray1024.is_init b_error 0 (to_uint bytes_filled)
      /\ to_uint xof_offset <= 264 /\ stop_sampling = W64.zero
      /\ condition = (to_uint bytes_filled < 992)
      /\ valid trace_error_4x__rejection_sample_multiple_blocks).
  + auto; ecall (error_4x____write_out_8_coefficients_proof param_7 b_param_1 param_6 param_5 param_4).
    auto => /> &hr hle hmod hinit hxo hvalid hlt.
    have hx0 := W64.to_uint_cmp xof_offset{hr}; have hb0 := W64.to_uint_cmp bytes_filled{hr}.
    have hx4 : to_uint (xof_offset{hr} + W64.of_int 4) = to_uint xof_offset{hr} + 4.
    + by rewrite W64.to_uintD_small W64.of_uintK /= /#.
    rewrite ?W64.uleE ?W64.ultE ?W64.umodE /ulift2 ?W64.to_uint_eq ?W64.of_uintK hx4 /=.
    (split; first smt()); move=> _ _ r1 hinit1 hle1 hmod1 hv1.
    move: hle1 hmod1; rewrite W64.uleE W64.to_uint_eq !W64.of_uintK /= => hle1 hmod1.
    by rewrite W64.ultE /=; do ! (split; first smt()); smt().
  if; last by auto => /> *; rewrite ?W64.uleE ?W64.ultE ?W64.of_uintK /=; smt().
  seq 20 : (b_randombytes = BArray272.init_arr (W8.of_int 255)
      /\ to_uint bytes_filled <= 1024 /\ to_uint bytes_filled %% 4 = 0
      /\ BArray1024.is_init b_error 0 (to_uint bytes_filled)
      /\ to_uint xof_offset <= 268 /\ stop_sampling = W64.zero
      /\ condition = (to_uint bytes_filled < 992)
      /\ valid trace_error_4x__rejection_sample_multiple_blocks).
  + auto; ecall (error_4x____write_out_8_coefficients_proof param_11 b_param_0 param_10 param_9 param_8).
    auto => /> &hr hle hmod hinit hxo hvalid hlt.
    have hx0 := W64.to_uint_cmp xof_offset{hr}; have hb0 := W64.to_uint_cmp bytes_filled{hr}.
    have hx4 : to_uint (xof_offset{hr} + W64.of_int 4) = to_uint xof_offset{hr} + 4.
    + by rewrite W64.to_uintD_small W64.of_uintK /= /#.
    rewrite ?W64.uleE ?W64.ultE ?W64.umodE /ulift2 ?W64.to_uint_eq ?W64.of_uintK hx4 /=.
    (split; first smt()); move=> _ _ r1 hinit1 hle1 hmod1 hv1.
    move: hle1 hmod1; rewrite W64.uleE W64.to_uint_eq !W64.of_uintK /= => hle1 hmod1.
    by rewrite W64.ultE /=; do ! (split; first smt()); smt().
  if; last by auto => /> *; rewrite ?W64.uleE ?W64.ultE ?W64.of_uintK /=; smt().
  auto; ecall (error_4x____write_out_8_coefficients_proof param_15 b_param param_14 param_13 param_12).
  auto => /> &hr hle hmod hinit hxo hvalid hlt.
  have hx0 := W64.to_uint_cmp xof_offset{hr}; have hb0 := W64.to_uint_cmp bytes_filled{hr}.
  have hx4 : to_uint (xof_offset{hr} + W64.of_int 4) = to_uint xof_offset{hr} + 4.
  + by rewrite W64.to_uintD_small W64.of_uintK /= /#.
  rewrite ?W64.uleE ?W64.ultE ?W64.umodE /ulift2 ?W64.to_uint_eq ?W64.of_uintK hx4 /=.
  (split; first smt()); move=> _ _ r1 hinit1 hle1 hmod1 hv1.
  move: hle1 hmod1; rewrite W64.uleE W64.to_uint_eq !W64.of_uintK /= => hle1 hmod1.
  by rewrite ?W64.uleE ?W64.ultE /=; do ! (split; first smt()); smt().
(* between the phases *)
auto => /> b0 bf0 cl0 st0 tr0 xo0 hcl hle hmod hinit hxo hstop hne hbnd hv.
rewrite !W64.ultE ?W64.uleE !W64.shr_div !W64.of_uintK W8.of_uintK /=.
have hbf : 4 * (to_uint bf0 %/ 4) = to_uint bf0 by smt().
rewrite hbf.
have hexit : forall (b1 : BArray1024.t) (f0 : W64.t), to_uint f0 <= 256 =>
    BArray1024.is_init b1 0 (4 * to_uint f0) =>
    BArray1024.is_init b1 0 (to_uint (W64.of_int 4 * f0)) /\ (f0 \ule W64.of_int 256).
+ by move=> b1 f0 hf hb; rewrite to_uint_mul4 1:/# W64.uleE /=.
smt().
qed.

lemma error_4x__rejection_sample_one_block_proof _error _b_error _filled _randombytes _b_randombytes :
  error_4x__rejection_sample_one_block_spec _error _b_error _filled _randombytes _b_randombytes.
proof.
hint +safety.
rewrite /error_4x__rejection_sample_one_block_spec; proc.
inline error_4x____reduce_coefficient.
conseq (_ :
     b_randombytes = BArray136.init_arr (W8.of_int 255)
  /\ BArray1024.is_init b_error 0 (4 * to_uint filled)
  /\ to_uint filled < 256
  ==> BArray1024.is_init b_error 0 (W64.to_uint ((W64.of_int 4) * filled))
   /\ filled \ule (W64.of_int 256)
   /\ valid trace_error_4x__rejection_sample_one_block).
+ move=> &hr /> hb hinit hle.
  move: hle hinit; rewrite W64.ultE /= => hle; rewrite to_uint_mul4 1:/# => hinit.
  by rewrite -(BI136.is_init_full _ 136) // hb.
+ by move=> />.
have h01 : W64.zero <> W64.one by rewrite W64.to_uint_eq.
(* each byte of the block gives two candidate coefficients, kept when they
   are below the rejection bound, until the polynomial is full or the block
   exhausted; the stop flag is only raised, never reset, inside the loop *)
while (b_randombytes = BArray136.init_arr (W8.of_int 255)
    /\ to_uint filled <= 256 /\ BArray1024.is_init b_error 0 (4 * to_uint filled)
    /\ to_uint xof_offset <= 136
    /\ (stop_sampling = W64.zero \/ stop_sampling = W64.one)
    /\ condition_loop = (stop_sampling <> W64.one)
    /\ (stop_sampling = W64.zero => to_uint xof_offset < 136 /\ to_uint filled < 256)
    /\ valid trace_error_4x__rejection_sample_one_block).
+ auto => /> &hr hle hinit hxo hstop hbnd hvalid hne.
  have hz : stop_sampling{hr} = W64.zero by smt().
  have [hlt hlt2] := hbnd hz.
  have hf0 := W64.to_uint_cmp filled{hr}; have hx0 := W64.to_uint_cmp xof_offset{hr}.
  have hx1 : to_uint (xof_offset{hr} + W64.of_int 1) = to_uint xof_offset{hr} + 1.
  + by rewrite W64.to_uintD_small W64.of_uintK /= /#.
  have hf1 : to_uint (filled{hr} + W64.of_int 1) = to_uint filled{hr} + 1.
  + by rewrite W64.to_uintD_small W64.of_uintK /= /#.
  have hf2 : to_uint (filled{hr} + W64.of_int 1 + W64.of_int 1) = to_uint filled{hr} + 2.
  + by rewrite W64.to_uintD_small hf1 W64.of_uintK /= /#.
  have hs1 : BArray1024.is_init
      (BArray1024.set32d b_error{hr} (to_uint filled{hr} * 4) (W32.of_int 4294967295))
      0 (4 * (to_uint filled{hr} + 1)).
  + by rewrite BI1024.is_init_set32d_in 1,2:/# /=; smt(BI1024.is_init_le0).
  have hs2 : BArray1024.is_init
      (BArray1024.set32d
         (BArray1024.set32d b_error{hr} (to_uint filled{hr} * 4) (W32.of_int 4294967295))
         ((to_uint filled{hr} + 1) * 4) (W32.of_int 4294967295))
      0 (4 * (to_uint filled{hr} + 2)).
  + by rewrite BI1024.is_init_set32d_in 1,2:/# /=; smt(BI1024.is_init_le0).
  rewrite ?W64.uleE ?W64.ultE ?hx1 ?hf1 ?hf2 /=.
  smt().
auto => /> &hr hle hinit.
rewrite ?W64.uleE ?W64.ultE /= to_uint_mul4 1:/#.
by split; [smt() | move=> *; rewrite to_uint_mul4 1:/# W64.uleE /= /#].
qed.

lemma error_4x____shake256_squeeze_multiple_blocks_4x_proof _state _b_state _b0 _b_b0 _b1 _b_b1 _b2 _b_b2 _b3 _b_b3 :
      (error_4x____shake256_squeeze_multiple_blocks_4x_spec _state _b_state
      _b0 _b_b0 _b1 _b_b1 _b2 _b_b2 _b3 _b_b3).
proof.
hint +safety.
rewrite /error_4x____shake256_squeeze_multiple_blocks_4x_spec; proc.
conseq (_ :
     b_state = BArray800.init_arr (W8.of_int 255)
  ==> BArray800.is_init b_state 0 (32 * 25)
   /\ BArray272.is_init b_b0 0 (2 * 136)
   /\ BArray272.is_init b_b1 0 (2 * 136)
   /\ BArray272.is_init b_b2 0 (2 * 136)
   /\ BArray272.is_init b_b3 0 (2 * 136)
   /\ valid trace_error_4x____shake256_squeeze_multiple_blocks_4x).
+ by move=> &hr />; rewrite -!(BI800.is_init_full _ 800) //.
+ by move=> />.
unroll for ^while.
auto; ecall (shake256_squeezeblock4x_proof param_3 ((BArray800.init_arr (W8.of_int 255))) param_2 b_param_2 param_1 b_param_1 param_0 b_param_0 param b_param).
auto; ecall (shake256_squeezeblock4x_proof param_3 ((BArray800.init_arr (W8.of_int 255))) param_2 b_param_2 param_1 b_param_1 param_0 b_param_0 param b_param).
by auto => /> *.
qed.

lemma error_4x____sample_polynomials_proof _rho_prime _b_rho_prime _starting_domain_separator :
  error_4x____sample_polynomials_spec _rho_prime _b_rho_prime _starting_domain_separator.
proof.
hint +safety.
rewrite /error_4x____sample_polynomials_spec; proc.
have h01 : W64.zero <> W64.one by rewrite W64.to_uint_eq.
(* a polynomial is complete once its count of coefficients reaches 256 *)
have hfull : forall (b : BArray1024.t) (f : W64.t),
    BArray1024.is_init b 0 (to_uint (W64.of_int 4 * f)) => f \ule W64.of_int 256 =>
    !(f \ult W64.of_int 256) => BArray1024.is_init b 0 1024.
+ move=> b f hb; rewrite W64.uleE W64.ultE /= => hle hlt.
  by move: hb; rewrite to_uint_mul4 1:/# => hb; smt().
(* the loop squeezes one more block per polynomial and extends the
   incomplete ones; it stops when the four are complete *)
while (b_buf0 = BArray272.init_arr (W8.of_int 255) /\ b_buf1 = BArray272.init_arr (W8.of_int 255)
    /\ b_buf2 = BArray272.init_arr (W8.of_int 255) /\ b_buf3 = BArray272.init_arr (W8.of_int 255)
    /\ BArray1024.is_init b_polynomial0 0 (to_uint (W64.of_int 4 * filled0))
    /\ filled0 \ule W64.of_int 256
    /\ BArray1024.is_init b_polynomial1 0 (to_uint (W64.of_int 4 * filled1))
    /\ filled1 \ule W64.of_int 256
    /\ BArray1024.is_init b_polynomial2 0 (to_uint (W64.of_int 4 * filled2))
    /\ filled2 \ule W64.of_int 256
    /\ BArray1024.is_init b_polynomial3 0 (to_uint (W64.of_int 4 * filled3))
    /\ filled3 \ule W64.of_int 256
    /\ (stop_sampling = W64.zero \/ stop_sampling = W64.one)
    /\ (stop_sampling = W64.one =>
          !(filled0 \ult W64.of_int 256) /\ !(filled1 \ult W64.of_int 256)
          /\ !(filled2 \ult W64.of_int 256) /\ !(filled3 \ult W64.of_int 256))
    /\ valid trace_error_4x____sample_polynomials).
+ seq 32 : (b_buf0 = BArray272.init_arr (W8.of_int 255) /\ b_buf1 = BArray272.init_arr (W8.of_int 255)
      /\ b_buf2 = BArray272.init_arr (W8.of_int 255) /\ b_buf3 = BArray272.init_arr (W8.of_int 255)
      /\ BArray1024.is_init b_polynomial0 0 (to_uint (W64.of_int 4 * filled0))
      /\ filled0 \ule W64.of_int 256
      /\ BArray1024.is_init b_polynomial1 0 (to_uint (W64.of_int 4 * filled1))
      /\ filled1 \ule W64.of_int 256
      /\ BArray1024.is_init b_polynomial2 0 (to_uint (W64.of_int 4 * filled2))
      /\ filled2 \ule W64.of_int 256
      /\ BArray1024.is_init b_polynomial3 0 (to_uint (W64.of_int 4 * filled3))
      /\ filled3 \ule W64.of_int 256
      /\ valid trace_error_4x____sample_polynomials).
  + auto; ecall (shake256_squeezeblock4x_proof param_19 (BArray800.init_arr (W8.of_int 255))
                   param_18 b_param_10 param_17 b_param_9 param_16 b_param_8 param_15 b_param_7).
    by auto => /> *; smt().
  seq 1 : (b_buf0 = BArray272.init_arr (W8.of_int 255) /\ b_buf1 = BArray272.init_arr (W8.of_int 255)
      /\ b_buf2 = BArray272.init_arr (W8.of_int 255) /\ b_buf3 = BArray272.init_arr (W8.of_int 255)
      /\ BArray1024.is_init b_polynomial0 0 (to_uint (W64.of_int 4 * filled0))
      /\ filled0 \ule W64.of_int 256
      /\ BArray1024.is_init b_polynomial1 0 (to_uint (W64.of_int 4 * filled1))
      /\ filled1 \ule W64.of_int 256
      /\ BArray1024.is_init b_polynomial2 0 (to_uint (W64.of_int 4 * filled2))
      /\ filled2 \ule W64.of_int 256
      /\ BArray1024.is_init b_polynomial3 0 (to_uint (W64.of_int 4 * filled3))
      /\ filled3 \ule W64.of_int 256
      /\ valid trace_error_4x____sample_polynomials).
  + if; last by auto.
    auto; ecall (error_4x__rejection_sample_one_block_proof param_22 b_param_6 param_21 param_20 b_param_5).
    by auto => /> *; rewrite SBI272_136.get_sub_init_arr //=; smt().
  seq 1 : (b_buf0 = BArray272.init_arr (W8.of_int 255) /\ b_buf1 = BArray272.init_arr (W8.of_int 255)
      /\ b_buf2 = BArray272.init_arr (W8.of_int 255) /\ b_buf3 = BArray272.init_arr (W8.of_int 255)
      /\ BArray1024.is_init b_polynomial0 0 (to_uint (W64.of_int 4 * filled0))
      /\ filled0 \ule W64.of_int 256
      /\ BArray1024.is_init b_polynomial1 0 (to_uint (W64.of_int 4 * filled1))
      /\ filled1 \ule W64.of_int 256
      /\ BArray1024.is_init b_polynomial2 0 (to_uint (W64.of_int 4 * filled2))
      /\ filled2 \ule W64.of_int 256
      /\ BArray1024.is_init b_polynomial3 0 (to_uint (W64.of_int 4 * filled3))
      /\ filled3 \ule W64.of_int 256
      /\ valid trace_error_4x____sample_polynomials).
  + if; last by auto.
    auto; ecall (error_4x__rejection_sample_one_block_proof param_25 b_param_4 param_24 param_23 b_param_3).
    by auto => /> *; rewrite SBI272_136.get_sub_init_arr //=; smt().
  seq 1 : (b_buf0 = BArray272.init_arr (W8.of_int 255) /\ b_buf1 = BArray272.init_arr (W8.of_int 255)
      /\ b_buf2 = BArray272.init_arr (W8.of_int 255) /\ b_buf3 = BArray272.init_arr (W8.of_int 255)
      /\ BArray1024.is_init b_polynomial0 0 (to_uint (W64.of_int 4 * filled0))
      /\ filled0 \ule W64.of_int 256
      /\ BArray1024.is_init b_polynomial1 0 (to_uint (W64.of_int 4 * filled1))
      /\ filled1 \ule W64.of_int 256
      /\ BArray1024.is_init b_polynomial2 0 (to_uint (W64.of_int 4 * filled2))
      /\ filled2 \ule W64.of_int 256
      /\ BArray1024.is_init b_polynomial3 0 (to_uint (W64.of_int 4 * filled3))
      /\ filled3 \ule W64.of_int 256
      /\ valid trace_error_4x____sample_polynomials).
  + if; last by auto.
    auto; ecall (error_4x__rejection_sample_one_block_proof param_28 b_param_2 param_27 param_26 b_param_1).
    by auto => /> *; rewrite SBI272_136.get_sub_init_arr //=; smt().
  seq 1 : (b_buf0 = BArray272.init_arr (W8.of_int 255) /\ b_buf1 = BArray272.init_arr (W8.of_int 255)
      /\ b_buf2 = BArray272.init_arr (W8.of_int 255) /\ b_buf3 = BArray272.init_arr (W8.of_int 255)
      /\ BArray1024.is_init b_polynomial0 0 (to_uint (W64.of_int 4 * filled0))
      /\ filled0 \ule W64.of_int 256
      /\ BArray1024.is_init b_polynomial1 0 (to_uint (W64.of_int 4 * filled1))
      /\ filled1 \ule W64.of_int 256
      /\ BArray1024.is_init b_polynomial2 0 (to_uint (W64.of_int 4 * filled2))
      /\ filled2 \ule W64.of_int 256
      /\ BArray1024.is_init b_polynomial3 0 (to_uint (W64.of_int 4 * filled3))
      /\ filled3 \ule W64.of_int 256
      /\ valid trace_error_4x____sample_polynomials).
  + if; last by auto.
    auto; ecall (error_4x__rejection_sample_one_block_proof param_31 b_param_0 param_30 param_29 b_param).
    by auto => /> *; rewrite SBI272_136.get_sub_init_arr //=; smt().
  by auto => /> *; smt().
(* the first blocks are squeezed four at a time and consumed in full *)
auto; ecall (error_4x__rejection_sample_multiple_blocks_proof param_14 b_param_11 param_13
               (BArray272.init_arr (W8.of_int 255))).
auto; ecall (error_4x__rejection_sample_multiple_blocks_proof param_12 b_param_12 param_11
               (BArray272.init_arr (W8.of_int 255))).
auto; ecall (error_4x__rejection_sample_multiple_blocks_proof param_10 b_param_13 param_9
               (BArray272.init_arr (W8.of_int 255))).
auto; ecall (error_4x__rejection_sample_multiple_blocks_proof param_8 b_param_14 param_7
               (BArray272.init_arr (W8.of_int 255))).
auto; ecall (error_4x____shake256_squeeze_multiple_blocks_4x_proof param_6
               (BArray800.init_arr (W8.of_int 255)) param_5 b_param_18 param_4 b_param_17
               param_3 b_param_16 param_2 b_param_15).
auto; ecall (shake256_absorb_66_4x_proof param_1 b_param_19 param_0
               (BArray64.init_arr (W8.of_int 255)) param).
by auto => /> *; smt().
qed.

lemma sample____error_vectors_proof _rho_prime _b_rho_prime :
      (sample____error_vectors_spec _rho_prime _b_rho_prime).
proof.
hint +safety.
rewrite /sample____error_vectors_spec; proc.
conseq (_ :
     b_rho_prime = BArray64.init_arr (W8.of_int 255)
  ==> BArray4096.is_init b_s2 0 4096
   /\ BArray4096.is_init b_s1 0 4096
   /\ valid trace_sample____error_vectors).
+ by move=> &hr />; rewrite -!(BI64.is_init_full _ 64) //.
+ by move=> />.
auto; ecall (error_4x____sample_polynomials_proof param_2 ((BArray64.init_arr (W8.of_int 255))) param_1).
auto; ecall (error_4x____sample_polynomials_proof param_0 ((BArray64.init_arr (W8.of_int 255))) param).
by auto => /> *.
qed.

lemma sample____matrix_A_proof _rho _b_rho :
      (sample____matrix_A_spec _rho _b_rho).
proof.
hint +safety.
rewrite /sample____matrix_A_spec; proc.
conseq (_ :
     b_rho = BArray32.init_arr (W8.of_int 255)
  ==> BArray16384.is_init b_matrix_A 0 16384
   /\ valid trace_sample____matrix_A).
+ by move=> &hr />; rewrite -!(BI32.is_init_full _ 32) //.
do 5! (unroll for ^while).
auto; ecall (matrix_A____sample_4_polynomials_proof param_0 b_param_0 param b_param).
auto; ecall (matrix_A____sample_4_polynomials_proof param_0 b_param_0 param b_param).
auto; ecall (matrix_A____sample_4_polynomials_proof param_0 b_param_0 param b_param).
auto; ecall (matrix_A____sample_4_polynomials_proof param_0 b_param_0 param b_param).
by auto => /> *.
qed.

lemma __keygen_prf_proof _prf_output _b_prf_output _randomness _b_randomness :
      (__keygen_prf_spec _prf_output _b_prf_output _randomness _b_randomness).
proof.
hint +safety.
rewrite /__keygen_prf_spec; proc.
conseq (_ :
     b_randomness = BArray32.init_arr (W8.of_int 255)
  ==> BArray128.is_init b_prf_output 0 128
   /\ valid trace___keygen_prf).
+ by move=> &hr />; rewrite -!(BI32.is_init_full _ 32) //.
auto; ecall (_shake256_A128__A32_A2_proof param_1 b_param_0 param_0 ((BArray32.init_arr (W8.of_int 255))) param b_param).
by auto => /> *.
qed.

lemma __compute_t0_t1_proof _matrix_A _b_matrix_A _s1 _b_s1 _s2 _b_s2 :
      (__compute_t0_t1_spec _matrix_A _b_matrix_A _s1 _b_s1 _s2 _b_s2).
proof.
hint +safety.
rewrite /__compute_t0_t1_spec; proc.
conseq (_ :
     b_s2 = BArray4096.init_arr (W8.of_int 255)
  /\ b_s1 = BArray4096.init_arr (W8.of_int 255)
  /\ b_matrix_A = BArray16384.init_arr (W8.of_int 255)
  ==> BArray4096.is_init b_t0 0 4096
   /\ BArray4096.is_init b_t1 0 4096
   /\ valid trace___compute_t0_t1).
+ by move=> &hr />; rewrite -!(BI4096.is_init_full _ 4096) // -!(BI16384.is_init_full _ 16384) //.
+ by move=> />.
auto; ecall (column_vector____power2round_proof param_6 ((BArray4096.init_arr (W8.of_int 255)))).
auto; ecall (column_vector____conditionally_add_modulus_proof param_5 ((BArray4096.init_arr (W8.of_int 255)))).
auto; ecall (column_vector____add_proof param_4 ((BArray4096.init_arr (W8.of_int 255))) param_3 ((BArray4096.init_arr (W8.of_int 255)))).
auto; ecall (column_vector__invert_ntt_montgomery_proof param_2 ((BArray4096.init_arr (W8.of_int 255)))).
auto; ecall (column_vector__reduce32_proof param_1 ((BArray4096.init_arr (W8.of_int 255)))).
auto; ecall (row_vector____multiply_with_matrix_A_proof param_0 ((BArray16384.init_arr (W8.of_int 255))) param ((BArray4096.init_arr (W8.of_int 255)))).
by auto => /> *.
qed.

lemma __encode_s1_into_signing_key_proof _signing_key _b_signing_key _s1 _b_s1 :
      (__encode_s1_into_signing_key_spec _signing_key _b_signing_key 
      _s1 _b_s1).
proof.
hint +safety.
rewrite /__encode_s1_into_signing_key_spec; proc.
conseq (_ :
     b_s1 = BArray4096.init_arr (W8.of_int 255)
  /\ BArray2560.is_init b_signing_key 0 (32 + 32)
  ==> BArray2560.is_init b_signing_key 0 (32 + 32)
   /\ BArray2560.is_init b_signing_key ((32 + 32) + 64) (4 * 96)
   /\ valid trace___encode_s1_into_signing_key).
+ by move=> &hr />; rewrite -!(BI4096.is_init_full _ 4096) //.
+ by move=> />.
auto; ecall (s1____encode_proof param_0 b_param param ((BArray4096.init_arr (W8.of_int 255)))).
by auto => /> *.
qed.

lemma __encode_s2_into_signing_key_proof _signing_key _b_signing_key _s2 _b_s2 :
      (__encode_s2_into_signing_key_spec _signing_key _b_signing_key 
      _s2 _b_s2).
proof.
hint +safety.
rewrite /__encode_s2_into_signing_key_spec; proc.
conseq (_ :
     b_s2 = BArray4096.init_arr (W8.of_int 255)
  /\ BArray2560.is_init b_signing_key 0 (32 + 32)
  /\ BArray2560.is_init b_signing_key ((32 + 32) + 64) (4 * 96)
  ==> BArray2560.is_init b_signing_key 0 (32 + 32)
   /\ BArray2560.is_init b_signing_key ((32 + 32) + 64) ((4 * 96) + (4 * 96))
   /\ valid trace___encode_s2_into_signing_key).
+ by move=> &hr />; rewrite -!(BI4096.is_init_full _ 4096) //.
+ by move=> />.
auto; ecall (s2____encode_proof param_0 b_param param ((BArray4096.init_arr (W8.of_int 255)))).
by auto => /> *.
qed.

lemma __keygen_internal_proof _verification_key _b_verification_key _signing_key _b_signing_key _randomness _b_randomness :
      (__keygen_internal_spec _verification_key _b_verification_key
      _signing_key _b_signing_key _randomness _b_randomness).
proof.
hint +safety.
rewrite /__keygen_internal_spec; proc.
conseq (_ :
     b_randomness = BArray32.init_arr (W8.of_int 255)
  ==> BArray1312.is_init b_verification_key 0 (32 + (4 * (((23 - 13) * 256) %/ 8)))
   /\ BArray2560.is_init b_signing_key 0 (((((32 + 32) + 64) + (4 * 96)) + (4 * 96)) + (4 * ((13 * 256) %/ 8)))
   /\ valid trace___keygen_internal).
+ by move=> &hr />; rewrite -!(BI32.is_init_full _ 32) //.
+ by move=> />.
auto; ecall (t0____encode_proof param_16 b_param param_15 ((BArray4096.init_arr (W8.of_int 255)))).
auto; ecall (hash_verification_key_proof param_14 b_param_1 param_13 b_param_0).
auto; ecall (t1____encode_proof param_12 b_param_2 param_11 ((BArray4096.init_arr (W8.of_int 255)))).
auto; ecall (__compute_t0_t1_proof param_10 ((BArray16384.init_arr (W8.of_int 255))) param_9 ((BArray4096.init_arr (W8.of_int 255))) param_8 ((BArray4096.init_arr (W8.of_int 255)))).
auto; ecall (row_vector__ntt_proof param_7 ((BArray4096.init_arr (W8.of_int 255)))).
auto; ecall (__encode_s2_into_signing_key_proof param_6 b_param_3 param_5 ((BArray4096.init_arr (W8.of_int 255)))).
auto; ecall (__encode_s1_into_signing_key_proof param_4 b_param_4 param_3 ((BArray4096.init_arr (W8.of_int 255)))).
auto; ecall (sample____error_vectors_proof param_2 b_param_5).
auto; ecall (sample____matrix_A_proof param_1 b_param_6).
auto; ecall (__keygen_prf_proof param_0 b_param_7 param ((BArray32.init_arr (W8.of_int 255)))).
by auto => /> *.
qed.

lemma sample____mask_proof _rho_prime _b_rho_prime _domain_separator :
      (sample____mask_spec _rho_prime _b_rho_prime _domain_separator).
proof.
hint +safety.
rewrite /sample____mask_spec; proc.
conseq (_ :
     b_rho_prime = BArray64.init_arr (W8.of_int 255)
  ==> BArray4096.is_init b_mask 0 4096
   /\ valid trace_sample____mask).
+ by move=> &hr />; rewrite -!(BI64.is_init_full _ 64) //.
auto; ecall (__sample_mask_polynomial_4x_proof param_0 ((BArray64.init_arr (W8.of_int 255))) param).
by auto => /> *.
qed.

lemma commitment__coefficients_to_bytestream_bits6_proof _c0 _c1 _c2 _c3 :
      (commitment__coefficients_to_bytestream_bits6_spec _c0 _c1 _c2 _c3).
proof.
hint +safety.
rewrite /commitment__coefficients_to_bytestream_bits6_spec; proc.
conseq (_ : _ ==> valid trace_commitment__coefficients_to_bytestream_bits6).
by auto => /> *.
qed.

lemma commitment____encode_polynomial_bits6_proof _encoded _b_encoded _raw _b_raw :
      (commitment____encode_polynomial_bits6_spec _encoded _b_encoded 
      _raw _b_raw).
proof.
hint +safety.
rewrite /commitment____encode_polynomial_bits6_spec; proc.
conseq (_ :
     b_raw = BArray1024.init_arr (W8.of_int 255)
  ==> BArray192.is_init b_encoded 0 ((6 * 256) %/ 8)
   /\ valid trace_commitment____encode_polynomial_bits6).
+ by move=> &hr />; rewrite -!(BI1024.is_init_full _ 1024) //.
do 2! (unroll for ^while).
auto; ecall (commitment__coefficients_to_bytestream_bits6_proof param_6 param_5 param_4 param_3).
auto; ecall (commitment__coefficients_to_bytestream_bits6_proof param_2 param_1 param_0 param).
auto; ecall (commitment__coefficients_to_bytestream_bits6_proof param_2 param_1 param_0 param).
auto; ecall (commitment__coefficients_to_bytestream_bits6_proof param_2 param_1 param_0 param).
auto; ecall (commitment__coefficients_to_bytestream_bits6_proof param_2 param_1 param_0 param).
auto; ecall (commitment__coefficients_to_bytestream_bits6_proof param_2 param_1 param_0 param).
auto; ecall (commitment__coefficients_to_bytestream_bits6_proof param_2 param_1 param_0 param).
auto; ecall (commitment__coefficients_to_bytestream_bits6_proof param_2 param_1 param_0 param).
by auto => /> *.
qed.

lemma commitment____encode_polynomial_proof _encoded _b_encoded _commitment _b_commitment :
      (commitment____encode_polynomial_spec _encoded _b_encoded _commitment
      _b_commitment).
proof.
hint +safety.
rewrite /commitment____encode_polynomial_spec; proc.
conseq (_ :
     b_commitment = BArray1024.init_arr (W8.of_int 255)
  ==> BArray192.is_init b_encoded 0 ((6 * 256) %/ 8)
   /\ valid trace_commitment____encode_polynomial).
+ by move=> &hr />; rewrite -!(BI1024.is_init_full _ 1024) //.
auto; ecall (commitment____encode_polynomial_bits6_proof param_0 b_param param ((BArray1024.init_arr (W8.of_int 255)))).
by auto => /> *.
qed.

lemma commitment____encode_proof _commitment _b_commitment :
      (commitment____encode_spec _commitment _b_commitment).
proof.
hint +safety.
rewrite /commitment____encode_spec; proc.
conseq (_ :
     b_commitment = BArray4096.init_arr (W8.of_int 255)
  ==> BArray768.is_init b_encoded_commitment 0 768
   /\ valid trace_commitment____encode).
+ by move=> &hr />; rewrite -!(BI4096.is_init_full _ 4096) //.
unroll for ^while.
auto; ecall (commitment____encode_polynomial_proof param_0 b_param_0 param b_param).
auto; ecall (commitment____encode_polynomial_proof param_0 b_param_0 param b_param).
auto; ecall (commitment____encode_polynomial_proof param_0 b_param_0 param b_param).
auto; ecall (commitment____encode_polynomial_proof param_0 b_param_0 param b_param).
by auto => /> *.
qed.

lemma derive_seed_for_mask_proof _k _b_k _randomness _b_randomness _message_representative _b_message_representative _seed_for_mask _b_seed_for_mask :
      (derive_seed_for_mask_spec _k _b_k _randomness _b_randomness
      _message_representative _b_message_representative _seed_for_mask
      _b_seed_for_mask).
proof.
hint +safety.
rewrite /derive_seed_for_mask_spec; proc.
conseq (_ :
     b_k = BArray32.init_arr (W8.of_int 255)
  /\ b_randomness = BArray32.init_arr (W8.of_int 255)
  /\ b_message_representative = BArray64.init_arr (W8.of_int 255)
  ==> BArray64.is_init b_seed_for_mask 0 64
   /\ valid trace_derive_seed_for_mask).
+ by move=> &hr />; rewrite -!(BI32.is_init_full _ 32) // -!(BI64.is_init_full _ 64) //.
auto; ecall (_shake256_A64__A128_proof param_0 b_param_0 param b_param).
by auto => /> *.
qed.

lemma __compute_signer_response_element_proof _s1_element _b_s1_element _verifier_challenge _b_verifier_challenge _mask_element _b_mask_element _signer_response_element _b_signer_response_element :
      (__compute_signer_response_element_spec _s1_element _b_s1_element
      _verifier_challenge _b_verifier_challenge _mask_element _b_mask_element
      _signer_response_element _b_signer_response_element).
proof.
hint +safety.
rewrite /__compute_signer_response_element_spec; proc.
conseq (_ :
     b_s1_element = BArray1024.init_arr (W8.of_int 255)
  /\ b_verifier_challenge = BArray1024.init_arr (W8.of_int 255)
  /\ b_mask_element = BArray1024.init_arr (W8.of_int 255)
  ==> BArray1024.is_init b_signer_response_element 0 (4 * 256)
   /\ valid trace___compute_signer_response_element).
+ by move=> &hr />; rewrite -!(BI1024.is_init_full _ 1024) //.
auto; ecall (polynomial____add_reduce32_check_infinity_norm_proof param_6 b_param param_5 ((BArray1024.init_arr (W8.of_int 255))) param_4 ((BArray1024.init_arr (W8.of_int 255))) param_3).
auto; ecall (polynomial__invert_ntt_montgomery_proof param_2 ((BArray1024.init_arr (W8.of_int 255)))).
auto; ecall (polynomial__pointwise_montgomery_multiply_and_reduce_proof param_1 b_param_0 param_0 ((BArray1024.init_arr (W8.of_int 255))) param ((BArray1024.init_arr (W8.of_int 255)))).
by auto => /> *.
qed.

lemma __compute_z_and_check_norm_proof _s1 _b_s1 _verifier_challenge _b_verifier_challenge _mask
    _b_mask _signer_response _b_signer_response _infinity_norm_check_result :
  __compute_z_and_check_norm_spec _s1 _b_s1 _verifier_challenge _b_verifier_challenge _mask
    _b_mask _signer_response _b_signer_response _infinity_norm_check_result.
proof.
hint +safety.
rewrite /__compute_z_and_check_norm_spec; proc.
conseq (_ :
     _infinity_norm_check_result = infinity_norm_check_result
  /\ b_s1 = BArray4096.init_arr (W8.of_int 255)
  /\ b_verifier_challenge = BArray1024.init_arr (W8.of_int 255)
  /\ b_mask = BArray4096.init_arr (W8.of_int 255)
  ==> ((infinity_norm_check_result <> (W64.of_int 0)) \/ (BArray4096.is_init b_signer_response 0 (4 * (4 * 256))))
   /\ ((_infinity_norm_check_result = (W64.of_int 0)) \/ (infinity_norm_check_result <> (W64.of_int 0)))
   /\ valid trace___compute_z_and_check_norm).
+ by move=> &hr />; rewrite -!(BI4096.is_init_full _ 4096) // -!(BI1024.is_init_full _ 1024) //.
+ by move=> />.
(* one element of the response per iteration; the loop stops early when the
   norm check of an element fails, and the response is complete otherwise; a
   failure reported on entry is kept *)
while (b_s1 = BArray4096.init_arr (W8.of_int 255)
    /\ b_verifier_challenge = BArray1024.init_arr (W8.of_int 255)
    /\ b_mask = BArray4096.init_arr (W8.of_int 255)
    /\ 0 <= base <= 1024 /\ base %% 256 = 0
    /\ (base < 1024 => infinity_norm_check_result = W64.of_int 0)
    /\ (infinity_norm_check_result = W64.of_int 0
        => BArray4096.is_init b_signer_response 0 (4 * base))
    /\ (_infinity_norm_check_result = W64.of_int 0 \/ infinity_norm_check_result <> W64.of_int 0)
    /\ valid trace___compute_z_and_check_norm).
+ auto; ecall (__compute_signer_response_element_proof param_2 b_param_1 param_1
                 (BArray1024.init_arr (W8.of_int 255)) param_0 b_param_0 param b_param).
  auto => /> &hr h0 h1024 hmod hres hinit hmono hvalid hlt.
  rewrite SBI4096_1024.get_sub_init_arr 1,2:/# /=.
  move=> r hr2 hv.
  have hi := hinit (hres hlt).
  rewrite SBI4096_1024.is_init_set_sub_in 1,2,3,4:/# /= hi /=.
  smt().
by auto => /> *; smt().
qed.

lemma __apply_cs2_and_check_norm_proof _w0_minus_cs2 _b_w0_minus_cs2 _w0 _b_w0 _s2 _b_s2
    _verifier_challenge _b_verifier_challenge _infinity_norm_check_result :
  __apply_cs2_and_check_norm_spec _w0_minus_cs2 _b_w0_minus_cs2 _w0 _b_w0 _s2 _b_s2
    _verifier_challenge _b_verifier_challenge _infinity_norm_check_result.
proof.
hint +safety.
rewrite /__apply_cs2_and_check_norm_spec; proc.
conseq (_ :
     _infinity_norm_check_result = infinity_norm_check_result
  /\ b_w0 = BArray4096.init_arr (W8.of_int 255)
  /\ b_s2 = BArray4096.init_arr (W8.of_int 255)
  /\ b_verifier_challenge = BArray1024.init_arr (W8.of_int 255)
  ==> ((infinity_norm_check_result <> (W64.of_int 0)) \/ (BArray4096.is_init b_w0_minus_cs2 0 (4 * (4 * 256))))
   /\ ((_infinity_norm_check_result = (W64.of_int 0)) \/ (infinity_norm_check_result <> (W64.of_int 0)))
   /\ valid trace___apply_cs2_and_check_norm).
+ by move=> &hr />; rewrite -!(BI4096.is_init_full _ 4096) // -!(BI1024.is_init_full _ 1024) //.
+ by move=> />.
(* one row per iteration; the loop stops early when the norm check of a row
   fails, and the difference is complete otherwise; a failure reported on
   entry is kept *)
while (b_w0 = BArray4096.init_arr (W8.of_int 255) /\ b_s2 = BArray4096.init_arr (W8.of_int 255)
    /\ b_verifier_challenge = BArray1024.init_arr (W8.of_int 255)
    /\ 0 <= base <= 1024 /\ base %% 256 = 0
    /\ (base < 1024 => infinity_norm_check_result = W64.of_int 0)
    /\ (infinity_norm_check_result = W64.of_int 0
        => BArray4096.is_init b_w0_minus_cs2 0 (4 * base))
    /\ (_infinity_norm_check_result = W64.of_int 0 \/ infinity_norm_check_result <> W64.of_int 0)
    /\ valid trace___apply_cs2_and_check_norm).
+ auto; ecall (polynomial____subtract_reduce32_check_infinity_norm_proof param_6 b_param_0 param_5
                 b_param param_4 (BArray1024.init_arr (W8.of_int 255)) param_3).
  auto; ecall (polynomial__invert_ntt_montgomery_proof param_2 (BArray1024.init_arr (W8.of_int 255))).
  auto; ecall (polynomial__pointwise_montgomery_multiply_and_reduce_proof param_1 b_param_2 param_0
                 b_param_1 param (BArray1024.init_arr (W8.of_int 255))).
  auto => /> &hr h0 h1024 hmod hres hinit hmono hvalid hlt.
  rewrite SBI4096_1024.get_sub_init_arr 1,2:/# /=.
  move=> r0 hb0 hv0 r1 hb1 hv1 r2 hb2 hv2.
  have hi := hinit (hres hlt).
  rewrite SBI4096_1024.is_init_set_sub_in 1,2,3,4:/# /= hi /=.
  smt().
by auto => /> *; smt().
qed.

lemma __apply_ct0_and_check_norm_proof _w0_minus_cs2_plus_ct0 _b_w0_minus_cs2_plus_ct0
    _w0_minus_cs2 _b_w0_minus_cs2 _t0 _b_t0 _verifier_challenge _b_verifier_challenge
    _infinity_norm_check_result :
  __apply_ct0_and_check_norm_spec _w0_minus_cs2_plus_ct0 _b_w0_minus_cs2_plus_ct0
    _w0_minus_cs2 _b_w0_minus_cs2 _t0 _b_t0 _verifier_challenge _b_verifier_challenge
    _infinity_norm_check_result.
proof.
hint +safety.
rewrite /__apply_ct0_and_check_norm_spec; proc.
conseq (_ :
     _infinity_norm_check_result = infinity_norm_check_result
  /\ (_infinity_norm_check_result <> W64.of_int 0 \/ b_w0_minus_cs2 = BArray4096.init_arr (W8.of_int 255))
  /\ b_t0 = BArray4096.init_arr (W8.of_int 255)
  /\ b_verifier_challenge = BArray1024.init_arr (W8.of_int 255)
  ==> ((_infinity_norm_check_result <> (W64.of_int 0)) \/ (BArray4096.is_init b_w0_minus_cs2_plus_ct0 0 (4 * (4 * 256))))
   /\ valid trace___apply_ct0_and_check_norm).
+ by move=> &hr />; rewrite -!(BI4096.is_init_full _ 4096) // -!(BI1024.is_init_full _ 1024) //.
(* one row per iteration; the whole loop is skipped when an earlier norm
   check failed, and the difference is read only in the loop *)
wp; while ((infinity_norm_check_result = W64.of_int 0
            => b_w0_minus_cs2 = BArray4096.init_arr (W8.of_int 255))
    /\ b_t0 = BArray4096.init_arr (W8.of_int 255)
    /\ b_verifier_challenge = BArray1024.init_arr (W8.of_int 255)
    /\ _infinity_norm_check_result = infinity_norm_check_result
    /\ 0 <= base <= 1024 /\ base %% 256 = 0
    /\ (base < 1024 => infinity_norm_check_result = W64.of_int 0)
    /\ (infinity_norm_check_result = W64.of_int 0
        => BArray4096.is_init b_w0_minus_cs2_plus_ct0 0 (4 * base))
    /\ valid trace___apply_ct0_and_check_norm).
+ auto; ecall (polynomial____add_reduce32_check_infinity_norm_rhs_proof param_7 b_param_0 param_6
                 b_param param_5 (BArray1024.init_arr (W8.of_int 255)) param_4 param_3).
  auto; ecall (polynomial__invert_ntt_montgomery_proof param_2 (BArray1024.init_arr (W8.of_int 255))).
  auto; ecall (polynomial__pointwise_montgomery_multiply_and_reduce_proof param_1 b_param_2 param_0
                 b_param_1 param (BArray1024.init_arr (W8.of_int 255))).
  auto => /> &hr hw h0 h1024 hmod hres hinit hvalid hlt.
  have -> := hw (hres hlt).
  rewrite SBI4096_1024.get_sub_init_arr 1,2:/# /=.
  move=> r0 hb0 hv0 r1 hb1 hv1 r2 hb2 hv2.
  rewrite SBI4096_1024.is_init_set_sub_in 1,2,3,4:/# /=.
  smt().
by auto => /> *; smt(BI4096.is_init_init_arr).
qed.

lemma __make_hint_vector_proof _w0_minus_cs2_plus_ct0 _b_w0_minus_cs2_plus_ct0 _w1 _b_w1 _hint
    _b_hint _infinity_norm_check_result :
  __make_hint_vector_spec _w0_minus_cs2_plus_ct0 _b_w0_minus_cs2_plus_ct0 _w1 _b_w1 _hint
    _b_hint _infinity_norm_check_result.
proof.
hint +safety.
rewrite /__make_hint_vector_spec; proc.
conseq (_ :
     _infinity_norm_check_result = infinity_norm_check_result
  /\ (_infinity_norm_check_result <> W64.of_int 0 \/ b_w0_minus_cs2_plus_ct0 = BArray4096.init_arr (W8.of_int 255))
  /\ b_w1 = BArray4096.init_arr (W8.of_int 255)
  ==> ((infinity_norm_check_result <> (W64.of_int 0)) \/ (BArray4096.is_init b_hint 0 (4 * (4 * 256))))
   /\ ((_infinity_norm_check_result = (W64.of_int 0)) \/ (infinity_norm_check_result <> (W64.of_int 0)))
   /\ valid trace___make_hint_vector).
+ by move=> &hr />; rewrite -!(BI4096.is_init_full _ 4096) //.
+ by move=> />.
(* one row of hints per iteration, at most 256 hints per row; the loop stops
   early when the hint weight exceeds its bound, and the sum it reads is
   needed only then; a failure reported on entry is kept *)
while ((infinity_norm_check_result = W64.of_int 0
        => b_w0_minus_cs2_plus_ct0 = BArray4096.init_arr (W8.of_int 255))
    /\ b_w1 = BArray4096.init_arr (W8.of_int 255)
    /\ 0 <= base <= 1024 /\ base %% 256 = 0
    /\ 0 <= total_ones_in_hint <= base
    /\ (base < 1024 => infinity_norm_check_result = W64.of_int 0)
    /\ (infinity_norm_check_result = W64.of_int 0 => BArray4096.is_init b_hint 0 (4 * base))
    /\ (_infinity_norm_check_result = W64.of_int 0 \/ infinity_norm_check_result <> W64.of_int 0)
    /\ valid trace___make_hint_vector).
+ auto; ecall (polynomial____make_hint_proof param_1 b_param_1 param_0 b_param_0 param b_param).
  auto => /> &hr hw h0 h1024 hmod ht0 ht hres hinit hmono hvalid hlt.
  have -> := hw (hres hlt).
  rewrite SBI4096_1024.get_sub_init_arr 1,2:/# /=.
  move=> r hr2 hv.
  have hi := hinit (hres hlt).
  rewrite SBI4096_1024.is_init_set_sub_in 1,2,3,4:/# /= hi /=.
  smt().
by auto => /> *; smt(BI4096.is_init_init_arr).
qed.

lemma __sign_internal_proof _signature _b_signature _signing_key _b_signing_key _context_pointer
    _context_size _message_pointer _message_size _randomness _b_randomness :
  __sign_internal_spec _signature _b_signature _signing_key _b_signing_key _context_pointer
    _context_size _message_pointer _message_size _randomness _b_randomness.
proof.
hint +safety.
rewrite /__sign_internal_spec; proc.
have hz : W64.zero = W64.of_int 0 by done.
conseq (_ :
     b_signing_key = BArray2560.init_arr (W8.of_int 255)
  /\ b_randomness = BArray32.init_arr (W8.of_int 255)
  /\ 0 <= context_pointer <= 18446744073709551615
  /\ 0 <= context_size <= 18446744073709551615
  /\ 0 <= message_pointer <= 18446744073709551615
  /\ 0 <= message_size <= 18446744073709551615
  ==> _).
+ by move=> &hr />; rewrite -!(BI2560.is_init_full _ 2560) // -!(BI32.is_init_full _ 32) //.
(* the rejection sampling loop runs until an attempt passes every norm check
   or the budget of attempts is exhausted; the signature is encoded from the
   last attempt *)
seq 275 : (exit_rejection_sampling_loop <> W64.zero
    /\ b_commitment_hash = BArray32.init_arr (W8.of_int 255)
    /\ (last_norm_check_result = W64.zero =>
          BArray4096.is_init b_signer_response 0 4096 /\ BArray4096.is_init b_hint 0 4096)
    /\ valid trace___sign_internal).
+ while ((exit_rejection_sampling_loop <> W64.zero =>
            b_commitment_hash = BArray32.init_arr (W8.of_int 255)
            /\ (last_norm_check_result = W64.zero =>
                  BArray4096.is_init b_signer_response 0 4096
                  /\ BArray4096.is_init b_hint 0 4096))
      /\ valid trace___sign_internal).
  + (* one attempt; the norm checks are chained: a failed check is reported
       by every later one *)
    seq 12 : (BArray4096.is_init b_mask_as_ntt 0 4096 /\ valid trace___sign_internal).
    + (* the mask is copied 32 bytes at a time *)
      while (0 <= j <= 4096 /\ j %% 32 = 0 /\ BArray4096.is_init b_mask_as_ntt 0 j
          /\ valid trace___sign_internal).
      + auto => /> &hr h0 h1 hmod hinit hv hlt.
        by rewrite BI4096.is_init_set256d_in 1,2:/# /=; smt(BI4096.is_init_le0).
      auto; ecall (sample____mask_proof param_20 (BArray64.init_arr (W8.of_int 255)) param_19).
      by auto => /> *; smt().
    auto; ecall (__make_hint_vector_proof param_52 b_param_5 param_51
                  (BArray4096.init_arr (W8.of_int 255)) param_50 b_param_4 param_49).
    auto; ecall (__apply_ct0_and_check_norm_proof param_48 b_param_7 param_47 b_param_6 param_46
                  (BArray4096.init_arr (W8.of_int 255)) param_45 (BArray1024.init_arr (W8.of_int 255))
                  param_44).
    auto; ecall (__apply_cs2_and_check_norm_proof param_43 b_param_8 param_42
                  (BArray4096.init_arr (W8.of_int 255)) param_41 (BArray4096.init_arr (W8.of_int 255))
                  param_40 (BArray1024.init_arr (W8.of_int 255)) param_39).
    auto; ecall (__compute_z_and_check_norm_proof param_38 (BArray4096.init_arr (W8.of_int 255))
                  param_37 (BArray1024.init_arr (W8.of_int 255)) param_36
                  (BArray4096.init_arr (W8.of_int 255)) param_35 b_param_9 param_34).
    auto; ecall (polynomial__ntt_proof param_33 (BArray1024.init_arr (W8.of_int 255))).
    auto; ecall (sample____challenge_proof param_32 b_param_10 param_31
                  (BArray32.init_arr (W8.of_int 255))).
    auto; ecall (__derive_commitment_hash_proof param_30 b_param_11 param_29
                  (BArray64.init_arr (W8.of_int 255)) param_28 (BArray768.init_arr (W8.of_int 255))).
    auto; ecall (commitment____encode_proof param_27 (BArray4096.init_arr (W8.of_int 255))).
    auto; ecall (column_vector____decompose_proof param_26 (BArray4096.init_arr (W8.of_int 255))).
    auto; ecall (column_vector__invert_ntt_montgomery_proof param_25
                  (BArray4096.init_arr (W8.of_int 255))).
    auto; ecall (column_vector__reduce32_proof param_24 (BArray4096.init_arr (W8.of_int 255))).
    auto; ecall (row_vector____multiply_with_matrix_A_proof param_23
                  (BArray16384.init_arr (W8.of_int 255)) param_22 (BArray4096.init_arr (W8.of_int 255))).
    auto; ecall (row_vector__ntt_proof param_21 b_param_12).
    by auto => /> *; smt(orw_eq0).
  (* the key is decoded and the seeds derived before the loop *)
  auto; ecall (column_vector__ntt_proof param_18 (BArray4096.init_arr (W8.of_int 255))).
  auto; ecall (column_vector__ntt_proof param_17 (BArray4096.init_arr (W8.of_int 255))).
  auto; ecall (row_vector__ntt_proof param_16 (BArray4096.init_arr (W8.of_int 255))).
  auto; ecall (t0__decode_proof param_15 b_param_14 param_14 b_param_13).
  auto; ecall (s2____decode_proof param_13 b_param_16 param_12 b_param_15).
  auto; ecall (s1____decode_proof param_11 b_param_18 param_10 b_param_17).
  auto; ecall (derive_seed_for_mask_proof param_9 b_param_20 param_8
                (BArray32.init_arr (W8.of_int 255)) param_7 (BArray64.init_arr (W8.of_int 255))
                param_6 b_param_19).
  auto; ecall (__derive_message_representative_proof param_5 b_param_22 param_4 b_param_21 param_3
                param_2 param_1 param_0).
  auto; ecall (sample____matrix_A_proof param b_param_23).
  by auto => /> *; smt().
(* the signature is encoded only when the exiting attempt passed every norm
   check; otherwise every byte of it is set to zero *)
sp; if.
+ auto; ecall (signature____encode_proof param_56 b_param_2 param_55 b_param_1 param_54 b_param_0
                param_53 b_param).
  by auto => /> /#.
auto; ecall (signature____zero_proof param_57 b_param_3).
by auto => /> *.
qed.

lemma __compare_commitment_hashes_proof _lhs _b_lhs _rhs _b_rhs :
      (__compare_commitment_hashes_spec _lhs _b_lhs _rhs _b_rhs).
proof.
hint +safety.
rewrite /__compare_commitment_hashes_spec; proc.
conseq (_ :
     b_rhs = BArray32.init_arr (W8.of_int 255)
  /\ b_lhs = BArray32.init_arr (W8.of_int 255)
  ==> valid trace___compare_commitment_hashes).
+ by move=> &hr />; rewrite -!(BI32.is_init_full _ 32) //.
unroll ^while; rcondt ^if; first by auto.
rcondf ^while; first by auto.
cfold* ^offset<-.
by auto => /> *.
qed.

lemma reconstruct_signer_commitment_proof _t1_encoded _b_t1_encoded _challenge_as_ntt _b_challenge_as_ntt _a_times_signer_response _b_A_times_signer_response _hints _b_hints :
      (reconstruct_signer_commitment_spec _t1_encoded _b_t1_encoded
      _challenge_as_ntt _b_challenge_as_ntt _a_times_signer_response
      _b_A_times_signer_response _hints _b_hints).
proof.
hint +safety.
rewrite /reconstruct_signer_commitment_spec; proc.
conseq (_ :
     b_hints = BArray4096.init_arr (W8.of_int 255)
  /\ b_A_times_signer_response = BArray4096.init_arr (W8.of_int 255)
  /\ b_challenge_as_ntt = BArray1024.init_arr (W8.of_int 255)
  /\ b_t1_encoded = BArray1280.init_arr (W8.of_int 255)
  ==> BArray768.is_init b_commitment_encoded 0 768
   /\ valid trace_reconstruct_signer_commitment).
+ by move=> &hr />; rewrite -!(BI1024.is_init_full _ 1024) // -!(BI1280.is_init_full _ 1280) // -!(BI4096.is_init_full _ 4096) //.
unroll for ^while.
auto; ecall (commitment____encode_proof param_14 b_param).
auto; ecall (polynomial__use_hints_proof param_13 ((BArray1024.init_arr (W8.of_int 255))) param_12 b_param_0).
auto; ecall (polynomial__conditionally_add_modulus_proof param_11 ((BArray1024.init_arr (W8.of_int 255)))).
auto; ecall (polynomial__invert_ntt_montgomery_proof param_10 ((BArray1024.init_arr (W8.of_int 255)))).
auto; ecall (polynomial__reduce32_proof param_9 ((BArray1024.init_arr (W8.of_int 255)))).
auto; ecall (polynomial__subtract_proof param_8 b_param_2 param_7 b_param_1 param_6 ((BArray1024.init_arr (W8.of_int 255)))).
auto; ecall (polynomial__pointwise_montgomery_multiply_and_reduce_proof param_5 b_param_3 param_4 ((BArray1024.init_arr (W8.of_int 255))) param_3 ((BArray1024.init_arr (W8.of_int 255)))).
auto; ecall (polynomial__ntt_proof param_2 ((BArray1024.init_arr (W8.of_int 255)))).
auto; ecall (polynomial____shift_coefficients_left_proof param_1 ((BArray1024.init_arr (W8.of_int 255)))).
auto; ecall (t1__decode_polynomial_proof param_0 b_param_5 param b_param_4).
auto; ecall (polynomial__use_hints_proof param_13 ((BArray1024.init_arr (W8.of_int 255))) param_12 b_param_0).
auto; ecall (polynomial__conditionally_add_modulus_proof param_11 ((BArray1024.init_arr (W8.of_int 255)))).
auto; ecall (polynomial__invert_ntt_montgomery_proof param_10 ((BArray1024.init_arr (W8.of_int 255)))).
auto; ecall (polynomial__reduce32_proof param_9 ((BArray1024.init_arr (W8.of_int 255)))).
auto; ecall (polynomial__subtract_proof param_8 b_param_2 param_7 b_param_1 param_6 ((BArray1024.init_arr (W8.of_int 255)))).
auto; ecall (polynomial__pointwise_montgomery_multiply_and_reduce_proof param_5 b_param_3 param_4 ((BArray1024.init_arr (W8.of_int 255))) param_3 ((BArray1024.init_arr (W8.of_int 255)))).
auto; ecall (polynomial__ntt_proof param_2 ((BArray1024.init_arr (W8.of_int 255)))).
auto; ecall (polynomial____shift_coefficients_left_proof param_1 ((BArray1024.init_arr (W8.of_int 255)))).
auto; ecall (t1__decode_polynomial_proof param_0 b_param_5 param b_param_4).
auto; ecall (polynomial__use_hints_proof param_13 ((BArray1024.init_arr (W8.of_int 255))) param_12 b_param_0).
auto; ecall (polynomial__conditionally_add_modulus_proof param_11 ((BArray1024.init_arr (W8.of_int 255)))).
auto; ecall (polynomial__invert_ntt_montgomery_proof param_10 ((BArray1024.init_arr (W8.of_int 255)))).
auto; ecall (polynomial__reduce32_proof param_9 ((BArray1024.init_arr (W8.of_int 255)))).
auto; ecall (polynomial__subtract_proof param_8 b_param_2 param_7 b_param_1 param_6 ((BArray1024.init_arr (W8.of_int 255)))).
auto; ecall (polynomial__pointwise_montgomery_multiply_and_reduce_proof param_5 b_param_3 param_4 ((BArray1024.init_arr (W8.of_int 255))) param_3 ((BArray1024.init_arr (W8.of_int 255)))).
auto; ecall (polynomial__ntt_proof param_2 ((BArray1024.init_arr (W8.of_int 255)))).
auto; ecall (polynomial____shift_coefficients_left_proof param_1 ((BArray1024.init_arr (W8.of_int 255)))).
auto; ecall (t1__decode_polynomial_proof param_0 b_param_5 param b_param_4).
auto; ecall (polynomial__use_hints_proof param_13 ((BArray1024.init_arr (W8.of_int 255))) param_12 b_param_0).
auto; ecall (polynomial__conditionally_add_modulus_proof param_11 ((BArray1024.init_arr (W8.of_int 255)))).
auto; ecall (polynomial__invert_ntt_montgomery_proof param_10 ((BArray1024.init_arr (W8.of_int 255)))).
auto; ecall (polynomial__reduce32_proof param_9 ((BArray1024.init_arr (W8.of_int 255)))).
auto; ecall (polynomial__subtract_proof param_8 b_param_2 param_7 b_param_1 param_6 ((BArray1024.init_arr (W8.of_int 255)))).
auto; ecall (polynomial__pointwise_montgomery_multiply_and_reduce_proof param_5 b_param_3 param_4 ((BArray1024.init_arr (W8.of_int 255))) param_3 ((BArray1024.init_arr (W8.of_int 255)))).
auto; ecall (polynomial__ntt_proof param_2 ((BArray1024.init_arr (W8.of_int 255)))).
auto; ecall (polynomial____shift_coefficients_left_proof param_1 ((BArray1024.init_arr (W8.of_int 255)))).
auto; ecall (t1__decode_polynomial_proof param_0 b_param_5 param b_param_4).
by auto => /> *.
qed.

lemma __verify_internal_proof _verification_key _b_verification_key _context_pointer _context_size
    _message_pointer _message_size _signature_encoded _b_signature_encoded :
  __verify_internal_spec _verification_key _b_verification_key _context_pointer _context_size
    _message_pointer _message_size _signature_encoded _b_signature_encoded.
proof.
hint +safety.
rewrite /__verify_internal_spec; proc.
have hz : W64.zero = W64.of_int 0 by done.
(* the signature is decoded and the norm of the response checked; the
   commitment is reconstructed only when both succeed *)
seq 108 : (b_verification_key = BArray1312.init_arr (W8.of_int 255)
    /\ b_signature_encoded = BArray2420.init_arr (W8.of_int 255)
    /\ 0 <= context_pointer <= 18446744073709551615 /\ 0 <= context_size <= 18446744073709551615
    /\ 0 <= message_pointer <= 18446744073709551615 /\ 0 <= message_size <= 18446744073709551615
    /\ (result = W64.zero => BArray4096.is_init b_hints 0 4096)
    /\ valid trace___verify_internal).
+ auto; ecall (row_vector____check_infinity_norm_proof param_3 (BArray4096.init_arr (W8.of_int 255))
                param_2).
  auto; ecall (signature____decode_proof param_1 b_param_9 param_0 b_param_8 param
                (BArray2420.init_arr (W8.of_int 255))).
  auto => />.
  rewrite -!(BI1312.is_init_full _ 1312) // -!(BI2420.is_init_full _ 2420) //.
  by move=> *; smt(orw_eq0).
if; last by auto => /> /#.
auto; ecall (__compare_commitment_hashes_proof param_27 (BArray32.init_arr (W8.of_int 255))
              param_26 b_param).
auto; ecall (__derive_commitment_hash_proof param_25 b_param_0 param_24
              (BArray64.init_arr (W8.of_int 255)) param_23 (BArray768.init_arr (W8.of_int 255))).
auto; ecall (__derive_message_representative_proof param_22 b_param_1 param_21
              (BArray64.init_arr (W8.of_int 255)) param_20 param_19 param_18 param_17).
auto; ecall (hash_verification_key_proof param_16 b_param_2 param_15
              (BArray1312.init_arr (W8.of_int 255))).
auto; ecall (reconstruct_signer_commitment_proof param_14 b_param_4 param_13
              (BArray1024.init_arr (W8.of_int 255)) param_12 (BArray4096.init_arr (W8.of_int 255))
              param_11 b_param_3).
auto; ecall (polynomial__ntt_proof param_10 (BArray1024.init_arr (W8.of_int 255))).
auto; ecall (sample____challenge_proof param_9 b_param_6 param_8 b_param_5).
auto; ecall (row_vector____multiply_with_matrix_A_proof param_7
              (BArray16384.init_arr (W8.of_int 255)) param_6 (BArray4096.init_arr (W8.of_int 255))).
auto; ecall (row_vector__ntt_proof param_5 (BArray4096.init_arr (W8.of_int 255))).
auto; ecall (sample____matrix_A_proof param_4 b_param_7).
by auto => /> *; smt().
qed.

lemma ml_dsa_44_keygen_proof _verification_key _b_verification_key _signing_key _b_signing_key _randomness _b_randomness :
      (ml_dsa_44_keygen_spec _verification_key _b_verification_key
      _signing_key _b_signing_key _randomness _b_randomness).
proof.
hint +safety.
rewrite /ml_dsa_44_keygen_spec; proc.
conseq (_ :
     b_randomness = BArray32.init_arr (W8.of_int 255)
  ==> BArray1312.is_init b_verification_key 0 (32 + (4 * (((23 - 13) * 256) %/ 8)))
   /\ BArray2560.is_init b_signing_key 0 (((((32 + 32) + 64) + (4 * 96)) + (4 * 96)) + (4 * ((13 * 256) %/ 8)))
   /\ valid trace_ml_dsa_44_keygen).
+ by move=> &hr />; rewrite -!(BI32.is_init_full _ 32) //.
+ by move=> />.
auto; ecall (__keygen_internal_proof param_1 b_param_0 param_0 b_param param ((BArray32.init_arr (W8.of_int 255)))).
by auto => /> *.
qed.

lemma ml_dsa_44_sign_proof _signature _b_signature _signing_key _b_signing_key _context
    _b_context _message_pointer _message_size _randomness _b_randomness :
  ml_dsa_44_sign_spec _signature _b_signature _signing_key _b_signing_key _context
    _b_context _message_pointer _message_size _randomness _b_randomness.
proof.
hint +safety.
rewrite /ml_dsa_44_sign_spec; proc.
have hne : W64.of_int 18446744073709551615 <> W64.of_int 0.
+ by rewrite W64.to_uint_eq !W64.of_uintK /=.
(* the context holds a pointer and a size; a context longer than 255 bytes
   is rejected without signing *)
sp; if.
+ auto; ecall (__sign_internal_proof param_5 b_param param_4 (BArray2560.init_arr (W8.of_int 255))
                param_3 param_2 param_1 param_0 param (BArray32.init_arr (W8.of_int 255))).
  auto => /> *.
  have /= := W64.to_uint_cmp (BArray16.get64d _context 8).
  by have /= := W64.to_uint_cmp (BArray16.get64d _context 0); smt().
by auto => /> /#.
qed.

lemma ml_dsa_44_verify_proof _verification_key _b_verification_key _context _b_context
    _message_pointer _message_size _signature _b_signature :
  ml_dsa_44_verify_spec _verification_key _b_verification_key _context _b_context
    _message_pointer _message_size _signature _b_signature.
proof.
hint +safety.
rewrite /ml_dsa_44_verify_spec; proc.
(* the context holds a pointer and a size; a context longer than 255 bytes
   is rejected without verifying *)
sp; if.
+ auto; ecall (__verify_internal_proof param_4 (BArray1312.init_arr (W8.of_int 255)) param_3
                param_2 param_1 param_0 param (BArray2420.init_arr (W8.of_int 255))).
  auto => /> *.
  have /= := W64.to_uint_cmp (BArray16.get64d _context 8).
  by have /= := W64.to_uint_cmp (BArray16.get64d _context 0); smt().
by auto => /> /#.
qed.

