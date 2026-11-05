require import AllCore IntDiv List Distr DList PROM FMap.
from Jasmin require import JByte_array JWord.
require import Array256.

require import Parameters GFq Rq.
require MLDSA_ROSep_Hop13.
require import MLDSA_RO MLDSA_ROSep MLDSA_ROSep_Hop1 MLDSA_ROSep_Hop2 MLDSA_ROSep_Hop3.
require import MLDSA_ROSep_Hop4 MLDSA_ROSep_Hop5 MLDSA_ROSep_Hop6 MLDSA_ROSep_Hop7 MLDSA_ROSep_Hop8.
require import MLDSA_ROSep_Hop9 MLDSA_ROSep_Hop10 MLDSA_ROSep_Hop11 MLDSA_ROSep_Hop12 MLDSA_ROSep_Hop13.
require import ConcreteDRing MLDSATargetFIPS.
require DS_ROM.

require import Leakage.
abstract theory MLDSA_ROSep_Hop14.

clone include MLDSA_ROSep_Hop13.MLDSA_ROSep_Hop13.
import Spec.
import PolyLVec PolyKVec PolyMat.
import Round ZModQ Zq MLDSAParams.

import PolyReduce.
import DV DV.MatRq.Vectors DV.MatRq.Matrices.

(*************** RejNTTPoly and the ExpandA of the target ****************)

lemma xa_key_seed (rho : Bytes32.t) (r s p : int) :
  0 <= r < 256 => 0 <= s < 256 =>
  xa_key (Bytes34.to_list (Bytes34.of_list (Bytes32.to_list rho ++ [W8.of_int s; W8.of_int r])), p) = ((rho, r, s), p).
proof.
move=> hr hs; rewrite /xa_key Bytes34.of_listK; 1: by rewrite size_cat Bytes32.size_to_list.
rewrite /= take_cat Bytes32.size_to_list /= ?take0 ?cats0 Bytes32.to_listK.
by rewrite !nth_cat Bytes32.size_to_list /= ?W8.of_uintK /=; smt().
qed.

op filled (aa : polymat) (mA : matrix) (p : int) =
  forall i j, 0 <= i < kvec => 0 <= j < lvec => i * lvec + j < p => mA.[i, j] = poly2alg (invntt aa.[i * lvec + j]).

lemma filled_upd (aa : polymat) (mA : matrix) (r s : int) (c : Rq.poly) (cs : int list) :
  0 <= r < kvec => 0 <= s < lvec => size mA = (kvec, lvec) => filled aa mA (r * lvec + s) => size cs = n =>
  (forall i, 0 <= i < n => c.[i] = incoeff (nth 0 cs i)) =>
  filled aa.[(r, s) <- c] (updm mA r s (toRq cs)) (r * lvec + s + 1).
proof.
move=> hr hs [hrow hcol] hf hcs hc i j hi hj hij.
rewrite get_updm; 1,2: smt().
case: ((i, j) = (r, s)) => [[-> ->] | hne] /=.
+ have /= H := param_sets.
  rewrite /PolyMat."_.[_<-_]" /= KLMatrix.get_setE; 1: smt().
  rewrite /toRq /=; congr; congr.
  by apply Array256.ext_eq => k hk; rewrite Array256.get_of_list // (nth_map 0 witness incoeff) 1:/# hc.
have /= H := param_sets.
have hne' : i * lvec + j <> r * lvec + s.
+ apply/negP => heq; apply hne; have [-> ->] // := euclideU lvec i r j s heq _ _; smt(gt0_l).
have h1 : (r + 1) * lvec <= kvec * lvec by apply StdOrder.IntOrder.ler_wpmul2r; smt(gt0_l).
have h0 : 0 <= r * lvec by smt(StdOrder.IntOrder.mulr_ge0 gt0_l).
rewrite /PolyMat."_.[_<-_]" /= KLMatrix.get_setE; 1: smt().
rewrite ifF //.
apply hf => //; smt().
qed.

lemma filled_end (aa : polymat) (mA : matrix) :
  size mA = (kvec, lvec) => filled aa mA (kvec * lvec) => mA = mat_of (invnttm aa).
