require import AllCore IntDiv.
require import Array256.
require import Parameters GFq Rq.
import Round ZModQ Zq.

(* Decompose, the hints and their polynomial lifts: the part of the
   rounding that depends on gamma2. *)
abstract theory DecomposeT.

clone include ParamsT.
import MLDSAParams.

op Decompose(r : coeff) : int * int = 
   let rplus = asint r in
   let rzero = smodem rplus (2*gamma2) in
   if (rplus - rzero = q-1) 
   then (0,rzero - 1)
   else ((rplus - rzero) %/ (2*gamma2),rzero).

op HighBits(r : coeff) = (Decompose r).`1.

op LowBits(r : coeff) = (Decompose r).`2.

op MakeHint(z r : coeff) : bool =
   let r1 = HighBits(r) in
   let v1 = HighBits(r+z) in
      r1 <> v1.

(* Implementation convention: high = w1 = HighBits(w), low = r0+ct0 = LowBits(w)-cs2+ct0.
   Computes whether adding low to high*2*gamma2 changes the high bits. *)
op MakeHintImpl(high low : coeff) : bool =
  MakeHint (Zq.zero - low) (incoeff (asint high * 2 * gamma2) + low).

op UseHint(h : bool, r : coeff) : coeff = 
    let m = (q-1) %/ (2*gamma2) in
    let (r1,r0) = Decompose r in
    if h && 0 < r0
    then incoeff ((r1 + 1) %% m)
    else if (h && r0 <= 0)
         then incoeff ((r1 - 1) %% m)
         else incoeff r1.

(* -------------------------------------------------------------------- *)
(* The Decompose kit: uniqueness, representation, ranges. HighBits      *)
(* ranges over [0, hb_range), with 2 gamma2 * hb_range = q - 1.         *)
(* -------------------------------------------------------------------- *)
op hb_range : int = (q - 1) %/ (2 * gamma2).

lemma hb_rangeE : 2 * gamma2 * hb_range = q - 1.
proof. by rewrite /hb_range mulzC divzK 1:gamma2_div. qed.

lemma hb_range_cases : hb_range = 16 \/ hb_range = 44.
proof. by rewrite /hb_range; case: gamma2_cases => ->. qed.

lemma gt1_hb_range : 1 < hb_range by smt(hb_range_cases).

lemma ge2_gamma2 : 2 <= gamma2 by smt(gamma2_bound).

lemma Beta_bnd : 0 <= Beta < gamma2 by smt(gt0_beta beta_gamma2_lt).

(* a pair (a, b) with 0 <= a < hb_range and -gamma2 < b <= gamma2
   representing r is Decompose r *)
lemma Decompose_unique (a b : int) (r : coeff) :
  0 <= a < hb_range => -gamma2 < b <= gamma2 =>
  incoeff (2 * gamma2 * a + b) = r => Decompose r = (a, b).
proof.
move=> ha hb <-; rewrite /Decompose /smodem /= incoeffK.
have hM := hb_rangeE; have hg := ge2_gamma2.
have -> : 2 * gamma2 %/ 2 = gamma2 by rewrite mulzC mulzK.
have hmod : forall x, (2 * gamma2 * a + x) %% (2 * gamma2) = x %% (2 * gamma2).
+ by move=> x; rewrite (mulzC (2 * gamma2)) modzMDl.
have hA : 2 * gamma2 * a <= q - 1 - 2 * gamma2.
+ have -> : q - 1 - 2 * gamma2 = 2 * gamma2 * (hb_range - 1) by rewrite -hM; ring.
  by apply StdOrder.IntOrder.ler_wpmul2l; smt().
case: (0 <= 2 * gamma2 * a + b) => hx.
- rewrite (pmod_small _ q) 1:/# hmod.
  case: (0 <= b) => hb0.
  + rewrite (pmod_small b) 1:/# (ifF (gamma2 < b)) 1:/# ifF 1:/# /=.
    by rewrite (addzK b) mulzC mulzK /#.
  have -> : b %% (2 * gamma2) = b + 2 * gamma2 by rewrite -(modzMDr 1) pmod_small /#.
  rewrite (ifT (gamma2 < b + 2 * gamma2)) 1:/# /= ifF 1:/# /=.
  have -> : b + 2 * gamma2 - 2 * gamma2 = b by ring.
  by rewrite (addzK b) mulzC mulzK /#.
