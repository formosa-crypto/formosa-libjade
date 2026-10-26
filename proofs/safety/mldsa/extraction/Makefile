# Safety model of the ML-DSA AVX2 entry points, extracted from the Jasmin
# sources in src/ with `jasmin2ec --model safety`.  Every procedure of the
# model returns a trace of the safety checks of the implementation
# (initialisation of the bytes it reads, array bounds) and carries a
# witness array per byte array; `<f>_spec` states the contract of f, from
# the `#[safety = ...]` annotations of the sources.
#
# The safety model is only produced by the Jasmin branch `safety-assert2`
# (jasmin-lang/jasmin PR 1170): point JASMIN2EC at its jasmin2ec.  The
# byte-array theories it emits next to the model (BArray*, SBArray*) are
# moved to ../../../arrays.
#
# `make check` extracts the models again into _check/ and compares them,
# and their byte-array theories, with the committed ones.

REPO      := ../../../..
SRC       := $(REPO)/src/mldsa/avx2
KECCAK    := $(REPO)/src/fips202
ARRAYS    := ../../../arrays
JASMIN2EC ?= jasmin2ec

COMMON_DEPS := $(shell find $(SRC)/common $(KECCAK) -name '*.jinc' 2>/dev/null)

# $(call extract,<set>,<dir>): model of the exported functions of a
# parameter set, written to <dir> with its byte-array theories
define extract
	mkdir -p $(2)
	cd $(REPO)/src && env JASMINPATH="Common=mldsa/avx2/common:Keccak=fips202" \
	  $(JASMIN2EC) mldsa/avx2/$(1)/mldsa.jazz --model safety \
	  -o $(abspath $(2))/Jmldsa$(1)_safety.ec \
	  -f ml_dsa_$(1)_keygen -f ml_dsa_$(1)_sign -f ml_dsa_$(1)_verify
endef

SETS := 44 65 87
MODELS := $(foreach s,$(SETS),../avx2/$(s)/Jmldsa$(s)_safety.ec)

.PHONY: all check clean $(addprefix check-,$(SETS))
all: $(MODELS)

# $(call rule,<set>): the model of a parameter set depends on its sources;
# check-<set> compares a fresh extraction with the committed files
define rule
../avx2/$(1)/Jmldsa$(1)_safety.ec: $(SRC)/$(1)/mldsa.jazz $(SRC)/$(1)/parameters.jinc $(COMMON_DEPS)
	$(call extract,$(1),../avx2/$(1))
	for f in ../avx2/$(1)/*Array*.ec; do \
	  if [ -f $(ARRAYS)/$$$$(basename $$$$f) ]; then rm $$$$f; \
	  else mv $$$$f $(ARRAYS)/; fi; \
	done

check-$(1):
	rm -rf _check/$(1)
	$(call extract,$(1),_check/$(1))
	cmp _check/$(1)/Jmldsa$(1)_safety.ec ../avx2/$(1)/Jmldsa$(1)_safety.ec
	for f in _check/$(1)/*Array*.ec; do \
	  cmp $$$$f $(ARRAYS)/$$$$(basename $$$$f) || exit 1; \
	done
endef
$(foreach s,$(SETS),$(eval $(call rule,$(s))))

check: $(addprefix check-,$(SETS))
	@echo "ML-DSA safety models up to date"

clean:
	rm -rf _check
