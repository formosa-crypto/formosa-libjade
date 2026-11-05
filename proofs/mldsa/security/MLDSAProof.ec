require import AllCore Distr List IntDiv FSet FMap Leakage Byte Finite.
require import StdOrder.
import RealOrder.
require MLDSAProof_Reduction.

(** Security of [MLDSATarget] by reduction to [SimplifiedScheme]
    (theorem [SD.DilithiumXOF_secure]): the final theorem [MLDSA_secure]
    chains the hops of [doc/proof_overview.tex]
    - G0 -> G1  [hop_expandA]     (MLDSAProof_ExpandA.ec),
    - G1 -> G2  [hop_collisions]  (MLDSAProof_Collisions.ec),
    - G2 -> G3  [hop_reduction]   (MLDSAProof_Reduction.ec),
    with [SD.DilithiumXOF_secure] applied to the reduction [RedMLDSA(A)].
    The clones, the games and the reduction are defined in
    MLDSAProof_Games.ec; each file includes the previous one. *)

abstract theory MLDSAProof.

clone include MLDSAProof_Reduction.MLDSAProof_Reduction.
import T Params DR DV DV.MatRq DV.HL.

section PROOF.


declare module A <: Adv_EFCMA {
  (* MLDSATarget *)
  -XA.RO, -SIB.XOF.RO, -ROtr.RO, -ROmu.RO, -ROct.RO, -O_CMA,
  -CountXA, -CountXC, -CountHtr, -CountHmu, -CountHct, -CountS,
  (* this file and ExpandAEquiv *)
  -RA, -XASim, -EA.RS.Sim, -EA.RS.RO, -EA.RS.IS.RO, -EA.RS.ISR,
  -O_CMA1, -LX.RO, -HctT, -HmuB, -RedSt,
  (* SimplifiedScheme, section XOF *)
  -SD.FSaCR.DSS.DS.Stateless.O_CMA_Default, -SD.H, -SD.OpBasedSig,
  -SD.O_CMA_Default_G, -SD.RO_G, -SD.OpBasedSigG,
  -SD.CMAtoKOA.ORedKOA, -SD.CMAtoKOA.CountS, -SD.CMAtoKOA.CountH,
  -SD.SIB.ORedXOFROC, -SD.SIB.XOF.RO, -SD.SIB.ROC.RO, -SD.XOF,
  -SD.DSSXOF.DS.Stateless.O_CMA_Default,
  -SD.CountS, -SD.CountH, -SD.CountX, -SD.CountSX, -SD.OConv,
  -SD.G, -SD.RqStMSIS.Std.PRO.RO, -SD.RqStMSIS.ORed,
  -SD.OpBased.P, -SD.OpBased.V,
  -SD.CG.FSaG.DSS.DS.Stateless.O_CMA_Default, -SD.CG.FSaG.DSS.PRO.RO,
  -SD.CG.FSaCR.DSS.DS.Stateless.O_CMA_Default, -SD.CG.FSaCR.DSS.PRO.RO,
  -SD.FSaG.DSS.DS.Stateless.O_CMA_Default, -SD.FSaG.DSS.PRO.RO,
  -SD.CMAtoKOA.FSaG.DSS.DS.Stateless.O_CMA_Default, -SD.CMAtoKOA.FSaG.DSS.PRO.RO,
  -SD.CMAtoKOA.OP.P, -SD.CMAtoKOA.OP.V, -SD.CMAtoKOA.RH.RO.RO,
  -SD.CMAtoKOA.RH.Count, -SD.CMAtoKOA.RH.OSign, -SD.CMAtoKOA.OGame1,
  -SD.CMAtoKOA.RedOnce
}.

(* Query bound (see MLDSATarget): at most qXA XOF queries for ExpandA, qXC
   distinct [c~] queried to the challenge XOF, qHtr, qHmu, qHct hash queries
   and qS signing queries. *)
