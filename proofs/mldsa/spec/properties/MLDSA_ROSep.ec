require import AllCore IntDiv List Distr DList PROM.
from Jasmin require import JByte_array JWord.
require import Array256.

require import Parameters GFq Rq.
require import Spec65.
import MLDSA65.
import PolyLVec PolyKVec PolyMat.
import Round ZModQ Zq MLDSAParams.

require import MLDSA_RO.
require import DistrExtra JWordExtra StdBigop StdOrder.
require DS_ROM.

op dxi : Bytes32.t distr = dmap (dlist W8.dword 32) Bytes32.of_list.
op [lossless] drnd : rnd_ distr.

op dblock : W8.t list distr = dlist W8.dword 64.
op dbytes64 : Bytes64.t distr = dmap (dlist W8.dword 64) Bytes64.of_list.
op dbytesCT : BytesCT.t distr = dmap (dlist W8.dword (lambda %/ 4)) BytesCT.of_list.

(*************** ML-DSA with SHAKE256 and SHAKE128 as random oracles ****************)

clone import DS_ROM.DS_ROM_x2 as DS2 with
  type pkey    <- BytesPK.t,
  type skey    <- BytesSK.t,
  type msg     <- W8.t list,
  type sig     <- BytesSig.t,
  type leakage <- Leakage list,
  type RO1.in_t  <- W8.t list * int,
  type RO1.out_t <- W8.t list,
  op   RO1.dout  <- fun _ => dblock,
  type RO2.in_t  <- W8.t list * int,
  type RO2.out_t <- W8.t,
  op   RO2.dout  <- fun _ => W8.dword.

module MLDSA_RO_DS(H : BlockOracle, G : Oracle) = {
  proc keygen() : BytesPK.t * BytesSK.t = {
    var eps, sk, pk;
    eps <$ dxi;
    (sk, pk) <@ MLDSA_RO(H, G).keygen_derand(eps);
    return (pk, sk);
  }

  proc sign(sk : BytesSK.t, m : W8.t list) : BytesSig.t option * Leakage list = {
    var coins, r;
    coins <$ drnd;
    r <@ MLDSA_RO(H, G).sign_derand(sk, m, coins);
    return r;
  }

  proc verify(pk : BytesPK.t, m : W8.t list, s : BytesSig.t) : bool = {
    var b;
    b <@ MLDSA_RO(H, G).verify(pk, s, m);
    return b;
  }
}.

(*************** ML-DSA with separate random oracles ****************)

(* Public: XA (SHAKE128 bytes, ExpandA), XC (SHAKE256 blocks on c~, SampleInBall),
   Htr, Hmu, Hct (fixed-length outputs). *)
clone import DS_ROM.DS_ROM_x5 as DS5 with
  type pkey    <- BytesPK.t,
  type skey    <- BytesSK.t,
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

(* Hidden: SHAKE256 blocks used only by the scheme. *)
clone FullRO as RO_seed with
  type in_t  <- W8.t list * int,
  type out_t <- W8.t list,
  op   dout  <- fun _ => dblock.

clone FullRO as RO_S with
  type in_t  <- W8.t list * int,
  type out_t <- W8.t list,
  op   dout  <- fun _ => dblock.

clone FullRO as RO_rhopp with
  type in_t  <- W8.t list * int,
  type out_t <- W8.t list,
  op   dout  <- fun _ => dblock.

clone FullRO as RO_v with
  type in_t  <- W8.t list * int,
  type out_t <- W8.t list,
  op   dout  <- fun _ => dblock.

