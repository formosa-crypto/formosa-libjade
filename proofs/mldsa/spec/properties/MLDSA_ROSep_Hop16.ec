require import AllCore IntDiv List Distr DList PROM FMap.
from Jasmin require import JByte_array JWord.
require import Array256.

require import Parameters GFq Rq.
require MLDSA_ROSep_Hop15.
require import MLDSA_RO MLDSA_ROSep MLDSA_ROSep_Hop1 MLDSA_ROSep_Hop2 MLDSA_ROSep_Hop3.
require import MLDSA_ROSep_Hop4 MLDSA_ROSep_Hop5 MLDSA_ROSep_Hop6 MLDSA_ROSep_Hop7 MLDSA_ROSep_Hop8.
require import MLDSA_ROSep_Hop9 MLDSA_ROSep_Hop10 MLDSA_ROSep_Hop11 MLDSA_ROSep_Hop12 MLDSA_ROSep_Hop13.
require import MLDSA_ROSep_Hop14 MLDSA_ROSep_Hop15.
require import ConcreteDRing MLDSATargetFIPS Leakage.
require DS_ROM.

abstract theory MLDSA_ROSep_Hop16.

clone include MLDSA_ROSep_Hop15.MLDSA_ROSep_Hop15.
import Spec.
import PolyLVec PolyKVec PolyMat.
import Round ZModQ Zq MLDSAParams.

import PolyReduce.
import DV DV.MatRq.Vectors DV.MatRq.Matrices.

(*************** Public keys ****************)

op t1_valid (l : int list list) =
  size l = kvec /\ all (fun (li : int list) => size li = n /\ all (fun x => 0 <= x < 1024) li) l.

lemma t1_of_poly (l : int list list) : t1_valid l => t1_of (poly_of_t1 l) = l.
proof.
move=> [hs hall]; apply (eq_from_nth []); 1: by rewrite /t1_of size_map KArray.size_to_list hs.
move=> i; rewrite /t1_of size_map KArray.size_to_list => hi.
rewrite (nth_map witness [] (fun (p : Rq.poly) => map asint (Array256.to_list p))) ?KArray.size_to_list //
        KArray.get_to_list /poly_of_t1 KArray.initiE //=.
have hli : nth [] l i \in l by apply mem_nth; smt().
move/List.allP: hall => /(_ _ hli) [hsi halli].
apply (eq_from_nth 0); 1: by rewrite size_map Array256.size_to_list hsi.
move=> j; rewrite size_map Array256.size_to_list => hj.
rewrite (nth_map witness 0 asint) ?Array256.size_to_list // Array256.get_to_list Array256.initiE //= incoeffK
        modz_small //.
have hlj : nth 0 (nth [] l i) j \in nth [] l i by apply mem_nth; smt().
move/List.allP: halli => /(_ _ hlj); smt().
qed.

lemma pk_dec_enc (rho : Bytes32.t) (l : int list list) : t1_valid l => pk_dec (pk_enc (rho, l)) = (rho, l).
proof.
move=> hv; have /= H := param_sets.
rewrite /pk_dec /pk_enc /=.
have hb : RealExp.ilog 2 1023 + 1 = 10 by rewrite (_ : RealExp.ilog 2 1023 = 9) // RealExp.ilog_eq.
pose xs := map (fun (p : Rq.poly) => SimpleBitPack p 1023) (KArray.to_list (poly_of_t1 l)).
have hxs : forall x, x \in xs => size x = 320 by move=> x /mapP [p [_ ->]]; rewrite size_SimpleBitPack // hb.
have hsz : size (Bytes32.to_list rho ++ flatten xs) = 32 + 320 * kvec
  by rewrite size_cat Bytes32.size_to_list (size_flatten_ctt 320) // /xs size_map KArray.size_to_list.
rewrite -/xs BytesPK.of_listK; 1: by rewrite hsz; smt().
split; 1: by rewrite take_cat Bytes32.size_to_list /= ?take0 ?cats0 Bytes32.to_listK.
have -> : pk_t1 (BytesPK.of_list (Bytes32.to_list rho ++ flatten xs)) = poly_of_t1 l; 2: by apply t1_of_poly.
apply KArray.ext_eq => i hi; rewrite /pk_t1 KArray.initiE //= BytesPK.of_listK; 1: by rewrite hsz; smt().
rewrite drop_cat Bytes32.size_to_list /=.
rewrite ifF 1:/# /xs (JWordList.take_drop_flatten (fun (p : Rq.poly) => SimpleBitPack p 1023) _ 320) //;
  1: by move=> x; rewrite size_SimpleBitPack // hb.
