/* jasmin hash adapter: maps the Jasmin-exported one-shot hash onto the common
 * ABI. JASMIN_HASH_FN is the exported function, e.g.
 *   -DJASMIN_HASH_FN=jade_hash_sha256_amd64_avx2
 * This shim is linked against the corresponding Jasmin .s. */
#include "common_abi.h"

extern void JASMIN_HASH_FN(uint8_t *, const uint8_t *, uint64_t);

void hash_digest(uint8_t *out, const uint8_t *in, size_t inlen) {
  JASMIN_HASH_FN(out, in, (uint64_t)inlen);
}
