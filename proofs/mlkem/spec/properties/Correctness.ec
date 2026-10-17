require import AllCore IntDiv RealExp StdOrder RealExp Ring List Distr DInterval.

from Jasmin require import JWord JUtils.

from JazzEC require import Array25 Array256 Array384 Array128 Array168  Array32.


(*---*) import BitEncoding BitChunking BS2Int.
(*---*) import RField RealOrder IntOrder IntID.

require import MLKEMLib DistrExtra.
require NttResidue.
from Spec require import GFq Rq Parameters Symmetric Sampling VecMat  Serialization KPKE MLKEM.
import Zq MLKEMParams PolyVec PolyMat.

(* Signed representation: could go in coeff *)

lemma as_sintK x:
 incoeff (as_sint x) = x.
proof. by smt(asintK). qed.

lemma incoeffK_sint_small n: 
 - (q-1) %/ 2 <= n <= (q-1) %/ 2 =>
 as_sint (incoeff n) = n.
proof. move=> H; smt(incoeffK). qed.

lemma as_sint_range x :  - (q-1) %/2 <= as_sint x <= (q-1) %/2 by smt(rg_asint).

lemma as_sint_bounded x y eps:
`| asint x - asint y | <= eps
 => `| as_sint (x-y) | <= eps.
proof.
rewrite !normP; move=> [Hl Hr].
case: ((q - 1) %/ 2 < asint (x - y)%BigDom.CR) => C.
 smt(incoeffN incoeffK asintK).
smt(incoeffN incoeffK asintK).
qed.

abbrev absZq (x: coeff): int = `| as_sint x |.

lemma absZqB x y eps:
 `| asint x - asint y | <= eps => absZq (x-y) <= eps
by apply as_sint_bounded.

lemma absZqP x eps:
 absZq x <= eps 
 <=> (asint x <= eps \/ q - eps <= asint x)
by smt(rg_asint).

(* Compress-error bound *)
op Bq d = round (q%r / (2^(d+1))%r).

lemma Bq_le_half d:
 0 < d =>
 (q%r / (2^(d+1))%r) <= (q-1)%r/2%r.
proof.
move=> gt0 //; rewrite exprS 1:/# fromintM.
have ?: q%r / (2 ^ d)%r + 1%r <= q%r - 1%r by smt(lt_pow expr_gt0).
apply ler_pdivl_mulr;1:smt().
rewrite (RField.mulrC (2%r)) invrM;1,2:by smt(lt_pow expr_gt0).
by rewrite RField.mulrC (RField.mulrA (q%r)) (RField.mulrC (q%r)) !RField.mulrA /#.
qed.

lemma dvdzN_q_2d (d: int):
 0 < d =>
 q %% 2^d <> 0.
proof.
elim/natind: d; first smt().
move=> d Hd IH _.
case: (0<d) => HHd; last first.
 by have ->/=/#: d=0 by smt(). 
rewrite exprD_nneg // expr1.
move: (IH HHd); apply contra.
by rewrite -!dvdzE /#.
qed.

lemma Bq_noties d:
 0 < d =>
 2^d < q =>
 frac (q%r / (2 ^ (d + 1))%r) <> inv 2%r.
proof.
move=> Hd0 Hd.
rewrite exprS 1:/#.
have ->: q%r / (2 * 2 ^ d)%r
         = inv 2%r * q%r / (2 ^ d)%r by smt().
apply frac_halfN.
rewrite !mulrA divrr //= frac_div_eq0.
 smt(expr_gt0).
by apply dvdzN_q_2d.
qed.

lemma Bq1E: Bq 1 = 832
by rewrite /Bq /= round_divz 1:// qE.

lemma Bq4E: Bq 4 = 104
by rewrite /Bq /= round_divz 1:// qE.

(* Compression and decompression are used as operations between 
   polynomials over coeff, but we first define the basic operations 
   over coefficients. *)

lemma comp_bound d x:
 0 < d =>
 2^d < q =>
 x * (2 ^ d)%r / q%r - inv 2%r
 < (comp d x)%r <= x * (2 ^ d)%r / q%r + inv 2%r.
proof. smt(round_bound). qed.

lemma comp_asint_bound d x:
 0 < d =>
 2^d < q =>
 (asint x)%r * (2 ^ d)%r - q%r / 2%r < q%r * (comp d (asint x)%r)%r
 && q%r * (comp d (asint x)%r)%r <= (asint x)%r * (2 ^ d)%r + q%r / 2%r.
proof. smt(round_bound). qed.

lemma comp_asint_range d x:
 0 < d =>
 2^d < q =>
 0 <= comp d (asint x)%r <= 2^d.
proof.
move=> *; split.
 rewrite -(from_int_round 0); apply round_mono.
 smt(expr_gt0 rg_asint RealOrder.divr_ge0).
move=> _.
have /#: (comp d (asint x)%r)%r < q%r * (2^d)%r / q%r + inv 2%r.
apply (RealOrder.ler_lt_trans ((asint x)%r*(2^d)%r/q%r+ inv 2%r)).
 by move: (comp_bound d (asint x)%r); smt().
by rewrite RealOrder.ltr_add2r RealOrder.ltr_pmul2r 1:/# RealOrder.ltr_pmul2r; smt(expr_gt0 rg_asint).
qed.

lemma comp_over d x:
 0 < d =>
 2^d < q =>
 comp d (asint x)%r = 2^d
 <=> q%r - q%r / (2^(d+1))%r <= (asint x)%r.
proof.
move=> Hd0 Hd.
have ->: (comp d (asint x)%r = 2^d) <=> (2^d <= comp d (asint x)%r) by smt(comp_asint_range).
rewrite le_roundE -RealOrder.ler_subl_addr ler_pdivl_mulr 1:/# RField.mulrBl.
rewrite -eqboolP eq_sym eqboolP.
rewrite RealOrder.ler_subl_addl -RealOrder.ler_subl_addr ler_pdivl_mulr.
 smt(expr_gt0).
by rewrite exprD_nneg 1..2:/# /= fromintM /#.
qed.

lemma compress0L d x:
 0 < d =>
 2^d < q =>
 q%r - q%r / (2^(d+1))%r <= (asint x)%r =>
 Compress d x = 0.
proof.
move=> Hd0 Hd Hx; rewrite /Compress.
have ->: comp d (asint x)%r = 2^d.
 by rewrite comp_over // modzz.
by rewrite modzz.
qed.

lemma compress_small d x:
 0 < d =>
 2^d < q =>
 (asint x)%r < q%r - q%r / (2^(d+1))%r =>
 Compress d x = comp d (asint x)%r.
proof.
move=> Hd0 Hd Hx.
rewrite /Compress.
rewrite modz_small 2:/# ger0_norm.
 smt(expr_ge0).
have ?: comp d (asint x)%r <> 2^d by rewrite comp_over // /#. 
smt(comp_asint_range).
qed.

lemma compress1_is0 x:
 Compress 1 x = 0 <=> absZq x <= Bq 1.
proof.
have L: forall y m, 0 <= y <= m => y %% m = 0 <=> y=0 \/ y=m.
 move=> y m H; case: (y=m) => E.
  by rewrite E modzz /#.
 by rewrite modz_small /#.
rewrite Bq1E /Compress L.
 by apply comp_asint_range => //= /#.
by rewrite absZqP qE /= -fromintM round_divz 1:/# /=; smt(rg_asint).
qed.

lemma decompress0 d:
 Decompress d 0 = Zq.zero
by rewrite /Decompress /= from_int_round.

lemma decomp_bound d x:
 0 < d =>
 2^d < q =>
 0 <= x < 2^d =>
 0 <= decomp d x%r < q.
proof. 
move=> Hd0 Hd Hx; split; 1: by smt(round_bound). 
have H := (round_bound (x%r * q%r / (2 ^ d)%r)).  
move => H0.
have ? : x%r * q%r / (2 ^ d)%r + inv 2%r < q%r; last by smt().
rewrite RField.mulrC RField.mulrA. 
have : x%r * q%r + (2 ^ d)%r * inv 2%r < (2 ^ d)%r * q%r by smt().
have -> : x%r * q%r + (2 ^ d)%r / 2%r =
          (2 ^ d)%r  * (inv (2 ^ d)%r * x%r * q%r + inv 2%r).
   by rewrite RField.mulrDr RField.mulrA RField.mulrA RField.divrr;  smt(gt0_pow2). 
apply RealOrder.ltr_pmul2l.
  smt(expr_gt0).
qed.

lemma decomp_mono d (x y: real):
 0 < d =>
 2^d < q =>
 x <= y =>
 decomp d x <= decomp d y. 
proof.
move=> ???.
apply round_mono.
rewrite -!mulrA ler_pmul2r // mulrC.
smt(RealOrder.divr_gt0 expr_gt0).
qed.

(* These operations introduce a rounding error, which we see additively *)
op compress_err(d : int, c: coeff) : coeff = Decompress d (Compress d c) - c.

lemma decompress_errE c d : 
   0 < d => 2^d < q => Decompress d (Compress d c) = c + (compress_err d c)
by rewrite /compress_err => *; ring.

lemma decomp_comp d x:
 0 < d =>
 2^d < q =>
 x - Bq d <= decomp d (comp d x%r)%r <= x + Bq d.
proof.
move=> Hd0 Hd.
have [Hl Hr]:= comp_bound d x%r Hd0 Hd.
have Hl': x%r * (2 ^ d)%r / q%r - inv 2%r <= (comp d x%r)%r by smt().
split.
 move: (decomp_mono d _ _ Hd0 Hd Hl').
 have ->: decomp d (x%r * (2 ^ d)%r / q%r - inv 2%r) = x - Bq d.
  have ->: ((x%r * (2 ^ d)%r / q%r - inv 2%r) * q%r / (2 ^ d)%r) = x%r - q%r / (2 ^ (d+1))%r.
   by field; smt(expr_gt0 exprS).
  rewrite roundDz roundN.
   by apply Bq_noties. 
  smt().
 smt().
move=> _.
move: (decomp_mono d _ _ Hd0 Hd Hr).
have ->: decomp d (x%r * (2 ^ d)%r / q%r + inv 2%r) = x + Bq d.
 have ->: ((x%r * (2 ^ d)%r / q%r + inv 2%r) * q%r / (2 ^ d)%r) = x%r + q%r / (2 ^ (d+1))%r. 
  by field; smt(expr_gt0 exprS).
 by rewrite roundDz /#.
smt().
qed.

(* This lemma is stated in the Spec *)
lemma compress_decompress d x:
 0 < d =>
 2^d < q =>
 absZq (x - Decompress d (Compress d x)) <= Bq d.
proof.
move=> Hd0 Hd.
case: ((asint x)%r < q%r - q%r / (2^(d+1))%r).
 move=> Hx; rewrite compress_small //.
 apply absZqB; apply normP.
 have XX: forall (b x y: int), y-b <= x <= y+b => -b <= y-x <= b by smt().
 apply XX. clear XX.
 rewrite incoeffK modz_small; last first.
  by apply decomp_comp.
 apply bound_abs.
 apply decomp_bound => //.
 have [_ Hc]:= (comp_bound d (asint x)%r _ _) => //.
 split.
  by apply round_ge0; smt(expr_gt0 rg_asint).
 move => _.
 have /#: (comp d (asint x)%r)%r < (2^d)%r.
 apply (RealOrder.ltr_le_trans ((q%r-q%r / (2 ^ (d + 1))%r) * (2 ^ d)%r / q%r + inv 2%r)) => //.
  apply (RealOrder.ler_lt_trans ((asint x)%r * (2 ^ d)%r / q%r + inv 2%r)) => //.
  apply RealOrder.ltr_add2r.
  rewrite -!mulrA; apply RealOrder.ltr_pmul2r.
   smt(expr_gt0).
  smt().
 rewrite exprS 1:/# fromintM. 
 have ->: (q%r - q%r / (2%r * (2 ^ d)%r)) * (2 ^ d)%r / q%r = (2^d)%r - inv 2%r by field; smt(expr_gt0).
 smt().
move=> Hx.
rewrite compress0L // 1:/# decompress0 /= ZqRing.oppr0 ZqRing.addr0.
have ?:= Bq_le_half d.
have Hhi: q%r - q%r / (2 ^ (d + 1))%r <= (asint x)%r by smt().
have ->: as_sint x = asint x - q by smt(asint_crepr rg_crepr rg_asint).
smt(round_bound rg_asint).
qed.

(* As a corollary we get a bound on the additive error term *)
lemma compress_err_bound (c:coeff) d : 
   0 < d => 2^d < q =>
     `| as_sint (compress_err d c) | <= round (q%r / (2^(d+1))%r).
proof.
move => *.
have ->: compress_err d c 
         = -(c - Decompress d (Compress d c))%Zq.
 by rewrite decompress_errE //; ring.
rewrite creprN; 1: by smt(prime_q).
rewrite normrN.
by apply compress_decompress.
qed.


(*******************************************************)
(* This is an extension of the spec with alternative   *)
(*   ways to compute compression and decompression, as *)
(*   well as defining rounding errors additively       *)
(*******************************************************)

lemma compress_alt_nice c d :
    Compress d c = (asint c * 2^d + (q %/ 2)) %/ q %% 2^d.
proof.
move=> *.
rewrite /Compress /round ; congr; congr.
have ->: (asint c * 2 ^ d + q %/ 2) %/ q
 = (2*asint c * 2 ^ d + q) %/ (2*q)
by smt().
rewrite divz_floor 1:/#; congr.
field; smt().
qed.

(* This is the implementation of compress d in C/Jasmin for d = 1,4 *)
op compress_alt(d : int, c : coeff) : int =
    (asint c * 2^d + ((q + 1) %/ 2)) * (2^28 %/ q) %/ 2^28 %% 2^d.

lemma compress_alt_compress c d :    
   1 <= d <=4 =>
      compress_alt d c = Compress d c.
proof.
move => db; rewrite compress_alt_nice /compress_alt qE =>  /=.
case (d = 1).
+ by move => ->;have ? : all
     (fun x => (x * 2 + 1665) * 80635 %/ 268435456 %% 2 = (x * 2 + 1664) %/ 3329 %% 2) 
        (iota_ 0 3229); [by rewrite -iotaredE //= | smt(mem_iota gtp_asint ge0_asint)].
move => *;case (d = 2).
+ by move => ->;have ? : all
     (fun x => (x * 4 + 1665) * 80635 %/ 268435456 %% 4 = (x * 4 + 1664) %/ 3329 %% 4) 
        (iota_ 0 3229); [by rewrite -iotaredE //= | smt(mem_iota gtp_asint ge0_asint)].
move => *;case (d = 3).
+ by move => ->;have ? : all
     (fun x => (x * 8 + 1665) * 80635 %/ 268435456 %% 8 = (x * 8 + 1664) %/ 3329 %% 8) 
        (iota_ 0 3229); [by rewrite -iotaredE //= | smt(mem_iota gtp_asint ge0_asint)].
move => *;case (d = 4).
+ by move => ->;have ? : all
     (fun x => (x * 16 + 1665) * 80635 %/ 268435456 %% 16 = (x * 16 + 1664) %/ 3329 %% 16) 
        (iota_ 0 3229); [by rewrite -iotaredE //= | smt(mem_iota gtp_asint ge0_asint)].
by smt().
qed.

(* du/dv compress implementations in C/Jasmin — the W32/W64 shift constants
   differ between variants, so they live in variant-namespace subtheories. *)
theory Compress768.   (* du = 10, dv = 4 *)
op compress_alt_large (c : coeff) : int =
   (asint c * 2 ^ 10 + (q + 1) %/ 2) * (2 ^ 32 %/ q) %/ 2 ^ 32 %% 2 ^ 10.

lemma compress_alt_compress_large (c : coeff):
    compress_alt_large c = Compress 10 c.
rewrite compress_alt_nice /compress_alt_large qE =>  /=.
by have ? : all
     (fun x => (x * 1024 + 1665) * 1290167 %/ 4294967296 %% 1024 = (x * 1024 + 1664) %/ 3329 %% 1024)
        (iota_ 0 3229); [by rewrite -iotaredE //= | smt(mem_iota gtp_asint ge0_asint)].
qed.
end Compress768.

theory Compress1024.   (* du = 11, dv = 5 *)
op compress_alt5(c : coeff) : int =
    (asint c * 32 + ((q - 1) %/ 2)) * (2^27 %/ q + 1) %/ 2^27 %% 32.

lemma compress_alt_compress5 c :
      compress_alt5 c = Compress 5 c.
proof.
rewrite compress_alt_nice /compress_alt5 qE =>  /=.
+ by  have  : all
     (fun x => (x * 32 + 1664) * 40318 %/ 134217728 %% 32 = (x * 32 + 1664) %/ 3329 %% 32)
        (iota_ 0 3229); [by rewrite -iotaredE //= | smt(mem_iota gtp_asint ge0_asint)].
qed.

op compress_alt_large (c : coeff) : int =
   (asint c * 2 ^ 11 + (q - 1) %/ 2) * (2 ^ 31 %/ q + 1) %/ 2 ^ 31 %% 2 ^ 11.

lemma compress_alt_compress_large (c : coeff):
    compress_alt_large c = Compress 11 c.
rewrite compress_alt_nice /compress_alt_large qE =>  /=.
have ? : all
     (fun x => (x * 2048 + 1664) * 645084 %/ 2147483648 %% 2048 = (x * 2048 + 1664) %/ 3329 %% 2048)
        (iota_ 0 3229); [by rewrite -iotaredE //= | ].
congr;congr; smt(allP mem_iota gtp_asint ge0_asint).
qed.
end Compress1024.

(* This is the implementation of decompress d in C/Jasmin *)
op decompress_alt(d : int, c : int) : coeff = 
    incoeff (((c * q + 2^(d-1)) %/ 2^d)).

lemma decompress_alt_decompress c d : 
   0 < d => d<=11 =>
    decompress_alt d c = Decompress d c.
proof.
move => *.
rewrite /decompress_alt /Decompress /round; congr.
rewrite mulrC divz_floor; first smt(expr_gt0).
congr; field; first 2 smt(expr_gt0).
rewrite mulrC mulrA.
have ->: 2 ^ d = 2^(d-1+1) by done.
by rewrite exprS 1:/#; field.
qed.

(** End extension *)

(* Encoding/decoding of Booleans as field elements *)
op trueval : coeff = incoeff ((q+1) %/ 2).
op falseval : coeff = Zq.zero.

lemma trueval_int : asint trueval = ((q+1) %/ 2) by smt(incoeffK).
lemma falseval_int : asint falseval = 0 by smt(incoeffK).

op b_encode(b: bool): coeff =
  if b then trueval else falseval.

lemma b_encode_int (b : bool) :
   asint (b_encode b) = 
    if b then (q+1) %/ 2 else 0 by smt(trueval_int falseval_int).

op b_decode(c: coeff) : bool = ! `| as_sint c| < q %/ 4 + 1.

(* The spec uses compress and decompress to do encode/decode,
   so these should be true *)
lemma b_encode_sem c :
 b_encode c = Decompress 1 (if c then 1 else 0)
by rewrite /b_encode -decompress_alt_decompress -1:/decompress_alt //; smt(qE).


lemma b_decode_sem c :
   Compress 1 c = if b_decode c then 1 else 0
by rewrite /b_decode -compress_alt_compress -1:/compress_alt //=; smt(qE rg_asint).



(*****************************************************)
(* Rq: polynomials in Zq[X]/(X^256+1) *)
(*****************************************************)

op compress_poly_err(d : int, p : poly) : poly =  map (compress_err d) p.

lemma round_poly_errE p d : p &+ (compress_poly_err d p) = decompress_poly d (compress_poly d p).
proof. 
rewrite /compress_poly_err /decompress_poly /(&+); apply Array256.ext_eq => /> x xl xh.
rewrite map2iE //= mapiE //= !mapiE // /compress_err. by ring.
qed.

(* The NTT operation over ring elements 

We give here the mathematical specification of the NTT in
a way that roughly matches what is described in the spec.

Then we will have an NTT.ec file where we prove that 1) the imperative
specs are equivalent to these operators and 2) that these operators have
the properties we require to show that MLKEM is correct up to some
decryption failure bound.

