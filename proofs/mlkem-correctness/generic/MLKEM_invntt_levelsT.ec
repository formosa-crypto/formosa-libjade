(**
  The register levels of the AVX2 inverse NTT of ML-KEM, against the
  generic Gentleman-Sande merges (`NttKem`: `ireduce_level`).

  The code reads a half polynomial into eight registers, runs the
  levels 1 .. 6 there, with lane shuffles and Barrett reductions of
  some registers in between.  The register-file invariant `rfinv` and
  the shuffle step are the forward ones (`MLKEM_ntt_levels`); a merge
  call is one inverse level (`ibf_inv`), under a computed check of the
  pairing and of the twiddle lanes, and a reduction of registers is a
  reduction of their positions (`rfinv_red`).
*)

require import AllCore List Int IntDiv StdOrder.
from Jasmin require import JModel.
from JazzEC require import Array16 Array256 Array400 WArray32 WArray512 WArray800.
require import Montgomery16 MLKEMFCLib NttKem.
require import JkemConstants.
require BaseT MLKEM_ntt_levelsT.

abstract theory MLKEM_invntt_levelsT.

clone import BaseT.BaseT as B.
import R.
clone import MLKEM_ntt_levelsT.MLKEM_ntt_levelsT as MLKEM_ntt_levels with theory B <- B.

(* ==================================================================== *)

(*---*) import IntOrder.

(* ==================================================================== *)
(* The inverse butterfly                                                *)
(* ==================================================================== *)
(* lane-wise merge halves: a + b and mmr16 (a - b) z                    *)
op [opaque] iaddl (a b : W256.t) : W256.t =
  W16u16.pack16 (mkseq (fun l => (a \bits16 l) + (b \bits16 l)) 16).

op [opaque] isubl (a b zl zh : W256.t) : W256.t =
  W16u16.pack16 (mkseq (fun l =>
    mmr16 ((a \bits16 l) - (b \bits16 l)) (zl \bits16 l, zh \bits16 l)) 16).

lemma wmulhsC (x y : W16.t) : wmulhs x y = wmulhs y x.
proof. by apply/to_sint_eq; rewrite !to_sint_wmulhs mulzC. qed.

lemma iaddlE (a b : W256.t) : VPADD_16u16 b a = iaddl a b.
proof.
apply W16u16.wordP => l rgl; rewrite /iaddl pack16bE // W16u16.Pack.get_of_list //.
by rewrite nth_mkseq //= /VPADD_16u16 map2bE //= W16.WRingA.addrC.
qed.

lemma isublE (a b zl zh : W256.t) :
    VPSUB_16u16 (VPMULH_16u16 zh (VPSUB_16u16 a b))
      (VPMULH_16u16 qx16v (VPMULL_16u16 zl (VPSUB_16u16 a b)))
  = isubl a b zl zh.
proof.
apply W16u16.wordP => l rgl; rewrite /isubl pack16bE // W16u16.Pack.get_of_list //.
rewrite nth_mkseq //= /VPSUB_16u16 /VPMULH_16u16 /VPMULL_16u16 !map2bE //=.
by rewrite bits16_qx16v // /mmr16 /= (wmulhsC (W16.of_int 3329)).
qed.

hoare ibutterfly64x_h (rl0 rl1 rl2 rl3 rh0 rh1 rh2 rh3 zl0 zl1 zh0 zh1 : W256.t) :
  M.__invntt___butterfly64x :
    arg = (rl0, rl1, rl2, rl3, rh0, rh1, rh2, rh3, zl0, zl1, zh0, zh1, qx16v)
  ==>
    res = (iaddl rl0 rh0, iaddl rl1 rh1, iaddl rl2 rh2, iaddl rl3 rh3,
           isubl rl0 rh0 zl0 zh0, isubl rl1 rh1 zl0 zh0,
           isubl rl2 rh2 zl1 zh1, isubl rl3 rh3 zl1 zh1).
proof. by proc; auto => |>; rewrite !iaddlE !isublE. qed.

