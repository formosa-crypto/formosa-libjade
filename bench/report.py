#!/usr/bin/env python3
"""Render the bench CSV as a Markdown report (tables + Mermaid bar charts).

Input is the CSV from `make bench-all` (columns rep,scheme,backend,operation,
median_cycles; one row per pass and measurement, rep optional), read from a
file argument or stdin. Each (scheme, backend, operation) is reported as the
median of its per-pass medians, with their spread. Output is Markdown on
stdout or to --out, with one Mermaid bar chart per (scheme, operation), axis
anchored at 0; --json also writes the aggregated results with the run
metadata (GitHub Actions environment, --version and --meta values).

    make bench-all | python3 report.py -o bench.md
    python3 report.py bench.csv --exclude pqcrystals-ref -o bench.md --json bench.json

--exclude (repeatable) drops a backend from the tables and charts.
--require keeps only schemes that include the named backend (default jasmin,
since a comparison without the implementation under study is uninteresting);
pass --require '' to report every scheme.
"""

import argparse
import csv
import json
import os
import statistics
import subprocess
import sys
from collections import defaultdict
from datetime import datetime, timezone

# display order; anything else falls after these, alphabetically
BACKEND_ORDER = ["jasmin", "mlkem-native", "mldsa-native", "pqcrystals",
                 "pqcrystals-ref"]
# operation order per kind, keyed by a signature operation present in the data
OPS = {"keypair": ["keypair", "encaps", "decaps"],   # KEM
       "keygen": ["keygen", "sign", "verify"]}       # SIG


def load(stream):
    """-> {scheme: {backend: {op: [cycles per pass]}}}, preserving scheme
    encounter order."""
    data = defaultdict(lambda: defaultdict(lambda: defaultdict(list)))
    order = []
    for row in csv.DictReader(stream):
        s, b, op = row["scheme"], row["backend"], row["operation"]
        if s not in data:
            order.append(s)
        data[s][b][op].append(int(row["median_cycles"]))
    return data, order


def stats(samples):
    """Median of the per-pass medians and their spread."""
    xs = sorted(samples)
    st = {"n": len(xs), "median": round(statistics.median(xs)),
          "min": xs[0], "max": xs[-1]}
    if len(xs) > 1:
        q = statistics.quantiles(xs, n=4, method="inclusive")
        st["p25"], st["p75"] = round(q[0]), round(q[2])
    else:
        st["p25"] = st["p75"] = xs[0]
    st["samples"] = list(samples)
    return st


def median(samples):
    return round(statistics.median(samples)) if samples else 0


def backends_of(scheme_data, exclude):
    bs = [b for b in scheme_data if b not in exclude]
    return sorted(bs, key=lambda b: (BACKEND_ORDER.index(b)
                                     if b in BACKEND_ORDER else len(BACKEND_ORDER),
                                     b))


def ops_of(scheme_data):
    present = {op for ops in scheme_data.values() for op in ops}
    for key, seq in OPS.items():
        if key in present:
            return seq
    return sorted(present)


def cell(samples):
    """Median cycles, with the half-range of the passes when there are several."""
    if not samples:
        return "0"
    m = median(samples)
    if len(samples) < 2 or not m:
        return f"{m:,}"
    return f"{m:,} ±{(max(samples) - min(samples)) / 2 / m:.1%}"


def table(scheme_data, backends, ops):
    out = ["| backend | " + " | ".join(ops) + " |",
           "|" + "---|" + "--:|" * len(ops)]
    for b in backends:
        cells = [cell(scheme_data[b].get(op, [])) for op in ops]
        out.append(f"| {b} | " + " | ".join(cells) + " |")
    return "\n".join(out)


def chart(scheme, op, scheme_data, backends):
    vals = [median(scheme_data[b].get(op, [])) for b in backends]
    xs = ", ".join(f'"{b}"' for b in backends)
    ys = ", ".join(str(v) for v in vals)
    # anchor the axis at 0 so bars are proportional; mermaid otherwise scales to
    # [min, max] and exaggerates small differences
    top = int(max(vals) * 1.1) if vals else 1
    return (f"```mermaid\nxychart-beta\n"
            f'    title "{scheme} {op} — median cycles"\n'
            f"    x-axis [{xs}]\n"
            f'    y-axis "cycles" 0 --> {top}\n'
            f"    bar [{ys}]\n```")


