(**
  The AVX2 inverse NTT of ML-KEM (`_poly_invntt`) computes the generic
  Gentleman-Sande merges (`NttKem.ireduce_level`), level by level, with
  Barrett reductions of some registers in between, and a last level
  fused with the scaling by F = 512 (128 * 512 = 2^16 mod q).

  The input is read in the order of `nttpack` (`pk`); levels 1 .. 6 run
  on half a polynomial in registers (`MLKEM_invntt_levels`), level 7 on
  memory.
*)

(* ==================================================================== *)
require import AllCore List Int IntDiv StdOrder.
(*---*) import IntOrder.

from Jasmin require import JModel.
from JazzEC require import Array16 Array256 Array400 WArray32 WArray512 WArray800.
from JazzEC require import Jkem_avx2.

require import Montgomery16 MLKEMFCLib NttKem MLKEM_ntt_levels MLKEM_ntt_avx2.
require import MLKEM_invntt_levels.

(* ==================================================================== *)
(* The computation                                                      *)
(* ==================================================================== *)
(* the input, read in the order of the code *)
op pk (p : wpoly) : wpoly = Array256.init (fun i => p.[nth 0 pkidx i]).

(* the reduced positions *)
op S1 = redS ip1 [0;1;4;5].
op S3 = redS ip3 [0].
op S4 = redS ip4 [0].
op S5 = redS ip5 [0].
op S6 = redS ip6 [0].

(* the levels 1 .. 6, with their reductions *)
op iv1 (v : wpoly) : wpoly = ireduce_level v 1.
op iv2 (v : wpoly) : wpoly = ireduce_level (redat (iv1 v) S1) 2.
op iv3 (v : wpoly) : wpoly = redat (ireduce_level (iv2 v) 3) S3.
op iv4 (v : wpoly) : wpoly = redat (ireduce_level (iv3 v) 4) S4.
op iv5 (v : wpoly) : wpoly = redat (ireduce_level (iv4 v) 5) S5.
op iv6 (v : wpoly) : wpoly = redat (ireduce_level (iv5 v) 6) S6.

(* level 7, with the scaling by F folded in *)
op F : int = 512.

op ilast (v : wpoly) : wpoly =
  Array256.init (fun i =>
    if i < 128 then mmr16 (v.[i] + v.[i + 128]) (tw16 F)
    else mmr16 (v.[i - 128] - v.[i]) (tw16 (izv 7 0 * F))).

op invres (rp : wpoly) : wpoly = ilast (iv6 (pk rp)).

(* ==================================================================== *)
(* Lane specifications                                                  *)
(* ==================================================================== *)
lemma iaddlb (a b : W256.t) (l : int) : 0 <= l < 16 =>
  iaddl a b \bits16 l = (a \bits16 l) + (b \bits16 l).
proof. by move=> rgl; rewrite /iaddl pack16bE // W16u16.Pack.get_of_list // nth_mkseq. qed.

lemma isublb (a b zl zh : W256.t) (l : int) : 0 <= l < 16 =>
  isubl a b zl zh \bits16 l = mmr16 ((a \bits16 l) - (b \bits16 l)) (zl \bits16 l, zh \bits16 l).
proof. by move=> rgl; rewrite /isubl pack16bE // W16u16.Pack.get_of_list // nth_mkseq. qed.

op [opaque] flov : W256.t = get256_direct (WArray32.init16 (fun i => jflox16.[i])) 0.
op [opaque] fhiv : W256.t = get256_direct (WArray32.init16 (fun i => jfhix16.[i])) 0.

lemma fE (l : int) : 0 <= l < 16 => (flov \bits16 l, fhiv \bits16 l) = tw16 F.
proof.
move=> rgl; rewrite /flov /fhiv !load32E //.
by move: l rgl; apply/allP_range; rewrite -iotaredE /tw16 /mrepr /F.
qed.

lemma z7E (l : int) : 0 <= l < 16 =>
  (zib 784 \bits16 l, zib 788 \bits16 l) = tw16 (izv 7 0 * F).
proof.
move=> rgl; rewrite !zibL // Array400.of_listK //.
move: l rgl; apply/allP_range; rewrite -iotaredE /= /F.
by with hint +listred (cbv delta).
qed.

lemma ldoE (p : wpoly) (o l : int) : 0 <= o => o + 32 <= 512 => 2 %| o => 0 <= l < 16 =>
  get256_direct (WArray512.init16 (fun i => p.[i])) o \bits16 l = p.[o %/ 2 + l].
proof.
move=> ge0o le512 evo rgl; have {1}-> : o = 2 * (o %/ 2) by rewrite mulrC divzK.
by rewrite load512E //; smt().
qed.

(* loading half h, whose lanes are the positions pos of P *)
lemma rfinv_ldo (P q : wpoly) (h : int) (pos os : int list) :
  0 <= h < 2 => size os = 8 => (forall m, 0 <= m < 8 => nth 0 os m = 32 * m + 256 * h) =>
  (forall i, 0 <= i < 128 => q.[128 * h + i] = P.[128 * h + nth 0 pos i]) =>
  rfinv P h pos (map (fun o => get256_direct (WArray512.init16 (fun i => q.[i])) o) os).
proof.
move=> rgh hsz hos hq i rgi; rewrite /rfl (nth_map 0) 1:/# /= hos 1:/#.
rewrite (: 32 * (i %/ 16) + 256 * h = 2 * (16 * (i %/ 16) + 128 * h)) 1:#ring.
by rewrite load512E 1..3:/# -hq 1:/#; congr; smt().
qed.

