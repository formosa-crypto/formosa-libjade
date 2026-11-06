require import AllCore List IntDiv RealExp BitEncoding.
from Jasmin require import JModel_x86.
from Spec require import GFq Rq Parameters MLDSA_W32_Rep.
require import XArray256 Array256 WArray1024.
require import CircuitBindings Bindings.
require import Vmov.
require BaseT.

abstract theory CommonRoundingT.

clone import BaseT.BaseT as B.
import S R MLDSAParams.

import Round ZModQ Zq BS2Int.


(* ================================================================== *)
(* polynomial____make_hint                                              *)
(* For each coefficient i:                                             *)
(*   hints[i] = MakeHint(low_coefficients[i], high_coefficients[i])   *)
(*            = 1 if HighBits(low+high) != HighBits(high), else 0     *)
(* Also returns the total weight (count of 1s).                        *)
(* Spec connection (via poly_MakeHintImpl from Rq.ec):                 *)
(*   liftu_wpoly res.`1 = poly_MakeHintImpl (lifts_wpoly _high)        *)
(*                                           (lifts_wpoly _low)         *)
(*   res.`2 = count (fun i => (liftu_wpoly res.`1).[i] <> Zq.zero)    *)
(*                  (iota_ 0 256)                                      *)
(* ================================================================== *)

lemma polynomial____make_hint_ll : islossless M.polynomial____make_hint.
proof.
proc.
wp; while (offset <= (256 * 32) %/ 8 /\ offset %% 32 = 0)
         ((256 * 32) %/ 8 - offset);
  last by auto => /> /#. 
by move => *; auto => /> /#. 
qed.

lemma mh_spec (l h : int) :
    -(2*gamma2 - Beta - 2) <= l <= 2*gamma2 - Beta - 2 =>
    0 <= h < hb_range =>
    MakeHintImpl (incoeff h) (incoeff l) = (gamma2 < `|l| \/ (l = -gamma2 /\ h <> 0)).
proof.
move=> Hl Hh; have [hB0 hB1] := Beta_bnd; have hg := ge2_gamma2; have hM := hb_rangeE.
have hgb := gamma2_bound.
rewrite /MakeHintImpl /MakeHint /= incoeffK (pmod_small h); 1: smt(hb_range_cases).
have -> : incoeff (h * 2 * gamma2) + incoeff l + (zero - incoeff l) = incoeff (h * 2 * gamma2) by ring.
rewrite -incoeffD.
have hH0 : HighBits (incoeff (h * 2 * gamma2)) = h.
+ rewrite /HighBits (Decompose_unique h 0 _) 1,2:/# //; congr; ring.
rewrite hH0.
case: (-gamma2 < l <= gamma2) => hl.
- rewrite /HighBits (Decompose_unique h l _) 1,2:/#; 1: by congr; ring.
  smt().
have hq2 : (hb_range - 1) * 2 * gamma2 = q - 1 - 2 * gamma2 by rewrite -hM; ring.
have hhb := hb_range_cases.
case: (gamma2 < l) => hgt.
- case: (h + 1 < hb_range) => hh.
  + rewrite /HighBits (Decompose_unique (h + 1) (l - 2 * gamma2) _) 1,2:/#; 1: by congr; ring.
    smt().
  have ->> : h = hb_range - 1 by smt().
  have hrep2 : incoeff ((hb_range - 1) * 2 * gamma2 + l) = incoeff (l - 2 * gamma2 - 1).
  + by rewrite hq2 -(incoeffDq (l - 2 * gamma2 - 1)); congr; ring.
  rewrite hrep2; case: (l - 2 * gamma2 - 1 = - gamma2) => he.
  + by rewrite /HighBits (Decompose_neg_gamma _) 1:he //=; smt().
  by rewrite /HighBits (Decompose_unique 0 (l - 2 * gamma2 - 1) _) 1,2:/# //=; smt().
case: (1 <= h) => h1.
- case: (l = - gamma2) => he.
  + rewrite /HighBits (Decompose_unique (h - 1) gamma2 _) 1,2:/#; 1: by congr; rewrite he; ring.
    smt().
  rewrite /HighBits (Decompose_unique (h - 1) (l + 2 * gamma2) _) 1,2:/#; 1: by congr; ring.
  smt().
have ->> : h = 0 by smt().
case: (l = - gamma2) => he.
- by rewrite /= he /HighBits (Decompose_neg_gamma _) //=; smt().
have hrep3 : incoeff (0 * 2 * gamma2 + l) =
             incoeff (2 * gamma2 * (hb_range - 1) + (l + 2 * gamma2 + 1)).
+ rewrite -(incoeffDq (0 * 2 * gamma2 + l)); congr.
  have -> : 2 * gamma2 * (hb_range - 1) = q - 1 - 2 * gamma2 by rewrite -hq2; ring.
  by ring.
rewrite hrep3 /HighBits (Decompose_unique (hb_range - 1) (l + 2 * gamma2 + 1) _) 1,2:/# //=.
smt().
qed.

(* one lane of make_hint, for the gamma2 word g *)
op mh_lane (g l h : W32.t) : W32.t =
  let a  = if l \slt W32.zero then - l else l in
  let c1 = if g \slt a then W32.onew else W32.zero in
  let e  = if l = - g then W32.onew else W32.zero in
  let c2 = if h \slt W32.zero then - e else if W32.zero \slt h then e else W32.zero in
  if (c1 `|` c2) \slt W32.zero then W32.one else W32.zero.

(* The weight of a block, with DOIT instructions only: bit 4j+3 of the byte
   mask is the sign of lane j, the product sums the eight sign bits into the
   top nibble. The sum is the one of the stored hints (the lanes >>> 31). *)
lemma mh_swar_sum (hb : W256.t) :
  (((MOVEMASK_32u8 hb `>>` W8.of_int 3) `&` W32.of_int 286331153) * W32.of_int 286331153)
    `>>` W8.of_int 28 =
  let s = VPSRL_8u32 hb (W128.of_int 31) in
  (s \bits32 0) + (s \bits32 1) + (s \bits32 2) + (s \bits32 3) +
  (s \bits32 4) + (s \bits32 5) + (s \bits32 6) + (s \bits32 7).
proof. by circuit. qed.

(* the 32-bit sum of eight words in [0, 1] does not wrap *)
lemma mh_to_uint_sum8 (a0 a1 a2 a3 a4 a5 a6 a7 : W32.t) :
  0 <= to_uint a0 <= 1 => 0 <= to_uint a1 <= 1 => 0 <= to_uint a2 <= 1 =>
  0 <= to_uint a3 <= 1 => 0 <= to_uint a4 <= 1 => 0 <= to_uint a5 <= 1 =>
  0 <= to_uint a6 <= 1 => 0 <= to_uint a7 <= 1 =>
  to_uint (a0 + a1 + a2 + a3 + a4 + a5 + a6 + a7) =
  to_uint a0 + to_uint a1 + to_uint a2 + to_uint a3 +
  to_uint a4 + to_uint a5 + to_uint a6 + to_uint a7.
proof.
move=> *.
rewrite -{1}(W32.to_uintK a0) -{1}(W32.to_uintK a1) -{1}(W32.to_uintK a2).
rewrite -{1}(W32.to_uintK a3) -{1}(W32.to_uintK a4) -{1}(W32.to_uintK a5).
rewrite -{1}(W32.to_uintK a6) -{1}(W32.to_uintK a7).
by rewrite -!W32.of_intD W32.of_uintK pmod_small /#.
qed.

lemma mh_block_count (hb : W256.t) :
  W64.to_uint (zeroextu64 ((((MOVEMASK_32u8 hb `>>` W8.of_int 3) `&` W32.of_int 286331153)
                            * W32.of_int 286331153) `>>` W8.of_int 28)) =
  count (fun j => VPSRL_8u32 hb (W128.of_int 31) \bits32 j <> W32.zero) (iota_ 0 8).
proof.
rewrite W2u32.to_uint_zeroextu64 mh_swar_sum /=.
pose s := VPSRL_8u32 hb (W128.of_int 31).
have hs : forall j, 0 <= j < 8 => to_uint (s \bits32 j) = b2i (s \bits32 j <> W32.zero).
+ move=> j hj; have hle : to_uint (s \bits32 j) < 2.
  + rewrite /s /VPSRL_8u32 W8u32.mapbE 1:// /= W32.to_uint_shr 1:// /=.
    by have := W32.to_uint_cmp (hb \bits32 j); smt().
  case: (s \bits32 j = W32.zero) => [-> //|hn]; rewrite /b2i /=.
  by have := W32.to_uint_cmp (s \bits32 j); move: hn; rewrite W32.to_uint_eq /=; smt().
have hb1 : forall j, 0 <= j < 8 => 0 <= to_uint (s \bits32 j) <= 1.
+ by move=> j hj; rewrite hs //; smt().
by rewrite -iotaredE /= -!hs // mh_to_uint_sum8 ?hb1 //; ring.
qed.

lemma mh_sliceset_get (t : W32.t Array256.t) (o : int) (s : W256.t) (i : int) :
  0 <= o <= 992 => o %% 32 = 0 => 0 <= i < 256 =>
  (BSWAS_256u32_256.sliceset t (o * 8) s).[i] = if o %/ 4 <= i < o %/ 4 + 8 then s \bits32 (i - o %/ 4) else t.[i].
proof.
move=> ho hm hi; rewrite BSWAS_256u32_256_slicesetE 1:/# initiE 1:// /= /WArray1024.get32_direct WArray1024.set256E /WArray1024.init32.
apply W32.wordP => k kb; rewrite W4u8.pack4E W32.initiE 1:// /= W4u8.Pack.initiE 1:/# /= WArray1024.initiE 1:/# /=.
have -> : (o <= 4 * i + k %/ 8 < o + 32) = (o %/ 4 <= i < o %/ 4 + 8) by smt().
case: (o %/ 4 <= i < o %/ 4 + 8) => hc /=.
+ rewrite W32u8.bits8E W8u32.bits32E W8.initiE 1:/# W32.initiE 1:// /=; congr; smt().
rewrite WArray1024.initiE 1:/# /= W4u8.bits8E W8.initiE 1:/# /=; smt().
qed.

lemma mh_lane_val (l h : W32.t) :
  -2147483648 < to_sint l => to_uint h < 2147483648 =>
  mh_lane (W32.of_int gamma2) l h =
  if gamma2 < `|to_sint l| \/ (to_sint l = -gamma2 /\ to_uint h <> 0) then W32.one else W32.zero.
proof.
move=> Hl Hh; have hgb := gamma2_bound; rewrite /mh_lane /= !W32.sltE.
have Hz : W32.to_sint W32.zero = 0 by rewrite /to_sint W32.to_uint0 /smod /=.
have Ho : W32.to_sint W32.onew = -1 by rewrite /to_sint W32.to_uint_onew /max_uint /smod /=.
have Hg : W32.to_sint (W32.of_int gamma2) = gamma2.
+ by rewrite /to_sint W32.of_uintK /smod (pmod_small gamma2) 1:/# ifF 1:/#.
have Hsh : W32.to_sint h = W32.to_uint h by rewrite /to_sint /smod /= ifF 1:/#.
have He : (l = - W32.of_int gamma2) = (W32.to_sint l = -gamma2).
+ rewrite eq_iff; split => [-> | H].
  * rewrite -W32.of_intN /to_sint W32.of_uintK /smod.
    rewrite (_ : (- gamma2) %% W32.modulus = W32.modulus - gamma2) 1:-(modzMDr 1) 1:pmod_small /#.
  have Hc := W32.to_uint_cmp l; move: Hc H; rewrite /to_sint /smod /= => Hc H.
  have Hu : to_uint l = W32.modulus - gamma2 by smt().
  rewrite W32.to_uint_eq Hu W32.to_uintN W32.of_uintK (pmod_small gamma2) 1:/#.
  by rewrite -(modzMDr 1) pmod_small /#.
have Ha : W32.to_sint (if W32.to_sint l < 0 then -l else l) = `|W32.to_sint l|.
+ case (W32.to_sint l < 0) => Hn /=; last by smt().
  have -> : -l = W32.zero - l by ring.
  rewrite W32.to_sintB_small Hz /=; [rewrite /min_sint /max_sint /=; smt() | smt()].
have Hhc := W32.to_uint_cmp h; move: Hhc; rewrite /= => Hhc.
rewrite Hz Hg Ha Hsh He /= (_ : (to_uint h < 0) = false) 1:/# /=.
case (gamma2 < `|to_sint l|) => H1 /=.
+ by rewrite Ho.
by case (0 < to_uint h) => H2; case (to_sint l = -gamma2) => H3 /=; rewrite ?Ho ?Hz /= /#.
qed.

(* make_hint computes mh_lane lane by lane, for the gamma2 word g *)
lemma make_hint_circ (g : W32.t) (_h _low _high : W32.t Array256.t) :
    hoare [ M.polynomial____make_hint :
        g = W32.of_int gamma2 /\
        hints = _h /\ low_coefficients = _low /\ high_coefficients = _high
        ==>
        res.`1 = BSWA_256u32.init (fun (i:int) => mh_lane g _low.[i] _high.[i]) /\
        res.`2 = count (fun (i:int) => res.`1.[i] <> W32.zero) (iota_ 0 256) ].
proof.
proc => /=.
seq 6 : (g = W32.of_int S.gamma2 /\ hints = _h /\ low_coefficients = _low /\
         high_coefficients = _high /\
         gamma2 = VPBROADCAST_8u32 g /\ minus_gamma2 = VPBROADCAST_8u32 (-g)).
+ auto => /> ; rewrite !truncateu32_VMOV_64E /truncateu32 !W64.of_uintK /gamma2.
  split; congr.
  + by apply W32.to_uint_eq; rewrite !W32.of_uintK /ptr_modulus /= modz_dvd.
  apply W32.to_uint_eq; rewrite W32.to_uintN !W32.of_uintK /ptr_modulus /= modz_dvd //.
  by rewrite modzNm.
proc change ^while.1 : {
  low <- if (0 <= offset*8 <= n*32-n)
         then BSWAS_256u32_256.sliceget low_coefficients (offset*8)
         else get256_direct (init32 (fun i => low_coefficients.[i])) offset; }.
+ auto => /> &2; case (0 <= offset{2} * 8 <= 7936); last by auto.
  by move => *; rewrite -BSWAS_256u32_256_slicegetE 1:/#.
proc change ^while.2 : {
  high <- if (0 <= offset*8 <= n*32-n)
          then BSWAS_256u32_256.sliceget high_coefficients (offset*8)
          else get256_direct (init32 (fun i => high_coefficients.[i])) offset; }.
+ auto => /> &2; case (0 <= offset{2} * 8 <= 7936); last by auto.
  by move => *; rewrite -BSWAS_256u32_256_slicegetE 1:/#.
proc change ^while.15 : {
  hints <- if (0 <= offset*8 <= n*32-n)
           then BSWAS_256u32_256.sliceset hints (offset*8) hint_block
           else Array256.init
                  (get32 (set256_direct (init32 (fun i => hints.[i])) offset hint_block)); }.
+ auto => /> &2; case (0 <= offset{2} * 8 <= 7936); last by auto.
  by move => *; rewrite BSWAS_256u32_256_slicesetE 1:/#.
hoare split; last first.
+ unroll for ^while; wp -1.
  conseq (: low_coefficients = _low /\ high_coefficients = _high /\
            gamma2 = VPBROADCAST_8u32 g /\ minus_gamma2 = VPBROADCAST_8u32 (-g) ==> _); 1: smt().
    kill 513; first by auto. kill 505 ! 6; first by auto.
    kill 497; first by auto. kill 489 ! 6; first by auto.
    kill 481; first by auto. kill 473 ! 6; first by auto.
    kill 465; first by auto. kill 457 ! 6; first by auto.
    kill 449; first by auto. kill 441 ! 6; first by auto.
    kill 433; first by auto. kill 425 ! 6; first by auto.
    kill 417; first by auto. kill 409 ! 6; first by auto.
    kill 401; first by auto. kill 393 ! 6; first by auto.
    kill 385; first by auto. kill 377 ! 6; first by auto.
    kill 369; first by auto. kill 361 ! 6; first by auto.
    kill 353; first by auto. kill 345 ! 6; first by auto.
    kill 337; first by auto. kill 329 ! 6; first by auto.
    kill 321; first by auto. kill 313 ! 6; first by auto.
    kill 305; first by auto. kill 297 ! 6; first by auto.
    kill 289; first by auto. kill 281 ! 6; first by auto.
    kill 273; first by auto. kill 265 ! 6; first by auto.
    kill 257; first by auto. kill 249 ! 6; first by auto.
    kill 241; first by auto. kill 233 ! 6; first by auto.
    kill 225; first by auto. kill 217 ! 6; first by auto.
    kill 209; first by auto. kill 201 ! 6; first by auto.
    kill 193; first by auto. kill 185 ! 6; first by auto.
    kill 177; first by auto. kill 169 ! 6; first by auto.
    kill 161; first by auto. kill 153 ! 6; first by auto.
    kill 145; first by auto. kill 137 ! 6; first by auto.
    kill 129; first by auto. kill 121 ! 6; first by auto.
    kill 113; first by auto. kill 105 ! 6; first by auto.
    kill 97; first by auto. kill 89 ! 6; first by auto.
    kill 81; first by auto. kill 73 ! 6; first by auto.
    kill 65; first by auto. kill 57 ! 6; first by auto.
    kill 49; first by auto. kill 41 ! 6; first by auto.
    kill 33; first by auto. kill 25 ! 6; first by auto.
    kill 17; first by auto. kill 9 ! 6; first by auto.
    kill 1; first by auto.
  by rewrite /mh_lane /=; circuit.
while (0 <= offset <= 1024 /\ offset %% 32 = 0 /\
       weight = count (fun (i:int) => hints.[i] <> W32.zero) (iota_ 0 (offset %/ 4))).
+ wp; skip => &hr [#] h0 h1 hm -> hc; have hb : 0 <= offset{hr} * 8 <= n * 32 - n by smt().
  rewrite hb /= mh_block_count; do! split; 1,2,3: smt().
  have E : forall (s : W256.t), count (fun (i : int) => (BSWAS_256u32_256.sliceset hints{hr} (offset{hr} * 8) s).[i] <> W32.zero) (iota_ 0 ((offset{hr} + 32) %/ 4)) = count (fun (i : int) => hints{hr}.[i] <> W32.zero) (iota_ 0 (offset{hr} %/ 4)) + count (fun (j : int) => s \bits32 j <> W32.zero) (iota_ 0 8).
  + move=> s; rewrite (_ : (offset{hr} + 32) %/ 4 = offset{hr} %/ 4 + 8) 1:/# iota_add 1,2:/# count_cat /=; congr.
    + by apply eq_in_count => i /mem_iota ri /=; rewrite mh_sliceset_get 1..3:/# ifF 1:/#.
    have -> : iota_ (offset{hr} %/ 4) 8 = map ((+) (offset{hr} %/ 4)) (iota_ 0 8) by rewrite -iota_addl.
    by rewrite count_map; apply eq_in_count => j /mem_iota rj; rewrite /preim /= mh_sliceset_get 1..3:/# ifT 1:/# (_ : offset{hr} %/ 4 + j - offset{hr} %/ 4 = j) 1:/#.
  by rewrite E.
auto => />.
split; [by rewrite iota0 | move=> h o h1 h2 h3 h4; congr; congr; smt()].
qed.

lemma polynomial____make_hint_correct
      (_h : W32.t Array256.t) (_low : W32.t Array256.t) (_high : W32.t Array256.t) :
    hoare [ M.polynomial____make_hint :
        hints = _h /\ low_coefficients = _low /\ high_coefficients = _high /\
        (* low: w0_minus_cs2_plus_ct0 range, the tightest from the norm checks *)
        wpoly_srng (2*gamma2 - Beta - 2) (2*gamma2 - Beta - 2) _low /\
        (* high: HighBits (w1) output range [0, (q-1) / (2*gamma2)] *)
        wpoly_urng ((q - 1) %/ (2 * gamma2)) _high
        ==>
        wpoly_urng 2 res.`1 /\
        liftu_wpoly res.`1 = poly_MakeHintImpl (lifts_wpoly _high) (lifts_wpoly _low) /\
        res.`2 = count (fun i => (liftu_wpoly res.`1).[i] <> Zq.zero) (iota_ 0 256)
    ].
proof.
conseq (make_hint_circ (W32.of_int gamma2) _h _low _high) => //.
move=> &hr [# _ _ _ Hl Hh] [h0 w0] /= [-> ->].
have [hB0 hB1] := Beta_bnd; have hgb := gamma2_bound; have hhb := hb_range_cases.
move: Hl Hh; rewrite /wpoly_srng /wpoly_urng !allP /= => Hl Hh.
have Hkey : forall i, 0 <= i < 256 =>
  (BSWA_256u32.init (fun (i0 : int) => mh_lane (W32.of_int gamma2) _low.[i0] _high.[i0])).[i] =
  if MakeHintImpl (lifts_wpoly _high).[i] (lifts_wpoly _low).[i] then W32.one else W32.zero.
+ move=> i Hi; rewrite /BSWA_256u32.init initiE 1:// /= /lifts_wpoly !mapiE 1,2:// /=.
  have [Hl1 Hl2] := Hl i Hi; have [Hh1 Hh2] := Hh i Hi.
  have Hsh : to_sint _high.[i] = to_uint _high.[i].
  + by rewrite /to_sint /smod /= ifF; smt(hb_range_cases).
  rewrite mh_lane_val; 1,2: smt(hb_range_cases).
  by rewrite Hsh mh_spec; smt(hb_range_cases).
split; first by move=> i Hi; rewrite Hkey 1://; case: (MakeHintImpl _ _); [rewrite W32.to_uint1 | rewrite W32.to_uint0].
split; first by apply Array256.ext_eq => i Hi; rewrite /liftu_wpoly mapiE 1:// /= Hkey 1:// /poly_MakeHintImpl initiE 1:// /=; case: (MakeHintImpl _ _); [rewrite W32.to_uint1 | rewrite W32.to_uint0].
apply eq_in_count => i /mem_iota Hi /=; rewrite /liftu_wpoly mapiE 1:/# /= Hkey 1:/#; case: (MakeHintImpl _ _) => /=.
+ by split => H; [move: W32.to_uint1; rewrite H W32.to_uint0 | move: (Zq.incoeffK 1); rewrite H Zq.zeroE /q /=].
by rewrite -Zq.zeroE asintK.
qed.

lemma polynomial____make_hint_ph
      (_h : W32.t Array256.t) (_low : W32.t Array256.t) (_high : W32.t Array256.t) :
    phoare [ M.polynomial____make_hint :
        hints = _h /\ low_coefficients = _low /\ high_coefficients = _high /\
        wpoly_srng (2*gamma2 - Beta - 2) (2*gamma2 - Beta - 2) _low /\
        wpoly_urng ((q - 1) %/ (2 * gamma2)) _high
        ==>
        wpoly_urng 2 res.`1 /\
        liftu_wpoly res.`1 = poly_MakeHintImpl (lifts_wpoly _high) (lifts_wpoly _low) /\
        res.`2 = count (fun i => (liftu_wpoly res.`1).[i] <> Zq.zero) (iota_ 0 256)
    ] = 1%r
  by conseq polynomial____make_hint_ll (polynomial____make_hint_correct _h _low _high).

