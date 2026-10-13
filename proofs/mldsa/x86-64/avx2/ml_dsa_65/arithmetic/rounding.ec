require import AllCore List IntDiv RealExp.

from Jasmin require import JModel_x86.

from JazzEC require import Ml_dsa_65_avx2 Mldsa_65_prelude.

from Spec require import GFq Rq Parameters MLDSA_W32_Rep.

import Round ZModQ Zq.

require import XArray256 Array256.
require import CircuitBindings Bindings.

(* ================================================================== *)
(* polynomial__decompose                                                *)
(* Decomposes each coefficient into (LowBits, HighBits) per FIPS 204. *)
(* Uses gamma2 = (q-1)/32 for ML-DSA-65.                              *)
(* Input: polynomial in [0, q-1] (after conditionally_add_modulus).    *)
(* Output: lows in [-gamma2, gamma2] (see lb_rng),                     *)
(*         highs in [0, (q-1)/(2*gamma2)]                             *)
(* Spec connection (via Decompose from GFq.ec):                        *)
(*   lows.[i]  = LowBits((liftu_wpoly _a).[i])                       *)
(*   highs.[i] = HighBits((liftu_wpoly _a).[i])                      *)
(* ================================================================== *)

lemma polynomial__decompose_gamma2_32_ll : islossless M.polynomial__decompose_gamma2_32.
proof.
proc.
wp; while (0 <= offset <= (256 * 32) %/ 8 /\ offset %% 32 = 0)
         ((256 * 32) %/ 8 - offset); last by auto => /#.
by move => *; auto => /#.
qed.

(* Per-lane specification, in 32-bit scalar arithmetic. *)
op hi_lane (c : W32.t) : W32.t =
  let t  = (c + W32.of_int 127) `>>` W8.of_int 7 in
  let u  = (t * W32.of_int 1025) `>>` W8.of_int 16 in
  let p  = (u * W32.of_int 512) `>>` W8.of_int 14 in
  let s  = p + W32.one in
  (s `>>` W8.of_int 1) `&` W32.of_int 15.

