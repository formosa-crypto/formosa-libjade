/* mlkem-native KEM adapter: maps the deterministic API onto the common ABI.
 * The parameter set / namespace / native backend are selected by
 * -DMLK_CONFIG_* flags at build time (see the bench Makefile); this file and
 * the monolithic mlkem_native.c are compiled with the same flags. */
#include "common_abi.h"
#include "mlkem_native.h"

/* mlkem_native.h undefines its own namespace macro after the declarations. */
#define MLKN(sym) MLK_API_CONCAT_UNDERSCORE(MLK_CONFIG_NAMESPACE_PREFIX, sym)

/* mlkem-native reports failures by cause (MLK_ERR_*); the common ABI, as the
 * test vectors, has -1 for every failure. */
static int abi(int r) { return r == 0 ? 0 : -1; }

int kem_keypair_derand(uint8_t *pk, uint8_t *sk, const uint8_t *coins) {
  return abi(MLKN(keypair_derand)(pk, sk, coins));
}
int kem_enc_derand(uint8_t *ct, uint8_t *ss, const uint8_t *pk,
                   const uint8_t *coins) {
  return abi(MLKN(enc_derand)(ct, ss, pk, coins));
}
int kem_dec(uint8_t *ss, const uint8_t *ct, const uint8_t *sk) {
  return abi(MLKN(dec)(ss, ct, sk));
}
int kem_check_pk(const uint8_t *pk) { return abi(MLKN(check_pk)(pk)); }
int kem_check_sk(const uint8_t *sk) { return abi(MLKN(check_sk)(sk)); }
