(* Facts on the challenge shared by the ML-DSA safety proofs.

   The bounds of the products by the challenge (polynomial____challenge_positions,
   polynomial____sparse_multiply_16/32) depend on the number of non-zero
   coefficients of the challenge, exactly tau: these lemmas state that count
   (cnz) and how the sampler and the scans of the challenge change it. *)
require import AllCore List IntDiv.
from Jasmin require import JModel_x86.
require import JWordExtra BArray1024.

(* the number of non-zero coefficients of a polynomial of 256 u32 *)
op cnz (c : BArray1024.t) : int = size (ipos (fun k => BArray1024.get32 c k <> W32.zero) 256).

(* the lanes of a 256-bit load at a multiple of 4 are the coefficients *)
lemma get256d_bits32 (t : BArray1024.t) (j b : int) : 0 <= b < 8 =>
  BArray1024.get256d t (4 * j) \bits32 b = BArray1024.get32 t (j + b).
proof.
move=> hb; rewrite /BArray1024.get256d BArray1024.get32dE.
apply W32.wordP => k hk.
rewrite bits32iE // pack32wE 1:/# pack4wE //.
rewrite W32u8.Pack.get_of_list 1:/# W4u8.Pack.get_of_list 1:/# /BArray1024.sub.
rewrite !nth_mkseq 1,2:/# /=.
have -> : (b * 32 + k) %/ 8 = 4 * b + k %/ 8.
+ by rewrite (: b * 32 + k = k + (4 * b) * 8) 1:#ring divzMDr.
have -> : (b * 32 + k) %% 8 = k %% 8.
+ by rewrite (: b * 32 + k = k + (4 * b) * 8) 1:#ring modzMDr.
by congr; congr; ring.
qed.

(* a coefficient whose four bytes are zero is zero *)
lemma get32_zero (t : BArray1024.t) (k : int) :
  (forall b, 4 * k <= b < 4 * k + 4 => t.[b] = W8.zero) => BArray1024.get32 t k = W32.zero.
proof.
move=> hz; rewrite BArray1024.get32dE; apply W32.wordP => x hx.
rewrite pack4wE // W4u8.Pack.get_of_list 1:/# /BArray1024.sub nth_mkseq 1:/# /= hz 1:/#.
by rewrite W8.zerowE.
qed.

(* changing a predicate at one index changes the count of its indices by
   at most one *)
lemma size_ipos_upd (P Q : int -> bool) (n i : int) : 0 <= i < n =>
  (forall k, k <> i => Q k = P k) =>
  size (ipos Q n) = size (ipos P n) - b2i (P i) + b2i (Q i).
proof.
move=> hi hPQ; rewrite /ipos !size_filter.
have e : iota_ 0 n = iota_ 0 i ++ i :: iota_ (i + 1) (n - i - 1).
+ by rewrite (_ : n = i + (1 + (n - i - 1))) 1:#ring iota_add 1,2:/# iota_add 1,2:/# iota1 /= /#.
rewrite e !count_cat /=.
rewrite (eq_in_count Q P (iota_ 0 i)) => [k /mem_iota hk | ]; 1: by rewrite hPQ 1:/#.
rewrite (eq_in_count Q P (iota_ (i + 1) (n - i - 1))) => [k /mem_iota hk | ].
+ by rewrite hPQ 1:/#.
ring.
qed.

(* the sampler writes 1 - 2 * (sign bit), never zero *)
lemma sign_nz (x : W32.t) :
  W32.of_int 1 - ((x `&` W32.of_int 1) `<<` W8.of_int 1) <> W32.zero.
proof.
have -> : x `&` W32.of_int 1 = if x.[0] then W32.one else W32.zero.
+ apply W32.wordP => k hk; rewrite W32.andwE.
  case: x.[0] => h0 /=.
  + rewrite W32.nth_one; case: (k = 0) => [-> | _] /=; 1: by rewrite h0.
    done.
  by rewrite W32.nth_one; case: (k = 0) => [-> | _] //=; rewrite h0.
apply/negP => /W32.WRingA.subr_eq0 /(congr1 (fun (w : W32.t) => w.[0])) /=.
by rewrite /(`<<`) /W32.(`<<<`) W32.nth_one W32.initiE.
qed.

(* the count of a disjoint union *)
lemma size_ipos_or (P Q R : int -> bool) (n : int) :
  (forall k, R k <=> P k \/ Q k) => (forall k, !(P k /\ Q k)) =>
  size (ipos R n) = size (ipos P n) + size (ipos Q n).
proof.
move=> hR hPQ; rewrite /ipos !size_filter.
elim: (iota_ 0 n) => //= x s ih; rewrite ih /b2i.
by case: (P x) => hp; case: (Q x) => hq; smt().
qed.

(* a non-zero coefficient is positive or negative *)
lemma nz_sint (w : W32.t) : w <> W32.zero <=> 0 < W32.to_sint w \/ W32.to_sint w < 0.
proof.
rewrite W32.to_sintE /W32.smod; have := W32.to_uint_cmp w.
case: (w = W32.zero) => [-> /= | hw]; 1: by [].
have : to_uint w <> 0 by move: hw; apply contra => h; apply W32.to_uint_eq; rewrite h.
smt().
qed.

(* the non-zero coefficients are the positive ones and the negative ones *)
lemma cnz_sign (c : BArray1024.t) :
  cnz c = size (ipos (fun k => 0 < W32.to_sint (BArray1024.get32 c k)) 256)
        + size (ipos (fun k => W32.to_sint (BArray1024.get32 c k) < 0) 256).
proof.
rewrite /cnz (size_ipos_or (fun k => 0 < W32.to_sint (BArray1024.get32 c k))
  (fun k => W32.to_sint (BArray1024.get32 c k) < 0)) //.
+ by move=> k /=; apply nz_sint.
by move=> k /=; smt().
qed.