+ by rewrite KArray.size_to_list.
have <- : nth witness (KArray.to_list (poly_of_t1 l)) i = (poly_of_t1 l).[i] by smt(KArray.get_to_list).
apply SimpleBitPackK => // j hj.
rewrite KArray.get_to_list // /poly_of_t1 KArray.initiE //= Array256.initiE //= incoeffK.
move: hv => [hs hall].
have hli : nth [] l i \in l by apply mem_nth; smt().
move/List.allP: hall => /(_ _ hli) [hsi halli].
have hlj : nth 0 (nth [] l i) j \in nth [] l i by apply mem_nth; smt().
move/List.allP: halli => /(_ _ hlj); smt(modz_small).
qed.

lemma b2hb_valid (t : vector) : size t = kvec => t1_valid (base2highbitsV t).
proof.
move=> hs; rewrite /t1_valid size_base2highbitsV hs /=.
apply/List.allP => li /mapP [p [_ ->]]; rewrite /DV.HL.base2highbits /= size_mkseq.
split; 1: smt().
apply/List.allP => x /mkseqP [j [hj ->]] /=; smt(highbits2_rng).
qed.

lemma expandA_size : hoare [MP.T.ExpandA(DST.RO1.RO).get : true ==> rows res.`1 = kvec /\ cols res.`1 = lvec].
proof.
proc.
while (rows mA = kvec /\ cols mA = lvec).
+ wp; while (rows mA = kvec /\ cols mA = lvec).
  * wp; call (: true); 1: by while true; [inline *; auto | auto].
    by auto => /> *; smt(size_updm).
  by auto.
by auto => />; smt(gt0_k gt0_l).
qed.

equiv expandA_eq_size : MP.T.ExpandA(DST.RO1.RO).get ~ MP.T.ExpandA(DST.RO1.RO).get :
  ={rho, DST.RO1.RO.m} ==> ={res, DST.RO1.RO.m} /\ rows res{1}.`1 = kvec /\ cols res{1}.`1 = lvec.
proof. by conseq (_ : ={rho, DST.RO1.RO.m} ==> ={res, DST.RO1.RO.m}) expandA_size _; sim. qed.

(*************** G16: the scheme of the target, with y from the table ****************)

module MLDSA_Y(XA : MP.T.XOF_A, XC : MP.T.SIB.XOF_t, Htr : MP.T.Hash_tr, Hmu : MP.T.Hash_mu, Hct : MP.T.Hash_ct) = {
  proc keygen = MP.T.MLDSA(XA, XC, Htr, Hmu, Hct).keygen
  proc verify = MP.T.MLDSA(XA, XC, Htr, Hmu, Hct).verify

  proc sign(sk : MP.T.SK, m : W8.t list, coins : rnd_) : MP.T.Sig option * leakage = {
    var z : vector;
    var h : bool list list;
    var response : (vector * bool list list) option;
    var c : polyXnD1;
    var ct : BytesCT.t;
    var ctr : int;
    var rho, tr, s1, s2, t0, mA, la, mu, y, yv, w, w0, w1;
    var lc, leak;
    var ct0_ok : bool;
    var z_fail, r0_fail, hint_fail : int option;
    ct <- witness;
    r0_fail <- witness;
    hint_fail <- witness;
    (rho, tr, s1, s2, t0) <- sk;
    leak <- MP.T.rho_leak rho;
    (mA, la) <@ MP.T.ExpandA(XA).get(rho);
    leak <- lcat leak la;
    leak <- lcat leak (MP.T.t0_leak t0);
    mu <@ Hmu.get(tr, m);
    response <- None;
    ctr <- 0;
    while (response = None /\ ctr < kappa_max) {
      yv <@ RO_y.RO.get(coins, mu, ctr);
      y <- vec_of_l yv;
      w <- mA *^ y;
      w1 <- highBitsV w;
      ct <@ Hct.get(w1, mu);
      leak <- lcat leak (MP.T.ct_leak ct);
      (c, lc) <@ MP.T.SIB.SampleInBall(XC).get(ct);
      leak <- lcat leak lc;
      leak <- lcat leak (MP.T.c_leak c);
      z <- y + c ** s1;
      z_fail <- check_z z;
      leak <- lcat leak (oileak z_fail);
      if (z_fail = None) {
        w0 <- w - c ** s2;
        r0_fail <- check_r0 w0;
        leak <- lcat leak (oileak r0_fail);
        if (r0_fail = None) {
          h <- makeHintV (- c ** t0) (w0 + c ** t0);
          hint_fail <- hint_fail_idx h;
          leak <- lcat leak (oileak hint_fail);
          (* test on c t0: a public computation of the leaked (c, t0) *)
          ct0_ok <- check_ct0 (c ** t0);
          if (ct0_ok /\ hint_fail = None) {
            response <- Some (z, h);
          }
        }
      }
      ctr <- ctr + 1;
    }
    return (omap (fun r => (ct, r)) response, leak);
  }
}.

