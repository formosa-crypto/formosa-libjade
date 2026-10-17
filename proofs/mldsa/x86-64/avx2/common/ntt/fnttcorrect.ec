(**
  This theory connects the extracted implementation code to the
  machine-level specification of the NTT.
*)
require import AllCore CoreUtils List Ring IntDiv BitEncoding.
require import StdRing StdOrder.
from Jasmin require import JWord JArray.
require import JArrayExtra.
require import CircuitBindings.
from Jasmin require import JModel_x86.
require import MldsaConstants.
require Parameters MldsaT.
require import WArray1024.
require import Array4 Array8 Array16 Array256.
require import XArray256.
require import Nttzetas Nttspec Nttlogspec.
require import Avx2red Listred.

abstract theory FnttcorrectT.

clone import Parameters.ParamsT as P.
clone import MldsaT.MldsaT as R with theory P <- P.
clone import Avx2red.Avx2redT as AR with theory P <- P, theory R <- R.

(* -------------------------------------------------------------------- *)

import BitChunking.

(* -------------------------------------------------------------------- *)
type wpoly = W32.t Array256.t.

(* -------------------------------------------------------------------- *)
lemma NTT_layer0_bf (p : wpoly) (start : int) (z : W256.t) :
     0 <= start < 32
  => 2 %| start
  => hoare[M.polynomial__butterfly_2 :
         arg = (p, W64.of_int start, z)
       ==>
         res = reduce_n p (8 * start) 1 (List.map ((\bits32) z) perm0L)
     ].
proof.
hint +listred.
move=> *; proc.
cfold ^lhs_start<-; kill ^lhs_start<-; first by auto.
cfold ^rhs_start<-; kill ^rhs_start<-; first by auto.

pose uw (i : int) := p.[8 * start + i].
pose vw (i : int) := p.[8 * start + 8 + i].
pose zw (i : int) := z \bits32 i.

swap ^rhs<- -1; seq 2 : (#pre /\
     lhs = W8u32.pack8 (mkseq uw 8)
  /\ rhs = W8u32.pack8 (mkseq vw 8)).
- hoare split; auto=> &hr |> /=.
  by rewrite !pmod_small ~-1:/# !wpoly_get256_alignedE //#.

proc change 5 : {
  zeta_products <-
    W8u32.pack8_t (W8u32.Pack.map2 mmr
      (W8u32.unpack32 zeta_products)
      (W8u32.unpack32 zetas)
    );
}.
- by ecall {1} (mmrP_ll zeta_products{1} zetas{1}); auto.

pose bf (w : int -> W32.t) (i : int) (t : int) :=
  [w i + mmr (w (i + 1)) (zw t); w i - mmr (w (i + 1)) (zw t)].
move=> /= ; seq 11 : (#{/~{lhs,rhs}}pre /\
  (  lhs = pack8 (flatten [bf uw 0 0; bf uw 2 1; bf uw 4 4; bf uw 6 5])
  /\ rhs = pack8 (flatten [bf vw 0 2; bf vw 2 3; bf vw 4 6; bf vw 6 7]))).
- by hoare split; [auto=> &hr ||> | auto=> &hr ||> ->].

