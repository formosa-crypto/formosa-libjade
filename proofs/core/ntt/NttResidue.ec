(**
  The NTT as a residue map: the multiplicative property, once for all
  leaf sizes.

  Over a commutative ring R, with 0 <= s < 8, a polynomial of
  R[X]/(X^256 + 1) is sent to its residues modulo the 2^(8-s) binomials
  X^(2^s) - w_j, where every w_j satisfies w_j^(2^(8-s)) = -1, so that
  X^(2^s) - w_j divides X^256 + 1.  Coefficient t of the residue
  modulo X^(2^s) - w is

      resid a w t = sum_u a_(u 2^s + t) w^u

  since X^(u 2^s + t) = w^u X^t modulo X^(2^s) - w.

  `resid_negmul` states that the residue of a negacyclic product is the
  product of the residues, reduced once: the multiplication of the NTT
  domain (`resmul`); `rntt_negmul` is the same statement on the whole
  transform (`rntt`, `rmul`).  At s = 0 this is the pointwise product of ML-DSA,
  at s = 1 the products modulo X^2 - w of ML-KEM.

  The proof reads arrays as polynomials (`Poly.PolyComRing`) and works
  with congruences modulo a polynomial, given by an explicit witness
  (`cgr`): reducing modulo X^L - w (`fold`) is a congruence, the
  modulus divides X^256 + 1, and two polynomials of degree below L that
  are congruent modulo the monic X^L - w are equal.
*)

(* ==================================================================== *)
require import AllCore List Ring IntDiv StdOrder StdBigop.
(*---*) import IntOrder.
require Poly.

(* -------------------------------------------------------------------- *)
from JazzEC require import Array256.

(* ==================================================================== *)
abstract theory NttResidueT.

type coeff.

clone import Ring.ComRing as Coeff with type t <= coeff.

clone import Poly.PolyComRing as P with
  type coeff <- coeff,
  theory Coeff <- Coeff.

import BigCf BigPoly.

(* -------------------------------------------------------------------- *)
(* The leaf level                                                       *)
op s : int.

axiom rg_s : 0 <= s < 8.

(* ==================================================================== *)
(* The operators                                                        *)
(* ==================================================================== *)
(* coefficient t of the residue of a modulo X^(2^s) - w *)
op resid (a : coeff Array256.t) (w : coeff) (t : int) : coeff =
  BCA.bigi predT (fun u => a.[u * 2^s + t] * Coeff.exp w u) 0 (2^(8-s)).

(* coefficient t of the product of two residues, modulo X^(2^s) - w *)
op resmul (f g : int -> coeff) (w : coeff) (t : int) : coeff =
  BCA.bigi predT
    (fun i => f i * (if i <= t then g (t - i) else w * g (t + 2^s - i))) 0 (2^s).

(* the negacyclic product, modulo X^256 + 1 *)
op negmul (a b : coeff Array256.t) : coeff Array256.t =
  Array256.init (fun i => BCA.bigi predT
    (fun k => if k <= i then a.[k] * b.[i - k] else - (a.[k] * b.[256 + i - k]))
    0 256).

(* the residue transform: block j holds the residue modulo X^(2^s) - ws j *)
op rntt (ws : int -> coeff) (a : coeff Array256.t) : coeff Array256.t =
  Array256.init (fun i => resid a (ws (i %/ 2^s)) (i %% 2^s)).

(* the product of the transform domain, block by block *)
op rmul (ws : int -> coeff) (a b : coeff Array256.t) : coeff Array256.t =
  Array256.init (fun i =>
    let j = i %/ 2^s in
    resmul (fun t => a.[j * 2^s + t]) (fun t => b.[j * 2^s + t]) (ws j) (i %% 2^s)).

(* ==================================================================== *)
(* Congruences modulo a polynomial                                      *)
(* ==================================================================== *)
op cgr (m p q : poly) = exists h, p - q = h * m.

lemma cgr_refl (m p : poly) : cgr m p p.
proof. by exists poly0; rewrite subrr mul0r. qed.

