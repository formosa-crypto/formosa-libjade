require import AllCore Distr List IntDiv FSet FMap Leakage Byte Finite.
require import StdOrder.
import RealOrder.
require PROM TableCollision MLDSAProof_ExpandA.

(** Hop G1 -> G2 of [doc/proof_overview.tex] (injective hashes):
    [hop_collisions], up to the collisions on [Hct]/[XC] and on [Hmu]. G1
    and G2 sample [c~] at the same moments (every [Hct] query of the
    adversary, every iteration of the signing loop, the verification), so
    that G1 is G2 up to the bad event [HctT.bad] of G2 (a fresh [c~] which is
    already an output of [Hct], or which was already queried to the local
    XOF [LX]): an up-to-bad step with the invariant [rel] relating the
    tables of G1 ([Hct], XOF on [c~]) and of G2 (random oracle of
    SimplifiedScheme, [LX], [tinv], [leakT]). The probabilities of [HctT.bad]
    and of a collision on [Hmu] are bounded by two instances of
    [TableCollision] ([ct_bound], [mu_bound]). The signing procedures are
    instances of [MLDSAGen] which only differ by their challenge ([ChalH],
    [ChalX]). *)

abstract theory MLDSAProof_Collisions.

clone include MLDSAProof_ExpandA.MLDSAProof_ExpandA.
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
  -SD.SIB.ORedXOFROC, -SD.SIB.XOF.RO, -SD.SIB.ROC.RO, -SD.SIB.ROC.FRO, -SD.XOF,
  -SD.HctRO.RO, -SD.HctRO.FRO, -SD.CacheRO,
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

(* ==================================================================== *)
(* Collisions on [Hmu]: TableCollision on the table [HmuB.m] (no [put]) *)
(* ==================================================================== *)

local clone TableCollision as TCmu with
  type in_t  <- tr_t * M,
  type out_t <- mu_t,
  op   dout  <- dmu,
  op   eps   <- eps_mu
proof *.
realize dout_ll by exact dmu_ll.
realize dout_max by exact dmu_max.

(* G2 as an adversary of TableCollision, the table [T] answers [Hmu] (with
   the query counters of MLDSATarget, to apply [A_bound]) *)
local module Amu (T : TCmu.Oracle) = {
  module XC = XCSim(SD.XOF)
  module S  = MLDSA1(XC, ROtr.RO, T, HctT)
  module O1 = O_CMA1(MLDSAGen(MatRA, ChalX, T))

  proc main() : unit = {
    var pk, sk, m, sig, is_valid;

    XASim.init();
    RA.init();
    SD.XOF.init();
    LX.RO.init();
    HctT.init();
    ROtr.RO.init();
    CountXA.q <- 0;
    CountXC.q <- 0;
    CountXC.xs <- fset0;
    CountHtr.q <- 0;
    CountHmu.q <- 0;
    CountHct.q <- 0;
    CountS.q <- 0;
    (pk, sk) <@ S.keygen();
    RA.rho <- pk.`1;
    RA.mA  <- sk.`1;
    O1.init(sk.`2);
    (m, sig) <@ A(CountXA(XASim), CountXC(XC), CountHtr(ROtr.RO), CountHmu(T),
                  CountHct(HctT), CountS(O1)).forge(pk);
    is_valid <@ S.verify(sk.`1, pk, m, sig);
  }
}.

(* The table [HmuB] of G2 is the table of TableCollision, which has no
   [put] (an abbreviation: the tactics see the conjunction) *)
local abbrev tmu (m1 : (tr_t * M, mu_t) fmap) (bad1 : bool) (m2 : (tr_t * M, mu_t) fmap)
  (bad2 : bool) (ks : mu_t fset) =
  m1 = m2 /\ bad1 = bad2 /\ ks = fset0.

local lemma HmuB_Tab :
  equiv[HmuB.get ~ TCmu.Count(TCmu.Tab).get :
        ={x} /\ tmu HmuB.m{1} HmuB.bad{1} TCmu.Tab.m{2} TCmu.Tab.bad{2} TCmu.Tab.ks{2} ==>
        ={res} /\ tmu HmuB.m{1} HmuB.bad{1} TCmu.Tab.m{2} TCmu.Tab.bad{2} TCmu.Tab.ks{2}].
proof. by proc; inline *; sp; if => //; auto => /> &2 _ mu _; rewrite in_fset0. qed.

local lemma G2_Amu &m :
  Pr[G2(A).main() @ &m : HmuB.bad] <= Pr[TCmu.Game(Amu).main() @ &m : TCmu.Tab.bad].
proof.
byequiv => //; proc; inline TCmu.Game(Amu).main Amu(TCmu.Count(TCmu.Tab)).main.
inline{1} G2(A).O.fresh G2(A).O.nr_queries; wp.
call (: ={arg, glob XASim, SD.DSSXOF.PRO.RO.m, LX.RO.m, glob HctT, ROtr.RO.m} /\
        tmu HmuB.m{1} HmuB.bad{1} TCmu.Tab.m{2} TCmu.Tab.bad{2} TCmu.Tab.ks{2} ==>
        HmuB.bad{1} = TCmu.Tab.bad{2}).
- proc; call (: ={glob HctT, LX.RO.m, SD.DSSXOF.PRO.RO.m}); 1: by sim.
  wp; call (: ={glob HctT, LX.RO.m, SD.DSSXOF.PRO.RO.m}); 1: by sim.
  call HmuB_Tab.
  by call (: ={ROtr.RO.m}); 1: sim; auto.
call (: ={glob XASim, SD.DSSXOF.PRO.RO.m, LX.RO.m, glob HctT, ROtr.RO.m,
          O_CMA1.sk, O_CMA1.qs} /\
        tmu HmuB.m{1} HmuB.bad{1} TCmu.Tab.m{2} TCmu.Tab.bad{2} TCmu.Tab.ks{2}).
- proc; inline{2} 2; wp.
  call (: ={sk, m, glob XASim, SD.DSSXOF.PRO.RO.m, LX.RO.m, glob HctT, ROtr.RO.m} /\
          tmu HmuB.m{1} HmuB.bad{1} TCmu.Tab.m{2} TCmu.Tab.bad{2} TCmu.Tab.ks{2} ==>
          ={res, glob XASim, SD.DSSXOF.PRO.RO.m, LX.RO.m, glob HctT, ROtr.RO.m} /\
          tmu HmuB.m{1} HmuB.bad{1} TCmu.Tab.m{2} TCmu.Tab.bad{2} TCmu.Tab.ks{2}).
  + proc; seq 7 7 : (={ct, r0_fail, hint_fail, mA, la, leak, rho, tr, s1, s2, t0, mu,
                       glob XASim, SD.DSSXOF.PRO.RO.m, LX.RO.m, glob HctT, ROtr.RO.m} /\
                     tmu HmuB.m{1} HmuB.bad{1} TCmu.Tab.m{2} TCmu.Tab.bad{2} TCmu.Tab.ks{2}).
    * call HmuB_Tab; inline MatRA.get; wp.
      by call (: ={glob XASim}); [sim | auto].
    sim / (tmu HmuB.m{1} HmuB.bad{1} TCmu.Tab.m{2} TCmu.Tab.bad{2} TCmu.Tab.ks{2}) :
          (={ct, response, leak, rho, la, glob XASim, SD.DSSXOF.PRO.RO.m, LX.RO.m, glob HctT,
             ROtr.RO.m}).
  by auto.
- by proc *; inline{2} 1; wp; call (: ={glob HctT, LX.RO.m, SD.DSSXOF.PRO.RO.m}); [sim | auto].
- by proc *; inline{2} 1; wp; call HmuB_Tab; auto.
- by proc *; inline{2} 1; wp; call (: ={ROtr.RO.m}); [sim | auto].
- by proc *; inline{2} 1; wp; call (: ={glob HctT, LX.RO.m, SD.DSSXOF.PRO.RO.m}); [sim | auto].
- by proc *; inline{2} 1; wp; call (: ={glob XASim}); [sim | auto].
by inline *; auto => />.
qed.

(* [Hmu] is queried [qHmu] times by A, once per signing query and once by
   the verification *)
local lemma Amu_bound (T <: TCmu.Oracle{-TCmu.Count, -Amu}) :
  hoare[ Amu(TCmu.Count(T)).main :
         TCmu.Count.cg = 0 /\ TCmu.Count.cp = 0 ==>
         TCmu.Count.cg <= qHmu + qS + 1 /\ TCmu.Count.cp <= 0 ].
