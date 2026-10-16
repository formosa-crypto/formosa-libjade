(* -------------------------------------------------------------------- *)
(* Agreement of a polynomial with a prefix of an accepted-coefficient   *)
(* stream: the loop invariants of the rejection samplers.               *)
(* -------------------------------------------------------------------- *)
require import AllCore List.

from JazzEC require import Array256.

(* -------------------------------------------------------------------- *)
op [opaque] agree ['a] (p : 'a Array256.t) (base : int) (coeffs : 'a list) =
  forall i,
       0 <= i < size coeffs
    => 0 <= i + base < 256
    => p.[base + i] = nth witness coeffs i.

(* -------------------------------------------------------------------- *)
lemma agree_nil ['a] (p : 'a Array256.t) (base : int) : agree p base [].
proof. by rewrite /agree /= /#. qed.

hint simplify agree_nil.

(* -------------------------------------------------------------------- *)
lemma agree_set ['a] (p : 'a Array256.t) (l : 'a list) (c : 'a) :
  size l < 256 => agree p 0 l =>
  agree p.[size l <- c] 0 (l ++ [c]).
proof.
move=> hsz; rewrite /agree => hag i /=; rewrite size_cat /= => rgi rgb.
rewrite Array256.get_setE 1:/# nth_cat.
case: (i = size l) => [-> /=|ne] //.
by rewrite ifT 1:/#; smt().
qed.

(* -------------------------------------------------------------------- *)
lemma agree_full ['a] (p : 'a Array256.t) (l1 l2 : 'a list) :
  256 <= size l1 => agree p 0 l1 =>
  agree p 0 (l1 ++ l2).
proof.
move=> hsz; rewrite /agree => hag i /=; rewrite size_cat => rgi rgb.
by rewrite nth_cat ifT 1:/#; smt().
qed.

(* a coefficient of a full agreed prefix, under any default             *)
lemma agree_nth ['a] (x0 : 'a) (p : 'a Array256.t) (l : 'a list) (j : int) :
  256 <= size l => agree p 0 l => 0 <= j < 256 => p.[j] = nth x0 l j.
proof.
move=> hsz @/agree hag rgj; rewrite (nth_change_dfl witness x0) 1:/#.
by have /= := hag j _ _ => //#.
qed.

(* -------------------------------------------------------------------- *)
(* The sampler bookkeeping pair: the polynomial agrees with the         *)
(* accepted stream and the fill counter is its size, capped at 256.     *)
op filled_ok ['a] (p : 'a Array256.t) (cs : 'a list) (f : int) =
  agree p 0 cs /\ f = min 256 (size cs).

(* an accepted candidate is stored at the fill mark                     *)
lemma filled_ok_snoc ['a] (p : 'a Array256.t) (cs : 'a list) (f : int) (w : 'a) :
  filled_ok p cs f => f < 256 =>
  filled_ok p.[f <- w] (cs ++ [w]) (f + 1).
proof.
move=> @/filled_ok [hag hf] hlt; have hsz : f = size cs by smt().
split; last by smt(size_cat).
by rewrite hsz; apply agree_set; [smt() | exact hag].
qed.

(* a full polynomial absorbs any further candidates                     *)
lemma filled_ok_full ['a] (p : 'a Array256.t) (cs ds : 'a list) (f : int) :
  filled_ok p cs f => f = 256 =>
  filled_ok p (cs ++ ds) f.
proof.
move=> @/filled_ok [hag hf] hfull; split; last by smt(size_cat size_ge0).
by apply agree_full; [smt() | exact hag].
qed.