def versions_table(versions):
    """versions: list of (component, value); rendered as a Markdown table."""
    out = ["## Environment", "", "| component | version |", "|---|---|"]
    out += [f"| {name} | {val} |" for name, val in versions]
    return "\n".join(out)


def render(data, order, exclude, require, versions):
    md = ["# Benchmark report", "",
          "Median CPU cycles (rdtsc) per operation, one process per backend, "
          "fresh derandomized inputs at each iteration, the same sequence "
          "across backends. With several passes, "
          "each cell is the median of the per-pass medians, ± half their range.",
          ""]
    if versions:
        md += [versions_table(versions), ""]
    for scheme in order:
        sd = data[scheme]
        backends = backends_of(sd, exclude)
        if require and require not in backends:
            continue
        ops = ops_of(sd)
        md += [f"## {scheme}", "", table(sd, backends, ops), ""]
        for op in ops:
            md += [chart(scheme, op, sd, backends), ""]
    return "\n".join(md)


def main(argv=None):
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("csv", nargs="?", type=argparse.FileType("r"),
                    default=sys.stdin, help="bench CSV (default: stdin)")
    ap.add_argument("-o", "--out", type=argparse.FileType("w"), default=sys.stdout)
    ap.add_argument("--exclude", action="append", default=[],
                    help="backend to drop from tables and charts (repeatable)")
    ap.add_argument("--require", default="jasmin",
                    help="keep only schemes with this backend ('' for all)")
    ap.add_argument("--version", action="append", default=[], dest="versions",
                    metavar="NAME=VALUE",
                    help="component version for the Versions table (repeatable)")
    ap.add_argument("--meta", action="append", default=[], metavar="KEY=VALUE",
                    help="extra run metadata for --json (repeatable)")
    ap.add_argument("--json", metavar="FILE",
                    help="also write the aggregated results and run metadata")
    args = ap.parse_args(argv)

    data, order = load(args.csv)
    if not order:
        sys.exit("no data on input")
    versions = [tuple(v.split("=", 1)) for v in args.versions if "=" in v]
    args.out.write(
        render(data, order, set(args.exclude), args.require, versions) + "\n")
    if args.json:
        extra = dict(m.split("=", 1) for m in args.meta if "=" in m)
        with open(args.json, "w") as f:
            json.dump(to_json(data, order, versions, extra), f, indent=1)
            f.write("\n")


def git(*argv):
    try:
        r = subprocess.run(["git", *argv], capture_output=True, text=True)
    except OSError:
        return None
    return (r.stdout.strip() or None) if r.returncode == 0 else None


def to_json(data, order, versions, extra):
    """Every measurement (no --exclude/--require filtering) with its
    statistics, and the run metadata."""
    # the commit actually checked out: on labelled PRs (pull_request_target)
    # GITHUB_SHA is the base branch, not the benchmarked head
    commit = git("rev-parse", "HEAD") or os.environ.get("GITHUB_SHA")
    meta = {
        "repo": os.environ.get("GITHUB_REPOSITORY"),
        "branch": os.environ.get("GITHUB_REF_NAME"),
        "commit": commit,
        "commit_date": git("show", "-s", "--format=%cI", commit) if commit else None,
        "subject": git("show", "-s", "--format=%s", commit) if commit else None,
        "run_id": int(os.environ["GITHUB_RUN_ID"])
                  if os.environ.get("GITHUB_RUN_ID") else None,
        "date": datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
    }
    meta.update({k: int(v) if v.isdigit() else v for k, v in extra.items()})
    meta["env"] = dict(versions)
    meta = {k: v for k, v in meta.items() if v not in (None, "", {})}
    results = [{"scheme": s, "backend": b, "operation": op, **stats(xs)}
               for s in order for b, ops in data[s].items()
               for op, xs in ops.items()]
    return {"meta": meta, "results": results}


if __name__ == "__main__":
    main()
