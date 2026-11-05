require import AllCore Distr List IntDiv FSet Leakage Byte.
require DParams DRing DVect SampleInBallEquiv PROM.

(** Target security spec for ML-DSA: the scheme of Dilithium.ec, extended with
    the parts of FIPS 204 whose justification belongs to the security proof:
    - ExpandA: rejection sampling of A from a public seed over a public XOF
      (with its leakage: every candidate read on the XOF)
    - the challenge: c~ <- Hct(w1, mu), c <- SampleInBall(c~) over a public XOF,
      signatures carry c~
    - the leakage of the signing loop: once, at the start of signing, the
      seed [rho], the leakage of ExpandA (for every entry of A, all the
      candidates read on the XOF, accepted or rejected) and [t0]; then at
      every iteration (accepted or rejected) [c~], the leakage of
      SampleInBall (its sign bytes and the pairs (position, byte) of its
      rejection loop), [c] and the outcomes of the rejection tests that are
      performed
    - hash-then-sign: mu <- Hmu(tr, m), tr <- Htr(pk)
    - a bounded signing loop and the FIPS 204 range for y
    The file also defines the EF-CMA security game of the scheme (random
    oracles [XA], [XC], [Htr], [Hmu], [Hct], signing oracle, query counters)
    and the assumptions on the parameters needed by the proof
    ([MLDSAProof.ec]): [q <= 2^23], the support of the masking distribution,
    the canonical coefficients of [ofRq], the injectivity of [to_concrete]
    on valid challenge encodings, bounds on the hash output distributions,
    and the properties of the (abstract) rejection tests. *)

abstract theory MLDSATarget.

(* n, q, k, l, eta, gamma1, gamma2, beta, tau, d *)
clone import DParams as Params.

clone import DRing as DR with
  op n <= n,
  op q <= q
proof prime_q by exact prime_q
proof gt0_n by exact gt0_n.

clone import DVect as DV with
  theory DR <= DR,
  op HL.alpha <- 2*gamma2,
  op HL.d     <- d
proof
  HL.ge2_alpha,
  HL.alpha_halfq_le,
  HL.even_alpha,
  HL.alpha_almost_divides_q,
  HL.d_bound.
realize HL.ge2_alpha by smt(gamma2_bound).
realize HL.even_alpha by smt().
realize HL.alpha_halfq_le by smt(gamma2_bound).
realize HL.alpha_almost_divides_q by apply gamma2_div.
realize HL.d_bound by smt(gt0_d pow2_d_lt_q).

import DV.MatRq.
import DV.HL.

(*************************************)
(**** Parameters and types    ********)
(*************************************)

(* bound on the number of iterations of the signing loop *)
op kappa_max : { int | 0 < kappa_max } as gt0_kappa_max.

(* masking distribution: coefficients uniform in [-gamma1 + 1, gamma1] *)
op [lossless uniform] dRq_mask : Rq distr.

(* Support of the masking distribution. FIPS 204 samples the coefficients of
   y uniformly in [-gamma1 + 1, gamma1]; the security proof only needs that
   this set contains the centered box of radius gamma1 - 1 and is contained
   in the one of radius gamma1. *)
axiom dRq_mask_supp_box   x : cnorm x <= gamma1 - 1 => x \in dRq_mask.
axiom dRq_mask_supp_bound x : x \in dRq_mask => cnorm x <= gamma1.

(* Coefficient lists of length n with entries in [0, q) are in bijection with Rq.
   FIPS 204 instantiates toRq with the inverse NTT. *)
op toRq : int list -> Rq.
op ofRq : Rq -> int list.
axiom toRqK r : toRq (ofRq r) = r.
axiom ofRqK xs :
  size xs = n => all (fun x => 0 <= x < q) xs => ofRq (toRq xs) = xs.
axiom ofRq_valid r : size (ofRq r) = n /\ all (fun x => 0 <= x < q) (ofRq r).

(*************************************)
(**** Rejection tests         ********)
(*************************************)

