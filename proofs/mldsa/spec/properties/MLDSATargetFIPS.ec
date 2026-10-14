require import AllCore IntDiv List Distr DList.
from Jasmin require import JWord.
require import Array256.
require import Parameters GFq Rq ConcreteDRing.
require import Spec65.
import MLDSA65.
require MLDSATarget.
import Round ZModQ Zq PolyReduce MLDSAParams.

(* The target security spec at the ML-DSA parameters, over the FIPS 204 ring *)

op dmask : polyXnD1 distr = dmap (dpoly (-gamma1 + 1) gamma1) poly2alg.

op toRq (cs : int list) : polyXnD1 = poly2alg (invntt (Array256.of_list witness (map incoeff cs))).
op ofRq (r : polyXnD1) : int list = map asint (Array256.to_list (ntt (alg2poly r))).

op check_hw (h : bool list list) : bool = count idfun (flatten h) <= w_hint.

op dseed : Bytes32.t distr = dmap (dlist W8.dword 32) Bytes32.of_list.

op to_challenge (cs : int list) : polyXnD1 = polyLX (map incoeff cs).

clone MLDSATarget.MLDSATarget as TF with
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
  op kappa_max <- kappa_max,
  op dRq_mask <- dmask,
  op toRq <- toRq,
  op ofRq <- ofRq,
  op check_hw <- check_hw,
  type M <- W8.t list,
  type seed <- Bytes32.t,
  type tr_t <- Bytes64.t,
  type mu_t <- Bytes64.t,
  type ctilde <- BytesCT.t,
  op dseed <- dseed,
  type SIB.B.byte <- W8.t,
  op SIB.B.to_int <- W8.to_uint,
  op SIB.B.from_int <- W8.of_int,
  op SIB.to_concrete <- to_challenge
proof *, SIB.B.tK, SIB.B.to_int_in_surj.
realize Params.prime_q by exact Parameters.prime_q.
realize Params.gt0_n by exact gt0_n.
realize Params.gt0_eta by exact gt0_eta.
realize Params.gt0_k by exact gt0_k.
realize Params.gt0_l by exact gt0_l.
realize Params.gt0_beta by exact gt0_beta.
realize Params.tau_bound by exact tau_bound.
realize Params.gt0_d by exact gt0_d.
realize Params.eta_tau_leq_b by exact eta_tau_leq_b.
realize Params.ub_d.
have -> : 2 ^ d = 8192 by do 12!(rewrite expr_pred //=); rewrite expr1.
by rewrite /gamma2 /tau /gamma2_div /Params65.tau /Params65.gamma2_div.
qed.
realize Params.gamma2_bound by exact gamma2_bound.
realize Params.gamma2_div by exact gamma2_div.
realize Params.beta_gamma1_lt by exact beta_gamma1_lt.
realize Params.beta_gamma2_lt by exact beta_gamma2_lt.
realize DV.HL.d_bound by split.
realize DV.HL.S.inhabited by exists (poly_highbits (2 * gamma2) zeroXnD1); exists zeroXnD1.
realize gt0_kappa_max by case: kappa_max_bnd.
realize dRq_mask_ll.
have hg : gamma1 = 524288 by rewrite /gamma1 /gamma1_log /Params65.gamma1_log.
by apply dmap_ll; apply Rq.dpoly_ll; rewrite hg.
qed.
realize dRq_mask_uni.
have hg : gamma1 = 524288 by rewrite /gamma1 /gamma1_log /Params65.gamma1_log.
apply dmap_uni_in_inj; last by apply Rq.dpoly_uni; rewrite hg.
by move=> x y _ _; apply (can_inj _ _ alg2polyK).
qed.
realize toRqK.
move=> r; rewrite /toRq /ofRq -map_comp.
rewrite (eq_map _ idfun); 1: by move=> c; rewrite /(\o) asintK.
by rewrite map_id Array256.to_listK invnttK poly2algK.
qed.
realize ofRqK.
move=> xs hs hall; rewrite /ofRq /toRq alg2polyK nttK Array256.of_listK; 1: by rewrite size_map.
rewrite -map_comp -{2}(map_id xs); apply eq_in_map => x hx; rewrite /(\o) /idfun /= incoeffK modz_small //.
by move/List.allP: hall => /(_ x hx) /#.
qed.
realize dseed_ll by apply dmap_ll; apply dlist_ll; exact W8.dword_ll.
realize dseed_uni.
apply dmap_uni_in_inj; last by apply dlist_uni; exact W8.dword_uni.
move=> x y; rewrite !supp_dlist // => -[hx _] [hy _] hxy.
by rewrite -(Bytes32.of_listK x) // -(Bytes32.of_listK y) // hxy.
qed.
realize dseed_fu.
move=> b; rewrite supp_dmap; exists (Bytes32.to_list b); rewrite Bytes32.to_listK /= supp_dlist // Bytes32.size_to_list /=.
by apply/List.allP => x _; exact W8.dword_fu.
qed.
realize SIB.to_concrete_inj.
move=> c c' [hs ha] [hs' ha'] heq; apply (eq_from_nth 0); 1: by rewrite hs hs'.
move=> i; rewrite hs => hi.
have := congr1 (fun (p : polyXnD1) => p.[i]) _ _ heq.
rewrite /to_challenge /= !polyLXE ?size_map ?hs ?hs' // !(nth_map 0) ?hs ?hs' //.
move/(congr1 asint); rewrite !incoeffK.
move: ha ha'; rewrite -!(List.all_nthP _ _ 0) hs hs' => /(_ i hi) h1 /(_ i hi) h2.
smt().
qed.
realize SIB.B.tK by exact W8.to_uintK.
realize SIB.B.to_int_in_surj.
move=> i; split => [hi | [b <-]]; 1: by exists (W8.of_int i); rewrite W8.of_uintK modz_small /#.
by have := W8.to_uint_cmp b.
qed.
