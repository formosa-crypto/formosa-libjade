# jasmin-nist

Jasmin implementations and EasyCrypt proofs of ML-KEM and ML-DSA.

- **Assembly**: [`asm/`](asm) holds the x86-64 (AVX2) assembly of every
  entry point for Linux, compiled from `src/` by `make -C src extract-asm`;
  the CI checks that it is up to date.
- **Results dashboard**: [proof-checking times and cycle benchmarks](https://www.strub.nu/jasmin-nist-timing/)
  for every commit on `main`: the latest results, trends over the history,
  comparisons between any two commits, and pull requests against their merge base.
