require import AllCore IntDiv List Distr DList DMap StdOrder StdBigop.
from Jasmin require import JWord.
require import Array256.
require import Parameters GFq Rq ConcreteDRing.
require import DistrExtras.
require MLDSA_ExpandS.
require MLDSAProof DVect.
require import JWordExtra.
require ChallengeFiber.
import IntOrder Bigint.

abstract theory MLDSATargetFIPS.

clone include MLDSA_ExpandS.MLDSA_ExpandS.
import Spec.
import Round ZModQ Zq PolyReduce MLDSAParams.

(* The target security spec (MLDSATarget, security/) at the ML-DSA
   parameters, over the FIPS 204 ring: the instantiation of every
   parameter of the target, with the canonical rejection tests (the
   short-circuit cascades of the implementation). The analogue of
   ConcreteMLDSA.ec of the security proof, for the ring of the
   specification. *)

(* -------------------------------------------------------------------- *)
(* Distributions of the hash outputs and of the seeds                   *)

op dseed : Bytes32.t distr = dmap (dlist W8.dword 32) Bytes32.of_list.
op dbytes64 : Bytes64.t distr = dmap (dlist W8.dword 64) Bytes64.of_list.
op dbytesCT : BytesCT.t distr = dmap (dlist W8.dword (lambda %/ 4)) BytesCT.of_list.

(* The probability of one output: 2^-512 for 64 bytes, 2^-(2 lambda) for c~ *)
op eps_mu : real = (1%r / 256%r) ^ 64.
op eps_ct : real = (1%r / 256%r) ^ (lambda %/ 4).

(* -------------------------------------------------------------------- *)
(* The ring elements of the target and the polynomials of FIPS 204       *)

(* masking distribution: coefficients uniform in [-gamma1 + 1, gamma1] *)
op dmask : polyXnD1 distr = dmap (dpoly (-gamma1 + 1) gamma1) poly2alg.

(* The coefficient list of a ring element is its NTT representation (the
   one the implementation computes with, and declassifies for t0 and c);
   ExpandA samples A in the NTT domain. *)
op toRq (cs : int list) : polyXnD1 = poly2alg (invntt (Array256.of_list witness (map incoeff cs))).
op ofRq (r : polyXnD1) : int list = map asint (Array256.to_list (ntt (alg2poly r))).

(* a challenge encoding (256 coefficients in {-1, 0, 1}) as a ring element *)
op to_challenge (cs : int list) : polyXnD1 = polyLX (map incoeff cs).

(* -------------------------------------------------------------------- *)
(* Vectors over the ring and the rejection tests                        *)

clone import DVect as DV with
  theory DR <= ConcreteDRing.DR,
  op HL.alpha <- 2*gamma2,
  op HL.d     <- d
proof
  HL.ge2_alpha,
  HL.alpha_halfq_le,
  HL.even_alpha,
  HL.alpha_almost_divides_q,
  HL.d_bound,
  HL.S.inhabited.
realize HL.ge2_alpha by smt(gamma2_bound).
realize HL.even_alpha by smt().
realize HL.alpha_halfq_le by smt(gamma2_bound).
realize HL.alpha_almost_divides_q by apply gamma2_div.
realize HL.d_bound by split.
realize HL.S.inhabited by exists (poly_highbits (2 * gamma2) zeroXnD1); exists zeroXnD1.

import DV.MatRq.

(* Weight of the first i polynomials of a hint *)
op hint_weight (h : bool list list) (i : int) =
  BIA.bigi predT (fun j => count idfun (nth [] h j)) 0 i.

(* The weight check as a short-circuit cascade over the kvec polynomials
   of the hint: the index of the first polynomial at which the accumulated
   weight exceeds w_hint (None when the hint is accepted). *)
op hint_fail_idx (h : bool list list) : int option =
  let i = find (fun i => w_hint < hint_weight h (i + 1)) (range 0 kvec) in
  if i < kvec then Some i else None.

lemma hint_fail_idx_range h i : hint_fail_idx h = Some i => 0 <= i < kvec.
proof.
rewrite /hint_fail_idx /=.
case: (find (fun i => w_hint < hint_weight h (i + 1)) (range 0 kvec) < kvec) => //= hlt <-.
by rewrite hlt find_ge0.
qed.

