require import AllCore BitEncoding List RealExp IntDiv.
require JWordList.
from Jasmin require import JWord.
require import Array256.
require import Parameters.
require import GFq.
require import Rq.
require import Distr DList.
require MLDSA_W32_Vec.

abstract theory ConversionT.

clone include MLDSA_W32_Vec.W32VecT.

import Round ZModQ Zq MLDSAParams.
import PolyLVec.
import PolyKVec.
import PolyMat.

op IntegerToBits(x alpha : int) : bool list = BS2Int.int2bs alpha x. 
op BitsToInteger(y : bool list) : int = BS2Int.bs2int y.

op BitsToBytes(y : bool list) : W8.t list = map W8.bits2w (BitChunking.chunk 8 y).
op BytesToBits(x : W8.t list) : bool list = flatten (map W8.w2bits x).

op IntegerToBytes(x alpha : int) : W8.t list = take alpha (BitsToBytes (IntegerToBits x (alpha*8))).

lemma size_BytesToBits (l : W8.t list) : size (BytesToBits l) = 8 * size l by
     rewrite size_flatten /= StdBigop.Bigint.sumzE /= -map_comp /(\o) /=;
     rewrite !StdBigop.Bigint.BIA.big_mapT /= /(\o) /=;
     rewrite !StdBigop.Bigint.big_constz /=;
     rewrite !count_predT /= /= /#.

op CoeffFromThreeBytes(b0 b1 b2 : W8.t) : int option = 
   let b2 = if 127 < to_uint b2 then b2 - W8.of_int 128 else b2 in
   let z = 2^16*to_uint b2 + 2^8 * to_uint b1 + to_uint b0 in
   if z < q then Some z else None.

(* a candidate with a zero high byte is below 2^16 < q, hence accepted *)
lemma CoeffFromThreeBytes_hi0 (b0 b1 : W8.t) : CoeffFromThreeBytes b0 b1 W8.zero <> None.
proof.
rewrite /CoeffFromThreeBytes /=.
by rewrite ifT //; have := W8.to_uint_cmp b0; have := W8.to_uint_cmp b1; smt().
qed.

op CoeffFromHalfByte(b : int) : int option =
   if Eta = 2 && b < 15 
   then Some (2 - (b %% 5))
   else if Eta = 4 && b < 9 
        then Some (4 - b)
        else None.

op SimpleBitPack(w : poly, b : int) : W8.t list = 
   let blen_b = ilog 2 b + 1 in
     BitsToBytes (flatten (map (fun wi => IntegerToBits (asint wi) blen_b) (to_list w))).

op BitPack(w : poly, a b : int) : W8.t list = 
   let blen_ab = ilog 2 (a + b) + 1 in
     BitsToBytes (flatten (map (fun wi => IntegerToBits (b - crepr wi) blen_ab) (to_list w))).

op SimpleBitUnpack(v : W8.t list, b : int) : poly =
   let c = ilog 2 b + 1 in
   let z = BytesToBits(v) in
     init (fun i => nth witness (map (fun co => incoeff (BitsToInteger co)) (BitChunking.chunk c z)) i).

op BitUnpack(v : W8.t list, a b : int) : poly =
   let c = ilog 2 (a + b) + 1 in
   let z = BytesToBits(v) in
     init (fun i => nth witness (map (fun co => incoeff (b - BitsToInteger co)) (BitChunking.chunk c z)) i).

(* -------------------------------------------------------------------- *)
(* sizes of the encodings                                               *)
lemma size_BitsToBytes (l : bool list) : size (BitsToBytes l) = size l %/ 8.
proof. by rewrite /BitsToBytes size_map BitChunking.size_chunk. qed.

lemma size_IntegerToBytes (x a : int) : 0 <= a => size (IntegerToBytes x a) = a.
proof.
move=> ge0a; rewrite /IntegerToBytes /IntegerToBits size_take // size_BitsToBytes.
by rewrite BS2Int.size_int2bs StdOrder.IntOrder.ler_maxr 1:/# mulzK.
qed.

lemma size_SimpleBitPack (p : poly) (b : int) :
  1 <= b => size (SimpleBitPack p b) = (ilog 2 b + 1) * n %/ 8.
proof.
move=> hb; rewrite /SimpleBitPack /= size_BitsToBytes (size_flatten_ctt (ilog 2 b + 1)).
+ by move=> l /mapP [c [_ ->]]; rewrite /IntegerToBits BS2Int.size_int2bs; smt(ilog_ge0).
by rewrite size_map size_to_list.
qed.

lemma size_BitPack (p : poly) (a b : int) :
  1 <= a + b => size (BitPack p a b) = (ilog 2 (a + b) + 1) * n %/ 8.
