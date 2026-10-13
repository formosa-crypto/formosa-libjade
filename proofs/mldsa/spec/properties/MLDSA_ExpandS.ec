require import AllCore IntDiv List Distr DInterval DList Xreal StdBigop.
from Jasmin require import JWord.
require import Array256.

require import DistrExtra JWordExtra.
require import Parameters GFq Rq Conversion Serialization Symmetric Sampling.
import Round ZModQ Zq MLDSAParams Bigreal.

lemma eta_cases : Eta = 2 \/ Eta = 4 by smt(param_sets).

(* -------------------------------------------------------------------- *)
(* RejBoundedPoly's loop as a transformer of its state (j, a): a        *)
(* half-byte appends a coefficient when accepted and 0 <= j < 256, a    *)
(* byte processes its low half-byte, then its high half-byte            *)
type rbp_state = int * poly.

op rbp_nib (st : rbp_state) (n : int) : rbp_state =
  if 0 <= st.`1 < 256 then
    match CoeffFromHalfByte n with
    | None => st
    | Some c => (st.`1 + 1, st.`2.[st.`1 <- incoeff c])
    end
  else st.

op rbp_byte (st : rbp_state) (b : W8.t) : rbp_state =
  rbp_nib (rbp_nib st (to_uint b %% 16)) (to_uint b %/ 16).

(* a uniform byte is a pair of uniform half-bytes, low half first *)
op of_nibs (p : int * int) : W8.t = W8.of_int (p.`1 + 16 * p.`2).

lemma dword_nibs : W8.dword = dmap ([0..15] `*` [0..15]) of_nibs.
proof.
apply eq_funi_ll; [exact W8.dword_funi | exact W8.dword_ll | | ].
- apply is_full_funiform.
  + move=> w; apply/supp_dmap; exists (to_uint w %% 16, to_uint w %/ 16).
    rewrite supp_dprod !supp_dinter /of_nibs /=.
    have [h0 h1] := W8.to_uint_cmp w; rewrite (: W8.modulus = 256) // in h1.
    by split; [smt() | rewrite addzC mulzC -divz_eq W8.to_uintK].
  apply dmap_uni_in_inj; 2: by apply dprod_uni; apply dinter_uni.
  move=> [l1 h1] [l2 h2]; rewrite !supp_dprod !supp_dinter /of_nibs /= => r1 r2.
  move/(congr1 W8.to_uint); rewrite !W8.of_uintK !modz_small; 1,2: smt().
  smt().
by apply dmap_ll; apply dprod_ll; split; apply dinter_ll.
qed.

(* -------------------------------------------------------------------- *)
(* a potential on the state that is preserved, in expectation, by a     *)
(* uniform half-byte is preserved by a uniform byte, and by a list of   *)
(* uniform bytes                                                        *)
op nib_mart (F : rbp_state -> xreal) =
  forall st, Ep [0..15] (fun n => F (rbp_nib st n)) = F st.

lemma rbp_byte_nibs st lo hi : 0 <= lo <= 15 => 0 <= hi <= 15 =>
  rbp_byte st (of_nibs (lo, hi)) = rbp_nib (rbp_nib st lo) hi.
proof.
move=> hlo hhi; rewrite /rbp_byte /of_nibs /= (modz_small (lo + 16 * hi)) 1:/#.
by rewrite mulzC modzMDr divzMDr // modz_small 1:/# divz_small 1:/#.
qed.

lemma byte_mart F : nib_mart F =>
  forall st, Ep W8.dword (fun b => F (rbp_byte st b)) = F st.
proof.
move=> hF st; rewrite dword_nibs Ep_dmap dprod_dlet Ep_dlet -hF.
apply eq_Ep => lo /supp_dinter hlo /=; rewrite Ep_dlet -hF.
apply eq_Ep => hi /supp_dinter hhi /=.
by rewrite Ep_dunit /= rbp_byte_nibs.
qed.

lemma block_mart F : nib_mart F =>
  forall k st, 0 <= k => Ep (dlist W8.dword k) (fun l => F (foldl rbp_byte st l)) = F st.
proof.
move=> hF; elim/natind => [k le0k st ge0k|k ge0k ih st _].
- by rewrite (_ : k = 0) 1:/# dlist0 // Ep_dunit.
rewrite dlistS //= Ep_dmap dprod_dlet Ep_dlet -(byte_mart F hF st).
apply eq_Ep => b _ /=; rewrite Ep_dlet -(ih (rbp_byte st b) ge0k).
by apply eq_Ep => l _ /=; rewrite Ep_dunit.
qed.

