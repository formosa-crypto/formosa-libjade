require import AllCore IntDiv List Distr DList PROM FMap.
from Jasmin require import JByte_array JWord.
require import Array256.

require import Parameters GFq Rq.
require import Spec65.
import MLDSA65.
import PolyLVec PolyKVec PolyMat.
import Round ZModQ Zq MLDSAParams.

require import MLDSA_RO MLDSA_ROSep MLDSA_ROSep_Hop1 MLDSA_ROSep_Hop2 MLDSA_ROSep_Hop3.
require import MLDSA_ROSep_Hop4 MLDSA_ROSep_Hop5 MLDSA_ROSep_Hop6 MLDSA_ROSep_Hop7 MLDSA_ROSep_Hop8.
require import MLDSA_ROSep_Hop9 MLDSA_ROSep_Hop10 MLDSA_ROSep_Hop11 MLDSA_ROSep_Hop12.
require import ConcreteDRing MLDSATargetFIPS.
require DS_ROM.
import PolyReduce.

(*************** The rounding of FIPS 204 and the rounding of the target ****************)

lemma HighBits_E (r : coeff) : HighBits r = highbits (2 * gamma2) r.
proof.
have hg : gamma2 = 261888 by have /= H := param_sets; smt().
have hr := ge0_asint r; have hq := gtp_asint r.
rewrite /HighBits /Decompose /highbits /rightshift /round /lowbits /smodem /cmod /mod_to_cmod hg /=.
have hq' : asint r < 8380417 by move: hq => /=.
have [hx hb] : asint r = 523776 * (asint r %/ 523776) + asint r %% 523776 /\ 0 <= asint r %% 523776 < 523776
  by smt(divz_eq modz_ge0 ltz_pmod).
case: (8118529 <= asint r) => hc /=.
+ smt(zeroE).
pose c := if asint r %% 523776 <= 261888 then asint r %% 523776 else asint r %% 523776 - 523776.
have -> : r - incoeff c = incoeff (asint r - c) by rewrite incoeffB asintK.
have hm : (asint r - c) %% q = asint r - c by rewrite modz_small; rewrite /c; smt().
rewrite incoeffK hm /c.
have -> : (if asint r %% 523776 <= 261888 then asint r %% 523776 else asint r %% 523776 - 523776) =
          (if 261888 < asint r %% 523776 then asint r %% 523776 - 523776 else asint r %% 523776) by smt().
rewrite ifF //; smt().
qed.

lemma LowBits_E (r : coeff) : LowBits r = crepr (lowbits (2 * gamma2) r).
proof.
have hg : gamma2 = 261888 by have /= H := param_sets; smt().
have hr := ge0_asint r; have hq := gtp_asint r.
have [hx hb] : asint r = 523776 * (asint r %/ 523776) + asint r %% 523776 /\ 0 <= asint r %% 523776 < 523776
  by smt(divz_eq modz_ge0 ltz_pmod).
rewrite /LowBits /Decompose /lowbits /smodem /cmod /mod_to_cmod hg /=.
case: (8118529 <= asint r) => hc /=.
+ rewrite ifT /=; 1: smt().
  rewrite /crepr /=; smt().
rewrite ifF /=; 1: smt().
rewrite incoeffK_centered; 1,2: smt().
smt().
qed.

lemma MakeHint_E (z r : coeff) : MakeHint z r = makehint (2 * gamma2) z r.
proof. by rewrite /MakeHint /makehint /= !HighBits_E. qed.

lemma Power2Round_E (x : coeff) : Power2Round x = (incoeff (highbits2 d x), lowbits2 d x).
proof.
have h2d : 2 ^ d = 8192 by rewrite expr_pred.
rewrite /Power2Round /highbits2 /rightshift2 /round2 /lowbits2 /smodem /cmod /mod_to_cmod h2d /=.
have hb : 0 <= asint x %% 8192 < 8192 by smt(modz_ge0 ltz_pmod).
rewrite incoeffK_centered; 1,2: smt().
have -> // : (if asint x %% 8192 <= 4096 then asint x %% 8192 else asint x %% 8192 - 8192) =
             (if 4096 < asint x %% 8192 then asint x %% 8192 - 8192 else asint x %% 8192) by smt().
qed.

