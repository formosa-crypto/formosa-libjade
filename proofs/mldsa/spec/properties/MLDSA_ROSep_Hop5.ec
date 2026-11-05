require import AllCore IntDiv List Distr DList PROM FMap Xreal StdBigop StdOrder.
from Jasmin require import JByte_array JWord.
require import Array256.

require import Parameters GFq Rq.
require MLDSA_ROSep_Hop4.
require import MLDSA_RO MLDSA_ROSep MLDSA_ROSep_Hop1 MLDSA_ROSep_Hop2 MLDSA_ROSep_Hop3.
require import DistrExtra.
require import MLDSA_ROSep_Hop4.

require import Leakage.
abstract theory MLDSA_ROSep_Hop5.

clone include MLDSA_ROSep_Hop4.MLDSA_ROSep_Hop4.
import Spec.
import PolyLVec PolyKVec PolyMat.
import Round ZModQ Zq MLDSAParams.


(*************** G4: K, xi and rho' leave the scheme's data ****************)

op cK : Bytes32.t = witness.
op cS : Bytes64.t = witness.

module St5 = {
  var epsp : Bytes34.t
  var r1 : W8.t list
}.

(* The seed blocks are sampled directly; K in the secret key and rho' in ExpandS are constants *)
module MLDSA_RO_DS4(H : BlockOracle, G : Oracle) = {
  proc keygen() : BytesPK.t * BytesSK.t = {
    var eps,sk,rho,_A,al,s1,s2,t,t1,t0,pk,tr,bs,r0,r1;
    RO_S.RO.init();
    RO_rhopp.RO.init();
    RO_v.RO.init();
    eps <$ dxi;
    St5.epsp <- Bytes34.of_list (Bytes32.to_list eps ++ [W8.of_int kvec;W8.of_int lvec]);
    r0 <$ dblock;
    r1 <$ dblock;
    St5.r1 <- r1;
    rho <- Bytes32.of_list (take 32 r0);
    (_A,al) <@ ExpandA(XOFA_O(G)).sample(rho);
    (s1,s2) <@ ExpandS(XOFS_O(RO_S.RO)).sample(cS);
    t <- invnttv (ntt_mulmxv _A (nttv s1)) + s2;
    (t1,t0) <- Power2Round t;
    pk <@ PkEncDec.pkEncode(rho,t1);
    bs <@ Squeeze(H).squeeze(BytesPK.to_list pk, 64);
    tr <- Bytes64.of_list bs;
    sk <@ SkEncDec.skEncode(rho,cK,tr,s1,s2,t0);
    return (pk,sk);
  }

  proc sign = MLDSA_RO_DS3(H, G).sign

  proc verify = MLDSA_RO_DS3(H, G).verify
}.

(* bad4 over-approximated by the data of G4: xi, the second seed block r1 = rho'_hi || K,
   and the values of RO_rhopp *)
op bad5 (tr : Bytes64.t) (mrest : (W8.t list * int, W8.t list) fmap) (epsp : Bytes34.t)
        (r1 : W8.t list) (mpp : (W8.t list * int, W8.t list) fmap) : bool =
     (exists x, x \in mrest /\ x.`1 = Bytes34.to_list epsp)
  \/ (exists x, x \in mrest /\ size x.`1 = 66 /\ drop 32 (take 64 x.`1) = take 32 r1)
  \/ (exists x, x \in mrest /\ size x.`1 = 128 /\ take 32 x.`1 = drop 32 r1)
  \/ (exists x y, x \in mrest /\ y \in mpp /\ size x.`1 = 66 /\ take 64 x.`1 = oget mpp.[y])
  \/ drop 32 r1 = take 32 (Bytes64.to_list tr)
  \/ (exists y, y \in mpp /\ oget mpp.[y] = Bytes64.to_list tr)
  \/ (exists y, y \in mpp /\ drop 32 (oget mpp.[y]) = take 32 r1).

op setK (s : BytesSK.t) (c : Bytes32.t) : BytesSK.t =
  BytesSK.of_list (take 32 (BytesSK.to_list s) ++ Bytes32.to_list c ++ drop 64 (BytesSK.to_list s)).

(* RO_rhopp of G3 and G4: the same values, keys with prefix kb in G3 and cK in G4 *)
op renK (kb : W8.t list) (m1 m2 : (W8.t list * int, W8.t list) fmap) : bool =
     (forall x, m1.[x] = if size x.`1 = 128 /\ take 32 x.`1 = kb
                         then m2.[(Bytes32.to_list cK ++ drop 32 x.`1, x.`2)] else None)
  /\ (forall y, y \in m2 => size y.`1 = 128 /\ take 32 y.`1 = Bytes32.to_list cK).

(* RO_S of G3 and G4: the same values, keys with prefix rho' in G3 and cS in G4 *)
op renS (rp : Bytes64.t) (m1 m2 : (W8.t list * int, W8.t list) fmap) : bool =
     (forall x, m1.[x] = if size x.`1 = 66 /\ take 64 x.`1 = Bytes64.to_list rp
                         then m2.[(Bytes64.to_list cS ++ drop 64 x.`1, x.`2)] else None)
  /\ (forall y, y \in m2 => size y.`1 = 66 /\ take 64 y.`1 = Bytes64.to_list cS).

op seedS (rp : Bytes64.t) (s1 s2 : Bytes66.t) : bool =
     take 64 (Bytes66.to_list s1) = Bytes64.to_list rp
  /\ Bytes66.to_list s2 = Bytes64.to_list cS ++ drop 64 (Bytes66.to_list s1).

(* The hidden maps of G3 after key generation, in terms of the data of G4 *)
op inv5 (epsp : Bytes34.t) (r1 : W8.t list) (mseed mS mpp1 mpp2 : (W8.t list * int, W8.t list) fmap) : bool =
     (forall x, x \in mseed => x.`1 = Bytes34.to_list epsp)
  /\ (forall x, x \in mS => size x.`1 = 66 /\ drop 32 (take 64 x.`1) = take 32 r1)
  /\ renK (drop 32 r1) mpp1 mpp2.

(*************** The secret key with K replaced ****************)

lemma setK_list (s : BytesSK.t) (c : Bytes32.t) :
  BytesSK.to_list (setK s c) =
  take 32 (BytesSK.to_list s) ++ Bytes32.to_list c ++ drop 64 (BytesSK.to_list s).
proof.
have hsk := ge128_sk_bytes.
by rewrite /setK BytesSK.of_listK // !size_cat size_take // size_drop // size_BytesSK
     Bytes32.size_to_list /#.
qed.

lemma setK_drop (s : BytesSK.t) (c : Bytes32.t) n :
  64 <= n => drop n (BytesSK.to_list (setK s c)) = drop n (BytesSK.to_list s).
proof.
move=> hn; have hsk := ge128_sk_bytes.
have hs : size (take 32 (BytesSK.to_list s) ++ Bytes32.to_list c) = 64
  by rewrite size_cat size_take // size_BytesSK Bytes32.size_to_list /#.
by rewrite setK_list drop_cat hs (_ : !(n < 64)) 1:/# /= drop_drop /#.
qed.

lemma setK_take (s : BytesSK.t) (c : Bytes32.t) :
  take 32 (BytesSK.to_list (setK s c)) = take 32 (BytesSK.to_list s) /\
  take 32 (drop 32 (BytesSK.to_list (setK s c))) = Bytes32.to_list c.
proof.
have hsk := ge128_sk_bytes.
have hA : size (take 32 (BytesSK.to_list s)) = 32 by rewrite size_take // size_BytesSK /#.
rewrite setK_list -catA; split; 1: by rewrite -{1}hA take_size_cat.
by rewrite -{1}hA drop_size_cat // take_cat Bytes32.size_to_list hA /= take0 cats0.
qed.

equiv skDecode_cK (s : BytesSK.t) : SkEncDec.skDecode ~ SkEncDec.skDecode :
  sk{1} = s /\ sk{2} = setK s cK
  ==> res{2} = (res{1}.`1, cK, res{1}.`3, res{1}.`4, res{1}.`5, res{1}.`6) /\
      Bytes32.to_list res{1}.`2 = take 32 (drop 32 (BytesSK.to_list s)).
proof.
proc; do 3! (wp; while (={i, rho, tr, s1, s2, t0} /\ k{2} = cK /\ sk{1} = s /\ sk{2} = setK s cK /\
                        0 <= i{1});
               1: by auto => /> &1 &2 *; rewrite setK_drop; [have /= H := param_sets; smt() | smt()]).
auto => />; have [h1 h2] := setK_take s cK.
have hsk := ge128_sk_bytes.
by rewrite h1 h2 Bytes32.to_listK setK_drop //= Bytes32.of_listK // size_take // size_drop // size_BytesSK /#.
qed.

lemma setK_of_list (l : W8.t list) (c : Bytes32.t) :
  64 <= size l =>
  setK (BytesSK.of_list l) c = BytesSK.of_list (take 32 l ++ Bytes32.to_list c ++ drop 64 l).
proof.
move=> hl; have hsk := ge128_sk_bytes.
rewrite /setK; apply BytesSK.tP => i hi; rewrite !BytesSK.get_of_list //.
have hL : forall j, 0 <= j < sk_bytes =>
            nth witness (BytesSK.to_list (BytesSK.of_list l)) j = nth witness l j
  by move=> j hj; rewrite BytesSK.get_to_list BytesSK.get_of_list.
rewrite !nth_cat !size_cat !size_take // size_BytesSK Bytes32.size_to_list
        (_ : 32 < sk_bytes) 1:/# (_ : 32 < size l) 1:/# /=.
case: (i < 64) => h64 /=; 2: by rewrite !nth_drop 1..4:/# hL /#.
by case: (i < 32) => h32 //=; rewrite !nth_take // hL /#.
qed.

equiv skEncode_setK (k0 : Bytes32.t) : SkEncDec.skEncode ~ SkEncDec.skEncode :
  ={rho, tr, s1, s2, t0} /\ k{1} = k0 /\ k{2} = cK
  ==> res{2} = setK res{1} cK /\ take 32 (drop 32 (BytesSK.to_list res{1})) = Bytes32.to_list k0.
proof.
proc*; exlim rho{1}, tr{1}, s1{1}, s2{1}, t0{1} => r t a b c.
call{1} (skEncode_corr r k0 t a b c); call{2} (skEncode_corr r cK t a b c); auto => />; split.
+ rewrite setK_of_list; 1: by rewrite !size_cat !Bytes32.size_to_list Bytes64.size_to_list; smt(size_ge0).
  by congr; rewrite -!catA take_cat drop_cat !Bytes32.size_to_list /= drop_cat Bytes32.size_to_list /=
       take0 cats0 drop0.
by rewrite -!catA catA sk_K.
qed.

(*************** ExpandS on the renamed seed ****************)

equiv getS5 (rp : Bytes64.t) : RO_S.RO.get ~ RO_S.RO.get :
  size x{1}.`1 = 66 /\ take 64 x{1}.`1 = Bytes64.to_list rp /\
  x{2} = (Bytes64.to_list cS ++ drop 64 x{1}.`1, x{1}.`2) /\ renS rp RO_S.RO.m{1} RO_S.RO.m{2}
  ==> ={res} /\ renS rp RO_S.RO.m{1} RO_S.RO.m{2}.
proof.
proc; auto => /> &1 &2 hs hp; rewrite /renS.
move=> h1 h2 rL _.
have hx : RO_S.RO.m{1}.[x{1}] = RO_S.RO.m{2}.[(Bytes64.to_list cS ++ drop 64 x{1}.`1, x{1}.`2)]
  by rewrite h1 hs hp.
case: ((Bytes64.to_list cS ++ drop 64 x{1}.`1, x{1}.`2) \in RO_S.RO.m{2}) => hv;
  case: (x{1} \in RO_S.RO.m{1}) => hu //=;
  [by rewrite hx | by move: hu hv; rewrite !domE hx | by move: hu hv; rewrite !domE hx | ].
rewrite !get_set_sameE /=; split.
+ move=> z; rewrite !get_setE; case: (z = x{1}) => [->> /= | hz /=]; 1: by rewrite hs hp.
  rewrite h1; case: (size z.`1 = 66 /\ take 64 z.`1 = Bytes64.to_list rp) => hc //=.
  have -> //= : !(Bytes64.to_list cS ++ drop 64 z.`1 = Bytes64.to_list cS ++ drop 64 x{1}.`1 /\
                  z.`2 = x{1}.`2).
  apply/negP => -[hd he]; apply hz.
  have hd' : drop 64 z.`1 = drop 64 x{1}.`1 by smt(eqseq_cat).
  case: hc => hzs hzp.
  have hz1 : z.`1 = x{1}.`1 by rewrite -(cat_take_drop 64 z.`1) hd' hzp -hp cat_take_drop.
  by move: hz1 he; case: z hz hzs hzp hd hd' => z1 z2 /=; case: (x{1}) => a b /= *; smt().
move=> y; rewrite mem_set => -[hy | ->> /=]; 1: by exact h2.
by rewrite size_cat size_drop // Bytes64.size_to_list take_size_cat ?Bytes64.size_to_list //; smt().
qed.

lemma seedS_of (rp : Bytes64.t) i :
  seedS rp (Bytes66.of_list (Bytes64.to_list rp ++ IntegerToBytes i 2))
           (Bytes66.of_list (Bytes64.to_list cS ++ IntegerToBytes i 2)).
proof.
have hitb : size (IntegerToBytes i 2) = 2
  by rewrite /IntegerToBytes /BitsToBytes /IntegerToBits size_take // size_map
       BitEncoding.BitChunking.size_chunk // BitEncoding.BS2Int.size_int2bs.
by rewrite /seedS !Bytes66.of_listK ?size_cat ?Bytes64.size_to_list ?hitb // take_size_cat
     ?Bytes64.size_to_list // !drop_size_cat ?Bytes64.size_to_list.
qed.

equiv next5 (rp : Bytes64.t) : XOFS_O(RO_S.RO).next ~ XOFS_O(RO_S.RO).next :
  ={XOFS_O.pos} /\ seedS rp XOFS_O.seed{1} XOFS_O.seed{2} /\ renS rp RO_S.RO.m{1} RO_S.RO.m{2}
  ==> ={res, XOFS_O.pos} /\ seedS rp XOFS_O.seed{1} XOFS_O.seed{2} /\ renS rp RO_S.RO.m{1} RO_S.RO.m{2}.
proof.
by proc; inline ReadByte(RO_S.RO).read; wp; call (getS5 rp); auto => /> &1 &2 hp hs hr;
  rewrite Bytes66.size_to_list hp hs.
qed.

equiv rbp5 (rp : Bytes64.t) : RejBoundedPoly(XOFS_O(RO_S.RO)).sample ~ RejBoundedPoly(XOFS_O(RO_S.RO)).sample :
  seedS rp rho{1} rho{2} /\ renS rp RO_S.RO.m{1} RO_S.RO.m{2}
  ==> ={res} /\ renS rp RO_S.RO.m{1} RO_S.RO.m{2}.
proof.
by proc; while (={j, a, XOFS_O.pos} /\ seedS rp XOFS_O.seed{1} XOFS_O.seed{2} /\
                renS rp RO_S.RO.m{1} RO_S.RO.m{2});
   [wp; call (next5 rp); auto => /> | inline *; auto => />].
qed.

equiv expandS5 (rp : Bytes64.t) : ExpandS(XOFS_O(RO_S.RO)).sample ~ ExpandS(XOFS_O(RO_S.RO)).sample :
  rho{1} = rp /\ rho{2} = cS /\ renS rp RO_S.RO.m{1} RO_S.RO.m{2}
  ==> ={res} /\ renS rp RO_S.RO.m{1} RO_S.RO.m{2}.
proof.
by proc; do 2! (while (={r, s1, s2} /\ rho{1} = rp /\ rho{2} = cS /\ renS rp RO_S.RO.m{1} RO_S.RO.m{2});
                [by wp; call (rbp5 rp); auto => />; smt(seedS_of) | wp]); auto => />.
qed.

(*************** rho'' on the renamed key ****************)

equiv getpp5 (kb : W8.t list) : RO_rhopp.RO.get ~ RO_rhopp.RO.get :
  size x{1}.`1 = 128 /\ take 32 x{1}.`1 = kb /\
  x{2} = (Bytes32.to_list cK ++ drop 32 x{1}.`1, x{1}.`2) /\ renK kb RO_rhopp.RO.m{1} RO_rhopp.RO.m{2}
  ==> ={res} /\ renK kb RO_rhopp.RO.m{1} RO_rhopp.RO.m{2}.
proof.
proc; auto => &1 &2 [] hs [] hp [] -> /=; rewrite /renK => -[h1 h2] rL -> /=.
have hx : RO_rhopp.RO.m{1}.[x{1}] =
          RO_rhopp.RO.m{2}.[(Bytes32.to_list cK ++ drop 32 x{1}.`1, x{1}.`2)]
  by rewrite h1 hs hp.
case: ((Bytes32.to_list cK ++ drop 32 x{1}.`1, x{1}.`2) \in RO_rhopp.RO.m{2}) => hv;
  case: (x{1} \in RO_rhopp.RO.m{1}) => hu //=;
  [by rewrite hx | by move: hu hv; rewrite !domE hx | by move: hu hv; rewrite !domE hx | ].
rewrite !get_set_sameE /=; split.
+ move=> z; rewrite !get_setE; case: (z = x{1}) => [->> /= | hz /=]; 1: by rewrite hs hp.
  rewrite h1; case: (size z.`1 = 128 /\ take 32 z.`1 = kb) => hc //=.
  have -> //= : !(Bytes32.to_list cK ++ drop 32 z.`1 = Bytes32.to_list cK ++ drop 32 x{1}.`1 /\
                  z.`2 = x{1}.`2).
  apply/negP => -[hd he]; apply hz.
  have hd' : drop 32 z.`1 = drop 32 x{1}.`1 by smt(eqseq_cat).
  case: hc => hzs hzp.
  have hz1 : z.`1 = x{1}.`1 by rewrite -(cat_take_drop 32 z.`1) hd' hzp -hp cat_take_drop.
  by move: hz1 he; case: z hz hzs hzp hd hd' => z1 z2 /=; case: (x{1}) => a b /= *; smt().
move=> y; rewrite mem_set => -[hy | ->> /=]; 1: by exact h2.
by rewrite size_cat size_drop // Bytes32.size_to_list take_size_cat ?Bytes32.size_to_list //; smt().
qed.

equiv squeezepp5 (kb : W8.t list) : Squeeze(RO_rhopp.RO).squeeze ~ Squeeze(RO_rhopp.RO).squeeze :
  ={len} /\ size x{1} = 128 /\ take 32 x{1} = kb /\ x{2} = Bytes32.to_list cK ++ drop 32 x{1} /\
  renK kb RO_rhopp.RO.m{1} RO_rhopp.RO.m{2}
  ==> ={res} /\ renK kb RO_rhopp.RO.m{1} RO_rhopp.RO.m{2}.
proof.
by proc; while (={r, j, len} /\ size x{1} = 128 /\ take 32 x{1} = kb /\
                x{2} = Bytes32.to_list cK ++ drop 32 x{1} /\ renK kb RO_rhopp.RO.m{1} RO_rhopp.RO.m{2});
   [wp; call (getpp5 kb); auto => /> | auto => />].
qed.

(*************** Signing with K replaced ****************)

equiv sign5 (kb : W8.t list) :
  MLDSA_RO_DS3(RoutedH, DS2.RO2.RO).sign ~ MLDSA_RO_DS4(RoutedH, DS2.RO2.RO).sign :
  ={m, glob DS2.RO2.RO, glob XOFA_O, glob RoutedH, RO_v.RO.m} /\ sk{2} = setK sk{1} cK /\
  take 32 (drop 32 (BytesSK.to_list sk{1})) = kb /\ renK kb RO_rhopp.RO.m{1} RO_rhopp.RO.m{2}
  ==> ={res, glob DS2.RO2.RO, glob XOFA_O, glob RoutedH, RO_v.RO.m} /\
      renK kb RO_rhopp.RO.m{1} RO_rhopp.RO.m{2}.
proof.
proc; seq 7 7 : (={m, coins, ct, ctl, sigma, rho, tr, s1, s2, t0, glob DS2.RO2.RO, glob XOFA_O,
                   glob RoutedH, RO_v.RO.m} /\
                 _K{2} = cK /\ Bytes32.to_list _K{1} = kb /\ renK kb RO_rhopp.RO.m{1} RO_rhopp.RO.m{2}).
+ by exlim sk{1} => s; call (skDecode_cK s); auto => /> &1 &2 *; smt().
seq 10 10 : (={m, coins, ct, ctl, sigma, leakage, s1h, s2h, t0h, _A, mu, rhopp, glob DS2.RO2.RO,
             glob XOFA_O, glob RoutedH, RO_v.RO.m} /\
           renK kb RO_rhopp.RO.m{1} RO_rhopp.RO.m{2}).
+ wp; call (squeezepp5 kb); call (: ={DS5.RO4.RO.m}); 1: by sim.
  wp; call (: ={glob DS2.RO2.RO, glob XOFA_O}); 1: by sim.
  auto => />; move=> &1 &2 _ _ mu0.
  by rewrite /rnd_to_list !size_cat !Bytes32.size_to_list Bytes64.size_to_list /= -!catA take_size_cat
       ?Bytes32.size_to_list // drop_size_cat ?Bytes32.size_to_list.
seq 3 3 : (={kappa, zh, ct, ctl, sigma, leakage, glob DS2.RO2.RO, glob XOFA_O, glob RoutedH, RO_v.RO.m} /\
           renK kb RO_rhopp.RO.m{1} RO_rhopp.RO.m{2}).
+ while (={kappa, zh, ct, ctl, sigma, leakage, s1h, s2h, t0h, _A, mu, rhopp, glob DS2.RO2.RO,
           glob XOFA_O, glob RoutedH, RO_v.RO.m} /\
         renK kb RO_rhopp.RO.m{1} RO_rhopp.RO.m{2}); 2: by auto => />.
  wp; call (: ={DS5.RO2.RO.m}); 1: by sim.
  call (: ={DS5.RO5.RO.m, RO_pad.RO.m}); 1: by sim.
  by wp; call (: ={RO_v.RO.m}); [by sim | auto => />].
by if => //; wp; call (: true); [by sim | auto => />].
qed.

(*************** Key generation ****************)

(* The two blocks of the seed query are fresh samples r0, r1; rho' = r0[32..64] || r1[0..32] and
   K = r1[32..64] are then used only by ExpandS and in the secret key *)
equiv keygen5 : MLDSA_RO_DS3(RoutedH, DS2.RO2.RO).keygen ~ MLDSA_RO_DS4(RoutedH, DS2.RO2.RO).keygen :
  ={glob DS2.RO2.RO, glob XOFA_O, glob RoutedH}
  ==> res{2}.`1 = res{1}.`1 /\ res{2}.`2 = setK res{1}.`2 cK /\
      take 32 (drop 32 (BytesSK.to_list res{1}.`2)) = drop 32 St5.r1{2} /\
      ={glob DS2.RO2.RO, glob XOFA_O, glob RoutedH, RO_v.RO.m} /\
      inv5 St5.epsp{2} St5.r1{2} RO_seed.RO.m{1} RO_S.RO.m{1} RO_rhopp.RO.m{1} RO_rhopp.RO.m{2}.
proof.
proc; inline{1} RO_seed.RO.init RO_S.RO.init RO_rhopp.RO.init RO_v.RO.init;
  inline{2} RO_S.RO.init RO_rhopp.RO.init RO_v.RO.init.
seq 8 9 : (={glob DS2.RO2.RO, glob XOFA_O, glob RoutedH, RO_v.RO.m, rho} /\
           RO_S.RO.m{1} = empty /\ RO_S.RO.m{2} = empty /\
           RO_rhopp.RO.m{1} = empty /\ RO_rhopp.RO.m{2} = empty /\
           (forall x, x \in RO_seed.RO.m{1} => x.`1 = Bytes34.to_list St5.epsp{2}) /\
           drop 32 (Bytes64.to_list rhop{1}) = take 32 St5.r1{2} /\
           Bytes32.to_list _K{1} = drop 32 St5.r1{2}).
+ inline{1} Squeeze(RO_seed.RO).squeeze.
  unroll{1} 11; rcondt{1} 11; 1: by auto.
  unroll{1} 14; rcondt{1} 14; 1: by move=> &m; wp; call (: true); auto.
  rcondf{1} 17; 1: by move=> &m; inline *; auto.
  inline{1} RO_seed.RO.get; wp; rnd; wp; rnd; wp; rnd; auto => />.
  move=> e _ r0 hr0; rewrite mem_empty /= => r1 hr1; rewrite mem_set mem_empty /= !get_setE /=.
  have hs0 : size r0 = 64 by move: hr0; rewrite /dblock supp_dlist //; smt().
  have hs1 : size r1 = 64 by move: hr1; rewrite /dblock supp_dlist //; smt().
  have -> : take 128 (r0 ++ r1) = r0 ++ r1 by rewrite take_oversize // size_cat /#.
  rewrite take_cat drop_cat drop_cat hs0 /=; split; 1: by move=> x2; rewrite !mem_set mem_empty /= => -[] ->.
  rewrite take_cat size_drop // hs0 /= Bytes64.of_listK.
  + by rewrite size_cat size_drop // size_take // /#.
  by rewrite drop_size_cat 1:size_drop // 1:/# Bytes32.of_listK // size_drop // /#.
exlim rhop{1}, _K{1} => rp k0; wp; call (skEncode_setK k0); wp; call (: ={glob RoutedH}); 1: by sim.
call (: true); 1: by sim.
wp; call (expandS5 rp); call (: ={glob DS2.RO2.RO, glob XOFA_O}); 1: by sim.
auto => /> &1 &2 hseed hrp hk; split; 1: by rewrite /renS; smt(emptyE mem_empty).
move=> _ _ mL mR h1 _ sk1 hsk; rewrite hsk hk /=; split; 2: by smt(emptyE mem_empty).
move=> x; rewrite domE h1; case: (size x.`1 = 66 /\ take 64 x.`1 = Bytes64.to_list rp) => // -[hs hp] _.
by rewrite hs hp hrp.
qed.

lemma bad4_bad5 t (mrest ms mS mpp1 mpp2 : (W8.t list * int, W8.t list) fmap) epsp r1 :
  inv5 epsp r1 ms mS mpp1 mpp2 => bad4 t mrest ms mS mpp1 => bad5 t mrest epsp r1 mpp2.
proof.
rewrite /inv5 /renK => -[hs [hS [h1 h2]]].
have hpp : forall y, y \in mpp1 =>
             size y.`1 = 128 /\ take 32 y.`1 = drop 32 r1 /\
             (Bytes32.to_list cK ++ drop 32 y.`1, y.`2) \in mpp2 /\
             mpp1.[y] = mpp2.[(Bytes32.to_list cK ++ drop 32 y.`1, y.`2)].
+ by move=> y; rewrite domE h1; case: (size y.`1 = 128 /\ take 32 y.`1 = drop 32 r1) => //= -[-> ->] /=.
rewrite /bad4 /bad5 => -[[x [hx [h | [h | h]]]] | [[x y [hx [hy [hsz hv]]]] |
                        [[y [hy [h | h]]] | [x y [hx [hy hv]]]]]].
+ by left; exists x; rewrite hx hs.
+ by right; left; exists x; rewrite hx hS.
+ by right; right; left; exists x; have := hpp x h; smt().
+ have [_ [_ [hy2 hyv]]] := hpp y hy; do 3! right; left.
  by exists x (Bytes32.to_list cK ++ drop 32 y.`1, y.`2); rewrite hx hy2 hsz hv hyv.
+ have [_ [hk _]] := hpp y hy; do 4! right; left.
  by rewrite -h take_take /= hk.
+ have [_ [_ [hy2 hyv]]] := hpp y hy; do 5! right; left.
  by exists (Bytes32.to_list cK ++ drop 32 y.`1, y.`2); rewrite hy2 -hyv h.
have [_ [_ [hy2 hyv]]] := hpp y hy; do 6! right.
exists (Bytes32.to_list cK ++ drop 32 y.`1, y.`2); have [_ hd] := hS x hx.
by rewrite hy2 -hyv -hv hd.
qed.

section.

declare module A <: DS2.Adversary {
  -DS2.RO1.RO, -DS2.RO2.RO, -DS2.EUF_CMA, -XOFA_O, -XOFS_O, -MLDSA_RO_DS1, -RoutedH,
  -DS5.RO2.RO, -DS5.RO3.RO, -DS5.RO4.RO, -DS5.RO5.RO, -RO_rest.RO, -RO_pad.RO,
  -RO_seed.RO, -RO_S.RO, -RO_rhopp.RO, -RO_v.RO, -CountH, -CountS, -St5 }.

(* Hop 5.1, exact: the seed blocks are direct samples, ExpandS and K are constants in the scheme *)
lemma hop5_1 &m :
  Pr[DS2.EUF_CMA(RoutedH, DS2.RO2.RO, MLDSA_RO_DS3, A).main() @ &m :
       res \/ bad4 RoutedH.tr RO_rest.RO.m RO_seed.RO.m RO_S.RO.m RO_rhopp.RO.m] <=
  Pr[DS2.EUF_CMA(RoutedH, DS2.RO2.RO, MLDSA_RO_DS4, A).main() @ &m :
       res \/ bad5 RoutedH.tr RO_rest.RO.m St5.epsp St5.r1 RO_rhopp.RO.m].
proof.
byequiv (: ={glob A, glob XOFA_O} ==>
           res{1} \/ bad4 RoutedH.tr{1} RO_rest.RO.m{1} RO_seed.RO.m{1} RO_S.RO.m{1} RO_rhopp.RO.m{1} =>
           res{2} \/ bad5 RoutedH.tr{2} RO_rest.RO.m{2} St5.epsp{2} St5.r1{2} RO_rhopp.RO.m{2}) => //.
proc; call (: ={pk, m, sigma, glob DS2.RO2.RO, glob XOFA_O, glob RoutedH} ==> ={res, glob RoutedH});
  1: by sim.
call (: ={glob DS2.RO2.RO, glob XOFA_O, glob RoutedH, RO_v.RO.m, DS2.EUF_CMA.qs} /\
        DS2.EUF_CMA.sk{2} = setK DS2.EUF_CMA.sk{1} cK /\
        take 32 (drop 32 (BytesSK.to_list DS2.EUF_CMA.sk{1})) = drop 32 St5.r1{2} /\
        inv5 St5.epsp{2} St5.r1{2} RO_seed.RO.m{1} RO_S.RO.m{1} RO_rhopp.RO.m{1} RO_rhopp.RO.m{2}).
+ by proc; exlim St5.r1{2} => r1; call (sign5 (drop 32 r1)); auto => />.
+ by proc; auto.
+ by proc*; call (: ={glob RoutedH}); [by sim | auto].
call keygen5; inline *; auto => />.
move=> rL rR mS mpp1 ms ep r1 mpp2 h _ _ _ _ _ _; split; 1: by rewrite h.
move=> _ ro mpp1' tr qs mrest mpp2' hs hS h1 h2 b.
have hb := bad4_bad5 tr mrest ms mS mpp1' mpp2' ep r1 _; 1: by rewrite /inv5 /renK; do !split => //.
smt().
qed.

end section.

(*************** G5: y keyed by K || rnd || mu instead of rho'' ****************)

clone FullRO as RO_lp with
  type in_t    <- W8.t list * int,
  type out_t   <- W8.t list,
  op   dout    <- fun _ => dblock,
  type d_in_t  <- unit,
  type d_out_t <- bool.

module St6 = {
  var keys : (W8.t list * int) list
}.

module ExpandMask_L(H : BlockOracle) = {
   proc sample(kp : W8.t list, mu : int) : polylvec = {
     var r, rhop, v, si, bs;
     var s : polylvec;
     s <- witness;
     r <- 0;
     while (r < lvec) {
        rhop <- kp ++ IntegerToBytes (mu+r) 2;
        bs <@ Squeeze(H).squeeze(rhop, n * (gamma1m1_bits + 1) %/ 8);
        v <- BytesV.of_list bs;
        si <- BitUnpack (BytesV.to_list v) (gamma1-1) (gamma1);
        s <- s.[r <- si];
        r <- r + 1;
     }
     return s;
   }
}.

(* rho'' is still sampled, by O, but no longer used *)
module MLDSA_RO_DS5(O : RO_lp.RO, H : BlockOracle, G : Oracle) = {
  proc keygen() : BytesPK.t * BytesSK.t = {
    var eps,sk,rho,_A,al,s1,s2,t,t1,t0,pk,tr,bs,r0,r1;
    RO_S.RO.init();
    O.init();
    RO_v.RO.init();
    St6.keys <- [];
    eps <$ dxi;
    St5.epsp <- Bytes34.of_list (Bytes32.to_list eps ++ [W8.of_int kvec;W8.of_int lvec]);
    r0 <$ dblock;
    r1 <$ dblock;
    St5.r1 <- r1;
    rho <- Bytes32.of_list (take 32 r0);
    (_A,al) <@ ExpandA(XOFA_O(G)).sample(rho);
    (s1,s2) <@ ExpandS(XOFS_O(RO_S.RO)).sample(cS);
    t <- invnttv (ntt_mulmxv _A (nttv s1)) + s2;
    (t1,t0) <- Power2Round t;
    pk <@ PkEncDec.pkEncode(rho,t1);
    bs <@ Squeeze(H).squeeze(BytesPK.to_list pk, 64);
    tr <- Bytes64.of_list bs;
    sk <@ SkEncDec.skEncode(rho,cK,tr,s1,s2,t0);
    return (pk,sk);
  }

  proc sign(sk : BytesSK.t, m : W8.t list) : BytesSig.t option * leakage = {
     var coins,rho,_K,tr,s1,s2,t0,s1h,s2h,t0h,_A,al,mu,kp,kappa,y,w,w1,ctl,ct,c,ch,cs1,
         cs2,z,r0,ct0,h,leakage,sigma,bct0,sl;
     var zf, rf, hf : int option;
     var zh : (polylvec * polykvec) option;
     coins <$ drnd;
     ct <- witness;
     ctl <- witness;
     sigma <- witness;
     rf <- witness;
     hf <- witness;
     (rho,_K,tr,s1,s2,t0) <@ SkEncDec.skDecode(sk);
     s1h <- nttv s1;
     s2h <- nttv s2;
     t0h <- nttv t0;
     leakage <- rho_leak rho;
     (_A,al) <@ ExpandA(XOFA_O(G)).sample(rho);
     leakage <- lcat leakage al;
     leakage <- lcat leakage (kvec_leak t0h);
     mu <@ DS5.RO4.RO.get(tr, m);
     kp <- Bytes32.to_list _K ++ rnd_to_list coins ++ Bytes64.to_list mu;
     O.sample((kp, 0));
     St6.keys <- (kp, 0) :: St6.keys;
     kappa <- 0;
     zh <- None;
     while (zh = None && ! (kappa_max <= kappa)) {
       y <@ ExpandMask_L(RO_v.RO).sample(kp,kappa * lvec);
       w <- invnttv (ntt_mulmxv _A (nttv y));
       w1 <- polykvec_HighBits w;
       ct <@ HctPad.get(mu, w1Encode w1);
       (c, sl) <@ SampleInBall_O(DS5.RO2.RO).sample(ct);
       ctl <- ((ct, c), sl);
       leakage <- lcat leakage (ctilde_leak ct);
       leakage <- lcat leakage ctl.`2;
       ch <- ntt c;
       leakage <- lcat leakage (poly_leak ch);
       cs1 <- invnttv (ntt_smul ch s1h);
       z <- y + cs1;
       zf <- zfail_idx z;
       leakage <- lcat leakage (oileak zf);
       if (zf = None) {
         cs2 <- invnttv (ntt_smul ch s2h);
         r0 <- polykvec_LowBits (w - cs2);
         rf <- r0fail_idx r0;
         leakage <- lcat leakage (oileak rf);
         if (rf = None) {
           ct0 <- invnttv (ntt_smul ch t0h);
           h <- MakeHint (PolyKVec.zerov-ct0) (w - cs2 + ct0);
           hf <- hintfail_idx h;
           leakage <- lcat leakage (oileak hf);
           (* public test: c and t0 are leaked *)
           bct0 <- infnorm_lt ct0 gamma2;
           if (bct0 /\ hf = None) { zh <- Some (z,h); }
         }
       }
       kappa <- kappa + 1;
     }
     if (zh <> None) {
       sigma <@ SigEncDec.sigEncode(ct,(oget zh).`1,(oget zh).`2);
     }
     return (if zh = None then None else Some sigma, leakage);
  }

  proc verify = MLDSA_RO_DS3(H, G).verify
}.

module MLDSA_RO_DS5R(H : BlockOracle, G : Oracle) = {
  proc keygen = MLDSA_RO_DS5(RO_lp.RO, H, G).keygen

  proc sign = MLDSA_RO_DS5(RO_lp.RO, H, G).sign

  proc verify = MLDSA_RO_DS5(RO_lp.RO, H, G).verify
}.

op rcoll (m : (W8.t list * int, W8.t list) fmap) : bool =
  exists k1 k2, k1 \in m /\ k2 \in m /\ k1 <> k2 /\ m.[k1] = m.[k2].

(* RO_v of G4 and G5: the same values, keys with prefix rho'' in G4 and K || rnd || mu in G5 *)
op renV (mpp mv1 mv2 : (W8.t list * int, W8.t list) fmap) : bool =
     (forall k nb j, k \in mpp => size nb = 2 =>
        mv1.[(oget mpp.[k] ++ nb, j)] = mv2.[(k.`1 ++ nb, j)])
  /\ (forall x, x \in mv1 => size x.`1 = 66 /\ exists k, k \in mpp /\ take 64 x.`1 = oget mpp.[k])
  /\ (forall x, x \in mv2 => size x.`1 = 130 /\ exists k, k \in mpp /\ take 128 x.`1 = k.`1)
  /\ (forall k, k \in mpp => size k.`1 = 128 /\ k.`2 = 0 /\ size (oget mpp.[k]) = 64).

lemma renV_key (mpp : (W8.t list * int, W8.t list) fmap) k k' (nb nb' : W8.t list) :
  (forall k, k \in mpp => size k.`1 = 128 /\ k.`2 = 0 /\ size (oget mpp.[k]) = 64) =>
  !rcoll mpp => k \in mpp => k' \in mpp => size nb = 2 => size nb' = 2 =>
  (oget mpp.[k'] ++ nb' = oget mpp.[k] ++ nb) = (k'.`1 ++ nb' = k.`1 ++ nb).
proof.
move=> h4 hc hk hk' hn hn'; have [hk1 [hk2 hv]] := h4 k hk; have [hk1' [hk2' hv']] := h4 k' hk'.
rewrite !eqseq_cat ?hv ?hv' ?hk1 ?hk1' //; case: (k' = k) => [->> // | hne].
have h1 : oget mpp.[k'] <> oget mpp.[k].
+ apply/negP => he; apply hc; exists k' k; rewrite hk hk' hne /=; move: hk hk' he; rewrite !domE.
  by case: (mpp.[k']) => // a; case: (mpp.[k]) => // b.
have h2 : k'.`1 <> k.`1 by apply/negP => he; apply hne; rewrite (pairS k') (pairS k) he hk2' hk2.
by rewrite h1 h2.
qed.

(* A fresh rho'' that collides with no other keeps the renaming *)
lemma renV_add (mpp mv1 mv2 : (W8.t list * int, W8.t list) fmap) k v :
  renV mpp mv1 mv2 => k \notin mpp => size k.`1 = 128 => k.`2 = 0 => size v = 64 =>
  !rcoll mpp.[k <- v] => renV mpp.[k <- v] mv1 mv2.
proof.
rewrite /renV => -[h1 [h2 [h3 h4]]] hk hs1 hs2 hv hc.
split; [move=> k' nb j; rewrite mem_set get_setE => -[hk' | ->>] hn |
        split; [move=> x hx | split; [move=> x hx | move=> k'; rewrite mem_set get_setE => -[hk' | ->> /=]]]].
+ by rewrite (_ : k' <> k) 1:/# /=; apply h1.
+ have hn2 : (k.`1 ++ nb, j) \notin mv2.
  - apply/negP => /h3 [_ [k0 [hk0 he]]]; move: he => /=; rewrite (take_size_cat 128 k.`1) //.
    apply/negP => he; apply hk; have [_ [h02 _]] := h4 k0 hk0.
    have hkk : k = k0 by rewrite (pairS k) (pairS k0) he hs2 h02.
    by rewrite hkk.
  have hn1 : (v ++ nb, j) \notin mv1.
  - apply/negP => /h2 [_ [k0 [hk0 he]]]; move: he => /=; rewrite (take_size_cat 64 v) //.
    apply/negP => he; apply hc; exists k k0.
    rewrite !mem_set hk0 /= get_set_sameE get_setE (_ : k0 <> k) 1:/# /= he; split; 1: smt().
    by move: hk0; rewrite domE; case: (mpp.[k0]).
  by move: hn1 hn2; rewrite /= !domE /= => -> ->.
+ have [-> [k0 [hk0 he]]] := h2 x hx.
  by exists k0; rewrite mem_set get_setE hk0 (_ : k0 <> k) 1:/#.
+ by have [-> [k0 [hk0 he]]] := h3 x hx; exists k0; rewrite mem_set hk0.
+ by rewrite (_ : k' <> k) 1:/# /=; apply h4.
by [].
qed.

equiv getv52 (k : W8.t list * int) (nb : W8.t list) : RO_v.RO.get ~ RO_v.RO.get :
  k \in RO_lp.RO.m{2} /\ size nb = 2 /\ x{1}.`2 = x{2}.`2 /\
  x{1}.`1 = oget RO_lp.RO.m{2}.[k] ++ nb /\ x{2}.`1 = k.`1 ++ nb /\
  renV RO_lp.RO.m{2} RO_v.RO.m{1} RO_v.RO.m{2} /\ !rcoll RO_lp.RO.m{2}
  ==> ={res} /\ renV RO_lp.RO.m{2} RO_v.RO.m{1} RO_v.RO.m{2}.
proof.
proc; auto => &1 &2 [] hk [] hn [] hj [] hx1 [] hx2 [] /= [h1 [h2 [h3 h4]]] hc rL -> /=.
have hx : RO_v.RO.m{1}.[x{1}] = RO_v.RO.m{2}.[x{2}] by rewrite (pairS x{1}) (pairS x{2}) hx1 hx2 hj h1.
case: (x{2} \in RO_v.RO.m{2}) => hv; case: (x{1} \in RO_v.RO.m{1}) => hu //=;
  [by rewrite hx /renV | by move: hu hv; rewrite !domE hx | by move: hu hv; rewrite !domE hx | ].
rewrite !get_set_sameE /= /renV; split; [move=> k' nb' j' hk' hn' | split; [move=> x0 | split; [move=> x0 | exact h4]]].
+ by rewrite !get_setE (pairS x{1}) hx1 hj (pairS x{2}) hx2 /= (renV_key _ k k' nb nb') // h1 //.
+ rewrite mem_set => -[/h2 // | ->>]; rewrite hx1; have [_ [_ hv']] := h4 k hk.
  by split; [rewrite size_cat hv' hn | exists k; rewrite hk take_size_cat].
rewrite mem_set => -[/h3 // | ->>]; rewrite hx2; have [hk1 _] := h4 k hk.
by split; [rewrite size_cat hk1 hn | exists k; rewrite hk take_size_cat].
qed.

equiv squeezev52 (k : W8.t list * int) (nb : W8.t list) :
  Squeeze(RO_v.RO).squeeze ~ Squeeze(RO_v.RO).squeeze :
  ={len} /\ k \in RO_lp.RO.m{2} /\ size nb = 2 /\
  x{1} = oget RO_lp.RO.m{2}.[k] ++ nb /\ x{2} = k.`1 ++ nb /\
  renV RO_lp.RO.m{2} RO_v.RO.m{1} RO_v.RO.m{2} /\ !rcoll RO_lp.RO.m{2}
  ==> ={res} /\ renV RO_lp.RO.m{2} RO_v.RO.m{1} RO_v.RO.m{2}.
proof.
by proc; while (={r, j, len} /\ k \in RO_lp.RO.m{2} /\ size nb = 2 /\
                x{1} = oget RO_lp.RO.m{2}.[k] ++ nb /\ x{2} = k.`1 ++ nb /\
                renV RO_lp.RO.m{2} RO_v.RO.m{1} RO_v.RO.m{2} /\ !rcoll RO_lp.RO.m{2});
   [wp; call (getv52 k nb); auto => /> | auto => />].
qed.

equiv emask52 (k : W8.t list * int) : ExpandMask_O(RO_v.RO).sample ~ ExpandMask_L(RO_v.RO).sample :
  ={mu} /\ k \in RO_lp.RO.m{2} /\ Bytes64.to_list rho{1} = oget RO_lp.RO.m{2}.[k] /\ kp{2} = k.`1 /\
  renV RO_lp.RO.m{2} RO_v.RO.m{1} RO_v.RO.m{2} /\ !rcoll RO_lp.RO.m{2}
  ==> ={res} /\ renV RO_lp.RO.m{2} RO_v.RO.m{1} RO_v.RO.m{2}.
proof.
proc; while (={r, s, mu} /\ k \in RO_lp.RO.m{2} /\ Bytes64.to_list rho{1} = oget RO_lp.RO.m{2}.[k] /\
             kp{2} = k.`1 /\ renV RO_lp.RO.m{2} RO_v.RO.m{1} RO_v.RO.m{2} /\ !rcoll RO_lp.RO.m{2});
  2: by auto => />.
exlim mu{2}, r{2} => mu0 r0; wp; call (squeezev52 k (IntegerToBytes (mu0 + r0) 2)).
auto => /> &1 &2 hk hr _ _ hrv hc _ _.
have hitb : size (IntegerToBytes (mu0 + r0) 2) = 2
  by rewrite /IntegerToBytes /BitsToBytes /IntegerToBits size_take // size_map
       BitEncoding.BitChunking.size_chunk // BitEncoding.BS2Int.size_int2bs.
by rewrite hitb /= Bytes66.of_listK ?size_cat ?Bytes64.size_to_list ?hitb // hr.
qed.

lemma emaskL_ll (H <: BlockOracle) : islossless H.get => islossless ExpandMask_L(H).sample.
proof.
move=> hH; proc; while true (lvec - r); 2: by auto => /#.
by move=> z; wp; call (Squeeze_ll H hH); auto => /#.
qed.

(* Signing agrees until two keys get the same rho''; this is decided when rho'' is sampled *)
equiv sign52 : MLDSA_RO_DS4(RoutedH, DS2.RO2.RO).sign ~ MLDSA_RO_DS5R(RoutedH, DS2.RO2.RO).sign :
  ={sk, m, glob DS2.RO2.RO, glob XOFA_O, glob RoutedH} /\ RO_rhopp.RO.m{1} = RO_lp.RO.m{2} /\
  renV RO_lp.RO.m{2} RO_v.RO.m{1} RO_v.RO.m{2} /\ !rcoll RO_lp.RO.m{2}
  ==> !rcoll RO_lp.RO.m{2} =>
      ={res, glob DS2.RO2.RO, glob XOFA_O, glob RoutedH} /\ RO_rhopp.RO.m{1} = RO_lp.RO.m{2} /\
      renV RO_lp.RO.m{2} RO_v.RO.m{1} RO_v.RO.m{2}.
proof.
proc; seq 15 15 : (={sk, m, coins, ct, ctl, sigma, leakage, rho, _K, tr, s1, s2, t0, s1h, s2h, t0h, _A, mu,
                     glob DS2.RO2.RO, glob XOFA_O, glob RoutedH} /\
                   RO_rhopp.RO.m{1} = RO_lp.RO.m{2} /\ renV RO_lp.RO.m{2} RO_v.RO.m{1} RO_v.RO.m{2} /\
                   !rcoll RO_lp.RO.m{2}).
+ by call (: ={DS5.RO4.RO.m});
    [by sim | wp; call (: ={glob DS2.RO2.RO, glob XOFA_O}); [by sim | wp; call (: true); [by sim | auto]]].
seq 2 3 : (={sk, m, coins, ct, ctl, sigma, leakage, s1h, s2h, t0h, _A, mu, glob DS2.RO2.RO, glob XOFA_O,
             glob RoutedH} /\
           RO_rhopp.RO.m{1} = RO_lp.RO.m{2} /\ (kp{2}, 0) \in RO_lp.RO.m{2} /\
           Bytes64.to_list rhopp{1} = oget RO_lp.RO.m{2}.[(kp{2}, 0)] /\
           (!rcoll RO_lp.RO.m{2} => renV RO_lp.RO.m{2} RO_v.RO.m{1} RO_v.RO.m{2})).
+ inline{1} Squeeze(RO_rhopp.RO).squeeze; inline{2} RO_lp.RO.sample; rcondt{1} 5; 1: by auto.
  rcondf{1} 8; 1: by move=> &m; inline *; auto.
  inline{1} RO_rhopp.RO.get; inline{2} RO_lp.RO.get; wp; rnd; auto => /> &1 &2 hrv hc hrL hsz _ r1 hr1.
  have hs1 : size r1 = 64 by move: hr1; rewrite /dblock supp_dlist //; smt().
  have hk1 : size (Bytes32.to_list _K{2} ++ rnd_to_list coins{2} ++ Bytes64.to_list mu{2}) = 128
    by rewrite !size_cat /rnd_to_list !Bytes32.size_to_list Bytes64.size_to_list.
  have hold : renV RO_lp.RO.m{2} RO_v.RO.m{1} RO_v.RO.m{2} by rewrite /renV; do !split.
  split => [hkn | hki]; last by have [_ [_ hsv]] := hsz _ hki; rewrite take_oversize ?hsv // Bytes64.of_listK.
  rewrite mem_set get_set_sameE /= take_oversize ?hs1 // Bytes64.of_listK // => hc'.
  by have := renV_add _ _ _ _ r1 hold hkn hk1 _ hs1 hc'; [by [] | by rewrite /renV].
case (rcoll RO_lp.RO.m{2}).
+ conseq (: _ ==> rcoll RO_lp.RO.m{2}) => //.
  seq 3 3 : (rcoll RO_lp.RO.m{2});
    last by wp; if{2}; [call{2} sigEncode_ll | ]; (if{1}; [call{1} sigEncode_ll | ]); auto.
  while{2} (rcoll RO_lp.RO.m{2}) (kappa_max - kappa{2}).
  - move=> _ z0; wp; call sib_XC_ll; call hctpad_ll; wp; call (emaskL_ll RO_v.RO RO_v_get_ll).
    by auto => /#.
  while{1} true (kappa_max - kappa{1}).
  - move=> _ z0; wp; call sib_XC_ll; call hctpad_ll; wp; call (emask_ll RO_v.RO RO_v_get_ll).
    by auto => /#.
  by auto => />; smt().
exlim kp{2} => kp0.
seq 3 3 : (={kappa, zh, ct, ctl, sigma, leakage, glob DS2.RO2.RO, glob XOFA_O, glob RoutedH} /\
           RO_rhopp.RO.m{1} = RO_lp.RO.m{2} /\ renV RO_lp.RO.m{2} RO_v.RO.m{1} RO_v.RO.m{2} /\
           !rcoll RO_lp.RO.m{2});
  last by if => //; wp; call (: true); [by sim | auto => />].
while (={kappa, zh, ct, ctl, sigma, leakage, s1h, s2h, t0h, _A, mu, glob DS2.RO2.RO, glob XOFA_O,
         glob RoutedH} /\
       kp{2} = kp0 /\ RO_rhopp.RO.m{1} = RO_lp.RO.m{2} /\ (kp0, 0) \in RO_lp.RO.m{2} /\
       Bytes64.to_list rhopp{1} = oget RO_lp.RO.m{2}.[(kp0, 0)] /\
       renV RO_lp.RO.m{2} RO_v.RO.m{1} RO_v.RO.m{2} /\ !rcoll RO_lp.RO.m{2});
  last by auto => />; smt().
wp; call (: ={DS5.RO2.RO.m}); 1: by sim.
call (: ={DS5.RO5.RO.m, RO_pad.RO.m}); 1: by sim.
by wp; call (emask52 (kp0, 0)); auto => />.
qed.

lemma RO_lp_sample_ll : islossless RO_lp.RO.sample.
proof. by proc; inline *; auto => />; apply dlist_ll; apply W8.dword_ll. qed.

lemma sign5_ll : islossless MLDSA_RO_DS5R(RoutedH, DS2.RO2.RO).sign.
proof.
proc; seq 21 : true => //; last by if; [call sigEncode_ll | ].
while true (kappa_max - kappa).
+ move=> z; wp; call sib_XC_ll; call hctpad_ll; wp; call (emaskL_ll RO_v.RO RO_v_get_ll).
  by auto => /#.
wp; call RO_lp_sample_ll; wp; call (: true);
  1: by auto => />; rewrite /dbytes64; apply dmap_ll; apply dlist_ll; apply W8.dword_ll.
wp; call expandA_ll; wp; call (: true).
+ while true (kvec - i); 1: by move=> z; auto => /#.
  wp; while true (kvec - i); 1: by move=> z; auto => /#.
  by wp; while true (lvec - i); [by move=> z; auto => /# | auto => /#].
by auto => />; smt(drnd_ll).
qed.

lemma rcoll_set (m : (W8.t list * int, W8.t list) fmap) k v : k \notin m => rcoll m => rcoll m.[k <- v].
proof.
move=> hk [k1 k2 [h1 [h2 [h12 he]]]]; exists k1 k2.
by rewrite !mem_set h1 h2 h12 /= !get_setE (_ : k1 <> k) 1:/# (_ : k2 <> k) 1:/#.
qed.

hoare sign5_coll : MLDSA_RO_DS5R(RoutedH, DS2.RO2.RO).sign : rcoll RO_lp.RO.m ==> rcoll RO_lp.RO.m.
proof.
proc; seq 21 : (rcoll RO_lp.RO.m); 2: by if; [call (: true); [by conseq /> | auto] | auto].
while (rcoll RO_lp.RO.m).
+ by wp; call (: true); [by conseq /> | call (: true); [by conseq /> | wp; call (: true); [by conseq /> | auto]]].
seq 15 : (rcoll RO_lp.RO.m).
+ by call (: true); [by conseq /> | wp; call (: true); [by conseq /> | wp; call (: true); [by conseq /> | auto]]].
inline *; auto => />.
by move=> &hr k1 k2 h1 h2 h12 he r1 _ hk; apply rcoll_set => //; exists k1 k2.
qed.

(* After key generation the rho'' and y maps are empty in both games *)
equiv keygen52 : MLDSA_RO_DS4(RoutedH, DS2.RO2.RO).keygen ~ MLDSA_RO_DS5R(RoutedH, DS2.RO2.RO).keygen :
  ={glob DS2.RO2.RO, glob XOFA_O, glob XOFS_O, glob RoutedH}
  ==> ={res, glob DS2.RO2.RO, glob XOFA_O, glob RoutedH, St5.epsp, St5.r1} /\
      RO_rhopp.RO.m{1} = RO_lp.RO.m{2} /\ renV RO_lp.RO.m{2} RO_v.RO.m{1} RO_v.RO.m{2} /\
      !rcoll RO_lp.RO.m{2}.
proof.
proc; inline{1} RO_S.RO.init RO_rhopp.RO.init RO_v.RO.init; inline{2} RO_S.RO.init RO_lp.RO.init RO_v.RO.init.
wp; call (: true); 1: by sim.
wp; call (: ={glob RoutedH}); 1: by sim.
call (: true); 1: by sim.
wp; call (: ={glob RO_S.RO, glob XOFS_O}); 1: by sim.
call (: ={glob DS2.RO2.RO, glob XOFA_O}); 1: by sim.
by auto => />; rewrite /renV /rcoll; smt(mem_empty).
qed.

hoare sign5_keys : MLDSA_RO_DS5R(RoutedH, DS2.RO2.RO).sign :
  (forall k, k \in RO_lp.RO.m <=> k \in St6.keys) ==> (forall k, k \in RO_lp.RO.m <=> k \in St6.keys).
proof.
proc; seq 21 : (forall k, k \in RO_lp.RO.m <=> k \in St6.keys);
  2: by if; [call (: true); [by conseq /> | auto] | auto].
while (forall k, k \in RO_lp.RO.m <=> k \in St6.keys).
+ by wp; call (: true); [by conseq /> | call (: true); [by conseq /> | wp; call (: true); [by conseq /> | auto]]].
seq 15 : (forall k, k \in RO_lp.RO.m <=> k \in St6.keys).
+ by call (: true); [by conseq /> | wp; call (: true); [by conseq /> | wp; call (: true); [by conseq /> | auto]]].
by inline *; auto => /> &hr h r _; smt(mem_set).
qed.

(*************** G6: rho'', xi and r1 sampled at the end ****************)

module St7 = {
  var vals : (W8.t list * int, W8.t list) fmap
}.

(* The part of bad5 \/ rcoll decided by the rho'' values *)
op badpp (t : Bytes64.t) (mrest mpp : (W8.t list * int, W8.t list) fmap) : bool =
     rcoll mpp
  \/ (exists x y, x \in mrest /\ y \in mpp /\ size x.`1 = 66 /\ take 64 x.`1 = oget mpp.[y])
  \/ (exists y, y \in mpp /\ oget mpp.[y] = Bytes64.to_list t).

lemma badpp_set t (mrest mpp : (W8.t list * int, W8.t list) fmap) k v :
  k \notin mpp => badpp t mrest mpp.[k <- v] =>
  badpp t mrest mpp \/
  ((exists y, y \in mpp /\ v = oget mpp.[y]) \/
   (exists x, x \in mrest /\ size x.`1 = 66 /\ take 64 x.`1 = v) \/
   v = Bytes64.to_list t).
proof.
move=> hk; rewrite /badpp /rcoll => -[[k1 k2 [h1 [h2 [h12 he]]]] | [[x y [hx [hy [hs he]]]] | [y [hy he]]]].
+ move: h1 h2 he; rewrite !mem_set !get_setE => h1 h2 he; case: (k1 = k) => h1k; case: (k2 = k) => h2k.
  - by move: h12; rewrite h1k h2k.
  - right; left; exists k2; move: he; rewrite h1k h2k /= => he.
    by split; [smt() | rewrite -he].
  - right; left; exists k1; move: he; rewrite h1k h2k /= => he.
    by split; [smt() | rewrite he].
  by left; left; exists k1 k2; move: he; rewrite h1k h2k /= => he; smt().
+ move: hy he; rewrite mem_set get_setE => hy he; case: (y = k) => hyk.
  - by move: he; rewrite hyk /= => he; right; right; left; exists x.
  by move: he; rewrite hyk /= => he; left; right; left; exists x y; smt().
move: hy he; rewrite mem_set get_setE => hy he; case: (y = k) => hyk.
+ by move: he; rewrite hyk /= => he; right; right; right.
by move: he; rewrite hyk /= => he; left; right; right; exists y; smt().
qed.

(* A fresh rho'' hits an earlier rho'', a 64-byte prefix of an adversary query, or tr *)
lemma mu_fresh_pp (t : Bytes64.t) (mrest mpp : (W8.t list * int, W8.t list) fmap) :
  mu dblock (fun v => (exists y, y \in mpp /\ v = oget mpp.[y]) \/
                      (exists x, x \in mrest /\ size x.`1 = 66 /\ take 64 x.`1 = v) \/
                      v = Bytes64.to_list t)
  <= (fsize mpp)%r * p512 + ((fsize mrest)%r * p512 + p512).
proof.
apply mu_or_le.
+ by apply Mu_mem.mu_mem_le_fsize => u _ /=; rewrite (mu_eq _ _ (pred1 (oget mpp.[u]))) 1:/# mu1_dblock.
apply mu_or_le; 2: by rewrite (mu_eq _ _ (pred1 (Bytes64.to_list t))) 1:/# mu1_dblock.
apply Mu_mem.mu_mem_le_fsize => u _ /=.
apply (RealOrder.ler_trans (mu dblock (pred1 (take 64 u.`1)))); 2: by apply mu1_dblock.
by apply mu_le => v _ /= [_ ->].
qed.

(* xi hits the prefix of an adversary query *)
lemma mu_xi_hit (mrest : (W8.t list * int, W8.t list) fmap) :
  mu dxi (fun e => exists x, x \in mrest /\
            x.`1 = Bytes34.to_list (Bytes34.of_list (Bytes32.to_list e ++ [W8.of_int kvec; W8.of_int lvec])))
  <= (fsize mrest)%r * p256.
proof.
apply Mu_mem.mu_mem_le_fsize => u _ /=.
apply (RealOrder.ler_trans (mu dxi (pred1 (Bytes32.of_list (take 32 u.`1))))); 2: by apply mu1_dxi.
apply mu_le => e _ /= ->; rewrite /pred1 Bytes34.of_listK ?size_cat ?Bytes32.size_to_list //.
by rewrite take_size_cat ?Bytes32.size_to_list // Bytes32.to_listK.
qed.

