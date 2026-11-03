(* -------------------------------------------------------------------- *)
(* Support for the safety proofs: simplification hints that compute the   *)
(* trace and the word-level arithmetic of the models, and the arithmetic  *)
(* facts the prover calls need.                                           *)
(* -------------------------------------------------------------------- *)
require import AllCore IntDiv List StdOrder.
from Jasmin require import JUtils JWord JMemory Jcheck.

(* -------------------------------------------------------------------- *)
(* The validity of a literal trace is the conjunction of its checks; the
   trace of a callee stays `valid t`, as in the callee's specification. *)
lemma valid_catE (t1 t2 : trace) : valid (t1 ++ t2) = (valid t1 /\ valid t2).
proof. by rewrite /valid all_cat. qed.

lemma valid_consE k b (t : trace) : valid ((k, b) :: t) = (b /\ valid t).
proof. by rewrite /valid. qed.

lemma valid_nilE : valid<:kind> [] = true.
proof. by rewrite /valid. qed.

hint simplify valid_catE, valid_consE, valid_nilE.

(* -------------------------------------------------------------------- *)
(* The byte position inside a state word is computed on a u64 register:
   `(64u) at & 7`. *)
lemma and7E (a : int) : to_uint (W64.of_int a `&` W64.of_int 7) = a %% 8.
proof.
rewrite (: 7 = 2 ^ 3 - 1) // to_uint_and_mod // of_uintK.
by rewrite modz_dvd.
qed.

lemma and7_nzE (a : int) :
  (W64.of_int a `&` W64.of_int 7 <> W64.zero) = (a %% 8 <> 0).
proof. by rewrite W64.to_uint_eq /= and7E. qed.

lemma and7_zE (a : int) :
  (W64.of_int a `&` W64.of_int 7 = W64.zero) = (a %% 8 = 0).
proof. by rewrite W64.to_uint_eq /= and7E. qed.

hint simplify and7E, and7_nzE, and7_zE.

(* integer shifts of the models (word offsets, 4-way lane offsets) *)
lemma shr3E (a : int) : a `|>>` 3 = a %/ 8.
proof. by rewrite /(`|>>`) /(`<<`). qed.

lemma shl3E (a : int) : a `<<` 3 = a * 8.
proof. by rewrite /(`<<`). qed.

lemma shl5E (a : int) : a `<<` 5 = a * 32.
proof. by rewrite /(`<<`). qed.

hint simplify shr3E, shl3E, shl5E.

(* -------------------------------------------------------------------- *)
(* a loop of x %/ d iterations of stride d stays within x bytes *)
lemma mul_div_le (x d i : int) : 0 < d => i <= x %/ d => d * i <= x.
proof.
move=> hd hi; have := divz_eq x d; have := modz_ge0 x d _; 1: smt().
by have := IntOrder.ler_wpmul2l d _ i (x %/ d) _; smt().
qed.

lemma mul_div_lt (x d i : int) : 0 < d => i < x %/ d => d * i + d <= x.
proof. by move=> hd hi; have := mul_div_le x d (i + 1) hd _; smt(). qed.

(* the position after a block is the position before it, modulo the rate *)
lemma modzBr (m d : int) : (m - d) %% d = m %% d.
proof. by rewrite -(modzDr (m - d) d); congr; algebra. qed.

(* the final position of an absorb: the input length after the first block,
   as the code computes it, against the contract's form *)
lemma modz_rate (l r a : int) : (l - (r - a)) %% r = (a + l) %% r.
proof. by rewrite -(modzBr (a + l) r); congr; algebra. qed.

(* the three strides of the whole-word phases *)
lemma chunks8 (l : int) :
  0 <= l =>
  32 * (l %/ 32) + (if 16 <= l %% 32 then 16 else 0) + (if 8 <= l %% 16 then 8 else 0)
  = 8 * (l %/ 8).
proof. smt(). qed.

(* -------------------------------------------------------------------- *)
(* memory validity on a sub-range *)
lemma is_valid_le m v p l p' l' :
  is_valid m v p l => p <= p' => p' + l' <= p + l => is_valid m v p' l'.
proof. by rewrite /is_valid; smt(). qed.
