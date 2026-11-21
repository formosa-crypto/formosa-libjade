/* 8-way SHA-256 (FIPS 180-4), target avx2, profile sct: 8 SHA-256 hashes of
 * messages of equal length, computed together.
 *
 * One-shot hash
 * Requires:
 *   - in points to a table of 8 pointers, lane k's message being the
 *     inlen bytes at in[k] (initialised; not read when inlen is 0); lanes may
 *     overlap each other;
 *   - out points to FIPS180SHA256X8_BYTES bytes, which overlap no lane;
 *   - inlen < 2^61 (the message length in bits fits in 64 bits);
 *   - the CPU has AVX2;
 *   - while the function runs, the caller ensures that no other thread writes
 *     to the input, or reads or writes the output.
 * Ensures:
 *   - out + 32 k holds SHA-256 of lane k's message (Section 6.2 in
 *     FIPS 180-4), for every lane k;
 *   - the function writes no memory outside out, keeps no state between
 *     calls, and clears the stack it used before it returns.
 * Pointers need no alignment.
 *
 * Incremental hash
 *   A context is FIPS180SHA256X8_CTXBYTES bytes of caller memory, which only
 *   these functions read or write. init starts the hash of the empty
 *   message in every lane; init_from starts every lane with the message so
 *   far of src, a context of jade_hash_sha256_amd64_avx2 (112 bytes, see
 *   fips180sha256.h), which it does not change; update appends the inlen
 *   bytes at in[k] to lane k; final writes the digests of the lanes to out
 *   as the one-shot hash does and zeroes the context, so that it cannot be
 *   used again before the next init.
 *   Requires: the regions of a call do not overlap; the other requirements
 *     of the one-shot hash.
 *   init_from returns 1 if src is not a context of jade_hash_sha256_amd64_avx2
 *   or was finalised; update and final return 1 if ctx is not a context of
 *   this function or was finalised, and update returns 2 if the total length
 *   would reach 2^61 bytes; all return 0 on success, and on a result other
 *   than 0 they write nothing.
 *
 * Constant time: the messages, the contexts and the digests are secret; in,
 *   the lane pointers, inlen and the results of init_from, update and final
 *   are public. The code declassifies the function tag and the total length
 *   stored in a context, which the results are computed from. */
#ifndef FIPS180SHA256X8_AVX2_H
#define FIPS180SHA256X8_AVX2_H

#include <stdint.h>

#define FIPS180SHA256X8_BYTES 256  /* digests of the 8 lanes */
#define FIPS180SHA256X8_CTXBYTES 784  /* context length */

void jade_hash_sha256x8_amd64_avx2(
    uint8_t *out,
    const uint8_t *const in[8],
    uint64_t inlen);

void jade_hash_sha256x8_amd64_avx2_init(
    uint8_t *ctx);

uint64_t jade_hash_sha256x8_amd64_avx2_init_from(
    uint8_t *ctx,
    const uint8_t *src);

uint64_t jade_hash_sha256x8_amd64_avx2_update(
    uint8_t *ctx,
    const uint8_t *const in[8],
    uint64_t inlen);

uint64_t jade_hash_sha256x8_amd64_avx2_final(
    uint8_t *ctx,
    uint8_t *out);

#endif /* FIPS180SHA256X8_AVX2_H */
