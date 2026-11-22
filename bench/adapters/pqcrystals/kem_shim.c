/* pq-crystals Kyber KEM adapter -> common derand ABI.
 *
 * Kyber exposes the deterministic supercop API directly. Parameter set is
 * selected by -DKYBER_K (2/3/4 -> ML-KEM-512/768/1024); the headers map the
 * crypto_kem_* and internal names onto the KYBER_NAMESPACE symbols.
 * randombytes is referenced only by the unused non-derand keypair/enc.
 *
 * Kyber performs neither FIPS 203 input check. The adapter adds them, built
 * from Kyber's own primitives, so that kem_enc_derand / kem_dec do the work
 * the standard asks for, as in the other backends. */
#include "common_abi.h"
#include "kem.h"
#include "polyvec.h"
#include "symmetric.h"
#include "verify.h"

/* Modulus check (FIPS 203, 7.2): decoding the key, reducing the coefficients
 * and encoding them again gives the key back. */
int kem_check_pk(const uint8_t *pk) {
  polyvec t;
  uint8_t enc[KYBER_POLYVECBYTES];
  polyvec_frombytes(&t, pk);
  polyvec_reduce(&t);
  polyvec_tobytes(enc, &t);
  return verify(pk, enc, KYBER_POLYVECBYTES) ? -1 : 0;
}

/* Hash check (FIPS 203, 7.3): the key holds the hash of the encapsulation
 * key it contains. */
int kem_check_sk(const uint8_t *sk) {
  uint8_t h[KYBER_SYMBYTES];
  hash_h(h, sk + KYBER_INDCPA_SECRETKEYBYTES, KYBER_PUBLICKEYBYTES);
  return verify(h, sk + KYBER_SECRETKEYBYTES - 2 * KYBER_SYMBYTES,
                KYBER_SYMBYTES) ? -1 : 0;
}

int kem_keypair_derand(uint8_t *pk, uint8_t *sk, const uint8_t *coins) {
  return crypto_kem_keypair_derand(pk, sk, coins);
}
int kem_enc_derand(uint8_t *ct, uint8_t *ss, const uint8_t *pk,
                   const uint8_t *coins) {
  if (kem_check_pk(pk)) return -1;
  return crypto_kem_enc_derand(ct, ss, pk, coins);
}
int kem_dec(uint8_t *ss, const uint8_t *ct, const uint8_t *sk) {
  if (kem_check_sk(sk)) return -1;
  return crypto_kem_dec(ss, ct, sk);
}
