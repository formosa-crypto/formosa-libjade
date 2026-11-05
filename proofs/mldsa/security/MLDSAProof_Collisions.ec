require import AllCore Distr List IntDiv FSet FMap Leakage Byte Finite.
require import StdOrder.
import RealOrder.
require PROM TableCollision MLDSAProof_ExpandA.

(** Hop G1 -> G2 of [doc/proof_overview.tex] (injective hashes):
    [hop_collisions], up to the collisions on [Hct]/[XC] and on [Hmu]. G1
    and G2 are related through the intermediate game [D(G)], a distinguisher
    of the random oracle [G] of [Hct] (PROM eager/lazy): with the eager [G],
    [D] is G1 up to the bad event [coll] (two inputs of [Hct] with the same
    output, or an output of [Hct] queried to the local XOF [LX]); with the
    lazy [G], it is G2. The probabilities of [coll] and of a collision on
    [Hmu] are bounded by two instances of [TableCollision] ([coll_bound],
    [mu_bound]). The signing procedures are instances of [MLDSAGen] which
    only differ by their challenge ([ChalH], [ChalE(G)], [ChalX]). *)

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

(* ==================================================================== *)
(* G1 -> G2: helpers                                                    *)
(* ==================================================================== *)

(* Intermediate game [D(G)], a distinguisher for the [Hct] random oracle
   [G] (PROM eager/lazy): it is [G2] where [Hct] is answered from [G]
   ([HctE]), and where every iteration of the signing loop calls
   [G.sample(w1, mu)] ([ChalE]; the loop of [MLDSAGen] has a guard on the
   counter only, so that both signing procedures run in lockstep even
   when the bad event occurs in the middle). The [(w1, mu)] of the rejected
   iterations are recorded in [St.pend]; at the end of the game they are
   all queried to [G] ([Flush]), so that the bad event [coll] can be read
   on [St.fl].
   - with [G = PC.RO] (eager), [D] is [G1] up to [coll];
   - with [G = PC.LRO] (lazy), [D] is [G2] (plus the final flush). *)

(* The random oracle for [Hct] in the intermediate game (a local clone, so
   that the adversary cannot access it) *)
local clone PROM.FullRO as PC with
  type in_t    <- high list * mu_t,
  type out_t   <- ctilde,
  op   dout    <- fun _ => dct,
  type d_in_t  <- unit,
  type d_out_t <- bool
proof *.

local module St = {
  var pend : (high list * mu_t) list
  var fl   : (high list * mu_t, ctilde) fmap
  var win  : bool
}.

(* The bad event: two inputs of [Hct] with the same output, or an output
   of [Hct] queried to the local XOF [LX] *)
local op [opaque] coll (pm : (high list * mu_t, ctilde) fmap)
              (lm : (ctilde * int, byte) fmap) =
  (exists x1 x2, x1 <> x2 /\ pm.[x1] <> None /\ pm.[x1] = pm.[x2]) \/
  (exists x ct i, pm.[x] = Some ct /\ (ct, i) \in lm).

local module HctE (G : PC.RO) : Hash_ct = {
  proc get(x : high list * mu_t) : ctilde = {
    var ct;
    if (x \notin HctT.t) {
      ct <@ G.get(x);
      HctT.bad <- HctT.bad \/ ct \in HctT.tinv \/ (exists i, (ct, i) \in LX.RO.m);
      if (ct \notin HctT.tinv) {
        HctT.tinv.[ct] <- x;
      }
      HctT.t.[x] <- ct;
    }
    return oget HctT.t.[x];
  }
}.

(* The challenge of [D(G)]: the challenge of G2, where every iteration
   also calls [G.sample(w1, mu)] and pushes [(w1, mu)] on [St.pend]; the
   accepted iteration is popped from [St.pend] by [final], which computes
   its [c~] from [G] *)
local module ChalE (G : PC.RO) : ChalGen = {
  proc get(w1 : high list, mu : mu_t) : ctilde * Rq * leakage = {
    var c, lc;
    G.sample(w1, mu);
    St.pend <- (w1, mu) :: St.pend;
    (c, lc) <@ SD.SIB.SampleInBall(SD.XOF).get(w1, mu);
    return (witness, c, lc);
  }

  proc final(w1 : high list, mu : mu_t, ct : ctilde) : ctilde = {
    var ct';
    St.pend <- behead St.pend;
    ct' <@ HctE(G).get(w1, mu);
    return ct';
  }
}.

local module Flush (G : PC.RO) = {
  proc run() : unit = {
    var x, ct;
    St.fl <- HctT.t;
    while (St.pend <> []) {
      x <- head witness St.pend;
      if (x \notin St.fl) {
        ct <@ G.get(x);
        St.fl.[x] <- ct;
      }
      St.pend <- behead St.pend;
    }
  }
}.

local module D (G : PC.RO) = {
  module XC = XCSim(SD.XOF)
  module H  = HctE(G)
  module S  = MLDSA1(XC, ROtr.RO, HmuB, H)
  module O  = O_CMA1(MLDSAGen(MatRA, ChalE(G), HmuB))

  proc distinguish(u : unit) : bool = {
    var pk, sk, m, sig, nrqs;
    var is_valid, is_fresh;

    G.init();
    XASim.init();
    RA.init();
    SD.XOF.init();
    LX.RO.init();
    HctT.init();
    ROtr.RO.init();
    HmuB.init();
    St.pend <- [];
    (pk, sk) <@ S.keygen();
    RA.rho <- pk.`1;
    RA.mA  <- sk.`1;
    O.init(sk.`2);
    (m, sig) <@ A(XASim, XC, ROtr.RO, HmuB, H, O).forge(pk);
    is_valid <@ S.verify(sk.`1, pk, m, sig);
    is_fresh <@ O.fresh(m);
    nrqs <@ O.nr_queries();
    St.win <- nrqs <= qS /\ is_valid /\ is_fresh;
    Flush(G).run();
    return St.win;
  }
}.

(* -------------------------------------------------------------------- *)
(* The lazy game is G2 *)

local lemma HctE_LRO_HctT :
  equiv[HctE(PC.LRO).get ~ HctT.get :
        ={x, HctT.t, HctT.tinv, HctT.bad, LX.RO.m} /\ PC.RO.m{1} = HctT.t{1} ==>
        ={res, HctT.t, HctT.tinv, HctT.bad, LX.RO.m} /\ PC.RO.m{1} = HctT.t{1}].
proof.
proc; inline *; if => //.
rcondt{1} 3; 1: by auto.
by auto => /> &2 _ ct _; rewrite !get_set_sameE.
qed.

local lemma Sign_LRO_G2 :
  equiv[MLDSAGen(MatRA, ChalE(PC.LRO), HmuB).sign ~ MLDSAGen(MatRA, ChalX, HmuB).sign :
        ={sk, m, RA.mA, HctT.t, HctT.tinv, HctT.bad, LX.RO.m, HmuB.m, HmuB.bad,
          SD.DSSXOF.PRO.RO.m} /\ PC.RO.m{1} = HctT.t{1} ==>
        ={res, HctT.t, HctT.tinv, HctT.bad, LX.RO.m, HmuB.m, HmuB.bad,
          SD.DSSXOF.PRO.RO.m} /\ PC.RO.m{1} = HctT.t{1}].
proof.
proc; inline MatRA.get.
seq 12 12 : (={w1, mu, ct, response, leak, HctT.t, HctT.tinv, HctT.bad, LX.RO.m,
               HmuB.m, HmuB.bad, SD.DSSXOF.PRO.RO.m} /\ PC.RO.m{1} = HctT.t{1}).
- while (={ctr, w1, mu, ct, response, leak, mA, s1, s2, t0, r0_fail, hint_fail, HctT.t,
           HctT.tinv, HctT.bad, LX.RO.m, HmuB.m, HmuB.bad, SD.DSSXOF.PRO.RO.m} /\
         PC.RO.m{1} = HctT.t{1}).
  + wp; if => //; inline ChalE(PC.LRO).get ChalX.get PC.LRO.sample; wp.
    call (: ={SD.DSSXOF.PRO.RO.m}); 1: by sim.
    by auto.
  wp; call (: ={HmuB.m, HmuB.bad}); 1: by sim.
  by auto.
if => //; inline ChalE(PC.LRO).final ChalX.final; wp.
by call HctE_LRO_HctT; auto.
qed.

local lemma PC_get_ll : islossless PC.RO.get by islossless.

local lemma Flush_ll (G <: PC.RO{-St}) : islossless G.get => islossless Flush(G).run.
proof.
move=> G_ll; proc; while true (size St.pend).
- move=> z; sp; if.
  + by wp; call G_ll; auto => /> &hr hne _; smt(size_behead List.size_ge0).
  by auto => /> &hr hne _; smt(size_behead List.size_ge0).
by auto => /> pend; case: pend => //= l; smt(List.size_ge0).
qed.

local lemma D_G2 &m (p : bool -> bool -> bool -> bool) :
  Pr[D(PC.LRO).distinguish() @ &m : p St.win HctT.bad HmuB.bad] =
  Pr[G2(A).main() @ &m : p res HctT.bad HmuB.bad].
proof.
byequiv => //; proc.
call{1} (Flush_ll PC.LRO _); 1: by islossless.
wp; call (: ={O_CMA1.qs}); 1: by sim.
call (: ={O_CMA1.qs}); 1: by sim.
call (: ={pk, m, sig, mA, HctT.t, HctT.tinv, HctT.bad, LX.RO.m, HmuB.m, HmuB.bad,
          SD.DSSXOF.PRO.RO.m, ROtr.RO.m} /\ PC.RO.m{1} = HctT.t{1} ==>
        ={res, HctT.t, HctT.tinv, HctT.bad, LX.RO.m, HmuB.m, HmuB.bad,
          SD.DSSXOF.PRO.RO.m, ROtr.RO.m} /\ PC.RO.m{1} = HctT.t{1}).
- proc; call HctE_LRO_HctT; wp.
  call (: ={HctT.t, HctT.tinv, LX.RO.m, SD.DSSXOF.PRO.RO.m}); 1: by sim.
  call (: ={HmuB.m, HmuB.bad}); 1: by sim.
  by call (: ={ROtr.RO.m}); 1: sim; auto.
call (: ={HctT.t, HctT.tinv, HctT.bad, LX.RO.m, HmuB.m, HmuB.bad, SD.DSSXOF.PRO.RO.m,
          ROtr.RO.m, glob XASim, O_CMA1.sk, O_CMA1.qs} /\ PC.RO.m{1} = HctT.t{1}).
- by proc; wp; call Sign_LRO_G2; auto.
- by conseq HctE_LRO_HctT.
- by proc *; call (: ={HmuB.m, HmuB.bad}); [sim | auto].
- by proc *; call (: ={ROtr.RO.m}); [sim | auto].
- by proc *; call (: ={HctT.tinv, LX.RO.m, SD.DSSXOF.PRO.RO.m}); [sim | auto].
- by proc *; call (: ={glob XASim}); [sim | auto].
by inline *; auto => />.
qed.

(* -------------------------------------------------------------------- *)
(* Collisions on [Hmu]: TableCollision on the table [HmuB.m] (no [put]) *)

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
call (: ={arg, glob XASim, SD.DSSXOF.PRO.RO.m, LX.RO.m, HctT.t, HctT.tinv, HctT.bad,
          ROtr.RO.m} /\
        tmu HmuB.m{1} HmuB.bad{1} TCmu.Tab.m{2} TCmu.Tab.bad{2} TCmu.Tab.ks{2} ==>
        HmuB.bad{1} = TCmu.Tab.bad{2}).
- proc; call (: ={HctT.t, HctT.tinv, HctT.bad, LX.RO.m}); 1: by sim.
  wp; call (: ={HctT.tinv, LX.RO.m, SD.DSSXOF.PRO.RO.m}); 1: by sim.
  call HmuB_Tab.
  by call (: ={ROtr.RO.m}); 1: sim; auto.
call (: ={glob XASim, SD.DSSXOF.PRO.RO.m, LX.RO.m, HctT.t, HctT.tinv, HctT.bad, ROtr.RO.m,
          O_CMA1.sk, O_CMA1.qs} /\
        tmu HmuB.m{1} HmuB.bad{1} TCmu.Tab.m{2} TCmu.Tab.bad{2} TCmu.Tab.ks{2}).
- proc; inline{2} 2; wp.
  call (: ={sk, m, RA.mA, SD.DSSXOF.PRO.RO.m, LX.RO.m, HctT.t, HctT.tinv, HctT.bad,
            ROtr.RO.m} /\
          tmu HmuB.m{1} HmuB.bad{1} TCmu.Tab.m{2} TCmu.Tab.bad{2} TCmu.Tab.ks{2} ==>
          ={res, SD.DSSXOF.PRO.RO.m, LX.RO.m, HctT.t, HctT.tinv, HctT.bad, ROtr.RO.m} /\
          tmu HmuB.m{1} HmuB.bad{1} TCmu.Tab.m{2} TCmu.Tab.bad{2} TCmu.Tab.ks{2}).
  + proc; seq 8 8 : (={ct, w1, r0_fail, hint_fail, mA, leak, rho, tr, s1, s2, t0, mu,
                       SD.DSSXOF.PRO.RO.m, LX.RO.m, HctT.t, HctT.tinv, HctT.bad, ROtr.RO.m} /\
                     tmu HmuB.m{1} HmuB.bad{1} TCmu.Tab.m{2} TCmu.Tab.bad{2} TCmu.Tab.ks{2}).
    * by call HmuB_Tab; inline MatRA.get; auto.
    sim / (tmu HmuB.m{1} HmuB.bad{1} TCmu.Tab.m{2} TCmu.Tab.bad{2} TCmu.Tab.ks{2}) :
          (={ct, response, leak, SD.DSSXOF.PRO.RO.m, LX.RO.m, HctT.t, HctT.tinv, HctT.bad,
             ROtr.RO.m}).
  by auto.