seq 2: (#{/~{polynomial}}pre /\ polynomial =
  let p = replace_ p (8 * start    ) (to_list lhs) in
  let p = replace_ p (8 * start + 8) (to_list rhs) in
  p
).
- hoare split; [wp; skip=> &hr [#] <<- ->> 3?| by auto].
  rewrite (replace_mkseq ((\bits32) lhs{hr}) _ _ 8) /=.
  rewrite (replace_mkseq ((\bits32) rhs{hr}) _ _ 8) /=.
  rewrite !(of_uintK, pmod_small) ~-1:/#.
  rewrite !wpoly_set256_alignedE ~-1:/#.
  by rewrite &(fill_congr) ~-1:/# &(fill_congr) ~-1:/#.

skip=> &hr [#] _ _ lE rE;
  pose l := W8u32.to_list lhs{hr};
  pose r := W8u32.to_list rhs{hr};
  move=> /=.
rewrite -replace_cat reduce_nE 1:/# => -> /=; congr.
rewrite /perm0L /= /reduce_coeff /=.
by rewrite /l lE /r rE /= !catA /bf /=.
qed.

(* -------------------------------------------------------------------- *)
lemma polynomial__ntt_at_layer_0P (p_ : wpoly) :
  hoare[M.polynomial__ntt_at_layer_0 :
    polynomial = p_ ==> res = reduce_level p_ 0].
proof.
hint +listred.
proc; sp; while (
     0 <= i <= 16
  /\ polynomial = reduce_n p_ 0 1 (take (8 * i) (map W32.of_int (zetaL 0)))
); last first.
- auto=> &hr |>; rewrite take0 /= reduce_0 /=.
  move=> j *; have ->> /=: j = 16 by smt().
  by rewrite reduce_levelE // take_oversize.

proc rewrite 2 LAYER_0_ZETASE.
wp; do 2! (cfold 1; kill -1; first by auto).
exlim i, polynomial => i_ polynomial_.
case@[ambient]: (0 <= i_ < 16) => [rgi|]; last first.
  (* FIXME: SHOULD BE A TACTIC *)
- by move=> h; conseq (_ : false ==> _); [smt() | by exfalso].

pose z := map (nth witness (take 8 (drop (8 * i_) (zetaL 0)))) perm0L.

call (NTT_layer0_bf polynomial_ (i_ * 2) (pack8 (map W32.of_int z))); ~-1: smt().

skip=> &hr |> * /=; do! (split=> *).
- rewrite /LAYER_0_ZETAS zeta_L0_AVX2 /= initE ifT //=.
  rewrite !(nth_map witness) /= ?(size_chunk, size_iota) //=.
  by rewrite nth_iota //= -/s sE /= -map_comp /=.
- smt().
- smt().
- rewrite mulrDr /= takeD ~-1://# reduce_n_cat /=; congr.
  - by rewrite -map_take /= size_take_condle ~-1:/# /= ifT /#.
  - rewrite /perm0L /= /z /= /perm0L /=; apply/eq_sym.
    rewrite -!(map_take, map_drop) -[List.map _ _](mkseq_nth witness) /=.
    rewrite size_take_condle // size_drop 1:/# ifT 1:/#.
    pose s := take 8 (drop _ _).
    rewrite -(eq_in_mkseq (fun i => W32.of_int (nth witness s i))) /= -1://.
    move=> i ?; rewrite (nth_map witness) //.
    by rewrite /s size_take_condle //  size_drop 1:/# ifT //#.
qed.

(* -------------------------------------------------------------------- *)
lemma NTT_layer1_bf (p : wpoly) (start : int) (z1 z2 z3 z4 : W32.t) :
     0 <= start < 32
  => 2 %| start
  => hoare[M.polynomial__butterfly_4:
         arg = (p, W64.of_int start, pack4 (map (pack2 \o nseq 2) [z1; z2; z3; z4]))
       ==>
         res = reduce_n p (8 * start) 2 [z1; z3; z2; z4]
     ].
proof.
hint +listred.
move=> *; proc.

have ?: start < 31 by smt().

cfold ^lhs_start<-; kill ^lhs_start<-; first by auto.
cfold ^rhs_start<-; kill ^rhs_start<-; first by auto.

pose uw (i : int) := p.[8 * start + i].
pose vw (i : int) := p.[8 * start + 8 + i].

swap ^rhs<- -1; seq 2 : (#pre /\
     lhs = W8u32.pack8 (mkseq uw 8)
  /\ rhs = W8u32.pack8 (mkseq vw 8)).
- hoare split; auto=> &hr |> /=.
  by rewrite !pmod_small ~-1:/# !wpoly_get256_alignedE //#.

swap ^rhs<- -1; proc change 3 : {
  zeta_products <-
    W8u32.pack8_t (W8u32.Pack.map2 mmr
      (W8u32.unpack32 zeta_products)
      (W8u32.unpack32 zetas)
    );
}.
- by ecall {1} (mmrP_ll zeta_products{1} zetas{1}); auto.

pose bfD (w : int -> W32.t) (z : W32.t) (d i : int) := w (d + i) + mmr (w (d + i + 2)) z.
pose bfB (w : int -> W32.t) (z : W32.t) (d i : int) := w (d + i) - mmr (w (d + i + 2)) z.

pose lhs_ := pack8 (
  mkseq (bfD uw z1 0) 2 ++ mkseq (bfB uw z1 0) 2 ++
  mkseq (bfD uw z3 4) 2 ++ mkseq (bfB uw z3 4) 2
).
pose rhs_ := pack8 (
  mkseq (bfD vw z2 0) 2 ++ mkseq (bfB vw z2 0) 2 ++
  mkseq (bfD vw z4 4) 2 ++ mkseq (bfB vw z4 4) 2
).

seq ^polynomial<-: (#{/~{lhs,rhs}}pre /\ (lhs = lhs_ /\ rhs = rhs_)).
- by hoare split; auto.

seq 2: (#{/~{polynomial}}pre /\ polynomial =
  let p = replace_ p (8 * start    ) (to_list lhs) in
  let p = replace_ p (8 * start + 8) (to_list rhs) in
  p
).
- hoare split; [wp; skip=> &hr [#] <<- ->> 3?| by auto].
  rewrite (replace_mkseq ((\bits32) lhs{hr}) _ _ 8) /=.
  rewrite (replace_mkseq ((\bits32) rhs{hr}) _ _ 8) /=.
  rewrite !(of_uintK, pmod_small) ~-1:/#.
  rewrite !wpoly_set256_alignedE ~-1:/#.
  by rewrite &(fill_congr) ~-1:/# &(fill_congr) ~-1:/#.

skip=> &hr [#] lE rE;
  pose l := W8u32.to_list lhs{hr};
  pose r := W8u32.to_list rhs{hr};
  move=> /=.

rewrite -replace_cat reduce_nE 1:/# => -> /=; congr.
rewrite /reduce_coeff_flatten /= /reduce_coeff /=.
by rewrite /l lE /r rE.
qed.

(* -------------------------------------------------------------------- *)
lemma polynomial__ntt_at_layer_1P (p_ : wpoly) :
  hoare[M.polynomial__ntt_at_layer_1 :
    polynomial = p_ ==> res = reduce_level p_ 1].
proof.
hint +listred.
proc; sp; while (
     0 <= i <= 16
  /\ polynomial = reduce_n p_ 0 2 (take (4 * i) (map W32.of_int (zetaL 1)))
); last first.
- auto=> &hr |>; rewrite take0 /= reduce_0 /=.
  move=> j *; have ->> /=: j = 16 by smt().
  by rewrite reduce_levelE // take_oversize.

proc rewrite 2 LAYER_1_ZETASE.
wp; do 2! (cfold 1; kill -1; first by auto).
exlim i, polynomial => i_ polynomial_.
case@[ambient]: (0 <= i_ < 16) => [rgi|]; last first.
  (* FIXME: SHOULD BE A TACTIC *)
- by move=> h; conseq (_ : false ==> _); [smt() | by exfalso].
pose z1 := W32.of_int (nth witness (zetaL 1) (4 * i_    )).
pose z2 := W32.of_int (nth witness (zetaL 1) (4 * i_ + 1)).
pose z3 := W32.of_int (nth witness (zetaL 1) (4 * i_ + 2)).
pose z4 := W32.of_int (nth witness (zetaL 1) (4 * i_ + 3)).

call (NTT_layer1_bf polynomial_ (i_ * 2) z1 z3 z2 z4); ~-1: smt().

skip=> &hr |> * /=.
pose s := take 4 (drop (4 * i{hr}) (zetaL 1)).
have szs: size s = 4 by rewrite /s size_take_condle // ifT // size_drop /#.
have sE: s = mkseq (fun j => nth witness (zetaL 1) (4 * i{hr} + j)) 4.
- apply/(eq_from_nth witness); first by rewrite size_mkseq.
  move=> j; rewrite szs => [# *]; rewrite nth_mkseq //=.
  by rewrite /s nth_take // nth_drop ~-1://#.
do! (split=> *).
- rewrite /LAYER_1_ZETAS zeta_L1_AVX2 initE ifT //=.
  rewrite !(nth_map witness) /= ?(size_chunk, size_iota) //=.
  rewrite nth_iota //= -/s sE /= -map_comp /=.
  by rewrite /perm1L.
- smt().
- smt().
- rewrite mulrDr /= takeD ~-1://# reduce_n_cat /=; congr.
  - by rewrite -map_take /= size_take_condle ~-1:/# /= ifT /#.
  - by rewrite -!(map_drop, map_take) -/s sE.
qed.

(* -------------------------------------------------------------------- *)
lemma NTT_layer2_bf (p : wpoly) (start : int) (z1 z2 : W32.t) :
     0 <= start < 32
  => 2 %| start
  => hoare[M.polynomial__butterfly_8:
         arg = (p, W64.of_int start, pack2 [pack4 (nseq 4 z1); pack4 (nseq 4 z2)])
       ==>
         res = reduce_n p (8 * start) 4 [z1; z2]
     ].
proof.
hint +listred.
move=> *; proc.
cfold ^lhs_start<-; kill ^lhs_start<-; first by auto.
cfold ^rhs_start<-; kill ^rhs_start<-; first by auto.

pose uw (i : int) := p.[8 * start + i].
pose vw (i : int) := p.[8 * start + 8 + i].

swap ^lhs_truncated<- 1; seq 2 : (#pre /\
     lhs = W8u32.pack8 (mkseq uw 8)
  /\ rhs = W8u32.pack8 (mkseq vw 8)).
- hoare split; auto=> &hr |> /=.
  by rewrite !pmod_small ~-1:/# !wpoly_get256_alignedE //#.

swap ^rhs<- -1; proc change 7 : {
  zeta_products <-
    W8u32.pack8_t (W8u32.Pack.map2 mmr
      (W8u32.unpack32 zeta_products)
      (W8u32.unpack32 zetas)
    );
}.
- by ecall {1} (mmrP_ll zeta_products{1} zetas{1}); auto.

pose bfD (w : int -> W32.t) (z : W32.t) (i : int) := w i + mmr (w (i + 4)) z.
pose bfB (w : int -> W32.t) (z : W32.t) (i : int) := w i - mmr (w (i + 4)) z.

pose lhs_ := pack8 (mkseq (bfD uw z1) 4 ++ mkseq (bfB uw z1) 4).
pose rhs_ := pack8 (mkseq (bfD vw z2) 4 ++ mkseq (bfB vw z2) 4).

seq ^polynomial<-: (#{/~{lhs,rhs}}pre /\
  (  lhs = lhs_
  /\ rhs = rhs_)).
- by hoare split; auto.

seq 2: (#{/~{polynomial}}pre /\ polynomial =
  let p = replace_ p (8 * start    ) (to_list lhs) in
  let p = replace_ p (8 * start + 8) (to_list rhs) in
  p
).
- hoare split; [wp; skip=> &hr [#] <<- ->> 3?| by auto].
  rewrite (replace_mkseq ((\bits32) lhs{hr}) _ _ 8) /=.
  rewrite (replace_mkseq ((\bits32) rhs{hr}) _ _ 8) /=.
  rewrite !(of_uintK, pmod_small) ~-1:/#.
  rewrite !wpoly_set256_alignedE ~-1:/#.
  by rewrite &(fill_congr) ~-1:/# &(fill_congr) ~-1:/#.

skip=> &hr [#] lE rE;
  pose l := W8u32.to_list lhs{hr};
  pose r := W8u32.to_list rhs{hr};
  move=> /=.
rewrite -replace_cat reduce_nE 1:/# => -> /=; congr.
rewrite /reduce_coeff_flatten /= /reduce_coeff /=.
by rewrite /l lE /r rE.
qed.

(* -------------------------------------------------------------------- *)
lemma polynomial__ntt_at_layer_2P (p_ : wpoly) :
  hoare[M.polynomial__ntt_at_layer_2 :
    polynomial = p_ ==> res = reduce_level p_ 2].
proof.
hint +listred.
proc; sp; while (
     0 <= i <= 16
  /\ polynomial = reduce_n p_ 0 4 (take (2 * i) (map W32.of_int (zetaL 2)))
); last first.
- auto=> &hr |>; rewrite take0 /= reduce_0 /=.
  move=> j *; have ->> /=: j = 16 by smt().
  by rewrite reduce_levelE // take_oversize.

proc rewrite 2 LAYER_2_ZETASE.
wp; do 2! (cfold 1; kill -1; first by auto).
exlim i, polynomial => i_ polynomial_.
case@[ambient]: (0 <= i_ < 16) => [rgi|]; last first.
  (* FIXME: SHOULD BE A TACTIC *)
- by move=> h; conseq (_ : false ==> _); [smt() | by exfalso].
pose z1 := W32.of_int (nth witness (zetaL 2) (2 * i_    )).
pose z2 := W32.of_int (nth witness (zetaL 2) (2 * i_ + 1)).
call (NTT_layer2_bf polynomial_ (i_ * 2) z1 z2); ~-1: smt().

skip=> &hr |> *.
pose s := take 2 (drop (2 * i{hr}) (zetaL 2)).
have szs: size s = 2 by rewrite /s size_take_condle // ifT // size_drop /#.
have sE: s = mkseq (fun j => nth witness (zetaL 2) (2 * i{hr} + j)) 2.
- apply/(eq_from_nth witness); first by rewrite size_mkseq.
  move=> j; rewrite szs => [# *]; rewrite nth_mkseq //=.
  by rewrite /s nth_take // nth_drop ~-1://#.
do! (split=> *).
- rewrite /LAYER_2_ZETAS zeta_L2_AVX2 initE ifT /= //.
  rewrite !(nth_map witness) /= ?(size_chunk, size_iota) //=.
  by rewrite nth_iota //= -/s sE /= /topair.
- smt().
- smt().
- rewrite mulrDr /= takeD ~-1://# reduce_n_cat /=; congr.
  - by rewrite -map_take /= size_take_condle ~-1:/# /= ifT /#.
  - by rewrite -!(map_drop, map_take) -/s sE.
qed.

(* -------------------------------------------------------------------- *)
lemma ntt_roundP (p_ : wpoly) (stpby base : int) (z : W32.t) :
     0 <= base
  => 1 <= stpby < 6
  => (base + 1) * (16 * stpby) <= 256
  => hoare[M.polynomial__ntt_round :
         arg = (
           p_,
           8 * stpby,
           stpby,
           base,
           pack8 (nseq 8 z)
         )
       ==>
         res = reduce p_ (16 * stpby * base) (8 * stpby) z
     ].
proof.
hint +listred.
move=> ge0b rgstpby hlt; proc.
pose offset_ := 2 * stpby * base.
pose bound_  := offset_ + stpby.

seq ^offset<-{-1} & +1 : (#pre /\ offset = offset_).
- hoare split; auto=> &hr |> @/offset_.
  by rewrite /(`|>>`) /(`<<`) /= /#. (* FIXME *)
swap ^i<- @^while; seq ^bound<-{-1} & +1 : (#pre /\ bound = bound_).
- by auto.

sp; while (
     offset_ <= i
  /\ i <= bound_
  /\ zetas = pack8 (nseq 8 z)
  /\ bound = bound_
  /\ step_by = stpby
  /\ polynomial = reduce_partial p_ (16 * stpby * base) (8 * stpby) (8 * (i - offset_)) z
); last first.
- skip=> &hr |>; split*.
  - smt().
  - move=> j *; have ->: (j - offset_) = step_by{hr} by smt().
    by rewrite reduce_as_partial //#.

swap ^coeffs_i<- @^coeffs_i_plus_step<-.
seq ^index_plus_step<-{-1} & +1 : (#pre /\ (
     index = 32 * i
  /\ index_plus_step = 32 * (i + stpby)
)).
- by hoare split; auto=> &hr |> *; smt().

exlim i => i_.
pose uw (j : int) := p_.[8 * (i_        ) + j].
pose vw (j : int) := p_.[8 * (i_ + stpby) + j].

case@[ambient]: (
     (offset_ <= i_)
  /\ (i_ < bound_)
) => [[#] lei gti|]; last first.
- by move=> ?; conseq (_ : false ==> _); [move=> &hr |> /# | exfalso].

have ?: 0 <= 8 * (i_        ) < 256 - 7 by smt().
have ?: 0 <= 8 * (i_ + stpby) < 256 - 7 by smt().

seq 2 : (#pre /\
     coeffs_i = W8u32.pack8 (mkseq uw 8)
  /\ coeffs_i_plus_step = W8u32.pack8 (mkseq vw 8)).
- hoare split; auto=> &hr |> /= *; split.
  - rewrite wpoly_get256_alignedE ~-1:/# -(eq_in_mkseq uw) -1://.
    by move=> j rgj /=; rewrite eqexcept_reduce_partial //#.
  - rewrite wpoly_get256_alignedE ~-1:/# -(eq_in_mkseq vw) -1://.
    by move=> j rgj /=; rewrite eqexcept_reduce_partial //#.

swap ^coeffs_i<-{-1} @^polynomial<-.

seq 1: (#pre /\ (product = W8u32.pack8_t
  (W8u32.Pack.map2 mmr (W8u32.unpack32 coeffs_i_plus_step) (W8u32.unpack32 zetas)))).
- by ecall (mmrP coeffs_i_plus_step (pack8 (nseq 8 z))); auto=> &hr |> /=.

seq 2: (#{/~{coeffs_i,coeffs_i_plus_step}}pre /\
     coeffs_i = pack8 (mkseq (fun i => uw i + mmr (vw i) z) 8)
  /\ coeffs_i_plus_step = pack8 (mkseq (fun i => uw i - mmr (vw i) z) 8)
).
- by auto.

exlim polynomial => q.

seq 1: (
     (  #{/~{polynomial}}pre
     /\ q = reduce_partial p_ (16 * stpby * base) (8 * stpby) (8 * (i - offset_)) z)
  /\ polynomial = replace_ q (8 * (i + stpby)) (to_list coeffs_i_plus_step)
).
- hoare split; [wp; skip=> &hr [#] -> <- 8? idxE ? hE | by auto].
  have ->: W8u32.to_list coeffs_i_plus_step{hr} =
    mkseq (fun i => coeffs_i_plus_step{hr} \bits32 i) 8 by done.
  rewrite idxE (_ : 32 * _ = 4 * (8 * (i_ + stpby))) 1:#ring.
  by rewrite wpoly_set256_aligned -1:replace_mkseq.

seq 1: (#{/~{polynomial}}pre /\ polynomial =
  let q = replace_ q (8 * (i + stpby)) (to_list coeffs_i_plus_step) in
  let q = replace_ q (8 * (i        )) (to_list coeffs_i          ) in
  q
).
- hoare split; [wp; skip=> &hr [#] <- 6? idxE ? hE 2? -> | by auto].
  have ->: W8u32.to_list coeffs_i{hr} =
    mkseq (fun i => coeffs_i{hr} \bits32 i) 8 by done.
  move: (replace_ q _ _) => q0; (pose s := mkseq _ _) => /=.
  rewrite /s replace_mkseq idxE.
  rewrite (_ : 32 * _ = 4 * (8 * i_)) 1:#ring.
  by rewrite wpoly_set256_aligned.

wp; skip=> &hr;
  pose c2  := W8u32.to_list _;
  pose c1  := W8u32.to_list _;
  pose bfD := mkseq _ 8;
  pose bfB := mkseq _ 8;
  move=> |> *; split*; ~-1: smt().

rewrite replace_swap; first by suff: size c1 = 8 by smt().
rewrite [_ + 1 + _]addrAC [8*(_+1)]mulrDr /= reduce_partialD ~-1://#.
(pose r := (reduce_partial p_ _ _ _ _)) => @/reduce_partial /=.
case _: (reduce_coeff _ _ _ _ _) => c'1 c'2 E /=.
suff [#] 2->: c1 = c'1 /\ c2 = c'2.
- by (congr; first congr); rewrite /offset_ #ring.
move: E; rewrite -(reduce_coeff_eqon p_).
- by move=> i * @/r; rewrite eqexcept_reduce_partial //#.
- by move=> i * @/r; rewrite eqexcept_reduce_partial //#.
rewrite mulrBr /offset_ !mulrA /= addrCA /=.
move=> ^ /(congr1 fst) /= <- /(congr1 snd) /= <-; split.
- rewrite reduce_coeffLE /c1 (_ : W8u32.to_list (pack8 _) = bfD) 1://.
  by apply: eq_mkseq => i /= @/uw @/vw; do! congr => //#.
- rewrite reduce_coeffRE /c2 (_ : W8u32.to_list (pack8 _) = bfB) 1://.
  by apply: eq_mkseq => i /= @/uw @/vw; do! congr => //#.
qed.

(* -------------------------------------------------------------------- *)
lemma polynomial__ntt_at_layer_3P (p_ : wpoly) :
  hoare[M.polynomial__ntt_at_layer_3 :
    polynomial = p_ ==> res = reduce_level p_ 3].
proof.
hint +listred.
proc.

proc rewrite 4.2 LAYER_3_ZETASE.
proc change [1..2] : {
  step    <- 8;
  step_by <- 1;
}; first by auto=> |>; circuit.
do 2! (cfold 1; kill -1; first by auto).

sp; while (
     0 <= i <= 16
  /\ polynomial = reduce_n p_ 0 8 (take i (map W32.of_int (zetaL 3)))
); last first.
- auto=> &hr |> *; do! (split=> *).
  - by rewrite take0 reduce_0.
  - by rewrite reduce_levelE // take_oversize //#.

sp; exlim i, zetas => i_ zetas_.
case@[ambient]: (0 <= i_ < 16) => ?; last first.
- by conseq (_ : false ==> _); [smt() | exfalso].
case@[ambient]: (zetas_ = LAYER_3_ZETAS.[i_]) => zE; last first.
- by conseq (_ : false ==> _); [smt() | exfalso].

exlim polynomial => q.
pose z := W32.of_int (nth witness (zetaL 3) i_).
wp; call (ntt_roundP q 1 i_ z); ~-1: move=> //#.

auto=> &hr |> *; do! (split=> *).
- rewrite -LAYER_3_ZETASE zeta_L3_AVX2 get_of_list ~-1://.
  by rewrite (nth_map witness).
- smt().
- smt().
- rewrite (take_nth witness) 1:// reduce_rcons /=; do! congr.
  - by rewrite size_take_condle //= ifT.
  - by rewrite (nth_map witness).
qed.

(* -------------------------------------------------------------------- *)
lemma polynomial__ntt_at_layer_4P (p_ : wpoly) :
  hoare[M.polynomial__ntt_at_layer_4 :
    polynomial = p_ ==> res = reduce_level p_ 4].
proof.
hint +listred.
proc.

proc rewrite 4.2 LAYER_4_ZETASE.
proc change [1..2] : {
  step    <- 16;
  step_by <- 2;
}; first by auto=> |>; circuit.
do 2! (cfold 1; kill -1; first by auto).

sp; while (
     0 <= i <= 8
  /\ polynomial = reduce_n p_ 0 16 (take i (map W32.of_int (zetaL 4)))
); last first.
- auto=> &hr |> *; do! (split=> *).
  - by rewrite take0 reduce_0.
  - by rewrite reduce_levelE // take_oversize //#.

sp; exlim i, zetas => i_ zetas_.
case@[ambient]: (0 <= i_ < 8) => ?; last first.
- by conseq (_ : false ==> _); [smt() | exfalso].
case@[ambient]: (zetas_ = LAYER_4_ZETAS.[i_]) => zE; last first.
- by conseq (_ : false ==> _); [smt() | exfalso].

exlim polynomial => q.
pose z := W32.of_int (nth witness (zetaL 4) i_).
wp; call (ntt_roundP q 2 i_ z); ~-1: move=> //#.

auto=> &hr |> *; do! (split=> *).
- rewrite -LAYER_4_ZETASE zeta_L4_AVX2 get_of_list ~-1://.
  by rewrite (nth_map witness).
- smt().
- smt().
- rewrite (take_nth witness) 1:// reduce_rcons /=; do! congr.
  - by rewrite size_take_condle //= ifT.
  - by rewrite (nth_map witness).
qed.

(* -------------------------------------------------------------------- *)
lemma polynomial__ntt_at_layer_5P (p_ : wpoly) :
  hoare[M.polynomial__ntt_at_layer_5 :
    polynomial = p_ ==> res = reduce_level p_ 5].
proof.
hint +listred.
proc.

proc rewrite 4.2 LAYER_5_ZETASE.
proc change [1..2] : {
  step    <- 32;
  step_by <- 4;
}; first by auto=> |>; circuit.
do 2! (cfold 1; kill -1; first by auto).

sp; while (
     0 <= i <= 4
  /\ polynomial = reduce_n p_ 0 32 (take i (map W32.of_int (zetaL 5)))
); last first.
- auto=> &hr |> *; do! (split=> *).
  - by rewrite take0 reduce_0.
  - by rewrite reduce_levelE // take_oversize //#.

sp; exlim i, zetas => i_ zetas_.
case@[ambient]: (0 <= i_ < 4) => ?; last first.
- by conseq (_ : false ==> _); [smt() | exfalso].
case@[ambient]: (zetas_ = LAYER_5_ZETAS.[i_]) => zE; last first.
- by conseq (_ : false ==> _); [smt() | exfalso].

exlim polynomial => q.
pose z := W32.of_int (nth witness (zetaL 5) i_).
wp; call (ntt_roundP q 4 i_ z); ~-1: move=> //#.

auto=> &hr |> *; do! (split=> *).
- rewrite -LAYER_5_ZETASE zeta_L5_AVX2 get_of_list ~-1://.
  by rewrite (nth_map witness).
- smt().
- smt().
- rewrite (take_nth witness) 1:// reduce_rcons /=; do! congr.
  - by rewrite size_take_condle //= ifT.
  - by rewrite (nth_map witness).
qed.

(* -------------------------------------------------------------------- *)
lemma polynomial__multiply (p_ : wpoly) (base stpby : int) (z : W32.t) :
     0 <= base
  => 1 <= stpby
  => 8 * (base + 8 * stpby) <= 256 - 7
  => hoare[M.polynomial__multiply :
         arg = (
           p_,
           W64.of_int base,
           W64.of_int (8 * stpby),
           z
         )
       ==>
         res = reduce_partial p_ (8 * base) (64 * stpby) 8 z
     ].
proof.
hint +listred.
move=> *; proc => /=.
swap [^index_i<- .. ^index_i<-{-1}] @^index_i_plus_step_by<-.
swap ^coeffs_i<- @^coeffs_i_plus_step_by<-.

seq ^index_i_plus_step_by<-{-1} & +1: (#pre /\
  (  index_i = W64.of_int (32 * base)
  /\ index_i_plus_step_by = W64.of_int (32 * (base + 8 * stpby)))).
- by hoare split; [auto=> &hr |> /# | by auto].

pose uw (i : int) := p_.[8 * base + i].
pose vw (i : int) := p_.[8 * (base + 8 * stpby) + i].

seq ^coeffs_i_plus_step_by<- & +1: (#pre /\
  (  coeffs_i = W8u32.pack8 (mkseq uw 8)
  /\ coeffs_i_plus_step_by = W8u32.pack8 (mkseq vw 8))).
- hoare split; [auto=> &hr |> /= | by auto].
  by rewrite !pmod_small ~-1:/# !wpoly_get256_alignedE /#.

swap ^coeffs_i<- @^polynomial<-.

seq ^polynomial<-: (#{/~{coeffs_i,coeffs_i_plus_step_by}}pre /\
  (  coeffs_i = pack8 (mkseq (fun i => uw i + mmr (vw i) zeta_0{hr}) 8)
  /\ coeffs_i_plus_step_by = pack8 (mkseq (fun i => uw i - mmr (vw i) zeta_0{hr}) 8))
).
- auto=> &hr |> /=.
  rewrite INVERSE_OF_MODULUS_MOD_MONTGOMERY_R_VECTOR_E.
  rewrite /INVERSE_OF_MODULUS_MOD_MONTGOMERY_R_VECTOR.
  rewrite MODULUS_VECTOR_E /MODULUS_VECTOR /=.

  pose qinv := W32.of_int INVERSE_OF_MODULUS_MOD_MONTGOMERY_R.
  pose q    := W32.of_int MODULUS.

  split.
  - pose F := fun k => uw k + (
        ((vw k \sx zeta_0{hr}) \bits32 1)
      - ((vw k \sx zeta_0{hr} \bits32 0 \sx qinv \bits32 0 \sx q) \bits32 1)).
    rewrite (pack8_eq F (fun i => uw i + mmr (vw i) zeta_0{hr})) //.
    move=> i rgi /=; rewrite -mmr_altE /F /mmr_alt /=.
    by move: (uw i) (vw i) => 2?; rewrite -!shr_shrw //; circuit.
  - pose F := fun k => uw k - (
        ((vw k \sx zeta_0{hr}) \bits32 1)
      - ((vw k \sx zeta_0{hr} \bits32 0 \sx qinv \bits32 0 \sx q) \bits32 1)).
    rewrite (pack8_eq F (fun i => uw i - mmr (vw i) zeta_0{hr})) //.
    move=> i rgi /=; rewrite -mmr_altE /F /mmr_alt /=.
    by move: (uw i) (vw i) => 2?; rewrite -!shr_shrw //; circuit.

seq 1: (#{/~{polynomial}}pre /\ polynomial =
  replace_ p_ (8 * (base + 8 * stpby)) (to_list coeffs_i_plus_step_by)
).
- hoare split; [wp; skip=> &hr [#] -> _ _ _ _ -> _ _ | by auto].
  have ->: W8u32.to_list coeffs_i_plus_step_by{hr} =
    mkseq (fun i => coeffs_i_plus_step_by{hr} \bits32 i) 8 by done.
  rewrite of_uintK pmod_small 1:/# (_ : 32 = 4 * 8) 1:#ring -mulrA.
  by rewrite wpoly_set256_aligned 1:/# replace_mkseq.

seq 1: (#{/~{polynomial}}pre /\ polynomial =
  let p_ = replace_ p_ (8 * (base + 8 * stpby)) (to_list coeffs_i_plus_step_by) in
  let p_ = replace_ p_ (8 * base) (to_list coeffs_i) in
  p_
).
- hoare split; [wp; skip=> &hr [#] _ _ _ -> _ _ -> | by auto].
  have ->: W8u32.to_list coeffs_i{hr} =
    mkseq (fun i => coeffs_i{hr} \bits32 i) 8 by done.
  rewrite of_uintK pmod_small 1:/# (_ : 32 = 4 * 8) 1:#ring -mulrA.
  rewrite wpoly_set256_aligned 1:/#.
  move: (replace_ p_ _ _) => q0; (pose s := mkseq _ _) => /=.
  by rewrite replace_mkseq.

skip=> &hr |> /=; rewrite replace_swap 1:/#.
by rewrite /reduce_partial /reduce_coeff /#.
qed.

(* -------------------------------------------------------------------- *)
lemma polynomial__layer (p : wpoly) (base stpby z : int) :
     0 <= base
  => 1 <= stpby
  => 8 * (base + 8 * stpby) <= 256 - 31
  => hoare[M.polynomial____layer :
         arg = (p, base, 8 * stpby, z)
       ==>
         res = reduce_partial p (8 * base) (64 * stpby) 32 (W32.of_int z)
     ].
proof.
hint +listred.
move=> *; proc=> /=; (do 2! (cfold 1; kill -1; first by auto)); sp.
while (
     #{/~{polynomial,i}}pre
  /\ 0 <= i <= 4
  /\ polynomial = reduce_partial p (8 * base) (64 * stpby) (8 * i) (W32.of_int z)
); last first.
- by auto=> &hr |> /#.

wp; cfold 1; kill -1; first by auto.
exlim i, polynomial => i_ q.
case@[ambient]: (0 <= i_ < 4) => ?; last first.
- by conseq (_ : false ==> _); [smt() | exfalso].
call (polynomial__multiply q (base + i_) stpby (W32.of_int z)); ~-1:smt().
auto=> &hr |> *; do! (split=> *).
- by rewrite of_int_bits32_div //#.
- smt().
- smt().
- by rewrite [8 * (_ + 1)]mulrDr /= reduce_partialD -1:-mulrDr //#.
qed.

(* -------------------------------------------------------------------- *)
op [opaque] players : player list = [
  {| base =  0; stepby = 2; twdf = zeta7 ; |};
  {| base =  8; stepby = 2; twdf = zeta7 ; |};
  {| base =  0; stepby = 1; twdf = zeta6L; |};
  {| base = 16; stepby = 1; twdf = zeta6R; |};
  {| base =  4; stepby = 2; twdf = zeta7 ; |};
  {| base = 12; stepby = 2; twdf = zeta7 ; |};
  {| base =  4; stepby = 1; twdf = zeta6L; |};
  {| base = 20; stepby = 1; twdf = zeta6R; |}
].

lemma reduce7E (p : wpoly) :
  reduce_level p 7 = reduce p 0 128 (W32.of_int zeta7).
proof. hint +listred. by rewrite reduce_levelE // zeta_L7E /= reduce_seq1. qed.

lemma reduce6E (p : wpoly) :
  reduce_level p 6 =
    reduce
      (reduce p 0 64 (W32.of_int zeta6L))
      128 64 (W32.of_int zeta6R).
proof. hint +listred. by rewrite reduce_levelE // zeta_L6E /= reduce_seq2. qed.

lemma reduce_playersE (p : wpoly) :
  reduce_players p players = reduce_tree p 6.
proof.
hint +listred.
rewrite /players.
rewrite (reduce_players_swap 4) ~-1://; cbv lswap iswap => /=.
rewrite (reduce_players_swap 3) ~-1://; cbv lswap iswap => /=.
rewrite (reduce_players_swap 5) ~-1://; cbv lswap iswap => /=.
rewrite (reduce_players_swap 4) ~-1://; cbv lswap iswap => /=.
rewrite (reduce_players_swap 2) ~-1://; cbv lswap iswap => /=.
rewrite (reduce_players_swap 6) ~-1://; cbv lswap iswap => /=.

(* Reduce layer 7 *)
rewrite -(cat_take_drop 4) reduce_players_cat /=.
have /= <- := reduce_players_merge p 4 0 2 zeta7.
pose q7 := reduce_partial _ _ _ _ _.

(* Reduce layer 6 *)
rewrite -(cat_take_drop 2) reduce_players_cat /=.
have /= <- := reduce_players_merge q7 2 0 1 zeta6L.
pose q6L := reduce_partial _ _ _ _ _.
have /= <- := reduce_players_merge q6L 2 16 1 zeta6R.
rewrite /q6L /q7 -(reduce_as_partial p 0 128) 1:// -reduce7E.
rewrite -!(reduce_as_partial _ _ 64) ~-1:// -reduce6E.

(* Reduce tree (2 levels) *)
by rewrite /reduce_tree /range -iotaredE.
qed.

lemma polynomial__ntt_at_layer_7_and_6P (p_ : wpoly) :
  hoare[M.polynomial__ntt_at_layer_7_and_6 :
    polynomial = p_ ==> res = reduce_tree p_ 6].
proof.
hint +listred.
proc; proc change [1..5] : {
  sTEP_BY_7 <- 16;
  sTEP_BY_6 <-  8;
  zETA_7    <- zeta7;
  zETA_60   <- zeta6L;
  zETA_61   <- zeta6R;
}; first by auto=> @/(`<<`).
do 5! (cfold 1; kill -1; first by auto).

seq 1: (polynomial = reduce_players p_ (take 1 players)).
- call (polynomial__layer p_ 0 2 zeta7).
  by auto=> &hr |> @/players @/reduce_players @/reduce_player /=.
seq 1: (polynomial = reduce_players p_ (take 2 players)).
- exlim polynomial=> q.
  call (polynomial__layer q 8 2 zeta7).
  by auto=> &hr |> @/players @/reduce_players @/reduce_player /=.
seq 1: (polynomial = reduce_players p_ (take 3 players)).
- exlim polynomial=> q.
  call (polynomial__layer q 0 1 zeta6L).
  by auto=> &hr |> @/players /= @/reduce_players @/reduce_player /=.
seq 1: (polynomial = reduce_players p_ (take 4 players)).
- exlim polynomial=> q.
  call (polynomial__layer q 16 1 zeta6R).
  by auto=> &hr |> @/players /= @/reduce_players @/reduce_player /=.
seq 1: (polynomial = reduce_players p_ (take 5 players)).
- exlim polynomial=> q.
  call (polynomial__layer q 4 2 zeta7).
  by auto=> &hr |> @/players @/reduce_players @/reduce_player /=.
seq 1: (polynomial = reduce_players p_ (take 6 players)).
- exlim polynomial=> q.
  call (polynomial__layer q 12 2 zeta7).
  by auto=> &hr |> @/players @/reduce_players @/reduce_player /=.
seq 1: (polynomial = reduce_players p_ (take 7 players)).
- exlim polynomial=> q.
  call (polynomial__layer q 4 1 zeta6L).
  by auto=> &hr |> @/players /= @/reduce_players @/reduce_player /=.
seq 1: (polynomial = reduce_players p_ (take 8 players)).
- exlim polynomial=> q.
  call (polynomial__layer q 20 1 zeta6R).
  by auto=> &hr |> @/players /= @/reduce_players @/reduce_player /=.

skip=> &hr |>; rewrite take_oversize 1:/players //.
by exact: reduce_playersE.
qed.

(* -------------------------------------------------------------------- *)
lemma polynomial__nttP (p_ : wpoly) :
  hoare[M.polynomial__ntt : polynomial = p_ ==> res = reduce_tree p_ 0].
proof.
hint +listred.
proc.
seq 1: (polynomial = reduce_tree p_ 6).
- by call (polynomial__ntt_at_layer_7_and_6P p_); auto.
exlim polynomial => q; seq 1: (polynomial = reduce_tree p_ 5).
- by call (polynomial__ntt_at_layer_5P q); auto=> &hr |>.
exlim polynomial => {q} q; seq 1: (polynomial = reduce_tree p_ 4).
- by call (polynomial__ntt_at_layer_4P q); auto=> &hr |>.
exlim polynomial => {q} q; seq 1: (polynomial = reduce_tree p_ 3).
- by call (polynomial__ntt_at_layer_3P q); auto=> &hr |>.
exlim polynomial => {q} q; seq 1: (polynomial = reduce_tree p_ 2).
- by call (polynomial__ntt_at_layer_2P q); auto=> &hr |>.
exlim polynomial => {q} q; seq 1: (polynomial = reduce_tree p_ 1).
- by call (polynomial__ntt_at_layer_1P q); auto=> &hr |>.
exlim polynomial => {q} q; seq 1: (polynomial = reduce_tree p_ 0).
- by call (polynomial__ntt_at_layer_0P q); auto=> &hr |>.
done.
qed.

end FnttcorrectT.
