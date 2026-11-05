require import AllCore IntDiv List Distr DList PROM FMap Xreal StdBigop StdOrder.
from Jasmin require import JByte_array JWord.
require import Array256.

require import Parameters GFq Rq.
require MLDSA_ROSep_Hop3.
require import MLDSA_RO MLDSA_ROSep MLDSA_ROSep_Hop1 MLDSA_ROSep_Hop2 MLDSA_ROSep_Hop3.
require import DistrExtra.

require import Leakage.
abstract theory MLDSA_ROSep_Hop4.

clone include MLDSA_ROSep_Hop3.MLDSA_ROSep_Hop3.
import Spec.
import PolyLVec PolyKVec PolyMat.
import Round ZModQ Zq MLDSAParams.


(*************** G3: the hidden inputs leave the routed oracle ****************)

module MLDSA_RO_DS3(H : BlockOracle, G : Oracle) = {
  proc keygen() : BytesPK.t * BytesSK.t = {
    var eps,sk,rho,rhop,_K,_A,al,s1,s2,t,t1,t0,pk,tr,epsp,bs;
    RO_seed.RO.init();
    RO_S.RO.init();
    RO_rhopp.RO.init();
    RO_v.RO.init();
    eps <$ dxi;
    epsp <- Bytes34.of_list (Bytes32.to_list eps ++ [W8.of_int kvec;W8.of_int lvec]);
    bs <@ Squeeze(RO_seed.RO).squeeze(Bytes34.to_list epsp, 128);
    (rho,rhop,_K) <- ( Bytes32.of_list (take 32 bs)
                     , Bytes64.of_list (take 64 (drop 32 bs))
                     , Bytes32.of_list (drop 96 bs) );
    (_A,al) <@ ExpandA(XOFA_O(G)).sample(rho);
    (s1,s2) <@ ExpandS(XOFS_O(RO_S.RO)).sample(rhop);
    t <- invnttv (ntt_mulmxv _A (nttv s1)) + s2;
    (t1,t0) <- Power2Round t;
    pk <@ PkEncDec.pkEncode(rho,t1);
    bs <@ Squeeze(H).squeeze(BytesPK.to_list pk, 64);
    tr <- Bytes64.of_list bs;
    sk <@ SkEncDec.skEncode(rho,_K,tr,s1,s2,t0);
    return (pk,sk);
  }

  proc sign(sk : BytesSK.t, m : W8.t list) : BytesSig.t option * leakage = {
     var coins,rho,_K,tr,s1,s2,t0,s1h,s2h,t0h,_A,al,mu,rhopp,kappa,y,w,w1,ctl,ct,c,ch,cs1,
         cs2,z,r0,ct0,h,leakage,sigma,bct0,bs,sl;
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
     bs <@ Squeeze(RO_rhopp.RO).squeeze(Bytes32.to_list _K ++ rnd_to_list coins ++ Bytes64.to_list mu, 64);
     rhopp <- Bytes64.of_list bs;
     kappa <- 0;
     zh <- None;
     while (zh = None && ! (kappa_max <= kappa)) {
       y <@ ExpandMask_O(RO_v.RO).sample(rhopp,kappa * lvec);
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

  proc verify = MLDSA_RO_DS2(H, G).verify
}.

(* bad: the adversary queries xi || k || l, an input rho' || n, an input K || rnd || mu, or an input
   beginning with some rho''; K || rnd = tr; rho'' = tr; rho'' = rho'.
   The rho'' events are stated on the values of RO_rhopp, so that they are decided when rho''
   is sampled, before the rejection loop of signing. *)
op bad4 (tr : Bytes64.t) (mrest mseed mS mrhopp : (W8.t list * int, W8.t list) fmap) : bool =
     (exists x, x \in mrest /\ (x \in mseed \/ x \in mS \/ x \in mrhopp))
  \/ (exists x y, x \in mrest /\ y \in mrhopp /\ size x.`1 = 66 /\ take 64 x.`1 = oget mrhopp.[y])
  \/ (exists y, y \in mrhopp /\
                (take 64 y.`1 = Bytes64.to_list tr \/ oget mrhopp.[y] = Bytes64.to_list tr))
  \/ (exists x y, x \in mS /\ y \in mrhopp /\ take 64 x.`1 = oget mrhopp.[y]).

(* The RO_rest map of G2, split into the hidden maps and the RO_rest map of G3 *)
op inv4 (m2 m3 mseed mS mrhopp mv : (W8.t list * int, W8.t list) fmap) : bool =
  forall x, m2.[x] =
    if x \in mseed then mseed.[x] else if x \in mS then mS.[x] else
    if x \in mrhopp then mrhopp.[x] else if x \in mv then mv.[x] else m3.[x].

op hshape (mseed mS mrhopp mv : (W8.t list * int, W8.t list) fmap) : bool =
     (forall x, x \in mseed => size x.`1 = 34)
  /\ (forall x, x \in mS => size x.`1 = 66)
  /\ (forall x, x \in mrhopp => size x.`1 = 128 /\ x.`2 = 0 /\ size (oget mrhopp.[x]) = 64)
  /\ (forall x, x \in mv => size x.`1 = 66 /\ exists y, y \in mrhopp /\ take 64 x.`1 = oget mrhopp.[y]).

equiv rest4 : RO_rest.RO.get ~ RO_rest.RO.get :
  ={x, RoutedH.tr} /\ hshape RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} RO_v.RO.m{2} /\
  !bad4 RoutedH.tr{2} RO_rest.RO.m{2} RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} /\
  inv4 RO_rest.RO.m{1} RO_rest.RO.m{2} RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} RO_v.RO.m{2}
  ==> !bad4 RoutedH.tr{2} RO_rest.RO.m{2} RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} =>
      ={res} /\
      inv4 RO_rest.RO.m{1} RO_rest.RO.m{2} RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} RO_v.RO.m{2}.
proof.
proc; auto => /> &1 &2 hs1 hs2 hs3 hs4 hb hinv rL _.
have hsp : forall m, x{2} \in m =>
  (x{2} \in RO_seed.RO.m{2} \/ x{2} \in RO_S.RO.m{2} \/ x{2} \in RO_rhopp.RO.m{2} \/ x{2} \in RO_v.RO.m{2}) =>
  bad4 RoutedH.tr{2} m RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2}.
+ move=> m hm -[h | [h | [h | h]]]; rewrite /bad4.
  - by left; exists x{2}; smt().
  - by left; exists x{2}; smt().
  - by left; exists x{2}; smt().
  by right; left; have [_ [y [hy hyv]]] := hs4 _ h; exists x{2} y; smt().
case: (x{2} \in RO_seed.RO.m{2} \/ x{2} \in RO_S.RO.m{2} \/ x{2} \in RO_rhopp.RO.m{2} \/ x{2} \in RO_v.RO.m{2}) => hx.
+ have hb1 : bad4 RoutedH.tr{2} RO_rest.RO.m{2}.[x{2} <- rL] RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2}.
  - by apply hsp; [rewrite mem_set | exact hx].
  have hb2 : x{2} \notin RO_rest.RO.m{2} by apply/negP => h; apply hb; exact (hsp _ h hx).
  smt().
move: hinv; rewrite /inv4 => hinv.
have hx1 : RO_rest.RO.m{1}.[x{2}] = RO_rest.RO.m{2}.[x{2}] by smt().
case: (x{2} \in RO_rest.RO.m{2}) => h2; case: (x{2} \in RO_rest.RO.m{1}) => h1 //=.
+ by rewrite hx1.
+ by move: h1 h2; rewrite !domE hx1.
+ by move: h1 h2; rewrite !domE hx1.
move=> _; rewrite !get_set_sameE /= => y; rewrite !get_setE.
by case: (y = x{2}) => [->> /= | _ /=]; [smt() | exact hinv].
qed.

equiv get4 : RoutedH.get ~ RoutedH.get :
  ={x, RoutedH.tr, RoutedH.trset, RO_pad.RO.m, DS5.RO2.RO.m, DS5.RO3.RO.m, DS5.RO4.RO.m, DS5.RO5.RO.m} /\
  RoutedH.trset{2} /\ hshape RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} RO_v.RO.m{2} /\
  !bad4 RoutedH.tr{2} RO_rest.RO.m{2} RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} /\
  inv4 RO_rest.RO.m{1} RO_rest.RO.m{2} RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} RO_v.RO.m{2}
  ==> ={RoutedH.tr, RoutedH.trset, RO_pad.RO.m, DS5.RO2.RO.m, DS5.RO3.RO.m, DS5.RO4.RO.m, DS5.RO5.RO.m} /\
      RoutedH.trset{2} /\ hshape RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} RO_v.RO.m{2} /\
      (!bad4 RoutedH.tr{2} RO_rest.RO.m{2} RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} =>
       ={res} /\
       inv4 RO_rest.RO.m{1} RO_rest.RO.m{2} RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} RO_v.RO.m{2}).
proof.
proc; sp; if => //.
+ by if => //; [inline *; auto => /> | call rest4; auto => />].
if => //.
+ by if => //; [inline *; auto => /> | call rest4; auto => />].
if => //; 1: by inline *; auto => />.
by if => //; [inline *; auto => /> | call rest4; auto => />].
qed.

equiv getv4 : RoutedH.get ~ RO_v.RO.get :
  ={x} /\
  ={RoutedH.tr, RoutedH.trset, RO_pad.RO.m, DS5.RO2.RO.m, DS5.RO3.RO.m, DS5.RO4.RO.m, DS5.RO5.RO.m} /\
  RoutedH.trset{2} /\ size x{2}.`1 = 66 /\
  (exists y, y \in RO_rhopp.RO.m{2} /\ take 64 x{2}.`1 = oget RO_rhopp.RO.m{2}.[y]) /\
  hshape RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} RO_v.RO.m{2} /\
  !bad4 RoutedH.tr{2} RO_rest.RO.m{2} RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} /\
  inv4 RO_rest.RO.m{1} RO_rest.RO.m{2} RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} RO_v.RO.m{2}
  ==> ={res} /\
      ={RoutedH.tr, RoutedH.trset, RO_pad.RO.m, DS5.RO2.RO.m, DS5.RO3.RO.m, DS5.RO4.RO.m, DS5.RO5.RO.m} /\
      RoutedH.trset{2} /\ hshape RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} RO_v.RO.m{2} /\
      inv4 RO_rest.RO.m{1} RO_rest.RO.m{2} RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} RO_v.RO.m{2}.
proof.
proc; sp 1 0; rcondf{1} 1.
+ by move=> &m; skip => /> &hr _ _ y hy hpre _ hb _; move: hb; rewrite /bad4; smt().
do 3! (rcondf{1} 1; 1: by move=> &m; skip => />; have /= H := param_sets; smt(w1_bytes_big)).
inline *; auto => /> &1 &2 htrs hsz y hy hpre hs1 hs2 hs3 hs4 hb hinv rL _.
have hxs : x{2} \notin RO_seed.RO.m{2} /\ x{2} \notin RO_S.RO.m{2} /\
           x{2} \notin RO_rhopp.RO.m{2} /\ x{2} \notin RO_rest.RO.m{2}
  by move: hb; rewrite /bad4; smt().
move: hinv; rewrite /inv4 => hinv.
have hx1 : RO_rest.RO.m{1}.[x{2}] = RO_v.RO.m{2}.[x{2}] by smt(domE).
case: (x{2} \in RO_v.RO.m{2}) => hv; case: (x{2} \in RO_rest.RO.m{1}) => h1 //=.
+ by rewrite hx1.
+ by move: h1 hv; rewrite !domE hx1.
+ by move: h1 hv; rewrite !domE hx1.
rewrite !get_set_sameE /=; split.
+ by move=> x1; rewrite mem_set => -[h | ->>]; [exact hs4 | smt()].
move=> z; rewrite !get_setE mem_set.
by case: (z = x{2}) => [->> /= | _ /=]; [smt() | exact hinv].
qed.

equiv squeezev4 : Squeeze(RoutedH).squeeze ~ Squeeze(RO_v.RO).squeeze :
  ={x, len} /\
  ={RoutedH.tr, RoutedH.trset, RO_pad.RO.m, DS5.RO2.RO.m, DS5.RO3.RO.m, DS5.RO4.RO.m, DS5.RO5.RO.m} /\
  RoutedH.trset{2} /\ size x{2} = 66 /\
  (exists y, y \in RO_rhopp.RO.m{2} /\ take 64 x{2} = oget RO_rhopp.RO.m{2}.[y]) /\
  hshape RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} RO_v.RO.m{2} /\
  !bad4 RoutedH.tr{2} RO_rest.RO.m{2} RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} /\
  inv4 RO_rest.RO.m{1} RO_rest.RO.m{2} RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} RO_v.RO.m{2}
  ==> ={res} /\
      ={RoutedH.tr, RoutedH.trset, RO_pad.RO.m, DS5.RO2.RO.m, DS5.RO3.RO.m, DS5.RO4.RO.m, DS5.RO5.RO.m} /\
      RoutedH.trset{2} /\ hshape RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} RO_v.RO.m{2} /\
      inv4 RO_rest.RO.m{1} RO_rest.RO.m{2} RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} RO_v.RO.m{2}.
proof.
proc; while (={r, j, x, len} /\
             ={RoutedH.tr, RoutedH.trset, RO_pad.RO.m, DS5.RO2.RO.m, DS5.RO3.RO.m, DS5.RO4.RO.m,
               DS5.RO5.RO.m} /\
             RoutedH.trset{2} /\ size x{2} = 66 /\
             (exists y, y \in RO_rhopp.RO.m{2} /\ take 64 x{2} = oget RO_rhopp.RO.m{2}.[y]) /\
             hshape RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} RO_v.RO.m{2} /\
             !bad4 RoutedH.tr{2} RO_rest.RO.m{2} RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} /\
             inv4 RO_rest.RO.m{1} RO_rest.RO.m{2} RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2}
               RO_v.RO.m{2}).
+ by wp; call getv4; auto => />.
by auto => />.
qed.

