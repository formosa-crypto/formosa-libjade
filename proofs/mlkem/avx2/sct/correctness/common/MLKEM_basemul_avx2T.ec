(**
  The AVX2 base multiplication of ML-KEM (`_poly_basemul`,
  `_poly_basemul_acc`, `_poly_basemul_acc_red`).

  The code runs on 8 blocks of 32 coefficients.  Lane l of the two
  registers of block k holds the pair (32 k + l, 32 k + 16 + l), the
  two coefficients of a degree-1 polynomial.  The block multiplies two
  such pairs modulo X^2 - z (k even) or X^2 + z (k odd): a coefficient
  of the product is the sum of two Montgomery products (`sbx`, `sby`).
  The product is stored, added to the destination, or added to it and
  reduced (`fin`).
*)

require import AllCore List Int IntDiv StdOrder.
from Jasmin require import JModel_x86.
from JazzEC require import Array16 Array256 Array400 WArray32 WArray512 WArray800.
require import Montgomery16 MLKEMFCLib NttKem.
from Spec require import GFq Rq.
require import JkemConstants.
require BaseT MLKEM_ntt_levelsT MLKEM_ntt_avx2T.

abstract theory MLKEM_basemul_avx2T.

clone import BaseT.BaseT as B.
import R.
clone import MLKEM_ntt_levelsT.MLKEM_ntt_levelsT as MLKEM_ntt_levels with theory B <- B.
clone import MLKEM_ntt_avx2T.MLKEM_ntt_avx2T as MLKEM_ntt_avx2 with theory B <- B, theory MLKEM_ntt_levels <- MLKEM_ntt_levels.

(* ==================================================================== *)

(*---*) import IntOrder.

(*---*) import Zq.

(* ==================================================================== *)
(* Lanes                                                                *)
(* ==================================================================== *)
(* the Montgomery product of two words *)
op mp (x y : W16.t) : W16.t = mmr16 y (x * W16.of_int 62209, x).

(* the two coefficients of the product of (a + b X) and (c + d X),
   modulo X^2 - z for s = 0 and X^2 + z otherwise, z given by its table
   pair *)
op sbx (s : int) (a b c d : W16.t) (z : W16.t * W16.t) : W16.t =
  let dz = mmr16 d z in if s = 0 then mp a c + mp b dz else mp a c - mp b dz.

op sby (a b c d : W16.t) : W16.t = mp a d + mp b c.

(* a coefficient v of the product: stored (m = 0), added to w (m = 1),
   or added to w and reduced *)
op fin (m : int) (v w : W16.t) : W16.t =
  if m = 0 then v else if m = 1 then v + w else sbred16 (v + w).

(* ==================================================================== *)
(* The procedures                                                       *)
(* ==================================================================== *)
op [opaque] qinvx16v : W256.t = W16u16.pack16 (nseq 16 (W16.of_int 62209)).

lemma bits16_qinvx16v (l : int) : 0 <= l < 16 => qinvx16v \bits16 l = W16.of_int 62209.
proof. by move=> rgl; rewrite /qinvx16v pack16bE // W16u16.Pack.get_of_list // nth_nseq. qed.

lemma qinvx16vE : get256_direct (WArray32.init16 (fun i => jqinvx16.[i])) 0 = qinvx16v.
proof.
apply W16u16.wordP => l rgl; rewrite load32E // bits16_qinvx16v //.
by move: l rgl; apply/allP_range; rewrite -iotaredE.
qed.

op [opaque] sbxv (s : int) (a b c d zq z : W256.t) : W256.t =
  W16u16.pack16 (mkseq (fun l => sbx s (a \bits16 l) (b \bits16 l) (c \bits16 l)
                                       (d \bits16 l) (zq \bits16 l, z \bits16 l)) 16).

op [opaque] sbyv (a b c d : W256.t) : W256.t =
  W16u16.pack16 (mkseq (fun l =>
    sby (a \bits16 l) (b \bits16 l) (c \bits16 l) (d \bits16 l)) 16).

