(**
  The link between the integer-level NTT development (`Nttalg`,
  `Fnttalg`, `Inttalg`) and the closed-form transforms of the
  specification (`Spec.Rq`).

  Read through `lifts_wpoly`, the integer congruences become equations
  in Zq:

  - the forward transform *is* the specification's `ntt`, with no
    Montgomery factor (the zeta tables carry 2^32, `mmr` removes it);
  - the inverse transform is `invntt` up to exactly one Montgomery
    factor: `iscale` multiplies by 41978 = 2^64 / 256 mod q, i.e. by
    2^32 / 256 after `mmr`, and the tree contributes 256.

  The inverse link needs no NTT pre-image from its caller: since
  `ntt (invntt v) = v` (`Rq.nttK`), the pre-image of any reduced input
  is `invntt` of its lift.
*)

(* -------------------------------------------------------------------- *)
require import AllCore List IntDiv BitEncoding StdOrder StdBigop.
(*---*) import IntOrder Bigint.

from Jasmin require import JWord.

require import Array256.

(* -------------------------------------------------------------------- *)
require import Nttspec Nttzetas Nttalg Fnttalg Inttalg.

from Spec require import Parameters GFq Rq MLDSA_W32_Rep.
(*---*) import Round ZModQ Zq PolyReduce.BasePoly.BigCf.BCA.

(* ==================================================================== *)
(* From integer congruences to Zq                                       *)
(* ==================================================================== *)
lemma incoeff_sum (f : int -> int) (a b : int) :
  incoeff (BIA.bigi predT f a b) = bigi predT (fun i => incoeff (f i)) a b.
proof.
elim: (range a b) => [|x s ih]; first by rewrite BIA.big_nil big_nil incoeff0.
by rewrite BIA.big_consT big_consT incoeffD ih.
qed.

lemma incoeff_zpw (e : int) : incoeff (zpw e) = ZModpRing.exp zroot e.
proof.
by rewrite /zpw /Nttlogspec.zeta_ incoeff_exp modz_ge0 //= -zroot_mod.
qed.

lemma lifts_wpolyE (p : W32.t Array256.t) (i : int) :
  0 <= i < 256 => (lifts_wpoly p).[i] = incoeff (sval p.[i]).
proof. by move=> rgi; rewrite /lifts_wpoly mapiE. qed.

