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

(* reduce32 on one coefficient: a - round(a / 2^23) * q. *)
op reduce32_w (a : W32.t) : W32.t =
  a - ((a + W32.of_int 4194304) `|>>>` 23) * W32.of_int 8380417.

lemma reduce32_wE (a : W32.t) :
    -(2^31 - 2^22 - 1) <= to_sint a <= 2^31 - 2^22 - 1 =>
    incoeff (to_sint (reduce32_w a)) = incoeff (to_sint a) /\
    -6283009 <= to_sint (reduce32_w a) <= 6283008.
proof.
(* The bounds of the quotient k and of the result, on the words. *)
have Hw : forall (x : W32.t),
    W32.of_int (-2143289343) \sle x => x \sle W32.of_int 2143289343 =>
    (W32.of_int (-255) \sle (x + W32.of_int 4194304) `|>>>` 23) /\
    ((x + W32.of_int 4194304) `|>>>` 23 \sle W32.of_int 255) /\
    (W32.of_int (-6283009) \sle reduce32_w x) /\ (reduce32_w x \sle W32.of_int 6283008).
+ by rewrite /reduce32_w; circuit.
move=> /= [Hs1 Hs2]; have := Hw a; rewrite !sleE !W32.to_sintK_small //=.
move=> /(_ Hs1 Hs2) [#] Hk1 Hk2 Hr1 Hr2; split=> //.
(* a = reduce32_w a + k * q holds on the words, and without overflow. *)
pose k := (a + W32.of_int 4194304) `|>>>` 23.
have Kk : W32.of_int (to_sint k) = k.
+ rewrite W32.to_sintE /smod; case: (2 ^ (32 - 1) <= to_uint k) => _ //=.
  by rewrite -(W32.of_int_mod (to_uint k - 4294967296)) -modzDr /= W32.of_int_mod.
have Ea : a = reduce32_w a + W32.of_int (to_sint k * q).
+ by rewrite /reduce32_w -W32.of_intM Kk /k; ring.
have Hkq : to_sint (W32.of_int (to_sint k * q)) = to_sint k * q.
+ by rewrite W32.to_sintK_small /q; smt().
have -> : to_sint a = to_sint (reduce32_w a) + to_sint k * q.
+ by rewrite -Hkq -W32.to_sintD_small -?Ea // Hkq /q; smt().
by rewrite incoeffD incoeffM (_ : incoeff q = Zq.zero) 1:incoeff_eq0P 1:dvdzz; ring.
qed.

(* The conditional addition of the modulus on one coefficient. *)
op caddq_w (c : W32.t) : W32.t =
  if c \slt W32.zero then c + W32.of_int 8380417 else c.

lemma caddq_w_val (c : W32.t) :
    -(q-1) <= W32.to_sint c <= q-1 =>
    0 <= W32.to_uint (caddq_w c) < q /\
    incoeff (W32.to_uint (caddq_w c)) = incoeff (W32.to_sint c).
proof.
move=> Hc; have Hq : to_sint (W32.of_int 8380417) = q by rewrite to_sintE of_uintK /smod.
have Hz : to_sint W32.zero = 0 by rewrite to_sintE of_uintK /smod.
rewrite /caddq_w sltE Hz; case: (to_sint c < 0) => Hlt /=.
+ have Hv : to_sint (c + W32.of_int 8380417) = to_sint c + q by rewrite to_sintD_small Hq; smt().
  have Hnn : 0 <= to_sint (c + W32.of_int 8380417) by smt().
  rewrite -(W32.to_sint_unsigned _ Hnn) Hv; split; 1: smt().
  by rewrite incoeffD (_ : incoeff q = Zq.zero) 1:incoeff_eq0P 1:dvdzz; ring.
have Hnn : 0 <= to_sint c by smt().
by rewrite -(W32.to_sint_unsigned _ Hnn); smt().
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
conseq (: polynomial = _a /\ wpoly_srng 2143289343 2143289343 _a ==>
          polynomial = BSWA_256u32.init (fun (i:int) => reduce32_w _a.[i])); last first.
+ by rewrite /reduce32_w; circuit.
move => &hr [# _ Hrng] p0 ->; move: Hrng; rewrite /wpoly_srng !allP => Hrng.
split.
+ apply Array256.tP => i Hi; rewrite /lifts_wpoly !mapiE 1,2:/# /= /BSWA_256u32.init initiE 1:/# /=.
  by have [-> _] := reduce32_wE _a.[i] (Hrng i Hi).
move => i Hi; rewrite /BSWA_256u32.init initiE 1:/# /=.
by have [_ ->] := reduce32_wE _a.[i] (Hrng i Hi).
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
conseq (: polynomial = _a /\ wpoly_srng (q-1) (q-1) _a ==>
          polynomial = BSWA_256u32.init (fun (i:int) => caddq_w _a.[i])); last first.
+ by rewrite /caddq_w; circuit.
move => &hr [# _ Hsr] p0 ->; move: Hsr; rewrite /wpoly_srng allP => Hsr.
have Hu : wpoly_urng q (BSWA_256u32.init (fun (i:int) => caddq_w _a.[i])).
+ rewrite /wpoly_urng allP => i Hi; rewrite /BSWA_256u32.init initiE 1:/# /=.
  by have [] := caddq_w_val _a.[i] (Hsr i Hi).
split; last exact Hu.
rewrite wpoly_urng_lifts_eq_liftu //; apply Array256.tP => i Hi.
rewrite /liftu_wpoly /lifts_wpoly !mapiE 1,2:/# /= /BSWA_256u32.init initiE 1:/# /=.
by have [_ ->] := caddq_w_val _a.[i] (Hsr i Hi).
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