(* ================================================================== *)
(* polynomial____power2round                                             *)
(* Splits each coefficient into high and low parts using 2^d:          *)
(*   highbits = (a + 2^(d-1)) >> d                                    *)
(*   lowbits  = a - highbits * 2^d                                    *)
(* Spec connection: poly_Power2Round from Rq.ec                        *)
(*   (liftu_wpoly res.`1, lifts_wpoly res.`2) ~ poly_Power2Round      *)
(* ================================================================== *)

lemma polynomial____power2round_ll : islossless M.polynomial____power2round.
proof.
proc.
wp; while (0 <= offset <= (256 * 32) %/ 8 /\ offset %% 32 = 0)
         ((256 * 32) %/ 8 - offset); last by auto => /#.
by move => *; auto => /#.
qed.

lemma polynomial____power2round_correct
      (_high : W32.t Array256.t) (_low : W32.t Array256.t) (_a : W32.t Array256.t) :
    hoare [ M.polynomial____power2round :
        highbits = _high /\ lowbits = _low /\ polynomial = _a /\
        wpoly_urng q _a  (* input in [0, q-1], after conditionally_add_modulus *)
        ==>
        (* t1 (high): unsigned, [0, 2^(23-d) - 1] *)
        (forall i, 0 <= i < 256 =>
            W32.to_uint res.`1.[i] = asint (Power2Round (liftu_wpoly _a).[i]).`1 ) /\
        wpoly_urng (2^(23-d)) res.`1 /\
        (* t0 (low): signed, (-(2^(d-1)), 2^(d-1)] *)
        (forall i, 0 <= i < 256 =>
            W32.to_sint res.`2.[i] = crepr (Power2Round (liftu_wpoly _a).[i]).`2 ) /\
        wpoly_srng (2^(d-1) - 1) (2^(d-1)) res.`2
    ].
