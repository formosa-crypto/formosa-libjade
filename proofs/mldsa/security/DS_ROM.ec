require import AllCore List Distr PROM.

(* Signatures with leakage, in the ROM with two random oracles *)
abstract theory DS_ROM_x2.

type pkey.
type skey.
type msg.
type sig.
type leakage.

clone import FullRO as RO1.
clone import FullRO as RO2.

module type Oracle1 = {
  include RO1.FRO [init, get]
}.

module type POracle1 = {
  include RO1.FRO [get]
}.

module type Oracle2 = {
  include RO2.FRO [init, get]
}.

module type POracle2 = {
  include RO2.FRO [get]
}.

module type Scheme(H1 : POracle1, H2 : POracle2) = {
  proc keygen() : pkey * skey
  proc sign(sk : skey, m : msg) : sig option * leakage
  proc verify(pk : pkey, m : msg, s : sig) : bool
}.

module type SOracle = {
  proc sign(m : msg) : sig option * leakage
}.

module type Adversary(H1 : POracle1, H2 : POracle2, O : SOracle) = {
  proc forge(pk : pkey) : msg * sig
}.

module EUF_CMA(H1 : Oracle1, H2 : Oracle2, S : Scheme, A : Adversary) = {
  var sk : skey
  var qs : msg list

  module O = {
    proc sign(m : msg) : sig option * leakage = {
      var r;
      qs <- m :: qs;
      r <@ S(H1, H2).sign(sk, m);
      return r;
    }
  }

  module A = A(H1, H2, O)

  proc main() : bool = {
    var pk, m, s, b;
    H1.init();
    H2.init();
    qs <- [];
    (pk, sk) <@ S(H1, H2).keygen();
    (m, s) <@ A.forge(pk);
    b <@ S(H1, H2).verify(pk, m, s);
    return b /\ !(m \in qs);
  }
}.

end DS_ROM_x2.

(* Signatures with leakage, in the ROM with five random oracles *)
abstract theory DS_ROM_x5.

type pkey.
type skey.
type msg.
type sig.
type leakage.

clone import FullRO as RO1.
clone import FullRO as RO2.
clone import FullRO as RO3.
clone import FullRO as RO4.
clone import FullRO as RO5.

module type Oracle1 = { include RO1.FRO [init, get] }.
module type Oracle2 = { include RO2.FRO [init, get] }.
module type Oracle3 = { include RO3.FRO [init, get] }.
module type Oracle4 = { include RO4.FRO [init, get] }.
module type Oracle5 = { include RO5.FRO [init, get] }.

module type POracle1 = { include RO1.FRO [get] }.
module type POracle2 = { include RO2.FRO [get] }.
module type POracle3 = { include RO3.FRO [get] }.
module type POracle4 = { include RO4.FRO [get] }.
module type POracle5 = { include RO5.FRO [get] }.

module type Scheme(H1 : POracle1, H2 : POracle2, H3 : POracle3, H4 : POracle4, H5 : POracle5) = {
  proc keygen() : pkey * skey
  proc sign(sk : skey, m : msg) : sig option * leakage
  proc verify(pk : pkey, m : msg, s : sig) : bool
}.

module type SOracle = {
  proc sign(m : msg) : sig option * leakage
}.

module type Adversary(H1 : POracle1, H2 : POracle2, H3 : POracle3, H4 : POracle4, H5 : POracle5,
                      O : SOracle) = {
  proc forge(pk : pkey) : msg * sig
}.

module EUF_CMA(H1 : Oracle1, H2 : Oracle2, H3 : Oracle3, H4 : Oracle4, H5 : Oracle5,
               S : Scheme, A : Adversary) = {
  var sk : skey
  var qs : msg list

  module O = {
    proc sign(m : msg) : sig option * leakage = {
      var r;
      qs <- m :: qs;
      r <@ S(H1, H2, H3, H4, H5).sign(sk, m);
      return r;
    }
  }

  module A = A(H1, H2, H3, H4, H5, O)

  proc main() : bool = {
    var pk, m, s, b;
    H1.init();
    H2.init();
    H3.init();
    H4.init();
    H5.init();
    qs <- [];
    (pk, sk) <@ S(H1, H2, H3, H4, H5).keygen();
    (m, s) <@ A.forge(pk);
    b <@ S(H1, H2, H3, H4, H5).verify(pk, m, s);
    return b /\ !(m \in qs);
  }
}.

end DS_ROM_x5.