equiv emask4 : ExpandMask_O(RoutedH).sample ~ ExpandMask_O(RO_v.RO).sample :
  ={rho, mu} /\
  ={RoutedH.tr, RoutedH.trset, RO_pad.RO.m, DS5.RO2.RO.m, DS5.RO3.RO.m, DS5.RO4.RO.m, DS5.RO5.RO.m} /\
  RoutedH.trset{2} /\
  (exists y, y \in RO_rhopp.RO.m{2} /\ Bytes64.to_list rho{2} = oget RO_rhopp.RO.m{2}.[y]) /\
  hshape RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} RO_v.RO.m{2} /\
  !bad4 RoutedH.tr{2} RO_rest.RO.m{2} RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} /\
  inv4 RO_rest.RO.m{1} RO_rest.RO.m{2} RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} RO_v.RO.m{2}
  ==> ={res} /\
      ={RoutedH.tr, RoutedH.trset, RO_pad.RO.m, DS5.RO2.RO.m, DS5.RO3.RO.m, DS5.RO4.RO.m, DS5.RO5.RO.m} /\
      RoutedH.trset{2} /\ hshape RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} RO_v.RO.m{2} /\
      inv4 RO_rest.RO.m{1} RO_rest.RO.m{2} RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} RO_v.RO.m{2}.
proof.
proc; while (={r, s, rho, mu} /\
             ={RoutedH.tr, RoutedH.trset, RO_pad.RO.m, DS5.RO2.RO.m, DS5.RO3.RO.m, DS5.RO4.RO.m,
               DS5.RO5.RO.m} /\
             RoutedH.trset{2} /\
             (exists y, y \in RO_rhopp.RO.m{2} /\ Bytes64.to_list rho{2} = oget RO_rhopp.RO.m{2}.[y]) /\
             hshape RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} RO_v.RO.m{2} /\
             !bad4 RoutedH.tr{2} RO_rest.RO.m{2} RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} /\
             inv4 RO_rest.RO.m{1} RO_rest.RO.m{2} RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2}
               RO_v.RO.m{2}).
+ by wp; call squeezev4; auto => />; smt(Bytes66.of_listK size_cat Bytes64.size_to_list size_IntegerToBytes take_size_cat Bytes66.size_to_list).
by auto => />.
qed.

equiv getpp4 (a : W8.t list * int) : RoutedH.get ~ RO_rhopp.RO.get :
  ={x} /\ x{2} = a /\
  ={RoutedH.tr, RoutedH.trset, RO_pad.RO.m, DS5.RO2.RO.m, DS5.RO3.RO.m, DS5.RO4.RO.m, DS5.RO5.RO.m} /\
  RoutedH.trset{2} /\ size a.`1 = 128 /\ a.`2 = 0 /\
  hshape RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} RO_v.RO.m{2} /\
  !bad4 RoutedH.tr{2} RO_rest.RO.m{2} RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} /\
  inv4 RO_rest.RO.m{1} RO_rest.RO.m{2} RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} RO_v.RO.m{2}
  ==> ={RoutedH.tr, RoutedH.trset} /\ RoutedH.trset{2} /\
      a \in RO_rhopp.RO.m{2} /\ res{2} = oget RO_rhopp.RO.m{2}.[a] /\
      hshape RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} RO_v.RO.m{2} /\
      (!bad4 RoutedH.tr{2} RO_rest.RO.m{2} RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} =>
       ={res} /\ ={RO_pad.RO.m, DS5.RO2.RO.m, DS5.RO3.RO.m, DS5.RO4.RO.m, DS5.RO5.RO.m} /\
       inv4 RO_rest.RO.m{1} RO_rest.RO.m{2} RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} RO_v.RO.m{2}).
proof.
proc; sp 1 0; if{1}.
+ rcondt{1} 1; 1: by move=> &m; skip => />.
  inline *; wp; rnd{1}; rnd{2}; auto => /> &1 &2 htrs hsz ha2 hs1 hs2 hs3 hs4 hb hinv htk r0 hr0.
  move=> r1 _.
  have hrs : size r0 = 64 by move: hr0; rewrite /dblock supp_dlist //; smt().
  case: (a \in RO_rhopp.RO.m{2}) => hin /=.
  - by move: hb; rewrite /bad4; smt().
  have hbad : bad4 RoutedH.tr{2} RO_rest.RO.m{2} RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2}.[a <- r0]
    by rewrite /bad4; right; right; left; exists a; rewrite mem_set /= htk.
  have hA : (forall x1, x1 \in RO_rhopp.RO.m{2}.[a <- r0] =>
               size x1.`1 = 128 /\ x1.`2 = 0 /\ size (oget RO_rhopp.RO.m{2}.[a <- r0].[x1]) = 64) /\
            (forall x1, x1 \in RO_v.RO.m{2} =>
               size x1.`1 = 66 /\
               exists y, y \in RO_rhopp.RO.m{2}.[a <- r0] /\ take 64 x1.`1 = oget RO_rhopp.RO.m{2}.[a <- r0].[y]).
  - split.
    * by move=> x1; rewrite mem_set get_setE => -[h | ->> /=]; [have := hs3 _ h; smt() | smt()].
    move=> x1 h; have [hs [y [hy hyv]]] := hs4 _ h; split => //.
    by exists y; rewrite mem_set get_setE hy /=; smt().
  by rewrite hbad /= mem_set /=; split => _; exact hA.
do 3! (rcondf{1} 1; 1: by move=> &m; skip => />; have /= H := param_sets; smt(w1_bytes_big)).
inline *; auto => /> &1 &2 htrs hsz ha2 hs1 hs2 hs3 hs4 hb hinv htk rL hrL.
have hrs : size rL = 64 by move: hrL; rewrite /dblock supp_dlist //; smt().
move: hinv; rewrite /inv4 => hinv.
have hxs : a \notin RO_seed.RO.m{2} /\ a \notin RO_S.RO.m{2} /\ a \notin RO_v.RO.m{2} by smt().
have ha : RO_rest.RO.m{1}.[a] =
          if a \in RO_rhopp.RO.m{2} then RO_rhopp.RO.m{2}.[a] else RO_rest.RO.m{2}.[a] by smt().
case: (a \in RO_rhopp.RO.m{2}) => hin /=.
+ have h3 : a \notin RO_rest.RO.m{2}
    by apply/negP => h; apply hb; rewrite /bad4; left; exists a; smt().
  smt(domE).
have hA : (forall x1, x1 \in RO_rhopp.RO.m{2}.[a <- rL] =>
             size x1.`1 = 128 /\ x1.`2 = 0 /\ size (oget RO_rhopp.RO.m{2}.[a <- rL].[x1]) = 64) /\
          (forall x1, x1 \in RO_v.RO.m{2} =>
             size x1.`1 = 66 /\
             exists y, y \in RO_rhopp.RO.m{2}.[a <- rL] /\ take 64 x1.`1 = oget RO_rhopp.RO.m{2}.[a <- rL].[y]).
+ split.
  - by move=> x1; rewrite mem_set get_setE => -[h | ->> /=]; [have := hs3 _ h; smt() | smt()].
  move=> x1 h; have [hs [y [hy hyv]]] := hs4 _ h; split => //.
  by exists y; rewrite mem_set get_setE hy /=; smt().
have hbad : a \in RO_rest.RO.m{2} =>
            bad4 RoutedH.tr{2} RO_rest.RO.m{2} RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2}.[a <- rL]
  by move=> h; rewrite /bad4; left; exists a; rewrite mem_set /= h.
rewrite mem_set /=; split => h1; split; 1, 3: exact hA.
+ move=> _; rewrite !get_set_sameE /= => z; rewrite !get_setE !mem_set.
  by case: (z = a) => [->> /= | _ /=]; [smt() | exact hinv].
smt(domE).
qed.

equiv rhopp4 (a : W8.t list) : Squeeze(RoutedH).squeeze ~ Squeeze(RO_rhopp.RO).squeeze :
  ={x, len} /\ x{2} = a /\ len{2} = 64 /\ size a = 128 /\
  ={RoutedH.tr, RoutedH.trset, RO_pad.RO.m, DS5.RO2.RO.m, DS5.RO3.RO.m, DS5.RO4.RO.m, DS5.RO5.RO.m} /\
  RoutedH.trset{2} /\ hshape RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} RO_v.RO.m{2} /\
  !bad4 RoutedH.tr{2} RO_rest.RO.m{2} RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} /\
  inv4 RO_rest.RO.m{1} RO_rest.RO.m{2} RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} RO_v.RO.m{2}
  ==> ={RoutedH.tr, RoutedH.trset} /\ RoutedH.trset{2} /\
      (a, 0) \in RO_rhopp.RO.m{2} /\ res{2} = oget RO_rhopp.RO.m{2}.[(a, 0)] /\
      hshape RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} RO_v.RO.m{2} /\
      (!bad4 RoutedH.tr{2} RO_rest.RO.m{2} RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} =>
       ={res} /\ ={RO_pad.RO.m, DS5.RO2.RO.m, DS5.RO3.RO.m, DS5.RO4.RO.m, DS5.RO5.RO.m} /\
       inv4 RO_rest.RO.m{1} RO_rest.RO.m{2} RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} RO_v.RO.m{2}).
proof.
proc; sp; rcondt{1} 1; 1: by auto.
rcondt{2} 1; 1: by auto.
seq 1 1 : (={RoutedH.tr, RoutedH.trset} /\ RoutedH.trset{2} /\
           (a, 0) \in RO_rhopp.RO.m{2} /\ b{2} = oget RO_rhopp.RO.m{2}.[(a, 0)] /\
           hshape RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} RO_v.RO.m{2} /\
           (!bad4 RoutedH.tr{2} RO_rest.RO.m{2} RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} =>
            ={b} /\ ={RO_pad.RO.m, DS5.RO2.RO.m, DS5.RO3.RO.m, DS5.RO4.RO.m, DS5.RO5.RO.m} /\
            inv4 RO_rest.RO.m{1} RO_rest.RO.m{2} RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2}
              RO_v.RO.m{2}) /\
           j{1} = 0 /\ j{2} = 0 /\ len{1} = 64 /\ len{2} = 64 /\ r{1} = [] /\ r{2} = []).
+ by call (getpp4 (a, 0)); auto => />.
rcondf{1} 3; 1: by auto.
rcondf{2} 3; 1: by auto.
auto => /> &1 &2 _ hin _ _ hs3 _ h.
have hs : size (oget RO_rhopp.RO.m{2}.[(a, 0)]) = 64 by smt().
smt(take_oversize).
qed.

lemma RO_v_get_ll : islossless RO_v.RO.get.
proof. by islossless; apply dlist_ll; apply W8.dword_ll. qed.

(* Signing agrees until bad4; bad4 is decided when rho'' is sampled, so the rejection loops
   run in sync when it is not set, and one-sided when it is *)
equiv sign4 : MLDSA_RO_DS2(RoutedH, DS2.RO2.RO).sign ~ MLDSA_RO_DS3(RoutedH, DS2.RO2.RO).sign :
  ={sk, m, glob DS2.RO2.RO, glob XOFA_O} /\
  ={RoutedH.tr, RoutedH.trset, RO_pad.RO.m, DS5.RO2.RO.m, DS5.RO3.RO.m, DS5.RO4.RO.m, DS5.RO5.RO.m} /\
  RoutedH.trset{2} /\ hshape RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} RO_v.RO.m{2} /\
  !bad4 RoutedH.tr{2} RO_rest.RO.m{2} RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} /\
  inv4 RO_rest.RO.m{1} RO_rest.RO.m{2} RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} RO_v.RO.m{2}
  ==> !bad4 RoutedH.tr{2} RO_rest.RO.m{2} RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} =>
      ={res, glob DS2.RO2.RO, glob XOFA_O} /\
      ={RoutedH.tr, RoutedH.trset, RO_pad.RO.m, DS5.RO2.RO.m, DS5.RO3.RO.m, DS5.RO4.RO.m, DS5.RO5.RO.m} /\
      RoutedH.trset{2} /\ hshape RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} RO_v.RO.m{2} /\
      inv4 RO_rest.RO.m{1} RO_rest.RO.m{2} RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} RO_v.RO.m{2}.
proof.
proc; seq 15 15 : (={sk, m, coins, ct, ctl, sigma, leakage, rho, _K, tr, s1, s2, t0, s1h, s2h, t0h, _A, mu,
                     glob DS2.RO2.RO, glob XOFA_O} /\
                   ={RoutedH.tr, RoutedH.trset, RO_pad.RO.m, DS5.RO2.RO.m, DS5.RO3.RO.m, DS5.RO4.RO.m,
                     DS5.RO5.RO.m} /\
                   RoutedH.trset{2} /\ hshape RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} RO_v.RO.m{2} /\
                   !bad4 RoutedH.tr{2} RO_rest.RO.m{2} RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} /\
                   inv4 RO_rest.RO.m{1} RO_rest.RO.m{2} RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2}
                     RO_v.RO.m{2}).
+ call (: ={DS5.RO4.RO.m}); 1: by sim.
  wp; call (: ={glob DS2.RO2.RO, glob XOFA_O}); 1: by sim.
  by wp; call (: true); [by sim | auto].
exlim _K{2}, coins{2}, mu{2} => k c mv.
seq 2 2 : (={sk, m, coins, ct, ctl, sigma, leakage, s1h, s2h, t0h, _A, mu, glob DS2.RO2.RO, glob XOFA_O,
             RoutedH.tr, RoutedH.trset} /\
           RoutedH.trset{2} /\ hshape RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} RO_v.RO.m{2} /\
           (exists y, y \in RO_rhopp.RO.m{2} /\ Bytes64.to_list rhopp{2} = oget RO_rhopp.RO.m{2}.[y]) /\
           (!bad4 RoutedH.tr{2} RO_rest.RO.m{2} RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} =>
            ={rhopp} /\ ={RO_pad.RO.m, DS5.RO2.RO.m, DS5.RO3.RO.m, DS5.RO4.RO.m, DS5.RO5.RO.m} /\
            inv4 RO_rest.RO.m{1} RO_rest.RO.m{2} RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2}
              RO_v.RO.m{2})).