proof.
proc => /=.
proc change 2 : { temp <- W64.of_int 1; }; 1: by auto.
proc change 3 : { ones_vector <- zeroextu256 temp; }.
+ auto => &1 &2 ->; rewrite /VMOV_64 zeroextu256E zeroextu256E.
  rewrite wordP => i ib.
  rewrite pack2E pack2E pack4E initiE 1:/# /= initiE 1:/# /= initiE 1:/# /= initiE 1:/# /=.
  case (i %/ 64 = 0) => ?; 1: by rewrite ifT 1:/# initiE 1:/# /= get_of_list /#.
  case (i %/ 128 = 0) => ?; 2: by auto.
  rewrite initiE 1:/# /= get_of_list 1:/#.
  by have -> /= : (i %% 128 %/ 64) = 1 by smt().
proc change ^while.1 : {
  coefficients <- if (0 <= offset*8 <= 32*256-256)
                  then BSWAS_256u32_256.sliceget polynomial (offset*8)
                  else get256_direct (init32 (fun i => polynomial.[i])) offset; }.
+ auto => /> &2; case (0 <= offset{2} * 8 <= 7936); last by auto.
  by move => *; rewrite -BSWAS_256u32_256_slicegetE 1:/#.
proc change ^while.7 : {
  highbits <- if (0 <= offset*8 <= 32*256-256)
              then BSWAS_256u32_256.sliceset highbits (offset*8) high
              else Array256.init
                     (get32 (set256_direct (init32 (fun i => highbits.[i])) offset high)); }.
