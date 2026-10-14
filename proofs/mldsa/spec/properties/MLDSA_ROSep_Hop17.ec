require import AllCore IntDiv List Distr DList PROM FMap FMapExtra Xreal StdBigop StdOrder.
from Jasmin require import JByte_array JWord.
require import Array256.

require import Parameters GFq Rq.
require import Spec65.
import MLDSA65.
import PolyLVec PolyKVec PolyMat.
import Round ZModQ Zq MLDSAParams.

require import MLDSA_RO MLDSA_ROSep MLDSA_ROSep_Hop1 MLDSA_ROSep_Hop2 MLDSA_ROSep_Hop3.
require import MLDSA_ROSep_Hop4 MLDSA_ROSep_Hop5 MLDSA_ROSep_Hop6 MLDSA_ROSep_Hop7 MLDSA_ROSep_Hop8.
require import MLDSA_ROSep_Hop9 MLDSA_ROSep_Hop10 MLDSA_ROSep_Hop11 MLDSA_ROSep_Hop12 MLDSA_ROSep_Hop13.
require import MLDSA_ROSep_Hop14 MLDSA_ROSep_Hop15 MLDSA_ROSep_Hop16.
require import ConcreteDRing MLDSATargetFIPS Leakage DistrExtra.
require DS_ROM.
import PolyReduce.
import TF.DV TF.DV.MatRq.Vectors TF.DV.MatRq.Matrices.

(*************** Termination ****************)

lemma xaw_get_ll : islossless XAw(DST.RO1.RO).get.
proof.
islossless.
by rewrite dB_dword; exact W8.dword_ll.
qed.

