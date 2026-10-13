require import AllCore IntDiv List Distr DList DInterval PROM FMap BitEncoding.
from Jasmin require import JByte_array JWord.
require import Array256.

require import Parameters GFq Rq VecMat Conversion Serialization Symmetric Sampling.
import PolyLVec PolyKVec PolyMat.
import Round ZModQ Zq MLDSAParams.

require import MLDSA MLDSA_RO MLDSA_ROSep MLDSA_ROSep_Hop1 MLDSA_ROSep_Hop2 MLDSA_ROSep_Hop3.
require import JWordList.
require import MLDSA_ROSep_Hop4 MLDSA_ROSep_Hop5 MLDSA_ROSep_Hop6 MLDSA_ROSep_Hop7 MLDSA_ROSep_Hop8.
require import MLDSA_ROSep_Hop9.
require DS_ROM.

(*************** G10: H_ct takes w1 ****************)

clone DS_ROM.DS_ROM_x5 as DS10 with
  type pkey    <- BytesPK.t,
  type skey    <- Bytes32.t * Bytes64.t * polylvec * polykvec * polykvec,
  type msg     <- W8.t list,
  type sig     <- BytesSig.t,
  type leakage <- Leakage list,
  type RO1.in_t  <- W8.t list * int,
  type RO1.out_t <- W8.t,
  op   RO1.dout  <- fun _ => W8.dword,
  type RO2.in_t  <- W8.t list * int,
  type RO2.out_t <- W8.t list,
  op   RO2.dout  <- fun _ => dblock,
  type RO3.in_t  <- BytesPK.t,
  type RO3.out_t <- Bytes64.t,
  op   RO3.dout  <- fun _ => dbytes64,
  type RO4.in_t  <- Bytes64.t * W8.t list,
  type RO4.out_t <- Bytes64.t,
  op   RO4.dout  <- fun _ => dbytes64,
  type RO5.in_t  <- polykvec * Bytes64.t,
  type RO5.out_t <- BytesCT.t,
  op   RO5.dout  <- fun _ => dbytesCT.

(* H_ct on byte strings that are not encodings of a w1 *)
clone FullRO as RO_hr with
  type in_t  <- Bytes64.t * BytesW1.t,
  type out_t <- BytesCT.t,
  op   dout  <- fun _ => dbytesCT.

module HctRoute(Hct : DS10.POracle5) = {
  proc get(mu : Bytes64.t, b : BytesW1.t) : BytesCT.t = {
    var r;
    if (w1Encode (w1Dec b) = b) {
      r <@ Hct.get(w1Dec b, mu);
    } else {
      r <@ RO_hr.RO.get(mu, b);
    }
    return r;
  }
}.

module Router10(A : DS2.Adversary)
               (XA : DS10.POracle1, XC : DS10.POracle2,
                Htr : DS10.POracle3, Hmu : DS10.POracle4, Hct : DS10.POracle5,
                O : DS10.SOracle) = {
  var tr : Bytes64.t

  module H = {
    proc get(x : W8.t list * int) : W8.t list = {
      var b, o, oc, pad;
      b <- witness;
      if (take 64 x.`1 = Bytes64.to_list tr) {
        if (x.`2 = 0) {
          o <@ Hmu.get(tr, drop 64 x.`1);
          b <- Bytes64.to_list o;
        } else {
          b <@ RO_rest.RO.get(x);
        }
      } else {
        if (size x.`1 = 64 + w1_bytes) {
          if (x.`2 = 0) {
            oc <@ HctRoute(Hct).get(Bytes64.of_list (take 64 x.`1), BytesW1.of_list (drop 64 x.`1));
            pad <@ RO_pad.RO.get(x.`1);
            b <- BytesCT.to_list oc ++ pad;
          } else {
            b <@ RO_rest.RO.get(x);
          }
        } else {
          if (size x.`1 = lambda %/ 4) {
            b <@ XC.get(x);
          } else {
            if (size x.`1 = pk_bytes /\ x.`2 = 0) {
              o <@ Htr.get(BytesPK.of_list x.`1);
              b <- Bytes64.to_list o;
            } else {
              b <@ RO_rest.RO.get(x);
            }
          }
        }
      }
      return b;
    }
  }

  proc forge(pk : BytesPK.t) : W8.t list * BytesSig.t = {
    var r;
    RO_rest.RO.init();
    RO_pad.RO.init();
    RO_hr.RO.init();
    tr <@ Htr.get(pk);
    r <@ A(H, XA, O).forge(pk);
    return r;
  }
}.

