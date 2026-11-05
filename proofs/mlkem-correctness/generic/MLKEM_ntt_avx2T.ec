(**
  The AVX2 forward NTT of ML-KEM (`_poly_ntt`) computes the generic
  Cooley-Tukey tree (`NttKem.reduce_tree`), level by level, followed by
  a Barrett reduction, in the coefficient order of `nttunpack`.

  Level 7 runs on memory, in two batches; levels 6 .. 1 run on half a
  polynomial in registers (`MLKEM_ntt_levels`).
*)

require import AllCore List Int IntDiv StdOrder.
from Jasmin require import JModel_x86.
from JazzEC require import Array16 Array256 Array400 WArray32 WArray512 WArray800.
require import Montgomery16 MLKEMFCLib NttKem.
require import JkemConstants.
require BaseT MLKEM_ntt_levelsT.

abstract theory MLKEM_ntt_avx2T.

clone import BaseT.BaseT as B.
import R.
clone import MLKEM_ntt_levelsT.MLKEM_ntt_levelsT as MLKEM_ntt_levels with theory B <- B.

(* ==================================================================== *)

(*---*) import IntOrder.

(* ==================================================================== *)
(* Constants, loads, stores and the final reduction                     *)
(* ==================================================================== *)
(* loads and stores of the 16 blocks of a polynomial *)
op [opaque] ld (p : wpoly) (b : int) : W256.t =
  get256_direct (WArray512.init16 (fun i => p.[i])) (32 * b).

op [opaque] st (p : wpoly) (b : int) (w : W256.t) : wpoly =
  Array256.init (fun j =>
    if 16 * b <= j < 16 * b + 16 then w \bits16 (j - 16 * b) else p.[j]).

lemma ldE (p : wpoly) (b l : int) :
  0 <= b < 16 => 0 <= l < 16 => ld p b \bits16 l = p.[16 * b + l].
proof. by move=> rgb rgl; rewrite /ld (: 32 * b = 2 * (16 * b)) 1:#ring load512E /#. qed.

lemma stE (p : wpoly) (b : int) (w : W256.t) : 0 <= b < 16 =>
    Array256.init (fun i0 => WArray512.get16
      (WArray512.set256_direct (WArray512.init16 (fun i => p.[i])) (32 * b) w) i0)
  = st p b w.
proof.
move=> rgb; apply Array256.ext_eq => j rgj; rewrite /st !initiE //=.
rewrite get16_set256E 1,2:/#; case: (16 * b <= j < 16 * b + 16) => hj.
- by rewrite ifT 1:/#.
by rewrite ifF 1:/# get16_init16 /#.
qed.

lemma stoE (p : wpoly) (o : int) (w : W256.t) : 0 <= o < 512 => 32 %| o =>
    Array256.init (fun i0 => WArray512.get16
      (WArray512.set256_direct (WArray512.init16 (fun i => p.[i])) o w) i0)
  = st p (o %/ 32) w.
proof. by move=> rgo hd; rewrite -stE 1:/# mulzC divzK. qed.

(* the loads and stores of the loop, at block m of half h *)
lemma ldhE (p : wpoly) (m h : int) :
  get256_direct (WArray512.init16 (fun i => p.[i])) (32 * m + 256 * h) = ld p (m + 8 * h).
proof. by rewrite /ld; congr; ring. qed.

lemma sthE (p : wpoly) (m h : int) (w : W256.t) : 0 <= m + 8 * h < 16 =>
    Array256.init (fun i0 => WArray512.get16
      (WArray512.set256_direct (WArray512.init16 (fun i => p.[i])) (32 * m + 256 * h) w) i0)
  = st p (m + 8 * h) w.
proof. by move=> rgb; rewrite -stE // (: 32 * (m + 8 * h) = 32 * m + 256 * h) 1:#ring. qed.

(* -------------------------------------------------------------------- *)
(* registers loaded from, or stored to, blocks bs of a polynomial       *)
op layout (h : int) (pos bs : int list) =
  all (fun i =>
       0 <= nth 0 bs (i %/ 16) < 16
    /\ 128 * h + nth 0 pos i = 16 * nth 0 bs (i %/ 16) + i %% 16) (iota_ 0 128).

op stl (q : wpoly) (bs : int list) (rf : W256.t list) : wpoly =
  foldl (fun p (x : int * W256.t) => st p x.`1 x.`2) q (zip bs rf).