(* -------------------------------------------------------------------- *)
(* the half-bytes accepted by CoeffFromHalfByte hit every coefficient   *)
(* of [-Eta..Eta] equally often: 3 times for Eta = 2, once for Eta = 4  *)
op nib_mult = if Eta = 2 then 3 else 1.

hint simplify in rangered : range_geq, range_ltn, BRA.big_consT, BRA.big_nil.

lemma nib_sum (h : int option -> real) :
  BRA.bigi predT (fun n => h (CoeffFromHalfByte n)) 0 16
  = (16 - nib_mult * (2 * Eta + 1))%r * h None
    + nib_mult%r * BRA.bigi predT (fun c => h (Some c)) (-Eta) (Eta + 1).
proof.
by rewrite /nib_mult /CoeffFromHalfByte; case: eta_cases => ->; simplify hint +rangered; ring.
qed.

lemma sum_b2r ['a] (P : 'a -> bool) s : BRA.big predT (fun x => b2r (P x)) s = (count P s)%r.
proof.
elim: s => [|x s ih] /=; 1: by rewrite BRA.big_nil.
rewrite BRA.big_consT /= ih fromintD.
by case: (P x) => _ /=; rewrite ?b2i1 ?b2i0.
qed.

(* -------------------------------------------------------------------- *)
(* the potential of the event [res = t]: the coefficients produced so   *)
(* far agree with t, times the probability of drawing the remaining     *)
(* coefficients of t                                                    *)
op dcoeff : coeff distr = dmap [-Eta..Eta] incoeff.

lemma mu1_dcoeff x : mu1 dcoeff x
  = BRA.bigi predT (fun c => b2r (incoeff c = x)) (-Eta) (Eta + 1) / (2 * Eta + 1)%r.
proof.
rewrite dmap1E dinterE size_filter /(\o) /pred1 sum_b2r.
by have := gt0_eta; smt().
qed.

op agree (t : poly) (st : rbp_state) = forall i, 0 <= i < st.`1 => st.`2.[i] = t.[i].

op rbp_tail (t : poly) (j : int) = BRM.bigi predT (fun i => mu1 dcoeff t.[i]) j 256.

op rbp_pot (t : poly) (st : rbp_state) = b2r (agree t st) * rbp_tail t st.`1.

lemma agree_set t j (a : poly) x : 0 <= j < 256 =>
  agree t (j + 1, a.[j <- x]) <=> agree t (j, a) /\ x = t.[j].
proof.
move=> hj; rewrite /agree /=; split => [h | [h ->] i hi].
- split => [i hi|]; 1: by rewrite -h 1:/# get_setE /#.
  by rewrite -(h j) 1:/# get_setE /#.
by rewrite get_setE //; case: (i = j) => [-> // | hij]; rewrite h /#.
qed.

lemma rbp_tailS t j : j < 256 => rbp_tail t j = mu1 dcoeff t.[j] * rbp_tail t (j + 1).
proof. by move=> hj; rewrite /rbp_tail BRM.big_ltn. qed.

(* the potential is a martingale for a uniform half-byte *)
lemma rbp_pot_nib t st :
  BRA.bigi predT (fun n => rbp_pot t (rbp_nib st n)) 0 16 = 16%r * rbp_pot t st.
proof.
case: st => j a; case: (0 <= j < 256) => hj; last by rewrite /rbp_nib /= hj /= sumri_const.
pose h := oapp (fun c => b2r (agree t (j, a)) * b2r (incoeff c = t.[j]) * rbp_tail t (j + 1))
               (rbp_pot t (j, a)).
have -> : (fun n => rbp_pot t (rbp_nib (j, a) n)) = (fun n => h (CoeffFromHalfByte n)).
- apply fun_ext => n; rewrite /rbp_nib /= hj /h /=; case: (CoeffFromHalfByte n) => //= c.
  by rewrite /rbp_pot /= agree_set //; smt().
rewrite nib_sum /h /= /rbp_pot /= rbp_tailS 1:/# mu1_dcoeff.
rewrite -BRA.mulr_suml -BRA.mulr_sumr.
have : (2 * Eta + 1)%r <> 0%r by smt(gt0_eta).
rewrite fromintB fromintM; move: ((2 * Eta + 1)%r) => d hd.
by field.
qed.

lemma nib_mart_real (f : rbp_state -> real) :
  (forall st, 0%r <= f st) =>
  (forall st, BRA.bigi predT (fun n => f (rbp_nib st n)) 0 16 = 16%r * f st) =>
  nib_mart (fun st => (f st)%xr).
proof.
move=> ge0f hf st /=; rewrite Ep_dinterval /= bigiXR 1:/# hf.
rewrite smulrp -of_realI -of_realM //; 1,2: smt().
by have -> : inv 16%r * (16%r * f st) = f st by field.
qed.

lemma rbp_tail_rng t j : 0%r <= rbp_tail t j <= 1%r.
proof.
split; 1: by apply prodr_ge0 => i _ /=; apply ge0_mu.
have <- := BRM.big1_eq predT<:int> (range j 256).
by move=> _; apply ler_prod => i _ /=; rewrite ge0_mu le1_mu.
qed.

lemma rbp_pot_rng t st : 0%r <= rbp_pot t st <= 1%r.
proof. by rewrite /rbp_pot; have := rbp_tail_rng t st.`1; case: (agree t st). qed.