have ->> : a = 0.
- case: (a = 0) => // ha0; have : 2 * gamma2 * 1 <= 2 * gamma2 * a.
  + by apply StdOrder.IntOrder.ler_wpmul2l; smt().
  smt().
have -> : (2 * gamma2 * 0 + b) %% q = b + q by rewrite /= -(modzMDr 1) pmod_small /#.
have hq : b + q = (b + 1) + hb_range * (2 * gamma2) by smt().
have -> : (b + q) %% (2 * gamma2) = (b + 1) %% (2 * gamma2) by rewrite hq modzMDr.
case: (b = -1) => [->> /=|hb1].
- by rewrite (ifF (gamma2 < 0)) 1:/#.
have -> : (b + 1) %% (2 * gamma2) = b + 1 + 2 * gamma2.
+ by rewrite -(modzMDr 1) pmod_small /#.
rewrite ifT 1:/# /= ifT 1:/#; smt().
qed.

(* the corner case of Decompose: -gamma2 is (0, -gamma2) *)
lemma Decompose_neg_gamma (r : coeff) :
  incoeff (- gamma2) = r => Decompose r = (0, - gamma2).
proof.
move=> <-; rewrite /Decompose /smodem /= incoeffK.
have hM := hb_rangeE; have hg := ge2_gamma2.
have -> : 2 * gamma2 %/ 2 = gamma2 by rewrite mulzC mulzK.
have -> : (- gamma2) %% q = q - gamma2 by rewrite -(modzMDr 1) pmod_small /#.
have -> : (q - gamma2) %% (2 * gamma2) = gamma2 + 1.
+ have -> : q - gamma2 = (gamma2 + 1) + (hb_range - 1) * (2 * gamma2) by smt().
  by rewrite modzMDr pmod_small /#.
by rewrite ifT 1:/# /= ifT 1:/#; smt().
qed.

(* ranges of the pair, and r = 2 gamma2 HighBits r + LowBits r *)
lemma Decompose_cases (r : coeff) :
     0 <= HighBits r < hb_range /\ -gamma2 <= LowBits r <= gamma2
  /\ incoeff (2 * gamma2 * HighBits r + LowBits r) = r.
proof.
rewrite /HighBits /LowBits /Decompose /smodem /=.
have hM := hb_rangeE; have hg := ge2_gamma2.
have -> : 2 * gamma2 %/ 2 = gamma2 by rewrite mulzC mulzK.
have [rg0 rgq] := rg_asint r.
have hdq := divz_eq (asint r) (2 * gamma2).
have [hx0 hxl] : 0 <= asint r %% (2 * gamma2) < 2 * gamma2 by smt(modz_ge0 ltz_pmod).
move: hdq hx0 hxl; move: (asint r %/ (2 * gamma2)) (asint r %% (2 * gamma2)) => k x hdq hx0 hxl.
have hk0 : 0 <= k by smt().
have hkM : k <= hb_range.
+ case: (k <= hb_range) => // hk; have : (hb_range + 1) * (2 * gamma2) <= k * (2 * gamma2).
  * by apply StdOrder.IntOrder.ler_wpmul2r; smt().
  smt().