(* The rejection tests of a signing iteration are abstract.  The tests on
   [z], on [w0 = w - c s2] and on the hint [h] return [None] when they pass
   and, when they fail, a value in [0, M) which is leaked: typically the
   index of the first failing polynomial or coefficient of a short-circuit
   cascade (see [DV.first_fail]).  The security proof needs:
   - the range of the failing value: it is guessed by a plug-and-pray
     argument, and [Mz + Mr0 + Mhint + 1] enters the bound;
   - the characterization of success by the norm bound: for [z] and [w0],
     the simulator reproduces the tests with the norm bounds, and the
     rejection probability is bounded in terms of the norm bounds;
   - for [z], the invariance under small shifts of the distribution of the
     outcome on a masking vector: the simulator does not know [s1].
   The tests on [w0] and on [h] are only performed, and their outcome only
   leaked, when the previous test passed.
   The test on [c t0] is a boolean: [c] and [t0] are leaked, so it is a
   public computation which can be performed anywhere, at any granularity.
   The vector [t0] (the low bits of [t], part of the secret key) is treated
   as public by the security proof. *)
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

(* Canonical instantiation of [check_z], not used by the model, provided for
   the instantiations: the index of the first polynomial of [z] failing the
   norm test [z_ok] ([first_fail z_ok l], a short-circuit cascade of [l]
   tests). Its outcome on a shifted masking vector does not depend on the
   shift, which realizes [check_z_shift] below. *)
op z_ok (p : Rq) = cnorm p < gamma1 - beta_.

section CanonicalZ.
import RqRing.

(* The probability that one masking polynomial passes the norm test does not
   depend on a shift of norm at most [beta] *)
lemma dRq_mask_shift u :
  cnorm u <= beta_ => mu dRq_mask (fun x => z_ok (x + u)) = mu dRq_mask z_ok.
proof.
move=> hu.
rewrite (_ : (fun x => z_ok (x + u)) = z_ok \o (fun x => x + u)) // -dmapE.
rewrite !muE; congr; apply fun_ext => w /=.
case: (z_ok w) => // hw.
rewrite dmap1E /(\o) (mu_eq _ _ (pred1 (w - u))).
- move=> x; rewrite /pred1 /= eq_iff.
  by split => [<-|->]; [rewrite addrK | rewrite subrK].
rewrite !mu1_uni_ll ?dRq_mask_uni ?dRq_mask_ll.
have -> : w - u \in dRq_mask.
- apply dRq_mask_supp_box; apply (StdOrder.IntOrder.ler_trans _ _ _ (cnorm_triangle _ _)).
  by rewrite cnormN; move: hw; rewrite /z_ok; smt(gt0_beta).
have -> // : w \in dRq_mask.
by apply dRq_mask_supp_box; move: hw; rewrite /z_ok; smt(gt0_beta).
qed.

lemma first_fail_z_shift (v : vector) :
  size v = l => inf_normv v <= beta_ =>
  dmap (dvector dRq_mask l) (fun y => first_fail z_ok l (y + v)) =
  dmap (dvector dRq_mask l) (first_fail z_ok l).
proof.
move=> _ norm_v; apply first_fail_shift; [exact dRq_mask_ll | smt(gt0_l) |].
move=> j _; apply dRq_mask_shift.
exact (StdOrder.IntOrder.ler_trans _ _ _ (ler_cnorm_inf_normv j v) norm_v).
qed.

end section CanonicalZ.

(* The outcome of the test on [y + v] does not depend on the shift [v] when
   [y] is a masking vector and [||v||_inf <= beta] *)
axiom check_z_shift (v : vector) :
  size v = l => inf_normv v <= beta_ =>
  dmap (dvector dRq_mask l) (fun y => check_z (y + v)) =
  dmap (dvector dRq_mask l) check_z.

op check_hw (h : hint_t list) = check_hint h = None.

(* Declassification of a challenge and of t0 *)
op c_leak (c : Rq) : leakage = [List (map Int (ofRq c))].

op t0_leak (t0 : vector) : leakage =
  [List (map (fun p => List (map Int (ofRq p))) (tolist t0))].

(* Declassification of the candidates read by ExpandA for one entry of the
   matrix (the integers of the 3-byte chunks, top bit dropped, accepted or
   rejected) *)
op cands_leak (vs : int list) : leakage = [List (map Int vs)].

type M.       (* messages      *)
type seed.    (* rho           *)
type tr_t.    (* tr            *)
type mu_t.    (* mu            *)
type ctilde.  (* c~            *)

(* Encoding of [c~] as a list of integers (FIPS 204: its bytes), with a left
   inverse: [c~] can be read back from its declassification. *)