lemma stlE (q : wpoly) (bs : int list) (rf : W256.t list) (j : int) :
  uniq bs => size bs = size rf => all (fun b => 0 <= b < 16) bs => 0 <= j < 256 =>
  (stl q bs rf).[j] =
    if j %/ 16 \in bs then nth W256.zero rf (index (j %/ 16) bs) \bits16 (j %% 16)
    else q.[j].
proof.
elim: bs rf q => [|b bs ih] [|w rf] q //=.
- by move=> _; smt(size_ge0).
move=> [nbs ubs] /= hsz [rgb hall] rgj.
rewrite /stl /= -/(stl _ bs rf) ih //; first smt().
rewrite index_cons; case: (j %/ 16 = b) => [hb|neb] /=.
- by rewrite hb ifF // /st initiE //= ifT 1:/#; congr; smt().
case: (j %/ 16 \in bs) => hin /=; first by rewrite ifF //; smt(index_ge0).
by rewrite /st initiE //= ifF 1:/#.
qed.

(* stored registers whose lanes are the values of P at their blocks     *)
lemma stl_lanes (P q : wpoly) (bs : int list) (rf : W256.t list) (j : int) :
  uniq bs => size bs = size rf => all (fun b => 0 <= b < 16) bs =>
  (forall k l, 0 <= k < size bs => 0 <= l < 16 =>
     nth W256.zero rf k \bits16 l = P.[16 * nth 0 bs k + l]) =>
  0 <= j < 256 =>
  (stl q bs rf).[j] = if j %/ 16 \in bs then P.[j] else q.[j].
proof.
move=> ubs hsz hall hl rgj; rewrite stlE //.
case: (j %/ 16 \in bs) => // hin; rewrite hl; [smt(index_ge0 index_mem) | smt() | ].
by rewrite nth_index //; congr; smt().
qed.

(* loading blocks on which q agrees with P *)
lemma rfinv_ld (P q : wpoly) (h : int) (pos bs : int list) :
  size bs = 8 => layout h pos bs =>
  (forall j, 0 <= j < 256 => j %/ 16 \in bs => q.[j] = P.[j]) =>
  rfinv P h pos (map (ld q) bs).
proof.
move=> hsz /List.allP hl hq i rgi; have /= [rgb e] := hl i _; first by rewrite mem_iota /#.
rewrite /rfl (nth_map 0) 1:/# ldE 1,2:/# e hq 1:/# //.
by rewrite (: (16 * nth 0 bs (i %/ 16) + i %% 16) %/ 16 = nth 0 bs (i %/ 16)) 1:/# mem_nth /#.
qed.

(* registers in layout hold, lane by lane, the values of their blocks  *)
lemma rfinv_lanes (P : wpoly) (h : int) (pos bs : int list) (rf : W256.t list) :
  layout h pos bs => rfinv P h pos rf =>
  forall k l, 0 <= k < 8 => 0 <= l < 16 =>
    nth W256.zero rf k \bits16 l = P.[16 * nth 0 bs k + l].
proof.
move=> /List.allP hl hinv k l rgk rgl.
have /= [_ e] := hl (16 * k + l) _; first by rewrite mem_iota /#.
move: e; rewrite (: (16 * k + l) %/ 16 = k) 1:/# (: (16 * k + l) %% 16 = l) 1:/# => <-.
by rewrite -hinv 1:/# rflE.
qed.

(* the final reduction acts lane by lane *)
lemma rfinv_redl (P : wpoly) (h : int) (pos : int list) (rf : W256.t list) :
  0 <= h < 2 => all (fun x => 0 <= x < 128) pos => size rf = 8 =>
  rfinv P h pos rf => rfinv (Array256.map sbred16 P) h pos (map redl rf).
proof.
move=> rgh /List.allP hpos hsz hinv i rgi; have rgx : 0 <= nth 0 pos i < 128.
- case: (i < size pos) => hi; first by apply hpos; rewrite mem_nth /#.
  by rewrite nth_out /#.
rewrite /rfl (nth_map W256.zero) 1:/# /redl pack16bE 1:/# W16u16.Pack.get_of_list 1:/#.
by rewrite nth_mkseq 1:/# /= -/(rfl rf i) hinv // mapiE 1:/#.
qed.

