require import AllCore IntDiv List Ring BitEncoding.
require StdOrder.
require import Array256.

require import GFq Parameters.
import Round ZModQ Zq .


(******************************************************)
(* Representations of polynomials in Zq[X]/(X^256+1)  *)
(******************************************************)

import PolyReduce.

type poly  = coeff Array256.t.
type apoly = polyXnD1.

op poly2prealg (p : poly) : prepoly =
  fun i => if 0 <= i < n then p.[i] else Zq.zero.

op [opaque] poly2alg (p : poly) : apoly =
  pinject (to_polyd (poly2prealg p)).

op [opaque] alg2poly (p : apoly) : poly =
  init (fun i => p.[i]).

lemma ispoly_poly2prealg (p : poly) : ispoly (poly2prealg p).
proof. by (split; last exists 256); smt(). qed.

lemma poly2algiE (p : poly) (i : int) :
  0 <= i < 256 => (poly2alg p).[i] = p.[i].
proof.
move=> rgi @/"_.[_]" @/poly2alg; rewrite piK.
- apply/reducedP/deg_leP => // j lt_ji.
  rewrite coeffE 1:&(ispoly_poly2prealg).
  by rewrite /poly2prealg ifF //#.
- rewrite to_polydK 1:ispoly_poly2prealg.
  by rewrite /poly2prealg ifT.
qed.

lemma alg2polyiE (p : apoly) (i : int) :
  0 <= i < 256 => (alg2poly p).[i] = p.[i].
proof. by move=> ? @/alg2poly; rewrite initiE. qed.

lemma alg2polyK : cancel poly2alg alg2poly.
proof.
move=> p; apply/Array256.ext_eq => i rgi.
by rewrite alg2polyiE // poly2algiE.
qed.

lemma poly2algK : cancel alg2poly poly2alg.
proof.
move=> p; apply: polyXnD1_eqP => i rgi.
by rewrite poly2algiE // alg2polyiE.
qed.

op (&*) (a b : poly) = alg2poly (( * ) (poly2alg a) (poly2alg b)).
op (&+) (a b : poly) = alg2poly (( + ) (poly2alg a) (poly2alg b)).
op (&-) (a   : poly) = alg2poly (PolyReduce.([-]) (poly2alg a)).
op poly_zero : poly = create Zq.zero.


(**************************************************)
(**************************************************)

(* The NTT operation over ring elements *)

import BigCf.BCA.

op zroot = incoeff 1753.

op br = BitEncoding.BitReverse.bsrev 8.

(* FIPS 204, eq. (7.1): slot j of the NTT is the evaluation at
   zroot^(2 br(j) + 1), the 256 roots of X^256 + 1 in bit-reversed order *)
op nttexp (j : int) : int = 2 * br j + 1.

op ntt (p : poly) : poly =
  init (fun j => bigi predT
          (fun s => p.[s] * exp zroot (nttexp j * s)) 0 256).

(* its inverse: interpolation at the same roots *)
op invntt (p : poly) : poly =
  init (fun s => inv (incoeff 256) * bigi predT
          (fun j => p.[j] * exp zroot (- nttexp j * s)) 0 256).

(* -------------------------------------------------------------------- *)
(* zroot is a primitive 512-th root of unity                            *)
(* -------------------------------------------------------------------- *)
lemma incoeff0 : incoeff 0 = zero.
proof. by rewrite incoeff_eq0P. qed.

lemma incoeff1 : incoeff 1 = one.
proof. by apply/asint_inj; rewrite incoeffK oneE. qed.

lemma zroot512 : exp zroot 512 = one.
proof.
rewrite /zroot.
have := incoeff_exp 1753 512; rewrite /= => <-.
by rewrite -eq_incoeff.
qed.

lemma zroot256 : exp zroot 256 = - one.
proof.
rewrite /zroot.
have := incoeff_exp 1753 256; rewrite /= => <-.
by rewrite -incoeffN -eq_incoeff.
qed.

lemma zroot_unit : unit zroot.
proof. by rewrite unitE /zroot -incoeff0 -eq_incoeff. qed.

