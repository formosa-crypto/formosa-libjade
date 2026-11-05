require import AllCore Distr List IntDiv FSet FMap Leakage Byte Finite.
require import StdOrder.
import RealOrder.
require MLDSAProof_Games.

(** Hop G0 -> G1 of [doc/proof_overview.tex] (uniform matrix): [hop_expandA].
    The real game is a distinguisher [DA(A)] of [EA.RS] (ExpandA in the
    random oracle model, real XOF and real sampler); [EA.ExpandA_sim]
    replaces them by the simulated XOF and the ideal sampler, which answers
    the [k * l] entries of the honest matrix with fresh samples: the matrix
    is then uniform ([dmatrix_loop]) and the game is G1. The signing
    procedures of the three games are instances of [MLDSAGen] which only
    differ by how the matrix is obtained ([ExpandA(XA)], [ExpandAS(S)],
    [MatRA]). *)

abstract theory MLDSAProof_ExpandA.

clone include MLDSAProof_Games.MLDSAProof_Games.
import T Params DR DV DV.MatRq DV.HL.

(* -------------------------------------------------------------------- *)
(* G0 as a distinguisher of ExpandAEquiv                                *)
(* -------------------------------------------------------------------- *)

(* The entries [(rho, r, s)] of the matrix expanded from [rho] *)
op honest (rho : seed) (x : seed * int * int) =
  x.`1 = rho /\ 0 <= x.`2 < k /\ 0 <= x.`3 < l.

(* Relation between the ideal sampler of [EA.RS] (map [mi]) and [RA]
   (seed [rho], matrix [mA], local map [mr]) *)
op ra_inv (mi : (seed * int * int, Rq) fmap) (rho : seed) (mA : matrix)
          (mr : (seed * int * int, Rq) fmap) =
  forall x, mi.[x] = if honest rho x then Some mA.[x.`2, x.`3] else mr.[x].

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

(* [ExpandA] where each entry is computed by a sampler *)
local module ExpandAS (S : EA.RS.Sampler_t) = {
  proc get(rho : seed) : matrix = {
    var mA, r, s, a;
    mA <- zerom k l;
    r <- 0;
    while (r < k) {
      s <- 0;
      while (s < l) {
        a <@ S.sample((rho, r, s));
        mA <- updm mA r s a;
        s <- s + 1;
      }
      r <- r + 1;
    }
    return mA;
  }
}.

(* Key generation and verification of [MLDSA] with [ExpandAS(S)] instead of
   [ExpandA(XA)] (the signing procedure is [MLDSAGen(ExpandAS(S), ...)]) *)
local module MLDSAS (S : EA.RS.Sampler_t, XC : SIB.XOF_t, Htr : Hash_tr, Hmu : Hash_mu, Hct : Hash_ct) = {
  proc keygen() : PK * SK = {
    var rho, mA, s1, s2, t, pk, tr;
    rho <$ dseed;
    mA  <@ ExpandAS(S).get(rho);
    s1  <$ dvector (dRq_ eta_) l;
    s2  <$ dvector (dRq_ eta_) k;
    t   <- mA *^ s1 + s2;
    pk  <- (rho, base2highbitsV t);
    tr  <@ Htr.get(pk);
    return (pk, (rho, tr, s1, s2, base2lowbitsV t));
  }

  proc verify(pk : PK, m : M, sig : Sig) : bool = {
    var rho, t1, ct, ct', response, z, h, mA, tr, mu, c, lc, w1;
    (rho, t1) <- pk;
    (ct, response) <- sig;
    (z, h) <- response;
    mA <@ ExpandAS(S).get(rho);
    tr <@ Htr.get(pk);
    mu <@ Hmu.get(tr, m);
    (c, lc) <@ SIB.SampleInBall(XC).get(ct);
    w1 <- useHintV h (mA *^ z - c ** base2shiftV t1);
    ct' <@ Hct.get(w1, mu);
    return size z = l /\ size h = k /\ inf_normv z < gamma1 - beta_ /\ ct = ct';
  }
}.

(* Signing oracle of the distinguisher (state of [O_CMA]) *)
local module OS (S : EA.RS.Sampler_t) = {
  proc sign(m : M) : Sig option * leakage = {
    var r;
    r <@ MLDSAGen(ExpandAS(S), ChalH(SIB.XOF.RO, ROct.RO), ROmu.RO).sign(O_CMA.sk, m);
    O_CMA.qs <- rcons O_CMA.qs m;
    return r;
  }
}.

(* The output of the distinguisher (its output type is abstract) *)
local module DRes = {
  var b : bool
}.

(* The EF-CMA game as a distinguisher of [EA.RS]: [R] is the XOF of ExpandA
   given to the adversary, [S] computes the entries of the matrix. *)
local module (DA (A : Adv_EFCMA) : EA.RS.Distinguisher) (R : EA.RS.RO_t) (S : EA.RS.Sampler_t) = {
  proc distinguish(x : EA.RS.input) : EA.RS.output = {
    var pk, sk, m, sig, is_valid;
    SIB.XOF.RO.init();
    ROtr.RO.init();
    ROmu.RO.init();
    ROct.RO.init();
    (pk, sk) <@ MLDSAS(S, SIB.XOF.RO, ROtr.RO, ROmu.RO, ROct.RO).keygen();
    O_CMA.sk <- sk;
    O_CMA.qs <- [];
    (m, sig) <@ A(R, SIB.XOF.RO, ROtr.RO, ROmu.RO, ROct.RO, OS(S)).forge(pk);
    is_valid <@ MLDSAS(S, SIB.XOF.RO, ROtr.RO, ROmu.RO, ROct.RO).verify(pk, m, sig);
    DRes.b <- size O_CMA.qs <= qS /\ is_valid /\ ! (m \in O_CMA.qs);
    return witness;
  }
}.

(* Sampling of the matrix *)
local module SampleMat = {
  proc sample() : matrix = {
    var mA;
    mA <$ dmatrix dRq k l;
    return mA;
  }
}.

local module SampleMatLoop = {
  proc sample() : matrix = {
    var mA, r, s, a;
    mA <- zerom k l;
    r <- 0;
    while (r < k) {
      s <- 0;
      while (s < l) {
        a <$ dRq;
        mA <- updm mA r s a;
        s <- s + 1;
      }
      r <- r + 1;
    }
    return mA;
  }
}.

(* G0: the signing procedure of MLDSATarget is an instance of [MLDSAGen]
   (the loop guard of [MLDSAGen] is on the counter only: once a response is
   found, the remaining iterations of [MLDSAGen] do nothing) *)
local equiv sign_G0 (XA <: XOF_A) (XC <: SIB.XOF_t {-XA}) (Htr <: Hash_tr)
              (Hmu <: Hash_mu {-XA, -XC}) (Hct <: Hash_ct {-XA, -XC, -Hmu}) :
  MLDSA(XA, XC, Htr, Hmu, Hct).sign ~ MLDSAGen(ExpandA(XA), ChalH(XC, Hct), Hmu).sign :
  ={sk, m, glob XA, glob XC, glob Hmu, glob Hct} ==>
  ={res, glob XA, glob XC, glob Hmu, glob Hct}.
proof.
proc.
splitwhile{2} 11 : (response = None).
seq 10 11 : (={ct, response, leak, glob XA, glob XC, glob Hmu, glob Hct} /\
             (ctr{2} < kappa_max => response{2} <> None)).
- while (={ctr, ct, mu, response, leak, mA, s1, s2, t0, r0_fail, hint_fail,
           glob XA, glob XC, glob Hmu, glob Hct}).
  + rcondt{2} 1; 1: by auto.
    inline{2} ChalH(XC, Hct).get.
    wp; call (: ={glob XC}); 1: by sim.
    by call (: true); auto.
  wp; call (: true); call (: ={glob XA}); 1: by sim.
  by auto => /> /#.
seq 0 1 : (={ct, response, leak, glob XA, glob XC, glob Hmu, glob Hct}).
- while{2} ((ctr{2} < kappa_max => response{2} <> None) /\
            ={ct, response, leak, glob XA, glob XC, glob Hmu, glob Hct})
           (kappa_max - ctr{2}).
  + by move=> &m z; rcondf 1; auto => /> /#.
  by auto => /> /#.
by if{2}; [inline *; auto | auto].
qed.

(* ==================================================================== *)
(* G0 -> G1: helpers                                                    *)
(* ==================================================================== *)

(* Helpers for [dmatrix_loop]: the loop samples the matrix row by row. *)
local clone DList.ParametricProgram as PRq with type t <- Rq proof *.
local clone DList.ParametricProgram as PRows with type t <- Rq list proof *.

(* The matrix whose rows are given by a list of lists *)
local op rows2m (rs : Rq list list) : matrix =
  offunm (fun i j => nth ZR.zeror (nth [] rs i) j, k, l).

local lemma rows2m_nil1 rs : rows2m (rs ++ [[]]) = rows2m rs.
proof.
apply/eq_matrixP; split => // i j []; rewrite /rows2m /= => hi hj.
rewrite !get_offunm //= nth_cat; case: (i < size rs) => // hge.
by rewrite (nth_default [] rs i) 1:/#.
qed.

local lemma rows2m_upd rs xs a : size rs < k => size xs < l =>
  rows2m (rs ++ [xs ++ [a]]) =
  updm (rows2m (rs ++ [xs])) (size rs) (size xs) a.
proof.
move=> hr hs; apply/eq_matrixP; split => // i j []; rewrite /rows2m /= => hi hj.
have h1 := List.size_ge0 rs; have h2 := List.size_ge0 xs.
rewrite get_updm /= 1,2:/# !get_offunm //= !nth_cat.
case: (i < size rs) => hi1; 1: smt().
case: (i = size rs) => [->> /= | hne].
+ rewrite nth_cat; case: (j < size xs) => hj1; 1: smt().
  by case: (j = size xs) => [-> // | hj2]; rewrite nth_default /= /#.
by rewrite (_ : (i - size rs = 0) = false) 1:/#.
qed.

local lemma dmatrix_rows : dmatrix dRq k l = dmap (DList.dlist (DList.dlist dRq l) k) rows2m.
proof.
have hk := gt0_k; have hl := gt0_l.
have hk0 : 0 <= k by smt(). have hl0 : 0 <= l by smt().
have supp : forall m, m \in dmatrix dRq k l <=> m \in dmap (DList.dlist (DList.dlist dRq l) k) rows2m.
+ move=> m; rewrite supp_dmatrix_full 1,2:/# 1:dRq_fu supp_dmap; split.
  + move=> [hr hc]; exists (mkseq (fun i => mkseq (fun j => m.[i, j]) l) k); split.
    + rewrite DList.supp_dlist 1:/# size_mkseq; split; 1: smt().
      apply/allP => xs /mkseqP [i [_ ->]] /=.
      rewrite DList.supp_dlist 1:/# size_mkseq; split; 1: smt().
      by apply/allP => x _; apply dRq_fu.
    apply/eq_matrixP; rewrite /rows2m /=; split; 1: smt().
    by move=> i j [hi hj]; rewrite get_offunm /= 1:/# nth_mkseq 1:/# /= nth_mkseq /#.
  by move=> [rs [_ ->]]; rewrite /rows2m /= /#.
have hsupp : support (dmatrix dRq k l) = support (dmap (DList.dlist (DList.dlist dRq l) k) rows2m).
+ by apply/fun_ext => m; rewrite eq_iff; apply supp.
apply/eq_distr => m; rewrite !mu1_uni_ll.
+ exact/dmatrix_uni/dRq_uni.
+ exact/dmatrix_ll/dRq_ll.
+ apply/dmap_uni_in_inj; last exact/DList.dlist_uni/DList.dlist_uni/dRq_uni.
  move=> x y /(DList.supp_dlist _ _ _ hk0) [sx ax] /(DList.supp_dlist _ _ _ hk0) [sy ay] exy.
  apply (eq_from_nth []); 1: by rewrite sx sy.
  move=> i hi; have hxi : nth [] x i \in DList.dlist dRq l by move/allP: ax; apply; apply mem_nth.
  have hyi : nth [] y i \in DList.dlist dRq l by move/allP: ay; apply; apply mem_nth; rewrite sy -sx.
  move: hxi hyi => /(DList.supp_dlist _ _ _ hl0) [sxi _] /(DList.supp_dlist _ _ _ hl0) [syi _].
  apply (eq_from_nth ZR.zeror); 1: by rewrite sxi syi.
  move=> j hj; move/eq_matrixP: exy => [_ /(_ i j _)]; 1: by rewrite /rows2m /= /#.
  by rewrite /rows2m /= !get_offunm /= /#.
+ exact/dmap_ll/DList.dlist_ll/DList.dlist_ll/dRq_ll.
by rewrite hsupp.
qed.

local module SMRows1 = {
  proc sample() : matrix = {
    var rs, r, xs;
    rs <- [];
    r <- 0;
    while (r < k) {
      xs <@ PRq.LoopSnoc.sample(dRq, l);
      rs <- rs ++ [xs];
      r <- r + 1;
    }
    return rows2m rs;
  }
}.

local module SMRows2 = {
  proc sample() : matrix = {
    var rs, r, xs;
    rs <- [];
    r <- 0;
    while (r < k) {
      xs <@ PRq.Sample.sample(dRq, l);
      rs <- rs ++ [xs];
      r <- r + 1;
    }
    return rows2m rs;
  }
}.

local module SMRows3 = {
  proc sample() : matrix = {
    var rs;
    rs <@ PRows.LoopSnoc.sample(DList.dlist dRq l, k);
    return rows2m rs;
  }
}.

local module SMRows4 = {
  proc sample() : matrix = {
    var rs;
    rs <@ PRows.Sample.sample(DList.dlist dRq l, k);
    return rows2m rs;
  }
}.

local lemma loop_rows1 : equiv [SampleMatLoop.sample ~ SMRows1.sample : true ==> ={res}].
proof.
proc.
while (={r} /\ mA{1} = rows2m rs{2} /\ size rs{2} = r{2} /\ 0 <= r{1}); last by auto.
inline PRq.LoopSnoc.sample; wp.
while (s{1} = i{2} /\ d{2} = dRq /\ n{2} = l /\ size l{2} = i{2} /\ 0 <= i{2} /\
       mA{1} = rows2m (rs{2} ++ [l{2}]) /\ size rs{2} = r{1} /\ r{1} < k).
+ auto => /> &2 h0 hr hs a _.
  by rewrite cats1 size_rcons -cats1 rows2m_upd //; smt().
auto => /> &2 *; split; 1: by rewrite rows2m_nil1.
by move=> lR *; rewrite cats1 size_rcons /#.
qed.

(* [dmatrix dRq k l] is the distribution of the matrix whose [k * l] entries
   are sampled independently in [dRq], in row-major order. *)
local lemma rows1_rows2 : equiv [SMRows1.sample ~ SMRows2.sample : true ==> ={res}].
proof.
proc; while (={r, rs}); last by auto.
wp; call (: ={d, n} ==> ={res}); last by auto.
by symmetry; conseq PRq.Sample_LoopSnoc_eq => /#.
qed.

local lemma rows2_rows3 : equiv [SMRows2.sample ~ SMRows3.sample : true ==> ={res}].
proof.
proc; inline PRows.LoopSnoc.sample; wp.
while (r{1} = i{2} /\ rs{1} = l{2} /\ n{2} = k /\ d{2} = DList.dlist dRq l).
+ by inline PRq.Sample.sample; auto.
by auto.
qed.

local lemma rows3_rows4 : equiv [SMRows3.sample ~ SMRows4.sample : true ==> ={res}].
proof.
proc; call (: ={d, n} ==> ={res}); last by auto.
by symmetry; conseq PRows.Sample_LoopSnoc_eq => /#.
qed.

local lemma rows4_mat : equiv [SMRows4.sample ~ SampleMat.sample : true ==> ={res}].
proof.
bypr (res{1}) (res{2}) => // &1 &2 m.
have -> : Pr[SMRows4.sample() @ &1 : res = m] = mu1 (dmatrix dRq k l) m.
+ byphoare => //; proc; inline PRows.Sample.sample; wp; rnd; auto => />.
  by rewrite dmatrix_rows dmap1E.
by byphoare => //; proc; rnd; auto.
qed.

local lemma dmatrix_loop : equiv [SampleMatLoop.sample ~ SampleMat.sample : true ==> ={res}].
proof.
transitivity SMRows1.sample (true ==> ={res}) (true ==> ={res}) => //; 1: exact loop_rows1.
transitivity SMRows2.sample (true ==> ={res}) (true ==> ={res}) => //; 1: exact rows1_rows2.
transitivity SMRows3.sample (true ==> ={res}) (true ==> ={res}) => //; 1: exact rows2_rows3.
transitivity SMRows4.sample (true ==> ={res}) (true ==> ={res}) => //; 1: exact rows3_rows4.
exact rows4_mat.
qed.

(* Step 1: the real game as a distinguisher with the real RO and ExpandA sampler *)

local lemma XA_RS_get : equiv [XA.RO.get ~ EA.RS.RO.get :
  ={arg} /\ XA.RO.m{1} = EA.RS.RO.m{2} ==> ={res} /\ XA.RO.m{1} = EA.RS.RO.m{2}].
proof. by proc; auto. qed.

local lemma ExpandA_ExpandAS : equiv [ExpandA(XA.RO).get ~ ExpandAS(EA.SampleRq(EA.RS.RO)).get :
  ={rho} /\ XA.RO.m{1} = EA.RS.RO.m{2} ==> ={res} /\ XA.RO.m{1} = EA.RS.RO.m{2}].
proof.
proc; inline EA.SampleRq(EA.RS.RO).sample.
while (={rho, r, mA} /\ XA.RO.m{1} = EA.RS.RO.m{2}); last by auto.
wp; while (={rho, r, s, mA} /\ XA.RO.m{1} = EA.RS.RO.m{2}); last by auto.
wp; while (={cs, ctx} /\ x{2} = (rho, r, s){1} /\ XA.RO.m{1} = EA.RS.RO.m{2}).
+ wp; do 3! call XA_RS_get; auto => />.
by auto.
qed.

local lemma verify_real : equiv [MLDSA(XA.RO, SIB.XOF.RO, ROtr.RO, ROmu.RO, ROct.RO).verify ~
  MLDSAS(EA.SampleRq(EA.RS.RO), SIB.XOF.RO, ROtr.RO, ROmu.RO, ROct.RO).verify :
  ={arg} /\ XA.RO.m{1} = EA.RS.RO.m{2} /\ ={SIB.XOF.RO.m, ROtr.RO.m, ROmu.RO.m, ROct.RO.m} ==>
  ={res} /\ XA.RO.m{1} = EA.RS.RO.m{2} /\ ={SIB.XOF.RO.m, ROtr.RO.m, ROmu.RO.m, ROct.RO.m}].
proof.
proc; seq 4 4 : (={pk, m, sig, rho, t1, ct, response, z, h, mA} /\
  XA.RO.m{1} = EA.RS.RO.m{2} /\ ={SIB.XOF.RO.m, ROtr.RO.m, ROmu.RO.m, ROct.RO.m}).
+ by call ExpandA_ExpandAS; auto.
by sim (: XA.RO.m{1} = EA.RS.RO.m{2}).
qed.

local lemma sign_real : equiv [MLDSA(XA.RO, SIB.XOF.RO, ROtr.RO, ROmu.RO, ROct.RO).sign ~
  MLDSAGen(ExpandAS(EA.SampleRq(EA.RS.RO)), ChalH(SIB.XOF.RO, ROct.RO), ROmu.RO).sign :
  ={arg} /\ XA.RO.m{1} = EA.RS.RO.m{2} /\ ={SIB.XOF.RO.m, ROmu.RO.m, ROct.RO.m} ==>
  ={res} /\ XA.RO.m{1} = EA.RS.RO.m{2} /\ ={SIB.XOF.RO.m, ROmu.RO.m, ROct.RO.m}].
proof.
transitivity MLDSAGen(ExpandA(XA.RO), ChalH(SIB.XOF.RO, ROct.RO), ROmu.RO).sign
  (={arg, XA.RO.m, SIB.XOF.RO.m, ROmu.RO.m, ROct.RO.m} ==>
   ={res, XA.RO.m, SIB.XOF.RO.m, ROmu.RO.m, ROct.RO.m})
  (={arg} /\ XA.RO.m{1} = EA.RS.RO.m{2} /\ ={SIB.XOF.RO.m, ROmu.RO.m, ROct.RO.m} ==>
   ={res} /\ XA.RO.m{1} = EA.RS.RO.m{2} /\ ={SIB.XOF.RO.m, ROmu.RO.m, ROct.RO.m}) => //.
- by move=> &1 &2 h; exists ROct.RO.m{1} ROmu.RO.m{1} XA.RO.m{1} SIB.XOF.RO.m{1} arg{1}; move: h.
- by proc*; call (sign_G0 XA.RO SIB.XOF.RO ROtr.RO ROmu.RO ROct.RO); auto.
proc; seq 7 7 : (={sk, m, ct, w1, r0_fail, hint_fail, leak, rho, tr, s1, s2, t0, mA} /\
  XA.RO.m{1} = EA.RS.RO.m{2} /\ ={SIB.XOF.RO.m, ROmu.RO.m, ROct.RO.m}).
+ by call ExpandA_ExpandAS; auto.
by sim (: XA.RO.m{1} = EA.RS.RO.m{2}).
qed.

local lemma keygen_real : equiv [MLDSA(XA.RO, SIB.XOF.RO, ROtr.RO, ROmu.RO, ROct.RO).keygen ~
  MLDSAS(EA.SampleRq(EA.RS.RO), SIB.XOF.RO, ROtr.RO, ROmu.RO, ROct.RO).keygen :
  XA.RO.m{1} = EA.RS.RO.m{2} /\ ={SIB.XOF.RO.m, ROtr.RO.m, ROmu.RO.m, ROct.RO.m} ==>
  ={res} /\ XA.RO.m{1} = EA.RS.RO.m{2} /\ ={SIB.XOF.RO.m, ROtr.RO.m, ROmu.RO.m, ROct.RO.m}].
proof.
proc; seq 2 2 : (={rho, mA} /\
  XA.RO.m{1} = EA.RS.RO.m{2} /\ ={SIB.XOF.RO.m, ROtr.RO.m, ROmu.RO.m, ROct.RO.m}).
+ by call ExpandA_ExpandAS; auto.
by sim (: XA.RO.m{1} = EA.RS.RO.m{2}).
qed.

local lemma step_real &m :
  Pr[EF_CMA_MLDSA(A).main() @ &m : res] =
  Pr[EA.RS.Main(DA(A), EA.RS.RO, EA.SampleRq(EA.RS.RO)).main(witness) @ &m : DRes.b].
proof.
byequiv => //; proc.
inline{2} DA(A, EA.RS.RO, EA.SampleRq(EA.RS.RO)).distinguish.
inline{1} ROs.init O_CMA(XA.RO, SIB.XOF.RO, ROtr.RO, ROmu.RO, ROct.RO).init
  O_CMA(XA.RO, SIB.XOF.RO, ROtr.RO, ROmu.RO, ROct.RO).fresh
  O_CMA(XA.RO, SIB.XOF.RO, ROtr.RO, ROmu.RO, ROct.RO).nr_queries.
inline{2} EA.SampleRq(EA.RS.RO).init.
wp; call verify_real.
call (: XA.RO.m{1} = EA.RS.RO.m{2} /\
        ={SIB.XOF.RO.m, ROtr.RO.m, ROmu.RO.m, ROct.RO.m, O_CMA.sk, O_CMA.qs}).
+ by proc; wp; call sign_real; auto.
+ by sim.
+ by sim.
+ by sim.
+ by sim.
+ by conseq XA_RS_get.
wp; call keygen_real.
inline *; auto.
qed.

(* Step 2: EA.ExpandA_sim *)

local lemma step_sim &m :
  Pr[EA.RS.Main(DA(A), EA.RS.RO, EA.SampleRq(EA.RS.RO)).main(witness) @ &m : DRes.b] =
  Pr[EA.RS.Main(DA(A), EA.RS.Sim(EA.ReprogRq, EA.RS.ISR), EA.RS.ISR).main(witness) @ &m : DRes.b].
proof. by byequiv (EA.ExpandA_sim (DA(A))) => // /> /#. qed.

(* Step 3: the ideal side is G1 *)

local lemma ISR_RA : equiv [EA.RS.ISR.sample ~ RA.sample :
  ={arg} /\ ra_inv EA.RS.IS.RO.m{1} RA.rho{2} RA.mA{2} RA.m{2} ==>
  ={res} /\ ra_inv EA.RS.IS.RO.m{1} RA.rho{2} RA.mA{2} RA.m{2}].
proof.
proc; if{2}.
+ auto => &1 &2 [[-> hinv] hh] r _.
  have h := hinv x{2}; rewrite (_ : honest RA.rho{2} x{2}) // /= in h.
  by rewrite domE h.
if{2}.
+ rcondt{1} 2.
  + move=> &m2; auto => &m1 [[[hx /(_ x{m2}) h] hh] hin] r _.
    have hf : honest RA.rho{m2} x{m2} = false by rewrite /honest; smt().
  by move: h; rewrite hf /= => h; rewrite hx !domE h -domE.
  wp; rnd; auto => &1 &2 [[[-> hinv] hh] _] r _ /=; split; 1: by rewrite !get_set_sameE.
  move=> x'; rewrite !get_setE.
  case: (x' = x{2}) => [->> | hne]; 1: by rewrite /honest; smt().
  exact hinv.
rcondf{1} 2.
+ move=> &m2; auto => &m1 [[[hx /(_ x{m2}) h] hh] hin] r _.
  have hf : honest RA.rho{m2} x{m2} = false by rewrite /honest; smt().
  by move: h; rewrite hf /= => h; rewrite hx !domE h -domE.
wp; rnd{1}; auto => &1 &2 [[[-> hinv] hh] _] r _ /=; rewrite hinv /=.
have hf : honest RA.rho{2} x{2} = false by rewrite /honest; smt().
by rewrite hf.
qed.

local lemma Sim_get : equiv [EA.RS.Sim(EA.ReprogRq, EA.RS.ISR).get ~ EA.RS.Sim(EA.ReprogRq, RA).get :
  ={arg, EA.RS.Sim.Overlay.m, EA.RS.Sim.reprog} /\
  ra_inv EA.RS.IS.RO.m{1} RA.rho{2} RA.mA{2} RA.m{2} ==>
  ={res, EA.RS.Sim.Overlay.m, EA.RS.Sim.reprog} /\
  ra_inv EA.RS.IS.RO.m{1} RA.rho{2} RA.mA{2} RA.m{2}].
proof.
proc; call (: ={EA.RS.Sim.Overlay.m}); 1: by sim.
inline EA.RS.Sim(EA.ReprogRq, EA.RS.ISR).reprogram EA.RS.Sim(EA.ReprogRq, RA).reprogram.
sp; if => //.
call (: ={EA.RS.Sim.Overlay.m}); 1: by sim.
by call ISR_RA; auto.
qed.

local lemma ExpandAS_fresh rho0 : equiv [ExpandAS(EA.RS.ISR).get ~ SampleMatLoop.sample :
  rho{1} = rho0 /\ EA.RS.IS.RO.m{1} = empty ==>
  ={res} /\ size res{1} = (k, l) /\
  forall x, EA.RS.IS.RO.m{1}.[x] =
            if honest rho0 x then Some res{1}.[x.`2, x.`3] else None].
proof.
proc; inline *.
while (={r, mA} /\ rho{1} = rho0 /\ size mA{1} = (k, l) /\ 0 <= r{1} <= k /\
  forall x, EA.RS.IS.RO.m{1}.[x] =
    if x.`1 = rho0 /\ 0 <= x.`2 < r{1} /\ 0 <= x.`3 < l
    then Some mA{1}.[x.`2, x.`3] else None).
