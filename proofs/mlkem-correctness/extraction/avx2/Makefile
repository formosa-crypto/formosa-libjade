# EasyCrypt extraction of the ML-KEM AVX2 derand entry points from the Jasmin
# sources in src/. The model is written to stdout, so jasmin2ec does NOT emit
# the array/word theories: those are provided by the proof development

REPO      := ../../../..
SRC       := $(REPO)/src/mlkem/avx2
KECCAK    := $(REPO)/src/fips202
JASMIN2EC := jasmin2ec

COMMON_DEPS := $(wildcard $(SRC)/common/*.jinc) \
               $(shell find $(KECCAK) -name '*.jinc' 2>/dev/null)

# $(call extract,<entry.jazz>) -> jasmin2ec command (stdout).  The models
# start from the internal entry points: the exported functions only add the
# misspeculation-flag initialisation, and their names depend on the set.
extract = env JASMINPATH="Keccak=$(KECCAK)" $(JASMIN2EC) $(1) --array-model=old \
            -f __crypto_kem_keypair_jazz \
            -f __crypto_kem_enc_jazz \
            -f __crypto_kem_dec_jazz

.PHONY: all generic clean
all: 768/Jkem_avx2.ec 1024/Jkem_avx2.ec

# the generic model ../../generic/{LayoutT,JkemConstants,JkemT}.ec and the
# instances ../../avx2/<set>/Jkem<set>I.ec
generic: all
	python3 generalize.py

768/Jkem_avx2.ec: $(SRC)/768/jmlkem.jazz $(wildcard $(SRC)/768/*.jinc) $(COMMON_DEPS)
	@mkdir -p 768
	$(call extract,$<) > $@

1024/Jkem_avx2.ec: $(SRC)/1024/jmlkem.jazz $(wildcard $(SRC)/1024/*.jinc) $(COMMON_DEPS)
	@mkdir -p 1024
	$(call extract,$<) > $@

clean:
	rm -f 768/Jkem_avx2.ec 1024/Jkem_avx2.ec