(* ==================================================================== *)
(* An inverse level on the register file                                *)
(* ==================================================================== *)
op rfibf (a : int list) (zl0 zl1 zh0 zh1 : W256.t) (rf : W256.t list) : W256.t list =
  let r = fun m => nth W256.zero rf (nth 0 a m) in
  mkseq (fun reg =>
    let m = index reg a in
    if m < 4 then iaddl (r m) (r (m + 4))
    else isubl (r (m - 4)) (r m) (zsel zl0 zl1 (m - 4)) (zsel zh0 zh1 (m - 4))) 8.

(* the pairing and the twiddles agree with inverse level k of half h   *)
op ibfok (k h : int) (a : int list) (zl0 zl1 zh0 zh1 : W256.t) (pos : int list) =
  all (fun i =>
    let m = i %/ 16 in let l = i %% 16 in
    let x = nth 0 pos (16 * nth 0 a m + l) in
    let y = nth 0 pos (16 * nth 0 a (m + 4) + l) in
    let g = 128 * h + x in
       0 <= x < 128 /\ y = x + 2^k /\ g %% 2^(k+1) < 2^k
    /\ (zsel zl0 zl1 m \bits16 l, zsel zh0 zh1 m \bits16 l)
       = tw16 (izv k (g %/ 2^(k+1)))) (iota_ 0 64).

lemma ibf_inv (P : wpoly) (h k : int) (pos : int list) (rf : W256.t list)
  (a : int list) (zl0 zl1 zh0 zh1 : W256.t) :
  0 <= h < 2 => 0 <= k < 8 => perm_eq a (iota_ 0 8) =>
  ibfok k h a zl0 zl1 zh0 zh1 pos =>
  rfinv P h pos rf => rfinv (ireduce_level P k) h pos (rfibf a zl0 zl1 zh0 zh1 rf).
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
have hlvl : forall g, 0 <= g < 256 => g %% 2^(k+1) < 2^k =>
     (ireduce_level P k).[g] = P.[g] + P.[g + 2^k]
  /\ (ireduce_level P k).[g + 2^k]
       = mmr16 (P.[g] - P.[g + 2^k]) (tw16 (izv k (g %/ 2^(k+1)))).
- move=> g rgg hg; have gt0K : 0 < 2^(k+1) by apply expr_gt0.
  have e256 : 2^(7-k) * 2^(k+1) = 256.
  + by rewrite -exprD_nneg 1,2:/# (: 7 - k + (k+1) = 8) 1:/#.
  have rgJ : 0 <= g %/ 2^(k+1) < 2^(7-k) by rewrite divz_ge0 // ltz_divLR // e256 /#.
  have rgt : 0 <= g %% 2^(k+1) < 2^k by smt(modz_ge0).
  have := ireduce_leveliE P k (g %/ 2^(k+1)) (g %% 2^(k+1)) _ rgJ rgt; first by smt().
  have e : g %/ 2^(k+1) * 2^(k+1) + 2^k + g %% 2^(k+1) = g + 2^k by smt(divz_eq).
  by rewrite e -divz_eq.
have hr : forall j, 0 <= j < 8 =>
    nth W256.zero rf (nth 0 a j) \bits16 (i %% 16)
  = P.[128 * h + nth 0 pos (16 * nth 0 a j + i %% 16)].
- by move=> j rgj; rewrite -rflE // hinv //; smt().
rewrite /rfl /rfibf /= nth_mkseq 1:/# /= -/m.
case: (m < 4) => hm.
- have := hok (16 * m + i %% 16) _; first by rewrite mem_iota /#.
  rewrite /= (: (16 * m + i %% 16) %/ 16 = m) 1:/#.
  rewrite (: (16 * m + i %% 16) %% 16 = i %% 16) 1:/#.
  move=> [rgx [hy [ht hz]]].
  rewrite /iaddl pack16bE // W16u16.Pack.get_of_list // nth_mkseq //= !hr 1,2:/# -hi hy.
  move: rgx ht; rewrite -hi => rgx ht.
  rewrite (: 128 * h + (nth 0 pos i + 2^k) = 128 * h + nth 0 pos i + 2^k) 1:#ring.
  by have [-> _] := hlvl (128 * h + nth 0 pos i) _ ht; smt().
