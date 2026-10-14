require import AllCore List IntDiv RealExp.
from Jasmin require import JModel_x86.
require import CircuitBindings Bindings.
from Spec require import GFq Rq Parameters MLDSA_W32_Rep.
require import XArray256 Array256.
require Nttspec.
require import Nttlink.
require BaseT.

abstract theory CommonReduceT.

clone import BaseT.BaseT as B.
import S R MLDSAParams.

import Round ZModQ Zq.



(* ================================================================== *)
(* montgomery_multiply_and_reduce                                       *)
(* AVX2 vectorised Montgomery multiplication (8 lanes in parallel).    *)
(* Computes a * b * R^-1 mod q for each of 8 coefficient pairs.        *)
(* Used as the inner loop body of pointwise_montgomery_multiply and     *)
(* invert_ntt_montgomery.                                               *)
(* ================================================================== *)

lemma montgomery_multiply_and_reduce_ll : islossless M.montgomery_multiply_and_reduce.
proof. by proc; islossless. qed.

(* ================================================================== *)
(* polynomial__reduce32                                                 *)
(* reduce32(a)[i] = a[i] mod q, centered representative                *)
(* Concretely: a[i] - round(a[i] / 2^23) * q                         *)
(* Spec: lifts_wpoly res = lifts_wpoly _a (same GFq value)             *)
(*       wpoly_srng ((q-1)%/2) ((q-1)%/2) res  (centered rep)         *)
(* ================================================================== *)

lemma polynomial__reduce32_ll : islossless M.polynomial__reduce32.
proof.
proc.
wp; while (0 <= offset <= (256 * 32) %/ 8 /\ offset %% 32 = 0)
         ((256 * 32) %/ 8 - offset); last by auto => /#.
by move => *; auto => /#.
qed.

lemma polynomial__reduce32_correct (_a : W32.t Array256.t) :
    hoare [ M.polynomial__reduce32 :
        polynomial = _a /\
        wpoly_srng (2^31 - 2^22 - 1) (2^31 - 2^22 - 1) _a
        ==>
        lifts_wpoly res = lifts_wpoly _a /\
        wpoly_srng 6283009 6283008 res
    ].