*)


(* We can now set-up the EC algebraic libraries *)

(* Note that I have no way to pass the ring operations
   to this theory because it takes the representation
   to be that of the base ring of polynomials, which 
   I never work with. *)

(* poly-ring algebraic bridge (RqTheory/AlgR, poly2polyr/polyr2poly,
   add_lift/sub_lift/mul_lift/zero_lift/one_lift, unit/invr) relocated
   to Rq.ec; the Matrix clone, conversions and ntt_*E to VecMat.ec. *)


(* Algebraic vector/matrix semantics, the `ring` instance, and
   ntt_mmulE/ntt_dotpE were relocated to the spec: the poly-ring bridge
   lives in Rq.ec, and the Matrix clone (own vector/matrix), conversions
   (poly2alg/alg2poly), ring instance and ntt_*E live in VecMat.ec.
   The old getvE/setvE/... bridge axioms are GONE — polyvec = poly KVec.t
   is concrete, so its accessors reduce on their own. *)

(****************************************************)
(*               Distributions over coeff              *)
(*   We will have two views: the operator semantics *)
(*  will be used to reason about security/failures. *)
(*  The equivalent imperative version will be used  *)
(*  to relate the security proof to the implem.     *)
(*  These distrubutions over coeff are then used to    *)
(*  define distributions over poly/R by sampling    *)
(*  each coefficient independently.                 *)
(****************************************************)

(* The binomial distribution over a field element *)

op dshort_elem : coeff distr = dmap (dcbd 2) incoeff.

lemma dshort_elem_ll: is_lossless dshort_elem.
proof.
by apply dmap_ll; apply ll_dcbd.
qed.

(* Definition of the support *)
lemma supp_dshort_elem x:
 x \in dshort_elem <=> -2 <= as_sint x <= 2.
proof.
rewrite supp_dmap; split.
 move=> [y []]; rewrite supp_dcbd.
 move=> H ->; rewrite incoeffK_sint_small /#.
move=> H; exists (as_sint x); rewrite supp_dcbd.
split => //.
by rewrite as_sintK.
qed.

(* Probability of each value in the support *)
lemma dshort_elem1E_2 : mu1 dshort_elem (incoeff 2) = 1%r / 16%r.
proof.
rewrite /dshort_elem (in_dmap1E_can (dcbd 2) _ as_sint).
  by rewrite as_sintK.
 move=> y; rewrite supp_dcbd; move=> ? <-.
 by rewrite /= incoeffK_sint_small /#.
rewrite /= incoeffK_sint_small; 1: by smt(qE).
by rewrite dcbd1E mcbd_2_2.
qed.

lemma dshort_elem1E_m2 : mu1 dshort_elem (incoeff (-2)) = 1%r / 16%r.
proof.
rewrite /dshort_elem (in_dmap1E_can (dcbd 2) _ as_sint).
  by rewrite as_sintK.
 move=> y; rewrite supp_dcbd; move=> ? <-.
 by rewrite /= incoeffK_sint_small /#.
rewrite /= incoeffK_sint_small; 1: by smt(qE).
by rewrite dcbd1E mcbd_2_2N.
qed.

lemma dshort_elem1E_1 : mu1 dshort_elem (incoeff 1) = 1%r / 4%r.
proof.
rewrite /dshort_elem (in_dmap1E_can (dcbd 2) _ as_sint).
  by rewrite as_sintK.
 move=> y; rewrite supp_dcbd; move=> ? <-.
 by rewrite /= incoeffK_sint_small /#.
rewrite /= incoeffK_sint_small; 1: by smt(qE).
by rewrite dcbd1E mcbd_2_1.
qed.

lemma dshort_elem1E_m1 : mu1 dshort_elem (incoeff (-1)) = 1%r / 4%r.
proof.
rewrite /dshort_elem (in_dmap1E_can (dcbd 2) _ as_sint).
  by rewrite as_sintK.
 move=> y; rewrite supp_dcbd; move=> ? <-.
 by rewrite /= incoeffK_sint_small /#.
rewrite /= incoeffK_sint_small; 1: by smt(qE).
by rewrite dcbd1E mcbd_2_1N.
qed.

lemma dshort_elem1E_0 : mu1 dshort_elem (incoeff 0) = 3%r / 8%r. 
proof.
rewrite /dshort_elem (in_dmap1E_can (dcbd 2) _ as_sint).
  by rewrite as_sintK.
 move=> y; rewrite supp_dcbd; move=> ? <-.
 by rewrite /= incoeffK_sint_small /#.
rewrite /= incoeffK_sint_small; 1: by smt(qE).
by rewrite dcbd1E mcbd_2_0.
qed.


(* The uniform distribution over a field element *)
op duni_elem : coeff distr = DZmodP.dunifin.

lemma duni_elem_ll: is_lossless duni_elem
 by exact DZmodP.dunifin_ll.

(* Definition of the support *)
lemma supp_duni_elem x:
 0 <= asint x < q <=> x \in duni_elem.
proof.
rewrite /duni_elem DZmodP.dcoeffE supp_dmap; split.
 move=> H; exists (asint x); split.
  rewrite supp_dinter; smt(rg_asint).
 by rewrite asintK.
move=> [a []]; rewrite supp_dinter => ? ->.
by rewrite incoeffK /#.
qed.

(* The probability of each value in the support. *)
op pe = 1%r /q%r.
lemma duni_elem1E x: mu1 duni_elem x = pe.
proof.
rewrite duniform1E_uniq.
 exact DZmodP.Support.enum_uniq.
by rewrite DZmodP.Support.enumP size_map size_range /#.
qed.

lemma duni_elemE: duni_elem = dmap [0..q-1] incoeff.
proof.
apply eq_distr => x.
rewrite duni_elem1E dmap1E /(\o) /=.
rewrite (mu_eq_support _ _ (pred1 (asint x))).
 move=> y; rewrite supp_dinter /pred1 => /> *.
 rewrite eqboolP; split.
  by move=> <-; rewrite incoeffK modz_small /#.
 by move => ->; rewrite asintK.
by rewrite dinter1E ifT; smt(rg_asint).
qed.

lemma duni_elem_uni : is_uniform duni_elem 
  by rewrite /is_uniform => *; rewrite !duni_elem1E.

lemma duni_elem_fu : is_full duni_elem
  by rewrite /is_full /support => x; rewrite duni_elem1E; smt(qE).

(* The distribution of ring elements of small norm as an operator *)

abbrev dR (d: coeff distr): poly distr = darray256 d.

lemma dR_ll d:
 is_lossless d => is_lossless (dR d)
by exact darray256_ll.

lemma supp_dR d p:
 p \in dR d <=> all (support d) (Array256.to_list p)
by exact supp_darray256.

lemma dR_fu d:
 is_full d => is_full (dR d)
by exact darray256_fu.

lemma dR_uni d:
 is_uniform d => is_uniform (dR d)
by exact darray256_uni.



op dshort_R : poly distr = dR dshort_elem.

lemma dshort_R_ll : is_lossless dshort_R
by smt(dR_ll dshort_elem_ll).

(* The uniform distribution of ring elements as an operator *)

op duni_R : poly distr =  dR duni_elem.

lemma duni_R_ll : is_lossless duni_R
by smt(dR_ll duni_elem_ll).

lemma duni_R_uni : is_uniform duni_R
by smt(dR_uni duni_elem_uni).

lemma duni_R_fu : is_full duni_R
by smt(dR_fu duni_elem_fu).



(****************************************************************************)
(****************************************************************************)
(*  Encoding polys and vectors to and from byte arrays                      *)
(****************************************************************************)
(****************************************************************************)


lemma ofipolyvecK_small (x : ipolyvec) :
    (forall k, 0 <= k < 256 * kvec => 0 <= x.[k] < q) =>  toipolyvec (ofipolyvec x) = x.
move => bnd.
apply IPVec.tP => k kb.
rewrite /toipolyvec IPVec.initiE //= /ofipolyvec KVec.initiE 1:/# /=.
rewrite /subarray256 mapiE 1:/# initiE 1:/# /=.
have ->: 256 * (k %/ 256) + k %% 256 = k by smt(divz_eq).
rewrite incoeffK; smt(modz_small).
qed.

lemma toipolyvecK (x : PolyVec.polyvec) :
   ofipolyvec (toipolyvec x) = x.
apply KVec.tP => i ib.
rewrite /ofipolyvec KVec.initiE //=.
apply Array256.tP => j jb.
rewrite /subarray256 mapiE 1:/# initiE 1:/# /=.
rewrite /toipolyvec IPVec.initiE 1:/# /=.
have ->: (256 * i + j) %/ 256 = i by smt(divzMDl).
have ->: (256 * i + j) %% 256 = j by smt(modzMDl).
by rewrite asintK.
qed.

(************************************)
(************************************)
(* SAMPLING PROCEDURES CORRECTNESS  *)
(************************************)
(************************************)

require import IntMin.
require import EclibExtra.
require import JWordList.
from CryptoSpecs require import Keccak1600_Spec Keccak1600_Orbit.
require import Agree Rejstream.

(** parses a byte list into (candidate) coefficients *)
op bytes2coeffs(bytes : W8.t list) : int list =
 map bs2int (chunk 12 (bytes_to_bits bytes)).

lemma bytes2coeffs_nil:
 bytes2coeffs [] = [].
proof.
by rewrite /bytes2coeffs bytes_to_bits_nil chunk0 //=.
qed.

lemma bytes2coeffs_cat l1 l2:
 3 %| size l1 => bytes2coeffs (l1++l2) = bytes2coeffs l1 ++ bytes2coeffs l2.
proof.
move=> /dvdzP [k Hl1].
rewrite /bytes2coeffs -map_cat; congr.
rewrite -chunk_cat.
 by rewrite size_bytes_to_bits Hl1 (mulzC k) -mulzA 1:/#.
by rewrite -bytes_to_bits_cat /#.
qed.

lemma size_bytes2coeffs l:
 size (bytes2coeffs l) = 2 * size l %/ 3.
proof.
by rewrite /bytes2coeffs size_map size_chunk // size_bytes_to_bits /#.
qed.

(* performs "rejection" of bad coefficients *)
op rejection l =
 map incoeff (filter (fun x => x<q) (bytes2coeffs l)).

op rejection16 l =
 map (fun x => W16.of_int (asint x)) (rejection l).

lemma rejection16E l:
 rejection16 l
 = map W16.of_int (filter (fun x => x<q) (bytes2coeffs l)).
proof.
rewrite /rejection16 /rejection -map_comp /(\o) /=.
apply eq_in_map => x /mem_filter /= [Hx /mapP [n [_ Hn]]].
rewrite to_uint_eq !of_uintK modz_small incoeffK 1:/#.
rewrite modz_small; first smt(bs2int_ge0).
by rewrite modz_small; first smt(bs2int_ge0).
qed.

lemma rejection0: rejection [] = [].
proof. by rewrite /rejection bytes2coeffs_nil. qed.

lemma rejection_cat l1 l2:
 3 %| size l1 =>
 rejection (l1 ++ l2) = rejection l1 ++ rejection l2.
proof.
by move=> H; rewrite /rejection bytes2coeffs_cat // filter_cat map_cat.
qed.

lemma size_rejection_le st i:
 size (rejection (squeezestate_i c256_r8 st i)) <= 112.
proof.
rewrite /rejection size_map.
have <-: size (bytes2coeffs (squeezestate_i c256_r8 st i)) = 112.
 by rewrite size_bytes2coeffs /= size_squeezestate_i.
by apply size_filter_le.
qed.

(* a variation of [size_rejection_le] *)
lemma size_rejection_le' n' l n:
 n = 2*n' %/ 3 =>
 size l <= n' =>
 size (rejection l) <= n.
proof.
move=> -> H; rewrite /rejection size_map.
apply (ler_trans (size (bytes2coeffs l))).
 by apply size_filter_le.
by rewrite size_bytes2coeffs /#.
qed.

