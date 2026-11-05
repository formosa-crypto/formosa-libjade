require import AllCore IntDiv List StdBigop.
from Jasmin require import JByte_array JWord.
require import Parameters GFq Rq.
require import Array256.
require Sampling.
require import Leakage.

abstract theory MLDSAT.

clone include Sampling.SamplingT.

import PolyLVec PolyKVec PolyMat.
import Round ZModQ Zq MLDSAParams.

(* Flat leakage model (Leakage.ec): the trace of a signing is the
   concatenation, with [lcat], of the declassified values, in the order in
   which they are declassified:
   - the NTT representation of t0, once, at the decoding of the key;
   - per iteration: the leakage of SampleInBall (pairs (position, byte) of
     the rejection loop), the NTT representation of c, then the outcome of
     the rejection tests as short-circuit cascades over the polynomials:
     the index of the first polynomial of z out of range (or -1), then,
     when z passed, the same for w0 - c s2, then, when it passed, the first
     polynomial at which the weight of the hint exceeds w_hint (or -1).
   The test ||c t0|| < gamma2 is a public computation (c and t0 are leaked)
   and is not in the trace. Nothing else is leaked: the control flow of the
   loop is a function of the trace. *)

op poly_decl (p : poly) : decl = List (map (fun (c : coeff) => Int (asint c)) (Array256.to_list p)).
op poly_leak (p : poly) : leakage = [poly_decl p].
op kvec_leak (v : polykvec) : leakage = [List (map poly_decl (KArray.to_list v))].

(* The rejection tests as short-circuit cascades: the index of the first
   failing polynomial, None when every polynomial passes *)
op zfail_idx (z : polylvec) : int option =
  let i = find (fun i => ! infnorm_lt z.[i] (gamma1 - Beta)) (range 0 lvec) in
  if i < lvec then Some i else None.

op r0fail_idx (r0 : polykvec) : int option =
  let i = find (fun i => ! infnorm_lt r0.[i] (gamma2 - Beta)) (range 0 kvec) in
  if i < kvec then Some i else None.

(* weight of the first i polynomials of a hint *)
op hint_weight (h : polykvec) (i : int) : int =
  Bigint.BIA.bigi predT (fun j => count (fun jj => h.[j].[jj] <> Zq.zero) (iota_ 0 256)) 0 i.

op hintfail_idx (h : polykvec) : int option =
  let i = find (fun i => w_hint < hint_weight h (i + 1)) (range 0 kvec) in
  if i < kvec then Some i else None.

(* the cascades pass exactly when the plain tests pass *)
lemma find_range_lt (p : int -> bool) (n : int) : 0 <= n =>
  (find p (range 0 n) < n) <=> exists i, 0 <= i < n /\ p i.
proof.
move=> ge0n; have := has_find p (range 0 n).
rewrite size_range (_ : max 0 (n - 0) = n) 1:/# => <-.
by rewrite hasP; split => -[i [/mem_range hi hp]]; exists i => //; rewrite mem_range.
qed.

lemma zfail_idx_None (z : polylvec) :
  zfail_idx z = None <=> PolyLVec.infnorm_lt z (gamma1 - Beta).
proof.
rewrite /zfail_idx /= PolyLVec.infnorm_lt_polyE allP.
have := find_range_lt (fun i => ! Rq.infnorm_lt z.[i] (gamma1 - Beta)) lvec _; 1: smt(gt0_l).
by move=> h; smt(mem_iota).
qed.

lemma r0fail_idx_None (r0 : polykvec) :
  r0fail_idx r0 = None <=> PolyKVec.infnorm_lt r0 (gamma2 - Beta).
proof.
rewrite /r0fail_idx /= PolyKVec.infnorm_lt_polyE allP.
have := find_range_lt (fun i => ! Rq.infnorm_lt r0.[i] (gamma2 - Beta)) kvec _; 1: smt(gt0_k).
by move=> h; smt(mem_iota).
qed.

