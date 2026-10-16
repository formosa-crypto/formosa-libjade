(**
  The Cooley-Tukey tree of a negacyclic NTT on 256 machine words,
  generic in the modulus q, the root zeta, the leaf level s and the
  word arithmetic.

  The polynomial ring is Z_q[X]/(X^256 + 1).  Level k (s <= k <= 8)
  splits a polynomial into 2^(8-k) residues modulo X^(2^k) - zeta^e;
  level 8 is the polynomial itself (X^256 + 1 = X^256 - zeta^(2^(8-s))),
  level s holds the leaves.  The forward transform runs the levels
  7, 6, ..., s; each level is one Cooley-Tukey butterfly per pair of
  coefficients, with a Montgomery multiplication by a table entry.

  - The word level (`reduce`, `reduce_level`, `reduce_tree`) is the
    operator that the implementations compute, one per level.
  - The integer level (`nttsum`) is the closed-form coefficient sum of
    each residue, with no quotient construction: statements are
    congruences modulo q.
  - `reduce_tree_alg` links the two: after the levels 7 .. k, every
    coefficient is congruent to its residue sum, and bounded.

  Instances provide q, zeta (zeta^(2^(8-s)) = -1 mod q), the word type
  with its signed reading `sval` and no-overflow facts for addition and
  subtraction, and the Montgomery multiplication `mmr` against the
  twiddle encoding `tw_of` of an integer.
*)

(* ==================================================================== *)
require import AllCore CoreUtils List Ring IntDiv BitEncoding.
require import StdRing StdOrder StdBigop.
(*---*) import BS2Int IntOrder Bigint.

(* -------------------------------------------------------------------- *)
require import ListExtra.
from Jasmin require import JUtils.
from JazzEC require import Array256.
require import XArray256.
require import Listred.

(* ==================================================================== *)
abstract theory NttTreeT.

(* -------------------------------------------------------------------- *)
(* The modulus                                                          *)
op q : int.

axiom gt1_q : 1 < q.
axiom odd_q : 2 %| (q - 1).

lemma gt0_q : 0 < q.
proof. by have := gt1_q => /#. qed.

(* -------------------------------------------------------------------- *)
(* The leaf level and the root                                          *)
op s : int.

axiom rg_s : 0 <= s < 8.

op zeta_ : int.

axiom zeta_half : zeta_ ^ (2^(8-s)) %% q = (-1) %% q.

(* -------------------------------------------------------------------- *)
(* Machine words: signed reading, exact when no overflow                *)
type w.

op sval : w -> int.
op wmax : int.

op ( + ) : w -> w -> w.
op ( - ) : w -> w -> w.

axiom svalD (a b : w) :
  `|sval a + sval b| < wmax => sval (a + b) = sval a + sval b.

axiom svalB (a b : w) :
  `|sval a - sval b| < wmax => sval (a - b) = sval a - sval b.

(* -------------------------------------------------------------------- *)
(* Twiddles: the encoding of an integer factor, and the Montgomery      *)
(* multiplication against it                                            *)
type tw.

op tw_of : int -> tw.
op mmr : w -> tw -> w.

axiom mmr_cgr (u : w) (x : int) :
  sval (mmr u (tw_of x)) %% q = (sval u * x) %% q.

axiom mmr_bnd (u : w) (x : int) :
  `|sval (mmr u (tw_of x))| < q.

(* -------------------------------------------------------------------- *)
(* The difference of the inverse butterfly, in the order of the code:  *)
(* isub a b reads isgn * (b - a)                                        *)
op isub : w -> w -> w.
op isgn : int.

axiom isgnP : isgn = 1 \/ isgn = -1.

axiom svalI (a b : w) :
  `|sval b - sval a| < wmax => sval (isub a b) = isgn * (sval b - sval a).

(* ==================================================================== *)
(* Exponents                                                            *)
(* ==================================================================== *)
type wpoly = w Array256.t.

(* bit reversal on the 8 - s bits of a leaf index *)
op bitrev (i : int) : int = bs2int (rev (int2bs (8 - s) i)).

(* the twiddle factor of node i of the tree (heap numbering) *)
op zpow (i : int) : int = (zeta_ ^ bitrev i) %% q.

(* the twiddles of level k, in butterfly order *)
op zetaW (k : int) : tw list =
  mkseq (fun j => tw_of (zpow (j + 2^(7-k)))) (2^(7-k)).

(* ==================================================================== *)
(* The word-level operators                                             *)
(* ==================================================================== *)
op reduce_coeff (p : wpoly) (base len plen : int) (z_ : tw) =
  let p1 = mkseq (fun i => p.[base       + i]) plen in
  let p2 = mkseq (fun i => p.[base + len + i]) plen in
  let r1 = map (fun (x : _ * _) => x.`1 + mmr x.`2 z_) (zip p1 p2) in
  let r2 = map (fun (x : _ * _) => x.`1 - mmr x.`2 z_) (zip p1 p2) in
  (r1, r2).

(* -------------------------------------------------------------------- *)
op reduce_coeff_flatten (p : wpoly) (base len : int) (z_ : tw) =
  let r = reduce_coeff p base len len z_ in
  r.`1 ++ r.`2.

(* -------------------------------------------------------------------- *)
op reduce_partial (p : wpoly) (base len plen : int) (z_ : tw) : wpoly =
  let r = reduce_coeff p base len plen z_ in
  let p = replace_ p base r.`1 in
  let p = replace_ p (base + len) r.`2 in
  p.

(* -------------------------------------------------------------------- *)
lemma reduce_coeffLE (p : wpoly) (base len plen : int) (z_ : tw) :
  (reduce_coeff p base len plen z_).`1 =
    mkseq (fun i => p.[base + i] + mmr p.[base + len + i] z_) plen.
proof.
rewrite /reduce_coeff /= zip_map /= -map_comp /(\o) /=.
by rewrite zipss -map_comp /(\o) /= -/(range 0 plen).
qed.

(* -------------------------------------------------------------------- *)
lemma reduce_coeffRE (p : wpoly) (base len plen : int) (z_ : tw) :
  (reduce_coeff p base len plen z_).`2 =
    mkseq (fun i => p.[base + i] - mmr p.[base + len + i] z_) plen.
proof.
rewrite /reduce_coeff /= zip_map /= -map_comp /(\o) /=.
by rewrite zipss -map_comp /(\o) /= -/(range 0 plen).
qed.

(* -------------------------------------------------------------------- *)
lemma reduce_coeff_sizeL (p : wpoly) (base len plen : int) (z_ : tw) :
  0 <= plen => size (reduce_coeff p base len plen z_).`1 = plen.
proof.
by move=> ? @/reduce_coeff /=; rewrite size_map size_zip !size_mkseq /#.
qed.

(* -------------------------------------------------------------------- *)
lemma reduce_coeff_sizeR (p : wpoly) (base len plen : int) (z_ : tw) :
  0 <= plen => size (reduce_coeff p base len plen z_).`2 = plen.
proof.
by move=> ? @/reduce_coeff /=; rewrite size_map size_zip !size_mkseq /#.
qed.

(* -------------------------------------------------------------------- *)
lemma reduce_coeff_flatten_size (p : wpoly) (base len : int) (z_ : tw) :
  0 <= len => size (reduce_coeff_flatten p base len z_) = 2 * len.
proof.
move=> ?; rewrite /reduce_coeff_flatten /= size_cat.
by rewrite !(reduce_coeff_sizeL, reduce_coeff_sizeR) //#.
qed.

(* -------------------------------------------------------------------- *)
lemma reduce_coeff_size (p : wpoly) (base len plen : int) (z_ : tw) (r s : _) :
     0 <= plen
  => reduce_coeff p base len plen z_ = (r, s)
  => size r = plen /\ size s = plen.
proof.
move=> ? ^ /(congr1 fst) /= <- /(congr1 snd) /= <-.
by rewrite !(reduce_coeff_sizeL, reduce_coeff_sizeR).
qed.

