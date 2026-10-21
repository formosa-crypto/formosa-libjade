/* Cycle-count benchmark for one backend.
 *
 *   ./bench <scheme> <backend.so>
 *
 * dlopen's a single backend's common-ABI .so, runs each derand operation
 * BENCH_ITERS times (env, default 10000) and reports median CPU cycles via
 * rdtsc. Each iteration runs on fresh inputs, made untimed beforehand: the
 * randomness of keypair, encaps, keygen and sign comes from a xorshift reset
 * to a fixed seed at the start of each operation's bench, and decaps and
 * verify take the ciphertext or signature of a fresh encaps or sign. The
 * medians then cover the spread of the rejection loops, while every backend
 * and commit runs on the same inputs. One backend per process:
 * different .so files can define the same global symbols (e.g. randombytes),
 * so co-loading them risks cross-lib interposition. The bench / bench-all make
 * targets loop, invoking this once per (scheme, backend) in a fresh process.
 * x86-64 + AVX2 only.
 *
 * Output is human-readable by default; set BENCH_FORMAT=csv for one row per
 * measurement -- "scheme,backend,operation,median_cycles" with no header (so
 * invocations concatenate; the bench-all target prints the header and
 * prefixes each row with its pass number). */

#include <dlfcn.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <x86intrin.h>

/* ---- scheme table ---- */
typedef enum { KEM, SIG } kind_t;
typedef struct {
  const char *name;
  kind_t kind;
  /* KEM: pk, sk, ct, ss=32, kp_coins=64, enc_coins=32
   * SIG: vk(pk), sk, sig, seed=32, rnd=32 */
  int a, b, c;
} scheme_t;

static const scheme_t SCHEMES[] = {
    {"ML-KEM-512", KEM, 800, 1632, 768},
    {"ML-KEM-768", KEM, 1184, 2400, 1088},
    {"ML-KEM-1024", KEM, 1568, 3168, 1568},
    {"ML-DSA-44", SIG, 1312, 2560, 2420},
    {"ML-DSA-65", SIG, 1952, 4032, 3309},
    {"ML-DSA-87", SIG, 2592, 4896, 4627},
};

/* ---- common ABI signatures ---- */
typedef int (*kem_keypair_t)(uint8_t *, uint8_t *, const uint8_t *);
typedef int (*kem_enc_t)(uint8_t *, uint8_t *, const uint8_t *, const uint8_t *);
typedef int (*kem_dec_t)(uint8_t *, const uint8_t *, const uint8_t *);
typedef void (*sig_keygen_t)(uint8_t *, uint8_t *, const uint8_t *);
typedef int (*sig_sign_t)(uint8_t *, const uint8_t *, const uint8_t *, size_t,
                          const uint8_t *, size_t, const uint8_t *);
typedef int (*sig_verify_t)(const uint8_t *, const uint8_t *, size_t,
                            const uint8_t *, size_t, const uint8_t *);

static uint64_t prng_state = 0x1234567;
static void fill(uint8_t *p, size_t n) {
  for (size_t i = 0; i < n; i++) {
    prng_state = prng_state * 6364136223846793005ULL + 1442695040888963407ULL;
    p[i] = (uint8_t)(prng_state >> 33);
  }
}

static int cmp_u64(const void *x, const void *y) {
  uint64_t a = *(const uint64_t *)x, b = *(const uint64_t *)y;
  return (a > b) - (a < b);
}

static int g_csv;

/* "_build/pqcrystals-ref_mlkem768.so" -> "pqcrystals-ref" (strip dir, the
 * trailing _<parambase>, and .so). Backend names use '-' but no '_'. */
static void lib_backend(const char *path, char *out, size_t n) {
  const char *base = strrchr(path, '/');
  base = base ? base + 1 : path;
  const char *us = strrchr(base, '_');
  size_t len = us ? (size_t)(us - base) : strlen(base);
  if (len >= n) len = n - 1;
  memcpy(out, base, len);
  out[len] = '\0';
}

static void report(const char *path, const scheme_t *s, uint64_t m0,
                   uint64_t m1, uint64_t m2) {
  const char *o0 = s->kind == KEM ? "keypair" : "keygen";
  const char *o1 = s->kind == KEM ? "encaps" : "sign";
  const char *o2 = s->kind == KEM ? "decaps" : "verify";
  if (g_csv) {
    char bk[64];
    lib_backend(path, bk, sizeof bk);
    printf("%s,%s,%s,%llu\n", s->name, bk, o0, (unsigned long long)m0);
    printf("%s,%s,%s,%llu\n", s->name, bk, o1, (unsigned long long)m1);
    printf("%s,%s,%s,%llu\n", s->name, bk, o2, (unsigned long long)m2);
  } else {
    printf("  %-22s %s=%-10llu %s=%-10llu %s=%-10llu\n", path, o0,
           (unsigned long long)m0, o1, (unsigned long long)m1, o2,
           (unsigned long long)m2);
  }
}

#define ITERS_DEFAULT 10000

/* rdtsc counts TSC ticks at a fixed rate, not core cycles: work measured while
 * the frequency governor is still at idle reads artificially high, so the first
 * backend in a process would be penalized vs later ones. Spin briefly first to
 * ramp the core to steady-state turbo so every backend is measured alike. */
