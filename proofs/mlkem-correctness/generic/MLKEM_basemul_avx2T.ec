(**
  The AVX2 base multiplication of ML-KEM (`_poly_basemul`).

  The code runs on 8 blocks of 32 coefficients.  Lane l of the two
  registers of block k holds the pair (32 k + l, 32 k + 16 + l), the
  two coefficients of a degree-1 polynomial.  The block multiplies two
  such pairs modulo X^2 - z (k even) or X^2 + z (k odd), followed by a
  Montgomery reduction (`sbx`, `sby`).
*)

require import AllCore List Int IntDiv StdOrder.
from Jasmin require import JModel.
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
(* the signed 32-bit product, as its low and high halves *)
op wm (x y : W16.t) : W32.t = W2u16.pack2 [x * y; wmulhs x y].

(* the Montgomery reduction of a 32-bit value *)
op mred (v : W32.t) : W16.t = Montgomery16.REDC16 (v \bits16 0) (v \bits16 1).

(* the two halves of the product of (a + b X) and (c + d X), modulo
   X^2 - z for s = 0 and X^2 + z otherwise, z given by its table pair *)
op sbx (s : int) (a b c d : W16.t) (z : W16.t * W16.t) : W16.t =
  let zb = mmr16 b z in mred (if s = 0 then wm a c + wm zb d else wm a c - wm zb d).

op sby (a b c d : W16.t) : W16.t = mred (wm b c + wm a d).

(* the 32-bit lane l of a value split over two registers, in the order
   of the interleaving instructions *)
op w32at (x0 x1 : W256.t) (l : int) : W32.t =
  (if l %% 8 < 4 then x0 else x1) \bits32 (4 * (l %/ 8) + l %% 4).

lemma ilvE (x y : W256.t) (l : int) : 0 <= l < 16 =>
  w32at (VPUNPCKL_16u16 x y) (VPUNPCKH_16u16 x y) l = W2u16.pack2 [x \bits16 l; y \bits16 l].
proof.
move: l; rewrite allP_range -iotaredE /w32at /= => />.
qed.

lemma vaddE (a0 a1 b0 b1 : W256.t) (l : int) : 0 <= l < 16 =>
  w32at (VPADD_8u32 a0 b0) (VPADD_8u32 a1 b1) l = w32at a0 a1 l + w32at b0 b1 l.
proof. by move=> rgl; rewrite /w32at; case: (l %% 8 < 4) => _; rewrite W8u32.map2bE 1:/#. qed.

lemma vsubE (a0 a1 b0 b1 : W256.t) (l : int) : 0 <= l < 16 =>
  w32at (VPSUB_8u32 a0 b0) (VPSUB_8u32 a1 b1) l = w32at a0 a1 l - w32at b0 b1 l.
proof. by move=> rgl; rewrite /w32at; case: (l %% 8 < 4) => _; rewrite W8u32.map2bE 1:/#. qed.

(* the unsigned saturation is the identity on lanes with a zero high half *)
lemma packusE (w : W128.t) (k : int) : 0 <= k < 4 =>
  packus_4u32 w \bits16 k =
    if (w \bits32 k) \slt W32.zero then W16.zero
    else if W32.of_int W16.max_uint \sle (w \bits32 k) then W16.of_int W16.max_uint
    else w \bits16 (2 * k).
proof. by move: k; rewrite allP_range -iotaredE /packus_4u32. qed.

lemma packus0 (w : W128.t) (k : int) : 0 <= k < 4 =>
  w \bits16 (2 * k + 1) = W16.zero => packus_4u32 w \bits16 k = w \bits16 (2 * k).
proof.
move=> rgk h0; rewrite packusE //.
have hv : W32.to_sint (w \bits32 k) = W16.to_uint (w \bits16 (2 * k)).
- by rewrite to_sint32_bits16 !W128_bits32_bits16 //= h0 W16.to_sintE /smod.
have /= hb := W16.to_uint_cmp (w \bits16 (2 * k)).
rewrite /(\slt) /(\sle) hv /= !W32.to_sintE /smod /= ifF 1:/#.
case: (W16.to_uint (w \bits16 (2 * k)) = 65535) => [e | ne]; last by rewrite ifF 1:/#.
by rewrite ifT 1:/# -e W16.to_uintK.
qed.