(* the 8 stores of one quarter of level 7, in the order of the code    *)
lemma st8qE (p q : wpoly) (h j : int) (w0 w1 w2 w3 w4 w5 w6 w7 : W256.t) :
  0 <= h < 2 => 0 <= j < 256 =>
  (forall k l, 0 <= k < 4 => 0 <= l < 16 =>
       nth W256.zero [w0; w1; w2; w3] k \bits16 l = q.[64 * h + 16 * k + l]
    /\ nth W256.zero [w4; w5; w6; w7] k \bits16 l = q.[128 + 64 * h + 16 * k + l]) =>
    (st (st (st (st (st (st (st (st p (8 + 4 * h) w4) (9 + 4 * h) w5) (10 + 4 * h) w6)
       (11 + 4 * h) w7) (4 * h) w0) (1 + 4 * h) w1) (2 + 4 * h) w2) (3 + 4 * h) w3).[j]
  = if j %% 128 %/ 64 = h then q.[j] else p.[j].
proof.
move=> rgh rgj hl.
pose bs := [8 + 4 * h; 9 + 4 * h; 10 + 4 * h; 11 + 4 * h; 4 * h; 1 + 4 * h; 2 + 4 * h; 3 + 4 * h].
rewrite -/(stl p bs [w4; w5; w6; w7; w0; w1; w2; w3]) (stl_lanes q) //.
- by rewrite /bs /=; smt().
- by rewrite /bs /=; smt().
- move=> k l rgk rgl; rewrite /bs.
  have [|[|[|[|[|[|[|]]]]]]] ->> /= : k = 0 \/ k = 1 \/ k = 2 \/ k = 3 \/
    k = 4 \/ k = 5 \/ k = 6 \/ k = 7 by smt().
  + by have /= [_ ->] := hl 0 l _ _ => //; congr; ring.
  + by have /= [_ ->] := hl 1 l _ _ => //; congr; ring.
  + by have /= [_ ->] := hl 2 l _ _ => //; congr; ring.
  + by have /= [_ ->] := hl 3 l _ _ => //; congr; ring.
  + by have /= [-> _] := hl 0 l _ _ => //; congr; ring.
  + by have /= [-> _] := hl 1 l _ _ => //; congr; ring.
  + by have /= [-> _] := hl 2 l _ _ => //; congr; ring.
  by have /= [-> _] := hl 3 l _ _ => //; congr; ring.
by rewrite /bs /=; smt().
qed.

(* reducing registers of a half in one of the layouts of the code     *)
lemma rfinv_redp (P : wpoly) (h : int) (pos regs : int list) (rf : W256.t list) :
  pos = ip1 \/ pos = ip3 \/ pos = ip4 \/ pos = ip5 \/ pos = ip6 => 0 <= h < 2 =>
  rfinv P h pos rf => rfinv (redat P (redS pos regs)) h pos (rfred regs rf).
proof. by move=> hp rgh; have [? [? ?]] := ip_props pos hp; apply rfinv_red. qed.

(* after level 6, the registers hold the blocks of their half          *)
lemma ip6E (i : int) : 0 <= i < 128 =>
  nth 0 ip6 i = 16 * nth 0 [0;4;1;5;2;6;3;7] (i %/ 16) + i %% 16.
proof. by move: i; apply/allP_range; rewrite /ip6 -iotaredE. qed.

lemma ip6_lanes (P : wpoly) (h : int) (r0 r1 r2 r3 r4 r5 r6 r7 : W256.t) :
  rfinv P h ip6 [r0; r1; r2; r3; r4; r5; r6; r7] =>
  forall k l, 0 <= k < 8 => 0 <= l < 16 =>
    nth W256.zero [r0; r2; r4; r6; r1; r3; r5; r7] k \bits16 l = P.[16 * (8 * h + k) + l].
proof.
move=> hinv k l rgk rgl; pose m := nth 0 [0;2;4;6;1;3;5;7] k.
have [rgm hm] : 0 <= m < 8 /\ nth 0 [0;4;1;5;2;6;3;7] m = k.
- by rewrite /m; have [|[|[|[|[|[|[|]]]]]]] ->> : k = 0 \/ k = 1 \/ k = 2 \/ k = 3 \/
    k = 4 \/ k = 5 \/ k = 6 \/ k = 7 by smt().
have -> : nth W256.zero [r0; r2; r4; r6; r1; r3; r5; r7] k
        = nth W256.zero [r0; r1; r2; r3; r4; r5; r6; r7] m.
- by rewrite /m; have [|[|[|[|[|[|[|]]]]]]] ->> : k = 0 \/ k = 1 \/ k = 2 \/ k = 3 \/
    k = 4 \/ k = 5 \/ k = 6 \/ k = 7 by smt().
rewrite -rflE // hinv 1:/# ip6E 1:/#.
by rewrite (: (16 * m + l) %/ 16 = m) 1:/# (: (16 * m + l) %% 16 = l) 1:/# hm /#.
qed.

