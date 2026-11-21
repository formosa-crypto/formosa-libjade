/* jasmin hash adapter: maps the Jasmin-exported one-shot and incremental
 * hash onto the common ABI. JASMIN_HASH_FN is the exported one-shot
 * function, e.g.
 *   -DJASMIN_HASH_FN=jade_hash_sha256_amd64_avx2
 * and JASMIN_HASH_FN_init, _update and _final the incremental ones.
 * This shim is linked against the corresponding Jasmin .s. */
#include "common_abi.h"

#define PASTE_(a, b) a##b
#define PASTE(a, b) PASTE_(a, b)
#define JH(suf) PASTE(JASMIN_HASH_FN, suf)

extern void JASMIN_HASH_FN(uint8_t *, const uint8_t *, uint64_t);
extern void JH(_init)(uint8_t *);
extern uint64_t JH(_update)(uint8_t *, const uint8_t *, uint64_t);
extern uint64_t JH(_final)(uint8_t *, uint8_t *);

void hash_digest(uint8_t *out, const uint8_t *in, size_t inlen) {
  JASMIN_HASH_FN(out, in, (uint64_t)inlen);
}
void hash_init(uint8_t *ctx) { JH(_init)(ctx); }
int hash_update(uint8_t *ctx, const uint8_t *in, size_t inlen) {
  return (int)JH(_update)(ctx, in, (uint64_t)inlen);
}
int hash_final(uint8_t *ctx, uint8_t *out) { return (int)JH(_final)(ctx, out); }