lemma zroot_mod (e : int) :
  exp zroot e = exp zroot (e %% 512).
proof. by apply/exp_mod/zroot512. qed.

lemma oneN1 : - one <> one.
proof. by rewrite -incoeffN -incoeff1 -eq_incoeff. qed.

(* odd-part decomposition of a positive integer *)
lemma odd_part (d : int) : 0 < d =>
  exists s u, 0 <= s /\ u %% 2 = 1 /\ d = 2^s * u.
proof.
have main : forall K, 0 <= K => forall d, 0 < d < 2^K =>
  exists s u, 0 <= s /\ u %% 2 = 1 /\ d = 2^s * u.
- elim/natind => [K le0K | K ge0K ih] ge0K' x rgx.
  + have ->> : K = 0 by smt().
    by move: rgx => /= /#.
  case (x %% 2 = 1) => hpar; first by exists 0 x.
  have e : 2^(K+1) = 2 * 2^K by rewrite IntID.exprS.
  have [s u [ge0s [hu hd]]] := ih ge0K (x %/ 2) _; 1: smt().
  exists (s + 1) u; rewrite IntID.exprS //#.
move=> gt0d; apply (main d _ d) => //; 1: smt().
split=> // _; elim/natind: d gt0d => [d le0d /#|d ge0d ih _].
by rewrite IntID.exprS //; case: (d = 0) => [->> //|?]; smt().
qed.

lemma zroot_neq1 (d : int) : 0 < d < 512 =>
  exp zroot d <> one.
