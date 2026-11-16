#!/usr/bin/env python3
"""Write the validation files of the SHA-2 specification,
CAVP_*.ec in this directory, from the NIST CAVP vectors of bench/vectors,
and run their negative controls.

    spec_vectors.py write    VECTORS OUTDIR
    spec_vectors.py check    VECTORS OUTDIR
    spec_vectors.py controls VECTORS --easycrypt EC --flags FLAGS [--jobs N]

Each file states, for a fixed selection of vectors of one function, the
lemma that the specification's function applied to the message of the
vector, written as a byte-list literal, equals the digest that the vector
records. Every lemma is closed by `cbv delta` with the rewriting rules of
SpecEval.ec: EasyCrypt computes the function from its definition in spec/
and compares the result with the literal. No lemma uses SMT, and none is
admitted.

The selection, per function with input block size B (64 for SHA-256, 128
for SHA-512), from the ShortMsg vectors (the first of each length): the
messages of 0, 1, B - L - 1, B - L, B - 9, B - 8, B - 1 and B bytes, where
L is the size of the length field (8 bytes for SHA-256, 16 for SHA-512,
sections 5.1.1 and 5.1.2). B - L - 1 bytes is the longest message whose
padding fits in one block, B - L the shortest that needs a second one. For
SHA-256 that is B - 9 and B - 8; for SHA-512 it is 111 and 112, and 119 and
120 are kept as two-block cases. From the LongMsg vectors: the first one,
of several blocks (163 or 227 bytes).

write  writes the files to OUTDIR.
check  does the same into memory and fails unless every file in OUTDIR
       equals a fresh generation and OUTDIR holds no other CAVP_*.ec.
controls
       requires EasyCrypt to reject, for each function, its first lemma
       with bit 0 of the last digest byte flipped, and to reject it as a
       proof that does not close: a parse or type error, or a failure in
       another file, does not count. Each control runs in a scratch
       directory and is never written to the tree.

Regenerate: make -C proofs spec-vectors  (check: make -C proofs check-spec-vectors)
Exit status: 0 on success, 1 on a failed check or control, 2 on bad input.
"""

import argparse
import json
import os
import re
import shlex
import shutil
import subprocess
import sys
import tempfile
import textwrap
import time
from concurrent.futures import ThreadPoolExecutor

PREAMBLE = """\
require import AllCore List.
from Jasmin require import JWord.
require import Bytes FIPS180_SHA2 FIPS198_HMAC SpecEval.
"""

# File, function as the specification names it, theory prefix of the
# lemma names, vector file, block size.
HASHES = [
    ("CAVP_SHA256", "SHA-256", "SHA256.sha256", "sha256", "fips180sha256.json", 64),
    ("CAVP_SHA512", "SHA-512", "SHA512.sha512", "sha512", "fips180sha512.json", 128),
]


def die(msg, status=2):
    sys.stderr.write("spec_vectors.py: %s\n" % msg)
    sys.exit(status)


# --------------------------------------------------------------------
# Vectors

def read_vectors(vectors, name):
    """The (count, message, digest) of the hash vectors of a bench vector
    file, in file order: the ShortMsg vectors, then the LongMsg ones."""
    path = os.path.join(vectors, name)
    data = json.load(open(path))
    out = []
    for t in data["tests"]:
        if "hash" in t:
            out.append((t["count"], bytes.fromhex(t["hash"]["message"]),
                        bytes.fromhex(t["hash"]["digest"])))
    if not out:
        die("%s: no hash vectors" % path)
    return out


# --------------------------------------------------------------------
# EasyCrypt text

def literal(b, indent):
    if not b:
        return "map W8.of_int []"
    items = ["0x%02x" % x for x in b]
    lines = [" ".join(i + ";" for i in items[k:k + 12]) for k in range(0, len(items), 12)]
    lines[-1] = lines[-1][:-1]
    pad = " " * indent
    return "map W8.of_int [\n" + "\n".join(pad + "  " + l for l in lines) + "]"


