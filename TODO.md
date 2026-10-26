# TODO

* CI check extracted models are consistent with the source 
* CI check assembly is consistent with the source 
* Clean up dead lemmas
* Remove unreferenced proof files: `proofs/mldsa/x86-64/avx2/common/ntt/{fnttalgcorrect,inttalgcorrect,pwmultest}.ec` are required by nothing
* Remove redundant lemmas
* Wrap the proof lines over 100 characters in `proofs/mldsa/x86-64/avx2/{generic,variants}`
* Do ct + sct for mldsa
* add ct + sct checks to CI
* Safety proofs: add `proofs/timing-safety.yml` to the timing sunburst/dashboard (`scripts/timing-report-to-json.py` reads one report)
* Safety proofs: upstream the jasmin-nist ref updstate variants (SPILL conditional, `*_export.jinc`, bare-state steps and their contracts, `gen/cfg_ref.py` annotations) to formosa-keccak
* Safety proofs: drop `JASMIN_SAFETY_ECLIB`/`jasminSafety` once a Jasmin release ships `-m safety` and `JSafety.ec`
