(**
  Registers and levels of the NTT tree, for the AVX2 NTTs whose
  coefficients stay in registers across the layers: a register holds 8
  consecutive coefficients of a polynomial ([vec]); each level of the
  tree, coefficient by coefficient; the twiddle tables, entry by entry;
  and the locality of the levels, which lets the per-block or
  per-column calls of the NTTs compose.
*)
require import AllCore CoreUtils List Ring IntDiv BitEncoding.
require import StdRing StdOrder.
from Jasmin require import JWord JArray JModel_x86.
require import MldsaConstants.
require import WArray1024.
require import Array2 Array4 Array8 Array16 Array256.
require import XArray256.
require import Nttzetas Nttspec.
require import Avx2red Listred.

import BitChunking.

(* ==================================================================== *)
(* The levels of the tree, coefficient by coefficient                   *)
(* ==================================================================== *)
(* the twiddle of block j of level k *)
op zj (k j : int) : W32.t = tw32 (zpow (j + 2^(7-k))).

lemma zjE (k j : int) : 0 <= k < 8 => 0 <= j < 2^(7-k) =>
  zj k j = W32.of_int (nth witness (zetaL k) j).
proof. by move=> rgk rgj; rewrite /zetaL ifT // nth_mkseq. qed.

(* coefficient x = j 2^(k+1) + t, in block j of level k *)
lemma reduce_level_pt (q : wpoly) (k j t x : int) :
  0 <= k < 8 => 0 <= j < 2^(7-k) => 0 <= t < 2^(k+1) => x = j * 2^(k+1) + t =>
  (reduce_level q k).[x] =
    if t < 2^k
    then q.[x] + mmr q.[x + 2^k] (zj k j)
    else q.[x - 2^k] - mmr q.[x] (zj k j).
proof.
move=> rgk rgj rgt ->; have eSk : 2^(k+1) = 2 * 2^k by rewrite exprS 1:/#.
case: (t < 2^k) => ht.
- have [-> _] := reduce_leveliE q k j t rgk rgj _; 1: smt().
  by rewrite /zj addzAC.
have [_ /=] := reduce_leveliE q k j (t - 2^k) rgk rgj _; 1: smt().
have -> : j * 2 ^ (k + 1) + 2 ^ k + (t - 2 ^ k) = j * 2 ^ (k + 1) + t by ring.
have -> : j * 2 ^ (k + 1) + (t - 2 ^ k) = j * 2 ^ (k + 1) + t - 2^k by ring.
by move=> ->.
qed.

(* ==================================================================== *)
(* Registers                                                            *)
(* ==================================================================== *)
(* the 8 coefficients of a polynomial from offset o *)
op vec (p : wpoly) (o : int) : W256.t = W8u32.pack8 (mkseq (fun l => p.[o + l]) 8).

(* a register in the low half of block j of level k ... *)
lemma vec_lo (q : wpoly) (k j r o : int) :
  0 <= k < 8 => 0 <= j < 2^(7-k) => 0 <= r => r + 8 <= 2^k => o = j * 2^(k+1) + r =>
  vec (reduce_level q k) o =
    W8u32.pack8 (mkseq (fun l => q.[o + l] + mmr q.[o + 2^k + l] (zj k j)) 8).
proof.
move=> rgk rgj ge0r hr ->; have eSk : 2^(k+1) = 2 * 2^k by rewrite exprS 1:/#.
rewrite /vec &(congr1 W8u32.pack8) &(eq_in_mkseq) => l rgl /=.
rewrite (reduce_level_pt q k j (r + l)) 1,2:// 1,2:/# ifT 1:/#.
by do 3! congr; ring.
qed.

(* ... and its partner in the high half *)
lemma vec_hi (q : wpoly) (k j r o : int) :
  0 <= k < 8 => 0 <= j < 2^(7-k) => 0 <= r => r + 8 <= 2^k => o = j * 2^(k+1) + r =>
  vec (reduce_level q k) (o + 2^k) =
    W8u32.pack8 (mkseq (fun l => q.[o + l] - mmr q.[o + 2^k + l] (zj k j)) 8).
proof.
move=> rgk rgj ge0r hr ->; have eSk : 2^(k+1) = 2 * 2^k by rewrite exprS 1:/#.
rewrite /vec &(congr1 W8u32.pack8) &(eq_in_mkseq) => l rgl /=.
rewrite (reduce_level_pt q k j (2^k + r + l)) 1,2:// 1,2:/# ifF 1:/#.
by congr; congr; ring.
qed.