lemma hint_weight_le h i j : 0 <= i <= j => hint_weight h i <= hint_weight h j.
proof.
move=> [ge0_i le_ij]; rewrite /hint_weight (BIA.big_cat_int i 0 j) //.
have := Bigint.sumr_ge0 predT (fun j => count idfun (nth [] h j)) (range i j) _.
- by move=> a _ /=; exact count_ge0.
smt().
qed.

(* The weight of a hint of kvec polynomials is the weight of its flatten *)
lemma hint_weight_total h :
  size h = kvec => hint_weight h kvec = count idfun (flatten h).
proof.
move=> <-; rewrite /hint_weight.
have -> : count idfun (flatten h) = BIA.big predT (count idfun) h.
- by elim: h => [|x h ih]; rewrite ?flatten_nil ?BIA.big_nil // flatten_cons count_cat BIA.big_cons /predT /= ih.
by rewrite (BIA.big_nth []).
qed.

(* The cascade accepts exactly the hints of weight at most w_hint *)
lemma hint_fail_idx_total h :
  size h = kvec => hint_fail_idx h = None <=> count idfun (flatten h) <= w_hint.
proof.
move=> sz; rewrite -hint_weight_total // /hint_fail_idx /=.
have -> : (find (fun i => w_hint < hint_weight h (i + 1)) (range 0 kvec) < kvec) =
          has (fun i => w_hint < hint_weight h (i + 1)) (range 0 kvec).
- by rewrite has_find size_range; smt(gt0_k).
case: (has (fun i => w_hint < hint_weight h (i + 1)) (range 0 kvec)) => /= hh.
- move/hasP: hh => [i [/mem_range rg_i hi]].
  by have := hint_weight_le h (i + 1) kvec _; smt().
have := hh; rewrite hasPn => /(_ (kvec - 1) _); 1: by rewrite mem_range; smt(gt0_k).
by move=> /= /lezNgt.
qed.

(* The canonical rejection tests: short-circuit cascades over the
   polynomials, leaking the index of the first failing polynomial
   ([DV.first_fail]); the weight check of the hint is [hint_fail_idx]
   above. The test on [c t0] is a plain norm test (its inputs are leaked). *)
op z_ok   (p : polyXnD1) = ConcreteDRing.DR.cnorm p < gamma1 - Beta.
op r0_ok  (p : polyXnD1) = ConcreteDRing.DR.cnorm p < gamma2 - Beta.

op check_z   (z : vector)  = first_fail z_ok lvec z.
op check_r0  (w0 : vector) = first_fail r0_ok kvec (lowBitsV w0).
op check_ct0 (v : vector)  = inf_normv v < gamma2.

(* -------------------------------------------------------------------- *)
(* The challenge distribution                                           *)