+ wp; call (rhopp4 (Bytes32.to_list k ++ rnd_to_list c ++ Bytes64.to_list mv)); auto => />.
  move=> &1 &2 _ _ _ _ _ _ _; split.
  - by rewrite !size_cat Bytes32.size_to_list Bytes64.size_to_list /rnd_to_list Bytes32.size_to_list.
  move=> _ rL mL mL0 mL1 mL2 mL3 mL4 mR hin _ _ hs3 _ h; split; 2: smt().
  exists (Bytes32.to_list k ++ rnd_to_list c ++ Bytes64.to_list mv, 0); split => //.
  by rewrite Bytes64.of_listK //; smt().
case (bad4 RoutedH.tr{2} RO_rest.RO.m{2} RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2}).
+ conseq (: _ ==> bad4 RoutedH.tr{2} RO_rest.RO.m{2} RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2}).
  - by move=> &1 &2 _ *; smt().
  seq 3 3 : (bad4 RoutedH.tr{2} RO_rest.RO.m{2} RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2}).
  - while{2} (bad4 RoutedH.tr{2} RO_rest.RO.m{2} RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2})
             (kappa_max - kappa{2}).
    * move=> _ z0; wp; call sib_XC_ll; call hctpad_ll; wp; call (emask_ll RO_v.RO RO_v_get_ll).
      by auto => /#.
    while{1} true (kappa_max - kappa{1}).
    * move=> _ z0; wp; call sib_XC_ll; call hctpad_ll; wp; call (emask_ll RoutedH RoutedH_get_ll).
      by auto => /#.
    by auto => />; smt().
  by wp; if{2}; [call{2} sigEncode_ll | ]; (if{1}; [call{1} sigEncode_ll | ]); auto.
seq 3 3 : (={kappa, zh, ct, ctl, sigma, leakage, s1h, s2h, t0h, _A, mu, rhopp, glob DS2.RO2.RO,
             glob XOFA_O} /\
           ={RoutedH.tr, RoutedH.trset, RO_pad.RO.m, DS5.RO2.RO.m, DS5.RO3.RO.m, DS5.RO4.RO.m,
             DS5.RO5.RO.m} /\
           RoutedH.trset{2} /\
           (exists y, y \in RO_rhopp.RO.m{2} /\ Bytes64.to_list rhopp{2} = oget RO_rhopp.RO.m{2}.[y]) /\
           hshape RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} RO_v.RO.m{2} /\
           !bad4 RoutedH.tr{2} RO_rest.RO.m{2} RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} /\
           inv4 RO_rest.RO.m{1} RO_rest.RO.m{2} RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2}
             RO_v.RO.m{2}).
+ while (={kappa, zh, ct, ctl, sigma, leakage, s1h, s2h, t0h, _A, mu, rhopp, glob DS2.RO2.RO,
           glob XOFA_O} /\
         ={RoutedH.tr, RoutedH.trset, RO_pad.RO.m, DS5.RO2.RO.m, DS5.RO3.RO.m, DS5.RO4.RO.m,
           DS5.RO5.RO.m} /\
         RoutedH.trset{2} /\
         (exists y, y \in RO_rhopp.RO.m{2} /\ Bytes64.to_list rhopp{2} = oget RO_rhopp.RO.m{2}.[y]) /\
         hshape RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} RO_v.RO.m{2} /\
         !bad4 RoutedH.tr{2} RO_rest.RO.m{2} RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} /\
         inv4 RO_rest.RO.m{1} RO_rest.RO.m{2} RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2}
           RO_v.RO.m{2}).
  - wp; call (: ={DS5.RO2.RO.m}); 1: by sim.
    call (: ={DS5.RO5.RO.m, RO_pad.RO.m}); 1: by sim.
    by wp; call emask4; auto => />.
  by auto => />; smt().
by if => //; wp; call (: true); [by sim | auto => />].
qed.

equiv getseed4 : RoutedH.get ~ RO_seed.RO.get :
  ={x} /\ size x{2}.`1 = 34 /\
  ={RoutedH.tr, RoutedH.trset, RO_pad.RO.m, DS5.RO2.RO.m, DS5.RO3.RO.m, DS5.RO4.RO.m, DS5.RO5.RO.m} /\
  !RoutedH.trset{2} /\ RO_rest.RO.m{2} = empty /\ RO_rhopp.RO.m{2} = empty /\ RO_v.RO.m{2} = empty /\
  hshape RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} RO_v.RO.m{2} /\
  inv4 RO_rest.RO.m{1} RO_rest.RO.m{2} RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} RO_v.RO.m{2}
  ==> ={res} /\
      ={RoutedH.tr, RoutedH.trset, RO_pad.RO.m, DS5.RO2.RO.m, DS5.RO3.RO.m, DS5.RO4.RO.m, DS5.RO5.RO.m} /\
      !RoutedH.trset{2} /\ RO_rest.RO.m{2} = empty /\ RO_rhopp.RO.m{2} = empty /\ RO_v.RO.m{2} = empty /\
      hshape RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} RO_v.RO.m{2} /\
      inv4 RO_rest.RO.m{1} RO_rest.RO.m{2} RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} RO_v.RO.m{2}.
proof.
proc; sp 1 0; rcondf{1} 1; 1: by move=> &m; skip => />.
do 3! (rcondf{1} 1; 1: by move=> &m; skip => />; have /= H := param_sets; smt(w1_bytes_big)).
inline *; auto => /> &1 &2 hsz htr hs1 hs2 _ _ hinv rL _.
move: hinv; rewrite /inv4 => hinv.
have hx1 : RO_rest.RO.m{1}.[x{2}] = RO_seed.RO.m{2}.[x{2}] by smt(emptyE mem_empty domE).
case: (x{2} \in RO_seed.RO.m{2}) => hv; case: (x{2} \in RO_rest.RO.m{1}) => h1 //=.
+ by rewrite hx1.
+ by move: h1 hv; rewrite !domE hx1.
+ by move: h1 hv; rewrite !domE hx1.
rewrite !get_set_sameE /=; split.
+ by move=> x1; rewrite mem_set => -[h | ->>]; [exact hs1 | smt()].
move=> z; rewrite !get_setE mem_set.
by case: (z = x{2}) => [->> /= | _ /=]; [smt() | smt(mem_empty)].
qed.

equiv getS4 : RoutedH.get ~ RO_S.RO.get :
  ={x} /\ size x{2}.`1 = 66 /\
  ={RoutedH.tr, RoutedH.trset, RO_pad.RO.m, DS5.RO2.RO.m, DS5.RO3.RO.m, DS5.RO4.RO.m, DS5.RO5.RO.m} /\
  !RoutedH.trset{2} /\ RO_rest.RO.m{2} = empty /\ RO_rhopp.RO.m{2} = empty /\ RO_v.RO.m{2} = empty /\
  hshape RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} RO_v.RO.m{2} /\
  inv4 RO_rest.RO.m{1} RO_rest.RO.m{2} RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} RO_v.RO.m{2}
  ==> ={res} /\
      ={RoutedH.tr, RoutedH.trset, RO_pad.RO.m, DS5.RO2.RO.m, DS5.RO3.RO.m, DS5.RO4.RO.m, DS5.RO5.RO.m} /\
      !RoutedH.trset{2} /\ RO_rest.RO.m{2} = empty /\ RO_rhopp.RO.m{2} = empty /\ RO_v.RO.m{2} = empty /\
      hshape RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} RO_v.RO.m{2} /\
      inv4 RO_rest.RO.m{1} RO_rest.RO.m{2} RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} RO_v.RO.m{2}.
proof.
proc; sp 1 0; rcondf{1} 1; 1: by move=> &m; skip => />.
do 3! (rcondf{1} 1; 1: by move=> &m; skip => />; have /= H := param_sets; smt(w1_bytes_big)).
inline *; auto => /> &1 &2 hsz htr hs1 hs2 _ _ hinv rL _.
move: hinv; rewrite /inv4 => hinv.
have hx1 : RO_rest.RO.m{1}.[x{2}] = RO_S.RO.m{2}.[x{2}] by smt(emptyE mem_empty domE).
case: (x{2} \in RO_S.RO.m{2}) => hv; case: (x{2} \in RO_rest.RO.m{1}) => h1 //=.
+ by rewrite hx1.
+ by move: h1 hv; rewrite !domE hx1.
+ by move: h1 hv; rewrite !domE hx1.
rewrite !get_set_sameE /=; split.
+ by move=> x1; rewrite mem_set => -[h | ->>]; [exact hs2 | smt()].
move=> z; rewrite !get_setE mem_set.
by case: (z = x{2}) => [->> /= | _ /=]; [smt() | smt(mem_empty)].
qed.

equiv squeezeseed4 : Squeeze(RoutedH).squeeze ~ Squeeze(RO_seed.RO).squeeze :
  ={x, len} /\ size x{2} = 34 /\
  ={RoutedH.tr, RoutedH.trset, RO_pad.RO.m, DS5.RO2.RO.m, DS5.RO3.RO.m, DS5.RO4.RO.m, DS5.RO5.RO.m} /\
  !RoutedH.trset{2} /\ RO_rest.RO.m{2} = empty /\ RO_rhopp.RO.m{2} = empty /\ RO_v.RO.m{2} = empty /\
  hshape RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} RO_v.RO.m{2} /\
  inv4 RO_rest.RO.m{1} RO_rest.RO.m{2} RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} RO_v.RO.m{2}
  ==> ={res} /\
      ={RoutedH.tr, RoutedH.trset, RO_pad.RO.m, DS5.RO2.RO.m, DS5.RO3.RO.m, DS5.RO4.RO.m, DS5.RO5.RO.m} /\
      !RoutedH.trset{2} /\ RO_rest.RO.m{2} = empty /\ RO_rhopp.RO.m{2} = empty /\ RO_v.RO.m{2} = empty /\
      hshape RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} RO_v.RO.m{2} /\
      inv4 RO_rest.RO.m{1} RO_rest.RO.m{2} RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} RO_v.RO.m{2}.
proof.
by proc; while (={r, j, x, len} /\ size x{2} = 34 /\
                ={RoutedH.tr, RoutedH.trset, RO_pad.RO.m, DS5.RO2.RO.m, DS5.RO3.RO.m, DS5.RO4.RO.m,
                  DS5.RO5.RO.m} /\
                !RoutedH.trset{2} /\ RO_rest.RO.m{2} = empty /\ RO_rhopp.RO.m{2} = empty /\
                RO_v.RO.m{2} = empty /\
                hshape RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} RO_v.RO.m{2} /\
                inv4 RO_rest.RO.m{1} RO_rest.RO.m{2} RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2}
                  RO_v.RO.m{2});
   [wp; call getseed4; auto => /> | auto => />].
qed.

equiv next4 : XOFS_O(RoutedH).next ~ XOFS_O(RO_S.RO).next :
  ={glob XOFS_O} /\
  ={RoutedH.tr, RoutedH.trset, RO_pad.RO.m, DS5.RO2.RO.m, DS5.RO3.RO.m, DS5.RO4.RO.m, DS5.RO5.RO.m} /\
  !RoutedH.trset{2} /\ RO_rest.RO.m{2} = empty /\ RO_rhopp.RO.m{2} = empty /\ RO_v.RO.m{2} = empty /\
  hshape RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} RO_v.RO.m{2} /\
  inv4 RO_rest.RO.m{1} RO_rest.RO.m{2} RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} RO_v.RO.m{2}
  ==> ={res, glob XOFS_O} /\
      ={RoutedH.tr, RoutedH.trset, RO_pad.RO.m, DS5.RO2.RO.m, DS5.RO3.RO.m, DS5.RO4.RO.m, DS5.RO5.RO.m} /\
      !RoutedH.trset{2} /\ RO_rest.RO.m{2} = empty /\ RO_rhopp.RO.m{2} = empty /\ RO_v.RO.m{2} = empty /\
      hshape RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} RO_v.RO.m{2} /\
      inv4 RO_rest.RO.m{1} RO_rest.RO.m{2} RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} RO_v.RO.m{2}.
proof.
by proc; inline ReadByte(RoutedH).read ReadByte(RO_S.RO).read; wp; call getS4; auto => />.
qed.

equiv rbp4 : RejBoundedPoly(XOFS_O(RoutedH)).sample ~ RejBoundedPoly(XOFS_O(RO_S.RO)).sample :
  ={rho, glob XOFS_O} /\
  ={RoutedH.tr, RoutedH.trset, RO_pad.RO.m, DS5.RO2.RO.m, DS5.RO3.RO.m, DS5.RO4.RO.m, DS5.RO5.RO.m} /\
  !RoutedH.trset{2} /\ RO_rest.RO.m{2} = empty /\ RO_rhopp.RO.m{2} = empty /\ RO_v.RO.m{2} = empty /\
  hshape RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} RO_v.RO.m{2} /\
  inv4 RO_rest.RO.m{1} RO_rest.RO.m{2} RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} RO_v.RO.m{2}
  ==> ={res, glob XOFS_O} /\
      ={RoutedH.tr, RoutedH.trset, RO_pad.RO.m, DS5.RO2.RO.m, DS5.RO3.RO.m, DS5.RO4.RO.m, DS5.RO5.RO.m} /\
      !RoutedH.trset{2} /\ RO_rest.RO.m{2} = empty /\ RO_rhopp.RO.m{2} = empty /\ RO_v.RO.m{2} = empty /\
      hshape RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} RO_v.RO.m{2} /\
      inv4 RO_rest.RO.m{1} RO_rest.RO.m{2} RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} RO_v.RO.m{2}.
