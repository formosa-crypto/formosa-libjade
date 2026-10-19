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
lemma reduce_level_pt (p : wpoly) (k j t x : int) :
  0 <= k < 8 => 0 <= j < 2^(7-k) => 0 <= t < 2^(k+1) => x = j * 2^(k+1) + t =>
  (reduce_level p k).[x] =
    if t < 2^k
    then p.[x] + mmr p.[x + 2^k] (zj k j)
    else p.[x - 2^k] - mmr p.[x] (zj k j).
proof.
move=> rgk rgj rgt ->; have eSk : 2^(k+1) = 2 * 2^k by rewrite exprS 1:/#.
case: (t < 2^k) => ht.
- have [-> _] := reduce_leveliE p k j t rgk rgj _; 1: smt().
  by rewrite /zj addzAC.
have [_ /=] := reduce_leveliE p k j (t - 2^k) rgk rgj _; 1: smt().
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
lemma vec_lo (p : wpoly) (k j r o : int) :
  0 <= k < 8 => 0 <= j < 2^(7-k) => 0 <= r => r + 8 <= 2^k => o = j * 2^(k+1) + r =>
  vec (reduce_level p k) o =
    W8u32.pack8 (mkseq (fun l => p.[o + l] + mmr p.[o + 2^k + l] (zj k j)) 8).
proof.
move=> rgk rgj ge0r hr ->; have eSk : 2^(k+1) = 2 * 2^k by rewrite exprS 1:/#.
rewrite /vec &(congr1 W8u32.pack8) &(eq_in_mkseq) => l rgl /=.
rewrite (reduce_level_pt p k j (r + l)) 1,2:// 1,2:/# ifT 1:/#.
by do 3! congr; ring.
qed.

(* ... and its partner in the high half *)
lemma vec_hi (p : wpoly) (k j r o : int) :
  0 <= k < 8 => 0 <= j < 2^(7-k) => 0 <= r => r + 8 <= 2^k => o = j * 2^(k+1) + r =>
  vec (reduce_level p k) (o + 2^k) =
    W8u32.pack8 (mkseq (fun l => p.[o + l] - mmr p.[o + 2^k + l] (zj k j)) 8).
proof.
move=> rgk rgj ge0r hr ->; have eSk : 2^(k+1) = 2 * 2^k by rewrite exprS 1:/#.
rewrite /vec &(congr1 W8u32.pack8) &(eq_in_mkseq) => l rgl /=.
rewrite (reduce_level_pt p k j (2^k + r + l)) 1,2:// 1,2:/# ifF 1:/#.
by congr; congr; ring.
qed.

(* levels 2 to 0: a register spans several blocks *)
lemma vec_small (p : wpoly) (k jb o : int) :
  0 <= k < 3 => 0 <= jb => o = jb * 2^(k+1) => o + 8 <= 256 =>
  vec (reduce_level p k) o =
    W8u32.pack8 (mkseq (fun l =>
      let j = jb + l %/ 2^(k+1) in
      if l %% 2^(k+1) < 2^k
      then p.[o + l] + mmr p.[o + (l + 2^k)] (zj k j)
      else p.[o + (l - 2^k)] - mmr p.[o + l] (zj k j)) 8).
proof.
move=> rgk ge0jb oE ho; have eSk : 2^(k+1) = 2 * 2^k by rewrite exprS 1:/#.
have e256 : 2^(7-k) * 2^(k+1) = 256.
- by rewrite -exprD_nneg 1,2:/# (: 7 - k + (k+1) = 8) 1:/#.
have gt0m : 0 < 2^(k+1) by apply IntOrder.expr_gt0.
rewrite /vec &(congr1 W8u32.pack8) &(eq_in_mkseq) => l rgl /=.
rewrite (reduce_level_pt p k (jb + l %/ 2^(k+1)) (l %% 2^(k+1))) 1://; last 3 first.
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

