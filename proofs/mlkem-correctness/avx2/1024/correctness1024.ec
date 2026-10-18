(* The AVX2 implementation of ML-KEM-1024 against its specification: the
   compression kernels of the set, then the generic inner PKE and KEM. *)
require import AllCore List.
from Jasmin require import JModel.
from JazzEC require import Jkem_avx2 Array160 Array256 Array1024 Array1408 Array1410 Array1568.
from Spec require import Spec1024.
require import Instances1024 MLKEM_compress_avx2_1024 Circuit_sem_1024.
require MLKEM_compress_avx2T MLKEM_InnerPKE_avx2T MLKEM_KEM_avx2T.

import MLKEM1024.

(* the dispatchers of the compression, at d_u = 11 and d_v = 5 *)
clone export MLKEM_compress_avx2T.MLKEM_compress_avx2T as MLKEM_compress_avx2I with
  theory B <- Base1024.Base1024,
  theory PR <- PreludeI
  proof poly_decompress_corr, i_poly_compress_corr, polyvec_decompress_corr,
    polyvec_compress_avx2_corr.
realize poly_decompress_corr.
proof.
move=> _a; proc; rcondf 1; 1: by auto.
call (poly_decompress_dv5_corr (Array160.init (fun i => _a.[i]))); auto => /> &hr.
have ha : a{hr} = Array160.init (fun i => (BytesPoly.init (fun i => a{hr}.[i])).[i]).
+ by apply Array160.tP => i ib; rewrite Array160.initiE //= BytesPoly.initiE.
split; 1: exact ha.
move=> _ r -> _; rewrite -ha /decode_poly (: dv = 5) 1://; congr; congr; congr.
apply (eq_from_nth witness); 1: by rewrite Array160.size_to_list BytesPoly.size_to_list.
move=> k; rewrite Array160.size_to_list => kb.
by rewrite Array160.get_to_list BytesPoly.get_to_list BytesPoly.initiE.
qed.

realize i_poly_compress_corr.
proof.
move=> _aw; proc; rcondf 1; 1: by auto.
call (i_poly_compress_dv5_corr _aw); auto => />.
move=> _ r ->; rewrite /encode_poly (: dv = 5) 1://; apply BytesPoly.tP => i ib.
by rewrite BytesPoly.initiE //= Array160.get_of_list 1:/# BytesPoly.get_of_list.
qed.

realize polyvec_decompress_corr.
proof.
move=> _aw; proc; rcondf 1; 1: by auto.
call (polyvec_decompress_du11_corr (Array1408.init (fun i => _aw.[i]))); auto => /> &hr.
have ha : Array1408.init (fun i => rp{hr}.[i]) =
  Array1408.init (fun i => (BytesCtVec.init (fun i => rp{hr}.[i])).[i]).
+ by apply Array1408.tP => i ib; rewrite !Array1408.initiE //= BytesCtVec.initiE.
split; 1: exact ha.
move=> _ r _ ->; rewrite -ha /decode_vec (: du = 11) 1://; congr; congr; congr.
apply (eq_from_nth witness); 1: by rewrite Array1408.size_to_list BytesCtVec.size_to_list.
move=> k; rewrite Array1408.size_to_list => kb.
by rewrite Array1408.get_to_list BytesCtVec.get_to_list BytesCtVec.initiE //= Array1408.initiE.
qed.

realize polyvec_compress_avx2_corr.
proof.
move=> _aw; proc; rcondf 1; 1: by auto.
call (polyvec_compress_du11_corr _aw); auto => />.
move=> _ _ r h; rewrite /encode_vec (: du = 11) 1://; apply BytesCtVec.tP => i ib.
move/Array1408.tP: h => /(_ i _); 1: smt().
by rewrite Array1408.initiE 1:/# Array1408.get_of_list 1:/# BytesCtVec.initiE //=
  BytesCtVec.get_of_list.
qed.

(* the inner PKE and the KEM *)
clone export MLKEM_InnerPKE_avx2T.MLKEM_InnerPKE_avx2T as MLKEM_InnerPKE_avx2I with
  theory B <- Base1024.Base1024,
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
  theory NTT_avx2 <- NTT_avx2I,
  theory MLKEM_PolyVec_avx2 <- MLKEM_PolyVec_avx2I,
  theory MLKEM_PolyVec_avx2_circuit <- MLKEM_PolyVec_avx2_circuitI,
  theory MLKEM_keccak_avx2 <- MLKEM_keccak_avx2I,
  theory Mlkem_filters_bridge <- Mlkem_filters_bridgeI,
  theory MLKEM_sampler_avx2 <- MLKEM_sampler_avx2I,
  theory MLKEM_genmatrix_avx2 <- MLKEM_genmatrix_avx2I,
  theory MLKEM_getnoise_avx2 <- MLKEM_getnoise_avx2I,
  theory MLKEM_compress_avx2 <- MLKEM_compress_avx2I.

clone export MLKEM_KEM_avx2T.MLKEM_KEM_avx2T as MLKEM_KEM_avx2I with
  theory B <- Base1024.Base1024,
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
  theory NTT_avx2 <- NTT_avx2I,
  theory MLKEM_PolyVec_avx2 <- MLKEM_PolyVec_avx2I,
  theory MLKEM_PolyVec_avx2_circuit <- MLKEM_PolyVec_avx2_circuitI,
  theory MLKEM_keccak_avx2 <- MLKEM_keccak_avx2I,
  theory Mlkem_filters_bridge <- Mlkem_filters_bridgeI,
  theory MLKEM_sampler_avx2 <- MLKEM_sampler_avx2I,
  theory MLKEM_genmatrix_avx2 <- MLKEM_genmatrix_avx2I,
  theory MLKEM_getnoise_avx2 <- MLKEM_getnoise_avx2I,
  theory MLKEM_compress_avx2 <- MLKEM_compress_avx2I,
  theory MLKEM_InnerPKE_avx2 <- MLKEM_InnerPKE_avx2I.

