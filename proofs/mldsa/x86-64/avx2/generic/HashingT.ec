require import AllCore IntDiv List.
from Jasmin require import JModel_x86.
from Spec require import GFq Rq Parameters MLDSA_W32_Rep.
require import Array2 Array25 Array26 Array32 Array64 Array66 Array128 Array136.
require import WArray2 Array7 WArray32 WArray64 WArray66 WArray128 WArray136 WArray200 WArray208.
require import JWordList.
from Keccak require import Keccakf1600.
from Keccak require import Keccak1600_ref.
from Keccak require import Keccak1600_fixedsizes_ref.
require import Keccak1600_updstate_finish.
from Keccak require import Keccak1600_updstate_ref.
require BaseT.

abstract theory HashingT.

clone import BaseT.BaseT as B.
import S R MLDSAParams.

import PolyLVec PolyKVec PolyMat.
import Round ZModQ Zq.
import Array_ctilde Array_w1vec_enc Array_pk_enc.

lemma pk_encE : pk_enc = pk_bytes.
proof. by rewrite /pk_enc /t1_enc /= (: 2560 * kvec = kvec * 320 * 8) 1:#ring mulzK. qed.

lemma w1vec_encE : w1vec_enc = w1_bytes.
proof.
by rewrite /w1vec_enc /w1_enc (: n * w1_bits * kvec = kvec * (32 * w1_bits) * 8) 1:#ring mulzK.
qed.

