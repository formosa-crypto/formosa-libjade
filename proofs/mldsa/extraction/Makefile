# EasyCrypt models of the ML-DSA AVX2 implementation, one per parameter set,
# from the internal entry points (the exported functions only add the
# misspeculation-flag initialisation and the context-length check).
#
#   make            # regenerate Mldsa<set>.ec for every set, and the arrays
#   make generic    # regenerate ../generic from the models
#
# The models are checked in; a clean `git diff` after `make` shows that they
# are the extraction of the checked-in sources.

SRC      := ../../../src
SETS     := 44 65 87
ARRAYS   := ../../arrays
JASMIN2EC ?= jasmin2ec

MODELS := $(SETS:%=Mldsa%.ec)

.PHONY: all generic clean
all: $(MODELS)

Mldsa%.ec: FORCE
	env JASMINPATH="Common=$(SRC)/mldsa/avx2/common:Keccak=$(SRC)/fips202" \
	  $(JASMIN2EC) --output-array=$(ARRAYS) --array-model=old \
	    $(SRC)/mldsa/avx2/$*/mldsa.jazz -o $@ \
	    -f __keygen_internal -f __sign_internal -f __verify_internal

generic: $(MODELS)
	python3 generalize.py

clean:
	rm -f $(MODELS)

.PHONY: FORCE
FORCE:
