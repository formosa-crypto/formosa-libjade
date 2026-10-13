SOURCE = ../../../../../src/mldsa/avx2/65
COMMON = ../../../../../src/mldsa/avx2/common
OARRAYS = ../../../../arrays
JASMIN2EC = jasmin2ec --output-array=$(OARRAYS)
KECCAK = ../../../../../src/fips202

# --------------------------------------------------------------------
all: ec


ec: 
	env JASMINPATH="Common=$(COMMON):Keccak=$(KECCAK)" $(JASMIN2EC) $(SOURCE)/mldsa.jazz --array-model=old -o ml_dsa_65_avx2.ec \
	  -f ml_dsa_65_keygen \
	  -f ml_dsa_65_sign \
	  -f ml_dsa_65_verify
# 	env JASMINPATH="Common=$(COMMON):Keccak=$(KECCAK)" $(JASMIN2EC) $(SOURCE)/mldsa.jazz -o ml_dsa_65_avx2_barray.ec \
# 	  -f ml_dsa_65_keygen \
# 	  -f ml_dsa_65_sign \
# 	  -f ml_dsa_65_verify

clean:
	rm -f ml_dsa_65_avx2.ec