(** [expand_seed] expands a seed to a given number of blocks... *)
abbrev rejection_seed (seed: W8.t Array32.t * (W8.t * W8.t)) =
 to_list seed.`1 ++ [seed.`2.`1; seed.`2.`2].

op expand_seed (seed: W8.t Array32.t * (W8.t * W8.t)) nb =
 SHAKE128_SQUEEZEBLOCKS (SHAKE128_ABSORB (rejection_seed seed)) nb. 

lemma size_expand_seed m nb:
 0 <= nb =>
 size (expand_seed m nb) = 3*(56*nb).
proof.
move=> Hnb.
by rewrite /expand_seed size_squeezeblocks 1:/# // /#.
qed.

lemma expand_seed0 m nb:
 nb <= 0 =>
 expand_seed m nb = [].
proof.
by move=> Hnb; rewrite /expand_seed /squeezeblocks iota0 //.
qed.

(** [nblocks] suffices to build a polynomial *)
op enough_blocks m (nblocks: int): bool =
 256 <= size (rejection (expand_seed m nblocks)).

lemma enough_blocks_ge0 m nb:
 enough_blocks m nb => 0 <= nb.
proof.
rewrite /enough_blocks => H.
case: (nb <= 0) => E; 2: smt().
move: H; rewrite /expand_seed /squeezeblocks iota0 //.
by rewrite /rejection bytes2coeffs_nil.
qed.

lemma enough_blocksE m nb:
 enough_blocks m nb
 <=> (size (take 256 (rejection (expand_seed m nb))) = 256).
proof. by rewrite size_takel' /#. qed.


(** Rejection sampling as specified terminates. Keccak-f[1600] is a
 permutation, so the absorbed state of the 34-byte seed recurs once per
 period, and with it an aligned zero 3-byte group at offset 36 of the
 squeezed block, whose two candidates are accepted. *)
lemma expand_seedS seed nb:
 0 <= nb =>
 expand_seed seed (nb + 1)
 = expand_seed seed nb
   ++ squeezestate_i c256_r8 (SHAKE128_ABSORB (rejection_seed seed)) nb.
proof.
move=> ge0nb; rewrite /expand_seed /squeezeblocks iotaSr // -cats1.
by rewrite map_cat flatten_cat /= flatten_cons flatten_nil cats0.
qed.

lemma SHAKE128_expand_seed seed nb:
 0 <= nb =>
 SHAKE128 (rejection_seed seed) (168 * nb) = expand_seed seed nb.
proof.
move=> ge0nb; case: (nb = 0) => [->|ne0nb].
- by rewrite expand_seed0 // -size_eq0 size_SHAKE128.
rewrite /SHAKE128 /KECCAK1600 /SQUEEZE1600 /expand_seed /c256_r8 /=.
rewrite (_ : (168 * nb - 1) %/ 168 + 1 = nb) 1:/# take_oversize //.
by rewrite size_squeezeblocks /#.
qed.

lemma rejection_zero3:
 rejection [W8.zero; W8.zero; W8.zero] = [incoeff 0; incoeff 0].
proof.
rewrite /rejection /bytes2coeffs /bytes_to_bits /= byte_to_bits_nil /= /chunk /=.
have -> : flatten [nseq 8 false; nseq 8 false; nseq 8 false] = nseq 24 false.
- by rewrite !flatten_cons flatten_nil cats0 !cat_nseq.
rewrite size_nseq /= (mkseqS _ 1) // mkseq1 /= !drop_nseq //= !take_nseq /=.
by rewrite !bs2int_nseq_false /= (_ : 0 < q) // /q.
qed.

lemma size_rejectionS seed nb:
 0 <= nb =>
 size (rejection (expand_seed seed (nb + 1)))
 = size (rejection (expand_seed seed nb))
   + size (rejection (squeezestate_i c256_r8 (SHAKE128_ABSORB (rejection_seed seed)) nb)).
proof.
move=> ge0nb; rewrite expand_seedS // rejection_cat 2:size_cat //.
by rewrite size_expand_seed // dvdz_mulr.
qed.

lemma size_rejection_mono seed nb1 nb2:
 0 <= nb1 <= nb2 =>
 size (rejection (expand_seed seed nb1))
 <= size (rejection (expand_seed seed nb2)).
proof.
move=> [ge0nb1 le12]; have [d [ge0d ->]] : exists d, 0 <= d /\ nb2 = nb1 + d.
- by exists (nb2 - nb1); smt().
elim: d ge0d => [|d ge0d ih] //.
by rewrite addzA size_rejectionS 1:/#; smt(size_ge0).
qed.

lemma kyber_terminates (seed: W8.t Array32.t * (W8.t * W8.t)):
 exists nblocks, enough_blocks seed nblocks.
proof.
pose m := rejection_seed seed.
pose blk := squeezestate_i c256_r8 (SHAKE128_ABSORB m).
have szm : size m = 34 by rewrite /m size_cat size_to_list.
have [L [gt0L hL]] := SHAKE128_zero_run m _; 1: by rewrite szm.
pose f := fun n => size (rejection (expand_seed seed n)).
have := count_grows f L (fun N => (N + 1) * L - 1) _ _ _ _ 256 _.
- smt().
- by move=> a b rgab; apply size_rejection_mono.
- move=> N ge0N /=; pose g := (N + 1) * L - 1.
  have ge0g : 0 <= g by smt().
  do 2! (split; 1: smt()).
  rewrite (_ : (N + 1) * L = g + 1) 1:/# /f size_rejectionS // -/m -/(blk g).
  have szb : size (blk g) = 168 by rewrite size_squeezestate_i.
  (* the zero group of the recurring block *)
  have hz : forall j, 0 <= j < 3 => nth witness (blk g) (36 + j) = W8.zero.
  - move=> j rgj; have := hL (N + 1) (36 + j) (168 * (g + 1)) _ _ _; 1..3: smt().
    rewrite SHAKE128_expand_seed 1:/# expand_seedS // nth_cat size_expand_seed //.
    rewrite -/m -/(blk g) -/g ifF 1:/#.
    by rewrite (_ : g * 168 + (36 + j) - 3 * (56 * g) = 36 + j) 1:#ring.
  have /= h0 := hz 0 _; 1: done.
  have /= h1 := hz 1 _; 1: done.
  have /= h2 := hz 2 _; 1: done.
  rewrite -(cat_take_drop 36 (blk g)) rejection_cat; 1: by rewrite size_take // szb.
  rewrite (drop_nth witness 36) 1:/# (drop_nth witness 37) 1:/#.
  rewrite (drop_nth witness 38) 1:/# h0 h1 h2 /=.
  rewrite (_ : W8.zero :: W8.zero :: W8.zero :: drop 39 (blk g)
             = [W8.zero; W8.zero; W8.zero] ++ drop 39 (blk g)) //.
  by rewrite rejection_cat // rejection_zero3 !size_cat /=; smt(size_ge0).
- by rewrite /f size_ge0.
- done.
by move=> /= h; exists (L * 256); rewrite /enough_blocks; smt().
qed.



(* [needed_blocks] gives the (minimal) "sufficient" size *)
op needed_blocks m : int = 
 argmin (fun i => size (rejection (expand_seed m i)))
        (fun i=> 256 <= i).

lemma needed_blocksP m:
 enough_blocks m (needed_blocks m).
proof.
have [nb Hnb] := kyber_terminates m.
have /= := (argminP (fun i => size (rejection (expand_seed m i))) (fun i => 256 <= i) nb _).
 by apply (enough_blocks_ge0 m).
by apply; apply Hnb.
qed.

lemma needed_blocks_min m i:
 0 <= i =>
 enough_blocks m i => needed_blocks m <= i.
proof.
rewrite /enough_blocks /needed_blocks => Hi H.
rewrite -le_argmin // => [[k /= Hk]].
exists i; smt().
qed.

lemma needed_blocks_ge3 m:
 3 <= needed_blocks m.
proof.
have H:= needed_blocksP m.
have Hnb:= enough_blocks_ge0 _ _ H.
have: size (rejection (expand_seed m (needed_blocks m))) <= size (bytes2coeffs (expand_seed m (needed_blocks m))).
 rewrite /rejection size_map.
 smt(size_filter_le).
by rewrite size_bytes2coeffs size_expand_seed 1:// /#.
qed.

(** [parse] constructs a polynomial coefficients from its seed *)
op parse_coeffs seed: coeff list =
 take 256 (rejection (expand_seed seed (needed_blocks seed))).

op parse rho j i =
 Array256.of_list witness (parse_coeffs (rho, (j,i))).

lemma size_parse_coeffs m: size (parse_coeffs m) = 256.
proof.
by rewrite size_takel //=; apply needed_blocksP.
qed.

abbrev idx_from_pos pos = ((* row *) pos %/ kvec, (* column *) pos %% kvec).

op pos2ji (pos: int) (t: bool): W8.t*W8.t =
 let rc = idx_from_pos pos  in
 if t then (W8.of_int rc.`1, W8.of_int rc.`2) else (W8.of_int rc.`2, W8.of_int rc.`1).

op plist ['a] (pol: 'a Array256.t) n = mkseq ("_.[_]" pol) n.

lemma size_plist ['a] (pol : 'a Array256.t) n:
 0 <= n <= 256 =>
 size (plist pol n) = n.
proof. by move=> Hn; rewrite size_mkseq /#. qed.

lemma plist0 ['a] (p: 'a Array256.t): plist p 0 = [].
proof. by rewrite /plist mkseq0. qed.

lemma plistS ['a] (p: 'a Array256.t) k:
 0 <= k =>
 plist p (k+1) = rcons (plist p k) p.[k].
proof. by move=> Hk; rewrite /plist mkseqS. qed.

lemma take_plist ['a] (p: 'a Array256.t) (n n': int):
 0 <= n' <= n =>
 take (n') (plist p n) = plist p n'.
proof.
move=> H; rewrite /plist /=.
by rewrite take_mkseq 1:/# //.
qed.

lemma take_k3 (buf: W8.t Array168.t) k:
 0 <= k && k+3 <= 168 =>
 take (k+3) (to_list buf)
 = take k (to_list buf)
   ++ [buf.[k];buf.[k+1];buf.[k+2]].
proof.
move=> Hk.
rewrite -{1}(cat_take_drop k (to_list buf)) take_cat.
rewrite ifF size_take 1,3:/# size_to_list 1:/#.
congr; rewrite ifT 1:/# addzC addzA (addzC _ k) /=.
rewrite /to_list drop_mkseq 1:/# take_mkseq 1:/#.
by rewrite /mkseq -iotaredE /(\o) /=.
qed.

(* -------------------------------------------------------------------- *)
(* SampleNTT against the stream: a 3-byte group appends its accepted    *)
(* candidates, a block its group candidates, and the polynomial is the  *)
(* first 256 accepted coefficients.                                     *)
lemma bytes2coeffs3E (b0 b1 b2 : W8.t) :
 bytes2coeffs [b0; b1; b2]
 = [ to_uint b0 + 256 * (to_uint b1 %% 16); to_uint b1 %/ 16 + 16 * to_uint b2 ].
proof.
rewrite /bytes2coeffs /bytes_to_bits /flatten /chunk /mkseq size_bytes_to_bits -iotaredE /=.
split.
 rewrite drop0 cats0 /to_uint.
 rewrite take_cat ifF !size_w2bits //= take_cat.
 by rewrite ifT 1:size_w2bits 1:// bs2int_cat size_w2bits bs2int_take.
rewrite drop_cat ifF !size_w2bits //= cats0.
rewrite drop_cat ifT 1:size_w2bits //= /to_uint.
rewrite take_cat ifF.
 by rewrite size_drop 1:// size_w2bits.
rewrite bs2int_cat bs2int_drop 1:// size_drop -1:/max //=.
rewrite bs2int_take 1:// modz_small //.
split; first by apply bs2int_ge0.
by move=> _; move: (bs2int_le2Xs (w2bits b2)); smt().
qed.

lemma rejection3E (b0 b1 b2 : W8.t) :
 rejection [b0; b1; b2]
 = (if to_uint b0 + 256 * (to_uint b1 %% 16) < q
    then [incoeff (to_uint b0 + 256 * (to_uint b1 %% 16))] else [])
   ++ (if to_uint b1 %/ 16 + 16 * to_uint b2 < q
       then [incoeff (to_uint b1 %/ 16 + 16 * to_uint b2)] else []).
proof. by rewrite /rejection bytes2coeffs3E /=; do 2! case: (_ < q). qed.

lemma rejection_expand_prefix seed nb1 nb2:
 0 <= nb1 <= nb2 =>
 exists l, rejection (expand_seed seed nb2) = rejection (expand_seed seed nb1) ++ l.
proof.
move=> [ge0nb1 le12]; have [d [ge0d ->]] : exists d, 0 <= d /\ nb2 = nb1 + d.
- by exists (nb2 - nb1); smt().
elim: d ge0d => [|d ge0d [l ih]]; 1: by exists []; rewrite cats0.
exists (l ++ rejection (squeezestate_i c256_r8 (SHAKE128_ABSORB (rejection_seed seed)) (nb1 + d))).
rewrite addzA expand_seedS 1:/# rejection_cat 2:ih 2:catA //.
by rewrite size_expand_seed 1:/# dvdz_mulr.
qed.

lemma lt_needed_blocks seed nb:
 0 <= nb =>
 size (rejection (expand_seed seed nb)) < 256 => nb < needed_blocks seed.
proof.
move=> ge0nb hlt; rewrite ltzNge; apply/negP => hle.
have := size_rejection_mono seed (needed_blocks seed) nb _; 1: smt(needed_blocks_ge3).
by have := needed_blocksP seed; rewrite /enough_blocks /#.
qed.

lemma parseE rho j i nb idx:
 0 <= nb => 256 <= size (rejection (expand_seed (rho, (j, i)) nb)) =>
 0 <= idx < 256 =>
 (parse rho j i).[idx] = nth witness (rejection (expand_seed (rho, (j, i)) nb)) idx.
proof.
move=> ge0nb hsz rgi; have hle := needed_blocks_min (rho, (j, i)) nb ge0nb hsz.
have [l ->] := rejection_expand_prefix (rho, (j, i)) (needed_blocks (rho, (j, i))) nb _.
- smt(needed_blocks_ge3).
have := needed_blocksP (rho, (j, i)); rewrite /enough_blocks => hn.
rewrite /parse /parse_coeffs Array256.get_of_list 1://.
by rewrite nth_cat ifT 1:/# nth_take /#.
qed.

lemma SHAKE128_SQUEEZE_168_st_i st n:
 0 <= n =>
 SHAKE128_SQUEEZE_168 (FIPS202_SHA3_Spec.st_i st n)
 = (FIPS202_SHA3_Spec.st_i st (n + 1),
    Array168.of_list W8.zero (squeezestate_i c256_r8 st n)).
proof.
move=> ge0n; have e : FIPS202_SHA3_Spec.st_i (FIPS202_SHA3_Spec.st_i st n) 1
                      = FIPS202_SHA3_Spec.st_i st (n + 1).
- by rewrite /FIPS202_SHA3_Spec.st_i iter1 iterS.
by rewrite /SHAKE128_SQUEEZE_168 /= /squeezestate_i /= e.
qed.

op parse_inv seed (k : int) (st : state) (aa : poly) (j : int) =
  0 <= k /\ st = FIPS202_SHA3_Spec.st_i (SHAKE128_ABSORB (rejection_seed seed)) k
  /\ filled_ok aa (rejection (expand_seed seed k)) j.

(* SampleNTT computes parse. The Keccak state does not determine the    *)
(* block count, so the loop variant is the largest count up to          *)
(* needed_blocks that the current state is consistent with.            *)
lemma parse_sem _st _rho _j _i:
 _st = SHAKE128_ABSORB_34 _rho _j _i =>
 phoare [ SampleNTT(XOF).sample
        : XOF.state = _st ==> res = parse _rho _j _i ] = 1%r.
proof.
move=> ->; pose seed := (_rho, (_j, _i)).
pose K := needed_blocks seed.
pose st0 := SHAKE128_ABSORB (rejection_seed seed).
pose R := fun n => rejection (expand_seed seed n).
pose blk := squeezestate_i c256_r8 st0.
have ge0K : 0 <= K by smt(needed_blocks_ge3).
proc; sp.
while (exists nb, nb <= K /\ parse_inv seed nb XOF.state aa j)
      (K - argmax idfun (fun nb => nb <= K /\ parse_inv seed nb XOF.state aa j)).
- move=> z.
  exlim (argmax idfun (fun nb => nb <= K /\ parse_inv seed nb XOF.state aa j)) => m.
  conseq (_ : parse_inv seed m XOF.state aa j /\ m < K /\ K - m = z ==> _).
  + move=> &hr [-> [[[nb [hnb hinv]] hj] hz]].
    have := argmax_bounded (fun nb => parse_inv seed nb XOF.state{hr} aa{hr} j{hr}) K nb _ hinv.
    - by case: hinv => /#.
    move=> /= [rgm [hm _]]; split; 1: exact hm.
    split; 2: smt().
    case: hm => [ge0m [_ [_ hjm]]].
    by have := lt_needed_blocks seed _ ge0m _; smt().
  (* one 3-byte group *)
  wp; while (XOF.state = FIPS202_SHA3_Spec.st_i st0 (m + 1) /\ to_list b168 = blk m
             /\ 0 <= k <= 168 /\ 3 %| k /\ 0 <= m < K /\ K - m = z
             /\ filled_ok aa (R m ++ rejection (take k (to_list b168))) j)
            (168 - k).
  - move=> z0; auto => &hr |> hb ge0k lek dvdk ge0m ltmK hok hj hk.
    rewrite take_k3 1:/# rejection_cat; 1: by rewrite size_take 1:/# size_to_list /#.
    rewrite rejection3E catA.
    pose c1 := to_uint b168{hr}.[k{hr}] + 256 * (to_uint b168{hr}.[k{hr} + 1] %% 16).
    pose c2 := to_uint b168{hr}.[k{hr} + 1] %/ 16 + 16 * to_uint b168{hr}.[k{hr} + 2].
    pose cs := R m ++ rejection (take k{hr} (to_list b168{hr})).
    have h3 : 3 %| (k{hr} + 3) by rewrite dvdzD.
    have hk3 : k{hr} + 3 <= 168 by move: dvdk => /dvdzP [n hn]; smt().
    have hok1 : c1 < q =>
      filled_ok aa{hr}.[j{hr} <- incoeff c1] (cs ++ [incoeff c1]) (j{hr} + 1).
    - by move=> _; apply filled_ok_snoc.
    have hok2 : c2 < q =>
      filled_ok aa{hr}.[j{hr} <- incoeff c2] (cs ++ [incoeff c2]) (j{hr} + 1).
    - by move=> _; apply filled_ok_snoc.
    split=> h1; split=> h2 /=; rewrite ?h1 ?h2 /=.
    - move=> hj1; split; 2: smt(); split; 1: smt(); split; 1: done.
      have -> : cs ++ [incoeff c1; incoeff c2] = (cs ++ [incoeff c1]) ++ [incoeff c2].
      - by rewrite /cs -!catA.
      rewrite (_ : j{hr} + 2 = j{hr} + 1 + 1) 1:/#.
      by apply filled_ok_snoc => //; apply hok1.
    - split; 2: smt(); split; 1: smt(); split; 1: done.
      case: (c2 < q) => h2' /=; last by apply hok1.
      have -> : cs ++ [incoeff c1; incoeff c2] = (cs ++ [incoeff c1]) ++ [incoeff c2].
      - by rewrite /cs -!catA.
      by apply filled_ok_full; [apply hok1 | smt()].
    - by split; 2: smt(); split; 1: smt(); split; [done | apply hok2].
    by split; 2: smt(); split; 1: smt(); split; [done | rewrite cats0].
  (* one block *)
  inline XOF.next_bytes; auto => &hr |> [ge0m [hst hok]] ltmK.
  rewrite hst SHAKE128_SQUEEZE_168_st_i //= of_listK; 1: by rewrite size_squeezestate_i.
  rewrite take0 rejection0 cats0 hok /=; split; 1: smt().
  move=> aa0 j0 k0; split; 1: smt().
  move=> hexit _ _ ge0k0 lek0 dvdk0 hok0.
  move=> hokk.
  have hR : filled_ok aa0 (R (m + 1)) j0.
  - rewrite /R expand_seedS // rejection_cat; 1: by rewrite size_expand_seed // dvdz_mulr.
    case: (k0 = 168) => [->> | ne168].
    - have e : take 168 (blk m) = blk m by rewrite take_oversize // size_squeezestate_i.
      by move: hokk; rewrite e => h; exact h.
    have hj0 : 256 <= j0 by smt().
    rewrite -(cat_take_drop k0 (squeezestate_i c256_r8 (SHAKE128_ABSORB (rejection_seed seed)) m)).
    rewrite rejection_cat; 1: by rewrite size_take // size_squeezestate_i /#.
    by rewrite catA; apply filled_ok_full; [exact hokk | smt()].
  have hinv : parse_inv seed (m + 1) (FIPS202_SHA3_Spec.st_i st0 (m + 1)) aa0 j0.
  - by do 2! (split; 1: smt()); exact hR.
  split; 1: by exists (m + 1); split; [smt() | exact hinv].
  have := argmax_bounded (fun nb => parse_inv seed nb (FIPS202_SHA3_Spec.st_i st0 (m + 1)) aa0 j0)
            K (m + 1) _ hinv; 1: smt().
  by move=> /= /#.
skip => &hr |> /=; split.
- exists 0; split; 1: smt().
  rewrite /parse_inv /FIPS202_SHA3_Spec.st_i iter0 //= expand_seed0 // rejection0.
  by rewrite /filled_ok.
move=> st aa0 j0; split.
- move=> nb hnb hinv hv.
  have := argmax_bounded (fun nb => parse_inv seed nb st aa0 j0) K nb _ hinv.
  - by case: hinv => /#.
  move=> /= [rgm [hm _]].
  have hK : argmax idfun (fun nb => nb <= K /\ parse_inv seed nb st aa0 j0) = K by smt().
  move: hm; rewrite hK => -[_ [_ [_ ->]]].
  by have := needed_blocksP seed; rewrite /enough_blocks /#.
move=> hj nb hnb [ge0nb [_ [hag hj0]]]; apply Array256.ext_eq => idx rgidx.
have hsz : 256 <= size (R nb) by smt().
by rewrite (agree_nth witness _ _ _ hsz hag rgidx) (parseE _ _ _ nb).
qed.


module Hmodule = {
    proc sampleA(sd : W8.t Array32.t) : polymat = {
     var i,j,c;
     var a : polymat;
     a <- witness;
     i <- 0;
     while (i < kvec) {
        j <- 0;
        while (j < kvec) {
           c <- parse sd (W8.of_int j) (W8.of_int i);
           a.[(i,j)] <- c;
           j <- j + 1;
        }
        i <- i + 1;
     }
     return a;
    }

    proc sampleAT(sd : W8.t Array32.t) : polymat = {
     var i,j,c;
     var a : polymat;
     a <- witness;
     i <- 0;
     while (i < kvec) {
        j <- 0;
        while (j < kvec) {
           c <- parse sd (W8.of_int i) (W8.of_int j);
           a.[(i,j)] <- c;
           j <- j + 1;
        }
        i <- i + 1;
     }
     return a;
    }

}.

lemma KSamplerA_ll  : islossless Hmodule.sampleA.
proc;while(0<=i<=kvec) (kvec - i) => *; last by auto => *; smt(gt0_k).
move => *;wp;while(0<=i<kvec && 0<=j<=kvec) (kvec - j) => *; last by auto => *; smt(gt0_k).
by move => *;inline *;auto => /> /#.
qed.

lemma KSamplerAT_ll : islossless Hmodule.sampleAT.
proc;while(0<=i<=kvec) (kvec - i) => *; last by auto => *; smt(gt0_k).
move => *;wp;while(0<=i<kvec && 0<=j<=kvec) (kvec - j) => *; last by auto => *; smt(gt0_k).
by move => *;inline *;auto => /> /#.
qed.

import KMatrix.Vector.

(* spec-level matrix sampling: concrete and parametric over kvec.
   sampleA.[(i,j)] = parse sd j i  (matches the Hmodule.sampleA proc). *)
op sampleA(sd : W8.t Array32.t) : polymat =
  KMat.init (fun f => parse sd (W8.of_int (f %% kvec)) (W8.of_int (f %/ kvec))).

lemma sampleAE sd i j : 0 <= i < kvec => 0 <= j < kvec =>
  (sampleA sd).[(i,j)] = parse sd (W8.of_int j) (W8.of_int i).
proof.
move=> hi hj; rewrite /sampleA {1}/PolyMat."_.[_]" KMat.initiE 1:/# /=.
by rewrite modzMDl modz_small 1:/# divzMDl 1:/# divz_small 1:/#.
qed.

lemma sampleA_sem _sd :
  phoare [ Hmodule.sampleA : arg = _sd ==> res = sampleA _sd ] = 1%r.
proof.
proc; sp.
while (sd = _sd /\ 0 <= i <= kvec /\
       forall i0 j0, 0 <= i0 < i => 0 <= j0 < kvec =>
         a.[(i0,j0)] = parse _sd (W8.of_int j0) (W8.of_int i0)) (kvec - i).
+ move=> z; wp; sp.
  while (sd = _sd /\ 0 <= i < kvec /\ 0 <= j <= kvec /\
         (forall i0 j0, 0 <= i0 < i => 0 <= j0 < kvec =>
            a.[(i0,j0)] = parse _sd (W8.of_int j0) (W8.of_int i0)) /\
         (forall j0, 0 <= j0 < j =>
            a.[(i,j0)] = parse _sd (W8.of_int j0) (W8.of_int i))) (kvec - j).
  - move=> z'; auto => /> &hr hi1 hi2 hj0 hjle Hprev Hrow hjlt; split; last by smt().
    split; first by smt().
    split.
    + move=> i0 j0 ????; case (i0 = i{hr} /\ j0 = j{hr}) => h; smt(get_setmE).
    move=> j0 ??; case (j0 = j{hr}) => h; smt(get_setmE).
  auto => /> /#.
auto => />; split; 1: smt(gt0_k).
move=> a0 i0; split; 1: smt().
move=> hexit hi0 hi0le Hinv; apply eq_polymatP => i0' j0' ??.
rewrite sampleAE 1,2:/#; smt().
qed.

lemma sampleAT_sem _sd :
  phoare [ Hmodule.sampleAT : arg = _sd ==> res = trmx (sampleA _sd) ] = 1%r.
proof.
proc; sp.
while (sd = _sd /\ 0 <= i <= kvec /\
       forall i0 j0, 0 <= i0 < i => 0 <= j0 < kvec =>
         a.[(i0,j0)] = parse _sd (W8.of_int i0) (W8.of_int j0)) (kvec - i).
+ move=> z; wp; sp.
  while (sd = _sd /\ 0 <= i < kvec /\ 0 <= j <= kvec /\
         (forall i0 j0, 0 <= i0 < i => 0 <= j0 < kvec =>
            a.[(i0,j0)] = parse _sd (W8.of_int i0) (W8.of_int j0)) /\
         (forall j0, 0 <= j0 < j =>
            a.[(i,j0)] = parse _sd (W8.of_int i) (W8.of_int j0))) (kvec - j).
  - move=> z'; auto => /> &hr hi1 hi2 hj0 hjle Hprev Hrow hjlt; split; last by smt().
    split; first by smt().
    split.
    + move=> i0 j0 ????; case (i0 = i{hr} /\ j0 = j{hr}) => h; smt(get_setmE).
    move=> j0 ??; case (j0 = j{hr}) => h; smt(get_setmE).
  auto => /> /#.
auto => />; split; 1: smt(gt0_k).
move=> a0 i0; split; 1: smt().
move=> hexit hi0 hi0le Hinv; apply eq_polymatP => i0' j0' ??.
rewrite trmxE 1,2:/# sampleAE 1,2:/#; smt().
qed.

equiv H_sem_equiv :
 Hmodule.sampleAT  ~ Hmodule.sampleA : ={arg} ==> res{1} = trmx res{2}.
proof.
proc*; ecall {2} (sampleA_sem sd{2}); ecall {1} (sampleAT_sem sd{1}); auto => /#.
qed.


from JazzEC require import Array168.
require import DMap DList.
clone DMapSampling as MSlw168 with
 type t1 <- int list,
 type t2 <- W8.t Array168.t.

clone DMapSampling as MSlpoly with
 type t1 <- int list,
 type t2 <- poly.

clone DMapSampling as MSll with
 type t1 <- int list,
 type t2 <- int list.


module ParseRnd = {
   proc sample_real() : poly = {
      var a, j, bi, bi1, bi2, d1, d2,k;
      var aa : poly;
      aa <- witness;
      j <- 0;
      while (j < 256) {
         a <@ MSlw168.S.sample(dlist (dbits 8) 168, Array168.of_list witness \o List.map W8.of_int);
         k <- 0;
         while ((j < 256) && (k < 168)) {
            bi  <- a.[k];
            bi1 <- a.[k+1];
            bi2 <- a.[k+2];
            k <- k + 3;
            d1 <- to_uint bi        + 256 * (to_uint bi1 %% 16);
            d2 <- to_uint bi1 %/ 16 + 16  * to_uint bi2;
            if (d1 < q)                { aa.[j] <- incoeff d1; j <- j + 1; }
            if ((d2 < q) && (j < 256)) { aa.[j] <- incoeff d2; j <- j + 1; }
         }
      }
      return aa;
   }
   proc sampleL_real() : poly = {
      var l, a, j, bi, bi1, bi2, d1, d2,k;
      var aa : poly;
      aa <- witness;
      l <- [];
      j <- 0;
      while (j < 256) {
         a <@ MSlw168.S.sample(dlist (dbits 8) 168, Array168.of_list witness \o List.map W8.of_int);
         k <- 0;
         while ((j < 256) && (k < 168)) {
            bi  <- a.[k];
            bi1 <- a.[k+1];
            bi2 <- a.[k+2];
            k <- k + 3;
            d1 <- to_uint bi        + 256 * (to_uint bi1 %% 16);
            d2 <- to_uint bi1 %/ 16 + 16  * to_uint bi2;
            if (d1 < q)                { l <- rcons l (incoeff d1); j <- j + 1; }
            if ((d2 < q) && (j < 256)) { l <- rcons l (incoeff d2); j <- j + 1; }
         }
      }
      aa <- Array256.of_list witness l;
      return aa;
   }
   proc sample_ideal() : poly = {
     var p;
     p <$ duni_R;
     return p;
   }
}.

lemma duni_R_sample:
 duni_R
 = dmap (dlist [0..q-1] 256) (Array256.of_list witness \o List.map incoeff).
proof. by rewrite /duni_R /darray256 duni_elemE dlist_dmap dmap_comp. qed.

equiv ParseRnd_sampleL_eq:
 ParseRnd.sample_real ~ ParseRnd.sampleL_real:
 true ==> ={res}.
proof.
proc.
wp; while (={j} /\ 0 <= j{1} <= 256 /\ a256l aa{1} l{2} j{1}).
 conseq (_:_ ==> ={j} /\ (0 <= j{1} && j{1} <= 256) /\ a256l aa{1} l{2} j{1}) => //.
 while (#[/:-3]pre /\ ={k,a}).
  conseq (_:_==> ={j,k,a} /\ (0 <= j{1} && j{1} <= 256) /\ a256l aa{1} l{2} j{1}) => //.
  auto => |> &1 &2 ?? Ha ??.
  split => C1.
   split => C2 *.
    split; first smt().
    apply a256l_rcons; first smt().
    apply a256l_rcons; first smt().
    done.
   split; first smt().
   apply a256l_rcons; first smt().
   done.
  move => C2.
  split; first smt().
  apply a256l_rcons; first smt().
  done.
 by inline*; auto. 
auto => |> *.
split; first smt().
move => |> p i l ???.
have ->: i=256 by smt().
by apply a256l_of_list. 
qed.

lemma dchunk_12_2_56:
 dlist (dbits 12) 112
 = dmap (dlist (dbits 24) 56) (flatten \o List.map (spreadbits 12 2)).
proof.
rewrite (_:112=2*56) 1:// dlist_mul 1..2:// -dbits_spreadbits 1..2://.
by rewrite dlist_dmap dmap_comp.
qed.

lemma dchunk_8_3_56:
 dlist (dbits 8) 168
 = dmap (dlist (dbits 24) 56) (flatten \o List.map (spreadbits 8 3)).
proof.
rewrite (_:168=3*56) 1:// dlist_mul 1..2:// -dbits_spreadbits 1..2://.
by rewrite dlist_dmap dmap_comp.
qed.

(** Parse proc. (over a random oracle) samples acording
    to the uniform distr. *)
equiv ParseRnd_equiv:
 ParseRnd.sample_real ~ ParseRnd.sample_ideal:
 true ==> ={res}.
proof.
transitivity ParseRnd.sampleL_real
 (true ==> ={res}) (true ==> ={res}) => //.
 by apply ParseRnd_sampleL_eq.
proc.
transitivity {2}
 { p <@ MSlpoly.S.sample(dlist [0..q-1] 256,
                         Array256.of_list witness \o List.map incoeff); }
 ( true ==> aa{1}=p{2} ) ( true ==> ={p} ) => //; last first.
 inline*; wp; rnd; wp; auto => /> *; smt(duni_R_sample).
transitivity {2}
 { p <@ MSlpoly.S.map(dlist [0..q-1] 256,
                      Array256.of_list witness \o List.map incoeff); }
 ( true ==> aa{1}=p{2} ) ( true ==> ={p} ) => //; last first.
 by symmetry; call MSlpoly.sample.
inline MSlpoly.S.map; swap{2} 2 1.
transitivity {2}
 { r1 <@ RejSampling.samplelist_upto(q-1,256); 
   p <- Array256.of_list witness (List.map incoeff r1); }
 ( true ==> aa{1}=p{2} ) ( true ==> ={p} ) => //; last first.
 by inline*; auto.
transitivity {2}
 { r1 <@ RejSampling.rsamplelist_chunked(12, q-1, 256, 112); 
   p <- Array256.of_list witness (List.map incoeff r1); }
 ( true ==> aa{1}=p{2} ) ( true ==> ={p} ) => //; last first.
 by wp; symmetry; call rsamplelist_chunked_upto; auto => |> * /#.
inline RejSampling.rsamplelist_chunked.
wp; while (={j} /\ 0 <= j{1} <= 256 /\ k{2}=12 /\ max{2}=q-1 /\ n{2}=256
           /\ nchunk{2}=112 /\ l{1} = List.map incoeff l{2}).
 wp.
 transitivity {2}
  { xl <@ MSll.S.map(dlist (dbits 24) 56, flatten \o List.map (spreadbits 12 2));
    xn <- 0;
    while (j < 256 && xn < 56) {
      if (nth 0 xl (2*xn) <= q-1 && j < 256) {
        l <- rcons l (nth 0 xl (2*xn));
        j <- j+1;
      }
      if (nth 0 xl (2*xn+1) <= q-1 && j < 256) {
        l <- rcons l (nth 0 xl (2*xn+1));
        j <- j+1;
      }
      xn <- xn + 1;
    }
  }
  ( ={j} /\ 0 <= j{1} < 256 /\ l{1} = map incoeff l{2}
    ==> ={j} /\ 0 <= j{1} <= 256 /\ l{1} = map incoeff l{2} )
  ( ={j,l} /\ 0 <= j{1} < 256 /\ k{2}=12 /\ max{2}=q-1 /\ n{2}=256 /\ nchunk{2}=112
    ==> ={j,l} /\ 0 <= j{1} <= 256 /\ k{2}=12 /\ max{2}=q-1 /\ n{2}=256 /\ nchunk{2}=112 ); 1..2: smt(); first last.
  seq 1 1: (={xl} /\ #pre).
   conseq |>.
   transitivity {1} { xl <@ MSll.S.sample(dlist (dbits 24) 56, flatten \o List.map (spreadbits 12 2)); }
    ( ={j,l} ==> ={xl,j,l} )
    ( ={j, l} /\ (0 <= j{1} && j{1} < 256) /\ k{2} = 12 /\ max{2} = q - 1 /\ n{2} = 256 /\ nchunk{2} = 112
      ==> ={xl} ); first 2 smt().
    by symmetry; call MSll.sample; auto.
   inline*; auto => |> &1 &2 *.
   by split => *; rewrite dchunk_12_2_56.

async while
 [ (fun x => xn < x), xn{1} + 1 ]
 [ (fun x => 256 <= j \/ xn < 2*x), xn{1} + 1 ]
   (false) (false)
 : (={j,l,xl} /\ 0 <= j{1} <= 256 /\ k{2}=12 /\ max{2}=q-1 /\ n{2}=256 /\ nchunk{2}=112
    /\ (256 <= j{1} \/ 2*xn{1} = xn{2}) /\ 0 <= xn{1}) => //=.
(* (1) cond:  inv ⇒ flock ∨ false ∨ false  — under inv, flock holds *)
+ move=> &1 &2 /> /#.
(* (2) xwh: lockstep equiv — left does 1 iter, right does 2 iters *)
  move => v1 v2.
  rcondt{1} 1; first by auto => /> /#.
  rcondf{1} 4; first by auto.
  rcondt{2} 1; first by auto => /> /#.
  if => //; 1: by auto => />; smt().

  + case: (j{1}=255).
    + rcondf{1} 3; first by auto.
      rcondf{2} 4; first by auto => /> &1 &2 * /#.   (* right while exits: j=256 *)
      by auto => /> &1 &2 * /#.
    unroll {2} 4.
    rcondt {2} 4; first by auto => /> /#.
    sp 2 0; if{1} => //; sp 0 3; if{2} => //.
    + rcondf {2} 4; first by auto => /> /#.
      by auto => /> &1 &2 * /#.
    + unroll {2} 2. 
      rcondf {2} 2; first by auto => /> &1 * /#.
      rcondf {2} 2; first by auto => /> &1 * /#.
      by auto => /> &1 &2 * /#.
    + by exfalso;smt().

  + rcondf {2} 2; first by auto => /> &1  * /#.
    by auto => /> &1 &2 * /#.

unroll {2} 2. 
rcondt {2} 2; first by auto => /> &1 &2 * /#.  
if{1} => //; sp 0 1; if{2} => //.   
+ rcondf {2} 4; first by auto => /> &1 * /#.
  by auto => /> &1 &2 * /#.
+ by exfalso; smt().
+ by exfalso; smt().
+ rcondf {2} 2; first by auto => /> &1 * /#.
  by auto => /> &1 &2 * /#.
by auto => /> /#.


 alias {1} 1 xl = [0].
 transitivity {1}
  { xl <@ MSll.S.map(dlist (dbits 24) 56, flatten \o List.map (spreadbits 8 3));
    k <- 0;
    while (j < 256 && k < 56) {
     d1 <- (nth 0 xl (3*k)) %% W8.modulus + 256 * ((nth 0 xl (3*k+1)) %% W8.modulus %% 16);
     d2 <- (nth 0 xl (3*k+1)) %% W8.modulus %/ 16 + 16 * ((nth 0 xl (3*k+2)) %% W8.modulus);
     if (d1 < q) {
      l <- rcons l (incoeff d1);
      j <- j+1;
     }
     if (d2 < q && j < 256) {
      l <- rcons l (incoeff d2);
      j <- j+1;
     }
     k <- k+1;
    }
  }
  ( ={j,l} /\ 0 <= j{1} < 256 ==> ={j,l} /\ 0 <= j{1} <= 256 )
  ( ={j} /\ 0 <= j{1} < 256 /\ l{1} = map incoeff l{2}
    ==> ={j} /\ 0 <= j{1} <= 256 /\ l{1} = map incoeff l{2} ); 1..2:smt().
  seq 2 1: (#pre /\ a{1}=Array168.of_list witness (List.map W8.of_int xl{2}) /\ size xl{2}=168).
   sp; conseq |>.
   transitivity {2} { xl <@ MSll.S.sample(dlist (dbits 24) 56, flatten \o List.map (spreadbits 8 3)); }
    ( ={j, l} /\ (0 <= j{1} && j{1} < 256) 
      ==> a{1} = (of_list witness (map W8.of_int xl{2}))%Array168 /\ size xl{2}=168 )
    ( ={j, l} ==> ={xl} ) ; first 2 smt().
    transitivity {1} { a <@ MSlw168.S.map(dlist (dbits 8) 168, Array168.of_list witness \o List.map W8.of_int); }
     ( ={j, l} /\ (0 <= j{1} && j{1} < 256) 
       ==> ={a} )
     ( ={j, l} ==> a{1} = (of_list witness (map W8.of_int xl{2}))%Array168 /\ size xl{2}=168); first 2 smt().
     by call MSlw168.sample; auto.
    inline*; auto => />; rewrite -dchunk_8_3_56 // => />.
    smt(supp_dlist).
   by call MSll.sample; auto.
  while (k{1}=3*k{2} /\ 0 <= k{1} /\ #post /\ #[/-2:]pre).
   swap {1} 4 4.
   seq 5 2: (#pre /\ ={d1,d2}).
    auto => /> &1 *.
    by rewrite !get_of_list 1..3:/# !(nth_map 0) 1..3:/# !of_uintK.
   by auto => /> &1 * /#.
  by auto => /#.
 inline*; swap 2 1; cfold {1} 1; cfold {1} 2; cfold {2} 1; cfold {2} 2.
 seq 2 2: (#pre /\ r10{2}=r1{1} /\ r1{1} \in dlist (dbits 24) 56
           /\ xl{1} = flatten (List.map (spreadbits 8 3) r1{1})
           /\ xl{2} = flatten (List.map (spreadbits 12 2) r1{1}) ).
  by auto.
 wp; conseq |>.
 while (#post /\ #[/5:]pre /\ k{1}=xn{2} /\ 0 <= k{1} <= 56).
  auto => /> &1 &2 ??.
  rewrite supp_dlist 1://; move => [r1_size /List.allP Hr1] *.
  pose x:= nth 0 r1{1} xn{2}.
  have Ex: x %% 2^24 = x.
   move: (Hr1 x _).
    by rewrite mem_nth /#.
   by rewrite supp_dinter => *; rewrite modz_small /#.
  pose d1:= nth 0 (flatten (map (spreadbits 12 2) r1{1})) (2*xn{2}).
  have Ed1: d1 = x %% 2^12.
   rewrite /d1 (nth_flatten 0 2).
    apply/List.allP => l /=.
    move=> /mapP [ll [_ ->]].
    by rewrite /spreadbits size_mkseq /#.
   by rewrite (nth_map 0) 1:/# mulzC mulzK 1:// modzMl nth_mkseq 1:// /x /=.
  pose d2:= nth 0 (flatten (map (spreadbits 12 2) r1{1})) (2*xn{2}+1).
  have Ed2: d2 = x %/ 2^12.
   rewrite /d2 (nth_flatten 0 2).
    apply/List.allP => l /=.
    move=> /mapP [ll [_ ->]].
    by rewrite /spreadbits size_mkseq /#.
   rewrite (nth_map 0) 1:/# mulzC divzMDl 1:// divz_small 1:// modzMDl nth_mkseq 1:// /= -divz_mod_mul 1..2:// /=.
   by move: Ex => /= ->.
  pose b1:= nth 0 (flatten (map (spreadbits 8 3) r1{1})) (3*xn{2}).
  have -> {b1}: b1 %% 256 = d1 %% 2^8.
   rewrite Ed1 modz_dvd_pow 1:// /b1 (nth_flatten 0 3).
    apply/List.allP => l /=.
    move=> /mapP [ll [_ ->]].
    by rewrite /spreadbits size_mkseq /#.
   by rewrite (nth_map 0) 1:/# mulzC mulzK 1:// modzMl nth_mkseq 1:// /= modz_mod /x /=.
  pose b2:= nth 0 (flatten (map (spreadbits 8 3) r1{1})) (3*xn{2}+1).
  have Eb2': b2 %% 2^8 = b2.
   rewrite /b2 (nth_flatten 0 3).
    apply/List.allP => l /=.
    move=> /mapP [ll [_ ->]].
    by rewrite /spreadbits size_mkseq /#.
   by rewrite (nth_map 0) 1:/# mulzC divzMDl 1:// divz_small 1:// modzMDl nth_mkseq 1:// /= modz_mod /=.
  have Eb2: b2 = x %% 2^16 %/ 2^8.
   rewrite /b2 (nth_flatten 0 3).
    apply/List.allP => l /=.
    move=> /mapP [ll [_ ->]].
    by rewrite /spreadbits size_mkseq /#.
   rewrite (nth_map 0) 1:/# mulzC divzMDl 1:// divz_small 1:// modzMDl nth_mkseq 1://; beta.
   by rewrite (_:2^16=2^8*2^8) 1:// divz_mod_mul 1..2://; congr; congr.
  pose b3:= nth 0 (flatten (map (spreadbits 8 3) r1{1})) (3*xn{2}+2).
  have Eb3: b3 %% 256 = x %% 2^24 %/ 2^16.
   rewrite /b3 (nth_flatten 0 3).
    apply/List.allP => l /=.
    move=> /mapP [ll [_ ->]].
    by rewrite /spreadbits size_mkseq /#.
   rewrite (nth_map 0) 1:/# mulzC divzMDl 1:// divz_small 1:// modzMDl nth_mkseq 1://; beta.
   by rewrite modz_mod (_:2^24=2^8*2^16) 1:// divz_mod_mul 1..2://; congr; congr.
  have <-: d1 = d1 %% 2^8 + 2^8 * (b2 %% 2^8 %% 2^4).
   rewrite modz_dvd_pow 1:// Eb2.
   rewrite -divz_mod_mul 1..2://.
   rewrite -exprD_nneg 1..2:// modz_dvd_pow 1:// Ed1 /=.
   by move: (divz_eq (x%%4096) 256) => {1}->; ring.
  have <-: d2 = b2 %% 256 %/ 16 + 16 * (b3 %% 256).
   rewrite Eb2' Eb3 Ex Eb2 (_:2^16=2^12*2^4) 1://= divz_mul 1:// -Ed2.
   rewrite -divz_mul 1:// (_:2^8*16=2^12) 1:// mulzC.
   rewrite divz_mod_mul 1..2:// -Ed2 /=.
   by move: (divz_eq d2 16) => {1}->; ring.
  by rewrite !map_rcons /#.
 by auto => /> * /#.
by auto.
qed.

clone DMapSampling as MSwlw128 with
 type t1 <- W8.t list,
 type t2 <- W8.t Array128.t.

import PolyVec PolyMat.
module CBD2rnd = {
   proc sampleL_real() : poly = {
      var i,a,b,bytes;
      var p : poly;
      var l: coeff list;
      bytes <@ MSwlw128.S.sample(dlist W8.dword 128, Array128.of_list witness);
      l <- [];
      i <- 0;
      while (i < 128) {
        a <- b2i bytes.[i].[0] + b2i bytes.[i].[1];
        b <- b2i bytes.[i].[2] + b2i bytes.[i].[3];
        l <- rcons l (incoeff  (a - b));
        a <- b2i bytes.[i].[4] + b2i bytes.[i].[5];
        b <- b2i bytes.[i].[6] + b2i bytes.[i].[7];
        l <- rcons l (incoeff  (a - b));
        i <- i + 1;
      }
      p <- Array256.of_list witness l;
      return p;
   }
   proc sample_real() : poly = {
      var i,a,b,bytes;
      var p : poly;
      p <- witness;
      bytes <@ MSwlw128.S.sample(dlist W8.dword 128, Array128.of_list witness);
      i <- 0;
      while (i < 128) {
        a <- b2i bytes.[i].[0] + b2i bytes.[i].[1];
        b <- b2i bytes.[i].[2] + b2i bytes.[i].[3];
        p.[2*i] <- incoeff  (a - b);
        a <- b2i bytes.[i].[4] + b2i bytes.[i].[5];
        b <- b2i bytes.[i].[6] + b2i bytes.[i].[7];
        p.[2*i+1] <- incoeff  (a - b);
        i <- i + 1;
      }
      return p;
   }
   proc sample_ideal() : poly = {
     var p;
     p <$ dshort_R;
     return p;
   }
   proc sampleL_vec_real() : polyvec = {
     var i, l, p, v;
     l <- [];
     i <- 0;
     while (i < kvec) {
       p <@ sample_real();
       l <- rcons l p;
       i <- i + 1;
     }
     v <- KVec.init (nth witness l);
     return v;
   }
   proc sample_vec_real() : polyvec = {
     var i, p;
     var v : polyvec;
     v <- witness;
     i <- 0;
     while (i < kvec) {
       p <@ sample_real();
       v <- v.[i<-p];
       i <- i + 1;
     }
     return v;
   }
   proc sample_vec_ideal() : polyvec = {
     var v;
     v <$ dmap (dlist dshort_R kvec) (fun l => KVec.init (nth witness l));
     return v;
   }
}.

op fcbd2 (w: W8.t) : coeff list =
 [ incoeff (b2i w.[0] + b2i w.[1] - b2i w.[2] - b2i w.[3])
 ; incoeff (b2i w.[4] + b2i w.[5] - b2i w.[6] - b2i w.[7]) ].

lemma dshort_R_sample:
 dshort_R 
 = dmap (dlist W8.dword 128) (Array256.of_list witness \o flatten \o List.map fcbd2).
proof.
rewrite /dshort_R /darray256 /dshort_elem dcbd_eq_sample // (_:256=2*128) 1:/#.
rewrite eq_sym -dmap_comp -dmap_comp dlist_mul //; congr; congr.
rewrite -dlist_dmap; congr. 
rewrite dlist_dmap /dcbd_sample.
rewrite (_:2=1+1) 1:// dlistS // dlist1 /= dmap_dprodR dmap_dprod !dmap_comp .
rewrite dword_bits (_:8=(2+2)+(2+2)) 1:/# !dlist_add // dmap_dprod !dmap_comp /(\o) /=.
apply eq_dmap_in; move => [ [l1 l2] [l3 l4]] /=.
rewrite !supp_dprod /= !supp_dlist // => /> Hl1 _ Hl2 _ Hl3 _ Hl4 _.
move: l1 Hl1 => [|x11 [|x12 [|x xs]]] //=; last smt(size_ge0).
move: l2 Hl2 => [|x21 [|x22 [|x xs]]] //=; last smt(size_ge0).
move: l3 Hl3 => [|x31 [|x32 [|x xs]]] //=; last smt(size_ge0).
move: l4 Hl4 => [|x41 [|x42 [|x xs]]] //=; last smt(size_ge0).
rewrite /fcbd2 /= /#.
qed.

clone DMapSampling as MSwlpoly with
 type t1 <- W8.t list,
 type t2 <- poly.

equiv CBD2rnd_sampleL_eq:
 CBD2rnd.sample_real ~ CBD2rnd.sampleL_real:
 true ==> ={res}.
proof.
proc.
wp; while (={i,bytes} /\ (0 <= i{1} <= 128) /\ a256l p{1} l{2} (2*i{1})).
 wp; skip => |> &1 &2 *.
 split; first smt().
 rewrite (_:2 * (i{2} + 1) = 2*i{2} + 1 + 1) 1:/#.
 apply a256l_rcons; first smt().
 apply a256l_rcons => //; smt().
wp; call (_:true); first by auto.
wp; skip => |> *.
split; first smt().
move => |> p i l ???.
have ->: i=128 by smt().
by apply a256l_of_list. 
qed.

(** CBD2 proc. (over a random oracle) samples acording
    to the binomial distribution *)
equiv CBD2rnd_equiv:
 CBD2rnd.sample_real ~ CBD2rnd.sample_ideal:
 true ==> ={res}.
proof.
transitivity CBD2rnd.sampleL_real
 (true ==> ={res}) (true ==> ={res}) => //.
 by apply CBD2rnd_sampleL_eq.
proc.
transitivity {2}
 { p <@ MSwlpoly.S.sample(dlist W8.dword 128,
                         Array256.of_list witness \o flatten \o List.map fcbd2); }
 ( true ==> ={p} ) ( true ==> ={p} ) => //; last first.
 inline*; wp; rnd; wp; auto => /> *; smt(dshort_R_sample).
transitivity {2}
 { p <@ MSwlpoly.S.map(dlist W8.dword 128,
                      Array256.of_list witness \o flatten \o List.map fcbd2); }
 ( true ==> ={p} ) ( true ==> ={p} ) => //; last first.
 by symmetry; call MSwlpoly.sample.
inline MSwlpoly.S.map; swap{2} 2 1.
seq 1 2: (to_list bytes{1} = r1{2}).
 transitivity {1}
  { bytes <@ MSwlw128.S.map(dlist W8.dword 128,
                           (of_list witness)%Array128); }
  ( true ==> ={bytes} ) ( true ==> to_list bytes{1} = r1{2} ) => //.
  by call MSwlw128.sample.
 inline*; wp; rnd; wp; auto => /> l; rewrite supp_dlist //.
 by move=> [?_]; rewrite of_listK.
wp; while {1} 
     (0 <= i{1} <= 128 /\ 
      to_list bytes{1} = r1{2} /\
      l{1} = flatten (List.map fcbd2 (take i{1} r1{2})))
     (128-i{1}).
 move=> &m z.
 wp; skip => /> &hr *; split; last smt().
 split. smt().
 rewrite (take_nth witness); first smt(Array128.size_to_list).
 rewrite map_rcons flatten_rcons.
 rewrite Array128.get_to_list -!cats1 -catA /=; congr. 
 rewrite /fcbd2; congr; smt().
wp; skip => /> &1; split.
 by rewrite take0 /= flatten_nil.
move=> i; split; first smt().
move=> *; have ->: i = size (to_list bytes{1}) by smt(Array128.size_to_list).
by rewrite /(\o) /= take_size.
qed.

equiv CBD2rnd_sampleL_vec_eq:
 CBD2rnd.sample_vec_real ~ CBD2rnd.sampleL_vec_real:
 true ==> ={res}.
proof.
proc.
wp; while (={i} /\ (0 <= i{1} <= kvec) /\
       size l{2}=i{2} /\ forall k, 0 <= k < i{1} => v{1}.[k] = nth witness l{2} k).
 wp; call (_: true); first by sim.
 skip => |> &1 &2 hge hle H hlt result; split; first smt().
 split; first by rewrite size_rcons.
 move=> k ??; rewrite KVec.get_setE 1:/# nth_rcons; smt().
wp; skip => |>; split; first smt(gt0_k).
move=> i_L v_L i_R l_R he1 he2 Hinv; apply KVec.tP => i Hi; rewrite KVec.initiE 1:/#; smt().
qed.

clone DMapSampling as MSvkvec with
 type t1 <- poly list,
 type t2 <- polyvec.

clone Program as LSvec with
 type t <- poly,
 op d <- dshort_R.

equiv CBD2rnd_vec_equiv:
 CBD2rnd.sample_vec_real ~ CBD2rnd.sample_vec_ideal:
 true ==> ={res}.
proof.
transitivity CBD2rnd.sampleL_vec_real
 (true ==> ={res}) (true ==> ={res}) => //.
 by apply CBD2rnd_sampleL_vec_eq.
proc.
transitivity {1}
 { l <- [];
   i <- 0;
   while (i<kvec) {
    p <@ CBD2rnd.sample_ideal();
    l <- rcons l p;
    i <- i+1;
   }
   v <- KVec.init (nth witness l); }
 ( true ==> ={v}) (true ==> ={v} ) => //=.
- wp; while (={i,l} /\ 0 <= i{2} <= kvec).
   by wp; call CBD2rnd_equiv; auto => /> /#.
  by auto.
transitivity {1}
 { l <@ LSvec.LoopSnoc.sample(kvec);
   v <- KVec.init (nth witness l); }
 ( true ==> ={v}) (true ==> ={v} ) => //=.
- inline*; wp.
  while ((i,l){1}=(i0,l0){2} /\ n{2}=kvec /\ 0 <= i{1} <= kvec).
   wp; rnd; auto; smt(cats1).
  by auto.
transitivity {1}
 { l <@ LSvec.Sample.sample(kvec);
   v <- KVec.init (nth witness l); }
 ( true ==> ={v}) (true ==> ={v} ) => //=.
- by symmetry; wp; call LSvec.Sample_LoopSnoc_eq; auto.
transitivity {2} { v <@ MSvkvec.S.map(dlist dshort_R kvec, fun (l:poly list) => KVec.init (nth witness l)); }
 ( true ==> ={v}) (true ==> ={v} ) => //=.
 by inline*; wp; rnd; auto. 
transitivity {1} { v <@ MSvkvec.S.sample(dlist dshort_R kvec, fun (l:poly list) => KVec.init (nth witness l)); }
 ( true ==> ={v}) (true ==> ={v} ) => //=.
 by symmetry; call MSvkvec.sample; auto.
by inline*; wp; rnd; auto => />; rewrite /dvector -dlist_djoin /#.
qed.




(*************************************************************************)
(**   Properties related to the NTT formalisation                       **)
(*************************************************************************)

lemma exp_neg1_2 :
  ZqRing.exp (incoeff (-1)) 2 = Zq.one.
proof. by rewrite ZqRing.expr2 -incoeffM. qed.

lemma exp_neg1_2_ring :
  ZqRing.exp (incoeff (-1)) 2 = Zq.one.
proof. by rewrite ZqRing.expr2 -incoeffM. qed.

(* @jba: on my setting, the following lemmas appear to require this...*)
hint simplify expr0.

lemma exp_zroot_128 :
  ZqRing.exp zroot 128 = incoeff (-1).
proof. by rewrite exp_incoeff /= incoeff_mod eq_sym incoeff_mod /q. qed.

lemma exp_zroot_256 :
  ZqRing.exp zroot 256 = incoeff 1.
proof. by rewrite exp_incoeff /= incoeff_mod /q. qed.

lemma unit_zroot :
  zroot <> Zq.zero.
proof. by rewrite -eq_incoeff /q. qed.

lemma unit_zroot_ring :
  unit zroot.
proof. by exists (incoeff 1175); rewrite -incoeffM_mod /q. qed.

lemma inv_zroot :
  inv zroot = incoeff 1175.
proof.
  apply (ZqField.mulIr zroot); [by apply unit_zroot_ring|].
  rewrite ZqField.mulVf; [by apply unit_zroot|].
  by rewrite -incoeffM_mod /q.
qed.

lemma exp_zroot n :
  ZqRing.exp zroot n =
  incoeff (exp 17 (n %% 256) %% q).
proof. by rewrite -!incoeff_mod (exp_mod _ _ _ exp_zroot_256) exp_incoeff modz_ge0. qed.

lemma exp_zroot_128_ring :
  ZqRing.exp zroot 128 = incoeff (-1).
proof. by rewrite exp_zroot_128. qed.

lemma exp_zroot_256_ring :
  ZqRing.exp zroot 256 = incoeff 1.
proof. by rewrite exp_zroot_256. qed.

lemma exp_zroot_ring n :
  ZqRing.exp zroot n =
  incoeff (exp 17 (n %% 256) %% q).
proof. by rewrite exp_zroot. qed.

lemma eq_exp_zroot_one n :
  ZqRing.exp zroot n = Zq.one <=> n %% 256 = 0.
proof.
  rewrite exp_zroot_ring /q; move: (mem_range_mod n 256 _) => //.
  move: (n %% 256) => {n} n; rewrite -eq_incoeff /q.
  do 256!(rewrite range_ltn //=; case; [by move => ->>|]).
  by rewrite range_geq.
qed.


op scale(p : poly, c : coeff) : poly =  Array256.map (fun x => x * c) p.

lemma ntt_scale p c : ntt (scale p c) = scale (ntt p) c.
proof.
  rewrite /ntt /scale !Array256.mapE Array256.tP => i mem_i_range.
  do 3!(rewrite Array256.initiE //=); case: (i %% 2 = 0) => [modi20|Nmodi20].
  + rewrite BigDom.BAdd.mulr_suml; apply BigDom.BAdd.eq_big_int.
    move => j /mem_range mem_j_range /=; rewrite Array256.initiE /=.
    - by apply/mem_range/mem_range_mull => //=; apply/(bsrev_range 7).
    by rewrite ZqRing.mulrAC.
  rewrite BigDom.BAdd.mulr_suml; apply BigDom.BAdd.eq_big_int.
  move => j /mem_range mem_j_range /=; rewrite Array256.initiE /=.
  + by apply/mem_range/mem_range_addr/mem_range_mull => //=; apply/(bsrev_range 7).
  by rewrite ZqRing.mulrAC.
qed.

lemma sum_pred1 f z a b :
  BigDom.BAdd.bigi predT (fun (x : int) => if x = z then f x else Zq.zero) a b =
  if z \in range a b
  then f z
  else Zq.zero.
proof.
  rewrite (BigDom.BAdd.bigEM (pred1 z)).
  rewrite (BigDom.BAdd.eq_big _ (pred1 z) _ (fun x => f z * Zq.one)) //=.
  + by rewrite ZqRing.mulr1 => ? ->.
  rewrite -BigDom.BAdd.mulr_sumr BigDom.BAdd.sumr_1.
  rewrite (BigDom.BAdd.eq_big _ (predC (pred1 z)) _ (fun x => Zq.zero)) //.
  + by move => x; rewrite /predC /pred1 /= => ->.
  rewrite BigDom.BAdd.big1_eq ZqRing.addr0 count_uniq_mem ?range_uniq //.
  case: (z \in range a b) => _; rewrite /b2i //=; last first.
  + by move: (ZqRing.mulr0z (Zq.one)); rewrite /ofint /intmul /= => ->; rewrite ZqRing.mulr0.
  by move: (ZqRing.mulr1z (Zq.one)); rewrite /ofint /intmul /= => ->; rewrite ZqRing.mulr1.
qed.

require import StdOrder. import IntOrder.
lemma sum_exp z a b :
  BigDom.BAdd.bigi predT (fun n => ZqRing.exp z n) a b =
  if b < a
  then Zq.zero
  else if z = Zq.zero
  then (if 0 \in range a b then Zq.one else Zq.zero)
  else if z = Zq.one
  then incoeff (b - a)
  else inv (z - Zq.one) * (ZqRing.exp z b - ZqRing.exp z a).
proof.
  case: (b < a) => [ltba|/lerNgt leab].
  + by rewrite range_geq; [apply/ltzW|rewrite BigDom.BAdd.big_nil].
  case: (z = Zq.zero) => [->>|unitz].
  + rewrite (BigDom.BAdd.eq_big_int _ _ _ (fun x => if x = 0 then Zq.one else Zq.zero)).
    - by move => x _ /=; rewrite ZqRing.expr0z.
    by rewrite sum_pred1.
  case: (z = Zq.one) => [->>|neqz1].
  + rewrite (BigDom.BAdd.eq_big_int _ _ _ (fun _ => Zq.one)).
    - by move => ? _ /=; rewrite ZqRing.expr1z.
    rewrite BigDom.BAdd.sumr_1 // count_predT size_range ler_maxr ?subr_ge0 //. 
    rewrite /ofint. 
    have : 0 <= b - a by smt().
    elim /natind (b-a).
    + by move => n;case (n = 0); smt(@Zq).
    by move => n *; rewrite incoeffD ZqRing.mulrS; smt(). 
  move: (neqz1); rewrite -ZqRing.subr_eq0 => unitsub; apply/(ZqRing.mulrI (z - Zq.one)) => //.
  + by apply/unitE.
  rewrite ZqRing.mulrA ZqRing.divrr; [by apply/unitE|rewrite ZqRing.mul1r].
  rewrite ZqRing.mulrDl BigDom.BAdd.mulr_sumr ZqRing.mulNr ZqRing.mul1r.
  pose f n:= ZqRing.exp z n; rewrite (BigDom.BAdd.eq_big_int _ _ _ (f \o (( + ) 1))).
  + move => ? _ /=; rewrite /f /= => {f}; rewrite ZqRing.exprD.
    - by apply/unitE.
    by rewrite ZqRing.expr1.
  rewrite -BigDom.BAdd.big_mapT -range_add.
  case/ler_eqVlt: leab => [<<-|ltab].
  + by rewrite !range_geq // BigDom.BAdd.big_nil !ZqRing.subrr.
  rewrite rangeSr -?ltzE // (range_ltn a) //= BigDom.BAdd.big_consT BigDom.BAdd.big_rcons.
  by rewrite {1}/predT /f /=; ring.
qed.

require import BitEncoding. import BitReverse.

lemma invnttK : cancel ntt invntt.
proof.
  move => r; rewrite /ntt /invntt Array256.tP => i /mem_range mem_i_range /=.
  rewrite Array256.initiE //=; move: (mem_range_mod i 2 _) => //; [by move => _; apply mem_range|].
  rewrite range_ltn // range_ltn // range_geq //=.
  case => eq_mod; rewrite eq_mod /=.
  + pose f j:=
      inv (incoeff 128) *
      BigDom.BAdd.bigi
        predT
        (fun (j' : int) =>
          idfun
            ( r.[2 * j'] *
              ZqRing.exp zroot ((2 * br j + 1) * (j' - (i %/ 2))) ) )
         0 128.
    rewrite (BigDom.BAdd.eq_big_int _ _ _ f); rewrite /f => {f}.
    - move => j /mem_range mem_j_range /=; rewrite Array256.initiE //=.
      * by apply/mem_range/mem_range_mull.
      rewrite modzMr /= mulKz // -ZqRing.mulrA; congr.
      rewrite BigDom.BAdd.mulr_suml; apply BigDom.BAdd.eq_big_int.
      move => j' /mem_range mem_j'_range /=; rewrite -ZqRing.mulrA; congr.
      by rewrite -ZqRing.exprD //; [apply/unit_zroot_ring|rewrite mulrDr mulrN].
    rewrite -BigDom.BAdd.mulr_sumr -BigDom.BAdd.big_allpairs.
    pose f x y:= r.[2 * y] * ZqRing.exp zroot ((2 * br x + 1) * (y - i %/ 2)).
    rewrite (BigDom.BAdd.eq_big_perm _ _
               (allpairs f (range 0 128) (range 0 128))
               (allpairs (transpose f) (range 0 128) (range 0 128))).
    - by apply/allpairs_swap.
    rewrite /f => {f}; rewrite BigDom.BAdd.big_allpairs.
    pose f x:=
      if x = i %/ 2
      then incoeff 128 * r.[2 * x]
      else Zq.zero.
    rewrite (BigDom.BAdd.eq_big_int _ _ _ f); rewrite /f => {f}.
    - move => j /mem_range mem_j_range /=.
      rewrite -BigDom.BAdd.mulr_sumr (ZqRing.mulrC).
      rewrite (BigDom.BAdd.eq_big_perm _ _ _ (map br (range 0 128))).
      * rewrite perm_eq_sym; move: (bsrev_range_pow2_perm_eq 7 7 _) => //=.
        by rewrite /br (eq_map (( * ) 1) idfun); [move => ?|rewrite map_id].
      pose f j':= ZqRing.exp (ZqRing.exp zroot (2 * (j - i %/ 2))) j' * ZqRing.exp zroot (j - i %/ 2).
      rewrite BigDom.BAdd.big_mapT (BigDom.BAdd.eq_big_int _ _ _ f); rewrite /f => {f}.
      * move => j' /mem_range mem_j'_range; rewrite /(\o) /br bsrev_involutive //= -ZqRing.exprM.
        by rewrite -ZqRing.exprD; [apply/unit_zroot_ring|rewrite mulrAC mulrSl].
      rewrite -BigDom.BAdd.mulr_suml sum_exp /=.
      have ->/=: ZqRing.exp zroot (2 * (j - i %/ 2)) <> Zq.zero.
      * by apply/unitE/ZqRing.unitrX/unit_zroot_ring.
      rewrite eq_exp_zroot_one -(Ring.IntID.subr_eq0 j) -(mulz_modr 2 (j - i %/ 2) 128) //.
      rewrite mulf_eq0 /=; have ->: ((j - i %/ 2) %% 128 = 0 <=> j - i %/ 2 = 0).
      * move: mem_j_range; rewrite (range_cat (i %/ 2)).
        + by rewrite lez_divRL //; move: mem_i_range; apply/mem_range_le.
        + by apply/ltzW/ltz_divLR => //; move: mem_i_range; apply/mem_range_gt.
        rewrite mem_cat /=; case => mem_j_range.
        + rewrite -(modzMDl 1) /= modz_small.
          - rewrite -mem_range mem_range_addl mem_range_subr; move: mem_j_range; apply mem_range_incl => //.
            by rewrite /= addrC subr_le0 ltzW ltz_divLR //; move: mem_i_range; apply/mem_range_gt.
          have -> //=: j - i %/ 2 <> 0.
          - by rewrite subr_eq0 ltr_eqF //; move: mem_j_range; apply/mem_range_gt.
          rewrite addrA subr_eq0 gtr_eqF //; apply (ltr_le_trans 128).
          - by rewrite ltz_divLR //; move: mem_i_range; apply/mem_range_gt.
          by rewrite -ler_subl_addl; move: mem_j_range; apply/mem_range_le.
        rewrite modz_small // -mem_range mem_range_subr; move: mem_j_range; apply/mem_range_incl => //=.
        by rewrite -ler_subl_addl lez_divRL //; move: mem_i_range; apply/mem_range_le.
      case: (j - i %/ 2 = 0) => [->|]; [by rewrite ZqRing.expr0 ZqRing.mulr1|].
      rewrite ZqRing.expr0 -ZqRing.exprM mulrAC /=.
      by rewrite (exp_mod _ (256 * _) _ exp_zroot_256) modzMr ZqRing.expr0 ZqRing.subrr ZqRing.mulr0 !ZqRing.mul0r.
    rewrite sum_pred1 /= range_div_range //= mem_i_range /= ZqRing.mulrA ZqField.mulVf.
    - by move: (eq_incoeff 128 0); rewrite /Zq.zero /q.
    by rewrite ZqRing.mul1r mulrC {2}(divz_eq i 2) eq_mod.
  pose f j:=
    inv (incoeff 128) *
    BigDom.BAdd.bigi
      predT
      (fun (j' : int) =>
        idfun
          ( r.[2 * j' + 1] *
            ZqRing.exp zroot ((2 * br j + 1) * (j' - (i %/ 2))) ) )
       0 128.
  rewrite (BigDom.BAdd.eq_big_int _ _ _ f); rewrite /f => {f}.
  - move => j /mem_range mem_j_range /=; rewrite Array256.initiE //=.
    * by apply/mem_range/mem_range_addr/mem_range_mull.
    rewrite (Ring.IntID.mulrC 2) modzMDl /= divzMDl //= -ZqRing.mulrA; congr.
    rewrite BigDom.BAdd.mulr_suml; apply BigDom.BAdd.eq_big_int.
    move => j' /mem_range mem_j'_range /=; rewrite -ZqRing.mulrA; congr.
    by rewrite -ZqRing.exprD //; [apply/unit_zroot_ring|rewrite mulrDr mulrN].
  rewrite -BigDom.BAdd.mulr_sumr -BigDom.BAdd.big_allpairs.
  pose f x y:= r.[2 * y + 1] * ZqRing.exp zroot ((2 * br x + 1) * (y - i %/ 2)).
  rewrite (BigDom.BAdd.eq_big_perm _ _
             (allpairs f (range 0 128) (range 0 128))
             (allpairs (transpose f) (range 0 128) (range 0 128))).
  - by apply/allpairs_swap.
  rewrite /f => {f}; rewrite BigDom.BAdd.big_allpairs.
  pose f x:=
    if x = i %/ 2
    then incoeff 128 * r.[2 * x + 1]
    else Zq.zero.
  rewrite (BigDom.BAdd.eq_big_int _ _ _ f); rewrite /f => {f}.
  + move => j /mem_range mem_j_range /=.
    rewrite -BigDom.BAdd.mulr_sumr (ZqRing.mulrC).
    rewrite (BigDom.BAdd.eq_big_perm _ _ _ (map br (range 0 128))).
    - rewrite perm_eq_sym; move: (bsrev_range_pow2_perm_eq 7 7 _) => //=.
      by rewrite /br (eq_map (( * ) 1) idfun); [move => ?|rewrite map_id].
    pose f j':= ZqRing.exp (ZqRing.exp zroot (2 * (j - i %/ 2))) j' * ZqRing.exp zroot (j - i %/ 2).
    rewrite BigDom.BAdd.big_mapT (BigDom.BAdd.eq_big_int _ _ _ f); rewrite /f => {f}.
    - move => j' /mem_range mem_j'_range; rewrite /(\o) /br bsrev_involutive //= -ZqRing.exprM.
      by rewrite -ZqRing.exprD; [apply/unit_zroot_ring|rewrite mulrAC mulrSl].
    rewrite -BigDom.BAdd.mulr_suml sum_exp /=.
    have ->/=: ZqRing.exp zroot (2 * (j - i %/ 2)) <> Zq.zero.
    - by apply/unitE/ZqRing.unitrX/unit_zroot_ring.
    rewrite eq_exp_zroot_one -(Ring.IntID.subr_eq0 j) -(mulz_modr 2 (j - i %/ 2) 128) //.
    rewrite mulf_eq0 /=; have ->: ((j - i %/ 2) %% 128 = 0 <=> j - i %/ 2 = 0).
    - move: mem_j_range; rewrite (range_cat (i %/ 2)).
      * by rewrite lez_divRL //; move: mem_i_range; apply/mem_range_le.
      * by apply/ltzW/ltz_divLR => //; move: mem_i_range; apply/mem_range_gt.
      rewrite mem_cat /=; case => mem_j_range.
      * rewrite -(modzMDl 1) /= modz_small.
        + rewrite -mem_range mem_range_addl mem_range_subr; move: mem_j_range; apply mem_range_incl => //.
          by rewrite /= addrC subr_le0 ltzW ltz_divLR //; move: mem_i_range; apply/mem_range_gt.
        have -> //=: j - i %/ 2 <> 0.
        + by rewrite subr_eq0 ltr_eqF //; move: mem_j_range; apply/mem_range_gt.
        rewrite addrA subr_eq0 gtr_eqF //; apply (ltr_le_trans 128).
        + by rewrite ltz_divLR //; move: mem_i_range; apply/mem_range_gt.
        by rewrite -ler_subl_addl; move: mem_j_range; apply/mem_range_le.
      rewrite modz_small // -mem_range mem_range_subr; move: mem_j_range; apply/mem_range_incl => //=.
      by rewrite -ler_subl_addl lez_divRL //; move: mem_i_range; apply/mem_range_le.
    case: (j - i %/ 2 = 0) => [->|]; [by rewrite ZqRing.expr0 ZqRing.mulr1|].
    rewrite ZqRing.expr0 -ZqRing.exprM mulrAC /=.
      by rewrite (exp_mod _ (256 * _) _ exp_zroot_256) modzMr ZqRing.expr0 ZqRing.subrr ZqRing.mulr0 !ZqRing.mul0r.  
     rewrite sum_pred1 /= range_div_range //= mem_i_range /= ZqRing.mulrA ZqField.mulVf.
  + by move: (eq_incoeff 128 0); rewrite /Zq.zero /q.
  by rewrite ZqRing.mul1r mulrC {2}(divz_eq i 2) eq_mod.
qed.

lemma nttK : cancel invntt ntt.
proof.
  move => r; rewrite /ntt /invntt Array256.tP => i /mem_range mem_i_range /=.
  rewrite Array256.initiE //=; move: (mem_range_mod i 2 _) => //; [by move => _; apply mem_range|].
  rewrite range_ltn // range_ltn // range_geq //=.
  case => eq_mod; rewrite eq_mod /=.
  + pose f j:=
      inv (incoeff 128) *
      BigDom.BAdd.bigi
        predT
        (fun (j' : int) =>
          idfun
            ( r.[2 * j'] *
              ZqRing.exp zroot (2 * (br (i %/ 2) - br j') * j) ) )
         0 128.
    rewrite (BigDom.BAdd.eq_big_int _ _ _ f); rewrite /f => {f}.
    - move => j /mem_range mem_j_range /=; rewrite Array256.initiE //=.
      * by apply/mem_range/mem_range_mull.
      rewrite modzMr /= mulKz // BigDom.BAdd.mulr_suml BigDom.BAdd.mulr_sumr.
      apply BigDom.BAdd.eq_big_int => j' /mem_range mem_j'_range /=.
      rewrite -!ZqRing.mulrA; congr; congr.
      by rewrite -ZqRing.exprD //; [apply/unit_zroot_ring|congr; ring].
    rewrite -BigDom.BAdd.mulr_sumr -BigDom.BAdd.big_allpairs.
    pose f x y:= r.[2 * y] * ZqRing.exp zroot (2 * (br (i %/ 2) - br y) * x).
    rewrite (BigDom.BAdd.eq_big_perm _ _
               (allpairs f (range 0 128) (range 0 128))
               (allpairs (transpose f) (range 0 128) (range 0 128))).
    - by apply/allpairs_swap.
    rewrite /f => {f}; rewrite BigDom.BAdd.big_allpairs.
    pose f x:=
      if x = i %/ 2
      then incoeff 128 * r.[2 * x]
      else Zq.zero.
    rewrite (BigDom.BAdd.eq_big_int _ _ _ f); rewrite /f => {f}.
    - move => j /mem_range mem_j_range /=.
      rewrite -BigDom.BAdd.mulr_sumr (ZqRing.mulrC).
      pose f j':= ZqRing.exp (ZqRing.exp zroot (2 * (br (i %/ 2) - br j))) j'.
      rewrite (BigDom.BAdd.eq_big_int _ _ _ f); rewrite /f => {f}.
      * by move => j' /mem_range mem_j'_range; rewrite -ZqRing.exprM.
      rewrite sum_exp /=; have ->/=: ZqRing.exp zroot (2 * (br (i %/ 2) - br j)) <> Zq.zero.
      * by apply/unitE/ZqRing.unitrX/unit_zroot_ring.
      rewrite eq_exp_zroot_one -(mulz_modr 2 (br (i %/ 2) - br j) 128) //.
      rewrite (eq_sym j); have <-: br (i %/ 2) = br j <=> i %/ 2 = j.
      * by split => [|->//]; apply bsrev_injective => //; apply/range_div_range.
      rewrite -(Ring.IntID.subr_eq0 (br _)) mulf_eq0 /=.
      have ->: (br (i %/ 2) - br j) %% 128 = 0 <=> br (i %/ 2) - br j = 0.
      * move: (bsrev_range 7 (i %/ 2))  (bsrev_range 7 j) => /=.
        move => {mem_i_range mem_j_range} mem_i_range mem_j_range.
        move: mem_j_range; rewrite (range_cat (br (i %/ 2) + 1)).
        + by rewrite -ler_subl_addr; move: mem_i_range; apply/mem_range_le.
        + by rewrite -ltzE; move: mem_i_range; apply/mem_range_gt.
        rewrite mem_cat /=; case => mem_j_range.
        + rewrite modz_small //= -mem_range mem_range_subl; move: mem_j_range; apply mem_range_incl => //=.
          by rewrite -ltzE addrC subr_lt0; move: mem_i_range; apply mem_range_gt.
        rewrite -(modzMDl 1) /= modz_small.
        + rewrite -mem_range mem_range_addl mem_range_subl; move: mem_j_range; apply mem_range_incl => //=.
          by rewrite -ler_subl_addl; move: mem_i_range; apply/mem_range_le.
        have -> //=: br (i %/ 2) - br j <> 0.
        + by rewrite subr_eq0 ltr_eqF // ltzE; move: mem_j_range; apply/mem_range_le.
        rewrite addrA subr_eq0 gtr_eqF //; apply (ltr_le_trans 128).
        + by move: mem_j_range; apply/mem_range_gt.
        by rewrite -ler_subl_addl; move: mem_i_range; apply/mem_range_le.
      case: (br (i %/ 2) - br j = 0) => [//|].
      rewrite ZqRing.expr0 -ZqRing.exprM mulrAC /=.
      by rewrite (exp_mod _ (256 * _) _ exp_zroot_256) modzMr ZqRing.expr0 ZqRing.subrr ZqRing.mulr0 !ZqRing.mul0r.
    rewrite sum_pred1 /= range_div_range //= mem_i_range /= ZqRing.mulrA ZqField.mulVf.
    - by move: (eq_incoeff 128 0); rewrite /Zq.zero /q.
    by rewrite ZqRing.mul1r mulrC {2}(divz_eq i 2) eq_mod.
  pose f j:=
    inv (incoeff 128) *
    BigDom.BAdd.bigi
      predT
      (fun (j' : int) =>
        idfun
          ( r.[2 * j' + 1] *
            ZqRing.exp zroot (2 * (br (i %/ 2) - br j') * j) ) )
       0 128.
  rewrite (BigDom.BAdd.eq_big_int _ _ _ f); rewrite /f => {f}.
  - move => j /mem_range mem_j_range /=; rewrite Array256.initiE //=.
    * by apply/mem_range/mem_range_addr/mem_range_mull.
    rewrite (Ring.IntID.mulrC 2) modzMDl /= divzMDl //=.
    rewrite BigDom.BAdd.mulr_suml BigDom.BAdd.mulr_sumr; apply BigDom.BAdd.eq_big_int.
    move => j' /mem_range mem_j'_range /=; rewrite /= -!ZqRing.mulrA; congr; congr.
    by rewrite -ZqRing.exprD //; [apply/unit_zroot_ring|congr; ring].
  rewrite -BigDom.BAdd.mulr_sumr -BigDom.BAdd.big_allpairs.
  pose f x y:= r.[2 * y + 1] * ZqRing.exp zroot (2 * (br (i %/ 2) - br y) * x).
  rewrite (BigDom.BAdd.eq_big_perm _ _
             (allpairs f (range 0 128) (range 0 128))
             (allpairs (transpose f) (range 0 128) (range 0 128))).
  - by apply/allpairs_swap.
  rewrite /f => {f}; rewrite BigDom.BAdd.big_allpairs.
  pose f x:=
    if x = i %/ 2
    then incoeff 128 * r.[2 * x + 1]
    else Zq.zero.
  rewrite (BigDom.BAdd.eq_big_int _ _ _ f); rewrite /f => {f}.
  + move => j /mem_range mem_j_range /=.
    rewrite -BigDom.BAdd.mulr_sumr (ZqRing.mulrC).
    pose f j':= ZqRing.exp (ZqRing.exp zroot (2 * (br (i %/ 2) - br j))) j'.
    rewrite (BigDom.BAdd.eq_big_int _ _ _ f); rewrite /f => {f}.
    - by move => j' /mem_range mem_j'_range; rewrite /= -ZqRing.exprM.
    rewrite sum_exp /=.
    have ->/=: ZqRing.exp zroot (2 * (br (i %/ 2) - br j)) <> Zq.zero.
    - by apply/unitE/ZqRing.unitrX/unit_zroot_ring.
    rewrite eq_exp_zroot_one -(mulz_modr 2 (br (i %/ 2) - br j) 128) //.
    rewrite (eq_sym j); have <-: br (i %/ 2) = br j <=> i %/ 2 = j.
    - by split => [|->//]; apply bsrev_injective => //; apply/range_div_range.
    rewrite -(Ring.IntID.subr_eq0 (br _)) mulf_eq0 /=.
    have ->: (br (i %/ 2) - br j) %% 128 = 0 <=> br (i %/ 2) - br j = 0.
    - move: (bsrev_range 7 (i %/ 2))  (bsrev_range 7 j) => /=.
      move => {mem_i_range mem_j_range} mem_i_range mem_j_range.
      move: mem_j_range; rewrite (range_cat (br (i %/ 2) + 1)).
      * by rewrite -ler_subl_addr; move: mem_i_range; apply/mem_range_le.
      * by rewrite -ltzE; move: mem_i_range; apply/mem_range_gt.
      rewrite mem_cat /=; case => mem_j_range.
      * rewrite modz_small //= -mem_range mem_range_subl; move: mem_j_range; apply mem_range_incl => //=.
        by rewrite -ltzE addrC subr_lt0; move: mem_i_range; apply mem_range_gt.
      rewrite -(modzMDl 1) /= modz_small.
      * rewrite -mem_range mem_range_addl mem_range_subl; move: mem_j_range; apply mem_range_incl => //=.
        by rewrite -ler_subl_addl; move: mem_i_range; apply/mem_range_le.
      have -> //=: br (i %/ 2) - br j <> 0.
      * by rewrite subr_eq0 ltr_eqF // ltzE; move: mem_j_range; apply/mem_range_le.
      rewrite addrA subr_eq0 gtr_eqF //; apply (ltr_le_trans 128).
      * by move: mem_j_range; apply/mem_range_gt.
      by rewrite -ler_subl_addl; move: mem_i_range; apply/mem_range_le.
    case: (br (i %/ 2) - br j = 0) => [//|].
    rewrite ZqRing.expr0 -ZqRing.exprM mulrAC /=.
      by rewrite (exp_mod _ (256 * _) _ exp_zroot_256) modzMr ZqRing.expr0 ZqRing.subrr ZqRing.mulr0 !ZqRing.mul0r.
  rewrite sum_pred1 /= range_div_range //= mem_i_range /= ZqRing.mulrA ZqField.mulVf.
  + by move: (eq_incoeff 128 0); rewrite /Zq.zero /q.
  by rewrite ZqRing.mul1r mulrC {2}(divz_eq i 2) eq_mod.
qed.

lemma nttvK : cancel invnttv nttv.
proof.
move=> v; apply KVec.tP => i ib.
rewrite /nttv /invnttv /mapv KVec.mapiE 1:/# KVec.mapiE 1:/#.
smt(nttK).
qed.

lemma invnttvK : cancel nttv invnttv.
proof.
move=> v; apply KVec.tP => i ib.
rewrite /nttv /invnttv /mapv KVec.mapiE 1:/# KVec.mapiE 1:/#.
smt(invnttK).
qed.

lemma nttmK : cancel invnttm nttm.
proof.
move=> m; apply KMat.tP => i ib.
rewrite /nttm /invnttm /mapm KMat.mapiE 1:/# KMat.mapiE 1:/#.
smt(nttK).
qed.

lemma invnttmK : cancel nttm invnttm.
proof.
move=> m; apply KMat.tP => i ib.
rewrite /nttm /invnttm /mapm KMat.mapiE 1:/# KMat.mapiE 1:/#.
smt(invnttK).
qed.

lemma invntt_scale p c : invntt (scale p c) = scale (invntt p) c.
proof.
rewrite (_: p = ntt (invntt p)); first by rewrite nttK.
by rewrite -ntt_scale {1}invnttK  nttK.
qed.

(* -------------------------------------------------------------------- *)
(* The residue view of the NTT: block j is the residue modulo           *)
(* X^2 - zroot^(2 br j + 1), a factor of X^256 + 1; the NTT of a        *)
(* product is the product of the residues (the generic residue theory,  *)
(* at leaves of size 2)                                                 *)
(* -------------------------------------------------------------------- *)
clone NttResidue.NttResidueT as NR with
  type coeff   <- coeff,
  theory Coeff <- ZqRing,
  op s         <- 1
  proof rg_s by done.

lemma mulE (a b : poly) : a &* b = NR.negmul a b.
proof.
apply/Array256.ext_eq => k rgk; rewrite mul_lift polyr2polyP // RqTheory.rcoeffM // initiE //=.
apply BigDom.BAdd.eq_big_int => i rgi /=; case: (i <= k) => hik.
- rewrite (RqTheory.gered_rcoeff _ (256 + k - i)) 1:/# ZqRing.mulr0 ZqRing.subr0.
  by rewrite poly2polyrP 1:/# poly2polyrP 1:/#.
rewrite (RqTheory.lt0_rcoeff _ (k - i)) 1:/# ZqRing.mulr0 ZqRing.sub0r.
by rewrite poly2polyrP 1:/# poly2polyrP 1:/#.
qed.

op xroot (j : int) : coeff = ZqRing.exp zroot (2 * br j + 1).

lemma xrootN (j : int) : ZqRing.exp (xroot j) 128 = - Zq.one.
proof.
have ge0br : 0 <= br j by rewrite /br /bsrev BS2Int.bs2int_ge0.
rewrite /xroot -ZqRing.exprM mulzC ZqRing.exprM exp_zroot_128 ZqRing.exprS 1:/#.
by rewrite ZqRing.exprM exp_neg1_2 ZqRing.expr1z ZqRing.mulr1 incoeffN.
qed.

lemma ntt_rntt (p : poly) : ntt p = NR.rntt xroot p.
proof.
apply/Array256.ext_eq => i rgi; rewrite nttE /NR.rntt !initiE //= /NR.resid /=.
have [] hi : i %% 2 = 0 \/ i %% 2 = 1 by smt().
- by rewrite hi /=; apply BigDom.BAdd.eq_big_int => u rgu /=; rewrite mulzC /xroot ZqRing.exprM.
by rewrite hi /=; apply BigDom.BAdd.eq_big_int => u rgu /=; rewrite mulzC /xroot ZqRing.exprM.
qed.

lemma basemul_rmul (a b : poly) : basemul a b = NR.rmul xroot a b.
proof.
apply/Array256.ext_eq => i rgi; rewrite /basemul /NR.rmul !initiE //= /cmplx_mul /=.
have [h0 h1] := NR.resmul_s1
  (fun t => a.[i %/ 2 * 2 + t]) (fun t => b.[i %/ 2 * 2 + t]) (xroot (i %/ 2)) _ => //.
have [] hi : i %% 2 = 0 \/ i %% 2 = 1 by smt().
- by rewrite hi /= h0 /= /xroot (mulzC 2) ZqRing.addrC (ZqRing.mulrC (exp zroot _)).
by rewrite hi /= h1 /= (mulzC 2).
qed.

lemma mul_comm_ntt (pa pb : poly):
  ntt (pa &* pb) = basemul (ntt pa) (ntt pb).
proof.
by rewrite mulE basemul_rmul !ntt_rntt NR.rntt_negmul // => j _; apply xrootN.
qed.

lemma add_comm_ntt (pa pb : poly):
  ntt (pa &+ pb) = (ntt pa) &+ (ntt pb).
proof.
  rewrite /ntt /(&+); apply/Array256.tP => i /mem_range mem_i_range.
  rewrite Array256.map2iE /=; [by apply/mem_range|].
  do 3!(rewrite Array256.initiE /=; [by apply/mem_range|]).
  case: (i %% 2 = 0) => eq_mod.
  + rewrite -BigDom.BAdd.big_split; apply BigDom.BAdd.eq_big_int.
    move => j /mem_range mem_j_range /=.
    rewrite Array256.map2iE /=; [by apply/mem_range/mem_range_mull|].
    by rewrite ZqRing.mulrDl.
  rewrite -BigDom.BAdd.big_split; apply BigDom.BAdd.eq_big_int.
  move => j /mem_range mem_j_range /=.
  rewrite Array256.map2iE /=; [by apply/mem_range/mem_range_addr/mem_range_mull|].
  by rewrite ZqRing.mulrDl.
qed.

lemma add_comm_invntt (pa pb : poly) : 
  invntt (pa &+ pb) = (invntt pa) &+ (invntt pb)
    by smt(invnttK nttK add_comm_ntt).

lemma mul_comm_invntt : forall (pa pb : poly), 
  invntt (basemul pa  pb) = (invntt pa) &* (invntt pb)
    by smt(invnttK nttK mul_comm_ntt).

lemma nttZero : ntt Rq.zero = Rq.zero.
proof.
  rewrite /ntt /Rq.zero; apply/Array256.tP => i /mem_range mem_i_range.
  rewrite Array256.createiE; [by apply/mem_range|].
  rewrite Array256.initiE /=; [by apply/mem_range|].
  rewrite (BigDom.BAdd.eq_big_int _ _ _ (fun _ => Zq.zero)).
  + move => j /mem_range mem_j_range /=.
    rewrite Array256.createiE; [by apply/mem_range/mem_range_mull|].
    by rewrite ZqRing.mul0r.
  rewrite BigDom.BAdd.big1_eq.
  rewrite (BigDom.BAdd.eq_big_int _ _ _ (fun _ => Zq.zero)).
  + move => j /mem_range mem_j_range /=.
    rewrite Array256.createiE; [by apply/mem_range/mem_range_addr/mem_range_mull|].
    by rewrite ZqRing.mul0r.
  by rewrite BigDom.BAdd.big1_eq; case: (i %% 2 = 0).
qed.

lemma invnttzero : invntt Rq.zero = Rq.zero by 
   smt(invnttK nttZero).

lemma nttv_add (v1 v2 : polyvec) :
   nttv (v1 + v2)%PolyVec = (nttv v1 + nttv v2)%PolyVec.
proof. apply KVec.tP => i ib; smt(nttvE polyvec_addE add_comm_ntt). qed.

lemma mulvec a b :
   dotp a b =
   KMatrix.Big.BAdd.bigi predT (fun (i : int) => invntt (basemul (ntt a.[i]) (ntt b.[i]))) 0 kvec.
proof.
rewrite /dotp; apply KMatrix.Big.BAdd.eq_bigr => i _ /=.
by rewrite -mul_comm_ntt invnttK.
qed.

lemma comm_nttv_add v1 v2:  nttv (v1 + v2)%PolyVec = (nttv v1 + nttv v2)%PolyVec.
proof. apply KVec.tP => i ib; smt(nttvE polyvec_addE add_comm_ntt). qed.

import KMatrix.Matrix.

(* ntt/invntt are BAdd-morphisms (no big_morph in the lib): push through the sum. *)
lemma ntt_big (f : int -> poly) (s : int list) :
  ntt (KMatrix.Big.BAdd.big predT f s) = KMatrix.Big.BAdd.big predT (fun j => ntt (f j)) s.
proof.
elim: s => [|x l ih] /=.
+ by rewrite !KMatrix.Big.BAdd.big_nil nttZero.
by rewrite !KMatrix.Big.BAdd.big_cons {1 2}/predT /= add_comm_ntt ih.
qed.

lemma invntt_big (f : int -> poly) (s : int list) :
  invntt (KMatrix.Big.BAdd.big predT f s) = KMatrix.Big.BAdd.big predT (fun j => invntt (f j)) s.
proof.
elim: s => [|x l ih] /=.
+ by rewrite !KMatrix.Big.BAdd.big_nil invnttzero.
by rewrite !KMatrix.Big.BAdd.big_cons {1 2}/predT /= add_comm_invntt ih.
qed.

lemma comm_nttv_mmul (a : polymat) (v : polyvec) :
  nttv (alg2poly (poly2almat a *^ poly2alg v)) = ntt_mmul (nttm a) (nttv v).
proof.
apply KVec.tP => i ib.
rewrite nttvE 1:/# alg2polyE 1:/# KMatrix.Matrix.mulmxvE /ntt_mmul KVec.initiE 1:/# /=.
rewrite nttsum_big ntt_big /range /=.
apply KMatrix.Big.BAdd.eq_big_seq => j /mem_iota jb /=.
by rewrite poly2almatE 1,2:/# poly2algE 1:/# nttmE 1,2:/# nttvE 1:/# mul_comm_ntt.
qed.

lemma comm_ntt_dotp (v1 v2 : polyvec):
  dotp (poly2alg (invnttv v1)) (poly2alg v2) = invntt (ntt_dotp v1 (nttv v2)).
proof.
rewrite /dotp ntt_dotpE invntt_big /range /=.
apply KMatrix.Big.BAdd.eq_big_seq => j /mem_iota jb /=.
by rewrite !poly2algE 1,2:/# invnttvE 1:/# nttvE 1:/# mul_comm_invntt invnttK.
qed.

(* dotpmm removed: dead (no consumers) + subsumed by comm_nttv_mmul/comm_ntt_dotp. *)

lemma nttvecinv v i: 0 <= i < kvec => ntt ((invnttv v).[i])%PolyVec = (v.[i])%PolyVec
  by move => ib; rewrite invnttvE 1:/#; smt(nttK invnttK).


