/* jasmin multi-way hash adapter: maps a Jasmin-exported multi-way hash of
 * LANES lanes onto the one-message hash ABI. JASMIN_HASH_X_FN is the
 * exported one-shot function and JASMIN_HASH_X_FN_init, _init_from,
 * _update and _final the incremental ones, e.g.
 *   -DJASMIN_HASH_X_FN=jade_hash_sha256x8_amd64_avx2
 * JASMIN_HASH_REF_FN is the single-way hash of the same function
 * (jade_hash_sha256_amd64_avx2), DIGEST_BYTES its digest length and
 * CTX_X_BYTES, CTX_REF_BYTES the context lengths of the two.
 *
 * Lane 0 hashes the caller's message, and its digest is the result. Lane k
 * > 0 hashes the message with every byte XORed with VARY(k), and its digest
 * must equal the single-way digest of the same bytes, or the shim aborts:
 * a KAT then also fails on an error that mixes or changes other lanes. The
 * context of the ABI is the multi-way context followed by one single-way
 * context per lane (lane 0's is the source of init_from). hash_init uses
 * init and init_from, by turns. hash_digest_x is the multi-way one-shot
 * itself, which bench.c measures when it is there.
 *
 * This shim is linked against the multi-way and the single-way Jasmin .s. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "common_abi.h"

#define PASTE_(a, b) a##b
#define PASTE(a, b) PASTE_(a, b)
#define JX(suf) PASTE(JASMIN_HASH_X_FN, suf)
#define JR(suf) PASTE(JASMIN_HASH_REF_FN, suf)
#define VARY(k) ((uint8_t)(0x5b * (k)))

typedef const uint8_t *const lanes_t[LANES];

extern void JASMIN_HASH_X_FN(uint8_t *, lanes_t, uint64_t);
extern void JX(_init)(uint8_t *);
extern uint64_t JX(_init_from)(uint8_t *, const uint8_t *);
extern uint64_t JX(_update)(uint8_t *, lanes_t, uint64_t);
extern uint64_t JX(_final)(uint8_t *, uint8_t *);
extern void JASMIN_HASH_REF_FN(uint8_t *, const uint8_t *, uint64_t);
extern void JR(_init)(uint8_t *);
extern uint64_t JR(_update)(uint8_t *, const uint8_t *, uint64_t);
extern uint64_t JR(_final)(uint8_t *, uint8_t *);

#define REF(ctx, k) ((ctx) + CTX_X_BYTES + (size_t)(k) * CTX_REF_BYTES)

static void lane_mismatch(int k) {
  fprintf(stderr, "hash_x_shim: lane %d differs from the single-way hash\n", k);
  abort();
}

/* lane 0 is in itself; lane k > 0 a copy of the inlen bytes, varied */
static void vary(const uint8_t *in, size_t inlen, const uint8_t *v[LANES]) {
  v[0] = in;
  for (int k = 1; k < LANES; k++) {
    uint8_t *p = inlen ? malloc(inlen) : NULL;
    if (inlen && !p) abort();
    for (size_t i = 0; i < inlen; i++) p[i] = in[i] ^ VARY(k);
    v[k] = p;
  }
}

static void unvary(const uint8_t *v[LANES]) {
  for (int k = 1; k < LANES; k++) free((void *)v[k]);
}

void hash_digest_x(uint8_t *out, lanes_t in, size_t inlen) {
  JASMIN_HASH_X_FN(out, in, (uint64_t)inlen);
}

void hash_digest(uint8_t *out, const uint8_t *in, size_t inlen) {
  const uint8_t *v[LANES];
  uint8_t all[LANES * DIGEST_BYTES], ref[DIGEST_BYTES];
  vary(in, inlen, v);
  JASMIN_HASH_X_FN(all, v, (uint64_t)inlen);
  for (int k = 1; k < LANES; k++) {
    JASMIN_HASH_REF_FN(ref, v[k], (uint64_t)inlen);
    if (memcmp(ref, all + k * DIGEST_BYTES, DIGEST_BYTES) != 0) lane_mismatch(k);
  }
  unvary(v);
  memcpy(out, all, DIGEST_BYTES);
}

void hash_init(uint8_t *ctx) {
  static unsigned calls;
  for (int k = 0; k < LANES; k++) JR(_init)(REF(ctx, k));
  if (calls++ & 1) {
    if (JX(_init_from)(ctx, REF(ctx, 0)) != 0) {
      fprintf(stderr, "hash_x_shim: init_from refuses a new context\n");
      abort();
    }
  } else {
    JX(_init)(ctx);
  }
}

int hash_update(uint8_t *ctx, const uint8_t *in, size_t inlen) {
  const uint8_t *v[LANES];
  uint64_t r;
  vary(in, inlen, v);
  r = JX(_update)(ctx, v, (uint64_t)inlen);
  if (r == 0)
    for (int k = 1; k < LANES; k++)
      if (JR(_update)(REF(ctx, k), v[k], (uint64_t)inlen) != 0) lane_mismatch(k);
  unvary(v);
  return (int)r;
}

int hash_final(uint8_t *ctx, uint8_t *out) {
  uint8_t all[LANES * DIGEST_BYTES], ref[DIGEST_BYTES];
  uint64_t r = JX(_final)(ctx, all);
  if (r != 0) return (int)r;
  for (int k = 1; k < LANES; k++) {
    if (JR(_final)(REF(ctx, k), ref) != 0) lane_mismatch(k);
    if (memcmp(ref, all + k * DIGEST_BYTES, DIGEST_BYTES) != 0) lane_mismatch(k);
  }
  memcpy(out, all, DIGEST_BYTES);
  return 0;
}
