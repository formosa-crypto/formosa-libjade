/* Memory-safety driver for one backend, to run under Valgrind's memcheck.
 *
 *   valgrind --error-exitcode=1 ./memcheck <scheme> <backend.so>
 *
 * dlopen's a single backend's common-ABI .so and runs every operation of the
 * scheme on buffers allocated on the heap at their exact size, so that
 * memcheck reports any access outside the arguments, and checks that the
 * outputs are fully initialised. The inputs cover the paths of the API:
 * KEM decapsulation of a valid and of a modified ciphertext, and the key
 * checks when the backend exports them; signing and verification with
 * messages and contexts of several lengths (including 0 and 255, and a
 * context of 256 bytes, which signing rejects), and verification of a
 * modified signature; hashing of messages of every length around the block
 * and padding boundaries. x86-64 + AVX2 only. */

#include <dlfcn.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* WITH_VALGRIND: check the outputs with memcheck's client requests; without
 * it (a plain run, e.g. under Rosetta), only the results are checked */
#ifdef WITH_VALGRIND
#include <valgrind/memcheck.h>
#else
#define VALGRIND_CHECK_MEM_IS_DEFINED(p, n) 0
#endif

typedef enum { KEM, SIG, HASH } kind_t;
typedef struct {
  const char *name;
  kind_t kind;
  /* KEM: pk, sk, ct; SIG: vk, sk, sig; HASH: digest, block */
  size_t a, b, c;
} scheme_t;

static const scheme_t SCHEMES[] = {
    {"ML-KEM-512", KEM, 800, 1632, 768},
    {"ML-KEM-768", KEM, 1184, 2400, 1088},
    {"ML-KEM-1024", KEM, 1568, 3168, 1568},
    {"ML-DSA-44", SIG, 1312, 2560, 2420},
    {"ML-DSA-65", SIG, 1952, 4032, 3309},
    {"ML-DSA-87", SIG, 2592, 4896, 4627},
    {"FIPS-180-sha256", HASH, 32, 64, 0},
    {"FIPS-180-sha512", HASH, 64, 128, 0},
};

typedef int (*kem_keypair_t)(uint8_t *, uint8_t *, const uint8_t *);
typedef int (*kem_enc_t)(uint8_t *, uint8_t *, const uint8_t *, const uint8_t *);
typedef int (*kem_dec_t)(uint8_t *, const uint8_t *, const uint8_t *);
typedef int (*kem_check_t)(const uint8_t *);
typedef void (*sig_keygen_t)(uint8_t *, uint8_t *, const uint8_t *);
typedef int (*sig_sign_t)(uint8_t *, const uint8_t *, const uint8_t *, size_t,
                          const uint8_t *, size_t, const uint8_t *);
typedef int (*sig_verify_t)(const uint8_t *, const uint8_t *, size_t,
                            const uint8_t *, size_t, const uint8_t *);
typedef void (*hash_digest_t)(uint8_t *, const uint8_t *, size_t);

static int g_failures;

static void fail(const char *what) {
  fprintf(stderr, "memcheck: %s\n", what);
  g_failures++;
}

static uint64_t prng_state = 0x1234567;
static void fill(uint8_t *p, size_t n) {
  for (size_t i = 0; i < n; i++) {
    prng_state = prng_state * 6364136223846793005ULL + 1442695040888963407ULL;
    p[i] = (uint8_t)(prng_state >> 33);
  }
}

/* a heap buffer of exactly n bytes (malloc(0) still gives a distinct block) */
static uint8_t *buf(size_t n) {
  uint8_t *p = malloc(n);
  if (!p) {
    perror("malloc");
    exit(2);
  }
  return p;
}

static uint8_t *input(size_t n) {
  uint8_t *p = buf(n);
  fill(p, n);
  return p;
}

static void *sym(void *h, const char *name, int required) {
  void *f = dlsym(h, name);
  if (!f && required) {
    fprintf(stderr, "memcheck: missing symbol %s\n", name);
    exit(2);
  }
  return f;
}

/* the outputs must be fully initialised */
static void defined(const char *what, const uint8_t *p, size_t n) {
  if (VALGRIND_CHECK_MEM_IS_DEFINED(p, n) != 0) fail(what);
}