module KG16 = {
  proc keygen() : BytesPK.t * MP.T.SK * MP.T.PK = {
    var pk, sk, pkb;
    RO_y.RO.init();
    (pk, sk) <@ MLDSA_Y(DST.RO1.RO, DST.RO2.RO, DST.RO3.RO, DST.RO4.RO, DST.RO5.RO).keygen();
    pkb <@ PkEncDec.pkEncode(pk.`1, poly_of_t1 pk.`2);
    return (pkb, sk, pk);
  }
}.

module Sign16 = {
  proc sign(sk : MP.T.SK, m : W8.t list) : BytesSig.t option * leakage = {
    var coins, rs, sg, s;
    coins <$ drnd;
    rs <@ MLDSA_Y(DST.RO1.RO, DST.RO2.RO, DST.RO3.RO, DST.RO4.RO, DST.RO5.RO).sign(sk, m, coins);
    sg <- None;
    if (rs.`1 <> None) {
      s <@ SigEncDec.sigEncode((oget rs.`1).`1, l_of_vec (oget rs.`1).`2.`1, poly_of_hints (oget rs.`1).`2.`2);
      sg <- Some s;
    }
    return (sg, rs.`2);
  }
}.

module V16 = {
  proc verify(pk : MP.T.PK, m : W8.t list, s : BytesSig.t) : bool = {
    var ct, z, h, b;
    (ct, z, h) <@ SigEncDec.sigDecode(s);
    b <- false;
    if (h <> None) {
      b <@ MLDSA_Y(DST.RO1.RO, DST.RO2.RO, DST.RO3.RO, DST.RO4.RO, DST.RO5.RO).verify(pk, m,
             (ct, (vec_of_l z, hints_of (oget h))));
    }
    return b;
  }
}.

(*************** G15 and G16 ****************)

equiv keygen_16 :
  MLDSA_RO_DS15(DST.RO1.RO, DST.RO2.RO, DST.RO3.RO, DST.RO4.RO, DST.RO5.RO).keygen ~ KG16.keygen :
  ={glob DST.RO1.RO, glob DST.RO3.RO}
  ==> res{1}.`1 = res{2}.`1 /\ res{1}.`2 = res{2}.`2 /\ res{2}.`1 = pk_enc res{2}.`3 /\ t1_valid res{2}.`3.`2 /\
      ={glob DST.RO1.RO, glob DST.RO3.RO, RO_y.RO.m}.
proof.
proc.
inline{2} MLDSA_Y(DST.RO1.RO, DST.RO2.RO, DST.RO3.RO, DST.RO4.RO, DST.RO5.RO).keygen.
inline{1} Htrw(DST.RO3.RO).get.
ecall{2} (pkEncode_corr pk{2}.`1 (poly_of_t1 pk{2}.`2)).
wp; call (: ={glob DST.RO3.RO}); 1: by sim.
ecall{1} (pkDecode_corr p{1}).
wp; ecall{1} (pkEncode_corr rho{1} (poly_of_t1 (base2highbitsV t{1}))).
wp; rnd; rnd.
call expandA_eq_size.
rnd.
inline RO_y.RO.init.
auto => />.
move=> rho _ [mA la] /= hrow hcol _ s1 _ hs1 _ s2 _ hs2 [r1 r2] /= -> ->.
have hsz2 : size s2 = kvec by move: hs2 => /size_dvector; smt(gt0_k).
have hsz : size (mA *^ s1 + s2) = kvec by rewrite size_addv size_mulmxv hrow hsz2; smt().
have hv := b2hb_valid _ hsz.
have := pk_dec_enc rho _ hv; rewrite /pk_dec /pk_enc /pk_t1 /= => -[h1 h2].
split; 1: by split.
by move=> _ _; exact hv.
qed.

