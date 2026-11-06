/* ML-DSA-44 (AVX2) -- derand entry points exported by
 * mldsa/avx2/sct/44/mldsa.jazz. keygen and sign take caller-supplied 32-byte
 * randomness (the deterministic/"internal" API). */
#ifndef MLDSA44_AVX2_H
#define MLDSA44_AVX2_H

#include <stdint.h>
#include <stddef.h>

#define MLDSA44_VERIFICATION_KEY_SIZE 1312
#define MLDSA44_SIGNING_KEY_SIZE      2560
#define MLDSA44_SIGNATURE_SIZE        2420
#define MLDSA44_RANDOMNESS_SIZE       32

/* context is a 2-element array [context_pointer, context_size]; the message is
 * passed as a raw pointer + length (mirrors the Jasmin reg ui64 arguments). */

void ml_dsa_44_keygen(
    uint8_t *verification_key,
    uint8_t *signing_key,
    const uint8_t *randomness);

/* returns 0 on success, -1 if context_size > 255 */
int ml_dsa_44_sign(
    uint8_t *signature,
    const uint8_t *signing_key,
    const uint64_t context[2],
    uint64_t message_pointer,
    uint64_t message_size,
    const uint8_t *randomness);

/* returns 0 if the signature verifies, nonzero otherwise */
int ml_dsa_44_verify(
    const uint8_t *verification_key,
    const uint64_t context[2],
    uint64_t message_pointer,
    uint64_t message_size,
    const uint8_t *signature);

#endif /* MLDSA44_AVX2_H */
