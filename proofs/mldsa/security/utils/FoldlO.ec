require import AllCore List.

(* Left fold of a partial step function: the fold stops (returns [None])
   as soon as one step fails. *)
op foldl_o (f : 'a -> 's -> 's option) (os : 's option) (l : 'a list) =
  foldl (fun os a => obind (f a) os) os l.

lemma foldl_o_None (f : 'a -> 's -> 's option) (l : 'a list) :
  foldl_o f None l = None.
proof. by elim: l. qed.

lemma foldl_o_cons (f : 'a -> 's -> 's option) os a (l : 'a list) :
  foldl_o f os (a :: l) = foldl_o f (obind (f a) os) l.
proof. done. qed.

lemma foldl_o_cat (f : 'a -> 's -> 's option) os (s1 s2 : 'a list) :
  foldl_o f os (s1 ++ s2) = foldl_o f (foldl_o f os s1) s2.
proof. by rewrite /foldl_o foldl_cat. qed.

lemma foldl_o_rcons (f : 'a -> 's -> 's option) os (l : 'a list) a :
  foldl_o f os (rcons l a) = obind (f a) (foldl_o f os l).
proof. by rewrite /foldl_o foldl_rcons. qed.