+ wp; while (={r, s, mA} /\ rho{1} = rho0 /\ size mA{1} = (k, l) /\ 0 <= r{1} < k /\
    0 <= s{1} <= l /\
    forall x, EA.RS.IS.RO.m{1}.[x] =
      if x.`1 = rho0 /\ (0 <= x.`2 < r{1} /\ 0 <= x.`3 < l \/ x.`2 = r{1} /\ 0 <= x.`3 < s{1})
      then Some mA{1}.[x.`2, x.`3] else None).
  + wp; rnd; wp; skip => /> &1 &2 hr hc hr0 hrk hs0 _ hm hsl a _.
    have hnin : (rho0, r{2}, s{2}) \notin EA.RS.IS.RO.m{1}.
    + by rewrite domE hm /= /#.
    split; last by move=> h; move: hnin; rewrite h.
    move=> _; rewrite get_set_sameE /= rows_updm cols_updm hr hc /=.
    split; 1: smt().
    move=> x; rewrite get_setE.
    case: (x = (rho0, r{2}, s{2})) => [->> /= | hne].
    + by rewrite (_ : 0 <= s{2} < s{2} + 1) 1:/# /= get_updm 1,2:/#.
    rewrite hm.
    case: (x.`1 = rho0 /\ (0 <= x.`2 < r{2} /\ 0 <= x.`3 < l \/
           x.`2 = r{2} /\ 0 <= x.`3 < s{2})) => hx.
    + have hne' : (x.`2, x.`3) <> (r{2}, s{2}) by move: hne hx; case: x => /#.
      have -> /= : x.`1 = rho0 /\ (0 <= x.`2 < r{2} /\ 0 <= x.`3 < l \/
                   x.`2 = r{2} /\ 0 <= x.`3 < s{2} + 1) by smt().
      by rewrite get_updm 1,2:/# hne'.
    have -> // : !(x.`1 = rho0 /\ (0 <= x.`2 < r{2} /\ 0 <= x.`3 < l \/
                   x.`2 = r{2} /\ 0 <= x.`3 < s{2} + 1)).
    + by move: hne hx; case: x => /#.
  auto => /> &1 &2 hr hc hr0 _ hm hrk; split.
  + split; 1: smt(gt0_l).
    by move=> x; rewrite hm; smt().
  move=> mm mA s h1 _ hr' hc' hs0 hsl hm'; split; 1: smt().
  by move=> x; rewrite hm'; smt().
