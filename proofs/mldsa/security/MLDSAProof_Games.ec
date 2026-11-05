require import AllCore Distr List IntDiv FSet FMap Leakage Byte Finite.
require import StdOrder.
import RealOrder.
require PROM.
require MLDSATarget SimplifiedScheme ExpandAEquiv.

(** Security of [MLDSATarget] by reduction to [SimplifiedScheme]
    (theorem [DilithiumXOF_secure]): the clones, the games and the
    reduction. The proof follows the sequence of games of
    [doc/proof_overview.tex], one file per hop, each file an abstract theory
    which includes ([clone include]) the previous one:
    - MLDSAProof_Games.ec       (this file) the clones of MLDSATarget ([T]),
                                SimplifiedScheme ([SD]) and ExpandAEquiv
                                ([EA]), the signing procedure [MLDSAGen] of
                                all the games, the games G1 and G2, the
                                reduction [RedMLDSA], the collision bounds,
                                the termination of the simulated oracles;
    - MLDSAProof_ExpandA.ec     G0 -> G1 ([hop_expandA]);
    - MLDSAProof_Collisions.ec  G1 -> G2 ([hop_collisions]);
    - MLDSAProof_Reduction.ec   G2 -> G3 ([hop_reduction], query bound and
                                termination of the reduction);
    - MLDSAProof.ec             the final theorem [MLDSA_secure].
    The games:
    - G0  [EF_CMA_MLDSA(A)] (MLDSATarget), the real scheme; its signing
          procedure is [MLDSAGen(ExpandA(XA), ChalH(XC, Hct), Hmu)]
          ([sign_G0], MLDSAProof_ExpandA);
    - G1  [G1(A)]: the matrix A is sampled uniformly ([MatRA]) and the XOF
          of ExpandA is simulated by [XASim];
    - G2  [G2(A)]: the challenge is computed from the XOF of
          SimplifiedScheme indexed by [(w1, mu)] ([ChalX]), [c~ = Hct(w1, mu)]
          only for the accepted iteration, the challenge XOF [XC] is
          simulated from the XOF of SimplifiedScheme ([XCSim]) and the hash
          collisions are flagged ([HctT.bad], [HmuB.bad]);
    - G3  [SD.EF_CMA_XOF(SD.DilithiumXOF, RedMLDSA(A), SD.XOF, SD.O_CMA_XOF)]
          (SimplifiedScheme, real-format scheme [DilithiumR] over
          [SampleInBall], ring challenges and fine SampleInBall leakage),
          which simulates G2 exactly as long as no collision is flagged. *)

abstract theory MLDSAProof_Games.

clone import MLDSATarget.MLDSATarget as T.
import Params DR DV DV.MatRq DV.HL.

(* -------------------------------------------------------------------- *)
(* Parameters of the security proof of SimplifiedScheme                 *)
(* -------------------------------------------------------------------- *)

op dA = dmatrix dRq k l.
op dy = dvector dRq_mask l.
op dz = dvector (dRq_ (gamma1 - beta_ - 1)) l.

(* The check on the matrix: entropy of the commitments and success of the
   signing loop (see SimplifiedScheme) *)
op check_mx : matrix -> bool.
axiom check_valid A : check_mx A => A \in dA.

op A0 : { matrix | check_mx A0 } as A0P.

const eps_comm : { real | 0%r < eps_comm } as eps_comm_gt0.
axiom check_mx_entropy :
  E (dcond dA check_mx) (fun mA =>
    p_max (dmap dy (fun y => highBitsV (mA *^ y)))) <= eps_comm.

const eps_check : { real | 0%r <= eps_check } as eps_check_gt0.
axiom check_mx_most : mu dA (predC check_mx) <= eps_check.

const eps_low : { real | eps_low < 1%r } as eps_low_lt1.
axiom bound_low (t : vector) (mA : matrix) :
  t \in dvector dRq k => check_mx mA =>
  let t0 = base2lowbitsV t in
  mu ((dC tau) `*` dz) (fun (cz : _*_) =>
      (gamma2 - beta_ <= inf_normv (lowBitsV (mA *^ cz.`2 - cz.`1 ** t))) \/
  ! (inf_normv (cz.`1 ** t0) < gamma2 /\
     check_hw (makeHintV (- cz.`1 ** t0) (mA *^ cz.`2 - cz.`1 ** t + cz.`1 ** t0)))) <= eps_low.

(* [to_concrete_inj_in] (injectivity of [to_concrete] on valid challenge
   encodings) is an assumption of [MLDSATarget]. *)

(* The challenge distribution of the ring is the distribution of the
   challenges computed by SampleInBall (an assumption of SimplifiedScheme,
   proved for the concrete ring in [ConcreteMLDSA]). *)
axiom dC_equiv : dC tau = SIB.dC.

(* The masking distribution *)
lemma dmask_fin : is_finite (support dRq_mask).
proof. by apply (finite_leq predT) => //; exact is_finite_Rq. qed.

(* XOF queries: the reduction makes one per distinct [c~] queried by A, plus
   one for the forgery, i.e. at most [qXC + 1 = qH - 1] (the conversion of
   the forgery in SimplifiedScheme makes one more) *)
lemma qH_ge0 : 0 <= qXC + 2 by smt(qXC_ge0).

clone SimplifiedScheme as SD with
  theory Params <- Params,
  theory DR <- DR,
  theory DV <- DV,
  type M <- mu_t,

  op dmask <- dRq_mask,
  op to_concrete <- to_concrete,
  op Rq_enc <- ofRq,
  op kappa <- kappa_max,
  op check_z <- check_z,
  op check_r0 <- check_r0,
  op check_hint <- check_hint,
  op check_ct0 <- check_ct0,
  op Mz <- Mz,
  op Mr0 <- Mr0,
  op Mhint <- Mhint,
  op check_mx <- check_mx,
  op eps_comm <- eps_comm,
  op eps_check <- eps_check,
  op eps_low <- eps_low,
  op A0 <- A0,
  op qS <- qS,
  op qH <- qXC + 2,

  axiom dmask_ll <- dRq_mask_ll,
  axiom dmask_uni <- dRq_mask_uni,
  axiom dmask_fin <- dmask_fin,
  axiom dmask_supp <- dRq_mask_supp_box,
  axiom to_concrete_inj_in <- to_concrete_inj_in,
  axiom dC_equiv <- dC_equiv,
  axiom gt0_kappa <- gt0_kappa_max,
  axiom eps_comm_gt0 <- eps_comm_gt0,
  axiom eps_check_gt0 <- eps_check_gt0,
  axiom check_mx_entropy <- check_mx_entropy,
  axiom bound_low <- bound_low,
  axiom eps_low_lt1 <- eps_low_lt1,
  axiom check_mx_most <- check_mx_most,
  axiom check_valid <- check_valid,
  axiom ge0_Mz <- ge0_Mz,
  axiom ge0_Mr0 <- ge0_Mr0,
  axiom ge0_Mhint <- ge0_Mhint,
  axiom check_z_range <- check_z_range,
  axiom check_r0_range <- check_r0_range,
  axiom check_hint_range <- check_hint_range,
  axiom check_z_None <- check_z_None,
  axiom check_r0_None <- check_r0_None,
  axiom check_ct0_None <- check_ct0_None,
  axiom check_z_shift <- check_z_shift,
  axiom A0P <- A0P,
  axiom qS_ge0 <- qS_ge0,
  axiom qH_ge0 <- qH_ge0
proof* by smt(gt0_eta gt0_k gt0_l gamma2_bound gamma2_div gt0_beta beta_gamma1_lt
              beta_gamma2_lt gt0_d tau_bound eta_tau_leq_b pow2_d_lt_q).

(* [dC_equiv], stated on the SampleInBall theory of SimplifiedScheme *)
lemma dC_equiv_SD : dC tau = SD.SIB.dC by exact dC_equiv.

(* ExpandA in the random oracle model (Flux C). ExpandAEquiv.eca wraps its
   content in an inner abstract theory, which is only reachable through a
   clone of the file. *)
clone ExpandAEquiv as EAF.
clone EAF.ExpandAEquiv as EA with
  theory Params <- Params,
  theory DR <- DR,
  type seed <- seed,
  op toRq <- toRq,
  op ofRq <- ofRq,
  axiom toRqK <- toRqK,
  axiom ofRqK <- ofRqK,
  axiom ofRq_valid <- ofRq_valid,
  axiom q_le_2_23 <- q_le_2_23.
(* -------------------------------------------------------------------- *)
(* The signing loop, generic in the matrix and in the challenge         *)
(* -------------------------------------------------------------------- *)

(* How the signer obtains the matrix from the seed [rho] *)
module type MatGen = {
  proc get(rho : seed) : matrix
}.

(* How the signer obtains the challenge: [get(w1, mu)] is called at every
   iteration and returns [(c~, c, lc)] ([lc] is the leakage of
   SampleInBall); [final(w1, mu, c~)] is called once after the loop, when
   an iteration was accepted, with the [(w1, mu, c~)] of that iteration,
   and returns the [c~] of the signature. The games G2 and later compute
   [c] from [(w1, mu)] and [c~] in [final] only: the [c~] of the rejected
   iterations are never sampled (see [bound_ct]). *)
module type ChalGen = {
  proc get(w1 : high list, mu : mu_t) : ctilde * Rq * leakage
  proc final(w1 : high list, mu : mu_t, ct : ctilde) : ctilde
}.

(* The signing procedure of every game. The loop is the one of [MLDSA]
   written with a guard on the counter only (the body is skipped once a
   response is found), so that two instances run in lockstep even when
   their responses differ (up-to-bad step of hop_collisions); [sign_G0]
   (MLDSAProof_ExpandA) relates it to [MLDSA.sign]. *)
module MLDSAGen (MG : MatGen, CG : ChalGen, Hmu : Hash_mu) = {
  proc sign(sk : SK, m : M) : Sig option * leakage = {
    var z : vector;
    var h : hint_t list;
    var response : response_t option;
    var c : Rq;
    var ct : ctilde;
    var ctr : int;
    var rho, tr, s1, s2, t0, mA, mu, y, w, w0, w1;
    var lc, leak;
    var ct0_ok : bool;
    var z_fail, r0_fail, hint_fail : int option;
    ct <- witness;
    w1 <- witness;
    r0_fail <- witness;
    hint_fail <- witness;

    (rho, tr, s1, s2, t0) <- sk;
    leak <- t0_leak t0;
    mA <@ MG.get(rho);
    mu <@ Hmu.get(tr, m);

    response <- None;
    ctr <- 0;
    while (ctr < kappa_max) {
      if (response = None) {
        y  <$ dvector dRq_mask l;
        w  <- mA *^ y;
        w1 <- highBitsV w;
        (ct, c, lc) <@ CG.get(w1, mu);
        leak <- lcat leak lc;
        leak <- lcat leak (c_leak c);
        z  <- y + c ** s1;
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
      }
      ctr  <- ctr + 1;
    }
    if (response <> None) {
      ct <@ CG.final(w1, mu, ct);
    }
    return (omap (fun r => (ct, r)) response, leak);
  }
}.

(* The challenge of MLDSATarget: [c~ = Hct(w1, mu)] and SampleInBall over
   the XOF [XC] on [c~] *)
module ChalH (XC : SIB.XOF_t, Hct : Hash_ct) : ChalGen = {
  proc get(w1 : high list, mu : mu_t) : ctilde * Rq * leakage = {
    var ct, c, lc;
    ct <@ Hct.get(w1, mu);
    (c, lc) <@ SIB.SampleInBall(XC).get(ct);
    return (ct, c, lc);
  }

  proc final(w1 : high list, mu : mu_t, ct : ctilde) : ctilde = {
    return ct;
  }
}.


(* -------------------------------------------------------------------- *)
(* G1: explicit matrix, simulated ExpandA XOF                           *)
(* -------------------------------------------------------------------- *)

(* Ideal sampler of the ExpandA simulator: the entries [(rho, r, s)] of the
   honest matrix (honest [rho], [0 <= r < k], [0 <= s < l]) are answered with
   [mA.[r, s]], all other inputs by a local lazy random oracle over [dRq].
   [rho] and [mA] are set by the game (or the reduction) after key
   generation. *)
module RA : EA.RS.Sampler_t = {
  var rho : seed
  var mA  : matrix
  var m   : (seed * int * int, Rq) fmap

  proc init() : unit = {
    m <- empty;
  }

  proc sample(x : seed * int * int) : Rq = {
    var r;
    if (x.`1 = rho /\ 0 <= x.`2 < k /\ 0 <= x.`3 < l) {
      r <- mA.[x.`2, x.`3];
    } else {
      if (x \notin m) {
        r <$ dRq;
        m.[x] <- r;
      }
      r <- oget m.[x];
    }
    return r;
  }
}.

