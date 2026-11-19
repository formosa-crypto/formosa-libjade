/* Jasmin Keccak Code Package (JKCP) -- FIPS 202 (SHA-3 / SHAKE).
 *
 * Common to all functions
 *   Requires:
 *     - every pointer argument points to a memory region of the size stated
 *       in the prototype or chosen by the caller (output_length for SHAKE,
 *       length for keccak_squeeze), and every input region is initialised;
 *     - the memory regions of a call do not overlap;
 *     - while the function runs, the caller ensures that no other thread writes
 *       to an input region, or reads or writes an output region.
 *   Ensures:
 *     - the function writes all of its output regions, and no memory outside
 *       the regions of the call.
 *   Pointers need no alignment. */
#ifndef JKCP_H
#define JKCP_H

#include <stdint.h>

/* =====================================================================
   State
   ===================================================================== */

/* keccak_updstate: 26 x uint64_t (208 bytes).
 * Words 0-24: Keccak-f[1600] state (25 lanes).
 * Word 25: status -- packs the current byte position (byte 0), the rate
 *   in 8-byte words minus one (byte 1), and the trail byte (byte 2), which
 *   the first squeeze clears. */
#define JKCP_STATE_SIZE 208
typedef uint64_t jkcp_state[26];

/* =====================================================================
   One-shot SHA-3
   ===================================================================== */

#define JKCP_SHA3_224_OUTPUT_SIZE 28
#define JKCP_SHA3_256_OUTPUT_SIZE 32
#define JKCP_SHA3_384_OUTPUT_SIZE 48
#define JKCP_SHA3_512_OUTPUT_SIZE 64

/* Ensures: output holds SHA3-224(input[0..input_length-1]). */
void sha3_224(
    uint8_t *output,
    const uint8_t *input,
    uint64_t input_length);

/* Ensures: output holds SHA3-256(input[0..input_length-1]). */
void sha3_256(
    uint8_t *output,
    const uint8_t *input,
    uint64_t input_length);

/* Ensures: output holds SHA3-384(input[0..input_length-1]). */
void sha3_384(
    uint8_t *output,
    const uint8_t *input,
    uint64_t input_length);

/* Ensures: output holds SHA3-512(input[0..input_length-1]). */
void sha3_512(
    uint8_t *output,
    const uint8_t *input,
    uint64_t input_length);

/* =====================================================================
   One-shot SHAKE
   ===================================================================== */

/* Ensures: output[0..output_length-1] holds the first output_length bytes
 *   of SHAKE128(input[0..input_length-1]). */
void shake128(
    uint8_t *output,
    uint64_t output_length,
    const uint8_t *input,
    uint64_t input_length);

/* Ensures: output[0..output_length-1] holds the first output_length bytes
 *   of SHAKE256(input[0..input_length-1]). */
void shake256(
    uint8_t *output,
    uint64_t output_length,
    const uint8_t *input,
    uint64_t input_length);

/* =====================================================================
   Incremental: per-variant init
   ===================================================================== */

/* Each init function zeroes the Keccak state and sets the rate and trail
 * byte for the corresponding algorithm.
 *
 * Ensures: state is ready for keccak_absorb and keccak_squeeze. */

void sha3_224_init(jkcp_state state);
void sha3_256_init(jkcp_state state);
void sha3_384_init(jkcp_state state);
void sha3_512_init(jkcp_state state);
void shake128_init(jkcp_state state);
void shake256_init(jkcp_state state);

/* =====================================================================
   Incremental: generic absorb / squeeze
   ===================================================================== */

/* Requires: state was returned by an init function, keccak_absorb, or
 *   keccak_squeeze with length 0: no squeeze of a positive length has been
 *   made on it.
 * Ensures: the bytes data[0..length-1] are absorbed into state. */
void keccak_absorb(
    jkcp_state state,
    const uint8_t *data,
    uint64_t length);

/* Requires: state was returned by an init function, keccak_absorb or
 *   keccak_squeeze.
 * Ensures: output[0..length-1] holds the next length bytes of the sponge
 *   output.  The first call with length > 0 applies the padding (there is
 *   no separate finalize); later calls continue where the previous one left
 *   off (for SHAKE XOF), and a call with length 0 changes nothing.  For
 *   SHA-3, a single call with the algorithm's output size suffices. */
void keccak_squeeze(
    jkcp_state state,
    uint8_t *output,
    uint64_t length);

/* =====================================================================
   4-way AVX2: state
   ===================================================================== */

/* keccakx4_updstate: 101 x uint64_t (808 bytes).
 * Words 0-99: four interleaved Keccak-f[1600] states (4 x 25 lanes,
 *   stored as u256[25]).
 * Word 100: status -- same layout as the single-lane status word. */
#define JKCP_X4_STATE_SIZE 808
typedef uint64_t jkcp_x4_state[101];

/* =====================================================================
   4-way AVX2: per-variant init
   ===================================================================== */

/* Each init function zeroes all four lanes and sets the rate and trail
 * byte for the corresponding algorithm.
 *
 * Ensures: state is ready for the absorb functions and keccakx4_squeeze. */

void sha3_224x4_init(jkcp_x4_state state);
void sha3_256x4_init(jkcp_x4_state state);
void sha3_384x4_init(jkcp_x4_state state);
void sha3_512x4_init(jkcp_x4_state state);
void shake128x4_init(jkcp_x4_state state);
void shake256x4_init(jkcp_x4_state state);

/* =====================================================================
   4-way AVX2: generic absorb / squeeze
   ===================================================================== */

/* Broadcast absorb: the same data is XORed into all four lanes.
 *
 * Requires: no squeeze of a positive length has been made on state.
 * Ensures: the bytes data[0..length-1] are absorbed into every lane. */
void keccakx4_absorb_bcast(
    jkcp_x4_state state,
    const uint8_t *data,
    uint64_t length);

/* Independent absorb: four separate buffers of the same length, one per
 * lane.
 *
 * Requires: no squeeze of a positive length has been made on state.
 * Ensures: data_i[0..length-1] is absorbed into lane i (i = 0..3). */
void keccakx4_absorb(
    jkcp_x4_state state,
    const uint8_t *data0,
    const uint8_t *data1,
    const uint8_t *data2,
    const uint8_t *data3,
    uint64_t length);

/* Ensures: output_i[0..length-1] holds the next length bytes of the
 *   sponge output of lane i (i = 0..3).  The first call with length > 0
 *   applies the padding to all four lanes; later calls continue where the
 *   previous one left off, and a call with length 0 changes nothing. */
void keccakx4_squeeze(
    jkcp_x4_state state,
    uint8_t *output0,
    uint8_t *output1,
    uint8_t *output2,
    uint8_t *output3,
    uint64_t length);

#endif /* JKCP_H */
