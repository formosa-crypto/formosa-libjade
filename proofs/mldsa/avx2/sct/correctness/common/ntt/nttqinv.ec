(**
  The twisted zeta tables of the AVX2 NTTs: entry by entry, each *_QINV
  table is the twisted form (zeta * q^-1 mod 2^32, Avx2red.twist) of the
  zeta table it goes with, as is the second entry of each pair of the
  constant tables of the outer layers. Checked by evaluation on the
  constant indices.
*)
require import AllCore List List_extra IntDiv.
from Jasmin require import JWord JModel_x86.
require import MldsaConstants.
require import Array2 Array4 Array6 Array8 Array16.
require import Avx2red Listred.

(* -------------------------------------------------------------------- *)
lemma qinv5E (i : int) : 0 <= i < 4 =>
  lAYER_5_ZETAS_QINV.[i] = twistv lAYER_5_ZETAS.[i].
proof.
move: i; apply/allP_range; rewrite /range -iotaredE /= /twistv.
by do! split; apply W8u32.allP => /=; do! split;
  rewrite !W8u32.of_int_bits32_div // /twist W32.of_intM;
  apply W32.to_uint_eq; rewrite !W32.of_uintK.
qed.

(* -------------------------------------------------------------------- *)
lemma qinv4E (i : int) : 0 <= i < 8 =>
  lAYER_4_ZETAS_QINV.[i] = twistv lAYER_4_ZETAS.[i].
proof.
move: i; apply/allP_range; rewrite /range -iotaredE /= /twistv.
by do! split; apply W8u32.allP => /=; do! split;
  rewrite !W8u32.of_int_bits32_div // /twist W32.of_intM;
  apply W32.to_uint_eq; rewrite !W32.of_uintK.
qed.

(* -------------------------------------------------------------------- *)
lemma qinv3E (i : int) : 0 <= i < 16 =>
  lAYER_3_ZETAS_QINV.[i] = twistv lAYER_3_ZETAS.[i].
proof.
move: i; apply/allP_range; rewrite /range -iotaredE /= /twistv.
by do! split; apply W8u32.allP => /=; do! split;
  rewrite !W8u32.of_int_bits32_div // /twist W32.of_intM;
  apply W32.to_uint_eq; rewrite !W32.of_uintK.
qed.

(* -------------------------------------------------------------------- *)
lemma qinv2E (i : int) : 0 <= i < 16 =>
  lAYER_2_ZETAS_QINV.[i] = twistv lAYER_2_ZETAS.[i].
proof.
move: i; apply/allP_range; rewrite /range -iotaredE /= /twistv.
by do! split; apply W8u32.allP => /=; do! split;
  rewrite !W8u32.of_int_bits32_div // /twist W32.of_intM;
  apply W32.to_uint_eq; rewrite !W32.of_uintK.
qed.

(* -------------------------------------------------------------------- *)
lemma qinv1E (i : int) : 0 <= i < 16 =>
  lAYER_1_ZETAS_QINV.[i] = twistv lAYER_1_ZETAS.[i].
proof.
move: i; apply/allP_range; rewrite /range -iotaredE /= /twistv.
by do! split; apply W8u32.allP => /=; do! split;
  rewrite !W8u32.of_int_bits32_div // /twist W32.of_intM;
  apply W32.to_uint_eq; rewrite !W32.of_uintK.
qed.

(* -------------------------------------------------------------------- *)
lemma qinv0E (i : int) : 0 <= i < 16 =>
  lAYER_0_ZETAS_QINV.[i] = twistv lAYER_0_ZETAS.[i].
proof.
move: i; apply/allP_range; rewrite /range -iotaredE /= /twistv.
by do! split; apply W8u32.allP => /=; do! split;
  rewrite !W8u32.of_int_bits32_div // /twist W32.of_intM;
  apply W32.to_uint_eq; rewrite !W32.of_uintK.
qed.

(* -------------------------------------------------------------------- *)
lemma iqinv0E (i : int) : 0 <= i < 16 =>
  zETAS_TO_INVERT_LAYER_0_QINV.[i] = twistv zETAS_TO_INVERT_LAYER_0.[i].
proof.
move: i; apply/allP_range; rewrite /range -iotaredE /= /twistv.
by do! split; apply W8u32.allP => /=; do! split;
  rewrite !W8u32.of_int_bits32_div // /twist W32.of_intM;
  apply W32.to_uint_eq; rewrite !W32.of_uintK.
