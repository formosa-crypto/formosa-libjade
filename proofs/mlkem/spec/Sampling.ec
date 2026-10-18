(* General EC imports *)
require import AllCore List.
require import IntDiv.

from Jasmin require import JWord.

from JazzEC require import Array25 Array32 Array128 Array168 Array256.

(* Imports of "lower-level" MLKEM spec parts *)
require import GFq.
import Zq.
require import Rq.

require import Symmetric.
require import Serialization.

module SampleNTT(XOF : XOF_t) = {
  proc sample() : poly = {
    var j, b168, bi, bi1, bi2, d1, d2,k;
    var aa : poly;
    aa <- witness;
    j <- 0;
    while (j < 256) {
      b168 <@ XOF.next_bytes();
      k <- 0;
      while ((j < 256) && (k < 168)) {
        bi  <- b168.[k];
        bi1 <- b168.[k+1];
        bi2 <- b168.[k+2];
        k <- k + 3;
        d1 <- to_uint bi        + 256 * (to_uint bi1 %% 16);
        d2 <- to_uint bi1 %/ 16 + 16  *  to_uint bi2;
        if (d1 < q)                { aa.[j] <- incoeff d1; j <- j + 1; }
          if ((d2 < q) && (j < 256)) { aa.[j] <- incoeff d2; j <- j + 1; }
      }
    }
    return aa;
  }
}.


(* FIPS 203, Algorithm 8 (SamplePolyCBD_eta): the coefficient i is the
   difference of the sums of the bits 2 i eta .. 2 i eta + eta - 1 and
   2 i eta + eta .. 2 i eta + 2 eta - 1 of the 64 eta input bytes *)
module SamplePolyCBD = {
  proc sample(eta_ : int, bytes : W8.t list) : poly = {
    var i, j, x, y, bits;
    var rr : poly;
    rr <- witness;
    bits <- BytesToBits bytes;
    i <- 0;
    while (i < 256) {
      x <- 0;
      y <- 0;
      j <- 0;
      while (j < eta_) {
        x <- x + b2i (nth false bits (2 * i * eta_ + j));
        y <- y + b2i (nth false bits (2 * i * eta_ + eta_ + j));
        j <- j + 1;
      }
      rr.[i] <- incoeff (x - y);
      i <- i + 1;
    }
    return rr;
  }
}.

proc op samplePolyCBD = SamplePolyCBD.sample. (* The functional lift *)