have := hok (16 * (m - 4) + i %% 16) _; first by rewrite mem_iota /#.
rewrite /= (: (16 * (m - 4) + i %% 16) %/ 16 = m - 4) 1:/#.
rewrite (: (16 * (m - 4) + i %% 16) %% 16 = i %% 16) 1:/#.
rewrite (: m - 4 + 4 = m) 1:#ring -hi => -[rgx [hy [ht hz]]].
rewrite /isubl pack16bE // W16u16.Pack.get_of_list // nth_mkseq //= hz !hr 1,2:/# -hi hy.
rewrite (: 128 * h + (nth 0 pos (16 * nth 0 a (m - 4) + i %% 16) + 2^k)
         = 128 * h + nth 0 pos (16 * nth 0 a (m - 4) + i %% 16) + 2^k) 1:#ring.
by have [_ ->] := hlvl _ _ ht; smt().
qed.

(* ==================================================================== *)
(* Reductions of registers                                              *)
(* ==================================================================== *)
(* the positions of the registers regs, in both halves                  *)
op redS (pos regs : int list) (i : int) : bool = index (i %% 128) pos %/ 16 \in regs.

op redat (P : wpoly) (S : int -> bool) : wpoly =
  Array256.init (fun i => if S i then sbred16 P.[i] else P.[i]).

op rfred (regs : int list) (rf : W256.t list) : W256.t list =
  mkseq (fun m => if m \in regs then redl (nth W256.zero rf m) else nth W256.zero rf m) 8.

lemma rfinv_red (P : wpoly) (h : int) (pos regs : int list) (rf : W256.t list) :
  0 <= h < 2 => uniq pos => size pos = 128 => all (fun x => 0 <= x < 128) pos =>
  rfinv P h pos rf => rfinv (redat P (redS pos regs)) h pos (rfred regs rf).
proof.
move=> rgh upos hsz /List.allP hpos hinv i rgi.
have rgx : 0 <= nth 0 pos i < 128 by apply hpos; rewrite mem_nth /#.
have hS : redS pos regs (128 * h + nth 0 pos i) = (i %/ 16 \in regs).
- by rewrite /redS (: (128 * h + nth 0 pos i) %% 128 = nth 0 pos i) 1:/# index_uniq 1:/#.
rewrite /redat initiE 1:/# /= hS /rfl /rfred nth_mkseq 1:/# /=.
case: (i %/ 16 \in regs) => hin /=; last by rewrite -/(rfl rf i) hinv.
rewrite /redl pack16bE 1:/# W16u16.Pack.get_of_list 1:/# nth_mkseq 1:/# /=.
by rewrite -/(rfl rf i) hinv.
qed.

(* ==================================================================== *)
(* The inverse twiddle table                                            *)
(* ==================================================================== *)
op [opaque] ziv (o : int) : W256.t =
  get256_direct (WArray800.init16 (fun j => jzetas_inv_exp.[j])) o.
op [opaque] zib (o : int) : W256.t =
  VPBROADCAST_8u32 (get32_direct (WArray800.init16 (fun j => jzetas_inv_exp.[j])) o).

(* a table entry, kept folded *)
op [opaque] zit (n : int) : W16.t = jzetas_inv_exp.[n].

lemma zivE (o : int) : 0 <= o => o + 32 <= 800 => 2 %| o =>
  ziv o = W16u16.pack16 (mkseq (fun l => zit (o %/ 2 + l)) 16).
proof.
move=> ge0o le800 evo; apply W16u16.wordP => l rgl.
rewrite pack16bE // W16u16.Pack.get_of_list // nth_mkseq //= /ziv.
have {1}-> : o = 2 * (o %/ 2) by rewrite mulrC divzK.
by rewrite /zit load800E //; smt().
qed.

