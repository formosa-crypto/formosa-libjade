(* ==================================================================== *)
(* Linking the mask sampler against the specification.                  *)
(*                                                                      *)
(* The byte oracle the sampler proofs are stated over is the byte       *)
(* stream of the specification's SHAKE256 (Sha3x4.shake256_sliceE).     *)
(* Proved here: the separator encoding, the equality of the SIMD        *)
(* decoder with BitUnpack, the coefficient range, and the link of the   *)
(* sampler's mask polynomial with the specification's.                  *)
(*                                                                      *)
(* Kept in a separate file for review; meant to replace the admitted    *)
(* statement in mask.ec.                                                *)
(* ==================================================================== *)

require import AllCore List IntDiv StdOrder RealExp BitEncoding.
(*---*) import BS2Int BitChunking IntOrder.

from Jasmin require import JModel_x86.

require import Mldsa65.
from JazzEC require import Mldsa_65_prelude.

from Spec require import GFq Rq Parameters MLDSA_W32_Rep.
from Spec require import Spec65.
import MLDSA65.

from CryptoSpecs require import Keccak1600_Spec.

import PolyLVec PolyKVec PolyMat.
import Round ZModQ Zq.

require import Array64 Array256 Array1280.
require import JWordList.

require import Sha3x4 Shared65. import Sha3x4_65 Shake256x4.
require Xof.
require Mexpand.

(* -------------------------------------------------------------------- *)
(* Parameters of the ML-DSA-65 instance                                 *)
lemma gamma1E : gamma1 = Mexpand.gamma1.
proof. by rewrite mldsa65_gamma1 /Mexpand.gamma1. qed.

(* -------------------------------------------------------------------- *)
(* The domain-separator encoding: the spec's 2-byte integer encoding    *)
(* is the little-endian byte pair of the W16 counter.                   *)
lemma IntegerToBytes2E (k : int) :
  0 <= k < 65536 =>
  IntegerToBytes k 2 = W2u8.to_list (W16.of_int k).
proof.
move=> rgk; rewrite /IntegerToBytes /BitsToBytes /IntegerToBits /=.
rewrite (int2bs_cat 8 16) //.
rewrite chunk_cat ?size_int2bs //.
rewrite !chunk_size ?size_int2bs //=.
split.
- apply W8.wordP => j rgj.
  rewrite get_bits2w // W2u8.bits8iE //= of_intwE /int_bit /=.
  have -> /= : 0 <= j < 16 by smt().
  by rewrite /int2bs nth_mkseq //= (pmod_small k 65536).
- apply W8.wordP => j rgj.
  rewrite get_bits2w // W2u8.bits8iE //= of_intwE /int_bit /=.
  have -> /= : 0 <= 8 + j < 16 by smt().
  rewrite /int2bs nth_mkseq //= (pmod_small k 65536) //.
  rewrite -divz_mul //.
  by have -> // : 256 * 2 ^ j = 2 ^ (8 + j) by rewrite exprD_nneg /#.
qed.

(* -------------------------------------------------------------------- *)
(* The decoded field and coefficient, at the integer level              *)
lemma rg_mbits (bs : W8.t list) (j : int) :
  0 <= Mexpand.mbits bs j < 2 ^ 20.
proof.
rewrite /Mexpand.mbits; split; [exact bs2int_ge0 | move=> _].
have h1 := bs2int_le2Xs (take 20 (drop (20 * j) (flatten (map W8.w2bits bs)))).
have h2 : size (take 20 (drop (20 * j) (flatten (map W8.w2bits bs)))) <= 20.
- by rewrite size_take /#.
have h3 : 2 ^ size (take 20 (drop (20 * j) (flatten (map W8.w2bits bs)))) <= 2 ^ 20.
- by apply ler_weexpn2l => //; smt(size_ge0).
exact (ltr_le_trans _ _ _ h1 h3).
qed.

lemma to_sint_mcoeffE (bs : W8.t list) (j : int) :
  W32.to_sint (Mexpand.mcoeff bs j) = Mexpand.gamma1 - Mexpand.mbits bs j.
proof.
have rgm := rg_mbits bs j.
have h20 : 2 ^ 20 = 1048576 by done.
move: rgm; rewrite h20 => rgm.
rewrite /Mexpand.mcoeff /Mexpand.gamma1 /=.
rewrite of_sintK /smod /=.
case: (0 <= 524288 - Mexpand.mbits bs j) => hs.
- by rewrite pmod_small 1:/# ifF /#.
rewrite -modzDr pmod_small 1:/#.
by rewrite ifT /#.
qed.

(* -------------------------------------------------------------------- *)
(* The SIMD decoder is the spec's BitUnpack.                            *)
lemma mdecode_BitUnpack (bs : W8.t list) :
  size bs = 640 =>
  lifts_wpoly (Mexpand.mdecode bs)
  = BitUnpack bs (gamma1 - 1) gamma1.
proof.
move=> sz_bs; rewrite /BitUnpack /= ilog_gamma1 /=.
apply Array256.tP => j rgj.
rewrite /lifts_wpoly mapiE //= /Mexpand.mdecode Array256.initiE //=.
rewrite Array256.initiE //= (nth_map witness) /=.
- by rewrite size_chunk // size_BytesToBits /#.
rewrite (nth_change_dfl [] witness).
- by rewrite size_chunk // size_BytesToBits sz_bs /#.
rewrite nth_chunk // ?size_BytesToBits ?sz_bs; 1,2: smt().
rewrite to_sint_mcoeffE gamma1E /Mexpand.gamma1 /Mexpand.mbits.
by rewrite /BitsToInteger /BytesToBits.
qed.

(* -------------------------------------------------------------------- *)
(* Coefficient range of the decoder output                              *)
lemma mdecode_srng (bs : W8.t list) :
  wpoly_srng (gamma1 - 1) gamma1 (Mexpand.mdecode bs).
proof.
rewrite /wpoly_srng Array256.allP => i rgi /=.
rewrite /Mexpand.mdecode Array256.initiE //= to_sint_mcoeffE.
by have := rg_mbits bs i; rewrite gamma1E /Mexpand.gamma1 /#.
qed.

(* -------------------------------------------------------------------- *)
(* The spec-side sampler, functionally                                  *)
lemma ExpandMask_sampleP (rho_ : Bytes64.t) (mu_ : int) :
  hoare [ ExpandMask.sample :
    arg = (rho_, mu_)
    ==>
    forall r, 0 <= r < lvec =>
      res.[r]
      = BitUnpack
          (BytesV.to_list (H_v (Bytes66.of_list
             (Bytes64.to_list rho_ ++ IntegerToBytes (mu_ + r) 2))))
          (gamma1 - 1) gamma1 ].
proof.
proc.
while (rho = rho_ /\ mu = mu_ /\ 0 <= r <= lvec
  /\ forall i, 0 <= i < r =>
       s.[i]
       = BitUnpack
           (BytesV.to_list (H_v (Bytes66.of_list
              (Bytes64.to_list rho_ ++ IntegerToBytes (mu_ + i) 2))))
           (gamma1 - 1) gamma1).
- auto=> |> &hr ge0_r _ hs lt_r; do! split; 1,2: smt().
  move=> i rgi rgir; rewrite LArray.get_setE 1:/#.
  by case: (i = r{hr}) => [->|ne]; [done | rewrite hs /#].
by auto=> |>; smt(mldsa65_lvec).
qed.

(* -------------------------------------------------------------------- *)
(* window plumbing: the vector entries of the flattened result are the  *)
(* sampler's windows                                                    *)
lemma unflatten_winof (a : W32.t Array1280.t) (r : int) :
  0 <= r < 5 =>
  (lvec_unflatten256 a).[r] = Array256.init (fun j => a.[256 * r + j]).
proof.
move=> rgr; rewrite /lvec_unflatten256 LArray.initiE /=; 1: smt(mldsa65_lvec).
apply Array256.tP => j rgj; rewrite initiE //=.
by rewrite initiE //= nth_sub /#.
qed.

(* -------------------------------------------------------------------- *)
(* -------------------------------------------------------------------- *)
(* The op-level link: under the SHAKE/XOF assumption, the sampler's     *)
(* isolation op [Mpoly] is the specification's mask polynomial.         *)
lemma Mpoly_specE (rho_ : W8.t Array64.t) (sep : W16.t) :
  lifts_wpoly (Mexpand.Mpoly rho_ sep)
  = BitUnpack
      (BytesV.to_list (H_v (Bytes66.of_list
         (to_list rho_ ++ IntegerToBytes (W16.to_uint sep) 2))))
      (gamma1 - 1) gamma1.
proof.
have hb : 0 <= W16.to_uint sep < 65536.
- by have := W16.to_uint_cmp sep; have -> : W16.modulus = 65536 by done.
rewrite Mexpand.MpolyP shake256_sliceE //.
rewrite IntegerToBytes2E // W16.to_uintK.
rewrite /H_v Bytes66.of_listK /=.
- by rewrite size_cat Array64.size_to_list /=.
rewrite BytesV.of_listK //= ?size_SHAKE256 //.
by rewrite mdecode_BitUnpack //= size_SHAKE256.
qed.

(* the coefficient range of the isolation op, at the spec's bounds      *)
lemma Mpoly_srng (rho_ : W8.t Array64.t) (sep : W16.t) :
  wpoly_srng (gamma1 - 1) gamma1
    (Mexpand.Mpoly rho_ sep).
proof. by rewrite Mexpand.MpolyP mdecode_srng. qed.

(* the form the vector-level assembly will consume: window r of the     *)
(* sampler is the r-th entry of the specification's ExpandMask          *)
lemma Mpoly_ExpandMask_entry (rho_ : W8.t Array64.t) (ds0 : W16.t) (r : int) :
  0 <= r => W16.to_uint ds0 + r < 65536 =>
  lifts_wpoly (Mexpand.Mpoly rho_ (ds0 + W16.of_int r))
  = BitUnpack
      (BytesV.to_list (H_v (Bytes66.of_list
         (to_list rho_ ++ IntegerToBytes (W16.to_uint ds0 + r) 2))))
      (gamma1 - 1) gamma1.
proof.
move=> ge0_r hbound.
have hM : W16.modulus = 65536 by done.
rewrite Mpoly_specE.
have -> // : to_uint (ds0 + W16.of_int r) = to_uint ds0 + r.
by rewrite to_uintD_small of_uintK ?hM ?pmod_small;
   1, 3: smt(W16.to_uint_cmp); smt().
qed.
