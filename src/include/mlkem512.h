/* ML-KEM-512, target avx2, profile sct.
 *
 * Common to all functions
 *   Requires:
 *     - every pointer argument points to a memory region of the size given by
 *       the macros below, and every input region is initialised;
 *     - the memory regions of a call do not overlap;
 *     - while the function runs, the caller ensures that no other thread writes
 *       to an input region, or reads or writes an output region.
 *   Ensures:
 *     - the function writes all of its output regions, and no memory outside
 *       the regions of the call;
 *     - the function keeps no state between calls.
 *   Pointers need no alignment.
 *   Constant time: every input is secret. The code declassifies:
 *     - rho, which is part of the public key and seeds the expansion of the
 *       public matrix;
 *     - intermediate results of the expansion of the public matrix that depend
 *       only on rho (added only because the Jasmin type system cannot
 *       autonomously confirm they depend only on rho);
 *     - the values returned by the functions, which are different from 0 only
 *       if a malformed key is received as input. */
#ifndef MLKEM512_AVX2_H
#define MLKEM512_AVX2_H

#include <stdint.h>

#define MLKEM512_PUBLICKEYBYTES   800
#define MLKEM512_SECRETKEYBYTES   1632
#define MLKEM512_CIPHERTEXTBYTES  768
#define MLKEM512_KEYPAIRCOINBYTES 64
#define MLKEM512_ENCCOINBYTES     32
#define MLKEM512_BYTES            32  /* shared-secret length */

/* Requires: coins holds d (bytes 0-31) and z (bytes 32-63).
 * Ensures: returns 0; public_key and secret_key hold the output of
 *   ML-KEM.KeyGen_internal(d, z) (Algorithm 16 in FIPS 203). */
int jade_kem_mlkem_mlkem512_amd64_avx2_keypair_derand(
    uint8_t *public_key,
    uint8_t *secret_key,
    const uint8_t *coins);

/* Requires: coins holds m.
 * Ensures: if public_key passes the modulus check (Section 7.2 in FIPS 203),
 *   returns 0, and ciphertext and shared_secret hold the output of
 *   ML-KEM.Encaps_internal(public_key, m) (Algorithm 17 in FIPS 203);
 *   otherwise returns -1, and ciphertext and shared_secret are all zero. */
int jade_kem_mlkem_mlkem512_amd64_avx2_enc_derand(
    uint8_t *ciphertext,
    uint8_t *shared_secret,
    const uint8_t *public_key,
    const uint8_t *coins);

/* Ensures: if secret_key passes the hash check (Section 7.3 in FIPS 203),
 *   returns 0, and shared_secret holds the output of
 *   ML-KEM.Decaps_internal(secret_key, ciphertext) (Algorithm 18 in FIPS 203);
 *   otherwise returns -1, and shared_secret is all zero. */
int jade_kem_mlkem_mlkem512_amd64_avx2_dec(
    uint8_t *shared_secret,
    const uint8_t *ciphertext,
    const uint8_t *secret_key);

/* Ensures: returns 0 if public_key passes the modulus check (Section 7.2 in
 *   FIPS 203), and -1 otherwise. */
int jade_kem_mlkem_mlkem512_amd64_avx2_check_pk(
    const uint8_t *public_key);

/* Ensures: returns 0 if secret_key passes the hash check (Section 7.3 in
 *   FIPS 203), and -1 otherwise. */
int jade_kem_mlkem_mlkem512_amd64_avx2_check_sk(
    const uint8_t *secret_key);

#endif /* MLKEM512_AVX2_H */