+ auto => /> &2; case (0 <= offset{2} * 8 <= 7936); last by auto.
  by move => *; rewrite BSWAS_256u32_256_slicesetE 1:/#.
proc change ^while.8 : {
  lowbits <- if (0 <= offset*8 <= 32*256-256)
             then BSWAS_256u32_256.sliceset lowbits (offset*8) low
             else Array256.init
                    (get32 (set256_direct (init32 (fun i => lowbits.[i])) offset low)); }.
+ auto => /> &2; case (0 <= offset{2} * 8 <= 7936); last by auto.
  by move => *; rewrite BSWAS_256u32_256_slicesetE 1:/#.
unroll for ^while.
wp 260.
conseq (: polynomial = _a /\ wpoly_urng q _a ==> highbits = BSWA_256u32.init (fun (i:int) => (_a.[i] + W32.of_int 4096 - W32.of_int 1) `|>>>` 13) /\ lowbits = BSWA_256u32.init (fun (i:int) => _a.[i] - ((_a.[i] + W32.of_int 4096 - W32.of_int 1) `|>>>` 13) * W32.of_int 8192)); last by circuit.
+ by move => &hr; smt().
move => &hr [# _ _ _ Hurng] hb lb [# -> ->].
move: Hurng; rewrite /wpoly_urng allP => Hurng.
have key : forall (i:int), 0 <= i < n => to_uint ((_a.[i] + of_int 4096 - one) `|>>>` d) = (to_uint _a.[i] + 4095) %/ 8192 /\ to_sint (_a.[i] - ((_a.[i] + of_int 4096 - one) `|>>>` d) * of_int 8192) = to_uint _a.[i] - (to_uint _a.[i] + 4095) %/ 8192 * 8192.
+ move => i Hi; have Hs := Hurng i Hi.
  have Hts : to_sint _a.[i] = to_uint _a.[i] by rewrite W32.to_sintE /smod /=; smt().
  have H4096 : to_sint (W32.of_int 4096) = 4096 by rewrite W32.to_sintE W32.of_uintK /smod /=.
  have Hone : to_sint W32.one = 1 by rewrite W32.to_sintE /smod /=.
  have Hadd : to_sint (_a.[i] + W32.of_int 4096) = to_uint _a.[i] + 4096.
  - rewrite W32.to_sintD_small; first (rewrite H4096 Hts; smt()).
    by rewrite H4096 Hts.
  have Hpre : to_sint (_a.[i] + W32.of_int 4096 - W32.one) = to_uint _a.[i] + 4095.
  - rewrite W32.to_sintB_small; first (rewrite Hadd Hone; smt()).
    by rewrite Hadd Hone.
  have Hsar : to_sint ((_a.[i] + W32.of_int 4096 - W32.one) `|>>>` d) = (to_uint _a.[i] + 4095) %/ 8192 by rewrite JWordExtra.WE32.to_sint_sar 1:/# Hpre /=.
  have Hhr : 0 <= (to_uint _a.[i] + 4095) %/ 8192 < 1024.
  - have Hde : to_uint _a.[i] + 4095 = (to_uint _a.[i] + 4095) %/ 8192 * 8192 + (to_uint _a.[i] + 4095) %% 8192 by smt(divz_eq).
    have Hmc : 0 <= (to_uint _a.[i] + 4095) %% 8192 < 8192 by smt(modz_cmp).
    smt().
  have Hcmp := W32.to_uint_cmp ((_a.[i] + W32.of_int 4096 - W32.one) `|>>>` d).
  have Huw : to_uint ((_a.[i] + W32.of_int 4096 - W32.one) `|>>>` d) = (to_uint _a.[i] + 4095) %/ 8192 by move: Hsar Hcmp; rewrite W32.to_sintE /smod /=; smt().
  split; first exact Huw.
  have Hprod : ((_a.[i] + W32.of_int 4096 - W32.one) `|>>>` d) * W32.of_int 8192 = W32.of_int ((to_uint _a.[i] + 4095) %/ 8192 * 8192) by rewrite W32.to_uint_eq W32.to_uintM !W32.of_uintK Huw /=; smt().
  have HK : to_sint (W32.of_int ((to_uint _a.[i] + 4095) %/ 8192 * 8192)) = (to_uint _a.[i] + 4095) %/ 8192 * 8192 by rewrite W32.to_sintK_small /=; smt().
  rewrite Hprod W32.to_sintB_small; first (rewrite HK Hts; smt()).
  by rewrite HK Hts.
have Hpr : forall (i:int), 0 <= i < n => asint (Power2Round (liftu_wpoly _a).[i]).`1 = (to_uint _a.[i] + 4095) %/ 8192 /\ crepr (Power2Round (liftu_wpoly _a).[i]).`2 = to_uint _a.[i] - (to_uint _a.[i] + 4095) %/ 8192 * 8192.
+ move => i Hi; have Hs := Hurng i Hi.
  rewrite /liftu_wpoly mapiE 1:/# /= /Power2Round /=.
  have Hrp : asint (incoeff (to_uint _a.[i])) = to_uint _a.[i] by rewrite incoeffK; smt().
  rewrite !Hrp.
  have Hsm : smodem (to_uint _a.[i]) 8192 = to_uint _a.[i] - (to_uint _a.[i] + 4095) %/ 8192 * 8192.
  - have E1 : to_uint _a.[i] = to_uint _a.[i] %/ 8192 * 8192 + to_uint _a.[i] %% 8192 by smt(divz_eq).
    have E2 : to_uint _a.[i] + 4095 = (to_uint _a.[i] + 4095) %/ 8192 * 8192 + (to_uint _a.[i] + 4095) %% 8192 by smt(divz_eq).
    have E3 : 0 <= to_uint _a.[i] %% 8192 < 8192 by smt(modz_cmp).
    have E4 : 0 <= (to_uint _a.[i] + 4095) %% 8192 < 8192 by smt(modz_cmp).
    rewrite /smodem /=; smt().
  have Hhi : (to_uint _a.[i] - smodem (to_uint _a.[i]) 8192) %/ 8192 = (to_uint _a.[i] + 4095) %/ 8192 by rewrite Hsm; smt(mulzK).
  split; first by rewrite Hhi incoeffK; smt(divz_eq modz_cmp).
  rewrite Hsm incoeffK_centered; smt(divz_eq modz_cmp).
split; first by move => i Hi; have [Hk1 _] := key i Hi; have [Hp1 _] := Hpr i Hi; rewrite /BSWA_256u32.init initiE 1:/# /= Hk1 Hp1.
split; first by rewrite /wpoly_urng allP => i Hi /=; rewrite /BSWA_256u32.init initiE 1:/# /=; have [Hk1 _] := key i Hi; have Hs := Hurng i Hi; rewrite Hk1; smt(divz_eq modz_cmp).
split; first by move => i Hi; have [_ Hk2] := key i Hi; have [_ Hp2] := Hpr i Hi; rewrite /BSWA_256u32.init initiE 1:/# /= Hk2 Hp2.
rewrite /wpoly_srng allP => i Hi /=; rewrite /BSWA_256u32.init initiE 1:/# /=; have [_ Hk2] := key i Hi; have Hs := Hurng i Hi; rewrite Hk2; smt(divz_eq modz_cmp).
qed.

lemma polynomial____power2round_ph
      (_high : W32.t Array256.t) (_low : W32.t Array256.t) (_a : W32.t Array256.t) :
    phoare [ M.polynomial____power2round :
        highbits = _high /\ lowbits = _low /\ polynomial = _a /\
        wpoly_urng q _a
        ==>
        (forall i, 0 <= i < 256 =>
            W32.to_uint res.`1.[i] = asint (Power2Round (liftu_wpoly _a).[i]).`1 ) /\
        wpoly_urng (2^(23-d)) res.`1 /\
        (forall i, 0 <= i < 256 =>
            W32.to_sint res.`2.[i] = crepr (Power2Round (liftu_wpoly _a).[i]).`2 ) /\
        wpoly_srng (2^(d-1) - 1) (2^(d-1)) res.`2
    ] = 1%r
  by conseq polynomial____power2round_ll
            (polynomial____power2round_correct _high _low _a).

end CommonRoundingT.
