(* -------------------------------------------------------------------- *)
require import AllCore.

(* -------------------------------------------------------------------- *)
from Jasmin require import JWord.

require import JWordExtra CircuitBindings.

(* -------------------------------------------------------------------- *)
clone export BitWordSH as W3 with
    op size <- 3
    rename "_XX" as "_3"
    proof gt0_size by done,
          size_le_256 by done.

clone WE as WE3 with
  op     size <- 3,
  theory W    <- W3 { rename "_XX" as "_3" }.

clone BSW as BSW3 with
  op     size <- 3,
  theory W    <- W3  { rename "_XX" as "_3" },
  theory WE   <- WE3 { rename "_XX" as "_3" }.

clone BS_WB_WS_U as BS_W32_W3_U with
        op sizeS <- 3,
        op sizeB <- 32,
    theory WS    <- W3  { rename "_XX" as "_3" },
    theory WSE   <- WE3,
    theory WB    <- W32  { rename "_XX" as "_32" },
    theory WBE   <- WE32,
    theory BSWS  <- BSW3,
    theory BSWB  <- BSW32

    rename "'S" as "3"
    rename "'B" as "32"

    proof le_size by done, *.
