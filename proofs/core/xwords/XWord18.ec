(* -------------------------------------------------------------------- *)
require import AllCore.

(* -------------------------------------------------------------------- *)
from Jasmin require import JWord.

require import JWordExtra CircuitBindings.

(* -------------------------------------------------------------------- *)
clone export BitWordSH as W18 with
    op size <- 18
    rename "_XX" as "_18"
    proof gt0_size by done,
          size_le_256 by done.

clone WE as WE18 with
  op     size <- 18,
  theory W    <- W18 { rename "_XX" as "_18" }.

clone BSW as BSW18 with
  op     size <- 18,
  theory W    <- W18  { rename "_XX" as "_18" },
  theory WE   <- WE18 { rename "_XX" as "_18" }.

clone BS_WB_WS_U as BS_W32_W18_U with
        op sizeS <- 18,
        op sizeB <- 32,
    theory WS    <- W18  { rename "_XX" as "_18" },
    theory WSE   <- WE18,
    theory WB    <- W32  { rename "_XX" as "_32" },
    theory WBE   <- WE32,
    theory BSWS  <- BSW18,
    theory BSWB  <- BSW32

    rename "'S" as "18"
    rename "'B" as "32"

    proof le_size by done, *.
