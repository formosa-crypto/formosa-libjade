# -*- Makefile -*-
# Run the EasyCrypt proof test-suites defined in tests.config.

# --------------------------------------------------------------------
EASYCRYPT ?= easycrypt
JOBS      ?=
ECFLAGS   ?=
ECRUNTEST ?= $(EASYCRYPT) runtest $(if $(JOBS),-jobs $(JOBS),) $(ECFLAGS)

CONFIG    := tests.config
SCENARIOS := core fips202 mldsa mlkem mlkem-avx2-generic mlkem-avx2-512 mlkem-avx2-768 mlkem-avx2-1024 mlkem-safety mldsa-safety

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
clean:
	find . -name '*.eco' -print0 | xargs -0 rm -f
