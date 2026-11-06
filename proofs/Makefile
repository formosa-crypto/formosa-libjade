# -*- Makefile -*-
# Check the EasyCrypt proofs (scenarios of tests.config), and extract the
# EasyCrypt models of the Jasmin sources in ../src.

# --------------------------------------------------------------------
EASYCRYPT ?= easycrypt
JOBS      ?=
REPORT    ?=
MEMORY    ?=
ECFLAGS   ?=
ECRUNTEST ?= $(EASYCRYPT) runtest $(if $(JOBS),-jobs $(JOBS),) $(if $(REPORT),-report $(REPORT),) $(ECFLAGS)

# REPORT=<file>: the per-file report of runtest (YAML). MEMORY=<file>: the
# peak memory of every checked file, one JSON line each (../scripts/ecmem):
# the runtest script of the installed EasyCrypt runs with ecmem as its
# binary, which `easycrypt runtest` does not allow (ECFLAGS is not used).
ifneq ($(MEMORY),)
RUNTEST   := $(shell $(EASYCRYPT) config 2>&1 | sed -n 's|^Commands PATH: *||p')/runtest
ECRUNTEST := env ECMEM_LOG=$(abspath $(MEMORY)) ECMEM_EASYCRYPT=$(shell command -v $(EASYCRYPT)) \
  python3 $(RUNTEST) --bin=$(abspath ../scripts/ecmem) $(if $(JOBS),--jobs=$(JOBS),) \
  $(if $(REPORT),--report=$(REPORT),)
endif

CONFIG    := tests.config
SCENARIOS := core fips202 mldsa mlkem mlkem-avx2-generic mlkem-avx2-512 mlkem-avx2-768 mlkem-avx2-1024 mlkem-safety mldsa-safety fips202-safety

# --------------------------------------------------------------------
.PHONY: default check all $(SCENARIOS) clean

default: check

# `check`/`all` run every scenario in a single runtest invocation; each
# scenario is also a target on its own (e.g. `make core`, `make mlkem-avx2-768`).
check all:
	$(ECRUNTEST) $(CONFIG) $(SCENARIOS)

$(SCENARIOS):
	$(ECRUNTEST) $(CONFIG) $@

# --------------------------------------------------------------------
# Extraction. The models are committed: `make extract` writes them again
# in place, with the array theories they use in arrays/ and the generic
# theories derived from them (generalize.py); `make check-extraction`
# fails if a file under proofs/ then differs from the committed one.
#
# The correctness models come from the jasmin2ec of the pinned Jasmin
# release. The safety models (`-m safety`) need the jasmin2ec of the Jasmin
# branch safety-assert2 (JASMIN2EC_SAFETY).
#
# The Keccak models are extracted from the harnesses of fips202/extracted
# and safety/fips202/extracted; the *_ASIZE models are the array variants
# at the dummy size _ASIZE = 999, which the proofs abstract over the size
# (checked by the *_checkXtr.ec files).

JASMIN2EC        ?= jasmin2ec
JASMIN2EC_SAFETY ?= jasmin2ec-safety

SRC        := ../src
KECCAK     := -I Keccak=$(SRC)/fips202
COMMON     := -I Common=$(SRC)/mldsa/avx2/sct/common
MLDSA_SETS := 44 65 87
MLKEM_SETS := 512 768 1024

CORRECTNESS := $(JASMIN2EC) --array-model=old --output-array=arrays
SAFETY      := $(JASMIN2EC_SAFETY) -m safety --array-model=barray --output-array=arrays

.PHONY: extract extract-correctness extract-safety check-extraction extraction-unchanged

extract: extract-correctness extract-safety

# ML-DSA and ML-KEM: the internal entry points (the exported functions only
# add the misspeculation-flag initialisation and the context-length check)
extract-correctness:
	$(CORRECTNESS) $(KECCAK) fips202/extracted/toEC_keccak1600.jazz \
	  -o fips202/extracted/Keccak1600_Jazz.ec
	$(CORRECTNESS) $(KECCAK) fips202/extracted/toEC_keccak1600_ASIZE.jazz \
	  -o fips202/extracted/Keccak1600_Jazz_ASIZE.ec
	for s in $(MLDSA_SETS); do \
	  $(CORRECTNESS) $(COMMON) $(KECCAK) $(SRC)/mldsa/avx2/sct/$$s/mldsa.jazz \
	    -o mldsa/avx2/sct/correctness/extraction/Mldsa$$s.ec \
	    -f __keygen_internal -f __sign_internal -f __verify_internal || exit 1; \
	done
	for s in $(MLKEM_SETS); do \
	  $(CORRECTNESS) $(KECCAK) $(SRC)/mlkem/avx2/sct/$$s/jmlkem.jazz \
	    -o mlkem/avx2/sct/correctness/extraction/$$s/Jkem_avx2.ec \
	    -f __crypto_kem_keypair_jazz -f __crypto_kem_enc_jazz \
	    -f __crypto_kem_dec_jazz -f __crypto_kem_check_pk_jazz \
	    -f __crypto_kem_check_sk_jazz -f __crypto_kem_encaps_derand_jazz \
	    -f __crypto_kem_decaps_jazz || exit 1; \
	done
	python3 mldsa/avx2/sct/correctness/extraction/generalize.py
	python3 mlkem/avx2/sct/correctness/extraction/generalize.py

# ML-DSA and ML-KEM: the exported functions, whose contracts are the
# `#[safety = ...]` annotations of the sources
extract-safety:
	$(SAFETY) $(KECCAK) safety/fips202/extracted/toEC_keccak1600.jazz \
	  -o safety/fips202/extracted/Keccak1600_Jazz_safety.ec
	$(SAFETY) $(KECCAK) safety/fips202/extracted/toEC_keccak1600_ASIZE.jazz \
	  -o safety/fips202/extracted/Keccak1600_Jazz_ASIZE_safety.ec
	for s in $(MLDSA_SETS); do \
	  $(SAFETY) $(COMMON) $(KECCAK) $(SRC)/mldsa/avx2/sct/$$s/mldsa.jazz \
	    -o mldsa/avx2/sct/safety/$$s/Jmldsa$${s}_safety.ec \
	    -f ml_dsa_$${s}_keygen -f ml_dsa_$${s}_sign \
	    -f ml_dsa_$${s}_verify || exit 1; \
	done
	for s in $(MLKEM_SETS); do \
	  p=jade_kem_mlkem_mlkem$${s}_amd64_avx2; \
	  $(SAFETY) $(KECCAK) $(SRC)/mlkem/avx2/sct/$$s/jmlkem.jazz \
	    -o mlkem/avx2/sct/safety/$$s/Jkem$${s}_safety.ec \
	    -f $${p}_keypair_derand -f $${p}_enc_derand -f $${p}_dec \
	    -f $${p}_check_pk -f $${p}_check_sk || exit 1; \
	done

check-extraction: extract
	@$(MAKE) --no-print-directory extraction-unchanged

# no file under proofs/ differs from the committed one
extraction-unchanged:
	@if [ -n "$$(git status --porcelain -- .)" ]; then \
	  echo "the committed models are not the extraction of ../src:"; \
	  git status --short -- .; \
	  exit 1; \
	fi
	@echo "extracted models up to date"

# --------------------------------------------------------------------
clean:
	find . -name '*.eco' -print0 | xargs -0 rm -f