proof.
move=> rgd; have [s u [ge0s [hodd hd]]] := odd_part d _; 1: smt().
have le8s : s <= 8.
- case (9 <= s) => [h9|/#].
  have : 2^9 <= 2^s by apply StdOrder.IntOrder.ler_weexpn2l.
  smt(StdOrder.IntOrder.expr_gt0).
apply/negP => h1.
have : exp zroot (d * 2^(8-s)) = one.
- by rewrite ZModpRing.exprM h1 ZModpRing.expr1z.
have -> : d * 2^(8-s) = 256 * u.
- rewrite hd (IntID.mulrC _ u) -IntID.mulrA -IntID.exprD_nneg 1,2:/#.
  by rewrite (_ : s + (8 - s) = 8) 1:/# IntID.mulrC.
rewrite ZModpRing.exprM zroot256 (_ : u = 2 * (u %/ 2) + 1) 1:/#.
rewrite (ZModpRing.exprD _ _ _ ZModpRing.unitrN1) ZModpRing.exprM.
rewrite ZModpRing.expr2 ZModpRing.mulrNN ZModpRing.mul1r.
by rewrite ZModpRing.expr1z ZModpRing.expr1 ZModpRing.mul1r &(oneN1).
qed.

lemma zroot_eq1 (e : int) :
  exp zroot e = one <=> 512 %| e.
proof.
rewrite zroot_mod dvdzE; split; last by move=> ->; rewrite ZModpRing.expr0.
by apply: contraLR => ?; apply zroot_neq1; smt().
qed.

(* -------------------------------------------------------------------- *)
(* Orthogonality of the characters s |-> zroot^(2 d s)                  *)
(* -------------------------------------------------------------------- *)
lemma sum_one (n : int) : 0 <= n =>
  bigi predT (fun _ => one) 0 n = incoeff n.
proof.
elim: n => [|n ge0n ih]; first by rewrite big_geq // incoeff0.
by rewrite big_int_recr //= ih incoeffD incoeff1.
qed.

lemma geom_sum (w : coeff) (n : int) : 0 <= n =>
  (w - one) * bigi predT (exp w) 0 n
    = exp w n - one.
proof.
elim: n => [|n ge0n ih].
- by rewrite big_geq // ZModpRing.expr0 ZModpRing.mulr0 ZModpRing.subrr.
rewrite big_int_recr //= ZModpRing.mulrDr ih ZModpRing.exprS //.
by rewrite ZModpRing.mulrBl ZModpRing.mul1r; ring.
qed.

lemma ortho (d : int) : -256 < d < 256 =>
  bigi predT (fun s => exp zroot (2 * d * s)) 0 256
    = if d = 0 then incoeff 256 else zero.
proof.
move=> rgd; case: (d = 0) => [->> /=|nz_d].
- by rewrite -(sum_one 256) //; apply eq_big_int => s _ /=; rewrite ZModpRing.expr0.
pose w := exp zroot (2 * d).
have -> : (fun s => exp zroot (2 * d * s)) = exp w.
- by apply/fun_ext => s; rewrite /w ZModpRing.exprM.
have hw1 : w - one <> zero.
- rewrite ZModpRing.subr_eq0 /w zroot_eq1; smt().
have : (w - one) * bigi predT (exp w) 0 256 = zero.
- rewrite (geom_sum w 256) // /w -ZModpRing.exprM.
  have /zroot_eq1 -> : 512 %| 2 * d * 256 by rewrite dvdzE /#.
  by rewrite ZModpRing.subrr.
by rewrite ZModpFieldMx.mulf_eq0 hw1.
qed.

(* -------------------------------------------------------------------- *)
(* ntt and invntt are inverse of each other                             *)
(* -------------------------------------------------------------------- *)
lemma br_rg (j : int) : 0 <= br j < 256.
proof. by have := BitReverse.bsrev_range 8 j; rewrite mem_range. qed.

lemma br_inj (j k : int) : 0 <= j < 256 => 0 <= k < 256 => br j = br k => j = k.
proof. by move=> rgj rgk; apply BitReverse.bsrev_injective; rewrite // mem_range. qed.

(* reindexing a sum over the NTT slots along the bit reversal *)
lemma sum_br (F : int -> coeff) :
  bigi predT (fun j => F (br j)) 0 256 = bigi predT F 0 256.
proof.
have := BitReverse.bsrev_range_pow2_perm_eq 8 8 _ => //=.
have -> : map (( * ) 1) (range 0 256) = range 0 256.
- by rewrite -{2}(map_id (range 0 256)); apply eq_map => /#.
move=> /(eq_big_perm predT F) <-.
by rewrite big_map.
qed.

lemma sum_delta (F : int -> coeff) (j : int) : 0 <= j < 256 =>
  bigi predT (fun k => if k = j then F k else zero) 0 256 = F j.
proof.
move=> rgj; rewrite (bigD1 _ _ j) 1:mem_range // 1:range_uniq /=.
rewrite big1 ?ZModpRing.addr0 // => k @/predC1 ne_kj /=.
by rewrite ifF.
qed.

lemma inv256K : inv (incoeff 256) * incoeff 256 = one.
proof. by rewrite ZModpRing.mulVr // unitE -incoeff0 -eq_incoeff. qed.

lemma nttK : cancel invntt ntt.
proof.
move=> v; apply/Array256.ext_eq => j rgj; rewrite /ntt initiE //=.
pose c := inv (incoeff 256).
rewrite (eq_big_int _ _ _ (fun s => bigi predT (fun k =>
  c * v.[k] * exp zroot (2 * (br j - br k) * s)) 0 256)) /=.
- move=> s rgs; rewrite /invntt initiE //= -/c mulr_sumr mulr_suml.
  apply eq_big_int => k rgk /=.
  rewrite -!ZModpRing.mulrA -(ZModpRing.exprD _ _ _ zroot_unit); do 3!congr.
  by rewrite /nttexp; ring.
rewrite exchange_big (eq_big_int _ _ _ (fun k => if k = j then v.[j] else zero)).
- move=> k rgk /=; rewrite -mulr_sumr ortho; 1: smt(br_rg).
  case: (k = j) => [->> /=|ne_kj]; last first.
  + by rewrite ifF 2:ZModpRing.mulr0 //; smt(br_inj).
  by rewrite -ZModpRing.mulrA (ZModpRing.mulrC v.[j]) ZModpRing.mulrA inv256K ZModpRing.mul1r.
by rewrite (sum_delta (fun _ => v.[j])).
qed.

lemma invnttK : cancel ntt invntt.
proof.
move=> p; apply/Array256.ext_eq => s rgs; rewrite /invntt initiE //=.
rewrite (eq_big_int _ _ _ (fun j => bigi predT (fun t =>
  p.[t] * exp zroot (t - s) * exp zroot (2 * (t - s) * br j)) 0 256)) /=.
- move=> j rgj; rewrite /ntt initiE //= mulr_suml.
  apply eq_big_int => t rgt /=.
  rewrite -!ZModpRing.mulrA -2!(ZModpRing.exprD zroot _ _ zroot_unit); do 2!congr.
  by rewrite /nttexp; ring.
rewrite exchange_big (eq_big_int _ _ _ (fun t => if t = s then incoeff 256 * p.[s] else zero)).
- move=> t rgt /=; rewrite -mulr_sumr.
  rewrite (sum_br (fun m => exp zroot (2 * (t - s) * m))) ortho 1:/#.
  case: (t = s) => [->> /=|ne_ts]; last by rewrite (ifF (t - s = 0)) 1:/# /= ZModpRing.mulr0.
  by rewrite ZModpRing.expr0 ZModpRing.mulr1 ZModpRing.mulrC.
rewrite (sum_delta (fun _ => incoeff 256 * p.[s])) //=.
by rewrite ZModpRing.mulrA inv256K ZModpRing.mul1r.
qed.

(* The base multiplication in the NTT domain pointwise. *)

op basemul(a b : poly) :  poly = init (fun i => a.[i] * b.[i]).

lemma basemulE (a b : poly) (i : int) :
  0 <= i < 256 => (basemul a b).[i] = a.[i] * b.[i].
proof. by move=> rgi; rewrite /basemul initiE. qed.

(* Scalar multiplication, in either domain: ntt and invntt are linear *)
op scale (c : coeff) (p : poly) : poly = init (fun i => c * p.[i]).

lemma scaleE (c : coeff) (p : poly) (i : int) :
  0 <= i < 256 => (scale c p).[i] = c * p.[i].
proof. by move=> rgi; rewrite /scale initiE. qed.

lemma scaleA (a b : coeff) (p : poly) : scale a (scale b p) = scale (a * b) p.
proof.
by apply/Array256.ext_eq => i rgi; rewrite !scaleE // ZModpRing.mulrA.
qed.

lemma scale1 (p : poly) : scale one p = p.
proof. by apply/Array256.ext_eq => i rgi; rewrite scaleE // ZModpRing.mul1r. qed.

lemma ntt_scale (c : coeff) (p : poly) : ntt (scale c p) = scale c (ntt p).
proof.
apply/Array256.ext_eq => j rgj; rewrite scaleE // /ntt !initiE //= mulr_sumr.
by apply eq_big_int => s rgs /=; rewrite scaleE // ZModpRing.mulrA.
qed.

lemma invntt_scale (c : coeff) (p : poly) : invntt (scale c p) = scale c (invntt p).
proof.
apply/Array256.ext_eq => s rgs; rewrite scaleE // /invntt !initiE //=.
rewrite ZModpRing.mulrCA; congr; rewrite mulr_sumr.
by apply eq_big_int => j rgj /=; rewrite scaleE // ZModpRing.mulrA.
qed.

lemma basemul_scalel (c : coeff) (a b : poly) :
  basemul (scale c a) b = scale c (basemul a b).
proof.
by apply/Array256.ext_eq => i rgi; rewrite scaleE // !basemulE // scaleE // ZModpRing.mulrA.
qed.

op poly_Power2Round(p : poly) : poly * poly = 
     (init (fun i => (Power2Round p.[i]).`1), 
      init (fun i => (Power2Round p.[i]).`2)).

op poly_UseHint(h : poly, r : poly) : poly = 
     init (fun ii => UseHint (!h.[ii] = Zq.zero) r.[ii]).

op poly_MakeHint(p1 : poly, p2 : poly) : poly =
     init (fun ii => incoeff (b2i (MakeHint p1.[ii] p2.[ii]))).

op poly_MakeHintImpl(p1 : poly, p2 : poly) : poly =
     init (fun ii => incoeff (b2i (MakeHintImpl p1.[ii] p2.[ii]))).

op poly_HighBits(p : poly) : poly = 
     init (fun ii => incoeff (HighBits p.[ii])).

op poly_LowBits(p : poly) : poly =
     init (fun ii => incoeff (LowBits p.[ii])).

op infnorm_lt (p : poly) (bound : int) : bool =
  all (fun j => `|p.[j]| < bound) (iota_ 0 256).

(* Componentwise indexing for poly-level +/- and the zero element. *)
lemma poly_addE (a b : poly) (i : int) :
  0 <= i < 256 => (a &+ b).[i] = a.[i] + b.[i].
proof. by move => Hi; rewrite /(&+) alg2polyiE // rcoeffD !poly2algiE. qed.

lemma Rq_addC (a b : poly) : a &+ b = b &+ a.
proof. by apply/Array256.ext_eq => i rgi; rewrite !poly_addE // ZModpRing.addrC. qed.

lemma poly_negE (a : poly) (i : int) :
  0 <= i < 256 => ((&-) a).[i] = - a.[i].
proof. by move => Hi; rewrite /(&-) alg2polyiE // -rcoeffN poly2algiE. qed.

lemma poly_zeroE (i : int) :
  0 <= i < 256 => poly_zero.[i] = Zq.zero.
proof. by move => Hi; rewrite /poly_zero Array256.createiE. qed.

lemma Rq_addA (a b c : poly) : a &+ (b &+ c) = (a &+ b) &+ c.
proof. by apply/Array256.ext_eq => i rgi; rewrite !poly_addE // ZModpRing.addrA. qed.

lemma Rq_add0r (a : poly) : poly_zero &+ a = a.
proof. by apply/Array256.ext_eq => i rgi; rewrite poly_addE // poly_zeroE // ZModpRing.add0r. qed.

lemma Rq_addr0 (a : poly) : a &+ poly_zero = a.
proof. by rewrite Rq_addC Rq_add0r. qed.

lemma scaleD (c : coeff) (a b : poly) : scale c (a &+ b) = scale c a &+ scale c b.
proof.
apply/Array256.ext_eq => i rgi.
by rewrite scaleE // !poly_addE // !scaleE // ZModpRing.mulrDr.
qed.

lemma scaleN (c : coeff) (a : poly) : scale c ((&-) a) = (&-) (scale c a).
proof.
apply/Array256.ext_eq => i rgi.
by rewrite scaleE // !poly_negE // scaleE // ZModpRing.mulrN.
qed.

lemma scale0 (c : coeff) : scale c poly_zero = poly_zero.
proof.
by apply/Array256.ext_eq => i rgi; rewrite scaleE // poly_zeroE // ZModpRing.mulr0.
qed.

lemma Rq_addN (a : poly) : a &+ (&-) a = poly_zero.
proof.
by apply/Array256.ext_eq => i rgi; rewrite poly_addE // poly_negE // poly_zeroE // ZModpRing.addrN.
qed.

(* ntt and invntt are additive *)
lemma nttD (a b : poly) : ntt (a &+ b) = ntt a &+ ntt b.
proof.
apply/Array256.ext_eq => j rgj; rewrite poly_addE // /ntt !initiE //= -big_split.
by apply eq_big_int => s rgs /=; rewrite poly_addE // ZModpRing.mulrDl.
qed.

lemma invnttD (a b : poly) : invntt (a &+ b) = invntt a &+ invntt b.
proof.
apply/Array256.ext_eq => s rgs; rewrite poly_addE // /invntt !initiE //= -ZModpRing.mulrDr -big_split.
by congr; apply eq_big_int => j rgj /=; rewrite poly_addE // ZModpRing.mulrDl.
qed.

lemma nttN (a : poly) : ntt ((&-) a) = (&-) (ntt a).
proof.
apply/Array256.ext_eq => j rgj; rewrite poly_negE // /ntt !initiE //= sumrN.
by apply eq_big_int => s rgs /=; rewrite poly_negE // ZModpRing.mulNr.
qed.

lemma invnttN (a : poly) : invntt ((&-) a) = (&-) (invntt a).
proof.
apply/Array256.ext_eq => s rgs; rewrite poly_negE // /invntt !initiE //= -ZModpRing.mulrN sumrN.
by congr; apply eq_big_int => j rgj /=; rewrite poly_negE // ZModpRing.mulNr.
qed.

lemma ntt0 : ntt poly_zero = poly_zero.
proof.
rewrite -{1}(scale0 zero) ntt_scale; apply/Array256.ext_eq => j rgj.
by rewrite scaleE // poly_zeroE // ZModpRing.mul0r.
qed.

lemma invntt0 : invntt poly_zero = poly_zero.
proof.
rewrite -{1}(scale0 zero) invntt_scale; apply/Array256.ext_eq => j rgj.
by rewrite scaleE // poly_zeroE // ZModpRing.mul0r.
qed.

(* -------------------------------------------------------------------- *)
(* The residue view of the NTT: slot j is the evaluation at             *)
(* x_j = zroot^(nttexp j), a root of X^256 + 1, which is a ring          *)
(* morphism on Zq[X]/(X^256 + 1): the convolution theorem               *)
(* -------------------------------------------------------------------- *)
lemma peval_expX (x : coeff) (k : int) : 0 <= k =>
  peval (PolyComRing.exp X k) x = ZModpRing.exp x k.
proof.
elim: k => [|k ge0k ih]; first by rewrite PolyComRing.expr0 ZModpRing.expr0 pevalC.
by rewrite PolyComRing.exprS // ZModpRing.exprS // pevalM pevalX ih.
qed.

(* evaluation at a root of X^n + 1 is constant on the classes mod X^n + 1 *)
lemma peval_eqv (p q : BasePoly.poly) (x : coeff) :
  ZModpRing.exp x n = - one => eqv p q => peval p x = peval q x.
proof.
move=> hx; rewrite /eqv /I PIdeal.mem_idgen1 => -[b hb].
have : peval (q - p) x = zero.
- by rewrite hb pevalM pevalD pevalC peval_expX // hx ZModpRing.addNr ZModpRing.mulr0.
by rewrite pevalB ZModpRing.subr_eq0 => ->.
qed.

lemma pevalX_mul (A B : polyXnD1) (x : coeff) :
  ZModpRing.exp x n = - one => pevalX (A * B) x = pevalX A x * pevalX B x.
proof.
move=> hx; rewrite /pevalX -pevalM.
have -> : A * B = pinject (prepr A * prepr B) by rewrite -mulE !reprK.
by apply/peval_eqv/eqv_repr.
qed.

lemma nttroot (j : int) : ZModpRing.exp (ZModpRing.exp zroot (nttexp j)) n = - one.
proof.
rewrite -ZModpRing.exprM mulzC ZModpRing.exprM zroot256 /nttexp.
rewrite ZModpRing.exprS 1:#smt:(br_rg) ZModpRing.exprM ZModpRing.expr2.
by rewrite ZModpRing.mulrNN ZModpRing.mul1r ZModpRing.expr1z ZModpRing.mulr1.
qed.

lemma ntt_peval (p : poly) (j : int) : 0 <= j < 256 =>
  (ntt p).[j] = pevalX (poly2alg p) (ZModpRing.exp zroot (nttexp j)).
proof.
move=> rgj; rewrite /ntt initiE //= /pevalX.
rewrite (peval_eqv _ (crepr (poly2alg p))) 1:&(nttroot) 1:&(eqv_reduce).
rewrite (pevalE_ge _ _ n) 1:&(deg_crepr).
apply eq_big_int => s rgs /=.
by rewrite -/("_.[_]" (poly2alg p) s) poly2algiE // ZModpRing.exprM.
qed.

lemma ntt_mul (a b : poly) : ntt (a &* b) = basemul (ntt a) (ntt b).
proof.
apply/Array256.ext_eq => j rgj.
by rewrite basemulE // !ntt_peval // /(&*) poly2algK pevalX_mul 1:&(nttroot).
qed.

(* the convolution theorem *)
lemma conv (a b : poly) : invntt (basemul (ntt a) (ntt b)) = a &* b.
proof. by rewrite -ntt_mul invnttK. qed.

lemma Rq_mulC (a b : poly) : a &* b = b &* a.
proof. by rewrite /(&*) PolyReduce.ComRingDflInv.mulrC. qed.

(* -------------------------------------------------------------------- *)
(* The l1 norm, and the coefficient bound of a product mod X^256 + 1:   *)
(* |(a * b)_k| <= ||a||_1 * ||b||_inf                                   *)
(* -------------------------------------------------------------------- *)
require StdBigop.

op l1 (p : poly) : int = StdBigop.Bigint.BIA.bigi predT (fun i => `|p.[i]|) 0 256.

lemma ge0_l1 (p : poly) : 0 <= l1 p.
proof. by rewrite /l1 StdBigop.Bigint.sumr_ge0 => i _ /=; apply ge0_abs_zp. qed.

lemma conv_coeff_bnd (a b : poly) (B : int) (k : int) : 0 <= k < 256 =>
  (forall i, 0 <= i < 256 => `|b.[i]| <= B) => `|(a &* b).[k]| <= l1 a * B.
proof.
move=> rgk hb; rewrite /(&*) alg2polyiE // rcoeffM //.
apply (StdOrder.IntOrder.ler_trans _ _ _ (abs_zp_triangle_big _ _)).
rewrite /l1 StdBigop.Bigint.BIA.mulr_suml.
apply StdBigop.Bigint.ler_sum_seq => i /mem_range rgi _ /=.
(* exactly one of the two products has its index in range *)
rewrite poly2algiE //.
case: (i <= k) => hik.
- rewrite (gered_rcoeff _ (n + k - i)) 1:/# ZModpRing.mulr0 ZModpRing.subr0 poly2algiE 1:/#.
  apply (StdOrder.IntOrder.ler_trans _ _ _ (abs_zp_prod _ _)).
  by apply StdOrder.IntOrder.ler_wpmul2l; [apply ge0_abs_zp | apply hb; smt()].
rewrite (lt0_rcoeff _ (k - i)) 1:/# ZModpRing.mulr0 ZModpRing.sub0r -abs_zpN poly2algiE 1:/#.
apply (StdOrder.IntOrder.ler_trans _ _ _ (abs_zp_prod _ _)).
by apply StdOrder.IntOrder.ler_wpmul2l; [apply ge0_abs_zp | apply hb; smt()].
qed.

(* -------------------------------------------------------------------- *)
(* polynomials with independent coefficients uniform in [a, b]          *)
(* -------------------------------------------------------------------- *)
require import Distr DInterval.
require JArrayExtra.

clone JArrayExtra.PAE as Array256E with op size <- 256, theory A <- Array256.

op dpoly (a b : int) : poly distr = Array256E.darray (dmap (dinter a b) incoeff).

lemma supp_dpoly (a b : int) (p : poly) :
  (q + 1) %/ 2 - q <= a => b < (q + 1) %/ 2 =>
  p \in dpoly a b <=> forall i, 0 <= i < n => a <= crepr p.[i] <= b.
proof.
move=> ha hb; rewrite /dpoly Array256E.supp_darray; split=> h i rgi.
- by have /supp_dmap [x [/supp_dinter hx ->]] := h i _; rewrite // incoeffK_centered /#.
by rewrite supp_dmap; exists (crepr p.[i]); rewrite supp_dinter creprK h.
qed.

lemma dpoly_uni (a b : int) :
  (q + 1) %/ 2 - q <= a => b < (q + 1) %/ 2 => is_uniform (dpoly a b).
proof.
move=> ha hb; apply/Array256E.darray_uni/dmap_uni_in_inj/dinter_uni.
move=> x y /supp_dinter hx /supp_dinter hy hxy.
by rewrite -(incoeffK_centered x) 1,2:/# -(incoeffK_centered y) 1,2:/# hxy.
qed.

lemma dpoly_ll (a b : int) : a <= b => is_lossless (dpoly a b).
proof. by move=> hab; apply/Array256E.darray_ll/dmap_ll/dinter_ll. qed.
