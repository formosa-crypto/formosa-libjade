require import AllCore IntDiv List Distr DList PROM FMap.
from Jasmin require import JByte_array JWord.
require import Array256.

require import Parameters GFq Rq.
require import Spec65.
import MLDSA65.
import PolyLVec PolyKVec PolyMat.
import Round ZModQ Zq MLDSAParams.

require import MLDSA_RO MLDSA_ROSep MLDSA_ROSep_Hop1 MLDSA_ROSep_Hop2 MLDSA_ROSep_Hop3.
require import MLDSA_ROSep_Hop4 MLDSA_ROSep_Hop5 MLDSA_ROSep_Hop6 MLDSA_ROSep_Hop7 MLDSA_ROSep_Hop8.
require import MLDSA_ROSep_Hop9 MLDSA_ROSep_Hop10.
require DS_ROM.

(*************** G11: SampleInBall reads a byte stream on c~ ****************)

clone DS_ROM.DS_ROM_x5 as DS11 with
  type pkey    <- BytesPK.t,
  type skey    <- Bytes32.t * Bytes64.t * polylvec * polykvec * polykvec,
  type msg     <- W8.t list,
  type sig     <- BytesSig.t,
  type leakage <- Leakage list,
  type RO1.in_t  <- W8.t list * int,
  type RO1.out_t <- W8.t,
  op   RO1.dout  <- fun _ => W8.dword,
  type RO2.in_t  <- W8.t list * int,
  type RO2.out_t <- W8.t,
  op   RO2.dout  <- fun _ => W8.dword,
  type RO3.in_t  <- BytesPK.t,
  type RO3.out_t <- Bytes64.t,
  op   RO3.dout  <- fun _ => dbytes64,
  type RO4.in_t  <- Bytes64.t * W8.t list,
  type RO4.out_t <- Bytes64.t,
  op   RO4.dout  <- fun _ => dbytes64,
  type RO5.in_t  <- polykvec * Bytes64.t,
  type RO5.out_t <- BytesCT.t,
  op   RO5.dout  <- fun _ => dbytesCT.

(* SHAKE256 bytes on c~ *)
clone FullRO as RO_xc with
  type in_t    <- W8.t list * int,
  type out_t   <- W8.t,
  op   dout    <- fun _ => W8.dword,
  type d_in_t  <- unit,
  type d_out_t <- bool.

clone DList.Program as PW with
  type t <- W8.t,
  op   d <- W8.dword.

(* Block j of the stream on x, as 64 bytes *)
module BlockOf(G : DS11.POracle2) = {
  proc get(x : W8.t list * int) : W8.t list = {
    var i, b, bs;
    bs <- [];
    i <- 0;
    while (i < 64) {
      b <@ G.get(x.`1, 64 * x.`2 + i);
      bs <- bs ++ [b];
      i <- i + 1;
    }
    return bs;
  }
}.

