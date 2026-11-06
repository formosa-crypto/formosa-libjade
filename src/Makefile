# Makefile -- assembly (.s) generation for the ML-KEM / ML-DSA entry points.
#
# Sources are laid out as <prim>/<target>/<profile>/<set>/, with the code
# shared by the sets in <prim>/<target>/<profile>/common/; Keccak (FIPS 202)
# as fips202/<target>/common/.
#
# Jasmin namespaces are resolved through JASMINPATH:
#   Common -> per-implementation shared code (ML-DSA only)
#   Keccak -> in-tree src/fips202 (flattened from formosa-keccak)

JASMINC  ?= jasminc
JASMINCT ?= jasmin-ct
ARCH     ?= x86-64
JFLAGS   ?=
JCTFLAGS ?=

BUILD   ?= _build

# The implementation: target (instruction set) and profile.
TARGET  := avx2
PROFILE := sct
MLDSA   := mldsa/$(TARGET)/$(PROFILE)
MLKEM   := mlkem/$(TARGET)/$(PROFILE)

# Jasmin emits OS-specific assembly: the .s produced in $(BUILD) matches the
# host (Mach-O on macOS, ELF on Linux). bench/ links it into the libraries
# that the KATs, memcheck and the benchmarks load. The committed assembly,
# for Linux, is in ../asm (see below).

KECCAK       := fips202
MLDSA_COMMON := $(MLDSA)/common

# ---- entry points -> output assembly -------------------------------------
# Discovered by wildcard, so a new parameter set is picked up as soon as its
# source directory appears:
#   ML-DSA: mldsa/avx2/sct/<set>/mldsa.jazz   -> _build/mldsa<set>_avx2.s
#   ML-KEM: mlkem/avx2/sct/<param>/jmlkem.jazz -> _build/mlkem<param>_avx2.s
MLDSA_S := $(patsubst $(MLDSA)/%/mldsa.jazz,$(BUILD)/mldsa%_$(TARGET).s,\
             $(wildcard $(MLDSA)/*/mldsa.jazz))
MLKEM_S := $(patsubst $(MLKEM)/%/jmlkem.jazz,$(BUILD)/mlkem%_$(TARGET).s,\
             $(wildcard $(MLKEM)/*/jmlkem.jazz))

TARGETS := $(MLDSA_S) $(MLKEM_S)

# Parameter sets, from the same wildcards.
MLDSA_SETS   := $(patsubst $(MLDSA)/%/mldsa.jazz,%,$(wildcard $(MLDSA)/*/mldsa.jazz))
MLKEM_PARAMS := $(patsubst $(MLKEM)/%/jmlkem.jazz,%,$(wildcard $(MLKEM)/*/jmlkem.jazz))

# ---- dependency tracking (rebuild when any included source changes) ------
KECCAK_DEPS := $(shell find -L $(KECCAK) -name '*.jinc' 2>/dev/null)
MLDSA_DEPS  := $(shell find mldsa -name '*.jinc' 2>/dev/null) $(KECCAK_DEPS)
MLKEM_DEPS  := $(shell find mlkem -name '*.jinc' 2>/dev/null) $(KECCAK_DEPS)

.PHONY: all mldsa mlkem clean
all:   $(TARGETS)
mldsa: $(MLDSA_S)
mlkem: $(MLKEM_S)

# ---- pattern rules: one per scheme, parametric in the set/param ----------
# ML-DSA needs the shared Common namespace; ML-KEM only needs Keccak.
$(BUILD)/mldsa%_$(TARGET).s: $(MLDSA)/%/mldsa.jazz $(MLDSA_DEPS) | $(BUILD)
	env JASMINPATH="Common=$(MLDSA_COMMON):Keccak=$(KECCAK)" \
	    $(JASMINC) -arch=$(ARCH) $(JFLAGS) -o $@ $<

$(BUILD)/mlkem%_$(TARGET).s: $(MLKEM)/%/jmlkem.jazz $(MLKEM_DEPS) | $(BUILD)
	env JASMINPATH="Keccak=$(KECCAK)" \
	    $(JASMINC) -arch=$(ARCH) $(JFLAGS) -o $@ $<

$(BUILD):
	mkdir -p $@

# ==========================================================================
#  The committed assembly: ../asm holds the .s of every entry point for
#  x86-64 Linux (ELF, System V calling convention), whatever the host, as
#  ../asm/<prim>/<target>/<prim><set>_<target>_<profile>.s. It is extracted
#  from the sources as the EasyCrypt models are (proofs/Makefile):
#
#    make extract-asm    # regenerate ../asm (always runs jasminc)
#    make asm-unchanged  # fail if a file under ../asm differs from git's
#    make check-asm      # both
# ==========================================================================