- by proc *; inline{2} 1; wp; call (: ={HctT.t, HctT.tinv, HctT.bad, LX.RO.m}); [sim | auto].
- by proc *; inline{2} 1; wp; call HmuB_Tab; auto.
- by proc *; inline{2} 1; wp; call (: ={ROtr.RO.m}); [sim | auto].
- by proc *; inline{2} 1; wp; call (: ={HctT.tinv, LX.RO.m, SD.DSSXOF.PRO.RO.m}); [sim | auto].
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
    seq 12 : (TCmu.Count.cp = 0 /\ TCmu.Count.cg <= CountHmu.q + CountS.q).
    * by inline *; wp; call (: true); auto => /> /#.
    seq 3 : (TCmu.Count.cp = 0 /\ TCmu.Count.cg <= CountHmu.q + CountS.q).
    * while (TCmu.Count.cp = 0 /\ TCmu.Count.cg <= CountHmu.q + CountS.q); 2: by auto.
      by wp; if => //; wp; call (: true) => //; auto.
    by sp; if => //; wp; call (: true) => //; auto.
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

(* -------------------------------------------------------------------- *)
(* Collisions on [Hct] ([coll] in the lazy game): TableCollision on the
   table [St.fl] of [Hct] (filled by [HctE] and by [Flush]), the [put]
   values are the [c~] queried to [LX] (which are not outputs of [Hct]
   at the time of the query) *)

local clone TableCollision as TCct with
  type in_t  <- high list * mu_t,
  type out_t <- ctilde,
  op   dout  <- dct,
  op   eps   <- eps_ct
proof *.
realize dout_ll by exact dct_ll.
realize dout_max by exact dct_max.

(* [Hct] samples through the [get] oracle of TableCollision *)
local module GB (T : TCct.Oracle) : PC.RO = {
  proc init() : unit = { }
  proc get(x : high list * mu_t) : ctilde = {
    var r;
    r <@ T.get(x);
    return r;
  }
  proc set(x : high list * mu_t, y : ctilde) : unit = { }
  proc rem(x : high list * mu_t) : unit = { }
  proc sample(x : high list * mu_t) : unit = { }
}.

(* [XC] puts the [c~] queried to [LX] *)
local module XCB (T : TCct.Oracle) : SIB.XOF_t = {
  var ps : ctilde fset

  proc get(y : ctilde * int) : byte = {
    var r;
    if (y.`1 \in HctT.tinv) {
      r <@ SD.XOF.get(oget HctT.tinv.[y.`1], y.`2);
    } else {
      if (y.`1 \notin ps) {
        T.put(y.`1);
        ps <- ps `|` fset1 y.`1;
      }
      r <@ LX.RO.get(y);
    }
    return r;
  }
}.

(* The lazy game [D(PC.LRO)] as an adversary of TableCollision (with the
   query counters of MLDSATarget, to apply [A_bound]) *)
local module Act (T : TCct.Oracle) = {
  module XC = XCB(T)
  module H  = HctE(GB(T))
  module S  = MLDSA1(XC, ROtr.RO, HmuB, H)
  module O1 = O_CMA1(MLDSAGen(MatRA, ChalE(GB(T)), HmuB))

  proc main() : unit = {
    var pk, sk, m, sig, is_valid;

    XASim.init();
    RA.init();
    SD.XOF.init();
    LX.RO.init();
    HctT.init();
    ROtr.RO.init();
    HmuB.init();
    St.pend <- [];
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
    Flush(GB(T)).run();
  }
}.

(* Invariant of the reduction: [coll] implies the bad event of the table,
   the [c~] queried to [LX] are put *)
local op [opaque] cinv (t : (high list * mu_t, ctilde) fmap) (lm : (ctilde * int, byte) fmap)
              (ps : ctilde fset) (bad : bool) =
  (coll t lm => bad) /\
  (forall ct i, (ct, i) \in lm => ct \in ps).

local op [opaque] tinv_ok (t : (high list * mu_t, ctilde) fmap)
                 (tinv : (ctilde, high list * mu_t) fmap) =
  forall ct, ct \in tinv <=> exists x, t.[x] = Some ct.

(* Invariant of the reduction [Act]: the table of TableCollision is the
   table [HctT.t], the [put] values are the [c~] queried to [LX], [cinv] and
   [tinv_ok] hold (an abbreviation: the tactics see the conjunction) *)
local abbrev tcinv (tm : (high list * mu_t, ctilde) fmap) (ks : ctilde fset) (bad : bool)
  (t : (high list * mu_t, ctilde) fmap) (tinv : (ctilde, high list * mu_t) fmap)
  (ps : ctilde fset) (lm : (ctilde * int, byte) fmap) =
  tm = t /\ ks = ps /\ cinv t lm ps bad /\ tinv_ok t tinv.

local lemma cinv_add t lm ps bad x y :
  x \notin t => cinv t lm ps bad =>
  cinv t.[x <- y] lm ps (bad \/ y \in frng t \/ y \in ps).