lemma zibE (o : int) : 0 <= o => o + 4 <= 800 => 2 %| o =>
  zib o = W16u16.pack16 (mkseq (fun l => zit (o %/ 2 + l %% 2)) 16).
proof.
move=> ge0o le800 evo; apply W16u16.wordP => l rgl.
rewrite pack16bE // W16u16.Pack.get_of_list // nth_mkseq //= /zib /VPBROADCAST_8u32.
have {2}-> : o = 2 * (o %/ 2) by rewrite mulrC divzK.
rewrite -load800_32E //; 1..3: smt().
apply W16.wordP => b rgb; rewrite !bits16iE // pack8wE 1:/#.
rewrite W8u32.Pack.get_of_list 1:/# (nth_map 0) 1:size_iota 1:/# /= /zit.
rewrite (: 2 * (2 * (o %/ 2) %/ 2) = o) 1:/#.
by congr; smt().
qed.

(* the same registers as slices of the table: one drop per register    *)
lemma zivL (o : int) : 0 <= o => o + 32 <= 800 => 2 %| o =>
  ziv o = W16u16.pack16 (take 16 (drop (o %/ 2) (to_list jzetas_inv_exp))).
proof.
move=> ge0o le800 evo; rewrite zivE //; do 2! congr.
apply (eq_from_nth witness).
- by rewrite size_mkseq size_take // size_drop 1:/# Array400.size_to_list /#.
move=> l; rewrite size_mkseq => rgl.
by rewrite nth_mkseq 1:/# /= nth_take 1,2:/# nth_drop 1,2:/# Array400.get_to_list /zit.
qed.

lemma zibL (o : int) : 0 <= o => o + 4 <= 800 => 2 %| o =>
  zib o = W16u16.pack16 (mkseq (fun l =>
    nth witness (take 2 (drop (o %/ 2) (to_list jzetas_inv_exp))) (l %% 2)) 16).
proof.
move=> ge0o le800 evo; rewrite zibE //; do 2! congr; apply eq_in_mkseq => l rgl /=.
by rewrite nth_take 1,2:/# nth_drop 1,2:/# Array400.get_to_list /zit.
qed.

(* ==================================================================== *)
(* The inverse tables and checks                                        *)
(* ==================================================================== *)
(* the position tables of the inverse levels; ip1 is the load order     *)
op [opaque] ip1 : int list = [
  0; 8; 16; 24; 32; 40; 48; 56; 64; 72; 80; 88; 96; 104; 112; 120;
  1; 9; 17; 25; 33; 41; 49; 57; 65; 73; 81; 89; 97; 105; 113; 121;
  2; 10; 18; 26; 34; 42; 50; 58; 66; 74; 82; 90; 98; 106; 114; 122;
  3; 11; 19; 27; 35; 43; 51; 59; 67; 75; 83; 91; 99; 107; 115; 123;
  4; 12; 20; 28; 36; 44; 52; 60; 68; 76; 84; 92; 100; 108; 116; 124;
  5; 13; 21; 29; 37; 45; 53; 61; 69; 77; 85; 93; 101; 109; 117; 125;
  6; 14; 22; 30; 38; 46; 54; 62; 70; 78; 86; 94; 102; 110; 118; 126;
  7; 15; 23; 31; 39; 47; 55; 63; 71; 79; 87; 95; 103; 111; 119; 127].

op [opaque] ip3 : int list = [
  0; 1; 16; 17; 32; 33; 48; 49; 64; 65; 80; 81; 96; 97; 112; 113;
  8; 9; 24; 25; 40; 41; 56; 57; 72; 73; 88; 89; 104; 105; 120; 121;
  2; 3; 18; 19; 34; 35; 50; 51; 66; 67; 82; 83; 98; 99; 114; 115;
  10; 11; 26; 27; 42; 43; 58; 59; 74; 75; 90; 91; 106; 107; 122; 123;
  4; 5; 20; 21; 36; 37; 52; 53; 68; 69; 84; 85; 100; 101; 116; 117;
  12; 13; 28; 29; 44; 45; 60; 61; 76; 77; 92; 93; 108; 109; 124; 125;
  6; 7; 22; 23; 38; 39; 54; 55; 70; 71; 86; 87; 102; 103; 118; 119;
  14; 15; 30; 31; 46; 47; 62; 63; 78; 79; 94; 95; 110; 111; 126; 127].

