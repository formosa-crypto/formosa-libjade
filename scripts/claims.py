#!/usr/bin/env python3
"""The claims of the meta.toml files of src/ and proofs/, with the lemma
that supports each proved one, as JSON on stdout.

Usage:  claims.py

  proofs/<prim>/spec/meta.toml
      the specification of an algorithm: its standard, parameter sets and
      operations, and the security theorem of the specification: the
      generic theorem, and its instance for each parameter set it covers:
      the theorem restated for the set, in a file that clones the theory of
      the generic theorem
  src/<prim>/<target>/<profile>/<set>/meta.toml
      an implementation: the properties it claims and its provable security
      (provsec, "functional": correctness and the instance of the security
      theorem of the specification for the set). The CI runs a check (kat,
      memcheck, ct, sct) on the implementations that claim it
      (scripts/checks.py); a proved property (safety, correctness) needs the
      file below.
  src/<prim>/meta.toml
      an implementation of every parameter set at once, with its target, its
      profile and the name of its scheme in bench/: the C API of FIPS 202
      (JKCP). Its parameter_set is "all"; it claims checks only (no proved
      property, no provsec yet).
  proofs/<prim>/<target>/<profile>/<property>/<set>/meta.toml
      the lemma of each operation for a proved property, stated in that
      directory (the statement of the parameter set, not a generic one)

Each lemma is located by its declaration (lemma, equiv, hoare, ...), which
must occur exactly once in its file (and an instance's file must clone the
theory of the generic theorem exactly once), and the file must be checked by
the proofs CI: in a scenario of proofs/tests.config
that proofs/Makefile runs. Every entry point of src/ (a directory
<prim>/<target>/<profile>/<set> with a .jazz file) needs its meta.toml.
Exits non-zero, listing them on stderr, on claims without evidence.
"""

import configparser
import json
import re
import sys
import tomllib
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
PROOFS = REPO / "proofs"

CI_PROPS = ["kat", "memcheck", "ct", "sct"]
PROOF_PROPS = ["safety", "correctness"]
PROVSEC_KINDS = ["functional", "reduction", "leakage-aware"]
DECL = r"\s*(?:lemma|equiv|hoare|phoare|ehoare|theorem)\s+{}(?![\w'])"
# the one implementation of each parameter set that src/Makefile and
# bench/Makefile build
BUILT = ("avx2", "sct")


class Error(Exception):
    pass


def load(path):
    with open(path, "rb") as f:
        return tomllib.load(f)


def rel(path):
    return path.resolve().relative_to(REPO).as_posix()


def checked_dirs():
    """the directories of proofs/ that the proofs CI checks, as (path,
    recursive): the okdirs of the tests.config scenarios that the default
    target of proofs/Makefile runs"""
    m = re.search(r"^SCENARIOS\s*:=(.*)$", (PROOFS / "Makefile").read_text(), re.M)
    config = configparser.ConfigParser()
    config.read(PROOFS / "tests.config")
    dirs = []
    for name in m.group(1).split() if m else []:
        for d in config.get(f"test-{name}", "okdirs", fallback="").split():
            dirs.append((PROOFS / d.lstrip("!"), d.startswith("!")))
    return dirs


def checked(path, dirs):
    return any(path.parent == d or (rec and d in path.parents) for d, rec in dirs)


def located(base, ref, dirs, pattern, what):
    """(path, line) of the single line of the file ref["file"] (relative to
    the directory base) that matches pattern"""
    path = base / ref["file"]
    if not path.is_file():
        raise Error(f"{rel(base)}: no file {ref['file']}")
    if not checked(path, dirs):
        raise Error(f"{rel(path)}: in no scenario of the proofs CI (proofs/tests.config)")
    lines = [i for i, l in enumerate(path.read_text().splitlines(), 1) if pattern.match(l)]
    if len(lines) != 1:
        raise Error(f"{rel(path)}: {len(lines)} {what}")
    return path, lines[0]


