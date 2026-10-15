require import AllCore.
require Spec44 Mldsa44I BaseT PreludeT ErrorSamplerT KeygenT SignT VerifyT.
require Eta2T Gamma1Bits18T W1Bits6T.
from JazzEC require Commitment_hash44.

(* The generic theories of key generation, signing and verification, at
   the ML-DSA-44 parameters and model. Their hypotheses, on the code that
   depends on the set, are discharged by the variants of that code used
   by ML-DSA-44 and by the ML-DSA-44 proofs of the rest. The theorems are
   restated in Correctness44. *)

clone BaseT.BaseT as Base44 with
  theory S <- Spec44.MLDSA44,
  theory R <- Mldsa44I.Mldsa44I.

clone PreludeT.PreludeT as Prelude44 with theory B <- Base44.

(* the variants of the encodings: Eta = 2, gamma1 = 2^17, gamma2 = (q-1)/88 *)
clone Eta2T.Eta2T as Eta2_44 with
  theory B <- Base44
proof *.

clone Gamma1Bits18T.Gamma1Bits18T as Gamma1Bits18_44 with
  theory B <- Base44,
  theory PR <- Prelude44
proof *.

clone W1Bits6T.W1Bits6T as W1Bits6_44 with
  theory B <- Base44,
  theory PR <- Prelude44
proof *.

(* the four-lane core of the error-vector sampler *)
clone ErrorSamplerT.ErrorSamplerT as ErrorSampler44 with
  theory B <- Base44,
  theory PR <- Prelude44
proof *.

(* -------------------------------------------------------------------- *)
clone KeygenT.KeygenT as Keygen44 with
  theory B <- Base44,
  theory PR <- Prelude44,
  theory EP <- Eta2_44.EP,
  theory EV <- ErrorSampler44.EV
proof *.

clone SignT.SignT as Sign44 with
  theory B <- Base44,
  theory PR <- Prelude44,
  theory EP <- Eta2_44.EP,
  theory CMT <- W1Bits6_44.CMT,
  theory SG.G1 <- Gamma1Bits18_44.G1
proof *.

clone VerifyT.VerifyT as Verify44 with
  theory B <- Base44,
  theory PR <- Prelude44,
  theory CMT <- W1Bits6_44.CMT,
  theory SG.G1 <- Gamma1Bits18_44.G1
proof *.
realize compare_commitment_hashes_correct
  by exact Commitment_hash44.compare_commitment_hashes_correct.
