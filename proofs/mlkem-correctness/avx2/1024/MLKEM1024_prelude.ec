(* The ML-KEM-1024 instance of the specification and its properties, for the
   avx2 correctness proofs: requiring this file brings its names in scope. *)
require import AllCore.
from Spec require import Spec1024.
export MLKEM1024.

lemma kvec_val : kvec = 4 by done.
