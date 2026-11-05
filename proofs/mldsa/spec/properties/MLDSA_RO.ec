require import AllCore IntDiv List.
from Jasmin require import JByte_array JWord.
require import Array256.

require import Parameters GFq Rq.
require import Symmetric.
require MLDSATargetFIPS.
from CryptoSpecs require import Keccak1600_Spec.
require import Xreal.
require import DistrExtra.

require import Leakage.
abstract theory MLDSA_RO.

clone include MLDSATargetFIPS.MLDSATargetFIPS.
import Spec.
import PolyLVec PolyKVec PolyMat.
import Round ZModQ Zq MLDSAParams.



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
      var leak : (int * int) list;
      var s : Bytes8.t;
      var h : bool list;
      var i,j,bs,pos;
      var c : poly;
      leak <- [];
      c <- poly_zero;
      bs <@ Squeeze(H).squeeze(BytesCT.to_list rho, 8);
      s <- Bytes8.of_list bs;
      h <- BytesToBits (Bytes8.to_list s);
      pos <- 8;
      i <- 256 - tau;
      while (i < 256) {
          j <@ ReadByte(H).read(BytesCT.to_list rho, pos);
          pos <- pos + 1;
          leak <- rcons leak (pos, W8.to_uint j);
          while(i < W8.to_uint j) {
            j <@ ReadByte(H).read(BytesCT.to_list rho, pos);
            pos <- pos + 1;
            leak <- rcons leak (pos, W8.to_uint j);
          }
          c.[i] <- c.[W8.to_uint j];
          c.[W8.to_uint j] <- if h.[i+tau-256] then incoeff (-1) else incoeff (1);
          i <- i + 1;
      }
      return (c, lcat (signs_leak s) (pairs_to_leakage leak));
   }
}.

(* SIB_RO on the block oracle: the leakage is the one of SampleInBall only,
   the signing loop leaks c~ itself *)
module SIB_RO_O(H : BlockOracle) = {
   proc get(mu : Bytes64.t, w1 : BytesW1.t): (BytesCT.t * poly) * sib_leakage = {
        var rr, bs, ct;
        bs <@ Squeeze(H).squeeze(Bytes64.to_list mu ++ BytesW1.to_list w1, lambda %/ 4);
        ct <- BytesCT.of_list bs;
        rr <@ SampleInBall_O(H).sample(ct);
        return ((ct,rr.`1), rr.`2);
   }
}.

module MLDSA_RO(H : BlockOracle, G : Oracle) = {
   proc keygen_derand(eps : Bytes32.t) : BytesSK.t * BytesPK.t= {
     var sk,rho,rhop,_K,_A,al,s1,s2,t,t1,t0,pk,tr,epsp,bs;
     epsp <- Bytes34.of_list (Bytes32.to_list eps ++ [W8.of_int kvec;W8.of_int lvec]);
     bs <@ Squeeze(H).squeeze(Bytes34.to_list epsp, 128);
     (rho,rhop,_K) <- ( Bytes32.of_list (take 32 bs)
                      , Bytes64.of_list (take 64 (drop 32 bs))
                      , Bytes32.of_list (drop 96 bs) );
     (_A,al) <@ ExpandA(XOFA_O(G)).sample(rho);
     (s1,s2) <@ ExpandS(XOFS_O(H)).sample(rhop);
     t <- invnttv (ntt_mulmxv _A (nttv s1)) + s2;
     (t1,t0) <- Power2Round t;
     pk <@ PkEncDec.pkEncode(rho,t1);
     bs <@ Squeeze(H).squeeze(BytesPK.to_list pk, 64);
     tr <- Bytes64.of_list bs;
     sk <@ SkEncDec.skEncode(rho,_K,tr,s1,s2,t0);
     return (sk,pk);
  }