(* the implementation evaluates at exactly the specification's points *)
lemma E0_nttexp (j : int) : 0 <= j < 256 => E 0 j = nttexp j.
proof.
move=> rgj; rewrite /E /nttexp /br (_ : Nttlogspec.bitrev8 = BitReverse.bsrev 8) //=.
rewrite (BitReverse.bsrev_cat 1 8 j) //= (BitReverse.bsrev_cat 7 8 (j %/ 2 + 128)) //=.
rewrite (_ : (j %/ 2 + 128) %/ 128 = 1) 1:/# -(BitReverse.bsrev_mod 7 (j %/ 2 + 128)) /=.
rewrite (_ : (j %/ 2 + 128) %% 128 = j %/ 2) 1:/# BitReverse.bsrev1 //.
rewrite -(BitReverse.bsrev_mod 1 j) /=.
have [->|->] : j %% 2 = 0 \/ j %% 2 = 1 by smt().
- by rewrite BitReverse.bsrev0 /=; ring.
- by rewrite BitReverse.bsrev1 //=; ring.
qed.

(* the closed-form sum of the integer development is the spec's NTT *)
lemma nttsum_link (p : W32.t Array256.t) (j : int) : 0 <= j < 256 =>
    incoeff (BIA.bigi predT (fun s => zpw (E 0 j * s) * sval p.[s]) 0 256)
  = (ntt (lifts_wpoly p)).[j].
proof.
move=> rgj; rewrite incoeff_sum /ntt initiE //= E0_nttexp //.
apply eq_big_int => s rgs /=.
by rewrite incoeffM incoeff_zpw lifts_wpolyE // ZModpRing.mulrC.
qed.

(* ==================================================================== *)
(* Forward transform                                                    *)
(* ==================================================================== *)
lemma ntt_link (p : W32.t Array256.t) (B : int) :
  0 <= B => B + 8 * q < 2^31 => cbnd p B =>
     cbnd (reduce_tree p 0) (B + 8 * q)
  /\ lifts_wpoly (reduce_tree p 0) = ntt (lifts_wpoly p).
proof.
move=> ge0B hB hbnd; have [hb hs] := ntt_alg p B ge0B hB hbnd.
split=> //; apply/Array256.ext_eq => j rgj.
by rewrite lifts_wpolyE // -nttsum_link // -eq_incoeff /coeffcgr hs.
qed.

(* ==================================================================== *)
(* Inverse transform                                                    *)
(* ==================================================================== *)
lemma lifts_unlift (u : poly) : lifts_wpoly (unlift_poly u) = u.
proof.
apply/Array256.ext_eq => i rgi.
rewrite lifts_wpolyE // /unlift_poly mapiE //= W32.to_sintK_small.
- by have := rg_asint u.[i]; smt().
by rewrite asintK.
qed.

lemma intt_link (v : W32.t Array256.t) (B : int) :
  q <= B => 2^8 * B < 2^31 => cbnd v B =>
     cbnd (iscale (invtree v 8)) q
  /\ lifts_wpoly (iscale (invtree v 8)) = invntt (liftm_wpoly v).
proof.
move=> leqB hB hbnd.
pose u := invntt (lifts_wpoly v).
have hv : forall i, 0 <= i < 256 =>
  sval v.[i] %% q = nttsum (unlift_poly u) 0 i 0 %% q.
- move=> i rgi; rewrite /nttsum /=.
  rewrite eq_incoeff (nttsum_link (unlift_poly u)) //.
  by rewrite lifts_unlift /u nttK lifts_wpolyE.
have [hb hs] := intt_ntt_alg (unlift_poly u) v B leqB hB hbnd hv.
split=> //; apply/Array256.ext_eq => i rgi.
rewrite /liftm_wpoly invntt_scale scaleE // lifts_wpolyE //.
have := hs i rgi; rewrite eq_incoeff => ->.
by rewrite incoeffM -lifts_wpolyE // lifts_unlift.
qed.

(* ==================================================================== *)
(* Ranges                                                               *)
(* ==================================================================== *)
lemma srng_cbnd (p : W32.t Array256.t) (b : int) :
  wpoly_srng b b p <=> cbnd p b.
proof.
rewrite /wpoly_srng /cbnd allP; split=> h i rgi; have := h i rgi; smt().
qed.

(* the last operation of the inverse NTT, on every coefficient *)
lemma iscale_rng (p : W32.t Array256.t) :
  wpoly_srng invntt_obound invntt_obound (iscale p).
proof.
rewrite /wpoly_srng allP => i rgi /=; rewrite iscaleiE //.
have := mmr_bnd_prod p.[i] (W32.of_int 41978) (2^31 * 41978) _.
- rewrite sval41978 normrM /=; have := W32.to_sint_cmp p.[i]; smt().
by rewrite /invntt_obound /Nttlogspec.q /=; smt().
qed.

(* ==================================================================== *)
(* Pointwise (NTT-domain) multiplication                                *)
(* ==================================================================== *)
(* the result is in Montgomery form: read through liftm, the 2^-32 of   *)
(* mmr is gone                                                          *)
lemma pwmul_link (a b : W32.t Array256.t) :
  liftm_wpoly (pwmul a b) = basemul (lifts_wpoly a) (lifts_wpoly b).
proof.
apply/Array256.ext_eq => i rgi.
rewrite /liftm_wpoly scaleE // basemulE // !lifts_wpolyE // /pwmul initiE //=.
by rewrite /mont -!incoeffM -eq_incoeff /coeffcgr mmr_cgr.
qed.

(* two operands below 9q in magnitude give a reduced product *)
lemma pwmul_rng (a b : W32.t Array256.t) :
  wpoly_bmul_irng a => wpoly_bmul_irng b => wpoly_srng (q-1) (q-1) (pwmul a b).
proof.
rewrite /wpoly_bmul_irng /wpoly_srng !allP => ha hb i rgi /=.
rewrite /pwmul initiE //=.
have := mmr_bnd_prod a.[i] b.[i] ((9*q-1) * (9*q-1)) _.
- rewrite normrM; apply ler_pmul; smt().
by rewrite /Nttlogspec.q /=; smt().
qed.