lemma packus8E (a b : W256.t) (l : int) : 0 <= l < 16 =>
  (forall j, 0 <= j < 8 => a \bits16 (2 * j + 1) = W16.zero /\ b \bits16 (2 * j + 1) = W16.zero) =>
  VPACKUS_8u32 a b \bits16 l = w32at a b l \bits16 0.
proof.
move=> rgl; rewrite allP_range -iotaredE /= => |> *.
move: l rgl; rewrite allP_range -iotaredE /w32at /VPACKUS_8u32 /VPACKUS_4u32 /=.
by rewrite !packus0 //=.
qed.

lemma blendE (x : W256.t) (l : int) : 0 <= l < 16 =>
     VPBLEND_16u16 x W256.zero (W8.of_int 170) \bits16 l
   = if l %% 2 = 0 then x \bits16 l else W16.zero.
proof. by move: l; rewrite allP_range -iotaredE /VPBLENDW_256 /VPBLENDW_128 /=. qed.

lemma shr16H (w : W32.t) : (w `>>>` 16) \bits16 1 = W16.zero.
proof. by apply W16.all_eq_eq; rewrite /all_eq /(`>>>`) /=. qed.

lemma srlE (x : W256.t) (l : int) : 0 <= l < 16 =>
  VPSRL_8u32 x (W128.of_int 16) \bits16 l = if l %% 2 = 0 then x \bits16 (l + 1) else W16.zero.
proof.
by move: l; rewrite allP_range -iotaredE /VPSRL_8u32 /= !bits32_shr16_bits16L //= !shr16H.
qed.

lemma w32atE (x0 x1 : W256.t) (l t : int) : 0 <= l < 16 => 0 <= t < 2 =>
     w32at x0 x1 l \bits16 t
   = (if l %% 8 < 4 then x0 else x1) \bits16 (8 * (l %/ 8) + 2 * (l %% 4) + t).
proof.
move=> rgl rgt; rewrite /w32at; case: (l %% 8 < 4) => _;
  rewrite W256_bits32_bits16 //; congr; ring.
qed.

lemma dloE (x0 x1 : W256.t) (l : int) : 0 <= l < 16 =>
     VPACKUS_8u32 (VPBLEND_16u16 x0 W256.zero (W8.of_int 170))
                  (VPBLEND_16u16 x1 W256.zero (W8.of_int 170)) \bits16 l
   = w32at x0 x1 l \bits16 0.
proof.
move=> rgl; rewrite packus8E //; first by move=> j rgj; rewrite !blendE /#.
by rewrite !w32atE //; case: (l %% 8 < 4) => _; rewrite blendE 1:/# ifT /#.
qed.

lemma dhiE (x0 x1 : W256.t) (l : int) : 0 <= l < 16 =>
     VPACKUS_8u32 (VPSRL_8u32 x0 (W128.of_int 16)) (VPSRL_8u32 x1 (W128.of_int 16)) \bits16 l
   = w32at x0 x1 l \bits16 1.
proof.
move=> rgl; rewrite packus8E //; first by move=> j rgj; rewrite !srlE /#.
by rewrite !w32atE //; case: (l %% 8 < 4) => _; rewrite srlE 1:/# ifT /#.
qed.

(* ==================================================================== *)
(* The procedures                                                       *)
(* ==================================================================== *)
op [opaque] qinvx16v : W256.t = W16u16.pack16 (nseq 16 (W16.of_int 62209)).

lemma qinvx16vE : get256_direct (WArray32.init16 (fun i => jqinvx16.[i])) 0 = qinvx16v.
proof.
apply W16u16.wordP => l rgl; rewrite load32E // /qinvx16v pack16bE //.
rewrite W16u16.Pack.get_of_list // nth_nseq //.
by move: l rgl; apply/allP_range; rewrite -iotaredE.
qed.

hoare wmul_h (x y : W256.t) :
  M.__wmul_16u16 : arg = (x, y) ==>
    forall l, 0 <= l < 16 => w32at res.`1 res.`2 l = wm (x \bits16 l) (y \bits16 l).
proof.
proc; inline *; auto => /> l h0 h1.
by rewrite ilvE 1:/# /wm /VPMULL_16u16 /VPMULH_16u16 !map2bE.
qed.

