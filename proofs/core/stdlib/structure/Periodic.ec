(* -------------------------------------------------------------------- *)
(* Periodicity of injective maps on finite types                         *)
(*                                                                      *)
(* On a finite type, an injective map is a permutation and every point  *)
(* lies on a cycle: iterating the map returns to the point after some    *)
(* positive number of steps, and then after every multiple of it.        *)
(* -------------------------------------------------------------------- *)
require import AllCore List IntDiv Finite.

(* -------------------------------------------------------------------- *)
lemma iterD ['a] (f : 'a -> 'a) (m n : int) (x : 'a) :
  0 <= m => 0 <= n => iter (m + n) f x = iter m f (iter n f x).
proof.
move=> ge0m; elim: n => [|n ge0n ih]; first by rewrite (iter0 0).
by rewrite addzA (iterS (m + n)) 1:/# ih (iterS n) // -iterSr // iterS.
qed.

lemma iter_inj ['a] (f : 'a -> 'a) (n : int) :
  injective f => injective (iter n f).
proof.
move=> inj_f; case: (n < 0) => [ltn x y|/lezNgt ge0n]; first by rewrite !iter0 1,2:/#.
elim: n ge0n => [|n ge0n ih] x y; first by rewrite !(iter0 0).
by rewrite !iterS // => /inj_f /ih.
qed.

(* -------------------------------------------------------------------- *)
(* every point is periodic                                              *)
lemma injective_periodic ['a] (f : 'a -> 'a) (x : 'a) :
  finite_type<:'a> => injective f =>
  exists L, 0 < L /\ iter L f x = x.
proof.
move=> /finite_typeP [s hs] inj_f; apply: contraT => hnp.
pose l := map (fun k => iter k f x) (iota_ 0 (size s + 1)).
have hu : uniq l.
- rewrite /l map_inj_in_uniq ?iota_uniq // => i j /mem_iota rgi /mem_iota rgj /= hij.
  have hper : forall a b, 0 <= a < b => iter a f x = iter b f x => false.
  + move=> a b rgab hab; apply: hnp; exists (b - a); split; 1: smt().
    apply: (iter_inj f a inj_f).
    by rewrite -iterD 1,2:/# (_ : a + (b - a) = b) 1:#ring hab.
  apply: contraT => neij.
  by case: (i < j) => hlt; [apply: (hper i j) | apply: (hper j i)] => /#.
have := uniq_leq_size l (undup s) hu _.
- by move=> y _; rewrite mem_undup hs.
by rewrite size_map size_iota; smt(size_undup size_ge0).
qed.

(* the cycle is traversed again after every multiple of the period      *)
lemma iter_periodM ['a] (f : 'a -> 'a) (L k : int) (x : 'a) :
  0 <= L => 0 <= k => iter L f x = x => iter (k * L) f x = x.
proof.
move=> ge0L; elim: k => [|k ge0k ih] hL; first by rewrite iter0.
by rewrite mulzDl /= iterD 1,2:/# hL ih.
qed.

lemma iter_periodmod ['a] (f : 'a -> 'a) (L n : int) (x : 'a) :
  0 < L => 0 <= n => iter L f x = x => iter n f x = iter (n %% L) f x.
proof.
move=> gt0L ge0n hL; rewrite {1}(divz_eq n L) addzC iterD 1:modz_ge0 1:/# 1:/#.
by rewrite iter_periodM 1:/# 1:divz_ge0.
qed.
