(* The prelude of the AVX2 proof at the ML-KEM-1024 parameters and model:
   the lifting of the Jasmin arrays and the bound predicates. The files
   that only reason on the model (the circuit semantics) require this
   instance rather than the whole tower of Instances1024. *)
require import AllCore.
require Base1024 PreludeT.

clone export PreludeT.PreludeT as PreludeI with
  theory B <- Base1024.Base1024.