(* The simulated XOF of ExpandA (see [EA.ExpandA_sim]). [XASim.init] does not
   initialize [RA]: [RA.init] has to be called too. *)
module XASim = EA.RS.Sim(EA.ReprogRq, RA).

(* The matrix of the games G1 and G2 (set by the game after key
   generation) *)
module MatRA : MatGen = {
  proc get(rho : seed) : matrix = {
    return RA.mA;
  }
}.

(* Key generation and verification when [mA] is sampled uniformly instead
   of being expanded from [rho]: the secret key carries the matrix, and
   [verify] takes the honest matrix as an extra argument (the game passes
   the one of the secret key; [verify] is only called on the honest public
   key). *)
type SK1 = matrix * SK.

module MLDSA1 (XC : SIB.XOF_t, Htr : Hash_tr, Hmu : Hash_mu, Hct : Hash_ct) = {
  proc keygen() : PK * SK1 = {
    var rho, mA, s1, s2, t, pk, tr;
    rho <$ dseed;
    mA  <$ dmatrix dRq k l;
    s1  <$ dvector (dRq_ eta_) l;
    s2  <$ dvector (dRq_ eta_) k;
    t   <- mA *^ s1 + s2;
    pk  <- (rho, base2highbitsV t);
    tr  <@ Htr.get(pk);
    return (pk, (mA, (rho, tr, s1, s2, base2lowbitsV t)));
  }