(* Calls hi_lane; do not inline it (breaks circuit's lane aggregation). *)
op lo_lane (c : W32.t) : W32.t =
  let l = c - hi_lane c * W32.of_int 523776 in
  l - (if W32.of_int 4190208 \slt l then W32.of_int 8380417 else W32.zero).

(* The lane arithmetic computes FIPS 204 Decompose. *)

lemma hb_u2_collapse (u1 : int) :
    0 <= u1 < 1024 =>
    ((u1 * 512) %/ 16384 + 1) %/ 2 = (u1 + 32) %/ 64.
proof.
move => H; have E : u1 * 512 %/ 16384 = u1 %/ 32 by smt(divzMr divz_eq).
by rewrite E; smt(divz_eq modz_cmp divzMr).
qed.

lemma hb_spec (r : int) :
    0 <= r < q =>
    (((r + 127) %/ 128 * 1025) %/ 65536 + 32) %/ 64 %% 16 = HighBits (incoeff r).
proof.
move => Hr; rewrite /HighBits /Decompose /=.
have -> : asint (incoeff r) = r by rewrite incoeffK; smt().
have Hg : gamma2 = 261888 by smt(param_sets).
rewrite Hg /= /smodem /=.
by smt(divz_eq modz_cmp).
qed.

lemma lb_spec (r : int) :
    0 <= r < q =>
    (let h = (((r + 127) %/ 128 * 1025) %/ 65536 + 32) %/ 64 %% 16 in
     let l = r - h * (2 * gamma2) in
     if q %/ 2 < l then l - q else l) = LowBits (incoeff r).
proof.
move => Hr; rewrite /LowBits /Decompose /=.
have -> : asint (incoeff r) = r by rewrite incoeffK; smt().
have Hg : gamma2 = 261888 by smt(param_sets).
rewrite Hg /smodem /=.
by smt(divz_eq modz_cmp).
qed.

(* Output ranges. *)
lemma hb_rng (r : int) :
    0 <= r < q =>
    0 <= (((r + 127) %/ 128 * 1025) %/ 65536 + 32) %/ 64 %% 16 < 16.
proof.
by move => Hr; smt(modz_cmp).
qed.

(* LowBits lands in [-gamma2, gamma2] (note: -gamma2, not -(gamma2-1)). *)
lemma lb_rng (r : int) :
    0 <= r < q => -gamma2 <= LowBits (incoeff r) <= gamma2.
proof.
move => Hr; rewrite /LowBits /Decompose /=.
have -> : asint (incoeff r) = r by rewrite incoeffK; smt().
have Hg : gamma2 = 261888 by smt(param_sets).
rewrite Hg /smodem /=.
by smt(divz_eq modz_cmp).
qed.

(* Input range, pointwise and as the List.all form circuit attaches to lanes. *)
lemma urng_at (a : W32.t Array256.t) (i : int) :
    wpoly_urng q a => 0 <= i < 256 => 0 <= W32.to_uint a.[i] < q.
proof.
rewrite /wpoly_urng allP /= => H Hi; by apply (H i _); smt().
qed.

lemma urng_to_lanes (a : W32.t Array256.t) :
    wpoly_urng q a =>
    List.all (fun i => a.[i] \ult W32.of_int 8380417) (iotared 0 256).
proof.
move => Hrng; rewrite iotaredE allP => x; rewrite mem_iota /= => Hx.
have Hb := urng_at a x Hrng _; first smt().
by rewrite W32.ultE /q W32.of_uintK /=; smt().
qed.

(* The lane functions as integer operations. *)
lemma hi_lane_val (c : W32.t) :
    0 <= W32.to_uint c < q =>
    W32.to_uint (hi_lane c) =
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
rewrite /hi_lane /=.
have -> : W32.of_int 15 = W32.of_int (2^4 - 1) by done.
rewrite W32.to_uint_and_mod 1:// Hs.
have -> : XWord4.W4.modulus = 16 by done.
by rewrite hb_u2_collapse 1:/#.
qed.

lemma hi_lane_rng (c : W32.t) : 0 <= W32.to_uint (hi_lane c) < 16.
proof.
rewrite /hi_lane /=.
have -> : W32.of_int 15 = W32.of_int (2^4 - 1) by done.
rewrite W32.to_uint_and_mod 1://.
have -> : XWord4.W4.modulus = 16 by done.
by smt(modz_cmp).
qed.

lemma lo_lane_val (c : W32.t) :
    0 <= W32.to_uint c < q =>
    W32.to_sint (lo_lane c) = LowBits (incoeff (W32.to_uint c)).
proof.
move => Hc.
have Hhb := hi_lane_rng c.
have Hhval := hi_lane_val c Hc.
have Hg : gamma2 = 261888 by smt(param_sets).
have Hlb := lb_spec (W32.to_uint c) Hc.
have Hmul : to_uint (hi_lane c * W32.of_int 523776) = to_uint (hi_lane c) * 523776
  by rewrite W32.to_uintM_small /=; smt().
rewrite /lo_lane /=.
pose L := c - hi_lane c * W32.of_int 523776.
have HLu := W32.to_uintBb c (hi_lane c * W32.of_int 523776) false.
move: HLu; rewrite /b2i /= Hmul => HLu.
have Hlrng : -7856640 <= to_uint c - to_uint (hi_lane c) * 523776 <= 8380416 by smt().
have HLs : W32.to_sint L = to_uint c - to_uint (hi_lane c) * 523776.
+ rewrite /to_sint /L HLu /smod /=; by smt().
move: Hlb; rewrite /= -Hhval Hg /= => Hlb.
rewrite W32.sltE HLs /to_sint W32.of_uintK /smod /=.
case (4190208 < to_uint c - to_uint (hi_lane c) * 523776) => Hcnd /=.
+ have HQ := W32.to_uintBb L (W32.of_int q) false.
  move: HQ; rewrite /b2i /q /= => HQ.
  have HLuv : to_uint L = to_uint c - to_uint (hi_lane c) * 523776
    by move: HLu; rewrite -/L; smt().
  by rewrite HQ HLuv -Hlb Hcnd /q /=; smt().
rewrite W32.WRingA.subr0.
have -> : (if 2147483648 <= to_uint L then to_uint L - 4294967296 else to_uint L)
        = W32.to_sint L by rewrite /to_sint /smod /=.
by rewrite HLs -Hlb Hcnd.
qed.

lemma polynomial__decompose_gamma2_32_correct
      (_low : W32.t Array256.t) (_high : W32.t Array256.t) (_a : W32.t Array256.t) :
    hoare [ M.polynomial__decompose_gamma2_32 :
        lows = _low /\ highs = _high /\ polynomial = _a /\
        wpoly_urng q _a  (* input in [0, q-1] *)
        ==>
        (* LowBits: signed, [-gamma2, gamma2] *)
        (forall i, 0 <= i < 256 =>
            W32.to_sint res.`1.[i] = LowBits ((liftu_wpoly _a).[i])) /\
        wpoly_srng gamma2 gamma2 res.`1 /\
        (* HighBits: unsigned, [0, (q-1)/(2*gamma2)] *)
        (forall i, 0 <= i < 256 =>
            W32.to_uint res.`2.[i] = HighBits ((liftu_wpoly _a).[i])) /\
        wpoly_urng ((q - 1) %/ (2 * gamma2)) res.`2
    ].
proof.
proc => /=.
(* Rewrite the WArray slice get/set into the BSWAS slice forms circuit knows. *)
proc change ^while.1 : { coefficients <- if (0 <= offset*8 <= 32*256-256) then BSWAS_256u32_256.sliceget polynomial (offset*8) else WArray1024.WArray1024.get256_direct (WArray1024.WArray1024.init32 (fun (i_0:int) => polynomial.[i_0])) offset; }; first (auto => /> &2; case (0 <= offset{2} * 8 <= 7936); [by move => *; rewrite -BSWAS_256u32_256_slicegetE 1:/# | by auto]).
proc change ^while.12 : { lows <- if (0 <= offset*8 <= 32*256-256) then BSWAS_256u32_256.sliceset lows (offset*8) lower else Array256.init (WArray1024.WArray1024.get32 (WArray1024.WArray1024.set256_direct (WArray1024.WArray1024.init32 (fun (i_0:int) => lows.[i_0])) offset lower)); }; first (auto => /> &2; case (0 <= offset{2} * 8 <= 7936); [by move => *; rewrite BSWAS_256u32_256_slicesetE 1:/# | by auto]).
proc change ^while.13 : { highs <- if (0 <= offset*8 <= 32*256-256) then BSWAS_256u32_256.sliceset highs (offset*8) upper else Array256.init (WArray1024.WArray1024.get32 (WArray1024.WArray1024.set256_direct (WArray1024.WArray1024.init32 (fun (i_0:int) => highs.[i_0])) offset upper)); }; first (auto => /> &2; case (0 <= offset{2} * 8 <= 7936); [by move => *; rewrite BSWAS_256u32_256_slicesetE 1:/# | by auto]).
unroll for ^while.
(* Absorb the trailing `offset <- 1024`, keeping the vector code as a program. *)
wp -1.
(* Refine to the two lane maps; the four spec conjuncts follow from them. *)
conseq (: polynomial = _a /\
          List.all (fun i => _a.[i] \ult W32.of_int 8380417) (iotared 0 256) ==>
          lows  = BSWA_256u32.init (fun (i:int) => lo_lane _a.[i]) /\
          highs = BSWA_256u32.init (fun (i:int) => hi_lane _a.[i])).
+ by move => &hr [# _ _ -> Hrng]; split; [ done | exact urng_to_lanes ].
+ move => &hr [# _ _ _ Hrng] lows0 highs0 [# -> ->].
  have Hg : gamma2 = 261888 by smt(param_sets).
  split; [| split; [| split ] ].
  (* lows value *)
  + move => i Hi; rewrite /BSWA_256u32.init initiE 1:/# /=.
    have Hai : 0 <= W32.to_uint _a.[i] < q by exact (urng_at _a i).
    by rewrite (lo_lane_val _ Hai) /liftu_wpoly mapiE 1:/#.
  (* lows range *)
  + rewrite /wpoly_srng allP => x; rewrite /BSWA_256u32.init /= => Hx.
    rewrite initiE 1:/# /=.
    have Hai : 0 <= W32.to_uint _a.[x] < q by exact (urng_at _a x).
    by rewrite (lo_lane_val _ Hai); exact (lb_rng _ Hai).
  (* highs value *)
  + move => i Hi; rewrite /BSWA_256u32.init initiE 1:/# /=.
    have Hai : 0 <= W32.to_uint _a.[i] < q by exact (urng_at _a i).
    by rewrite (hi_lane_val _ Hai) /liftu_wpoly mapiE 1:/# /= hb_spec.
  (* highs range *)
  rewrite Hg /= /wpoly_urng allP => i Hi.
  by rewrite /BSWA_256u32.init initiE 1:/# /=; smt(hi_lane_rng).
(* One circuit per array: a two-array post defeats lane collapsing. *)
hoare split.
+ by rewrite /hi_lane /=; circuit.
by rewrite /lo_lane /hi_lane /=; circuit.
qed.

(* Decompose through the gamma2 dispatcher *)
lemma polynomial__decompose_ll : islossless M.polynomial__decompose.
proof. by proc; rcondf 1; [auto | call polynomial__decompose_gamma2_32_ll]. qed.

lemma polynomial__decompose_correct
      (_low : W32.t Array256.t) (_high : W32.t Array256.t) (_a : W32.t Array256.t) :
    hoare [ M.polynomial__decompose :
        lows = _low /\ highs = _high /\ polynomial = _a /\
        wpoly_urng q _a  (* input in [0, q-1] *)
        ==>
        (* LowBits: signed, [-gamma2, gamma2] *)
        (forall i, 0 <= i < 256 =>
            W32.to_sint res.`1.[i] = LowBits ((liftu_wpoly _a).[i])) /\
        wpoly_srng gamma2 gamma2 res.`1 /\
        (* HighBits: unsigned, [0, (q-1)/(2*gamma2)] *)
        (forall i, 0 <= i < 256 =>
            W32.to_uint res.`2.[i] = HighBits ((liftu_wpoly _a).[i])) /\
        wpoly_urng ((q - 1) %/ (2 * gamma2)) res.`2
    ].
proof. by proc; rcondf 1; [auto | call (polynomial__decompose_gamma2_32_correct _low _high _a); auto]. qed.

lemma polynomial__decompose_ph
      (_low : W32.t Array256.t) (_high : W32.t Array256.t) (_a : W32.t Array256.t) :
    phoare [ M.polynomial__decompose :
        lows = _low /\ highs = _high /\ polynomial = _a /\
        wpoly_urng q _a
        ==>
        (forall i, 0 <= i < 256 =>
            W32.to_sint res.`1.[i] = LowBits ((liftu_wpoly _a).[i])) /\
        wpoly_srng gamma2 gamma2 res.`1 /\
        (forall i, 0 <= i < 256 =>
            W32.to_uint res.`2.[i] = HighBits ((liftu_wpoly _a).[i])) /\
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
op uh_lane (h l hi : W32.t) : W32.t =
  let l' = l `|` (if l = W32.zero then W32.onew else W32.zero) in
  let s  = (if l' \slt W32.zero then - h
            else if W32.zero \slt l' then h else W32.zero) in
  (hi + s) `&` W32.of_int 15.

(* HighBits lands in [0, 16). *)
lemma hb_rng16 (r : int) : 0 <= r < q => 0 <= HighBits (incoeff r) < 16.
proof.
move => Hr; rewrite -hb_spec 1://; exact (hb_rng r Hr).
qed.

lemma uh_spec (r : int) (hb : bool) :
    0 <= r < q =>
    (HighBits (incoeff r)
     + (if hb then (if 0 < LowBits (incoeff r) then 1 else -1) else 0)) %% 16
    = asint (UseHint hb (incoeff r)).
proof.
move => Hr.
have Hb := hb_rng16 r Hr.
have Hg : gamma2 = 261888 by smt(param_sets).
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

(* uh_lane as an integer operation. *)
lemma uh_lane_val (h l hi : W32.t) :
    to_uint h < 2 => to_uint hi < 16 =>
    to_uint (uh_lane h l hi)
    = (to_uint hi
       + (if h = W32.one then (if 0 < to_sint l then 1 else -1) else 0)) %% 16.
proof.
move => Hh Hhi; rewrite /uh_lane /=.
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
    hoare [ M.polynomial__use_hints_gamma2_32 :
        commitment = _commitment /\ hint_polynomial = _hints /\
        wpoly_urng q _commitment /\   (* standard range [0, q-1] *)
        wpoly_urng 2 _hints           (* hints are 0 or 1 *)
        ==>
        liftu_wpoly res = poly_UseHint (liftu_wpoly _hints) (liftu_wpoly _commitment) /\
        wpoly_urng ((q - 1) %/ (2 * gamma2)) res
    ].
proof.
proc => /=.
proc change ^while.1 : { low <- if (0 <= offset*8 <= n*32-n) then BSWAS_256u32_256.sliceget lows (offset*8) else WArray1024.WArray1024.get256_direct (WArray1024.WArray1024.init32 (fun (i_0:int) => lows.[i_0])) offset; }; first (auto => /> &2; case (0 <= offset{2} * 8 <= 7936); [by move => *; rewrite -BSWAS_256u32_256_slicegetE 1:/# | by auto]).
proc change ^while.2 : { hints <- if (0 <= offset*8 <= n*32-n) then BSWAS_256u32_256.sliceget hint_polynomial (offset*8) else WArray1024.WArray1024.get256_direct (WArray1024.WArray1024.init32 (fun (i_0:int) => hint_polynomial.[i_0])) offset; }; first (auto => /> &2; case (0 <= offset{2} * 8 <= 7936); [by move => *; rewrite -BSWAS_256u32_256_slicegetE 1:/# | by auto]).
proc change ^while.6 : { high <- if (0 <= offset*8 <= n*32-n) then BSWAS_256u32_256.sliceget highs (offset*8) else WArray1024.WArray1024.get256_direct (WArray1024.WArray1024.init32 (fun (i_0:int) => highs.[i_0])) offset; }; first (auto => /> &2; case (0 <= offset{2} * 8 <= 7936); [by move => *; rewrite -BSWAS_256u32_256_slicegetE 1:/# | by auto]).
proc change ^while.9 : { commitment <- if (0 <= offset*8 <= n*32-n) then BSWAS_256u32_256.sliceset commitment (offset*8) coefficients else Array256.init (WArray1024.WArray1024.get32 (WArray1024.WArray1024.set256_direct (WArray1024.WArray1024.init32 (fun (i_0:int) => commitment.[i_0])) offset coefficients)); }; first (auto => /> &2; case (0 <= offset{2} * 8 <= 7936); [by move => *; rewrite BSWAS_256u32_256_slicesetE 1:/# | by auto]).
(* decompose gives the low/high characterisation; the loop is then a per-lane
   map, so one conseq + circuit does the program part. *)
seq 5 : (commitment = _commitment /\ hint_polynomial = _hints /\
         wpoly_urng q _commitment /\ wpoly_urng 2 _hints /\
         zeros = W256.zero /\
         mask = Array5.Array5."_.[_]" polynomial__CONSTANTS_TABLE_gamma2_32 0 /\
         (forall i, 0 <= i < 256 =>
            to_sint lows.[i] = LowBits ((liftu_wpoly _commitment).[i])) /\
         (forall i, 0 <= i < 256 =>
            to_uint highs.[i] = HighBits ((liftu_wpoly _commitment).[i])) /\
         wpoly_urng 16 highs);
  first (call (polynomial__decompose_gamma2_32_correct witness witness _commitment);
         auto => />; have Hm : 8380416 %/ (2 * gamma2) = 16 by smt(param_sets));
  first by rewrite Hm.
unroll for ^while; wp -1.
conseq (: hint_polynomial = _hints /\ zeros = W256.zero /\
          mask = Array5.Array5."_.[_]" polynomial__CONSTANTS_TABLE_gamma2_32 0 /\
          lows = lows /\ highs = highs ==>
          commitment = BSWA_256u32.init
                         (fun (i:int) => uh_lane _hints.[i] lows.[i] highs.[i])).
+ by move => &hr [# _ -> _ _ -> -> _ _ _].
+ move => &hr [# Hc Hhp Hcq Hhq Hz Hm Hlv Hhv Hhr] c0 Hc0.
  have Hm16 : 8380416 %/ (2 * gamma2) = 16 by smt(param_sets).
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
    rewrite (uh_lane_val _ _ _ Hhi2 Hhg16) Hhv 1:/# Hlv 1:/#.
    (* the hint is 0/1, so "coeff nonzero" and "word = one" coincide *)
    have Hhb : ((liftu_wpoly _hints).[i] <> Zq.zero) = (_hints.[i] = W32.one).
    + rewrite /liftu_wpoly mapiE 1:/# /=.
      case (to_uint _hints.[i] = 1) => Hu1.
      + rewrite Hu1 -(W32.to_uintK _hints.[i]) Hu1
                -(W32.to_uintK W32.one) W32.to_uint1 /=.
        by rewrite eqT; apply/negP => He;
           move: (Zq.incoeffK 1); rewrite He Zq.zeroE /q /=.
      have Hge := W32.to_uint_cmp _hints.[i]; move: Hge; rewrite /= => Hge.
      have Hu0 : to_uint _hints.[i] = 0 by smt().
      rewrite Hu0 -(W32.to_uintK _hints.[i]) Hu0
              -(W32.to_uintK W32.one) W32.to_uint1 /=.
      have -> : Zq.incoeff 0 = Zq.zero by rewrite -Zq.zeroE asintK.
      have Hne : W32.zero <> W32.one;
        first (apply/negP => He; move: W32.to_uint1;
               rewrite -He W32.to_uint0; by apply).
      by move: Hne; case (W32.zero = W32.one).
    rewrite Hhb /liftu_wpoly mapiE 1:/# /=.
    by apply uh_spec; exact (urng_at _commitment i).
  split; last first.
  + rewrite Hm16 /wpoly_urng allP => x Hx.
    rewrite Hc0 /BSWA_256u32.init initiE 1:/# /= /uh_lane /=.
    have -> : W32.of_int 15 = W32.of_int (2^4 - 1) by done.
    rewrite W32.to_uint_and_mod 1://.
    have -> : XWord4.W4.modulus = 16 by done.
    by apply modz_cmp.
  apply Array256.ext_eq => x Hx.
  rewrite /liftu_wpoly mapiE 1:/# /poly_UseHint initiE 1:/# /=.
  rewrite -/liftu_wpoly (Hkey x Hx) asintK.
  by rewrite /liftu_wpoly.
by rewrite /uh_lane /=; circuit.
qed.

(* UseHint through the gamma2 dispatcher *)
lemma polynomial__use_hints_ll : islossless M.polynomial__use_hints.
proof. by proc; rcondf 1; [auto | call polynomial__use_hints_gamma2_32_ll]. qed.

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
proof. by proc; rcondf 1; [auto | call (polynomial__use_hints_gamma2_32_correct _commitment _hints); auto]. qed.

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
