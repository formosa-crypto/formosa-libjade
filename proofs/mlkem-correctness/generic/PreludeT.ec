(* -------------------------------------------------------------------- *)
(* The 16-bit representation of the vectors and matrices of the AVX2    *)
(* code, at abstract parameters: lifts to the specification, bounds,    *)
(* and slices of a vector into polynomials and of a matrix into rows.   *)
(* -------------------------------------------------------------------- *)
require import AllCore List Int IntDiv BitEncoding.
from Jasmin require import JModel_x86.
from JazzEC require import Array256 Array384.
from Spec require import GFq Rq Serialization Correctness EncDecCorrectness.
require import W16extra MLKEMFCLib.
require BaseT.
import BitChunking BS2Int.

(* -------------------------------------------------------------------- *)
(* the bits of a byte list, and the d-bit integers they decode to       *)
lemma nth_BytesToBits (l : W8.t list) n : 0 <= n < 8 * size l =>
  nth false (BytesToBits l) n = (nth W8.zero l (n %/ 8)).[n %% 8].
proof.
move=> nb; rewrite /BytesToBits (BitChunking.nth_flatten false 8).
+ by rewrite allP => x /mapP [w [_ ->]].
by rewrite (nth_map W8.zero) 1:/# W8.get_w2bits.
qed.

lemma nth_ByteDecode d (l : W8.t list) i : 0 < d => 0 <= i => d * i + d <= 8 * size l =>
  nth 0 (ByteDecode d l) i =
  bs2int (mkseq (fun j => (nth W8.zero l ((d * i + j) %/ 8)).[(d * i + j) %% 8]) d).
proof.
move=> d0 i0 il; have hi : i < 8 * size l %/ d.
+ have : (i + 1) * d %/ d <= 8 * size l %/ d by apply leq_div2r => /#.
  by rewrite mulzK 1:/#; smt().
have hs : size (nth [] (chunk d (BytesToBits l)) i) = d.
+ by rewrite size_nth_chunk 1:/# // size_BytesToBits.
rewrite /ByteDecode (nth_map []); 1: by rewrite size_chunk 1:/# size_BytesToBits.
congr; apply (eq_from_nth false); 1: by rewrite hs size_mkseq /#.
move=> j; rewrite hs => jb; rewrite nth_mkseq //=; 1: by rewrite size_BytesToBits.
by rewrite nth_take 1,2:/# nth_drop 1,2:/# nth_mkseq //= nth_BytesToBits /#.
qed.

lemma nth_ByteEncode d (l : int list) n : 0 < d => 0 <= n => 8 * n + 8 <= d * size l =>
  nth W8.zero (ByteEncode d l) n =
  W8.init (fun k => nth false (int2bs d (nth 0 l ((8 * n + k) %/ d))) ((8 * n + k) %% d)).
proof.
move=> d0 n0 nl; have sB : size (flatten (map (int2bs d) l)) = d * size l.
+ rewrite (size_flatten_ctt d) 2:size_map // => x /mapP [y [_ ->]].
  by rewrite size_int2bs; smt().
have hn : n < size (flatten (map (int2bs d) l)) %/ 8.
+ rewrite sB; have : (n + 1) * 8 %/ 8 <= d * size l %/ 8 by apply leq_div2r => /#.
  by rewrite mulzK 1:/#; smt().
rewrite /ByteEncode /BitsToBytes (nth_map []); 1: by rewrite size_chunk 1:/# /#.
apply W8.wordP => k kb; rewrite W8.get_bits2w // W8.initiE //=.
rewrite /chunk nth_mkseq 1:/# /= nth_take 1,2:/# nth_drop 1,2:/#.
rewrite (BitChunking.nth_flatten false d).
+ by rewrite allP => x /mapP [y [_ ->]] /=; smt(size_int2bs).
rewrite (nth_map 0) //; split; 1: smt(divz_ge0).
by move=> _; rewrite ltz_divLR 1:/#; smt().
qed.

