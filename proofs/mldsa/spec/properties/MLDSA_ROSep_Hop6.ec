require import AllCore IntDiv List Distr DList PROM FMap Xreal StdBigop StdOrder.
from Jasmin require import JByte_array JWord.
require import Array256.

require import Parameters GFq Rq.
require MLDSA_ROSep_Hop5.
require import MLDSA_RO MLDSA_ROSep MLDSA_ROSep_Hop1 MLDSA_ROSep_Hop2 MLDSA_ROSep_Hop3.
require import MLDSA_ROSep_Hop4 MLDSA_ROSep_Hop5.

require import Leakage.
abstract theory MLDSA_ROSep_Hop6.

clone include MLDSA_ROSep_Hop5.MLDSA_ROSep_Hop5.
import Spec.
import PolyLVec PolyKVec PolyMat.
import Round ZModQ Zq MLDSAParams.


(*************** G6: the adversary queries five random oracles ****************)

(* The signer of G5 over the five oracles, without the samples nothing reads: xi, r1, rho''
   and the padding of H_ct *)
module MLDSA_RO_DS6(XA : DS5.POracle1, XC : DS5.POracle2, Htr : DS5.POracle3, Hmu : DS5.POracle4,
                    Hct : DS5.POracle5) = {
  proc keygen() : BytesPK.t * BytesSK.t = {
    var sk,rho,_A,s1,s2,t,t1,t0,pk,tr,r0;
    RO_S.RO.init();
    RO_v.RO.init();
    r0 <$ dblock;
    rho <- Bytes32.of_list (take 32 r0);
    _A <@ ExpandA(XOFA_O(XA)).sample(rho);
    (s1,s2) <@ ExpandS(XOFS_O(RO_S.RO)).sample(cS);
    t <- invnttv (ntt_mulmxv _A (nttv s1)) + s2;
    (t1,t0) <- Power2Round t;
    pk <@ PkEncDec.pkEncode(rho,t1);
    tr <@ Htr.get(pk);
    sk <@ SkEncDec.skEncode(rho,cK,tr,s1,s2,t0);
    return (pk,sk);
  }

  proc sign(sk : BytesSK.t, m : W8.t list) : BytesSig.t option * leakage = {
     var coins,rho,_K,tr,s1,s2,t0,s1h,s2h,t0h,_A,mu,kp,kappa,y,w,w1,ctl,ct,c,ch,cs1,
         cs2,z,r0,ct0,h,leakage,sigma,bct0,sl;
     var zf, rf, hf : int option;
     var zh : (polylvec * polykvec) option;
     coins <$ drnd;
     ct <- witness;
     ctl <- witness;
     sigma <- witness;
     rf <- witness;
     hf <- witness;
     (rho,_K,tr,s1,s2,t0) <@ SkEncDec.skDecode(sk);
     s1h <- nttv s1;
     s2h <- nttv s2;
     t0h <- nttv t0;
     leakage <- kvec_leak t0h;
     _A <@ ExpandA(XOFA_O(XA)).sample(rho);
     mu <@ Hmu.get(tr, m);
     kp <- Bytes32.to_list _K ++ rnd_to_list coins ++ Bytes64.to_list mu;
     kappa <- 0;
     zh <- None;
     while (zh = None && ! (kappa_max <= kappa)) {
       y <@ ExpandMask_L(RO_v.RO).sample(kp,kappa * lvec);
       w <- invnttv (ntt_mulmxv _A (nttv y));
       w1 <- polykvec_HighBits w;
       ct <@ Hct.get(mu, w1Encode w1);
       (c, sl) <@ SampleInBall_O(XC).sample(ct);
       ctl <- ((ct, c), sl);
       leakage <- lcat leakage ctl.`2;
       ch <- ntt c;
       leakage <- lcat leakage (poly_leak ch);
       cs1 <- invnttv (ntt_smul ch s1h);
       z <- y + cs1;
       zf <- zfail_idx z;
       leakage <- lcat leakage (oileak zf);
       if (zf = None) {
         cs2 <- invnttv (ntt_smul ch s2h);
         r0 <- polykvec_LowBits (w - cs2);
         rf <- r0fail_idx r0;
         leakage <- lcat leakage (oileak rf);
         if (rf = None) {
           ct0 <- invnttv (ntt_smul ch t0h);
           h <- MakeHint (PolyKVec.zerov-ct0) (w - cs2 + ct0);
           hf <- hintfail_idx h;
           leakage <- lcat leakage (oileak hf);
           (* public test: c and t0 are leaked *)
           bct0 <- infnorm_lt ct0 gamma2;
           if (bct0 /\ hf = None) { zh <- Some (z,h); }
         }
       }
       kappa <- kappa + 1;
     }
     if (zh <> None) {
       sigma <@ SigEncDec.sigEncode(ct,(oget zh).`1,(oget zh).`2);
     }
     return (if zh = None then None else Some sigma, leakage);
  }

  proc verify = MLDSA_ROSep(XA, XC, Htr, Hmu, Hct).verify
}.

(* SHAKE128 moves from the two-oracle game to the five-oracle game *)
equiv xa_get : DS2.RO2.RO.get ~ DS5.RO1.RO.get :
  ={x} /\ DS2.RO2.RO.m{1} = DS5.RO1.RO.m{2} ==> ={res} /\ DS2.RO2.RO.m{1} = DS5.RO1.RO.m{2}.
proof. by proc; auto. qed.

equiv expandA6 : ExpandA(XOFA_O(DS2.RO2.RO)).sample ~ ExpandA(XOFA_O(DS5.RO1.RO)).sample :
  ={rho, glob XOFA_O} /\ DS2.RO2.RO.m{1} = DS5.RO1.RO.m{2}
  ==> ={res, glob XOFA_O} /\ DS2.RO2.RO.m{1} = DS5.RO1.RO.m{2}.
proof.
proc; while (={r, aa, rho, glob XOFA_O} /\ DS2.RO2.RO.m{1} = DS5.RO1.RO.m{2}); 2: by auto.
wp; while (={r, s, aa, rho, glob XOFA_O} /\ DS2.RO2.RO.m{1} = DS5.RO1.RO.m{2}); 2: by auto.
wp; call (: ={rho, glob XOFA_O} /\ DS2.RO2.RO.m{1} = DS5.RO1.RO.m{2}
            ==> ={res, glob XOFA_O} /\ DS2.RO2.RO.m{1} = DS5.RO1.RO.m{2}); 2: by auto.
proc; while (={j, c, glob XOFA_O} /\ DS2.RO2.RO.m{1} = DS5.RO1.RO.m{2}); 2: by inline *; auto.
by wp; inline XOFA_O(DS2.RO2.RO).next XOFA_O(DS5.RO1.RO).next; wp; do 3! call xa_get; auto.
qed.

section.

declare module A <: DS2.Adversary {
  -DS2.RO1.RO, -DS2.RO2.RO, -DS2.EUF_CMA, -XOFA_O, -XOFS_O, -MLDSA_RO_DS1, -RoutedH,
  -DS5.RO1.RO, -DS5.RO2.RO, -DS5.RO3.RO, -DS5.RO4.RO, -DS5.RO5.RO, -DS5.EUF_CMA, -RO_rest.RO,
  -RO_pad.RO, -RO_pad.FRO, -RO_seed.RO, -RO_S.RO, -RO_rhopp.RO, -RO_v.RO, -CountH, -CountS, -St5,
  -RO_lp.RO, -RO_lp.FRO, -St6, -St7, -Router }.

(* H_ct with its padding sampled through P, and the routed SHAKE256 oracle with the padding read
   through P *)
local module HctP (P : RO_pad.RO) = {
  proc get(mu : Bytes64.t, w1 : BytesW1.t) : BytesCT.t = {
    var ct;
    ct <@ DS5.RO5.RO.get(mu, w1);
    P.sample(Bytes64.to_list mu ++ BytesW1.to_list w1);
    return ct;
  }
}.

local module HP (P : RO_pad.RO) = {
  proc get(x : W8.t list * int) : W8.t list = {
    var b, o, oc, pad;
    b <- witness;
    if (take 64 x.`1 = Bytes64.to_list Router.tr) {
      if (x.`2 = 0) {
        o <@ DS5.RO4.RO.get(Router.tr, drop 64 x.`1);
        b <- Bytes64.to_list o;
      } else {
        b <@ RO_rest.RO.get(x);
      }
    } else {
      if (size x.`1 = 64 + w1_bytes) {
        if (x.`2 = 0) {
          oc <@ DS5.RO5.RO.get(Bytes64.of_list (take 64 x.`1), BytesW1.of_list (drop 64 x.`1));
          pad <@ P.get(x.`1);
          b <- BytesCT.to_list oc ++ pad;
        } else {
          b <@ RO_rest.RO.get(x);
        }
      } else {
        if (size x.`1 = lambda %/ 4) {
          b <@ DS5.RO2.RO.get(x);
        } else {
          if (size x.`1 = pk_bytes /\ x.`2 = 0) {
            o <@ DS5.RO3.RO.get(BytesPK.of_list x.`1);
            b <- Bytes64.to_list o;
          } else {
            b <@ RO_rest.RO.get(x);
          }
        }
      }
    }
    return b;
  }
}.

(* G6 with the padding oracle as a parameter *)
local module D7 (P : RO_pad.RO) = {
  module OS = {
    proc sign(m : W8.t list) : BytesSig.t option * leakage = {
      var r;
      DS5.EUF_CMA.qs <- m :: DS5.EUF_CMA.qs;
      r <@ MLDSA_RO_DS6(DS5.RO1.RO, DS5.RO2.RO, DS5.RO3.RO, DS5.RO4.RO, HctP(P)).sign(DS5.EUF_CMA.sk, m);
      return r;
    }
  }

  proc distinguish() : bool = {
    var pk, sk, m, s, b;
    DS5.RO1.RO.init();
    DS5.RO2.RO.init();
    DS5.RO3.RO.init();
    DS5.RO4.RO.init();
    DS5.RO5.RO.init();
    DS5.EUF_CMA.qs <- [];
    (pk, sk) <@ MLDSA_RO_DS6(DS5.RO1.RO, DS5.RO2.RO, DS5.RO3.RO, DS5.RO4.RO, HctP(P)).keygen();
    DS5.EUF_CMA.sk <- sk;
    RO_rest.RO.init();
    Router.tr <@ DS5.RO3.RO.get(pk);
    (m, s) <@ A(HP(P), DS5.RO1.RO, OS).forge(pk);
    b <@ MLDSA_RO_DS6(DS5.RO1.RO, DS5.RO2.RO, DS5.RO3.RO, DS5.RO4.RO, HctP(P)).verify(pk, m, s);
    return b /\ !(m \in DS5.EUF_CMA.qs);
  }
}.

(*************** G5 is D7 with the eager padding oracle ****************)

local equiv getP : RoutedH.get ~ HP(RO_pad.RO).get :
  ={x, RO_pad.RO.m, RO_rest.RO.m, DS5.RO2.RO.m, DS5.RO3.RO.m, DS5.RO4.RO.m, DS5.RO5.RO.m} /\
  RoutedH.trset{1} /\ RoutedH.tr{1} = Router.tr{2}
  ==> ={res, RO_pad.RO.m, RO_rest.RO.m, DS5.RO2.RO.m, DS5.RO3.RO.m, DS5.RO4.RO.m, DS5.RO5.RO.m} /\
      RoutedH.trset{1} /\ RoutedH.tr{1} = Router.tr{2}.
proof.
proc; sp; if; 1: smt().
+ by if => //; inline *; auto => />.
if => //; 1: by if => //; inline *; auto => />.
if => //; 1: by inline *; auto => />.
by if => //; inline *; auto => />.
qed.

(* The pk query of key generation is the one that sets tr *)
local equiv pktr6 (pk0 : BytesPK.t) : Squeeze(RoutedH).squeeze ~ DS5.RO3.RO.get :
  ={RO_pad.RO.m, DS5.RO2.RO.m, DS5.RO3.RO.m, DS5.RO4.RO.m, DS5.RO5.RO.m} /\ RO_rest.RO.m{1} = empty /\
  !RoutedH.trset{1} /\ x{2} = pk0 /\ x{1} = BytesPK.to_list pk0 /\ len{1} = 64
  ==> ={RO_pad.RO.m, DS5.RO2.RO.m, DS5.RO3.RO.m, DS5.RO4.RO.m, DS5.RO5.RO.m} /\ RO_rest.RO.m{1} = empty /\
      RoutedH.trset{1} /\ RoutedH.tr{1} = res{2} /\ res{1} = Bytes64.to_list res{2} /\
      DS5.RO3.RO.m{2}.[pk0] = Some res{2}.
proof.
proc; sp; rcondt{1} 1; 1: by auto.
rcondf{1} 4; 1: by move=> &m; wp; call (: true); auto.
inline{1} RoutedH.get; sp; rcondf{1} 1; 1: by move=> &m; skip => />.
rcondf{1} 1; 1: by move=> &m; skip => />; have /= := key_sizes; smt(pk_len_nrel).
rcondf{1} 1; 1: by move=> &m; skip => />; have /= := key_sizes; have /= := param_sets; smt().
rcondt{1} 1; 1: by move=> &m; skip => />; have /= := key_sizes; smt().
rcondt{1} 3; 1: by move=> &m; inline *; auto.
inline *; auto => />.
by move=> &1 &2 _ r _; rewrite !take_oversize ?Bytes64.size_to_list // get_set_sameE /=; smt(domE).
qed.

local equiv keygen6a : MLDSA_RO_DS5R(RoutedH, DS2.RO2.RO).keygen ~
                       MLDSA_RO_DS6(DS5.RO1.RO, DS5.RO2.RO, DS5.RO3.RO, DS5.RO4.RO, HctP(RO_pad.RO)).keygen :
  ={RO_pad.RO.m, DS5.RO2.RO.m, DS5.RO3.RO.m, DS5.RO4.RO.m, DS5.RO5.RO.m, glob XOFA_O, glob XOFS_O} /\
  RO_rest.RO.m{1} = empty /\ DS2.RO2.RO.m{1} = DS5.RO1.RO.m{2} /\ !RoutedH.trset{1}
  ==> ={res, RO_pad.RO.m, DS5.RO2.RO.m, DS5.RO3.RO.m, DS5.RO4.RO.m, DS5.RO5.RO.m, glob XOFA_O, RO_v.RO.m} /\
      RO_rest.RO.m{1} = empty /\ DS2.RO2.RO.m{1} = DS5.RO1.RO.m{2} /\ RoutedH.trset{1} /\
      DS5.RO3.RO.m{2}.[res{2}.`1] = Some RoutedH.tr{1}.
proof.
proc; inline{1} RO_S.RO.init RO_lp.RO.init RO_v.RO.init; inline{2} RO_S.RO.init RO_v.RO.init.
seq 15 9 : (={pk, rho, s1, s2, t0, RO_pad.RO.m, DS5.RO2.RO.m, DS5.RO3.RO.m, DS5.RO4.RO.m, DS5.RO5.RO.m,
              glob XOFA_O, RO_v.RO.m} /\
            RO_rest.RO.m{1} = empty /\ DS2.RO2.RO.m{1} = DS5.RO1.RO.m{2} /\ !RoutedH.trset{1}).
+ call (: true); 1: by sim.
  wp; call (: ={glob RO_S.RO, glob XOFS_O}); 1: by sim.
  call expandA6.
  by wp; rnd{1}; rnd; wp; rnd{1}; auto => />.
exlim pk{2} => pk0; call (: true); 1: by sim.
by wp; call (pktr6 pk0); auto => /> &1 &2 _ _ o ->; rewrite Bytes64.to_listK.
qed.

local equiv sign6a : MLDSA_RO_DS5R(RoutedH, DS2.RO2.RO).sign ~
                     MLDSA_RO_DS6(DS5.RO1.RO, DS5.RO2.RO, DS5.RO3.RO, DS5.RO4.RO, HctP(RO_pad.RO)).sign :
  ={sk, m, RO_pad.RO.m, DS5.RO2.RO.m, DS5.RO4.RO.m, DS5.RO5.RO.m, glob XOFA_O, RO_v.RO.m} /\
  DS2.RO2.RO.m{1} = DS5.RO1.RO.m{2}
  ==> ={res, RO_pad.RO.m, DS5.RO2.RO.m, DS5.RO4.RO.m, DS5.RO5.RO.m, glob XOFA_O, RO_v.RO.m} /\
      DS2.RO2.RO.m{1} = DS5.RO1.RO.m{2}.
proof.
proc; seq 13 13 : (={sk, m, coins, ct, ctl, sigma, leakage, rho, _K, tr, s1, s2, t0, s1h, s2h, t0h, _A, mu,
                     RO_pad.RO.m, DS5.RO2.RO.m, DS5.RO4.RO.m, DS5.RO5.RO.m, glob XOFA_O, RO_v.RO.m} /\
                   DS2.RO2.RO.m{1} = DS5.RO1.RO.m{2}).
+ call (: ={DS5.RO4.RO.m}); 1: by sim.
  call expandA6.
  by wp; call (: true); [by sim | auto].
seq 3 1 : (={sk, m, coins, ct, ctl, sigma, leakage, s1h, s2h, t0h, _A, mu, kp, RO_pad.RO.m, DS5.RO2.RO.m,
             DS5.RO4.RO.m, DS5.RO5.RO.m, glob XOFA_O, RO_v.RO.m} /\
           DS2.RO2.RO.m{1} = DS5.RO1.RO.m{2}).
+ by wp; call{1} RO_lp_sample_ll; auto.
seq 3 3 : (={kappa, zh, ct, ctl, sigma, leakage, RO_pad.RO.m, DS5.RO2.RO.m, DS5.RO4.RO.m, DS5.RO5.RO.m,
             glob XOFA_O, RO_v.RO.m} /\
           DS2.RO2.RO.m{1} = DS5.RO1.RO.m{2});
  2: by if => //; wp; call (: true); [by sim | auto].
while (={kappa, zh, ct, ctl, sigma, leakage, s1h, s2h, t0h, _A, mu, kp, RO_pad.RO.m, DS5.RO2.RO.m,
         DS5.RO4.RO.m, DS5.RO5.RO.m, glob XOFA_O, RO_v.RO.m} /\
       DS2.RO2.RO.m{1} = DS5.RO1.RO.m{2}); 2: by auto.
wp; call (: ={DS5.RO2.RO.m}); 1: by sim.
call (: ={DS5.RO5.RO.m, RO_pad.RO.m}); 1: by sim.
by wp; call (: ={RO_v.RO.m}); [by sim | auto].
qed.

local equiv verify6a : MLDSA_RO_DS5R(RoutedH, DS2.RO2.RO).verify ~
                       MLDSA_RO_DS6(DS5.RO1.RO, DS5.RO2.RO, DS5.RO3.RO, DS5.RO4.RO, HctP(RO_pad.RO)).verify :
  ={pk, m, sigma, RO_pad.RO.m, DS5.RO2.RO.m, DS5.RO3.RO.m, DS5.RO4.RO.m, DS5.RO5.RO.m, glob XOFA_O} /\
  DS2.RO2.RO.m{1} = DS5.RO1.RO.m{2}
  ==> ={res}.
proof.
proc; seq 4 4 : (={pk, m, rho, t1, ct, z, h, rb, w1, RO_pad.RO.m, DS5.RO2.RO.m, DS5.RO3.RO.m, DS5.RO4.RO.m,
                   DS5.RO5.RO.m, glob XOFA_O} /\
                 DS2.RO2.RO.m{1} = DS5.RO1.RO.m{2});
  1: by call (: true); [by sim | call (: true); [by sim | auto]].
if => //; wp; call (: ={DS5.RO5.RO.m, RO_pad.RO.m}); 1: by sim.
wp; call (: ={DS5.RO2.RO.m}); 1: by sim.
call (: ={DS5.RO4.RO.m}); 1: by sim.
call (: ={DS5.RO3.RO.m}); 1: by sim.
by call expandA6; auto.
qed.

local lemma G5_D7 &m :
  Pr[DS2.EUF_CMA(RoutedH, DS2.RO2.RO, MLDSA_RO_DS5R, A).main() @ &m : res] =
  Pr[RO_pad.MainD(D7, RO_pad.RO).distinguish() @ &m : res].
proof.
byequiv (: ={glob A, glob XOFA_O, glob XOFS_O} ==> ={res}) => //.
proc; inline{2} D7(RO_pad.RO).distinguish.
wp; call verify6a.
call (: ={RO_pad.RO.m, RO_rest.RO.m, DS5.RO2.RO.m, DS5.RO3.RO.m, DS5.RO4.RO.m, DS5.RO5.RO.m, glob XOFA_O,
          RO_v.RO.m} /\
        DS2.RO2.RO.m{1} = DS5.RO1.RO.m{2} /\ DS2.EUF_CMA.qs{1} = DS5.EUF_CMA.qs{2} /\
        DS2.EUF_CMA.sk{1} = DS5.EUF_CMA.sk{2} /\ RoutedH.trset{1} /\ RoutedH.tr{1} = Router.tr{2}).
+ by proc; call sign6a; auto.
+ by proc; auto.
+ by proc*; call getP; auto.
inline{2} RO_rest.RO.init DS5.RO3.RO.get; wp; rnd{2}; wp; call keygen6a; inline *; auto => />.
by move=> rR t b m hb hm r _; rewrite domE hm.
qed.

(*************** G6 is D7 with the lazy padding oracle ****************)

local lemma D7_LRO &m :
  Pr[RO_pad.MainD(D7, RO_pad.RO).distinguish() @ &m : res] =
  Pr[RO_pad.MainD(D7, RO_pad.LRO).distinguish() @ &m : res].
proof.
byequiv (RO_pad.FullEager.RO_LRO D7 _) => //.
by move=> _; apply dlist_ll; apply W8.dword_ll.
qed.

local equiv hctp_lro : HctP(RO_pad.LRO).get ~ DS5.RO5.RO.get :
  ={DS5.RO5.RO.m} /\ arg{1} = arg{2} ==> ={res, DS5.RO5.RO.m}.
proof. by proc*; inline *; auto. qed.

local equiv sign6b : MLDSA_RO_DS6(DS5.RO1.RO, DS5.RO2.RO, DS5.RO3.RO, DS5.RO4.RO, HctP(RO_pad.LRO)).sign ~
                     MLDSA_RO_DS6(DS5.RO1.RO, DS5.RO2.RO, DS5.RO3.RO, DS5.RO4.RO, DS5.RO5.RO).sign :
  ={sk, m, glob DS5.RO1.RO, DS5.RO2.RO.m, DS5.RO4.RO.m, DS5.RO5.RO.m, glob XOFA_O, RO_v.RO.m}
  ==> ={res, glob DS5.RO1.RO, DS5.RO2.RO.m, DS5.RO4.RO.m, DS5.RO5.RO.m, glob XOFA_O, RO_v.RO.m}.
proof.
proc; seq 14 14 : (={sk, m, coins, ct, ctl, sigma, leakage, s1h, s2h, t0h, _A, mu, kp, glob DS5.RO1.RO,
                     DS5.RO2.RO.m, DS5.RO4.RO.m, DS5.RO5.RO.m, glob XOFA_O, RO_v.RO.m}); 1: by sim.
seq 3 3 : (={kappa, zh, ct, ctl, sigma, leakage, glob DS5.RO1.RO, DS5.RO2.RO.m, DS5.RO4.RO.m, DS5.RO5.RO.m,
             glob XOFA_O, RO_v.RO.m}); 2: by sim.
while (={kappa, zh, ct, ctl, sigma, leakage, s1h, s2h, t0h, _A, mu, kp, glob DS5.RO1.RO, DS5.RO2.RO.m,
         DS5.RO4.RO.m, DS5.RO5.RO.m, glob XOFA_O, RO_v.RO.m}); 2: by auto.
wp; call (: ={DS5.RO2.RO.m}); 1: by sim.
call hctp_lro.
by wp; call (: ={RO_v.RO.m}); [by sim | auto].
qed.

local equiv verify6b : MLDSA_RO_DS6(DS5.RO1.RO, DS5.RO2.RO, DS5.RO3.RO, DS5.RO4.RO, HctP(RO_pad.LRO)).verify ~
                       MLDSA_RO_DS6(DS5.RO1.RO, DS5.RO2.RO, DS5.RO3.RO, DS5.RO4.RO, DS5.RO5.RO).verify :
  ={pk, m, sigma, glob DS5.RO1.RO, DS5.RO2.RO.m, DS5.RO3.RO.m, DS5.RO4.RO.m, DS5.RO5.RO.m, glob XOFA_O}
  ==> ={res}.
proof.
proc; seq 4 4 : (={pk, m, rho, t1, ct, z, h, rb, w1, glob DS5.RO1.RO, DS5.RO2.RO.m, DS5.RO3.RO.m,
                   DS5.RO4.RO.m, DS5.RO5.RO.m, glob XOFA_O}); 1: by sim.
if => //; wp; call hctp_lro.
wp; call (: ={DS5.RO2.RO.m}); 1: by sim.
call (: ={DS5.RO4.RO.m}); 1: by sim.
call (: ={DS5.RO3.RO.m}); 1: by sim.
by call (: ={glob DS5.RO1.RO, glob XOFA_O}); [by sim | auto].
qed.

local lemma D7_G6 &m :
  Pr[RO_pad.MainD(D7, RO_pad.LRO).distinguish() @ &m : res] =
  Pr[DS5.EUF_CMA(DS5.RO1.RO, DS5.RO2.RO, DS5.RO3.RO, DS5.RO4.RO, DS5.RO5.RO, MLDSA_RO_DS6, Router(A)).main()
       @ &m : res].
proof.
byequiv (: ={glob A, glob XOFA_O, glob XOFS_O, RO_v.RO.m, RO_S.RO.m} ==> ={res}) => //.
proc; inline{1} D7(RO_pad.LRO).distinguish.
inline{2} DS5.EUF_CMA(DS5.RO1.RO, DS5.RO2.RO, DS5.RO3.RO, DS5.RO4.RO, DS5.RO5.RO, MLDSA_RO_DS6, Router(A)).A.forge.
wp; call verify6b.
wp; call (: ={RO_pad.RO.m, RO_rest.RO.m, DS5.RO1.RO.m, DS5.RO2.RO.m, DS5.RO3.RO.m, DS5.RO4.RO.m,
              DS5.RO5.RO.m, glob XOFA_O, RO_v.RO.m, Router.tr, DS5.EUF_CMA.qs, DS5.EUF_CMA.sk}).
+ by proc; call sign6b; auto.
+ by proc; auto.
+ by proc; inline *; sim.
call (: ={DS5.RO3.RO.m}); 1: by sim.
inline{1} RO_rest.RO.init; inline{2} RO_rest.RO.init RO_pad.RO.init; wp.
call (: ={RO_v.RO.m, RO_S.RO.m, glob XOFA_O, glob XOFS_O, DS5.RO1.RO.m, DS5.RO3.RO.m}); 1: by sim.
by inline *; auto => />.
qed.

lemma G5_G6 &m :
  Pr[DS2.EUF_CMA(RoutedH, DS2.RO2.RO, MLDSA_RO_DS5R, A).main() @ &m : res] =
  Pr[DS5.EUF_CMA(DS5.RO1.RO, DS5.RO2.RO, DS5.RO3.RO, DS5.RO4.RO, DS5.RO5.RO, MLDSA_RO_DS6, Router(A)).main()
       @ &m : res].
proof. by rewrite (G5_D7 &m) (D7_LRO &m) (D7_G6 &m). qed.

(* Hop 6: the adversary is run by Router against the scheme in the five-oracle game *)
lemma hop6 (qH qS : int) &m : 0 <= qH => 0 <= qS =>
  (forall (H1 <: DS2.POracle1 {-A}) (H2 <: DS2.POracle2 {-A}) (O <: DS2.SOracle {-A}),
     islossless H1.get => islossless H2.get => islossless O.sign =>
     islossless A(H1, H2, O).forge) =>
  (forall (H <: DS2.POracle1 {-A, -CountH, -CountS}) (G <: DS2.POracle2 {-A, -CountH, -CountS})
          (O <: DS2.SOracle {-A, -CountH, -CountS}),
     hoare [A(CountH(H), G, CountS(O)).forge :
              CountH.c = 0 /\ CountS.c = 0 ==> CountH.c <= qH /\ CountS.c <= qS]) =>
  Pr[DS2.EUF_CMA(DS2.RO1.RO, DS2.RO2.RO, MLDSA_RO_DS1, A).main() @ &m : res] <=
  Pr[DS5.EUF_CMA(DS5.RO1.RO, DS5.RO2.RO, DS5.RO3.RO, DS5.RO4.RO, DS5.RO5.RO, MLDSA_RO_DS6, Router(A)).main()
       @ &m : res] +
  2%r * p512 + (qH + qS * (1 + kappa_max) + 2)%r * p512 +
  ((qS * (qS + qH + 1))%r * p512 + (3 * qH + qS + 4)%r * p256).
proof.
move=> hqH hqS A_ll A_count.
by rewrite -(G5_G6 &m); apply (hop5 A qH qS &m hqH hqS A_ll A_count).
qed.

end section.

end MLDSA_ROSep_Hop6.
