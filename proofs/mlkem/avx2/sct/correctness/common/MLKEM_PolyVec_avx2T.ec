(* -------------------------------------------------------------------- *)
(* The polynomial and vector additions and reductions of the model, at  *)
(* abstract parameters: the polynomial ones from their proofs on the    *)
(* prevec modules, the vector ones polynomial by polynomial.            *)
(* -------------------------------------------------------------------- *)
require import AllCore List Int IntDiv CoreMap Real Number.
from Jasmin require import JModel_x86.
from JazzEC require import Array256.
from Spec require import GFq Rq Serialization Correctness.
require import W16extra MLKEMFCLib.
require import JkemConstants.
require BaseT PreludeT Fq_avx2T MLKEM_ntt_levelsT MLKEM_ntt_avx2T MLKEM_invntt_levelsT.
require MLKEM_invntt_avx2T MLKEM_basemul_avx2T NTT_avx2_polyT MLKEM_Poly_avx2T.

abstract theory MLKEM_PolyVec_avx2T.

clone import BaseT.BaseT as B.
import S R.
clone import PreludeT.PreludeT as PR with theory B <- B.
clone import Fq_avx2T.Fq_avx2T as Fq_avx2 with theory B <- B.
clone import MLKEM_ntt_levelsT.MLKEM_ntt_levelsT as MLKEM_ntt_levels with theory B <- B.
clone import MLKEM_ntt_avx2T.MLKEM_ntt_avx2T as MLKEM_ntt_avx2 with
  theory B <- B, theory MLKEM_ntt_levels <- MLKEM_ntt_levels.
clone import MLKEM_invntt_levelsT.MLKEM_invntt_levelsT as MLKEM_invntt_levels with
  theory B <- B, theory MLKEM_ntt_levels <- MLKEM_ntt_levels.
clone import MLKEM_invntt_avx2T.MLKEM_invntt_avx2T as MLKEM_invntt_avx2 with
  theory B <- B, theory MLKEM_ntt_levels <- MLKEM_ntt_levels,
  theory MLKEM_ntt_avx2 <- MLKEM_ntt_avx2, theory MLKEM_invntt_levels <- MLKEM_invntt_levels.
clone import MLKEM_basemul_avx2T.MLKEM_basemul_avx2T as MLKEM_basemul_avx2 with
  theory B <- B, theory MLKEM_ntt_levels <- MLKEM_ntt_levels,
  theory MLKEM_ntt_avx2 <- MLKEM_ntt_avx2.
clone import NTT_avx2_polyT.NTT_avx2_polyT as NTT_avx2_poly with
  theory B <- B, theory MLKEM_ntt_levels <- MLKEM_ntt_levels,
  theory MLKEM_ntt_avx2 <- MLKEM_ntt_avx2, theory MLKEM_invntt_levels <- MLKEM_invntt_levels,
  theory MLKEM_invntt_avx2 <- MLKEM_invntt_avx2, theory MLKEM_basemul_avx2 <- MLKEM_basemul_avx2.
clone import MLKEM_Poly_avx2T.MLKEM_Poly_avx2T as MLKEM_Poly_avx2 with
  theory B <- B, theory Fq_avx2 <- Fq_avx2, theory MLKEM_ntt_levels <- MLKEM_ntt_levels,
  theory MLKEM_ntt_avx2 <- MLKEM_ntt_avx2, theory MLKEM_invntt_levels <- MLKEM_invntt_levels,
  theory MLKEM_invntt_avx2 <- MLKEM_invntt_avx2, theory MLKEM_basemul_avx2 <- MLKEM_basemul_avx2,
  theory NTT_avx2_poly <- NTT_avx2_poly.

import Zq.
import Array_vecn.
import MLKEM_PolyAVX MLKEM_PolyAVXVec.

(* -------------------------------------------------------------------- *)
lemma poly_add_corr_avx ab bb :
  0 <= ab <= 6 => 0 <= bb <= 3 =>
  forall _a _b,
  phoare [M._poly_add2 :
    _a = lift_array256 rp /\ _b = lift_array256 bp /\
    signed_bound_cxq rp 0 256 ab /\ signed_bound_cxq bp 0 256 bb
    ==>
    signed_bound_cxq res 0 256 (ab + bb) /\
    forall k, 0 <= k < 256 =>
      incoeff (to_sint res.[k]) = _a.[k] + _b.[k]] = 1%r.
