(**
  The AVX2 forward NTT of ML-KEM, level by level, against the generic
  Cooley-Tukey tree (`NttKem`: `reduce_level`, `reduce_tree`).

  The code keeps a half polynomial (128 coefficients) in eight
  registers across levels 6 .. 1, with lane shuffles in between.  The
  invariant `rfinv` reads the registers, lane by lane, through a
  position table: lane l of register m holds coefficient
  128 h + pos.[16 m + l] of the current tree state.  A shuffle permutes
  the table (`shuf_inv`); a butterfly call is one level of the tree,
  provided a decidable check on the table and on the twiddle lanes
  holds (`bf_inv`).
*)

require import AllCore List Int IntDiv StdOrder.
from Jasmin require import JModel_x86.
from JazzEC require import Array16 Array256 Array400 WArray32 WArray512 WArray800.
require import Montgomery16 MLKEMFCLib NttKem.
require import JkemConstants.
require BaseT.

abstract theory MLKEM_ntt_levelsT.

clone import BaseT.BaseT as B.
import R.

(* ==================================================================== *)

(*---*) import IntOrder.

(* ==================================================================== *)
(* Lanes                                                                *)
(* ==================================================================== *)
(* lane-wise butterfly halves: a + mmr16 b z and a - mmr16 b z          *)
op [opaque] addl (a b zl zh : W256.t) : W256.t =
  W16u16.pack16 (mkseq (fun l =>
    (a \bits16 l) + mmr16 (b \bits16 l) (zl \bits16 l, zh \bits16 l)) 16).

op [opaque] subl (a b zl zh : W256.t) : W256.t =
  W16u16.pack16 (mkseq (fun l =>
    (a \bits16 l) - mmr16 (b \bits16 l) (zl \bits16 l, zh \bits16 l)) 16).

op [opaque] qx16v : W256.t = W16u16.pack16 (nseq 16 (W16.of_int 3329)).

lemma bits16_qx16v (l : int) : 0 <= l < 16 => qx16v \bits16 l = W16.of_int 3329.
proof. by move=> rgl; rewrite /qx16v pack16bE // W16u16.Pack.get_of_list // nth_nseq. qed.

lemma addlE (a b zl zh : W256.t) :
    VPSUB_16u16 (VPADD_16u16 (VPMULH_16u16 zh b) a)
      (VPMULH_16u16 (VPMULL_16u16 zl b) qx16v)
  = addl a b zl zh.
proof.
apply W16u16.wordP => l rgl; rewrite /addl pack16bE // W16u16.Pack.get_of_list // nth_mkseq //=.
rewrite /VPSUB_16u16 /VPADD_16u16 /VPMULH_16u16 /VPMULL_16u16 !map2bE //=.
by rewrite bits16_qx16v // /mmr16 /=; ring.
qed.

lemma sublE (a b zl zh : W256.t) :
    VPADD_16u16 (VPMULH_16u16 (VPMULL_16u16 zl b) qx16v)
      (VPSUB_16u16 a (VPMULH_16u16 zh b))
  = subl a b zl zh.
proof.
apply W16u16.wordP => l rgl; rewrite /subl pack16bE // W16u16.Pack.get_of_list // nth_mkseq //=.
rewrite /VPSUB_16u16 /VPADD_16u16 /VPMULH_16u16 /VPMULL_16u16 !map2bE //=.
by rewrite bits16_qx16v // /mmr16 /=; ring.
qed.

hoare butterfly64x_h (rl0 rl1 rl2 rl3 rh0 rh1 rh2 rh3 zl0 zl1 zh0 zh1 : W256.t) :
  M.__butterfly64x :
    arg = (rl0, rl1, rl2, rl3, rh0, rh1, rh2, rh3, zl0, zl1, zh0, zh1, qx16v)
  ==>
    res = (addl rl0 rh0 zl0 zh0, addl rl1 rh1 zl0 zh0,
           addl rl2 rh2 zl1 zh1, addl rl3 rh3 zl1 zh1,
           subl rl0 rh0 zl0 zh0, subl rl1 rh1 zl0 zh0,
           subl rl2 rh2 zl1 zh1, subl rl3 rh3 zl1 zh1).
proof.
by proc; auto => |>; rewrite !addlE !sublE.
qed.

(* -------------------------------------------------------------------- *)
(* the 32 lanes of a register pair, and their permutations              *)
op lane2 (a b : W256.t) (j : int) : W16.t =
  if j < 16 then a \bits16 j else b \bits16 (j - 16).

op [opaque] shl (idx : int list) (a b : W256.t) : W256.t =
  W16u16.pack16 (mkseq (fun l => lane2 a b (nth 0 idx l)) 16).

op [opaque] shh (idx : int list) (a b : W256.t) : W256.t =
  W16u16.pack16 (mkseq (fun l => lane2 a b (nth 0 idx (16 + l))) 16).

op sh8 = [0; 1; 2; 3; 4; 5; 6; 7; 16; 17; 18; 19; 20; 21; 22; 23;
          8; 9; 10; 11; 12; 13; 14; 15; 24; 25; 26; 27; 28; 29; 30; 31].

op sh4 = [0; 1; 2; 3; 16; 17; 18; 19; 8; 9; 10; 11; 24; 25; 26; 27;
          4; 5; 6; 7; 20; 21; 22; 23; 12; 13; 14; 15; 28; 29; 30; 31].

op sh2 = [0; 1; 16; 17; 4; 5; 20; 21; 8; 9; 24; 25; 12; 13; 28; 29;
          2; 3; 18; 19; 6; 7; 22; 23; 10; 11; 26; 27; 14; 15; 30; 31].