lemma xpandA_fips_ll : islossless ExpandA(XOFA_O(XAw(DST.RO1.RO))).sample.
proof.
apply (ExpandA_ll (XAw(DST.RO1.RO))
         (fun (g : glob XAw(DST.RO1.RO)) (x : W8.t list * int) =>
            if size x.`1 = 34 then xa_key x \in g.`2 else x \in g.`1) xaw_get_ll).
+ move=> g0 x; proc; if; inline *; auto => /> &hr; rewrite /xa_key /=; smt(mem_set).
+ move=> g0 x /= hk; proc; if; inline *.
  - rcondt 3; 1: by auto; smt().
    wp; rnd (pred1 W8.zero); auto => />.
    move=> &hr _ _; rewrite dB_dword JWordExtra.DW8.mu1_dword /=.
    by move=> v _ ->; rewrite get_set_sameE.
  - rcondt 3; 1: by auto; smt().
    wp; rnd (pred1 W8.zero); auto => />.
    move=> &hr _ _; rewrite JWordExtra.DW8.mu1_dword /=.
    by move=> v _ ->; rewrite get_set_sameE.
move=> g r /=; case: (size r = 34) => hr /=.
+ have [B hB] := fmap_bounded_snd g.`2 (xa_key (r, 0)).`1.
  by exists B => c; rewrite /xa_key /= => /hB.
have [B hB] := fmap_bounded_snd g.`1 r.
by exists B.
qed.

lemma tfexpandA_ll : islossless TF.ExpandA(DST.RO1.RO).get.
proof.
bypr => &m _.
have <- : Pr[ExpandA(XOFA_O(XAw(DST.RO1.RO))).sample(arg{m}) @ &m : true] =
          Pr[TF.ExpandA(DST.RO1.RO).get(arg{m}) @ &m : true].
+ byequiv (_ : ={rho, DST.RO1.RO.m, RO_xr.RO.m} ==> true) => //; conseq expandA_14.
by byphoare xpandA_fips_ll.
qed.

lemma ro2_get_ll : islossless DST.RO2.RO.get.
proof. by islossless; rewrite dB_dword; exact W8.dword_ll. qed.

lemma tfsib_ll : islossless TF.SIB.SampleInBall(DST.RO2.RO).get.
proof.
proc.
while (0 <= ctx /\ 0 <= i) (256 - i); last first.
+ wp; while (0 <= ctx) (8 - ctx); 1: by move=> z; wp; call ro2_get_ll; auto => /#.
  by auto => />; smt(tau_bound).
move=> z.
wp.
exlim (DST.RO2.RO.m), x, i => g0 x0 i0.
have [B hB] := fmap_bounded_snd g0 x0.
sp 1.
conseq (_ : x = x0 /\ i = i0 /\ 0 <= ctx /\ 0 <= i < 256 /\ 256 - i = z /\
            (forall c, (x, c) \in DST.RO2.RO.m => c < B \/ c < ctx) ==> _).
+ move=> &hr; smt().
while (x = x0 /\ i = i0 /\ 0 <= ctx /\ 0 <= i < 256 /\ 256 - i = z /\
       (forall c, (x, c) \in DST.RO2.RO.m => c < B \/ c < ctx))
      (if !(i < j) then 0 else if (x, ctx) \in DST.RO2.RO.m then max B (ctx + 1) - ctx + 1 else 1)
      (max B 0 + 2) (1%r / 256%r).
+ by [].
+ move=> &hr m c j; smt().
+ move=> &hr m c j [_ [_ [hc [[hi0 hi] [_ hk]]]]]; split; 2: smt().
  case: (i{hr} < j) => /= hij; 2: smt().
  case: ((x{hr}, c) \in m) => hm /=; 2: smt().
  by have := hk c hm; smt().
+ move=> hw.
  seq 3 : (x = x0 /\ i = i0 /\ 0 <= ctx /\ 0 <= i < 256 /\ 256 - i = z /\
           (forall c, (x, c) \in DST.RO2.RO.m => c < B \/ c < ctx)).
  * by wp; call (: true); auto.
  * wp; inline *; auto => /> &hr hc hi0 hi hz hk hij.
    rewrite dB_dword W8.dword_ll /=.
    move=> v _; split => hm; (split; 1: smt()); move=> c; rewrite ?mem_set; smt().
  * by apply hw.
  * hoare; wp; inline *; auto => /> &hr hc hi0 hi hz hk hij v _.
    split => hm; (split; 1: smt()); move=> c; rewrite ?mem_set; smt().
  * by [].
+ wp; inline *; auto => />.
  move=> &hr hc hi0 hi hk hij; rewrite dB_dword W8.dword_ll /= => v _.
  split => hm; (split; 1: smt()); move=> c; rewrite ?mem_set; smt().
split; 1: smt().
move=> z0; case ((x, ctx) \in DST.RO2.RO.m).
+ conseq (_ : _ ==> _ : = 1%r); 1: smt().
  inline *; rcondf 3; 1: by auto.
  wp; rnd; auto => />.
  move=> &hr hc hi0 hi hk hij hm.
  rewrite dB_dword W8.dword_ll /=.
  have hcB : ctx{hr} < B by smt().
  smt().
inline *; rcondt 3; 1: by auto.
wp; rnd (pred1 W8.zero); auto => />.
move=> &hr hc hi0 hi hk hij hm.
rewrite dB_dword JWordExtra.DW8.mu1_dword /=.
move=> v _ ->; rewrite get_set_sameE /= ?W8.to_uint0; smt().
qed.

lemma roy_get_ll : islossless RO_y.RO.get.
proof.
islossless.
have hg : gamma1 = 524288 by rewrite /gamma1 /gamma1_log /Params65.gamma1_log.
by apply LArrayE.darray_ll; apply Rq.dpoly_ll; rewrite hg.
qed.

lemma dbytes64_ll : is_lossless dbytes64.
proof. by apply dmap_ll; apply dlist_ll; exact W8.dword_ll. qed.

lemma dbytesCT_ll : is_lossless dbytesCT.
proof. by apply dmap_ll; apply dlist_ll; exact W8.dword_ll. qed.

lemma ro1_get_ll : islossless DST.RO1.RO.get.
proof. by islossless; rewrite dB_dword; exact W8.dword_ll. qed.

lemma ro3_get_ll : islossless DST.RO3.RO.get.
proof. by islossless; exact dbytes64_ll. qed.

lemma ro4_get_ll : islossless DST.RO4.RO.get.
proof. by islossless; exact dbytes64_ll. qed.

lemma ro5_get_ll : islossless DST.RO5.RO.get.
proof. by islossless; exact dbytesCT_ll. qed.

lemma ysign_ll : islossless MLDSA_Y(DST.RO1.RO, DST.RO2.RO, DST.RO3.RO, DST.RO4.RO, DST.RO5.RO).sign.
proof.
proc.
while true (kappa_max - ctr).
+ move=> z; wp; call tfsib_ll; call ro5_get_ll; wp; call roy_get_ll; auto => /> /#.
by wp; call ro4_get_ll; call tfexpandA_ll; auto => /> /#.
qed.

lemma tfsign_ll : islossless TF.MLDSA(DST.RO1.RO, DST.RO2.RO, DST.RO3.RO, DST.RO4.RO, DST.RO5.RO).sign.
proof.
proc.
while true (kappa_max - ctr).
+ move=> z; wp; call tfsib_ll; call ro5_get_ll; auto => />.
  smt(TF.dRq_mask_ll TF.DV.MatRq.Vectors.dvector_ll).
by wp; call ro4_get_ll; call tfexpandA_ll; auto => /> /#.
qed.

lemma tfverify_ll : islossless TF.MLDSA(DST.RO1.RO, DST.RO2.RO, DST.RO3.RO, DST.RO4.RO, DST.RO5.RO).verify.
proof. by proc; call ro5_get_ll; wp; call tfsib_ll; call ro4_get_ll; call ro3_get_ll; call tfexpandA_ll; auto. qed.

lemma v16_ll : islossless V16.verify.
proof.
proc; seq 2 : true => //.
+ by wp; call sigDecode_ll.
by if => //; call tfverify_ll.
qed.

lemma rorest_ll : islossless RO_rest.RO.get.
proof. by islossless; rewrite /dblock; apply dlist_ll; exact W8.dword_ll. qed.

lemma ropad_ll : islossless RO_pad.RO.get.
proof. by islossless; apply dlist_ll; exact W8.dword_ll. qed.

lemma rohr_ll : islossless RO_hr.RO.get.
proof. by islossless; exact dbytesCT_ll. qed.

lemma roxr_ll : islossless RO_xr.RO.get.
proof. by islossless; exact W8.dword_ll. qed.

lemma hctroute_ll : islossless HctRoute(Hctw(DST.RO5.RO)).get.
proof. by proc; if; [inline Hctw(DST.RO5.RO).get; wp; call ro5_get_ll; auto | call rohr_ll; auto]. qed.

lemma htrw_ll : islossless Htrw(DST.RO3.RO).get.
proof. by proc; call ro3_get_ll; call pkDecode_ll. qed.

lemma blockof_ll : islossless BlockOf(XCw(DST.RO2.RO)).get.
proof.
proc; while true (64 - i); 2: by auto => /#.
by move=> z; inline XCw(DST.RO2.RO).get; wp; call ro2_get_ll; auto => /#.
qed.

lemma rH_ll (A <: DS2.Adversary) (O <: DS11.SOracle) :
  islossless Router11(A, XAw(DST.RO1.RO), XCw(DST.RO2.RO), Htrw(DST.RO3.RO), DST.RO4.RO,
                      Hctw(DST.RO5.RO), O).H.get.
proof.
proc; sp; if.
+ by if; [wp; call ro4_get_ll; auto | call rorest_ll; auto].
if.
+ by if; [wp; call ropad_ll; call hctroute_ll; auto | call rorest_ll; auto].
if; 1: by call blockof_ll; auto.
by if; [wp; call htrw_ll; auto | call rorest_ll; auto].
qed.

(*************** The mask distribution ****************)

lemma dpolyl_mask : dmap (dpolyl (dpoly (-gamma1 + 1) gamma1)) vec_of_l = dvector dmask lvec.
proof.
have /= H := param_sets.
rewrite /dpolyl /LArrayE.darray /TF.DV.MatRq.Vectors.dvector /dmask (_ : max 0 lvec = lvec) 1:/#.
rewrite (dlist_dmap (dpoly (-gamma1 + 1) gamma1) poly2alg lvec) !dmap_comp.
apply eq_dmap_in => x hx; rewrite /(\o) /vec_of_l LArray.of_listK //.
by move: hx; rewrite supp_dlist; smt(gt0_l).
qed.

lemma mu1_dmask_l (v : vector) :
  size v = lvec => mu1 (dvector dmask lvec) v = mu1 (dpolyl (dpoly (-gamma1 + 1) gamma1)) (l_of_vec v).
proof.
move=> hs; rewrite -dpolyl_mask dmap1E; apply mu_eq => x; rewrite /pred1 /(\o) /=; smt(vec_of_lK l_of_vecK).
qed.

(*************** G17: y sampled afresh in every iteration ****************)

module Sign17 = {
  proc sign(sk : TF.SK, m : W8.t list) : BytesSig.t option * Leakage list = {
    var rs, sg, s;
    rs <@ TF.MLDSA(DST.RO1.RO, DST.RO2.RO, DST.RO3.RO, DST.RO4.RO, DST.RO5.RO).sign(sk, m);
    sg <- None;
    if (rs.`1 <> None) {
      s <@ SigEncDec.sigEncode((oget rs.`1).`1, l_of_vec (oget rs.`1).`2.`1, poly_of_hints (oget rs.`1).`2.`2);
      sg <- Some s;
    }
    return (sg, tleak rs.`2);
  }
}.

module G17(A : DS2.Adversary) = {
  module O = {
    proc sign(m : W8.t list) : BytesSig.t option * Leakage list = {
      var r;
      G13.qs <- m :: G13.qs;
      r <@ Sign17.sign(G13.sk, m);
      return r;
    }
  }

  proc main() : bool = {
    var pk, pkb, m, s, b;
    DST.RO1.RO.init();
    RO_xr.RO.init();
    DST.RO2.RO.init();
    DST.RO3.RO.init();
    DST.RO4.RO.init();
    DST.RO5.RO.init();
    G13.qs <- [];
    (pkb, G13.sk, pk) <@ KG16.keygen();
    (m, s) <@ Router11(A, XAw(DST.RO1.RO), XCw(DST.RO2.RO), Htrw(DST.RO3.RO), DST.RO4.RO,
                       Hctw(DST.RO5.RO), O).forge(pkb);
    b <@ V16.verify(pk, m, s);
    return b /\ !(m \in G13.qs);
  }
}.

(*************** The coins drawn by the signing oracle ****************)

module Coins = {
  var bad : bool
  var cl : rnd_ list

  proc draw() : rnd_ = {
    var coins;
    coins <$ drnd;
    bad <- bad \/ coins \in cl;
    cl <- coins :: cl;
    return coins;
  }
}.

module Sign16c = {
  proc sign(sk : TF.SK, m : W8.t list) : BytesSig.t option * Leakage list = {
    var coins, rs, sg, s;
    coins <@ Coins.draw();
    rs <@ MLDSA_Y(DST.RO1.RO, DST.RO2.RO, DST.RO3.RO, DST.RO4.RO, DST.RO5.RO).sign(sk, m, coins);
    sg <- None;
    if (rs.`1 <> None) {
      s <@ SigEncDec.sigEncode((oget rs.`1).`1, l_of_vec (oget rs.`1).`2.`1, poly_of_hints (oget rs.`1).`2.`2);
      sg <- Some s;
    }
    return (sg, tleak rs.`2);
  }
}.

