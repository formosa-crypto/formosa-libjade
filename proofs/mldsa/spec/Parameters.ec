require import AllCore IntDiv List Ring.
require StdOrder.

(* ML-DSA parameters. The constants shared by every parameter set are
   top-level; the parameters of a set are the operators of the abstract
   theory ParamsT, on which the rest of the specification is built and
   which each parameter-set instance realizes. *)

abbrev q : int = 8380417.
abbrev n : int = 256.
axiom prime_q : prime q.
abbrev d : int = 13.

lemma gt0_n : 0 < n by auto.
lemma gt0_d : 0 < d by auto.

abstract theory ParamsT.

op tau : int.                (*    39             49           60      : exact number of 1s in c *)
op lambda : int.             (*   128            192          256      : collision strength of ctilde *)
op gamma1_log : int.         (*    17             19           19      : gamma1 = 2^gamma1_log *)
op gamma2_div : int.         (*    88             32           32      : gamma2 = (q-1) / gamma2_div *)
(* We have k x l matrices *)
op kvec : int.               (*    4              6             8      : number of rows of A *)
op lvec : int.               (*    4              5             7      : number of columns of A *)
op Eta : int.                (*    2              4             2      : private key range *)
op w_hint : int.             (*   80              55            75     : max number of 1s in the hint *)
op kappa_max : int.          (* abstract bound on rejection sampling iterations *)

op gamma1 : int = 2 ^ gamma1_log.        (* coefficient range of y *)
op gamma2 : int = (q - 1) %/ gamma2_div. (* low order rounding range *)
op Beta : int = tau * Eta.               (*   78             196           120     *)

axiom param_sets :
   (tau,lambda,gamma1_log,gamma2_div,kvec,lvec,Eta,w_hint) \in
     [ (39,128,17,88,4,4,2,80);
       (49,192,19,32,6,5,4,55);
       (60,256,19,32,8,7,2,75) ].

axiom kappa_max_bnd : 0 <= kappa_max /\ kappa_max * lvec <= 65536.

(* bit widths of the encoded coefficients: eta-bounded, gamma1-bounded *)
(* and the high bits w1                                                 *)
abbrev noise_bits = if Eta = 4 then 4 else 3.
abbrev gamma1_bits = gamma1_log + 1.
abbrev w1_bits = if gamma2_div = 88 then 6 else 4.

theory MLDSAParams.

lemma gamma1_cases : gamma1 = 131072 \/ gamma1 = 524288.
proof.
have := param_sets; rewrite /gamma1 /=.
by case=> [|[|]] [#] _ _ -> *; [left | right | right];
   do 16!(rewrite expr_pred //=); rewrite ?(expr_pred 2 3) ?(expr_pred 2 2) //= expr1.
qed.

lemma gamma2_cases : gamma2 = 95232 \/ gamma2 = 261888.
proof. by have := param_sets; rewrite /gamma2 /=; smt(). qed.

lemma gt0_eta : 0 < Eta by smt(param_sets).
lemma gt0_k   : 0 < kvec by smt(param_sets).
lemma gt0_l   : 0 < lvec by smt(param_sets).
lemma gt0_beta : 0 < Beta by smt(param_sets).
lemma tau_bound : 1 <= tau <= n /\ tau <= 64 by smt(param_sets).
lemma eta_tau_leq_b : Eta * tau <= Beta by smt(param_sets).
lemma gamma2_bound  : 2 <= gamma2 <= q %/ 4 by smt(gamma2_cases).
lemma gamma2_div : 2 * gamma2 %| (q - 1) by smt(gamma2_cases).
lemma beta_gamma2_lt : Beta < gamma2 by smt(param_sets gamma2_cases).
lemma beta_gamma1_lt : Beta < gamma1 by smt(param_sets gamma1_cases).

(* a nonce k * lvec + r of the mask sampler fits in 16 bits *)
lemma nonce_rng (k r : int) : 0 <= k < kappa_max => 0 <= r < lvec => 0 <= k * lvec + r < 65536.
proof.
move=> hk hr; have hb := kappa_max_bnd; have hl := gt0_l.
have : (k + 1) * lvec <= kappa_max * lvec by apply StdOrder.IntOrder.ler_wpmul2r; smt().
smt().
qed.

end MLDSAParams.

end ParamsT.