proof.
by proc; while (={j, a, glob XOFS_O} /\
                ={RoutedH.tr, RoutedH.trset, RO_pad.RO.m, DS5.RO2.RO.m, DS5.RO3.RO.m, DS5.RO4.RO.m,
                  DS5.RO5.RO.m} /\
                !RoutedH.trset{2} /\ RO_rest.RO.m{2} = empty /\ RO_rhopp.RO.m{2} = empty /\
                RO_v.RO.m{2} = empty /\
                hshape RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} RO_v.RO.m{2} /\
                inv4 RO_rest.RO.m{1} RO_rest.RO.m{2} RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2}
                  RO_v.RO.m{2});
   [wp; call next4; auto => /> | inline *; auto => />].
qed.

equiv expandS4 : ExpandS(XOFS_O(RoutedH)).sample ~ ExpandS(XOFS_O(RO_S.RO)).sample :
  ={rho, glob XOFS_O} /\
  ={RoutedH.tr, RoutedH.trset, RO_pad.RO.m, DS5.RO2.RO.m, DS5.RO3.RO.m, DS5.RO4.RO.m, DS5.RO5.RO.m} /\
  !RoutedH.trset{2} /\ RO_rest.RO.m{2} = empty /\ RO_rhopp.RO.m{2} = empty /\ RO_v.RO.m{2} = empty /\
  hshape RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} RO_v.RO.m{2} /\
  inv4 RO_rest.RO.m{1} RO_rest.RO.m{2} RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} RO_v.RO.m{2}
  ==> ={res, glob XOFS_O} /\
      ={RoutedH.tr, RoutedH.trset, RO_pad.RO.m, DS5.RO2.RO.m, DS5.RO3.RO.m, DS5.RO4.RO.m, DS5.RO5.RO.m} /\
      !RoutedH.trset{2} /\ RO_rest.RO.m{2} = empty /\ RO_rhopp.RO.m{2} = empty /\ RO_v.RO.m{2} = empty /\
      hshape RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} RO_v.RO.m{2} /\
      inv4 RO_rest.RO.m{1} RO_rest.RO.m{2} RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} RO_v.RO.m{2}.
proof.
proc; while (={r, s1, s2, rho, glob XOFS_O} /\
             ={RoutedH.tr, RoutedH.trset, RO_pad.RO.m, DS5.RO2.RO.m, DS5.RO3.RO.m, DS5.RO4.RO.m,
               DS5.RO5.RO.m} /\
             !RoutedH.trset{2} /\ RO_rest.RO.m{2} = empty /\ RO_rhopp.RO.m{2} = empty /\
             RO_v.RO.m{2} = empty /\
             hshape RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} RO_v.RO.m{2} /\
             inv4 RO_rest.RO.m{1} RO_rest.RO.m{2} RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2}
               RO_v.RO.m{2}).
+ by wp; call rbp4; auto => />.
by wp; while (={r, s1, s2, rho, glob XOFS_O} /\
              ={RoutedH.tr, RoutedH.trset, RO_pad.RO.m, DS5.RO2.RO.m, DS5.RO3.RO.m, DS5.RO4.RO.m,
                DS5.RO5.RO.m} /\
              !RoutedH.trset{2} /\ RO_rest.RO.m{2} = empty /\ RO_rhopp.RO.m{2} = empty /\
              RO_v.RO.m{2} = empty /\
              hshape RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} RO_v.RO.m{2} /\
              inv4 RO_rest.RO.m{1} RO_rest.RO.m{2} RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2}
                RO_v.RO.m{2});
   [wp; call rbp4; auto => /> | auto => />].
qed.

equiv gettr4 : RoutedH.get ~ RoutedH.get :
  ={x} /\ size x{2}.`1 = pk_bytes /\ x{2}.`2 = 0 /\
  ={RoutedH.tr, RoutedH.trset, RO_pad.RO.m, DS5.RO2.RO.m, DS5.RO3.RO.m, DS5.RO4.RO.m, DS5.RO5.RO.m} /\
  !RoutedH.trset{2} /\ RO_rest.RO.m{2} = empty /\ RO_rhopp.RO.m{2} = empty /\ RO_v.RO.m{2} = empty /\
  hshape RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} RO_v.RO.m{2} /\
  inv4 RO_rest.RO.m{1} RO_rest.RO.m{2} RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} RO_v.RO.m{2}
  ==> ={res} /\
      ={RoutedH.tr, RoutedH.trset, RO_pad.RO.m, DS5.RO2.RO.m, DS5.RO3.RO.m, DS5.RO4.RO.m, DS5.RO5.RO.m} /\
      RoutedH.trset{2} /\ RO_rest.RO.m{2} = empty /\ RO_rhopp.RO.m{2} = empty /\ RO_v.RO.m{2} = empty /\
      hshape RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} RO_v.RO.m{2} /\
      inv4 RO_rest.RO.m{1} RO_rest.RO.m{2} RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} RO_v.RO.m{2}.
proof.
proc; sp; rcondf{1} 1; 1: by move=> &m; skip => />.
rcondf{2} 1; 1: by move=> &m; skip => />.
do 2! (rcondf{1} 1; [by move=> &m; skip => />; have /= H := param_sets; smt(w1_bytes_big) |
       rcondf{2} 1; [by move=> &m; skip => />; have /= H := param_sets; smt(w1_bytes_big) | ]]).
rcondt{1} 1; 1: by move=> &m; skip => />.
rcondt{2} 1; 1: by move=> &m; skip => />.
rcondt{1} 3; 1: by move=> &m; inline *; auto => />.
rcondt{2} 3; 1: by move=> &m; inline *; auto => />.
by inline *; auto => />.
qed.

equiv pktr4 : Squeeze(RoutedH).squeeze ~ Squeeze(RoutedH).squeeze :
  ={x, len} /\ size x{2} = pk_bytes /\ len{2} = 64 /\
  ={RoutedH.tr, RoutedH.trset, RO_pad.RO.m, DS5.RO2.RO.m, DS5.RO3.RO.m, DS5.RO4.RO.m, DS5.RO5.RO.m} /\
  !RoutedH.trset{2} /\ RO_rest.RO.m{2} = empty /\ RO_rhopp.RO.m{2} = empty /\ RO_v.RO.m{2} = empty /\
  hshape RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} RO_v.RO.m{2} /\
  inv4 RO_rest.RO.m{1} RO_rest.RO.m{2} RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} RO_v.RO.m{2}
  ==> ={res} /\
      ={RoutedH.tr, RoutedH.trset, RO_pad.RO.m, DS5.RO2.RO.m, DS5.RO3.RO.m, DS5.RO4.RO.m, DS5.RO5.RO.m} /\
      RoutedH.trset{2} /\ RO_rest.RO.m{2} = empty /\ RO_rhopp.RO.m{2} = empty /\ RO_v.RO.m{2} = empty /\
      hshape RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} RO_v.RO.m{2} /\
      inv4 RO_rest.RO.m{1} RO_rest.RO.m{2} RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} RO_v.RO.m{2}.
proof.
proc; sp; rcondt{1} 1; 1: by auto.
rcondt{2} 1; 1: by auto.
rcondf{1} 4; 1: by move=> &m; wp; call (: true); auto.
rcondf{2} 4; 1: by move=> &m; wp; call (: true); auto.
by wp; call gettr4; auto => />.
qed.

(* Key generation: the seed and ExpandS queries move to RO_seed and RO_S; RO_rest and RO_rhopp of G3
   are empty afterwards, so bad4 does not hold *)
equiv keygen4 : MLDSA_RO_DS2(RoutedH, DS2.RO2.RO).keygen ~ MLDSA_RO_DS3(RoutedH, DS2.RO2.RO).keygen :
  ={glob DS2.RO2.RO, glob XOFA_O, glob XOFS_O} /\
  ={RoutedH.tr, RoutedH.trset, RO_pad.RO.m, DS5.RO2.RO.m, DS5.RO3.RO.m, DS5.RO4.RO.m, DS5.RO5.RO.m} /\
  !RoutedH.trset{2} /\ RO_rest.RO.m{1} = empty /\ RO_rest.RO.m{2} = empty
  ==> ={res, glob DS2.RO2.RO, glob XOFA_O} /\
      ={RoutedH.tr, RoutedH.trset, RO_pad.RO.m, DS5.RO2.RO.m, DS5.RO3.RO.m, DS5.RO4.RO.m, DS5.RO5.RO.m} /\
      RoutedH.trset{2} /\ hshape RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} RO_v.RO.m{2} /\
      !bad4 RoutedH.tr{2} RO_rest.RO.m{2} RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} /\
      inv4 RO_rest.RO.m{1} RO_rest.RO.m{2} RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} RO_v.RO.m{2}.
proof.
proc; inline{1} MLDSA_RO(RoutedH, DS2.RO2.RO).keygen_derand.
inline{2} RO_seed.RO.init RO_S.RO.init RO_rhopp.RO.init RO_v.RO.init.
wp; call (: true); 1: by sim.
wp; call pktr4; call (: true); 1: by sim.
wp; call expandS4; call (: ={glob DS2.RO2.RO, glob XOFA_O}); 1: by sim.
wp; call squeezeseed4; wp; rnd; auto => /> &2 _ e _; split; 1: smt(mem_empty).
by move=> *; rewrite /bad4; have /= := key_sizes; smt(mem_empty).
qed.

(*************** bad4 is kept by G3 ****************)

lemma bad4_set_rest t (m3 ms mS mr : (W8.t list * int, W8.t list) fmap) k v :
  bad4 t m3 ms mS mr => bad4 t m3.[k <- v] ms mS mr.
proof. by rewrite /bad4; smt(mem_set). qed.

lemma bad4_set_rhopp t (m3 ms mS mr : (W8.t list * int, W8.t list) fmap) k v :
  k \notin mr => bad4 t m3 ms mS mr => bad4 t m3 ms mS mr.[k <- v].
proof.
move=> hk; rewrite /bad4 => -[h | [[x y [h1 [h2 [h3 h4]]]] | [[y [h1 h2]] | [x y [h1 [h2 h3]]]]]].
+ by left; smt(mem_set).
+ by right; left; exists x y; rewrite mem_set h1 h2 h3 /= get_setE; smt().
+ by right; right; left; exists y; rewrite mem_set h1 /= get_setE; smt().
by right; right; right; exists x y; rewrite mem_set h1 h2 /= get_setE; smt().
qed.

hoare get_B4 : RoutedH.get :
  RoutedH.trset /\ bad4 RoutedH.tr RO_rest.RO.m RO_seed.RO.m RO_S.RO.m RO_rhopp.RO.m
  ==> RoutedH.trset /\ bad4 RoutedH.tr RO_rest.RO.m RO_seed.RO.m RO_S.RO.m RO_rhopp.RO.m.
proof.
proc; sp; if; 1: by if; inline *; auto => />; smt(bad4_set_rest).
if; 1: by if; inline *; auto => />; smt(bad4_set_rest).
if; 1: by inline *; auto.
by if; [rcondf 3; [by inline *; auto | by inline *; auto] | inline *; auto => />; smt(bad4_set_rest)].
qed.

hoare squeezepp_B : Squeeze(RO_rhopp.RO).squeeze :
  bad4 RoutedH.tr RO_rest.RO.m RO_seed.RO.m RO_S.RO.m RO_rhopp.RO.m
  ==> bad4 RoutedH.tr RO_rest.RO.m RO_seed.RO.m RO_S.RO.m RO_rhopp.RO.m.
proof.
by proc; while (bad4 RoutedH.tr RO_rest.RO.m RO_seed.RO.m RO_S.RO.m RO_rhopp.RO.m);
   [inline *; auto => />; smt(bad4_set_rhopp) | auto].
qed.

hoare sign3_B : MLDSA_RO_DS3(RoutedH, DS2.RO2.RO).sign :
  RoutedH.trset /\ bad4 RoutedH.tr RO_rest.RO.m RO_seed.RO.m RO_S.RO.m RO_rhopp.RO.m
  ==> RoutedH.trset /\ bad4 RoutedH.tr RO_rest.RO.m RO_seed.RO.m RO_S.RO.m RO_rhopp.RO.m.
proof.
proc; seq 20 : (RoutedH.trset /\ bad4 RoutedH.tr RO_rest.RO.m RO_seed.RO.m RO_S.RO.m RO_rhopp.RO.m);
  2: by if; [call (: true); [by conseq /> | auto] | auto].
while (RoutedH.trset /\ bad4 RoutedH.tr RO_rest.RO.m RO_seed.RO.m RO_S.RO.m RO_rhopp.RO.m).
+ wp; call (: true); 1: by conseq />.
  call (: true); 1: by conseq />.
  by wp; call (: true); [by conseq /> | auto].
wp; call squeezepp_B; call (: true); 1: by conseq />.
by wp; call (: true); [by conseq /> | wp; call (: true); [by conseq /> | auto]].
qed.

lemma RO_rhopp_get_ll : islossless RO_rhopp.RO.get.
proof. by islossless; apply dlist_ll; apply W8.dword_ll. qed.

lemma sign3_ll : islossless MLDSA_RO_DS3(RoutedH, DS2.RO2.RO).sign.
proof.
proc; seq 20 : true => //; last by if; [call sigEncode_ll | ].
while true (kappa_max - kappa).
+ move=> z; wp; call sib_XC_ll; call hctpad_ll; wp; call (emask_ll RO_v.RO RO_v_get_ll).
  by auto => /#.
wp; call (Squeeze_ll RO_rhopp.RO RO_rhopp_get_ll); call (: true);
  1: by auto => />; rewrite /dbytes64; apply dmap_ll; apply dlist_ll; apply W8.dword_ll.
