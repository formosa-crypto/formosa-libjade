require import AllCore IntDiv List Distr DList PROM FMap.
from Jasmin require import JByte_array JWord.
require import Array256.

require import Parameters GFq Rq.
require MLDSA_ROSep_Hop14.
require import MLDSA_RO MLDSA_ROSep MLDSA_ROSep_Hop1 MLDSA_ROSep_Hop2 MLDSA_ROSep_Hop3.
require import MLDSA_ROSep_Hop4 MLDSA_ROSep_Hop5 MLDSA_ROSep_Hop6 MLDSA_ROSep_Hop7 MLDSA_ROSep_Hop8.
require import MLDSA_ROSep_Hop9 MLDSA_ROSep_Hop10 MLDSA_ROSep_Hop11 MLDSA_ROSep_Hop12 MLDSA_ROSep_Hop13.
require import MLDSA_ROSep_Hop14.
require import ConcreteDRing MLDSATargetFIPS Leakage.
require DS_ROM.

abstract theory MLDSA_ROSep_Hop15.

clone include MLDSA_ROSep_Hop14.MLDSA_ROSep_Hop14.
import Spec.
import PolyLVec PolyKVec PolyMat.
import Round ZModQ Zq MLDSAParams.

import PolyReduce.
import DV DV.MatRq.Vectors DV.MatRq.Matrices.

(*************** SampleInBall of FIPS 204 and SampleInBall of the target ****************)