op [opaque] ip4 : int list = [
  0; 1; 2; 3; 32; 33; 34; 35; 64; 65; 66; 67; 96; 97; 98; 99;
  8; 9; 10; 11; 40; 41; 42; 43; 72; 73; 74; 75; 104; 105; 106; 107;
  16; 17; 18; 19; 48; 49; 50; 51; 80; 81; 82; 83; 112; 113; 114; 115;
  24; 25; 26; 27; 56; 57; 58; 59; 88; 89; 90; 91; 120; 121; 122; 123;
  4; 5; 6; 7; 36; 37; 38; 39; 68; 69; 70; 71; 100; 101; 102; 103;
  12; 13; 14; 15; 44; 45; 46; 47; 76; 77; 78; 79; 108; 109; 110; 111;
  20; 21; 22; 23; 52; 53; 54; 55; 84; 85; 86; 87; 116; 117; 118; 119;
  28; 29; 30; 31; 60; 61; 62; 63; 92; 93; 94; 95; 124; 125; 126; 127].

op [opaque] ip5 : int list = [
  0; 1; 2; 3; 4; 5; 6; 7; 64; 65; 66; 67; 68; 69; 70; 71;
  8; 9; 10; 11; 12; 13; 14; 15; 72; 73; 74; 75; 76; 77; 78; 79;
  16; 17; 18; 19; 20; 21; 22; 23; 80; 81; 82; 83; 84; 85; 86; 87;
  24; 25; 26; 27; 28; 29; 30; 31; 88; 89; 90; 91; 92; 93; 94; 95;
  32; 33; 34; 35; 36; 37; 38; 39; 96; 97; 98; 99; 100; 101; 102; 103;
  40; 41; 42; 43; 44; 45; 46; 47; 104; 105; 106; 107; 108; 109; 110; 111;
  48; 49; 50; 51; 52; 53; 54; 55; 112; 113; 114; 115; 116; 117; 118; 119;
  56; 57; 58; 59; 60; 61; 62; 63; 120; 121; 122; 123; 124; 125; 126; 127].

op [opaque] ip6 : int list = [
  0; 1; 2; 3; 4; 5; 6; 7; 8; 9; 10; 11; 12; 13; 14; 15;
  64; 65; 66; 67; 68; 69; 70; 71; 72; 73; 74; 75; 76; 77; 78; 79;
  16; 17; 18; 19; 20; 21; 22; 23; 24; 25; 26; 27; 28; 29; 30; 31;
  80; 81; 82; 83; 84; 85; 86; 87; 88; 89; 90; 91; 92; 93; 94; 95;
  32; 33; 34; 35; 36; 37; 38; 39; 40; 41; 42; 43; 44; 45; 46; 47;
  96; 97; 98; 99; 100; 101; 102; 103; 104; 105; 106; 107; 108; 109; 110; 111;
  48; 49; 50; 51; 52; 53; 54; 55; 56; 57; 58; 59; 60; 61; 62; 63;
  112; 113; 114; 115; 116; 117; 118; 119; 120; 121; 122; 123; 124; 125; 126; 127].