wp; call expandA_ll; wp; call (: true).
+ while true (kvec - i); 1: by move=> z; auto => /#.
  wp; while true (kvec - i); 1: by move=> z; auto => /#.
  by wp; while true (lvec - i); [by move=> z; auto => /# | auto => /#].
by auto => />; smt(drnd_ll).
qed.

hoare verify3_B : MLDSA_RO_DS3(RoutedH, DS2.RO2.RO).verify :
  bad4 RoutedH.tr RO_rest.RO.m RO_seed.RO.m RO_S.RO.m RO_rhopp.RO.m
  ==> bad4 RoutedH.tr RO_rest.RO.m RO_seed.RO.m RO_S.RO.m RO_rhopp.RO.m.
proof.
proc; seq 4 : (bad4 RoutedH.tr RO_rest.RO.m RO_seed.RO.m RO_S.RO.m RO_rhopp.RO.m).
+ by call (: true); [by conseq /> | call (: true); [by conseq /> | auto]].
if; 2: by auto.
wp; call (: true); 1: by conseq />.
wp; call (: true); 1: by conseq />.
call (: true); 1: by conseq />.
call (: true); 1: by conseq />.
by call (: true); [by conseq /> | auto].
qed.

(*************** mapbad in G3: H_mu and H_ct outputs cost p512 each ****************)

lemma mapbad_get4 t m4 m5 k v : mapbad t m4.[k <- v] m5 => mapbad t m4 m5 \/ v = t.
proof.
rewrite /mapbad => -[[x hx] | [x y [hx hy]]].
+ case: (x = k) => [->> | hne]; 1: by right; move: hx; rewrite get_set_sameE /=.
  by left; left; exists x; move: hx; rewrite get_set_neqE.
by left; right; exists x y.
qed.

lemma mapbad_get5 t m4 m5 k v :
  mapbad t m4 m5.[k <- v] => mapbad t m4 m5 \/ BytesCT.to_list v = Bytes64.to_list t.
proof.
rewrite /mapbad => -[[x hx] | [x y [hx hy]]]; 1: by left; left; exists x.
case: (x = k) => [->> | hne]; 1: by right; move: hx; rewrite get_set_sameE /= => ->.
by left; right; exists x y; move: hx; rewrite get_set_neqE.
qed.

ehoare RO4_mb (t0 : Bytes64.t) (c : real) : DS5.RO4.RO.get :
  (0%r <= c) `|` (b2r (mapbad t0 DS5.RO4.RO.m DS5.RO5.RO.m) + p512 + c)%xr
  ==> (b2r (mapbad t0 DS5.RO4.RO.m DS5.RO5.RO.m) + c)%xr.
proof.
proc; auto => &hr /=; apply xle_cxr_r => hc.
apply (xle_trans (Ep dbytes64 (fun r =>
         (b2r (mapbad t0 DS5.RO4.RO.m{hr} DS5.RO5.RO.m{hr} \/ r = t0) + c)%xr))).
+ by apply le_Ep => r _ /=; case: (x{hr} \notin DS5.RO4.RO.m{hr}) => hx /=;
     apply le_pos; smt(mapbad_get4).
apply (xle_trans _ _ _ (Ep_hitE dbytes64 (mapbad t0 DS5.RO4.RO.m{hr} DS5.RO5.RO.m{hr}) true
         (fun r => mapbad t0 DS5.RO4.RO.m{hr} DS5.RO5.RO.m{hr} \/ r = t0) (fun r => r = t0)
         c p512 _ _ hc _)).
+ by rewrite /dbytes64; apply dmap_ll; apply dlist_ll; apply W8.dword_ll.
+ by rewrite (mu_eq _ _ (pred1 t0)) 1:/# mu1_dbytes64 mu1_dblock.
+ by move=> r0 /=.
by rewrite /b2r /=.
qed.

ehoare RO5_mb (t0 : Bytes64.t) (c : real) : DS5.RO5.RO.get :
  (0%r <= c) `|` (b2r (mapbad t0 DS5.RO4.RO.m DS5.RO5.RO.m) + p512 + c)%xr
  ==> (b2r (mapbad t0 DS5.RO4.RO.m DS5.RO5.RO.m) + c)%xr.
proof.
proc; auto => &hr /=; apply xle_cxr_r => hc.
apply (xle_trans (Ep dbytesCT (fun r =>
         (b2r (mapbad t0 DS5.RO4.RO.m{hr} DS5.RO5.RO.m{hr} \/
               BytesCT.to_list r = Bytes64.to_list t0) + c)%xr))).
+ by apply le_Ep => r _ /=; case: (x{hr} \notin DS5.RO5.RO.m{hr}) => hx /=;
     apply le_pos; smt(mapbad_get5).
apply (xle_trans _ _ _ (Ep_hitE dbytesCT (mapbad t0 DS5.RO4.RO.m{hr} DS5.RO5.RO.m{hr}) true
         (fun r => mapbad t0 DS5.RO4.RO.m{hr} DS5.RO5.RO.m{hr} \/
                   BytesCT.to_list r = Bytes64.to_list t0)
         (fun r => BytesCT.to_list r = Bytes64.to_list t0) c p512 _ _ hc _)).
+ by rewrite /dbytesCT; apply dmap_ll; apply dlist_ll; apply W8.dword_ll.
+ by apply mu_ct_tr.
+ by move=> r0 /=.
by rewrite /b2r /=.
qed.

ehoare RO_seed_e (v : xreal) : RO_seed.RO.get : v ==> v.
proof.
by proc; auto => &hr; rewrite (eq_Ep _ _ (fun _ => v)) 1:/# EpC /dblock (dlist_ll W8.dword 64 W8.dword_ll).
qed.

ehoare RO_S_e (v : xreal) : RO_S.RO.get : v ==> v.
proof.
by proc; auto => &hr; rewrite (eq_Ep _ _ (fun _ => v)) 1:/# EpC /dblock (dlist_ll W8.dword 64 W8.dword_ll).
qed.

ehoare RO_rhopp_e (v : xreal) : RO_rhopp.RO.get : v ==> v.
proof.
by proc; auto => &hr; rewrite (eq_Ep _ _ (fun _ => v)) 1:/# EpC /dblock (dlist_ll W8.dword 64 W8.dword_ll).
qed.

ehoare RO_v_e (v : xreal) : RO_v.RO.get : v ==> v.
proof.
by proc; auto => &hr; rewrite (eq_Ep _ _ (fun _ => v)) 1:/# EpC /dblock (dlist_ll W8.dword 64 W8.dword_ll).
qed.

ehoare RO_rest_e (v : xreal) : RO_rest.RO.get : v ==> v.
proof.
by proc; auto => &hr; rewrite (eq_Ep _ _ (fun _ => v)) 1:/# EpC /dblock (dlist_ll W8.dword 64 W8.dword_ll).
qed.

ehoare XC_e (v : xreal) : DS5.RO2.RO.get : v ==> v.
proof.
by proc; auto => &hr; rewrite (eq_Ep _ _ (fun _ => v)) 1:/# EpC /dblock (dlist_ll W8.dword 64 W8.dword_ll).
qed.

ehoare Htr_e (v : xreal) : DS5.RO3.RO.get : v ==> v.
proof.
have hll : is_lossless dbytes64 by rewrite /dbytes64; apply dmap_ll; apply dlist_ll; apply W8.dword_ll.
by proc; auto => &hr; rewrite (eq_Ep _ _ (fun _ => v)) 1:/# EpC hll.
qed.

ehoare pad_get_e (v : xreal) : RO_pad.RO.get : v ==> v.
proof.
by proc; auto => &hr; rewrite (eq_Ep _ _ (fun _ => v)) 1:/# EpC
     (dlist_ll W8.dword (64 - lambda %/ 4) W8.dword_ll).
qed.

ehoare pad_sample_e (v : xreal) : RO_pad.RO.sample : v ==> v.
proof.
by proc; inline *; auto => &hr; rewrite (eq_Ep _ _ (fun _ => v)) 1:/# EpC
     (dlist_ll W8.dword (64 - lambda %/ 4) W8.dword_ll).
qed.

ehoare hctpad_mb (t0 : Bytes64.t) (c : real) : HctPad.get :
  (0%r <= c) `|` (b2r (mapbad t0 DS5.RO4.RO.m DS5.RO5.RO.m) + p512 + c)%xr
  ==> (b2r (mapbad t0 DS5.RO4.RO.m DS5.RO5.RO.m) + c)%xr.
proof.
proc; seq 1 : (b2r (mapbad t0 DS5.RO4.RO.m DS5.RO5.RO.m) + c)%xr; 1: by call (RO5_mb t0 c).
exlim DS5.RO4.RO.m, DS5.RO5.RO.m => m4 m5.
call /(fun y => (DS5.RO4.RO.m = m4 /\ DS5.RO5.RO.m = m5) `|` y)
     (pad_sample_e (b2r (mapbad t0 m4 m5) + c)%xr).
+ by move=> &hr; apply xle_cxr_r => -[-> ->].
by skip => &hr; apply xle_cxr => -[<- <-].
qed.

(* An adversary query costs p512 when it reaches H_mu or H_ct; tr is set and stays *)
ehoare get_mb (t0 : Bytes64.t) (c : real) : RoutedH.get :
  (RoutedH.trset /\ RoutedH.tr = t0 /\ 0%r <= c) `|`
    (b2r (mapbad t0 DS5.RO4.RO.m DS5.RO5.RO.m) + p512 + c)%xr
  ==> (RoutedH.trset /\ RoutedH.tr = t0) `|` (b2r (mapbad t0 DS5.RO4.RO.m DS5.RO5.RO.m) + c)%xr.
proof.
proc; seq 1 : ((RoutedH.trset /\ RoutedH.tr = t0 /\ 0%r <= c) `|`
               (b2r (mapbad t0 DS5.RO4.RO.m DS5.RO5.RO.m) + p512 + c)%xr); 1: by auto.
if.
+ if.
  + wp; call /(fun y => (RoutedH.trset /\ RoutedH.tr = t0) `|` y) (RO4_mb t0 c).
    by skip => &hr; rewrite !cxrA; apply xle_cxr => />.
  exlim DS5.RO4.RO.m, DS5.RO5.RO.m => m4 m5.
  call /(fun y => (RoutedH.trset /\ RoutedH.tr = t0 /\ DS5.RO4.RO.m = m4 /\ DS5.RO5.RO.m = m5 /\
                   0%r <= c) `|` y)
       (RO_rest_e (b2r (mapbad t0 m4 m5) + c)%xr).
  + by move=> &hr; apply xle_cxr => />.
  by skip => &hr; rewrite !cxrA; apply xle_cxr => /> *; apply le_pos; smt(RealOrder.expr_ge0).
if.
+ if.
  + seq 1 : ((RoutedH.trset /\ RoutedH.tr = t0) `|`
             (b2r (mapbad t0 DS5.RO4.RO.m DS5.RO5.RO.m) + c)%xr).
    + call /(fun y => (RoutedH.trset /\ RoutedH.tr = t0) `|` y) (RO5_mb t0 c).
      by skip => &hr; rewrite !cxrA; apply xle_cxr => />.
    exlim DS5.RO4.RO.m, DS5.RO5.RO.m => m4 m5; wp.
    call /(fun y => (RoutedH.trset /\ RoutedH.tr = t0 /\ DS5.RO4.RO.m = m4 /\ DS5.RO5.RO.m = m5) `|` y)
         (pad_get_e (b2r (mapbad t0 m4 m5) + c)%xr).
    + by move=> &hr; apply xle_cxr => />.
    by skip => &hr; rewrite !cxrA; apply xle_cxr => />.
  exlim DS5.RO4.RO.m, DS5.RO5.RO.m => m4 m5.
  call /(fun y => (RoutedH.trset /\ RoutedH.tr = t0 /\ DS5.RO4.RO.m = m4 /\ DS5.RO5.RO.m = m5 /\
                   0%r <= c) `|` y)
       (RO_rest_e (b2r (mapbad t0 m4 m5) + c)%xr).
  + by move=> &hr; apply xle_cxr => />.
  by skip => &hr; rewrite !cxrA; apply xle_cxr => /> *; apply le_pos; smt(RealOrder.expr_ge0).
if.
+ exlim DS5.RO4.RO.m, DS5.RO5.RO.m => m4 m5.
  call /(fun y => (RoutedH.trset /\ RoutedH.tr = t0 /\ DS5.RO4.RO.m = m4 /\ DS5.RO5.RO.m = m5 /\
                   0%r <= c) `|` y)
       (XC_e (b2r (mapbad t0 m4 m5) + c)%xr).
  + by move=> &hr; apply xle_cxr => />.
  by skip => &hr; rewrite !cxrA; apply xle_cxr => /> *; apply le_pos; smt(RealOrder.expr_ge0).
if.
+ seq 2 : ((RoutedH.trset /\ RoutedH.tr = t0) `|`
           (b2r (mapbad t0 DS5.RO4.RO.m DS5.RO5.RO.m) + c)%xr).
  + exlim DS5.RO4.RO.m, DS5.RO5.RO.m => m4 m5; wp.
    call /(fun y => (RoutedH.trset /\ RoutedH.tr = t0 /\ DS5.RO4.RO.m = m4 /\ DS5.RO5.RO.m = m5 /\
                     0%r <= c) `|` y)
         (Htr_e (b2r (mapbad t0 m4 m5) + c)%xr).
    + by move=> &hr; apply xle_cxr => />.
    by skip => &hr; rewrite !cxrA; apply xle_cxr => /> *; apply le_pos; smt(RealOrder.expr_ge0).
  if; 1: by auto => &hr; apply xle_cxr => />.
  by skip => &hr; rewrite cxrA; apply xle_cxr => />.
exlim DS5.RO4.RO.m, DS5.RO5.RO.m => m4 m5.
call /(fun y => (RoutedH.trset /\ RoutedH.tr = t0 /\ DS5.RO4.RO.m = m4 /\ DS5.RO5.RO.m = m5 /\
                 0%r <= c) `|` y)
     (RO_rest_e (b2r (mapbad t0 m4 m5) + c)%xr).
+ by move=> &hr; apply xle_cxr => />.
by skip => &hr; rewrite !cxrA; apply xle_cxr => /> *; apply le_pos; smt(RealOrder.expr_ge0).
qed.

(* One signing call costs p512 for H_mu and p512 per iteration for H_ct *)
ehoare sign3_mb (tr0 : Bytes64.t) (k : real) : MLDSA_RO_DS3(RoutedH, DS2.RO2.RO).sign :
  (RoutedH.trset /\ RoutedH.tr = tr0 /\ 0%r <= k) `|`
    (b2r (mapbad tr0 DS5.RO4.RO.m DS5.RO5.RO.m) + (1 + kappa_max)%r * p512 + k)%xr
  ==> (RoutedH.trset /\ RoutedH.tr = tr0) `|` (b2r (mapbad tr0 DS5.RO4.RO.m DS5.RO5.RO.m) + k)%xr.
proof.
proc; seq 19 : ((RoutedH.trset /\ RoutedH.tr = tr0 /\ 0%r <= k /\ kappa = 0) `|`
                (b2r (mapbad tr0 DS5.RO4.RO.m DS5.RO5.RO.m) + kappa_max%r * p512 + k)%xr).
+ seq 16 : ((RoutedH.trset /\ RoutedH.tr = tr0 /\ 0%r <= k) `|`
            (b2r (mapbad tr0 DS5.RO4.RO.m DS5.RO5.RO.m) + kappa_max%r * p512 + k)%xr);
    2: by auto => &hr; apply xle_cxr => />.
  seq 15 : ((RoutedH.trset /\ RoutedH.tr = tr0 /\ 0%r <= k) `|`
            (b2r (mapbad tr0 DS5.RO4.RO.m DS5.RO5.RO.m) + kappa_max%r * p512 + k)%xr).
  - seq 12 : ((RoutedH.trset /\ RoutedH.tr = tr0 /\ 0%r <= k) `|`
              (b2r (mapbad tr0 DS5.RO4.RO.m DS5.RO5.RO.m) + (1 + kappa_max)%r * p512 + k)%xr).
    * exlim DS5.RO4.RO.m, DS5.RO5.RO.m => m4 m5.
      call /(fun y => (DS5.RO4.RO.m = m4 /\ DS5.RO5.RO.m = m5 /\ RoutedH.trset /\ RoutedH.tr = tr0) `|` y)
           (ExpandA_e ((0%r <= k) `|`
                       (b2r (mapbad tr0 m4 m5) + (1 + kappa_max)%r * p512 + k)%xr)).
      + by move=> &hr; rewrite cxrA; apply xle_cxr => />.
      wp; call /(fun y => (DS5.RO4.RO.m = m4 /\ DS5.RO5.RO.m = m5 /\ RoutedH.trset /\ RoutedH.tr = tr0) `|` y)
           (skDecode_e ((0%r <= k) `|`
                        (b2r (mapbad tr0 m4 m5) + (1 + kappa_max)%r * p512 + k)%xr)).
      by auto => &hr; rewrite EpC drnd_ll smul1m; apply xle_cxr => />.
    call /(fun y => (RoutedH.trset /\ RoutedH.tr = tr0 /\ 0%r <= k) `|` y)
         (RO4_mb tr0 (kappa_max%r * p512 + k)).
    * by move=> &hr; apply xle_cxr => /> *; apply le_pos; smt(kappa_max_bnd).
    wp; skip => &hr; rewrite cxrA; apply xle_cxr => /> *.
    have hp : 0%r <= p512 by smt(RealOrder.expr_ge0).
    by split; [smt(RealOrder.mulr_ge0 kappa_max_bnd) | apply le_pos; rewrite fromintD; smt(kappa_max_bnd)].
  exlim DS5.RO4.RO.m, DS5.RO5.RO.m => m4 m5.
  call /(fun y => (DS5.RO4.RO.m = m4 /\ DS5.RO5.RO.m = m5 /\ RoutedH.trset /\ RoutedH.tr = tr0 /\
                   0%r <= k) `|` y)
       (Squeeze_e RO_rhopp.RO (b2r (mapbad tr0 m4 m5) + kappa_max%r * p512 + k)%xr RO_rhopp_e).
  - by move=> &hr; apply xle_cxr => />.
  by skip => &hr; rewrite cxrA; apply xle_cxr => />.
seq 1 : ((RoutedH.trset /\ RoutedH.tr = tr0 /\ 0%r <= k) `|`
         (b2r (mapbad tr0 DS5.RO4.RO.m DS5.RO5.RO.m) + k)%xr).
+ while ((RoutedH.trset /\ RoutedH.tr = tr0 /\ 0%r <= k /\ 0 <= kappa) `|`
         (b2r (mapbad tr0 DS5.RO4.RO.m DS5.RO5.RO.m) + (max 0 (kappa_max - kappa))%r * p512 + k)%xr).
  - by move=> &hr; rewrite cxrA; apply xle_cxr => /> *; apply le_pos; smt(RealOrder.expr_ge0).
  - exlim kappa => kap.
    seq 3 : ((RoutedH.trset /\ RoutedH.tr = tr0 /\ 0%r <= k /\ kappa = kap /\ 0 <= kap /\
              kap < kappa_max) `|`
             (b2r (mapbad tr0 DS5.RO4.RO.m DS5.RO5.RO.m) + (max 0 (kappa_max - kap))%r * p512 + k)%xr).
    * exlim DS5.RO4.RO.m, DS5.RO5.RO.m => m4 m5; wp.
      call /(fun y => (DS5.RO4.RO.m = m4 /\ DS5.RO5.RO.m = m5 /\ RoutedH.trset /\ RoutedH.tr = tr0 /\
                       0%r <= k /\ kappa = kap /\ 0 <= kap /\ kap < kappa_max) `|` y)
           (ExpandMask_e RO_v.RO (b2r (mapbad tr0 m4 m5) + (max 0 (kappa_max - kap))%r * p512 + k)%xr
                         RO_v_e).
      + by move=> &hr; apply xle_cxr => />.
      by skip => &hr; rewrite !cxrA; apply xle_cxr => /> *; smt().
    seq 1 : ((RoutedH.trset /\ RoutedH.tr = tr0 /\ 0%r <= k /\ kappa = kap /\ 0 <= kap /\
              kap < kappa_max) `|`
             (b2r (mapbad tr0 DS5.RO4.RO.m DS5.RO5.RO.m) +
              (max 0 (kappa_max - (kap + 1)))%r * p512 + k)%xr).
    * call /(fun y => (RoutedH.trset /\ RoutedH.tr = tr0 /\ 0%r <= k /\ kappa = kap /\ 0 <= kap /\
                       kap < kappa_max) `|` y)
           (hctpad_mb tr0 ((max 0 (kappa_max - (kap + 1)))%r * p512 + k)).
      + by move=> &hr; apply xle_cxr => /> *; apply le_pos; smt().
      skip => &hr; rewrite cxrA; apply xle_cxr => /> *.
      have hp : 0%r <= p512 by smt(RealOrder.expr_ge0).
      have -> : max 0 (kappa_max - kappa{hr}) = 1 + max 0 (kappa_max - (kappa{hr} + 1)) by smt().
      by split; [smt(RealOrder.mulr_ge0) | apply le_pos; rewrite fromintD; smt()].
    exlim DS5.RO4.RO.m, DS5.RO5.RO.m => m4 m5; wp.
    call /(fun y => (DS5.RO4.RO.m = m4 /\ DS5.RO5.RO.m = m5 /\ RoutedH.trset /\ RoutedH.tr = tr0 /\
                     0%r <= k /\ kappa = kap /\ 0 <= kap /\ kap < kappa_max) `|` y)
         (SampleInBall_e DS5.RO2.RO
            (b2r (mapbad tr0 m4 m5) + (max 0 (kappa_max - (kap + 1)))%r * p512 + k)%xr XC_e).
    * move=> &hr /=; apply xle_cxr_r => /> *.
      by apply xle_cxr_l; smt().
    by skip => &hr; rewrite cxrA; apply xle_cxr => />.
  by skip => &hr; apply xle_cxr => /> *; apply le_pos; smt(RealOrder.expr_ge0 kappa_max_bnd).
if; 2: by skip => &hr; rewrite cxrA; apply xle_cxr => />.
exlim DS5.RO4.RO.m, DS5.RO5.RO.m => m4 m5.
call /(fun y => (DS5.RO4.RO.m = m4 /\ DS5.RO5.RO.m = m5 /\ RoutedH.trset /\ RoutedH.tr = tr0) `|` y)
     (sigEncode_e (b2r (mapbad tr0 m4 m5) + k)%xr).
+ by move=> &hr; apply xle_cxr => />.
by skip => &hr; rewrite !cxrA; apply xle_cxr => />.
qed.

(* Verification costs p512 for H_mu and p512 for H_ct *)
ehoare verify3_mb (tr0 : Bytes64.t) : MLDSA_RO_DS3(RoutedH, DS2.RO2.RO).verify :
  (RoutedH.trset /\ RoutedH.tr = tr0) `|`
    (b2r (mapbad tr0 DS5.RO4.RO.m DS5.RO5.RO.m) + 2%r * p512)%xr
  ==> (mapbad RoutedH.tr DS5.RO4.RO.m DS5.RO5.RO.m)%xr.
proof.
proc; seq 4 : ((RoutedH.trset /\ RoutedH.tr = tr0) `|`
               (b2r (mapbad tr0 DS5.RO4.RO.m DS5.RO5.RO.m) + 2%r * p512)%xr).
+ exlim DS5.RO4.RO.m, DS5.RO5.RO.m => m4 m5.
  call /(fun y => (DS5.RO4.RO.m = m4 /\ DS5.RO5.RO.m = m5 /\ RoutedH.trset /\ RoutedH.tr = tr0) `|` y)
       (sigDecode_e (b2r (mapbad tr0 m4 m5) + 2%r * p512)%xr).
  + by move=> &hr; apply xle_cxr => />.
  call /(fun y => (DS5.RO4.RO.m = m4 /\ DS5.RO5.RO.m = m5 /\ RoutedH.trset /\ RoutedH.tr = tr0) `|` y)
       (pkDecode_e (b2r (mapbad tr0 m4 m5) + 2%r * p512)%xr).
  by auto => &hr; rewrite ?cxrA; apply xle_cxr => />.
if; 2: by skip => &hr; rewrite cxrA; apply xle_cxr_r => /> *; apply le_pos; smt(RealOrder.expr_ge0).
seq 2 : ((RoutedH.trset /\ RoutedH.tr = tr0) `|`
         (b2r (mapbad tr0 DS5.RO4.RO.m DS5.RO5.RO.m) + 2%r * p512)%xr).
+ exlim DS5.RO4.RO.m, DS5.RO5.RO.m => m4 m5.
  call /(fun y => (DS5.RO4.RO.m = m4 /\ DS5.RO5.RO.m = m5 /\ RoutedH.trset /\ RoutedH.tr = tr0) `|` y)
       (Htr_e (b2r (mapbad tr0 m4 m5) + 2%r * p512)%xr).
  + by move=> &hr; apply xle_cxr => />.
  call /(fun y => (DS5.RO4.RO.m = m4 /\ DS5.RO5.RO.m = m5 /\ RoutedH.trset /\ RoutedH.tr = tr0) `|` y)
       (ExpandA_e (b2r (mapbad tr0 m4 m5) + 2%r * p512)%xr).
  by skip => &hr; rewrite !cxrA; apply xle_cxr => />.
seq 1 : ((RoutedH.trset /\ RoutedH.tr = tr0) `|`
         (b2r (mapbad tr0 DS5.RO4.RO.m DS5.RO5.RO.m) + p512)%xr).
+ call /(fun y => (RoutedH.trset /\ RoutedH.tr = tr0) `|` y) (RO4_mb tr0 p512).
  skip => &hr; rewrite cxrA; apply xle_cxr => /> *.
  by split; [smt(RealOrder.expr_ge0) | apply le_pos; smt()].
seq 3 : ((RoutedH.trset /\ RoutedH.tr = tr0) `|`
         (b2r (mapbad tr0 DS5.RO4.RO.m DS5.RO5.RO.m) + p512)%xr).
+ exlim DS5.RO4.RO.m, DS5.RO5.RO.m => m4 m5; wp.
  call /(fun y => (DS5.RO4.RO.m = m4 /\ DS5.RO5.RO.m = m5 /\ RoutedH.trset /\ RoutedH.tr = tr0) `|` y)
       (SampleInBall_e DS5.RO2.RO (b2r (mapbad tr0 m4 m5) + p512)%xr XC_e).
  + by move=> &hr; apply xle_cxr => />.
  by skip => &hr; rewrite cxrA; apply xle_cxr => />.
wp; call /(fun y => (RoutedH.trset /\ RoutedH.tr = tr0) `|` y) (hctpad_mb tr0 0%r).
+ by move=> &hr; apply xle_cxr_r => /> *; apply le_pos; smt().
by skip => &hr; rewrite cxrA; apply xle_cxr => />.
qed.

(* Key generation sets tr and leaves H_mu and H_ct empty *)
ehoare gettr_mb (v : xreal) : RoutedH.get :
  (!RoutedH.trset /\ DS5.RO4.RO.m = empty /\ DS5.RO5.RO.m = empty /\ size x.`1 = pk_bytes /\
   x.`2 = 0) `|` v
  ==> (RoutedH.trset /\ DS5.RO4.RO.m = empty /\ DS5.RO5.RO.m = empty) `|` v.
proof.
proc; seq 1 : ((!RoutedH.trset /\ DS5.RO4.RO.m = empty /\ DS5.RO5.RO.m = empty /\
                size x.`1 = pk_bytes /\ x.`2 = 0) `|` v); 1: by auto.
rcondf 1; 1: by auto => />.
do 2! (rcondf 1; 1: by auto => /> *; have /= H := param_sets; smt(pk_len_nrel)).
rcondt 1; 1: by auto => />.
rcondt 3; 1: by inline *; auto.
by wp; call /(fun y => (DS5.RO4.RO.m = empty /\ DS5.RO5.RO.m = empty) `|` y) (Htr_e v);
   skip => &hr; apply xle_cxr => />.
qed.

ehoare pksq_mb (v : xreal) : Squeeze(RoutedH).squeeze :
  (!RoutedH.trset /\ DS5.RO4.RO.m = empty /\ DS5.RO5.RO.m = empty /\ size x = pk_bytes /\
   len = 64) `|` v
  ==> (RoutedH.trset /\ DS5.RO4.RO.m = empty /\ DS5.RO5.RO.m = empty) `|` v.
proof.
proc; seq 2 : ((!RoutedH.trset /\ DS5.RO4.RO.m = empty /\ DS5.RO5.RO.m = empty /\
                size x = pk_bytes /\ len = 64 /\ j = 0) `|` v); 1: by auto.
rcondt 1; 1: by auto.
seq 3 : ((RoutedH.trset /\ DS5.RO4.RO.m = empty /\ DS5.RO5.RO.m = empty /\ j = 1 /\ len = 64) `|` v).
+ wp; call /(fun y => (len = 64 /\ j = 0) `|` y) (gettr_mb v).
  - by move=> &hr; rewrite cxrA; apply xle_cxr => />.
  by skip => &hr; rewrite cxrA; apply xle_cxr => />.
rcondf 1; 1: by auto.
by skip => &hr; apply xle_cxr => />.
qed.

ehoare keygen3_mb (v : xreal) : MLDSA_RO_DS3(RoutedH, DS2.RO2.RO).keygen :
  (!RoutedH.trset /\ DS5.RO4.RO.m = empty /\ DS5.RO5.RO.m = empty) `|` v
  ==> (RoutedH.trset /\ DS5.RO4.RO.m = empty /\ DS5.RO5.RO.m = empty) `|` v.
proof.
have hll : is_lossless dxi by rewrite /dxi; apply dmap_ll; apply dlist_ll; apply W8.dword_ll.
proc; wp; call /(fun y => (RoutedH.trset /\ DS5.RO4.RO.m = empty /\ DS5.RO5.RO.m = empty) `|` y)
              (skEncode_e v).
wp; call (pksq_mb v).
call /(fun y => (!RoutedH.trset /\ DS5.RO4.RO.m = empty /\ DS5.RO5.RO.m = empty) `|` y) (pkEncode_e v).
+ by move=> &hr /=; have /= := key_sizes; smt().
wp; call /(fun y => (!RoutedH.trset /\ DS5.RO4.RO.m = empty /\ DS5.RO5.RO.m = empty) `|` y)
         (ExpandS_e RO_S.RO v RO_S_e).
call /(fun y => (!RoutedH.trset /\ DS5.RO4.RO.m = empty /\ DS5.RO5.RO.m = empty) `|` y) (ExpandA_e v).
wp; call /(fun y => (!RoutedH.trset /\ DS5.RO4.RO.m = empty /\ DS5.RO5.RO.m = empty) `|` y)
         (Squeeze_e RO_seed.RO v RO_seed_e).
by wp; inline *; auto => &hr; rewrite EpC hll smul1m.
qed.

(* Remaining budget: p512 per SHAKE256 query, p512 per H_mu query and per signing
   iteration, 2 * p512 for the final verification. Zero once a query bound is exceeded. *)
op potm (qH qS ch cs : int) (ts : bool) (t : Bytes64.t)
        (m4 : (Bytes64.t * W8.t list, Bytes64.t) fmap)
        (m5 : (Bytes64.t * BytesW1.t, BytesCT.t) fmap) : xreal =
  if ch <= qH /\ cs <= qS
  then ts `|` (b2r (mapbad t m4 m5) + (qH - ch)%r * p512 +
               (qS - cs)%r * ((1 + kappa_max)%r * p512) + 2%r * p512)%xr
  else 0%xr.

ehoare CountH_get_mb (qH qS : int) : CountH(RoutedH).get :
  potm qH qS CountH.c CountS.c RoutedH.trset RoutedH.tr DS5.RO4.RO.m DS5.RO5.RO.m
  ==> potm qH qS CountH.c CountS.c RoutedH.trset RoutedH.tr DS5.RO4.RO.m DS5.RO5.RO.m.
proof.
proc; exlim RoutedH.tr, CountH.c, CountS.c => t0 ch cs.
call /(fun y => (CountH.c = ch + 1 /\ CountS.c = cs) `|`
                (if ch + 1 <= qH /\ cs <= qS then y else 0%xr))
     (get_mb t0 ((qH - (ch + 1))%r * p512 + (qS - cs)%r * ((1 + kappa_max)%r * p512) +
                 2%r * p512)).
+ move=> &hr; apply xle_cxr_r => [#] hch hcs; rewrite /potm hch hcs.
  case: (ch + 1 <= qH /\ cs <= qS) => hok //=.
  by apply xle_cxr => /> *; apply le_pos; smt(kappa_max_bnd).
wp; skip => &hr /=; apply xle_cxr_r => [#] ->> ->> ->>; rewrite /potm.
case: (CountH.c{hr} + 1 <= qH /\ CountS.c{hr} <= qS) => hok /=; last by apply xle0x.
have -> /= : CountH.c{hr} <= qH /\ CountS.c{hr} <= qS by smt().
apply xle_cxr => /> hts; have hp : 0%r <= p512 by smt(RealOrder.expr_ge0).
by split; [smt(RealOrder.mulr_ge0 kappa_max_bnd) | apply le_pos; smt(kappa_max_bnd)].
qed.

ehoare RO2_get_potm (qH qS : int) : DS2.RO2.RO.get :
  potm qH qS CountH.c CountS.c RoutedH.trset RoutedH.tr DS5.RO4.RO.m DS5.RO5.RO.m
  ==> potm qH qS CountH.c CountS.c RoutedH.trset RoutedH.tr DS5.RO4.RO.m DS5.RO5.RO.m.
proof. by proc; auto => &hr /=; rewrite EpC W8.dword_ll. qed.

section.

declare module A <: DS2.Adversary {
  -DS2.RO1.RO, -DS2.RO2.RO, -DS2.EUF_CMA, -XOFA_O, -XOFS_O, -MLDSA_RO_DS1, -RoutedH,
  -DS5.RO2.RO, -DS5.RO3.RO, -DS5.RO4.RO, -DS5.RO5.RO, -RO_rest.RO, -RO_pad.RO,
  -RO_seed.RO, -RO_S.RO, -RO_rhopp.RO, -RO_v.RO, -CountH, -CountS }.

lemma hop4_uptobad &m :
  (forall (H1 <: DS2.POracle1 {-A}) (H2 <: DS2.POracle2 {-A}) (O <: DS2.SOracle {-A}),
     islossless H1.get => islossless H2.get => islossless O.sign =>
     islossless A(H1, H2, O).forge) =>
  Pr[DS2.EUF_CMA(RoutedH, DS2.RO2.RO, MLDSA_RO_DS2, A).main() @ &m :
       res \/ mapbad RoutedH.tr DS5.RO4.RO.m DS5.RO5.RO.m] <=
  Pr[DS2.EUF_CMA(RoutedH, DS2.RO2.RO, MLDSA_RO_DS3, A).main() @ &m :
       res \/ mapbad RoutedH.tr DS5.RO4.RO.m DS5.RO5.RO.m \/
       bad4 RoutedH.tr RO_rest.RO.m RO_seed.RO.m RO_S.RO.m RO_rhopp.RO.m].
proof.
move=> A_ll.
byequiv (: ={glob A, glob XOFA_O, glob XOFS_O} ==>
           res{1} \/ mapbad RoutedH.tr{1} DS5.RO4.RO.m{1} DS5.RO5.RO.m{1} =>
           res{2} \/ mapbad RoutedH.tr{2} DS5.RO4.RO.m{2} DS5.RO5.RO.m{2} \/
           bad4 RoutedH.tr{2} RO_rest.RO.m{2} RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2}) => //.
proc; seq 4 4 : (={glob A, glob DS2.RO2.RO, glob XOFA_O, pk, DS2.EUF_CMA.sk, DS2.EUF_CMA.qs} /\
                 ={RoutedH.tr, RoutedH.trset, RO_pad.RO.m, DS5.RO2.RO.m, DS5.RO3.RO.m, DS5.RO4.RO.m,
                   DS5.RO5.RO.m} /\
                 RoutedH.trset{2} /\ hshape RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} RO_v.RO.m{2} /\
                 !bad4 RoutedH.tr{2} RO_rest.RO.m{2} RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} /\
                 inv4 RO_rest.RO.m{1} RO_rest.RO.m{2} RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2}
                   RO_v.RO.m{2}).
