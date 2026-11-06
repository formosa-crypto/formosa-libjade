require import AllCore.
from Spec require Spec1024 MLKEMSecurity.

(* The security of ML-KEM-1024: the theorem mlkem_spec_security of the
   generic theory MLKEMSecurityT (IND-CCA in the ROM) at the parameters of
   ML-KEM-1024, restated below for the set as mlkem1024_secure. *)
clone MLKEMSecurity.MLKEMSecurityT as Sec1024 with
  op kvec = Spec1024.Params1024.kvec,
  op du   = Spec1024.Params1024.du,
  op dv   = Spec1024.Params1024.dv,
  op eta1 = Spec1024.Params1024.eta1,
  op eta2 = Spec1024.Params1024.eta2
proof param_sets by exact Spec1024.Params1024.param_sets,
      eta_vals by done.

import Sec1024 MLWEPKEHash MLWE_.

section.

(* The CCA adversary against the specification, whose state is disjoint
   from the modules of the proof. *)
declare module A <: SPEC_MODEL.CCA_ADV {
  -FO_MLKEM.KEMROM.RO.RO.m, -FO_MLKEM.KEMROM.CCA, -FO_MLKEM.B1x2,
  -FO_MLKEM.UU.TT.PKE.OW_CPA, -FO_MLKEM.UU.TT.PKE.BOWp, -FO_MLKEM.UU.TT.PKE.OWL_CPA,
  -FO_MLKEM.UU.TT.PKE.OWvsIND.Bowl, -FO_MLKEM.UU.TT.PKEROM.RO.RO,
  -FO_MLKEM.UU.TT.PKEROM.RO.FRO, -FO_MLKEM.UU.TT.PKEROM.OW_PCVA, -FO_MLKEM.UU.TT.BasePKE,
  -FO_MLKEM.UU.TT.B, -FO_MLKEM.UU.TT.Correctness_Adv1, -FO_MLKEM.UU.TT.CountO,
  -FO_MLKEM.UU.TT.O_AdvOW, -FO_MLKEM.UU.TT.Gm, -FO_MLKEM.UU.RF.RF, -FO_MLKEM.UU.PseudoRF.PRF,
  -FO_MLKEM.UU.KEMROMx2.RO1.RO, -FO_MLKEM.UU.KEMROMx2.RO1.FRO, -FO_MLKEM.UU.KEMROMx2.RO2.RO,
  -FO_MLKEM.UU.KEMROMx2.RO2.FRO, -FO_MLKEM.UU.KEMROMx2.CCA, -FO_MLKEM.UU.CountHx2,
  -FO_MLKEM.UU.RO1E.FunRO, -FO_MLKEM.UU.UU2, -FO_MLKEM.UU.H2, -FO_MLKEM.UU.H2BOWMod,
  -FO_MLKEM.UU.Gm2, -FO_MLKEM.UU.Gm3, -MLWE_PKE_HASH_PRG, -CB, -SPEC_MODEL.RO.RO,
  -SPEC_MODEL.CCA, -NPRF.PRF, -NRF.RF
}.

(* A against the KEM with two hash oracles, and the reductions to the
   inner PKE that the hybrids below wrap: the SHA-3 functions of key
   generation (k1-k7) and encapsulation (e1-e7) replaced by a PRG (HS_DEFS,
   advantage hsadv) and a PRF (PRF_DEFS, advantage prfadv). *)
module AK    = FO_MLKEM.B1x2(A).
module ROWq  = FO_MLKEM.UU.TT.PKE.BOWp(FO_MLKEM.UU.TT.BasePKE,
    FO_MLKEM.UU.TT.AdvOW_query(FO_MLKEM.UU.BUUOWMod(AK))).
module ROW   = FO_MLKEM.UU.TT.PKE.BOWp(FO_MLKEM.UU.TT.BasePKE,
    FO_MLKEM.UU.TT.AdvOW(FO_MLKEM.UU.BUUOWMod(AK))).
