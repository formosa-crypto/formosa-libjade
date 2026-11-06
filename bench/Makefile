# Multi-backend KAT + benchmark harness.
#
# Each backend builds to _build/<backend>_<scheme>.so exposing the common
# derand ABI (adapters/common_abi.h). Backends are x86-64 + AVX2: on Apple
# Silicon they cross-build but only run on an x86-64 + AVX2 host.

CC      ?= cc
PYTHON  ?= python3
BUILD   ?= _build

UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Darwin)
  XARCH ?= -arch x86_64
else
  XARCH ?=
endif

ADAPTERS := adapters
SRC_BUILD := ../src/_build
MLKN := third_party/mlkem-native/mlkem
MLDN := third_party/mldsa-native/mldsa
KREF := third_party/kyber/ref
DREF := third_party/dilithium/ref
KAVX := third_party/kyber/avx2
DAVX := third_party/dilithium/avx2

# ---- backend library sets (<backend>_<scheme>.so) ------------------------
# jasmin: only the parameter sets present in src/, discovered from
# src/mlkem/avx2/sct/<set>/jmlkem.jazz and src/mldsa/avx2/sct/<set>/mldsa.jazz.
JASMIN_KEM := $(patsubst ../src/mlkem/avx2/sct/%/jmlkem.jazz,$(BUILD)/jasmin_mlkem%.so,\
                $(wildcard ../src/mlkem/avx2/sct/*/jmlkem.jazz))
JASMIN_SIG := $(patsubst ../src/mldsa/avx2/sct/%/mldsa.jazz,$(BUILD)/jasmin_mldsa%.so,\
                $(wildcard ../src/mldsa/avx2/sct/*/mldsa.jazz))
# native reference libraries: all parameter sets.
MLKN_KEM   := $(BUILD)/mlkem-native_mlkem512.so \
              $(BUILD)/mlkem-native_mlkem768.so \
              $(BUILD)/mlkem-native_mlkem1024.so
MLDN_SIG   := $(BUILD)/mldsa-native_mldsa44.so \
              $(BUILD)/mldsa-native_mldsa65.so \
              $(BUILD)/mldsa-native_mldsa87.so
# pq-crystals, all parameter sets: `pqcrystals` from the avx2 tree,
# `pqcrystals-ref` from the portable-C ref tree.
PQC_KEM    := $(BUILD)/pqcrystals_mlkem512.so \
              $(BUILD)/pqcrystals_mlkem768.so \
              $(BUILD)/pqcrystals_mlkem1024.so
PQC_SIG    := $(BUILD)/pqcrystals_mldsa44.so \
              $(BUILD)/pqcrystals_mldsa65.so \
              $(BUILD)/pqcrystals_mldsa87.so
PQCR_KEM   := $(BUILD)/pqcrystals-ref_mlkem512.so \
              $(BUILD)/pqcrystals-ref_mlkem768.so \
              $(BUILD)/pqcrystals-ref_mlkem1024.so
PQCR_SIG   := $(BUILD)/pqcrystals-ref_mldsa44.so \
              $(BUILD)/pqcrystals-ref_mldsa65.so \
              $(BUILD)/pqcrystals-ref_mldsa87.so

# the libraries of each backend (BACKENDS names them)
LIBS_jasmin         := $(JASMIN_KEM) $(JASMIN_SIG)
LIBS_mlkem-native   := $(MLKN_KEM)
LIBS_mldsa-native   := $(MLDN_SIG)
LIBS_pqcrystals     := $(PQC_KEM) $(PQC_SIG)
LIBS_pqcrystals-ref := $(PQCR_KEM) $(PQCR_SIG)

LIBS := $(foreach b,jasmin mlkem-native mldsa-native pqcrystals pqcrystals-ref,$(LIBS_$(b)))

.PHONY: libs clean
libs: $(LIBS)

$(BUILD):
	mkdir -p $@

# ---- jasmin backend: shim + the Jasmin-generated .s ----------------------
$(SRC_BUILD)/mlkem%_avx2.s:
	$(MAKE) -C ../src _build/mlkem$*_avx2.s

$(BUILD)/jasmin_mlkem%.so: $(ADAPTERS)/jasmin/kem_shim.c $(SRC_BUILD)/mlkem%_avx2.s | $(BUILD)
	$(CC) $(XARCH) -O2 -fPIC -shared -I$(ADAPTERS) \
	    -DJASMIN_KEM_NS=jade_kem_mlkem_mlkem$*_amd64_avx2 -o $@ $^

$(SRC_BUILD)/mldsa%_avx2.s:
	$(MAKE) -C ../src _build/mldsa$*_avx2.s