equiv sign_16 :
  MLDSA_RO_DS15(DST.RO1.RO, DST.RO2.RO, DST.RO3.RO, DST.RO4.RO, DST.RO5.RO).sign ~ Sign16.sign :
  ={sk, m, glob DST.RO1.RO, glob DST.RO2.RO, glob DST.RO4.RO, glob DST.RO5.RO, RO_y.RO.m}
  ==> ={res, glob DST.RO1.RO, glob DST.RO2.RO, glob DST.RO4.RO, glob DST.RO5.RO, RO_y.RO.m}.
proof.
proc.
inline{2} MLDSA_Y(DST.RO1.RO, DST.RO2.RO, DST.RO3.RO, DST.RO4.RO, DST.RO5.RO).sign.
seq 11 15 : (coins{1} = coins0{2} /\ ={ct, mA, mu, s1, s2, t0, glob DST.RO1.RO, glob DST.RO2.RO, glob DST.RO4.RO,
                glob DST.RO5.RO, RO_y.RO.m} /\ kappa{1} = ctr{2} /\ zh{1} = response{2} /\ leakage{1} = leak{2}).
+ wp; call (: ={glob DST.RO4.RO}); 1: by sim.
  wp; call (: ={glob DST.RO1.RO}); 1: by sim.
  by auto.
seq 1 1 : (coins{1} = coins0{2} /\ ={ct, mA, mu, s1, s2, t0, glob DST.RO1.RO, glob DST.RO2.RO, glob DST.RO4.RO,
               glob DST.RO5.RO, RO_y.RO.m} /\ kappa{1} = ctr{2} /\ zh{1} = response{2} /\ leakage{1} = leak{2}).
+ while (coins{1} = coins0{2} /\ ={ct, mA, mu, s1, s2, t0, glob DST.RO1.RO, glob DST.RO2.RO, glob DST.RO4.RO,
               glob DST.RO5.RO, RO_y.RO.m} /\ kappa{1} = ctr{2} /\ zh{1} = response{2} /\ leakage{1} = leak{2}).
  * wp; call (: ={glob DST.RO2.RO}); 1: by sim.
    wp; call (: ={glob DST.RO5.RO}); 1: by sim.
    wp; call (: ={RO_y.RO.m}); 1: by sim.
    by auto => /> /#.
  by auto => /> /#.
sp 0 2; if{1}.
+ rcondt{2} 1; 1: by auto => /> /#.
  wp; call (: true); 1: by sim.
  auto => />; by move=> &2; case: (response{2}).
rcondf{2} 1; 1: by auto => /> /#.
by auto => /> /#.
qed.

equiv verify_16 :
  MLDSA_RO_DS15(DST.RO1.RO, DST.RO2.RO, DST.RO3.RO, DST.RO4.RO, DST.RO5.RO).verify ~ V16.verify :
  ={m, glob DST.RO1.RO, glob DST.RO2.RO, glob DST.RO3.RO, glob DST.RO4.RO, glob DST.RO5.RO} /\
  sigma{1} = s{2} /\ pk{1} = pk_enc pk{2} /\ t1_valid pk{2}.`2
  ==> ={res}.
proof.
proc.
inline{2} MLDSA_Y(DST.RO1.RO, DST.RO2.RO, DST.RO3.RO, DST.RO4.RO, DST.RO5.RO).verify.
seq 4 2 : (={ct, z, h, m, glob DST.RO1.RO, glob DST.RO2.RO, glob DST.RO3.RO, glob DST.RO4.RO, glob DST.RO5.RO} /\
           rb{1} = b{2} /\ (rho{1}, t1_of t1{1}) = pk{2} /\ pk{1} = pk_enc pk{2} /\ t1_valid pk{2}.`2).