op [opaque] pkidx : int list = [
  0; 16; 32; 48; 64; 80; 96; 112; 1; 17; 33; 49; 65; 81; 97; 113;
  2; 18; 34; 50; 66; 82; 98; 114; 3; 19; 35; 51; 67; 83; 99; 115;
  4; 20; 36; 52; 68; 84; 100; 116; 5; 21; 37; 53; 69; 85; 101; 117;
  6; 22; 38; 54; 70; 86; 102; 118; 7; 23; 39; 55; 71; 87; 103; 119;
  8; 24; 40; 56; 72; 88; 104; 120; 9; 25; 41; 57; 73; 89; 105; 121;
  10; 26; 42; 58; 74; 90; 106; 122; 11; 27; 43; 59; 75; 91; 107; 123;
  12; 28; 44; 60; 76; 92; 108; 124; 13; 29; 45; 61; 77; 93; 109; 125;
  14; 30; 46; 62; 78; 94; 110; 126; 15; 31; 47; 63; 79; 95; 111; 127;
  128; 144; 160; 176; 192; 208; 224; 240; 129; 145; 161; 177; 193; 209; 225; 241;
  130; 146; 162; 178; 194; 210; 226; 242; 131; 147; 163; 179; 195; 211; 227; 243;
  132; 148; 164; 180; 196; 212; 228; 244; 133; 149; 165; 181; 197; 213; 229; 245;
  134; 150; 166; 182; 198; 214; 230; 246; 135; 151; 167; 183; 199; 215; 231; 247;
  136; 152; 168; 184; 200; 216; 232; 248; 137; 153; 169; 185; 201; 217; 233; 249;
  138; 154; 170; 186; 202; 218; 234; 250; 139; 155; 171; 187; 203; 219; 235; 251;
  140; 156; 172; 188; 204; 220; 236; 252; 141; 157; 173; 189; 205; 221; 237; 253;
  142; 158; 174; 190; 206; 222; 238; 254; 143; 159; 175; 191; 207; 223; 239; 255].

(* the loads: register m of half h holds the coefficients ip1 of v      *)
lemma ip1_load (h i : int) : 0 <= h < 2 => 0 <= i < 128 =>
  nth 0 pkidx (128 * h + nth 0 ip1 i) = 128 * h + i.
proof.
move=> rgh; have [] ->> : h = 0 \/ h = 1 by smt().
- by move: i; apply/allP_range; rewrite /pkidx /ip1 -iotaredE.
by move: i; apply/allP_range; rewrite /pkidx /ip1 -iotaredE.
qed.

lemma ip3P : pshuf sh1 6 7 (pshuf sh1 4 5 (pshuf sh1 2 3 (pshuf sh1 0 1 ip1))) = ip3.
proof. by rewrite /ip1 /ip3; with hint +listred (cbv delta). qed.

lemma ip4P : pshuf sh2 5 7 (pshuf sh2 1 3 (pshuf sh2 4 6 (pshuf sh2 0 2 ip3))) = ip4.
proof. by rewrite /ip3 /ip4; with hint +listred (cbv delta). qed.

lemma ip5P : pshuf sh4 3 7 (pshuf sh4 2 6 (pshuf sh4 1 5 (pshuf sh4 0 4 ip4))) = ip5.
proof. by rewrite /ip4 /ip5; with hint +listred (cbv delta). qed.

lemma ip6P : pshuf sh8 6 7 (pshuf sh8 4 5 (pshuf sh8 2 3 (pshuf sh8 0 1 ip5))) = ip6.
proof. by rewrite /ip5 /ip6; with hint +listred (cbv delta). qed.

lemma ip_props (pos : int list) : pos = ip1 \/ pos = ip3 \/ pos = ip4 \/ pos = ip5 \/ pos = ip6 =>
  uniq pos /\ size pos = 128 /\ all (fun x => 0 <= x < 128) pos.
proof.
by case=> [|[|[|[|]]]] ->; rewrite ?/ip1 ?/ip3 ?/ip4 ?/ip5 ?/ip6;
  with hint +listred (cbv delta).
qed.

lemma ichk1 (h : int) : 0 <= h < 2 =>
  ibfok 1 h [0;1;4;5;2;3;6;7]
    (ziv (392 * h)) (ziv (64 + 392 * h)) (ziv (32 + 392 * h)) (ziv (96 + 392 * h)) ip1.
proof.
by move=> rgh; (have [] ->> : h = 0 \/ h = 1 by smt());
  rewrite !zivL // Array400.of_listK // /ibfok /ip1 -!iotaredE /=;
  with hint +listred (cbv delta).