proof.
rewrite /cinv /coll => hx -[hc hl]; split => //.
case=> [[x1 x2 [hne [hn heq]]] | [x0 ct i [hx0 hin]]].
- move: hn heq; rewrite !get_setE.
  case: (x1 = x) => [->> | hne1] /=.
  + case: (x2 = x) => [->> // | hne2] /=.
    by move=> heq; right; left; rewrite mem_frng rngE /=; exists x2; rewrite -heq.
  case: (x2 = x) => [->> | hne2] /=.
  + by move=> _ heq; right; left; rewrite mem_frng rngE /=; exists x1.
  by move=> hn heq; left; apply hc; left; exists x1 x2.
move: hx0; rewrite get_setE; case: (x0 = x) => [_ /= <<- | hne /= hx0].
- by right; right; exact (hl _ _ hin).
by left; apply hc; right; exists x0 ct i.
qed.

local lemma cinv_put t lm ps bad ct :
  cinv t lm ps bad => cinv t lm (ps `|` fset1 ct) bad.
proof. by rewrite /cinv => -[hc hl]; split => // ct' i /hl; rewrite in_fsetU => ->. qed.

local lemma cinv_lx t lm ps bad ct i b :
  (forall x, t.[x] <> Some ct) => ct \in ps => cinv t lm ps bad =>
  cinv t lm.[(ct, i) <- b] ps bad.
proof.
rewrite /cinv /coll => ht hps -[hc hl]; split.
- case=> [h | [x0 ct' i' [hx0 hin]]]; 1: by apply hc; left.
  move: hin; rewrite mem_set; case=> [hin | [->> _]].
  + by apply hc; right; exists x0 ct' i'.
  by move: (ht x0); rewrite hx0.
move=> ct' i'; rewrite mem_set; case=> [/hl // | [-> _]] //.
qed.

local lemma tinv_ok_add t tinv x y :
  x \notin t => tinv_ok t tinv =>
  tinv_ok t.[x <- y] (if y \notin tinv then tinv.[y <- x] else tinv).
proof.
rewrite /tinv_ok => hx ht ct; case: (y \in tinv) => hy /=.
- rewrite ht; split; case=> x' hx'.
  + by exists x'; rewrite get_setE; smt().
  move: hx'; rewrite get_setE; case: (x' = x) => [_ /= <- | _ /= hx'].
  + by move/ht: hy.
  by exists x'.
rewrite mem_set ht; split.
- case=> [[x' hx'] | ->].
  + by exists x'; rewrite get_setE; smt().
  by exists x; rewrite get_set_sameE.
case=> x'; rewrite get_setE; case: (x' = x) => [_ /= <- | _ /= hx'].
- by right.
by left; exists x'.
qed.

local lemma cinv_coll t lm ps bad : cinv t lm ps bad => coll t lm => bad.
proof. by rewrite /cinv => -[h _]. qed.

local lemma HctE_B :
  equiv[HctE(PC.LRO).get ~ HctE(GB(TCct.Count(TCct.Tab))).get :
        ={x, HctT.t, HctT.tinv, HctT.bad, LX.RO.m} /\ PC.RO.m{1} = HctT.t{1} /\
        tcinv TCct.Tab.m{2} TCct.Tab.ks{2} TCct.Tab.bad{2}
              HctT.t{2} HctT.tinv{2} XCB.ps{2} LX.RO.m{2} ==>
        ={res, HctT.t, HctT.tinv, HctT.bad, LX.RO.m} /\ PC.RO.m{1} = HctT.t{1} /\
        tcinv TCct.Tab.m{2} TCct.Tab.ks{2} TCct.Tab.bad{2}
              HctT.t{2} HctT.tinv{2} XCB.ps{2} LX.RO.m{2}].
proof.
proc; inline *; if => //.
rcondt{1} 3; 1: by auto.
rcondt{2} 5; 1: by auto.
wp; rnd; auto => /> &2 hci htv hx ct _.
have h1 := tinv_ok_add _ _ _ ct hx htv; have h2 := cinv_add _ _ _ _ _ ct hx hci.
by case: (ct \in HctT.tinv{2}) => hin /=; rewrite !get_set_sameE /= hin /=;
  move: h1 h2; rewrite hin.
qed.

local lemma XC_B :
  equiv[XCSim(SD.XOF).get ~ XCB(TCct.Count(TCct.Tab)).get :
        ={y, HctT.t, HctT.tinv, LX.RO.m, SD.DSSXOF.PRO.RO.m} /\
        tcinv TCct.Tab.m{2} TCct.Tab.ks{2} TCct.Tab.bad{2}
              HctT.t{2} HctT.tinv{2} XCB.ps{2} LX.RO.m{2} ==>
        ={res, HctT.t, HctT.tinv, LX.RO.m, SD.DSSXOF.PRO.RO.m} /\
        tcinv TCct.Tab.m{2} TCct.Tab.ks{2} TCct.Tab.bad{2}
              HctT.t{2} HctT.tinv{2} XCB.ps{2} LX.RO.m{2}].
proof.
proc; if => //.
- by call (: ={SD.DSSXOF.PRO.RO.m}); [sim | auto].
seq 0 1 : (={y, HctT.t, HctT.tinv, LX.RO.m, SD.DSSXOF.PRO.RO.m} /\
           y{2}.`1 \notin HctT.tinv{2} /\ y{2}.`1 \in XCB.ps{2} /\
           tcinv TCct.Tab.m{2} TCct.Tab.ks{2} TCct.Tab.bad{2}
                 HctT.t{2} HctT.tinv{2} XCB.ps{2} LX.RO.m{2}).
- if{2}; 2: by auto.
  inline *; auto => /> &2 hci htv htin hps; split; 1: smt(in_fsetU in_fset1).
  by apply cinv_put.
inline *; auto => /> &2 htin hps hci htv r _.
case: (y{2} \in LX.RO.m{2}) => //= hy.
rewrite (pairS y{2}); apply cinv_lx => // x; apply/negP => hx.
by move: htin; rewrite /tinv_ok in htv; rewrite htv; apply/negP; rewrite negbK; exists x.
qed.

local lemma SIB_B :
  equiv[SIB.SampleInBall(XCSim(SD.XOF)).get ~ SIB.SampleInBall(XCB(TCct.Count(TCct.Tab))).get :
        ={x, HctT.t, HctT.tinv, LX.RO.m, SD.DSSXOF.PRO.RO.m} /\
        tcinv TCct.Tab.m{2} TCct.Tab.ks{2} TCct.Tab.bad{2}
              HctT.t{2} HctT.tinv{2} XCB.ps{2} LX.RO.m{2} ==>
        ={res, HctT.t, HctT.tinv, LX.RO.m, SD.DSSXOF.PRO.RO.m} /\
        tcinv TCct.Tab.m{2} TCct.Tab.ks{2} TCct.Tab.bad{2}
              HctT.t{2} HctT.tinv{2} XCB.ps{2} LX.RO.m{2}].
proof.
proc.
while (={i, ctx, signs, challenge, leak, x, byte, HctT.t, HctT.tinv, LX.RO.m,
         SD.DSSXOF.PRO.RO.m} /\
       tcinv TCct.Tab.m{2} TCct.Tab.ks{2} TCct.Tab.bad{2}
             HctT.t{2} HctT.tinv{2} XCB.ps{2} LX.RO.m{2}).
- wp; while (={i, j, ctx, signs, challenge, leak, x, byte, HctT.t, HctT.tinv, LX.RO.m,
               SD.DSSXOF.PRO.RO.m} /\
             tcinv TCct.Tab.m{2} TCct.Tab.ks{2} TCct.Tab.bad{2}
                   HctT.t{2} HctT.tinv{2} XCB.ps{2} LX.RO.m{2}).
  + by wp; call XC_B; auto.
  by auto.
wp; while (={ctx, signs, x, byte, HctT.t, HctT.tinv, LX.RO.m, SD.DSSXOF.PRO.RO.m} /\
           tcinv TCct.Tab.m{2} TCct.Tab.ks{2} TCct.Tab.bad{2}
                 HctT.t{2} HctT.tinv{2} XCB.ps{2} LX.RO.m{2}).
- by wp; call XC_B; auto.
by auto.
qed.

local lemma Sign_B :
  equiv[MLDSAGen(MatRA, ChalE(PC.LRO), HmuB).sign ~
        MLDSAGen(MatRA, ChalE(GB(TCct.Count(TCct.Tab))), HmuB).sign :
        ={sk, m, RA.mA, HctT.t, HctT.tinv, HctT.bad, LX.RO.m, HmuB.m, HmuB.bad,
          SD.DSSXOF.PRO.RO.m, St.pend} /\ PC.RO.m{1} = HctT.t{1} /\
        tcinv TCct.Tab.m{2} TCct.Tab.ks{2} TCct.Tab.bad{2}
              HctT.t{2} HctT.tinv{2} XCB.ps{2} LX.RO.m{2} ==>
        ={res, HctT.t, HctT.tinv, HctT.bad, LX.RO.m, HmuB.m, HmuB.bad,
          SD.DSSXOF.PRO.RO.m, St.pend} /\ PC.RO.m{1} = HctT.t{1} /\
        tcinv TCct.Tab.m{2} TCct.Tab.ks{2} TCct.Tab.bad{2}
              HctT.t{2} HctT.tinv{2} XCB.ps{2} LX.RO.m{2}].
proof.
proc; inline MatRA.get.
seq 12 12 : (={w1, mu, ct, response, leak, HctT.t, HctT.tinv, HctT.bad, LX.RO.m, HmuB.m,
               HmuB.bad, SD.DSSXOF.PRO.RO.m, St.pend} /\ PC.RO.m{1} = HctT.t{1} /\
             tcinv TCct.Tab.m{2} TCct.Tab.ks{2} TCct.Tab.bad{2}
                   HctT.t{2} HctT.tinv{2} XCB.ps{2} LX.RO.m{2}).
- while (={ctr, w1, mu, ct, response, leak, mA, s1, s2, t0, r0_fail, hint_fail, HctT.t,
           HctT.tinv, HctT.bad, LX.RO.m, HmuB.m, HmuB.bad, SD.DSSXOF.PRO.RO.m, St.pend} /\
         PC.RO.m{1} = HctT.t{1} /\
         tcinv TCct.Tab.m{2} TCct.Tab.ks{2} TCct.Tab.bad{2}
               HctT.t{2} HctT.tinv{2} XCB.ps{2} LX.RO.m{2}).
  + wp; if => //.
    inline ChalE(PC.LRO).get ChalE(GB(TCct.Count(TCct.Tab))).get
           PC.LRO.sample GB(TCct.Count(TCct.Tab)).sample; wp.
    call (: ={SD.DSSXOF.PRO.RO.m}); 1: by sim.
    by auto.
  wp; call (: ={HmuB.m, HmuB.bad}); 1: by sim.
  by auto.
if => //; inline ChalE(PC.LRO).final ChalE(GB(TCct.Count(TCct.Tab))).final.
by wp; call HctE_B; auto.
qed.

local lemma Flush_B :
  equiv[Flush(PC.LRO).run ~ Flush(GB(TCct.Count(TCct.Tab))).run :
        ={HctT.t, St.pend, LX.RO.m} /\ PC.RO.m{1} = HctT.t{1} /\
        TCct.Tab.m{2} = HctT.t{2} /\ TCct.Tab.ks{2} = XCB.ps{2} /\
        cinv HctT.t{2} LX.RO.m{2} XCB.ps{2} TCct.Tab.bad{2} ==>
        ={St.fl, LX.RO.m} /\
        TCct.Tab.m{2} = St.fl{2} /\ TCct.Tab.ks{2} = XCB.ps{2} /\
        cinv St.fl{2} LX.RO.m{2} XCB.ps{2} TCct.Tab.bad{2}].
proof.
proc.
while (={St.fl, St.pend, LX.RO.m} /\ PC.RO.m{1} = St.fl{1} /\
       TCct.Tab.m{2} = St.fl{2} /\ TCct.Tab.ks{2} = XCB.ps{2} /\
        cinv St.fl{2} LX.RO.m{2} XCB.ps{2} TCct.Tab.bad{2}).
- sp; if => //; last by auto.
  inline *; rcondt{1} 3; 1: by auto.
  rcondt{2} 5; 1: by auto.
  wp; rnd; auto => /> &2 hne hci hx ct _.
  by rewrite !get_set_sameE /=; apply cinv_add.
auto => />.
qed.

local lemma cinv0 : cinv empty empty fset0 false.
proof.
rewrite /cinv /coll; split; 2: by move=> ct i; rewrite mem_empty.
smt(emptyE).
qed.

local lemma tinv_ok0 : tinv_ok empty empty.
proof. by rewrite /tinv_ok => ct; rewrite mem_empty /=; smt(emptyE). qed.

local lemma D_Act &m :
  Pr[D(PC.LRO).distinguish() @ &m : coll St.fl LX.RO.m] <=
  Pr[TCct.Game(Act).main() @ &m : TCct.Tab.bad].
proof.
byequiv (_ : ={glob A} ==> coll St.fl{1} LX.RO.m{1} => TCct.Tab.bad{2}) => //.
proc; inline TCct.Game(Act).main Act(TCct.Count(TCct.Tab)).main.
call Flush_B.
inline{1} D(PC.LRO).O.fresh D(PC.LRO).O.nr_queries; wp.
call (: ={arg, HctT.t, HctT.tinv, HctT.bad, LX.RO.m, HmuB.m, HmuB.bad,
          SD.DSSXOF.PRO.RO.m, ROtr.RO.m, St.pend} /\ PC.RO.m{1} = HctT.t{1} /\
        tcinv TCct.Tab.m{2} TCct.Tab.ks{2} TCct.Tab.bad{2}
              HctT.t{2} HctT.tinv{2} XCB.ps{2} LX.RO.m{2} ==>
        ={HctT.t, St.pend, LX.RO.m} /\ PC.RO.m{1} = HctT.t{1} /\
        TCct.Tab.m{2} = HctT.t{2} /\ TCct.Tab.ks{2} = XCB.ps{2} /\
        cinv HctT.t{2} LX.RO.m{2} XCB.ps{2} TCct.Tab.bad{2}).
- proc; call HctE_B; wp; call SIB_B.
  call (: ={HmuB.m, HmuB.bad}); 1: by sim.
  by call (: ={ROtr.RO.m}); 1: sim; auto.
call (: ={glob XASim, SD.DSSXOF.PRO.RO.m, LX.RO.m, HctT.t, HctT.tinv, HctT.bad,
          ROtr.RO.m, HmuB.m, HmuB.bad, O_CMA1.sk, O_CMA1.qs, St.pend} /\
        PC.RO.m{1} = HctT.t{1} /\
        tcinv TCct.Tab.m{2} TCct.Tab.ks{2} TCct.Tab.bad{2}
              HctT.t{2} HctT.tinv{2} XCB.ps{2} LX.RO.m{2}).
- by proc; inline{2} 2; wp; call Sign_B; auto.
- by proc *; inline{2} 1; wp; call HctE_B; auto.
- by proc *; inline{2} 1; wp; call (: ={HmuB.m, HmuB.bad}); [sim | auto].
- by proc *; inline{2} 1; wp; call (: ={ROtr.RO.m}); [sim | auto].
- by proc *; inline{2} 1; wp; call XC_B; auto.
- by proc *; inline{2} 1; wp; call (: ={glob XASim}); [sim | auto].
inline *; auto => />; rewrite cinv0 tinv_ok0 /=; smt(cinv_coll).
qed.

(* Query counting for [Act] *)
local lemma HctE_GB_h (T <: TCct.Oracle{-TCct.Count, -Act}) b c :
  hoare[HctE(GB(TCct.Count(T))).get :
        (b => forall ct, ct \in CountXC.xs => ct \in XCB.ps \/ ct \in HctT.tinv) /\
        TCct.Count.cg = c ==>
        (b => forall ct, ct \in CountXC.xs => ct \in XCB.ps \/ ct \in HctT.tinv) /\
        TCct.Count.cg <= c + 1].
proof.
proc; inline *; sp; if; last by auto => /> /#.
by wp; call (: true); auto => />; smt(mem_set).
qed.

local lemma Sign_GB_h (T <: TCct.Oracle{-TCct.Count, -Act}) c :
  hoare[MLDSAGen(MatRA, ChalE(GB(TCct.Count(T))), HmuB).sign :
        (forall ct, ct \in CountXC.xs => ct \in XCB.ps \/ ct \in HctT.tinv) /\
        TCct.Count.cg + size St.pend = c ==>
        (forall ct, ct \in CountXC.xs => ct \in XCB.ps \/ ct \in HctT.tinv) /\
        TCct.Count.cg + size St.pend <= c + kappa_max].
proof.
proc.
seq 11 : ((forall ct, ct \in CountXC.xs => ct \in XCB.ps \/ ct \in HctT.tinv) /\
          TCct.Count.cg + size St.pend <= c + kappa_max /\
          (response <> None => St.pend <> [])).
- while ((forall ct, ct \in CountXC.xs => ct \in XCB.ps \/ ct \in HctT.tinv) /\
         0 <= ctr <= kappa_max /\ TCct.Count.cg + size St.pend <= c + ctr /\
         (response <> None => St.pend <> [])).
  + wp; if; 2: by auto => /> /#.
    inline ChalE(GB(TCct.Count(T))).get GB(TCct.Count(T)).sample; wp.
    by call (: true) => //; auto => /> /#.
  inline MatRA.get; wp; call (: true) => //; auto => />; smt(gt0_kappa_max).
if; last by auto.
inline ChalE(GB(TCct.Count(T))).final; wp.
exlim TCct.Count.cg => c0.
call (HctE_GB_h T true c0); auto => />; smt(size_behead List.size_ge0).
qed.

local lemma XCB_h (T <: TCct.Oracle{-TCct.Count, -Act}) c0 x0 :
  hoare[XCB(TCct.Count(T)).get :
        y.`1 = x0 /\ TCct.Count.cp <= c0 + 1 /\ (x0 \notin XCB.ps => TCct.Count.cp <= c0) ==>
        TCct.Count.cp <= c0 + 1 /\ (x0 \notin XCB.ps => TCct.Count.cp <= c0)].
proof.
proc; if; 1: by call (: true) => //; auto.
seq 1 : (TCct.Count.cp <= c0 + 1 /\ (x0 \notin XCB.ps => TCct.Count.cp <= c0)).
- if; 2: by auto => /> /#.
  by inline *; wp; call (: true); auto => />; smt(in_fsetU in_fset1).
by call (: true) => //; auto.
qed.

local lemma SIB_XCB_h (T <: TCct.Oracle{-TCct.Count, -Act}) c0 :
  hoare[SIB.SampleInBall(XCB(TCct.Count(T))).get :
        TCct.Count.cp <= c0 ==> TCct.Count.cp <= c0 + 1].
proof.
proc; exlim x => x0.
while (x = x0 /\ TCct.Count.cp <= c0 + 1 /\ (x0 \notin XCB.ps => TCct.Count.cp <= c0)).
- wp; while (x = x0 /\ TCct.Count.cp <= c0 + 1 /\ (x0 \notin XCB.ps => TCct.Count.cp <= c0)).
  + by wp; call (XCB_h T c0 x0); auto.
  by auto.
wp; while (x = x0 /\ TCct.Count.cp <= c0 + 1 /\ (x0 \notin XCB.ps => TCct.Count.cp <= c0)).
- by wp; call (XCB_h T c0 x0); auto.
by auto => /> /#.
qed.

local lemma Act_bound (T <: TCct.Oracle{-TCct.Count, -Act}) :
  hoare[ Act(TCct.Count(T)).main :
         TCct.Count.cg = 0 /\ TCct.Count.cp = 0 ==>
         TCct.Count.cg <= qHct + kappa_max * qS + 1 /\ TCct.Count.cp <= qXC + 1 ].
proof.
proc.
seq 21 : ((forall ct, ct \in CountXC.xs => ct \in XCB.ps \/ ct \in HctT.tinv) /\
          TCct.Count.cp <= qXC /\ TCct.Count.cg + size St.pend <= qHct + kappa_max * qS).
- seq 20 : (TCct.Count.cp = 0 /\ TCct.Count.cg = 0 /\ St.pend = [] /\ CountXC.xs = fset0 /\
            CountXA.q = 0 /\ CountXC.q = 0 /\ CountHtr.q = 0 /\ CountHmu.q = 0 /\
            CountHct.q = 0 /\ CountS.q = 0).
  + by inline *; auto.
  conseq (: _ ==> (forall ct, ct \in CountXC.xs => ct \in XCB.ps \/ ct \in HctT.tinv) /\
                  TCct.Count.cp <= CountXC.q /\
                  TCct.Count.cg + size St.pend <= CountHct.q + kappa_max * CountS.q)
         (: CountXA.q = 0 /\ CountXC.q = 0 /\ CountHtr.q = 0 /\ CountHmu.q = 0 /\
            CountHct.q = 0 /\ CountS.q = 0 ==>
            CountXC.q <= qXC /\ CountHct.q <= qHct /\ CountS.q <= qS) => //.
  + move=> &hr _ tinv pend ps qhct qs qxc xs cg cp [#] hxs hcp hcs hqxc hqhct hqs.
    split => //; split; 1: smt().
    have : kappa_max * qs <= kappa_max * qS.
    * by apply StdOrder.IntOrder.ler_wpmul2l; [smt(gt0_kappa_max) | done].
    smt().
  + by call (A_bound XASim (XCB(TCct.Count(T))) ROtr.RO HmuB (HctE(GB(TCct.Count(T))))
                     (O_CMA1(MLDSAGen(MatRA, ChalE(GB(TCct.Count(T))), HmuB)))); auto.
  call (: (forall ct, ct \in CountXC.xs => ct \in XCB.ps \/ ct \in HctT.tinv) /\
          TCct.Count.cp <= CountXC.q /\
          TCct.Count.cg + size St.pend <= CountHct.q + kappa_max * CountS.q).
  + proc; inline O_CMA1(MLDSAGen(MatRA, ChalE(GB(TCct.Count(T))), HmuB)).sign; wp.
    exlim (TCct.Count.cg + size St.pend) => c.
    call (Sign_GB_h T c); auto => /> /#.
  + proc; exlim TCct.Count.cg => c.
    call (HctE_GB_h T true c); auto => /> /#.
  + by proc; call (: true) => //; auto.
  + by proc; call (: true) => //; auto.
  + proc; inline XCB(TCct.Count(T)).get.
    seq 1 : (y.`1 \in CountXC.xs /\
             (forall ct, ct \in CountXC.xs => ct <> y.`1 => ct \in XCB.ps \/ ct \in HctT.tinv) /\
             (y.`1 \notin XCB.ps => y.`1 \notin HctT.tinv => TCct.Count.cp + 1 <= CountXC.q) /\
             TCct.Count.cp <= CountXC.q /\
             TCct.Count.cg + size St.pend <= CountHct.q + kappa_max * CountS.q).
    * by auto => />; smt(in_fsetU in_fset1).
    sp; if.
    * by wp; call (: true) => //; auto => /> /#.
    seq 1 : (y0.`1 \in CountXC.xs /\ y0.`1 \in XCB.ps /\
             (forall ct, ct \in CountXC.xs => ct <> y0.`1 => ct \in XCB.ps \/ ct \in HctT.tinv) /\
             TCct.Count.cp <= CountXC.q /\
             TCct.Count.cg + size St.pend <= CountHct.q + kappa_max * CountS.q).
    * if; 2: by auto => /> /#.
      by inline *; wp; call (: true); auto => />; smt(in_fsetU in_fset1).
    by wp; call (: true) => //; auto => /> /#.
  + by proc; call (: true) => //; auto.
  by auto => />; smt(in_fset0).
seq 1 : (TCct.Count.cp <= qXC + 1 /\
         TCct.Count.cg + size St.pend <= qHct + kappa_max * qS + 1).
- inline Act(TCct.Count(T)).S.verify.
  wp; exlim TCct.Count.cg => c1; call (HctE_GB_h T false c1).
  wp; exlim TCct.Count.cp => c0; call (SIB_XCB_h T c0).
  by call (: true) => //; call (: true) => //; auto => /> /#.
inline Flush(GB(TCct.Count(T))).run.
while (TCct.Count.cp <= qXC + 1 /\
       TCct.Count.cg + size St.pend <= qHct + kappa_max * qS + 1).
- sp; if; 2: by auto => />; smt(size_behead).
  by inline *; wp; call (: true); auto => />; smt(size_behead).
by auto => /> /#.
qed.

(* -------------------------------------------------------------------- *)
(* The eager game is G1 up to [coll] *)

(* Monotonicity of [coll] *)
local lemma coll_set pm lm x y :
  x \notin pm => coll pm lm => coll pm.[x <- y] lm.
proof.
rewrite /coll => hx [[x1 x2 [hne [hn heq]]] | [x0 ct i [hx0 hin]]].
- left; exists x1 x2; rewrite !get_setE; smt().
by right; exists x0 ct i; rewrite get_setE; smt().
qed.

local lemma coll_lx pm lm z b : coll pm lm => coll pm lm.[z <- b].
proof.
rewrite /coll => -[h | [x0 ct i [hx0 hin]]]; 1: by left.
by right; exists x0 ct i; rewrite mem_set hin.
qed.

local lemma coll_inj pm lm x1 x2 ct :
  !coll pm lm => pm.[x1] = Some ct => pm.[x2] = Some ct => x1 = x2.
proof.
rewrite /coll => hc h1 h2; case: (x1 = x2) => // hne.
by apply hc; left; exists x1 x2; rewrite h1 h2.
qed.

local lemma coll_nolx pm lm x ct i :
  !coll pm lm => pm.[x] = Some ct => (ct, i) \notin lm.
proof. rewrite /coll => hc h1; apply/negP => hin; apply hc; right; by exists x ct i. qed.

local lemma coll_lxin pm lm x ct i b :
  pm.[x] = Some ct => coll pm lm.[(ct, i) <- b].
proof. by rewrite /coll => h; right; exists x ct i; rewrite mem_set. qed.

local lemma coll_new pm lm x y :
  x \notin pm => !coll pm.[x <- y] lm =>
  !coll pm lm /\ (forall x', pm.[x'] <> Some y) /\ (forall i, (y, i) \notin lm).
proof.
move=> hx hc; split; 1: by apply/negP => h; apply hc; apply coll_set.
split.
- move=> x'; apply/negP => hx'.
  have := coll_inj _ _ x' x y hc; rewrite !get_setE /=; smt().
by move=> i; apply (coll_nolx _ _ x y i hc); rewrite get_set_sameE.
qed.

(* The relation between the XOF of G1 and the XOFs of D, through the
   eagerly sampled [Hct] *)
local op [opaque] rel (xm1 : (ctilde * int, byte) fmap)
             (pm : (high list * mu_t, ctilde) fmap)
             (t : (high list * mu_t, ctilde) fmap)
             (tinv : (ctilde, high list * mu_t) fmap)
             (xm2 : ((high list * mu_t) * int, byte) fmap)
             (lm : (ctilde * int, byte) fmap) =
  (forall x, x \in t => t.[x] = pm.[x]) /\
  (forall ct x, tinv.[ct] = Some x => t.[x] = Some ct) /\
  (forall x ct, t.[x] = Some ct => ct \in tinv) /\
  (forall x ct i, pm.[x] = Some ct => xm1.[(ct, i)] = xm2.[(x, i)]) /\
  (forall ct i, (forall x, pm.[x] <> Some ct) => xm1.[(ct, i)] = lm.[(ct, i)]) /\
  (forall x i, x \notin pm => (x, i) \notin xm2).

(* The relation between G1 (tables [mmu1], [mct1], [xm1]) and D (tables
   [mmu2], [pm], [HctT], [xm2], [lm]) on the state that is not syntactically
   equal (an abbreviation: the tactics see the conjunction) *)
local abbrev relD (mmu1 : (tr_t * M, mu_t) fmap) (mct1 : (high list * mu_t, ctilde) fmap)
  (xm1 : (ctilde * int, byte) fmap) (mmu2 : (tr_t * M, mu_t) fmap)
  (pm : (high list * mu_t, ctilde) fmap) (bad : bool) (t : (high list * mu_t, ctilde) fmap)
  (tinv : (ctilde, high list * mu_t) fmap) (xm2 : ((high list * mu_t) * int, byte) fmap)
  (lm : (ctilde * int, byte) fmap) =
  mmu1 = mmu2 /\ mct1 = pm /\ !bad /\ rel xm1 pm t tinv xm2 lm.

local lemma rel0 : rel empty empty empty empty empty empty.
proof. by rewrite /rel; smt(emptyE mem_empty). qed.

(* A XOF query on an output [c~ = pm.[x]] *)
local lemma rel_xof xm1 pm t tinv xm2 lm x ct i b :
  !coll pm lm => pm.[x] = Some ct => rel xm1 pm t tinv xm2 lm =>
  xm1.[(ct, i)] = xm2.[(x, i)] /\
  (xm1.[(ct, i)] = None =>
   rel xm1.[(ct, i) <- b] pm t tinv xm2.[(x, i) <- b] lm).
proof.
rewrite /rel => hc hx [h1 [h2 [h3 [h4 [h5 h6]]]]].
split; 1: by apply h4.
move=> hn; split => //; split => //; split => //; split.
- move=> x' ct' i' hx'; rewrite !get_setE.
  case: (x' = x) => [->> | hne].
  + have <<- : ct = ct' by move: hx'; rewrite hx.
    by have := h4 x ct i' hx; smt().
  have : ct' <> ct by apply/negP => ->>; apply hne; apply (coll_inj _ _ _ _ _ hc hx' hx).
  by have := h4 x' ct' i' hx'; smt().
split.
- move=> ct' i' hct'; rewrite get_setE.
  have hne : ct' <> ct by apply/negP => ->>; move: (hct' x); rewrite hx.
  by rewrite (: (ct', i') <> (ct, i)) 1:/# /=; apply h5.