op sh1 = [0; 16; 2; 18; 4; 20; 6; 22; 8; 24; 10; 26; 12; 28; 14; 30;
          1; 17; 3; 19; 5; 21; 7; 23; 9; 25; 11; 27; 13; 29; 15; 31].

lemma allP_range (P : int -> bool) (n : int) :
  (forall k, 0 <= k < n => P k) <=> all P (iota_ 0 n).
proof.
split=> [h|/List.allP h k rgk]; last by apply h; rewrite mem_iota /#.
by apply/List.allP => k; rewrite mem_iota /#.
qed.

lemma bits64_shr32_bits16 (w : W256.t) (k i : int) :
  0 <= k < 4 => 0 <= i < 2 =>
  ((w \bits64 k) `>>>` 32) \bits16 i = w \bits16 (4 * k + 2 + i).
proof.
move=> rgk; move: i; rewrite allP_range.
move: k rgk; rewrite allP_range -!iotaredE /= => />.
by do split; apply W16.all_eq_eq; rewrite /all_eq /= /(`>>>`) /=.
qed.

lemma bits32_shl16_bits16H (w : W256.t) (k : int) :
  0 <= k < 8 => (w \bits32 k) `<<<` 16 \bits16 1 = w \bits16 (2 * k).
proof.
move: k; rewrite allP_range -!iotaredE /= => />.
by do split; apply W16.all_eq_eq; rewrite /all_eq /= /(`<<<`) /=.
qed.

lemma bits32_shr16_bits16L (w : W256.t) (k : int) :
  0 <= k < 8 => (w \bits32 k) `>>>` 16 \bits16 0 = w \bits16 (2 * k + 1).
proof.
move: k; rewrite allP_range -!iotaredE /= => />.
by do split; apply W16.all_eq_eq; rewrite /all_eq /= /(`>>>`) /=.
qed.

hoare shuffle8_h (a b : W256.t) :
  M.__shuffle8 : arg = (a, b) ==> res = (shl sh8 a b, shh sh8 a b).
proof.
proc; auto => |>; rewrite /shl /shh /=; split; apply W16u16.wordP; apply/allP_range;
  rewrite -iotaredE /= /VPERM2I128 /W8.int_bit /= !nth_mkseq //= /lane2 /sh8 /=.
qed.

hoare shuffle4_h (a b : W256.t) :
  M.__shuffle4 : arg = (a, b) ==> res = (shl sh4 a b, shh sh4 a b).
proof.
proc; auto => |>; rewrite /shl /shh /=; split; apply W16u16.wordP; apply/allP_range;
  rewrite -iotaredE /= /VPUNPCKL_4u64 /VPUNPCKH_4u64 /VPUNPCKL_2u64 /VPUNPCKH_2u64;
  rewrite /interleave_gen /get_lo_2u64 /get_hi_2u64 /= !nth_mkseq //= /lane2 /sh4 /=.
qed.

hoare shuffle2_h (a b : W256.t) :
  M.__shuffle2 : arg = (a, b) ==> res = (shl sh2 a b, shh sh2 a b).
proof.
proc; auto => |>; rewrite /shl /shh /=; split; apply W16u16.wordP; apply/allP_range;
  rewrite -iotaredE /= /VPBLENDD_256 /VMOVSLDUP_256 /VMOVSLDUP_128 /VPSRL_4u64 /=;
  do 2! rewrite /W8.int_bit /= ?bits64_shr32_bits16 //= !nth_mkseq //= /lane2 /sh2 /=.
qed.

hoare shuffle1_h (a b : W256.t) :
  M.__shuffle1 : arg = (a, b) ==> res = (shl sh1 a b, shh sh1 a b).
proof.
proc; auto => |>; rewrite /shl /shh /=; split; apply W16u16.wordP; apply/allP_range;
  rewrite -iotaredE /= /VPBLENDW_256 /VPBLENDW_128 /VPSLL_8u32 /VPSRL_8u32 /=;
  do 2! rewrite /W8.int_bit /= ?bits32_shl16_bits16H // ?bits32_shr16_bits16L //=
    !nth_mkseq //= /lane2 /sh1 /=.
qed.

(* -------------------------------------------------------------------- *)
op [opaque] vx16v : W256.t = W16u16.pack16 (nseq 16 (W16.of_int 20159)).

lemma load32E (f : int -> W16.t) (l : int) : 0 <= l < 16 =>
  get256_direct (WArray32.init16 f) 0 \bits16 l = f l.
proof.
move=> rgl; apply W16.wordP => b rgb.
rewrite bits16iE // /get256_direct pack32wE 1:/# W32u8.Pack.initiE 1:/# /=.
rewrite /WArray32.init16 WArray32.initiE 1:/# /= bits8iE 1:/#.
by congr; [congr|]; smt().
qed.

lemma qx16vE : get256_direct (WArray32.init16 (fun i => jqx16.[i])) 0 = qx16v.
proof.
apply W16u16.wordP => l rgl; rewrite load32E // bits16_qx16v //.
by move: l rgl; apply/allP_range; rewrite -iotaredE.
qed.

lemma vx16vE : get256_direct (WArray32.init16 (fun i => jvx16.[i])) 0 = vx16v.
proof.
apply W16u16.wordP => l rgl; rewrite load32E // /vx16v pack16bE //.
rewrite W16u16.Pack.get_of_list // nth_nseq //.
by move: l rgl; apply/allP_range; rewrite -iotaredE.
qed.

(* the final Barrett reduction, lane-wise *)
op [opaque] redl (r : W256.t) : W256.t =
  W16u16.pack16 (mkseq (fun l => sbred16 (r \bits16 l)) 16).

hoare red16x_h (r : W256.t) :
  M.__red16x : arg = (r, qx16v, vx16v) ==> res = redl r.
