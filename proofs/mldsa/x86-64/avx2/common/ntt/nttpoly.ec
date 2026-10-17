(**
  The polynomial view of the NTT correctness results
  (M2 of nttalg-abstraction.md).

  Word arrays are linked to polynomials over Zq in the ambient logic:
  `pofw a` is the polynomial with coefficients `inzmod (to_sint a.[i])`.
  The forward invariant of the tree (`reduce_tree_alg`, instantiated in
  `Nttspec`) is restated as a congruence of `Crspoly`:

      peqm (basis k j) (pofw p) (pofw_blk (reduce_tree p k) (j*2^k) (2^k))

  where `basis k j = X^(2^k) - C (zZ ^ E k j)` -- block (k, j) of the
  butterfly network is the residue of P modulo the basis element.
  At k = 0 this is evaluation:

      peval (pofw p) (zZ ^ E 0 j) = inzmod (to_sint (ntt p).[j]).

  Everything here is *derived* from the int-level theorems; no program
  or butterfly reasoning is redone.  The constructive core is
  `xnp_fold`: reduction of a coefficient list modulo X^n - c, by
  induction on the list of n-chunks, with the residue coefficients
  produced directly in the `nttsum` shape.
*)

(* ==================================================================== *)
require import AllCore List Ring IntDiv BitEncoding StdOrder StdBigop.
(*---*) import Bigint BIA IntOrder.

(* -------------------------------------------------------------------- *)
require import Nttlogspec Nttspec Nttzetas Inttalg.
require import Crspoly.
(*---*) import Zq ZqP ZqP.BigCf ZqP.Lagrange ZqCA.

(* -------------------------------------------------------------------- *)
from Jasmin require import JUtils JWord.

(* -------------------------------------------------------------------- *)
require import Array256.

(* ==================================================================== *)
(* Bridges between int congruences mod q and Zq                         *)
(* ==================================================================== *)
lemma inzmod_exp (x n : int) : 0 <= n =>
  Zq.inzmod (x ^ n) = Zq.ZModpRing.exp (Zq.inzmod x) n.
proof.
elim: n => [|n ge0n ih].
- by rewrite Ring.IntID.expr0 Zq.ZModpRing.expr0.
rewrite Ring.IntID.exprS // Zq.ZModpRing.exprS //.
by rewrite Zq.inzmodM ih.
qed.

lemma inzmod0 : Zq.inzmod 0 = Zq.zero.
proof.
apply Zq.asint_inj.
by rewrite Zq.inzmodK Zq.zeroE mod0z.
qed.

lemma inzmod_sum (f : int -> int) (a b : int) :
  Zq.inzmod (BIA.bigi predT f a b)
    = BCA.bigi predT (fun i => Zq.inzmod (f i)) a b.
proof.
have h : forall (s : int list),
  Zq.inzmod (BIA.big predT f s) = BCA.big predT (fun i => Zq.inzmod (f i)) s.
- elim=> [|x s ih].
  - by rewrite BIA.big_nil BCA.big_nil inzmod0.
  rewrite BIA.big_cons BCA.big_cons /predT /=.
  by rewrite Zq.inzmodD ih.
by apply h.
qed.

(* zeta_ in Zq *)
op zZ : Zq.zmod = Zq.inzmod zeta_.

lemma inzmod_zpw (e : int) : 0 <= e =>
  Zq.inzmod (zpw e) = Zq.ZModpRing.exp zZ e.
proof.
move=> ge0e.
rewrite /zpw /zZ.
rewrite -(inzmod_exp zeta_ e ge0e).
rewrite -Zq.eq_inzmod.
by apply zexp_modE.
qed.

(* ==================================================================== *)
(* The linking ops                                                      *)
(* ==================================================================== *)
op pofw (a : wpoly) : poly =
  polyL (mkseq (fun i => Zq.inzmod (sval a.[i])) 256).

op pofw_blk (a : wpoly) (base len : int) : poly =
  polyL (mkseq (fun t => Zq.inzmod (sval a.[base + t])) len).

(* the moduli *)
op xnp (n : int) (c : Zq.zmod) : poly =
  exp X n - polyC c.

op basis (k j : int) : poly =
  xnp (2^k) (Zq.ZModpRing.exp zZ (E k j)).

(* the residue polynomial, coefficients in the nttsum shape *)
op nttsump (p : wpoly) (k j : int) : poly =
  polyL (mkseq (fun t => Zq.inzmod (nttsum p k j t)) (2^k)).

(* ==================================================================== *)
(* polyL structure                                                      *)
(* ==================================================================== *)
lemma polyL_cat (xs ys : Zq.zmod list) :
  polyL (xs ++ ys) = polyL xs + exp X (size xs) * polyL ys.
proof.
elim: xs => [|c xs ih].
- by rewrite cat0s polyL_nil /= expr0 mul1r.
rewrite cat_cons !polyL_cons ih /=.
rewrite mulrDl -!addrA.
congr.
congr.
rewrite (addzC 1 (size xs)) exprS 1:size_ge0.
rewrite -mulrA [polyL ys * X]mulrC.
rewrite !mulrA.
congr.
by rewrite mulrC.
qed.

(* pointwise sum and scaling of equal-length coefficient lists *)
lemma polyL_add (f g : int -> Zq.zmod) (n : int) :
  polyL (mkseq f n) + polyL (mkseq g n)
    = polyL (mkseq (fun i => f i + g i) n).
proof.
apply poly_eqP => i ge0.
rewrite polyDE !polyLE.
case (i < n) => hcase.
- by rewrite !nth_mkseq //#.
rewrite !nth_default ?size_mkseq 1,2,3:/#.
by rewrite Zq.ZModpRing.addr0.
qed.

