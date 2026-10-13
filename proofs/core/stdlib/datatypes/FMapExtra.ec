(* -------------------------------------------------------------------- *)
(* Finite maps: any integer measure on the keys is bounded               *)
(* -------------------------------------------------------------------- *)
require import AllCore List FSet FMap.

lemma fmap_bounded ['a 'b] (m : ('a, 'b) fmap) (f : 'a -> int) :
  exists B, forall x, x \in m => f x < B.
proof.
pose B := foldr (fun x b => max b (f x + 1)) 0 (elems (fdom m)).
have h : forall (l : 'a list) x, x \in l => f x < foldr (fun x b => max b (f x + 1)) 0 l.
- by elim=> [|y l ih] x //= [-> | /ih]; smt().
by exists B => x hx; apply h; rewrite -memE mem_fdom.
qed.

(* the second components of the keys with a given first component *)
lemma fmap_bounded_snd ['a 'b] (m : ('a * int, 'b) fmap) (a : 'a) :
  exists B, forall c, (a, c) \in m => c < B.
proof.
have [B hB] := fmap_bounded m (fun (x : 'a * int) => if x.`1 = a then x.`2 else 0).
by exists B => c /hB.
qed.
