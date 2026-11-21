/* HMAC-SHA-512 (FIPS 198-1 over FIPS 180-4), target avx2, profile sct.
 *
 * One-shot MAC
 * Requires:
 *   - out points to FIPS198SHA512_BYTES bytes, key to keylen initialised bytes and
 *     msg to msglen initialised bytes (key and msg are not read when their
 *     length is 0);
 *   - keylen < 2^61 and msglen < 2^61 - 128 (the inner hash covers one
 *     128-byte key block and the message);
 *   - out does not overlap the key or the message (key and msg may
 *     overlap each other);
 *   - the CPU has AVX2, BMI1 and BMI2;
 *   - while the function runs, the caller ensures that no other thread writes
 *     to the inputs, or reads or writes the output.
 * Ensures:
 *   - out holds HMAC-SHA-512 of the msglen bytes at msg under the keylen bytes
 *     at key (Section 4 in FIPS 198-1); a key longer than 128 bytes is hashed
 *     first;
 *   - the function writes no memory outside out, keeps no state between
 *     calls, and clears the stack it used before it returns.
 * Pointers need no alignment.
 *
 * Incremental MAC
 *   A context is FIPS198SHA512_CTXBYTES bytes of caller memory, which only these
 *   functions read or write. init starts the MAC of the empty message under
 *   the keylen bytes at key; update appends the inlen bytes at in; final
 *   writes the tag of the bytes appended since init to out and zeroes the
 *   context, so that it cannot be used again before the next init.
 *   Requires: the regions of a call do not overlap; key and in point to
 *     keylen and inlen initialised bytes; the other requirements of the
 *     one-shot MAC.
 *   update and final return 0 on success, 1 if ctx is not a context of this
 *   function or was finalised, and 2 (update) if the total length of the
 *   inner hash would reach 2^61 bytes; on a result other than 0 they write
 *   nothing.
 *
 * Constant time: the key, the message, the context and the tag are secret;
 *   key, keylen, msg, msglen, in, inlen and the results of update and final
 *   are public. The code declassifies the function tag and the total length
 *   stored in a context, which the results are computed from. */
#ifndef FIPS198SHA512_AVX2_H
#define FIPS198SHA512_AVX2_H

#include <stdint.h>

#define FIPS198SHA512_BYTES 64  /* tag length */
#define FIPS198SHA512_CTXBYTES 272  /* context length */

void jade_mac_hmac_sha512_amd64_avx2(
    uint8_t *out,
    const uint8_t *key,
    uint64_t keylen,
    const uint8_t *msg,
    uint64_t msglen);

void jade_mac_hmac_sha512_amd64_avx2_init(
    uint8_t *ctx,
    const uint8_t *key,
    uint64_t keylen);

uint64_t jade_mac_hmac_sha512_amd64_avx2_update(
    uint8_t *ctx,
    const uint8_t *in,
    uint64_t inlen);

uint64_t jade_mac_hmac_sha512_amd64_avx2_final(
    uint8_t *ctx,
    uint8_t *out);

#endif /* FIPS198SHA512_AVX2_H */