module Sign17c = {
  proc sign(sk : TF.SK, m : W8.t list) : BytesSig.t option * Leakage list = {
    var r;
    Coins.draw();
    r <@ Sign17.sign(sk, m);
    return r;
  }
}.

module type Signer = {
  proc sign(sk : TF.SK, m : W8.t list) : BytesSig.t option * Leakage list
}.

module GC(S : Signer, A : DS2.Adversary) = {
  module O = {
    proc sign(m : W8.t list) : BytesSig.t option * Leakage list = {
      var r;
      G13.qs <- m :: G13.qs;
      r <@ S.sign(G13.sk, m);
      return r;
    }
  }

  proc main() : bool = {
    var pk, pkb, m, s, b;
    Coins.bad <- false;
    Coins.cl <- [];
    DST.RO1.RO.init();
    RO_xr.RO.init();
    DST.RO2.RO.init();
    DST.RO3.RO.init();
    DST.RO4.RO.init();
    DST.RO5.RO.init();
    G13.qs <- [];
    (pkb, G13.sk, pk) <@ KG16.keygen();
    (m, s) <@ Router11(A, XAw(DST.RO1.RO), XCw(DST.RO2.RO), Htrw(DST.RO3.RO), DST.RO4.RO,
                       Hctw(DST.RO5.RO), O).forge(pkb);
    b <@ V16.verify(pk, m, s);
    return b /\ !(m \in G13.qs);
  }
}.

(*************** Fresh coins give a fresh y ****************)