(****************************************************************************)
(* Establish that M's keccak primitives equal Keccak1600_Jazz.M             *)
(****************************************************************************)


equiv state_init_eq:
 M.__state_init ~ Keccak1600_Jazz.M.__state_init
 : ={arg} ==> ={res}
 by sim.

equiv keccakf1600_eq:
 M._keccakf1600 ~ Keccak1600_Jazz.M._keccakf1600
 : ={arg} ==> ={res}
 by sim.

(****************************************************************************)
(* Clone KeccakArrayRef for each array size used in hashing.jinc            *)
(****************************************************************************)


clone KeccakArrayRef as A2ref
 with op _ASIZE <- 2,
      theory A <- Array2,
      theory WA <- WArray2
      proof _ASIZE_ge0 by done
      proof _ASIZE_u64 by done.

clone KeccakArrayRef as A32ref
 with op _ASIZE <- 32,
      theory A <- Array32,
      theory WA <- WArray32
      proof _ASIZE_ge0 by done
      proof _ASIZE_u64 by done.

clone KeccakArrayRef as ACTref
 with op _ASIZE <- ctilde,
      theory A <- Array_ctilde,
      theory WA <- WArray_ctilde
      proof _ASIZE_ge0 by exact ge0_ctilde
      proof _ASIZE_u64 by smt(param_sets).

clone KeccakArrayRef as A64ref
 with op _ASIZE <- 64,
      theory A <- Array64,
      theory WA <- WArray64
      proof _ASIZE_ge0 by done
      proof _ASIZE_u64 by done.

clone KeccakArrayRef as A128ref
 with op _ASIZE <- 128,
      theory A <- Array128,
      theory WA <- WArray128
      proof _ASIZE_ge0 by done
      proof _ASIZE_u64 by done.

clone KeccakArrayRef as AW1ref
 with op _ASIZE <- w1vec_enc,
      theory A <- Array_w1vec_enc,
      theory WA <- WArray_w1vec_enc
      proof _ASIZE_ge0 by exact ge0_w1vec_enc
      proof _ASIZE_u64 by smt(param_sets).

clone KeccakArrayRef as APKref
 with op _ASIZE <- pk_enc,
      theory A <- Array_pk_enc,
      theory WA <- WArray_pk_enc
      proof _ASIZE_ge0 by exact ge0_pk_enc
      proof _ASIZE_u64 by smt(param_sets).

clone KeccakArrayRef as A66ref
 with op _ASIZE <- 66,
      theory A <- Array66,
      theory WA <- WArray66
      proof _ASIZE_ge0 by done
      proof _ASIZE_u64 by done.

clone KeccakUpdstateRef as A64updstate
 with op _ASIZE <- 64,
      theory A <- Array64,
      theory WA <- WArray64
      proof _ASIZE_ge0 by done
      proof _ASIZE_u64 by done.

(****************************************************************************)
(* Equiv lemmas: M.primitive ~ KeccakArray.MM.primitive                     *)
(****************************************************************************)

equiv a2__absorb_eq:
 M.a2____absorb ~ A2ref.MM.__absorb
 : ={arg} ==> ={res}
 by sim.

equiv a32__absorb_eq:
 M.a32____absorb ~ A32ref.MM.__absorb
 : ={arg} ==> ={res}
 by sim.

equiv a64__absorb_eq:
 M.a64____absorb ~ A64ref.MM.__absorb
 : ={arg} ==> ={res}
 by sim.

equiv a66__absorb_eq:
 M.a66____absorb ~ A66ref.MM.__absorb
 : ={arg} ==> ={res}
 by sim.

equiv a128__absorb_eq:
 M.a128____absorb ~ A128ref.MM.__absorb
 : ={arg} ==> ={res}
 by sim.

equiv a_ENCODED_COMMITMENT__absorb_eq:
 M.a_ENCODED_COMMITMENT____absorb ~ AW1ref.MM.__absorb
 : ={arg} ==> ={res}.
proof.
proc; seq 2 2 : (={st, aT, buf, _TRAILB, _RATE8, offset, _LEN}).
+ by auto => />; rewrite /w1vec_enc /w1_enc; smt().
by sim.
qed.

equiv a_VERIFICATION_KEY__absorb_eq:
 M.a_VERIFICATION_KEY____absorb ~ APKref.MM.__absorb
 : ={arg} ==> ={res}.
proof.
proc; seq 2 2 : (={st, aT, buf, _TRAILB, _RATE8, offset, _LEN}).
+ by auto => />; rewrite /pk_enc /t1_enc /=; ring.
by sim.
qed.

equiv a_COMMITMENT_HASH__squeeze_eq:
 M.a_COMMITMENT_HASH____squeeze ~ ACTref.MM.__squeeze
 : ={arg} ==> ={res}
 by sim.

equiv a64__squeeze_eq:
 M.a64____squeeze ~ A64ref.MM.__squeeze
 : ={arg} ==> ={res}
 by sim.

equiv a128__squeeze_eq:
 M.a128____squeeze ~ A128ref.MM.__squeeze
 : ={arg} ==> ={res}
 by sim.

equiv add_m_updstate_eq:
 M._add_m_updstate ~ Keccak1600_Jazz.M._add_m_updstate
 : ={arg, Glob.mem} ==> ={res, Glob.mem}
 by sim.

equiv absorb_m_state_eq:
 M._absorb_m_state ~ Keccak1600_Jazz.M._absorb_m_state
 : ={arg, Glob.mem} ==> ={res, Glob.mem}
 by sim.

equiv finish_state_eq:
 M._finish_state ~ Keccak1600_Jazz.M._finish_state
 : ={arg} ==> ={res}
 by sim.

equiv a64_squeeze_state_eq:
 M.a64___squeeze_state ~ A64updstate.MM._squeeze_state
 : ={arg} ==> ={res}.
proof.
proc; inline{1} M.__KECCAK_F; inline{2} Keccak1600_Jazz.M.__KECCAK_F.
seq 4 4 : (={st, r8, at, buf, len} /\ sPILL{1} /\ !sPILL{2}); 1: by auto => />; rewrite (: 255 = 2^8 - 1) // !W256.and_mod.
seq 1 1 : (={st, r8, at, buf, len} /\ sPILL{1} /\ !sPILL{2}).
+ if => //.
  by rcondt{1} 1; [auto | rcondf{2} 1; [auto | wp; call keccakf1600_eq; auto]].
seq 3 3 : (={st, r8, at, buf, len, off}).
+ while (={st, r8, at, buf, len, off} /\ sPILL{1} /\ !sPILL{2}); 2: by auto.
  seq 1 1 : (={st, r8, at, buf, len, off} /\ sPILL{1} /\ !sPILL{2}); 1: by call (: ={arg} ==> ={res}); [sim | auto].
  by rcondt{1} 1; [auto | rcondf{2} 1; [auto | wp; call keccakf1600_eq; auto]].
by sim.
qed.

(****************************************************************************)
(* Module K: keccak-library wrapper mirroring M's hashing procedures        *)
(****************************************************************************)

module K = {

  proc _shake256_A128__A32_A2 (out:W8.t Array128.t, seed:W8.t Array32.t,
                               extra:W8.t Array2.t) : W8.t Array128.t = {
    var lanes:W64.t Array25.t;
    var  _0:int;
    var  _1:int;
    var  _2:W64.t Array25.t;
    lanes <- witness;
    lanes <@ Keccak1600_Jazz.M.__state_init (lanes);
    (lanes,  _0) <@ A32ref.MM.__absorb (lanes, 0, seed, 0, 136);
    (lanes,  _1) <@ A2ref.MM.__absorb (lanes, 32, extra, 31, 136);
    ( _2, out) <@ A128ref.MM.__squeeze (lanes, out, 136);
    return out;
  }

  proc _shake256_A64__A128 (out:W8.t Array64.t, in_0:W8.t Array128.t) :
  W8.t Array64.t = {
    var lanes:W64.t Array25.t;
    var  _0:int;
    var  _1:W64.t Array25.t;
    lanes <- witness;
    lanes <@ Keccak1600_Jazz.M.__state_init (lanes);
    (lanes,  _0) <@ A128ref.MM.__absorb (lanes, 0, in_0, 31, 136);
    ( _1, out) <@ A64ref.MM.__squeeze (lanes, out, 136);
    return out;
  }

  proc hash_verification_key (verification_key_hash:W8.t Array64.t,
                              verification_key:W8.t Array_pk_enc.t) :
  W8.t Array64.t = {
    var lanes:W64.t Array25.t;
    var  _0:int;
    var  _1:W64.t Array25.t;
    lanes <- witness;
    lanes <@ Keccak1600_Jazz.M.__state_init (lanes);
    (lanes,  _0) <@ APKref.MM.__absorb (lanes, 0, verification_key, 31, 136);
    ( _1, verification_key_hash) <@ A64ref.MM.__squeeze (lanes, verification_key_hash, 136);
    return verification_key_hash;
  }

  proc __derive_commitment_hash (commitment_hash:W8.t Array_ctilde.t,
                                 message_representative:W8.t Array64.t,
                                 encoded_commitment:W8.t Array_w1vec_enc.t) :
  W8.t Array_ctilde.t = {
    var lanes:W64.t Array25.t;
    var  _0:int;
    var  _1:int;
    var  _2:W64.t Array25.t;
    lanes <- witness;
    lanes <@ Keccak1600_Jazz.M.__state_init (lanes);
    (lanes,  _0) <@ A64ref.MM.__absorb (lanes, 0, message_representative, 0, 136);
    (lanes,  _1) <@ AW1ref.MM.__absorb (lanes, 64, encoded_commitment, 31, 136);
    ( _2, commitment_hash) <@ ACTref.MM.__squeeze (lanes, commitment_hash, 136);
    return commitment_hash;
  }

  (* Absorbs (randomness || [kvec; lvec]) via SHAKE256 and squeezes 128 bytes,
     corresponding to the keygen PRF expansion step in __keygen_internal. *)
  proc __keygen_prf (prf_output:W8.t Array128.t, randomness:W8.t Array32.t) : W8.t Array128.t = {
    var extra:W8.t Array2.t;
    extra <- witness;
    extra.[0] <- W8.of_int kvec;
    extra.[1] <- W8.of_int lvec;
    prf_output <@ _shake256_A128__A32_A2 (prf_output, randomness, extra);
    return prf_output;
  }

  proc derive_seed_for_mask (k:W8.t Array32.t, randomness:W8.t Array32.t,
                             message_representative:W8.t Array64.t,
                             seed_for_mask:W8.t Array64.t) : W8.t Array64.t = {
    var copied_32_bytes:W256.t;
    var block:W8.t Array128.t;
    block <- witness;
    copied_32_bytes <- (get256_direct (WArray32.init8 (fun i => k.[i])) 0);
    block <- (Array128.init (WArray128.get8 (WArray128.set256_direct (WArray128.init8 (fun i => block.[i])) 0 copied_32_bytes)));
    copied_32_bytes <- (get256_direct (WArray32.init8 (fun i => randomness.[i])) 0);
    block <- (Array128.init (WArray128.get8 (WArray128.set256_direct (WArray128.init8 (fun i => block.[i])) 32 copied_32_bytes)));
    copied_32_bytes <- (get256_direct (WArray64.init8 (fun i => message_representative.[i])) 0);
    block <- (Array128.init (WArray128.get8 (WArray128.set256_direct (WArray128.init8 (fun i => block.[i])) 64 copied_32_bytes)));
    copied_32_bytes <- (get256_direct (WArray64.init8 (fun i => message_representative.[i])) 32);
    block <- (Array128.init (WArray128.get8 (WArray128.set256_direct (WArray128.init8 (fun i => block.[i])) 96 copied_32_bytes)));
    seed_for_mask <@ _shake256_A64__A128 (seed_for_mask, block);
    return seed_for_mask;
  }

  (* __derive_message_representative absorbs a variable-length input through
     the 25-lane streaming procedures of Keccak1600_Jazz.M (memory pointers),
     after the fixed-size 66-byte prefix (A66ref.MM). *)
  proc __derive_message_representative (message_representative:W8.t Array64.t,
                                        verification_key_hash:W8.t Array64.t,
                                        context_pointer:int, context_size:int,
                                        message_pointer:int, message_size:int) :
  W8.t Array64.t = {
    var copied_32_bytes:W256.t;
    var prefix:W8.t Array66.t;
    var state:W64.t Array25.t;
    var trailb:W8.t;
    var at:int;
    var buf:int;
    var len:int;
    var r8:int;
    var  _0:int;
    var  _1:int;
    prefix <- witness;
    state <- witness;
    copied_32_bytes <-
    (get256_direct (WArray64.init8 (fun i => verification_key_hash.[i])) 0);
    prefix <-
    (Array66.init
    (WArray66.get8
    (WArray66.set256_direct (WArray66.init8 (fun i => prefix.[i])) 0
    copied_32_bytes)));
    copied_32_bytes <-
    (get256_direct (WArray64.init8 (fun i => verification_key_hash.[i])) 32);
    prefix <-
    (Array66.init
    (WArray66.get8
    (WArray66.set256_direct (WArray66.init8 (fun i => prefix.[i])) 32
    copied_32_bytes)));
    prefix.[64] <- (W8.of_int 0);
    prefix.[65] <- (truncateu8 (W64.of_int context_size));
    state <@ Keccak1600_Jazz.M.__state_init (state);
    (state,  _0) <@ A66ref.MM.__absorb (state, 0, prefix, 0, 136);
    at <- 66;
    buf <- context_pointer;
    len <- context_size;
    r8 <- 136;
    (state, at) <@ Keccak1600_Jazz.M._absorb_m_state (state, r8, at, buf, len);
    buf <- message_pointer;
    len <- message_size;
    r8 <- 136;
    (state, at) <@ Keccak1600_Jazz.M._absorb_m_state (state, r8, at, buf, len);
    r8 <- 136;
    trailb <- (W8.of_int 31);
    state <@ Keccak1600_Jazz.M._finish_state (state, r8, at, trailb);
    at <- 0;
    len <- 64;
    (state, message_representative,  _1) <@ A64updstate.MM._squeeze_state (state,
    r8, at, message_representative, len);
    return message_representative;
  }

}.

(****************************************************************************)
(* Equiv lemmas: M.proc ~ K.proc                                            *)
(****************************************************************************)

equiv shake256_A128__A32_A2_eq:
 M._shake256_A128__A32_A2 ~ K._shake256_A128__A32_A2
 : ={arg} ==> ={res}.
proof.
proc; inline{1} M.__KECCAK_F.
rcondf{1} 7; first by auto => />; rewrite (: 255 = 2^8 - 1) // W256.and_mod.
call a128__squeeze_eq; call a2__absorb_eq; call a32__absorb_eq; call state_init_eq.
by auto.
qed.

equiv shake256_A64__A128_eq:
 M._shake256_A64__A128 ~ K._shake256_A64__A128
 : ={arg} ==> ={res}.
proof.
proc; inline{1} M.__KECCAK_F.
rcondf{1} 7; first by auto => />; rewrite (: 255 = 2^8 - 1) // W256.and_mod.
call a64__squeeze_eq; call a128__absorb_eq; call state_init_eq.
by auto.
qed.

equiv hash_verification_key_eq:
 M.hash_verification_key ~ K.hash_verification_key
 : ={arg} ==> ={res}.
proof.
proc; inline{1} M.__KECCAK_F.
rcondf{1} 7; first by auto => />; rewrite (: 255 = 2^8 - 1) // W256.and_mod.
call a64__squeeze_eq; call a_VERIFICATION_KEY__absorb_eq; call state_init_eq.
by auto.
qed.

equiv derive_commitment_hash_eq:
 M.__derive_commitment_hash ~ K.__derive_commitment_hash
 : ={arg} ==> ={res}.
proof.
proc; inline{1} M.__KECCAK_F.
rcondf{1} 7; first by auto => />; rewrite (: 255 = 2^8 - 1) // W256.and_mod.
call a_COMMITMENT_HASH__squeeze_eq; call a_ENCODED_COMMITMENT__absorb_eq.
call a64__absorb_eq; call state_init_eq.
by auto.
qed.

equiv derive_message_representative_eq:
 M.__derive_message_representative ~ K.__derive_message_representative
 : ={arg, Glob.mem} ==> ={res, Glob.mem}.
proof.
proc.
call a64_squeeze_state_eq; wp; call finish_state_eq; wp.
call absorb_m_state_eq; wp; call absorb_m_state_eq; wp.
call a66__absorb_eq; call state_init_eq.
by auto.
qed.

equiv keygen_prf_eq:
 M.__keygen_prf ~ K.__keygen_prf
 : ={arg} ==> ={res}.
proof.
proc.
by call shake256_A128__A32_A2_eq; auto.
qed.

equiv derive_seed_for_mask_eq:
 M.derive_seed_for_mask ~ K.derive_seed_for_mask
 : ={arg} ==> ={res}.
proof.
proc.
by call shake256_A64__A128_eq; auto.
qed.

(****************************************************************************)
(* Correctness lemmas                                                       *)
(****************************************************************************)

(* ---------- _shake256_A128__A32_A2 ---------- *)

hoare shake256_A128__A32_A2_h' _seed _extra :
 K._shake256_A128__A32_A2
 : arg.`2 = _seed /\ arg.`3 = _extra
 ==> res = Array128.of_list witness (SHAKE256 (to_list _seed ++ to_list _extra) 128).
proof.
proc.
ecall (A128ref.squeeze_h out lanes 136).
ecall (A2ref.absorb_h (to_list seed) extra 31 136).
ecall (A32ref.absorb_h [<:W8.t>] seed 0 136).
ecall (state_init_h 136).
auto => &hr [Hs He] r0 h0; split => // [st1 a1] /= [Ha _]; split; 1: by rewrite size_to_list.
move=> _ [st2 a2] /= Ha2 [st3 o3] /= [_ Ho]; rewrite -(Array128.to_listK witness o3) Ho Ha2 -Hs -He.
by rewrite /SHAKE256 /KECCAK1600 /SHAKE_DS_BYTE /c512_r8.
qed.

lemma shake256_A128__A32_A2_ll : islossless K._shake256_A128__A32_A2.
proof.
proc.
call A128ref.squeeze_ll.
call A2ref.absorb_ll.
call A32ref.absorb_ll.
call state_init_ll.
by auto.
qed.

(* ---------- _shake256_A64__A128 ---------- *)

hoare shake256_A64__A128_h' _in :
 K._shake256_A64__A128
 : arg.`2 = _in
 ==> res = Array64.of_list witness (SHAKE256 (to_list _in) 64).
proof.
proc.
ecall (A64ref.squeeze_h out lanes 136).
ecall (A128ref.absorb_h [<:W8.t>] in_0 31 136).
ecall (state_init_h 136).
auto => &hr Hin r0 h0; split => // [st1 a1] /= Ha [st2 o2] /= [_ Ho].
rewrite -(Array64.to_listK witness o2) Ho Ha -Hin.
by rewrite /SHAKE256 /KECCAK1600 /SHAKE_DS_BYTE /c512_r8.
qed.

lemma shake256_A64__A128_ll : islossless K._shake256_A64__A128.
proof.
proc.
call A64ref.squeeze_ll.
call A128ref.absorb_ll.
call state_init_ll.
by auto.
qed.

(* ---------- hash_verification_key ---------- *)

hoare hash_verification_key_h' _vk :
 K.hash_verification_key
 : arg.`2 = _vk
 ==> res = Array64.of_list witness (Bytes64.to_list (H_tr (BytesPK.of_list (to_list _vk)))).
proof.
proc.
ecall (A64ref.squeeze_h verification_key_hash lanes 136).
ecall (APKref.absorb_h [<:W8.t>] verification_key 31 136).
ecall (state_init_h 136).
auto => &hr Hvk r0 h0; split => // [st1 a1] /= Ha [st2 o2] /= [_ Ho].
rewrite -(Array64.to_listK witness o2) Ho Ha -Hvk /H_tr.
rewrite BytesPK.of_listK 1:Array_pk_enc.size_to_list 1:pk_encE //.
by rewrite Bytes64.of_listK 1:size_SHAKE256 // /SHAKE256 /KECCAK1600 /SHAKE_DS_BYTE /c512_r8.
qed.

lemma hash_verification_key_ll : islossless K.hash_verification_key.
proof.
proc.
call A64ref.squeeze_ll.
call APKref.absorb_ll.
call state_init_ll.
by auto.
qed.

phoare hash_verification_key_ph' _vk :
 [ K.hash_verification_key
 : arg.`2 = _vk
 ==> res = Array64.of_list witness (Bytes64.to_list (H_tr (BytesPK.of_list (to_list _vk))))
 ] = 1%r.
proof.
by conseq hash_verification_key_ll (hash_verification_key_h' _vk).
qed.

phoare hash_verification_key_correct _vk :
 [ M.hash_verification_key
 : arg.`2 = _vk
 ==> res = Array64.of_list witness (Bytes64.to_list (H_tr (BytesPK.of_list (to_list _vk))))
 ] = 1%r.
proof.
by conseq hash_verification_key_eq (hash_verification_key_ph' _vk) => // /#.
qed.

(* ---------- __derive_commitment_hash ---------- *)

hoare derive_commitment_hash_h' _mu _w1 :
 K.__derive_commitment_hash
 : arg.`2 = _mu /\ arg.`3 = _w1
 ==> res = Array_ctilde.of_list witness (BytesCT.to_list (H_ct (Bytes64.of_list (to_list _mu)) (BytesW1.of_list (to_list _w1)))).
proof.
proc.
ecall (ACTref.squeeze_h commitment_hash lanes 136).
ecall (AW1ref.absorb_h (to_list message_representative) encoded_commitment 31 136).
ecall (A64ref.absorb_h [<:W8.t>] message_representative 0 136).
ecall (state_init_h 136).
auto => &hr [Hmu Hw1] r0 h0; split => // [st1 a1] /= [Ha _]; split; 1: by rewrite size_to_list.
move=> _ [st2 a2] /= Ha2 [st3 o3] /= [_ Ho]; rewrite -(Array_ctilde.to_listK witness o3) Ho Ha2 -Hmu -Hw1 /H_ct.
rewrite Bytes64.of_listK 1:Array64.size_to_list //.
rewrite BytesW1.of_listK 1:Array_w1vec_enc.size_to_list 1:w1vec_encE //.
by rewrite BytesCT.of_listK 1:size_SHAKE256 //; exact ge0_ctilde.
qed.

lemma derive_commitment_hash_ll : islossless K.__derive_commitment_hash.
proof.
proc.
call ACTref.squeeze_ll.
call AW1ref.absorb_ll.
call A64ref.absorb_ll.
call state_init_ll.
by auto.
qed.

phoare derive_commitment_hash_ph' _mu _w1 :
 [ K.__derive_commitment_hash
 : arg.`2 = _mu /\ arg.`3 = _w1
 ==> res = Array_ctilde.of_list witness (BytesCT.to_list (H_ct (Bytes64.of_list (to_list _mu)) (BytesW1.of_list (to_list _w1))))
 ] = 1%r.
proof.
by conseq derive_commitment_hash_ll (derive_commitment_hash_h' _mu _w1).
qed.

phoare derive_commitment_hash_ph _mu _w1 :
 [ M.__derive_commitment_hash
 : arg.`2 = _mu /\ arg.`3 = _w1
 ==> res = Array_ctilde.of_list witness (BytesCT.to_list (H_ct (Bytes64.of_list (to_list _mu)) (BytesW1.of_list (to_list _w1))))
 ] = 1%r.
proof.
by conseq derive_commitment_hash_eq (derive_commitment_hash_ph' _mu _w1) => // /#.
qed.

(* ---------- __keygen_prf ---------- *)

(* Absorbs (randomness || [W8.of_int kvec; W8.of_int lvec]) with SHAKE256 and
   squeezes 128 bytes. kvec and lvec are the matrix dimensions
   ROWS_IN_MATRIX_A and COLUMNS_IN_MATRIX_A. *)

hoare keygen_prf_h' _seed :
 K.__keygen_prf
 : arg.`2 = _seed
 ==> res = Array128.of_list witness (SHAKE256 (to_list _seed ++ [W8.of_int kvec; W8.of_int lvec]) 128).
proof.
proc.
ecall (shake256_A128__A32_A2_h' randomness extra).
auto => /> *.
by congr; congr; congr; rewrite /to_list /mkseq -iotaredE /=.
qed.

lemma keygen_prf_ll : islossless K.__keygen_prf.
proof.
proc.
call shake256_A128__A32_A2_ll.
by auto.
qed.

phoare keygen_prf_ph' _seed :
 [ K.__keygen_prf
 : arg.`2 = _seed
 ==> res = Array128.of_list witness (SHAKE256 (to_list _seed ++ [W8.of_int kvec; W8.of_int lvec]) 128)
 ] = 1%r.
proof.
by conseq keygen_prf_ll (keygen_prf_h' _seed).
qed.

phoare keygen_prf_correct _seed :
 [ M.__keygen_prf
 : arg.`2 = _seed
 ==> res = Array128.of_list witness (SHAKE256 (to_list _seed ++ [W8.of_int kvec; W8.of_int lvec]) 128)
 ] = 1%r.
proof.
by conseq keygen_prf_eq (keygen_prf_ph' _seed) => // /#.
qed.

(* ---------- __derive_message_representative ---------- *)

lemma K_derive_message_representative_ll : islossless K.__derive_message_representative.
proof.
proc.
call A64updstate.squeeze_state_ll.
wp; call finish_state_ll.
wp; call absorb_m_state_ll.
wp; call absorb_m_state_ll.
wp; call A66ref.absorb_ll.
call state_init_ll.
by auto.
qed.

hoare K_derive_message_representative_h' _vk_hash _ctx _msg :
  K.__derive_message_representative :
    arg.`2 = _vk_hash /\
    arg.`4 = List.size _ctx /\
    memread Glob.mem arg.`3 arg.`4 = _ctx /\
    arg.`6 = List.size _msg /\
    memread Glob.mem arg.`5 arg.`6 = _msg /\
    arg.`3 + List.size _ctx < W64.modulus /\
    arg.`5 + List.size _msg < W64.modulus
    ==>
    res = Array64.of_list witness (SHAKE256
      (to_list _vk_hash ++ [W8.zero; truncateu8 (W64.of_int (List.size _ctx))]
       ++ _ctx ++ _msg) 64).
proof.
proc.
seq 8 : (context_size = size _ctx /\ memread Glob.mem context_pointer context_size = _ctx
         /\ message_size = size _msg /\ memread Glob.mem message_pointer message_size = _msg
         /\ to_list prefix = to_list _vk_hash ++ [W8.zero; truncateu8 (W64.of_int (size _ctx))]).
+ auto => |> &hr Hctx Hmsg _ _.
  apply (eq_from_nth witness); 1: by rewrite size_cat !size_to_list.
  move => i; rewrite size_to_list => ib; rewrite nth_cat size_to_list /=.
  rewrite !get_setE // initiE 1:/# /=.
  case (i < 64) => Hi64; last by smt().
  rewrite ifF 1:/# ifF 1:/# /=; case (i < 32) => Hi32.
  + by rewrite ifF 1:/# /= /get8 initiE //= initiE //= /set256_direct initiE 1:/# /= ifT 1:/# /get256_direct pack32bE 1:/# initiE 1:/# /= initiE 1:/#.
  + by rewrite ifT 1:/# /get256_direct pack32bE 1:/# initiE 1:/# /= initiE 1:/#.
ecall (A64updstate.squeeze_state_h 136 (ABSORB1600 (W8.of_int 31) 136 (to_list prefix ++ memread Glob.mem context_pointer context_size ++ memread Glob.mem message_pointer message_size)) 0 message_representative len).
wp; ecall (finish_state_h 136 (W8.of_int 31) (to_list prefix ++ memread Glob.mem context_pointer context_size ++ memread Glob.mem message_pointer message_size)).
wp; ecall (absorb_m_state_h Glob.mem 136 (to_list prefix ++ memread Glob.mem context_pointer context_size) buf len).
wp; ecall (absorb_m_state_h Glob.mem 136 (to_list prefix) buf len).
wp; ecall (A66ref.absorb_h [<:W8.t>] prefix 0 136).
wp; ecall (state_init_h 136).
wp; skip => &hr [#] Hcs Hctx Hms Hmsg Hp.
split => // _ st0 H0; split; 1: by rewrite /= H0.
move=> _ [st1 a1] /= [H1 _]; split; 1: by rewrite size_to_list Hcs size_ge0 -pabsorb_spec_refE.
move=> _ [st2 a2] /= [H2 ->]; split; 1: by rewrite Hms size_ge0 H2.
move=> _ [st3 a3] /= [H3 ->] /=; split; 1: done.
move=> _ st4 ->; split; 1: by rewrite /FIPS202_SHA3_Spec.st_i iter0.
move=> _ [st5 m a5] /= [-> _]; rewrite Keccak1600_updstate.sqstream0 Hp Hctx Hmsg -!catA.
apply Array64.tP => i Hi; rewrite Array64.filliE // ifT 1:/# /= Array64.get_of_list // /SHAKE256 /KECCAK1600 /SHAKE_DS_BYTE /c512_r8.
by rewrite (nth_change_dfl witness); smt(size_SQUEEZE1600).
qed.

phoare K_derive_message_representative_ph' _vk_hash _ctx _msg :
 [ K.__derive_message_representative
 : arg.`2 = _vk_hash /\
   arg.`4 = List.size _ctx /\
   memread Glob.mem arg.`3 arg.`4 = _ctx /\
   arg.`6 = List.size _msg /\
   memread Glob.mem arg.`5 arg.`6 = _msg /\
   arg.`3 + List.size _ctx < W64.modulus /\
   arg.`5 + List.size _msg < W64.modulus
 ==> res = Array64.of_list witness (SHAKE256
       (to_list _vk_hash ++ [W8.zero; truncateu8 (W64.of_int (List.size _ctx))]
        ++ _ctx ++ _msg) 64)
 ] = 1%r.
proof.
by conseq K_derive_message_representative_ll
          (K_derive_message_representative_h' _vk_hash _ctx _msg).
qed.

phoare derive_message_representative_ph _vk_hash _ctx _msg :
 [ M.__derive_message_representative
 : arg.`2 = _vk_hash /\
   arg.`4 = List.size _ctx /\
   memread Glob.mem arg.`3 arg.`4 = _ctx /\
   arg.`6 = List.size _msg /\
   memread Glob.mem arg.`5 arg.`6 = _msg /\
   arg.`3 + List.size _ctx < W64.modulus /\
   arg.`5 + List.size _msg < W64.modulus
 ==> res = Array64.of_list witness (Bytes64.to_list
     (H_mu (Bytes64.of_list (to_list _vk_hash))
           ([W8.zero; truncateu8 (W64.of_int (List.size _ctx))] ++ _ctx ++ _msg)))
 ] = 1%r.
proof.
have Hconseq := (K_derive_message_representative_ph' _vk_hash _ctx _msg).
conseq derive_message_representative_eq Hconseq => |>.
+ move => &1 ???????; exists Glob.mem{1} arg{1}  =>/=;do split;smt(W64.to_uint_cmp pow2_64).
rewrite Bytes64.of_listK;1: by rewrite size_SHAKE256 // Bytes64.to_listK.
congr;congr.
rewrite Bytes64.of_listK;1: by rewrite size_to_list.
by rewrite -!catA /=.
qed.

(* ---------- derive_seed_for_mask ---------- *)

(* Assembles block = k || randomness || mu (128 bytes) using four 256-bit
   AVX2 copies, then calls _shake256_A64__A128.
   The result is SHAKE256(k || randomness || mu, 64) = H_rhopp(K, coins, mu)
   when rnd_to_list coins = to_list randomness. *)

hoare K_derive_seed_for_mask_h' _k _randomness _mu _arr :
  K.derive_seed_for_mask :
    arg.`1 = _k /\ arg.`2 = _randomness /\ arg.`3 = _mu /\ arg.`4 = _arr
    ==>
    res = Array64.of_list witness
            (SHAKE256 (to_list _k ++ to_list _randomness ++ to_list _mu) 64).
proof.
proc.
ecall (shake256_A64__A128_h' block).
wp; skip => />.
congr; congr;  apply (eq_from_nth witness).
  + by rewrite size_to_list !size_cat !size_to_list /=.
  move => i; rewrite size_to_list /= => Hi.
  rewrite !nth_cat !size_to_list !size_cat !size_to_list.
  case (i < 32) => Hi32.
  + rewrite ifT 1:/#.
    rewrite /get256_direct /set256_direct /get8 /pack32_t /(\bits8) wordP => k kb.
    by rewrite !initiE 1:/# /= !initiE 1:/# /= !initiE 1..3:/# /= ifF 1:/# ifF 1:/# !initiE 1..3:/# /= ifF 1:/# initiE 1:/# initiE 1:/# initiE 1:/# /= ifT 1:/# initiE 1:/# /= initiE 1:/# /= initiE 1:/# initiE 1:/# /#.
  case (i < 64) => Hi64.
  + (* 32 <= i < 64: from randomness[i-32] via set256_direct at offset 32 — ifF(96) ifF(64) ifT(32) *)
    rewrite /get256_direct /set256_direct /get8 /pack32_t /(\bits8) wordP => k kb.
    by rewrite !initiE 1:/# /= !initiE 1:/# /= !initiE 1..3:/# /= ifF 1:/# ifF 1:/# !initiE 1..3:/# /= ifT 1:/# initiE 1:/# /= initiE 1:/# /= initiE 1:/# initiE 1:/# /#.
  case (i < 96) => Hi96.
  + (* 64 <= i < 96: from mu[i-64] via set256_direct at offset 64 — ifF(96) ifT(64) *)
    rewrite /get256_direct /set256_direct /get8 /pack32_t /(\bits8) wordP => k kb.
    by rewrite !initiE 1:/# /= !initiE 1:/# /= !initiE 1..3:/# /= ifF 1:/# !initiE 1..3:/# /= ifT 1:/# initiE 1:/# /= initiE 1:/# /= initiE 1:/# initiE 1:/# /#.
  + (* 96 <= i < 128: from mu[i-64] via set256_direct at offset 96 — ifT(96) *)
    rewrite /get256_direct /set256_direct /get8 /pack32_t /(\bits8) wordP => k kb.
    rewrite !initiE 1:/# /= !initiE 1:/# /= !initiE 1..3:/# /= ifT 1:/# initiE 1:/# /= initiE 1:/# /= ifF 1:/# initiE 1:/# /= initiE 1:/# /#.
qed.

lemma K_derive_seed_for_mask_ll : islossless K.derive_seed_for_mask.
proof.
proc.
call shake256_A64__A128_ll.
by auto.
qed.

phoare K_derive_seed_for_mask_ph' _k _randomness _mu _arr :
 [ K.derive_seed_for_mask
 : arg.`1 = _k /\ arg.`2 = _randomness /\ arg.`3 = _mu /\ arg.`4 = _arr
 ==> res = Array64.of_list witness
             (SHAKE256 (to_list _k ++ to_list _randomness ++ to_list _mu) 64)
 ] = 1%r.
proof.
by conseq K_derive_seed_for_mask_ll (K_derive_seed_for_mask_h' _k _randomness _mu _arr).
qed.

phoare derive_seed_for_mask_ph _k _randomness _mu _arr :
  [ M.derive_seed_for_mask :
    arg.`1 = _k /\ arg.`2 = _randomness /\ arg.`3 = _mu /\ arg.`4 = _arr
    ==>
    res = Array64.of_list witness
            (SHAKE256 (to_list _k ++ to_list _randomness ++ to_list _mu) 64)
  ] = 1%r.
proof.
by conseq derive_seed_for_mask_eq (K_derive_seed_for_mask_ph' _k _randomness _mu _arr) => // /#.
qed.

end HashingT.