module MLDSA_RO_DS10(XA : DS10.POracle1, XC : DS10.POracle2, Htr : DS10.POracle3, Hmu : DS10.POracle4,
                     Hct : DS10.POracle5) = {
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
       ct <@ Hct.get(w1, mu);
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
      ctp <@ Hct.get(w1, mu);
      rb <- infnorm_lt z (gamma1 - Beta);
      rb <- rb && ct = ctp;
    }
    return rb;
  }
}.

(*************** G9 and G10 ****************)

(* H_ct of G9 and the two oracles of G10 *)
op hctrel (m5 : (Bytes64.t * BytesW1.t, BytesCT.t) fmap) (ms : (polykvec * Bytes64.t, BytesCT.t) fmap)
          (mr : (Bytes64.t * BytesW1.t, BytesCT.t) fmap) : bool =
     (forall mu b, m5.[(mu, b)] = if w1Encode (w1Dec b) = b then ms.[(w1Dec b, mu)] else mr.[(mu, b)])
  /\ (forall w1 mu, (w1, mu) \in ms => w1Dec (w1Encode w1) = w1).

lemma hctrel_empty : hctrel empty empty empty.
proof.
by rewrite /hctrel; split => [mu b | w1 mu]; rewrite ?emptyE ?mem_empty //.
qed.

lemma hctrel_img m5 ms mr mu b v :
  hctrel m5 ms mr => w1Encode (w1Dec b) = b => hctrel m5.[(mu, b) <- v] ms.[(w1Dec b, mu) <- v] mr.
