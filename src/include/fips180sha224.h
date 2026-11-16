/* SHA-224 (FIPS 180-4), target avx2, profile sct.
 *
 * One-shot hash
 * Requires:
 *   - out points to FIPS180SHA224_BYTES bytes, and in points to inlen
 *     initialised bytes (in is not read when inlen is 0);
 *   - inlen < 2^61 (the message length in bits fits in 64 bits);
 *   - out does not overlap the inlen bytes at in;
 *   - the CPU has AVX2, BMI1 and BMI2;
 *   - while the function runs, the caller ensures that no other thread writes
 *     to the input, or reads or writes the output.
 * Ensures:
 *   - out holds SHA-224 of the inlen bytes at in (Section 6.3 in FIPS 180-4);
 *   - the function writes no memory outside out, keeps no state between
 *     calls, and clears the stack it used before it returns.
 * Pointers need no alignment.
 *
 * Incremental hash
 *   A context is FIPS180SHA224_CTXBYTES bytes of caller memory, which only
 *   these functions read or write. init starts the hash of the empty
 *   message; update appends the inlen bytes at in; final writes the digest
 *   of the bytes appended since init to out and zeroes the context, so that
 *   it cannot be used again before the next init.
 *   Requires: the regions of a call do not overlap; in points to inlen
 *     initialised bytes; the other requirements of the one-shot hash.
 *   update and final return 0 on success, 1 if ctx is not a context of this
 *   function or was finalised, and 2 (update) if the total length would
 *   reach 2^61 bytes; on a result other than 0 they write nothing.
 *
 * Constant time: the message, the context and the digest are secret; in,
 *   inlen and the results of update and final are public. The code
 *   declassifies the function tag and the total length stored in a context,
 *   which the results are computed from. */
#ifndef FIPS180SHA224_AVX2_H
#define FIPS180SHA224_AVX2_H

#include <stdint.h>

#define FIPS180SHA224_BYTES 28  /* digest length */
#define FIPS180SHA224_CTXBYTES 112  /* context length */

void jade_hash_sha224_amd64_avx2(
    uint8_t *out,
    const uint8_t *in,
    uint64_t inlen);

void jade_hash_sha224_amd64_avx2_init(
    uint8_t *ctx);

uint64_t jade_hash_sha224_amd64_avx2_update(
    uint8_t *ctx,
    const uint8_t *in,
    uint64_t inlen);

uint64_t jade_hash_sha224_amd64_avx2_final(
    uint8_t *ctx,
    uint8_t *out);

#endif /* FIPS180SHA224_AVX2_H */
