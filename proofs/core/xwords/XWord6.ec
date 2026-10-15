(* -------------------------------------------------------------------- *)
require import AllCore.

(* -------------------------------------------------------------------- *)
from Jasmin require import JWord.

require import JWordExtra CircuitBindings.

(* -------------------------------------------------------------------- *)
clone export BitWordSH as W6 with
    op size <- 6
    rename "_XX" as "_6"
    proof gt0_size by done,
          size_le_256 by done.

clone WE as WE6 with
  op     size <- 6,
  theory W    <- W6 { rename "_XX" as "_6" }.

clone BSW as BSW6 with
  op     size <- 6,
  theory W    <- W6  { rename "_XX" as "_6" },
  theory WE   <- WE6 { rename "_XX" as "_6" }.

clone BS_WB_WS_U as BS_W32_W6_U with
        op sizeS <- 6,
        op sizeB <- 32,
    theory WS    <- W6  { rename "_XX" as "_6" },
    theory WSE   <- WE6,
    theory WB    <- W32  { rename "_XX" as "_32" },
    theory WBE   <- WE32,
    theory BSWS  <- BSW6,
    theory BSWB  <- BSW32

    rename "'S" as "6"
    rename "'B" as "32"

    proof le_size by done, *.
