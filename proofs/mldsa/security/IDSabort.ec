require import AllCore Int Real List FinType DBool.

abstract theory IDS.
(* Generic types for
   public and secret key,
   commitment W, challenge C, response Z,
   and internal state of the prover
*)
type PK, SK, W, C, Z, Pstate.

type LkgC.
type LkgR.

type transcript = W * C * Z.
type LkgTr = LkgC * LkgR.

type otranscript = [
  | TrF of LkgTr
  | TrS of transcript & LkgTr
].

op is_fail(tr : otranscript) : bool =
 match tr with
 | TrF _ => true
 | TrS _ _ => false
 end.

op tr_lkg(tr : otranscript) : LkgTr =
 match tr with
 | TrF l => l
 | TrS _ l => l
 end.

op tr_wcz(tr : otranscript) : transcript =
 match tr with
 | TrF _ => witness
 | TrS t _ => t
 end.

(* ---------------------------------------------------------------------------*)
(*   Identification scheme (protocol between prover and verifier)             *)
(* ---------------------------------------------------------------------------*)

(* Generic prover *)
module type Prover = {
  proc keygen(): PK * SK
  proc commit(sk:SK): W * LkgC
  proc respond(sk:SK, c:C): Z option * LkgR
}.

(* Generic verifier *)
module type Verifier ={
  proc challenge(w:W, pk:PK): C
  proc verify(pk:PK, w:W, c:C, z:Z): bool
}.

(* -----------------------------------------------------
    Security for IDS: HonestVerifierZeroKnowledge
   ----------------------------------------------------- *)


(***********************************************************)
(*     HVZK: There exists an HVZK_Sim such that            *)
(*     HVZK_Sim.getTrace(pk)                               *)
(*             ~ Honest_Execution.get_trace()              *)
(***********************************************************)

(* Simulator for HVZK that generates valid transcripts given a public key *)
module type HVZK_Sim = {
  proc get_trans(pk:PK) : otranscript
}.


(* Module that generates transcripts of honest executions as reference *)

module Honest_Execution (P: Prover, V: Verifier) = {
  proc get_trans(pk:PK, sk:SK) = {
    var w, c, oz, r;
    var lc, lr;

    (w, lc) <@ P.commit(sk);
    c <@ V.challenge(w, pk);
    (oz, lr) <@ P.respond(sk, c);
    r <- if oz = None
         then TrF (lc, lr)
         else TrS (w, c, oget oz) (lc, lr);
    return r;
  }
}.


end IDS.
