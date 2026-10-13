require import AllCore IntDiv List Distr DList DInterval PROM FMap BitEncoding.
from Jasmin require import JByte_array JWord.
require import Array256.

require import Parameters GFq Rq.
require import Spec65.
import MLDSA65.
import PolyLVec PolyKVec PolyMat.
import Round ZModQ Zq MLDSAParams.

require import MLDSA_RO MLDSA_ROSep MLDSA_ROSep_Hop1 MLDSA_ROSep_Hop2 MLDSA_ROSep_Hop3.
require import MLDSA_ROSep_Hop4 MLDSA_ROSep_Hop5 MLDSA_ROSep_Hop6 MLDSA_ROSep_Hop7 MLDSA_ROSep_Hop8.

(*************** G9: the scheme computes without the NTT ****************)

module MLDSA_RO_DS9(XA : DS5.POracle1, XC : DS5.POracle2, Htr : DS5.POracle3, Hmu : DS5.POracle4,
                    Hct : DS5.POracle5) = {
  proc keygen() : BytesPK.t * (Bytes32.t * Bytes64.t * polylvec * polykvec * polykvec) = {
    var rho,_A,s1,s2,t,t1,t0,pk,tr;
    RO_y.RO.init();
    rho <$ dxi;
    _A <@ ExpandA(XOFA_O(XA)).sample(rho);
    s1 <$ dpolyl (dpoly (-Eta) Eta);
    s2 <$ dpolyk (dpoly (-Eta) Eta);
    t <- mulmxv (invnttm _A) s1 + s2;
    (t1,t0) <- Power2Round t;
    pk <@ PkEncDec.pkEncode(rho,t1);
    tr <@ Htr.get(pk);
    return (pk, (rho, tr, s1, s2, t0));
  }

  proc sign(sk : Bytes32.t * Bytes64.t * polylvec * polykvec * polykvec, m : W8.t list) :
    BytesSig.t option * Leakage list = {
     var coins,rho,tr,s1,s2,t0,_A,mu,kappa,y,w,w1,ctl,ct,c,cs1,cs2,z,r0,ct0,h,leakage,sigma,bz,bh,sl;
     var zh : (polylvec * polykvec) option;
     coins <$ drnd;
     ct <- witness;
     ctl <- witness;
     sigma <- witness;
     leakage <- [];
     (rho,tr,s1,s2,t0) <- sk;
     _A <@ ExpandA(XOFA_O(XA)).sample(rho);
     mu <@ Hmu.get(tr, m);
     kappa <- 0;
     zh <- None;
     while (zh = None && ! (kappa_max <= kappa)) {
       y <@ RO_y.RO.get(coins, mu, kappa);
       w <- mulmxv (invnttm _A) y;
       w1 <- polykvec_HighBits w;
       ct <@ Hct.get(mu, w1Encode w1);
       (c, sl) <@ SampleInBall_O(XC).sample(ct);
       ctl <- ((ct, c), sl);
       leakage <- leakage ++ [ RO ctl.`2] ;
       cs1 <- psmul c s1;
       cs2 <- psmul c s2;
       z <- y + cs1;
       r0 <- polykvec_LowBits (w - cs2);
       bz <- infnorm_lt z (gamma1 - Beta) &&
                  infnorm_lt r0 (gamma2 - Beta);
       leakage <- leakage ++ [ CheckZ bz ];
       if (bz) {
          ct0 <- psmul c t0;
          h <- MakeHint (PolyKVec.zerov-ct0) (w - cs2 + ct0);
          bh <- infnorm_lt ct0 gamma2 && hammw h w_hint;
          leakage <- leakage ++ [ CheckH bh ];
          if (bh) { zh <- Some (z,h); }
       }
       kappa <- kappa + 1;
     }
     if (zh <> None) {
       sigma <@ SigEncDec.sigEncode(ct,(oget zh).`1,(oget zh).`2);
     }
     return (if zh = None then None else Some sigma, leakage);
  }

  proc verify(pk : BytesPK.t, m : W8.t list, sigma : BytesSig.t) : bool = {
    var rho,t1,c,l,ct,z,h,rb,_A,tr,mu,wapprox,w1,ctp;
    w1 <- witness;
    rb <- false;
    (rho,t1) <@ PkEncDec.pkDecode(pk);
    (ct,z,h) <@ SigEncDec.sigDecode(sigma);
    if (h <> None) {
      _A <@ ExpandA(XOFA_O(XA)).sample(rho);
      tr <@ Htr.get(pk);
      mu <@ Hmu.get(tr, m);
      (c,l) <@ SampleInBall_O(XC).sample(ct);
      wapprox <- mulmxv (invnttm _A) z - psmul c (smul t1 (incoeff (2^d)));
      w1 <- UseHint (oget h) wapprox;
      ctp <@ Hct.get(mu, w1Encode w1);
      rb <- infnorm_lt z (gamma1 - Beta);
      rb <- rb && ct = ctp;
    }
    return rb;
  }
}.

(*************** G8 and G9 ****************)

equiv keygen89 :
  MLDSA_RO_DS8(DS5.RO1.RO, DS5.RO2.RO, DS5.RO3.RO, DS5.RO4.RO, DS5.RO5.RO).keygen ~
  MLDSA_RO_DS9(DS5.RO1.RO, DS5.RO2.RO, DS5.RO3.RO, DS5.RO4.RO, DS5.RO5.RO).keygen :
  ={glob DS5.RO1.RO, DS5.RO3.RO.m, glob XOFA_O}
  ==> ={res, glob DS5.RO1.RO, DS5.RO3.RO.m, glob XOFA_O, RO_y.RO.m}.
proof.
proc.
call (: ={DS5.RO3.RO.m}); 1: by sim.
wp; call (: true); 1: by sim.
wp; rnd; rnd; call (: ={glob DS5.RO1.RO, glob XOFA_O}); 1: by sim.
by inline *; auto => />; smt(invnttv_ntt_mulmxv).
qed.

equiv sign89 :
  MLDSA_RO_DS8(DS5.RO1.RO, DS5.RO2.RO, DS5.RO3.RO, DS5.RO4.RO, DS5.RO5.RO).sign ~
  MLDSA_RO_DS9(DS5.RO1.RO, DS5.RO2.RO, DS5.RO3.RO, DS5.RO4.RO, DS5.RO5.RO).sign :
  ={sk, m, glob DS5.RO1.RO, DS5.RO2.RO.m, DS5.RO4.RO.m, DS5.RO5.RO.m, glob XOFA_O, RO_y.RO.m}
  ==> ={res, glob DS5.RO1.RO, DS5.RO2.RO.m, DS5.RO4.RO.m, DS5.RO5.RO.m, glob XOFA_O, RO_y.RO.m}.
proof.
proc.
seq 13 10 : (={coins, ct, ctl, sigma, leakage, rho, tr, s1, s2, t0, _A, mu, kappa, zh, glob DS5.RO1.RO,
               DS5.RO2.RO.m, DS5.RO4.RO.m, DS5.RO5.RO.m, glob XOFA_O, RO_y.RO.m} /\
             s1h{1} = PolyLVec.nttv s1{1} /\ s2h{1} = PolyKVec.nttv s2{1} /\ t0h{1} = PolyKVec.nttv t0{1}).
+ wp; call (: ={DS5.RO4.RO.m}); 1: by sim.
  call (: ={glob DS5.RO1.RO, glob XOFA_O}); 1: by sim.
  by auto.
seq 1 1 : (={zh, ct, sigma, leakage, glob DS5.RO1.RO, DS5.RO2.RO.m, DS5.RO4.RO.m, DS5.RO5.RO.m, glob XOFA_O,
             RO_y.RO.m}).
+ while (={coins, ct, ctl, sigma, leakage, s1, s2, t0, _A, mu, kappa, zh, glob DS5.RO1.RO, DS5.RO2.RO.m,
           DS5.RO4.RO.m, DS5.RO5.RO.m, glob XOFA_O, RO_y.RO.m} /\
         s1h{1} = PolyLVec.nttv s1{1} /\ s2h{1} = PolyKVec.nttv s2{1} /\ t0h{1} = PolyKVec.nttv t0{1}).
  - wp; call (: ={DS5.RO2.RO.m}); 1: by sim.
    wp; call (: ={DS5.RO5.RO.m}); 1: by sim.
    wp; call (: ={RO_y.RO.m}); 1: by sim.
    auto => /> &2 _ y; rewrite !invnttv_ntt_mulmxv /= => cl.
    by rewrite !PolyLVec.invnttv_ntt_smul !PolyKVec.invnttv_ntt_smul /=; smt().
  by auto => />.
by if => //; wp; call (: true); [by sim | auto].
qed.

equiv verify89 :
  MLDSA_RO_DS8(DS5.RO1.RO, DS5.RO2.RO, DS5.RO3.RO, DS5.RO4.RO, DS5.RO5.RO).verify ~
  MLDSA_RO_DS9(DS5.RO1.RO, DS5.RO2.RO, DS5.RO3.RO, DS5.RO4.RO, DS5.RO5.RO).verify :
  ={pk, m, sigma, glob DS5.RO1.RO, DS5.RO2.RO.m, DS5.RO3.RO.m, DS5.RO4.RO.m, DS5.RO5.RO.m, glob XOFA_O}
  ==> ={res}.
proof.
proc.
seq 4 4 : (={pk, m, rho, t1, ct, z, h, rb, w1, glob DS5.RO1.RO, DS5.RO2.RO.m, DS5.RO3.RO.m, DS5.RO4.RO.m,
             DS5.RO5.RO.m, glob XOFA_O}); 1: by sim.
if => //.
wp; call (: ={DS5.RO5.RO.m}); 1: by sim.
wp; call (: ={DS5.RO2.RO.m}); 1: by sim.
call (: ={DS5.RO4.RO.m}); 1: by sim.
call (: ={DS5.RO3.RO.m}); 1: by sim.
call (: ={glob DS5.RO1.RO, glob XOFA_O}); 1: by sim.
auto => /> &2 _ a cl.
by rewrite PolyKVec.invnttv_sub invnttv_ntt_mulmxv PolyKVec.invnttv_ntt_smul.
qed.

section.

declare module A <: DS2.Adversary {
  -DS2.RO1.RO, -DS2.RO2.RO, -DS2.EUF_CMA, -XOFA_O, -XOFS_O, -MLDSA_RO_DS1, -RoutedH,
  -DS5.RO1.RO, -DS5.RO2.RO, -DS5.RO3.RO, -DS5.RO4.RO, -DS5.RO5.RO, -DS5.EUF_CMA, -RO_rest.RO,
  -RO_pad.RO, -RO_pad.FRO, -RO_seed.RO, -RO_S.RO, -RO_rhopp.RO, -RO_v.RO, -CountH, -CountS, -St5,
  -RO_lp.RO, -RO_lp.FRO, -St6, -St7, -Router, -RO_y.RO, -DS8.EUF_CMA }.

lemma G8_G9 &m :
  Pr[DS8.EUF_CMA(DS5.RO1.RO, DS5.RO2.RO, DS5.RO3.RO, DS5.RO4.RO, DS5.RO5.RO, MLDSA_RO_DS8, Router(A)).main()
       @ &m : res] =
  Pr[DS8.EUF_CMA(DS5.RO1.RO, DS5.RO2.RO, DS5.RO3.RO, DS5.RO4.RO, DS5.RO5.RO, MLDSA_RO_DS9, Router(A)).main()
       @ &m : res].
proof.
byequiv (: ={glob A, glob XOFA_O} ==> ={res}) => //.
proc.
inline{1} DS8.EUF_CMA(DS5.RO1.RO, DS5.RO2.RO, DS5.RO3.RO, DS5.RO4.RO, DS5.RO5.RO, MLDSA_RO_DS8, Router(A)).A.forge.
inline{2} DS8.EUF_CMA(DS5.RO1.RO, DS5.RO2.RO, DS5.RO3.RO, DS5.RO4.RO, DS5.RO5.RO, MLDSA_RO_DS9, Router(A)).A.forge.
wp; call verify89.
wp; call (: ={RO_pad.RO.m, RO_rest.RO.m, DS5.RO1.RO.m, DS5.RO2.RO.m, DS5.RO3.RO.m, DS5.RO4.RO.m,
              DS5.RO5.RO.m, glob XOFA_O, Router.tr, RO_y.RO.m, DS8.EUF_CMA.qs, DS8.EUF_CMA.sk}).
+ by proc; call sign89; auto.
+ by proc; auto.
+ by proc; inline *; sim.
call (: ={DS5.RO3.RO.m}); 1: by sim.
inline RO_rest.RO.init RO_pad.RO.init; wp.
call keygen89.
by inline *; auto => />.
qed.

(* Hop 9: the NTT is eliminated *)
lemma hop9 (qH qS : int) &m : 0 <= qH => 0 <= qS =>
  (forall (H1 <: DS2.POracle1 {-A}) (H2 <: DS2.POracle2 {-A}) (O <: DS2.SOracle {-A}),
     islossless H1.get => islossless H2.get => islossless O.sign =>
     islossless A(H1, H2, O).forge) =>
  (forall (H <: DS2.POracle1 {-A, -CountH, -CountS}) (G <: DS2.POracle2 {-A, -CountH, -CountS})
          (O <: DS2.SOracle {-A, -CountH, -CountS}),
     hoare [A(CountH(H), G, CountS(O)).forge :
              CountH.c = 0 /\ CountS.c = 0 ==> CountH.c <= qH /\ CountS.c <= qS]) =>
  Pr[DS2.EUF_CMA(DS2.RO1.RO, DS2.RO2.RO, MLDSA_RO_DS1, A).main() @ &m : res] <=
  Pr[DS8.EUF_CMA(DS5.RO1.RO, DS5.RO2.RO, DS5.RO3.RO, DS5.RO4.RO, DS5.RO5.RO, MLDSA_RO_DS9, Router(A)).main()
       @ &m : res] +
  2%r * p512 + (qH + qS * (1 + kappa_max) + 2)%r * p512 +
  ((qS * (qS + qH + 1))%r * p512 + (3 * qH + qS + 4)%r * p256).
proof.
move=> hqH hqS A_ll A_count.
by rewrite -(G8_G9 &m); apply (hop8 A qH qS &m hqH hqS A_ll A_count).
qed.

end section.