lemma polyL_scale (c : Zq.zmod) (f : int -> Zq.zmod) (n : int) :
  polyC c * polyL (mkseq f n) = polyL (mkseq (fun i => c * f i) n).
proof.
rewrite -scalepE.
apply poly_eqP => i ge0.
rewrite polyZE !polyLE.
case (i < n) => hcase.
- by rewrite !nth_mkseq //#.
rewrite !nth_default ?size_mkseq 1,2:/#.
by rewrite Zq.ZModpRing.mulr0.
qed.

(* ==================================================================== *)
(* Reduction modulo X^n - c                                             *)
(* ==================================================================== *)
lemma xnp_Xn (n : int) (c : Zq.zmod) :
  peqm (xnp n c) (exp X n) (polyC c).
proof.
by exists poly1; rewrite mul1r /xnp.
qed.

(* one chunk: X^n f1 + f0 == c f1 + f0 *)
lemma xnp_chunk (n : int) (c : Zq.zmod) (xs ys : Zq.zmod list) :
  size xs = n =>
  peqm (xnp n c) (polyL (xs ++ ys)) (polyL xs + polyC c * polyL ys).
proof.
move=> hsz.
rewrite polyL_cat hsz.
apply eqmD.
- by apply eqm_refl.
apply eqmM.
- by apply xnp_Xn.
by apply eqm_refl.
qed.

(* the fold: a (n*m)-coefficient list reduces to the n-coefficient
   residue, whose entries come out directly as Horner sums *)
lemma xnp_fold (n m : int) (c : Zq.zmod) (g : int -> Zq.zmod) :
  0 < n => 0 <= m =>
  peqm (xnp n c)
    (polyL (mkseq g (n * m)))
    (polyL (mkseq
       (fun t => BCA.bigi predT
                   (fun s => Zq.ZModpRing.exp c s * g (s * n + t)) 0 m)
       n)).
proof.
move=> gt0n ge0m.
elim: m ge0m g => [|m ge0m ih] g.
- rewrite (: n * 0 = 0) 1:/# mkseq0 polyL_nil.
  have -> : mkseq
      (fun t => BCA.bigi predT
         (fun s => Zq.ZModpRing.exp c s * g (s * n + t)) 0 0) n
    = mkseq (fun (_ : int) => Zq.zero) n.
  + apply eq_in_mkseq => t rgt /=.
    by rewrite BCA.big_geq.
  have -> : polyL (mkseq (fun (_ : int) => Zq.zero) n) = poly0.
  + apply poly_eqP => i ge0.
    rewrite polyLE poly0E.
    case (i < n) => hc.
    - by rewrite nth_mkseq //#.
    by rewrite nth_default ?size_mkseq /#.
  by apply eqm_refl.
rewrite (: n * (m + 1) = n + n * m) 1:/#.
rewrite mkseq_add 1,2:/#.
apply (eqm_trans _
  (polyL (mkseq g n) + polyC c * polyL (mkseq (fun i => g (n + i)) (n * m)))).
- apply xnp_chunk.
  by rewrite size_mkseq /#.
apply (eqm_trans _
  (polyL (mkseq g n) + polyC c * polyL (mkseq
     (fun t => BCA.bigi predT
        (fun s => Zq.ZModpRing.exp c s * g (n + (s * n + t))) 0 m) n))).
- apply eqmD.
  - by apply eqm_refl.
  apply eqmM.
  - by apply eqm_refl.
  by apply ih.
apply eqm_eq.
rewrite polyL_scale polyL_add.
congr.
apply eq_in_mkseq => t rgt /=.
rewrite BCA.big_int_recl 1:// /=.
congr.
- by rewrite Zq.ZModpRing.expr0 Zq.ZModpRing.mul1r.
rewrite BCA.mulr_sumr.
apply BCA.eq_big_int => s rgs /=.
rewrite Zq.ZModpRing.exprS 1:/#.
rewrite !Zq.ZModpRing.mulrA.
congr.
by rewrite (: (s + 1) * n + t = n + (s * n + t)) 1:/#.
qed.

(* ==================================================================== *)
(* The forward restatement                                              *)
(* ==================================================================== *)
(* the input polynomial is congruent to the nttsum polynomial *)
lemma pofw_nttsump (p : wpoly) (k j : int) :
  0 <= k <= 8 => 0 <= j < 2^(8-k) =>
  peqm (basis k j) (pofw p) (nttsump p k j).
proof.
move=> rgk rgj.
have e256 : 2^k * 2^(8-k) = 256.
- by rewrite -exprD_nneg 1,2:/# (: k + (8 - k) = 8) 1:/# /=.
have gt0n : 0 < 2^k by apply expr_gt0.
have := xnp_fold (2^k) (2^(8-k)) (Zq.ZModpRing.exp zZ (E k j))
  (fun i => Zq.inzmod (sval p.[i])) gt0n _; 1: by apply expr_ge0.
rewrite e256 -/(pofw p) -/(basis k j).
move=> h.
apply (eqm_trans _
  (polyL (mkseq
     (fun t => BCA.bigi predT
        (fun s => Zq.ZModpRing.exp (Zq.ZModpRing.exp zZ (E k j)) s
                  * Zq.inzmod (sval p.[s * 2^k + t])) 0 (2^(8-k)))
     (2^k)))).
- by apply h.
apply eqm_eq.
rewrite /nttsump.
congr.
apply eq_in_mkseq => t rgt /=.
rewrite /nttsum inzmod_sum.
apply BCA.eq_big_int => s rgs /=.
rewrite Zq.inzmodM.
congr.
rewrite inzmod_zpw 1:#smt:(E_range).
by rewrite Zq.ZModpRing.exprM.
qed.