(* p' on the coefficients satisfying P, p elsewhere *)
op merge (P : int -> bool) (p p' : wpoly) : wpoly =
  Array256.init (fun t => if P t then p'.[t] else p.[t]).

lemma merge_none (P : int -> bool) (p p' : wpoly) :
  (forall t, 0 <= t < 256 => !P t) => merge P p p' = p.
proof. by move=> hP; apply Array256.tP => t rgt; rewrite /merge initiE //= /#. qed.

lemma merge_all (P : int -> bool) (p p' : wpoly) :
  (forall t, 0 <= t < 256 => P t) => merge P p p' = p'.
proof. by move=> hP; apply Array256.tP => t rgt; rewrite /merge initiE //= /#. qed.

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

lemma vec_bits (p : wpoly) (o i : int) : 0 <= i < 8 => vec p o \bits32 i = p.[o + i].
proof. by move=> rgi; rewrite /vec pack8_bits32E // nth_mkseq. qed.

(* a 256-bit store at the aligned index i *)
abbrev st (p : wpoly) (i : int) (w : W256.t) : wpoly =
  Array256.init (fun k => get32 (set256 (init32 ("_.[_]" p)) i w) k).

(* the loads of a column of registers *)
lemma get256_colE (p : wpoly) (j m : int) : 0 <= j < 4 => 0 <= m < 32 => m %% 4 = 0 =>
  get256_direct (WArray1024.init32 (fun i => p.[i])) (32 * (j + m)) = vec p (8 * j + 8 * m).
proof. by move=> 3?; rewrite (get256_vecE p _ (8 * j + 8 * m)) 1,2:/#. qed.

(* the stores of the registers of a call: the block g of p' ... *)
lemma store_blkE (p p' : wpoly) (g : int) : 0 <= g < 4 =>
  st (st (st (st (st (st (st (st p
    (8 * g) (vec p' (64 * g))) (8 * g + 1) (vec p' (64 * g + 8)))
    (8 * g + 2) (vec p' (64 * g + 16))) (8 * g + 3) (vec p' (64 * g + 24)))
    (8 * g + 4) (vec p' (64 * g + 32))) (8 * g + 5) (vec p' (64 * g + 40)))
    (8 * g + 6) (vec p' (64 * g + 48))) (8 * g + 7) (vec p' (64 * g + 56))
  = merge (fun t => t %/ 64 = g) p p'.
proof.
move=> rgg.
rewrite (set256_initE _ _ (64 * g + 56)) 1,2:/# (set256_initE _ _ (64 * g + 48)) 1,2:/#.
rewrite (set256_initE _ _ (64 * g + 40)) 1,2:/# (set256_initE _ _ (64 * g + 32)) 1,2:/#.
rewrite (set256_initE _ _ (64 * g + 24)) 1,2:/# (set256_initE _ _ (64 * g + 16)) 1,2:/#.
rewrite (set256_initE _ _ (64 * g + 8)) 1,2:/# (set256_initE _ _ (64 * g)) 1,2:/#.
apply Array256.tP => t rgt; rewrite /merge Array256.initiE //=.
by rewrite !Array256.filliE //; smt(vec_bits).
qed.

(* ... or the column j of p' *)
lemma store_colE (p p' : wpoly) (j : int) : 0 <= j < 4 =>
  st (st (st (st (st (st (st (st p
    j (vec p' (8 * j))) (j + 4) (vec p' (8 * j + 32)))
    (j + 8) (vec p' (8 * j + 64))) (j + 12) (vec p' (8 * j + 96)))
    (j + 16) (vec p' (8 * j + 128))) (j + 20) (vec p' (8 * j + 160)))
    (j + 24) (vec p' (8 * j + 192))) (j + 28) (vec p' (8 * j + 224))
  = merge (fun t => t %/ 8 %% 4 = j) p p'.
proof.
move=> rgj.
rewrite (set256_initE _ _ (8 * j + 224)) 1,2:/# (set256_initE _ _ (8 * j + 192)) 1,2:/#.
rewrite (set256_initE _ _ (8 * j + 160)) 1,2:/# (set256_initE _ _ (8 * j + 128)) 1,2:/#.
rewrite (set256_initE _ _ (8 * j + 96)) 1,2:/# (set256_initE _ _ (8 * j + 64)) 1,2:/#.
rewrite (set256_initE _ _ (8 * j + 32)) 1,2:/# (set256_initE _ _ (8 * j)) 1,2:/#.
apply Array256.tP => t rgt; rewrite /merge Array256.initiE //=.
by rewrite !Array256.filliE //; smt(vec_bits).
qed.

(* the registers r0 .. r7 of a call: the block g of 64 coefficients ... *)
abbrev blk (p : wpoly) (g : int) (r0 r1 r2 r3 r4 r5 r6 r7 : W256.t) =
     r0 = vec p (64 * g +  0) /\ r1 = vec p (64 * g +  8)
  /\ r2 = vec p (64 * g + 16) /\ r3 = vec p (64 * g + 24)
  /\ r4 = vec p (64 * g + 32) /\ r5 = vec p (64 * g + 40)
  /\ r6 = vec p (64 * g + 48) /\ r7 = vec p (64 * g + 56).

(* ... or the column j of registers *)
abbrev col (p : wpoly) (j : int) (r0 r1 r2 r3 r4 r5 r6 r7 : W256.t) =
     r0 = vec p (8 * j +   0) /\ r1 = vec p (8 * j +  32)
  /\ r2 = vec p (8 * j +  64) /\ r3 = vec p (8 * j +  96)
  /\ r4 = vec p (8 * j + 128) /\ r5 = vec p (8 * j + 160)
  /\ r6 = vec p (8 * j + 192) /\ r7 = vec p (8 * j + 224).

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

lemma levels_frame (p p' : wpoly) (lo hi : int) (P : int -> bool) :
     0 <= lo => hi <= 8
  => (forall k, lo <= k < hi => closed k P)
  => agree P p p' => agree P (levels p lo hi) (levels p' lo hi).
proof.
move=> ge0lo le8 hcl hag; rewrite /levels.
have : forall k, k \in range lo hi => 0 <= k < 8 /\ closed k P.
- by move=> k /mem_range rgk; split; [smt() | apply hcl].
elim: (range lo hi) => //= k ks ih hks.
have [? ?] := hks k _ => //; apply reduce_level_frame => //.
by apply ih => k' hk'; apply hks; right.
qed.

(* the coefficients of a block of 64, closed by the levels 0 to 4 ... *)
lemma closed_blk (g k : int) : 0 <= k < 5 => closed k (fun t => t %/ 64 = g).
proof.
move=> rgk; have : k = 0 \/ k = 1 \/ k = 2 \/ k = 3 \/ k = 4 by smt().
by case=> [->|[->|[->|[->|->]]]]; rewrite /closed /=; split => u rgu hu ?; smt().
qed.

(* ... and those of a column of registers, by the levels 5 to 7 *)
lemma closed_col (j k : int) : 5 <= k < 8 => closed k (fun t => t %/ 8 %% 4 = j).
proof.
move=> rgk; have : k = 5 \/ k = 6 \/ k = 7 by smt().
by case=> [->|[->|->]]; rewrite /closed /=; split => u rgu hu ?; smt().
qed.

(* the calls of a loop: the i-th call applies F to the coefficients of
   class i (C t = i) of the polynomial, F being local on each class *)
lemma merge_step (C : int -> int) (F : wpoly -> wpoly) (p : wpoly) (i : int) :
     (forall p', agree (fun t => C t = i) p' p => agree (fun t => C t = i) (F p') (F p))
  => merge (fun t => C t = i) (merge (fun t => C t < i) p (F p))
       (F (merge (fun t => C t < i) p (F p)))
     = merge (fun t => C t < i + 1) p (F p).
proof.
move=> hF; apply Array256.tP => t rgt; rewrite /merge !initiE //=.
case: (C t = i) => hi; last by rewrite initiE //= /#.
rewrite ifT 1:/#; apply (hF _ _ t _ hi) => // u rgu /= hu.
by rewrite initiE //= ifF 1:/#.
qed.

(* ==================================================================== *)
(* The inverse levels, coefficient by coefficient                       *)
(* ==================================================================== *)
(* the twiddle of block j of inverse level k *)
op izj (k j : int) : W32.t = tw32 (izv k j).

lemma izjE (k j : int) : 0 <= k < 8 => 0 <= j < 2^(7-k) =>
  nth witness (izetasL k) j = izj k j.
proof. by move=> rgk rgj; rewrite izetasLE // /izetaW nth_mkseq. qed.

lemma ireduce_level_pt (p : wpoly) (k j t x : int) :
  0 <= k < 8 => 0 <= j < 2^(7-k) => 0 <= t < 2^(k+1) => x = j * 2^(k+1) + t =>
  (ireduce_level p k).[x] =
    if t < 2^k
    then p.[x] + p.[x + 2^k]
    else mmr (p.[x] - p.[x - 2^k]) (izj k j).
proof.
move=> rgk rgj rgt ->; have eSk : 2^(k+1) = 2 * 2^k by rewrite exprS 1:/#.
case: (t < 2^k) => ht.
- have [-> _] := ireduce_leveliE p k j t rgk rgj _; 1: smt().
  by rewrite addzAC.
have [_ /=] := ireduce_leveliE p k j (t - 2^k) rgk rgj _; 1: smt().
have -> : j * 2 ^ (k + 1) + 2 ^ k + (t - 2 ^ k) = j * 2 ^ (k + 1) + t by ring.
have -> : j * 2 ^ (k + 1) + (t - 2 ^ k) = j * 2 ^ (k + 1) + t - 2^k by ring.
by move=> ->.
qed.

lemma ivec_lo (p : wpoly) (k j r o : int) :
  0 <= k < 8 => 0 <= j < 2^(7-k) => 0 <= r => r + 8 <= 2^k => o = j * 2^(k+1) + r =>
  vec (ireduce_level p k) o =
    W8u32.pack8 (mkseq (fun l => p.[o + l] + p.[o + 2^k + l]) 8).
proof.
move=> rgk rgj ge0r hr ->; have eSk : 2^(k+1) = 2 * 2^k by rewrite exprS 1:/#.
rewrite /vec &(congr1 W8u32.pack8) &(eq_in_mkseq) => l rgl /=.
rewrite (ireduce_level_pt p k j (r + l)) 1,2:// 1,2:/# ifT 1:/#.
by do 2! congr; ring.
qed.

lemma ivec_hi (p : wpoly) (k j r o : int) :
  0 <= k < 8 => 0 <= j < 2^(7-k) => 0 <= r => r + 8 <= 2^k => o = j * 2^(k+1) + r =>
  vec (ireduce_level p k) (o + 2^k) =
    W8u32.pack8 (mkseq (fun l => mmr (p.[o + 2^k + l] - p.[o + l]) (izj k j)) 8).
proof.
move=> rgk rgj ge0r hr ->; have eSk : 2^(k+1) = 2 * 2^k by rewrite exprS 1:/#.
rewrite /vec &(congr1 W8u32.pack8) &(eq_in_mkseq) => l rgl /=.
rewrite (ireduce_level_pt p k j (2^k + r + l)) 1,2:// 1,2:/# ifF 1:/#.
by do 4! congr; ring.
qed.

lemma ivec_small (p : wpoly) (k jb o : int) :
  0 <= k < 3 => 0 <= jb => o = jb * 2^(k+1) => o + 8 <= 256 =>
  vec (ireduce_level p k) o =
    W8u32.pack8 (mkseq (fun l =>
      let j = jb + l %/ 2^(k+1) in
      if l %% 2^(k+1) < 2^k
      then p.[o + (l + 2^k)] + p.[o + l]
      else mmr (p.[o + l] - p.[o + (l - 2^k)]) (izj k j)) 8).
proof.
move=> rgk ge0jb oE ho; have eSk : 2^(k+1) = 2 * 2^k by rewrite exprS 1:/#.
have e256 : 2^(7-k) * 2^(k+1) = 256.
- by rewrite -exprD_nneg 1,2:/# (: 7 - k + (k+1) = 8) 1:/#.
have gt0m : 0 < 2^(k+1) by apply IntOrder.expr_gt0.
rewrite /vec &(congr1 W8u32.pack8) &(eq_in_mkseq) => l rgl /=.
rewrite (ireduce_level_pt p k (jb + l %/ 2^(k+1)) (l %% 2^(k+1))) 1://; last 3 first.
- by apply modz_cmp.
- by rewrite oE mulzDl {1}(divz_eq l (2^(k+1))); ring.
- by rewrite !addzA W32.WRingA.addrC.
- smt().
split; 1: smt(divz_ge0).
move=> _; rewrite -(IntOrder.ltr_pmul2r (2^(k+1))) // e256 mulzDl -oE.
smt(lez_floor).
qed.

(* the final scaling *)
lemma vec_iscale (p : wpoly) (o : int) : 0 <= o => o + 8 <= 256 =>
  vec (iscale p) o = W8u32.pack8 (mkseq (fun l => mmr p.[o + l] (W32.of_int 41978)) 8).
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
