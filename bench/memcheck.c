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
 * modified signature; for FIPS 202, every function of the JKCP C API
 * (src/include/JKCP.h) on inputs and outputs around the rates (including
 * empty ones), through the one-shot functions, the incremental API and the
 * 4-way API, whose outputs must agree. x86-64 + AVX2 only. */

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

typedef enum { KEM, SIG, FIPS202 } kind_t;
typedef struct {
  const char *name;
  kind_t kind;
  /* KEM: pk, sk, ct; SIG: vk, sk, sig; FIPS202: unused */
  size_t a, b, c;
} scheme_t;

static const scheme_t SCHEMES[] = {
    {"ML-KEM-512", KEM, 800, 1632, 768},
    {"ML-KEM-768", KEM, 1184, 2400, 1088},
    {"ML-KEM-1024", KEM, 1568, 3168, 1568},
    {"ML-DSA-44", SIG, 1312, 2560, 2420},
    {"ML-DSA-65", SIG, 1952, 4032, 3309},
    {"ML-DSA-87", SIG, 2592, 4896, 4627},
    {"FIPS-202", FIPS202, 0, 0, 0},
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

/* FIPS 202: the C API of src/include/JKCP.h */
typedef void (*hash_t)(uint8_t *, const uint8_t *, uint64_t);
typedef void (*xof_t)(uint8_t *, uint64_t, const uint8_t *, uint64_t);
typedef void (*init_t)(uint64_t *);
typedef void (*absorb_t)(uint64_t *, const uint8_t *, uint64_t);
typedef void (*squeeze_t)(uint64_t *, uint8_t *, uint64_t);
typedef void (*absorb4_t)(uint64_t *, const uint8_t *, const uint8_t *,
                          const uint8_t *, const uint8_t *, uint64_t);
typedef void (*squeeze4_t)(uint64_t *, uint8_t *, uint8_t *, uint8_t *,
                           uint8_t *, uint64_t);

#define JKCP_STATE 208    /* jkcp_state */
#define JKCP_X4_STATE 808 /* jkcp_x4_state */

/* a heap copy of p[0..n), at its exact size */
static uint8_t *copy(const uint8_t *p, size_t n) {
  uint8_t *q = buf(n);
  if (n) memcpy(q, p, n);
  return q;
}

/* the output of a squeeze in two parts must be the one-shot output */
static void agree(const char *what, const uint8_t *ref, const uint8_t *o1,
                  size_t k, const uint8_t *o2, size_t n) {
  defined(what, o1, k);
  defined(what, o2, n - k);
  if ((k && memcmp(ref, o1, k) != 0) || (n - k && memcmp(ref + k, o2, n - k) != 0))
    fail(what);
}

static void run_fips202(void *h) {
  static const struct { const char *fn; size_t digest; } FNS[] = {
      {"sha3_224", 28}, {"sha3_256", 32}, {"sha3_384", 48},
      {"sha3_512", 64}, {"shake128", 0},  {"shake256", 0}};
  /* around the rates (72, 104, 136, 144, 168), empty included */
  static const size_t IN_LENS[] = {0, 1, 71, 72, 73, 136, 137, 168, 169, 1000};
  static const size_t OUT_LENS[] = {0, 1, 32, 136, 167, 168, 169, 500};
  absorb_t absorb = (absorb_t)sym(h, "keccak_absorb", 1);
  squeeze_t squeeze = (squeeze_t)sym(h, "keccak_squeeze", 1);
  absorb_t absorb4_bcast = (absorb_t)sym(h, "keccakx4_absorb_bcast", 1);
  absorb4_t absorb4 = (absorb4_t)sym(h, "keccakx4_absorb", 1);
  squeeze4_t squeeze4 = (squeeze4_t)sym(h, "keccakx4_squeeze", 1);
  char name[32];

  for (size_t f = 0; f < sizeof FNS / sizeof *FNS; f++) {
    void *oneshot = sym(h, FNS[f].fn, 1);
    snprintf(name, sizeof name, "%s_init", FNS[f].fn);
    init_t init = (init_t)sym(h, name, 1);
    snprintf(name, sizeof name, "%sx4_init", FNS[f].fn);
    init_t init4 = (init_t)sym(h, name, 1);
    size_t nout = FNS[f].digest ? 1 : sizeof OUT_LENS / sizeof *OUT_LENS;

    for (size_t i = 0; i < sizeof IN_LENS / sizeof *IN_LENS; i++) {
      size_t len = IN_LENS[i], m = len / 2;
      uint8_t *in = input(len);
      uint8_t *p1 = copy(in, m), *p2 = copy(in + m, len - m);
      uint8_t *q[4];
      for (int l = 0; l < 4; l++) q[l] = copy(in + m, len - m);

      for (size_t o = 0; o < nout; o++) {
        size_t n = FNS[f].digest ? FNS[f].digest : OUT_LENS[o], k = n / 2;
        uint8_t *ref = buf(n), *none = buf(0);
        if (FNS[f].digest)
          ((hash_t)oneshot)(ref, in, len);
        else
          ((xof_t)oneshot)(ref, n, in, len);
        defined("one-shot: output", ref, n);

        /* incremental: the input in two parts, the output in two parts,
           zero-length squeezes before and between them */
        uint64_t *st = (uint64_t *)buf(JKCP_STATE);
        uint8_t *o1 = buf(k), *o2 = buf(n - k);
        init(st);
        absorb(st, p1, m);
        absorb(st, p2, len - m);
        squeeze(st, none, 0);
        squeeze(st, o1, k);
        squeeze(st, none, 0);
        squeeze(st, o2, n - k);
        agree("incremental: output differs from one-shot", ref, o1, k, o2, n);
        free(st), free(o1), free(o2);

        /* 4-way: broadcast absorb, then four buffers; every lane must give
           the one-shot output */
        uint64_t *st4 = (uint64_t *)buf(JKCP_X4_STATE);
        uint8_t *a[4], *b[4], *z[4];
        for (int l = 0; l < 4; l++) a[l] = buf(k), b[l] = buf(n - k), z[l] = buf(0);
        init4(st4);
        absorb4_bcast(st4, p1, m);
        absorb4(st4, q[0], q[1], q[2], q[3], len - m);
        squeeze4(st4, z[0], z[1], z[2], z[3], 0);
        squeeze4(st4, a[0], a[1], a[2], a[3], k);
        squeeze4(st4, b[0], b[1], b[2], b[3], n - k);
        for (int l = 0; l < 4; l++) {
          agree("4-way: output differs from one-shot", ref, a[l], k, b[l], n);
          free(a[l]), free(b[l]), free(z[l]);
        }
        free(st4), free(ref), free(none);
      }
      for (int l = 0; l < 4; l++) free(q[l]);
      free(in), free(p1), free(p2);
    }
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
    run_fips202(h);
  printf("%s %s: %s\n", s->name, argv[2], g_failures ? "FAILED" : "ok");
  return g_failures != 0;
}
