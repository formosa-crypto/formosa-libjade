require import AllCore Distr List IntDiv FSet FMap Leakage Byte Finite.
require import StdOrder.
import RealOrder.
require MLDSAProof_Collisions.

(** Hop G2 -> G3 of [doc/proof_overview.tex] (the challenge is a function of
    [(w1, mu)]): [hop_reduction]. The reduction [RedMLDSA(A)] simulates G2
    exactly as long as no collision is flagged: its signing oracle hashes
    the message with [Hmu], asks SimplifiedScheme for a signature of [mu]
    (the signing loop of [SD.DilithiumR] is the one of
    [MLDSAGen(MatRA, ChalX, HmuB)]) and computes [c~ = Hct(w1, mu)] from the
    commitment [w1] recovered from the signature ([hint_recover]). [B_bound]
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
(* G2 -> G3: helpers                                                    *)
(* ==================================================================== *)

(* Hint recovery for an honest iteration of the signing loop (adapted from
   [SD.recover_correct]): the commitment recovered from the response is the
   commitment [highBitsV (mA *^ y)] used in the iteration. *)
local lemma hint_recover (mA : matrix) (s1 s2 y : vector) (c : Rq) :
  mA \in dmatrix dRq k l => s1 \in dvector (dRq_ eta_) l =>
  s2 \in dvector (dRq_ eta_) k => size y = l => c \in dC tau =>
  check_r0 (mA *^ y - c ** s2) = None =>
  check_ct0 (c ** base2lowbitsV (mA *^ s1 + s2)) =>
  useHintV (makeHintV (- c ** base2lowbitsV (mA *^ s1 + s2))
                      (mA *^ y - c ** s2 + c ** base2lowbitsV (mA *^ s1 + s2)))
           (mA *^ (y + c ** s1) - c ** base2shiftV (base2highbitsV (mA *^ s1 + s2)))
  = highBitsV (mA *^ y).
proof.
move=> hA hs1 rg_s2 hy c_supp r0_pass ct0_pass.
have sk_sizes: size mA = (k, l) /\ size s1 = l /\ size s2 = k.
- have := size_dmatrix dRq k l mA hA.
  have := size_dvector (dRq_ eta_) l s1 hs1.
  have := size_dvector (dRq_ eta_) k s2 rg_s2.
  smt(gt0_k gt0_l).
have C2 : inf_normv (lowBitsV (mA *^ y - c ** s2)) < gamma2 - beta_.
- rewrite -(check_r0_None (mA *^ y - c ** s2)) //.
  move: sk_sizes => />; smt(size_oppv size_scalarv size_mulmxv size_addv).
pose t := mA *^ s1 + s2.
pose t1 := base2highbitsV t.
pose t0 := base2lowbitsV t.
pose w := mA *^ y.
pose z := y + c ** s1.
have W : w - c ** s2 = mA *^ z - c ** t0 - c ** base2shiftV t1.
  rewrite /w /z mulmxvDr -!addvA; congr.
  rewrite mulmx_scalarv -!scalarvN -2!scalarvDr. congr.
  rewrite -oppvD [t0+_]addvC b2high_lowPv /t.
  rewrite oppvD addvA addvN size_mulmxv /= lin_add0v /=; move : sk_sizes => /> /#.
have W' : w - c ** s2 + c ** t0 =  mA *^ z - c ** base2shiftV t1.
  rewrite W -!addvA; congr; rewrite [_ + c**t0]addvC addvA [_ + c**t0]addvC addvN.
  rewrite lin_add0v // size_oppv.
  by rewrite !size_scalarv size_base2lowbitsV size_base2shiftV size_base2highbitsV.
rewrite W'.
rewrite usehint_correctV.
- rewrite size_addv !size_oppv !size_scalarv size_base2shiftV size_mulmxv.
  have ->: size t0 = size t by smt(size_base2lowbitsV).
  have ->: size t1 = size t by smt(size_base2highbitsV).
  suff: size t = rows mA by smt().
  rewrite size_addv size_mulmxv; move : sk_sizes => /> /#.
- have ->: 2 * gamma2 %/ 2 = gamma2 by smt().
  rewrite inf_normvN.
  move: ct0_pass; rewrite check_ct0_None 2:/#.
  rewrite size_scalarv size_base2lowbitsV size_addv size_mulmxv.
  by move: sk_sizes => /> /#.
rewrite -addvA [(_ - _)%Vectors]addvC addvA -W.
have {2}-> : w = w - c**s2 + c**s2.
  rewrite -addvA [_+ c**s2]addvC addvN size_scalarv.
  rewrite addvC lin_add0v //; have := sk_sizes => />; smt(size_mulmxv size_dvector).
apply eq_sym; apply (hide_lowV _ _ beta_);
  2, 3, 5: smt(size_oppv size_scalarv size_mulmxv size_dvector size_addv
               gt0_beta beta_gamma2_lt).
+ have := sk_sizes => />; smt(size_oppv size_scalarv size_mulmxv size_dvector size_addv
               gt0_beta beta_gamma2_lt).
apply: StdOrder.IntOrder.ler_trans eta_tau_leq_b; rewrite mulrC.
apply l1_inf_norm_product_ub; 1..3: smt(tau_bound gt0_eta supp_dC).
apply inf_normv_ler =>[|i rg_i]; first by smt(gt0_eta).
rewrite supp_dvector in rg_s2; first by smt(gt0_k).
by rewrite -supp_dRq; smt(gt0_eta).
qed.

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
local equiv xc_xof :
  XCSim(SD.XOF).get ~ SD.XOF.get :
  y{1}.`1 \in HctT.tinv{1} /\ x{2} = (oget HctT.tinv{1}.[y{1}.`1], y{1}.`2) /\
  ={SD.XOF.m, LX.RO.m} ==> ={res, SD.XOF.m, LX.RO.m}.
proof. by proc; rcondt{1} 1; [auto | inline *; auto]. qed.

local equiv sib_xc_xof :
  SIB.SampleInBall(XCSim(SD.XOF)).get ~ SD.SIB.SampleInBall(SD.XOF).get :
  arg{1} \in HctT.tinv{1} /\ arg{2} = oget HctT.tinv{1}.[arg{1}] /\
  ={SD.XOF.m, glob HctT, LX.RO.m} ==> ={res, SD.XOF.m, glob HctT, LX.RO.m}.
proof.
proc.
while (={i, ctx, signs, challenge, leak, SD.XOF.m, glob HctT, LX.RO.m} /\
       x{1} \in HctT.tinv{1} /\ x{2} = oget HctT.tinv{1}.[x{1}]).
- wp; while (={i, j, ctx, signs, challenge, leak, SD.XOF.m, glob HctT, LX.RO.m} /\
             x{1} \in HctT.tinv{1} /\ x{2} = oget HctT.tinv{1}.[x{1}]).
  + by wp; call xc_xof; auto.
  by auto => />; rewrite /SIB.to_bool /SD.SIB.to_bool /SIB.to_bool_list /SD.SIB.to_bool_list.
wp; while (={ctx, signs, SD.XOF.m, glob HctT, LX.RO.m} /\
           x{1} \in HctT.tinv{1} /\ x{2} = oget HctT.tinv{1}.[x{1}]).
- by wp; call xc_xof; auto.
by auto => />; rewrite /SIB.to_leakage /SD.SIB.to_leakage.
qed.

(* Off the outputs of [Hct], SampleInBall queries [LX] on its input and does
   not modify [HctT] *)
local hoare sib_xc_lx_mem ct0 t0 ti0 b0 :
  SIB.SampleInBall(XCSim(SD.XOF)).get :
  arg = ct0 /\ ! ct0 \in HctT.tinv /\
  HctT.t = t0 /\ HctT.tinv = ti0 /\ HctT.bad = b0 ==>
  (exists i, (ct0, i) \in LX.RO.m) /\
  HctT.t = t0 /\ HctT.tinv = ti0 /\ HctT.bad = b0.
proof.
proc.
while (x = ct0 /\ ! ct0 \in HctT.tinv /\ HctT.t = t0 /\ HctT.tinv = ti0 /\
       HctT.bad = b0 /\ (ct0, 0) \in LX.RO.m).
- wp; while (x = ct0 /\ ! ct0 \in HctT.tinv /\ HctT.t = t0 /\ HctT.tinv = ti0 /\
             HctT.bad = b0 /\ (ct0, 0) \in LX.RO.m).
  + wp; inline XCSim(SD.XOF).get; rcondf 2; 1: by auto.
    by inline *; auto => />; smt(mem_set).
  by auto.
wp; while (x = ct0 /\ ! ct0 \in HctT.tinv /\ HctT.t = t0 /\ HctT.tinv = ti0 /\
           HctT.bad = b0 /\ 0 <= ctx /\ (0 < ctx => (ct0, 0) \in LX.RO.m)).
- wp; inline XCSim(SD.XOF).get; rcondf 2; 1: by auto.
  by inline *; auto => />; smt(mem_set).
by auto => /> /#.
qed.

local lemma sib_xc_lx_mem_ph ct0 t0 ti0 b0 :
  phoare [ SIB.SampleInBall(XCSim(SD.XOF)).get :
    arg = ct0 /\ ! ct0 \in HctT.tinv /\
    HctT.t = t0 /\ HctT.tinv = ti0 /\ HctT.bad = b0 ==>
    (exists i, (ct0, i) \in LX.RO.m) /\
    HctT.t = t0 /\ HctT.tinv = ti0 /\ HctT.bad = b0 ] = 1%r.
proof. by conseq SIBX_ll (sib_xc_lx_mem ct0 t0 ti0 b0) => /#. qed.

(* Determinism of SampleInBall over a lazy random oracle, through the
   functional characterisation [sample_indices] of SampleInBallEquiv *)
local op sib_out (y : SD.SIB.challenge_ir * SD.SIB.rej_ir) : Rq * leakage =
  (to_concrete (SD.SIB.to_challenge y.`1), SD.SIB.full_leak y.`1 y.`2).