$(BUILD)/jasmin_mldsa%.so: $(ADAPTERS)/jasmin/sig_shim.c $(SRC_BUILD)/mldsa%_avx2.s | $(BUILD)
	$(CC) $(XARCH) -O2 -fPIC -shared -I$(ADAPTERS) \
	    -DJASMIN_SIG_NS=ml_dsa_$* -o $@ $^

# ---- mlkem-native backend: shim + monolithic source + asm, AVX2 backend --
# mlkem_native_asm.S bundles the x86_64 backend assembly; NO_RANDOMIZED_API
# drops the non-derand keypair/enc (and their randombytes dependency).
MLKN_FLAGS := -mavx2 -mbmi2 \
              -DMLK_CONFIG_USE_NATIVE_BACKEND_ARITH \
              -DMLK_CONFIG_USE_NATIVE_BACKEND_FIPS202 \
              -DMLK_CONFIG_NO_RANDOMIZED_API
MLKN_SRC := $(ADAPTERS)/mlkem-native/kem_shim.c \
            $(MLKN)/mlkem_native.c $(MLKN)/mlkem_native_asm.S

$(BUILD)/mlkem-native_mlkem%.so: $(MLKN_SRC) | $(BUILD)
	$(CC) $(XARCH) -O3 -fomit-frame-pointer -fPIC -shared \
	    $(MLKN_FLAGS) -DMLK_CONFIG_PARAMETER_SET=$* \
	    -DMLK_CONFIG_NAMESPACE_PREFIX=mlkn$*_ \
	    -I$(MLKN) -I$(ADAPTERS) -o $@ $(MLKN_SRC)

# ---- mldsa-native backend: shim + monolithic source + asm, AVX2 backend --
MLDN_FLAGS := -mavx2 -mbmi2 \
              -DMLD_CONFIG_USE_NATIVE_BACKEND_ARITH \
              -DMLD_CONFIG_USE_NATIVE_BACKEND_FIPS202 \
              -DMLD_CONFIG_NO_RANDOMIZED_API
MLDN_SRC := $(ADAPTERS)/mldsa-native/sig_shim.c \
            $(MLDN)/mldsa_native.c $(MLDN)/mldsa_native_asm.S

$(BUILD)/mldsa-native_mldsa%.so: $(MLDN_SRC) | $(BUILD)
	$(CC) $(XARCH) -O3 -fomit-frame-pointer -fPIC -shared \
	    $(MLDN_FLAGS) -DMLD_CONFIG_PARAMETER_SET=$* \
	    -DMLD_CONFIG_NAMESPACE_PREFIX=mldn$*_ \
	    -I$(MLDN) -I$(ADAPTERS) -o $@ $(MLDN_SRC)

# ---- pq-crystals backends -------------------------------------------------
# Kyber exposes the derand supercop API directly. Dilithium has no derand
# keypair, so sig_shim.c supplies its own randombytes (the tree's is excluded)
# to feed keygen the seed; signing uses the *_internal entry points. The shims
# include "kem.h"/"sign.h", so the same source builds against both the ref and
# avx2 trees.
SHK := adapters/pqcrystals/kem_shim.c
SHS := adapters/pqcrystals/sig_shim.c

# avx2 source lists (hand-written .S + keccak4x; see upstream Makefiles)
KAVX_SRC := $(addprefix $(KAVX)/,kem.c indcpa.c polyvec.c poly.c fq.S shuffle.S \
            ntt.S invntt.S basemul.S consts.c rejsample.c cbd.c verify.c \
            fips202.c fips202x4.c symmetric-shake.c randombytes.c \
            keccak4x/KeccakP-1600-times4-SIMD256.c)
DAVX_SRC := $(addprefix $(DAVX)/,sign.c packing.c polyvec.c poly.c ntt.S invntt.S \
            pointwise.S shuffle.S consts.c rejsample.c rounding.c fips202.c \
            fips202x4.c f1600x4.S symmetric-shake.c)