proof.
move=> [hrow hcol] hf; apply eq_matrixP; rewrite /mat_of /=; split; 1: smt(gt0_k gt0_l).
move=> i j [hi hj].
have h1 : (i + 1) * lvec <= kvec * lvec by apply StdOrder.IntOrder.ler_wpmul2r; smt(gt0_l).
have h0 : 0 <= i * lvec by smt(StdOrder.IntOrder.mulr_ge0 gt0_l).
rewrite get_offunm /=; 1: smt().
rewrite /invnttm KLMatrix.mapiE; 1: smt().
apply hf; smt().
qed.

(* The matrix of the target is the inverse NTT of the matrix of the
   specification, and the leakages are equal: the candidates read are the
   same integers ([rej_cand] is the [v] of the target) *)
equiv expandA_14 : ExpandA(XOFA_O(XAw(DST.RO1.RO))).sample ~ MP.T.ExpandA(DST.RO1.RO).get :
  ={rho, DST.RO1.RO.m, RO_xr.RO.m} ==>
  res{2} = (mat_of (invnttm res{1}.`1), res{1}.`2) /\ ={DST.RO1.RO.m, RO_xr.RO.m}.
proof.
proc.
while (={r, rho, DST.RO1.RO.m, RO_xr.RO.m} /\ 0 <= r{1} <= kvec /\ size mA{2} = (kvec, lvec) /\
       al{1} = la{2} /\ filled aa{1} mA{2} (r{1} * lvec)).
- wp; while (={r, s, rho, DST.RO1.RO.m, RO_xr.RO.m} /\ 0 <= r{1} < kvec /\ 0 <= s{1} <= lvec /\
             size mA{2} = (kvec, lvec) /\ al{1} = la{2} /\ filled aa{1} mA{2} (r{1} * lvec + s{1})).
  + wp.
    inline{1} RejNTTPoly(XOFA_O(XAw(DST.RO1.RO))).sample XOFA_O(XAw(DST.RO1.RO)).init.
    inline{2} MP.T.ExpandA(DST.RO1.RO).poly.
    wp; while (={r, s, rho, DST.RO1.RO.m, RO_xr.RO.m} /\ 0 <= r{1} < kvec /\ 0 <= s{1} < lvec /\
               size mA{2} = (kvec, lvec) /\ filled aa{1} mA{2} (r{1} * lvec + s{1}) /\
               al{1} = la{2} /\ vs0{1} = vs0{2} /\ x{2} = (rho{2}, r{2}, s{2}) /\
               XOFA_O.seed{1} = Bytes34.of_list (Bytes32.to_list rho{1} ++ [W8.of_int s{1}; W8.of_int r{1}]) /\
               XOFA_O.pos{1} = ctx{2} /\ j{1} = size cs{2} /\ 0 <= j{1} <= 256 /\
               (forall i, 0 <= i < j{1} => c{1}.[i] = incoeff (nth 0 cs{2} i))).
    * inline{1} XOFA_O(XAw(DST.RO1.RO)).next XAw(DST.RO1.RO).get.
      rcondt{1} 2; 1: by move=> &m; auto => /> *; rewrite Bytes34.size_to_list.
      rcondt{1} 5; 1: by move=> &m; inline *; auto => /> *; rewrite Bytes34.size_to_list.
      rcondt{1} 8; 1: by move=> &m; inline *; auto => /> *; rewrite Bytes34.size_to_list.
      wp; call (: ={DST.RO1.RO.m}); 1: by sim.
      wp; call (: ={DST.RO1.RO.m}); 1: by sim.
      wp; call (: ={DST.RO1.RO.m}); 1: by sim.
      auto => />.
      move=> &1 &2 hr0 hr hs0 hs hrow hcol hf hj0 hj hc hjn.
      have /= H := param_sets.
      have hk : forall p, xa_key (Bytes34.to_list (Bytes34.of_list (Bytes32.to_list rho{2} ++
                                   [W8.of_int s{2}; W8.of_int r{2}])), p) = ((rho{2}, r{2}, s{2}), p)
        by move=> p; apply xa_key_seed; smt().
      rewrite !hk /= => _ _ _ b0 _ _ _ b1 _ _ _ b2.
      rewrite cftb_E /rej_cand /Byte.to_int /=.
      case: (to_uint b0 + 256 * to_uint b1 + 65536 * (to_uint b2 %% 128) < q) => hv /=;
        smt(size_rcons nth_rcons Array256.get_setE).
    auto => />.
    move=> &1 &2 hr0 hr hs0 hs hrow hcol hf hsl.
    split; 1: smt().
    move=> c cs h1 _ h2 h3 hc.
    have hcs : size cs = n by smt().
    split; 1: smt().
    split; 1: by have := size_updm mA{2} r{2} s{2} (toRq cs); rewrite hrow hcol.
    rewrite (_ : r{2} * lvec + (s{2} + 1) = r{2} * lvec + s{2} + 1) 1:/#.
    apply filled_upd => //; smt().
  auto => /> &1 &2 hr0 _ hrow hcol hf hr.
  move=> aa mA s hs1 hs0 hs2 hrow' hcol' hf' hf2.
  split; 1: smt().
  by rewrite (_ : (r{2} + 1) * lvec = r{2} * lvec + s) 1:/#.
auto => />; split.
+ rewrite /filled; smt(gt0_k gt0_l StdOrder.IntOrder.mulr_ge0).
move=> aa mA r hr1 _ hr0 hrk hrow hcol hf.
apply filled_end; 1: by rewrite hrow hcol.
by rewrite (_ : kvec = r) 1:/#.
qed.

(*************** G14: ExpandA of the target ****************)

module MLDSA_RO_DS14(XA : DST.POracle1, XC : DS11.POracle2, Htr : DST.POracle3, Hmu : DST.POracle4,
                     Hct : DST.POracle5) = {
  proc keygen() : BytesPK.t * MP.T.SK = {
    var rho, mA, la, s1, s2, t, pk, tr;
    RO_y.RO.init();
    rho <$ dxi;
    (mA, la) <@ MP.T.ExpandA(XA).get(rho);
    s1 <$ dvector (DR.dRq_ Eta) lvec;
    s2 <$ dvector (DR.dRq_ Eta) kvec;
    t <- mA *^ s1 + s2;
    pk <@ PkEncDec.pkEncode(rho, poly_of_t1 (base2highbitsV t));
    tr <@ Htrw(Htr).get(pk);
    return (pk, (rho, tr, s1, s2, base2lowbitsV t));
  }

  proc sign(sk : MP.T.SK, m : W8.t list) : BytesSig.t option * leakage = {
    var coins, rho, tr, s1, s2, t0, mA, la, mu, kappa, y, w, w1, ctl, ct, c, cr, z, h, leakage, sigma, w0, ct0_ok, sl;
    var z_fail, r0_fail, hint_fail : int option;
    var zh : (vector * bool list list) option;
    coins <$ drnd;
    ct <- witness;
    ctl <- witness;
    sigma <- witness;
    (rho, tr, s1, s2, t0) <- sk;
    leakage <- MP.T.rho_leak rho;
    (mA, la) <@ MP.T.ExpandA(XA).get(rho);
    leakage <- lcat leakage la;
    leakage <- lcat leakage (MP.T.t0_leak t0);
    mu <@ Hmu.get(tr, m);
    kappa <- 0;
    zh <- None;
    while (zh = None && ! (kappa_max <= kappa)) {
      y <@ RO_y.RO.get(coins, mu, kappa);
      w <- mA *^ vec_of_l y;
      w1 <- highBitsV w;
      ct <@ Hct.get(w1, mu);
      (c, sl) <@ SampleInBall_B(XC).sample(ct);
      ctl <- ((ct, c), sl);
      leakage <- lcat leakage (ctilde_leak ct);
      leakage <- lcat leakage ctl.`2;
      cr <- poly2alg c;
      leakage <- lcat leakage (MP.T.c_leak cr);
      z <- vec_of_l y + cr ** s1;
      z_fail <- check_z z;
      leakage <- lcat leakage (oileak z_fail);
      if (z_fail = None) {
        w0 <- w - cr ** s2;
        r0_fail <- check_r0 w0;
        leakage <- lcat leakage (oileak r0_fail);
        if (r0_fail = None) {
          h <- makeHintV (- (cr ** t0)) (w0 + cr ** t0);
          hint_fail <- hint_fail_idx h;
          leakage <- lcat leakage (oileak hint_fail);
          (* test on c t0: a public computation of the leaked (c, t0) *)
          ct0_ok <- check_ct0 (cr ** t0);
          if (ct0_ok /\ hint_fail = None) { zh <- Some (z, h); }
        }
      }
      kappa <- kappa + 1;
    }
    if (zh <> None) {
      sigma <@ SigEncDec.sigEncode(ct, l_of_vec (oget zh).`1, poly_of_hints (oget zh).`2);
    }
    return (if zh = None then None else Some sigma, leakage);
  }

  proc verify(pk : BytesPK.t, m : W8.t list, sigma : BytesSig.t) : bool = {
    var rho, t1, c, l, ct, z, h, rb, mA, la, tr, mu, w1, ctp;
    w1 <- witness;
    rb <- false;
    (rho, t1) <@ PkEncDec.pkDecode(pk);
    (ct, z, h) <@ SigEncDec.sigDecode(sigma);
    if (h <> None) {
      (mA, la) <@ MP.T.ExpandA(XA).get(rho);
      tr <@ Htrw(Htr).get(pk);
      mu <@ Hmu.get(tr, m);
      (c, l) <@ SampleInBall_B(XC).sample(ct);
      w1 <- useHintV (hints_of (oget h)) (mA *^ vec_of_l z - poly2alg c ** base2shiftV (t1_of t1));
      ctp <@ Hct.get(w1, mu);
      rb <- inf_normv (vec_of_l z) < gamma1 - Beta;
      rb <- rb && ct = ctp;
    }
    return rb;
  }
}.

(*************** G13 and G14 ****************)

equiv keygen_14 :
  MLDSA_RO_DS13(XAw(DST.RO1.RO), XCw(DST.RO2.RO), DST.RO3.RO, DST.RO4.RO, DST.RO5.RO).keygen ~
  MLDSA_RO_DS14(DST.RO1.RO, XCw(DST.RO2.RO), DST.RO3.RO, DST.RO4.RO, DST.RO5.RO).keygen :
  ={glob DST.RO1.RO, glob RO_xr.RO, glob DST.RO3.RO}
  ==> ={res, glob DST.RO1.RO, glob RO_xr.RO, glob DST.RO3.RO, RO_y.RO.m}.
proof.
proc; call (: ={glob DST.RO3.RO}); 1: by sim.
wp; call (: true); 1: by sim.
wp; rnd; rnd; wp; call expandA_14; inline RO_y.RO.init; auto.
qed.

equiv sign_14 :
  MLDSA_RO_DS13(XAw(DST.RO1.RO), XCw(DST.RO2.RO), DST.RO3.RO, DST.RO4.RO, DST.RO5.RO).sign ~
  MLDSA_RO_DS14(DST.RO1.RO, XCw(DST.RO2.RO), DST.RO3.RO, DST.RO4.RO, DST.RO5.RO).sign :
  ={sk, m, glob DST.RO1.RO, glob RO_xr.RO, glob DST.RO2.RO, glob DST.RO4.RO, glob DST.RO5.RO, RO_y.RO.m}
  ==> ={res, glob DST.RO1.RO, glob RO_xr.RO, glob DST.RO2.RO, glob DST.RO4.RO, glob DST.RO5.RO, RO_y.RO.m}.
proof.
proc.
seq 10 9 : (={sk, m, coins, ct, ctl, sigma, leakage, rho, tr, s1, s2, t0, mA, glob DST.RO1.RO, glob RO_xr.RO,
             glob DST.RO2.RO, glob DST.RO4.RO, glob DST.RO5.RO, RO_y.RO.m}).
+ by wp; call expandA_14; auto.
by sim.
qed.

equiv verify_14 :
  MLDSA_RO_DS13(XAw(DST.RO1.RO), XCw(DST.RO2.RO), DST.RO3.RO, DST.RO4.RO, DST.RO5.RO).verify ~
  MLDSA_RO_DS14(DST.RO1.RO, XCw(DST.RO2.RO), DST.RO3.RO, DST.RO4.RO, DST.RO5.RO).verify :
  ={pk, m, sigma, glob DST.RO1.RO, glob RO_xr.RO, glob DST.RO2.RO, glob DST.RO3.RO, glob DST.RO4.RO, glob DST.RO5.RO}
  ==> ={res}.
proof.
proc.
seq 4 4 : (={pk, m, rho, t1, ct, z, h, rb, glob DST.RO1.RO, glob RO_xr.RO, glob DST.RO2.RO, glob DST.RO3.RO,
             glob DST.RO4.RO, glob DST.RO5.RO}).
+ by call (: true); [by sim | call (: true); [by sim | auto]].
if => //.
seq 2 1 : (={pk, m, rho, t1, ct, z, h, rb, mA, glob DST.RO1.RO, glob RO_xr.RO, glob DST.RO2.RO, glob DST.RO3.RO,
             glob DST.RO4.RO, glob DST.RO5.RO}).
+ by wp; call expandA_14; auto.
by sim.
qed.

module G14(A : DS2.Adversary) = {
  module O = {
    proc sign(m : W8.t list) : BytesSig.t option * leakage = {
      var r;
      G13.qs <- m :: G13.qs;
      r <@ MLDSA_RO_DS14(DST.RO1.RO, XCw(DST.RO2.RO), DST.RO3.RO, DST.RO4.RO, DST.RO5.RO).sign(G13.sk, m);
      return r;
    }
  }

  proc main() : bool = {
    var pk, m, s, b;
    DST.RO1.RO.init();
    RO_xr.RO.init();
    DST.RO2.RO.init();
    DST.RO3.RO.init();
    DST.RO4.RO.init();
    DST.RO5.RO.init();
    G13.qs <- [];
    (pk, G13.sk) <@ MLDSA_RO_DS14(DST.RO1.RO, XCw(DST.RO2.RO), DST.RO3.RO, DST.RO4.RO, DST.RO5.RO).keygen();
    (m, s) <@ Router11(A, XAw(DST.RO1.RO), XCw(DST.RO2.RO), Htrw(DST.RO3.RO), DST.RO4.RO,
                       Hctw(DST.RO5.RO), O).forge(pk);
    b <@ MLDSA_RO_DS14(DST.RO1.RO, XCw(DST.RO2.RO), DST.RO3.RO, DST.RO4.RO, DST.RO5.RO).verify(pk, m, s);
    return b /\ !(m \in G13.qs);
  }
}.

section.

declare module A <: DS2.Adversary {
  -DS2.RO1.RO, -DS2.RO2.RO, -DS2.EUF_CMA, -XOFA_O, -XOFS_O, -MLDSA_RO_DS1, -RoutedH,
  -DS5.RO1.RO, -DS5.RO2.RO, -DS5.RO3.RO, -DS5.RO4.RO, -DS5.RO5.RO, -DS5.EUF_CMA, -RO_rest.RO,
  -RO_pad.RO, -RO_pad.FRO, -RO_seed.RO, -RO_S.RO, -RO_rhopp.RO, -RO_v.RO, -CountH, -CountS, -St5,
  -RO_lp.RO, -RO_lp.FRO, -St6, -St7, -Router, -RO_y.RO, -DS8.EUF_CMA, -DS10.EUF_CMA, -DS10.RO5.RO,
  -RO_hr.RO, -Router10, -DS11.EUF_CMA, -RO_xc.RO, -RO_xc.FRO, -Router11, -DST.RO1.RO, -DST.RO2.RO,
  -DST.RO3.RO, -DST.RO4.RO, -DST.RO5.RO, -DST.EUF_CMA, -RO_xr.RO, -G13 }.

lemma G13_G14 &m : Pr[G13(A).main() @ &m : res] = Pr[G14(A).main() @ &m : res].
proof.
byequiv (: ={glob A} ==> ={res}) => //.
proc.
inline{1} Router11(A, XAw(DST.RO1.RO), XCw(DST.RO2.RO), Htrw(DST.RO3.RO), DST.RO4.RO, Hctw(DST.RO5.RO), G13(A).O).forge.
inline{2} Router11(A, XAw(DST.RO1.RO), XCw(DST.RO2.RO), Htrw(DST.RO3.RO), DST.RO4.RO, Hctw(DST.RO5.RO), G14(A).O).forge.
wp; call verify_14.
wp; call (: ={glob DST.RO1.RO, glob RO_xr.RO, glob DST.RO2.RO, glob DST.RO3.RO, glob DST.RO4.RO, glob DST.RO5.RO,
              RO_y.RO.m, RO_rest.RO.m, RO_pad.RO.m, RO_hr.RO.m, Router11.tr, G13.qs, G13.sk}).
+ by proc; call sign_14; auto.
+ by sim.
+ by sim.
call (: ={glob DST.RO3.RO}); 1: by sim.
inline{1} RO_rest.RO.init RO_pad.RO.init RO_hr.RO.init; inline{2} RO_rest.RO.init RO_pad.RO.init RO_hr.RO.init; wp.
call keygen_14.
by inline *; auto.
qed.

end section.

end MLDSA_ROSep_Hop14.