proof.
  move => abbnd bbbnd _a _b.
  bypr => &m Hpre.
  have ->: 1%r = Pr[Mprevec.poly_add2(rp{m}, bp{m}) @ &m :
                signed_bound_cxq res 0 256 (ab + bb) /\
                forall k, 0 <= k < 256 => incoeff (to_sint res.[k]) = _a.[k] + _b.[k]].
  + by byphoare (MLKEM_PolyAVX.poly_add_corr _a _b ab bb abbnd bbbnd) => //=; smt().
  byequiv => //. symmetry. proc*. call prevec_eq_poly_add2. auto.
qed.

lemma poly_sub_corr_avx ab bb :
  0 <= ab <= 4 => 0 <= bb <= 4 =>
  forall _a _b,
  phoare [M._poly_sub :
    _a = lift_array256 ap /\ _b = lift_array256 bp /\
    signed_bound_cxq ap 0 256 ab /\ signed_bound_cxq bp 0 256 bb
    ==>
    signed_bound_cxq res 0 256 (ab + bb) /\
    forall k, 0 <= k < 256 =>
      incoeff (to_sint res.[k]) = _a.[k] - _b.[k]] = 1%r.
proof.
  move => abbnd bbbnd _a _b.
  bypr => &m Hpre.
  have ->: 1%r = Pr[Mprevec.poly_sub(rp{m}, ap{m}, bp{m}) @ &m :
                signed_bound_cxq res 0 256 (ab + bb) /\
                forall k, 0 <= k < 256 => incoeff (to_sint res.[k]) = _a.[k] - _b.[k]].
  + by byphoare (MLKEM_PolyAVX.poly_sub_corr _a _b ab bb abbnd bbbnd) => //=; smt().
  byequiv => //. symmetry. proc*. call prevec_eq_poly_sub. auto.
qed.

lemma poly_reduce_corr_avx ap :
  phoare [M.__poly_reduce :
    ap = lift_array256 rp
    ==>
    ap = lift_array256 res /\
    forall k, 0 <= k < 256 => bpos16 res.[k] (2*q)] = 1%r.
proof.
  bypr => &m Hpre.
  have ->: 1%r = Pr[Mprevec.poly_reduce(rp{m}) @ &m :
                ap = lift_array256 res /\
                forall k, 0 <= k < 256 => bpos16 res.[k] (2*q)].
  + by byphoare (MLKEM_PolyAVX.poly_reduce_corr ap) => //=; smt().
  byequiv => //. symmetry. proc*. call prevec_eq_poly_reduce. auto.
qed.

lemma poly_frommont_corr_avx ap :
  phoare [M._poly_frommont :
    ap = map W16.to_sint rp
    ==>
    map W16.to_sint res =
      map (fun x => SignedReductions_W16.SREDC (x * ((Ring.IntID.(^) SignedReductions_W16.R 2) %%
        q))) ap] = 1%r.
proof.
  bypr => &m Hpre.
  have ->: 1%r = Pr[Mprevec.poly_frommont(rp{m}) @ &m :
                map W16.to_sint res =
                  map (fun x => SignedReductions_W16.SREDC (x * ((Ring.IntID.(^)
                    SignedReductions_W16.R 2) %% q))) ap].
  + by byphoare (MLKEM_PolyAVX.poly_frommont_corr ap) => //=; smt().
  byequiv => //. symmetry. proc*. call prevec_eq_poly_frommont. auto.
qed.

(* -------------------------------------------------------------------- *)
lemma polyvec_add_corr_avx ab bb :
  0 <= ab <= 6 => 0 <= bb <= 3 =>
  forall _a _b,
  phoare [M.__polyvec_add2 :
    _a = lift_arrayvecn r /\ _b = lift_arrayvecn b /\
    signed_boundvecn_cxq r 0 vecn ab /\ signed_boundvecn_cxq b 0 vecn bb
    ==>
    signed_boundvecn_cxq res 0 vecn (ab + bb) /\
    forall k, 0 <= k < vecn =>
      incoeff (to_sint res.[k]) = _a.[k] + _b.[k]] = 1%r.
