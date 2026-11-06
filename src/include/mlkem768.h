/* ML-KEM-768 (AVX2) -- derand entry points exported by
 * mlkem/avx2/sct/768/jmlkem.jazz. The deterministic (*_derand) API takes caller
 * supplied coins; there is no randombytes-backed variant. */
#ifndef MLKEM768_AVX2_H
#define MLKEM768_AVX2_H

#include <stdint.h>

#define MLKEM768_PUBLICKEYBYTES   1184
#define MLKEM768_SECRETKEYBYTES   2400
#define MLKEM768_CIPHERTEXTBYTES  1088
#define MLKEM768_KEYPAIRCOINBYTES 64
#define MLKEM768_ENCCOINBYTES     32
#define MLKEM768_BYTES            32  /* shared-secret length */

int jade_kem_mlkem_mlkem768_amd64_avx2_keypair_derand(
    uint8_t *public_key,
    uint8_t *secret_key,
    const uint8_t *coins);

int jade_kem_mlkem_mlkem768_amd64_avx2_enc_derand(
    uint8_t *ciphertext,
    uint8_t *shared_secret,
    const uint8_t *public_key,
    const uint8_t *coins);

int jade_kem_mlkem_mlkem768_amd64_avx2_dec(
    uint8_t *shared_secret,
    const uint8_t *ciphertext,
    const uint8_t *secret_key);

int jade_kem_mlkem_mlkem768_amd64_avx2_check_pk(
    const uint8_t *public_key);

int jade_kem_mlkem_mlkem768_amd64_avx2_check_sk(
    const uint8_t *secret_key);

#endif /* MLKEM768_AVX2_H */
