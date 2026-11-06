require import AllCore IntDiv List.
from Jasmin require import JModel_x86.
require import Mldsa65.
from Spec require import Spec65.
require import Array32 Array640 Array768 Array1952 Array3309 Array4032 JWordList.
from JazzEC require Instances65.
import MLDSA65.

(* The correctness of the AVX2 implementation of ML-DSA-65: key
   generation, signing and verification are the specification's. *)

(* the validity of the encodings of s1 and s2 in the signing key *)
op valid_s1_bytes = Instances65.Sign65.S1E.valid_s1_bytes.
op valid_s2_bytes = Instances65.Sign65.S2E.valid_s2_bytes.

lemma keygen_correct :
  equiv [ MLDSA(MLDSA_XOFA, MLDSA_XOFS, MLDSA_XOF_SIB, SIB_RO).keygen_derand
          ~ M.__keygen_internal :
     arg{1} = Bytes32.of_list (to_list arg{2}.`3)
     ==>
     res{1}.`2 = BytesPK.of_list (to_list res{2}.`1) /\
     res{1}.`1 = BytesSK.of_list (to_list res{2}.`2) ].
proof. by exact Instances65.Keygen65.keygen_internal_correct. qed.

(* The signing loop of the code stops after (2^16 - 1 - l) / l iterations. *)
lemma sign_correct _m :
  kappa_max = (65535 - lvec) %/ lvec =>
  equiv [ MLDSA(MLDSA_XOFA, MLDSA_XOFS, MLDSA_XOF_SIB, SIB_RO).sign_derand
          ~ M.__sign_internal :
       Glob.mem{2} = _m
    /\ sk{1} = BytesSK.of_list (to_list signing_key{2})
    /\ rnd_to_list coins{1} = to_list randomness{2}
    /\ 0 <= context_size{2} <= 255
    /\ 0 <= message_size{2}
    /\ 0 <= context_pointer{2} /\ context_pointer{2} + context_size{2} < W64.modulus
    /\ message_pointer{2} + message_size{2} < W64.modulus
    /\ m{1} = [W8.zero; W8.of_int context_size{2}]
              ++ memread _m context_pointer{2} context_size{2}
              ++ memread _m message_pointer{2} message_size{2}
    /\ valid_s1_bytes (Array640.init (fun i => signing_key{2}.[128 + i]))
    /\ valid_s2_bytes (Array768.init (fun i => signing_key{2}.[768 + i]))
    ==>
       Glob.mem{2} = _m
    /\ (res{1}.`1 = None <=> res{2}.`2 = -W64.one /\ res{2}.`1 = Array3309.create W8.zero)
    /\ (res{1}.`1 <> None =>
          BytesSig.to_list (oget res{1}.`1) = to_list res{2}.`1 /\
          res{2}.`2 = W64.zero) ].
proof. by exact (Instances65.Sign65.sign_internal_correct _m). qed.

lemma verify_correct _m :
  equiv [ MLDSA(MLDSA_XOFA, MLDSA_XOFS, MLDSA_XOF_SIB, SIB_RO).verify
          ~ M.__verify_internal :
       Glob.mem{2} = _m
    /\ arg{1}.`1 = BytesPK.of_list (to_list verification_key{2})
    /\ arg{1}.`2 = BytesSig.init (fun i => signature_encoded{2}.[i])
    /\ 0 <= context_size{2} <= 255
    /\ 0 <= message_size{2}
    /\ 0 <= context_pointer{2} /\ context_pointer{2} + context_size{2} < W64.modulus
    /\ message_pointer{2} + message_size{2} < W64.modulus
    /\ arg{1}.`3 = [W8.zero; W8.of_int context_size{2}]
                   ++ memread _m context_pointer{2} context_size{2}
                   ++ memread _m message_pointer{2} message_size{2}
    ==>
       Glob.mem{2} = _m /\ res{1} = (res{2} = W64.zero) ].
proof. by exact (Instances65.Verify65.verify_internal_correct _m). qed.
