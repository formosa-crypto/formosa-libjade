(* -------------------------------------------------------------------- *)
require import AllCore List IntDiv JWordExtra CircuitBindings.
from JazzEC require import Array25.

from Jasmin require import JWord.

(* -------------------------------------------------------------------- *)
export Array25.

(* -------------------------------------------------------------------- *)
clone export PAE with
      op size <- 25,
  theory A    <- Array25.

(* -------------------------------------------------------------------- *)
clone BSA as BSA25 with
      op size <- 25,
  theory A    <- Array25

  proof gt0_size by done.

(* -------------------------------------------------------------------- *)
clone BSWA as BSWA_25u64 with
      op asize <- 25,
      op bsize <- 64,
  theory A     <- Array25,
  theory BSA   <- BSA25,
  theory W     <- W64 { rename "_XX" as "_64" },
  theory WE    <- WE64,
  theory BSW   <- BSW64.

(* -------------------------------------------------------------------- *)
clone BSWAS as BSWAS_25u64_128 with
      op asize   <- 25,
      op bsize   <- 64,
      op ssize   <- 128,
  theory A       <- Array25,
  theory BSA     <- BSA25,
  theory WB      <- W64  { rename "_XX" as "_64" },
  theory WEB     <- WE64,
  theory BSWB    <- BSW64,
  theory WS      <- W128  { rename "_XX" as "_128" },
  theory WES     <- WE128,
  theory BSWS    <- BSW128,
  theory BSWA    <- BSWA_25u64

  proof le_size by done.

from JazzEC require import WArray200.
require import BitEncoding.
import Array25 BitChunking.

lemma BSWAS_25u64_128_slicesetE (t : W64.t Array25.t) o (s : W128.t) :
  0 <= (o*8) <= 64 * 25 - 128 =>
   BSWAS_25u64_128.sliceset t (o*8) s =
      Array25.init
        (get64 (set128_direct (WArray200.init64 (fun (i_0 : int) => t.[i_0])) o s)).
proof.
move => Ho.
rewrite tP => k kb.
rewrite wordP => i ib;rewrite initiE 1:/# /=.
have //= :=
  BSWAS_25u64_128.BVA_asliceset_Top_CircuitBindings_BSWAS_WB_t_Top_CircuitBindings_BSWAS_WS_t_Top_CircuitBindings_BSWAS_A_t.bvaslicesetP
    t (o*8) s _ (k*64+i) _; 1,2: by smt().
rewrite (nth_flatten false 64).
+ rewrite allP /= => x; rewrite mapP => He; elim He;smt(W64.size_w2bits').
rewrite (nth_map witness); 1: by rewrite size_to_list; smt().
rewrite get_to_list get_w2bits (: (k * 64 + i) %/ 64 = k) 1:/#.
rewrite (: (k * 64 + i) %% 64 = i) 1:/# => -> .
rewrite (nth_flatten false 64).
+ rewrite allP /= => x; rewrite mapP => He; elim He;smt(W64.size_w2bits').
rewrite (nth_map witness); 1: by rewrite size_to_list; smt().
rewrite get_w2bits get_to_list get64E pack8E initiE 1:/# /= /set128_direct initiE 1:/# /=.
rewrite /(\bits8) initiE 1:/# /= /init64 initiE 1:/# /=.
by smt(W8.initiE).
qed.