proof.
move=> hab; rewrite /BitPack /= size_BitsToBytes (size_flatten_ctt (ilog 2 (a + b) + 1)).
+ by move=> l /mapP [c [_ ->]]; rewrite /IntegerToBits BS2Int.size_int2bs; smt(ilog_ge0).
by rewrite size_map size_to_list.
qed.

(* -------------------------------------------------------------------- *)
(* round trips                                                          *)
lemma BitsToBytesK (y : bool list) : 8 %| size y => BytesToBits (BitsToBytes y) = y.
proof.
move=> h; rewrite /BytesToBits /BitsToBytes -map_comp; apply JWordList.map_chunkK => // l hl.
by rewrite /(\o) W8.bits2wK.
qed.

lemma BytesToBitsK (x : W8.t list) : BitsToBytes (BytesToBits x) = x.
proof.
rewrite /BitsToBytes /BytesToBits BitChunking.flattenK //.
+ by move=> b /mapP [w [_ ->]]; rewrite W8.size_w2bits.
rewrite -map_comp; apply (eq_from_nth witness); rewrite ?size_map // => i hi.
by rewrite (nth_map witness) // /(\o) W8.w2bitsK.
qed.

lemma IntegerToBytesK (x a : int) :
  0 <= a => 0 <= x < 2 ^ (8 * a) => BS2Int.bs2int (BytesToBits (IntegerToBytes x a)) = x.
proof.
move=> ge0a hx; rewrite /IntegerToBytes /IntegerToBits take_oversize.
+ by rewrite size_BitsToBytes BS2Int.size_int2bs StdOrder.IntOrder.ler_maxr 1:/# mulzK.
rewrite BitsToBytesK ?BS2Int.size_int2bs; 1: by rewrite StdOrder.IntOrder.ler_maxr 1:/# dvdz_mull dvdzz.
by rewrite (mulzC a) BS2Int.int2bsK /#.
qed.

lemma SimpleBitPackK (p : poly) (b : int) :
  0 < b => (forall i, 0 <= i < n => asint p.[i] <= b) => SimpleBitUnpack (SimpleBitPack p b) b = p.
proof.
move=> hb hp; rewrite /SimpleBitUnpack /SimpleBitPack /=.
have [_ hlt] := ilogP 2 b _ _; 1,2: smt().
have hc : 0 < ilog 2 b + 1 by smt(ilog_ge0).
have hsz : forall x, x \in map (fun (wi : coeff) => IntegerToBits (asint wi) (ilog 2 b + 1))
                             (Array256.to_list p) =>
                     size x = ilog 2 b + 1
  by move=> x /mapP [w [_ ->]]; rewrite /IntegerToBits BS2Int.size_int2bs /#.
rewrite BitsToBytesK.
+ by rewrite (size_flatten_ctt _ _ hsz) size_map Array256.size_to_list; apply dvdz_mull.
rewrite BitChunking.flattenK // -map_comp; apply Array256.ext_eq => i hi.
rewrite Array256.initiE //= (nth_map witness) ?Array256.size_to_list // /(\o) /= /BitsToInteger /IntegerToBits
        BS2Int.int2bsK; 1,2: smt(Array256.get_to_list ge0_asint).
by rewrite asintK.
qed.

lemma BitPackK (p : poly) (a b : int) :
  0 < a + b => (forall i, 0 <= i < n => -a <= crepr p.[i] <= b) =>
  BitUnpack (BitPack p a b) a b = p.
proof.
move=> hab hp; rewrite /BitUnpack /BitPack /=.
have [_ hlt] := ilogP 2 (a + b) _ _; 1,2: smt().
have hc : 0 < ilog 2 (a + b) + 1 by smt(ilog_ge0).
have hsz : forall x, x \in map (fun (wi : coeff) => IntegerToBits (b - crepr wi) (ilog 2 (a + b) + 1))
                             (Array256.to_list p) =>
                     size x = ilog 2 (a + b) + 1
  by move=> x /mapP [w [_ ->]]; rewrite /IntegerToBits BS2Int.size_int2bs /#.
rewrite BitsToBytesK.
+ by rewrite (size_flatten_ctt _ _ hsz) size_map Array256.size_to_list; apply dvdz_mull.
rewrite BitChunking.flattenK // -map_comp; apply Array256.ext_eq => i hi.
rewrite Array256.initiE //= (nth_map witness) ?Array256.size_to_list // /(\o) /= /BitsToInteger /IntegerToBits
        BS2Int.int2bsK; 1,2: smt(Array256.get_to_list).
by rewrite (_ : b - (b - crepr p.[i]) = crepr p.[i]) 1:/# creprK.
qed.

lemma BitUnpackK (v : W8.t list) (a b : int) :
  0 < a + b => 2 ^ (ilog 2 (a + b) + 1) = a + b + 1 =>
  (q + 1) %/ 2 - q <= -a => b < (q + 1) %/ 2 =>
  8 * size v = n * (ilog 2 (a + b) + 1) =>
  BitPack (BitUnpack v a b) a b = v.
