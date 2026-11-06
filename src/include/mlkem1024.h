/* ML-KEM-1024 (AVX2) -- derand entry points exported by
 * mlkem/avx2/sct/1024/jmlkem.jazz. The deterministic (*_derand) API takes caller
 * supplied coins; there is no randombytes-backed variant. */
#ifndef MLKEM1024_AVX2_H
#define MLKEM1024_AVX2_H

#include <stdint.h>

#define MLKEM1024_PUBLICKEYBYTES   1568
#define MLKEM1024_SECRETKEYBYTES   3168
#define MLKEM1024_CIPHERTEXTBYTES  1568
#define MLKEM1024_KEYPAIRCOINBYTES 64
#define MLKEM1024_ENCCOINBYTES     32
#define MLKEM1024_BYTES            32  /* shared-secret length */

int jade_kem_mlkem_mlkem1024_amd64_avx2_keypair_derand(
    uint8_t *public_key,
    uint8_t *secret_key,
    const uint8_t *coins);

int jade_kem_mlkem_mlkem1024_amd64_avx2_enc_derand(
    uint8_t *ciphertext,
    uint8_t *shared_secret,
    const uint8_t *public_key,
    const uint8_t *coins);

int jade_kem_mlkem_mlkem1024_amd64_avx2_dec(
    uint8_t *shared_secret,
    const uint8_t *ciphertext,
    const uint8_t *secret_key);

int jade_kem_mlkem_mlkem1024_amd64_avx2_check_pk(
    const uint8_t *public_key);

int jade_kem_mlkem_mlkem1024_amd64_avx2_check_sk(
    const uint8_t *secret_key);

#endif /* MLKEM1024_AVX2_H */
