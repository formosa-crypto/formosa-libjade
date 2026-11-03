/* mlkem-native KEM adapter: maps the deterministic supercop API onto the
 * common ABI. The parameter set / namespace / native backend are selected by
 * -DMLK_CONFIG_* flags at build time (see the bench Makefile); this file and
 * the monolithic mlkem_native.c are compiled with the same flags. */
#include "common_abi.h"
#include "mlkem_native.h"

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
int kem_check_pk(const uint8_t *pk) { return crypto_kem_check_pk(pk); }
int kem_check_sk(const uint8_t *sk) { return crypto_kem_check_sk(sk); }