hoare dil_h (x0 x1 : W256.t) :
  M.__w256_deinterleave_u16 : arg = (W256.zero, x0, x1) ==>
    forall l, 0 <= l < 16 =>
      res.`1 \bits16 l = w32at x0 x1 l \bits16 0 /\ res.`2 \bits16 l = w32at x0 x1 l \bits16 1.
proof. by proc; auto => /> l h0 h1; rewrite dloE 1:/# dhiE 1:/#. qed.

hoare mred_h (lo hi : W256.t) :
  M.__mont_red : arg = (lo, hi, qx16v, qinvx16v) ==>
    forall l, 0 <= l < 16 => res \bits16 l = mred (W2u16.pack2 [lo \bits16 l; hi \bits16 l]).
proof.
proc; auto => /> l h0 h1; have rgl : 0 <= l < 16 by done.
rewrite /mred /Montgomery16.REDC16 /VPSUB_16u16 /VPMULH_16u16 /VPMULL_16u16 !map2bE //=.
by rewrite bits16_qx16v // /qinvx16v pack16bE // W16u16.Pack.get_of_list // nth_nseq.
qed.

op [opaque] sbxv (s : int) (are aim bre bim zq z : W256.t) : W256.t =
  W16u16.pack16 (mkseq (fun l => sbx s (are \bits16 l) (aim \bits16 l) (bre \bits16 l)
                                       (bim \bits16 l) (zq \bits16 l, z \bits16 l)) 16).

op [opaque] sbyv (are aim bre bim : W256.t) : W256.t =
  W16u16.pack16 (mkseq (fun l =>
    sby (are \bits16 l) (aim \bits16 l) (bre \bits16 l) (bim \bits16 l)) 16).

lemma sbxvb (s : int) (are aim bre bim zq z : W256.t) (l : int) : 0 <= l < 16 =>
  sbxv s are aim bre bim zq z \bits16 l =
    sbx s (are \bits16 l) (aim \bits16 l) (bre \bits16 l) (bim \bits16 l)
      (zq \bits16 l, z \bits16 l).
proof. by move=> rgl; rewrite /sbxv pack16bE // W16u16.Pack.get_of_list // nth_mkseq. qed.

lemma sbyvb (are aim bre bim : W256.t) (l : int) : 0 <= l < 16 =>
  sbyv are aim bre bim \bits16 l =
    sby (are \bits16 l) (aim \bits16 l) (bre \bits16 l) (bim \bits16 l).
proof. by move=> rgl; rewrite /sbyv pack16bE // W16u16.Pack.get_of_list // nth_mkseq. qed.

(* a reduced lane, from the deinterleaving and the reduction *)
lemma redlane (x0 x1 r : W256.t) (d : W256.t * W256.t) (l : int) : 0 <= l < 16 =>
     (d.`1 \bits16 l = w32at x0 x1 l \bits16 0 /\ d.`2 \bits16 l = w32at x0 x1 l \bits16 1)
  => r \bits16 l = mred (W2u16.pack2 [d.`1 \bits16 l; d.`2 \bits16 l])
  => r \bits16 l = mred (w32at x0 x1 l).
proof. by move=> rgl [-> ->] ->; rewrite -W32_unpack16E. qed.

hoare schoolbook_h (are aim bre bim z zq : W256.t) (s : int) :
  M.__schoolbook16x : arg = (are, aim, bre, bim, z, zq, qx16v, qinvx16v, s) ==>
    res = (sbxv s are aim bre bim zq z, sbyv are aim bre bim).
proof.
proc.
ecall (mred_h y0 y1); ecall (mred_h x0 x1); ecall (dil_h y0 y1); ecall (dil_h x0 x1).
wp; ecall (wmul_h zaim bim); ecall (wmul_h aim bre); ecall (wmul_h are bim).
ecall (wmul_h are bre); ecall (fqmulprecomp16x_h aim zq z).
auto => />.
move=> [ac0 ac1] /= hac [ad0 ad1] /= had [bc0 bc1] /= hbc [zb0 zb1] /= hzb.
split=> [|hs]; move=> [x0 x1] hx [y0 y1] hy rx hrx ry hry; split;
  apply W16u16.wordP => l rgl.
