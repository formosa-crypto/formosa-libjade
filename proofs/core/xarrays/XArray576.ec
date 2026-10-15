(* -------------------------------------------------------------------- *)
require import AllCore List IntDiv JWordExtra JArrayExtra CircuitBindings.
from JazzEC require (*--*) Array576.

from Jasmin require import JWord.

(* -------------------------------------------------------------------- *)
export Array576.Array576.

(* -------------------------------------------------------------------- *)
clone export PAE with
      op size <- 576,
  theory A    <- Array576.Array576.

(* -------------------------------------------------------------------- *)
clone BSA as BSA576 with
      op size <- 576,
  theory A    <- Array576.Array576

  proof gt0_size by done.

(* -------------------------------------------------------------------- *)
clone BSWA as BSWA_576u8 with
      op asize <- 576,
      op bsize <- 8,
  theory A     <- Array576.Array576,
  theory BSA   <- BSA576,
  theory W     <- W8 { rename "_XX" as "_8" },
  theory WE    <- WE8,
  theory BSW   <- BSW8
  proof *.

(* -------------------------------------------------------------------- *)
clone BSWAS as BSWAS_576u8_128 with
      op asize   <- 576,
      op bsize   <- 8,
      op ssize   <- 128,
  theory A       <- Array576.Array576,
  theory BSA     <- BSA576,
  theory WB      <- W8  { rename "_XX" as "_8" },
  theory WEB     <- WE8,
  theory BSWB    <- BSW8,
  theory WS      <- W128  { rename "_XX" as "_128" },
  theory WES     <- WE128,
  theory BSWS    <- BSW128,
  theory BSWA    <- BSWA_576u8

  proof le_size by done.

from JazzEC require import WArray576.
require import BitEncoding.
import Array576 BitChunking.

lemma BSWAS_576u8_128_slicesetE (t : W8.t Array576.t) o (s : W128.t) :
  0 <= (o*8) <= 8 * 576 - 128 =>
   BSWAS_576u8_128.sliceset t (o*8) s =
      Array576.init (get8 (set128_direct (WArray576.init8 (fun (i_0 : int) => t.[i_0])) o s)).
proof.
move => Ho.
rewrite tP => k kb.
rewrite wordP => i ib;rewrite initiE 1:/# /=.
have //= := BSWAS_576u8_128.BVA_asliceset_Top_CircuitBindings_BSWAS_WB_t_Top_CircuitBindings_BSWAS_WS_t_Top_CircuitBindings_BSWAS_A_t.bvaslicesetP t (o*8) s _ (k*8+i) _;1,2:by smt().
rewrite (nth_flatten false 8).
+ rewrite allP /= => x; rewrite mapP => He; elim He;smt(W8.size_w2bits).
rewrite (nth_map witness); 1: by rewrite size_to_list; smt().
rewrite get_to_list get_w2bits (: (k * 8 + i) %/ 8 = k) 1:/# (: (k * 8 + i) %% 8 = i) 1:/# => -> .
rewrite (nth_flatten false 8).
+ rewrite allP /= => x; rewrite mapP => He; elim He;smt(W8.size_w2bits).
rewrite (nth_map witness); 1: by rewrite size_to_list; smt().
rewrite get_w2bits get_to_list /get8 /set128_direct initiE 1:/# /= /(\bits8) initiE 1:/# /=.
by smt(W8.initiE).
qed.

lemma BSWAS_576u8_128_slicegetE o (p : W8.t Array576.t):
    0 <= o*8 <= 576*8-128 =>
     get128_direct (WArray576.init8 (fun (i_0 : int) => p.[i_0])) o = BSWAS_576u8_128.sliceget p (o * 8).
  proof.
  move => Ho.
  rewrite /get128_direct /pack16_t;apply W128.wordP => k kb.
  have //= := BSWAS_576u8_128.BVA_asliceget_Top_CircuitBindings_BSWAS_WB_t_Top_CircuitBindings_BSWAS_WS_t_Top_CircuitBindings_BSWAS_A_t.bvaslicegetP p (o * 8) _; 1: by smt().
  move => -> //; rewrite initiE 1:/# /= initiE 1:/# /= initiE 1:/# /=.
  rewrite nth_take 1,2:/# nth_drop 1,2:/#  (nth_flatten false 8).
  + rewrite allP /= => x; rewrite mapP => He; elim He;smt(W8.size_w2bits).
  rewrite (nth_map witness); 1: by rewrite size_to_list; smt().
  by rewrite get_to_list get_w2bits /#.
 qed.