proof.
move=> [h1 h2] hb; split.
+ move=> mu' b'; rewrite !get_setE; case: ((mu', b') = (mu, b)) => [[->> ->>] | hne] /=; 1: by rewrite hb.
  rewrite h1; case: (w1Encode (w1Dec b') = b') => hb' //=.
  case: (w1Dec b' = w1Dec b /\ mu' = mu) => [[e1 e2] | //].
  have heq : (mu', b') = (mu, b) by rewrite e2 -hb' -hb e1.
  by move: hne; rewrite heq.
move=> w1 mu'; rewrite mem_set => -[/h2 // | [-> _]]; by rewrite hb.
qed.

lemma hctrel_rest m5 ms mr mu b v :
  hctrel m5 ms mr => w1Encode (w1Dec b) <> b => hctrel m5.[(mu, b) <- v] ms mr.[(mu, b) <- v].
proof.
move=> [h1 h2] hb; split => // mu' b'; rewrite !get_setE.
case: ((mu', b') = (mu, b)) => [[->> ->>] | hne] /=; 1: by rewrite hb.
exact h1.
qed.

equiv hct_route : DS5.RO5.RO.get ~ HctRoute(DS10.RO5.RO).get :
  x{1} = (mu{2}, b{2}) /\ hctrel DS5.RO5.RO.m{1} DS10.RO5.RO.m{2} RO_hr.RO.m{2}
  ==> ={res} /\ hctrel DS5.RO5.RO.m{1} DS10.RO5.RO.m{2} RO_hr.RO.m{2}.
proof.
proc; inline *; if{2}.
+ auto => /> &1 &2 hr hb v hv _; have he := hr mu{2} b{2}; rewrite v /= in he.
  have hI : hctrel DS5.RO5.RO.m{1} DS10.RO5.RO.m{2} RO_hr.RO.m{2} by split.
  have hdom : ((mu{2}, b{2}) \in DS5.RO5.RO.m{1}) <=> ((w1Dec b{2}, mu{2}) \in DS10.RO5.RO.m{2})
    by rewrite !domE he.
  have [h1' h2'] := hctrel_img _ _ _ mu{2} b{2} hv hI v.
  split => hin; split => hin'.
  - by rewrite !get_set_sameE /=; split; [exact h1' | exact h2'].
  - smt().
  - smt().
  by rewrite he.
auto => /> &1 &2 hr hb v hv _; have he := hr mu{2} b{2}; rewrite v /= in he.
have hI : hctrel DS5.RO5.RO.m{1} DS10.RO5.RO.m{2} RO_hr.RO.m{2} by split.
have hdom : ((mu{2}, b{2}) \in DS5.RO5.RO.m{1}) <=> ((mu{2}, b{2}) \in RO_hr.RO.m{2}) by rewrite !domE he.
have [h1' h2'] := hctrel_rest _ _ _ mu{2} b{2} hv hI v.
split => hin; split => hin'.
- by rewrite !get_set_sameE /=; exact h1'.
- smt().
- smt().
by rewrite he.
qed.

equiv hct_struct : DS5.RO5.RO.get ~ DS10.RO5.RO.get :
  x{1} = (x{2}.`2, w1Encode x{2}.`1) /\ w1rng x{2}.`1 /\ hctrel DS5.RO5.RO.m{1} DS10.RO5.RO.m{2} RO_hr.RO.m{2}
  ==> ={res} /\ hctrel DS5.RO5.RO.m{1} DS10.RO5.RO.m{2} RO_hr.RO.m{2}.
proof.
proc; auto => />.
move=> &1 &2 hw hr hb v _.
have hk := w1DecK x{2}.`1 hw.
have himg : w1Encode (w1Dec (w1Encode x{2}.`1)) = w1Encode x{2}.`1 by rewrite hk.
have hx : x{2} = (x{2}.`1, x{2}.`2) by smt().
have he := hr x{2}.`2 (w1Encode x{2}.`1); rewrite himg hk /= -hx in he.
have hI : hctrel DS5.RO5.RO.m{1} DS10.RO5.RO.m{2} RO_hr.RO.m{2} by split.
have hdom : ((x{2}.`2, w1Encode x{2}.`1) \in DS5.RO5.RO.m{1}) <=> (x{2} \in DS10.RO5.RO.m{2})
  by rewrite !domE he.
have [h1' h2'] := hctrel_img _ _ _ x{2}.`2 (w1Encode x{2}.`1) v hI himg.
rewrite hk -hx in h1'; rewrite hk -hx in h2'.
split => hin; split => hin'.
- by rewrite !get_set_sameE /=; split; [exact h1' | exact h2'].
- smt().
- smt().
by rewrite he.
qed.

equiv keygen910 :
  MLDSA_RO_DS9(DS5.RO1.RO, DS5.RO2.RO, DS5.RO3.RO, DS5.RO4.RO, DS5.RO5.RO).keygen ~
  MLDSA_RO_DS10(DS5.RO1.RO, DS5.RO2.RO, DS5.RO3.RO, DS5.RO4.RO, DS10.RO5.RO).keygen :
  ={glob DS5.RO1.RO, DS5.RO3.RO.m, glob XOFA_O}
  ==> ={res, glob DS5.RO1.RO, DS5.RO3.RO.m, glob XOFA_O, RO_y.RO.m}.
proof. by sim. qed.

equiv sign910 :
  MLDSA_RO_DS9(DS5.RO1.RO, DS5.RO2.RO, DS5.RO3.RO, DS5.RO4.RO, DS5.RO5.RO).sign ~
  MLDSA_RO_DS10(DS5.RO1.RO, DS5.RO2.RO, DS5.RO3.RO, DS5.RO4.RO, DS10.RO5.RO).sign :
  ={sk, m, glob DS5.RO1.RO, DS5.RO2.RO.m, DS5.RO4.RO.m, glob XOFA_O, RO_y.RO.m} /\
  hctrel DS5.RO5.RO.m{1} DS10.RO5.RO.m{2} RO_hr.RO.m{2}
  ==> ={res, glob DS5.RO1.RO, DS5.RO2.RO.m, DS5.RO4.RO.m, glob XOFA_O, RO_y.RO.m} /\
      hctrel DS5.RO5.RO.m{1} DS10.RO5.RO.m{2} RO_hr.RO.m{2}.
proof.
proc.
seq 10 10 : (={coins, ct, ctl, sigma, leakage, rho, tr, s1, s2, t0, _A, mu, kappa, zh, glob DS5.RO1.RO,
               DS5.RO2.RO.m, DS5.RO4.RO.m, glob XOFA_O, RO_y.RO.m} /\
             hctrel DS5.RO5.RO.m{1} DS10.RO5.RO.m{2} RO_hr.RO.m{2}).
+ wp; call (: ={DS5.RO4.RO.m}); 1: by sim.
  call (: ={glob DS5.RO1.RO, glob XOFA_O}); 1: by sim.
  by auto.
seq 1 1 : (={zh, ct, sigma, leakage, glob DS5.RO1.RO, DS5.RO2.RO.m, DS5.RO4.RO.m, glob XOFA_O, RO_y.RO.m} /\
           hctrel DS5.RO5.RO.m{1} DS10.RO5.RO.m{2} RO_hr.RO.m{2}).
+ while (={coins, ct, ctl, sigma, leakage, s1, s2, t0, _A, mu, kappa, zh, glob DS5.RO1.RO, DS5.RO2.RO.m,
           DS5.RO4.RO.m, glob XOFA_O, RO_y.RO.m} /\
         hctrel DS5.RO5.RO.m{1} DS10.RO5.RO.m{2} RO_hr.RO.m{2}).
  - wp; call (: ={DS5.RO2.RO.m}); 1: by sim.
    wp; call hct_struct.
    wp; call (: ={RO_y.RO.m}); 1: by sim.
    by auto => /> *; apply hb_rng.
  by auto.
by if => //; wp; call (: true); [by sim | auto].
qed.

equiv verify910 :
  MLDSA_RO_DS9(DS5.RO1.RO, DS5.RO2.RO, DS5.RO3.RO, DS5.RO4.RO, DS5.RO5.RO).verify ~
  MLDSA_RO_DS10(DS5.RO1.RO, DS5.RO2.RO, DS5.RO3.RO, DS5.RO4.RO, DS10.RO5.RO).verify :
  ={pk, m, sigma, glob DS5.RO1.RO, DS5.RO2.RO.m, DS5.RO3.RO.m, DS5.RO4.RO.m, glob XOFA_O} /\
  hctrel DS5.RO5.RO.m{1} DS10.RO5.RO.m{2} RO_hr.RO.m{2}
  ==> ={res} /\ hctrel DS5.RO5.RO.m{1} DS10.RO5.RO.m{2} RO_hr.RO.m{2}.
proof.
proc.
seq 4 4 : (={pk, m, rho, t1, ct, z, h, rb, w1, glob DS5.RO1.RO, DS5.RO2.RO.m, DS5.RO3.RO.m, DS5.RO4.RO.m,
             glob XOFA_O} /\
           hctrel DS5.RO5.RO.m{1} DS10.RO5.RO.m{2} RO_hr.RO.m{2}).
+ by call (: true); [by sim | call (: true); [by sim | auto]].
if => //.
wp; call hct_struct.
wp; call (: ={DS5.RO2.RO.m}); 1: by sim.
call (: ={DS5.RO4.RO.m}); 1: by sim.
call (: ={DS5.RO3.RO.m}); 1: by sim.
call (: ={glob DS5.RO1.RO, glob XOFA_O}); 1: by sim.
by auto => /> *; apply uh_rng.
qed.

section.

declare module A <: DS2.Adversary {
  -DS2.RO1.RO, -DS2.RO2.RO, -DS2.EUF_CMA, -XOFA_O, -XOFS_O, -MLDSA_RO_DS1, -RoutedH,
  -DS5.RO1.RO, -DS5.RO2.RO, -DS5.RO3.RO, -DS5.RO4.RO, -DS5.RO5.RO, -DS5.EUF_CMA, -RO_rest.RO,
  -RO_pad.RO, -RO_pad.FRO, -RO_seed.RO, -RO_S.RO, -RO_rhopp.RO, -RO_v.RO, -CountH, -CountS, -St5,
  -RO_lp.RO, -RO_lp.FRO, -St6, -St7, -Router, -RO_y.RO, -DS8.EUF_CMA, -DS10.EUF_CMA, -DS10.RO5.RO,
  -RO_hr.RO, -Router10 }.

lemma G9_G10 &m :
  Pr[DS8.EUF_CMA(DS5.RO1.RO, DS5.RO2.RO, DS5.RO3.RO, DS5.RO4.RO, DS5.RO5.RO, MLDSA_RO_DS9, Router(A)).main()
       @ &m : res] =
  Pr[DS10.EUF_CMA(DS5.RO1.RO, DS5.RO2.RO, DS5.RO3.RO, DS5.RO4.RO, DS10.RO5.RO, MLDSA_RO_DS10, Router10(A)).main()
       @ &m : res].
proof.
byequiv (: ={glob A, glob XOFA_O} ==> ={res}) => //.
proc.
inline{1} DS8.EUF_CMA(DS5.RO1.RO, DS5.RO2.RO, DS5.RO3.RO, DS5.RO4.RO, DS5.RO5.RO, MLDSA_RO_DS9, Router(A)).A.forge.
inline{2} DS10.EUF_CMA(DS5.RO1.RO, DS5.RO2.RO, DS5.RO3.RO, DS5.RO4.RO, DS10.RO5.RO, MLDSA_RO_DS10, Router10(A)).A.forge.
wp; call verify910.
wp; call (: ={RO_pad.RO.m, RO_rest.RO.m, DS5.RO1.RO.m, DS5.RO2.RO.m, DS5.RO3.RO.m, DS5.RO4.RO.m, glob XOFA_O,
              RO_y.RO.m} /\
            Router.tr{1} = Router10.tr{2} /\ DS8.EUF_CMA.qs{1} = DS10.EUF_CMA.qs{2} /\
            DS8.EUF_CMA.sk{1} = DS10.EUF_CMA.sk{2} /\ hctrel DS5.RO5.RO.m{1} DS10.RO5.RO.m{2} RO_hr.RO.m{2}).
+ by proc; call sign910; auto.
+ by proc; auto.
+ proc; sp; if; 1: by move=> &1 &2 /> /#.
  - if => //.
    + by wp; call (: ={DS5.RO4.RO.m}); [by sim | auto].
    by call (: ={RO_rest.RO.m}); [by sim | auto].
  if => //.
  - if => //.
    + wp; call (: ={RO_pad.RO.m}); 1: by sim.
      by wp; call hct_route; auto.
    by call (: ={RO_rest.RO.m}); [by sim | auto].
  if => //.
  - by call (: ={DS5.RO2.RO.m}); [by sim | auto].
  if => //.
  - by wp; call (: ={DS5.RO3.RO.m}); [by sim | auto].
  by call (: ={RO_rest.RO.m}); [by sim | auto].
call (: ={DS5.RO3.RO.m}); 1: by sim.
inline{1} RO_rest.RO.init RO_pad.RO.init; inline{2} RO_rest.RO.init RO_pad.RO.init RO_hr.RO.init; wp.
call keygen910.
by inline *; auto => />; exact hctrel_empty.
qed.

(* Hop 10: H_ct is queried on w1; other byte strings go to a separate oracle *)
lemma hop10 (qH qS : int) &m : 0 <= qH => 0 <= qS =>
  (forall (H1 <: DS2.POracle1 {-A}) (H2 <: DS2.POracle2 {-A}) (O <: DS2.SOracle {-A}),
     islossless H1.get => islossless H2.get => islossless O.sign =>
     islossless A(H1, H2, O).forge) =>
  (forall (H <: DS2.POracle1 {-A, -CountH, -CountS}) (G <: DS2.POracle2 {-A, -CountH, -CountS})
          (O <: DS2.SOracle {-A, -CountH, -CountS}),
     hoare [A(CountH(H), G, CountS(O)).forge :
              CountH.c = 0 /\ CountS.c = 0 ==> CountH.c <= qH /\ CountS.c <= qS]) =>
  Pr[DS2.EUF_CMA(DS2.RO1.RO, DS2.RO2.RO, MLDSA_RO_DS1, A).main() @ &m : res] <=
  Pr[DS10.EUF_CMA(DS5.RO1.RO, DS5.RO2.RO, DS5.RO3.RO, DS5.RO4.RO, DS10.RO5.RO, MLDSA_RO_DS10, Router10(A)).main()
       @ &m : res] +
  2%r * p512 + (qH + qS * (1 + kappa_max) + 2)%r * p512 +
  ((qS * (qS + qH + 1))%r * p512 + (3 * qH + qS + 4)%r * p256).
proof.
move=> hqH hqS A_ll A_count.
by rewrite -(G9_G10 &m); apply (hop9 A qH qS &m hqH hqS A_ll A_count).
qed.

end section.