- rewrite (redlane _ _ _ _ _ rgl (hx l rgl) (hrx l rgl)) vaddE // hac // hzb //.
  by rewrite sbxvb // sclb.
- rewrite (redlane _ _ _ _ _ rgl (hy l rgl) (hry l rgl)) vaddE // hbc // had //.
  by rewrite sbyvb.
- rewrite (redlane _ _ _ _ _ rgl (hx l rgl) (hrx l rgl)) vsubE // hac // hzb //.
  by rewrite sbxvb // sclb // /sbx /= hs.
rewrite (redlane _ _ _ _ _ rgl (hy l rgl) (hry l rgl)) vaddE // hbc // had //.
by rewrite sbyvb.
qed.

(* -------------------------------------------------------------------- *)
(* the zeta table offset of block k *)
op zo (k : int) : int = nth 0 [136; 168; 332; 364] (k %/ 2).

(* the result: lane l of the two registers of block k, from its pairs *)
op bmres (a b : wpoly) : wpoly = Array256.init (fun i =>
  let k = i %/ 32 in let l = i %% 16 in let re = 32 * k + l in
  if i %% 32 < 16
  then sbx (k %% 2) a.[re] a.[re + 16] b.[re] b.[re + 16] (zt (zo k + l), zt (zo k + 16 + l))
  else sby a.[re] a.[re + 16] b.[re] b.[re + 16]).

(* the first k blocks of r are those of the result *)
op binv (k : int) (a b r : wpoly) = forall j, 0 <= j < 32 * k => r.[j] = (bmres a b).[j].

lemma ldoE (p : wpoly) (o : int) : 0 <= o < 512 => 32 %| o =>
  get256_direct (WArray512.init16 (fun i => p.[i])) o = ld p (o %/ 32).
proof. by move=> rgo ho; rewrite /ld mulrC divzK. qed.

lemma zvb (o l : int) : 0 <= o => o + 32 <= 800 => 2 %| o => 0 <= l < 16 =>
  zv o \bits16 l = zt (o %/ 2 + l).
proof. by move=> *; rewrite zvE // pack16bE // W16u16.Pack.get_of_list // nth_mkseq. qed.

lemma bm_step (r a b : wpoly) (k k' s m0 m1 : int) (zq z : W256.t) :
  0 <= k < 8 => k' = k + 1 => s = k %% 2 => m0 = 2 * k => m1 = 2 * k + 1 =>
  (forall l, 0 <= l < 16 => zq \bits16 l = zt (zo k + l) /\ z \bits16 l = zt (zo k + 16 + l)) =>
  binv k a b r =>
  binv k' a b (st (st r m0 (sbxv s (ld a m0) (ld a m1) (ld b m0) (ld b m1) zq z))
                  m1 (sbyv (ld a m0) (ld a m1) (ld b m0) (ld b m1))).
proof.
move=> rgk -> -> -> -> hz hinv j rgj; rewrite /st !initiE 1,2:/# /=.
case: (16 * (2 * k + 1) <= j < 16 * (2 * k + 1) + 16) => h1.
- rewrite sbyvb 1:/# ifF 1:/#.
  have [-> ->] : j %/ 32 = k /\ j %% 16 = j - 32 * k - 16 by smt().
  by rewrite !ldE 1..8:/#; smt().
rewrite initiE 1:/# /=; case: (16 * (2 * k) <= j < 16 * (2 * k) + 16) => h0.
- rewrite sbxvb 1:/# ifT 1:/#.
  have [-> ->] : j %/ 32 = k /\ j %% 16 = j - 32 * k by smt().
  by rewrite !ldE 1..8:/# !(hz (j - 16 * (2 * k))) 1,2:/#; smt().
by rewrite hinv 1:/# initiE 1:/#.
qed.

