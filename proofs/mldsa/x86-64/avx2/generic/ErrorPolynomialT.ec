require import AllCore List IntDiv BitEncoding.
from Jasmin require import JModel_x86.
from Spec require import GFq Rq Parameters MLDSA_W32_Rep.
require import Array256.
require BaseT.

(* The encoding of a polynomial with coefficients in [-Eta, Eta], on
   noise_bits bits per coefficient. Its code depends on Eta (eta4 or eta2
   variant) and works on the encoding array of each set: its correctness is
   a hypothesis of this theory, proved for each set. *)
abstract theory ErrorPolynomialT.

clone import BaseT.BaseT as B.
import S R MLDSAParams.
import Array_eta_enc.
import BS2Int.

(* each noise_bits-bit field of the encoding is at most 2 Eta *)
op valid_eta_bytes (a : W8.t Array_eta_enc.t) =
  forall i, 0 <= i < 256 =>
    bs2int (mkseq (fun j => a.[(noise_bits * i + j) %/ 8].[(noise_bits * i + j) %% 8])
                  noise_bits) <= 2 * Eta.

axiom error_polynomial_encode (_a : W32.t Array256.t) :
  hoare [ M.error_polynomial__encode :
      polynomial = _a /\ wpoly_srng Eta Eta _a
    ==>
      to_list res = BitPack (lifts_wpoly _a) Eta Eta /\ valid_eta_bytes res ].

axiom error_polynomial_decode (_a : W8.t Array_eta_enc.t) :
  hoare [ M.error_polynomial__decode :
      encoded = _a /\ valid_eta_bytes _a
    ==>
      lifts_wpoly res = BitUnpack (to_list _a) Eta Eta /\ wpoly_srng Eta Eta res ].

axiom error_polynomial_encode_ll : islossless M.error_polynomial__encode.
axiom error_polynomial_decode_ll : islossless M.error_polynomial__decode.

lemma error_polynomial_encode_ph (_a : W32.t Array256.t) :
  phoare [ M.error_polynomial__encode :
      polynomial = _a /\ wpoly_srng Eta Eta _a
    ==>
      to_list res = BitPack (lifts_wpoly _a) Eta Eta /\ valid_eta_bytes res ] = 1%r
by conseq error_polynomial_encode_ll (error_polynomial_encode _a).

lemma error_polynomial_decode_ph (_a : W8.t Array_eta_enc.t) :
  phoare [ M.error_polynomial__decode :
      encoded = _a /\ valid_eta_bytes _a
    ==>
      lifts_wpoly res = BitUnpack (to_list _a) Eta Eta /\ wpoly_srng Eta Eta res ] = 1%r
by conseq error_polynomial_decode_ll (error_polynomial_decode _a).

end ErrorPolynomialT.