op yinv (m : (rnd_ * Bytes64.t * int, polylvec) fmap) (cl : rnd_ list) =
  forall x, x \in m => x.`1 \in cl.

equiv ysign_fresh (cl0 : rnd_ list) :
  MLDSA_Y(DST.RO1.RO, DST.RO2.RO, DST.RO3.RO, DST.RO4.RO, DST.RO5.RO).sign ~
  TF.MLDSA(DST.RO1.RO, DST.RO2.RO, DST.RO3.RO, DST.RO4.RO, DST.RO5.RO).sign :
  ={sk, m, glob DST.RO1.RO, glob DST.RO2.RO, glob DST.RO3.RO, glob DST.RO4.RO, glob DST.RO5.RO} /\
  yinv RO_y.RO.m{1} cl0 /\ coins{1} \in cl0 /\ (forall mu k, (coins{1}, mu, k) \notin RO_y.RO.m{1})
  ==> ={res, glob DST.RO1.RO, glob DST.RO2.RO, glob DST.RO3.RO, glob DST.RO4.RO, glob DST.RO5.RO} /\
      yinv RO_y.RO.m{1} cl0.
proof.
proc.
while (={s1, s2, t0, mA, mu, ct, ctr, response, leak, glob DST.RO1.RO, glob DST.RO2.RO, glob DST.RO3.RO,
         glob DST.RO4.RO, glob DST.RO5.RO} /\
       yinv RO_y.RO.m{1} cl0 /\ coins{1} \in cl0 /\
       (forall mu k, (coins{1}, mu, k) \in RO_y.RO.m{1} => k < ctr{1})); last first.
+ wp; call (: ={glob DST.RO4.RO}); 1: by sim.
  call (: ={glob DST.RO1.RO}); 1: by sim.
  by auto => /> /#.
inline{1} RO_y.RO.get.
seq 5 1 : (={y, s1, s2, t0, mA, mu, ct, ctr, response, leak, glob DST.RO1.RO, glob DST.RO2.RO,
             glob DST.RO3.RO, glob DST.RO4.RO, glob DST.RO5.RO} /\
           yinv RO_y.RO.m{1} cl0 /\ coins{1} \in cl0 /\
           (forall mu k, (coins{1}, mu, k) \in RO_y.RO.m{1} => k < ctr{1} + 1)).
+ rcondt{1} 3; 1: by auto => /> /#.
  wp; rnd vec_of_l l_of_vec; auto => />.
  have hszl : forall v, v \in dvector dmask lvec => size v = lvec by move=> v /size_dvector; smt(gt0_l).
  move=> &1 &2 hy hc hk _; split; 1: by move=> v /hszl /l_of_vecK ->.
  move=> _; split; 1: by move=> v /hszl /mu1_dmask_l.
  move=> _ r hr; split; 1: by rewrite -dpolyl_mask supp_dmap; exists r.
  move=> _; split; 1: by rewrite vec_of_lK.
  move=> _; rewrite get_set_sameE /=; split.
  + by move=> x; rewrite mem_set => -[/hy | ->].
  by move=> mu0 k; rewrite mem_set => -[/hk | ] /#.
wp; call (: ={glob DST.RO2.RO}); 1: by sim.
wp; call (: ={glob DST.RO5.RO}); 1: by sim.
by auto => />.
qed.

lemma draw_ll : islossless Coins.draw.
proof. by islossless; exact drnd_ll. qed.

lemma sign16c_ll : islossless Sign16c.sign.
proof.
proc; seq 2 : true => //.
+ by call ysign_ll; call draw_ll.
by sp; if; [wp; call sigEncode_ll; auto | auto].
qed.

lemma sign17_ll : islossless Sign17.sign.
proof.
proc; seq 1 : true => //.
+ by call tfsign_ll.
by sp; if; [wp; call sigEncode_ll; auto | auto].
qed.

lemma sign17c_bad : phoare [Sign17c.sign : Coins.bad ==> Coins.bad] = 1%r.
proof. by proc; call sign17_ll; inline *; auto => />; smt(drnd_ll). qed.

(* The signing oracles agree unless the coins of a query were drawn before *)
equiv sign_c : Sign16c.sign ~ Sign17c.sign :
  ={sk, m, glob DST.RO1.RO, glob DST.RO2.RO, glob DST.RO3.RO, glob DST.RO4.RO, glob DST.RO5.RO,
    Coins.bad, Coins.cl} /\ !Coins.bad{2} /\ yinv RO_y.RO.m{1} Coins.cl{1}
  ==> !Coins.bad{2} =>
      ={res, glob DST.RO1.RO, glob DST.RO2.RO, glob DST.RO3.RO, glob DST.RO4.RO, glob DST.RO5.RO,
        Coins.bad, Coins.cl} /\ yinv RO_y.RO.m{1} Coins.cl{1}.
proof.
proc; inline Coins.draw Sign17.sign.
seq 4 5 : (={glob DST.RO1.RO, glob DST.RO2.RO, glob DST.RO3.RO, glob DST.RO4.RO, glob DST.RO5.RO,
             Coins.bad, Coins.cl} /\ sk{1} = sk0{2} /\ m{1} = m0{2} /\ coins{1} \in Coins.cl{1} /\
           yinv RO_y.RO.m{1} Coins.cl{1} /\
           (!Coins.bad{2} => forall mu k, (coins{1}, mu, k) \notin RO_y.RO.m{1})).
+ auto => /> &1 &2 hb hy c _; split; 1: by move=> x /hy /= ->.
  by move=> hc mu k; apply/negP => /hy /=.
case (Coins.bad{2}).
+ conseq (: _ ==> true) => //.
  seq 1 1 : true; 1: by call{1} ysign_ll; call{2} tfsign_ll.
  by sp; if{1}; if{2}; wp; try call{1} sigEncode_ll; try call{2} sigEncode_ll; auto.
exlim Coins.cl{1} => cl0.
seq 1 1 : (={rs, glob DST.RO1.RO, glob DST.RO2.RO, glob DST.RO3.RO, glob DST.RO4.RO, glob DST.RO5.RO,
             Coins.bad, Coins.cl} /\ Coins.cl{1} = cl0 /\ yinv RO_y.RO.m{1} cl0).
+ by call (ysign_fresh cl0); auto => /> /#.
by sp; if => //; [wp; call (: true); [sim | auto => />] | auto => />].
qed.

(*************** Potentials that the oracles leave unchanged ****************)

ehoare ro1_e (u : xreal) : DST.RO1.RO.get : u ==> u.
proof. by proc; auto => &hr; rewrite (eq_Ep _ _ (fun _ => u)) 1:/# EpC dB_dword W8.dword_ll. qed.

ehoare ro2_e (u : xreal) : DST.RO2.RO.get : u ==> u.
proof. by proc; auto => &hr; rewrite (eq_Ep _ _ (fun _ => u)) 1:/# EpC dB_dword W8.dword_ll. qed.

ehoare ro3_e (u : xreal) : DST.RO3.RO.get : u ==> u.
proof. by proc; auto => &hr; rewrite (eq_Ep _ _ (fun _ => u)) 1:/# EpC dbytes64_ll. qed.

ehoare ro4_e (u : xreal) : DST.RO4.RO.get : u ==> u.
proof. by proc; auto => &hr; rewrite (eq_Ep _ _ (fun _ => u)) 1:/# EpC dbytes64_ll. qed.

ehoare ro5_e (u : xreal) : DST.RO5.RO.get : u ==> u.
proof. by proc; auto => &hr; rewrite (eq_Ep _ _ (fun _ => u)) 1:/# EpC dbytesCT_ll. qed.

ehoare roxr_e (u : xreal) : RO_xr.RO.get : u ==> u.
proof. by proc; auto => &hr; rewrite (eq_Ep _ _ (fun _ => u)) 1:/# EpC W8.dword_ll. qed.

ehoare rohr_e (u : xreal) : RO_hr.RO.get : u ==> u.
proof. by proc; auto => &hr; rewrite (eq_Ep _ _ (fun _ => u)) 1:/# EpC dbytesCT_ll. qed.

ehoare xaw_e (u : xreal) : XAw(DST.RO1.RO).get : u ==> u.
proof.
proc; if.
+ by call (ro1_e u); skip => &hr; apply xle_cxr_r.
by call (roxr_e u); skip => &hr; apply xle_cxr_r.
qed.

ehoare blockof_e (u : xreal) : BlockOf(XCw(DST.RO2.RO)).get : u ==> u.
proof.
proc; while (u); [by move=> &hr; apply xle_cxr_r | | by auto].
by inline XCw(DST.RO2.RO).get; wp; call (ro2_e u); auto => &hr; apply xle_cxr_r.
qed.

ehoare hctroute_e (u : xreal) : HctRoute(Hctw(DST.RO5.RO)).get : u ==> u.
proof.
proc; if.
+ by inline Hctw(DST.RO5.RO).get; wp; call (ro5_e u); auto => &hr; apply xle_cxr_r.
by call (rohr_e u); skip => &hr; apply xle_cxr_r.
qed.

ehoare htrw_e (u : xreal) : Htrw(DST.RO3.RO).get : u ==> u.
proof. by proc; call (ro3_e u); call (pkDecode_e u); auto. qed.

ehoare rH_e (A <: DS2.Adversary) (O <: DS11.SOracle) (u : xreal) :
  Router11(A, XAw(DST.RO1.RO), XCw(DST.RO2.RO), Htrw(DST.RO3.RO), DST.RO4.RO, Hctw(DST.RO5.RO), O).H.get :
  u ==> u.
proof.
proc; seq 1 : u; 1: by auto.
if.
+ if.
  - by wp; call (ro4_e u); skip => &hr; do ! (apply xle_cxr_r => _).
  - by call (RO_rest_e u); skip => &hr; do ! (apply xle_cxr_r => _).
if.
+ if.
  - by wp; call (pad_get_e u); call (hctroute_e u); skip => &hr; do ! (apply xle_cxr_r => _).
  - by call (RO_rest_e u); skip => &hr; do ! (apply xle_cxr_r => _).
if.
+ by call (blockof_e u); skip => &hr; do ! (apply xle_cxr_r => _).
if.
+ by wp; call (htrw_e u); skip => &hr; do ! (apply xle_cxr_r => _).
by call (RO_rest_e u); skip => &hr; do ! (apply xle_cxr_r => _).
qed.

ehoare tfexpandA_e (u : xreal) : TF.ExpandA(DST.RO1.RO).get : u ==> u.
proof.
proc; while (u); [by move=> &hr; apply xle_cxr_r | | by auto].
wp; while (u); [by move=> &hr; apply xle_cxr_r | | by auto => &hr; apply xle_cxr_r].
wp; while (u); [by move=> &hr; apply xle_cxr_r | | by auto => &hr; apply xle_cxr_r].
by wp; do 3! call (ro1_e u); auto => &hr; apply xle_cxr_r.
qed.

ehoare tfsib_e (u : xreal) : TF.SIB.SampleInBall(DST.RO2.RO).get : u ==> u.
proof.
proc; wp.
while (u); [by move=> &hr; apply xle_cxr_r | | ].
+ wp; while (u); [by move=> &hr; apply xle_cxr_r | by wp; call (ro2_e u); auto => &hr; apply xle_cxr_r |
                  by auto => &hr; apply xle_cxr_r].
wp; while (u); [by move=> &hr; apply xle_cxr_r | by wp; call (ro2_e u); auto => &hr; apply xle_cxr_r | by auto].
qed.

ehoare tfsign_e (u : xreal) : TF.MLDSA(DST.RO1.RO, DST.RO2.RO, DST.RO3.RO, DST.RO4.RO, DST.RO5.RO).sign :
  u ==> u.
proof.
proc; while (u); [by move=> &hr; apply xle_cxr_r | | by wp; call (ro4_e u); call (tfexpandA_e u); auto].
wp; call (tfsib_e u); call (ro5_e u); auto => &hr.
have hll : is_lossless (dvector dmask lvec) by smt(TF.dRq_mask_ll dvector_ll).
by rewrite EpC hll smul1m; apply xle_cxr_r.
qed.

ehoare sign17_e (u : xreal) : Sign17.sign : u ==> u.
proof.
proc; seq 2 : u.
+ by wp; call (tfsign_e u); auto.
if; 2: by auto => &hr; apply xle_cxr_r.
by wp; call (sigEncode_e u); auto => &hr; apply xle_cxr_r.
qed.

ehoare ykeygen_e (u : xreal) : MLDSA_Y(DST.RO1.RO, DST.RO2.RO, DST.RO3.RO, DST.RO4.RO, DST.RO5.RO).keygen :
  u ==> u.
proof.
proc; call (ro3_e u); wp.
have hl : is_lossless (dvector (dpoly_ball Eta) lvec) by apply dvector_ll; exact (DR.dRq__ll Eta).
have hk : is_lossless (dvector (dpoly_ball Eta) kvec) by apply dvector_ll; exact (DR.dRq__ll Eta).
conseq (_ : _ ==> u).
+ by move=> &hr; rewrite !EpC hk hl !smul1m.
+ by move=> _; rewrite !EpC hk hl !smul1m; apply xle_cxr_r.
call (tfexpandA_e u); auto => &hr.
by rewrite EpC TF.dseed_ll smul1m.
qed.

ehoare kg16_e (u : xreal) : KG16.keygen : u ==> u.
proof. by proc; call (pkEncode_e u); call (ykeygen_e u); inline *; auto. qed.

ehoare yverify_e (u : xreal) : MLDSA_Y(DST.RO1.RO, DST.RO2.RO, DST.RO3.RO, DST.RO4.RO, DST.RO5.RO).verify :
  u ==> u.
proof.
by proc; call (ro5_e u); wp; call (tfsib_e u); call (ro4_e u); call (ro3_e u); call (tfexpandA_e u); auto.
qed.

ehoare v16_e (u : xreal) : V16.verify : u ==> u.
proof.
proc; seq 2 : u.
+ by wp; call (sigDecode_e u); auto.
if; 2: by auto => &hr; apply xle_cxr_r.
by call (yverify_e u); auto => &hr; apply xle_cxr_r.
qed.

(*************** The coin-collision potential ****************)

(* tsum qS c = c + (c + 1) + ... + (qS - 1) *)
op tsum (qS c : int) : real = (qS * (qS - 1) - c * (c - 1))%r / 2%r.

lemma tsumS qS c : tsum qS c = tsum qS (c + 1) + c%r.
proof. rewrite /tsum; smt(). qed.

lemma tsum_ge0 qS c : 0 <= c <= qS => 0%r <= tsum qS c.
proof.
move=> hc; rewrite /tsum; have : c * (c - 1) <= qS * (qS - 1) by smt().
smt().
qed.

(* After c signing queries, the remaining queries collide with probability at most tsum qS c * eps *)
op ipot (qS : int) (eps : real) (c : int) (cl : rnd_ list) (b : bool) : xreal =
  (size cl = c /\ 0 <= c /\ 0%r <= eps /\ forall r, mu1 drnd r <= eps) `|`
  (if c <= qS then (b2r b + tsum qS c * eps)%xr else 0%xr).

section.

declare module A <: DS2.Adversary {
  -DS2.RO1.RO, -DS2.RO2.RO, -DS2.EUF_CMA, -XOFA_O, -XOFS_O, -MLDSA_RO_DS1, -RoutedH,
  -DS5.RO1.RO, -DS5.RO2.RO, -DS5.RO3.RO, -DS5.RO4.RO, -DS5.RO5.RO, -DS5.EUF_CMA, -RO_rest.RO,
  -RO_pad.RO, -RO_pad.FRO, -RO_seed.RO, -RO_S.RO, -RO_rhopp.RO, -RO_v.RO, -CountH, -CountS, -St5,
  -RO_lp.RO, -RO_lp.FRO, -St6, -St7, -Router, -RO_y.RO, -DS8.EUF_CMA, -DS10.EUF_CMA, -DS10.RO5.RO,
  -RO_hr.RO, -Router10, -DS11.EUF_CMA, -RO_xc.RO, -RO_xc.FRO, -Router11, -DST.RO1.RO, -DST.RO2.RO,
  -DST.RO3.RO, -DST.RO4.RO, -DST.RO5.RO, -DST.EUF_CMA, -RO_xr.RO, -G13, -Coins }.

local lemma G16_GC &m : Pr[G16(A).main() @ &m : res] = Pr[GC(Sign16c, A).main() @ &m : res].
proof.
byequiv (: ={glob A} ==> ={res}) => //.
proc.
inline{1} Router11(A, XAw(DST.RO1.RO), XCw(DST.RO2.RO), Htrw(DST.RO3.RO), DST.RO4.RO, Hctw(DST.RO5.RO), G16(A).O).forge.
inline{2} Router11(A, XAw(DST.RO1.RO), XCw(DST.RO2.RO), Htrw(DST.RO3.RO), DST.RO4.RO, Hctw(DST.RO5.RO),
                   GC(Sign16c, A).O).forge.
wp; call (: ={glob DST.RO1.RO, glob DST.RO2.RO, glob DST.RO3.RO, glob DST.RO4.RO, glob DST.RO5.RO}); 1: by sim.
wp; call (: ={glob DST.RO1.RO, glob RO_xr.RO, glob DST.RO2.RO, glob DST.RO3.RO, glob DST.RO4.RO, glob DST.RO5.RO,
              RO_y.RO.m, RO_rest.RO.m, RO_pad.RO.m, RO_hr.RO.m, Router11.tr, G13.qs, G13.sk}).
+ by proc; inline Sign16.sign Sign16c.sign Coins.draw; sim.
+ by sim.
+ by sim.
call (: ={glob DST.RO3.RO}); 1: by sim.
inline{1} RO_rest.RO.init RO_pad.RO.init RO_hr.RO.init; inline{2} RO_rest.RO.init RO_pad.RO.init RO_hr.RO.init; wp.
call (: ={glob DST.RO1.RO, glob DST.RO3.RO} ==> ={res, glob DST.RO1.RO, glob DST.RO3.RO, RO_y.RO.m}); 1: by sim.
by inline *; auto => />.
qed.

local lemma GC_G17 &m : Pr[GC(Sign17c, A).main() @ &m : res] = Pr[G17(A).main() @ &m : res].
proof.
byequiv (: ={glob A} ==> ={res}) => //.
proc.
inline{1} Router11(A, XAw(DST.RO1.RO), XCw(DST.RO2.RO), Htrw(DST.RO3.RO), DST.RO4.RO, Hctw(DST.RO5.RO),
                   GC(Sign17c, A).O).forge.
inline{2} Router11(A, XAw(DST.RO1.RO), XCw(DST.RO2.RO), Htrw(DST.RO3.RO), DST.RO4.RO, Hctw(DST.RO5.RO), G17(A).O).forge.
wp; call (: ={glob DST.RO1.RO, glob DST.RO2.RO, glob DST.RO3.RO, glob DST.RO4.RO, glob DST.RO5.RO}); 1: by sim.
wp; call (: ={glob DST.RO1.RO, glob RO_xr.RO, glob DST.RO2.RO, glob DST.RO3.RO, glob DST.RO4.RO, glob DST.RO5.RO,
              RO_rest.RO.m, RO_pad.RO.m, RO_hr.RO.m, Router11.tr, G13.qs, G13.sk}).
+ proc; inline{1} Sign17c.sign Coins.draw; wp.
  call (: ={glob DST.RO1.RO, glob DST.RO2.RO, glob DST.RO3.RO, glob DST.RO4.RO, glob DST.RO5.RO}); 1: by sim.
  by wp; rnd{1}; auto => />; exact drnd_ll.
+ by sim.
+ by sim.
call (: ={glob DST.RO3.RO}); 1: by sim.
inline{1} RO_rest.RO.init RO_pad.RO.init RO_hr.RO.init; inline{2} RO_rest.RO.init RO_pad.RO.init RO_hr.RO.init; wp.
call (: ={glob DST.RO1.RO, glob DST.RO3.RO} ==> ={res, glob DST.RO1.RO, glob DST.RO3.RO}); 1: by sim.
by inline *; auto => />.
qed.

local lemma GC_uptobad &m :
  (forall (H1 <: DS2.POracle1 {-A}) (H2 <: DS2.POracle2 {-A}) (O <: DS2.SOracle {-A}),
     islossless H1.get => islossless H2.get => islossless O.sign =>
     islossless A(H1, H2, O).forge) =>
  Pr[GC(Sign16c, A).main() @ &m : res] <= Pr[GC(Sign17c, A).main() @ &m : res \/ Coins.bad].
proof.
move=> A_ll.
byequiv (: ={glob A} ==> !Coins.bad{2} => ={res}) => //; 2: smt().
proc.
inline{1} Router11(A, XAw(DST.RO1.RO), XCw(DST.RO2.RO), Htrw(DST.RO3.RO), DST.RO4.RO, Hctw(DST.RO5.RO),
                   GC(Sign16c, A).O).forge.
inline{2} Router11(A, XAw(DST.RO1.RO), XCw(DST.RO2.RO), Htrw(DST.RO3.RO), DST.RO4.RO, Hctw(DST.RO5.RO),
                   GC(Sign17c, A).O).forge.
seq 17 17 : (={pk} /\
             (!Coins.bad{2} => ={m, s, G13.qs, glob DST.RO1.RO, glob DST.RO2.RO, glob DST.RO3.RO, glob DST.RO4.RO,
                                 glob DST.RO5.RO})).
+ wp.
  call (: Coins.bad,
          ={glob DST.RO1.RO, glob RO_xr.RO, glob DST.RO2.RO, glob DST.RO3.RO, glob DST.RO4.RO, glob DST.RO5.RO,
            RO_rest.RO.m, RO_pad.RO.m, RO_hr.RO.m, Router11.tr, G13.qs, G13.sk, Coins.bad, Coins.cl} /\
          yinv RO_y.RO.m{1} Coins.cl{1}).
  + by move=> H1 H2 O hO h2 h1; apply (A_ll H1 H2 O).
  + by proc; call sign_c; auto => /> /#.
  + by move=> &2 _; proc; call sign16c_ll; auto.
  + by proc; call sign17c_bad; auto.
  + conseq (_ : ={arg, glob DST.RO1.RO, glob RO_xr.RO} ==> ={res, glob DST.RO1.RO, glob RO_xr.RO}) => />.
    by sim.
  + by move=> &2 _; exact xaw_get_ll.
  + by move=> _; proc; if; [call ro1_get_ll | call roxr_ll]; auto.
  + conseq (_ : ={arg, glob DST.RO1.RO, glob RO_xr.RO, glob DST.RO2.RO, glob DST.RO3.RO, glob DST.RO4.RO,
                  glob DST.RO5.RO, RO_rest.RO.m, RO_pad.RO.m, RO_hr.RO.m, Router11.tr} ==>
                ={res, glob DST.RO1.RO, glob RO_xr.RO, glob DST.RO2.RO, glob DST.RO3.RO, glob DST.RO4.RO,
                  glob DST.RO5.RO, RO_rest.RO.m, RO_pad.RO.m, RO_hr.RO.m, Router11.tr}) => />.
    by sim.
  + by move=> &2 _; exact (rH_ll A (<: GC(Sign16c, A).O)).
  + by move=> _; conseq (rH_ll A (<: GC(Sign17c, A).O)).
  call (: ={glob DST.RO3.RO}); 1: by sim.
  inline{1} RO_rest.RO.init RO_pad.RO.init RO_hr.RO.init; inline{2} RO_rest.RO.init RO_pad.RO.init RO_hr.RO.init.
  wp; inline KG16.keygen RO_y.RO.init.
  wp; call (: true); 1: by sim.
  call (: ={glob DST.RO1.RO, glob DST.RO3.RO}); 1: by sim.
  inline *; auto => />.
  split; 1: by move=> x; rewrite mem_empty.
  by move=> _ rL rR *; smt().
case (Coins.bad{2}).
+ by call{1} v16_ll; call{2} v16_ll; auto => />.
by call (: ={glob DST.RO1.RO, glob DST.RO2.RO, glob DST.RO3.RO, glob DST.RO4.RO, glob DST.RO5.RO});
   [sim | auto => /> /#].
qed.

local ehoare countS_e (qS : int) (eps : real) : CountS(GC(Sign17c, CountA(A)).O).sign :
  ipot qS eps CountS.c Coins.cl Coins.bad ==> ipot qS eps CountS.c Coins.cl Coins.bad.
proof.
proc; inline GC(Sign17c, CountA(A)).O.sign Sign17c.sign Coins.draw.
seq 8 : (ipot qS eps CountS.c Coins.cl Coins.bad); last first.
+ exlim Coins.bad, Coins.cl, CountS.c => b0 cl0 c0.
  wp; call /(fun y => (Coins.bad = b0 /\ Coins.cl = cl0 /\ CountS.c = c0) `|` y) (sign17_e (ipot qS eps c0 cl0 b0)).
  + by move=> &hr; apply xle_cxr_r => -[-> [-> ->]].
  by skip => &hr; apply xle_cxr_r => -[-> [-> ->]]; apply xle_cxr_l.
auto => &hr; rewrite {2}/ipot; apply xle_cxr_r => [#] hs hc he hmu.
case: (CountS.c{hr} + 1 <= qS) => hq.
+ apply (xle_trans (Ep drnd (fun r => (b2r (Coins.bad{hr} \/ r \in Coins.cl{hr}) +
                                       tsum qS (CountS.c{hr} + 1) * eps)%xr))).
  - apply le_Ep => r _ /=; rewrite /ipot; apply xle_cxr_l; 1: smt().
    by rewrite hq.
  apply (xle_trans _ _ _ (Ep_hitE drnd Coins.bad{hr} true (fun r => Coins.bad{hr} \/ r \in Coins.cl{hr})
           (mem Coins.cl{hr}) (tsum qS (CountS.c{hr} + 1) * eps) ((size Coins.cl{hr})%r * eps) drnd_ll _ _ _)).
  - by apply mu_mem_le_mu1.
  - by apply RealOrder.mulr_ge0 => //; apply tsum_ge0; smt().
  - by move=> r /=.
  have -> /= : CountS.c{hr} <= qS by smt().
  have ht : 0%r <= tsum qS (CountS.c{hr} + 1) by apply tsum_ge0; smt().
  apply le_pos; rewrite (tsumS qS CountS.c{hr}) hs; smt().
apply (xle_trans (Ep drnd (fun _ => 0%xr))).
+ apply le_Ep => r _ /=; rewrite /ipot; apply xle_cxr_l; 1: smt().
  by rewrite ifF 1:/#.
rewrite EpC drnd_ll smul1m.
by apply xle0x.
qed.

local lemma bad_ok (qS : int) (eps : real) &m : 0 <= qS => (forall r, mu1 drnd r <= eps) =>
  Pr[GC(Sign17c, CountA(A)).main() @ &m : Coins.bad /\ CountS.c <= qS] <= tsum qS 0 * eps.
proof.
move=> hqS hmu; have he : 0%r <= eps by have := hmu witness; smt(mu_bounded).
byehoare => //; last by apply RealOrder.mulr_ge0 => //; apply tsum_ge0.
proc.
inline Router11(CountA(A), XAw(DST.RO1.RO), XCw(DST.RO2.RO), Htrw(DST.RO3.RO), DST.RO4.RO, Hctw(DST.RO5.RO),
                GC(Sign17c, CountA(A)).O).forge.
inline CountA(A, Router11(CountA(A), XAw(DST.RO1.RO), XCw(DST.RO2.RO), Htrw(DST.RO3.RO), DST.RO4.RO,
                          Hctw(DST.RO5.RO), GC(Sign17c, CountA(A)).O).H,
              XAw(DST.RO1.RO), GC(Sign17c, CountA(A)).O).forge.
seq 21 : ((Coins.bad /\ CountS.c <= qS)%xr); last first.
+ exlim Coins.bad, CountS.c => b0 c0.
  call /(fun y => (Coins.bad = b0 /\ CountS.c = c0) `|` y) (v16_e ((b0 /\ c0 <= qS)%xr)).
  + by move=> &hr; apply xle_cxr_r => -[-> ->].
  by skip => &hr; apply xle_cxr_r => -[-> ->].
seq 18 : (ipot qS eps CountS.c Coins.cl Coins.bad).
+ wp.
  inline Htrw(DST.RO3.RO).get KG16.keygen.
  wp.
  call /(fun y => (Coins.bad = false /\ Coins.cl = []) `|` y) (ro3_e (ipot qS eps 0 [] false)).
  + by move=> &hr; apply xle_cxr_r => -[-> ->].
  call /(fun y => (Coins.bad = false /\ Coins.cl = []) `|` y) (pkDecode_e (ipot qS eps 0 [] false)).
  wp.
  inline RO_rest.RO.init RO_pad.RO.init RO_hr.RO.init; wp.
  call /(fun y => (Coins.bad = false /\ Coins.cl = []) `|` y) (pkEncode_e (ipot qS eps 0 [] false)).
  call /(fun y => (Coins.bad = false /\ Coins.cl = []) `|` y) (ykeygen_e (ipot qS eps 0 [] false)).
  inline *; auto => &hr.
  apply xle_cxr_l => //; rewrite /ipot; apply xle_cxr_l; 1: smt().
  by rewrite hqS /b2r.
wp; call /(fun y => y) (: ipot qS eps CountS.c Coins.cl Coins.bad ==> ipot qS eps CountS.c Coins.cl Coins.bad).
+ move=> &hr; rewrite /ipot; apply xle_cxr_r => [#] hs hc _ _; case: (CountS.c{hr} <= qS) => hq /=.
  - have ht := tsum_ge0 qS CountS.c{hr} _; 1: smt().
    by apply le_pos; smt().
  - by [].
+ proc (ipot qS eps CountS.c Coins.cl Coins.bad).
  + by move=> &hr.
  + by move=> &hr.
  + by apply (countS_e qS eps).
  + proc*; exlim Coins.bad, Coins.cl, CountS.c => b0 cl0 c0.
    call /(fun y => (Coins.bad = b0 /\ Coins.cl = cl0 /\ CountS.c = c0) `|` y) (xaw_e (ipot qS eps c0 cl0 b0)).
    + by move=> &hr; apply xle_cxr_r => -[-> [-> ->]].
    by skip => &hr; apply xle_cxr_r => -[-> [-> ->]]; apply xle_cxr_l.
  proc; exlim Coins.bad, Coins.cl, CountS.c => b0 cl0 c0.
  call /(fun y => (Coins.bad = b0 /\ Coins.cl = cl0 /\ CountS.c = c0) `|` y)
       (rH_e (CountA(A)) (<: GC(Sign17c, CountA(A)).O) (ipot qS eps c0 cl0 b0)).
  + by move=> &hr; apply xle_cxr_r => -[-> [-> ->]].
  by auto => &hr; apply xle_cxr_r => -[-> [-> ->]]; apply xle_cxr_l.
by skip.
qed.

local lemma count_ok (qH qS : int) &m :
  (forall (H <: DS2.POracle1 {-A, -CountH, -CountS}) (G <: DS2.POracle2 {-A, -CountH, -CountS})
          (O <: DS2.SOracle {-A, -CountH, -CountS}),
     hoare [A(CountH(H), G, CountS(O)).forge :
              CountH.c = 0 /\ CountS.c = 0 ==> CountH.c <= qH /\ CountS.c <= qS]) =>
  Pr[GC(Sign17c, CountA(A)).main() @ &m : !(CountH.c <= qH /\ CountS.c <= qS)] = 0%r.
proof.
move=> A_count; byphoare => //; hoare; proc.
inline Router11(CountA(A), XAw(DST.RO1.RO), XCw(DST.RO2.RO), Htrw(DST.RO3.RO), DST.RO4.RO, Hctw(DST.RO5.RO),
                GC(Sign17c, CountA(A)).O).forge.
inline CountA(A, Router11(CountA(A), XAw(DST.RO1.RO), XCw(DST.RO2.RO), Htrw(DST.RO3.RO), DST.RO4.RO,
                          Hctw(DST.RO5.RO), GC(Sign17c, CountA(A)).O).H,
              XAw(DST.RO1.RO), GC(Sign17c, CountA(A)).O).forge.
call (: true); 1: by conseq />.
wp; call (A_count (<: Router11(CountA(A), XAw(DST.RO1.RO), XCw(DST.RO2.RO), Htrw(DST.RO3.RO), DST.RO4.RO,
                              Hctw(DST.RO5.RO), GC(Sign17c, CountA(A)).O).H)
                  (<: XAw(DST.RO1.RO)) (<: GC(Sign17c, CountA(A)).O)).
wp; call (: true); 1: by conseq />.
inline RO_rest.RO.init RO_pad.RO.init RO_hr.RO.init; wp.
call (: true); 1: by conseq />.
by inline *; auto.
qed.

local lemma bad_count &m :
  Pr[GC(Sign17c, A).main() @ &m : Coins.bad] = Pr[GC(Sign17c, CountA(A)).main() @ &m : Coins.bad].
proof.
byequiv (_ : ={glob A} ==> ={Coins.bad}) => //; proc.
inline{1} Router11(A, XAw(DST.RO1.RO), XCw(DST.RO2.RO), Htrw(DST.RO3.RO), DST.RO4.RO, Hctw(DST.RO5.RO),
                   GC(Sign17c, A).O).forge.
inline{2} Router11(CountA(A), XAw(DST.RO1.RO), XCw(DST.RO2.RO), Htrw(DST.RO3.RO), DST.RO4.RO, Hctw(DST.RO5.RO),
                   GC(Sign17c, CountA(A)).O).forge.
inline{2} CountA(A, Router11(CountA(A), XAw(DST.RO1.RO), XCw(DST.RO2.RO), Htrw(DST.RO3.RO), DST.RO4.RO,
                             Hctw(DST.RO5.RO), GC(Sign17c, CountA(A)).O).H,
                 XAw(DST.RO1.RO), GC(Sign17c, CountA(A)).O).forge.
call (: ={glob DST.RO1.RO, glob DST.RO2.RO, glob DST.RO3.RO, glob DST.RO4.RO, glob DST.RO5.RO}); 1: by sim.
wp; call (: ={glob DST.RO1.RO, glob RO_xr.RO, glob DST.RO2.RO, glob DST.RO3.RO, glob DST.RO4.RO, glob DST.RO5.RO,
              RO_rest.RO.m, RO_pad.RO.m, RO_hr.RO.m, Router11.tr, G13.qs, G13.sk, Coins.bad, Coins.cl}).
+ by proc; inline{2} 2; wp; sim.
+ by sim.
+ by proc*; inline{2} 1; wp;
     call (: ={glob DST.RO1.RO, glob DST.RO2.RO, glob DST.RO3.RO, glob DST.RO4.RO, glob DST.RO5.RO, RO_rest.RO.m,
               RO_pad.RO.m, RO_hr.RO.m, Router11.tr}); [by sim | auto].
wp; call (: ={glob DST.RO3.RO}); 1: by sim.
inline{1} RO_rest.RO.init RO_pad.RO.init RO_hr.RO.init; inline{2} RO_rest.RO.init RO_pad.RO.init RO_hr.RO.init; wp.
call (: ={glob DST.RO1.RO, glob DST.RO3.RO} ==> ={res, glob DST.RO1.RO, glob DST.RO3.RO}); 1: by sim.
by inline *; auto => />.
qed.

(* Hop 17: every iteration samples a fresh y, up to a repetition of the signing coins *)
lemma hop17 (qH qS : int) (eps : real) &m : 0 <= qS => (forall r, mu1 drnd r <= eps) =>
  (forall (H1 <: DS2.POracle1 {-A}) (H2 <: DS2.POracle2 {-A}) (O <: DS2.SOracle {-A}),
     islossless H1.get => islossless H2.get => islossless O.sign =>
     islossless A(H1, H2, O).forge) =>
  (forall (H <: DS2.POracle1 {-A, -CountH, -CountS}) (G <: DS2.POracle2 {-A, -CountH, -CountS})
          (O <: DS2.SOracle {-A, -CountH, -CountS}),
     hoare [A(CountH(H), G, CountS(O)).forge :
              CountH.c = 0 /\ CountS.c = 0 ==> CountH.c <= qH /\ CountS.c <= qS]) =>
  Pr[G16(A).main() @ &m : res] <= Pr[G17(A).main() @ &m : res] + (qS * (qS - 1))%r / 2%r * eps.
proof.
move=> hqS hmu A_ll A_count.
rewrite (G16_GC &m) -(GC_G17 &m).
have h1 := GC_uptobad &m A_ll.
have h2 : Pr[GC(Sign17c, A).main() @ &m : res \/ Coins.bad] <=
          Pr[GC(Sign17c, A).main() @ &m : res] + Pr[GC(Sign17c, A).main() @ &m : Coins.bad].
+ by rewrite Pr[mu_or]; smt(mu_bounded).
have h3 := bad_count &m.
have h4 := bad_ok qS eps &m hqS hmu.
have h5 := count_ok qH qS &m A_count.
have h6 : Pr[GC(Sign17c, CountA(A)).main() @ &m : Coins.bad] <=
          Pr[GC(Sign17c, CountA(A)).main() @ &m : Coins.bad /\ CountS.c <= qS] +
          Pr[GC(Sign17c, CountA(A)).main() @ &m : !(CountH.c <= qH /\ CountS.c <= qS)].
+ rewrite Pr[mu_split (CountS.c <= qS)]; apply RealOrder.ler_add2l.
  by rewrite Pr[mu_sub] => /#.
have -> : (qS * (qS - 1))%r / 2%r * eps = tsum qS 0 * eps by rewrite /tsum.
smt().
qed.

end section.
