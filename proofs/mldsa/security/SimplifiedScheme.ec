require import AllCore Distr List Leakage DistrExtras FMap.
require import Finite DBool.
import Biased.
require SampleInBallEquiv DigitalSignaturesLeakageRO Byte.
require import RealSeries Supplementary Finite.
require import IntDiv.
require import Nat.

require import IDSabort.
require FSabort.
require FSa_CMAtoKOA.
require FSa_CRtoGen.

require DRing DVect MLWE SelfTargetMSISLeakage ChallengeFiber.

require DParams.

clone import DParams as Params.

(* Parameters of the security games *)
const qS : int. (* allowed number of sig queries *)
const qH : int. (* allowed number of ro  queries *)
axiom qS_ge0 : 0 <= qS.
axiom qH_ge0 : 0 <= qH.

(* Bound on the number of iterations of the signing loop *)
op kappa : { int | 0 < kappa } as gt0_kappa.

(* Dilithium-specific parameters *)

(* Abstract theory representing Rq = Zq[X]/(X^n + 1) and the high/lowBits operations *)
(* The constants [n] and [q] are defined by this theory *)
clone import DRing as DR with
  op q <= q,
  op n <= n
proof prime_q by exact prime_q
proof gt0_n by exact gt0_n.
import RqRing.

clone import DVect as DV with
  theory DR <- DR,
  op HL.alpha <- 2*gamma2,
  op HL.d     <- d
proof HL.ge2_alpha, HL.alpha_halfq_le, HL.even_alpha, HL.alpha_almost_divides_q, HL.d_bound.
realize HL.ge2_alpha by smt(gamma2_bound).
realize HL.even_alpha by smt().
realize HL.alpha_halfq_le by smt(gamma2_bound).
realize HL.alpha_almost_divides_q by apply gamma2_div.
realize HL.d_bound by smt(gt0_d pow2_d_lt_q).

import DV.MatRq. (* Matrices and Vectors over Rq *)
import DV.HL.    (* highBitsV and lowBitsV with HL.alpha = 2 * gamma2 and HL.d = d *)

lemma cnorm_dC c tau : c \in dC tau => cnorm c <= 1 by smt(supp_dC).

(* Distribution of the coefficients of the masking vector [y]. FIPS 204 uses
   coefficients uniform in [-gamma1 + 1, gamma1]; the proof only needs the
   following properties, in particular that every [x] with
   [cnorm x <= gamma1 - 1] is in the support. *)
op dmask : Rq distr.
axiom dmask_ll : is_lossless dmask.
axiom dmask_uni : is_uniform dmask.
axiom dmask_fin : is_finite (support dmask).
axiom dmask_supp x : cnorm x <= gamma1 - 1 => x \in dmask.

(* Conversion of the coefficient list computed by [SampleInBall] into a ring
   element. It must be injective on the valid challenge encodings: lists of
   [256] coefficients in {-1, 0, 1} (see [SampleInBallEquiv]). *)
op to_concrete : int list -> Rq.
axiom to_concrete_inj_in (x y : int list) :
  size x = 256 => all (fun c => c = -1 \/ c = 0 \/ c = 1) x =>
  size y = 256 => all (fun c => c = -1 \/ c = 0 \/ c = 1) y =>
  to_concrete x = to_concrete y => x = y.

type M.

type SK = matrix * vector * vector.
type PK = matrix * vector.
type commit_t = high list.
type response_t = vector * hint_t list.

clone SampleInBallEquiv as SIB with
  type in_t <= commit_t * M,
  type challenge <- Rq,
  type input <- unit,
  type output <- bool,
  op to_concrete <- to_concrete,
  theory Params <- Params
proof*.
realize to_concrete_inj_in.
move=> x y _ _ eq_xy.
have [szx hx] := SIB.to_challenge_valid x.
have [szy hy] := SIB.to_challenge_valid y.
exact (to_concrete_inj_in _ _ szx hx szy hy eq_xy).
qed.

(* The challenges of the simplified scheme are the outputs of the ideal
   challenge oracle [SIB.ROC] of [SampleInBallEquiv]: a pre-image computed
   by [SampleInBall] (sign bytes and accepted index bytes), the ring element
   being [to_c c], together with the leakage of the rejected bytes.  The
   leakage of [SampleInBall] ([SIB.full_leak], which interleaves the rejected
   bytes and the accepted indices in time order) is a function of both, so
   that it can be leaked by the response (see [resp_leak]). *)
type challenge_t = SIB.challenge_ir * leakage.

op to_c (c : challenge_t) : Rq = to_concrete (SIB.to_challenge c.`1).

(* The distribution of the challenges: the output distribution of the ideal
   challenge oracle [SIB.ROC] *)
op dC_t : challenge_t distr = SIB.dI `*` SIB.dLeakRej.

lemma dC_t_ll : is_lossless dC_t.
proof. by apply dprod_ll; split; [exact SIB.dI_ll | exact SIB.dLeakRej_ll]. qed.

lemma supp_dC_t (c : challenge_t) : c \in dC_t <=> c.`1 \in SIB.dI /\ c.`2 \in SIB.dLeakRej.
proof. exact supp_dprod. qed.

(* The efficient sampler of uniform pre-images of a challenge (the
   backward partial Fisher-Yates shuffle of [ChallengeFiber]). *)
clone ChallengeFiber as CF with
  theory Params <- Params,
  theory DR <- DR,
  type in_t <- commit_t * M,
  op to_concrete <- to_concrete
proof *.
realize to_concrete_inj_in by exact to_concrete_inj_in.

lemma CF_dI : CF.SIB.dI = SIB.dI.
proof. by rewrite /CF.SIB.dI /SIB.dI. qed.

lemma CF_to_challenge : CF.SIB.to_challenge = SIB.to_challenge.
proof. by rewrite /CF.SIB.to_challenge /SIB.to_challenge. qed.

lemma CF_to_c (c : challenge_t) : CF.to_c c.`1 = to_c c.
proof. by rewrite /CF.to_c /to_c CF_to_challenge. qed.

(* Just storing `y` should be good here. *)
type pstate_t = vector.

clone IDS as DID with
  type PK <= PK,
  type SK <= SK,
  type W <= commit_t,
  type C <= challenge_t,
  type Z <= response_t,
  type Pstate <= pstate_t,
  type LkgC <- leakage,
  type LkgR <- leakage
proof*.

(* TODO: this equivalence needs the coefficients of the ring; it is an
   assumption here, proved for the concrete ring Zq[X]/(X^n + 1) in
   [ConcreteMLDSA]. *)
axiom dC_equiv : dC tau = SIB.dC.

(* The ring challenges are the images by [to_c] of the challenges *)
lemma dC_t_to_c : dmap dC_t to_c = dmap SIB.dI (to_concrete \o SIB.to_challenge).
proof.
rewrite /dC_t (_ : to_c = (to_concrete \o SIB.to_challenge) \o fst) //.
by rewrite -dmap_comp (dprod_marginalL _ _ idfun) SIB.dLeakRej_ll dscalar1 dmap_id.
qed.

lemma dC_to_c : dC tau = dmap dC_t to_c.
proof. by rewrite dC_equiv dC_t_to_c. qed.

lemma to_c_dC c : c \in dC_t => to_c c \in dC tau.
proof. by move=> c_in; rewrite dC_to_c; apply supp_dmap; exists c. qed.

lemma cnorm_to_c c : c \in dC_t => cnorm (to_c c) <= 1.
proof. by move=> /to_c_dC /cnorm_dC. qed.

lemma l1_norm_to_c c : c \in dC_t => l1_norm (to_c c) = tau.
proof. by move=> /to_c_dC; rewrite supp_dC. qed.

(* A challenge times a short secret is bounded by [beta] *)
lemma norm_cs_le_beta c s :
  c \in dC_t => inf_normv s <= eta_ => inf_normv (to_c c ** s) <= beta_.
proof.
move=> c_in norm_s; apply: StdOrder.IntOrder.ler_trans eta_tau_leq_b; rewrite mulrC.
by apply l1_inf_norm_product_ub; rewrite ?l1_norm_to_c //; smt(tau_bound gt0_eta).
qed.

(* The commitment [A y - c s2] in terms of the response [z = y + c s1] and of
   the public key [t = A s1 + s2], and with the split [t = t1 2^d + t0] *)
lemma sub_ct_split (x t : vector) (c : Rq) :
  x - c ** t = x - c ** base2lowbitsV t - c ** base2shiftV (base2highbitsV t).
proof. by rewrite -{1}(b2high_lowPv t) scalarvDr oppvD -addvA; congr; exact addvC. qed.

lemma commit_identity (mA : matrix) (y s1 s2 : vector) (c : Rq) :
  size mA = (k, l) => size s2 = k =>
  mA *^ y - c ** s2 = mA *^ (y + c ** s1) - c ** (mA *^ s1 + s2).
proof.
move=> size_mA size_s2; rewrite mulmxvDr -addvA; congr.
rewrite mulmx_scalarv scalarvDr oppvD addvA addvN.
by rewrite lin_add0v // size_oppv !size_scalarv size_mulmxv /#.
qed.

lemma commit_identity_split (mA : matrix) (y s1 s2 : vector) (c : Rq) :
  size mA = (k, l) => size s2 = k =>
  mA *^ y - c ** s2 =
  mA *^ (y + c ** s1) - c ** base2lowbitsV (mA *^ s1 + s2)
                      - c ** base2shiftV (base2highbitsV (mA *^ s1 + s2)).
proof. by move=> size_mA size_s2; rewrite (commit_identity _ _ s1) // sub_ct_split. qed.

clone import FSabort as FSa with
  type M <- M,
  type ID.PK <= PK,
  type ID.SK <= SK,
  type ID.W <= commit_t,
  type ID.C <= challenge_t,
  type ID.Z <= response_t,
  type ID.Pstate <= pstate_t,
  op dC <= dC_t,
  op dLkgRO <= dunit Empty,
  op kappa <= kappa
proof*.
realize gt0_kappa by exact gt0_kappa.
realize dC_ll by exact dC_t_ll.
realize dLkgRO_ll by exact dunit_ll.

(* -- Procedure-based -- *)

op recover (pk : PK) (c : challenge_t) (resp : response_t) : commit_t =
  let (mA, t) = pk in
  let (z, h) = resp in
  useHintV h (mA *^ z - to_c c ** base2shiftV (base2highbitsV t)).

clone FSa.CommRecov as FSaCR with
  op recover <= recover,
  op qS <= qS,
  op qH <= qH
proof* by smt(qS_ge0 qH_ge0).

import FSaCR.
import FSaCR.DSS.

(* Signatures of the scheme with a XOF: the (ring) challenge and the response *)
type SigXOF = Rq * response_t.

clone DigitalSignaturesLeakageRO as DSSXOF with
type DS.pk_t <- PK,
type DS.sk_t <- SK,
type DS.msg_t <- M,
type DS.sig_t <- SigXOF,
type DS.lkg_t <- leakage,
type PRO.in_t <= (DID.W * M) * int,
type PRO.out_t <= Byte.byte,
op   PRO.dout <= fun _ => Byte.dB,
op   EFCMA.q_efcma <= qS
proof* by smt(qS_ge0).


(* This scheme corresponds to the scheme in KLS18 Figure 13, whith the
following minor differences:

- We (uniformly) sample the matrix A rather than a seed
- The public key is (A, t) rather than (A, t1, t0)
- The secret key is (A, s1, s2) rather than (A, s1, s2, t0)
- sign (resp. verify) computes t0 (t1) from s1 and s2 (t).
- due to liberal typing, verify needs to check the size (length) of the signature

This avoids having to split/merge t (e.g., in the MLWE reduction). We
eliminate these differences using a separate reduction *)

(* The rejection tests of a signing iteration are abstract (as in
   [MLDSATarget]).  The tests on [z], on [w0 = w - c s2] and on the hint [h]
   return [None] when they pass and, when they fail, a value in [0, M) which
   is leaked: typically the index of the first failing polynomial or
   coefficient of a short-circuit cascade (see [DV.first_fail]; canonical
   instances in [MLDSATarget] and [ConcreteMLDSA]).  The proof needs:
   - the range of the failing value: [Mz + Mr0 + Mhint + 1] enters the bound
     (it is the number of possible outcomes of a failing response);
   - the characterization of success by the norm bound, for [z], [w0] and
     the test on [c t0];
   - for [z], the invariance under small shifts of the distribution of the
     outcome on a masking vector: the simulator does not know [s1].
   The tests on [w0] and on [h] are only performed, and their outcome only
   leaked, when the previous test passed.  The test on [c t0] is a boolean:
   [c] is leaked and [t0 = base2lowbitsV t] is a function of the public key
   [(mA, t)] (it is leaked once by [DilithiumR] and [MLDSATarget]), so it is
   a public computation which can be performed anywhere, at any granularity.
   The vector [t0] (the low bits of [t], part of the secret key in ML-DSA)
   is treated as public by the security proof. *)
op check_z    : vector -> int option.
op check_r0   : vector -> int option.
op check_hint : hint_t list -> int option.
op check_ct0  : vector -> bool.

op Mz, Mr0, Mhint : int.
axiom ge0_Mz : 0 <= Mz.
axiom ge0_Mr0 : 0 <= Mr0.
axiom ge0_Mhint : 0 <= Mhint.

axiom check_z_range z i    : check_z z = Some i    => 0 <= i < Mz.
axiom check_r0_range w0 i  : check_r0 w0 = Some i  => 0 <= i < Mr0.
axiom check_hint_range h i : check_hint h = Some i => 0 <= i < Mhint.

axiom check_z_None z :
  size z = l => check_z z = None <=> inf_normv z < gamma1 - beta_.
axiom check_r0_None w0 :
  size w0 = k => check_r0 w0 = None <=> inf_normv (lowBitsV w0) < gamma2 - beta_.
axiom check_ct0_None v :
  size v = k => check_ct0 v <=> inf_normv v < gamma2.

(* The outcome of the test on [y + v] does not depend on the shift [v] when
   [y] is a masking vector and [||v||_inf <= beta] *)
axiom check_z_shift (v : vector) :
  size v = l => inf_normv v <= beta_ =>
  dmap (dvector dmask l) (fun y => check_z (y + v)) =
  dmap (dvector dmask l) check_z.

op check_hw (h : hint_t list) = check_hint h = None.

(* Encoding of a ring element as a list of integers, used to leak [c] and
   [t0] (instantiated with the coefficient list [ofRq] in [MLDSAProof]). *)
op Rq_enc : Rq -> int list.

(* Declassification of a challenge and of t0 *)
op c_leak (c : Rq) : leakage = [List (map Int (Rq_enc c))].

op t0_leak (t0 : vector) : leakage =
  [List (map (fun p => List (map Int (Rq_enc p))) (tolist t0))].

(* Leakage of the response of one iteration, a flat list of items appended
   with [lcat]: the leakage of [SampleInBall] (the rejected bytes and the
   accepted indices of the challenge, in time order), the ring challenge,
   and the outcomes of the tests that are performed.  The commitment and
   the random oracle of the FS+abort chain leak nothing ([Empty]), so the
   trace of [DilithiumS] is the trace of [DilithiumR] (the format of
   [MLDSATarget]) without its initial item [t0_leak t0]: [t0] is a function
   of the public key, its leakage is prepended by the reduction [RedXOF]. *)
op resp_leak (c : challenge_t) (z_fail r0_fail hint_fail : int option) : leakage =
  lcat (SIB.full_leak c.`1 (SIB.leakage_to_rej c.`2))
  (lcat (c_leak (to_c c))
  (lcat (oileak z_fail)
    (if z_fail = None then
       lcat (oileak r0_fail) (if r0_fail = None then oileak hint_fail else Empty)
     else Empty))).

module (DilithiumS : SchemeRO)(H: Hash) = {
  proc keygen() : PK * SK = {
    var pk, sk;
    var mA, s1, s2, t;
    mA <$ dmatrix dRq k l;
    s1 <$ dvector (dRq_ Params.eta_) l;
    s2 <$ dvector (dRq_ Params.eta_) k;
    t  <- mA *^ s1 + s2;
    pk <- (mA, t);
    sk <- (mA, s1, s2);
    return (pk, sk);
  }

  proc sign(sk: SK, m: M) : Sig option * leakage = {
    var z : vector;
    var h : hint_t list;
    var response : response_t option;
    var c : challenge_t;
    var ctr : int;
    var y, w, w1;
    var mA, s1, s2;
    var t0;
    var lc, lz, leak, w0;
    var ct0_ok : bool;
    var z_fail, r0_fail, hint_fail : int option;
    (* silences unused variable warning *)
    c <- witness;
    r0_fail <- witness;
    hint_fail <- witness;

    (mA, s1, s2) <- sk;
    t0 <- base2lowbitsV (mA *^ s1 + s2); (* compute t0 *)

    leak <- Empty;
    response <- None;
    ctr <- 0;
    while(response = None /\ ctr < kappa) {
      y <$ dvector dmask l;
      w <- mA *^ y;
      w1 <- highBitsV w;
      (c, lc) <@ H.get(w1, m);
      z <- y + to_c c ** s1;
      z_fail <- check_z z;
      if (z_fail = None) {
        w0 <- w - to_c c ** s2;
        r0_fail <- check_r0 w0;
        if (r0_fail = None) {
          h <- makeHintV (- to_c c ** t0) (w0 + to_c c ** t0);
          hint_fail <- check_hint h;
          (* test on c t0: a public computation of the leaked c and of t0
             (a function of the public key) *)
          ct0_ok <- check_ct0 (to_c c ** t0);
          if (ct0_ok /\ hint_fail = None) {
            response <- Some (z, h);
          }
        }
      }
      (* the response leaks the leakage of [SampleInBall], the challenge
         and the outcomes of the tests ([resp_leak]); the random oracle
         leaks nothing ([lc = Empty]) *)
      lz <- resp_leak c z_fail r0_fail hint_fail;
      leak <- catFS leak (response = None, (Empty, lc, lz));
      ctr <- ctr + 1;
    }
    return (omap (fun r => (c, r)) response, leak);
  }

  proc verify(pk: PK, m : M, sig : Sig) = {
    var w1, c;
    var response;
    var z, h;
    var cl';
    var mA, t, t1;
    var result;
    (mA, t) <- pk;
    t1 <- base2highbitsV t; (* t only used to compure t1 *)

    (c, response) <- sig;
    (z, h) <- response;
    w1 <- useHintV h (mA *^ z - to_c c ** base2shiftV t1);
    cl' <@ H.get((w1, m));
    result <- size z = l /\ size h = k /\ inf_normv z < gamma1 - beta_ /\ c = cl'.`1;

    return result;
  }
}.

(** KOA to MLWE + SelfTargetMSIS *)

clone import MLWE as RqMLWE with
  theory M <- MatRq,
  op dR <- dRq,
  op dS <- dRq_ Params.eta_,
  op k <- k,
  op l <- l
proof* by smt(gt0_k gt0_l).

(* The reduction [RedStd] of [SelfTargetMSISLeakage] (from the game with
   challenges to the standard SelfTargetMSIS game) samples a challenge
   (pre-image and rejected bytes) of each ring challenge by calling a
   fibre-sampling program.  It is instantiated with the program
   [FiberSamplerRej], which runs [CF.FiberSampler] (sampling
   [CF.dfiber], see [CF.FiberSampler_dfiber]: [tau] uniform choices among at
   most 256 positions plus [64 - tau] coins) and samples the leakage of the
   rejected bytes in [SIB.dLeakRej] ([FiberSamplerRej_DFiber]).  Hence the
   reduction to the standard SelfTargetMSIS assumption is PPT. *)
