/* ML-KEM-512 (AVX2) -- derand entry points exported by
 * mlkem/avx2/512/jmlkem.jazz. The deterministic (*_derand) API takes caller
 * supplied coins; there is no randombytes-backed variant. */
#ifndef MLKEM512_AVX2_H
#define MLKEM512_AVX2_H

#include <stdint.h>

#define MLKEM512_PUBLICKEYBYTES   800
#define MLKEM512_SECRETKEYBYTES   1632
#define MLKEM512_CIPHERTEXTBYTES  768
#define MLKEM512_KEYPAIRCOINBYTES 64
#define MLKEM512_ENCCOINBYTES     32
#define MLKEM512_BYTES            32  /* shared-secret length */

int jade_kem_mlkem_mlkem512_amd64_avx2_keypair_derand(
    uint8_t *public_key,
    uint8_t *secret_key,
    const uint8_t *coins);

int jade_kem_mlkem_mlkem512_amd64_avx2_enc_derand(
    uint8_t *ciphertext,
    uint8_t *shared_secret,
    const uint8_t *public_key,
    const uint8_t *coins);

int jade_kem_mlkem_mlkem512_amd64_avx2_dec(
    uint8_t *shared_secret,
    const uint8_t *ciphertext,
    const uint8_t *secret_key);

int jade_kem_mlkem_mlkem512_amd64_avx2_check_pk(
    const uint8_t *public_key);

int jade_kem_mlkem_mlkem512_amd64_avx2_check_sk(
    const uint8_t *secret_key);

#endif /* MLKEM512_AVX2_H */
