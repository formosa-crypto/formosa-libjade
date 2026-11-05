require import AllCore Distr List IntDiv FSet FMap Leakage Byte Finite.
require import StdOrder.
import RealOrder.
require MLDSAProof_Collisions.

(** Hop G2 -> G3 of [doc/proof_overview.tex] (the challenge is a function of
    [(w1, mu)]): [hop_reduction]. The reduction [RedMLDSA(A)] simulates G2
    exactly as long as no collision is flagged. Its signing oracle hashes
    the message with [Hmu] and asks SimplifiedScheme for a signature of
    [mu]: the signing loop of [SD.DilithiumR] runs in lockstep with the one
    of [MLDSAGen(MatRA, ChalX, HmuB)] on the same random oracle and leaks
    the same items, from which [SignRed] decodes the streams consumed on
    the [c~] of the signer ([sign_red], [lt_rel]); the leakage of [rho]
    and of ExpandA is computed by running ExpandA on the simulated XOF of
    ExpandA, which the reduction runs itself ([rho] and [A] are public).
    Under [!HctT.bad], G2
    keeps the invariant [ginv]: the [XH] entries of the random oracle are
    injective commitment hashes, [tinv] maps an output to its preimage,
    the [c~] of the signer are hashes on signed [mu], [LX] has no entry on
    the other outputs, and every output is in [tinv] or [leakT]. With it,
    G2 accepts a forgery only on a [c~] of [tinv] which is not a [c~] of
    the signer; on it the simulated challenge XOF is the XOF of
    SimplifiedScheme on the preimage ([sib_xc_P]), and the verification of
    SimplifiedScheme recomputes the same challenge ([sib_det]). [B_bound]
    and [B_ll], the query bound and the termination of the reduction, are
    the hypotheses of [SD.DilithiumXOF_secure]. *)

abstract theory MLDSAProof_Reduction.

clone include MLDSAProof_Collisions.MLDSAProof_Collisions.
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
(* G2 -> G3: helpers                                                    *)
(* ==================================================================== *)

(* Support of the intermediate representation of challenges *)
local lemma sib_supp_dI (s idx : byte list) :
  size s = 8 => size idx = tau =>
  (forall i, 0 <= i < tau => to_int (nth witness idx i) <= 256 - tau + i) =>
  (s, idx) \in SD.SIB.dI.
proof. by move=> hs hidx hle; apply/SD.SIB.supp_dI. qed.

(* The challenges computed by SampleInBall are in the support of [dC tau]
   (through [dC_equiv]) *)
local hoare sib_dC (X <: SD.SIB.XOF_t) :
  SD.SIB.SampleInBall(X).get : true ==> res.`1 \in dC tau.
proof.
proc.
while (size signs = 8 /\ 256 - tau <= i <= 256 /\
       exists idx, size idx = i - (256 - tau) /\
         (forall k, 0 <= k < size idx => to_int (nth witness idx k) <= 256 - tau + k) /\
         challenge = SD.SIB.to_challenge_aux (signs, idx) (i - (256 - tau))).
- wp; while (j <= i => j = to_int byte); 1: by wp; call (: true); auto.
  auto => /> &h hs hi1 hi2 idx hsz hle hi3; split; 1: smt().
  move=> b j hji hj; split; 1: smt().
  exists (rcons idx b); rewrite size_rcons hsz /=; split; 1: ring.
  split; 1: by move=> k hk; rewrite nth_rcons; smt().
  have -> : i{h} + 1 - (256 - tau) = (i{h} - (256 - tau)) + 1 by ring.
  rewrite SD.SIB.to_challenge_auxS 1:/#.
  rewrite SD.SIB.to_challenge_aux_rcons 1:/# /=.
  rewrite /SD.SIB.to_challenge_body /= nth_rcons.
  have -> : j = to_int b by smt().
  have -> : 256 - tau + (i{h} - (256 - tau)) = i{h} by ring.
  have hs' : i{h} - (256 - tau) = size idx by smt().
  by rewrite hs' /= /SD.SIB.to_bool.
wp; while (size signs = ctx /\ 0 <= ctx <= 8); 1: by wp; call (: true); auto => />; smt(size_rcons).
auto => /> signs h1 h2 h3; have hs : size signs = 8 by smt().
split.
- rewrite hs /=; split; 1: smt(tau_bound).
  exists []; rewrite SD.SIB.to_challenge_aux0 //=; smt().
move=> i h4 _ h5 h6 idx h7 h8.
rewrite dC_equiv_SD /SD.SIB.dC supp_dmap; exists (signs, idx); split.
- apply sib_supp_dI => //; smt().
have -> : i - (256 - tau) = tau by smt().
by [].
qed.

(* On an output [c~] of [Hct], the simulated challenge XOF is the XOF of
   SimplifiedScheme on the preimage of [c~] *)

local op [opaque] inv_mu (m : (tr_t * M, mu_t) fmap) (bad : bool) =
  !bad => forall a b, a \in m => b \in m => m.[a] = m.[b] => a = b.

local lemma inv_mu_upd m bad x mu :
  inv_mu m bad => x \notin m => inv_mu m.[x <- mu] (bad \/ mu \in frng m).
proof.
rewrite /inv_mu => h hx; rewrite negb_or => -[hb hmu] a b; rewrite !mem_set !get_setE.
have {h} h := h hb.
have hn : forall c, c \in m => m.[c] <> Some mu.
- move=> c hc; apply/negP => heq; apply hmu; rewrite mem_frng rngE /=.
  by exists c.
case: (a = x) => [->> | hax] /=.
- case: (b = x) => [// | hbx] /= hb' heq; have := hn b hb'; by rewrite heq.
case: (b = x) => [->> | hbx] /= ha'.
- by move=> heq; have := hn a ha'; rewrite heq.
by move=> hb'; apply h.
qed.

local lemma fresh_mu (mm : (tr_t * M, mu_t) fmap) bad tr qs m :
  inv_mu mm bad => !bad => (forall m', m' \in qs => (tr, m') \in mm) =>
  (tr, m) \in mm => ! (m \in qs) =>
  ! (oget mm.[(tr, m)] \in map (fun m' => oget mm.[(tr, m')]) qs).
proof.
rewrite /inv_mu => h hb hqs hm hnq; apply/negP => /mapP [m' [hm' heq]] /=.
have hm'' := hqs m' hm'.
have := h hb (tr, m) (tr, m') hm hm'' _.
- by move: hm hm'' heq; rewrite !domE /=; case: (mm.[(tr, m')]); case: (mm.[(tr, m)]).
by move=> heq'; apply hnq; have <- : m' = m by move: heq'; case.
qed.

local module SKD = SD.DSSXOF.DS.Stateless.O_CMA_Default.

(* The leakage of SampleInBall has two items (the sign bytes, the pairs) *)
local hoare sib_sz (X <: SD.SIB.XOF_t) :
  SD.SIB.SampleInBall(X).get : true ==> size res.`2 = 2.
proof.
proc; while (true); 1: by wp; while (true); [wp; call (: true) | ]; auto.
by wp; while (true); [wp; call (: true) | ]; auto.
qed.

(* ---- Invariants of G2 (unary, under [!HctT.bad]) ---- *)

(* [c~] is the commitment hash of [x] in the random oracle of
   SimplifiedScheme *)
local op hm (m2 : (SD.xin, SD.xout) fmap) (x : high list * mu_t) (ct : ctilde) =
  m2.[SD.XH x] = Some (SD.OH ct).

(* The invariant of G2 that makes the reduction exact: on the [XH] part
   [m2] of the random oracle, the inverse table [ti] of [Hct], the streams
   [lt] of the [c~] of the signer, the local XOF [lx] and the list [qs] of
   the signed [mu]:
   - the [XH] entries are commitment hashes, and they are injective;
   - [ti] maps an output to its preimage;
   - the [c~] of the signer are outputs on a signed [mu];
   - [lx] has no entry on an output which is not a [c~] of the signer;
   - every output is in [ti] or in [lt]. *)