local op [opaque] sib_det_pred (x : SD.SIB.in_t) (m : (SD.SIB.in_t * int, byte) fmap)
                (r : Rq * leakage) =
  exists log y,
    (forall a b, (a, b) \in log => m.[a] = Some b) /\
    SD.SIB.sample_indices log x = Some y /\ r = sib_out y.

local module WLog = {
  proc run(x : SD.SIB.in_t) = {
    var r;
    SD.SIB.RR.F1.RO.m <- SD.XOF.m;
    r <@ SD.SIB.RR.F1.Op_sample_game(SD.SIB.SampleIndices).sample(x);
    return r;
  }
}.

local equiv sib_log :
  SD.SIB.SampleInBall(SD.XOF).get ~ WLog.run :
  ={arg, SD.XOF.m} ==>
  res{1} = sib_out res{2}.`2 /\
  SD.XOF.m{1} = SD.SIB.RR.F1.RO.m{2} /\
  (forall a b, (a, b) \in res{2}.`1 => SD.SIB.RR.F1.RO.m{2}.[a] = Some b).
proof.
proc; inline *; wp.
while (={i, signs, ctx, byte} /\ x{1} = x1{2} /\
       SD.XOF.m{1} = SD.SIB.RR.F1.RO.m{2} /\
       (forall a b, (a, b) \in SD.SIB.RR.F1.LogRO.log{2} =>
                    SD.SIB.RR.F1.RO.m{2}.[a] = Some b) /\
       (i <= 256 /\ size indices = i - (256 - tau) /\ size rej = size indices){2} /\
       challenge{1} = (SD.SIB.to_challenge_aux (signs, indices) (i - (256 - tau))){2} /\
       leak{1} = (SD.SIB.full_pairs (signs, indices) rej).`2{2} /\
       ctx{2} = (SD.SIB.full_pairs (signs, indices) rej).`1{2}).