move=> x' i' hx'; rewrite mem_set negb_or; split; 1: by apply h6.
by apply/negP => -[] ->> _; move: hx'; rewrite domE hx.
qed.

(* A XOF query on a [c~] which is not an output of [Hct] *)
local lemma rel_lx xm1 pm t tinv xm2 lm ct i b :
  (forall x, pm.[x] <> Some ct) => rel xm1 pm t tinv xm2 lm =>
  xm1.[(ct, i)] = lm.[(ct, i)] /\
  rel xm1.[(ct, i) <- b] pm t tinv xm2 lm.[(ct, i) <- b].
proof.
rewrite /rel => hct [h1 [h2 [h3 [h4 [h5 h6]]]]].
split; 1: by apply h5.
do 3! (split => //); split.
- move=> x' ct' i' hx'; rewrite get_setE.
  have hne : ct' <> ct by apply/negP => ->>; move: (hct x'); rewrite hx'.
  by rewrite (: (ct', i') <> (ct, i)) 1:/# /=; apply h4.
split => // ct' i' hct'; rewrite !get_setE.
by case: ((ct', i') = (ct, i)) => // _; apply h5.
qed.

(* A fresh output [y] of [Hct] for [x] (eager sample) *)
local lemma rel_fresh xm1 pm t tinv xm2 lm x y :
  x \notin pm => !coll pm.[x <- y] lm => rel xm1 pm t tinv xm2 lm =>
  rel xm1 pm.[x <- y] t tinv xm2 lm.
proof.
move=> hx hc; have [hc0 [hy hyl]] := coll_new _ _ _ _ hx hc.
rewrite /rel => -[h1 [h2 [h3 [h4 [h5 h6]]]]].
split.
- move=> x' hx'; rewrite get_setE; case: (x' = x) => [->> | _]; 2: by apply h1.
  by move: (h1 x hx'); rewrite (get_none _ _ hx) => /#.
do 2! (split => //); split.
- move=> x' ct i; rewrite get_setE; case: (x' = x) => [->> /= <<- | _ hx']; 2: by apply h4.
  rewrite h5 // (get_none _ (x, i)) 1:/#.
  by apply/get_none/hyl.
split.
- by move=> ct i hct; apply h5 => x'; move: (hct x'); rewrite get_setE /#.
move=> x' i; rewrite mem_set negb_or => -[hx' _]; exact h6.
qed.

(* [x] (already in [pm]) is added to [t] *)
local lemma rel_reveal xm1 pm t tinv xm2 lm x ct :
  !coll pm lm => x \notin t => pm.[x] = Some ct => rel xm1 pm t tinv xm2 lm =>
  ct \notin tinv /\ rel xm1 pm t.[x <- ct] tinv.[ct <- x] xm2 lm.
proof.
rewrite /rel => hc hxt hx [h1 [h2 [h3 [h4 [h5 h6]]]]].
have hct : ct \notin tinv.
- apply/negP; rewrite domE; case _: (tinv.[ct]) => // x' hx' _.
  have ht := h2 _ _ hx'; have := h1 x'; rewrite domE ht /=; apply/negP => hp.
  have hp' : pm.[x'] = Some ct by rewrite -hp.
  have ->> := coll_inj _ _ _ _ _ hc hp' hx.
  by move: hxt; rewrite domE ht.
