(* The ML-KEM-1024 bundle: the specification instance and the model instance *)
require import AllCore.
from Spec require Spec1024.
require BaseT Jkem1024I.

clone BaseT.BaseT as Base1024 with
  theory S <- Spec1024.MLKEM1024,
  theory R <- Jkem1024I.Jkem1024I.