(* the potentials of [res = t] and of [res <> t] *)
lemma pot_mart t : nib_mart (fun st => (rbp_pot t st)%xr).
proof. by apply nib_mart_real; [move=> st; have := rbp_pot_rng t st | apply rbp_pot_nib]. qed.

lemma copot_mart t : nib_mart (fun st => (1%r - rbp_pot t st)%xr).
proof.
apply nib_mart_real => st /=; 1: by have := rbp_pot_rng t st; smt().
by rewrite -BRA.sumrB sumri_const // rbp_pot_nib; ring.
qed.

lemma foldl_rbp_done l (a : poly) : foldl rbp_byte (256, a) l = (256, a).
proof. by elim: l => //= b l; rewrite {1}/rbp_byte /rbp_nib. qed.

(* -------------------------------------------------------------------- *)
(* the XOF on fresh randomness: a block of 64 uniform bytes is drawn    *)
(* whenever the position enters a new block                             *)
module XOFS_F : XOF_RejBPoly = {
  var pos : int
  var buf : W8.t list

  proc init(rho : Bytes66.t) : unit = {
    pos <- 0;
  }

  proc next() : W8.t = {
    var b;
    if (pos %% 64 = 0) {
      buf <$ dlist W8.dword 64;
    }
    b <- nth witness buf (pos %% 64);
    pos <- pos + 1;
    return b;
  }
}.

(* the bytes of the current block that are still to be read *)
op rest (pos : int) (buf : W8.t list) = if pos %% 64 = 0 then [] else drop (pos %% 64) buf.

lemma rest_next pos (buf : W8.t list) : size buf = 64 =>
  nth witness buf (pos %% 64) :: rest (pos + 1) buf = drop (pos %% 64) buf.
proof.
move=> hsz; rewrite (drop_nth witness) 1:/# /rest.
case: ((pos + 1) %% 64 = 0) => h.
- have -> : pos %% 64 = 63 by move: h; rewrite -modzDml; smt(modz_ge0 ltz_pmod).
  by rewrite drop_oversize 1:/#.
by move: h; rewrite -modzDml; smt(modz_ge0 ltz_pmod).
qed.

lemma foldl_rest st pos (buf : W8.t list) : size buf = 64 =>
  foldl rbp_byte (rbp_byte st (nth witness buf (pos %% 64))) (rest (pos + 1) buf)
  = foldl rbp_byte st (drop (pos %% 64) buf).
proof. by move=> hsz; rewrite -rest_next. qed.

op rbp_inv (j pos : int) (buf : W8.t list) =
  0 <= j <= 256 /\ (pos %% 64 <> 0 => size buf = 64).

(* over the fresh XOF, a martingale potential, applied to the state     *)
(* reached once the bytes left in the current block are processed,      *)
(* bounds the expectation of its value on the result                    *)
lemma RejBoundedPoly_fresh_e (F : rbp_state -> xreal) : nib_mart F =>
  ehoare [RejBoundedPoly(XOFS_F).sample : F (0, witness) ==> F (256, res)].
