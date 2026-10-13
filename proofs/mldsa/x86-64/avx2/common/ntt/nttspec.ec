(**
  This theory formalizes the machine-level specification of the NTT as it is
  implemented in the target architecture.

  In contrast to the high-level algebraic specification, this file makes the
  implementation structure explicit.  It models the concrete data
  representation, the sequencing of arithmetic operations, and the use of
  low-level techniques such as Montgomery reduction for modular
  multiplication.

  The specification captures the exact computational behavior of the
  implementation, including the operational details required for efficient
  execution on the underlying hardware.

  This machine-level model is intended to be linked upward to the clean
  algebraic specification, enabling a correctness proof that connects the
  concrete implementation to its mathematical meaning.
*)

(* ==================================================================== *)
require import AllCore CoreUtils List IntDiv BitEncoding.
(*---*) import BS2Int.

(* -------------------------------------------------------------------- *)
require import ListExtra Nttlogspec.

(* -------------------------------------------------------------------- *)
from Jasmin require import JUtils JWord.

(* -------------------------------------------------------------------- *)
require import Array256 XArray256.

(* -------------------------------------------------------------------- *)
require import Listred.

(* -------------------------------------------------------------------- *)
type wpoly = W32.t Array256.t.

(* -------------------------------------------------------------------- *)
(* FIXME: Should be defined in a generic way                            *)
op ( \sx ) (w1 w2 : W32.t) =
  W64.( * ) (W2u32.sigextu64 w1) (W2u32.sigextu64 w2).

(* ==================================================================== *)
op mmr (u w : W32.t) =
  let a = u \sx w in
  let t = W2u32.truncateu32 (a * W64.of_int 58728449) in
  let t = t \sx W32.of_int 8380417 in
  W2u32.truncateu32 ((a - t) `>>>` 32).

(* -------------------------------------------------------------------- *)
op mmr_alt (u w : W32.t) =
  let a = u \sx w in
  let t = W2u32.truncateu32 (a * W64.of_int 58728449) in
  let t = t \sx W32.of_int 8380417 in
  (W2u32.truncateu32 (a `>>>` 32)) - (W2u32.truncateu32 (t `>>>` 32)).

(* -------------------------------------------------------------------- *)
(* no borrow: when a and t agree on their low words, the high word of   *)
(* a - t is the difference of the high words                            *)
lemma high32_sub (a t : W64.t) :
  W64.to_uint a %% 2^32 = W64.to_uint t %% 2^32 =>
  W2u32.truncateu32 ((a - t) `>>>` 32)
  = W2u32.truncateu32 (a `>>>` 32) - W2u32.truncateu32 (t `>>>` 32).
proof.
move=> hlow; apply W32.to_uint_eq.
rewrite W32.to_uintD W32.to_uintN !W2u32.to_uint_truncateu32 !W64.to_uint_shr //.
rewrite W64.to_uintD W64.to_uintN /= modzDmr.
have -> : to_uint a - to_uint t = (to_uint a %/ 4294967296 - to_uint t %/ 4294967296) * 4294967296.
+ have := divz_eq (to_uint a) 4294967296; have := divz_eq (to_uint t) 4294967296.
  by move: hlow; rewrite (_ : W32.modulus = 4294967296) 1://; smt().
rewrite (_ : 18446744073709551616 = 4294967296 * 4294967296) 1:// -mulz_modl // mulzK // modz_mod.
by rewrite modzDmr modzDml -(modzDmr _ (- (to_uint t %/ 4294967296 %% 4294967296))) modzNm modzDmr.
qed.

(* the Montgomery multiplier t agrees with the product a on the low     *)
(* word (q * qinv = 1 mod 2^32), so the subtraction may be done on the  *)
(* high words                                                           *)
lemma mmr_altE : mmr_alt = mmr.
proof.
apply/fun_ext2 => u w; rewrite /mmr_alt /mmr /= high32_sub //.
pose t := W2u32.truncateu32 ((u \sx w) * W64.of_int 58728449).
have hA : W64.to_uint (u \sx w) = (W32.to_sint u * W32.to_sint w) %% W64.modulus.
- by rewrite /(\sx) W64.to_uintM /sigextu64 !W64.of_uintK modzMml modzMmr.
have hT : W64.to_uint (t \sx W32.of_int 8380417) = (W32.to_sint t * 8380417) %% W64.modulus.
- rewrite /(\sx) W64.to_uintM /sigextu64 !W64.of_uintK modzMml modzMmr.
  have -> // : W32.to_sint (W32.of_int 8380417) = 8380417 by rewrite W32.to_sintK_small.
have ht : W32.to_sint t %% 2^32 = (W32.to_sint u * W32.to_sint w * 58728449) %% 2^32.
- rewrite /t W32.to_sintE /W32.smod /= W2u32.to_uint_truncateu32 W64.to_uintM hA W64.of_uintK.
  rewrite modzMml modzMmr (: W64.modulus = 2^64) 1:// (: W32.modulus = 2^32) 1:// modz_dvd_pow 1://.
  by case (2147483648 <= (W32.to_sint u * W32.to_sint w * 58728449) %% 2^32) => _; smt().
rewrite hA hT (: JModel_x86.ptr_modulus = 2^64) 1:// (: W32.modulus = 2^32) 1:// !modz_dvd_pow 1,2://.
rewrite -(modzMml (to_sint t)) ht modzMml.
rewrite (_ : to_sint u * to_sint w * 58728449 * 8380417 = to_sint u * to_sint w * (58728449 * 8380417)) 1:#ring.
by rewrite -(modzMmr _ (58728449 * 8380417)) (: W32.modulus = 2^32) 1:// /=.
qed.

