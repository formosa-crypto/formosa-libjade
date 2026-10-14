(* -------------------------------------------------------------------- *)
(* The error-vector sampler against the specification's ExpandS        *)
(*                                                                      *)
(* The code-level stream polynomial [Spoly] (first 256 accepted         *)
(* half-byte candidates of the lane's SHAKE256 stream) is the           *)
(* specification's [rejBoundedPoly] of the same 66-byte seed, and the   *)
(* code's termination criterion follows from [rejBounded_ok].           *)
(* -------------------------------------------------------------------- *)
require import AllCore List IntDiv IntMin BitEncoding.

from Jasmin require import JModel_x86.

require import Mldsa65.
from JazzEC require import Mldsa_65_prelude.

from Spec require import GFq Rq Parameters MLDSA_W32_Rep.
from Spec require import Spec65.
import MLDSA65.

from CryptoSpecs require import Keccak1600_Spec.

import PolyLVec PolyKVec.
import Round ZModQ Zq.

require import Array64 Array256 Array1280 Array1536.
require import Rejstream Sha3x4 Shared65. import Sha3x4_65 Shake256x4.
require import Sexpand. import SRS.
require Mask_link.

(* -------------------------------------------------------------------- *)
(* a code candidate is the spec's CoeffFromHalfByte (eta = 4)           *)
lemma halfstep_specE (c : W8.t) :
  to_uint c < 16 =>
  map W32.to_sint (halfstep c) = pmap idfun [CoeffFromHalfByte (to_uint c)].
proof.
move=> hc; rewrite /CoeffFromHalfByte mldsa65_Eta /saccept /=.
case: (to_uint c < 9) => h /=; last by [].
rewrite /scoeff /zeroextu32 (_ : W32.of_int 4 - W32.of_int (to_uint c) = W32.of_int (4 - to_uint c)).
- by rewrite W32.of_intD W32.of_intN.
by rewrite W32.to_sintK_small /=; smt(W8.to_uint_cmp).
qed.

(* one byte, low nibble first, as Alg. 31 reads it                      *)
lemma sreject1_specE (b : W8.t) :
  map W32.to_sint (sreject [b])
  = pmap idfun [CoeffFromHalfByte (to_uint b %% 16); CoeffFromHalfByte (to_uint b %/ 16)].
proof.
have hlo : to_uint (b `&` W8.of_int 15) = to_uint b %% 16.
- by rewrite (W8.to_uint_and_mod 4).
have hhi : to_uint (b `>>>` 4) = to_uint b %/ 16.
- by rewrite W8.to_uint_shr.
have /= hb := W8.to_uint_cmp b.
rewrite sreject1E map_cat !halfstep_specE ?hlo ?hhi.
- smt(modz_cmp).
- smt().
by rewrite -pmap_cat.
qed.

(* the code's accepted stream is the spec's accepted list               *)
lemma sreject_specE (rho : Bytes66.t) (t : int) : 0 <= t =>
  map W32.to_sint (sreject (shake256_slice (Bytes66.to_list rho) 0 t))
  = bounded_accepted rho t.
proof.
elim: t => [|t ge0t ih].
- by rewrite /bounded_accepted /shake256_slice /Xof.slice mkseq0 /= iota0.
rewrite bounded_acceptedS // -ih sreject_slice_block 1,2:// 1:dvd1z map_cat; congr.
have -> : shake256_slice (Bytes66.to_list rho) t 1
          = [nth witness (SHAKE256 (Bytes66.to_list rho) (t + 1)) t].
- by rewrite /shake256_slice /Xof.slice mkseq1 /= /shake256_xof.
by rewrite sreject1_specE /bounded_cands.
qed.

(* -------------------------------------------------------------------- *)
(* termination: the code criterion follows from the spec's              *)
lemma stream_ok_spec (n : W8.t list) : size n = 66 => stream_ok n.
proof.
move=> szn; have [t [ge0t hsz]] := rejBounded_terminates (Bytes66.of_list n).
exists t; split=> //.
have [l ->] := sreject_slice_prefix n t (136 * t) _; 1: smt().
move: hsz; rewrite -sreject_specE // Bytes66.of_listK // size_map size_cat.
smt(size_ge0).
qed.

lemma stream_ok_all (rho_ : W8.t Array64.t) (ds : W16.t) :
  stream_ok (to_list rho_ ++ W2u8.to_list ds).
proof. by apply stream_ok_spec; rewrite size_cat Array64.size_to_list W2u8.size_to_list. qed.

(* -------------------------------------------------------------------- *)
(* the stream polynomial is the spec's RejBoundedPoly                   *)
lemma Spoly_specE (rho_ : W8.t Array64.t) (sep : W16.t) :
  lifts_wpoly (Spoly rho_ sep)
  = rejBoundedPoly (Bytes66.of_list (to_list rho_ ++ W2u8.to_list sep)).
proof.
pose nc := to_list rho_ ++ W2u8.to_list sep.
pose s := Bytes66.of_list nc.
have szn : size nc = 66 by rewrite /nc size_cat Array64.size_to_list W2u8.size_to_list.
have hn : Bytes66.to_list s = nc by rewrite /s Bytes66.of_listK.
pose p := fun t => 256 <= size (bounded_accepted s t).
have [t0 [ge0t0 ht0]] := rejBounded_terminates s.
have hf : p (rejBounded_fuel s) by apply (argminP idfun p t0).
have ge0f : 0 <= rejBounded_fuel s by rewrite /rejBounded_fuel ge0_argmin.
have hsz : 256 <= size (sreject (shake256_slice nc 0 (rejBounded_fuel s))).
- by move: hf; rewrite /p -sreject_specE // hn size_map.
apply Array256.ext_eq => j rgj.
rewrite /lifts_wpoly Array256.mapiE // (SpolyP rho_ sep (rejBounded_fuel s) j) //.
rewrite /rejBoundedPoly Array256.initiE // -sreject_specE // hn.
by rewrite /= (nth_map W32.zero) 1:/#.
qed.

(* its coefficients lie in [-eta, eta]                                  *)
lemma to_sint_scoeff (c : W8.t) : saccept c => to_sint (scoeff c) = 4 - to_uint c.
proof.
rewrite /saccept => h.
rewrite /scoeff /zeroextu32 (_ : W32.of_int 4 - W32.of_int (to_uint c) = W32.of_int (4 - to_uint c)).
- by rewrite W32.of_intD W32.of_intN.
by rewrite W32.to_sintK_small /=; smt(W8.to_uint_cmp).
qed.

lemma Spoly_srng (rho_ : W8.t Array64.t) (sep : W16.t) : wpoly_srng Eta Eta (Spoly rho_ sep).
proof.
pose nc := to_list rho_ ++ W2u8.to_list sep.
have szn : size nc = 66 by rewrite /nc size_cat Array64.size_to_list W2u8.size_to_list.
have [k [ge0k hk]] := stream_ok_spec nc szn.
rewrite /wpoly_srng Array256.allP mldsa65_Eta => i rgi /=.
rewrite (SpolyP rho_ sep (136 * k) i) 1:/# // -/nc.
have : nth W32.zero (sreject (shake256_slice nc 0 (136 * k))) i
       \in sreject (shake256_slice nc 0 (136 * k)) by apply mem_nth => /#.
move: (nth W32.zero _ i) => w.
rewrite srejectE => /mapP [c [/mem_filter [hc _] ->]].
by rewrite to_sint_scoeff //; move: hc; rewrite /saccept; smt(W8.to_uint_cmp).
qed.

(* -------------------------------------------------------------------- *)
(* the vectors                                                          *)
lemma lvec_entryE (s : W32.t Array1280.t) (i : int) : 0 <= i < 5 =>
  (lvec_unflatten256 s).[i] = poly_of_s1 s i.
proof.
move=> rgi; rewrite /lvec_unflatten256 LArray.initiE; 1: by rewrite mldsa65_lvec.
apply Array256.ext_eq => j rgj.
by rewrite /= Array256.get_of_list // nth_sub 1:/# /PW_1280_256.winof Array256.initiE.
qed.

lemma kvec_entryE (s : W32.t Array1536.t) (i : int) : 0 <= i < 6 =>
  (kvec_unflatten256 s).[i] = poly_of_s2 s i.
proof.
move=> rgi; rewrite /kvec_unflatten256 KArray.initiE; 1: by rewrite mldsa65_kvec.
apply Array256.ext_eq => j rgj.
by rewrite /= Array256.get_of_list // nth_sub 1:/# /PW_1536_256.winof Array256.initiE.
qed.

lemma error_vectors_specE (rho_ : W8.t Array64.t)
  (s1 : W32.t Array1280.t) (s2 : W32.t Array1536.t) :
  (forall r, 0 <= r < 5 => poly_of_s1 s1 r = Spoly rho_ (W16.of_int r)) =>
  (forall r, 0 <= r < 6 => poly_of_s2 s2 r = Spoly rho_ (W16.of_int (5 + r))) =>
     lifts_wpolylvec (lvec_unflatten256 s1) = (expandS (Bytes64.of_list (to_list rho_))).`1
  /\ wpolylvec_srng (lvec_unflatten256 s1) Eta Eta
  /\ lifts_wpolykvec (kvec_unflatten256 s2) = (expandS (Bytes64.of_list (to_list rho_))).`2
  /\ wpolykvec_srng (kvec_unflatten256 s2) Eta Eta.
proof.
move=> h1 h2.
have hrho : Bytes64.to_list (Bytes64.of_list (to_list rho_)) = to_list rho_.
- by rewrite Bytes64.of_listK // Array64.size_to_list.
do! split.
- apply LArray.tP => i; rewrite mldsa65_lvec => rgi.
  rewrite /lifts_wpolylvec LArray.mapiE 1:mldsa65_lvec // /= lvec_entryE // h1 //.
  rewrite /expandS /= LArray.initiE 1:mldsa65_lvec // /= Spoly_specE hrho.
  by rewrite Mask_link.IntegerToBytes2E 1:/#.
- rewrite /wpolylvec_srng LArray.allP mldsa65_lvec => i rgi.
  by rewrite lvec_entryE // h1 // Spoly_srng.
- apply KArray.tP => i; rewrite mldsa65_kvec => rgi.
  rewrite /lifts_wpolykvec KArray.mapiE 1:mldsa65_kvec // /= kvec_entryE // h2 //.
  rewrite /expandS /= KArray.initiE 1:mldsa65_kvec // /= Spoly_specE hrho mldsa65_lvec.
  by rewrite Mask_link.IntegerToBytes2E 1:/# addzC.
rewrite /wpolykvec_srng KArray.allP mldsa65_kvec => i rgi.
by rewrite kvec_entryE // h2 // Spoly_srng.
qed.