module MLDSA_ROSep(XA : DS5.POracle1, XC : DS5.POracle2,
                   Htr : DS5.POracle3, Hmu : DS5.POracle4, Hct : DS5.POracle5) = {
  proc keygen() : BytesPK.t * BytesSK.t = {
    var eps,sk,rho,rhop,_K,_A,s1,s2,t,t1,t0,pk,tr,epsp,bs;
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
    _A <@ ExpandA(XOFA_O(XA)).sample(rho);
    (s1,s2) <@ ExpandS(XOFS_O(RO_S.RO)).sample(rhop);
    t <- invnttv (ntt_mulmxv _A (nttv s1)) + s2;
    (t1,t0) <- Power2Round t;
    pk <@ PkEncDec.pkEncode(rho,t1);
    tr <@ Htr.get(pk);
    sk <@ SkEncDec.skEncode(rho,_K,tr,s1,s2,t0);
    return (pk,sk);
  }

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
     _A <@ ExpandA(XOFA_O(XA)).sample(rho);
     mu <@ Hmu.get(tr, m);
     bs <@ Squeeze(RO_rhopp.RO).squeeze(Bytes32.to_list _K ++ rnd_to_list coins ++ Bytes64.to_list mu, 64);
     rhopp <- Bytes64.of_list bs;
     kappa <- 0;
     zh <- None;
     while (zh = None && ! (kappa_max <= kappa)) {
       y <@ ExpandMask_O(RO_v.RO).sample(rhopp,kappa * lvec);
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

  proc verify(pk : BytesPK.t, m : W8.t list, sigma : BytesSig.t) : bool = {
    var rho,t1,c,l,ct,z,h,rb,_A,tr,mu,wapprox,w1,ctp;
    w1 <- witness;
    rb <- false;
    (rho,t1) <@ PkEncDec.pkDecode(pk);
    (ct,z,h) <@ SigEncDec.sigDecode(sigma);
    if (h <> None) {
      _A <@ ExpandA(XOFA_O(XA)).sample(rho);
      tr <@ Htr.get(pk);
      mu <@ Hmu.get(tr, m);
      (c,l) <@ SampleInBall_O(XC).sample(ct);
      wapprox <- invnttv (ntt_mulmxv _A (nttv z) - (ntt_smul (ntt c) (nttv (smul t1 (incoeff (2^d))))));
      w1 <- UseHint (oget h) wapprox;
      ctp <@ Hct.get(mu, w1Encode w1);
      rb <- infnorm_lt z (gamma1 - Beta);
      rb <- rb && ct = ctp;
    }
    return rb;
  }
}.

(*************** The reduction ****************)

(* SHAKE256 blocks for inputs outside the public domains *)
clone FullRO as RO_rest with
  type in_t  <- W8.t list * int,
  type out_t <- W8.t list,
  op   dout  <- fun _ => dblock.

(* The last 64 - lambda/4 bytes of block 0 on H_ct inputs *)
clone FullRO as RO_pad with
  type in_t    <- W8.t list,
  type out_t   <- W8.t list,
  op   dout    <- fun _ => dlist W8.dword (64 - lambda %/ 4),
  type d_in_t  <- unit,
  type d_out_t <- bool.

module Router(A : DS2.Adversary)
             (XA : DS5.POracle1, XC : DS5.POracle2,
              Htr : DS5.POracle3, Hmu : DS5.POracle4, Hct : DS5.POracle5,
              O : DS5.SOracle) = {
  var tr : Bytes64.t

  module H = {
    proc get(x : W8.t list * int) : W8.t list = {
      var b, o, oc, pad;
      b <- witness;
      if (take 64 x.`1 = Bytes64.to_list tr) {
        if (x.`2 = 0) {
          o <@ Hmu.get(tr, drop 64 x.`1);
          b <- Bytes64.to_list o;
        } else {
          b <@ RO_rest.RO.get(x);
        }
      } else {
        if (size x.`1 = 64 + w1_bytes) {
          if (x.`2 = 0) {
            oc <@ Hct.get(Bytes64.of_list (take 64 x.`1), BytesW1.of_list (drop 64 x.`1));
            pad <@ RO_pad.RO.get(x.`1);
            b <- BytesCT.to_list oc ++ pad;
          } else {
            b <@ RO_rest.RO.get(x);
          }
        } else {
          if (size x.`1 = lambda %/ 4) {
            b <@ XC.get(x);
          } else {
            if (size x.`1 = pk_bytes /\ x.`2 = 0) {
              o <@ Htr.get(BytesPK.of_list x.`1);
              b <- Bytes64.to_list o;
            } else {
              b <@ RO_rest.RO.get(x);
            }
          }
        }
      }
      return b;
    }
  }

  proc forge(pk : BytesPK.t) : W8.t list * BytesSig.t = {
    var r;
    RO_rest.RO.init();
    RO_pad.RO.init();
    tr <@ Htr.get(pk);
    r <@ A(H, XA, O).forge(pk);
    return r;
  }
}.

(*************** The hop ****************)

op p256 : real = (1%r / 256%r) ^ 32.
op p512 : real = (1%r / 256%r) ^ 64.

(* the uniform byte distributions: point and prefix/suffix masses *)
lemma mu1_dlist32 (c : W8.t list) : mu1 (dlist W8.dword 32) c <= p256.
proof. by rewrite /p256; apply mu1_dlist_le => //; [smt() | move=> w; rewrite DW8.mu1_dword]. qed.

lemma mu1_dblock (v : W8.t list) : mu1 dblock v <= p512.
proof. by rewrite /p512 /dblock; apply mu1_dlist_le => //; [smt() | move=> w; rewrite DW8.mu1_dword]. qed.

lemma mu_dblock_take (c : W8.t list) : mu dblock (fun r => take 32 r = c) <= p256.
proof.
rewrite /p256 /dblock (_ : 64 = 32 + 32) // mu_dlist_take_le //; 1: smt().
by move=> w; rewrite DW8.mu1_dword.
qed.

lemma mu_dblock_drop (c : W8.t list) : mu dblock (fun r => drop 32 r = c) <= p256.
proof.
rewrite /p256 /dblock (_ : 64 = 32 + 32) // mu_dlist_drop_le //; 1: smt().
by move=> w; rewrite DW8.mu1_dword.
qed.