(* the 8 stores of one half, in the order of the code *)
lemma st8E (p q : wpoly) (h j : int) (w0 w1 w2 w3 w4 w5 w6 w7 : W256.t) :
  0 <= h < 2 => 0 <= j < 256 =>
  (forall k l, 0 <= k < 8 => 0 <= l < 16 =>
     nth W256.zero [w0; w4; w1; w5; w2; w6; w3; w7] k \bits16 l = q.[16 * (8 * h + k) + l]) =>
    (st (st (st (st (st (st (st (st p (8 * h) w0) (1 + 8 * h) w4) (2 + 8 * h) w1)
       (3 + 8 * h) w5) (4 + 8 * h) w2) (5 + 8 * h) w6) (6 + 8 * h) w3) (7 + 8 * h) w7).[j]
  = if 8 * h <= j %/ 16 < 8 * h + 8 then q.[j] else p.[j].
proof.
move=> rgh rgj hl.
pose bs := [8 * h; 1 + 8 * h; 2 + 8 * h; 3 + 8 * h; 4 + 8 * h; 5 + 8 * h; 6 + 8 * h; 7 + 8 * h].
rewrite -/(stl p bs [w0; w4; w1; w5; w2; w6; w3; w7]) (stl_lanes q) //.
- by rewrite /bs /=; smt().
- by rewrite /bs /=; smt().
- move=> k l rgk rgl; rewrite hl //; congr; congr.
  by (have [|[|[|[|[|[|[|]]]]]]] ->> : k = 0 \/ k = 1 \/ k = 2 \/ k = 3 \/
    k = 4 \/ k = 5 \/ k = 6 \/ k = 7 by smt()); rewrite /bs /=; smt().
by rewrite /bs /=; smt().
qed.

(* the expected result: the leaves, reduced, in the order of the code   *)
op sigma : int list = [0;4;1;5;2;6;3;7].

op fin (j : int) : int =
  128 * (j %/ 128) + nth 0 pos2 (16 * nth 0 sigma (j %% 128 %/ 16) + j %% 16).

op nttres (p : wpoly) : wpoly =
  Array256.init (fun j => sbred16 (reduce_tree p 1).[fin j]).

(* ==================================================================== *)
(* The forward NTT                                                      *)
(* ==================================================================== *)
hoare poly_ntt_h (_r : wpoly) : M._poly_ntt : rp = _r ==> res = nttres _r.
proof.
proc.
seq 3 : (rp = _r /\ qx16 = qx16v /\ zeta0 = zb 0 /\ zeta1 = zb 4).
- by auto => />; rewrite qx16vE /zb.
(* level 7: the first batch, blocks 0..3 against 8..11 *)
seq 9 : (rp = _r /\ qx16 = qx16v /\ zeta0 = zb 0 /\ zeta1 = zb 4 /\
  rfinv (reduce_level _r 7) 0 pos7a [r0; r1; r2; r3; r4; r5; r6; r7]).
- ecall (butterfly64x_h r0 r1 r2 r3 r4 r5 r6 r7 zeta0 zeta0 zeta1 zeta1).
  auto => &hr |> /=.
  have := lvl7 rp{hr} pos7a (map (ld rp{hr}) [0;1;2;3;8;9;10;11]) _ _ => //.
  + by apply rfinv_ld => //; rewrite /layout /pos7a -!iotaredE.
  by rewrite /rfbf /ld /mkseq -iotaredE /= /zsel /=.
seq 21 : (qx16 = qx16v /\
     (forall j, 0 <= j < 256 => !(64 <= j < 128) => rp.[j] = (reduce_level _r 7).[j])
  /\ (forall i, 0 <= i < 64 => rfl [r0; r1; r2; r3] i = (reduce_level _r 7).[64 + i])).