(* block (k, j) of the butterfly network is the residue of P *)
lemma reduce_tree_polyP (p : wpoly) (B k j : int) :
  0 <= k <= 8 => 0 <= B => B + (8 - k) * q < 2^31 => cbnd p B =>
  0 <= j < 2^(8-k) =>
  peqm (basis k j)
    (pofw p)
    (pofw_blk (reduce_tree p k) (j * 2^k) (2^k)).
proof.
move=> rgk ge0B hB hbnd rgj.
apply (eqm_trans _ (nttsump p k j)).
- by apply pofw_nttsump.
apply eqm_eq.
rewrite /nttsump /pofw_blk.
congr.
apply eq_in_mkseq => t rgt /=.
have [_ hs] := reduce_tree_alg p B k rgk ge0B hB hbnd.
apply Zq.eq_inzmod.
by rewrite (hs j t rgj rgt).
qed.

(* congruence modulo a linear factor determines the evaluation *)
lemma peqm_lin_eval (u v : poly) (a : Zq.zmod) :
  peqm (X - polyC a) u v => peval u a = peval v a.
proof.
move=> h.
have hroot : root (X - polyC a) a.
- by rewrite pevalB pevalX pevalC Zq.ZModpRing.subrr.
have := peqm_root (X - polyC a) u v a h hroot.
rewrite pevalB.
by rewrite Zq.ZModpRing.subr_eq0.
qed.

lemma polyL1 (x : Zq.zmod) : polyL [x] = polyC x.
proof.
rewrite polyL_cons polyL_nil.
by rewrite mul0r addr0.
qed.

(* at the leaves, congruence modulo X - c is evaluation *)
lemma ntt_evalP (p : wpoly) (B j : int) :
  0 <= B => B + 8 * q < 2^31 => cbnd p B =>
  0 <= j < 256 =>
  peval (pofw p) (Zq.ZModpRing.exp zZ (E 0 j))
    = Zq.inzmod (sval (reduce_tree p 0).[j]).
proof.
move=> ge0B hB hbnd rgj.
have c1 : 0 <= 0 <= 8 by done.
have c2 : B + (8 - 0) * q < 2^31 by move: hB => /#.
have c3 : 0 <= j < 2^(8-0) by move: rgj => /= /#.
have h := reduce_tree_polyP p B 0 j c1 ge0B c2 hbnd c3.
move: h.
rewrite /basis /xnp /= expr1.
move/peqm_lin_eval => ->.
rewrite /pofw_blk.
have -> : mkseq
    (fun t => Zq.inzmod (sval (reduce_tree p 0).[j * 2^0 + t])) (2^0)
  = [Zq.inzmod (sval (reduce_tree p 0).[j])].
- apply (eq_from_nth witness).
  - by rewrite size_mkseq /=.
  move=> i; rewrite size_mkseq /= => rgi.
  rewrite nth_mkseq 1:/# /=.
  have -> : i = 0 by smt().
  by rewrite ifT // /#.
by rewrite polyL1 pevalC.
qed.

(* ==================================================================== *)
(* The ML-DSA CRS instance (M3): the basis elements are products of     *)
(* monomials with globally distinct roots, and their product is         *)
(* X^256 + 1                                                            *)
(* ==================================================================== *)
(* the leaf roots under block (k, j) *)
op leafroots (k j : int) : Zq.zmod list =
  mkseq (fun t => Zq.ZModpRing.exp zZ (E 0 (j * 2^k + t))) (2^k).

(* zZ facts, bridged from the int level *)
lemma zZ_exp_cgr (e1 e2 : int) :
  0 <= e1 => 0 <= e2 => e1 %% 512 = e2 %% 512 =>
  Zq.ZModpRing.exp zZ e1 = Zq.ZModpRing.exp zZ e2.
proof.
move=> ge1 ge2 hcgr.
rewrite -(inzmod_zpw e1) // -(inzmod_zpw e2) //.
by rewrite (zpw_cgr_exp e1 e2).
qed.

lemma inzmod1 : Zq.inzmod 1 = Zq.one.
proof.
apply Zq.asint_inj.
rewrite Zq.inzmodK Zq.oneE.
by rewrite pmod_small //; smt(gt0_q lt_q_2p23).
qed.

lemma zZ_256 : Zq.ZModpRing.exp zZ 256 = - Zq.one.
proof.
rewrite -(inzmod_zpw 256) //.
have -> : Zq.inzmod (zpw 256) = Zq.inzmod (-1).
- by rewrite -Zq.eq_inzmod zpw_256.
by rewrite Zq.inzmodN inzmod1.
qed.

lemma zZ_512 : Zq.ZModpRing.exp zZ 512 = Zq.one.
proof.
by rewrite -(inzmod_zpw 512) //.
qed.

lemma zZ_oppE (e : int) : 0 <= e =>
  Zq.ZModpRing.exp zZ (e + 256) = - Zq.ZModpRing.exp zZ e.
proof.
move=> ge0e.
rewrite Zq.ZModpRing.exprD_nneg 1:// 1://.
by rewrite zZ_256 Zq.ZModpRing.mulrN1.
qed.

(* one split of the CRT tree, as a polynomial identity *)
lemma basis_split (k j : int) : 0 <= k < 8 => 0 <= j < 2^(7-k) =>
  basis (k+1) j = basis k (2*j) * basis k (2*j+1).
