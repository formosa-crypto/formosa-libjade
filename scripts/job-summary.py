#!/usr/bin/env python3
"""The job summary of a proofs or bench job, from its record (Markdown on
stdout), for the jobs that run and for those that reuse an earlier run.

Usage:  job-summary.py proofs proofs-timing.json
        job-summary.py bench bench/bench.json RUNNER

Links to the results dashboard rather than tables: on a push to main
(PUBLISHED=true) the commit's results and its comparison with the previous
commit; on a PR (PR=<number>, bench) the comparison with its merge base.
"""

import json
import os
import sys

SITE = "https://formosa-crypto.github.io/formosa-libjade-results"
UPDATED = "on the results dashboard (updated a minute after this run)."


def gb(b):
    return f"{b / 1e9:.1f} GB"


def commit_links():
    sha = os.environ.get("GITHUB_SHA")
    return (f"**[results for this commit]({SITE}/#/results/{sha})** · "
            f"**[compare with the previous commit]({SITE}/#/compare/{sha})** {UPDATED}")


def proofs(m):
    print(f"Proof checking: **{m['total_seconds'] / 60:.1f} min** cumulative over "
          f"{m['files']} files ({m.get('machine', {}).get('jobs', '?')} jobs).")
    if m.get("memory"):
        print(f"Memory: peak **{gb(m['memory']['peak_total'])}** for the whole run, "
              f"largest file {gb(m.get('max_file_maxrss') or 0)}.")
    if os.environ.get("PUBLISHED") == "true":
        print(commit_links())
    else:
        print("If this commit is the head of a PR, its page on the "
              f"**[results dashboard]({SITE}/)** compares it with the merge base "
              "(published by publish-pr a minute after this run).")


def bench(m, runner):
    pr = os.environ.get("PR")
    if pr:
        msg = f"**[compare with the merge base]({SITE}/#/pr/{pr})** {UPDATED}"
    elif os.environ.get("PUBLISHED") == "true":
        msg = commit_links()
    else:
        msg = (f"not published (only main and PRs are); the full report is in the "
               f"`bench-{runner}` artifact.")
    print(f"Benchmarks on `{runner}`: {msg}")


def main():
    kind, path = sys.argv[1], sys.argv[2]
    m = json.load(open(path))["meta"]
    if kind == "proofs":
        proofs(m)
    else:
        bench(m, sys.argv[3])
    if m.get("reused"):
        r = m["reused"]
        print(f"\nResults of run {r['run_id']} ({r['commit'][:8]}), on the same tree.")


if __name__ == "__main__":
    main()
