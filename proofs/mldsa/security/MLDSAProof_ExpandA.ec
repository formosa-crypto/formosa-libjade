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
    differ by how the matrix and the leakage of ExpandA are obtained
    ([ExpandA(XA)], [ExpandASL(S, R)], [MatRA]). In the distinguisher, the
    signer computes each entry with the sampler [S] and its candidates by
    a second run of the inner loop of ExpandA on the XOF [R] of the
    adversary; on the real side this run reads the bytes that the sampler
    has just read ([poly_rerun]), on the ideal side it is the run of
    [MatRA] on the simulated XOF. *)

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

(* [ExpandA] where each entry is computed by a sampler [S], and its
   candidates (the leakage) by the inner loop of [ExpandA] on the XOF [R] *)
local module ExpandASL (S : EA.RS.Sampler_t, R : XOF_A) = {
  proc get(rho : seed) : matrix * leakage = {
    var mA, la, r, s, a, a', vs;
    mA <- zerom k l;
    la <- Empty;
    r <- 0;
    while (r < k) {
      s <- 0;
      while (s < l) {
        a <@ S.sample((rho, r, s));
        (a', vs) <@ ExpandA(R).poly((rho, r, s));
        mA <- updm mA r s a;
        la <- lcat la (cands_leak vs);
        s <- s + 1;
      }
      r <- r + 1;
    }
    return (mA, la);
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
local module OS (S : EA.RS.Sampler_t, R : XOF_A) = {
  proc sign(m : M) : Sig option * leakage = {
    var r;
    r <@ MLDSAGen(ExpandASL(S, R), ChalH(SIB.XOF.RO, ROct.RO), ROmu.RO).sign(O_CMA.sk, m);
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
    (m, sig) <@ A(R, SIB.XOF.RO, ROtr.RO, ROmu.RO, ROct.RO, OS(S, R)).forge(pk);
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
splitwhile{2} 10 : (response = None).
seq 12 10 : (={ct, response, glob XA, glob XC, glob Hmu, glob Hct} /\
             leak{1} = lcat (lcat (rho_leak rho{2}) la{2}) leak{2} /\
             (ctr{2} < kappa_max => response{2} <> None)).
- while (={ctr, ct, mu, response, mA, s1, s2, t0, r0_fail, hint_fail,
           glob XA, glob XC, glob Hmu, glob Hct} /\
         leak{1} = lcat (lcat (rho_leak rho{2}) la{2}) leak{2}).
  + rcondt{2} 1; 1: by auto.
    inline{2} ChalH(XC, Hct).get; swap{1} 5 1.
    wp; call (: ={glob XC}); 1: by sim.
    by call (: true); auto => /> *; rewrite !catA.
  wp; call (: true); wp; call (: ={glob XA}); 1: by sim.
  by auto => /> /#.
while{2} ((ctr{2} < kappa_max => response{2} <> None) /\
          ={ct, response, glob XA, glob XC, glob Hmu, glob Hct} /\
          leak{1} = lcat (lcat (rho_leak rho{2}) la{2}) leak{2})
         (kappa_max - ctr{2}).
- by move=> &m z; rcondf 1; auto => /> /#.
by auto => /> /#.
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

local lemma poly_sample : equiv [ExpandA(XA.RO).poly ~ EA.SampleRq(EA.RS.RO).sample :
  ={x} /\ XA.RO.m{1} = EA.RS.RO.m{2} ==> res{1}.`1 = res{2} /\ XA.RO.m{1} = EA.RS.RO.m{2}].
proof.
proc; wp; while (={x, cs, ctx} /\ XA.RO.m{1} = EA.RS.RO.m{2}); 2: by auto.
by wp; do 3! call XA_RS_get; auto => />.
qed.

local lemma ExpandA_ExpandAS : equiv [ExpandA(XA.RO).get ~ ExpandAS(EA.SampleRq(EA.RS.RO)).get :
  ={rho} /\ XA.RO.m{1} = EA.RS.RO.m{2} ==> res{1}.`1 = res{2} /\ XA.RO.m{1} = EA.RS.RO.m{2}].
proof.
proc.
while (={rho, r, mA} /\ XA.RO.m{1} = EA.RS.RO.m{2}); last by auto.
wp; while (={rho, r, s, mA} /\ XA.RO.m{1} = EA.RS.RO.m{2}); last by auto.
by wp; call poly_sample; auto.
qed.

(* The inner loop of [ExpandA] on a lazy random oracle, as a function of
   its map: [cand m x j] is the [j]-th candidate of the stream of [x], and
   [pdone m x rv] says that [rv] is the result of the loop on [x] and
   that [m] contains all the bytes that the loop reads. *)
local op cand (m : ((seed * int * int) * int, byte) fmap) (x : seed * int * int) (j : int) =
  EA.v_of (oget m.[(x, 3 * j)]) (oget m.[(x, 3 * j + 1)]) (oget m.[(x, 3 * j + 2)]).

local op cands m x j = mkseq (cand m x) j.
local op accs m x j = filter (fun v => v < q) (cands m x j).

local op pdone (m : ((seed * int * int) * int, byte) fmap) x (rv : Rq * int list) =
  let j = size rv.`2 in
  rv = (toRq (accs m x j), cands m x j) /\ n <= size (accs m x j) /\
  (forall j', 0 <= j' < j => size (accs m x j') < n) /\
  (forall i, 0 <= i < 3 * j => (x, i) \in m).

(* [m'] extends [m] *)
local op ext (m m' : ((seed * int * int) * int, byte) fmap) =
  forall z, z \in m => m'.[z] = m.[z].

local lemma ext_mem m m' z : ext m m' => z \in m => z \in m'.
proof. by move=> h hz; rewrite domE h // -domE. qed.

local lemma ext_some m m' z b : ext m m' => m.[z] = Some b => m'.[z] = Some b.
proof. by move=> h hz; rewrite h // domE hz. qed.

local lemma ext_trans m1 m2 m3 : ext m1 m2 => ext m2 m3 => ext m1 m3.
proof. by move=> h12 h23 z hz; rewrite h23 1:(ext_mem m1) // h12. qed.

local lemma cands_ext m m' x j :
  (forall i, 0 <= i < 3 * j => (x, i) \in m) => ext m m' =>
  cands m' x j = cands m x j.
proof.
move=> hin hext; apply eq_in_mkseq => t ht /=; rewrite /cand.
by rewrite !hext ?hin //; smt().
qed.

local lemma accs_ext m m' x j :
  (forall i, 0 <= i < 3 * j => (x, i) \in m) => ext m m' =>
  accs m' x j = accs m x j.
proof. by move=> hin hext; rewrite /accs (cands_ext m m'). qed.

local lemma cands_S m x j : 0 <= j => cands m x (j + 1) = rcons (cands m x j) (cand m x j).
proof. by move=> hj; rewrite /cands mkseqS. qed.

local lemma accs_S m x j : 0 <= j =>
  accs m x (j + 1) =
  if cand m x j < q then rcons (accs m x j) (cand m x j) else accs m x j.
proof. by move=> hj; rewrite /accs cands_S // filter_rcons. qed.

local lemma XA_get_ext m0 y0 : hoare [XA.RO.get : XA.RO.m = m0 /\ x = y0 ==>
  XA.RO.m.[y0] = Some res /\ ext m0 XA.RO.m].
proof.
proc; auto => /> r _; case: (y0 \in m0) => hy /=.
- by move: hy; rewrite domE; case: (m0.[y0]).
rewrite get_set_sameE /= => z hz; rewrite get_setE.
by case: (z = y0) => // ->>; move: hy; rewrite hz.
qed.

local lemma RS_get_in m0 y0 : phoare [EA.RS.RO.get :
  EA.RS.RO.m = m0 /\ x = y0 /\ y0 \in m0 ==> res = oget m0.[y0] /\ EA.RS.RO.m = m0] = 1%r.
proof. by proc; auto => /> h; exact dB_ll. qed.

(* One iteration of the inner loop: the map [m3] extends [m] with the
   three bytes of the next chunk *)
local lemma step_inv m m3 x0 (vs : int list) b0 b1 b2 :
  vs = cands m x0 (size vs) =>
  (forall j', 0 <= j' < size vs => size (accs m x0 j') < n) =>
  (forall i, 0 <= i < 3 * size vs => (x0, i) \in m) =>
  size (accs m x0 (size vs)) < n =>
  ext m m3 =>
  m3.[(x0, 3 * size vs)] = Some b0 => m3.[(x0, 3 * size vs + 1)] = Some b1 =>
  m3.[(x0, 3 * size vs + 2)] = Some b2 =>
  let v = to_int b0 + 256 * to_int b1 + 65536 * (to_int b2 %% 128) in
  rcons vs v = cands m3 x0 (size vs + 1) /\
  (if v < q then rcons (accs m x0 (size vs)) v else accs m x0 (size vs)) =
    accs m3 x0 (size vs + 1) /\
  (forall j', 0 <= j' < size vs + 1 => size (accs m3 x0 j') < n) /\
  (forall i, 0 <= i < 3 * size vs + 3 => (x0, i) \in m3).
proof.
move=> hvs hlt hin hn he h0 h1 h2 /=.
have hj := List.size_ge0 vs.
have hc : cand m3 x0 (size vs) = to_int b0 + 256 * to_int b1 + 65536 * (to_int b2 %% 128).
- by rewrite /cand h0 h1 h2.
split; 1: by rewrite cands_S // (cands_ext m) // -hvs hc.
split; 1: by rewrite accs_S // (accs_ext m m3) // hc.
split.
- move=> j' hj'; case: (j' = size vs) => [->> | hne]; 1: by rewrite (accs_ext m).
  by rewrite (accs_ext m) 2:// 2:hlt; smt().
move=> i hi; case: (i < 3 * size vs) => hlt3; 1: by apply (ext_mem m); [| apply hin; smt()].
by rewrite domE; smt().
qed.

(* The first run of the inner loop on [x0] *)
local lemma poly_done x0 : hoare [ExpandA(XA.RO).poly : x = x0 ==> pdone XA.RO.m x0 res].
proof.
proc.
while (x = x0 /\ ctx = 3 * size vs /\ vs = cands XA.RO.m x0 (size vs) /\
       cs = accs XA.RO.m x0 (size vs) /\
       (forall j', 0 <= j' < size vs => size (accs XA.RO.m x0 j') < n) /\
       (forall i, 0 <= i < ctx => (x0, i) \in XA.RO.m)).
- wp; ecall (XA_get_ext XA.RO.m (x, ctx + 2)); ecall (XA_get_ext XA.RO.m (x, ctx + 1)).
  ecall (XA_get_ext XA.RO.m (x, ctx)).
  skip => &hr [#] -> -> hvs hcs hlt hin hn b0 m1 [h1 e1] b1 m2 [h2 e2] b2 m3 [h3 e3].
  have := step_inv XA.RO.m{hr} m3 x0 vs{hr} b0 b1 b2 hvs hlt hin _
            (ext_trans _ _ _ (ext_trans _ _ _ e1 e2) e3)
            (ext_some _ _ _ _ e3 (ext_some _ _ _ _ e2 h1)) (ext_some _ _ _ _ e3 h2) h3.
  + by rewrite -hcs.
  move=> /= [H1 [H2 [H3 H4]]]; rewrite size_rcons /=.
  by case: (to_int b0 + 256 * to_int b1 + 65536 * (to_int b2 %% 128) < q) => hv;
    move: H2; rewrite hv /= -hcs => H2; smt().
auto => /> &hr; split; 1: by rewrite /accs /cands mkseq0 /=; smt().
by move=> m vs hn hvs hlt hin; rewrite /pdone /=; smt().
qed.

(* The second run reads the same bytes *)
local lemma poly_rerun x0 m0 r0 : phoare [ExpandA(EA.RS.RO).poly :
  x = x0 /\ EA.RS.RO.m = m0 /\ pdone m0 x0 r0 ==> res = r0 /\ EA.RS.RO.m = m0] = 1%r.
proof.
proc; sp.
while (x = x0 /\ EA.RS.RO.m = m0 /\ pdone m0 x0 r0 /\ ctx = 3 * size vs /\
       vs = cands m0 x0 (size vs) /\ cs = accs m0 x0 (size vs) /\ size vs <= size r0.`2)
      (size r0.`2 - size vs).
- move=> z; exlim vs => vs0.
  wp; call (RS_get_in m0 (x0, 3 * size vs0 + 2)).
  call (RS_get_in m0 (x0, 3 * size vs0 + 1)); call (RS_get_in m0 (x0, 3 * size vs0)).
  skip => &hr /> hr0 hn0 hlt0 hin hvs hle hn.
  have hlt : size vs{hr} < size r0.`2.
  - by case: (size vs{hr} = size r0.`2) => heq; [move: hn; rewrite heq; smt() | smt()].
  have h0 : (x{hr}, 3 * size vs{hr}) \in EA.RS.RO.m{hr} by apply hin; smt(List.size_ge0).
  have h1 : (x{hr}, 3 * size vs{hr} + 1) \in EA.RS.RO.m{hr} by apply hin; smt(List.size_ge0).
  have h2 : (x{hr}, 3 * size vs{hr} + 2) \in EA.RS.RO.m{hr} by apply hin; smt(List.size_ge0).
  rewrite h0 h1 h2 /= size_rcons.
  rewrite cands_S ?List.size_ge0 accs_S ?List.size_ge0 -hvs /cand /EA.v_of /=.
  by split => hv; rewrite hv /=; smt().
skip => &hr /> hr0 hn0 hlt0 hin.
split; 1: by rewrite /accs /cands mkseq0 /=; smt(List.size_ge0).
move=> vs; split => [hvs hle hv | hn hvs hle].
- by rewrite (: size vs = size r0.`2) 1:/#; smt().
have heq : size vs = size r0.`2.
- case: (size vs < size r0.`2) => hlt; 2: smt().
  by have := hlt0 (size vs) _; [smt(List.size_ge0) | smt()].
by rewrite hr0 -heq -hvs.
qed.

(* ExpandA with its leakage, against the sampler and a second run of the
   inner loop for the leakage *)
local lemma ExpandA_ExpandASL : equiv [ExpandA(XA.RO).get ~
  ExpandASL(EA.SampleRq(EA.RS.RO), EA.RS.RO).get :
  ={rho} /\ XA.RO.m{1} = EA.RS.RO.m{2} ==> ={res} /\ XA.RO.m{1} = EA.RS.RO.m{2}].
proof.
proc.
while (={rho, r, mA, la} /\ XA.RO.m{1} = EA.RS.RO.m{2}); last by auto.
wp; while (={rho, r, s, mA, la} /\ XA.RO.m{1} = EA.RS.RO.m{2}); last by auto.
exlim rho{1}, r{1}, s{1} => rho0 r0 s0.
seq 1 1 : (={rho, r, s, mA, la, a} /\ XA.RO.m{1} = EA.RS.RO.m{2} /\
           (rho, r, s){1} = (rho0, r0, s0) /\ pdone XA.RO.m{1} (rho0, r0, s0) (a, vs){1}).
- call (: ={x} /\ x{1} = (rho0, r0, s0) /\ XA.RO.m{1} = EA.RS.RO.m{2} ==>
          res{1}.`1 = res{2} /\ XA.RO.m{1} = EA.RS.RO.m{2} /\
          pdone XA.RO.m{1} (rho0, r0, s0) res{1}).
  + by conseq poly_sample (poly_done (rho0, r0, s0)) _ => /> /#.
  by auto => /> _ [a vs] m /= h _ h1 h2; rewrite h /= => /#.
exlim XA.RO.m{1}, a{1}, vs{1} => m0 a0 vs0.
wp; call{2} (poly_rerun (rho0, r0, s0) m0 (a0, vs0)).
by auto => />.
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
  MLDSAGen(ExpandASL(EA.SampleRq(EA.RS.RO), EA.RS.RO), ChalH(SIB.XOF.RO, ROct.RO), ROmu.RO).sign :
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
proc; seq 5 5 : (={sk, m, ct, r0_fail, hint_fail, rho, tr, s1, s2, t0, mA, la} /\
  XA.RO.m{1} = EA.RS.RO.m{2} /\ ={SIB.XOF.RO.m, ROmu.RO.m, ROct.RO.m}).
+ by call ExpandA_ExpandASL; auto.
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

local lemma ISR_read x0 a0 m0 : phoare [EA.RS.ISR.sample :
  arg = x0 /\ EA.RS.IS.RO.m = m0 /\ m0.[x0] = Some a0 ==> res = a0 /\ EA.RS.IS.RO.m = m0] = 1%r.
proof. by proc; auto => /> h; rewrite dRq_ll /= domE h. qed.

(* The leakage of ExpandA: the same run on the two simulated XOFs *)
local lemma poly_ideal : equiv [ExpandA(EA.RS.Sim(EA.ReprogRq, EA.RS.ISR)).poly ~
  ExpandA(XASim).poly :
  ={x, EA.RS.Sim.Overlay.m, EA.RS.Sim.reprog} /\
  ra_inv EA.RS.IS.RO.m{1} RA.rho{2} RA.mA{2} RA.m{2} ==>
  ={res, EA.RS.Sim.Overlay.m, EA.RS.Sim.reprog} /\
  ra_inv EA.RS.IS.RO.m{1} RA.rho{2} RA.mA{2} RA.m{2}].
proof.
proc; wp; while (={x, cs, vs, ctx, EA.RS.Sim.Overlay.m, EA.RS.Sim.reprog} /\
                 ra_inv EA.RS.IS.RO.m{1} RA.rho{2} RA.mA{2} RA.m{2}); 2: by auto.
by wp; do 3! call Sim_get; auto.
qed.

local lemma ExpandASL_ideal : equiv [
  ExpandASL(EA.RS.ISR, EA.RS.Sim(EA.ReprogRq, EA.RS.ISR)).get ~ ExpandA(XASim).get :
  ={rho, EA.RS.Sim.Overlay.m, EA.RS.Sim.reprog} /\ rho{1} = RA.rho{2} /\
  size RA.mA{2} = (k, l) /\ ra_inv EA.RS.IS.RO.m{1} RA.rho{2} RA.mA{2} RA.m{2} ==>
  res{1} = (RA.mA{2}, res{2}.`2) /\ ={EA.RS.Sim.Overlay.m, EA.RS.Sim.reprog} /\
  ra_inv EA.RS.IS.RO.m{1} RA.rho{2} RA.mA{2} RA.m{2}].
proof.
proc.
while (={rho, r, la, EA.RS.Sim.Overlay.m, EA.RS.Sim.reprog} /\ rho{1} = RA.rho{2} /\
       size RA.mA{2} = (k, l) /\ ra_inv EA.RS.IS.RO.m{1} RA.rho{2} RA.mA{2} RA.m{2} /\
       size mA{1} = (k, l) /\ 0 <= r{1} <= k /\
       (forall i j, 0 <= i < r{1} => 0 <= j < l => mA{1}.[i, j] = RA.mA{2}.[i, j])).
- wp; while (={rho, r, s, la, EA.RS.Sim.Overlay.m, EA.RS.Sim.reprog} /\ rho{1} = RA.rho{2} /\
             size RA.mA{2} = (k, l) /\ ra_inv EA.RS.IS.RO.m{1} RA.rho{2} RA.mA{2} RA.m{2} /\
             size mA{1} = (k, l) /\ 0 <= r{1} < k /\ 0 <= s{1} <= l /\
             (forall i j, 0 <= i < k => 0 <= j < l => (i < r{1} \/ i = r{1} /\ j < s{1}) =>
                mA{1}.[i, j] = RA.mA{2}.[i, j])).
  + wp; call poly_ideal.
    exlim EA.RS.IS.RO.m{1}, rho{1}, r{1}, s{1}, RA.mA{2} => m0 rho0 r0 s0 mA0.
    call{1} (ISR_read (rho0, r0, s0) mA0.[r0, s0] m0).
    auto => /> &1 &2 hr hc hinv hrm hc' hr0 hrk hs0 _ hmA hsl.
    split; 1: by rewrite hinv /honest /= hr0 hrk hs0 hsl.
    move=> _ _ m1 mr _.
    rewrite rows_updm cols_updm hrm hc' /=; split; 1: smt().
    move=> i j hi0 hi hj0 hj hij; rewrite get_updm 1,2:/#.
    case: ((i, j) = (r0, s0)) => [[-> ->] // | hne].
    by apply hmA => //; smt().
  auto => /> &1 &2 hr hc hinv hrm hcm hr0 _ hmA hrk.
  split; 1: by split; [smt(gt0_l) | move=> i j *; apply hmA => /#].
  move=> m1 mA s m2 hs _ _ _ _ hs0 hsl hmA'; split; 1: smt().
  by move=> i j *; apply hmA' => /#.
auto => /> &1 &2 hr hc hinv; split; 1: smt(gt0_k gt0_l).
move=> m1 mA r m2 hr1 _ _ hrA hcA hr0 hrk hmA; apply eq_matrixP; split; 1: smt().
by move=> i j hij; apply hmA; smt().
qed.

local lemma sign_ideal : equiv [
  MLDSAGen(ExpandASL(EA.RS.ISR, EA.RS.Sim(EA.ReprogRq, EA.RS.ISR)),
           ChalH(SIB.XOF.RO, ROct.RO), ROmu.RO).sign ~
  MLDSAGen(MatRA, ChalH(SIB.XOF.RO, ROct.RO), ROmu.RO).sign :
  ={sk, m, EA.RS.Sim.Overlay.m, EA.RS.Sim.reprog} /\ sk{1}.`1 = RA.rho{2} /\
  size RA.mA{2} = (k, l) /\ ra_inv EA.RS.IS.RO.m{1} RA.rho{2} RA.mA{2} RA.m{2} /\
  ={SIB.XOF.RO.m, ROtr.RO.m, ROmu.RO.m, ROct.RO.m} ==>
  ={res, EA.RS.Sim.Overlay.m, EA.RS.Sim.reprog} /\
  ra_inv EA.RS.IS.RO.m{1} RA.rho{2} RA.mA{2} RA.m{2} /\
  ={SIB.XOF.RO.m, ROtr.RO.m, ROmu.RO.m, ROct.RO.m}].
proof.
proc; seq 5 5 : (={sk, m, ct, r0_fail, hint_fail, rho, tr, s1, s2, t0, mA, la} /\
  ={EA.RS.Sim.Overlay.m, EA.RS.Sim.reprog} /\
  ra_inv EA.RS.IS.RO.m{1} RA.rho{2} RA.mA{2} RA.m{2} /\
  ={SIB.XOF.RO.m, ROtr.RO.m, ROmu.RO.m, ROct.RO.m}).
+ inline{2} MatRA.get; wp.
  by call ExpandASL_ideal; auto => />.
by sim / (ra_inv EA.RS.IS.RO.m{1} RA.rho{2} RA.mA{2} RA.m{2}) :
  (={ct, response, leak, rho, la, EA.RS.Sim.Overlay.m, EA.RS.Sim.reprog,
     SIB.XOF.RO.m, ROtr.RO.m, ROmu.RO.m, ROct.RO.m}).
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