(* the 12-bit encoding of 256 * k integers is the concatenation of the *)
(* 384-byte encodings of its 256-integer chunks                         *)
lemma ByteDecode12_sub (l : W8.t list) j k :
  0 <= j => 0 <= k < 256 => 384 * (j + 1) <= size l =>
  nth 0 (ByteDecode 12 l) (256 * j + k) =
  nth 0 (ByteDecode 12 (take 384 (drop (384 * j) l))) k.
proof.
move=> j0 kb sl; rewrite !nth_ByteDecode //; 1,2,3,4: smt(size_take size_drop).
congr; apply eq_in_mkseq => jj jjb /=.
have -> : 12 * (256 * j + k) + jj = (384 * j) * 8 + (12 * k + jj) by ring.
rewrite divzMDl // modzMDl nth_take 1:/#; 1: smt().
by rewrite nth_drop 1,2:/#.
qed.

lemma ByteEncode12_sub (l : int list) j n :
  0 <= j => 0 <= n < 384 => 256 * (j + 1) <= size l =>
  nth W8.zero (ByteEncode 12 l) (384 * j + n) =
  nth W8.zero (ByteEncode 12 (take 256 (drop (256 * j) l))) n.
proof.
move=> j0 nb sl; rewrite !nth_ByteEncode //; 1,2,3,4: smt(size_take size_drop).
apply/W8.wordP => k kb; rewrite !W8.initiE //=.
have -> : 8 * (384 * j + n) + k = 256 * j * 12 + (8 * n + k) by ring.
rewrite divzMDl // modzMDl; congr; congr.
by rewrite nth_take 1:/#; [smt() | rewrite nth_drop 1,2:/#].
qed.

abstract theory PreludeT.

clone import BaseT.BaseT as B.
import S R.
import Zq Serialization.
import PolyVec PolyMat KMatrix KMatrix.Matrix.
import BitChunking BS2Int.
import Array_vecn Array_matn Array_polyvec_bytes.

lemma vecnE : vecn = 256 * kvec by done.
lemma matnE : matn = kvec * vecn by done.

lemma matn_idx (i x : int) : 0 <= i < kvec => 0 <= x < vecn => 0 <= vecn * i + x < matn.
proof.
have gt0_vecn : 0 < vecn by rewrite vecnE; smt(gt0_k).
move=> [ge0i ltik] [ge0x ltxv].
have := StdOrder.IntOrder.ler_wpmul2l vecn _ (i + 1) kvec _; 1,2: smt().
have := StdOrder.IntOrder.mulr_ge0 vecn i _ _; 1,2: smt().
by rewrite matnE (mulzC kvec) mulrDr /= => /#.
qed.

(* -------------------------------------------------------------------- *)
op lift_arraymatn (p : W16.t Array_matn.t) =
  Array_matn.map (fun x => incoeff (W16.to_sint x)) p.