- seq 8 : (qx16 = qx16v /\ zeta0 = zb 0 /\ zeta1 = zb 4 /\
    rp = stl _r [0;1;2;3;8;9;10;11] [r0; r1; r2; r3; r4; r5; r6; r7] /\
    rfinv (reduce_level _r 7) 0 pos7a [r0; r1; r2; r3; r4; r5; r6; r7]).
  + by auto => &hr |> *; rewrite !stoE // /stl.
  conseq (_ : qx16 = qx16v /\ zeta0 = zb 0 /\ zeta1 = zb 4 /\
    forall j, 0 <= j < 256 => rp.[j] =
      if j %/ 16 \in [0;1;2;3;8;9;10;11] then (reduce_level _r 7).[j] else _r.[j] ==> _).
  + move=> &hr |> hinv j rgj ltj; rewrite (stl_lanes (reduce_level _r 7)) //.
    move=> k l rgk rgl; apply (rfinv_lanes _ 0 pos7a _ _ _ hinv) => //.
    by rewrite /layout /pos7a -!iotaredE.
  (* level 7: the second batch, blocks 4..7 against 12..15 *)
  seq 9 : (qx16 = qx16v /\
    (forall j, 0 <= j < 256 => rp.[j] =
       if j %/ 16 \in [0;1;2;3;8;9;10;11] then (reduce_level _r 7).[j] else _r.[j]) /\
    rfinv (reduce_level _r 7) 0 pos7b [r0; r1; r2; r3; r4; r5; r6; r7]).
  + ecall (butterfly64x_h r0 r1 r2 r3 r4 r5 r6 r7 zeta0 zeta0 zeta1 zeta1).
    auto => &hr |> hm /=.
    have := lvl7 _r pos7b (map (ld rp{hr}) [4;5;6;7;12;13;14;15]) _ _ => //.
    * apply rfinv_ld => //; first by rewrite /layout /pos7b -!iotaredE.
      by move=> j rgj /= hj; rewrite hm //; smt().
    by rewrite /rfbf /ld /mkseq -iotaredE /= /zsel /=.
  auto => &hr |> hm hinv.
  rewrite !stoE // -/(stl rp{hr} [12;13;14;15] [r4{hr}; r5{hr}; r6{hr}; r7{hr}]).
  have hl := rfinv_lanes _ 0 pos7b [4;5;6;7;12;13;14;15] _ _ hinv.
  + by rewrite /layout /pos7b -!iotaredE.
  split=> [j ge0j ltj hj | i ge0i lti].
  + rewrite (stl_lanes (reduce_level _r 7)) //.
    * move=> k l rgk rgl; have := hl (k + 4) l _ rgl; first smt().
      by have [|[|[|]]] ->> : k = 0 \/ k = 1 \/ k = 2 \/ k = 3 by smt().
    by case: (j %/ 16 \in [12;13;14;15]) => // hn; rewrite hm //; smt().
  rewrite /rfl; have := hl (i %/ 16) (i %% 16) _ _; 1,2: smt().
  by (have [|[|[|]]] hk : i %/ 16 = 0 \/ i %/ 16 = 1 \/ i %/ 16 = 2 \/ i %/ 16 = 3 by smt());
    rewrite hk /= => ->; congr; smt().
(* the loop: one half per iteration, levels 6 .. 1 in registers *)
sp; while (0 <= i <= 2 /\ qx16 = qx16v /\
  (forall j, 0 <= j < 128 * i => rp.[j] = (nttres _r).[j]) /\
  (forall j, 128 * i <= j < 256 => (i = 0 => !(64 <= j < 128)) =>
     rp.[j] = (reduce_level _r 7).[j]) /\
  (i = 0 => forall k, 0 <= k < 64 => rfl [r0; r1; r2; r3] k = (reduce_level _r 7).[64 + k]));
  last first.
- auto => &hr |> h1 h2; split; first smt().
  move=> i0 r0 r1 r2 r3 rp0 h4 h5 h6 h7 h8 h9.
  by apply Array256.ext_eq => j rgj; apply h7; smt().
exlim i => h.
have rt7 : reduce_tree _r 7 = reduce_level _r 7 by rewrite reduce_tree_step // reduce_tree8.
have ldoE : forall (p : wpoly) (o l : int), 0 <= o => o + 32 <= 512 => 2 %| o => 0 <= l < 16 =>
  get256_direct (WArray512.init16 (fun i => p.[i])) o \bits16 l = p.[o %/ 2 + l].
- move=> p o l ge0o le512 evo rgl; have {1}-> : o = 2 * (o %/ 2) by rewrite mulrC divzK.
  by rewrite load512E //; smt().
