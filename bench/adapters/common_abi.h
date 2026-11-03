/* Common derand ABI shared by every backend's adapter.
 *
 * Each built shared library is one (backend, scheme) pair and exports exactly
 * these fixed symbols, so the test/bench drivers load a .so and call the same
 * names regardless of which library is underneath. Buffer sizes are owned by
 * the drivers (per scheme), not declared here.
 */
#ifndef BENCH_COMMON_ABI_H
#define BENCH_COMMON_ABI_H

#include <stddef.h>
#include <stdint.h>

/* ---- KEM (ML-KEM) -- deterministic API ---- */
int kem_keypair_derand(uint8_t *public_key, uint8_t *secret_key,
                       const uint8_t *coins);
int kem_enc_derand(uint8_t *ciphertext, uint8_t *shared_secret,
                   const uint8_t *public_key, const uint8_t *coins);
int kem_dec(uint8_t *shared_secret, const uint8_t *ciphertext,
            const uint8_t *secret_key);

/* FIPS 203 input checks: modulus check of the encapsulation key (7.2), hash
 * check of the decapsulation key (7.3); 0 on success. Optional: only the
 * backends whose kem_enc_derand / kem_dec perform these checks export them. */
int kem_check_pk(const uint8_t *public_key);
int kem_check_sk(const uint8_t *secret_key);

/* ---- SIG (ML-DSA) -- deterministic API ----
 * context and message are plain pointer + length. (The jasmin backend's entry
 * points want the message/context as reg-u64 addresses; that conversion lives
 * in the jasmin adapter, not in this shared ABI.) */
void sig_keygen(uint8_t *verification_key, uint8_t *signing_key,
                const uint8_t *randomness);
int sig_sign(uint8_t *signature, const uint8_t *signing_key,
             const uint8_t *context, size_t context_len,
             const uint8_t *message, size_t message_len,
             const uint8_t *randomness);
int sig_verify(const uint8_t *verification_key,
               const uint8_t *context, size_t context_len,
               const uint8_t *message, size_t message_len,
               const uint8_t *signature);

#endif /* BENCH_COMMON_ABI_H */