split => //; split.
- move=> x'; rewrite mem_set get_setE; case: (x' = x) => [->> | _ /= hx'] /=; 1: by rewrite hx.
  by apply h1.
split.
- move=> ct' x'; rewrite !get_setE; case: (ct' = ct) => [->> /= <<- | hne hx'] /=; 1: done.
  rewrite (h2 _ _ hx'); case: (x' = x) => // ->>.
  by move: hxt; rewrite domE (h2 _ _ hx').
split.
- move=> x' ct'; rewrite get_setE mem_set; case: (x' = x) => [_ /= <- | _ hx'] /=; 1: done.
  by left; exact (h3 _ _ hx').
by do 2! (split => //).
qed.

local lemma rel_tinv xm1 pm t tinv xm2 lm ct x :
  rel xm1 pm t tinv xm2 lm => tinv.[ct] = Some x => pm.[x] = Some ct.
proof.
rewrite /rel => -[h1 [h2 _]] hx; have ht := h2 _ _ hx.
by rewrite -h1 ?domE ht.
qed.

local lemma rel_t xm1 pm t tinv xm2 lm x :
  rel xm1 pm t tinv xm2 lm => x \in t => t.[x] = pm.[x].
proof. by rewrite /rel => -[h1 _]; apply h1. qed.

local lemma E_XC :
  equiv[SIB.XOF.RO.get ~ XCSim(SD.XOF).get :
        !coll PC.RO.m{2} LX.RO.m{2} /\ ={arg} /\
        (={glob XASim, ROtr.RO.m, O_CMA1.sk, O_CMA1.qs} /\
         relD ROmu.RO.m{1} ROct.RO.m{1} SIB.XOF.RO.m{1} HmuB.m{2} PC.RO.m{2} HctT.bad{2}
              HctT.t{2} HctT.tinv{2} SD.DSSXOF.PRO.RO.m{2} LX.RO.m{2}) ==>
        !coll PC.RO.m{2} LX.RO.m{2} =>
        ={res} /\
        (={glob XASim, ROtr.RO.m, O_CMA1.sk, O_CMA1.qs} /\
         relD ROmu.RO.m{1} ROct.RO.m{1} SIB.XOF.RO.m{1} HmuB.m{2} PC.RO.m{2} HctT.bad{2}
              HctT.t{2} HctT.tinv{2} SD.DSSXOF.PRO.RO.m{2} LX.RO.m{2})].
proof.
proc; inline *; sp.
if{2}.
- sp 0 1; wp; rnd; skip => /> &1 &2 hc hbad hrel hin r _.
  have [x0 hx0] : exists x0, HctT.tinv{2}.[y{2}.`1] = Some x0.
  - by move: hin; rewrite domE; case: (HctT.tinv{2}.[y{2}.`1]) => // x0 _; exists x0.
  have hpm := rel_tinv _ _ _ _ _ _ _ _ hrel hx0.
  have [heq hset] := rel_xof _ _ _ _ _ _ x0 y{2}.`1 y{2}.`2 r hc hpm hrel.
  move: heq hset; rewrite -pairS hx0 /= => heq hset.
  rewrite !get_set_sameE /= !domE heq /=.
  by case: (SD.DSSXOF.PRO.RO.m{2}.[x0, y{2}.`2]) heq hset => //= heq hset; apply hset.
sp 0 1; wp; rnd; skip => /> &1 &2 hc hbad hrel hin r _.
case: (exists x, PC.RO.m{2}.[x] = Some y{2}.`1) => [[x hx] | hnx].
- have hn : y{2} \notin LX.RO.m{2} by rewrite (pairS y{2}); apply (coll_nolx _ _ x _ _ hc hx).
  have hcl := coll_lxin PC.RO.m{2} LX.RO.m{2} x y{2}.`1 y{2}.`2 r hx.
  by move: hcl; rewrite -pairS => hcl; rewrite hn /= hcl.
have hnx' : forall x, PC.RO.m{2}.[x] <> Some y{2}.`1.
- by move=> x; apply/negP => h; apply hnx; exists x.
have [heq hrel'] := rel_lx _ _ _ _ _ _ y{2}.`1 y{2}.`2 r hnx' hrel.
move: heq hrel'; rewrite -pairS => heq hrel'.
rewrite !get_set_sameE !domE heq /=.
by case: (LX.RO.m{2}.[y{2}]) => [|b] //=.
qed.

local lemma E_Hct :
  equiv[ROct.RO.get ~ HctE(PC.RO).get :
        !coll PC.RO.m{2} LX.RO.m{2} /\ ={arg} /\
        (={glob XASim, ROtr.RO.m, O_CMA1.sk, O_CMA1.qs} /\
         relD ROmu.RO.m{1} ROct.RO.m{1} SIB.XOF.RO.m{1} HmuB.m{2} PC.RO.m{2} HctT.bad{2}
              HctT.t{2} HctT.tinv{2} SD.DSSXOF.PRO.RO.m{2} LX.RO.m{2}) ==>
        !coll PC.RO.m{2} LX.RO.m{2} => ={res} /\
        (={glob XASim, ROtr.RO.m, O_CMA1.sk, O_CMA1.qs} /\
         relD ROmu.RO.m{1} ROct.RO.m{1} SIB.XOF.RO.m{1} HmuB.m{2} PC.RO.m{2} HctT.bad{2}
              HctT.t{2} HctT.tinv{2} SD.DSSXOF.PRO.RO.m{2} LX.RO.m{2})].
proof.
proc; inline *.
if{2}; last first.
- rcondf{1} 2; 1: by auto => /> &hr _ _ hrel hx; rewrite domE -(rel_t _ _ _ _ _ _ _ hrel hx) -domE.
  rnd{1}; skip => /> &1 &2 hc hbad hrel hx _ _.
  by rewrite (rel_t _ _ _ _ _ _ _ hrel hx).
sp 0 1; wp; rnd; skip => /> &1 &2 hc hbad hrel hxt r _.
rewrite !get_set_sameE /=.
case: (x{2} \in PC.RO.m{2}) => hxp /=.
- have [ct hct] : exists ct, PC.RO.m{2}.[x{2}] = Some ct.
  + by move: hxp; rewrite domE; case: (PC.RO.m{2}.[x{2}]) => // ct _; exists ct.
  have [hnt hrel'] := rel_reveal _ _ _ _ _ _ _ _ hc hxt hct hrel.
  rewrite hct /= hnt /=.
  split => //; apply/negP => -[i hi]; move: hi; apply (coll_nolx _ _ _ _ i hc hct).
case: (coll PC.RO.m{2}.[x{2} <- r] LX.RO.m{2}) => [// | hc'] /=.
have hrel1 := rel_fresh _ _ _ _ _ _ _ r hxp hc' hrel.
have [hnt hrel'] := rel_reveal _ _ _ _ _ _ x{2} r hc' hxt _ hrel1; 1: by rewrite get_set_sameE.
rewrite hnt /=; split => //; apply/negP => -[i hi]; move: hi.
by apply (coll_nolx _ _ x{2} _ i hc'); rewrite get_set_sameE.
qed.

(* Losslessness of the oracles of G1, preservation of [coll] by the
   oracles of D *)
local lemma ROct_get_ll : islossless ROct.RO.get by islossless.

local lemma ROmu_get_ll : islossless ROmu.RO.get by islossless.

local lemma ROtr_get_ll : islossless ROtr.RO.get by islossless.

(* Termination of the signing procedure *)
local lemma MLDSAGen_ll (MG <: MatGen) (CG <: ChalGen) (Hmu <: Hash_mu) :
  islossless MG.get => islossless CG.get => islossless CG.final =>
  islossless Hmu.get => islossless MLDSAGen(MG, CG, Hmu).sign.
proof.
move=> MG_ll get_ll final_ll Hmu_ll; proc.
seq 11 : true => //.
- while true (kappa_max - ctr).
  + move=> z; wp; if; 2: by auto => /> /#.
    wp; call get_ll; auto => /> &hr _; split; 2: smt().
    by apply dvector_ll; exact dRq_mask_ll.
  by wp; call Hmu_ll; call MG_ll; auto => /> /#.
by if; [call final_ll | ].
qed.

local lemma ChalH_ll : islossless ChalH(SIB.XOF.RO, ROct.RO).get.
proof. by proc; call SIB_ll; call ROct_get_ll. qed.

local lemma Sign1_ll : islossless MLDSAGen(MatRA, ChalH(SIB.XOF.RO, ROct.RO), ROmu.RO).sign.
proof.
apply (MLDSAGen_ll MatRA (ChalH(SIB.XOF.RO, ROct.RO)) ROmu.RO).
- by proc; auto.
- exact ChalH_ll.
- by proc; auto.
exact ROmu_get_ll.
qed.

local lemma PC_sample_coll :
  phoare[PC.RO.sample : coll PC.RO.m LX.RO.m ==> coll PC.RO.m LX.RO.m] = 1%r.
proof.
proc; inline *; auto => /> &hr hc; split; 1: exact dct_ll.
by move=> _ r _ _ hx; apply coll_set.
qed.

local lemma HctE_coll :
  phoare[HctE(PC.RO).get : coll PC.RO.m LX.RO.m ==> coll PC.RO.m LX.RO.m] = 1%r.
proof.
proc; inline *; sp; if; 2: by auto.
auto => /> &hr hc _; split; 1: exact dct_ll.
by move=> _ r _ _ hx; apply coll_set.
qed.

local lemma XC_coll_h :
  hoare[XCSim(SD.XOF).get : coll PC.RO.m LX.RO.m ==> coll PC.RO.m LX.RO.m].
proof. by proc; inline *; sp; if; auto => />; smt(coll_lx). qed.

local lemma XC_coll :
  phoare[XCSim(SD.XOF).get : coll PC.RO.m LX.RO.m ==> coll PC.RO.m LX.RO.m] = 1%r.
proof.
conseq (: true ==> true) XC_coll_h => //.
by proc; inline *; if; auto; smt(dB_ll).
qed.

local lemma SDSIB_coll :
  phoare[SD.SIB.SampleInBall(SD.XOF).get :
         coll PC.RO.m LX.RO.m ==> coll PC.RO.m LX.RO.m] = 1%r.
proof.
conseq SDSIB_ll (: coll PC.RO.m LX.RO.m ==> coll PC.RO.m LX.RO.m) => //.
proc; while (coll PC.RO.m LX.RO.m).
- by wp; while (coll PC.RO.m LX.RO.m); [wp; call (: true) => //; auto | auto].
by wp; while (coll PC.RO.m LX.RO.m); [wp; call (: true) => //; auto | auto].
qed.

local lemma HctE_ll : islossless HctE(PC.RO).get.
proof. by proc; inline *; sp; if; auto => />; smt(dct_ll). qed.

local lemma ChalE_ll : islossless ChalE(PC.RO).get.
proof. by proc; call SDSIB_ll; inline *; auto => />; exact dct_ll. qed.

local lemma ChalE_final_ll : islossless ChalE(PC.RO).final.
proof. by proc; call HctE_ll; auto. qed.

local lemma SignD_ll : islossless MLDSAGen(MatRA, ChalE(PC.RO), HmuB).sign.
proof.
apply (MLDSAGen_ll MatRA (ChalE(PC.RO)) HmuB).
- by proc; auto.
- exact ChalE_ll.
- exact ChalE_final_ll.
by proc; sp; if; auto => />; smt(dmu_ll).
qed.

local lemma ChalE_coll :
  phoare[ChalE(PC.RO).get : coll PC.RO.m LX.RO.m ==> coll PC.RO.m LX.RO.m] = 1%r.
proof. by proc; call SDSIB_coll; wp; call PC_sample_coll; auto. qed.

local lemma SignD_coll_h :
  hoare[MLDSAGen(MatRA, ChalE(PC.RO), HmuB).sign :
        coll PC.RO.m LX.RO.m ==> coll PC.RO.m LX.RO.m].
proof.
proc; seq 11 : (coll PC.RO.m LX.RO.m).
- wp; while (coll PC.RO.m LX.RO.m).
  + wp; if; 2: by auto.
    inline ChalE(PC.RO).get; wp; call (: true) => //.
    by inline *; auto => />; smt(coll_set).
  by inline MatRA.get; wp; call (: true) => //; auto.
if; 2: by auto.
by inline *; sp; if; auto => />; smt(coll_set).
qed.

local lemma SignD_coll :
  phoare[MLDSAGen(MatRA, ChalE(PC.RO), HmuB).sign :
         coll PC.RO.m LX.RO.m ==> coll PC.RO.m LX.RO.m] = 1%r.
proof. by conseq SignD_ll SignD_coll_h. qed.

(* The challenge of the signing loop: [SampleInBall] on [c~ = Hct(w1, mu)]
   in G1, on [(w1, mu)] in D *)
local lemma E_XOF :
  equiv[SIB.XOF.RO.get ~ SD.XOF.get :
        x{1}.`2 = x{2}.`2 /\ PC.RO.m{2}.[x{2}.`1] = Some x{1}.`1 /\
        !coll PC.RO.m{2} LX.RO.m{2} /\
        rel SIB.XOF.RO.m{1} PC.RO.m{2} HctT.t{2} HctT.tinv{2} SD.DSSXOF.PRO.RO.m{2}
            LX.RO.m{2} ==>
        ={res} /\
        rel SIB.XOF.RO.m{1} PC.RO.m{2} HctT.t{2} HctT.tinv{2} SD.DSSXOF.PRO.RO.m{2}
            LX.RO.m{2}].
proof.
proc; auto => /> &1 &2 hi hx hc hrel r _.
have [heq hset] := rel_xof _ _ _ _ _ _ x{2}.`1 x{1}.`1 x{1}.`2 r hc hx hrel.
move: heq hset; rewrite -pairS hi -pairS => heq hset.
rewrite !get_set_sameE /= !domE heq /=.
by case: (SD.DSSXOF.PRO.RO.m{2}.[x{2}]) heq hset => //= heq hset; apply hset.
qed.

local lemma SB_eq :
  equiv[SIB.SampleInBall(SIB.XOF.RO).get ~ SD.SIB.SampleInBall(SD.XOF).get :
        PC.RO.m{2}.[x{2}] = Some x{1} /\ !coll PC.RO.m{2} LX.RO.m{2} /\
        rel SIB.XOF.RO.m{1} PC.RO.m{2} HctT.t{2} HctT.tinv{2} SD.DSSXOF.PRO.RO.m{2}
            LX.RO.m{2} ==>
        ={res} /\
        rel SIB.XOF.RO.m{1} PC.RO.m{2} HctT.t{2} HctT.tinv{2} SD.DSSXOF.PRO.RO.m{2}
            LX.RO.m{2}].
proof.
proc.
while (={i, ctx, signs, challenge, leak, byte} /\ PC.RO.m{2}.[x{2}] = Some x{1} /\
       !coll PC.RO.m{2} LX.RO.m{2} /\
       rel SIB.XOF.RO.m{1} PC.RO.m{2} HctT.t{2} HctT.tinv{2} SD.DSSXOF.PRO.RO.m{2}
           LX.RO.m{2}).
- wp; while (={i, j, ctx, signs, challenge, leak, byte} /\ PC.RO.m{2}.[x{2}] = Some x{1} /\
             !coll PC.RO.m{2} LX.RO.m{2} /\
             rel SIB.XOF.RO.m{1} PC.RO.m{2} HctT.t{2} HctT.tinv{2} SD.DSSXOF.PRO.RO.m{2}
                 LX.RO.m{2}).
  + by wp; call E_XOF; auto.
  by auto.
wp; while (={ctx, signs, byte} /\ PC.RO.m{2}.[x{2}] = Some x{1} /\
           !coll PC.RO.m{2} LX.RO.m{2} /\
           rel SIB.XOF.RO.m{1} PC.RO.m{2} HctT.t{2} HctT.tinv{2} SD.DSSXOF.PRO.RO.m{2}
               LX.RO.m{2}).
- by wp; call E_XOF; auto.
by auto.
qed.

local lemma HctE_rev xm1v pm0 ct0 xa :
  phoare[HctE(PC.RO).get :
         x = xa /\ PC.RO.m = pm0 /\ pm0.[xa] = Some ct0 /\ !coll pm0 LX.RO.m /\
         !HctT.bad /\ rel xm1v pm0 HctT.t HctT.tinv SD.DSSXOF.PRO.RO.m LX.RO.m ==>
         res = ct0 /\ PC.RO.m = pm0 /\ !HctT.bad /\
         rel xm1v pm0 HctT.t HctT.tinv SD.DSSXOF.PRO.RO.m LX.RO.m] = 1%r.
proof.
proc; inline *; sp; if.
- rcondf 3; 1: by auto => /> &hr hx _ _ _ _; rewrite domE hx.
  auto => /> &hr hx hc hbad hrel hxt; split; 1: exact dct_ll.
  move=> _ r _; have [hnt hrel'] := rel_reveal _ _ _ _ _ _ _ _ hc hxt hx hrel.
  rewrite hx /= hnt /= get_set_sameE /=; split => //.
  by apply/negP => -[i hi]; move: hi; apply (coll_nolx _ _ _ _ i hc hx).
by auto => /> &hr hx hc hbad hrel hxt; rewrite (rel_t _ _ _ _ _ _ _ hrel hxt) hx.
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

(* The challenge of an iteration, up to [coll]: in G1 it is [SampleInBall]
   on [c~ = Hct(w1, mu)], in D it is [SampleInBall] on [(w1, mu)], and
   [Hct(w1, mu)] is sampled (eagerly) by [G.sample] *)
local lemma Chal_G1_D x0 :
  equiv[ChalH(SIB.XOF.RO, ROct.RO).get ~ ChalE(PC.RO).get :
        ={w1, mu} /\ (w1, mu){2} = x0 /\ !coll PC.RO.m{2} LX.RO.m{2} /\
        (={glob XASim, ROtr.RO.m, O_CMA1.sk, O_CMA1.qs} /\
         relD ROmu.RO.m{1} ROct.RO.m{1} SIB.XOF.RO.m{1} HmuB.m{2} PC.RO.m{2} HctT.bad{2}
              HctT.t{2} HctT.tinv{2} SD.DSSXOF.PRO.RO.m{2} LX.RO.m{2}) ==>
        !coll PC.RO.m{2} LX.RO.m{2} =>
        res{1}.`2 = res{2}.`2 /\ res{1}.`3 = res{2}.`3 /\
        PC.RO.m{2}.[x0] = Some res{1}.`1 /\
        (={glob XASim, ROtr.RO.m, O_CMA1.sk, O_CMA1.qs} /\
         relD ROmu.RO.m{1} ROct.RO.m{1} SIB.XOF.RO.m{1} HmuB.m{2} PC.RO.m{2} HctT.bad{2}
              HctT.t{2} HctT.tinv{2} SD.DSSXOF.PRO.RO.m{2} LX.RO.m{2})].
proof.
proc.
seq 1 2 : (={w1, mu} /\ (w1, mu){2} = x0 /\
           (!coll PC.RO.m{2} LX.RO.m{2} =>
            (={glob XASim, ROtr.RO.m, O_CMA1.sk, O_CMA1.qs} /\
             relD ROmu.RO.m{1} ROct.RO.m{1} SIB.XOF.RO.m{1} HmuB.m{2} PC.RO.m{2} HctT.bad{2}
                  HctT.t{2} HctT.tinv{2} SD.DSSXOF.PRO.RO.m{2} LX.RO.m{2}) /\
            PC.RO.m{2}.[(w1{2}, mu{2})] = Some ct{1})).
- inline ROct.RO.get PC.RO.sample PC.RO.get; auto => />.
  move=> &1 &2 hc hbad hrel r _; split => hx.
  + by move=> hc'; rewrite get_set_sameE /=; apply (rel_fresh _ _ _ _ _ _ _ _ hx hc' hrel).
  by move: hx; rewrite domE; case: (PC.RO.m{2}.[w1{2}, mu{2}]).
case (coll PC.RO.m{2} LX.RO.m{2}).
- conseq (: coll PC.RO.m{2} LX.RO.m{2} ==> coll PC.RO.m{2} LX.RO.m{2}) => //.
  by wp; call{2} SDSIB_coll; call{1} SIB_ll; auto.
by wp; call SB_eq; auto => /> /#.
qed.

(* The signing procedures of G1 and D, up to [coll] (they run in
   lockstep: [MLDSAGen] has a guard on the counter only) *)
local lemma Sign_G1_D :
  equiv[MLDSAGen(MatRA, ChalH(SIB.XOF.RO, ROct.RO), ROmu.RO).sign ~
        MLDSAGen(MatRA, ChalE(PC.RO), HmuB).sign :
        !coll PC.RO.m{2} LX.RO.m{2} /\ ={sk, m} /\
        (={glob XASim, ROtr.RO.m, O_CMA1.sk, O_CMA1.qs} /\
         relD ROmu.RO.m{1} ROct.RO.m{1} SIB.XOF.RO.m{1} HmuB.m{2} PC.RO.m{2} HctT.bad{2}
              HctT.t{2} HctT.tinv{2} SD.DSSXOF.PRO.RO.m{2} LX.RO.m{2}) ==>
        !coll PC.RO.m{2} LX.RO.m{2} => ={res} /\
        (={glob XASim, ROtr.RO.m, O_CMA1.sk, O_CMA1.qs} /\
         relD ROmu.RO.m{1} ROct.RO.m{1} SIB.XOF.RO.m{1} HmuB.m{2} PC.RO.m{2} HctT.bad{2}
              HctT.t{2} HctT.tinv{2} SD.DSSXOF.PRO.RO.m{2} LX.RO.m{2})].
proof.
proc; inline MatRA.get.
seq 11 11 : (!coll PC.RO.m{2} LX.RO.m{2} /\ ={mA, s1, s2, t0, mu, leak, response, ctr} /\
             response{1} = None /\
             (={glob XASim, ROtr.RO.m, O_CMA1.sk, O_CMA1.qs} /\
              relD ROmu.RO.m{1} ROct.RO.m{1} SIB.XOF.RO.m{1} HmuB.m{2} PC.RO.m{2} HctT.bad{2}
                   HctT.t{2} HctT.tinv{2} SD.DSSXOF.PRO.RO.m{2} LX.RO.m{2})).
- by wp; call Hmu_eq; auto.
seq 1 1 : (={ctr, mA, s1, s2, t0, mu} /\
           (!coll PC.RO.m{2} LX.RO.m{2} =>
            ={response, leak} /\
            (={glob XASim, ROtr.RO.m, O_CMA1.sk, O_CMA1.qs} /\
             relD ROmu.RO.m{1} ROct.RO.m{1} SIB.XOF.RO.m{1} HmuB.m{2} PC.RO.m{2} HctT.bad{2}
                  HctT.t{2} HctT.tinv{2} SD.DSSXOF.PRO.RO.m{2} LX.RO.m{2}) /\
            (response{1} <> None => PC.RO.m{2}.[(w1{2}, mu{2})] = Some ct{1}))).
- while (={ctr, mA, s1, s2, t0, mu} /\
         (!coll PC.RO.m{2} LX.RO.m{2} =>
          ={response, leak} /\
          (={glob XASim, ROtr.RO.m, O_CMA1.sk, O_CMA1.qs} /\
           relD ROmu.RO.m{1} ROct.RO.m{1} SIB.XOF.RO.m{1} HmuB.m{2} PC.RO.m{2} HctT.bad{2}
                HctT.t{2} HctT.tinv{2} SD.DSSXOF.PRO.RO.m{2} LX.RO.m{2}) /\
          (response{1} <> None => PC.RO.m{2}.[(w1{2}, mu{2})] = Some ct{1}))).
  + wp; case (coll PC.RO.m{2} LX.RO.m{2}).
    * conseq (: coll PC.RO.m{2} LX.RO.m{2} /\ ={ctr, mA, s1, s2, t0, mu} ==>
                coll PC.RO.m{2} LX.RO.m{2} /\ ={ctr, mA, s1, s2, t0, mu}).
      - smt().
      - by move=> /> &1 &2 *; smt().
      seq 1 0 : (coll PC.RO.m{2} LX.RO.m{2} /\ ={ctr, mA, s1, s2, t0, mu}).
      - if{1}; 2: by auto.
        wp; call{1} ChalH_ll; auto => />.
        by move=> *; apply dvector_ll; exact dRq_mask_ll.
      if{2}; 2: by auto.
      wp; call{2} ChalE_coll; auto => />.
      by move=> *; apply dvector_ll; exact dRq_mask_ll.
    if; 1: smt(); last by skip => />; smt().
    seq 3 3 : (={y, w, w1, ctr, mA, s1, s2, t0, mu, response, leak} /\ response{1} = None /\
               !coll PC.RO.m{2} LX.RO.m{2} /\
               (={glob XASim, ROtr.RO.m, O_CMA1.sk, O_CMA1.qs} /\
                relD ROmu.RO.m{1} ROct.RO.m{1} SIB.XOF.RO.m{1} HmuB.m{2} PC.RO.m{2} HctT.bad{2}
                     HctT.t{2} HctT.tinv{2} SD.DSSXOF.PRO.RO.m{2} LX.RO.m{2})).
    * by auto => /> /#.
    seq 1 1 : (={y, w, w1, ctr, mA, s1, s2, t0, mu, response, leak} /\ response{1} = None /\
               (!coll PC.RO.m{2} LX.RO.m{2} =>
                ={c, lc} /\ PC.RO.m{2}.[(w1{2}, mu{2})] = Some ct{1} /\
                (={glob XASim, ROtr.RO.m, O_CMA1.sk, O_CMA1.qs} /\
                 relD ROmu.RO.m{1} ROct.RO.m{1} SIB.XOF.RO.m{1} HmuB.m{2} PC.RO.m{2} HctT.bad{2}
                      HctT.t{2} HctT.tinv{2} SD.DSSXOF.PRO.RO.m{2} LX.RO.m{2}))).
    * by exlim (w1, mu){2} => x0; call (Chal_G1_D x0); auto => /> /#.
    case (coll PC.RO.m{2} LX.RO.m{2}).
    * conseq (: coll PC.RO.m{2} LX.RO.m{2} /\ ={ctr, mA, s1, s2, t0, mu} ==>
                coll PC.RO.m{2} LX.RO.m{2} /\ ={ctr, mA, s1, s2, t0, mu}); 1,2: smt().
      by auto.
    by auto => /> /#.
  by skip => />.
case (coll PC.RO.m{2} LX.RO.m{2}).
- conseq (: coll PC.RO.m{2} LX.RO.m{2} ==> coll PC.RO.m{2} LX.RO.m{2}) => //.
  seq 1 0 : (coll PC.RO.m{2} LX.RO.m{2}); 1: by if{1}; [inline *; auto | auto].
  seq 0 1 : (coll PC.RO.m{2} LX.RO.m{2}); 2: by auto.
  by if{2}; [inline ChalE(PC.RO).final; wp; call{2} HctE_coll; auto | auto].
if; 1: smt().
- inline ChalH(SIB.XOF.RO, ROct.RO).final ChalE(PC.RO).final.
  exlim SIB.XOF.RO.m{1}, PC.RO.m{2}, ct{1}, w1{2}, mu{2} => xm1v pm0 ct0 w10 mu0.
  wp; call{2} (HctE_rev xm1v pm0 ct0 (w10, mu0)).
  by auto => /> /#.
by auto => /> /#.
qed.

(* The verification of the forgery *)
local lemma coll_lx_safe pm lm ct i b :
  (forall x, pm.[x] <> Some ct) => !coll pm lm => !coll pm lm.[(ct, i) <- b].
proof.
rewrite /coll => hct hc; apply/negP => -[h | [x0 ct' i' [hx0 hin]]]; 1: by apply hc; left.
move: hin; rewrite mem_set => -[hin | [] <<- _]; 1: by apply hc; right; exists x0 ct' i'.
by move: (hct x0); rewrite hx0.
qed.

local lemma coll_of_in pm lm x ct i : pm.[x] = Some ct => (ct, i) \in lm => coll pm lm.
proof. by rewrite /coll => hx hin; right; exists x ct i. qed.

local lemma XC_safe_h :
  hoare[XCSim(SD.XOF).get :
        (y.`1 \in HctT.tinv \/ forall x, PC.RO.m.[x] <> Some y.`1) /\ !coll PC.RO.m LX.RO.m ==>
        !coll PC.RO.m LX.RO.m].
proof.
proc; inline *; sp; if; 1: by auto.
auto => /> &hr hs hc hnt r _ hy.
have hs' : forall x, PC.RO.m{hr}.[x] <> Some y{hr}.`1 by case: hs.
by rewrite (pairS y{hr}); apply coll_lx_safe.
qed.

local lemma E_XC_safe :
  equiv[SIB.XOF.RO.get ~ XCSim(SD.XOF).get :
        ={arg} /\ (y{2}.`1 \in HctT.tinv{2} \/ forall x', PC.RO.m{2}.[x'] <> Some y{2}.`1) /\
        !coll PC.RO.m{2} LX.RO.m{2} /\
        (={glob XASim, ROtr.RO.m, O_CMA1.sk, O_CMA1.qs} /\
         relD ROmu.RO.m{1} ROct.RO.m{1} SIB.XOF.RO.m{1} HmuB.m{2} PC.RO.m{2} HctT.bad{2}
              HctT.t{2} HctT.tinv{2} SD.DSSXOF.PRO.RO.m{2} LX.RO.m{2}) ==>
        ={res} /\ !coll PC.RO.m{2} LX.RO.m{2} /\
        (={glob XASim, ROtr.RO.m, O_CMA1.sk, O_CMA1.qs} /\
         relD ROmu.RO.m{1} ROct.RO.m{1} SIB.XOF.RO.m{1} HmuB.m{2} PC.RO.m{2} HctT.bad{2}
              HctT.t{2} HctT.tinv{2} SD.DSSXOF.PRO.RO.m{2} LX.RO.m{2})].
proof.
by conseq E_XC _ XC_safe_h => /> /#.
qed.

local lemma SBX_eq :
  equiv[SIB.SampleInBall(SIB.XOF.RO).get ~ SIB.SampleInBall(XCSim(SD.XOF)).get :
        ={x} /\ (x{2} \in HctT.tinv{2} \/ forall x', PC.RO.m{2}.[x'] <> Some x{2}) /\
        !coll PC.RO.m{2} LX.RO.m{2} /\
        (={glob XASim, ROtr.RO.m, O_CMA1.sk, O_CMA1.qs} /\
         relD ROmu.RO.m{1} ROct.RO.m{1} SIB.XOF.RO.m{1} HmuB.m{2} PC.RO.m{2} HctT.bad{2}
              HctT.t{2} HctT.tinv{2} SD.DSSXOF.PRO.RO.m{2} LX.RO.m{2}) ==>
        ={res} /\ !coll PC.RO.m{2} LX.RO.m{2} /\
        (={glob XASim, ROtr.RO.m, O_CMA1.sk, O_CMA1.qs} /\
         relD ROmu.RO.m{1} ROct.RO.m{1} SIB.XOF.RO.m{1} HmuB.m{2} PC.RO.m{2} HctT.bad{2}
              HctT.t{2} HctT.tinv{2} SD.DSSXOF.PRO.RO.m{2} LX.RO.m{2})].
proof.
proc.
while (={i, ctx, signs, challenge, leak, x, byte} /\
       (x{2} \in HctT.tinv{2} \/ forall x', PC.RO.m{2}.[x'] <> Some x{2}) /\
       !coll PC.RO.m{2} LX.RO.m{2} /\
       (={glob XASim, ROtr.RO.m, O_CMA1.sk, O_CMA1.qs} /\
        relD ROmu.RO.m{1} ROct.RO.m{1} SIB.XOF.RO.m{1} HmuB.m{2} PC.RO.m{2} HctT.bad{2}
             HctT.t{2} HctT.tinv{2} SD.DSSXOF.PRO.RO.m{2} LX.RO.m{2})).
- wp; while (={i, j, ctx, signs, challenge, leak, x, byte} /\
             (x{2} \in HctT.tinv{2} \/ forall x', PC.RO.m{2}.[x'] <> Some x{2}) /\
             !coll PC.RO.m{2} LX.RO.m{2} /\
             (={glob XASim, ROtr.RO.m, O_CMA1.sk, O_CMA1.qs} /\
              relD ROmu.RO.m{1} ROct.RO.m{1} SIB.XOF.RO.m{1} HmuB.m{2} PC.RO.m{2} HctT.bad{2}
                   HctT.t{2} HctT.tinv{2} SD.DSSXOF.PRO.RO.m{2} LX.RO.m{2})).
  + by wp; call E_XC_safe; auto => /> /#.
  by auto.
wp; while (={ctx, signs, x, byte} /\
           (x{2} \in HctT.tinv{2} \/ forall x', PC.RO.m{2}.[x'] <> Some x{2}) /\
           !coll PC.RO.m{2} LX.RO.m{2} /\
           (={glob XASim, ROtr.RO.m, O_CMA1.sk, O_CMA1.qs} /\
            relD ROmu.RO.m{1} ROct.RO.m{1} SIB.XOF.RO.m{1} HmuB.m{2} PC.RO.m{2} HctT.bad{2}
                 HctT.t{2} HctT.tinv{2} SD.DSSXOF.PRO.RO.m{2} LX.RO.m{2})).
- by wp; call E_XC_safe; auto => /> /#.
by auto.
qed.

local lemma SIBX_pend_h :
  hoare[SIB.SampleInBall(XCSim(SD.XOF)).get :
        x \notin HctT.tinv /\ (exists x', PC.RO.m.[x'] = Some x) ==> coll PC.RO.m LX.RO.m].
proof.
proc.
while (x \notin HctT.tinv /\ (exists x', PC.RO.m.[x'] = Some x) /\ 0 < ctx /\
       coll PC.RO.m LX.RO.m).
- wp; while (x \notin HctT.tinv /\ (exists x', PC.RO.m.[x'] = Some x) /\ 0 < ctx /\
             coll PC.RO.m LX.RO.m).
  + inline *; sp; rcondf 1; 1: by auto.
    by auto => /> &hr *; smt(coll_lx).
  by auto => />.
wp; while (x \notin HctT.tinv /\ (exists x', PC.RO.m.[x'] = Some x) /\
           (0 < ctx => coll PC.RO.m LX.RO.m) /\ 0 <= ctx).
- inline *; sp; rcondf 1; 1: by auto.
  by auto => /> &hr *; smt(coll_of_in mem_set).
by auto => />; smt().
qed.

local lemma SIBX_pend :
  phoare[SIB.SampleInBall(XCSim(SD.XOF)).get :
         x \notin HctT.tinv /\ (exists x', PC.RO.m.[x'] = Some x) ==>
         coll PC.RO.m LX.RO.m] = 1%r.
proof. by conseq SIBX_ll SIBX_pend_h. qed.

local lemma SIBX_coll :
  phoare[SIB.SampleInBall(XCSim(SD.XOF)).get :
         coll PC.RO.m LX.RO.m ==> coll PC.RO.m LX.RO.m] = 1%r.
proof.
conseq SIBX_ll (: coll PC.RO.m LX.RO.m ==> coll PC.RO.m LX.RO.m) => //.
proc; while (coll PC.RO.m LX.RO.m).
- by wp; while (coll PC.RO.m LX.RO.m); [wp; call XC_coll_h; auto | auto].
by wp; while (coll PC.RO.m LX.RO.m); [wp; call XC_coll_h; auto | auto].
qed.

local lemma HmuB_coll :
  phoare[HmuB.get : coll PC.RO.m LX.RO.m ==> coll PC.RO.m LX.RO.m] = 1%r.
proof. by proc; sp; if; auto => />; smt(dmu_ll). qed.

local lemma ROtr_coll :
  phoare[ROtr.RO.get : coll PC.RO.m LX.RO.m ==> coll PC.RO.m LX.RO.m] = 1%r.
proof. by proc; auto => />; smt(dtr_ll). qed.

local lemma Verify1_ll :
  islossless MLDSA1(SIB.XOF.RO, ROtr.RO, ROmu.RO, ROct.RO).verify.
proof.
by proc; call ROct_get_ll; wp; call SIB_ll; call ROmu_get_ll; call ROtr_get_ll; auto.
qed.

local lemma VerifyD_coll :
  phoare[MLDSA1(XCSim(SD.XOF), ROtr.RO, HmuB, HctE(PC.RO)).verify :
         coll PC.RO.m LX.RO.m ==> coll PC.RO.m LX.RO.m] = 1%r.
proof.
by proc; call HctE_coll; wp; call SIBX_coll; call HmuB_coll; call ROtr_coll; auto.
qed.

local lemma Verify_G1_D :
  equiv[MLDSA1(SIB.XOF.RO, ROtr.RO, ROmu.RO, ROct.RO).verify ~
        MLDSA1(XCSim(SD.XOF), ROtr.RO, HmuB, HctE(PC.RO)).verify :
        !coll PC.RO.m{2} LX.RO.m{2} /\ ={arg} /\
        (={glob XASim, ROtr.RO.m, O_CMA1.sk, O_CMA1.qs} /\
         relD ROmu.RO.m{1} ROct.RO.m{1} SIB.XOF.RO.m{1} HmuB.m{2} PC.RO.m{2} HctT.bad{2}
              HctT.t{2} HctT.tinv{2} SD.DSSXOF.PRO.RO.m{2} LX.RO.m{2}) ==>
        !coll PC.RO.m{2} LX.RO.m{2} => ={res} /\
        (={glob XASim, ROtr.RO.m, O_CMA1.sk, O_CMA1.qs} /\
         relD ROmu.RO.m{1} ROct.RO.m{1} SIB.XOF.RO.m{1} HmuB.m{2} PC.RO.m{2} HctT.bad{2}
              HctT.t{2} HctT.tinv{2} SD.DSSXOF.PRO.RO.m{2} LX.RO.m{2})].
proof.
proc.
seq 5 5 : (!coll PC.RO.m{2} LX.RO.m{2} /\
           ={pk, m, sig, mA, rho, t1, ct, response, z, h, tr, mu} /\
           (={glob XASim, ROtr.RO.m, O_CMA1.sk, O_CMA1.qs} /\
            relD ROmu.RO.m{1} ROct.RO.m{1} SIB.XOF.RO.m{1} HmuB.m{2} PC.RO.m{2} HctT.bad{2}
                 HctT.t{2} HctT.tinv{2} SD.DSSXOF.PRO.RO.m{2} LX.RO.m{2})).
- call Hmu_eq; call (: ={ROtr.RO.m}); 1: by sim.
  by auto => />.
case ((exists x', PC.RO.m{2}.[x'] = Some ct{2}) /\ ct{2} \notin HctT.tinv{2}).
- seq 1 1 : (coll PC.RO.m{2} LX.RO.m{2}).
  + by call{1} SIB_ll; call{2} SIBX_pend; auto => /> /#.
  by wp; call{1} ROct_get_ll; call{2} HctE_coll; auto.