op [opaque] finv (m : int) (v w : W256.t) : W256.t =
  W16u16.pack16 (mkseq (fun l => fin m (v \bits16 l) (w \bits16 l)) 16).

lemma sbxvb (s : int) (a b c d zq z : W256.t) (l : int) : 0 <= l < 16 =>
  sbxv s a b c d zq z \bits16 l =
    sbx s (a \bits16 l) (b \bits16 l) (c \bits16 l) (d \bits16 l) (zq \bits16 l, z \bits16 l).
proof. by move=> rgl; rewrite /sbxv pack16bE // W16u16.Pack.get_of_list // nth_mkseq. qed.

lemma sbyvb (a b c d : W256.t) (l : int) : 0 <= l < 16 =>
  sbyv a b c d \bits16 l = sby (a \bits16 l) (b \bits16 l) (c \bits16 l) (d \bits16 l).
proof. by move=> rgl; rewrite /sbyv pack16bE // W16u16.Pack.get_of_list // nth_mkseq. qed.

lemma finvb (m : int) (v w : W256.t) (l : int) : 0 <= l < 16 =>
  finv m v w \bits16 l = fin m (v \bits16 l) (w \bits16 l).
proof. by move=> rgl; rewrite /finv pack16bE // W16u16.Pack.get_of_list // nth_mkseq. qed.

lemma finv0 (v w : W256.t) : v = finv 0 v w.
proof. by apply W16u16.wordP => l rgl; rewrite finvb. qed.

lemma finv1 (v w : W256.t) : VPADD_16u16 v w = finv 1 v w.
proof. by apply W16u16.wordP => l rgl; rewrite finvb // /VPADD_16u16 map2bE. qed.

lemma finv2 (v w : W256.t) : redl (finv 1 v w) = finv 2 v w.
proof.
apply W16u16.wordP => l rgl; rewrite !finvb // /redl pack16bE //.
by rewrite W16u16.Pack.get_of_list // nth_mkseq //= finvb.
qed.

hoare basemul16x_h (a b c d z zq : W256.t) (s : int) :
  M.__basemul16x : arg = (a, b, c, d, z, zq, qx16v, qinvx16v, s) ==>
    res = (sbxv s a b c d zq z, sbyv a b c d).
