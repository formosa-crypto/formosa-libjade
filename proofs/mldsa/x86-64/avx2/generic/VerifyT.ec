require import AllCore List IntDiv RealExp.
from Jasmin require import JModel_x86.
from Spec require import GFq Rq Parameters MLDSA_W32_Rep.
require import Array2 Array32 Array64 Array256.
require import BitEncoding JWordList.
require BaseT PreludeT PolynomialT CommonNttT CommonModularT CommonInvertNttT RoundingT.
require RowVectorT MatrixAT ChallengeT SignatureT CommitmentT T1T HashingT.

abstract theory VerifyT.

clone import BaseT.BaseT as B.
import S R MLDSAParams.
clone import PreludeT.PreludeT as PR with theory B <- B.
clone import PolynomialT.PolynomialT as PL with theory B <- B.
clone import CommonNttT.CommonNttT as CN with theory B <- B.
clone import CommonModularT.CommonModularT as CM with theory B <- B.
clone import CommonInvertNttT.CommonInvertNttT as CI with theory B <- B.
clone import RoundingT.RoundingT as RD with theory B <- B.
clone import RowVectorT.RowVectorT as RV with
  theory B <- B, theory PR <- PR, theory PL <- PL, theory CN <- CN, theory CM <- CM.
clone import MatrixAT.MatrixAT as MA with theory B <- B, theory PR <- PR.
clone import ChallengeT.ChallengeT as CH with theory B <- B.
clone import SignatureT.SignatureT as SG with theory B <- B, theory PR <- PR.
clone import CommitmentT.CommitmentT as CMT with theory B <- B, theory PR <- PR.
clone import T1T.T1T as T1 with theory B <- B, theory PR <- PR.
clone import HashingT.HashingT as HS with theory B <- B.
import CR.

import PolyLVec PolyKVec PolyMat.
import Round ZModQ Zq.
import Array_ctilde Array_pk_enc Array_sig_enc Array_t1_enc Array_w1vec_enc Array_kpolys.
import BitChunking.

lemma compare_commitment_hashes_ll : islossless M.__compare_commitment_hashes.
proof.
have hct : 16 <= ctilde /\ ctilde %% 16 = 0 by rewrite /ctilde; smt(param_sets).
proc.
wp; while (0 <= offset <= ctilde /\ offset %% 16 = 0) (ctilde - offset).
+ by move=> z; auto => /> /#.
by auto => /> /#.
qed.

(* The comparison of the two commitment hashes is unrolled on the size of
   the hash, which depends on the set: its correctness is a hypothesis of
   this theory, proved for each set. *)
axiom compare_commitment_hashes_correct (_lhs _rhs : W8.t Array_ctilde.t) :
  phoare [ M.__compare_commitment_hashes :
      arg.`1 = _lhs /\ arg.`2 = _rhs
      ==>
      res = (if _lhs = _rhs then W64.of_int 0 else -W64.one)
  ] = 1%r.