static void run_kem(void *h, const scheme_t *s) {
  kem_keypair_t keypair = (kem_keypair_t)sym(h, "kem_keypair_derand", 1);
  kem_enc_t enc = (kem_enc_t)sym(h, "kem_enc_derand", 1);
  kem_dec_t dec = (kem_dec_t)sym(h, "kem_dec", 1);
  kem_check_t check_pk = (kem_check_t)sym(h, "kem_check_pk", 0);
  kem_check_t check_sk = (kem_check_t)sym(h, "kem_check_sk", 0);

  uint8_t *pk = buf(s->a), *sk = buf(s->b), *ct = buf(s->c);
  uint8_t *ss = buf(32), *ss2 = buf(32);
  uint8_t *kp_coins = input(64), *enc_coins = input(32);

  if (keypair(pk, sk, kp_coins) != 0) fail("keypair failed");
  defined("keypair: public key", pk, s->a);
  defined("keypair: secret key", sk, s->b);
  if (check_pk && check_pk(pk) != 0) fail("check_pk rejects a valid key");
  if (check_sk && check_sk(sk) != 0) fail("check_sk rejects a valid key");

  if (enc(ct, ss, pk, enc_coins) != 0) fail("encaps failed");
  defined("encaps: ciphertext", ct, s->c);
  defined("encaps: shared secret", ss, 32);

  if (dec(ss2, ct, sk) != 0) fail("decaps failed");
  defined("decaps: shared secret", ss2, 32);
  if (memcmp(ss, ss2, 32) != 0) fail("decaps: shared secrets differ");

  /* implicit rejection */
  ct[0] ^= 1;
  if (dec(ss2, ct, sk) != 0) fail("decaps of a modified ciphertext failed");
  defined("decaps (rejection): shared secret", ss2, 32);
  if (memcmp(ss, ss2, 32) == 0) fail("decaps accepts a modified ciphertext");

  free(pk), free(sk), free(ct), free(ss), free(ss2);
  free(kp_coins), free(enc_coins);
}

static void run_sig(void *h, const scheme_t *s) {
  sig_keygen_t keygen = (sig_keygen_t)sym(h, "sig_keygen", 1);
  sig_sign_t sign = (sig_sign_t)sym(h, "sig_sign", 1);
  sig_verify_t verify = (sig_verify_t)sym(h, "sig_verify", 1);

  uint8_t *vk = buf(s->a), *sk = buf(s->b), *sig = buf(s->c);
  uint8_t *seed = input(32);

  keygen(vk, sk, seed);
  defined("keygen: verification key", vk, s->a);
  defined("keygen: signing key", sk, s->b);

  static const size_t MSG_LENS[] = {0, 1, 33, 1000};
  static const size_t CTX_LENS[] = {0, 1, 255};
  for (size_t i = 0; i < sizeof MSG_LENS / sizeof *MSG_LENS; i++) {
    for (size_t j = 0; j < sizeof CTX_LENS / sizeof *CTX_LENS; j++) {
      uint8_t *msg = input(MSG_LENS[i]), *ctx = input(CTX_LENS[j]);
      uint8_t *rnd = input(32);
      if (sign(sig, sk, ctx, CTX_LENS[j], msg, MSG_LENS[i], rnd) != 0)
        fail("sign failed");
      defined("sign: signature", sig, s->c);
      if (verify(vk, ctx, CTX_LENS[j], msg, MSG_LENS[i], sig) != 0)
        fail("verify rejects a valid signature");
      sig[s->c / 2] ^= 1;
      if (verify(vk, ctx, CTX_LENS[j], msg, MSG_LENS[i], sig) == 0)
        fail("verify accepts a modified signature");
      free(msg), free(ctx), free(rnd);
    }
  }

  /* a context longer than 255 bytes is rejected */
  uint8_t *msg = input(16), *ctx = input(256), *rnd = input(32);
  if (sign(sig, sk, ctx, 256, msg, 16, rnd) == 0)
    fail("sign accepts a 256-byte context");
  free(msg), free(ctx), free(rnd);

  free(vk), free(sk), free(sig), free(seed);
}

/* every length up to three blocks, then a few long messages: the padding
 * boundaries (block - 9, block - 8 for SHA-256; block - 17, block - 16 for
 * SHA-512), whole and partial blocks, and the empty message */
static void run_hash(void *h, const scheme_t *s) {
  hash_digest_t digest = (hash_digest_t)sym(h, "hash_digest", 1);
  static const size_t LONG_LENS[] = {1000, 4096, 10007};
  size_t nlen = 3 * s->b + 1 + sizeof LONG_LENS / sizeof *LONG_LENS;
  for (size_t i = 0; i < nlen; i++) {
    size_t len = i <= 3 * s->b ? i : LONG_LENS[i - 3 * s->b - 1];
    uint8_t *msg = input(len), *md = buf(s->a), *md2 = buf(s->a);
    digest(md, msg, len);
    defined("hash: digest", md, s->a);
    digest(md2, msg, len);
    if (memcmp(md, md2, s->a) != 0) fail("hash: two digests of one message differ");
    free(msg), free(md), free(md2);
  }
}

int main(int argc, char **argv) {
  if (argc != 3) {
    fprintf(stderr, "usage: %s <scheme> <backend.so>\n", argv[0]);
    return 2;
  }
  const scheme_t *s = NULL;
  for (size_t i = 0; i < sizeof SCHEMES / sizeof *SCHEMES; i++)
    if (strcmp(SCHEMES[i].name, argv[1]) == 0) s = &SCHEMES[i];
  if (!s) {
    fprintf(stderr, "memcheck: unknown scheme %s\n", argv[1]);
    return 2;
  }
  void *h = dlopen(argv[2], RTLD_NOW | RTLD_LOCAL);
  if (!h) {
    fprintf(stderr, "memcheck: %s\n", dlerror());
    return 2;
  }
  if (s->kind == KEM)
    run_kem(h, s);
  else if (s->kind == SIG)
    run_sig(h, s);
  else
    run_hash(h, s);
  printf("%s %s: %s\n", s->name, argv[2], g_failures ? "FAILED" : "ok");
  return g_failures != 0;
}
