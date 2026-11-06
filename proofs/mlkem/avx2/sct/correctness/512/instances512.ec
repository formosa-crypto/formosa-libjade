(* The generic theories of the AVX2 proof below the compression, at the
   ML-KEM-512 parameters and model. *)
require import AllCore.
require Base512 Prelude512.
require Cbd3_avx2_512.
require MLKEM_ntt_levelsT.
require MLKEM_ntt_avx2T.
require MLKEM_invntt_levelsT.
require MLKEM_invntt_avx2T.
require MLKEM_basemul_avx2T.
require NTT_avx2_polyT.
require Fq_avx2T.
require MLKEM_Poly_avx2T.
require MLKEM_Poly_avx2_circuitT.
require NTT_avx2T.
require MLKEM_PolyVec_avx2T.
require MLKEM_PolyVec_avx2_circuitT.
require MLKEM_keccak_avx2T.
require Mlkem_filters_bridgeT.
require MLKEM_sampler_avx2T.
require MLKEM_genmatrix_avx2T.
require MLKEM_getnoise_avx2T.

clone export MLKEM_ntt_levelsT.MLKEM_ntt_levelsT as MLKEM_ntt_levelsI with
  theory B <- Base512.Base512.

clone export MLKEM_ntt_avx2T.MLKEM_ntt_avx2T as MLKEM_ntt_avx2I with
  theory B <- Base512.Base512,
  theory MLKEM_ntt_levels <- MLKEM_ntt_levelsI.

clone export MLKEM_invntt_levelsT.MLKEM_invntt_levelsT as MLKEM_invntt_levelsI with
  theory B <- Base512.Base512,
  theory MLKEM_ntt_levels <- MLKEM_ntt_levelsI.

clone export MLKEM_invntt_avx2T.MLKEM_invntt_avx2T as MLKEM_invntt_avx2I with
  theory B <- Base512.Base512,
  theory MLKEM_ntt_levels <- MLKEM_ntt_levelsI,
  theory MLKEM_ntt_avx2 <- MLKEM_ntt_avx2I,
  theory MLKEM_invntt_levels <- MLKEM_invntt_levelsI.

clone export MLKEM_basemul_avx2T.MLKEM_basemul_avx2T as MLKEM_basemul_avx2I with
  theory B <- Base512.Base512,
  theory MLKEM_ntt_levels <- MLKEM_ntt_levelsI,
  theory MLKEM_ntt_avx2 <- MLKEM_ntt_avx2I.

clone export NTT_avx2_polyT.NTT_avx2_polyT as NTT_avx2_polyI with
  theory B <- Base512.Base512,
  theory MLKEM_ntt_levels <- MLKEM_ntt_levelsI,
  theory MLKEM_ntt_avx2 <- MLKEM_ntt_avx2I,
  theory MLKEM_invntt_levels <- MLKEM_invntt_levelsI,
  theory MLKEM_invntt_avx2 <- MLKEM_invntt_avx2I,
  theory MLKEM_basemul_avx2 <- MLKEM_basemul_avx2I.

clone export Fq_avx2T.Fq_avx2T as Fq_avx2I with
  theory B <- Base512.Base512.

clone export MLKEM_Poly_avx2T.MLKEM_Poly_avx2T as MLKEM_Poly_avx2I with
  theory B <- Base512.Base512,
  theory Fq_avx2 <- Fq_avx2I,
  theory MLKEM_ntt_levels <- MLKEM_ntt_levelsI,
  theory MLKEM_ntt_avx2 <- MLKEM_ntt_avx2I,
  theory MLKEM_invntt_levels <- MLKEM_invntt_levelsI,
  theory MLKEM_invntt_avx2 <- MLKEM_invntt_avx2I,
  theory MLKEM_basemul_avx2 <- MLKEM_basemul_avx2I,
  theory NTT_avx2_poly <- NTT_avx2_polyI.

clone export MLKEM_Poly_avx2_circuitT.MLKEM_Poly_avx2_circuitT as MLKEM_Poly_avx2_circuitI with
  theory B <- Base512.Base512,
  theory Fq_avx2 <- Fq_avx2I,
  theory MLKEM_ntt_levels <- MLKEM_ntt_levelsI,
  theory MLKEM_ntt_avx2 <- MLKEM_ntt_avx2I,
  theory MLKEM_invntt_levels <- MLKEM_invntt_levelsI,
  theory MLKEM_invntt_avx2 <- MLKEM_invntt_avx2I,
  theory MLKEM_basemul_avx2 <- MLKEM_basemul_avx2I,
  theory NTT_avx2_poly <- NTT_avx2_polyI,
  theory MLKEM_Poly_avx2 <- MLKEM_Poly_avx2I.

export Prelude512.

clone export NTT_avx2T.NTT_avx2T as NTT_avx2I with
  theory B <- Base512.Base512,
  theory PR <- PreludeI,
  theory MLKEM_ntt_levels <- MLKEM_ntt_levelsI,
  theory MLKEM_ntt_avx2 <- MLKEM_ntt_avx2I,
  theory MLKEM_invntt_levels <- MLKEM_invntt_levelsI,
  theory MLKEM_invntt_avx2 <- MLKEM_invntt_avx2I,
  theory MLKEM_basemul_avx2 <- MLKEM_basemul_avx2I,
  theory NTT_avx2_poly <- NTT_avx2_polyI.