qed.

lemma ichk2 (h : int) : 0 <= h < 2 =>
  ibfok 2 h [0;1;2;3;4;5;6;7]
    (ziv (128 + 392 * h)) (ziv (128 + 392 * h)) (ziv (160 + 392 * h)) (ziv (160 + 392 * h)) ip1.
proof.
by move=> rgh; (have [] ->> : h = 0 \/ h = 1 by smt());
  rewrite !zivL // Array400.of_listK // /ibfok /ip1 -!iotaredE /=;
  with hint +listred (cbv delta).
qed.

lemma ichk3 (h : int) : 0 <= h < 2 =>
  ibfok 3 h [0;2;4;6;1;3;5;7]
    (ziv (192 + 392 * h)) (ziv (192 + 392 * h)) (ziv (224 + 392 * h)) (ziv (224 + 392 * h)) ip3.
proof.
by move=> rgh; (have [] ->> : h = 0 \/ h = 1 by smt());
  rewrite !zivL // Array400.of_listK // /ibfok /ip3 -!iotaredE /=;
  with hint +listred (cbv delta).
qed.

lemma ichk4 (h : int) : 0 <= h < 2 =>
  ibfok 4 h [0;4;1;5;2;6;3;7]
    (ziv (256 + 392 * h)) (ziv (256 + 392 * h)) (ziv (288 + 392 * h)) (ziv (288 + 392 * h)) ip4.
proof.
by move=> rgh; (have [] ->> : h = 0 \/ h = 1 by smt());
  rewrite !zivL // Array400.of_listK // /ibfok /ip4 -!iotaredE /=;
  with hint +listred (cbv delta).
qed.

lemma ichk5 (h : int) : 0 <= h < 2 =>
  ibfok 5 h [0;1;2;3;4;5;6;7]
    (ziv (320 + 392 * h)) (ziv (320 + 392 * h)) (ziv (352 + 392 * h)) (ziv (352 + 392 * h)) ip5.
proof.
by move=> rgh; (have [] ->> : h = 0 \/ h = 1 by smt());
  rewrite !zivL // Array400.of_listK // /ibfok /ip5 -!iotaredE /=;
  with hint +listred (cbv delta).
qed.

lemma ichk6 (h : int) : 0 <= h < 2 =>
  ibfok 6 h [0;2;4;6;1;3;5;7]
    (zib (384 + 392 * h)) (zib (384 + 392 * h)) (zib (388 + 392 * h)) (zib (388 + 392 * h)) ip6.
proof.
by move=> rgh; (have [] ->> : h = 0 \/ h = 1 by smt());
  rewrite !zibL // Array400.of_listK // /ibfok /ip6 -!iotaredE /=;
  with hint +listred (cbv delta).
qed.

lemma perm_i1 : perm_eq [0;1;4;5;2;3;6;7] (iota_ 0 8).
proof. by rewrite -iotaredE; apply/perm_eqP => p /=; ring. qed.

(* ==================================================================== *)
(* The inverse levels                                                   *)
(* ==================================================================== *)
lemma ilvl1 (P : wpoly) (h : int) (rf : W256.t list) : 0 <= h < 2 =>
  rfinv P h ip1 rf =>
  rfinv (ireduce_level P 1) h ip1
    (rfibf [0;1;4;5;2;3;6;7]
      (ziv (392 * h)) (ziv (64 + 392 * h)) (ziv (32 + 392 * h)) (ziv (96 + 392 * h)) rf).
proof. by move=> rgh hinv; apply: (ibf_inv _ _ _ _ _ _ _ _ _ _ rgh _ perm_i1 (ichk1 h rgh)). qed.

lemma ilvl2 (P : wpoly) (h : int) (rf : W256.t list) : 0 <= h < 2 =>
  rfinv P h ip1 rf =>
  rfinv (ireduce_level P 2) h ip1
    (rfibf [0;1;2;3;4;5;6;7]
      (ziv (128 + 392 * h)) (ziv (128 + 392 * h)) (ziv (160 + 392 * h)) (ziv (160 + 392 * h))
      rf).