proof.
move=> hF; proc.
while (rbp_inv j XOFS_F.pos XOFS_F.buf `|`
       F (foldl rbp_byte (j, a) (rest XOFS_F.pos XOFS_F.buf))).
- move=> &hr; case: (j{hr} < 256) => hj; 1: by rewrite /(`|`) xlexoo.
  apply xle_cxr_r => _; apply xle_cxr_r => -[hj' _].
  by rewrite (_ : j{hr} = 256) 1:/# foldl_rbp_done.
- (* reading the byte: a fresh block keeps the potential by block_mart *)
  seq 1 : ((0 <= j < 256 /\ (XOFS_F.pos %% 64 <> 0 => size XOFS_F.buf = 64)) `|`
           F (foldl rbp_byte (rbp_byte (j, a) z) (rest XOFS_F.pos XOFS_F.buf))).
  + inline XOFS_F.next; wp; skip => &hr.
    apply xle_cxr_r => hj; apply xle_cxr_r => -[hj0 hsz].
    case: (XOFS_F.pos{hr} %% 64 = 0) => hp /=.
    * rewrite {2}/rest hp /= -(block_mart F hF 64 (j{hr}, a{hr})) //.
      apply le_Ep => l; rewrite supp_dlist // => -[hl _]; apply xle_cxr_l; 1: smt().
      by have := foldl_rest (j{hr}, a{hr}) XOFS_F.pos{hr} l hl; rewrite hp drop0 /= => ->.
    apply xle_cxr_l; 1: smt().
    by rewrite foldl_rest 1:hsz // /rest hp.
  (* processing the byte: the two half-bytes, as in rbp_byte *)
  wp; skip => &hr; apply xle_cxr_r => -[hj hsz] /=.
  have -> : rbp_byte (j{hr}, a{hr}) z{hr}
    = rbp_nib (rbp_nib (j{hr}, a{hr}) (to_uint z{hr} %% 16)) (to_uint z{hr} %/ 16) by done.
  rewrite /rbp_nib /= hj /=.
  case: (CoeffFromHalfByte (to_uint z{hr} %% 16)) => [|c0] /=.
  + case: (CoeffFromHalfByte (to_uint z{hr} %/ 16)) => [|c1] /=.
    * by apply xle_cxr_l => //; rewrite /rbp_inv; smt().
    rewrite hj /= (_ : j{hr} < 256) 1:/# /=.
    by apply xle_cxr_l => //; rewrite /rbp_inv; smt().
  rewrite (_ : 0 <= j{hr} + 1) 1:/# /=.
  case: (CoeffFromHalfByte (to_uint z{hr} %/ 16)) => [|c1] /=;
    by case: (j{hr} + 1 < 256) => h /=; apply xle_cxr_l => //; rewrite /rbp_inv; smt().
inline XOFS_F.init; wp; skip => &hr.
by apply xle_cxr_l; rewrite /rbp_inv /rest.
qed.

lemma mu1_dpoly t : mu1 (dpoly (-Eta) Eta) t = rbp_tail t 0.
proof.
rewrite /dpoly /Array256E.darray -/dcoeff dmap1E /(\o) /pred1.
rewrite (mu_eq_support _ _ (pred1 (Array256.to_list t))).
- move=> l; rewrite supp_dlist // => -[hl _] /=; rewrite /pred1.
  by rewrite eq_iff; split => [<- | ->]; [rewrite of_listK | rewrite to_listK].
rewrite dlist1E // size_to_list /= /rbp_tail.
by rewrite /to_list /mkseq BRM.big_mapT /(\o).
qed.

lemma rbp_pot0 t (a : poly) : rbp_pot t (0, a) = mu1 (dpoly (-Eta) Eta) t.
proof. by rewrite /rbp_pot /agree mu1_dpoly /= /#. qed.

lemma rbp_pot256 t (a : poly) : rbp_pot t (256, a) = b2r (a = t).
proof.
rewrite /rbp_pot /rbp_tail BRM.big_geq //= /agree /=.
by congr; rewrite eq_iff; split => [h | -> //]; apply ext_eq.
qed.

lemma RejBoundedPoly_fresh_le t &m rho :
  Pr[RejBoundedPoly(XOFS_F).sample(rho) @ &m : res = t] <= mu1 (dpoly (-Eta) Eta) t.
proof.
byehoare (: (mu1 (dpoly (-Eta) Eta) t)%xr ==> (res = t)%xr) => //.
conseq (RejBoundedPoly_fresh_e (fun st => (rbp_pot t st)%xr) (pot_mart t)).
- move=> _; apply xle_cxr_l => [r | ]; 1: by rewrite /= rbp_pot256.
  by rewrite rbp_pot0.
by move=> &hr; apply xle_cxr_r => _; rewrite rbp_pot256.
qed.

lemma RejBoundedPoly_fresh_neq t &m rho :
  Pr[RejBoundedPoly(XOFS_F).sample(rho) @ &m : res <> t] <= 1%r - mu1 (dpoly (-Eta) Eta) t.
proof.
byehoare (: (1%r - mu1 (dpoly (-Eta) Eta) t)%xr ==> (res <> t)%xr) => //.
- conseq (RejBoundedPoly_fresh_e (fun st => (1%r - rbp_pot t st)%xr) (copot_mart t)).
  + move=> _; apply xle_cxr_l => [r | ]; 1: by rewrite /= rbp_pot256; case: (r = t).
    by rewrite rbp_pot0.
  by move=> &hr; apply xle_cxr_r => _; rewrite rbp_pot256; case: (res{hr} = t).
by have := le1_mu (dpoly (-Eta) Eta) (pred1 t); smt().
qed.

(* -------------------------------------------------------------------- *)
(* RejBoundedPoly terminates over the fresh XOF: a read inside a block  *)
(* moves forward in it, and the first byte of a fresh block is zero,    *)
(* hence an accepted half-byte, with probability 1/256                  *)
lemma coeff_nib0 : CoeffFromHalfByte 0 <> None.
proof. by rewrite /CoeffFromHalfByte; case: eta_cases => ->. qed.

op rbf_variant (j pos : int) =
  (256 - j) * 65 + (if pos %% 64 = 0 then 0 else 64 - pos %% 64).

lemma RejBoundedPoly_fresh_ll : islossless RejBoundedPoly(XOFS_F).sample.
proof.
have next_ll : islossless XOFS_F.next.
- proc; wp; if => //; auto => />.
  by move=> _ _; apply/dlist_ll/W8.dword_ll.
proc; inline XOFS_F.init; sp.
conseq (_ : 0 <= j <= 256 ==> _) => //.
while (0 <= j <= 256) (rbf_variant j XOFS_F.pos) (256 * 65 + 64) (1%r / 256%r).
- by [].
- by [].
- by move=> _ pos j0 hj; rewrite /rbf_variant; smt(modz_ge0 ltz_pmod).
- move=> hw; seq 5 : (0 <= j <= 256).
  + by wp; call (: true); auto.
  + by wp; call next_ll; auto => /> /#.
  + by apply hw.
  + by hoare; wp; call (: true); auto => /> /#.
  by [].
- by wp; call next_ll; auto => /> /#.
split; 1: smt().
move=> v; inline XOFS_F.next; case (XOFS_F.pos %% 64 = 0).
- rcondt 1; 1: by auto.
  wp; rnd (fun l => nth witness l 0 = W8.zero); skip => &hr /=.
  move=> [[hj [hj' <-]] hp]; split.
  + rewrite (mu_dlist_head W8.dword 64 witness (pred1 W8.zero) W8.dword_ll) //.
    by rewrite DW8.mu1_dword.
  move=> _ l _ h0; rewrite hp h0 /= coeff_nib0 /= /rbf_variant hp /=.
  by rewrite -modzDml hp /=; smt().
conseq (_ : _ ==> _ : = 1%r) => //; 1: by move=> &hr; smt().
rcondf 1; 1: by auto.
wp; skip => &hr [[hj [hj' <-]] hp] /=; rewrite /rbf_variant hp /=.
have : (if (XOFS_F.pos{hr} + 1) %% 64 = 0 then 0 else 64 - (XOFS_F.pos{hr} + 1) %% 64)
         < 64 - XOFS_F.pos{hr} %% 64.
- by rewrite -modzDml; smt(modz_ge0 ltz_pmod).
by move: (if _ then _ else _) => d hd; smt().
qed.

lemma RejBoundedPoly_fresh_pr t &m rho :
  Pr[RejBoundedPoly(XOFS_F).sample(rho) @ &m : res = t] = mu1 (dpoly (-Eta) Eta) t.
proof.
have hll : Pr[RejBoundedPoly(XOFS_F).sample(rho) @ &m : true] = 1%r.
- by byphoare RejBoundedPoly_fresh_ll.
move: hll; rewrite Pr [mu_split (res = t)] /=.
have := RejBoundedPoly_fresh_le t &m rho.
by have := RejBoundedPoly_fresh_neq t &m rho; smt().
qed.

(* -------------------------------------------------------------------- *)
(* over the fresh XOF, RejBoundedPoly samples dpoly (-Eta) Eta          *)
module SampleBP = {
  proc sample() : poly = {
    var a;
    a <$ dpoly (-Eta) Eta;
    return a;
  }
}.

equiv RejBoundedPoly_fresh : RejBoundedPoly(XOFS_F).sample ~ SampleBP.sample : true ==> ={res}.
proof.
bypr (res{1}) (res{2}) => // &1 &2 a; rewrite RejBoundedPoly_fresh_pr.
by byphoare => //; proc; rnd; auto.
qed.

(* -------------------------------------------------------------------- *)
(* over the fresh XOF, ExpandS samples s1 and s2 coefficient-wise       *)
require import VecMat.
import PolyLVec PolyKVec.

clone DList.Program as PS with
  type t <- poly,
  op   d <- dpoly (-Eta) Eta.

module SampleS = {
  proc l() : polylvec = {
    var s;
    s <$ dpolyl (dpoly (-Eta) Eta);
    return s;
  }

  proc k() : polykvec = {
    var s;
    s <$ dpolyk (dpoly (-Eta) Eta);
    return s;
  }

  proc sample() : polylvec * polykvec = {
    var s1, s2;
    s1 <@ l();
    s2 <@ k();
    return (s1, s2);
  }
}.

(* ExpandS with each polynomial sampled directly *)
module ExpandS_D = {
  proc l() : polylvec = {
    var r, si;
    var s : polylvec;
    s <- witness;
    r <- 0;
    while (r < lvec) {
      si <@ SampleBP.sample();
      s <- s.[r <- si];
      r <- r + 1;
    }
    return s;
  }

  proc k() : polykvec = {
    var r, si;
    var s : polykvec;
    s <- witness;
    r <- 0;
    while (r < kvec) {
      si <@ SampleBP.sample();
      s <- s.[r <- si];
      r <- r + 1;
    }
    return s;
  }

  proc sample() : polylvec * polykvec = {
    var s1, s2;
    s1 <@ l();
    s2 <@ k();
    return (s1, s2);
  }
}.

equiv ExpandS_fresh_D : ExpandS(XOFS_F).sample ~ ExpandS_D.sample : true ==> ={res}.
proof.
proc; inline ExpandS_D.l ExpandS_D.k; wp.
while (r{1} = r0{2} /\ s2{1} = s0{2}); 1: by wp; call RejBoundedPoly_fresh; auto.
wp; while (r{1} = r{2} /\ s1{1} = s{2}); 1: by wp; call RejBoundedPoly_fresh; auto.
by auto.
qed.

equiv l_snoc : ExpandS_D.l ~ PS.LoopSnoc.sample :
  n{2} = lvec ==> res{1} = LArray.of_list witness res{2}.
proof.
proc; inline SampleBP.sample; wp.
while (r{1} = i{2} /\ n{2} = lvec /\ size l{2} = r{1} /\ 0 <= r{1} <= lvec /\
       forall k, 0 <= k < r{1} => s{1}.[k] = nth witness l{2} k).
- auto => /> &1 &2 h0 h1 hk hl x _; rewrite size_cat /=; split; 1: smt().
  by move=> k hk0 hk1; rewrite LArray.get_setE 1:/# nth_cat; smt().
auto => />; split; 1: smt(gt0_l).
move=> s l h1 h2 h3 h4 hk; apply LArray.ext_eq => k hk'.
by rewrite LArray.get_of_list //; smt().
qed.

equiv k_snoc : ExpandS_D.k ~ PS.LoopSnoc.sample :
  n{2} = kvec ==> res{1} = KArray.of_list witness res{2}.
proof.
proc; inline SampleBP.sample; wp.
while (r{1} = i{2} /\ n{2} = kvec /\ size l{2} = r{1} /\ 0 <= r{1} <= kvec /\
       forall k, 0 <= k < r{1} => s{1}.[k] = nth witness l{2} k).
- auto => /> &1 &2 h0 h1 hk hl x _; rewrite size_cat /=; split; 1: smt().
  by move=> k hk0 hk1; rewrite KArray.get_setE 1:/# nth_cat; smt().
auto => />; split; 1: smt(gt0_k).
move=> s l h1 h2 h3 h4 hk; apply KArray.ext_eq => k hk'.
by rewrite KArray.get_of_list //; smt().
qed.

equiv l_dist : ExpandS_D.l ~ SampleS.l : true ==> ={res}.
proof.
bypr (res{1}) (res{2}) => // &1 &2 a.
have -> : Pr[ExpandS_D.l() @ &1 : res = a]
          = Pr[PS.Sample.sample(lvec) @ &1 : LArray.of_list witness res = a].
- byequiv (_ : n{2} = lvec ==> res{1} = LArray.of_list witness res{2}) => //.
  transitivity PS.LoopSnoc.sample
    (n{2} = lvec ==> res{1} = LArray.of_list witness res{2}) (={n} ==> ={res}) => //.
  + by move=> _ &m ->; exists lvec.
  + by apply l_snoc.
  by symmetry; conseq PS.Sample_LoopSnoc_eq.
have -> : Pr[PS.Sample.sample(lvec) @ &1 : LArray.of_list witness res = a]
          = mu (dlist (dpoly (-Eta) Eta) lvec) (fun l => LArray.of_list witness l = a).
- by byphoare (: n = lvec ==> LArray.of_list witness res = a) => //; proc; rnd; auto.
have -> : Pr[SampleS.l() @ &2 : res = a] = mu1 (dpolyl (dpoly (-Eta) Eta)) a.
- by byphoare => //; proc; rnd; auto.
by rewrite /dpolyl dmap1E /pred1 /(\o).
qed.

equiv k_dist : ExpandS_D.k ~ SampleS.k : true ==> ={res}.
proof.
bypr (res{1}) (res{2}) => // &1 &2 a.
have -> : Pr[ExpandS_D.k() @ &1 : res = a]
          = Pr[PS.Sample.sample(kvec) @ &1 : KArray.of_list witness res = a].
- byequiv (_ : n{2} = kvec ==> res{1} = KArray.of_list witness res{2}) => //.
  transitivity PS.LoopSnoc.sample
    (n{2} = kvec ==> res{1} = KArray.of_list witness res{2}) (={n} ==> ={res}) => //.
  + by move=> _ &m ->; exists kvec.
  + by apply k_snoc.
  by symmetry; conseq PS.Sample_LoopSnoc_eq.
have -> : Pr[PS.Sample.sample(kvec) @ &1 : KArray.of_list witness res = a]
          = mu (dlist (dpoly (-Eta) Eta) kvec) (fun l => KArray.of_list witness l = a).
- by byphoare (: n = kvec ==> KArray.of_list witness res = a) => //; proc; rnd; auto.
have -> : Pr[SampleS.k() @ &2 : res = a] = mu1 (dpolyk (dpoly (-Eta) Eta)) a.
- by byphoare => //; proc; rnd; auto.
by rewrite /dpolyk dmap1E /pred1 /(\o).
qed.

equiv ExpandS_fresh : ExpandS(XOFS_F).sample ~ SampleS.sample : true ==> ={res}.
proof.
transitivity ExpandS_D.sample (true ==> ={res}) (true ==> ={res}) => //.
- exact ExpandS_fresh_D.
by proc; call k_dist; call l_dist.
qed.

(* -------------------------------------------------------------------- *)
(* the seeds of the polynomials of s1 and s2 are pairwise distinct      *)
op sseed (rho : Bytes64.t) (r : int) : Bytes66.t =
  Bytes66.of_list (Bytes64.to_list rho ++ IntegerToBytes r 2).

lemma sseed_inj rho r1 r2 : 0 <= r1 < 65536 => 0 <= r2 < 65536 =>
  Bytes66.to_list (sseed rho r1) = Bytes66.to_list (sseed rho r2) => r1 = r2.
proof.
move=> h1 h2; rewrite /sseed !Bytes66.of_listK.
- by rewrite size_cat Bytes64.size_to_list size_IntegerToBytes.
- by rewrite size_cat Bytes64.size_to_list size_IntegerToBytes.
rewrite eqseq_cat // => -[_ h].
by rewrite -(IntegerToBytesK r1 2) // h IntegerToBytesK.
qed.
