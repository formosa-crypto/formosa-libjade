#!/usr/bin/env python3
"""Give the commits of a push to main the results of their PR runs.

A push to main runs the proofs and the benchmarks for its last commit only.
When a stack of PRs is merged, the push brings one commit per PR; the PR
runs already measured each of them, on the PR's head. A merged commit with
the same tree as its PR's head is the same code, so its PR records are
copied into main's history:

    data/pr/<n>/proofs/<head>.json         -> data/proofs/<commit>.json
    data/pr/<n>/bench/<runner>/<head>.json -> data/bench/<runner>/<commit>.json

The copy is for the merged commit (meta.commit, commit_date, subject,
branch, and parent: a merged stack's commits share their commit date, the
dashboard orders them by parent) and records where it comes from
(meta.from_pr: the PR, its head and run). A merged commit whose tree
differs from its PR's head, or that has no PR record, gets nothing; an
existing main record is never replaced.

Usage:  publish-merged-records.py [--dry-run] BEFORE AFTER RESULTS_DIR

BEFORE..AFTER is the push (github.event.before, github.sha), AFTER itself
excluded: its own runs publish it. RESULTS_DIR is a clone of the results
repo; the copies are written there, the caller commits and pushes them.
Talks to the GitHub API through `gh api` (GH_TOKEN, GITHUB_REPOSITORY).
"""

import argparse
import json
import os
import re
import subprocess
import sys
import time
from pathlib import Path


def api(path, tries=4):
    """GET an API path, retrying transient failures."""
    for i in range(tries):
        out = subprocess.run(["gh", "api", path], capture_output=True, text=True)
        if out.returncode == 0:
            return json.loads(out.stdout)
        time.sleep(2 ** i)
    sys.exit(f"gh api {path}: {out.stderr.strip()}")


def tree(repo, sha):
    return api(f"repos/{repo}/git/commits/{sha}")["tree"]["sha"]


def merged_pr(repo, sha):
    """The PR merged into main as this commit (rebase, squash or merge)."""
    for pr in api(f"repos/{repo}/commits/{sha}/pulls"):
        if pr.get("merged_at") and pr.get("merge_commit_sha") == sha:
            return pr
    return None


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--dry-run", action="store_true")
    ap.add_argument("before")
    ap.add_argument("after")
    ap.add_argument("results", type=Path)
    a = ap.parse_args()
    repo = os.environ["GITHUB_REPOSITORY"]
    if re.fullmatch(r"0+", a.before):
        print("new branch: no earlier commit to compare with")
        return
    pushed = api(f"repos/{repo}/compare/{a.before}...{a.after}")["commits"]
    copied = 0
    for c in pushed:
        sha = c["sha"]
        if sha == a.after:
            continue
        pr = merged_pr(repo, sha)
        if pr is None:
            print(f"{sha[:8]}: no merged PR")
            continue
        n, head = pr["number"], pr["head"]["sha"]
        if tree(repo, sha) != tree(repo, head):
            print(f"{sha[:8]}: #{n} head {head[:8]} has another tree")
            continue
        pdir = a.results / "data" / "pr" / str(n)
        pairs = [(pdir / "proofs" / f"{head}.json", a.results / "data" / "proofs" / f"{sha}.json")]
        pairs += [(f, a.results / "data" / "bench" / f.parent.name / f"{sha}.json")
                  for f in sorted(pdir.glob(f"bench/*/{head}.json"))]
        for src, dst in pairs:
            what = dst.parent.relative_to(a.results)
            if not src.exists():
                kind = src.parent.relative_to(pdir)
                print(f"{sha[:8]}: #{n} has no {kind} record for {head[:8]}")
                continue
            if dst.exists():
                print(f"{sha[:8]}: {what} already recorded")
                continue
            d = json.loads(src.read_text())
            meta = d["meta"]
            run_id = meta.get("run_id")
            meta.pop("pr", None)
            meta.update({
                "commit": sha,
                "commit_date": c["commit"]["committer"]["date"],
                "parent": c["parents"][0]["sha"],
                "subject": c["commit"]["message"].splitlines()[0],
                "branch": "main",
                "from_pr": {"number": n, "commit": head, "run_id": run_id},
            })
            print(f"{sha[:8]}: {what} from #{n} ({head[:8]})")
            copied += 1
            if not a.dry_run:
                dst.parent.mkdir(parents=True, exist_ok=True)
                dst.write_text(json.dumps(d, indent=1) + "\n")
    print(f"{copied} record(s) {'to copy' if a.dry_run else 'copied'}")


if __name__ == "__main__":
    sys.exit(main())