proof.
proc => /=.
proc change ^while.1 : { a <- if (0 <= offset*8 <= 32*256-256) then BSWAS_256u32_256.sliceget polynomial (offset*8) else WArray1024.WArray1024.get256_direct (WArray1024.WArray1024.init32 (fun (i_0:int) => polynomial.[i_0])) offset; }; first (auto => /> &2; case (0 <= offset{2} * 8 <= 7936); [by move => *; rewrite -BSWAS_256u32_256_slicegetE 1:/# | by auto]).
proc change ^while.6 : { polynomial <- if (0 <= offset*8 <= 32*256-256) then BSWAS_256u32_256.sliceset polynomial (offset*8) a else Array256.init (WArray1024.WArray1024.get32 (WArray1024.WArray1024.set256_direct (WArray1024.WArray1024.init32 (fun (i_0:int) => polynomial.[i_0])) offset a)); }; first (auto => /> &2; case (0 <= offset{2} * 8 <= 7936); [by move => *; rewrite BSWAS_256u32_256_slicesetE 1:/# | by auto]).
unroll for ^while.
wp 194.
conseq (: polynomial = _a /\ wpoly_srng 2143289343 2143289343 _a ==> polynomial = BSWA_256u32.init (fun (i:int) => _a.[i] - ((_a.[i] + W32.of_int 4194304) `|>>>` 23) * W32.of_int 8380417)); last by circuit.
move => &hr [# _ Hrng] p0 ->; move: Hrng; rewrite /wpoly_srng !allP => Hrng.
have key : forall (i:int), 0 <= i < n => to_sint (_a.[i] - ((_a.[i] + W32.of_int 4194304) `|>>>` q_bits) * W32.of_int q) = to_sint _a.[i] - ((to_sint _a.[i] + 4194304) %/ 2^23) * q.
+ move => i Hi; have /= Hs := Hrng i Hi.
  have H22 : to_sint (W32.of_int 4194304) = 4194304 by rewrite W32.to_sintE W32.of_uintK /smod /=.
  have H23 : 2 ^ 23 = 8388608 by done.
  have Hadd : to_sint (_a.[i] + W32.of_int 4194304) = to_sint _a.[i] + 4194304.
  + rewrite W32.to_sintD_small; first (rewrite H22 /=; smt()).
    by rewrite H22.
  have Hsar : to_sint ((_a.[i] + W32.of_int 4194304) `|>>>` q_bits) = (to_sint _a.[i] + 4194304) %/ 8388608 by rewrite JWordExtra.WE32.to_sint_sar 1:/# Hadd H23.
  have Hk : -255 <= (to_sint _a.[i] + 4194304) %/ 8388608 <= 255 by smt().
  have Hush : to_uint ((_a.[i] + W32.of_int 4194304) `|>>>` q_bits) = ((to_sint _a.[i] + 4194304) %/ 8388608) %% 4294967296.
  + have Hmod : W32.modulus = 4294967296 by done.
    rewrite -Hsar; move: (W32.to_uint_cmp ((_a.[i] + W32.of_int 4194304) `|>>>` q_bits)); rewrite Hmod => Hub; case (msb ((_a.[i] + W32.of_int 4194304) `|>>>` q_bits)) => Hm; [ rewrite (JWordExtra.W32_to_sint_neg _ Hm) | rewrite (JWordExtra.W32_to_sint_pos _ Hm) ]; smt().
  have Hprod : ((_a.[i] + W32.of_int 4194304) `|>>>` q_bits) * W32.of_int q = W32.of_int (((to_sint _a.[i] + 4194304) %/ 8388608) * q).
  + rewrite W32.to_uint_eq W32.to_uintM !W32.of_uintK Hush /=; smt().
  have Hqv : q = 8380417 by done.
  have Hrange : -6283009 <= to_sint _a.[i] - ((to_sint _a.[i] + 4194304) %/ 8388608) * q <= 6283008.
  + have Hde : to_sint _a.[i] + 4194304 = (to_sint _a.[i] + 4194304) %/ 8388608 * 8388608 + (to_sint _a.[i] + 4194304) %% 8388608 by smt(divz_eq).
    have Hmc : 0 <= (to_sint _a.[i] + 4194304) %% 8388608 < 8388608 by smt(modz_cmp).
    rewrite /q; smt().
  rewrite Hprod W32.to_sintB_small.
  + rewrite W32.to_sintK_small /=; smt().
  rewrite W32.to_sintK_small //; rewrite /q /=; smt().
split.
+ apply Array256.tP => i Hi; rewrite /lifts_wpoly !mapiE 1,2:/# /= /BSWA_256u32.init initiE 1:/# /= (key i Hi).
  rewrite incoeffB incoeffM.
  have Hq0 : incoeff q = Zq.zero by apply Zq.asint_inj; rewrite incoeffK Zq.zeroE; smt().
  by rewrite Hq0; ring.
move => i Hi; have /= Hs := Hrng i Hi; rewrite /BSWA_256u32.init initiE 1:/# /= (key i Hi).
have Hde : to_sint _a.[i] + 4194304 = (to_sint _a.[i] + 4194304) %/ 8388608 * 8388608 + (to_sint _a.[i] + 4194304) %% 8388608 by smt(divz_eq).
have Hmc : 0 <= (to_sint _a.[i] + 4194304) %% 8388608 < 8388608 by smt(modz_cmp).
rewrite /q; smt().
qed.

lemma polynomial__reduce32_ph (_a : W32.t Array256.t) :
    phoare [ M.polynomial__reduce32 :
        polynomial = _a /\
        wpoly_srng (2^31 - 2^22 - 1) (2^31 - 2^22 - 1) _a
        ==>
        lifts_wpoly res = lifts_wpoly _a /\
        wpoly_srng 6283009 6283008 res
    ] = 1%r
  by conseq polynomial__reduce32_ll (polynomial__reduce32_correct _a).

(* ================================================================== *)
(* polynomial__pointwise_montgomery_multiply_and_reduce                 *)
(* Computes lhs[i] * rhs[i] in Zq via Montgomery reduction.           *)
(* Input:  wpoly_bmul_irng on both operands                            *)
(*         (NTT outputs satisfy this: wpoly_ntt_orng => wpoly_bmul_irng)*)
(* Output: liftm_wpoly res = basemul (lifts_wpoly lhs) (lifts_wpoly rhs)*)
(*           the product carries the Montgomery factor 2^-32: it is    *)
(*           read in Montgomery form (liftm), as invert_ntt consumes it *)
(*         wpoly_srng (q-1) (q-1) res  (from final Montgomery reduction) *)
(* ================================================================== *)

lemma polynomial__pointwise_montgomery_multiply_and_reduce_ll :
    islossless M.polynomial__pointwise_montgomery_multiply_and_reduce.
proof.
proc.
wp; while (0 <= offset <= (256 * 32) %/ 8 /\ offset %% 64 = 0)
         ((256 * 32) %/ 8 - offset); last by auto => /#.
move => *.
(* each loop body processes two 32-byte chunks via montgomery_multiply_and_reduce *)
wp; call (: true ==> true); 1: by islossless. (* second call *)
wp; call (: true ==> true); 1: by islossless. (* first call *)
by auto => /#.
qed.

(* ================================================================== *)
(* polynomial__conditionally_add_modulus                                 *)
(* Converts centered representative to standard [0, q-1]:              *)
(*   if coeff < 0 then coeff + q else coeff                           *)
(* Spec: lifts_wpoly res = lifts_wpoly _a  (Zq value preserved)       *)
(*       wpoly_urng q res                  (all in [0, q-1])          *)
(* ================================================================== *)

lemma polynomial__conditionally_add_modulus_ll :
    islossless M.polynomial__conditionally_add_modulus.
proof.
proc.
wp; while (0 <= offset <= (256 * 32) %/ 8 /\ offset %% 32 = 0)
         ((256 * 32) %/ 8 - offset); last by auto => /#.
by move => *; auto => /#.
qed.

lemma polynomial__conditionally_add_modulus_correct (_a : W32.t Array256.t) :
    hoare [ M.polynomial__conditionally_add_modulus :
        polynomial = _a /\
        wpoly_srng (q-1) (q-1) _a
        ==>
        lifts_wpoly res = lifts_wpoly _a /\
        wpoly_urng q res
    ].
proof.
proc => /=.
proc change ^while.1 : { lhs <- if (0 <= offset*8 <= 32*256-256) then BSWAS_256u32_256.sliceget polynomial (offset*8) else WArray1024.WArray1024.get256_direct (WArray1024.WArray1024.init32 (fun (i_0:int) => polynomial.[i_0])) offset; }; first (auto => /> &2; case (0 <= offset{2} * 8 <= 7936); [by move => *; rewrite -BSWAS_256u32_256_slicegetE 1:/# | by auto]).
proc change ^while.5 : { polynomial <- if (0 <= offset*8 <= 32*256-256) then BSWAS_256u32_256.sliceset polynomial (offset*8) lhs else Array256.init (WArray1024.WArray1024.get32 (WArray1024.WArray1024.set256_direct (WArray1024.WArray1024.init32 (fun (i_0:int) => polynomial.[i_0])) offset lhs)); }; first (auto => /> &2; case (0 <= offset{2} * 8 <= 7936); [by move => *; rewrite BSWAS_256u32_256_slicesetE 1:/# | by auto]).
unroll for ^while.
wp 162.
conseq (: polynomial = _a /\ wpoly_srng (q-1) (q-1) _a ==> polynomial = BSWA_256u32.init (fun (i:int) => if _a.[i] \slt W32.zero then _a.[i] + W32.of_int q else _a.[i])); last by circuit.
move => &hr [# _ Hsr] p0 ->; move: Hsr; rewrite /wpoly_srng !allP => Hsr; split.
+ apply Array256.tP => i Hi; rewrite mapiE 1:/# mapiE 1:/# /BSWA_256u32.init initiE 1:/# /=.
  have /= Hsi := Hsr i Hi; case: (_a.[i] \slt W32.zero) => Hlt //=.
  have Hq : to_sint (W32.of_int q) = q by rewrite to_sintE of_uintK /smod /=; smt().
  rewrite to_sintD_small Hq; first smt().
  rewrite incoeffD.
  have -> : incoeff q = Zq.zero by rewrite incoeff_eq0P dvdzz.
  by ring.
rewrite /wpoly_urng allP => k kb; have /= Hsk := Hsr k kb; rewrite /BSWA_256u32.init initiE 1:/# /=.
have Hq : to_sint (W32.of_int q) = q by rewrite to_sintE of_uintK /smod /=; smt().
have Hz : to_sint W32.zero = 0 by rewrite to_sintE of_uintK /smod /=.
rewrite sltE Hz; case: (to_sint _a.[k] < 0) => Hlt /=.
+ have Hv : to_sint (_a.[k] + of_int q) = to_sint _a.[k] + q by rewrite to_sintD_small Hq; smt().
  have Hnn : 0 <= to_sint (_a.[k] + of_int q) by smt().
  by rewrite -(W32.to_sint_unsigned _ Hnn) Hv; smt().
have Hnn : 0 <= to_sint _a.[k] by smt().
by rewrite -(W32.to_sint_unsigned _ Hnn); smt().
qed.

lemma polynomial__conditionally_add_modulus_ph (_a : W32.t Array256.t) :
    phoare [ M.polynomial__conditionally_add_modulus :
        polynomial = _a /\
        wpoly_srng (q-1) (q-1) _a
        ==>
        lifts_wpoly res = lifts_wpoly _a /\
        wpoly_urng q res
    ] = 1%r
  by conseq polynomial__conditionally_add_modulus_ll
            (polynomial__conditionally_add_modulus_correct _a).

end CommonReduceT.