(* r1 = rho'_hi || K hits a query, the prefix of tr, or a half of a rho'' *)
lemma mu_r1_hit (t : Bytes64.t) (mrest mpp : (W8.t list * int, W8.t list) fmap) :
  mu dblock (fun r => (exists x, x \in mrest /\ size x.`1 = 66 /\ drop 32 (take 64 x.`1) = take 32 r) \/
                      (exists x, x \in mrest /\ size x.`1 = 128 /\ take 32 x.`1 = drop 32 r) \/
                      drop 32 r = take 32 (Bytes64.to_list t) \/
                      (exists y, y \in mpp /\ drop 32 (oget mpp.[y]) = take 32 r))
  <= (fsize mrest)%r * p256 + ((fsize mrest)%r * p256 + (p256 + (fsize mpp)%r * p256)).
proof.
apply mu_or_le.
+ apply Mu_mem.mu_mem_le_fsize => u _ /=.
  apply (RealOrder.ler_trans (mu dblock (fun r => take 32 r = drop 32 (take 64 u.`1)))); 2: by apply mu_dblock_take.
  by apply mu_le => r _ /= [_ ->].
apply mu_or_le.
+ apply Mu_mem.mu_mem_le_fsize => u _ /=.
  apply (RealOrder.ler_trans (mu dblock (fun r => drop 32 r = take 32 u.`1))); 2: by apply mu_dblock_drop.
  by apply mu_le => r _ /= [_ ->].
apply mu_or_le; 1: by apply mu_dblock_drop.
apply Mu_mem.mu_mem_le_fsize => u _ /=.
apply (RealOrder.ler_trans (mu dblock (fun r => take 32 r = drop 32 (oget mpp.[u])))); 2: by apply mu_dblock_take.
by apply mu_le => r _ /= ->.
qed.

(* One SHAKE256 query adds at most one entry to RO_rest *)
hoare RoutedH_rest (n : int) : RoutedH.get : fsize RO_rest.RO.m <= n ==> fsize RO_rest.RO.m <= n + 1.
proof.
proc; sp; if; 1: by if; inline *; auto => />; smt(fsize_set).
if; 1: by if; inline *; auto => />; smt(fsize_set).
if; 1: by inline *; auto => /> /#.
by if; inline *; auto => />; smt(fsize_set).
qed.

hoare squeeze_rest : Squeeze(RoutedH).squeeze : RO_rest.RO.m = empty /\ len = 64 ==> fsize RO_rest.RO.m <= 1.
proof.
proc; while (fsize RO_rest.RO.m <= j /\ len = 64 /\ 0 <= j <= 1).
+ by wp; exlim j => j0; call (RoutedH_rest j0); auto => /> /#.
by auto => />; smt(fsize_empty).
qed.

section.

declare module A <: DS2.Adversary {
  -DS2.RO1.RO, -DS2.RO2.RO, -DS2.EUF_CMA, -XOFA_O, -XOFS_O, -MLDSA_RO_DS1, -RoutedH,
  -DS5.RO2.RO, -DS5.RO3.RO, -DS5.RO4.RO, -DS5.RO5.RO, -RO_rest.RO, -RO_pad.RO,
  -RO_seed.RO, -RO_S.RO, -RO_rhopp.RO, -RO_v.RO, -CountH, -CountS, -St5, -RO_lp.RO, -RO_lp.FRO,
  -St6, -St7 }.

(* Hop 5.2, up to a rho'' collision: y is keyed by K || rnd || mu; rho'' is sampled but not used.
   rcoll is not bounded here: it is bounded with bad5, once the rho'' values are sampled at the end *)
lemma hop5_2 &m :
  (forall (H1 <: DS2.POracle1 {-A}) (H2 <: DS2.POracle2 {-A}) (O <: DS2.SOracle {-A}),
     islossless H1.get => islossless H2.get => islossless O.sign =>
     islossless A(H1, H2, O).forge) =>
  Pr[DS2.EUF_CMA(RoutedH, DS2.RO2.RO, MLDSA_RO_DS4, A).main() @ &m :
       res \/ bad5 RoutedH.tr RO_rest.RO.m St5.epsp St5.r1 RO_rhopp.RO.m] <=
  Pr[DS2.EUF_CMA(RoutedH, DS2.RO2.RO, MLDSA_RO_DS5R, A).main() @ &m :
       res \/ bad5 RoutedH.tr RO_rest.RO.m St5.epsp St5.r1 RO_lp.RO.m \/ rcoll RO_lp.RO.m].
proof.
move=> A_ll.
byequiv (: ={glob A, glob XOFA_O, glob XOFS_O} ==>
           res{1} \/ bad5 RoutedH.tr{1} RO_rest.RO.m{1} St5.epsp{1} St5.r1{1} RO_rhopp.RO.m{1} =>
           res{2} \/ bad5 RoutedH.tr{2} RO_rest.RO.m{2} St5.epsp{2} St5.r1{2} RO_lp.RO.m{2} \/
           rcoll RO_lp.RO.m{2}) => //.
proc; seq 4 4 : (={glob A, glob DS2.RO2.RO, glob XOFA_O, glob RoutedH, pk, DS2.EUF_CMA.sk, DS2.EUF_CMA.qs,
                   St5.epsp, St5.r1} /\
                 RO_rhopp.RO.m{1} = RO_lp.RO.m{2} /\ renV RO_lp.RO.m{2} RO_v.RO.m{1} RO_v.RO.m{2} /\
                 !rcoll RO_lp.RO.m{2});
  1: by call keygen52; inline *; auto => />.
seq 1 1 : (={pk} /\
           (!rcoll RO_lp.RO.m{2} =>
            ={m, s, glob DS2.RO2.RO, glob XOFA_O, glob RoutedH, DS2.EUF_CMA.qs, St5.epsp, St5.r1} /\
            RO_rhopp.RO.m{1} = RO_lp.RO.m{2})).
+ call (: rcoll RO_lp.RO.m,
          ={glob DS2.RO2.RO, glob XOFA_O, glob RoutedH, DS2.EUF_CMA.sk, DS2.EUF_CMA.qs, St5.epsp, St5.r1} /\
          RO_rhopp.RO.m{1} = RO_lp.RO.m{2} /\ renV RO_lp.RO.m{2} RO_v.RO.m{1} RO_v.RO.m{2}).
  - by move=> H1 H2 O hO h2 h1; apply (A_ll H1 H2 O).
  - by proc; call sign52; auto => />; smt().
  - by move=> &2 _; proc; call sign3_ll; auto.
  - by move=> _; proc; call (: rcoll RO_lp.RO.m ==> rcoll RO_lp.RO.m); [conseq sign5_ll sign5_coll => /# | auto].
  - by proc; auto => /> /#.
  - by move=> &2 _; conseq (: true ==> true) => //; islossless; exact W8.dword_ll.
  - by move=> _; proc; auto => /> *; exact W8.dword_ll.
  - by proc*; call (: ={glob RoutedH}); [by sim | auto => /> /#].
  - by move=> &2 _; conseq RoutedH_get_ll.
  - by move=> _; proc*; call RoutedH_get_ll; auto.
  by skip => /> /#.
case (rcoll RO_lp.RO.m{2}).
+ conseq (: _ ==> rcoll RO_lp.RO.m{2}); 1: smt().
  by call{2} verify2_ll; call{1} verify2_ll; skip => />.
by call (: ={pk, m, sigma, glob DS2.RO2.RO, glob XOFA_O, glob RoutedH} ==> ={res, glob RoutedH});
   [by sim | skip => /> /#].
qed.

(* G5 with the query counters, as a distinguisher for the rho'' oracle O: the rho'' values are read
   after the adversary, and xi and r1, which nothing but bad5 uses, are sampled last *)
local module D6 (O : RO_lp.RO) = {
  module OS = {
    proc sign(m : W8.t list) : BytesSig.t option * leakage = {
      var r;
      DS2.EUF_CMA.qs <- m :: DS2.EUF_CMA.qs;
      r <@ MLDSA_RO_DS5(O, RoutedH, DS2.RO2.RO).sign(DS2.EUF_CMA.sk, m);
      return r;
    }
  }

  proc fin() : bool = {
    var ks,k,v,eps,r1;
    St7.vals <- empty;
    ks <- St6.keys;
    while (ks <> []) {
      k <- head witness ks;
      v <@ O.get(k);
      St7.vals.[k] <- v;
      ks <- behead ks;
    }
    eps <$ dxi;
    St5.epsp <- Bytes34.of_list (Bytes32.to_list eps ++ [W8.of_int kvec;W8.of_int lvec]);
    r1 <$ dblock;
    St5.r1 <- r1;
    return bad5 RoutedH.tr RO_rest.RO.m St5.epsp St5.r1 St7.vals \/ rcoll St7.vals;
  }

  proc distinguish() : bool = {
    var sk,rho,_A,al,s1,s2,t,t1,t0,pk,tr,bs,r0,m,s,b;
    RoutedH.init();
    DS2.RO2.RO.init();
    DS2.EUF_CMA.qs <- [];
    RO_S.RO.init();
    O.init();
    RO_v.RO.init();
    St6.keys <- [];
    r0 <$ dblock;
    rho <- Bytes32.of_list (take 32 r0);
    (_A,al) <@ ExpandA(XOFA_O(DS2.RO2.RO)).sample(rho);
    (s1,s2) <@ ExpandS(XOFS_O(RO_S.RO)).sample(cS);
    t <- invnttv (ntt_mulmxv _A (nttv s1)) + s2;
    (t1,t0) <- Power2Round t;
    pk <@ PkEncDec.pkEncode(rho,t1);
    bs <@ Squeeze(RoutedH).squeeze(BytesPK.to_list pk, 64);
    tr <- Bytes64.of_list bs;
    sk <@ SkEncDec.skEncode(rho,cK,tr,s1,s2,t0);
    DS2.EUF_CMA.sk <- sk;
    (m, s) <@ CountA(A, RoutedH, DS2.RO2.RO, OS).forge(pk);
    b <@ fin();
    return b;
  }
}.

local lemma G5_D6 &m :
  Pr[DS2.EUF_CMA(RoutedH, DS2.RO2.RO, MLDSA_RO_DS5R, A).main() @ &m :
       bad5 RoutedH.tr RO_rest.RO.m St5.epsp St5.r1 RO_lp.RO.m \/ rcoll RO_lp.RO.m] =
  Pr[RO_lp.MainD(D6, RO_lp.RO).distinguish() @ &m : res].
proof.
byequiv (: ={glob A, glob XOFA_O, glob XOFS_O} ==>
           (bad5 RoutedH.tr{1} RO_rest.RO.m{1} St5.epsp{1} St5.r1{1} RO_lp.RO.m{1} \/
            rcoll RO_lp.RO.m{1}) = res{2}) => //.
proc; inline{2} D6(RO_lp.RO).distinguish D6(RO_lp.RO).fin; inline{1} 4;
  inline{2} CountA(A, RoutedH, DS2.RO2.RO, D6(RO_lp.RO).OS).forge.
swap{1} [8..9] 15; swap{1} [9..10] 14.
seq 19 25 : (={glob RoutedH, RO_lp.RO.m, St6.keys} /\ (forall k, k \in RO_lp.RO.m{1} <=> k \in St6.keys{1})).
+ wp; call (: ={glob DS2.RO2.RO, glob XOFA_O, glob RoutedH, RO_v.RO.m, RO_lp.RO.m, St6.keys, DS2.EUF_CMA.sk,
               DS2.EUF_CMA.qs} /\
              (forall k, k \in RO_lp.RO.m{1} <=> k \in St6.keys{1})).
  - proc; inline{2} 2; wp.
    call (: ={sk, m, glob DS2.RO2.RO, glob XOFA_O, glob RoutedH, RO_v.RO.m, RO_lp.RO.m, St6.keys} /\
            (forall k, k \in RO_lp.RO.m{1} <=> k \in St6.keys{1})
            ==> ={res, glob DS2.RO2.RO, glob XOFA_O, glob RoutedH, RO_v.RO.m, RO_lp.RO.m, St6.keys} /\
                (forall k, k \in RO_lp.RO.m{1} <=> k \in St6.keys{1})); 2: by auto.
    by conseq (: ={sk, m, glob DS2.RO2.RO, glob XOFA_O, glob RoutedH, RO_v.RO.m, RO_lp.RO.m, St6.keys}
                 ==> ={res, glob DS2.RO2.RO, glob XOFA_O, glob RoutedH, RO_v.RO.m, RO_lp.RO.m, St6.keys})
               sign5_keys _; [smt() | smt() | sim].
  - by proc; auto.
  - by proc*; inline{2} 1; wp; call (: ={glob RoutedH}); [by sim | auto].
  wp; call (: true); 1: by sim.
  wp; call (: ={glob RoutedH}); 1: by sim.
  call (: true); 1: by sim.
  wp; call (: ={glob RO_S.RO, glob XOFS_O}); 1: by sim.
  call (: ={glob DS2.RO2.RO, glob XOFA_O}); 1: by sim.
  by inline *; auto => />; smt(mem_empty).
seq 1 3 : (={RoutedH.tr, RO_rest.RO.m, RO_lp.RO.m} /\ St7.vals{2} = RO_lp.RO.m{2});
  last by wp; rnd; wp; rnd; auto => />.
call{1} verify2_ll.
while{2} (RO_lp.RO.m{2} = RO_lp.RO.m{1} /\
          (forall k, k \in St7.vals{2} => St7.vals{2}.[k] = RO_lp.RO.m{2}.[k]) /\
          (forall k, k \in RO_lp.RO.m{2} => k \in St7.vals{2} \/ k \in ks{2}) /\
          (forall k, k \in ks{2} => k \in RO_lp.RO.m{2}))
         (size ks{2}).
+ move=> &m0 z; inline RO_lp.RO.get; wp; rnd; wp; skip => /> &hr h1 h2 h3 hne.
  move: hne h2 h3; case: (ks{hr}) => // a l _ h2 h3 /=; have ha : a \in RO_lp.RO.m{m0} by apply h3.
  rewrite ha /= (mu_eq _ _ predT); 2: by apply dlist_ll; apply W8.dword_ll.
  move=> x1 /=; rewrite /predT /= eqT.
  split; [split; [move=> k0; rewrite mem_set get_setE => -[hk | ->>] /=;
                  [case: (k0 = a) => [->> /= | _]; [smt(domE) | exact h1] | smt(domE)] |
                  split; [smt(mem_set) | smt()]] |
          smt(size_ge0)].
wp; skip => /> &2 hk; split; 1: smt(mem_empty).
move=> vals ks; split; 1: smt(size_eq0 size_ge0).
move=> h1 h2; apply fmap_eqP => k; case: (k \in vals) => hv; 1: exact h1.
have hm : k \notin RO_lp.RO.m{2} by smt().
by move: hv hm; rewrite !domE => /= -> ->.
qed.

local lemma D6_LRO &m :
  Pr[RO_lp.MainD(D6, RO_lp.RO).distinguish() @ &m : res] =
  Pr[RO_lp.MainD(D6, RO_lp.LRO).distinguish() @ &m : res].
proof.
byequiv (RO_lp.FullEager.RO_LRO D6 _) => //.
by move=> _; apply dlist_ll; apply W8.dword_ll.
qed.

(* The end of G6: each fresh rho'' costs (qS + qH + 1) * p512, xi costs (qH + 1) * p256, and
   r1 = rho'_hi || K costs (2 * (qH + 1) + 1 + qS) * p256 *)
local ehoare fin_e (qH qS : int) : D6(RO_lp.LRO).fin :
  (RO_lp.RO.m = empty /\ fsize RO_rest.RO.m <= qH + 1 /\ size St6.keys <= qS /\ 0 <= qH /\ 0 <= qS) `|`
    ((qS * (qS + qH + 1))%r * p512 + (3 * qH + qS + 4)%r * p256)%xr
  ==> res%xr.
proof.
proc.
seq 3 : ((fsize RO_rest.RO.m <= qH + 1 /\ fsize St7.vals <= qS /\ 0 <= qH) `|`
         (b2r (badpp RoutedH.tr RO_rest.RO.m St7.vals) + (3 * qH + qS + 4)%r * p256)%xr).
+ while ((St7.vals = RO_lp.RO.m /\ fsize RO_rest.RO.m <= qH + 1 /\ fsize St7.vals + size ks <= qS /\
          0 <= qH /\ 0 <= qS) `|`
         (b2r (badpp RoutedH.tr RO_rest.RO.m St7.vals) + (size ks)%r * ((qS + qH + 1)%r * p512) +
          (3 * qH + qS + 4)%r * p256)%xr).
  - move=> &hr; apply xle_cxr_r => hks; apply xle_cxr_r => [#] hv hR hs hqH hqS.
    have hk0 : ks{hr} = [] by smt().
    by apply xle_cxr_l; [rewrite hR hqH /=; move: hs; rewrite hk0 | rewrite hk0].
  - inline RO_lp.LRO.get; auto => &hr /=.
    apply xle_cxr_r => [#] hks hv hR hs hqH hqS; move: hks hs; case: (ks{hr}) => // a l _ hs /=.
    have hc : 0%r <= (qS + qH + 1)%r * p512 by apply RealOrder.mulr_ge0; smt(RealOrder.expr_ge0).
    have hE0 : 0%r <= (3 * qH + qS + 4)%r * p256 by apply RealOrder.mulr_ge0; smt(RealOrder.expr_ge0).
    case: (a \in RO_lp.RO.m{hr}) => hm /=.
    * have hv' : St7.vals{hr}.[a <- oget RO_lp.RO.m{hr}.[a]] = St7.vals{hr}.
      + rewrite hv; apply fmap_eqP => z; rewrite get_setE; case: (z = a) => [->> | //].
        by move: hm; rewrite domE; case: (RO_lp.RO.m{hr}.[a]).
      rewrite hv' EpC /dblock (dlist_ll W8.dword 64 W8.dword_ll) smul1m; apply xle_cxr_l.
      + by rewrite hv hR hqH hqS /=; move: hs hv; rewrite /= => hs <-; smt().
      by apply xle_rle; smt(size_ge0).
    have hva : a \notin St7.vals{hr} by rewrite hv.
    apply (xle_trans (Ep dblock (fun r0 =>
             (b2r (badpp RoutedH.tr{hr} RO_rest.RO.m{hr} St7.vals{hr} \/
                   ((exists y, y \in St7.vals{hr} /\ r0 = oget St7.vals{hr}.[y]) \/
                    (exists x, x \in RO_rest.RO.m{hr} /\ size x.`1 = 66 /\ take 64 x.`1 = r0) \/
                    r0 = Bytes64.to_list RoutedH.tr{hr})) +
              ((size l)%r * ((qS + qH + 1)%r * p512) + (3 * qH + qS + 4)%r * p256))%xr))).
    * apply le_Ep => r0 _ /=; rewrite get_set_sameE /=; apply xle_cxr_l.
      + split; 1: by rewrite hv.
        by rewrite hR hqH hqS /= fsize_set hva /b2i /=; smt().
      apply xle_rle; have /le_b2r hle := (badpp_set RoutedH.tr{hr} RO_rest.RO.m{hr} St7.vals{hr} a r0 hva).
      split; 2: smt().
      have hl0 : 0%r <= (size l)%r * ((qS + qH + 1)%r * p512) by apply RealOrder.mulr_ge0; smt(size_ge0).
      by rewrite /b2r; smt().
    apply (xle_trans _ _ _ (Ep_hitE dblock (badpp RoutedH.tr{hr} RO_rest.RO.m{hr} St7.vals{hr}) true
             (fun r0 => badpp RoutedH.tr{hr} RO_rest.RO.m{hr} St7.vals{hr} \/
                        ((exists y, y \in St7.vals{hr} /\ r0 = oget St7.vals{hr}.[y]) \/
                         (exists x, x \in RO_rest.RO.m{hr} /\ size x.`1 = 66 /\ take 64 x.`1 = r0) \/
                         r0 = Bytes64.to_list RoutedH.tr{hr}))
             (fun r0 => (exists y, y \in St7.vals{hr} /\ r0 = oget St7.vals{hr}.[y]) \/
                        (exists x, x \in RO_rest.RO.m{hr} /\ size x.`1 = 66 /\ take 64 x.`1 = r0) \/
                        r0 = Bytes64.to_list RoutedH.tr{hr})
             ((size l)%r * ((qS + qH + 1)%r * p512) + (3 * qH + qS + 4)%r * p256)
             ((qS + qH + 1)%r * p512) _ _ _ _)).
    * by apply dlist_ll; apply W8.dword_ll.
    * apply (RealOrder.ler_trans _ _ _ (mu_fresh_pp RoutedH.tr{hr} RO_rest.RO.m{hr} St7.vals{hr})).
      have hp : 0%r <= p512 by smt(RealOrder.expr_ge0).
      have -> : (fsize St7.vals{hr})%r * p512 + ((fsize RO_rest.RO.m{hr})%r * p512 + p512) =
                (fsize St7.vals{hr} + fsize RO_rest.RO.m{hr} + 1)%r * p512 by rewrite !fromintD; ring.
      by apply RealOrder.ler_wpmul2r => //; rewrite le_fromint; move: hs => /=; smt(size_ge0).
    * have hl0 : 0%r <= (size l)%r * ((qS + qH + 1)%r * p512) by apply RealOrder.mulr_ge0; smt(size_ge0).
      smt().
    * by move=> r0 /=.
    have hl0 : 0%r <= (size l)%r * ((qS + qH + 1)%r * p512) by apply RealOrder.mulr_ge0; smt(size_ge0).
    by apply xle_rle; case: (badpp RoutedH.tr{hr} RO_rest.RO.m{hr} St7.vals{hr}) => _;
       rewrite /b2r /= fromintD; smt().
  wp; skip => &hr /=; apply xle_cxr_r => [#] hm hR hk hqH hqS; apply xle_cxr_l.
  - by rewrite hm hR hqH hqS fsize_empty /=.
  have -> /= : !badpp RoutedH.tr{hr} RO_rest.RO.m{hr} empty by rewrite /badpp /rcoll; smt(mem_empty).
  have hp : 0%r <= p512 by smt(RealOrder.expr_ge0).
  have hp2 : 0%r <= p256 by smt(RealOrder.expr_ge0).
  have hq : (qS * (qS + qH + 1))%r * p512 = qS%r * ((qS + qH + 1)%r * p512) by rewrite fromintM; ring.
  have hk' : (size St6.keys{hr})%r * ((qS + qH + 1)%r * p512) <= (qS * (qS + qH + 1))%r * p512.
  - by rewrite hq; apply RealOrder.ler_wpmul2r; [apply RealOrder.mulr_ge0; smt() | smt()].
  by apply le_pos; smt(size_ge0 RealOrder.mulr_ge0).
seq 2 : ((fsize RO_rest.RO.m <= qH + 1 /\ fsize St7.vals <= qS /\ 0 <= qH) `|`
         (b2r (badpp RoutedH.tr RO_rest.RO.m St7.vals \/
               exists x, x \in RO_rest.RO.m /\ x.`1 = Bytes34.to_list St5.epsp) +
          (2 * (qH + 1) + 1 + qS)%r * p256)%xr).
+ auto => &hr /=; apply xle_cxr_r => [#] hR hv hqH.
  have hp2 : 0%r <= p256 by smt(RealOrder.expr_ge0).
  have hqS : 0 <= qS by smt(ge0_fsize).
  have hK : 0%r <= (2 * (qH + 1) + 1 + qS)%r * p256 by apply RealOrder.mulr_ge0; smt().
  apply (xle_trans (Ep dxi (fun e =>
           (b2r (badpp RoutedH.tr{hr} RO_rest.RO.m{hr} St7.vals{hr} \/
                 exists x, x \in RO_rest.RO.m{hr} /\
                   x.`1 = Bytes34.to_list (Bytes34.of_list (Bytes32.to_list e ++ [W8.of_int kvec; W8.of_int lvec]))) +
            (2 * (qH + 1) + 1 + qS)%r * p256)%xr))).
  - by apply le_Ep => e _ /=; apply xle_cxr_l.
  apply (xle_trans _ _ _ (Ep_hitE dxi (badpp RoutedH.tr{hr} RO_rest.RO.m{hr} St7.vals{hr}) true
           (fun e => badpp RoutedH.tr{hr} RO_rest.RO.m{hr} St7.vals{hr} \/
                     exists x, x \in RO_rest.RO.m{hr} /\
                       x.`1 = Bytes34.to_list (Bytes34.of_list (Bytes32.to_list e ++ [W8.of_int kvec; W8.of_int lvec])))
           (fun e => exists x, x \in RO_rest.RO.m{hr} /\
                       x.`1 = Bytes34.to_list (Bytes34.of_list (Bytes32.to_list e ++ [W8.of_int kvec; W8.of_int lvec])))
           ((2 * (qH + 1) + 1 + qS)%r * p256) ((qH + 1)%r * p256) _ _ _ _)).
  - by rewrite /dxi; apply dmap_ll; apply dlist_ll; apply W8.dword_ll.
  - apply (RealOrder.ler_trans _ _ _ (mu_xi_hit RO_rest.RO.m{hr})).
    by apply RealOrder.ler_wpmul2r => //; smt().
  - by [].
  - by move=> e /=.
  by apply xle_rle; case: (badpp RoutedH.tr{hr} RO_rest.RO.m{hr} St7.vals{hr}) => _;
     rewrite /b2r /= !fromintD; smt().
auto => &hr /=; apply xle_cxr_r => [#] hR hv hqH.
have hp2 : 0%r <= p256 by smt(RealOrder.expr_ge0).
have hqS : 0 <= qS by smt(ge0_fsize).
apply (xle_trans (Ep dblock (fun r =>
         (b2r (bad5 RoutedH.tr{hr} RO_rest.RO.m{hr} St5.epsp{hr} r St7.vals{hr} \/ rcoll St7.vals{hr}) +
          0%r)%xr))).
+ by apply le_Ep => r _ /=.
apply (xle_trans _ _ _ (Ep_hitE dblock
         (badpp RoutedH.tr{hr} RO_rest.RO.m{hr} St7.vals{hr} \/
          exists x, x \in RO_rest.RO.m{hr} /\ x.`1 = Bytes34.to_list St5.epsp{hr}) true
         (fun r => bad5 RoutedH.tr{hr} RO_rest.RO.m{hr} St5.epsp{hr} r St7.vals{hr} \/ rcoll St7.vals{hr})
         (fun r => (exists x, x \in RO_rest.RO.m{hr} /\ size x.`1 = 66 /\ drop 32 (take 64 x.`1) = take 32 r) \/
                   (exists x, x \in RO_rest.RO.m{hr} /\ size x.`1 = 128 /\ take 32 x.`1 = drop 32 r) \/
                   drop 32 r = take 32 (Bytes64.to_list RoutedH.tr{hr}) \/
                   (exists y, y \in St7.vals{hr} /\ drop 32 (oget St7.vals{hr}.[y]) = take 32 r))
         0%r ((2 * (qH + 1) + 1 + qS)%r * p256) _ _ _ _)).
+ by apply dlist_ll; apply W8.dword_ll.
+ apply (RealOrder.ler_trans _ _ _ (mu_r1_hit RoutedH.tr{hr} RO_rest.RO.m{hr} St7.vals{hr})).
  have -> : (fsize RO_rest.RO.m{hr})%r * p256 +
            ((fsize RO_rest.RO.m{hr})%r * p256 + (p256 + (fsize St7.vals{hr})%r * p256)) =
            (2 * fsize RO_rest.RO.m{hr} + 1 + fsize St7.vals{hr})%r * p256
    by rewrite !fromintD fromintM; ring.
  by apply RealOrder.ler_wpmul2r => //; rewrite le_fromint; smt().
+ by [].
+ by move=> r /=; rewrite /bad5 /badpp; smt().
by apply xle_rle; case: (badpp RoutedH.tr{hr} RO_rest.RO.m{hr} St7.vals{hr} \/
                         exists x, x \in RO_rest.RO.m{hr} /\ x.`1 = Bytes34.to_list St5.epsp{hr}) => _;
   rewrite /b2r /=; smt().
qed.

local lemma fin_bound (qH qS : int) : 0 <= qH => 0 <= qS =>
  phoare [D6(RO_lp.LRO).fin :
    RO_lp.RO.m = empty /\ fsize RO_rest.RO.m <= qH + 1 /\ size St6.keys <= qS ==> res]
  <= ((qS * (qS + qH + 1))%r * p512 + (3 * qH + qS + 4)%r * p256).
proof.
move=> hqH hqS; bypr => &hr; split; 1: smt(RealOrder.mulr_ge0 RealOrder.expr_ge0).
move=> hR; byehoare (: (RO_lp.RO.m = empty /\ fsize RO_rest.RO.m <= qH + 1 /\ size St6.keys <= qS /\
                        0 <= qH /\ 0 <= qS) `|`
                       ((qS * (qS + qH + 1))%r * p512 + (3 * qH + qS + 4)%r * p256)%xr ==> res%xr).
+ by conseq (fin_e qH qS).
+ by apply xle_cxr_l; smt().
+ by move=> &hr0.
by smt(RealOrder.mulr_ge0 RealOrder.expr_ge0).
qed.

(* Under LRO the signing oracle adds one key and never touches the rho'' map *)
local hoare OS6_sign (n : int) : D6(RO_lp.LRO).OS.sign :
  size St6.keys = n /\ RO_lp.RO.m = empty ==> size St6.keys = n + 1 /\ RO_lp.RO.m = empty.
proof.
proc; call (: size St6.keys = n /\ RO_lp.RO.m = empty ==> size St6.keys = n + 1 /\ RO_lp.RO.m = empty);
  2: by auto.
proc; seq 21 : (size St6.keys = n + 1 /\ RO_lp.RO.m = empty);
  2: by if; [call (: true); [by conseq /> | auto] | auto].
while (size St6.keys = n + 1 /\ RO_lp.RO.m = empty).
+ by wp; call (: true); [by conseq /> | call (: true); [by conseq /> | wp; call (: true); [by conseq /> | auto]]].
seq 15 : (size St6.keys = n /\ RO_lp.RO.m = empty).
+ by call (: true); [by conseq /> | wp; call (: true); [by conseq /> | wp; call (: true); [by conseq /> | auto]]].
by inline *; auto => /> /#.
qed.

local lemma bound6 (qH qS : int) &m : 0 <= qH => 0 <= qS =>
  Pr[RO_lp.MainD(D6, RO_lp.LRO).distinguish() @ &m : res /\ CountH.c <= qH /\ CountS.c <= qS] <=
  (qS * (qS + qH + 1))%r * p512 + (3 * qH + qS + 4)%r * p256.
proof.
move=> hqH hqS; byphoare => //; proc.
inline D6(RO_lp.LRO).distinguish CountA(A, RoutedH, DS2.RO2.RO, D6(RO_lp.LRO).OS).forge.
seq 25 : (RO_lp.RO.m = empty /\ fsize RO_rest.RO.m <= CountH.c + 1 /\ size St6.keys = CountS.c)
         1%r ((qS * (qS + qH + 1))%r * p512 + (3 * qH + qS + 4)%r * p256) 0%r 1%r.
+ by conseq />.
+ by conseq (: true ==> true).
+ case (CountH.c <= qH /\ CountS.c <= qS).
  - by wp; call (fin_bound qH qS hqH hqS); auto => /> /#.
  hoare; 1: smt(RealOrder.mulr_ge0 RealOrder.expr_ge0).
  by wp; call (: true); [by conseq /> | auto => /> /#].
+ hoare.
  wp; call (: RO_lp.RO.m = empty /\ fsize RO_rest.RO.m <= CountH.c + 1 /\ size St6.keys = CountS.c).
  - by proc; exlim St6.keys => ks0; call (OS6_sign (size ks0)); auto => /> /#.
  - by proc; auto.
  - by proc; exlim RO_rest.RO.m => m0; call (RoutedH_rest (fsize m0)); auto => /> /#.
  wp; call (: true); 1: by conseq />.
  wp; call squeeze_rest.
  call (: true); 1: by conseq />.
  wp; call (: true); 1: by conseq />.
  call (: true); 1: by conseq />.
  by inline *; auto => />; smt(fsize_empty).
by [].
qed.

local lemma count_ok6 (qH qS : int) &m :
  (forall (H <: DS2.POracle1 {-A, -CountH, -CountS}) (G <: DS2.POracle2 {-A, -CountH, -CountS})
          (O <: DS2.SOracle {-A, -CountH, -CountS}),
     hoare [A(CountH(H), G, CountS(O)).forge :
              CountH.c = 0 /\ CountS.c = 0 ==> CountH.c <= qH /\ CountS.c <= qS]) =>
  Pr[RO_lp.MainD(D6, RO_lp.LRO).distinguish() @ &m : !(CountH.c <= qH /\ CountS.c <= qS)] = 0%r.
proof.
move=> A_count; byphoare => //; hoare; proc.
inline D6(RO_lp.LRO).distinguish CountA(A, RoutedH, DS2.RO2.RO, D6(RO_lp.LRO).OS).forge.
wp; call (: true); 1: by conseq />.
wp; call (A_count (<: RoutedH) (<: DS2.RO2.RO) (<: D6(RO_lp.LRO).OS)).
by seq 21 : true; [by conseq /> | by auto].
qed.

(* bad5 and the rho'' collision, bounded in G5 through G6, where rho'', xi and r1 are sampled after the
   adversary: at most qH + 1 entries of RO_rest (the adversary's queries and the pk query of key
   generation) and at most qS rho'' keys *)
lemma hop5_bad (qH qS : int) &m : 0 <= qH => 0 <= qS =>
  (forall (H <: DS2.POracle1 {-A, -CountH, -CountS}) (G <: DS2.POracle2 {-A, -CountH, -CountS})
          (O <: DS2.SOracle {-A, -CountH, -CountS}),
     hoare [A(CountH(H), G, CountS(O)).forge :
              CountH.c = 0 /\ CountS.c = 0 ==> CountH.c <= qH /\ CountS.c <= qS]) =>
  Pr[DS2.EUF_CMA(RoutedH, DS2.RO2.RO, MLDSA_RO_DS5R, A).main() @ &m :
       bad5 RoutedH.tr RO_rest.RO.m St5.epsp St5.r1 RO_lp.RO.m \/ rcoll RO_lp.RO.m] <=
  (qS * (qS + qH + 1))%r * p512 + (3 * qH + qS + 4)%r * p256.
proof.
move=> hqH hqS A_count; rewrite (G5_D6 &m) (D6_LRO &m).
have h1 := bound6 qH qS &m hqH hqS.
have h2 := count_ok6 qH qS &m A_count.
have h3 : Pr[RO_lp.MainD(D6, RO_lp.LRO).distinguish() @ &m : res] <=
          Pr[RO_lp.MainD(D6, RO_lp.LRO).distinguish() @ &m : res /\ CountH.c <= qH /\ CountS.c <= qS] +
          Pr[RO_lp.MainD(D6, RO_lp.LRO).distinguish() @ &m : !(CountH.c <= qH /\ CountS.c <= qS)].
+ rewrite Pr[mu_split (CountH.c <= qH /\ CountS.c <= qS)]; apply RealOrder.ler_add2l.
  by rewrite Pr[mu_sub].
smt().
qed.

(* Hop 5: the hidden inputs xi, rho', K and rho'' are eliminated; bad4 is bounded *)
lemma hop5 (qH qS : int) &m : 0 <= qH => 0 <= qS =>
  (forall (H1 <: DS2.POracle1 {-A}) (H2 <: DS2.POracle2 {-A}) (O <: DS2.SOracle {-A}),
     islossless H1.get => islossless H2.get => islossless O.sign =>
     islossless A(H1, H2, O).forge) =>
  (forall (H <: DS2.POracle1 {-A, -CountH, -CountS}) (G <: DS2.POracle2 {-A, -CountH, -CountS})
          (O <: DS2.SOracle {-A, -CountH, -CountS}),
     hoare [A(CountH(H), G, CountS(O)).forge :
              CountH.c = 0 /\ CountS.c = 0 ==> CountH.c <= qH /\ CountS.c <= qS]) =>
  Pr[DS2.EUF_CMA(DS2.RO1.RO, DS2.RO2.RO, MLDSA_RO_DS1, A).main() @ &m : res] <=
  Pr[DS2.EUF_CMA(RoutedH, DS2.RO2.RO, MLDSA_RO_DS5R, A).main() @ &m : res] +
  2%r * p512 + (qH + qS * (1 + kappa_max) + 2)%r * p512 +
  ((qS * (qS + qH + 1))%r * p512 + (3 * qH + qS + 4)%r * p256).
proof.
move=> hqH hqS A_ll A_count.
have h4 := hop4 A qH qS &m hqH hqS A_ll A_count.
have h51 := hop5_1 A &m.
have h52 := hop5_2 &m A_ll.
have hb := hop5_bad qH qS &m hqH hqS A_count.
have hor : Pr[DS2.EUF_CMA(RoutedH, DS2.RO2.RO, MLDSA_RO_DS5R, A).main() @ &m :
               res \/ bad5 RoutedH.tr RO_rest.RO.m St5.epsp St5.r1 RO_lp.RO.m \/ rcoll RO_lp.RO.m] <=
           Pr[DS2.EUF_CMA(RoutedH, DS2.RO2.RO, MLDSA_RO_DS5R, A).main() @ &m : res] +
           Pr[DS2.EUF_CMA(RoutedH, DS2.RO2.RO, MLDSA_RO_DS5R, A).main() @ &m :
               bad5 RoutedH.tr RO_rest.RO.m St5.epsp St5.r1 RO_lp.RO.m \/ rcoll RO_lp.RO.m]
  by rewrite Pr[mu_or]; smt(mu_bounded).
smt().
qed.

end section.

end MLDSA_ROSep_Hop5.
