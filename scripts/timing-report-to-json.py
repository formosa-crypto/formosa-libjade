#!/usr/bin/env python3
"""Convert an `easycrypt runtest -report` YAML into the timing JSON.

The report has one node per scenario, each with per-file details:

    - name: mldsa
      details:
      - name: correctness65 (mldsa/x86-64/avx2/ml_dsa_65/correctness65.ec)
        time: '12.345'
        success: true
        ...

Output is the sunburst input format (see scripts/timing-sunburst.py):

    { "meta": {...}, "files": [{"path": ..., "seconds": ...}, ...] }

Run metadata is picked up from the GitHub Actions environment when
present (GITHUB_SHA, GITHUB_REF_NAME, GITHUB_RUN_ID, RUNNER_NAME); the
timestamp comes from the report itself. The meta also records what a
comparison between two runs needs to be meaningful: the commit date,
the machine (architecture, CPUs available, parallel jobs) and the
EasyCrypt and prover versions, probed from the tools on PATH.

Usage:  timing-report-to-json.py [--jobs N] report.yml [out.json]
Exits non-zero if the report contains failures (no timing JSON is
written from a broken run).
"""

import argparse
import json
import os
import platform
import re
import subprocess
import sys
from pathlib import Path

import yaml


def run(cmd):
    """First line of `cmd`'s output, or None if it cannot be run."""
    try:
        r = subprocess.run(cmd, capture_output=True, text=True, timeout=60)
    except (OSError, subprocess.SubprocessError):
        return None
    lines = (r.stdout or r.stderr).strip().splitlines()
    return lines[0].strip() if r.returncode == 0 and lines else None


def easycrypt_version():
    """EASYCRYPT_REV (set by the nix shell: a nix build embeds no git hash),
    else the git hash `easycrypt config` reports."""
    unknown = (None, "", "n/a", "unknown")
    rev = os.environ.get("EASYCRYPT_REV")
    if rev not in unknown:
        return rev
    try:
        r = subprocess.run(["easycrypt", "config"], capture_output=True,
                           text=True, timeout=60)
    except (OSError, subprocess.SubprocessError):
        return None
    m = re.search(r"^git-hash:\s*(\S+)", r.stdout + r.stderr, re.M)
    return m.group(1) if m and m.group(1) not in unknown else None


def cpus():
    try:
        return len(os.sched_getaffinity(0))
    except AttributeError:          # not on Linux
        return os.cpu_count()


def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("report", nargs="?", default="timing.yml")
    ap.add_argument("out", nargs="?", default="proofs-timing.json")
    ap.add_argument("--jobs", type=int, help="parallel jobs of the checked run")
    args = ap.parse_args()
    inp, out = Path(args.report), Path(args.out)

    report = yaml.safe_load(inp.read_text())

    files, seen, failures = [], set(), []
    for group in report:
        for d in group.get("details", []):
            m = re.search(r"\((.*)\)\s*$", d["name"])
            path = m.group(1) if m else d["name"]
            if not d.get("success", False):
                failures.append(path)
            if path in seen:
                continue
            seen.add(path)
            files.append({"path": path, "seconds": round(float(d["time"]), 1)})

    if failures:
        print(f"{inp}: {len(failures)} failed file(s), refusing to emit timing:",
              file=sys.stderr)
        for p in failures:
            print(f"  {p}", file=sys.stderr)
        sys.exit(1)

    files.sort(key=lambda f: f["path"])
    # the commit actually checked out (on pull requests GITHUB_SHA can differ)
    commit = run(["git", "rev-parse", "HEAD"]) or os.environ.get("GITHUB_SHA")
    meta = {
        "repo": os.environ.get("GITHUB_REPOSITORY"),
        "branch": os.environ.get("GITHUB_REF_NAME"),
        "commit": commit,
        "commit_date": run(["git", "show", "-s", "--format=%cI", commit])
                       if commit else None,
        "subject": run(["git", "show", "-s", "--format=%s", commit])
                   if commit else None,
        "run_id": int(os.environ["GITHUB_RUN_ID"])
                  if os.environ.get("GITHUB_RUN_ID") else None,
        "date": report[0].get("timestamp") if report else None,
        "machine": {
            "runner": os.environ.get("RUNNER_NAME"),
            "arch": platform.machine(),
            "cpus": cpus(),
            "jobs": args.jobs,
        },
        "tools": {
            "easycrypt": easycrypt_version(),
            "z3": run(["z3", "--version"]),
            "cvc5": run(["cvc5", "--version"]),
        },
        "files": len(files),
        "total_seconds": round(sum(f["seconds"] for f in files), 1),
    }
    for k in ("machine", "tools"):
        meta[k] = {kk: v for kk, v in meta[k].items() if v is not None}
    meta = {k: v for k, v in meta.items() if v not in (None, {})}

    out.write_text(json.dumps({"meta": meta, "files": files}, indent=1))
    print(f"{out}: {len(files)} files, {meta['total_seconds']/60:.1f} min total")


if __name__ == "__main__":
    main()
