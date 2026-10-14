require import AllCore List.

from Jasmin require import JModel_x86.

require import Mldsa65.
from JazzEC require import Mldsa_65_prelude.

from Spec require import GFq Rq Parameters MLDSA_W32_Rep.
from Spec require import Spec65.
import MLDSA65.

import PolyLVec PolyKVec PolyMat.
import Round ZModQ Zq.

require import Array64 Array256 Array1280.
require Mexpand.
require import Mask_link.

(* -------------------------------------------------------------------- *)
(* Losslessness.  The Keccak primitives are lossless by the trust        *)
(* boundary (Sha3x4); the remaining loops are the decoder, the state     *)
(* load/store and the squeeze-blocks loops.                              *)
(* -------------------------------------------------------------------- *)
lemma gamma1____decode_to_polynomial_ll : islossless M.gamma1____decode_to_polynomial.
proof.
proc; rcondf 1; 1: by auto.
inline *; wp; while true (1024 - output_offset); auto => /#.
qed.
hint solve 0 lossless : gamma1____decode_to_polynomial_ll.

lemma __load_shake256_state_ll : islossless M.__load_shake256_state.
proof. proc; while true (7 - i); auto => /#. qed.
hint solve 0 lossless : __load_shake256_state_ll.

lemma __store_shake256_state_ll : islossless M.__store_shake256_state.
proof. proc; while true (7 - i); auto => /#. qed.
hint solve 0 lossless : __store_shake256_state_ll.

lemma shake256_squeeze_multiple_blocks_4x_ll : islossless M.shake256_squeeze_multiple_blocks_4x.
proof.
proc; while true (inc - i); [by move=> z; wp; call (: true); [islossless | auto => /#] | auto => /#].
qed.
hint solve 0 lossless : shake256_squeeze_multiple_blocks_4x_ll.

lemma __sample_mask_polynomial_1x_ll : islossless M.__sample_mask_polynomial_1x.
proof.
proc; islossless; while true (inc - i); [by move=> z; wp; call (: true); [islossless | auto => /#] | auto => /#].
qed.
hint solve 0 lossless : __sample_mask_polynomial_1x_ll.

lemma sample____mask_ll : islossless M.sample____mask.
proof. by islossless. qed.

lemma ExpandMask_sample_ll : islossless ExpandMask.sample.
proof. proc; while true (lvec - r); auto => /#. qed.

(* -------------------------------------------------------------------- *)
lemma ExpandMask_sample_ph (rho_ : Bytes64.t) (mu_ : int) :
  phoare [ ExpandMask.sample : arg = (rho_, mu_) ==>
    forall r, 0 <= r < lvec =>
      res.[r] = BitUnpack (BytesV.to_list (H_v (Bytes66.of_list
                  (Bytes64.to_list rho_ ++ IntegerToBytes (mu_ + r) 2))))
                (gamma1 - 1) gamma1 ] = 1%r.
proof. by conseq ExpandMask_sample_ll (ExpandMask_sampleP rho_ mu_). qed.

lemma sample____mask_ph (rho_ : W8.t Array64.t) (ds0 : W16.t) :
  phoare [ M.sample____mask : rho_prime = rho_ /\ domain_separator = ds0 ==>
     (forall r, 0 <= r < 5 =>
        Mexpand.poly_of_mask res.`1 r = Mexpand.Mpoly rho_ (ds0 + W16.of_int r))
  /\ res.`2 = ds0 + W16.of_int 5 ] = 1%r.
proof. by conseq sample____mask_ll (Mexpand.sample____maskP rho_ ds0). qed.

(* Equiv between the spec ExpandMask.sample and the Jasmin sample____mask.
   Both take a 64-byte seed and an integer domain separator / kappa counter.
   The Jasmin function samples lvec polynomials using domain separators
   [kappa, kappa+1, ..., kappa+lvec-1] and returns the updated domain separator.
   Note: the spec's kappa increment (kappa <- kappa + lvec) is done in the
   outer loop, not inside ExpandMask.sample; the Jasmin increments internally
   and returns the new value.  The 16-bit separator must not wrap:
   to_uint _dom + lvec < 65536 (the signing loop keeps it below 65530). *)
lemma mask_correct _seed _dom :
    equiv [ ExpandMask.sample ~ M.sample____mask :
        arg{1}.`1 = Bytes64.of_list (to_list _seed)
     /\ arg{1}.`2 = W16.to_uint _dom
     /\ arg{2}.`1 = _seed
     /\ arg{2}.`2 = _dom
     /\ W16.to_uint _dom + lvec < 65536
        ==>
        lifts_wpolylvec (lvec_unflatten256 res{2}.`1) = res{1}
     /\ wpolylvec_srng (lvec_unflatten256 res{2}.`1) (gamma1-1) gamma1
     /\ W16.to_uint res{2}.`2 = W16.to_uint _dom + lvec
    ].
proof.
proc*.
ecall{1} (ExpandMask_sample_ph (Bytes64.of_list (to_list _seed)) (W16.to_uint _dom)).
ecall{2} (sample____mask_ph _seed _dom).
skip => &1 &2 /> hb r2 hw hsep r1 hs.
have hl := mldsa65_lvec.
(* window k of the result is the mask polynomial at separator _dom + k *)
have hwin : forall k, 0 <= k < 5 =>
  (lvec_unflatten256 r2.`1).[k] = Mexpand.Mpoly rho_prime{2} (domain_separator{2} + W16.of_int k).
- by move=> k hk; rewrite (unflatten_winof _ k) 1:/# -hw.
split.
- apply LArray.tP => k hk.
  rewrite /lifts_wpolylvec LArray.mapiE // hwin 1:/#.
  rewrite Mpoly_ExpandMask_entry 1,2:/# hs 1:/#.
  by rewrite Bytes64.of_listK // Array64.size_to_list.
split.
- by rewrite /wpolylvec_srng LArray.allP => k hk; rewrite hwin 1:/#; exact Mpoly_srng.
rewrite hsep W16.to_uintD_small W16.of_uintK; smt(W16.to_uint_cmp).
qed.