op ct_enc : ctilde -> int list.
op ct_dec : int list -> ctilde.
axiom ct_encK : cancel ct_enc ct_dec.

(* Declassification of [c~] *)
op ct_leak (ct : ctilde) : leakage = [List (map Int (ct_enc ct))].

(* Encoding of the seed [rho] as a list of integers (FIPS 204: its bytes),
   with a left inverse, and its declassification ([rho] is part of the
   public key). *)
op rho_enc : seed -> int list.
op rho_dec : int list -> seed.
axiom rho_encK : cancel rho_enc rho_dec.

op rho_leak (rho : seed) : leakage = [List (map Int (rho_enc rho))].

op [lossless full uniform] dseed : seed distr.

type PK = seed * high2 list.
type SK = seed * tr_t * vector * vector * vector.
type response_t = vector * hint_t list.
type Sig = ctilde * response_t.

(*************************************)
(**** Oracles                 ********)
(*************************************)

(* XOF used by ExpandA: byte at position i of the stream on (rho, r, s) *)
clone PROM.FullRO as XA with
  type in_t  <- (seed * int * int) * int,
  type out_t <- byte,
  op   dout  <- fun _ => dB.

module type XOF_A = {
  include XA.RO [get]
}.

(* SampleInBall over a XOF on c~ (the XOF is [SIB.XOF.RO]) *)
(* [to_concrete] turns a challenge encoding (a list of 256 coefficients in
   {-1, 0, 1}) into a ring element; it must be injective on these lists. *)
op to_concrete : int list -> Rq.
axiom to_concrete_inj_in (x y : int list) :
  size x = 256 => all (fun c => c = -1 \/ c = 0 \/ c = 1) x =>
  size y = 256 => all (fun c => c = -1 \/ c = 0 \/ c = 1) y =>
  to_concrete x = to_concrete y => x = y.

clone SampleInBallEquiv as SIB with
  type in_t      <- ctilde,
  type challenge <- Rq,
  op to_concrete <- to_concrete,
  theory Params  <- Params
proof to_concrete_inj_in.
realize to_concrete_inj_in.
move=> x y _ _ eq_xy.
have [szx hx] := SIB.to_challenge_valid x.
have [szy hy] := SIB.to_challenge_valid y.
exact (to_concrete_inj_in _ _ szx hx szy hy eq_xy).
qed.

(* Hash functions, modeled as random oracles with uniform outputs *)
op [lossless full uniform] dtr : tr_t distr.
op [lossless full uniform] dmu : mu_t distr.
op [lossless full uniform] dct : ctilde distr.

(* Upper bounds on the probability of guessing a hash output
   (1 / |mu_t| and 1 / |ctilde| for uniform distributions). *)
op eps_mu : real.
op eps_ct : real.
axiom dmu_max x : mu1 dmu x <= eps_mu.
axiom dct_max x : mu1 dct x <= eps_ct.

clone PROM.FullRO as ROtr with
  type in_t  <- PK,
  type out_t <- tr_t,
  op   dout  <- fun _ => dtr.

clone PROM.FullRO as ROmu with
  type in_t  <- tr_t * M,
  type out_t <- mu_t,
  op   dout  <- fun _ => dmu.

clone PROM.FullRO as ROct with
  type in_t  <- high list * mu_t,
  type out_t <- ctilde,
  op   dout  <- fun _ => dct.

module type Hash_tr = {
  include ROtr.RO [get]
}.

module type Hash_mu = {
  include ROmu.RO [get]
}.

module type Hash_ct = {
  include ROct.RO [get]
}.

(*************************************)
(**** ExpandA                 ********)
(*************************************)

(* [poly(x)] samples the entry [x = (rho, r, s)] by rejection over the
   stream of [x], and returns it with the list of all the candidates read
   (accepted or rejected, in order). [get(rho)] returns the matrix and its
   leakage: the candidates of every entry, in the order of the loops. *)
module ExpandA (X : XOF_A) = {
  proc poly(x : seed * int * int) : Rq * int list = {
    var cs, vs, ctx, b0, b1, b2, v;
    cs <- [];
    vs <- [];
    ctx <- 0;
    while (size cs < n) {
      b0 <@ X.get(x, ctx);
      b1 <@ X.get(x, ctx + 1);
      b2 <@ X.get(x, ctx + 2);
      v <- to_int b0 + 256 * to_int b1 + 65536 * (to_int b2 %% 128);
      vs <- rcons vs v;
      if (v < q) {
        cs <- rcons cs v;
      }
      ctx <- ctx + 3;
    }
    return (toRq cs, vs);
  }