def lemma(base, ref, dirs):
    """{file, lemma, line} of the lemma ref = {file, lemma}"""
    decl = re.compile(DECL.format(re.escape(ref["lemma"])))
    path, line = located(base, ref, dirs, decl, f"declarations of {ref['lemma']}")
    return {"file": rel(path), "lemma": ref["lemma"], "line": line}


def instance(base, ref, theorem, dirs):
    """{file, lemma, line} of the instance ref = {file, lemma} of the generic
    theorem: a lemma of a file that clones a theory of the theorem's file
    (the lemma restates the theorem for the set; EasyCrypt checks the proof)"""
    theory = re.escape(Path(theorem["file"]).stem)
    clone = re.compile(rf"\s*clone\s+(?:(?:import|export)\s+)*{theory}\.[\w.]+\s+as\s")
    located(base, ref, dirs, clone, f"clones of {theory}")
    return lemma(base, ref, dirs)


def spec(meta, dirs, errors):
    s = load(meta)
    out = {"primitive": s["primitive"], "standard": s["standard"],
           "spec": rel(meta.parent / s["spec"]), "operations": s["operations"],
           "parameter_sets": s["parameter_sets"]}
    if not (meta.parent / s["spec"]).is_file():
        errors.append(f"{rel(meta)}: no file {s['spec']}")
    sec = s.get("spec_security")
    if sec:
        insts = sec.get("instances", {})
        out["security"] = {k: sec[k] for k in ("notion", "leakage", "assumptions") if k in sec}
        out["security"]["parameter_sets"] = [p for p in s["parameter_sets"] if p in insts]
        for p in insts:
            if p not in s["parameter_sets"]:
                errors.append(f"{rel(meta)}: an instance for {p}, no such parameter set")
        if dirs is not None:
            try:
                theorem = lemma(meta.parent, sec["theorem"], dirs)
                out["security"]["theorem"] = theorem
                out["security"]["instances"] = {}
                for p in out["security"]["parameter_sets"]:
                    try:
                        out["security"]["instances"][p] = instance(meta.parent, insts[p],
                                                                   theorem, dirs)
                    except Error as e:
                        errors.append(str(e))
            except Error as e:
                errors.append(str(e))
    return out


def evidence(sp, impl, dirs, errors):
    """the lemma of each operation for each proved property of impl"""
    claims = impl["claims"]
    for p in PROOF_PROPS:
        if p not in claims:
            continue
        pmeta = (PROOFS / impl["prim"] / impl["target"] / impl["profile"] / p
                 / impl["parameter_set"] / "meta.toml")
        if not pmeta.is_file():
            errors.append(f"{impl['meta']}: claims {p}, no {rel(pmeta)}")
            continue
        ev = load(pmeta)
        impl["proofs"][p] = {}
        for op in sp["operations"]:
            if op not in ev:
                errors.append(f"{rel(pmeta)}: no lemma for {op}")
                continue
            if (pmeta.parent / ev[op]["file"]).resolve().parent != pmeta.parent.resolve():
                errors.append(f"{rel(pmeta)}: the lemma for {op} is not in {rel(pmeta.parent)} "
                              "(state it there for the parameter set)")
                continue
            try:
                impl["proofs"][p][op] = lemma(pmeta.parent, ev[op], dirs)
            except Error as e:
                errors.append(str(e))
    kind = impl.pop("provsec_kind")
    if kind is not None:
        sec = sp.get("security")
        if kind not in PROVSEC_KINDS:
            errors.append(f"{impl['meta']}: unknown provsec {kind}")
        elif kind != "functional":
            errors.append(f"{impl['meta']}: provsec {kind}: no such proof yet")
        elif "correctness" not in claims:
            errors.append(f"{impl['meta']}: provsec {kind} without correctness")
        elif not sec or impl["parameter_set"] not in sec["parameter_sets"]:
            errors.append(f"{impl['meta']}: provsec {kind}, spec security does not cover "
                          f"{impl['parameter_set']}")
        else:
            impl["provsec"] = {"kind": kind,
                               "theorem": sec.get("instances", {}).get(impl["parameter_set"])}


