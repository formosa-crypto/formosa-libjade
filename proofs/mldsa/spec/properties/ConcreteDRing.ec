require import AllCore List IntDiv Distr DInterval.
require import Supplementary Nat.
require DRing.
require StdBigop.
require import Array256.
require import Parameters GFq Rq.
import Round ZModQ Zq PolyReduce.

(* The ring of DRing realized by Zq[X]/(X^n + 1) and the rounding operations of ZqRounding *)

op l1_norm (p : polyXnD1) = l1 (alg2poly p).

op dC a = dcond dpolyXnD1 (fun (c : polyXnD1) => `|c| <= 1 /\ l1_norm c = a).

op dpoly_ball i = if 0 <= i < q %/ 2 then dmap (dpoly (-i) i) poly2alg else dpolyXnD1.

lemma l1_inf_norm_product (x y : polyXnD1) b1 b2 :
  0 < b1 => 0 < b2 => l1_norm x <= b1 => `|y| <= b2 => `|x * y| <= b1 * b2.
proof.
move=> gt0_b1 gt0_b2 hx hy; apply inf_norm_le; 1: smt().
move=> i rgi.
have -> : (x * y).[i] = (alg2poly x &* alg2poly y).[i] by rewrite /(&*) !poly2algK alg2polyiE.
apply (StdOrder.IntOrder.ler_trans (l1 (alg2poly x) * b2)).
+ by apply conv_coeff_bnd => // j rgj; rewrite alg2polyiE //; apply (inf_normXE y b2) => //; smt().
by apply StdOrder.IntOrder.ler_wpmul2r; smt().
qed.

op make_valid_challenge a = polyLX (nseq a Zq.one).

lemma make_valid_challenge_infty_norm a : 0 <= a <= n => `|make_valid_challenge a| <= 1.
proof.
move=> rg_a; apply inf_norm_le => // i rgi.
rewrite /make_valid_challenge polyLXE; 1: smt(size_nseq).
by rewrite nth_nseq_if; case (0 <= i < a) => _; [rewrite abs_zp_one | rewrite abs_zp_zero].
qed.

lemma make_valid_challenge_1norm a : 0 <= a <= n => l1_norm (make_valid_challenge a) = a.
proof.
move=> rg_a; rewrite /l1_norm /l1.
rewrite (StdBigop.Bigint.BIA.eq_big_int 0 256 _ (fun i => if i < a then 1 else 0)) /=.
+ move=> i rgi /=; rewrite alg2polyiE // /make_valid_challenge polyLXE; 1: smt(size_nseq).
  by rewrite nth_nseq_if; case: (i < a) => h; [rewrite ifT 1:/# abs_zp_one | rewrite ifF 1:/# abs_zp_zero].
rewrite (StdBigop.Bigint.BIA.big_cat_int a) 1,2:/#.
rewrite (StdBigop.Bigint.BIA.eq_big_int 0 a _ (fun _ => 1)) 1:/# (StdBigop.Bigint.BIA.eq_big_int a n _ (fun _ => 0)) 1:/#.
by rewrite StdBigop.Bigint.bigi_constz 1:/# StdBigop.Bigint.BIA.big1_eq.
qed.

lemma poly_leftshift_imE alpha (xs : int list) (x : int) :
  x \in xs => Supplementary.image (poly_highbits alpha) xs => Round.image (highbits alpha) x.
proof.
rewrite /Supplementary.image /Round.image => in_x [y im_y].
by move: in_x; rewrite -im_y /poly_highbits mkseqP => -[i [rg_i ->]]; exists y.[i].
qed.

clone DRing as DR with
  op q <= q,
  op n <= n,
  type Rq <= polyXnD1,
  theory RqRing <= ComRingDflInv,
  op cnorm <= Round."`|_|",
  op dRq <= dpolyXnD1,
  op dRq_ <= dpoly_ball,
  op dC <= dC,
  op l1_norm <= l1_norm,
  type Flex.high <= int list,
  op Flex.highBits <= poly_highbits,
  op Flex.shift <= poly_leftshift,
  op Flex.lowBits <= poly_lowbits,
  type Flex.high2 <= int list,
  type hint_t <= bool list,
  op Flex.makeHint <= poly_makehint,
  op Flex.useHint <= poly_usehint,
  op Flex.power2round <= fun d => poly_highbits2 d,
  op Flex.shift2 <= fun d => poly_leftshift2 d
proof *.
realize prime_q by exact Parameters.prime_q.
realize gt0_n by exact gt0_n.
realize dRq_ll by exact dpolyXnD1_ll.
realize dRq_uni by exact dpolyXnD1_uni.
realize dRq_fu by exact dpolyXnD1_full.
realize dRq__ll.
move=> i; rewrite /dpoly_ball; case: (0 <= i < Parameters.q %/ 2) => h /=; last exact dpolyXnD1_ll.
by apply dmap_ll; apply Rq.dpoly_ll; smt().
qed.
realize dRq__uni.
move=> i; rewrite /dpoly_ball; case: (0 <= i < Parameters.q %/ 2) => h /=; last exact dpolyXnD1_uni.
apply dmap_uni_in_inj; last by apply Rq.dpoly_uni; smt().
by move=> x y _ _; apply (can_inj _ _ alg2polyK).
qed.
realize supp_dRq.
move=> x a ge0_a; rewrite /dpoly_ball; case: (0 <= a < Parameters.q %/ 2) => h /=; last first.
+ by split => _; [smt(inf_norm_ub) | exact dpolyXnD1_full].
rewrite supp_dmap; split.
+ move=> [p [hp ->]]; apply inf_norm_le => // i rgi.
  move: hp; rewrite supp_dpoly 1,2:/# => /(_ i rgi).
  by rewrite poly2algiE // /ZModQ."`|_|"; smt().
move=> hx; exists (alg2poly x); rewrite poly2algK /= supp_dpoly 1,2:/# => i rgi.
by have := inf_normXE x a i ge0_a hx rgi; rewrite alg2polyiE // /ZModQ."`|_|"; smt().
qed.
realize dC_ll.
move=> i rg_i; apply dcond_ll; apply witness_support => /=.
exists (make_valid_challenge i); split; last exact dpolyXnD1_full.
by split; [exact make_valid_challenge_infty_norm | exact make_valid_challenge_1norm].
qed.
realize dC_uni by move=> i; apply dcond_uni; exact dpolyXnD1_uni.
realize supp_dC by smt(dcond_supp dpolyXnD1_full).
realize cnorm_ge0 by exact ge0_inf_norm_p.
realize cnormN by exact abs_polyXN.
realize Flex.high_lowP by exact poly_high_lowP.
realize Flex.hide_low by smt(poly_hide_low).
realize Flex.lowbit_small by exact poly_lowbit_small.
realize Flex.shift_inj.
move=> alpha rg_alpha even_alpha alpha_almost_divides_q xs ys im_x im_y sx_sy_eq.
apply (poly_leftshift_inj alpha xs ys) => //.
- by case: im_x => x <-; exact poly_highbits_size.
- by case: im_y => y <-; exact poly_highbits_size.
- by move=> x hx; apply (poly_leftshift_imE alpha xs).
- by move=> y hy; apply (poly_leftshift_imE alpha ys).
qed.
realize l1_cnorm_product_ub by exact l1_inf_norm_product.
realize cnorm0 by exact inf_norm0.
realize cnorm_triangle by exact inf_norm_triangle.
realize Flex.usehint_correct by exact poly_use_makehint.
realize Flex.usehint_insub by exact poly_usehint_im.
realize Flex.hide_low2 by exact poly_hide_low2.
realize Flex.power2round_bound.
move=> d r *.
rewrite poly_rm_high2 //.
exact poly_lowbits2_small.
qed.