op [a] subarrayvecn (x : 'a Array_matn.t, i : int) : 'a Array_vecn.t =
  Array_vecn.init (fun (k : int) => x.[vecn * i + k]).

op [a] subarray256 (x : 'a Array_vecn.t, i : int) : 'a Array256.t =
  Array256.init (fun (k : int) => x.[256 * i + k]).

op pos_boundmatn_cxq (coefs : W16.t Array_matn.t) (l u c : int) : bool =
  forall (k : int), l <= k && k < u => bpos16 coefs.[k] (c * q).

op lift_arrayvecn (p : W16.t Array_vecn.t) =
  Array_vecn.map (fun x => incoeff (W16.to_sint x)) p.

op signed_boundvecn_cxq (coefs : W16.t Array_vecn.t) (l u c : int) : bool =
  forall (k : int), l <= k < u => b16 coefs.[k] (c * q).

op pos_boundvecn_cxq (coefs : W16.t Array_vecn.t) (l u c : int) : bool =
  forall (k : int), l <= k < u => bpos16 coefs.[k] (c * q).

lemma subliftsub (a : W16.t Array_vecn.t) i k : 0 <= i < kvec => 0 <= k < 256 =>
  (lift_array256 (subarray256 a i)).[k] = (lift_arrayvecn a).[256 * i + k].
proof.
move=> ib kb; rewrite /subarray256 /lift_array256 /lift_arrayvecn.
by rewrite !mapiE 1,2:/# /= !initiE /#.
qed.

lemma subsublift (a : W16.t Array_matn.t) i j k :
  0 <= i < kvec => 0 <= j < kvec => 0 <= k < 256 =>
  (subarray256 (subarrayvecn (lift_arraymatn a) i) j).[k] =
  (lift_arrayvecn (Array_vecn.init (fun x => a.[i * vecn + x]))).[256 * j + k].
proof.
move=> ib jb kb; have hj : 0 <= 256 * j + k < vecn by smt().
have hi := matn_idx i (256 * j + k) ib hj.
rewrite /subarray256 /subarrayvecn /lift_arraymatn /lift_arrayvecn.
rewrite Array256.initiE 1:/# /= Array_vecn.initiE 1:// /= Array_matn.mapiE 1:// /=.
by rewrite Array_vecn.mapiE 1:// /= Array_vecn.initiE 1:// /= mulrC.
qed.

(* -------------------------------------------------------------------- *)
(* a vector is the concatenation of its kvec polynomials                *)
lemma subarray256E (v : 'a Array_vecn.t) j k : 0 <= k < 256 =>
  (subarray256 v j).[k] = v.[256 * j + k].
proof. by move=> kb; rewrite /subarray256 Array256.initiE. qed.

lemma vecn_div (k : int) : 0 <= k < vecn => 0 <= k %/ 256 < kvec.
proof. by rewrite vecnE; smt(). qed.

lemma vecn_slice (j k : int) : 0 <= j < kvec => 0 <= k < 256 => 0 <= 256 * j + k < vecn.
proof. by rewrite vecnE; smt(). qed.

lemma vecn_tP (v w : 'a Array_vecn.t) :
  v = w <=> forall j, 0 <= j < kvec => subarray256 v j = subarray256 w j.
proof.
split=> [-> //| h]; apply Array_vecn.tP => k kb.
have := h (k %/ 256) (vecn_div k kb); rewrite Array256.tP => /(_ (k %% 256) _); 1: smt().
by rewrite !subarray256E 1,2:/# (mulzC 256) -divz_eq.
qed.

lemma subarray256_init (f : int -> 'a) j : 0 <= j < kvec =>
  subarray256 (Array_vecn.init f) j = Array256.init (fun k => f (256 * j + k)).
proof.
move=> jb; apply Array256.tP => k kb.
by rewrite subarray256E // Array_vecn.initiE 1:vecn_slice // Array256.initiE.
qed.

(* the vector with its i-th polynomial replaced by a *)
lemma subarray256_set (r : 'a Array_vecn.t) (a : 'a Array256.t) i j :
  0 <= i < kvec => 0 <= j < kvec =>
  subarray256 (Array_vecn.init (fun k =>
    if 256 * i <= k < 256 * i + 256 then a.[k - 256 * i] else r.[k])) j =
  if j = i then a else subarray256 r j.
proof.
move=> ib jb; rewrite subarray256_init //; apply Array256.tP => k kb.
rewrite Array256.initiE //=; case: (j = i) => [-> /=| ne]; 1: by rewrite ifT /#.
by rewrite ifF 2:subarray256E //; smt().
qed.

lemma all_vecn (P : 'a -> bool) (v : 'a Array_vecn.t) :
  Array_vecn.all P v <=> forall j, 0 <= j < kvec => Array256.all P (subarray256 v j).
proof.
rewrite Array_vecn.allP; split=> [h j jb|h k kb].
+ by rewrite Array256.allP => k kb; rewrite subarray256E // h vecn_slice.
have := h (k %/ 256) (vecn_div k kb); rewrite Array256.allP => /(_ (k %% 256) _); 1: smt().
by rewrite subarray256E 1:/# (mulzC 256) -divz_eq.
qed.

lemma signed_boundvecnP (v : W16.t Array_vecn.t) c :
  signed_boundvecn_cxq v 0 vecn c <=>
  forall j, 0 <= j < kvec => signed_bound_cxq (subarray256 v j) 0 256 c.
proof.
split=> [h j jb k kb|h k kb].
+ by rewrite subarray256E // h vecn_slice.
move: (h (k %/ 256) (vecn_div k kb) (k %% 256) _); 1: smt().
by rewrite subarray256E 1:/# (mulzC 256) -divz_eq.
qed.

lemma pos_boundvecnP (v : W16.t Array_vecn.t) c :
  pos_boundvecn_cxq v 0 vecn c <=>
  forall j, 0 <= j < kvec => pos_bound256_cxq (subarray256 v j) 0 256 c.
proof.
split=> [h j jb k kb|h k kb].
+ by rewrite subarray256E // h vecn_slice.
move: (h (k %/ 256) (vecn_div k kb) (k %% 256) _); 1: smt().
by rewrite subarray256E 1:/# (mulzC 256) -divz_eq.
qed.

lemma lift_subarray256 (v : W16.t Array_vecn.t) j : 0 <= j < kvec =>
  lift_array256 (subarray256 v j) = subarray256 (lift_arrayvecn v) j.
proof.
move=> jb; apply Array256.tP => k kb.
by rewrite /lift_array256 Array256.mapiE // !subarray256E // Array_vecn.mapiE 1:vecn_slice.
qed.

lemma subarray256_map (f : 'a -> 'b) (v : 'a Array_vecn.t) j : 0 <= j < kvec =>
  subarray256 (Array_vecn.map f v) j = Array256.map f (subarray256 v j).
proof.
move=> jb; apply Array256.tP => k kb.
by rewrite Array256.mapiE // !subarray256E // Array_vecn.mapiE 1:vecn_slice.
qed.

lemma to_list_subarray256 (v : 'a Array_vecn.t) j : 0 <= j < kvec =>
  Array256.to_list (subarray256 v j) = take 256 (drop (256 * j) (Array_vecn.to_list v)).
proof.
move=> jb; apply (eq_from_nth witness).
+ rewrite Array256.size_to_list size_take // size_drop 1:/# Array_vecn.size_to_list.
  by rewrite vecnE; smt().
move=> k; rewrite Array256.size_to_list => kb.
rewrite Array256.get_to_list nth_take 1,2:/# nth_drop 1,2:/#.
by rewrite Array_vecn.get_to_list subarray256E.
qed.

(* -------------------------------------------------------------------- *)
(* the 384-byte encodings of the polynomials of a vector                *)
lemma polyvec_bytesE : polyvec_bytes = 384 * kvec by done.

op [a] subarray384 (x : 'a Array_polyvec_bytes.t, i : int) : 'a Array384.t =
  Array384.init (fun (k : int) => x.[384 * i + k]).

lemma subarray384E (v : 'a Array_polyvec_bytes.t) j k : 0 <= k < 384 =>
  (subarray384 v j).[k] = v.[384 * j + k].
proof. by move=> kb; rewrite /subarray384 Array384.initiE. qed.

lemma polyvec_bytes_tP (v w : 'a Array_polyvec_bytes.t) :
  v = w <=> forall j, 0 <= j < kvec => subarray384 v j = subarray384 w j.
proof.
split=> [-> //| h]; apply Array_polyvec_bytes.tP => k kb.
have := h (k %/ 384) _; 1: by move: kb; rewrite polyvec_bytesE; smt().
rewrite Array384.tP => /(_ (k %% 384) _); 1: smt().
by rewrite !subarray384E 1,2:/# (mulzC 384) -divz_eq.
qed.

lemma to_list_subarray384 (v : 'a Array_polyvec_bytes.t) j : 0 <= j < kvec =>
  Array384.to_list (subarray384 v j) =
  take 384 (drop (384 * j) (Array_polyvec_bytes.to_list v)).
proof.
move=> jb; apply (eq_from_nth witness).
+ rewrite Array384.size_to_list size_take // size_drop 1:/# Array_polyvec_bytes.size_to_list.
  by rewrite polyvec_bytesE; smt().
move=> k; rewrite Array384.size_to_list => kb.
rewrite Array384.get_to_list nth_take 1,2:/# nth_drop 1,2:/#.
by rewrite Array_polyvec_bytes.get_to_list subarray384E.
qed.

lemma subarray384_set (r : 'a Array_polyvec_bytes.t) (a : 'a Array384.t) i j :
  0 <= i < kvec => 0 <= j < kvec =>
  subarray384 (Array_polyvec_bytes.init (fun k =>
    if 384 * i <= k < 384 * i + 384 then a.[k - 384 * i] else r.[k])) j =
  if j = i then a else subarray384 r j.
proof.
move=> ib jb; apply Array384.tP => k kb.
rewrite subarray384E // Array_polyvec_bytes.initiE /=; 1: by rewrite polyvec_bytesE; smt().
case: (j = i) => [-> /=|ne]; 1: by rewrite ifT /#.
by rewrite ifF 2:subarray384E //; smt().
qed.

(* -------------------------------------------------------------------- *)
(* a matrix is the concatenation of its kvec * kvec entries, row major  *)
op [a] blk (x : 'a Array_matn.t) (pos : int) : 'a Array256.t =
  Array256.init (fun (k : int) => x.[256 * pos + k]).

lemma matn_blk : matn = 256 * (kvec * kvec).
proof. by rewrite matnE vecnE; ring. qed.

lemma blkE (x : 'a Array_matn.t) pos k : 0 <= k < 256 => (blk x pos).[k] = x.[256 * pos + k].
proof. by move=> kb; rewrite /blk Array256.initiE. qed.

lemma matn_slice (pos k : int) : 0 <= pos < kvec * kvec => 0 <= k < 256 =>
  0 <= 256 * pos + k < matn.
proof. by rewrite matn_blk; smt(). qed.

lemma matn_tP (v w : 'a Array_matn.t) :
  v = w <=> forall pos, 0 <= pos < kvec * kvec => blk v pos = blk w pos.
proof.
split=> [-> //| h]; apply Array_matn.tP => n nb.
have := h (n %/ 256) _; 1: by move: nb; rewrite matn_blk; smt().
rewrite Array256.tP => /(_ (n %% 256) _); 1: smt().
by rewrite !blkE 1,2:/# (mulzC 256) -divz_eq.
qed.

lemma blk_set (r : 'a Array_matn.t) (a : 'a Array256.t) p pos :
  0 <= p < kvec * kvec => 0 <= pos < kvec * kvec =>
  blk (Array_matn.init (fun k =>
    if 256 * p <= k < 256 * p + 256 then a.[k - 256 * p] else r.[k])) pos =
  if pos = p then a else blk r pos.
proof.
move=> pb posb; apply Array256.tP => k kb.
rewrite blkE // Array_matn.initiE 1:matn_slice //=.
case: (pos = p) => [-> /=|ne]; 1: by rewrite ifT /#.
by rewrite ifF 2:blkE //; smt().
qed.

(* -------------------------------------------------------------------- *)
op lift_polyvec(vec : W16.t Array_vecn.t) : polyvec =
  KVec.init (fun i => lift_array256 (subarray256 vec i)).

op lift_matrix (a : W16.t Array_matn.t) : polymat =
  KMat.init (fun flat =>
    subarray256 (subarrayvecn (lift_arraymatn a) (flat %/ kvec)) (flat %% kvec)).

op unlift_matrix (a : polymat) : W16.t Array_matn.t = Array_matn.init
  (fun i => W16.of_int (asint (a.[i %/ vecn, i %% vecn %/ 256].[i %% 256]))%Matrix).

op unlift_polyvec (a : polyvec) =
  Array_vecn.init (fun i => W16.of_int (as_sint a.[i %/ 256].[i %% 256])).

lemma lift_polyvecE (v : W16.t Array_vecn.t) j : 0 <= j < kvec =>
  (lift_polyvec v).[j] = lift_array256 (subarray256 v j).
proof. by move=> jb; rewrite /lift_polyvec KVec.initiE. qed.

(* the decoded 12-bit integers of a vector are 12-bit *)
lemma decode12_vec_bnd (a : W8.t BytesPKVec.t) (k : int) :
  0 <= k < vecn => 0 <= (decode12_vec a).[k] < 4096.
proof.
move=> kb; rewrite /decode12_vec IPVec.get_of_list 1:/# /ByteDecode (nth_map witness).
+ rewrite size_chunk 1:/# size_BytesToBits size_to_list; smt().
have := bs2int_le2Xs (nth witness (chunk 12 (BytesToBits (to_list a))) k).
rewrite size_nth_chunk //=; 1: by rewrite size_BytesToBits size_to_list; smt().
by smt(bs2int_ge0).
qed.

lemma vector_unlift a :
  lift_polyvec (unlift_polyvec a) = a /\
  signed_boundvecn_cxq (unlift_polyvec a) 0 vecn 1.
proof.
split.
+ rewrite /unlift_polyvec; apply KVec.tP => i ib.
  rewrite /lift_polyvec KVec.initiE 1:/# /= /subarray256 /lift_array256 /= tP => k kb.
  rewrite mapiE //= initiE //= Array_vecn.initiE //= 1:/# /to_sint /smod /=.
  rewrite !of_uintK /=; smt(rg_crepr as_sintK qE).
rewrite /unlift_polyvec /signed_boundvecn_cxq => k kb; rewrite Array_vecn.initiE //=.
rewrite /to_sint /smod /= !of_uintK /=; smt(rg_crepr qE).
qed.

(* lifting a vector then taking its integers maps asint over its lift *)
lemma toipolivec_lift (_v : W16.t Array_vecn.t) :
  toipolyvec (lift_polyvec _v) =
  IPVec.init (fun idx => asint (lift_arrayvecn _v).[idx]).
proof.
rewrite /toipolyvec; apply IPVec.tP => idx ib.
rewrite !IPVec.initiE 1,2:/# /=; congr.
rewrite /lift_polyvec KVec.initiE 1:/#.
rewrite /= /lift_array256 mapiE 1:/#.
by rewrite Array256.mapiE 1:/# /subarray256 initiE 1:/# /= /#.
qed.

(* -------------------------------------------------------------------- *)
(* the 12-bit encoding of a vector, polynomial by polynomial            *)
lemma decode12_vec_sub (a : W8.t BytesPKVec.t) j : 0 <= j < kvec =>
  subarray256 (decode12_vec a) j = decode12 (subarray384 a j).
proof.
move=> jb; apply Array256.tP => k kb.
rewrite /subarray256 Array256.initiE //= /decode12_vec /decode12.
rewrite IPVec.get_of_list 1:/# Array256.get_of_list //.
rewrite !nth_ByteDecode //; 1,3: smt(); 1: by rewrite BytesPKVec.size_to_list; smt().
+ by rewrite Array384.size_to_list /#.
congr; apply eq_in_mkseq => jj jjb /=.
have -> : 12 * (256 * j + k) + jj = 8 * (384 * j) + (12 * k + jj) by ring.
rewrite (mulzC 8) divzMDl // modzMDl.
rewrite (nth_change_dfl witness) 1:BytesPKVec.size_to_list; 1: smt().
rewrite (nth_change_dfl witness _ (Array384.to_list (subarray384 a j))).
+ by rewrite Array384.size_to_list /#.
by rewrite BytesPKVec.get_to_list Array384.get_to_list /subarray384 Array384.initiE 1:/#.
qed.

lemma encode12_vec_sub (v : ipolyvec) j : 0 <= j < kvec =>
  subarray384 (encode12_vec v) j = encode12 (subarray256 v j).
proof.
move=> jb; apply Array384.tP => n nb.
rewrite /subarray384 Array384.initiE //= /encode12_vec /encode12.
rewrite BytesPKVec.get_of_list 1:/# Array384.get_of_list //.
rewrite !nth_ByteEncode //; 1,3: smt(); 1: by rewrite IPVec.size_to_list /#.
+ by rewrite Array256.size_to_list /#.
apply/W8.wordP => k kb; rewrite !W8.initiE //=.
have -> : 8 * (384 * j + n) + k = 256 * j * 12 + (8 * n + k) by ring.
rewrite divzMDl // modzMDl; congr; congr.
rewrite (nth_change_dfl witness) 1:IPVec.size_to_list; 1: smt().
rewrite (nth_change_dfl witness _ (Array256.to_list (subarray256 v j))).
+ by rewrite Array256.size_to_list /#.
by rewrite IPVec.get_to_list Array256.get_to_list /subarray256 Array256.initiE 1:/#.
qed.

end PreludeT.
