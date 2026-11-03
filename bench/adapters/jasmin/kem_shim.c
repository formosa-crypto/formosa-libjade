/* jasmin KEM adapter: maps the Jasmin-exported derand symbols onto the common
 * ABI. JASMIN_KEM_NS is the namespace, e.g.
 *   -DJASMIN_KEM_NS=jade_kem_mlkem_mlkem768_amd64_avx2
 * This shim is linked against the corresponding Jasmin .s. */
#include "common_abi.h"

#define PASTE_(a, b) a##b
#define PASTE(a, b) PASTE_(a, b)
#define JK(suf) PASTE(JASMIN_KEM_NS, suf)

extern int JK(_keypair_derand)(uint8_t *, uint8_t *, const uint8_t *);
extern int JK(_enc_derand)(uint8_t *, uint8_t *, const uint8_t *, const uint8_t *);
extern int JK(_dec)(uint8_t *, const uint8_t *, const uint8_t *);
extern int JK(_check_pk)(const uint8_t *);
extern int JK(_check_sk)(const uint8_t *);

int kem_keypair_derand(uint8_t *pk, uint8_t *sk, const uint8_t *coins) {
  return JK(_keypair_derand)(pk, sk, coins);
}
int kem_enc_derand(uint8_t *ct, uint8_t *ss, const uint8_t *pk,
                   const uint8_t *coins) {
  return JK(_enc_derand)(ct, ss, pk, coins);
}
int kem_dec(uint8_t *ss, const uint8_t *ct, const uint8_t *sk) {
  return JK(_dec)(ss, ct, sk);
}
int kem_check_pk(const uint8_t *pk) { return JK(_check_pk)(pk); }
int kem_check_sk(const uint8_t *sk) { return JK(_check_sk)(sk); }