(* Byte p of the stream on x, with the rest of its block sampled through P *)
module XCP(P : RO_xc.RO) = {
  proc get(x : W8.t list * int) : W8.t = {
    var i, r;
    r <- witness;
    i <- 0;
    while (i < 64) {
      if (i = x.`2 %% 64) {
        r <@ P.get(x.`1, 64 * (x.`2 %/ 64) + i);
      } else {
        P.sample(x.`1, 64 * (x.`2 %/ 64) + i);
      }
      i <- i + 1;
    }
    return r;
  }
}.

module SqueezeB(G : DS11.POracle2) = {
  proc squeeze(x : W8.t list, len : int) : W8.t list = {
    var r, b, i;
    r <- [];
    i <- 0;
    while (i < len) {
      b <@ G.get(x, i);
      r <- r ++ [b];
      i <- i + 1;
    }
    return r;
  }
}.

module SampleInBall_B(G : DS11.POracle2) = {
   proc sample(rho : BytesCT.t) : poly * sib_leakage = {
      var leakage : bool list;
      var s : Bytes8.t;
      var h : bool list;
      var i,j,bs,pos;
      var c : poly;
      leakage <- [];
      c <- poly_zero;
      bs <@ SqueezeB(G).squeeze(BytesCT.to_list rho, 8);
      s <- Bytes8.of_list bs;
      h <- BytesToBits (Bytes8.to_list s);
      pos <- 8;
      i <- 256 - tau;
      while (i < 256) {
          j <@ G.get(BytesCT.to_list rho, pos);
          pos <- pos + 1;
          while(i < W8.to_uint j) {
            leakage <- leakage ++ [true];
            j <@ G.get(BytesCT.to_list rho, pos);
            pos <- pos + 1;
          }
          leakage <- leakage ++ [false];
          c.[i] <- c.[W8.to_uint j];
          c.[W8.to_uint j] <- if h.[i+tau-256] then incoeff (-1) else incoeff (1);
          i <- i + 1;
      }
      return (c,leakage);
   }
}.

module Router11(A : DS2.Adversary)
               (XA : DS11.POracle1, XC : DS11.POracle2,
                Htr : DS11.POracle3, Hmu : DS11.POracle4, Hct : DS11.POracle5,
                O : DS11.SOracle) = {
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
            oc <@ HctRoute(Hct).get(Bytes64.of_list (take 64 x.`1), BytesW1.of_list (drop 64 x.`1));
            pad <@ RO_pad.RO.get(x.`1);
            b <- BytesCT.to_list oc ++ pad;
          } else {
            b <@ RO_rest.RO.get(x);
          }
        } else {
          if (size x.`1 = lambda %/ 4) {
            b <@ BlockOf(XC).get(x);
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
    RO_hr.RO.init();
    tr <@ Htr.get(pk);
    r <@ A(H, XA, O).forge(pk);
    return r;
  }
}.

module MLDSA_RO_DS11(XA : DS11.POracle1, XC : DS11.POracle2, Htr : DS11.POracle3, Hmu : DS11.POracle4,
                     Hct : DS11.POracle5) = {
  proc keygen = MLDSA_RO_DS10(XA, BlockOf(XC), Htr, Hmu, Hct).keygen

  proc sign(sk : Bytes32.t * Bytes64.t * polylvec * polykvec * polykvec, m : W8.t list) :
    BytesSig.t option * Leakage list = {
     var coins,rho,tr,s1,s2,t0,_A,mu,kappa,y,w,w1,ctl,ct,c,cs1,cs2,z,r0,ct0,h,leakage,sigma,bz,bh,sl;
     var zh : (polylvec * polykvec) option;
     coins <$ drnd;
     ct <- witness;
     ctl <- witness;
     sigma <- witness;
     leakage <- [];
     (rho,tr,s1,s2,t0) <- sk;
     _A <@ ExpandA(XOFA_O(XA)).sample(rho);
     mu <@ Hmu.get(tr, m);
     kappa <- 0;
     zh <- None;
     while (zh = None && ! (kappa_max <= kappa)) {
       y <@ RO_y.RO.get(coins, mu, kappa);
       w <- mulmxv (invnttm _A) y;
       w1 <- polykvec_HighBits w;
       ct <@ Hct.get(w1, mu);
       (c, sl) <@ SampleInBall_B(XC).sample(ct);
       ctl <- ((ct, c), sl);
       leakage <- leakage ++ [ RO ctl.`2] ;
       cs1 <- psmul c s1;
       cs2 <- psmul c s2;
       z <- y + cs1;
       r0 <- polykvec_LowBits (w - cs2);
       bz <- infnorm_lt z (gamma1 - Beta) &&
                  infnorm_lt r0 (gamma2 - Beta);
       leakage <- leakage ++ [ CheckZ bz ];
       if (bz) {
          ct0 <- psmul c t0;
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
      (c,l) <@ SampleInBall_B(XC).sample(ct);
      wapprox <- mulmxv (invnttm _A) z - psmul c (smul t1 (incoeff (2^d)));
      w1 <- UseHint (oget h) wapprox;
      ctp <@ Hct.get(w1, mu);
      rb <- infnorm_lt z (gamma1 - Beta);
      rb <- rb && ct = ctp;
    }
    return rb;
  }
}.

(*************** Blocks and bytes ****************)

(* The blocks of G10 and the bytes of G11 *)
op blkrel (mb : (W8.t list * int, W8.t list) fmap) (mw : (W8.t list * int, W8.t) fmap) : bool =
     (forall y j k, 0 <= k < 64 => mw.[(y, 64 * j + k)] = omap (fun b => nth witness b k) mb.[(y, j)])
  /\ (forall x b, mb.[x] = Some b => size b = 64).

equiv blk_get (x0 : W8.t list * int) : DS5.RO2.RO.get ~ BlockOf(RO_xc.RO).get :
  ={x} /\ x{1} = x0 /\ blkrel DS5.RO2.RO.m{1} RO_xc.RO.m{2}
  ==> ={res} /\ blkrel DS5.RO2.RO.m{1} RO_xc.RO.m{2} /\ DS5.RO2.RO.m{1}.[x0] = Some res{1}.
proof.
proc; inline RO_xc.RO.get; sp 0 2.
case: (x{1} \in DS5.RO2.RO.m{1}).
+ rcondf{1} 2; 1: by auto.
  while{2} (0 <= i{2} <= 64 /\ bs{2} = take i{2} (oget DS5.RO2.RO.m{1}.[x{1}]) /\ x{1} = x{2} /\ x{1} = x0 /\
            blkrel DS5.RO2.RO.m{1} RO_xc.RO.m{2} /\ x{1} \in DS5.RO2.RO.m{1}) (64 - i{2}).
  - move=> &1 z; auto => /> &hr h0 h64 hr hs hin hi; split; 1: exact W8.dword_ll.
    move=> _ v _ _.
    have [b hb] : exists b, DS5.RO2.RO.m{1}.[x{1}] = Some b
      by move: hin; rewrite domE; case: (DS5.RO2.RO.m{1}.[x{1}]) => // b _; exists b.
    have hk := hr x{1}.`1 x{1}.`2 i{hr} _; 1: smt().
    rewrite (_ : (x{1}.`1, x{1}.`2) = x{1}) 1:/# hb /= in hk.
    have hsb := hs _ _ hb.
    split => hn; 1: by move: hn; rewrite domE hk.
    by rewrite hk hb /= (take_nth witness) 1:/# cats1 /#.
  rnd{1}; auto => /> &1 &2 hr hs hin r0 _; split; 1: by rewrite take0.
  move=> mR iR; split; 1: smt().
  move=> hi h0 h64 _ _.
  have [b hb] : exists b, DS5.RO2.RO.m{1}.[x0] = Some b
    by move: hin; rewrite domE; case: (DS5.RO2.RO.m{1}.[x0]) => // b _; exists b.
  by rewrite hb /= take_oversize // (hs _ _ hb) /#.
rcondt{1} 2; 1: by auto.
outline{1} [1 .. 1] by { r <@ PW.Sample.sample(64); }.
transitivity{1} { r <@ PW.LoopSnoc.sample(64); DS5.RO2.RO.m.[x] <- r; }
  (={x, DS5.RO2.RO.m} ==> ={x, DS5.RO2.RO.m})
  ((bs{2} = [] /\ i{2} = 0 /\ x{1} = x{2} /\ x{1} = x0 /\ blkrel DS5.RO2.RO.m{1} RO_xc.RO.m{2}) /\
   x{1} \notin DS5.RO2.RO.m{1}
   ==> oget DS5.RO2.RO.m{1}.[x{1}] = bs{2} /\ blkrel DS5.RO2.RO.m{1} RO_xc.RO.m{2} /\
       DS5.RO2.RO.m{1}.[x0] = Some (oget DS5.RO2.RO.m{1}.[x{1}])).
+ by move=> &1 &2 h; exists DS5.RO2.RO.m{1} x{1}.
+ by move=> /#.
+ by wp; call PW.Sample_LoopSnoc_eq; auto.
inline PW.LoopSnoc.sample; wp.
while (={i} /\ n{1} = 64 /\ l{1} = bs{2} /\ size bs{2} = i{2} /\ 0 <= i{2} <= 64 /\ x{1} = x{2} /\ x{1} = x0 /\
       (forall k, 0 <= k < 64 => RO_xc.RO.m{2}.[(x{2}.`1, 64 * x{2}.`2 + k)] =
                                 if k < i{2} then Some (nth witness bs{2} k) else None) /\
       (forall y j k, 0 <= k < 64 => (y, j) <> x{2} =>
          RO_xc.RO.m{2}.[(y, 64 * j + k)] = omap (fun b => nth witness b k) DS5.RO2.RO.m{1}.[(y, j)]) /\
       (forall z b, DS5.RO2.RO.m{1}.[z] = Some b => size b = 64)).
+ auto => /> &1 &2 h0 h64 h1 h2 hs hi r0 _.
  have hnone : RO_xc.RO.m{2}.[(x0.`1, 64 * x0.`2 + size bs{2})] = None by have := h1 (size bs{2}) _; smt().
  split => hin; 2: by move: hin; rewrite domE hnone.
  rewrite get_set_sameE /= size_cat /=; split; 1: smt().
  split => [k hk0 hk1 | y j k hk0 hk1 hne].
  + rewrite get_setE nth_cat; case: (k = size bs{2}) => [-> /= | hk]; 1: smt().
    have -> /= : (x0.`1, 64 * x0.`2 + k) <> (x0.`1, 64 * x0.`2 + size bs{2}) by smt().
    by rewrite h1 //; smt().
  have hne' : (y, 64 * j + k) <> (x0.`1, 64 * x0.`2 + size bs{2}) by smt(euclideU).
  by rewrite get_setE hne' /=; apply h2.
auto => /> &1 &2 hr hs hn; split.
+ split => [k hk0 hk1 | y j k hk0 hk1 _]; 2: by apply hr.
  rewrite (_ : k < 0 = false) 1:/# /= hr // (_ : (x0.`1, x0.`2) = x0) 1:/#.
  by move: hn; rewrite domE => /= ->.
move=> mR bs h64 _ h0 h64' h1 h2; rewrite !get_set_sameE /=.
have hsz : size bs = 64 by smt().
split => [y j k hk0 hk1 | z b].
+ rewrite get_setE; case: ((y, j) = x0) => [hyj | hne] /=; 2: by apply h2.
  have [-> ->] : y = x0.`1 /\ j = x0.`2 by smt().
  by rewrite h1 //; smt().
by rewrite get_setE; case: (z = x0) => /= _; [move=> <- | apply hs]; smt().
qed.

equiv xcp_blk (x0 : W8.t list * int) : XCP(RO_xc.RO).get ~ BlockOf(RO_xc.RO).get :
  x{1} = x0 /\ x{2} = (x0.`1, x0.`2 %/ 64) /\ ={RO_xc.RO.m}
  ==> res{1} = nth witness res{2} (x0.`2 %% 64) /\ ={RO_xc.RO.m}.
proof.
proc; inline RO_xc.RO.sample.
while (={i, RO_xc.RO.m} /\ x{1} = x0 /\ x{2} = (x0.`1, x0.`2 %/ 64) /\ size bs{2} = i{2} /\ 0 <= i{2} <= 64 /\
       (x0.`2 %% 64 < i{1} => r{1} = nth witness bs{2} (x0.`2 %% 64))).
+ if{1}; inline *; auto => />.
  - move=> &1 &2 h0 h64 hr hi heq r0 _; split => _; rewrite size_cat nth_cat -heq /=; smt().
  move=> &1 &2 h0 h64 hr hi hne r0 _; split => _; rewrite size_cat nth_cat /=; smt().
by auto => />; smt(modz_ge0 ltz_pmod).
qed.

equiv blk_xcp (x0 : W8.t list * int) : DS5.RO2.RO.get ~ XCP(RO_xc.RO).get :
  x{1} = (x0.`1, x0.`2 %/ 64) /\ x{2} = x0 /\ blkrel DS5.RO2.RO.m{1} RO_xc.RO.m{2}
  ==> res{2} = nth witness res{1} (x0.`2 %% 64) /\ blkrel DS5.RO2.RO.m{1} RO_xc.RO.m{2} /\
      DS5.RO2.RO.m{1}.[(x0.`1, x0.`2 %/ 64)] = Some res{1}.
proof.
transitivity BlockOf(RO_xc.RO).get
  (={x} /\ x{1} = (x0.`1, x0.`2 %/ 64) /\ blkrel DS5.RO2.RO.m{1} RO_xc.RO.m{2}
   ==> ={res} /\ blkrel DS5.RO2.RO.m{1} RO_xc.RO.m{2} /\ DS5.RO2.RO.m{1}.[(x0.`1, x0.`2 %/ 64)] = Some res{1})
  (x{1} = (x0.`1, x0.`2 %/ 64) /\ x{2} = x0 /\ ={RO_xc.RO.m}
   ==> res{2} = nth witness res{1} (x0.`2 %% 64) /\ ={RO_xc.RO.m}).
+ by move=> &1 &2 h; exists RO_xc.RO.m{2} (x0.`1, x0.`2 %/ 64); smt().
+ smt().
+ exact (blk_get (x0.`1, x0.`2 %/ 64)).
by symmetry; conseq (xcp_blk x0).
qed.

lemma xcp_present (mb : (W8.t list * int, W8.t list) fmap) (mw : (W8.t list * int, W8.t) fmap)
                  (x0 : W8.t list * int) :
  phoare [XCP(RO_xc.RO).get : x = x0 /\ RO_xc.RO.m = mw /\ blkrel mb mw /\ (x0.`1, x0.`2 %/ 64) \in mb
          ==> RO_xc.RO.m = mw /\ res = nth witness (oget mb.[(x0.`1, x0.`2 %/ 64)]) (x0.`2 %% 64)] = 1%r.
proof.
proc; inline RO_xc.RO.sample.
while (x = x0 /\ RO_xc.RO.m = mw /\ blkrel mb mw /\ (x0.`1, x0.`2 %/ 64) \in mb /\ 0 <= i <= 64 /\
       (x0.`2 %% 64 < i => r = nth witness (oget mb.[(x0.`1, x0.`2 %/ 64)]) (x0.`2 %% 64))) (64 - i).
+ move=> z; if; inline *; auto => />.
  - move=> hr hs hin h0 _ h64; split; 1: exact W8.dword_ll.
    move=> _ v _ _.
    have [b hb] : exists b, mb.[(x0.`1, x0.`2 %/ 64)] = Some b
      by move: hin; rewrite domE; case: (mb.[(x0.`1, x0.`2 %/ 64)]) => // b _; exists b.
    have hk := hr x0.`1 (x0.`2 %/ 64) (x0.`2 %% 64) _; 1: smt().
    rewrite hb /= in hk.
    split => hn; 1: by move: hn; rewrite domE hk.
    by rewrite hk hb /=; smt().
  move=> &hr hr hs hin h0 h64 hri hi hne; split; 1: exact W8.dword_ll.
  move=> _ v _ _.
  have [b hb] : exists b, mb.[(x0.`1, x0.`2 %/ 64)] = Some b
    by move: hin; rewrite domE; case: (mb.[(x0.`1, x0.`2 %/ 64)]) => // b _; exists b.
  have hk := hr x0.`1 (x0.`2 %/ 64) i{hr} _; 1: smt().
  rewrite hb /= in hk.
  split => hn; 1: by move: hn; rewrite domE hk.
  smt().
by auto => />; smt(modz_ge0 ltz_pmod).
qed.

(* The first 8 bytes: one block in G10, eight bytes in G11 *)
equiv squeeze8 : Squeeze(DS5.RO2.RO).squeeze ~ SqueezeB(XCP(RO_xc.RO)).squeeze :
  ={x, len} /\ len{1} = 8 /\ blkrel DS5.RO2.RO.m{1} RO_xc.RO.m{2}
  ==> ={res} /\ blkrel DS5.RO2.RO.m{1} RO_xc.RO.m{2}.
proof.
proc.
rcondt{1} 3; 1: by auto.
rcondf{1} 6; 1: by auto; call (: true); auto.
unroll{2} 3; rcondt{2} 3; 1: by auto.
seq 3 3 : (b{2} = nth witness b{1} 0 /\ ={x, len} /\ len{1} = 8 /\ i{2} = 0 /\ j{1} = 0 /\ r{1} = [] /\
           r{2} = [] /\ blkrel DS5.RO2.RO.m{1} RO_xc.RO.m{2} /\ DS5.RO2.RO.m{1}.[(x{1}, 0)] = Some b{1}).
+ by exlim x{2} => xx; call (blk_xcp (xx, 0)); auto => />.
while{2} (r{2} = take i{2} b{1} /\ 1 <= i{2} <= 8 /\ len{2} = 8 /\ x{2} = x{1} /\
          blkrel DS5.RO2.RO.m{1} RO_xc.RO.m{2} /\ DS5.RO2.RO.m{1}.[(x{1}, 0)] = Some b{1}) (8 - i{2}).
+ move=> &1 z; wp; exlim RO_xc.RO.m, x, i => mw xx ii.
  call (xcp_present DS5.RO2.RO.m{1} mw (xx, ii)); auto => />.
  move=> h1 h8 hr hs hb hi; have hsz := hs _ _ hb.
  by rewrite divz_small 1:/# modz_small 1:/# domE hb /= cats1 (take_nth witness) 1:/#; smt().
auto => /> &1 &2 hr hs hb; have := hs _ _ hb; case: (b{1}) => [| c l] //= _; split; 1: by rewrite take0.
smt().
qed.

equiv rb_xcp : ReadByte(DS5.RO2.RO).read ~ XCP(RO_xc.RO).get :
  x{2} = (x{1}, p{1}) /\ blkrel DS5.RO2.RO.m{1} RO_xc.RO.m{2} ==> ={res} /\ blkrel DS5.RO2.RO.m{1} RO_xc.RO.m{2}.
proof.
proc*; inline{1} ReadByte(DS5.RO2.RO).read; wp.
by exlim x{2} => xx; call (blk_xcp xx); auto => />.
qed.

equiv sib11 : SampleInBall_O(DS5.RO2.RO).sample ~ SampleInBall_B(XCP(RO_xc.RO)).sample :
  ={rho} /\ blkrel DS5.RO2.RO.m{1} RO_xc.RO.m{2} ==> ={res} /\ blkrel DS5.RO2.RO.m{1} RO_xc.RO.m{2}.
proof.
proc.
while (={i, c, h, leakage, pos, rho} /\ blkrel DS5.RO2.RO.m{1} RO_xc.RO.m{2}).
+ wp; while (={i, j, c, h, leakage, pos, rho} /\ blkrel DS5.RO2.RO.m{1} RO_xc.RO.m{2}).
  + by wp; call rb_xcp; auto.
  by wp; call rb_xcp; auto.
by wp; call squeeze8; auto.
qed.

(* With the lazy oracle, XCP reads one byte *)
equiv xcp_lro : XCP(RO_xc.LRO).get ~ RO_xc.RO.get : ={x, RO_xc.RO.m} ==> ={res, RO_xc.RO.m}.
proof.
proc*; inline{1} XCP(RO_xc.LRO).get; inline RO_xc.LRO.sample.
splitwhile{1} 4 : (i < x0.`2 %% 64).
seq 4 0 : (i{1} = x0{1}.`2 %% 64 /\ x0{1} = x{2} /\ ={RO_xc.RO.m}).
+ while{1} (0 <= i{1} <= x0{1}.`2 %% 64 /\ x0{1} = x{2} /\ ={RO_xc.RO.m}) (x0{1}.`2 %% 64 - i{1}).
  - move=> &2 z; rcondf 1; 1: by auto => /#.
    by auto => /#.
  by auto => />; smt(modz_ge0 ltz_pmod).
unroll{1} 1; rcondt{1} 1; 1: by auto => />; smt(ltz_pmod).
rcondt{1} 1; 1: by auto.
seq 1 1 : (r0{1} = r{2} /\ i{1} = x0{1}.`2 %% 64 /\ x0{1} = x{2} /\ ={RO_xc.RO.m}).
+ call (: ={RO_xc.RO.m}); 1: by sim.
  by auto => />; smt(divz_eq).
wp; while{1} (x0{1}.`2 %% 64 < i{1} <= 64 /\ r0{1} = r{2} /\ ={RO_xc.RO.m}) (64 - i{1}).
+ move=> &2 z; rcondf 1; 1: by auto => /#.
  by auto => /#.
by auto => />; smt(ltz_pmod).
qed.

equiv sib_lro : SampleInBall_B(XCP(RO_xc.LRO)).sample ~ SampleInBall_B(RO_xc.RO).sample :
  ={rho, RO_xc.RO.m} ==> ={res, RO_xc.RO.m}.
proof.
proc.
while (={i, c, h, leakage, pos, rho, RO_xc.RO.m}).
+ wp; while (={i, j, c, h, leakage, pos, rho, RO_xc.RO.m}); 1: by wp; call xcp_lro; auto.
  by wp; call xcp_lro; auto.
wp; call (: ={RO_xc.RO.m}); 2: by auto.
while (={i, r, len, x, RO_xc.RO.m}); 2: by auto.
by wp; call xcp_lro; auto.
qed.

(*************** The scheme ****************)

equiv keygen1011 :
  MLDSA_RO_DS10(DS5.RO1.RO, DS5.RO2.RO, DS5.RO3.RO, DS5.RO4.RO, DS10.RO5.RO).keygen ~
  MLDSA_RO_DS11(DS5.RO1.RO, XCP(RO_xc.RO), DS5.RO3.RO, DS5.RO4.RO, DS10.RO5.RO).keygen :
  ={glob DS5.RO1.RO, DS5.RO3.RO.m, glob XOFA_O}
  ==> ={res, glob DS5.RO1.RO, DS5.RO3.RO.m, glob XOFA_O, RO_y.RO.m}.
proof. by sim. qed.

equiv sign1011 :
  MLDSA_RO_DS10(DS5.RO1.RO, DS5.RO2.RO, DS5.RO3.RO, DS5.RO4.RO, DS10.RO5.RO).sign ~
  MLDSA_RO_DS11(DS5.RO1.RO, XCP(RO_xc.RO), DS5.RO3.RO, DS5.RO4.RO, DS10.RO5.RO).sign :
  ={sk, m, glob DS5.RO1.RO, DS5.RO4.RO.m, DS10.RO5.RO.m, glob XOFA_O, RO_y.RO.m} /\
  blkrel DS5.RO2.RO.m{1} RO_xc.RO.m{2}
  ==> ={res, glob DS5.RO1.RO, DS5.RO4.RO.m, DS10.RO5.RO.m, glob XOFA_O, RO_y.RO.m} /\
      blkrel DS5.RO2.RO.m{1} RO_xc.RO.m{2}.
proof.
proc.
seq 10 10 : (={coins, ct, ctl, sigma, leakage, rho, tr, s1, s2, t0, _A, mu, kappa, zh, glob DS5.RO1.RO,
               DS5.RO4.RO.m, DS10.RO5.RO.m, glob XOFA_O, RO_y.RO.m} /\
             blkrel DS5.RO2.RO.m{1} RO_xc.RO.m{2}).
+ wp; call (: ={DS5.RO4.RO.m}); 1: by sim.
  call (: ={glob DS5.RO1.RO, glob XOFA_O}); 1: by sim.
  by auto.
seq 1 1 : (={zh, ct, sigma, leakage, glob DS5.RO1.RO, DS5.RO4.RO.m, DS10.RO5.RO.m, glob XOFA_O, RO_y.RO.m} /\
           blkrel DS5.RO2.RO.m{1} RO_xc.RO.m{2}).
+ while (={coins, ct, ctl, sigma, leakage, s1, s2, t0, _A, mu, kappa, zh, glob DS5.RO1.RO, DS5.RO4.RO.m,
           DS10.RO5.RO.m, glob XOFA_O, RO_y.RO.m} /\
         blkrel DS5.RO2.RO.m{1} RO_xc.RO.m{2}); 2: by auto.
  wp; call sib11.
  wp; call (: ={DS10.RO5.RO.m}); 1: by sim.
  wp; call (: ={RO_y.RO.m}); 1: by sim.
  by auto.
by if => //; wp; call (: true); [by sim | auto].
qed.

equiv verify1011 :
  MLDSA_RO_DS10(DS5.RO1.RO, DS5.RO2.RO, DS5.RO3.RO, DS5.RO4.RO, DS10.RO5.RO).verify ~
  MLDSA_RO_DS11(DS5.RO1.RO, XCP(RO_xc.RO), DS5.RO3.RO, DS5.RO4.RO, DS10.RO5.RO).verify :
  ={pk, m, sigma, glob DS5.RO1.RO, DS5.RO3.RO.m, DS5.RO4.RO.m, DS10.RO5.RO.m, glob XOFA_O} /\
  blkrel DS5.RO2.RO.m{1} RO_xc.RO.m{2}
  ==> ={res}.
proof.
proc.
seq 4 4 : (={pk, m, rho, t1, ct, z, h, rb, w1, glob DS5.RO1.RO, DS5.RO3.RO.m, DS5.RO4.RO.m, DS10.RO5.RO.m,
             glob XOFA_O} /\
           blkrel DS5.RO2.RO.m{1} RO_xc.RO.m{2}).
+ by call (: true); [by sim | call (: true); [by sim | auto]].
if => //.
wp; call (: ={DS10.RO5.RO.m}); 1: by sim.
wp; call sib11.
call (: ={DS5.RO4.RO.m}); 1: by sim.
call (: ={DS5.RO3.RO.m}); 1: by sim.
by call (: ={glob DS5.RO1.RO, glob XOFA_O}); [by sim | auto].
qed.

equiv keygen11b :
  MLDSA_RO_DS11(DS5.RO1.RO, XCP(RO_xc.LRO), DS5.RO3.RO, DS5.RO4.RO, DS10.RO5.RO).keygen ~
  MLDSA_RO_DS11(DS5.RO1.RO, RO_xc.RO, DS5.RO3.RO, DS5.RO4.RO, DS10.RO5.RO).keygen :
  ={glob DS5.RO1.RO, DS5.RO3.RO.m, glob XOFA_O}
  ==> ={res, glob DS5.RO1.RO, DS5.RO3.RO.m, glob XOFA_O, RO_y.RO.m}.
proof. by sim. qed.

equiv sign11b :
  MLDSA_RO_DS11(DS5.RO1.RO, XCP(RO_xc.LRO), DS5.RO3.RO, DS5.RO4.RO, DS10.RO5.RO).sign ~
  MLDSA_RO_DS11(DS5.RO1.RO, RO_xc.RO, DS5.RO3.RO, DS5.RO4.RO, DS10.RO5.RO).sign :
  ={sk, m, glob DS5.RO1.RO, RO_xc.RO.m, DS5.RO4.RO.m, DS10.RO5.RO.m, glob XOFA_O, RO_y.RO.m}
  ==> ={res, glob DS5.RO1.RO, RO_xc.RO.m, DS5.RO4.RO.m, DS10.RO5.RO.m, glob XOFA_O, RO_y.RO.m}.
proof.
proc.
seq 11 11 : (={zh, ct, sigma, leakage, glob DS5.RO1.RO, RO_xc.RO.m, DS5.RO4.RO.m, DS10.RO5.RO.m, glob XOFA_O,
               RO_y.RO.m}); 2: by sim.
while (={coins, ct, ctl, sigma, leakage, s1, s2, t0, _A, mu, kappa, zh, glob DS5.RO1.RO, RO_xc.RO.m,
         DS5.RO4.RO.m, DS10.RO5.RO.m, glob XOFA_O, RO_y.RO.m}).
+ wp; call sib_lro.
  wp; call (: ={DS10.RO5.RO.m}); 1: by sim.
  wp; call (: ={RO_y.RO.m}); 1: by sim.
  by auto.
wp; call (: ={DS5.RO4.RO.m}); 1: by sim.
call (: ={glob DS5.RO1.RO, glob XOFA_O}); 1: by sim.
by auto.
qed.

equiv verify11b :
  MLDSA_RO_DS11(DS5.RO1.RO, XCP(RO_xc.LRO), DS5.RO3.RO, DS5.RO4.RO, DS10.RO5.RO).verify ~
  MLDSA_RO_DS11(DS5.RO1.RO, RO_xc.RO, DS5.RO3.RO, DS5.RO4.RO, DS10.RO5.RO).verify :
  ={pk, m, sigma, glob DS5.RO1.RO, RO_xc.RO.m, DS5.RO3.RO.m, DS5.RO4.RO.m, DS10.RO5.RO.m, glob XOFA_O}
  ==> ={res}.
proof.
proc.
seq 4 4 : (={pk, m, rho, t1, ct, z, h, rb, w1, glob DS5.RO1.RO, RO_xc.RO.m, DS5.RO3.RO.m, DS5.RO4.RO.m,
             DS10.RO5.RO.m, glob XOFA_O}); 1: by sim.
if => //.
wp; call (: ={DS10.RO5.RO.m}); 1: by sim.
wp; call sib_lro.
call (: ={DS5.RO4.RO.m}); 1: by sim.
call (: ={DS5.RO3.RO.m}); 1: by sim.
by call (: ={glob DS5.RO1.RO, glob XOFA_O}); [by sim | auto].
qed.

section.

declare module A <: DS2.Adversary {
  -DS2.RO1.RO, -DS2.RO2.RO, -DS2.EUF_CMA, -XOFA_O, -XOFS_O, -MLDSA_RO_DS1, -RoutedH,
  -DS5.RO1.RO, -DS5.RO2.RO, -DS5.RO3.RO, -DS5.RO4.RO, -DS5.RO5.RO, -DS5.EUF_CMA, -RO_rest.RO,
  -RO_pad.RO, -RO_pad.FRO, -RO_seed.RO, -RO_S.RO, -RO_rhopp.RO, -RO_v.RO, -CountH, -CountS, -St5,
  -RO_lp.RO, -RO_lp.FRO, -St6, -St7, -Router, -RO_y.RO, -DS8.EUF_CMA, -DS10.EUF_CMA, -DS10.RO5.RO,
  -RO_hr.RO, -Router10, -DS11.EUF_CMA, -RO_xc.RO, -RO_xc.FRO, -Router11 }.

(* G11 with the byte oracle as a parameter *)
local module D11 (P : RO_xc.RO) = {
  module OS = {
    proc sign(m : W8.t list) : BytesSig.t option * Leakage list = {
      var r;
      DS11.EUF_CMA.qs <- m :: DS11.EUF_CMA.qs;
      r <@ MLDSA_RO_DS11(DS5.RO1.RO, XCP(P), DS5.RO3.RO, DS5.RO4.RO, DS10.RO5.RO).sign(DS11.EUF_CMA.sk, m);
      return r;
    }
  }

  proc distinguish() : bool = {
    var pk, sk, m, s, b;
    DS5.RO1.RO.init();
    DS5.RO3.RO.init();
    DS5.RO4.RO.init();
    DS10.RO5.RO.init();
    DS11.EUF_CMA.qs <- [];
    (pk, sk) <@ MLDSA_RO_DS11(DS5.RO1.RO, XCP(P), DS5.RO3.RO, DS5.RO4.RO, DS10.RO5.RO).keygen();
    DS11.EUF_CMA.sk <- sk;
    (m, s) <@ Router11(A, DS5.RO1.RO, P, DS5.RO3.RO, DS5.RO4.RO, DS10.RO5.RO, OS).forge(pk);
    b <@ MLDSA_RO_DS11(DS5.RO1.RO, XCP(P), DS5.RO3.RO, DS5.RO4.RO, DS10.RO5.RO).verify(pk, m, s);
    return b /\ !(m \in DS11.EUF_CMA.qs);
  }
}.

local lemma G10_D11 &m :
  Pr[DS10.EUF_CMA(DS5.RO1.RO, DS5.RO2.RO, DS5.RO3.RO, DS5.RO4.RO, DS10.RO5.RO, MLDSA_RO_DS10, Router10(A)).main()
       @ &m : res] =
  Pr[RO_xc.MainD(D11, RO_xc.RO).distinguish() @ &m : res].
proof.
byequiv (: ={glob A, glob XOFA_O} ==> ={res}) => //.
proc; inline{2} D11(RO_xc.RO).distinguish.
inline{1} DS10.EUF_CMA(DS5.RO1.RO, DS5.RO2.RO, DS5.RO3.RO, DS5.RO4.RO, DS10.RO5.RO, MLDSA_RO_DS10, Router10(A)).A.forge.
inline{2} Router11(A, DS5.RO1.RO, RO_xc.RO, DS5.RO3.RO, DS5.RO4.RO, DS10.RO5.RO, D11(RO_xc.RO).OS).forge.
wp; call verify1011.
wp; call (: ={RO_pad.RO.m, RO_rest.RO.m, RO_hr.RO.m, DS5.RO1.RO.m, DS5.RO3.RO.m, DS5.RO4.RO.m, DS10.RO5.RO.m,
              glob XOFA_O, RO_y.RO.m} /\
            Router10.tr{1} = Router11.tr{2} /\ DS10.EUF_CMA.qs{1} = DS11.EUF_CMA.qs{2} /\
            DS10.EUF_CMA.sk{1} = DS11.EUF_CMA.sk{2} /\ blkrel DS5.RO2.RO.m{1} RO_xc.RO.m{2}).
+ by proc; call sign1011; auto.
+ by proc; auto.
+ proc; sp; if; 1: by move=> &1 &2 /> /#.
  - if => //.
    + by wp; call (: ={DS5.RO4.RO.m}); [by sim | auto].
    by call (: ={RO_rest.RO.m}); [by sim | auto].
  if => //.
  - if => //.
    + wp; call (: ={RO_pad.RO.m}); 1: by sim.
      by wp; call (: ={DS10.RO5.RO.m, RO_hr.RO.m}); [by sim | auto].
    by call (: ={RO_rest.RO.m}); [by sim | auto].
  if => //.
  - by exlim x{2} => xx; call (blk_get xx); auto.
  if => //.
  - by wp; call (: ={DS5.RO3.RO.m}); [by sim | auto].
  by call (: ={RO_rest.RO.m}); [by sim | auto].
call (: ={DS5.RO3.RO.m}); 1: by sim.
inline{1} RO_rest.RO.init RO_pad.RO.init RO_hr.RO.init; inline{2} RO_rest.RO.init RO_pad.RO.init RO_hr.RO.init; wp.
call keygen1011.
inline *; auto => />.
by split => [y j k _ _ | x b]; rewrite !emptyE.
qed.

local lemma D11_LRO &m :
  Pr[RO_xc.MainD(D11, RO_xc.RO).distinguish() @ &m : res] =
  Pr[RO_xc.MainD(D11, RO_xc.LRO).distinguish() @ &m : res].
proof.
byequiv (RO_xc.FullEager.RO_LRO D11 _) => //.
by move=> _; exact W8.dword_ll.
qed.

local lemma D11_G11 &m :
  Pr[RO_xc.MainD(D11, RO_xc.LRO).distinguish() @ &m : res] =
  Pr[DS11.EUF_CMA(DS5.RO1.RO, RO_xc.RO, DS5.RO3.RO, DS5.RO4.RO, DS10.RO5.RO, MLDSA_RO_DS11, Router11(A)).main()
       @ &m : res].
proof.
byequiv (: ={glob A, glob XOFA_O} ==> ={res}) => //.
proc; inline{1} D11(RO_xc.LRO).distinguish.
inline{1} Router11(A, DS5.RO1.RO, RO_xc.LRO, DS5.RO3.RO, DS5.RO4.RO, DS10.RO5.RO, D11(RO_xc.LRO).OS).forge.
inline{2} DS11.EUF_CMA(DS5.RO1.RO, RO_xc.RO, DS5.RO3.RO, DS5.RO4.RO, DS10.RO5.RO, MLDSA_RO_DS11, Router11(A)).A.forge.
wp; call verify11b.
wp; call (: ={RO_pad.RO.m, RO_rest.RO.m, RO_hr.RO.m, DS5.RO1.RO.m, RO_xc.RO.m, DS5.RO3.RO.m, DS5.RO4.RO.m,
              DS10.RO5.RO.m, glob XOFA_O, RO_y.RO.m, Router11.tr, DS11.EUF_CMA.qs, DS11.EUF_CMA.sk}).
+ by proc; call sign11b; auto.
+ by proc; auto.
+ by proc; inline *; sim.
call (: ={DS5.RO3.RO.m}); 1: by sim.
inline{1} RO_rest.RO.init RO_pad.RO.init RO_hr.RO.init; inline{2} RO_rest.RO.init RO_pad.RO.init RO_hr.RO.init; wp.
call keygen11b.
by inline *; auto => />.
qed.

lemma G10_G11 &m :
  Pr[DS10.EUF_CMA(DS5.RO1.RO, DS5.RO2.RO, DS5.RO3.RO, DS5.RO4.RO, DS10.RO5.RO, MLDSA_RO_DS10, Router10(A)).main()
       @ &m : res] =
  Pr[DS11.EUF_CMA(DS5.RO1.RO, RO_xc.RO, DS5.RO3.RO, DS5.RO4.RO, DS10.RO5.RO, MLDSA_RO_DS11, Router11(A)).main()
       @ &m : res].
proof. by rewrite (G10_D11 &m) (D11_LRO &m) (D11_G11 &m). qed.

(* Hop 11: SampleInBall reads single bytes of the stream on c~ *)
lemma hop11 (qH qS : int) &m : 0 <= qH => 0 <= qS =>
  (forall (H1 <: DS2.POracle1 {-A}) (H2 <: DS2.POracle2 {-A}) (O <: DS2.SOracle {-A}),
     islossless H1.get => islossless H2.get => islossless O.sign =>
     islossless A(H1, H2, O).forge) =>
  (forall (H <: DS2.POracle1 {-A, -CountH, -CountS}) (G <: DS2.POracle2 {-A, -CountH, -CountS})
          (O <: DS2.SOracle {-A, -CountH, -CountS}),
     hoare [A(CountH(H), G, CountS(O)).forge :
              CountH.c = 0 /\ CountS.c = 0 ==> CountH.c <= qH /\ CountS.c <= qS]) =>
  Pr[DS2.EUF_CMA(DS2.RO1.RO, DS2.RO2.RO, MLDSA_RO_DS1, A).main() @ &m : res] <=
  Pr[DS11.EUF_CMA(DS5.RO1.RO, RO_xc.RO, DS5.RO3.RO, DS5.RO4.RO, DS10.RO5.RO, MLDSA_RO_DS11, Router11(A)).main()
       @ &m : res] +
  2%r * p512 + (qH + qS * (1 + kappa_max) + 2)%r * p512 +
  ((qS * (qS + qH + 1))%r * p512 + (3 * qH + qS + 4)%r * p256).
proof.
move=> hqH hqS A_ll A_count.
by rewrite -(G10_G11 &m); apply (hop10 A qH qS &m hqH hqS A_ll A_count).
qed.

end section.
