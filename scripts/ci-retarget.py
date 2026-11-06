#!/usr/bin/env python3
"""Rewrite the record of an earlier run for another commit.

A commit whose tree an earlier run already checked (a rebase that changes no
file, a rebase merge) reuses that run's record, a proofs, checks or bench
JSON. The record then names this commit and this run; meta.reused keeps the
commit and the run that produced the results.

Usage:  ci-retarget.py FILE [COMMIT]

COMMIT (default HEAD) must be in the local repository.
"""

import json
import os
import subprocess
import sys


def git(*args):
    return subprocess.run(["git", *args], capture_output=True, text=True,
                          check=True).stdout.strip()


def main():
    path = sys.argv[1]
    commit = git("rev-parse", sys.argv[2] if len(sys.argv) > 2 else "HEAD")
    d = json.load(open(path))
    meta = d["meta"]
    env = os.environ.get
    # a record reused twice keeps the run that measured it
    meta.setdefault("reused", {"commit": meta.get("commit"), "run_id": meta.get("run_id")})
    run_id = int(env("GITHUB_RUN_ID")) if env("GITHUB_RUN_ID") else None
    meta.update({
        "branch": env("GITHUB_REF_NAME"),
        "commit": commit,
        "commit_date": git("show", "-s", "--format=%cI", commit),
        "subject": git("show", "-s", "--format=%s", commit),
        "run_id": run_id,
    })
    if "event" in meta:
        meta["event"] = env("GITHUB_EVENT_NAME")
    if "run_url" in meta and run_id is not None:
        meta["run_url"] = (f"{env('GITHUB_SERVER_URL')}/{env('GITHUB_REPOSITORY')}"
                           f"/actions/runs/{run_id}")
    json.dump(d, open(path, "w"), indent=1)
    print(f"{path}: results of {meta['reused']['commit'][:8]} "
          f"(run {meta['reused']['run_id']}) for {commit[:8]}")


if __name__ == "__main__":
    main()