# portable C source lists (no asm)
KREF_SRC := $(wildcard $(KREF)/*.c)
DREF_SRC := $(filter-out %/randombytes.c,$(wildcard $(DREF)/*.c))

AVX2FLAGS := -mavx2 -mbmi2 -Wl,-z,noexecstack

# scheme -> KYBER_K / DILITHIUM_MODE (shared by both variants)
$(BUILD)/pqcrystals_mlkem512.so $(BUILD)/pqcrystals-ref_mlkem512.so:   KYBER_K := 2
$(BUILD)/pqcrystals_mlkem768.so $(BUILD)/pqcrystals-ref_mlkem768.so:   KYBER_K := 3
$(BUILD)/pqcrystals_mlkem1024.so $(BUILD)/pqcrystals-ref_mlkem1024.so: KYBER_K := 4
$(BUILD)/pqcrystals_mldsa44.so $(BUILD)/pqcrystals-ref_mldsa44.so: DILITHIUM_MODE := 2
$(BUILD)/pqcrystals_mldsa65.so $(BUILD)/pqcrystals-ref_mldsa65.so: DILITHIUM_MODE := 3
$(BUILD)/pqcrystals_mldsa87.so $(BUILD)/pqcrystals-ref_mldsa87.so: DILITHIUM_MODE := 5

# avx2 variant (the `pqcrystals` backend)
$(PQC_KEM): $(BUILD)/pqcrystals_mlkem%.so: $(SHK) $(KAVX_SRC) | $(BUILD)
	$(CC) $(XARCH) -O3 -fomit-frame-pointer $(AVX2FLAGS) -fPIC -shared \
	    -DKYBER_K=$(KYBER_K) -I$(KAVX) -Iadapters -o $@ $(SHK) $(KAVX_SRC)
$(PQC_SIG): $(BUILD)/pqcrystals_mldsa%.so: $(SHS) $(DAVX_SRC) | $(BUILD)
	$(CC) $(XARCH) -O3 -fomit-frame-pointer $(AVX2FLAGS) -fPIC -shared \
	    -DDILITHIUM_MODE=$(DILITHIUM_MODE) -I$(DAVX) -Iadapters -o $@ $(SHS) $(DAVX_SRC)

# portable-C variant (the `pqcrystals-ref` backend)
$(PQCR_KEM): $(BUILD)/pqcrystals-ref_mlkem%.so: $(SHK) $(KREF_SRC) | $(BUILD)
	$(CC) $(XARCH) -O3 -fomit-frame-pointer -fPIC -shared \
	    -DKYBER_K=$(KYBER_K) -I$(KREF) -Iadapters -o $@ $(SHK) $(KREF_SRC)
$(PQCR_SIG): $(BUILD)/pqcrystals-ref_mldsa%.so: $(SHS) $(DREF_SRC) | $(BUILD)
	$(CC) $(XARCH) -O3 -fomit-frame-pointer -fPIC -shared \
	    -DDILITHIUM_MODE=$(DILITHIUM_MODE) -I$(DREF) -Iadapters -o $@ $(SHS) $(DREF_SRC)

# ---- drivers (x86-64 + AVX2 host only) -----------------------------------
DLLIB := $(if $(filter Darwin,$(UNAME_S)),,-ldl)

$(BUILD)/bench: bench.c | $(BUILD)
	$(CC) $(XARCH) -O2 -o $@ bench.c $(DLLIB)

comma := ,
empty :=
space := $(empty) $(empty)

VECTORS  ?= $(wildcard vectors/*.json)
BACKENDS ?= jasmin mlkem-native
SCHEME   ?= ML-KEM-768
N        ?= 100
SCHEME_BASE = $(shell echo $(SCHEME) | tr -d '-' | tr 'A-Z' 'a-z')
ALL_SCHEMES ?= ML-KEM-512 ML-KEM-768 ML-KEM-1024 ML-DSA-44 ML-DSA-65 ML-DSA-87

REPORT  ?= bench.md
# machine-readable report (aggregated results + run metadata) next to REPORT
REPORT_JSON ?= bench.json
# bench-all passes over every (scheme, backend); each pass runs them all in
# turn, so slow drift (temperature, frequency) hits every backend alike, and
# the report gives the spread of the per-pass medians
REPS    ?= 5
# extra run metadata for the JSON report, as KEY=VALUE words (e.g. runner=...)
META    ?=
# backend(s) excluded from the report; override with EXCLUDE= to include all
EXCLUDE ?= pqcrystals-ref
# report only schemes containing this backend; REQUIRE= reports every scheme
REQUIRE ?= jasmin

# Pin the bench to one core: avoids scheduler migration, and on hybrid CPUs
# (Intel P/E, ARM big.LITTLE) keeps every backend on the same core type. Default
# is the highest-max-MHz core (a P-core on hybrid parts); override with CPU=<id>
# or disable with CPU=. Pinning fixes migration, not frequency scaling -- for
# stable cycles also set the performance governor and disable turbo (needs root).
CPU ?= $(shell lscpu -e=CPU,MAXMHZ 2>/dev/null | awk 'NR>1 && $$2+0>=m {m=$$2+0; c=$$1} END{print c}')
PIN := $(if $(and $(CPU),$(shell command -v taskset)),taskset -c $(CPU) ,)

.PHONY: bench-bin test memcheck compare bench bench-all report
bench-bin: $(BUILD)/bench

# KAT: run each backend over the vector files
test: $(foreach b,$(BACKENDS),$(LIBS_$(b)))
	@for b in $(BACKENDS); do echo "== $$b =="; $(PYTHON) kat.py --backend $$b $(VECTORS) || exit $$?; done

# memory safety of the jasmin libraries under Valgrind's memcheck
# (memcheck.c: exact-size heap buffers, initialised outputs); VALGRIND=
# runs the driver alone
VALGRIND ?= valgrind --error-exitcode=1 --track-origins=yes --leak-check=no -q

$(BUILD)/memcheck: memcheck.c FORCE | $(BUILD)
	$(CC) $(XARCH) -O1 -g $(if $(VALGRIND),-DWITH_VALGRIND) -o $@ memcheck.c $(DLLIB)

.PHONY: FORCE
FORCE:

memcheck: $(LIBS_jasmin) $(BUILD)/memcheck
	@for s in $(ALL_SCHEMES); do \
	   sb=$$(echo $$s | tr -d '-' | tr 'A-Z' 'a-z'); \
	   $(VALGRIND) $(BUILD)/memcheck $$s $(BUILD)/jasmin_$$sb.so || exit 1; \
	 done

# differential agreement across backends for one scheme
compare: libs
	$(PYTHON) compare.py --scheme $(SCHEME) --backends $(subst $(space),$(comma),$(BACKENDS)) -n $(N)

# cycle benchmark for one scheme: one process per built backend library
bench: libs $(BUILD)/bench
	@echo "$(SCHEME) (median cycles over $${BENCH_ITERS:-10000} iters$(if $(PIN), on cpu $(CPU))):"
	@for so in $(BUILD)/*_$(SCHEME_BASE).so; do $(PIN)$(BUILD)/bench $(SCHEME) $$so; done

# machine-readable (CSV) benchmark over every scheme x its built backends,
# one process per (scheme, backend), REPS interleaved passes
bench-all: libs $(BUILD)/bench
	@echo "rep,scheme,backend,operation,median_cycles"
	@for r in $$(seq 1 $(REPS)); do \
	   for s in $(ALL_SCHEMES); do \
	     sb=$$(echo $$s | tr -d '-' | tr 'A-Z' 'a-z'); \
	     for so in $(BUILD)/*_$$sb.so; do \
	       out=$$(BENCH_FORMAT=csv $(PIN)$(BUILD)/bench $$s $$so) || exit $$?; \
	       printf '%s\n' "$$out" | sed "s/^/$$r,/"; \
	     done; \
	   done; \
	done

# render a fresh bench-all into a Markdown report (tables + Mermaid charts)
# and its JSON counterpart (REPORT_JSON).
# Versions are read from the pinned submodule revisions and the jasmin compiler.
gitver = $$(git -C $(1) describe --tags --always --dirty 2>/dev/null || echo '?')
report: libs $(BUILD)/bench
	@$(MAKE) --no-print-directory -s bench-all > $(BUILD)/bench.csv
	@$(PYTHON) report.py $(if $(EXCLUDE),$(addprefix --exclude ,$(EXCLUDE))) \
	        --require '$(REQUIRE)' \
	        --version "CPU=$$(grep -m1 'model name' /proc/cpuinfo | cut -d: -f2- | sed 's/^ *//')" \
	        --version "pinned core=$(if $(PIN),$(CPU),none)" \
	        --version "freq governor=$$(cat /sys/devices/system/cpu/cpu$(if $(PIN),$(CPU),0)/cpufreq/scaling_governor 2>/dev/null || echo unknown)" \
	        --version "jasminc=$$(jasminc -version 2>/dev/null | head -1)" \
	        --version "mlkem-native=$(call gitver,$(MLKN)/..)" \
	        --version "mldsa-native=$(call gitver,$(MLDN)/..)" \
	        --version "pq-crystals/kyber=$(call gitver,$(KREF)/..)" \
	        --version "pq-crystals/dilithium=$(call gitver,$(DREF)/..)" \
	        --meta "reps=$(REPS)" --meta "iters=$${BENCH_ITERS:-10000}" \
	        $(addprefix --meta ,$(META)) \
	        --json $(REPORT_JSON) -o $(REPORT) $(BUILD)/bench.csv
	@echo "wrote $(REPORT) $(REPORT_JSON)"

clean:
	rm -rf $(BUILD)
