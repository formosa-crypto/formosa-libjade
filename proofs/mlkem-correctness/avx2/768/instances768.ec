require import AllCore.
require Base768 MLKEM_ntt_levelsT MLKEM_ntt_avx2T MLKEM_invntt_levelsT MLKEM_invntt_avx2T MLKEM_basemul_avx2T NTT_avx2_polyT Fq_avx2T MLKEM_Poly_avx2T MLKEM_Poly_avx2_circuitT.

(* The generic theories of the parameter-free AVX2 code, at the
   ML-KEM-768 parameters and model. *)

clone export MLKEM_ntt_levelsT.MLKEM_ntt_levelsT as MLKEM_ntt_levelsI with
  theory B <- Base768.Base768.

clone export MLKEM_ntt_avx2T.MLKEM_ntt_avx2T as MLKEM_ntt_avx2I with
  theory B <- Base768.Base768,
  theory MLKEM_ntt_levels <- MLKEM_ntt_levelsI.

clone export MLKEM_invntt_levelsT.MLKEM_invntt_levelsT as MLKEM_invntt_levelsI with
  theory B <- Base768.Base768,
  theory MLKEM_ntt_levels <- MLKEM_ntt_levelsI.

clone export MLKEM_invntt_avx2T.MLKEM_invntt_avx2T as MLKEM_invntt_avx2I with
  theory B <- Base768.Base768,
  theory MLKEM_ntt_levels <- MLKEM_ntt_levelsI,
  theory MLKEM_ntt_avx2 <- MLKEM_ntt_avx2I,
  theory MLKEM_invntt_levels <- MLKEM_invntt_levelsI.

clone export MLKEM_basemul_avx2T.MLKEM_basemul_avx2T as MLKEM_basemul_avx2I with
  theory B <- Base768.Base768,
  theory MLKEM_ntt_levels <- MLKEM_ntt_levelsI,
  theory MLKEM_ntt_avx2 <- MLKEM_ntt_avx2I.

clone export NTT_avx2_polyT.NTT_avx2_polyT as NTT_avx2_polyI with
  theory B <- Base768.Base768,
  theory MLKEM_ntt_levels <- MLKEM_ntt_levelsI,
  theory MLKEM_ntt_avx2 <- MLKEM_ntt_avx2I,
  theory MLKEM_invntt_levels <- MLKEM_invntt_levelsI,
  theory MLKEM_invntt_avx2 <- MLKEM_invntt_avx2I,
  theory MLKEM_basemul_avx2 <- MLKEM_basemul_avx2I.

clone export Fq_avx2T.Fq_avx2T as Fq_avx2I with
  theory B <- Base768.Base768.

clone export MLKEM_Poly_avx2T.MLKEM_Poly_avx2T as MLKEM_Poly_avx2I with
  theory B <- Base768.Base768,
  theory Fq_avx2 <- Fq_avx2I,
  theory MLKEM_ntt_levels <- MLKEM_ntt_levelsI,
  theory MLKEM_ntt_avx2 <- MLKEM_ntt_avx2I,
  theory MLKEM_invntt_levels <- MLKEM_invntt_levelsI,
  theory MLKEM_invntt_avx2 <- MLKEM_invntt_avx2I,
  theory MLKEM_basemul_avx2 <- MLKEM_basemul_avx2I,
  theory NTT_avx2_poly <- NTT_avx2_polyI.

clone export MLKEM_Poly_avx2_circuitT.MLKEM_Poly_avx2_circuitT as MLKEM_Poly_avx2_circuitI with
  theory B <- Base768.Base768,
  theory Fq_avx2 <- Fq_avx2I,
  theory MLKEM_ntt_levels <- MLKEM_ntt_levelsI,
  theory MLKEM_ntt_avx2 <- MLKEM_ntt_avx2I,
  theory MLKEM_invntt_levels <- MLKEM_invntt_levelsI,
  theory MLKEM_invntt_avx2 <- MLKEM_invntt_avx2I,
  theory MLKEM_basemul_avx2 <- MLKEM_basemul_avx2I,
  theory NTT_avx2_poly <- NTT_avx2_polyI,
  theory MLKEM_Poly_avx2 <- MLKEM_Poly_avx2I.
