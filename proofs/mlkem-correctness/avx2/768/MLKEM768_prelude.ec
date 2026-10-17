(* The ML-KEM-768 instance of the specification and its properties, for the
   avx2 correctness proofs: requiring this file brings its names in scope. *)
require import AllCore.
from Spec require import Spec768.
export MLKEM768.

lemma kvec_val : kvec = 3 by done.