proof.
move=> hab hpow hlo hhi hsz; rewrite /BitPack /BitUnpack /=.
have hc : 0 < ilog 2 (a + b) + 1 by smt(ilog_ge0).
pose cs := BitChunking.chunk (ilog 2 (a + b) + 1) (BytesToBits v).
have hcs : size cs = n by rewrite /cs BitChunking.size_chunk // size_BytesToBits hsz mulzK 1:/#.
have -> : Array256.to_list (Array256.init (nth witness (map (fun (co : bool list) => incoeff (b - BitsToInteger co)) cs))) =
          map (fun (co : bool list) => incoeff (b - BitsToInteger co)) cs.
+ apply (eq_from_nth witness); 1: by rewrite Array256.size_to_list size_map hcs.
  by rewrite Array256.size_to_list => i hi; rewrite Array256.get_to_list Array256.initiE.
have hmap : forall co, co \in cs =>
              IntegerToBits (b - crepr (incoeff (b - BitsToInteger co))) (ilog 2 (a + b) + 1) = co.
+ move=> co hco; have hs := BitChunking.in_chunk_size _ _ _ hc hco.
  rewrite /IntegerToBits /BitsToInteger incoeffK_centered; 1,2: smt(BS2Int.bs2int_ge0 BS2Int.bs2int_le2Xs).
  by rewrite (_ : b - (b - BS2Int.bs2int co) = BS2Int.bs2int co) 1:/# -hs BS2Int.bs2intK.
rewrite -map_comp (_ : map _ cs = cs).
+ apply (eq_from_nth witness); rewrite ?size_map // => i hi.
  have hi' : 0 <= i < size cs by rewrite /cs BitChunking.size_chunk //; smt(size_iota).
  by rewrite (nth_map witness) // /(\o) /=; apply hmap; exact mem_nth.
rewrite /cs BitChunking.chunkK ?BytesToBitsK //; rewrite size_BytesToBits hsz; apply dvdz_mull; apply dvdzz.
qed.

(* Validity predicate for byte-encoded eta-bounded polynomials at the spec level.
   Each (ilog 2 (2*Eta) + 1)-bit chunk of v represents an integer in [0, 2*Eta],
   matching valid_eta_bytes from the implementation proofs. *)
op valid_eta_bytes (v : W8.t list) : bool =
    forall i, 0 <= i < n =>
       BitsToInteger (nth witness
                          (BitChunking.chunk (ilog 2 (Eta + Eta) + 1) (BytesToBits v))
                          i) <= 2*Eta.

(* Each coefficient of BitUnpack v Eta Eta lies in [-Eta, Eta], so infnorm < Eta+1.
   Requires v has valid size and each nibble is in [0, 2*Eta] (valid_eta_bytes). *)
lemma BitUnpack_infnorm (v : W8.t list) :
    size v = (n * (ilog 2 (Eta + Eta) + 1)) %/ 8 =>
    valid_eta_bytes v =>
    infnorm_lt (BitUnpack v Eta Eta) (Eta + 1).
proof.
move => Hs Hval.
have ? : 8 * (n * (ilog 2 (Eta + Eta) + 1) %/ 8) %/ (ilog 2 (Eta + Eta) + 1) = n.
+ have hk : 0 < ilog 2 (Eta + Eta) + 1 by smt(ilog_ge0 param_sets).
  have h8nk : 8 %| n * (ilog 2 (Eta + Eta) + 1) by rewrite dvdz_mulr.
  by rewrite mulrC divzK // mulzK 1:/#.
rewrite /infnorm_lt /BitUnpack allP => k; rewrite mem_iota /= => kb.
rewrite initiE 1:/# (nth_map witness) /=.
+ rewrite BitChunking.size_chunk /=; 1: smt(ilog_ge0 param_sets).
  rewrite size_BytesToBits Hs /= /#.
pose x := (BitChunking.chunk (ilog 2 (Eta + Eta) + 1) (BytesToBits v)).
suff : 0 <= BitsToInteger (nth witness<:bool list> x k) <= 2*Eta.
+ rewrite -incoeffK_centered;  smt(abs_zp_small gamma2_bound param_sets).
split; first by rewrite /BitsToInteger; smt(BS2Int.bs2int_ge0).
by move => _; apply Hval; smt().
qed.

module HintPackUnpack = {
   proc hintBitPack(h : polykvec) : W8.t list = {
     var index : int;
     var y : W8.t list;
     var i,j;
     y <- mkseq (fun _ => W8.zero) (kvec + w_hint);
     index <- 0;
     i <- 0;
     while (i < kvec) {
        j <- 0;
        while (j < 256) {
           if (h.[i].[j] = Zq.one) {
              y <- put y index (W8.of_int j);
              index <- index + 1;
           }
           j <- j + 1;
        }
        y <- put y (w_hint + i) (W8.of_int index);
        i <- i + 1;
     }
     return y;
   }

