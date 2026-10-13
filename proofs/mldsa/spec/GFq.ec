require import AllCore IntDiv.
require ZqRounding.

require import Parameters.

clone import ZqRounding as Round with
  op q <- q,
  op n <- n
  proof prime_q by exact prime_q
  proof gt0_n  by exact gt0_n
  rename "zmod"   as "coeff"
         "inzmod" as "incoeff"
         "ZMF"    as "Zq".

import Round ZModQ Zq.

(* Signed representation *)

op smodem(n d : int) : int = if (d %/ 2 < n %% d) then n %% d - d else n %% d.

op Power2Round(x : coeff) : coeff * coeff = 
    let rplus = asint x in
    let rzero = smodem rplus (2^d)
    in (incoeff ((rplus - rzero) %/ (2^d)), incoeff rzero).

lemma incoeffP (z : int) (r : coeff) : z %% q = asint r => incoeff z = r.
proof. by move=> h; apply asint_inj; rewrite incoeffK. qed.

lemma incoeffDq (z : int) : incoeff (z + q) = incoeff z.
proof. by rewrite incoeffD (_ : incoeff q = zero) 1:incoeff_eq0P // ZModpRing.addr0. qed.

lemma abs_incoeff (t : int) : -4190208 <= t <= 4190208 => `|incoeff t| = `|t|.
proof. by move=> ht; rewrite /"`|_|" incoeffK_centered /#. qed.

(* the low part of Power2Round is in (-2^(d-1), 2^(d-1)] *)
lemma p2r_t0 (x : coeff) : -(2^(d-1) - 1) <= crepr (Power2Round x).`2 <= 2^(d-1).
proof.
rewrite /Power2Round /= /smodem /=.
have h0 := modz_ge0 (asint x) 8192 _ => //.
have h1 := ltz_pmod (asint x) 8192 _ => //.
rewrite (_ : 2 ^ d = 8192); 1: by do 12!(rewrite expr_pred //=); rewrite expr1.
have -> : 2 ^ 12 = 4096 by do 11!(rewrite expr_pred //=); rewrite expr1.
by case: (4096 < asint x %% 8192) => h; rewrite incoeffK_centered; smt().
qed.