(* -------------------------------------------------------------------- *)
lemma reduce_coeff_eqon (p p' : wpoly) (base len plen : int) (z_ : tw) :
     eqon p p' (base      ) plen
  => eqon p p' (base + len) plen
  => reduce_coeff p base len plen z_ = reduce_coeff p' base len plen z_.
proof.
move=> eq1 eq2 @/reduce_coeff /=.
pose s1 := mkseq _ _; pose s2 := mkseq _ _.
pose r1 := mkseq _ _; pose r2 := mkseq _ _.
have [#] 2-> //: s1 = r1 /\ s2 = r2; split; apply: eq_in_mkseq => /=.
- by move=> i *; apply/eq1 => /#.
- by move=> i *; apply/eq2 => /#.
qed.

(* -------------------------------------------------------------------- *)
lemma reduce_coeff0 (p : wpoly) (base len : int) (z : tw) :
  reduce_coeff p base len 0 z = ([], []).
proof. by rewrite /reduce_coeff /= !mkseq0. qed.

hint simplify reduce_coeff0.

(* -------------------------------------------------------------------- *)
lemma reduce_coeffD (p : wpoly) (base len plen1 plen2 : int) (z : tw) :
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
lemma reduce_partial0 (p : wpoly) (base len : int) (z_ : tw) :
  reduce_partial p base len 0 z_ = p.
proof. done. qed.

(* -------------------------------------------------------------------- *)
lemma eqexcept_reduce_partial (p : wpoly) (base len plen : int) (z_ : tw) :
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
lemma reduce_partialD (p : wpoly) (base len plen1 plen2) (z_ : tw) :
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
lemma reduce_partial_swap (p : wpoly) (b1 b2 l1 l2 pl1 pl2) (z1 z2 : tw) :
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
op [opaque] reduce (p : wpoly) (base len : int) (z_ : tw) : wpoly =
  replace_ p base (reduce_coeff_flatten p base len z_).

(* -------------------------------------------------------------------- *)
lemma reduce_as_partial (p : wpoly) (base len : int) (z_ : tw) :
  0 <= len => reduce p base len z_ = reduce_partial p base len len z_.
proof.
move=> *; rewrite /reduce /reduce_coeff_flatten /reduce_partial /=.
pose r := reduce_coeff _ _ _ _ _; rewrite replace_cat.
by rewrite reduce_coeff_sizeL //#.
qed.

(* -------------------------------------------------------------------- *)
op reduce_n (p : wpoly) (base len : int) (zs : tw list) =
  foldl
    (fun p i => reduce p (base + i * 2 * len) len (nth witness zs i))
    p (range 0 (size zs)).

(* -------------------------------------------------------------------- *)
op reduce_level (p : wpoly) (i : int) =
  reduce_n p 0 (2^i) (zetaW i).

(* -------------------------------------------------------------------- *)
op reduce_tree (p : wpoly) (i : int) =
  foldr (fun i p => reduce_level p i) p (range i 8).

(* -------------------------------------------------------------------- *)
lemma reduce_0 (p : wpoly) (base len : int) :
  reduce_n p base len [] = p.
proof. by rewrite /reduce_n /= range_geq. qed.

(* -------------------------------------------------------------------- *)
lemma reduce_seq1 (p : wpoly) (base len : int) (z : tw) :
  reduce_n p base len [z] = reduce p base len z.
proof. by rewrite /reduce_n /= (rangeS 0). qed.

(* -------------------------------------------------------------------- *)
lemma reduce_seq2 (p : wpoly) (base len : int) (z1 z2 : tw) :
    reduce_n p base len [z1; z2]
  = reduce (reduce p base len z1) (base + 2 * len) len z2.
proof. by rewrite /reduce_n /range /= -iotaredE. qed.

(* -------------------------------------------------------------------- *)
lemma reduce_n_cat (p : wpoly) (base len : int) (zs1 zs2 : tw list) :
    reduce_n p base len (zs1 ++ zs2)
  = reduce_n (reduce_n p base len zs1) (base + 2 * len * size zs1) len zs2.
proof.
rewrite {1}/reduce_n size_cat (range_cat (size zs1)) ~-1:#smt:(size_ge0).
rewrite (range_addl 0 _ (size zs1)) addrAC /= foldl_cat.
rewrite foldl_map &(eq_in_foldl) //=; last first.
- by apply/eq_in_foldl=> //= x i /mem_range rgi; smt(nth_cat).
- by move=> x i /mem_range rgi; smt(nth_cat).
qed.

(* -------------------------------------------------------------------- *)
lemma reduce_rcons (p : wpoly) (base len : int) (zs : tw list) (z : tw) :
    reduce_n p base len (rcons zs z)
  = reduce (reduce_n p base len zs) (base + 2 * len * size zs) len z.
proof. by rewrite -cats1 reduce_n_cat reduce_seq1. qed.

(* -------------------------------------------------------------------- *)
lemma reduce_nE (p : wpoly) (base len : int) (zs : tw list) : 0 <= len =>
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
lemma reduce_tree8 (p : wpoly) : reduce_tree p 8 = p.
proof. by rewrite /reduce_tree range_geq. qed.

(* ==================================================================== *)
(* Interpretation of word-level data                                    *)
(* ==================================================================== *)
(* all coefficients bounded by B in magnitude *)
op cbnd (p : wpoly) (B : int) =
  forall i, 0 <= i < 256 => `|sval p.[i]| <= B.

(* ==================================================================== *)
(* Integer powers of zeta                                               *)
(* ==================================================================== *)
(* helper: mod-pow compatibility (missing from IntDiv) *)
lemma modzXm (x n m : int) : 0 <= n => (x %% m) ^ n %% m = x ^ n %% m.
proof.
move=> ge0_n; elim: n ge0_n => [|n ge0_n ih]; first by rewrite !expr0.
by rewrite !exprS // modzMml -modzMmr ih modzMmr.
qed.

lemma ge0_8s : 0 <= 8 - s.
proof. by have := rg_s => /#. qed.

(* zeta has order 2^(9-s) mod q *)
lemma e9s : 2^(9-s) = 2 * 2^(8-s).
proof. by rewrite (_ : 9 - s = (8 - s) + 1) 1:/# exprS 1:ge0_8s /#. qed.

lemma zeta_order : zeta_ ^ (2^(9-s)) %% q = 1.
proof.
rewrite e9s mulzC exprM -modzXm 1:#smt:(expr_ge0) zeta_half modzXm //.
by rewrite expr2 /= modz_small; smt(gt1_q).
qed.

lemma zexp_modE (n : int) : 0 <= n =>
  zeta_ ^ (n %% 2^(9-s)) %% q = zeta_ ^ n %% q.
proof.
move=> ge0_n; have gt0M : 0 < 2^(9-s) by apply expr_gt0.
have := zeta_order; move: gt0M; move: (2^(9-s)) => M gt0M hM.
rewrite {2}(divz_eq n M) exprD_nneg ?modz_ge0 1:mulr_ge0 1:divz_ge0 ~-1:/#.
rewrite (mulzC (n %/ M)) exprM -modzMml -(modzXm (zeta_ ^ M)) 1:#smt:(divz_ge0).
by rewrite hM expr1z modzMml.
qed.

(* reduce exponents mod 2^(9-s) *)
op zpw (e : int) : int = zeta_ ^ (e %% 2^(9-s)).

lemma zpw_cgr_exp (e e' : int) :
  e %% 2^(9-s) = e' %% 2^(9-s) => zpw e = zpw e'.
proof. by move=> @/zpw ->. qed.

lemma zpwD (a b : int) : zpw (a + b) %% q = (zpw a * zpw b) %% q.
proof.
have gt0M : 0 < 2^(9-s) by apply expr_gt0.
rewrite /zpw -exprD_nneg ?modz_ge0 ~-1:/# -modzDm zexp_modE //.
by rewrite addr_ge0 modz_ge0 /#.
qed.

(* zeta^(2^(8-s)) = -1 mod q: the sign identity of the CRT tree *)
lemma zpw_half : zpw (2^(8-s)) %% q = (-1) %% q.
proof.
by rewrite /zpw (modz_small (2^(8-s))) 2:zeta_half // e9s; smt(expr_gt0).
qed.

lemma zpw_oppE (e : int) : zpw (e + 2^(8-s)) %% q = (- zpw e) %% q.
proof. by rewrite zpwD -modzMmr zpw_half modzMmr mulrN1. qed.

(* -------------------------------------------------------------------- *)
lemma bitrev_rg (x : int) : 0 <= bitrev x < 2^(8-s).
proof.
rewrite /bitrev; split; [exact bs2int_ge0 | move=> _].
have := bs2int_le2Xs (rev (int2bs (8 - s) x)).
by rewrite size_rev size_int2bs ler_maxr // ge0_8s.
qed.

lemma bitrev0 : bitrev 0 = 0.
proof. by rewrite /bitrev int2bs0 rev_nseq bs2int_nseq_false. qed.

(* the halving identity behind the exponent tree *)
lemma bitrev_half (x : int) : 0 <= x < 2^(8-s) =>
  2 * bitrev x = bitrev (x %/ 2) + 2^(8-s) * (x %% 2).
proof.
move=> rgx @/bitrev; have [ge0s lt8s] := rg_s.
rewrite (int2bs_cons (8 - s) x) 1:/# rev_cons bs2int_rcons.
rewrite size_rev size_int2bs ler_maxr 1:/#.
rewrite (int2bs_rcons (8 - s) (x %/ 2)) 1:/#.
have e8 : 2^(8-s) = 2 * 2^(8-s-1) by rewrite -exprS 1:/#.
rewrite -divz_mul // -e8.
have -> /= : x %/ 2^(8-s) = 0 by apply pdiv_small.
rewrite /= rev_rcons bs2int_cons /= e8 /=.
case (2 %| x) => hx /=.
- by rewrite b2i0 /=; have -> : x %% 2 = 0 by rewrite -dvdzE.
have -> : x %% 2 = 1 by smt().
by rewrite b2i1 b2i0; ring.
qed.

(* the top bit of a node index becomes the low bit *)
lemma bitrev_top (m : int) : 0 <= m < 2^(7-s) =>
  bitrev (m + 2^(7-s)) = bitrev m + 1.
proof.
move=> rgm @/bitrev; have [ge0s lt8s] := rg_s.
have e8 : 8 - s = (7 - s) + 1 by ring.
rewrite e8 !(int2bs_rcons (7 - s + 1)) 1,2:/# /=.
have -> : (m + 2^(7-s)) %/ 2^(7-s) = 1.
- by rewrite divzDr 1:dvdzz divzz /= pdiv_small //#.
have -> : m %/ 2^(7-s) = 0 by apply pdiv_small.
have -> : int2bs (7 - s) (m + 2^(7-s)) = int2bs (7 - s) m.
- by rewrite -(int2bs_mod (7 - s) (m + _)) modzDr int2bs_mod.
by rewrite !rev_rcons !bs2int_cons /=; ring.
qed.

(* link with the table exponents *)
lemma zpow_zpw (x : int) : zpow x = zpw (bitrev x) %% q.
proof.
rewrite /zpow /zpw (modz_small (bitrev x) (2^(9-s))) //.
by rewrite e9s; smt(bitrev_rg).
qed.

(* ==================================================================== *)
(* The exponent tree                                                    *)
(* ==================================================================== *)
(* E k j: block j at level k holds P mod (X^(2^k) - zeta^(E k j)).
   Level 8 is the whole input: X^256 + 1 = X^256 - zeta^(2^(8-s)).
   Splitting block j of level k+1 with w = zeta^(bitrev (j + 2^(7-k)))
   yields children 2j (minus sign) and 2j+1 (plus sign, i.e.
   e + 2^(8-s)). *)
op E (k j : int) : int =
  if k = 8 then 2^(8-s)
  else bitrev (j %/ 2 + 2^(7-k)) + 2^(8-s) * (j %% 2).

lemma E_even (k j : int) : 0 <= k < 8 =>
  E k (2*j) = bitrev (j + 2^(7-k)).
proof. by move=> rgk @/E; rewrite ifF 1:/# mulKz // modzMr /=. qed.

lemma E_odd (k j : int) : 0 <= k < 8 =>
  E k (2*j+1) = E k (2*j) + 2^(8-s).
proof.
by move=> rgk @/E; rewrite !ifF 1,2:/# (mulzC 2 j) divzMDl // modzMDl mulzK // modzMl.
qed.

(* squaring a child exponent gives the parent exponent *)
lemma E_double (k j : int) : s <= k < 8 => 0 <= j < 2^(7-k) =>
  (2 * E k (2*j)) %% 2^(9-s) = E (k+1) j %% 2^(9-s).
proof.
move=> rgk rgj; have [ge0s _] := rg_s; rewrite E_even 1:/#.
have le7 : 2^(7-k) <= 2^(7-s) by apply ler_weexpn2l => /#.
have e8 : 2^(8-s) = 2 * 2^(7-s) by rewrite -exprS 1:/# /#.
have rgx : 0 <= j + 2^(7-k) < 2^(8-s) by smt(expr_gt0).
rewrite bitrev_half //.
case (k = 7) => [->>|neq7].
- move: rgj => /= rgj; have ->> : j = 0 by smt().
  by rewrite /E /= bitrev0.
have h2 : 2^(7-k) = 2 * 2^(6-k) by rewrite -exprS 1:/# /#.
rewrite /E ifF 1:/#.
have -> : (j + 2^(7-k)) %/ 2 = j %/ 2 + 2^(6-k) by smt().
have -> : (j + 2^(7-k)) %% 2 = j %% 2 by smt().
by have -> : 7 - (k + 1) = 6 - k by smt().
qed.

(* the leaves: block j of level s is the residue at zeta^(2 bitrev j + 1) *)
lemma E_leaf (j : int) : 0 <= j < 2^(8-s) => E s j = 2 * bitrev j + 1.
proof.
move=> rgj; have [ge0s lt8s] := rg_s.
have e8 : 2^(8-s) = 2 * 2^(7-s) by rewrite -exprS 1:/#.
rewrite /E ifF 1:/# bitrev_top 1:/# bitrev_half //#.
qed.

(* ==================================================================== *)
(* The target sums: coefficients of P mod (X^(2^k) - zeta^(E k j))      *)
(* ==================================================================== *)
(* helpers: congruence of big sums, and even/odd splitting *)
import BIA.

lemma big_cgr (m : int) (f g : int -> int) (a b : int) :
  (forall i, a <= i < b => f i %% m = g i %% m) =>
  bigi predT f a b %% m = bigi predT g a b %% m.
proof.
move=> h; have {h} : forall i, i \in range a b => f i %% m = g i %% m.
- by move=> i /mem_range; apply h.
elim: (range a b) => [|x xs ih] hs; first by rewrite !big_nil.
rewrite !big_cons /predT /=.
by rewrite -modzDm hs // ih 1:/# modzDm.
qed.

lemma big_split_parity (F : int -> int) (n : int) : 0 <= n =>
    bigi predT F 0 (2*n)
  = bigi predT (fun u => F (2*u)) 0 n + bigi predT (fun u => F (2*u+1)) 0 n.
proof.
elim: n => [|n ge0_n ih]; first by rewrite !big_geq.
have ->: 2*(n+1) = (2*n+1)+1 by ring.
rewrite big_int_recr 1:/# big_int_recr 1:/# ih.
rewrite big_int_recr // big_int_recr //=.
by ring.
qed.

(* Since X^(u * 2^k + t) = (X^(2^k))^u * X^t = zeta^(E k j * u) * X^t
   modulo the block modulus, coefficient t of the residue is: *)
op nttsum (p : wpoly) (k j t : int) : int =
  bigi predT (fun u => zpw (E k j * u) * sval p.[u * 2^k + t]) 0 (2^(8-k)).

(* level 8: the residue is the polynomial itself *)
lemma nttsum8 (p : wpoly) (t : int) : nttsum p 8 0 t = sval p.[t].
proof. by rewrite /nttsum /= big_int1 /= /zpw /=. qed.

(* the butterfly identity on sums: splitting even/odd u in the parent
   sum realizes the CRT step *)
lemma nttsum_split (p : wpoly) (k j t : int) :
  s <= k < 8 => 0 <= j < 2^(7-k) => 0 <= t < 2^k =>
     nttsum p k (2*j) t %% q
       = (nttsum p (k+1) j t + zpw (E k (2*j)) * nttsum p (k+1) j (t + 2^k)) %% q
  /\ nttsum p k (2*j+1) t %% q
       = (nttsum p (k+1) j t - zpw (E k (2*j)) * nttsum p (k+1) j (t + 2^k)) %% q.
proof.
move=> rgk rgj rgt; have [ge0s _] := rg_s.
have rgk0 : 0 <= k < 8 by smt().
have cgrM : forall (a a' b : int), a %% q = a' %% q => (a * b) %% q = (a' * b) %% q.
- by move=> a a' b h; rewrite -modzMml h modzMml.
have e8k : 2^(8-k) = 2 * 2^(7-k).
- by rewrite (_ : 8 - k = (7 - k) + 1) 1:/# exprS 1:/#.
have heven : forall u, zpw (E k (2*j) * (2*u)) = zpw (E (k+1) j * u).
- move=> u; apply zpw_cgr_exp.
  have ->: E k (2*j) * (2*u) = (2 * E k (2*j)) * u by ring.
  by rewrite -modzMml E_double // modzMml.
have hidx : forall u, (2*u) * 2^k + t = u * 2^(k+1) + t.
- by move=> u; rewrite exprS 1:/# /#.
have hidx1 : forall u, (2*u+1) * 2^k + t = u * 2^(k+1) + (t + 2^k).
- by move=> u; rewrite exprS 1:/# /#.
have hodd :
    bigi predT
      (fun u => zpw (E k (2*j) * (2*u+1)) * sval p.[(2*u+1) * 2^k + t])
      0 (2^(7-k)) %% q
  = (zpw (E k (2*j)) *
       bigi predT
         (fun u => zpw (E (k+1) j * u) * sval p.[u * 2^(k+1) + (t + 2^k)])
         0 (2^(7-k))) %% q.
- rewrite BIA.mulr_sumr.
  apply big_cgr => u rgu /=.
  rewrite hidx1 mulrA.
  rewrite -modzMml -(modzMml
    (zpw (E k (2*j)) * zpw (E (k+1) j * u))
    (sval p.[u * 2^(k+1) + (t + 2^k)]) q).
  congr; congr.
  have ->: E k (2*j) * (2*u+1) = E k (2*j) + E k (2*j) * (2*u) by ring.
  by rewrite zpwD heven.
split.
- rewrite /nttsum.
  have -> : 8 - (k + 1) = 7 - k by smt().
  rewrite e8k big_split_parity 1:expr_ge0 //=.
  have -> :
      bigi predT
        (fun (u : int) => zpw (E k (2*j) * (2*u)) * sval p.[(2*u) * 2^k + t])
        0 (2^(7-k))
    = bigi predT
        (fun (u : int) => zpw (E (k+1) j * u) * sval p.[u * 2^(k+1) + t])
        0 (2^(7-k)).
  + by apply eq_big_int => u rgu /=; rewrite heven hidx.
  by rewrite -modzDmr hodd modzDmr.
have heven2 : forall u, zpw (E k (2*j+1) * (2*u)) = zpw (E (k+1) j * u).
- move=> u; rewrite E_odd //; apply zpw_cgr_exp.
  have ->: (E k (2*j) + 2^(8-s)) * (2*u) = u * 2^(9-s) + (2 * E k (2*j)) * u.
  + by rewrite e9s; ring.
  by rewrite modzMDl -modzMml E_double // modzMml.
have hodd2 :
    bigi predT
      (fun u => zpw (E k (2*j+1) * (2*u+1)) * sval p.[(2*u+1) * 2^k + t])
      0 (2^(7-k)) %% q
  = (- zpw (E k (2*j)) *
       bigi predT
         (fun u => zpw (E (k+1) j * u) * sval p.[u * 2^(k+1) + (t + 2^k)])
         0 (2^(7-k))) %% q.
- rewrite BIA.mulr_sumr BIA.sumrN /=.
  apply big_cgr => u rgu /=.
  rewrite hidx1 E_odd //.
  have ->: (E k (2*j) + 2^(8-s)) * (2*u+1)
         = (E k (2*j) + 2^(8-s)) + (E k (2*j) + 2^(8-s)) * (2*u) by ring.
  rewrite mulrA -mulNr.
  rewrite mulrA.
  apply cgrM.
  rewrite zpwD.
  have ->: (E k (2*j) + 2^(8-s)) * 2 * u = E k (2*j+1) * (2*u).
  + by rewrite E_odd //; ring.
  rewrite heven2.
  by apply cgrM; apply zpw_oppE.
rewrite /nttsum.
have -> : 8 - (k + 1) = 7 - k by smt().
rewrite e8k big_split_parity 1:expr_ge0 //=.
have -> :
    bigi predT
      (fun (u : int) => zpw (E k (2*j+1) * (2*u)) * sval p.[(2*u) * 2^k + t])
      0 (2^(7-k))
  = bigi predT
      (fun (u : int) => zpw (E (k+1) j * u) * sval p.[u * 2^(k+1) + t])
      0 (2^(7-k)).
- by apply eq_big_int => u rgu /=; rewrite heven2 hidx.
by rewrite -modzDmr hodd2 modzDmr.
qed.

(* ==================================================================== *)
(* One butterfly block, at the level of values                          *)
(* ==================================================================== *)
(* pointwise access to [reduce] *)
lemma reduceiE_lo (p : wpoly) (base len : int) (z : tw) (t : int) :
  0 <= base => 0 <= t < len => base + 2*len <= 256 =>
  (reduce p base len z).[base + t] = p.[base + t] + mmr p.[base + len + t] z.
proof.
move=> ge0b rgt le256.
rewrite /reduce /replace_ filliE 1:/# reduce_coeff_flatten_size 1:/#.
rewrite ifT 1:/#.
rewrite /reduce_coeff_flatten /= nth_cat reduce_coeff_sizeL 1:/#.
rewrite ifT 1:/# reduce_coeffLE nth_mkseq 1:/# /=.
by rewrite (: base + t - base = t) 1:/#.
qed.

lemma reduceiE_hi (p : wpoly) (base len : int) (z : tw) (t : int) :
  0 <= base => 0 <= t < len => base + 2*len <= 256 =>
  (reduce p base len z).[base + len + t] = p.[base + t] - mmr p.[base + len + t] z.
proof.
move=> ge0b rgt le256.
rewrite /reduce /replace_ filliE 1:/# reduce_coeff_flatten_size 1:/#.
rewrite ifT 1:/#.
rewrite /reduce_coeff_flatten /= nth_cat reduce_coeff_sizeL 1:/#.
rewrite ifF 1:/# reduce_coeffRE nth_mkseq 1:/# /=.
by rewrite (: base + len + t - base - len = t) 1:/#.
qed.

(* coefficients outside the block are untouched *)
lemma reduce_out (p : wpoly) (base len : int) (z : tw) (i : int) :
  0 <= len => 0 <= i < 256 => ! (base <= i < base + 2 * len) =>
  (reduce p base len z).[i] = p.[i].
proof.
move=> ge0len rgi hout.
by rewrite /reduce /replace_ filliE 1:/# reduce_coeff_flatten_size 1:/# ifF 1:/#.
qed.

(* ==================================================================== *)
(* One level                                                            *)
(* ==================================================================== *)
lemma zetaW_size (k : int) : 0 <= k < 8 => size (zetaW k) = 2^(7-k).
proof. by move=> rgk; rewrite /zetaW size_mkseq; smt(expr_gt0). qed.

lemma zetaW_nth (k j : int) : 0 <= j < 2^(7-k) =>
  nth witness (zetaW k) j = tw_of (zpow (j + 2^(7-k))).
proof. by move=> rgj; rewrite /zetaW nth_mkseq. qed.

(* pointwise access to [reduce_level]: block j is one butterfly *)
lemma reduce_leveliE (p : wpoly) (k j t : int) :
  0 <= k < 8 => 0 <= j < 2^(7-k) => 0 <= t < 2^k =>
     (reduce_level p k).[j * 2^(k+1) + t]
       = p.[j * 2^(k+1) + t]
         + mmr p.[j * 2^(k+1) + 2^k + t] (tw_of (zpow (j + 2^(7-k))))
  /\ (reduce_level p k).[j * 2^(k+1) + 2^k + t]
       = p.[j * 2^(k+1) + t]
         - mmr p.[j * 2^(k+1) + 2^k + t] (tw_of (zpow (j + 2^(7-k)))).
proof.
move=> rgk rgj rgt.
have gt0len : 0 < 2^k by apply expr_gt0.
have eSk : 2^(k+1) = 2 * 2^k by rewrite exprS 1:/#.
have e256 : 2^(7-k) * 2^(k+1) = 256.
- by rewrite -exprD_nneg 1,2:/# (: 7 - k + (k+1) = 8) 1:/# /=.
rewrite /reduce_level.
rewrite (reduce_nE p 0 (2^k)) 1:/#.
rewrite zetaW_size //.
pose F := fun (i : int) =>
  reduce_coeff_flatten p (0 + 2 * i * 2^k) (2^k) (nth witness (zetaW k) i).
have hbsz : forall i, 0 <= i < 2^(7-k) => size (F i) = 2 * 2^k.
- by move=> i rgi; rewrite /F reduce_coeff_flatten_size /#.
have hfsz : size (flatten (mkseq F (2^(7-k)))) = 256.
- rewrite size_flatten.
  have -> : map size (mkseq F (2^(7-k))) = nseq (2^(7-k)) (2 * 2^k).
  + apply (eq_from_nth witness).
    * by rewrite size_map size_mkseq size_nseq.
    move=> i; rewrite size_map size_mkseq => rgi.
    rewrite (nth_map witness) 1:size_mkseq 1:/# nth_mkseq 1:/# nth_nseq 1:/#.
    by rewrite hbsz /#.
  rewrite Bigint.sumz_nseq.
  + by apply expr_ge0.
  by rewrite -eSk /#.
have hx : j * 2^(k+1) + 2^(k+1) <= 256.
- have : (j + 1) * 2^(k+1) <= 2^(7-k) * 2^(k+1).
  + by apply ler_pmul2r; smt(expr_gt0).
  by rewrite e256 /#.
have hzj := zetaW_nth k j rgj.
have hnth : forall (r : int), 0 <= r < 2^(k+1) =>
    nth witness (flatten (mkseq F (2^(7-k)))) (j * 2^(k+1) + r)
  = nth witness (F j) r.
- move=> r rgr.
  rewrite (BitChunking.nth_flatten witness (2 * 2^k)).
  + by apply/List.allP=> x /mkseqP [i [rgi ->]] /=; rewrite hbsz.
  rewrite -eSk.
  have -> : (j * 2^(k+1) + r) %/ 2^(k+1) = j.
  - by rewrite divzMDl 1:#smt:(expr_gt0) pdiv_small //.
  have -> : (j * 2^(k+1) + r) %% 2^(k+1) = r by rewrite modzMDl pmod_small.
  by rewrite nth_mkseq 1:/#.
split.
- rewrite /replace_ filliE 1:/# hfsz ifT 1:/#.
  rewrite /= (: j * 2^(k+1) + t - 0 = j * 2^(k+1) + t) 1:/#.
  rewrite hnth 1:/#.
  rewrite /F /= hzj /reduce_coeff_flatten /= nth_cat reduce_coeff_sizeL 1:/#.
  rewrite ifT 1:/# reduce_coeffLE nth_mkseq 1:/# /=.
  by have -> // : 2 * j * 2^k = j * 2^(k+1) by rewrite eSk; ring.
rewrite /replace_ filliE 1:/# hfsz ifT 1:/#.
rewrite /= (: j * 2^(k+1) + 2^k + t - 0 = j * 2^(k+1) + (2^k + t)) 1:/#.
rewrite hnth 1:/#.
rewrite /F /= hzj /reduce_coeff_flatten /= nth_cat reduce_coeff_sizeL 1:/#.
rewrite ifF 1:/# reduce_coeffRE nth_mkseq 1:/# /=.
have -> : 2^k + t - 2^k = t by ring.
have -> : 2 * j * 2^k + t = j * 2^(k+1) + t by rewrite eSk; ring.
have -> : 2 * j * 2^k + 2^k + t = j * 2^(k+1) + (2^k + t) by rewrite eSk; ring.
done.
qed.

lemma reduce_level_alg (p : wpoly) (B k : int) :
  s <= k < 8 => 0 <= B => B + q < wmax => cbnd p B =>
     cbnd (reduce_level p k) (B + q)
  /\ forall (j t : int), 0 <= j < 2^(7-k) => 0 <= t < 2^k =>
       let base = j * 2^(k+1) in
       let x    = zpw (E k (2*j)) in
          sval (reduce_level p k).[base + t] %% q
            = (sval p.[base + t] + x * sval p.[base + 2^k + t]) %% q
       /\ sval (reduce_level p k).[base + 2^k + t] %% q
            = (sval p.[base + t] - x * sval p.[base + 2^k + t]) %% q.
proof.
move=> rgk ge0B hB hbnd; have [ge0s _] := rg_s.
have rgk0 : 0 <= k < 8 by smt().
have eSk : 2^(k+1) = 2 * 2^k by rewrite exprS 1:/#.
have e256 : 2^(7-k) * 2^(k+1) = 256.
- by rewrite -exprD_nneg 1,2:/# (: 7 - k + (k+1) = 8) 1:/# /=.
have hgen : forall (j t : int), 0 <= j < 2^(7-k) => 0 <= t < 2^k =>
     `|sval (reduce_level p k).[j * 2^(k+1) + t]| <= B + q
  /\ `|sval (reduce_level p k).[j * 2^(k+1) + 2^k + t]| <= B + q
  /\ (sval (reduce_level p k).[j * 2^(k+1) + t] %% q
        = (sval p.[j * 2^(k+1) + t]
           + zpw (E k (2*j)) * sval p.[j * 2^(k+1) + 2^k + t]) %% q)
  /\ (sval (reduce_level p k).[j * 2^(k+1) + 2^k + t] %% q
        = (sval p.[j * 2^(k+1) + t]
           - zpw (E k (2*j)) * sval p.[j * 2^(k+1) + 2^k + t]) %% q).
- move=> j t rgj rgt.
  have [-> ->] := reduce_leveliE p k j t _ _ _ => //.
  have hidx1 : 0 <= j * 2^(k+1) + t < 256 by smt(expr_gt0 ler_pmul2r).
  have hidx2 : 0 <= j * 2^(k+1) + 2^k + t < 256 by smt(expr_gt0 ler_pmul2r).
  have h1 : `|sval p.[j * 2^(k+1) + t]| <= B by smt().
  have h2 : `|sval p.[j * 2^(k+1) + 2^k + t]| <= B by smt().
  have hm := mmr_bnd p.[j * 2^(k+1) + 2^k + t] (zpow (j + 2^(7-k))).
  have hmc := mmr_cgr p.[j * 2^(k+1) + 2^k + t] (zpow (j + 2^(7-k))).
  have hw : zpow (j + 2^(7-k)) = zpw (E k (2*j)) %% q by rewrite zpow_zpw -E_even.
  rewrite svalD; first by smt().
  rewrite svalB; first by smt().
  do! split.
  + by move=> {hbnd hB e256 eSk hmc hw hidx1 hidx2}; smt().
  + by move=> {hbnd hB e256 eSk hmc hw hidx1 hidx2}; smt().
  + rewrite -modzDmr hmc hw modzMmr modzDmr.
    by have -> // : sval p.[j * 2^(k+1) + t]
           + sval p.[j * 2^(k+1) + 2^k + t] * zpw (E k (2*j))
         = sval p.[j * 2^(k+1) + t]
           + zpw (E k (2*j)) * sval p.[j * 2^(k+1) + 2^k + t] by ring.
  rewrite -modzDmr -modzNm hmc hw modzMmr modzNm modzDmr.
  by have -> // : sval p.[j * 2^(k+1) + t]
         - sval p.[j * 2^(k+1) + 2^k + t] * zpw (E k (2*j))
       = sval p.[j * 2^(k+1) + t]
         - zpw (E k (2*j)) * sval p.[j * 2^(k+1) + 2^k + t] by ring.
split.
- move=> x rgx.
  pose j := x %/ 2^(k+1); pose r := x %% 2^(k+1).
  have hj : 0 <= j < 2^(7-k).
  + split; first by rewrite /j divz_ge0 1:expr_gt0 /#.
    by move=> _; rewrite /j ltz_divLR 1:expr_gt0 // 1:/# e256 /#.
  have hr : 0 <= r < 2^(k+1) by smt(expr_gt0 modz_ge0 ltz_pmod).
  have hx : x = j * 2^(k+1) + r by rewrite /j /r -divz_eq.
  case (r < 2^k) => hcase.
  + by have := hgen j r _ _; smt().
  by have := hgen j (r - 2^k) _ _; smt().
move=> j t rgj rgt /=.
by have := hgen j t rgj rgt; smt().
qed.

(* ==================================================================== *)
(* The tree: main invariant                                             *)
(* ==================================================================== *)
lemma reduce_tree_alg (p : wpoly) (B k : int) :
  s <= k <= 8 => 0 <= B => B + (8 - k) * q < wmax => cbnd p B =>
     cbnd (reduce_tree p k) (B + (8 - k) * q)
  /\ forall (j t : int), 0 <= j < 2^(8-k) => 0 <= t < 2^k =>
       sval (reduce_tree p k).[j * 2^k + t] %% q = nttsum p k j t %% q.
proof.
move=> + ge0B.
have : forall (d : int), 0 <= d => forall (k' : int),
  k' = 8 - d => s <= k' <= 8 => B + (8 - k') * q < wmax => cbnd p B =>
     cbnd (reduce_tree p k') (B + (8 - k') * q)
  /\ forall (j t : int), 0 <= j < 2^(8-k') => 0 <= t < 2^k' =>
       sval (reduce_tree p k').[j * 2^k' + t] %% q = nttsum p k' j t %% q.
- elim => [|d ge0d ih] k' eqk rgk hB hbnd.
  + have -> : k' = 8 by smt().
    split; first by rewrite reduce_tree8 /#.
    move=> j t rgj rgt.
    have -> : j = 0 by move: rgj => /= /#.
    by rewrite nttsum8 /= reduce_tree8.
  have cgrD : forall (a a' b b' : int),
    a %% q = a' %% q => b %% q = b' %% q => (a + b) %% q = (a' + b') %% q.
  + by move=> a a' b b' ha hb; rewrite -modzDm ha hb modzDm.
  have cgrB : forall (a a' b b' : int),
    a %% q = a' %% q => b %% q = b' %% q => (a - b) %% q = (a' - b') %% q.
  + by move=> a a' b b' ha hb; rewrite -modzBm ha hb modzBm.
  have cgrMr : forall (c b b' : int),
    b %% q = b' %% q => (c * b) %% q = (c * b') %% q.
  + by move=> c b b' hb; rewrite -modzMmr hb modzMmr.
  have rgk' : s <= k' < 8 by smt().
  have [ge0s _] := rg_s.
  have eSk : 2^(k'+1) = 2 * 2^k' by rewrite exprS 1:/#.
  have hkd : k' + 1 = 8 - d by smt().
  have hrg : s <= k' + 1 <= 8 by smt().
  have hB2 : B + (8 - (k'+1)) * q < wmax by smt(gt0_q).
  have := ih (k'+1) hkd hrg hB2 hbnd.
  rewrite (: 8 - (k'+1) = 7 - k') 1:/#.
  move=> [ihb ihs].
  have hstep : reduce_tree p k' = reduce_level (reduce_tree p (k'+1)) k'.
  + by rewrite (reduce_tree_step p k') 1:/#.
  have hB3 : (B + (7 - k') * q) + q < wmax by smt().
  have ge0B2 : 0 <= B + (7 - k') * q by smt(gt0_q).
  have [lvlb lvls] := reduce_level_alg
    (reduce_tree p (k'+1)) (B + (7 - k') * q) k' rgk' ge0B2 hB3 ihb.
  split.
  + rewrite hstep.
    by have -> : B + (8 - k') * q = (B + (7 - k') * q) + q by ring.
  move=> j t rgj rgt.
  rewrite hstep.
  case (j %% 2 = 0) => hpar.
  + pose j2 := j %/ 2.
    have jE : j = 2 * j2 by smt().
    have rgj2 : 0 <= j2 < 2^(7-k').
    * by move: rgj; rewrite (: 8 - k' = (7 - k') + 1) 1:/# exprS 1:/# /#.
    have [c1 _] := nttsum_split p k' j2 t rgk' rgj2 rgt.
    rewrite jE c1.
    have := lvls j2 t rgj2 rgt.
    rewrite /= => -[l1 _].
    have eidx : 2 * j2 * 2^k' + t = j2 * 2^(k'+1) + t.
    * by rewrite eSk; ring.
    rewrite eidx l1.
    apply cgrD.
    * by apply (ihs j2 t rgj2 _); smt().
    apply cgrMr.
    rewrite (: t + 2^k' = 2^k' + t) 1:/#.
    have := ihs j2 (2^k' + t) rgj2 _; 1: smt().
    by rewrite (: j2 * 2^(k'+1) + (2^k' + t) = j2 * 2^(k'+1) + 2^k' + t) 1:/#.
  pose j2 := j %/ 2.
  have jE : j = 2 * j2 + 1 by smt().
  have rgj2 : 0 <= j2 < 2^(7-k').
  + by move: rgj; rewrite (: 8 - k' = (7 - k') + 1) 1:/# exprS 1:/# /#.
  have [_ c2] := nttsum_split p k' j2 t rgk' rgj2 rgt.
  rewrite jE c2.
  have := lvls j2 t rgj2 rgt.
  rewrite /= => -[_ l2].
  have eidx : (2 * j2 + 1) * 2^k' + t = j2 * 2^(k'+1) + 2^k' + t.
  + by rewrite eSk; ring.
  rewrite eidx l2.
  apply cgrB.
  + by apply (ihs j2 t rgj2 _); smt().
  apply cgrMr.
  rewrite (: t + 2^k' = 2^k' + t) 1:/#.
  have := ihs j2 (2^k' + t) rgj2 _; 1: smt().
  by rewrite (: j2 * 2^(k'+1) + (2^k' + t) = j2 * 2^(k'+1) + 2^k' + t) 1:/#.
move=> main rgk hB hbnd.
have := main (8 - k) _ k _ _ _ _ => //; smt().
qed.

(* ==================================================================== *)
(* Endpoint: the full transform evaluates at the leaves                 *)
(* ==================================================================== *)
lemma ntt_alg (p : wpoly) (B : int) :
  0 <= B => B + (8 - s) * q < wmax => cbnd p B =>
     cbnd (reduce_tree p s) (B + (8 - s) * q)
  /\ forall (j t : int), 0 <= j < 2^(8-s) => 0 <= t < 2^s =>
       sval (reduce_tree p s).[j * 2^s + t] %% q = nttsum p s j t %% q.
proof.
move=> ge0B hB hbnd; have [ge0s lt8s] := rg_s.
by apply reduce_tree_alg => //#.
qed.

(* ==================================================================== *)
(* The inverse transform (Gentleman-Sande)                              *)
(* ==================================================================== *)
(* One merge of level k: from a = f mod (X^(2^k) - w) and
   b = f mod (X^(2^k) + w) (blocks at base and base + 2^k) it computes
   a + b = 2 f0 and (b - a) w' = 2 f1 with w' = -w^-1 = zeta^(H - e),
   recovering 2 (f mod (X^(2^(k+1)) - w^2)).  The twiddle value absorbs
   the sign of isub. *)
op izv (k j : int) : int = isgn * zpw (2^(8-s) - E k (2*j)).

op izetaW (k : int) : tw list = mkseq (fun j => tw_of (izv k j)) (2^(7-k)).

op ireduce_coeff (p : wpoly) (base len plen : int) (z_ : tw) =
  let p1 = mkseq (fun i => p.[base       + i]) plen in
  let p2 = mkseq (fun i => p.[base + len + i]) plen in
  let r1 = map (fun (x : _ * _) => x.`1 + x.`2) (zip p1 p2) in
  let r2 = map (fun (x : _ * _) => mmr (isub x.`1 x.`2) z_) (zip p1 p2) in
  (r1, r2).

op ireduce_coeff_flatten (p : wpoly) (base len : int) (z_ : tw) =
  let r = ireduce_coeff p base len len z_ in
  r.`1 ++ r.`2.

op [opaque] ireduce (p : wpoly) (base len : int) (z_ : tw) : wpoly =
  replace_ p base (ireduce_coeff_flatten p base len z_).

op ireduce_n (p : wpoly) (base len : int) (zs : tw list) =
  foldl
    (fun p i => ireduce p (base + i * 2 * len) len (nth witness zs i))
    p (range 0 (size zs)).

op ireduce_level (p : wpoly) (i : int) =
  ireduce_n p 0 (2^i) (izetaW i).

(* -------------------------------------------------------------------- *)
lemma ireduce_coeffLE (p : wpoly) (base len plen : int) (z_ : tw) :
  (ireduce_coeff p base len plen z_).`1 =
    mkseq (fun i => p.[base + i] + p.[base + len + i]) plen.
proof.
rewrite /ireduce_coeff /= zip_map /= -map_comp /(\o) /=.
by rewrite zipss -map_comp /(\o) /= -/(range 0 plen).
qed.

lemma ireduce_coeffRE (p : wpoly) (base len plen : int) (z_ : tw) :
  (ireduce_coeff p base len plen z_).`2 =
    mkseq (fun i => mmr (isub p.[base + i] p.[base + len + i]) z_) plen.
proof.
rewrite /ireduce_coeff /= zip_map /= -map_comp /(\o) /=.
by rewrite zipss -map_comp /(\o) /= -/(range 0 plen).
qed.

lemma ireduce_coeff_sizeL (p : wpoly) (base len plen : int) (z_ : tw) :
  0 <= plen => size (ireduce_coeff p base len plen z_).`1 = plen.
proof.
by move=> ? @/ireduce_coeff /=; rewrite size_map size_zip !size_mkseq /#.
qed.

lemma ireduce_coeff_sizeR (p : wpoly) (base len plen : int) (z_ : tw) :
  0 <= plen => size (ireduce_coeff p base len plen z_).`2 = plen.
proof.
by move=> ? @/ireduce_coeff /=; rewrite size_map size_zip !size_mkseq /#.
qed.

lemma ireduce_coeff_flatten_size (p : wpoly) (base len : int) (z_ : tw) :
  0 <= len => size (ireduce_coeff_flatten p base len z_) = 2 * len.
proof.
move=> ?; rewrite /ireduce_coeff_flatten /= size_cat.
by rewrite !(ireduce_coeff_sizeL, ireduce_coeff_sizeR) //#.
qed.

lemma ireduce_coeff_eqon (p p' : wpoly) (base len plen : int) (z_ : tw) :
     eqon p p' (base      ) plen
  => eqon p p' (base + len) plen
  => ireduce_coeff p base len plen z_ = ireduce_coeff p' base len plen z_.
proof.
move=> eq1 eq2 @/ireduce_coeff /=.
pose s1 := mkseq _ _; pose s2 := mkseq _ _.
pose r1 := mkseq _ _; pose r2 := mkseq _ _.
have [#] 2-> //: s1 = r1 /\ s2 = r2; split; apply: eq_in_mkseq => /=.
- by move=> i *; apply/eq1 => /#.
- by move=> i *; apply/eq2 => /#.
qed.

lemma ireduce_n0 (p : wpoly) (base len : int) : ireduce_n p base len [] = p.
proof. by rewrite /ireduce_n /= range_geq. qed.

lemma ireduce_seq1 (p : wpoly) (base len : int) (z : tw) :
  ireduce_n p base len [z] = ireduce p base len z.
proof. by rewrite /ireduce_n /= (rangeS 0). qed.

lemma ireduce_n_cat (p : wpoly) (base len : int) (zs1 zs2 : tw list) :
    ireduce_n p base len (zs1 ++ zs2)
  = ireduce_n (ireduce_n p base len zs1) (base + 2 * len * size zs1) len zs2.
proof.
rewrite {1}/ireduce_n size_cat (range_cat (size zs1)) ~-1:#smt:(size_ge0).
rewrite (range_addl 0 _ (size zs1)) addrAC /= foldl_cat.
rewrite foldl_map &(eq_in_foldl) //=; last first.
- by apply/eq_in_foldl=> //= x i /mem_range rgi; smt(nth_cat).
- by move=> x i /mem_range rgi; smt(nth_cat).
qed.

lemma ireduce_out (p : wpoly) (base len : int) (z : tw) (i : int) :
  0 <= len => 0 <= i < 256 => ! (base <= i < base + 2 * len) =>
  (ireduce p base len z).[i] = p.[i].
proof.
move=> ge0len rgi hout.
by rewrite /ireduce /replace_ filliE 1:/# ireduce_coeff_flatten_size 1:/# ifF 1:/#.
qed.

lemma ireduce_nE (p : wpoly) (base len : int) (zs : tw list) : 0 <= len =>
    ireduce_n p base len zs
  = replace_ p base (flatten (
      mkseq
      (fun i => ireduce_coeff_flatten p (base + 2 * i * len) len (nth witness zs i))
      (size zs))).
proof.
move=> ?; elim: zs p base => /= [|z zs ih] p base.
- by rewrite ireduce_n0 mkseq0.
rewrite -cat1s ireduce_n_cat ireduce_seq1.
rewrite [1+_]addzC mkseqSr 1:size_ge0 /(\o) /=.
rewrite flatten_cons replace_cat -/(ireduce _ _ _ _).
rewrite ireduce_coeff_flatten_size // ih; do 2! congr.
apply: eq_in_mkseq=> i rgi /=; rewrite ifF 1:/#.
rewrite mulrDr /= mulrDl addrA /ireduce_coeff_flatten.
pose r1 := ireduce_coeff _ _ _ _ _.
pose r2 := ireduce_coeff _ _ _ _ _.
suff ->: r1 = r2 by done.
apply: ireduce_coeff_eqon => j rgj /=;
  by case: (0 <= j < 256) => ?; [rewrite ireduce_out //# | rewrite !get_out //#].
qed.

lemma izetaW_size (k : int) : 0 <= k < 8 => size (izetaW k) = 2^(7-k).
proof. by move=> rgk; rewrite /izetaW size_mkseq; smt(expr_gt0). qed.

lemma izetaW_nth (k j : int) : 0 <= j < 2^(7-k) =>
  nth witness (izetaW k) j = tw_of (izv k j).
proof. by move=> rgj; rewrite /izetaW nth_mkseq. qed.

(* pointwise access to [ireduce_level]: block j is one merge *)
lemma ireduce_leveliE (p : wpoly) (k j t : int) :
  0 <= k < 8 => 0 <= j < 2^(7-k) => 0 <= t < 2^k =>
     (ireduce_level p k).[j * 2^(k+1) + t]
       = p.[j * 2^(k+1) + t] + p.[j * 2^(k+1) + 2^k + t]
  /\ (ireduce_level p k).[j * 2^(k+1) + 2^k + t]
       = mmr (isub p.[j * 2^(k+1) + t] p.[j * 2^(k+1) + 2^k + t]) (tw_of (izv k j)).
proof.
move=> rgk rgj rgt.
have gt0len : 0 < 2^k by apply expr_gt0.
have eSk : 2^(k+1) = 2 * 2^k by rewrite exprS 1:/#.
have e256 : 2^(7-k) * 2^(k+1) = 256.
- by rewrite -exprD_nneg 1,2:/# (: 7 - k + (k+1) = 8) 1:/# /=.
rewrite /ireduce_level (ireduce_nE p 0 (2^k)) 1:/# izetaW_size //.
pose F := fun (i : int) =>
  ireduce_coeff_flatten p (0 + 2 * i * 2^k) (2^k) (nth witness (izetaW k) i).
have hbsz : forall i, 0 <= i < 2^(7-k) => size (F i) = 2 * 2^k.
- by move=> i rgi; rewrite /F ireduce_coeff_flatten_size /#.
have hfsz : size (flatten (mkseq F (2^(7-k)))) = 256.
- rewrite size_flatten.
  have -> : map size (mkseq F (2^(7-k))) = nseq (2^(7-k)) (2 * 2^k).
  + apply (eq_from_nth witness).
    * by rewrite size_map size_mkseq size_nseq.
    move=> i; rewrite size_map size_mkseq => rgi.
    rewrite (nth_map witness) 1:size_mkseq 1:/# nth_mkseq 1:/# nth_nseq 1:/#.
    by rewrite hbsz /#.
  rewrite Bigint.sumz_nseq; first by apply expr_ge0.
  by rewrite -eSk /#.
have hx : j * 2^(k+1) + 2^(k+1) <= 256.
- have : (j + 1) * 2^(k+1) <= 2^(7-k) * 2^(k+1).
  + by apply ler_pmul2r; smt(expr_gt0).
  by rewrite e256 /#.
have hzj := izetaW_nth k j rgj.
have hnth : forall (r : int), 0 <= r < 2^(k+1) =>
    nth witness (flatten (mkseq F (2^(7-k)))) (j * 2^(k+1) + r)
  = nth witness (F j) r.
- move=> r rgr.
  rewrite (BitChunking.nth_flatten witness (2 * 2^k)).
  + by apply/List.allP=> x /mkseqP [i [rgi ->]] /=; rewrite hbsz.
  rewrite -eSk.
  have -> : (j * 2^(k+1) + r) %/ 2^(k+1) = j.
  - by rewrite divzMDl 1:#smt:(expr_gt0) pdiv_small //.
  have -> : (j * 2^(k+1) + r) %% 2^(k+1) = r by rewrite modzMDl pmod_small.
  by rewrite nth_mkseq 1:/#.
split.
- rewrite /replace_ filliE 1:/# hfsz ifT 1:/#.
  rewrite /= (: j * 2^(k+1) + t - 0 = j * 2^(k+1) + t) 1:/# hnth 1:/#.
  rewrite /F /= hzj /ireduce_coeff_flatten /= nth_cat ireduce_coeff_sizeL 1:/#.
  rewrite ifT 1:/# ireduce_coeffLE nth_mkseq 1:/# /=.
  by have -> // : 2 * j * 2^k = j * 2^(k+1) by rewrite eSk; ring.
rewrite /replace_ filliE 1:/# hfsz ifT 1:/#.
rewrite /= (: j * 2^(k+1) + 2^k + t - 0 = j * 2^(k+1) + (2^k + t)) 1:/# hnth 1:/#.
rewrite /F /= hzj /ireduce_coeff_flatten /= nth_cat ireduce_coeff_sizeL 1:/#.
rewrite ifF 1:/# ireduce_coeffRE nth_mkseq 1:/# /=.
have -> : 2^k + t - 2^k = t by ring.
have -> : 2 * j * 2^k + t = j * 2^(k+1) + t by rewrite eSk; ring.
have -> : 2 * j * 2^k + 2^k + t = j * 2^(k+1) + (2^k + t) by rewrite eSk; ring.
done.
qed.

(* -------------------------------------------------------------------- *)
(* The value of one merge, when neither the sum nor the difference      *)
(* overflows                                                            *)
lemma izv_inv (k j : int) :
  (izv k j * isgn * zpw (E k (2*j))) %% q = (-1) %% q.
proof.
have hs : isgn * isgn = 1 by smt(isgnP).
rewrite /izv (: isgn * zpw (2^(8-s) - E k (2*j)) * isgn * zpw (E k (2*j))
             = (isgn * isgn) * (zpw (2^(8-s) - E k (2*j)) * zpw (E k (2*j)))) 1:#ring hs /=.
by rewrite -zpwD (: 2^(8-s) - E k (2*j) + E k (2*j) = 2^(8-s)) 1:#ring zpw_half.
qed.

op novf (p : wpoly) (k : int) =
  forall j t, 0 <= j < 2^(7-k) => 0 <= t < 2^k =>
       `|sval p.[j * 2^(k+1) + t] + sval p.[j * 2^(k+1) + 2^k + t]| < wmax
    /\ `|sval p.[j * 2^(k+1) + 2^k + t] - sval p.[j * 2^(k+1) + t]| < wmax.

lemma ireduce_level_val (p : wpoly) (k j t : int) :
  0 <= k < 8 => novf p k => 0 <= j < 2^(7-k) => 0 <= t < 2^k =>
  let a = sval p.[j * 2^(k+1) + t] in
  let b = sval p.[j * 2^(k+1) + 2^k + t] in
     sval (ireduce_level p k).[j * 2^(k+1) + t] = a + b
  /\ sval (ireduce_level p k).[j * 2^(k+1) + 2^k + t] %% q
       = ((b - a) * zpw (2^(8-s) - E k (2*j))) %% q
  /\ `|sval (ireduce_level p k).[j * 2^(k+1) + 2^k + t]| < q.
proof.
move=> rgk hov rgj rgt /=; have [h1 h2] := hov j t rgj rgt.
have [-> ->] := ireduce_leveliE p k j t rgk rgj rgt.
rewrite svalD //; split => //; split; last by apply mmr_bnd.
rewrite mmr_cgr svalI // /izv.
have hs : forall (x y : int), isgn * x * (isgn * y) = x * y.
- move=> x y; rewrite (: isgn * x * (isgn * y) = (isgn * isgn) * (x * y)) 1:#ring.
  by rewrite (: isgn * isgn = 1) 1:#smt:(isgnP).
by rewrite hs.
qed.

(* -------------------------------------------------------------------- *)
(* The inverse tree, relative to the forward one: after the levels      *)
(* s .. k - 1, block j of level k holds 2^(k-s) times the residue       *)
op icgr (p v : wpoly) (k : int) =
  forall j t, 0 <= j < 2^(8-k) => 0 <= t < 2^k =>
    sval v.[j * 2^k + t] %% q = (2^(k-s) * nttsum p k j t) %% q.

lemma icgr_cgr (p v v' : wpoly) (k : int) :
  icgr p v k => (forall i, 0 <= i < 256 => sval v'.[i] %% q = sval v.[i] %% q) =>
  0 <= k <= 8 => icgr p v' k.
proof.
move=> hv hv' rgk j t rgj rgt; rewrite hv' ?hv //.
have : j * 2^k + t < 2^(8-k) * 2^k.
- by have := ler_pmul2r (2^k) _ (j + 1) (2^(8-k)); smt(expr_gt0).
by rewrite -exprD_nneg 1,2:/# (: 8 - k + k = 8) 1:/#; smt(expr_gt0).
qed.

lemma icgr_step (p v : wpoly) (k : int) :
  s <= k < 8 => icgr p v k => novf v k => icgr p (ireduce_level v k) (k + 1).
proof.
move=> rgk hv hov; have [ge0s _] := rg_s; have rgk0 : 0 <= k < 8 by smt().
have eSk : 2^(k+1) = 2 * 2^k by rewrite exprS 1:/#.
have eks : 2^(k+1-s) = 2 * 2^(k-s) by rewrite (: k + 1 - s = (k - s) + 1) 1:/# exprS 1:/#.
move=> j t; rewrite (: 8 - (k+1) = 7 - k) 1:/# => rgj rgt.
have e8k : 2^(8-k) = 2 * 2^(7-k) by rewrite (: 8 - k = (7 - k) + 1) 1:/# exprS 1:/#.
have hA := hv (2*j); have hB := hv (2*j+1).
case: (t < 2^k) => hcase.
- have [l1 _] := ireduce_level_val v k j t rgk0 hov rgj _; first smt().
  have eA : j * 2^(k+1) + t = 2*j * 2^k + t by rewrite eSk; ring.
  have eB : j * 2^(k+1) + 2^k + t = (2*j+1) * 2^k + t by rewrite eSk; ring.
  rewrite l1 eA eB -modzDm hA 1,2:/# hB 1,2:/# modzDm.
  have [c1 c2] := nttsum_split p k j t rgk rgj _; first smt().
  rewrite -mulrDr -modzMmr -modzDm c1 c2 modzDm modzMmr eks.
  by congr; smt().
pose t2 := t - 2^k.
have et : t = 2^k + t2 by smt().
have rgt2 : 0 <= t2 < 2^k by smt().
have [_ [l2 _]] := ireduce_level_val v k j t2 rgk0 hov rgj rgt2.
rewrite et (: j * 2^(k+1) + (2^k + t2) = j * 2^(k+1) + 2^k + t2) 1:/# l2.
have eA : j * 2^(k+1) + t2 = 2*j * 2^k + t2 by rewrite eSk; ring.
have eB : j * 2^(k+1) + 2^k + t2 = (2*j+1) * 2^k + t2 by rewrite eSk; ring.
rewrite eA eB -modzMml -modzBm hA 1,2:/# hB 1,2:/# modzBm.
have [c1 c2] := nttsum_split p k j t2 rgk rgj rgt2.
rewrite -mulrBr -(modzMmr (2^(k-s))) -modzBm c1 c2 modzBm modzMmr modzMml.
have -> : 2^(k-s) * (nttsum p (k+1) j t2 - zpw (E k (2*j)) * nttsum p (k+1) j (t2 + 2^k)
          - (nttsum p (k+1) j t2 + zpw (E k (2*j)) * nttsum p (k+1) j (t2 + 2^k)))
          * zpw (2^(8-s) - E k (2*j))
        = (- (2^(k+1-s) * nttsum p (k+1) j (2^k + t2)))
          * (zpw (2^(8-s) - E k (2*j)) * zpw (E k (2*j))).
- by rewrite eks (: t2 + 2^k = 2^k + t2) 1:#ring; ring.
rewrite -modzMmr -zpwD (: 2^(8-s) - E k (2*j) + E k (2*j) = 2^(8-s)) 1:#ring.
by rewrite zpw_half modzMmr; smt().
qed.

lemma icgr_leaves (p v : wpoly) :
  (forall j t, 0 <= j < 2^(8-s) => 0 <= t < 2^s =>
     sval v.[j * 2^s + t] %% q = nttsum p s j t %% q) =>
  icgr p v s.
proof. by move=> hv j t rgj rgt; rewrite hv //=. qed.

lemma icgr_top (p v : wpoly) (i : int) :
  icgr p v 8 => 0 <= i < 256 => sval v.[i] %% q = (2^(8-s) * sval p.[i]) %% q.
proof. by move=> hv rgi; have /= := hv 0 i _ _ => //; rewrite nttsum8. qed.

(* -------------------------------------------------------------------- *)
(* Bounds, coefficient by coefficient: a merge adds the two bounds of   *)
(* its sum and resets its product below q                               *)
op ibnd (k : int) (b : int -> int) (i : int) : int =
  if i %% 2^(k+1) < 2^k then b i + b (i + 2^k) else q.

lemma novf_bnd (p : wpoly) (k : int) (b : int -> int) :
  0 <= k < 8 =>
  (forall i, 0 <= i < 256 => `|sval p.[i]| <= b i) =>
  (forall j t, 0 <= j < 2^(7-k) => 0 <= t < 2^k =>
     b (j * 2^(k+1) + t) + b (j * 2^(k+1) + 2^k + t) < wmax) =>
  novf p k.
proof.
move=> rgk hb hw j t rgj rgt.
have e : j * 2^(k+1) + 2^k + t < 256.
- have : (j + 1) * 2^(k+1) <= 2^(7-k) * 2^(k+1) by apply ler_pmul2r; smt(expr_gt0).
  by rewrite -exprD_nneg 1,2:/# (: 7 - k + (k + 1) = 8) 1:/#; smt(expr_gt0 exprS).
have := hb (j * 2^(k+1) + t) _; first smt(expr_gt0).
have := hb (j * 2^(k+1) + 2^k + t) _; first smt(expr_gt0).
by have := hw j t rgj rgt; smt().
qed.

lemma ireduce_level_bnd (p : wpoly) (k : int) (b : int -> int) :
  0 <= k < 8 =>
  (forall i, 0 <= i < 256 => `|sval p.[i]| <= b i) =>
  (forall j t, 0 <= j < 2^(7-k) => 0 <= t < 2^k =>
     b (j * 2^(k+1) + t) + b (j * 2^(k+1) + 2^k + t) < wmax) =>
  forall i, 0 <= i < 256 => `|sval (ireduce_level p k).[i]| <= ibnd k b i.
proof.
move=> rgk hb hw i rgi; have hov := novf_bnd p k b rgk hb hw.
have gt0K : 0 < 2^(k+1) by apply expr_gt0.
have eSk : 2^(k+1) = 2 * 2^k by rewrite exprS 1:/#.
have e256 : 2^(7-k) * 2^(k+1) = 256.
- by rewrite -exprD_nneg 1,2:/# (: 7 - k + (k+1) = 8) 1:/# /=.
pose j := i %/ 2^(k+1); pose r := i %% 2^(k+1).
have hj : 0 <= j < 2^(7-k) by rewrite /j divz_ge0 // ltz_divLR // e256 /#.
have hi : i = j * 2^(k+1) + r by rewrite /j /r -divz_eq.
rewrite /ibnd -/r; case: (r < 2^k) => hr.
- have := ireduce_level_val p k j r rgk hov hj _; first smt(modz_ge0).
  rewrite -hi /= => -[-> _].
  have := hb i rgi; have := hb (j * 2^(k+1) + 2^k + r) _; first smt().
  by rewrite (: j * 2^(k+1) + 2^k + r = i + 2^k) 1:/#; smt().
have := ireduce_level_val p k j (r - 2^k) rgk hov hj _; first smt(modz_ge0).
by rewrite (: j * 2^(k+1) + 2^k + (r - 2^k) = i) 1:/# /= => -[_ [_ h]]; smt().
qed.

end NttTreeT.
