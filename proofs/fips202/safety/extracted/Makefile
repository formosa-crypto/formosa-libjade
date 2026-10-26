# Safety models of the Keccak code in src/fips202: `jasmin2ec -m safety`, with
# the barray array model. The safety extraction is only available in Jasmin's
# `safety-assert2` branch (jasmin 1e7479a2, jasmin-compiler c1cae60e), not in
# the release the rest of the repository uses (2026.03.1, whose jasmin2ec
# rejects `-m safety`). Point JASMIN2EC_SAFETY at that build, e.g.
#
#     make re_extract JASMIN2EC_SAFETY=~/.opam/jasmin-safety/bin/jasmin2ec
#
# (the nix dev shell sets it). Same strategy as the correctness extraction:
#  - Keccak1600_Jazz_safety.ec: memory variants (and everything that does not
#    depend on the array size), extracted directly;
#  - Keccak1600_Jazz_ASIZE_safety.ec: array variants, extracted under the
#    dummy size _ASIZE = 999. It is abstracted over the size by ../gen (module
#    MM of the abstract theories in the proof files); the *_checkXtr.ec files
#    check that MM is the abstraction of this extraction.
# The array theories (Array*, BArray*, SBArray*, WArray*) are written here,
# not in proofs/arrays: they are barray-model theories, the correctness proofs
# use the old model.
#
# Besides each model, jasmin2ec writes a proof skeleton (*.skel: one lemma per
# function); ../gen takes the lemma statements from it. Not committed: run
# `make re_extract` before regenerating the proofs.

REPO             := ../../../..
KECCAK           := $(REPO)/src/fips202
JASMIN2EC_SAFETY ?= jasmin2ec
JECFLAGS         := --arch x86-64 --array-model=barray -m safety
KECCAK_DEPS      := $(shell find $(KECCAK) -name '*.jinc' 2>/dev/null)
HARNESS          := toEC_keccak1600.jazz ../../extracted/toEC_keccak1600.jazz

extract = $(JASMIN2EC_SAFETY) $(JECFLAGS) -I Keccak=$(KECCAK) -o $(2) --output-proof $(2:.ec=.skel) $(1)

PROGS = Keccak1600_Jazz_safety.ec Keccak1600_Jazz_ASIZE_safety.ec

.DEFAULT_GOAL := all
.PHONY: all re_extract_mem re_extract_array re_extract clean

all: $(PROGS)

re_extract_mem: Keccak1600_Jazz_safety.ec
Keccak1600_Jazz_safety.ec: $(HARNESS) $(KECCAK_DEPS)
	$(call extract,$<,$@)

re_extract_array: Keccak1600_Jazz_ASIZE_safety.ec
Keccak1600_Jazz_ASIZE_safety.ec: toEC_keccak1600_ASIZE.jazz $(HARNESS) $(KECCAK_DEPS)
	$(call extract,$<,$@)

re_extract: clean all

clean:
	rm -f $(PROGS) *.skel Array*.ec WArray*.ec BArray*.ec SBArray*.ec *~