lemma cgr_sym (m p q : poly) : cgr m p q => cgr m q p.
proof. by move=> [h e]; exists (-h); rewrite -opprB e mulNr. qed.

lemma cgr_trans (m q p r : poly) : cgr m p q => cgr m q r => cgr m p r.
proof.
move=> [h1 e1] [h2 e2]; exists (h1 + h2).
by rewrite mulrDl -e1 -e2 addrA subrK.
qed.

lemma cgrD (m p1 p2 q1 q2 : poly) :
  cgr m p1 q1 => cgr m p2 q2 => cgr m (p1 + p2) (q1 + q2).
proof.
move=> [h1 e1] [h2 e2]; exists (h1 + h2).
by rewrite mulrDl -e1 -e2 opprD addrACA.
qed.

lemma cgrM (m p1 p2 q1 q2 : poly) :
  cgr m p1 q1 => cgr m p2 q2 => cgr m (p1 * p2) (q1 * q2).
proof.
move=> [h1 e1] [h2 e2]; exists (h1 * p2 + q1 * h2).
rewrite mulrDl -!mulrA (mulrC p2) mulrA -e1 -e2.
by rewrite mulrBl mulrBr addrA subrK.
qed.

lemma cgr_exp (m p q : poly) (n : int) :
  0 <= n => cgr m p q => cgr m (exp p n) (exp q n).
proof.
move=> + h; elim: n => [|n ge0n ih]; first by rewrite !expr0 cgr_refl.
by rewrite !exprS // cgrM.
qed.