proof.
proc; auto => |>; apply W16u16.wordP => l rgl.
rewrite /redl pack16bE // W16u16.Pack.get_of_list // nth_mkseq //=.
rewrite /VPSUB_16u16 /VPMULL_16u16 /VPSRA_16u16 /VPMULH_16u16 !map2bE // mapbE // map2bE //=.
by rewrite bits16_qx16v // /vx16v pack16bE // W16u16.Pack.get_of_list // nth_nseq // /sbred16.
qed.

(* the reduction keeps the residue, and lands in [0, 2q) *)
lemma sbred16P (x : W16.t) :
     W16.to_sint (sbred16 x) %% 3329 = W16.to_sint x %% 3329
  /\ 0 <= W16.to_sint (sbred16 x) < 2 * 3329.
proof.
rewrite -sbred16_eq.
move: (SignedReductions_W16.BREDCp_corr (W16.to_sint x) 26 _ _ _ _ _ _).
+ by rewrite /SignedReductions_W16.R ?GFq.qE.
+ by rewrite /SignedReductions_W16.R ?GFq.qE.
+ by rewrite /SignedReductions_W16.R ?GFq.qE.
+ by rewrite /SignedReductions_W16.R ?GFq.qE.
+ by move: (W16.to_sint_cmp x); rewrite /SignedReductions_W16.R ?GFq.qE /= /#.
+ move=> n.
  by rewrite /barrett_pred /barrett_pred_low /barrett_pred_high
       /barrett_fun /barrett_fun_aux ?GFq.qE /SignedReductions_W16.R /= /#.
by rewrite GFq.qE.
qed.

(* the Montgomery product against a table pair, lane-wise *)
op [opaque] scl (b al ah : W256.t) : W256.t =
  W16u16.pack16 (mkseq (fun l => mmr16 (b \bits16 l) (al \bits16 l, ah \bits16 l)) 16).

hoare fqmulprecomp16x_h (b al ah : W256.t) :
  M.__fqmulprecomp16x : arg = (b, al, ah, qx16v) ==> res = scl b al ah.
proof.
proc; auto => |>; apply W16u16.wordP => l rgl.
rewrite /scl pack16bE // W16u16.Pack.get_of_list // nth_mkseq //=.
rewrite /VPSUB_16u16 /VPMULH_16u16 /VPMULL_16u16 !map2bE //=.
by rewrite bits16_qx16v.
qed.

lemma sclb (b al ah : W256.t) (l : int) : 0 <= l < 16 =>
  scl b al ah \bits16 l = mmr16 (b \bits16 l) (al \bits16 l, ah \bits16 l).
proof. by move=> rgl; rewrite /scl pack16bE // W16u16.Pack.get_of_list // nth_mkseq. qed.

(* ==================================================================== *)
(* The register file                                                    *)
(* ==================================================================== *)
(* lane i of eight registers: register i / 16, lane i mod 16            *)
op rfl (rf : W256.t list) (i : int) : W16.t =
  nth W256.zero rf (i %/ 16) \bits16 (i %% 16).

(* the registers hold half h of P, read through the position table      *)
op rfinv (P : wpoly) (h : int) (pos : int list) (rf : W256.t list) =
  forall i, 0 <= i < 128 => rfl rf i = P.[128 * h + nth 0 pos i].

lemma rflE (rf : W256.t list) (m l : int) :
  0 <= l < 16 => rfl rf (16 * m + l) = nth W256.zero rf m \bits16 l.
proof. by move=> rgl; rewrite /rfl; congr; [congr|]; smt(). qed.

(* -------------------------------------------------------------------- *)
(* a shuffle of registers x and y permutes the table                    *)
op src (x y j : int) : int = if j < 16 then 16 * x + j else 16 * y + (j - 16).

op rfshuf (idx : int list) (x y : int) (rf : W256.t list) : W256.t list =
  let a = nth W256.zero rf x in let b = nth W256.zero rf y in
  mkseq (fun m => if m = x then shl idx a b else if m = y then shh idx a b
                  else nth W256.zero rf m) 8.

op pshuf (idx : int list) (x y : int) (pos : int list) : int list =
  mkseq (fun i =>
    if i %/ 16 = x then nth 0 pos (src x y (nth 0 idx (i %% 16)))
    else if i %/ 16 = y then nth 0 pos (src x y (nth 0 idx (16 + i %% 16)))
    else nth 0 pos i) 128.

lemma shuf_inv (P : wpoly) (h : int) (pos : int list) (rf : W256.t list)
  (idx : int list) (x y : int) :
  0 <= x < 8 => 0 <= y < 8 => x <> y => all (fun j => 0 <= j < 32) idx =>
  rfinv P h pos rf => rfinv P h (pshuf idx x y pos) (rfshuf idx x y rf).
proof.
move=> rgx rgy nexy /List.allP hidx hinv i rgi.
have rgl : 0 <= i %% 16 < 16 by smt().
have lane : forall j, 0 <= j < 32 =>
  lane2 (nth W256.zero rf x) (nth W256.zero rf y) j = rfl rf (src x y j).
