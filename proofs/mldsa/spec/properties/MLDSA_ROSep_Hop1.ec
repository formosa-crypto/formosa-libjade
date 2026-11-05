require import AllCore IntDiv List Distr DList PROM FMap Xreal StdBigop StdOrder.
from Jasmin require import JByte_array JWord.
require import Array256.

require import Parameters GFq Rq.
require MLDSA_ROSep.
require import MLDSA_RO MLDSA_ROSep.
require import DistrExtra.

require import Leakage.
abstract theory MLDSA_ROSep_Hop1.

clone include MLDSA_ROSep.MLDSA_ROSep.
import Spec.
import PolyLVec PolyKVec PolyMat.
import Round ZModQ Zq MLDSAParams.


(* G0': verify rejects c~ = tr *)
module MLDSA_RO_DS1(H : BlockOracle, G : Oracle) = {
  var pkv : BytesPK.t
  var bad : bool

  proc keygen() : BytesPK.t * BytesSK.t = {
    var r;
    r <@ MLDSA_RO_DS(H, G).keygen();
    pkv <- r.`1;
    return r;
  }

  proc sign = MLDSA_RO_DS(H, G).sign

  proc verify(pk : BytesPK.t, m : W8.t list, sigma : BytesSig.t) : bool = {
    var b, ct, bs;
    b <@ MLDSA_RO(H, G).verify(pk, sigma, m);
    ct <- BytesCT.init (fun ii => BytesSig."_.[_]" sigma ii);
    bs <@ Squeeze(H).squeeze(BytesPK.to_list pk, 64);
    bad <- b /\ BytesCT.to_list ct = bs;
    return b /\ BytesCT.to_list ct <> bs;
  }
}.

(*************** Collision of an H_ct block with tr ****************)

op rel (x : W8.t list * int) : bool = size x.`1 = 64 + w1_bytes /\ x.`2 = 0.

op coll (m : (W8.t list * int, W8.t list) fmap) (pk : BytesPK.t) : bool =
  exists x, rel x /\ x \in m /\ m.[x] = m.[(BytesPK.to_list pk, 0)].

lemma coll_set m pk x r :
  (BytesPK.to_list pk, 0) \in m => x \notin m => coll m.[x <- r] pk =>
  coll m pk \/ (rel x /\ r = oget m.[(BytesPK.to_list pk, 0)]).
proof.
move=> hpk hx [y [hy [hym heq]]].
have hne : (BytesPK.to_list pk, 0) <> x by smt().
case: (y = x) => [->> | hney].
+ right; split => //.
  by move: heq; rewrite !get_setE /= hne /= => <-.
left; exists y; split => //; split; 1: smt(mem_set).
by move: heq; rewrite !get_setE hney hne.
qed.

op allsize (m : (W8.t list * int, W8.t list) fmap) : bool =
  forall p, p \in m => size (oget m.[p]) = 64.

op inv_m (m : (W8.t list * int, W8.t list) fmap) (pk : BytesPK.t) : bool =
  (BytesPK.to_list pk, 0) \in m /\ allsize m.

(* A fresh H_ct block costs p512 of potential; everything else is free *)
ehoare RO1_get_coll (pk0 : BytesPK.t) (x1 : W8.t list * int)
                    (m1 : (W8.t list * int, W8.t list) fmap) (c : real) : DS2.RO1.RO.get :
  (inv_m DS2.RO1.RO.m pk0 /\ x = x1 /\ DS2.RO1.RO.m = m1 /\ 0%r <= c) `|`
    (b2r (coll DS2.RO1.RO.m pk0) + b2r (rel x1) * p512 + c)%xr
  ==> (inv_m DS2.RO1.RO.m pk0 /\ x1 \in DS2.RO1.RO.m /\ res = oget DS2.RO1.RO.m.[x1] /\
       forall p, p \in m1 => DS2.RO1.RO.m.[p] = m1.[p]) `|`
    (b2r (coll DS2.RO1.RO.m pk0) + c)%xr.
proof.
proc; auto => &hr /=.
apply xle_cxr_r => -[[hin hsz] [<<- [<<- hc]]].
move: hsz; rewrite /allsize => hsz.
apply (xle_trans (Ep dblock (fun r =>
         (b2r (coll DS2.RO1.RO.m{hr} pk0 \/
               (rel x{hr} /\ r = oget DS2.RO1.RO.m{hr}.[(BytesPK.to_list pk0, 0)])) + c)%xr))).
+ apply le_Ep => r hr /=; rewrite /(`|`).
  have hrs : size r = 64 by move: hr; rewrite /dblock supp_dlist //; smt().
  case: (x{hr} \notin DS2.RO1.RO.m{hr}) => hx /=.
  - have -> /= : inv_m DS2.RO1.RO.m{hr}.[x{hr} <- r] pk0 /\
                 (x{hr} \in DS2.RO1.RO.m{hr}.[x{hr} <- r]) /\
                 forall (p : W8.t list * int), p \in DS2.RO1.RO.m{hr} =>
                   DS2.RO1.RO.m{hr}.[x{hr} <- r].[p] = DS2.RO1.RO.m{hr}.[p].
    + split; 2: by rewrite mem_set /= => p hp; rewrite get_setE; smt().
      rewrite /inv_m /allsize mem_set hin /= => p; rewrite mem_set get_setE.
      by case: (p = x{hr}) => [->> /= | hne /= hp]; [rewrite hrs | apply hsz].
    by have hcs := coll_set _ pk0 _ r hin hx; apply le_pos; smt().
  have -> /= : inv_m DS2.RO1.RO.m{hr} pk0 /\ (x{hr} \in DS2.RO1.RO.m{hr}) by smt().
  by apply le_pos; smt().
apply (Ep_hitE dblock _ _ (fun r => coll DS2.RO1.RO.m{hr} pk0 \/
         (rel x{hr} /\ r = oget DS2.RO1.RO.m{hr}.[(BytesPK.to_list pk0, 0)]))
         (pred1 (oget DS2.RO1.RO.m{hr}.[(BytesPK.to_list pk0, 0)])) c p512) => //.
+ by rewrite /dblock dlist_ll W8.dword_ll.
by apply mu1_dblock.
qed.

(* Squeezing costs p512 only when the input has the H_ct length *)
ehoare Squeeze_coll (pk0 : BytesPK.t) (x0 : W8.t list) (len0 : int) (c : real) :
  Squeeze(DS2.RO1.RO).squeeze :
  (inv_m DS2.RO1.RO.m pk0 /\ x = x0 /\ len = len0 /\ 0%r <= c) `|`
    (b2r (coll DS2.RO1.RO.m pk0) + b2r (size x0 = 64 + w1_bytes /\ 0 < len0) * p512 + c)%xr
  ==> (inv_m DS2.RO1.RO.m pk0 /\
       (0 < len0 <= 64 => (x0, 0) \in DS2.RO1.RO.m /\
                          res = take len0 (oget DS2.RO1.RO.m.[(x0, 0)]))) `|`
    (b2r (coll DS2.RO1.RO.m pk0) + c)%xr.
proof.
proc.
while ((inv_m DS2.RO1.RO.m pk0 /\ x = x0 /\ len = len0 /\ 0%r <= c /\ 0 <= j /\
        (j = 0 => r = []) /\
        (0 < j => 64 * (j - 1) < len /\ (x0, 0) \in DS2.RO1.RO.m /\
                  (j = 1 => r = oget DS2.RO1.RO.m.[(x0, 0)]))) `|`
       (b2r (coll DS2.RO1.RO.m pk0) +
        b2r (size x0 = 64 + w1_bytes /\ j = 0 /\ 0 < len0) * p512 + c)%xr).
+ move=> &hr; apply xle_cxr_r => hj; apply xle_cxr => /> *.
  by split; [smt() | apply le_pos; smt(RealOrder.expr_ge0)].
+ wp; exlim j, r, DS2.RO1.RO.m => j_ r_ m_.
  call /(fun y => (x = x0 /\ len = len0 /\ j = j_ /\ r = r_ /\ 0%r <= c /\ 0 <= j_ /\
                   64 * j_ < len /\ (j_ = 0 => r_ = []) /\
                   (0 < j_ => 64 * (j_ - 1) < len /\ (x0, 0) \in m_ /\
                             (j_ = 1 => r_ = oget m_.[(x0, 0)]))) `|` y)
       (RO1_get_coll pk0 (x0, j_) m_ c).
  + move=> &hr /=; apply xle_cxr_r => /> *.
    by apply xle_cxr_l; [smt(domE) | apply xle_rle; smt(RealOrder.expr_ge0)].
  skip => &hr /=; apply xle_cxr => /> *.
  by apply le_pos; rewrite /rel /=; smt().
by auto => &hr /=; apply xle_cxr => /> *.
qed.

ehoare ReadByte_coll (pk0 : BytesPK.t) (x0 : W8.t list) (p0 : int) (c : real) :
  ReadByte(DS2.RO1.RO).read :
  (inv_m DS2.RO1.RO.m pk0 /\ x = x0 /\ p = p0 /\ 0%r <= c) `|`
    (b2r (coll DS2.RO1.RO.m pk0) + b2r (rel (x0, p0 %/ 64)) * p512 + c)%xr
  ==> inv_m DS2.RO1.RO.m pk0 `|` (b2r (coll DS2.RO1.RO.m pk0) + c)%xr.
proof.
proc; exlim DS2.RO1.RO.m => m_.
call /(fun y => (x = x0 /\ p = p0 /\ 0%r <= c) `|` y) (RO1_get_coll pk0 (x0, p0 %/ 64) m_ c).
+ by move=> &hr /=; apply xle_cxr => />.
by skip => &hr /=; apply xle_cxr => />.
qed.

(* SampleInBall only reads inputs of length lambda/4, so it is free *)
ehoare SampleInBall_coll (pk0 : BytesPK.t) (k : real) : SampleInBall_O(DS2.RO1.RO).sample :
  (inv_m DS2.RO1.RO.m pk0 /\ 0%r <= k) `|` (b2r (coll DS2.RO1.RO.m pk0) + k)%xr
  ==> inv_m DS2.RO1.RO.m pk0 `|` (b2r (coll DS2.RO1.RO.m pk0) + k)%xr.
proof.
proc; while ((inv_m DS2.RO1.RO.m pk0 /\ 0%r <= k) `|` (b2r (coll DS2.RO1.RO.m pk0) + k)%xr).
+ by move=> &hr /=; apply xle_cxr => />.
+ wp; while ((inv_m DS2.RO1.RO.m pk0 /\ 0%r <= k) `|` (b2r (coll DS2.RO1.RO.m pk0) + k)%xr).
  + by move=> &hr /=; apply xle_cxr => />.
  + wp; exlim pos, rho => pos_ rho_.
    call /(fun y => (0%r <= k) `|` y) (ReadByte_coll pk0 (BytesCT.to_list rho_) pos_ k).
    + by move=> &hr /=; apply xle_cxr => />.
    auto => &hr /=; apply xle_cxr => /> *.
    by apply le_pos; rewrite /rel /=; smt(ct_len_nrel BytesCT.size_to_list).
  wp; exlim pos, rho => pos_ rho_.
  call /(fun y => (0%r <= k) `|` y) (ReadByte_coll pk0 (BytesCT.to_list rho_) pos_ k).
  + by move=> &hr /=; apply xle_cxr => />.
  auto => &hr /=; apply xle_cxr => /> *.
  by apply le_pos; rewrite /rel /=; smt(ct_len_nrel BytesCT.size_to_list).
wp; exlim rho => rho_.
call /(fun y => (0%r <= k) `|` y) (Squeeze_coll pk0 (BytesCT.to_list rho_) 8 k).
+ by move=> &hr /=; apply xle_cxr => />.
auto => &hr /=; apply xle_cxr => /> *.
by apply le_pos; smt(ct_len_nrel BytesCT.size_to_list).
qed.

(* The H_ct squeeze costs p512, SampleInBall is free *)
ehoare SIB_RO_coll (pk0 : BytesPK.t) (k : real) : SIB_RO_O(DS2.RO1.RO).get :
  (inv_m DS2.RO1.RO.m pk0 /\ 0%r <= k) `|` (b2r (coll DS2.RO1.RO.m pk0) + p512 + k)%xr
  ==> inv_m DS2.RO1.RO.m pk0 `|` (b2r (coll DS2.RO1.RO.m pk0) + k)%xr.
proof.
proc; wp; call (SampleInBall_coll pk0 k); wp; exlim mu, w1 => mu_ w1_.
call /(fun y => (0%r <= k) `|` y)
     (Squeeze_coll pk0 (Bytes64.to_list mu_ ++ BytesW1.to_list w1_) (lambda %/ 4) k).
+ by move=> &hr /=; apply xle_cxr => />.
by skip => &hr /=; apply xle_cxr => /> *; apply le_pos; smt(RealOrder.expr_ge0).
qed.

(* ExpandMask squeezes 66-byte inputs, so it is free *)
ehoare ExpandMask_coll (pk0 : BytesPK.t) (k : real) : ExpandMask_O(DS2.RO1.RO).sample :
  (inv_m DS2.RO1.RO.m pk0 /\ 0%r <= k) `|` (b2r (coll DS2.RO1.RO.m pk0) + k)%xr
  ==> inv_m DS2.RO1.RO.m pk0 `|` (b2r (coll DS2.RO1.RO.m pk0) + k)%xr.
proof.
proc; while ((inv_m DS2.RO1.RO.m pk0 /\ 0%r <= k) `|` (b2r (coll DS2.RO1.RO.m pk0) + k)%xr).
+ by move=> &hr /=; apply xle_cxr => />.
+ seq 1 : ((inv_m DS2.RO1.RO.m pk0 /\ 0%r <= k) `|` (b2r (coll DS2.RO1.RO.m pk0) + k)%xr).
  + by auto => &hr /=; apply xle_cxr => />.
  wp; exlim rhop => rhop_.
  call /(fun y => (0%r <= k) `|` y)
       (Squeeze_coll pk0 (Bytes66.to_list rhop_) (n * (gamma1m1_bits + 1) %/ 8) k).
  + by move=> &hr /=; apply xle_cxr => />.
  skip => &hr /=; apply xle_cxr => /> *.
  by apply le_pos; smt(w1_bytes_big).
by auto.
qed.

(* Procedures that do not touch the SHAKE256 map keep any constant potential *)

ehoare hintBitPack_e (v : xreal) : HintPackUnpack.hintBitPack : v ==> v.
proof.
proc; while (v).
+ by move=> &hr; apply xle_cxr_r.
+ by wp; while (v); [move=> &hr; apply xle_cxr_r | auto => &hr; apply xle_cxr_r |
                     auto => &hr; apply xle_cxr_r].
by auto.
qed.

ehoare hintBitUnpack_e (v : xreal) : HintPackUnpack.hintBitUnpack : v ==> v.
proof.
proc; while (v).
+ by move=> &hr; apply xle_cxr_r.
+ by auto => &hr; apply xle_cxr_r => _; case: (to_uint (nth witness y{hr} index{hr}) <> 0).
while (v); [by move=> &hr; apply xle_cxr_r | | by auto].
seq 1 : ((i < kvec && !error) `|` v); 1: by auto.
if; 1: by auto => &hr; apply xle_cxr_r.
seq 2 : v; last by wp; skip => &hr; case: (! error{hr}).
while (v); [by move=> &hr; apply xle_cxr_r | | by auto => &hr; apply xle_cxr_r].
by wp; skip => &hr; apply xle_cxr_r => _;
   case: (_first{hr} < index{hr} /\
          to_uint (nth witness y{hr} index{hr}) <= to_uint (nth witness y{hr} (index{hr} - 1))).
qed.

ehoare skDecode_e (v : xreal) : SkEncDec.skDecode : v ==> v.
proof.
proc; do 3! (while (v); [by move=> &hr; apply xle_cxr_r | by auto => &hr; apply xle_cxr_r | wp]).
by auto.
qed.

ehoare sigEncode_e (v : xreal) : SigEncDec.sigEncode : v ==> v.
proof.
proc; wp; call (hintBitPack_e v).
by while (v); [move=> &hr; apply xle_cxr_r | auto => &hr; apply xle_cxr_r | auto].
qed.

ehoare pkDecode_e (v : xreal) : PkEncDec.pkDecode : v ==> v.
proof.
by proc; while (v); [move=> &hr; apply xle_cxr_r | auto => &hr; apply xle_cxr_r | auto].
qed.

ehoare sigDecode_e (v : xreal) : SigEncDec.sigDecode : v ==> v.
proof.
proc; call (hintBitUnpack_e v).
by while (v); [move=> &hr; apply xle_cxr_r | auto => &hr; apply xle_cxr_r | auto].
qed.

ehoare pkEncode_e (v : xreal) : PkEncDec.pkEncode : v ==> v.
proof.
by proc; wp; while (v); [move=> &hr; apply xle_cxr_r | auto => &hr; apply xle_cxr_r | auto].
qed.

ehoare skEncode_e (v : xreal) : SkEncDec.skEncode : v ==> v.
proof.
proc; wp; do 3! (while (v); [by move=> &hr; apply xle_cxr_r | by auto => &hr; apply xle_cxr_r | wp]).
by auto.
qed.

ehoare RO2_get_e (v : xreal) : DS2.RO2.RO.get : v ==> v.
proof.
proc; auto => &hr.
by rewrite (eq_Ep _ _ (fun _ => v)) 1:/# EpC W8.dword_ll.
qed.

ehoare RejNTTPoly_e (v : xreal) : RejNTTPoly(XOFA_O(DS2.RO2.RO)).sample : v ==> v.
proof.
proc; while (v); [by move=> &hr; apply xle_cxr_r | | by inline *; auto].
seq 1 : v.
+ inline XOFA_O(DS2.RO2.RO).next; wp; do 3! call (RO2_get_e v).
  by auto => &hr; apply xle_cxr_r.
by auto => &hr; case: (CoeffFromThreeBytes b3{hr}.[0] b3{hr}.[1] b3{hr}.[2] <> None).
qed.

ehoare ExpandA_e (v : xreal) : ExpandA(XOFA_O(DS2.RO2.RO)).sample : v ==> v.
proof.
proc; while (v); [by move=> &hr; apply xle_cxr_r | | by auto].
by wp; while (v); [move=> &hr; apply xle_cxr_r |
                   wp; call (RejNTTPoly_e v); auto => &hr; apply xle_cxr_r |
                   auto => &hr; apply xle_cxr_r].
qed.

(* One signing call costs p512 for H_mu and p512 per iteration for H_ct *)
ehoare sign_coll (pk0 : BytesPK.t) (k : real) : MLDSA_RO(DS2.RO1.RO, DS2.RO2.RO).sign_derand :
  (inv_m DS2.RO1.RO.m pk0 /\ 0%r <= k) `|`
    (b2r (coll DS2.RO1.RO.m pk0) + (1 + kappa_max)%r * p512 + k)%xr
  ==> inv_m DS2.RO1.RO.m pk0 `|` (b2r (coll DS2.RO1.RO.m pk0) + k)%xr.
proof.
proc; seq 17 : ((inv_m DS2.RO1.RO.m pk0 /\ 0%r <= k /\ kappa = 0) `|`
                (b2r (coll DS2.RO1.RO.m pk0) + kappa_max%r * p512 + k)%xr).
+ seq 13 : ((inv_m DS2.RO1.RO.m pk0 /\ 0%r <= k) `|`
            (b2r (coll DS2.RO1.RO.m pk0) + kappa_max%r * p512 + k)%xr).
  + seq 11 : ((inv_m DS2.RO1.RO.m pk0 /\ 0%r <= k) `|`
             (b2r (coll DS2.RO1.RO.m pk0) + (1 + kappa_max)%r * p512 + k)%xr).
    + exlim DS2.RO1.RO.m => m0.
      call /(fun y => (DS2.RO1.RO.m = m0) `|` y)
           (ExpandA_e ((inv_m m0 pk0 /\ 0%r <= k) `|`
                       (b2r (coll m0 pk0) + (1 + kappa_max)%r * p512 + k)%xr)).
      + by move=> &hr /=; apply xle_cxr_r => [#] hm hinv hk; rewrite hm hinv hk.
      wp; call /(fun y => (DS2.RO1.RO.m = m0) `|` y)
           (skDecode_e ((inv_m m0 pk0 /\ 0%r <= k) `|`
                        (b2r (coll m0 pk0) + (1 + kappa_max)%r * p512 + k)%xr)).
      auto => &hr /=.
      by apply xle_cxr_r => [#] hm hinv hk; rewrite hm hinv hk.
    wp; exlim tr, m => tr_ m_.
    call /(fun y => (0%r <= k) `|` y)
         (Squeeze_coll pk0 (Bytes64.to_list tr_ ++ m_) 64 (kappa_max%r * p512 + k)).
    + by move=> &hr /=; apply xle_cxr => /> *; apply le_pos; smt(kappa_max_bnd).
    skip => &hr /=; apply xle_cxr => /> *.
    by split; [smt(RealOrder.expr_ge0 kappa_max_bnd) | apply le_pos; smt(RealOrder.expr_ge0 kappa_max_bnd)].
  wp; exlim _K, coins, mu => K_ c_ mu_.
  call /(fun y => (0%r <= k) `|` y)
       (Squeeze_coll pk0 (Bytes32.to_list K_ ++ rnd_to_list c_ ++ Bytes64.to_list mu_) 64
                     (kappa_max%r * p512 + k)).
  + by move=> &hr /=; apply xle_cxr => /> *; apply le_pos; smt(kappa_max_bnd).
  skip => &hr /=; apply xle_cxr => /> *.
  rewrite !size_cat Bytes32.size_to_list Bytes64.size_to_list /rnd_to_list Bytes32.size_to_list /=.
  by split; [smt(RealOrder.expr_ge0 kappa_max_bnd) | apply le_pos; smt(w1_bytes_big kappa_max_bnd)].
seq 1 : ((inv_m DS2.RO1.RO.m pk0 /\ 0%r <= k) `|` (b2r (coll DS2.RO1.RO.m pk0) + k)%xr).
+ while ((inv_m DS2.RO1.RO.m pk0 /\ 0%r <= k /\ 0 <= kappa) `|`
         (b2r (coll DS2.RO1.RO.m pk0) + (max 0 (kappa_max - kappa))%r * p512 + k)%xr).
  + by move=> &hr /=; apply xle_cxr => /> *; apply le_pos; smt(RealOrder.expr_ge0).
  + exlim kappa => kap.
    seq 3 : ((inv_m DS2.RO1.RO.m pk0 /\ 0%r <= k /\ kappa = kap /\ 0 <= kap /\ kap < kappa_max) `|`
             (b2r (coll DS2.RO1.RO.m pk0) + (max 0 (kappa_max - kap))%r * p512 + k)%xr).
    + wp; call /(fun y => (kappa = kap /\ 0 <= kap /\ kap < kappa_max /\ 0%r <= k) `|` y)
                (ExpandMask_coll pk0 ((max 0 (kappa_max - kap))%r * p512 + k)).
      + by move=> &hr /=; apply xle_cxr => /> *; apply le_pos; smt().
      skip => &hr /=; apply xle_cxr => /> *.
      by split; [smt(RealOrder.expr_ge0) | apply le_pos; smt()].
    wp; call /(fun y => (kappa = kap /\ 0 <= kap /\ kap < kappa_max /\ 0%r <= k) `|` y)
              (SIB_RO_coll pk0 ((max 0 (kappa_max - (kap + 1)))%r * p512 + k)).
    + move=> &hr /=; apply xle_cxr_r => /> *.
      by apply xle_cxr_l; [smt() | apply xle_rle; smt(RealOrder.expr_ge0)].
    skip => &hr /=; apply xle_cxr => /> *; split; 1: smt(RealOrder.expr_ge0).
    apply le_pos.
    have -> : max 0 (kappa_max - kappa{hr}) = 1 + max 0 (kappa_max - (kappa{hr} + 1)) by smt().
    by rewrite fromintD; smt().
  by skip => &hr /=; apply xle_cxr => /> *; apply le_pos; smt(RealOrder.expr_ge0 kappa_max_bnd).
if; last by auto => &hr /=; apply xle_cxr => />.
exlim DS2.RO1.RO.m => m0.
call /(fun y => (DS2.RO1.RO.m = m0) `|` y)
     (sigEncode_e (inv_m m0 pk0 `|` (b2r (coll m0 pk0) + k)%xr)).
+ by move=> &hr /=; apply xle_cxr_r => [#] hm hinv; rewrite hm hinv.
skip => &hr /=; apply xle_cxr_r => [#] hm _ hinv hk.
by rewrite hm hinv.
qed.

ehoare sigDecode_ct (s0 : BytesSig.t) (v : xreal) : SigEncDec.sigDecode :
  (sigma = s0) `|` v ==> (res.`1 = BytesCT.init (fun ii => BytesSig."_.[_]" s0 ii)) `|` v.
proof.
proc; call /(fun y => (ct = BytesCT.init (fun ii => BytesSig."_.[_]" s0 ii)) `|` y)
            (hintBitUnpack_e v).
by while ((ct = BytesCT.init (fun ii => BytesSig."_.[_]" s0 ii)) `|` v);
   [move=> &hr /=; apply xle_cxr => /> | auto => &hr /=; apply xle_cxr => /> |
    auto => &hr /=; apply xle_cxr => />].
qed.

(* Verification costs p512 for H_mu and p512 for H_ct. When it accepts, c~ is the
   first lambda/4 bytes of a block at an H_ct-length input. *)
ehoare verify_coll (pk0 : BytesPK.t) (s0 : BytesSig.t) (k : real) :
  MLDSA_RO(DS2.RO1.RO, DS2.RO2.RO).verify :
  (inv_m DS2.RO1.RO.m pk0 /\ sigma = s0 /\ 0%r <= k) `|`
    (b2r (coll DS2.RO1.RO.m pk0) + 2%r * p512 + k)%xr
  ==> (inv_m DS2.RO1.RO.m pk0 /\
       (res => exists x, rel x /\ x \in DS2.RO1.RO.m /\
                BytesCT.to_list (BytesCT.init (fun ii => BytesSig."_.[_]" s0 ii)) =
                take (lambda %/ 4) (oget DS2.RO1.RO.m.[x]))) `|`
    (b2r (coll DS2.RO1.RO.m pk0) + k)%xr.
proof.
proc; seq 4 : ((inv_m DS2.RO1.RO.m pk0 /\ 0%r <= k /\
                ct = BytesCT.init (fun ii => BytesSig."_.[_]" s0 ii) /\ !rb) `|`
               (b2r (coll DS2.RO1.RO.m pk0) + 2%r * p512 + k)%xr).
+ exlim DS2.RO1.RO.m => m0.
  call /(fun y => (DS2.RO1.RO.m = m0 /\ !rb) `|` y)
       (sigDecode_ct s0 ((inv_m m0 pk0 /\ 0%r <= k) `|`
                         (b2r (coll m0 pk0) + 2%r * p512 + k)%xr)).
  + by move=> &hr /=; apply xle_cxr_r => [#] hm hrb hct hinv hk; rewrite hm hrb hct hinv hk.
  call /(fun y => (DS2.RO1.RO.m = m0 /\ !rb /\ sigma = s0) `|` y)
       (pkDecode_e ((inv_m m0 pk0 /\ 0%r <= k) `|`
                    (b2r (coll m0 pk0) + 2%r * p512 + k)%xr)).
  + by move=> &hr /=; apply xle_cxr_r => [#] hm hrb hs hinv hk; rewrite hm hrb hs hinv hk.
  auto => &hr /=; apply xle_cxr_r => [#] hm hinv hs hk.
  by move: hinv hs hk; rewrite -hm => -> -> ->.
if; last by auto => &hr /=; apply xle_cxr => /> *; apply le_pos; smt(RealOrder.expr_ge0).
seq 8 : ((inv_m DS2.RO1.RO.m pk0 /\ 0%r <= k /\
          ct = BytesCT.init (fun ii => BytesSig."_.[_]" s0 ii)) `|`
         (b2r (coll DS2.RO1.RO.m pk0) + p512 + k)%xr).
+ seq 3 : ((inv_m DS2.RO1.RO.m pk0 /\ 0%r <= k /\
            ct = BytesCT.init (fun ii => BytesSig."_.[_]" s0 ii)) `|`
           (b2r (coll DS2.RO1.RO.m pk0) + 2%r * p512 + k)%xr).
  + seq 1 : ((inv_m DS2.RO1.RO.m pk0 /\ 0%r <= k /\
              ct = BytesCT.init (fun ii => BytesSig."_.[_]" s0 ii)) `|`
             (b2r (coll DS2.RO1.RO.m pk0) + 2%r * p512 + k)%xr).
    + exlim DS2.RO1.RO.m, ct => m0 ct0.
      call /(fun y => (DS2.RO1.RO.m = m0 /\ ct = ct0 /\
                       ct0 = BytesCT.init (fun ii => BytesSig."_.[_]" s0 ii)) `|` y)
           (ExpandA_e ((inv_m m0 pk0 /\ 0%r <= k) `|`
                       (b2r (coll m0 pk0) + 2%r * p512 + k)%xr)).
      + by move=> &hr /=; apply xle_cxr_r => [#] hm hct hct0 hinv hk;
           rewrite hm hct hct0 hinv hk.
      skip => &hr /=; apply xle_cxr_r => [#] H1 H2 H3 H4 H5 H6 H7.
      by rewrite H1 H2 H6 H4 H5.
    wp; exlim pk, ct => pk_ ct0.
    call /(fun y => (0%r <= k /\ ct = ct0 /\
                     ct0 = BytesCT.init (fun ii => BytesSig."_.[_]" s0 ii)) `|` y)
         (Squeeze_coll pk0 (BytesPK.to_list pk_) 64 (2%r * p512 + k)).
    + by move=> &hr /=; apply xle_cxr => /> *; apply le_pos; smt().
    skip => &hr /=; apply xle_cxr => /> *.
    by split; [smt(RealOrder.expr_ge0) | apply le_pos; smt(pk_len_nrel BytesPK.size_to_list)].
  seq 2 : ((inv_m DS2.RO1.RO.m pk0 /\ 0%r <= k /\
            ct = BytesCT.init (fun ii => BytesSig."_.[_]" s0 ii)) `|`
           (b2r (coll DS2.RO1.RO.m pk0) + p512 + k)%xr).
  + wp; exlim tr, m, ct => tr_ m_ ct0.
    call /(fun y => (0%r <= k /\ ct = ct0 /\
                     ct0 = BytesCT.init (fun ii => BytesSig."_.[_]" s0 ii)) `|` y)
         (Squeeze_coll pk0 (Bytes64.to_list tr_ ++ m_) 64 (p512 + k)).
    + by move=> &hr /=; apply xle_cxr => /> *; apply le_pos; smt().
    skip => &hr /=; apply xle_cxr => /> *.
    by split; [smt(RealOrder.expr_ge0) | apply le_pos; smt(RealOrder.expr_ge0)].
  wp; exlim ct => ct0.
  call /(fun y => (0%r <= k /\ ct = ct0 /\
                   ct0 = BytesCT.init (fun ii => BytesSig."_.[_]" s0 ii)) `|` y)
       (SampleInBall_coll pk0 (p512 + k)).
  + by move=> &hr /=; apply xle_cxr => /> *; apply le_pos; smt().
  skip => &hr /=; apply xle_cxr => /> *.
  by split; [smt(RealOrder.expr_ge0) | apply le_pos; smt()].
wp; exlim mu, w1, ct => mu_ w1_ ct0.
call /(fun y => (0%r <= k /\ ct = ct0 /\
                 ct0 = BytesCT.init (fun ii => BytesSig."_.[_]" s0 ii)) `|` y)
     (Squeeze_coll pk0 (Bytes64.to_list mu_ ++ BytesW1.to_list (w1Encode w1_)) (lambda %/ 4) k).
+ move=> &hr /=; apply xle_cxr => [#] hk hct hct0 hinv himp.
  have hlam : 0 < lambda %/ 4 <= 64 by have /= H := param_sets; smt().
  have [hx hbs] := himp hlam; split => //; split => // -[_ hctbs].
  exists (Bytes64.to_list mu_ ++ BytesW1.to_list (w1Encode w1_), 0).
  split; 1: by rewrite /rel /= size_cat Bytes64.size_to_list BytesW1.size_to_list.
  split => //; rewrite -hct0 -hct hctbs BytesCT.of_listK -?hbs //.
  by move: hinv => [_ hsz]; rewrite hbs size_take; smt().
by skip => &hr /=; apply xle_cxr => /> *; apply le_pos; smt(RealOrder.expr_ge0).
qed.

(* Squeezing a block that is already in the map leaves the map unchanged *)
ehoare Squeeze_in (x0 : W8.t list) (m0 : (W8.t list * int, W8.t list) fmap) (v : xreal) :
  Squeeze(DS2.RO1.RO).squeeze :
  (DS2.RO1.RO.m = m0 /\ x = x0 /\ len = 64 /\ (x0, 0) \in m0) `|` v
  ==> (DS2.RO1.RO.m = m0 /\ res = take 64 (oget m0.[(x0, 0)])) `|` v.
proof.
proc; while ((DS2.RO1.RO.m = m0 /\ x = x0 /\ len = 64 /\ (x0, 0) \in m0 /\ 0 <= j <= 1 /\
              (j = 0 => r = []) /\ (j = 1 => r = oget m0.[(x0, 0)])) `|` v).
+ by move=> &hr; apply xle_cxr_r => hj; apply xle_cxr => /> *; smt().
+ inline *; auto => &hr /=.
  apply xle_cxr_r => [#] hj hm hx hlen hin hj0 hj1 hr0 hr1; have hj' : j{hr} = 0 by smt().
  by rewrite hm hx hj' hin /= hr0 // hlen /= (eq_Ep _ _ (fun _ => v)) 1:/# EpC /dblock
             (dlist_ll W8.dword 64 W8.dword_ll).
by auto => &hr /=; apply xle_cxr => />.
qed.

(* bad in G0' implies coll: c~ = tr forces lambda/4 = 64, so the H_ct block equals the
   block at (pk, 0) *)
ehoare verify_bad (pk0 : BytesPK.t) : MLDSA_RO_DS1(DS2.RO1.RO, DS2.RO2.RO).verify :
  (inv_m DS2.RO1.RO.m pk0 /\ pk = pk0) `|` (b2r (coll DS2.RO1.RO.m pk0) + 2%r * p512)%xr
  ==> (MLDSA_RO_DS1.bad)%xr.
proof.
proc; exlim sigma => s0.
seq 1 : ((inv_m DS2.RO1.RO.m pk0 /\ pk = pk0 /\ sigma = s0 /\
          (b => exists x, rel x /\ x \in DS2.RO1.RO.m /\
                 BytesCT.to_list (BytesCT.init (fun ii => BytesSig."_.[_]" s0 ii)) =
                 take (lambda %/ 4) (oget DS2.RO1.RO.m.[x]))) `|`
         (b2r (coll DS2.RO1.RO.m pk0))%xr).
+ call /(fun y => (pk = pk0 /\ sigma = s0) `|` y) (verify_coll pk0 s0 0%r).
  + by move=> &hr /=; apply xle_cxr => />.
  by skip => &hr /=; apply xle_cxr => />.
wp; exlim DS2.RO1.RO.m, b => m0 b0.
call /(fun y => (pk = pk0 /\ ct = BytesCT.init (fun ii => BytesSig."_.[_]" s0 ii) /\
                 b = b0 /\ inv_m m0 pk0 /\
                 (b0 => exists x, rel x /\ x \in m0 /\
                         BytesCT.to_list (BytesCT.init (fun ii => BytesSig."_.[_]" s0 ii)) =
                         take (lambda %/ 4) (oget m0.[x]))) `|` y)
     (Squeeze_in (BytesPK.to_list pk0) m0 (b2r (coll m0 pk0))%xr).
+ move=> &hr /=.
  apply xle_cxr_r => [#] _ hct hb [hin hsz] himp hm hbs.
  case: (b{hr} /\ BytesCT.to_list ct{hr} = bs{hr}) => [[hb1 heq] | hn].
  + move: himp; rewrite -hb hb1 /= => -[x [hrel [hx hctx]]].
    have h1 : take (lambda %/ 4) (oget m0.[x]) = oget m0.[(BytesPK.to_list pk0, 0)].
    + by rewrite -hctx -hct heq hbs take_oversize // hsz.
    have hxe : oget m0.[x] = oget m0.[(BytesPK.to_list pk0, 0)].
    + rewrite -h1 take_oversize //; have := congr1 List.size _ _ h1; rewrite size_take;
      have := hsz _ hin; have := hsz _ hx; have /= := param_sets; smt().
    have hc : coll m0 pk0.
    + by exists x; rewrite hrel hx /= (get_some _ _ hx) (get_some _ _ hin) hxe.
    by rewrite hc.
  by case: (coll m0 pk0).
by auto => &hr /=; apply xle_cxr => /> *; smt().
qed.

(*************** Key generation queries no H_ct-length input ****************)

op norel (m : (W8.t list * int, W8.t list) fmap) : bool = forall x, x \in m => !rel x.

ehoare RO1_get_norel (x1 : W8.t list * int) (v : xreal) : DS2.RO1.RO.get :
  (norel DS2.RO1.RO.m /\ allsize DS2.RO1.RO.m /\ x = x1 /\ !rel x1) `|` v
  ==> (norel DS2.RO1.RO.m /\ allsize DS2.RO1.RO.m /\ x1 \in DS2.RO1.RO.m) `|` v.
proof.
proc; auto => &hr /=; apply xle_cxr_r => [#] hn hsz <<- hrel.
rewrite (eq_Ep _ _ (fun _ => v)) => [r0 hr0 /= | ];
  last by rewrite EpC /dblock (dlist_ll W8.dword 64 W8.dword_ll).
have hrs : size r0 = 64 by move: hr0; rewrite /dblock supp_dlist //; smt().
case: (x{hr} \notin DS2.RO1.RO.m{hr}) => hx /=; last by rewrite hn hsz /=; smt().
have -> // : norel DS2.RO1.RO.m{hr}.[x{hr} <- r0] /\ allsize DS2.RO1.RO.m{hr}.[x{hr} <- r0] /\
             x{hr} \in DS2.RO1.RO.m{hr}.[x{hr} <- r0].
rewrite mem_set /=; split => p; rewrite mem_set.
+ by case: (p = x{hr}) => [->> | hne /= hp] //; apply hn.
by rewrite get_setE; case: (p = x{hr}) => [->> | hne /= hp] //; apply hsz.
qed.

ehoare Squeeze_norel (x0 : W8.t list) (len0 : int) (v : xreal) : Squeeze(DS2.RO1.RO).squeeze :
  (norel DS2.RO1.RO.m /\ allsize DS2.RO1.RO.m /\ x = x0 /\ len = len0 /\
   size x0 <> 64 + w1_bytes) `|` v
  ==> (norel DS2.RO1.RO.m /\ allsize DS2.RO1.RO.m /\
       (0 < len0 <= 64 => (x0, 0) \in DS2.RO1.RO.m)) `|` v.
proof.
proc; while ((norel DS2.RO1.RO.m /\ allsize DS2.RO1.RO.m /\ x = x0 /\ len = len0 /\
              size x0 <> 64 + w1_bytes /\ 0 <= j /\
              (0 < len0 <= 64 => 0 < j => (x0, 0) \in DS2.RO1.RO.m)) `|` v).
+ by move=> &hr; apply xle_cxr_r => hj; apply xle_cxr => /> *; smt().
+ wp; exlim j => j_.
  call /(fun y => (x = x0 /\ len = len0 /\ size x0 <> 64 + w1_bytes /\ j = j_ /\ 0 <= j_ /\
                   64 * j_ < len0) `|` y)
       (RO1_get_norel (x0, j_) v).
  + by move=> &hr /=; apply xle_cxr => /> *; smt().
  by skip => &hr /=; apply xle_cxr => /> *; rewrite /rel /= /#.
by auto => &hr /=; apply xle_cxr => />.
qed.

ehoare XOFS_next_norel (v : xreal) : XOFS_O(DS2.RO1.RO).next :
  (norel DS2.RO1.RO.m /\ allsize DS2.RO1.RO.m) `|` v
  ==> (norel DS2.RO1.RO.m /\ allsize DS2.RO1.RO.m) `|` v.
proof.
proc; inline ReadByte(DS2.RO1.RO).read; wp; exlim XOFS_O.seed, XOFS_O.pos => s_ p_.
call /(fun y => y) (RO1_get_norel (Bytes66.to_list s_, p_ %/ 64) v).
+ by move=> &hr /=; apply xle_cxr => />.
auto => &hr /=; apply xle_cxr => /> *.
by rewrite /rel /=; smt(w1_bytes_big Bytes66.size_to_list).
qed.

ehoare RejBoundedPoly_norel (v : xreal) : RejBoundedPoly(XOFS_O(DS2.RO1.RO)).sample :
  (norel DS2.RO1.RO.m /\ allsize DS2.RO1.RO.m) `|` v
  ==> (norel DS2.RO1.RO.m /\ allsize DS2.RO1.RO.m) `|` v.
proof.
proc; while ((norel DS2.RO1.RO.m /\ allsize DS2.RO1.RO.m) `|` v);
  [by move=> &hr; apply xle_cxr_r | | by inline *; auto].
seq 1 : ((norel DS2.RO1.RO.m /\ allsize DS2.RO1.RO.m) `|` v).
+ by call (XOFS_next_norel v); skip => &hr; apply xle_cxr_r.
by auto.
qed.

ehoare ExpandS_norel (v : xreal) : ExpandS(XOFS_O(DS2.RO1.RO)).sample :
  (norel DS2.RO1.RO.m /\ allsize DS2.RO1.RO.m) `|` v
  ==> (norel DS2.RO1.RO.m /\ allsize DS2.RO1.RO.m) `|` v.
proof.
proc; while ((norel DS2.RO1.RO.m /\ allsize DS2.RO1.RO.m) `|` v).
+ by move=> &hr; apply xle_cxr_r.
+ by wp; call (RejBoundedPoly_norel v); auto => &hr; apply xle_cxr => />.
wp; while ((norel DS2.RO1.RO.m /\ allsize DS2.RO1.RO.m) `|` v);
  [by move=> &hr; apply xle_cxr_r | | by auto].
by wp; call (RejBoundedPoly_norel v); auto => &hr; apply xle_cxr => />.
qed.

ehoare keygen_norel (v : xreal) : MLDSA_RO_DS(DS2.RO1.RO, DS2.RO2.RO).keygen :
  (DS2.RO1.RO.m = empty) `|` v
  ==> (inv_m DS2.RO1.RO.m res.`1 /\ norel DS2.RO1.RO.m) `|` v.
proof.
proc; inline MLDSA_RO(DS2.RO1.RO, DS2.RO2.RO).keygen_derand; wp.
call /(fun y => (inv_m DS2.RO1.RO.m pk0 /\ norel DS2.RO1.RO.m) `|` y) (skEncode_e v).
seq 10 : ((norel DS2.RO1.RO.m /\ allsize DS2.RO1.RO.m) `|` v).
+ call /(fun y => (norel DS2.RO1.RO.m /\ allsize DS2.RO1.RO.m) `|` y) (pkEncode_e v).
  wp; call (ExpandS_norel v).
  call /(fun y => (norel DS2.RO1.RO.m /\ allsize DS2.RO1.RO.m) `|` y) (ExpandA_e v); wp.
  seq 3 : ((DS2.RO1.RO.m = empty) `|` v).
  + auto => &hr /=; apply xle_cxr_r => hm.
    have hll : is_lossless dxi by rewrite /dxi; apply dmap_ll; apply dlist_ll; apply W8.dword_ll.
    by rewrite hm /= EpC hll.
  exlim epsp => e_; call /(fun y => y) (Squeeze_norel (Bytes34.to_list e_) 128 v).
  by skip => &hr /=; apply xle_cxr => /> *; rewrite /norel /allsize;
     smt(mem_empty w1_bytes_big Bytes34.size_to_list).
wp; exlim pk0 => pk_.
call /(fun y => (pk0 = pk_) `|` y) (Squeeze_norel (BytesPK.to_list pk_) 64 v).
+ by move=> &hr /=; apply xle_cxr => />.
by skip => &hr /=; apply xle_cxr => /> *; smt(pk_len_nrel BytesPK.size_to_list).
qed.

(*************** Adversary queries ****************)

(* Remaining budget: p512 per SHAKE256 query, p512 per H_mu query and per signing
   iteration, 2 * p512 for the final verification. Zero once a query bound is exceeded. *)
op pot (qH qS ch cs : int) (m : (W8.t list * int, W8.t list) fmap) (pk : BytesPK.t) : xreal =
  if ch <= qH /\ cs <= qS
  then inv_m m pk `|`
       (b2r (coll m pk) + (qH - ch)%r * p512 +
        (qS - cs)%r * ((1 + kappa_max)%r * p512) + 2%r * p512)%xr
  else 0%xr.

ehoare CountH_get (qH qS : int) : CountH(DS2.RO1.RO).get :
  pot qH qS CountH.c CountS.c DS2.RO1.RO.m MLDSA_RO_DS1.pkv
  ==> pot qH qS CountH.c CountS.c DS2.RO1.RO.m MLDSA_RO_DS1.pkv.
proof.
proc; exlim x, DS2.RO1.RO.m, MLDSA_RO_DS1.pkv, CountH.c, CountS.c => x1 m1 pk0 ch cs.
call /(fun y => (MLDSA_RO_DS1.pkv = pk0 /\ CountH.c = ch + 1 /\ CountS.c = cs) `|`
                (if ch + 1 <= qH /\ cs <= qS then y else 0%xr))
     (RO1_get_coll pk0 x1 m1 ((qH - (ch + 1))%r * p512 +
                              (qS - cs)%r * ((1 + kappa_max)%r * p512) + 2%r * p512)).
+ move=> &hr; apply xle_cxr_r => [#] hpk hch hcs; rewrite /pot hpk hch hcs.
  case: (ch + 1 <= qH /\ cs <= qS) => hok //=.
  by apply xle_cxr => /> *; apply le_pos; smt(kappa_max_bnd).
wp; skip => &hr /=; apply xle_cxr_r => [#] ->> ->> ->> ->> ->>; rewrite /pot.
case: (CountH.c{hr} + 1 <= qH /\ CountS.c{hr} <= qS) => hok /=; last by apply xle0x.
have -> /= : CountH.c{hr} <= qH /\ CountS.c{hr} <= qS by smt().
apply xle_cxr => /> hinv _; have hp : 0%r <= p512 by smt(RealOrder.expr_ge0).
have hk : 0%r <= (qH - (CountH.c{hr} + 1))%r * p512 +
               (qS - CountS.c{hr})%r * ((1 + kappa_max)%r * p512) + 2%r * p512.
+ by smt(RealOrder.mulr_ge0 kappa_max_bnd).
by split => //; apply le_pos; smt(kappa_max_bnd).
qed.

ehoare RO2_get_pot (qH qS : int) : DS2.RO2.RO.get :
  pot qH qS CountH.c CountS.c DS2.RO1.RO.m MLDSA_RO_DS1.pkv
  ==> pot qH qS CountH.c CountS.c DS2.RO1.RO.m MLDSA_RO_DS1.pkv.
proof. by proc; auto => &hr /=; rewrite EpC W8.dword_ll. qed.

lemma Squeeze_RO1_ll : islossless Squeeze(DS2.RO1.RO).squeeze.
proof.
have hget : islossless DS2.RO1.RO.get.
+ by proc; auto => />; rewrite /dblock; smt(dlist_ll W8.dword_ll).
proc; while true (len - 64 * j).
+ by move=> z; wp; call hget; auto => /#.
by auto => /#.
qed.

module CountA(A : DS2.Adversary)(H1 : DS2.POracle1, H2 : DS2.POracle2, O : DS2.SOracle) = {
  proc forge(pk : BytesPK.t) : W8.t list * BytesSig.t = {
    var r;
    CountH.c <- 0;
    CountS.c <- 0;
    r <@ A(CountH(H1), H2, CountS(O)).forge(pk);
    return r;
  }
}.

section.

declare module A <: DS2.Adversary {
  -DS2.RO1.RO, -DS2.RO2.RO, -DS2.EUF_CMA, -XOFA_O, -XOFS_O, -MLDSA_RO_DS1, -CountH, -CountS }.

local equiv verify_rel :
  MLDSA_RO_DS(DS2.RO1.RO, DS2.RO2.RO).verify ~ MLDSA_RO_DS1(DS2.RO1.RO, DS2.RO2.RO).verify :
  ={pk, m, glob DS2.RO1.RO, glob DS2.RO2.RO, glob XOFA_O} /\ s{1} = sigma{2} ==>
  res{1} => res{2} \/ MLDSA_RO_DS1.bad{2}.
proof.
proc.
wp; call{2} Squeeze_RO1_ll; wp.
call (: ={glob DS2.RO1.RO, glob DS2.RO2.RO, glob XOFA_O}); 1: by sim.
by auto => /> /#.
qed.

lemma hop1_uptobad &m :
  Pr[DS2.EUF_CMA(DS2.RO1.RO, DS2.RO2.RO, MLDSA_RO_DS, A).main() @ &m : res] <=
  Pr[DS2.EUF_CMA(DS2.RO1.RO, DS2.RO2.RO, MLDSA_RO_DS1, A).main() @ &m : res] +
  Pr[DS2.EUF_CMA(DS2.RO1.RO, DS2.RO2.RO, MLDSA_RO_DS1, A).main() @ &m : MLDSA_RO_DS1.bad].
proof.
have h1 : Pr[DS2.EUF_CMA(DS2.RO1.RO, DS2.RO2.RO, MLDSA_RO_DS, A).main() @ &m : res] <=
          Pr[DS2.EUF_CMA(DS2.RO1.RO, DS2.RO2.RO, MLDSA_RO_DS1, A).main() @ &m :
             res \/ MLDSA_RO_DS1.bad].
+ byequiv (: ={glob A, glob XOFA_O, glob XOFS_O} ==>
             res{1} => res{2} \/ MLDSA_RO_DS1.bad{2}) => //.
  proc.
  seq 5 5 : (={pk, m, s, glob DS2.RO1.RO, glob DS2.RO2.RO, glob XOFA_O, DS2.EUF_CMA.qs}).
  + call (: ={glob DS2.RO1.RO, glob DS2.RO2.RO, glob XOFA_O, glob XOFS_O,
              DS2.EUF_CMA.sk, DS2.EUF_CMA.qs}).
    + by sim.
    + by sim.
    + by proc; inline *; sim.
    inline{2} 4; wp.
    call (: ={glob DS2.RO1.RO, glob DS2.RO2.RO, glob XOFA_O, glob XOFS_O}); 1: by sim.
    by inline *; auto.
  by wp; call verify_rel; auto => /> /#.
have h2 : Pr[DS2.EUF_CMA(DS2.RO1.RO, DS2.RO2.RO, MLDSA_RO_DS1, A).main() @ &m :
             res \/ MLDSA_RO_DS1.bad] <=
          Pr[DS2.EUF_CMA(DS2.RO1.RO, DS2.RO2.RO, MLDSA_RO_DS1, A).main() @ &m : res] +
          Pr[DS2.EUF_CMA(DS2.RO1.RO, DS2.RO2.RO, MLDSA_RO_DS1, A).main() @ &m : MLDSA_RO_DS1.bad].
+ by rewrite Pr[mu_or]; smt(mu_bounded).
smt().
qed.

local ehoare CountS_sign (qH qS : int) :
  CountS(DS2.EUF_CMA(DS2.RO1.RO, DS2.RO2.RO, MLDSA_RO_DS1, CountA(A)).O).sign :
  pot qH qS CountH.c CountS.c DS2.RO1.RO.m MLDSA_RO_DS1.pkv
  ==> pot qH qS CountH.c CountS.c DS2.RO1.RO.m MLDSA_RO_DS1.pkv.
proof.
proc; inline DS2.EUF_CMA(DS2.RO1.RO, DS2.RO2.RO, MLDSA_RO_DS1, CountA(A)).O.sign
             MLDSA_RO_DS1(DS2.RO1.RO, DS2.RO2.RO).sign; wp.
exlim MLDSA_RO_DS1.pkv, CountH.c, CountS.c => pk0 ch cs.
call /(fun y => (MLDSA_RO_DS1.pkv = pk0 /\ CountH.c = ch /\ CountS.c = cs + 1) `|`
                (if ch <= qH /\ cs + 1 <= qS then y else 0%xr))
     (sign_coll pk0 ((qH - ch)%r * p512 +
                     (qS - (cs + 1))%r * ((1 + kappa_max)%r * p512) + 2%r * p512)).
+ move=> &hr; apply xle_cxr_r => [#] hpk hch hcs; rewrite /pot hpk hch hcs.
  case: (ch <= qH /\ cs + 1 <= qS) => hok //=.
  by apply xle_cxr => /> *; apply le_pos; smt(kappa_max_bnd).
auto => &hr /=; apply xle_cxr_r => [#] ->> ->> ->>; rewrite EpC drnd_ll /pot smul1m /=.
case: (CountH.c{hr} <= qH /\ CountS.c{hr} + 1 <= qS) => hok /=; last by apply xle0x.
have -> /= : CountH.c{hr} <= qH /\ CountS.c{hr} <= qS by smt().
apply xle_cxr => /> hinv _; have hp : 0%r <= p512 by smt(RealOrder.expr_ge0).
by split; [smt(RealOrder.mulr_ge0 kappa_max_bnd) | apply le_pos; smt(kappa_max_bnd)].
qed.

local lemma bad_ok (qH qS : int) &m : 0 <= qH => 0 <= qS =>
  Pr[DS2.EUF_CMA(DS2.RO1.RO, DS2.RO2.RO, MLDSA_RO_DS1, CountA(A)).main() @ &m :
     MLDSA_RO_DS1.bad /\ CountH.c <= qH /\ CountS.c <= qS] <=
  qH%r * p512 + qS%r * ((1 + kappa_max)%r * p512) + 2%r * p512.
proof.
move=> hqH hqS; byehoare => //; last first.
+ have hp : 0%r <= p512 by smt(RealOrder.expr_ge0).
  by smt(RealOrder.mulr_ge0 kappa_max_bnd).
proc; inline MLDSA_RO_DS1(DS2.RO1.RO, DS2.RO2.RO).keygen.
seq 6 : ((pk = MLDSA_RO_DS1.pkv /\ inv_m DS2.RO1.RO.m MLDSA_RO_DS1.pkv /\
          norel DS2.RO1.RO.m) `|`
         (qH%r * p512 + qS%r * ((1 + kappa_max)%r * p512) + 2%r * p512)%xr).
+ wp; call /(fun y => y)
           (keygen_norel (qH%r * p512 + qS%r * ((1 + kappa_max)%r * p512) +
                          2%r * p512)%xr).
  by inline *; auto.
seq 1 : ((pk = MLDSA_RO_DS1.pkv) `|`
         pot qH qS CountH.c CountS.c DS2.RO1.RO.m MLDSA_RO_DS1.pkv).
+ inline DS2.EUF_CMA(DS2.RO1.RO, DS2.RO2.RO, MLDSA_RO_DS1, CountA(A)).A.forge; wp.
  call /(fun y => (pk = MLDSA_RO_DS1.pkv) `|` y)
       (: pot qH qS CountH.c CountS.c DS2.RO1.RO.m MLDSA_RO_DS1.pkv
          ==> pot qH qS CountH.c CountS.c DS2.RO1.RO.m MLDSA_RO_DS1.pkv).
  + proc (pot qH qS CountH.c CountS.c DS2.RO1.RO.m MLDSA_RO_DS1.pkv).
    + by move=> &hr.
    + by move=> &hr.
    + by apply (CountS_sign qH qS).
    + by apply (RO2_get_pot qH qS).
    by apply (CountH_get qH qS).
  auto => &hr /=; apply xle_cxr_r => [#] hpk hinv hn; rewrite /pot hqH hqS /=.
  have -> /= : !coll DS2.RO1.RO.m{hr} MLDSA_RO_DS1.pkv{hr}.
  + by apply/negP => -[x [hx [hxm _]]]; move: (hn x hxm); rewrite hx.
  by rewrite hpk hinv.
exlim MLDSA_RO_DS1.pkv, CountH.c, CountS.c => pk0 ch cs.
call /(fun y => (MLDSA_RO_DS1.pkv = pk0 /\ CountH.c = ch /\ CountS.c = cs) `|`
                (if ch <= qH /\ cs <= qS then y else 0%xr))
     (verify_bad pk0).
+ by move=> &hr; apply xle_cxr_r => [#] _ -> ->; case: (ch <= qH /\ cs <= qS) => hok /=.
skip => &hr /=; apply xle_cxr_r => [#] ->> ->> ->> hpk; rewrite /pot /=.
case: (CountH.c{hr} <= qH /\ CountS.c{hr} <= qS) => hok //=.
apply xle_cxr => /> hinv _; have hp : 0%r <= p512 by smt(RealOrder.expr_ge0).
by apply le_pos; smt(RealOrder.mulr_ge0 kappa_max_bnd).
qed.

local lemma count_ok (qH qS : int) &m :
  (forall (H <: DS2.POracle1 {-A, -CountH, -CountS}) (G <: DS2.POracle2 {-A, -CountH, -CountS})
          (O <: DS2.SOracle {-A, -CountH, -CountS}),
     hoare [A(CountH(H), G, CountS(O)).forge :
              CountH.c = 0 /\ CountS.c = 0 ==> CountH.c <= qH /\ CountS.c <= qS]) =>
  Pr[DS2.EUF_CMA(DS2.RO1.RO, DS2.RO2.RO, MLDSA_RO_DS1, CountA(A)).main() @ &m :
     !(CountH.c <= qH /\ CountS.c <= qS)] = 0%r.
proof.
move=> A_count; byphoare => //; hoare; proc.
inline DS2.EUF_CMA(DS2.RO1.RO, DS2.RO2.RO, MLDSA_RO_DS1, CountA(A)).A.forge.
call (: true); 1: by conseq />.
wp; call (A_count (<: DS2.RO1.RO) (<: DS2.RO2.RO)
                  (<: DS2.EUF_CMA(DS2.RO1.RO, DS2.RO2.RO, MLDSA_RO_DS1, CountA(A)).O)).
by wp; call (: true); 1: by conseq />.
qed.

local lemma bad_count &m :
  Pr[DS2.EUF_CMA(DS2.RO1.RO, DS2.RO2.RO, MLDSA_RO_DS1, A).main() @ &m : MLDSA_RO_DS1.bad] =
  Pr[DS2.EUF_CMA(DS2.RO1.RO, DS2.RO2.RO, MLDSA_RO_DS1, CountA(A)).main() @ &m :
     MLDSA_RO_DS1.bad].
proof.
byequiv (_ : ={glob A, glob MLDSA_RO_DS1} ==> ={MLDSA_RO_DS1.bad}) => //; proc.
inline{2} DS2.EUF_CMA(DS2.RO1.RO, DS2.RO2.RO, MLDSA_RO_DS1, CountA(A)).A.forge.
call (: ={glob DS2.RO1.RO, glob DS2.RO2.RO, glob XOFA_O, glob MLDSA_RO_DS1}); 1: by sim.
wp; call (: ={glob DS2.RO1.RO, glob DS2.RO2.RO, glob XOFA_O, glob XOFS_O, glob MLDSA_RO_DS1,
              DS2.EUF_CMA.sk, DS2.EUF_CMA.qs}).
+ by proc; inline{2} 2; wp; sim.
+ by sim.
+ by proc*; inline{2} 1; wp; call (: ={glob DS2.RO1.RO}); [by sim | auto].
by wp; call (: ={glob DS2.RO1.RO, glob DS2.RO2.RO, glob MLDSA_RO_DS1}); [sim | inline *; auto].
qed.

(* Hop 1: verification additionally rejects c~ = tr *)
lemma hop1 (qH qS : int) &m : 0 <= qH => 0 <= qS =>
  (forall (H <: DS2.POracle1 {-A, -CountH, -CountS}) (G <: DS2.POracle2 {-A, -CountH, -CountS})
          (O <: DS2.SOracle {-A, -CountH, -CountS}),
     hoare [A(CountH(H), G, CountS(O)).forge :
              CountH.c = 0 /\ CountS.c = 0 ==> CountH.c <= qH /\ CountS.c <= qS]) =>
  Pr[DS2.EUF_CMA(DS2.RO1.RO, DS2.RO2.RO, MLDSA_RO_DS, A).main() @ &m : res] <=
  Pr[DS2.EUF_CMA(DS2.RO1.RO, DS2.RO2.RO, MLDSA_RO_DS1, A).main() @ &m : res] +
  (qH + qS * (1 + kappa_max) + 2)%r * p512.
proof.
move=> hqH hqS A_count.
have h1 := hop1_uptobad &m.
have h2 := bad_count &m.
have h4 := bad_ok qH qS &m hqH hqS.
have h5 := count_ok qH qS &m A_count.
have h3 : Pr[DS2.EUF_CMA(DS2.RO1.RO, DS2.RO2.RO, MLDSA_RO_DS1, CountA(A)).main() @ &m :
             MLDSA_RO_DS1.bad] <=
          Pr[DS2.EUF_CMA(DS2.RO1.RO, DS2.RO2.RO, MLDSA_RO_DS1, CountA(A)).main() @ &m :
             MLDSA_RO_DS1.bad /\ CountH.c <= qH /\ CountS.c <= qS] +
          Pr[DS2.EUF_CMA(DS2.RO1.RO, DS2.RO2.RO, MLDSA_RO_DS1, CountA(A)).main() @ &m :
             !(CountH.c <= qH /\ CountS.c <= qS)].
+ rewrite Pr[mu_split (CountH.c <= qH /\ CountS.c <= qS)]; apply RealOrder.ler_add2l.
  by rewrite Pr[mu_sub].
have -> : (qH + qS * (1 + kappa_max) + 2)%r * p512 =
          qH%r * p512 + qS%r * ((1 + kappa_max)%r * p512) + 2%r * p512.
+ by rewrite !fromintD fromintM; ring.
smt().
qed.

end section.

end MLDSA_ROSep_Hop1.