lemma w2bits_int2bs (b : W8.t) : W8.w2bits b = BitEncoding.BS2Int.int2bs 8 (W8.to_uint b).
proof. by rewrite W8.to_uintE -(W8.size_w2bits' b) BitEncoding.BS2Int.bs2intK. qed.

equiv sib_15 : SampleInBall_B(XCw(DST.RO2.RO)).sample ~ MP.T.SIB.SampleInBall(DST.RO2.RO).get :
  rho{1} = x{2} /\ ={DST.RO2.RO.m}
  ==> poly2alg res{1}.`1 = res{2}.`1 /\ res{1}.`2 = res{2}.`2 /\ ={DST.RO2.RO.m}.
proof.
proc.
inline{1} SqueezeB(XCw(DST.RO2.RO)).squeeze.
seq 7 6 : (={DST.RO2.RO.m} /\ x{2} = rho{1} /\ r{1} = signs{2} /\ size signs{2} = 8 /\ ctx{2} = 8 /\
           leak{1} = [] /\ leak{2} = [] /\ c{1} = poly_zero /\ challenge{2} = nseq 256 0).
+ while (={DST.RO2.RO.m} /\ x{2} = rho{1} /\ x{1} = BytesCT.to_list rho{1} /\ len{1} = 8 /\ i0{1} = ctx{2} /\
         r{1} = signs{2} /\ size signs{2} = ctx{2} /\ 0 <= ctx{2} <= 8 /\ leak{1} = [] /\ leak{2} = [] /\
         c{1} = poly_zero /\ challenge{2} = nseq 256 0).
  - inline{1} XCw(DST.RO2.RO).get; wp; call (: ={DST.RO2.RO.m}); 1: by sim.
    auto => /> &1 &2 *; smt(BytesCT.to_listK size_rcons cats1).
  by auto => />; smt().
seq 5 1 : (={i, DST.RO2.RO.m} /\ x{2} = rho{1} /\ pos{1} = ctx{2} /\
           leak{1} = leak{2} /\ h{1} = MP.T.SIB.to_bool_list signs{2} /\ size challenge{2} = 256 /\
           (forall k, 0 <= k < 256 => c{1}.[k] = incoeff (nth 0 challenge{2} k)) /\ 0 <= i{1} /\
           signs{2} = Bytes8.to_list s{1}).
+ auto => />.
  move=> &2 hs.
  rewrite Bytes8.of_listK // /BytesToBits /MP.T.SIB.to_bool_list /(\o) /=.
  split; 1: by congr; apply eq_map => b; rewrite w2bits_int2bs.
  split; 1: by rewrite size_nseq.
  split; 2: by have /= H := param_sets; smt().
  move=> k hk0 hk; rewrite nth_nseq //= /poly_zero Array256.createiE //; smt(incoeff0).
while (={i, DST.RO2.RO.m} /\ x{2} = rho{1} /\ pos{1} = ctx{2} /\
       leak{1} = leak{2} /\ h{1} = MP.T.SIB.to_bool_list signs{2} /\ size challenge{2} = 256 /\
       (forall k, 0 <= k < 256 => c{1}.[k] = incoeff (nth 0 challenge{2} k)) /\ 0 <= i{1} /\
           signs{2} = Bytes8.to_list s{1}).
- inline{1} XCw(DST.RO2.RO).get.
  unroll{2} 2.
  rcondt{2} 2; 1: by auto => /> /#.
  seq 5 5 : (={i, DST.RO2.RO.m} /\ x{2} = rho{1} /\ pos{1} = ctx{2} /\ j{2} = to_uint j{1} /\
             leak{1} = leak{2} /\ h{1} = MP.T.SIB.to_bool_list signs{2} /\ size challenge{2} = 256 /\
             (forall k, 0 <= k < 256 => c{1}.[k] = incoeff (nth 0 challenge{2} k)) /\ 0 <= i{1} < 256 /\
             signs{2} = Bytes8.to_list s{1}).
  + wp; call (: ={DST.RO2.RO.m}); 1: by sim.
    auto => />; smt(BytesCT.to_listK).
  wp.
  while (={i, DST.RO2.RO.m} /\ x{2} = rho{1} /\ pos{1} = ctx{2} /\ j{2} = to_uint j{1} /\
         leak{1} = leak{2} /\ h{1} = MP.T.SIB.to_bool_list signs{2} /\ size challenge{2} = 256 /\
         (forall k, 0 <= k < 256 => c{1}.[k] = incoeff (nth 0 challenge{2} k)) /\ 0 <= i{1} < 256 /\
             signs{2} = Bytes8.to_list s{1}).
  + wp; call (: ={DST.RO2.RO.m}); 1: by sim.
    auto => />; smt(BytesCT.to_listK).
  auto => />.
  move=> &1 &2 hsz hc hi0 hi j _ _.
  split; 1: by rewrite !size_put.
  split; 2: smt().
  move=> k hk0 hk.
  have /= hJ := W8.to_uint_cmp j.
  rewrite !Array256.get_setE; 1,2: smt().
  rewrite !nth_put ?size_put ?hsz; 1,2: smt().
  case: (k = to_uint j) => [-> /= | hkj].
  + have -> : (MP.T.SIB.to_bool_list (Bytes8.to_list s{1})).[i{2} + tau - n] = MP.T.SIB.to_bool (Bytes8.to_list s{1}) (i{2} + tau - n) by done.
    by case: (MP.T.SIB.to_bool (Bytes8.to_list s{1}) (i{2} + tau - n)).
  rewrite (_ : (to_uint j = k) = false) 1:/# /=.
  case: (k = i{2}) => [-> /= | hki]; 2: by rewrite (_ : (i{2} = k) = false) 1:/# /= hc.
  rewrite hc //; smt(nth_change_dfl).
auto => />.
move=> &1 &2 _ _ _ c ch i _ _ hsz hc _.
apply polyXnD1_eqP => k hk.
rewrite poly2algiE // /to_challenge polyLXE; 1: by rewrite size_map hsz.
by rewrite (nth_map 0 Zq.zero incoeff) 1:/# hc.
qed.

(*************** G15: SampleInBall of the target ****************)

module MLDSA_RO_DS15(XA : DST.POracle1, XC : DST.POracle2, Htr : DST.POracle3, Hmu : DST.POracle4,
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
    var coins, rho, tr, s1, s2, t0, mA, la, mu, kappa, y, w, w1, ct, c, lc, z, h, leakage, sigma, w0, ct0_ok;
    var z_fail, r0_fail, hint_fail : int option;
    var zh : (vector * bool list list) option;
    coins <$ drnd;
    ct <- witness;
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
      leakage <- lcat leakage (MP.T.ct_leak ct);
      (c, lc) <@ MP.T.SIB.SampleInBall(XC).get(ct);
      leakage <- lcat leakage lc;
      leakage <- lcat leakage (MP.T.c_leak c);
      z <- vec_of_l y + c ** s1;
      z_fail <- check_z z;
      leakage <- lcat leakage (oileak z_fail);
      if (z_fail = None) {
        w0 <- w - c ** s2;
        r0_fail <- check_r0 w0;
        leakage <- lcat leakage (oileak r0_fail);
        if (r0_fail = None) {
          h <- makeHintV (- (c ** t0)) (w0 + c ** t0);
          hint_fail <- hint_fail_idx h;
          leakage <- lcat leakage (oileak hint_fail);
          (* test on c t0: a public computation of the leaked (c, t0) *)
          ct0_ok <- check_ct0 (c ** t0);
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
      (c, l) <@ MP.T.SIB.SampleInBall(XC).get(ct);
      w1 <- useHintV (hints_of (oget h)) (mA *^ vec_of_l z - c ** base2shiftV (t1_of t1));
      ctp <@ Hct.get(w1, mu);
      rb <- inf_normv (vec_of_l z) < gamma1 - Beta;
      rb <- rb && ct = ctp;
    }
    return rb;
  }
}.

(*************** G14 and G15 ****************)

equiv keygen_15 :
  MLDSA_RO_DS14(DST.RO1.RO, XCw(DST.RO2.RO), DST.RO3.RO, DST.RO4.RO, DST.RO5.RO).keygen ~
  MLDSA_RO_DS15(DST.RO1.RO, DST.RO2.RO, DST.RO3.RO, DST.RO4.RO, DST.RO5.RO).keygen :
  ={glob DST.RO1.RO, glob DST.RO3.RO} ==> ={res, glob DST.RO1.RO, glob DST.RO3.RO, RO_y.RO.m}.
proof. by sim. qed.

equiv sign_15 :
  MLDSA_RO_DS14(DST.RO1.RO, XCw(DST.RO2.RO), DST.RO3.RO, DST.RO4.RO, DST.RO5.RO).sign ~
  MLDSA_RO_DS15(DST.RO1.RO, DST.RO2.RO, DST.RO3.RO, DST.RO4.RO, DST.RO5.RO).sign :
  ={sk, m, glob DST.RO1.RO, glob DST.RO2.RO, glob DST.RO4.RO, glob DST.RO5.RO, RO_y.RO.m}
  ==> ={res, glob DST.RO1.RO, glob DST.RO2.RO, glob DST.RO4.RO, glob DST.RO5.RO, RO_y.RO.m}.
proof.
proc.
seq 12 11 : (={coins, ct, sigma, leakage, rho, tr, s1, s2, t0, mA, mu, kappa, zh, glob DST.RO1.RO,
               glob DST.RO2.RO, glob DST.RO4.RO, glob DST.RO5.RO, RO_y.RO.m}).
+ wp; call (: ={glob DST.RO4.RO}); 1: by sim.
  wp; call (: ={glob DST.RO1.RO}); 1: by sim.
  by auto.
seq 1 1 : (={ct, sigma, leakage, zh, glob DST.RO1.RO, glob DST.RO2.RO, glob DST.RO4.RO, glob DST.RO5.RO, RO_y.RO.m}).
+ while (={coins, ct, sigma, leakage, s1, s2, t0, mA, mu, kappa, zh, glob DST.RO1.RO, glob DST.RO2.RO,
           glob DST.RO4.RO, glob DST.RO5.RO, RO_y.RO.m}); 2: by auto.
  wp; call sib_15.
  wp; call (: ={glob DST.RO5.RO}); 1: by sim.
  wp; call (: ={RO_y.RO.m}); 1: by sim.
  auto => />.
  by move=> &2 _ y ct [c sl] [c' lc] /= <- ->; rewrite ct_leakE -!catA; smt().
by if => //; wp; call (: true); [by sim | auto].
qed.

equiv verify_15 :
  MLDSA_RO_DS14(DST.RO1.RO, XCw(DST.RO2.RO), DST.RO3.RO, DST.RO4.RO, DST.RO5.RO).verify ~
  MLDSA_RO_DS15(DST.RO1.RO, DST.RO2.RO, DST.RO3.RO, DST.RO4.RO, DST.RO5.RO).verify :
  ={pk, m, sigma, glob DST.RO1.RO, glob DST.RO2.RO, glob DST.RO3.RO, glob DST.RO4.RO, glob DST.RO5.RO}
  ==> ={res}.
proof.
proc.
seq 4 4 : (={pk, m, rho, t1, ct, z, h, rb, glob DST.RO1.RO, glob DST.RO2.RO, glob DST.RO3.RO, glob DST.RO4.RO,
             glob DST.RO5.RO}).
+ by call (: true); [by sim | call (: true); [by sim | auto]].
if => //.
wp; call (: ={glob DST.RO5.RO}); 1: by sim.
wp; call sib_15.
call (: ={glob DST.RO4.RO}); 1: by sim.
call (: ={glob DST.RO3.RO}); 1: by sim.
call (: ={glob DST.RO1.RO}); 1: by sim.
auto => />.
by move=> &2 _ mA [c l] [c' l'] /= <- _; congr.
qed.

module G15(A : DS2.Adversary) = {
  module O = {
    proc sign(m : W8.t list) : BytesSig.t option * leakage = {
      var r;
      G13.qs <- m :: G13.qs;
      r <@ MLDSA_RO_DS15(DST.RO1.RO, DST.RO2.RO, DST.RO3.RO, DST.RO4.RO, DST.RO5.RO).sign(G13.sk, m);
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
    (pk, G13.sk) <@ MLDSA_RO_DS15(DST.RO1.RO, DST.RO2.RO, DST.RO3.RO, DST.RO4.RO, DST.RO5.RO).keygen();
    (m, s) <@ Router11(A, XAw(DST.RO1.RO), XCw(DST.RO2.RO), Htrw(DST.RO3.RO), DST.RO4.RO,
                       Hctw(DST.RO5.RO), O).forge(pk);
    b <@ MLDSA_RO_DS15(DST.RO1.RO, DST.RO2.RO, DST.RO3.RO, DST.RO4.RO, DST.RO5.RO).verify(pk, m, s);
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

lemma G14_G15 &m : Pr[G14(A).main() @ &m : res] = Pr[G15(A).main() @ &m : res].
proof.
byequiv (: ={glob A} ==> ={res}) => //.
proc.
inline{1} Router11(A, XAw(DST.RO1.RO), XCw(DST.RO2.RO), Htrw(DST.RO3.RO), DST.RO4.RO, Hctw(DST.RO5.RO), G14(A).O).forge.
inline{2} Router11(A, XAw(DST.RO1.RO), XCw(DST.RO2.RO), Htrw(DST.RO3.RO), DST.RO4.RO, Hctw(DST.RO5.RO), G15(A).O).forge.
wp; call verify_15.
wp; call (: ={glob DST.RO1.RO, glob RO_xr.RO, glob DST.RO2.RO, glob DST.RO3.RO, glob DST.RO4.RO, glob DST.RO5.RO,
              RO_y.RO.m, RO_rest.RO.m, RO_pad.RO.m, RO_hr.RO.m, Router11.tr, G13.qs, G13.sk}).
+ by proc; call sign_15; auto.
+ by sim.
+ by sim.
call (: ={glob DST.RO3.RO}); 1: by sim.
inline{1} RO_rest.RO.init RO_pad.RO.init RO_hr.RO.init; inline{2} RO_rest.RO.init RO_pad.RO.init RO_hr.RO.init; wp.
call keygen_15.
by inline *; auto.
qed.

end section.

end MLDSA_ROSep_Hop15.