  proc verify(mA : matrix, pk : PK, m : M, sig : Sig) : bool = {
    var rho, t1, ct, ct', response, z, h, tr, mu, c, lc, w1;
    (rho, t1) <- pk;
    (ct, response) <- sig;
    (z, h) <- response;
    tr <@ Htr.get(pk);
    mu <@ Hmu.get(tr, m);
    (c, lc) <@ SIB.SampleInBall(XC).get(ct);
    w1 <- useHintV h (mA *^ z - c ** base2shiftV t1);
    ct' <@ Hct.get(w1, mu);
    return size z = l /\ size h = k /\ inf_normv z < gamma1 - beta_ /\ ct = ct';
  }
}.

module type Signer = {
  proc sign(sk : SK, m : M) : Sig option * leakage
}.

(* Signing oracle of the games *)
module O_CMA1 (S : Signer) = {
  var sk : SK
  var qs : M list

  proc init(sk_init : SK) : unit = {
    sk <- sk_init;
    qs <- [];
  }

  proc sign(m : M) : Sig option * leakage = {
    var r;
    r <@ S.sign(sk, m);
    qs <- rcons qs m;
    return r;
  }

  proc fresh(m : M) : bool = {
    return ! (m \in qs);
  }

  proc nr_queries() : int = {
    return size qs;
  }
}.

module G1 (A : Adv_EFCMA) = {
  module S = MLDSA1(SIB.XOF.RO, ROtr.RO, ROmu.RO, ROct.RO)
  module O = O_CMA1(MLDSAGen(MatRA, ChalH(SIB.XOF.RO, ROct.RO), ROmu.RO))

  proc main() : bool = {
    var pk, sk, m, sig, nrqs;
    var is_valid, is_fresh;

    XASim.init();
    RA.init();
    SIB.XOF.RO.init();
    ROtr.RO.init();
    ROmu.RO.init();
    ROct.RO.init();
    (pk, sk) <@ S.keygen();
    RA.rho <- pk.`1;
    RA.mA  <- sk.`1;
    O.init(sk.`2);
    (m, sig) <@ A(XASim, SIB.XOF.RO, ROtr.RO, ROmu.RO, ROct.RO, O).forge(pk);
    is_valid <@ S.verify(sk.`1, pk, m, sig);
    is_fresh <@ O.fresh(m);
    nrqs <@ O.nr_queries();
    return nrqs <= qS /\ is_valid /\ is_fresh;
  }
}.