  proc sign_derand(sk : BytesSK.t, m : W8.t list, coins : rnd_) : BytesSig.t option * leakage= {
     var rho,_K,tr,s1,s2,t0,s1h,s2h,t0h,_A,al,mu,rhopp,kappa,y,w,w1,ctl,ct,c,ch,cs1,
         cs2,z,r0,ct0,h,leakage,sigma,bct0,bs;
     var zf, rf, hf : int option;
     var zh : (polylvec * polykvec) option;
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

  proc verify(pk : BytesPK.t, sigma : BytesSig.t, m : W8.t list) : bool = {
    var rho,t1,c,l,ct,z,h,rb,_A,al,tr,mu,wapprox,w1,ctp,bs;
    w1 <- witness;
    rb <- false;
    (rho,t1) <@ PkEncDec.pkDecode(pk);
    (ct,z,h) <@ SigEncDec.sigDecode(sigma);
    if (h <> None) {
      (_A,al) <@ ExpandA(XOFA_O(G)).sample(rho);
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
while (={j, c, vs} /\ XOFA_state.seed{1} = Bytes34.to_list XOFA_O.seed{2}
       /\ XOFA_state.pos{1} = XOFA_O.pos{2} /\ 0 <= XOFA_state.pos{1}).
+ inline *; auto => /> &2 *.
  by rewrite SHAKE128_3 //= /#.
by inline *; auto.
qed.

equiv ExpandA_equiv :
  ExpandA(MLDSA_XOFA).sample ~ ExpandA(XOFA_O(SHAKE128_O)).sample :
  ={rho} ==> ={res}.
proof.
proc.
while (={r, rho, aa, al}).
+ wp; while (={r, s, rho, aa, al}); 1: by wp; call RejNTTPoly_equiv; auto.
  by auto.
by auto.
qed.

equiv RejBoundedPoly_equiv :
  RejBoundedPoly(MLDSA_XOFS).sample ~ RejBoundedPoly(XOFS_O(SHAKE256_O)).sample :
  ={rho} ==> ={res}.
proof.
proc.
while (={j, a} /\ XOFS_state.seed{1} = Bytes66.to_list XOFS_O.seed{2}
       /\ XOFS_state.pos{1} = XOFS_O.pos{2} /\ 0 <= XOFS_state.pos{1}).
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
by auto => />; smt(param_sets).
qed.

equiv SampleInBall_equiv :
  SampleInBall(MLDSA_XOF_SIB).sample ~ SampleInBall_O(SHAKE256_O).sample :
  ={rho} ==> ={res}.
proof.
proc.
while (={i, c, h, leak, rho} /\ XOFSIB_state.seed{1} = BytesCT.to_list rho{2}
       /\ XOFSIB_state.pos{1} = pos{2} /\ ctx{1} = pos{2} /\ 0 <= pos{2}).
+ wp; while (={i, j, c, h, leak, rho} /\ XOFSIB_state.seed{1} = BytesCT.to_list rho{2}
             /\ XOFSIB_state.pos{1} = pos{2} /\ ctx{1} = pos{2} /\ 0 <= pos{2}).
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
seq 17 19 : (={rho, _K, tr, s1, s2, t0, s1h, s2h, t0h, _A, mu, rhopp, rf, hf,
               kappa, zh, leakage, sigma, ct, ctl}).
+ wp; ecall{2} (Squeeze_SHAKE256_ph
                  (Bytes32.to_list _K{2} ++ rnd_to_list coins{2} ++ Bytes64.to_list mu{2}) 64).
  wp; ecall{2} (Squeeze_SHAKE256_ph (Bytes64.to_list tr{2} ++ m{2}) 64).
  wp; call ExpandA_equiv.
  wp; call (: true); 1: by sim.
  by auto.
seq 1 1 : (={zh, leakage, sigma, ct}); last by sim.
while (={rho, _K, tr, s1, s2, t0, s1h, s2h, t0h, _A, mu, rhopp, rf, hf,
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

(* -------------------------------------------------------------------- *)
(* the block-oracle samplers are lossless, and keep any constant        *)
(* potential, when the oracle is and does                               *)

lemma Squeeze_ll (H <: BlockOracle) : islossless H.get => islossless Squeeze(H).squeeze.
proof.
by move=> H_ll; proc; while true (len - 64 * j);
   [by move=> z; wp; call H_ll; auto => /# | by auto => /#].
qed.

lemma emask_ll (H <: BlockOracle) : islossless H.get => islossless ExpandMask_O(H).sample.
proof.
by move=> H_ll; proc; while true (lvec - r);
   [by move=> z; wp; call (Squeeze_ll H H_ll); auto => /# | by auto => /#].
qed.

lemma Squeeze_e (H <: BlockOracle) (v : xreal) :
  (forall v, ehoare [H.get : v ==> v]) => ehoare [Squeeze(H).squeeze : v ==> v].
proof.
move=> hH; proc; while (v).
+ by move=> &hr; apply xle_cxr_r.
+ by wp; call (hH v); skip => &hr; apply xle_cxr_r.
by auto.
qed.

lemma ReadByte_e (H <: BlockOracle) (v : xreal) :
  (forall v, ehoare [H.get : v ==> v]) => ehoare [ReadByte(H).read : v ==> v].
proof. by move=> hH; proc; call (hH v); auto. qed.

lemma SampleInBall_e (H <: BlockOracle) (v : xreal) :
  (forall v, ehoare [H.get : v ==> v]) => ehoare [SampleInBall_O(H).sample : v ==> v].
proof.
move=> hH; proc; while (v).
+ by move=> &hr; apply xle_cxr_r.
+ wp; while (v).
  + by move=> &hr; apply xle_cxr_r.
  + by wp; call (ReadByte_e H v hH); auto => &hr; apply xle_cxr_r.
  by wp; call (ReadByte_e H v hH); auto => &hr; apply xle_cxr_r.
by wp; call (Squeeze_e H v hH); auto.
qed.

lemma ExpandMask_e (H <: BlockOracle) (v : xreal) :
  (forall v, ehoare [H.get : v ==> v]) => ehoare [ExpandMask_O(H).sample : v ==> v].
proof.
by move=> hH; proc; while (v);
   [move=> &hr; apply xle_cxr_r | wp; call (Squeeze_e H v hH); auto => &hr; apply xle_cxr_r | auto].
qed.

lemma XOFS_next_e (H <: BlockOracle) (v : xreal) :
  (forall v, ehoare [H.get : v ==> v]) => ehoare [XOFS_O(H).next : v ==> v].
proof. by move=> hH; proc; wp; call (ReadByte_e H v hH); auto. qed.

lemma RejBoundedPoly_e (H <: BlockOracle) (v : xreal) :
  (forall v, ehoare [H.get : v ==> v]) => ehoare [RejBoundedPoly(XOFS_O(H)).sample : v ==> v].
proof.
move=> hH; proc; while (v); [by move=> &hr; apply xle_cxr_r | | by inline *; auto].
seq 1 : v; 2: by auto.
by call (XOFS_next_e H v hH); skip => &hr; apply xle_cxr_r.
qed.

lemma ExpandS_e (H <: BlockOracle) (v : xreal) :
  (forall v, ehoare [H.get : v ==> v]) => ehoare [ExpandS(XOFS_O(H)).sample : v ==> v].
proof.
move=> hH; proc; while (v).
+ by move=> &hr; apply xle_cxr_r.
+ by wp; call (RejBoundedPoly_e H v hH); auto => &hr; apply xle_cxr_r.
wp; while (v); [by move=> &hr; apply xle_cxr_r | | by auto].
by wp; call (RejBoundedPoly_e H v hH); auto => &hr; apply xle_cxr_r.
qed.

(* -------------------------------------------------------------------- *)
(* SampleInBall terminates over any block oracle that only learns the   *)
(* block it is asked for, knows finitely many blocks per input, and     *)
(* answers an unknown block with a zero at any given position with      *)
(* probability at least 1/256.  A zero byte is always accepted, and the *)
(* reads walk past the known blocks, so the rejection loop stops with   *)
(* probability 1.                                                       *)

(* the known blocks of r: below B, or already read (up to position p) *)
op known_below ['g] (known : 'g -> W8.t list * int -> bool) (g : 'g) (r : W8.t list) (B p : int) =
  forall c, known g (r, c) => c < B \/ c <= p %/ 64.

(* the reads left before the next unknown block, 0 once the loop exits *)
op sib_variant ['g] (known : 'g -> W8.t list * int -> bool) (g : 'g) (r : W8.t list)
                    (B i : int) (j : W8.t) (p : int) =
  if !(i < to_uint j) then 0
  else if known g (r, p %/ 64) then 64 * (max B (p %/ 64 + 1) - p %/ 64) - p %% 64 + 1
  else 1.

(* reading the block of position p keeps the known blocks below B or read *)
lemma known_below_step ['g] (known : 'g -> W8.t list * int -> bool) g g' r B p :
     known_below known g r B p
  => (forall c, known g' (r, c) <=> known g (r, c) \/ c = p %/ 64)
  => known_below known g' r B (p + 1).
proof. by move=> h hk c /hk [/h [| ] | ->]; smt(leq_div2r). qed.

lemma SampleInBall_O_ll (H <: BlockOracle)
  (known : glob H -> W8.t list * int -> bool) (ok : W8.t list -> bool) :
     islossless H.get
  => (forall (g0 : glob H) (x : W8.t list * int), ok x.`1 =>
        hoare [H.get : glob H = g0 /\ arg = x ==>
                 forall c, known (glob H) (x.`1, c) <=> known g0 (x.`1, c) \/ c = x.`2])
  => (forall (g0 : glob H) (x : W8.t list * int) k,
        ok x.`1 => 0 <= k < 64 => !known g0 x =>
        phoare [H.get : glob H = g0 /\ arg = x ==> nth witness res k = W8.zero]
        >= (1%r / 256%r))
  => (forall (g : glob H) rho, exists B, forall c, known g (rho, c) => c < B)
  => phoare [SampleInBall_O(H).sample : ok (BytesCT.to_list rho) ==> true] = 1%r.
proof.
move=> H_ll H_kn H_fr H_fin.
have get_kn : forall (g0 : glob H) (x : W8.t list * int), ok x.`1 =>
  phoare [H.get : glob H = g0 /\ arg = x ==>
            forall c, known (glob H) (x.`1, c) <=> known g0 (x.`1, c) \/ c = x.`2] = 1%r.
- by move=> g0 x hx; conseq H_ll (H_kn g0 x hx).
proc.
while (ok (BytesCT.to_list rho) /\ 0 <= pos /\ 0 <= i) (256 - i); last first.
- by wp; call (Squeeze_ll H H_ll); auto => />; smt(tau_bound).
move=> z.
(* the first read of the round *)
seq 3 : (ok (BytesCT.to_list rho) /\ 0 <= pos /\ 0 <= i /\ i < 256 /\ 256 - i = z).
- by wp; inline ReadByte(H).read; wp; call (: true); auto.
- by wp; inline ReadByte(H).read; wp; call H_ll; auto => /> /#.
(* the rejection loop *)
- wp; exlim (glob H), rho, i => g0 rho0 i0.
  case @[ambient]: (ok (BytesCT.to_list rho0) /\ 0 <= i0) => [[hok hi0] | hn]; last first.
  + by conseq (_ : false ==> _) => // &hr [[_ [<- <-]] [h [_ [hi _]]]]; apply hn.
  have [B hB] := H_fin g0 (BytesCT.to_list rho0).
  conseq (_ : 0 <= pos /\ rho = rho0 /\ i = i0 /\ i < 256 /\ 256 - i = z
              /\ known_below known (glob H) (BytesCT.to_list rho) B pos ==> _).
  + by move=> &hr [[<- [<- <-]] |>] *; left; apply hB.
  while (0 <= pos /\ rho = rho0 /\ i = i0 /\ i < 256 /\ 256 - i = z
         /\ known_below known (glob H) (BytesCT.to_list rho) B pos)
        (sib_variant known (glob H) (BytesCT.to_list rho) B i j pos)
        (64 * max B 0 + 65) (1%r / 256%r).
  + by [].
  + by move=> &hr H0 j0 pos0 [h1 [h2 [h3 [_ [h4 _]]]]] _; rewrite h2 hok h1 h3 /= /#.
  + move=> &hr H0 j0 pos0 [hp _]; rewrite /sib_variant.
    have [h0 h1] : 0 <= pos0 %% 64 < 64 by smt(modz_ge0 ltz_pmod).
    have h2 : 0 <= pos0 %/ 64 by smt(divz_ge0).
    case: (i{hr} < to_uint j0) => /= _; 2: smt().
    by case: (known H0 (BytesCT.to_list rho{hr}, pos0 %/ 64)) => /= _; smt().
  + move=> hw.
    seq 3 : (0 <= pos /\ rho = rho0 /\ i = i0 /\ i < 256 /\ 256 - i = z
             /\ known_below known (glob H) (BytesCT.to_list rho) B pos).
    * by wp; inline ReadByte(H).read; wp; call (: true); auto.
    * wp; inline ReadByte(H).read; wp; exlim (glob H), pos => gg pp.
      call (get_kn gg (BytesCT.to_list rho0, pp %/ 64) hok).
      auto => &hr [[-> ->] [[hp [-> [-> [hi [hz hinv]]]]] _]] /= H1 hk.
      by do 3! (split; 1: smt()); apply (known_below_step _ _ _ _ _ _ hinv hk).
    * by apply hw.
    * hoare; wp; inline ReadByte(H).read; wp; exlim (glob H), pos => gg pp.
      call (H_kn gg (BytesCT.to_list rho0, pp %/ 64) hok).
      auto => &hr [[-> ->] [[hp [-> [-> [hi [hz hinv]]]]] _]] /= H1 hk.
      by do 3! (split; 1: smt()); apply (known_below_step _ _ _ _ _ _ hinv hk).
    by [].
  + wp; inline ReadByte(H).read; wp; exlim (glob H), pos => gg pp.
    call (get_kn gg (BytesCT.to_list rho0, pp %/ 64) hok).
    auto => &hr [[-> ->] [[hp [-> [-> [hi [hz hinv]]]]] _]] /= H1 hk.
    by do 3! (split; 1: smt()); apply (known_below_step _ _ _ _ _ _ hinv hk).
  split; 1: smt().
  move=> z0; case (known (glob H) (BytesCT.to_list rho, pos %/ 64)).
  (* a known block: the read is deterministic and the variant drops by 1 *)
  + conseq (_ : _ ==> _ : = 1%r); 1: by move=> &hr; smt().
    wp; inline ReadByte(H).read; wp; exlim (glob H), pos => gg pp.
    call (get_kn gg (BytesCT.to_list rho0, pp %/ 64) hok).
    auto => &hr [[-> ->] [[[hp [-> [-> [hi [hz hinv]]]]] [hg hv]] hk0]] /=.
    move=> rr H1 hk; move: hv; rewrite /sib_variant hg hk0 /= => <-.
    pose b := pos{hr} %/ 64; pose o := pos{hr} %% 64.
    have [h0 h1] : 0 <= o < 64 by smt(modz_ge0 ltz_pmod).
    have hd : pos{hr} = b * 64 + o by apply divz_eq.
    case: (i0 < to_uint (nth witness rr o)) => /= hj; last by smt().
    case: (o = 63) => h63.
    * (* the next read starts block b + 1 *)
      rewrite (_ : pos{hr} + 1 = (b + 1) * 64 + 0) 1:/# divzMDl // modzMDl /=.
      case: (known H1 (BytesCT.to_list rho0, b + 1)) => hk1; last by smt().
      have : b + 1 < B by move: hk1; rewrite hk => -[/hinv /# | /#].
      smt().
    (* the next read stays in block b *)
    rewrite (_ : pos{hr} + 1 = b * 64 + (o + 1)) 1:/# divzMDl // modzMDl.
    rewrite (pdiv_small (o + 1)) 1:/# (pmod_small (o + 1)) 1:/# /=.
    by rewrite (_ : known H1 (BytesCT.to_list rho0, b)) 1:hk //; smt().
  (* an unknown block: a zero byte, read with probability >= 1/256, ends the loop *)
  wp; inline ReadByte(H).read; wp; exlim (glob H), pos => gg pp.
  case @[ambient]: (known gg (BytesCT.to_list rho0, pp %/ 64)) => hkn.
  + conseq (_ : false ==> _) => //.
    * by move=> &hr [[<- <-] [[[_ [-> _]] _]]]; rewrite hkn.
    by exfalso => _; smt().
  call (: glob H = gg /\ arg = (BytesCT.to_list rho0, pp %/ 64)
          ==> nth witness res (pp %% 64) = W8.zero).
  + apply (H_fr gg (BytesCT.to_list rho0, pp %/ 64) (pp %% 64) hok _ hkn).
    by smt(modz_ge0 ltz_pmod).
  auto => &hr [[-> ->] [[[hp [-> [-> [hi [hz hinv]]]]] [hg hv]] hk0]] /=.
  move=> rr H1 hz0; move: hv; rewrite /sib_variant hg hk0 /= => <-.
  by rewrite hz0 W8.to_uint0; smt().
- by hoare; wp; inline ReadByte(H).read; wp; call (: true); auto => /> /#.
by [].
qed.

(* -------------------------------------------------------------------- *)
(* RejNTTPoly and ExpandA terminate over any byte oracle with the same   *)
(* three properties.  A candidate whose third byte is zero is accepted   *)
(* (CoeffFromThreeBytes_hi0), and an unknown third byte is zero with     *)
(* probability at least 1/256.                                           *)

(* the known bytes of r: below B, or already read (before position p) *)
op known_before ['g] (known : 'g -> W8.t list * int -> bool) (g : 'g) (r : W8.t list)
                     (B p : int) =
  forall c, known g (r, c) => c < B \/ c < p.

(* acceptances left, weighted, plus the candidates left before the next *)
(* unknown third byte                                                   *)
op rej_variant ['g] (known : 'g -> W8.t list * int -> bool) (g : 'g) (r : W8.t list)
                    (B j p : int) =
  if 256 <= j then 0
  else (256 - j) * (max B 3 + 1)
       + (if known g (r, p + 2) then max B (p + 3) - p else 0).

lemma RejNTTPoly_O_ll (G <: Oracle {-XOFA_O}) (known : glob G -> W8.t list * int -> bool) :
     islossless G.get
  => (forall (g0 : glob G) (x : W8.t list * int),
        hoare [G.get : glob G = g0 /\ arg = x ==>
                 forall c, known (glob G) (x.`1, c) <=> known g0 (x.`1, c) \/ c = x.`2])
  => (forall (g0 : glob G) (x : W8.t list * int), !known g0 x =>
        phoare [G.get : glob G = g0 /\ arg = x ==> res = W8.zero] >= (1%r / 256%r))
  => (forall (g : glob G) r, exists B, forall c, known g (r, c) => c < B)
  => islossless RejNTTPoly(XOFA_O(G)).sample.
proof.
move=> G_ll G_kn G_fr G_fin.
(* next reads the three bytes at pos, pos + 1 and pos + 2 *)
have next_h : forall (g0 : glob G) s p,
  hoare [XOFA_O(G).next : glob G = g0 /\ XOFA_O.seed = s /\ XOFA_O.pos = p ==>
           XOFA_O.seed = s /\ XOFA_O.pos = p + 3 /\
           forall c, known (glob G) (Bytes34.to_list s, c) <=>
                     known g0 (Bytes34.to_list s, c) \/ p <= c < p + 3].
- move=> g0 s p; proc; wp.
  seq 1 : (XOFA_O.seed = s /\ XOFA_O.pos = p /\
           forall c, known (glob G) (Bytes34.to_list s, c) <=>
                     known g0 (Bytes34.to_list s, c) \/ c = p).
  + by ecall (G_kn g0 (Bytes34.to_list s, p)); skip => />.
  seq 1 : (XOFA_O.seed = s /\ XOFA_O.pos = p /\
           forall c, known (glob G) (Bytes34.to_list s, c) <=>
                     known g0 (Bytes34.to_list s, c) \/ p <= c < p + 2).
  + exlim (glob G) => g1; ecall (G_kn g1 (Bytes34.to_list s, p + 1)).
    by skip => &hr [<- [-> [-> hk]]] /= G1 hk1 c; rewrite hk1 hk /#.
  exlim (glob G) => g2; ecall (G_kn g2 (Bytes34.to_list s, p + 2)).
  by skip => &hr [<- [-> [-> hk]]] /= G2 hk2 c; rewrite hk2 hk /#.
have next_ll : islossless XOFA_O(G).next by proc; wp; do 3! call G_ll; auto.
have next_ph : forall (g0 : glob G) s p,
  phoare [XOFA_O(G).next : glob G = g0 /\ XOFA_O.seed = s /\ XOFA_O.pos = p ==>
           XOFA_O.seed = s /\ XOFA_O.pos = p + 3 /\
           forall c, known (glob G) (Bytes34.to_list s, c) <=>
                     known g0 (Bytes34.to_list s, c) \/ p <= c < p + 3] = 1%r.
- by move=> g0 s p; conseq next_ll (next_h g0 s p).
(* an unknown third byte is zero with probability at least 1/256 *)
have next_fr : forall (g0 : glob G) s p, !known g0 (Bytes34.to_list s, p + 2) =>
  phoare [XOFA_O(G).next : glob G = g0 /\ XOFA_O.seed = s /\ XOFA_O.pos = p ==>
            Bytes3."_.[_]" res 2 = W8.zero] >= (1%r / 256%r).
- move=> g0 s p hkn; proc; wp.
  seq 2 : (XOFA_O.seed = s /\ XOFA_O.pos = p /\ !known (glob G) (Bytes34.to_list s, p + 2))
          1%r (1%r / 256%r) 0%r 0%r.
  + by call (: true); call (: true); auto.
  + have keep : forall (x : W8.t list * int) c, x.`2 <> c =>
      phoare [G.get : arg = x /\ !known (glob G) (x.`1, c) ==> !known (glob G) (x.`1, c)]
      = 1%r.
    * move=> x c hc; exlim (glob G) => g.
      conseq G_ll (_ : g = glob G /\ arg = x /\ !known (glob G) (x.`1, c)
                       ==> !known (glob G) (x.`1, c)) => //.
      conseq (G_kn g x) => // &hr [<- [_ hk]] G1 h.
      by move: (h c); rewrite (negbTE _ hk) /#.
    conseq (_ : _ ==> _ : = 1%r) => //.
    call (keep (Bytes34.to_list s, p + 1) (p + 2) _); 1: smt().
    call (keep (Bytes34.to_list s, p) (p + 2) _); 1: smt().
    by skip => &hr [-> [-> ->]] /=; rewrite hkn.
  + exlim (glob G) => g2.
    case @[ambient]: (known g2 (Bytes34.to_list s, p + 2)) => hk2.
    * conseq (_ : false ==> _) => //; 1: by move=> &hr [<- [_ [_ h]]].
      by exfalso => _; smt().
    call (: glob G = g2 /\ arg = (Bytes34.to_list s, p + 2) ==> res = W8.zero).
    * by apply (G_fr g2 _ hk2).
    by skip => &hr [<- [-> [-> _]]].
  + by conseq (_ : _ ==> _ : >= 0%r) => //; exfalso => _; smt().
  by move=> &hr _; smt().
have next_fr' : forall (g0 : glob G) s p, !known g0 (Bytes34.to_list s, p + 2) =>
  phoare [XOFA_O(G).next : glob G = g0 /\ XOFA_O.seed = s /\ XOFA_O.pos = p ==>
           Bytes3."_.[_]" res 2 = W8.zero /\ XOFA_O.seed = s /\ XOFA_O.pos = p + 3 /\
           forall c, known (glob G) (Bytes34.to_list s, c) <=>
                     known g0 (Bytes34.to_list s, c) \/ p <= c < p + 3]
  >= (1%r / 256%r).
- by move=> g0 s p hk; conseq (next_fr g0 s p hk) (next_h g0 s p).
proc; inline XOFA_O(G).init; sp.
exlim (glob G), XOFA_O.seed => g0 s0.
have [B hB] := G_fin g0 (Bytes34.to_list s0).
(* reading a candidate keeps the known bytes below B or read *)
have kb_step : forall (g g' : glob G) p,
     known_before known g (Bytes34.to_list s0) B p
  => (forall c, known g' (Bytes34.to_list s0, c) <=>
                known g (Bytes34.to_list s0, c) \/ p <= c < p + 3)
  => known_before known g' (Bytes34.to_list s0) B (p + 3).
- by move=> g g' p h hk c /hk [/h /# | /#].
conseq (_ : XOFA_O.seed = s0 /\ 0 <= XOFA_O.pos /\ 0 <= j
            /\ known_before known (glob G) (Bytes34.to_list s0) B XOFA_O.pos ==> _).
- by move=> &hr /> *; left; apply hB.
while (XOFA_O.seed = s0 /\ 0 <= XOFA_O.pos /\ 0 <= j
       /\ known_before known (glob G) (Bytes34.to_list s0) B XOFA_O.pos)
      (rej_variant known (glob G) (Bytes34.to_list s0) B j XOFA_O.pos)
      (256 * (max B 3 + 1) + max B 3) (1%r / 256%r).
- by [].
- by [].
- move=> &hr G0 pos j0 [_ [hp [hj hkb]]]; rewrite /rej_variant.
  case: (256 <= j0) => /= hj0; 1: smt().
  case: (known G0 (Bytes34.to_list s0, pos + 2)) => hk; 2: smt().
  by have := hkb _ hk; smt().
- move=> hw.
  seq 4 : (XOFA_O.seed = s0 /\ 0 <= XOFA_O.pos /\ 0 <= j
           /\ known_before known (glob G) (Bytes34.to_list s0) B XOFA_O.pos).
  + by wp; call (: true); auto.
  + wp; exlim (glob G), XOFA_O.pos => gg pp; call (next_ph gg s0 pp).
    auto => &hr [[-> ->] [[-> [hp [hj hkb]]] _]] /= r G1 p' [-> hk].
    by have h := kb_step _ _ _ hkb hk; smt().
  + by apply hw.
  + hoare; wp; exlim (glob G), XOFA_O.pos => gg pp; call (next_h gg s0 pp).
    auto => &hr [[-> ->] [[-> [hp [hj hkb]]] _]] /= r G1 p' [-> hk].
    by have h := kb_step _ _ _ hkb hk; smt().
  by [].
- wp; exlim (glob G), XOFA_O.pos => gg pp; call (next_ph gg s0 pp).
  auto => &hr [[-> ->] [[-> [hp [hj hkb]]] _]] /= r G1 p' [-> hk].
  by have h := kb_step _ _ _ hkb hk; smt().
split; 1: smt().
move=> z; case (known (glob G) (Bytes34.to_list s0, XOFA_O.pos + 2)).
(* a known third byte: the candidate is deterministic, and either it is *)
(* accepted or the next candidate is one step closer to unknown bytes   *)
- conseq (_ : _ ==> _ : = 1%r); 1: by move=> &hr; smt().
  wp; exlim (glob G), XOFA_O.pos => gg pp; call (next_ph gg s0 pp).
  auto => &hr [[-> ->] [[[-> [hp [hj hkb]]] [hj256 hv]] hk2]] /= r G1 p' [-> hk].
  have hB2 : XOFA_O.pos{hr} + 2 < B by have := hkb _ hk2; smt().
  have h5 : known G1 (Bytes34.to_list s0, XOFA_O.pos{hr} + 3 + 2) => XOFA_O.pos{hr} + 5 < B.
  + by move=> /hk [/hkb | ]; smt().
  by move: hv; rewrite /rej_variant hk2 /= ifF 1:/# => <-; smt().
(* an unknown third byte: zero with probability >= 1/256, then accepted *)
wp; exlim (glob G), XOFA_O.pos => gg pp.
case @[ambient]: (known gg (Bytes34.to_list s0, pp + 2)) => hkn.
- conseq (_ : false ==> _) => //.
  + by move=> &hr [[<- <-] [_ h]]; move: h; rewrite hkn.
  by exfalso => _; smt().
call (next_fr' gg s0 pp hkn).
auto => &hr [[-> ->] [[[-> [hp [hj hkb]]] [hj256 hv]] hk2]] /= r G1 p' [hr2 [-> hk]].
rewrite hr2 ifT; 1: by apply CoeffFromThreeBytes_hi0.
have h5 : known G1 (Bytes34.to_list s0, XOFA_O.pos{hr} + 3 + 2) => XOFA_O.pos{hr} + 5 < B.
- by move=> /hk [/hkb | ]; smt().
by move: hv; rewrite /rej_variant (negbTE _ hk2) /= => <-; smt().
qed.

lemma ExpandA_ll (G <: Oracle {-XOFA_O}) (known : glob G -> W8.t list * int -> bool) :
     islossless G.get
  => (forall (g0 : glob G) (x : W8.t list * int),
        hoare [G.get : glob G = g0 /\ arg = x ==>
                 forall c, known (glob G) (x.`1, c) <=> known g0 (x.`1, c) \/ c = x.`2])
  => (forall (g0 : glob G) (x : W8.t list * int), !known g0 x =>
        phoare [G.get : glob G = g0 /\ arg = x ==> res = W8.zero] >= (1%r / 256%r))
  => (forall (g : glob G) r, exists B, forall c, known g (r, c) => c < B)
  => islossless ExpandA(XOFA_O(G)).sample.
proof.
move=> G_ll G_kn G_fr G_fin; have rej_ll := RejNTTPoly_O_ll G known G_ll G_kn G_fr G_fin.
proc; while true (kvec - r); 2: by auto => /#.
move=> z; wp; while true (lvec - s); 2: by auto => /#.
by move=> z'; wp; call rej_ll; auto => /#.
qed.

end MLDSA_RO.