proof.
move=> rgk rgj.
have e8k : 2^(8-k) = 2 * 2^(7-k).
- by rewrite (: 8 - k = (7-k)+1) 1:/# exprS 1:/#.
have rg2j : 0 <= 2*j < 2^(8-k) by smt().
have ge0E : 0 <= E k (2*j) by smt(E_range).
rewrite /basis (E_odd k j) //.
rewrite (zZ_oppE (E k (2*j))) //.
have -> : Zq.ZModpRing.exp zZ (E (k+1) j)
        = Zq.ZModpRing.exp zZ (E k (2*j)) * Zq.ZModpRing.exp zZ (E k (2*j)).
- rewrite -Zq.ZModpRing.exprD_nneg 1,2://.
  apply zZ_exp_cgr; 1,2: smt(E_range).
  by rewrite (: E k (2*j) + E k (2*j) = 2 * E k (2*j)) 1:/# E_double.
rewrite /xnp.
have eSk : 2^(k+1) = 2^k + 2^k by rewrite exprS 1:/# /#.
rewrite eSk exprD_nneg 1,2:#smt:(expr_ge0).
pose A := exp X (2^k).
pose w := Zq.ZModpRing.exp zZ (E k (2*j)).
rewrite polyCN opprK.
rewrite mulrDr !mulrBl.
rewrite polyCM.
rewrite [polyC w * A]mulrC.
by rewrite addrA subrK.
qed.

(* the basis elements are products of monomials over the leaf roots *)
lemma basis_leaves (k j : int) : 0 <= k <= 8 => 0 <= j < 2^(8-k) =>
  basis k j = mprod (leafroots k j).
proof.
have main : forall kk, 0 <= kk <= 8 => forall jj, 0 <= jj < 2^(8-kk) =>
  basis kk jj = mprod (leafroots kk jj).
- elim/natind => [{k j} k le0k | {k j} k ge0k ih] rgk j rgj.
  + have ->> : k = 0 by smt().
    rewrite /leafroots.
    have -> : mkseq (fun t => Zq.ZModpRing.exp zZ (E 0 (j * 2^0 + t))) (2^0)
            = [Zq.ZModpRing.exp zZ (E 0 j)].
    * apply (eq_from_nth witness).
      - by rewrite size_mkseq /=.
      move=> i; rewrite size_mkseq /= => rgi.
      rewrite nth_mkseq 1:/# /=.
      have -> : i = 0 by smt().
      by rewrite ifT // /#.
    rewrite mprod_cons mprod_nil mulr1.
    by rewrite /basis /xnp /= expr1.
  have rgk8 : 0 <= k < 8 by smt().
  have e8k : 2^(8-k) = 2 * 2^(7-k).
  + by rewrite (: 8 - k = (7-k)+1) 1:/# exprS 1:/#.
  have rgj7 : 0 <= j < 2^(7-k) by move: rgj; rewrite (: 8 - (k+1) = 7 - k) 1:/#.
  rewrite basis_split //.
  rewrite (ih _ (2*j)) 1:/# 1:/#.
  rewrite (ih _ (2*j+1)) 1:/# 1:/#.
  rewrite -mprod_cat.
  congr.
  rewrite /leafroots.
  have eSk : 2^(k+1) = 2^k + 2^k by rewrite exprS 1:/# /#.
  rewrite eSk mkseq_add 1,2:#smt:(expr_ge0).
  congr.
  + apply eq_in_mkseq => t rgt /=.
    by rewrite (: j * (2^k + 2^k) + t = 2*j * 2^k + t) 1:/#.
  apply eq_in_mkseq => t rgt /=.
  by rewrite (: j * (2^k + 2^k) + (2^k + t) = (2*j+1) * 2^k + t) 1:/#.
move=> rgk rgj.
by apply (main k rgk j rgj).
qed.

(* the root of the tree is X^256 + 1 *)
lemma basisX256 : basis 8 0 = exp X 256 + poly1.
proof.
rewrite /basis /xnp /=.
have -> : E 8 0 = 256 by rewrite /E.
by rewrite zZ_256 polyCN opprK.
qed.

(* ==================================================================== *)
(* Distinctness of the leaf roots                                       *)
(* ==================================================================== *)
lemma bitrev_invol (x : int) : 0 <= x < 256 => bitrev (bitrev x) = x.
proof.
move=> rgx.
rewrite /bitrev /=.
have -> : BS2Int.int2bs 8 (BS2Int.bs2int (rev (BS2Int.int2bs 8 x)))
        = rev (BS2Int.int2bs 8 x).
- have := BS2Int.bs2intK (rev (BS2Int.int2bs 8 x)).
  by rewrite size_rev BS2Int.size_int2bs /=.
rewrite revK.
by rewrite BS2Int.int2bsK // /=.
qed.

lemma E0_inj (j1 j2 : int) :
  0 <= j1 < 256 => 0 <= j2 < 256 => E 0 j1 = E 0 j2 => j1 = j2.
proof.
move=> rg1 rg2.
rewrite /E !ifF 1,2:// /= => heq.
have hpar : j1 %% 2 = j2 %% 2 by smt(bitrev8_rg).
have hbr : bitrev (j1 %/ 2 + 128) = bitrev (j2 %/ 2 + 128) by smt(bitrev8_rg).
have h2 : bitrev (bitrev (j1 %/ 2 + 128)) = bitrev (bitrev (j2 %/ 2 + 128)).
- by rewrite hbr.
have e1 : bitrev (bitrev (j1 %/ 2 + 128)) = j1 %/ 2 + 128.
- by apply bitrev_invol; smt().
have e2 : bitrev (bitrev (j2 %/ 2 + 128)) = j2 %/ 2 + 128.
- by apply bitrev_invol; smt().
by smt().
qed.

(* odd-part decomposition *)
lemma odd_part (d : int) : 0 < d =>
  exists s u, 0 <= s /\ 0 < u /\ u %% 2 = 1 /\ d = 2^s * u.