(* one byte of a uniform block is a uniform byte *)
lemma mu_dblock_nth (k : int) (P : W8.t -> bool) :
  0 <= k < 64 => mu dblock (fun r => P (nth witness r k)) = mu W8.dword P.
proof. by move=> rgk; rewrite /dblock mu_dlist_nth // W8.dword_ll. qed.

lemma mu_dbytes64_nth (k : int) (P : W8.t -> bool) :
  0 <= k < 64 => mu dbytes64 (fun o => P (nth witness (Bytes64.to_list o) k)) = mu W8.dword P.
proof.
move=> rgk; rewrite /dbytes64 dmapE /(\o) /=.
rewrite -(mu_dlist_nth W8.dword 64 k witness P) // 1:W8.dword_ll.
by apply mu_eq_support => l _ /=; rewrite Bytes64.get_of_list.
qed.

lemma mu1_dxi (e : Bytes32.t) : mu1 dxi e <= p256.
proof.
rewrite /dxi dmap1E /(\o) /=.
apply (RealOrder.ler_trans (mu (dlist W8.dword 32) (pred1 (Bytes32.to_list e)))); 2: by apply mu1_dlist32.
by apply mu_le => l hl /= h; rewrite /pred1 -h Bytes32.of_listK //; move: hl; rewrite supp_dlist //; smt().
qed.

lemma mu1_dbytes64 (o : Bytes64.t) : mu1 dbytes64 o = mu1 dblock (Bytes64.to_list o).
proof.
rewrite /dbytes64 /dblock (dmap1E_can _ _ Bytes64.to_list) //.
by move=> l; rewrite supp_dlist // => -[hs _]; apply Bytes64.of_listK.
qed.

lemma mu_ct_tr (t : Bytes64.t) :
  mu dbytesCT (fun y => BytesCT.to_list y = Bytes64.to_list t) <= p512.
proof.
have hl : 0 <= lambda %/ 4 by have /= H := param_sets; smt().
rewrite /dbytesCT dmapE /(\o) /=.
apply (RealOrder.ler_trans (mu (dlist W8.dword (lambda %/ 4)) (pred1 (Bytes64.to_list t)))).
+ apply mu_le => l hl' /= h; rewrite /pred1 -h BytesCT.of_listK //.
  by move: hl'; rewrite supp_dlist //; smt().
rewrite dlist1E //; case: (lambda %/ 4 = size (Bytes64.to_list t)) => hs; 2: smt(RealOrder.expr_ge0).
rewrite (Bigreal.BRM.eq_bigr _ _ (fun _ => 1%r / 256%r)) /=.
+ by move=> w *; rewrite DW8.mu1_dword.
by rewrite Bigreal.mulr_const Bytes64.size_to_list /p512.
qed.

lemma dblock_take : dmap dblock (fun r => Bytes32.of_list (take 32 r)) = dxi.
proof.
rewrite /dblock (_ : 64 = 32 + 32) // dlist_add // dmap_comp /(\o) /=.
rewrite (eq_dmap_in _ _ (fun (p : W8.t list * W8.t list) => Bytes32.of_list p.`1)).
+ move=> [p1 p2] /supp_dprod /= [h1 _]; rewrite take_size_cat //; move: h1; rewrite supp_dlist //; case.
by rewrite dprod_marginalL (dlist_ll W8.dword 32 W8.dword_ll) dscalar1.
qed.

(* qH: SHAKE256 block queries of the adversary, qS: signing queries.
   Output events (p512 unless stated):
     pk begins with H_tr(pk);
     an H_mu output equals tr (qH + qS + 1 outputs);
     an H_ct output equals tr (qH + qS * kappa_max + 1 outputs; the forgery's c~ = tr
       verifies only if some H_ct output equals tr);
     rho' = tr; K prefix of tr (p256); rho'' = tr and rho'' = rho' (qS values of rho'').
   Adversary events, per SHAKE256 query: input begins with xi (p256), with rho'
     (p512), with K (p256), or with one of qS values of rho'' (p512 each). *)
op eps_sep (qH qS : int) : real =
    (4 + 2 * qH + 3 * qS + qS * kappa_max)%r * p512 + p256
  + qH%r * (2%r * p256 + (qS + 1)%r * p512).

module CountH(H : DS2.POracle1) = {
  var c : int
  proc get(x : W8.t list * int) : W8.t list = {
    var b;
    c <- c + 1;
    b <@ H.get(x);
    return b;
  }
}.

module CountS(O : DS2.SOracle) = {
  var c : int
  proc sign(m : W8.t list) : BytesSig.t option * Leakage list = {
    var r;
    c <- c + 1;
    r <@ O.sign(m);
    return r;
  }
}.

