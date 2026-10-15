require import AllCore.
require Spec87 Mldsa87I BaseT PreludeT ErrorSamplerT KeygenT SignT VerifyT.
require Eta2T Gamma1Bits20T W1Bits4T.
from JazzEC require Commitment_hash87.

(* The generic theories of key generation, signing and verification, at
   the ML-DSA-87 parameters and model. Their hypotheses, on the code that
   depends on the set, are discharged by the variants of that code used
   by ML-DSA-87 and by the ML-DSA-87 proofs of the rest. The theorems are
   restated in Correctness87. *)

clone BaseT.BaseT as Base87 with
  theory S <- Spec87.MLDSA87,
  theory R <- Mldsa87I.Mldsa87I.

clone PreludeT.PreludeT as Prelude87 with theory B <- Base87.

(* the variants of the encodings: Eta = 2, gamma1 = 2^19, gamma2 = (q-1)/32 *)
clone Eta2T.Eta2T as Eta2_87 with
  theory B <- Base87
proof *.

clone Gamma1Bits20T.Gamma1Bits20T as Gamma1Bits20_87 with
  theory B <- Base87,
  theory PR <- Prelude87
proof *.

clone W1Bits4T.W1Bits4T as W1Bits4_87 with
  theory B <- Base87,
  theory PR <- Prelude87
proof *.

(* the four-lane core of the error-vector sampler *)
clone ErrorSamplerT.ErrorSamplerT as ErrorSampler87 with
  theory B <- Base87,
  theory PR <- Prelude87
proof *.

(* -------------------------------------------------------------------- *)
clone KeygenT.KeygenT as Keygen87 with
  theory B <- Base87,
  theory PR <- Prelude87,
  theory EP <- Eta2_87.EP,
  theory EV <- ErrorSampler87.EV
proof *.

clone SignT.SignT as Sign87 with
  theory B <- Base87,
  theory PR <- Prelude87,
  theory EP <- Eta2_87.EP,
  theory CMT <- W1Bits4_87.CMT,
  theory SG.G1 <- Gamma1Bits20_87.G1
proof *.

clone VerifyT.VerifyT as Verify87 with
  theory B <- Base87,
  theory PR <- Prelude87,
  theory CMT <- W1Bits4_87.CMT,
  theory SG.G1 <- Gamma1Bits20_87.G1
proof *.
realize compare_commitment_hashes_correct
  by exact Commitment_hash87.compare_commitment_hashes_correct.
