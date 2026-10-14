# TODO

* CI check extracted models are consistent with the source 
* CI check assembly is consistent with the source 
* Redo safety
* Clean up dead lemmas
* Remove unreferenced proof files: `proofs/mldsa/x86-64/avx2/common/ntt/{fnttalgcorrect,inttalgcorrect,pwmultest}.ec` are required by nothing
* Remove redundant lemmas
* Wrap the proof lines over 100 characters in `proofs/mldsa/x86-64/avx2/{generic,variants}`
* Do ct + sct for mldsa
* add ct + sct checks to CI