proof.
have h2d : forall n, 0 <= n => n < 2^n.
- elim/natind => [n le0n ge0n | n ge0n ihn]; 1: smt(expr_gt0).
  have e : 2^(n+1) = 2 * 2^n by rewrite exprS 1:/#.
  by smt(expr_gt0).
have main : forall K, 0 <= K => forall dd, 0 < dd < 2^K =>
  exists s u, 0 <= s /\ 0 < u /\ u %% 2 = 1 /\ dd = 2^s * u.
- elim/natind => [{d} K le0K | {d} K ge0K ih] rgK d rgd.
  + have ->> : K = 0 by smt().
    by move: rgd => /= /#.
  case (d %% 2 = 1) => hpar.
  + exists 0 d.
    by move: rgd => /=; smt().
  have eS : 2^(K+1) = 2 * 2^K by rewrite exprS 1:/#.
  have hrec : 0 < d %/ 2 < 2^K by smt().
  have hih := ih ge0K (d %/ 2) hrec.
  case: hih => s u [ge0s [gt0u [hu hdu]]].
  exists (s+1) u.
  have eS2 : 2^(s+1) = 2 * 2^s by rewrite exprS 1:/#.
  by smt().
move=> gt0d.
apply (main d _ d _); 1: smt().
split; 1: smt().
move=> _.
by apply h2d; smt().
qed.

(* zeta has no nontrivial 512-th "sub-root" of unity: for 0 < d < 512,
   zZ^d <> 1 -- by the odd-part trick, (zZ^(2^8))^odd = -1 <> 1 *)
lemma zZ_pow_neq1 (d : int) : 0 < d < 512 =>
  Zq.ZModpRing.exp zZ d <> Zq.one.
proof.
move=> rgd.
have hop := odd_part d _; 1: smt().
case: hop => s u [ge0s [gt0u [hodd hd]]].
have hs : s <= 8.
- case (9 <= s) => hge; last by smt().
  have h9 : 2^9 <= 2^s by apply IntOrder.ler_weexpn2l => /#.
  have e9 : 2^9 = 512 by rewrite /=.
  have hle : 2^s <= d.
  + rewrite hd.
    have := IntOrder.ler_pmul2l (2^s) _ 1 u; 1: smt(expr_gt0).
    by smt().
  by smt().
apply /negP => heq1.
have e1 : Zq.ZModpRing.exp zZ (d * 2^(8-s)) = Zq.one.
- rewrite Zq.ZModpRing.exprM heq1.
  by rewrite Zq.ZModpRing.expr1z.
have e2 : Zq.ZModpRing.exp zZ (d * 2^(8-s)) = - Zq.one.
- have -> : d * 2^(8-s) = 256 * u.
  + rewrite hd (: 2^s * u * 2^(8-s) = 2^s * 2^(8-s) * u) 1:/#.
    rewrite -exprD_nneg 1:// 1:/#.
    by rewrite (: s + (8 - s) = 8) 1:/# /=.
  rewrite Zq.ZModpRing.exprM zZ_256.
  (* (- one)^u = - one for odd u *)
  have -> : u = 2 * (u %/ 2) + 1 by smt().
  rewrite Zq.ZModpRing.exprD_nneg 1:/# 1://.
  rewrite Zq.ZModpRing.expr1 (mulzC 2) Zq.ZModpRing.exprM.
  rewrite -Zq.ZModpRing.exprM (mulzC (u %/ 2) 2) Zq.ZModpRing.exprM.
  have -> : Zq.ZModpRing.exp (- Zq.one) 2 = Zq.one.
  + by rewrite Zq.ZModpRing.expr2 Zq.ZModpRing.mulrNN Zq.ZModpRing.mul1r.
  by rewrite Zq.ZModpRing.expr1z Zq.ZModpRing.mul1r.
(* impossible: 1 = q - 1 would give q = 2 *)
move: e1; rewrite e2 => heq.
have : Zq.asint (- Zq.one) = Zq.asint Zq.one by rewrite heq.
rewrite Zq.oneE Zq.oppE Zq.oneE.
by rewrite /q /=.
qed.

lemma zZ_exp_inj (e1 e2 : int) :
  0 <= e1 < 512 => 0 <= e2 < 512 =>
  Zq.ZModpRing.exp zZ e1 = Zq.ZModpRing.exp zZ e2 => e1 = e2.
proof.
have main : forall e1 e2, 0 <= e1 < 512 => 0 <= e2 < 512 => e1 <= e2 =>
  Zq.ZModpRing.exp zZ e1 = Zq.ZModpRing.exp zZ e2 => e1 = e2.
- move=> f1 f2 rg1 rg2 hle heq.
  case (f1 = f2) => // hne.
  have hnz : Zq.ZModpRing.exp zZ f1 <> Zq.zero.
  + apply /negP => h0.
    have h512 : Zq.ZModpRing.exp zZ 512 = Zq.zero.
    * have -> : 512 = f1 + (512 - f1) by smt().
      rewrite Zq.ZModpRing.exprD_nneg 1:/# 1:/#.
      by rewrite h0 Zq.ZModpRing.mul0r.
    have := zZ_512.
    rewrite h512 => h01.
    have := Zq.ZModpRing.oner_neq0.
    by rewrite -h01.
  have hsplit : Zq.ZModpRing.exp zZ f2
              = Zq.ZModpRing.exp zZ f1 * Zq.ZModpRing.exp zZ (f2 - f1).
  + have {1}-> : f2 = f1 + (f2 - f1) by ring.
    by rewrite Zq.ZModpRing.exprD_nneg 1:/# 1:/#.
  have hzero : Zq.ZModpRing.exp zZ f1
               * (Zq.one - Zq.ZModpRing.exp zZ (f2 - f1)) = Zq.zero.
  + rewrite Zq.ZModpRing.mulrBr Zq.ZModpRing.mulr1.
    by rewrite -hsplit heq Zq.ZModpRing.subrr.
  move: hzero.
  rewrite Zq.ZModpFieldMx.mulf_eq0.
  case=> [h0|hz]; 1: by smt().
  have h1 : Zq.ZModpRing.exp zZ (f2 - f1) = Zq.one.
  + by smt(@Zq.ZModpRing).
  have := zZ_pow_neq1 (f2 - f1) _; 1: smt().
  by rewrite h1.
