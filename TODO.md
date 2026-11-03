# TODO

* CI check extracted models are consistent with the source 
* CI check assembly is consistent with the source 
* Clean up dead lemmas
* Remove unreferenced proof files: `proofs/mldsa/x86-64/avx2/common/ntt/{fnttalgcorrect,inttalgcorrect,pwmultest}.ec` are required by nothing
* Remove redundant lemmas
* Wrap the proof lines over 100 characters in `proofs/mldsa/x86-64/avx2/{generic,variants}`
* Do ct + sct for mldsa
* add ct + sct checks to CI
* Safety proofs: upstream the jasmin-nist ref updstate variants (SPILL conditional, `*_export.jinc`, bare-state steps and their contracts, their safety proofs) to formosa-keccak
* Safety proofs: drop `proofs/safety/eclib` and `JASMIN2EC_SAFETY` once a Jasmin release ships `-m safety` and `JSafety.ec`
* Safety proofs: check in CI that the committed safety models are the extraction of the sources (needs the `safety-assert2` `jasmin2ec` on the runner; its opam-nix build fails on `mlgmpidl`)