proof.
proc; seq 1 : (#pre /\ dz = scl d zq z).
- by ecall (fqmulprecomp16x_h d zetaqinv zeta_0); auto.
auto => />; split=> [|hs]; split; apply W16u16.wordP => l rgl;
  rewrite ?sbxvb ?sbyvb // /sbx /sby /mp /mmr16 /= ?hs /=;
  rewrite /VPADD_16u16 /VPSUB_16u16 /VPMULH_16u16 /VPMULL_16u16 !map2bE //=;
  by rewrite ?sclb // !bits16_qx16v // !bits16_qinvx16v.
qed.

(* -------------------------------------------------------------------- *)
(* the zeta table offset of block k *)
op zof (k : int) : int = 136 + 196 * (k %/ 4) + 32 * (k %/ 2 %% 2).

(* the product: lane l of the two registers of block k, from its pairs *)
op bmres (a b : wpoly) : wpoly = Array256.init (fun i =>
  let k = i %/ 32 in let l = i %% 16 in let re = 32 * k + l in
  if i %% 32 < 16
  then sbx (k %% 2) a.[re] a.[re + 16] b.[re] b.[re + 16] (zt (zof k + l), zt (zof k + 16 + l))
  else sby a.[re] a.[re + 16] b.[re] b.[re + 16]).

(* the result in mode m, for the destination r *)
op bmacc (m : int) (r a b : wpoly) : wpoly =
  Array256.init (fun i => fin m (bmres a b).[i] r.[i]).

(* the first k blocks of r are those of the result, the others those of
   the destination r0 *)
op binv (k m : int) (r0 a b r : wpoly) =
  forall j, 0 <= j < 256 => r.[j] = if j < 32 * k then (bmacc m r0 a b).[j] else r0.[j].

lemma zvb (o l : int) : 0 <= o => o + 32 <= 800 => 2 %| o => 0 <= l < 16 =>
  zv o \bits16 l = zt (o %/ 2 + l).
proof. by move=> *; rewrite zvE // pack16bE // W16u16.Pack.get_of_list // nth_mkseq. qed.

lemma bm_step (r0 r a b : wpoly) (k m : int) (zq z : W256.t) :
  0 <= k < 8 =>
  (forall l, 0 <= l < 16 => zq \bits16 l = zt (zof k + l) /\ z \bits16 l = zt (zof k + 16 + l)) =>
  binv k m r0 a b r =>
  binv (k + 1) m r0 a b
    (st (st r (2 * k)
           (finv m (sbxv (k %% 2) (ld a (2 * k)) (ld a (2 * k + 1)) (ld b (2 * k))
                      (ld b (2 * k + 1)) zq z) (ld r (2 * k))))
        (2 * k + 1)
        (finv m (sbyv (ld a (2 * k)) (ld a (2 * k + 1)) (ld b (2 * k)) (ld b (2 * k + 1)))
           (ld r (2 * k + 1)))).
proof.
move=> rgk hz hinv j rgj; rewrite /st !initiE 1,2:/# /=.
case: (16 * (2 * k + 1) <= j < 16 * (2 * k + 1) + 16) => h1.
- rewrite finvb 1:/# sbyvb 1:/# ifT 1:/# /bmres initiE 1:/# /= ifF 1:/#.
  have [-> ->] : j %/ 32 = k /\ j %% 16 = j - 32 * k - 16 by smt().
  rewrite !ldE 1..10:/# (hinv (16 * (2 * k + 1) + (j - 16 * (2 * k + 1)))) 1:/# ifF 1:/#.
  by smt().
rewrite initiE 1:/# /=; case: (16 * (2 * k) <= j < 16 * (2 * k) + 16) => h0.
- rewrite finvb 1:/# sbxvb 1:/# ifT 1:/# /bmres initiE 1:/# /= ifT 1:/#.
  have [-> ->] : j %/ 32 = k /\ j %% 16 = j - 32 * k by smt().
  rewrite !ldE 1..10:/# !(hz (j - 16 * (2 * k))) 1,2:/#.
  rewrite (hinv (16 * (2 * k) + (j - 16 * (2 * k)))) 1:/# ifF 1:/#.
  by smt().
by rewrite hinv 1:/# /bmacc initiE 1:/# /=; smt().
qed.

(* the lanes of the zeta registers of block k, loaded at offsets o and o' *)
lemma zlanes (k o o' : int) : 0 <= k < 8 => o = 2 * zof k => o' = o + 32 =>
  forall l, 0 <= l < 16 => zv o \bits16 l = zt (zof k + l) /\ zv o' \bits16 l = zt (zof k + 16 + l).
proof.
move=> rgk -> -> l rgl; have hz : 136 <= zof k <= 364 by rewrite /zof; smt().
by rewrite !zvb 1..8:/#; smt().
qed.

lemma binv0 (m : int) (r a b : wpoly) : binv 0 m r a b r.
proof. by move=> j rgj; rewrite ifF 1:/#. qed.

lemma binv8 (m : int) (r0 a b r : wpoly) : binv 8 m r0 a b r => r = bmacc m r0 a b.
proof. by move=> h; apply Array256.ext_eq => j rgj; rewrite h // ifT 1:/#. qed.

lemma zvF (o : int) : get256_direct (WArray800.init16 (fun i => jzetas_exp.[i])) o = zv o.
proof. by rewrite /zv. qed.

hoare poly_basemul_body_h (_r _a _b : wpoly) (m : int) :
  M.__poly_basemul_body : rp = _r /\ ap = _a /\ bp = _b /\ acc = m /\ 0 <= m <= 2 ==>
    res = bmacc m _r _a _b.
proof.
proc.
while (ap = _a /\ bp = _b /\ acc = m /\ 0 <= m <= 2 /\ qx16 = qx16v /\ qinvx16 = qinvx16v
       /\ (m = 2 => vx16 = vx16v) /\ 0 <= i <= 8 /\ binv i m _r _a _b rp); last first.
- auto => />; rewrite qx16vE qinvx16vE vx16vE /=.
  have h : forall n, binv 0 n _r _a _b _r /\
      forall (i0 : int) (rp0 : wpoly), ! i0 < 8 => 0 <= i0 => i0 <= 8 =>
        binv i0 n _r _a _b rp0 => rp0 = bmacc n _r _a _b.
  + move=> n; split; first by apply binv0.
    by move=> i0 r0 ge8 _ le8 hb; apply binv8; have <- : i0 = 8 by smt().
  by move=> _ _; split=> _; apply h.
(* the product of block i *)
seq 8 : (#pre /\ exists zq z,
           (forall l, 0 <= l < 16 =>
              zq \bits16 l = zt (zof i + l) /\ z \bits16 l = zt (zof i + 16 + l))
           /\ r = sbxv (i %% 2) (ld _a (2 * i)) (ld _a (2 * i + 1)) (ld _b (2 * i))
                    (ld _b (2 * i + 1)) zq z
           /\ s = sbyv (ld _a (2 * i)) (ld _a (2 * i + 1)) (ld _b (2 * i)) (ld _b (2 * i + 1))).
- ecall (basemul16x_h a b c d zeta_0 zetaqinv (i %% 2)); auto => /> &hr *.
  rewrite !zvF; exists (zv (272 + 392 * (i{hr} %/ 4) + 64 * (i{hr} %/ 2 %% 2)))
    (zv (272 + 392 * (i{hr} %/ 4) + 64 * (i{hr} %/ 2 %% 2) + 32)).
  by rewrite /ld /=; apply (zlanes i{hr}) => //; rewrite /zof /#.
elim* => zq z.
(* the accumulation *)
seq 1 : (ap = _a /\ bp = _b /\ acc = m /\ 0 <= m <= 2 /\ qx16 = qx16v /\ qinvx16 = qinvx16v
         /\ (m = 2 => vx16 = vx16v) /\ 0 <= i < 8 /\ binv i m _r _a _b rp
         /\ (forall l, 0 <= l < 16 =>
               zq \bits16 l = zt (zof i + l) /\ z \bits16 l = zt (zof i + 16 + l))
         /\ r = finv (min m 1) (sbxv (i %% 2) (ld _a (2 * i)) (ld _a (2 * i + 1)) (ld _b (2 * i))
                                  (ld _b (2 * i + 1)) zq z) (ld rp (2 * i))
         /\ s = finv (min m 1) (sbyv (ld _a (2 * i)) (ld _a (2 * i + 1)) (ld _b (2 * i))
                                  (ld _b (2 * i + 1))) (ld rp (2 * i + 1))).
- if; auto => /> &hr *.
  + by rewrite (: min m 1 = 1) 1:/# !finv1 /ld.
  by split; apply finv0.
(* the reduction *)
seq 1 : (ap = _a /\ bp = _b /\ acc = m /\ 0 <= m <= 2 /\ qx16 = qx16v /\ qinvx16 = qinvx16v
         /\ (m = 2 => vx16 = vx16v) /\ 0 <= i < 8 /\ binv i m _r _a _b rp
         /\ (forall l, 0 <= l < 16 =>
               zq \bits16 l = zt (zof i + l) /\ z \bits16 l = zt (zof i + 16 + l))
         /\ r = finv m (sbxv (i %% 2) (ld _a (2 * i)) (ld _a (2 * i + 1)) (ld _b (2 * i))
                          (ld _b (2 * i + 1)) zq z) (ld rp (2 * i))
         /\ s = finv m (sbyv (ld _a (2 * i)) (ld _a (2 * i + 1)) (ld _b (2 * i))
                          (ld _b (2 * i + 1))) (ld rp (2 * i + 1))).
- if; last by auto => /> &hr *; rewrite (: min m 1 = m) 1:/#.
  by ecall (red16x_h s); ecall (red16x_h r); auto => /> &hr *; rewrite !finv2.
auto => /> &hr *; rewrite !stE 1,2:/#; split; first smt().
by apply bm_step.
qed.

hoare poly_basemul_h (_a _b : wpoly) :
  M._poly_basemul : ap = _a /\ bp = _b ==> res = bmres _a _b.
proof.
proc; ecall (poly_basemul_body_h rp _a _b 0); auto => /> &hr.
by apply Array256.ext_eq => j rgj; rewrite /bmacc initiE.
qed.

hoare poly_basemul_acc_h (_r _a _b : wpoly) :
  M._poly_basemul_acc : rp = _r /\ ap = _a /\ bp = _b ==> res = bmacc 1 _r _a _b.
proof. by proc; ecall (poly_basemul_body_h _r _a _b 1); auto. qed.

hoare poly_basemul_acc_red_h (_r _a _b : wpoly) :
  M._poly_basemul_acc_red : rp = _r /\ ap = _a /\ bp = _b ==> res = bmacc 2 _r _a _b.
proof. by proc; ecall (poly_basemul_body_h _r _a _b 2); auto. qed.

(* ==================================================================== *)
(* Values                                                               *)
(* ==================================================================== *)
lemma cgrE (x y : int) : x %% 3329 = y %% 3329 => incoeff x = incoeff y.
proof. by move=> h; apply/eq_incoeff; rewrite /coeffcgr qE. qed.

lemma absM_le (x y m n : int) : `|x| <= m => `|y| <= n => `|x * y| <= m * n.
proof. by move=> hx hy; rewrite normrM ler_pmul // normr_ge0. qed.

(* the Montgomery product of two words of magnitude at most 2 q *)
lemma mpP (x y : W16.t) :
  `|W16.to_sint x| <= 2 * 3329 => `|W16.to_sint y| <= 2 * 3329 =>
     incoeff (W16.to_sint (mp x y))
       = incoeff (W16.to_sint x) * incoeff (W16.to_sint y) * incoeff 169
  /\ `|W16.to_sint (mp x y)| <= 2341.
proof.
move=> hx hy.
have e : mp x y = Montgomery16.REDC16 (x * y) (wmulhs x y).
- rewrite /mp /mmr16 /Montgomery16.REDC16 /= /Montgomery16.qinv /Montgomery16.q.
  by congr; congr; congr; ring.
have hp := absM_le _ _ _ _ hx hy.
have hh : -677 <= W16.to_sint (wmulhs x y) <= 676 by rewrite to_sint_wmulhs /#.
have := Montgomery16.REDC16_correct (-677) 676 (x * y) (wmulhs x y) _ _ hh => //.
rewrite -wmulsE /Montgomery16.q /Montgomery16.Rinv -e => -[hc hr].
split; last by move: hr; rewrite /sint_bnd /#.
by rewrite (cgrE _ _ hc) !incoeffM.
qed.

lemma sbxP (s : int) (a b c d : W16.t) (x : int) :
  `|W16.to_sint a| <= 2 * 3329 => `|W16.to_sint b| <= 2 * 3329 =>
  `|W16.to_sint c| <= 2 * 3329 => `|W16.to_sint d| <= 2 * 3329 =>
     incoeff (W16.to_sint (sbx s a b c d (tw16 x)))
       = (incoeff (W16.to_sint a) * incoeff (W16.to_sint c)
          + (if s = 0 then incoeff x else - incoeff x)
            * incoeff (W16.to_sint b) * incoeff (W16.to_sint d)) * incoeff 169
  /\ `|W16.to_sint (sbx s a b c d (tw16 x))| < 2 * 3329.
proof.
move=> ha hb hc hd; have [zc zb] := mmr16_correct d x.
pose dz := mmr16 d (tw16 x).
have [e1 b1] := mpP a c ha hc.
have [e2 b2] := mpP b dz hb _; first smt().
have ez : incoeff (W16.to_sint dz) = incoeff (W16.to_sint d) * incoeff x.
- by rewrite (cgrE _ _ zc) incoeffM.
rewrite /sbx /= -/dz; case: (s = 0) => _.
- by rewrite to_sintD_small 1:/# incoeffD e1 e2 ez; split; [ring | smt()].
by rewrite to_sintB_small 1:/# incoeffB e1 e2 ez; split; [ring | smt()].
qed.

lemma sbyP (a b c d : W16.t) :
  `|W16.to_sint a| <= 2 * 3329 => `|W16.to_sint b| <= 2 * 3329 =>
  `|W16.to_sint c| <= 2 * 3329 => `|W16.to_sint d| <= 2 * 3329 =>
     incoeff (W16.to_sint (sby a b c d))
       = (incoeff (W16.to_sint a) * incoeff (W16.to_sint d)
          + incoeff (W16.to_sint b) * incoeff (W16.to_sint c)) * incoeff 169
  /\ `|W16.to_sint (sby a b c d)| < 2 * 3329.
proof.
move=> ha hb hc hd; have [e1 b1] := mpP a d ha hd; have [e2 b2] := mpP b c hb hc.
by rewrite /sby to_sintD_small 1:/# incoeffD e1 e2; split; [ring | smt()].
qed.

(* the accumulation of a coefficient v of the product on w, of magnitude
   at most c q: it does not wrap, and the reduction lands in [0, 2q) *)
lemma fin1P (c : int) (v w : W16.t) : 0 <= c <= 7 =>
  `|W16.to_sint v| < 2 * 3329 => - c * 3329 <= W16.to_sint w < c * 3329 =>
     incoeff (W16.to_sint (fin 1 v w)) = incoeff (W16.to_sint v) + incoeff (W16.to_sint w)
  /\ - (c + 2) * 3329 <= W16.to_sint (fin 1 v w) < (c + 2) * 3329.
proof. by move=> hc hv hw; rewrite /fin /= to_sintD_small 1:/# incoeffD /#. qed.

lemma fin2P (c : int) (v w : W16.t) : 0 <= c <= 7 =>
  `|W16.to_sint v| < 2 * 3329 => - c * 3329 <= W16.to_sint w < c * 3329 =>
     incoeff (W16.to_sint (fin 2 v w)) = incoeff (W16.to_sint v) + incoeff (W16.to_sint w)
  /\ 0 <= W16.to_sint (fin 2 v w) < 2 * 3329.
proof.
move=> hc hv hw; have [e r] := sbred16P (v + w).
by rewrite /fin /= (cgrE _ _ e) to_sintD_small 1:/# incoeffD.
qed.

(* -------------------------------------------------------------------- *)
op sg (s : int) : int = if s = 0 then 1 else -1.

(* the pair of block k, lane l, in the order of the specification       *)
op bmi (k l : int) : int = 64 * (k %/ 4) + 4 * l + k %% 4.

lemma ztvE (k l : int) : 0 <= k < 8 => 0 <= l < 16 =>
    (zt (zof k + l), zt (zof k + 16 + l))
  = (zv (2 * zof k) \bits16 l, zv (2 * zof k + 32) \bits16 l).
proof.
move=> rgk rgl; have hz : 136 <= zof k <= 364 by rewrite /zof; smt().
by rewrite !zvb 1..8:/# mulKz // (: (2 * zof k + 32) %/ 2 = zof k + 16) 1:/#.
qed.

(* the table holds the factor of the pair, up to the sign of the block *)
lemma ztabE (k l : int) : 0 <= k < 8 => 0 <= l < 16 =>
  (zt (zof k + l), zt (zof k + 16 + l)) = tw16 (sg (k %% 2) * zpw (2 * bitrev (bmi k l) + 1)).
proof.
move=> rgk rgl; rewrite ztvE //; move: l rgl; rewrite allP_range; move: k rgk.
rewrite allP_range -!iotaredE /zof /= !zvL; 1..24: done.
rewrite Array400.of_listK; first done.
by rewrite /=; with hint +listred (cbv delta).
qed.

(* ==================================================================== *)
(* The link with the specification                                      *)
(* ==================================================================== *)
(* the coefficients of the pairs are those of A and B, in the order of
   the specification; the product is the base multiplication, times the
   inverse Montgomery factor 169 = 2^-16 mod q *)
lemma bmres_val (a b : wpoly) (A B : poly) :
  (forall i, 0 <= i < 256 =>
     `|W16.to_sint a.[i]| <= 2 * 3329 /\ `|W16.to_sint b.[i]| <= 2 * 3329) =>
  (forall k l t, 0 <= k < 8 => 0 <= l < 16 => 0 <= t < 2 =>
        A.[2 * bmi k l + t] = incoeff (W16.to_sint a.[32 * k + l + 16 * t])
     /\ B.[2 * bmi k l + t] = incoeff (W16.to_sint b.[32 * k + l + 16 * t])) =>
  forall k l t, 0 <= k < 8 => 0 <= l < 16 => 0 <= t < 2 =>
       incoeff (W16.to_sint (bmres a b).[32 * k + l + 16 * t])
         = (basemul A B).[2 * bmi k l + t] * incoeff 169
    /\ `|W16.to_sint (bmres a b).[32 * k + l + 16 * t]| < 2 * 3329.
proof.
move=> hb hab k l t rgk rgl rgt; have rgi : 0 <= bmi k l < 128 by rewrite /bmi; smt().
have [ek el] : (32 * k + l + 16 * t) %/ 32 = k /\ (32 * k + l + 16 * t) %% 16 = l by smt().
have [ha0 hb0] := hb (32 * k + l) _; first smt().
have [ha1 hb1] := hb (32 * k + l + 16) _; first smt().
have /= [eA0 eB0] := hab k l 0 _ _ _ => //.
have /= [eA1 eB1] := hab k l 1 _ _ _ => //.
have ez : ZqRing.exp zroot (2 * br (bmi k l) + 1) = incoeff (zpw (2 * bitrev (bmi k l) + 1)).
- by rewrite incoeff_zpw ?bitrev_br //; smt(bitrev_rg).
rewrite /bmres /basemul !initiE 1,2:/# /= ek el.
have [-> ->] : (2 * bmi k l + t) %/ 2 = bmi k l /\ (2 * bmi k l + t) %% 2 = t by smt().
case: (t = 0) => [->> | ne0t] /=.
- rewrite ifT 1:/# ztabE // /cmplx_mul /= eA0 eA1 eB0 eB1 ez.
  have [-> bnd] := sbxP (k %% 2)
    a.[32 * k + l] a.[32 * k + l + 16] b.[32 * k + l] b.[32 * k + l + 16]
    (sg (k %% 2) * zpw (2 * bitrev (bmi k l) + 1)) _ _ _ _; 1..4: smt().
  split=> //; rewrite /sg; case: (k %% 2 = 0) => _ /=; first by ring.
  by rewrite mulN1r incoeffN; ring.
have ->> : t = 1 by smt().
rewrite ifF 1:/# /cmplx_mul /= eA0 eA1 eB0 eB1.
have [-> bnd] := sbyP a.[32 * k + l] a.[32 * k + l + 16] b.[32 * k + l] b.[32 * k + l + 16]
  _ _ _ _; 1..4: smt().
by split=> //; ring.
qed.

end MLKEM_basemul_avx2T.
