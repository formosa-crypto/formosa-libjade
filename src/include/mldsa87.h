/* ML-DSA-87 (AVX2) -- derand entry points exported by
 * mldsa/avx2/sct/87/mldsa.jazz. keygen and sign take caller-supplied 32-byte
 * randomness (the deterministic/"internal" API). */
#ifndef MLDSA87_AVX2_H
#define MLDSA87_AVX2_H

#include <stdint.h>
#include <stddef.h>

#define MLDSA87_VERIFICATION_KEY_SIZE 2592
#define MLDSA87_SIGNING_KEY_SIZE      4896
#define MLDSA87_SIGNATURE_SIZE        4627
#define MLDSA87_RANDOMNESS_SIZE       32

/* context is a 2-element array [context_pointer, context_size]; the message is
 * passed as a raw pointer + length (mirrors the Jasmin reg ui64 arguments). */

void ml_dsa_87_keygen(
    uint8_t *verification_key,
    uint8_t *signing_key,
    const uint8_t *randomness);

/* returns 0 on success, -1 if context_size > 255 */
int ml_dsa_87_sign(
    uint8_t *signature,
    const uint8_t *signing_key,
    const uint64_t context[2],
    uint64_t message_pointer,
    uint64_t message_size,
    const uint8_t *randomness);

/* returns 0 if the signature verifies, nonzero otherwise */
int ml_dsa_87_verify(
    const uint8_t *verification_key,
    const uint64_t context[2],
    uint64_t message_pointer,
    uint64_t message_size,
    const uint8_t *signature);

#endif /* MLDSA87_AVX2_H */
