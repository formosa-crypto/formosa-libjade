(******************************************************************************
   Keccakf1600_x4_x1.ec:

   Correctness of a four-way and a one-way Keccak-f[1600] permutation run
   together (keccakf1600x4_x1.jinc).
******************************************************************************)
require import AllCore List Int IntDiv.

from Jasmin require import JModel_x86.

from CryptoSpecs require import FIPS202_Keccakf1600 Keccakf1600_Spec.

require import Keccak1600_avx2x4.

from JazzEC require import Keccak1600_Jazz.
from JazzEC require import Array25.

require import Keccakf1600 Keccakf1600_avx2x4 Keccakf1600_x4_x1_nat_opt.

hoare keccakf1600_x4_x1_h _a4 _a1:
 M._keccakf1600_x4_x1
 : a4 = _a4 /\ a1 = _a1
 ==> res = (st4x_map keccak_f1600_op _a4, keccak_f1600_op _a1).
proof.
proc.
seq 2: #pre; first by inline*; auto.
if; first by ecall (keccakf1600_x4_x1_nat_opt_h a4 a1).
by ecall (keccakf1600_h a1); ecall (keccakf1600_avx2x4_h a4).
qed.

lemma keccakf1600_x4_x1_ll: islossless M._keccakf1600_x4_x1.
proof.
proc.
seq 2: true => //; first by inline*; auto.
if; first by call keccakf1600_x4_x1_nat_opt_ll.
by call keccakf1600_ll; call keccakf1600_avx2x4_ll.
qed.

phoare keccakf1600_x4_x1_ph _a4 _a1:
 [ M._keccakf1600_x4_x1
 : a4 = _a4 /\ a1 = _a1
 ==> res = (st4x_map keccak_f1600_op _a4, keccak_f1600_op _a1)
 ] = 1%r.
proof. by conseq keccakf1600_x4_x1_ll (keccakf1600_x4_x1_h _a4 _a1). qed.