move=> rg1 rg2 heq.
case (e1 <= e2) => hle.
- by apply main.
have := main e2 e1 rg2 rg1 _ _; 1,2: smt().
by smt().
qed.

lemma uniq_leafroots : uniq (leafroots 8 0).
proof.
rewrite /leafroots /mkseq.
rewrite map_inj_in_uniq ?iota_uniq //.
move=> x y /mem_iota hx /mem_iota hy /= heq.
have hE : E 0 x = E 0 y.
- apply zZ_exp_inj => //; 1,2: smt(E_range).
apply E0_inj.
- by move: hx => /#.
- by move: hy => /#.
by apply hE.
qed.

(* ==================================================================== *)
(* The gluing corollary: congruent on all 256 leaves =>                 *)
(* congruent modulo X^256 + 1                                           *)
(* ==================================================================== *)
lemma leaf_glue (u v : poly) :
  (forall j, 0 <= j < 256 => peqm (basis 0 j) u v) =>
  peqm (exp X 256 + poly1) u v.
proof.
move=> hleaf.
rewrite -basisX256 (basis_leaves 8 0) 1:// 1:/#.
apply peqm_mprod; first by apply uniq_leafroots.
move=> r /mkseqP [jj [rgj ->]] /=.
have rgj' : 0 <= jj < 256 by move: rgj => /#.
have := hleaf jj rgj'.
by rewrite /basis /xnp /= expr1.
qed.

(* the converse (CRT-tree descend): each leaf is a factor of X^256 + 1 *)
lemma leaf_descend (u v : poly) :
  peqm (exp X 256 + poly1) u v =>
  forall j, 0 <= j < 256 => peqm (basis 0 j) u v.
proof.
move=> h j rgj.
have hmem : Zq.ZModpRing.exp zZ (E 0 j) \in leafroots 8 0.
- rewrite /leafroots.
  apply/mkseqP.
  exists j => /=.
  by smt().
have [q hq] := mprod_mem_factor (leafroots 8 0) (Zq.ZModpRing.exp zZ (E 0 j)) hmem.
have hb : basis 0 j = X - polyC (Zq.ZModpRing.exp zZ (E 0 j)).
- by rewrite /basis /xnp /= expr1.
rewrite hb.
apply (eqm_mulm _ q).
rewrite -hq -(basis_leaves 8 0) 1:// 1:/# basisX256.
by apply h.
qed.

