#!/usr/bin/env python3
"""
check_isa.py — instruction-set checks over every Jasmin program of the
repository that exports functions (src/**/*.jazz: the ML-KEM and ML-DSA entry
points, the Keccak test programs).

  vex   compile each program (jasminc) and report every SIMD instruction that
        is not VEX-encoded: an instruction with an %xmm/%ymm operand whose
        mnemonic does not start with `v` (e.g. the legacy `movq` that MOVV and
        the (64u)/(32u) truncations of an xmm register compile to). MMX moves
        (Jasmin's #mmx spill registers) have no VEX form and do not touch the
        SSE/AVX state: they are not reported.

  doit  check that only DOIT instructions (Intel's Data Operand Independent
        Timing list, as classified by Jasmin) touch secret data: the security
        signatures that `jasmin-ct --infer` gives to the exported functions
        must not change under `--doit`. A non-DOIT instruction applied to data
        derived from an argument forces that argument to be public, which
        changes the signature.
        The classification comes from the instruction descriptors of Jasmin,
        as in the pinned release 2026.09.0 (jasmin-lang/jasmin#1520). Builds
        before 2026.03.2 also flag ROL/ROR/RORX/BSWAP (jasmin-lang/jasmin#1458),
        so every Keccak permutation fails with them. Such builds are detected
        (a probe using ROL) and the check stops without a verdict. jasmin-ct
        reports only the first error of a program: a rejected program may have
        more violations.

Usage:
    python3 scripts/check_isa.py vex  [--jasminc JASMINC]
    python3 scripts/check_isa.py doit [--jasmin-ct JASMINCT]
    python3 scripts/check_isa.py all  [--jasminc JASMINC] [--jasmin-ct JASMINCT]

Exit status: 0 when every check passes, 1 on a violation, 2 when a check
could not run (compilation error, jasmin-ct with ROL outside the DOIT list).
"""
import argparse
import os
import re
import subprocess
import sys
import tempfile

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
JPATH = ["-I", "Keccak=" + os.path.join(REPO, "src/fips202"),
         "-I", "Common=" + os.path.join(REPO, "src/mldsa/avx2/sct/common")]
ROOTS = ("src",)

SIMD_OPERAND = re.compile(r"%[xy]mm\d+\b")
CT_SIG = re.compile(r'#\[ct = "(.*?)"\]\s*fn\s+([\w:]+)', re.S)

DOIT_PROBE = """export fn doit_probe(reg u64 x) -> reg u64 {
  reg u64 y;
  _, _, y = #ROL_64(x, 1);
  return y;
}
"""


def programs():
    """The .jazz files of the repository that export functions."""
    out = []
    for root in ROOTS:
        for d, _, files in os.walk(os.path.join(REPO, root)):
            for f in files:
                p = os.path.join(d, f)
                if f.endswith(".jazz") and re.search(r"(?m)^\s*export\s+fn\b", open(p).read()):
                    out.append(p)
    return sorted(out)


def rel(p):
    return os.path.relpath(p, REPO)


def run(cmd):
    return subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)


def check_vex(jasminc):
    status = 0
    with tempfile.TemporaryDirectory() as tmp:
        for p in programs():
            asm = os.path.join(tmp, "out.s")
            r = run([jasminc, "-arch", "x86-64", *JPATH, "-o", asm, p])
            if r.returncode != 0:
                print(f"ERROR {rel(p)}: jasminc failed\n{r.stdout}")
                status = max(status, 2)
                continue
            bad = {}
            for line in open(asm):
                parts = line.split(None, 1)
                if (line[:1].isspace() and len(parts) == 2 and not parts[0].startswith("v")
                        and SIMD_OPERAND.search(parts[1])):
                    bad.setdefault(parts[0], []).append(line.strip())
            if bad:
                status = max(status, 1)
                print(f"FAIL  {rel(p)}: non-VEX SIMD instructions")
                for mnem, lines in sorted(bad.items()):
                    print(f"        {len(lines):3} x {mnem:10} e.g. {lines[0]}")
            else:
                print(f"ok    {rel(p)}")
    return status


def signatures(jasmin_ct, path, doit):
    r = run([jasmin_ct, *(["--doit"] if doit else []), "--infer", *JPATH, path])
    if r.returncode != 0:
        return None, r.stdout
    return {fn: " ".join(sig.split()) for sig, fn in CT_SIG.findall(r.stdout)}, r.stdout


def check_doit(jasmin_ct):
    with tempfile.TemporaryDirectory() as tmp:
        probe = os.path.join(tmp, "doit_probe.jazz")
        open(probe, "w").write(DOIT_PROBE)
        plain, out1 = signatures(jasmin_ct, probe, False)
        doit, out2 = signatures(jasmin_ct, probe, True)
        if plain is None or doit is None:
            print(f"ERROR jasmin-ct failed on the DOIT probe\n{out1 or out2}")
            return 2
        if plain != doit:
            print(f"ERROR {jasmin_ct} treats ROL as non-DOIT: it predates the DOIT\n"
                  "      classification of Jasmin 2026.03.2, the check needs the pinned Jasmin 2026.09.0")
            return 2
    status = 0
    for p in programs():
        plain, out = signatures(jasmin_ct, p, False)
        if plain is None:
            print(f"ERROR {rel(p)}: jasmin-ct failed\n{out}")
            status = max(status, 2)
            continue
        doit, out = signatures(jasmin_ct, p, True)
        if doit is None:
            # inference succeeds without --doit only: the error locates the culprit
            status = max(status, 1)
            err = [l for l in out.splitlines() if l.startswith('"') or "type checker" in l]
            print(f"FAIL  {rel(p)}: rejected by jasmin-ct --doit")
            for l in err:
                print(f"        {l}")
            continue
        changed = [(fn, plain[fn], doit.get(fn)) for fn in plain if doit.get(fn) != plain[fn]]
        if changed:
            status = max(status, 1)
            print(f"FAIL  {rel(p)}: non-DOIT instructions on secret-dependent data")
            for fn, s1, s2 in changed:
                print(f"        {fn}: {s1}  ==>  {s2}")
        else:
            print(f"ok    {rel(p)}")
    return status


def main():
    ap = argparse.ArgumentParser(description=__doc__.split("\n\n")[0])
    ap.add_argument("check", choices=("vex", "doit", "all"))
    ap.add_argument("--jasminc", default=os.environ.get("JASMINC", "jasminc"))
    ap.add_argument("--jasmin-ct", default=os.environ.get("JASMINCT", "jasmin-ct"))
    a = ap.parse_args()
    status = 0
    if a.check in ("vex", "all"):
        print("== VEX encoding (" + a.jasminc + ")")
        status = max(status, check_vex(a.jasminc))
    if a.check in ("doit", "all"):
        print("== DOIT instructions on secrets (" + a.jasmin_ct + ")")
        status = max(status, check_doit(a.jasmin_ct))
    sys.exit(status)


if __name__ == "__main__":
    main()
