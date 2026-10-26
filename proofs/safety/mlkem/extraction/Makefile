# Safety model of the ML-KEM AVX2 derand entry points, extracted from the
# Jasmin sources in src/ with `jasmin2ec --model safety`.  Every procedure
# of the model returns a trace of the safety checks of the implementation
# (initialisation of the bytes it reads, array bounds) and carries a
# witness array per byte array; `<f>_spec` states the contract of f.
#
# The safety model is only produced by the Jasmin branch `safety-assert2`
# (jasmin-lang/jasmin PR 1170): point JASMIN2EC at its jasmin2ec.  The
# byte-array theories it emits next to the model (BArray*, SBArray*) are
# moved to ../../../arrays.
#
# `make check` extracts the models again into _check/ and compares them,
# and their byte-array theories, with the committed ones.

REPO      := ../../../..
SRC       := $(REPO)/src/mlkem/avx2
KECCAK    := $(REPO)/src/fips202
ARRAYS    := ../../../arrays
JASMIN2EC ?= jasmin2ec

COMMON_DEPS := $(wildcard $(SRC)/common/*.jinc) \
               $(shell find $(KECCAK) -name '*.jinc' 2>/dev/null)

# $(call extract,<set>,<dir>): model of the exported functions of a
# parameter set, written to <dir> with its byte-array theories
define extract
	mkdir -p $(2)
	env JASMINPATH="Keccak=$(KECCAK)" $(JASMIN2EC) $(SRC)/$(1)/jmlkem.jazz \
	  --model safety -o $(2)/Jkem$(1)_safety.ec \
	  -f jade_kem_mlkem_mlkem$(1)_amd64_avx2_keypair_derand \
	  -f jade_kem_mlkem_mlkem$(1)_amd64_avx2_enc_derand \
	  -f jade_kem_mlkem_mlkem$(1)_amd64_avx2_dec
endef

SETS := 512 768 1024
MODELS := $(foreach s,$(SETS),../avx2/$(s)/Jkem$(s)_safety.ec)

.PHONY: all check clean $(addprefix check-,$(SETS))
all: $(MODELS)

# $(call rule,<set>): the model of a parameter set depends on its sources;
# check-<set> compares a fresh extraction with the committed files
define rule
../avx2/$(1)/Jkem$(1)_safety.ec: $(SRC)/$(1)/jmlkem.jazz $(wildcard $(SRC)/$(1)/*.jinc) $(COMMON_DEPS)
	$(call extract,$(1),../avx2/$(1))
	for f in ../avx2/$(1)/*Array*.ec; do \
	  if [ -f $(ARRAYS)/$$$$(basename $$$$f) ]; then rm $$$$f; \
	  else mv $$$$f $(ARRAYS)/; fi; \
	done

check-$(1):
	rm -rf _check/$(1)
	$(call extract,$(1),_check/$(1))
	cmp _check/$(1)/Jkem$(1)_safety.ec ../avx2/$(1)/Jkem$(1)_safety.ec
	for f in _check/$(1)/*Array*.ec; do \
	  cmp $$$$f $(ARRAYS)/$$$$(basename $$$$f) || exit 1; \
	done
endef
$(foreach s,$(SETS),$(eval $(call rule,$(s))))

check: $(addprefix check-,$(SETS))
	@echo "ML-KEM safety models up to date"

clean:
	rm -rf _check
