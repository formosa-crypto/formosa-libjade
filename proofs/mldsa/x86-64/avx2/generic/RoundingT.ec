require import AllCore List IntDiv RealExp.
from Jasmin require import JModel_x86.
from Spec require import GFq Rq Parameters MLDSA_W32_Rep.
require import XArray256 Array256 WArray1024.
require import CircuitBindings Bindings MldsaConstants.
require BaseT CommonReduceT.

abstract theory RoundingT.

clone import BaseT.BaseT as B.
import S R MLDSAParams.
clone import CommonReduceT.CommonReduceT as CR with theory B <- B.

import Round ZModQ Zq Array5.


(* ================================================================== *)
(* polynomial__decompose                                                *)
(* Decomposes each coefficient into (LowBits, HighBits) per FIPS 204. *)
(* Uses gamma2 = (q-1)/32 for ML-DSA-65.                              *)
(* Input: polynomial in [-(q-1), q-1]; the pass first brings each      *)
(*        coefficient to [0, q-1] (caddq_w).                           *)
(* Output: lows in [-gamma2, gamma2] (see lb32_rng),                     *)
(*         highs in [0, (q-1)/(2*gamma2)]                             *)
(* Spec connection (via Decompose from GFq.ec):                        *)
(*   lows.[i]  = LowBits((lifts_wpoly _a).[i])                       *)
(*   highs.[i] = HighBits((lifts_wpoly _a).[i])                      *)
(* ================================================================== *)

lemma polynomial__decompose_gamma2_32_ll : islossless M.polynomial__decompose_gamma2_32.
proof.
proc.
wp; while (0 <= offset <= (256 * 32) %/ 8 /\ offset %% 32 = 0)
         ((256 * 32) %/ 8 - offset); last by auto => /#.
by move => *; auto => /#.
qed.

(* Per-lane specification, in 32-bit scalar arithmetic. *)
op hi_lane32 (c : W32.t) : W32.t =
  let t  = (c + W32.of_int 127) `>>` W8.of_int 7 in
  let u  = (t * W32.of_int 1025) `>>` W8.of_int 16 in
  let p  = (u * W32.of_int 512) `>>` W8.of_int 14 in
  let s  = p + W32.one in
  (s `>>` W8.of_int 1) `&` W32.of_int 15.