+ wp; call (: true); 1: by sim.
  wp; ecall{1} (pkDecode_corr pk{1}).
  auto => /> &1 &2 hv.
  have hv' : t1_valid pk{1}.`2 by split.
  have := pk_dec_enc pk{1}.`1 pk{1}.`2 hv'.
  have <- : pk{1} = (pk{1}.`1, pk{1}.`2) by case: (pk{1}).
  move=> h [r1 r2] /= -> ->; move: h; rewrite /pk_dec /pk_t1 /=.
  by move=> h; exact h.
if => //.
inline{1} Htrw(DST.RO3.RO).get.
wp; call (: ={glob DST.RO5.RO}); 1: by sim.
wp; call (: ={glob DST.RO2.RO}); 1: by sim.
call (: ={glob DST.RO4.RO}); 1: by sim.
wp; call (: ={glob DST.RO3.RO}); 1: by sim.
ecall{1} (pkDecode_corr p{1}).
wp; call (: ={glob DST.RO1.RO}); 1: by sim.
auto => />.
move=> &1 &2 hs ha hh [r1 r2] /= -> ->.
have hv : t1_valid (t1_of t1{1}) by split.
have := pk_dec_enc rho{1} (t1_of t1{1}) hv; rewrite /pk_dec /pk_t1 /= => -[-> ->] /=.
move=> r.
have hsh : size (hints_of (oget h{2})) = kvec
  by rewrite /hints_of size_map; smt(size_iota gt0_k KArray.size_to_list).
rewrite size_vec_of_l hsh; smt().
qed.

module G16(A : DS2.Adversary) = {
  module O = {
    proc sign(m : W8.t list) : BytesSig.t option * leakage = {
      var r;
      G13.qs <- m :: G13.qs;
      r <@ Sign16.sign(G13.sk, m);
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

section.

declare module A <: DS2.Adversary {
  -DS2.RO1.RO, -DS2.RO2.RO, -DS2.EUF_CMA, -XOFA_O, -XOFS_O, -MLDSA_RO_DS1, -RoutedH,
  -DS5.RO1.RO, -DS5.RO2.RO, -DS5.RO3.RO, -DS5.RO4.RO, -DS5.RO5.RO, -DS5.EUF_CMA, -RO_rest.RO,
  -RO_pad.RO, -RO_pad.FRO, -RO_seed.RO, -RO_S.RO, -RO_rhopp.RO, -RO_v.RO, -CountH, -CountS, -St5,
  -RO_lp.RO, -RO_lp.FRO, -St6, -St7, -Router, -RO_y.RO, -DS8.EUF_CMA, -DS10.EUF_CMA, -DS10.RO5.RO,
  -RO_hr.RO, -Router10, -DS11.EUF_CMA, -RO_xc.RO, -RO_xc.FRO, -Router11, -DST.RO1.RO, -DST.RO2.RO,
  -DST.RO3.RO, -DST.RO4.RO, -DST.RO5.RO, -DST.EUF_CMA, -RO_xr.RO, -G13 }.

lemma G15_G16 &m : Pr[G15(A).main() @ &m : res] = Pr[G16(A).main() @ &m : res].
proof.
byequiv (: ={glob A} ==> ={res}) => //.
proc.
inline{1} Router11(A, XAw(DST.RO1.RO), XCw(DST.RO2.RO), Htrw(DST.RO3.RO), DST.RO4.RO, Hctw(DST.RO5.RO), G15(A).O).forge.
inline{2} Router11(A, XAw(DST.RO1.RO), XCw(DST.RO2.RO), Htrw(DST.RO3.RO), DST.RO4.RO, Hctw(DST.RO5.RO), G16(A).O).forge.
wp; call verify_16.
wp; call (: ={glob DST.RO1.RO, glob RO_xr.RO, glob DST.RO2.RO, glob DST.RO3.RO, glob DST.RO4.RO, glob DST.RO5.RO,
              RO_y.RO.m, RO_rest.RO.m, RO_pad.RO.m, RO_hr.RO.m, Router11.tr, G13.qs, G13.sk}).
+ by proc; call sign_16; auto.
+ by sim.
+ by sim.
call (: ={glob DST.RO3.RO}); 1: by sim.
inline{1} RO_rest.RO.init RO_pad.RO.init RO_hr.RO.init; inline{2} RO_rest.RO.init RO_pad.RO.init RO_hr.RO.init; wp.
call keygen_16.
inline *; auto => />.
by move=> rL rR -> _ ->.
qed.

end section.

end MLDSA_ROSep_Hop16.
