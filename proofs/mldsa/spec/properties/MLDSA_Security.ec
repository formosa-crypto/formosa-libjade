require import AllCore IntDiv List Distr FSet StdOrder StdBigop.
from Jasmin require import JByte_array JWord.
require import Array256.

require import Parameters GFq Rq.
require MLDSA_ROSep_Hop18.
require import ConcreteDRing Leakage.
require DS_ROM.
import RealOrder.

(* The security of the ML-DSA specification: the reduction of the FIPS 204
   scheme (hedged signing, SHAKE256 and SHAKE128 as random oracles) to the
   target security spec (`mldsa_euf_cma`, the eighteen hops) composed with
   the security proof of the target (`MP.MLDSA_secure`: MLWE,
   SelfTargetMSIS, the Fiat-Shamir with aborts terms and the collision
   bounds of the hash functions). *)

abstract theory MLDSA_Security.

clone include MLDSA_ROSep_Hop18.MLDSA_ROSep_Hop18.
import Spec.
import PolyLVec PolyKVec PolyMat.
import Round ZModQ Zq MLDSAParams.

(*************** Termination and counting of the oracles of B ****************)

lemma xaw_ll (XA' <: DST.POracle1) : islossless XA'.get => islossless XAw(XA').get.
proof. by move=> h; proc; if; [call h | call roxr_ll]. qed.

lemma xcw_ll (XC' <: DST.POracle2) : islossless XC'.get => islossless XCw(XC').get.
proof. by move=> h; proc; call h. qed.

lemma htrw_ll' (Htr' <: DST.POracle3) : islossless Htr'.get => islossless Htrw(Htr').get.
proof. by move=> h; proc; call h; call pkDecode_ll. qed.

lemma hctw_ll (Hct' <: DST.POracle5) : islossless Hct'.get => islossless Hctw(Hct').get.
proof. by move=> h; proc; call h. qed.

lemma blockof_ll' (XC' <: DST.POracle2) : islossless XC'.get => islossless BlockOf(XCw(XC')).get.
proof.
move=> h; proc; while true (64 - i); 2: by auto => /#.
by move=> z; wp; call (xcw_ll XC' h); auto => /#.
qed.

lemma rH_ll' (A0 <: DS2.Adversary) (XA' <: DST.POracle1) (XC' <: DST.POracle2) (Htr' <: DST.POracle3)
  (Hmu' <: DST.POracle4) (Hct' <: DST.POracle5) (O <: DS11.SOracle) :
  islossless XC'.get => islossless Htr'.get => islossless Hmu'.get => islossless Hct'.get =>
  islossless Router11(A0, XAw(XA'), XCw(XC'), Htrw(Htr'), Hmu', Hctw(Hct'), O).H.get.
proof.
move=> hxc htr hmu hct; proc; sp; if.
+ by if; [wp; call hmu; auto | call rorest_ll; auto].
if.
+ if; 2: by call rorest_ll; auto.
  wp; call ropad_ll; inline HctRoute(Hctw(Hct')).get; sp; wp.
  by if; [call (hctw_ll Hct' hct) | call rohr_ll]; auto.
if; 1: by call (blockof_ll' XC' hxc); auto.
by if; [wp; call (htrw_ll' Htr' htr); auto | call rorest_ll; auto].
qed.

(* One query to the SHAKE256 router makes at most one query to each of the
   hash oracles of the target, and at most one new c~ to its XOF *)
lemma blockof_count
  (XC' <: MP.T.SIB.XOF_t {-MP.T.CountXA, -MP.T.CountXC, -MP.T.CountHtr, -MP.T.CountHmu, -MP.T.CountHct,
                          -MP.T.CountS}) (a b c d e f : int) :
  hoare [BlockOf(XCw(MP.T.CountXC(XC'))).get :
         MP.T.CountXA.q = a /\ MP.T.CountXC.q = b /\ MP.T.CountHtr.q = c /\ MP.T.CountHmu.q = d /\
         MP.T.CountHct.q = e /\ MP.T.CountS.q = f ==>
         MP.T.CountXA.q = a /\ MP.T.CountXC.q <= b + 1 /\ MP.T.CountHtr.q = c /\ MP.T.CountHmu.q = d /\
         MP.T.CountHct.q = e /\ MP.T.CountS.q = f].
proof.
proc.
while (MP.T.CountXA.q = a /\ MP.T.CountHtr.q = c /\ MP.T.CountHmu.q = d /\ MP.T.CountHct.q = e /\
       MP.T.CountS.q = f /\
       (MP.T.CountXC.q = b \/ (MP.T.CountXC.q = b + 1 /\ BytesCT.of_list x.`1 \in MP.T.CountXC.xs))).
+ inline XCw(MP.T.CountXC(XC')).get MP.T.CountXC(XC').get.
  wp; call (: true); auto => /> &hr; smt(in_fsetU in_fset1).
by auto => /> /#.
qed.

lemma rH_count (A0 <: DS2.Adversary)
  (XA'  <: MP.T.XOF_A {-MP.T.CountXA, -MP.T.CountXC, -MP.T.CountHtr, -MP.T.CountHmu, -MP.T.CountHct,
                             -MP.T.CountS})
  (XC'  <: MP.T.SIB.XOF_t {-MP.T.CountXA, -MP.T.CountXC, -MP.T.CountHtr, -MP.T.CountHmu, -MP.T.CountHct,
                             -MP.T.CountS})
  (Htr' <: MP.T.Hash_tr {-MP.T.CountXA, -MP.T.CountXC, -MP.T.CountHtr, -MP.T.CountHmu, -MP.T.CountHct,
                             -MP.T.CountS})
  (Hmu' <: MP.T.Hash_mu {-MP.T.CountXA, -MP.T.CountXC, -MP.T.CountHtr, -MP.T.CountHmu, -MP.T.CountHct,
                             -MP.T.CountS})
  (Hct' <: MP.T.Hash_ct {-MP.T.CountXA, -MP.T.CountXC, -MP.T.CountHtr, -MP.T.CountHmu, -MP.T.CountHct,
                             -MP.T.CountS})
  (O <: DS11.SOracle) (a b c d e f : int) :
  hoare [Router11(A0, XAw(MP.T.CountXA(XA')), XCw(MP.T.CountXC(XC')), Htrw(MP.T.CountHtr(Htr')),
                  MP.T.CountHmu(Hmu'), Hctw(MP.T.CountHct(Hct')), O).H.get :
         MP.T.CountXA.q = a /\ MP.T.CountXC.q = b /\ MP.T.CountHtr.q = c /\ MP.T.CountHmu.q = d /\
         MP.T.CountHct.q = e /\ MP.T.CountS.q = f ==>
         MP.T.CountXA.q = a /\ MP.T.CountXC.q <= b + 1 /\ MP.T.CountHtr.q <= c + 1 /\
         MP.T.CountHmu.q <= d + 1 /\ MP.T.CountHct.q <= e + 1 /\ MP.T.CountS.q = f].
proof.
proc; sp; if.
+ if; 2: by call (: true); auto => /> /#.
  by inline MP.T.CountHmu(Hmu').get; wp; call (: true); auto => /> /#.
if.
+ if; 2: by call (: true); auto => /> /#.
  wp; call (: true); 1: by auto.
  inline HctRoute(Hctw(MP.T.CountHct(Hct'))).get; sp; wp.
  if; 2: by call (: true); auto => /> /#.
  by inline Hctw(MP.T.CountHct(Hct')).get MP.T.CountHct(Hct').get; wp; call (: true); auto => /> /#.
if; 1: by call (blockof_count XC' a b c d e f); auto => /> /#.
if; 2: by call (: true); auto => /> /#.
by inline Htrw(MP.T.CountHtr(Htr')).get MP.T.CountHtr(Htr').get; wp; call (: true); auto;
   call (: true); auto => /> /#.
qed.

(*************** The oracles of the hops are those of the target ****************)

(* The five oracles of the hops (DST.RO1..5) and those of the target game
   have the same code, on different global tables *)
equiv ro1_T : DST.RO1.RO.get ~ MP.T.XA.RO.get :
  ={x} /\ DST.RO1.RO.m{1} = MP.T.XA.RO.m{2} ==> ={res} /\ DST.RO1.RO.m{1} = MP.T.XA.RO.m{2}.
proof. by proc; auto. qed.

equiv ro2_T : DST.RO2.RO.get ~ MP.T.SIB.XOF.RO.get :
  ={x} /\ DST.RO2.RO.m{1} = MP.T.SIB.XOF.RO.m{2} ==> ={res} /\ DST.RO2.RO.m{1} = MP.T.SIB.XOF.RO.m{2}.
proof. by proc; auto. qed.

equiv ro3_T : DST.RO3.RO.get ~ MP.T.ROtr.RO.get :
  ={x} /\ DST.RO3.RO.m{1} = MP.T.ROtr.RO.m{2} ==> ={res} /\ DST.RO3.RO.m{1} = MP.T.ROtr.RO.m{2}.
proof. by proc; auto. qed.

equiv ro4_T : DST.RO4.RO.get ~ MP.T.ROmu.RO.get :
  ={x} /\ DST.RO4.RO.m{1} = MP.T.ROmu.RO.m{2} ==> ={res} /\ DST.RO4.RO.m{1} = MP.T.ROmu.RO.m{2}.
proof. by proc; auto. qed.

equiv ro5_T : DST.RO5.RO.get ~ MP.T.ROct.RO.get :
  ={x} /\ DST.RO5.RO.m{1} = MP.T.ROct.RO.m{2} ==> ={res} /\ DST.RO5.RO.m{1} = MP.T.ROct.RO.m{2}.
proof. by proc; auto. qed.

equiv expandA_T : MP.T.ExpandA(DST.RO1.RO).get ~ MP.T.ExpandA(MP.T.XA.RO).get :
  ={rho} /\ DST.RO1.RO.m{1} = MP.T.XA.RO.m{2} ==> ={res} /\ DST.RO1.RO.m{1} = MP.T.XA.RO.m{2}.
proof.
proc; while (={mA, r, rho} /\ DST.RO1.RO.m{1} = MP.T.XA.RO.m{2}); 2: by auto.
wp; while (={mA, r, s, rho} /\ DST.RO1.RO.m{1} = MP.T.XA.RO.m{2}); 2: by auto.
wp; while (={mA, r, s, rho, cs, ctx} /\ DST.RO1.RO.m{1} = MP.T.XA.RO.m{2}); 2: by auto.
by wp; call ro1_T; call ro1_T; call ro1_T; auto.
qed.

equiv sib_T : MP.T.SIB.SampleInBall(DST.RO2.RO).get ~ MP.T.SIB.SampleInBall(MP.T.SIB.XOF.RO).get :
  ={x} /\ DST.RO2.RO.m{1} = MP.T.SIB.XOF.RO.m{2} ==> ={res} /\ DST.RO2.RO.m{1} = MP.T.SIB.XOF.RO.m{2}.
proof.
proc.
while (={signs, challenge, leak, ctx, i, x} /\ DST.RO2.RO.m{1} = MP.T.SIB.XOF.RO.m{2}).
+ wp; while (={signs, challenge, leak, ctx, i, j, x} /\ DST.RO2.RO.m{1} = MP.T.SIB.XOF.RO.m{2}).
  * by wp; call ro2_T; auto.
  by auto.
wp; while (={signs, challenge, leak, ctx, x} /\ DST.RO2.RO.m{1} = MP.T.SIB.XOF.RO.m{2}).
+ by wp; call ro2_T; auto.
by auto.
qed.

equiv keygen_T :
  MP.T.MLDSA(DST.RO1.RO, DST.RO2.RO, DST.RO3.RO, DST.RO4.RO, DST.RO5.RO).keygen ~
  MP.T.MLDSA(MP.T.XA.RO, MP.T.SIB.XOF.RO, MP.T.ROtr.RO, MP.T.ROmu.RO, MP.T.ROct.RO).keygen :
  DST.RO1.RO.m{1} = MP.T.XA.RO.m{2} /\ DST.RO2.RO.m{1} = MP.T.SIB.XOF.RO.m{2} /\
  DST.RO3.RO.m{1} = MP.T.ROtr.RO.m{2} /\ DST.RO4.RO.m{1} = MP.T.ROmu.RO.m{2} /\
  DST.RO5.RO.m{1} = MP.T.ROct.RO.m{2}
  ==> ={res} /\
  DST.RO1.RO.m{1} = MP.T.XA.RO.m{2} /\ DST.RO2.RO.m{1} = MP.T.SIB.XOF.RO.m{2} /\
  DST.RO3.RO.m{1} = MP.T.ROtr.RO.m{2} /\ DST.RO4.RO.m{1} = MP.T.ROmu.RO.m{2} /\
  DST.RO5.RO.m{1} = MP.T.ROct.RO.m{2}.
proof. by proc; call ro3_T; wp; rnd; rnd; call expandA_T; rnd; auto. qed.

equiv sign_T :
  MP.T.MLDSA(DST.RO1.RO, DST.RO2.RO, DST.RO3.RO, DST.RO4.RO, DST.RO5.RO).sign ~
  MP.T.MLDSA(MP.T.XA.RO, MP.T.SIB.XOF.RO, MP.T.ROtr.RO, MP.T.ROmu.RO, MP.T.ROct.RO).sign :
  ={sk, m} /\
  DST.RO1.RO.m{1} = MP.T.XA.RO.m{2} /\ DST.RO2.RO.m{1} = MP.T.SIB.XOF.RO.m{2} /\
  DST.RO3.RO.m{1} = MP.T.ROtr.RO.m{2} /\ DST.RO4.RO.m{1} = MP.T.ROmu.RO.m{2} /\
  DST.RO5.RO.m{1} = MP.T.ROct.RO.m{2}
  ==> ={res} /\
  DST.RO1.RO.m{1} = MP.T.XA.RO.m{2} /\ DST.RO2.RO.m{1} = MP.T.SIB.XOF.RO.m{2} /\
  DST.RO3.RO.m{1} = MP.T.ROtr.RO.m{2} /\ DST.RO4.RO.m{1} = MP.T.ROmu.RO.m{2} /\
  DST.RO5.RO.m{1} = MP.T.ROct.RO.m{2}.
proof.
proc.
while (={response, ctr, leak, ct, mA, mu, s1, s2, t0} /\
       DST.RO1.RO.m{1} = MP.T.XA.RO.m{2} /\ DST.RO2.RO.m{1} = MP.T.SIB.XOF.RO.m{2} /\
       DST.RO3.RO.m{1} = MP.T.ROtr.RO.m{2} /\ DST.RO4.RO.m{1} = MP.T.ROmu.RO.m{2} /\
       DST.RO5.RO.m{1} = MP.T.ROct.RO.m{2}).
+ wp; call sib_T; call ro5_T; auto.
wp; call ro4_T; call expandA_T; auto.
qed.

equiv verify_T :
  MP.T.MLDSA(DST.RO1.RO, DST.RO2.RO, DST.RO3.RO, DST.RO4.RO, DST.RO5.RO).verify ~
  MP.T.MLDSA(MP.T.XA.RO, MP.T.SIB.XOF.RO, MP.T.ROtr.RO, MP.T.ROmu.RO, MP.T.ROct.RO).verify :
  ={pk, m, sig} /\
  DST.RO1.RO.m{1} = MP.T.XA.RO.m{2} /\ DST.RO2.RO.m{1} = MP.T.SIB.XOF.RO.m{2} /\
  DST.RO3.RO.m{1} = MP.T.ROtr.RO.m{2} /\ DST.RO4.RO.m{1} = MP.T.ROmu.RO.m{2} /\
  DST.RO5.RO.m{1} = MP.T.ROct.RO.m{2}
  ==> ={res} /\
  DST.RO1.RO.m{1} = MP.T.XA.RO.m{2} /\ DST.RO2.RO.m{1} = MP.T.SIB.XOF.RO.m{2} /\
  DST.RO3.RO.m{1} = MP.T.ROtr.RO.m{2} /\ DST.RO4.RO.m{1} = MP.T.ROmu.RO.m{2} /\
  DST.RO5.RO.m{1} = MP.T.ROct.RO.m{2}.
proof. by proc; call ro5_T; wp; call sib_T; call ro4_T; call ro3_T; call expandA_T; auto. qed.

equiv xaw_T : XAw(DST.RO1.RO).get ~ XAw(MP.T.XA.RO).get :
  ={x, RO_xr.RO.m} /\ DST.RO1.RO.m{1} = MP.T.XA.RO.m{2} ==>
  ={res, RO_xr.RO.m} /\ DST.RO1.RO.m{1} = MP.T.XA.RO.m{2}.
proof. by proc; if => //; [call ro1_T | call (: ={RO_xr.RO.m}); 1: sim]; auto. qed.

equiv rH_T (A0 <: DS2.Adversary) (O1 <: DS11.SOracle) (O2 <: DS11.SOracle) :
  Router11(A0, XAw(DST.RO1.RO), XCw(DST.RO2.RO), Htrw(DST.RO3.RO), DST.RO4.RO, Hctw(DST.RO5.RO), O1).H.get ~
  Router11(A0, XAw(MP.T.XA.RO), XCw(MP.T.SIB.XOF.RO), Htrw(MP.T.ROtr.RO), MP.T.ROmu.RO, Hctw(MP.T.ROct.RO),
           O2).H.get :
  ={x, RO_rest.RO.m, RO_pad.RO.m, RO_hr.RO.m, Router11.tr} /\
  DST.RO1.RO.m{1} = MP.T.XA.RO.m{2} /\ DST.RO2.RO.m{1} = MP.T.SIB.XOF.RO.m{2} /\
  DST.RO3.RO.m{1} = MP.T.ROtr.RO.m{2} /\ DST.RO4.RO.m{1} = MP.T.ROmu.RO.m{2} /\
  DST.RO5.RO.m{1} = MP.T.ROct.RO.m{2}
  ==> ={res, RO_rest.RO.m, RO_pad.RO.m, RO_hr.RO.m, Router11.tr} /\
  DST.RO1.RO.m{1} = MP.T.XA.RO.m{2} /\ DST.RO2.RO.m{1} = MP.T.SIB.XOF.RO.m{2} /\
  DST.RO3.RO.m{1} = MP.T.ROtr.RO.m{2} /\ DST.RO4.RO.m{1} = MP.T.ROmu.RO.m{2} /\
  DST.RO5.RO.m{1} = MP.T.ROct.RO.m{2}.
proof.
proc; sp; if => //.
+ by if => //; [wp; call ro4_T | call (: ={RO_rest.RO.m}); 1: sim]; auto.
if => //.
+ if => //; 2: by call (: ={RO_rest.RO.m}); [sim | auto].
  wp; call (: ={RO_pad.RO.m}); 1: by sim.
  inline HctRoute(Hctw(DST.RO5.RO)).get HctRoute(Hctw(MP.T.ROct.RO)).get; sp; wp.
  if => //; 2: by call (: ={RO_hr.RO.m}); [sim | auto].
  by inline Hctw(DST.RO5.RO).get Hctw(MP.T.ROct.RO).get; wp; call ro5_T; auto.
if => //.
+ inline BlockOf(XCw(DST.RO2.RO)).get BlockOf(XCw(MP.T.SIB.XOF.RO)).get; wp.
  while (={i, bs, x0} /\
         DST.RO1.RO.m{1} = MP.T.XA.RO.m{2} /\ DST.RO2.RO.m{1} = MP.T.SIB.XOF.RO.m{2} /\
         DST.RO3.RO.m{1} = MP.T.ROtr.RO.m{2} /\ DST.RO4.RO.m{1} = MP.T.ROmu.RO.m{2} /\
         DST.RO5.RO.m{1} = MP.T.ROct.RO.m{2}); 2: by auto.
  by inline XCw(DST.RO2.RO).get XCw(MP.T.SIB.XOF.RO).get; wp; call ro2_T; auto.
if => //; 2: by call (: ={RO_rest.RO.m}); [sim | auto].
inline Htrw(DST.RO3.RO).get Htrw(MP.T.ROtr.RO).get; wp.
by call ro3_T; call (: true); 1: sim; auto.
qed.

section.

declare module A <: DS2.Adversary {
  -DS2.RO1.RO, -DS2.RO2.RO, -DS2.EUF_CMA, -XOFA_O, -XOFS_O, -MLDSA_RO_DS1, -RoutedH,
  -DS5.RO1.RO, -DS5.RO2.RO, -DS5.RO3.RO, -DS5.RO4.RO, -DS5.RO5.RO, -DS5.EUF_CMA, -RO_rest.RO,
  -RO_pad.RO, -RO_pad.FRO, -RO_seed.RO, -RO_S.RO, -RO_rhopp.RO, -RO_v.RO, -CountH, -CountS, -St5,
  -RO_lp.RO, -RO_lp.FRO, -St6, -St7, -Router, -RO_y.RO, -DS8.EUF_CMA, -DS10.EUF_CMA, -DS10.RO5.RO,
  -RO_hr.RO, -Router10, -DS11.EUF_CMA, -RO_xc.RO, -RO_xc.FRO, -Router11, -DST.RO1.RO, -DST.RO2.RO,
  -DST.RO3.RO, -DST.RO4.RO, -DST.RO5.RO, -DST.EUF_CMA, -RO_xr.RO, -G13, -Coins, -CountG,
  (* the target and its security proof *)
  -MP.T.XA.RO, -MP.T.SIB.XOF.RO, -MP.T.ROtr.RO, -MP.T.ROmu.RO, -MP.T.ROct.RO,
  -MP.T.O_CMA, -MP.T.CountXA, -MP.T.CountXC, -MP.T.CountHtr, -MP.T.CountHmu,
  -MP.T.CountHct, -MP.T.CountS,
  -MP.EA.RS.RO, -MP.EA.RS.IS.RO, -MP.EA.RS.Sim, -MP.EA.RS.ISR,
  -MP.RA, -MP.O_CMA1, -MP.XASim, -MP.LX.RO, -MP.HctT, -MP.HmuB, -MP.RedSt,
  -MP.SD.FSaCR.DSS.DS.Stateless.O_CMA_Default, -MP.SD.H, -MP.SD.OpBasedSig,
  -MP.SD.O_CMA_Default_G, -MP.SD.RO_G, -MP.SD.OpBasedSigG,
  -MP.SD.CMAtoKOA.ORedKOA, -MP.SD.CMAtoKOA.CountS, -MP.SD.CMAtoKOA.CountH,
  -MP.SD.SIB.ORedXOFROC, -MP.SD.SIB.XOF.RO, -MP.SD.SIB.ROC.RO, -MP.SD.XOF,
  -MP.SD.DSSXOF.DS.Stateless.O_CMA_Default,
  -MP.SD.CountS, -MP.SD.CountH, -MP.SD.CountX, -MP.SD.CountSX, -MP.SD.OConv,
  -MP.SD.G, -MP.SD.RqStMSIS.Std.PRO.RO, -MP.SD.RqStMSIS.ORed,
  -MP.SD.OpBased.P, -MP.SD.OpBased.V,
  -MP.SD.CG.FSaG.DSS.DS.Stateless.O_CMA_Default, -MP.SD.CG.FSaG.DSS.PRO.RO,
  -MP.SD.CG.FSaCR.DSS.DS.Stateless.O_CMA_Default, -MP.SD.CG.FSaCR.DSS.PRO.RO,
  -MP.SD.FSaG.DSS.DS.Stateless.O_CMA_Default, -MP.SD.FSaG.DSS.PRO.RO,
  -MP.SD.CMAtoKOA.FSaG.DSS.DS.Stateless.O_CMA_Default, -MP.SD.CMAtoKOA.FSaG.DSS.PRO.RO,
  -MP.SD.CMAtoKOA.OP.P, -MP.SD.CMAtoKOA.OP.V, -MP.SD.CMAtoKOA.RH.RO.RO,
  -MP.SD.CMAtoKOA.RH.Count, -MP.SD.CMAtoKOA.RH.OSign, -MP.SD.CMAtoKOA.OGame1,
  -MP.SD.CMAtoKOA.RedOnce
}.

(* A terminates when its oracles do *)
declare axiom A_ll
  (H1 <: DS2.POracle1 {-A}) (H2 <: DS2.POracle2 {-A}) (O <: DS2.SOracle {-A}) :
  islossless H1.get => islossless H2.get => islossless O.sign =>
  islossless A(H1, H2, O).forge.

(* Query bounds: qH queries to SHAKE256, qG to SHAKE128, qS signing queries *)
op qH, qG, qS : int.

declare axiom A_count
  (H <: DS2.POracle1 {-A, -CountH, -CountS}) (G <: DS2.POracle2 {-A, -CountH, -CountS})
  (O <: DS2.SOracle {-A, -CountH, -CountS}) :
  hoare [A(CountH(H), G, CountS(O)).forge :
         CountH.c = 0 /\ CountS.c = 0 ==> CountH.c <= qH /\ CountS.c <= qS].

declare axiom A_countG
  (H <: DS2.POracle1 {-A, -CountG}) (G <: DS2.POracle2 {-A, -CountG})
  (O <: DS2.SOracle {-A, -CountG}) :
  hoare [A(H, CountG(G), O).forge : CountG.c = 0 ==> CountG.c <= qG].

declare axiom qH_ge0 : 0 <= qH.
declare axiom qG_ge0 : 0 <= qG.
declare axiom qS_ge0 : 0 <= qS.

(* The query bounds of the target dominate those of A: every SHAKE256 query
   of A is routed to at most one of the four hash oracles of the target
   (with at most one new c~ for its XOF), every SHAKE128 query to at most one
   query to its XOF; B makes one more query to Htr, the hash of the public
   key *)
declare axiom qXA_dom  : qG <= MP.T.qXA.
declare axiom qXC_dom  : qH <= MP.T.qXC.
declare axiom qHtr_dom : qH + 1 <= MP.T.qHtr.
declare axiom qHmu_dom : qH <= MP.T.qHmu.
declare axiom qHct_dom : qH <= MP.T.qHct.
declare axiom qS_dom   : qS <= MP.T.qS.

(*************** The reduction B against the target ****************)

(* B terminates when its oracles do *)
lemma B_ll
  (XA'  <: MP.T.XOF_A      {-A, -B})
  (XC'  <: MP.T.SIB.XOF_t  {-A, -B})
  (Htr' <: MP.T.Hash_tr    {-A, -B})
  (Hmu' <: MP.T.Hash_mu    {-A, -B})
  (Hct' <: MP.T.Hash_ct    {-A, -B})
  (O'   <: MP.T.SOracle_CMA{-A, -B}) :
  islossless XA'.get => islossless XC'.get => islossless Htr'.get =>
  islossless Hmu'.get => islossless Hct'.get => islossless O'.sign =>
  islossless B(A, XA', XC', Htr', Hmu', Hct', O').forge.
proof.
move=> hxa hxc htr hmu hct ho; proc.
inline 3; inline 8.
call sigDecode_ll; wp.
call (A_ll (<: CountH(Router11(CountAG(A), XAw(XA'), XCw(XC'), Htrw(Htr'), Hmu', Hctw(Hct'),
                              B(A, XA', XC', Htr', Hmu', Hct', O').O').H))
           (<: CountG(XAw(XA'))) (<: CountS(B(A, XA', XC', Htr', Hmu', Hct', O').O'))).
+ proc; call (rH_ll' (CountAG(A)) XA' XC' Htr' Hmu' Hct' (<: B(A, XA', XC', Htr', Hmu', Hct', O').O')
                    hxc htr hmu hct).
  by auto.
+ by proc; call (xaw_ll XA' hxa); auto.
+ proc; inline 2; wp; seq 3 : true => //; 1: by call ho; auto.
  by sp; if; [wp; call sigEncode_ll | ]; auto.
wp; call (htrw_ll' Htr' htr); inline RO_rest.RO.init RO_pad.RO.init RO_hr.RO.init; wp.
exlim pk => pk0; call (pkEncode_corr pk0.`1 (poly_of_t1 pk0.`2)).
by inline *; auto.
qed.

(* B makes at most as many queries to each oracle of the target as A to
   the oracle it is routed from *)
lemma B_bound
  (XA'  <: MP.T.XOF_A      {-A, -B, -MP.T.CountXA, -MP.T.CountXC, -MP.T.CountHtr, -MP.T.CountHmu, -MP.T.CountHct, -MP.T.CountS})
  (XC'  <: MP.T.SIB.XOF_t  {-A, -B, -MP.T.CountXA, -MP.T.CountXC, -MP.T.CountHtr, -MP.T.CountHmu, -MP.T.CountHct, -MP.T.CountS})
  (Htr' <: MP.T.Hash_tr    {-A, -B, -MP.T.CountXA, -MP.T.CountXC, -MP.T.CountHtr, -MP.T.CountHmu, -MP.T.CountHct, -MP.T.CountS})
  (Hmu' <: MP.T.Hash_mu    {-A, -B, -MP.T.CountXA, -MP.T.CountXC, -MP.T.CountHtr, -MP.T.CountHmu, -MP.T.CountHct, -MP.T.CountS})
  (Hct' <: MP.T.Hash_ct    {-A, -B, -MP.T.CountXA, -MP.T.CountXC, -MP.T.CountHtr, -MP.T.CountHmu, -MP.T.CountHct, -MP.T.CountS})
  (O'   <: MP.T.SOracle_CMA{-A, -B, -MP.T.CountXA, -MP.T.CountXC, -MP.T.CountHtr, -MP.T.CountHmu, -MP.T.CountHct, -MP.T.CountS}) :
  hoare[ B(A, MP.T.CountXA(XA'), MP.T.CountXC(XC'), MP.T.CountHtr(Htr'),
           MP.T.CountHmu(Hmu'), MP.T.CountHct(Hct'), MP.T.CountS(O')).forge :
         MP.T.CountXA.q = 0 /\ MP.T.CountXC.q = 0 /\ MP.T.CountHtr.q = 0 /\
         MP.T.CountHmu.q = 0 /\ MP.T.CountHct.q = 0 /\ MP.T.CountS.q = 0 ==>
         MP.T.CountXA.q <= MP.T.qXA /\ MP.T.CountXC.q <= MP.T.qXC /\
         MP.T.CountHtr.q <= MP.T.qHtr /\ MP.T.CountHmu.q <= MP.T.qHmu /\
         MP.T.CountHct.q <= MP.T.qHct /\ MP.T.CountS.q <= MP.T.qS ].
proof.
proc.
inline 3; inline 8.
call (: true); 1: by conseq />.
wp.
(* the counters of the target are bounded by those of A *)
call (: CountH.c = 0 /\ CountG.c = 0 /\ CountS.c = 0 /\
        MP.T.CountXA.q <= CountG.c /\ MP.T.CountXC.q <= CountH.c /\ MP.T.CountHtr.q <= CountH.c + 1 /\
        MP.T.CountHmu.q <= CountH.c /\ MP.T.CountHct.q <= CountH.c /\ MP.T.CountS.q <= CountS.c ==>
        (CountH.c <= qH /\ CountS.c <= qS) /\ CountG.c <= qG /\
        MP.T.CountXA.q <= CountG.c /\ MP.T.CountXC.q <= CountH.c /\ MP.T.CountHtr.q <= CountH.c + 1 /\
        MP.T.CountHmu.q <= CountH.c /\ MP.T.CountHct.q <= CountH.c /\ MP.T.CountS.q <= CountS.c).
+ conseq (A_count
            (<: Router11(CountAG(A), XAw(MP.T.CountXA(XA')), XCw(MP.T.CountXC(XC')),
                         Htrw(MP.T.CountHtr(Htr')), MP.T.CountHmu(Hmu'), Hctw(MP.T.CountHct(Hct')),
                         B(A, MP.T.CountXA(XA'), MP.T.CountXC(XC'), MP.T.CountHtr(Htr'), MP.T.CountHmu(Hmu'),
                           MP.T.CountHct(Hct'), MP.T.CountS(O')).O').H)
            (<: CountG(XAw(MP.T.CountXA(XA'))))
            (<: B(A, MP.T.CountXA(XA'), MP.T.CountXC(XC'), MP.T.CountHtr(Htr'), MP.T.CountHmu(Hmu'),
                  MP.T.CountHct(Hct'), MP.T.CountS(O')).O'))
         (: CountG.c = 0 /\
            MP.T.CountXA.q <= CountG.c /\ MP.T.CountXC.q <= CountH.c /\ MP.T.CountHtr.q <= CountH.c + 1 /\
            MP.T.CountHmu.q <= CountH.c /\ MP.T.CountHct.q <= CountH.c /\ MP.T.CountS.q <= CountS.c ==>
            CountG.c <= qG /\
            MP.T.CountXA.q <= CountG.c /\ MP.T.CountXC.q <= CountH.c /\ MP.T.CountHtr.q <= CountH.c + 1 /\
            MP.T.CountHmu.q <= CountH.c /\ MP.T.CountHct.q <= CountH.c /\ MP.T.CountS.q <= CountS.c) => //.
  conseq (A_countG
            (<: CountH(Router11(CountAG(A), XAw(MP.T.CountXA(XA')), XCw(MP.T.CountXC(XC')),
                                Htrw(MP.T.CountHtr(Htr')), MP.T.CountHmu(Hmu'), Hctw(MP.T.CountHct(Hct')),
                                B(A, MP.T.CountXA(XA'), MP.T.CountXC(XC'), MP.T.CountHtr(Htr'),
                                  MP.T.CountHmu(Hmu'), MP.T.CountHct(Hct'), MP.T.CountS(O')).O').H))
            (<: XAw(MP.T.CountXA(XA')))
            (<: CountS(B(A, MP.T.CountXA(XA'), MP.T.CountXC(XC'), MP.T.CountHtr(Htr'), MP.T.CountHmu(Hmu'),
                         MP.T.CountHct(Hct'), MP.T.CountS(O')).O')))
         (: MP.T.CountXA.q <= CountG.c /\ MP.T.CountXC.q <= CountH.c /\ MP.T.CountHtr.q <= CountH.c + 1 /\
            MP.T.CountHmu.q <= CountH.c /\ MP.T.CountHct.q <= CountH.c /\ MP.T.CountS.q <= CountS.c ==>
            MP.T.CountXA.q <= CountG.c /\ MP.T.CountXC.q <= CountH.c /\ MP.T.CountHtr.q <= CountH.c + 1 /\
            MP.T.CountHmu.q <= CountH.c /\ MP.T.CountHct.q <= CountH.c /\ MP.T.CountS.q <= CountS.c) => //.
  proc (MP.T.CountXA.q <= CountG.c /\ MP.T.CountXC.q <= CountH.c /\ MP.T.CountHtr.q <= CountH.c + 1 /\
        MP.T.CountHmu.q <= CountH.c /\ MP.T.CountHct.q <= CountH.c /\ MP.T.CountS.q <= CountS.c) => //.
  * proc; inline 2; inline MP.T.CountS(O').sign; wp.
    seq 7 : (MP.T.CountXA.q <= CountG.c /\ MP.T.CountXC.q <= CountH.c /\ MP.T.CountHtr.q <= CountH.c + 1 /\
             MP.T.CountHmu.q <= CountH.c /\ MP.T.CountHct.q <= CountH.c /\ MP.T.CountS.q <= CountS.c).
    - by wp; call (: true); auto => /> /#.
    by if; [wp; call (: true); 1: by conseq /> | ]; auto.
  * proc; inline XAw(MP.T.CountXA(XA')).get MP.T.CountXA(XA').get; sp; wp.
    by if; [wp; call (: true) | call (: true); 1: by auto]; auto => /> /#.
  proc; exlim MP.T.CountXA.q, MP.T.CountXC.q, MP.T.CountHtr.q, MP.T.CountHmu.q, MP.T.CountHct.q,
              MP.T.CountS.q => a b c d e f.
  call (rH_count (CountAG(A)) XA' XC' Htr' Hmu' Hct'
          (<: B(A, MP.T.CountXA(XA'), MP.T.CountXC(XC'), MP.T.CountHtr(Htr'), MP.T.CountHmu(Hmu'),
                MP.T.CountHct(Hct'), MP.T.CountS(O')).O') a b c d e f).
  by auto => /> /#.
wp; inline Htrw(MP.T.CountHtr(Htr')).get MP.T.CountHtr(Htr').get; wp.
call (: true); wp; call (: true); 1: by conseq />.
inline RO_rest.RO.init RO_pad.RO.init RO_hr.RO.init RO_xr.RO.init; wp.
call (: true); 1: by conseq />.
auto => />; smt(qXA_dom qXC_dom qHtr_dom qHmu_dom qHct_dom qS_dom).
qed.

(*************** The game of the target ****************)

(* B makes at most qS signing queries *)
local lemma qs_bound :
  hoare [DST.EUF_CMA(DST.RO1.RO, DST.RO2.RO, DST.RO3.RO, DST.RO4.RO, DST.RO5.RO, MP.T.MLDSA, B(A)).main :
         true ==> size DST.EUF_CMA.qs <= qS].
proof.
proc.
call (: true); 1: by conseq />.
inline 8; inline 11; inline 16.
wp; call (: true); 1: by conseq />.
wp; call (: CountH.c = 0 /\ CountS.c = 0 /\ DST.EUF_CMA.qs = [] ==> size DST.EUF_CMA.qs <= qS).
+ conseq (A_count (<: Router11(CountAG(A), XAw(DST.RO1.RO), XCw(DST.RO2.RO), Htrw(DST.RO3.RO), DST.RO4.RO,
                              Hctw(DST.RO5.RO),
                              B(A, DST.RO1.RO, DST.RO2.RO, DST.RO3.RO, DST.RO4.RO, DST.RO5.RO,
                     DST.EUF_CMA(DST.RO1.RO, DST.RO2.RO, DST.RO3.RO, DST.RO4.RO, DST.RO5.RO, MP.T.MLDSA,
                                 B(A)).O).O').H)
                  (<: CountG(XAw(DST.RO1.RO)))
                  (<: B(A, DST.RO1.RO, DST.RO2.RO, DST.RO3.RO, DST.RO4.RO, DST.RO5.RO,
                     DST.EUF_CMA(DST.RO1.RO, DST.RO2.RO, DST.RO3.RO, DST.RO4.RO, DST.RO5.RO, MP.T.MLDSA,
                                 B(A)).O).O'))
         (: size DST.EUF_CMA.qs <= CountS.c ==> size DST.EUF_CMA.qs <= CountS.c).
  * by move=> &hr [-> [-> ->]].
  * by move=> &hr _ c c0 qs /#.
  proc (size DST.EUF_CMA.qs <= CountS.c) => //.
  * proc; inline 2;
      inline DST.EUF_CMA(DST.RO1.RO, DST.RO2.RO, DST.RO3.RO, DST.RO4.RO, DST.RO5.RO, MP.T.MLDSA,
                         B(A)).O.sign; wp.
    seq 7 : (size DST.EUF_CMA.qs <= CountS.c).
    - by wp; call (: true); [by conseq /> | auto => /> /#].
    by if; [wp; call (: true); 1: by conseq /> | ]; auto.
  * by proc; wp; call (: true); [by conseq /> | auto].
  by proc; wp; call (: true); [by conseq /> | auto].
wp; call (: true); 1: by conseq />.
inline RO_rest.RO.init RO_pad.RO.init RO_hr.RO.init RO_xr.RO.init; wp.
call (: true); 1: by conseq />.
wp; call (: true); 1: by conseq />.
by inline *; auto.
qed.

(* The five-oracle game of the hops with the target scheme is the game of
   the target (same oracles, the bound on the number of signing queries
   holds by A_count) *)
lemma DST_target &m :
  Pr[DST.EUF_CMA(DST.RO1.RO, DST.RO2.RO, DST.RO3.RO, DST.RO4.RO, DST.RO5.RO, MP.T.MLDSA, B(A)).main() @ &m : res] <=
  Pr[MP.T.EF_CMA_MLDSA(B(A)).main() @ &m : res].
proof.
have h0 : Pr[DST.EUF_CMA(DST.RO1.RO, DST.RO2.RO, DST.RO3.RO, DST.RO4.RO, DST.RO5.RO, MP.T.MLDSA,
                         B(A)).main() @ &m : !(size DST.EUF_CMA.qs <= qS)] = 0%r.
+ by byphoare => //; hoare; conseq qs_bound.
have h1 : Pr[DST.EUF_CMA(DST.RO1.RO, DST.RO2.RO, DST.RO3.RO, DST.RO4.RO, DST.RO5.RO, MP.T.MLDSA,
                         B(A)).main() @ &m : res /\ size DST.EUF_CMA.qs <= qS] <=
          Pr[MP.T.EF_CMA_MLDSA(B(A)).main() @ &m : res].
+ byequiv (_ : ={glob A} ==> (res{1} /\ size DST.EUF_CMA.qs{1} <= qS) => res{2}) => //.
  proc.
  inline{2} MP.T.EF_CMA_MLDSA(B(A)).O.fresh MP.T.EF_CMA_MLDSA(B(A)).O.nr_queries; wp.
  call verify_T.
  call (: ={pk, glob A} /\
          DST.RO1.RO.m{1} = MP.T.XA.RO.m{2} /\ DST.RO2.RO.m{1} = MP.T.SIB.XOF.RO.m{2} /\
          DST.RO3.RO.m{1} = MP.T.ROtr.RO.m{2} /\ DST.RO4.RO.m{1} = MP.T.ROmu.RO.m{2} /\
          DST.RO5.RO.m{1} = MP.T.ROct.RO.m{2} /\
          DST.EUF_CMA.sk{1} = MP.T.O_CMA.sk{2} /\ DST.EUF_CMA.qs{1} = rev MP.T.O_CMA.qs{2}
          ==> ={res} /\
          DST.RO1.RO.m{1} = MP.T.XA.RO.m{2} /\ DST.RO2.RO.m{1} = MP.T.SIB.XOF.RO.m{2} /\
          DST.RO3.RO.m{1} = MP.T.ROtr.RO.m{2} /\ DST.RO4.RO.m{1} = MP.T.ROmu.RO.m{2} /\
          DST.RO5.RO.m{1} = MP.T.ROct.RO.m{2} /\ DST.EUF_CMA.qs{1} = rev MP.T.O_CMA.qs{2}).
  + proc; inline{1} 3; inline{2} 3; inline{1} 8; inline{2} 8.
    wp; call (: true); 1: by sim.
    wp; call (: ={RO_xr.RO.m, RO_rest.RO.m, RO_pad.RO.m, RO_hr.RO.m, Router11.tr, CountH.c, CountG.c,
                  CountS.c} /\
                DST.RO1.RO.m{1} = MP.T.XA.RO.m{2} /\ DST.RO2.RO.m{1} = MP.T.SIB.XOF.RO.m{2} /\
                DST.RO3.RO.m{1} = MP.T.ROtr.RO.m{2} /\ DST.RO4.RO.m{1} = MP.T.ROmu.RO.m{2} /\
                DST.RO5.RO.m{1} = MP.T.ROct.RO.m{2} /\
                DST.EUF_CMA.sk{1} = MP.T.O_CMA.sk{2} /\ DST.EUF_CMA.qs{1} = rev MP.T.O_CMA.qs{2}).
    * proc; inline{1} 2; inline{2} 2.
      inline{1} DST.EUF_CMA(DST.RO1.RO, DST.RO2.RO, DST.RO3.RO, DST.RO4.RO, DST.RO5.RO, MP.T.MLDSA,
                            B(A)).O.sign.
      inline{2} MP.T.O_CMA(MP.T.XA.RO, MP.T.SIB.XOF.RO, MP.T.ROtr.RO, MP.T.ROmu.RO, MP.T.ROct.RO).sign.
      seq 7 7 : (={rs, sg, RO_xr.RO.m, RO_rest.RO.m, RO_pad.RO.m, RO_hr.RO.m, Router11.tr, CountH.c, CountG.c,
                   CountS.c} /\
                 DST.RO1.RO.m{1} = MP.T.XA.RO.m{2} /\ DST.RO2.RO.m{1} = MP.T.SIB.XOF.RO.m{2} /\
                 DST.RO3.RO.m{1} = MP.T.ROtr.RO.m{2} /\ DST.RO4.RO.m{1} = MP.T.ROmu.RO.m{2} /\
                 DST.RO5.RO.m{1} = MP.T.ROct.RO.m{2} /\
                 DST.EUF_CMA.sk{1} = MP.T.O_CMA.sk{2} /\ DST.EUF_CMA.qs{1} = rev MP.T.O_CMA.qs{2}).
      - wp; call sign_T; auto => />.
        by move=> &2; rewrite rev_rcons.
      wp; if => //.
      wp; call (: true); 1: by sim.
      by auto => />.
    * by proc; wp; call xaw_T; auto.
    * proc; wp.
      call (rH_T (CountAG(A))
              (<: B(A, DST.RO1.RO, DST.RO2.RO, DST.RO3.RO, DST.RO4.RO, DST.RO5.RO,
                    DST.EUF_CMA(DST.RO1.RO, DST.RO2.RO, DST.RO3.RO, DST.RO4.RO, DST.RO5.RO, MP.T.MLDSA,
                                B(A)).O).O')
              (<: B(A, MP.T.XA.RO, MP.T.SIB.XOF.RO, MP.T.ROtr.RO, MP.T.ROmu.RO, MP.T.ROct.RO,
                    MP.T.O_CMA(MP.T.XA.RO, MP.T.SIB.XOF.RO, MP.T.ROtr.RO, MP.T.ROmu.RO,
                               MP.T.ROct.RO)).O')).
      by auto.
    wp; inline Htrw(DST.RO3.RO).get Htrw(MP.T.ROtr.RO).get; wp.
    call ro3_T; call (: true); 1: by sim.
    inline RO_rest.RO.init RO_pad.RO.init RO_hr.RO.init RO_xr.RO.init; wp.
    call (: true); 1: by sim.
    by auto => />.
  inline{2} MP.T.EF_CMA_MLDSA(B(A)).O.init; wp.
  call keygen_T.
  inline *; auto => /> *.
  smt(mem_rev size_rev qS_dom).
rewrite Pr[mu_split (size DST.EUF_CMA.qs <= qS)].
have : Pr[DST.EUF_CMA(DST.RO1.RO, DST.RO2.RO, DST.RO3.RO, DST.RO4.RO, DST.RO5.RO, MP.T.MLDSA,
                      B(A)).main() @ &m : res /\ !(size DST.EUF_CMA.qs <= qS)] <=
       Pr[DST.EUF_CMA(DST.RO1.RO, DST.RO2.RO, DST.RO3.RO, DST.RO4.RO, DST.RO5.RO, MP.T.MLDSA,
                      B(A)).main() @ &m : !(size DST.EUF_CMA.qs <= qS)]
  by rewrite Pr[mu_sub].
smt().
qed.

(*************** The security theorem ****************)

lemma mldsa_secure (eps : real) &m :
  (forall r, mu1 drnd r <= eps) =>
  Pr[DS2.EUF_CMA(DS2.RO1.RO, DS2.RO2.RO, MLDSA_RO_DS, A).main() @ &m : res] <=
    (* MLWE *)
    `|Pr[MP.SD.RqMLWE.GameL(MP.SD.RedMLWE(MP.SD.RedNMA(MP.SD.RedXOF(MP.RedMLDSA(B(A)))),
                                          MP.SD.FSaCR.DSS.PRO.RO)).main() @ &m : res] -
      Pr[MP.SD.RqMLWE.GameR(MP.SD.RedMLWE(MP.SD.RedNMA(MP.SD.RedXOF(MP.RedMLDSA(B(A)))),
                                          MP.SD.FSaCR.DSS.PRO.RO)).main() @ &m : res]|
    (* SelfTargetMSIS *)
  + Pr[MP.SD.RqStMSIS.Std.Game(
         MP.SD.RqStMSIS.RedStd(MP.SD.FiberSamplerRej,
                               MP.SD.RedMSIS(MP.SD.RedNMA(MP.SD.RedXOF(MP.RedMLDSA(B(A)))))),
         MP.SD.RqStMSIS.Std.PRO.RO).main() @ &m : res]
    (* Fiat-Shamir with aborts: the leakage of the rejected iterations *)
  + ((lvec + kvec + kvec + 2)%r * MP.T.qS%r * ((MP.T.qXC + 2) + MP.T.qS + 1)%r * MP.eps_comm / (1%r - MP.SD.p_rej) +
     MP.T.qS%r * MP.eps_comm * (MP.T.qS%r + 1%r) / (2%r * (1%r - MP.SD.p_rej) ^ 2))
  + MP.eps_check
    (* collisions of the hash functions of the target *)
  + MP.bound_ct + MP.bound_mu
    (* the hops: the separation of SHAKE256 into independent oracles and the
       hedged randomness *)
  + (2 * (qH + qS * (1 + kappa_max)) + qS * (qS + qH + 1) + 6)%r * p512 + (3 * qH + qS + 4)%r * p256 +
    (qS * (qS - 1))%r / 2%r * eps.
proof.
move=> hmu.
have h1 := mldsa_euf_cma A qH qS eps &m qH_ge0 qS_ge0 hmu A_ll A_count.
have h2 := DST_target &m.
have h3 := MP.MLDSA_secure (B(A)) B_bound B_ll &m.
smt().
qed.

end section.

end MLDSA_Security.