clone export MLKEM_PolyVec_avx2T.MLKEM_PolyVec_avx2T as MLKEM_PolyVec_avx2I with
  theory B <- Base512.Base512,
  theory PR <- PreludeI,
  theory Fq_avx2 <- Fq_avx2I,
  theory MLKEM_ntt_levels <- MLKEM_ntt_levelsI,
  theory MLKEM_ntt_avx2 <- MLKEM_ntt_avx2I,
  theory MLKEM_invntt_levels <- MLKEM_invntt_levelsI,
  theory MLKEM_invntt_avx2 <- MLKEM_invntt_avx2I,
  theory MLKEM_basemul_avx2 <- MLKEM_basemul_avx2I,
  theory NTT_avx2_poly <- NTT_avx2_polyI,
  theory MLKEM_Poly_avx2 <- MLKEM_Poly_avx2I.

clone export MLKEM_PolyVec_avx2_circuitT.MLKEM_PolyVec_avx2_circuitT as MLKEM_PolyVec_avx2_circuitI
  with
  theory B <- Base512.Base512,
  theory PR <- PreludeI,
  theory Fq_avx2 <- Fq_avx2I,
  theory MLKEM_ntt_levels <- MLKEM_ntt_levelsI,
  theory MLKEM_ntt_avx2 <- MLKEM_ntt_avx2I,
  theory MLKEM_invntt_levels <- MLKEM_invntt_levelsI,
  theory MLKEM_invntt_avx2 <- MLKEM_invntt_avx2I,
  theory MLKEM_basemul_avx2 <- MLKEM_basemul_avx2I,
  theory NTT_avx2_poly <- NTT_avx2_polyI,
  theory MLKEM_Poly_avx2 <- MLKEM_Poly_avx2I,
  theory MLKEM_Poly_avx2_circuit <- MLKEM_Poly_avx2_circuitI,
  theory NTT_avx2 <- NTT_avx2I.

clone export MLKEM_keccak_avx2T.MLKEM_keccak_avx2T as MLKEM_keccak_avx2I with
  theory B <- Base512.Base512.

clone export Mlkem_filters_bridgeT.Mlkem_filters_bridgeT as Mlkem_filters_bridgeI with
  theory B <- Base512.Base512.

clone export MLKEM_sampler_avx2T.MLKEM_sampler_avx2T as MLKEM_sampler_avx2I with
  theory B <- Base512.Base512,
  theory MLKEM_keccak_avx2 <- MLKEM_keccak_avx2I,
  theory Mlkem_filters_bridge <- Mlkem_filters_bridgeI.

clone export MLKEM_genmatrix_avx2T.MLKEM_genmatrix_avx2T as MLKEM_genmatrix_avx2I with
  theory B <- Base512.Base512,
  theory PR <- PreludeI,
  theory Fq_avx2 <- Fq_avx2I,
  theory MLKEM_ntt_levels <- MLKEM_ntt_levelsI,
  theory MLKEM_ntt_avx2 <- MLKEM_ntt_avx2I,
  theory MLKEM_invntt_levels <- MLKEM_invntt_levelsI,
  theory MLKEM_invntt_avx2 <- MLKEM_invntt_avx2I,
  theory MLKEM_basemul_avx2 <- MLKEM_basemul_avx2I,
  theory NTT_avx2_poly <- NTT_avx2_polyI,
  theory MLKEM_Poly_avx2 <- MLKEM_Poly_avx2I,
  theory NTT_avx2 <- NTT_avx2I,
  theory MLKEM_keccak_avx2 <- MLKEM_keccak_avx2I,
  theory Mlkem_filters_bridge <- Mlkem_filters_bridgeI,
  theory MLKEM_sampler_avx2 <- MLKEM_sampler_avx2I
  proof gen_matrix_indexesP.
realize gen_matrix_indexesP.
proof.
move=> t pos; rewrite (: Spec512.MLKEM512.kvec = 2) 1:// /= => hp.
have : pos = 0 \/ pos = 1 \/ pos = 2 \/ pos = 3 by smt().
case: t => /=; move=> _; rewrite /b2i /=.
+ case=> [->|[->|[->|->]]];
    by rewrite /Spec512.MLKEM512.pos2ji /Jkem512I.Jkem512I.gen_matrix_indexes /=.
case=> [->|[->|[->|->]]];
  by rewrite /Spec512.MLKEM512.pos2ji /Jkem512I.Jkem512I.gen_matrix_indexes /=.
qed.

clone export MLKEM_getnoise_avx2T.MLKEM_getnoise_avx2T as MLKEM_getnoise_avx2I with
  theory B <- Base512.Base512,
  theory MLKEM_keccak_avx2 <- MLKEM_keccak_avx2I
  proof cbd3_corr.
(* eta1 = 3: the eta = 3 sampler, by circuit *)
realize cbd3_corr.
proof. by move=> _b _; apply Cbd3_avx2_512.cbd3_corr_512. qed.