qed.

(* -------------------------------------------------------------------- *)
lemma iqinv1E (i : int) : 0 <= i < 16 =>
  zETAS_TO_INVERT_LAYER_1_QINV.[i] = twistv zETAS_TO_INVERT_LAYER_1.[i].
proof.
move: i; apply/allP_range; rewrite /range -iotaredE /= /twistv.
by do! split; apply W8u32.allP => /=; do! split;
  rewrite !W8u32.of_int_bits32_div // /twist W32.of_intM;
  apply W32.to_uint_eq; rewrite !W32.of_uintK.
qed.

(* -------------------------------------------------------------------- *)
lemma iqinv2E (i : int) : 0 <= i < 16 =>
  zETAS_TO_INVERT_LAYER_2_QINV.[i] = twistv zETAS_TO_INVERT_LAYER_2.[i].
proof.
move: i; apply/allP_range; rewrite /range -iotaredE /= /twistv.
by do! split; apply W8u32.allP => /=; do! split;
  rewrite !W8u32.of_int_bits32_div // /twist W32.of_intM;
  apply W32.to_uint_eq; rewrite !W32.of_uintK.
qed.

(* -------------------------------------------------------------------- *)
lemma iqinv3E (i : int) : 0 <= i < 16 =>
  zETAS_TO_INVERT_LAYER_3_QINV.[i] = twist zETAS_TO_INVERT_LAYER_3.[i].
proof.
move: i; apply/allP_range; rewrite /range -iotaredE /= /twist.
by do! split; rewrite W32.of_intM; apply W32.to_uint_eq; rewrite !W32.of_uintK.
qed.

(* -------------------------------------------------------------------- *)
lemma iqinv4E (i : int) : 0 <= i < 8 =>
  zETAS_TO_INVERT_LAYER_4_QINV.[i] = twist zETAS_TO_INVERT_LAYER_4.[i].
proof.
move: i; apply/allP_range; rewrite /range -iotaredE /= /twist.
by do! split; rewrite W32.of_intM; apply W32.to_uint_eq; rewrite !W32.of_uintK.
qed.

(* -------------------------------------------------------------------- *)
lemma iqinv5E (i : int) : 0 <= i < 4 =>
  zETAS_TO_INVERT_LAYER_5_QINV.[i] = twist zETAS_TO_INVERT_LAYER_5.[i].
proof.
move: i; apply/allP_range; rewrite /range -iotaredE /= /twist.
by do! split; rewrite W32.of_intM; apply W32.to_uint_eq; rewrite !W32.of_uintK.
qed.

(* -------------------------------------------------------------------- *)
lemma iqinv6E (i : int) : 0 <= i < 2 =>
  zETAS_TO_INVERT_LAYER_6_QINV.[i] = twist zETAS_TO_INVERT_LAYER_6.[i].
proof.
move: i; apply/allP_range; rewrite /range -iotaredE /= /twist.
by do! split; rewrite W32.of_intM; apply W32.to_uint_eq; rewrite !W32.of_uintK.
qed.

(* -------------------------------------------------------------------- *)
(* the root of layer 7, then its twisted form                           *)
lemma qinv7E : lAYERS_7_6_ZETAS.[1] = twist lAYERS_7_6_ZETAS.[0].
proof. by rewrite /twist /=. qed.

(* -------------------------------------------------------------------- *)
(* the roots of layer 6, each followed by its twisted form              *)
lemma qinv6LE : lAYERS_7_6_ZETAS.[3] = twist lAYERS_7_6_ZETAS.[2].
proof. by rewrite /twist /=. qed.

(* -------------------------------------------------------------------- *)
lemma qinv6RE : lAYERS_7_6_ZETAS.[5] = twist lAYERS_7_6_ZETAS.[4].
proof. by rewrite /twist /=. qed.

(* -------------------------------------------------------------------- *)
(* zeta f and f, each followed by its twisted form                      *)
lemma iqinv7zE : iNVERSE_NTT_LAYER_7_CONSTANTS.[1] = twist iNVERSE_NTT_LAYER_7_CONSTANTS.[0].
proof. by rewrite /twist /=. qed.

(* -------------------------------------------------------------------- *)
lemma iqinv7fE : iNVERSE_NTT_LAYER_7_CONSTANTS.[3] = twist iNVERSE_NTT_LAYER_7_CONSTANTS.[2].
proof. by rewrite /twist /=. qed.