(* ==================================================================== *)
op reduce_coeff (p : wpoly) (base len plen : int) (z_ : W32.t) =
  let p1 = mkseq (fun i => p.[base       + i]) plen in
  let p2 = mkseq (fun i => p.[base + len + i]) plen in
  let r1 = map (fun (w : _ * _) => w.`1 + mmr w.`2 z_) (zip p1 p2) in
  let r2 = map (fun (w : _ * _) => w.`1 - mmr w.`2 z_) (zip p1 p2) in
  (r1, r2).

(* -------------------------------------------------------------------- *)
op reduce_coeff_flatten (p : wpoly) (base len : int) (z_ : W32.t) =
  let r = reduce_coeff p base len len z_ in
  r.`1 ++ r.`2.

(* -------------------------------------------------------------------- *)
op reduce_partial (p : wpoly) (base len plen : int) (z_ : W32.t) : wpoly =
  let r = reduce_coeff p base len plen z_ in
  let p = replace_ p base r.`1 in
  let p = replace_ p (base + len) r.`2 in
  p.

(* ==================================================================== *)
lemma reduce_coeffLE (p : wpoly) (base len plen : int) (z_ : W32.t) :
  (reduce_coeff p base len plen z_).`1 =
    mkseq (fun i => p.[base + i] + mmr p.[base + len + i] z_) plen.
proof.
rewrite /reduce_coeff /= zip_map /= -map_comp /(\o) /=.
by rewrite zipss -map_comp /(\o) /= -/(range 0 plen).
qed.

(* -------------------------------------------------------------------- *)
lemma reduce_coeffRE (p : wpoly) (base len plen : int) (z_ : W32.t) :
  (reduce_coeff p base len plen z_).`2 =
    mkseq (fun i => p.[base + i] - mmr p.[base + len + i] z_) plen.
proof.
rewrite /reduce_coeff /= zip_map /= -map_comp /(\o) /=.
by rewrite zipss -map_comp /(\o) /= -/(range 0 plen).
qed.

(* -------------------------------------------------------------------- *)
lemma reduce_coeff_sizeL (p : wpoly) (base len plen : int) (z_ : W32.t) :
  0 <= plen => size (reduce_coeff p base len plen z_).`1 = plen.
proof.
by move=> ? @/reduce_coeff /=; rewrite size_map size_zip !size_mkseq /#.
qed.

(* -------------------------------------------------------------------- *)
lemma reduce_coeff_sizeR (p : wpoly) (base len plen : int) (z_ : W32.t) :
  0 <= plen => size (reduce_coeff p base len plen z_).`2 = plen.
proof.
by move=> ? @/reduce_coeff /=; rewrite size_map size_zip !size_mkseq /#.
qed.

(* -------------------------------------------------------------------- *)
lemma reduce_coeff_flatten_size (p : wpoly) (base len : int) (z_ : W32.t) :
  0 <= len => size (reduce_coeff_flatten p base len z_) = 2 * len.
proof.
move=> ?; rewrite /reduce_coeff_flatten /= size_cat.
by rewrite !(reduce_coeff_sizeL, reduce_coeff_sizeR) //#.
qed.

(* -------------------------------------------------------------------- *)
lemma reduce_coeff_size (p : wpoly) (base len plen : int) (z_ : W32.t) (r s : _) :
     0 <= plen
  => reduce_coeff p base len plen z_ = (r, s)
  => size r = plen /\ size s = plen.
proof.
move=> ? ^ /(congr1 fst) /= <- /(congr1 snd) /= <-.
by rewrite !(reduce_coeff_sizeL, reduce_coeff_sizeR).
qed.

(* -------------------------------------------------------------------- *)
lemma reduce_coeff_eqon (p q : wpoly) (base len plen : int) (z_ : W32.t) :
     eqon p q (base      ) plen
  => eqon p q (base + len) plen
  => reduce_coeff p base len plen z_ = reduce_coeff q base len plen z_.
