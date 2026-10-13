require import AllCore IntDiv List Distr DList DInterval PROM FMap BitEncoding.
from Jasmin require import JByte_array JWord.
require import Array256.

require import Parameters GFq Rq.
require import Spec65.
import MLDSA65.
import PolyLVec PolyKVec PolyMat.
import Round ZModQ Zq MLDSAParams.

require import MLDSA_RO MLDSA_ROSep MLDSA_ROSep_Hop1 MLDSA_ROSep_Hop2 MLDSA_ROSep_Hop3.
require import JWordList ListExtra.
require import MLDSA_ROSep_Hop4 MLDSA_ROSep_Hop5 MLDSA_ROSep_Hop6 MLDSA_ROSep_Hop7.
require DS_ROM.

(*************** G8: the secret key is (rho, tr, s1, s2, t0) ****************)

clone DS_ROM.DS_ROM_x5 as DS8 with
  type pkey    <- BytesPK.t,
  type skey    <- Bytes32.t * Bytes64.t * polylvec * polykvec * polykvec,
  type msg     <- W8.t list,
  type sig     <- BytesSig.t,
  type leakage <- Leakage list,
  type RO1.in_t  <- W8.t list * int,
  type RO1.out_t <- W8.t,
  op   RO1.dout  <- fun _ => W8.dword,
  type RO2.in_t  <- W8.t list * int,
  type RO2.out_t <- W8.t list,
  op   RO2.dout  <- fun _ => dblock,
  type RO3.in_t  <- BytesPK.t,
  type RO3.out_t <- Bytes64.t,
  op   RO3.dout  <- fun _ => dbytes64,
  type RO4.in_t  <- Bytes64.t * W8.t list,
  type RO4.out_t <- Bytes64.t,
  op   RO4.dout  <- fun _ => dbytes64,
  type RO5.in_t  <- Bytes64.t * BytesW1.t,
  type RO5.out_t <- BytesCT.t,
  op   RO5.dout  <- fun _ => dbytesCT.