+ wp.
  while (={i, j, ctx, signs, byte} /\ x{1} = x1{2} /\
         SD.XOF.m{1} = SD.SIB.RR.F1.RO.m{2} /\
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
  + seq 4 7 : (={i, j, ctx, signs, byte} /\ x{1} = x1{2} /\
               SD.XOF.m{1} = SD.SIB.RR.F1.RO.m{2} /\
               (forall a b, (a, b) \in SD.SIB.RR.F1.LogRO.log{2} =>
                            SD.SIB.RR.F1.RO.m{2}.[a] = Some b) /\
               (i < 256 /\ size indices = i - (256 - tau) /\ size rej = size indices){2} /\
               leak{1} = ((SD.SIB.full_pairs (signs, indices) rej).`2 ++
                         zip (iota_ ((SD.SIB.full_pairs (signs, indices) rej).`1 + 1)
                                    (size rejc)) rejc){2} /\
               ctx{2} = ((SD.SIB.full_pairs (signs, indices) rej).`1 + size rejc){2} /\
               i{2} < j{2}).
    * auto => /> &2 hlog hj hi hsz1 hsz2 hij b _.
      by split => hin a b'; rewrite mem_rcons /= => -[[-> ->] | /hlog h]; smt(get_setE).
    auto => /> &2 hlog hi hsz1 hsz2 hij.
    rewrite /SD.SIB.seg.
    have hA : forall (a b : int), a + 1 + b = a + b + 1 by smt().
    case: (i{2} < to_int byte{2}) => /= _;
      rewrite ?size_rcons !SD.SIB.zip_iota_rcons rcons_cat hA //.
    by rewrite addzA.
  auto => /> &2 hlog hi hsz1 hsz2 hlt.
  have -> /= : i{2} < i{2} + 1 by smt().
  rewrite iota0 // cats0 /=; split; 1: smt().
  move=> log m b j rejc hji _ hlog' hj.
  have {hj} hj := hj _; 1: smt().
  rewrite SD.SIB.full_pairs_rcons 1:/# /=.
  split; 1: smt(size_rcons).
  have -> /= : i{2} + 1 - (256 - tau) = (i{2} - (256 - tau)) + 1 by ring.
  rewrite -hj /=.
  rewrite SD.SIB.to_challenge_auxS; 1: by rewrite -hsz1 size_ge0.
  rewrite SD.SIB.to_challenge_aux_rcons 1:/# /=.
  rewrite /SD.SIB.to_challenge_body /= nth_rcons.
  have -> : 256 - tau + (i{2} - (256 - tau)) = i{2} by ring.
  have hs : i{2} - (256 - tau) = size indices{2} by smt().
  by rewrite hs /= /SD.SIB.to_bool hj.
wp; while (={signs, ctx, byte} /\ x{1} = x1{2} /\ SD.XOF.m{1} = SD.SIB.RR.F1.RO.m{2} /\
           (forall a b, (a, b) \in SD.SIB.RR.F1.LogRO.log{2} =>
                        SD.SIB.RR.F1.RO.m{2}.[a] = Some b) /\ ctx{1} <= 8).
+ auto => /> &2 hlog hc hc8 b _.
  by split => hin; (split; [move=> a b'; rewrite mem_rcons /= => -[[-> ->] | /hlog h];
                              smt(get_setE) | smt()]).
auto => /> log m ctx signs h1 _ hlog h2.
have ->> /= : ctx = 8 by smt().
split; 1: by rewrite SD.SIB.to_challenge_aux0 // /SD.SIB.full_pairs /=; smt(tau_bound).
move=> log2 m2 i idx rej _ hi hlog2 hi2 hsz1 hsz2.
have -> : i - (256 - tau) = tau by smt().
by rewrite /sib_out /SD.SIB.to_challenge /SD.SIB.full_leak.
qed.

local hoare wlog_h x0 :
  WLog.run : arg = x0 ==> SD.SIB.sample_indices res.`1 x0 = Some res.`2.
proof. by proc; call (SD.SIB.SampleIndices_OpSampleGame x0); auto. qed.

local equiv sib_P x0 :
  SD.SIB.SampleInBall(SD.XOF).get ~ SD.SIB.SampleInBall(SD.XOF).get :
  ={arg, SD.XOF.m} /\ arg{2} = x0 ==>
  ={res, SD.XOF.m} /\ sib_det_pred x0 SD.XOF.m{2} res{2}.
proof.
transitivity WLog.run
  (={arg, SD.XOF.m} /\ arg{2} = x0 ==>
   res{1} = sib_out res{2}.`2 /\
   SD.XOF.m{1} = SD.SIB.RR.F1.RO.m{2} /\
   SD.SIB.sample_indices res{2}.`1 x0 = Some res{2}.`2)
  (={arg, SD.XOF.m} ==>
   res{2} = sib_out res{1}.`2 /\
   SD.XOF.m{2} = SD.SIB.RR.F1.RO.m{1} /\
   (forall a b, (a, b) \in res{1}.`1 => SD.SIB.RR.F1.RO.m{1}.[a] = Some b)).
