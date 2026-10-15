require import AllCore.
require Spec65 Mldsa65I BaseT PreludeT ErrorSamplerT KeygenT SignT VerifyT.
require Eta4T Gamma1Bits20T W1Bits4T.
from JazzEC require Commitment_hash.

(* The generic theories of key generation, signing and verification, at
   the ML-DSA-65 parameters and model. Their hypotheses, on the code that
   depends on the set, are discharged by the variants of that code used
   by ML-DSA-65 and by the ML-DSA-65 proofs of the rest. The theorems are
   restated in Correctness65. *)

clone BaseT.BaseT as Base65 with
  theory S <- Spec65.MLDSA65,
  theory R <- Mldsa65I.Mldsa65I.

clone PreludeT.PreludeT as Prelude65 with theory B <- Base65.

(* the variants of the encodings: Eta = 4, gamma1 = 2^19, gamma2 = (q-1)/32 *)
clone Eta4T.Eta4T as Eta4_65 with
  theory B <- Base65
proof *.

clone Gamma1Bits20T.Gamma1Bits20T as Gamma1Bits20_65 with
  theory B <- Base65,
  theory PR <- Prelude65
proof *.

clone W1Bits4T.W1Bits4T as W1Bits4_65 with
  theory B <- Base65,
  theory PR <- Prelude65
proof *.

(* the four-lane core of the error-vector sampler *)
clone ErrorSamplerT.ErrorSamplerT as ErrorSampler65 with
  theory B <- Base65,
  theory PR <- Prelude65
proof *.

(* -------------------------------------------------------------------- *)
clone KeygenT.KeygenT as Keygen65 with
  theory B <- Base65,
  theory PR <- Prelude65,
  theory EP <- Eta4_65.EP,
  theory EV <- ErrorSampler65.EV
proof *.

clone SignT.SignT as Sign65 with
  theory B <- Base65,
  theory PR <- Prelude65,
  theory EP <- Eta4_65.EP,
  theory CMT <- W1Bits4_65.CMT,
  theory SG.G1 <- Gamma1Bits20_65.G1
proof *.

clone VerifyT.VerifyT as Verify65 with
  theory B <- Base65,
  theory PR <- Prelude65,
  theory CMT <- W1Bits4_65.CMT,
  theory SG.G1 <- Gamma1Bits20_65.G1
proof *.
realize compare_commitment_hashes_correct by exact Commitment_hash.compare_commitment_hashes_correct.