module MLDSA_RO_DS8(XA : DS5.POracle1, XC : DS5.POracle2, Htr : DS5.POracle3, Hmu : DS5.POracle4,
                    Hct : DS5.POracle5) = {
  proc keygen() : BytesPK.t * (Bytes32.t * Bytes64.t * polylvec * polykvec * polykvec) = {
    var rho,_A,s1,s2,t,t1,t0,pk,tr;
    RO_y.RO.init();
    rho <$ dxi;
    _A <@ ExpandA(XOFA_O(XA)).sample(rho);
    s1 <$ dpolyl (dpoly (-Eta) Eta);
    s2 <$ dpolyk (dpoly (-Eta) Eta);
    t <- invnttv (ntt_mulmxv _A (nttv s1)) + s2;
    (t1,t0) <- Power2Round t;
    pk <@ PkEncDec.pkEncode(rho,t1);
    tr <@ Htr.get(pk);
    return (pk, (rho, tr, s1, s2, t0));
  }

  proc sign(sk : Bytes32.t * Bytes64.t * polylvec * polykvec * polykvec, m : W8.t list) :
    BytesSig.t option * Leakage list = {
     var coins,rho,tr,s1,s2,t0,s1h,s2h,t0h,_A,mu,kappa,y,w,w1,ctl,ct,c,ch,cs1,
         cs2,z,r0,ct0,h,leakage,sigma,bz,bh,sl;
     var zh : (polylvec * polykvec) option;
     coins <$ drnd;
     ct <- witness;
     ctl <- witness;
     sigma <- witness;
     leakage <- [];
     (rho,tr,s1,s2,t0) <- sk;
     s1h <- nttv s1;
     s2h <- nttv s2;
     t0h <- nttv t0;
     _A <@ ExpandA(XOFA_O(XA)).sample(rho);
     mu <@ Hmu.get(tr, m);
     kappa <- 0;
     zh <- None;
     while (zh = None && ! (kappa_max <= kappa)) {
       y <@ RO_y.RO.get(coins, mu, kappa);
       w <- invnttv (ntt_mulmxv _A (nttv y));
       w1 <- polykvec_HighBits w;
       ct <@ Hct.get(mu, w1Encode w1);
       (c, sl) <@ SampleInBall_O(XC).sample(ct);
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

  proc verify = MLDSA_ROSep(XA, XC, Htr, Hmu, Hct).verify
}.

(*************** The secret key encoding ****************)

op skEnc (sk : Bytes32.t * Bytes64.t * polylvec * polykvec * polykvec) : BytesSK.t =
  BytesSK.of_list (Bytes32.to_list sk.`1 ++ Bytes32.to_list cK ++ Bytes64.to_list sk.`2 ++
                   flatten (map (fun p => BitPack p Eta Eta) (LArray.to_list sk.`3)) ++
                   flatten (map (fun p => BitPack p Eta Eta) (KArray.to_list sk.`4)) ++
                   flatten (map (fun p => BitPack p (2^(d-1)-1) (2^(d-1))) (KArray.to_list sk.`5))).

op skrange (sk : Bytes32.t * Bytes64.t * polylvec * polykvec * polykvec) : bool =
     (forall i j, 0 <= i < lvec => 0 <= j < n => -Eta <= crepr sk.`3.[i].[j] <= Eta)
  /\ (forall i j, 0 <= i < kvec => 0 <= j < n => -Eta <= crepr sk.`4.[i].[j] <= Eta)
  /\ (forall i j, 0 <= i < kvec => 0 <= j < n => -(2^(d-1) - 1) <= crepr sk.`5.[i].[j] <= 2^(d-1)).

lemma skEnc_list (sk : Bytes32.t * Bytes64.t * polylvec * polykvec * polykvec) :
  BytesSK.to_list (skEnc sk) =
  Bytes32.to_list sk.`1 ++ Bytes32.to_list cK ++ Bytes64.to_list sk.`2 ++
  flatten (map (fun p => BitPack p Eta Eta) (LArray.to_list sk.`3)) ++
  flatten (map (fun p => BitPack p Eta Eta) (KArray.to_list sk.`4)) ++
  flatten (map (fun p => BitPack p (2^(d-1)-1) (2^(d-1))) (KArray.to_list sk.`5)).
proof.
rewrite /skEnc BytesSK.of_listK // !size_cat Bytes32.size_to_list Bytes64.size_to_list.
rewrite (size_flatten_ctt (n * noise_bits %/ 8)); 1: by move=> x /mapP [p [_ ->]]; rewrite size_bp_eta.
rewrite (size_flatten_ctt (n * noise_bits %/ 8)); 1: by move=> x /mapP [p [_ ->]]; rewrite size_bp_eta.
rewrite (size_flatten_ctt (n * d %/ 8)); 1: by move=> x /mapP [p [_ ->]]; rewrite size_bp_t0.
rewrite !size_map Bytes32.size_to_list !size_iota.
by have /= H := param_sets; smt().
qed.

lemma skdec_rho sk : Bytes32.of_list (take 32 (BytesSK.to_list (skEnc sk))) = sk.`1.
proof. by rewrite skEnc_list -!catA take_size_cat ?Bytes32.size_to_list // Bytes32.to_listK. qed.

lemma skdec_tr sk : Bytes64.of_list (take 64 (drop 64 (BytesSK.to_list (skEnc sk)))) = sk.`2.
proof.
rewrite skEnc_list -!catA catA drop_size_cat ?size_cat ?Bytes32.size_to_list //.
by rewrite take_size_cat ?Bytes64.size_to_list // Bytes64.to_listK.
qed.

lemma skdec_s1 sk : skrange sk =>
  LArray.init (fun i => BitUnpack (take ((n * noise_bits) %/ 8)
                 (drop (128 + i * (n * noise_bits) %/ 8) (BytesSK.to_list (skEnc sk)))) Eta Eta) = sk.`3.
proof.
move=> [h1 _]; apply LArray.ext_eq => i hi; rewrite LArray.initiE //=.
have hnb0 : 0 < n * noise_bits %/ 8 by have /= H := param_sets; smt().
have hnb : i * (n * noise_bits) %/ 8 = n * noise_bits %/ 8 * i by have /= H := param_sets; smt().
have hF1 : size (flatten (map (fun p => BitPack p Eta Eta) (LArray.to_list sk.`3))) = n * noise_bits %/ 8 * lvec.
+ rewrite (size_flatten_ctt (n * noise_bits %/ 8)); 1: by move=> x /mapP [p [_ ->]]; rewrite size_bp_eta.
  by rewrite size_map LArray.size_to_list mulzC.
rewrite hnb addzC -drop_drop; 1,2: smt().
rewrite skEnc_list -!catA catA catA drop_size_cat ?size_cat ?Bytes32.size_to_list ?Bytes64.size_to_list //.
rewrite take_drop_cat; 1,2: smt().
+ by rewrite hF1; smt(StdOrder.IntOrder.ler_wpmul2l).
rewrite take_drop_flatten //; 1: by move=> p; rewrite size_bp_eta.
+ by rewrite LArray.size_to_list.
by rewrite LArray.get_to_list BitPackK //; smt(gt0_eta).
qed.

lemma skdec_s2 sk : skrange sk =>
  KArray.init (fun i => BitUnpack (take ((n * noise_bits) %/ 8)
                 (drop (128 + s1_bytes + i*((n * noise_bits) %/ 8)) (BytesSK.to_list (skEnc sk)))) Eta Eta) = sk.`4.
proof.
move=> [_ [h2 _]]; apply KArray.ext_eq => i hi; rewrite KArray.initiE //=.
have hnb0 : 0 < n * noise_bits %/ 8 by have /= H := param_sets; smt().
have hF1 : size (flatten (map (fun p => BitPack p Eta Eta) (LArray.to_list sk.`3))) = s1_bytes.
+ rewrite (size_flatten_ctt (n * noise_bits %/ 8)); 1: by move=> x /mapP [p [_ ->]]; rewrite size_bp_eta.
  by rewrite size_map LArray.size_to_list; have /= H := param_sets; smt().
have hF2 : size (flatten (map (fun p => BitPack p Eta Eta) (KArray.to_list sk.`4))) = n * noise_bits %/ 8 * kvec.
+ rewrite (size_flatten_ctt (n * noise_bits %/ 8)); 1: by move=> x /mapP [p [_ ->]]; rewrite size_bp_eta.
  by rewrite size_map KArray.size_to_list mulzC.
rewrite (_ : 128 + s1_bytes + i * (n * noise_bits %/ 8) = n * noise_bits %/ 8 * i + (s1_bytes + 128)) 1:/#.
rewrite -drop_drop; 1,2: by have /= H := param_sets; smt().
rewrite -drop_drop.
+ by rewrite -hF1 size_ge0.
+ done.
rewrite skEnc_list -!catA catA catA drop_size_cat ?size_cat ?Bytes32.size_to_list ?Bytes64.size_to_list //.
rewrite drop_size_cat //.
rewrite take_drop_cat; 1,2: smt().
+ by rewrite hF2; smt(StdOrder.IntOrder.ler_wpmul2l).
rewrite take_drop_flatten //; 1: by move=> p; rewrite size_bp_eta.
+ by rewrite KArray.size_to_list.
by rewrite KArray.get_to_list BitPackK //; smt(gt0_eta).
qed.

lemma skdec_t0 sk : skrange sk =>
  KArray.init (fun i => BitUnpack (take ((n * d) %/ 8)
                 (drop (128 + s1_bytes + s2_bytes + i*((n * d) %/ 8)) (BytesSK.to_list (skEnc sk))))
                 (2^(d-1)-1) (2^(d-1))) = sk.`5.
proof.
move=> [_ [_ h3]]; apply KArray.ext_eq => i hi; rewrite KArray.initiE //=.
have hF1 : size (flatten (map (fun p => BitPack p Eta Eta) (LArray.to_list sk.`3))) = s1_bytes.
+ rewrite (size_flatten_ctt (n * noise_bits %/ 8)); 1: by move=> x /mapP [p [_ ->]]; rewrite size_bp_eta.
  by rewrite size_map LArray.size_to_list; have /= H := param_sets; smt().
have hF2 : size (flatten (map (fun p => BitPack p Eta Eta) (KArray.to_list sk.`4))) = s2_bytes.
+ rewrite (size_flatten_ctt (n * noise_bits %/ 8)); 1: by move=> x /mapP [p [_ ->]]; rewrite size_bp_eta.
  by rewrite size_map KArray.size_to_list; have /= H := param_sets; smt().
rewrite (_ : 128 + s1_bytes + s2_bytes + i * (n * d %/ 8) =
             n * d %/ 8 * i + (s2_bytes + (s1_bytes + 128))) 1:/#.
rewrite -drop_drop.
+ smt().
+ by rewrite -hF2 -hF1 /=; smt(size_ge0).
rewrite -drop_drop.
+ by rewrite -hF2 size_ge0.
+ by rewrite -hF1 /=; smt(size_ge0).
rewrite -drop_drop.
+ by rewrite -hF1 size_ge0.
+ done.
rewrite skEnc_list -!catA catA catA drop_size_cat ?size_cat ?Bytes32.size_to_list ?Bytes64.size_to_list //.
rewrite drop_size_cat // drop_size_cat //.
rewrite take_drop_flatten //; 1: by move=> p; rewrite size_bp_t0.
+ by rewrite KArray.size_to_list.
rewrite /= BitPackK //.
by move=> j hj; have /= := h3 i j hi hj.
qed.

phoare skdec_enc (s : Bytes32.t * Bytes64.t * polylvec * polykvec * polykvec) :
  [SkEncDec.skDecode : sk = skEnc s ==>
   skrange s => res.`1 = s.`1 /\ res.`3 = s.`2 /\ res.`4 = s.`3 /\ res.`5 = s.`4 /\ res.`6 = s.`5] = 1%r.
proof.
proc*; call (skDecode_corr (skEnc s)); auto.
move=> &hr ->; split => // _ rr [#] h1 _ h3 h4 h5 h6 hs.
have /= ht0 := skdec_t0 s hs.
by rewrite h1 h3 h4 h5 h6 skdec_rho skdec_tr skdec_s1 // skdec_s2 // ht0.
qed.

(*************** G7 and G8 ****************)

equiv keygen78 :
  MLDSA_RO_DS7(DS5.RO1.RO, DS5.RO2.RO, DS5.RO3.RO, DS5.RO4.RO, DS5.RO5.RO).keygen ~
  MLDSA_RO_DS8(DS5.RO1.RO, DS5.RO2.RO, DS5.RO3.RO, DS5.RO4.RO, DS5.RO5.RO).keygen :
  ={glob DS5.RO1.RO, DS5.RO3.RO.m, glob XOFA_O}
  ==> res{1}.`1 = res{2}.`1 /\ res{1}.`2 = skEnc res{2}.`2 /\ skrange res{2}.`2 /\
      ={glob DS5.RO1.RO, DS5.RO3.RO.m, glob XOFA_O, RO_y.RO.m}.
proof.
proc.
seq 9 9 : (={rho, s1, s2, t, t0, tr, pk, glob DS5.RO1.RO, DS5.RO3.RO.m, glob XOFA_O, RO_y.RO.m} /\
           s1{2} \in dpolyl (dpoly (-Eta) Eta) /\ s2{2} \in dpolyk (dpoly (-Eta) Eta) /\
           t0{2} = (Power2Round t{2}).`2).
+ call (: ={DS5.RO3.RO.m}); 1: by sim.
  wp; call (: true); 1: by sim.
  wp; rnd; rnd; call (: ={glob DS5.RO1.RO, glob XOFA_O}); 1: by sim.
  by inline *; auto => />.
exlim rho{2}, tr{2}, s1{2}, s2{2}, t0{2} => r0 tr0 s10 s20 t00.
call{1} (skEncode_corr r0 cK tr0 s10 s20 t00).
auto => /> &2 h1 h2.
have hEta : (q + 1) %/ 2 - q <= -Eta /\ Eta < (q + 1) %/ 2 by have /= H := param_sets; smt().
split.
+ move=> i j hi0 hi1 hj0 hj1; move: h1 => /supp_dpolyl /(_ i _); 1: done.
  by rewrite supp_dpoly; smt().
split.
+ move=> i j hi0 hi1 hj0 hj1; move: h2 => /supp_dpolyk /(_ i _); 1: done.
  by rewrite supp_dpoly; smt().
move=> i j hi0 hi1 hj0 hj1.
rewrite /Power2Round /= KArray.mapiE 1:/# /= /poly_Power2Round /= Array256.initiE 1:/# /=.
by have /= := p2r_t0 t{2}.[i].[j]; smt().
qed.

equiv sign78 :
  MLDSA_RO_DS7(DS5.RO1.RO, DS5.RO2.RO, DS5.RO3.RO, DS5.RO4.RO, DS5.RO5.RO).sign ~
  MLDSA_RO_DS8(DS5.RO1.RO, DS5.RO2.RO, DS5.RO3.RO, DS5.RO4.RO, DS5.RO5.RO).sign :
  sk{1} = skEnc sk{2} /\ skrange sk{2} /\
  ={m, glob DS5.RO1.RO, DS5.RO2.RO.m, DS5.RO4.RO.m, DS5.RO5.RO.m, glob XOFA_O, RO_y.RO.m}
  ==> ={res, glob DS5.RO1.RO, DS5.RO2.RO.m, DS5.RO4.RO.m, DS5.RO5.RO.m, glob XOFA_O, RO_y.RO.m}.
proof.
proc.
seq 6 6 : (={coins, ct, ctl, sigma, leakage, m, rho, tr, s1, s2, t0, glob DS5.RO1.RO, DS5.RO2.RO.m,
             DS5.RO4.RO.m, DS5.RO5.RO.m, glob XOFA_O, RO_y.RO.m}).
+ by exlim sk{2} => s; wp; call{1} (skdec_enc s); auto => />.
by sim.
qed.

equiv verify78 :
  MLDSA_RO_DS7(DS5.RO1.RO, DS5.RO2.RO, DS5.RO3.RO, DS5.RO4.RO, DS5.RO5.RO).verify ~
  MLDSA_RO_DS8(DS5.RO1.RO, DS5.RO2.RO, DS5.RO3.RO, DS5.RO4.RO, DS5.RO5.RO).verify :
  ={pk, m, sigma, glob DS5.RO1.RO, DS5.RO2.RO.m, DS5.RO3.RO.m, DS5.RO4.RO.m, DS5.RO5.RO.m, glob XOFA_O}
  ==> ={res}.
proof. by sim. qed.

section.

declare module A <: DS2.Adversary {
  -DS2.RO1.RO, -DS2.RO2.RO, -DS2.EUF_CMA, -XOFA_O, -XOFS_O, -MLDSA_RO_DS1, -RoutedH,
  -DS5.RO1.RO, -DS5.RO2.RO, -DS5.RO3.RO, -DS5.RO4.RO, -DS5.RO5.RO, -DS5.EUF_CMA, -RO_rest.RO,
  -RO_pad.RO, -RO_pad.FRO, -RO_seed.RO, -RO_S.RO, -RO_rhopp.RO, -RO_v.RO, -CountH, -CountS, -St5,
  -RO_lp.RO, -RO_lp.FRO, -St6, -St7, -Router, -RO_y.RO, -DS8.EUF_CMA }.

lemma G7_G8 &m :
  Pr[DS5.EUF_CMA(DS5.RO1.RO, DS5.RO2.RO, DS5.RO3.RO, DS5.RO4.RO, DS5.RO5.RO, MLDSA_RO_DS7, Router(A)).main()
       @ &m : res] =
  Pr[DS8.EUF_CMA(DS5.RO1.RO, DS5.RO2.RO, DS5.RO3.RO, DS5.RO4.RO, DS5.RO5.RO, MLDSA_RO_DS8, Router(A)).main()
       @ &m : res].
proof.
byequiv (: ={glob A, glob XOFA_O} ==> ={res}) => //.
proc.
inline{1} DS5.EUF_CMA(DS5.RO1.RO, DS5.RO2.RO, DS5.RO3.RO, DS5.RO4.RO, DS5.RO5.RO, MLDSA_RO_DS7, Router(A)).A.forge.
inline{2} DS8.EUF_CMA(DS5.RO1.RO, DS5.RO2.RO, DS5.RO3.RO, DS5.RO4.RO, DS5.RO5.RO, MLDSA_RO_DS8, Router(A)).A.forge.
wp; call verify78.
wp; call (: ={RO_pad.RO.m, RO_rest.RO.m, DS5.RO1.RO.m, DS5.RO2.RO.m, DS5.RO3.RO.m, DS5.RO4.RO.m,
              DS5.RO5.RO.m, glob XOFA_O, Router.tr, RO_y.RO.m} /\
            DS5.EUF_CMA.qs{1} = DS8.EUF_CMA.qs{2} /\ DS5.EUF_CMA.sk{1} = skEnc DS8.EUF_CMA.sk{2} /\
            skrange DS8.EUF_CMA.sk{2}).
+ by proc; call sign78; auto.
+ by proc; auto.
+ proc*; call (: ={RO_pad.RO.m, RO_rest.RO.m, DS5.RO2.RO.m, DS5.RO3.RO.m, DS5.RO4.RO.m, DS5.RO5.RO.m,
                   Router.tr}); 2: by auto.
  by inline *; sim.
call (: ={DS5.RO3.RO.m}); 1: by sim.
inline RO_rest.RO.init RO_pad.RO.init; wp.
call keygen78.
by inline *; auto => />.
qed.

(* Hop 8: the scheme keeps the secret key decoded *)
lemma hop8 (qH qS : int) &m : 0 <= qH => 0 <= qS =>
  (forall (H1 <: DS2.POracle1 {-A}) (H2 <: DS2.POracle2 {-A}) (O <: DS2.SOracle {-A}),
     islossless H1.get => islossless H2.get => islossless O.sign =>
     islossless A(H1, H2, O).forge) =>
  (forall (H <: DS2.POracle1 {-A, -CountH, -CountS}) (G <: DS2.POracle2 {-A, -CountH, -CountS})
          (O <: DS2.SOracle {-A, -CountH, -CountS}),
     hoare [A(CountH(H), G, CountS(O)).forge :
              CountH.c = 0 /\ CountS.c = 0 ==> CountH.c <= qH /\ CountS.c <= qS]) =>
  Pr[DS2.EUF_CMA(DS2.RO1.RO, DS2.RO2.RO, MLDSA_RO_DS1, A).main() @ &m : res] <=
  Pr[DS8.EUF_CMA(DS5.RO1.RO, DS5.RO2.RO, DS5.RO3.RO, DS5.RO4.RO, DS5.RO5.RO, MLDSA_RO_DS8, Router(A)).main()
       @ &m : res] +
  2%r * p512 + (qH + qS * (1 + kappa_max) + 2)%r * p512 +
  ((qS * (qS + qH + 1))%r * p512 + (3 * qH + qS + 4)%r * p256).
proof.
move=> hqH hqS A_ll A_count.
by rewrite -(G7_G8 &m); apply (hop7 A qH qS &m hqH hqS A_ll A_count).
qed.

end section.