seq 2 : (#pre /\ i = h /\ zeta0 = zb (8 + 392 * h) /\ zeta1 = zb (12 + 392 * h)).
- by auto => &hr |> *; rewrite /zb.
(* the half in registers, at level 7 *)
seq 5 : (i = h /\ 0 <= h < 2 /\ qx16 = qx16v /\
  (forall j, 0 <= j < 128 * h => rp.[j] = (nttres _r).[j]) /\
  (forall j, 128 * (h + 1) <= j < 256 => rp.[j] = (reduce_tree _r 7).[j]) /\
  zeta0 = zb (8 + 392 * h) /\ zeta1 = zb (12 + 392 * h) /\
  rfinv (reduce_tree _r 7) h pos6 [r0; r1; r2; r3; r4; r5; r6; r7]).
- if.
  + auto => &hr |> _ hm hreg; rewrite rt7; split => [j ge0j ltj | i rgi].
    * by rewrite hm /#.
    rewrite /rfl /pos6 nth_iota //=; case: (i < 64) => hi.
    * have [|[|[|]]] hk : i %/ 16 = 0 \/ i %/ 16 = 1 \/ i %/ 16 = 2 \/ i %/ 16 = 3 by smt().
      - by rewrite hk /= ldoE //; [smt() | rewrite hm 1,2:/#; congr; smt()].
      - by rewrite hk /= ldoE //; [smt() | rewrite hm 1,2:/#; congr; smt()].
      - by rewrite hk /= ldoE //; [smt() | rewrite hm 1,2:/#; congr; smt()].
      by rewrite hk /= ldoE //; [smt() | rewrite hm 1,2:/#; congr; smt()].
    have := hreg (i - 64) _; first smt().
    rewrite /rfl.
    have [|[|[|]]] hk : i %/ 16 = 4 \/ i %/ 16 = 5 \/ i %/ 16 = 6 \/ i %/ 16 = 7 by smt().
    * by rewrite hk /= (: (i - 64) %/ 16 = 0) 1:/# (: (i - 64) %% 16 = i %% 16) 1:/#.
    * by rewrite hk /= (: (i - 64) %/ 16 = 1) 1:/# (: (i - 64) %% 16 = i %% 16) 1:/#.
    * by rewrite hk /= (: (i - 64) %/ 16 = 2) 1:/# (: (i - 64) %% 16 = i %% 16) 1:/#.
    by rewrite hk /= (: (i - 64) %/ 16 = 3) 1:/# (: (i - 64) %% 16 = i %% 16) 1:/#.
  auto => &hr |> 2? _ hm _ hlt hne; have ->> : i{hr} = 1 by smt().
  rewrite rt7; split => [j ge0j ltj | ]; first by smt().
  have := rfinv_ld (reduce_level _r 7) rp{hr} 1 pos6 [8;9;10;11;12;13;14;15] _ _ _ => //.
  + by rewrite /layout /pos6 -!iotaredE.
  + by move=> j rgj /= hj; rewrite hm //; smt().
  by rewrite /ld.
(* level 6 *)
seq 1 : (#{/~{r0,r1,r2,r3,r4,r5,r6,r7,zeta0,zeta1}}pre /\
  rfinv (reduce_tree _r 6) h pos6 [r0; r1; r2; r3; r4; r5; r6; r7]).
- ecall (butterfly64x_h r0 r1 r2 r3 r4 r5 r6 r7 zeta0 zeta0 zeta1 zeta1).
  auto => &hr |> 4? hinv /=.
  have := lvl6 (reduce_tree _r 7) _ _ _ hinv; first smt().
  by rewrite -reduce_tree_step // /rfbf /mkseq -iotaredE /= /zsel /=.
(* level 5 *)
seq 2 : (#{/~{zeta0,zeta1}}pre /\ zeta0 = zv (16 + 392 * h) /\ zeta1 = zv (48 + 392 * h)).
- by auto => &hr |> *; rewrite /zv.
seq 5 : (#{/~{r0,r1,r2,r3,r4,r5,r6,r7}}pre /\
  rfinv (reduce_tree _r 5) h pos5 [r0; r1; r2; r3; r4; r5; r6; r7]).
- ecall (butterfly64x_h r0 r4 r1 r5 r2 r6 r3 r7 zeta0 zeta0 zeta1 zeta1).
  ecall (shuffle8_h r3 r7); ecall (shuffle8_h r2 r6).
  ecall (shuffle8_h r1 r5); ecall (shuffle8_h r0 r4).
  auto => &hr |> 4? hinv.
  have := lvl5 (reduce_tree _r 6) _ _ _ hinv; first smt().
  by rewrite -reduce_tree_step // /rfbf /rfshuf /mkseq -iotaredE /= /zsel /=.
(* level 4 *)
seq 2 : (#{/~{zeta0,zeta1}}pre /\ zeta0 = zv (80 + 392 * h) /\ zeta1 = zv (112 + 392 * h)).
- by auto => &hr |> *; rewrite /zv.
seq 5 : (#{/~{r0,r1,r2,r3,r4,r5,r6,r7}}pre /\
  rfinv (reduce_tree _r 4) h pos4 [r0; r1; r2; r3; r4; r5; r6; r7]).
- ecall (butterfly64x_h r0 r2 r4 r6 r1 r3 r5 r7 zeta0 zeta0 zeta1 zeta1).
  ecall (shuffle4_h r5 r7); ecall (shuffle4_h r1 r3).
  ecall (shuffle4_h r4 r6); ecall (shuffle4_h r0 r2).
  auto => &hr |> 4? hinv.
  have := lvl4 (reduce_tree _r 5) _ _ _ hinv; first smt().
  by rewrite -reduce_tree_step // /rfbf /rfshuf /mkseq -iotaredE /= /zsel /=.
(* level 3 *)
seq 2 : (#{/~{zeta0,zeta1}}pre /\ zeta0 = zv (144 + 392 * h) /\ zeta1 = zv (176 + 392 * h)).
- by auto => &hr |> *; rewrite /zv.
seq 5 : (#{/~{r0,r1,r2,r3,r4,r5,r6,r7}}pre /\
  rfinv (reduce_tree _r 3) h pos3 [r0; r1; r2; r3; r4; r5; r6; r7]).
- ecall (butterfly64x_h r0 r1 r2 r3 r4 r5 r6 r7 zeta0 zeta0 zeta1 zeta1).
  ecall (shuffle2_h r6 r7); ecall (shuffle2_h r4 r5).
  ecall (shuffle2_h r2 r3); ecall (shuffle2_h r0 r1).
  auto => &hr |> 4? hinv.
  have := lvl3 (reduce_tree _r 4) _ _ _ hinv; first smt().
  by rewrite -reduce_tree_step // /rfbf /rfshuf /mkseq -iotaredE /= /zsel /=.
(* level 2 *)
seq 2 : (#{/~{zeta0,zeta1}}pre /\ zeta0 = zv (208 + 392 * h) /\ zeta1 = zv (240 + 392 * h)).
- by auto => &hr |> *; rewrite /zv.
seq 5 : (#{/~{r0,r1,r2,r3,r4,r5,r6,r7}}pre /\
  rfinv (reduce_tree _r 2) h pos2 [r0; r1; r2; r3; r4; r5; r6; r7]).
- ecall (butterfly64x_h r0 r4 r1 r5 r2 r6 r3 r7 zeta0 zeta0 zeta1 zeta1).
  ecall (shuffle1_h r3 r7); ecall (shuffle1_h r2 r6).
  ecall (shuffle1_h r1 r5); ecall (shuffle1_h r0 r4).
  auto => &hr |> 4? hinv.
  have := lvl2 (reduce_tree _r 3) _ _ _ hinv; first smt().
  by rewrite -reduce_tree_step // /rfbf /rfshuf /mkseq -iotaredE /= /zsel /=.
(* level 1 *)
seq 4 : (#{/~{zeta0,zeta1}}pre /\ zeta0 = zv (272 + 392 * h) /\ zeta2 = zv (304 + 392 * h) /\
  zeta1 = zv (336 + 392 * h) /\ zeta3 = zv (368 + 392 * h)).
- by auto => &hr |> *; rewrite /zv.
seq 1 : (#{/~{r0,r1,r2,r3,r4,r5,r6,r7}}pre /\
  rfinv (reduce_tree _r 1) h pos2 [r0; r1; r2; r3; r4; r5; r6; r7]).
- ecall (butterfly64x_h r0 r4 r2 r6 r1 r5 r3 r7 zeta0 zeta1 zeta2 zeta3).
  auto => &hr |> 4? hinv.
  have := lvl1 (reduce_tree _r 2) _ _ _ hinv; first smt().
  by rewrite -reduce_tree_step // /rfbf /mkseq -iotaredE /= /zsel /=.
(* the final reduction *)
seq 1 : (#pre /\ vx16 = vx16v); first by auto => &hr |> *; exact vx16vE.
seq 8 : (#{/~{r0,r1,r2,r3,r4,r5,r6,r7}}pre /\
  rfinv (Array256.map sbred16 (reduce_tree _r 1)) h pos2 [r0; r1; r2; r3; r4; r5; r6; r7]).
- ecall (red16x_h r7); ecall (red16x_h r3); ecall (red16x_h r5); ecall (red16x_h r1).
  ecall (red16x_h r6); ecall (red16x_h r2); ecall (red16x_h r4); ecall (red16x_h r0).
  auto => &hr |> 4? hinv.
  by have := rfinv_redl _ _ _ _ _ _ _ hinv => //; rewrite /pos2.
(* the stores *)
auto => &hr |> 2? hdone hrest hinv.
have fl : forall (k l : int), 0 <= k < 8 => 0 <= l < 16 =>
    nth W256.zero [r0{hr}; r4{hr}; r1{hr}; r5{hr}; r2{hr}; r6{hr}; r3{hr}; r7{hr}] k \bits16 l
  = (nttres _r).[16 * (8 * i{hr} + k) + l].
- move=> k l rgk rgl.
  have hs : 0 <= nth 0 sigma k < 8.
  + by have [|[|[|[|[|[|[|]]]]]]] ->> : k = 0 \/ k = 1 \/ k = 2 \/ k = 3 \/
      k = 4 \/ k = 5 \/ k = 6 \/ k = 7 by smt().
  have -> : nth W256.zero [r0{hr}; r4{hr}; r1{hr}; r5{hr}; r2{hr}; r6{hr}; r3{hr}; r7{hr}] k
          = nth W256.zero [r0{hr}; r1{hr}; r2{hr}; r3{hr}; r4{hr}; r5{hr}; r6{hr}; r7{hr}]
              (nth 0 sigma k).
  + by have [|[|[|[|[|[|[|]]]]]]] ->> : k = 0 \/ k = 1 \/ k = 2 \/ k = 3 \/
      k = 4 \/ k = 5 \/ k = 6 \/ k = 7 by smt().
  rewrite -rflE // hinv; first smt().
  have hp : 0 <= nth 0 pos2 (16 * nth 0 sigma k + l) < 128.
  + have : all (fun x => 0 <= x < 128) pos2 by rewrite /pos2.
    move=> /List.allP; apply; rewrite mem_nth /pos2 /=; smt().
  rewrite mapiE 1:/# /nttres initiE 1:/# /fin /=.
  rewrite (: (16 * (8 * i{hr} + k) + l) %/ 128 = i{hr}) 1:/#.
  rewrite (: (16 * (8 * i{hr} + k) + l) %% 128 %/ 16 = k) 1:/#.
  by rewrite (: (16 * (8 * i{hr} + k) + l) %% 16 = l) 1:/#.
rewrite !stoE; 1..16: smt(dvdzD dvdz_mulr dvdzz).
rewrite (: 256 * i{hr} %/ 32 = 8 * i{hr}) 1:/#.
rewrite (: (32 + 256 * i{hr}) %/ 32 = 1 + 8 * i{hr}) 1:/#.
rewrite (: (64 + 256 * i{hr}) %/ 32 = 2 + 8 * i{hr}) 1:/#.
rewrite (: (96 + 256 * i{hr}) %/ 32 = 3 + 8 * i{hr}) 1:/#.
rewrite (: (128 + 256 * i{hr}) %/ 32 = 4 + 8 * i{hr}) 1:/#.
rewrite (: (160 + 256 * i{hr}) %/ 32 = 5 + 8 * i{hr}) 1:/#.
rewrite (: (192 + 256 * i{hr}) %/ 32 = 6 + 8 * i{hr}) 1:/#.
rewrite (: (224 + 256 * i{hr}) %/ 32 = 7 + 8 * i{hr}) 1:/#.
split; first smt().
split => [j ge0j ltj | ].
- rewrite (st8E _ (nttres _r)) 1,2:/# //.
  by case: (8 * i{hr} <= j %/ 16 < 8 * i{hr} + 8) => hj //; rewrite hdone /#.
split => [j ge0j ltj _ | /#].
by rewrite (st8E _ (nttres _r)) 1,2:/# // ifF 1:/# hrest // reduce_tree_step // reduce_tree8.
qed.

end MLKEM_ntt_avx2T.
