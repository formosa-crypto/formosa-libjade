/* pq-crystals Kyber KEM adapter -> common derand ABI.
 *
 * Kyber exposes the deterministic supercop API directly, so this is a
 * pass-through. Parameter set is selected by -DKYBER_K (2/3/4 ->
 * ML-KEM-512/768/1024); kem.h maps the crypto_kem_* names onto the
 * KYBER_NAMESPACE symbols. randombytes is referenced only by the unused
 * non-derand keypair/enc. Kyber performs neither FIPS 203 input check, so
 * kem_check_pk / kem_check_sk are not exported. */
#include "common_abi.h"
#include "kem.h"

int kem_keypair_derand(uint8_t *pk, uint8_t *sk, const uint8_t *coins) {
  return crypto_kem_keypair_derand(pk, sk, coins);
}
int kem_enc_derand(uint8_t *ct, uint8_t *ss, const uint8_t *pk,
                   const uint8_t *coins) {
  return crypto_kem_enc_derand(ct, ss, pk, coins);
}
int kem_dec(uint8_t *ss, const uint8_t *ct, const uint8_t *sk) {
  return crypto_kem_dec(ss, ct, sk);
}
