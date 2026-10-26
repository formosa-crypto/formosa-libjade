# -*- Makefile -*-
# Run the EasyCrypt proof test-suites defined in tests.config.

# --------------------------------------------------------------------
EASYCRYPT ?= easycrypt
JOBS      ?=
ECFLAGS   ?=
ECRUNTEST ?= $(EASYCRYPT) runtest $(if $(JOBS),-jobs $(JOBS),) $(ECFLAGS)

CONFIG    := tests.config
SCENARIOS := core fips202 mldsa mlkem mlkem-avx2-generic mlkem-avx2-512 mlkem-avx2-768 mlkem-avx2-1024 mlkem-safety mldsa-safety

# The safety proofs of fips202/safety need the EasyCrypt library (eclib) of
# Jasmin's safety-assert2 branch (JSafety.ec, and its additions to Jcheck,
# JMemory, JByte_array and JWord), which the 2026.03.1 release does not ship.
# JASMIN_SAFETY_ECLIB is the directory of that eclib (the nix dev shell sets
# it; with opam, the lib/easycrypt/jasmin directory of a switch with that
# Jasmin, e.g. ~/.opam/jasmin-safety/lib/easycrypt/jasmin). It is put first in
# the load path through EC_IDIRS, so that every `Jasmin` theory of these runs
# comes from it (an easycrypt.project `idirs` cannot override the installed
# eclib). These scenarios are not part of `check`: run `check-safety`.
JASMIN_SAFETY_ECLIB ?=
SAFETY_SCENARIOS    := fips202-safety

# --------------------------------------------------------------------
.PHONY: default check all check-safety $(SCENARIOS) $(SAFETY_SCENARIOS) clean

default: check

# `check`/`all` run every scenario in a single runtest invocation; each
# scenario is also a target on its own (e.g. `make core`, `make mlkem-avx2-768`).
check all:
	$(ECRUNTEST) $(CONFIG) $(SCENARIOS)

$(SCENARIOS):
	$(ECRUNTEST) $(CONFIG) $@

check-safety: $(SAFETY_SCENARIOS)

$(SAFETY_SCENARIOS):
	@test -n "$(JASMIN_SAFETY_ECLIB)" || { \
	  echo "$@: set JASMIN_SAFETY_ECLIB to the eclib of Jasmin's safety-assert2 branch" >&2; exit 1; }
	@test -f "$(JASMIN_SAFETY_ECLIB)/JSafety.ec" || { \
	  echo "$@: $(JASMIN_SAFETY_ECLIB) has no JSafety.ec (not a safety-assert2 eclib)" >&2; exit 1; }
	EC_IDIRS="Jasmin:$(JASMIN_SAFETY_ECLIB)$${EC_IDIRS:+;$$EC_IDIRS}" $(ECRUNTEST) $(CONFIG) $@

# --------------------------------------------------------------------
clean:
	find . -name '*.eco' -print0 | xargs -0 rm -f