(* ================================================================== *)
(* reconstruct_signer_commitment                                       *)
(* Reconstructs w1' = UseHint(h, A*z - c*t1*2^d) for each of the kvec rows. *)
(* Per-component loop body:                                            *)
(*   t1_decode → shift_left → NTT → pmmar(c,t1) →                    *)
(*   subtract(az, ct1) → reduce32 → invNTT → cond_add_mod →          *)
(*   use_hints → write back                                            *)
(* Then commitment_encode on the result.                               *)
(* Spec: w1Encode(UseHint(h, Az - c*NTT^{-1}(NTT(t1*2^d)*chat)))    *)
(* ================================================================== *)

lemma reconstruct_signer_commitment_ll :
    islossless M.reconstruct_signer_commitment.
proof.
proc.
wp; call commitment____encode_ll.
while (0 <= i <= kvec) (kvec - i); last by auto => />; smt(gt0_k).
move => *; wp.
call polynomial__use_hints_ll; wp.
call polynomial__conditionally_add_modulus_ll.
call polynomial__invert_ntt_montgomery_ll.
call polynomial__reduce32_ll.
call polynomial__subtract_ll; wp.
call polynomial__pointwise_montgomery_multiply_and_reduce_ll.
call polynomial__ntt_ll.
call polynomial____shift_coefficients_left_ll.
call t1__decode_polynomial_ll.
by auto => /#.
qed.

(* Spec-level t1 polykvec obtained from the t1_encoded bytes (kvec chunks of 320 bytes, *)
(* each decoded via SimpleBitUnpack with range 2^(q_bits-d)-1 = 1023 = b_t1).        *)
op t1_from_t1enc (_t1enc : W8.t Array_t1_enc.t) : polykvec =
   KArray.init (fun i =>
      SimpleBitUnpack
        (take ((n * (q_bits - d)) %/ 8)
              (drop (((n * (q_bits - d)) %/ 8) * i) (to_list _t1enc)))
        (2^(q_bits - d) - 1)).

(* The reconstructed signer commitment at the spec level: the wapprox that the proc *)
(* computes internally, reused by the verify proof after algebra bridging.           *)
(* _az is row_vector____multiply_with_matrix_A's output, a sum of Montgomery         *)
(* products: it is read in Montgomery form (liftm), as invert_ntt consumes it.       *)
op signer_commitment_spec
     (_t1enc : W8.t Array_t1_enc.t) (_ch : W32.t Array256.t) (_az : W32.t Array_kpolys.t)
   : polykvec =
   invnttv (liftm_wpolykvec (kvec_unflatten256 _az)
             - ntt_smul (lifts_wpoly _ch)
                        (nttv (smul (t1_from_t1enc _t1enc) (incoeff (2^d))))).

lemma reconstruct_signer_commitment_correct
      (_t1enc : W8.t Array_t1_enc.t) (_ch : W32.t Array256.t)
      (_az : W32.t Array_kpolys.t) (_hints : W32.t Array_kpolys.t) :
    hoare [ M.reconstruct_signer_commitment :
        t1_encoded = _t1enc /\ challenge_as_ntt = _ch /\
        a_times_signer_response = _az /\ hints = _hints /\
        wpoly_ntt_orng _ch /\
        wpolykvec_urng (kvec_unflatten256 _hints) 2 /\
        (* _az is the output of row_vector____multiply_with_matrix_A: sum of lvec *)
        (* basemul results, each wpoly_srng (q-1) (q-1). Bound: lvec*(q-1).        *)
        wpolykvec_srng (kvec_unflatten256 _az) (lvec * (q-1)) (lvec * (q-1))
        ==>
        BytesW1.of_list (to_list res) =
          w1Encode (UseHint (liftu_wpolykvec (kvec_unflatten256 _hints))
                            (signer_commitment_spec _t1enc _ch _az))
    ].
proof.
proc => /=.
(* Post-loop: commitment____encode produces res from commitment.                       *)
(* commitment_encode's pre requires wpolykvec_urng _ b_w1 (values in [0..b_w1-1]).     *)
wp; ecall (commitment_encode commitment).
(* Outer kvec-iteration loop. Invariant tracks, for each processed component k < i:       *)
(*  (a) liftu (commitment.[k]) = poly_UseHint (liftu (_hints.[k])) (spec_commit.[k]);  *)
(*  (b) wpoly_urng ((q-1)/(2*gamma2)) commitment.[k]  (tight use_hints post = [0..15]) *)
while (0 <= i <= kvec /\ t1_encoded = _t1enc /\ challenge_as_ntt = _ch /\
       a_times_signer_response = _az /\ hints = _hints /\
       wpoly_ntt_orng _ch /\
       wpolykvec_urng (kvec_unflatten256 _hints) 2 /\
       wpolykvec_srng (kvec_unflatten256 _az) (lvec * (q-1)) (lvec * (q-1)) /\
       (forall k, 0 <= k < i =>
          liftu_wpoly (kvec_unflatten256 commitment).[k] =
            poly_UseHint
              (liftu_wpoly (kvec_unflatten256 _hints).[k])
              (signer_commitment_spec _t1enc _ch _az).[k] /\
          wpoly_urng ((q - 1) %/ (2 * gamma2)) (kvec_unflatten256 commitment).[k])
      ); last first.
+ (* Exit: aggregate per-component invariant to kvec level and bridge to w1Encode.    *)
  auto => |> Hch_rng Hhints_rng Haz_rng; split; 1: smt(gt0_k).
  move => cm_exit i_exit Hng Hi1 Hi2 Hdone.
  have Hlifts_cm :
      liftu_wpolykvec (kvec_unflatten256 cm_exit) =
      UseHint (liftu_wpolykvec (kvec_unflatten256 _hints))
              (signer_commitment_spec _t1enc _ch _az).
  + rewrite /UseHint; apply KArray.tP => k kb.
    rewrite KArray.map2iE 1:/# /= /liftu_wpolykvec KArray.mapiE 1:/# /=.
    rewrite KArray.mapiE 1:/# /=.
    by have /= [-> _] := Hdone k _; smt(gt0_k).
  (* commitment_encode's pre: the invariant bounds each component by hb_range *)
  split.
  + rewrite /wpolykvec_urng KArray.allP => k kbl.
    by have /= [_ Hrng] := Hdone k _; 1: smt(gt0_k).
  (* commitment_encode's post, polynomial by polynomial, against w1Encode *)
  move => _ encres Hunflat.
  rewrite Hlifts_cm in Hunflat.
  rewrite /w1Encode; apply BytesW1.tP => k kb.
  rewrite !BytesW1.get_of_list 1,2:/# get_to_list (w1_unflatteniE encres k) 1:/# Hunflat.
  have Hk : 0 <= k < kvec * w1_enc by move: kb; rewrite -w1vec_encE /w1vec_enc.
  have [Hq Hr] := blk_idx kvec w1_enc k gt0_w1_enc Hk.
  have Hhb : 1 <= hb_range - 1 by rewrite /hb_range; smt(gamma2_cases).
  have Hsz : forall p, size (SimpleBitPack p (hb_range - 1)) = w1_enc.
  + by move=> p; rewrite size_SimpleBitPack // ilog_w1 w1_encE.
  rewrite KArray.mapiE // /= Array_w1_enc.get_of_list ?Hsz //.
  rewrite (BitChunking.nth_flatten witness w1_enc).
  + by rewrite allP => s /mapP [wi [_ ->]] /=; rewrite Hsz.
  rewrite (nth_map witness); 1: by rewrite size_mkseq; smt(gt0_k).
  by rewrite nth_mkseq.
(* Loop body: 9-call chain (t1_decode → shift → ntt → pmmar → subtract → reduce32 →    *)
(*   invert_ntt → caddq → use_hints) + writeback. The ecall chain is structurally      *)
(* threaded below.                              *)
wp.
ecall (polynomial__use_hints_correct commitment_element hints_element).
wp.
ecall (polynomial__conditionally_add_modulus_correct commitment_element).
ecall (polynomial__invert_ntt_montgomery_correct commitment_element).
ecall (polynomial__reduce32_correct commitment_element).
ecall (polynomial__subtract_correct commitment_element az_element c_times_t1
         (lvec * (q-1)) (q-1)).
wp.
ecall (polynomial__pointwise_montgomery_multiply_and_reduce_correct
         c_times_t1 challenge_as_ntt t1_element).
ecall (polynomial__ntt_correct t1_element).
ecall (polynomial____shift_coefficients_left_correct t1_element).
ecall (t1_decode_polynomial
         (Array320.Array320.init
            (fun j => t1_encoded.[(q_bits - d) * n %/ 8 * i + j]))).
auto => /> &hr Hi1 Hi2 Hch_rng Hhints_rng Haz_rng Hdone Hguard.
move => result Hliftu_t1 Hurng_t1 Hurng_t1_1024 result0 Hto_sint_shift Hsrng_shift.
(* ntt's and pmmar's pres are the ranges at hand (ntt_irng = srng (q-1); *)
(* ntt_orng = bmul_irng): discharged by auto                              *)
move => _ result1 Hlifts_ntt Horng_ntt _ _ result2 Hlifts_pmmar Hsrng_pmmar.
(* subtract's pre: wpoly_srng on az slice + arithmetic bound *)
split.
+ split; 2: smt(param_sets).
  have /= Hslice := kvec_slice_eq _az (i{hr} * n) _ _; 1,2: smt().
  have Hdiv : i{hr} * n %/ n = i{hr} by smt().
  move: Hslice; rewrite Hdiv => Hslice.
  rewrite -Hslice.
  by move: Haz_rng; rewrite /wpolykvec_srng KArray.allP => H; apply H; smt(gt0_k).
move => _ _ result3 Hlifts_sub Hsrng_sub.
split; first by apply (wpoly_srng_widen result3 (lvec * 8380416 + 8380416) (lvec * 8380416 + 8380416) 2143289343 2143289343); [ smt(param_sets) | smt(param_sets) | exact Hsrng_sub ].
move => _ result4 Hlifts_red Hsrng_red.
(* invert_ntt's pre: wpoly_intt_irng via widening + bridge *)
split; first by apply wpoly_bmul_orng_intt_irng;
  apply (wpoly_srng_widen _ 6283009 6283008 (q-1) (q-1)); smt().
move => _ result5 Hlifts_invntt Hsrng_invntt.
(* caddq's pre: wpoly_srng (q-1) (q-1) via widening *)
split; first by apply (wpoly_srng_widen _ invntt_obound invntt_obound (q-1) (q-1));
  first 2 smt(invntt_obound_fits_for_caddq param_sets);
  exact Hsrng_invntt.
move => _ result6 Hlifts_caddq Hurng_caddq.
(* use_hints' pre: wpoly_urng 2 hints slice *)
split.
+ have /= Hslice_h := kvec_slice_eq _hints (i{hr} * n) _ _; 1,2: smt().
  have Hdiv_h : i{hr} * n %/ n = i{hr} by smt().
  move: Hslice_h; rewrite Hdiv_h => Hslice_h.
  rewrite -Hslice_h.
  by move: Hhints_rng; rewrite /wpolykvec_urng KArray.allP => H; apply H; smt(gt0_k).
move => _ result7 Hliftu_useh Hurng_useh.
(* Final goal: invariant at i+1 *)
split; 1: smt().
move => k Hk_lo Hk_hi.
have /= Hwb :=
  kvec_unflatten256_writeback_iE commitment{hr} result7 (i{hr} * n) k _ _;
  1,2: smt(gt0_k).
rewrite Hwb.
case (k = i{hr}) => Hki.
+ (* New component k = i *)
  subst k; have Hnnd : i{hr} * n %/ n = i{hr} by smt().
  rewrite Hnnd ifT //; split; last exact Hurng_useh.
  rewrite Hliftu_useh.
  (* Match poly_UseHint's two args *)
  have H_hints_slice : liftu_wpoly (init (fun (i_0 : int) => _hints.[i{hr} * n + i_0])) =
                       (liftu_wpoly (kvec_unflatten256 _hints).[i{hr}]).
  + have /= Hslice_h2 := kvec_slice_eq _hints (i{hr} * n) _ _; 1,2: smt().
    move: Hslice_h2; rewrite Hnnd => Hslice_h2.
    by rewrite Hslice_h2.
  rewrite H_hints_slice; congr.
  (* Algebraic chain: liftu result6 = (signer_commitment_spec ...).[i] *)
  have Hliftu_eq : liftu_wpoly result6 = lifts_wpoly result6
    by rewrite -wpoly_urng_lifts_eq_liftu.
  (* the inverse NTT consumes Montgomery form: read the subtraction through liftm *)
  have Hm : liftm_wpoly result4 =
      liftm_wpoly (init (fun (i_0 : int) => _az.[i{hr} * n + i_0])) &+
      (&-) (basemul (lifts_wpoly _ch) (lifts_wpoly result1)).
  + by rewrite -Hlifts_pmmar /liftm_wpoly Hlifts_red Hlifts_sub scaleD scaleN.
  rewrite Hliftu_eq Hlifts_caddq Hlifts_invntt Hm Hlifts_ntt.
  (* Unfold signer_commitment_spec + decompose the kvec ops *)
  rewrite /signer_commitment_spec /invnttv KArray.mapiE; 1: smt(gt0_k).
  rewrite polykvec_sub_iE; 1: smt(gt0_k).
  congr; congr.
  + (* liftm_wpoly az_slice = (liftm_wpolykvec ...).[i] *)
    rewrite /liftm_wpolykvec mapiE; 1: smt(gt0_k).
    congr; by rewrite -kvec_slice_eq; smt().
  (* Remaining: basemul _ch (ntt (lifts result0))
       = (&-) ((ntt_smul _ch (nttv (smul t1_spec (incoeff 2^d)))).[i])  *)
  (* Wait — need to match against the FULL (&-) term *)
  congr.
  rewrite /ntt_smul KArray.mapiE; 1: smt(gt0_k).
  rewrite /= /nttv KArray.mapiE; 1: smt(gt0_k).
  rewrite /smul KArray.mapiE; 1: smt(gt0_k).
  rewrite /=.
  (* Bridge: lifts_wpoly (shift result) = smul t1_spec (incoeff 2^d) at index i.      *)
  (* Per-coeff: Hto_sint_shift gives to_sint = to_uint * 2^d. After incoeffM and      *)
  (* Zq commutativity the remaining obligation reduces to the byte-list equality      *)
  (*   Array320.to_list (init (fun k => _t1enc.[320*i + k])) =                         *)
  (*   take 320 (drop (320*i) (to_list _t1enc))                                        *)
  (* which we close via eq_from_nth + size_take/size_drop + get_to_list/initiE.        *)
  have Hlifts_shift_eq :
      lifts_wpoly result0 = map ((( * ) (incoeff (2^d))))
                                (t1_from_t1enc _t1enc).[i{hr}].
  + apply Array256.tP => j jb.
    rewrite /lifts_wpoly mapiE 1:/# /= (Hto_sint_shift j jb).
    rewrite mapiE 1:/# /=.
    rewrite /t1_from_t1enc KArray.initiE; 1: smt(gt0_k).
    rewrite /=.
    rewrite incoeffM Zq.ComRing.mulrC; congr.
    have <- : liftu_wpoly result = SimpleBitUnpack
                (take 320 (drop (320 * i{hr}) (to_list _t1enc))) 1023.
    + rewrite Hliftu_t1 /b_t1 /=; congr.
      apply (eq_from_nth witness).
      + rewrite Array320.Array320.size_to_list size_take 1:/# size_drop 1:/#
                size_to_list /= /#.
      move => i0 Hi0.
      move: Hi0; rewrite Array320.Array320.size_to_list => Hi0.
      rewrite Array320.Array320.get_to_list Array320.Array320.initiE 1:/# /=.
      rewrite nth_take 1:/# 1:/# nth_drop 1:/# 1:/#.
      by rewrite get_to_list.
    by rewrite /liftu_wpoly mapiE 1:/#.
  rewrite Hlifts_shift_eq.
  (* basemul (lifts _ch) X = basemul X (lifts _ch) — use tP + init.                   *)
  (* W13_eq normalizes XWord13.W13.modulus (= 8192 = 2^d) on LHS to match RHS's 8192. *)
  apply Array256.tP => j jb.
  have W13_eq : XWord13.W13.modulus = 8192 by smt(XWord13.W13.ge2_modulus).
  rewrite W13_eq.
  rewrite /basemul !initiE 1,2:/# /=; first smt(gt0_k).
  by rewrite Zq.ComRing.mulrC.
+ (* Old component k < i: via Hdone *)
  have -> : (k = i{hr} * n %/ n) = false by smt().
  rewrite /=.
  by have /= := Hdone k _; first smt().
qed.

lemma reconstruct_signer_commitment_ph
      (_t1enc : W8.t Array_t1_enc.t) (_ch : W32.t Array256.t)
      (_az : W32.t Array_kpolys.t) (_hints : W32.t Array_kpolys.t) :
    phoare [ M.reconstruct_signer_commitment :
        t1_encoded = _t1enc /\ challenge_as_ntt = _ch /\
        a_times_signer_response = _az /\ hints = _hints /\
        wpoly_ntt_orng _ch /\
        wpolykvec_urng (kvec_unflatten256 _hints) 2 /\
        wpolykvec_srng (kvec_unflatten256 _az) (lvec * (q-1)) (lvec * (q-1))
        ==>
        BytesW1.of_list (to_list res) =
          w1Encode (UseHint (liftu_wpolykvec (kvec_unflatten256 _hints))
                            (signer_commitment_spec _t1enc _ch _az))
    ] = 1%r
  by conseq reconstruct_signer_commitment_ll
            (reconstruct_signer_commitment_correct _t1enc _ch _az _hints).

(* the threshold of the norm check of the signer response *)
lemma thr_gamma1E : (1 `<<` gamma1m1_bits) - tau * Eta = gamma1 - Beta.
proof. by rewrite /(`<<`) /gamma1m1_bits /gamma1 /Beta ifT; [smt(param_sets) | done]. qed.

lemma gamma1_q2 : gamma1 <= q %/ 2 by smt(gamma1_cases).

lemma gamma1_beta_bnd : 0 < gamma1 - Beta <= q %/ 2 by smt(gamma1_q2 beta_gamma1_lt gt0_beta).

lemma verify_internal_correct _m :
    equiv [ MLDSA(MLDSA_XOFA, MLDSA_XOFS, MLDSA_XOF_SIB, SIB_RO).verify ~ M.__verify_internal :
       Glob.mem{2} = _m /\
       arg{1}.`1 = BytesPK.of_list (to_list verification_key{2})
    /\ arg{1}.`2 = BytesSig.init (fun i => signature_encoded{2}.[i])
    /\ 0 <= context_size{2} <= 255
    /\ 0 <= message_size{2}
    /\ 0 <= context_pointer{2} /\ context_pointer{2} + context_size{2} < 18446744073709551616
    /\ message_pointer{2} + message_size{2} < 18446744073709551616
    /\ arg{1}.`3 = [W8.zero; W8.of_int context_size{2}]
                   ++ memread _m context_pointer{2} context_size{2}
                   ++ memread _m message_pointer{2} message_size{2}
       ==>
       Glob.mem{2} = _m /\
       res{1} = (res{2} = W64.of_int 0)
   ].
proof.

proc => /=; conseq |>.

seq 1 9 : #pre; 1: by auto.
sp 1 0.
seq 1 0 : (#pre /\
    rho{1} = Bytes32.of_list (take 32 (BytesPK.to_list pk{1})) /\
    t1{1}  = KArray.init (fun i =>
        SimpleBitUnpack
          (take ((n * (q_bits-d)) %/ 8)
                (drop (((n * (q_bits-d)) %/ 8) * i + 32) (BytesPK.to_list pk{1})))
          (2^(q_bits - d) - 1))).
+ ecall{1} (pkDecode_corr pk{1}).
  by auto.

seq 1 1 : (#pre /\
    ct{1} = BytesCT.init (fun i => signature_encoded{2}.[i]) /\
    lifts_wpolylvec (lvec_unflatten256 signer_response{2}) = z{1} /\
    wpolylvec_srng (lvec_unflatten256 signer_response{2}) (gamma1 - 1) gamma1 /\
    (h{1} = None => result1{2} = -W64.one) /\
    (h{1} <> None =>
        result1{2} = W64.zero /\
        liftu_wpolykvec (kvec_unflatten256 hints{2}) = oget h{1} /\
        wpolykvec_urng (kvec_unflatten256 hints{2}) 2)).
+ ecall (signature_decode signature_encoded{2}).
  by auto.
seq 0 1 : (#pre /\
    (!wpolylvec_infnorm_lt (gamma1 - Beta) (lvec_unflatten256 signer_response{2}) => result2{2} <> W64.of_int 0) /\
    (wpolylvec_infnorm_lt (gamma1 - Beta) (lvec_unflatten256 signer_response{2})  => result2{2} = W64.zero)).
+ ecall {2} (row_vector____check_infinity_norm_correct signer_response{2}
    ((1 `<<` gamma1m1_bits) - tau * Eta)).
  auto => /> &1 &2 6? rr0.
  by rewrite thr_gamma1E; smt(gamma1_beta_bnd).
  
if {1}; last first.
+ sp 0 2; rcondf {2} 1.
  + auto => |> &hr 7? -> ??.
    have ? : (- W64.one <> W64.zero); last by smt(or64_ne0).
    by rewrite to_uint_eq to_uintN  /=.
  auto => /> &2 7? -> ??.
    have ? : (- W64.one <> W64.zero); last by smt(or64_ne0).
    by rewrite to_uint_eq to_uintN  /=.
  
sp;if {2}; last first.
+ wp; call {1} (: true ==> true); 1: by proc*; exlim  rho => _rho;  call (SampleInBall_correct _rho).
  wp; call {1} (: true ==> true); 1: by proc*; exlim  rho => _rho;  call (ExpandA_correct _rho).
  auto => /> &1 &2 12? rr0 rr1.
  have ? : (!wpolylvec_infnorm_lt (gamma1 - Beta) (lvec_unflatten256 signer_response{2})) by smt(or64_ne0).
  have Hrng : wpolylvec_srng (lvec_unflatten256 signer_response{2}) (gamma1-1) gamma1 by smt().
  have Hb := gamma1_beta_bnd.
  have Hq1 : (gamma1-1) + 1 <= q %/ 2 by smt(gamma1_q2).
  have Hq2 := gamma1_q2.
  have ? := wpolylvec_infnorm_unliftE (gamma1-Beta) (gamma1-1) gamma1
              (lvec_unflatten256 signer_response{2}) Hb Hq1 Hq2 Hrng.
  by smt().
  
(* expand A *)
seq 1 1 : (#pre /\
      liftu_wpolymat (mat_unflatten256 matrix_A{2}) = _A{1} /\
      wpolymat_urng (mat_unflatten256 matrix_A{2}) q).
  + ecall{1} (ExpandA_correct rho{1}).
    ecall{2} (matrix_A_correct (Array32.init (fun i => verification_key{2}.[i]))).
    auto => |> &1 &2 13? rr0 -> ?;congr.
    apply Bytes32.tP => k kb.
    do 2!(rewrite Bytes32.get_of_list //).
    rewrite get_to_list initiE 1:/# /=.
    rewrite nth_take 1,2:/# BytesPK.get_to_list /=.
    by rewrite BytesPK.get_of_list ?size_to_list -?pk_encE; smt(ge0_t1_enc).

(* anticipate hashing *)
swap {2} [8..11] -7.

(* verification key hash. *)
sp 1 1.
seq 0 1 : (#pre /\
      verification_key_hash{2} =
        Array64.of_list witness (Bytes64.to_list (H_tr pk{1}))).
  + ecall{2} (hash_verification_key_correct verification_key{2}).
    by auto.

(* message representative *)
sp 1 1.
seq 0 1 : (#pre /\
      message_representative{2} =
        Array64.of_list witness (Bytes64.to_list mu{1})).
  + ecall{2} (derive_message_representative_ph
                 verification_key_hash{2}
                 (memread _m context_pointer{2} context_size{2})
                 (memread _m message_pointer{2} message_size{2})).
    wp; skip => /> &1 &2 *; do split.
    + by rewrite !size_memread /=; smt(W64.to_uint_cmp).
    + by rewrite !size_memread /=; smt(W64.to_uint_cmp).
    + by rewrite !size_memread /=; smt(W64.to_uint_cmp).
    + by rewrite !size_memread /=;  smt(W64.to_uint_cmp).
    move => 4?;do congr.
    + rewrite Bytes64.tP => k kb.
      by rewrite Bytes64.get_of_list // get_to_list get_of_list //.
    + by rewrite size_memread 1:/# /truncateu8 W64.of_uintK (pmod_small _ W64.modulus) //; smt().
   
(* anticipate sib *)
swap {2} [4..5] -3.
  seq 1 1 : (#pre /\ lifts_wpoly challenge{2} = c{1} /\ wpoly_srng 1 1 challenge{2}).
  + call sample_challenge_correct.
    wp; skip => /> &1 &2 *.
    rewrite BytesCT.tP => i ib.
    rewrite BytesCT.initiE 1:/# BytesCT.get_of_list 1:/#.
    by rewrite get_to_list initiE /#.

(* Ghost-bind pre-NTT signer_response and challenge — the seq 2 4 below NTTs   *)
(* them in place, so the infnorm/range/lifts facts we established earlier      *)
(* (which reference the memory vars signer_response{2} / challenge{2}) would   *)
(* become false post-seq if left as literal memory references.                 *)
exlim signer_response{2} => _sr_pre.
exlim challenge{2} => _ch_pre.

(* jump over algebra *)
seq 2 6 :
  (#{/~signer_response{2}}{/~challenge{2}}pre /\
    lifts_wpolylvec (lvec_unflatten256 _sr_pre) = z{1} /\
    wpolylvec_srng (lvec_unflatten256 _sr_pre) (gamma1 - 1) gamma1 /\
    (!wpolylvec_infnorm_lt (gamma1 - Beta) (lvec_unflatten256 _sr_pre) => result2{2} <> W64.of_int 0) /\
    (wpolylvec_infnorm_lt (gamma1 - Beta) (lvec_unflatten256 _sr_pre) => result2{2} = W64.zero) /\
    lifts_wpoly _ch_pre = c{1} /\
    wpoly_srng 1 1 _ch_pre /\
    BytesW1.of_list (to_list reconstructed_signer_commitment{2}) = w1Encode w1{1}); last first.

(* recompute hash *)
sp 1 0.
seq 0 1 : (#pre /\
      expected_commitment_hash{2} =
        Array_ctilde.of_list witness (BytesCT.to_list (H_ct mu{1} (w1Encode w1{1})))).
  + ecall{2} (derive_commitment_hash_ph message_representative{2}
                 reconstructed_signer_commitment{2}).
    wp; skip => /> &1 &2 *; do congr.
    rewrite Bytes64.tP => k kb.
    + by rewrite Bytes64.get_of_list // get_to_list get_of_list //.

 wp; ecall{2} (compare_commitment_hashes_correct expected_commitment_hash{2} (Array_ctilde.init (fun (i : int) => signature_encoded{2}.[0 + i]))).
 
 wp;skip => /> &1 &2 *.
 pose xx := H_ct
   (H_mu (H_tr (BytesPK.of_list (to_list verification_key{2})))
      (W8.zero :: W8.of_int context_size{2} :: (memread _m context_pointer{2} context_size{2} ++  memread _m message_pointer{2} message_size{2}))) (
   w1Encode w1{1}).
have ? : wpolylvec_infnorm_lt (gamma1 - Beta) (lvec_unflatten256 _sr_pre) by smt(or64_ne0).
have -> /=: infnorm_lt (lifts_wpolylvec (lvec_unflatten256 _sr_pre)) (gamma1 - Beta).
+ by apply (wpolylvec_infnorm_liftE _ _ gamma1_beta_bnd).
suff: ((BytesCT.init ("_.[_]" signature_encoded{2}) = xx) <=>  (Array_ctilde.of_list witness (BytesCT.to_list xx) = Array_ctilde.init ("_.[_]" signature_encoded{2}))); last first.
+ by rewrite tP BytesCT.tP /=;split => H i ib; have := H i _;[ by smt() | rewrite get_of_list 1:/# BytesCT.get_to_list BytesCT.initiE 1:/# /= initiE /#  | by smt() | rewrite get_of_list 1:/# BytesCT.get_to_list BytesCT.initiE 1:/# /= initiE /# ].

move => -> ; pose bb := Array_ctilde.of_list witness (BytesCT.to_list xx) = Array_ctilde.init ("_.[_]" signature_encoded{2}).
by case (bb) => //=; rewrite to_uint_eq to_uintN /=.

(* algebra: the forward head of `seq 2 4` — chain the four Jasmin ecalls        *)
(* (polynomial__ntt on challenge, row_vector__ntt on signer_response,           *)
(*  row_vector____multiply_with_matrix_A, reconstruct_signer_commitment) then   *)
(* substitute the spec's wapprox via the known lifted equalities (nttv, ntt,    *)
(* matrix multiply) and the pkDecode ↔ t1_from_t1enc slice identity.             *)
sp 2 0.
wp; ecall{2} (reconstruct_signer_commitment_ph
                (Array_t1_enc.init (fun i => verification_key{2}.[32 + i]))
                challenge{2} a_times_signer_response{2} hints{2}).
wp; ecall{2} (row_vector____multiply_with_matrix_A_ph matrix_A{2} signer_response{2}).
wp; ecall{2} (row_vector__ntt_ph signer_response{2}).
wp; ecall{2} (polynomial__ntt_ph challenge{2}).
auto => />.
move => &1 &2 ? Hctx Hmsg ? Hov1 Hov2 Hz_srng Hh_none Hh_some_case Hr2_nz Hr2_z Hh_some Hor HA Hc_srng.
split; first by apply wpoly_srng_ntt_irng; apply (wpoly_srng_widen _ 1 1 (q-1) (q-1)); smt().
move => _ result0 Hlift_chal Horng_chal.
split; first by apply wpolylvec_srng_ntt_irng;
  apply (wpolylvec_srng_widen _ (gamma1-1) gamma1 (q-1) (q-1)); smt(gamma1_q2).
move => _ result3 Hlift_s_ntt Horng_s.
move => _ result4 Hlift_amulz Hsrng_amulz.
have [Hr1z [Hh_lift Hh_urng]] := Hh_some_case Hh_some.
split; first exact Hh_urng.
move => _ result5 Hreconstruct.
rewrite Hreconstruct Hh_lift.
congr; congr.
rewrite /signer_commitment_spec Hlift_amulz Hlift_s_ntt Hlift_chal.
congr; congr; congr; congr; congr.
+ (* t1_from_t1enc (init (fun i => verification_key0.[32+i])) = pkDecode t1 form *)
  rewrite /t1_from_t1enc.
  apply KArray.tP => k kb.
  rewrite !KArray.initiE; 1,2: smt(gt0_k).
  rewrite /= BytesPK.of_listK; 1: by rewrite size_to_list /#.
  congr; congr.
  have -> : to_list (Array_t1_enc.init (fun i => verification_key{2}.[32 + i])) =
            drop 32 (to_list verification_key{2}).
  + apply (eq_from_nth witness); 1: by rewrite size_to_list size_drop 1:/# size_to_list /#.
    move => i Hi.
    rewrite get_to_list Array_t1_enc.initiE /=;
      1: by move: Hi; rewrite size_to_list.
    by rewrite nth_drop 1:/# 1:/# get_to_list /#.
  by rewrite drop_drop 1,2:/#.
+ (* incoeff XWord13.W13.modulus = incoeff 8192 *)
  have W13_eq : XWord13.W13.modulus = 8192 by smt(XWord13.W13.ge2_modulus).
  by rewrite W13_eq.
qed.

end VerifyT.
