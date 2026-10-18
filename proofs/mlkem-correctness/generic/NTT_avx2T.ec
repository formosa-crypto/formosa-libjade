(* -------------------------------------------------------------------- *)
(* The NTT of a vector, at abstract parameters: the packed layout of a  *)
(* vector and of a matrix, polynomial by polynomial, and the vector     *)
(* NTT and inverse NTT against the specification.                       *)
(* -------------------------------------------------------------------- *)
require import AllCore List Int IntDiv CoreMap Real Number.
from Jasmin require import JModel.
from JazzEC require import Array256.
from Spec require import GFq Rq Serialization Correctness.
require import W16extra MLKEMFCLib.
require import JkemConstants.
require BaseT PreludeT.
require MLKEM_ntt_levelsT MLKEM_ntt_avx2T MLKEM_invntt_levelsT MLKEM_invntt_avx2T.
require MLKEM_basemul_avx2T NTT_avx2_polyT.

abstract theory NTT_avx2T.

clone import BaseT.BaseT as B.
import S R.
clone import PreludeT.PreludeT as PR with theory B <- B.
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

import Zq PolyVec PolyMat.
import Array_vecn Array_matn.

(* -------------------------------------------------------------------- *)
(* the packed layout, polynomial by polynomial                          *)
op nttunpackv (v : 'a Array_vecn.t) =
  Array_vecn.init (fun i => (nttunpack (subarray256 v (i %/ 256))).[i %% 256]).

op nttpackv (v : 'a Array_vecn.t) =
  Array_vecn.init (fun i => (nttpack (subarray256 v (i %/ 256))).[i %% 256]).

op nttunpackm (v : 'a Array_matn.t) =
  Array_matn.init (fun i => (nttunpackv (subarrayvecn v (i %/ vecn))).[i %% vecn]).

op nttpackm (v : 'a Array_matn.t) =
  Array_matn.init (fun i => (nttpackv (subarrayvecn v (i %/ vecn))).[i %% vecn]).

lemma subarray256_nttpackv (v : 'a Array_vecn.t) j : 0 <= j < kvec =>
  subarray256 (nttpackv v) j = nttpack (subarray256 v j).
proof.
move=> jb; rewrite /nttpackv subarray256_init //; apply Array256.tP => k kb.
by rewrite Array256.initiE //=; congr; smt().
qed.

lemma subarray256_nttunpackv (v : 'a Array_vecn.t) j : 0 <= j < kvec =>
  subarray256 (nttunpackv v) j = nttunpack (subarray256 v j).
proof.
move=> jb; rewrite /nttunpackv subarray256_init //; apply Array256.tP => k kb.
by rewrite Array256.initiE //=; congr; smt().
qed.

lemma packvK : cancel nttpackv<:'a> nttunpackv.
proof.
move=> v; apply vecn_tP => j jb.
by rewrite subarray256_nttunpackv // subarray256_nttpackv // nttpackK.
qed.

lemma unpackvK : cancel nttunpackv<:'a> nttpackv.
proof.
move=> v; apply vecn_tP => j jb.
by rewrite subarray256_nttpackv // subarray256_nttunpackv // nttunpackK.
qed.

lemma nttpackv_pred (v : 'a Array_vecn.t) P : all P (nttpackv v) <=> all P v.
proof.
rewrite !all_vecn; split=> h j jb; have := h j jb.
+ by rewrite subarray256_nttpackv // nttpack_pred.
by rewrite subarray256_nttpackv // nttpack_pred.
qed.

lemma nttunpackv_pred (v : 'a Array_vecn.t) P : all P (nttunpackv v) <=> all P v.
proof.
rewrite !all_vecn; split=> h j jb; have := h j jb.
+ by rewrite subarray256_nttunpackv // nttunpack_pred.
by rewrite subarray256_nttunpackv // nttunpack_pred.
qed.

lemma nttpackv_lift (v : W16.t Array_vecn.t) :
  nttpackv (lift_arrayvecn v) = lift_arrayvecn (nttpackv v).
proof.
apply vecn_tP => j jb.
by rewrite subarray256_nttpackv // -!lift_subarray256 // subarray256_nttpackv // lift_nttpack.
qed.

lemma nttunpackv_lift (v : W16.t Array_vecn.t) :
  nttunpackv (lift_arrayvecn v) = lift_arrayvecn (nttunpackv v).
proof.
apply vecn_tP => j jb; rewrite subarray256_nttunpackv // -!lift_subarray256 //.
by rewrite subarray256_nttunpackv // lift_nttunpack.
qed.

lemma lift_array_256_vecn_k (r : W16.t Array_vecn.t) k : 0 <= k <= vecn - 256 =>
  lift_array256 (Array256.init (fun (i : int) => r.[k + i])) =
  Array256.init (fun (i : int) => (lift_arrayvecn r).[k + i]).
proof.
move=> kb; apply Array256.tP => i ib.
by rewrite /lift_array256 Array256.mapiE // !Array256.initiE //= Array_vecn.mapiE 1:/#.
qed.

(* -------------------------------------------------------------------- *)
import KMatrix Vector.

lemma polyvec_ntt_avx2_corr _r :
  phoare [M.__polyvec_ntt :
    r = _r /\ signed_boundvecn_cxq r 0 vecn 2 ==>
    nttv (lift_polyvec _r) = lift_polyvec (nttpackv res) /\
    pos_boundvecn_cxq res 0 vecn 2] = 1%r.
proof.
proc; sp.
while (0 <= i <= kvec /\
  (forall j, 0 <= j < i =>
     ntt (lift_array256 (subarray256 _r j)) = lift_array256 (nttpack (subarray256 r j)) /\
     pos_bound256_cxq (subarray256 r j) 0 256 2) /\
  (forall j, i <= j < kvec => subarray256 r j = subarray256 _r j) /\
  signed_boundvecn_cxq _r 0 vecn 2) (kvec - i).
+ move=> z; wp; ecall (poly_ntt_avx2_corr (subarray256 r i)).
  auto=> &hr [#] i0 ik ih eq hb ilt vz; rewrite -/(subarray256 r{hr} i{hr}) /=; split.
  + by rewrite eq 1:/#; move/signed_boundvecnP: hb => /(_ i{hr} _) /#.
  move=> _ r1 [h1 h2]; do split; 1,2,5,6: smt().
  + move=> j jb; rewrite subarray256_set 1,2:/#.
    case: (j = i{hr}) => [->|ne] /=; [by rewrite -eq 1:/# h1 | by apply ih => /#].
  by move=> j jb; rewrite subarray256_set 1,2:/# ifF 1:/# eq /#.
auto=> &hr /> hb; split; 1: smt(gt0_k).
move=> i r0; split; 1: smt().
move=> ige i0 ik ih _; have {i0 ik ige} ?: i = kvec by smt(). subst i.
split.
+ apply KVec.tP => j jb; rewrite /nttv /mapv KVec.mapiE 1:// /= !lift_polyvecE //.
  by rewrite subarray256_nttpackv //; case: (ih j jb).
by apply pos_boundvecnP => j jb; case: (ih j jb).
qed.

abbrev mul1x256v i v = mapv (mul1x256 i) v.

lemma polyvec_invntt_avx2_corr _r :
  phoare [M.__polyvec_invntt :
    nttpackv (lift_arrayvecn r) = lift_arrayvecn _r /\ signed_boundvecn_cxq r 0 vecn 4 ==>
    mul1x256v (incoeff W16.modulus) (invnttv (lift_polyvec _r)) = lift_polyvec res /\
    signed_boundvecn_cxq res 0 vecn 1] = 1%r.
proof.
proc; sp; exists* r; elim* => r0.
while (0 <= i <= kvec /\
  (forall j, 0 <= j < i =>
     mul1x256 (incoeff W16.modulus) (invntt (lift_array256 (subarray256 _r j))) =
       lift_array256 (subarray256 r j) /\
     signed_bound_cxq (subarray256 r j) 0 256 1) /\
  (forall j, i <= j < kvec => subarray256 r j = subarray256 r0 j) /\
  nttpackv (lift_arrayvecn r0) = lift_arrayvecn _r /\
  signed_boundvecn_cxq r0 0 vecn 4) (kvec - i).
+ move=> z; wp; ecall (poly_invntt_avx2_corr (subarray256 _r i)).
  auto=> &hr [#] i0 ik ih eq hp hb ilt vz; rewrite -/(subarray256 r{hr} i{hr}) /=; split.
  + rewrite eq 1:/#; split; last first.
    + by move/signed_boundvecnP: hb => /(_ i{hr} _) /#.
    rewrite lift_nttpack lift_subarray256 1:/# -subarray256_nttpackv 1:/# hp.
    by rewrite lift_subarray256 /#.
  move=> _ r1 [h1 h2]; do split; 1,2,5,6,7: smt().
  + move=> j jb; rewrite subarray256_set 1,2:/#.
    case: (j = i{hr}) => [->|ne] /=; [by rewrite h1 | by apply ih => /#].
  by move=> j jb; rewrite subarray256_set 1,2:/# ifF 1:/# eq /#.
auto=> &hr /> hp hb; split; 1: smt(gt0_k).
move=> i r1; split; 1: smt().
move=> ige i0 ik ih _; have {i0 ik ige} ?: i = kvec by smt(). subst i.
split.
+ apply KVec.tP => j jb; rewrite /invnttv /mapv !KVec.mapiE 1,2:// /= !lift_polyvecE //.
  by case: (ih j jb).
by apply signed_boundvecnP => j jb; case: (ih j jb).
qed.

end NTT_avx2T.