lemma to_challenge_inj_in (c c' : int list) :
  size c = 256 => all (fun c => c = -1 \/ c = 0 \/ c = 1) c =>
  size c' = 256 => all (fun c => c = -1 \/ c = 0 \/ c = 1) c' =>
  to_challenge c = to_challenge c' => c = c'.
proof.
move=> hs ha hs' ha' heq; apply (eq_from_nth 0); 1: by rewrite hs hs'.
move=> i; rewrite hs => hi.
have := congr1 (fun (p : polyXnD1) => p.[i]) _ _ heq.
rewrite /to_challenge /= !polyLXE ?size_map ?hs ?hs' // !(nth_map 0) ?hs ?hs' //.
move/(congr1 asint); rewrite !incoeffK.
move: ha ha'; rewrite -!(List.all_nthP _ _ 0) hs hs' => /(_ i hi) h1 /(_ i hi) h2.
smt().
qed.

(* The pre-image sampler of [ChallengeFiber], for the FIPS 204 ring *)
clone ChallengeFiber as CF with
  op Params.q <- Parameters.q,
  op Params.n <- Parameters.n,
  op Params.eta_ <- Eta,
  op Params.k <- kvec,
  op Params.l <- lvec,
  op Params.gamma1 <- gamma1,
  op Params.gamma2 <- gamma2,
  op Params.beta_ <- Beta,
  op Params.tau <- tau,
  op Params.d <- Parameters.d,
  theory DR <- ConcreteDRing.DR,
  type in_t <- BytesCT.t,
  op to_concrete <- to_challenge
proof *.
realize Params.prime_q by exact Parameters.prime_q.
realize Params.gt0_n by exact gt0_n.
realize Params.gt0_eta by exact gt0_eta.
realize Params.gt0_k by exact gt0_k.
realize Params.gt0_l by exact gt0_l.
realize Params.gt0_beta by exact gt0_beta.
realize Params.tau_bound by exact tau_bound.
realize Params.gt0_d by exact gt0_d.
realize Params.eta_tau_leq_b by exact eta_tau_leq_b.
realize Params.pow2_d_lt_q by done.
realize Params.gamma2_bound by exact gamma2_bound.
realize Params.gamma2_div by exact gamma2_div.
realize Params.beta_gamma1_lt by exact beta_gamma1_lt.
realize Params.beta_gamma2_lt by exact beta_gamma2_lt.
realize to_concrete_inj_in by exact to_challenge_inj_in.

op is_ch (c : int) = c = -1 \/ c = 0 \/ c = 1.

lemma to_challengeE (l : int list) i :
  size l = 256 => 0 <= i < 256 => (to_challenge l).[i] = incoeff (nth 0 l i).
proof. by move=> hs hi; rewrite /to_challenge polyLXE ?size_map ?hs // (nth_map 0) 1:/#. qed.

lemma big_b2i ['a] (P : 'a -> bool) (s : 'a list) :
  BIA.big predT (fun x => b2i (P x)) s = count P s.
proof.
elim: s => [|x s ih]; 1: by rewrite BIA.big_nil.
by rewrite BIA.big_cons /predT /= ih.
qed.

(* The l1 norm of a ring element with coefficients in {-1, 0, 1} is its
   number of nonzero coefficients *)
lemma l1_norm_to_challenge (l : int list) :
  size l = 256 => all is_ch l =>
  l1_norm (to_challenge l) = count (fun p => nth 0 l p <> 0) (range 0 256).
proof.
move=> hs /(List.all_nthP _ _ 0) hl.
rewrite /l1_norm /l1 /range -big_b2i.
apply BIA.eq_big_seq => i /mem_range hi /=.
rewrite alg2polyiE // to_challengeE // abs_incoeff; 1: smt().
by have := hl i _; [rewrite hs /# | rewrite /is_ch /b2i => /#].
qed.

lemma dC_equiv_CF : ConcreteDRing.DR.dC tau = CF.dCR.
proof.
apply distr_eq_supp.
- exact ConcreteDRing.DR.dC_uni.
- exact CF.dCR_uni.
- by apply ConcreteDRing.DR.dC_ll; smt(tau_bound).
- exact/dmap_ll/CF.SIB.dI_ll.
move=> c; rewrite ConcreteDRing.DR.supp_dC CF.dCR_supp; split.
- move=> [h1 h2]; pose l := mkseq (fun i => crepr c.[i]) 256.
  have hs : size l = 256 by rewrite size_mkseq.
  have hl : all is_ch l.
  + apply/List.allP => x /mkseqP [i [hi ->]] /=.
    have := inf_normXE c 1 i _ h1 hi => //.
    by rewrite /ZModQ."`|_|" /is_ch; smt().
  have hc : to_challenge l = c.
  + apply polyXnD1_eqP => i hi; rewrite to_challengeE 1:hs //.
    by rewrite nth_mkseq //= creprK.
  exists l; rewrite hc /= /CF.Zinv; split; 1: by split => //; move: hl; apply List.all_imp_in => x _.
  split; 1: smt().
  by rewrite /CF.nzpos size_filter /= -l1_norm_to_challenge // hc h2 /CF.i0; ring.
move=> [l [[[hs hl] [_ hn]] ->]]; split.
- apply inf_norm_le => // i hi; rewrite to_challengeE 1:hs //.
  have /(List.all_nthP _ _ 0) /(_ i _) := hl; 1: by rewrite hs.
  by move=> /= hi'; rewrite abs_incoeff; smt().
rewrite l1_norm_to_challenge //; move: hn; rewrite /CF.nzpos size_filter /CF.i0 /= => ->; ring.
qed.

(* -------------------------------------------------------------------- *)
(* The security proof (MLDSAProof) instantiated at the parameters of the
   specification; the target security spec is the nested theory [MP.T].
   The statistical assumptions of the proof ([check_mx], [A0], [eps_comm],
   [eps_check], [eps_low]) and the query bounds stay abstract.           *)

clone MLDSAProof.MLDSAProof as MP with
  op T.Params.q <- Parameters.q,
  op T.Params.n <- Parameters.n,
  op T.Params.eta_ <- Eta,
  op T.Params.k <- kvec,
  op T.Params.l <- lvec,
  op T.Params.gamma1 <- gamma1,
  op T.Params.gamma2 <- gamma2,
  op T.Params.beta_ <- Beta,
  op T.Params.tau <- tau,
  op T.Params.d <- Parameters.d,
  theory T.DR <- ConcreteDRing.DR,
  theory T.DV <- DV,
  op T.kappa_max <- kappa_max,
  op T.dRq_mask <- dmask,
  op T.toRq <- toRq,
  op T.ofRq <- ofRq,
  op T.check_z <- check_z,
  op T.check_r0 <- check_r0,
  op T.check_hint <- hint_fail_idx,
  op T.check_ct0 <- check_ct0,
  op T.Mz <- lvec,
  op T.Mr0 <- kvec,
  op T.Mhint <- kvec,
  type T.M <- W8.t list,
  type T.seed <- Bytes32.t,
  type T.tr_t <- Bytes64.t,
  type T.mu_t <- Bytes64.t,
  type T.ctilde <- BytesCT.t,
  op T.dseed <- dseed,
  op T.to_concrete <- to_challenge,
  op T.dtr <- dbytes64,
  op T.dmu <- dbytes64,
  op T.dct <- dbytesCT,
  op T.eps_mu <- eps_mu,
  op T.eps_ct <- eps_ct
proof T.Params.prime_q,
      T.Params.gt0_n,
      T.Params.gt0_eta,
      T.Params.gt0_k,
      T.Params.gt0_l,
      T.Params.gt0_beta,
      T.Params.tau_bound,
      T.Params.gt0_d,
      T.Params.eta_tau_leq_b,
      T.Params.pow2_d_lt_q,
      T.Params.gamma2_bound,
      T.Params.gamma2_div,
      T.Params.beta_gamma1_lt,
      T.Params.beta_gamma2_lt,
      T.gt0_kappa_max,
      T.q_le_2_23,
      T.dRq_mask_ll,
      T.dRq_mask_uni,
      T.dRq_mask_supp_box,
      T.dRq_mask_supp_bound,
      T.toRqK,
      T.ofRqK,
      T.ofRq_valid,
      T.ge0_Mz,
      T.ge0_Mr0,
      T.ge0_Mhint,
      T.check_z_range,
      T.check_r0_range,
      T.check_hint_range,
      T.check_z_None,
      T.check_r0_None,
      T.check_ct0_None,
      T.check_z_shift,
      T.dseed_ll,
      T.dseed_uni,
      T.dseed_fu,
      T.to_concrete_inj_in,
      T.dtr_ll,
      T.dtr_uni,
      T.dtr_fu,
      T.dmu_ll,
      T.dmu_uni,
      T.dmu_fu,
      T.dct_ll,
      T.dct_uni,
      T.dct_fu,
      T.dmu_max,
      T.dct_max,
      dC_equiv.
realize T.Params.prime_q by exact Parameters.prime_q.
realize T.Params.gt0_n by exact gt0_n.
realize T.Params.gt0_eta by exact gt0_eta.
realize T.Params.gt0_k by exact gt0_k.
realize T.Params.gt0_l by exact gt0_l.
realize T.Params.gt0_beta by exact gt0_beta.
realize T.Params.tau_bound by exact tau_bound.
realize T.Params.gt0_d by exact gt0_d.
realize T.Params.eta_tau_leq_b by exact eta_tau_leq_b.
realize T.Params.pow2_d_lt_q by done.
realize T.Params.gamma2_bound by exact gamma2_bound.
realize T.Params.gamma2_div by exact gamma2_div.
realize T.Params.beta_gamma1_lt by exact beta_gamma1_lt.
realize T.Params.beta_gamma2_lt by exact beta_gamma2_lt.
realize T.gt0_kappa_max by case: kappa_max_bnd.
realize T.q_le_2_23 by done.
realize T.dRq_mask_ll.
by apply dmap_ll; apply Rq.dpoly_ll; case: gamma1_cases => ->.
qed.
realize T.dRq_mask_uni.
apply dmap_uni_in_inj; last by apply Rq.dpoly_uni; case: gamma1_cases => ->.
by move=> x y _ _; apply (can_inj _ _ alg2polyK).
qed.
realize T.dRq_mask_supp_box.
move=> x hx; rewrite /dmask supp_dmap; exists (alg2poly x); rewrite poly2algK /=.
rewrite supp_dpoly; 1,2: by case: gamma1_cases => ->.
move=> i rgi; have := inf_normXE x (gamma1 - 1) i _ hx rgi; 1: by case: gamma1_cases => ->.
by rewrite alg2polyiE // /ZModQ."`|_|"; smt().
qed.
realize T.dRq_mask_supp_bound.
move=> x; rewrite /dmask supp_dmap => -[p [hp ->]].
apply inf_norm_le; 1: by case: gamma1_cases => ->.
move=> i rgi; move: hp; rewrite supp_dpoly; 1,2: by case: gamma1_cases => ->.
move=> /(_ i rgi); rewrite poly2algiE // /ZModQ."`|_|"; smt().
qed.
realize T.toRqK.
move=> r; rewrite /toRq /ofRq -map_comp.
rewrite (eq_map _ idfun); 1: by move=> c; rewrite /(\o) asintK.
by rewrite map_id Array256.to_listK invnttK poly2algK.
qed.
realize T.ofRqK.
move=> xs hs hall; rewrite /ofRq /toRq alg2polyK nttK Array256.of_listK; 1: by rewrite size_map.
rewrite -map_comp -{2}(map_id xs); apply eq_in_map => x hx; rewrite /(\o) /idfun /= incoeffK modz_small //.
by move/List.allP: hall => /(_ x hx) /#.
qed.
realize T.ofRq_valid.
move=> r; rewrite /ofRq size_map Array256.size_to_list /=.
by apply/List.allP => x /mapP [y [_ ->]]; exact rg_asint.
qed.
realize T.ge0_Mz by smt(gt0_l).
realize T.ge0_Mr0 by smt(gt0_k).
realize T.ge0_Mhint by smt(gt0_k).
realize T.check_z_range by move=> z i; rewrite /check_z => /first_fail_range.
realize T.check_r0_range by move=> w0 i; rewrite /check_r0 => /first_fail_range.
realize T.check_hint_range by exact hint_fail_idx_range.
realize T.check_z_None.
move=> z hs; rewrite /check_z /z_ok; apply first_fail_norm => //.
smt(beta_gamma1_lt).
qed.
realize T.check_r0_None.
move=> w0 hs; rewrite /check_r0 /r0_ok; apply first_fail_norm.
- smt(beta_gamma2_lt).
by rewrite size_lowBitsV.
qed.
realize T.check_ct0_None by done.
realize T.check_z_shift by exact first_fail_z_shift.
realize T.dseed_ll by apply dmap_ll; apply dlist_ll; exact W8.dword_ll.
realize T.dseed_uni.
apply dmap_uni_in_inj; last by apply dlist_uni; exact W8.dword_uni.
move=> x y; rewrite !supp_dlist // => -[hx _] [hy _] hxy.
by rewrite -(Bytes32.of_listK x) // -(Bytes32.of_listK y) // hxy.
qed.
realize T.dseed_fu.
move=> b; rewrite supp_dmap; exists (Bytes32.to_list b); rewrite Bytes32.to_listK /= supp_dlist // Bytes32.size_to_list /=.
by apply/List.allP => x _; exact W8.dword_fu.
qed.
realize T.to_concrete_inj_in by exact to_challenge_inj_in.
realize T.dtr_ll by apply dmap_ll; apply dlist_ll; exact W8.dword_ll.
realize T.dtr_uni.
apply dmap_uni_in_inj; last by apply dlist_uni; exact W8.dword_uni.
move=> x y; rewrite !supp_dlist // => -[hx _] [hy _] hxy.
by rewrite -(Bytes64.of_listK x) // -(Bytes64.of_listK y) // hxy.
qed.
realize T.dtr_fu.
move=> b; rewrite supp_dmap; exists (Bytes64.to_list b); rewrite Bytes64.to_listK /= supp_dlist // Bytes64.size_to_list /=.
by apply/List.allP => x _; exact W8.dword_fu.
qed.
realize T.dmu_ll by apply dmap_ll; apply dlist_ll; exact W8.dword_ll.
realize T.dmu_uni.
apply dmap_uni_in_inj; last by apply dlist_uni; exact W8.dword_uni.
move=> x y; rewrite !supp_dlist // => -[hx _] [hy _] hxy.
by rewrite -(Bytes64.of_listK x) // -(Bytes64.of_listK y) // hxy.
qed.
realize T.dmu_fu.
move=> b; rewrite supp_dmap; exists (Bytes64.to_list b); rewrite Bytes64.to_listK /= supp_dlist // Bytes64.size_to_list /=.
by apply/List.allP => x _; exact W8.dword_fu.
qed.
realize T.dct_ll.
by apply dmap_ll; apply dlist_ll; exact W8.dword_ll.
qed.
realize T.dct_uni.
have ge0_ct : 0 <= lambda %/ 4 by have := param_sets; smt().
apply dmap_uni_in_inj; last by apply dlist_uni; exact W8.dword_uni.
move=> x y; rewrite !supp_dlist // => -[hx _] [hy _] hxy.
by rewrite -(BytesCT.of_listK x) // -(BytesCT.of_listK y) // hxy.
qed.
realize T.dct_fu.
have ge0_ct : 0 <= lambda %/ 4 by have := param_sets; smt().
move=> b; rewrite supp_dmap; exists (BytesCT.to_list b); rewrite BytesCT.to_listK /= supp_dlist // BytesCT.size_to_list /=.
by apply/List.allP => x _; exact W8.dword_fu.
qed.
realize T.dmu_max.
move=> x; rewrite /dbytes64 (dmap1E_can _ _ Bytes64.to_list); 1: exact Bytes64.to_listK.
- by move=> a; rewrite supp_dlist // => -[ha _]; rewrite Bytes64.of_listK.
by rewrite dlist1E // Bytes64.size_to_list /= (Bigreal.BRM.eq_big_seq _ (fun _ => 1%r / 256%r)) 2:Bigreal.mulr_const ?Bytes64.size_to_list // => w _ /=; rewrite DW8.mu1_dword.
qed.
realize T.dct_max.
have ge0_ct : 0 <= lambda %/ 4 by have := param_sets; smt().
move=> x; rewrite /dbytesCT (dmap1E_can _ _ BytesCT.to_list); 1: exact BytesCT.to_listK.
- by move=> a; rewrite supp_dlist // => -[ha _]; rewrite BytesCT.of_listK.
by rewrite dlist1E // BytesCT.size_to_list /= (Bigreal.BRM.eq_big_seq _ (fun _ => 1%r / 256%r)) 2:Bigreal.mulr_const ?BytesCT.size_to_list // => w _ /=; rewrite DW8.mu1_dword.
qed.

realize dC_equiv.
(* [T.SIB.dC] and [CF.dCR] are the same distribution, up to the unfolding
   of the two clones of SampleInBallDefs *)
have := dC_equiv_CF; rewrite /ConcreteDRing.DR.dC => ->.
by rewrite /CF.dCR /T.SIB.dC /CF.to_c /(\o).
qed.

end MLDSATargetFIPS.
