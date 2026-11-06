(**
  This theory provides a high-level, algebraic specification of the Number
  Theoretic Transform (NTT).

  This specification abstracts away from algorithmic structure and
  implementation concerns, focusing solely on the mathematical meaning of
  the transform.

  It is intended to serve as an intermediate, clean algebraic layer:
  on one side, it can be related to the official NIST specification, and
  on the other side, it provides the reference model against which the
  low-level (machine-level) implementation is connected and verified.
*)

(* -------------------------------------------------------------------- *)
require import AllCore CoreUtils List IntDiv BitEncoding.
(*---*) import BS2Int.

(* -------------------------------------------------------------------- *)
(* Should come from somewhere else                                      *)
op q : int = 8380417.

(* -------------------------------------------------------------------- *)
op zeta_ : int = 1753.

op qcenter (x : int) : int =    (* FIXME: factor out *)
  let x = x %% q in
  if q %/ 2 < x then x - q else x.

op mrepr (x : int) : int =
  (x * 2^32) %% q.

