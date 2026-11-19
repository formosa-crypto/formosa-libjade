/* mldsa-native SIG adapter: maps the deterministic *_internal API onto the
 * common ABI. Built with -DMLD_CONFIG_NO_RANDOMIZED_API so only the internal
 * functions remain. The common ABI's sig_sign/sig_verify take a context, which
 * ML-DSA folds into the message as pre = 0x00 || len(ctx) || ctx; this shim
 * reconstructs that prefix (matching what the Jasmin entry point does). */
#include "common_abi.h"
#include "mldsa_native.h"
#include <stddef.h>
#include <stdlib.h>
#include <string.h>

/* mldsa_native.h undefines its own namespace macro after the declarations. */
#define MLDN(sym) MLD_API_CONCAT_UNDERSCORE(MLD_CONFIG_NAMESPACE_PREFIX, sym)

void sig_keygen(uint8_t *vk, uint8_t *sk, const uint8_t *seed) {
  /* keypair_internal is warn_unused_result; a nonzero return is a real failure,
   * not something to discard. sig_keygen has no status channel, so abort. */
  if (MLDN(keypair_internal)(vk, sk, seed) != 0)
    abort();
}

static size_t make_pre(uint8_t pre[2 + 255], const uint8_t *ctx,
                       size_t ctx_len) {
  pre[0] = 0x00;
  pre[1] = (uint8_t)ctx_len;
  if (ctx_len) memcpy(pre + 2, ctx, ctx_len);
  return 2 + ctx_len;
}

int sig_sign(uint8_t *sig, const uint8_t *sk, const uint8_t *ctx, size_t ctx_len,
             const uint8_t *msg, size_t msg_len, const uint8_t *rnd) {
  uint8_t pre[2 + 255];
  size_t prelen = make_pre(pre, ctx, ctx_len);
  return MLDN(signature_internal)(
      sig, msg, msg_len, pre, prelen, rnd, sk, 0 /* externalmu */);
}

int sig_verify(const uint8_t *vk, const uint8_t *ctx, size_t ctx_len,
               const uint8_t *msg, size_t msg_len, const uint8_t *sig) {
  uint8_t pre[2 + 255];
  size_t prelen = make_pre(pre, ctx, ctx_len);
  return MLDN(verify_internal)(sig, msg, msg_len, pre, prelen, vk,
                               0 /* externalmu */);
}