declare axiom A_bound
  (XA'  <: XOF_A      {-A, -CountXA, -CountXC, -CountHtr, -CountHmu, -CountHct, -CountS})
  (XC'  <: SIB.XOF_t  {-A, -CountXA, -CountXC, -CountHtr, -CountHmu, -CountHct, -CountS})
  (Htr' <: Hash_tr    {-A, -CountXA, -CountXC, -CountHtr, -CountHmu, -CountHct, -CountS})
  (Hmu' <: Hash_mu    {-A, -CountXA, -CountXC, -CountHtr, -CountHmu, -CountHct, -CountS})
  (Hct' <: Hash_ct    {-A, -CountXA, -CountXC, -CountHtr, -CountHmu, -CountHct, -CountS})
  (O'   <: SOracle_CMA{-A, -CountXA, -CountXC, -CountHtr, -CountHmu, -CountHct, -CountS}) :
  hoare[ A(CountXA(XA'), CountXC(XC'), CountHtr(Htr'), CountHmu(Hmu'),
           CountHct(Hct'), CountS(O')).forge :
         CountXA.q = 0 /\ CountXC.q = 0 /\ CountHtr.q = 0 /\
         CountHmu.q = 0 /\ CountHct.q = 0 /\ CountS.q = 0 ==>
         CountXA.q <= qXA /\ CountXC.q <= qXC /\ CountHtr.q <= qHtr /\
         CountHmu.q <= qHmu /\ CountHct.q <= qHct /\ CountS.q <= qS ].

(* A terminates, provided its oracles terminate *)
declare axiom A_ll
  (XA'  <: XOF_A      {-A})
  (XC'  <: SIB.XOF_t  {-A})
  (Htr' <: Hash_tr    {-A})
  (Hmu' <: Hash_mu    {-A})
  (Hct' <: Hash_ct    {-A})
  (O'   <: SOracle_CMA{-A}) :
  islossless XA'.get => islossless XC'.get => islossless Htr'.get =>
  islossless Hmu'.get => islossless Hct'.get => islossless O'.sign =>
  islossless A(XA', XC', Htr', Hmu', Hct', O').forge.

(************************************************)
(*         M A I N       T H E O R E M          *)
(************************************************)

(* The bound of [SD.DilithiumXOF_secure] for the reduction [RedMLDSA(A)]
   (MLWE advantage, standard SelfTargetMSIS game with ring challenges, and
   the FS+abort terms with [qH = qXC + 2]: the reduction makes at most
   [qXC + 1] distinct XOF queries, the conversion of the forgery in
   SimplifiedScheme one more), plus the collision bounds of hop_collisions.
   The leakage of [SampleInBall] is the fine one: the pairs [(ctx, j)] after
   every inner iteration. *)

lemma MLDSA_secure &m :
  Pr[EF_CMA_MLDSA(A).main() @ &m : res] <=
    `|Pr[SD.RqMLWE.GameL(SD.RedMLWE(SD.RedNMA(SD.RedXOF(RedMLDSA(A))),
                                    SD.FSaCR.DSS.PRO.RO)).main() @ &m : res] -
      Pr[SD.RqMLWE.GameR(SD.RedMLWE(SD.RedNMA(SD.RedXOF(RedMLDSA(A))),
                                    SD.FSaCR.DSS.PRO.RO)).main() @ &m : res]|
  + Pr[SD.RqStMSIS.Std.Game(
         SD.RqStMSIS.RedStd(SD.FiberSamplerRej,
                            SD.RedMSIS(SD.RedNMA(SD.RedXOF(RedMLDSA(A))))),
         SD.RqStMSIS.Std.PRO.RO).main() @ &m : res]
  + ((Mz + Mr0 + Mhint + 2)%r * qS%r * ((qXC + 2) + qS + 1)%r * eps_comm / (1%r - SD.p_rej) +
     qS%r * eps_comm * (qS%r + 1%r) / (2%r * (1%r - SD.p_rej) ^ 2))
  + eps_check
  + bound_ct + bound_mu.
proof.
rewrite (hop_expandA A A_bound A_ll &m).
have h1 := hop_collisions A A_bound A_ll &m.
have h2 := hop_reduction A A_bound A_ll &m.
have h3 := SD.DilithiumXOF_secure (RedMLDSA(A))
             (B_bound A A_bound A_ll) (B_ll A A_bound A_ll) &m.
smt().
qed.

end section PROOF.

end MLDSAProof.