  proc get(rho : seed) : matrix * leakage = {
    var mA, la, r, s, a, vs;
    mA <- zerom k l;
    la <- Empty;
    r <- 0;
    while (r < k) {
      s <- 0;
      while (s < l) {
        (a, vs) <@ poly((rho, r, s));
        mA <- updm mA r s a;
        la <- lcat la (cands_leak vs);
        s <- s + 1;
      }
      r <- r + 1;
    }
    return (mA, la);
  }
}.

(*************************************)
(**** The scheme              ********)
(*************************************)

module MLDSA (XA : XOF_A, XC : SIB.XOF_t, Htr : Hash_tr, Hmu : Hash_mu, Hct : Hash_ct) = {
  proc keygen() : PK * SK = {
    var rho, mA, la, s1, s2, t, pk, tr;
    rho <$ dseed;
    (mA, la) <@ ExpandA(XA).get(rho);
    s1  <$ dvector (dRq_ eta_) l;
    s2  <$ dvector (dRq_ eta_) k;
    t   <- mA *^ s1 + s2;
    pk  <- (rho, base2highbitsV t);
    tr  <@ Htr.get(pk);
    return (pk, (rho, tr, s1, s2, base2lowbitsV t));
  }

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
    (* rho, the candidates read by ExpandA, then t0, once *)
    leak <- rho_leak rho;
    (mA, la) <@ ExpandA(XA).get(rho);
    leak <- lcat leak la;
    leak <- lcat leak (t0_leak t0);
    mu <@ Hmu.get(tr, m);


    response <- None;
    ctr <- 0;
    while (response = None /\ ctr < kappa_max) {
      y  <$ dvector dRq_mask l;
      w  <- mA *^ y;
      w1 <- highBitsV w;
      ct <@ Hct.get(w1, mu);
      leak <- lcat leak (ct_leak ct);
      (c, lc) <@ SIB.SampleInBall(XC).get(ct);
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
      ctr  <- ctr + 1;
    }
    return (omap (fun r => (ct, r)) response, leak);
  }

  proc verify(pk : PK, m : M, sig : Sig) : bool = {
    var rho, t1, ct, ct', response, z, h, mA, la, tr, mu, c, lc, w1;
    (rho, t1) <- pk;
    (ct, response) <- sig;
    (z, h) <- response;
    (mA, la) <@ ExpandA(XA).get(rho);
    tr <@ Htr.get(pk);
    mu <@ Hmu.get(tr, m);
    (c, lc) <@ SIB.SampleInBall(XC).get(ct);
    w1 <- useHintV h (mA *^ z - c ** base2shiftV t1);
    ct' <@ Hct.get(w1, mu);
    return size z = l /\ size h = k /\ inf_normv z < gamma1 - beta_ /\ ct = ct';
  }
}.

(*************************************)
(**** Additional assumptions  ********)
(*************************************)

(* q fits in 23 bits: the rejection sampling of ExpandA (3 bytes, top bit
   dropped) is then uniform on [0, q). *)
axiom q_le_2_23 : q <= 2^23.

(*************************************)
(**** Security game (EF-CMA)  ********)
(*************************************)

(* Query bounds: number of signing queries, of XOF queries for A (any index),
   of distinct [c~] queried to the challenge XOF (the integer index is not
   counted, as in [SimplifiedScheme.CountX]), and of hash queries. *)
const qS   : { int | 0 <= qS   } as qS_ge0.
const qXA  : { int | 0 <= qXA  } as qXA_ge0.
const qXC  : { int | 0 <= qXC  } as qXC_ge0.
const qHtr : { int | 0 <= qHtr } as qHtr_ge0.
const qHmu : { int | 0 <= qHmu } as qHmu_ge0.
const qHct : { int | 0 <= qHct } as qHct_ge0.

(* Signing oracle as seen by the adversary: a signature may fail (bounded
   loop), in which case only the leakage is returned. *)
module type SOracle_CMA = {
  proc sign(m : M) : Sig option * leakage
}.