local op [opaque] ginv (m2 : (SD.xin, SD.xout) fmap) (ti : (ctilde, high list * mu_t) fmap)
  (lt : (ctilde, byte list) fmap) (lx : (ctilde * int, byte) fmap) (qs : mu_t list) =
  (forall x o, m2.[SD.XH x] = Some o => o = SD.OH (SD.oh o)) /\
  (forall x x' ct, hm m2 x ct => hm m2 x' ct => x = x') /\
  (forall ct x, ti.[ct] = Some x => hm m2 x ct) /\
  (forall ct, ct \in lt => exists x, hm m2 x ct /\ x.`2 \in qs) /\
  (forall ct i x, (ct, i) \in lx => hm m2 x ct => ct \in lt) /\
  (forall x ct, hm m2 x ct => ct \in ti \/ ct \in lt).

local lemma ginv_init : ginv empty empty empty empty [].
proof. by rewrite /ginv /hm; smt(emptyE mem_empty). qed.

local lemma ginv_xh m2 m2' ti lt lx qs :
  (forall x, m2'.[SD.XH x] = m2.[SD.XH x]) =>
  ginv m2 ti lt lx qs => ginv m2' ti lt lx qs.
proof.
rewrite /ginv => h; have e : forall x ct, hm m2' x ct = hm m2 x ct by move=> x ct; rewrite /hm h.
by move=> [# h0 h1 h2 h3 h4 h5]; do! split; smt().
qed.

local lemma ginv_qs m2 ti lt lx qs qs' :
  (forall mu, mu \in qs => mu \in qs') =>
  ginv m2 ti lt lx qs => ginv m2 ti lt lx qs'.
proof. by rewrite /ginv => hq [# h0 h1 h2 h3 h4 h5]; do! split => //; smt(). qed.

local lemma ginv_lx m2 ti lt lx qs (y : ctilde * int) b :
  ginv m2 ti lt lx qs => (y.`1 \in lt \/ y.`1 \notin ti) =>
  ginv m2 ti lt lx.[y <- b] qs.
proof.
rewrite /ginv => [# h0 h1 h2 h3 h4 h5] hy; do! split => //.
move=> ct i x; rewrite mem_set => -[hi | hy'] hx; 1: exact: (h4 _ _ _ hi hx).
by have := h5 _ _ hx; smt().
qed.

(* Shape of the [XH] entries of the random oracle *)
local lemma ginv_oh m2 ti lt lx qs x :
  ginv m2 ti lt lx qs => SD.XH x \in m2 => hm m2 x (SD.oh (oget m2.[SD.XH x])).
proof.
rewrite /ginv /hm => -[h0 _]; rewrite domE; case _ : (m2.[SD.XH x]) => // o ho _.
by rewrite (h0 _ _ ho).
qed.

(* A fresh output of [Hct], not an output and not in [lx] *)
local lemma ginv_fresh m2 ti lt lx qs x ct :
  ginv m2 ti lt lx qs => SD.XH x \notin m2 => !hrng m2 ct =>
  !(exists i, (ct, i) \in lx) =>
  (forall x' ct', hm m2.[SD.XH x <- SD.OH ct] x' ct' <=> (hm m2 x' ct' \/ (x' = x /\ ct' = ct))) /\
  ct \notin ti /\ !(exists x', hm m2 x' ct).
proof.
rewrite /ginv /hm /hrng => [# h0 h1 h2 h3 h4 h5] hx hct hlx.
have hn : !(exists x', m2.[SD.XH x'] = Some (SD.OH ct)) by smt().
do! split.
- move=> x' ct'; rewrite get_setE; case: (x' = x) => [->> /= | /#].
  by move: hx; rewrite domE => /= ->.
- by apply/negP => /domE; case _ : (ti.[ct]) => // x' /h2; smt().
by smt().
qed.

(* The adversary's query to [Hct] *)
local lemma ginv_get_fresh m2 ti lt lx qs x ct :
  ginv m2 ti lt lx qs => SD.XH x \notin m2 => !hrng m2 ct =>
  !(exists i, (ct, i) \in lx) =>
  ginv m2.[SD.XH x <- SD.OH ct] ti.[ct <- x] lt lx qs.
proof.
move=> hI hx hct hlx; have [hE [hti hn]] := ginv_fresh _ _ _ _ _ _ _ hI hx hct hlx.
move: hI; rewrite /ginv => [# h0 h1 h2 h3 h4 h5]; do! split.
- by move=> x' o; rewrite get_setE; case: (SD.XH x' = SD.XH x) => _ /=; [move=> <- | apply h0].
- by move=> x1 x2 ct'; rewrite !hE; smt().
- by move=> ct' x'; rewrite get_setE hE; case: (ct' = ct) => [-> /= <- // | _ /h2 -> //].
- by move=> ct' /h3 [x' [hx' hq]]; exists x'; rewrite hE hx' hq.
- by move=> ct' i x'; rewrite hE => hi [/(h4 _ _ _ hi) // | [_ ->>]]; smt().
by move=> x' ct'; rewrite hE mem_set => -[/h5 | [_ ->]]; smt().
qed.

local lemma ginv_get_old m2 ti lt lx qs x :
  ginv m2 ti lt lx qs => SD.XH x \in m2 =>
  let ct = SD.oh (oget m2.[SD.XH x]) in
  ginv m2 (if ct \notin ti then ti.[ct <- x] else ti) lt lx qs.
proof.
move=> hI hx /=; have hh := ginv_oh _ _ _ _ _ _ hI hx.
case: (SD.oh (oget m2.[SD.XH x]) \in ti) => //= hn.
move: hI; rewrite /ginv => [# h0 h1 h2 h3 h4 h5]; do! split => //.
- move=> ct' x'; rewrite get_setE.
  by case: (ct' = SD.oh (oget m2.[SD.XH x])) => [->> /= <<- // | _ /h2].
by move=> x' ct'; rewrite mem_set => /h5; smt().
qed.

(* The query of the signer to [Hct], then the stream consumed on [c~] *)
local lemma ginv_sign_fresh m2 ti lt lx qs x ct s :
  ginv m2 ti lt lx qs => SD.XH x \notin m2 => !hrng m2 ct =>
  !(exists i, (ct, i) \in lx) => x.`2 \in qs =>
  ginv m2.[SD.XH x <- SD.OH ct] ti lt.[ct <- s] lx qs.
proof.
move=> hI hx hct hlx hq; have [hE [hti hn]] := ginv_fresh _ _ _ _ _ _ _ hI hx hct hlx.
move: hI; rewrite /ginv => [# h0 h1 h2 h3 h4 h5]; do! split.
- by move=> x' o; rewrite get_setE; case: (SD.XH x' = SD.XH x) => _ /=; [move=> <- | apply h0].
- by move=> x1 x2 ct'; rewrite !hE; smt().
- by move=> ct' x' /h2 h; rewrite hE h.
- move=> ct'; rewrite mem_set => -[/h3 [x' [hx' hq']] | ->>].
  + by exists x'; rewrite hE hx' hq'.
  by exists x; rewrite hE.
- by move=> ct' i x' hi; rewrite mem_set hE => -[/(h4 _ _ _ hi) -> // | [_ ->]].
by move=> x' ct'; rewrite hE mem_set => -[/h5 | [_ ->]]; smt().
qed.

local lemma ginv_sign_old m2 ti lt lx qs x s :
  ginv m2 ti lt lx qs => SD.XH x \in m2 => x.`2 \in qs =>
  ginv m2 ti lt.[SD.oh (oget m2.[SD.XH x]) <- s] lx qs.
proof.
move=> hI hx hq; have hh := ginv_oh _ _ _ _ _ _ hI hx.
move: hI; rewrite /ginv => [# h0 h1 h2 h3 h4 h5]; do! split => //.
- move=> ct'; rewrite mem_set => -[/h3 // | ->>].
  by exists x.
- by move=> ct' i x' hi hx'; rewrite mem_set (h4 _ _ _ hi hx').
by move=> x' ct'; rewrite mem_set => /h5; smt().
qed.
(* ---- Decoding of the leakage of the signing loop by [SignRed] ---- *)

(* The failing values of the tests are non-negative (range axioms) *)
local op okf (o : int option) = forall i, o = Some i => 0 <= i.

(* [pstep] over the items of one iteration *)
local lemma pstep_iter (st : int * ctilde * decl * (ctilde, byte list) fmap)
  ct (lc : leakage) c zf rf hf :
  st.`1 = 0 => size lc = 2 => okf zf => (zf = None => okf rf) =>
  (zf = None => rf = None => okf hf) =>
  foldl pstep st (ct_leak ct ++ lc ++ c_leak c ++ oileak zf ++
                  (if zf = None then oileak rf ++ (if rf = None then oileak hf else [])
                   else []))
  = (0, ct, head witness lc, st.`4.[ct <- SD.SIB.leak_to_stream lc]).
proof.
case: st => ph ct0 b0 m /= ->.
case: lc => [|d1 [|d2 [|d3 l]]] //=; 2: by move=> h; have : false by smt(List.size_ge0).
move=> hz hr hh.
have hct : ct_dec (SD.SIB.decl_to_ints (List (map Int (ct_enc ct)))) = ct.
- by rewrite /= -map_comp /(\o) /= map_id ct_encK.
rewrite /ct_leak /c_leak /oileak /= /pstep /= hct /=.
case: zf hz hr hh => [|i] hz hr hh /=; last first.
- by have := hz i; rewrite (: i <> -1) 1:/#.
case: rf hr hh => [|i] hr hh /=; last first.
- by have := hr _ i => //; rewrite (: i <> -1) 1:/#.
by [].
qed.

(* The table of the streams of the signer ([lt]) is the one decoded from
   the leakage [l] (which starts with [t0_leak t0]) from the table [lt0] *)
local op [opaque] lt_rel (lt0 lt : (ctilde, byte list) fmap) (l : leakage) =
  l <> [] /\ exists ct b, foldl pstep (0, witness, witness, lt0) (behead l) = (0, ct, b, lt).

local lemma lt_rel_init lt0 t0 : lt_rel lt0 lt0 (t0_leak t0).
proof. by rewrite /lt_rel /t0_leak /=; exists witness witness. qed.

local lemma lt_rel_iter lt0 lt l ct (lc : leakage) c zf rf hf :
  lt_rel lt0 lt l => size lc = 2 => okf zf => (zf = None => okf rf) =>
  (zf = None => rf = None => okf hf) =>
  lt_rel lt0 lt.[ct <- SD.SIB.leak_to_stream lc]
    (l ++ ct_leak ct ++ lc ++ c_leak c ++ oileak zf ++
     (if zf = None then oileak rf ++ (if rf = None then oileak hf else []) else [])).
proof.
rewrite /lt_rel; case: l => // d l [_ [ct0 b0 h]] hs hz hr hh /=.
exists ct (head witness lc).
by rewrite -!catA foldl_cat h /= !catA pstep_iter.
qed.

local lemma lt_rel_upd lt0 lt l : lt_rel lt0 lt l => upd_leakT lt0 (behead l) = lt.
proof. by rewrite /lt_rel /upd_leakT => -[_ [ct b ->]]. qed.

(* ---- Determinism of SampleInBall over the random oracle of
        SimplifiedScheme, through the functional characterisation
        [sample_indices] of SampleInBallEquiv ---- *)
local op sib_out (y : SD.SIB.challenge_ir * SD.SIB.rej_ir) : Rq * leakage =
  (to_concrete (SD.SIB.to_challenge y.`1), SD.SIB.sib_leak y.`1 y.`2).

local op [opaque] sib_det_pred (x : SD.SIB.in_t) (m : (SD.xin, SD.xout) fmap)
                (r : Rq * leakage) =
  exists log y,
    (forall a b, (a, b) \in log => (xbproj m).[a] = Some b) /\
    SD.SIB.sample_indices log x = Some y /\ r = sib_out y.

local module WLog = {
  proc run(x : SD.SIB.in_t) = {
    var r;
    SD.SIB.RR.F1.RO.m <- xbproj SD.XOF.m;
    r <@ SD.SIB.RR.F1.Op_sample_game(SD.SIB.SampleIndices).sample(x);
    return r;
  }
}.

(* A byte query, against the logged lazy random oracle on the projection *)
local equiv xb_log (m0 : (SD.xin, SD.xout) fmap) :
  SD.XofOf(SD.XOF).get ~ SD.SIB.RR.F1.LogRO.get :
  ={arg} /\ xbproj SD.XOF.m{1} = SD.SIB.RR.F1.RO.m{2} /\
  (forall x, SD.XOF.m{1}.[SD.XH x] = m0.[SD.XH x]) /\
  (forall a b, (a, b) \in SD.SIB.RR.F1.LogRO.log{2} => SD.SIB.RR.F1.RO.m{2}.[a] = Some b) ==>
  ={res} /\ xbproj SD.XOF.m{1} = SD.SIB.RR.F1.RO.m{2} /\
  (forall x, SD.XOF.m{1}.[SD.XH x] = m0.[SD.XH x]) /\
  (forall a b, (a, b) \in SD.SIB.RR.F1.LogRO.log{2} => SD.SIB.RR.F1.RO.m{2}.[a] = Some b).
proof.
proc; inline *; wp.
rnd SD.ob SD.OB; auto => /> &1 &2 hxh hlog; split => [b _ | _]; 1: by rewrite mu1_dOB.
move=> o ho; rewrite dB_full /= -(supp_dOB _ ho) /=.
rewrite xbproj_mem !get_set_sameE /=; case: (SD.XB x{2} \in SD.DSSXOF.PRO.RO.m{1}) => //= hx.
- have [o' ho'] : exists o', SD.DSSXOF.PRO.RO.m{1}.[SD.XB x{2}] = Some o'.
  + by move: hx; rewrite domE; case: (SD.DSSXOF.PRO.RO.m{1}.[SD.XB x{2}]) => // o' _; exists o'.
  rewrite xbprojE ho' /= => a b; rewrite mem_rcons /= => -[[-> ->] | /hlog //].
  by rewrite xbprojE ho'.
rewrite xbproj_set /=; split; 1: by move=> x; rewrite get_setE /= hxh.
move=> a b; rewrite mem_rcons /= => -[[-> ->] | ha]; 1: by rewrite get_set_sameE.
have := hlog _ _ ha; rewrite get_setE; case: (a = x{2}) => // ->> h.
by move: hx; rewrite -xbproj_mem domE h.
qed.

local equiv sib_log (m0 : (SD.xin, SD.xout) fmap) :
  SD.SIB.SampleInBall(SD.XofOf(SD.XOF)).get ~ WLog.run :
  ={arg, SD.XOF.m} /\ (forall x, SD.XOF.m{1}.[SD.XH x] = m0.[SD.XH x]) ==>
  res{1} = sib_out res{2}.`2 /\
  xbproj SD.XOF.m{1} = SD.SIB.RR.F1.RO.m{2} /\
  (forall x, SD.XOF.m{1}.[SD.XH x] = m0.[SD.XH x]) /\
  (forall x, SD.XOF.m{2}.[SD.XH x] = m0.[SD.XH x]) /\
  (forall a b, (a, b) \in res{2}.`1 => SD.SIB.RR.F1.RO.m{2}.[a] = Some b).
proof.
proc; inline WLog.run SD.SIB.RR.F1.Op_sample_game(SD.SIB.SampleIndices).sample
  SD.SIB.SampleIndices(SD.SIB.RR.F1.LogRO).sample; wp.
while (={i, signs, ctx, byte} /\ x{1} = x1{2} /\
       xbproj SD.XOF.m{1} = SD.SIB.RR.F1.RO.m{2} /\
       (forall x, SD.XOF.m{1}.[SD.XH x] = m0.[SD.XH x]) /\
       (forall x, SD.XOF.m{2}.[SD.XH x] = m0.[SD.XH x]) /\
       (forall a b, (a, b) \in SD.SIB.RR.F1.LogRO.log{2} =>
                    SD.SIB.RR.F1.RO.m{2}.[a] = Some b) /\
       (i <= 256 /\ size indices = i - (256 - tau) /\ size rej = size indices){2} /\
       challenge{1} = (SD.SIB.to_challenge_aux (signs, indices) (i - (256 - tau))){2} /\
       leak{1} = (SD.SIB.full_pairs (signs, indices) rej).`2{2} /\
       ctx{2} = (SD.SIB.full_pairs (signs, indices) rej).`1{2}).
+ wp.
  while (={i, j, ctx, signs, byte} /\ x{1} = x1{2} /\
         xbproj SD.XOF.m{1} = SD.SIB.RR.F1.RO.m{2} /\
         (forall x, SD.XOF.m{1}.[SD.XH x] = m0.[SD.XH x]) /\
         (forall x, SD.XOF.m{2}.[SD.XH x] = m0.[SD.XH x]) /\
         (forall a b, (a, b) \in SD.SIB.RR.F1.LogRO.log{2} =>
                      SD.SIB.RR.F1.RO.m{2}.[a] = Some b) /\
         (j <= i => j = to_int byte){2} /\
         (i < 256 /\ size indices = i - (256 - tau) /\ size rej = size indices){2} /\
         leak{1} = (SD.SIB.full_pairs (signs, indices) rej).`2{2} ++
                   (if i < j then zip (iota_ ((SD.SIB.full_pairs (signs, indices) rej).`1 + 1)
                                             (size rejc)) rejc
                    else SD.SIB.seg (SD.SIB.full_pairs (signs, indices) rej).`1 rejc j){2} /\
         ctx{2} = (SD.SIB.full_pairs (signs, indices) rej).`1{2} + size rejc{2} +
                  (if i < j then 0 else 1){2}).
  + wp; call (xb_log m0); auto => /> &1 &2 _ _ hlog hj hi hsz1 hsz2 hij r1 m1 m2 hxm hlog2.
    rewrite /SD.SIB.seg.
    have hA : forall (a b : int), a + 1 + b = a + b + 1 by smt().
    case: (i{2} < to_int r1) => /= _;
      rewrite ?size_rcons !SD.SIB.zip_iota_rcons rcons_cat hA //.
    by rewrite addzA.
  auto => /> &1 &2 _ _ hlog hi hsz1 hsz2 hlt.
  have -> /= : i{2} < i{2} + 1 by smt().
  rewrite iota0 // cats0 /=; split; 1: smt().
  move=> m_L log_R b j rejc hji _ hxm hlog' hj.
  have {hj} hj := hj _; 1: smt().
  rewrite SD.SIB.full_pairs_rcons 1:/# /=.
  split; 1: smt(size_rcons).
  have -> /= : i{2} + 1 - (256 - tau) = (i{2} - (256 - tau)) + 1 by ring.
  rewrite -hj /=.
  rewrite SD.SIB.to_challenge_auxS; 1: by rewrite -hsz1 List.size_ge0.
  rewrite SD.SIB.to_challenge_aux_rcons 1:/# /=.
  rewrite /SD.SIB.to_challenge_body /= nth_rcons.
  have -> : 256 - tau + (i{2} - (256 - tau)) = i{2} by ring.
  have hs : i{2} - (256 - tau) = size indices{2} by smt().
  by rewrite hs /= /SD.SIB.to_bool hj.
wp; while (={signs, ctx, byte} /\ x{1} = x1{2} /\
           xbproj SD.XOF.m{1} = SD.SIB.RR.F1.RO.m{2} /\
           (forall x, SD.XOF.m{1}.[SD.XH x] = m0.[SD.XH x]) /\
           (forall x, SD.XOF.m{2}.[SD.XH x] = m0.[SD.XH x]) /\
           (forall a b, (a, b) \in SD.SIB.RR.F1.LogRO.log{2} =>
                        SD.SIB.RR.F1.RO.m{2}.[a] = Some b) /\ ctx{1} <= 8).
+ by wp; call (xb_log m0); auto => /> /#.
auto => /> &2 _ m_L log_R ctx signs h1 _ _ hlog h2.
have ->> /= : ctx = 8 by smt().
split; 1: by rewrite SD.SIB.to_challenge_aux0 // /SD.SIB.full_pairs /=; smt(tau_bound).
move=> m2 log2 i idx rej _ hi _ hlog2 hi2 hsz1 hsz2.
have -> : i - (256 - tau) = tau by smt().
by rewrite /sib_out /SD.SIB.to_challenge /SD.SIB.sib_leak /SD.SIB.full_leak.
qed.

local hoare wlog_h x0 :
  WLog.run : arg = x0 ==> SD.SIB.sample_indices res.`1 x0 = Some res.`2.
proof. by proc; call (SD.SIB.SampleIndices_OpSampleGame x0); auto. qed.

(* A run of SampleInBall on [x0] leaves the random oracle in a state from
   which a new run on [x0] gives the same result ([sib_det]); the [XH]
   part of the random oracle is not modified *)
local equiv sib_P x0 (m0 : (SD.xin, SD.xout) fmap) :
  SD.SIB.SampleInBall(SD.XofOf(SD.XOF)).get ~ SD.SIB.SampleInBall(SD.XofOf(SD.XOF)).get :
  ={arg, SD.XOF.m} /\ arg{2} = x0 /\ (forall x, SD.XOF.m{1}.[SD.XH x] = m0.[SD.XH x]) ==>
  ={res} /\ (forall x, SD.XOF.m{1}.[SD.XH x] = m0.[SD.XH x]) /\
  (forall x, SD.XOF.m{2}.[SD.XH x] = m0.[SD.XH x]) /\
  sib_det_pred x0 SD.XOF.m{2} res{2}.
proof.
transitivity WLog.run
  (={arg, SD.XOF.m} /\ (forall x, SD.XOF.m{1}.[SD.XH x] = m0.[SD.XH x]) ==>
   res{1} = sib_out res{2}.`2 /\ (forall x, SD.XOF.m{1}.[SD.XH x] = m0.[SD.XH x]))
  (={arg, SD.XOF.m} /\ arg{2} = x0 /\ (forall x, SD.XOF.m{1}.[SD.XH x] = m0.[SD.XH x]) ==>
   res{2} = sib_out res{1}.`2 /\ (forall x, SD.XOF.m{2}.[SD.XH x] = m0.[SD.XH x]) /\
   xbproj SD.XOF.m{2} = SD.SIB.RR.F1.RO.m{1} /\
   (forall a b, (a, b) \in res{1}.`1 => SD.SIB.RR.F1.RO.m{1}.[a] = Some b) /\
   SD.SIB.sample_indices res{1}.`1 x0 = Some res{1}.`2).
- by move=> &1 &2 h; exists SD.XOF.m{1} arg{1}; smt().
- move=> &1 &m &2 [-> h1] [# -> h2 h3 h4 h5] /=; do! split => //.
  by rewrite /sib_det_pred; exists res{m}.`1 res{m}.`2; rewrite h3.
- by conseq (sib_log m0) => /#.
symmetry; conseq (sib_log m0) _ (wlog_h x0) => /#.
qed.

local lemma sib_det r0 :
  phoare [ SD.SIB.SampleInBall(SD.XofOf(SD.XOF)).get :
           sib_det_pred arg SD.XOF.m r0 ==> res = r0 ] = 1%r.
proof.
bypr => &m; split => //; rewrite /sib_det_pred => -[log y [hlog [hsi ->]]].
have h1 : Pr[WLog.run(arg{m}) @ &m :
             (res.`1 = log /\ SD.SIB.RR.F1.RO.m = xbproj SD.XOF.m{m}) /\
             SD.SIB.sample_indices res.`1 arg{m} = Some res.`2] = 1%r.
- byphoare (_ : arg = arg{m} /\ SD.XOF.m = SD.XOF.m{m} ==> _) => //.
  proc; call (_ : (forall a b, (a, b) \in log => SD.SIB.RR.F1.RO.m.[a] = Some b) /\
                  SD.SIB.sample_indices log x = Some y /\ x = arg{m} /\
                  SD.SIB.RR.F1.RO.m = xbproj SD.XOF.m{m} ==>
                  (res.`1 = log /\ SD.SIB.RR.F1.RO.m = xbproj SD.XOF.m{m}) /\
                  SD.SIB.sample_indices res.`1 arg{m} = Some res.`2).
  + by conseq (SD.SIB.SampleIndices_OpSampleGameFun log y (xbproj SD.XOF.m{m}))
              (SD.SIB.SampleIndices_OpSampleGame arg{m}) => /#.
  by auto.
have h2 : Pr[WLog.run(arg{m}) @ &m :
             (res.`1 = log /\ SD.SIB.RR.F1.RO.m = xbproj SD.XOF.m{m}) /\
             SD.SIB.sample_indices res.`1 arg{m} = Some res.`2] <=
          Pr[SD.SIB.SampleInBall(SD.XofOf(SD.XOF)).get(arg{m}) @ &m : res = sib_out y].
- byequiv (_ : ={arg, SD.XOF.m} /\ SD.XOF.m{2} = SD.XOF.m{m} ==> _) => //.
  by symmetry; conseq (sib_log SD.XOF.m{m}) => /#.
have h3 : Pr[SD.SIB.SampleInBall(SD.XofOf(SD.XOF)).get(arg{m}) @ &m : res = sib_out y] <= 1%r.
- by byphoare => //.
smt().
qed.

(* SampleInBall over the random oracle of SimplifiedScheme does not modify
   its [XH] part *)
local hoare sib_xh (m0 : (SD.xin, SD.xout) fmap) :
  SD.SIB.SampleInBall(SD.XofOf(SD.XOF)).get :
  forall x, SD.XOF.m.[SD.XH x] = m0.[SD.XH x] ==>
  forall x, SD.XOF.m.[SD.XH x] = m0.[SD.XH x].
proof.
proc; while (forall x, SD.XOF.m.[SD.XH x] = m0.[SD.XH x]).
- wp; while (forall x, SD.XOF.m.[SD.XH x] = m0.[SD.XH x]); 2: by auto.
  by inline *; auto => />; smt(get_setE).
wp; while (forall x, SD.XOF.m.[SD.XH x] = m0.[SD.XH x]); 2: by auto.
by inline *; auto => />; smt(get_setE).
qed.

(* The challenge of the signing loop, with its support and the size of its
   leakage *)
local equiv sib_eq (m0 : (SD.xin, SD.xout) fmap) :
  SD.SIB.SampleInBall(SD.XofOf(SD.XOF)).get ~ SD.SIB.SampleInBall(SD.XofOf(SD.XOF)).get :
  ={arg, SD.XOF.m} /\ (forall x, SD.XOF.m{1}.[SD.XH x] = m0.[SD.XH x]) ==>
  ={res, SD.XOF.m} /\ res{1}.`1 \in dC tau /\ size res{1}.`2 = 2 /\
  (forall x, SD.XOF.m{1}.[SD.XH x] = m0.[SD.XH x]).
proof.
conseq (_: ={arg, SD.XOF.m} ==> ={res, SD.XOF.m})
       (: (forall x, SD.XOF.m.[SD.XH x] = m0.[SD.XH x]) ==>
          res.`1 \in dC tau /\ size res.`2 = 2 /\
          (forall x, SD.XOF.m.[SD.XH x] = m0.[SD.XH x])) _ => //; 2: by sim.
conseq (sib_dC (SD.XofOf(SD.XOF)))
       (: (forall x, SD.XOF.m.[SD.XH x] = m0.[SD.XH x]) ==>
          size res.`2 = 2 /\ (forall x, SD.XOF.m.[SD.XH x] = m0.[SD.XH x])) => //.
by conseq (sib_sz (SD.XofOf(SD.XOF))) (sib_xh m0).
qed.

(* ---- The simulated challenge XOF ---- *)

(* On an output [c~] of [Hct] for the adversary which is not a [c~] of the
   signer and has no entry in [LX], the simulated challenge XOF is the XOF
   of SimplifiedScheme on the preimage of [c~] *)
local equiv xc_xof ct0 :
  XCSim(SD.XOF).get ~ SD.XofOf(SD.XOF).get :
  y{1}.`1 = ct0 /\ ct0 \in HctT.tinv{1} /\ y{2} = (oget HctT.tinv{1}.[ct0], y{1}.`2) /\
  ct0 \notin HctT.leakT{1} /\ (forall i, (ct0, i) \notin LX.RO.m{1}) /\ ={SD.XOF.m} ==>
  ={res, SD.XOF.m} /\ (forall i, (ct0, i) \notin LX.RO.m{1}).
proof.
proc; rcondf{1} 1; 1: by auto => /> &hr; smt().
rcondf{1} 1; 1: by auto => />.
rcondt{1} 1; 1: by auto => />.
by inline *; auto => />.
qed.

local equiv sib_xc_xof ct0 :
  SIB.SampleInBall(XCSim(SD.XOF)).get ~ SD.SIB.SampleInBall(SD.XofOf(SD.XOF)).get :
  arg{1} = ct0 /\ ct0 \in HctT.tinv{1} /\ arg{2} = oget HctT.tinv{1}.[ct0] /\
  ct0 \notin HctT.leakT{1} /\ (forall i, (ct0, i) \notin LX.RO.m{1}) /\ ={SD.XOF.m} ==>
  ={res, SD.XOF.m}.
proof.
proc.
while (={i, ctx, signs, challenge, leak, SD.XOF.m} /\ x{1} = ct0 /\
       ct0 \in HctT.tinv{1} /\ x{2} = oget HctT.tinv{1}.[ct0] /\
       ct0 \notin HctT.leakT{1} /\ (forall i, (ct0, i) \notin LX.RO.m{1})).
- wp; while (={i, j, ctx, signs, challenge, leak, SD.XOF.m} /\ x{1} = ct0 /\
             ct0 \in HctT.tinv{1} /\ x{2} = oget HctT.tinv{1}.[ct0] /\
             ct0 \notin HctT.leakT{1} /\ (forall i, (ct0, i) \notin LX.RO.m{1})).
  + by wp; call (xc_xof ct0); auto.
  by auto => />; rewrite /SIB.to_bool /SD.SIB.to_bool /SIB.to_bool_list /SD.SIB.to_bool_list.
wp; while (={ctx, signs, SD.XOF.m} /\ x{1} = ct0 /\
           ct0 \in HctT.tinv{1} /\ x{2} = oget HctT.tinv{1}.[ct0] /\
           ct0 \notin HctT.leakT{1} /\ (forall i, (ct0, i) \notin LX.RO.m{1})).
- by wp; call (xc_xof ct0); auto.
by auto => />.
qed.

(* [sib_xc_xof] composed with [sib_P] *)
local equiv sib_xc_P ct0 x0 (m0 : (SD.xin, SD.xout) fmap) :
  SIB.SampleInBall(XCSim(SD.XOF)).get ~ SD.SIB.SampleInBall(SD.XofOf(SD.XOF)).get :
  arg{1} = ct0 /\ ct0 \in HctT.tinv{1} /\ x0 = oget HctT.tinv{1}.[ct0] /\ arg{2} = x0 /\
  ct0 \notin HctT.leakT{1} /\ (forall i, (ct0, i) \notin LX.RO.m{1}) /\ ={SD.XOF.m} /\
  (forall x, SD.XOF.m{1}.[SD.XH x] = m0.[SD.XH x]) ==>
  ={res} /\ (forall x, SD.XOF.m{1}.[SD.XH x] = m0.[SD.XH x]) /\
  (forall x, SD.XOF.m{2}.[SD.XH x] = m0.[SD.XH x]) /\ sib_det_pred x0 SD.XOF.m{2} res{2}.
proof.
transitivity SD.SIB.SampleInBall(SD.XofOf(SD.XOF)).get
  (arg{1} = ct0 /\ ct0 \in HctT.tinv{1} /\ arg{2} = oget HctT.tinv{1}.[ct0] /\
   ct0 \notin HctT.leakT{1} /\ (forall i, (ct0, i) \notin LX.RO.m{1}) /\ ={SD.XOF.m} ==>
   ={res, SD.XOF.m})
  (={arg, SD.XOF.m} /\ arg{2} = x0 /\ (forall x, SD.XOF.m{1}.[SD.XH x] = m0.[SD.XH x]) ==>
   ={res} /\ (forall x, SD.XOF.m{1}.[SD.XH x] = m0.[SD.XH x]) /\
   (forall x, SD.XOF.m{2}.[SD.XH x] = m0.[SD.XH x]) /\ sib_det_pred x0 SD.XOF.m{2} res{2}).
- by move=> &1 &2 h; exists SD.XOF.m{1} x0; smt().
- by move=> &1 &m &2 [-> ->] [-> [h1 [h2 h3]]].
- exact (sib_xc_xof ct0).
exact (sib_P x0 m0).
qed.

(* Off the case of [sib_xc_P], SampleInBall over the simulated challenge
   XOF does not modify the [XH] part of the random oracle, and queries
   [LX] on [(c~, 0)] when [c~] is neither an output of [Hct] for the
   adversary nor a [c~] of the signer *)
local hoare sib_xc_h ct0 (m0 : (SD.xin, SD.xout) fmap) :
  SIB.SampleInBall(XCSim(SD.XOF)).get :
  arg = ct0 /\ (forall x, SD.XOF.m.[SD.XH x] = m0.[SD.XH x]) ==>
  (forall x, SD.XOF.m.[SD.XH x] = m0.[SD.XH x]) /\
  (ct0 \notin HctT.tinv /\ ct0 \notin HctT.leakT => (ct0, 0) \in LX.RO.m).
proof.
proc.
while (x = ct0 /\ (forall x, SD.XOF.m.[SD.XH x] = m0.[SD.XH x]) /\
       (ct0 \notin HctT.tinv /\ ct0 \notin HctT.leakT => (ct0, 0) \in LX.RO.m)).
- wp; while (x = ct0 /\ (forall x, SD.XOF.m.[SD.XH x] = m0.[SD.XH x]) /\
             (ct0 \notin HctT.tinv /\ ct0 \notin HctT.leakT => (ct0, 0) \in LX.RO.m)).
  + inline *; sp 1; if; 1: by auto => />; smt(mem_set).
    if; 1: by auto.
    by if; auto => />; smt(get_setE mem_set).
  by auto.
wp; while (x = ct0 /\ (forall x, SD.XOF.m.[SD.XH x] = m0.[SD.XH x]) /\ 0 <= ctx /\
           (ct0 \notin HctT.tinv /\ ct0 \notin HctT.leakT => 0 < ctx => (ct0, 0) \in LX.RO.m)).
- inline *; sp 1; if; 1: by auto => />; smt(mem_set).
  if; 1: by auto => /> /#.
  by if; auto => />; smt(get_setE mem_set).
by auto => /> /#.
qed.

local lemma sib_xc_ph ct0 (m0 : (SD.xin, SD.xout) fmap) :
  phoare [ SIB.SampleInBall(XCSim(SD.XOF)).get :
  arg = ct0 /\ (forall x, SD.XOF.m.[SD.XH x] = m0.[SD.XH x]) ==>
  (forall x, SD.XOF.m.[SD.XH x] = m0.[SD.XH x]) /\
  (ct0 \notin HctT.tinv /\ ct0 \notin HctT.leakT => (ct0, 0) \in LX.RO.m) ] = 1%r.
proof. by conseq SIBX_ll (sib_xc_h ct0 m0). qed.

(* The query of the signer to [Hct], in the form of the inlined code *)
local lemma ginv_sample_fresh m2 ti lt lx qs x r bad :
  (!bad => ginv m2 ti lt lx qs) => SD.XH x \notin m2 => r \in dmap dct SD.OH =>
  x.`2 \in qs =>
  !(bad \/ hrng m2 (SD.oh (oget m2.[SD.XH x <- r].[SD.XH x])) \/
    exists i, (SD.oh (oget m2.[SD.XH x <- r].[SD.XH x]), i) \in lx) =>
  forall s, ginv m2.[SD.XH x <- r] ti lt.[SD.oh (oget m2.[SD.XH x <- r].[SD.XH x]) <- s] lx qs.
proof.
rewrite get_set_sameE /= => hI hx hr hq; rewrite !negb_or => -[# hb hh hl] s.
by rewrite (supp_dOH _ hr); apply ginv_sign_fresh => //; 1: exact: hI.
qed.

local lemma ginv_sample_old m2 ti lt lx qs x bad :
  (!bad => ginv m2 ti lt lx qs) => SD.XH x \in m2 => x.`2 \in qs => !bad =>
  forall s, ginv m2 ti lt.[SD.oh (oget m2.[SD.XH x]) <- s] lx qs.
proof. by move=> hI hx hq hb s; apply ginv_sign_old => //; apply hI. qed.

(* [lt_rel_iter] in the three exits of an iteration, with the leakage
   appended item by item as in the signing loops *)
local lemma lt_rel_z lt0 lt l ct (lc : leakage) c zf :
  lt_rel lt0 lt l => size lc = 2 => okf zf => zf <> None =>
  lt_rel lt0 lt.[ct <- SD.SIB.leak_to_stream lc]
    (lcat (lcat (lcat (lcat l (ct_leak ct)) lc) (c_leak c)) (oileak zf)).
proof.
move=> h hs hz hn.
have := lt_rel_iter _ _ _ ct _ c zf witness witness h hs hz _ _; 1, 2: smt().
by rewrite hn /= -!catA cats0.
qed.

local lemma lt_rel_r0 lt0 lt l ct (lc : leakage) c zf rf :
  lt_rel lt0 lt l => size lc = 2 => zf = None => okf rf => rf <> None =>
  lt_rel lt0 lt.[ct <- SD.SIB.leak_to_stream lc]
    (lcat (lcat (lcat (lcat (lcat l (ct_leak ct)) lc) (c_leak c)) (oileak zf)) (oileak rf)).
proof.
move=> h hs hz hr hn.
have := lt_rel_iter _ _ _ ct _ c zf rf witness h hs _ _ _; 1: by rewrite hz.
- by move=> _.
- smt().
by rewrite hz hn /= -!catA cats0.
qed.

local lemma lt_rel_h lt0 lt l ct (lc : leakage) c zf rf hf :
  lt_rel lt0 lt l => size lc = 2 => zf = None => rf = None => okf hf =>
  lt_rel lt0 lt.[ct <- SD.SIB.leak_to_stream lc]
    (lcat (lcat (lcat (lcat (lcat (lcat l (ct_leak ct)) lc) (c_leak c)) (oileak zf))
           (oileak rf)) (oileak hf)).
proof.
move=> h hs hz hr hh.
have := lt_rel_iter _ _ _ ct _ c zf rf hf h hs _ _ _; 1: by rewrite hz.
- by rewrite hr.
- by move=> _ _.
by rewrite hz hr /= -!catA.
qed.

local lemma okf_z z : okf (check_z z).
proof. by move=> i /check_z_range. qed.

local lemma okf_r0 w0 : okf (check_r0 w0).
proof. by move=> i /check_r0_range. qed.

local lemma okf_h h : okf (check_hint h).
proof. by move=> i /check_hint_range. qed.

(* Relation between the signing oracle [O_CMA1] of G2 (key [skA], queries
   [qsA]) and the state of the reduction ([RA], [RedSt], the oracle [SKD] of
   SimplifiedScheme, the tables of [HmuB] and [ROtr]). It is an
   abbreviation: the tactics see the conjunction. *)
local abbrev red_rel (skA : SK) (qsA : M list) (rho : seed) (mA : matrix) (tr : tr_t)
  (t1 : high2 list) (sk : SD.SK) (qs : mu_t list) (mm : (tr_t * M, mu_t) fmap) (mbad : bool)
  (mtr : (PK, tr_t) fmap) =
  skA = (rho, tr, sk.`2, sk.`3, base2lowbitsV (sk.`1 *^ sk.`2 + sk.`3)) /\
  mA = sk.`1 /\ t1 = base2highbitsV (sk.`1 *^ sk.`2 + sk.`3) /\
  qs = map (fun m => oget mm.[(tr, m)]) qsA /\
  (forall m, m \in qsA => (tr, m) \in mm) /\
  mtr.[(rho, t1)] = Some tr /\ inv_mu mm mbad.

(* The signing oracle: the reduction asks SimplifiedScheme for a signature
   of [mu]; both signing loops run in lockstep on the same random oracle,
   and the table of the streams of the signer is decoded from the leakage *)
local equiv sign_red :
  O_CMA1(MLDSAGen(MatRA, ChalX, HmuB)).sign ~
  CountS(SignRed(SKD(SD.DilithiumXOF(SD.XOF)))).sign :
  ={arg, glob XASim, glob RA, SD.XOF.m, LX.RO.m, HctT.tinv, HctT.leakT, ROtr.RO.m, glob HmuB} /\
  red_rel O_CMA1.sk{1} O_CMA1.qs{1} RA.rho{2} RA.mA{2} RedSt.tr{2} RedSt.t1{2} SKD.sk{2} SKD.qs{2}
          HmuB.m{2} HmuB.bad{2} ROtr.RO.m{2} /\
  (!HctT.bad{1} => ginv SD.XOF.m{1} HctT.tinv{1} HctT.leakT{1} LX.RO.m{1} SKD.qs{2}) ==>
  ={res, glob XASim, glob RA, SD.XOF.m, LX.RO.m, HctT.tinv, HctT.leakT, ROtr.RO.m, glob HmuB} /\
  red_rel O_CMA1.sk{1} O_CMA1.qs{1} RA.rho{2} RA.mA{2} RedSt.tr{2} RedSt.t1{2} SKD.sk{2} SKD.qs{2}
          HmuB.m{2} HmuB.bad{2} ROtr.RO.m{2} /\
  (!HctT.bad{1} => ginv SD.XOF.m{1} HctT.tinv{1} HctT.leakT{1} LX.RO.m{1} SKD.qs{2}).
proof.
proc; inline{1} 1; inline{2} 2; inline{2} 5; inline{2} 6.
(* the leakage of ExpandA, on the same simulated XOF *)
seq 7 3 : (={glob XASim, glob RA, SD.XOF.m, LX.RO.m, HctT.tinv, HctT.leakT, ROtr.RO.m, glob HmuB} /\
  red_rel O_CMA1.sk{1} O_CMA1.qs{1} RA.rho{2} RA.mA{2} RedSt.tr{2} RedSt.t1{2} SKD.sk{2} SKD.qs{2}
          HmuB.m{2} HmuB.bad{2} ROtr.RO.m{2} /\
  (!HctT.bad{1} => ginv SD.XOF.m{1} HctT.tinv{1} HctT.leakT{1} LX.RO.m{1} SKD.qs{2}) /\
  ={m, m0, la} /\ m0{1} = m{1} /\ (rho, tr, s1, s2, t0){1} = O_CMA1.sk{1} /\ mA{1} = RA.mA{2} /\
  ct{1} = witness).
- inline{1} MatRA.get; wp; call (: ={glob XASim}); 1: by sim.
  by auto.
seq 2 1 : (={glob XASim, glob RA, SD.XOF.m, LX.RO.m, HctT.tinv, HctT.leakT, ROtr.RO.m, glob HmuB} /\
  red_rel O_CMA1.sk{1} O_CMA1.qs{1} RA.rho{2} RA.mA{2} RedSt.tr{2} RedSt.t1{2} SKD.sk{2} SKD.qs{2}
          HmuB.m{2} HmuB.bad{2} ROtr.RO.m{2} /\
  (!HctT.bad{1} => ginv SD.XOF.m{1} HctT.tinv{1} HctT.leakT{1} LX.RO.m{1} SKD.qs{2}) /\
  m{1} = m{2} /\ mu{1} = mu{2} /\ mA{1} = SKD.sk{2}.`1 /\
  s1{1} = SKD.sk{2}.`2 /\ s2{1} = SKD.sk{2}.`3 /\
  t0{1} = base2lowbitsV (SKD.sk{2}.`1 *^ SKD.sk{2}.`2 + SKD.sk{2}.`3) /\
  tr{1} = RedSt.tr{2} /\ mu{2} = oget HmuB.m{2}.[(RedSt.tr{2}, m{2})] /\
  (RedSt.tr{2}, m{2}) \in HmuB.m{2} /\ leak{1} = t0_leak t0{1} /\ ct{1} = witness /\
  la{1} = la{2} /\ rho{1} = RA.rho{2}).
- inline HmuB.get; sp; if => //.
  + auto => /> &1 &2 hqs' htr hmu hI hx mu _.
    split; last by rewrite mem_set.
    split.
    * apply eq_in_map => m' hm /=; rewrite get_setE.
      case: ((RedSt.tr{2}, m') = (RedSt.tr{2}, m{2})) => // heq.
      by move: hx; rewrite -heq hqs'.
    split; 1: by move=> m' hm; rewrite mem_set hqs'.
    by apply inv_mu_upd.
  by auto => />.

seq 2 12 : (={glob XASim, glob RA, SD.XOF.m, LX.RO.m, HctT.tinv, ROtr.RO.m, glob HmuB} /\
  red_rel O_CMA1.sk{1} O_CMA1.qs{1} RA.rho{2} RA.mA{2} RedSt.tr{2} RedSt.t1{2} SKD.sk{2} SKD.qs{2}
          HmuB.m{2} HmuB.bad{2} ROtr.RO.m{2} /\
  m{1} = m{2} /\ mu{1} = mu{2} /\ m2{2} = mu{2} /\ m1{2} = mu{2} /\
  mA{1} = mA{2} /\ s1{1} = s1{2} /\ s2{1} = s2{2} /\ t0{1} = t0{2} /\
  mA{2} = SKD.sk{2}.`1 /\ s1{2} = SKD.sk{2}.`2 /\ s2{2} = SKD.sk{2}.`3 /\
  t0{2} = base2lowbitsV (mA{2} *^ s1{2} + s2{2}) /\
  mu{2} = oget HmuB.m{2}.[(RedSt.tr{2}, m{2})] /\ (RedSt.tr{2}, m{2}) \in HmuB.m{2} /\
  ={response, leak, ct} /\ (response{1} = None => ={ctr}) /\
  lt_rel HctT.leakT{2} HctT.leakT{1} leak{1} /\
  (!HctT.bad{1} =>
     ginv SD.XOF.m{1} HctT.tinv{1} HctT.leakT{1} LX.RO.m{1} (rcons SKD.qs{2} mu{2})) /\
  la{1} = la{2} /\ rho{1} = RA.rho{2}).
- auto => /> &1 &2 hqs htr hmu hI hmem.
  split; 1: by apply lt_rel_init.
  move=> hb; apply (ginv_qs _ _ _ _ _ _ _ (hI hb)) => mu' hmu'.
  by rewrite mem_rcons /= hmu'.

splitwhile{1} 1 : (response = None).
seq 1 1 : ((ctr{1} < kappa_max => response{1} <> None) /\ #pre).
- while (#pre).
  + rcondt{1} 1; 1: by auto.
    inline{1} ChalX.get; inline{1} HctT.sample; inline{2} SD.HctOf(SD.XOF).get.
    inline SD.XOF.get.
    seq 13 9 : (={glob XASim, glob RA, SD.XOF.m, LX.RO.m, HctT.tinv, ROtr.RO.m, glob HmuB} /\
  red_rel O_CMA1.sk{1} O_CMA1.qs{1} RA.rho{2} RA.mA{2} RedSt.tr{2} RedSt.t1{2} SKD.sk{2} SKD.qs{2}
          HmuB.m{2} HmuB.bad{2} ROtr.RO.m{2} /\
  m{1} = m{2} /\ mu{1} = mu{2} /\ m2{2} = mu{2} /\ m1{2} = mu{2} /\
  mA{1} = mA{2} /\ s1{1} = s1{2} /\ s2{1} = s2{2} /\ t0{1} = t0{2} /\
  mA{2} = SKD.sk{2}.`1 /\ s1{2} = SKD.sk{2}.`2 /\ s2{2} = SKD.sk{2}.`3 /\
  t0{2} = base2lowbitsV (mA{2} *^ s1{2} + s2{2}) /\
  mu{2} = oget HmuB.m{2}.[(RedSt.tr{2}, m{2})] /\ (RedSt.tr{2}, m{2}) \in HmuB.m{2} /\
  ={response, leak} /\ (response{1} = None => ={ctr}) /\
  lt_rel HctT.leakT{2} HctT.leakT{1} leak{1} /\
      ={y, w, w1} /\ w10{1} = w1{2} /\ mu0{1} = m2{2} /\ ct0{1} = ct{2} /\
      (response{1} = None) /\ ctr{1} < kappa_max /\ ={ctr} /\
      (!HctT.bad{1} => forall s, ginv SD.XOF.m{1} HctT.tinv{1} HctT.leakT{1}.[ct0{1} <- s]
                                      LX.RO.m{1} (rcons SKD.qs{2} mu{2})) /\
      la{1} = la{2} /\ rho{1} = RA.rho{2}).
    * wp; rnd; wp; rnd; auto => /> &1 &2 hqs htr hmu hmem hctr hlt hI hk hk2
        yL hyL r1L hr1L; split => hx.
      - by apply (ginv_sample_fresh _ _ _ _ _ _ _ _ hI hx hr1L); rewrite mem_rcons.
      by apply (ginv_sample_old _ _ _ _ _ _ _ hI hx); rewrite mem_rcons.
    exlim SD.XOF.m{1} => mm.
    wp; call (sib_eq mm); auto => /> &1 &2 hqs htr hmu hmem hlt hk hI [c lc] m_R /= hdc hsz hxh.
    split; [move=> hz; split; [move=> hr; split => [hc hh | hch] | move=> hr] | move=> hz].
    * by split; [apply lt_rel_h => //; apply okf_h | move=> hb; apply (ginv_xh mm); [exact hxh | exact (hI hb _)]].
    * by split; [apply lt_rel_h => //; apply okf_h | move=> hb; apply (ginv_xh mm); [exact hxh | exact (hI hb _)]].
    * by split; [apply lt_rel_r0 => //; apply okf_r0 | move=> hb; apply (ginv_xh mm); [exact hxh | exact (hI hb _)]].
    by split; [apply lt_rel_z => //; apply okf_z | move=> hb; apply (ginv_xh mm); [exact hxh | exact (hI hb _)]].
  by skip => /> /#.
seq 1 0 : (#pre).
- while{1} (#pre) (kappa_max - ctr{1}).
  + by move=> &h z; rcondf 1; auto => /> /#.
  by skip => /> /#.
auto => /> &1 &2 _ hqs htr hmu hmem _ hlt hI.
split; 1: by split; [by case: (response{2}) | by rewrite (lt_rel_upd _ _ _ hlt)].
rewrite map_rcons /=.
by move=> m'; rewrite mem_rcons /=; case => [-> // | /hqs //].
qed.

(* The query of the adversary to [Hct], in the form of the inlined code *)
local lemma ginv_hget_fresh m2 ti lt lx qs x r bad :
  (!bad => ginv m2 ti lt lx qs) => SD.XH x \notin m2 => r \in dmap dct SD.OH =>
  !(bad \/ hrng m2 (SD.oh (oget m2.[SD.XH x <- r].[SD.XH x])) \/
    exists i, (SD.oh (oget m2.[SD.XH x <- r].[SD.XH x]), i) \in lx) =>
  SD.oh (oget m2.[SD.XH x <- r].[SD.XH x]) \notin ti /\
  ginv m2.[SD.XH x <- r] ti.[SD.oh (oget m2.[SD.XH x <- r].[SD.XH x]) <- x] lt lx qs.
proof.
rewrite get_set_sameE /= => hI hx hr; rewrite !negb_or => -[# hb hh hl].
have hI' := hI hb; have [_ [hti _]] := ginv_fresh _ _ _ _ _ _ _ hI' hx hh hl.
by rewrite hti /= (supp_dOH _ hr); apply ginv_get_fresh => //; rewrite -(supp_dOH _ hr).
qed.

(* ---- The verification of the forgery ---- *)

(* The facts of [ginv] used for the forgery, according to [c~]: an output
   for the adversary which is not a [c~] of the signer, a [c~] of the
   signer, or none of them *)
local lemma ginv_C m2 ti lt lx qs ct x0 :
  ginv m2 ti lt lx qs => ti.[ct] = Some x0 => ct \notin lt =>
  (forall x o, m2.[SD.XH x] = Some o => o = SD.OH (SD.oh o)) /\
  hm m2 x0 ct /\ (forall x', hm m2 x' ct => x' = x0) /\ (forall i, (ct, i) \notin lx).
proof.
rewrite /ginv => [# h0 h1 h2 h3 h4 h5] hti hlt.
have hx0 := h2 _ _ hti; do! split => //.
- by move=> x' hx'; apply (h1 _ _ _ hx' hx0).
by move=> i; apply/negP => hi; have := h4 _ _ _ hi hx0; rewrite hlt.
qed.

local lemma ginv_A m2 ti lt lx qs ct :
  ginv m2 ti lt lx qs => ct \in lt =>
  (forall x o, m2.[SD.XH x] = Some o => o = SD.OH (SD.oh o)) /\
  (forall x', hm m2 x' ct => x'.`2 \in qs) /\ hrng m2 ct.
proof.
rewrite /ginv => [# h0 h1 h2 h3 h4 h5] hlt.
have [x1 [hx1 hq]] := h3 _ hlt; do! split => //.
- by move=> x' hx'; rewrite (h1 _ _ _ hx' hx1).
by exists x1.
qed.

local lemma ginv_B m2 ti lt lx qs ct :
  ginv m2 ti lt lx qs => ct \notin ti => ct \notin lt =>
  (forall x o, m2.[SD.XH x] = Some o => o = SD.OH (SD.oh o)) /\
  (forall x', hm m2 x' ct => false).
proof.
rewrite /ginv => [# h0 h1 h2 h3 h4 h5] hti hlt; split => // x' /h5.
by rewrite hti hlt.
qed.

(* The query of the verification of G2 to [Hct] on an [XH] entry *)
local lemma hctt_get_det x0 ct0 (mm : (SD.xin, SD.xout) fmap) :
  phoare [ HctT.get : arg = x0 /\ (forall x, SD.XOF.m.[SD.XH x] = mm.[SD.XH x]) /\
           mm.[SD.XH x0] = Some (SD.OH ct0) ==> res = ct0 ] = 1%r.
proof.
proc; inline *; auto => /> &hr hxh hx0; split; 1: by apply/dmap_ll/dct_ll.
by move=> _ r _ _; rewrite !domE hxh hx0.
qed.

local lemma hctof_det x0 ct0 (mm : (SD.xin, SD.xout) fmap) :
  phoare [ SD.HctOf(SD.XOF).get : arg = x0 /\ SD.XOF.m = mm /\
           mm.[SD.XH x0] = Some (SD.OH ct0) ==> res = ct0 /\ SD.XOF.m = mm ] = 1%r.
proof.
proc; inline *; auto => /> hx0; split; 1: by apply/dmap_ll/dct_ll.
by move=> _ r _ _; rewrite !domE hx0.
qed.

(* The query of the verification of G2 to [Hct] in the other cases: the
   result is not [c~ = ct0] unless [bad] is set or [P] holds for the
   query (in particular when [ct0] is not an output) *)
local lemma hctt_get_bad x0 ct0 (P : high list * mu_t -> bool) (mm : (SD.xin, SD.xout) fmap) :
  phoare [ HctT.get : arg = x0 /\
           (HctT.bad \/
            ((forall x, SD.XOF.m.[SD.XH x] = mm.[SD.XH x]) /\
             (forall x o, mm.[SD.XH x] = Some o => o = SD.OH (SD.oh o)) /\
             (forall x', hm mm x' ct0 => P x') /\ (hrng mm ct0 \/ (ct0, 0) \in LX.RO.m))) ==>
           HctT.bad \/ res <> ct0 \/ P x0 ] = 1%r.
proof.
proc; inline *; auto => /> &hr hpre; split; 1: by apply/dmap_ll/dct_ll.
move=> _ r hr _; case: hpre => [-> // | [hxh [h0 [hP hct]]]].
case: (SD.XH x0 \in SD.XOF.m{hr}) => hx /=.
- move: hx; rewrite domE hxh; case _ : (mm.[SD.XH x0]) => // o ho _.
  rewrite /=; case: (SD.oh o = ct0) => heq //.
  by right; right; apply hP; rewrite /hm ho (h0 _ _ ho) heq.
rewrite get_set_sameE /=; case: (SD.oh r = ct0) => // ->; left; right.
case: hct => [[x1 hx1] | hlx]; 2: by right; exists 0.
by left; exists x1; rewrite hxh.
qed.

local lemma ginv_D m2 ti lt lx qs ct :
  ginv m2 ti lt lx qs => !(ct \in ti /\ ct \notin lt) =>
  (forall x o, m2.[SD.XH x] = Some o => o = SD.OH (SD.oh o)) /\
  (forall x', hm m2 x' ct => x'.`2 \in qs) /\ (hrng m2 ct \/ (ct \notin ti /\ ct \notin lt)).
proof.
move=> hI hct; case: (ct \in lt) => hlt.
- by have [h0 [hP hr]] := ginv_A _ _ _ _ _ _ hI hlt.
have hti : ct \notin ti by smt().
have [h0 hP] := ginv_B _ _ _ _ _ _ hI hti hlt; split => //; split; 2: by right.
by move=> x' /hP.
qed.

local lemma hctof_ll : islossless SD.HctOf(SD.XOF).get.
proof. by proc; inline *; auto => />; apply/dmap_ll/dct_ll. qed.

(* ---- end of the G2 -> G3 helpers ---- *)

(* G2 -> G3: the reduction perfectly simulates G2 as long as there is
   no collision. *)
lemma hop_reduction &m :
  Pr[G2(A).main() @ &m : res /\ !HctT.bad /\ !HmuB.bad] <=
  Pr[SD.EF_CMA_XOF(SD.DilithiumXOF, RedMLDSA(A), SD.XOF, SD.O_CMA_XOF).main() @ &m : res].
proof.
byequiv (_: ={glob A} ==> (res /\ !HctT.bad /\ !HmuB.bad){1} => res{2}) => //.
proc; inline{2} 2; inline{2} 2.
inline{1} 8; inline{2} 10.
swap{1} [8..11] -7; swap{2} 12 -11; swap{2} [3..5] -1.
seq 4 4 : (={glob A, rho, mA, s1, s2}); 1: by auto.
seq 14 27 : (={glob A, glob XASim, glob RA, SD.XOF.m, LX.RO.m, HctT.tinv, HctT.leakT,
               ROtr.RO.m, glob HmuB} /\
  red_rel O_CMA1.sk{1} O_CMA1.qs{1} RA.rho{2} RA.mA{2} RedSt.tr{2} RedSt.t1{2} SKD.sk{2} SKD.qs{2}
          HmuB.m{2} HmuB.bad{2} ROtr.RO.m{2} /\
  (!HctT.bad{1} => ginv SD.XOF.m{1} HctT.tinv{1} HctT.leakT{1} LX.RO.m{1} SKD.qs{2}) /\
  pk{1} = (rho, t1){2} /\ sk{1} = (SKD.sk{2}.`1, O_CMA1.sk{1}) /\ pk{2} = (mA0, t0){2} /\
  t0{2} = mA0{2} *^ SKD.sk{2}.`2 + SKD.sk{2}.`3 /\
  mA0{2} = SKD.sk{2}.`1 /\ tr{2} = RedSt.tr{2} /\
  t1{2} = RedSt.t1{2} /\ rho{2} = RA.rho{2}).
- inline *; auto => /> &2 r _.
  rewrite mem_empty get_set_sameE /= ginv_init /=.
  by rewrite /inv_mu; smt(emptyE mem_empty).
seq 1 1 : (#pre /\ m{1} = m0{2} /\ sig{1} = sig0{2}).
- call (: ={glob XASim, glob RA, SD.XOF.m, LX.RO.m, HctT.tinv, HctT.leakT, ROtr.RO.m, glob HmuB} /\
     red_rel O_CMA1.sk{1} O_CMA1.qs{1} RA.rho{2} RA.mA{2} RedSt.tr{2} RedSt.t1{2} SKD.sk{2}
             SKD.qs{2} HmuB.m{2} HmuB.bad{2} ROtr.RO.m{2} /\
     (!HctT.bad{1} => ginv SD.XOF.m{1} HctT.tinv{1} HctT.leakT{1} LX.RO.m{1} SKD.qs{2})).
  + (* sign *)
    by conseq sign_red.
  + (* Hct *)
    proc; inline{1} HctT.sample; inline{2} HctX(SD.XOF).get; inline SD.XOF.get.
    wp; rnd; auto => />.
    move=> &1 &2 hqs htr hmu hI r hr; split => hx; last first.
    * by move=> hct hb; have := ginv_get_old _ _ _ _ _ _ (hI hb) hx => /=; rewrite hct.
    by split => hct' hb; have [hct hG] := ginv_hget_fresh _ _ _ _ _ _ _ _ hI hx hr hb.
  + (* Hmu *)
    proc; inline{2} 2; sp 0 2; if => //; last by auto.
    auto => /> &1 &2 hqs htr hmu hI hx mu _; split; 2: split.
    * apply eq_in_map => m hm /=; rewrite get_setE; case: ((RedSt.tr{2}, m) = x{2}) => // heq.
      by move: hx; rewrite -heq hqs.
    * by move=> m hm; rewrite mem_set hqs.
    by apply inv_mu_upd.
  + (* Htr *)
    proc; inline{2} 2; inline *; auto => /> &1 &2 hqs htr hmu hI r _ hx.
    by rewrite get_setE; smt(domE).
  + (* XC *)
    proc; seq 0 1 : (#pre); 1: by auto.
    inline{2} 1; sp 0 1; if => //.
    * inline LX.RO.get; rcondf{1} 3; 1: by auto.
      by rcondf{2} 3; auto.
    if => //; 1: by auto.
    if => //.
    * inline *; auto => /> &1 &2 hqs htr hmu hI _ _ _ r _ _ hb.
      by apply (ginv_xh SD.XOF.m{2}); [move=> x; rewrite get_setE | apply hI].
    inline *; auto => /> &1 &2 hqs htr hmu hI hy _ hti r _ hb.
    by apply ginv_lx; [apply hI | right].
  + (* XA *)
    proc*; inline{2} 1; wp; call (_: ={arg, glob XASim} ==> ={res, glob XASim}); 1: by sim.
    by auto.
  by auto.
inline{1} 3; inline{1} 2; inline{1} 1; inline{2} 9; inline{2} 8; inline{2} 7.
inline{1} ROtr.RO.get.
rcondf{1} 10; 1: by auto => /> /#.
seq 10 2 : (={HctT.tinv, HctT.leakT, SD.XOF.m, LX.RO.m, glob HmuB} /\
  mA0{1} = mA0{2} /\ t1{1} = t1{2} /\ t1{2} = base2highbitsV t0{2} /\ pk{2} = (mA0, t0){2} /\
  ={ct, z, h} /\ response{1} = zh{2} /\ zh{2} = (z{2}, h{2}) /\ m{1} = m0{2} /\
  (!HctT.bad{1} => ginv SD.XOF.m{1} HctT.tinv{1} HctT.leakT{1} LX.RO.m{1} SKD.qs{2}) /\
  inv_mu HmuB.m{2} HmuB.bad{2} /\
  SKD.qs{2} = map (fun m => oget HmuB.m{2}.[(RedSt.tr{2}, m)]) O_CMA1.qs{1} /\
  (forall m, m \in O_CMA1.qs{1} => (RedSt.tr{2}, m) \in HmuB.m{2}) /\
  tr0{1} = tr{2} /\ m1{1} = m{1} /\ tr{2} = RedSt.tr{2}).
- by auto => /> /#.
seq 1 1 : (={HctT.tinv, HctT.leakT, SD.XOF.m, LX.RO.m, glob HmuB} /\
  mA0{1} = mA0{2} /\ t1{1} = t1{2} /\ t1{2} = base2highbitsV t0{2} /\ pk{2} = (mA0, t0){2} /\
  ={ct, z, h} /\ response{1} = zh{2} /\ zh{2} = (z{2}, h{2}) /\ m{1} = m0{2} /\
  (!HctT.bad{1} => ginv SD.XOF.m{1} HctT.tinv{1} HctT.leakT{1} LX.RO.m{1} SKD.qs{2}) /\
  inv_mu HmuB.m{2} HmuB.bad{2} /\
  SKD.qs{2} = map (fun m => oget HmuB.m{2}.[(RedSt.tr{2}, m)]) O_CMA1.qs{1} /\
  (forall m, m \in O_CMA1.qs{1} => (RedSt.tr{2}, m) \in HmuB.m{2}) /\
  mu{1} = mu{2} /\ mu{2} = oget HmuB.m{2}.[(RedSt.tr{2}, m0{2})] /\
  (RedSt.tr{2}, m0{2}) \in HmuB.m{2}).
- inline HmuB.get; sp; if => //.
  + auto => /> &1 &2 hI hmu hqs hx mu _; split; 1: by apply inv_mu_upd.
    split.
    * apply eq_in_map => m' hm /=; rewrite get_setE.
      case: ((RedSt.tr{2}, m') = (RedSt.tr{2}, m0{2})) => // heq.
      by move: hx; rewrite -heq hqs.
    split; 1: by move=> m' hm; rewrite mem_set hqs.
    by rewrite mem_set.
  by auto => />.
case (!HctT.bad{1} /\ ct{2} \in HctT.tinv{2} /\ ct{2} \notin HctT.leakT{2}).
- (* [c~] is an output of [Hct] for the adversary, not a [c~] of the signer:
     the simulated challenge XOF on [c~] is the XOF on its preimage *)
  rcondt{2} 2; 1: by auto.
  exlim (oget HctT.tinv{2}.[ct{2}]), SD.XOF.m{2}, ct{2} => x0 mm ct0.
  seq 1 3 : (={glob HmuB, ct, z, h} /\ ct{2} = ct0 /\
  mA0{1} = mA0{2} /\ t1{1} = t1{2} /\ t1{2} = base2highbitsV t0{2} /\ pk{2} = (mA0, t0){2} /\
  zh{2} = (z{2}, h{2}) /\ m{1} = m0{2} /\ mu{1} = mu{2} /\
  inv_mu HmuB.m{2} HmuB.bad{2} /\
  SKD.qs{2} = map (fun m => oget HmuB.m{2}.[(RedSt.tr{2}, m)]) O_CMA1.qs{1} /\
  (forall m, m \in O_CMA1.qs{1} => (RedSt.tr{2}, m) \in HmuB.m{2}) /\
  mu{2} = oget HmuB.m{2}.[(RedSt.tr{2}, m0{2})] /\ (RedSt.tr{2}, m0{2}) \in HmuB.m{2} /\
    ={c, lc} /\ x{2} = x0 /\ r0{2} = witness /\ !HctT.bad{1} /\
    (forall x, SD.XOF.m{1}.[SD.XH x] = mm.[SD.XH x]) /\
    (forall x, SD.XOF.m{2}.[SD.XH x] = mm.[SD.XH x]) /\
    sib_det_pred x0 SD.XOF.m{2} (c{2}, lc{2}) /\
    mm.[SD.XH x0] = Some (SD.OH ct0) /\ (forall x', hm mm x' ct0 => x' = x0) /\
    (forall x o, mm.[SD.XH x] = Some o => o = SD.OH (SD.oh o))).
  + wp; call (sib_xc_P ct0 x0 mm); auto => /> &1 &2 hI hmu hqs hmem hb hti hlt.
    have /domE hti' := hti; have hsome : HctT.tinv{2}.[ct0] = Some (oget HctT.tinv{2}.[ct0]).
    * by move: hti'; case: (HctT.tinv{2}.[ct0]).
    have [h0 [hx0 [hu hlx]]] := ginv_C _ _ _ _ _ _ _ (hI hb) hsome hlt.
    by split => // _ [c' lc'] m1 m2 _ _ /= -> /=; do! split.
  seq 1 1 : (#pre /\ ={w1} /\
             w1{2} = useHintV h{2} (mA0{2} *^ z{2} - c{2} ** base2shiftV t1{2})); 1: by auto.
  case ((w1, mu){2} = x0).
  + (* the preimage of [c~] is the point of the forgery: G3 accepts *)
    rcondt{2} 1; 1: by auto.
    exlim (c{2}, lc{2}), SD.XOF.m{2} => r0' m2'.
    wp; call{2} (sib_det r0'); wp; call{2} (hctof_det x0 ct0 m2'); wp.
    call{1} (hctt_get_det x0 ct0 mm); auto => />.
    move=> &1 &2 hmu hqs hmem hb hxh1 hxh2 hdet hx0 hu h0 bad_L.
    rewrite hxh2 hx0 /= hdet /= => hq hz hh hn hfresh _ hmb; rewrite size_map hq /=.
    by apply (fresh_mu _ HmuB.bad{2}).
  (* otherwise G2 rejects, unless [bad] is set *)
  rcondf{2} 1; 1: by auto.
  exlim (w1{1}, mu{1}) => xq.
  wp; call{2} SDSIB_ll; wp; call{2} hctof_ll; wp.
  call{1} (hctt_get_bad xq ct0 (fun x => x = x0) mm); auto => />.
  move=> &1 &2 hmu hqs hmem hb hxh1 hxh2 hdet hx0 hu h0 hne.
  by left; exists x0.
(* [c~] is a [c~] of the signer (the point of the forgery would be a signed
   message) or not an output of [Hct] ([LX] has been queried on it): G2
   rejects, unless [bad] is set *)
exlim SD.XOF.m{1}, ct{1}, SKD.qs{2} => mm ct0 qs0.
seq 1 0 : (={glob HmuB, ct, z, h} /\ ct{1} = ct0 /\
  mA0{1} = mA0{2} /\ t1{1} = t1{2} /\ t1{2} = base2highbitsV t0{2} /\ pk{2} = (mA0, t0){2} /\
  zh{2} = (z{2}, h{2}) /\ m{1} = m0{2} /\ mu{1} = mu{2} /\
  inv_mu HmuB.m{2} HmuB.bad{2} /\
  SKD.qs{2} = map (fun m => oget HmuB.m{2}.[(RedSt.tr{2}, m)]) O_CMA1.qs{1} /\
  (forall m, m \in O_CMA1.qs{1} => (RedSt.tr{2}, m) \in HmuB.m{2}) /\
  mu{2} = oget HmuB.m{2}.[(RedSt.tr{2}, m0{2})] /\ (RedSt.tr{2}, m0{2}) \in HmuB.m{2} /\ SKD.qs{2} = qs0 /\
  (HctT.bad{1} \/
   ((forall x, SD.XOF.m{1}.[SD.XH x] = mm.[SD.XH x]) /\
    (forall x o, mm.[SD.XH x] = Some o => o = SD.OH (SD.oh o)) /\
    (forall x', hm mm x' ct0 => x'.`2 \in qs0) /\ (hrng mm ct0 \/ (ct0, 0) \in LX.RO.m{1})))).
- call{1} (sib_xc_ph ct0 mm); auto => /> &1 &2 hI hmu hqs hmem hnc lx m' _ hlx.
  case: (HctT.bad{1}) => hb //=.
  have [h0 [hP hr]] := ginv_D _ _ _ _ _ ct0 (hI hb) _; 1: smt().
  do! split => //; case: hr => [-> // | hn]; right; exact (hlx hn).
seq 1 0 : (#pre); 1: by auto.
exlim (w1{1}, mu{1}) => xq.
wp; call{2} SDSIB_ll; wp; call{2} hctof_ll; wp.
call{1} (hctt_get_bad xq ct0 (fun (x : high list * mu_t) => x.`2 \in qs0) mm).
sp 0 1; if{2}; [wp; call{2} SDSIB_ll | ]; auto => /> &1 &2 hmu hqs hmem _.
- move=> _ c'; split => _ ct' bL hp r2 r3 _ _ _ _ heq hf hb hmb.
  + by have := fresh_mu _ _ _ _ _ hmu hmb hqs hmem hf; smt().
  by have := fresh_mu _ _ _ _ _ hmu hmb hqs hmem hf; smt().
move=> _ ct' bL hp r2 r3 _ _ _ _ heq hf hb hmb.
by have := fresh_mu _ _ _ _ _ hmu hmb hqs hmem hf; smt().
qed.

(* ==================================================================== *)
(* Transfer lemmas (query bound and losslessness of the reduction)      *)
(* ==================================================================== *)

(* Invariant of the query-bound transfer: every preimage recorded in [tinv]
   is a point already queried to the random oracle of SimplifiedScheme
   ([SD.CountX.xs]): the byte queries of [XCSim] are on such points and
   are not counted. *)
local op red_cnt (xs : (SD.DID.W * mu_t) fset) (tinv : (ctilde, high list * mu_t) fmap) =
  forall ct x, tinv.[ct] = Some x => x \in xs.

local lemma red_cnt_mem xs tinv ct x :
  red_cnt xs tinv => tinv.[ct] = Some x => x \in xs.
proof. by move=> h; apply h. qed.

local lemma red_cnt_xs xs tinv y : red_cnt xs tinv => red_cnt (xs `|` fset1 y) tinv.
proof. by move=> h ct x /h hx; rewrite in_fsetU hx. qed.

local lemma red_cnt_tinv xs tinv ct x :
  red_cnt xs tinv => x \in xs => red_cnt xs tinv.[ct <- x].
proof. by move=> h hx ct' x'; rewrite get_setE; case: (ct' = ct) => [_ /= <- // | _ /h]. qed.

(* The forgery translation: [SampleInBall] only queries its argument, so it
   counts at most one new distinct point. *)
local lemma Red_SIB_count (X <: SD.DSSXOF.Hash{-SD.CountX}) x0 n :
  hoare [ SD.SIB.SampleInBall(SD.XofOf(SD.CountX(X))).get :
          x = x0 /\ SD.CountX.qx <= n ==> SD.CountX.qx <= n + 1 ].
proof.
proc.
while (x = x0 /\ SD.CountX.qx <= n + b2i (x0 \in SD.CountX.xs)).
+ wp; while (x = x0 /\ SD.CountX.qx <= n + b2i (x0 \in SD.CountX.xs)).
  + inline *; wp; call (: true); auto => /> &hr; smt(in_fsetU in_fset1).
  by auto.
wp; while (x = x0 /\ SD.CountX.qx <= n + b2i (x0 \in SD.CountX.xs)).
+ inline *; wp; call (: true); auto => /> &hr; smt(in_fsetU in_fset1).
by auto => /> /#.
qed.

(* The simulated XOF of ExpandA does not touch the state of the query-bound
   transfer (its termination is [XASim_ll]). *)
local lemma Red_XASim_true : hoare [ XASim.get : true ==> true ].
proof. by proc; inline *; auto. qed.

(* ---- end of the transfer helpers ---- *)

(* The reduction queries the random oracle of SimplifiedScheme on at most
   one new point per [Hct] query of A: the byte queries of [XCSim] and the
   forgery translation are on preimages recorded in [tinv], which are
   points already queried. *)
lemma B_bound
 (X'  <: SD.DSSXOF.Hash{-RedMLDSA(A), -SD.CountX, -SD.CountSX})
 (SO' <: SD.DSSXOF.DS.Stateless.SOracle_CMA{-RedMLDSA(A), -SD.CountX, -SD.CountSX}) :
 hoare[ RedMLDSA(A, SD.CountX(X'), SD.CountSX(SO')).forge :
        SD.CountX.qx = 0 /\ SD.CountSX.qs = 0 ==>
        SD.CountX.qx <= qHct + 1 /\ SD.CountSX.qs <= qS].
proof.
proc.
seq 22 : (SD.CountX.qx <= qHct /\ SD.CountSX.qs <= qS /\
          red_cnt SD.CountX.xs HctT.tinv).
- conseq (: _ ==> SD.CountX.qx <= CountHct.q /\ SD.CountSX.qs = CountS.q /\
                  red_cnt SD.CountX.xs HctT.tinv)
         (: _ ==> CountHct.q <= qHct /\ CountS.q <= qS); 1, 2: smt().
  + (* query bound of [A], syntactic instance of [A_bound] *)
    by call (A_bound XASim (XCSim(SD.CountX(X'))) ROtr.RO HmuB (HctX(SD.CountX(X')))
                     (SignRed(SD.CountSX(SO')))); inline *; auto.
  call (: SD.CountX.qx <= CountHct.q /\ SD.CountSX.qs = CountS.q /\
          red_cnt SD.CountX.xs HctT.tinv).
  + (* signing oracle: one query of the reduction per query of A, no XOF query *)
    proc; inline SignRed(SD.CountSX(SO')).sign SD.CountSX(SO').sign.
    wp; call (: true); wp; call (: true); 1: by auto.
    by call (: true); [conseq (: _ ==> true) | auto => /> /#].
  + (* Hct: at most one new point per query *)
    proc; inline HctX(SD.CountX(X')).get SD.CountX(X').get; wp.
    call (: true); auto => /> &hr hq hI.
    by split => hx r; split => _; smt(red_cnt_xs red_cnt_tinv in_fsetU in_fset1).
  + (* Hmu *)
    by proc; call (: true); auto.
  + (* Htr *)
    by proc; call (: true); auto.
  + (* challenge XOF: the byte queries are on the preimages of [tinv] *)
    proc; inline XCSim(SD.CountX(X')).get SD.CountX(X').get.
    seq 2 : (#pre); 1: by auto.
    wp; if; 1: by inline *; auto.
    if; 1: by auto.
    if; 2: by inline *; auto.
    rcondf 2; 1: by auto => />; smt(domE some_oget).
    by wp; call (: true); auto.
  + (* ExpandA XOF: does not touch the invariant *)
    by proc; call Red_XASim_true; auto.
  wp; call (: true); 1: by auto.
  by inline *; auto => /> &hr _ _; rewrite /red_cnt => ct x; rewrite emptyE.
(* the forgery translation makes at most one new XOF query *)
seq 4 : (#pre); 1: by wp; call (: true); auto.
if; last by auto => /#.
seq 1 : (#pre); 1: by auto.
exlim x => x0; wp; call (Red_SIB_count X' x0 qHct); auto => /#.
qed.

(* Losslessness of the reduction. The forgery translation runs
   [SD.SIB.SampleInBall(SD.XofOf(X)).get], which diverges for some lossless
   XOFs, hence the extra hypothesis, which is also the form of [A_ll] in
   section XOF of SimplifiedScheme.ec. *)
lemma B_ll
 (SO <: SD.DSSXOF.DS.Stateless.SOracle_CMA{-RedMLDSA(A)})
 (X  <: SD.DSSXOF.Hash{-RedMLDSA(A)}) :
 islossless SO.sign => islossless X.get => islossless SD.SIB.SampleInBall(SD.XofOf(X)).get =>
 islossless RedMLDSA(A, X, SO).forge.
proof.
move=> SO_ll X_ll SIB_ll; proc.
seq 22 : true => //.
- call (A_ll (CountXA(XASim)) (CountXC(XCSim(X))) (CountHtr(ROtr.RO))
             (CountHmu(HmuB)) (CountHct(HctX(X))) (CountS(SignRed(SO))) _ _ _ _ _ _).
  + by proc; call XASim_ll; auto.
  + proc; inline XCSim(X).get; sp; if; 1: by inline *; auto; smt(dB_ll).
    if; 1: by auto.
    by if; [wp; call X_ll; auto | inline *; auto; smt(dB_ll)].
  + by proc; islossless.
  + by proc; islossless.
  + by proc; inline HctX(X).get; wp; call X_ll; auto.
  + proc; inline SignRed(SO).sign; wp; call SO_ll.
    by call (: true); [islossless | call ExpandA_XASim_ll; auto].
  by islossless.
seq 4 : true => //; 1: by islossless.
by if => //; wp; call SIB_ll; auto.
qed.

end section PROOF.

end MLDSAProof_Reduction.