proof.
proc.
seq 18 : (TCmu.Count.cp = 0 /\ TCmu.Count.cg <= qHmu + qS).
- seq 17 : (TCmu.Count.cp = 0 /\ TCmu.Count.cg = 0 /\ CountXA.q = 0 /\ CountXC.q = 0 /\
            CountHtr.q = 0 /\ CountHmu.q = 0 /\ CountHct.q = 0 /\ CountS.q = 0).
  + by inline *; auto.
  conseq (: _ ==> TCmu.Count.cp = 0 /\ TCmu.Count.cg <= CountHmu.q + CountS.q)
         (: CountXA.q = 0 /\ CountXC.q = 0 /\ CountHtr.q = 0 /\ CountHmu.q = 0 /\
            CountHct.q = 0 /\ CountS.q = 0 ==> CountHmu.q <= qHmu /\ CountS.q <= qS) => //;
    1: smt().
  + by call (A_bound XASim (XCSim(SD.XOF)) ROtr.RO (TCmu.Count(T)) HctT
                     (O_CMA1(MLDSAGen(MatRA, ChalX, TCmu.Count(T))))); auto.
  call (: TCmu.Count.cp = 0 /\ TCmu.Count.cg <= CountHmu.q + CountS.q).
  + proc; inline O_CMA1(MLDSAGen(MatRA, ChalX, TCmu.Count(T))).sign
                 MLDSAGen(MatRA, ChalX, TCmu.Count(T)).sign; wp.
    seq 13 : (TCmu.Count.cp = 0 /\ TCmu.Count.cg <= CountHmu.q + CountS.q).
    * inline TCmu.Count(T).get; wp; call (: true); wp.
      by call (: true); [conseq (: _ ==> true) | auto => /> /#].
    while (TCmu.Count.cp = 0 /\ TCmu.Count.cg <= CountHmu.q + CountS.q); 2: by auto.
    by wp; if => //; wp; call (: true) => //; auto.
  + by proc; call (: true) => //; auto.
  + by proc; inline *; wp; call (: true); auto => /> /#.
  + by proc; call (: true) => //; auto.
  + by proc; call (: true) => //; auto.
  + by proc; call (: true) => //; auto.
  by auto.
inline Amu(TCmu.Count(T)).S.verify; wp; call (: true) => //; wp; call (: true) => //.
inline TCmu.Count(T).get; wp; call (: true) => //; wp; call (: true) => //.
by auto => /> /#.
qed.

local lemma mu_bound &m :
  Pr[G2(A).main() @ &m : HmuB.bad] <= bound_mu.
proof.
apply (ler_trans _ _ _ (G2_Amu &m)).
have := TCmu.table_collision Amu 0 (qHmu + qS + 1) _ _ Amu_bound &m.
- done.
- smt(qHmu_ge0 qS_ge0).
by rewrite /bound_mu /= RField.expr2 fromintM.
qed.

(* ==================================================================== *)
(* Collisions on [Hct] ([HctT.bad]): TableCollision on the table of the  *)
(* commitment hash (the [XH] entries of the random oracle of            *)
(* SimplifiedScheme); the [put] values are the [c~] queried to the      *)
(* challenge XOF                                                        *)
(* ==================================================================== *)

local clone TableCollision as TCct with
  type in_t  <- high list * mu_t,
  type out_t <- ctilde,
  op   dout  <- dct,
  op   eps   <- eps_ct
proof *.
realize dout_ll by exact dct_ll.
realize dout_max by exact dct_max.

(* [Hct] samples through the [get] oracle of TableCollision, and copies its
   answer in the random oracle of SimplifiedScheme *)
local module HB (T : TCct.Oracle) = {
  proc sample(x : high list * mu_t) : ctilde = {
    var ct;
    ct <@ T.get(x);
    if (SD.XH x \notin SD.XOF.m) {
      SD.XOF.m.[SD.XH x] <- SD.OH ct;
    }
    return ct;
  }

  proc get(x : high list * mu_t) : ctilde = {
    var ct;
    ct <@ sample(x);
    if (ct \notin HctT.tinv) {
      HctT.tinv.[ct] <- x;
    }
    return ct;
  }
}.

local module ChalB (T : TCct.Oracle) : ChalGen = {
  proc get(w1 : high list, mu : mu_t) : ctilde * Rq * leakage = {
    var ct, c, lc;
    ct <@ HB(T).sample(w1, mu);
    (c, lc) <@ SD.SIB.SampleInBall(SD.XofOf(SD.XOF)).get(w1, mu);
    HctT.leakT.[ct] <- SD.SIB.leak_to_stream lc;
    return (ct, c, lc);
  }
}.

(* [XC] puts every [c~] queried *)
local module XCB (T : TCct.Oracle) : SIB.XOF_t = {
  var ps : ctilde fset

  proc get(y : ctilde * int) : byte = {
    var r;
    if (y.`1 \notin ps) {
      T.put(y.`1);
      ps <- ps `|` fset1 y.`1;
    }
    r <@ XCSim(SD.XOF).get(y);
    return r;
  }
}.

(* G2 as an adversary of TableCollision (with the query counters of
   MLDSATarget, to apply [A_bound]) *)
local module Act (T : TCct.Oracle) = {
  module XC = XCB(T)
  module H  = HB(T)
  module S  = MLDSA1(XC, ROtr.RO, HmuB, H)
  module O1 = O_CMA1(MLDSAGen(MatRA, ChalB(T), HmuB))

  proc main() : unit = {
    var pk, sk, m, sig, is_valid;

    XASim.init();
    RA.init();
    SD.XOF.init();
    LX.RO.init();
    HctT.init();
    ROtr.RO.init();
    HmuB.init();
    XCB.ps <- fset0;
    CountXA.q <- 0;
    CountXC.q <- 0;
    CountXC.xs <- fset0;
    CountHtr.q <- 0;
    CountHmu.q <- 0;
    CountHct.q <- 0;
    CountS.q <- 0;
    (pk, sk) <@ S.keygen();
    RA.rho <- pk.`1;
    RA.mA  <- sk.`1;
    O1.init(sk.`2);
    (m, sig) <@ A(CountXA(XASim), CountXC(XC), CountHtr(ROtr.RO), CountHmu(HmuB),
                  CountHct(H), CountS(O1)).forge(pk);
    is_valid <@ S.verify(sk.`1, pk, m, sig);
  }
}.

(* The table of TableCollision is the [XH] part of the random oracle of
   SimplifiedScheme, the [put] values contain the [c~] queried to [LX], and
   the bad event of G2 implies the one of TableCollision (an abbreviation:
   the tactics see the conjunction) *)
local op ct_tab (tm : (high list * mu_t, ctilde) fmap) (m : (SD.xin, SD.xout) fmap) =
  forall x, tm.[x] = omap SD.oh m.[SD.XH x].

local abbrev crel (tm : (high list * mu_t, ctilde) fmap) (ks : ctilde fset) (bad2 : bool)
  (m : (SD.xin, SD.xout) fmap) (ps : ctilde fset) (lm : (ctilde * int, byte) fmap) (bad1 : bool) =
  ct_tab tm m /\ ks = ps /\ (forall ct i, (ct, i) \in lm => ct \in ps) /\ (bad1 => bad2).

local lemma HctT_HB :
  equiv[HctT.sample ~ HB(TCct.Count(TCct.Tab)).sample :
        ={x, SD.XOF.m, LX.RO.m} /\
        crel TCct.Tab.m{2} TCct.Tab.ks{2} TCct.Tab.bad{2} SD.XOF.m{2} XCB.ps{2} LX.RO.m{2}
             HctT.bad{1} ==>
        ={res, SD.XOF.m, LX.RO.m} /\
        crel TCct.Tab.m{2} TCct.Tab.ks{2} TCct.Tab.bad{2} SD.XOF.m{2} XCB.ps{2} LX.RO.m{2}
             HctT.bad{1}].
proof.
proc; inline *; sp.
case (SD.XH x{1} \in SD.XOF.m{1}).
- rcondf{1} 2; 1: by auto.
  rcondf{2} 1.
  + move=> &1; auto => /> &2 htab _ _ h; rewrite domE htab; move: h; rewrite domE.
    by case: (SD.XOF.m{2}.[SD.XH x{2}]).
  rcondf{2} 3; 1: by auto.
  rcondf{1} 3; 1: by auto.
  wp; rnd{1}; skip => &1 &2 [[cg h] hin]; move: h => [#] 7!->> htab hps hl hbad hb.
  rewrite dxout_XH dmap_ll ?dct_ll /= => _ _; rewrite (hps x{2}) /=.
  by split; [move: hin; rewrite domE; case: (SD.DSSXOF.PRO.RO.m{2}.[SD.XH x{2}]) | ].
rcondt{1} 2; 1: by auto.
rcondt{1} 4; 1: by auto.
rcondt{2} 1.
- move=> &1; auto => /> &2 htab hl hb hin.
  by move: hin; rewrite !domE (htab x{2}); case: (SD.DSSXOF.PRO.RO.m{2}.[SD.XH x{2}]).
rcondt{2} 6; 1: by auto.
wp; rnd SD.oh SD.OH; skip.
move=> &1 &2 [[cg h] hin]; move: h => [#] 7!->> htab hps hl hbad hb.
split => [c _ // | _]; split => [c _ | _]; 1: by rewrite dxout_XH mu1_dOH.
move=> o; rewrite dxout_XH => ho; rewrite -(supp_dOH _ ho) /= !get_set_sameE /=.
rewrite -(supp_dOH _ ho) /= htab /=.
split.
- move=> x'; rewrite !get_setE /=.
  by case: (x' = x{2}) => // _; exact (hps x').
split => //; split => // hb'.
case: hb' => [/hb -> // | [[x' hx'] | [i hi]]].
- by right; left; rewrite mem_frng rngE /=; exists x'; rewrite (hps x') hx'.
by right; right; rewrite hl; apply (hbad _ i).
qed.

local lemma HctT_HB_get :
  equiv[HctT.get ~ HB(TCct.Count(TCct.Tab)).get :
        ={x, SD.XOF.m, LX.RO.m, HctT.tinv} /\
        crel TCct.Tab.m{2} TCct.Tab.ks{2} TCct.Tab.bad{2} SD.XOF.m{2} XCB.ps{2} LX.RO.m{2}
             HctT.bad{1} ==>
        ={res, SD.XOF.m, LX.RO.m, HctT.tinv} /\
        crel TCct.Tab.m{2} TCct.Tab.ks{2} TCct.Tab.bad{2} SD.XOF.m{2} XCB.ps{2} LX.RO.m{2}
             HctT.bad{1}].
proof. by proc; wp; call HctT_HB; auto. qed.

local lemma ct_tab_XB tm m y o : ct_tab tm m => ct_tab tm m.[SD.XB y <- o].
proof. by move=> h x; rewrite get_setE /= h. qed.

local lemma XC_B :
  equiv[XCSim(SD.XOF).get ~ XCB(TCct.Count(TCct.Tab)).get :
        ={y, SD.XOF.m, LX.RO.m, HctT.tinv, HctT.leakT} /\
        crel TCct.Tab.m{2} TCct.Tab.ks{2} TCct.Tab.bad{2} SD.XOF.m{2} XCB.ps{2} LX.RO.m{2}
             HctT.bad{1} ==>
        ={res, SD.XOF.m, LX.RO.m, HctT.tinv, HctT.leakT} /\
        crel TCct.Tab.m{2} TCct.Tab.ks{2} TCct.Tab.bad{2} SD.XOF.m{2} XCB.ps{2} LX.RO.m{2}
             HctT.bad{1}].
proof.
proc.
seq 0 1 : (={y, SD.XOF.m, LX.RO.m, HctT.tinv, HctT.leakT} /\ y{2}.`1 \in XCB.ps{2} /\
           crel TCct.Tab.m{2} TCct.Tab.ks{2} TCct.Tab.bad{2} SD.XOF.m{2} XCB.ps{2} LX.RO.m{2}
                HctT.bad{1}).
- if{2}; 2: by auto.
  inline *; auto => /> &1 &2 htab hps _ _; split; 1: by rewrite in_fsetU in_fset1.
  by move=> ct i /hps; rewrite in_fsetU => ->.
inline{2} 1; wp; sp 0 1.
if => //.
- by inline *; auto.
if => //; 1: by auto.
if => //.
- by inline *; auto => /> &1 &2 _ htab *; apply ct_tab_XB.
inline *; auto => /> &1 &2 hy htab hps hb _ _ _ r _ ct i.
by rewrite mem_set => -[/hps // | heq]; move: hy; rewrite -heq.
qed.

local lemma SIB_B :
  equiv[SIB.SampleInBall(XCSim(SD.XOF)).get ~ SIB.SampleInBall(XCB(TCct.Count(TCct.Tab))).get :
        ={x, SD.XOF.m, LX.RO.m, HctT.tinv, HctT.leakT} /\
        crel TCct.Tab.m{2} TCct.Tab.ks{2} TCct.Tab.bad{2} SD.XOF.m{2} XCB.ps{2} LX.RO.m{2}
             HctT.bad{1} ==>
        ={res, SD.XOF.m, LX.RO.m, HctT.tinv, HctT.leakT} /\
        crel TCct.Tab.m{2} TCct.Tab.ks{2} TCct.Tab.bad{2} SD.XOF.m{2} XCB.ps{2} LX.RO.m{2}
             HctT.bad{1}].
proof.
proc.
while (={i, ctx, signs, challenge, leak, x, byte, SD.XOF.m, LX.RO.m, HctT.tinv, HctT.leakT} /\
       crel TCct.Tab.m{2} TCct.Tab.ks{2} TCct.Tab.bad{2} SD.XOF.m{2} XCB.ps{2} LX.RO.m{2}
            HctT.bad{1}).
- wp; while (={i, j, ctx, signs, challenge, leak, x, byte, SD.XOF.m, LX.RO.m, HctT.tinv,
               HctT.leakT} /\
             crel TCct.Tab.m{2} TCct.Tab.ks{2} TCct.Tab.bad{2} SD.XOF.m{2} XCB.ps{2} LX.RO.m{2}
                  HctT.bad{1}).
  + by wp; call XC_B; auto.
  by auto.
wp; while (={ctx, signs, x, byte, SD.XOF.m, LX.RO.m, HctT.tinv, HctT.leakT} /\
           crel TCct.Tab.m{2} TCct.Tab.ks{2} TCct.Tab.bad{2} SD.XOF.m{2} XCB.ps{2} LX.RO.m{2}
                HctT.bad{1}).
- by wp; call XC_B; auto.
by auto.
qed.

local lemma XB_tab :
  equiv[SD.XofOf(SD.XOF).get ~ SD.XofOf(SD.XOF).get :
        ={y, SD.XOF.m} /\ ct_tab TCct.Tab.m{2} SD.XOF.m{2} ==>
        ={res, SD.XOF.m} /\ ct_tab TCct.Tab.m{2} SD.XOF.m{2}].
proof.
proc; inline *; auto => /> &2 htab r _ _.
exact: ct_tab_XB.
qed.

local lemma SDSIB_tab :
  equiv[SD.SIB.SampleInBall(SD.XofOf(SD.XOF)).get ~ SD.SIB.SampleInBall(SD.XofOf(SD.XOF)).get :
        ={x, SD.XOF.m} /\ ct_tab TCct.Tab.m{2} SD.XOF.m{2} ==>
        ={res, SD.XOF.m} /\ ct_tab TCct.Tab.m{2} SD.XOF.m{2}].
proof.
proc.
while (={i, ctx, signs, challenge, leak, x, byte, SD.XOF.m} /\ ct_tab TCct.Tab.m{2} SD.XOF.m{2}).
- wp; while (={i, j, ctx, signs, challenge, leak, x, byte, SD.XOF.m} /\
             ct_tab TCct.Tab.m{2} SD.XOF.m{2}).
  + by wp; call XB_tab; auto.
  by auto.
wp; while (={ctx, signs, x, byte, SD.XOF.m} /\ ct_tab TCct.Tab.m{2} SD.XOF.m{2}).
- by wp; call XB_tab; auto.
by auto.
qed.

local lemma Sign_B :
  equiv[MLDSAGen(MatRA, ChalX, HmuB).sign ~ MLDSAGen(MatRA, ChalB(TCct.Count(TCct.Tab)), HmuB).sign :
        ={sk, m, glob XASim, SD.XOF.m, LX.RO.m, HctT.tinv, HctT.leakT, HmuB.m, HmuB.bad} /\
        crel TCct.Tab.m{2} TCct.Tab.ks{2} TCct.Tab.bad{2} SD.XOF.m{2} XCB.ps{2} LX.RO.m{2}
             HctT.bad{1} ==>
        ={res, glob XASim, SD.XOF.m, LX.RO.m, HctT.tinv, HctT.leakT, HmuB.m, HmuB.bad} /\
        crel TCct.Tab.m{2} TCct.Tab.ks{2} TCct.Tab.bad{2} SD.XOF.m{2} XCB.ps{2} LX.RO.m{2}
             HctT.bad{1}].
proof.
proc.
seq 9 9 : (={mA, la, rho, s1, s2, t0, mu, ct, response, leak, r0_fail, hint_fail, ctr, glob XASim,
               SD.XOF.m, LX.RO.m, HctT.tinv, HctT.leakT, HmuB.m, HmuB.bad} /\
           crel TCct.Tab.m{2} TCct.Tab.ks{2} TCct.Tab.bad{2} SD.XOF.m{2} XCB.ps{2} LX.RO.m{2}
                HctT.bad{1}).
- wp; call (: ={HmuB.m, HmuB.bad}); 1: by sim.
  by wp; call (: ={glob XASim}); [sim | auto].
while (={ctr, mA, s1, s2, t0, mu, ct, response, leak, r0_fail, hint_fail, glob XASim,
         SD.XOF.m, LX.RO.m, HctT.tinv, HctT.leakT, HmuB.m, HmuB.bad} /\
       crel TCct.Tab.m{2} TCct.Tab.ks{2} TCct.Tab.bad{2} SD.XOF.m{2} XCB.ps{2} LX.RO.m{2}
            HctT.bad{1}); 2: by auto.
wp; if => //.
inline ChalX.get ChalB(TCct.Count(TCct.Tab)).get; wp.
call SDSIB_tab; wp; call HctT_HB; auto => /> /#.
qed.

local lemma G2_Act &m :
  Pr[G2(A).main() @ &m : HctT.bad] <= Pr[TCct.Game(Act).main() @ &m : TCct.Tab.bad].
proof.
byequiv (_ : ={glob A} ==> HctT.bad{1} => TCct.Tab.bad{2}) => //.
proc; inline TCct.Game(Act).main Act(TCct.Count(TCct.Tab)).main.
inline{1} G2(A).O.fresh G2(A).O.nr_queries; wp.
call (: ={arg, SD.XOF.m, LX.RO.m, HctT.tinv, HctT.leakT, HmuB.m, HmuB.bad, ROtr.RO.m} /\
        crel TCct.Tab.m{2} TCct.Tab.ks{2} TCct.Tab.bad{2} SD.XOF.m{2} XCB.ps{2} LX.RO.m{2}
             HctT.bad{1} ==>
        HctT.bad{1} => TCct.Tab.bad{2}).
- proc; call HctT_HB_get; wp; call SIB_B.
  call (: ={HmuB.m, HmuB.bad}); 1: by sim.
  by call (: ={ROtr.RO.m}); 1: sim; auto.
call (: ={glob XASim, SD.XOF.m, LX.RO.m, HctT.tinv, HctT.leakT, ROtr.RO.m, HmuB.m, HmuB.bad,
          O_CMA1.sk, O_CMA1.qs} /\
        crel TCct.Tab.m{2} TCct.Tab.ks{2} TCct.Tab.bad{2} SD.XOF.m{2} XCB.ps{2} LX.RO.m{2}
             HctT.bad{1}).
- by proc; inline{2} 2; wp; call Sign_B; auto.
- by proc *; inline{2} 1; wp; call HctT_HB_get; auto.
- by proc *; inline{2} 1; wp; call (: ={HmuB.m, HmuB.bad}); [sim | auto].
- by proc *; inline{2} 1; wp; call (: ={ROtr.RO.m}); [sim | auto].
- by proc *; inline{2} 1; wp; call XC_B; auto.
- by proc *; inline{2} 1; wp; call (: ={glob XASim}); [sim | auto].
inline *; auto => /> *.
have h : ct_tab empty<:high list * mu_t, ctilde> empty<:SD.xin, SD.xout>.
- by move=> x; rewrite !emptyE.
by rewrite h /=; smt(mem_empty).
qed.

(* Query counting for [Act]: every [c~] queried to [XC] is put once *)
local lemma XCB_h (T <: TCct.Oracle{-TCct.Count, -Act}) (S : ctilde fset) :
  hoare[XCB(TCct.Count(T)).get :
        TCct.Count.cp = card XCB.ps /\ XCB.ps \subset S /\ y.`1 \in S ==>
        TCct.Count.cp = card XCB.ps /\ XCB.ps \subset S].
proof.
proc; call (: true) => //.
if; 2: by auto.
inline TCct.Count(T).put; wp; call (: true); auto => /> &hr hs hy hn.
rewrite fcardU1 hn /b2i /=; split; 1: smt().
by move=> z; rewrite in_fsetU in_fset1 => -[/hs | ->].
qed.

local lemma SIB_XCB_h (T <: TCct.Oracle{-TCct.Count, -Act}) (S : ctilde fset) x0 :
  hoare[SIB.SampleInBall(XCB(TCct.Count(T))).get :
        x = x0 /\ TCct.Count.cp = card XCB.ps /\ XCB.ps \subset S ==>
        TCct.Count.cp = card XCB.ps /\ XCB.ps \subset S `|` fset1 x0].
proof.
proc.
while (x = x0 /\ TCct.Count.cp = card XCB.ps /\ XCB.ps \subset S `|` fset1 x0).
- wp; while (x = x0 /\ TCct.Count.cp = card XCB.ps /\ XCB.ps \subset S `|` fset1 x0).
  + by wp; call (XCB_h T (S `|` fset1 x0)); auto => />; rewrite in_fsetU in_fset1.
  by auto.
wp; while (x = x0 /\ TCct.Count.cp = card XCB.ps /\ XCB.ps \subset S `|` fset1 x0).
- by wp; call (XCB_h T (S `|` fset1 x0)); auto => />; rewrite in_fsetU in_fset1.
by auto => /> &hr hs z /hs hz; rewrite in_fsetU hz.
qed.

local lemma Sign_TB_h (T <: TCct.Oracle{-TCct.Count, -Act}) c :
  hoare[MLDSAGen(MatRA, ChalB(TCct.Count(T)), HmuB).sign :
        TCct.Count.cg = c ==> TCct.Count.cg <= c + kappa_max].
proof.
proc.
seq 9 : (TCct.Count.cg = c /\ ctr = 0).
- wp; call (: true) => //; wp.
  by call (: true); [conseq (: _ ==> true) | auto].
while (0 <= ctr <= kappa_max /\ TCct.Count.cg <= c + ctr).
- wp; if; 2: by auto => /> /#.
  inline ChalB(TCct.Count(T)).get HB(TCct.Count(T)).sample TCct.Count(T).get; wp.
  call (: true) => //; wp; call (: true) => //; auto => /> /#.
by auto => />; smt(gt0_kappa_max).
qed.

local lemma Act_bound (T <: TCct.Oracle{-TCct.Count, -Act}) :
  hoare[ Act(TCct.Count(T)).main :
         TCct.Count.cg = 0 /\ TCct.Count.cp = 0 ==>
         TCct.Count.cg <= qHct + kappa_max * qS + 1 /\ TCct.Count.cp <= qXC + 1 ].
proof.
proc.
seq 20 : (TCct.Count.cg <= qHct + kappa_max * qS /\ TCct.Count.cp = card XCB.ps /\
          XCB.ps \subset CountXC.xs /\ card CountXC.xs <= qXC).
- seq 19 : (TCct.Count.cp = 0 /\ TCct.Count.cg = 0 /\ XCB.ps = fset0 /\ CountXC.xs = fset0 /\
            CountXA.q = 0 /\ CountXC.q = 0 /\ CountHtr.q = 0 /\ CountHmu.q = 0 /\
            CountHct.q = 0 /\ CountS.q = 0).
  + by inline *; auto.
  conseq (: _ ==> TCct.Count.cg <= CountHct.q + kappa_max * CountS.q /\
                  TCct.Count.cp = card XCB.ps /\ XCB.ps \subset CountXC.xs /\
                  CountXC.q = card CountXC.xs)
         (: CountXA.q = 0 /\ CountXC.q = 0 /\ CountHtr.q = 0 /\ CountHmu.q = 0 /\
            CountHct.q = 0 /\ CountS.q = 0 ==>
            CountXC.q <= qXC /\ CountHct.q <= qHct /\ CountS.q <= qS) => //.
  + move=> &hr _ ps qhct qs qxc xs cg cp [#] hcg hcp hps hq hqxc hqhct hqs.
    have : kappa_max * qs <= kappa_max * qS.
    * by apply StdOrder.IntOrder.ler_wpmul2l; [smt(gt0_kappa_max) | done].
    smt().
  + by call (A_bound XASim (XCB(TCct.Count(T))) ROtr.RO HmuB (HB(TCct.Count(T)))
                     (O_CMA1(MLDSAGen(MatRA, ChalB(TCct.Count(T)), HmuB)))); auto.
  call (: TCct.Count.cg <= CountHct.q + kappa_max * CountS.q /\
          TCct.Count.cp = card XCB.ps /\ XCB.ps \subset CountXC.xs /\
          CountXC.q = card CountXC.xs).
  + proc; inline O_CMA1(MLDSAGen(MatRA, ChalB(TCct.Count(T)), HmuB)).sign; wp.
    exlim TCct.Count.cg => c.
    by call (Sign_TB_h T c); auto => /> /#.
  + proc; inline HB(TCct.Count(T)).get HB(TCct.Count(T)).sample TCct.Count(T).get.
    by wp; call (: true) => //; auto => /> /#.
  + by proc; call (: true) => //; auto.
  + by proc; call (: true) => //; auto.
  + proc; exlim CountXC.xs => S0.
    seq 1 : (TCct.Count.cg <= CountHct.q + kappa_max * CountS.q /\
             TCct.Count.cp = card XCB.ps /\ XCB.ps \subset CountXC.xs /\
             CountXC.q = card CountXC.xs /\ y.`1 \in CountXC.xs).
    * if; auto => />.
      move=> &hr hcg hs hn; rewrite fcardU1 hn /b2i /= in_fsetU in_fset1 /=.
      by split; [move=> z /hs; rewrite in_fsetU => -> | ring].
    exlim CountXC.xs => S1.
    by call (XCB_h T S1); auto => /> &hr hcg hs hq hy cp ps hcp hps.
  + by proc; call (: true) => //; auto.
  by auto => />; rewrite fcards0.
inline Act(TCct.Count(T)).S.verify HB(TCct.Count(T)).get HB(TCct.Count(T)).sample
       TCct.Count(T).get.
wp; call (: true) => //; wp.
exlim sig.`1, CountXC.xs => ct0 S0.
call (SIB_XCB_h T S0 ct0).
call (: true) => //; call (: true) => //; auto => /> &hr hcg hs hq ps hps.
split; 1: smt().
have := subset_leq_fcard _ _ hps; rewrite fcardU fcard1.
have := fcard_ge0 (S0 `&` fset1 sig{hr}.`1).
smt().
qed.

local lemma ct_bound &m :
  Pr[G2(A).main() @ &m : HctT.bad] <= bound_ct.
proof.
apply (ler_trans _ _ _ (G2_Act &m)).
have := TCct.table_collision Act (qXC + 1) (qHct + kappa_max * qS + 1) _ _ Act_bound &m.
- smt(qXC_ge0).
- have : 0 <= kappa_max * qS by apply StdOrder.IntOrder.mulr_ge0; smt(gt0_kappa_max qS_ge0).
  smt(qHct_ge0).
have -> : qXC + 1 + (qHct + kappa_max * qS + 1) = qXC + 1 + qHct + kappa_max * qS + 1 by ring.
by rewrite /bound_ct fromintM (RField.mulrC (qXC + 1 + qHct + kappa_max * qS + 1)%r).
qed.

(* ==================================================================== *)
(* G1 -> G2: G1 is G2 up to [HctT.bad]                                  *)
(* ==================================================================== *)

(* [x] is a preimage of [c~] in the commitment hash part of the random
   oracle of SimplifiedScheme *)
local op hm (m : (SD.xin, SD.xout) fmap) x ct = m.[SD.XH x] = Some (SD.OH ct).

(* The stream consumed by SampleInBall: [acc_i] is the index [i] of the
   rejection loop after reading the bytes following the 8 sign bytes; a
   complete stream is one after which SampleInBall stops, and only then. *)
local op step_i (i : int) (b : byte) = if i < to_int b then i else i + 1.
local op acc_i (bs : byte list) = foldl step_i (256 - tau) bs.
local op complete (s : byte list) =
  8 <= size s /\ acc_i (drop 8 s) = 256 /\
  forall n, 8 <= n < size s => acc_i (drop 8 (take n s)) < 256.

(* Relation between the tables of G1 ([mct]: Hct, [xm1]: XOF on [c~]) and
   of G2 ([m2]: random oracle of SimplifiedScheme, [lm]: [LX], [ti]: [tinv],
   [lt]: [leakT]), as long as [HctT.bad] is not set; [pend] is the
   iteration of the signer in progress (its point, its [c~] and the number
   of bytes already read). *)
local op [opaque] rel (mct : (high list * mu_t, ctilde) fmap) (xm1 : (ctilde * int, byte) fmap)
   (m2 : (SD.xin, SD.xout) fmap) (lm : (ctilde * int, byte) fmap)
   (ti : (ctilde, high list * mu_t) fmap) (lt : (ctilde, byte list) fmap)
   (pend : ((high list * mu_t) * ctilde * int) option) =
  (* Hct of G1 is the XH part of the random oracle *)
  (forall x, mct.[x] = omap SD.oh m2.[SD.XH x]) /\
  (forall x o, m2.[SD.XH x] = Some o => o = SD.OH (SD.oh o)) /\
  (forall y o, m2.[SD.XB y] = Some o => o = SD.OB (SD.ob o)) /\
  (* injectivity (no collision) *)
  (forall x1 x2 ct, hm m2 x1 ct => hm m2 x2 ct => x1 = x2) /\
  (forall ct x, ti.[ct] = Some x => hm m2 x ct) /\
  (* the streams consumed by the signer are complete and in the oracle *)
  (forall ct s, lt.[ct] = Some s => complete s /\ exists x, hm m2 x ct /\
       forall i, 0 <= i < size s => m2.[SD.XB (x, i)] = Some (SD.OB (nth witness s i))) /\
  (* the bytes of the oracle are read through [tinv] or by the signer *)
  (forall x i, SD.XB (x, i) \in m2 =>
       (exists ct n, pend = Some (x, ct, n) /\ 0 <= i < n) \/
       exists ct, hm m2 x ct /\ (ct \in ti \/ (ct \in lt /\ 0 <= i < size (oget lt.[ct])))) /\
  (forall x ct, hm m2 x ct => ct \in ti \/ ct \in lt \/ exists n, pend = Some (x, ct, n)) /\
  (* [LX] is only queried on an output beyond the consumed stream *)
  (forall x ct i, hm m2 x ct => (ct, i) \in lm => ct \in lt /\ !(0 <= i < size (oget lt.[ct]))) /\
  (* the XOF of G1 *)
  (forall ct i, ((ct, i) \in lm \/ forall x, !hm m2 x ct) => xm1.[(ct, i)] = lm.[(ct, i)]) /\
  (forall x ct i, hm m2 x ct => (ct, i) \notin lm => xm1.[(ct, i)] = omap SD.ob m2.[SD.XB (x, i)]).

local lemma hm_set m x c x' c' :
  hm m.[SD.XH x <- SD.OH c] x' c' <=> (x' = x /\ c' = c) \/ (x' <> x /\ hm m x' c').
proof. by rewrite /hm get_setE /=; case: (x' = x). qed.

local lemma hm_setB m y o x' c' : hm m.[SD.XB y <- o] x' c' <=> hm m x' c'.
proof. by rewrite /hm get_setE. qed.

local lemma hm_in m x c : hm m x c => SD.XH x \in m.
proof. by rewrite /hm domE => ->. qed.

(* A fresh output [c] of [Hct] (signer or adversary) *)
local lemma rel_sfresh mct xm1 m2 lm ti lt x c :
  SD.XH x \notin m2 => !hrng m2 c => (forall i, (c, i) \notin lm) =>
  rel mct xm1 m2 lm ti lt None =>
  rel mct.[x <- c] xm1 m2.[SD.XH x <- SD.OH c] lm ti lt (Some (x, c, 0)).
proof.
move=> hx hc hl; rewrite /rel => -[#] h1 h2 h3 h4 h5 h6 h7 h8 h9 h10 h11.
have hnc : forall x', !hm m2 x' c by move=> x'; apply/negP => h; apply hc; exists x'.
have hxb : forall i, SD.XB (x, i) \notin m2.
- move=> i; apply/negP => /h7 [[ct n [] //] | [ct [/hm_in hin _]]].
  by move: hx; rewrite hin.
have hold : forall x' c', hm m2 x' c' => x' <> x by move=> x' c' /hm_in; smt().
do ! split.
- by move=> x'; rewrite !get_setE /=; case: (x' = x) => // _; apply h1.
- move=> x' o; rewrite get_setE /=; case: (x' = x) => hx'.
  + by move=> /someI <-.
  by apply h2.
- by move=> y o; rewrite get_setE /=; apply h3.
- by move=> x1 x2 ct; rewrite !hm_set; smt().
- by move=> ct x' /h5 h; rewrite hm_set; right; split => //; apply (hold _ _ h).
- move=> ct s /h6 [hs [x' [hx' hb]]]; split => //; exists x'; split.
  + by rewrite hm_set; right; split => //; apply (hold _ _ hx').
  by move=> i hi; rewrite get_setE /=; apply hb.
- move=> x' i; rewrite mem_set /= => /h7 [[ct n [] //] | [ct [hx' hct]]].
  right; exists ct; rewrite hm_set.
  by split => //; right; split => //; apply (hold _ _ hx').
- move=> x' ct; rewrite hm_set => -[[-> ->] | [_ /h8 [-> // | [-> // | [n []] //]]]].
  by right; right; exists 0.
- move=> x' ct i; rewrite hm_set => -[[_ ->] | [_ hx']]; 1: by rewrite hl.
  by apply (h9 _ _ _ hx').
- move=> ct i hcase; apply h10; case: hcase => [-> // | hn]; right => x'.
  by have := hn x'; rewrite hm_set negb_or => -[_]; smt().
move=> x' ct i; rewrite hm_set => -[[-> ->] hi | [hne hx'] hi].
- by rewrite get_setE /= (get_none _ _ (hxb i)) /= h10 //; right.
by rewrite get_setE /=; apply (h11 _ _ _ hx').
qed.

(* An old output of [Hct] *)
local lemma rel_sold mct xm1 m2 lm ti lt x c :
  hm m2 x c => rel mct xm1 m2 lm ti lt None => rel mct xm1 m2 lm ti lt (Some (x, c, 0)).
proof.
move=> hxc; rewrite /rel => -[#] h1 h2 h3 h4 h5 h6 h7 h8 h9 h10 h11.
do ! split => //.
- by move=> x' i /h7 [[ct n [] //] | h]; right.
by move=> x' ct /h8 [-> // | [-> // | [n []] //]].
qed.

(* The registration of [c] in [tinv] by the adversary's [Hct] *)
local lemma rel_reg mct xm1 m2 lm ti lt x c :
  hm m2 x c => rel mct xm1 m2 lm ti lt (Some (x, c, 0)) =>
  rel mct xm1 m2 lm (if c \notin ti then ti.[c <- x] else ti) lt None.
proof.
move=> hxc; rewrite /rel => -[#] h1 h2 h3 h4 h5 h6 h7 h8 h9 h10 h11.
have hti : forall ct, ct \in ti => ct \in (if c \notin ti then ti.[c <- x] else ti).
- by move=> ct; case: (c \in ti) => //= _; rewrite mem_set => ->.
do ! split => //.
- move=> ct x'; case: (c \in ti) => /= hc; 1: by apply h5.
  by rewrite get_setE; case: (ct = c) => [-> /someI <- // | _ /h5 //].
- move=> x' i /h7 [[ct n [h hi]] | [ct [hx' hc']]]; 1: by move: h => /someI /#.
  by right; exists ct; split => //; case: hc' => [/hti -> // | -> //].
move=> x' ct /h8 [/hti -> // | [-> // | [n /someI [#] -> ->]]].
by move=> _; left; case: (ct \in ti) => //=; rewrite mem_set.
qed.

local lemma hm_fun m x c c' : hm m x c => hm m x c' => c = c'.
proof. by rewrite /hm => -> /someI /(congr1 SD.oh). qed.

(* [XC] rule 1: a query already answered by [LX] *)
local lemma rel_x1 mct xm1 m2 lm ti lt ct i :
  rel mct xm1 m2 lm ti lt None => (ct, i) \in lm => xm1.[(ct, i)] = lm.[(ct, i)].
proof. by rewrite /rel => -[#] _ _ _ _ _ _ _ _ _ h10 _ hin; apply h10; left. qed.

(* [XC] rule 2: a position of a stream consumed by the signer *)
local lemma rel_x2 mct xm1 m2 lm ti lt ct i s :
  rel mct xm1 m2 lm ti lt None => lt.[ct] = Some s => 0 <= i < size s =>
  (ct, i) \notin lm => xm1.[(ct, i)] = Some (nth witness s i).
proof.
rewrite /rel => -[#] _ _ _ _ _ h6 _ _ _ _ h11 hs hi hl.
have [_ [x [hx hb]]] := h6 _ _ hs.
by rewrite (h11 _ _ _ hx hl) (hb _ hi).
qed.

(* [XC] rule 3: an output of [Hct] for the adversary *)
local lemma rel_x3 mct xm1 m2 lm ti lt ct i x :
  rel mct xm1 m2 lm ti lt None => ti.[ct] = Some x => (ct, i) \notin lm =>
  xm1.[(ct, i)] = omap SD.ob m2.[SD.XB (x, i)] /\
  forall b, SD.XB (x, i) \notin m2 =>
    rel mct xm1.[(ct, i) <- b] m2.[SD.XB (x, i) <- SD.OB b] lm ti lt None.
proof.
rewrite /rel => -[#] h1 h2 h3 h4 h5 h6 h7 h8 h9 h10 h11 hti hl.
have hx := h5 _ _ hti.
split; 1: by apply h11.
move=> b hxb; do ! split.
- by move=> x'; rewrite get_setE /=; apply h1.
- by move=> x' o; rewrite get_setE /=; apply h2.
- by move=> y o; rewrite get_setE /=; case: (y = (x, i)) => [_ /someI <- // | _ /h3].
- by move=> x1 x2 c; rewrite !hm_setB; apply h4.
- by move=> c x'; rewrite hm_setB; apply h5.
- move=> c s /h6 [hs [x' [hx' hb']]]; split => //; exists x'; rewrite hm_setB hx' /=.
  move=> k hk; rewrite get_setE; case: (SD.XB (x', k) = SD.XB (x, i)) => heq.
  + by move: hxb; rewrite -heq domE (hb' _ hk).
  by apply hb'.
- move=> x' k; rewrite mem_set => -[/h7 [[c n []] | [c [hc hc']]] | heq] //.
  + by right; exists c; rewrite hm_setB.
  have [->> ->>] : x' = x /\ k = i by move: heq => /=.
  by right; exists ct; rewrite hm_setB hx /= domE hti.
- by move=> x' c; rewrite hm_setB => /h8.
- by move=> x' c k; rewrite hm_setB; apply h9.
- move=> c k hck; rewrite get_setE.
  case: ((c, k) = (ct, i)) => [[->> ->>] | _] /=.
  + case: hck => [hin | /(_ x)]; [by move: hl; rewrite hin | by rewrite hm_setB hx].
  by apply h10; case: hck => [-> // | hn]; right => x'; have := hn x'; rewrite hm_setB.
move=> x' c k; rewrite hm_setB => hc hk; rewrite !get_setE.
case: ((c, k) = (ct, i)) => [[->> ->>] | hne] /=.
- by have -> /= : x' = x by apply (h4 _ _ _ hc hx).
case: (x' = x /\ k = i) => [[->> ->>] | _]; 2: by apply h11.
by have := hm_fun _ _ _ _ hc hx => ->>; move: hne.
qed.

(* [XC] rule 4: a fresh query to [LX] *)
local lemma rel_x4 mct xm1 m2 lm ti lt ct i :
  rel mct xm1 m2 lm ti lt None => (ct, i) \notin lm =>
  !(ct \in lt /\ 0 <= i < size (oget lt.[ct])) => ct \notin ti =>
  xm1.[(ct, i)] = None /\
  forall b, rel mct xm1.[(ct, i) <- b] m2 lm.[(ct, i) <- b] ti lt None.
proof.
rewrite /rel => -[#] h1 h2 h3 h4 h5 h6 h7 h8 h9 h10 h11 hl hlt hti.
have hpre : forall x, hm m2 x ct => ct \in lt.
- by move=> x /h8 [// | [// | [n []] //]].
split.
- case: (exists x, hm m2 x ct) => [[x hx] | hn].
  + rewrite (h11 _ _ _ hx hl); case _ : (m2.[SD.XB (x, i)]) => // o ho.
    have : SD.XB (x, i) \in m2 by rewrite domE ho.
    move=> /h7 [[c n []] | [c [hc [hc' | hc']]]] //.
    * by have := hm_fun _ _ _ _ hx hc => ->>; move: hti; rewrite hc'.
    by have := hm_fun _ _ _ _ hx hc => ->>; move: hlt; rewrite hc'.
  rewrite h10; 1: by right => x; apply/negP => hx; apply hn; exists x.
  by apply get_none.
move=> b; do ! split => //.
- move=> x c k hc; rewrite mem_set => -[/(h9 _ _ _ hc) // | [->> ->>]].
  by have := hpre _ hc => hin; move: hlt; rewrite hin.
- move=> c k; rewrite mem_set !get_setE.
  by case: ((c, k) = (ct, i)) => //= _ hck; apply h10.
move=> x c k hc; rewrite mem_set negb_or => -[hk hne]; rewrite get_setE hne /=.
by apply h11.
qed.

(* A byte read by the signer at position [n] of the iteration in progress *)
local lemma rel_read mct xm1 m2 lm ti lt x c n :
  rel mct xm1 m2 lm ti lt (Some (x, c, n)) => hm m2 x c => (c, n) \notin lm => 0 <= n =>
  xm1.[(c, n)] = omap SD.ob m2.[SD.XB (x, n)] /\
  (SD.XB (x, n) \in m2 => rel mct xm1 m2 lm ti lt (Some (x, c, n + 1))) /\
  (forall b, SD.XB (x, n) \notin m2 =>
     rel mct xm1.[(c, n) <- b] m2.[SD.XB (x, n) <- SD.OB b] lm ti lt (Some (x, c, n + 1))).
proof.
rewrite /rel => -[#] h1 h2 h3 h4 h5 h6 h7 h8 h9 h10 h11 hx hl hn.
split; 1: by apply h11.
split.
- move=> _; do ! split => //.
  + move=> x' k /h7 [[c' n' [/someI [#] <<- <<- <<- hk]] | h]; 2: by right.
    by left; exists c (n + 1) => /#.
  by move=> x' c' /h8 [-> // | [-> // | [n' /someI [#] <<- <<- _]]]; right; right; exists (n + 1).
move=> b hxb; do ! split.
- by move=> x'; rewrite get_setE /=; apply h1.
- by move=> x' o; rewrite get_setE /=; apply h2.
- by move=> y o; rewrite get_setE /=; case: (y = (x, n)) => [_ /someI <- // | _ /h3].
- by move=> x1 x2 c'; rewrite !hm_setB; apply h4.
- by move=> c' x'; rewrite hm_setB; apply h5.
- move=> c' s /h6 [hs [x' [hx' hb']]]; split => //; exists x'; rewrite hm_setB hx' /=.
  move=> k hk; rewrite get_setE; case: (SD.XB (x', k) = SD.XB (x, n)) => heq.
  + by move: hxb; rewrite -heq domE (hb' _ hk).
  by apply hb'.
- move=> x' k; rewrite mem_set => -[/h7 [[c' n' [/someI [#] <<- <<- <<- hk]] | [c' [hc hc']]] | heq].
  + by left; exists c (n + 1) => /#.
  + by right; exists c'; rewrite hm_setB.
  have [->> ->>] : x' = x /\ k = n by move: heq => /=.
  by left; exists c (n + 1) => /#.
- move=> x' c'; rewrite hm_setB => /h8 [-> // | [-> // | [n' /someI [#] <<- <<- _]]].
  by right; right; exists (n + 1).
- by move=> x' c' k; rewrite hm_setB; apply h9.
- move=> c' k hck; rewrite get_setE.
  case: ((c', k) = (c, n)) => [[->> ->>] | _] /=.
  + case: hck => [hin | /(_ x)]; [by move: hl; rewrite hin | by rewrite hm_setB hx].
  by apply h10; case: hck => [-> // | hn']; right => x'; have := hn' x'; rewrite hm_setB.
move=> x' c' k; rewrite hm_setB => hc hk; rewrite !get_setE.
case: ((c', k) = (c, n)) => [[->> ->>] | hne] /=.
- by have -> /= : x' = x by apply (h4 _ _ _ hc hx).
case: (x' = x /\ k = n) => [[->> ->>] | _]; 2: by apply h11.
by have := hm_fun _ _ _ _ hc hx => ->>; move: hne.
qed.

(* The end of the iteration in progress of the signer: its consumed stream
   is recorded *)
local lemma rel_end mct xm1 m2 lm ti lt x c rd :
  rel mct xm1 m2 lm ti lt (Some (x, c, size rd)) => hm m2 x c => complete rd =>
  (forall i, 0 <= i < size rd => m2.[SD.XB (x, i)] = Some (SD.OB (nth witness rd i))) =>
  (c \in lt => oget lt.[c] = rd) =>
  rel mct xm1 m2 lm ti lt.[c <- rd] None.
proof.
rewrite /rel => -[#] h1 h2 h3 h4 h5 h6 h7 h8 h9 h10 h11 hx hc hb hlt.
have hold : forall c', c' \in lt => oget lt.[c'] = oget lt.[c <- rd].[c'].
- by move=> c' hc'; rewrite get_setE; case: (c' = c) => [->> | //]; rewrite hlt.
do ! split => //.
- move=> c' s; rewrite get_setE; case: (c' = c) => [->> /someI <- | _ /h6 //].
  by split => //; exists x.
- move=> x' k /h7 [[c' n [/someI [#] <<- <<- <<- hk]] | [c' [hc' [hti | [hl hk]]]]].
  + by right; exists c; rewrite hx /= mem_set get_set_sameE /=; right.
  + by right; exists c'; rewrite hc' /= mem_set hti.
  by right; exists c'; rewrite hc' /= mem_set hl /=; right; rewrite -hold.
- move=> x' c' /h8 [-> // | [hl | [n /someI [#] _ <<- _]]].
  + by right; left; rewrite mem_set hl.
  by right; left; rewrite mem_set.
move=> x' c' k hc' hk; have [hl hr] := h9 _ _ _ hc' hk.
by rewrite mem_set hl /= -hold.
qed.

(* Facts on the iteration in progress *)
local lemma rel_pend_lx mct xm1 m2 lm ti lt x c n i :
  rel mct xm1 m2 lm ti lt (Some (x, c, n)) => hm m2 x c => (c, i) \in lm =>
  c \in lt /\ !(0 <= i < size (oget lt.[c])).
proof. by rewrite /rel => -[#] _ _ _ _ _ _ _ _ h9 _ _ hx; apply (h9 x). qed.

local lemma rel_pend_lt mct xm1 m2 lm ti lt x c n s :
  rel mct xm1 m2 lm ti lt (Some (x, c, n)) => hm m2 x c => lt.[c] = Some s =>
  complete s /\ forall i, 0 <= i < size s => m2.[SD.XB (x, i)] = Some (SD.OB (nth witness s i)).
proof.
rewrite /rel => -[#] _ _ _ h4 _ h6 _ _ _ _ _ hx hs.
have [hc [x' [hx' hb]]] := h6 _ _ hs.
by have <<- := h4 _ _ _ hx hx'.
qed.

local lemma rel_xbshape mct xm1 m2 lm ti lt p y o :
  rel mct xm1 m2 lm ti lt p => m2.[SD.XB y] = Some o => o = SD.OB (SD.ob o).
proof. by rewrite /rel => -[#] _ _ h3 *; apply (h3 y). qed.

local lemma rel_h1 mct xm1 m2 lm ti lt p x :
  rel mct xm1 m2 lm ti lt p => mct.[x] = omap SD.oh m2.[SD.XH x].
proof. by rewrite /rel => -[#] h1 *; apply h1. qed.

local lemma rel_hm mct xm1 m2 lm ti lt p x o :
  rel mct xm1 m2 lm ti lt p => m2.[SD.XH x] = Some o => hm m2 x (SD.oh o).
proof. by rewrite /rel /hm => -[#] _ h2 _ _ _ _ _ _ _ _ _ ho; rewrite ho -(h2 _ _ ho). qed.

(* The relation between the state of G1 and the one of G2 (an
   abbreviation: the tactics see the conjunction) *)
local abbrev relD (mmu1 : (tr_t * M, mu_t) fmap) (mct : (high list * mu_t, ctilde) fmap)
  (xm1 : (ctilde * int, byte) fmap) (mmu2 : (tr_t * M, mu_t) fmap) (bad : bool)
  (m2 : (SD.xin, SD.xout) fmap) (lm : (ctilde * int, byte) fmap)
  (ti : (ctilde, high list * mu_t) fmap) (lt : (ctilde, byte list) fmap) =
  mmu1 = mmu2 /\ !bad /\ rel mct xm1 m2 lm ti lt None.

(* A query to [Hct] of the signer: G1 samples [c~] in its table, G2 in the
   random oracle of SimplifiedScheme *)
local lemma E_sample x0 :
  equiv[ROct.RO.get ~ HctT.sample :
        ={x} /\ x{2} = x0 /\ !HctT.bad{2} /\
        rel ROct.RO.m{1} SIB.XOF.RO.m{1} SD.XOF.m{2} LX.RO.m{2} HctT.tinv{2} HctT.leakT{2} None ==>
        !HctT.bad{2} =>
        ={res} /\ hm SD.XOF.m{2} x0 res{2} /\
        rel ROct.RO.m{1} SIB.XOF.RO.m{1} SD.XOF.m{2} LX.RO.m{2} HctT.tinv{2} HctT.leakT{2}
            (Some (x0, res{2}, 0))].
proof.
proc; inline *; sp.
case (SD.XH x{2} \in SD.XOF.m{2}).
- rcondf{2} 2; 1: by auto.
  rcondf{2} 3; 1: by auto.
  rcondf{1} 2.
  + move=> &2; auto => /> &1 hb hr hin r _.
    by rewrite domE (rel_h1 _ _ _ _ _ _ _ _ hr); move: hin; rewrite domE; case: (SD.DSSXOF.PRO.RO.m{2}.[SD.XH x{2}]).
  wp; rnd{2}; rnd{1}; skip => /> &1 &2 hb hr hin _ _.
  rewrite dmap_ll ?dct_ll //= => _ _.
  have [o' ho'] : exists o', SD.XOF.m{2}.[SD.XH x0] = Some o'.
  + by move: hin; rewrite domE; case: (SD.XOF.m{2}.[SD.XH x0]) => // o' _; exists o'.
  rewrite (rel_h1 _ _ _ _ _ _ _ _ hr) ho' /=.
  have hm' := rel_hm _ _ _ _ _ _ _ _ _ hr ho'.
  by rewrite hm' /=; apply rel_sold.
rcondt{2} 2; 1: by auto.
rcondt{2} 4; 1: by auto.
rcondt{1} 2.
- move=> &2; auto => /> &1 hb hr hin r _.
  by rewrite domE (rel_h1 _ _ _ _ _ _ _ _ hr); move: hin; rewrite domE; case: (SD.DSSXOF.PRO.RO.m{2}.[SD.XH x{2}]).
wp; rnd SD.OH SD.oh; auto => /> &1 &2 hb hr hin.
split => [o ho | _]; 1: by apply supp_dOH.
split => [o ho | _]; 1: by rewrite (supp_dOH _ ho) mu1_dOH.
move=> c hc0; rewrite supp_dmap; split => [| _]; 1: by exists c.
rewrite !get_set_sameE /= negb_or => -[hc hl].
split; 1: by rewrite /hm get_set_sameE.
by apply rel_sfresh => // i; apply/negP => hi; apply hl; exists i.
qed.

(* A query to [Hct] of the adversary *)
local lemma E_Hct :
  equiv[ROct.RO.get ~ HctT.get :
        ={x} /\ !HctT.bad{2} /\
        rel ROct.RO.m{1} SIB.XOF.RO.m{1} SD.XOF.m{2} LX.RO.m{2} HctT.tinv{2} HctT.leakT{2} None ==>
        !HctT.bad{2} => ={res} /\
        rel ROct.RO.m{1} SIB.XOF.RO.m{1} SD.XOF.m{2} LX.RO.m{2} HctT.tinv{2} HctT.leakT{2} None].
proof.
proc *; inline{2} HctT.get; wp; sp.
exlim x0{2} => x1; call (E_sample x1); auto => /> &1 &2 hb hr r b mct bad m hrel.
split => hn hb'; have [-> [hm' hr']] := hrel hb'; split => //;
  have := rel_reg _ _ _ _ _ _ _ _ hm' hr'; by rewrite /= hn.
qed.

(* A query to the challenge XOF *)
local lemma E_XC :
  equiv[SIB.XOF.RO.get ~ XCSim(SD.XOF).get :
        ={arg} /\ !HctT.bad{2} /\
        rel ROct.RO.m{1} SIB.XOF.RO.m{1} SD.XOF.m{2} LX.RO.m{2} HctT.tinv{2} HctT.leakT{2} None ==>
        ={res} /\ !HctT.bad{2} /\
        rel ROct.RO.m{1} SIB.XOF.RO.m{1} SD.XOF.m{2} LX.RO.m{2} HctT.tinv{2} HctT.leakT{2} None].
proof.
proc; inline *; sp.
if{2}.
- rcondf{2} 3; 1: by auto.
  rcondf{1} 2.
  + move=> &2; auto => /> &1 hb hr hin r _.
    have := rel_x1 _ _ _ _ _ _ y{2}.`1 y{2}.`2 hr; rewrite -pairS => /(_ hin) h.
    by rewrite domE h; move: hin; rewrite domE.
  auto => /> &1 &2 hb hr hin r _.
  by have := rel_x1 _ _ _ _ _ _ y{2}.`1 y{2}.`2 hr; rewrite -pairS => /(_ hin) ->.
if{2}.
- rcondf{1} 2.
  + move=> &2; auto => /> &1 hb hr hnin hlt hi1 hi2 r _.
    have [s hs] : exists s, HctT.leakT{2}.[y{2}.`1] = Some s.
    * by move: hlt; rewrite domE; case: (HctT.leakT{2}.[y{2}.`1]) => // s _; exists s.
    have hi : 0 <= y{2}.`2 < size s by move: hi2; rewrite hs /#.
    have := rel_x2 _ _ _ _ _ _ y{2}.`1 y{2}.`2 s hr hs hi; rewrite -pairS => /(_ hnin) h.
    by rewrite domE h.
  wp; rnd{1}; skip => /> &1 &2 hb hr hnin hlt hi1 hi2; split => [|_ r _]; 1: exact dB_ll.
  have [s hs] : exists s, HctT.leakT{2}.[y{2}.`1] = Some s.
  + by move: hlt; rewrite domE; case: (HctT.leakT{2}.[y{2}.`1]) => // s _; exists s.
  have hi : 0 <= y{2}.`2 < size s by move: hi2; rewrite hs /#.
  have := rel_x2 _ _ _ _ _ _ y{2}.`1 y{2}.`2 s hr hs hi; rewrite -pairS => /(_ hnin) h.
  by rewrite h hs.
if{2}.
- wp; rnd SD.OB SD.ob; auto => /> &1 &2 hb hr hnin hlt hti.
  have [x hx] : exists x, HctT.tinv{2}.[y{2}.`1] = Some x.
  + by move: hti; rewrite domE; case: (HctT.tinv{2}.[y{2}.`1]) => // x _; exists x.
  have := rel_x3 _ _ _ _ _ _ y{2}.`1 y{2}.`2 x hr hx; rewrite -pairS => /(_ hnin) [hv hset].
  rewrite hx /=.
  split => [o ho | _]; 1: by apply supp_dOB.
  split => [o ho | _]; 1: by rewrite (supp_dOB _ ho) mu1_dOB.
  move=> b hb0; rewrite supp_dmap; split => [| _]; 1: by exists b.
  rewrite !domE hv.
  case _ : (SD.XOF.m{2}.[SD.XB (x, y{2}.`2)]) => [hn | o ho] //=.
  by rewrite !get_set_sameE /=; apply hset; rewrite domE hn.
rcondt{1} 2.
- move=> &2; auto => /> &1 hb hr hnin hlt hti r _.
  have := rel_x4 _ _ _ _ _ _ y{2}.`1 y{2}.`2 hr; rewrite -pairS => /(_ hnin hlt hti) [hv _].
  by rewrite domE hv.
rcondt{2} 3; 1: by auto.
auto => /> &1 &2 hb hr hnin hlt hti r _.
have := rel_x4 _ _ _ _ _ _ y{2}.`1 y{2}.`2 hr; rewrite -pairS => /(_ hnin hlt hti) [hv hset].
by rewrite !get_set_sameE /=; apply hset.
qed.

(* The stream read so far by SampleInBall *)
local op rdof (signs : byte list) (leak : (int * int) list) : byte list =
  signs ++ map (fun (p : int * int) => from_int p.`2) leak.

local lemma lts_eq signs leak :
  SD.SIB.leak_to_stream (lcat (SD.SIB.bytes_leak signs) (pairs_to_leakage leak)) = rdof signs leak.
proof.
rewrite /SD.SIB.leak_to_stream /SD.SIB.bytes_leak /pairs_to_leakage /rdof /=; congr.
- by rewrite -map_comp -{2}(map_id signs); apply eq_map => b; rewrite /(\o) /= tK.
by rewrite -map_comp; apply eq_map.
qed.

local lemma rdof_s signs b : rdof (rcons signs b) [] = rcons (rdof signs []) b.
proof. by rewrite /rdof /= !cats0. qed.

local lemma rdof_l signs leak c b :
  rdof signs (rcons leak (c, to_int b)) = rcons (rdof signs leak) b.
proof. by rewrite /rdof map_rcons /= tK rcons_cat. qed.

local lemma acc_rcons bs b : acc_i (rcons bs b) = step_i (acc_i bs) b.
proof. by rewrite /acc_i foldl_rcons. qed.

(* Invariant of SampleInBall in the signer: [rd] is the stream read so far,
   on the point [x0] of [c~ = c0] *)
local op [opaque] sbinv mct xm1 m2 lm ti (lt : (ctilde, byte list) fmap) x0 c0 (rd : byte list) =
  hm m2 x0 c0 /\ rel mct xm1 m2 lm ti lt (Some (x0, c0, size rd)) /\
  (forall q, 0 <= q < size rd => m2.[SD.XB (x0, q)] = Some (SD.OB (nth witness rd q))) /\
  (forall n, 8 <= n < size rd => acc_i (drop 8 (take n rd)) < 256) /\
  (c0 \in lt => size rd <= size (oget lt.[c0]) /\ rd = take (size rd) (oget lt.[c0])).

local lemma sb_lt8 mct xm1 m2 lm ti lt x0 c0 rd :
  sbinv mct xm1 m2 lm ti lt x0 c0 rd => size rd < 8 =>
  c0 \in lt => size rd < size (oget lt.[c0]).
proof.
rewrite /sbinv => -[#] hx hr _ _ _ h8 /domE hc; move: hc; case _ : (lt.[c0]) => // s hs _ /=.
by have [[hs8 _] _] := rel_pend_lt _ _ _ _ _ _ _ _ _ _ hr hx hs; smt().
qed.

local lemma sb_ltacc mct xm1 m2 lm ti lt x0 c0 rd :
  sbinv mct xm1 m2 lm ti lt x0 c0 rd => 8 <= size rd => acc_i (drop 8 rd) < 256 =>
  c0 \in lt => size rd < size (oget lt.[c0]).
proof.
rewrite /sbinv => -[#] hx hr _ _ hlt h8 hacc hc; have [hle heq] := hlt hc.
move: hc => /domE; case _ : (lt.[c0]) => // s hs _ /=.
have [[_ [hs256 _]] _] := rel_pend_lt _ _ _ _ _ _ _ _ _ _ hr hx hs.
move: hle heq; rewrite hs /= => hle heq.
case: (size rd = size s) => [heqs | /#].
by move: hacc; rewrite heq heqs take_size hs256.
qed.

local lemma sb_pre mct xm1 m2 lm ti lt x0 c0 rd :
  sbinv mct xm1 m2 lm ti lt x0 c0 rd => (c0 \in lt => size rd < size (oget lt.[c0])) =>
  (c0, size rd) \notin lm /\
  (c0 \in lt => m2.[SD.XB (x0, size rd)] = Some (SD.OB (nth witness (oget lt.[c0]) (size rd)))).
proof.
rewrite /sbinv => -[#] hx hr _ _ hlt hsz; split.
- apply/negP => hin; have [hc hn] := rel_pend_lx _ _ _ _ _ _ _ _ _ _ hr hx hin.
  by apply hn; rewrite size_ge0 /= hsz.
move=> hc; move: (hc) => /domE; case _ : (lt.[c0]) => // s hs _ /=.
have [_ hb] := rel_pend_lt _ _ _ _ _ _ _ _ _ _ hr hx hs.
by apply hb; rewrite size_ge0 /=; move: (hsz hc); rewrite hs.
qed.

local lemma sb_step mct xm1 m2 m2' xm1' lm ti lt x0 c0 rd b :
  sbinv mct xm1 m2 lm ti lt x0 c0 rd =>
  rel mct xm1' m2' lm ti lt (Some (x0, c0, size rd + 1)) => hm m2' x0 c0 =>
  m2'.[SD.XB (x0, size rd)] = Some (SD.OB b) =>
  (forall q, q <> size rd => m2'.[SD.XB (x0, q)] = m2.[SD.XB (x0, q)]) =>
  (c0 \in lt => size rd < size (oget lt.[c0])) =>
  (c0 \in lt => b = nth witness (oget lt.[c0]) (size rd)) =>
  (8 <= size rd => acc_i (drop 8 rd) < 256) =>
  sbinv mct xm1' m2' lm ti lt x0 c0 (rcons rd b).
proof.
rewrite /sbinv => -[#] hx hr hb hpre hlt hr' hx' hn hq hsz hbs hacc; rewrite /sbinv size_rcons.
do ! split => //.
- move=> q hq'; rewrite nth_rcons; case: (q < size rd) => hlt'.
  + by rewrite hq 1:/#; apply hb => /#.
  by have -> : q = size rd by smt().
- move=> n hn'; case: (n < size rd) => hlt'.
  + by rewrite -cats1 take_cat hlt' /=; apply hpre => /#.
  have -> : n = size rd by smt().
  by rewrite -cats1 take_cat /= ?take0 ?cats0; apply hacc => /#.
move=> hc; have [hle heq] := hlt hc; split; 1: smt().
rewrite (take_nth witness); 1: by rewrite size_ge0 /= hsz.
by rewrite -heq hbs.
qed.

local lemma sb_end mct xm1 m2 lm ti lt x0 c0 rd :
  sbinv mct xm1 m2 lm ti lt x0 c0 rd => 8 <= size rd => acc_i (drop 8 rd) = 256 =>
  complete rd /\ (c0 \in lt => oget lt.[c0] = rd).
proof.
rewrite /sbinv => -[#] hx hr hb hpre hlt h8 hacc; split; 1: by rewrite /complete h8 hacc.
move=> hc; have [hle heq] := hlt hc.
move: (hc) => /domE; case _ : (lt.[c0]) => // s hs _.
have [[_ [_ hp]] _] := rel_pend_lt _ _ _ _ _ _ _ _ _ _ hr hx hs.
move: hle heq; rewrite hs /= => hle heq.
case: (size rd = size s) => [heqs | hne]; 1: by rewrite heq heqs take_size.
by have := hp (size rd) _; [smt() | rewrite -heq hacc].
qed.

(* A byte read by the signer *)
local lemma E_read x0 c0 rd :
  equiv[SIB.XOF.RO.get ~ SD.XofOf(SD.XOF).get :
        x{1} = (c0, size rd) /\ y{2} = (x0, size rd) /\
        sbinv ROct.RO.m{1} SIB.XOF.RO.m{1} SD.XOF.m{2} LX.RO.m{2} HctT.tinv{2} HctT.leakT{2}
              x0 c0 rd /\
        (c0 \in HctT.leakT{2} => size rd < size (oget HctT.leakT{2}.[c0])) /\
        (8 <= size rd => acc_i (drop 8 rd) < 256) ==>
        ={res} /\
        sbinv ROct.RO.m{1} SIB.XOF.RO.m{1} SD.XOF.m{2} LX.RO.m{2} HctT.tinv{2} HctT.leakT{2}
              x0 c0 (rcons rd res{2})].
proof.
proc; inline *; wp.
sp; rnd SD.OB SD.ob; skip => /> &1 &2 hinv hsz hacc.
have [hl hlt] := sb_pre _ _ _ _ _ _ _ _ _ hinv hsz.
have := hinv; rewrite {1}/sbinv => -[#] hx hr _ _ _.
have [hv [hold hnew]] := rel_read _ _ _ _ _ _ _ _ _ hr hx hl (List.size_ge0 rd).
split => [o ho | _]; 1: by apply supp_dOB.
split => [o ho | _]; 1: by rewrite (supp_dOB _ ho) mu1_dOB.
move=> b hb0; rewrite supp_dmap; split => [| _]; 1: by exists b.
split => hin; rewrite !domE hv.
- rewrite (get_none _ _ hin) /= !get_set_sameE /=.
  apply (sb_step _ _ _ _ _ _ _ _ _ _ _ _ hinv (hnew _ hin)) => //.
  + by rewrite hm_setB.
  + by rewrite get_set_sameE.
  + by move=> q hq; rewrite get_setE /= hq.
  by move=> hc; move: (hlt hc); rewrite (get_none _ _ hin).
have [v hv'] : exists v, SD.XOF.m{2}.[SD.XB (x0, size rd)] = Some v.
- by move: hin; rewrite domE; case: (SD.XOF.m{2}.[_]) => // v _; exists v.
rewrite hv' /=.
have hvs := rel_xbshape _ _ _ _ _ _ _ _ _ hr hv'.
apply (sb_step _ _ _ _ _ _ _ _ _ _ _ _ hinv (hold hin) hx) => //.
- by rewrite hv' {1}hvs.
by move=> hc; have := hlt hc; rewrite hv' => /someI ->.
qed.

local lemma drop8_rcons (rd : byte list) b :
  8 <= size rd => drop 8 (rcons rd b) = rcons (drop 8 rd) b.
proof. by move=> h; rewrite -!cats1 drop_cat_le h. qed.

(* SampleInBall in the signer: on [c~ = c0] in G1, on its preimage [x0] in
   G2, in lockstep; the stream read is complete *)
local lemma SB_eq x0 c0 :
  equiv[SIB.SampleInBall(SIB.XOF.RO).get ~ SD.SIB.SampleInBall(SD.XofOf(SD.XOF)).get :
        x{1} = c0 /\ x{2} = x0 /\
        sbinv ROct.RO.m{1} SIB.XOF.RO.m{1} SD.XOF.m{2} LX.RO.m{2} HctT.tinv{2} HctT.leakT{2}
              x0 c0 [] ==>
        ={res} /\
        sbinv ROct.RO.m{1} SIB.XOF.RO.m{1} SD.XOF.m{2} LX.RO.m{2} HctT.tinv{2} HctT.leakT{2}
              x0 c0 (SD.SIB.leak_to_stream res{2}.`2) /\
        8 <= size (SD.SIB.leak_to_stream res{2}.`2) /\
        acc_i (drop 8 (SD.SIB.leak_to_stream res{2}.`2)) = 256].
proof.
proc.
while (={i, ctx, signs, challenge, leak, byte} /\ x{1} = c0 /\ x{2} = x0 /\
       sbinv ROct.RO.m{1} SIB.XOF.RO.m{1} SD.XOF.m{2} LX.RO.m{2} HctT.tinv{2} HctT.leakT{2}
             x0 c0 (rdof signs{2} leak{2}) /\
       ctx{2} = size (rdof signs{2} leak{2}) /\ 8 <= ctx{2} /\ i{2} <= 256 /\
       acc_i (drop 8 (rdof signs{2} leak{2})) = i{2}).
- wp.
  while (={i, j, ctx, signs, challenge, leak, byte} /\ x{1} = c0 /\ x{2} = x0 /\
         sbinv ROct.RO.m{1} SIB.XOF.RO.m{1} SD.XOF.m{2} LX.RO.m{2} HctT.tinv{2} HctT.leakT{2}
               x0 c0 (rdof signs{2} leak{2}) /\
         ctx{2} = size (rdof signs{2} leak{2}) /\ 8 <= ctx{2} /\ i{2} < 256 /\
         (i{2} < j{2} => acc_i (drop 8 (rdof signs{2} leak{2})) = i{2}) /\
         (j{2} <= i{2} => acc_i (drop 8 (rdof signs{2} leak{2})) = i{2} + 1)).
  + wp; exlim (rdof signs{2} leak{2}) => rd.
    call (E_read x0 c0 rd); auto => /> &1 &2 hinv h8 hi hj1 _ hij.
    have hacc := hj1 hij.
    split; 1: by split; [apply (sb_ltacc _ _ _ _ _ _ _ _ _ hinv) => // /# | rewrite hacc].
    move=> _ _ b m1 m2 hinv'; rewrite rdof_l size_rcons hinv' /=; split; 1: smt().
    rewrite drop8_rcons // acc_rcons hacc /step_i.
    by case: (i{2} < to_int b) => /#.
  auto => /> &1 &2 hinv h8 hle hlt; split; 1: smt().
  by move=> m1 m2 j leak' hj _ hinv' h8' hacc'; smt().
wp.
while (={ctx, signs, byte, leak} /\ x{1} = c0 /\ x{2} = x0 /\ leak{2} = [] /\
       sbinv ROct.RO.m{1} SIB.XOF.RO.m{1} SD.XOF.m{2} LX.RO.m{2} HctT.tinv{2} HctT.leakT{2}
             x0 c0 (rdof signs{2} []) /\
       ctx{2} = size (rdof signs{2} []) /\ ctx{2} <= 8).
- wp; exlim (rdof signs{2} []) => rd.
  call (E_read x0 c0 rd); auto => /> &1 &2 hinv h8 hlt.
  split; 1: by split => [| /#]; apply (sb_lt8 _ _ _ _ _ _ _ _ _ hinv).
  by move=> _ _ b m1 m2 hinv'; rewrite rdof_s size_rcons hinv' /= /#.
auto => /> &1 &2 hinv0 m1 m2 signs hs _ hinv h8.
split.
- split; 1: smt(); split; 1: smt(tau_bound).
  by rewrite drop_oversize 1:/# /acc_i.
move=> m1' m2' leak ha _ hinv' h8' hle.
by rewrite lts_eq hinv' h8' /=; smt().
qed.

local lemma sb_init mct xm1 m2 lm ti lt x0 c0 :
  hm m2 x0 c0 => rel mct xm1 m2 lm ti lt (Some (x0, c0, 0)) =>
  sbinv mct xm1 m2 lm ti lt x0 c0 [].
proof. by rewrite /sbinv /= => -> -> /=; smt(List.size_ge0 take0). qed.

local lemma sb_fin mct xm1 m2 lm ti lt x0 c0 rd :
  sbinv mct xm1 m2 lm ti lt x0 c0 rd => 8 <= size rd => acc_i (drop 8 rd) = 256 =>
  rel mct xm1 m2 lm ti lt.[c0 <- rd] None.
proof.
move=> hinv h8 hacc; have [hc hlt] := sb_end _ _ _ _ _ _ _ _ _ hinv h8 hacc.
move: hinv; rewrite /sbinv => -[#] hx hr hb _ _.
exact (rel_end _ _ _ _ _ _ _ _ _ hr hx hc hb hlt).
qed.

(* The challenge of an iteration of the signer, up to [HctT.bad] *)
local lemma Chal_G1_G2 :
  equiv[ChalH(SIB.XOF.RO, ROct.RO).get ~ ChalX.get :
        ={w1, mu} /\ !HctT.bad{2} /\
        rel ROct.RO.m{1} SIB.XOF.RO.m{1} SD.XOF.m{2} LX.RO.m{2} HctT.tinv{2} HctT.leakT{2} None ==>
        !HctT.bad{2} => ={res} /\
        rel ROct.RO.m{1} SIB.XOF.RO.m{1} SD.XOF.m{2} LX.RO.m{2} HctT.tinv{2} HctT.leakT{2} None].
proof.
proc.
seq 1 1 : (={w1, mu} /\
           (!HctT.bad{2} => ={ct} /\ hm SD.XOF.m{2} (w1, mu){2} ct{2} /\
             rel ROct.RO.m{1} SIB.XOF.RO.m{1} SD.XOF.m{2} LX.RO.m{2} HctT.tinv{2} HctT.leakT{2}
                 (Some ((w1, mu){2}, ct{2}, 0)))).
- by exlim (w1, mu){2} => x0; call (E_sample x0); auto => /> /#.
case (HctT.bad{2}).
- conseq (: HctT.bad{2} ==> HctT.bad{2}) => //.
  by wp; call{1} SIB_ll; call{2} SDSIB_ll; auto.
exlim ct{2}, (w1, mu){2} => c0 x0.
wp; call (SB_eq x0 c0); auto => /> &1 &2 hrel hb.
have [hc [hx hr]] := hrel hb; rewrite hc /=; split; 1: by apply sb_init.
move=> _ r m1 m2 hinv h8 hacc.
exact (sb_fin _ _ _ _ _ _ _ _ _ hinv h8 hacc).
qed.

local lemma Hmu_eq :
  equiv[ROmu.RO.get ~ HmuB.get :
        ={arg} /\ ROmu.RO.m{1} = HmuB.m{2} ==> ={res} /\ ROmu.RO.m{1} = HmuB.m{2}].
proof.
proc; sp; if{2}.
- rcondt{1} 2; 1: by auto => />.
  by wp; rnd; auto => />.
rcondf{1} 2; 1: by auto => />.
by wp; rnd{1}; auto => />; smt(dmu_ll).
qed.

(* Termination of the oracles of G1 and G2, monotonicity of [HctT.bad] *)
local lemma MLDSAGen_ll (MG <: MatGen) (CG <: ChalGen) (Hmu <: Hash_mu) :
  islossless MG.get => islossless CG.get => islossless Hmu.get =>
  islossless MLDSAGen(MG, CG, Hmu).sign.
proof.
move=> MG_ll get_ll Hmu_ll; proc.
while true (kappa_max - ctr).
- move=> z; wp; if; 2: by auto => /> /#.
  wp; call get_ll; auto => /> &hr _; split; 2: smt().
  by apply dvector_ll; exact dRq_mask_ll.
by wp; call Hmu_ll; wp; call MG_ll; auto => /> /#.
qed.

local lemma ChalH_ll : islossless ChalH(SIB.XOF.RO, ROct.RO).get.
proof. by proc; call SIB_ll; inline *; auto => />; smt(dct_ll). qed.

local lemma Sign1_ll : islossless MLDSAGen(MatRA, ChalH(SIB.XOF.RO, ROct.RO), ROmu.RO).sign.
proof.
apply (MLDSAGen_ll MatRA (ChalH(SIB.XOF.RO, ROct.RO)) ROmu.RO).
- by proc; call ExpandA_XASim_ll.
- exact ChalH_ll.
by proc; auto; smt(dmu_ll).
qed.

local lemma HctT_sample_bad :
  phoare[HctT.sample : HctT.bad ==> HctT.bad] = 1%r.
proof. by proc; inline *; auto => /> &hr hb; apply/dmap_ll/dct_ll. qed.

local lemma HctT_get_bad :
  phoare[HctT.get : HctT.bad ==> HctT.bad] = 1%r.
proof. by proc; wp; call HctT_sample_bad; auto. qed.

local lemma ChalX_bad :
  phoare[ChalX.get : HctT.bad ==> HctT.bad] = 1%r.
proof. by proc; wp; call SDSIB_ll; call HctT_sample_bad; auto. qed.

local lemma SignX_bad :
  phoare[MLDSAGen(MatRA, ChalX, HmuB).sign : HctT.bad ==> HctT.bad] = 1%r.
proof.
proc; while (HctT.bad) (kappa_max - ctr).
- move=> z; wp; if; 2: by auto => /> /#.
  wp; call ChalX_bad; auto => /> &hr _ _; split; 2: smt().
  by apply dvector_ll; exact dRq_mask_ll.
wp; call (: HctT.bad ==> HctT.bad); 1: by proc; sp; if; auto => />; smt(dmu_ll).
by inline MatRA.get; wp; call ExpandA_XASim_ll; auto => /> /#.
qed.

local lemma XC_bad :
  phoare[XCSim(SD.XOF).get : HctT.bad ==> HctT.bad] = 1%r.
proof.
proc; inline *; if; 1: by auto; smt(dB_ll).
if; 1: by auto.
by if; auto => />; smt(dB_ll dmap_ll).
qed.

(* The signing procedures of G1 and G2, up to [HctT.bad] (they run in
   lockstep: [MLDSAGen] has a guard on the counter only) *)
local lemma Sign_G1_G2 :
  equiv[MLDSAGen(MatRA, ChalH(SIB.XOF.RO, ROct.RO), ROmu.RO).sign ~
        MLDSAGen(MatRA, ChalX, HmuB).sign :
        ={sk, m, glob XASim} /\ ROmu.RO.m{1} = HmuB.m{2} /\ !HctT.bad{2} /\
        rel ROct.RO.m{1} SIB.XOF.RO.m{1} SD.XOF.m{2} LX.RO.m{2} HctT.tinv{2} HctT.leakT{2} None ==>
        ={glob XASim} /\ (!HctT.bad{2} => ={res} /\ ROmu.RO.m{1} = HmuB.m{2} /\
        rel ROct.RO.m{1} SIB.XOF.RO.m{1} SD.XOF.m{2} LX.RO.m{2} HctT.tinv{2} HctT.leakT{2} None)].
proof.
proc.
seq 9 9 : (={mA, la, rho, s1, s2, t0, mu, ct, response, leak, ctr, r0_fail, hint_fail, glob XASim} /\
             ROmu.RO.m{1} = HmuB.m{2} /\ !HctT.bad{2} /\
             rel ROct.RO.m{1} SIB.XOF.RO.m{1} SD.XOF.m{2} LX.RO.m{2} HctT.tinv{2} HctT.leakT{2}
                 None).
- wp; call Hmu_eq; wp.
  by call (: ={glob XASim}); [sim | auto].
while (={ctr, mA, s1, s2, t0, mu, glob XASim} /\
       (!HctT.bad{2} =>
        ={ct, response, leak, r0_fail, hint_fail} /\ ROmu.RO.m{1} = HmuB.m{2} /\
        rel ROct.RO.m{1} SIB.XOF.RO.m{1} SD.XOF.m{2} LX.RO.m{2} HctT.tinv{2} HctT.leakT{2}
            None)); 2: by auto => /> /#.
wp; case (HctT.bad{2}).
- conseq (: HctT.bad{2} /\ ={ctr, mA, s1, s2, t0, mu, glob XASim} ==>
            HctT.bad{2} /\ ={ctr, mA, s1, s2, t0, mu, glob XASim}); 1, 2: smt().
  seq 1 0 : (HctT.bad{2} /\ ={ctr, mA, s1, s2, t0, mu, glob XASim}).
  + if{1}; 2: by auto.
    wp; call{1} ChalH_ll; auto => />.
    by move=> *; apply dvector_ll; exact dRq_mask_ll.
  if{2}; 2: by auto.
  wp; call{2} ChalX_bad; auto => />.
  by move=> *; apply dvector_ll; exact dRq_mask_ll.
if; 1: smt(); last by skip => />; smt().
seq 3 3 : (={y, w, w1, ctr, mA, s1, s2, t0, mu, glob XASim, ct, response, leak, r0_fail, hint_fail} /\
           ROmu.RO.m{1} = HmuB.m{2} /\ !HctT.bad{2} /\
           rel ROct.RO.m{1} SIB.XOF.RO.m{1} SD.XOF.m{2} LX.RO.m{2} HctT.tinv{2} HctT.leakT{2}
               None).
- by auto => /> /#.
seq 1 1 : (={y, w, w1, ctr, mA, s1, s2, t0, mu, glob XASim, response, leak, r0_fail, hint_fail} /\
           (!HctT.bad{2} => ={ct, c, lc} /\ ROmu.RO.m{1} = HmuB.m{2} /\
             rel ROct.RO.m{1} SIB.XOF.RO.m{1} SD.XOF.m{2} LX.RO.m{2} HctT.tinv{2} HctT.leakT{2}
                 None)).
- by call Chal_G1_G2; auto => /> /#.
case (HctT.bad{2}).
- conseq (: HctT.bad{2} /\ ={ctr, mA, s1, s2, t0, mu, glob XASim} ==>
            HctT.bad{2} /\ ={ctr, mA, s1, s2, t0, mu, glob XASim}); 1, 2: smt().
  by auto.
by auto => /> /#.
qed.

(* The verification of the forgery *)
local lemma SBX_eq :
  equiv[SIB.SampleInBall(SIB.XOF.RO).get ~ SIB.SampleInBall(XCSim(SD.XOF)).get :
        ={x} /\ !HctT.bad{2} /\
        rel ROct.RO.m{1} SIB.XOF.RO.m{1} SD.XOF.m{2} LX.RO.m{2} HctT.tinv{2} HctT.leakT{2} None ==>
        ={res} /\ !HctT.bad{2} /\
        rel ROct.RO.m{1} SIB.XOF.RO.m{1} SD.XOF.m{2} LX.RO.m{2} HctT.tinv{2} HctT.leakT{2} None].
proof.
proc.
while (={i, ctx, signs, challenge, leak, x, byte} /\ !HctT.bad{2} /\
       rel ROct.RO.m{1} SIB.XOF.RO.m{1} SD.XOF.m{2} LX.RO.m{2} HctT.tinv{2} HctT.leakT{2} None).
- wp; while (={i, j, ctx, signs, challenge, leak, x, byte} /\ !HctT.bad{2} /\
             rel ROct.RO.m{1} SIB.XOF.RO.m{1} SD.XOF.m{2} LX.RO.m{2} HctT.tinv{2} HctT.leakT{2}
                 None).
  + by wp; call E_XC; auto.
  by auto.
wp; while (={ctx, signs, x, byte} /\ !HctT.bad{2} /\
           rel ROct.RO.m{1} SIB.XOF.RO.m{1} SD.XOF.m{2} LX.RO.m{2} HctT.tinv{2} HctT.leakT{2} None).
- by wp; call E_XC; auto.
by auto.
qed.

local lemma Verify_G1_G2 :
  equiv[MLDSA1(SIB.XOF.RO, ROtr.RO, ROmu.RO, ROct.RO).verify ~
        MLDSA1(XCSim(SD.XOF), ROtr.RO, HmuB, HctT).verify :
        ={arg, ROtr.RO.m} /\ ROmu.RO.m{1} = HmuB.m{2} /\ !HctT.bad{2} /\
        rel ROct.RO.m{1} SIB.XOF.RO.m{1} SD.XOF.m{2} LX.RO.m{2} HctT.tinv{2} HctT.leakT{2} None ==>
        !HctT.bad{2} => ={res}].
proof.
proc.
seq 5 5 : (={pk, m, sig, mA, rho, t1, ct, response, z, h, tr, mu} /\ !HctT.bad{2} /\
           rel ROct.RO.m{1} SIB.XOF.RO.m{1} SD.XOF.m{2} LX.RO.m{2} HctT.tinv{2} HctT.leakT{2}
               None).
- by call Hmu_eq; call (: ={ROtr.RO.m}); [sim | auto].
seq 1 1 : (={pk, m, sig, mA, rho, t1, ct, response, z, h, tr, mu, c, lc} /\ !HctT.bad{2} /\
           rel ROct.RO.m{1} SIB.XOF.RO.m{1} SD.XOF.m{2} LX.RO.m{2} HctT.tinv{2} HctT.leakT{2}
               None).
- by call SBX_eq; auto.
by wp; call E_Hct; auto => /> /#.
qed.

local lemma Verify1_ll : islossless MLDSA1(SIB.XOF.RO, ROtr.RO, ROmu.RO, ROct.RO).verify.
proof.
proc; call (: true); 1: by islossless.
wp; call SIB_ll; call (: true); 1: by islossless.
by call (: true); [islossless | auto].
qed.

local lemma Hmu_bad : phoare[HmuB.get : HctT.bad ==> HctT.bad] = 1%r.
proof. by proc; sp; if; auto => />; smt(dmu_ll). qed.

local lemma Htr_bad : phoare[ROtr.RO.get : HctT.bad ==> HctT.bad] = 1%r.
proof. by proc; auto => />; smt(dtr_ll). qed.

local lemma VerifyX_bad :
  phoare[MLDSA1(XCSim(SD.XOF), ROtr.RO, HmuB, HctT).verify : HctT.bad ==> HctT.bad] = 1%r.
proof.
proc; call HctT_get_bad; wp.
call (: HctT.bad ==> HctT.bad); 1: by conseq SIBX_ll.
by call Hmu_bad; call Htr_bad; auto.
qed.

local lemma rel0 : rel empty empty empty empty empty empty None.
proof. by rewrite /rel /hm; smt(emptyE mem_empty). qed.

local lemma G1_G2 :
  equiv[G1(A).main ~ G2(A).main : ={glob A} ==> !HctT.bad{2} => ={res}].
proof.
proc.
seq 11 12 : (!HctT.bad{2} =>
             ={m, sig, pk, sk, O_CMA1.qs, ROtr.RO.m, RA.mA} /\ ROmu.RO.m{1} = HmuB.m{2} /\
             rel ROct.RO.m{1} SIB.XOF.RO.m{1} SD.XOF.m{2} LX.RO.m{2} HctT.tinv{2} HctT.leakT{2}
                 None).
- call (: HctT.bad,
          ={glob XASim, ROtr.RO.m, O_CMA1.sk, O_CMA1.qs} /\ ROmu.RO.m{1} = HmuB.m{2} /\
          rel ROct.RO.m{1} SIB.XOF.RO.m{1} SD.XOF.m{2} LX.RO.m{2} HctT.tinv{2} HctT.leakT{2}
              None).
  + move=> XA XC Htr Hmu Hct O h1 h2 h3 h4 h5 h6.
    exact (A_ll XA XC Htr Hmu Hct O h6 h5 h4 h3 h2 h1).
  + by proc; wp; call Sign_G1_G2; auto => /> /#.
  + by move=> &2 _; proc; wp; call Sign1_ll; auto.
  + by move=> _; proc; wp; call SignX_bad; auto.
  + by proc *; call E_Hct; auto => /> /#.
  + by move=> &2 _; islossless.
  + by move=> _; conseq HctT_get_bad.
  + by proc *; call Hmu_eq; auto => /> /#.
  + by move=> &2 _; islossless.
  + by move=> _; conseq Hmu_bad.
  + by proc *; call (: ={ROtr.RO.m}); [sim | auto => /> /#].
  + by move=> &2 _; islossless.
  + by move=> _; conseq Htr_bad.
  + by proc *; call E_XC; auto => /> /#.
  + by move=> &2 _; proc; auto => />; exact dB_ll.
  + by move=> _; conseq XC_bad.
  + by proc *; call (: ={glob XASim}); [sim | auto => /> /#].
  + by move=> &2 _; exact XASim_ll.
  + by move=> _; proc *; call XASim_ll; auto.
  by inline *; auto => />; smt(rel0).
inline G1(A).O.fresh G1(A).O.nr_queries G2(A).O.fresh G2(A).O.nr_queries.
case (HctT.bad{2}).
- by wp; call{1} Verify1_ll; call{2} VerifyX_bad; auto => /> /#.
by wp; call Verify_G1_G2; auto => /> /#.
qed.

(* ---- end of the G1 -> G2 helpers ---- *)

(* G1 -> G2 (TableCollision): up to the collisions on [Hct]/[XC]
   and on [Hmu]. The winning event of G2 excludes the bad events, as needed
   by hop_reduction. *)
lemma hop_collisions &m :
  Pr[G1(A).main() @ &m : res] <=
  Pr[G2(A).main() @ &m : res /\ !HctT.bad /\ !HmuB.bad] + bound_ct + bound_mu.
proof.
have h1 : Pr[G1(A).main() @ &m : res] <=
          Pr[G2(A).main() @ &m : (res /\ !HctT.bad /\ !HmuB.bad) \/ (HmuB.bad \/ HctT.bad)].
- by byequiv G1_G2 => // /#.
apply (ler_trans _ _ _ h1); rewrite Pr[mu_or] Pr[mu_or].
have hct := ct_bound &m; have hmu := mu_bound &m.
smt(mu_bounded).
qed.

end section PROOF.

end MLDSAProof_Collisions.