proof.
move=> eq1 eq2 @/reduce_coeff /=.
pose s1 := mkseq _ _; pose s2 := mkseq _ _.
pose r1 := mkseq _ _; pose r2 := mkseq _ _.
have [#] 2-> //: s1 = r1 /\ s2 = r2; split; apply: eq_in_mkseq => /=.
- by move=> i *; apply/eq1 => /#.
- by move=> i *; apply/eq2 => /#.
qed.

(* -------------------------------------------------------------------- *)
lemma reduce_coeff0 (p : wpoly) (base len : int) (z : W32.t) :
  reduce_coeff p base len 0 z = ([], []).
proof. by rewrite /reduce_coeff /= !mkseq0. qed.

hint simplify reduce_coeff0.

(* -------------------------------------------------------------------- *)
lemma reduce_coeffD (p : wpoly) (base len plen1 plen2 : int) (z : W32.t) :
     0 <= plen1
  => 0 <= plen2
  =>   reduce_coeff p base len (plen1 + plen2) z
     = pairxmap (++)
         (reduce_coeff p (base        ) len plen1 z)
         (reduce_coeff p (base + plen1) len plen2 z).
proof.
move=> *; rewrite /reduce_coeff /= !mkseq_add ~-1:// /=.
by rewrite !zip_cat ?size_mkseq ~-1:// !map_cat /=; smt().
qed.

(* -------------------------------------------------------------------- *)
lemma reduce_partial0 (p : wpoly) (base len : int) (z_ : W32.t) :
  reduce_partial p base len 0 z_ = p.
proof. done. qed.

(* -------------------------------------------------------------------- *)
lemma eqexcept_reduce_partial (p : wpoly) (base len plen : int) (z_ : W32.t) :
  0 <= plen =>

  forall i,
       !(base       <= i < base       + plen)
    => !(base + len <= i < base + len + plen)
    => (reduce_partial p base len plen z_).[i] = p.[i].
proof.
move=> ? i * @/reduce_partial /=.
case _: (reduce_coeff p base len plen z_) => r s E /=.
have [??] := reduce_coeff_size _ _ _ _ _ _ _ // E.
by rewrite !replace_eqexcept //#.
qed.

(* -------------------------------------------------------------------- *)
lemma reduce_partialD (p : wpoly) (base len plen1 plen2) (z_ : W32.t) :
     0 <= plen1
  => 0 <= plen2
  => plen1 + plen2 <= len
  =>   reduce_partial p base len (plen1 + plen2) z_
     = reduce_partial (reduce_partial p base len plen1 z_) (base + plen1) len plen2 z_.
proof.
move=> *; rewrite {1}/reduce_partial /= reduce_coeffD ~-1://.
case _: (reduce_coeff p _ _ plen1 _) => x1 y1 E1 /=.
case _: (reduce_coeff p _ _ plen2 _) => x2 y2 E2 /=.
have [??] := reduce_coeff_size _ _ _ _ _ _ _ // E1.
have [??] := reduce_coeff_size _ _ _ _ _ _ _ // E2.
rewrite !replace_cat -[replace_ _ (base + len) y1]replace_swap 1:/#.
(pose rp := reduce_partial p _ _ _ _) => @/reduce_partial.
rewrite (_ : reduce_coeff rp _ _ _ _ = (x2, y2)).
- rewrite -E2 &(reduce_coeff_eqon) /rp.
  - by move=> i ?; rewrite eqexcept_reduce_partial //#.
  - by move=> i ?; rewrite eqexcept_reduce_partial //#.
by rewrite /= /rp /reduce_partial E1 /#.
qed.

(* -------------------------------------------------------------------- *)
lemma reduce_partial_swap (p : wpoly) (b1 b2 l1 l2 pl1 pl2) (z1 z2 : W32.t) :
     0 <= pl1
  => 0 <= pl2
  => (forall i,
          !(b1 <= i < b1 + pl1 \/ b1 + l1 <= i < b1 + l1 + pl1)
       \/ !(b2 <= i < b2 + pl2 \/ b2 + l2 <= i < b2 + l2 + pl2))
  =>  
    reduce_partial (reduce_partial p b1 l1 pl1 z1) b2 l2 pl2 z2
  = reduce_partial (reduce_partial p b2 l2 pl2 z2) b1 l1 pl1 z1.
proof.
move=> + + indep.
move/lez_eqVlt => -[<<-|?]; first by rewrite !reduce_partial0.
move/lez_eqVlt => -[<<-|?]; first by rewrite !reduce_partial0.
rewrite {1}/reduce_partial;
  (pose r1 := reduce_coeff _ _ _ _ _) => /=; apply/eq_sym.
rewrite {1}/reduce_partial;
  (pose r2 := reduce_coeff _ _ _ _ _) => /=; apply/eq_sym.
have -> {r1}: r1 = reduce_coeff p b2 l2 pl2 z2.
- apply: reduce_coeff_eqon => /= i rgi; move/(_ i): indep => ?.
  - smt(eqexcept_reduce_partial).
  - smt(eqexcept_reduce_partial).
have -> {r2}: r2 = reduce_coeff p b1 l1 pl1 z1.
- apply: reduce_coeff_eqon => /= i rgi; move/(_ i): indep => ?.
  - smt(eqexcept_reduce_partial).
  - smt(eqexcept_reduce_partial).
pose r1 := reduce_coeff p b1 l1 pl1 z1.
pose r2 := reduce_coeff p b2 l2 pl2 z2.
rewrite /reduce_partial /= -/r1 -/r2.
rewrite !(replaceC _ _ _ r2.`1).
- by rewrite !(reduce_coeff_sizeL, reduce_coeff_sizeR) /#.
- by rewrite !(reduce_coeff_sizeL, reduce_coeff_sizeR) /#.
rewrite 2?(replaceC _ _ _ r2.`2).
- by rewrite !(reduce_coeff_sizeL, reduce_coeff_sizeR) /#.
- by rewrite !(reduce_coeff_sizeL, reduce_coeff_sizeR) /#.
done.
qed.

(* -------------------------------------------------------------------- *)
op [opaque] reduce (p : wpoly) (base len : int) (z_ : W32.t) : wpoly =
  replace_ p base (reduce_coeff_flatten p base len z_).

(* -------------------------------------------------------------------- *)
lemma reduce_as_partial (p : wpoly) (base len : int) (z_ : W32.t) :
  0 <= len => reduce p base len z_ = reduce_partial p base len len z_.
proof.
move=> *; rewrite /reduce /reduce_coeff_flatten /reduce_partial /=.
pose r := reduce_coeff _ _ _ _ _; rewrite replace_cat.
by rewrite reduce_coeff_sizeL //#.
qed.

(* -------------------------------------------------------------------- *)
op reduce_n (p : wpoly) (base len : int) (zs : W32.t list) =
  foldl
    (fun p i => reduce p (base + i * 2 * len) len (nth witness zs i))
    p (range 0 (size zs)).

(* -------------------------------------------------------------------- *)
op reduce_level (p : wpoly) (i : int) =
  reduce_n p 0 (2^i) (map W32.of_int (zetaL i)).

(* -------------------------------------------------------------------- *)
op reduce_tree (p : wpoly) (i : int) =
  foldr (fun i p => reduce_level p i) p (range i 8).

(* -------------------------------------------------------------------- *)
lemma reduce_0 (p : wpoly) (base len : int) :
  reduce_n p base len [] = p.
proof. by rewrite /reduce_n /= range_geq. qed.

(* -------------------------------------------------------------------- *)
lemma reduce_seq1 (p : wpoly) (base len : int) (z : W32.t) :
  reduce_n p base len [z] = reduce p base len z.
proof. by rewrite /reduce_n /= (rangeS 0). qed.

(* -------------------------------------------------------------------- *)
lemma reduce_seq2 (p : wpoly) (base len : int) (z1 z2 : W32.t) :
    reduce_n p base len [z1; z2]
  = reduce (reduce p base len z1) (base + 2 * len) len z2.
proof. by rewrite /reduce_n /range /= -iotaredE. qed.

(* -------------------------------------------------------------------- *)
lemma reduce_n_cat (p : wpoly) (base len : int) (zs1 zs2 : W32.t list) :
    reduce_n p base len (zs1 ++ zs2)
  = reduce_n (reduce_n p base len zs1) (base + 2 * len * size zs1) len zs2.
proof.
rewrite {1}/reduce_n size_cat (range_cat (size zs1)) ~-1:#smt:(size_ge0).
rewrite (range_addl 0 _ (size zs1)) addrAC /= foldl_cat.
rewrite foldl_map &(eq_in_foldl) //=; last first.
- by apply/eq_in_foldl=> //= w i /mem_range rgi; smt(nth_cat).
- by move=> w i /mem_range rgi; smt(nth_cat).
qed.

(* -------------------------------------------------------------------- *)
lemma reduce_rcons (p : wpoly) (base len : int) (zs : W32.t list) (z : W32.t) :
    reduce_n p base len (rcons zs z)
  = reduce (reduce_n p base len zs) (base + 2 * len * size zs) len z.
proof. by rewrite -cats1 reduce_n_cat reduce_seq1. qed.

(* -------------------------------------------------------------------- *)
lemma reduce_nE (p : wpoly) (base len : int) (zs : W32.t list) : 0 <= len =>
    reduce_n p base len zs
  = replace_ p base (flatten (
      mkseq
      (fun i => reduce_coeff_flatten p (base + 2 * i * len) len (nth witness zs i))
      (size zs))).
proof.
move=> ?; elim: zs p base => /= [|z zs ih] p base.
- by rewrite reduce_0 mkseq0.
rewrite -cat1s reduce_n_cat reduce_seq1.
rewrite [1+_]addzC mkseqSr 1:size_ge0 /(\o) /=.
rewrite flatten_cons replace_cat -/(reduce _ _ _ _).
rewrite reduce_coeff_flatten_size // ih; do 2! congr.
apply: eq_in_mkseq=> i rgi /=; rewrite ifF 1:/#.
rewrite mulrDr /= mulrDl addrA /reduce_coeff_flatten.
pose r1 := reduce_coeff _ _ _ _ _.
pose r2 := reduce_coeff _ _ _ _ _.
suff ->: r1 = r2 by done.
rewrite &(reduce_coeff_eqon) reduce_as_partial //.
- smt(eqexcept_reduce_partial).
- smt(eqexcept_reduce_partial).
qed.

(* -------------------------------------------------------------------- *)
lemma reduce_tree_step (p : wpoly) (n : int) : n < 8 =>
  reduce_tree p n = reduce_level (reduce_tree p (n + 1)) n.
proof. by move=> ?; rewrite {1}/reduce_tree (range_ltn) 1:// /=. qed.

(* -------------------------------------------------------------------- *)
type player = {
  base   : int;
  stepby : int;
  twdf   : int;
}.

(* -------------------------------------------------------------------- *)
op reduce_player (p : wpoly) (pl : player) =
  reduce_partial p (8 * pl.`base) (64 * pl.`stepby) 32 (W32.of_int pl.`twdf).

(* -------------------------------------------------------------------- *)
op reduce_players (p : wpoly) (pls : player list) =
  foldl reduce_player p pls.

(* -------------------------------------------------------------------- *)
op [opaque] iswap (i j : int) =
  fun k => if k = i then j else if k = j then i else k.

(* -------------------------------------------------------------------- *)
lemma iswapL (i j : int) : iswap i j i = j.
proof. by smt(). qed.

hint simplify iswapL.

(* -------------------------------------------------------------------- *)
lemma iswapR (i j : int) : iswap i j j = i.
proof. by smt(). qed.

hint simplify iswapR.

(* -------------------------------------------------------------------- *)
lemma iswap_id (i j k : int) : k <> i => k <> j => iswap i j k = k.
proof. by smt(). qed.

(* -------------------------------------------------------------------- *)
op lswap ['a] (i j : int) (s : 'a list) =
  mkseq (fun k => nth witness s (iswap i j k)) (size s).

(* -------------------------------------------------------------------- *)
lemma size_lswap ['a] (i j : int) (s : 'a list) :
  size (lswap i j s) = size s.
proof. by rewrite /lswap size_mkseq #smt:(size_ge0). qed.

(* -------------------------------------------------------------------- *)
lemma nth_lswapL ['a] (x0 : 'a) (i j : int) (s : 'a list) :
  0 <= i < size s => nth x0 (lswap i j s) i = nth witness s j.
proof. by move=> ?; rewrite /lswap nth_mkseq. qed.

(* -------------------------------------------------------------------- *)
lemma nth_lswapR ['a] (x0 : 'a) (i j : int) (s : 'a list) :
  0 <= j < size s => nth x0 (lswap i j s) j = nth witness s i.
proof. by move=> ?; rewrite /lswap nth_mkseq. qed.

(* -------------------------------------------------------------------- *)
lemma nth_lswap_id ['a] (x0 : 'a) (i j k : int) (s : 'a list) :
     k <> i
  => k <> j
  => 0 <= k < size s
  => nth x0 (lswap i j s) k = nth x0 s k.
proof.
move=> *; rewrite /lswap nth_mkseq //= iswap_id //.
by apply: nth_change_dfl. 
qed.

(* -------------------------------------------------------------------- *)
lemma lswapE ['a] (x0 : 'a) (i : int) (s : 'a list) : 0 < i < size s =>
  lswap i (i - 1) s =
    take (i - 1) s ++ nth x0 s i :: nth x0 s (i - 1) :: drop (i + 1) s.
proof.
move=> ?; rewrite -[lswap _ _ _](cat_take_drop (i - 1)); congr.
- rewrite !(take_mkseqE x0) ?size_lswap ~-1:/#.
  by apply: eq_in_mkseq=> j ? /=; rewrite nth_lswap_id //#.
rewrite (drop_nth x0) ?size_lswap 1:/# nth_lswapR 1:/# /=.
split; first by apply: nth_change_dfl => //#.
rewrite (drop_nth x0) ?size_lswap 1:/# nth_lswapL 1:/# /=.
split; first by apply: nth_change_dfl => //#.
rewrite !(drop_mkseqE x0) ?size_lswap ~-1:/#.
by apply: eq_in_mkseq => j ? /=; rewrite nth_lswap_id //#.
qed.

(* -------------------------------------------------------------------- *)
op indep_range (r1 r2 : int * int) =
  r1.`1 + r1.`2 <= r2.`1 \/ r2.`1 + r2.`2 <= r1.`1.

(* -------------------------------------------------------------------- *)
op ranges_of_player (pl : player) =
  [(8 * pl.`base, 32); (8 * pl.`base + 64 * pl.`stepby, 32)].

