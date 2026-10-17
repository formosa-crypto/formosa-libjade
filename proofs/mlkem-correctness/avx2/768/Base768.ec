(* The ML-KEM-768 bundle: the specification instance and the model instance *)
require import AllCore.
from Spec require Spec768.
require BaseT Jkem768I.

clone BaseT.BaseT as Base768 with
  theory S <- Spec768.MLKEM768,
  theory R <- Jkem768I.Jkem768I.
