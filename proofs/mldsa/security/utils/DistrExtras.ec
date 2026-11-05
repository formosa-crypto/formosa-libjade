require import AllCore List Distr DBool.
require StdOrder.

lemma mu_eq_l (d2 d1 : 'a distr) p : d1 = d2 => mu d1 p = mu d2 p by smt().

lemma distr_eq_supp (d1 d2 : 'a distr) :
  is_uniform d1 => is_uniform d2 =>
  is_lossless d1 => is_lossless d2 =>
  (forall x, x \in d1 <=> x \in d2) =>
    d1 = d2.
proof.
move => d1_uniform d2_uniform d1_ll d2_ll eq_supp.
apply eq_distr => x.
rewrite (mu1_uni_ll _ _ d1_uniform d1_ll) (mu1_uni_ll _ _ d2_uniform d2_ll).
have -> // : support d1 = support d2.
by apply fun_ext => ?; apply/eqboolP/eq_supp.
qed.

lemma mu_drange_le k i :
  mu (drange 0 k) (fun (j : int) => j <= i) =
    if 0 < k then Biased.clamp ((i + 1)%r / k%r) else 0%r.
proof.
  case (0 < k) => hk; last first.
  + by rewrite drangeE range_geq 1:/#.
  case: (0 <= i + 1 <= k) => [ [??] | ?]; last first.
  + case: (! 0 <= i + 1) => ?.
    + have ? : (i + 1)%r / k%r <= 0%r.
      + apply StdOrder.RealOrder.mulr_le0_ge0; 1:smt().
        apply StdOrder.RealOrder.invr_ge0; 1:smt().
      have -> : Biased.clamp ((i + 1)%r / k%r) = 0%r by smt().
      by apply mu0_false => j /supp_drange /= /#.
    have -> : Biased.clamp ((i + 1)%r / k%r) = 1%r by smt().
    apply eq1_mu; 1: by apply: drange_ll hk.
    by move=> j /supp_drange /= /#.
  rewrite drangeE (range_cat (i+1)) // count_cat all_count_in.
  + by apply allP => ? /mem_range /= /#.
  rewrite count_pred0_eq_in.
  + by move=> ? /mem_range /= /#.
  rewrite size_range /= /#.
qed.


(* ----------------------------------------- *)
(* Products of distributions *)

lemma dlet_dprod (d1 : 'a distr) (d2 : 'b distr) (G : 'a * 'b -> 'c distr) :
  dlet (d1 `*` d2) G = dlet d1 (fun a => dlet d2 (fun b => G (a, b))).
proof.
rewrite dprod_dlet dlet_dlet; apply eq_dlet => // a /=.
by rewrite dlet_dlet; apply eq_dlet => // b /=; rewrite dlet_unit.
qed.

lemma dprodA ['a 'b 'c] (d1:'a distr) (d2:'b distr) (d3:'c distr) :
  (d1 `*` d2) `*` d3 = dmap (d1 `*` (d2 `*` d3)) (fun (p : _ * (_ * _)) => ((p.`1, p.`2.`1), p.`2.`2)).
proof.
  rewrite !dprod_dlet dmap_dlet dlet_dlet.
  apply eq_dlet => //= x1.
  rewrite dmap_dlet !dlet_dlet; apply eq_dlet => //= x2.
  rewrite !dlet_dlet dlet_unit /=; apply eq_dlet => //= x3.
  by rewrite dlet_unit /= dmap_dunit.
qed.

lemma djoinmap_prod ['a 'b 'c] (d1 : 'c -> 'a distr) (d2 : 'c -> 'b distr) l:
  djoinmap (fun i => d1 i `*` d2 i) l =
  dmap (djoinmap d1 l `*` djoinmap d2 l) (fun l : _ * _ => zip l.`1 l.`2).
proof.
  elim: l => //=.
  + by rewrite !djoin_nil dprod_dunit dmap_dunit.
  move=> c l ih.
  rewrite !djoin_cons /= ih !dmap_dprod !dmap_comp dmap_dprodR dmap_comp.
  rewrite !dprodA !dmap_comp !(dprod_dlet (d1 c)) !dmap_dlet; apply eq_dlet => //= x1.
  rewrite (dprodC (djoinmap d1 l) (_ `*` _)) dprodA !(dprod_dlet (d2 c)).
  rewrite !dmap_dlet !dlet_dlet; apply eq_dlet => //= x2.
  rewrite dprodC !dlet_dlet; apply eq_dlet => //= -[l2 l1].
  by rewrite /(\o) /= !(dlet_unit,dmap_dunit) /= !(dlet_unit, dmap_dunit) /= !dmap_dunit.
qed.