   proc hintBitUnpack(y : W8.t list) : polykvec option = {
     var h : polykvec;
     var index : int;
     var error : bool;
     var _first : int;
     var i;
     h <- witness;
     index <- 0;
     error <- false;
     i <- 0;
     while (i < kvec && !error) {
       h.[i] <- Array256.init (fun k => Zq.zero);
       if (to_uint (nth witness y (w_hint+i)) < index || 
                   w_hint < to_uint (nth witness y (w_hint+i))) {
           error <- true; 
       }
       else {
          _first <- index;
          while (index < to_uint (nth witness y (w_hint+i)) && !error) {
             if (_first < index /\ to_uint (nth witness y (index)) <= to_uint (nth witness y (index-1))) {
                error <- true;
             }
             else {
                h.[i] <- h.[i].[to_uint (nth witness y index) <- Zq.one];
                index <- index + 1;
             }
          }
          if (!error) {
              i <- i + 1;
          }
       }       
     }
     while (index < w_hint && !error) {
       if (to_uint (nth witness y index) <> 0) {
         error <- true;
       }
       else {
         index <- index + 1;
       }
     }
     return if error then None else Some h;
   }
}.



(* -------------------------------------------------------------------- *)
(* BitUnpack maps uniform bytes to uniform coefficients in [-a, b] when *)
(* a + b + 1 is a power of 2                                            *)

lemma dmap_BitUnpack (a b : int) :
  0 < a + b => 2 ^ (ilog 2 (a + b) + 1) = a + b + 1 =>
  (q + 1) %/ 2 - q <= -a => b < (q + 1) %/ 2 =>
  dmap (dlist W8.dword ((ilog 2 (a + b) + 1) * n %/ 8)) (fun v => BitUnpack v a b) = dpoly (-a) b.
proof.
move=> hab hpow hlo hhi.
pose c := ilog 2 (a + b) + 1.
have hc : 0 < c by smt(ilog_ge0).
have hL : 8 * (c * n %/ 8) = n * c by smt().
have hK : forall v, size v = c * n %/ 8 => BitPack (BitUnpack v a b) a b = v.
- by move=> v hv; apply BitUnpackK => //; rewrite hv.
have hu1 : is_uniform (dmap (dlist W8.dword (c * n %/ 8)) (fun v => BitUnpack v a b)).
- apply dmap_uni_in_inj; last by apply dlist_uni; exact W8.dword_uni.
  move=> x y; rewrite !supp_dlist 1,2:/# => -[hx _] [hy _] /= hxy.
  by rewrite -(hK x hx) -(hK y hy) hxy.
have hs : support (dmap (dlist W8.dword (c * n %/ 8)) (fun v => BitUnpack v a b)) = support (dpoly (-a) b).
- apply fun_ext => z; apply eq_iff; rewrite (supp_dpoly (-a) b z hlo hhi); split.
  + rewrite supp_dmap => -[v [hv ->]] i hi /=; move: hv; rewrite supp_dlist 1:/# => -[hv _].
    have hn : 0 <= i < size (BytesToBits v) %/ c by rewrite size_BytesToBits hv hL mulzK 1:/#.
    have hsz := BitChunking.size_nth_chunk witness (BytesToBits v) i c _ hn; 1: smt().
    rewrite /BitUnpack /= -/c Array256.initiE //= (nth_map witness) /=; 1: by rewrite BitChunking.size_chunk.
    have hb0 := BS2Int.bs2int_ge0 (nth witness (BitChunking.chunk c (BytesToBits v)) i).
    have hb1 := BS2Int.bs2int_le2Xs (nth witness (BitChunking.chunk c (BytesToBits v)) i).
    rewrite hsz hpow in hb1.
    by rewrite /BitsToInteger incoeffK_centered; smt().
  move=> h; rewrite supp_dmap; exists (BitPack z a b); split.
  + rewrite supp_dlist 1:/# size_BitPack 1:/# /=.
    by split; [done | apply/List.allP => x _; exact W8.dword_fu].
  by rewrite /= BitPackK //; smt().
have hl1 : is_lossless (dmap (dlist W8.dword (c * n %/ 8)) (fun v => BitUnpack v a b)).
- by apply dmap_ll; apply dlist_ll; exact W8.dword_ll.
have hu2 := dpoly_uni (-a) b hlo hhi.
have hl2 := dpoly_ll (-a) b _; 1: smt().
by apply eq_distr => y; rewrite (mu1_uni_ll _ _ hu1 hl1) (mu1_uni_ll _ _ hu2 hl2) hs.
qed.

end ConversionT.
