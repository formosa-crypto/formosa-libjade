# Safety models of the Keccak code in src/fips202: `jasmin2ec -m safety`, with
# the barray array model. The safety extraction is only available in Jasmin's
# `safety-assert2` branch (jasmin 1e7479a2, jasmin-compiler c1cae60e), not in
# the release the rest of the repository uses (2026.03.1, whose jasmin2ec
# rejects `-m safety`). Point JASMIN2EC_SAFETY at that build, e.g.
#
#     make re_extract JASMIN2EC_SAFETY=~/.opam/jasmin-safety/bin/jasmin2ec
#
# Same strategy as the correctness extraction:
#  - Keccak1600_Jazz_safety.ec: memory variants (and everything that does not
#    depend on the array size), extracted directly;
#  - Keccak1600_Jazz_ASIZE_safety.ec: array variants, extracted under the
#    dummy size _ASIZE = 999. The proof files abstract it over the size
#    (module MM of their abstract theories); the *_checkXtr.ec files check
#    that MM is the abstraction of this extraction.
# The array theories jasmin2ec writes next to a model (Array*, BArray*,
# SBArray*, WArray*) are moved to proofs/arrays, shared with every
# extraction of the repository.
#
# `make check` extracts the models again into _check/ and compares them, and
# their array theories, with the committed ones.

REPO             := ../../../..
KECCAK           := $(REPO)/src/fips202
ARRAYS           := $(REPO)/proofs/arrays
JASMIN2EC_SAFETY ?= jasmin2ec
JECFLAGS         := --arch x86-64 --array-model=barray -m safety
KECCAK_DEPS      := $(shell find $(KECCAK) -name '*.jinc' 2>/dev/null)
HARNESS          := toEC_keccak1600.jazz ../../../fips202/extracted/toEC_keccak1600.jazz

# $(call extract,<harness>,<model>): the model; the array theories it uses
# are written next to it
extract = $(JASMIN2EC_SAFETY) $(JECFLAGS) -I Keccak=$(KECCAK) -o $(2) $(1)

# $(call share_arrays,<model>): move the array theories written next to the
# model to proofs/arrays (dropped when proofs/arrays has the file already)
define share_arrays
	for f in $(dir $(1))*Array*.ec; do \
	  if [ -f $(ARRAYS)/$$(basename $$f) ]; then rm $$f; \
	  else mv $$f $(ARRAYS)/; fi; \
	done
endef

PROGS = Keccak1600_Jazz_safety.ec Keccak1600_Jazz_ASIZE_safety.ec

.DEFAULT_GOAL := all
.PHONY: all re_extract_mem re_extract_array re_extract check clean

all: $(PROGS)

re_extract_mem: Keccak1600_Jazz_safety.ec
Keccak1600_Jazz_safety.ec: $(HARNESS) $(KECCAK_DEPS)
	$(call extract,$<,$@)
	$(call share_arrays,$@)

re_extract_array: Keccak1600_Jazz_ASIZE_safety.ec
Keccak1600_Jazz_ASIZE_safety.ec: toEC_keccak1600_ASIZE.jazz $(HARNESS) $(KECCAK_DEPS)
	$(call extract,$<,$@)
	$(call share_arrays,$@)

re_extract: clean all

# a fresh extraction must reproduce the committed models and array theories
check:
	rm -rf _check && mkdir -p _check
	$(call extract,toEC_keccak1600.jazz,_check/Keccak1600_Jazz_safety.ec)
	$(call extract,toEC_keccak1600_ASIZE.jazz,_check/Keccak1600_Jazz_ASIZE_safety.ec)
	for f in $(PROGS); do cmp _check/$$f $$f || exit 1; done
	for f in _check/*Array*.ec; do cmp $$f $(ARRAYS)/$$(basename $$f) || exit 1; done
	@echo "Keccak safety models up to date"

clean:
	rm -f $(PROGS) *~
	rm -rf _check