def header(fname, what, source):
    title = fname + ".ec"
    intro = ("%s of the specification in spec/, evaluated by EasyCrypt on NIST "
             "CAVP vectors (bench/vectors/%s). Each lemma states that the "
             "function applied to the input of a vector equals the output the "
             "vector records, and is closed by reduction with the rules of "
             "SpecEval.ec, without SMT. The generator explains the selection of "
             "vectors." % (what, source))
    lines = textwrap.wrap(intro, 72)
    return ("(*\n"
            " * GENERATED FILE. DO NOT EDIT.\n"
            " *\n"
            " * %s\n * %s\n *\n" % (title, "=" * len(title))
            + "".join(" * %s\n" % l for l in lines)
            + " *\n"
            " * Generator: spec_vectors.py in this directory\n"
            " * Regenerate: make -C proofs spec-vectors   (check: make -C proofs check-spec-vectors)\n"
            " *)\n\n")


def hash_lemmas(vectors, op, prefix, source, block):
    recs = read_vectors(vectors, source)
    lenfield = 8 if block == 64 else 16
    want = sorted({0, 1, block - lenfield - 1, block - lenfield,
                   block - 9, block - 8, block - 1, block})
    by_len = {}
    for count, m, d in recs:
        if len(m) <= block:
            by_len.setdefault(len(m), (count, m, d))
    cases = []
    for n in want:
        if n not in by_len:
            die("%s has no message of %d bytes" % (source, n))
        count, m, d = by_len[n]
        cases.append(("%s_short_%d" % (prefix, n),
                      "%s, count %d (%s)" % (source, count, nbytes(n)), m, d))
    count, m, d = next(r for r in recs if len(r[1]) > block)
    cases.append(("%s_long_%d" % (prefix, len(m)),
                  "%s, count %d (%s)" % (source, count, nbytes(len(m))), m, d))
    return [(name, src, "  %s\n    (%s)\n  = %s" % (op, literal(m, 4), literal(d, 2)))
            for name, src, m, d in cases]


def nbytes(n):
    return "1 byte" if n == 1 else "%d bytes" % n


def lemma_text(name, src, stmt):
    return "(* %s *)\nlemma %s :\n%s.\nproof. by cbv delta. qed.\n" % (src, name, stmt)


def generate(vectors):
    files = {}
    for fname, what, op, prefix, source, block in HASHES:
        files[fname] = (what, source, hash_lemmas(vectors, op, prefix, source, block))
    return files


def render(fname, what, source, cases):
    body = "\n".join(lemma_text(*c) for c in cases)
    return header(fname, what, source) + PREAMBLE + "\n" + body


# --------------------------------------------------------------------
# Commands

def cmd_write(vectors, outdir):
    files = generate(vectors)
    os.makedirs(outdir, exist_ok=True)
    for fname, (what, source, cases) in files.items():
        with open(os.path.join(outdir, fname + ".ec"), "w") as f:
            f.write(render(fname, what, source, cases))
        print("spec-vectors: wrote %s.ec (%d lemmas)" % (fname, len(cases)))
    return 0


def cmd_check(vectors, outdir):
    files = generate(vectors)
    bad = 0
    present = sorted(f for f in os.listdir(outdir) if re.fullmatch(r"CAVP_.*\.ec", f))
    for f in present:
        if f[:-3] not in files:
            print("spec-vectors: %s is not a generated file" % os.path.join(outdir, f))
            bad += 1
    n = 0
    for fname, (what, source, cases) in files.items():
        path = os.path.join(outdir, fname + ".ec")
        n += len(cases)
        if not os.path.exists(path):
            print("spec-vectors: %s is missing" % path)
            bad += 1
        elif open(path).read() != render(fname, what, source, cases):
            print("spec-vectors: %s differs from a fresh generation" % path)
            bad += 1
    if bad:
        print("spec-vectors: FAIL (regenerate with make -C proofs spec-vectors)")
        return 1
    print("spec-vectors: PASS (%d files, %d lemmas)" % (len(files), n))
    return 0


