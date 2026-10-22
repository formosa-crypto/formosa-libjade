require import AllCore List IntDiv BitEncoding JWordList.
from Jasmin require import JWord.
require import Array256 Array320 Array416.
require BaseT JArrayExtra.

(* The views of the implementation's flat arrays as vectors and matrices of
   polynomials or of polynomial encodings, their slice and writeback laws,
   and the encoding of the samplers' domain separators. *)
abstract theory PreludeT.

clone import BaseT.BaseT as B.
import S R MLDSAParams.
import LArray KArray.
import Array_lpolys Array_kpolys Array_klpolys Array_z_enc Array_gamma1_enc.
import Array_s1_enc Array_s2_enc Array_eta_enc Array_w1vec_enc Array_w1_enc.
import Array_t1_enc Array_t0_enc.

(* -------------------------------------------------------------------- *)
(* The views                                                            *)
(* -------------------------------------------------------------------- *)

op lvec_unflatten256 (a : 'a Array_lpolys.t) =
  LArray.init (fun i => Array256.of_list witness (Array_lpolys.sub a (256 * i) 256)).

op kvec_unflatten256 (a : 'a Array_kpolys.t) =
  KArray.init (fun i => Array256.of_list witness (Array_kpolys.sub a (256 * i) 256)).

op mat_unflatten256 (a : 'a Array_klpolys.t) =
  KLMatrix.init (fun i => Array256.of_list witness (Array_klpolys.sub a (256 * i) 256)).

(* the gamma1 encoding of an L-vector, polynomial by polynomial *)
op z_unflatten (a : 'a Array_z_enc.t) =
  LArray.init (fun i =>
    Array_gamma1_enc.of_list witness (Array_z_enc.sub a (gamma1_enc * i) gamma1_enc)).

(* the eta encodings of s1 and s2, polynomial by polynomial *)
op s1_unflatten (a : 'a Array_s1_enc.t) =
  LArray.init (fun i =>
    Array_eta_enc.of_list witness (Array_s1_enc.sub a (eta_enc * i) eta_enc)).

op s2_unflatten (a : 'a Array_s2_enc.t) =
  KArray.init (fun i =>
    Array_eta_enc.of_list witness (Array_s2_enc.sub a (eta_enc * i) eta_enc)).

(* the encoding of w1, polynomial by polynomial *)
op w1_unflatten (a : 'a Array_w1vec_enc.t) =
  KArray.init (fun i =>
    Array_w1_enc.of_list witness (Array_w1vec_enc.sub a (w1_enc * i) w1_enc)).

(* the encodings of t1 and t0, polynomial by polynomial *)
op t1_unflatten (a : 'a Array_t1_enc.t) =
  KArray.init (fun i => Array320.of_list witness (Array_t1_enc.sub a (320 * i) 320)).

op t0_unflatten (a : 'a Array_t0_enc.t) =
  KArray.init (fun i => Array416.of_list witness (Array_t0_enc.sub a (416 * i) 416)).

(* -------------------------------------------------------------------- *)
(* Reading an element through a view                                    *)
(* -------------------------------------------------------------------- *)

lemma blk_idx (k m i : int) : 0 < m => 0 <= i < k * m => 0 <= i %/ m < k /\ 0 <= i %% m < m.
proof.
move=> hm [h0 h1]; split; 2: smt(modz_ge0 ltz_pmod).
split; 1: smt(divz_ge0).
by move=> _; rewrite ltz_divLR // mulzC.
qed.

lemma gt0_gamma1_enc : 0 < gamma1_enc by rewrite /gamma1_enc; smt(param_sets).
lemma gt0_eta_enc : 0 < eta_enc by rewrite /eta_enc; smt(param_sets).
lemma gt0_w1_enc : 0 < w1_enc by rewrite /w1_enc; smt(param_sets).

lemma lvec_unflatten256iE (v : 'a Array_lpolys.t) i :
  0 <= i < lpolys => v.[i] = (lvec_unflatten256 v).[i %/ 256].[i %% 256].
proof.
rewrite /lpolys => hi; rewrite /lvec_unflatten256 LArray.initiE /=; 1: smt().
by rewrite Array256.get_of_list 1:/# /= Array_lpolys.nth_sub /#.
qed.

lemma kvec_unflatten256iE (v : 'a Array_kpolys.t) i :
  0 <= i < kpolys => v.[i] = (kvec_unflatten256 v).[i %/ 256].[i %% 256].
proof.
rewrite /kpolys => hi; rewrite /kvec_unflatten256 KArray.initiE /=; 1: smt().
by rewrite Array256.get_of_list 1:/# /= Array_kpolys.nth_sub /#.
qed.

lemma z_unflatteniE (v : 'a Array_z_enc.t) i :
  0 <= i < z_enc => v.[i] = (z_unflatten v).[i %/ gamma1_enc].[i %% gamma1_enc].
proof.
rewrite /z_enc => hi; have [hq hr] := blk_idx lvec gamma1_enc i gt0_gamma1_enc hi.
rewrite /z_unflatten LArray.initiE //= Array_gamma1_enc.get_of_list // Array_z_enc.nth_sub //.
by rewrite {1}(divz_eq i gamma1_enc); congr; ring.
qed.

lemma s1_unflatteniE (v : 'a Array_s1_enc.t) i :
  0 <= i < s1_enc => v.[i] = (s1_unflatten v).[i %/ eta_enc].[i %% eta_enc].
proof.
rewrite /s1_enc => hi; have [hq hr] := blk_idx lvec eta_enc i gt0_eta_enc hi.
rewrite /s1_unflatten LArray.initiE //= Array_eta_enc.get_of_list // Array_s1_enc.nth_sub //.
by rewrite {1}(divz_eq i eta_enc); congr; ring.
qed.

lemma s2_unflatteniE (v : 'a Array_s2_enc.t) i :
  0 <= i < s2_enc => v.[i] = (s2_unflatten v).[i %/ eta_enc].[i %% eta_enc].
proof.
rewrite /s2_enc => hi; have [hq hr] := blk_idx kvec eta_enc i gt0_eta_enc hi.
rewrite /s2_unflatten KArray.initiE //= Array_eta_enc.get_of_list // Array_s2_enc.nth_sub //.
by rewrite {1}(divz_eq i eta_enc); congr; ring.
qed.

lemma w1_unflatteniE (v : 'a Array_w1vec_enc.t) i :
  0 <= i < w1vec_enc => v.[i] = (w1_unflatten v).[i %/ w1_enc].[i %% w1_enc].
proof.
rewrite /w1vec_enc => hi; have [hq hr] := blk_idx kvec w1_enc i gt0_w1_enc hi.
rewrite /w1_unflatten KArray.initiE //= Array_w1_enc.get_of_list // Array_w1vec_enc.nth_sub //.
by rewrite {1}(divz_eq i w1_enc); congr; ring.
qed.

lemma t1_unflatteniE (v : 'a Array_t1_enc.t) i :
  0 <= i < t1_enc => v.[i] = (t1_unflatten v).[i %/ 320].[i %% 320].
proof.
rewrite /t1_enc => hi; rewrite /t1_unflatten KArray.initiE /=; 1: smt().
by rewrite Array320.get_of_list 1:/# /= Array_t1_enc.nth_sub /#.
qed.

lemma t0_unflatteniE (v : 'a Array_t0_enc.t) i :
  0 <= i < t0_enc => v.[i] = (t0_unflatten v).[i %/ 416].[i %% 416].
proof.
rewrite /t0_enc => hi; rewrite /t0_unflatten KArray.initiE /=; 1: smt().
by rewrite Array416.get_of_list 1:/# /= Array_t0_enc.nth_sub /#.
qed.

(* an element of a view satisfying P pointwise, read in the flat array *)
lemma kvec_unflatten256E i j (h : 'a Array_kpolys.t) (P : 'a -> bool) :
  0 <= i < kvec => 0 <= j < 256 =>
  all (all P) (kvec_unflatten256 h) => P h.[i * 256 + j].
proof.
move=> hi hj; rewrite allP => Hii.
have := Hii i _; 1: smt().
rewrite allP => Hjj; have := Hjj j _; 1: smt().
by rewrite initiE 1:/# /= get_of_list 1:/# /= nth_sub /#.
qed.

lemma kvec_unflatten256P i j (h1 : 'a Array_kpolys.t) (h2 : ('b Array256.t) KArray.t)
                         (F : 'a -> 'b) :
  0 <= i < kvec => 0 <= j < 256 =>
  map (map F) (kvec_unflatten256 h1) = h2 => F h1.[i * 256 + j] = h2.[i].[j].
proof.
move=> hi hj; rewrite tP => Hii; have := Hii i _; 1: smt().
rewrite tP => Hjj; have := Hjj j _; 1: smt().
rewrite mapiE 1:/# /= mapiE 1:/# /= initiE 1:/# initiE 1:/# /=.
by rewrite /= !nth_sub /#.
qed.

(* -------------------------------------------------------------------- *)
(* Slices and writebacks                                                *)
(* -------------------------------------------------------------------- *)

(* the k-th polynomial of a K-vector is the 256-element window at 256 k *)
lemma kvec_slice_eq (v : 'a Array_kpolys.t) (base : int) :
  base %% 256 = 0 => 0 <= base %/ 256 < kvec =>
  (kvec_unflatten256 v).[base %/ 256] = Array256.init (fun i => v.[base + i]).
proof.
move=> Hmod Hk; apply Array256.tP => j jb.
rewrite Array256.initiE 1:/# /= /kvec_unflatten256 KArray.initiE 1:/# /=.
by rewrite get_of_list 1:/# nth_sub 1:/# /#.
qed.

lemma lvec_slice_eq (v : 'a Array_lpolys.t) (base : int) :
  base %% 256 = 0 => 0 <= base %/ 256 < lvec =>
  (lvec_unflatten256 v).[base %/ 256] = Array256.init (fun i => v.[base + i]).
proof.
move=> Hmod Hk; apply Array256.tP => j jb.
rewrite Array256.initiE 1:/# /= /lvec_unflatten256 LArray.initiE 1:/# /=.
by rewrite get_of_list 1:/# nth_sub 1:/# /#.
qed.

(* reading back the window [base, base + 256) of a writeback *)
lemma kvec_writeback_slice_eq (arr : 'a Array_kpolys.t) (f : 'a Array256.t) (base : int) :
  0 <= base => base + 256 <= kpolys =>
  Array256.init (fun i => (Array_kpolys.init (fun i0 =>
    if base <= i0 < base + 256 then f.[i0 - base] else arr.[i0])).[base + i]) = f.
proof.
move=> Hbase Hend; apply Array256.tP => j jb.
by rewrite Array256.initiE 1:/# /= Array_kpolys.initiE 1:/# /= /#.
qed.

(* a writeback of the window at base = 256 k changes the k-th polynomial only *)
lemma kvec_unflatten256_writeback_iE (arr : 'a Array_kpolys.t) (f : 'a Array256.t) (base k : int) :
  base %% 256 = 0 => 0 <= k < kvec =>
  (kvec_unflatten256 (Array_kpolys.init (fun i =>
    if base <= i < base + 256 then f.[i - base] else arr.[i]))).[k] =
  if k = base %/ 256 then f else (kvec_unflatten256 arr).[k].
proof.
move=> Hmod Hk; apply Array256.tP => j jb.
rewrite /kvec_unflatten256 KArray.initiE 1:/# /= get_of_list 1:/# nth_sub 1:/# /=.
rewrite Array_kpolys.initiE 1:/kpolys 1:/# /=.
case (k = base %/ 256) => Heq /=.
+ have -> : (base <= 256 * k + j && 256 * k + j < base + 256) = true by smt().
  by smt().
have -> : (base <= 256 * k + j && 256 * k + j < base + 256) = false by smt().
by rewrite kvec_unflatten256iE 1:/kpolys 1:/# /#.
qed.

lemma lvec_unflatten256_writeback_iE (arr : 'a Array_lpolys.t) (f : 'a Array256.t) (base k : int) :
  base %% 256 = 0 => 0 <= k < lvec =>
  (lvec_unflatten256 (Array_lpolys.init (fun i =>
    if base <= i < base + 256 then f.[i - base] else arr.[i]))).[k] =
  if k = base %/ 256 then f else (lvec_unflatten256 arr).[k].
proof.
move=> Hmod Hk; apply Array256.tP => j jb.
rewrite /lvec_unflatten256 LArray.initiE 1:/# /= get_of_list 1:/# nth_sub 1:/# /=.
rewrite Array_lpolys.initiE 1:/lpolys 1:/# /=.
case (k = base %/ 256) => Heq /=.
+ have -> : (base <= 256 * k + j && 256 * k + j < base + 256) = true by smt().
  by smt().
have -> : (base <= 256 * k + j && 256 * k + j < base + 256) = false by smt().
by rewrite lvec_unflatten256iE 1:/lpolys 1:/# /#.
qed.

(* row r of a flat K x L matrix, read as an L-vector *)
lemma mat_row_slice_unflatten (m : 'a Array_klpolys.t) (r k : int) :
  0 <= r < kvec => 0 <= k < lvec =>
  (lvec_unflatten256 (Array_lpolys.init (fun j => m.[lpolys * r + j]))).[k] =
  (mat_unflatten256 m).[r * lvec + k].
proof.
move=> Hr Hk; apply Array256.tP => j jb.
rewrite /lvec_unflatten256 LArray.initiE 1:/# /= get_of_list 1:/# nth_sub 1:/# /=.
rewrite Array_lpolys.initiE 1:/lpolys 1:/# /mat_unflatten256 KLMatrix.initiE; 1: smt(gt0_l).
rewrite /= get_of_list 1:/# nth_sub 1:/# /=; congr; rewrite /lpolys; ring.
qed.

(* -------------------------------------------------------------------- *)
(* The specification's separator encoding is the little-endian byte     *)
(* pair of the W16 counter                                              *)
import BS2Int.

lemma IntegerToBytes2E (k : int) :
  0 <= k < 65536 => IntegerToBytes k 2 = W2u8.to_list (W16.of_int k).
proof.
move=> rgk; rewrite /IntegerToBytes /BitsToBytes /IntegerToBits /=.
rewrite (int2bs_cat 8 16) // BitChunking.chunk_cat ?size_int2bs //.
rewrite !chunk_size ?size_int2bs //=.
split; apply W8.wordP => j rgj.
- rewrite get_bits2w // W2u8.bits8iE //= of_intwE /int_bit /=.
  have -> /= : 0 <= j < 16 by smt().
  by rewrite /int2bs nth_mkseq //= (pmod_small k 65536).
rewrite get_bits2w // W2u8.bits8iE //= of_intwE /int_bit /=.
have -> /= : 0 <= 8 + j < 16 by smt().
rewrite /int2bs nth_mkseq //= (pmod_small k 65536) // -divz_mul //.
by have -> // : 256 * 2 ^ j = 2 ^ (8 + j) by rewrite exprD_nneg /#.
qed.

(* -------------------------------------------------------------------- *)
(* Word packing in the byte view of an L-vector of u32 polynomials:      *)
(* init32, get32, set256_direct and get256_direct.                       *)
(* -------------------------------------------------------------------- *)

clone JArrayExtra.WAE as WAE_lpolys_bytes with
  op size <- lpolys_bytes, theory A <- WArray_lpolys_bytes.

(* the same for a K-vector (the hint encoder loads eight coefficients at a time) *)
clone JArrayExtra.WAE as WAE_kpolys_bytes with
  op size <- kpolys_bytes, theory A <- WArray_kpolys_bytes.

end PreludeT.
