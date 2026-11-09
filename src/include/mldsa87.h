/* ML-DSA-87, target avx2, profile sct.
 *
 * Common to all functions
 *   Requires:
 *     - every pointer argument points to a memory region of the size given by
 *       the macros below, and every input region is initialised;
 *     - message_pointer points to message_size initialised bytes, and
 *       context[0] points to context[1] initialised bytes;
 *     - the memory regions of a call do not overlap;
 *     - while the function runs, the caller ensures that no other thread writes
 *       to an input region, or reads or writes an output region.
 *   Ensures:
 *     - the function writes all of its output regions, and no memory outside
 *       the regions of the call;
 *     - the function keeps no state between calls.
 *   Pointers need no alignment.
 *   Constant time: the signing key and the randomness are secret; the
 *     verification key, the message, the context and the signature are public.
 *     The code declassifies:
 *     - rho, which is part of the verification key and seeds the expansion of
 *       the public matrix;
 *     - intermediate results of the expansion of the public matrix that depend
 *       only on rho (added only because the Jasmin type system cannot
 *       autonomously confirm they depend only on rho);
 *     - in keygen, information that reveals which candidates are rejected in
 *       the sampling of s1 and s2, and the verification key;
 *     - in sign:
 *       - t0, the low-order part of t = A*s1 + s2 stored in the signing key,
 *         which the security proof treats as part of the public key;
 *       - in each iteration of the rejection loop, the challenge c, the bytes
 *         that SampleInBall reads to build c, and, for each of the rejection
 *         tests on z, on w0 - c*s2 and on the hint, the first polynomial that
 *         fails the test;
 *       - the signature, when the loop ends with a valid signature;
 *     - in verify, the outcome of the verification, which depends only on
 *       public inputs (added only because the Jasmin type system cannot
 *       autonomously confirm it depends only on public inputs);
 *     - the status of the incremental SHAKE256, which depends only on the
 *       lengths of the message and the context;
 *     - the value returned by sign, which is different from 0 only if the
 *       context is longer than 255 bytes or the signing loop reaches its
 *       iteration bound. */
#ifndef MLDSA87_AVX2_H
#define MLDSA87_AVX2_H

#include <stdint.h>
#include <stddef.h>

#define MLDSA87_VERIFICATION_KEY_SIZE 2592
#define MLDSA87_SIGNING_KEY_SIZE      4896
#define MLDSA87_SIGNATURE_SIZE        4627
#define MLDSA87_RANDOMNESS_SIZE       32

/* Requires: randomness holds xi.
 * Ensures: verification_key and signing_key hold the output of
 *   ML-DSA.KeyGen_internal(xi) (Algorithm 6 in FIPS 204). */
void ml_dsa_87_keygen(
    uint8_t *verification_key,
    uint8_t *signing_key,
    const uint8_t *randomness);

/* Requires: the coefficients of s1 and s2 encoded in signing_key lie in
 *   [-eta, eta], as keygen produces them.
 * Ensures: if context[1] > 255, returns -1 and does not write signature;
 *   otherwise, returns 0 and writes to signature the output of ML-DSA.Sign
 *   (Algorithm 2 in FIPS 204) on signing_key, the message and the context,
 *   with randomness as rnd; or returns -1 and sets signature to zero when the
 *   signing loop reaches its iteration bound. */
int ml_dsa_87_sign(
    uint8_t *signature,
    const uint8_t *signing_key,
    const uint64_t context[2],
    uint64_t message_pointer,
    uint64_t message_size,
    const uint8_t *randomness);

/* Ensures: if context[1] > 255, returns -1; otherwise, returns 0 if ML-DSA.Verify
 *   (Algorithm 3 in FIPS 204) accepts signature on the message and the context
 *   under verification_key, and a nonzero value otherwise. */
int ml_dsa_87_verify(
    const uint8_t *verification_key,
    const uint64_t context[2],
    uint64_t message_pointer,
    uint64_t message_size,
    const uint8_t *signature);

#endif /* MLDSA87_AVX2_H */