(* per polynomial version of [bz_sync]: under |cs2| <= Beta, the cascade
   of the r0 test fails at the same polynomial on LowBits (w - cs2) and on
   LowBits w - cs2 *)
lemma r0fail_sync (w cs2 : polykvec) :
    PolyKVec.infnorm_lt cs2 (Beta + 1) =>
    r0fail_idx (polykvec_LowBits (w - cs2)) = r0fail_idx (polykvec_LowBits w - cs2).
proof.
move=> Hcs2; rewrite /r0fail_idx /=.
rewrite (find_eq_in (fun i => ! Rq.infnorm_lt (polykvec_LowBits w - cs2).[i] (gamma2 - Beta))) //.
move=> k /mem_range Hk /=.
suff -> : Rq.infnorm_lt (polykvec_LowBits (w - cs2)).[k] (gamma2 - Beta) =
          Rq.infnorm_lt (polykvec_LowBits w - cs2).[k] (gamma2 - Beta) by done.
rewrite /Rq.infnorm_lt eq_iff.
apply eq_all_in => j Hj_iota.
have Hj : 0 <= j < n by smt(mem_iota).
rewrite /= /polykvec_LowBits KArray.mapiE 1:/# polykvec_sub_iE 1:/# polykvec_sub_iE 1:/#.
rewrite KArray.mapiE 1:/#.
rewrite /poly_LowBits poly_addE 1:/# !Array256.initiE 1,2:/# /= !poly_addE 1:/# !poly_negE 1:/#.
have HLBS := LowBits_sub_sync w.[k].[j] cs2.[k].[j] _.
+ move: Hcs2; rewrite /PolyKVec.infnorm_lt !allP => Hcs2.
  have := Hcs2 k _; first by rewrite mem_iota /#.
  rewrite /= allP => Hcs2k.
  have := Hcs2k j _; first by rewrite mem_iota /#.
  by simplify => /#.
by rewrite HLBS.
qed.

lemma hint_weight_le (h : polykvec) (i j : int) :
  0 <= i <= j => hint_weight h i <= hint_weight h j.
proof.
move=> [ge0_i le_ij]; rewrite /hint_weight (Bigint.BIA.big_cat_int i 0 j) //.
have := Bigint.sumr_ge0 predT (fun j => count (fun jj => h.[j].[jj] <> Zq.zero) (iota_ 0 256)) (range i j) _.
- by move=> a _ /=; exact count_ge0.
smt().
qed.

lemma hintfail_idx_None (h : polykvec) :
  hintfail_idx h = None <=> hammw h w_hint.
proof.
have hk := gt0_k.
have -> : hammw h w_hint <=> hint_weight h kvec <= w_hint.
- by rewrite /hammw /hint_weight /range.
rewrite /hintfail_idx /=.
have := find_range_lt (fun i => w_hint < hint_weight h (i + 1)) kvec _; 1: smt().
pose i0 := find _ (range 0 kvec); move=> hf.
case: (i0 < kvec) => hc /=.
- have [i [hi hlt]] : exists i, 0 <= i < kvec /\ w_hint < hint_weight h (i + 1) by rewrite -hf.
  by have := hint_weight_le h (i + 1) kvec _; smt().
rewrite lezNgt; apply/negP => hlt.
by apply hc; apply hf; exists (kvec - 1) => /#.
qed.