(* ==================================================================== *)
(* Inverse restatement: the code's inverse output represents 2^32 * p   *)
(* as an equality of polynomials                                        *)
(* ==================================================================== *)
lemma pofw_eval0 (p : wpoly) (j : int) :
  0 <= j < 256 =>
  peval (pofw p) (Zq.ZModpRing.exp zZ (E 0 j)) = Zq.inzmod (nttsum p 0 j 0).
proof.
move=> rgj.
have hpm := pofw_nttsump p 0 j _ _; 1: done; 1: by move: rgj => /#.
have hb : basis 0 j = X - polyC (Zq.ZModpRing.exp zZ (E 0 j)).
- by rewrite /basis /xnp /= expr1.
move: hpm; rewrite hb => hpm.
rewrite (peqm_lin_eval _ (nttsump p 0 j)) 1://.
rewrite /nttsump /=.
rewrite (: mkseq (fun t => Zq.inzmod (nttsum p 0 j t)) 1
           = [Zq.inzmod (nttsum p 0 j 0)]) 1:mkseq1 1://.
by rewrite polyL1 pevalC.
qed.

lemma intt_polyP (p v : wpoly) (B : int) :
  q <= B => 2^8 * B < 2^31 => cbnd v B =>
  (forall i, 0 <= i < 256 => sval v.[i] %% q = nttsum p 0 i 0 %% q) =>
  pofw (iscale (invtree v 8)) = polyC (Zq.inzmod (2^32)) * pofw p.
proof.
move=> leqB hB hbnd hv.
have [_ hs] := intt_ntt_alg p v B leqB hB hbnd hv.
rewrite /pofw polyL_scale.
apply poly_eqP => i ge0i.
rewrite !polyLE.
case (i < 256) => hcase.
- rewrite !nth_mkseq 1,2:/# /=.
  rewrite -Zq.inzmodM.
  rewrite -Zq.eq_inzmod.
  by rewrite hs 1:/#.
by rewrite !nth_default ?size_mkseq 1,2:/#.
qed.

(* same, with the hypothesis in the algebraic view: v holds the         *)
(* evaluations of pofw p at the 256 leaf roots                          *)
lemma intt_poly_algP (p v : wpoly) (B : int) :
  q <= B => 2^8 * B < 2^31 => cbnd v B =>
  (forall j, 0 <= j < 256 =>
     Zq.inzmod (sval v.[j]) = peval (pofw p) (Zq.ZModpRing.exp zZ (E 0 j))) =>
  pofw (iscale (invtree v 8)) = polyC (Zq.inzmod (2^32)) * pofw p.
proof.
move=> leqB hB hbnd halg.
apply (intt_polyP p v B) => //.
move=> i rgi.
rewrite Zq.eq_inzmod.
by rewrite halg 1:// pofw_eval0.
qed.

(* ==================================================================== *)
(* Ring-morphism properties: evaluation at the leaf roots is injective  *)
(* on degree < 257, and pointwise products glue to the product modulo   *)
(* X^256 + 1                                                            *)
(* ==================================================================== *)
lemma basis0E (j : int) :
  basis 0 j = X - polyC (Zq.ZModpRing.exp zZ (E 0 j)).
proof.
by rewrite /basis /xnp /= expr1.
qed.

lemma degX256 : deg (exp X 256 + poly1) = 257.
proof.
have hX : deg (exp X 256) = 257.
- rewrite degXn_proper.
  + by rewrite lcX; apply /Zq.ZModpFieldMx.Dom.lregP; apply Zq.ZModpRing.oner_neq0.
  + by done.
  by rewrite degX.
by rewrite degDl hX // deg1.
qed.

lemma deg_pofw (a : wpoly) : deg (pofw a) <= 256.
proof.
rewrite /pofw.
have := degL_le (mkseq (fun i => Zq.inzmod (sval a.[i])) 256).
by rewrite size_mkseq.
qed.

(* injectivity of the evaluation map on representatives *)
lemma peval_leaf_inj (u v : poly) :
  deg u <= 256 => deg v <= 256 =>
  (forall j, 0 <= j < 256 =>
     peval u (Zq.ZModpRing.exp zZ (E 0 j))
       = peval v (Zq.ZModpRing.exp zZ (E 0 j))) =>
  u = v.
proof.
move=> hu hv hev.
apply (peqm_deg_eq (exp X 256 + poly1)).
- by rewrite degX256 /#.
- by rewrite degX256 /#.
apply leaf_glue => j rgj.
rewrite basis0E.
by apply peqm_lin_root; apply hev.
qed.

(* the basemul theorem: pointwise products at the leaf roots represent  *)
(* the product modulo X^256 + 1                                         *)
lemma peval_mul_glue (w u v : poly) :
  (forall j, 0 <= j < 256 =>
     peval w (Zq.ZModpRing.exp zZ (E 0 j))
       = peval u (Zq.ZModpRing.exp zZ (E 0 j))
       * peval v (Zq.ZModpRing.exp zZ (E 0 j))) =>
  peqm (exp X 256 + poly1) w (u * v).
proof.
move=> hev.
apply leaf_glue => j rgj.
rewrite basis0E.
apply peqm_lin_root.
by rewrite pevalM hev.
qed.

(* ==================================================================== *)
(* The pointwise (NTT-domain) multiplication of the code (pwmul, cf.    *)
(* pointwise_montgomery_multiply_and_reduce) in the algebraic view      *)
(* ==================================================================== *)
lemma pwmul_cgr (a b : wpoly) (j : int) :
  0 <= j < 256 =>
  (2^32 * sval ((pwmul a b).[j])) %% q = (sval a.[j] * sval b.[j]) %% q.
proof.
move=> rgj.
rewrite /pwmul initiE //=.
by apply mmr_mont.
qed.

(* on inputs holding the evaluations of pofw p1, pofw p2 at the leaf    *)
(* roots, pwmul returns (2^-32 times) their pointwise products -- the   *)
(* hypothesis shape consumed by peval_mul_glue                          *)
lemma pwmul_evalP (p1 p2 v1 v2 : wpoly) :
  (forall j, 0 <= j < 256 =>
     Zq.inzmod (sval v1.[j]) = peval (pofw p1) (Zq.ZModpRing.exp zZ (E 0 j))) =>
  (forall j, 0 <= j < 256 =>
     Zq.inzmod (sval v2.[j]) = peval (pofw p2) (Zq.ZModpRing.exp zZ (E 0 j))) =>
  forall j, 0 <= j < 256 =>
    Zq.inzmod (2^32 * sval ((pwmul v1 v2).[j]))
      = peval (pofw p1) (Zq.ZModpRing.exp zZ (E 0 j))
      * peval (pofw p2) (Zq.ZModpRing.exp zZ (E 0 j)).
proof.
move=> h1 h2 j rgj.
have -> : Zq.inzmod (2^32 * sval ((pwmul v1 v2).[j]))
        = Zq.inzmod (sval v1.[j] * sval v2.[j]).
- rewrite -Zq.eq_inzmod.
  by apply pwmul_cgr.
by rewrite Zq.inzmodM h1 1:// h2 1://.
qed.

(* ==================================================================== *)
(* Interpolation at the leaf roots (instance of the generic Lagrange    *)
(* kit): any assignment of values at the 256 leaf roots is realized by  *)
(* a polynomial of degree <= 256                                        *)
(* ==================================================================== *)
lemma size_leafroots : size (leafroots 8 0) = 256.
proof.
by rewrite /leafroots size_mkseq.
qed.

op leafinterp (f : int -> Zq.zmod) : poly =
  interp (leafroots 8 0) (fun r => f (index r (leafroots 8 0))).

lemma leafinterp_evalP (f : int -> Zq.zmod) (j : int) :
  0 <= j < 256 =>
  peval (leafinterp f) (Zq.ZModpRing.exp zZ (E 0 j)) = f j.
proof.
move=> rgj.
have hmem : Zq.ZModpRing.exp zZ (E 0 j) \in leafroots 8 0.
- rewrite /leafroots.
  apply/mkseqP.
  exists j => /=.
  by smt().
rewrite /leafinterp interp_evalP 1:uniq_leafroots 1:hmem /=.
congr.
have -> : Zq.ZModpRing.exp zZ (E 0 j) = nth witness (leafroots 8 0) j.
- by rewrite /leafroots nth_mkseq 1:/# /=.
by rewrite index_uniq 1:(size_leafroots) 1:/# 1:uniq_leafroots.
qed.

(* the interpolated representative of the pwmul output: a polynomial    *)
(* of degree <= 256 whose leaf evaluations are the (2^32-scaled) output *)
(* coefficients, and which is congruent to the product modulo X^256+1   *)
lemma pwmul_reprP (p1 p2 v1 v2 : wpoly) :
  (forall j, 0 <= j < 256 =>
     Zq.inzmod (sval v1.[j]) = peval (pofw p1) (Zq.ZModpRing.exp zZ (E 0 j))) =>
  (forall j, 0 <= j < 256 =>
     Zq.inzmod (sval v2.[j]) = peval (pofw p2) (Zq.ZModpRing.exp zZ (E 0 j))) =>
  exists (u : poly),
       deg u <= 256
    /\ (forall j, 0 <= j < 256 =>
          peval u (Zq.ZModpRing.exp zZ (E 0 j))
            = Zq.inzmod (2^32 * sval ((pwmul v1 v2).[j])))
    /\ peqm (exp X 256 + poly1) u (pofw p1 * pofw p2).
proof.
move=> h1 h2.
exists (leafinterp (fun j => Zq.inzmod (2^32 * sval ((pwmul v1 v2).[j])))).
do! split.
- have := deg_interp (leafroots 8 0)
    (fun r => (fun j => Zq.inzmod (2^32 * sval ((pwmul v1 v2).[j])))
                (index r (leafroots 8 0))) uniq_leafroots.
  by rewrite size_leafroots /leafinterp.
- move=> j rgj.
  by rewrite leafinterp_evalP.
apply peval_mul_glue => j rgj.
rewrite leafinterp_evalP 1://.
by apply (pwmul_evalP p1 p2 v1 v2).
qed.

(* ==================================================================== *)
(* End-to-end: feeding the pointwise product through the code's         *)
(* inverse NTT yields a representative of the product polynomial --     *)
(* the Montgomery factors of pwmul (2^-32) and of the inverse NTT       *)
(* (2^32) cancel exactly                                                *)
(* ==================================================================== *)
op wofp (u : poly) : wpoly =
  Array256.init (fun i => W32.of_int (Zq.asint u.[i])).

lemma pofw_wofp (u : poly) : deg u <= 256 => pofw (wofp u) = u.
proof.
move=> hdeg.
rewrite /pofw /wofp.
apply poly_eqP => i ge0i.
rewrite polyLE.
case (i < 256) => hcase.
- rewrite nth_mkseq 1:/# /= initiE 1:/# /=.
  rewrite W32.to_sintK_small.
  - by smt(Zq.rg_asint).
  by rewrite Zq.asintK.
rewrite nth_default ?size_mkseq 1:/#.
by rewrite gedeg_coeff 1:/#.
qed.

lemma cbnd_pwmul (v1 v2 : wpoly) (B1 B2 : int) :
  cbnd v1 B1 => cbnd v2 B2 => B1 * B2 <= 2^31 * q =>
  cbnd (pwmul v1 v2) q.
proof.
move=> h1 h2 hB i rgi.
rewrite /pwmul initiE //=.
apply (mmr_bnd2 _ _ B1 B2) => //.
- by apply h1.
by apply h2.
qed.

lemma intt_pwmul_polyP (p1 p2 v1 v2 : wpoly) (B1 B2 : int) :
  cbnd v1 B1 => cbnd v2 B2 => B1 * B2 <= 2^31 * q =>
  (forall j, 0 <= j < 256 =>
     Zq.inzmod (sval v1.[j]) = peval (pofw p1) (Zq.ZModpRing.exp zZ (E 0 j))) =>
  (forall j, 0 <= j < 256 =>
     Zq.inzmod (sval v2.[j]) = peval (pofw p2) (Zq.ZModpRing.exp zZ (E 0 j))) =>
  peqm (exp X 256 + poly1)
       (pofw (iscale (invtree (pwmul v1 v2) 8)))
       (pofw p1 * pofw p2).
proof.
move=> hb1 hb2 hBB h1 h2.
pose w := pwmul v1 v2.
pose u' := leafinterp (fun j => Zq.inzmod (sval w.[j])).
have hdeg : deg u' <= 256.
- have := deg_interp (leafroots 8 0)
    (fun r => (fun j => Zq.inzmod (sval w.[j])) (index r (leafroots 8 0)))
    uniq_leafroots.
  by rewrite size_leafroots /u' /leafinterp.
have hev : forall j, 0 <= j < 256 =>
  peval u' (Zq.ZModpRing.exp zZ (E 0 j)) = Zq.inzmod (sval w.[j]).
- move=> j rgj.
  by rewrite /u' leafinterp_evalP.
have hbw : cbnd w q.
- by apply (cbnd_pwmul v1 v2 B1 B2).
have hevw : forall j, 0 <= j < 256 =>
  Zq.inzmod (sval w.[j]) = peval (pofw (wofp u')) (Zq.ZModpRing.exp zZ (E 0 j)).
- move=> j rgj.
  by rewrite pofw_wofp 1:hdeg hev 1://.
have heq := intt_poly_algP (wofp u') w q _ _ hbw hevw.
- by done.
- by rewrite /q.
rewrite heq.
apply peval_mul_glue => j rgj.
rewrite pevalM pevalC pofw_wofp 1:hdeg hev 1://.
rewrite -Zq.inzmodM.
by apply (pwmul_evalP p1 p2 v1 v2).
qed.