(* -------------------------------------------------------------------- *)
op plindep (pl1 pl2 : player) =
  all (fun r1 =>
    all (fun r2 => indep_range r1 r2) (ranges_of_player pl2)
  ) (ranges_of_player pl1).

(* -------------------------------------------------------------------- *)
lemma reduce_players_swap (i : int) (p : wpoly) (pls : player list) :
     0 < i < size pls
  => plindep (nth witness pls (i-1)) (nth witness pls i)
  => reduce_players p pls = reduce_players p (lswap i (i-1) pls).
proof.
pose pl1 := nth witness pls (i - 1); pose pl2 := nth witness pls i.
move=> ?; have {1}->: pls = take (i-1) pls ++ (pl1 :: pl2 :: drop (i+1) pls).
- rewrite -{1}[pls](cat_take_drop (i - 1)); congr.
  by rewrite 2?(drop_nth witness) //#.
rewrite /plindep /ranges_of_player /= => [#] *.
rewrite (lswapE witness) 1:/#.
pose s1 := take _ _; pose s2 := drop _ _.
rewrite /reduce_players !foldl_cat.
move: (foldl reduce_player p s1) => q /=.
congr; rewrite -/pl1 -/pl2 /reduce_player.
by rewrite reduce_partial_swap 1,2:// -1:// /#.
qed.

(* -------------------------------------------------------------------- *)
lemma reduce_players_cat (p : wpoly) (pls1 pls2 : player list) :
  reduce_players p (pls1 ++ pls2) =
    reduce_players (reduce_players p pls1) pls2.
proof. by rewrite /reduce_players foldl_cat. qed.

(* -------------------------------------------------------------------- *)
lemma reduce_players_merge (p : wpoly) (n base stepby twdf : int) :
     0 <= n
  => 32 * n <= 64 * stepby
  =>   reduce_partial p (8 * base) (64 * stepby) (32 * n) (W32.of_int twdf)
     = reduce_players p
         (mkseq (fun i => {| base = base + 4 * i; stepby = stepby; twdf = twdf; |}) n).
proof.
elim: n => [|n ge0_n ih] ? /=; first by rewrite reduce_partial0 mkseq0.
rewrite mulrDr /= reduce_partialD ~-1:/#.
rewrite mkseqS ~-1:// /= /reduce_players foldl_rcons.
by rewrite -/(reduce_players _ _) -ih /#.
qed.

(* ==================================================================== *)
(* ==================================================================== *)
(* Inverse (Gentleman-Sande) butterfly, mirror of Nttspec.reduce.       *)
(* Code (invert_ntt_round): with a = coeffs_i, b = coeffs_{i+len},      *)
(*   coeffs_i        <- a + b                                            *)
(*   coeffs_{i+len}  <- mmr (b - a) z                                    *)
(* ==================================================================== *)
op ireduce_coeff (p : wpoly) (base len plen : int) (z_ : W32.t) =
  let p1 = mkseq (fun i => p.[base       + i]) plen in
  let p2 = mkseq (fun i => p.[base + len + i]) plen in
  let r1 = map (fun (w : W32.t * W32.t) => w.`1 + w.`2)       (zip p1 p2) in
  let r2 = map (fun (w : W32.t * W32.t) => mmr (w.`2 - w.`1) z_) (zip p1 p2) in
  (r1, r2).

(* -------------------------------------------------------------------- *)
op ireduce_coeff_flatten (p : wpoly) (base len : int) (z_ : W32.t) =
  let r = ireduce_coeff p base len len z_ in
  r.`1 ++ r.`2.

(* -------------------------------------------------------------------- *)
op ireduce_partial (p : wpoly) (base len plen : int) (z_ : W32.t) : wpoly =
  let r = ireduce_coeff p base len plen z_ in
  let p = replace_ p base r.`1 in
  let p = replace_ p (base + len) r.`2 in
  p.

(* ==================================================================== *)
lemma ireduce_coeffLE (p : wpoly) (base len plen : int) (z_ : W32.t) :
  (ireduce_coeff p base len plen z_).`1 =
    mkseq (fun i => p.[base + i] + p.[base + len + i]) plen.
proof.
hint +listred.
rewrite /ireduce_coeff /= zip_map /= -map_comp /(\o) /=.
by rewrite zipss -map_comp /(\o) /= -/(range 0 plen).
qed.

(* -------------------------------------------------------------------- *)
lemma ireduce_coeffRE (p : wpoly) (base len plen : int) (z_ : W32.t) :
  (ireduce_coeff p base len plen z_).`2 =
    mkseq (fun i => mmr (p.[base + len + i] - p.[base + i]) z_) plen.
proof.
hint +listred.
rewrite /ireduce_coeff /= zip_map /= -map_comp /(\o) /=.
by rewrite zipss -map_comp /(\o) /= -/(range 0 plen).
qed.

(* -------------------------------------------------------------------- *)
lemma ireduce_coeff_sizeL (p : wpoly) (base len plen : int) (z_ : W32.t) :
  0 <= plen => size (ireduce_coeff p base len plen z_).`1 = plen.
proof.
hint +listred.
by move=> ? @/ireduce_coeff /=; rewrite size_zip !size_mkseq /#.
qed.

(* -------------------------------------------------------------------- *)
lemma ireduce_coeff_sizeR (p : wpoly) (base len plen : int) (z_ : W32.t) :
  0 <= plen => size (ireduce_coeff p base len plen z_).`2 = plen.
proof.
hint +listred.
by move=> ? @/ireduce_coeff /=; rewrite size_zip !size_mkseq /#.
qed.

(* -------------------------------------------------------------------- *)
lemma ireduce_coeff_flatten_size (p : wpoly) (base len : int) (z_ : W32.t) :
  0 <= len => size (ireduce_coeff_flatten p base len z_) = 2 * len.
proof.
hint +listred.
move=> ?; rewrite /ireduce_coeff_flatten /= size_cat.
by rewrite !(ireduce_coeff_sizeL, ireduce_coeff_sizeR) //#.
qed.

(* -------------------------------------------------------------------- *)
lemma ireduce_coeff_size (p : wpoly) (base len plen : int) (z_ : W32.t) (r s : _) :
     0 <= plen
  => ireduce_coeff p base len plen z_ = (r, s)
  => size r = plen /\ size s = plen.
proof.
hint +listred.
move=> ? ^ /(congr1 fst) /= <- /(congr1 snd) /= <-.
by rewrite !(ireduce_coeff_sizeL, ireduce_coeff_sizeR).
qed.

(* -------------------------------------------------------------------- *)
lemma ireduce_coeff_eqon (p q : wpoly) (base len plen : int) (z_ : W32.t) :
     eqon p q (base      ) plen
  => eqon p q (base + len) plen
  => ireduce_coeff p base len plen z_ = ireduce_coeff q base len plen z_.
proof.
hint +listred.
move=> eq1 eq2 @/ireduce_coeff /=.
pose s1 := mkseq _ _; pose s2 := mkseq _ _.
pose r1 := mkseq _ _; pose r2 := mkseq _ _.
have [#] 2-> //: s1 = r1 /\ s2 = r2; split; apply: eq_in_mkseq => /=.
- by move=> i *; apply/eq1 => /#.
- by move=> i *; apply/eq2 => /#.
qed.

(* -------------------------------------------------------------------- *)
lemma ireduce_coeff0 (p : wpoly) (base len : int) (z : W32.t) :
  ireduce_coeff p base len 0 z = ([], []).
proof. hint +listred. by rewrite /ireduce_coeff /=. qed.

hint simplify ireduce_coeff0.

(* -------------------------------------------------------------------- *)
lemma ireduce_coeffD (p : wpoly) (base len plen1 plen2 : int) (z : W32.t) :
     0 <= plen1
  => 0 <= plen2
  =>   ireduce_coeff p base len (plen1 + plen2) z
     = pairxmap (++)
         (ireduce_coeff p (base        ) len plen1 z)
         (ireduce_coeff p (base + plen1) len plen2 z).
proof.
hint +listred.
move=> *; rewrite /ireduce_coeff /= !mkseq_add ~-1:// /=.
by rewrite !zip_cat ?size_mkseq ~-1:// !map_cat /=; smt().
qed.

(* -------------------------------------------------------------------- *)
lemma ireduce_partial0 (p : wpoly) (base len : int) (z_ : W32.t) :
  ireduce_partial p base len 0 z_ = p.
proof. hint +listred. done. qed.

(* -------------------------------------------------------------------- *)
lemma eqexcept_ireduce_partial (p : wpoly) (base len plen : int) (z_ : W32.t) :
  0 <= plen =>

  forall i,
       !(base       <= i < base       + plen)
    => !(base + len <= i < base + len + plen)
    => (ireduce_partial p base len plen z_).[i] = p.[i].
proof.
hint +listred.
move=> ? i * @/ireduce_partial /=.
case _: (ireduce_coeff p base len plen z_) => r s E /=.
have [??] := ireduce_coeff_size _ _ _ _ _ _ _ // E.
by rewrite !replace_eqexcept //#.
qed.

(* -------------------------------------------------------------------- *)
lemma ireduce_partialD (p : wpoly) (base len plen1 plen2) (z_ : W32.t) :
     0 <= plen1
  => 0 <= plen2
  => plen1 + plen2 <= len
  =>   ireduce_partial p base len (plen1 + plen2) z_
     = ireduce_partial (ireduce_partial p base len plen1 z_) (base + plen1) len plen2 z_.
proof.
hint +listred.
move=> *; rewrite {1}/ireduce_partial /= ireduce_coeffD ~-1://.
case _: (ireduce_coeff p _ _ plen1 _) => x1 y1 E1 /=.
case _: (ireduce_coeff p _ _ plen2 _) => x2 y2 E2 /=.
have [??] := ireduce_coeff_size _ _ _ _ _ _ _ // E1.
have [??] := ireduce_coeff_size _ _ _ _ _ _ _ // E2.
rewrite !replace_cat -[replace_ _ (base + len) y1]replace_swap 1:/#.
(pose rp := ireduce_partial p _ _ _ _) => @/ireduce_partial.
rewrite (_ : ireduce_coeff rp _ _ _ _ = (x2, y2)).
- rewrite -E2 &(ireduce_coeff_eqon) /rp.
  - by move=> i ?; rewrite eqexcept_ireduce_partial //#.
  - by move=> i ?; rewrite eqexcept_ireduce_partial //#.
by rewrite /= /rp /ireduce_partial E1 /#.
qed.

(* -------------------------------------------------------------------- *)
op [opaque] ireduce (p : wpoly) (base len : int) (z_ : W32.t) : wpoly =
  replace_ p base (ireduce_coeff_flatten p base len z_).

(* -------------------------------------------------------------------- *)
lemma ireduce_as_partial (p : wpoly) (base len : int) (z_ : W32.t) :
  0 <= len => ireduce p base len z_ = ireduce_partial p base len len z_.
proof.
hint +listred.
move=> *; rewrite /ireduce /ireduce_coeff_flatten /ireduce_partial /=.
pose r := ireduce_coeff _ _ _ _ _; rewrite replace_cat.
by rewrite ireduce_coeff_sizeL //#.
qed.

(* -------------------------------------------------------------------- *)
op ireduce_n (p : wpoly) (base len : int) (zs : W32.t list) =
  foldl
    (fun p i => ireduce p (base + i * 2 * len) len (nth witness zs i))
    p (range 0 (size zs)).

(* -------------------------------------------------------------------- *)
lemma ireduce_n0 (p : wpoly) (base len : int) :
  ireduce_n p base len [] = p.
proof. hint +listred. by rewrite /ireduce_n /=. qed.

(* -------------------------------------------------------------------- *)
lemma ireduce_seq1 (p : wpoly) (base len : int) (z : W32.t) :
  ireduce_n p base len [z] = ireduce p base len z.
proof. hint +listred. by rewrite /ireduce_n /=. qed.

(* -------------------------------------------------------------------- *)
lemma ireduce_n_cat (p : wpoly) (base len : int) (zs1 zs2 : W32.t list) :
    ireduce_n p base len (zs1 ++ zs2)
  = ireduce_n (ireduce_n p base len zs1) (base + 2 * len * size zs1) len zs2.
proof.
hint +listred.
rewrite {1}/ireduce_n size_cat (range_cat (size zs1)) ~-1:#smt:(size_ge0).
rewrite (range_addl 0 _ (size zs1)) addrAC /= foldl_cat.
rewrite foldl_map &(eq_in_foldl) //=; last first.
- by apply/eq_in_foldl=> //= w i /mem_range rgi; smt(nth_cat).
- by move=> w i /mem_range rgi; smt(nth_cat).
qed.

(* -------------------------------------------------------------------- *)
lemma ireduce_rcons (p : wpoly) (base len : int) (zs : W32.t list) (z : W32.t) :
    ireduce_n p base len (rcons zs z)
  = ireduce (ireduce_n p base len zs) (base + 2 * len * size zs) len z.
proof. hint +listred. by rewrite -cats1 ireduce_n_cat ireduce_seq1. qed.

(* ==================================================================== *)
(* ==================================================================== *)
lemma ireduce_nE (p : wpoly) (base len : int) (zs : W32.t list) : 0 <= len =>
    ireduce_n p base len zs
  = replace_ p base (flatten (
      mkseq
      (fun i => ireduce_coeff_flatten p (base + 2 * i * len) len (nth witness zs i))
      (size zs))).
proof.
hint +listred.
move=> ?; elim: zs p base => /= [|z zs ih] p base.
- by rewrite ireduce_n0.
rewrite -cat1s ireduce_n_cat ireduce_seq1.
rewrite [1+_]addzC mkseqSr 1:size_ge0 /(\o) /=.
rewrite replace_cat -/(ireduce _ _ _ _).
rewrite ireduce_coeff_flatten_size // ih; do 2! congr.
apply: eq_in_mkseq=> i rgi /=; rewrite ifF 1:/#.
rewrite mulrDr /= mulrDl addrA /ireduce_coeff_flatten.
pose r1 := ireduce_coeff _ _ _ _ _.
pose r2 := ireduce_coeff _ _ _ _ _.
suff ->: r1 = r2 by done.
rewrite &(ireduce_coeff_eqon) ireduce_as_partial //.
- smt(eqexcept_ireduce_partial).
- smt(eqexcept_ireduce_partial).
qed.

(* ==================================================================== *)
(* Final scaling: every coefficient is montgomery-multiplied by 41978   *)
(* (MONT^2/256 mod q), cf. the tail loop of invert_ntt_montgomery.      *)
(* ==================================================================== *)
op iscale (p : wpoly) : wpoly =
  Array256.map (fun (c : W32.t) => mmr c (W32.of_int 41978)) p.

(* Prefix-scaled polynomial: coefficients [0, n) already scaled.        *)
op iscale_partial (p : wpoly) (n : int) : wpoly =
  Array256.init
    (fun j => if j < n then mmr p.[j] (W32.of_int 41978) else p.[j]).

(* -------------------------------------------------------------------- *)
lemma iscale_partial0 (p : wpoly) : iscale_partial p 0 = p.
proof. hint +listred. by apply/Array256.ext_eq => x rgx; rewrite initiE //#. qed.

(* -------------------------------------------------------------------- *)
lemma iscale_partial_full (p : wpoly) : iscale_partial p 256 = iscale p.
proof.
hint +listred.
by apply/Array256.ext_eq => x rgx; rewrite initiE //= mapiE //= ifT //#.
qed.

(* -------------------------------------------------------------------- *)
lemma eqexcept_iscale_partial (p : wpoly) (n j : int) :
  n <= j => (iscale_partial p n).[j] = p.[j].
proof.
hint +listred.
move=> ?; case: (0 <= j < 256) => [rgj|?]; last by rewrite !get_out //#.
by rewrite initiE //= ifF //#.
qed.

(* -------------------------------------------------------------------- *)
lemma iscale_partialS (p : wpoly) (n : int) :
     0 <= n
  => n + 8 <= 256
  =>   iscale_partial p (n + 8)
     = replace_ (iscale_partial p n) n
         (mkseq (fun k => mmr p.[n + k] (W32.of_int 41978)) 8).
proof.
hint +listred.
move=> ge0n hle; apply/Array256.ext_eq => x rgx.
rewrite initiE //= /replace_ filliE //=.
case: (n <= x < n + 8) => hx; first by smt().
by rewrite initiE //= /#.
qed.

(* ==================================================================== *)
(* Pointwise (NTT-domain) multiplication: every coefficient of the      *)
(* product is the montgomery-multiplication of the matching             *)
(* coefficients, cf. pointwise_montgomery_multiply_and_reduce.          *)
(* ==================================================================== *)
op pwmul (a b : wpoly) : wpoly =
  Array256.init (fun j => mmr a.[j] b.[j]).

(* Prefix-multiplied polynomial: coefficients [0, n) already written,   *)
(* the rest still holding the destination's initial contents.           *)
op pwmul_partial (a b t : wpoly) (n : int) : wpoly =
  Array256.init (fun j => if j < n then mmr a.[j] b.[j] else t.[j]).

(* -------------------------------------------------------------------- *)
lemma pwmul_partial0 (a b t : wpoly) : pwmul_partial a b t 0 = t.
proof. hint +listred. by apply/Array256.ext_eq => x rgx; rewrite initiE //#. qed.

(* -------------------------------------------------------------------- *)
lemma pwmul_partial_full (a b t : wpoly) : pwmul_partial a b t 256 = pwmul a b.
proof.
hint +listred.
by apply/Array256.ext_eq => x rgx; rewrite !initiE //= ifT //#.
qed.

(* -------------------------------------------------------------------- *)
lemma eqexcept_pwmul_partial (a b t : wpoly) (n j : int) :
  n <= j => (pwmul_partial a b t n).[j] = t.[j].
proof.
hint +listred.
move=> ?; case: (0 <= j < 256) => [rgj|?]; last by rewrite !get_out //#.
by rewrite initiE //= ifF //#.
qed.

(* -------------------------------------------------------------------- *)
lemma pwmul_partialS (a b t : wpoly) (n : int) :
     0 <= n
  => n + 8 <= 256
  =>   pwmul_partial a b t (n + 8)
     = replace_ (pwmul_partial a b t n) n
         (mkseq (fun k => mmr a.[n + k] b.[n + k]) 8).
proof.
hint +listred.
move=> ge0n hle; apply/Array256.ext_eq => x rgx.
rewrite initiE //= /replace_ filliE //=.
case: (n <= x < n + 8) => hx; first by smt().
by rewrite initiE //= /#.
qed.