(* levels 2 to 0: a register spans several blocks *)
lemma vec_small (q : wpoly) (k jb o : int) :
  0 <= k < 3 => 0 <= jb => o = jb * 2^(k+1) => o + 8 <= 256 =>
  vec (reduce_level q k) o =
    W8u32.pack8 (mkseq (fun l =>
      let j = jb + l %/ 2^(k+1) in
      if l %% 2^(k+1) < 2^k
      then q.[o + l] + mmr q.[o + (l + 2^k)] (zj k j)
      else q.[o + (l - 2^k)] - mmr q.[o + l] (zj k j)) 8).
proof.
move=> rgk ge0jb oE ho; have eSk : 2^(k+1) = 2 * 2^k by rewrite exprS 1:/#.
have e256 : 2^(7-k) * 2^(k+1) = 256.
- by rewrite -exprD_nneg 1,2:/# (: 7 - k + (k+1) = 8) 1:/#.
have gt0m : 0 < 2^(k+1) by apply IntOrder.expr_gt0.
rewrite /vec &(congr1 W8u32.pack8) &(eq_in_mkseq) => l rgl /=.
rewrite (reduce_level_pt q k (jb + l %/ 2^(k+1)) (l %% 2^(k+1))) 1://; last 3 first.
- by apply modz_cmp.
- by rewrite oE mulzDl {1}(divz_eq l (2^(k+1))); ring.
- by rewrite !addzA.
- smt().
split; 1: smt(divz_ge0).
move=> _; rewrite -(IntOrder.ltr_pmul2r (2^(k+1))) // e256 mulzDl -oE.
smt(lez_floor).
qed.