(* -------------------------------------------------------------------- *)
(* G2: challenge XOF indexed by (w1, mu), collisions flagged            *)
(* -------------------------------------------------------------------- *)

(* Local random oracle for the queries [XC(c~, i)] where [c~] is not (yet) an
   output of [Hct] *)
clone PROM.FullRO as LX with
  type in_t  <- ctilde * int,
  type out_t <- byte,
  op   dout  <- fun _ => dB.

(* Lazy table for [Hct] (WPD2). [tinv] is the inverse table: it maps an output
   [c~] to the first input that produced it, it is never overwritten (so that
   [XCSim] answers all the queries on a given [c~] from the same XOF entry).
   [bad] is set when a fresh output is already an output of [Hct] or has
   already been queried to the local XOF [LX]. *)
module HctT : Hash_ct = {
  var t    : (high list * mu_t, ctilde) fmap
  var tinv : (ctilde, high list * mu_t) fmap
  var bad  : bool

  proc init() : unit = {
    t    <- empty;
    tinv <- empty;
    bad  <- false;
  }

  proc get(x : high list * mu_t) : ctilde = {
    var ct;
    if (x \notin t) {
      ct <$ dct;
      bad <- bad \/ ct \in tinv \/ (exists i, (ct, i) \in LX.RO.m);
      if (ct \notin tinv) {
        tinv.[ct] <- x;
      }
      t.[x] <- ct;
    }
    return oget t.[x];
  }
}.

(* Simulated challenge XOF: a query on an output [c~] of [Hct] is answered by
   the XOF [X] of SimplifiedScheme on its preimage, the other ones by [LX]. *)
