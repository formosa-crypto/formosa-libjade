(**
  List-related user reduction rules, collected in the named database
  [listred]. Nothing here touches the default simplification database:
  requiring this file leaks no reduction behavior. Proofs opt in
  explicitly, either for a whole proof

      hint +listred.

  or for a single call ([simplify hint +listred], [with hint +listred (...)]).
*)

(* -------------------------------------------------------------------- *)
require import AllCore List.

from Jasmin require import JUtils.

(* -------------------------------------------------------------------- *)
hint simplify in listred : size_map, size_nseq.
hint simplify in listred : size_mkseq.
hint simplify in listred : nth_mkseq, nth_nseq.
hint simplify in listred : flatten_cons, flatten_nil.
hint simplify in listred : cat0s, cats0.
hint simplify in listred : mkseqSr_minus, mkseq0.
hint simplify in listred : nseq0, nseqS_minus.
hint simplify in listred : range_geq, range_ltn.

(* -------------------------------------------------------------------- *)
(* Structural rules for [nth]: with [hint -delta nth] in force, [nth]
   no longer iota-reduces on its own; these rules recover the literal
   -index computations (and only those: [nth_consS]'s guard needs a
   decidable [0 < n]). *)
lemma nth_cons0 ['a] (x0 x : 'a) (s : 'a list) :
  nth x0 (x :: s) 0 = x.
proof. by []. qed.

lemma nth_consS ['a] (x0 x : 'a) (s : 'a list) (n : int) :
  0 < n => nth x0 (x :: s) n = nth x0 s (n - 1).
proof. by move=> gt0_n /=; rewrite ifF 1:/#. qed.

lemma nth_nil ['a] (x0 : 'a) (n : int) :
  nth x0 [] n = x0.
proof. by []. qed.

hint simplify in listred : nth_cons0, nth_consS, nth_nil.