static void warmup(void) {
  volatile uint64_t x = 0;
  for (uint64_t i = 0; i < 300000000ULL; i++) x += i * i + (x >> 1);
}

/* xorshift64 for the randomness of the operations (n a multiple of 8) */
#define RND_SEED 0x9e3779b97f4a7c15ULL
static uint64_t rnd_state;
static void next_rnd(uint8_t *p, size_t n) {
  for (size_t i = 0; i < n; i += 8) {
    rnd_state ^= rnd_state << 13;
    rnd_state ^= rnd_state >> 7;
    rnd_state ^= rnd_state << 17;
    memcpy(p + i, &rnd_state, 8);
  }
}

/* time `expr` ITERS times, each after an untimed `setup`, store median cycles
 * in *out; the xorshift restarts from RND_SEED, so every bench of an
 * operation sees the same inputs */
#define BENCH(iters, samples, out, setup, expr)                                \
  do {                                                                         \
    rnd_state = RND_SEED;                                                      \
    for (size_t _i = 0; _i < (iters); _i++) {                                  \
      unsigned _aux;                                                           \
      setup;                                                                   \
      uint64_t _t0 = __rdtscp(&_aux);                                          \
      expr;                                                                    \
      uint64_t _t1 = __rdtscp(&_aux);                                          \
      (samples)[_i] = _t1 - _t0;                                               \
    }                                                                          \
    qsort((samples), (iters), sizeof(uint64_t), cmp_u64);                      \
    *(out) = (samples)[(iters) / 2];                                           \
  } while (0)

/* The AVX2 backends want 32-byte-aligned buffers; aligned_alloc needs the size
   rounded up to the alignment. */
static void *xalloc32(size_t n) {
  void *p = aligned_alloc(32, (n + 31) & ~(size_t)31);
  if (!p) {
    perror("aligned_alloc");
    exit(2);
  }
  return p;
}

static void bench_backend(const char *path, const scheme_t *s, size_t iters,
                          uint64_t *samples) {
  void *h = dlopen(path, RTLD_NOW | RTLD_LOCAL);
  if (!h) {
    fprintf(stderr, "  cannot load %s: %s\n", path, dlerror());
    return;
  }
  uint8_t *A = xalloc32((size_t)s->a), *B = xalloc32((size_t)s->b);
  uint8_t *C = xalloc32((size_t)s->c);
  _Alignas(32) uint8_t ss[32], coins[64], seed[32], rnd[32], msg[64];
  uint64_t m0 = 0, m1 = 0, m2 = 0;
  fill(coins, 64); fill(seed, 32); fill(rnd, 32); fill(msg, 64);

  if (s->kind == KEM) {
    kem_keypair_t kp = dlsym(h, "kem_keypair_derand");
    kem_enc_t enc = dlsym(h, "kem_enc_derand");
    kem_dec_t dec = dlsym(h, "kem_dec");
    kp(A, B, coins);          /* A=pk B=sk */
    enc(C, ss, A, coins);     /* C=ct ss=ss */
    BENCH(iters, samples, &m0, next_rnd(coins, 64), kp(A, B, coins));
    BENCH(iters, samples, &m1, next_rnd(coins, 32), enc(C, ss, A, coins));
    BENCH(iters, samples, &m2, (next_rnd(coins, 32), enc(C, ss, A, coins)),
          dec(ss, C, B));
    report(path, s, m0, m1, m2);
  } else {
    sig_keygen_t kg = dlsym(h, "sig_keygen");
    sig_sign_t sign = dlsym(h, "sig_sign");
    sig_verify_t ver = dlsym(h, "sig_verify");
    kg(A, B, seed);                                   /* A=vk B=sk */
    sign(C, B, NULL, 0, msg, sizeof msg, rnd);        /* C=sig, empty context */
    BENCH(iters, samples, &m0, next_rnd(seed, 32), kg(A, B, seed));
    BENCH(iters, samples, &m1, next_rnd(rnd, 32),
          sign(C, B, NULL, 0, msg, sizeof msg, rnd));
    BENCH(iters, samples, &m2,
          (next_rnd(rnd, 32), sign(C, B, NULL, 0, msg, sizeof msg, rnd)),
          ver(A, NULL, 0, msg, sizeof msg, C));
    report(path, s, m0, m1, m2);
  }
  free(A); free(B); free(C);
  dlclose(h);
}

int main(int argc, char **argv) {
  if (argc != 3) {
    fprintf(stderr, "usage: %s <scheme> <backend.so>\n", argv[0]);
    return 2;
  }
  const scheme_t *s = NULL;
  for (size_t i = 0; i < sizeof SCHEMES / sizeof *SCHEMES; i++)
    if (!strcmp(argv[1], SCHEMES[i].name)) s = &SCHEMES[i];
  if (!s) { fprintf(stderr, "unknown scheme %s\n", argv[1]); return 2; }

  size_t iters = ITERS_DEFAULT;
  const char *e = getenv("BENCH_ITERS");
  if (e) iters = strtoul(e, NULL, 10);
  const char *fmt = getenv("BENCH_FORMAT");
  g_csv = fmt && !strcmp(fmt, "csv");
  uint64_t *samples = malloc(iters * sizeof(uint64_t));

  warmup();
  bench_backend(argv[2], s, iters, samples);
  free(samples);
  return 0;
}