(* the lanes of the zeta registers of block k, loaded at offsets o and o' *)
lemma zlanes (k o o' : int) : 0 <= k < 8 => o = 2 * zo k => o' = o + 32 =>
  forall l, 0 <= l < 16 => zv o \bits16 l = zt (zo k + l) /\ zv o' \bits16 l = zt (zo k + 16 + l).
proof.
move=> rgk -> -> l rgl; have hz : 136 <= zo k <= 364.
- by rewrite /zo; smt().
by rewrite !zvb 1..8:/#; smt().
qed.

lemma binv8 (a b r : wpoly) : binv 8 a b r => r = bmres a b.
proof. by move=> h; apply Array256.ext_eq => j rgj; apply h => /#. qed.

lemma zvF (o : int) : get256_direct (WArray800.init16 (fun i => jzetas_exp.[i])) o = zv o.
proof. by rewrite /zv. qed.

hoare poly_basemul_h (_a _b : wpoly) :
  M._poly_basemul : ap = _a /\ bp = _b ==> res = bmres _a _b.
proof.
proc.
seq 4 : (ap = _a /\ bp = _b /\ qx16 = qx16v /\ qinvx16 = qinvx16v
         /\ zetaqinv = zv 272 /\ zeta_0 = zv 304 /\ binv 0 _a _b rp).
- by auto => />; rewrite qx16vE qinvx16vE /zv /binv /#.
seq 7 : (ap = _a /\ bp = _b /\ qx16 = qx16v /\ qinvx16 = qinvx16v
         /\ zetaqinv = zv 272 /\ zeta_0 = zv 304 /\ binv 1 _a _b rp).
- wp; ecall (schoolbook_h are aim bre bim zeta_0 zetaqinv 0); auto => /> &hr hinv.
  rewrite !stoE // !ldoE //=.
  by apply (bm_step _ _ _ 0 1 0 0 1) => //; apply (zlanes 0 272 304).
seq 7 : (ap = _a /\ bp = _b /\ qx16 = qx16v /\ qinvx16 = qinvx16v
         /\ zetaqinv = zv 272 /\ zeta_0 = zv 304 /\ binv 2 _a _b rp).
- wp; ecall (schoolbook_h are aim bre bim zeta_0 zetaqinv 1); auto => /> &hr hinv.
  rewrite !stoE // !ldoE //= ?zvF ?zvF /=.
  by apply (bm_step _ _ _ 1 2 1 2 3) => //; apply (zlanes 1 272 304).
seq 9 : (ap = _a /\ bp = _b /\ qx16 = qx16v /\ qinvx16 = qinvx16v
         /\ zetaqinv = zv 336 /\ zeta_0 = zv 368 /\ binv 3 _a _b rp).
- wp; ecall (schoolbook_h are aim bre bim zeta_0 zetaqinv 0); auto => /> &hr hinv.
  rewrite !stoE // !ldoE //= ?zvF ?zvF /=.
  by apply (bm_step _ _ _ 2 3 0 4 5) => //; apply (zlanes 2 336 368).
seq 7 : (ap = _a /\ bp = _b /\ qx16 = qx16v /\ qinvx16 = qinvx16v
         /\ zetaqinv = zv 336 /\ zeta_0 = zv 368 /\ binv 4 _a _b rp).
- wp; ecall (schoolbook_h are aim bre bim zeta_0 zetaqinv 1); auto => /> &hr hinv.
  rewrite !stoE // !ldoE //= ?zvF ?zvF /=.
  by apply (bm_step _ _ _ 3 4 1 6 7) => //; apply (zlanes 3 336 368).
seq 9 : (ap = _a /\ bp = _b /\ qx16 = qx16v /\ qinvx16 = qinvx16v
         /\ zetaqinv = zv 664 /\ zeta_0 = zv 696 /\ binv 5 _a _b rp).
- wp; ecall (schoolbook_h are aim bre bim zeta_0 zetaqinv 0); auto => /> &hr hinv.
  rewrite !stoE // !ldoE //= ?zvF ?zvF /=.
  by apply (bm_step _ _ _ 4 5 0 8 9) => //; apply (zlanes 4 664 696).
seq 7 : (ap = _a /\ bp = _b /\ qx16 = qx16v /\ qinvx16 = qinvx16v
         /\ zetaqinv = zv 664 /\ zeta_0 = zv 696 /\ binv 6 _a _b rp).
- wp; ecall (schoolbook_h are aim bre bim zeta_0 zetaqinv 1); auto => /> &hr hinv.
  rewrite !stoE // !ldoE //= ?zvF ?zvF /=.
  by apply (bm_step _ _ _ 5 6 1 10 11) => //; apply (zlanes 5 664 696).
seq 9 : (ap = _a /\ bp = _b /\ qx16 = qx16v /\ qinvx16 = qinvx16v
         /\ zetaqinv = zv 728 /\ zeta_0 = zv 760 /\ binv 7 _a _b rp).
- wp; ecall (schoolbook_h are aim bre bim zeta_0 zetaqinv 0); auto => /> &hr hinv.
  rewrite !stoE // !ldoE //= ?zvF ?zvF /=.
  by apply (bm_step _ _ _ 6 7 0 12 13) => //; apply (zlanes 6 728 760).
wp; ecall (schoolbook_h are aim bre bim zeta_0 zetaqinv 1); auto => /> &hr hinv.
rewrite !stoE // !ldoE //=; apply binv8.
by apply (bm_step _ _ _ 7 8 1 14 15) => //; apply (zlanes 7 728 760).
qed.

(* ==================================================================== *)
(* Values                                                               *)
(* ==================================================================== *)
lemma wmE (x y : W16.t) : W32.to_sint (wm x y) = W16.to_sint x * W16.to_sint y.
proof. by rewrite /wm to_sint_pack2 -wmulsE. qed.

lemma absM_le (x y m n : int) : `|x| <= m => `|y| <= n => `|x * y| <= m * n.
proof. by move=> hx hy; rewrite normrM ler_pmul // normr_ge0. qed.

lemma cgr_lin (u v w e y k : int) :
  u %% 3329 = v %% 3329 => (w + e * u * y) * k %% 3329 = (w + e * v * y) * k %% 3329.
proof.
move=> h; have -> : (w + e * u * y) * k
  = (w + e * v * y) * k + ((u %/ 3329 - v %/ 3329) * (e * y * k)) * 3329.
- by rewrite {1}(divz_eq u 3329) {1}(divz_eq v 3329) h; ring.
by rewrite modzMDr.
qed.

(* the reduction of a value of magnitude at most 8 q^2 *)
lemma mredP (v : W32.t) : `|W32.to_sint v| <= 8 * 3329 * 3329 =>
     W16.to_sint (mred v) %% 3329 = (W32.to_sint v * 169) %% 3329
  /\ `|W16.to_sint (mred v)| < 3329.
proof.
move=> hv; have /= e := to_sint32_bits16 v.
have /= hb := W16.to_uint_cmp (v \bits16 0).
have hh : -1353 <= W16.to_sint (v \bits16 1) <= 1353 by smt().
have [hc hr] := Montgomery16.REDC16_correct (-1353) 1353 (v \bits16 0) (v \bits16 1) _ _ hh => //.
split; last by move: hr; rewrite /mred /#.
by rewrite /mred hc e /Montgomery16.Rinv /Montgomery16.q.
qed.

op sg (s : int) : int = if s = 0 then 1 else -1.

lemma sbxP (s : int) (a b c d : W16.t) (x : int) : s = 0 \/ s = 1 =>
  `|W16.to_sint a| <= 2 * 3329 => `|W16.to_sint c| <= 2 * 3329 => `|W16.to_sint d| <= 2 * 3329 =>
     W16.to_sint (sbx s a b c d (tw16 x)) %% 3329
       = (W16.to_sint a * W16.to_sint c + sg s * (W16.to_sint b * x) * W16.to_sint d) * 169 %% 3329
  /\ `|W16.to_sint (sbx s a b c d (tw16 x))| < 3329.
proof.
move=> hs ha hc hd; have [zc zb] := mmr16_correct b x.
pose z := mmr16 b (tw16 x).
pose v := if s = 0 then wm a c + wm z d else wm a c - wm z d.
have h1 := absM_le (W16.to_sint a) (W16.to_sint c) (2 * 3329) (2 * 3329) _ _; 1,2: smt().
have h2 := absM_le (W16.to_sint z) (W16.to_sint d) 3329 (2 * 3329) _ _; 1,2: smt().
have hv : W32.to_sint v = W16.to_sint a * W16.to_sint c + sg s * W16.to_sint z * W16.to_sint d.
- rewrite /v /sg; case: hs => ->> /=.
  + by rewrite to_sint32D_small !wmE //; smt().
  by rewrite to_sint32B_small !wmE //; smt().
have [m1 m2] := mredP v _; first by rewrite hv /sg; case: (s = 0) => _; smt().
rewrite /sbx /= -/z -/v m1 hv m2 /=.
by apply cgr_lin; rewrite zc mulrC.
qed.

lemma sbyP (a b c d : W16.t) :
  `|W16.to_sint a| <= 2 * 3329 => `|W16.to_sint b| <= 2 * 3329 =>
  `|W16.to_sint c| <= 2 * 3329 => `|W16.to_sint d| <= 2 * 3329 =>
     W16.to_sint (sby a b c d) %% 3329
       = (W16.to_sint b * W16.to_sint c + W16.to_sint a * W16.to_sint d) * 169 %% 3329
  /\ `|W16.to_sint (sby a b c d)| < 3329.
proof.
move=> ha hb hc hd.
have h1 := absM_le (W16.to_sint b) (W16.to_sint c) (2 * 3329) (2 * 3329) _ _; 1,2: smt().
have h2 := absM_le (W16.to_sint a) (W16.to_sint d) (2 * 3329) (2 * 3329) _ _; 1,2: smt().
have hv : W32.to_sint (wm b c + wm a d)
        = W16.to_sint b * W16.to_sint c + W16.to_sint a * W16.to_sint d.
- by rewrite to_sint32D_small !wmE //; smt().
by have [m1 m2] := mredP (wm b c + wm a d) _; [rewrite hv; smt() | rewrite /sby m1 hv m2].
qed.

(* -------------------------------------------------------------------- *)
(* the pair of block k, lane l, in the order of the specification       *)
op bmi (k l : int) : int = 64 * (k %/ 4) + 4 * l + k %% 4.

lemma ztvE (k l : int) : 0 <= k < 8 => 0 <= l < 16 =>
  (zt (zo k + l), zt (zo k + 16 + l)) = (zv (2 * zo k) \bits16 l, zv (2 * zo k + 32) \bits16 l).
proof.
move=> rgk rgl; have hz : 136 <= zo k <= 364 by rewrite /zo; smt().
by rewrite !zvb 1..8:/# mulKz // (: (2 * zo k + 32) %/ 2 = zo k + 16) 1:/#.
qed.

(* the table holds the factor of the pair, up to the sign of the block *)
lemma ztabE (k l : int) : 0 <= k < 8 => 0 <= l < 16 =>
  (zt (zo k + l), zt (zo k + 16 + l)) = tw16 (sg (k %% 2) * zpw (2 * bitrev (bmi k l) + 1)).
proof.
move=> rgk rgl; rewrite ztvE //; move: l rgl; rewrite allP_range; move: k rgk.
rewrite allP_range -!iotaredE /zo /= !zvL; 1..24: done.
rewrite Array400.of_listK; first done.
by rewrite /=; with hint +listred (cbv delta).
qed.

lemma cgrE (x y : int) : x %% 3329 = y %% 3329 => incoeff x = incoeff y.
proof. by move=> h; apply/eq_incoeff; rewrite /coeffcgr qE. qed.

(* ==================================================================== *)
(* The link with the specification                                      *)
(* ==================================================================== *)
(* the coefficients of the pairs are those of A and B, in the order of
   the specification; the result is the base multiplication, times the
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
    /\ `|W16.to_sint (bmres a b).[32 * k + l + 16 * t]| < 3329.
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
  have [c bnd] := sbxP (k %% 2)
    a.[32 * k + l] a.[32 * k + l + 16] b.[32 * k + l] b.[32 * k + l + 16]
    (sg (k %% 2) * zpw (2 * bitrev (bmi k l) + 1)) _ _ _ _; 1..4: smt().
  split=> //; rewrite (cgrE _ _ c).
  have -> : forall (x y : int), sg (k %% 2) * (x * (sg (k %% 2) * y)) = x * y.
  - by move=> x y; rewrite /sg; case: (k %% 2 = 0) => _; ring.
  by rewrite !incoeffM !incoeffD !incoeffM; ring.
have ->> : t = 1 by smt().
rewrite ifF 1:/# /cmplx_mul /= eA0 eA1 eB0 eB1.
have [c bnd] := sbyP a.[32 * k + l] a.[32 * k + l + 16] b.[32 * k + l] b.[32 * k + l + 16] _ _ _ _;
  1..4: smt().
by split=> //; rewrite (cgrE _ _ c) !incoeffM !incoeffD !incoeffM; ring.
qed.

end MLKEM_basemul_avx2T.