- by move=> j rgj; rewrite /lane2 /src; case: (j < 16) => ?; rewrite rflE //#.
have hsrc : forall j, 0 <= j < 32 => 0 <= src x y j < 128 by smt().
rewrite /rfl /rfshuf /pshuf /= nth_mkseq 1:/# nth_mkseq //= -/(rfl _ i).
case: (i %/ 16 = x) => [hx|nx].
- rewrite /shl pack16bE // W16u16.Pack.get_of_list // nth_mkseq //=.
  have hj : 0 <= nth 0 idx (i %% 16) < 32.
  + by case: (i %% 16 < size idx) => ?; [apply hidx; rewrite mem_nth /# | rewrite nth_out /#].
  by rewrite (lane _ hj) hinv //; apply/hsrc/hj.
case: (i %/ 16 = y) => [hy|ny].
- rewrite /shh pack16bE // W16u16.Pack.get_of_list // nth_mkseq //=.
  have hj : 0 <= nth 0 idx (16 + i %% 16) < 32.
  + case: (16 + i %% 16 < size idx) => ?; first by apply hidx; rewrite mem_nth /#.
    by rewrite nth_out /#.
  by rewrite (lane _ hj) hinv //; apply/hsrc/hj.
by rewrite -/(rfl rf i) hinv.
qed.

(* -------------------------------------------------------------------- *)
(* a butterfly call is one level of the tree: register a_m (m < 4) is   *)
(* paired with a_(m+4), under the twiddle lanes of zl_(m/2), zh_(m/2)   *)
op zsel (z0 z1 : W256.t) (m : int) : W256.t = if m < 2 then z0 else z1.

op rfbf (a : int list) (zl0 zl1 zh0 zh1 : W256.t) (rf : W256.t list) : W256.t list =
  let r = fun m => nth W256.zero rf (nth 0 a m) in
  mkseq (fun reg =>
    let m = index reg a in
    if m < 4 then addl (r m) (r (m + 4)) (zsel zl0 zl1 m) (zsel zh0 zh1 m)
    else subl (r (m - 4)) (r m) (zsel zl0 zl1 (m - 4)) (zsel zh0 zh1 (m - 4))) 8.

(* the pairing and the twiddles agree with level k of half h           *)
op bfok (k h : int) (a : int list) (zl0 zl1 zh0 zh1 : W256.t) (pos : int list) =
  all (fun i =>
    let m = i %/ 16 in let l = i %% 16 in
    let x = nth 0 pos (16 * nth 0 a m + l) in
    let y = nth 0 pos (16 * nth 0 a (m + 4) + l) in
    let g = 128 * h + x in
       0 <= x < 128 /\ y = x + 2^k /\ g %% 2^(k+1) < 2^k
    /\ (zsel zl0 zl1 m \bits16 l, zsel zh0 zh1 m \bits16 l)
       = tw16 (zpow (g %/ 2^(k+1) + 2^(7-k)))) (iota_ 0 64).

lemma bf_inv (P : wpoly) (h k : int) (pos : int list) (rf : W256.t list)
  (a : int list) (zl0 zl1 zh0 zh1 : W256.t) :
  0 <= h < 2 => 0 <= k < 8 => perm_eq a (iota_ 0 8) =>
  bfok k h a zl0 zl1 zh0 zh1 pos =>
  rfinv P h pos rf => rfinv (reduce_level P k) h pos (rfbf a zl0 zl1 zh0 zh1 rf).
proof.
move=> rgh rgk hperm /List.allP hok hinv i rgi.
have hsz : size a = 8 by rewrite (perm_eq_size _ _ hperm) size_iota.
have hmem : forall r, r \in a <=> 0 <= r < 8.
- by move=> r; rewrite (perm_eq_mem _ _ hperm) mem_iota.
have ha : forall m, 0 <= m < 8 => 0 <= nth 0 a m < 8.
- by move=> m rgm; rewrite -hmem mem_nth /#.
pose m := index (i %/ 16) a.
have rgm : 0 <= m < 8 by rewrite /m index_ge0 -hsz index_mem hmem /#.
have ham : nth 0 a m = i %/ 16 by rewrite /m nth_index // hmem /#.
have rgl : 0 <= i %% 16 < 16 by smt().
have hi : i = 16 * nth 0 a m + i %% 16 by rewrite ham /#.
(* the butterfly of level k at a coefficient g of a lower half-block *)
have hlvl : forall g, 0 <= g < 256 => g %% 2^(k+1) < 2^k =>
     (reduce_level P k).[g]
       = P.[g] + mmr16 P.[g + 2^k] (tw16 (zpow (g %/ 2^(k+1) + 2^(7-k))))
  /\ (reduce_level P k).[g + 2^k]
       = P.[g] - mmr16 P.[g + 2^k] (tw16 (zpow (g %/ 2^(k+1) + 2^(7-k)))).
- move=> g rgg hg; have gt0K : 0 < 2^(k+1) by apply expr_gt0.
  have e256 : 2^(7-k) * 2^(k+1) = 256.
  + by rewrite -exprD_nneg 1,2:/# (: 7 - k + (k+1) = 8) 1:/#.
  have rgJ : 0 <= g %/ 2^(k+1) < 2^(7-k) by rewrite divz_ge0 // ltz_divLR // e256 /#.
  have rgt : 0 <= g %% 2^(k+1) < 2^k by smt(modz_ge0).
  have := reduce_leveliE P k (g %/ 2^(k+1)) (g %% 2^(k+1)) _ rgJ rgt; first by smt().
  have e : g %/ 2^(k+1) * 2^(k+1) + 2^k + g %% 2^(k+1) = g + 2^k by smt(divz_eq).
  by rewrite e -divz_eq.
have hr : forall j, 0 <= j < 8 =>
    nth W256.zero rf (nth 0 a j) \bits16 (i %% 16)
  = P.[128 * h + nth 0 pos (16 * nth 0 a j + i %% 16)].
- by move=> j rgj; rewrite -rflE // hinv //; smt().
rewrite /rfl /rfbf /= nth_mkseq 1:/# /= -/m.
case: (m < 4) => hm.
- have := hok (16 * m + i %% 16) _; first by rewrite mem_iota /#.
  rewrite /= (: (16 * m + i %% 16) %/ 16 = m) 1:/#.
  rewrite (: (16 * m + i %% 16) %% 16 = i %% 16) 1:/#.
  move=> [rgx [hy [ht hz]]].
  rewrite /addl pack16bE // W16u16.Pack.get_of_list // nth_mkseq //= hz !hr 1,2:/# -hi hy.
  move: rgx ht; rewrite -hi => rgx ht.
  rewrite (: 128 * h + (nth 0 pos i + 2^k) = 128 * h + nth 0 pos i + 2^k) 1:#ring.
  by have [-> _] := hlvl (128 * h + nth 0 pos i) _ ht; smt().
have := hok (16 * (m - 4) + i %% 16) _; first by rewrite mem_iota /#.
rewrite /= (: (16 * (m - 4) + i %% 16) %/ 16 = m - 4) 1:/#.
rewrite (: (16 * (m - 4) + i %% 16) %% 16 = i %% 16) 1:/#.
rewrite (: m - 4 + 4 = m) 1:#ring -hi => -[rgx [hy [ht hz]]].
rewrite /subl pack16bE // W16u16.Pack.get_of_list // nth_mkseq //= hz !hr 1,2:/# -hi hy.
rewrite (: 128 * h + (nth 0 pos (16 * nth 0 a (m - 4) + i %% 16) + 2^k)
         = 128 * h + nth 0 pos (16 * nth 0 a (m - 4) + i %% 16) + 2^k) 1:#ring.
by have [_ ->] := hlvl _ _ ht; smt().
qed.

(* ==================================================================== *)
(* Memory                                                               *)
(* ==================================================================== *)
lemma load512E (f : int -> W16.t) (o l : int) :
  0 <= o => 2 * o + 32 <= 512 => 0 <= l < 16 =>
  get256_direct (WArray512.init16 f) (2 * o) \bits16 l = f (o + l).
proof.
move=> ge0o le512 rgl; apply W16.wordP => b rgb.
rewrite bits16iE // /get256_direct pack32wE 1:/# W32u8.Pack.initiE 1:/# /=.
rewrite /WArray512.init16 WArray512.initiE 1:/# /= bits8iE 1:/#.
by congr; [congr|]; smt().
qed.

lemma load800E (f : int -> W16.t) (o l : int) :
  0 <= o => 2 * o + 32 <= 800 => 0 <= l < 16 =>
  get256_direct (WArray800.init16 f) (2 * o) \bits16 l = f (o + l).
proof.
move=> ge0o le800 rgl; apply W16.wordP => b rgb.
rewrite bits16iE // /get256_direct pack32wE 1:/# W32u8.Pack.initiE 1:/# /=.
rewrite /WArray800.init16 WArray800.initiE 1:/# /= bits8iE 1:/#.
by congr; [congr|]; smt().
qed.

lemma load800_32E (f : int -> W16.t) (o c : int) :
  0 <= o => 2 * o + 4 <= 800 => 0 <= c < 2 =>
  get32_direct (WArray800.init16 f) (2 * o) \bits16 c = f (o + c).
proof.
move=> ge0o le800 rgc; apply W16.wordP => b rgb.
rewrite bits16iE // /get32_direct pack4wE 1:/# W4u8.Pack.initiE 1:/# /=.
rewrite /WArray800.init16 WArray800.initiE 1:/# /= bits8iE 1:/#.
by congr; [congr|]; smt().
qed.

(* ==================================================================== *)
(* The forward NTT: tables and checks                                   *)
(* ==================================================================== *)
(* twiddle registers: a full vector, or a broadcast pair                *)
op [opaque] zv (o : int) : W256.t = get256_direct (WArray800.init16 (fun j => jzetas_exp.[j])) o.
op [opaque] zb (o : int) : W256.t =
  VPBROADCAST_8u32 (get32_direct (WArray800.init16 (fun j => jzetas_exp.[j])) o).

(* a table entry, kept folded *)
op [opaque] zt (n : int) : W16.t = jzetas_exp.[n].

lemma zvE (o : int) : 0 <= o => o + 32 <= 800 => 2 %| o =>
  zv o = W16u16.pack16 (mkseq (fun l => zt (o %/ 2 + l)) 16).
proof.
move=> ge0o le800 evo; apply W16u16.wordP => l rgl.
rewrite pack16bE // W16u16.Pack.get_of_list // nth_mkseq //= /zv.
have {1}-> : o = 2 * (o %/ 2) by rewrite mulrC divzK.
by rewrite /zt load800E //; smt().
qed.

lemma zbE (o : int) : 0 <= o => o + 4 <= 800 => 2 %| o =>
  zb o = W16u16.pack16 (mkseq (fun l => zt (o %/ 2 + l %% 2)) 16).
proof.
move=> ge0o le800 evo; apply W16u16.wordP => l rgl.
rewrite pack16bE // W16u16.Pack.get_of_list // nth_mkseq //= /zb /VPBROADCAST_8u32.
have {2}-> : o = 2 * (o %/ 2) by rewrite mulrC divzK.
rewrite -load800_32E //; 1..3: smt().
apply W16.wordP => b rgb; rewrite !bits16iE // pack8wE 1:/#.
rewrite W8u32.Pack.get_of_list 1:/# (nth_map 0) 1:size_iota 1:/# /= /zt.
rewrite (: 2 * (2 * (o %/ 2) %/ 2) = o) 1:/#.
by congr; smt().
qed.

(* the same registers as slices of the table: one drop per register    *)
lemma zvL (o : int) : 0 <= o => o + 32 <= 800 => 2 %| o =>
  zv o = W16u16.pack16 (take 16 (drop (o %/ 2) (to_list jzetas_exp))).
proof.
move=> ge0o le800 evo; rewrite zvE //; do 2! congr.
apply (eq_from_nth witness).
- by rewrite size_mkseq size_take // size_drop 1:/# Array400.size_to_list /#.
move=> l; rewrite size_mkseq => rgl.
by rewrite nth_mkseq 1:/# /= nth_take 1,2:/# nth_drop 1,2:/# Array400.get_to_list /zt.
qed.

lemma zbL (o : int) : 0 <= o => o + 4 <= 800 => 2 %| o =>
  zb o = W16u16.pack16 (mkseq (fun l =>
    nth witness (take 2 (drop (o %/ 2) (to_list jzetas_exp))) (l %% 2)) 16).
proof.
move=> ge0o le800 evo; rewrite zbE //; do 2! congr; apply eq_in_mkseq => l rgl /=.
by rewrite nth_take 1,2:/# nth_drop 1,2:/# Array400.get_to_list /zt.
qed.

(* the position tables of levels 6 .. 1 *)
op pos6 : int list = iota_ 0 128.
op [opaque] pos5 : int list = [
  0; 1; 2; 3; 4; 5; 6; 7; 64; 65; 66; 67; 68; 69; 70; 71;
  16; 17; 18; 19; 20; 21; 22; 23; 80; 81; 82; 83; 84; 85; 86; 87;
  32; 33; 34; 35; 36; 37; 38; 39; 96; 97; 98; 99; 100; 101; 102; 103;
  48; 49; 50; 51; 52; 53; 54; 55; 112; 113; 114; 115; 116; 117; 118; 119;
  8; 9; 10; 11; 12; 13; 14; 15; 72; 73; 74; 75; 76; 77; 78; 79;
  24; 25; 26; 27; 28; 29; 30; 31; 88; 89; 90; 91; 92; 93; 94; 95;
  40; 41; 42; 43; 44; 45; 46; 47; 104; 105; 106; 107; 108; 109; 110; 111;
  56; 57; 58; 59; 60; 61; 62; 63; 120; 121; 122; 123; 124; 125; 126; 127].

op [opaque] pos4 : int list = [
  0; 1; 2; 3; 32; 33; 34; 35; 64; 65; 66; 67; 96; 97; 98; 99;
  16; 17; 18; 19; 48; 49; 50; 51; 80; 81; 82; 83; 112; 113; 114; 115;
  4; 5; 6; 7; 36; 37; 38; 39; 68; 69; 70; 71; 100; 101; 102; 103;
  20; 21; 22; 23; 52; 53; 54; 55; 84; 85; 86; 87; 116; 117; 118; 119;
  8; 9; 10; 11; 40; 41; 42; 43; 72; 73; 74; 75; 104; 105; 106; 107;
  24; 25; 26; 27; 56; 57; 58; 59; 88; 89; 90; 91; 120; 121; 122; 123;
  12; 13; 14; 15; 44; 45; 46; 47; 76; 77; 78; 79; 108; 109; 110; 111;
  28; 29; 30; 31; 60; 61; 62; 63; 92; 93; 94; 95; 124; 125; 126; 127].

op [opaque] pos3 : int list = [
  0; 1; 16; 17; 32; 33; 48; 49; 64; 65; 80; 81; 96; 97; 112; 113;
  2; 3; 18; 19; 34; 35; 50; 51; 66; 67; 82; 83; 98; 99; 114; 115;
  4; 5; 20; 21; 36; 37; 52; 53; 68; 69; 84; 85; 100; 101; 116; 117;
  6; 7; 22; 23; 38; 39; 54; 55; 70; 71; 86; 87; 102; 103; 118; 119;
  8; 9; 24; 25; 40; 41; 56; 57; 72; 73; 88; 89; 104; 105; 120; 121;
  10; 11; 26; 27; 42; 43; 58; 59; 74; 75; 90; 91; 106; 107; 122; 123;
  12; 13; 28; 29; 44; 45; 60; 61; 76; 77; 92; 93; 108; 109; 124; 125;
  14; 15; 30; 31; 46; 47; 62; 63; 78; 79; 94; 95; 110; 111; 126; 127].

op [opaque] pos2 : int list = [
  0; 8; 16; 24; 32; 40; 48; 56; 64; 72; 80; 88; 96; 104; 112; 120;
  2; 10; 18; 26; 34; 42; 50; 58; 66; 74; 82; 90; 98; 106; 114; 122;
  4; 12; 20; 28; 36; 44; 52; 60; 68; 76; 84; 92; 100; 108; 116; 124;
  6; 14; 22; 30; 38; 46; 54; 62; 70; 78; 86; 94; 102; 110; 118; 126;
  1; 9; 17; 25; 33; 41; 49; 57; 65; 73; 81; 89; 97; 105; 113; 121;
  3; 11; 19; 27; 35; 43; 51; 59; 67; 75; 83; 91; 99; 107; 115; 123;
  5; 13; 21; 29; 37; 45; 53; 61; 69; 77; 85; 93; 101; 109; 117; 125;
  7; 15; 23; 31; 39; 47; 55; 63; 71; 79; 87; 95; 103; 111; 119; 127].

(* each table is the previous one through the shuffles of its level *)
lemma pos5P : pshuf sh8 3 7 (pshuf sh8 2 6 (pshuf sh8 1 5 (pshuf sh8 0 4 pos6))) = pos5.
proof. by rewrite /pos5 /pos6 -iotaredE; with hint +listred (cbv delta). qed.

lemma pos4P : pshuf sh4 5 7 (pshuf sh4 1 3 (pshuf sh4 4 6 (pshuf sh4 0 2 pos5))) = pos4.
proof. by rewrite /pos4 /pos5; with hint +listred (cbv delta). qed.

lemma pos3P : pshuf sh2 6 7 (pshuf sh2 4 5 (pshuf sh2 2 3 (pshuf sh2 0 1 pos4))) = pos3.
proof. by rewrite /pos3 /pos4; with hint +listred (cbv delta). qed.

lemma pos2P : pshuf sh1 3 7 (pshuf sh1 2 6 (pshuf sh1 1 5 (pshuf sh1 0 4 pos3))) = pos2.
proof. by rewrite /pos2 /pos3; with hint +listred (cbv delta). qed.

(* the checks, by computation, for both halves *)
lemma chk6 (h : int) : 0 <= h < 2 =>
  bfok 6 h [0;1;2;3;4;5;6;7]
    (zb (8 + 392 * h)) (zb (8 + 392 * h)) (zb (12 + 392 * h)) (zb (12 + 392 * h)) pos6.
proof.
by move=> rgh; (have [] ->> : h = 0 \/ h = 1 by smt());
  rewrite !zbL // Array400.of_listK // /bfok /pos6 -!iotaredE /=;
  with hint +listred (cbv delta).
qed.

lemma chk5 (h : int) : 0 <= h < 2 =>
  bfok 5 h [0;4;1;5;2;6;3;7]
    (zv (16 + 392 * h)) (zv (16 + 392 * h)) (zv (48 + 392 * h)) (zv (48 + 392 * h)) pos5.
proof.
by move=> rgh; (have [] ->> : h = 0 \/ h = 1 by smt());
  rewrite !zvL // Array400.of_listK // /bfok /pos5 -!iotaredE /=;
  with hint +listred (cbv delta).
qed.

lemma chk4 (h : int) : 0 <= h < 2 =>
  bfok 4 h [0;2;4;6;1;3;5;7]
    (zv (80 + 392 * h)) (zv (80 + 392 * h)) (zv (112 + 392 * h)) (zv (112 + 392 * h)) pos4.
proof.
by move=> rgh; (have [] ->> : h = 0 \/ h = 1 by smt());
  rewrite !zvL // Array400.of_listK // /bfok /pos4 -!iotaredE /=;
  with hint +listred (cbv delta).
qed.

lemma chk3 (h : int) : 0 <= h < 2 =>
  bfok 3 h [0;1;2;3;4;5;6;7]
    (zv (144 + 392 * h)) (zv (144 + 392 * h)) (zv (176 + 392 * h)) (zv (176 + 392 * h)) pos3.
proof.
by move=> rgh; (have [] ->> : h = 0 \/ h = 1 by smt());
  rewrite !zvL // Array400.of_listK // /bfok /pos3 -!iotaredE /=;
  with hint +listred (cbv delta).
qed.

lemma chk2 (h : int) : 0 <= h < 2 =>
  bfok 2 h [0;4;1;5;2;6;3;7]
    (zv (208 + 392 * h)) (zv (208 + 392 * h)) (zv (240 + 392 * h)) (zv (240 + 392 * h)) pos2.
proof.
by move=> rgh; (have [] ->> : h = 0 \/ h = 1 by smt());
  rewrite !zvL // Array400.of_listK // /bfok /pos2 -!iotaredE /=;
  with hint +listred (cbv delta).
qed.

lemma chk1 (h : int) : 0 <= h < 2 =>
  bfok 1 h [0;4;2;6;1;5;3;7]
    (zv (272 + 392 * h)) (zv (336 + 392 * h)) (zv (304 + 392 * h)) (zv (368 + 392 * h)) pos2.
proof.
by move=> rgh; (have [] ->> : h = 0 \/ h = 1 by smt());
  rewrite !zvL // Array400.of_listK // /bfok /pos2 -!iotaredE /=;
  with hint +listred (cbv delta).
qed.

(* ==================================================================== *)
(* The forward NTT: levels as register-file transformations             *)
(* ==================================================================== *)
lemma perm_id8 : perm_eq [0;1;2;3;4;5;6;7] (iota_ 0 8).
proof. by rewrite -iotaredE perm_eq_refl. qed.

lemma perm_a2 : perm_eq [0;4;1;5;2;6;3;7] (iota_ 0 8).
proof. by rewrite -iotaredE; apply/perm_eqP => p /=; ring. qed.

lemma perm_a3 : perm_eq [0;2;4;6;1;3;5;7] (iota_ 0 8).
proof. by rewrite -iotaredE; apply/perm_eqP => p /=; ring. qed.

lemma perm_a6 : perm_eq [0;4;2;6;1;5;3;7] (iota_ 0 8).
proof. by rewrite -iotaredE; apply/perm_eqP => p /=; ring. qed.

lemma rg_sh8 : all (fun j => 0 <= j < 32) sh8 by done.
lemma rg_sh4 : all (fun j => 0 <= j < 32) sh4 by done.
lemma rg_sh2 : all (fun j => 0 <= j < 32) sh2 by done.
lemma rg_sh1 : all (fun j => 0 <= j < 32) sh1 by done.

lemma lvl6 (P : wpoly) (h : int) (rf : W256.t list) : 0 <= h < 2 =>
  rfinv P h pos6 rf =>
  rfinv (reduce_level P 6) h pos6
    (rfbf [0;1;2;3;4;5;6;7]
      (zb (8 + 392 * h)) (zb (8 + 392 * h)) (zb (12 + 392 * h)) (zb (12 + 392 * h)) rf).
proof. by move=> rgh hinv; apply: (bf_inv _ _ _ _ _ _ _ _ _ _ rgh _ perm_id8 (chk6 h rgh)). qed.

lemma lvl5 (P : wpoly) (h : int) (rf : W256.t list) : 0 <= h < 2 =>
  rfinv P h pos6 rf =>
  rfinv (reduce_level P 5) h pos5
    (rfbf [0;4;1;5;2;6;3;7]
      (zv (16 + 392 * h)) (zv (16 + 392 * h)) (zv (48 + 392 * h)) (zv (48 + 392 * h))
      (rfshuf sh8 3 7 (rfshuf sh8 2 6 (rfshuf sh8 1 5 (rfshuf sh8 0 4 rf))))).
proof.
move=> rgh hinv; apply: (bf_inv _ _ _ _ _ _ _ _ _ _ rgh _ perm_a2 (chk5 h rgh)); first done.
rewrite -pos5P; do 4! (apply shuf_inv; [by [] | by [] | by [] | by [] |]).
exact hinv.
qed.

lemma lvl4 (P : wpoly) (h : int) (rf : W256.t list) : 0 <= h < 2 =>
  rfinv P h pos5 rf =>
  rfinv (reduce_level P 4) h pos4
    (rfbf [0;2;4;6;1;3;5;7]
      (zv (80 + 392 * h)) (zv (80 + 392 * h)) (zv (112 + 392 * h)) (zv (112 + 392 * h))
      (rfshuf sh4 5 7 (rfshuf sh4 1 3 (rfshuf sh4 4 6 (rfshuf sh4 0 2 rf))))).
proof.
move=> rgh hinv; apply: (bf_inv _ _ _ _ _ _ _ _ _ _ rgh _ perm_a3 (chk4 h rgh)); first done.
rewrite -pos4P; do 4! (apply shuf_inv; [by [] | by [] | by [] | by [] |]).
exact hinv.
qed.

lemma lvl3 (P : wpoly) (h : int) (rf : W256.t list) : 0 <= h < 2 =>
  rfinv P h pos4 rf =>
  rfinv (reduce_level P 3) h pos3
    (rfbf [0;1;2;3;4;5;6;7]
      (zv (144 + 392 * h)) (zv (144 + 392 * h)) (zv (176 + 392 * h)) (zv (176 + 392 * h))
      (rfshuf sh2 6 7 (rfshuf sh2 4 5 (rfshuf sh2 2 3 (rfshuf sh2 0 1 rf))))).
proof.
move=> rgh hinv; apply: (bf_inv _ _ _ _ _ _ _ _ _ _ rgh _ perm_id8 (chk3 h rgh)); first done.
rewrite -pos3P; do 4! (apply shuf_inv; [by [] | by [] | by [] | by [] |]).
exact hinv.
qed.

lemma lvl2 (P : wpoly) (h : int) (rf : W256.t list) : 0 <= h < 2 =>
  rfinv P h pos3 rf =>
  rfinv (reduce_level P 2) h pos2
    (rfbf [0;4;1;5;2;6;3;7]
      (zv (208 + 392 * h)) (zv (208 + 392 * h)) (zv (240 + 392 * h)) (zv (240 + 392 * h))
      (rfshuf sh1 3 7 (rfshuf sh1 2 6 (rfshuf sh1 1 5 (rfshuf sh1 0 4 rf))))).
proof.
move=> rgh hinv; apply: (bf_inv _ _ _ _ _ _ _ _ _ _ rgh _ perm_a2 (chk2 h rgh)); first done.
rewrite -pos2P; do 4! (apply shuf_inv; [by [] | by [] | by [] | by [] |]).
exact hinv.
qed.

lemma lvl1 (P : wpoly) (h : int) (rf : W256.t list) : 0 <= h < 2 =>
  rfinv P h pos2 rf =>
  rfinv (reduce_level P 1) h pos2
    (rfbf [0;4;2;6;1;5;3;7]
      (zv (272 + 392 * h)) (zv (336 + 392 * h)) (zv (304 + 392 * h)) (zv (368 + 392 * h))
      rf).
proof.
by move=> rgh hinv; apply: (bf_inv _ _ _ _ _ _ _ _ _ _ rgh _ perm_a6 (chk1 h rgh)).
qed.

(* -------------------------------------------------------------------- *)
(* level 7 runs on memory, in two batches of 4 + 4 blocks               *)
op pos7a : int list = iota_ 0 64 ++ iota_ 128 64.
op pos7b : int list = iota_ 64 64 ++ iota_ 192 64.

lemma chk7a : bfok 7 0 [0;1;2;3;4;5;6;7] (zb 0) (zb 0) (zb 4) (zb 4) pos7a.
proof.
by rewrite !zbL // Array400.of_listK // /bfok /pos7a -!iotaredE /=;
  with hint +listred (cbv delta).
qed.

lemma chk7b : bfok 7 0 [0;1;2;3;4;5;6;7] (zb 0) (zb 0) (zb 4) (zb 4) pos7b.
proof.
by rewrite !zbL // Array400.of_listK // /bfok /pos7b -!iotaredE /=;
  with hint +listred (cbv delta).
qed.

lemma lvl7 (P : wpoly) (pos : int list) (rf : W256.t list) :
  pos = pos7a \/ pos = pos7b =>
  rfinv P 0 pos rf =>
  rfinv (reduce_level P 7) 0 pos (rfbf [0;1;2;3;4;5;6;7] (zb 0) (zb 0) (zb 4) (zb 4) rf).
proof.
move=> hpos hinv; have hchk : bfok 7 0 [0;1;2;3;4;5;6;7] (zb 0) (zb 0) (zb 4) (zb 4) pos.
- by case: hpos => ->; [exact chk7a | exact chk7b].
by apply: (bf_inv _ _ _ _ _ _ _ _ _ _ _ _ perm_id8 hchk).
qed.

end MLKEM_ntt_levelsT.
