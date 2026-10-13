# Makefile -- assembly (.s) generation for the ML-KEM / ML-DSA entry points.
#
# Jasmin namespaces are resolved through JASMINPATH:
#   Common -> per-implementation shared code (ML-DSA only)
#   Keccak -> in-tree src/fips202 (flattened from formosa-keccak)

JASMINC  ?= jasminc
JASMINCT ?= jasmin-ct
ARCH     ?= x86-64
JFLAGS   ?=
JCTFLAGS ?=

CC      ?= cc
PYTHON  ?= python3

BUILD   ?= _build

# Jasmin emits OS-specific assembly: the .s produced here matches the host
# (Mach-O on macOS, ELF on Linux). The x86-64 AVX2 code therefore runs on an
# x86-64 host of the SAME OS as the one that generated the .s. On an Apple
# Silicon Mac the code is cross-assembled/linked (clang -arch x86_64); it
# runs under Rosetta, which executes AVX2, from an x86-64 process (e.g. an
# x86-64 Python for the KAT driver: `arch -x86_64 <python> tests/kat.py ...`).
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Darwin)
  XARCH ?= -arch x86_64
else
  XARCH ?=
endif

KECCAK       := fips202
MLDSA_COMMON := mldsa/avx2/common

# ---- entry points -> output assembly -------------------------------------
# Discovered by wildcard, so a new parameter set is picked up as soon as its
# source directory appears:
#   ML-DSA: mldsa/avx2/<set>/mldsa.jazz   -> _build/mldsa<set>_avx2.s
#   ML-KEM: mlkem/avx2/<param>/jmlkem.jazz -> _build/mlkem<param>_avx2.s
MLDSA_S := $(patsubst mldsa/avx2/%/mldsa.jazz,$(BUILD)/mldsa%_avx2.s,\
             $(wildcard mldsa/avx2/*/mldsa.jazz))
MLKEM_S := $(patsubst mlkem/avx2/%/jmlkem.jazz,$(BUILD)/mlkem%_avx2.s,\
             $(wildcard mlkem/avx2/*/jmlkem.jazz))

TARGETS := $(MLDSA_S) $(MLKEM_S)

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
$(BUILD)/mldsa%_avx2.s: mldsa/avx2/%/mldsa.jazz $(MLDSA_DEPS) | $(BUILD)
	env JASMINPATH="Common=$(MLDSA_COMMON):Keccak=$(KECCAK)" \
	    $(JASMINC) -arch=$(ARCH) $(JFLAGS) -o $@ $<

$(BUILD)/mlkem%_avx2.s: mlkem/avx2/%/jmlkem.jazz $(MLKEM_DEPS) | $(BUILD)
	env JASMINPATH="Keccak=$(KECCAK)" \
	    $(JASMINC) -arch=$(ARCH) $(JFLAGS) -o $@ $<

$(BUILD):
	mkdir -p $@

# ==========================================================================
#  Constant-time (CT) and speculative-constant-time (SCT) checking.
#
#  `jasmin-ct` type-checks the source directly -- no assembly is produced and
#  no AVX2 host is needed, so these run anywhere (including Apple Silicon).
#  Namespaces are passed with -I, the jasmin-ct spelling of JASMINPATH.
#
#  Per-entry-point goals let you check one thing while another is being
#  worked on:
#    make ct                 # every entry point
#    make ct-mlkem768        # just that one
#    make sct-mldsa65
#
#  STATUS: ML-KEM and ML-DSA pass both CT and SCT; CI gates on all of them.
# ==========================================================================

MLDSA_INC := -I Common=$(MLDSA_COMMON) -I Keccak=$(KECCAK)
MLKEM_INC := -I Keccak=$(KECCAK)

# Entry point names, derived from the same wildcards as the .s targets.
MLDSA_SETS   := $(patsubst mldsa/avx2/%/mldsa.jazz,%,$(wildcard mldsa/avx2/*/mldsa.jazz))
MLKEM_PARAMS := $(patsubst mlkem/avx2/%/jmlkem.jazz,%,$(wildcard mlkem/avx2/*/jmlkem.jazz))

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
$(CT_MLDSA):  ct-mldsa%:  mldsa/avx2/%/mldsa.jazz
	$(JASMINCT) --arch=$(ARCH) $(JCTFLAGS) $(MLDSA_INC) $<

$(SCT_MLDSA): sct-mldsa%: mldsa/avx2/%/mldsa.jazz
	$(JASMINCT) --sct --arch=$(ARCH) $(JCTFLAGS) $(MLDSA_INC) $<

$(CT_MLKEM):  ct-mlkem%:  mlkem/avx2/%/jmlkem.jazz
	$(JASMINCT) --arch=$(ARCH) $(JCTFLAGS) $(MLKEM_INC) $<

$(SCT_MLKEM): sct-mlkem%: mlkem/avx2/%/jmlkem.jazz
	$(JASMINCT) --sct --arch=$(ARCH) $(JCTFLAGS) $(MLKEM_INC) $<

# ==========================================================================
#  Shared libraries (assemble + link). Buildable on Apple Silicon; only
#  loadable/runnable on an x86-64 + AVX2 host.
# ==========================================================================

# One shared library per discovered entry point.
LIBS := $(TARGETS:.s=.so)

.PHONY: libs
libs: $(LIBS)

# Every entry point exports a plain C ABI (see include/*.h); one rule turns
# each generated .s into a position-independent shared library.
$(BUILD)/%_avx2.so: $(BUILD)/%_avx2.s | $(BUILD)
	$(CC) $(XARCH) -fPIC -shared -o $@ $<

# ==========================================================================
#  Run the KATs through the single ctypes driver (x86-64 + AVX2 host only).
# ==========================================================================

VECTORS := $(wildcard tests/vectors/*.json)

.PHONY: test
test: libs
	@if [ -z "$(VECTORS)" ]; then \
	  echo "no KAT vectors in tests/vectors/ -- nothing to run"; \
	else \
	  $(PYTHON) tests/kat.py --lib-dir $(BUILD) $(VECTORS); \
	fi

clean:
	rm -rf $(BUILD)