auto => />; split.
+ split; 1: smt(gt0_k gt0_l).
  split; 1: smt(gt0_k).
  by move=> x; rewrite emptyE /#.
move=> mm mA r h1 _ hr' hc' hr0 hrk hm x; rewrite hm /honest; smt().
qed.

local lemma ExpandAS_read rho0 mA0 m0 : phoare [ExpandAS(EA.RS.ISR).get :
  rho = rho0 /\ EA.RS.IS.RO.m = m0 /\ size mA0 = (k, l) /\
  (forall x, honest rho0 x => m0.[x] = Some mA0.[x.`2, x.`3]) ==>
  res = mA0 /\ EA.RS.IS.RO.m = m0] = 1%r.
proof.
proc; inline *.
while (rho = rho0 /\ EA.RS.IS.RO.m = m0 /\ size mA0 = (k, l) /\
  (forall x, honest rho0 x => m0.[x] = Some mA0.[x.`2, x.`3]) /\
  size mA = (k, l) /\ 0 <= r <= k /\
  (forall i j, 0 <= i < r => 0 <= j < l => mA.[i, j] = mA0.[i, j])) (k - r).
+ move=> z; wp.
  while (rho = rho0 /\ EA.RS.IS.RO.m = m0 /\ size mA0 = (k, l) /\
    (forall x, honest rho0 x => m0.[x] = Some mA0.[x.`2, x.`3]) /\
    size mA = (k, l) /\ 0 <= r < k /\ 0 <= s <= l /\
    (forall i j, 0 <= i < k => 0 <= j < l => (i < r \/ i = r /\ j < s) =>
       mA.[i, j] = mA0.[i, j])) (l - s).
  + move=> z'; wp; rnd; wp; skip => /> &hr hr0 hc0 hm0 hr hc hrr hrk hs0 _ hmA hsl.
    have hx := hm0 (rho0, r{hr}, s{hr}) _; 1: by rewrite /honest /#.
    rewrite domE hx /= -dRq_ll; apply mu_eq => a /=.
    rewrite eqT /= rows_updm cols_updm hr hc /=.
    split; 2: smt().
    split; 1: smt().
    move=> i j hi hj hij; rewrite get_updm 1,2:/#.
    case: ((i, j) = (r{hr}, s{hr})) => [[-> ->] // | hne].
    by apply hmA => //; smt().
  auto => /> &hr hr0 hc0 hm0 hr hc hrr _ hmA hrk; split; 1: smt(gt0_l).
  move=> mA s; split; 1: smt().
  move=> hs hr' hc' hs0 _ hmA'; split; 2: smt().
  split; 1: smt().
  by move=> i j hi0 hi hj0 hj; apply hmA' => /#.
auto => /> hr0 hc0 hm0; split; 1: smt(gt0_k gt0_l).
move=> mA r; split; 1: smt().
move=> hr hr' hc' hr0' _ hmA; apply eq_matrixP; split; 1: smt().
by move=> i j hij; apply hmA; smt().
qed.

local lemma ExpandAS_dmatrix rho0 : equiv [ExpandAS(EA.RS.ISR).get ~ SampleMat.sample :
  rho{1} = rho0 /\ EA.RS.IS.RO.m{1} = empty ==>
  ={res} /\ size res{1} = (k, l) /\
  forall x, EA.RS.IS.RO.m{1}.[x] =
            if honest rho0 x then Some res{1}.[x.`2, x.`3] else None].
proof.
transitivity SampleMatLoop.sample
  (rho{1} = rho0 /\ EA.RS.IS.RO.m{1} = empty ==>
   ={res} /\ size res{1} = (k, l) /\
   forall x, EA.RS.IS.RO.m{1}.[x] =
             if honest rho0 x then Some res{1}.[x.`2, x.`3] else None)
  (true ==> ={res}).
+ by move=> &1 _ h.
+ by move=> /> /#.
+ by conseq (ExpandAS_fresh rho0).
exact dmatrix_loop.
qed.

local lemma keygen_ideal : equiv [MLDSAS(EA.RS.ISR, SIB.XOF.RO, ROtr.RO, ROmu.RO, ROct.RO).keygen ~
  MLDSA1(SIB.XOF.RO, ROtr.RO, ROmu.RO, ROct.RO).keygen :
  EA.RS.IS.RO.m{1} = empty /\ ={ROtr.RO.m} ==>
  res{1} = (res{2}.`1, res{2}.`2.`2) /\ res{2}.`1.`1 = res{2}.`2.`2.`1 /\
  size res{2}.`2.`1 = (k, l) /\
  ra_inv EA.RS.IS.RO.m{1} res{2}.`1.`1 res{2}.`2.`1 empty /\ ={ROtr.RO.m}].
proof.
proc; seq 2 2 : (={rho, mA, ROtr.RO.m} /\ size mA{2} = (k, l) /\
  ra_inv EA.RS.IS.RO.m{1} rho{2} mA{2} empty).
+ seq 1 1 : (={rho, ROtr.RO.m} /\ EA.RS.IS.RO.m{1} = empty); 1: by auto.
  exlim rho{1} => rho0.
  outline {2} 1 by { mA <@ SampleMat.sample(); }.
  call (ExpandAS_dmatrix rho0); auto => /> mA mm hr hc hm.
  by move=> x; rewrite hm emptyE.
by wp; call (: ={ROtr.RO.m}); [sim | auto].
qed.

local lemma sign_ideal : equiv [
  MLDSAGen(ExpandAS(EA.RS.ISR), ChalH(SIB.XOF.RO, ROct.RO), ROmu.RO).sign ~
  MLDSAGen(MatRA, ChalH(SIB.XOF.RO, ROct.RO), ROmu.RO).sign :
  ={sk, m} /\ sk{1}.`1 = RA.rho{2} /\
  size RA.mA{2} = (k, l) /\ ra_inv EA.RS.IS.RO.m{1} RA.rho{2} RA.mA{2} RA.m{2} /\
  ={SIB.XOF.RO.m, ROtr.RO.m, ROmu.RO.m, ROct.RO.m} ==>
  ={res} /\ ra_inv EA.RS.IS.RO.m{1} RA.rho{2} RA.mA{2} RA.m{2} /\
  ={SIB.XOF.RO.m, ROtr.RO.m, ROmu.RO.m, ROct.RO.m}].
proof.
proc; seq 7 7 : (={sk, m, ct, w1, r0_fail, hint_fail, leak, rho, tr, s1, s2, t0, mA} /\
  ra_inv EA.RS.IS.RO.m{1} RA.rho{2} RA.mA{2} RA.m{2} /\
  ={SIB.XOF.RO.m, ROtr.RO.m, ROmu.RO.m, ROct.RO.m}).
+ inline{2} MatRA.get; wp.
  exlim sk{1}.`1, RA.mA{2}, EA.RS.IS.RO.m{1} => rho0 mA0 m0.
  call{1} (ExpandAS_read rho0 mA0 m0); auto => /> &2 hr hc hinv x h1 h2 h3 h4 h5.
  by rewrite hinv /honest h1 h2 h3 h4 h5.
by sim / (ra_inv EA.RS.IS.RO.m{1} RA.rho{2} RA.mA{2} RA.m{2}) :
  (={ct, response, leak, SIB.XOF.RO.m, ROtr.RO.m, ROmu.RO.m, ROct.RO.m}).
qed.

local lemma verify_ideal : equiv [MLDSAS(EA.RS.ISR, SIB.XOF.RO, ROtr.RO, ROmu.RO, ROct.RO).verify ~
  MLDSA1(SIB.XOF.RO, ROtr.RO, ROmu.RO, ROct.RO).verify :
  ={pk, m, sig} /\ mA{2} = RA.mA{2} /\ pk{1}.`1 = RA.rho{2} /\
  size RA.mA{2} = (k, l) /\ ra_inv EA.RS.IS.RO.m{1} RA.rho{2} RA.mA{2} RA.m{2} /\
  ={SIB.XOF.RO.m, ROtr.RO.m, ROmu.RO.m, ROct.RO.m} ==> ={res}].
proof.
proc; seq 3 3 : (={pk, m, sig, rho, t1, ct, response, z, h} /\ mA{2} = RA.mA{2} /\
  rho{1} = RA.rho{2} /\ size RA.mA{2} = (k, l) /\
  ra_inv EA.RS.IS.RO.m{1} RA.rho{2} RA.mA{2} RA.m{2} /\
  ={SIB.XOF.RO.m, ROtr.RO.m, ROmu.RO.m, ROct.RO.m}).
+ by auto => /> /#.
seq 1 0 : (={pk, m, sig, rho, t1, ct, response, z, h, mA} /\
  ={SIB.XOF.RO.m, ROtr.RO.m, ROmu.RO.m, ROct.RO.m}).
+ exlim rho{1}, mA{2}, EA.RS.IS.RO.m{1} => rho0 mA0 m0.
  call{1} (ExpandAS_read rho0 mA0 m0); auto => /> &2 hr hc hinv x h1 h2 h3 h4 h5.
  by rewrite hinv /honest h1 h2 h3 h4 h5.
by sim.
qed.

local lemma step_ideal &m :
  Pr[EA.RS.Main(DA(A), EA.RS.Sim(EA.ReprogRq, EA.RS.ISR), EA.RS.ISR).main(witness) @ &m : DRes.b] =
  Pr[G1(A).main() @ &m : res].
proof.
byequiv => //; proc.
inline{1} DA(A, EA.RS.Sim(EA.ReprogRq, EA.RS.ISR), EA.RS.ISR).distinguish.
inline{2} G1(A).O.init G1(A).O.fresh G1(A).O.nr_queries.
wp; call verify_ideal.
call (: ={EA.RS.Sim.Overlay.m, EA.RS.Sim.reprog} /\
        ={SIB.XOF.RO.m, ROtr.RO.m, ROmu.RO.m, ROct.RO.m} /\
        O_CMA.sk{1} = O_CMA1.sk{2} /\ O_CMA.qs{1} = O_CMA1.qs{2} /\
        O_CMA.sk{1}.`1 = RA.rho{2} /\ size RA.mA{2} = (k, l) /\
        ra_inv EA.RS.IS.RO.m{1} RA.rho{2} RA.mA{2} RA.m{2}).
+ by proc; wp; call sign_ideal; auto.
+ by proc; auto.
+ by proc; auto.
+ by proc; auto.
+ by proc; auto.
+ by conseq Sim_get.
wp; call keygen_ideal.
by inline *; auto => /> r m0 ->.
qed.

(* ---- end of the G0 -> G1 helpers ---- *)

(* G0 -> G1 (EA.ExpandA_sim and dmatrix sampling of the k * l
   fresh entries of the honest seed) *)
lemma hop_expandA &m :
  Pr[EF_CMA_MLDSA(A).main() @ &m : res] = Pr[G1(A).main() @ &m : res].
proof. by rewrite (step_real &m) (step_sim &m) (step_ideal &m). qed.

end section PROOF.

end MLDSAProof_ExpandA.
