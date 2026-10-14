require import AllCore Distr List IntDiv Leakage.
require DParams DRing DVect SampleInBallEquiv PROM.

(** Target security spec for ML-DSA: the scheme of Dilithium.ec, extended with
    the parts of FIPS 204 whose justification belongs to the security proof:
    - ExpandA: rejection sampling of A from a public seed over a public XOF
    - the challenge: c~ <- Hct(w1, mu), c <- SampleInBall(c~) over a public XOF,
      signatures carry c~
    - hash-then-sign: mu <- Hmu(tr, m), tr <- Htr(pk)
    - a bounded signing loop and the FIPS 204 range for y *)

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
  HL.alpha_almost_divides_q.
realize HL.ge2_alpha by smt(gamma2_bound).
realize HL.even_alpha by smt().
realize HL.alpha_halfq_le by smt(gamma2_bound).
realize HL.alpha_almost_divides_q by apply gamma2_div.

import DV.MatRq.
import DV.HL.

(*************************************)
(**** Parameters and types    ********)
(*************************************)

(* bound on the number of iterations of the signing loop *)
op kappa_max : { int | 0 < kappa_max } as gt0_kappa_max.

(* masking distribution: coefficients uniform in [-gamma1 + 1, gamma1] *)
op [lossless uniform] dRq_mask : Rq distr.

(* Coefficient lists of length n with entries in [0, q) are in bijection with Rq.
   FIPS 204 instantiates toRq with the inverse NTT. *)
op toRq : int list -> Rq.
op ofRq : Rq -> int list.
axiom toRqK r : toRq (ofRq r) = r.
axiom ofRqK xs :
  size xs = n => all (fun x => 0 <= x < q) xs => ofRq (toRq xs) = xs.

op check_hw : hint_t list -> bool.

type M.       (* messages      *)
type seed.    (* rho           *)
type tr_t.    (* tr            *)
type mu_t.    (* mu            *)
type ctilde.  (* c~            *)

op [lossless full uniform] dseed : seed distr.

type PK = seed * high2 list.
type SK = seed * tr_t * vector * vector * vector.
type response_t = vector * hint_t list.
type Sig = ctilde * response_t.

(*************************************)
(**** Oracles                 ********)
(*************************************)

(* SampleInBall over a XOF on c~ *)
clone SampleInBallEquiv as SIB with
  type in_t      <- ctilde,
  type challenge <- Rq,
  theory Params  <- Params.
import SIB.B.

(* XOF used by ExpandA: byte at position i of the stream on (rho, r, s) *)
clone PROM.FullRO as XA with
  type in_t  <- (seed * int * int) * int,
  type out_t <- byte,
  op   dout  <- fun _ => dB.

module type XOF_A = {
  include XA.RO [get]
}.

module type Hash_tr = {
  proc get(pk : PK) : tr_t
}.

module type Hash_mu = {
  proc get(tr : tr_t, m : M) : mu_t
}.

module type Hash_ct = {
  proc get(w1 : high list, mu : mu_t) : ctilde
}.

(*************************************)
(**** ExpandA                 ********)
(*************************************)

module ExpandA (X : XOF_A) = {
  proc get(rho : seed) : matrix = {
    var mA, r, s, cs, ctx, b0, b1, b2, v;
    mA <- zerom k l;
    r <- 0;
    while (r < k) {
      s <- 0;
      while (s < l) {
        cs <- [];
        ctx <- 0;
        while (size cs < n) {
          b0 <@ X.get((rho, r, s), ctx);
          b1 <@ X.get((rho, r, s), ctx + 1);
          b2 <@ X.get((rho, r, s), ctx + 2);
          v <- to_int b0 + 256 * to_int b1 + 65536 * (to_int b2 %% 128);
          if (v < q) {
            cs <- rcons cs v;
          }
          ctx <- ctx + 3;
        }
        mA <- updm mA r s (toRq cs);
        s <- s + 1;
      }
      r <- r + 1;
    }
    return mA;
  }
}.

(*************************************)
(**** The scheme              ********)
(*************************************)

module MLDSA (XA : XOF_A, XC : SIB.XOF_t, Htr : Hash_tr, Hmu : Hash_mu, Hct : Hash_ct) = {
  proc keygen() : PK * SK = {
    var rho, mA, s1, s2, t, pk, tr;
    rho <$ dseed;
    mA  <@ ExpandA(XA).get(rho);
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
    var rho, tr, s1, s2, t0, mA, mu, y, w, w1;
    var lc, lz, leak;
    var b1, b2, b3, b4;
    ct <- witness;
    b3 <- witness;
    b4 <- witness;

    (rho, tr, s1, s2, t0) <- sk;
    mA <@ ExpandA(XA).get(rho);
    mu <@ Hmu.get(tr, m);

    leak <- Empty;
    response <- None;
    ctr <- 0;
    while (response = None /\ ctr < kappa_max) {
      y  <$ dvector dRq_mask l;
      w  <- mA *^ y;
      w1 <- highBitsV w;
      ct <@ Hct.get(w1, mu);
      (c, lc) <@ SIB.SampleInBall(XC).get(ct);
      z  <- y + c ** s1;
      b1 <- inf_normv z < gamma1 - beta_;
      b2 <- inf_normv (lowBitsV (w - c ** s2)) < gamma2 - beta_;
      if (b1 /\ b2) {
        h  <- makeHintV (- c ** t0) (w - c ** s2 + c ** t0);
        b3 <- inf_normv (c ** t0) < gamma2;
        b4 <- check_hw h;
        if (b3 /\ b4) {
          response <- Some (z, h);
        }
      }
      lz   <- ite (b1 /\ b2) (ite b3 (ite b4 Empty Empty) Empty) Empty;
      leak <- catFS leak (response = None, (Empty, lc, lz));
      ctr  <- ctr + 1;
    }
    return (omap (fun r => (ct, r)) response, leak);
  }

  proc verify(pk : PK, m : M, sig : Sig) : bool = {
    var rho, t1, ct, ct', response, z, h, mA, tr, mu, c, lc, w1;
    (rho, t1) <- pk;
    (ct, response) <- sig;
    (z, h) <- response;
    mA <@ ExpandA(XA).get(rho);
    tr <@ Htr.get(pk);
    mu <@ Hmu.get(tr, m);
    (c, lc) <@ SIB.SampleInBall(XC).get(ct);
    w1 <- useHintV h (mA *^ z - c ** base2shiftV t1);
    ct' <@ Hct.get(w1, mu);
    return size z = l /\ size h = k /\ inf_normv z < gamma1 - beta_ /\ ct = ct';
  }
}.

end MLDSATarget.
