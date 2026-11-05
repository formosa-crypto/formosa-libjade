(* -------------------------------------------------------------------- *)
require import AllCore List IntDiv JWordExtra CircuitBindings.
from JazzEC require import Array200.

from Jasmin require import JWord.

(* -------------------------------------------------------------------- *)
export Array200.

(* -------------------------------------------------------------------- *)
clone export PAE with
      op size <- 200,
  theory A    <- Array200.

(* -------------------------------------------------------------------- *)
clone BSA as BSA200 with
      op size <- 200,
  theory A    <- Array200

  proof gt0_size by done.

(* -------------------------------------------------------------------- *)
clone BSWA as BSWA_200u8 with
      op asize <- 200,
      op bsize <- 8,
  theory A     <- Array200,
  theory BSA   <- BSA200,
  theory W     <- W8 { rename "_XX" as "_8" },
  theory WE    <- WE8,
  theory BSW   <- BSW8
  proof *.

(* -------------------------------------------------------------------- *)
clone BSWAS as BSWAS_200u8_256 with
      op asize <- 200, op bsize <- 8, op ssize <- 256,
  theory A    <- Array200, theory BSA <- BSA200,
  theory WB   <- W8   { rename "_XX" as "_8" }, theory WEB <- WE8, theory BSWB <- BSW8,
  theory WS   <- W256 { rename "_XX" as "_256" }, theory WES <- WE256, theory BSWS <- BSW256,
  theory BSWA <- BSWA_200u8
  proof le_size by done.

from JazzEC require import WArray200.
require import BitEncoding.
import Array200 BitChunking.

lemma BSWAS_200u8_256_slicegetE o (p : W8.t Array200.t):
    0 <= o*8 <= 200*8-256 =>
     get256_direct (WArray200.init8 (fun (i_0 : int) => p.[i_0])) o = BSWAS_200u8_256.sliceget p (o * 8).
  proof.
  move => Ho.
  rewrite /get256_direct /pack32_t;apply W256.wordP => k kb.
  have //= := BSWAS_200u8_256.BVA_asliceget_Top_CircuitBindings_BSWAS_WB_t_Top_CircuitBindings_BSWAS_WS_t_Top_CircuitBindings_BSWAS_A_t.bvaslicegetP p (o * 8) _; 1: by smt().
  move => -> //; rewrite initiE 1:/# /= initiE 1:/# /= initiE 1:/# /=.
  rewrite nth_take 1,2:/# nth_drop 1,2:/#  (nth_flatten false 8).
  + rewrite allP /= => x; rewrite mapP => He; elim He;smt(W8.size_w2bits').
  rewrite (nth_map witness); 1: by rewrite size_to_list; smt().
  by rewrite get_to_list get_w2bits /#.
 qed.