seq 1 1 : (!coll PC.RO.m{2} LX.RO.m{2} /\
           ={pk, m, sig, mA, rho, t1, ct, response, z, h, tr, mu, c, lc} /\
           (={glob XASim, ROtr.RO.m, O_CMA1.sk, O_CMA1.qs} /\
            relD ROmu.RO.m{1} ROct.RO.m{1} SIB.XOF.RO.m{1} HmuB.m{2} PC.RO.m{2} HctT.bad{2}
                 HctT.t{2} HctT.tinv{2} SD.DSSXOF.PRO.RO.m{2} LX.RO.m{2})).
- by call SBX_eq; auto => /> /#.
by wp; call E_Hct; auto => /> /#.
qed.

(* The final flush *)
local lemma Flush_P w :
  phoare[Flush(PC.RO).run :
         coll PC.RO.m LX.RO.m \/ (St.win = w /\ !HctT.bad) ==>
         coll PC.RO.m LX.RO.m \/ (St.win = w /\ !HctT.bad)] = 1%r.
proof.
conseq (Flush_ll PC.RO PC_get_ll) (: coll PC.RO.m LX.RO.m \/ (St.win = w /\ !HctT.bad) ==>
                      coll PC.RO.m LX.RO.m \/ (St.win = w /\ !HctT.bad)) => //.
