require import AllCore List StdBigop.
require import Parameters GFq Rq.
require import Array256.
from Jasmin require import JArray.
require import Distr.
require JArrayExtra.
require Decompose.

abstract theory VecMatT.

clone include Decompose.DecomposeT.

import Round ZModQ Zq MLDSAParams.

(* polyXnD1-typed vectors/matrices, from's DynMatrix clone.   *)
(* (Previously these came from cloning [DVect] in the dilithium submodule.) *)
import VM VM.Vectors VM.Matrices.

clone export PolyArray as LArray  with
        op size <- lvec
        proof ge0_size by smt(gt0_l).

clone export PolyArray as KArray  with
        op size <- kvec
        proof ge0_size by smt(gt0_k).

clone export PolyArray as KLMatrix  with
        op size <- kvec*lvec
        proof ge0_size by smt(gt0_l gt0_k).

theory PolyLVec.
type polylvec = poly LArray.t.

op nttv v = LArray.map ntt v.
op invnttv v = LArray.map invntt v. 
op zerov : polylvec = LArray.init (fun i =>  poly_zero).

(* addition, componentwise *)
op (+) (v1 v2 : polylvec) : polylvec = map2 (&+) v1 v2.

lemma polylvec_add_iE (v1 v2 : polylvec) k :
  0 <= k < lvec => (v1 + v2).[k] = v1.[k] &+ v2.[k].
proof. by move=> rgk; rewrite /(+) map2iE. qed.

op ntt_smul(p : poly, v : polylvec) : polylvec = map (fun p' => basemul p' p) v.

lemma invnttv_ntt_smul_k (c : poly) (sv : polylvec) (k : int) :
  0 <= k < lvec =>
  (invnttv (ntt_smul c sv)).[k] = invntt (basemul sv.[k] c).
proof. by move => hk; rewrite /invnttv /ntt_smul !mapiE 1:/# /=. qed.

(* multiplication by a polynomial, componentwise *)
op psmul (c : poly) (v : polylvec) : polylvec = map (fun p => p &* c) v.

lemma invnttv_ntt_smul (c : poly) (v : polylvec) :
  invnttv (ntt_smul (ntt c) (nttv v)) = psmul c v.
proof.
apply LArray.ext_eq => i rgi.
by rewrite /invnttv /ntt_smul /nttv /psmul !mapiE //= conv.
qed.

lemma invnttv_add (v1 v2 : polylvec) : invnttv (v1 + v2) = invnttv v1 + invnttv v2.
proof.
apply LArray.ext_eq => i rgi; rewrite (polylvec_add_iE (invnttv v1)) // /invnttv.
by rewrite !mapiE // polylvec_add_iE // invnttD.
qed.

op infnorm_lt(v : polylvec, bound : int) : bool =
  all (fun ii => all (fun jj => `|v.[ii].[jj]| < bound) (iota_ 0 256)) (iota_ 0 lvec).

lemma infnorm_lt_polyE (v : polylvec) (bound : int) :
  infnorm_lt v bound <=> all (fun i => infnorm_lt v.[i] bound) (iota_ 0 lvec).
proof.
by rewrite /infnorm_lt  allP /=; split => H i Hi /=.
qed.

op mods(v : polylvec) : polylvec =
  map (fun (vi : poly) => map (fun c => incoeff (crepr c)) vi) v.

 end PolyLVec.

theory PolyKVec.
type polykvec = poly KArray.t.


op nttv v = KArray.map ntt v.
op invnttv v = KArray.map invntt v.
op zerov : polykvec = create poly_zero.

(* addition and subtraction, componentwise *)
op (+) (v1 v2 : polykvec) : polykvec = map2 (&+) v1 v2.
op (-) (v1 v2 : polykvec) : polykvec = map2 (fun a b => a &+ (&-) b) v1 v2.
op ntt_smul(p : poly, v : polykvec) : polykvec = map (fun p' => basemul p' p) v.

lemma invnttv_ntt_smul_k (c : poly) (sv : polykvec) (k : int) :
  0 <= k < kvec =>
  (invnttv (ntt_smul c sv)).[k] = invntt (basemul sv.[k] c).
proof. by move => hk; rewrite /invnttv /ntt_smul !mapiE 1:/# /=. qed.

lemma polykvec_sub_iE (v1 v2 : polykvec) k :
  0 <= k < kvec => (v1 - v2).[k] = v1.[k] &+ (&-) v2.[k].
proof. by move=> rgk; rewrite /(-) map2iE. qed.

lemma polykvec_add_iE (v1 v2 : polykvec) k :
  0 <= k < kvec => (v1 + v2).[k] = v1.[k] &+ v2.[k].
proof. by move=> rgk; rewrite /(+) map2iE. qed.

(* multiplication by a polynomial, componentwise *)
op psmul (c : poly) (v : polykvec) : polykvec = map (fun p => p &* c) v.

lemma invnttv_ntt_smul (c : poly) (v : polykvec) :
  invnttv (ntt_smul (ntt c) (nttv v)) = psmul c v.
proof.
apply KArray.ext_eq => i rgi.
by rewrite /invnttv /ntt_smul /nttv /psmul !mapiE //= conv.
qed.

lemma invnttv_add (v1 v2 : polykvec) : invnttv (v1 + v2) = invnttv v1 + invnttv v2.
proof.
apply KArray.ext_eq => i rgi; rewrite (polykvec_add_iE (invnttv v1)) // /invnttv.
by rewrite !mapiE // polykvec_add_iE // invnttD.
qed.

lemma invnttv_sub (v1 v2 : polykvec) : invnttv (v1 - v2) = invnttv v1 - invnttv v2.
proof.
apply KArray.ext_eq => i rgi; rewrite (polykvec_sub_iE (invnttv v1)) // /invnttv.
by rewrite !mapiE // polykvec_sub_iE // invnttD invnttN.
qed.

op smul(v : polykvec, c : coeff) : polykvec =
   KArray.map (fun (vi : poly) => map (fun ci => c*ci) vi) v.

op Power2Round(t : polykvec) : polykvec * polykvec =
   (map (fun p => (poly_Power2Round p).`1) t, 
    map (fun p => (poly_Power2Round p).`2) t).

op UseHint(h : polykvec, r : polykvec) : polykvec = 
    map2 poly_UseHint h r.

op MakeHint(v1 : polykvec, v2 : polykvec) : polykvec =
    map2 poly_MakeHint v1 v2.

op MakeHintImpl(v1 : polykvec, v2 : polykvec) : polykvec =
    map2 poly_MakeHintImpl v1 v2.

op infnorm_lt(v : polykvec, bound : int) : bool = 
  all (fun ii => all (fun jj => `|v.[ii].[jj]| < bound) (iota_ 0 256)) (iota_ 0 kvec).

import Bigint BIA. 
op hammw(v : polykvec, bound : int) : bool =
 big predT (fun ii => count (fun jj => v.[ii].[jj] <> Zq.zero) (iota_ 0 256)) (iota_ 0 kvec) <= bound.

op polykvec_HighBits(v : polykvec) : polykvec =
  map poly_HighBits v.

op polykvec_LowBits(v : polykvec) : polykvec =
  map poly_LowBits v.

lemma infnorm_lt_le (v : polykvec) (a b : int) :
  a <= b => infnorm_lt v a => infnorm_lt v b.
proof.
move=> leab; rewrite /infnorm_lt !allP => h i /h /=.
by rewrite !allP => h' j /h' /= /#.
qed.

(* When |cs2| <= Beta at every coefficient, LowBits(w-cs2) and LowBits(w)-cs2 agree
   for the infnorm check at threshold gamma2-Beta.  If cs2 were to cross a
   2*gamma2 rounding boundary, then |LowBits(w)-cs2| >= gamma2 > gamma2-Beta,
   making both sides false; in the no-crossing case the two representations are equal. *)
lemma bz_sync (w cs2 : polykvec) :
    infnorm_lt cs2 (Beta + 1) =>
    infnorm_lt (polykvec_LowBits (w - cs2)) (gamma2 - Beta) =
    infnorm_lt (polykvec_LowBits w - cs2) (gamma2 - Beta).
proof.
move => Hcs2.
rewrite /infnorm_lt eq_iff.
apply eq_all_in => k Hk_iota.
have Hk : 0 <= k < kvec by smt(mem_iota).
rewrite /=.
apply eq_all_in => j Hj_iota.
have Hj : 0 <= j < n by smt(mem_iota).
rewrite /=.
rewrite /polykvec_LowBits.
rewrite KArray.mapiE 1:/#.
rewrite polykvec_sub_iE 1:/#.
rewrite polykvec_sub_iE 1:/#.
rewrite KArray.mapiE 1:/#.
rewrite /poly_LowBits poly_addE 1:/# !Array256.initiE 1,2:/# /= !poly_addE 1:/# !poly_negE 1:/#.
have HLBS := LowBits_sub_sync w.[k].[j] cs2.[k].[j] _.
+ move: Hcs2; rewrite /infnorm_lt !allP => Hcs2.
  have := Hcs2 k _; first by rewrite mem_iota /#.
  rewrite /= allP => Hcs2k.
  have := Hcs2k j _; first by rewrite mem_iota /#.
  by simplify => /#.
by rewrite HLBS.
qed.

(* Coefficient-wise lift of MakeHintImpl_MakeHint_equiv from GFq.ec: the low
   bits of w minus cs2 must stay below gamma2 (the signing loop's rejection
   test gives gamma2 - Beta). *)
lemma polykvec_MakeHintImpl_MakeHint_equiv (w cs2 ct0 : polykvec) :
    infnorm_lt cs2 (Beta + 1) =>
    infnorm_lt (polykvec_LowBits w - cs2) gamma2 =>
    MakeHintImpl (polykvec_HighBits w) (polykvec_LowBits w - cs2 + ct0) =
    MakeHint (zerov - ct0) (w - cs2 + ct0).
proof.
move => Hcs2 Hlow.
apply KArray.tP => k Hk.
rewrite /MakeHintImpl /MakeHint !KArray.map2iE //=.
rewrite /polykvec_HighBits /polykvec_LowBits !KArray.mapiE //=.
rewrite /zerov KArray.createiE 1:/#.
apply Array256.tP => j Hj.
rewrite /poly_MakeHintImpl /poly_MakeHint !Array256.initiE 1,2:/# /=.
rewrite !poly_addE // !poly_negE // ?poly_addE // poly_zeroE //.
rewrite /poly_HighBits /poly_LowBits !Array256.initiE 1,2:/# /=.
congr; congr.
have hcs : `|cs2.[k].[j]| <= Beta.
+ move: Hcs2; rewrite /infnorm_lt !allP => Hcs2.
  have := Hcs2 k _; first by rewrite mem_iota /#.
  rewrite /= allP => Hcs2k.
  by have := Hcs2k j _; [rewrite mem_iota /# | simplify => /#].
have hl : `|incoeff (LowBits w.[k].[j]) - cs2.[k].[j]| < gamma2.
+ move: Hlow; rewrite /infnorm_lt !allP => Hlow.
  have := Hlow k _; first by rewrite mem_iota /#.
  rewrite /= allP => Hlowk.
  have := Hlowk j _; first by rewrite mem_iota /#.
  rewrite /= polykvec_sub_iE // /polykvec_LowBits KArray.mapiE //= poly_addE //.
  by rewrite poly_negE // /poly_LowBits Array256.initiE.
apply MakeHintImpl_MakeHint_equiv.
have [#] _ _ hl0 hl1 _ := Decompose_cases w.[k].[j].
have [hB0 hB1] := Beta_bnd; have hg := gamma2_bound.
have hc : `|crepr cs2.[k].[j]| <= Beta by done.
move: hl; rewrite -(creprK cs2.[k].[j]) -incoeffB abs_incoeff 1:/#.
by rewrite creprK.
qed.

end PolyKVec.

theory PolyMat.
type polymat = poly KLMatrix.t.
type apolymat = matrix.

op "_.[_<-_]" (m : polymat, rc : int * int, p : poly) =
        m.[rc.`1*lvec+rc.`2 <- p].

op nttm m = KLMatrix.map ntt m.
op invnttm m = KLMatrix.map invntt m.
op zerom : polymat = create poly_zero.

op row(m : polymat, r : int) : PolyLVec.polylvec = LArray.init (fun i => m.[r*lvec+i]).
op col(m : polymat, c : int) : PolyKVec.polykvec = KArray.init (fun i => m.[c+lvec*i]).
end PolyMat.

import PolyLVec PolyKVec PolyMat.

op ntt_dotp (v1 v2 : polylvec) : poly =
   foldr (fun (i : int) (a : poly) => (basemul v1.[i] v2.[i]) &+ a) poly_zero (iota_ 0 lvec).

op ntt_mulmxv(m : polymat, v : polylvec) : polykvec = 
   KArray.init (fun i => ntt_dotp (row m i) v).
 
op dotp_partial (v1 v2 : polylvec) (k : int) : poly =
  foldr (fun (i : int) (a : poly) => (basemul v1.[i] v2.[i]) &+ a)
        poly_zero (iota_ 0 k).

lemma foldr_addl (F : int -> poly) (x z : poly) (s : int list) :
  foldr (fun i a => F i &+ a) (x &+ z) s = x &+ foldr (fun i a => F i &+ a) z s.
proof.
elim: s => [|i s ih]; first by done.
by rewrite /= ih Rq_addA (Rq_addC (F i)) -Rq_addA.
qed.

lemma dotp_partialS (v1 v2 : polylvec) (k : int) :
  0 <= k => dotp_partial v1 v2 (k + 1) = basemul v1.[k] v2.[k] &+ dotp_partial v1 v2 k.
proof.
move=> ge0k; rewrite /dotp_partial iotaSr // -cats1 foldr_cat.
by rewrite /= -foldr_addl Rq_addr0.
qed.

lemma dotp_partial_ntt_dotp (v1 v2 : polylvec) :
  dotp_partial v1 v2 lvec = ntt_dotp v1 v2.
proof. by rewrite /dotp_partial /ntt_dotp. qed.

(* the products in the normal domain *)
op dotp (v1 v2 : polylvec) : poly =
  foldr (fun (i : int) (a : poly) => v1.[i] &* v2.[i] &+ a) poly_zero (iota_ 0 lvec).

op mulmxv (m : polymat) (v : polylvec) : polykvec =
  KArray.init (fun i => dotp (row m i) v).

lemma invntt_ntt_dotp (v1 v2 : polylvec) :
  invntt (ntt_dotp v1 (PolyLVec.nttv v2)) = dotp (PolyLVec.invnttv v1) v2.
proof.
rewrite /ntt_dotp /dotp.
have : forall i, i \in iota_ 0 lvec => 0 <= i < lvec by move=> i /mem_iota.
elim: (iota_ 0 lvec) => [_ | x l ih hl] /=; 1: exact invntt0.
rewrite invnttD ih; 1: by move=> i hi; apply hl; rewrite in_cons hi.
have hx : 0 <= x < lvec by apply hl; rewrite in_cons.
congr; rewrite /PolyLVec.invnttv /PolyLVec.nttv !LArray.mapiE //.
by rewrite -{1}(nttK v1.[x]) conv.
qed.

lemma invnttv_ntt_mulmxv (m : polymat) (v : polylvec) :
  PolyKVec.invnttv (ntt_mulmxv m (PolyLVec.nttv v)) = mulmxv (invnttm m) v.
proof.
apply KArray.ext_eq => i hi; rewrite /PolyKVec.invnttv /ntt_mulmxv /mulmxv KArray.mapiE // !KArray.initiE //=.
rewrite invntt_ntt_dotp; congr; apply LArray.ext_eq => j hj.
rewrite /row /PolyLVec.invnttv LArray.mapiE // !LArray.initiE //= /invnttm KLMatrix.mapiE //.
have : i * lvec + lvec <= kvec * lvec
  by rewrite -(mulzDl i 1); apply StdOrder.IntOrder.ler_wpmul2r; smt(gt0_l).
smt(gt0_l).
qed.

(* NTT/INTT cancellation + polynomial multiplication norm bound:
   invnttv(ntt_smul(ntt c)(nttv s2)) = c * s2 componentwise (convolution
   theorem), and |c * s2|_inf <= ||c||_1 * ||s2||_inf <= tau * Eta = Beta.
   The l1 bound on c is what the challenge provides (tau nonzero +-1
   coefficients); |c|_inf < 2 alone does not bound the product. *)
lemma cs2_norm_bound (c : poly) (s2 : polykvec) :
    l1 c <= tau =>
    PolyKVec.infnorm_lt s2 (Eta + 1) =>
    PolyKVec.infnorm_lt (PolyKVec.invnttv (PolyKVec.ntt_smul (ntt c) (PolyKVec.nttv s2))) (Beta + 1).
proof.
move=> hc hs2; rewrite /PolyKVec.infnorm_lt allP => k /mem_iota rgk /=.
rewrite allP => j /mem_iota rgj /=.
rewrite PolyKVec.invnttv_ntt_smul_k 1:/# /PolyKVec.nttv mapiE 1:/# /= conv Rq_mulC.
have hEta : 0 <= Eta by have := param_sets; smt().
have hs2k : forall i, 0 <= i < 256 => `|s2.[k].[i]| <= Eta.
- move=> i rgi; move: hs2; rewrite /PolyKVec.infnorm_lt allP => /(_ k _); 1: by rewrite mem_iota /#.
  by rewrite /= allP => /(_ i _) /=; [rewrite mem_iota /# | smt()].
have := conv_coeff_bnd c s2.[k] Eta j _ hs2k; 1: smt().
have : l1 c * Eta <= tau * Eta by apply StdOrder.IntOrder.ler_wpmul2r.
by rewrite /Beta; smt().
qed.

(* -------------------------------------------------------------------- *)
(* vectors of independent polynomials drawn from d                      *)

clone JArrayExtra.PAE as LArrayE with op size <- lvec, theory A <- LArray.
clone JArrayExtra.PAE as KArrayE with op size <- kvec, theory A <- KArray.

op dpolyl (d : poly distr) : polylvec distr = LArrayE.darray d.
op dpolyk (d : poly distr) : polykvec distr = KArrayE.darray d.

lemma supp_dpolyl (d : poly distr) (s : polylvec) :
  s \in dpolyl d <=> forall i, 0 <= i < lvec => s.[i] \in d.
proof. by apply LArrayE.supp_darray. qed.

lemma supp_dpolyk (d : poly distr) (s : polykvec) :
  s \in dpolyk d <=> forall i, 0 <= i < kvec => s.[i] \in d.
proof. by apply KArrayE.supp_darray. qed.

end VecMatT.