def flip_last_bit(stmt):
    """The statement with bit 0 of the last byte of its right-hand side
    flipped."""
    m = re.search(r"0x([0-9a-f]{2})\]$", stmt)
    if not m:
        die("no output byte to flip in a statement")
    v = int(m.group(1), 16) ^ 1
    return stmt[: m.start()] + "0x%02x]" % v


def rejected(out, fname):
    crit = [l for l in out.replace("\r", "\n").splitlines() if "[critical]" in l]
    if not crit:
        return False
    pat = re.compile(r"^\[critical\] \[%s: line \d+ \([0-9-]+\)\] \[by\]: cannot close goals$"
                     % re.escape(fname))
    return all(pat.match(l.strip()) for l in crit)


def run_control(easycrypt, flags, fname, what, case):
    """(accepted, rejected as required, seconds, output) of the control
    of one file: its first lemma with one output bit flipped, compiled
    from a scratch directory."""
    name, src, stmt = case
    text = PREAMBLE + "\n" + lemma_text(name + "_flipped", src, flip_last_bit(stmt))
    tmp = tempfile.mkdtemp(prefix="spec-control-")
    try:
        path = os.path.join(tmp, "Control_" + fname[len("CAVP_"):] + ".ec")
        with open(path, "w") as f:
            f.write(text)
        start = time.monotonic()
        proc = subprocess.run([easycrypt, "compile", *flags, path],
                              stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
        seconds = time.monotonic() - start
        out = proc.stdout.decode("utf-8", errors="replace")
        return proc.returncode == 0, rejected(out, path), seconds, out
    finally:
        shutil.rmtree(tmp, ignore_errors=True)


def cmd_controls(vectors, easycrypt, flags, jobs):
    files = generate(vectors)
    flags = shlex.split(flags)
    work = [(fname, what, cases[0]) for fname, (what, source, cases) in files.items()]
    with ThreadPoolExecutor(max_workers=jobs) as pool:
        results = list(pool.map(lambda w: run_control(easycrypt, flags, *w), work))
    failed = 0
    for (fname, what, case), (accepted, ok, seconds, out) in zip(work, results):
        what = "control %s, %s with one bit flipped" % (what, case[0])
        if accepted:
            print("%s: FAIL (accepted)" % what)
            failed += 1
        elif not ok:
            print("%s: FAIL (rejected for another reason)" % what)
            print(out.rstrip())
            failed += 1
        else:
            print("%s: rejected %.1f s" % (what, seconds))
    if failed:
        print("spec-controls: FAIL %d of %d controls" % (failed, len(work)))
        return 1
    print("spec-controls: PASS %d controls rejected" % len(work))
    return 0


def main(argv):
    ap = argparse.ArgumentParser(prog="spec_vectors.py")
    ap.add_argument("command", choices=["write", "check", "controls"])
    ap.add_argument("vectors")
    ap.add_argument("outdir", nargs="?")
    ap.add_argument("--easycrypt")
    ap.add_argument("--flags")
    ap.add_argument("--jobs", type=int, default=1)
    a = ap.parse_args(argv[1:])
    if a.command in ("write", "check") and a.outdir is None:
        die("%s needs OUTDIR" % a.command)
    if a.command == "write":
        return cmd_write(a.vectors, a.outdir)
    if a.command == "check":
        return cmd_check(a.vectors, a.outdir)
    if a.easycrypt is None or a.flags is None or a.jobs < 1:
        die("controls needs --easycrypt, --flags and --jobs of at least 1")
    return cmd_controls(a.vectors, a.easycrypt, a.flags, a.jobs)


if __name__ == "__main__":
    sys.exit(main(sys.argv))