have hinj : forall j, (j * (2 * gamma2) = q - 1) <=> (j = hb_range).
+ move=> j; rewrite -hM (mulzC (2 * gamma2) hb_range); split=> [|-> //].
  by move=> h; rewrite -(mulzK j (2 * gamma2)) 1:/# h mulzK /#.
case: (gamma2 < x) => hc /=.
- rewrite hdq (_ : k * (2 * gamma2) + x - (x - 2 * gamma2) = (k + 1) * (2 * gamma2)) 1:#ring.
  rewrite mulzK 1:/#.
  case: (k + 1 = hb_range) => hk16.
  + rewrite ifT 1:hinj // /=; split; 1: smt().
    split; 1: smt().
    apply incoeffP; rewrite hdq.
    have -> : x - 2 * gamma2 - 1 = (k * (2 * gamma2) + x) + (-1) * q by smt().
    by rewrite modzMDr pmod_small /#.
  have hk1 : k + 1 < hb_range.
  + case: (k = hb_range) => hkm; 2: smt().
    by move: hdq; rewrite hkm (mulzC hb_range) hM; smt().
  rewrite ifF 1:hinj // /=; split; first smt().
  split; first smt().
  apply incoeffP; rewrite hdq.
  have -> : 2 * gamma2 * (k + 1) + (x - 2 * gamma2) = k * (2 * gamma2) + x by ring.
  by rewrite pmod_small /#.
rewrite hdq (_ : k * (2 * gamma2) + x - x = k * (2 * gamma2)) 1:#ring mulzK 1:/#.
case: (k = hb_range) => hk16.
+ rewrite ifT 1:hinj // /=; split; 1: smt().
  split; 1: smt().
  apply incoeffP; rewrite hdq.
  have hx : x = 0 by move: hdq; rewrite hk16 (mulzC hb_range) hM; smt().
  by rewrite hx hk16 /= (mulzC hb_range) hM.
rewrite ifF 1:hinj // /=; split; first smt().
split; first smt().
apply incoeffP; rewrite hdq.
by rewrite (mulzC (2 * gamma2)) pmod_small /#.
qed.

(* Key equivalence: MakeHintImpl with (HighBits(w), LowBits(w)-cs2+ct0) equals
   MakeHint(-ct0, w-cs2+ct0), connecting the eager/impl convention to FIPS 204.
   The implementation's convention replaces HighBits(w - cs2) by HighBits(w):
   this needs cs2 not to push the low bits of w across a 2*gamma2 boundary,
   i.e. |LowBits(w) - cs2| < gamma2 (|cs2| <= Beta alone does not suffice).
   The signing loop's rejection test |LowBits(w) - cs2| < gamma2 - Beta
   provides it where the lemma is used. *)
lemma MakeHintImpl_MakeHint_equiv (w cs2 ct0 : coeff) :
    `|LowBits w - crepr cs2| < gamma2 =>
    MakeHintImpl (incoeff (HighBits w)) (incoeff (LowBits w) - cs2 + ct0) =
    MakeHint (Zq.zero - ct0) (w - cs2 + ct0).
proof.
move=> hlow; have hg := ge2_gamma2; have hM := hb_rangeE.
have [#] hh0 hh1 hl0 hl1 hr := Decompose_cases w.
(* HighBits (w - cs2) = HighBits w: cs2 does not cross a boundary *)
have hH : HighBits (w - cs2) = HighBits w.
- rewrite {1}/HighBits (Decompose_unique (HighBits w) (LowBits w - crepr cs2) (w - cs2)) 1,2:/# //.
  have -> : 2 * gamma2 * HighBits w + (LowBits w - crepr cs2) = (2 * gamma2 * HighBits w + LowBits w) - crepr cs2 by ring.
  by rewrite incoeffB hr creprK.
(* HighBits of a pure multiple of 2 gamma2 is the multiplier *)
have hM2 : HighBits (incoeff (HighBits w * 2 * gamma2)) = HighBits w.
- rewrite {1}/HighBits (Decompose_unique (HighBits w) 0 _) 1,2:/# //.
  by congr; ring.
have hHq : 0 <= HighBits w * 2 * gamma2 < q.
- have : HighBits w * (2 * gamma2) <= (hb_range - 1) * (2 * gamma2).
  + by apply StdOrder.IntOrder.ler_wpmul2r; smt().
  smt().
rewrite /MakeHintImpl /MakeHint /= incoeffK (pmod_small _ q) 1:/#.
(* both second arguments are w - cs2 + ct0; the first ones shift to *)
(* 2 gamma2 HighBits w and to w - cs2, both of high bits HighBits w *)
have e2 : forall (x y : coeff), x + y + (Zq.zero - y) = x by move=> x y; ring.
rewrite (e2 (incoeff (HighBits w * 2 * gamma2))).
have e1 : incoeff (HighBits w * 2 * gamma2) + (incoeff (LowBits w) - cs2 + ct0) = w - cs2 + ct0.
- by rewrite -{3}hr (_ : 2 * gamma2 * HighBits w = HighBits w * 2 * gamma2) 1:#ring incoeffD; ring.
by rewrite e1 hM2 -hH; congr; congr; congr; ring.
qed.

(* Coefficient-level synchronization for the bz norm check:
   when |cs2| <= Beta, the infnorm check on LowBits(a - cs2) and on LowBits(a) - cs2
   agree at threshold gamma2 - Beta.
   - No 2*gamma2 crossing case: LowBits(a - cs2) = LowBits(a) - cs2 (as coeffs).
   - Crossing case: |LowBits(a) - cs2| >= gamma2 > gamma2 - Beta, and likewise
     |LowBits(a - cs2)| >= gamma2 - Beta (since LowBits is bounded but cs2 was the
     boundary-crosser). Both checks fail. *)
lemma LowBits_sub_sync (a cs2 : coeff) :
    `|cs2| <= Beta =>
    (`|incoeff (LowBits (a - cs2))| < gamma2 - Beta) =
    (`|incoeff (LowBits a) - cs2| < gamma2 - Beta).
proof.
move=> hcs; have [hB0 hB1] := Beta_bnd.
have [#] hh0 hh1 hl0 hl1 hr := Decompose_cases a.
have [#] _ _ hl0' hl1' _ := Decompose_cases (a - cs2).
have hc : `|crepr cs2| <= Beta by done.
(* t = LowBits a - cs2, read as an integer: a - cs2 = 2 gamma2 HighBits a + t *)
pose t := LowBits a - crepr cs2.
have hrep : incoeff (2 * gamma2 * HighBits a + t) = a - cs2.
- have -> : 2 * gamma2 * HighBits a + t = (2 * gamma2 * HighBits a + LowBits a) - crepr cs2 by rewrite /t; ring.
  by rewrite incoeffB hr creprK.
have hg := ge2_gamma2; have hM := hb_rangeE; have hgb := gamma2_bound.
have -> : `|incoeff (LowBits a) - cs2| = `|t|.
- by rewrite -abs_incoeff 1:/# /t incoeffB creprK.
rewrite abs_incoeff 1:/#.
(* no boundary crossing: the low bits of a - cs2 are t *)
case: (-gamma2 < t <= gamma2) => [ht|ht].
- by rewrite {1}/LowBits (Decompose_unique (HighBits a) t (a - cs2)).
(* crossing: |t| >= gamma2, and the low bits of a - cs2 wrap by 2 gamma2 *)
suff hL : gamma2 - Beta <= `|LowBits (a - cs2)| by smt().
case: (gamma2 < t) => hgt.
- case: (HighBits a + 1 < hb_range) => hh.
  + rewrite {1}/LowBits (Decompose_unique (HighBits a + 1) (t - 2 * gamma2) (a - cs2)) 1,2:/#.
    * by rewrite -hrep; congr; ring.
    by smt().
  have hrep2 : incoeff (t - 2 * gamma2 - 1) = a - cs2.
  + rewrite -hrep -incoeffDq; congr.
    have -> : HighBits a = hb_range - 1 by smt().
    by smt().
  case: (t - 2 * gamma2 - 1 = - gamma2) => he.
  + by rewrite {1}/LowBits (Decompose_neg_gamma (a - cs2)) 1:-he //=; smt().
  rewrite {1}/LowBits (Decompose_unique 0 (t - 2 * gamma2 - 1) (a - cs2)) 1,2:/#.
  + by rewrite -hrep2; congr; ring.
  by smt().
case: (1 <= HighBits a) => hh.
- rewrite {1}/LowBits (Decompose_unique (HighBits a - 1) (t + 2 * gamma2) (a - cs2)) 1,2:/#.
  + by rewrite -hrep; congr; ring.
  by smt().
have hh0' : HighBits a = 0 by smt().
have hrep3 : incoeff (2 * gamma2 * (hb_range - 1) + (t + 2 * gamma2 + 1)) = a - cs2.
- rewrite -hrep hh0' -(incoeffDq (2 * gamma2 * 0 + t)); congr.
  have -> : 2 * gamma2 * (hb_range - 1) = q - 1 - 2 * gamma2 by rewrite -hM; ring.
  by ring.
case: (t = - gamma2) => he.
- by rewrite {1}/LowBits (Decompose_neg_gamma (a - cs2)) 1:-he 1:-hrep 1:hh0' //=; smt().
rewrite {1}/LowBits (Decompose_unique (hb_range - 1) (t + 2 * gamma2 + 1) (a - cs2)) 1,2:/# //.
by smt().
qed.

from Jasmin require import JUtils.

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

end DecomposeT.
