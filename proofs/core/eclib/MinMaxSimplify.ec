(* -------------------------------------------------------------------- *)
(* `max m n` and `min m n` simplify when the order of m and n does, e.g. on
   literals: the size lemmas of the Jasmin library (size_to_list,
   size_w2bits) state `max 0 size`. The hints are active wherever this
   file is required. *)
require import AllCore.

lemma max_simplify_r (m n : int) : m <= n => max m n = n.
proof. by rewrite /max; case: (m < n) => // /#. qed.

lemma max_simplify_l (m n : int) : n <= m => max m n = m.
proof. by rewrite /max; case: (m < n) => // /#. qed.

lemma min_simplify_l (m n : int) : m <= n => min m n = m.
proof. by rewrite /min; case: (m < n) => // /#. qed.

lemma min_simplify_r (m n : int) : n <= m => min m n = n.
proof. by rewrite /min; case: (m < n) => // /#. qed.

hint simplify max_simplify_r, max_simplify_l, min_simplify_l, min_simplify_r.