- by move=> &1 &2 h; exists SD.XOF.m{1} arg{1}; smt().
- move=> &1 &m &2 [#] -> h1 hsi [#] -> h2 hlog /=; split; 1: by rewrite h1 h2.
  by rewrite /sib_det_pred; exists res{m}.`1 res{m}.`2; rewrite h2.
- by conseq sib_log _ (wlog_h x0) => /#.
by symmetry; conseq sib_log => /#.
qed.

(* [sib_P] composed with [sib_xc_xof] *)
local equiv sib_xc_P x0 :
  SIB.SampleInBall(XCSim(SD.XOF)).get ~ SD.SIB.SampleInBall(SD.XOF).get :
  arg{1} \in HctT.tinv{1} /\ arg{2} = oget HctT.tinv{1}.[arg{1}] /\ arg{2} = x0 /\
  ={SD.XOF.m, glob HctT, LX.RO.m} ==>
  ={res, SD.XOF.m, glob HctT, LX.RO.m} /\ sib_det_pred x0 SD.XOF.m{2} res{2}.
proof.
transitivity SD.SIB.SampleInBall(SD.XOF).get
  (arg{1} \in HctT.tinv{1} /\ arg{2} = oget HctT.tinv{1}.[arg{1}] /\
   ={SD.XOF.m, glob HctT, LX.RO.m} ==> ={res, SD.XOF.m, glob HctT, LX.RO.m})
  (={arg, SD.XOF.m, glob HctT, LX.RO.m} /\ arg{2} = x0 ==>
   ={res, SD.XOF.m, glob HctT, LX.RO.m} /\ sib_det_pred x0 SD.XOF.m{2} res{2}).
- move=> &1 &2 [#] h1 h2 h3 h4 /= [#] h5 h6 h7 h8 h9.
  by exists HctT.bad{1} HctT.t{1} HctT.tinv{1} LX.RO.m{1} SD.XOF.m{1} arg{2} => /=; smt().
- smt().
- exact sib_xc_xof.
by proc*; call (sib_P x0); auto.
qed.

local lemma sib_det r0 :
  phoare [ SD.SIB.SampleInBall(SD.XOF).get :
           sib_det_pred arg SD.XOF.m r0 ==> res = r0 ] = 1%r.
proof.
bypr => &m; split => //; rewrite /sib_det_pred => -[log y [hlog [hsi ->]]].
have h1 : Pr[WLog.run(arg{m}) @ &m :
             (res.`1 = log /\ SD.SIB.RR.F1.RO.m = SD.XOF.m{m}) /\
             SD.SIB.sample_indices res.`1 arg{m} = Some res.`2] = 1%r.
- byphoare (_ : arg = arg{m} /\ SD.XOF.m = SD.XOF.m{m} ==> _) => //.
  proc; call (_ : (forall a b, (a, b) \in log => SD.SIB.RR.F1.RO.m.[a] = Some b) /\
                  SD.SIB.sample_indices log x = Some y /\ x = arg{m} /\
                  SD.SIB.RR.F1.RO.m = SD.XOF.m{m} ==>
                  (res.`1 = log /\ SD.SIB.RR.F1.RO.m = SD.XOF.m{m}) /\
                  SD.SIB.sample_indices res.`1 arg{m} = Some res.`2).
  + by conseq (SD.SIB.SampleIndices_OpSampleGameFun log y SD.XOF.m{m})
              (SD.SIB.SampleIndices_OpSampleGame arg{m}) => /#.
  by auto.
have h2 : Pr[WLog.run(arg{m}) @ &m :
             (res.`1 = log /\ SD.SIB.RR.F1.RO.m = SD.XOF.m{m}) /\
             SD.SIB.sample_indices res.`1 arg{m} = Some res.`2] <=
          Pr[SD.SIB.SampleInBall(SD.XOF).get(arg{m}) @ &m : res = sib_out y].
- by byequiv => //; symmetry; conseq sib_log => /#.
have h3 : Pr[SD.SIB.SampleInBall(SD.XOF).get(arg{m}) @ &m : res = sib_out y] <= 1%r.
- by byphoare => //.
smt().
qed.

(* Invariants of the lazy tables [HctT] and [HmuB] *)
local op [opaque] inv_ct (t : (high list * mu_t, ctilde) fmap) (ti : (ctilde, high list * mu_t) fmap)
          (bad : bool) =
  (forall x ct, t.[x] = Some ct => ct \in ti /\ (!bad => ti.[ct] = Some x)) /\
  (forall ct x, ti.[ct] = Some x => t.[x] = Some ct).

local op [opaque] inv_mu (m : (tr_t * M, mu_t) fmap) (bad : bool) =
  !bad => forall a b, a \in m => b \in m => m.[a] = m.[b] => a = b.

local lemma inv_ct_upd t ti bad x ct b :
  inv_ct t ti bad => x \notin t =>
  inv_ct t.[x <- ct] (if ct \notin ti then ti.[ct <- x] else ti) (bad \/ ct \in ti \/ b).
proof.
rewrite /inv_ct => -[h1 h2] hx; split.
- move=> x' ct'; rewrite get_setE; case: (x' = x) => [->> /= <<- | hne /= hx'].
  + by case: (ct \in ti) => hct /=; rewrite ?mem_set ?get_set_sameE.
  have [hin hinv] := h1 _ _ hx'.
  case: (ct \in ti) => hct /=; 1: by rewrite hin /= => /hinv.
  rewrite mem_set hin /= => hb; rewrite get_setE.
  case: (ct' = ct) => [->> | _] /=; 1: smt().
  by apply hinv; smt().
move=> ct' x'; case: (ct \in ti) => hct /=.
- move=> /h2 hx'; rewrite get_setE; case: (x' = x) => [->> | //].
  by move: hx; rewrite domE hx'.
rewrite get_setE; case: (ct' = ct) => [->> /= <<- | hne /= /h2 hx'].
- by rewrite get_set_sameE.
rewrite get_setE; case: (x' = x) => [->> | //].
by move: hx; rewrite domE hx'.
qed.

local lemma inv_ct_new t ti bad x ct b :
  inv_ct t ti bad => x \notin t => ct \notin ti =>
  inv_ct t.[x <- ct] ti.[ct <- x] (bad \/ b).
proof.
move=> h hx hct; have := inv_ct_upd t ti bad x ct b h hx.
by rewrite hct.
qed.

local lemma inv_ct_old t ti bad x ct :
  inv_ct t ti bad => x \notin t => ct \in ti => inv_ct t.[x <- ct] ti true.
proof.
move=> h hx hct; have := inv_ct_upd t ti bad x ct false h hx.
by rewrite hct.
qed.

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

(* The challenge of the signing loop, with its support *)
local equiv sib_eq_dC :
  SD.SIB.SampleInBall(SD.XOF).get ~ SD.SIB.SampleInBall(SD.XOF).get :
  ={arg, SD.XOF.m} ==> ={res, SD.XOF.m} /\ res{1}.`1 \in dC tau.
proof.
by conseq (_: ={arg, SD.XOF.m} ==> ={res, SD.XOF.m}) (sib_dC SD.XOF) _ => //; sim.
qed.

local equiv hct_get :
  HctT.get ~ HctT.get :
  ={arg, glob HctT, LX.RO.m} /\ inv_ct HctT.t{2} HctT.tinv{2} HctT.bad{2} ==>
  ={res, glob HctT} /\ inv_ct HctT.t{2} HctT.tinv{2} HctT.bad{2}.
proof.
proc; if => //; auto => /> &2 hct hx c _; split => hc.
- by apply inv_ct_new.
by rewrite hc /=; apply (inv_ct_old _ _ HctT.bad{2}).
qed.

local lemma inv_ct_tinv t ti bad ct :
  inv_ct t ti bad => ct \in ti => t.[oget ti.[ct]] = Some ct.
proof. by rewrite /inv_ct => -[_ h2] /domE hct; apply h2; move: hct; case: (ti.[ct]). qed.

local lemma inv_ct_t t ti bad x ct :
  inv_ct t ti bad => t.[x] = Some ct => ct \in ti /\ (!bad => ti.[ct] = Some x).
proof. by rewrite /inv_ct => -[h1 _]; apply h1. qed.

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

(* The rejection tests and the leakage of a response are the same in
   MLDSATarget and in SimplifiedScheme ([SD.Rq_enc] is [ofRq]) *)
local lemma SD_c_leak_eq : SD.c_leak = c_leak by [].

(* The signing oracle of SimplifiedScheme, which holds the key of the
   reduction *)
local module SKD = SD.DSSXOF.DS.Stateless.O_CMA_Default.

(* Relation between the signing oracle [O_CMA1] of G2 (key [skA], queries
   [qsA]) and the state of the reduction ([RA], [RedSt], the oracle [SKD] of
   SimplifiedScheme, the tables of [HmuB], [ROtr] and [HctT]). It is an
   abbreviation: the tactics see the conjunction. *)
local abbrev red_rel (skA : SK) (qsA : M list) (rho : seed) (mA : matrix) (tr : tr_t)
  (t1 : high2 list) (sk : SD.SK) (qs : mu_t list) (mm : (tr_t * M, mu_t) fmap) (mbad : bool)
  (mtr : (PK, tr_t) fmap) (ht : (high list * mu_t, ctilde) fmap)
  (hti : (ctilde, high list * mu_t) fmap) (hbad : bool) =
  skA = (rho, tr, sk.`2, sk.`3, base2lowbitsV (sk.`1 *^ sk.`2 + sk.`3)) /\
  mA = sk.`1 /\ t1 = base2highbitsV (sk.`1 *^ sk.`2 + sk.`3) /\
  sk.`1 \in dmatrix dRq k l /\ sk.`2 \in dvector (dRq_ eta_) l /\
  sk.`3 \in dvector (dRq_ eta_) k /\
  qs = map (fun m => oget mm.[(tr, m)]) qsA /\
  (forall m, m \in qsA => (tr, m) \in mm) /\
  mtr.[(rho, t1)] = Some tr /\
  inv_ct ht hti hbad /\ inv_mu mm mbad.

(* The signing oracle: the reduction asks SimplifiedScheme for a signature
   of [mu] and recovers the commitment [w1] from it ([hint_recover]) *)
local equiv sign_red :
  O_CMA1(MLDSAGen(MatRA, ChalX, HmuB)).sign ~
  CountS(SignRed(SKD(SD.DilithiumR(SD.SIB.SampleInBall(SD.DSSXOF.PRO.RO))))).sign :
  ={arg, glob XASim, glob RA, SD.XOF.m, LX.RO.m, glob HctT, ROtr.RO.m, glob HmuB} /\
  red_rel O_CMA1.sk{1} O_CMA1.qs{1} RA.rho{2} RA.mA{2} RedSt.tr{2} RedSt.t1{2} SKD.sk{2} SKD.qs{2}
          HmuB.m{2} HmuB.bad{2} ROtr.RO.m{2} HctT.t{2} HctT.tinv{2} HctT.bad{2} ==>
  ={res, glob XASim, glob RA, SD.XOF.m, LX.RO.m, glob HctT, ROtr.RO.m, glob HmuB} /\
  red_rel O_CMA1.sk{1} O_CMA1.qs{1} RA.rho{2} RA.mA{2} RedSt.tr{2} RedSt.t1{2} SKD.sk{2} SKD.qs{2}
          HmuB.m{2} HmuB.bad{2} ROtr.RO.m{2} HctT.t{2} HctT.tinv{2} HctT.bad{2}.
proof.
proc; inline{1} 1; inline{2} 2; inline{2} 4; inline{2} 5; inline{1} MatRA.get.
seq 11 3 : (={glob XASim, glob RA, SD.XOF.m, LX.RO.m, glob HctT, ROtr.RO.m, glob HmuB} /\
  red_rel O_CMA1.sk{1} O_CMA1.qs{1} RA.rho{2} RA.mA{2} RedSt.tr{2} RedSt.t1{2} SKD.sk{2} SKD.qs{2}
          HmuB.m{2} HmuB.bad{2} ROtr.RO.m{2} HctT.t{2} HctT.tinv{2} HctT.bad{2} /\
  m{1} = m{2} /\ mu{1} = mu{2} /\ mA{1} = SKD.sk{2}.`1 /\
  s1{1} = SKD.sk{2}.`2 /\ s2{1} = SKD.sk{2}.`3 /\
  t0{1} = base2lowbitsV (SKD.sk{2}.`1 *^ SKD.sk{2}.`2 + SKD.sk{2}.`3) /\
  tr{1} = RedSt.tr{2} /\ mu{2} = oget HmuB.m{2}.[(RedSt.tr{2}, m{2})] /\
  (RedSt.tr{2}, m{2}) \in HmuB.m{2} /\ leak{1} = t0_leak t0{1}).
inline HmuB.get; sp; if => //.
- auto => /> &1 &2 _ _ _ hqs _ _ hmu hx mu _.
  split; last by rewrite mem_set.
  split.
  * apply eq_in_map => m' hm /=; rewrite get_setE.
    case: ((RedSt.tr{2}, m') = (RedSt.tr{2}, m{2})) => // heq.
    by move: hx; rewrite -heq hqs.
  split; 1: by move=> m' hm; rewrite mem_set hqs.
  by apply inv_mu_upd.
by auto => />.
seq 2 11 : (={glob XASim, glob RA, SD.XOF.m, LX.RO.m, glob HctT, ROtr.RO.m, glob HmuB} /\
  red_rel O_CMA1.sk{1} O_CMA1.qs{1} RA.rho{2} RA.mA{2} RedSt.tr{2} RedSt.t1{2} SKD.sk{2} SKD.qs{2}
          HmuB.m{2} HmuB.bad{2} ROtr.RO.m{2} HctT.t{2} HctT.tinv{2} HctT.bad{2} /\
  m{1} = m{2} /\ mu{1} = mu{2} /\ m2{2} = mu{2} /\ m1{2} = mu{2} /\
  mA{1} = mA{2} /\ s1{1} = s1{2} /\ s2{1} = s2{2} /\ t0{1} = t0{2} /\
  mA{2} = SKD.sk{2}.`1 /\ s1{2} = SKD.sk{2}.`2 /\ s2{2} = SKD.sk{2}.`3 /\
  t0{2} = base2lowbitsV (mA{2} *^ s1{2} + s2{2}) /\
  mu{2} = oget HmuB.m{2}.[(RedSt.tr{2}, m{2})] /\ (RedSt.tr{2}, m{2}) \in HmuB.m{2} /\
  ={response, leak} /\ (response{1} = None => ={ctr}) /\
  (response{2} <> None =>
     useHintV (oget response{2}).`2
       (mA{2} *^ (oget response{2}).`1 - c0{2} ** base2shiftV RedSt.t1{2}) = w1{1})).
- by auto => /> /#.
splitwhile{1} 1 : (response = None).
seq 1 1 : ((ctr{1} < kappa_max => response{1} <> None) /\ #pre).
- while (#pre).
  + rcondt{1} 1; 1: by auto.
    inline{1} ChalX.get; wp; call sib_eq_dC; wp; rnd; skip.
    rewrite SD_c_leak_eq => />.
    move=> &1 &2 hA hs1 hs2 _ _ _ _ _ ->> _ _ y hy r hr /= hz hr0 hct0 _; apply hint_recover => //.
    by have := size_dvector _ _ _ hy; smt(gt0_l).
  by skip => /> /#.
seq 1 0 : (#pre).
- while{1} (#pre) (kappa_max - ctr{1}).
  + by move=> &h z; rcondf 1; auto => /> /#.
  by skip => /> /#.
case (response{1} = None).
- rcondf{1} 1; 1: by auto.
  rcondf{2} 5; 1: by auto => /> /#.
  auto => />.
  move=> &1 &2 _ _ _ _ hqs _ _ _ hm _; rewrite map_rcons /=.
  by move=> m'; rewrite mem_rcons /=; case => [-> // | /hqs //].
rcondt{1} 1; 1: by auto.
rcondt{2} 5.
- move=> &1; auto => />; move=> &hr; do ! move=> ?.
  have hom : forall (f : SD.response_t -> SD.SigXOF) (o : SD.response_t option),
    omap f o = None => o = None by move=> f [].
  smt().
inline{1} ChalX.final; wp; call hct_get; auto => />.
move=> &1 &2 _ _ _ _ hqs _ _ _ hm _; case: (response{2}) => // -[z h] /= hrec.
split; 1: by rewrite hrec.
move=> _ b t ti _; rewrite map_rcons /=.
by move=> m'; rewrite mem_rcons /=; case => [-> // | /hqs //].
qed.

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
seq 4 4 : (={glob A, rho, mA, s1, s2} /\ mA{1} \in dmatrix dRq k l /\
           s1{1} \in dvector (dRq_ eta_) l /\ s2{1} \in dvector (dRq_ eta_) k); 1: by auto.
seq 14 27 : (={glob A, glob XASim, glob RA, SD.XOF.m, LX.RO.m, glob HctT, ROtr.RO.m, glob HmuB} /\
red_rel O_CMA1.sk{1} O_CMA1.qs{1} RA.rho{2} RA.mA{2} RedSt.tr{2} RedSt.t1{2} SKD.sk{2} SKD.qs{2}
      HmuB.m{2} HmuB.bad{2} ROtr.RO.m{2} HctT.t{2} HctT.tinv{2} HctT.bad{2} /\
  pk{1} = (rho, t1){2} /\ sk{1} = (SKD.sk{2}.`1, O_CMA1.sk{1}) /\ pk{2} = (mA0, t0){2} /\
  t0{2} = mA0{2} *^ SKD.sk{2}.`2 + SKD.sk{2}.`3 /\
  mA0{2} = SKD.sk{2}.`1 /\ tr{2} = RedSt.tr{2} /\
  t1{2} = RedSt.t1{2} /\ rho{2} = RA.rho{2}).
- inline *; auto => /> &2 _ _ _ r _.
  by rewrite mem_empty get_set_sameE /= /inv_mu; smt(emptyE mem_empty).
seq 1 1 : (#pre /\ m{1} = m0{2} /\ sig{1} = sig0{2}).
- call (: ={glob XASim, glob RA, SD.XOF.m, LX.RO.m, glob HctT, ROtr.RO.m, glob HmuB} /\
red_rel O_CMA1.sk{1} O_CMA1.qs{1} RA.rho{2} RA.mA{2} RedSt.tr{2} RedSt.t1{2} SKD.sk{2} SKD.qs{2}
      HmuB.m{2} HmuB.bad{2} ROtr.RO.m{2} HctT.t{2} HctT.tinv{2} HctT.bad{2}).
  + (* sign *)
    by conseq sign_red.
  + (* Hct *)
    proc; inline{2} 2; sp 0 2; if => //; last by auto.
    auto => /> &1 &2 _ _ _ _ _ hct _ hx c _; split => hc.
    * by apply inv_ct_new.
    by rewrite hc /=; apply (inv_ct_old _ _ HctT.bad{2}).
  + (* Hmu *)
    proc; inline{2} 2; sp 0 2; if => //; last by auto.
    auto => /> &1 &2 _ _ _ hqs _ _ hmu hx mu _; split; 2: split.
    * apply eq_in_map => m hm /=; rewrite get_setE; case: ((RedSt.tr{2}, m) = x{2}) => // heq.
      by move: hx; rewrite -heq hqs.
    * by move=> m hm; rewrite mem_set hqs.
    by apply inv_mu_upd.
  + (* Htr *)
    proc; inline{2} 2; inline *; auto => /> &1 &2 _ _ _ _ htr _ _ r _ hx.
    by rewrite get_setE; smt(domE).
  + (* XC *)
    proc*; inline{2} 1; wp; call (_: ={arg, SD.XOF.m, LX.RO.m, glob HctT} ==>
                                     ={res, SD.XOF.m, LX.RO.m, glob HctT}); 1: by sim.
    by auto.
  + (* XA *)
    proc*; inline{2} 1; wp; call (_: ={arg, glob XASim} ==> ={res, glob XASim}); 1: by sim.
    by auto.
  by auto.
inline{1} 3; inline{1} 2; inline{1} 1; inline{2} 9; inline{2} 8; inline{2} 7.
inline{1} 8.
rcondf{1} 10; 1: by auto => /> /#.
seq 10 2 : (={glob HctT, SD.XOF.m, LX.RO.m, glob HmuB} /\
  mA0{1} = mA0{2} /\ t1{1} = t1{2} /\ t1{2} = base2highbitsV t0{2} /\ pk{2} = (mA0, t0){2} /\
  ={ct, z, h} /\ response{1} = zh{2} /\ zh{2} = (z{2}, h{2}) /\ m{1} = m0{2} /\
  inv_ct HctT.t{2} HctT.tinv{2} HctT.bad{2} /\ inv_mu HmuB.m{2} HmuB.bad{2} /\
  SKD.qs{2} = map (fun m => oget HmuB.m{2}.[(RedSt.tr{2}, m)]) O_CMA1.qs{1} /\
  (forall m, m \in O_CMA1.qs{1} => (RedSt.tr{2}, m) \in HmuB.m{2}) /\ tr0{1} = tr{2} /\ m1{1} = m{1} /\ tr{2} = RedSt.tr{2}).
- by auto => /> /#.
seq 1 1 : (={glob HctT, SD.XOF.m, LX.RO.m, glob HmuB} /\
  mA0{1} = mA0{2} /\ t1{1} = t1{2} /\ t1{2} = base2highbitsV t0{2} /\ pk{2} = (mA0, t0){2} /\
  ={ct, z, h} /\ response{1} = zh{2} /\ zh{2} = (z{2}, h{2}) /\ m{1} = m0{2} /\
  inv_ct HctT.t{2} HctT.tinv{2} HctT.bad{2} /\ inv_mu HmuB.m{2} HmuB.bad{2} /\
  SKD.qs{2} = map (fun m => oget HmuB.m{2}.[(RedSt.tr{2}, m)]) O_CMA1.qs{1} /\
  (forall m, m \in O_CMA1.qs{1} => (RedSt.tr{2}, m) \in HmuB.m{2}) /\ mu{1} = mu{2} /\ mu{2} = oget HmuB.m{2}.[(RedSt.tr{2}, m0{2})] /\
  (RedSt.tr{2}, m0{2}) \in HmuB.m{2}).
- inline HmuB.get; sp; if => //.
  + auto => /> &1 &2 _ hmu hqs hx mu _; split; 1: by apply inv_mu_upd.
    split.
    * apply eq_in_map => m' hm /=; rewrite get_setE.
      case: ((RedSt.tr{2}, m') = (RedSt.tr{2}, m0{2})) => // heq.
      by move: hx; rewrite -heq hqs.
    split; 1: by move=> m' hm; rewrite mem_set hqs.
    by rewrite mem_set.
  by auto => />.
case (ct{2} \in HctT.tinv{2}).
- rcondt{2} 2; 1: by auto.
  exlim (oget HctT.tinv{2}.[ct{2}]) => x0.
  seq 1 3 : (#pre /\ ={c, lc} /\ x{2} = x0 /\ x0 = oget HctT.tinv{2}.[ct{2}] /\
             sib_det_pred x0 SD.XOF.m{2} (c, lc){2} /\ r0{2} = witness).
  + by wp; call (sib_xc_P x0); auto => /> &1 &2 _ _ _ _ _ [r1 r2].
  seq 1 1 : (#pre /\ ={w1} /\
             w1{2} = useHintV h{2} (mA0{2} *^ z{2} - c{2} ** base2shiftV t1{2})); 1: by auto => />.
  case ((w1, mu){2} = x0).
  + rcondt{2} 1; 1: by auto.
    inline{1} 1; rcondf{1} 2.
    * move=> &m0; wp; skip => /> &hr hct _ _ _ hin _ ->.
      by rewrite domE (inv_ct_tinv _ _ _ _ hct hin).
    exlim (c, lc){2} => r0'.
    wp; call{2} (sib_det r0'); auto => />.
    move=> &1 &2 hct hmu hqs hmem hin hdet heq; rewrite heq hdet /=.
    move=> hs _ _ _ _ hnq _ hb; rewrite size_map hs /=.
    by apply (fresh_mu _ HmuB.bad{2}).
  + rcondf{2} 1; 1: by auto.
    inline{1} 1.
    wp; call{2} SDSIB_ll; wp.
    sp 1 0; if{1}.
    - wp; rnd{1}; skip => />.
      move=> &1 &2 _ _ _ _ hin _ _ _ c _ r _ _ _ _; rewrite get_set_sameE /= => <<- _.
      by rewrite hin.
    skip => />.
    move=> &1 &2 hct _ _ _ hin _ hne /domE hx r _ _ _ _ heq _ hb.
    move: hx heq; case _ : (HctT.t{2}.[_]) => // ct' hct' _ /= heq.
    have [_ /(_ hb) hti] := inv_ct_t _ _ _ _ _ hct hct'.
    by move: hne; rewrite heq hti.
- rcondf{2} 2; 1: by auto.
  exlim HctT.t{1}, HctT.tinv{1}, HctT.bad{1}, ct{1} => t0' ti0 b0 ct0.
  seq 1 0 : (HctT.t{1} = HctT.t{2} /\ HctT.tinv{1} = HctT.tinv{2} /\ HctT.bad{1} = HctT.bad{2} /\
             ct{1} = ct{2} /\ ! ct{2} \in HctT.tinv{2} /\ (exists i, (ct{1}, i) \in LX.RO.m{1}) /\
             inv_ct HctT.t{2} HctT.tinv{2} HctT.bad{2}).
  - by call{1} (sib_xc_lx_mem_ph ct0 t0' ti0 b0); auto => />.
  inline{1} 2.
  wp; call{2} SDSIB_ll; wp.
  sp 2 0; if{1}.
  - wp; rnd{1}; skip => />.
    move=> &1 &2 hnin i hi hct hx c _ r _ _ _ _; rewrite get_set_sameE /= => <<- _ hb.
    by move: hb; rewrite negb_or negb_or /= negb_exists /= => -[_ [_ /(_ i)]]; rewrite hi.
  skip => />.
  move=> &1 &2 hnin i hi hct /domE hx r _ _ _ _ heq.
  move: hx heq; case _ : (HctT.t{2}.[_]) => // ct' hct' _ /= heq.
  have [hin _] := inv_ct_t _ _ _ _ _ hct hct'.
  by move: hnin; rewrite heq hin.
qed.



(* ==================================================================== *)
(* Transfer lemmas (query bound and losslessness of the reduction)      *)
(* ==================================================================== *)

(* Every element of [xs] has a preimage in [cs] by [t]: [xs] is no larger
   than [cs]. *)
local lemma Red_card_witness ['a 'b] (xs : 'b fset) (cs : 'a fset) (t : ('a, 'b) fmap) :
  (forall x, x \in xs => exists c, c \in cs /\ t.[c] = Some x) =>
  card xs <= card cs.
proof.
move=> hw; apply (lez_trans (card (image (fun c => oget t.[c]) cs))).
+ apply subset_leq_fcard => x /hw [c [hc htc]].
  by apply/imageP; exists c => /=; rewrite htc.
exact fcard_image_leq.
qed.

(* Invariant of the query-bound transfer during the run of [A]: [xs] are the
   distinct inputs of the XOF of SimplifiedScheme ([SD.CountX], initially
   [xs0]), [cxs] the distinct [c~] queried by [A] to its challenge XOF
   ([CountXC]), [tinv] the inverse table of [Hct]. Each new XOF input is the
   preimage by [tinv] of a [c~] queried by [A]. [sqs] and [cs] are the
   numbers of signing queries of the reduction and of [A]. *)
local op red_inv (xs0 xs : (SD.DID.W * mu_t) fset) (qx : int) (cxs : ctilde fset)
            (cq sqs cs : int) (tinv : (ctilde, high list * mu_t) fmap) =
  qx = card (xs `\` xs0) /\ xs0 \subset xs /\ cq = card cxs /\ sqs = cs /\
  forall x, x \in xs `\` xs0 => exists ct, ct \in cxs /\ tinv.[ct] = Some x.

local lemma red_inv_tinv xs0 xs qx cxs cq sqs cs tinv c y :
  red_inv xs0 xs qx cxs cq sqs cs tinv => c \notin tinv =>
  red_inv xs0 xs qx cxs cq sqs cs tinv.[c <- y].
proof.
rewrite /red_inv => -[# h1 h2 h3 h4 hw] hc; do! split => // x /hw [ct [hct htc]].
exists ct; rewrite get_setE hct /=; case: (ct = c) => // ->>.
by move: hc; rewrite domE htc.
qed.

local lemma red_inv_cxs xs0 xs qx cxs cq sqs cs tinv c :
  red_inv xs0 xs qx cxs cq sqs cs tinv => c \notin cxs =>
  red_inv xs0 xs qx (cxs `|` fset1 c) (cq + 1) sqs cs tinv.
proof.
rewrite /red_inv => -[# h1 h2 h3 h4 hw] hc; do! split => //.
+ by rewrite fcardU1 hc h3 /b2i /=; ring.
move=> x /hw [ct [hct htc]]; exists ct.
by rewrite in_fsetU hct.
qed.

local lemma red_inv_xs xs0 xs qx cxs cq sqs cs tinv c x :
  red_inv xs0 xs qx cxs cq sqs cs tinv => c \in cxs => tinv.[c] = Some x =>
  x \notin xs =>
  red_inv xs0 (xs `|` fset1 x) (qx + 1) cxs cq sqs cs tinv.
proof.
rewrite /red_inv => -[# h1 h2 h3 h4 hw] hc htc hx; do! split => //.
+ have -> : (xs `|` fset1 x) `\` xs0 = (xs `\` xs0) `|` fset1 x.
  + apply fsetP => z; rewrite !(in_fsetD, in_fsetU, in_fset1).
    by case: (z = x) => // ->>; have := h2 x; smt().
  by rewrite fcardU1 in_fsetD hx h1 /b2i /=; ring.
+ by move=> z /h2 hz; rewrite in_fsetU hz.
move=> z; rewrite in_fsetD in_fsetU in_fset1 => -[[hz | ->>] hz0].
+ by apply hw; rewrite in_fsetD hz hz0.
by exists c.
qed.

local lemma red_inv_sign xs0 xs qx cxs cq sqs cs tinv :
  red_inv xs0 xs qx cxs cq sqs cs tinv =>
  red_inv xs0 xs qx cxs cq (sqs + 1) (cs + 1) tinv.
proof. by rewrite /red_inv => -[# h1 h2 h3 h4 hw]; do! split => //; rewrite h4. qed.

local lemma red_inv_init xs0 tinv : red_inv xs0 xs0 0 fset0 0 0 0 tinv.
proof.
rewrite /red_inv fsetDv !fcards0 /=; split => [z // | x].
by rewrite in_fset0.
qed.

local lemma red_inv_bound xs0 xs qx cxs cq sqs cs tinv :
  red_inv xs0 xs qx cxs cq sqs cs tinv => qx <= cq /\ sqs = cs.
proof.
rewrite /red_inv => -[# h1 h2 h3 h4 hw]; rewrite h1 h3 h4 /=.
by apply (Red_card_witness _ _ tinv).
qed.

local lemma Red_HctT_get xs0 :
  hoare [ HctT.get :
          red_inv xs0 SD.CountX.xs SD.CountX.qx CountXC.xs CountXC.q
                   SD.CountSX.qs CountS.q HctT.tinv ==>
          red_inv xs0 SD.CountX.xs SD.CountX.qx CountXC.xs CountXC.q
                   SD.CountSX.qs CountS.q HctT.tinv ].
proof.
proc; if; auto => &hr [hI _] ct _.
by case: (ct \in HctT.tinv{hr}) => //= hct; apply red_inv_tinv.
qed.

(* The forgery translation: [SampleInBall] only queries its argument, so it
   counts at most one new distinct XOF input. *)
local lemma Red_SIB_count (X <: SD.SIB.XOF_t{-SD.CountX}) x0 n :
  hoare [ SD.SIB.SampleInBall(SD.CountX(X)).get :
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
proof.
by proc; inline *; auto.
qed.

(* ---- end of the transfer helpers ---- *)

lemma B_bound
 (X'  <: SD.SIB.XOF_t{-RedMLDSA(A), -SD.CountX, -SD.CountSX})
 (SO' <: SD.DSSXOF.DS.Stateless.SOracle_CMA{-RedMLDSA(A), -SD.CountX, -SD.CountSX}) :
 hoare[ RedMLDSA(A, SD.CountX(X'), SD.CountSX(SO')).forge :
        SD.CountX.qx = 0 /\ SD.CountSX.qs = 0 ==>
        SD.CountX.qx <= qXC + 1 /\ SD.CountSX.qs <= qS].
proof.
proc.
exists* SD.CountX.xs; elim* => xs0.
seq 22 : (SD.CountX.qx <= qXC /\ SD.CountSX.qs <= qS).
- conseq (: _ ==> SD.CountX.qx <= CountXC.q /\ SD.CountSX.qs = CountS.q)
         (: _ ==> CountXC.q <= qXC /\ CountS.q <= qS); 1, 2: smt().
  + (* query bound of [A], syntactic instance of [A_bound] *)
    by call (A_bound XASim (XCSim(SD.CountX(X'))) ROtr.RO HmuB HctT
                     (SignRed(SD.CountSX(SO')))); inline *; auto.
  call (: red_inv xs0 SD.CountX.xs SD.CountX.qx CountXC.xs CountXC.q
                   SD.CountSX.qs CountS.q HctT.tinv).
  + (* signing oracle: one query of the reduction per query of A *)
    proc; inline SignRed(SD.CountSX(SO')).sign SD.CountSX(SO').sign.
    seq 7 : (red_inv xs0 SD.CountX.xs SD.CountX.qx CountXC.xs CountXC.q
                      SD.CountSX.qs CountS.q HctT.tinv).
    + wp; call (: true); wp; call (: true); 1: by auto.
      by auto => &hr hI; apply red_inv_sign.
    by sp; if; auto; call (Red_HctT_get xs0); auto.
  + (* Hct *)
    by proc; call (Red_HctT_get xs0); auto.
  + (* Hmu *)
    by proc; call (: true); auto.
  + (* Htr *)
    by proc; call (: true); auto.
  + (* challenge XOF: a new XOF input is the preimage of a [c~] queried by A *)
    proc; inline XCSim(SD.CountX(X')).get SD.CountX(X').get.
    seq 1 : (red_inv xs0 SD.CountX.xs SD.CountX.qx CountXC.xs CountXC.q
                      SD.CountSX.qs CountS.q HctT.tinv /\ y.`1 \in CountXC.xs).
    + auto => &hr hI; case: (y{hr}.`1 \in CountXC.xs{hr}) => //= hy.
      by rewrite in_fsetU in_fset1 /=; apply red_inv_cxs.
    sp; if; last by wp; call (: true); auto.
    wp; call (: true); auto => &hr [[<<- [hI hy]] hin] /=.
    case: (oget HctT.tinv{hr}.[y0{hr}.`1] \in SD.CountX.xs{hr}) => //= hx.
    by apply (red_inv_xs _ _ _ _ _ _ _ _ y0{hr}.`1) => //; rewrite -some_oget.
  + (* ExpandA XOF: does not touch the invariant *)
    by proc; call Red_XASim_true; auto.
  wp; call (: true); 1: by auto.
  inline *; auto => &hr [<<- [-> ->]] /= _ _.
  split; 1: by apply red_inv_init.
  by move=> _ tinv qs qx xs q q0 xs1; apply red_inv_bound.
(* the forgery translation makes at most one new XOF query *)
seq 4 : (SD.CountX.qx <= qXC /\ SD.CountSX.qs <= qS); 1: by wp; call (: true); auto.
if; last by auto => /#.
seq 1 : (#pre); 1: by auto.
exlim x => x0; wp; call (Red_SIB_count X' x0 qXC); auto => /#.
qed.

(* Losslessness of the reduction. The forgery translation runs
   [SD.SIB.SampleInBall(X).get], which diverges for some lossless XOFs, hence
   the extra hypothesis [islossless SD.SIB.SampleInBall(X).get], which is also
   the form of [A_ll] in section XOF of SimplifiedScheme.ec. *)
lemma B_ll
 (SO <: SD.DSSXOF.DS.Stateless.SOracle_CMA{-RedMLDSA(A)})
 (X  <: SD.SIB.XOF_t{-RedMLDSA(A)}) :
 islossless SO.sign => islossless X.get => islossless SD.SIB.SampleInBall(X).get =>
 islossless RedMLDSA(A, X, SO).forge.
proof.
move=> SO_ll X_ll SIB_ll; proc.
seq 22 : true => //.
- call (A_ll (CountXA(XASim)) (CountXC(XCSim(X))) (CountHtr(ROtr.RO))
             (CountHmu(HmuB)) (CountHct(HctT)) (CountS(SignRed(SO))) _ _ _ _ _ _).
  + by proc; call XASim_ll; auto.
  + proc; inline XCSim(X).get; wp; sp; if; 1: by call X_ll; auto.
    by inline *; auto; smt(dB_ll).
  + by proc; islossless.
  + by proc; islossless.
  + by proc; islossless.
  + proc; inline SignRed(SO).sign; wp; sp.
    seq 1 : true => //; 1: by islossless.
    seq 1 : true => //; 1: by call SO_ll.
    by sp; if; [islossless | auto].
  by islossless.
seq 3 : true => //; 1: by islossless.
by sp; if => //; wp; call SIB_ll; auto.
qed.

end section PROOF.

end MLDSAProof_Reduction.
