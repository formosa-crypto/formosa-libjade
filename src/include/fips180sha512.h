/* SHA-512 (FIPS 180-4), target avx2, profile sct.
 *
 * Requires:
 *   - out points to FIPS180SHA512_BYTES bytes, and in points to inlen
 *     initialised bytes (in is not read when inlen is 0);
 *   - inlen < 2^61 (the message length in bits fits in 64 bits);
 *   - out does not overlap the inlen bytes at in;
 *   - the CPU has AVX2, BMI1 and BMI2;
 *   - while the function runs, the caller ensures that no other thread writes
 *     to the input, or reads or writes the output.
 * Ensures:
 *   - out holds SHA-512 of the inlen bytes at in (Section 6.4 in FIPS 180-4);
 *   - the function writes no memory outside out, keeps no state between
 *     calls, and clears the stack it used before it returns.
 * Pointers need no alignment.
 * Constant time: the message and the digest are secret; in and inlen are
 *   public. Nothing is declassified. */
#ifndef FIPS180SHA512_AVX2_H
#define FIPS180SHA512_AVX2_H

#include <stdint.h>

#define FIPS180SHA512_BYTES 64  /* digest length */

void jade_hash_sha512_amd64_avx2(
    uint8_t *out,
    const uint8_t *in,
    uint64_t inlen);

#endif /* FIPS180SHA512_AVX2_H */