module RCorr = FO_MLKEM.UU.TT.B(FO_MLKEM.UU.TT.AdvCorr(FO_MLKEM.UU.BUUOWMod(AK)),
    FO_MLKEM.UU.TT.PKEROM.RO.RO).
module RCI   = FO_MLKEM.UU.TT.B(FO_MLKEM.UU.BUUCI(AK), FO_MLKEM.UU.TT.PKEROM.RO.RO).
module RC    = FO_MLKEM.UU.TT.B(FO_MLKEM.UU.BUUC(AK), FO_MLKEM.UU.TT.PKEROM.RO.RO).
module RIND  = FO_MLKEM.UU.TT.PKE.OWvsIND.Bowl(FO_MLKEM.UU.TT.PKE.OWvsIND.BL(
    FO_MLKEM.UU.TT.AdvOW(FO_MLKEM.UU.BUUOWMod(AK)))).
module ROWLq = FO_MLKEM.UU.TT.PKE.OWvsIND.Bowl(
    FO_MLKEM.UU.TT.AdvOWL_query(FO_MLKEM.UU.BUUOWMod(AK))).

lemma mlkem1024_secure &m (failprob hsadv prfadv : real) :
  (* the decryption failure probability *)
  Pr[CorrectnessBound.main() @ &m : res] <= failprob =>
  (* k1 *)
  `|Pr[HS_DEFS.IND(HS_DEFS.PRGr, B_HS_KG(DC_KG(ROWq))).main() @ &m : res] -
    Pr[HS_DEFS.IND(HS_DEFS.PRGi, B_HS_KG(DC_KG(ROWq))).main() @ &m : res]| <= hsadv =>
  `|Pr[PRF_DEFS.IND(NPRF.PRF, B_PRF_KG(DC_KG(ROWq))).main() @ &m : res] -
    Pr[PRF_DEFS.IND(NRF.RF, B_PRF_KG(DC_KG(ROWq))).main() @ &m : res]| <= prfadv =>
  (* k2 *)
  `|Pr[HS_DEFS.IND(HS_DEFS.PRGr, B_HS_KG(DC_KG(ROW))).main() @ &m : res] -
    Pr[HS_DEFS.IND(HS_DEFS.PRGi, B_HS_KG(DC_KG(ROW))).main() @ &m : res]| <= hsadv =>
  `|Pr[PRF_DEFS.IND(NPRF.PRF, B_PRF_KG(DC_KG(ROW))).main() @ &m : res] -
    Pr[PRF_DEFS.IND(NRF.RF, B_PRF_KG(DC_KG(ROW))).main() @ &m : res]| <= prfadv =>
  (* k3 *)
  `|Pr[HS_DEFS.IND(HS_DEFS.PRGr, B_HS_KG(DC_KG(RCorr))).main() @ &m : res] -
    Pr[HS_DEFS.IND(HS_DEFS.PRGi, B_HS_KG(DC_KG(RCorr))).main() @ &m : res]| <= hsadv =>
  `|Pr[PRF_DEFS.IND(NPRF.PRF, B_PRF_KG(DC_KG(RCorr))).main() @ &m : res] -
    Pr[PRF_DEFS.IND(NRF.RF, B_PRF_KG(DC_KG(RCorr))).main() @ &m : res]| <= prfadv =>
  (* k4 *)
  `|Pr[HS_DEFS.IND(HS_DEFS.PRGr, B_HS_KG(DC_KG(RCI))).main() @ &m : res] -
    Pr[HS_DEFS.IND(HS_DEFS.PRGi, B_HS_KG(DC_KG(RCI))).main() @ &m : res]| <= hsadv =>
  `|Pr[PRF_DEFS.IND(NPRF.PRF, B_PRF_KG(DC_KG(RCI))).main() @ &m : res] -
    Pr[PRF_DEFS.IND(NRF.RF, B_PRF_KG(DC_KG(RCI))).main() @ &m : res]| <= prfadv =>
  (* k5 *)
  `|Pr[HS_DEFS.IND(HS_DEFS.PRGr, B_HS_KG(DC_KG(RC))).main() @ &m : res] -
    Pr[HS_DEFS.IND(HS_DEFS.PRGi, B_HS_KG(DC_KG(RC))).main() @ &m : res]| <= hsadv =>
  `|Pr[PRF_DEFS.IND(NPRF.PRF, B_PRF_KG(DC_KG(RC))).main() @ &m : res] -
    Pr[PRF_DEFS.IND(NRF.RF, B_PRF_KG(DC_KG(RC))).main() @ &m : res]| <= prfadv =>
  (* k6 *)
  `|Pr[HS_DEFS.IND(HS_DEFS.PRGr, B_HS_KG(D_KG(RIND))).main() @ &m : res] -
    Pr[HS_DEFS.IND(HS_DEFS.PRGi, B_HS_KG(D_KG(RIND))).main() @ &m : res]| <= hsadv =>
  `|Pr[PRF_DEFS.IND(NPRF.PRF, B_PRF_KG(D_KG(RIND))).main() @ &m : res] -
    Pr[PRF_DEFS.IND(NRF.RF, B_PRF_KG(D_KG(RIND))).main() @ &m : res]| <= prfadv =>
  (* k7 *)
  `|Pr[HS_DEFS.IND(HS_DEFS.PRGr, B_HS_KG(D_KG(ROWLq))).main() @ &m : res] -
    Pr[HS_DEFS.IND(HS_DEFS.PRGi, B_HS_KG(D_KG(ROWLq))).main() @ &m : res]| <= hsadv =>
  `|Pr[PRF_DEFS.IND(NPRF.PRF, B_PRF_KG(D_KG(ROWLq))).main() @ &m : res] -
    Pr[PRF_DEFS.IND(NRF.RF, B_PRF_KG(D_KG(ROWLq))).main() @ &m : res]| <= prfadv =>
  (* e1 *)
  `|Pr[PRF_DEFS.IND(NPRF.PRF, B_PRF_ENC(DC_ENC(ROWq))).main() @ &m : res] -
    Pr[PRF_DEFS.IND(NRF.RF, B_PRF_ENC(DC_ENC(ROWq))).main() @ &m : res]| <= prfadv =>
  (* e2 *)
  `|Pr[PRF_DEFS.IND(NPRF.PRF, B_PRF_ENC(DC_ENC(ROW))).main() @ &m : res] -
    Pr[PRF_DEFS.IND(NRF.RF, B_PRF_ENC(DC_ENC(ROW))).main() @ &m : res]| <= prfadv =>
  (* e3 *)
  `|Pr[PRF_DEFS.IND(NPRF.PRF, B_PRF_ENC(DC_ENC(RCorr))).main() @ &m : res] -
    Pr[PRF_DEFS.IND(NRF.RF, B_PRF_ENC(DC_ENC(RCorr))).main() @ &m : res]| <= prfadv =>
  (* e4 *)
  `|Pr[PRF_DEFS.IND(NPRF.PRF, B_PRF_ENC(DC_ENC(RCI))).main() @ &m : res] -
    Pr[PRF_DEFS.IND(NRF.RF, B_PRF_ENC(DC_ENC(RCI))).main() @ &m : res]| <= prfadv =>
  (* e5 *)
  `|Pr[PRF_DEFS.IND(NPRF.PRF, B_PRF_ENC(DC_ENC(RC))).main() @ &m : res] -
    Pr[PRF_DEFS.IND(NRF.RF, B_PRF_ENC(DC_ENC(RC))).main() @ &m : res]| <= prfadv =>
  (* e6 *)
  `|Pr[PRF_DEFS.IND(NPRF.PRF, B_PRF_ENC(D_ENC(RIND))).main() @ &m : res] -
    Pr[PRF_DEFS.IND(NRF.RF, B_PRF_ENC(D_ENC(RIND))).main() @ &m : res]| <= prfadv =>
  (* e7 *)
  `|Pr[PRF_DEFS.IND(NPRF.PRF, B_PRF_ENC(D_ENC(ROWLq))).main() @ &m : res] -
    Pr[PRF_DEFS.IND(NRF.RF, B_PRF_ENC(D_ENC(ROWLq))).main() @ &m : res]| <= prfadv =>
  (* the query bounds of the FO transform, and of A *)
  FO_MLKEM.UU.qHT = FO_MLKEM.qHK =>
  FO_MLKEM.UU.qHU = FO_MLKEM.qHK =>
  FO_MLKEM.UU.TT.qH = FO_MLKEM.UU.qHT + FO_MLKEM.UU.qHU + 1 =>
  FO_MLKEM.UU.TT.qV = 0 =>
  FO_MLKEM.UU.TT.qP = 0 =>
  FO_MLKEM.UU.TT.qH + 1 = FO_MLKEM.UU.TT.qHC =>
  FO_MLKEM.UU.TT.qHC < FO_MLKEM.UU.TT.FinT.card - 1 =>
  (forall (RO0 <: FO_MLKEM.KEMROM.POracle {-FO_MLKEM.CountH, -A})
          (O0 <: FO_MLKEM.KEMROM.CCA_ORC {-FO_MLKEM.CountH, -A}),
     hoare[A(FO_MLKEM.CountH(RO0), O0).guess :
           FO_MLKEM.CountH.c_h = 0 ==> FO_MLKEM.CountH.c_h <= FO_MLKEM.qHK]) =>
  (* A terminates *)
  (forall (H0 <: FO_MLKEM.KEMROM.POracle {-A}) (O0 <: FO_MLKEM.UU.KEMROMx2.CCA_ORC {-A}),
     islossless O0.dec => islossless H0.get => islossless A(H0, O0).guess) =>
  (* the bound: twice the MLWE advantages of the reductions B1 and B2 (and
     the hybrids), for the two hops of the proof, the failure probability,
     the PRF J of the implicit rejection and the message entropy *)
  `|Pr[SPEC_MODEL.CCA(SPEC_MODEL.RO.RO, MLKEM_Op, A).main() @ &m : res] - 1%r / 2%r| <=
    2%r *
      (`|Pr[MLWE_H(B1(ROWLq)).main(false, false) @ &m : res] -
         Pr[MLWE_H(B1(ROWLq)).main(false, true) @ &m : res]| +
       `|Pr[MLWE_H(B2(ROWLq)).main(true, false) @ &m : res] -
         Pr[MLWE_H(B2(ROWLq)).main(true, true) @ &m : res]| +
       hsadv + 2%r * prfadv) +
    2%r *
      (`|Pr[MLWE_H(B1(RIND)).main(false, false) @ &m : res] -
         Pr[MLWE_H(B1(RIND)).main(false, true) @ &m : res]| +
       `|Pr[MLWE_H(B2(RIND)).main(true, false) @ &m : res] -
         Pr[MLWE_H(B2(RIND)).main(true, true) @ &m : res]| +
       hsadv + 2%r * prfadv) +
    (3%r * (2 * FO_MLKEM.qHK + 3)%r + 1%r) * (failprob + hsadv + 2%r * prfadv) +
    `|Pr[FO_MLKEM.UU.J.IND(FO_MLKEM.UU.PseudoRF.PRF, FO_MLKEM.UU.D(AK)).main() @ &m : res] -
      Pr[FO_MLKEM.UU.J.IND(FO_MLKEM.UU.RF.RF, FO_MLKEM.UU.D(AK)).main() @ &m : res]| +
    2%r * (2 * FO_MLKEM.qHK + 2)%r * FO_MLKEM.UU.TT.PKE.eps_msg.
proof. exact (mlkem_spec_security A). qed.

end section.