module type Adv_EFCMA (XA : XOF_A) (XC : SIB.XOF_t) (Htr : Hash_tr)
                      (Hmu : Hash_mu) (Hct : Hash_ct) (O : SOracle_CMA) = {
  proc forge(pk : PK) : M * Sig
}.

module O_CMA (XA : XOF_A, XC : SIB.XOF_t, Htr : Hash_tr, Hmu : Hash_mu, Hct : Hash_ct) = {
  var sk : SK
  var qs : M list

  proc init(sk_init : SK) : unit = {
    sk <- sk_init;
    qs <- [];
  }

  proc sign(m : M) : Sig option * leakage = {
    var r;
    r <@ MLDSA(XA, XC, Htr, Hmu, Hct).sign(sk, m);
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

(* The random oracles of the game *)
module ROs = {
  proc init() : unit = {
    XA.RO.init();
    SIB.XOF.RO.init();
    ROtr.RO.init();
    ROmu.RO.init();
    ROct.RO.init();
  }
}.

module EF_CMA_MLDSA (A : Adv_EFCMA) = {
  module S = MLDSA(XA.RO, SIB.XOF.RO, ROtr.RO, ROmu.RO, ROct.RO)
  module O = O_CMA(XA.RO, SIB.XOF.RO, ROtr.RO, ROmu.RO, ROct.RO)

  proc main() : bool = {
    var pk, sk, m, sig, nrqs;
    var is_valid, is_fresh;

    ROs.init();
    (pk, sk) <@ S.keygen();
    O.init(sk);
    (m, sig) <@ A(XA.RO, SIB.XOF.RO, ROtr.RO, ROmu.RO, ROct.RO, O).forge(pk);
    is_valid <@ S.verify(pk, m, sig);
    is_fresh <@ O.fresh(m);
    nrqs <@ O.nr_queries();
    return nrqs <= qS /\ is_valid /\ is_fresh;
  }
}.

(*************************************)
(**** Query counting          ********)
(*************************************)

(* The query bound on an adversary [A] is expressed, in the security
   theorem, as
     hoare [ A(CountXA(XA'), CountXC(XC'), CountHtr(Htr'), CountHmu(Hmu'),
               CountHct(Hct'), CountS(O')).forge :
             all counters are 0 ==>
             CountXA.q <= qXA /\ CountXC.q <= qXC /\ CountHtr.q <= qHtr /\
             CountHmu.q <= qHmu /\ CountHct.q <= qHct /\ CountS.q <= qS ]
   for all oracle implementations. *)

module CountXA (X : XOF_A) = {
  var q : int
  proc init() = { q <- 0; }
  proc get(x : (seed * int * int) * int) : byte = {
    var r;
    q <- q + 1;
    r <@ X.get(x);
    return r;
  }
}.

(* Only distinct [c~] are counted, the integer index is ignored. *)
module CountXC (X : SIB.XOF_t) = {
  var q  : int
  var xs : ctilde fset
  proc init() = { q <- 0; xs <- fset0; }
  proc get(y : ctilde * int) : byte = {
    var r;
    if (y.`1 \notin xs) {
      xs <- xs `|` fset1 y.`1;
      q  <- q + 1;
    }
    r <@ X.get(y);
    return r;
  }
}.

module CountHtr (H : Hash_tr) = {
  var q : int
  proc init() = { q <- 0; }
  proc get(x : PK) : tr_t = {
    var r;
    q <- q + 1;
    r <@ H.get(x);
    return r;
  }
}.

module CountHmu (H : Hash_mu) = {
  var q : int
  proc init() = { q <- 0; }
  proc get(x : tr_t * M) : mu_t = {
    var r;
    q <- q + 1;
    r <@ H.get(x);
    return r;
  }
}.

module CountHct (H : Hash_ct) = {
  var q : int
  proc init() = { q <- 0; }
  proc get(x : high list * mu_t) : ctilde = {
    var r;
    q <- q + 1;
    r <@ H.get(x);
    return r;
  }
}.

module CountS (O : SOracle_CMA) = {
  var q : int
  proc init() = { q <- 0; }
  proc sign(m : M) : Sig option * leakage = {
    var r;
    q <- q + 1;
    r <@ O.sign(m);
    return r;
  }
}.

end MLDSATarget.