(* ==================================================================== *)
(* Twiddle tables                                                       *)
(* ==================================================================== *)
lemma nth_chunkE ['a] (x0 : 'a list) (r i : int) (s : 'a list) :
  0 <= i < size s %/ r => nth x0 (chunk r s) i = take r (drop (r * i) s).
proof. by move=> rgi; rewrite /chunk nth_mkseq. qed.

lemma zetas5E (i : int) : 0 <= i < 4 =>
  lAYER_5_ZETAS.[i] = W8u32.pack8 (nseq 8 (zj 5 i)).
proof.
move=> rgi; rewrite zeta_L5_AVX2 Array4.get_of_list 1:// (nth_map witness) //=.
by rewrite zjE.
qed.

lemma zetas4E (i : int) : 0 <= i < 8 =>
  lAYER_4_ZETAS.[i] = W8u32.pack8 (nseq 8 (zj 4 i)).
proof.
move=> rgi; rewrite zeta_L4_AVX2 Array8.get_of_list 1:// (nth_map witness) //=.
by rewrite zjE.
qed.

lemma zetas3E (i : int) : 0 <= i < 16 =>
  lAYER_3_ZETAS.[i] = W8u32.pack8 (nseq 8 (zj 3 i)).
proof.
move=> rgi; rewrite zeta_L3_AVX2 Array16.get_of_list 1:// (nth_map witness) //=.
by rewrite zjE.
qed.

lemma zetas2E (i jb jb2 : int) : 0 <= i < 16 => jb = 2 * i => jb2 = jb + 1 =>
  lAYER_2_ZETAS.[i] =
    W2u128.pack2 [W4u32.pack4 (nseq 4 (zj 2 jb)); W4u32.pack4 (nseq 4 (zj 2 jb2))].
proof.
move=> rgi -> ->; rewrite zeta_L2_AVX2 Array16.get_of_list 1://.
rewrite (nth_map witness) /=; 1: by rewrite size_map size_chunk.
rewrite (nth_map witness) /=; 1: by rewrite size_chunk.
rewrite nth_chunkE 1:/# /topair /= !nth_take // !nth_drop 1..4:/#.
by rewrite !zjE 1..4:/#.
qed.

lemma zetas1E (i jb jb2 : int) : 0 <= i < 16 => jb = 4 * i => jb2 = jb + 2 =>
  lAYER_1_ZETAS.[i] = W4u64.pack4 [
    W2u32.pack2 (nseq 2 (zj 1 jb)); W2u32.pack2 (nseq 2 (zj 1 jb2));
    W2u32.pack2 (nseq 2 (zj 1 (jb + 1))); W2u32.pack2 (nseq 2 (zj 1 (jb2 + 1)))].
proof.
move=> rgi -> ->; rewrite zeta_L1_AVX2 Array16.get_of_list 1://.
rewrite (nth_map witness) /=; 1: by rewrite size_map size_chunk.
rewrite (nth_map witness) /=; 1: by rewrite size_chunk.
rewrite nth_chunkE 1:/# /perm1L /= !nth_take // !nth_drop 1..8:/#.
by rewrite !zjE 1..8:/# addz0.
qed.

lemma zetas0E (i jb jb2 : int) : 0 <= i < 16 => jb = 8 * i => jb2 = jb + 4 =>
  lAYER_0_ZETAS.[i] = W8u32.pack8 [
    zj 0 jb; zj 0 (jb + 1); zj 0 jb2; zj 0 (jb2 + 1);
    zj 0 (jb + 2); zj 0 (jb + 3); zj 0 (jb2 + 2); zj 0 (jb2 + 3)].
proof.
move=> rgi -> ->; rewrite zeta_L0_AVX2 Array16.get_of_list 1://.
rewrite (nth_map witness) /=; 1: by rewrite size_map size_chunk.
rewrite (nth_map witness) /=; 1: by rewrite size_chunk.
rewrite nth_chunkE 1:/# /perm0L /= !nth_take // !nth_drop 1..16:/#.
by rewrite !zjE 1..16:/# addz0.
qed.

(* ==================================================================== *)
(* Loads, stores and the levels of a call                              *)
(* ==================================================================== *)
op levels (p : wpoly) (lo hi : int) : wpoly =
  foldr (fun i p => reduce_level p i) p (range lo hi).

lemma levels0_5E (p : wpoly) : levels p 0 5 =
  reduce_level (reduce_level (reduce_level (reduce_level (reduce_level p 4) 3) 2) 1) 0.
proof. by rewrite /levels /range /= -iotaredE. qed.

lemma levels5_8E (p : wpoly) : levels p 5 8 =
  reduce_level (reduce_level (reduce_level p 7) 6) 5.
proof. by rewrite /levels /range /= -iotaredE. qed.

(* q on the coefficients satisfying P, p elsewhere *)
op merge (P : int -> bool) (p q : wpoly) : wpoly =
  Array256.init (fun t => if P t then q.[t] else p.[t]).

lemma get256_vecE (p : wpoly) (x o : int) : 0 <= o < 249 => x = 4 * o =>
  get256_direct (WArray1024.init32 (fun i => p.[i])) x = vec p o.
proof. by move=> rgo ->; rewrite wpoly_get256_aligned. qed.

lemma get256_blkE (p : wpoly) (g k : int) : 0 <= g < 4 => 0 <= k < 8 =>
  get256_direct (WArray1024.init32 (fun i => p.[i])) (32 * (8 * g + k))
  = vec p (64 * g + 8 * k).
proof. by move=> 2?; rewrite (get256_vecE p _ (64 * g + 8 * k)) 1,2:/#. qed.

lemma set256_initE (p : wpoly) (x o : int) (w : W256.t) : 0 <= o < 249 => x = 4 * o =>
  Array256.init (fun i => get32 (set256_direct (init32 ("_.[_]" p)) x w) i)
  = Array256.fill (fun i => w \bits32 (i - o)) o 8 p.
proof. by move=> rgo ->; apply wpoly_set256_aligned. qed.

lemma vec_bits (q : wpoly) (o i : int) : 0 <= i < 8 => vec q o \bits32 i = q.[o + i].
proof. by move=> rgi; rewrite /vec pack8_bits32E // nth_mkseq. qed.

(* ==================================================================== *)
(* The twiddles of levels 7 and 6, loaded as immediates                *)
(* ==================================================================== *)
lemma zj7E : zj 7 0 = W32.of_int 25847.
proof. by rewrite zjE // zeta_L7E. qed.

lemma zj6E : zj 6 0 = W32.of_int (-2608894) /\ zj 6 1 = W32.of_int (-518909).
proof. by rewrite !zjE // zeta_L6E. qed.

(* ==================================================================== *)
(* Locality: a level only combines the coefficients t and t +/- 2^k of  *)
(* a same block, so it preserves the agreement on a set closed by this  *)
(* pairing                                                              *)
(* ==================================================================== *)
op agree (P : int -> bool) (p p' : wpoly) =
  forall t, 0 <= t < 256 => P t => p.[t] = p'.[t].

op closed (k : int) (P : int -> bool) =
     (forall t, 0 <= t < 256 => P t => t %% 2^(k+1) < 2^k => P (t + 2^k))
  /\ (forall t, 0 <= t < 256 => P t => 2^k <= t %% 2^(k+1) => P (t - 2^k)).

lemma reduce_level_frame (p p' : wpoly) (k : int) (P : int -> bool) :
  0 <= k < 8 => closed k P => agree P p p' =>
  agree P (reduce_level p k) (reduce_level p' k).
proof.
move=> rgk [hlo hhi] hag t rgt Pt.
have eSk : 2^(k+1) = 2 * 2^k by rewrite exprS 1:/#.
have e256 : 2^(7-k) * 2^(k+1) = 256.
- by rewrite -exprD_nneg 1,2:/# (: 7 - k + (k+1) = 8) 1:/#.
have gt0m : 0 < 2^(k+1) by apply IntOrder.expr_gt0.
have rgj : 0 <= t %/ 2^(k+1) < 2^(7-k).
- split; 1: smt(divz_ge0).
  by move=> _; rewrite ltz_divLR // e256; case: rgt.
have rgr := modz_cmp t (2^(k+1)) gt0m.
have tE := divz_eq t (2^(k+1)).
rewrite !(reduce_level_pt _ k (t %/ 2^(k+1)) (t %% 2^(k+1)) t) //.
have hb : (t %/ 2^(k+1) + 1) * 2^(k+1) <= 256.
- by rewrite -e256 IntOrder.ler_pmul2r // /#.
case: (t %% 2^(k+1) < 2^k) => h.
- rewrite (hag t) // (hag (t + 2^k)) //; first smt().
  by apply hlo.
rewrite (hag t) // (hag (t - 2^k)) //; first smt().
by apply hhi => /#.
qed.

lemma levelsS (p : wpoly) (lo hi : int) : lo < hi =>
  levels p lo hi = reduce_level (levels p (lo + 1) hi) lo.
proof. by move=> lt; rewrite /levels range_ltn. qed.

lemma levels_frame (p p' : wpoly) (lo hi : int) (P : int -> bool) :
     0 <= lo => hi <= 8
  => (forall k, lo <= k < hi => closed k P)
  => agree P p p' => agree P (levels p lo hi) (levels p' lo hi).
proof.
move=> ge0lo le8 hcl hag.
have h : forall n, 0 <= n => forall l, lo <= l => hi - l = n =>
  agree P (levels p l hi) (levels p' l hi).
- elim/natind => [n le0n _|n ge0n ih _] l hl hn.
  - by rewrite /levels !range_geq 1,2:/#.
  rewrite !(levelsS _ l hi) 1,2:/#.
  by apply reduce_level_frame; [smt() | apply hcl => /# | apply (ih _ (l + 1)) => /#].
case: (lo <= hi) => hle; first by apply (h (hi - lo)) => /#.
by rewrite /levels !range_geq 1,2:/#.
qed.

(* ==================================================================== *)
(* The inverse levels, coefficient by coefficient                       *)
(* ==================================================================== *)
(* the twiddle of block j of inverse level k *)
op izj (k j : int) : W32.t = tw32 (izv k j).

lemma izjE (k j : int) : 0 <= k < 8 => 0 <= j < 2^(7-k) =>
  nth witness (izetasL k) j = izj k j.
proof. by move=> rgk rgj; rewrite izetasLE // /izetaW nth_mkseq. qed.

lemma ireduce_level_pt (q : wpoly) (k j t x : int) :
  0 <= k < 8 => 0 <= j < 2^(7-k) => 0 <= t < 2^(k+1) => x = j * 2^(k+1) + t =>
  (ireduce_level q k).[x] =
    if t < 2^k
    then q.[x] + q.[x + 2^k]
    else mmr (q.[x] - q.[x - 2^k]) (izj k j).
proof.
move=> rgk rgj rgt ->; have eSk : 2^(k+1) = 2 * 2^k by rewrite exprS 1:/#.
case: (t < 2^k) => ht.
- have [-> _] := ireduce_leveliE q k j t rgk rgj _; 1: smt().
  by rewrite addzAC.
have [_ /=] := ireduce_leveliE q k j (t - 2^k) rgk rgj _; 1: smt().
have -> : j * 2 ^ (k + 1) + 2 ^ k + (t - 2 ^ k) = j * 2 ^ (k + 1) + t by ring.
have -> : j * 2 ^ (k + 1) + (t - 2 ^ k) = j * 2 ^ (k + 1) + t - 2^k by ring.
by move=> ->.
qed.

lemma ivec_lo (q : wpoly) (k j r o : int) :
  0 <= k < 8 => 0 <= j < 2^(7-k) => 0 <= r => r + 8 <= 2^k => o = j * 2^(k+1) + r =>
  vec (ireduce_level q k) o =
    W8u32.pack8 (mkseq (fun l => q.[o + l] + q.[o + 2^k + l]) 8).
proof.
move=> rgk rgj ge0r hr ->; have eSk : 2^(k+1) = 2 * 2^k by rewrite exprS 1:/#.
rewrite /vec &(congr1 W8u32.pack8) &(eq_in_mkseq) => l rgl /=.
rewrite (ireduce_level_pt q k j (r + l)) 1,2:// 1,2:/# ifT 1:/#.
by do 2! congr; ring.
qed.

lemma ivec_hi (q : wpoly) (k j r o : int) :
  0 <= k < 8 => 0 <= j < 2^(7-k) => 0 <= r => r + 8 <= 2^k => o = j * 2^(k+1) + r =>
  vec (ireduce_level q k) (o + 2^k) =
    W8u32.pack8 (mkseq (fun l => mmr (q.[o + 2^k + l] - q.[o + l]) (izj k j)) 8).
proof.
move=> rgk rgj ge0r hr ->; have eSk : 2^(k+1) = 2 * 2^k by rewrite exprS 1:/#.
rewrite /vec &(congr1 W8u32.pack8) &(eq_in_mkseq) => l rgl /=.
rewrite (ireduce_level_pt q k j (2^k + r + l)) 1,2:// 1,2:/# ifF 1:/#.
by do 4! congr; ring.
qed.

lemma ivec_small (q : wpoly) (k jb o : int) :
  0 <= k < 3 => 0 <= jb => o = jb * 2^(k+1) => o + 8 <= 256 =>
  vec (ireduce_level q k) o =
    W8u32.pack8 (mkseq (fun l =>
      let j = jb + l %/ 2^(k+1) in
      if l %% 2^(k+1) < 2^k
      then q.[o + (l + 2^k)] + q.[o + l]
      else mmr (q.[o + l] - q.[o + (l - 2^k)]) (izj k j)) 8).
proof.
move=> rgk ge0jb oE ho; have eSk : 2^(k+1) = 2 * 2^k by rewrite exprS 1:/#.
have e256 : 2^(7-k) * 2^(k+1) = 256.
- by rewrite -exprD_nneg 1,2:/# (: 7 - k + (k+1) = 8) 1:/#.
have gt0m : 0 < 2^(k+1) by apply IntOrder.expr_gt0.
rewrite /vec &(congr1 W8u32.pack8) &(eq_in_mkseq) => l rgl /=.
rewrite (ireduce_level_pt q k (jb + l %/ 2^(k+1)) (l %% 2^(k+1))) 1://; last 3 first.
- by apply modz_cmp.
- by rewrite oE mulzDl {1}(divz_eq l (2^(k+1))); ring.
- by rewrite !addzA W32.WRingA.addrC.
- smt().
split; 1: smt(divz_ge0).
move=> _; rewrite -(IntOrder.ltr_pmul2r (2^(k+1))) // e256 mulzDl -oE.
smt(lez_floor).
qed.

(* the final scaling *)
lemma vec_iscale (q : wpoly) (o : int) : 0 <= o => o + 8 <= 256 =>
  vec (iscale q) o = W8u32.pack8 (mkseq (fun l => mmr q.[o + l] (W32.of_int 41978)) 8).
proof.
move=> 2?; rewrite /vec &(congr1 W8u32.pack8) &(eq_in_mkseq) => l rgl /=.
by rewrite /iscale mapiE 1:/#.
qed.

(* ==================================================================== *)
(* Inverse twiddle tables                                               *)
(* ==================================================================== *)
lemma izetas3E (i : int) : 0 <= i < 16 => zETAS_TO_INVERT_LAYER_3.[i] = izj 3 i.
proof.
move=> rgi; rewrite -izjE // /izetasL.
by do 3! rewrite ifF //; rewrite ifT // Array16.get_to_list.
qed.

lemma izetas4E (i : int) : 0 <= i < 8 => zETAS_TO_INVERT_LAYER_4.[i] = izj 4 i.
proof.
move=> rgi; rewrite -izjE // /izetasL.
by do 4! rewrite ifF //; rewrite ifT // Array8.get_to_list.
qed.

lemma izetas5E (i : int) : 0 <= i < 4 => zETAS_TO_INVERT_LAYER_5.[i] = izj 5 i.
proof.
move=> rgi; rewrite -izjE // /izetasL.
by do 5! rewrite ifF //; rewrite ifT // Array4.get_to_list.
qed.

lemma izetas6E (i : int) : 0 <= i < 2 => zETAS_TO_INVERT_LAYER_6.[i] = izj 6 i.
proof.
move=> rgi; rewrite -izjE // /izetasL.
by do 6! rewrite ifF //; rewrite ifT // Array2.get_to_list.
qed.

lemma izj7E : izj 7 0 = W32.of_int 25847.
proof. by rewrite -izjE // /izetasL. qed.

lemma nth_flatten_map ['a 'b] (x0 : 'b) (f : 'a -> 'b list) (s : 'a list) (n i m : int) :
     (forall x, size (f x) = n) => 0 <= i < size s => 0 <= m < n
  => nth x0 (flatten (map f s)) (n * i + m) = nth x0 (f (nth witness s i)) m.
proof.
move=> hsz rgi rgm; rewrite (BitChunking.nth_flatten x0 n).
- by apply/List.allP => x /mapP [y [_ ->]]; apply hsz.
rewrite (mulzC n) divzMDl 1:/# modzMDl pdiv_small // pmod_small //=.
by rewrite (nth_map witness).
qed.

(* the tables of levels 2 to 0, read through an abstract table so that
   they are not unfolded *)
lemma nth_flat2 (T : W256.t Array16.t) (i : int) : 0 <= i < 16 =>
     nth witness (flatten (map (fun (z : W256.t) => [z \bits32 0; z \bits32 4])
       (Array16.to_list T))) (2 * i) = T.[i] \bits32 0
  /\ nth witness (flatten (map (fun (z : W256.t) => [z \bits32 0; z \bits32 4])
       (Array16.to_list T))) (2 * i + 1) = T.[i] \bits32 4.
proof.
move=> rgi; have h := nth_flatten_map witness (fun (z : W256.t) => [z \bits32 0; z \bits32 4])
  (Array16.to_list T) 2 i.
have /= h0 := h 0 _ _ _ => //; 1: by rewrite Array16.size_to_list.
by have /= h1 := h 1 _ _ _ => //; 1: by rewrite Array16.size_to_list.
qed.

lemma nth_flat4 (T : W256.t Array16.t) (i : int) : 0 <= i < 16 =>
  let s = flatten (map (fun (z : W256.t) => map (fun m => z \bits32 (2 * m)) perm1L)
            (Array16.to_list T)) in
     nth witness s (4 * i) = T.[i] \bits32 0
  /\ nth witness s (4 * i + 1) = T.[i] \bits32 4
  /\ nth witness s (4 * i + 2) = T.[i] \bits32 2
  /\ nth witness s (4 * i + 3) = T.[i] \bits32 6.
proof.
move=> rgi /=; have h := nth_flatten_map witness
  (fun (z : W256.t) => map (fun m => z \bits32 (2 * m)) perm1L) (Array16.to_list T) 4 i.
have hsz : forall (x : W256.t), size (map (fun m => x \bits32 (2 * m)) perm1L) = 4.
- by move=> x; rewrite size_map.
have hs : 0 <= i < size (Array16.to_list T) by rewrite Array16.size_to_list.
have /= h0 := h 0 hsz hs _ => //; have /= h1 := h 1 hsz hs _ => //.
by have /= h2 := h 2 hsz hs _ => //; have /= h3 := h 3 hsz hs _ => //.
qed.

lemma nth_flat8 (T : W256.t Array16.t) (i : int) : 0 <= i < 16 =>
  let s = flatten (map (fun (z : W256.t) => map ((\bits32) z) perm0L) (Array16.to_list T)) in
     nth witness s (8 * i) = T.[i] \bits32 0
  /\ nth witness s (8 * i + 1) = T.[i] \bits32 1
  /\ nth witness s (8 * i + 2) = T.[i] \bits32 4
  /\ nth witness s (8 * i + 3) = T.[i] \bits32 5
  /\ nth witness s (8 * i + 4) = T.[i] \bits32 2
  /\ nth witness s (8 * i + 5) = T.[i] \bits32 3
  /\ nth witness s (8 * i + 6) = T.[i] \bits32 6
  /\ nth witness s (8 * i + 7) = T.[i] \bits32 7.
proof.
move=> rgi /=; have h := nth_flatten_map witness
  (fun (z : W256.t) => map ((\bits32) z) perm0L) (Array16.to_list T) 8 i.
have hsz : forall (x : W256.t), size (map ((\bits32) x) perm0L) = 8.
- by move=> x; rewrite size_map.
have hs : 0 <= i < size (Array16.to_list T) by rewrite Array16.size_to_list.
have /= h0 := h 0 hsz hs _ => //; have /= h1 := h 1 hsz hs _ => //.
have /= h2 := h 2 hsz hs _ => //; have /= h3 := h 3 hsz hs _ => //.
have /= h4 := h 4 hsz hs _ => //; have /= h5 := h 5 hsz hs _ => //.
by have /= h6 := h 6 hsz hs _ => //; have /= h7 := h 7 hsz hs _ => //.
qed.

lemma izetasL2T : izetasL 2 = flatten (map
  (fun (z : W256.t) => [z \bits32 0; z \bits32 4]) (Array16.to_list zETAS_TO_INVERT_LAYER_2)).
proof. by rewrite /izetasL. qed.

lemma izetasL1T : izetasL 1 = flatten (map
  (fun (z : W256.t) => map (fun m => z \bits32 (2 * m)) perm1L)
  (Array16.to_list zETAS_TO_INVERT_LAYER_1)).
proof. by rewrite /izetasL. qed.

lemma izetasL0T : izetasL 0 = flatten (map
  (fun (z : W256.t) => map ((\bits32) z) perm0L) (Array16.to_list zETAS_TO_INVERT_LAYER_0)).
proof. by rewrite /izetasL. qed.

lemma izetas2E (i jb jb2 : int) : 0 <= i < 16 => jb = 2 * i => jb2 = jb + 1 =>
  zETAS_TO_INVERT_LAYER_2.[i] = W8u32.pack8 [
    izj 2 jb; izj 2 jb; izj 2 jb; izj 2 jb; izj 2 jb2; izj 2 jb2; izj 2 jb2; izj 2 jb2].
proof.
move=> rgi -> ->; rewrite T2_shape // -!izjE 1..4:/# izetasL2T.
by have [-> ->] := nth_flat2 zETAS_TO_INVERT_LAYER_2 i rgi.
qed.

lemma izetas1E (i jb jb2 : int) : 0 <= i < 16 => jb = 4 * i => jb2 = jb + 2 =>
  zETAS_TO_INVERT_LAYER_1.[i] = W8u32.pack8 [
    izj 1 jb; izj 1 jb; izj 1 jb2; izj 1 jb2;
    izj 1 (jb + 1); izj 1 (jb + 1); izj 1 (jb2 + 1); izj 1 (jb2 + 1)].
proof.
move=> rgi -> ->; rewrite T1_shape // -!izjE 1..8:/# izetasL1T.
by have /= [-> [-> [-> ->]]] := nth_flat4 zETAS_TO_INVERT_LAYER_1 i rgi.
qed.

lemma izetas0E (i jb jb2 : int) : 0 <= i < 16 => jb = 8 * i => jb2 = jb + 4 =>
  zETAS_TO_INVERT_LAYER_0.[i] = W8u32.pack8 [
    izj 0 jb; izj 0 (jb + 1); izj 0 jb2; izj 0 (jb2 + 1);
    izj 0 (jb + 2); izj 0 (jb + 3); izj 0 (jb2 + 2); izj 0 (jb2 + 3)].
proof.
hint +listred.
move=> rgi -> ->; rewrite -!izjE 1..16:/# izetasL0T.
have /= [-> [-> [-> [-> [-> [-> [-> ->]]]]]]] := nth_flat8 zETAS_TO_INVERT_LAYER_0 i rgi.
by rewrite -{1}(pack8K zETAS_TO_INVERT_LAYER_0.[i]).
qed.

(* ==================================================================== *)
(* The inverse levels of a call, and their locality                     *)
(* ==================================================================== *)
op ilevels (p : wpoly) (lo hi : int) : wpoly =
  foldl (fun p k => ireduce_level p k) p (range lo hi).

lemma ilevels0_5E (p : wpoly) : ilevels p 0 5 =
  ireduce_level (ireduce_level (ireduce_level (ireduce_level (ireduce_level p 0) 1) 2) 3) 4.
proof. by rewrite /ilevels /range /= -iotaredE. qed.

lemma ilevels5_8E (p : wpoly) : ilevels p 5 8 =
  ireduce_level (ireduce_level (ireduce_level p 5) 6) 7.
proof. by rewrite /ilevels /range /= -iotaredE. qed.

lemma invtree8E (p : wpoly) : invtree p 8 = ilevels (ilevels p 0 5) 5 8.
proof. by rewrite ilevels0_5E ilevels5_8E /invtree /range /= -iotaredE. qed.

lemma ireduce_level_frame (p p' : wpoly) (k : int) (P : int -> bool) :
  0 <= k < 8 => closed k P => agree P p p' =>
  agree P (ireduce_level p k) (ireduce_level p' k).
proof.
move=> rgk [hlo hhi] hag t rgt Pt.
have eSk : 2^(k+1) = 2 * 2^k by rewrite exprS 1:/#.
have e256 : 2^(7-k) * 2^(k+1) = 256.
- by rewrite -exprD_nneg 1,2:/# (: 7 - k + (k+1) = 8) 1:/#.
have gt0m : 0 < 2^(k+1) by apply IntOrder.expr_gt0.
have rgj : 0 <= t %/ 2^(k+1) < 2^(7-k).
- split; 1: smt(divz_ge0).
  by move=> _; rewrite ltz_divLR // e256; case: rgt.
have rgr := modz_cmp t (2^(k+1)) gt0m.
have tE := divz_eq t (2^(k+1)).
rewrite !(ireduce_level_pt _ k (t %/ 2^(k+1)) (t %% 2^(k+1)) t) //.
have hb : (t %/ 2^(k+1) + 1) * 2^(k+1) <= 256.
- by rewrite -e256 IntOrder.ler_pmul2r // /#.
case: (t %% 2^(k+1) < 2^k) => h.
- rewrite (hag t) // (hag (t + 2^k)) //; first smt().
  by apply hlo.
rewrite (hag t) // (hag (t - 2^k)) //; first smt().
by apply hhi => /#.
qed.

lemma ilevels_frame (p p' : wpoly) (lo hi : int) (P : int -> bool) :
     0 <= lo => hi <= 8
  => (forall k, lo <= k < hi => closed k P)
  => agree P p p' => agree P (ilevels p lo hi) (ilevels p' lo hi).
proof.
move=> ge0lo le8 hcl; rewrite /ilevels.
have : forall k, k \in range lo hi => 0 <= k < 8 /\ closed k P.
- by move=> k /mem_range rgk; split; [smt() | apply hcl].
elim: (range lo hi) p p' => //= k ks ih p p' hks hag.
apply ih; 1: by move=> k' hk'; apply hks; right.
by have [? ?] := hks k _ => //; apply ireduce_level_frame.
qed.

lemma iscale_frame (p p' : wpoly) (P : int -> bool) :
  agree P p p' => agree P (iscale p) (iscale p').
proof. by move=> hag t rgt Pt; rewrite /iscale !mapiE // hag. qed.

(* ==================================================================== *)
(* The last inverse level, with the scaling folded in                   *)
(* ==================================================================== *)
lemma ilevels5_7E (p : wpoly) : ilevels p 5 7 = ireduce_level (ireduce_level p 5) 6.
proof. by rewrite /ilevels /range /= -iotaredE. qed.

lemma invtree7E (p : wpoly) : invtree p 7 = ilevels (ilevels p 0 5) 5 7.
proof. by rewrite ilevels0_5E ilevels5_7E /invtree /range /= -iotaredE. qed.

lemma vec_ifinal_lo (q : wpoly) (o : int) : 0 <= o => o + 8 <= 128 =>
  vec (ifinal q) o =
    W8u32.pack8 (mkseq (fun l => mmr (q.[o + l] + q.[o + 128 + l]) (W32.of_int 41978)) 8).
proof.
move=> 2?; rewrite /vec &(congr1 W8u32.pack8) &(eq_in_mkseq) => l rgl /=.
by rewrite /ifinal initiE 1:/# /= ifT 1:/#; do 3! congr; ring.
qed.

lemma vec_ifinal_hi (q : wpoly) (o : int) : 0 <= o => o + 8 <= 128 =>
  vec (ifinal q) (o + 128) =
    W8u32.pack8 (mkseq (fun l =>
      mmr (q.[o + 128 + l] - q.[o + l]) (W32.of_int (-3975713))) 8).
proof.
move=> 2?; rewrite /vec &(congr1 W8u32.pack8) &(eq_in_mkseq) => l rgl /=.
by rewrite /ifinal initiE 1:/# /= ifF 1:/#; do 4! congr; ring.
qed.

lemma ifinal_frame (p p' : wpoly) (P : int -> bool) :
  closed 7 P => agree P p p' => agree P (ifinal p) (ifinal p').
proof.
move=> [hlo hhi] hag t rgt Pt; rewrite /ifinal !initiE //=.
case: (t < 128) => ht.
- by rewrite (hag t) // (hag (t + 128)) 1:/#; [apply hlo => /# | done].
by rewrite (hag t) // (hag (t - 128)) 1:/#; [apply hhi => /# | done].
qed.

(* the 8 stores of a column of registers *)
lemma store_colE (s p : wpoly) (j t : int) : 0 <= j < 4 => 0 <= t < 256 =>
  (fill (fun i => vec s (8 * j + 224) \bits32 (i - (8 * j + 224))) (8 * j + 224) 8
  (fill (fun i => vec s (8 * j + 192) \bits32 (i - (8 * j + 192))) (8 * j + 192) 8
  (fill (fun i => vec s (8 * j + 160) \bits32 (i - (8 * j + 160))) (8 * j + 160) 8
  (fill (fun i => vec s (8 * j + 128) \bits32 (i - (8 * j + 128))) (8 * j + 128) 8
  (fill (fun i => vec s (8 * j + 96) \bits32 (i - (8 * j + 96))) (8 * j + 96) 8
  (fill (fun i => vec s (8 * j + 64) \bits32 (i - (8 * j + 64))) (8 * j + 64) 8
  (fill (fun i => vec s (8 * j + 32) \bits32 (i - (8 * j + 32))) (8 * j + 32) 8
  (fill (fun i => vec s (8 * j) \bits32 (i - 8 * j)) (8 * j) 8 p)))))))).[t]
  = if t %/ 8 %% 4 = j then s.[t] else p.[t].
proof. by move=> rgj rgt; rewrite !Array256.filliE //; smt(vec_bits). qed.