(* Calls hi_lane32; do not inline it (breaks circuit's lane aggregation). *)
op lo_lane32 (c : W32.t) : W32.t =
  let l = c - hi_lane32 c * W32.of_int 523776 in
  l - (if W32.of_int 4190208 \slt l then W32.of_int 8380417 else W32.zero).

(* The lane arithmetic computes FIPS 204 Decompose. *)

lemma hb32_collapse (u1 : int) :
    0 <= u1 < 1024 =>
    ((u1 * 512) %/ 16384 + 1) %/ 2 = (u1 + 32) %/ 64.
proof.
move => H; have E : u1 * 512 %/ 16384 = u1 %/ 32 by smt(divzMr divz_eq).
by rewrite E; smt(divz_eq modz_cmp divzMr).
qed.

lemma hb32_spec (r : int) :
    gamma2 = 261888 => 0 <= r < q =>
    (((r + 127) %/ 128 * 1025) %/ 65536 + 32) %/ 64 %% 16 = HighBits (incoeff r).
proof.
move => Hg Hr; rewrite /HighBits /Decompose /=.
have -> : asint (incoeff r) = r by rewrite incoeffK; smt().
rewrite Hg /= /smodem /=.
by smt(divz_eq modz_cmp).
qed.

lemma lb32_spec (r : int) :
    gamma2 = 261888 => 0 <= r < q =>
    (let h = (((r + 127) %/ 128 * 1025) %/ 65536 + 32) %/ 64 %% 16 in
     let l = r - h * (2 * gamma2) in
     if q %/ 2 < l then l - q else l) = LowBits (incoeff r).
proof.
move => Hg Hr; rewrite /LowBits /Decompose /=.
have -> : asint (incoeff r) = r by rewrite incoeffK; smt().
rewrite Hg /smodem /=.
by smt(divz_eq modz_cmp).
qed.

(* Output ranges. *)
lemma hb32_rng (r : int) :
    0 <= r < q =>
    0 <= (((r + 127) %/ 128 * 1025) %/ 65536 + 32) %/ 64 %% 16 < 16.
proof.
by move => Hr; smt(modz_cmp).
qed.

(* LowBits lands in [-gamma2, gamma2] (note: -gamma2, not -(gamma2-1)). *)
lemma lb32_rng (r : int) :
    gamma2 = 261888 => 0 <= r < q => -gamma2 <= LowBits (incoeff r) <= gamma2.
proof.
move => Hg Hr; rewrite /LowBits /Decompose /=.
have -> : asint (incoeff r) = r by rewrite incoeffK; smt().
rewrite Hg /smodem /=.
by smt(divz_eq modz_cmp).
qed.

(* Input range, pointwise and as the List.all form circuit attaches to lanes. *)
lemma urng_at (a : W32.t Array256.t) (i : int) :
    wpoly_urng q a => 0 <= i < 256 => 0 <= W32.to_uint a.[i] < q.
proof.
rewrite /wpoly_urng allP /= => H Hi; by apply (H i _); smt().
qed.

lemma srng_at (a : W32.t Array256.t) (i : int) :
    wpoly_srng (q-1) (q-1) a => 0 <= i < 256 =>
    0 <= W32.to_uint (caddq_w a.[i]) < q /\
    incoeff (W32.to_uint (caddq_w a.[i])) = (lifts_wpoly a).[i].
proof.
rewrite /wpoly_srng allP /= => H Hi.
by rewrite /lifts_wpoly mapiE //= caddq_w_val; apply (H i _); smt().
qed.

lemma srng_to_lanes (a : W32.t Array256.t) :
    wpoly_srng (q-1) (q-1) a =>
    List.all (fun i => caddq_w a.[i] \ult W32.of_int 8380417) (iotared 0 256).
proof.
move => Hrng; rewrite iotaredE allP => x; rewrite mem_iota /= => Hx.
have [Hb _] := srng_at a x Hrng _; first smt().
by rewrite W32.ultE /q W32.of_uintK /=; smt().
qed.

(* The input range of use_hints, [0, q-1], is within that of decompose. *)
lemma urng_srng (a : W32.t Array256.t) :
    wpoly_urng q a => wpoly_srng (q-1) (q-1) a /\ lifts_wpoly a = liftu_wpoly a.
proof.
move=> Hu; split; last exact wpoly_urng_lifts_eq_liftu.
move: Hu; rewrite /wpoly_urng /wpoly_srng !allP => H i Hi /=.
have /= Hi' := H i Hi; rewrite W32.to_sintE /smod; smt().
qed.

(* The lane functions as integer operations. *)
lemma hi_lane32_val (c : W32.t) :
    0 <= W32.to_uint c < q =>
    W32.to_uint (hi_lane32 c) =
      ((W32.to_uint c + 127) %/ 128 * 1025 %/ 65536 + 32) %/ 64 %% 16.
proof.
move => Hc.
have Ht : to_uint (c + W32.of_int 127 `>>` W8.of_int 7) = (to_uint c + 127) %/ 128
  by rewrite W32.shr_div_le 1:// W32.to_uintD_small /=; smt(W32.to_uint_cmp).
have Hu : to_uint ((c + W32.of_int 127 `>>` W8.of_int 7) * W32.of_int 1025 `>>` W8.of_int 16)
        = (to_uint c + 127) %/ 128 * 1025 %/ 65536
  by rewrite W32.shr_div_le 1:// W32.to_uintM_small /= 1:/# Ht.
have Hp : to_uint (((c + W32.of_int 127 `>>` W8.of_int 7) * W32.of_int 1025 `>>` W8.of_int 16)
                     * W32.of_int 512 `>>` W8.of_int 14)
        = (to_uint c + 127) %/ 128 * 1025 %/ 65536 * 512 %/ 16384
  by rewrite W32.shr_div_le 1:// W32.to_uintM_small /= 1:/# Hu.
have Hs : to_uint ((((c + W32.of_int 127 `>>` W8.of_int 7) * W32.of_int 1025 `>>` W8.of_int 16)
                      * W32.of_int 512 `>>` W8.of_int 14) + W32.one `>>` W8.one)
        = ((to_uint c + 127) %/ 128 * 1025 %/ 65536 * 512 %/ 16384 + 1) %/ 2
  by rewrite W32.shr_div_le 1:// W32.to_uintD_small /= 1:/# Hp.
rewrite /hi_lane32 /=.
have -> : W32.of_int 15 = W32.of_int (2^4 - 1) by done.
rewrite W32.to_uint_and_mod 1:// Hs.
have -> : XWord4.W4.modulus = 16 by done.
by rewrite hb32_collapse 1:/#.
qed.

lemma hi_lane32_rng (c : W32.t) : 0 <= W32.to_uint (hi_lane32 c) < 16.
proof.
rewrite /hi_lane32 /=.
have -> : W32.of_int 15 = W32.of_int (2^4 - 1) by done.
rewrite W32.to_uint_and_mod 1://.
have -> : XWord4.W4.modulus = 16 by done.
by smt(modz_cmp).
qed.

lemma lo_lane32_val (c : W32.t) :
    gamma2 = 261888 => 0 <= W32.to_uint c < q =>
    W32.to_sint (lo_lane32 c) = LowBits (incoeff (W32.to_uint c)).
proof.
move => Hg Hc.
have Hhb := hi_lane32_rng c.
have Hhval := hi_lane32_val c Hc.
have Hlb := lb32_spec (W32.to_uint c) Hg Hc.
have Hmul : to_uint (hi_lane32 c * W32.of_int 523776) = to_uint (hi_lane32 c) * 523776
  by rewrite W32.to_uintM_small /=; smt().
rewrite /lo_lane32 /=.
pose L := c - hi_lane32 c * W32.of_int 523776.
have HLu := W32.to_uintBb c (hi_lane32 c * W32.of_int 523776) false.
move: HLu; rewrite /b2i /= Hmul => HLu.
have Hlrng : -7856640 <= to_uint c - to_uint (hi_lane32 c) * 523776 <= 8380416 by smt().
have HLs : W32.to_sint L = to_uint c - to_uint (hi_lane32 c) * 523776.
+ rewrite /to_sint /L HLu /smod /=; by smt().
move: Hlb; rewrite /= -Hhval Hg /= => Hlb.
rewrite W32.sltE HLs /to_sint W32.of_uintK /smod /=.
case (4190208 < to_uint c - to_uint (hi_lane32 c) * 523776) => Hcnd /=.
+ have HQ := W32.to_uintBb L (W32.of_int q) false.
  move: HQ; rewrite /b2i /q /= => HQ.
  have HLuv : to_uint L = to_uint c - to_uint (hi_lane32 c) * 523776
    by move: HLu; rewrite -/L; smt().
  by rewrite HQ HLuv -Hlb Hcnd /q /=; smt().
rewrite W32.WRingA.subr0.
have -> : (if 2147483648 <= to_uint L then to_uint L - 4294967296 else to_uint L)
        = W32.to_sint L by rewrite /to_sint /smod /=.
by rewrite HLs -Hlb Hcnd.
qed.

lemma polynomial__decompose_gamma2_32_correct
      (_low : W32.t Array256.t) (_high : W32.t Array256.t) (_a : W32.t Array256.t) :
    gamma2 = 261888 =>
    hoare [ M.polynomial__decompose_gamma2_32 :
        lows = _low /\ highs = _high /\ polynomial = _a /\
        wpoly_srng (q-1) (q-1) _a
        ==>
        (* LowBits: signed, [-gamma2, gamma2] *)
        (forall i, 0 <= i < 256 =>
            W32.to_sint res.`1.[i] = LowBits ((lifts_wpoly _a).[i])) /\
        wpoly_srng gamma2 gamma2 res.`1 /\
        (* HighBits: unsigned, [0, (q-1)/(2*gamma2)] *)
        (forall i, 0 <= i < 256 =>
            W32.to_uint res.`2.[i] = HighBits ((lifts_wpoly _a).[i])) /\
        wpoly_urng ((q - 1) %/ (2 * gamma2)) res.`2
    ].
proof.
move=> Hg; proc => /=.
(* Rewrite the WArray slice get/set into the BSWAS slice forms circuit knows. *)
proc change ^while.1 : {
  coefficients <- if (0 <= offset*8 <= 32*256-256)
                  then BSWAS_256u32_256.sliceget polynomial (offset*8)
                  else get256_direct (init32 (fun i => polynomial.[i])) offset; }.
+ auto => /> &2; case (0 <= offset{2} * 8 <= 7936); last by auto.
  by move => *; rewrite -BSWAS_256u32_256_slicegetE 1:/#.
proc change ^while.15 : {
  lows <- if (0 <= offset*8 <= 32*256-256)
          then BSWAS_256u32_256.sliceset lows (offset*8) lower
          else Array256.init (get32 (set256_direct (init32 (fun i => lows.[i])) offset lower)); }.
+ auto => /> &2; case (0 <= offset{2} * 8 <= 7936); last by auto.
  by move => *; rewrite BSWAS_256u32_256_slicesetE 1:/#.
proc change ^while.16 : {
  highs <- if (0 <= offset*8 <= 32*256-256)
           then BSWAS_256u32_256.sliceset highs (offset*8) upper
           else Array256.init (get32 (set256_direct (init32 (fun i => highs.[i])) offset upper)); }.
+ auto => /> &2; case (0 <= offset{2} * 8 <= 7936); last by auto.
  by move => *; rewrite BSWAS_256u32_256_slicesetE 1:/#.
unroll for ^while.
(* Absorb the trailing `offset <- 1024`, keeping the vector code as a program. *)
wp -1.
(* Refine to the two lane maps; the four spec conjuncts follow from them. *)
conseq (: polynomial = _a /\
          List.all (fun i => caddq_w _a.[i] \ult W32.of_int 8380417) (iotared 0 256) ==>
          lows  = BSWA_256u32.init (fun (i:int) => lo_lane32 (caddq_w _a.[i])) /\
          highs = BSWA_256u32.init (fun (i:int) => hi_lane32 (caddq_w _a.[i]))).
+ by move => &hr [# _ _ -> Hrng]; split; [ done | apply (srng_to_lanes _a Hrng) ].
+ move => &hr [# _ _ _ Hrng] lows0 highs0 [# -> ->].
  split; [| split; [| split ] ].
  (* lows value *)
  + move => i Hi; rewrite /BSWA_256u32.init initiE 1:/# /=.
    have [Hai <-] := srng_at _a i Hrng Hi.
    by rewrite (lo_lane32_val _ Hg Hai).
  (* lows range *)
  + rewrite /wpoly_srng allP => x; rewrite /BSWA_256u32.init /= => Hx.
    rewrite initiE 1:/# /=.
    have [Hai _] := srng_at _a x Hrng Hx.
    by rewrite (lo_lane32_val _ Hg Hai); exact (lb32_rng _ Hg Hai).
  (* highs value *)
  + move => i Hi; rewrite /BSWA_256u32.init initiE 1:/# /=.
    have [Hai <-] := srng_at _a i Hrng Hi.
    by rewrite (hi_lane32_val _ Hai) /= hb32_spec.
  (* highs range *)
  rewrite Hg /= /wpoly_urng allP => i Hi.
  by rewrite /BSWA_256u32.init initiE 1:/# /=; smt(hi_lane32_rng).
(* One circuit per array: a two-array post defeats lane collapsing. *)
hoare split.
+ by rewrite /hi_lane32 /caddq_w /=; circuit.
by rewrite /lo_lane32 /hi_lane32 /caddq_w /=; circuit.
qed.

(* ------------------------------------------------------------------ *)
(* Decompose for gamma2 = (q-1)/88                                      *)
(* ------------------------------------------------------------------ *)

lemma polynomial__decompose_gamma2_88_ll : islossless M.polynomial__decompose_gamma2_88.
proof.
proc.
wp; while (0 <= to_uint offset <= 1024 /\ to_uint offset %% 32 = 0) (1024 - to_uint offset).
+ move=> z; auto => &hr [#] h0 h1 hm hlt hz; move: hlt; rewrite ultE /= => hlt.
  by rewrite to_uintD_small /=; smt().
by auto => /> o *; rewrite ultE /#.
qed.

(* Decompose as rounding: with k = (r + gamma2 - 1) %/ (2 gamma2), the
   remainder r - 2 gamma2 k is in (-gamma2, gamma2]. *)
lemma Decompose_round (r : int) :
  0 <= r < q =>
  Decompose (incoeff r) =
    let k = (r + gamma2 - 1) %/ (2 * gamma2) in
    if k = hb_range then (0, r - q) else (k, r - 2 * gamma2 * k).
proof.
move=> [hr0 hrq] /=; have hM := hb_rangeE; have hg := ge2_gamma2.
have hd := divz_eq (r + gamma2 - 1) (2 * gamma2).
have [hm0 hm1] : 0 <= (r + gamma2 - 1) %% (2 * gamma2) < 2 * gamma2.
+ by rewrite modz_ge0 2:ltz_pmod /#.
move: hd hm0 hm1; move: ((r + gamma2 - 1) %/ (2 * gamma2)) ((r + gamma2 - 1) %% (2 * gamma2)).
move=> k m hd hm0 hm1.
have hk0 : 0 <= k by smt().
have hkM : k <= hb_range.
+ case: (k <= hb_range) => // hk; have : (hb_range + 1) * (2 * gamma2) <= k * (2 * gamma2).
  * by apply StdOrder.IntOrder.ler_wpmul2r; smt().
  smt().
case: (k = hb_range) => [->> | hk].
+ case: (r = q - gamma2) => [->> | hr].
  * rewrite (_ : q - gamma2 - q = - gamma2) 1:/#; apply Decompose_neg_gamma.
    by rewrite -incoeffDq; congr; ring.
  by apply Decompose_unique; 1,2: smt(); rewrite -incoeffDq; congr; ring.
by apply Decompose_unique; [smt() | smt() | congr; ring].
qed.

(* Per-lane specification, in 32-bit scalar arithmetic. *)
op hi_lane88 (c : W32.t) : W32.t =
  let t = (c + W32.of_int 127) `>>` W8.of_int 7 in
  let u = (t * W32.of_int 11275) `>>` W8.of_int 16 in
  let p = (u * W32.of_int 128) `>>` W8.of_int 14 in
  let h = (p + W32.one) `>>` W8.one in
  if (W32.of_int 43 - h) \slt W32.zero then W32.zero else h.

(* Calls hi_lane88; do not inline it (breaks circuit's lane aggregation). *)
op lo_lane88 (c : W32.t) : W32.t =
  let l = c - hi_lane88 c * W32.of_int 190464 in
  l - (if W32.of_int 4190208 \slt l then W32.of_int 8380417 else W32.zero).

(* The lane rounding before the wrap-around of 44 to 0, on integers *)
op hb88 (r : int) : int = ((r + 127) %/ 128 * 11275 %/ 65536 * 128 %/ 16384 + 1) %/ 2.

lemma hb88_mono (a b : int) : 0 <= a <= b => hb88 a <= hb88 b.
proof.
move=> hab; rewrite /hb88; apply leq_div2r => //; apply StdOrder.IntOrder.ler_add2r.
do 2! (apply leq_div2r => //; apply StdOrder.IntOrder.ler_wpmul2r => //).
by apply leq_div2r => //; rewrite StdOrder.IntOrder.ler_add2r; case: hab.
qed.

(* hb88 is the rounding of the coefficient, checked at the ends of each step *)
lemma hb88_round (r : int) :
  0 <= r < q => hb88 r = (r + 95231) %/ 190464.
proof.
move=> hr; have hd := divz_eq (r + 95231) 190464.
have [hm0 hm1] : 0 <= (r + 95231) %% 190464 < 190464 by rewrite modz_ge0 2:ltz_pmod.
move: hd hm0 hm1; move: ((r + 95231) %/ 190464) ((r + 95231) %% 190464) => k m hd hm0 hm1.
have hk : 0 <= k < 45 by smt().
have hends : all (fun k => hb88 (max 0 (190464 * k - 95231)) = k /\
                           hb88 (min (q - 1) (190464 * k + 95232)) = k) (iota_ 0 45).
+ by rewrite -iotaredE /hb88 /=.
move: hends; rewrite allP => /(_ k); rewrite mem_iota.
case: hk => hk0 hk1 /=; rewrite hk0 hk1 /= => -[hlo hhi].
apply StdOrder.IntOrder.ler_asym; split.
+ by rewrite -{1}hhi; apply hb88_mono; smt().
by move=> _; rewrite -{1}hlo; apply hb88_mono; smt().
qed.

(* The lane functions as integer operations, and their spec. *)
lemma hi_lane88_val (c : W32.t) :
    0 <= W32.to_uint c < q =>
    W32.to_uint (hi_lane88 c) = let h = hb88 (W32.to_uint c) in if h = 44 then 0 else h.
proof.
move=> Hc; have Hr := hb88_round _ Hc.
have Hh : 0 <= hb88 (to_uint c) <= 44 by rewrite Hr; smt().
pose h := (((c + W32.of_int 127 `>>` W8.of_int 7) * W32.of_int 11275 `>>` W8.of_int 16)
           * W32.of_int 128 `>>` W8.of_int 14) + W32.one `>>` W8.one.
have Hhv : to_uint h = hb88 (to_uint c).
+ have Ht : to_uint (c + W32.of_int 127 `>>` W8.of_int 7) = (to_uint c + 127) %/ 128
    by rewrite W32.shr_div_le 1:// W32.to_uintD_small /=; smt(W32.to_uint_cmp).
  have Hu : to_uint ((c + W32.of_int 127 `>>` W8.of_int 7) * W32.of_int 11275 `>>` W8.of_int 16)
          = (to_uint c + 127) %/ 128 * 11275 %/ 65536
    by rewrite W32.shr_div_le 1:// W32.to_uintM_small /= 1:/# Ht.
  have Hp : to_uint (((c + W32.of_int 127 `>>` W8.of_int 7) * W32.of_int 11275
                        `>>` W8.of_int 16) * W32.of_int 128 `>>` W8.of_int 14)
          = (to_uint c + 127) %/ 128 * 11275 %/ 65536 * 128 %/ 16384
    by rewrite W32.shr_div_le 1:// W32.to_uintM_small /= 1:/# Hu.
  by rewrite /h W32.shr_div_le 1:// W32.to_uintD_small /= 1:/# Hp.
rewrite /hi_lane88 /= -/h W32.sltE /=.
have HB := W32.to_uintBb (W32.of_int 43) h false; move: HB; rewrite /b2i /= Hhv => HB.
rewrite /to_sint /smod HB /=.
case: (hb88 (to_uint c) = 44) => H44; first by rewrite H44.
rewrite (_ : (43 < hb88 (to_uint c)) = false) 1:/# /=.
rewrite (_ : (2147483648 <= 43 - hb88 (to_uint c)) = false) 1:/# /=.
by rewrite (_ : (43 - hb88 (to_uint c) < 0) = false) 1:/# /= Hhv.
qed.

lemma hb88_spec (r : int) :
    gamma2 = 95232 => 0 <= r < q =>
    (let h = hb88 r in if h = 44 then 0 else h) = HighBits (incoeff r).
proof.
move=> Hg Hr; rewrite /HighBits Decompose_round // /hb_range Hg /= hb88_round //.
by case: ((r + 95231) %/ 190464 = 44).
qed.

lemma lo_lane88_val (c : W32.t) :
    gamma2 = 95232 => 0 <= W32.to_uint c < q =>
    W32.to_sint (lo_lane88 c) = LowBits (incoeff (W32.to_uint c)).
proof.
move=> Hg Hc; have Hhv := hi_lane88_val c Hc; have Hr := hb88_round _ Hc.
rewrite /LowBits Decompose_round // /hb_range Hg /= -Hr.
rewrite /lo_lane88 /=; move: Hhv => /=.
have hk : 190464 * hb88 (to_uint c) - 95231 <= to_uint c <= 190464 * hb88 (to_uint c) + 95232.
+ by rewrite Hr; smt(divz_eq modz_ge0 ltz_pmod).
have hk44 : 0 <= hb88 (to_uint c) <= 44 by rewrite Hr; smt().
case: (hb88 (to_uint c) = 44) => H44 /= Hhv.
+ have -> : hi_lane88 c = W32.zero by apply W32.to_uint_eq; rewrite Hhv.
  rewrite W32.WRingA.mul0r W32.WRingA.subr0 W32.sltE.
  have Hcs : to_sint c = to_uint c by rewrite /to_sint /smod /= ifF 1:/#.
  rewrite Hcs (_ : to_sint (W32.of_int 4190208) = 4190208).
  + by rewrite /to_sint /smod W32.of_uintK.
  rewrite ifT 1:/#.
  have HB := W32.to_uintBb c (W32.of_int q) false; move: HB; rewrite /b2i /q /= => HB.
  by rewrite /to_sint /smod HB /q /= ifT 1:/# ifT 1:/#; ring.
have Hmul : to_uint (hi_lane88 c * W32.of_int 190464) = hb88 (to_uint c) * 190464.
+ by rewrite W32.to_uintM_small Hhv /=; smt().
pose L := c - hi_lane88 c * W32.of_int 190464.
have HLs : to_sint L = to_uint c - 190464 * hb88 (to_uint c).
+ have HB := W32.to_uintBb c (hi_lane88 c * W32.of_int 190464) false.
  by move: HB; rewrite /b2i /= Hmul /to_sint /L => ->; rewrite /smod /=; smt().
rewrite W32.sltE HLs (_ : to_sint (W32.of_int 4190208) = 4190208).
+ by rewrite /to_sint /smod W32.of_uintK.
by rewrite ifF 1:/# W32.WRingA.subr0.
qed.

(* The gamma2_88 loops with an int counter, for `unroll for`. *)
module D88 = {
  proc decompose (lows highs polynomial : W32.t Array256.t) :
                 W32.t Array256.t * W32.t Array256.t = {
    var modulus, modulus_halved, v, alpha, offs, shift, max, zeros : W256.t;
    var coefficients, upper, mask, lower : W256.t;
    var offset : int;
    modulus <- mODULUS_VECTOR;
    modulus_halved <- VPSRL_8u32 modulus (W128.of_int 1);
    v <- polynomial__CONSTANTS_TABLE_gamma2_88.[0];
    alpha <- polynomial__CONSTANTS_TABLE_gamma2_88.[1];
    offs <- polynomial__CONSTANTS_TABLE_gamma2_88.[2];
    shift <- polynomial__CONSTANTS_TABLE_gamma2_88.[3];
    max <- polynomial__CONSTANTS_TABLE_gamma2_88.[4];
    zeros <- set0_256;
    offset <- 0;
    while (offset < 1024) {
      coefficients <- get256_direct
                        (init32 (fun i => polynomial.[i])) offset;
      mask <- VPCMPGT_8u32 zeros coefficients;
      mask <- VPAND_256 mask modulus;
      coefficients <- VPADD_8u32 coefficients mask;
      upper <- VPADD_8u32 coefficients offs;
      upper <- VPSRL_8u32 upper (W128.of_int 7);
      upper <- VPMULHU_16u16 upper v;
      upper <- VPMULHRS_16u16 upper shift;
      mask <- VPSUB_8u32 max upper;
      mask <- VPCMPGT_8u32 zeros mask;
      upper <- VPANDN_256 mask upper;
      lower <- VPMULL_8u32 upper alpha;
      lower <- VPSUB_8u32 coefficients lower;
      coefficients <- VPCMPGT_8u32 lower modulus_halved;
      coefficients <- VPAND_256 coefficients modulus;
      lower <- VPSUB_8u32 lower coefficients;
      lows <- Array256.init (get32 (set256_direct
                (init32 (fun i => lows.[i])) offset lower));
      highs <- Array256.init (get32 (set256_direct
                 (init32 (fun i => highs.[i])) offset upper));
      offset <- offset + 32;
    }
    return (lows, highs);
  }

  proc use_hints (commitment hint_polynomial : W32.t Array256.t) : W32.t Array256.t = {
    var max, zeros, low, high, hints, t : W256.t;
    var lows, highs : W32.t Array256.t;
    var offset : int;
    highs <- witness;
    lows <- witness;
    max <- polynomial__CONSTANTS_TABLE_gamma2_88.[4];
    zeros <- set0_256;
    (lows, highs) <@ M.polynomial__decompose_gamma2_88 (lows, highs, commitment);
    offset <- 0;
    while (offset < 1024) {
      low <- get256_direct
               (init32 (fun i => lows.[i])) offset;
      high <- get256_direct
                (init32 (fun i => highs.[i])) offset;
      hints <- get256_direct
                 (init32 (fun i => hint_polynomial.[i])) offset;
      low <- VPCMPGT_8u32 low zeros;
      t <- BLENDV_8u32 hints zeros low;
      t <- VPSLL_8u32 t (W128.of_int 1);
      hints <- VPSUB_8u32 hints t;
      high <- VPADD_8u32 high hints;
      high <- BLENDV_8u32 high max high;
      low <- VPCMPGT_8u32 high max;
      high <- BLENDV_8u32 high zeros low;
      commitment <- Array256.init (get32 (set256_direct
                      (init32 (fun i => commitment.[i])) offset high));
      offset <- offset + 32;
    }
    return commitment;
  }
}.

lemma D88_decompose_eq :
  equiv [M.polynomial__decompose_gamma2_88 ~ D88.decompose : ={arg} ==> ={res}].
proof.
proc; while (={lows, highs, polynomial, modulus, modulus_halved, v, alpha, offs, shift, max, zeros}
             /\ offset{2} = to_uint offset{1} /\ 0 <= offset{2} <= 1024 /\ offset{2} %% 32 = 0).
+ auto => /> &1 h0 h1 hm _ hlt; rewrite !ultE to_uintD_small /= /#.
by auto => /> o; rewrite ultE /=.
qed.

lemma D88_decompose_lanes (_a : W32.t Array256.t) :
    hoare [ D88.decompose :
        polynomial = _a /\
        List.all (fun i => caddq_w _a.[i] \ult W32.of_int 8380417) (iotared 0 256)
        ==>
        res.`1 = BSWA_256u32.init (fun (i:int) => lo_lane88 (caddq_w _a.[i])) /\
        res.`2 = BSWA_256u32.init (fun (i:int) => hi_lane88 (caddq_w _a.[i])) ].
proof.
proc => /=.
proc change ^while.1 : {
  coefficients <- if (0 <= offset*8 <= 32*256-256)
                  then BSWAS_256u32_256.sliceget polynomial (offset*8)
                  else get256_direct (init32 (fun i => polynomial.[i])) offset; }.
+ auto => /> &2; case (0 <= offset{2} * 8 <= 7936); last by auto.
  by move => *; rewrite -BSWAS_256u32_256_slicegetE 1:/#.
proc change ^while.17 : {
  lows <- if (0 <= offset*8 <= 32*256-256)
          then BSWAS_256u32_256.sliceset lows (offset*8) lower
          else Array256.init (get32 (set256_direct (init32 (fun i => lows.[i])) offset lower)); }.
+ auto => /> &2; case (0 <= offset{2} * 8 <= 7936); last by auto.
  by move => *; rewrite BSWAS_256u32_256_slicesetE 1:/#.
proc change ^while.18 : {
  highs <- if (0 <= offset*8 <= 32*256-256)
           then BSWAS_256u32_256.sliceset highs (offset*8) upper
           else Array256.init (get32 (set256_direct (init32 (fun i => highs.[i])) offset upper)); }.
+ auto => /> &2; case (0 <= offset{2} * 8 <= 7936); last by auto.
  by move => *; rewrite BSWAS_256u32_256_slicesetE 1:/#.
unroll for ^while.
wp -1.
(* One circuit per array: a two-array post defeats lane collapsing. *)
hoare split.
+ by rewrite /hi_lane88 /caddq_w /=; circuit.
by rewrite /lo_lane88 /hi_lane88 /caddq_w /=; circuit.
qed.

lemma D88_decompose_correct (_a : W32.t Array256.t) :
    gamma2 = 95232 =>
    hoare [ D88.decompose :
        polynomial = _a /\ wpoly_srng (q-1) (q-1) _a
        ==>
        (forall i, 0 <= i < 256 =>
            W32.to_sint res.`1.[i] = LowBits ((lifts_wpoly _a).[i])) /\
        wpoly_srng gamma2 gamma2 res.`1 /\
        (forall i, 0 <= i < 256 =>
            W32.to_uint res.`2.[i] = HighBits ((lifts_wpoly _a).[i])) /\
        wpoly_urng ((q - 1) %/ (2 * gamma2)) res.`2
    ].
proof.
move=> Hg; conseq (D88_decompose_lanes _a).
+ by move=> &hr [-> Hrng]; split; [done | apply (srng_to_lanes _a Hrng)].
move=> &hr [_ Hrng] [lows0 highs0] /= [-> ->].
split; [| split; [| split ] ].
(* lows value *)
+ move=> i Hi; rewrite /BSWA_256u32.init initiE 1:/# /=.
  have [Hai <-] := srng_at _a i Hrng Hi.
  by rewrite (lo_lane88_val _ Hg Hai).
(* lows range *)
+ rewrite /wpoly_srng allP => x; rewrite /BSWA_256u32.init /= => Hx.
  rewrite initiE 1:/# /=.
  have [Hai _] := srng_at _a x Hrng Hx.
  rewrite (lo_lane88_val _ Hg Hai).
  by have := Decompose_cases (incoeff (to_uint (caddq_w _a.[x]))).
(* highs value *)
+ move=> i Hi; rewrite /BSWA_256u32.init initiE 1:/# /=.
  have [Hai <-] := srng_at _a i Hrng Hi.
  by rewrite (hi_lane88_val _ Hai) /= -hb88_spec.
(* highs range *)
rewrite Hg /wpoly_urng allP => i Hi /=.
rewrite /BSWA_256u32.init initiE 1:/# /=.
have [Hai _] := srng_at _a i Hrng Hi.
by rewrite (hi_lane88_val _ Hai) /= hb88_round //; smt().
qed.

lemma polynomial__decompose_gamma2_88_correct
      (_low : W32.t Array256.t) (_high : W32.t Array256.t) (_a : W32.t Array256.t) :
    gamma2 = 95232 =>
    hoare [ M.polynomial__decompose_gamma2_88 :
        lows = _low /\ highs = _high /\ polynomial = _a /\
        wpoly_srng (q-1) (q-1) _a
        ==>
        (forall i, 0 <= i < 256 =>
            W32.to_sint res.`1.[i] = LowBits ((lifts_wpoly _a).[i])) /\
        wpoly_srng gamma2 gamma2 res.`1 /\
        (forall i, 0 <= i < 256 =>
            W32.to_uint res.`2.[i] = HighBits ((lifts_wpoly _a).[i])) /\
        wpoly_urng ((q - 1) %/ (2 * gamma2)) res.`2
    ].
proof.
move=> Hg; conseq D88_decompose_eq (D88_decompose_correct _a Hg) => //.
by move=> &1 [# _ _ h3 Hrng]; exists arg{1}; split; [| split; [rewrite -h3 |]].
qed.

(* ------------------------------------------------------------------ *)
(* Decompose through the gamma2 dispatcher                              *)
(* ------------------------------------------------------------------ *)

lemma polynomial__decompose_ll : islossless M.polynomial__decompose.
proof.
proc; if.
+ by call polynomial__decompose_gamma2_88_ll.
by call polynomial__decompose_gamma2_32_ll.
qed.

lemma polynomial__decompose_correct
      (_low : W32.t Array256.t) (_high : W32.t Array256.t) (_a : W32.t Array256.t) :
    hoare [ M.polynomial__decompose :
        lows = _low /\ highs = _high /\ polynomial = _a /\
        wpoly_srng (q-1) (q-1) _a
        ==>
        (* LowBits: signed, [-gamma2, gamma2] *)
        (forall i, 0 <= i < 256 =>
            W32.to_sint res.`1.[i] = LowBits ((lifts_wpoly _a).[i])) /\
        wpoly_srng gamma2 gamma2 res.`1 /\
        (* HighBits: unsigned, [0, (q-1)/(2*gamma2)] *)
        (forall i, 0 <= i < 256 =>
            W32.to_uint res.`2.[i] = HighBits ((lifts_wpoly _a).[i])) /\
        wpoly_urng ((q - 1) %/ (2 * gamma2)) res.`2
    ].
proof.
case: gamma2_cases => Hg; proc.
+ rcondt 1; first by auto => />; rewrite -/gamma2 Hg.
  by call (polynomial__decompose_gamma2_88_correct _low _high _a Hg); auto.
rcondf 1; first by auto => />; rewrite -/gamma2 Hg.
by call (polynomial__decompose_gamma2_32_correct _low _high _a Hg); auto.
qed.

lemma polynomial__decompose_ph
      (_low : W32.t Array256.t) (_high : W32.t Array256.t) (_a : W32.t Array256.t) :
    phoare [ M.polynomial__decompose :
        lows = _low /\ highs = _high /\ polynomial = _a /\
        wpoly_srng (q-1) (q-1) _a
        ==>
        (forall i, 0 <= i < 256 =>
            W32.to_sint res.`1.[i] = LowBits ((lifts_wpoly _a).[i])) /\
        wpoly_srng gamma2 gamma2 res.`1 /\
        (forall i, 0 <= i < 256 =>
            W32.to_uint res.`2.[i] = HighBits ((lifts_wpoly _a).[i])) /\
        wpoly_urng ((q - 1) %/ (2 * gamma2)) res.`2
    ] = 1%r
  by conseq polynomial__decompose_ll (polynomial__decompose_correct _low _high _a).

(* ================================================================== *)
(* polynomial__use_hints                                                *)
(* Applies hints to adjust HighBits of commitment coefficients.        *)
(* Internally calls polynomial__decompose, then uses VPSIGN-based     *)
(* conditional adjustment of high bits based on sign of low bits.      *)
(* Spec connection (via poly_UseHint from Rq.ec):                      *)
(*   liftu_wpoly res = poly_UseHint (liftu_wpoly _hints)               *)
(*                                   (liftu_wpoly _commitment)         *)
(* ================================================================== *)

(* Per-lane specification. The VPCMPEQ/VPOR pair maps low = 0 to all-ones so
   that VPSIGN gives -1 there, not 0. *)
op uh_lane32 (h l hi : W32.t) : W32.t =
  let l' = l `|` (if l = W32.zero then W32.onew else W32.zero) in
  let s  = (if l' \slt W32.zero then - h
            else if W32.zero \slt l' then h else W32.zero) in
  (hi + s) `&` W32.of_int 15.

(* HighBits lands in [0, 16). *)
lemma hb32_rng16 (r : int) :
    gamma2 = 261888 => 0 <= r < q => 0 <= HighBits (incoeff r) < 16.
proof.
move => Hg Hr; rewrite -hb32_spec 1,2://; exact (hb32_rng r Hr).
qed.

lemma uh32_spec (r : int) (hb : bool) :
    gamma2 = 261888 => 0 <= r < q =>
    (HighBits (incoeff r)
     + (if hb then (if 0 < LowBits (incoeff r) then 1 else -1) else 0)) %% 16
    = asint (UseHint hb (incoeff r)).
proof.
move => Hg Hr.
have Hb := hb32_rng16 r Hg Hr.
rewrite /UseHint /HighBits /LowBits /= Hg /=.
move: Hb; rewrite /HighBits.
case (Decompose (incoeff r)) => r1 r0 /= Hb.
case hb => Hh /=; last first.
+ by rewrite incoeffK (modz_small _ q) 1:/# (modz_small _ 16) 1:/#.
case (0 < r0) => H0 /=.
+ by rewrite incoeffK (modz_small _ q) 1:/#.
have -> : (r0 <= 0) = true by smt().
by rewrite /= incoeffK (modz_small _ q) 1:/#.
qed.

(* uh_lane32 as an integer operation. *)
lemma uh_lane32_val (h l hi : W32.t) :
    to_uint h < 2 => to_uint hi < 16 =>
    to_uint (uh_lane32 h l hi)
    = (to_uint hi
       + (if h = W32.one then (if 0 < to_sint l then 1 else -1) else 0)) %% 16.
proof.
move => Hh Hhi; rewrite /uh_lane32 /=.
have -> : W32.of_int 15 = W32.of_int (2^4 - 1) by done.
rewrite W32.to_uint_and_mod 1://.
have -> : XWord4.W4.modulus = 16 by done.
have Ho : W32.to_sint W32.onew = -1
  by rewrite /to_sint W32.to_uint_onew /max_uint /smod /=.
have Hz : W32.to_sint W32.zero = 0 by rewrite /to_sint W32.to_uint0 /smod /=.
(* h is 0 or 1, and to_uint is injective, so `h <> one` gives `to_uint h <> 1`. *)
have Hn1 : h <> W32.one => to_uint h <> 1.
+ move => Hh1; apply/negP => He; move: Hh1; rewrite -(W32.to_uintK h) He; by apply.
(* Concretize W32.modulus BEFORE any smt call: smt is useless with `^`. *)
have Hge := W32.to_uint_cmp h; move: Hge; rewrite /= => Hge.
case (l = W32.zero) => Hl0.
+ rewrite Hl0 W32.or0w /= !W32.sltE Ho Hz /=.
  have HB := W32.to_uintBb hi h false; move: HB; rewrite /b2i /= => HB; rewrite HB.
  case (h = W32.one) => Hh1.
  + rewrite Hh1 W32.to_uint1 /=; case (to_uint hi < 1) => Hc /=; last done.
    have -> : to_uint hi + 4294967295 = (to_uint hi - 1) + 268435456 * 16 by ring.
    by rewrite modzMDr.
  have Hh0 : to_uint h = 0 by move: (Hn1 Hh1); smt().
  by rewrite Hh0 /=; smt().
rewrite W32.orw0 !W32.sltE Hz.
have Hls : to_sint l <> 0.
+ apply/negP => He; move: Hl0; move: He; rewrite /to_sint /smod /=.
  have Hc := W32.to_uint_cmp l; move: Hc; rewrite /= => Hc.
  move => He; have Hu0 : to_uint l = 0 by smt().
  by rewrite -(W32.to_uintK l) Hu0.
case (to_sint l < 0) => Hsl /=.
+ have -> : (0 < to_sint l) = false by smt().
  have HB := W32.to_uintBb hi h false; move: HB; rewrite /b2i /= => HB; rewrite HB.
  case (h = W32.one) => Hh1.
  + rewrite Hh1 W32.to_uint1 /=; case (to_uint hi < 1) => Hc /=; last done.
    have -> : to_uint hi + 4294967295 = (to_uint hi - 1) + 268435456 * 16 by ring.
    by rewrite modzMDr.
  have Hh0 : to_uint h = 0 by move: (Hn1 Hh1); smt().
  by rewrite Hh0 /=; smt().
have -> : (0 < to_sint l) = true by smt().
rewrite /= W32.to_uintD /= modz_dvd 1://.
case (h = W32.one) => Hh1; first by rewrite Hh1 W32.to_uint1.
have Hh0 : to_uint h = 0 by move: (Hn1 Hh1); smt().
by rewrite Hh0.
qed.

(* A 0/1 hint word is one exactly when its coefficient is nonzero. *)
lemma hint_bitE (h : W32.t Array256.t) (i : int) :
    wpoly_urng 2 h => 0 <= i < 256 =>
    ((liftu_wpoly h).[i] <> Zq.zero) = (h.[i] = W32.one).
proof.
move=> Hh Hi; rewrite /liftu_wpoly mapiE 1:/# /=.
have Hge := W32.to_uint_cmp h.[i]; move: Hge; rewrite /= => Hge.
have Hh2 : to_uint h.[i] < 2.
+ by move: Hh; rewrite /wpoly_urng allP /= => H; have := H i _; first smt().
case (to_uint h.[i] = 1) => Hu1.
+ rewrite Hu1 -(W32.to_uintK h.[i]) Hu1 -(W32.to_uintK W32.one) W32.to_uint1 /=.
  by rewrite eqT; apply/negP => He; move: (Zq.incoeffK 1); rewrite He Zq.zeroE /q /=.
have Hu0 : to_uint h.[i] = 0 by smt().
rewrite Hu0 -(W32.to_uintK h.[i]) Hu0 -(W32.to_uintK W32.one) W32.to_uint1 /=.
have -> : Zq.incoeff 0 = Zq.zero by rewrite -Zq.zeroE asintK.
have Hne : W32.zero <> W32.one.
+ by apply/negP => He; move: W32.to_uint1; rewrite -He W32.to_uint0.
by move: Hne; case (W32.zero = W32.one).
qed.

lemma polynomial__use_hints_gamma2_32_ll : islossless M.polynomial__use_hints_gamma2_32.
proof.
proc.
while (0 <= offset <= (256 * 32) %/ 8 /\ offset %% 32 = 0)
       ((256 * 32) %/ 8 - offset); last first.
+ wp; call polynomial__decompose_gamma2_32_ll.
  by auto => /#.
by move => *; auto => /#.
qed.

(* Tight output bound: the AVX2 impl ends use_hints with `& 15` (4-bit mask),     *)
(* so output is always in [0..15] = wpoly_urng ((q-1)/(2*gamma2)) = wpoly_urng 16.*)
(* See submodules/dilithium/dilithium/ref/rounding.c:91-95 for the reference.     *)
lemma polynomial__use_hints_gamma2_32_correct
      (_commitment : W32.t Array256.t) (_hints : W32.t Array256.t) :
    gamma2 = 261888 =>
    hoare [ M.polynomial__use_hints_gamma2_32 :
        commitment = _commitment /\ hint_polynomial = _hints /\
        wpoly_urng q _commitment /\   (* standard range [0, q-1] *)
        wpoly_urng 2 _hints           (* hints are 0 or 1 *)
        ==>
        liftu_wpoly res = poly_UseHint (liftu_wpoly _hints) (liftu_wpoly _commitment) /\
        wpoly_urng ((q - 1) %/ (2 * gamma2)) res
    ].
proof.
move=> Hg; proc => /=.
proc change ^while.1 : {
  low <- if (0 <= offset*8 <= n*32-n)
         then BSWAS_256u32_256.sliceget lows (offset*8)
         else get256_direct (init32 (fun i => lows.[i])) offset; }.
+ auto => /> &2; case (0 <= offset{2} * 8 <= 7936); last by auto.
  by move => *; rewrite -BSWAS_256u32_256_slicegetE 1:/#.
proc change ^while.2 : {
  hints <- if (0 <= offset*8 <= n*32-n)
           then BSWAS_256u32_256.sliceget hint_polynomial (offset*8)
           else get256_direct (init32 (fun i => hint_polynomial.[i])) offset; }.
+ auto => /> &2; case (0 <= offset{2} * 8 <= 7936); last by auto.
  by move => *; rewrite -BSWAS_256u32_256_slicegetE 1:/#.
proc change ^while.6 : {
  high <- if (0 <= offset*8 <= n*32-n)
          then BSWAS_256u32_256.sliceget highs (offset*8)
          else get256_direct (init32 (fun i => highs.[i])) offset; }.
+ auto => /> &2; case (0 <= offset{2} * 8 <= 7936); last by auto.
  by move => *; rewrite -BSWAS_256u32_256_slicegetE 1:/#.
proc change ^while.9 : {
  commitment <- if (0 <= offset*8 <= n*32-n)
                then BSWAS_256u32_256.sliceset commitment (offset*8) coefficients
                else Array256.init (get32 (set256_direct
                       (init32 (fun i => commitment.[i])) offset coefficients)); }.
+ auto => /> &2; case (0 <= offset{2} * 8 <= 7936); last by auto.
  by move => *; rewrite BSWAS_256u32_256_slicesetE 1:/#.
(* decompose gives the low/high characterisation; the loop is then a per-lane
   map, so one conseq + circuit does the program part. *)
seq 5 : (commitment = _commitment /\ hint_polynomial = _hints /\
         wpoly_urng q _commitment /\ wpoly_urng 2 _hints /\
         zeros = W256.zero /\
         mask = polynomial__CONSTANTS_TABLE_gamma2_32.[0] /\
         (forall i, 0 <= i < 256 =>
            to_sint lows.[i] = LowBits ((liftu_wpoly _commitment).[i])) /\
         (forall i, 0 <= i < 256 =>
            to_uint highs.[i] = HighBits ((liftu_wpoly _commitment).[i])) /\
         wpoly_urng 16 highs).
+ call (polynomial__decompose_gamma2_32_correct witness witness _commitment Hg).
  auto => /> Hc _; have [Hs Hl] := urng_srng _ Hc.
  split; 1: exact Hs.
  move=> _ r Hlo _ Hhi Hhr; rewrite -Hl; do split.
  + by move=> i h0 h1; apply Hlo.
  + by move=> i h0 h1; apply Hhi.
  by move: Hhr; rewrite Hg.
unroll for ^while; wp -1.
conseq (: hint_polynomial = _hints /\ zeros = W256.zero /\
          mask = polynomial__CONSTANTS_TABLE_gamma2_32.[0] /\
          lows = lows /\ highs = highs ==>
          commitment = BSWA_256u32.init
                         (fun (i:int) => uh_lane32 _hints.[i] lows.[i] highs.[i])).
+ by move => &hr [# _ -> _ _ -> -> _ _ _].
+ move => &hr [# Hc Hhp Hcq Hhq Hz Hm Hlv Hhv Hhr] c0 Hc0.
  have Hm16 : 8380416 %/ (2 * gamma2) = 16 by rewrite Hg.
  (* Per-lane: the word-level map equals the spec's UseHint. *)
  have Hkey : forall i, 0 <= i < 256 =>
      to_uint c0.[i]
      = asint (UseHint (!(liftu_wpoly _hints).[i] = Zq.zero)
                       ((liftu_wpoly _commitment).[i])).
  + move => i Hi; rewrite Hc0 /BSWA_256u32.init initiE 1:/# /=.
    have Hhi2 : to_uint _hints.[i] < 2
      by move: Hhq; rewrite /wpoly_urng allP /= => H; have := H i _; first smt().
    have Hhg16 : to_uint highs{hr}.[i] < 16
      by move: Hhr; rewrite /wpoly_urng allP /= => H; have := H i _; first smt().
    rewrite (uh_lane32_val _ _ _ Hhi2 Hhg16) Hhv 1:/# Hlv 1:/#.
    (* the hint is 0/1, so "coeff nonzero" and "word = one" coincide *)
    have Hhb := hint_bitE _hints i Hhq Hi.
    rewrite Hhb /liftu_wpoly mapiE 1:/# /=.
    by apply uh32_spec => //; exact (urng_at _commitment i).
  split; last first.
  + rewrite Hm16 /wpoly_urng allP => x Hx.
    rewrite Hc0 /BSWA_256u32.init initiE 1:/# /= /uh_lane32 /=.
    have -> : W32.of_int 15 = W32.of_int (2^4 - 1) by done.
    rewrite W32.to_uint_and_mod 1://.
    have -> : XWord4.W4.modulus = 16 by done.
    by apply modz_cmp.
  apply Array256.ext_eq => x Hx.
  rewrite /liftu_wpoly mapiE 1:/# /poly_UseHint initiE 1:/# /=.
  rewrite -/liftu_wpoly (Hkey x Hx) asintK.
  by rewrite /liftu_wpoly.
by rewrite /uh_lane32 /=; circuit.
qed.

(* ------------------------------------------------------------------ *)
(* UseHint for gamma2 = (q-1)/88                                        *)
(* ------------------------------------------------------------------ *)

lemma polynomial__use_hints_gamma2_88_ll : islossless M.polynomial__use_hints_gamma2_88.
proof.
proc; while (0 <= to_uint offset <= 1024 /\ to_uint offset %% 32 = 0) (1024 - to_uint offset).
+ move=> z; auto => &hr [#] h0 h1 hm hlt hz; move: hlt; rewrite ultE /= => hlt.
  by rewrite to_uintD_small /=; smt().
wp; call polynomial__decompose_gamma2_88_ll.
by auto => /> o *; rewrite ultE /#.
qed.

lemma D88_use_hints_eq :
  equiv [M.polynomial__use_hints_gamma2_88 ~ D88.use_hints : ={arg} ==> ={res}].
proof.
proc; while (={commitment, hint_polynomial, lows, highs, max, zeros}
             /\ offset{2} = to_uint offset{1} /\ 0 <= offset{2} <= 1024 /\ offset{2} %% 32 = 0).
+ auto => /> &1 h0 h1 hm _ hlt; rewrite !ultE to_uintD_small /= /#.
wp; call (: true); auto => />.
by sim.
qed.

(* Per-lane specification: the signed hint is added to the high part, and the
   result wraps around [0, 43]. *)
op uh_lane88 (h l hi : W32.t) : W32.t =
  let s = if W32.zero \slt l then h else - h in
  let x = hi + s in
  let y = if x \slt W32.zero then W32.of_int 43 else x in
  if W32.of_int 43 \slt y then W32.zero else y.

lemma uh_lane88_val (h l hi : W32.t) :
    to_uint h < 2 => to_uint hi < 44 =>
    to_uint (uh_lane88 h l hi)
    = (to_uint hi
       + (if h = W32.one then (if 0 < to_sint l then 1 else -1) else 0)) %% 44.
proof.
move=> Hh Hhi; have Hhc := W32.to_uint_cmp hi.
have Hz : W32.to_sint W32.zero = 0 by rewrite /to_sint W32.to_uint0 /smod /=.
have H43 : W32.to_sint (W32.of_int 43) = 43 by rewrite /to_sint /smod W32.of_uintK.
have Hsm : forall (x : W32.t), to_uint x < 2147483648 => to_sint x = to_uint x.
+ by move=> x hx; rewrite /to_sint /smod /= ifF 1:/#.
have Hne : W32.zero <> W32.one.
+ by apply/negP => He; move: W32.to_uint1; rewrite -He W32.to_uint0.
have [->> | ->>] : h = W32.zero \/ h = W32.one.
+ have := W32.to_uint_cmp h; case: (to_uint h = 0) => H0 Hc; [left | right];
    apply W32.to_uint_eq; rewrite ?W32.to_uint0 ?W32.to_uint1 /#.
+ rewrite /uh_lane88 /= W32.WRingA.oppr0 if_same W32.WRingA.addr0 Hne /=.
  by rewrite !W32.sltE Hz H43 Hsm 1:/# /= ifF 1:/# /= ifF 1:/# modz_small /#.
rewrite /uh_lane88 /= !W32.sltE Hz H43; case: (0 < to_sint l) => Hl /=.
+ have Hu : to_uint (hi + W32.one) = to_uint hi + 1.
  + by rewrite W32.to_uintD_small W32.to_uint1 /#.
  have Hs1 : to_sint (hi + W32.one) = to_uint hi + 1 by rewrite Hsm Hu //#.
  rewrite Hs1 (_ : (to_uint hi + 1 < 0) = false) 1:/# /= Hs1.
  case: (to_uint hi = 43) => H43h; first by rewrite H43h.
  by rewrite (_ : (43 < to_uint hi + 1) = false) 1:/# /= Hu modz_small /#.
have HB := W32.to_uintBb hi W32.one false; move: HB; rewrite /b2i W32.to_uint1 /= => HB.
have Hs1 : to_sint (hi - W32.one) = to_uint hi - 1.
+ by rewrite /to_sint /smod HB /=; case: (to_uint hi < 1) => /= ?; smt().
rewrite Hs1; case: (to_uint hi = 0) => H0.
+ by rewrite H0 /= H43 /=.
rewrite (_ : (to_uint hi - 1 < 0) = false) 1:/# /= Hs1.
by rewrite (_ : (43 < to_uint hi - 1) = false) 1:/# /= HB ifF 1:/# modz_small /#.
qed.

(* UseHint as the signed hint added to HighBits, modulo hb_range. *)
lemma uh_spec (r : coeff) (hb : bool) :
    (HighBits r + (if hb then (if 0 < LowBits r then 1 else -1) else 0)) %% hb_range
    = asint (UseHint hb r).
proof.
have [[Hb0 Hb1] _] := Decompose_cases r; have Hhb := hb_range_cases.
move: Hb0 Hb1; rewrite /UseHint /HighBits /LowBits /= -/hb_range.
case (Decompose r) => r1 r0 /= Hb0 Hb1.
case hb => Hh /=; last by rewrite incoeffK (modz_small _ q) 1:/# (modz_small _ hb_range) 1:/#.
case (0 < r0) => H0 /=; first by rewrite incoeffK (modz_small _ q) 1:/#.
have -> : (r0 <= 0) = true by smt().
by rewrite /= incoeffK (modz_small _ q) 1:/#.
qed.

lemma D88_use_hints_correct (_commitment : W32.t Array256.t) (_hints : W32.t Array256.t) :
    gamma2 = 95232 =>
    hoare [ D88.use_hints :
        commitment = _commitment /\ hint_polynomial = _hints /\
        wpoly_urng q _commitment /\ wpoly_urng 2 _hints
        ==>
        liftu_wpoly res = poly_UseHint (liftu_wpoly _hints) (liftu_wpoly _commitment) /\
        wpoly_urng ((q - 1) %/ (2 * gamma2)) res
    ].
proof.
move=> Hg; proc => /=.
proc change ^while.1 : {
  low <- if (0 <= offset*8 <= n*32-n)
         then BSWAS_256u32_256.sliceget lows (offset*8)
         else get256_direct (init32 (fun i => lows.[i])) offset; }.
+ auto => /> &2; case (0 <= offset{2} * 8 <= 7936); last by auto.
  by move => *; rewrite -BSWAS_256u32_256_slicegetE 1:/#.
proc change ^while.2 : {
  high <- if (0 <= offset*8 <= n*32-n)
          then BSWAS_256u32_256.sliceget highs (offset*8)
          else get256_direct (init32 (fun i => highs.[i])) offset; }.
+ auto => /> &2; case (0 <= offset{2} * 8 <= 7936); last by auto.
  by move => *; rewrite -BSWAS_256u32_256_slicegetE 1:/#.
proc change ^while.3 : {
  hints <- if (0 <= offset*8 <= n*32-n)
           then BSWAS_256u32_256.sliceget hint_polynomial (offset*8)
           else get256_direct (init32 (fun i => hint_polynomial.[i])) offset; }.
+ auto => /> &2; case (0 <= offset{2} * 8 <= 7936); last by auto.
  by move => *; rewrite -BSWAS_256u32_256_slicegetE 1:/#.
proc change ^while.12 : {
  commitment <- if (0 <= offset*8 <= n*32-n)
                then BSWAS_256u32_256.sliceset commitment (offset*8) high
                else Array256.init
                       (get32 (set256_direct (init32 (fun i => commitment.[i])) offset high)); }.
+ auto => /> &2; case (0 <= offset{2} * 8 <= 7936); last by auto.
  by move => *; rewrite BSWAS_256u32_256_slicesetE 1:/#.
seq 5 : (commitment = _commitment /\ hint_polynomial = _hints /\
         wpoly_urng q _commitment /\ wpoly_urng 2 _hints /\
         zeros = W256.zero /\ max = polynomial__CONSTANTS_TABLE_gamma2_88.[4] /\
         (forall i, 0 <= i < 256 =>
            to_sint lows.[i] = LowBits ((liftu_wpoly _commitment).[i])) /\
         (forall i, 0 <= i < 256 =>
            to_uint highs.[i] = HighBits ((liftu_wpoly _commitment).[i])) /\
         wpoly_urng 44 highs).
+ call (polynomial__decompose_gamma2_88_correct witness witness _commitment Hg).
  auto => /> Hc _; have [Hs Hl] := urng_srng _ Hc.
  split; 1: exact Hs.
  move=> _ r Hlo _ Hhi Hhr; rewrite -Hl; do split.
  + by move=> i h0 h1; apply Hlo.
  + by move=> i h0 h1; apply Hhi.
  by move: Hhr; rewrite Hg.
unroll for ^while; wp -1.
conseq (: hint_polynomial = _hints /\ zeros = W256.zero /\
          max = polynomial__CONSTANTS_TABLE_gamma2_88.[4] /\
          lows = lows /\ highs = highs ==>
          commitment = BSWA_256u32.init
                         (fun (i:int) => uh_lane88 _hints.[i] lows.[i] highs.[i])).
+ by move => &hr [# _ -> _ _ -> -> _ _ _].
+ move => &hr [# Hc Hhp Hcq Hhq Hz Hm Hlv Hhv Hhr] c0 Hc0.
  (* Per-lane: the word-level map equals the spec's UseHint. *)
  have Hkey : forall i, 0 <= i < 256 =>
      to_uint c0.[i]
      = asint (UseHint (!(liftu_wpoly _hints).[i] = Zq.zero)
                       ((liftu_wpoly _commitment).[i])).
  + move => i Hi; rewrite Hc0 /BSWA_256u32.init initiE 1:/# /=.
    have Hhi2 : to_uint _hints.[i] < 2
      by move: Hhq; rewrite /wpoly_urng allP /= => H; have := H i _; first smt().
    have Hhg44 : to_uint highs{hr}.[i] < 44
      by move: Hhr; rewrite /wpoly_urng allP /= => H; have := H i _; first smt().
    rewrite (uh_lane88_val _ _ _ Hhi2 Hhg44) Hhv 1:/# Hlv 1:/#.
    by rewrite (hint_bitE _hints i Hhq Hi) -uh_spec /hb_range Hg.
  split; last first.
  + rewrite (_ : 8380416 %/ (2 * gamma2) = hb_range) 1:// /wpoly_urng allP => x Hx /=.
    by rewrite Hkey 1:/# -uh_spec; apply modz_cmp; smt(hb_range_cases).
  apply Array256.ext_eq => x Hx.
  rewrite /liftu_wpoly mapiE 1:/# /poly_UseHint initiE 1:/# /=.
  by rewrite -/liftu_wpoly (Hkey x Hx) asintK.
by rewrite /uh_lane88 /=; circuit.
qed.

lemma polynomial__use_hints_gamma2_88_correct
      (_commitment : W32.t Array256.t) (_hints : W32.t Array256.t) :
    gamma2 = 95232 =>
    hoare [ M.polynomial__use_hints_gamma2_88 :
        commitment = _commitment /\ hint_polynomial = _hints /\
        wpoly_urng q _commitment /\ wpoly_urng 2 _hints
        ==>
        liftu_wpoly res = poly_UseHint (liftu_wpoly _hints) (liftu_wpoly _commitment) /\
        wpoly_urng ((q - 1) %/ (2 * gamma2)) res
    ].
proof.
move=> Hg; conseq D88_use_hints_eq (D88_use_hints_correct _commitment _hints Hg) => //.
by move=> &1 [#] *; exists arg{1}; do! split.
qed.

(* ------------------------------------------------------------------ *)
(* UseHint through the gamma2 dispatcher                                *)
(* ------------------------------------------------------------------ *)

lemma polynomial__use_hints_ll : islossless M.polynomial__use_hints.
proof.
proc; if.
+ by call polynomial__use_hints_gamma2_88_ll.
by call polynomial__use_hints_gamma2_32_ll.
qed.

lemma polynomial__use_hints_correct
      (_commitment : W32.t Array256.t) (_hints : W32.t Array256.t) :
    hoare [ M.polynomial__use_hints :
        commitment = _commitment /\ hint_polynomial = _hints /\
        wpoly_urng q _commitment /\   (* standard range [0, q-1] *)
        wpoly_urng 2 _hints           (* hints are 0 or 1 *)
        ==>
        liftu_wpoly res = poly_UseHint (liftu_wpoly _hints) (liftu_wpoly _commitment) /\
        wpoly_urng ((q - 1) %/ (2 * gamma2)) res
    ].
proof.
case: gamma2_cases => Hg; proc.
+ rcondt 1; first by auto => />; rewrite -/gamma2 Hg.
  by call (polynomial__use_hints_gamma2_88_correct _commitment _hints Hg); auto.
rcondf 1; first by auto => />; rewrite -/gamma2 Hg.
by call (polynomial__use_hints_gamma2_32_correct _commitment _hints Hg); auto.
qed.

lemma polynomial__use_hints_ph
      (_commitment : W32.t Array256.t) (_hints : W32.t Array256.t) :
    phoare [ M.polynomial__use_hints :
        commitment = _commitment /\ hint_polynomial = _hints /\
        wpoly_urng q _commitment /\
        wpoly_urng 2 _hints
        ==>
        liftu_wpoly res = poly_UseHint (liftu_wpoly _hints) (liftu_wpoly _commitment) /\
        wpoly_urng ((q - 1) %/ (2 * gamma2)) res
    ] = 1%r
  by conseq polynomial__use_hints_ll (polynomial__use_hints_correct _commitment _hints).

end RoundingT.
