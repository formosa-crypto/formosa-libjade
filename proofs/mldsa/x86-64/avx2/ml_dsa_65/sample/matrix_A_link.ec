(* -------------------------------------------------------------------- *)
(* The matrix-A sampler against the specification's ExpandA            *)
(*                                                                      *)
(* The code-level stream polynomial [Apoly] (first 256 accepted 3-byte  *)
(* candidates of the lane's SHAKE128 stream) is the specification's     *)
(* [rejNTTPoly] of the same 34-byte seed, and the code's termination     *)
(* criterion [stream_ok] follows from the specification's [rejNTT_ok].       *)
(* -------------------------------------------------------------------- *)
require import AllCore List IntDiv IntMin BitEncoding.

from Jasmin require import JModel_x86.

require import Mldsa65.
from JazzEC require import Mldsa_65_prelude.

from Spec require import GFq Rq Parameters MLDSA_W32_Rep.
from Spec require import Spec65.
import MLDSA65.

from CryptoSpecs require import Keccak1600_Spec.

import PolyMat.
import Round ZModQ Zq.

require import Array32 Array256 Array7680.
require import Rejstream Sha3x4 Shared65. import Sha3x4_65 Shake128x4.
require import Aexpand. import ARS.
require Mexpand.

(* -------------------------------------------------------------------- *)
(* a code candidate is the spec's 23-bit little-endian coefficient      *)
lemma to_uint_cand (x y z : W8.t) :
  to_uint (W4u8.pack4 [x; y; z] `&` mask23)
  = to_uint x + 256 * to_uint y + 65536 * (to_uint z %% 128).
proof.
rewrite (W32.to_uint_and_mod 23) //.
have -> : W4u8.pack4 [x; y; z] = W4u8.pack4 [x; y; z; W8.zero].
- apply W32.wordP => i rgi; rewrite !W4u8.pack4wE 1,2:// !W4u8.Pack.get_of_list 1,2:/#.
  by have [->|[->|[->|->]]] : i %/ 8 = 0 \/ i %/ 8 = 1 \/ i %/ 8 = 2 \/ i %/ 8 = 3 by smt().
rewrite Mexpand.to_uint_pack4_3 !BS2Int.bs2int_cat !W8.size_w2bits -!W8.to_uintE.
rewrite size_cat !W8.size_w2bits /=.
have hx := W8.to_uint_cmp x; have hy := W8.to_uint_cmp y; have hz := W8.to_uint_cmp z.
rewrite {1}(divz_eq (to_uint z) 128).
have -> : to_uint x + 256 * to_uint y + 65536 * (to_uint z %/ 128 * 128 + to_uint z %% 128)
        = to_uint z %/ 128 * 2 ^ 23 + (to_uint x + 256 * to_uint y + 65536 * (to_uint z %% 128)).
- by ring.
rewrite modzMDl pmod_small //.
have := modz_cmp (to_uint z) 128 _; 1: done.
move=> hzm; have e : 2 ^ q_bits = 8388608 by rewrite /q_bits /=.
rewrite e; have /= hx' := W8.to_uint_cmp x; have /= hy' := W8.to_uint_cmp y.
smt().
qed.

(* -------------------------------------------------------------------- *)
(* the t-th 3-byte group of the lane stream, as Alg. 30 reads it        *)
lemma slice3E (m : W8.t list) (t : int) : 0 <= t =>
  shake128_slice m (3 * t) 3
  = [nth witness (SHAKE128 m (3 * t + 3)) (3 * t);
     nth witness (SHAKE128 m (3 * t + 3)) (3 * t + 1);
     nth witness (SHAKE128 m (3 * t + 3)) (3 * t + 2)].
proof.
move=> ge0t; apply (eq_from_nth witness); 1: by rewrite size_shake128_slice.
rewrite size_shake128_slice // => i rgi.
rewrite /shake128_slice /Xof.slice nth_mkseq //= /shake128_xof.
rewrite (SHAKE128_ext m (3 * t + i + 1) (3 * t + 3)) 1:/# nth_take 1,2:/#.
by have [->|[->|->]] : i = 0 \/ i = 1 \/ i = 2 by smt().
qed.

(* the CoeffFromThreeBytes of a group, in closed form                  *)
lemma CoeffFromThreeBytesE (x y z : W8.t) :
  CoeffFromThreeBytes x y z
  = if to_uint x + 256 * to_uint y + 65536 * (to_uint z %% 128) < q
    then Some (to_uint x + 256 * to_uint y + 65536 * (to_uint z %% 128)) else None.
proof.
rewrite /CoeffFromThreeBytes /=.
have -> : to_uint (if 127 < to_uint z then z - W8.of_int 128 else z) = to_uint z %% 128.
- have hz := W8.to_uint_cmp z; case: (127 < to_uint z) => hc.
  - rewrite W8.to_uintB 1:W8.uleE 1:/# /=.
    have /= hz' := W8.to_uint_cmp z.
    rewrite -(modzMDr (-1) (to_uint z) 128) pmod_small /#.
  have /= hz' := W8.to_uint_cmp z.
  by rewrite pmod_small /#.
have -> : 65536 * (to_uint z %% 128) + 256 * to_uint y + to_uint x
        = to_uint x + 256 * to_uint y + 65536 * (to_uint z %% 128) by ring.
by [].
qed.

(* a 3-byte group is accepted by the code iff Alg. 30 accepts it        *)
lemma reject3_specE (x y z : W8.t) :
  map W32.to_uint (reject [x; y; z])
  = let c = CoeffFromThreeBytes x y z in if c = None then [] else [oget c].
proof.
rewrite reject3E acceptE CoeffFromThreeBytesE.
case: (to_uint (W4u8.pack4 [x; y; z] `&` mask23) < 8380417) => h.
- rewrite to_uint_cand; rewrite to_uint_cand in h.
  by rewrite /= h.
rewrite to_uint_cand in h.
by rewrite /= h.
qed.

(* the code's accepted stream is the spec's accepted list               *)
lemma reject_specE (rho : Bytes34.t) (t : int) : 0 <= t =>
  map W32.to_uint (reject (shake128_slice (Bytes34.to_list rho) 0 (3 * t)))
  = ntt_accepted rho t.
proof.
elim: t => [|t ge0t ih].
- by rewrite /ntt_accepted /shake128_slice /Xof.slice mkseq0 /= iota0.
rewrite ntt_acceptedS // -ih (_ : 3 * (t + 1) = 3 * t + 3) 1:#ring.
rewrite reject_slice_block 1,2:/# 1:dvdz_mulr // map_cat; congr.
by rewrite slice3E // reject3_specE /ntt_cand.
qed.

(* -------------------------------------------------------------------- *)
(* termination: the code criterion follows from the spec's              *)
lemma stream_ok_spec (n : W8.t list) : size n = 34 => stream_ok n.
proof.
move=> szn; have [t [ge0t hsz]] := rejNTT_terminates (Bytes34.of_list n).
exists t; split=> //.
have [l ->] := reject_slice_prefix n (3 * t) (168 * t) _; 1: smt().
move: hsz; rewrite -reject_specE // Bytes34.of_listK // size_map size_cat.
smt(size_ge0).
qed.

lemma stream_ok_all (rho_ : rho) (ds : W16.t) : stream_ok (to_list rho_ ++ W2u8.to_list ds).
proof. by apply stream_ok_spec; rewrite size_cat Array32.size_to_list W2u8.size_to_list. qed.

(* -------------------------------------------------------------------- *)
(* the stream polynomial is the spec's RejNTTPoly                       *)
lemma Apoly_specE (rho_ : rho) (rc : int * int) :
  liftu_wpoly (Apoly rho_ rc)
  = rejNTTPoly (Bytes34.of_list (to_list rho_ ++ W2u8.to_list (A_ds rc))).
proof.
pose nc := to_list rho_ ++ W2u8.to_list (A_ds rc).
pose s := Bytes34.of_list nc.
have szn : size nc = 34 by rewrite /nc size_cat size_to_list.
have hn : Bytes34.to_list s = nc by rewrite /s Bytes34.of_listK.
pose p := fun t => 256 <= size (ntt_accepted s t).
have [t0 [ge0t0 ht0]] := rejNTT_terminates s.
have hf : p (rejNTT_fuel s) by apply (argminP idfun p t0).
have ge0f : 0 <= rejNTT_fuel s by rewrite /rejNTT_fuel ge0_argmin.
have hsz : 256 <= size (reject (shake128_slice nc 0 (3 * rejNTT_fuel s))).
- by move: hf; rewrite /p -reject_specE // hn size_map.
apply Array256.ext_eq => j rgj.
rewrite /liftu_wpoly Array256.mapiE // (ApolyP rho_ rc (3 * rejNTT_fuel s) j) 1:/# //.
rewrite /rejNTTPoly Array256.initiE // -reject_specE // hn.
by rewrite /= (nth_map W32.zero) 1:/#.
qed.

(* its coefficients are canonical                                       *)
lemma Apoly_urng (rho_ : rho) (rc : int * int) : wpoly_urng q (Apoly rho_ rc).
proof.
pose nc := to_list rho_ ++ W2u8.to_list (A_ds rc).
have szn : size nc = 34 by rewrite /nc size_cat size_to_list.
have [k [ge0k hk]] := stream_ok_spec nc szn.
rewrite /wpoly_urng Array256.allP => i rgi /=.
rewrite (ApolyP rho_ rc (168 * k) i) 1:/# // -/nc.
have : nth W32.zero (reject (shake128_slice nc 0 (168 * k))) i
       \in reject (shake128_slice nc 0 (168 * k)) by apply mem_nth => /#.
move: (nth W32.zero _ i) => w.
rewrite Aexpand.rejectE => /mem_filter [+ _].
by rewrite acceptE => h; smt(W32.to_uint_cmp).
qed.

(* -------------------------------------------------------------------- *)
(* the matrix                                                           *)
lemma A_ds_listE (rc : int * int) :
  W2u8.to_list (A_ds rc) = [W8.of_int rc.`2; W8.of_int rc.`1].
proof.
apply (eq_from_nth W8.zero); 1: by rewrite W2u8.size_to_list.
rewrite W2u8.size_to_list => i rgi; rewrite W2u8.nth_to_list /A_ds W2u8.pack2bE 1://.
by have [->|->] : i = 0 \/ i = 1 by smt().
qed.

lemma mat_entryE (a : A) (i : int) : 0 <= i < 30 =>
  (mat_unflatten256 a).[i] = poly_of_A a (A_rc_of_index i).
proof.
move=> rgi; rewrite /mat_unflatten256 KLMatrix.initiE.
- by rewrite mldsa65_kvec mldsa65_lvec.
rewrite /poly_of_A /poly_index_in_A /A_rc_of_index /=.
rewrite (_ : (5 * (i %/ 5) + i %% 5) * 256 = 256 * i) 1:/#.
apply Array256.ext_eq => j rgj; rewrite !Array256.get_of_list //.
by rewrite !(nth_change_dfl witness W32.zero) // size_sub /#.
qed.

lemma A_valid_specE (rho_ : rho) (a : A) : A_valid_up_to rho_ a 30 =>
     liftu_wpolymat (mat_unflatten256 a) = expandA (Bytes32.of_list (to_list rho_))
  /\ wpolymat_urng (mat_unflatten256 a) q.
proof.
move=> hv; have hsz : kvec * lvec = 30 by rewrite mldsa65_kvec mldsa65_lvec.
have hent : forall i, 0 <= i < 30 =>
  (mat_unflatten256 a).[i] = Apoly rho_ (A_rc_of_index i).
- by move=> i rgi; rewrite mat_entryE // hv.
split.
- apply KLMatrix.tP => i; rewrite hsz => rgi.
  rewrite /liftu_wpolymat KLMatrix.mapiE 1:/# /= hent //.
  rewrite /expandA KLMatrix.initiE 1:/# /= Apoly_specE A_ds_listE.
  rewrite Bytes32.of_listK; first by rewrite Array32.size_to_list.
  by rewrite mldsa65_lvec /A_rc_of_index.
rewrite /wpolymat_urng KLMatrix.allP => i; rewrite hsz => rgi.
by rewrite hent // Apoly_urng.
qed.