lemma UseHint_E (h : bool) (r : coeff) : UseHint h r = incoeff (usehint (2 * gamma2) h r).
proof.
have hD : Decompose r = (HighBits r, LowBits r) by rewrite /HighBits /LowBits; case: (Decompose r).
have [[h0 h16] _] := Decompose_cases r.
have hg : gamma2 = 261888 by have /= H := param_sets; smt().
rewrite /UseHint /usehint hD /= -HighBits_E -LowBits_E hg /=.
case: h => //= _.
case: (0 < LowBits r) => hl /=.
+ by case: (HighBits r = 15) => [-> // | hne]; rewrite modz_small; smt().
rewrite ifT 1:/#.
by case: (HighBits r = 0) => [-> // | hne]; rewrite modz_small; smt().
qed.

(*************** Vectors and matrices ****************)

op vec_of_k (v : polykvec) : TF.DV.MatRq.Vectors.vector =
  TF.DV.MatRq.Vectors.oflist (map poly2alg (KArray.to_list v)).

op mat_of (m : polymat) : TF.DV.MatRq.Matrices.matrix =
  TF.DV.MatRq.Matrices.offunm (fun i j => poly2alg m.[i * lvec + j], kvec, lvec).

lemma size_vec_of_l (v : polylvec) : TF.DV.MatRq.Vectors.size (vec_of_l v) = lvec.
proof. by rewrite /vec_of_l TF.DV.MatRq.Vectors.size_oflist size_map LArray.size_to_list. qed.

lemma size_vec_of_k (v : polykvec) : TF.DV.MatRq.Vectors.size (vec_of_k v) = kvec.
proof. by rewrite /vec_of_k TF.DV.MatRq.Vectors.size_oflist size_map KArray.size_to_list. qed.

lemma vec_of_lE (v : polylvec) i : 0 <= i < lvec => TF.DV.MatRq.Vectors.get (vec_of_l v) i = poly2alg v.[i].
proof.
move=> hi; rewrite /vec_of_l (TF.DV.MatRq.Vectors.get_oflist witness) ?size_map ?LArray.size_to_list //;
  1: smt(size_iota).
rewrite (nth_map witness witness poly2alg); 1: smt(LArray.size_to_list).
by rewrite LArray.get_to_list.
qed.

lemma vec_of_kE (v : polykvec) i : 0 <= i < kvec => TF.DV.MatRq.Vectors.get (vec_of_k v) i = poly2alg v.[i].
proof.
move=> hi; rewrite /vec_of_k (TF.DV.MatRq.Vectors.get_oflist witness) ?size_map ?KArray.size_to_list //;
  1: smt(size_iota).
rewrite (nth_map witness witness poly2alg); 1: smt(KArray.size_to_list).
by rewrite KArray.get_to_list.
qed.

lemma poly2alg0 : poly2alg poly_zero = zeroXnD1.
proof.
have := congr1 poly2alg _ _ (Rq_addr0 poly_zero); rewrite /(&+) poly2algK => h.
by apply (ComRingDflInv.addrI (poly2alg poly_zero)); rewrite h ComRingDflInv.addr0.
qed.

lemma poly2alg_dotp (v1 v2 : polylvec) :
  poly2alg (dotp v1 v2) = TF.DV.MatRq.Big.BAdd.bigi predT (fun j => poly2alg v1.[j] * poly2alg v2.[j]) 0 lvec.
proof.
rewrite /dotp /= /range /=; elim: (iota_ 0 lvec) => [|x l ih] /=; 1: by rewrite TF.DV.MatRq.Big.BAdd.big_nil poly2alg0.
by rewrite TF.DV.MatRq.Big.BAdd.big_cons /predT /= -ih /(&+) /(&*) !poly2algK.
qed.

lemma vec_of_k_mulmxv (m : polymat) (v : polylvec) :
  vec_of_k (mulmxv m v) = TF.DV.MatRq.Matrices.mulmxv (mat_of m) (vec_of_l v).
proof.
apply TF.DV.MatRq.Vectors.eq_vectorP; rewrite size_vec_of_k TF.DV.MatRq.Matrices.size_mulmxv /mat_of /=.
split; 1: smt(gt0_k).
move=> i hi; rewrite vec_of_kE // TF.DV.MatRq.Matrices.get_mulmxv TF.DV.MatRq.Vectors.dotpE /mulmxv KArray.initiE //=
        poly2alg_dotp size_vec_of_l /=.
rewrite (_ : max (max 0 lvec) lvec = lvec); 1: smt(gt0_l).
apply TF.DV.MatRq.Big.BAdd.eq_big_int => j hj /=.
rewrite TF.DV.MatRq.Matrices.get_offunm /=; 1: smt(gt0_l gt0_k).
by rewrite vec_of_lE // /row LArray.initiE.
qed.

lemma vec_of_l_add (u v : polylvec) : vec_of_l (u + v) = TF.DV.MatRq.Vectors.( + ) (vec_of_l u) (vec_of_l v).
proof.
apply TF.DV.MatRq.Vectors.eq_vectorP; rewrite TF.DV.MatRq.Vectors.size_addv !size_vec_of_l /=; split => // i hi.
by rewrite TF.DV.MatRq.Vectors.get_addv !vec_of_lE // polylvec_add_iE // /(&+) poly2algK.
qed.

lemma vec_of_l_psmul (c : Rq.poly) (v : polylvec) :
  vec_of_l (psmul c v) = TF.DV.MatRq.Vectors.( ** ) (poly2alg c) (vec_of_l v).
proof.
apply TF.DV.MatRq.Vectors.eq_vectorP; rewrite TF.DV.MatRq.Vectors.size_scalarv !size_vec_of_l /= => i hi.
by rewrite TF.DV.MatRq.Vectors.get_scalarv !vec_of_lE // /psmul LArray.mapiE //= /(&*) poly2algK ComRingDflInv.mulrC.
qed.

lemma vec_of_k_add (u v : polykvec) : vec_of_k (u + v) = TF.DV.MatRq.Vectors.( + ) (vec_of_k u) (vec_of_k v).
proof.
apply TF.DV.MatRq.Vectors.eq_vectorP; rewrite TF.DV.MatRq.Vectors.size_addv !size_vec_of_k /=; split => // i hi.
by rewrite TF.DV.MatRq.Vectors.get_addv !vec_of_kE // polykvec_add_iE // /(&+) poly2algK.
qed.

lemma vec_of_k_sub (u v : polykvec) : vec_of_k (u - v) = TF.DV.MatRq.Vectors.( - ) (vec_of_k u) (vec_of_k v).
proof.
apply TF.DV.MatRq.Vectors.eq_vectorP.
rewrite TF.DV.MatRq.Vectors.size_addv TF.DV.MatRq.Vectors.size_oppv !size_vec_of_k /=; split => // i hi.
by rewrite TF.DV.MatRq.Vectors.get_addv TF.DV.MatRq.Vectors.getvN !vec_of_kE // polykvec_sub_iE // /(&+) /(&-) !poly2algK.
qed.

lemma vec_of_k_psmul (c : Rq.poly) (v : polykvec) :
  vec_of_k (psmul c v) = TF.DV.MatRq.Vectors.( ** ) (poly2alg c) (vec_of_k v).
proof.
apply TF.DV.MatRq.Vectors.eq_vectorP; rewrite TF.DV.MatRq.Vectors.size_scalarv !size_vec_of_k /= => i hi.
by rewrite TF.DV.MatRq.Vectors.get_scalarv !vec_of_kE // /psmul KArray.mapiE //= /(&*) poly2algK ComRingDflInv.mulrC.
qed.

lemma vec_of_k_neg (v : polykvec) : vec_of_k (PolyKVec.zerov - v) = TF.DV.MatRq.Vectors.([-]) (vec_of_k v).
proof.
apply TF.DV.MatRq.Vectors.eq_vectorP; rewrite TF.DV.MatRq.Vectors.size_oppv !size_vec_of_k /= => i hi.
rewrite !vec_of_kE // polykvec_sub_iE //.
by rewrite /PolyKVec.zerov KArray.createiE // /(&+) /(&-) !poly2algK poly2alg0 ComRingDflInv.add0r.
qed.

lemma poly_norm_lt (p : polyXnD1) a : 0 < a => (`|p| < a <=> forall i, 0 <= i < n => `|p.[i]| < a).
proof.
move=> ha; split => [h i hi | h]; 2: exact inf_norm_lt.
by have := inf_normXE p (a - 1) i _ _ hi; smt().
qed.

lemma infnorm_l (v : polylvec) b : 0 < b => (PolyLVec.infnorm_lt v b <=> TF.DV.inf_normv (vec_of_l v) < b).
proof.
move=> hb; rewrite TF.DV.inf_normv_ltr // size_vec_of_l /PolyLVec.infnorm_lt allP; split.
+ move=> h i hi; rewrite vec_of_lE // poly_norm_lt // => j hj; rewrite poly2algiE //.
  by have := h i _; [rewrite mem_iota /# | rewrite /= allP => /(_ j _); [rewrite mem_iota /# | done]].
move=> h i /mem_iota hi /=; rewrite allP => j /mem_iota hj /=.
have := h i _; 1: smt().
rewrite vec_of_lE 1:/# poly_norm_lt // => /(_ j _); 1: smt().
by rewrite poly2algiE 1:/#.
qed.

lemma infnorm_k (v : polykvec) b : 0 < b => (PolyKVec.infnorm_lt v b <=> TF.DV.inf_normv (vec_of_k v) < b).
proof.
move=> hb; rewrite TF.DV.inf_normv_ltr // size_vec_of_k /PolyKVec.infnorm_lt allP; split.
+ move=> h i hi; rewrite vec_of_kE // poly_norm_lt // => j hj; rewrite poly2algiE //.
  by have := h i _; [rewrite mem_iota /# | rewrite /= allP => /(_ j _); [rewrite mem_iota /# | done]].
move=> h i /mem_iota hi /=; rewrite allP => j /mem_iota hj /=.
have := h i _; 1: smt().
rewrite vec_of_kE 1:/# poly_norm_lt // => /(_ j _); 1: smt().
by rewrite poly2algiE 1:/#.
qed.

(*************** Rounding on vectors ****************)

lemma vec_of_k_LowBits (w : polykvec) : vec_of_k (polykvec_LowBits w) = TF.DV.lowBitsV (vec_of_k w).
proof.
apply TF.DV.MatRq.Vectors.eq_vectorP; rewrite TF.DV.MatRq.Vectors.size_mapv !size_vec_of_k /= => i hi.
rewrite TF.DV.MatRq.Vectors.get_mapv ?size_vec_of_k // !vec_of_kE // /polykvec_LowBits KArray.mapiE //=
        /TF.DV.HL.lowBits /=.
apply polyXnD1_eqP => j hj; rewrite poly2algiE // /poly_LowBits Array256.initiE //= poly_lowbits_correct //.
by rewrite LowBits_E poly2algiE // creprK.
qed.

lemma w1_key_HighBits (w : polykvec) : w1_key (polykvec_HighBits w) = TF.DV.highBitsV (vec_of_k w).
proof.
apply (eq_from_nth witness).
+ by rewrite /w1_key TF.DV.size_highBitsV size_vec_of_k size_map KArray.size_to_list.
move=> i; rewrite /w1_key size_map KArray.size_to_list => hi.
rewrite -/(w1_key _) w1_key_nth // /TF.DV.highBitsV (nth_map witness witness TF.DV.HL.highBits)
        ?TF.DV.MatRq.Vectors.size_tolist ?size_vec_of_k // TF.DV.MatRq.Vectors.nth_tolist ?size_vec_of_k //
        vec_of_kE // /TF.DV.HL.highBits.
congr; apply (eq_from_nth 0); 1: by rewrite size_map Array256.size_to_list /poly_highbits size_mkseq.
move=> j; rewrite size_map Array256.size_to_list => hj.
rewrite (nth_map witness 0 asint) ?Array256.size_to_list // Array256.get_to_list /polykvec_HighBits KArray.mapiE //=
        /poly_HighBits Array256.initiE //= incoeffK modz_small; 1: smt(Decompose_cases).
by rewrite /poly_highbits nth_mkseq //= HighBits_E poly2algiE.
qed.

lemma hints_of_MakeHint (u v : polykvec) : hints_of (MakeHint u v) = TF.DV.makeHintV (vec_of_k u) (vec_of_k v).
proof.
apply (eq_from_nth witness).
+ by rewrite /hints_of TF.DV.size_makeHintV !size_vec_of_k size_map KArray.size_to_list.
move=> i; rewrite /hints_of size_map KArray.size_to_list => hi.
rewrite (nth_map witness witness (fun (p : Rq.poly) => map (fun c => c <> Zq.zero) (Array256.to_list p)))
        ?KArray.size_to_list // KArray.get_to_list /=.
rewrite /TF.DV.makeHintV (nth_map (witness, witness) witness (TF.DV.uncurry TF.DV.HL.makeHint));
  1: by rewrite size_zip !TF.DV.MatRq.Vectors.size_tolist !size_vec_of_k /#.
rewrite nth_zip ?TF.DV.MatRq.Vectors.size_tolist ?size_vec_of_k // /TF.DV.uncurry /=
        !TF.DV.MatRq.Vectors.nth_tolist ?size_vec_of_k // !vec_of_kE // /TF.DV.HL.makeHint.
apply (eq_from_nth witness); 1: by rewrite size_map Array256.size_to_list /poly_makehint size_mkseq.
move=> j; rewrite size_map Array256.size_to_list => hj.
rewrite (nth_map witness witness (fun (c : coeff) => c <> Zq.zero)) ?Array256.size_to_list // Array256.get_to_list
        /MakeHint KArray.map2iE //= /poly_MakeHint Array256.initiE //= /poly_makehint nth_mkseq //= !poly2algiE //
        MakeHint_E.
by case: (makehint (2 * gamma2) u.[i].[j] v.[i].[j]) => /=; smt(incoeffK zeroE).
qed.

lemma hammw_E (h : polykvec) : hammw h w_hint = check_hw (hints_of h).
proof.
rewrite /hammw /check_hw /hints_of count_flatten -map_comp StdBigop.Bigint.sumzE StdBigop.Bigint.BIA.big_mapT /(\o) /=.
congr; rewrite /KArray.to_list /mkseq StdBigop.Bigint.BIA.big_mapT /(\o) /=.
apply StdBigop.Bigint.BIA.eq_big_seq => ii _ /=.
by rewrite count_map /Array256.to_list /mkseq count_map.
qed.

lemma usehint_rng (b : bool) (x : coeff) : 0 <= usehint (2 * gamma2) b x <= 15.
proof.
have [[h0 h16] _] := Decompose_cases x.
have hg : gamma2 = 261888 by have /= H := param_sets; smt().
rewrite /usehint /= -HighBits_E hg /=; smt().
qed.

lemma w1_key_UseHint (h r : polykvec) : w1_key (UseHint h r) = TF.DV.useHintV (hints_of h) (vec_of_k r).
proof.
apply (eq_from_nth witness).
+ rewrite TF.DV.size_useHintV size_vec_of_k /w1_key /hints_of !size_map; smt(size_iota gt0_k).
move=> i hi; have {hi} hi : 0 <= i < kvec
  by move: hi; rewrite /w1_key size_map; smt(size_iota gt0_k KArray.size_to_list).
have hsh : size (hints_of h) = kvec by rewrite /hints_of size_map; smt(size_iota gt0_k KArray.size_to_list).
rewrite w1_key_nth // /TF.DV.useHintV (nth_map (witness, witness) witness (TF.DV.uncurry TF.DV.HL.useHint));
  1: by rewrite size_zip TF.DV.MatRq.Vectors.size_tolist size_vec_of_k hsh /#.
rewrite nth_zip ?TF.DV.MatRq.Vectors.size_tolist ?size_vec_of_k ?hsh // /TF.DV.uncurry /=
        TF.DV.MatRq.Vectors.nth_tolist ?size_vec_of_k // vec_of_kE // /TF.DV.HL.useHint.
congr.
rewrite /hints_of (nth_map witness witness (fun (p : Rq.poly) => map (fun c => c <> Zq.zero) (Array256.to_list p)));
  1: smt(KArray.size_to_list).
rewrite KArray.get_to_list /=.
apply (eq_from_nth 0); 1: by rewrite size_map Array256.size_to_list size_poly_usehint.
move=> j; rewrite size_map Array256.size_to_list => hj.
rewrite (nth_map witness 0 asint) ?Array256.size_to_list // Array256.get_to_list /UseHint KArray.map2iE //=
        /poly_UseHint Array256.initiE //= /poly_usehint nth_mkseq //= poly2algiE // UseHint_E incoeffK modz_small;
  1: smt(usehint_rng).
by rewrite (nth_map witness false (fun (c : coeff) => c <> Zq.zero)) ?Array256.size_to_list // Array256.get_to_list.
qed.

lemma highbits2_rng (x : coeff) : 0 <= highbits2 d x <= 1023.
proof.
have h2d : 2 ^ d = 8192 by rewrite expr_pred.
have hr := ge0_asint x; have hq := gtp_asint x.
rewrite /highbits2 /rightshift2 /round2 /lowbits2 /cmod /mod_to_cmod h2d /=.
have hb : 0 <= asint x %% 8192 < 8192 by smt(modz_ge0 ltz_pmod).
have hx : asint x = 8192 * (asint x %/ 8192) + asint x %% 8192 by smt(divz_eq).
rewrite incoeffK_centered; 1,2: smt().
case: (asint x %% 8192 <= 4096) => hc /=.
+ by rewrite (_ : asint x - asint x %% 8192 = 8192 * (asint x %/ 8192)) 1:/# mulKz //; smt().
by rewrite (_ : asint x - (asint x %% 8192 - 8192) = 8192 * (asint x %/ 8192 + 1)) 1:/# mulKz //; smt().
qed.

lemma t1_of_Power2Round (t : polykvec) : t1_of (Power2Round t).`1 = TF.DV.base2highbitsV (vec_of_k t).
proof.
apply (eq_from_nth witness).
+ rewrite TF.DV.size_base2highbitsV size_vec_of_k /t1_of size_map; smt(size_iota gt0_k KArray.size_to_list).
move=> i hi; have {hi} hi : 0 <= i < kvec
  by move: hi; rewrite /t1_of size_map; smt(size_iota gt0_k KArray.size_to_list).
rewrite /t1_of (nth_map witness witness (fun (p : Rq.poly) => map asint (Array256.to_list p)));
  1: smt(KArray.size_to_list).
rewrite KArray.get_to_list /TF.DV.base2highbitsV (nth_map witness witness TF.DV.HL.base2highbits)
        ?TF.DV.MatRq.Vectors.size_tolist ?size_vec_of_k // TF.DV.MatRq.Vectors.nth_tolist ?size_vec_of_k //
        vec_of_kE // /TF.DV.HL.base2highbits /=.
apply (eq_from_nth 0); 1: by rewrite size_map Array256.size_to_list /poly_highbits2 size_mkseq.
move=> j; rewrite size_map Array256.size_to_list => hj.
rewrite (nth_map witness 0 asint) ?Array256.size_to_list // Array256.get_to_list /PolyKVec.Power2Round /=
        KArray.mapiE //= /poly_Power2Round /= Array256.initiE //= Power2Round_E /= incoeffK modz_small;
  1: smt(highbits2_rng).
by rewrite poly_highbits2_correct // poly2algiE.
qed.

lemma vec_of_k_Power2Round (t : polykvec) : vec_of_k (Power2Round t).`2 = TF.DV.base2lowbitsV (vec_of_k t).
proof.
apply TF.DV.MatRq.Vectors.eq_vectorP; rewrite TF.DV.MatRq.Vectors.size_mapv !size_vec_of_k /= => i hi.
rewrite TF.DV.MatRq.Vectors.get_mapv ?size_vec_of_k // !vec_of_kE //
        /TF.DV.HL.base2lowbits /TF.DV.HL.base2shift /TF.DV.HL.base2highbits /=.
apply polyXnD1_eqP => j hj; rewrite poly2algiE // rcoeffD -rcoeffN poly_leftshift2_correct // poly_highbits2_correct //
  /PolyKVec.Power2Round /= KArray.mapiE //= /poly_Power2Round /= Array256.initiE //= Power2Round_E /= poly2algiE //.
have h2d : 2 ^ d = 8192 by rewrite expr_pred.
have H := high2_low2P d t.[i].[j] _ _; 1,2: by rewrite ?h2d.
have -> // : t.[i].[j] - leftshift2 d (highbits2 d t.[i].[j]) = lowbits2 d t.[i].[j] by rewrite -{1}H; ring.
qed.

lemma vec_of_k_smul (t1 : polykvec) : vec_of_k (smul t1 (incoeff (2 ^ d))) = TF.DV.base2shiftV (t1_of t1).
proof.
have hs : size (t1_of t1) = kvec by rewrite /t1_of size_map; smt(size_iota gt0_k KArray.size_to_list).
apply TF.DV.MatRq.Vectors.eq_vectorP; rewrite TF.DV.size_base2shiftV size_vec_of_k hs /= => i hi.
rewrite vec_of_kE // /TF.DV.base2shiftV (TF.DV.MatRq.Vectors.get_oflist witness); 1: by rewrite size_map hs.
rewrite (nth_map witness witness TF.DV.HL.base2shift) 1:/#.
rewrite /t1_of (nth_map witness witness (fun (p : Rq.poly) => map asint (Array256.to_list p)));
  1: smt(KArray.size_to_list).
rewrite KArray.get_to_list /TF.DV.HL.base2shift /=.
apply polyXnD1_eqP => j hj; rewrite poly2algiE // poly_leftshift2_correct // (nth_map witness 0 asint)
  ?Array256.size_to_list // Array256.get_to_list /smul KArray.mapiE //= Array256.mapiE //= /leftshift2 incoeffM asintK.
by rewrite expr_pred.
qed.

lemma hints_ofK (u v : polykvec) : poly_of_hints (hints_of (MakeHint u v)) = MakeHint u v.
proof.
apply KArray.ext_eq => i hi; apply Array256.ext_eq => j hj.
rewrite /poly_of_hints KArray.initiE //= Array256.initiE //=
        /hints_of (nth_map witness [] (fun (p : Rq.poly) => map (fun c => c <> Zq.zero) (Array256.to_list p)));
  1: smt(KArray.size_to_list).
rewrite KArray.get_to_list /= (nth_map witness false (fun (c : coeff) => c <> Zq.zero)) ?Array256.size_to_list //
        Array256.get_to_list /MakeHint KArray.map2iE //= /poly_MakeHint Array256.initiE //=.
by case: (MakeHint u.[i].[j] v.[i].[j]) => /=; smt(incoeffK zeroE oneE asint_inj).
qed.

(*************** Distributions ****************)

op k_of_vec (v : TF.DV.MatRq.Vectors.vector) : polykvec =
  KArray.init (fun i => alg2poly (TF.DV.MatRq.Vectors.get v i)).

lemma vec_of_lK : cancel vec_of_l l_of_vec.
proof. move=> v; apply LArray.ext_eq => i hi; by rewrite /l_of_vec LArray.initiE //= vec_of_lE // alg2polyK. qed.

lemma vec_of_kK : cancel vec_of_k k_of_vec.
proof. move=> v; apply KArray.ext_eq => i hi; by rewrite /k_of_vec KArray.initiE //= vec_of_kE // alg2polyK. qed.

lemma dpolyl_vec : dmap (dpolyl (dpoly (-Eta) Eta)) vec_of_l = TF.DV.MatRq.Vectors.dvector (DR.dRq_ Eta) lvec.
proof.
have /= H := param_sets.
rewrite /dpolyl /LArrayE.darray /TF.DV.MatRq.Vectors.dvector /DR.dRq_ /dpoly_ball ifT 1:/# (_ : max 0 lvec = lvec) 1:/#.
rewrite (dlist_dmap (dpoly (-Eta) Eta) poly2alg lvec) !dmap_comp.
apply eq_dmap_in => x hx; rewrite /(\o) /vec_of_l LArray.of_listK //.
by move: hx; rewrite supp_dlist; smt(gt0_l).
qed.

lemma dpolyk_vec : dmap (dpolyk (dpoly (-Eta) Eta)) vec_of_k = TF.DV.MatRq.Vectors.dvector (DR.dRq_ Eta) kvec.
proof.
have /= H := param_sets.
rewrite /dpolyk /KArrayE.darray /TF.DV.MatRq.Vectors.dvector /DR.dRq_ /dpoly_ball ifT 1:/# (_ : max 0 kvec = kvec) 1:/#.
rewrite (dlist_dmap (dpoly (-Eta) Eta) poly2alg kvec) !dmap_comp.
apply eq_dmap_in => x hx; rewrite /(\o) /vec_of_k KArray.of_listK //.
by move: hx; rewrite supp_dlist; smt(gt0_k).
qed.

import TF.DV TF.DV.MatRq.Vectors TF.DV.MatRq.Matrices.

lemma l_of_vecK (v : vector) : size v = lvec => vec_of_l (l_of_vec v) = v.
proof.
move=> hs; apply eq_vectorP; rewrite size_vec_of_l hs /= => i hi.
by rewrite vec_of_lE // /l_of_vec LArray.initiE //= poly2algK.
qed.

lemma k_of_vecK (v : vector) : size v = kvec => vec_of_k (k_of_vec v) = v.
proof.
move=> hs; apply eq_vectorP; rewrite size_vec_of_k hs /= => i hi.
by rewrite vec_of_kE // /k_of_vec KArray.initiE //= poly2algK.
qed.

lemma mu1_dvector_l (v : vector) :
  size v = lvec => mu1 (dvector (DR.dRq_ Eta) lvec) v = mu1 (dpolyl (dpoly (-Eta) Eta)) (l_of_vec v).
proof.
move=> hs; rewrite -dpolyl_vec dmap1E; apply mu_eq => x; rewrite /pred1 /(\o) /=; smt(vec_of_lK l_of_vecK).
qed.

lemma mu1_dvector_k (v : vector) :
  size v = kvec => mu1 (dvector (DR.dRq_ Eta) kvec) v = mu1 (dpolyk (dpoly (-Eta) Eta)) (k_of_vec v).
proof.
move=> hs; rewrite -dpolyk_vec dmap1E; apply mu_eq => x; rewrite /pred1 /(\o) /=; smt(vec_of_kK k_of_vecK).
qed.

(*************** G13: the arithmetic of the target ****************)

module MLDSA_RO_DS13(XA : DS11.POracle1, XC : DS11.POracle2, Htr : DST.POracle3, Hmu : DST.POracle4,
                     Hct : DST.POracle5) = {
  proc keygen() : BytesPK.t * TF.SK = {
    var rho, _A, mA, s1, s2, t, pk, tr;
    RO_y.RO.init();
    rho <$ dxi;
    _A <@ ExpandA(XOFA_O(XA)).sample(rho);
    mA <- mat_of (invnttm _A);
    s1 <$ dvector (DR.dRq_ Eta) lvec;
    s2 <$ dvector (DR.dRq_ Eta) kvec;
    t <- mA *^ s1 + s2;
    pk <@ PkEncDec.pkEncode(rho, poly_of_t1 (base2highbitsV t));
    tr <@ Htrw(Htr).get(pk);
    return (pk, (rho, tr, s1, s2, base2lowbitsV t));
  }

  proc sign(sk : TF.SK, m : W8.t list) : BytesSig.t option * Leakage list = {
    var coins, rho, tr, s1, s2, t0, _A, mA, mu, kappa, y, w, w1, ctl, ct, c, cr, z, h, leakage, sigma, bz, bh, sl;
    var zh : (vector * bool list list) option;
    coins <$ drnd;
    ct <- witness;
    ctl <- witness;
    sigma <- witness;
    leakage <- [];
    (rho, tr, s1, s2, t0) <- sk;
    _A <@ ExpandA(XOFA_O(XA)).sample(rho);
    mA <- mat_of (invnttm _A);
    mu <@ Hmu.get(tr, m);
    kappa <- 0;
    zh <- None;
    while (zh = None && ! (kappa_max <= kappa)) {
      y <@ RO_y.RO.get(coins, mu, kappa);
      w <- mA *^ vec_of_l y;
      w1 <- highBitsV w;
      ct <@ Hct.get(w1, mu);
      (c, sl) <@ SampleInBall_B(XC).sample(ct);
      ctl <- ((ct, c), sl);
      leakage <- leakage ++ [RO ctl.`2];
      cr <- poly2alg c;
      z <- vec_of_l y + cr ** s1;
      bz <- inf_normv z < gamma1 - Beta && inf_normv (lowBitsV (w - cr ** s2)) < gamma2 - Beta;
      leakage <- leakage ++ [CheckZ bz];
      if (bz) {
        h <- makeHintV (- (cr ** t0)) (w - cr ** s2 + cr ** t0);
        bh <- inf_normv (cr ** t0) < gamma2 && check_hw h;
        leakage <- leakage ++ [CheckH bh];
        if (bh) { zh <- Some (z, h); }
      }
      kappa <- kappa + 1;
    }
    if (zh <> None) {
      sigma <@ SigEncDec.sigEncode(ct, l_of_vec (oget zh).`1, poly_of_hints (oget zh).`2);
    }
    return (if zh = None then None else Some sigma, leakage);
  }

  proc verify(pk : BytesPK.t, m : W8.t list, sigma : BytesSig.t) : bool = {
    var rho, t1, c, l, ct, z, h, rb, _A, mA, tr, mu, w1, ctp;
    w1 <- witness;
    rb <- false;
    (rho, t1) <@ PkEncDec.pkDecode(pk);
    (ct, z, h) <@ SigEncDec.sigDecode(sigma);
    if (h <> None) {
      _A <@ ExpandA(XOFA_O(XA)).sample(rho);
      mA <- mat_of (invnttm _A);
      tr <@ Htrw(Htr).get(pk);
      mu <@ Hmu.get(tr, m);
      (c, l) <@ SampleInBall_B(XC).sample(ct);
      w1 <- useHintV (hints_of (oget h)) (mA *^ vec_of_l z - poly2alg c ** base2shiftV (t1_of t1));
      ctp <@ Hct.get(w1, mu);
      rb <- inf_normv (vec_of_l z) < gamma1 - Beta;
      rb <- rb && ct = ctp;
    }
    return rb;
  }
}.

(*************** G12 and G13 ****************)

op sk_rel (sk12 : Bytes32.t * Bytes64.t * polylvec * polykvec * polykvec) (sk13 : TF.SK) =
  sk13 = (sk12.`1, sk12.`2, vec_of_l sk12.`3, vec_of_k sk12.`4, vec_of_k sk12.`5).

equiv keygen_13 :
  MLDSA_RO_DS11(XAw(DST.RO1.RO), XCw(DST.RO2.RO), Htrw(DST.RO3.RO), DST.RO4.RO, Hctw(DST.RO5.RO)).keygen ~
  MLDSA_RO_DS13(XAw(DST.RO1.RO), XCw(DST.RO2.RO), DST.RO3.RO, DST.RO4.RO, DST.RO5.RO).keygen :
  ={glob DST.RO1.RO, glob RO_xr.RO, glob DST.RO3.RO, glob XOFA_O}
  ==> res{1}.`1 = res{2}.`1 /\ sk_rel res{1}.`2 res{2}.`2 /\
      ={glob DST.RO1.RO, glob RO_xr.RO, glob DST.RO3.RO, glob XOFA_O, RO_y.RO.m}.
proof.
proc; inline{1} RO_y.RO.init; inline{2} RO_y.RO.init.
call (: ={glob DST.RO3.RO}); 1: by sim.
wp; call (: true); 1: by sim.
wp; rnd vec_of_k k_of_vec; rnd vec_of_l l_of_vec; wp.
call (: ={glob DST.RO1.RO, glob RO_xr.RO, glob XOFA_O}); 1: by sim.
have hszl : forall v, v \in dvector (DR.dRq_ Eta) lvec => size v = lvec by move=> v /size_dvector; smt(gt0_l).
have hszk : forall v, v \in dvector (DR.dRq_ Eta) kvec => size v = kvec by move=> v /size_dvector; smt(gt0_k).
auto => />.
move=> rho _ _A; split; 1: by move=> v /hszl /l_of_vecK ->.
move=> _; split; 1: by move=> v /hszl /mu1_dvector_l.
move=> _ s1 hs1; split; 1: by rewrite -dpolyl_vec supp_dmap; exists s1.
move=> _; split; 1: by rewrite vec_of_lK.
move=> _; split; 1: by move=> v /hszk /k_of_vecK ->.
move=> _; split; 1: by move=> v /hszk /mu1_dvector_k.
move=> _ s2 hs2; split; 1: by rewrite -dpolyk_vec supp_dmap; exists s2.
move=> _; split; 1: by rewrite vec_of_kK.
move=> _; rewrite -vec_of_k_mulmxv -vec_of_k_add -t1_of_Power2Round t1_ofK /=.
by rewrite vec_of_k_Power2Round.
qed.

lemma sign_alg (A : polymat) (y s1 : polylvec) (c : Rq.poly) (s2 t0 : polykvec) :
     (PolyLVec.infnorm_lt (y + psmul c s1) (gamma1 - Beta) <=>
      inf_normv (vec_of_l y + poly2alg c ** vec_of_l s1) < gamma1 - Beta)
  /\ (PolyKVec.infnorm_lt (polykvec_LowBits (mulmxv (invnttm A) y - psmul c s2)) (gamma2 - Beta) <=>
      inf_normv (lowBitsV (mat_of (invnttm A) *^ vec_of_l y - poly2alg c ** vec_of_k s2)) < gamma2 - Beta)
  /\ (PolyKVec.infnorm_lt (psmul c t0) gamma2 <=> inf_normv (poly2alg c ** vec_of_k t0) < gamma2)
  /\ hints_of (MakeHint (PolyKVec.zerov - psmul c t0) (mulmxv (invnttm A) y - psmul c s2 + psmul c t0)) =
     makeHintV (- (poly2alg c ** vec_of_k t0))
       (mat_of (invnttm A) *^ vec_of_l y - poly2alg c ** vec_of_k s2 + poly2alg c ** vec_of_k t0)
  /\ vec_of_l (y + psmul c s1) = vec_of_l y + poly2alg c ** vec_of_l s1.
proof.
have /= H := param_sets.
have hg1 : 0 < gamma1 - Beta by smt(beta_gamma1_lt).
have hg2 : 0 < gamma2 - Beta by smt(beta_gamma2_lt).
have hg : 0 < gamma2 by smt().
split; 1: by rewrite -vec_of_l_psmul -vec_of_l_add; apply infnorm_l.
split; 1: by rewrite -vec_of_k_mulmxv -vec_of_k_psmul -vec_of_k_sub -vec_of_k_LowBits; apply infnorm_k.
split; 1: by rewrite -vec_of_k_psmul; apply infnorm_k.
split; 2: by rewrite vec_of_l_add vec_of_l_psmul.
rewrite hints_of_MakeHint vec_of_k_neg vec_of_k_add vec_of_k_sub vec_of_k_mulmxv !vec_of_k_psmul.
congr.
qed.

equiv sign_13 :
  MLDSA_RO_DS11(XAw(DST.RO1.RO), XCw(DST.RO2.RO), Htrw(DST.RO3.RO), DST.RO4.RO, Hctw(DST.RO5.RO)).sign ~
  MLDSA_RO_DS13(XAw(DST.RO1.RO), XCw(DST.RO2.RO), DST.RO3.RO, DST.RO4.RO, DST.RO5.RO).sign :
  ={m, glob DST.RO1.RO, glob RO_xr.RO, glob DST.RO2.RO, glob DST.RO4.RO, glob DST.RO5.RO, glob XOFA_O, RO_y.RO.m} /\
  sk_rel sk{1} sk{2}
  ==> ={res, glob DST.RO1.RO, glob RO_xr.RO, glob DST.RO2.RO, glob DST.RO4.RO, glob DST.RO5.RO, glob XOFA_O,
        RO_y.RO.m}.
proof.
proc.
seq 10 11 : (={coins, ct, ctl, sigma, leakage, rho, tr, mu, kappa, glob DST.RO1.RO, glob RO_xr.RO, glob DST.RO2.RO,
               glob DST.RO4.RO, glob DST.RO5.RO, glob XOFA_O, RO_y.RO.m} /\
             s1{2} = vec_of_l s1{1} /\ s2{2} = vec_of_k s2{1} /\ t0{2} = vec_of_k t0{1} /\
             mA{2} = mat_of (invnttm _A{1}) /\ zh{1} = None /\ zh{2} = None).
+ wp; call (: ={glob DST.RO4.RO}); 1: by sim.
  wp; call (: ={glob DST.RO1.RO, glob RO_xr.RO, glob XOFA_O}); 1: by sim.
  by auto => />; rewrite /sk_rel => &1 &2 -> /=.
seq 1 1 : (={ct, sigma, leakage, glob DST.RO1.RO, glob RO_xr.RO, glob DST.RO2.RO, glob DST.RO4.RO, glob DST.RO5.RO,
             glob XOFA_O, RO_y.RO.m} /\
           zh{2} = omap (fun (p : polylvec * polykvec) => (vec_of_l p.`1, hints_of p.`2)) zh{1} /\
           (zh{1} <> None => poly_of_hints (hints_of (oget zh{1}).`2) = (oget zh{1}).`2)).
+ while (={coins, ct, ctl, leakage, mu, kappa, glob DST.RO1.RO, glob RO_xr.RO, glob DST.RO2.RO, glob DST.RO4.RO,
           glob DST.RO5.RO, glob XOFA_O, RO_y.RO.m} /\
         s1{2} = vec_of_l s1{1} /\ s2{2} = vec_of_k s2{1} /\ t0{2} = vec_of_k t0{1} /\
         mA{2} = mat_of (invnttm _A{1}) /\
         zh{2} = omap (fun (p : polylvec * polykvec) => (vec_of_l p.`1, hints_of p.`2)) zh{1} /\
         (zh{1} <> None => poly_of_hints (hints_of (oget zh{1}).`2) = (oget zh{1}).`2)); 2: by auto => />.
  inline{1} Hctw(DST.RO5.RO).get.
  wp; call (: ={glob DST.RO2.RO}); 1: by sim.
  wp; call (: ={glob DST.RO5.RO}); 1: by sim.
  wp; call (: ={RO_y.RO.m}); 1: by sim.
  auto => /> &1 &2 _ y.
  split; 1: (rewrite w1_key_HighBits vec_of_k_mulmxv; congr).
  move=> _ c.
  have [h1 [h2 [h3 [h4 h5]]]] := sign_alg _A{1} y s1{1} c.`1 s2{1} t0{1}.
  rewrite hints_ofK h1 h2 h3 hammw_E h4 h5.
  smt().
if; 1: smt().
+ wp; call (: true); 1: by sim.
  auto => /> &1 hz; smt(vec_of_lK).
auto; smt().
qed.

equiv verify_13 :
  MLDSA_RO_DS11(XAw(DST.RO1.RO), XCw(DST.RO2.RO), Htrw(DST.RO3.RO), DST.RO4.RO, Hctw(DST.RO5.RO)).verify ~
  MLDSA_RO_DS13(XAw(DST.RO1.RO), XCw(DST.RO2.RO), DST.RO3.RO, DST.RO4.RO, DST.RO5.RO).verify :
  ={pk, m, sigma, glob DST.RO1.RO, glob RO_xr.RO, glob DST.RO2.RO, glob DST.RO3.RO, glob DST.RO4.RO, glob DST.RO5.RO,
    glob XOFA_O}
  ==> ={res}.
proof.
proc.
seq 4 4 : (={pk, m, rho, t1, ct, z, h, rb, glob DST.RO1.RO, glob RO_xr.RO, glob DST.RO2.RO, glob DST.RO3.RO,
             glob DST.RO4.RO, glob DST.RO5.RO, glob XOFA_O}).
+ by call (: true); [by sim | call (: true); [by sim | auto]].
if => //.
inline{1} Hctw(DST.RO5.RO).get.
wp; call (: ={glob DST.RO5.RO}); 1: by sim.
wp; call (: ={glob DST.RO2.RO}); 1: by sim.
call (: ={glob DST.RO4.RO}); 1: by sim.
call (: ={glob DST.RO3.RO}); 1: by sim.
wp; call (: ={glob DST.RO1.RO, glob RO_xr.RO, glob XOFA_O}); 1: by sim.
auto => /> &2 _ _A c.
split.
+ rewrite w1_key_UseHint vec_of_k_sub vec_of_k_mulmxv vec_of_k_psmul (_ : incoeff 8192 = incoeff (2 ^ d));
    1: by rewrite expr_pred.
  rewrite vec_of_k_smul; congr.
move=> _ r; have /= H := param_sets; have hg1 : 0 < gamma1 - Beta by smt(beta_gamma1_lt).
by rewrite (infnorm_l _ _ hg1).
qed.

module G13(A : DS2.Adversary) = {
  var sk : TF.SK
  var qs : W8.t list list

  module O = {
    proc sign(m : W8.t list) : BytesSig.t option * Leakage list = {
      var r;
      qs <- m :: qs;
      r <@ MLDSA_RO_DS13(XAw(DST.RO1.RO), XCw(DST.RO2.RO), DST.RO3.RO, DST.RO4.RO, DST.RO5.RO).sign(sk, m);
      return r;
    }
  }

  proc main() : bool = {
    var pk, m, s, b;
    DST.RO1.RO.init();
    RO_xr.RO.init();
    DST.RO2.RO.init();
    DST.RO3.RO.init();
    DST.RO4.RO.init();
    DST.RO5.RO.init();
    qs <- [];
    (pk, sk) <@ MLDSA_RO_DS13(XAw(DST.RO1.RO), XCw(DST.RO2.RO), DST.RO3.RO, DST.RO4.RO, DST.RO5.RO).keygen();
    (m, s) <@ Router11(A, XAw(DST.RO1.RO), XCw(DST.RO2.RO), Htrw(DST.RO3.RO), DST.RO4.RO,
                       Hctw(DST.RO5.RO), O).forge(pk);
    b <@ MLDSA_RO_DS13(XAw(DST.RO1.RO), XCw(DST.RO2.RO), DST.RO3.RO, DST.RO4.RO, DST.RO5.RO).verify(pk, m, s);
    return b /\ !(m \in qs);
  }
}.

section.

declare module A <: DS2.Adversary {
  -DS2.RO1.RO, -DS2.RO2.RO, -DS2.EUF_CMA, -XOFA_O, -XOFS_O, -MLDSA_RO_DS1, -RoutedH,
  -DS5.RO1.RO, -DS5.RO2.RO, -DS5.RO3.RO, -DS5.RO4.RO, -DS5.RO5.RO, -DS5.EUF_CMA, -RO_rest.RO,
  -RO_pad.RO, -RO_pad.FRO, -RO_seed.RO, -RO_S.RO, -RO_rhopp.RO, -RO_v.RO, -CountH, -CountS, -St5,
  -RO_lp.RO, -RO_lp.FRO, -St6, -St7, -Router, -RO_y.RO, -DS8.EUF_CMA, -DS10.EUF_CMA, -DS10.RO5.RO,
  -RO_hr.RO, -Router10, -DS11.EUF_CMA, -RO_xc.RO, -RO_xc.FRO, -Router11, -DST.RO1.RO, -DST.RO2.RO,
  -DST.RO3.RO, -DST.RO4.RO, -DST.RO5.RO, -DST.EUF_CMA, -RO_xr.RO, -G13 }.

lemma G12_G13 &m : Pr[G12(A).main() @ &m : res] = Pr[G13(A).main() @ &m : res].
proof.
byequiv (: ={glob A, glob XOFA_O} ==> ={res}) => //.
proc.
inline{1} Router11(A, XAw(DST.RO1.RO), XCw(DST.RO2.RO), Htrw(DST.RO3.RO), DST.RO4.RO, Hctw(DST.RO5.RO), G12(A).O).forge.
inline{2} Router11(A, XAw(DST.RO1.RO), XCw(DST.RO2.RO), Htrw(DST.RO3.RO), DST.RO4.RO, Hctw(DST.RO5.RO), G13(A).O).forge.
wp; call verify_13.
wp; call (: ={glob DST.RO1.RO, glob RO_xr.RO, glob DST.RO2.RO, glob DST.RO3.RO, glob DST.RO4.RO, glob DST.RO5.RO,
              glob XOFA_O, RO_y.RO.m, RO_rest.RO.m, RO_pad.RO.m, RO_hr.RO.m, Router11.tr} /\
            DS11.EUF_CMA.qs{1} = G13.qs{2} /\ sk_rel DS11.EUF_CMA.sk{1} G13.sk{2}).
+ by proc; call sign_13; auto.
+ proc; if => //.
  - by call (: ={DST.RO1.RO.m}); [by sim | auto].
  by call (: ={RO_xr.RO.m}); [by sim | auto].
+ proc; sp; if => //.
  - if => //.
    + by wp; call (: ={DST.RO4.RO.m}); [by sim | auto].
    by call (: ={RO_rest.RO.m}); [by sim | auto].
  if => //.
  - if => //.
    + wp; call (: ={RO_pad.RO.m}); 1: by sim.
      by wp; call (: ={DST.RO5.RO.m, RO_hr.RO.m}); [by sim | auto].
    by call (: ={RO_rest.RO.m}); [by sim | auto].
  if => //.
  - by call (: ={DST.RO2.RO.m}); [by sim | auto].
  if => //.
  - by wp; call (: ={DST.RO3.RO.m}); [by sim | auto].
  by call (: ={RO_rest.RO.m}); [by sim | auto].
call (: ={DST.RO3.RO.m}); 1: by sim.
inline{1} RO_rest.RO.init RO_pad.RO.init RO_hr.RO.init; inline{2} RO_rest.RO.init RO_pad.RO.init RO_hr.RO.init; wp.
call keygen_13.
by inline *; auto.
qed.

end section.