ASM       := ../asm
ASM_FLAGS := -system linux -call-conv linux

.PHONY: extract-asm asm-unchanged check-asm

extract-asm:
	mkdir -p $(ASM)/mldsa/$(TARGET) $(ASM)/mlkem/$(TARGET)
	for s in $(MLDSA_SETS); do \
	  env JASMINPATH="Common=$(MLDSA_COMMON):Keccak=$(KECCAK)" \
	    $(JASMINC) -arch=$(ARCH) $(ASM_FLAGS) \
	    -o $(ASM)/mldsa/$(TARGET)/mldsa$${s}_$(TARGET)_$(PROFILE).s \
	    $(MLDSA)/$$s/mldsa.jazz || exit 1; \
	done
	for p in $(MLKEM_PARAMS); do \
	  env JASMINPATH="Keccak=$(KECCAK)" \
	    $(JASMINC) -arch=$(ARCH) $(ASM_FLAGS) \
	    -o $(ASM)/mlkem/$(TARGET)/mlkem$${p}_$(TARGET)_$(PROFILE).s \
	    $(MLKEM)/$$p/jmlkem.jazz || exit 1; \
	done

asm-unchanged:
	@if [ -n "$$(git status --porcelain -- $(ASM))" ]; then \
	  echo "the committed assembly is not the extraction of the sources:"; \
	  git status --short -- $(ASM); \
	  exit 1; \
	fi
	@echo "extracted assembly up to date"

check-asm: extract-asm
	@$(MAKE) --no-print-directory asm-unchanged

# ==========================================================================
#  Constant-time (CT) and speculative-constant-time (SCT) checking.
#
#  `jasmin-ct` type-checks the source directly -- no assembly is produced and
#  no AVX2 host is needed, so these run anywhere (including Apple Silicon).
#  Namespaces are passed with -I, the jasmin-ct spelling of JASMINPATH.
#  Both checks run with --doit: secret values (for SCT, transient ones too)
#  only reach instructions of Intel's data operand independent timing list.
#
#  Per-entry-point goals let you check one thing while another is being
#  worked on:
#    make ct                 # every entry point
#    make ct-mlkem768        # just that one
#    make sct-mldsa65
#
#  STATUS: ML-KEM and ML-DSA pass both CT and SCT (with --doit); CI gates on
#  all of them.
# ==========================================================================

MLDSA_INC := -I Common=$(MLDSA_COMMON) -I Keccak=$(KECCAK)
MLKEM_INC := -I Keccak=$(KECCAK)

CT_MLDSA  := $(addprefix ct-mldsa,$(MLDSA_SETS))
CT_MLKEM  := $(addprefix ct-mlkem,$(MLKEM_PARAMS))
SCT_MLDSA := $(addprefix sct-mldsa,$(MLDSA_SETS))
SCT_MLKEM := $(addprefix sct-mlkem,$(MLKEM_PARAMS))

.PHONY: ct sct ct-mlkem sct-mlkem ct-mldsa sct-mldsa \
        $(CT_MLDSA) $(CT_MLKEM) $(SCT_MLDSA) $(SCT_MLKEM)

ct:  $(CT_MLKEM)  $(CT_MLDSA)
sct: $(SCT_MLKEM) $(SCT_MLDSA)

# Per-scheme aggregates.
ct-mlkem:  $(CT_MLKEM)
sct-mlkem: $(SCT_MLKEM)
ct-mldsa:  $(CT_MLDSA)
sct-mldsa: $(SCT_MLDSA)

# Static pattern rules over the .PHONY goal names. A plain `ct-mldsa%:`
# pattern rule would NOT be phony (pattern rules ignore .PHONY), so make
# would see no file to build and report "nothing to be done" -- a silent
# false pass. Static patterns keep the goals phony and always run.
$(CT_MLDSA):  ct-mldsa%:  $(MLDSA)/%/mldsa.jazz
	$(JASMINCT) --doit --arch=$(ARCH) $(JCTFLAGS) $(MLDSA_INC) $<

$(SCT_MLDSA): sct-mldsa%: $(MLDSA)/%/mldsa.jazz
	$(JASMINCT) --sct --doit --arch=$(ARCH) $(JCTFLAGS) $(MLDSA_INC) $<

$(CT_MLKEM):  ct-mlkem%:  $(MLKEM)/%/jmlkem.jazz
	$(JASMINCT) --doit --arch=$(ARCH) $(JCTFLAGS) $(MLKEM_INC) $<

$(SCT_MLKEM): sct-mlkem%: $(MLKEM)/%/jmlkem.jazz
	$(JASMINCT) --sct --doit --arch=$(ARCH) $(JCTFLAGS) $(MLKEM_INC) $<

clean:
	rm -rf $(BUILD)