lemma cgr_sum ['a] (m : poly) (F G : 'a -> poly) (r : 'a list) :
  (forall x, x \in r => cgr m (F x) (G x)) =>
  cgr m (PCA.big predT F r) (PCA.big predT G r).
proof.
elim: r => [|x r ih] h; first by rewrite !PCA.big_nil cgr_refl.
rewrite !PCA.big_consT cgrD; first by apply h.
by apply ih => y ry; apply h; rewrite /= ry.
qed.

(* a congruence modulo m1 is one modulo every divisor of m1 *)
lemma cgr_dvd (m1 m2 p q : poly) : cgr m1 p q => cgr m2 m1 poly0 => cgr m2 p q.
proof.
move=> [h1 e1] [h2]; rewrite subr0 => e2; exists (h1 * h2).
by rewrite e1 e2 mulrA.
qed.

lemma cgr_eq (m p q : poly) : p = q => cgr m p q.
proof. by move=> ->; apply cgr_refl. qed.

(* ==================================================================== *)
(* Arrays as polynomials, reduction modulo X^L - w                      *)
(* ==================================================================== *)
op pa (a : coeff Array256.t) : poly =
  to_polyd (fun i => if 0 <= i < 256 then a.[i] else zeror).

lemma paE (a : coeff Array256.t) (i : int) :
  (pa a).[i] = if 0 <= i < 256 then a.[i] else zeror.
proof.
rewrite coeffE //; split => [c lt0c|]; first by rewrite ifF //#.
by exists 256 => c gtc; rewrite ifF //#.
qed.

lemma deg_pa (a : coeff Array256.t) : deg (pa a) <= 256.
proof. by apply deg_leP => // c gec; rewrite paE ifF //#. qed.

(* the remainder modulo X^L - w of a polynomial of degree below M * L *)
op fold (L M : int) (w : coeff) (p : poly) : poly =
  to_polyd (fun k => if 0 <= k < L
    then BCA.bigi predT (fun u => p.[u * L + k] * exp w u) 0 M else zeror).

lemma foldE (L M : int) (w : coeff) (p : poly) (k : int) :
  (fold L M w p).[k] =
    if 0 <= k < L then BCA.bigi predT (fun u => p.[u * L + k] * exp w u) 0 M else zeror.
proof.
rewrite coeffE //; split => [c lt0c|]; first by rewrite ifF //#.
by exists L => c gtc; rewrite ifF //#.
qed.

lemma deg_fold (L M : int) (w : coeff) (p : poly) : 0 <= L => deg (fold L M w p) <= L.
proof. by move=> ge0L; apply deg_leP => // c gec; rewrite foldE ifF //#. qed.

lemma polyC_sum ['a] (F : 'a -> coeff) (r : 'a list) :
  polyC (BCA.big predT F r) = PCA.big predT (fun x => polyC (F x)) r.
proof.
elim: r => [|x r ih]; first by rewrite BCA.big_nil PCA.big_nil.
by rewrite BCA.big_consT PCA.big_consT polyCD ih.
qed.

(* a sum over [0, M L) as M blocks of length L *)
lemma big_blocks (F : int -> poly) (L M : int) : 0 <= L => 0 <= M =>
    PCA.bigi predT F 0 (M * L)
  = PCA.bigi predT (fun u => PCA.bigi predT (fun t => F (u * L + t)) 0 L) 0 M.
proof.
move=> ge0L; elim: M => [|M ge0M ih]; first by rewrite !PCA.big_geq.
rewrite mulzDl /= (PCA.big_cat_int (M * L)) 1:mulr_ge0 // 1:/# ih.
rewrite PCA.big_int_recr //=; congr.
rewrite -{1}(add0z (M * L)) (addzC (M * L) L) PCA.big_addn /predT /=.
rewrite (: L + M * L - M * L = L) 1:#ring.
by apply PCA.eq_big_int => t _ /=; rewrite addzC.
qed.

(* X^(u L + t) = w^u X^t modulo X^L - w *)
lemma cgr_Xn (L : int) (w : coeff) (u t : int) : 0 <= L => 0 <= u => 0 <= t =>
  cgr (exp X L - polyC w) (exp X (u * L + t)) (polyC (exp w u) * exp X t).
proof.
move=> ge0L ge0u ge0t.
rewrite exprD_nneg 1:mulr_ge0 // (mulzC u) exprM -polyCX //.
apply cgrM; last by apply cgr_refl.
by apply cgr_exp => //; exists poly1; rewrite mul1r.
qed.

lemma cgr_fold (L M : int) (w : coeff) (p : poly) : 0 <= L => 0 <= M => deg p <= M * L =>
  cgr (exp X L - polyC w) p (fold L M w p).
proof.
move=> ge0L ge0M hp.
rewrite {1}(polywE (M * L) p) // big_blocks //.
rewrite (polywE L (fold L M w p)) 1:deg_fold //.
apply (cgr_trans _ (PCA.bigi predT (fun u => PCA.bigi predT
         (fun t => polyC (p.[u * L + t] * exp w u) * exp X t) 0 L) 0 M)).
- apply cgr_sum => u /mem_range rgu /=; apply cgr_sum => t /mem_range rgt /=.
  rewrite polyCM -mulrA scalepE; apply cgrM; first by apply cgr_refl.
  by apply cgr_Xn => //#.
rewrite PCA.exchange_big; apply/cgr_eq/PCA.eq_big_int => t rgt /=.
rewrite foldE ifT 1:/# scalepE polyC_sum PCA.mulr_suml.
by apply PCA.eq_big_int => u _.
qed.

(* remainders modulo the monic X^L - w are unique *)
lemma cgr_uniq (L : int) (w : coeff) (p q : poly) : 0 < L =>
  deg p <= L => deg q <= L => cgr (exp X L - polyC w) p q => p = q.
proof.
move=> gt0L hp hq [h e]; case: (h = poly0) => [->> | nzh].
- by move: e; rewrite mul0r subr_eq0.
have em : exp X L - polyC w = exp X L + polyC (-w) by rewrite polyCN.
have := degM_proper h (exp X L - polyC w) _.
- by rewrite em lc_polyXnDC // mulr1 lc_eq0.
rewrite -e em deg_polyXnDC //.
have := degB p q; have := deg_eq0 h; have := ge0_deg h.
by rewrite nzh /=; smt().
qed.

lemma degM_bnd (p q : poly) (n m : int) : 0 <= n => 0 <= m =>
  deg p <= n => deg q <= m => deg (p * q) <= n + m.
proof.
move=> ge0n ge0m hp hq; apply deg_leP => [/#|k hk].
rewrite polyME; apply BCA.big1_seq => i [_ /mem_range rgi] /=.
case: (i < n) => hi; last by rewrite gedeg_coeff 1:/# Coeff.mul0r.
by rewrite (gedeg_coeff q) 1:/# Coeff.mulr0.
qed.

(* ==================================================================== *)
(* The operators as remainders                                          *)
(* ==================================================================== *)
lemma eML : 2^(8-s) * 2^s = 256.
proof.
have [ge0s lt8s] := rg_s.
by rewrite -exprD_nneg 1,2:/# (: 8 - s + s = 8) 1:/#.
qed.

lemma resid_fold (a : coeff Array256.t) (w : coeff) (t : int) : 0 <= t < 2^s =>
  resid a w t = (fold (2^s) (2^(8-s)) w (pa a)).[t].
proof.
move=> rgt; rewrite foldE ifT // /resid; apply BCA.eq_big_int => u rgu /=.
rewrite paE ifT //; split => [|_]; first smt(expr_gt0).
have : (u + 1) * 2^s <= 2^(8-s) * 2^s by apply ler_wpmul2r; smt(expr_gt0).
by rewrite eML; smt().
qed.

(* the negacyclic product is the remainder modulo X^256 + 1 *)
lemma negmul_fold (a b : coeff Array256.t) :
  pa (negmul a b) = fold 256 2 (-oner) (pa a * pa b).
proof.
apply/poly_eqP => k ge0k; rewrite paE foldE.
case: (k < 256) => hk; last by rewrite !ifF //#.
rewrite ge0k /= initiE 1:/# /=.
rewrite (BCA.big_ltn 0 2) // (BCA.big_ltn 1 2) // (BCA.big_geq 2 2) //=.
rewrite Coeff.expr0 Coeff.expr1 !polyME /=.
rewrite (BCA.big_cat_int (k+1) 0 256) 1,2:/#.
rewrite (BCA.big_cat_int (k+1) 0 (257 + k)) 1,2:/# (BCA.big_cat_int 256 (k+1) (257+k)) 1,2:/#.
have z1 : BCA.bigi predT (fun i => (pa a).[i] * (pa b).[256 + k - i]) 0 (k + 1) = zeror.
- apply BCA.big1_seq => i [_ /mem_range rgi] /=; by rewrite (paE b) ifF 1:/# Coeff.mulr0.
have z2 : BCA.bigi predT (fun i => (pa a).[i] * (pa b).[256 + k - i]) 256 (257 + k) = zeror.
- apply BCA.big1_seq => i [_ /mem_range rgi] /=; by rewrite (paE a) ifF 1:/# Coeff.mul0r.
rewrite z1 z2 Coeff.add0r Coeff.addr0 Coeff.addr0 Coeff.mulr1 Coeff.mulrN1 BCA.sumrN.
congr; apply BCA.eq_big_int => i rgi /=.
- by rewrite ifT 1:/# !paE !ifT 1,2:/#.
by rewrite ifF 1:/# !paE !ifT 1,2:/#.
qed.

(* the remainder of a product of two remainders: one reduction *)
lemma fold_prod (F G : poly) (f g : int -> coeff) (w : coeff) (t : int) :
  0 <= t < 2^s =>
  (forall i, F.[i] = if 0 <= i < 2^s then f i else zeror) =>
  (forall i, G.[i] = if 0 <= i < 2^s then g i else zeror) =>
  (fold (2^s) (2^(8-s)) w (F * G)).[t] = resmul f g w t.
proof.
move=> rgt hF hG; have [ge0s lt8s] := rg_s.
have gt0L : 0 < 2^s by apply expr_gt0.
have ge2M : 2 <= 2^(8-s).
- by rewrite (: 8 - s = (7 - s) + 1) 1:/# exprS 1:/#; smt(expr_gt0).
have hz : forall k, 2 * 2^s <= k => (F * G).[k] = zeror.
- move=> k hk; rewrite polyME; apply BCA.big1_seq => i [_ /mem_range rgi] /=.
  rewrite hF hG; case: (i < 2^s) => hi.
  + by rewrite (ifF (0 <= k - i < 2^s)) 1:/# Coeff.mulr0.
  by rewrite ifF 1:/# Coeff.mul0r.
rewrite foldE ifT // (BCA.big_ltn 0) 1:/# (BCA.big_ltn 1) 1:/# /=.
have -> : BCA.bigi predT (fun u => (F * G).[u * 2^s + t] * exp w u) 2 (2^(8-s)) = zeror.
- apply BCA.big1_seq => u [_ /mem_range rgu] /=; rewrite hz ?Coeff.mul0r //.
  by have := ler_wpmul2r (2^s) _ 2 u _; smt().
rewrite Coeff.expr0 Coeff.expr1 Coeff.mulr1 Coeff.addr0 !polyME /resmul.
rewrite (BCA.big_cat_int (t+1) 0 (2^s)) 1,2:/#.
rewrite (BCA.big_cat_int (t+1) 0 (2^s + t + 1)) 1,2:/#.
rewrite (BCA.big_cat_int (2^s) (t+1) (2^s+t+1)) 1,2:/#.
have -> : BCA.bigi predT (fun i => F.[i] * G.[2^s + t - i]) 0 (t + 1) = zeror.
- apply BCA.big1_seq => i [_ /mem_range rgi] /=; by rewrite (hG (2^s+t-i)) ifF 1:/# Coeff.mulr0.
have -> : BCA.bigi predT (fun i => F.[i] * G.[2^s + t - i]) (2^s) (2^s + t + 1) = zeror.
- apply BCA.big1_seq => i [_ /mem_range rgi] /=; by rewrite hF ifF 1:/# Coeff.mul0r.
rewrite Coeff.add0r Coeff.addr0 BCA.mulr_suml; congr; apply BCA.eq_big_int => i rgi /=.
- by rewrite hF hG ifT 1:/# ifT 1:/# ifT 1:/#.
rewrite hF hG ifT 1:/# ifT 1:/# ifF 1:/# (: 2^s + t - i = t + 2^s - i) 1:/#.
by rewrite -Coeff.mulrA (Coeff.mulrC w).
qed.

(* the products of the two instances: pointwise at leaves of size 1,  *)
(* modulo X^2 - w at leaves of size 2                                  *)
lemma resmul_s0 (f g : int -> coeff) (w : coeff) : s = 0 =>
  resmul f g w 0 = f 0 * g 0.
proof. by move=> hs @/resmul; rewrite hs /= BCA.big_int1. qed.

lemma resmul_s1 (f g : int -> coeff) (w : coeff) : s = 1 =>
     resmul f g w 0 = f 0 * g 0 + w * (f 1 * g 1)
  /\ resmul f g w 1 = f 0 * g 1 + f 1 * g 0.
proof.
move=> hs @/resmul; rewrite hs /= !(BCA.big_ltn 0 2) // !(BCA.big_ltn 1 2) //.
rewrite !(BCA.big_geq 2 2) //=.
by rewrite !Coeff.addr0 Coeff.mulrCA.
qed.

(* the product of two residues only reads them below 2^s *)
lemma resmul_eq (f g f' g' : int -> coeff) (w : coeff) (t : int) :
  (forall i, 0 <= i < 2^s => f i = f' i /\ g i = g' i) => 0 <= t < 2^s =>
  resmul f g w t = resmul f' g' w t.
proof.
move=> h rgt; apply BCA.eq_big_int => i rgi /=.
have [-> _] := h i rgi; case: (i <= t) => hi.
- by have [_ ->] := h (t - i) _; first smt().
by have [_ ->] := h (t + 2^s - i) _; first smt().
qed.

(* ==================================================================== *)
(* The multiplicative property                                          *)
(* ==================================================================== *)
lemma resid_negmul (a b : coeff Array256.t) (w : coeff) (t : int) :
  exp w (2^(8-s)) = - oner => 0 <= t < 2^s =>
  resid (negmul a b) w t = resmul (resid a w) (resid b w) w t.
proof.
move=> hw rgt; have [ge0s lt8s] := rg_s.
have gt0L : 0 < 2^s by apply expr_gt0.
have ge2M : 2 <= 2^(8-s).
- by rewrite (: 8 - s = (7 - s) + 1) 1:/# exprS 1:/#; smt(expr_gt0).
have hd : forall c, deg (pa c) <= 2^(8-s) * 2^s by move=> c; rewrite eML deg_pa.
have hdL : forall p, deg (fold (2^s) (2^(8-s)) w p) <= 2^s by move=> p; apply deg_fold => /#.
(* X^(2^s) - w divides X^256 + 1 *)
have hdiv : cgr (exp X (2^s) - polyC w) (exp X 256 - polyC (-oner)) poly0.
- have := cgr_Xn (2^s) w (2^(8-s)) 0 _ _ _; 1..3: smt(expr_ge0).
  rewrite /= eML hw expr0 mulr1 => h.
  by rewrite -(subrr (polyC (-oner))); apply cgrD => //; apply cgr_refl.
have hneg : cgr (exp X (2^s) - polyC w) (pa (negmul a b)) (pa a * pa b).
- rewrite negmul_fold; apply (cgr_dvd _ _ _ _ _ hdiv); apply/cgr_sym/cgr_fold => //.
  apply (ler_trans (256 + 256)); last done.
  by apply degM_bnd => //; apply deg_pa.
pose FA := fold (2^s) (2^(8-s)) w (pa a); pose FB := fold (2^s) (2^(8-s)) w (pa b).
have hab : cgr (exp X (2^s) - polyC w) (pa a * pa b) (FA * FB).
- by apply cgrM; apply cgr_fold => //; smt(expr_ge0).
have hfab : cgr (exp X (2^s) - polyC w) (FA * FB) (fold (2^s) (2^(8-s)) w (FA * FB)).
- apply cgr_fold; 1,2: smt(expr_ge0).
  apply (ler_trans (2^s + 2^s)); first by apply degM_bnd; smt(expr_ge0).
  by have := ler_wpmul2r (2^s) _ 2 (2^(8-s)) _; smt().
have heq : fold (2^s) (2^(8-s)) w (pa (negmul a b)) = fold (2^s) (2^(8-s)) w (FA * FB).
- apply (cgr_uniq (2^s) w) => //; 1,2: by apply hdL.
  apply (cgr_trans _ (pa (negmul a b))); first by apply/cgr_sym/cgr_fold; smt(expr_ge0).
  apply (cgr_trans _ (FA * FB)) => //.
  by apply (cgr_trans _ _ _ _ hneg hab).
rewrite resid_fold // heq; apply fold_prod => // i.
- case: (0 <= i < 2^s) => hi; first by rewrite resid_fold.
  by rewrite /FA foldE ifF.
case: (0 <= i < 2^s) => hi; first by rewrite resid_fold.
by rewrite /FB foldE ifF.
qed.

lemma rntt_negmul (ws : int -> coeff) (a b : coeff Array256.t) :
  (forall j, 0 <= j < 2^(8-s) => exp (ws j) (2^(8-s)) = - oner) =>
  rntt ws (negmul a b) = rmul ws (rntt ws a) (rntt ws b).
proof.
move=> hws; apply/Array256.ext_eq => i rgi; have [ge0s lt8s] := rg_s.
have gt0L : 0 < 2^s by apply expr_gt0.
have rgj : 0 <= i %/ 2^s < 2^(8-s).
- by rewrite divz_ge0 // ltz_divLR // eML.
have rgt : 0 <= i %% 2^s < 2^s by rewrite modz_ge0 1:/# ltz_pmod.
rewrite /rntt /rmul !initiE //= resid_negmul ?hws //.
apply resmul_eq => // t rgt'.
have rgk : 0 <= i %/ 2^s * 2^s + t < 256.
- have := ler_wpmul2r (2^s) _ (i %/ 2^s + 1) (2^(8-s)) _; smt(eML).
rewrite /= !initiE //= divzMDl 1:/# modzMDl (divz_small t) 1:/# (modz_small t) 1:/#.
done.
qed.
end NttResidueT.
