(* The ML-KEM-512 bundle: the specification instance and the model instance *)
require import AllCore.
from Spec require Spec512.
require BaseT Jkem512I.

clone BaseT.BaseT as Base512 with
  theory S <- Spec512.MLKEM512,
  theory R <- Jkem512I.Jkem512I.
