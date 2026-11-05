require import AllCore List.
export List.

(* Declassified values *)
type decl = [ Int of int | List of decl list ].

(* Constant-Time leakage model: the proof only produces flat traces of
   declassified values (no branch or loop conditions are leaked). *)
type leakage = decl list.

abbrev Empty : leakage = [].

(* Concatenates leakage. *)
abbrev lcat (l1 l2 : leakage) : leakage = l1 ++ l2.

(* Leakage of one iteration of the FS+abort signing loop: the leakages of
   the commitment, of the random oracle and of the response, appended to
   the leakage of the previous iterations.  The boolean (the loop
   condition) is not leaked: the trace is flat, and every item is appended
   with [lcat] (so that the bracketing does not matter, see [catA]). *)
op fs_leak (x : bool * (leakage * leakage * leakage)) =
  let (b, l_fs) = x in
  let (lw, lc, lz) = l_fs in
  lcat lw (lcat lc lz).

op catFS l l_fs = lcat l (fs_leak l_fs).

lemma catFSE l b lw lc lz : catFS l (b, (lw, lc, lz)) = lcat l (lcat lw (lcat lc lz)).
proof. by rewrite /catFS /fs_leak. qed.

(* Leakage of a short-circuit cascade of tests (a loop that stops at the
   first failing test): the index of the first failing test, or -1 when all
   tests pass. *)
op oileak (oi : int option) : leakage = [Int (odflt (-1) oi)].

(* Leakage of a rejection-sampling loop over a byte stream: the pairs
   (position in the stream after the read, byte read), declassified. *)
op pairs_to_leakage (l : (int * int) list) : leakage =
  [List (map (fun (p : int * int) => List [Int p.`1; Int p.`2]) l)].