clone import SelfTargetMSISLeakage as RqStMSIS with
  theory M <- MatRq,
  type M <- M,
  type C <- challenge_t,
  type LkgRO <- leakage,
  op m <- k,
  op n <- l+1,
  op dR <- dRq,
  op dC <- dC_t,
  op to_R <- to_c,
  op dfiber <- fun r => CF.dfiber r `*` SIB.dLeakRej,
  op dLkgRO <- dunit Empty,
  op inf_norm <- inf_normv,
  op gamma <- max (gamma1 - beta_) (tau * 2^(d-1) + (2*gamma2+1))
proof *.
realize gt0_m by smt(gt0_k).
realize gt0_n by smt(Params.gt0_l).
realize dC_ll by exact dC_t_ll.
realize dLkgRO_ll by exact dunit_ll.
realize dfiber_supp.
move=> r c; rewrite /dCR dC_t_to_c supp_dprod => hr [hc _]; rewrite -CF_to_c.
by apply (CF.dfiber_supp r c.`1) => //; rewrite /CF.dCR CF_dI.
qed.

realize dfiber_marginal.
have -> : dCR = CF.dCR by rewrite /dCR dC_t_to_c /CF.dCR CF_dI /CF.to_c CF_to_challenge.
rewrite /dC_t (dprod_dlet SIB.dI) -CF_dI -CF.dfiber_marginal (dlet_dlet CF.dCR).
by apply eq_dlet => // r; exact dprod_dlet.
qed.

module H = DSS.PRO.RO.
module G = RqStMSIS.PRO.RO.

module RedMLWE (A : Adv_EFKOA_RO) (H : Hash_i) : RqMLWE.Adversary = {
  proc distinguish (mA : matrix, t : vector) = {
    var pk, m, sig, r;
    H.init();
    pk <- (mA, t);
    (m, sig) <@ A(H).forge(pk);
    r <@ DilithiumS(H).verify(pk, m, sig);
    return r;
  }
}.

module HS (G : RqStMSIS.PRO.RO) : Hash_i = {
  proc init = G.init

  proc get(w1, mu) = {
    var r;
    r <@ G.get(shiftV w1, mu);
    return r;
  }
}.

module H' = HS(G).

module RedMSIS (A : Adv_EFKOA_RO) (H : RqStMSIS.PRO.RO) = {
  proc guess(mB : matrix) : vector * M = {
    var mA, tbar, t, mu, sig, c, zh, z, h;
    var t1, r, u1, u2, y;
    mA <- subm mB 0 k 0 l;
    tbar <- col mB l;
    t <- -tbar;
    (mu, sig) <@ A(HS(H)).forge(mA, t);
    y <- witness;
    (c, zh) <- sig;
    (z, h) <- zh;
    t1 <- base2highbitsV t;
    r <- mA *^z - to_c c ** base2shiftV t1;
    u1 <- r - shiftV (useHintV h r);
    u2 <- to_c c ** base2lowbitsV t;
    y <- (u2 - u1) || z || vectc 1 (to_c c);

    return (y, mu);
  }
}.


section PROOF.

declare module A <: Adv_EFKOA_RO{-H, -G}.

local module S1 (H : Hash) = {
  proc keygen() : PK * SK = {
    var pk, mA, t;
    mA <$ dmatrix dRq k l;
    t  <$ dvector dRq k;
    pk <- (mA, t);
    return (pk, witness);
  }

  proc sign(sk: SK, m: M) : Sig option * leakage = { return witness; }

  proc verify = DilithiumS(H).verify
}.

(* Hop 1 : replace keygen with (completely) random public key *)
local lemma hop1 &m :
  Pr [EF_KOA_RO(DilithiumS, A, H).main() @ &m : res ] <=
  Pr [EF_KOA_RO(S1, A, H).main() @ &m : res] +
  `| Pr[ GameL(RedMLWE(A, H)).main() @ &m : res ] - Pr [ GameR(RedMLWE(A, H)).main() @ &m : res ] |.
proof.
have -> : Pr [EF_KOA_RO(DilithiumS, A, H).main() @ &m : res ] =
          Pr[ GameL(RedMLWE(A, H)).main() @ &m : res ].
- byequiv (_: ={glob A, glob H} ==> ={res}) => //; proc.
  inline{1} 2; inline{1} 2; inline{2} 4. swap{2} 6 -5.
  by sim.
suff -> : Pr [EF_KOA_RO(S1, A, H).main() @ &m : res ] =
          Pr[ GameR(RedMLWE(A, H)).main() @ &m : res ] by smt().
- byequiv (_: ={glob A, glob H} ==> ={res}) => //; proc.
  inline{1} 2; inline{1} 2; inline{2} 3. swap{2} 5 -4.
  by sim; wp; sim.
qed.

import SmtMap.

(* Hop2 : replace H with H' (wrapped RO from SelfTargetMSIS *)
local lemma hop2 &m :
  Pr [EF_KOA_RO(S1, A, H).main() @ &m : res] = Pr [EF_KOA_RO(S1, A, H').main() @ &m : res].
proof.
byequiv (_ : ={glob A} ==> ={res}) => //; proc.
inline{1} 2; inline{2} 2.
seq 3 3 : (={m, sig, pk} /\
           forall (w : commit_t) (mu : M),
             H.m.[(w, mu)]{1} = G.m.[(shiftV w, mu)]{2}).
- call (:forall (w : commit_t) (mu : M),
         H.m.[(w, mu)]{1} = G.m.[(shiftV w, mu)]{2}).
  + proc; inline*; sp.
    seq 1 1 : (#pre /\ r{1} = r0{2}); first by auto.
    if; 1, 3: by auto => /> /#.
    auto => /> &1 &2 ??; split; 1: by rewrite !get_set_eqE //.
    move => w mu0; rewrite !get_setE.
    case (w = w1{2}) => />; 1:smt().
    move => ?; rewrite ifF; smt(shiftV_inj).

  by inline*; auto => />; smt(emptyE).
inline*; auto => /> &1 &2 *; do split =>*; do split =>*;
 1..3: by rewrite !get_setE // /#.
by do congr; smt().
qed.

import StdOrder.RealOrder.

(* move to EC lib? *)
lemma maxr_lerP (i j k : int) : i <= max j k <=> i <= j \/ i <= k by smt().

local lemma hop3 &m :
  Pr[EF_KOA_RO(S1, A, H').main() @ &m : res] <= Pr[Game(RedMSIS(A), G).main() @ &m : res].
proof.
byequiv (_ : ={glob A} ==> res{1} => res{2}) => //; proc.
inline{1} 2; inline{1} 1. inline{1} 2; inline{2} 3.
seq 6 7 : (={sig, PRO.RO.m} /\ (forall x, x \in PRO.RO.m => oget PRO.RO.m.[x] \in dC_t `*` dunit Empty){1}
           /\ m{1} = mu0{2} /\ pk{1} = (mA0, t){2} /\
           (mA = (mA0 || - colmx t) /\ size mA0 = (k, l) /\ size t = k){2}).
- (* merge [dmatrix/dvector] sampling on LHS *)
  seq 3 2 : (={glob A, PRO.RO.m} /\ (forall x, x \in PRO.RO.m => oget PRO.RO.m.[x] \in dC_t `*` dunit Empty){1}
            /\ size mA{1} = (k, l) /\ size t{1} = k /\
            (mA || - colmx t){1} = mA{2}).
  + inline*; sp 1 1.
    conseq (:_ ==> size mA{1} = (k, l) /\ size t{1} = k /\ (mA || - colmx t){1} = mA{2}).
    * smt(emptyE).
    rnd (fun mAt : matrix * vector => (mAt.`1 || -colmx mAt.`2))
        (fun mAt : matrix => (subm mAt 0 k 0 l, - col mAt l)) : *0 *0.
    skip => /= &1 &2 _. split => [A|?]; last split => [A|?].
    * rewrite dmap_id => /size_dmatrix /(_ _ _) /=; 1, 2: smt(gt0_k Params.gt0_l).
      rewrite colmxN oppvK => -[<-] ?. rewrite subm_colmx; smt(gt0_k Params.gt0_l).
    * rewrite -(dmap_dprodE _ _ (fun x => x)) !dmap_id.
      rewrite dprod1E (@dvector_rnd_funi _ _ (col A l)) ?dRq_funi // -dprod1E.
      move/size_dmatrix => /(_ _ _); 1, 2: smt(gt0_k Params.gt0_l).
      apply dmatrixRSr1E; 1, 2: smt(gt0_k Params.gt0_l).
    case => A t /=; rewrite -(dmap_dprodE _ _ (fun x => x)) !dmap_id supp_dprod /=.
    case => supp_A supp_t.
    move: (supp_A) => /size_dmatrix /(_ _ _) /=; 1, 2: smt(gt0_k Params.gt0_l).
    move: (supp_t) => /size_dvector. rewrite lez_maxr; 1:smt(gt0_k). move => s_t [r_A c_A].
    (* case => /supp_dmatrix_Rqkl /= [[r_A c_A] Rq_A] /supp_dvector_Rqk [s_t Rq_t]. *)
    rewrite r_A c_A s_t /= -{2}r_A -{2}c_A subm_catmrCl /=.
    rewrite col_catmrR /= ?r_A ?c_A ?s_t // subrr.
    rewrite colN oppmK colK /=; apply supp_dmatrix_catmr => //; 1, 2: smt(gt0_k Params.gt0_l).
    rewrite supp_dmatrix_full ?dRq_fu //; smt(gt0_k Params.gt0_l).
  call (: ={PRO.RO.m} /\ (forall x, x \in PRO.RO.m => oget PRO.RO.m.[x] \in dC_t `*` dunit Empty){1}).
    proc; inline*; auto => /> &2 ? r0 ?? x0 ?.
    + case (x0 = (shiftV w1{2}, mu{2})) => *.
      + rewrite get_set_eqE /#.
      rewrite get_set_neqE 1:/#; smt(mem_set).
  auto => /> &1 &2 RO_dC r_mA c_mA s_t. split => [|E1 E2].
  + rewrite -r_mA -c_mA subm_catmrCl /=.
    rewrite col_catmrR //= 1:/#.
    by rewrite colN oppmK colK.
  move => _ _.
  by rewrite -E1 -E2 /= rows_catmr //=; smt(gt0_k Params.gt0_l).
(* If A forges successfully the reduction succeeds in the SelfTargetMSIS game *)
inline S1(H').verify  H'.get. wp. sp.
(* need [size z{1} = l /\ size h{1} = l] to prove equality of the RO argument *)
case (size z{1} = l /\ size h{1} = k);
  last by conseq (:_ ==> true); [ smt() | inline*; auto].
call(: ={arg, glob G} /\ (forall x, x \in PRO.RO.m => oget PRO.RO.m.[x] \in dC_t `*` dunit Empty){1}
       ==> ={res} /\ res{1} \in dC_t `*` dunit Empty).
- proc; inline*; auto => /> &2 ? r0 ?.
    + case (x{2} \notin PRO.RO.m{2}) => * /=.
      + rewrite get_set_eqE /#.
      by smt().
auto => /> &1 _.
move: (mA0{1}) (t{1}) (z{1}) (c0{1}) (h{1}) => mA t z c h {&1 &m}.
move => r_mA c_mA size_t size_z size_h.
(* Recover the definitions from the reduction *)
pose t0 := base2lowbitsV t.
pose t1 := base2highbitsV t.
pose r  := mA *^ z - to_c c ** base2shiftV t1.
pose r' := shiftV (useHintV h r).
pose u1 := r - r'; pose u2 := to_c c ** t0.
have size_Az : size (mA *^ z) = k by rewrite size_mulmxv.
have [size_r size_r'] : size r = k /\ size r' = k.
  rewrite /r' /r. rewrite !size_addv size_shiftV size_useHintV size_addv.
  rewrite size_Az size_oppv size_scalarv size_base2shiftV.
  rewrite size_base2highbitsV /#.
have size_u : size (u2 - u1) = k.
  rewrite size_addv size_scalarv size_oppv size_addv size_oppv size_base2lowbitsV /#.
split => [|? rr c_dC normv_z Hr]; last split.
- (* StMSIS Oracle is called on the same arguments *)
  rewrite mulmxv_cat; 1: smt(size_addv size_oppv gt0_k).
  rewrite mulmxv_cat 1:/#.
  rewrite colmxN mul_colmxc -size_u mulmx1v scalarvN.
  suff : u2 - r + (mA *^ z - to_c c ** t) = zerov k by smt(addvA addvC addv0 oppvD oppvK).
  suff : (mA *^ z - mA *^ z) + (to_c c ** base2shiftV t1 + to_c c ** t0 - to_c c** t) = zerov k.
     rewrite /u2 /r.
     move: (mA *^ z) (to_c c ** base2shiftV t1) (to_c c ** t0) (to_c c ** t) => a b e f.
     move=> <-; rewrite oppvD oppvK (addvC a (-a)) (addvC e (-a + b)) -!addvA; congr.
     by rewrite (addvC a (b + (e + -f))) -!addvA (addvC (-f) a).
  rewrite addvN lin_add0v.
  + rewrite ?size_Az ?size_addv ?size_oppv ?size_scalarv ?size_base2shiftV.
    rewrite size_base2highbitsV size_base2lowbitsV /#.
  by rewrite -scalarvDr b2high_lowPv addvN size_scalarv size_t.
- (* The StMSIS solution is "short" *)
  rewrite 2!inf_normv_cat !StdOrder.IntOrder.ler_maxrP !maxr_lerP.
  rewrite [inf_normv z <= _]StdOrder.IntOrder.ltrW 1:normv_z /= 1!inf_normv_vectc //.
  have ? : 0 <= tau * (2 ^ (d - 1)).
  + apply StdOrder.IntOrder.mulr_ge0; 2: by apply StdOrder.IntOrder.expr_ge0.
    smt(tau_bound).
  rewrite supp_dprod in c_dC.
  rewrite -Hr -/r -/r' -/u1 -/u2.
  suff: inf_normv (u2 - u1) <= 2 * gamma2 + 1 + tau * 2 ^ (d - 1); 1: by
     move => ?; split; smt(cnorm_to_c gamma2_bound supp_dprod).
  rewrite /u1 /u2 oppvD oppvK [_ + r']addvC addrC.
  have X := ler_inf_normv (to_c c ** t0) (r' - r).
  apply (StdOrder.IntOrder.ler_trans _ _ _ X) => {X}.
  apply (StdOrder.IntOrder.ler_add); last first.
  + by rewrite -inf_normvN oppvD addvC oppvK /r' hint_error /#.
  apply l1_inf_norm_product_ub;
    1, 2: smt(tau_bound StdOrder.IntOrder.expr_gt0 gt0_d).
  + by rewrite Hr l1_norm_to_c //; case: c_dC.
  exact b2low_bound.
- rewrite catvA get_catv_r ?size_catv 1:/# -Hr.
  have -> : k + (l + 1) - 1 - (size (u2-u1) + size z) = 0 by smt().
  by rewrite get_vectc.
qed.

lemma KOA_bound &m :
     Pr [EF_KOA_RO(DilithiumS, A, H).main() @ &m : res ]
  <= `| Pr[ GameL(RedMLWE(A, H)).main() @ &m : res ] - Pr [ GameR(RedMLWE(A, H)).main() @ &m : res ] |
   + Pr [ Game(RedMSIS(A), G).main() @ &m : res].
proof.
apply (ler_trans _ _ _ (hop1 &m)); rewrite RField.addrC ler_add2l.
by rewrite hop2 hop3.
qed.

end section PROOF.

(* The fibre-sampling program: a pre-image of the ring challenge [r],
   sampled by the program [CF.FiberSampler], and the leakage of the rejected
   bytes, sampled independently. *)
module FiberSamplerRej : RqStMSIS.FiberSampler_t = {
  proc sample(r : Rq) : challenge_t = {
    var ir, lr;
    ir <@ CF.FiberSampler.sample(r);
    lr <$ SIB.dLeakRej;
    return (ir, lr);
  }
}.

(* The fibre-sampling program [FiberSamplerRej] samples the distribution
   [RqStMSIS.dfiber r = CF.dfiber r `*` SIB.dLeakRej]. *)
equiv FiberSamplerRej_DFiber :
  FiberSamplerRej.sample ~ RqStMSIS.DFiber.sample : ={r} ==> ={res}.
proof.
proc.
transitivity{1} { ir <@ CF.FiberSamplerD.sample(r); lr <$ SIB.dLeakRej; }
  (={r} ==> ={ir, lr}) (={r} ==> (ir, lr){1} = c{2}); 1, 2: smt().
- by rnd; call CF.FiberSampler_dfiber; auto.
inline *; sp; rndsem*{1} 0; rnd: *0 *0; auto => /> &2.
have <- : CF.dfiber r{2} `*` SIB.dLeakRej =
          dlet (CF.dfiber r{2}) (fun x => dmap SIB.dLeakRej (fun lr => (x, lr))).
- by rewrite -(dmap_id (_ `*` _)) dmap_dprodE.
have -> : (fun (p : CF.challenge_ir * leakage) => (p.`1, p.`2)) = (fun x => x).
- by apply fun_ext => -[].
by split => // _ [] ? ?.
qed.

(* Bridge to the standard SelfTargetMSIS assumption, where the random oracle
   returns ring challenges sampled in [RqStMSIS.dCR = dC tau] ([dC_to_c]).
   The reduction runs the program [FiberSamplerRej] to sample challenges. *)
lemma StMSIS_bridge (B <: RqStMSIS.Adversary{-G, -RqStMSIS.Std.PRO.RO, -RqStMSIS.ORed}) &m :
  Pr[Game(B, G).main() @ &m : res] <=
  Pr[RqStMSIS.Std.Game(RqStMSIS.RedStd(FiberSamplerRej, B), RqStMSIS.Std.PRO.RO).main() @ &m : res].
proof. exact (RqStMSIS.StMSIS_Std_le FiberSamplerRej B FiberSamplerRej_DFiber &m). qed.

(* -- Operator-based -- *)

op dA = dmatrix dRq k l.
op ds1 = dvector (dRq_ Params.eta_) l.
op ds2 = dvector (dRq_ Params.eta_) k.

op keygen : (PK * SK) distr =
  dlet (dmatrix dRq k l) (fun mA =>
  dlet ds1 (fun s1 =>
  dmap ds2 (fun s2 =>
  let pk = (mA, mA *^ s1 + s2) in
  let sk = (mA, s1, s2) in
  (pk, sk)))).

op dy = dvector dmask l.

op commit_fun (sk : SK) = dmap dy (fun y =>
  let (mA, s1, s2) = sk in
  let w1 = highBitsV (mA *^ y) in (w1, y)).

(* commitment leakage does not depend on the secret key *)
op commit_leak = dunit Empty.

(* the result of the commitment is independent from the associated leakage *)
op commit (sk : SK) : ((commit_t * pstate_t) * leakage) distr =
  commit_fun sk `*` commit_leak.

(* The part of the respond function that follows the computation of
   [z = y + c s1] and of the outcome [z_fail] of the test on [z]: the tests
   on [c t0], on [r0 = LowBits(w0)] and on the hint, where
   [w0 = w - c s2 = A z - c t], and the leakage of the whole response.  The
   response is accepted iff the four tests pass.  When the test on [z]
   fails, neither [z] nor [w0] matter (see [resp_after_z_zfail]): this is
   what allows the simulator to only sample [z] when it passes the test.
   It is shared by [respond] and by the simulator [HVZK_Sim_Inst]. *)
op resp_after_z (c : challenge_t) (t0 : vector) (z_fail : int option) (z w0 : vector) =
  let r0_fail = check_r0 w0 in
  let h = makeHintV (- to_c c ** t0) (w0 + to_c c ** t0) in
  let hint_fail = check_hint h in
  (if check_ct0 (to_c c ** t0) /\ z_fail = None /\ r0_fail = None /\ hint_fail = None
   then Some (z, h) else None,
   resp_leak c z_fail r0_fail hint_fail).

lemma resp_after_z_zfail c t0 z_fail z1 w1 z2 w2 :
  z_fail <> None =>
  resp_after_z c t0 z_fail z1 w1 = resp_after_z c t0 z_fail z2 w2.
proof. by move=> hz; rewrite /resp_after_z /resp_leak /= hz. qed.

op respond (sk : SK) (c : challenge_t) (y: pstate_t) : response_t option * leakage =
  let (mA, s1, s2) = sk in
  let t0 = base2lowbitsV (mA *^ s1 + s2) in
  let z = y + to_c c ** s1 in
  resp_after_z c t0 (check_z z) z (mA *^ y - to_c c ** s2).

op verify (pk : PK) (w1 : commit_t) (c : challenge_t) (resp : response_t) : bool =
  let (mA, t) = pk in
  let t1 = base2highbitsV t in
  let (z, h) = resp in
  size z = l /\
  size h = k /\
  inf_normv z < gamma1 - beta_ /\
  w1 = useHintV h (mA *^ z - to_c c ** base2shiftV t1).

lemma keygen_ll : is_lossless keygen.
proof.
apply dlet_ll => [|/= mA ?]; 1: by apply dmatrix_ll; apply dRq_ll.
apply dlet_ll => [|/= s1 ?]; 1: by apply dvector_ll; apply dRq__ll.
by apply dmap_ll; apply dvector_ll; apply dRq__ll.
qed.

lemma commit_leak_ll : is_lossless commit_leak.
proof. exact dunit_ll. qed.

lemma commit_fun_ll sk : is_lossless (commit_fun sk).
proof. by apply/dmap_ll/dvector_ll/dmask_ll. qed.

lemma commit_ll sk : is_lossless (commit sk).
proof. by apply/dprod_ll_auto/commit_leak_ll/commit_fun_ll. qed.

clone import OpBased with
  op keygen <= keygen,
  op commit <= commit,
  op respond <= respond,
  op verify <= verify
proof* by smt(keygen_ll commit_ll).

(* Support of the key generation *)
lemma supp_keygen pk sk :
  (pk, sk) \in keygen <=>
  exists mA s1 s2, mA \in dmatrix dRq k l /\ s1 \in ds1 /\ s2 \in ds2 /\
    pk = (mA, mA *^ s1 + s2) /\ sk = (mA, s1, s2).
proof.
rewrite /keygen; split.
- case/supp_dlet => mA /= [s_mA /supp_dlet [s1 /= [s_s1 /supp_dmap [s2 /= [s_s2 [] -> ->]]]]].
  by exists mA s1 s2.
case=> mA s1 s2 [#] s_mA s_s1 s_s2 -> ->.
apply/supp_dlet; exists mA; split => //=; apply/supp_dlet; exists s1; split => //=.
by apply/supp_dmap; exists s2.
qed.

lemma sk_size mA s1 s2 :
  (exists pk, (pk, (mA, s1, s2)) \in keygen) => size mA = (k, l) /\ size s1 = l /\ size s2 = k.
proof.
case=> pk /supp_keygen [mA' s1' s2' [#] s_mA s_s1 s_s2 _ <<- <<- <<-].
have := size_dmatrix dRq k l mA _ _ _; 1..3:smt(gt0_k Params.gt0_l).
have := size_dvector (dRq_ eta_) l s1 _; 1:smt().
have := size_dvector (dRq_ eta_) k s2 _; 1:smt().
smt(gt0_k Params.gt0_l).
qed.

lemma size_t pk sk : (pk, sk) \in keygen => size pk.`2 = k.
proof.
move=> /supp_keygen [mA s1 s2 [#] s_mA _ s_s2 -> _].
rewrite [Vectors.size]lock /= -lock size_addv size_mulmxv.
have := size_dmatrix dRq k l mA s_mA _ _; 1, 2:smt(gt0_k Params.gt0_l).
have := size_dvector (dRq_ eta_) k s2 s_s2; smt(gt0_k).
qed.

module OpBasedSig = FSaCR.IDS_Sig(OpBased.P, OpBased.V).

section OpBasedCorrectness.

declare module H <: Hash {-OpBased.P}.

equiv keygen_opbased_correct :
  OpBasedSig(H).keygen ~ DilithiumS(H).keygen :
  true ==> ={res}.
proof.
proc; inline *.
rnd: *0 *0; skip => />; split => [kp ?|_ [pk sk]].
- by rewrite dmap_id /keygen &(mu_eq).
by rewrite /keygen dmap_id.
qed.

equiv sign_opbased_correct :
  OpBasedSig(H).sign ~ DilithiumS(H).sign :
  ={arg, glob H} ==> ={res, glob H}.
proof.
proc; inline *; sp.
while (oz{1} = response{2} /\ i{1} = ctr{2} /\ ={c, leak, sk, glob H, m} /\
       t0{2} = base2lowbitsV (mA{2} *^ s1{2} + s2{2}) /\
       (sk = (mA, s1, s2)){2});
  last by  auto => />.
conseq (: _ ==> ={c, leak, sk, glob H, m} /\ (sk = (mA, s1, s2)){2}
                 /\ oz{1} = response{2} /\ i{1} = ctr{2}); 1: smt().
seq 5 4 : (#pre /\ (w, lw, P.pstate, lc){1} = (w1, Empty, y, lc){2} /\ (w = mA *^ y){2}).
- call(: true); conseq />; sp; wp.
  rnd (fun (wly : ((DID.W * vector) * leakage)) => wly.`1.`2)
      (fun y => ((highBitsV (mA{2} *^ y), y), Empty)).
  skip => /> &h _.
  split => [? ? | ? [? ?] /supp_dprod [ /supp_dmap ? /supp_dunit ? ] /#].
  rewrite /commit /= /dy /= dprod1E dunit1xx -Real.RField.ofintR Real.RField.mul1r1z.
  rewrite [mu1 _ (_, _)]dmap1E &(mu_eq) => y'.
  by rewrite /pred1 /(\o) /=; smt().
conseq />; auto => /> &2 _; split => [|pass_chk].
+ rewrite /respond /resp_after_z /=.
  move: (check_ct0 _) (check_z _) (check_r0 _) (check_hint _) => cf zf rf hf.
  move=> -> /=; split => [-> /= | hr]; 1: by case: cf => //=; case: hf.
  by rewrite /resp_leak /= hr.
by rewrite /respond /resp_after_z /resp_leak /= pass_chk.
qed.

equiv verify_opbased_correct :
  OpBasedSig(H).verify ~ DilithiumS(H).verify :
  ={arg, glob H} ==> ={res, glob H}.
proof.
proc; inline *.
wp; call (: true).
auto => /> &m; move: (pk{m}) (sig{m}) => [A t] [c [z h]] //.
qed.

end section OpBasedCorrectness.

(* -- OpBased is commitment recoverable -- *)
(* Necessary for the simulator definition below to make sense *)

lemma pk_decomp mA' t' mA s1 s2 :
  ((mA', t'), (mA, s1, s2)) \in keygen =>
  mA' = mA /\ t' = mA *^ s1 + s2.
proof. by case/supp_keygen => ? ? ? [#] _ _ _ -> -> -> -> ->. qed.

lemma keygen_supp_decomp pk mA s1 s2 :
  (pk, (mA, s1, s2)) \in keygen =>
    s1 \in ds1 /\ s2 \in ds2.
proof. by case/supp_keygen => ? ? ? [#] _ ? ? _ _ -> ->. qed.

hoare recover_correct (pk_i : PK) (sk_i : SK) :
  DID.Honest_Execution(OpBased.P, OpBased.V).get_trans :
  ((pk_i, sk_i) \in keygen /\ arg = (pk_i, sk_i)) ==>
  (!DID.is_fail res => let (w, c, z) = DID.tr_wcz res in w = recover pk_i c z).
proof.
case pk_i sk_i => [mA' t'] [mA s1 s2].
proc; inline *; auto => /> valid_keys.
have sk_sizes: size mA = (k, l) /\ size s1 = l /\ size s2 = k.
- by apply sk_size; exists (mA', t').
have rg_s2: s2 \in ds2 by have := keygen_supp_decomp (mA', t')  mA  s1  s2 valid_keys =>/#.
case /pk_decomp valid_keys => [??]; subst.
move => [[w0 y0] ?] @/commit /= /supp_dprod [ /supp_dmap [y [y_supp [??]]] ?] c c_supp H w c' z; subst.
have {H} H /=: ((respond (mA, s1, s2) c y).`1 <> None) by smt().
rewrite H /respond /DID.tr_wcz /= => [#] *; subst c' w z.
move: H; rewrite /respond /resp_after_z /=.
case: (check_z (y + to_c c ** s1) = None) => hz //=.
case: (check_r0 (mA *^ y - to_c c ** s2) = None) => hr //=.
case: (check_ct0 (to_c c ** base2lowbitsV (mA *^ s1 + s2))) => hct //=.
have size_y : size y = l by have := size_dvector _ _ _ y_supp; smt(Params.gt0_l).
have [C1 C2] : inf_normv (y + to_c c ** s1) < gamma1 - beta_ /\
               inf_normv (lowBitsV (mA *^ y - to_c c ** s2)) < gamma2 - beta_.
- split; [rewrite -check_z_None // | rewrite -check_r0_None //].
  + by rewrite size_addv size_scalarv size_y /#.
  rewrite size_addv size_oppv size_scalarv size_mulmxv.
  by move: sk_sizes => /> /#.
rewrite /recover /=; case: (check_hint _ = None) => //=.
(* recover some definitions *)
pose t := mA *^ s1 + s2.
pose t1 := base2highbitsV t.
pose t0 := base2lowbitsV t.
pose w := mA *^ y.
pose z := y + to_c c ** s1.
rewrite mulmxvDr mulmx_scalarv -/w.
have W : w - to_c c ** s2 = mA *^ z - to_c c ** t0 - to_c c ** base2shiftV t1.
- by move: sk_sizes => [? [_ ?]]; apply commit_identity_split.
have W' : w - to_c c ** s2 + to_c c ** t0 =  mA *^ z - to_c c ** base2shiftV t1.
  rewrite W -!addvA; congr; rewrite [_ + to_c c**t0]addvC addvA [_ + to_c c**t0]addvC addvN.
  rewrite lin_add0v // size_oppv.
  by rewrite !size_scalarv size_base2lowbitsV size_base2shiftV size_base2highbitsV.
rewrite W'.
have -> : w + to_c c ** (mA *^ s1) = mA *^ z by rewrite /w /z mulmxvDr mulmx_scalarv.
rewrite usehint_correctV.
- rewrite size_addv !size_oppv !size_scalarv size_base2shiftV size_mulmxv.
  have ->: size t0 = size t by smt(size_base2lowbitsV).
  have ->: size t1 = size t by smt(size_base2highbitsV).
  suff: size t = rows mA by smt().
  rewrite size_addv size_mulmxv; move : sk_sizes => /> /#.
- have ->: 2 * gamma2 %/ 2 = gamma2 by smt().
  rewrite inf_normvN.
  move: hct; rewrite check_ct0_None 2:/#.
  rewrite size_scalarv size_base2lowbitsV size_addv size_mulmxv.
  by move: sk_sizes => /> /#.
rewrite -addvA [(_ - _)%Vectors]addvC addvA -W.
have {1}-> : w = w - to_c c**s2 + to_c c**s2.
  rewrite -addvA [_+ to_c c**s2]addvC addvN size_scalarv.
  rewrite addvC lin_add0v //; have := sk_sizes => />; smt(size_mulmxv size_dvector).

apply (hide_lowV _ _ beta_);
  2, 3, 5: smt(size_oppv size_scalarv size_mulmxv size_dvector size_addv
               gt0_beta beta_gamma2_lt).
+ have := sk_sizes => />; smt(size_oppv size_scalarv size_mulmxv size_dvector size_addv
               gt0_beta beta_gamma2_lt).
apply (norm_cs_le_beta c s2 c_supp).
apply inf_normv_ler =>[|i rg_i]; first by smt(gt0_eta).
rewrite supp_dvector in rg_s2; first by smt(gt0_k).
by rewrite -supp_dRq; smt(gt0_eta).
qed.

(* -- OpBased is indeed zero-knowledge -- *)

(* Ditstribution of "good" (i.e., small inf norm) vectors *)
op dsimz = dvector (dRq_open (gamma1 - beta_)) l.

(* fraction of "good" z compared to the domain of y *)
op line12_magic_number = (size (to_seq (support dsimz)))%r / (size (to_seq (support dy)))%r.

(* Distribution of the outcome [z_fail] of the test on [z = y + c s1], for
   [y] sampled in [dy].  It does not depend on [c s1] ([check_z_shift],
   [line12_magic] below), and [z_fail = None] with probability
   [line12_magic_number] ([dz_fail_None]). *)
op dz_fail : int option distr = dmap dy check_z.

(* Directly sample the outcome of the test on z, together with z when the
   test passes (it is then uniform in [dsimz]) *)
op dsimoz : (int option * vector option) distr =
  dlet dz_fail (fun f =>
    if f = None then dmap dsimz (fun z => (None, Some z)) else dunit (f, None)).

op to_transcript pk c oz leak =
  oapp (fun z => DID.TrS (recover pk c z, c, z) leak) (DID.TrF leak) oz.

(* The simulator samples the outcome of the test on [z] (it does not depend
   on the secret key), then [z] itself only when the test passes. The other
   tests only depend on the public key, on [c] and on [z]: they are computed
   with [w - c s2 = A z - c t] (and [t0] is a function of [t]). *)
module HVZK_Sim_Inst : DID.HVZK_Sim = {
  proc get_trans(pk : PK)  = {
    var mA, z, t, t0, c, oz, z_fail;
    var lw, lz;

    c <- witness;
    z <- witness;
    (mA, t) <- pk;
    t0 <- base2lowbitsV t;

    lw <$ commit_leak;
    z_fail <$ dz_fail;
    c <$ FSa.dC;
    if (z_fail = None) {
      z <$ dsimz;
    }
    (oz, lz) <- resp_after_z c t0 z_fail z (mA *^ z - to_c c ** t);

    return to_transcript pk c oz (lw, lz);
  }
}.

section OpBasedHVZK.

local lemma dsimz_uni :is_uniform dsimz.
proof. smt(dRq_open_uni dvector_uni). qed.

local lemma dsimz_ll : is_lossless dsimz.
proof. smt(dRq_open_ll dvector_ll). qed.

local lemma dsimz1E z : z \in dsimz =>
  mu1 dsimz z = inv (size (to_seq (support dsimz)))%r.
proof. by rewrite mu1_uni_ll ?dsimz_uni ?dsimz_ll /#. qed.

lemma supp_ds1 s1 : s1 \in ds1 <=> size s1 = l /\ inf_normv s1 <= Params.eta_.
proof. rewrite supp_dRq_vect; smt(Params.gt0_l gt0_k gt0_eta). qed.

lemma supp_dsimz z : z \in dsimz <=> size z = l /\ inf_normv z < gamma1 - beta_.
proof. rewrite supp_dRq_vect; smt(Params.gt0_l beta_gamma1_lt). qed.

lemma supp_dy y : y \in dy <=> size y = l /\ forall i, 0 <= i < l => y.[i] \in dmask.
proof. by rewrite supp_dvector // ltzW Params.gt0_l. qed.

lemma dy_of_norm y : size y = l => inf_normv y <= gamma1 - 1 => y \in dy.
proof.
move=> size_y norm_y; rewrite supp_dy size_y /= => i rg_i.
apply dmask_supp; move: norm_y; rewrite inf_normv_ler; 1: smt(beta_gamma1_lt gt0_beta).
by move=> /(_ i); rewrite size_y; apply.
qed.

local lemma masking_range c s1 z:
  c \in FSa.dC => s1 \in ds1 => z \in dsimz =>
  (z - to_c c ** s1) \in dy.
proof.
move=> c_in; rewrite supp_ds1 supp_dsimz => |> size_s1 norm_s1 size_z norm_z.
apply dy_of_norm; 1: by rewrite size_addv size_oppv size_scalarv size_z size_s1 maxrr.
apply (StdOrder.IntOrder.ler_trans _ _ _ (ler_inf_normv _ _)).
by rewrite inf_normvN; have := norm_cs_le_beta c s1 c_in norm_s1; smt().
qed.

local lemma is_finite_dy : is_finite (support dy).
proof.
have := is_finite_vector (support dmask) l dmask_fin.
by apply finite_leq => v; rewrite supp_dy.
qed.

local lemma is_finite_dsimz : is_finite (support dsimz).
proof. apply finite_dRq_vect; smt(Params.gt0_l beta_gamma1_lt gt0_beta). qed.

lemma mask_size :
  size (to_seq (support dsimz)) <= size (to_seq (support dy)).
proof.
apply sub_size_to_seq => [v|]; last exact is_finite_dy.
rewrite supp_dsimz => -[size_v norm_v]; apply dy_of_norm => //.
smt(gt0_beta).
qed.

lemma mask_nonzero :
  0 < size (to_seq (support dsimz)).
proof.
suff: zerov l \in (to_seq (support dsimz)) by smt(size_eq0 List.size_ge0).
by rewrite mem_to_seq ?is_finite_dsimz dRq_zerov;
  smt(Params.gt0_l gt0_beta beta_gamma1_lt).
qed.

lemma clamp_magic : clamp line12_magic_number = line12_magic_number.
proof.
 have := clamp_id line12_magic_number.
 rewrite /line12_magic_number.
 have  := mask_size.
 have  := mask_nonzero.
 pose a := (size (to_seq (support dsimz))).
 pose b := (size (to_seq (support dy))).
 move => ?? -> //.
 split; 1: by apply StdOrder.RealOrder.divr_ge0 => /#.
 by rewrite StdOrder.RealOrder.ler_pdivr_mulr => /#.
qed.

local lemma dy_ll :
  is_lossless dy.
proof. exact/dvector_ll/dmask_ll. qed.

local lemma dy_uni :
  is_uniform dy.
proof. exact/dvector_uni/dmask_uni. qed.

lemma dz_fail_None : mu1 dz_fail None = line12_magic_number.
proof.
rewrite /dz_fail dmap1E /(\o) /pred1 /=.
rewrite (mu_eq_support _ _ (support dsimz)).
- move=> y /size_dvector; rewrite lez_maxr; 1: smt(Params.gt0_l).
  by move=> size_y; rewrite /= check_z_None // supp_dsimz size_y.
rewrite muE (eq_sum _ (fun y => if y \in dsimz then inv (size (to_seq (support dy)))%r else 0%r)).
- move=> y /=; case: (y \in dsimz) => // y_in.
  rewrite mu1_uni_ll ?dy_uni ?dy_ll ifT //.
  by move: y_in; rewrite supp_dsimz => -[size_y norm_y]; apply dy_of_norm; smt(gt0_beta).
by rewrite fin_sum_const ?is_finite_dsimz.
qed.

local op transz (c : challenge_t) s1 =
  dmap dy (fun y =>
    let z = y + to_c c ** s1 in
    (check_z z, if check_z z = None then Some z else None)).

local lemma dsimozE :
  dsimoz = dmap (dz_fail `*` dsimz)
                (fun (fz : int option * vector) =>
                   (fz.`1, if fz.`1 = None then Some fz.`2 else None)).
proof.
rewrite /dsimoz dmap_dprodE; apply in_eq_dlet => f _ /=.
case: (f = None) => [-> // | hf]; rewrite eq_sym.
by apply/dmap_cst/dsimz_ll.
qed.

local lemma dmap_pair_id (d : (int option * vector option) distr) :
  dmap d (fun (p : int option * vector option) => (p.`1, p.`2)) = d.
proof. by rewrite -{2}(dmap_id d); congr; apply fun_ext => -[]. qed.

local lemma line12_magic c s1 :
  c \in FSa.dC => s1 \in ds1 =>
  transz c s1 = dsimoz.
proof.
move => c_valid s1_valid.
pose v := to_c c ** s1.
have [size_s1 norm_s1] : size s1 = l /\ inf_normv s1 <= eta_ by rewrite -supp_ds1.
have size_v : size v = l by rewrite /v size_scalarv.
have norm_v : inf_normv v <= beta_ by exact (norm_cs_le_beta c s1 c_valid norm_s1).
apply eq_distr => -[f oz]; rewrite dsimozE /transz -/v !dmap1E /(\o) /pred1 /=.
move: f oz => -[|i] [|z] /=.
- (* the test passes but there is no z: impossible *)
  rewrite (mu_eq _ _ pred0); 1: by move=> x; rewrite /pred0; case: (check_z (x + v)).
  rewrite mu0 eq_sym (mu_eq _ _ pred0) ?mu0 //.
  by case=> -[|f] z0.
- (* the test passes: z is uniform in [dsimz] *)
  rewrite eq_sym (mu_eq _ _ (fun (fz : int option * vector) => pred1 None fz.`1 /\ pred1 z fz.`2)).
  + by case=> f z0 /=; case: (f = None).
  rewrite (dprodE (pred1 None) (pred1 z) dz_fail dsimz) dz_fail_None eq_sym.
  case: (z \in dsimz) => z_valid; last first.
  + have -> : mu1 dsimz z = 0%r by rewrite -supportPn.
    rewrite (mu_eq_support _ _ pred0) ?mu0 //.
    move=> y /size_dvector; rewrite lez_maxr; 1: smt(Params.gt0_l).
    move=> size_y; rewrite /pred0 /=; apply/negbTE/negP => -[hz].
    rewrite hz /=; apply/negP => hyz; apply z_valid; rewrite -hyz.
    by rewrite supp_dsimz -check_z_None // size_addv size_y size_v.
  have [size_z norm_z] : size z = l /\ inf_normv z < gamma1 - beta_ by rewrite -supp_dsimz.
  rewrite (mu_eq_support _ _ (pred1 (z - v))).
  + move=> y /size_dvector; rewrite lez_maxr; 1: smt(Params.gt0_l).
    move=> size_y; rewrite /pred1 eq_iff /=; split.
    * move=> [hz]; rewrite hz /= => <-.
      by rewrite -addvA addvN size_v -size_y addv0.
    move=> ->; rewrite -addvA (addvC (-v)) addvN size_v (lin_addv0 z l) 1:size_z //=.
    have hz : check_z z = None by rewrite check_z_None.
    by rewrite hz.
  rewrite mu1_uni_ll ?dy_uni ?dy_ll ifT; 1: exact masking_range.
  rewrite dsimz1E // /line12_magic_number.
  have ? := mask_nonzero; have ? := mask_size.
  by field; smt().
- (* the test fails on the polynomial i: no z *)
  rewrite eq_sym (mu_eq _ _ (fun (fz : int option * vector) => pred1 (Some i) fz.`1)).
  + by case=> -[|f] z0.
  rewrite (dprodEl dz_fail dsimz (pred1 (Some i))) dsimz_ll /= /dz_fail.
  rewrite -(check_z_shift v) // dmap1E /(\o) /pred1 /=.
  by apply mu_eq => y /=; case: (check_z (y + v)).
(* the test fails and there is a z: impossible *)
rewrite (mu_eq _ _ pred0); 1: by move=> x; rewrite /pred0; case: (check_z (x + v)).
rewrite mu0 eq_sym (mu_eq _ _ pred0) ?mu0 //.
by case=> -[|f] z0.
qed.

local module HVZK_Hops = {
  (* Drop commitment *)
  proc game1(pk: PK, sk: SK) = {
    var w, st, c, or;
    var lw, lr;

    (w, st) <$ commit_fun sk;
    lw <$ commit_leak;
    c <$ FSa.dC;
    (or, lr) <- respond sk c st;
    return to_transcript pk c or (lw, lr);
  }

  (* unfold everything *)
  proc game2(pk: PK, sk: SK) = {
    var mA, s1, s2, y, c, z, t, t0, or;
    var lw, lr;

    (mA, s1, s2) <- sk;
    t <- mA *^ s1 + s2;
    t0 <- base2lowbitsV t;

    lw <$ commit_leak;
    c <$ FSa.dC;
    y <$ dy;

    z <- y + to_c c ** s1;
    (or, lr) <- resp_after_z c t0 (check_z z) z (mA *^ y - to_c c ** s2);

    return to_transcript pk c or (lw, lr);
  }

  (* Compute w - c s2 using only public information *)
  proc game3(pk: PK, sk: SK) = {
    var mA, s1, s2, y, c, or, z, t, t0;
    var lw, lr;

    (mA, s1, s2) <- sk;
    t <- mA *^ s1 + s2;
    t0 <- base2lowbitsV t;

    lw <$ commit_leak;
    c <$ FSa.dC;
    y <$ dy;

    z <- y + to_c c ** s1;
    (or, lr) <- resp_after_z c t0 (check_z z) z (mA *^ z - to_c c ** t);

    return to_transcript pk c or (lw, lr);
  }

  (* Only keep z when it passes the test *)
  proc game4(pk: PK, sk: SK) = {
    var mA, s1, s2, y, c, z, t, t0, oz, or, z_fail;
    var lw, lr;

    (mA, s1, s2) <- sk;
    t <- mA *^ s1 + s2;
    t0 <- base2lowbitsV t;

    lw <$ commit_leak;
    c <$ FSa.dC;
    y <$ dy;

    z <- y + to_c c ** s1;
    (z_fail, oz) <- (check_z z, if check_z z = None then Some z else None);
    z <- oget oz;
    (or, lr) <- resp_after_z c t0 z_fail z (mA *^ z - to_c c ** t);

    return to_transcript pk c or (lw, lr);
  }

  (* Rewrite relevant parts of above as operator *)
  proc game5(pk: PK, sk: SK) = {
    var mA, s1, s2, c, z, t, t0, or, oz, z_fail;
    var lw, lr;

    (mA, s1, s2) <- sk;
    t <- mA *^ s1 + s2;
    t0 <- base2lowbitsV t;

    lw <$ commit_leak;
    c <$ FSa.dC;
    (z_fail, oz) <$ transz c s1;

    z <- oget oz;
    (or, lr) <- resp_after_z c t0 z_fail z (mA *^ z - to_c c ** t);
    return to_transcript pk c or (lw, lr);
  }

  (* Get (a, t) from public key *)
  proc game6(pk: PK, sk: SK) = {
    var mA, mA', s1, s2, c, oz, z, t, t0, or, z_fail;
    var lw, lr;

    (mA', s1, s2) <- sk;
    (mA, t) <- pk;
    t0 <- base2lowbitsV t;

    lw <$ commit_leak;
    c <$ FSa.dC;
    (z_fail, oz) <$ transz c s1;

    z <- oget oz;
    (or, lr) <- resp_after_z c t0 z_fail z (mA *^ z - to_c c ** t);
    return to_transcript pk c or (lw, lr);
  }

  (* simulator: dropping secret key *)
  proc game7(pk: PK) = {
    var mA, c, z, t, t0, or, oz, z_fail;
    var lw, lr;

    (mA, t) <- pk;
    t0 <- base2lowbitsV t;

    lw <$ commit_leak;
    c <$ FSa.dC;
    (z_fail, oz) <$ dsimoz;

    z <- oget oz;
    (or, lr) <- resp_after_z c t0 z_fail z (mA *^ z - to_c c ** t);
    return to_transcript pk c or (lw, lr);
  }

  proc game8(pk: PK) = {
    var mA, c, z, t, t0, or, z_fail;
    var oz; (* only used for the proof *)
    var lw, lr;

    (mA, t) <- pk;
    t0 <- base2lowbitsV t;

    lw <$ commit_leak;
    c <$ FSa.dC;
    z_fail <$ dz_fail;
    z <$ dsimz;

    oz <- if z_fail = None then Some z else None;
    z <- oget oz;
    (or, lr) <- resp_after_z c t0 z_fail z (mA *^ z - to_c c ** t);
    return to_transcript pk c or (lw, lr);
  }

  proc game9(pk: PK) = {
    var mA, z, t, t0, c, or, z_fail;
    var lw, lr;

    c <- witness;
    z <- witness;
    (mA, t) <- pk;
    t0 <- base2lowbitsV t;

    lw <$ commit_leak;
    z_fail <$ dz_fail;
    c <$ FSa.dC;
    if (z_fail = None) {
      z <$ dsimz;
    }
    (or, lr) <- resp_after_z c t0 z_fail z (mA *^ z - to_c c ** t);

    return to_transcript pk c or (lw, lr);
  }
}.

local equiv hop2_correct pk_i sk_i :
  HVZK_Hops.game1 ~ HVZK_Hops.game2 :
  (pk_i, sk_i) \in keygen /\ arg{1} = (pk_i, sk_i) /\ arg{2} = (pk_i, sk_i) ==>
  ={res}.
proof.
case sk_i => mA' s1' s2'.
proc; inline*.
swap{1} 1 2.
swap{2} [4..5] -3.
seq 2 2: (#pre /\ ={c, lw}); first by auto.
sp.
(* Sample `y` and discard unused `w` *)
seq 1 1: (#pre /\ st{1} = y{2}).
- rnd (fun (wy : (DID.W * vector)) => wy.`2) (fun y => ((highBitsV (mA{2} *^ y), y))).
  auto => /> _.
  split.
  + move => y supp_y.
    rewrite /commit /= (dmap1E dy) /(\o).
    by apply mu_eq => ? /#.
  move => _ [w st] @/commit /= /supp_dmap [y [supp_y [??]]]; subst.
  smt().
by auto => />.
qed.

local equiv hop3_correct :
  HVZK_Hops.game2 ~ HVZK_Hops.game3 :
  ={arg} /\ arg{1} \in keygen ==> ={res}.
proof.
proc.
seq 7 7 : (#pre /\ ={mA, s1, s2, t, c, lw, y, z, t0} /\
          mA{1} *^ y{1} - to_c c{1} ** s2{1} = mA{2} *^ z{2} - to_c c{2} ** t{2});
  last by auto => /> &2 _ ->.
auto => /> &2 valid_key c c_valid y y_valid.
have: size (sk{2}.`1) = (k, l) /\ size (sk{2}.`2) = l /\ size (sk{2}.`3) = k.
- apply (sk_size (sk{2}.`1) (sk{2}.`2) (sk{2}.`3)).
  by exists pk{2} => /#.
by case (sk{2}) => mA s1 s2 /= [? [_ ?]] *; rewrite (commit_identity _ _ s1).
qed.

local equiv hop4_correct :
  HVZK_Hops.game3 ~ HVZK_Hops.game4 :
  ={arg} ==> ={res}.
proof.
proc.
seq 7 7 : (={pk, sk, mA, s1, s2, t, t0, lw, c, y, z}); 1: by auto.
auto => /> &2; case: (check_z z{2} = None) => [-> // | hz].
by rewrite (resp_after_z_zfail c{2} t0{2} _ (oget None) (mA{2} *^ oget None - to_c c{2} ** t{2})
              z{2} (mA{2} *^ z{2} - to_c c{2} ** t{2})).
qed.

local equiv hop5_correct pk_i sk_i :
  HVZK_Hops.game4 ~ HVZK_Hops.game5 :
  ={arg} /\ arg{1} = (pk_i, sk_i) /\ (pk_i, sk_i) \in keygen ==> ={res}.
proof.
proc.
seq 5 5: (#pre /\ ={mA, s1, s2, t, t0, lw, c} /\ (mA{1}, s1{1}, s2{1}) = sk_i).
- by auto => /#.
seq 3 1: (#pre /\ ={z_fail, oz}); last by sim.
rnd: *0 *0.
by auto => /> &2; rewrite !dmap_pair_id /transz.
qed.

local equiv hop6_correct pk_i sk_i :
  HVZK_Hops.game5 ~ HVZK_Hops.game6 :
  ={arg} /\ arg{1} = (pk_i, sk_i) /\ (pk_i, sk_i) \in keygen ==> ={res}.
proof.
proc.
seq 2 2: (#pre /\ ={mA, s1, s2, t} /\ mA{2} = mA'{2}); last by sim.
by auto => />; smt(pk_decomp).
qed.

local equiv hop7_correct pk_i sk_i :
  HVZK_Hops.game6 ~ HVZK_Hops.game7 :
  arg{1} = (pk_i, sk_i) /\ arg{2} = pk_i /\ (pk_i, sk_i) \in keygen ==> ={res}.
proof.
proc.
seq 2 1 : (#pre /\ ={mA, t} /\ mA{1} = mA'{1} /\ sk{1} = (mA'{1}, s1{1}, s2{1}) /\ pk{1} = (mA{1}, t{1})).
- by auto; smt(pk_decomp).
sp.
seq 2 2 : (#pre /\ ={lw, c} /\ c{1} \in FSa.dC); first by auto.
seq 1 1 : (#pre /\ ={z_fail, oz}); last by sim.
rnd; auto => //= &1 &2.
move => [#] ????? valid_keys ????????; subst.
rewrite line12_magic //.
by case /keygen_supp_decomp valid_keys.
qed.

local equiv hop8_correct pk_i sk_i :
  HVZK_Hops.game7 ~ HVZK_Hops.game8 :
  arg{1} = pk_i /\ arg{2} = pk_i /\ (pk_i, sk_i) \in keygen ==> ={res}.
proof.
proc.
swap{1} 5 -4; swap{2} [5..7] -4.
seq 1 3 : (={pk, z_fail, oz}); 2: by sim.
conseq />.
rnd : *0 *0; skip.
have -> : dlet dz_fail (fun f => dmap dsimz (fun z => (f, if f = None then Some z else None))) =
          dsimoz by rewrite dsimozE dmap_dprodE.
by move=> _ _ _; rewrite dmap_pair_id !andaE.
qed.

local equiv hop9_correct pk_i sk_i :
  HVZK_Hops.game8 ~ HVZK_Hops.game9 :
  arg{1} = pk_i /\ arg{2} = pk_i /\ (pk_i, sk_i) \in keygen ==> ={res}.
proof.
proc.
swap{1} 5 -1.
seq 5 7 : (={mA, t, t0, pk, lw, c, z_fail} /\ z{2} = witness); 1: by auto.
if{2}.
- by wp; rnd; auto => />.
by wp; rnd{1}; auto => /> &2 _; exact dsimz_ll.
qed.

local equiv KLS_HVZK pk sk :
  HVZK_Hops.game1 ~ HVZK_Hops.game9 :
  (pk, sk) \in keygen /\ arg{1} = (pk, sk) /\ arg{2} = pk ==>
  ={res}.
proof.
transitivity HVZK_Hops.game2
  ((pk, sk) \in Self.keygen /\ arg{1} = (pk, sk) /\ arg{2} = (pk, sk) ==> ={res})
  ((pk, sk) \in Self.keygen /\ arg{1} = (pk, sk) /\ arg{2} = pk ==> ={res}); 1, 2: smt().
- by conseq (hop2_correct pk sk).
transitivity HVZK_Hops.game3
  ((pk, sk) \in Self.keygen /\ arg{1} = (pk, sk) /\ arg{2} = (pk, sk) ==> ={res})
  ((pk, sk) \in Self.keygen /\ arg{1} = (pk, sk) /\ arg{2} = pk ==> ={res}); 1, 2: smt().
- by conseq hop3_correct.
transitivity HVZK_Hops.game4
  ((pk, sk) \in Self.keygen /\ arg{1} = (pk, sk) /\ arg{2} = (pk, sk) ==> ={res})
  ((pk, sk) \in Self.keygen /\ arg{1} = (pk, sk) /\ arg{2} = pk ==> ={res}); 1, 2: smt().
- by conseq hop4_correct.
transitivity HVZK_Hops.game5
  ((pk, sk) \in Self.keygen /\ arg{1} = (pk, sk) /\ arg{2} = (pk, sk) ==> ={res})
  ((pk, sk) \in Self.keygen /\ arg{1} = (pk, sk) /\ arg{2} = pk ==> ={res}); 1, 2: smt().
- by conseq (hop5_correct pk sk).
transitivity HVZK_Hops.game6
  ((pk, sk) \in Self.keygen /\ arg{1} = (pk, sk) /\ arg{2} = (pk, sk) ==> ={res})
  ((pk, sk) \in Self.keygen /\ arg{1} = (pk, sk) /\ arg{2} = pk ==> ={res}); 1, 2: smt().
- by conseq (hop6_correct pk sk).
transitivity HVZK_Hops.game7
  ((pk, sk) \in Self.keygen /\ arg{1} = (pk, sk) /\ arg{2} = pk ==> ={res})
  ((pk, sk) \in Self.keygen /\ arg{1} = pk /\ arg{2} = pk ==> ={res}); 1, 2: smt().
- by conseq (hop7_correct pk sk).
transitivity HVZK_Hops.game8
  ((pk, sk) \in Self.keygen /\ arg{1} = pk /\ arg{2} = pk ==> ={res})
  ((pk, sk) \in Self.keygen /\ arg{1} = pk /\ arg{2} = pk ==> ={res}); 1, 2: smt().
- by conseq (hop8_correct pk sk).
by conseq (hop9_correct pk sk).
qed.

local op partial_from_transcript (tr : DID.otranscript) =
  match tr with
  | DID.TrF l => (l, None)
  | DID.TrS wcz l => (l, Some (wcz.`2, wcz.`3))
  end.

(* Used in the following two proofs *)
local equiv HE_game1 : DID.Honest_Execution(P, V).get_trans ~ HVZK_Hops.game1 :
  ={arg} /\ arg{1} \in keygen ==>
  partial_from_transcript res{1} = partial_from_transcript res{2}.
proof.
proc. inline *. sp.
seq 1 2 : (#pre /\ (s, lw){1} = ((w, st), lw){2}); last first.
+ auto => /> &1 &2 ?c0 ??.
  rewrite /to_transcript.
  case ((respond sk{1} c0 st{1}).`1 = None);1:smt().
  move => Hr.
  have -> := some_oget (respond sk{1} c0 st{1}).`1 Hr.
  by simplify; rewrite /partial_from_transcript /=.
  
conseq />.
transitivity{1} { s <$ commit_fun sk; lw <$ commit_leak; }
  (sk0{1} = sk{2} ==> ={s, lw}) (={sk} ==> s{1} = (w, st){2} /\ ={lw}); 1, 2, 4: by auto => /#.
rndsem{2} 0. rnd. skip => ? ? ->.
by rewrite -(dmap_dprodE _ _ (fun x => x)) dmap_id.
qed.

equiv HVZK_Sim_correct k :
  DID.Honest_Execution(OpBased.P, OpBased.V).get_trans ~ HVZK_Sim_Inst.get_trans :
  k \in keygen /\ arg{1} = k /\ arg{2} = k.`1 ==> ={res}.
proof.
case k => pk_i sk_i.
(* Commitment recoverable - can drop the commitment *)
conseq
  (_: (pk_i, sk_i) \in keygen /\ arg{1} = (pk_i, sk_i) /\ arg{2} = pk_i ==>
       partial_from_transcript res{1} = partial_from_transcript res{2})
  (_: arg = (pk_i, sk_i) /\ (pk, sk) \in keygen ==>
      (!DID.is_fail res => let (w, c, z) = DID.tr_wcz res in w = (recover pk_i c z)))
  (_: arg = pk_i ==>
      (!DID.is_fail res => let (w, c, z) = DID.tr_wcz res in w = (recover pk_i c z))); 1: smt().
- by move => _ _ _ [?|??] [?|??] /> /#.
- by conseq (recover_correct pk_i sk_i).
- proc; conseq (_ : _ ==> pk = pk_i); 2: by conseq />.
  rewrite /to_transcript. by move => _ -> ??? [] /#. 
(* left hand side equiv to KLS HVZK first game *)
transitivity HVZK_Hops.game1
 ((pk_i, sk_i) \in keygen /\ arg{1} = (pk_i, sk_i) /\ arg{2} = (pk_i, sk_i) ==>
  partial_from_transcript res{1} = partial_from_transcript res{2})
 ((pk_i, sk_i) \in keygen /\ arg{1} = (pk_i, sk_i) /\ arg{2} = pk_i ==> ={res}); 1, 2: smt().
 - by conseq HE_game1.
(* right hand side equiv to KLS HVZK final game *)
transitivity HVZK_Hops.game9
  ((pk_i, sk_i) \in keygen /\ arg{1} = (pk_i, sk_i) /\ arg{2} = pk_i ==> ={res})
  ((pk_i, sk_i) \in keygen /\ arg{1} = pk_i /\ arg{2} = pk_i ==>
    res{1} = res{2}); 1, 2: smt().
- by conseq (KLS_HVZK pk_i sk_i).
proc.
by conseq (: ={pk, c, lw} /\ (or, lr){1} = (oz, lz){2}); [ done | sim ].
qed.

lemma pr_HonestExecution_Sim &m p pk sk : (pk, sk) \in keygen =>
  Pr[DID.Honest_Execution(P, V).get_trans(pk, sk) @ &m : p res] =
  Pr[HVZK_Sim_Inst.get_trans(pk) @ &m : p res].
proof.
move => pk_sk; byequiv => //. by conseq (HVZK_Sim_correct (pk, sk)) => />.
qed.

op respond_on_tuple (sk : SK) (x : (ID.W * pstate_t) * challenge_t) =
  respond sk x.`2 x.`1.`2.

op respond_is_none sk x = (respond_on_tuple sk x).`1 = None.

local module HE = {
  proc sample(sk) = {
    var x;
    x <$ (commit_fun sk `*` dC_t);
    return respond_on_tuple sk x;
  }
}.


lemma pr_HonestExecution_op pk sk &m :
  Pr[DID.Honest_Execution(P, V).get_trans(pk, sk) @ &m : DID.is_fail res] =
  mu (commit_fun sk `*` dC_t) (respond_is_none sk).
proof.
have <- : Pr[HE.sample(sk) @ &m : res.`1 = None] =
          mu (commit_fun sk `*` dC_t) (respond_is_none sk).
- by byphoare (: arg = sk ==> _) => //; proc; rnd; skip => &hr />.
byequiv => //. proc. inline. swap{1} 7 -4. wp. sp.
conseq (: (s, c0){1} = x{2}); 1: smt().
transitivity{1} { s <$ commit_fun sk0; c0 <$ dC_t; }
  (={sk0} ==> ={s, c0}) (sk0{1} = sk{!2} ==> (s, c0){1} = x{2}); 1, 2: smt().
- sim. rndsem*{1} 0. 
  auto => /> &2.
    have -> : (dfst (commit sk0{2})) = (commit_fun sk0{2}) by rewrite /commit (dprod_marginalL _ _ idfun) commit_leak_ll dscalar1 dmap_id.
    by smt().
rndsem*{1} 0. rnd. skip => &1 &2 ->.
by rewrite -(dmap_dprodE _ _ (fun x => x)) dmap_id /#.
qed.

end section OpBasedHVZK.


op ll_dflt (d : 'a distr) : 'a = choiceb (support d) witness.

lemma ll_dfltP (d : 'a distr) : is_lossless d => ll_dflt d \in d.
proof.
move => d_ll; apply: (choicebP (fun x => x \in d) witness) => /=.
move: d_ll. rewrite /is_lossless weightE_support.
apply absurd => /= ?; rewrite mu0_false /#.
qed.


(******************************************************)
(****  Instantiation of the CMA to NMA reduction ******)
(******************************************************)

(** We require a check on the matrix component of public and secrect
key that ensures:

- sufficiently high commitment entropy
- sufficiently high probability that respond succeeds *)

(* Check that ensures that the matrix is "entropy preserving" *)
(* (and has the right dimensions)                             *)
op check_mx : matrix -> bool.

axiom check_valid A : check_mx A => A \in dA.

(* upper bound on the mass of the most likely commitment for a good key *)
const eps_comm  : { real | 0%r < eps_comm } as eps_comm_gt0.

op A0 : { matrix | check_mx A0 } as A0P.

axiom check_mx_entropy :
  E (dcond dA check_mx) (fun mA =>
    p_max (dmap dy (fun y => highBitsV (mA *^ y)))) <= eps_comm.


(* upper bound on the mass of the keys not passing check *)
const eps_check : { real | 0%r <= eps_check }  as eps_check_gt0.

axiom check_mx_most : mu dA (predC check_mx) <= eps_check.


(* bound on the probability that he low-bis check in the Sim fails *)

op dz = dvector (dRq_ (gamma1 - beta_ - 1)) l.
const eps_low : { real | eps_low < 1%r } as eps_low_lt1.

axiom bound_low (t : vector) (mA : matrix) :
  t \in dvector dRq k => check_mx mA =>
  let t0 = base2lowbitsV t in
  mu ((dC tau) `*` dz) (fun (cz : _*_) =>
      (gamma2 - beta_ <= inf_normv (lowBitsV (mA *^ cz.`2 - cz.`1 ** t))) \/
  ! (inf_normv (cz.`1 ** t0) < gamma2 /\ check_hw (makeHintV (- cz.`1 ** t0) (mA *^ cz.`2 - cz.`1 ** t + cz.`1 ** t0)))) <= eps_low.


(* From the assumptions above, we can derive the assumptions of the
CMA to NMA reduction: *)

op p_rej = line12_magic_number * eps_low + (1%r - line12_magic_number).

lemma gt0_magic_number : 0%r < line12_magic_number.
proof.
suff: 0 < size (to_seq (support dsimz)) /\ 0 < size (to_seq (support dy)); last by
have := mask_nonzero; have := mask_size; smt().
rewrite /line12_magic_number => [#] ??.
apply StdOrder.RealOrder.divr_gt0;smt().
qed.

lemma magic_number_bounded : 0%r < line12_magic_number <= 1%r.
proof.
rewrite gt0_magic_number /=.
by have := clamp_magic; rewrite /clamp => <-; smt().
qed.

lemma ge0_eps_low : 0%r <= eps_low.
proof.
have t00_in : ll_dflt (dvector dRq k) \in dvector dRq k.
- by rewrite ll_dfltP dvector_ll dRq_ll.
have /= h := bound_low _ A0 t00_in A0P.
exact: (StdOrder.RealOrder.ler_trans _ _ _ (ge0_mu _ _) h).
qed.

lemma p_rej_bounded : 0%r <= p_rej < 1%r.
proof.
have ? := magic_number_bounded.
have ? : 0%r <= eps_low < 1%r by rewrite ge0_eps_low eps_low_lt1.
rewrite /p_rej.
have -> : line12_magic_number * eps_low + (1%r - line12_magic_number) =
         1%r - line12_magic_number * (1%r - eps_low) by field.
suff : 0%r < line12_magic_number * (1%r - eps_low) <= 1%r by smt().
have ? : 0%r < (1%r - eps_low) <= 1%r by smt().
split =>*; 1: by apply StdOrder.RealOrder.pmulr_gt0; smt().
by apply StdOrder.RealOrder.mulr_ile1; smt().
qed.

(* op valid_sk sk = exists pk, (pk, sk) \in keygen. *)

(* a check for "good" secret keys (i.e, well-formed and high entropy) *)
op check (sk : SK) : bool = check_mx (sk.`1) /\ sk.`2 \in ds1 /\ sk.`3 \in ds2.

import StdBigop.Bigreal.BRA.
import StdOrder.RealOrder.

lemma dmap_keygen : dmap keygen (fun (k : PK * SK) => k.`2.`1) = dA.
proof.
have ds1_ll : is_lossless ds1 by apply/dvector_ll/dRq__ll.
have ds2_ll : is_lossless ds2 by apply/dvector_ll/dRq__ll.
apply eq_distr => mA. rewrite dmap1E.
rewrite /keygen -/dA -dmapE dmap_dlet /= -{2}(dlet_d_unit dA).
rewrite (eq_dlet _ MUnit.dunit dA dA) // => {mA} mA.
rewrite dmap_dlet -(dlet_cst ds1 (MUnit.dunit mA)) //; apply eq_dlet => //= s1.
by rewrite dmap_comp /dmap -(dlet_cst ds2 (MUnit.dunit mA)) //; apply eq_dlet.
qed.

(* The expected entropy, conditioned on the SK passing the check, is high *)
lemma check_entropy: E (dcond keygen (fun k : (PK * SK) => check k.`2))
                          (fun (k : PK * SK) =>
                             p_max (dfst (commit_fun k.`2))) <= eps_comm.
proof.
apply: StdOrder.RealOrder.ler_trans check_mx_entropy.
pose g (mA : matrix) := p_max (dmap dy (fun (y : vector) => highBitsV (mA *^ y))).
pose f (k : PK * SK) := k.`2.`1.
have -> : (fun (k : PK * SK) => p_max (dfst (commit_fun k.`2))) = g \o f.
  apply/fun_ext => -[pk [A s1 s2]] @/(\o) @/f @/g @/commit /=.
  by rewrite dmap_comp /(\o) /=.
rewrite -exp_dmap.
- pose d := dmap _ _; rewrite /hasE.
  rewrite (eq_summable _ (fun x => mu1 d x * g x)) 1:/#.
  apply/summable_mu1_wght; smt(pmax_ge0 pmax_le1).
apply lerr_eq; congr; apply/eq_distr => mA.
rewrite (eq_dcond _ _ (check_mx \o f)).
+ move => x Hx /=; have :=  keygen_supp_decomp x.`1 x.`2.`1 x.`2.`2 x.`2.`3  _; smt().
by rewrite -dcond_dmap dmap_keygen.
qed.

(* most honestly sampled secret keys pass the check *)
lemma check_most : mu keygen (fun k : PK * SK => !check k.`2) <= eps_check.
proof.
apply: StdOrder.RealOrder.ler_trans check_mx_most.
rewrite (mu_eq_support _ _ ((predC check_mx) \o (fun k : PK*SK => k.`2.`1))).
+ move => x Hx /=; have /= :=  keygen_supp_decomp x.`1 x.`2.`1 x.`2.`2 x.`2.`3  _; 1:smt().
  rewrite /(\o) /predC /= /#.
by rewrite -dmapE (mu_eq_l dA) // dmap_keygen.
qed.

lemma get_pk (sk : SK) : check sk => exists pk, (pk, sk) \in keygen.
proof.
case: sk => mA s1 s2 [|> chk_mA s1_d s2_d]; exists (mA, mA *^ s1 + s2).
rewrite supp_dlet; exists mA; rewrite check_valid //=.
rewrite supp_dlet; exists s1; rewrite s1_d //=.
by rewrite supp_dmap; exists s2; rewrite s2_d.
qed.

(* probability that response fails on "good" keys is bounded by p_rej *)
lemma rej_bound (sk : SK) :
  check sk => mu (commit_fun sk `*` dC_t) (respond_is_none sk) <= p_rej.
proof.
move => chk_sk; have [pk pk_sk] := get_pk _ chk_sk.
pose &m.
have /= <- := pr_HonestExecution_op pk sk &m.
have -> := pr_HonestExecution_Sim &m (DID.is_fail) pk sk pk_sk.
have [A' t' [def_pk chk_A]] : exists A t, pk = (A, t) /\ check_mx A; 2: subst.
  case: pk pk_sk => A t pk_sk; exists A t => /=.
  + have := pk_decomp A t sk.`1 sk.`2 sk.`3; smt().
byphoare (: arg = (A', t') ==> _) => //; proc.
conseq (: _ ==> oz = None).
+ move => &hr; have -> : (pk{hr} = (pk{hr}.`1, pk{hr}.`2)) by smt().
  move => [#??] c0 lw0 lz0 oz0.
  by case(oz0);smt().
have [_ magic_le1] := magic_number_bounded.
seq 6 : (z_fail = None) line12_magic_number eps_low (1%r - line12_magic_number) 1%r
        (mA = A' /\ t = t' /\ t0 = base2lowbitsV t ).
- by auto.
- rnd; [by auto => /> _ _; rewrite -dz_fail_None | smt(gt0_magic_number)].
- rcondt ^if; 1: by auto.
  wp; conseq (: _ ==> gamma2 - beta_ <= inf_normv (lowBitsV (mA *^ z - to_c c ** t)) \/
        (!(inf_normv (to_c c ** t0) < gamma2 /\
      check_hw (makeHintV (- to_c c ** t0) (mA{hr} *^ z - to_c c ** t + to_c c ** t0))))).
  + move=> &hr [#] -> -> -> -> c0 z0; rewrite /resp_after_z /= /check_hw.
    have size_t1 : size t' = k by have := size_t _ _ pk_sk.
    have [rows_A cols_A] : size A' = (k, l).
    * by have := size_dmatrix dRq k l A' (check_valid _ chk_A); smt(gt0_k Params.gt0_l).
    rewrite check_r0_None.
    * by rewrite size_addv size_oppv size_scalarv size_mulmxv rows_A size_t1.
    rewrite check_ct0_None; 1: by rewrite size_scalarv size_base2lowbitsV.
    by move: (check_hint _) => hf; smt().
  rndsem*  0.
  rnd (fun (cz : _*_) =>
      (gamma2 - beta_ <= inf_normv (lowBitsV (mA *^ cz.`2 - to_c cz.`1 ** t))) \/
  ! (inf_normv (to_c cz.`1 ** t0) < gamma2 /\ check_hw (makeHintV (- to_c cz.`1 ** t0) (mA *^ cz.`2 - to_c cz.`1 ** t + to_c cz.`1 ** t0))));
    [auto => /> | by move=> _; exact ge0_eps_low].
  have /= := bound_low t' A' _ _.
  + rewrite supp_dvector ?ltzW ?gt0_k; move/size_t : pk_sk; smt(dRq_fu).
  + by auto.
  + pose q1 := mu (dC tau `*` dz) _.
    pose q2 := mu (dlet FSa.dC _) _.
    have ? : q1 = q2; last by smt().
    rewrite /q1 /q2 dC_to_c dmap_dprodL dmapE; congr.
    rewrite dprod_dlet /FSa.dC.
    congr; apply fun_ext => c.
    by have <- := dlet_dunit dsimz (fun (z0 : vector) => (c, z0)).
    by rewrite /(\o).
- rnd; [auto => /> _ _ | smt()].
  have dz_ll : is_lossless dz_fail by apply/dmap_ll/dvector_ll/dmask_ll.
  by rewrite (mu_eq _ _ (predC (pred1 None))) // mu_not dz_ll -dz_fail_None.
- by auto.
- done.
qed.

lemma keygen_finite : is_finite (support keygen).
proof.
apply finite_dlet => [|mA ? /=]; first exact/uniform_finite/dmatrix_uni/dRq_uni.
apply finite_dlet => [|s1 ? /=]; first exact/uniform_finite/dvector_uni/dRq__uni.
apply finite_dlet; first exact/uniform_finite/dvector_uni/dRq__uni.
by move => s2 ? @/(\o); exact finite_dunit.
qed.

(* Factorisation of the leakage of a failing response (see [ReprogHybrid]):
   the leakage of the response is a function of the challenge and of the
   outcomes [(z_fail, r0_fail, hint_fail)] of the tests on [z], [r0] and on
   the hint, normalised so that the outcomes of the tests that are not
   performed are [None] (it does not depend on the secret key).  A failing
   response has one of the [Mz + Mr0 + Mhint + 1] following outcomes: the
   test on [z] fails with one of its [Mz] failing values, the test on [r0]
   fails with one of its [Mr0] failing values, the test on the hint fails
   with one of its [Mhint] failing values, or these three tests pass (and
   the test on [c t0] fails). *)
op failing_data : (int option * int option * int option) list =
  map (fun i => (Some i, None, None)) (range 0 Mz) ++
  map (fun j => (None, Some j, None)) (range 0 Mr0) ++
  map (fun j => (None, None, Some j)) (range 0 Mhint) ++
  [(None, None, None)].

op respond_preprocess (sk : SK) (c : challenge_t) (y : pstate_t) =
  let (mA, s1, s2) = sk in
  let t0 = base2lowbitsV (mA *^ s1 + s2) in
  let z = y + to_c c ** s1 in
  let w0 = mA *^ y - to_c c ** s2 in
  let z_fail = check_z z in
  let r0_fail = check_r0 w0 in
  let hint_fail = check_hint (makeHintV (- to_c c ** t0) (w0 + to_c c ** t0)) in
  if z_fail <> None then (z_fail, None, None)
  else if r0_fail <> None then (None, r0_fail, None)
  else (None, None, hint_fail).

op respond_synthesis (sk : SK) (c : challenge_t) (d : int option * int option * int option) =
  resp_leak c d.`1 d.`2 d.`3.

lemma failing_data_uniq : uniq failing_data.
proof.
rewrite /failing_data !cat_uniq /= !map_inj_in_uniq ?range_uniq //=.
do ! split.
- by apply/hasPn => x /mapP [j [_ ->]]; apply/negP => /mapP [i [_]].
- apply/hasPn => x /mapP [j [_ ->]]; rewrite mem_cat negb_or.
  by split; apply/negP => /mapP [i [_]].
by rewrite !mem_cat !negb_or; do ! split; apply/negP => /mapP [i [_]].
qed.

lemma size_failing_data : size failing_data = Mz + Mr0 + Mhint + 1.
proof.
rewrite /failing_data !size_cat !size_map !size_range /=.
smt(ge0_Mz ge0_Mr0 ge0_Mhint).
qed.

lemma respond_factorisation sk c y : (respond sk c y).`1 = None =>
  let d = respond_preprocess sk c y in
    snd (respond sk c y) = respond_synthesis sk c d /\ mem failing_data d.
proof.
move: sk => [] mA s1 s2 /=.
rewrite /respond /resp_after_z /respond_synthesis /respond_preprocess /=.
move: (check_ct0 _) => ct0_ok.
case _: (check_z (y + to_c c ** s1)) => [|i] hz /=; last first.
- rewrite /resp_leak /= /failing_data !mem_cat; left; left; left.
  by apply/mapP; exists i; rewrite mem_range; exact (check_z_range _ _ hz).
case _: (check_r0 (mA *^ y - to_c c ** s2)) => [|j] hr /=; last first.
- rewrite /resp_leak /= /failing_data !mem_cat; left; left; right.
  by apply/mapP; exists j; rewrite mem_range; exact (check_r0_range _ _ hr).
case _: (check_hint _) => [|j] hh /=.
- by rewrite /failing_data !mem_cat.
rewrite /failing_data !mem_cat; left; right.
by apply/mapP; exists j; rewrite mem_range; exact (check_hint_range _ _ hh).
qed.

import FSaCR.DSS.
import FSaCR.DSS.PRO.
import FSaCR.DSS.DS.Stateless.
import FSaCR.DSS.EFCMA.

(* Distinguisher for (RO) signature schemes *)
module type SigDist (S : Scheme) (H : Hash_i) = {
  proc distinguish() : bool
}.


equiv eqv_code_op (D <: SigDist{-OpBasedSig}) (H <: Hash_i{-OpBased.P, -D}) :
  D(DilithiumS(H), H).distinguish ~ D(OpBasedSig(H), H).distinguish :
  ={glob D, glob H} ==> ={glob D, glob H, res}.
proof.
proc*; call (: ={glob H}); 1,2: by proc true; auto.
- by symmetry; conseq (keygen_opbased_correct H) => //.
- by symmetry; conseq (sign_opbased_correct H) => /#.
- by symmetry; conseq (verify_opbased_correct H) => /#.
done.
qed.

clone Generic as FSaG with
  op qS <= qS,
  op qH <= qH + Self.qS
proof* by smt(qS_ge0 qH_ge0).

(* Generic FS+abort transform of the OpBased ID scheme *)
module OpBasedSigG     = FSaG.IDS_Sig(OpBased.P, OpBased.V).
module O_CMA_Default_G = FSaG.DSS.DS.Stateless.O_CMA_Default.
module RO_G            = FSaG.DSS.PRO.RO.

module EF_CMA_XOF = DSSXOF.EF_CMA_RO.

module EF_CMA_RO_G = FSaG.DSS.EF_CMA_RO.
module EF_KOA_RO_G = FSaG.DSS.EF_KOA_RO.

clone FSa_CRtoGen as CG with
  type FSa.ID.PK <= PK,
  type FSa.ID.SK <= SK,
  type FSa.ID.W <= commit_t,
  type FSa.ID.C <= challenge_t,
  type FSa.ID.Z <= response_t,
  type FSa.ID.Pstate <= pstate_t,
  type FSa.M <= M,
  type FSa.ID.otranscript <= DID.otranscript,
  type FSa.LkgRO <= LkgRO,
  op FSa.dC <= dC_t,
  op FSa.dLkgRO <= dunit Empty,
  op FSa.kappa <= kappa,
  op FSaCR.recover <= recover,
  op FSaCR.qH <= qH,
  op FSaG.qS <= qS,
  op FSaG.qH <= qH + Self.qS
  proof *.
realize FSa.dC_ll by exact dC_t_ll.
realize FSaG.qS_ge0 by exact qS_ge0.
realize FSaG.qH_ge0 by smt(qH_ge0 qS_ge0).
realize FSaCR.qS_ge0 by exact qS_ge0.
realize FSaCR.qH_ge0 by exact qH_ge0.
realize FSa.dLkgRO_ll by exact dunit_ll.
realize FSa.gt0_kappa by exact gt0_kappa.

clone import FSa_CMAtoKOA as CMAtoKOA with
  type FSa.ID.PK <= PK,
  type FSa.ID.SK <= SK,
  type FSa.ID.W <= commit_t,
  type FSa.ID.C <= challenge_t,
  type FSa.ID.Z <= response_t,
  type FSa.ID.Pstate <= pstate_t,
  type FSa.M <= M,
  type FSa.ID.otranscript <= DID.otranscript,
  op FSa.dC <= dC_t,
  op FSa.dLkgRO <= dunit Empty,
  op FSa.kappa <= kappa,
  op FSaG.qS <= qS,
  op FSaG.qH <= qH + Self.qS,

  op OP.keygen <- keygen,
  op OP.respond <- respond,
  op OP.verify <- verify,
  op commit <- commit,
  op commit_fun <- commit_fun,
  op commit_leak <- fun _ => commit_leak,
  op p_rej <- p_rej,
  op check_entropy <- check,
  op eps <- eps_comm,
  op dlt <- eps_check,

  type RH.data <- int option * int option * int option,
  op RH.failing_data <- failing_data,
  op RH.respond_preprocess <- respond_preprocess,
  op RH.respond_synthesis <- respond_synthesis
proof *.
realize FSa.dC_ll by exact dC_t_ll.
realize commit_fun_ll by exact commit_fun_ll.
realize commit_leak_ll by move=>_; exact commit_leak_ll.
realize FSaG.qS_ge0 by exact qS_ge0.
realize FSaG.qH_ge0 by smt(qH_ge0 qS_ge0).
realize OP.keygen_ll by exact keygen_ll.
realize check_entropy_correct by apply check_entropy.
realize most_keys_high_entropy by apply check_most.
realize p_rej_bounded by smt(p_rej_bounded).
realize rej_bound by apply rej_bound.
realize keygen_finite by apply keygen_finite.
realize FSa.dLkgRO_ll by exact dunit_ll.
realize FSa.gt0_kappa by exact gt0_kappa.
realize RH.failing_data_non_empty.
proof. by rewrite -size_eq0 size_failing_data; smt(ge0_Mz ge0_Mr0 ge0_Mhint). qed.
realize RH.respond_factorisation by exact respond_factorisation.

(* The number of possible outcomes of a failing response *)
lemma F_eq : RH.F = Mz + Mr0 + Mhint + 1.
proof. by rewrite /RH.F undup_id ?failing_data_uniq // size_failing_data. qed.

module (RedCR (A : Self.FSaG.DSS.Adv_EFKOA_RO) : Adv_EFKOA_RO) (H : Hash) = {
  proc forge (pk : PK) : M*Sig = {
    var m, sig, w, z, cl;
    (m, sig) <@ A(H).forge(pk);
    (w, z) <- sig;
    cl <@ H.get(w, m);
    return (m, (cl.`1, z));
  }
}.

module RedNMA(A : Adv_EFCMA_RO) = RedCR(RedKOA(CG.RedFSaG(A), HVZK_Sim_Inst)).

require import SmtMap.

require import FSet.

(* Counting wrapper for XOF queries. Following the convention of the base
   game, only distinct [x : IN] arguments are counted: the integer index
   of a query is ignored. *)
module CountX(X : SIB.XOF_t) : SIB.XOF_t = {
  var qx : int
  var xs : (DID.W * M) fset

  proc init() = { qx <- 0; xs <- fset0; }

  proc get(y : (DID.W * M) * int) = {
    var r;
    if (y.`1 \notin xs) {
      xs <- xs `|` fset1 y.`1;
      qx <- qx + 1;
    }
    r <@ X.get(y);
    return r;
  }
}.

module CountS (O : SOracle_CMA) = {
  var qs : int
  proc init() = { qs <- 0; }

  proc sign (m : M) = {
    var s;
    qs <- qs + 1;
    s <@ O.sign(m);
    return s;
  }
}.

module CountH (H : Hash) = {
  var qh : int
  proc init() = { qh <- 0; }

  proc get (w, m) = {
    var cl;
    qh <- qh + 1;
    cl <@ H.get(w, m);
    return cl;
  }
}.

(*** The base game: Dilithium where challenges are computed by [SampleInBall]
     on top of an (ideal) XOF ***)

(* The scheme on top of a (leaky) challenge oracle [R] returning ring
   challenges: same computations as [DilithiumS], but the signature contains
   the ring challenge, [verify] compares ring challenges, and the leakage is
   the flat trace of [MLDSATarget] (every item is appended with [lcat]):
   [t0], then, at each iteration, the leakage of the challenge oracle, the
   challenge, and the outcomes of the tests that are performed.  This is the
   trace of [DilithiumS] preceded by [t0_leak t0] (see [resp_leak]). *)
module DilithiumR (R : SIB.SIB_t) = {
  proc keygen() : PK * SK = {
    var pk, sk;
    var mA, s1, s2, t;
    mA <$ dmatrix dRq k l;
    s1 <$ dvector (dRq_ Params.eta_) l;
    s2 <$ dvector (dRq_ Params.eta_) k;
    t  <- mA *^ s1 + s2;
    pk <- (mA, t);
    sk <- (mA, s1, s2);
    return (pk, sk);
  }

  proc sign(sk: SK, m: M) : SigXOF option * leakage = {
    var z : vector;
    var h : hint_t list;
    var response : response_t option;
    var c : Rq;
    var ctr : int;
    var y, w, w1;
    var mA, s1, s2;
    var t0;
    var lc, leak, w0;
    var ct0_ok : bool;
    var z_fail, r0_fail, hint_fail : int option;
    (* silences unused variable warning *)
    c <- witness;
    r0_fail <- witness;
    hint_fail <- witness;

    (mA, s1, s2) <- sk;
    t0 <- base2lowbitsV (mA *^ s1 + s2); (* compute t0 *)

    leak <- t0_leak t0;
    response <- None;
    ctr <- 0;
    while(response = None /\ ctr < kappa) {
      y <$ dvector dmask l;
      w <- mA *^ y;
      w1 <- highBitsV w;
      (c, lc) <@ R.get(w1, m);
      leak <- lcat leak lc;
      leak <- lcat leak (c_leak c);
      z <- y + c ** s1;
      z_fail <- check_z z;
      leak <- lcat leak (oileak z_fail);
      if (z_fail = None) {
        w0 <- w - c ** s2;
        r0_fail <- check_r0 w0;
        leak <- lcat leak (oileak r0_fail);
        if (r0_fail = None) {
          h <- makeHintV (- c ** t0) (w0 + c ** t0);
          hint_fail <- check_hint h;
          leak <- lcat leak (oileak hint_fail);
          (* test on c t0: a public computation of the leaked (c, t0) *)
          ct0_ok <- check_ct0 (c ** t0);
          if (ct0_ok /\ hint_fail = None) {
            response <- Some (z, h);
          }
        }
      }
      ctr <- ctr + 1;
    }
    return (omap (fun r => (c, r)) response, leak);
  }

  proc verify(pk: PK, m : M, sig : SigXOF) = {
    var w1, c;
    var response;
    var z, h;
    var cl';
    var mA, t, t1;
    var result;
    (mA, t) <- pk;
    t1 <- base2highbitsV t; (* t only used to compure t1 *)

    (c, response) <- sig;
    (z, h) <- response;
    w1 <- useHintV h (mA *^ z - c ** base2shiftV t1);
    cl' <@ R.get((w1, m));
    result <- size z = l /\ size h = k /\ inf_normv z < gamma1 - beta_ /\ c = cl'.`1;

    return result;
  }
}.

(* The scheme with a XOF, as specified by ML-DSA: the challenge and its
   leakage are computed by [SampleInBall] on top of the XOF. *)
module (DilithiumXOF : DSSXOF.SchemeRO)(X : SIB.XOF_t) = DilithiumR(SIB.SampleInBall(X)).
module XOF = DSSXOF.PRO.RO.
module O_CMA_XOF = DSSXOF.DS.Stateless.O_CMA_Default.

(* The EF-CMA game against [DilithiumXOF] seen as an adversary against
   the XOF, in the sense of [SampleInBallEquiv]: [X] is the XOF given to the
   adversary, [R] the (SampleInBall-based or ideal) challenge oracle used
   by the scheme. *)
module (XOFAdv(A : DSSXOF.Adv_EFCMA_RO) : SIB.XOFAdversary)(X : SIB.XOF_t, R : SIB.SIB_t) = {
  proc run(x : unit) : bool = {
    var r;
    r <@ DSSXOF.EFCMA.EF_CMA(DilithiumR(R), A(X), O_CMA_XOF).main();
    return r;
  }
}.

(*** Conversion from the simplified scheme to the scheme with a XOF ***)

(* Commitment recovery from a ring challenge *)
op recover_r (pk : PK) (c : Rq) (resp : response_t) : commit_t =
  let (mA, t) = pk in
  let (z, h) = resp in
  useHintV h (mA *^ z - c ** base2shiftV (base2highbitsV t)).

op conv_sig (s : Sig) : SigXOF = (to_c s.`1, s.`2).

(* Conversion of a signature and of its leakage: the leakage of [t0] (a
   function of the public key [pk = (mA, t)]) is prepended to the leakage of
   the simplified scheme. *)
op conv_sigl (pk : PK) (sl : Sig option * leakage) : SigXOF option * leakage =
  (omap conv_sig sl.`1, lcat (t0_leak (base2lowbitsV pk.`2)) sl.`2).

(* Conversion of the signing oracle, for the public key [OConv.pk] *)
module OConv (O : SOracle_CMA) : DSSXOF.DS.Stateless.SOracle_CMA = {
  var pk : PK

  proc sign(m : M) = {
    var sl;
    sl <@ O.sign(m);
    return conv_sigl pk sl;
  }
}.

(* The challenge oracle of [SampleInBallEquiv] on top of a random oracle of
   the simplified scheme (whose leakage is [Empty]) *)
module ROCofRO (H : Hash) : SIB.ROC_t = {
  proc get(x : commit_t * M) = {
    var r;
    r <@ H.get(x);
    return r.`1;
  }
}.

(* Counting wrapper for the signing queries of an adversary against the
   scheme with a XOF *)
module CountSX (O : DSSXOF.DS.Stateless.SOracle_CMA) = {
  var qs : int
  proc init() = { qs <- 0; }

  proc sign (m : M) = {
    var s;
    qs <- qs + 1;
    s <@ O.sign(m);
    return s;
  }
}.

(* A signature that never verifies *)
op bad_sig : Sig = (witness, (zerov 0, witness)).

(* Reduction from an adversary against the scheme with a XOF to an adversary
   against the simplified scheme: the XOF is simulated from the challenge
   oracle (see [SampleInBallEquiv]; the random oracle of the simplified scheme
   returns the outputs of the ideal challenge oracle, and an empty leakage),
   the answers of the signing oracle are converted (the reduction knows [t]
   hence [t0 = base2lowbitsV t], and prepends its leakage), and the forgery
   is converted by querying the challenge oracle on the recovered commitment
   (one additional query).  The counting
   wrappers [CountX] and [CountSX] do not change the behaviour of the
   reduction: they are only there so that the query bound of the reduction is
   a syntactic instance of the query bound of [A] (see [RedA_bound]). *)
module (RedXOF(A : DSSXOF.Adv_EFCMA_RO) : Adv_EFCMA_RO)(RO : Hash, O : SOracle_CMA) = {
  proc forge(pk : PK) : M * Sig = {
    var m, sig, c, zh, w1, cl;
    CountX.qx <- 0;
    CountX.xs <- fset0;
    CountSX.qs <- 0;
    OConv.pk <- pk;
    SIB.Sim(ROCofRO(RO)).init();
    (m, sig) <@ A(CountX(SIB.Sim(ROCofRO(RO))), CountSX(OConv(O))).forge(pk);
    (c, zh) <- sig;
    w1 <- recover_r pk c zh;
    cl <@ RO.get(w1, m);
    return (m, if to_c cl.`1 = c then (cl.`1, zh) else bad_sig);
  }
}.

(*************************)
(****  Main Theorem ******)
(*************************)

(* The main theorem is first proved for an adversary against the scheme
   with an ideal challenge oracle ([DilithiumS_secure], steps 1 to 5), and
   then for an adversary against the scheme with an ideal XOF
   ([DilithiumXOF_secure], step 0). *)

section PROOF.

declare module A <: Adv_EFCMA_RO{
  -O_CMA_Default, -H, -OpBasedSig,
  -O_CMA_Default_G, -RO_G, -OpBasedSigG,
  -ORedKOA, -CMAtoKOA.CountS, -CMAtoKOA.CountH,
  -CountS, -CountH,
  -G, -RqStMSIS.Std.PRO.RO, -RqStMSIS.ORed,
  -P, -V, -CG.FSaG.DSS.DS.Stateless.O_CMA_Default, -CG.FSaG.DSS.PRO.RO, -CG.FSaCR.DSS.DS.Stateless.O_CMA_Default, -CG.FSaCR.DSS.PRO.RO,
  -FSaG.DSS.DS.Stateless.O_CMA_Default, -FSaG.DSS.PRO.RO, -OP.P, -OP.V, -RH.RO.RO, -RH.Count, -RH.OSign, -OGame1, -RedOnce
}.

(* A makes at most qS queries to [sign] and at most qH queries to [H.get] *)
declare axiom A_bound
 (H' <: Hash{-A, -CountH, -CountS})
 (SO' <: SOracle_CMA{-A, -CountH, -CountS})
 :
 hoare[ A(CountH(H'), CountS(SO')).forge :
        CountH.qh = 0 /\ CountS.qs = 0 ==>
        CountH.qh <= qH /\ CountS.qs <= qS].

(* The adversary will output a forgery attempt, provided all oracle calls terminate *)
declare axiom A_ll
 (SO <: SOracle_CMA{-A})
 (H <: Hash{-A}) :
 islossless SO.sign => islossless H.get => islossless A(H, SO).forge.

(*** Step 1 : Replace the code-based scheme with an operator-based one ***)

(* EF_CMA game seen as a distinshuisher for signature schemes *)
local module (SD : SigDist) (S : Scheme) (H : Hash_i) = {
  proc distinguish() = {
    var r;
    H.init();
    r <@ EF_CMA(S, A(H), O_CMA_Default).main();
    return r;
  }
}.

local lemma pr_code_op &m :
  Pr [ EF_CMA_RO(DilithiumS, A, RO, O_CMA_Default).main() @ &m : res ] =
  Pr [ EF_CMA_RO(OpBasedSig, A, RO, O_CMA_Default).main() @ &m : res ].
proof.
byequiv (_: ={glob A, glob RO, glob O_CMA_Default} ==> ={res}) => //; proc*.
transitivity*{1} { r <@ SD(DilithiumS(RO), RO).distinguish(); };
  first by sim.
transitivity*{2} { r <@ SD(OpBasedSig(RO), RO).distinguish(); };
  last by sim.
by call (eqv_code_op SD RO).
qed.


(*** Step 2 : Reduce to the case for general (i.e., not commitment recoverable schemes) ***)

local lemma pr_cr_gen &m :
  Pr [ EF_CMA_RO  (OpBasedSig, A, RO, O_CMA_Default).main() @ &m : res ] <=
  Pr [ EF_CMA_RO_G(OpBasedSigG, CG.RedFSaG(A), RO_G, O_CMA_Default_G).main() @ &m : res ].
proof.
have H := CG.FSa_CommRecov_Generic OpBased.P OpBased.V _ A &m; 1: by islossless.
have -> : Pr[EF_CMA_RO_G(OpBasedSigG, CG.RedFSaG(A), RO_G, O_CMA_Default_G).main() @ &m : res] =
   Pr[CG.FSaG.DSS.EF_CMA_RO(CG.FSaG.IDS_Sig(P, V), CG.RedFSaG(A), CG.FSaG.DSS.PRO.RO, CG.FSaG_O_Default).main
      () @ &m : res]  by byequiv => //; proc; sim.
have -> : Pr[EF_CMA_RO(OpBasedSig, A, RO, O_CMA_Default).main() @ &m : res] =
  Pr[CG.FSaCR.DSS.EF_CMA_RO(CG.FSaCR.IDS_Sig(P, V), A, CG.FSaCR.DSS.PRO.RO, CG.FSaCR_O_Default).main() @ &m : res ]  by byequiv => //; proc; sim.
by exact (StdOrder.RealOrder.ler_trans _ _ _ H).
qed.

(*** Step 3 : Instantiate the CMA to KOA reduction *)

(* Counting wrapper for adversaries*)

local module Wrap(A : Adv_EFCMA_RO, H : Hash, O : SOracle_CMA) = {
  proc forge(pk) = {
    var r;
    CountH.qh <- 0;
    CountS.qs <- 0;
    r <@ A(CountH(H), CountS(O)).forge(pk);
    return r;
  }
}.

local module B = RedKOA(CG.RedFSaG(A), HVZK_Sim_Inst).

section.
import Self.FSaG.
import Self.FSaG.DSS.
import Self.FSaG.DSS.PRO.
import Self.FSaG.DSS.DS.Stateless.

lemma pr_cma_koa &m :
  Pr [ EF_CMA_RO_G(OpBasedSigG, CG.RedFSaG(A), RO_G, O_CMA_Default_G).main() @ &m : res ] <=
  Pr [ EF_KOA_RO_G(OpBasedSigG, RedKOA(CG.RedFSaG(A), HVZK_Sim_Inst), RO_G).main() @ &m : res ] +
  reprog_bound + eps_check.
proof.
have H := CMAtoKOA.FSabort_bound (CG.RedFSaG(Wrap(A))) _ _ HVZK_Sim_Inst _ &m; first last.
- move => Hx Ox ? ?. islossless.
  apply (A_ll (<:CountS(CG.OCR(Hx, Ox))) (CountH(Hx))); islossless.
- move => _k.
  have Hsim := HVZK_Sim_correct _k.
  proc*.
  transitivity* {1} {r <@ DID.Honest_Execution(P, V).get_trans(pk, sk); }; 1: by sim.
  transitivity* {2} {r <@ HVZK_Sim_Inst.get_trans(pk); }; 2: by sim.
  by call Hsim.

- (* This is the same up to [Wrap] which introduces a counter that's never checked *)
  have -> : Pr[EF_CMA_RO_G(OpBasedSigG, CG.RedFSaG(A), RO_G, O_CMA_Default_G).main() @ &m : res ]=
            Pr[EF_CMA_RO_G(OpBasedSigG, CG.RedFSaG(Wrap(A)), RO_G, O_CMA_Default_G).main() @ &m : res ].
  + byequiv (_: ={glob A, glob RO_G, glob O_CMA_Default_G, glob P} ==> ={res}) => //.
    proc. inline{1}2; inline{2} 2.
    seq 4 4 : (={pk, m, sig, RO.m, O_CMA_Default.qs}); last by sim.
    inline{1}4; inline{2}4; inline{2} 5; wp.
    call (: ={glob RO, glob CG.OCR(RO, O_CMA_Default(IDS_Sig(P, V, RO)))}).
    - by proc*; inline{2} 1; wp; sim.
    - by proc; inline *; auto.
    by inline*; auto => />.
  have -> : Pr[EF_CMA_RO_G(OpBasedSigG, CG.RedFSaG(Wrap(A)), RO_G, O_CMA_Default_G).main() @ &m : res] =
     Pr[FSaG.DSS.EF_CMA_RO(FSaG.IDS_Sig(OP.P, OP.V), CG.RedFSaG(Wrap(A)), FSaG.DSS.PRO.RO, FSaG.DSS.DS.Stateless.O_CMA_Default).main
      () @ &m : res]; 1: by byequiv => //=; sim.
  apply (StdOrder.RealOrder.ler_trans _ _ _ H); rewrite !StdOrder.RealOrder.ler_add2r.
  byequiv (_: ={glob A, glob RO_G, glob P} ==> ={res}) => //. symmetry.
  proc. inline{1}2; inline{2} 2.
  seq 3 3 : (={pk, m, sig} /\ RO.m{1} = FSaG.DSS.PRO.RO.m{2}); last by sim.
  inline{1}3; inline{2}3; inline{1}5; inline{2}5; inline{2} 6; wp.
  call (: ={glob ORedKOA(HVZK_Sim_Inst)} /\ RO.m{1} = FSaG.DSS.PRO.RO.m{2}).
  - by proc*; inline{2} 1; wp; sim.
  - proc*; inline{2} 1; wp.
    call (: ={glob ORedKOA(HVZK_Sim_Inst)} /\ RO.m{1} = FSaG.DSS.PRO.RO.m{2}); last by auto.
    by inline *; sp; if; auto.
  by inline*; auto => />.
(* Query bound for RedFSaG *)
move => Ox Hx; proc; wp.
(* go back to procedure judgment *)
inline *; sp; wp.
(* [OCR] only queries [H] when signing succeeds: the count is an upper bound *)
conseq (_: CMAtoKOA.CountH.qh <= CountH.qh + CountS.qs /\ CountS.qs = CMAtoKOA.CountS.qs)
       (_: CountH.qh = 0 /\ CountS.qs = 0 ==> CountH.qh <= qH /\ CountS.qs <= qS); 1, 2: smt().
  by call (A_bound (<: CMAtoKOA.CountH(Hx)) (<: CG.OCR(CMAtoKOA.CountH(Hx), CMAtoKOA.CountS(Ox)))).
call (: CMAtoKOA.CountH.qh <= CountH.qh + CountS.qs /\ CountS.qs = CMAtoKOA.CountS.qs).
- proc. inline*. sp. seq 1 : (#pre); 1: by call(: true).
  sp; if; last by auto => /> /#.
  by wp; call(: true); auto => /> /#.
- proc. inline*; wp; call(: true); auto => /> /#.
- by auto.
qed.

end section.

(*** Step 4 : Go back to the KOA propblem for the CR transform *)

local lemma verify_recover pk w c z :
  verify pk w c z => recover pk c z = w.
proof. rewrite /verify /recover. smt(). qed.

local lemma pr_koa_cr &m (B <: Self.FSaG.DSS.Adv_EFKOA_RO{-RO.m, -Self.FSaG.DSS.PRO.RO}) :
  Pr [ EF_KOA_RO_G(OpBasedSigG, B, RO_G).main() @ &m : res ] <=
  Pr [ EF_KOA_RO(OpBasedSig, RedCR(B), RO).main() @ &m : res].
proof.
byequiv => //; proc.
inline{1}2; inline{2}2. inline{2}3.
seq 3 4 : (={pk} /\ m{1} = m0{2} /\ sig{1} = sig0{2} /\ Self.FSaG.DSS.PRO.RO.m{1} = RO.m{2}).
- inline*.
  call(: Self.FSaG.DSS.PRO.RO.m{1} = RO.m{2}); [by proc; inline*; auto| by auto].
wp.
inline{1} 1. inline{2} 4. wp. sp.
seq 1 1 : (#pre /\ (c, _lc){1} = cl{2} /\ (RO.m.[w, m0] = Some cl){2}).
- inline*. auto => /> &2 r0 ?. rewrite get_set_eqE //=.
  do 2 ! rewrite -pairS. by split => [ _ | /get_some ].
inline V.verify. sp.
inline RO.get.
case (result{1}); last by conseq (:_ ==> true); [smt()|islossless].
rcondf{2} ^if; 1: by move => &h; auto => &h' />; smt(verify_recover).
rcondt{2} ^if; 1: by move => &h; auto => &h' />; smt(verify_recover).
auto => />; smt(verify_recover).
qed.

(* Step 5 : Go back to the Code-Based Scheme used for the NMA proof *)

local module (SD' : SigDist) (S : Scheme) (H : Hash_i) = {
  proc distinguish() = {
    var r;
    H.init();
    r <@ EF_KOA(S, RedCR(B, H)).main();
    return r;
  }
}.

local lemma pr_code_op' &m :
  Pr [ EF_KOA_RO(DilithiumS, RedCR(B), RO).main() @ &m : res ] =
  Pr [ EF_KOA_RO(OpBasedSig, RedCR(B), RO).main() @ &m : res ].
proof.
byequiv (_: ={glob A, glob RO, glob ORedKOA} ==> ={res}) => //; proc*.
transitivity*{1} { r <@ SD'(DilithiumS(RO), RO).distinguish(); };
  first by sim.
transitivity*{2} { r <@ SD'(OpBasedSig(RO), RO).distinguish(); };
  last by sim.
by call (eqv_code_op SD' RO).
qed.

lemma DilithiumS_secure &m :
  Pr [EF_CMA_RO(DilithiumS, A, RO, O_CMA_Default).main() @ &m : res ] <=
    `|Pr[GameL(RedMLWE(RedNMA(A), RO)).main() @ &m : res] -
      Pr[GameR(RedMLWE(RedNMA(A), RO)).main() @ &m : res]|
  + Pr[RqStMSIS.Std.Game(RqStMSIS.RedStd(FiberSamplerRej, RedMSIS(RedNMA(A))), RqStMSIS.Std.PRO.RO).main() @ &m : res]
  + ((Mz + Mr0 + Mhint + 2)%r * qS%r * (qH + qS + 1)%r * eps_comm / (1%r - p_rej) +
     qS%r * eps_comm * (qS%r + 1%r) / (2%r * (1%r - p_rej) ^ 2))
  + eps_check.
proof.
rewrite pr_code_op.
apply (ler_trans _ _ _ (pr_cr_gen _)).
apply (ler_trans _ _ _ (pr_cma_koa _)).
have -> : Mz + Mr0 + Mhint + 2 = RH.F + 1 by rewrite F_eq.
rewrite !ler_add2r.
apply (ler_trans _ _ _ (pr_koa_cr _ B)).
rewrite -pr_code_op'.
apply (ler_trans _ _ _ (KOA_bound (RedCR(B)) &m)).
by rewrite ler_add2l; exact (StMSIS_bridge (RedMSIS(RedCR(B))) &m).
qed.
end section PROOF.

(*** Step 0 : Reduce to the game with an abstract challenge RO ***)

(* The scheme with an ideal XOF [DilithiumXOF] is reduced to the simplified
   scheme whose random oracle returns the outputs of the ideal challenge
   oracle [SIB.ROC] (pre-image and leakage of the rejected bytes) with an
   empty leakage, by [SampleInBallEquiv].  The leakage traces are then equal,
   up to the initial item [t0_leak t0] which the reduction [RedXOF]
   prepends ([conv_sigl], [sign_conv]). *)

section XOF.

declare module A <: DSSXOF.Adv_EFCMA_RO{
  -O_CMA_Default, -H, -OpBasedSig,
  -O_CMA_Default_G, -RO_G, -OpBasedSigG,
  -ORedKOA, -CMAtoKOA.CountS, -CMAtoKOA.CountH,
  -SIB.ORedXOFROC, -SIB.XOF.RO, -SIB.ROC.RO, -XOF, -O_CMA_XOF,
  -CountS, -CountH, -CountX, -CountSX, -OConv,
  -G, -RqStMSIS.Std.PRO.RO, -RqStMSIS.ORed,
  -P, -V, -CG.FSaG.DSS.DS.Stateless.O_CMA_Default, -CG.FSaG.DSS.PRO.RO, -CG.FSaCR.DSS.DS.Stateless.O_CMA_Default, -CG.FSaCR.DSS.PRO.RO,
  -FSaG.DSS.DS.Stateless.O_CMA_Default, -FSaG.DSS.PRO.RO, -OP.P, -OP.V, -RH.RO.RO, -RH.Count, -RH.OSign, -OGame1, -RedOnce
}.

(* A makes at most qS queries to [sign] and at most [qH - 1] (distinct)
   queries to the XOF: the reduction [RedXOF] makes one more query to the
   challenge oracle, to convert the forgery. *)
declare axiom A_bound
 (X' <: SIB.XOF_t{-A, -CountX, -CountSX})
 (SO' <: DSSXOF.DS.Stateless.SOracle_CMA{-A, -CountX, -CountSX})
 :
 hoare[ A(CountX(X'), CountSX(SO')).forge :
        CountX.qx = 0 /\ CountSX.qs = 0 ==>
        CountX.qx <= qH - 1 /\ CountSX.qs <= qS].

(* The adversary will output a forgery attempt, provided all oracle calls terminate *)
declare axiom A_ll
 (SO <: DSSXOF.DS.Stateless.SOracle_CMA{-A})
 (X <: SIB.XOF_t{-A}) :
 islossless SO.sign => islossless X.get => islossless SIB.SampleInBall(X).get =>
 islossless A(X, SO).forge.

local module A' = RedXOF(A).

(*** Query bound for the reduced adversary ***)

(* The simulator queries the challenge oracle exactly once per distinct [x],
   which is what [CountX] counts; the conversion of the forgery makes one
   more query. *)
local lemma RedA_bound
 (H' <: Hash{-A', -CountH, -CountS})
 (SO' <: SOracle_CMA{-A', -CountH, -CountS})
 :
 hoare[ A'(CountH(H'), CountS(SO')).forge :
        CountH.qh = 0 /\ CountS.qs = 0 ==>
        CountH.qh <= qH /\ CountS.qs <= qS].
proof.
proc.
seq 6 : (CountH.qh <= qH - 1 /\ CountS.qs <= qS); last first.
- by inline *; wp; call (: true); auto => /#.
conseq (: _ ==> CountH.qh <= CountX.qx /\ CountS.qs = CountSX.qs)
       (: CountH.qh = 0 /\ CountS.qs = 0 ==> CountX.qx <= qH - 1 /\ CountSX.qs <= qS); 1, 2: smt().
- (* query bound of [A], syntactic instance of [A_bound] *)
  by call (A_bound (SIB.Sim(ROCofRO(CountH(H')))) (OConv(CountS(SO')))); inline*; auto.
call (: CountH.qh = CountX.qx /\ CountS.qs = CountSX.qs /\ CountX.xs = SIB.RR.F2.Sim.reprog /\
         SIB.RR.F1.Sim.reprog = SIB.RR.F2.Sim.reprog).
- (* signing oracle *)
  by proc; inline *; wp; call (: true); auto.
- (* XOF oracle *)
  proc; inline *; case (y.`1 \in CountX.xs).
  + (* [x] already known: no query to the challenge oracle, nothing counted *)
    rcondf 1; 1: by auto. sp. rcondf 1; 1: by auto => /#.
    by auto.
  (* new [x]: the simulator queries the challenge oracle exactly once *)
  rcondt 1; 1: by auto. sp. rcondt 1; 1: by auto => /#. rcondt 4; 1: by auto => /#.
  seq 8 : (CountH.qh = CountX.qx /\ CountS.qs = CountSX.qs /\ CountX.xs = SIB.RR.F2.Sim.reprog /\
         SIB.RR.F1.Sim.reprog = SIB.RR.F2.Sim.reprog); 1: by wp; call (: true); auto => /> /#.
  wp; rnd; wp; while (CountH.qh = CountX.qx /\ CountS.qs = CountSX.qs /\ CountX.xs = SIB.RR.F2.Sim.reprog /\
         SIB.RR.F1.Sim.reprog = SIB.RR.F2.Sim.reprog); 1: by auto.
  seq 5 : (CountH.qh = CountX.qx /\ CountS.qs = CountSX.qs /\ CountX.xs = SIB.RR.F2.Sim.reprog /\
         SIB.RR.F1.Sim.reprog = SIB.RR.F2.Sim.reprog); 1: by auto.
  seq 1 : (CountH.qh = CountX.qx /\ CountS.qs = CountSX.qs /\ CountX.xs = SIB.RR.F2.Sim.reprog /\
         SIB.RR.F1.Sim.reprog = SIB.RR.F2.Sim.reprog); 1: by if; auto.
  by auto.
by inline*; auto.
qed.

(*** Losslessness of the reduced adversary ***)

local lemma Sim_get_ll (H <: SIB.ROC_t) :
  islossless H.get => islossless SIB.Sim(H).get.
proof.
move => H_ll; proc.
call (: true); 1: by auto; smt(Byte.dB_ll).
inline 1; sp; if; last by auto.
call (SIB.ReprogIndices_ll
        (<: SIB.RR.F1.Sim(SIB.ReprogIndices,
              SIB.RR.ToSampler(SIB.RR.F2.Sim(SIB.ReprogChallenge, SIB.Sim(H).R'))).Overlay) _);
  1: by islossless.
call (: true); last by auto.
call (: true); 1: by auto; smt(dprod_ll SIB.dI_ll SIB.dRej_ll).
inline 1; sp; if; last by auto.
call (SIB.ReprogChallenge_ll (<: SIB.RR.F2.Sim(SIB.ReprogChallenge, SIB.Sim(H).R').Overlay) _);
  1: by islossless.
by call H_ll; auto.
qed.

(* [SampleInBall] on top of the simulated XOF terminates: the first query on
   [x] reprograms the whole (finite) overlay of [x]; afterwards, the inner
   loop of [SampleInBall] reads the overlay up to its last context [B], and
   then only fresh (uniform) bytes, each accepted with probability at least
   [1/256]. *)
local lemma ctx_bound_list (s : ((DID.W * M) * int) list) :
  exists B, forall p, p \in s => p.`2 < B.
proof.
elim: s => [|p s [B hB]]; 1: by exists 0.
by exists (max B (p.`2 + 1)) => q /= [-> | /hB]; smt().
qed.

local lemma ctx_bound (m : ((DID.W * M) * int, 'b) fmap) x :
  exists B, forall c, (x, c) \in m => c < B.
proof.
have [B hB] := ctx_bound_list (elems (fdom m)).
by exists B => c hc; apply (hB (x, c)); rewrite -memE mem_fdom.
qed.

local lemma mu_dB_le i : 0 <= i => 1%r / 256%r <= mu Byte.dB (fun b => Byte.to_int b <= i).
proof.
move=> ge0i; rewrite /Byte.dB dmapE /(\o) /=.
apply (ler_trans (mu (drange 0 256) (pred1 0))); 1: by rewrite drange1E.
by apply mu_le => x /supp_drange hx /= ->; rewrite Byte.tK'.
qed.

local lemma CSim_get_ll (H <: SIB.ROC_t) :
  islossless H.get => islossless CountX(SIB.Sim(H)).get.
proof. by move => H_ll; proc; call (Sim_get_ll H H_ll); auto. qed.

local lemma CSim_get_reprog (H <: SIB.ROC_t{-SIB.RR.F1.Sim}) xr :
  hoare [CountX(SIB.Sim(H)).get :
           xr \in SIB.RR.F1.Sim.reprog \/ y.`1 = xr ==> xr \in SIB.RR.F1.Sim.reprog].
proof.
proc; inline *.
seq 4 : (xr \in SIB.RR.F1.Sim.reprog); last by auto.
seq 3 : (xr \in SIB.RR.F1.Sim.reprog \/ x = xr); 1: by auto.
if; last by auto => /#.
seq 1 : (xr \in SIB.RR.F1.Sim.reprog).
- by auto => /> &hr h _; rewrite in_fsetU in_fset1 /#.
by conseq (: _ ==> true).
qed.

local lemma CSim_get_dom (H <: SIB.ROC_t{-SIB.RR.F1.Sim}) yq mq rq :
  hoare [CountX(SIB.Sim(H)).get :
           y = yq /\ yq.`1 \in SIB.RR.F1.Sim.reprog /\
           SIB.RR.F1.Sim.Overlay.m = mq /\ SIB.RR.F1.Sim.reprog = rq ==>
           SIB.RR.F1.Sim.reprog = rq /\
           forall z, z \in SIB.RR.F1.Sim.Overlay.m <=> (z \in mq \/ z = yq)].
proof.
proc; inline *.
rcondf 4; 1: by auto.
auto => /> _ r1 _; split => [_ z | hin z]; [by rewrite mem_set | by case => // ->].
qed.

local lemma CSim_get_dom_ph (H <: SIB.ROC_t{-SIB.RR.F1.Sim}) yq mq rq :
  islossless H.get =>
  phoare [CountX(SIB.Sim(H)).get :
           y = yq /\ yq.`1 \in SIB.RR.F1.Sim.reprog /\
           SIB.RR.F1.Sim.Overlay.m = mq /\ SIB.RR.F1.Sim.reprog = rq ==>
           SIB.RR.F1.Sim.reprog = rq /\
           forall z, z \in SIB.RR.F1.Sim.Overlay.m <=> (z \in mq \/ z = yq)] = 1%r.
proof. by move=> H_ll; conseq (CSim_get_ll H H_ll) (CSim_get_dom H yq mq rq). qed.

local lemma ctx_bound_step (m0 m1 : ((DID.W * M) * int, 'b) fmap) x B c0 :
  (forall c, B <= c => (x, c) \in m0 => c < c0) =>
  (forall q, q \in m1 <=> (q \in m0 \/ q = (x, c0))) =>
  forall c, B <= c => (x, c) \in m1 => c < c0 + 1.
proof. by move=> h0 h1 c le_Bc /h1 [/(h0 _ le_Bc) | /= ->] /#. qed.

local lemma CSim_get_fresh (H <: SIB.ROC_t{-SIB.RR.F1.Sim}) i0 :
  phoare [CountX(SIB.Sim(H)).get :
           y.`1 \in SIB.RR.F1.Sim.reprog /\ y \notin SIB.RR.F1.Sim.Overlay.m /\ 0 <= i0 ==>
           Byte.to_int res <= i0] >= (1%r / 256%r).
proof.
proc; inline *.
rcondf 4; 1: by auto.
rcondt 6; 1: by auto.
wp; rnd (fun b => Byte.to_int b <= i0); auto => />.
by move=> &hr _ _ ge0i; rewrite mu_dB_le //= => v _; rewrite get_set_sameE.
qed.

local lemma SampleInBall_Sim_ll (H <: SIB.ROC_t{-SIB.RR.F1.Sim}) :
  islossless H.get => islossless SIB.SampleInBall(CountX(SIB.Sim(H))).get.
proof.
move => H_ll; proc.
exlim x => xx.
while (x = xx /\ xx \in SIB.RR.F1.Sim.reprog /\ 8 <= ctx /\ 256 - tau <= i <= 256) (256 - i).
- move=> z; sp; wp.
  conseq (: (exists B, forall c, B <= c => (xx, c) \in SIB.RR.F1.Sim.Overlay.m => c < ctx) /\
            x = xx /\ (xx \in SIB.RR.F1.Sim.reprog) /\ 8 <= ctx /\ 256 - tau <= i < 256 /\
            256 - i = z /\ i < j ==>
            x = xx /\ (xx \in SIB.RR.F1.Sim.reprog) /\ 8 <= ctx /\ 256 - tau <= i < 256 /\
            256 - i = z).
  + move=> &hr h; have [B hB] := ctx_bound SIB.RR.F1.Sim.Overlay.m{hr} xx.
    by split; [exists B => c ge_c /hB /# | smt()].
  + by move=> &hr h reprog ctx0 /#.
  elim* => B.
  conseq (: x = xx /\ (xx \in SIB.RR.F1.Sim.reprog) /\ 8 <= ctx /\ 256 - tau <= i < 256 /\
            256 - i = z /\ (forall c, B <= c => (xx, c) \in SIB.RR.F1.Sim.Overlay.m => c < ctx) ==>
            _); 1: smt().
  while (x = xx /\ (xx \in SIB.RR.F1.Sim.reprog) /\ 8 <= ctx /\ 256 - tau <= i < 256 /\
         256 - i = z /\ (forall c, B <= c => (xx, c) \in SIB.RR.F1.Sim.Overlay.m => c < ctx))
        (if i < j then max (B - ctx) 0 + 1 else 0) (max B 0 + 1) (1%r / 256%r).
  + by move=> &hr.
  + by move=> &hr reprog m ctx0 j0 [#] 6? _ _; smt().
  + by move=> &hr reprog m ctx0 j0 [#] *; smt().
  + move=> ih; seq 4 : (x = xx /\ (xx \in SIB.RR.F1.Sim.reprog) /\ 8 <= ctx /\ 256 - tau <= i < 256 /\
                       256 - i = z /\ (forall c, B <= c => (xx, c) \in SIB.RR.F1.Sim.Overlay.m => c < ctx)).
    * by auto.
    * wp; exlim ctx, SIB.RR.F1.Sim.Overlay.m, SIB.RR.F1.Sim.reprog => c0 m0 r0.
      call (CSim_get_dom_ph H (xx, c0) m0 r0 H_ll).
      by auto => /> &hr; smt(ctx_bound_step).
    * exact ih.
    * hoare; wp; exlim ctx, SIB.RR.F1.Sim.Overlay.m, SIB.RR.F1.Sim.reprog => c0 m0 r0.
      call (CSim_get_dom H (xx, c0) m0 r0).
      by auto => /> &hr; smt(ctx_bound_step).
    by move=> &hr.
  + wp; exlim ctx, SIB.RR.F1.Sim.Overlay.m, SIB.RR.F1.Sim.reprog => c0 m0 r0.
    call (CSim_get_dom_ph H (xx, c0) m0 r0 H_ll).
    by auto => /> &hr; smt(ctx_bound_step).
  split; 1: smt().
  move=> z0; case (ctx < B).
  + (* the context is still in the reprogrammed part: deterministic progress *)
    conseq (: _ ==> _ : = 1%r); 1: smt().
    by wp; call (CSim_get_ll H H_ll); auto => /> &hr *; smt().
  (* fresh context: the byte is accepted with probability at least 1/256 *)
  exlim i => i0; wp.
  call (CSim_get_fresh H i0).
  auto => /> &hr _ _ ge_i0 _ hB _ ge_B; split; 2: smt().
  split; 2: smt(tau_bound).
  by apply/negP => h; have := hB ctx{hr} _ h; smt().
(* the first [8] queries reprogram [x] *)
wp; while (x = xx /\ 0 <= ctx <= 8 /\ (0 < ctx => xx \in SIB.RR.F1.Sim.reprog)) (8 - ctx).
- move=> z; wp; call (: xx \in SIB.RR.F1.Sim.reprog \/ y.`1 = xx ==> xx \in SIB.RR.F1.Sim.reprog).
  + by conseq (CSim_get_ll H H_ll) (CSim_get_reprog H xx).
  by auto => /#.
by auto => />; smt(tau_bound).
qed.

local lemma RedA_ll
 (SO <: SOracle_CMA{-A'})
 (H <: Hash{-A'}) :
 islossless SO.sign => islossless H.get => islossless A'(H, SO).forge.
proof.
move => SO_ll H_ll; proc.
call H_ll; wp.
have RH_ll : islossless ROCofRO(H).get by proc; call H_ll.
call (A_ll (CountSX(OConv(SO))) (CountX(SIB.Sim(ROCofRO(H)))) _
        (CSim_get_ll (ROCofRO(H)) RH_ll) (SampleInBall_Sim_ll (ROCofRO(H)) RH_ll)).
- by proc; inline *; wp; call SO_ll; auto.
by inline*; auto.
qed.

(*** Step 0 : Reduce to the game with an abstract challenge RO ***)

(* The challenge oracle of [SampleInBallEquiv] and the hash oracle of the
   FS+abort proof are the same random oracle, up to the (empty) leakage of
   the latter. *)
local equiv ROC_RO_get :
  SIB.ROC.RO.get ~ RO.get :
  ={arg} /\ RO.m{2} = map (fun _ v => (v, Empty)) SIB.ROC.RO.m{1} ==>
  res{2} = (res{1}, Empty) /\ RO.m{2} = map (fun _ v => (v, Empty)) SIB.ROC.RO.m{1}.
proof.
proc; seq 1 1 : (#pre /\ r{2} = (r{1}, Empty)).
- rnd (fun v => (v, Empty)) (fun (p : challenge_t * leakage) => p.`1); auto => />.
  split => [[c l] /supp_dprod /= [_ /supp_dunit] -> // | _].
  split => [[c l] /supp_dprod /= [_ /supp_dunit ->] | _ v hv]; 1: by rewrite dprod1E dunit1E /= /dC_t.
  by rewrite supp_dprod /= supp_dunit.
if; 1: by move=> &1 &2 [[-> ->] _]; rewrite mem_map.
- by auto => /> &1 &2 _; rewrite map_set /= !get_set_sameE.
by auto => /> &1 &2; rewrite mapE domE; case: (SIB.ROC.RO.m{1}.[x{2}]).
qed.

(* The same, recording that the answer is in the table *)
local equiv ROC_RO_get_in x0 :
  SIB.ROC.RO.get ~ RO.get :
  ={arg} /\ arg{2} = x0 /\ RO.m{2} = map (fun _ v => (v, Empty)) SIB.ROC.RO.m{1} ==>
  res{2} = (res{1}, Empty) /\ RO.m{2} = map (fun _ v => (v, Empty)) SIB.ROC.RO.m{1} /\
  RO.m{2}.[x0] = Some res{2}.
proof.
conseq ROC_RO_get _ (: x = x0 ==> RO.m.[x0] = Some res) => //.
proc; auto => /> &h r _.
by rewrite get_set_sameE domE /=; case: (RO.m{h}.[x0]).
qed.

local equiv ROC_ROCofRO_get :
  SIB.ROC.RO.get ~ ROCofRO(RO).get :
  ={arg} /\ RO.m{2} = map (fun _ v => (v, Empty)) SIB.ROC.RO.m{1} ==>
  ={res} /\ RO.m{2} = map (fun _ v => (v, Empty)) SIB.ROC.RO.m{1}.
proof. by proc*; inline{2} 1; wp; call ROC_RO_get; auto => /> /#. qed.

local equiv Sim_get_eq :
  SIB.Sim(SIB.ROC.RO).get ~ SIB.Sim(ROCofRO(RO)).get :
  ={arg, glob SIB.Sim} /\ RO.m{2} = map (fun _ v => (v, Empty)) SIB.ROC.RO.m{1} ==>
  ={res, glob SIB.Sim} /\ RO.m{2} = map (fun _ v => (v, Empty)) SIB.ROC.RO.m{1}.
proof.
by sim (SIB.ROC.RO.get ~ ROCofRO(RO).get : true)
       / (RO.m{2} = map (fun _ v => (v, Empty)) SIB.ROC.RO.m{1}) : (={res, glob SIB.Sim});
  apply ROC_ROCofRO_get.
qed.

(* Signing with the scheme on top of [ToC(ROC)] is signing with the simplified
   scheme, up to the conversion of the signature and the leakage of [t0]. *)
local equiv sign_conv (sk0 : SK) :
  DilithiumR(SIB.ToC(SIB.ROC.RO)).sign ~ DilithiumS(RO).sign :
  ={sk, m} /\ sk{2} = sk0 /\ RO.m{2} = map (fun _ v => (v, Empty)) SIB.ROC.RO.m{1} ==>
  res{1} = conv_sigl (sk0.`1, sk0.`1 *^ sk0.`2 + sk0.`3) res{2} /\
  RO.m{2} = map (fun _ v => (v, Empty)) SIB.ROC.RO.m{1}.
proof.
proc; sp.
while (={response, ctr, mA, s1, s2, t0, m, r0_fail, hint_fail} /\
       RO.m{2} = map (fun _ v => (v, Empty)) SIB.ROC.RO.m{1} /\
       leak{1} = lcat (t0_leak t0{2}) leak{2} /\
       (response{2} <> None => c{1} = to_c c{2})).
- inline{1} SIB.ToC(SIB.ROC.RO).get.
  seq 6 4 : (#pre /\ ={y, w, w1} /\ c{1} = to_c c{2} /\ lc{2} = Empty /\
             lc{1} = SIB.full_leak c{2}.`1 (SIB.leakage_to_rej c{2}.`2)).
  + by wp; call ROC_RO_get; auto => />.
  auto => /> &2; rewrite !catFSE !cat0s /resp_leak.
  move: (check_z _) (check_r0 _) (check_ct0 _) (check_hint _) => zf rf cf hf.
  by case: zf => [|i] /=; [case: rf => [|j] /= |]; case: cf; rewrite ?catA ?cats0.
auto => /> &2 cL cR ctr lR r _ _ hc.
by rewrite /conv_sigl /=; case: r hc => [|r] //= ->.
qed.

lemma pr_xof_ro &m :
  Pr [EF_CMA_XOF(DilithiumXOF, A, XOF, O_CMA_XOF).main() @ &m : res ] =
  Pr [EF_CMA_RO(DilithiumS, RedXOF(A), RO, O_CMA_Default).main() @ &m : res ].
proof.
(* The base game is the real game of [SampleInBallEquiv] against [XOFAdv(A)] *)
have -> : Pr[EF_CMA_XOF(DilithiumXOF, A, XOF, O_CMA_XOF).main() @ &m : res]
        = Pr[SIB.GameReal(XOFAdv(A)).main() @ &m : res].
- by byequiv => //; proc; inline{2} 2; wp; sim.
(* Core argument: simulate the XOF from the challenge oracle *)
have -> : Pr[SIB.GameReal(XOFAdv(A)).main() @ &m : res]
        = Pr[SIB.GameROC(SIB.ORedXOFROC(XOFAdv(A))).main() @ &m : res].
- by byequiv (SIB.adv_xof_roc (XOFAdv(A))).
(* The ideal game is the EF-CMA game against [RedXOF(A)], up to the
   position of the simulator initialization, the counting wrappers and the
   conversions of signatures, leakages and of the forgery *)
byequiv => //; proc.
inline{1} SIB.ORedXOFROC(XOFAdv(A), SIB.ROC.RO).run XOFAdv(A, SIB.Sim(SIB.ROC.RO), SIB.ToC(SIB.ROC.RO)).run.
inline{1} DSSXOF.EFCMA.EF_CMA(DilithiumR(SIB.ToC(SIB.ROC.RO)), A(SIB.Sim(SIB.ROC.RO)), O_CMA_XOF).main.
inline{2} EF_CMA(DilithiumS(RO), RedXOF(A, RO), O_CMA_Default).main.
inline{2} RedXOF(A, RO, O_CMA_Default(DilithiumS(RO))).forge.
swap{2} 9 -7.
seq 6 9 : (={pk, sk, glob A, glob SIB.Sim} /\ pk0{2} = pk{2} /\ RO.m{2} = map (fun _ v => (v, Empty)) SIB.ROC.RO.m{1} /\
           O_CMA_XOF.sk{1} = O_CMA_Default.sk{2} /\ O_CMA_XOF.qs{1} = O_CMA_Default.qs{2} /\
           OConv.pk{2} = (O_CMA_Default.sk.`1, O_CMA_Default.sk.`1 *^ O_CMA_Default.sk.`2 + O_CMA_Default.sk.`3){2}).
+ by inline *; auto => />; rewrite map_empty.
(* the adversary, in lockstep *)
seq 1 1 : (={pk, glob A} /\ m{1} = m0{2} /\ sig{1} = sig0{2} /\ pk0{2} = pk{2} /\
           RO.m{2} = map (fun _ v => (v, Empty)) SIB.ROC.RO.m{1} /\
           O_CMA_XOF.sk{1} = O_CMA_Default.sk{2} /\ O_CMA_XOF.qs{1} = O_CMA_Default.qs{2}).
+ call (: RO.m{2} = map (fun _ v => (v, Empty)) SIB.ROC.RO.m{1} /\ ={glob SIB.Sim} /\
          O_CMA_XOF.sk{1} = O_CMA_Default.sk{2} /\ O_CMA_XOF.qs{1} = O_CMA_Default.qs{2} /\
          OConv.pk{2} = (O_CMA_Default.sk.`1, O_CMA_Default.sk.`1 *^ O_CMA_Default.sk.`2 + O_CMA_Default.sk.`3){2}).
  - (* signing oracle *)
    proc; inline{2} CountSX(OConv(O_CMA_Default(DilithiumS(RO)))).sign
                    OConv(O_CMA_Default(DilithiumS(RO))).sign O_CMA_Default(DilithiumS(RO)).sign; wp.
    by exlim O_CMA_Default.sk{2} => sk0; call (sign_conv sk0); auto.
  - (* XOF oracle *)
    proc*; inline{2} CountX(SIB.Sim(ROCofRO(RO))).get; wp.
    by call Sim_get_eq; auto.
  by auto.
(* verification of the forgery and its conversion: the query on the
   recovered commitment is the query of the verification of the forgery *)
inline{1} DilithiumR(SIB.ToC(SIB.ROC.RO)).verify SIB.ToC(SIB.ROC.RO).get.
inline{2} DilithiumS(RO).verify.
seq 10 3 : (pk0{1} = pk{2} /\ pk0{2} = pk{2} /\ m0{1} = m0{2} /\ m{1} = m0{2} /\ c{1} = c{2} /\
            (z, h){1} = zh{2} /\ w1{1} = w1{2} /\ w1{2} = recover_r pk{2} c{2} zh{2} /\
            cl{2} = ((ir, l){1}, Empty) /\ RO.m{2} = map (fun _ v => (v, Empty)) SIB.ROC.RO.m{1} /\ RO.m{2}.[(w1{2}, m0{2})] = Some cl{2} /\
            O_CMA_XOF.sk{1} = O_CMA_Default.sk{2} /\ O_CMA_XOF.qs{1} = O_CMA_Default.qs{2} /\
            (mA, t){1} = pk{2} /\ t1{1} = base2highbitsV t{1}).
+ sp; exlim x2{1} => x0; call (ROC_RO_get_in x0); auto => /> &1 &2.
  by rewrite /recover_r /= => -[].
inline *.
case: (to_c cl{2}.`1 = c{2}).
+ (* valid conversion: the verification query is answered by the table *)
  rcondf{2} ^if.
  - by move=> &1; auto => />; rewrite /recover_r /= domE => ->.
  auto => />.
  by move=> &1 &2; rewrite /recover_r /= => -> /= _ _; rewrite /to_c.
(* invalid conversion: both verifications fail *)
auto => /> &1 &2 _ hne r _.
have hz : size bad_sig.`2.`1 = 0 by rewrite /bad_sig.
have hb : size bad_sig.`2.`1 <> Params.l by rewrite hz; smt(Params.gt0_l).
have hc : c{2} <> to_concrete (SIB.to_challenge ir{1}) by move: hne; rewrite /to_c eq_sym.
by rewrite hb hc.
qed.

(*** Main theorem for the scheme with an ideal XOF ***)

(* Note: [A] makes at most [qH - 1] (distinct) queries to the XOF
   ([A_bound]). *)
lemma DilithiumXOF_secure &m :
  Pr [EF_CMA_XOF(DilithiumXOF, A, XOF, O_CMA_XOF).main() @ &m : res ] <=
    `|Pr[GameL(RedMLWE(RedNMA(RedXOF(A)), RO)).main() @ &m : res] -
      Pr[GameR(RedMLWE(RedNMA(RedXOF(A)), RO)).main() @ &m : res]|
  + Pr[RqStMSIS.Std.Game(RqStMSIS.RedStd(FiberSamplerRej, RedMSIS(RedNMA(RedXOF(A)))), RqStMSIS.Std.PRO.RO).main() @ &m : res]
  + ((Mz + Mr0 + Mhint + 2)%r * qS%r * (qH + qS + 1)%r * eps_comm / (1%r - p_rej) +
     qS%r * eps_comm * (qS%r + 1%r) / (2%r * (1%r - p_rej) ^ 2))
  + eps_check.
proof.
rewrite pr_xof_ro.
exact (DilithiumS_secure (RedXOF(A)) RedA_bound RedA_ll &m).
qed.

end section XOF.