module XCSim (X : SD.SIB.XOF_t) : SIB.XOF_t = {
  proc get(y : ctilde * int) : byte = {
    var r;
    if (y.`1 \in HctT.tinv) {
      r <@ X.get(oget HctT.tinv.[y.`1], y.`2);
    } else {
      r <@ LX.RO.get(y);
    }
    return r;
  }
}.

(* Lazy table for [Hmu] (WPD3). [bad] is set when a fresh output collides with
   a previous one. *)
module HmuB : Hash_mu = {
  var m   : (tr_t * M, mu_t) fmap
  var bad : bool

  proc init() : unit = {
    m   <- empty;
    bad <- false;
  }

  proc get(x : tr_t * M) : mu_t = {
    var mu;
    if (x \notin m) {
      mu <$ dmu;
      bad <- bad \/ mu \in frng m;
      m.[x] <- mu;
    }
    return oget m.[x];
  }
}.

(* The challenge of G2: [c] is computed directly from the XOF of
   SimplifiedScheme on [(w1, mu)] ([SD.SIB.SampleInBall(SD.XOF)], as
   [SD.DilithiumXOF] does); [c~ = Hct(w1, mu)] is only computed for the
   accepted iteration ([final]).
   DEVIATION from the plan (WPD2): the plan computes [c~] at every iteration
   and the challenge through [XCSim]. In that version the [c~] of the rejected
   iterations are in [HctT.tinv] in G2 but not in the reduction (which only
   sees the accepted iteration), so hop_reduction would not be an exact
   step; here this difference is moved to hop_collisions (where the rejected
   [c~] are never revealed to the adversary, hence the [kappa_max * qS] term of
   the collision bound). *)
module ChalX : ChalGen = {
  proc get(w1 : high list, mu : mu_t) : ctilde * Rq * leakage = {
    var c, lc;
    (c, lc) <@ SD.SIB.SampleInBall(SD.XOF).get(w1, mu);
    return (witness, c, lc);
  }

  proc final(w1 : high list, mu : mu_t, ct : ctilde) : ctilde = {
    var ct';
    ct' <@ HctT.get(w1, mu);
    return ct';
  }
}.

(* G2: [keygen] and [verify] are the ones of G1 with the simulated oracles *)
module G2 (A : Adv_EFCMA) = {
  module XC = XCSim(SD.XOF)
  module S  = MLDSA1(XC, ROtr.RO, HmuB, HctT)
  module O  = O_CMA1(MLDSAGen(MatRA, ChalX, HmuB))

  proc main() : bool = {
    var pk, sk, m, sig, nrqs;
    var is_valid, is_fresh;

    XASim.init();
    RA.init();
    SD.XOF.init();
    LX.RO.init();
    HctT.init();
    ROtr.RO.init();
    HmuB.init();
    (pk, sk) <@ S.keygen();
    RA.rho <- pk.`1;
    RA.mA  <- sk.`1;
    O.init(sk.`2);
    (m, sig) <@ A(XASim, XC, ROtr.RO, HmuB, HctT, O).forge(pk);
    is_valid <@ S.verify(sk.`1, pk, m, sig);
    is_fresh <@ O.fresh(m);
    nrqs <@ O.nr_queries();
    return nrqs <= qS /\ is_valid /\ is_fresh;
  }
}.

(* -------------------------------------------------------------------- *)
(* The reduction to SimplifiedScheme                                    *)
(* -------------------------------------------------------------------- *)

(* State of the reduction *)
module RedSt = {
  var t1 : high2 list
  var tr : tr_t
}.

(* Simulated signing oracle: the message is hashed with [Hmu], the signature
   [(c, (z, h))] returned by SimplifiedScheme is translated into
   [(c~, (z, h))] with [c~ = Hct(w1, mu)], where [w1] is recovered from the
   signature. The leakage is returned unchanged: the signing loop of
   [SD.DilithiumR] leaks [t0_leak t0] and then appends, with [lcat], the same
   items in the same order as the loop of [MLDSAGen(MatRA, ChalX, HmuB)]. *)
module SignRed (O : SD.DSSXOF.DS.Stateless.SOracle_CMA) : SOracle_CMA = {
  proc sign(m : M) : Sig option * leakage = {
    var mu, so, lk, c, zh, z, h, w1, ct, r;
    mu <@ HmuB.get(RedSt.tr, m);
    (so, lk) <@ O.sign(mu);
    r <- None;
    if (so <> None) {
      (c, zh) <- oget so;
      (z, h) <- zh;
      w1 <- useHintV h (RA.mA *^ z - c ** base2shiftV RedSt.t1);
      ct <@ HctT.get(w1, mu);
      r <- Some (ct, zh);
    }
    return (r, lk);
  }
}.

(* The forgery [(m, (c~, (z, h)))] is translated into [(mu, (c, (z, h)))] with
   [mu = Hmu(tr, m)] and [c] computed from the XOF on the preimage [(w1, mu)]
   of [c~] by [Hct] (when [c~] has one, otherwise [witness] is returned).
   DEVIATION from the plan: the reduction checks that the preimage of [c~] is
   [(w1, mu)] (with [w1] recovered from [c]) instead of querying
   [Hct(w1, mu)]; this way it makes a single XOF query for the forgery, so
   that its query bound is [qXC + 1].
   The counting wrappers of MLDSATarget around the oracles given to [A] do
   not change the behaviour of the reduction: they are only there so that
   the query bound of the reduction is a syntactic instance of [A_bound]
   (see [B_bound]; same trick as [SD.RedXOF] and [SD.RedA_bound]). *)
module (RedMLDSA (A : Adv_EFCMA) : SD.DSSXOF.Adv_EFCMA_RO)
       (X : SD.DSSXOF.Hash) (O : SD.DSSXOF.DS.Stateless.SOracle_CMA) = {
  proc forge(pk : SD.PK) : mu_t * SD.SigXOF = {
    var mA, t, rho, t1, tr, m, sig, ct, zh, z, h, mu, c, lc, w1, x, r;
    (mA, t) <- pk;
    rho <$ dseed;
    t1 <- base2highbitsV t;
    XASim.init();
    RA.init();
    RA.rho <- rho;
    RA.mA  <- mA;
    LX.RO.init();
    HctT.init();
    ROtr.RO.init();
    HmuB.init();
    tr <@ ROtr.RO.get((rho, t1));
    RedSt.t1 <- t1;
    RedSt.tr <- tr;
    CountXA.q <- 0;
    CountXC.q <- 0;
    CountXC.xs <- fset0;
    CountHtr.q <- 0;
    CountHmu.q <- 0;
    CountHct.q <- 0;
    CountS.q <- 0;
    (m, sig) <@ A(CountXA(XASim), CountXC(XCSim(X)), CountHtr(ROtr.RO),
                  CountHmu(HmuB), CountHct(HctT), CountS(SignRed(O))).forge((rho, t1));
    (ct, zh) <- sig;
    (z, h) <- zh;
    mu <@ HmuB.get(tr, m);
    r <- witness;
    if (ct \in HctT.tinv) {
      x <- oget HctT.tinv.[ct];
      (c, lc) <@ SD.SIB.SampleInBall(X).get(x);
      w1 <- useHintV h (mA *^ z - c ** base2shiftV t1);
      if ((w1, mu) = x) {
        r <- (mu, (c, zh));
      }
    }
    return r;
  }
}.

(* -------------------------------------------------------------------- *)
(* Collision bounds                                                     *)
(* -------------------------------------------------------------------- *)

(* [Hct]/[XC] (WPD2, TableCollision with dout = dct): at most
   [qHct + kappa_max * qS + 1] fresh samples (adversary queries, every
   iteration of every signing query, verification), each one compared with a
   set of size at most [qXC + 1 + (qHct + kappa_max * qS + 1)] (the [c~]
   queried to the local XOF [LX] by the adversary and by the verification,
   and the previous samples).
   NOTE: the plan has [qXC] instead of [qXC + 1] in the second factor; the
   [+ 1] accounts for the [LX] query of the verification. *)
op bound_ct = (qHct + kappa_max * qS + 1)%r *
              (qXC + 1 + qHct + kappa_max * qS + 1)%r * eps_ct.

(* [Hmu] (WPD3, TableCollision with dout = dmu, no [put]): at most
   [qHmu + qS + 1] fresh samples. *)
op bound_mu = (qHmu + qS + 1)%r ^ 2 * eps_mu.

(* -------------------------------------------------------------------- *)
(* Termination of the oracles of the games                             *)
(* -------------------------------------------------------------------- *)

section Termination.

(* Losslessness of SampleInBall over lazy random oracles, from
   [SampleIndices_ll] (same queries, same control flow). *)
local module WL = {
  proc run1(x : ctilde) = {
    var r;
    SIB.RR.F1.RO.m <- SIB.XOF.RO.m;
    r <@ SIB.SampleIndices(SIB.RR.F1.RO).sample(x);
  }

  proc run2(x : high list * mu_t) = {
    var r;
    SD.SIB.RR.F1.RO.m <- SD.DSSXOF.PRO.RO.m;
    r <@ SD.SIB.SampleIndices(SD.SIB.RR.F1.RO).sample(x);
  }

  proc run3(x : ctilde) = {
    var r, r';
    if (x \in HctT.tinv) {
      SD.SIB.RR.F1.RO.m <- SD.DSSXOF.PRO.RO.m;
      r <@ SD.SIB.SampleIndices(SD.SIB.RR.F1.RO).sample(oget HctT.tinv.[x]);
    } else {
      SIB.RR.F1.RO.m <- LX.RO.m;
      r' <@ SIB.SampleIndices(SIB.RR.F1.RO).sample(x);
    }
  }
}.

lemma SIB_ll : islossless SIB.SampleInBall(SIB.XOF.RO).get.
proof.
bypr => &m _.
have <- : Pr[WL.run1(x{m}) @ &m : true] = 1%r.
- byphoare => //; proc; call SIB.SampleIndices_ll; auto.
byequiv => //; proc *; inline *; wp.
while (={i, ctx} /\ x0{1} = x1{2} /\ SIB.XOF.RO.m{1} = SIB.RR.F1.RO.m{2}).
- wp; while (={i, j, ctx} /\ x0{1} = x1{2} /\ SIB.XOF.RO.m{1} = SIB.RR.F1.RO.m{2}); 1: by auto.
  by auto.
wp; while (={ctx} /\ x0{1} = x1{2} /\ SIB.XOF.RO.m{1} = SIB.RR.F1.RO.m{2}); 1: by auto.
by auto.
qed.

lemma SDSIB_ll : islossless SD.SIB.SampleInBall(SD.XOF).get.
proof.
bypr => &m _.
have <- : Pr[WL.run2(x{m}) @ &m : true] = 1%r.
- byphoare => //; proc; call SD.SIB.SampleIndices_ll; auto.
byequiv => //; proc *; inline *; wp.
while (={i, ctx} /\ x0{1} = x1{2} /\ SD.DSSXOF.PRO.RO.m{1} = SD.SIB.RR.F1.RO.m{2}).
- wp; while (={i, j, ctx} /\ x0{1} = x1{2} /\ SD.DSSXOF.PRO.RO.m{1} = SD.SIB.RR.F1.RO.m{2}); 1: by auto.
  by auto.
wp; while (={ctx} /\ x0{1} = x1{2} /\ SD.DSSXOF.PRO.RO.m{1} = SD.SIB.RR.F1.RO.m{2}); 1: by auto.
by auto.
qed.

lemma SIBX_ll : islossless SIB.SampleInBall(XCSim(SD.XOF)).get.
proof.
bypr => &m _.
have <- : Pr[WL.run3(x{m}) @ &m : true] = 1%r.
- byphoare => //; proc; if.
  + by call SD.SIB.SampleIndices_ll; auto.
  by call SIB.SampleIndices_ll; auto.
byequiv => //; proc *; inline WL.run3.
case (x{1} \in HctT.tinv{1}).
- rcondt{2} 2; 1: by auto.
  inline *; wp.
  while (={i, ctx} /\ x0{1} = x{2} /\ (x0 \in HctT.tinv){1} /\ x1{2} = oget HctT.tinv.[x0]{1} /\
         ={HctT.tinv} /\ SD.DSSXOF.PRO.RO.m{1} = SD.SIB.RR.F1.RO.m{2}).
  + wp; while (={i, j, ctx} /\ x0{1} = x{2} /\ (x0 \in HctT.tinv){1} /\ x1{2} = oget HctT.tinv.[x0]{1} /\
         ={HctT.tinv} /\ SD.DSSXOF.PRO.RO.m{1} = SD.SIB.RR.F1.RO.m{2}).
    * by rcondt{1} 2; auto.
    by auto.
  wp; while (={ctx} /\ x0{1} = x{2} /\ (x0 \in HctT.tinv){1} /\ x1{2} = oget HctT.tinv.[x0]{1} /\
         ={HctT.tinv} /\ SD.DSSXOF.PRO.RO.m{1} = SD.SIB.RR.F1.RO.m{2}).
  + by rcondt{1} 2; auto.
  by auto.
rcondf{2} 2; 1: by auto.
inline *; wp.
while (={i, ctx} /\ x0{1} = x{2} /\ (x0 \notin HctT.tinv){1} /\ x1{2} = x0{1} /\
       LX.RO.m{1} = SIB.RR.F1.RO.m{2}).
- wp; while (={i, j, ctx} /\ x0{1} = x{2} /\ (x0 \notin HctT.tinv){1} /\ x1{2} = x0{1} /\
       LX.RO.m{1} = SIB.RR.F1.RO.m{2}).
  + by rcondf{1} 2; auto.
  by auto.
wp; while (={ctx} /\ x0{1} = x{2} /\ (x0 \notin HctT.tinv){1} /\ x1{2} = x0{1} /\
       LX.RO.m{1} = SIB.RR.F1.RO.m{2}).
- by rcondf{1} 2; auto.
by auto.
qed.

local module OV = EA.RS.Sim(EA.ReprogRq, RA).Overlay.

lemma XASim_ll : islossless XASim.get.
proof.
proc; call (: true); 1: by auto => />; exact dB_ll.
inline 1; sp; if => //.
call (EA.RP_ll OV _); 1: by islossless.
inline *; auto => />.
by sp; if; [auto | sp; if; auto; smt(dRq_ll)].
qed.

end section Termination.

end MLDSAProof_Games.