def implementation(sp, prim, meta, impls, errors):
    """the implementation that meta states, of the specification sp: of one
    parameter set (src/<prim>/<target>/<profile>/<set>/meta.toml) or of every
    one (src/<prim>/meta.toml, which gives its target, its profile and its
    scheme in bench/)"""
    m = load(meta)
    whole = meta.parent == REPO / "src" / prim
    if whole:
        target, profile, param = m.get("target"), m.get("profile"), "all"
        name, scheme = prim, m.get("scheme")
    else:
        target, profile, param = meta.parents[2].name, meta.parents[1].name, meta.parent.name
        name, scheme = f"{prim}{param}", f"{sp['primitive']}-{param}"
    impl = {"primitive": sp["primitive"], "prim": prim, "parameter_set": param,
            "name": name, "scheme": scheme, "target": target, "profile": profile,
            "meta": rel(meta), "claims": m.get("claims", []), "proofs": {},
            "provsec": None, "provsec_kind": m.get("provsec")}
    if whole:
        impl["parameter_sets"] = sp["parameter_sets"]
        if not scheme:
            errors.append(f"{impl['meta']}: no scheme")
        if impl["provsec_kind"] is not None:
            errors.append(f"{impl['meta']}: provsec, not supported yet for an implementation "
                          "of every parameter set")
    elif param not in sp["parameter_sets"]:
        errors.append(f"{impl['meta']}: {param} is no parameter set of {sp['primitive']}")
    for c in impl["claims"]:
        if c not in CI_PROPS + PROOF_PROPS:
            errors.append(f"{impl['meta']}: unknown claim {c}")
        elif whole and c in PROOF_PROPS:
            errors.append(f"{impl['meta']}: claims {c}, not supported yet for an "
                          "implementation of every parameter set")
    if (target, profile) != BUILT:
        errors.append(f"{impl['meta']}: the build has {'/'.join(BUILT)} only")
    if any(i["name"] == name for i in impls):
        errors.append(f"{impl['meta']}: a second implementation named {name}; the build "
                      "has one of each")
    return impl


def collect(errors, proofs=True):
    """the specifications and the implementations, with the evidence of the
    proved claims when proofs is set"""
    dirs = checked_dirs() if proofs else None
    specs, impls = [], []
    for meta in sorted(PROOFS.glob("*/spec/meta.toml")):
        prim = meta.parent.parent.name
        sp = spec(meta, dirs, errors)
        specs.append(sp)
        for d in sorted((REPO / "src" / prim).glob("*/*/*")):
            if (d.is_dir() and d.name != "common" and any(d.glob("*.jazz"))
                    and not (d / "meta.toml").is_file()):
                errors.append(f"{rel(d)}: an entry point without meta.toml")
        whole = REPO / "src" / prim / "meta.toml"
        for imeta in ([whole] if whole.is_file() else []) + sorted(
                (REPO / "src" / prim).glob("*/*/*/meta.toml")):
            impl = implementation(sp, prim, imeta, impls, errors)
            if proofs and imeta != whole:
                evidence(sp, impl, dirs, errors)
            else:
                impl.pop("provsec_kind")
            impls.append(impl)
    return specs, impls


def plan(check):
    """the implementations that claim the CI check; Error when the claims
    are inconsistent"""
    errors = []
    _, impls = collect(errors, proofs=False)
    if errors:
        raise Error("\n".join(dict.fromkeys(errors)))
    return [i for i in impls if check in i["claims"]]


def main():
    errors = []
    specs, impls = collect(errors)
    for i in impls:
        del i["prim"], i["meta"]
    json.dump({"specifications": specs, "implementations": impls}, sys.stdout, indent=1)
    print()
    errors = list(dict.fromkeys(errors))
    for e in errors:
        print(f"claims: {e}", file=sys.stderr)
    if errors:
        sys.exit(1)
    print(f"claims: {len(impls)} implementations, every claim with its evidence",
          file=sys.stderr)


if __name__ == "__main__":
    main()
