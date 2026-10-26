
require import AllCore IntDiv CoreMap List Distr StdBigop.
import Bigbool.


lemma BBAnd_big_foldr ['a] (F : 'a -> bool) (r : 'a list) :
  foldr (fun x0 acc => x0 /\ acc) true (map F r) =
  BBAnd.big predT F r.
    proof.
by rewrite /BBAnd.big filter_predT.    
  qed.
  
lemma and_iota (F : int -> bool) i l :
  foldr (fun x0 acc => x0 /\ acc) true (map F (iota_ i l)) <=>
  forall k, i <= k < i + l => F k.
    proof.
      rewrite BBAnd_big_foldr BBAnd.bigP filter_predT List.allP.
    smt( mem_iota).
  qed.

(* Word facts used by the safety proofs *)

from Jasmin require import JWord JModel_x86.

lemma to_uint_popcnt64 (w : W64.t) : 0 <= to_uint (POPCNT_64 w).`6 <= 64.
proof.
have := count_size idfun (W64.w2bits w); have := count_ge0 idfun (W64.w2bits w).
rewrite W64.size_w2bits /POPCNT_64 /flags_w /rflags_of_popcnt /= => h0 h.
by rewrite W64.to_uint_small /ptr_modulus; smt().
qed.

require import BitEncoding.
import BS2Int.

(* the popcount of a value below 2^8 is at most 8 *)
lemma to_uint_popcnt64_byte (w : W64.t) :
  to_uint w < 256 => 0 <= to_uint (POPCNT_64 w).`6 <= 8.
proof.
move=> hw.
have hc : count idfun (W64.w2bits w) = count idfun (int2bs 8 (to_uint w)).
+ have e1 : bs2int (W64.w2bits w) = bs2int (int2bs 8 (to_uint w) ++ nseq 56 false).
  - rewrite -W64.to_uintE bs2int_cat bs2int_nseq_false size_int2bs /= int2bsK //.
    smt(W64.to_uint_cmp).
  have h1 := bs2intK (W64.w2bits w).
  have h2 := bs2intK (int2bs 8 (to_uint w) ++ nseq 56 false).
  move: h1 h2; rewrite W64.size_w2bits size_cat size_int2bs size_nseq /= e1 => h1 h2.
  by rewrite -h1 h2 count_cat count_nseq /idfun /=.
have := count_size idfun (int2bs 8 (to_uint w)).
have := count_ge0 idfun (int2bs 8 (to_uint w)).
rewrite size_int2bs /POPCNT_64 /flags_w /rflags_of_popcnt /= hc => h0 h.
by rewrite W64.to_uint_small /ptr_modulus; smt().
qed.

(* a movemask of eight lanes is below 2^8 *)
lemma to_uint_movemask8 (v : W256.t) : to_uint (MOVEMASK_8u32 v) < 256.
proof.
rewrite /MOVEMASK_8u32 /= W32.to_uintE.
pose bs := map W32.msb (W8u32.to_list v).
have hsz : size bs = 8 by rewrite size_map W8u32.size_to_list.
have -> : W32.w2bits (W32.bits2w bs) = bs ++ nseq 24 false.
+ apply (eq_from_nth false); 1: by rewrite W32.size_w2bits size_cat size_nseq hsz.
  move=> i; rewrite W32.size_w2bits => hi.
  rewrite W32.get_w2bits // W32.get_bits2w // nth_cat hsz.
  by case (i < 8) => h //; smt(nth_nseq nth_default).
rewrite bs2int_cat bs2int_nseq_false hsz /=.
by have := bs2int_le2Xs bs; rewrite hsz /=.
qed.

lemma to_uint_popcnt64_movemask8 (x : W256.t) :
  0 <= to_uint (POPCNT_64 (zeroextu64 (MOVEMASK_8u32 x))).`6 <= 8.
proof.
apply to_uint_popcnt64_byte; rewrite /zeroextu64 W64.of_uintK.
by have := to_uint_movemask8 x; have := W32.to_uint_cmp (MOVEMASK_8u32 x); smt().
qed.

(* the "done" flags of the hint decoder: a condition byte or-ed with a
   0/1 word is zero iff both are *)
lemma setcc_or_eq0 (b : bool) (x : W64.t) :
  x = W64.zero \/ x = W64.one =>
  (SETcc b `|` truncateu8 x = W8.zero) = (!b /\ x = W64.zero).
proof.
have t0 : truncateu8 W64.zero = W8.zero by done.
have t1 : truncateu8 W64.one = W8.one by done.
have h10 : W8.one <> W8.zero by rewrite W8.to_uint_eq.
have h10' : W64.one <> W64.zero by rewrite W64.to_uint_eq.
by case=> ->; case b; rewrite /SETcc /= ?t0 ?t1 ?W8.orw0 ?W8.or0w ?W8.orww /#.
qed.

(* bytes are below 2^8 (W8.modulus is opaque to the provers) *)
lemma to_uint_W8_lt256 (x : W8.t) : 0 <= to_uint x < 256.
proof. by have /= := W8.to_uint_cmp x. qed.

(* the byte offset of a coefficient count below 2^62 does not wrap *)
lemma to_uint_mul4 (x : W64.t) :
  to_uint x <= 1024 => to_uint (W64.of_int 4 * x) = 4 * to_uint x.
proof.
move=> h; rewrite W64.to_uintM W64.of_uintK /= modz_small //.
smt(W64.to_uint_cmp).
qed.

(* the popcount of a value below 2^k is at most k *)
lemma to_uint_popcnt64_le (w : W64.t) (k : int) :
  0 <= k <= 64 => to_uint w < 2 ^ k => 0 <= to_uint (POPCNT_64 w).`6 <= k.
proof.
move=> [hk0 hk] hw.
have hsz : size (int2bs k (to_uint w)) = k by rewrite size_int2bs /#.
have hc : count idfun (W64.w2bits w) = count idfun (int2bs k (to_uint w)).
+ have e1 : bs2int (W64.w2bits w) = bs2int (int2bs k (to_uint w) ++ nseq (64 - k) false).
  - by rewrite -W64.to_uintE bs2int_cat bs2int_nseq_false int2bsK //; smt(W64.to_uint_cmp).
  have h1 := bs2intK (W64.w2bits w).
  have h2 := bs2intK (int2bs k (to_uint w) ++ nseq (64 - k) false).
  move: h1 h2; rewrite W64.size_w2bits size_cat hsz size_nseq.
  have -> : k + max 0 (64 - k) = 64 by smt().
  rewrite e1 => h1 h2.
  by rewrite -h1 h2 count_cat count_nseq /idfun /=.
have := count_size idfun (int2bs k (to_uint w)).
have := count_ge0 idfun (int2bs k (to_uint w)).
rewrite hsz /POPCNT_64 /flags_w /rflags_of_popcnt /= hc => h0 h.
by rewrite W64.to_uint_small /ptr_modulus; smt().
qed.

lemma to_uint_popcnt64_nibble (w : W64.t) :
  to_uint w < 16 => 0 <= to_uint (POPCNT_64 w).`6 <= 4.
proof. by move=> h; apply (to_uint_popcnt64_le w 4). qed.

(* the disjunction of two words is zero only when both are *)
lemma orw_eq0 (x y : W64.t) : x `|` y = W64.zero => x = W64.zero /\ y = W64.zero.
proof.
move=> h; split; apply/W64.wordP => i hi;
  by have := congr1 (fun (w : W64.t) => w.[i]) _ _ h; rewrite /= W64.orwE W64.zerowE /#.
qed.

(* the opposite of a word is zero only when the word is *)
lemma negw_eq0 (x : W64.t) : (- x = W64.zero) <=> (x = W64.zero).
proof. by rewrite -!W64.to_uint_eq W64.to_uintN /=; smt(W64.to_uint_cmp). qed.