proof.
move=> abb bbb _a _b; proc; sp; exists* r; elim* => r0.
while (0 <= i <= kvec /\
  (forall j, 0 <= j < i =>
     signed_bound_cxq (subarray256 r j) 0 256 (ab + bb) /\
     forall k, 0 <= k < 256 =>
       incoeff (to_sint (subarray256 r j).[k]) =
       (subarray256 _a j).[k] + (subarray256 _b j).[k]) /\
  (forall j, i <= j < kvec => subarray256 r j = subarray256 r0 j) /\
  _a = lift_arrayvecn r0 /\ _b = lift_arrayvecn b /\
  signed_boundvecn_cxq r0 0 vecn ab /\ signed_boundvecn_cxq b 0 vecn bb) (kvec - i).
+ move=> z; wp; ecall (poly_add_corr_avx ab bb abb bbb
    (subarray256 _a i) (subarray256 _b i)).
  auto=> &hr [#] i0 ik ih eq ha hb' hr hb ilt vz.
  rewrite -/(subarray256 r{hr} i{hr}) -/(subarray256 b{hr} i{hr}) /=; split.
  + rewrite eq 1:/# ha hb' !lift_subarray256 1,2:/#.
    by move/signed_boundvecnP: hr => /(_ i{hr} _); move/signed_boundvecnP: hb => /(_ i{hr} _) /#.
  move=> _ r1 [h1 h2]; do split; 1,2,5..9: smt().
  + move=> j jb; rewrite subarray256_set 1,2:/#.
    case: (j = i{hr}) => [->|ne] /=; [by rewrite h1 | by apply ih => /#].
  by move=> j jb; rewrite subarray256_set 1,2:/# ifF 1:/# eq /#.
auto=> &hr /> hr hb; split; 1: smt(gt0_k).
move=> i r1; split; 1: smt().
move=> ige i0 ik ih _; have {i0 ik ige} ?: i = kvec by smt(). subst i.
split; 1: by apply/signed_boundvecnP => j jb; case: (ih j jb).
move=> k k0 k1; have kb : 0 <= k < vecn by done.
case: (ih (k %/ 256) (vecn_div k kb)) => _ /(_ (k %% 256) _); 1: smt().
by rewrite !subarray256E 1..3:/# (mulzC 256) -divz_eq.
qed.

lemma polyvec_reduce_corr_avx _a :
  phoare [M.__polyvec_reduce :
    _a = lift_arrayvecn r
    ==>
    _a = lift_arrayvecn res /\
    forall k, 0 <= k < vecn => bpos16 res.[k] (2*q)] = 1%r.
proof.
proc; sp; exists* r; elim* => r0.
while (0 <= i <= kvec /\
  (forall j, 0 <= j < i =>
     subarray256 _a j = lift_array256 (subarray256 r j) /\
     forall k, 0 <= k < 256 => bpos16 (subarray256 r j).[k] (2*q)) /\
  (forall j, i <= j < kvec => subarray256 r j = subarray256 r0 j) /\
  _a = lift_arrayvecn r0) (kvec - i).
+ move=> z; wp; ecall (poly_reduce_corr_avx (subarray256 _a i)).
  auto=> &hr [#] i0 ik ih eq ha ilt vz; rewrite -/(subarray256 r{hr} i{hr}) /=; split.
  + by rewrite eq 1:/# ha lift_subarray256 /#.
  move=> _ r1 [h1 h2]; do split; 1,2,5,6: smt().
  + move=> j jb; rewrite subarray256_set 1,2:/#.
    case: (j = i{hr}) => [->|ne] /=; [by rewrite -h1 | by apply ih => /#].
  by move=> j jb; rewrite subarray256_set 1,2:/# ifF 1:/# eq /#.
auto=> &hr /> ; split; 1: smt(gt0_k).
move=> i r1; split; 1: smt().
move=> ige i0 ik ih _; have {i0 ik ige} ?: i = kvec by smt(). subst i.
split.
+ apply/vecn_tP => j jb; rewrite -lift_subarray256 //.
  by case: (ih j jb) => h _; rewrite lift_subarray256 // h -lift_subarray256.
move=> k k0 k1; have kb : 0 <= k < vecn by done.
case: (ih (k %/ 256) (vecn_div k kb)) => _ /(_ (k %% 256) _); 1: smt().
by rewrite subarray256E 1:/# (mulzC 256) -divz_eq /#.
qed.

end MLKEM_PolyVec_avx2T.
