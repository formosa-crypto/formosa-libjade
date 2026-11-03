(* General EC imports *)
from Jasmin require import JWord.

from JazzEC require import Array32.

require import Symmetric.
require import KPKE.

(* ------------------------------------------------------------------ *)
(* FIPS-203 ML-KEM (the FO/KEM layer over K-PKE), parametric over the
   parameters of ParamsT. *)
(* ------------------------------------------------------------------ *)
abstract theory MLKEMT.

clone include KPKET.

type publickey = pkey.
type secretkey = skey * pkey * W8.t Array32.t * W8.t Array32.t.
type sharedsecret = W8.t Array32.t.
(* ciphertext / plaintext are in scope from KPKE. *)

(* FIPS-203 7.2, modulus check: ByteEncode12(ByteDecode12(ek[0:384k])) = ek[0:384k] *)
op check_ek (pk : publickey) : bool =
  encode12_vec (toipolyvec (ofipolyvec (decode12_vec pk.`1))) = pk.`1.

(* FIPS-203 7.3, hash check: H(dk[384k:768k+32]) = dk[768k+32:768k+64] *)
op check_dk (sk : secretkey) : bool =
  H_pk sk.`2 = sk.`3.

(* the outputs when a check fails *)
op ct_zero : ciphertext = (BytesCtVec.create W8.zero, BytesPoly.create W8.zero).
op ss_zero : sharedsecret = Array32.create W8.zero.

module MLKEM = {

  proc keygen_internal(coins: W8.t Array32.t * W8.t Array32.t) : publickey * secretkey = {
    var kgs, z, pk, sk, hpk;
    kgs     <- coins.`1;
    z       <- coins.`2;
    (pk, sk) <@ KPKE.keygen(kgs);
    hpk     <- H_pk pk;
    return (pk, (sk, pk, hpk, z));
  }

  proc encaps_internal(pk : publickey, coins: W8.t Array32.t) : ciphertext * sharedsecret = {
    var m, hpk, r, c, _K;
    m       <- coins;
    hpk     <- H_pk pk;
    (_K, r) <- G_mhpk m hpk;
    c       <@ KPKE.encrypt(pk, m, r);
    return (c, _K);
  }

  proc decaps_internal(cph : ciphertext, sk : secretkey) : sharedsecret = {
    var m, _K', r, skp, pk, hpk, z, c, _K;
    (skp, pk, hpk, z) <- sk;
    m             <@ KPKE.decrypt(skp, cph);
    (_K, r)       <- G_mhpk m hpk;
    _K'           <- J z cph;
    c             <@ KPKE.encrypt(pk, m, r);
    if (c <> cph) {
      _K <- _K';
    }
    return _K;
  }

  proc encaps_derand(pk : publickey, coins: W8.t Array32.t) : bool * ciphertext * sharedsecret = {
    var b, c, _K;
    b       <- check_ek pk;
    (c, _K) <- (ct_zero, ss_zero);
    if (b) {
      (c, _K) <@ encaps_internal(pk, coins);
    }
    return (b, c, _K);
  }

  proc decaps(cph : ciphertext, sk : secretkey) : bool * sharedsecret = {
    var b, _K;
    b  <- check_dk sk;
    _K <- ss_zero;
    if (b) {
      _K <@ decaps_internal(cph, sk);
    }
    return (b, _K);
  }
}.

end MLKEMT.
