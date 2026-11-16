/* jasmin MAC adapter: maps the Jasmin-exported one-shot and incremental MAC
 * onto the common ABI. JASMIN_MAC_FN is the exported one-shot function, e.g.
 *   -DJASMIN_MAC_FN=jade_mac_hmac_sha256_amd64_avx2
 * and JASMIN_MAC_FN_init, _update and _final the incremental ones.
 * This shim is linked against the corresponding Jasmin .s. */
#include "common_abi.h"

#define PASTE_(a, b) a##b
#define PASTE(a, b) PASTE_(a, b)
#define JM(suf) PASTE(JASMIN_MAC_FN, suf)

extern void JASMIN_MAC_FN(uint8_t *, const uint8_t *, uint64_t, const uint8_t *, uint64_t);
extern void JM(_init)(uint8_t *, const uint8_t *, uint64_t);
extern uint64_t JM(_update)(uint8_t *, const uint8_t *, uint64_t);
extern uint64_t JM(_final)(uint8_t *, uint8_t *);

void mac_tag(uint8_t *out, const uint8_t *key, size_t keylen,
             const uint8_t *msg, size_t msglen) {
  JASMIN_MAC_FN(out, key, (uint64_t)keylen, msg, (uint64_t)msglen);
}
void mac_init(uint8_t *ctx, const uint8_t *key, size_t keylen) {
  JM(_init)(ctx, key, (uint64_t)keylen);
}
int mac_update(uint8_t *ctx, const uint8_t *in, size_t inlen) {
  return (int)JM(_update)(ctx, in, (uint64_t)inlen);
}
int mac_final(uint8_t *ctx, uint8_t *out) { return (int)JM(_final)(ctx, out); }