proc; while (coll PC.RO.m LX.RO.m \/ (St.win = w /\ !HctT.bad)); 2: by auto.
sp; if; 2: by auto.
by inline *; auto => />; smt(coll_set).
qed.

local lemma G1_D_eq :
  equiv[G1(A).main ~ D(PC.RO).distinguish :
        ={glob A} ==> !coll PC.RO.m{2} LX.RO.m{2} => res{1} = St.win{2} /\ !HctT.bad{2}].
proof.
proc.
seq 14 18 : (!coll PC.RO.m{2} LX.RO.m{2} =>
             (nrqs <= qS /\ is_valid /\ is_fresh){1} = St.win{2} /\ !HctT.bad{2}).
- seq 11 14 : (={pk, sk} /\ (!coll PC.RO.m{2} LX.RO.m{2} => ={m, sig} /\
(={glob XASim, ROtr.RO.m, O_CMA1.sk, O_CMA1.qs} /\
 relD ROmu.RO.m{1} ROct.RO.m{1} SIB.XOF.RO.m{1} HmuB.m{2} PC.RO.m{2} HctT.bad{2}
      HctT.t{2} HctT.tinv{2} SD.DSSXOF.PRO.RO.m{2} LX.RO.m{2}))).
  + call (: coll PC.RO.m LX.RO.m,
  (={glob XASim, ROtr.RO.m, O_CMA1.sk, O_CMA1.qs} /\
   relD ROmu.RO.m{1} ROct.RO.m{1} SIB.XOF.RO.m{1} HmuB.m{2} PC.RO.m{2} HctT.bad{2}
        HctT.t{2} HctT.tinv{2} SD.DSSXOF.PRO.RO.m{2} LX.RO.m{2})).
    * move=> XA XC Htr Hmu Hct O h1 h2 h3 h4 h5 h6.
      exact (A_ll XA XC Htr Hmu Hct O h6 h5 h4 h3 h2 h1).
    * by proc; wp; call Sign_G1_D; auto => /> /#.
    * by move=> &2 _; proc; wp; call Sign1_ll; auto.
    * by move=> _; proc; wp; call SignD_coll; auto.
    * by conseq E_Hct.
    * by move=> &2 _; exact ROct_get_ll.
    * by move=> _; conseq HctE_coll.
    * by proc *; call Hmu_eq; auto => /> /#.
    * by move=> &2 _; exact ROmu_get_ll.
    * by move=> _; conseq HmuB_coll.
    * by proc *; call (: ={ROtr.RO.m}); [sim | auto => /> /#].
    * by move=> &2 _; exact ROtr_get_ll.
    * by move=> _; conseq ROtr_coll.
    * by conseq E_XC.
    * by move=> &2 _; proc; auto => />; exact dB_ll.
    * by move=> _; conseq XC_coll.
    * by proc *; call (: ={glob XASim}); [sim | auto => /> /#].
    * by move=> &2 _; exact XASim_ll.
    * by move=> _; proc *; call XASim_ll; auto.
    inline *; auto => />.
    by move=> *; rewrite rel0 /=; smt().
  inline G1(A).O.fresh G1(A).O.nr_queries D(PC.RO).O.fresh D(PC.RO).O.nr_queries.
  case (coll PC.RO.m{2} LX.RO.m{2}).
  + wp; call{1} Verify1_ll; call{2} VerifyD_coll; auto => />.
  by wp; call Verify_G1_D; auto => /> /#.
exlim (nrqs{1} <= qS /\ is_valid{1} /\ is_fresh{1}) => w.
call{2} (Flush_P w).
by auto => /> /#.
qed.

(* Structural invariant of the eager game: the domain of [PC.RO.m] is the
   domain of [HctT.t] (or [St.fl]) plus the pending inputs *)
local op [opaque] si (pm t : (high list * mu_t, ctilde) fmap) (pend : (high list * mu_t) list)
                     (x0 : (high list * mu_t) option) =
  (forall x, x \in pm <=> x \in t \/ x \in pend \/ Some x = x0) /\
  (forall x, x \in t => t.[x] = pm.[x]).

local lemma si_known pm t pend x :
  x \notin t => x \in pm => si pm t pend None => si pm t.[x <- oget pm.[x]] pend None.
proof.
rewrite /si => hxt hx /= [h1 h2]; split => y; rewrite mem_set.
- case: (y = x) => [->> | hne]; 1: by rewrite hx.
  by have := h1 y; smt().
rewrite get_setE; case: (y = x) => [->> _ /= | hne /= hy]; 2: by apply h2.
by move: hx; rewrite domE; case: (pm.[x]).
qed.

local lemma si_new pm t pend x r :
  x \notin t => x \notin pm => si pm t pend None => si pm.[x <- r] t.[x <- r] pend None.
proof.
rewrite /si => hxt hx /= [h1 h2]; split => y; rewrite !mem_set.
- by rewrite h1; smt().
rewrite !get_setE; case: (y = x) => [-> // | hne /= hy]; by apply h2.
qed.

local lemma si_sample pm t pend x r :
  si pm t pend None =>
  si (if x \in pm then pm else pm.[x <- r]) t pend (Some x).
proof.
rewrite /si => /= -[h1 h2]; case: (x \in pm) => hx /=.
- split => y; 2: by apply h2.
  case: (y = x) => [->> | hne]; 1: by rewrite hx.
  by have := h1 y; smt().
split => y.
- by rewrite mem_set h1; smt().
move=> hy; rewrite get_setE; case: (y = x) => [->> | _]; 2: by apply h2.
by move: hx; rewrite h1 hy.
qed.

local lemma si_push pm t pend x :
  si pm t pend (Some x) => si pm t (x :: pend) None.
proof. by rewrite /si => -[h1 h2]; split => // y; rewrite h1 /=; smt(). qed.

local lemma si_pop pm t pend x :
  si pm t (x :: pend) None => si pm t pend (Some x).
proof. by rewrite /si => -[h1 h2]; split => // y; rewrite h1 /=; smt(). qed.

local lemma si_acc pm t pend x :
  si pm t pend (Some x) => x \notin t => si pm t.[x <- oget pm.[x]] pend None.
proof.
rewrite /si => -[h1 h2] hxt; split => y; rewrite mem_set.
- by rewrite h1 /=; smt().
rewrite get_setE; case: (y = x) => [->> _ /= | hne /= hy]; 2: by apply h2.
by have := h1 x; rewrite /= domE; case: (pm.[x]).
qed.

local lemma si_acc_in pm t pend x :
  si pm t pend (Some x) => x \in t => si pm t pend None.
proof. by rewrite /si => -[h1 h2] hxt; split => // y; rewrite h1 /=; smt(). qed.

local lemma si_fl_mem pm fl pend :
  pend <> [] => si pm fl pend None => head witness pend \in pm.
proof.
rewrite /si => hne [h1 _]; rewrite h1; right; left.
by case: pend hne h1 => //= y l.
qed.

local lemma si_fl_step pm fl pend :
  pend <> [] => si pm fl pend None =>
  si pm (if head witness pend \in fl then fl else fl.[head witness pend <- oget pm.[head witness pend]])
     (behead pend) None.
proof.
rewrite /si => hne [h1 h2] /=.
have hpe : pend = head witness pend :: behead pend by rewrite head_behead.
case: (head witness pend \in fl) => hx /=.
- split => // y; have := h1 y; rewrite {1}hpe /=; smt().
split => y.
- have := h1 y; rewrite mem_set {1}hpe /=; smt().
rewrite mem_set get_setE; case: (y = head witness pend) => [->> /= | hne' /= hy]; 2: by apply h2.
have : head witness pend \in pm by apply (si_fl_mem pm fl pend hne); rewrite /si; split.
by rewrite domE; case: (pm.[head witness pend]).
qed.

local lemma si_fl_end pm fl : si pm fl [] None => fl = pm.
proof.
rewrite /si => -[h1 h2]; apply fmap_eqP => y.
case: (y \in fl) => hy; 1: by apply h2.
by rewrite !get_none //; move: (h1 y); rewrite hy.
qed.

(* In the eager game, [St.fl] is [PC.RO.m] at the end *)
local lemma HctE_SI xx o :
  hoare[HctE(PC.RO).get : x = xx /\ si PC.RO.m HctT.t St.pend o /\ (o = None \/ o = Some xx) ==>
        si PC.RO.m HctT.t St.pend None].
proof.
proc; inline *; sp; if.
- case (x \in PC.RO.m).
  + rcondf 3; 1: by auto.
    auto => /> &hr hsi ho hxt hx r _.
    case: ho hsi => -> hsi; [exact si_known | exact si_acc].
  rcondt 3; 1: by auto.
  auto => /> &hr hsi ho hxt hx r _; rewrite get_set_sameE /=.
  case: ho hsi => -> hsi; 1: exact si_new.
  by move: hsi; rewrite /si /= => -[h1 _]; move: hx; rewrite h1.
by auto => /> &hr hsi ho hxt; case: ho hsi => -> hsi //; apply (si_acc_in _ _ _ xx).
qed.

local lemma SignD_SI :
  hoare[MLDSAGen(MatRA, ChalE(PC.RO), HmuB).sign :
        si PC.RO.m HctT.t St.pend None ==> si PC.RO.m HctT.t St.pend None].
proof.
proc; inline MatRA.get.
seq 11 : (si PC.RO.m HctT.t St.pend None /\ response = None).
- by wp; call (: true) => //; auto.
seq 1 : (si PC.RO.m HctT.t St.pend None /\
         (response <> None => St.pend = (w1, mu) :: behead St.pend)).
- while (si PC.RO.m HctT.t St.pend None /\
         (response <> None => St.pend = (w1, mu) :: behead St.pend)).
  + wp; if; 2: by auto.
    seq 4 : (si PC.RO.m HctT.t St.pend None /\ St.pend = (w1, mu) :: behead St.pend).
    * inline ChalE(PC.RO).get PC.RO.sample PC.RO.get; wp.
      call (: true) => //; auto => /> &hr hsi _ y _ r _.
      have := si_sample _ _ _ (highBitsV (mA{hr} *^ y), mu{hr}) r hsi.
      by case: ((highBitsV (mA{hr} *^ y), mu{hr}) \in PC.RO.m{hr}) => /= _ /si_push.
    by auto => />.
  by auto => />.
if; 2: by auto.
inline ChalE(PC.RO).final.
exlim w1, mu => w10 mu0.
wp; call (HctE_SI (w10, mu0) (Some (w10, mu0))); auto => /> &hr hsi hp hr.
by move: hsi; rewrite (hp hr) => /si_pop.
qed.

local lemma HctE_SI0 :
  hoare[HctE(PC.RO).get : si PC.RO.m HctT.t St.pend None ==> si PC.RO.m HctT.t St.pend None].
proof. by proc *; exlim x => xx; call (HctE_SI xx None); auto. qed.

local lemma si0 : si empty empty [] None.
proof. by rewrite /si; smt(mem_empty). qed.

local lemma D_fl : hoare[D(PC.RO).distinguish : true ==> St.fl = PC.RO.m].
proof.
proc.
seq 18 : (si PC.RO.m HctT.t St.pend None).
- wp; call (: true) => //; call (: true) => //.
  inline D(PC.RO).S.verify; wp.
  call HctE_SI0; wp; call (: true) => //.
  call (: true) => //; call (: true) => //; wp.
  call (: si PC.RO.m HctT.t St.pend None).
  + by proc; wp; call SignD_SI; auto.
  + by conseq HctE_SI0.
  + by proc *; call (: true) => //; auto.
  + by proc *; call (: true) => //; auto.
  + by proc *; call (: true) => //; auto.
  + by proc *; call (: true) => //; auto.
  by inline *; auto => />; rewrite si0.
inline Flush(PC.RO).run.
while (si PC.RO.m St.fl St.pend None).
- sp; if.
  + inline *; rcondf 3.
    * by auto => /> &hr hsi hne _ r _; apply (si_fl_mem _ _ _ hne hsi).
    by auto => /> &hr hsi hne hx r _; have := si_fl_step _ _ _ hne hsi; rewrite hx.
  by auto => /> &hr hsi hne hx; have := si_fl_step _ _ _ hne hsi; rewrite hx.
by auto => /> &hr hsi fl m0; exact si_fl_end.
qed.

(* -------------------------------------------------------------------- *)
(* The steps *)

local lemma G1_D &m :
  Pr[G1(A).main() @ &m : res] <=
  Pr[D(PC.RO).distinguish() @ &m :
       (St.win /\ !HctT.bad) \/ coll St.fl LX.RO.m].
proof.
byequiv (_ : ={glob A} ==> res{1} => (St.win{2} /\ !HctT.bad{2}) \/ coll St.fl{2} LX.RO.m{2}) => //.
by conseq G1_D_eq _ D_fl => /> /#.
qed.

local lemma D_RO_LRO &m :
  Pr[D(PC.RO).distinguish() @ &m :
       (St.win /\ !HctT.bad) \/ coll St.fl LX.RO.m] =
  Pr[D(PC.LRO).distinguish() @ &m :
       (St.win /\ !HctT.bad) \/ coll St.fl LX.RO.m].
proof.
byequiv (PC.FullEager.RO_LRO_D D _) => //.
by move=> _; exact dct_ll.
qed.

local lemma coll_bound &m :
  Pr[D(PC.LRO).distinguish() @ &m : coll St.fl LX.RO.m] <= bound_ct.
proof.
apply (ler_trans _ _ _ (D_Act &m)).
have := TCct.table_collision Act (qXC + 1) (qHct + kappa_max * qS + 1) _ _ Act_bound &m.
- smt(qXC_ge0).
- have : 0 <= kappa_max * qS by apply StdOrder.IntOrder.mulr_ge0; smt(gt0_kappa_max qS_ge0).
  smt(qHct_ge0).
have -> : qXC + 1 + (qHct + kappa_max * qS + 1) = qXC + 1 + qHct + kappa_max * qS + 1 by ring.
by rewrite /bound_ct fromintM (RField.mulrC (qXC + 1 + qHct + kappa_max * qS + 1)%r).
qed.

(* ---- end of the G1 -> G2 helpers ---- *)

(* G1 -> G2 (TableCollision): up to the collisions on [Hct]/[XC]
   and on [Hmu]. The winning event of G2 excludes the bad events, as needed
   by hop_reduction. *)
lemma hop_collisions &m :
  Pr[G1(A).main() @ &m : res] <=
  Pr[G2(A).main() @ &m : res /\ !HctT.bad /\ !HmuB.bad] + bound_ct + bound_mu.
proof.
apply (ler_trans _ _ _ (G1_D &m)); rewrite D_RO_LRO.
have h1 := D_G2 &m (fun w b mb => w /\ !b /\ !mb).
have h2 := D_G2 &m (fun w b mb => mb).
have hct := coll_bound &m.
have hmu := mu_bound &m.
have hle : Pr[D(PC.LRO).distinguish() @ &m :
                (St.win /\ !HctT.bad) \/ coll St.fl LX.RO.m] <=
           Pr[D(PC.LRO).distinguish() @ &m :
                (St.win /\ !HctT.bad /\ !HmuB.bad) \/ (HmuB.bad \/ coll St.fl LX.RO.m)].
- by rewrite Pr[mu_sub] => // /#.
apply (ler_trans _ _ _ hle); rewrite Pr[mu_or] Pr[mu_or] /=.
smt(mu_bounded).
qed.

end section PROOF.

end MLDSAProof_Collisions.