+ by call keygen4; inline *; auto => />.
seq 1 1 : (={pk} /\ RoutedH.trset{2} /\
           (!bad4 RoutedH.tr{2} RO_rest.RO.m{2} RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} =>
            ={m, s, glob DS2.RO2.RO, glob XOFA_O, DS2.EUF_CMA.qs} /\
            ={RoutedH.tr, RoutedH.trset, RO_pad.RO.m, DS5.RO2.RO.m, DS5.RO3.RO.m, DS5.RO4.RO.m,
              DS5.RO5.RO.m})).
+ call (: bad4 RoutedH.tr RO_rest.RO.m RO_seed.RO.m RO_S.RO.m RO_rhopp.RO.m,
          ={glob DS2.RO2.RO, glob XOFA_O, DS2.EUF_CMA.sk, DS2.EUF_CMA.qs} /\
          ={RoutedH.tr, RoutedH.trset, RO_pad.RO.m, DS5.RO2.RO.m, DS5.RO3.RO.m, DS5.RO4.RO.m,
            DS5.RO5.RO.m} /\
          RoutedH.trset{2} /\ hshape RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2} RO_v.RO.m{2} /\
          inv4 RO_rest.RO.m{1} RO_rest.RO.m{2} RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2}
            RO_v.RO.m{2},
          RoutedH.trset{2}).
  - by move=> H1 H2 O hO h2 h1; apply (A_ll H1 H2 O).
  - by proc; call sign4; auto => />; smt().
  - by move=> &2 _; conseq (: true ==> true) => //; proc; call sign2_ll; auto.
  - by move=> _; proc;
       call (: bad4 RoutedH.tr RO_rest.RO.m RO_seed.RO.m RO_S.RO.m RO_rhopp.RO.m /\ RoutedH.trset
               ==> bad4 RoutedH.tr RO_rest.RO.m RO_seed.RO.m RO_S.RO.m RO_rhopp.RO.m /\ RoutedH.trset);
       [conseq sign3_ll sign3_B => /# | auto].
  - by proc; auto => /> /#.
  - by move=> &2 _; conseq (: true ==> true) => //; islossless; exact W8.dword_ll.
  - by move=> _; proc; auto => /> *; exact W8.dword_ll.
  - by proc*; call get4; auto => /> /#.
  - by move=> &2 _; conseq RoutedH_get_ll.
  - by move=> _; conseq RoutedH_get_ll get_B4 => /#.
  by skip => /> /#.
case (bad4 RoutedH.tr{2} RO_rest.RO.m{2} RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2}).
+ conseq (: _ ==> bad4 RoutedH.tr{2} RO_rest.RO.m{2} RO_seed.RO.m{2} RO_S.RO.m{2} RO_rhopp.RO.m{2});
    1: smt().
  call{2} (: bad4 RoutedH.tr RO_rest.RO.m RO_seed.RO.m RO_S.RO.m RO_rhopp.RO.m
             ==> bad4 RoutedH.tr RO_rest.RO.m RO_seed.RO.m RO_S.RO.m RO_rhopp.RO.m);
    1: by conseq verify2_ll verify3_B.
  by call{1} verify2_ll; skip => />.
