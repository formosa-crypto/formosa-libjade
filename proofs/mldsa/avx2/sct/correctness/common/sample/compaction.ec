(* -------------------------------------------------------------------- *)
(* The compaction index table shared by the ML-DSA rejection samplers:  *)
(* row m (bytes 8m .. 8m+7) lists the positions of the set bits of the  *)
(* 8-bit mask m, then zeros. The rows are checked on the 256 masks once *)
(* (rows_ok, on integers); the two compactions follow, for any table    *)
(* with these rows:                                                     *)
(*   - shuffle_compact8: as a VPSHUFB control, the row packs the bytes  *)
(*     selected by m to the front (error vector sampler);               *)
(*   - permd_compact: widened by VPMOVZX, as a VPERMD index vector, the *)
(*     row packs the dwords selected by m (matrix A sampler).           *)
(* The table is a literal of 2048 bytes: the proofs keep it abstract    *)
(* away from the check of its rows.                                     *)
(* -------------------------------------------------------------------- *)
require import AllCore List List_extra IntDiv BitEncoding.
import BS2Int.

from Jasmin require import JWord JModel_x86.
require import MldsaConstants.

require import Avx2red.
require import Array2048 WArray2048.

(* -------------------------------------------------------------------- *)
(* the positions of the true entries of bs, in increasing order         *)
op positions (bs : bool list) : int list =
  with bs = [] => []
  with bs = b :: bs' => (if b then [0] else []) ++ map ((+) 1) (positions bs').

lemma positions_rng (bs : bool list) (i : int) :
  i \in positions bs => 0 <= i < size bs.
proof.
elim: bs i => //= b bs ih i; rewrite mem_cat => -[|].
- by case: b => //=; smt(size_ge0).
by move=> /mapP [j [/ih hj ->]] /#.
qed.

lemma size_positions (bs : bool list) : size (positions bs) = count idfun bs.
proof. by elim: bs => //= b bs ih; rewrite size_cat size_map ih /idfun; case: b. qed.

