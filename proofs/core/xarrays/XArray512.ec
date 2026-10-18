(* -------------------------------------------------------------------- *)
require import AllCore List IntDiv JWordExtra CircuitBindings.
from JazzEC require import Array512.
require import XWord10 XWord12.

from Jasmin require import JWord.

(* -------------------------------------------------------------------- *)
export Array512.

(* -------------------------------------------------------------------- *)
clone export PAE with
      op size <- 512,
  theory A    <- Array512.

(* -------------------------------------------------------------------- *)
clone BSA as BSA512 with
      op size <- 512,
  theory A    <- Array512

  proof gt0_size by done.

(* -------------------------------------------------------------------- *)
clone BSWA as BSWA_512u16 with
      op asize <- 512,
      op bsize <- 16,
  theory A     <- Array512,
  theory BSA   <- BSA512,
  theory W     <- W16 { rename "_XX" as "_16" },
  theory WE    <- WE16,
  theory BSW   <- BSW16.

(* -------------------------------------------------------------------- *)
clone BSWA as BSWA_512u12 with
      op asize <- 512,
      op bsize <- 12,
  theory A     <- Array512,
  theory BSA   <- BSA512,
  theory W     <- W12 { rename "_XX" as "_12" },
  theory WE    <- WE12,
  theory BSW   <- BSW12.

(* -------------------------------------------------------------------- *)
clone BSWA as BSWA_512u10 with
      op asize <- 512,
      op bsize <- 10,
  theory A     <- Array512,
  theory BSA   <- BSA512,
  theory W     <- W10 { rename "_XX" as "_10" },
  theory WE    <- WE10,
  theory BSW   <- BSW10.

(* -------------------------------------------------------------------- *)
clone BSWAS as BSWAS_512u16_256 with
      op asize   <- 512,
      op bsize   <- 16,
      op ssize   <- 256,
  theory A       <- Array512,
  theory BSA     <- BSA512,
  theory WB      <- W16  { rename "_XX" as "_16" },
  theory WEB     <- WE16,
  theory BSWB    <- BSW16,
  theory WS      <- W256  { rename "_XX" as "_256" },
  theory WES     <- WE256,
  theory BSWS    <- BSW256,
  theory BSWA    <- BSWA_512u16

  proof le_size by done.

from JazzEC require import WArray1024.
require import BitEncoding.
import Array512 BitChunking.

lemma BSWAS_512u16_256_slicegetE o (p : W16.t Array512.t):
    0 <= o*8 <= 512*16-256 =>
     get256_direct (WArray1024.init16 (fun (i_0 : int) => p.[i_0])) o = BSWAS_512u16_256.sliceget p (o * 8).
  proof.
  move => Ho.
  rewrite /get256_direct /pack32_t;apply W256.wordP => k kb.
  have //= := BSWAS_512u16_256.BVA_asliceget_Top_CircuitBindings_BSWAS_WB_t_Top_CircuitBindings_BSWAS_WS_t_Top_CircuitBindings_BSWAS_A_t.bvaslicegetP p (o * 8) _; 1: by smt().
  move => -> //; rewrite initiE 1:/# /= initiE 1:/# /= initiE 1:/# /= /(\bits8) initiE 1:/# /=.
  rewrite nth_take 1,2:/# nth_drop 1,2:/#  (nth_flatten false 16).
  + rewrite allP /= => x; rewrite mapP => He; elim He;smt(W16.size_w2bits).
  rewrite (nth_map witness); 1: by rewrite size_to_list; smt().
  by rewrite get_to_list get_w2bits /#.
 qed.

lemma BSWAS_512u16_256_slicesetE (t : W16.t Array512.t) o (s : W256.t) :
  0 <= (o*8) <= 16 * 512 - 256 =>
   BSWAS_512u16_256.sliceset t (o*8) s =
      Array512.init (get16 (set256_direct (WArray1024.init16 (fun (i_0 : int) => t.[i_0])) o s)).
proof.
move => Ho.
rewrite tP => k kb.
rewrite wordP => i ib;rewrite initiE 1:/# /=.
have //= := BSWAS_512u16_256.BVA_asliceset_Top_CircuitBindings_BSWAS_WB_t_Top_CircuitBindings_BSWAS_WS_t_Top_CircuitBindings_BSWAS_A_t.bvaslicesetP t (o*8) s _ (k*16+i) _;1,2:by smt().
rewrite (nth_flatten false 16).
+ rewrite allP /= => x; rewrite mapP => He; elim He;smt(W16.size_w2bits).
rewrite (nth_map witness); 1: by rewrite size_to_list; smt().
rewrite get_to_list get_w2bits (: (k * 16 + i) %/ 16 = k) 1:/# (: (k * 16 + i) %% 16 = i) 1:/# => -> .
rewrite (nth_flatten false 16).
+ rewrite allP /= => x; rewrite mapP => He; elim He;smt(W16.size_w2bits).
rewrite (nth_map witness); 1: by rewrite size_to_list; smt().
rewrite get_w2bits get_to_list get16E pack2E initiE 1:/# /= /set256_direct initiE 1:/# /= /(\bits8) initiE 1:/# /= /init16 initiE 1:/# /=.
by smt(W8.initiE).
qed.
