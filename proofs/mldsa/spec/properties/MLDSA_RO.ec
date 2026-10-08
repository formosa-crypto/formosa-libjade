require import AllCore IntDiv List.
from Jasmin require import JByte_array JWord.
require import Array256.

require import Parameters GFq Rq VecMat Conversion Serialization Symmetric Sampling.
import PolyLVec PolyKVec PolyMat.
import Round ZModQ Zq MLDSAParams.

from CryptoSpecs require import Keccak1600_Spec.

require import MLDSA.

(* H = SHAKE256, as an oracle returning the 64-byte block j of the output stream on x;
   G = SHAKE128, as an oracle returning byte i of the output stream on x *)

module type BlockOracle = {
  proc get(x : W8.t list * int) : W8.t list
}.

module type Oracle = {
  proc get(x : W8.t list * int) : W8.t
}.

module SHAKE256_O : BlockOracle = {
  proc get(x : W8.t list * int) : W8.t list = {
    return take 64 (drop (64 * x.`2) (SHAKE256 x.`1 (64 * (x.`2 + 1))));
  }
}.

module SHAKE128_O : Oracle = {
  proc get(x : W8.t list * int) : W8.t = {
    return nth witness (SHAKE128 x.`1 (x.`2 + 1)) x.`2;
  }
}.

module Squeeze(H : BlockOracle) = {
  proc squeeze(x : W8.t list, len : int) : W8.t list = {
    var r, b, j;
    r <- [];
    j <- 0;
    while (64 * j < len) {
      b <@ H.get(x, j);
      r <- r ++ b;
      j <- j + 1;
    }
    return take len r;
  }
}.

module ReadByte(H : BlockOracle) = {
  proc read(x : W8.t list, p : int) : W8.t = {
    var b;
    b <@ H.get(x, p %/ 64);
    return nth witness b (p %% 64);
  }
}.

module XOFA_O(G : Oracle) : XOF_RejNTTPoly = {
  var seed : Bytes34.t
  var pos  : int

  proc init(rho : Bytes34.t) : unit = {
    seed <- rho;
    pos  <- 0;
  }

  proc next() : Bytes3.t = {
    var b0, b1, b2;
    b0 <@ G.get(Bytes34.to_list seed, pos);
    b1 <@ G.get(Bytes34.to_list seed, pos + 1);
    b2 <@ G.get(Bytes34.to_list seed, pos + 2);
    pos <- pos + 3;
    return Bytes3.of_list [b0; b1; b2];
  }
}.

module XOFS_O(H : BlockOracle) : XOF_RejBPoly = {
  var seed : Bytes66.t
  var pos  : int

  proc init(rho : Bytes66.t) : unit = {
    seed <- rho;
    pos  <- 0;
  }

  proc next() : W8.t = {
    var b;
    b <@ ReadByte(H).read(Bytes66.to_list seed, pos);
    pos <- pos + 1;
    return b;
  }
}.

module ExpandMask_O(H : BlockOracle) = {
   proc sample(rho : Bytes64.t, mu : int) : polylvec = {
     var r, rhop, v, si, bs;
     var s : polylvec;
     s <- witness;
     r <- 0;
     while (r < lvec) {
        rhop <- Bytes66.of_list (Bytes64.to_list rho ++ (IntegerToBytes (mu+r) 2));
        bs <@ Squeeze(H).squeeze(Bytes66.to_list rhop, n * (gamma1m1_bits + 1) %/ 8);
        v <- BytesV.of_list bs;
        si <- BitUnpack (BytesV.to_list v) (gamma1-1) (gamma1);
        s <- s.[r <- si];
        r <- r + 1;
     }
     return s;
   }
}.

module SampleInBall_O(H : BlockOracle) = {
   proc sample(rho : BytesCT.t) : poly * sib_leakage = {
      var leakage : bool list;
      var s : Bytes8.t;
      var h : bool list;
      var i,j,bs,pos;
      var c : poly;
      leakage <- [];
      c <- poly_zero;
      bs <@ Squeeze(H).squeeze(BytesCT.to_list rho, 8);
      s <- Bytes8.of_list bs;
      h <- BytesToBits (Bytes8.to_list s);
      pos <- 8;
      i <- 256 - tau;
      while (i < 256) {
          j <@ ReadByte(H).read(BytesCT.to_list rho, pos);
          pos <- pos + 1;
          while(i < W8.to_uint j) {
            leakage <- leakage ++ [true];
            j <@ ReadByte(H).read(BytesCT.to_list rho, pos);
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

module SIB_RO_O(H : BlockOracle) = {
   proc get(mu : Bytes64.t, w1 : BytesW1.t): (BytesCT.t * poly) * sib_leakage = {
        var rr, bs, ct;
        bs <@ Squeeze(H).squeeze(Bytes64.to_list mu ++ BytesW1.to_list w1, lambda %/ 4);
        ct <- BytesCT.of_list bs;
        rr <@ SampleInBall_O(H).sample(ct);
        return ((ct,rr.`1),rr.`2);
   }
}.

module MLDSA_RO(H : BlockOracle, G : Oracle) = {
   proc keygen_derand(eps : Bytes32.t) : BytesSK.t * BytesPK.t= {
     var sk,rho,rhop,_K,_A,s1,s2,t,t1,t0,pk,tr,epsp,bs;
     epsp <- Bytes34.of_list (Bytes32.to_list eps ++ [W8.of_int kvec;W8.of_int lvec]);
     bs <@ Squeeze(H).squeeze(Bytes34.to_list epsp, 128);
     (rho,rhop,_K) <- ( Bytes32.of_list (take 32 bs)
                      , Bytes64.of_list (take 64 (drop 32 bs))
                      , Bytes32.of_list (drop 96 bs) );
     _A <@ ExpandA(XOFA_O(G)).sample(rho);
     (s1,s2) <@ ExpandS(XOFS_O(H)).sample(rhop);
     t <- invnttv (ntt_mulmxv _A (nttv s1)) + s2;
     (t1,t0) <- Power2Round t;
     pk <@ PkEncDec.pkEncode(rho,t1);
     bs <@ Squeeze(H).squeeze(BytesPK.to_list pk, 64);
     tr <- Bytes64.of_list bs;
     sk <@ SkEncDec.skEncode(rho,_K,tr,s1,s2,t0);
     return (sk,pk);
  }

  proc sign_derand(sk : BytesSK.t, m : W8.t list, coins : rnd_) : BytesSig.t option * Leakage list= {
     var rho,_K,tr,s1,s2,t0,s1h,s2h,t0h,_A,mu,rhopp,kappa,y,w,w1,ctl,ct,c,ch,cs1,
         cs2,z,r0,ct0,h,leakage,sigma,bz,bh,bs;
     var zh : (polylvec * polykvec) option;
     ct <- witness;
     ctl <- witness;
     sigma <- witness;
     leakage <- [];
     (rho,_K,tr,s1,s2,t0) <@ SkEncDec.skDecode(sk);
     s1h <- nttv s1;
     s2h <- nttv s2;
     t0h <- nttv t0;
     _A <@ ExpandA(XOFA_O(G)).sample(rho);
     bs <@ Squeeze(H).squeeze(Bytes64.to_list tr ++ m, 64);
     mu <- Bytes64.of_list bs;
     bs <@ Squeeze(H).squeeze(Bytes32.to_list _K ++ rnd_to_list coins ++ Bytes64.to_list mu, 64);
     rhopp <- Bytes64.of_list bs;
     kappa <- 0;
     zh <- None;
     while (zh = None && ! (kappa_max <= kappa)) {
       y <@ ExpandMask_O(H).sample(rhopp,kappa * lvec);
       w <- invnttv (ntt_mulmxv _A (nttv y));
       w1 <- polykvec_HighBits w;
       ctl <@ SIB_RO_O(H).get(mu,w1Encode w1);
       (ct,c) <- ctl.`1;
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

  proc verify(pk : BytesPK.t, sigma : BytesSig.t, m : W8.t list) : bool = {
    var rho,t1,c,l,ct,z,h,rb,_A,tr,mu,wapprox,w1,ctp,bs;
    w1 <- witness;
    rb <- false;
    (rho,t1) <@ PkEncDec.pkDecode(pk);
    (ct,z,h) <@ SigEncDec.sigDecode(sigma);
    if (h <> None) {
      _A <@ ExpandA(XOFA_O(G)).sample(rho);
      bs <@ Squeeze(H).squeeze(BytesPK.to_list pk, 64);
      tr <- Bytes64.of_list bs;
      bs <@ Squeeze(H).squeeze(Bytes64.to_list tr ++ m, 64);
      mu <- Bytes64.of_list bs;
      (c,l) <@ SampleInBall_O(H).sample(ct);
      wapprox <- invnttv (ntt_mulmxv _A (nttv z) - (ntt_smul (ntt c) (nttv (smul t1 (incoeff (2^d))))));
      w1 <- UseHint (oget h) wapprox;
      bs <@ Squeeze(H).squeeze(Bytes64.to_list mu ++ BytesW1.to_list (w1Encode w1), lambda %/ 4);
      ctp <- BytesCT.of_list bs;
      rb <- infnorm_lt z (gamma1 - Beta);
      rb <- rb && ct = ctp;
    }
    return rb;
  }
}.

(*************** Instantiation with the functional SHAKE ****************)

lemma SHAKE256_block x j :
  0 <= j =>
  SHAKE256 x (64 * (j + 1)) =
  SHAKE256 x (64 * j) ++ take 64 (drop (64 * j) (SHAKE256 x (64 * (j + 1)))).
proof.
move=> ge0_j.
have hs : size (SHAKE256 x (64 * (j + 1))) = 64 * (j + 1) by apply size_SHAKE256 => /#.
rewrite (SHAKE256_ext x (64 * j) (64 * (j + 1))) 1:/#.
rewrite (take_oversize 64 (drop (64 * j) (SHAKE256 x (64 * (j + 1))))).
+ by rewrite size_drop 1:/# hs /#.
by rewrite cat_take_drop.
qed.

lemma SHAKE256_byte x p :
  0 <= p =>
  nth witness (take 64 (drop (64 * (p %/ 64)) (SHAKE256 x (64 * (p %/ 64 + 1))))) (p %% 64) =
  nth witness (SHAKE256 x (p + 1)) p.
proof.
move=> ge0_p.
have hp : p = 64 * (p %/ 64) + p %% 64 by smt(divz_eq).
have hr : 0 <= p %% 64 < 64 by smt(modz_ge0 ltz_pmod).
rewrite (SHAKE256_ext x (p + 1) (64 * (p %/ 64 + 1))) 1:/#.
rewrite (nth_take witness (p + 1) (SHAKE256 x (64 * (p %/ 64 + 1))) p) 1,2:/#.
rewrite (nth_take witness 64) 1,2:/# nth_drop 1,2:/#.
by rewrite -hp.
qed.

lemma SHAKE128_3 x p :
  0 <= p =>
  take 3 (drop p (SHAKE128 x (p + 3))) =
  [ nth witness (SHAKE128 x (p + 1)) p
  ; nth witness (SHAKE128 x (p + 2)) (p + 1)
  ; nth witness (SHAKE128 x (p + 3)) (p + 2) ].
proof.
move=> ge0_p.
have hs : size (SHAKE128 x (p + 3)) = p + 3 by apply size_SHAKE128 => /#.
have E : forall i, 0 <= i < p + 3 =>
  nth witness (SHAKE128 x (i + 1)) i = nth witness (SHAKE128 x (p + 3)) i.
+ by move=> i hi; rewrite (SHAKE128_ext x (i + 1) (p + 3)) 1:/# nth_take /#.
rewrite E 1:/# (E (p + 1)) 1:/# (E (p + 2)) 1:/#.
apply (eq_from_nth witness).
+ by rewrite size_take // size_drop // hs /#.
move=> i; rewrite size_take // size_drop // hs => hi.
rewrite nth_take 1,2:/# nth_drop 1,2:/#.
by have [->|[->|->]] /= : i = 0 \/ i = 1 \/ i = 2 by smt().
qed.

phoare Squeeze_SHAKE256_ph _x _len :
  [ Squeeze(SHAKE256_O).squeeze :
    arg = (_x, _len) /\ 0 <= _len ==> res = SHAKE256 _x _len ] = 1%r.
proof.
proc.
while (0 <= j /\ 0 <= len /\ r = SHAKE256 x (64 * j)) (len - 64 * j).
+ move=> z; inline *; auto => /> &hr *.
  by rewrite -SHAKE256_block /#.
by auto => />; smt(size_SHAKE256 size_eq0 SHAKE256_ext).
qed.

equiv RejNTTPoly_equiv :
  RejNTTPoly(MLDSA_XOFA).sample ~ RejNTTPoly(XOFA_O(SHAKE128_O)).sample :
  ={rho} ==> ={res}.
proof.
proc.
while (={j, c} /\ MLDSA_XOFA.seed{1} = XOFA_O.seed{2}
       /\ MLDSA_XOFA.pos{1} = XOFA_O.pos{2} /\ 0 <= MLDSA_XOFA.pos{1}).
+ inline *; auto => /> &2 *.
  by rewrite SHAKE128_3 //= /#.
by inline *; auto.
qed.

equiv ExpandA_equiv :
  ExpandA(MLDSA_XOFA).sample ~ ExpandA(XOFA_O(SHAKE128_O)).sample :
  ={rho} ==> ={res}.
proof.
proc.
while (={r, rho, aa}).
+ wp; while (={r, s, rho, aa}); 1: by wp; call RejNTTPoly_equiv; auto.
  by auto.
by auto.
qed.

equiv RejBoundedPoly_equiv :
  RejBoundedPoly(MLDSA_XOFS).sample ~ RejBoundedPoly(XOFS_O(SHAKE256_O)).sample :
  ={rho} ==> ={res}.
proof.
proc.
while (={j, a} /\ MLDSA_XOFS.seed{1} = XOFS_O.seed{2}
       /\ MLDSA_XOFS.pos{1} = XOFS_O.pos{2} /\ 0 <= MLDSA_XOFS.pos{1}).
+ inline *; auto => /> &2 *.
  by rewrite SHAKE256_byte //= /#.
by inline *; auto.
qed.

equiv ExpandS_equiv :
  ExpandS(MLDSA_XOFS).sample ~ ExpandS(XOFS_O(SHAKE256_O)).sample :
  ={rho} ==> ={res}.
proof.
proc.
while (={r, rho, s1, s2}); 1: by wp; call RejBoundedPoly_equiv; auto.
wp; while (={r, rho, s1, s2}); 1: by wp; call RejBoundedPoly_equiv; auto.
by auto.
qed.

equiv ExpandMask_equiv :
  ExpandMask.sample ~ ExpandMask_O(SHAKE256_O).sample :
  ={rho, mu} ==> ={res}.
proof.
proc.
while (={r, s, rho, mu}); 2: by auto.
wp; ecall{2} (Squeeze_SHAKE256_ph (Bytes66.to_list rhop{2}) (n * (gamma1m1_bits + 1) %/ 8)).
by auto => />.
qed.

equiv SampleInBall_equiv :
  SampleInBall(MLDSA_XOF_SIB).sample ~ SampleInBall_O(SHAKE256_O).sample :
  ={rho} ==> ={res}.
proof.
proc.
while (={i, c, h, leakage, rho} /\ MLDSA_XOF_SIB.seed{1} = rho{2}
       /\ MLDSA_XOF_SIB.pos{1} = pos{2} /\ 0 <= pos{2}).
+ wp; while (={i, j, c, h, leakage, rho} /\ MLDSA_XOF_SIB.seed{1} = rho{2}
             /\ MLDSA_XOF_SIB.pos{1} = pos{2} /\ 0 <= pos{2}).
  + inline *; auto => /> &2 *.
    by rewrite SHAKE256_byte //= /#.
  inline *; auto => /> &2 *.
  by rewrite SHAKE256_byte //= /#.
inline MLDSA_XOF_SIB.init; wp.
ecall{2} (Squeeze_SHAKE256_ph (BytesCT.to_list rho{2}) 8).
by auto.
qed.

equiv SIB_RO_equiv :
  SIB_RO(MLDSA_XOF_SIB).get ~ SIB_RO_O(SHAKE256_O).get :
  ={mu, w1} ==> ={res}.
proof.
proc.
wp; call SampleInBall_equiv; wp.
ecall{2} (Squeeze_SHAKE256_ph (Bytes64.to_list mu{2} ++ BytesW1.to_list w1{2}) (lambda %/ 4)).
by auto => />; smt(param_sets).
qed.

lemma keygen_derand_equiv :
  equiv [ MLDSA(MLDSA_XOFA, MLDSA_XOFS, MLDSA_XOF_SIB, SIB_RO).keygen_derand ~
          MLDSA_RO(SHAKE256_O, SHAKE128_O).keygen_derand :
          ={eps} ==> ={res} ].
proof.
proc.
wp; call (: true); 1: by sim.
wp; ecall{2} (Squeeze_SHAKE256_ph (BytesPK.to_list pk{2}) 64).
wp; call (: true); 1: by sim.
wp; call ExpandS_equiv; call ExpandA_equiv.
wp; ecall{2} (Squeeze_SHAKE256_ph (Bytes34.to_list epsp{2}) 128).
by auto.
qed.

lemma sign_derand_equiv :
  equiv [ MLDSA(MLDSA_XOFA, MLDSA_XOFS, MLDSA_XOF_SIB, SIB_RO).sign_derand ~
          MLDSA_RO(SHAKE256_O, SHAKE128_O).sign_derand :
          ={sk, m, coins} ==> ={res} ].
proof.
proc.
seq 13 15 : (={rho, _K, tr, s1, s2, t0, s1h, s2h, t0h, _A, mu, rhopp,
               kappa, zh, leakage, sigma, ct, ctl}).
+ wp; ecall{2} (Squeeze_SHAKE256_ph
                  (Bytes32.to_list _K{2} ++ rnd_to_list coins{2} ++ Bytes64.to_list mu{2}) 64).
  wp; ecall{2} (Squeeze_SHAKE256_ph (Bytes64.to_list tr{2} ++ m{2}) 64).
  call ExpandA_equiv.
  wp; call (: true); 1: by sim.
  by auto.
seq 1 1 : (={zh, leakage, sigma, ct}); last by sim.
while (={rho, _K, tr, s1, s2, t0, s1h, s2h, t0h, _A, mu, rhopp,
         kappa, zh, leakage, sigma, ct, ctl}); 2: by auto.
wp; call SIB_RO_equiv; wp; call ExpandMask_equiv.
by auto.
qed.

lemma verify_equiv :
  equiv [ MLDSA(MLDSA_XOFA, MLDSA_XOFS, MLDSA_XOF_SIB, SIB_RO).verify ~
          MLDSA_RO(SHAKE256_O, SHAKE128_O).verify :
          ={pk, sigma, m} ==> ={res} ].
proof.
proc.
seq 4 4 : (={pk, sigma, m, rho, t1, ct, z, h, w1, rb}); 1: by sim.
if => //.
wp; ecall{2} (Squeeze_SHAKE256_ph
                (Bytes64.to_list mu{2} ++ BytesW1.to_list (w1Encode w1{2})) (lambda %/ 4)).
wp; call SampleInBall_equiv.
wp; ecall{2} (Squeeze_SHAKE256_ph (Bytes64.to_list tr{2} ++ m{2}) 64).
wp; ecall{2} (Squeeze_SHAKE256_ph (BytesPK.to_list pk{2}) 64).
call ExpandA_equiv.
by auto => />; smt(param_sets).
qed.