proof. by move=> rgh hinv; apply: (ibf_inv _ _ _ _ _ _ _ _ _ _ rgh _ perm_id8 (ichk2 h rgh)). qed.

lemma ilvl3 (P : wpoly) (h : int) (rf : W256.t list) : 0 <= h < 2 =>
  rfinv P h ip1 rf =>
  rfinv (ireduce_level P 3) h ip3
    (rfibf [0;2;4;6;1;3;5;7]
      (ziv (192 + 392 * h)) (ziv (192 + 392 * h)) (ziv (224 + 392 * h)) (ziv (224 + 392 * h))
      (rfshuf sh1 6 7 (rfshuf sh1 4 5 (rfshuf sh1 2 3 (rfshuf sh1 0 1 rf))))).
proof.
move=> rgh hinv; apply: (ibf_inv _ _ _ _ _ _ _ _ _ _ rgh _ perm_a3 (ichk3 h rgh)); first done.
rewrite -ip3P; do 4! (apply shuf_inv; [by [] | by [] | by [] | by [] |]).
exact hinv.
qed.

lemma ilvl4 (P : wpoly) (h : int) (rf : W256.t list) : 0 <= h < 2 =>
  rfinv P h ip3 rf =>
  rfinv (ireduce_level P 4) h ip4
    (rfibf [0;4;1;5;2;6;3;7]
      (ziv (256 + 392 * h)) (ziv (256 + 392 * h)) (ziv (288 + 392 * h)) (ziv (288 + 392 * h))
      (rfshuf sh2 5 7 (rfshuf sh2 1 3 (rfshuf sh2 4 6 (rfshuf sh2 0 2 rf))))).
proof.
move=> rgh hinv; apply: (ibf_inv _ _ _ _ _ _ _ _ _ _ rgh _ perm_a2 (ichk4 h rgh)); first done.
rewrite -ip4P; do 4! (apply shuf_inv; [by [] | by [] | by [] | by [] |]).
exact hinv.
qed.

lemma ilvl5 (P : wpoly) (h : int) (rf : W256.t list) : 0 <= h < 2 =>
  rfinv P h ip4 rf =>
  rfinv (ireduce_level P 5) h ip5
    (rfibf [0;1;2;3;4;5;6;7]
      (ziv (320 + 392 * h)) (ziv (320 + 392 * h)) (ziv (352 + 392 * h)) (ziv (352 + 392 * h))
      (rfshuf sh4 3 7 (rfshuf sh4 2 6 (rfshuf sh4 1 5 (rfshuf sh4 0 4 rf))))).
proof.
move=> rgh hinv; apply: (ibf_inv _ _ _ _ _ _ _ _ _ _ rgh _ perm_id8 (ichk5 h rgh)); first done.
rewrite -ip5P; do 4! (apply shuf_inv; [by [] | by [] | by [] | by [] |]).
exact hinv.
qed.

lemma ilvl6 (P : wpoly) (h : int) (rf : W256.t list) : 0 <= h < 2 =>
  rfinv P h ip5 rf =>
  rfinv (ireduce_level P 6) h ip6
    (rfibf [0;2;4;6;1;3;5;7]
      (zib (384 + 392 * h)) (zib (384 + 392 * h)) (zib (388 + 392 * h)) (zib (388 + 392 * h))
      (rfshuf sh8 6 7 (rfshuf sh8 4 5 (rfshuf sh8 2 3 (rfshuf sh8 0 1 rf))))).
proof.
move=> rgh hinv; apply: (ibf_inv _ _ _ _ _ _ _ _ _ _ rgh _ perm_a3 (ichk6 h rgh)); first done.
rewrite -ip6P; do 4! (apply shuf_inv; [by [] | by [] | by [] | by [] |]).
exact hinv.
qed.

end MLKEM_invntt_levelsT.
