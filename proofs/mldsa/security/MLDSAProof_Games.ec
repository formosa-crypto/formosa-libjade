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
          of ExpandA is simulated by [XASim]; the leakage of ExpandA is the
          one of a run of ExpandA on [XASim];
    - G2  [G2(A)]: [Hct] and the challenge are computed from the random
          oracle of SimplifiedScheme indexed by [(w1, mu)] ([HctT], [ChalX]:
          [c~ = Hct(w1, mu)] and [SampleInBall] on [(w1, mu)], at every
          iteration), the challenge XOF [XC] is simulated from the same
          random oracle, from the streams consumed by the signer and from a
          local XOF ([XCSim]), and the hash collisions are flagged
          ([HctT.bad], [HmuB.bad]);
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

(* Queries to the random oracle of SimplifiedScheme: the reduction queries
   it on at most one new point [(w1, mu)] per [Hct] query of A (the byte
   queries and the forgery are on points already queried to [Hct]), i.e. on
   at most [qHct <= qH - 1] points (the conversion of the forgery in
   SimplifiedScheme makes one more) *)
lemma qH_ge0 : 0 <= qHct + 2 by smt(qHct_ge0).

clone SimplifiedScheme as SD with
  theory Params <- Params,
  theory DR <- DR,
  theory DV <- DV,
  type M <- mu_t,
  type ctilde <- ctilde,

  op dct <- dct,
  op ct_enc <- ct_enc,
  op ct_dec <- ct_dec,

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
  op qH <- qHct + 2,

  axiom dct_ll <- dct_ll,
  axiom ct_encK <- ct_encK,
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

(* How the signer obtains the matrix from the seed [rho], with the leakage
   of ExpandA (the candidates read on the XOF of ExpandA) *)
module type MatGen = {
  proc get(rho : seed) : matrix * leakage
}.

(* How the signer obtains the challenge: [get(w1, mu)] is called at every
   iteration and returns [(c~, c, lc)] ([lc] is the leakage of
   SampleInBall); [c~] is leaked at every iteration, and the [c~] of the
   accepted iteration is the one of the signature. *)
module type ChalGen = {
  proc get(w1 : high list, mu : mu_t) : ctilde * Rq * leakage
}.

(* The signing procedure of every game. The loop is the one of [MLDSA]
   written with a guard on the counter only (the body is skipped once a
   response is found), so that two instances run in lockstep even when
   their responses differ (up-to-bad step of hop_collisions); [sign_G0]
   (MLDSAProof_ExpandA) relates it to [MLDSA.sign]. The leakage of [rho]
   and of ExpandA, the first items of the trace, is prepended at the end:
   the variable [leak] is then the trace of [SD.DilithiumR] (from
   [t0_leak t0] on), which the reduction relays unchanged. *)