module MLDSA(XOFA : XOF_RejNTTPoly, XOFS : XOF_RejBPoly, XOFSIB : XOF_SIB, RO : LeakyRO) = {
   proc keygen_derand(eps : Bytes32.t) : BytesSK.t * BytesPK.t= {
     var sk,rho,rhop,_K,_A,s1,s2,t,t1,t0,pk,tr,epsp;
     epsp <- Bytes34.of_list (Bytes32.to_list eps ++ [W8.of_int kvec;W8.of_int lvec]);
     (rho,rhop,_K) <- H_seed epsp;
     _A <@ ExpandA(XOFA).sample(rho);
     (s1,s2) <@ ExpandS(XOFS).sample(rhop);
     t <- invnttv (ntt_mulmxv _A (nttv s1)) + s2;
     (t1,t0) <- Power2Round t;
     pk <@ PkEncDec.pkEncode(rho,t1);
     tr <- H_tr pk;
     sk <@ SkEncDec.skEncode(rho,_K,tr,s1,s2,t0);
     return (sk,pk);
  }

  proc sign_derand(sk : BytesSK.t, m : W8.t list, coins : rnd_) : BytesSig.t option * leakage = {
     var rho,_K,tr,s1,s2,t0,s1h,s2h,t0h,_A,mu,rhopp,kappa,y,w,w1,ctl,ct,c,ch,cs1,
         cs2,z,r0,ct0,h,leakage,sigma,bct0;
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
     leakage <- kvec_leak t0h;
     _A <@ ExpandA(XOFA).sample(rho);
     mu <- H_mu tr m;
     rhopp <- H_rhopp _K coins mu;
     kappa <- 0;
     zh <- None;
     while (zh = None && ! (kappa_max <= kappa)) {
       y <@ ExpandMask.sample(rhopp,kappa * lvec);
       w <- invnttv (ntt_mulmxv _A (nttv y));
       w1 <- polykvec_HighBits w;
       ctl <@ RO(XOFSIB).get(mu,w1Encode w1);
       (ct,c) <- ctl.`1;
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

  (* Eager variant: decomposes w into (w0,w1) immediately, then uses w0 - cs2.
     The Jasmin implementation follows this order. *)
  proc sign_eager(sk : BytesSK.t, m : W8.t list, coins : rnd_) : BytesSig.t option * leakage = {
     var rho,_K,tr,s1,s2,t0,s1h,s2h,t0h,_A,mu,rhopp,kappa,y,w,w0,w1,ctl,ct,c,ch,cs1,
         cs2,z,r0,ct0,h,leakage,sigma,bct0;
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
     leakage <- kvec_leak t0h;
     _A <@ ExpandA(XOFA).sample(rho);
     mu <- H_mu tr m;
     rhopp <- H_rhopp _K coins mu;
     kappa <- 0;
     zh <- None;
     while (zh = None && ! (kappa_max <= kappa)) {
       y <@ ExpandMask.sample(rhopp,kappa * lvec);
       w <- invnttv (ntt_mulmxv _A (nttv y));
       (* eager decomposition: split w now *)
       w0 <- polykvec_LowBits w;
       w1 <- polykvec_HighBits w;
       ctl <@ RO(XOFSIB).get(mu,w1Encode w1);
       (ct,c) <- ctl.`1;
       leakage <- lcat leakage ctl.`2;
       ch <- ntt c;
       leakage <- lcat leakage (poly_leak ch);
       cs1 <- invnttv (ntt_smul ch s1h);
       z <- y + cs1;
       zf <- zfail_idx z;
       leakage <- lcat leakage (oileak zf);
       if (zf = None) {
         cs2 <- invnttv (ntt_smul ch s2h);
         r0 <- w0 - cs2;
         rf <- r0fail_idx r0;
         leakage <- lcat leakage (oileak rf);
         if (rf = None) {
           ct0 <- invnttv (ntt_smul ch t0h);
           h <- PolyKVec.MakeHintImpl w1 (r0 + ct0);
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
    var rho,t1,c,l,ct,z,h,rb,_A,tr,mu,wapprox,w1,ctp;
    w1 <- witness;
    rb <- false;
    (rho,t1) <@ PkEncDec.pkDecode(pk);
    (ct,z,h) <@ SigEncDec.sigDecode(sigma);
    if (h <> None) {
      _A <@ ExpandA(XOFA).sample(rho);
      tr <- H_tr pk;
      mu <- H_mu tr m;
      (c,l) <@ SampleInBall(XOFSIB).sample(ct); (* we don't care about leakage in verify *)
      wapprox <- invnttv (ntt_mulmxv _A (nttv z) - (ntt_smul (ntt c) (nttv (smul t1 (incoeff (2^d))))));
      w1 <- UseHint (oget h) wapprox;
      ctp <- H_ct mu (w1Encode w1);
      rb <-  infnorm_lt z (gamma1 - Beta);
      rb <- rb && ct = ctp;
    }
    return rb;
  }
}.

(* The eager decomposition is equivalent to the standard one.
   Stated for the concrete XOFs to avoid module restriction issues.
   Two algebraic facts are needed in the loop body:
   (1) LowBits commutativity: LowBits(w-cs2) = LowBits(w)-cs2 (same bz infnorm check).
   (2) MakeHintImpl_MakeHint_equiv: MakeHintImpl(w1, r0+ct0) = MakeHint(-ct0, w-cs2+ct0)
       where w1 = HighBits(w) and r0 = LowBits(w)-cs2. *)
lemma sign_eager_equiv :
    equiv [ MLDSA(MLDSA_XOFA, MLDSA_XOFS, MLDSA_XOF_SIB, SIB_RO).sign_derand ~
            MLDSA(MLDSA_XOFA, MLDSA_XOFS, MLDSA_XOF_SIB, SIB_RO).sign_eager :
      ={sk, m, coins,
        glob MLDSA_XOFA, glob MLDSA_XOFS, glob MLDSA_XOF_SIB, glob SIB_RO}
      /\ valid_sk_s2 sk{1}
      ==>
      ={res} ].
proof.
proc.
(* Break seq 15 15 into: 5 witness assignments (sim), skDecode (equiv bridge
   skDecode_equiv_bound which yields infnorm_lt s2), 3 nttv assignments and
   the leakage of t0h (auto yields s2h = nttv s2), 5 remaining assignments (sim). *)
seq 15 15 : (={rho, _K, tr, s1, s2, t0, s1h, s2h, t0h, _A, mu, rhopp,
               kappa, zh, leakage, sigma, ct, ctl, rf, hf,
               glob MLDSA_XOFA, glob MLDSA_XOFS, glob MLDSA_XOF_SIB, glob SIB_RO}
            /\ PolyKVec.infnorm_lt s2{1} (Eta + 1)
            /\ s2h{1} = nttv s2{1}).
+ seq 5 5 : (={sk, m, coins, ct, ctl, sigma, rf, hf,
               glob MLDSA_XOFA, glob MLDSA_XOFS, glob MLDSA_XOF_SIB, glob SIB_RO}
             /\ valid_sk_s2 sk{1}); 1: by auto.
  seq 1 1 : (={sk, m, coins, ct, ctl, sigma, rf, hf, rho, _K, tr, s1, s2, t0,
               glob MLDSA_XOFA, glob MLDSA_XOFS, glob MLDSA_XOF_SIB, glob SIB_RO}
             /\ PolyKVec.infnorm_lt s2{1} (Eta + 1)); 1: by call skDecode_equiv_bound.
  seq 4 4 : (={sk, m, coins, ct, ctl, sigma, rf, hf, rho, _K, tr, s1, s2, t0,
               s1h, s2h, t0h, leakage,
               glob MLDSA_XOFA, glob MLDSA_XOFS, glob MLDSA_XOF_SIB, glob SIB_RO}
             /\ PolyKVec.infnorm_lt s2{1} (Eta + 1)
             /\ s2h{1} = nttv s2{1}); 1: by auto.
  wp; call(: ={glob MLDSA_XOFA, glob MLDSA_XOFS, glob MLDSA_XOF_SIB, glob SIB_RO});
    first by sim.
  by auto.
seq 1 1 : (={rho, _K, tr, s1, s2, t0, s1h, s2h, t0h, _A, mu, rhopp,
              kappa, zh, leakage, sigma, ct, ctl, rf, hf,
              glob MLDSA_XOFA, glob MLDSA_XOFS,  glob SIB_RO}
            /\ PolyKVec.infnorm_lt s2{1} (Eta + 1)
            /\ s2h{1} = nttv s2{1}); last by sim.
while (={rho, _K, tr, s1, s2, t0, s1h, s2h, t0h, _A, mu, rhopp,
           kappa, zh, leakage, sigma, ct, ctl, rf, hf,
           glob MLDSA_XOFA, glob MLDSA_XOFS,  glob SIB_RO}
        /\ PolyKVec.infnorm_lt s2{1} (Eta + 1)
        /\ s2h{1} = nttv s2{1}); last by auto => />.
(* up to the z test: same z, same z cascade; cs2 is not computed yet, its
   bound is stated on its definition *)
seq 12 13 : (={_K, tr, s1, s2, t0,
                   w, w1, c, ch, cs1, z, zf, ct, ctl, leakage, rf, hf,
                   rho, s1h, s2h, t0h, _A, mu, rhopp, kappa, zh, sigma,
                   glob MLDSA_XOFA, glob MLDSA_XOFS,  glob SIB_RO}
             /\ PolyKVec.infnorm_lt s2{1} (Eta + 1)
             /\ s2h{1} = nttv s2{1}
             /\ PolyKVec.infnorm_lt (invnttv (ntt_smul ch{1} s2h{1})) (Beta + 1)
             /\ w1{1} = polykvec_HighBits w{1}
             /\ w0{2} = polykvec_LowBits w{2}).
+ seq 1 1 : (#pre /\ ={y}); 1: by conseq />;sim.
  sp; inline {1} 1; inline {2} 1.
  wp.
  ecall{2} (SampleInBall_correct ct1{2}).
  ecall{1} (SampleInBall_correct ct1{1}).
  auto => /> &2 Hs2 Hkappa.
  by apply cs2_norm_bound; [apply sampleInBall_norm | exact Hs2].
seq 1 1 : (={_K, tr, s1, s2, t0, rho, s1h, s2h, t0h, _A, mu, rhopp, kappa, zh,
              sigma, ct, ctl, leakage, rf, hf,
              glob MLDSA_XOFA, glob MLDSA_XOFS,  glob SIB_RO}
           /\ PolyKVec.infnorm_lt s2{1} (Eta + 1)
           /\ s2h{1} = nttv s2{1}); last by auto.
if; 1: by auto.
- (* the r0 cascade: same index on LowBits (w - cs2) and LowBits w - cs2 *)
  seq 4 4 : (#pre /\ ={cs2, rf, leakage}
             /\ PolyKVec.infnorm_lt cs2{1} (Beta + 1)
             /\ r0{2} = polykvec_LowBits w{1} - cs2{1} /\ rf{2} = r0fail_idx r0{2}).
  + auto => /> &2 _ Hcs2.
    by rewrite (r0fail_sync w{2} _ Hcs2).
  if; 1: by auto.
  - seq 5 5 : (#pre /\ ={ct0, h, hf, bct0}); last by if; auto.
    auto => /> &2 _ _ Hcs2 Hr0.
    (* the rejection test bounds the low bits: |LowBits w - cs2| < gamma2 - Beta *)
    have Hlow : infnorm_lt (polykvec_LowBits w{2} - cs2{2}) gamma2.
    - apply (infnorm_lt_le _ (gamma2 - Beta)); 1: smt(Beta_bnd).
      by rewrite -r0fail_idx_None.
    by rewrite (polykvec_MakeHintImpl_MakeHint_equiv w{2} cs2{2}
                  (invnttv (ntt_smul ch{2} t0h{2})) Hcs2 Hlow).
  by auto.
by auto.
qed.

end MLDSAT.