call (: ={pk, m, sigma, glob DS2.RO2.RO, glob XOFA_O, RO_pad.RO.m, DS5.RO2.RO.m, DS5.RO3.RO.m,
          DS5.RO4.RO.m, DS5.RO5.RO.m} ==> ={res, DS5.RO4.RO.m, DS5.RO5.RO.m}); 1: by sim.
by skip => /> /#.
qed.

local ehoare CountS_sign_mb (qH qS : int) :
  CountS(DS2.EUF_CMA(RoutedH, DS2.RO2.RO, MLDSA_RO_DS3, CountA(A)).O).sign :
  potm qH qS CountH.c CountS.c RoutedH.trset RoutedH.tr DS5.RO4.RO.m DS5.RO5.RO.m
  ==> potm qH qS CountH.c CountS.c RoutedH.trset RoutedH.tr DS5.RO4.RO.m DS5.RO5.RO.m.
proof.
proc; inline DS2.EUF_CMA(RoutedH, DS2.RO2.RO, MLDSA_RO_DS3, CountA(A)).O.sign; wp.
exlim RoutedH.tr, CountH.c, CountS.c => t0 ch cs.
call /(fun y => (CountH.c = ch /\ CountS.c = cs + 1) `|`
                (if ch <= qH /\ cs + 1 <= qS then y else 0%xr))
     (sign3_mb t0 ((qH - ch)%r * p512 + (qS - (cs + 1))%r * ((1 + kappa_max)%r * p512) +
                   2%r * p512)).
