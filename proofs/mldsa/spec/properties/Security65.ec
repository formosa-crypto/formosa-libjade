require import AllCore Distr.
require Spec65 MLDSA_Security.

(* The security of ML-DSA-65: the theorem mldsa_secure of the generic
   theory MLDSA_Security (EUF-CMA in the ROM, hedged signing, with leakage),
   instantiated on the specification MLDSA65 (the instance used by the
   implementation proofs), restated below for the set as mldsa65_secure. *)
clone MLDSA_Security.MLDSA_Security as Sec65 with
  theory Spec <- Spec65.MLDSA65.

import Sec65 Spec65.MLDSA65.

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
  -MP.SD.SIB.ORedXOFROC, -MP.SD.SIB.XOF.RO, -MP.SD.SIB.ROC.RO, -MP.SD.SIB.ROC.FRO, -MP.SD.XOF,
  -MP.SD.HctRO.RO, -MP.SD.HctRO.FRO, -MP.SD.CacheRO,
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

lemma mldsa65_secure (eps : real) &m :
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
    (* Fiat-Shamir with aborts: the leakage of the rejected iterations
       (with c~ leaked at every iteration, the Hct queries are the queries
       to the oracle of the chain: [MP.T.qHct], which, like [MP.T.qXC]
       before, only has to dominate the SHAKE256 bound [qH], [qHct_dom]) *)
  + ((lvec + kvec + kvec + 2)%r * MP.T.qS%r * ((MP.T.qHct + 2) + MP.T.qS + 1)%r *
       MP.eps_comm / (1%r - MP.SD.p_rej) +
     MP.T.qS%r * MP.eps_comm * (MP.T.qS%r + 1%r) / (2%r * (1%r - MP.SD.p_rej) ^ 2))
  + MP.eps_check
    (* collisions of the hash functions of the target *)
  + MP.bound_ct + MP.bound_mu
    (* the hops: the separation of SHAKE256 into independent oracles and the
       hedged randomness *)
  + (2 * (qH + qS * (1 + kappa_max)) + qS * (qS + qH + 1) + 6)%r * p512 +
    (3 * qH + qS + 4)%r * p256 +
    (qS * (qS - 1))%r / 2%r * eps.
proof.
exact (mldsa_secure A A_ll A_count A_countG qH_ge0 qG_ge0 qS_ge0
                      qXA_dom qXC_dom qHtr_dom qHmu_dom qHct_dom qS_dom).
qed.

end section.