(* ==================================================================== *)
(* The inverse NTT                                                      *)
(* ==================================================================== *)
hoare poly_invntt_h (_rp : wpoly) : M._poly_invntt : rp = _rp ==> res = invres _rp.
proof.
proc.
seq 2 : (rp = _rp /\ qx16 = qx16v /\ i = 0); first by auto => />; rewrite qx16vE.
(* the levels 1 .. 6, one half per iteration *)
seq 1 : (qx16 = qx16v /\
  (forall j, 0 <= j < 128 => rp.[j] = (iv6 (pk _rp)).[j]) /\
  (forall j, 192 <= j < 256 => rp.[j] = (iv6 (pk _rp)).[j]) /\
  (forall k l, 0 <= k < 4 => 0 <= l < 16 =>
     nth W256.zero [r0; r2; r4; r6] k \bits16 l = (iv6 (pk _rp)).[128 + 16 * k + l])).
- while (0 <= i <= 2 /\ qx16 = qx16v /\
    (forall j, 0 <= j < 128 * i => !(128 <= j < 192) => rp.[j] = (iv6 (pk _rp)).[j]) /\
    (forall j, 128 * i <= j < 256 => rp.[j] = _rp.[j]) /\
    (i = 2 => forall k l, 0 <= k < 4 => 0 <= l < 16 =>
       nth W256.zero [r0; r2; r4; r6] k \bits16 l = (iv6 (pk _rp)).[128 + 16 * k + l]));
    last first.
  + auto => &hr |> *; split; first smt().
    move=> i0 r0 r2 r4 r6 rp0 h1 h2 h3 h4 h5 h6; have ->> : i0 = 2 by smt().
    split=> [j *|]; first by rewrite h4 //#.
    split=> [j *|]; first by rewrite h4 //#.
    by move=> k l *; apply h6 => //#.
  exlim i => h.
  seq 4 : (#pre /\ i = h /\ zeta0 = ziv (392 * h) /\ zeta1 = ziv (64 + 392 * h) /\
    zeta2 = ziv (32 + 392 * h) /\ zeta3 = ziv (96 + 392 * h)).
  + by auto => &hr |> *; rewrite /ziv.
  seq 8 : (#{/~{r0,r1,r2,r3,r4,r5,r6,r7}}pre /\
    rfinv (pk _rp) h ip1 [r0; r1; r2; r3; r4; r5; r6; r7]).
  + auto => &hr |> 2? hdone hrest _ hlt.
    have := rfinv_ldo (pk _rp) rp{hr} i{hr} ip1
      [256 * i{hr}; 32 + 256 * i{hr}; 64 + 256 * i{hr}; 96 + 256 * i{hr};
       128 + 256 * i{hr}; 160 + 256 * i{hr}; 192 + 256 * i{hr}; 224 + 256 * i{hr}] _ _ _ _.
    * smt().
    * done.
    * by move=> m rgm; have [|[|[|[|[|[|[|]]]]]]] ->> : m = 0 \/ m = 1 \/ m = 2 \/ m = 3 \/
        m = 4 \/ m = 5 \/ m = 6 \/ m = 7 by smt().
    * move=> j rgj; rewrite hrest 1:/# /pk initiE /=.
      - have [_ [hsz /List.allP hp]] := ip_props ip1 _; first by left.
        by have /= := hp (nth 0 ip1 j) _; [rewrite mem_nth hsz | smt()].
      by rewrite ip1_load //#.
    by move=> /=.
  (* level 1 *)
  seq 1 : (#{/~{r0,r1,r2,r3,r4,r5,r6,r7}}pre /\
    rfinv (iv1 (pk _rp)) h ip1 [r0; r1; r2; r3; r4; r5; r6; r7]).
  + ecall (ibutterfly64x_h r0 r1 r4 r5 r2 r3 r6 r7 zeta0 zeta1 zeta2 zeta3).
    auto => &hr |> ge0 _ _ _ hlt hinv.
    have := ilvl1 _ _ _ _ hinv; first smt().
    by rewrite /iv1 /rfibf /mkseq -iotaredE /= /zsel /=.
  (* level 2 *)
  seq 1 : (#pre /\ vx16 = vx16v); first by auto => &hr |> *; exact vx16vE.
  seq 2 : (#{/~{zeta0,zeta1}}pre /\ zeta0 = ziv (128 + 392 * h) /\ zeta1 = ziv (160 + 392 * h)).
  + by auto => &hr |> *; rewrite /ziv.
  seq 4 : (#{/~{r0,r1,r2,r3,r4,r5,r6,r7}}pre /\
    rfinv (redat (iv1 (pk _rp)) S1) h ip1 [r0; r1; r2; r3; r4; r5; r6; r7]).
  + ecall (red16x_h r5); ecall (red16x_h r4); ecall (red16x_h r1); ecall (red16x_h r0).
    auto => &hr |> ge0 _ _ _ hlt hinv.
    have := rfinv_redp _ _ ip1 [0;1;4;5] _ _ _ hinv; [by left | smt() |].
    by rewrite /rfred /mkseq -iotaredE /=.
  seq 1 : (#{/~{r0,r1,r2,r3,r4,r5,r6,r7}}pre /\
    rfinv (iv2 (pk _rp)) h ip1 [r0; r1; r2; r3; r4; r5; r6; r7]).
  + ecall (ibutterfly64x_h r0 r1 r2 r3 r4 r5 r6 r7 zeta0 zeta0 zeta1 zeta1).
    auto => &hr |> ge0 _ _ _ hlt hinv.
    have := ilvl2 _ _ _ _ hinv; first smt().
    by rewrite /iv2 /rfibf /mkseq -iotaredE /= /zsel /=.
  (* level 3 *)
  swap [5..6] -4.
  seq 2 : (#{/~{zeta0,zeta1}}pre /\ zeta0 = ziv (192 + 392 * h) /\
    zeta1 = ziv (224 + 392 * h)).
  + by auto => &hr |> *; rewrite /ziv.
  seq 5 : (#{/~{r0,r1,r2,r3,r4,r5,r6,r7}}pre /\
    rfinv (ireduce_level (iv2 (pk _rp)) 3) h ip3 [r0; r1; r2; r3; r4; r5; r6; r7]).
  + ecall (ibutterfly64x_h r0 r2 r4 r6 r1 r3 r5 r7 zeta0 zeta0 zeta1 zeta1).
    ecall (shuffle1_h r6 r7); ecall (shuffle1_h r4 r5);
    ecall (shuffle1_h r2 r3); ecall (shuffle1_h r0 r1).
    auto => &hr |> ge0 _ _ _ hlt hinv.
    have := ilvl3 _ _ _ _ hinv; first smt().
    by rewrite /rfibf /rfshuf /mkseq -iotaredE /= /zsel /=.
  seq 1 : (#{/~{r0,r1,r2,r3,r4,r5,r6,r7}}pre /\
    rfinv (iv3 (pk _rp)) h ip3 [r0; r1; r2; r3; r4; r5; r6; r7]).
  + ecall (red16x_h r0); auto => &hr |> ge0 _ _ _ hlt hinv.
    have := rfinv_redp _ _ ip3 [0] _ _ _ hinv; [smt() | smt() |].
    by rewrite /iv3 /rfred /mkseq -iotaredE /=.
  (* level 4 *)
  swap [5..6] -4.
  seq 2 : (#{/~{zeta0,zeta1}}pre /\ zeta0 = ziv (256 + 392 * h) /\
    zeta1 = ziv (288 + 392 * h)).
  + by auto => &hr |> *; rewrite /ziv.
  seq 5 : (#{/~{r0,r1,r2,r3,r4,r5,r6,r7}}pre /\
    rfinv (ireduce_level (iv3 (pk _rp)) 4) h ip4 [r0; r1; r2; r3; r4; r5; r6; r7]).
  + ecall (ibutterfly64x_h r0 r4 r1 r5 r2 r6 r3 r7 zeta0 zeta0 zeta1 zeta1).
    ecall (shuffle2_h r5 r7); ecall (shuffle2_h r1 r3);
    ecall (shuffle2_h r4 r6); ecall (shuffle2_h r0 r2).
    auto => &hr |> ge0 _ _ _ hlt hinv.
    have := ilvl4 _ _ _ _ hinv; first smt().
    by rewrite /rfibf /rfshuf /mkseq -iotaredE /= /zsel /=.
  seq 1 : (#{/~{r0,r1,r2,r3,r4,r5,r6,r7}}pre /\
    rfinv (iv4 (pk _rp)) h ip4 [r0; r1; r2; r3; r4; r5; r6; r7]).
  + ecall (red16x_h r0); auto => &hr |> ge0 _ _ _ hlt hinv.
    have := rfinv_redp _ _ ip4 [0] _ _ _ hinv; [smt() | smt() |].
    by rewrite /iv4 /rfred /mkseq -iotaredE /=.
  (* level 5 *)
  swap [5..6] -4.
  seq 2 : (#{/~{zeta0,zeta1}}pre /\ zeta0 = ziv (320 + 392 * h) /\
    zeta1 = ziv (352 + 392 * h)).
  + by auto => &hr |> *; rewrite /ziv.
  seq 5 : (#{/~{r0,r1,r2,r3,r4,r5,r6,r7}}pre /\
    rfinv (ireduce_level (iv4 (pk _rp)) 5) h ip5 [r0; r1; r2; r3; r4; r5; r6; r7]).
  + ecall (ibutterfly64x_h r0 r1 r2 r3 r4 r5 r6 r7 zeta0 zeta0 zeta1 zeta1).
    ecall (shuffle4_h r3 r7); ecall (shuffle4_h r2 r6);
    ecall (shuffle4_h r1 r5); ecall (shuffle4_h r0 r4).
    auto => &hr |> ge0 _ _ _ hlt hinv.
    have := ilvl5 _ _ _ _ hinv; first smt().
    by rewrite /rfibf /rfshuf /mkseq -iotaredE /= /zsel /=.
  seq 1 : (#{/~{r0,r1,r2,r3,r4,r5,r6,r7}}pre /\
    rfinv (iv5 (pk _rp)) h ip5 [r0; r1; r2; r3; r4; r5; r6; r7]).
  + ecall (red16x_h r0); auto => &hr |> ge0 _ _ _ hlt hinv.
    have := rfinv_redp _ _ ip5 [0] _ _ _ hinv; [smt() | smt() |].
    by rewrite /iv5 /rfred /mkseq -iotaredE /=.
  (* level 6 *)
  swap [5..6] -4.
  seq 2 : (#{/~{zeta0,zeta1}}pre /\ zeta0 = zib (384 + 392 * h) /\
    zeta1 = zib (388 + 392 * h)).
  + by auto => &hr |> *; rewrite /zib.
  seq 5 : (#{/~{r0,r1,r2,r3,r4,r5,r6,r7}}pre /\
    rfinv (ireduce_level (iv5 (pk _rp)) 6) h ip6 [r0; r1; r2; r3; r4; r5; r6; r7]).
  + ecall (ibutterfly64x_h r0 r2 r4 r6 r1 r3 r5 r7 zeta0 zeta0 zeta1 zeta1).
    ecall (shuffle8_h r6 r7); ecall (shuffle8_h r4 r5);
    ecall (shuffle8_h r2 r3); ecall (shuffle8_h r0 r1).
    auto => &hr |> ge0 _ _ _ hlt hinv.
    have := ilvl6 _ _ _ _ hinv; first smt().
    by rewrite /rfibf /rfshuf /mkseq -iotaredE /= /zsel /=.
  seq 1 : (#{/~{r0,r1,r2,r3,r4,r5,r6,r7}}pre /\
    rfinv (iv6 (pk _rp)) h ip6 [r0; r1; r2; r3; r4; r5; r6; r7]).
  + ecall (red16x_h r0); auto => &hr |> ge0 _ _ _ hlt hinv.
    have := rfinv_redp _ _ ip6 [0] _ _ _ hinv; [smt() | smt() |].
    by rewrite /iv6 /rfred /mkseq -iotaredE /=.
  (* the stores: blocks 0 .. 7 of half 0, blocks 12 .. 15 of half 1     *)
  if.
  + auto => &hr |> hdone hrest hinv; rewrite !stoE //=.
    have hst : forall j, 0 <= j < 256 =>
        (st (st (st (st (st (st (st (st rp{hr} 0 r0{hr}) 1 r2{hr}) 2 r4{hr}) 3 r6{hr})
           4 r1{hr}) 5 r3{hr}) 6 r5{hr}) 7 r7{hr}).[j]
      = if j < 128 then (iv6 (pk _rp)).[j] else rp{hr}.[j].
    - move=> j rgj; have /= -> := st8E rp{hr} (iv6 (pk _rp)) 0 j r0{hr} r4{hr} r1{hr} r5{hr}
        r2{hr} r6{hr} r3{hr} r7{hr} _ rgj (ip6_lanes _ _ _ _ _ _ _ _ _ _ hinv) => //.
      by congr; smt().
    split=> [j 3? | j 2?]; rewrite hst 1:/#; first by rewrite ifT /#.
    by rewrite ifF 1:/# hrest /#.
  auto => &hr |> ge0 _ hdone _ hlt hinv ne0; have ->> : i{hr} = 1 by smt().
  rewrite !stoE //= -/(stl rp{hr} [12;13;14;15] [r1{hr}; r3{hr}; r5{hr}; r7{hr}]).
  have hl := ip6_lanes _ _ _ _ _ _ _ _ _ _ hinv.
  have hst : forall j, 0 <= j < 256 =>
      (stl rp{hr} [12;13;14;15] [r1{hr}; r3{hr}; r5{hr}; r7{hr}]).[j]
    = if j %/ 16 \in [12;13;14;15] then (iv6 (pk _rp)).[j] else rp{hr}.[j].
  - move=> j rgj; apply stl_lanes => //.
    move=> k l rgk rgl; have := hl (k + 4) l _ rgl; first smt().
    by have [|[|[|]]] ->> : k = 0 \/ k = 1 \/ k = 2 \/ k = 3 by smt().
  split=> [j 3? | ]; first by rewrite hst 1:/#; case: (j %/ 16 \in [12;13;14;15]) => //#.
  split=> [/# | k l 4?]; have := hl k l _ _; 1,2: smt().
  by have [|[|[|]]] ->> /= : k = 0 \/ k = 1 \/ k = 2 \/ k = 3 by smt().
(* level 7, fused with the scaling by F, one quarter per iteration     *)
seq 3 : (#pre /\ i = 0 /\ zeta0 = zib 784 /\ zeta1 = zib 788).
- by auto => &hr |> *; rewrite /zib.
while (0 <= i <= 2 /\ qx16 = qx16v /\ zeta0 = zib 784 /\ zeta1 = zib 788 /\
  (forall j, 0 <= j < 256 => !(i = 0 /\ 128 <= j < 192) =>
     rp.[j] = if j %% 128 < 64 * i then (invres _rp).[j] else (iv6 (pk _rp)).[j]) /\
  (i = 0 => forall k l, 0 <= k < 4 => 0 <= l < 16 =>
     nth W256.zero [r0; r2; r4; r6] k \bits16 l = (iv6 (pk _rp)).[128 + 16 * k + l]));
  last first.
- auto => &hr |> hlo hhi hreg; split.
  + by move=> j 3?; case: (j < 128) => hj; [rewrite hlo /# | rewrite hhi /#].
  move=> i0 4? rp0 3? h1 _; have ->> : i0 = 2 by smt().
  by apply Array256.ext_eq => j rgj; rewrite h1 // ifT /#.
exlim i => h.
seq 5 : (0 <= h < 2 /\ i = h /\ qx16 = qx16v /\ zeta0 = zib 784 /\ zeta1 = zib 788 /\
  (forall j, 0 <= j < 256 => !(h = 0 /\ 128 <= j < 192) =>
     rp.[j] = if j %% 128 < 64 * h then (invres _rp).[j] else (iv6 (pk _rp)).[j]) /\
  (forall k l, 0 <= k < 4 => 0 <= l < 16 =>
       nth W256.zero [r0; r1; r2; r3] k \bits16 l = (iv6 (pk _rp)).[64 * h + 16 * k + l]
    /\ nth W256.zero [r4; r5; r6; r7] k \bits16 l
       = (iv6 (pk _rp)).[128 + 64 * h + 16 * k + l])).
- if.
  + auto => &hr |> hm hreg k l 4?; split; last by apply hreg.
    have [|[|[|]]] ->> /= : k = 0 \/ k = 1 \/ k = 2 \/ k = 3 by smt().
    * by rewrite ldoE 1..4:/# hm 1,2:/#; smt().
    * by rewrite ldoE 1..4:/# hm 1,2:/#; smt().
    * by rewrite ldoE 1..4:/# hm 1,2:/#; smt().
    by rewrite ldoE 1..4:/# hm 1,2:/#; smt().
  auto => &hr |> 2? hm _ hlt ne0 k l 4?; have ->> /= : i{hr} = 1 by smt().
  have [|[|[|]]] ->> /= : k = 0 \/ k = 1 \/ k = 2 \/ k = 3 by smt().
  + by split; (rewrite ldoE 1..4:/# hm 1,2:/#; smt()).
  + by split; (rewrite ldoE 1..4:/# hm 1,2:/#; smt()).
  + by split; (rewrite ldoE 1..4:/# hm 1,2:/#; smt()).
  by split; (rewrite ldoE 1..4:/# hm 1,2:/#; smt()).
seq 1 : (#{/~{r0,r1,r2,r3,r4,r5,r6,r7}}pre /\
  (forall k l, 0 <= k < 4 => 0 <= l < 16 =>
       nth W256.zero [r0; r1; r2; r3] k \bits16 l
       = (iv6 (pk _rp)).[64 * h + 16 * k + l] + (iv6 (pk _rp)).[128 + 64 * h + 16 * k + l]
    /\ nth W256.zero [r4; r5; r6; r7] k \bits16 l
       = (invres _rp).[128 + 64 * h + 16 * k + l])).
- ecall (ibutterfly64x_h r0 r1 r2 r3 r4 r5 r6 r7 zeta0 zeta0 zeta1 zeta1).
  auto => &hr |> 2? _ hl k l 4?.
  have -> : (invres _rp).[128 + 64 * i{hr} + 16 * k + l]
          = mmr16 ((iv6 (pk _rp)).[64 * i{hr} + 16 * k + l]
                   - (iv6 (pk _rp)).[128 + 64 * i{hr} + 16 * k + l]) (tw16 (izv 7 0 * F)).
  - rewrite /invres /ilast initiE 1:/# /= ifF 1:/#.
    by rewrite (: 128 + 64 * i{hr} + 16 * k + l - 128 = 64 * i{hr} + 16 * k + l) 1:#ring.
  have := hl k l _ _; 1,2: smt().
  have [|[|[|]]] ->> /= : k = 0 \/ k = 1 \/ k = 2 \/ k = 3 by smt().
  + by move=> [h0 h4]; rewrite iaddlb // isublb // h0 h4 z7E.
  + by move=> [h0 h4]; rewrite iaddlb // isublb // h0 h4 z7E.
  + by move=> [h0 h4]; rewrite iaddlb // isublb // h0 h4 z7E.
  by move=> [h0 h4]; rewrite iaddlb // isublb // h0 h4 z7E.
seq 2 : (#pre /\ flox16 = flov /\ fhix16 = fhiv).
- by auto => &hr |> *; rewrite /flov /fhiv.
wp; ecall (fqmulprecomp16x_h r3 flox16 fhix16); ecall (fqmulprecomp16x_h r2 flox16 fhix16).
ecall (fqmulprecomp16x_h r1 flox16 fhix16); ecall (fqmulprecomp16x_h r0 flox16 fhix16).
auto => &hr |> ge0 lt2 hm hl.
have hw : forall k l, 0 <= k < 4 => 0 <= l < 16 =>
     nth W256.zero [scl r0{hr} flov fhiv; scl r1{hr} flov fhiv;
                    scl r2{hr} flov fhiv; scl r3{hr} flov fhiv] k \bits16 l
     = (invres _rp).[64 * i{hr} + 16 * k + l]
  /\ nth W256.zero [r4{hr}; r5{hr}; r6{hr}; r7{hr}] k \bits16 l
     = (invres _rp).[128 + 64 * i{hr} + 16 * k + l].
- move=> k l rgk rgl; have [h0 h4] := hl k l rgk rgl; split; last exact h4.
  have -> : (invres _rp).[64 * i{hr} + 16 * k + l]
          = mmr16 ((iv6 (pk _rp)).[64 * i{hr} + 16 * k + l]
                   + (iv6 (pk _rp)).[128 + 64 * i{hr} + 16 * k + l]) (tw16 F).
  + rewrite /invres /ilast initiE 1:/# /= ifT 1:/#.
    by rewrite (: 64 * i{hr} + 16 * k + l + 128 = 128 + 64 * i{hr} + 16 * k + l) 1:#ring.
  rewrite -h0 -(fE l) //.
  by (have [|[|[|]]] ->> /= : k = 0 \/ k = 1 \/ k = 2 \/ k = 3 by smt()); rewrite sclb.
have [] ->> /= : i{hr} = 0 \/ i{hr} = 1 by smt().
- rewrite !stoE //= => j 2?.
  have /= -> := st8qE rp{hr} (invres _rp) 0 j _ _ _ _ _ _ _ _ _ _ hw => //.
  by case: (j %% 128 %/ 64 = 0) => hj; [rewrite ifT /# | rewrite hm /#].
rewrite !stoE //= => j 2?.
have /= -> := st8qE rp{hr} (invres _rp) 1 j _ _ _ _ _ _ _ _ _ _ hw => //.
by case: (j %% 128 %/ 64 = 1) => hj; [rewrite ifT /# | rewrite hm /#].
qed.

(* ==================================================================== *)
(* The value of the computation                                         *)
(* ==================================================================== *)
(* the reduced positions, in closed form *)
lemma S1E (i : int) : S1 i = (i %% 4 < 2).
proof.
rewrite /S1 /redS (: i %% 4 = i %% 128 %% 4) 1:#smt:(modz_dvd).
have : 0 <= i %% 128 < 128 by smt().
move: (i %% 128) => x; move: x; apply/allP_range.
by rewrite /ip1 -iotaredE; with hint +listred (cbv delta).
qed.

lemma S3E (i : int) : S3 i = (i %% 16 < 2).
proof.
rewrite /S3 /redS (: i %% 16 = i %% 128 %% 16) 1:#smt:(modz_dvd) .
have : 0 <= i %% 128 < 128 by smt().
move: (i %% 128) => x; move: x; apply/allP_range.
by rewrite /ip3 -iotaredE; with hint +listred (cbv delta).
qed.

lemma S4E (i : int) : S4 i = (i %% 32 < 4).
proof.
rewrite /S4 /redS (: i %% 32 = i %% 128 %% 32) 1:#smt:(modz_dvd) .
have : 0 <= i %% 128 < 128 by smt().
move: (i %% 128) => x; move: x; apply/allP_range.
by rewrite /ip4 -iotaredE; with hint +listred (cbv delta).
qed.

lemma S5E (i : int) : S5 i = (i %% 64 < 8).
proof.
rewrite /S5 /redS (: i %% 64 = i %% 128 %% 64) 1:#smt:(modz_dvd) .
have : 0 <= i %% 128 < 128 by smt().
move: (i %% 128) => x; move: x; apply/allP_range.
by rewrite /ip5 -iotaredE; with hint +listred (cbv delta).
qed.

lemma S6E (i : int) : S6 i = (i %% 128 < 16).
proof.
rewrite /S6 /redS.
have : 0 <= i %% 128 < 128 by smt().
move: (i %% 128) => x; move: x; apply/allP_range.
by rewrite /ip6 -iotaredE; with hint +listred (cbv delta).
qed.

(* -------------------------------------------------------------------- *)
(* bounds, position by position: a reduction resets below 2q            *)
op rb (S : int -> bool) (b : int -> int) (i : int) : int = if S i then 2 * 3329 else b i.

op b0 (i : int) : int = 4 * 3329.
op b1 = rb (fun i => i %% 4 < 2) (ibnd 1 b0).
op b2 = ibnd 2 b1.
op b3 = rb (fun i => i %% 16 < 2) (ibnd 3 b2).
op b4 = rb (fun i => i %% 32 < 4) (ibnd 4 b3).
op b5 = rb (fun i => i %% 64 < 8) (ibnd 5 b4).
op b6 = rb (fun i => i %% 128 < 16) (ibnd 6 b5).

(* the merges of level k stay below 2^15 *)
op chk (k : int) (b : int -> int) =
  all (fun i => i %% 2^(k+1) < 2^k => b i + b (i + 2^k) < 2^15) (iota_ 0 256).

lemma chk1 : chk 1 b0.
proof.
by rewrite /chk -iotaredE; cbv delta.
qed.

lemma chk2 : chk 2 b1.
proof.
by rewrite /chk -iotaredE; cbv delta.
qed.

lemma chk3 : chk 3 b2.
proof.
by rewrite /chk -iotaredE; cbv delta.
qed.

lemma chk4 : chk 4 b3.
proof.
by rewrite /chk -iotaredE; cbv delta.
qed.

lemma chk5 : chk 5 b4.
proof.
by rewrite /chk -iotaredE; cbv delta.
qed.

lemma chk6 : chk 6 b5.
proof.
by rewrite /chk -iotaredE; cbv delta.
qed.

lemma chk7 : chk 7 b6.
proof.
by rewrite /chk -iotaredE; cbv delta.
qed.

lemma chkP (k : int) (b : int -> int) : 0 <= k < 8 => chk k b =>
  forall j t, 0 <= j < 2^(7-k) => 0 <= t < 2^k =>
    b (j * 2^(k+1) + t) + b (j * 2^(k+1) + 2^k + t) < 2^15.
proof.
move=> rgk /List.allP hc j t rgj rgt; have gt0k := expr_gt0 k 2 _ => //.
have e256 : 2^(7-k) * 2^(k+1) = 256.
- by rewrite -exprD_nneg 1,2:/# (: 7 - k + (k+1) = 8) 1:/#.
have eSk : 2^(k+1) = 2 * 2^k by rewrite exprS 1:/#.
have hlt : j * 2^(k+1) + t < 256.
- have : (j + 1) * 2^(k+1) <= 2^(7-k) * 2^(k+1) by apply ler_pmul2r; smt().
  by smt().
have := hc (j * 2^(k+1) + t) _; first by rewrite mem_iota; smt().
rewrite /= modzMDl pmod_small 1:/# => h; have := h _; first smt().
by rewrite (: j * 2^(k+1) + t + 2^k = j * 2^(k+1) + 2^k + t) 1:#ring.
qed.

lemma redat_cgr (P : wpoly) (S : int -> bool) (i : int) : 0 <= i < 256 =>
  W16.to_sint (redat P S).[i] %% 3329 = W16.to_sint P.[i] %% 3329.
proof.
move=> rgi; rewrite /redat initiE //=.
by case: (S i) => // _; have [] := sbred16P P.[i].
qed.

(* one level: the residue of the next level, and the bounds *)
lemma lvl_step (p v : wpoly) (k : int) (b : int -> int) :
  1 <= k < 8 => chk k b => icgr p v k =>
  (forall i, 0 <= i < 256 => `|W16.to_sint v.[i]| <= b i) =>
     icgr p (ireduce_level v k) (k + 1)
  /\ forall i, 0 <= i < 256 => `|W16.to_sint (ireduce_level v k).[i]| <= ibnd k b i.
proof.
move=> rgk hc hv hb; have hw := chkP k b _ hc; first smt().
split; last by apply ireduce_level_bnd => //#.
by apply icgr_step => //; apply (novf_bnd v k b) => //#.
qed.

(* the reductions after a level *)
lemma red_step (p v : wpoly) (k : int) (S S' : int -> bool) (b : int -> int) :
  0 <= k <= 8 => (forall i, S i = S' i) => icgr p v k =>
  (forall i, 0 <= i < 256 => `|W16.to_sint v.[i]| <= b i) =>
     icgr p (redat v S) k
  /\ forall i, 0 <= i < 256 => `|W16.to_sint (redat v S).[i]| <= rb S' b i.
proof.
move=> rgk hS hv hb; split.
- by apply (icgr_cgr p v) => // i rgi; apply redat_cgr.
move=> i rgi; rewrite /redat initiE //= /rb hS.
case: (S' i) => _; last by apply hb.
by have [_ ?] := sbred16P v.[i]; smt().
qed.

lemma pkidx_rg (i : int) : 0 <= i < 256 => 0 <= nth 0 pkidx i < 256.
proof.
by move: i; apply/allP_range; rewrite /pkidx -iotaredE; with hint +listred (cbv delta).
qed.

(* the result: 2^16 times the inverse transform, below q *)
lemma invres_val (r p : wpoly) :
  (forall i, 0 <= i < 256 => `|W16.to_sint r.[i]| <= 4 * 3329) => icgr p (pk r) 1 =>
     (forall i, 0 <= i < 256 =>
        W16.to_sint (invres r).[i] %% 3329 = (2^16 * W16.to_sint p.[i]) %% 3329)
  /\ (forall i, 0 <= i < 256 => `|W16.to_sint (invres r).[i]| < 3329).
proof.
move=> hr hv1; pose v := pk r.
have hb0 : forall i, 0 <= i < 256 => `|W16.to_sint v.[i]| <= b0 i.
- by move=> i rgi; rewrite /v /pk initiE //= /b0; apply/hr/pkidx_rg.
(* levels 1 .. 6, with their reductions, then level 7 *)
have [c2 h2] := lvl_step p v 1 b0 _ chk1 hv1 hb0 => //.
have [c2' h2'] := red_step _ _ 2 S1 (fun i => i %% 4 < 2) _ _ S1E c2 h2 => //.
have [c3 h3] := lvl_step _ _ 2 b1 _ chk2 c2' h2' => //.
have [c4 h4] := lvl_step _ _ 3 b2 _ chk3 c3 h3 => //.
have [c4' h4'] := red_step _ _ 4 S3 (fun i => i %% 16 < 2) _ _ S3E c4 h4 => //.
have [c5 h5] := lvl_step _ _ 4 b3 _ chk4 c4' h4' => //.
have [c5' h5'] := red_step _ _ 5 S4 (fun i => i %% 32 < 4) _ _ S4E c5 h5 => //.
have [c6 h6] := lvl_step _ _ 5 b4 _ chk5 c5' h5' => //.
have [c6' h6'] := red_step _ _ 6 S5 (fun i => i %% 64 < 8) _ _ S5E c6 h6 => //.
have [c7 h7] := lvl_step _ _ 6 b5 _ chk6 c6' h6' => //.
have [c7' h7'] := red_step _ _ 7 S6 (fun i => i %% 128 < 16) _ _ S6E c7 h7 => //.
have [c8 _] := lvl_step _ _ 7 b6 _ chk7 c7' h7' => //.
(* the last level is level 7 of the tree, times F *)
pose V := iv6 v; pose W := ireduce_level V 7.
have hW : forall t, 0 <= t < 128 =>
     W.[t] = V.[t] + V.[t + 128]
  /\ W.[t + 128] = mmr16 (V.[t] - V.[t + 128]) (tw16 (izv 7 0)).
- move=> t rgt; have [e1 e2] := ireduce_leveliE V 7 0 t _ _ _; 1..3: smt().
  by move: e1 e2 => /=; rewrite (addzC 128 t) => e1 e2; rewrite /W e1 e2.
have hres : forall i, 0 <= i < 256 =>
     W16.to_sint (invres r).[i] %% 3329 = ((W16.to_sint W.[i] %% 3329) * F) %% 3329
  /\ `|W16.to_sint (invres r).[i]| < 3329.
- move=> i rgi; rewrite /invres -/v -/V /ilast initiE //=.
  case: (i < 128) => hi.
  + have [-> _] := hW i _; first smt().
    by rewrite mmr_cgr modzMml mmr_bnd.
  have [_] := hW (i - 128) _; first smt().
  rewrite (: i - 128 + 128 = i) 1:#ring => ->.
  by rewrite mmr_cgr mmr_cgr modzMml mulrA mmr_bnd.
split=> i rgi; have [r1 r2] := hres i rgi => //.
rewrite r1 (icgr_top p W i c8 rgi) modzMml /F (: 2^(8-1) = 128) //.
rewrite (: 2^16 = 65536) //.
by rewrite (: 128 * W16.to_sint p.[i] * 512 = 65536 * W16.to_sint p.[i]) 1:#ring.
qed.
