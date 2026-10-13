require import AllCore IntDiv List Distr DList PROM FMap Xreal StdBigop StdOrder.
from Jasmin require import JByte_array JWord.
require import Array256.

require import Parameters GFq Rq VecMat Conversion Serialization Symmetric Sampling.
import PolyLVec PolyKVec PolyMat.
import Round ZModQ Zq MLDSAParams.

require import MLDSA MLDSA_RO MLDSA_ROSep MLDSA_ROSep_Hop1 MLDSA_ROSep_Hop2.

(*************** G2: the scheme queries Htr, Hmu, Hct and XC directly ****************)

(* H_ct, still sampling the padding of block 0 as the routed oracle does *)
module HctPad = {
  proc get(mu : Bytes64.t, w1 : BytesW1.t) : BytesCT.t = {
    var ct;
    ct <@ DS5.RO5.RO.get(mu, w1);
    RO_pad.RO.sample(Bytes64.to_list mu ++ BytesW1.to_list w1);
    return ct;
  }
}.

module MLDSA_RO_DS2(H : BlockOracle, G : Oracle) = {
  proc keygen = MLDSA_RO_DS(H, G).keygen

  proc sign(sk : BytesSK.t, m : W8.t list) : BytesSig.t option * Leakage list = {
     var coins,rho,_K,tr,s1,s2,t0,s1h,s2h,t0h,_A,mu,rhopp,kappa,y,w,w1,ctl,ct,c,ch,cs1,
         cs2,z,r0,ct0,h,leakage,sigma,bz,bh,bs,sl;
     var zh : (polylvec * polykvec) option;
     coins <$ drnd;
     ct <- witness;
     ctl <- witness;
     sigma <- witness;
     leakage <- [];
     (rho,_K,tr,s1,s2,t0) <@ SkEncDec.skDecode(sk);
     s1h <- nttv s1;
     s2h <- nttv s2;
     t0h <- nttv t0;
     _A <@ ExpandA(XOFA_O(G)).sample(rho);
     mu <@ DS5.RO4.RO.get(tr, m);
     bs <@ Squeeze(H).squeeze(Bytes32.to_list _K ++ rnd_to_list coins ++ Bytes64.to_list mu, 64);
     rhopp <- Bytes64.of_list bs;
     kappa <- 0;
     zh <- None;
     while (zh = None && ! (kappa_max <= kappa)) {
       y <@ ExpandMask_O(H).sample(rhopp,kappa * lvec);
       w <- invnttv (ntt_mulmxv _A (nttv y));
       w1 <- polykvec_HighBits w;
       ct <@ HctPad.get(mu, w1Encode w1);
       (c, sl) <@ SampleInBall_O(DS5.RO2.RO).sample(ct);
       ctl <- ((ct, c), sl);
       leakage <- leakage ++ [ RO ctl.`2] ;
       ch <- ntt c;
       cs1 <- invnttv (ntt_smul ch s1h);
       cs2 <- invnttv (ntt_smul ch s2h);
       z <- y + cs1;
       r0 <- polykvec_LowBits (w - cs2);
       bz <- infnorm_lt z (gamma1 - Beta) &&
                  infnorm_lt r0 (gamma2 - Beta);
       leakage <- leakage ++ [ CheckZ bz ];
       if (bz) {
          ct0 <- invnttv (ntt_smul ch t0h);
          h <- MakeHint (PolyKVec.zerov-ct0) (w - cs2 + ct0);
          bh <- infnorm_lt ct0 gamma2 && hammw h w_hint;
          leakage <- leakage ++ [ CheckH bh ];
          if (bh) { zh <- Some (z,h); }
       }
       kappa <- kappa + 1;
     }
     if (zh <> None) {
       sigma <@ SigEncDec.sigEncode(ct,(oget zh).`1,(oget zh).`2);
     }
     return (if zh = None then None else Some sigma, leakage);
  }

  proc verify(pk : BytesPK.t, m : W8.t list, sigma : BytesSig.t) : bool = {
    var rho,t1,c,l,ct,z,h,rb,_A,tr,mu,wapprox,w1,ctp;
    w1 <- witness;
    rb <- false;
    (rho,t1) <@ PkEncDec.pkDecode(pk);
    (ct,z,h) <@ SigEncDec.sigDecode(sigma);
    if (h <> None) {
      _A <@ ExpandA(XOFA_O(G)).sample(rho);
      tr <@ DS5.RO3.RO.get(pk);
      mu <@ DS5.RO4.RO.get(tr, m);
      (c,l) <@ SampleInBall_O(DS5.RO2.RO).sample(ct);
      wapprox <- invnttv (ntt_mulmxv _A (nttv z) - (ntt_smul (ntt c) (nttv (smul t1 (incoeff (2^d))))));
      w1 <- UseHint (oget h) wapprox;
      ctp <@ HctPad.get(mu, w1Encode w1);
      rb <- infnorm_lt z (gamma1 - Beta);
      rb <- rb && ct = ctp;
    }
    return rb;
  }
}.

(* bad: some H_mu output or H_ct output equals tr *)
op mapbad (tr : Bytes64.t) (mmu : (Bytes64.t * W8.t list, Bytes64.t) fmap)
          (mct : (Bytes64.t * BytesW1.t, BytesCT.t) fmap) : bool =
     (exists x, mmu.[x] = Some tr)
  \/ (exists x y, mct.[x] = Some y /\ BytesCT.to_list y = Bytes64.to_list tr).

(*************** The scheme's queries through the routed oracle ****************)

equiv squeeze_mu : Squeeze(RoutedH).squeeze ~ DS5.RO4.RO.get :
  ={glob RoutedH} /\ RoutedH.trset{1} /\ x{2}.`1 = RoutedH.tr{1} /\
  x{1} = Bytes64.to_list x{2}.`1 ++ x{2}.`2 /\ len{1} = 64
  ==> ={glob RoutedH} /\ res{1} = Bytes64.to_list res{2}.
proof.
proc; unroll{1} 3; rcondt{1} 3; 1: by auto.
rcondf{1} 6; 1: by move=> &m; wp; call (: true); auto.
wp; inline{1} RoutedH.get; sp 4 0; rcondt{1} 1;
  1: by auto => /> &2 *; rewrite take_size_cat // Bytes64.size_to_list.
rcondt{1} 1; 1: by auto.
inline{1} DS5.RO4.RO.get; wp; rnd; auto => />.
move=> &2 _ r _; rewrite drop_size_cat 1:Bytes64.size_to_list // take_oversize 1:Bytes64.size_to_list //.
have hx : (x{2}.`1, x{2}.`2) = x{2} by smt().
by rewrite hx !take_oversize ?Bytes64.size_to_list //; smt(get_set_sameE).
qed.

equiv get_xc (t : Bytes64.t) : RoutedH.get ~ DS5.RO2.RO.get :
  ={x, glob RoutedH} /\ RoutedH.tr{1} = t /\ size x{1}.`1 = lambda %/ 4 /\
  take 64 x{1}.`1 <> Bytes64.to_list t
  ==> ={res, glob RoutedH} /\ RoutedH.tr{1} = t.
proof.
proc; sp 1 0; rcondf{1} 1; 1: by auto => /#.
rcondf{1} 1; 1: by auto => />; have /= H := param_sets; smt(w1_bytes_big).
by rcondt{1} 1; [auto | inline *; auto].
qed.

equiv squeeze_xc (t : Bytes64.t) : Squeeze(RoutedH).squeeze ~ Squeeze(DS5.RO2.RO).squeeze :
  ={x, len, glob RoutedH} /\ RoutedH.tr{1} = t /\ size x{1} = lambda %/ 4 /\
  take 64 x{1} <> Bytes64.to_list t
  ==> ={res, glob RoutedH} /\ RoutedH.tr{1} = t.
proof.
by proc; while (={x, len, j, r, glob RoutedH} /\ RoutedH.tr{1} = t /\
                size x{1} = lambda %/ 4 /\ take 64 x{1} <> Bytes64.to_list t);
   [wp; call (get_xc t); auto | auto].
qed.

equiv read_xc (t : Bytes64.t) : ReadByte(RoutedH).read ~ ReadByte(DS5.RO2.RO).read :
  ={x, p, glob RoutedH} /\ RoutedH.tr{1} = t /\ size x{1} = lambda %/ 4 /\
  take 64 x{1} <> Bytes64.to_list t
  ==> ={res, glob RoutedH} /\ RoutedH.tr{1} = t.
proof. by proc; wp; call (get_xc t); auto. qed.

equiv sib_xc (t : Bytes64.t) : SampleInBall_O(RoutedH).sample ~ SampleInBall_O(DS5.RO2.RO).sample :
  ={rho, glob RoutedH} /\ RoutedH.tr{1} = t /\ take 64 (BytesCT.to_list rho{1}) <> Bytes64.to_list t
  ==> ={res, glob RoutedH} /\ RoutedH.tr{1} = t.
proof.
proc; while (={i, pos, h, c, leakage, rho, glob RoutedH} /\ RoutedH.tr{1} = t /\
             take 64 (BytesCT.to_list rho{1}) <> Bytes64.to_list t);
  2: by wp; call (squeeze_xc t); auto => />; rewrite BytesCT.size_to_list.
wp; while (={i, j, pos, leakage, rho, glob RoutedH} /\ RoutedH.tr{1} = t /\
           take 64 (BytesCT.to_list rho{1}) <> Bytes64.to_list t);
  1: by wp; call (read_xc t); auto => />; rewrite BytesCT.size_to_list.
by wp; call (read_xc t); auto => />; rewrite BytesCT.size_to_list.
qed.

equiv squeeze_ct : Squeeze(RoutedH).squeeze ~ HctPad.get :
  ={glob RoutedH} /\ mu{2} <> RoutedH.tr{1} /\
  x{1} = Bytes64.to_list mu{2} ++ BytesW1.to_list w1{2} /\ len{1} = lambda %/ 4
  ==> ={glob RoutedH} /\ res{1} = BytesCT.to_list res{2}.
proof.
proc; unroll{1} 3; rcondt{1} 3; 1: by auto => />; have /= H := param_sets; smt().
rcondf{1} 6; 1: by move=> &m; wp; call (: true); auto => />; have /= H := param_sets; smt().
wp; inline{1} RoutedH.get; sp 4 0; rcondf{1} 1;
  1: by auto => />; smt(take_size_cat Bytes64.size_to_list Bytes64.to_listK).
rcondt{1} 1; 1: by auto => />; rewrite size_cat Bytes64.size_to_list BytesW1.size_to_list.
rcondt{1} 1; 1: by auto.
inline *; wp; rnd; wp; rnd; auto => />.
move=> &2 _ r _; rewrite take_size_cat 1:Bytes64.size_to_list // drop_size_cat 1:Bytes64.size_to_list //
  Bytes64.to_listK BytesW1.to_listK.
rewrite !take_size_cat ?BytesCT.size_to_list //.
have hT : forall (a : BytesCT.t) b, take (lambda %/ 4) (BytesCT.to_list a ++ b) = BytesCT.to_list a
  by move=> a b; rewrite take_size_cat // BytesCT.size_to_list.
smt(get_set_sameE).
qed.

equiv squeeze_mu_e (a : Bytes64.t * W8.t list) : Squeeze(RoutedH).squeeze ~ DS5.RO4.RO.get :
  ={glob RoutedH} /\ RoutedH.trset{1} /\ x{2} = a /\ a.`1 = RoutedH.tr{1} /\
  x{1} = Bytes64.to_list a.`1 ++ a.`2 /\ len{1} = 64
  ==> ={glob RoutedH} /\ res{1} = Bytes64.to_list res{2} /\ DS5.RO4.RO.m{2}.[a] = Some res{2}.
proof.
conseq squeeze_mu _ (_ : x = a ==> DS5.RO4.RO.m.[a] = Some res) => //.
proc; auto => />.
by move=> &2 r _; rewrite get_set_sameE /= domE; case: (DS5.RO4.RO.m{2}.[a]).
qed.

equiv squeeze_ct_e (a : Bytes64.t) (b : BytesW1.t) : Squeeze(RoutedH).squeeze ~ HctPad.get :
  ={glob RoutedH} /\ mu{2} = a /\ w1{2} = b /\ a <> RoutedH.tr{1} /\
  x{1} = Bytes64.to_list a ++ BytesW1.to_list b /\ len{1} = lambda %/ 4
  ==> ={glob RoutedH} /\ res{1} = BytesCT.to_list res{2} /\ DS5.RO5.RO.m{2}.[(a, b)] = Some res{2}.
proof.
conseq squeeze_ct _ (_ : mu = a /\ w1 = b ==> DS5.RO5.RO.m.[(a, b)] = Some res) => //.
proc; inline *; auto => />.
by move=> &2 r _; rewrite get_set_sameE /= domE; case: (DS5.RO5.RO.m{2}.[a, b]).
qed.

(*************** Once set, bad stays set ****************)

lemma mapbad_set4 t m4 m5 k v : mapbad t m4 m5 => k \notin m4 => mapbad t m4.[k <- v] m5.
proof.
by rewrite /mapbad => -[[x hx] | hy] hk; [left; exists x; rewrite get_setE; smt(domE) | right].
qed.

lemma mapbad_set5 t m4 m5 k v : mapbad t m4 m5 => k \notin m5 => mapbad t m4 m5.[k <- v].
proof.
by rewrite /mapbad => -[hx | [x y [hx hy]]] hk; [left | right; exists x y; rewrite get_setE; smt(domE)].
qed.

hoare get_mono (b : bool) (t : Bytes64.t) : RoutedH.get :
  RoutedH.trset /\ RoutedH.tr = t /\ (b => mapbad t DS5.RO4.RO.m DS5.RO5.RO.m)
  ==> RoutedH.trset /\ RoutedH.tr = t /\ (b => mapbad t DS5.RO4.RO.m DS5.RO5.RO.m).
proof.
proc; sp; if; 1: by if; inline *; auto => />; smt(mapbad_set4).
if; 1: by if; inline *; auto => />; smt(mapbad_set5).
by if; [inline *; auto | if; [rcondf 3; [by inline *; auto | by inline *; auto] | by inline *; auto]].
qed.

hoare squeeze_mono (b : bool) (t : Bytes64.t) : Squeeze(RoutedH).squeeze :
  RoutedH.trset /\ RoutedH.tr = t /\ (b => mapbad t DS5.RO4.RO.m DS5.RO5.RO.m)
  ==> RoutedH.trset /\ RoutedH.tr = t /\ (b => mapbad t DS5.RO4.RO.m DS5.RO5.RO.m).
proof.
by proc; while (RoutedH.trset /\ RoutedH.tr = t /\ (b => mapbad t DS5.RO4.RO.m DS5.RO5.RO.m));
   [wp; call (get_mono b t); auto | auto].
qed.

hoare emask_mono (b : bool) (t : Bytes64.t) : ExpandMask_O(RoutedH).sample :
  RoutedH.trset /\ RoutedH.tr = t /\ (b => mapbad t DS5.RO4.RO.m DS5.RO5.RO.m)
  ==> RoutedH.trset /\ RoutedH.tr = t /\ (b => mapbad t DS5.RO4.RO.m DS5.RO5.RO.m).
proof.
by proc; while (RoutedH.trset /\ RoutedH.tr = t /\ (b => mapbad t DS5.RO4.RO.m DS5.RO5.RO.m));
   [wp; call (squeeze_mono b t); auto | auto].
qed.

hoare sib_mono (b : bool) (t : Bytes64.t) : SampleInBall_O(RoutedH).sample :
  RoutedH.trset /\ RoutedH.tr = t /\ (b => mapbad t DS5.RO4.RO.m DS5.RO5.RO.m)
  ==> RoutedH.trset /\ RoutedH.tr = t /\ (b => mapbad t DS5.RO4.RO.m DS5.RO5.RO.m).
proof.
proc; while (RoutedH.trset /\ RoutedH.tr = t /\ (b => mapbad t DS5.RO4.RO.m DS5.RO5.RO.m));
  2: by wp; call (squeeze_mono b t); auto.
by wp; while (RoutedH.trset /\ RoutedH.tr = t /\ (b => mapbad t DS5.RO4.RO.m DS5.RO5.RO.m));
   [inline ReadByte(RoutedH).read; wp; call (get_mono b t); auto |
    inline ReadByte(RoutedH).read; wp; call (get_mono b t); auto].
qed.

hoare hctpad_mono (b : bool) (t : Bytes64.t) : HctPad.get :
  RoutedH.trset /\ RoutedH.tr = t /\ (b => mapbad t DS5.RO4.RO.m DS5.RO5.RO.m)
  ==> RoutedH.trset /\ RoutedH.tr = t /\ (b => mapbad t DS5.RO4.RO.m DS5.RO5.RO.m).
proof. by proc; inline *; auto => />; smt(mapbad_set5). qed.

hoare ro4_mono (b : bool) (t : Bytes64.t) : DS5.RO4.RO.get :
  RoutedH.trset /\ RoutedH.tr = t /\ (b => mapbad t DS5.RO4.RO.m DS5.RO5.RO.m)
  ==> RoutedH.trset /\ RoutedH.tr = t /\ (b => mapbad t DS5.RO4.RO.m DS5.RO5.RO.m).
proof. by proc; auto => />; smt(mapbad_set4). qed.

equiv squeeze_sync (b : bool) (t : Bytes64.t) : Squeeze(RoutedH).squeeze ~ Squeeze(RoutedH).squeeze :
  ={x, len, glob RoutedH} /\ RoutedH.trset{2} /\ RoutedH.tr{2} = t /\
  (b => mapbad t DS5.RO4.RO.m{2} DS5.RO5.RO.m{2})
  ==> ={res, glob RoutedH} /\ RoutedH.trset{2} /\ RoutedH.tr{2} = t /\
      (b => mapbad t DS5.RO4.RO.m{2} DS5.RO5.RO.m{2}).
proof. by conseq (: ={x, len, glob RoutedH} ==> ={res, glob RoutedH}) _ (squeeze_mono b t) => //; sim. qed.

equiv emask_sync (b : bool) (t : Bytes64.t) : ExpandMask_O(RoutedH).sample ~ ExpandMask_O(RoutedH).sample :
  ={rho, mu, glob RoutedH} /\ RoutedH.trset{2} /\ RoutedH.tr{2} = t /\
  (b => mapbad t DS5.RO4.RO.m{2} DS5.RO5.RO.m{2})
  ==> ={res, glob RoutedH} /\ RoutedH.trset{2} /\ RoutedH.tr{2} = t /\
      (b => mapbad t DS5.RO4.RO.m{2} DS5.RO5.RO.m{2}).
proof. by conseq (: ={rho, mu, glob RoutedH} ==> ={res, glob RoutedH}) _ (emask_mono b t) => //; sim. qed.

(*************** Losslessness ****************)

axiom sib_XC_ll : islossless SampleInBall_O(DS5.RO2.RO).sample.

lemma hctpad_ll : islossless HctPad.get.
proof.
proc; inline *; auto => />.
by split => [| *];
   [rewrite /dbytesCT; apply dmap_ll; apply dlist_ll; apply W8.dword_ll | apply dlist_ll; apply W8.dword_ll].
qed.

(*************** Signing ****************)

hoare skDecode_tr (s : BytesSK.t) : SkEncDec.skDecode :
  sk = s ==> res.`3 = Bytes64.of_list (take 64 (drop 64 (BytesSK.to_list s))).
proof.
proc; while (tr = Bytes64.of_list (take 64 (drop 64 (BytesSK.to_list s)))); 1: by auto.
by wp; while (tr = Bytes64.of_list (take 64 (drop 64 (BytesSK.to_list s))));
   [auto | wp; while (tr = Bytes64.of_list (take 64 (drop 64 (BytesSK.to_list s)))); auto].
qed.

(* The routed and the direct signing oracles agree until an H_mu or H_ct output equals tr;
   both rejection loops are split at that point *)
equiv sign_eq : MLDSA_RO_DS1(RoutedH, DS2.RO2.RO).sign ~ MLDSA_RO_DS2(RoutedH, DS2.RO2.RO).sign :
  ={sk, m, glob RoutedH, glob DS2.RO2.RO, glob XOFA_O} /\ RoutedH.trset{2} /\
  Bytes64.of_list (take 64 (drop 64 (BytesSK.to_list sk{2}))) = RoutedH.tr{2} /\
  !mapbad RoutedH.tr{2} DS5.RO4.RO.m{2} DS5.RO5.RO.m{2}
  ==> !mapbad RoutedH.tr{2} DS5.RO4.RO.m{2} DS5.RO5.RO.m{2} =>
      ={res, glob RoutedH, glob DS2.RO2.RO, glob XOFA_O}.
proof.
proc; inline{1} MLDSA_RO(RoutedH, DS2.RO2.RO).sign_derand.
exlim RoutedH.tr{2}, sk{2}, m{2} => t s mm.
seq 13 10 : (={glob RoutedH, glob DS2.RO2.RO, glob XOFA_O, ct, ctl, sigma, leakage, rho, _K, tr,
               s1, s2, t0, s1h, s2h, t0h, _A} /\
             coins0{1} = coins{2} /\ m0{1} = m{2} /\ m{2} = mm /\ tr{2} = t /\
             RoutedH.trset{2} /\ RoutedH.tr{2} = t /\ !mapbad t DS5.RO4.RO.m{2} DS5.RO5.RO.m{2}).
+ call (: ={glob DS2.RO2.RO, glob XOFA_O}); 1: by sim.
  wp; call (: ={sk} /\ sk{2} = s ==>
              ={res} /\ res{2}.`3 = Bytes64.of_list (take 64 (drop 64 (BytesSK.to_list s)))).
  + by conseq (: ={sk} ==> ={res}) _ (skDecode_tr s) => //; sim.
  by auto => /> /#.
seq 2 1 : (={glob RoutedH, glob DS2.RO2.RO, glob XOFA_O, ct, ctl, sigma, leakage, rho, _K, tr,
              s1, s2, t0, s1h, s2h, t0h, _A, mu} /\
           coins0{1} = coins{2} /\ m0{1} = m{2} /\ m{2} = mm /\ tr{2} = t /\
           RoutedH.trset{2} /\ RoutedH.tr{2} = t /\ DS5.RO4.RO.m{2}.[(t, mm)] = Some mu{2}).
+ by wp; call (squeeze_mu_e (t, mm)); auto => />.
seq 4 4 : (={glob RoutedH, glob DS2.RO2.RO, glob XOFA_O, ct, ctl, sigma, leakage, rho, _K, tr,
              s1, s2, t0, s1h, s2h, t0h, _A, mu, rhopp, kappa, zh} /\
           m0{1} = m{2} /\ tr{2} = t /\ RoutedH.trset{2} /\ RoutedH.tr{2} = t /\
           (mu{2} = t => mapbad t DS5.RO4.RO.m{2} DS5.RO5.RO.m{2})).
+ by exlim mu{2} => mv; wp; call (squeeze_sync (mv = t) t); auto => />; smt().
splitwhile{1} 1 : (!mapbad RoutedH.tr DS5.RO4.RO.m DS5.RO5.RO.m);
  splitwhile{2} 1 : (!mapbad RoutedH.tr DS5.RO4.RO.m DS5.RO5.RO.m).
seq 1 1 : (((mapbad t DS5.RO4.RO.m{1} DS5.RO5.RO.m{1} /\ mapbad t DS5.RO4.RO.m{2} DS5.RO5.RO.m{2} /\
             RoutedH.trset{1} /\ RoutedH.tr{1} = t /\ RoutedH.trset{2} /\ RoutedH.tr{2} = t) \/
            (!mapbad t DS5.RO4.RO.m{2} DS5.RO5.RO.m{2} /\ mu{2} <> t /\
             ={glob RoutedH, glob DS2.RO2.RO, glob XOFA_O, ct, ctl, sigma, leakage, s1h, s2h, t0h,
               _A, mu, rhopp, kappa, zh} /\ RoutedH.trset{2} /\ RoutedH.tr{2} = t)) /\
           !((zh{2} = None && ! kappa_max <= kappa{2}) /\
             !mapbad RoutedH.tr{2} DS5.RO4.RO.m{2} DS5.RO5.RO.m{2})).
+ while ((mapbad t DS5.RO4.RO.m{1} DS5.RO5.RO.m{1} /\ mapbad t DS5.RO4.RO.m{2} DS5.RO5.RO.m{2} /\
          RoutedH.trset{1} /\ RoutedH.tr{1} = t /\ RoutedH.trset{2} /\ RoutedH.tr{2} = t) \/
         (!mapbad t DS5.RO4.RO.m{2} DS5.RO5.RO.m{2} /\ mu{2} <> t /\
          ={glob RoutedH, glob DS2.RO2.RO, glob XOFA_O, ct, ctl, sigma, leakage, s1h, s2h, t0h,
            _A, mu, rhopp, kappa, zh} /\ RoutedH.trset{2} /\ RoutedH.tr{2} = t)).
  + seq 3 3 : (mu{2} <> t /\
               ={glob RoutedH, glob DS2.RO2.RO, glob XOFA_O, ct, ctl, sigma, leakage, s1h, s2h, t0h,
                 _A, mu, rhopp, kappa, zh, y, w, w1} /\ RoutedH.trset{2} /\ RoutedH.tr{2} = t).
    + by wp; call (emask_sync false t); auto => /> /#.
    inline{1} SIB_RO_O(RoutedH).get; exlim mu{2}, w1{2} => mv wv.
    seq 4 1 : (mu{2} <> t /\ ct1{1} = ct{2} /\ DS5.RO5.RO.m{2}.[(mv, w1Encode wv)] = Some ct{2} /\
               mu{2} = mv /\
               ={glob RoutedH, glob DS2.RO2.RO, glob XOFA_O, ctl, sigma, leakage, s1h, s2h, t0h,
                 _A, mu, rhopp, kappa, zh, y, w, w1} /\ RoutedH.trset{2} /\ RoutedH.tr{2} = t).
    + wp; call (: ={glob RoutedH} /\ mu{2} = mv /\ w1{2} = w1Encode wv /\ mv <> RoutedH.tr{1} /\
                  x{1} = Bytes64.to_list mv ++ BytesW1.to_list (w1Encode wv) /\ len{1} = lambda %/ 4 /\
                  RoutedH.trset{2} /\ RoutedH.tr{2} = t
                  ==> ={glob RoutedH} /\ res{1} = BytesCT.to_list res{2} /\
                      DS5.RO5.RO.m{2}.[(mv, w1Encode wv)] = Some res{2} /\
                      RoutedH.trset{2} /\ RoutedH.tr{2} = t).
      + by conseq (squeeze_ct_e mv (w1Encode wv)) _ (hctpad_mono false t) => /#.
      by auto => /> &1 &2 *; rewrite BytesCT.to_listK /#.
    case (take 64 (BytesCT.to_list ct{2}) = Bytes64.to_list t).
    + wp; call{2} sib_XC_ll.
      call{1} (: RoutedH.trset /\ RoutedH.tr = t /\ (true => mapbad t DS5.RO4.RO.m DS5.RO5.RO.m)
                 ==> RoutedH.trset /\ RoutedH.tr = t /\ (true => mapbad t DS5.RO4.RO.m DS5.RO5.RO.m));
        1: by conseq sib_RoutedH_ll (sib_mono true t).
      have hmb : forall (m4 : (Bytes64.t * W8.t list, Bytes64.t) fmap)
                        (m5 : (Bytes64.t * BytesW1.t, BytesCT.t) fmap) k c,
                   m5.[k] = Some c => take 64 (BytesCT.to_list c) = Bytes64.to_list t =>
                   mapbad t m4 m5.
      + move=> m4 m5 k c hk hc; right; exists k c; split => //.
        by rewrite -hc take_oversize // BytesCT.size_to_list; have /= H := param_sets; smt().
      by skip => />; smt().
    by wp; call (sib_xc t); auto => /> /#.
  by skip => />; smt().
case (mapbad t DS5.RO4.RO.m{2} DS5.RO5.RO.m{2}).
+ conseq (: _ ==> RoutedH.tr{2} = t /\ mapbad t DS5.RO4.RO.m{2} DS5.RO5.RO.m{2}).
  + by move=> &1 &2 _ /> *; smt().
  seq 1 1 : (RoutedH.trset{2} /\ RoutedH.tr{2} = t /\ mapbad t DS5.RO4.RO.m{2} DS5.RO5.RO.m{2}).
  + while{2} (RoutedH.trset{2} /\ RoutedH.tr{2} = t /\ mapbad t DS5.RO4.RO.m{2} DS5.RO5.RO.m{2})
             (kappa_max - kappa{2}).
    + move=> _ z0; wp; call sib_XC_ll.
      call (: RoutedH.trset /\ RoutedH.tr = t /\ (true => mapbad t DS5.RO4.RO.m DS5.RO5.RO.m)
              ==> RoutedH.trset /\ RoutedH.tr = t /\ (true => mapbad t DS5.RO4.RO.m DS5.RO5.RO.m));
        1: by conseq hctpad_ll (hctpad_mono true t).
      wp; call (: RoutedH.trset /\ RoutedH.tr = t /\ (true => mapbad t DS5.RO4.RO.m DS5.RO5.RO.m)
                  ==> RoutedH.trset /\ RoutedH.tr = t /\ (true => mapbad t DS5.RO4.RO.m DS5.RO5.RO.m));
        1: by conseq (emask_ll RoutedH RoutedH_get_ll) (emask_mono true t).
      by auto => /#.
    while{1} true (kappa_max - kappa{1}).
    + move=> _ z0; wp; call (: true ==> true);
        1: by proc; call sib_RoutedH_ll; wp; call (Squeeze_ll RoutedH RoutedH_get_ll); auto.
      by wp; call (emask_ll RoutedH RoutedH_get_ll); auto => /#.
    by skip => />; smt().
  by wp; if{2}; [call{2} sigEncode_ll | ]; (if{1}; [call{1} sigEncode_ll | ]); auto.
rcondf{1} 1; 1: by auto => /#.
rcondf{2} 1; 1: by auto => /#.
by wp; if; [smt() | wp; call (: true); 1: by sim | ]; auto => /> /#.
qed.

(* G2's signing keeps tr, bad and the H_tr entry of the public key, and preserves bad *)
hoare get_inv (b bb : bool) (t : Bytes64.t) (k : BytesPK.t) : RoutedH.get :
  RoutedH.trset /\ RoutedH.tr = t /\ RoutedH.bad = bb /\ DS5.RO3.RO.m.[k] = Some t /\
  (b => mapbad t DS5.RO4.RO.m DS5.RO5.RO.m)
  ==> RoutedH.trset /\ RoutedH.tr = t /\ RoutedH.bad = bb /\ DS5.RO3.RO.m.[k] = Some t /\
      (b => mapbad t DS5.RO4.RO.m DS5.RO5.RO.m).
proof.
proc; sp; if; 1: by if; inline *; auto => />; smt(mapbad_set4).
if; 1: by if; inline *; auto => />; smt(mapbad_set5).
if; 1: by inline *; auto.
by if; [rcondf 3; [by inline *; auto | by inline *; auto => /> &hr *; rewrite get_setE; smt(domE)] |
        inline *; auto].
qed.

hoare squeeze_inv (b bb : bool) (t : Bytes64.t) (k : BytesPK.t) : Squeeze(RoutedH).squeeze :
  RoutedH.trset /\ RoutedH.tr = t /\ RoutedH.bad = bb /\ DS5.RO3.RO.m.[k] = Some t /\
  (b => mapbad t DS5.RO4.RO.m DS5.RO5.RO.m)
  ==> RoutedH.trset /\ RoutedH.tr = t /\ RoutedH.bad = bb /\ DS5.RO3.RO.m.[k] = Some t /\
      (b => mapbad t DS5.RO4.RO.m DS5.RO5.RO.m).
proof.
by proc; while (RoutedH.trset /\ RoutedH.tr = t /\ RoutedH.bad = bb /\ DS5.RO3.RO.m.[k] = Some t /\
                (b => mapbad t DS5.RO4.RO.m DS5.RO5.RO.m));
   [wp; call (get_inv b bb t k); auto | auto].
qed.

hoare emask_inv (b bb : bool) (t : Bytes64.t) (k : BytesPK.t) : ExpandMask_O(RoutedH).sample :
  RoutedH.trset /\ RoutedH.tr = t /\ RoutedH.bad = bb /\ DS5.RO3.RO.m.[k] = Some t /\
  (b => mapbad t DS5.RO4.RO.m DS5.RO5.RO.m)
  ==> RoutedH.trset /\ RoutedH.tr = t /\ RoutedH.bad = bb /\ DS5.RO3.RO.m.[k] = Some t /\
      (b => mapbad t DS5.RO4.RO.m DS5.RO5.RO.m).
proof.
by proc; while (RoutedH.trset /\ RoutedH.tr = t /\ RoutedH.bad = bb /\ DS5.RO3.RO.m.[k] = Some t /\
                (b => mapbad t DS5.RO4.RO.m DS5.RO5.RO.m));
   [wp; call (squeeze_inv b bb t k); auto | auto].
qed.

hoare sib_inv (b bb : bool) (t : Bytes64.t) (k : BytesPK.t) : SampleInBall_O(RoutedH).sample :
  RoutedH.trset /\ RoutedH.tr = t /\ RoutedH.bad = bb /\ DS5.RO3.RO.m.[k] = Some t /\
  (b => mapbad t DS5.RO4.RO.m DS5.RO5.RO.m)
  ==> RoutedH.trset /\ RoutedH.tr = t /\ RoutedH.bad = bb /\ DS5.RO3.RO.m.[k] = Some t /\
      (b => mapbad t DS5.RO4.RO.m DS5.RO5.RO.m).
proof.
proc; while (RoutedH.trset /\ RoutedH.tr = t /\ RoutedH.bad = bb /\ DS5.RO3.RO.m.[k] = Some t /\
             (b => mapbad t DS5.RO4.RO.m DS5.RO5.RO.m));
  2: by wp; call (squeeze_inv b bb t k); auto.
by wp; while (RoutedH.trset /\ RoutedH.tr = t /\ RoutedH.bad = bb /\ DS5.RO3.RO.m.[k] = Some t /\
              (b => mapbad t DS5.RO4.RO.m DS5.RO5.RO.m));
   [inline ReadByte(RoutedH).read; wp; call (get_inv b bb t k); auto |
    inline ReadByte(RoutedH).read; wp; call (get_inv b bb t k); auto].
qed.

hoare sign2_inv (b bb : bool) (t : Bytes64.t) (k : BytesPK.t) : MLDSA_RO_DS2(RoutedH, DS2.RO2.RO).sign :
  RoutedH.trset /\ RoutedH.tr = t /\ RoutedH.bad = bb /\ DS5.RO3.RO.m.[k] = Some t /\
  (b => mapbad t DS5.RO4.RO.m DS5.RO5.RO.m)
  ==> RoutedH.trset /\ RoutedH.tr = t /\ RoutedH.bad = bb /\ DS5.RO3.RO.m.[k] = Some t /\
      (b => mapbad t DS5.RO4.RO.m DS5.RO5.RO.m).
proof.
proc; seq 16 : (RoutedH.trset /\ RoutedH.tr = t /\ RoutedH.bad = bb /\ DS5.RO3.RO.m.[k] = Some t /\
                (b => mapbad t DS5.RO4.RO.m DS5.RO5.RO.m));
  2: by if; [call (: true); [by conseq /> | auto] | auto].
while (RoutedH.trset /\ RoutedH.tr = t /\ RoutedH.bad = bb /\ DS5.RO3.RO.m.[k] = Some t /\
       (b => mapbad t DS5.RO4.RO.m DS5.RO5.RO.m)).
+ wp; call (: true); 1: by conseq />.
  by call (hctpad_mono b t); wp; call (emask_inv b bb t k); auto.
by wp; call (squeeze_inv b bb t k); call (ro4_mono b t);
   call (: true); [by conseq /> | wp; call (: true); [by conseq /> | auto]].
qed.

lemma sign2_ll : islossless MLDSA_RO_DS2(RoutedH, DS2.RO2.RO).sign.
proof.
proc; seq 16 : true => //; last by if; [call sigEncode_ll | ].
while true (kappa_max - kappa);
  1: by move=> z; wp; call sib_XC_ll; call hctpad_ll; wp; call (emask_ll RoutedH RoutedH_get_ll);
        auto => /#.
wp; call (Squeeze_ll RoutedH RoutedH_get_ll); call (: true);
  1: by auto => />; rewrite /dbytes64; apply dmap_ll; apply dlist_ll; apply W8.dword_ll.
call expandA_ll; wp; call (: true).
+ while true (kvec - i); 1: by move=> z; auto => /#.
  wp; while true (kvec - i); 1: by move=> z; auto => /#.
  by wp; while true (lvec - i); [by move=> z; auto => /# | auto => /#].
by auto => />; smt(drnd_ll).
qed.

(*************** Verification ****************)

lemma verify2_ll : islossless MLDSA_RO_DS2(RoutedH, DS2.RO2.RO).verify.
proof.
proc; seq 4 : true => //; 1: by call sigDecode_ll; call pkDecode_ll; auto.
by if => //; wp; call hctpad_ll; wp; call sib_XC_ll;
   call (: true);
     [by auto => />; rewrite /dbytes64; apply dmap_ll; apply dlist_ll; apply W8.dword_ll |
      call (: true);
        [by auto => />; rewrite /dbytes64; apply dmap_ll; apply dlist_ll; apply W8.dword_ll |
         call expandA_ll; auto]].
qed.

hoare sigDecode_ct (s : BytesSig.t) : SigEncDec.sigDecode :
  sigma = s ==> res.`1 = BytesCT.init (fun ii => BytesSig."_.[_]" s ii).
proof.
by proc; call (: true); 1: (by conseq />);
   while (ct = BytesCT.init (fun ii => BytesSig."_.[_]" s ii)); auto.
qed.

hoare hctpad_res (a : Bytes64.t) (b : BytesW1.t) : HctPad.get :
  mu = a /\ w1 = b ==> DS5.RO5.RO.m.[(a, b)] = Some res.
proof.
by proc; inline *; auto => /> &hr r _ *; rewrite get_set_sameE /= domE; case: (DS5.RO5.RO.m{hr}.[a, b]).
qed.

(* The H_tr query on the public key returns tr *)
hoare squeeze_pk (p : BytesPK.t) (t : Bytes64.t) : Squeeze(RoutedH).squeeze :
  x = BytesPK.to_list p /\ len = 64 /\ RoutedH.trset /\ RoutedH.tr = t /\ DS5.RO3.RO.m.[p] = Some t /\
  take 64 x <> Bytes64.to_list t
  ==> res = Bytes64.to_list t.
proof.
proc; unroll 3; rcondt 3; 1: by auto.
rcondf 6; 1: by wp; call (: true); auto.
have hpkl : pk_bytes <> lambda %/ 4 by rewrite /pk_bytes; have /= H := param_sets; smt().
wp; inline RoutedH.get; sp; rcondf 1; 1: by auto => /#.
rcondf 1; 1: by auto => />; smt(pk_len_nrel BytesPK.size_to_list).
rcondf 1; 1: by auto => />; smt(BytesPK.size_to_list).
rcondt 1; 1: by auto => />; smt(BytesPK.size_to_list).
rcondf 3; 1: by inline *; auto.
inline *; auto => />.
by move=> &hr _ hp _ r _; rewrite domE hp /= take_oversize // Bytes64.size_to_list.
qed.

equiv squeeze_tr (p : BytesPK.t) (t : Bytes64.t) : Squeeze(RoutedH).squeeze ~ DS5.RO3.RO.get :
  ={glob RoutedH} /\ x{2} = p /\ x{1} = BytesPK.to_list p /\ len{1} = 64 /\
  RoutedH.trset{1} /\ RoutedH.tr{1} = t /\ DS5.RO3.RO.m{1}.[p] = Some t /\
  take 64 (BytesPK.to_list p) <> Bytes64.to_list t
  ==> ={glob RoutedH} /\ res{1} = Bytes64.to_list t /\ res{2} = t.
proof.
proc; unroll{1} 3; rcondt{1} 3; 1: by auto.
rcondf{1} 6; 1: by move=> &m; wp; call (: true); auto.
have hpkl : pk_bytes <> lambda %/ 4 by rewrite /pk_bytes; have /= H := param_sets; smt().
wp; inline{1} RoutedH.get; sp 4 0; rcondf{1} 1; 1: by auto => /#.
rcondf{1} 1; 1: by auto => />; smt(pk_len_nrel BytesPK.size_to_list).
rcondf{1} 1; 1: by auto => />; smt(BytesPK.size_to_list).
rcondt{1} 1; 1: by auto => />; smt(BytesPK.size_to_list).
rcondf{1} 3; 1: by move=> &m; inline *; auto.
inline *; wp; rnd; auto => />.
by move=> &2 _ hp _ r _; rewrite domE hp /= take_oversize // Bytes64.size_to_list.
qed.

hoare mverify_inv (bb : bool) (t : Bytes64.t) (k : BytesPK.t) : MLDSA_RO(RoutedH, DS2.RO2.RO).verify :
  RoutedH.trset /\ RoutedH.tr = t /\ RoutedH.bad = bb /\ DS5.RO3.RO.m.[k] = Some t /\
  (false => mapbad t DS5.RO4.RO.m DS5.RO5.RO.m)
  ==> RoutedH.trset /\ RoutedH.tr = t /\ RoutedH.bad = bb /\ DS5.RO3.RO.m.[k] = Some t /\
      (false => mapbad t DS5.RO4.RO.m DS5.RO5.RO.m).
proof.
proc; seq 4 : (RoutedH.trset /\ RoutedH.tr = t /\ RoutedH.bad = bb /\ DS5.RO3.RO.m.[k] = Some t /\
               (false => mapbad t DS5.RO4.RO.m DS5.RO5.RO.m));
  1: by call (: true); [by conseq /> | call (: true); [by conseq /> | auto]].
by if; [wp; call (squeeze_inv false bb t k); wp; call (sib_inv false bb t k); wp;
        call (squeeze_inv false bb t k); wp; call (squeeze_inv false bb t k);
        call (: true); [by conseq /> | auto] | auto].
qed.

(* c~ = tr: G1 rejects, and G2 accepts only if an H_ct output equals tr *)
hoare verify1_ct (p : BytesPK.t) (t : Bytes64.t) : MLDSA_RO_DS1(RoutedH, DS2.RO2.RO).verify :
  pk = p /\ RoutedH.trset /\ RoutedH.tr = t /\ DS5.RO3.RO.m.[p] = Some t /\
  take 64 (BytesPK.to_list p) <> Bytes64.to_list t /\
  take 64 (BytesCT.to_list (BytesCT.init (fun ii => BytesSig."_.[_]" sigma ii))) = Bytes64.to_list t
  ==> !res.
proof.
proc; exlim RoutedH.bad => bb; wp; ecall (squeeze_pk p t); wp; call (mverify_inv bb t p).
skip => /> &hr _ _ _ hct r.
have hs : size (BytesCT.to_list (BytesCT.init (BytesSig."_.[_]" sigma{hr}))) <= 64
  by rewrite BytesCT.size_to_list; have /= H := param_sets; smt().
by move: hct; rewrite (take_oversize 64 _ hs) => ->.
qed.

hoare verify2_ct (t : Bytes64.t) : MLDSA_RO_DS2(RoutedH, DS2.RO2.RO).verify :
  take 64 (BytesCT.to_list (BytesCT.init (fun ii => BytesSig."_.[_]" sigma ii))) = Bytes64.to_list t
  ==> res => mapbad t DS5.RO4.RO.m DS5.RO5.RO.m.
proof.
proc; seq 4 : (take 64 (BytesCT.to_list ct) = Bytes64.to_list t /\ !rb).
+ ecall (sigDecode_ct sigma).
  call (: true); [by conseq /> | auto => />].
  by move=> &hr h r ->.
if; 2: by auto.
wp; ecall (hctpad_res mu (w1Encode w1)); wp; call (: true); 1: by conseq />.
call (: true); 1: by conseq />.
call (: true); 1: by conseq />.
call (: true); 1: by conseq />.
skip => /> &hr hct.
move=> _ _ A t0 m4 c m5 hm _; right.
exists (t0, w1Encode (UseHint (oget h{hr}) (invnttv (ntt_mulmxv A (nttv z{hr}) -
                     ntt_smul (ntt c.`1) (nttv (smul t1{hr} (incoeff 8192))))))) ct{hr}.
split => //.
by rewrite -hct take_oversize // BytesCT.size_to_list; have /= H := param_sets; smt().
qed.

equiv verify_eq_ct (p : BytesPK.t) (t : Bytes64.t) :
  MLDSA_RO_DS1(RoutedH, DS2.RO2.RO).verify ~ MLDSA_RO_DS2(RoutedH, DS2.RO2.RO).verify :
  ={pk, m, sigma, glob RoutedH, glob DS2.RO2.RO, glob XOFA_O} /\ pk{2} = p /\
  RoutedH.trset{2} /\ RoutedH.tr{2} = t /\ DS5.RO3.RO.m{2}.[p] = Some t /\
  take 64 (BytesPK.to_list p) <> Bytes64.to_list t /\
  take 64 (BytesCT.to_list (BytesCT.init (fun ii => BytesSig."_.[_]" sigma{2} ii))) = Bytes64.to_list t
  ==> !mapbad t DS5.RO4.RO.m{2} DS5.RO5.RO.m{2} => ={res}.
proof.
conseq (: true ==> true) (verify1_ct p t) (verify2_ct t).
+ by move=> &1 &2 /> /#.
+ by move=> &1 &2 /> /#.
proc*; call{2} verify2_ll; call{1} (: true ==> true); 2: by auto.
by proc; wp; call (Squeeze_ll RoutedH RoutedH_get_ll); wp;
   call (verify_ll RoutedH RoutedH_get_ll sib_RoutedH_ll); auto.
qed.

(* c~ <> tr: the routed and the direct verifications agree until an H_mu output equals tr *)
equiv verify_eq_nct (p : BytesPK.t) (t : Bytes64.t) :
  MLDSA_RO_DS1(RoutedH, DS2.RO2.RO).verify ~ MLDSA_RO_DS2(RoutedH, DS2.RO2.RO).verify :
  ={pk, m, sigma, glob RoutedH, glob DS2.RO2.RO, glob XOFA_O} /\ pk{2} = p /\
  RoutedH.trset{2} /\ RoutedH.tr{2} = t /\ DS5.RO3.RO.m{2}.[p] = Some t /\
  take 64 (BytesPK.to_list p) <> Bytes64.to_list t /\
  take 64 (BytesCT.to_list (BytesCT.init (fun ii => BytesSig."_.[_]" sigma{2} ii))) <> Bytes64.to_list t
  ==> !mapbad t DS5.RO4.RO.m{2} DS5.RO5.RO.m{2} => ={res}.
proof.
proc; inline{1} MLDSA_RO(RoutedH, DS2.RO2.RO).verify.
exlim RoutedH.bad{2}, m{2}, sigma{2} => bb mm ss.
wp; call{1} (: x = BytesPK.to_list p /\ len = 64 /\ RoutedH.trset /\ RoutedH.tr = t /\
               DS5.RO3.RO.m.[p] = Some t /\ take 64 x <> Bytes64.to_list t
               ==> res = Bytes64.to_list t);
  1: by conseq (Squeeze_ll RoutedH RoutedH_get_ll) (squeeze_pk p t).
wp; seq 7 4 : (={rho, t1, z, h, w1, rb, glob RoutedH, glob DS2.RO2.RO, glob XOFA_O} /\
               ct0{1} = ct{2} /\ ct{2} = BytesCT.init (fun ii => BytesSig."_.[_]" ss ii) /\
               pk0{1} = p /\ pk{1} = p /\ pk{2} = p /\ m0{1} = mm /\ m{2} = mm /\ sigma{1} = ss /\
               RoutedH.trset{2} /\ RoutedH.tr{2} = t /\ DS5.RO3.RO.m{2}.[p] = Some t /\
               take 64 (BytesPK.to_list p) <> Bytes64.to_list t /\
               take 64 (BytesCT.to_list (BytesCT.init (fun ii => BytesSig."_.[_]" ss ii))) <>
               Bytes64.to_list t).
+ call (: ={sigma} /\ sigma{2} = ss ==>
          ={res} /\ res{2}.`1 = BytesCT.init (fun ii => BytesSig."_.[_]" ss ii));
    1: by conseq (: ={sigma} ==> ={res}) _ (sigDecode_ct ss) => //; sim.
  by call (: true); [sim | auto => /> /#].
if; [smt() | | by auto => />; smt(take_oversize Bytes64.size_to_list)].
seq 1 1 : (={rho, t1, z, h, w1, rb, _A, glob RoutedH, glob DS2.RO2.RO, glob XOFA_O} /\
           ct0{1} = ct{2} /\ ct{2} = BytesCT.init (fun ii => BytesSig."_.[_]" ss ii) /\
           pk0{1} = p /\ pk{1} = p /\ pk{2} = p /\ m0{1} = mm /\ m{2} = mm /\ sigma{1} = ss /\
           RoutedH.trset{2} /\ RoutedH.tr{2} = t /\ DS5.RO3.RO.m{2}.[p] = Some t /\
           take 64 (BytesPK.to_list p) <> Bytes64.to_list t /\
           take 64 (BytesCT.to_list (BytesCT.init (fun ii => BytesSig."_.[_]" ss ii))) <>
           Bytes64.to_list t);
  1: by call (: ={glob DS2.RO2.RO, glob XOFA_O}); [sim | auto].
seq 4 2 : (={rho, t1, z, h, w1, rb, _A, mu, glob RoutedH, glob DS2.RO2.RO, glob XOFA_O} /\
           ct0{1} = ct{2} /\ ct{2} = BytesCT.init (fun ii => BytesSig."_.[_]" ss ii) /\ pk{1} = p /\
           RoutedH.trset{2} /\ RoutedH.tr{2} = t /\ DS5.RO3.RO.m{2}.[p] = Some t /\
           take 64 (BytesPK.to_list p) <> Bytes64.to_list t /\
           take 64 (BytesCT.to_list (BytesCT.init (fun ii => BytesSig."_.[_]" ss ii))) <>
           Bytes64.to_list t /\ sigma{1} = ss /\ DS5.RO4.RO.m{2}.[(t, mm)] = Some mu{2}).
+ wp; call (squeeze_mu_e (t, mm)); wp.
  call (: ={glob RoutedH} /\ x{2} = p /\ x{1} = BytesPK.to_list p /\ len{1} = 64 /\
          RoutedH.trset{1} /\ RoutedH.tr{1} = t /\ DS5.RO3.RO.m{1}.[p] = Some t /\
          take 64 (BytesPK.to_list p) <> Bytes64.to_list t
          ==> ={glob RoutedH} /\ res{1} = Bytes64.to_list t /\ res{2} = t /\
              DS5.RO3.RO.m{2}.[p] = Some t).
  + conseq (squeeze_tr p t) _ (_ : x = p /\ DS5.RO3.RO.m.[p] = Some t ==> DS5.RO3.RO.m.[p] = Some t).
    + by move=> &1 &2 />.
    + by move=> &1 &2 />.
    by proc; auto => /> &hr hp r _; rewrite domE hp.
  by auto => /> &1 &2 *; rewrite Bytes64.to_listK /=; smt(Bytes64.to_listK).
case (mu{2} = t).
+ conseq (: _ ==> pk{1} = p /\ RoutedH.trset{1} /\ RoutedH.tr{1} = t /\ DS5.RO3.RO.m{1}.[p] = Some t /\
                  mapbad t DS5.RO4.RO.m{2} DS5.RO5.RO.m{2}).
  + move=> &1 &2 hpre tr0 ts m3 rb1 m5 rb2 [->] [] -> [] -> [] hm hmb; split; 1: smt().
    by move=> r hr; rewrite hmb.
  exlim RoutedH.bad{1} => b1; wp.
  call{2} (: RoutedH.trset /\ RoutedH.tr = t /\ (true => mapbad t DS5.RO4.RO.m DS5.RO5.RO.m)
             ==> RoutedH.trset /\ RoutedH.tr = t /\ (true => mapbad t DS5.RO4.RO.m DS5.RO5.RO.m));
    1: by conseq hctpad_ll (hctpad_mono true t).
  wp; call{1} (: RoutedH.trset /\ RoutedH.tr = t /\ RoutedH.bad = b1 /\ DS5.RO3.RO.m.[p] = Some t /\
                 (false => mapbad t DS5.RO4.RO.m DS5.RO5.RO.m)
                 ==> RoutedH.trset /\ RoutedH.tr = t /\ RoutedH.bad = b1 /\ DS5.RO3.RO.m.[p] = Some t /\
                     (false => mapbad t DS5.RO4.RO.m DS5.RO5.RO.m));
    1: by conseq (Squeeze_ll RoutedH RoutedH_get_ll) (squeeze_inv false b1 t p).
  wp; call{2} sib_XC_ll.
  call{1} (: RoutedH.trset /\ RoutedH.tr = t /\ RoutedH.bad = b1 /\ DS5.RO3.RO.m.[p] = Some t /\
             (false => mapbad t DS5.RO4.RO.m DS5.RO5.RO.m)
             ==> RoutedH.trset /\ RoutedH.tr = t /\ RoutedH.bad = b1 /\ DS5.RO3.RO.m.[p] = Some t /\
                 (false => mapbad t DS5.RO4.RO.m DS5.RO5.RO.m));
    1: by conseq sib_RoutedH_ll (sib_inv false b1 t p).
  by skip => /> /#.
seq 3 3 : (={rho, t1, z, h, w1, rb, _A, mu, c, l, wapprox, glob RoutedH, glob DS2.RO2.RO, glob XOFA_O} /\
           ct0{1} = ct{2} /\ ct{2} = BytesCT.init (fun ii => BytesSig."_.[_]" ss ii) /\ pk{1} = p /\
           RoutedH.trset{2} /\ RoutedH.tr{2} = t /\ DS5.RO3.RO.m{2}.[p] = Some t /\
           take 64 (BytesPK.to_list p) <> Bytes64.to_list t /\
           take 64 (BytesCT.to_list (BytesCT.init (fun ii => BytesSig."_.[_]" ss ii))) <>
           Bytes64.to_list t /\ sigma{1} = ss /\ mu{2} <> t).
+ by wp; call (sib_xc t); auto => /> /#.
exlim mu{2}, w1{2} => mv wv; wp; call (squeeze_ct_e mv (w1Encode wv)); auto => /> &1 &2 *.
smt(take_oversize Bytes64.size_to_list).
qed.

hoare verify2_B (t : Bytes64.t) : MLDSA_RO_DS2(RoutedH, DS2.RO2.RO).verify :
  (RoutedH.bad \/ mapbad t DS5.RO4.RO.m DS5.RO5.RO.m) /\ RoutedH.trset /\ RoutedH.tr = t
  ==> (RoutedH.bad \/ mapbad t DS5.RO4.RO.m DS5.RO5.RO.m) /\ RoutedH.trset /\ RoutedH.tr = t.
proof.
proc; seq 4 : (#pre); 1: by call (: true); [by conseq /> | call (: true); [by conseq /> | auto]].
if; 2: by auto.
wp; inline HctPad.get DS5.RO4.RO.get; wp; call (: true); 1: by conseq />.
inline DS5.RO5.RO.get; wp; rnd; wp; call (: true); 1: by conseq />.
by wp; rnd; wp; call (: true);
   [by conseq /> | call (: true); [by conseq /> | auto => />; smt(mapbad_set4 mapbad_set5)]].
qed.

(*************** Key generation ****************)

hoare skEncode_tr (t : Bytes64.t) : SkEncDec.skEncode :
  tr = t ==> Bytes64.of_list (take 64 (drop 64 (BytesSK.to_list res))) = t.
proof.
proc; wp; while (take 128 skbytes = Bytes32.to_list rho ++ Bytes32.to_list k ++ Bytes64.to_list t /\
                 128 <= size skbytes).
+ auto => /> &hr h1 h2 _; split; 2: smt(size_cat size_ge0).
  by rewrite take_cat; case: (128 < size skbytes{hr}) => hs //=;
     rewrite (_ : 128 - size skbytes{hr} = 0) 1:/# take0 cats0 -h1 take_oversize /#.
wp; while (take 128 skbytes = Bytes32.to_list rho ++ Bytes32.to_list k ++ Bytes64.to_list t /\
           128 <= size skbytes);
  1: by auto => /> &hr h1 h2 _; split;
        [rewrite take_cat; case: (128 < size skbytes{hr}) => hs //=;
         rewrite (_ : 128 - size skbytes{hr} = 0) 1:/# take0 cats0 -h1 take_oversize /# |
         smt(size_cat size_ge0)].
wp; while (take 128 skbytes = Bytes32.to_list rho ++ Bytes32.to_list k ++ Bytes64.to_list t /\
           128 <= size skbytes);
  1: by auto => /> &hr h1 h2 _; split;
        [rewrite take_cat; case: (128 < size skbytes{hr}) => hs //=;
         rewrite (_ : 128 - size skbytes{hr} = 0) 1:/# take0 cats0 -h1 take_oversize /# |
         smt(size_cat size_ge0)].
auto => /> &hr; rewrite !size_cat !Bytes32.size_to_list Bytes64.size_to_list /=; split;
  1: by rewrite take_oversize // !size_cat !Bytes32.size_to_list Bytes64.size_to_list.
by move=> i0 s0 _ _ _ i1 s1 _ _ _ i2 s _ h _; rewrite -(cat_take_drop 128 s) h sk_tr.
qed.

(* The H_tr query of key generation sets tr; unless bad, pk does not begin with tr *)
hoare squeeze_pk_set (p : BytesPK.t) : Squeeze(RoutedH).squeeze :
  !RoutedH.trset /\ x = BytesPK.to_list p /\ len = 64
  ==> RoutedH.trset /\ res = Bytes64.to_list RoutedH.tr /\ DS5.RO3.RO.m.[p] = Some RoutedH.tr /\
      (!RoutedH.bad => take 64 (BytesPK.to_list p) <> Bytes64.to_list RoutedH.tr).
proof.
proc; unroll 3; rcondt 3; 1: by auto.
rcondf 6; 1: by wp; call (: true); auto.
have hpkl : pk_bytes <> lambda %/ 4 by rewrite /pk_bytes; have /= H := param_sets; smt().
wp; inline RoutedH.get; sp; rcondf 1; 1: by auto => /#.
rcondf 1; 1: by auto => />; smt(pk_len_nrel BytesPK.size_to_list).
rcondf 1; 1: by auto => />; smt(BytesPK.size_to_list).
rcondt 1; 1: by auto => />; smt(BytesPK.size_to_list).
rcondt 3; 1: by inline *; auto.
inline *; auto => />.
by move=> &hr _ r _; rewrite /hit; smt(domE get_set_sameE take_oversize Bytes64.size_to_list).
qed.

hoare keygen_facts : MLDSA_RO_DS(RoutedH, DS2.RO2.RO).keygen :
  !RoutedH.trset /\ !RoutedH.bad /\ DS5.RO3.RO.m = empty /\ RO_rest.RO.m = empty
  ==> RoutedH.trset /\ Bytes64.of_list (take 64 (drop 64 (BytesSK.to_list res.`2))) = RoutedH.tr /\
      DS5.RO3.RO.m.[res.`1] = Some RoutedH.tr /\
      (!RoutedH.bad => take 64 (BytesPK.to_list res.`1) <> Bytes64.to_list RoutedH.tr).
proof.
proc; inline MLDSA_RO(RoutedH, DS2.RO2.RO).keygen_derand; wp; ecall (skEncode_tr tr); wp;
  ecall (squeeze_pk_set pk0); call (: true); 1: by conseq />.
conseq (: _ ==> !RoutedH.trset).
+ by move=> &hr _ ts k0 r0 a b c hts p /=; rewrite hts /= => r1 bd t0 ts0 m [hts0] [->] [hm hb];
     rewrite Bytes64.to_listK => s /= ->.
wp; ecall (expandS_pre rhop); call (: true); 1: by conseq />.
wp; call squeeze_short; wp; rnd; auto => />.
by move=> &hr _ _ e _; have /= H := param_sets; smt(mem_empty).
qed.

(*************** The adversary's oracles after bad ****************)

hoare sign2_B (t : Bytes64.t) (p : BytesPK.t) : MLDSA_RO_DS2(RoutedH, DS2.RO2.RO).sign :
  (RoutedH.bad \/ mapbad t DS5.RO4.RO.m DS5.RO5.RO.m) /\ RoutedH.trset /\ RoutedH.tr = t /\
  DS5.RO3.RO.m.[p] = Some t
  ==> (RoutedH.bad \/ mapbad t DS5.RO4.RO.m DS5.RO5.RO.m) /\ RoutedH.trset /\ RoutedH.tr = t /\
      DS5.RO3.RO.m.[p] = Some t.
proof.
exlim RoutedH.bad => bb; case: bb => hb;
  [conseq (sign2_inv false true t p) | conseq (sign2_inv true false t p)] => /#.
qed.

hoare get_B (t : Bytes64.t) (p : BytesPK.t) : RoutedH.get :
  (RoutedH.bad \/ mapbad t DS5.RO4.RO.m DS5.RO5.RO.m) /\ RoutedH.trset /\ RoutedH.tr = t /\
  DS5.RO3.RO.m.[p] = Some t
  ==> (RoutedH.bad \/ mapbad t DS5.RO4.RO.m DS5.RO5.RO.m) /\ RoutedH.trset /\ RoutedH.tr = t /\
      DS5.RO3.RO.m.[p] = Some t.
proof.
exlim RoutedH.bad => bb; case: bb => hb;
  [conseq (get_inv false true t p) | conseq (get_inv true false t p)] => /#.
qed.

hoare emask_keep (b : bool) : ExpandMask_O(RoutedH).sample :
  RoutedH.trset /\ RoutedH.bad = b ==> RoutedH.trset /\ RoutedH.bad = b.
proof. by proc; while (RoutedH.trset /\ RoutedH.bad = b); [wp; call (squeeze_keep b); auto | auto]. qed.

hoare sign2_keep (b : bool) : MLDSA_RO_DS2(RoutedH, DS2.RO2.RO).sign :
  RoutedH.trset /\ RoutedH.bad = b ==> RoutedH.trset /\ RoutedH.bad = b.
proof.
proc; seq 16 : (RoutedH.trset /\ RoutedH.bad = b);
  2: by if; [call (: true); [by conseq /> | auto] | auto].
while (RoutedH.trset /\ RoutedH.bad = b);
  1: by wp; call (: true); [by conseq /> | call (: true); [by conseq /> | wp; call (emask_keep b); auto]].
by wp; call (squeeze_keep b);
   call (: true); [by conseq /> | call (: true); [by conseq /> | wp; call (: true); [by conseq /> | auto]]].
qed.

section.

declare module A <: DS2.Adversary {
  -DS2.RO1.RO, -DS2.RO2.RO, -DS2.EUF_CMA, -XOFA_O, -XOFS_O, -MLDSA_RO_DS1, -RoutedH,
  -DS5.RO2.RO, -DS5.RO3.RO, -DS5.RO4.RO, -DS5.RO5.RO, -RO_rest.RO, -RO_pad.RO }.

lemma hop3_uptobad &m :
  (forall (H1 <: DS2.POracle1 {-A}) (H2 <: DS2.POracle2 {-A}) (O <: DS2.SOracle {-A}),
     islossless H1.get => islossless H2.get => islossless O.sign =>
     islossless A(H1, H2, O).forge) =>
  Pr[DS2.EUF_CMA(RoutedH, DS2.RO2.RO, MLDSA_RO_DS1, A).main() @ &m : res \/ RoutedH.bad] <=
  Pr[DS2.EUF_CMA(RoutedH, DS2.RO2.RO, MLDSA_RO_DS2, A).main() @ &m :
       res \/ RoutedH.bad \/ mapbad RoutedH.tr DS5.RO4.RO.m DS5.RO5.RO.m].
proof.
move=> A_ll.
byequiv (: ={glob A, glob XOFA_O, glob XOFS_O} ==>
           res{1} \/ RoutedH.bad{1} =>
           res{2} \/ RoutedH.bad{2} \/ mapbad RoutedH.tr{2} DS5.RO4.RO.m{2} DS5.RO5.RO.m{2}) => //.
proc; inline{1} MLDSA_RO_DS1(RoutedH, DS2.RO2.RO).keygen.
seq 6 4 : (={glob A, glob XOFA_O, glob XOFS_O, glob RoutedH, glob DS2.RO2.RO, pk, DS2.EUF_CMA.sk,
              DS2.EUF_CMA.qs} /\ RoutedH.trset{2} /\
           Bytes64.of_list (take 64 (drop 64 (BytesSK.to_list DS2.EUF_CMA.sk{2}))) = RoutedH.tr{2} /\
           DS5.RO3.RO.m{2}.[pk{2}] = Some RoutedH.tr{2} /\
           (!RoutedH.bad{2} => take 64 (BytesPK.to_list pk{2}) <> Bytes64.to_list RoutedH.tr{2})).
+ wp; call (: ={glob RoutedH, glob DS2.RO2.RO, glob XOFA_O, glob XOFS_O} /\ !RoutedH.trset{2} /\
              !RoutedH.bad{2} /\ DS5.RO3.RO.m{2} = empty /\ RO_rest.RO.m{2} = empty
              ==> ={res, glob RoutedH, glob DS2.RO2.RO, glob XOFA_O, glob XOFS_O} /\ RoutedH.trset{2} /\
                  Bytes64.of_list (take 64 (drop 64 (BytesSK.to_list res{2}.`2))) = RoutedH.tr{2} /\
                  DS5.RO3.RO.m{2}.[res{2}.`1] = Some RoutedH.tr{2} /\
                  (!RoutedH.bad{2} =>
                   take 64 (BytesPK.to_list res{2}.`1) <> Bytes64.to_list RoutedH.tr{2})).
  + by conseq (: ={glob RoutedH, glob DS2.RO2.RO, glob XOFA_O, glob XOFS_O} ==>
                 ={res, glob RoutedH, glob DS2.RO2.RO, glob XOFA_O, glob XOFS_O}) _ keygen_facts => //;
       proc; sim.
  by inline *; auto => /> /#.
exlim RoutedH.tr{2}, pk{2} => t p.
seq 1 1 : (pk{1} = p /\ pk{2} = p /\ RoutedH.trset{2} /\ RoutedH.tr{2} = t /\ DS5.RO3.RO.m{2}.[p] = Some t /\
           (!(RoutedH.bad{2} \/ mapbad t DS5.RO4.RO.m{2} DS5.RO5.RO.m{2}) =>
            ={m, s, glob RoutedH, glob DS2.RO2.RO, glob XOFA_O, DS2.EUF_CMA.qs} /\
            take 64 (BytesPK.to_list p) <> Bytes64.to_list t)).
+ call (: RoutedH.bad \/ mapbad t DS5.RO4.RO.m DS5.RO5.RO.m,
          ={glob RoutedH, glob DS2.RO2.RO, glob XOFA_O, glob XOFS_O, DS2.EUF_CMA.sk, DS2.EUF_CMA.qs} /\
          RoutedH.trset{2} /\ RoutedH.tr{2} = t /\
          Bytes64.of_list (take 64 (drop 64 (BytesSK.to_list DS2.EUF_CMA.sk{2}))) = t /\
          DS5.RO3.RO.m{2}.[p] = Some t /\ take 64 (BytesPK.to_list p) <> Bytes64.to_list t,
          RoutedH.trset{2} /\ RoutedH.tr{2} = t /\ DS5.RO3.RO.m{2}.[p] = Some t).
  + by move=> H1 H2 O hO h2 h1; apply (A_ll H1 H2 O).
  + proc; exlim RoutedH.bad{2} => bb.
    call (: ={sk, m, glob RoutedH, glob DS2.RO2.RO, glob XOFA_O} /\ RoutedH.trset{2} /\
            RoutedH.tr{2} = t /\ RoutedH.bad{2} = bb /\
            Bytes64.of_list (take 64 (drop 64 (BytesSK.to_list sk{2}))) = t /\
            DS5.RO3.RO.m{2}.[p] = Some t /\ !mapbad t DS5.RO4.RO.m{2} DS5.RO5.RO.m{2}
            ==> (!mapbad t DS5.RO4.RO.m{2} DS5.RO5.RO.m{2} =>
                 ={res, glob RoutedH, glob DS2.RO2.RO, glob XOFA_O}) /\
                RoutedH.trset{2} /\ RoutedH.tr{2} = t /\ RoutedH.bad{2} = bb /\
                DS5.RO3.RO.m{2}.[p] = Some t).
    + by conseq sign_eq _ (sign2_inv false bb t p) => /#.
    by auto => /> /#.
  + move=> &2 _; conseq (: true ==> true) => //; proc.
    inline MLDSA_RO_DS1(RoutedH, DS2.RO2.RO).sign; wp.
    by call (sign_ll RoutedH RoutedH_get_ll sib_RoutedH_ll); auto => />; exact drnd_ll.
  + by move=> _; proc;
       call (: (RoutedH.bad \/ mapbad t DS5.RO4.RO.m DS5.RO5.RO.m) /\ RoutedH.trset /\
               RoutedH.tr = t /\ DS5.RO3.RO.m.[p] = Some t
               ==> (RoutedH.bad \/ mapbad t DS5.RO4.RO.m DS5.RO5.RO.m) /\ RoutedH.trset /\
                   RoutedH.tr = t /\ DS5.RO3.RO.m.[p] = Some t);
       [conseq sign2_ll (sign2_B t p) | auto].
  + by proc; auto => /> /#.
  + by move=> &2 _; conseq (: true ==> true) => //; islossless; exact W8.dword_ll.
  + by move=> _; proc; auto => /> *; exact W8.dword_ll.
  + exlim RoutedH.bad{2} => bb.
    conseq (: ={x, glob RoutedH} ==> ={res, glob RoutedH}) _ (get_inv false bb t p).
    + by move=> &1 &2 />.
    + by move=> &1 &2 /> *; case: (bad_R \/ mapbad t m_R3 m_R4) => //=.
    by sim.
  + by move=> &2 _; conseq RoutedH_get_ll.
  + by move=> _; conseq RoutedH_get_ll (get_B t p).
  by skip => /> /#.
case (RoutedH.bad{2} \/ mapbad t DS5.RO4.RO.m{2} DS5.RO5.RO.m{2}).
+ conseq (: _ ==> (RoutedH.bad{2} \/ mapbad t DS5.RO4.RO.m{2} DS5.RO5.RO.m{2}) /\ RoutedH.tr{2} = t);
    1: smt().
  call{2} (: (RoutedH.bad \/ mapbad t DS5.RO4.RO.m DS5.RO5.RO.m) /\ RoutedH.trset /\ RoutedH.tr = t
             ==> (RoutedH.bad \/ mapbad t DS5.RO4.RO.m DS5.RO5.RO.m) /\ RoutedH.trset /\ RoutedH.tr = t);
    1: by conseq verify2_ll (verify2_B t).
  call{1} (: true ==> true);
    1: by proc; wp; call (Squeeze_ll RoutedH RoutedH_get_ll); wp;
          call (verify_ll RoutedH RoutedH_get_ll sib_RoutedH_ll); auto.
  by skip => /> /#.
case (take 64 (BytesCT.to_list (BytesCT.init (fun ii => BytesSig."_.[_]" s{2} ii))) = Bytes64.to_list t).
+ call (: ={pk, m, sigma, glob RoutedH, glob DS2.RO2.RO, glob XOFA_O} /\ pk{2} = p /\
          RoutedH.trset{2} /\ RoutedH.tr{2} = t /\ DS5.RO3.RO.m{2}.[p] = Some t /\
          take 64 (BytesPK.to_list p) <> Bytes64.to_list t /\
          take 64 (BytesCT.to_list (BytesCT.init (fun ii => BytesSig."_.[_]" sigma{2} ii))) =
          Bytes64.to_list t /\ RoutedH.trset{1} /\ RoutedH.bad{1} = false
          ==> (!mapbad t DS5.RO4.RO.m{2} DS5.RO5.RO.m{2} => ={res}) /\ RoutedH.bad{1} = false);
    1: by conseq (verify_eq_ct p t) (verify_keep false) _ => /#.
  by skip => /> /#.
call (: ={pk, m, sigma, glob RoutedH, glob DS2.RO2.RO, glob XOFA_O} /\ pk{2} = p /\
        RoutedH.trset{2} /\ RoutedH.tr{2} = t /\ DS5.RO3.RO.m{2}.[p] = Some t /\
        take 64 (BytesPK.to_list p) <> Bytes64.to_list t /\
        take 64 (BytesCT.to_list (BytesCT.init (fun ii => BytesSig."_.[_]" sigma{2} ii))) <>
        Bytes64.to_list t /\ RoutedH.trset{1} /\ RoutedH.bad{1} = false
        ==> (!mapbad t DS5.RO4.RO.m{2} DS5.RO5.RO.m{2} => ={res}) /\ RoutedH.bad{1} = false);
  1: by conseq (verify_eq_nct p t) (verify_keep false) _ => /#.
by skip => /> /#.
qed.

(* bad of hop 2 silences the game once set; bounded here in G2, where key generation is unchanged *)
local lemma hop3_bad &m :
  Pr[DS2.EUF_CMA(RoutedH, DS2.RO2.RO, MLDSA_RO_DS2, A).main() @ &m : RoutedH.bad] <= 2%r * p512.
proof.
byphoare => //; proc; seq 4 : RoutedH.bad (2%r * p512) 1%r 1%r 0%r RoutedH.trset.
+ by call keygen_trset; inline *; auto.
+ by call keygen_bad; inline *; auto.
+ by conseq (: _ ==> true) => //.
+ hoare; call (: true); 1: by conseq />.
  call (: RoutedH.trset /\ !RoutedH.bad); last by auto => /#.
  + by proc; call (sign2_keep false); auto => /#.
  + by proc; auto.
  + by conseq (get_keep false) => /#.
by [].
qed.

(* Hops 2 and 3: the scheme queries Htr, Hmu, Hct and XC directly.
   mapbad is carried, not bounded in G2: there the hidden inputs K || rnd || mu and rho'' || n
   still go through the router and reach H_mu when K || rnd = tr or rho'' = tr, so a count of
   H_mu entries in G2 would charge every hidden query. Once the hidden queries leave the router
   (hop 4), each H_mu or H_ct entry comes from the adversary or from a direct scheme query. *)
lemma hop3 &m :
  (forall (H1 <: DS2.POracle1 {-A}) (H2 <: DS2.POracle2 {-A}) (O <: DS2.SOracle {-A}),
     islossless H1.get => islossless H2.get => islossless O.sign =>
     islossless A(H1, H2, O).forge) =>
  Pr[DS2.EUF_CMA(DS2.RO1.RO, DS2.RO2.RO, MLDSA_RO_DS1, A).main() @ &m : res] <=
  Pr[DS2.EUF_CMA(RoutedH, DS2.RO2.RO, MLDSA_RO_DS2, A).main() @ &m :
       res \/ mapbad RoutedH.tr DS5.RO4.RO.m DS5.RO5.RO.m] + 2%r * p512.
proof.
move=> A_ll; have h2 := hop2_uptobad A &m A_ll.
have h3 := hop3_uptobad &m A_ll.
have h4 := hop3_bad &m.
have h5 : Pr[DS2.EUF_CMA(RoutedH, DS2.RO2.RO, MLDSA_RO_DS2, A).main() @ &m :
             res \/ RoutedH.bad \/ mapbad RoutedH.tr DS5.RO4.RO.m DS5.RO5.RO.m] <=
          Pr[DS2.EUF_CMA(RoutedH, DS2.RO2.RO, MLDSA_RO_DS2, A).main() @ &m :
             (res \/ mapbad RoutedH.tr DS5.RO4.RO.m DS5.RO5.RO.m) \/ RoutedH.bad]
  by rewrite Pr[mu_sub] => /#.
have h6 : Pr[DS2.EUF_CMA(RoutedH, DS2.RO2.RO, MLDSA_RO_DS2, A).main() @ &m :
             (res \/ mapbad RoutedH.tr DS5.RO4.RO.m DS5.RO5.RO.m) \/ RoutedH.bad] <=
          Pr[DS2.EUF_CMA(RoutedH, DS2.RO2.RO, MLDSA_RO_DS2, A).main() @ &m :
             res \/ mapbad RoutedH.tr DS5.RO4.RO.m DS5.RO5.RO.m] +
          Pr[DS2.EUF_CMA(RoutedH, DS2.RO2.RO, MLDSA_RO_DS2, A).main() @ &m : RoutedH.bad]
  by rewrite Pr[mu_or]; smt(mu_bounded).
smt().
qed.

end section.
