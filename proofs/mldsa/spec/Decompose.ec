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
(* The Decompose kit: uniqueness, representation, ranges                *)
(* (both parameter sets have gamma2 = (q-1)/32, i.e. 2 gamma2 * 16 = q-1)*)
(* -------------------------------------------------------------------- *)
lemma gamma2E : gamma2 = 261888.
proof. by have := param_sets; rewrite /=; smt(). qed.

lemma Beta_bnd : 0 <= Beta <= 196.
proof. by have := param_sets; rewrite /Beta /=; smt(). qed.

(* a pair (a, b) with 0 <= a < 16 and -gamma2 < b <= gamma2 representing r
   is Decompose r *)
lemma Decompose_unique (a b : int) (r : coeff) :
  0 <= a < 16 => -gamma2 < b <= gamma2 =>
  incoeff (2 * gamma2 * a + b) = r => Decompose r = (a, b).
proof.
rewrite gamma2E => ha hb <-; rewrite /Decompose /smodem gamma2E /= incoeffK.
case: (0 <= 523776 * a + b) => hx.
- rewrite (pmod_small _ q) 1:/#.
  have -> : (523776 * a + b) %% 523776 = b %% 523776 by rewrite mulzC modzMDl.
  case: (0 <= b) => hb0.
  + rewrite (pmod_small b) 1:/# (ifF (261888 < b)) 1:/# ifF 1:/# /=.
    by rewrite (addzK b) mulzC mulzK.
  have -> : b %% 523776 = b + 523776 by rewrite -(modzMDl 1) pmod_small /#.
  rewrite (ifT (261888 < b + 523776)) 1:/# /= ifF 1:/# /=.
  by rewrite (addzK b) mulzC mulzK.
have ->> : a = 0 by smt().
have -> : (523776 * 0 + b) %% q = b + q by rewrite /= -(modzMDl 1) pmod_small /#.
have hq : b + q = (b + 1) + 16 * 523776 by smt().
case: (b = -1) => [->> //|hb1].
have -> : (b + q) %% 523776 = b + 1 + 523776.
+ by rewrite hq modzMDr -(modzMDl 1) pmod_small /#.
by rewrite ifT 1:/# /= ifT 1:/#.
qed.

(* the corner case of Decompose: -gamma2 is (0, -gamma2) *)
lemma Decompose_neg_gamma (r : coeff) :
  incoeff (- gamma2) = r => Decompose r = (0, - gamma2).
proof. by rewrite gamma2E => <-; rewrite /Decompose /smodem gamma2E /= incoeffK. qed.

(* ranges of the pair, and r = 2 gamma2 HighBits r + LowBits r *)
lemma Decompose_cases (r : coeff) :
     0 <= HighBits r < 16 /\ -gamma2 <= LowBits r <= gamma2
  /\ incoeff (2 * gamma2 * HighBits r + LowBits r) = r.
proof.
rewrite /HighBits /LowBits /Decompose /smodem gamma2E /=.
have [rg0 rgq] := rg_asint r.
have hdq := divz_eq (asint r) 523776.
have [hx0 hxl] : 0 <= asint r %% 523776 < 523776 by smt(modz_ge0 ltz_pmod).
move: hdq hx0 hxl; move: (asint r %/ 523776) (asint r %% 523776) => k x hdq hx0 hxl.
case: (261888 < x) => hc /=.
- rewrite hdq (_ : k * 523776 + x - (x - 523776) = (k + 1) * 523776) 1:#ring mulzK //.
  rewrite !andbA; case: (k + 1 = 16) => hk16 /=.
  + by rewrite ifT 1:/# /=; split; [smt() | apply incoeffP; rewrite hdq /#].
  rewrite ifF 1:/# /=; split; first smt().
  by apply incoeffP; rewrite hdq pmod_small /#.
rewrite hdq (_ : k * 523776 + x - x = k * 523776) 1:#ring mulzK //.
rewrite !andbA; case: (k = 16) => hk16 /=.
+ by rewrite ifT 1:/# /=; split; [smt() | apply incoeffP; rewrite hdq /#].
rewrite ifF 1:/# /=; split; first smt().
by apply incoeffP; rewrite hdq pmod_small /#.
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
move=> hlow; have hg := gamma2E.
have [#] hh0 hh1 hl0 hl1 hr := Decompose_cases w.
(* HighBits (w - cs2) = HighBits w: cs2 does not cross a boundary *)
have hH : HighBits (w - cs2) = HighBits w.
- rewrite {1}/HighBits (Decompose_unique (HighBits w) (LowBits w - crepr cs2) (w - cs2)) 1,2:/# //.
  have -> : 2 * gamma2 * HighBits w + (LowBits w - crepr cs2) = (2 * gamma2 * HighBits w + LowBits w) - crepr cs2 by ring.
  by rewrite incoeffB hr creprK.
(* HighBits of a pure multiple of 2 gamma2 is the multiplier *)
have hM : HighBits (incoeff (HighBits w * 2 * gamma2)) = HighBits w.
- rewrite {1}/HighBits (Decompose_unique (HighBits w) 0 _) 1,2:/# //.
  by congr; ring.
rewrite /MakeHintImpl /MakeHint /= incoeffK (pmod_small _ q) 1:/#.
(* both second arguments are w - cs2 + ct0; the first ones shift to *)
(* 2 gamma2 HighBits w and to w - cs2, both of high bits HighBits w *)
have e2 : forall (x y : coeff), x + y + (Zq.zero - y) = x by move=> x y; ring.
rewrite (e2 (incoeff (HighBits w * 2 * gamma2))).
have e1 : incoeff (HighBits w * 2 * gamma2) + (incoeff (LowBits w) - cs2 + ct0) = w - cs2 + ct0.
- by rewrite -{3}hr (_ : 2 * gamma2 * HighBits w = HighBits w * 2 * gamma2) 1:#ring incoeffD; ring.
by rewrite e1 hM -hH; congr; congr; congr; ring.
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
have hg := gamma2E.
have -> : `|incoeff (LowBits a) - cs2| = `|t|.
- by rewrite -abs_incoeff 1:/# /t incoeffB creprK.
rewrite abs_incoeff 1:/#.
(* no boundary crossing: the low bits of a - cs2 are t *)
case: (-gamma2 < t <= gamma2) => [ht|ht].
- by rewrite {1}/LowBits (Decompose_unique (HighBits a) t (a - cs2)).
(* crossing: |t| >= gamma2, and the low bits of a - cs2 wrap by 2 gamma2 *)
suff hL : gamma2 - Beta <= `|LowBits (a - cs2)| by smt().
case: (gamma2 < t) => hgt.
- case: (HighBits a + 1 < 16) => hh.
  + rewrite {1}/LowBits (Decompose_unique (HighBits a + 1) (t - 2 * gamma2) (a - cs2)) 1,2:/#.
    * by rewrite -hrep; congr; ring.
    by smt().
  have hrep2 : incoeff (t - 2 * gamma2 - 1) = a - cs2.
  + by rewrite -hrep -incoeffDq; congr; smt().
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
have hrep3 : incoeff (2 * gamma2 * 15 + (t + 2 * gamma2 + 1)) = a - cs2.
- by rewrite -hrep hh0' -(incoeffDq (2 * gamma2 * 0 + t)); congr; smt().
case: (t = - gamma2) => he.
- by rewrite {1}/LowBits (Decompose_neg_gamma (a - cs2)) 1:-he 1:-hrep 1:hh0' //=; smt().
rewrite {1}/LowBits (Decompose_unique 15 (t + 2 * gamma2 + 1) (a - cs2)) 1,2:/# //.
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