+ move=> &hr; apply xle_cxr_r => [#] hch hcs; rewrite /potm hch hcs.
  case: (ch <= qH /\ cs + 1 <= qS) => hok //=.
  by apply xle_cxr => /> *; apply le_pos; smt(kappa_max_bnd).
auto => &hr /=; apply xle_cxr_r => [#] ->> ->> ->>; rewrite /potm.
case: (CountH.c{hr} <= qH /\ CountS.c{hr} + 1 <= qS) => hok /=; last by apply xle0x.
have -> /= : CountH.c{hr} <= qH /\ CountS.c{hr} <= qS by smt().
apply xle_cxr => /> hts; have hp : 0%r <= p512 by smt(RealOrder.expr_ge0).
by split; [smt(RealOrder.mulr_ge0 kappa_max_bnd) | apply le_pos; smt(kappa_max_bnd)].
qed.

local lemma mb_ok (qH qS : int) &m : 0 <= qH => 0 <= qS =>
  Pr[DS2.EUF_CMA(RoutedH, DS2.RO2.RO, MLDSA_RO_DS3, CountA(A)).main() @ &m :
     mapbad RoutedH.tr DS5.RO4.RO.m DS5.RO5.RO.m /\ CountH.c <= qH /\ CountS.c <= qS] <=
  qH%r * p512 + qS%r * ((1 + kappa_max)%r * p512) + 2%r * p512.
proof.
move=> hqH hqS; byehoare => //; last first.
+ have hp : 0%r <= p512 by smt(RealOrder.expr_ge0).
  by smt(RealOrder.mulr_ge0 kappa_max_bnd).
have hll : is_lossless dxi by rewrite /dxi; apply dmap_ll; apply dlist_ll; apply W8.dword_ll.
proc; inline MLDSA_RO_DS3(RoutedH, DS2.RO2.RO).keygen
             DS2.EUF_CMA(RoutedH, DS2.RO2.RO, MLDSA_RO_DS3, CountA(A)).A.forge.
seq 20 : ((RoutedH.trset /\ DS5.RO4.RO.m = empty /\ DS5.RO5.RO.m = empty) `|`
          (qH%r * p512 + qS%r * ((1 + kappa_max)%r * p512) + 2%r * p512)%xr).
+ wp; call /(fun y => (RoutedH.trset /\ DS5.RO4.RO.m = empty /\ DS5.RO5.RO.m = empty) `|` y)
           (skEncode_e (qH%r * p512 + qS%r * ((1 + kappa_max)%r * p512) + 2%r * p512)%xr).
  wp; call (pksq_mb (qH%r * p512 + qS%r * ((1 + kappa_max)%r * p512) + 2%r * p512)%xr).
  call /(fun y => (!RoutedH.trset /\ DS5.RO4.RO.m = empty /\ DS5.RO5.RO.m = empty) `|` y)
       (pkEncode_e (qH%r * p512 + qS%r * ((1 + kappa_max)%r * p512) + 2%r * p512)%xr).
  + by move=> &hr /=; have /= := key_sizes; smt().
  wp; call /(fun y => (!RoutedH.trset /\ DS5.RO4.RO.m = empty /\ DS5.RO5.RO.m = empty) `|` y)
           (ExpandS_e RO_S.RO (qH%r * p512 + qS%r * ((1 + kappa_max)%r * p512) +
                               2%r * p512)%xr RO_S_e).
  call /(fun y => (!RoutedH.trset /\ DS5.RO4.RO.m = empty /\ DS5.RO5.RO.m = empty) `|` y)
       (ExpandA_e (qH%r * p512 + qS%r * ((1 + kappa_max)%r * p512) + 2%r * p512)%xr).
  wp; call /(fun y => (!RoutedH.trset /\ DS5.RO4.RO.m = empty /\ DS5.RO5.RO.m = empty) `|` y)
           (Squeeze_e RO_seed.RO (qH%r * p512 + qS%r * ((1 + kappa_max)%r * p512) +
                                  2%r * p512)%xr RO_seed_e).
  by wp; inline *; auto => &hr; rewrite EpC hll smul1m.
seq 5 : (potm qH qS CountH.c CountS.c RoutedH.trset RoutedH.tr DS5.RO4.RO.m DS5.RO5.RO.m).
+ wp; call (: potm qH qS CountH.c CountS.c RoutedH.trset RoutedH.tr DS5.RO4.RO.m DS5.RO5.RO.m
              ==> potm qH qS CountH.c CountS.c RoutedH.trset RoutedH.tr DS5.RO4.RO.m DS5.RO5.RO.m).
  + proc (potm qH qS CountH.c CountS.c RoutedH.trset RoutedH.tr DS5.RO4.RO.m DS5.RO5.RO.m).
    + by move=> &hr.
    + by move=> &hr.
    + by apply (CountS_sign_mb qH qS).
    + by apply (RO2_get_potm qH qS).
    by apply (CountH_get_mb qH qS).
  auto => &hr /=; apply xle_cxr_r => [#] hts h4 h5; rewrite /potm hqH hqS /= h4 h5.
  have -> : !mapbad RoutedH.tr{hr} empty empty by rewrite /mapbad; smt(emptyE).
  by rewrite hts cxr_true /b2r /=.
exlim RoutedH.tr, CountH.c, CountS.c => t0 ch cs.
call /(fun y => (CountH.c = ch /\ CountS.c = cs) `|` (if ch <= qH /\ cs <= qS then y else 0%xr))
     (verify3_mb t0).
+ by move=> &hr; apply xle_cxr_r => [#] -> ->; case: (ch <= qH /\ cs <= qS) => hok /=.
skip => &hr /=; apply xle_cxr_r => [#] ->> ->> ->>; rewrite /potm.
case: (CountH.c{hr} <= qH /\ CountS.c{hr} <= qS) => hok //=.
apply xle_cxr => /> *; have hp : 0%r <= p512 by smt(RealOrder.expr_ge0).
have h1 : 0%r <= (qH - CountH.c{hr})%r * p512 by apply RealOrder.mulr_ge0; smt().
have h2 : 0%r <= (qS - CountS.c{hr})%r * ((1 + kappa_max)%r * p512)
  by apply RealOrder.mulr_ge0; [smt() | apply RealOrder.mulr_ge0; smt(kappa_max_bnd)].
by apply le_pos; smt().
qed.

local lemma count_ok4 (qH qS : int) &m :
  (forall (H <: DS2.POracle1 {-A, -CountH, -CountS}) (G <: DS2.POracle2 {-A, -CountH, -CountS})
          (O <: DS2.SOracle {-A, -CountH, -CountS}),
     hoare [A(CountH(H), G, CountS(O)).forge :
              CountH.c = 0 /\ CountS.c = 0 ==> CountH.c <= qH /\ CountS.c <= qS]) =>
  Pr[DS2.EUF_CMA(RoutedH, DS2.RO2.RO, MLDSA_RO_DS3, CountA(A)).main() @ &m :
     !(CountH.c <= qH /\ CountS.c <= qS)] = 0%r.
proof.
move=> A_count; byphoare => //; hoare; proc.
inline DS2.EUF_CMA(RoutedH, DS2.RO2.RO, MLDSA_RO_DS3, CountA(A)).A.forge.
call (: true); 1: by conseq />.
wp; call (A_count (<: RoutedH) (<: DS2.RO2.RO)
                  (<: DS2.EUF_CMA(RoutedH, DS2.RO2.RO, MLDSA_RO_DS3, CountA(A)).O)).
by wp; call (: true); [by conseq /> | inline *; auto].
qed.

local lemma mb_count &m :
  Pr[DS2.EUF_CMA(RoutedH, DS2.RO2.RO, MLDSA_RO_DS3, A).main() @ &m :
     mapbad RoutedH.tr DS5.RO4.RO.m DS5.RO5.RO.m] =
  Pr[DS2.EUF_CMA(RoutedH, DS2.RO2.RO, MLDSA_RO_DS3, CountA(A)).main() @ &m :
     mapbad RoutedH.tr DS5.RO4.RO.m DS5.RO5.RO.m].
proof.
byequiv (_ : ={glob A, glob XOFA_O, glob XOFS_O} ==> ={RoutedH.tr, DS5.RO4.RO.m, DS5.RO5.RO.m}) => //.
proc; inline{2} DS2.EUF_CMA(RoutedH, DS2.RO2.RO, MLDSA_RO_DS3, CountA(A)).A.forge.
call (: ={glob RoutedH, glob DS2.RO2.RO, glob XOFA_O}); 1: by sim.
wp; call (: ={glob RoutedH, glob DS2.RO2.RO, glob XOFA_O, glob RO_rhopp.RO, glob RO_v.RO,
              DS2.EUF_CMA.sk, DS2.EUF_CMA.qs}).
+ by proc; inline{2} 2; wp; sim.
+ by sim.
+ by proc*; inline{2} 1; wp; call (: ={glob RoutedH}); [by sim | auto].
by wp; call (: ={glob RoutedH, glob DS2.RO2.RO, glob XOFA_O, glob XOFS_O} ==>
               ={res, glob RoutedH, glob DS2.RO2.RO, glob XOFA_O, glob RO_rhopp.RO, glob RO_v.RO});
   [proc; sim | inline *; auto].
qed.

(* mapbad is bounded in G3: the hidden queries no longer reach H_mu or H_ct, so each H_mu or
   H_ct output comes from an adversary query or a direct scheme query *)
lemma hop4_mapbad (qH qS : int) &m : 0 <= qH => 0 <= qS =>
  (forall (H <: DS2.POracle1 {-A, -CountH, -CountS}) (G <: DS2.POracle2 {-A, -CountH, -CountS})
          (O <: DS2.SOracle {-A, -CountH, -CountS}),
     hoare [A(CountH(H), G, CountS(O)).forge :
              CountH.c = 0 /\ CountS.c = 0 ==> CountH.c <= qH /\ CountS.c <= qS]) =>
  Pr[DS2.EUF_CMA(RoutedH, DS2.RO2.RO, MLDSA_RO_DS3, A).main() @ &m :
     mapbad RoutedH.tr DS5.RO4.RO.m DS5.RO5.RO.m] <=
  (qH + qS * (1 + kappa_max) + 2)%r * p512.
proof.
move=> hqH hqS A_count; rewrite (mb_count &m).
have h4 := mb_ok qH qS &m hqH hqS.
have h5 := count_ok4 qH qS &m A_count.
have h3 : Pr[DS2.EUF_CMA(RoutedH, DS2.RO2.RO, MLDSA_RO_DS3, CountA(A)).main() @ &m :
             mapbad RoutedH.tr DS5.RO4.RO.m DS5.RO5.RO.m] <=
          Pr[DS2.EUF_CMA(RoutedH, DS2.RO2.RO, MLDSA_RO_DS3, CountA(A)).main() @ &m :
             mapbad RoutedH.tr DS5.RO4.RO.m DS5.RO5.RO.m /\ CountH.c <= qH /\ CountS.c <= qS] +
          Pr[DS2.EUF_CMA(RoutedH, DS2.RO2.RO, MLDSA_RO_DS3, CountA(A)).main() @ &m :
             !(CountH.c <= qH /\ CountS.c <= qS)].
+ rewrite Pr[mu_split (CountH.c <= qH /\ CountS.c <= qS)]; apply RealOrder.ler_add2l.
  by rewrite Pr[mu_sub].
have -> : (qH + qS * (1 + kappa_max) + 2)%r * p512 =
          qH%r * p512 + qS%r * ((1 + kappa_max)%r * p512) + 2%r * p512.
+ by rewrite !fromintD fromintM; ring.
smt().
qed.

(* Hop 4: the hidden inputs leave the routed oracle; mapbad is bounded in G3.
   bad4 is carried, not bounded in G3: there rho', K and rho'' are still outputs of the hidden
   oracles. Once these are eliminated (hop 5) they are direct samples, independent of the
   adversary's view, and bad4 is bounded by a union bound over the adversary's queries. *)
lemma hop4 (qH qS : int) &m : 0 <= qH => 0 <= qS =>
  (forall (H1 <: DS2.POracle1 {-A}) (H2 <: DS2.POracle2 {-A}) (O <: DS2.SOracle {-A}),
     islossless H1.get => islossless H2.get => islossless O.sign =>
     islossless A(H1, H2, O).forge) =>
  (forall (H <: DS2.POracle1 {-A, -CountH, -CountS}) (G <: DS2.POracle2 {-A, -CountH, -CountS})
          (O <: DS2.SOracle {-A, -CountH, -CountS}),
     hoare [A(CountH(H), G, CountS(O)).forge :
              CountH.c = 0 /\ CountS.c = 0 ==> CountH.c <= qH /\ CountS.c <= qS]) =>
  Pr[DS2.EUF_CMA(DS2.RO1.RO, DS2.RO2.RO, MLDSA_RO_DS1, A).main() @ &m : res] <=
  Pr[DS2.EUF_CMA(RoutedH, DS2.RO2.RO, MLDSA_RO_DS3, A).main() @ &m :
       res \/ bad4 RoutedH.tr RO_rest.RO.m RO_seed.RO.m RO_S.RO.m RO_rhopp.RO.m] +
  2%r * p512 + (qH + qS * (1 + kappa_max) + 2)%r * p512.
proof.
move=> hqH hqS A_ll A_count.
have h3 := hop3 A &m A_ll.
have h4 := hop4_uptobad &m A_ll.
have h5 := hop4_mapbad qH qS &m hqH hqS A_count.
have h6 : Pr[DS2.EUF_CMA(RoutedH, DS2.RO2.RO, MLDSA_RO_DS3, A).main() @ &m :
             res \/ mapbad RoutedH.tr DS5.RO4.RO.m DS5.RO5.RO.m \/
             bad4 RoutedH.tr RO_rest.RO.m RO_seed.RO.m RO_S.RO.m RO_rhopp.RO.m] <=
          Pr[DS2.EUF_CMA(RoutedH, DS2.RO2.RO, MLDSA_RO_DS3, A).main() @ &m :
             (res \/ bad4 RoutedH.tr RO_rest.RO.m RO_seed.RO.m RO_S.RO.m RO_rhopp.RO.m) \/
             mapbad RoutedH.tr DS5.RO4.RO.m DS5.RO5.RO.m]
  by rewrite Pr[mu_sub] => /#.
have h7 : Pr[DS2.EUF_CMA(RoutedH, DS2.RO2.RO, MLDSA_RO_DS3, A).main() @ &m :
             (res \/ bad4 RoutedH.tr RO_rest.RO.m RO_seed.RO.m RO_S.RO.m RO_rhopp.RO.m) \/
             mapbad RoutedH.tr DS5.RO4.RO.m DS5.RO5.RO.m] <=
          Pr[DS2.EUF_CMA(RoutedH, DS2.RO2.RO, MLDSA_RO_DS3, A).main() @ &m :
             res \/ bad4 RoutedH.tr RO_rest.RO.m RO_seed.RO.m RO_S.RO.m RO_rhopp.RO.m] +
          Pr[DS2.EUF_CMA(RoutedH, DS2.RO2.RO, MLDSA_RO_DS3, A).main() @ &m :
             mapbad RoutedH.tr DS5.RO4.RO.m DS5.RO5.RO.m]
  by rewrite Pr[mu_or]; smt(mu_bounded).
smt().
qed.

end section.

end MLDSA_ROSep_Hop4.