(* masking is picking at the positions                                  *)
lemma mask_positions ['a] (x0 : 'a) (bs : bool list) (xs : 'a list) :
  size bs = size xs => mask bs xs = map (nth x0 xs) (positions bs).
proof.
elim: xs bs => [|x xs ih] [|b bs] //=.
- smt(size_ge0).
move=> hsz; rewrite map_cat -map_comp.
have -> : map (nth x0 (x :: xs) \o (+) 1) (positions bs) = map (nth x0 xs) (positions bs).
- apply eq_in_map => i /positions_rng hi @/(\o) /=.
  by rewrite (_ : 1 + i <> 0) 1:/#.
by rewrite -(ih bs) 1:/#; case: b.
qed.

(* -------------------------------------------------------------------- *)
(* the entries of row m of a table, as integers                         *)
op row (t : W8.t Array2048.t) (m : int) : int list =
  map (fun j => to_uint t.[8 * m + j]) (iota_ 0 8).

(* a compaction table: row m starts with the positions of m, and all    *)
(* its entries are below 8                                              *)
op rows_ok (t : W8.t Array2048.t) =
  forall m, 0 <= m < 256 =>
       take (size (positions (int2bs 8 m))) (row t m) = positions (int2bs 8 m)
    /\ all (fun i => i < 8) (row t m).

lemma compaction_rows_ok : rows_ok cOMPACTION_INDEX_TABLE.
proof.
move=> m rgm; split; move: m rgm; apply/allP_range.
- by rewrite /range /row /int2bs /mkseq -iotaredE /=.
- by rewrite /range /row -!iotaredE /=.
qed.

(* -------------------------------------------------------------------- *)
(* picking the entries of xs at the indices of row m, and keeping as    *)
(* many as m has set bits, masks xs by m                                 *)
lemma take_compaction ['a] (t : W8.t Array2048.t) (x0 : 'a) (xs : 'a list)
    (m : int) (f : int -> 'a) :
  rows_ok t => 0 <= m < 256 => size xs = 8 =>
  (forall j, 0 <= j < 8 => f j = nth x0 xs (to_uint t.[8 * m + j])) =>
  take (count idfun (int2bs 8 m)) (map f (iota_ 0 8)) = mask (int2bs 8 m) xs.
proof.
move=> ht rgm szxs hf.
have -> : map f (iota_ 0 8) = map (nth x0 xs) (row t m).
- rewrite /row -map_comp; apply eq_in_map => j /mem_iota hj @/(\o) /=.
  by apply hf; smt().
have [hrow _] := ht m rgm.
rewrite -size_positions -map_take hrow.
by rewrite (mask_positions x0) // size_int2bs /#.
qed.

lemma row_lt8 (t : W8.t Array2048.t) (m j : int) :
  rows_ok t => 0 <= m < 256 => 0 <= j < 8 => to_uint t.[8 * m + j] < 8.
proof.
move=> ht rgm rgj; have [_] := ht m rgm; rewrite /row allP => /(_ (to_uint t.[8 * m + j])).
by apply; apply/mapP; exists j; rewrite mem_iota /#.
qed.

(* -------------------------------------------------------------------- *)
lemma truncateu64_128E (w : W128.t) : truncateu64 w = w \bits64 0.
proof.
apply: W64.ext_eq=> i rgi; rewrite bits64iE //=.
rewrite /truncateu64 of_intwE rgi /= /W64.int_bit.
rewrite modz_pow2_div ~-1://# modz_dvd.
- by rewrite -{1}[2]expr1 dvdz_exp2l /#.
- by rewrite -b2i_get /#.
qed.

hint simplify truncateu64_128E.

(* -------------------------------------------------------------------- *)
lemma VMOV_64_pack8E (b0 b1 b2 b3 b4 b5 b6 b7 : W8.t) :
  VMOV_64 (W8u8.pack8 [b0; b1; b2; b3; b4; b5; b6; b7])
  = W16u8.pack16 [b0; b1; b2; b3; b4; b5; b6; b7;
                  W8.zero; W8.zero; W8.zero; W8.zero;
                  W8.zero; W8.zero; W8.zero; W8.zero].
proof.
by apply W128.all_eq_eq; cbv W128.all_eq VMOV_64 W8u8.unpack8 W16u8.unpack8.
qed.

hint simplify VMOV_64_pack8E.

(* -------------------------------------------------------------------- *)
(* VPSHUFB: the error vector sampler packs the selected bytes           *)
lemma shuffle_compact8_gen (t : W8.t Array2048.t) (x : W128.t) (m : int) :
  rows_ok t => 0 <= m < 256 =>
    take (count idfun (int2bs 8 m))
      (W8u8.to_list (truncateu64 (VPSHUFB_128 x
        (VMOV_64 (W8u8.pack8 (Array2048.sub t (8 * m) 8))))))
  = mask (int2bs 8 m) (take 8 (W16u8.to_list x)).
proof.
move=> ht rgm.
rewrite (_ : W8u8.to_list _ = map (fun j => VPSHUFB_128_B x t.[8 * m + j]) (iota_ 0 8)).
- by rewrite /sub /mkseq -!iotaredE /=.
apply (take_compaction t W8.zero) => //.
move=> j rgj /=; have := row_lt8 t m j ht rgm rgj.
move: (t.[8 * m + j]) => b hb.
move: hb (W8.to_uint_cmp b); move: (to_uint b) => k hk [hk0 _].
rewrite ifF 1:/# pmod_small 1:/#.
have : k \in iota_ 0 8 by rewrite mem_iota /#.
by rewrite -iotaredE /= => -[|[|[|[|[|[|[|]]]]]]] ->.
qed.

lemma shuffle_compact8 (x : W128.t) (m : int) : 0 <= m < 256 =>
    take (count idfun (int2bs 8 m))
      (W8u8.to_list (truncateu64 (VPSHUFB_128 x
        (VMOV_64 (W8u8.pack8 (Array2048.sub cOMPACTION_INDEX_TABLE (8 * m) 8))))))
  = mask (int2bs 8 m) (take 8 (W16u8.to_list x)).
proof. exact (shuffle_compact8_gen _ x m compaction_rows_ok). qed.

(* -------------------------------------------------------------------- *)
lemma truncateu64_zeroextu128E (w : W64.t) : truncateu64 (zeroextu128 w) = w.
proof.
rewrite -(W64.to_uintK (truncateu64 (zeroextu128 w))).
rewrite W2u64.to_uint_truncateu64 W2u64.to_uint_zeroextu128.
by rewrite pmod_small 1:W64.to_uint_cmp W64.to_uintK.
qed.

(* lane j of VPERMD picks the dword of index byte j, modulo 8           *)
lemma VPERMD_VPMOVZX_E (x : W64.t) (cs : W32.t list) : size cs = 8 =>
    W8u32.to_list (VPERMD (VPMOVZX_8u8_8u32 x) (W8u32.pack8 cs))
  = map (fun j => nth W32.zero cs (to_uint (x \bits8 j) %% 8)) (iota_ 0 8).
proof.
move=> szcs; rewrite /VPMOVZX_8u8_8u32 /=.
rewrite -iotaredE /= /MOVZX_u32u8.
have h : forall (b : W8.t),
    W8u32.pack8 cs \bits32 (to_uint (W32.of_int (to_uint b)) %% 8)
  = nth W32.zero cs (to_uint b %% 8).
- move=> b; rewrite W32.of_uintK.
  rewrite (pmod_small (to_uint b)); 1: by have := W8.to_uint_cmp b; smt().
  by rewrite W8u32.pack8bE 1:/# W8u32.Pack.get_of_list 1:/#.
by rewrite !h.
qed.

(* VPERMD: the matrix A sampler packs the selected dwords               *)
lemma permd_compact_gen (t : W8.t Array2048.t) (cs : W32.t list) (m : int) :
  rows_ok t => size cs = 8 => 0 <= m < 256 =>
    take (count idfun (int2bs 8 m))
      (W8u32.to_list (VPERMD
        (VPMOVZX_8u8_8u32 (truncateu64 (zeroextu128
          (get64_direct (WArray2048.init8 (fun i => t.[i])) (8 * m)))))
        (W8u32.pack8 cs)))
  = mask (int2bs 8 m) cs.
proof.
move=> ht szcs rgm; rewrite truncateu64_zeroextu128E VPERMD_VPMOVZX_E //.
apply (take_compaction t W32.zero) => // j rgj /=.
have -> : WArray2048.get64 (WArray2048.init8 ("_.[_]" t)) m \bits8 j = t.[8 * m + j].
- rewrite WArray2048.get64E W8u8.pack8bE 1:// W8u8.Pack.initiE 1:// /=.
  by rewrite WArray2048.initiE 1:/#.
have := row_lt8 t m j ht rgm rgj; have := W8.to_uint_cmp t.[8 * m + j].
move: (to_uint t.[8 * m + j]) => k hk0 hk.
by rewrite pmod_small 1:/#.
qed.

lemma permd_compact (cs : W32.t list) (m : int) : size cs = 8 => 0 <= m < 256 =>
    take (count idfun (int2bs 8 m))
      (W8u32.to_list (VPERMD
        (VPMOVZX_8u8_8u32 (truncateu64 (zeroextu128
          (get64_direct (WArray2048.init8 (fun i => cOMPACTION_INDEX_TABLE.[i])) (8 * m)))))
        (W8u32.pack8 cs)))
  = mask (int2bs 8 m) cs.
proof. exact (permd_compact_gen _ cs m compaction_rows_ok). qed.
