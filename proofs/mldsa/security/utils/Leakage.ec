require List.
export List.

(* Declassified values *)
type decl = [ Int of int | List of decl list ].

(* Constant-Time leakage model *)
type leakage = [
  | Seq of leakage list
  | If of bool & leakage
  | While of bool & leakage
  | Decl of decl
  (* Unused in this proof
  | Load of int
  | Store of int
  *)
].

op Empty = Seq [].

op to_seq l =
  with l = Seq l' => l'
  with l = If _ _ => [l]
  with l = While _ _ => [l]
  with l = Decl _ => [l].

(* Concatenates leakage. *)
op lcat l1 l2 =
  if l1 = Empty then l2
  else if l2 = Empty then l1
  else Seq (to_seq l1 ++ to_seq l2).

lemma lcatEmpty l : lcat l Empty = l by smt().
lemma lcatA l l' l'' : lcat l (lcat l' l'') = lcat (lcat l l') l''.
proof.
have ? : forall l2 l1, l1 <> Empty => lcat l1 l2 <> Empty by case => /#.
have ? := catA<:leakage>.
case (l = Empty); case (l' = Empty); case (l'' = Empty) => /#.
qed.

(* if-then-else leakage *)
op ite (g : bool) (lt lf : leakage) = If g (if g then lt else lf).

op fs_leak arg =
  let (b, l_fs) = arg in
  let (lc, lw, lz) = l_fs in
  While b (Seq [lc; lw; lz]).

op catFS l l_fs = lcat l (fs_leak l_fs).