module MLDSAGen (MG : MatGen, CG : ChalGen, Hmu : Hash_mu) = {
  proc sign(sk : SK, m : M) : Sig option * leakage = {
    var z : vector;
    var h : hint_t list;
    var response : response_t option;
    var c : Rq;
    var ct : ctilde;
    var ctr : int;
    var rho, tr, s1, s2, t0, mA, la, mu, y, w, w0, w1;
    var lc, leak;
    var ct0_ok : bool;
    var z_fail, r0_fail, hint_fail : int option;
    ct <- witness;
    r0_fail <- witness;
    hint_fail <- witness;

    (rho, tr, s1, s2, t0) <- sk;
    (mA, la) <@ MG.get(rho);
    leak <- t0_leak t0;
    mu <@ Hmu.get(tr, m);

    response <- None;
    ctr <- 0;
    while (ctr < kappa_max) {
      if (response = None) {
        y  <$ dvector dRq_mask l;
        w  <- mA *^ y;
        w1 <- highBitsV w;
        (ct, c, lc) <@ CG.get(w1, mu);
        leak <- lcat leak (ct_leak ct);
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
    (* the leakage of [rho] and of ExpandA comes first *)
    return (omap (fun r => (ct, r)) response, lcat (lcat (rho_leak rho) la) leak);
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

(* The matrix of the games G1 and G2 and its seed (set by the game after
   key generation; the signer only signs with the honest key, so [rho] is
   [RA.rho]). The leakage of ExpandA is obtained by running ExpandA on the
   simulated XOF [XASim] (the one of the adversary), whose stream is
   consistent with [RA.mA]; its matrix is not used. *)
module MatRA : MatGen = {
  proc get(rho : seed) : matrix * leakage = {
    var mA, la;
    (mA, la) <@ ExpandA(XASim).get(RA.rho);
    return (RA.mA, la);
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
(* G2: Hct and challenge XOF from the random oracle of SimplifiedScheme  *)
(* -------------------------------------------------------------------- *)

(* Local random oracle for the queries [XC(c~, i)] which are not answered
   from the random oracle of SimplifiedScheme *)
clone PROM.FullRO as LX with
  type in_t  <- ctilde * int,
  type out_t <- byte,
  op   dout  <- fun _ => dB.

(* [c~] is an output of the commitment hash part of the random oracle [m]
   of SimplifiedScheme *)
op hrng (m : (SD.xin, SD.xout) fmap) (ct : ctilde) =
  exists x, m.[SD.XH x] = Some (SD.OH ct).

(* [Hct] (WPD2) is the commitment hash part ([XH] queries) of the random
   oracle [SD.XOF] of SimplifiedScheme. [sample] is the query of the signer,
   [get] the query of the adversary (and of the verification), which also
   records [c~] in the inverse table [tinv]: [tinv] maps an output [c~] of
   [get] to the first input that produced it, it is never overwritten (so
   that [XCSim] answers all the queries on a given [c~] from the same XOF
   entry). The [c~] of the signer are not recorded in [tinv] (the reduction
   does not know the [w1] of a rejected iteration); instead, [leakT] maps
   them to the byte stream that the signer consumed on their XOF, which the
   reduction can decode from the leakage. [bad] is set when a fresh output
   is already an output of [Hct] or has already been queried to the local
   XOF [LX]. *)
module HctT : Hash_ct = {
  var tinv  : (ctilde, high list * mu_t) fmap
  var leakT : (ctilde, byte list) fmap
  var bad   : bool

  proc init() : unit = {
    tinv  <- empty;
    leakT <- empty;
    bad   <- false;
  }

  proc sample(x : high list * mu_t) : ctilde = {
    var m0, r;
    m0 <- SD.XOF.m;
    r <@ SD.XOF.get(SD.XH x);
    if (SD.XH x \notin m0) {
      bad <- bad \/ hrng m0 (SD.oh r) \/ (exists i, (SD.oh r, i) \in LX.RO.m);
    }
    return SD.oh r;
  }

  proc get(x : high list * mu_t) : ctilde = {
    var ct;
    ct <@ sample(x);
    if (ct \notin tinv) {
      tinv.[ct] <- x;
    }
    return ct;
  }
}.

(* [HctT.get] without the bad event, over the random oracle [X] of
   SimplifiedScheme (the commitment hash of the reduction) *)
module HctX (X : SD.DSSXOF.Hash) : Hash_ct = {
  proc get(x : high list * mu_t) : ctilde = {
    var r, ct;
    r <@ X.get(SD.XH x);
    ct <- SD.oh r;
    if (ct \notin HctT.tinv) {
      HctT.tinv.[ct] <- x;
    }
    return ct;
  }
}.

(* Simulated challenge XOF, over the random oracle [X] of SimplifiedScheme.
   A query [(c~, i)] is answered, in this order:
   1. from [LX] if it was already answered by [LX];
   2. from the stream consumed by the signer on [c~], if [c~] is a [c~] of
      the signer and [i] a position of the stream;
   3. by the XOF of SimplifiedScheme on [(tinv.[c~], i)] if [c~] is an
      output of [Hct] for the adversary;
   4. by [LX] otherwise (in particular for the positions beyond the consumed
      stream of a [c~] of the signer: they are only read through [XCSim]). *)
module XCSim (X : SD.DSSXOF.Hash) : SIB.XOF_t = {
  proc get(y : ctilde * int) : byte = {
    var r, o;
    if (y \in LX.RO.m) {
      r <@ LX.RO.get(y);
    } else {
      if (y.`1 \in HctT.leakT /\ 0 <= y.`2 < size (oget HctT.leakT.[y.`1])) {
        r <- nth witness (oget HctT.leakT.[y.`1]) y.`2;
      } else {
        if (y.`1 \in HctT.tinv) {
          o <@ X.get(SD.XB (oget HctT.tinv.[y.`1], y.`2));
          r <- SD.ob o;
        } else {
          r <@ LX.RO.get(y);
        }
      }
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

(* The challenge of G2, at every iteration: [c~ = Hct(w1, mu)] and [c] are
   computed from the random oracle of SimplifiedScheme on [(w1, mu)] (as
   [SD.DilithiumXOF] does), and the stream consumed by [SampleInBall] is
   recorded for [c~] (it is decodable from the leakage of SampleInBall,
   [SD.SIB.leak_to_streamK]). *)
module ChalX : ChalGen = {
  proc get(w1 : high list, mu : mu_t) : ctilde * Rq * leakage = {
    var ct, c, lc;
    ct <@ HctT.sample(w1, mu);
    (c, lc) <@ SD.SIB.SampleInBall(SD.XofOf(SD.XOF)).get(w1, mu);
    HctT.leakT.[ct] <- SD.SIB.leak_to_stream lc;
    return (ct, c, lc);
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

(* Decoding of the leakage of the signing loop (without its first item
   [t0_leak t0]): at every iteration, the item of [c~], the two items of
   SampleInBall (sign bytes, pairs), the item of [c], then one to three
   outcomes ([Int (-1)] when a test passes, the next test is then
   performed). [pstep] reads one item; its state is the phase (the index of
   the item in the iteration), the [c~] and the first SampleInBall item of
   the current iteration, and the table [c~ -> consumed stream] being
   updated. *)
op pstep (st : int * ctilde * decl * (ctilde, byte list) fmap) (d : decl) =
  let (ph, ct, b, m) = st in
  if ph = 0 then (1, ct_dec (SD.SIB.decl_to_ints d), b, m)
  else if ph = 1 then (2, ct, d, m)
  else if ph = 2 then (3, ct, b, m.[ct <- SD.SIB.leak_to_stream [b; d]])
  else if ph = 3 then (4, ct, b, m)
  else if ph = 4 then ((if SD.SIB.decl_to_int d = -1 then 5 else 0), ct, b, m)
  else if ph = 5 then ((if SD.SIB.decl_to_int d = -1 then 6 else 0), ct, b, m)
  else (0, ct, b, m).

op upd_leakT (m : (ctilde, byte list) fmap) (l : leakage) : (ctilde, byte list) fmap =
  (foldl pstep (0, witness, witness, m) l).`4.

(* State of the reduction *)
module RedSt = {
  var t1 : high2 list
  var tr : tr_t
}.

(* Simulated signing oracle: the leakage of [rho] and of ExpandA is
   computed as [MatRA] does (ExpandA on the simulated XOF [XASim]: [rho] is
   public), the message is hashed with [Hmu], the signature
   [(c~, c, (z, h))] returned by SimplifiedScheme is translated into
   [(c~, (z, h))]. The leakage of SimplifiedScheme is appended unchanged:
   the signing loop of [SD.DilithiumR] leaks [t0_leak t0] and then appends,
   with [lcat], the same items in the same order as the loop of
   [MLDSAGen(MatRA, ChalX, HmuB)]; the streams consumed by SampleInBall at
   every iteration are decoded from it and recorded for the [c~] of the
   iteration ([upd_leakT]), as [ChalX] does. *)
module SignRed (O : SD.DSSXOF.DS.Stateless.SOracle_CMA) : SOracle_CMA = {
  proc sign(m : M) : Sig option * leakage = {
    var ma, la, mu, so, lk, r;
    (ma, la) <@ ExpandA(XASim).get(RA.rho);
    mu <@ HmuB.get(RedSt.tr, m);
    (so, lk) <@ O.sign(mu);
    HctT.leakT <- upd_leakT HctT.leakT (behead lk);
    r <- omap (fun (s : SD.SigXOF) => (s.`1, s.`3)) so;
    return (r, lcat (lcat (rho_leak RA.rho) la) lk);
  }
}.

(* The forgery [(m, (c~, (z, h)))] is translated into
   [(mu, (c~, c, (z, h)))] with [mu = Hmu(tr, m)] and [c] computed from the
   XOF on the preimage [(w1, mu)] of [c~] by [Hct] (when [c~] has one,
   otherwise [witness] is returned).
   DEVIATION from the plan: the reduction checks that the preimage of [c~] is
   [(w1, mu)] (with [w1] recovered from [c]) instead of querying
   [Hct(w1, mu)].
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
                  CountHmu(HmuB), CountHct(HctX(X)), CountS(SignRed(O))).forge((rho, t1));
    (ct, zh) <- sig;
    (z, h) <- zh;
    mu <@ HmuB.get(tr, m);
    r <- witness;
    if (ct \in HctT.tinv) {
      x <- oget HctT.tinv.[ct];
      (c, lc) <@ SD.SIB.SampleInBall(SD.XofOf(X)).get(x);
      w1 <- useHintV h (mA *^ z - c ** base2shiftV t1);
      if ((w1, mu) = x) {
        r <- (mu, (ct, c, zh));
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
   queried to the challenge XOF by the adversary and by the verification,
   and the previous samples).
   NOTE: the plan has [qXC] instead of [qXC + 1] in the second factor; the
   [+ 1] accounts for the challenge XOF queries of the verification. *)
op bound_ct = (qHct + kappa_max * qS + 1)%r *
              (qXC + 1 + qHct + kappa_max * qS + 1)%r * eps_ct.

(* [Hmu] (WPD3, TableCollision with dout = dmu, no [put]): at most
   [qHmu + qS + 1] fresh samples. *)
op bound_mu = (qHmu + qS + 1)%r ^ 2 * eps_mu.

(* -------------------------------------------------------------------- *)
(* The random oracle of SimplifiedScheme                                *)
(* -------------------------------------------------------------------- *)

lemma dxout_XB y : SD.dxout (SD.XB y) = dmap dB SD.OB by [].
lemma dxout_XH x : SD.dxout (SD.XH x) = dmap dct SD.OH by [].

(* The byte part of the random oracle of SimplifiedScheme, as a table on
   [(w1, mu), i] *)
op xbproj (m : (SD.xin, SD.xout) fmap) : ((high list * mu_t) * int, byte) fmap =
  offsetmap (fun y => SD.ob (oget m.[SD.XB y]))
            (oflist (map SD.xb_arg (filter SD.is_xb (elems (fdom m))))).

lemma xbprojE m y : (xbproj m).[y] = omap SD.ob m.[SD.XB y].
proof.
case: (SD.XB y \in m) => hy.
- rewrite /xbproj offsetmapT.
  + rewrite mem_oflist; apply/mapP; exists (SD.XB y) => /=.
    by rewrite mem_filter /= -memE mem_fdom.
  by move: hy => /=; rewrite domE; case: (m.[SD.XB y]).
rewrite /xbproj offsetmapN; 2: by move: hy; rewrite domE => /= ->.
rewrite mem_oflist; apply/negP => /mapP [q [+ hq]].
by rewrite mem_filter -memE mem_fdom; case: q hq => //= y' <<-.
qed.

lemma xbproj_mem m y : y \in xbproj m <=> SD.XB y \in m.
proof. by rewrite !domE xbprojE; case: (m.[SD.XB y]). qed.

lemma xbproj_set m y o : xbproj m.[SD.XB y <- o] = (xbproj m).[y <- SD.ob o].
proof.
apply fmap_eqP => z; rewrite xbprojE !get_setE xbprojE.
by case: (z = y) => [-> // | hne]; rewrite (: SD.XB z <> SD.XB y) 1:/#.
qed.

lemma xbproj_setH m x o : xbproj m.[SD.XH x <- o] = xbproj m.
proof. by apply fmap_eqP => z; rewrite !xbprojE get_setE. qed.

lemma mu1_dOB b : mu1 (dmap dB SD.OB) (SD.OB b) = mu1 dB b.
proof. by rewrite (in_dmap1E_can _ _ SD.ob) //= => y _ []. qed.

lemma supp_dOB o : o \in dmap dB SD.OB => o = SD.OB (SD.ob o).
proof. by rewrite supp_dmap => -[b [_ ->]]. qed.

lemma mu1_dOH c : mu1 (dmap dct SD.OH) (SD.OH c) = mu1 dct c.
proof. by rewrite (in_dmap1E_can _ _ SD.oh) //= => y _ []. qed.

lemma supp_dOH o : o \in dmap dct SD.OH => o = SD.OH (SD.oh o).
proof. by rewrite supp_dmap => -[b [_ ->]]. qed.

(* The simulated challenge XOF on [c~ = x0], as a table on [(c~, i)] (the
   value that [XCSim] returns without sampling, if any) *)
op xcval (lx : (ctilde * int, byte) fmap) (lt : (ctilde, byte list) fmap)
         (ti : (ctilde, high list * mu_t) fmap) (m : (SD.xin, SD.xout) fmap)
         (k : ctilde * int) : byte option =
  if k \in lx then lx.[k]
  else if k.`1 \in lt /\ 0 <= k.`2 < size (oget lt.[k.`1])
       then Some (nth witness (oget lt.[k.`1]) k.`2)
  else if k.`1 \in ti then omap SD.ob m.[SD.XB (oget ti.[k.`1], k.`2)]
  else None.

op xcproj lx lt ti m (x0 : ctilde) : (ctilde * int, byte) fmap =
  offsetmap (fun k => oget (xcval lx lt ti m k))
    (oflist (filter (fun (k : ctilde * int) => k.`1 = x0) (elems (fdom lx)) ++
             (if x0 \in lt then map (fun p => (x0, p)) (iota_ 0 (size (oget lt.[x0])))
              else []) ++
             (if x0 \in ti
              then map (fun q => (x0, (SD.xb_arg q).`2))
                     (filter (fun q => SD.is_xb q /\ (SD.xb_arg q).`1 = oget ti.[x0])
                             (elems (fdom m)))
              else []))).

lemma xcprojE lx lt ti m x0 p :
  (xcproj lx lt ti m x0).[(x0, p)] = xcval lx lt ti m (x0, p).
proof.
have m1 : (x0, p) \in filter (fun (k : ctilde * int) => k.`1 = x0) (elems (fdom lx)) <=>
          (x0, p) \in lx.
- by rewrite mem_filter -memE mem_fdom.
have m2 : ((x0, p) \in (if x0 \in lt then map (fun p => (x0, p)) (iota_ 0 (size (oget lt.[x0])))
                       else [])) <=>
          (x0 \in lt /\ 0 <= p < size (oget lt.[x0])).
- case: (x0 \in lt) => //= _; rewrite mapP; split.
  + by move=> [q [+ /= ->]]; rewrite mem_iota /#.
  by move=> hp; exists p; rewrite mem_iota /#.
have m3 : ((x0, p) \in (if x0 \in ti
                       then map (fun q => (x0, (SD.xb_arg q).`2))
                              (filter (fun q => SD.is_xb q /\ (SD.xb_arg q).`1 = oget ti.[x0])
                                      (elems (fdom m)))
                       else [])) <=>
          (x0 \in ti /\ SD.XB (oget ti.[x0], p) \in m).
- case: (x0 \in ti) => //= _; rewrite mapP; split.
  + by move=> [q [+ /= ->]]; rewrite mem_filter -memE mem_fdom; case: q => //= -[x i] /= [<- h].
  by move=> h; exists (SD.XB (oget ti.[x0], p)); rewrite mem_filter -memE mem_fdom.
rewrite /xcproj; case _ : (xcval lx lt ti m (x0, p)) => [hn | v hv].
- rewrite offsetmapN // mem_oflist !mem_cat m1 m2 m3; move: hn; rewrite /xcval /= !domE.
  smt().
rewrite offsetmapT /= ?hv // mem_oflist !mem_cat m1 m2 m3; move: hv; rewrite /xcval /= !domE.
smt().
qed.

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
    SD.SIB.RR.F1.RO.m <- xbproj SD.XOF.m;
    r <@ SD.SIB.SampleIndices(SD.SIB.RR.F1.RO).sample(x);
  }

  proc run3(x : ctilde) = {
    var r;
    SIB.RR.F1.RO.m <- xcproj LX.RO.m HctT.leakT HctT.tinv SD.XOF.m x;
    r <@ SIB.SampleIndices(SIB.RR.F1.RO).sample(x);
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

(* A byte query to the random oracle of SimplifiedScheme, against the lazy
   random oracle on the projection *)
local lemma xb_get :
  equiv[SD.XofOf(SD.XOF).get ~ SD.SIB.RR.F1.RO.get :
        ={arg} /\ xbproj SD.XOF.m{1} = SD.SIB.RR.F1.RO.m{2} ==>
        ={res} /\ xbproj SD.XOF.m{1} = SD.SIB.RR.F1.RO.m{2}].
proof.
proc; inline *; wp.
rnd SD.ob SD.OB; auto => /> &1 &2; split => [b _ | _]; 1: by rewrite mu1_dOB.
move=> o ho; rewrite dB_full /= -(supp_dOB _ ho) /=.
rewrite xbproj_mem !get_set_sameE /=; case: (SD.XB x{2} \in SD.DSSXOF.PRO.RO.m{1}) => //= hx.
- by rewrite xbprojE; move: hx; rewrite domE; case: (SD.DSSXOF.PRO.RO.m{1}.[SD.XB x{2}]).
by rewrite xbproj_set.
qed.

lemma SDSIB_ll : islossless SD.SIB.SampleInBall(SD.XofOf(SD.XOF)).get.
proof.
bypr => &m _.
have <- : Pr[WL.run2(x{m}) @ &m : true] = 1%r.
- byphoare => //; proc; call SD.SIB.SampleIndices_ll; auto.
byequiv => //; proc *; inline SD.SIB.SampleInBall(SD.XofOf(SD.XOF)).get WL.run2
  SD.SIB.SampleIndices(SD.SIB.RR.F1.RO).sample; wp.
while (={i, ctx} /\ x0{1} = x1{2} /\ xbproj SD.XOF.m{1} = SD.SIB.RR.F1.RO.m{2}).
- wp; while (={i, j, ctx} /\ x0{1} = x1{2} /\ xbproj SD.XOF.m{1} = SD.SIB.RR.F1.RO.m{2}).
  + by wp; call xb_get; auto.
  by auto.
wp; while (={ctx} /\ x0{1} = x1{2} /\ xbproj SD.XOF.m{1} = SD.SIB.RR.F1.RO.m{2}).
- by wp; call xb_get; auto.
by auto.
qed.

local lemma xcval_lx lx lt ti m (k k' : ctilde * int) b :
  k \notin lx =>
  xcval lx.[k <- b] lt ti m k' = if k' = k then Some b else xcval lx lt ti m k'.
proof.
move=> hk; rewrite /xcval mem_set get_setE.
by case: (k' = k).
qed.

local lemma xcval_xb lx lt ti m x0 p p' o :
  (x0, p) \notin lx => !(x0 \in lt /\ 0 <= p < size (oget lt.[x0])) => x0 \in ti =>
  xcval lx lt ti m.[SD.XB (oget ti.[x0], p) <- o] (x0, p') =
  if p' = p then Some (SD.ob o) else xcval lx lt ti m (x0, p').
proof.
move=> h1 h2 h3; rewrite /xcval /= get_setE.
case: (p' = p) => [->> | hne] /=; 1: by rewrite h1 h3 /=; move: h2 => /= ->.
by rewrite (: SD.XB (oget ti.[x0], p') <> SD.XB (oget ti.[x0], p)) 1:/#.
qed.

(* A query to the simulated challenge XOF, against the lazy random oracle
   on its table *)
local lemma xc_get x0 :
  equiv[XCSim(SD.XOF).get ~ SIB.RR.F1.RO.get :
        ={arg} /\ arg{1}.`1 = x0 /\
        (forall p, xcval LX.RO.m{1} HctT.leakT{1} HctT.tinv{1} SD.XOF.m{1} (x0, p) =
                   SIB.RR.F1.RO.m{2}.[(x0, p)]) ==>
        ={res} /\
        (forall p, xcval LX.RO.m{1} HctT.leakT{1} HctT.tinv{1} SD.XOF.m{1} (x0, p) =
                   SIB.RR.F1.RO.m{2}.[(x0, p)])].
proof.
proc; inline *; if{1}.
- rcondf{1} 3; 1: by auto.
  rcondf{2} 2.
  + move=> &m; auto => /> &hr hm hin r _.
    have := hm y{m}.`2; rewrite -pairS /xcval hin /= domE => <-.
    by move: hin; rewrite domE.
  auto => /> &1 &2 hm hin r _.
  by have := hm x{2}.`2; rewrite -pairS /xcval hin /= => <-.
if{1}.
- rcondf{2} 2.
  + move=> &m; auto => /> &hr hm hnin hlt hp1 hp2 r _.
    by have := hm y{m}.`2; rewrite -pairS /xcval hnin hlt hp1 hp2 /= domE => <-.
  auto => /> &1 &2 hm hnin hlt hp1 hp2; rewrite dB_ll /= => _ _.
  by have := hm x{2}.`2; rewrite -pairS /xcval hnin hlt hp1 hp2 /= => <-.
if{1}.
- wp; rnd SD.ob SD.OB; auto => /> &1 &2 hm hnin hlt hti.
  have hv : SIB.RR.F1.RO.m{2}.[x{2}] =
            omap SD.ob SD.XOF.m{1}.[SD.XB (oget HctT.tinv{1}.[x{2}.`1], x{2}.`2)].
  + by have := hm x{2}.`2; rewrite -pairS /xcval hnin hlt hti /= => <-.
  split => [b _ | _]; 1: by rewrite mu1_dOB.
  move=> o ho; rewrite dB_full /= -(supp_dOB _ ho) /= !domE hv.
  case _ : (SD.XOF.m{1}.[SD.XB (oget HctT.tinv{1}.[x{2}.`1], x{2}.`2)]) => [hn | v hs] //=.
  rewrite !get_set_sameE /= => p.
  rewrite xcval_xb -?pairS // get_setE.
  by rewrite hm (: ((x{2}.`1, p) = x{2}) = (p = x{2}.`2)) //; smt().
auto => /> &1 &2 hm hnin hlt hti.
have hv : SIB.RR.F1.RO.m{2}.[x{2}] = None.
- by have := hm x{2}.`2; rewrite -pairS /xcval hnin hlt hti /= => <-.
move=> r _; rewrite !domE hv /= !get_set_sameE /= => p.
by rewrite (pairS x{2}) xcval_lx -?pairS // get_setE hm.
qed.

lemma SIBX_ll : islossless SIB.SampleInBall(XCSim(SD.XOF)).get.
proof.
bypr => &m _.
have <- : Pr[WL.run3(x{m}) @ &m : true] = 1%r.
- byphoare => //; proc; call SIB.SampleIndices_ll; auto.
byequiv => //; proc *; inline SIB.SampleInBall(XCSim(SD.XOF)).get WL.run3
  SIB.SampleIndices(SIB.RR.F1.RO).sample; wp.
exlim x{1} => xx.
while (={i, ctx} /\ x0{1} = x1{2} /\ x0{1} = xx /\
       (forall p, xcval LX.RO.m{1} HctT.leakT{1} HctT.tinv{1} SD.XOF.m{1} (xx, p) =
                  SIB.RR.F1.RO.m{2}.[(xx, p)])).
- wp; while (={i, j, ctx} /\ x0{1} = x1{2} /\ x0{1} = xx /\
             (forall p, xcval LX.RO.m{1} HctT.leakT{1} HctT.tinv{1} SD.XOF.m{1} (xx, p) =
                        SIB.RR.F1.RO.m{2}.[(xx, p)])).
  + by wp; call (xc_get xx); auto.
  by auto.
wp; while (={ctx} /\ x0{1} = x1{2} /\ x0{1} = xx /\
           (forall p, xcval LX.RO.m{1} HctT.leakT{1} HctT.tinv{1} SD.XOF.m{1} (xx, p) =
                      SIB.RR.F1.RO.m{2}.[(xx, p)])).
- by wp; call (xc_get xx); auto.
by auto => /> p; rewrite xcprojE.
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

(* ExpandA terminates over the simulated XOF: the first query on an entry
   reprograms its stream, the loop then reads a lazy random oracle (the
   overlay), on which it terminates ([EA.SampleRq_ll], same queries and
   control flow). *)
(* a query on an entry already reprogrammed is a query to the overlay *)
local lemma xasim_ro R : equiv [XASim.get ~ EA.RS.RO.get :
  ={arg} /\ arg{1}.`1 \in R /\ EA.RS.Sim.reprog{1} = R /\ OV.m{1} = EA.RS.RO.m{2} ==>
  ={res} /\ EA.RS.Sim.reprog{1} = R /\ OV.m{1} = EA.RS.RO.m{2}].
proof. by proc; inline *; rcondf{1} 2; auto. qed.

local module WA = {
  proc run(x : seed * int * int) = {
    var r;
    XASim.reprogram(x);
    EA.RS.RO.m <- OV.m;
    r <@ EA.SampleRq(EA.RS.RO).sample(x);
  }
}.

lemma ExpandA_poly_XASim_ll : islossless ExpandA(XASim).poly.
proof.
bypr => &m _.
have <- : Pr[WA.run(x{m}) @ &m : true] = 1%r.
- byphoare => //; proc; call EA.SampleRq_ll; wp.
  inline 1; sp; if => //.
  call (EA.RP_ll OV _); 1: by islossless.
  by inline *; auto => />; sp; if; [auto | sp; if; auto; smt(dRq_ll)].
byequiv => //; proc *.
inline WA.run ExpandA(XASim).poly EA.SampleRq(EA.RS.RO).sample.
(* the first query reprograms the entry *)
unroll{1} 5; rcondt{1} 5; 1: by auto => />; smt(gt0_n).
unroll{2} 7; rcondt{2} 7.
- by move=> &m0; wp; call (: true); auto => />; smt(gt0_n).
inline{1} 5.
seq 6 2 : (x0{1} = x0{2} /\ x0{1} \in EA.RS.Sim.reprog{1} /\ ={OV.m} /\
           cs{1} = [] /\ ctx{1} = 0 /\ y{1} = (x0{1}, 0)).
- exlim x{1} => xx.
  call (: ={x, EA.RS.Sim.reprog, OV.m, glob RA} /\ x{1} = xx ==>
          ={EA.RS.Sim.reprog, OV.m, glob RA} /\ xx \in EA.RS.Sim.reprog{1}); 2: by auto.
  proc; if => //.
  call (: ={OV.m}); 1: by sim.
  call (: ={glob RA}); 1: by sim.
  by auto => />; smt(in_fsetU in_fset1).
exlim EA.RS.Sim.reprog{1} => R.
wp; while (x0{1} = x1{2} /\ x0{1} \in R /\ EA.RS.Sim.reprog{1} = R /\
           OV.m{1} = EA.RS.RO.m{2} /\ ={cs, ctx}).
- by wp; do 3! call (xasim_ro R); auto => />; rewrite /EA.v_of.
by wp; do 2! call (xasim_ro R); inline *; auto => />.
qed.

lemma ExpandA_XASim_ll : islossless ExpandA(XASim).get.
proof.
proc; while true (k - r); 2: by auto => /#.
move=> z; wp; while true (l - s); 2: by auto => /#.
by move=> z'; wp; call ExpandA_poly_XASim_ll; auto => /#.
qed.

end section Termination.

end MLDSAProof_Games.
