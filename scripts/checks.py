#!/usr/bin/env python3
"""The checks of the checks workflow, and their record: one JSON record per
commit.

  checks.py ct|extraction|kat-memcheck OUT
      run the checks of that job, made of the same `make` targets as a local
      run, and append one result per check and target to OUT (JSON lines).
      Every check runs; fails if one of them fails.
  checks.py merge OUT FRAGMENT...
      write the record of the commit checked out: its meta (commit, run,
      tools, the conclusion of each job, from the JOBS environment variable:
      the workflow's `toJSON(needs)`; the end of the log of each job that
      failed, from <JOB_LOGS>/<job>.log when JOB_LOGS names a directory),
      the results and the data of every fragment

The checks kat, memcheck, ct and sct run on the implementations that claim
them in their src/**/meta.toml (scripts/claims.py); the known-answer tests
of an implementation are bench/vectors/<prim><set>[-*].json, and a vector
file that no implementation runs fails the kat check.

A result is {"check", "target", "ok", "seconds"}, with the line of the
output that states the result as "summary" when there is one, and the last
lines of the output as "tail" when the check fails. The record has the
shape publish-result expects ("meta" with the full commit hash, "results").
"""

import datetime
import importlib.util
import json
import os
import re
import subprocess
import sys
import time
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent

# the lines that state a check's result: the totals of kat.py, the verdict
# of memcheck.c, the last words of the extraction checks and of claims.py
SUMMARY = re.compile(r"\d+ passed, \d+ failed|: (ok|FAILED)$|up to date$|with its evidence$")


def claims():
    spec = importlib.util.spec_from_file_location("claims", REPO / "scripts" / "claims.py")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def append(out, entry):
    with open(out, "a") as f:
        f.write(json.dumps(entry) + "\n")


def result(out, check, target, rc, lines, seconds):
    shown = [l for l in lines if l.strip()]
    entry = {"check": check, "target": target, "ok": rc == 0, "seconds": round(seconds, 1)}
    summary = [l for l in shown if SUMMARY.search(l)]
    if summary:
        entry["summary"] = summary[-1].strip()
    if rc != 0:
        entry["tail"] = shown[-20:]
    append(out, {"result": entry})
    return rc


def run(out, check, target, cmd, data=False):
    """run cmd, print its output and record its result; with data, cmd
    prints a JSON value on stdout (and its messages on stderr), which goes
    into the record's data under check"""
    print(f"== {check} {target}", flush=True)
    start = time.monotonic()
    p = subprocess.Popen(cmd, cwd=REPO, stdout=subprocess.PIPE,
                         stderr=subprocess.PIPE if data else subprocess.STDOUT,
                         text=True, errors="replace")
    if data:
        value, messages = p.communicate()
        output = messages.splitlines(keepends=True)
    else:
        output = p.stdout
    lines = []
    for line in output:
        sys.stdout.write(line)
        sys.stdout.flush()
        lines.append(line.rstrip("\n"))
        del lines[:-40]
    rc = p.wait()
    if data:
        try:
            append(out, {"data": {check: json.loads(value)}})
        except ValueError as e:
            lines.append(f"{check}: not a JSON value ({e})")
            rc = rc or 1
    return result(out, check, target, rc, lines, time.monotonic() - start)


def fail(out, check, target, message):
    print(f"== {check} {target}\n{message}", flush=True)
    return result(out, check, target, 1, message.splitlines(), 0)


def tool(out, name, cmd):
    """record the first line printed by cmd as the version of the tool name"""
    try:
        r = subprocess.run(cmd, capture_output=True, text=True, errors="replace")
        lines = (r.stdout + r.stderr).splitlines()
        version = lines[0].strip() if lines else ""
    except OSError as e:
        version = f"unavailable ({e.strerror})"
    print(f"{name}: {version}")
    append(out, {"tool": {name: version}})


def plan(out, check):
    """the implementations that claim check, or None after recording the
    inconsistency of the claims as a failed check"""
    c = claims()
    try:
        return c.plan(check)
    except c.Error as e:
        fail(out, check, "claims", str(e))
        return None


def ct(out):
    tool(out, "jasmin", ["jasminc", "-version"])
    rc = 0
    for k in ("ct", "sct"):
        impls = plan(out, k)
        if impls is None:
            rc = 1
            continue
        for i in impls:
            rc |= run(out, k, i["name"], ["make", "-C", "src", f"{k}-{i['name']}"])
    return rc


def extraction(out):
    tool(out, "jasmin", ["jasminc", "-version"])
    tool(out, "jasmin2ec", ["jasmin2ec", "--version"])
    tool(out, "jasmin2ec-safety", ["jasmin2ec-safety", "--version"])
    rc = 0
    for k in ("correctness", "safety"):
        rc |= run(out, "extraction", k, ["make", "-C", "proofs", f"extract-{k}"])
    rc |= run(out, "extraction", "unchanged", ["make", "-C", "proofs", "extraction-unchanged"])
    rc |= run(out, "extraction", "assembly", ["make", "-C", "src", "extract-asm"])
    rc |= run(out, "extraction", "assembly-unchanged", ["make", "-C", "src", "asm-unchanged"])
    rc |= run(out, "claims", "meta", [sys.executable, "scripts/claims.py"], data=True)
    return rc


def kat_memcheck(out):
    tool(out, "jasmin", ["jasminc", "-version"])
    tool(out, "cc", ["cc", "--version"])
    tool(out, "valgrind", ["valgrind", "--version"])
    if run(out, "build", "assembly", ["make", "-C", "src"]):
        return 1
    rc = 0
    impls = plan(out, "kat")
    if impls is None:
        rc = 1
    else:
        unused = set((REPO / "bench" / "vectors").glob("*.json"))
        for i in impls:
            vectors = sorted(v for v in unused
                             if v.stem == i["name"] or v.stem.startswith(i["name"] + "-"))
            unused -= set(vectors)
            if not vectors:
                rc |= fail(out, "kat", i["name"], f"no bench/vectors/{i['name']}[-*].json")
            for v in vectors:
                rc |= run(out, "kat", v.stem, ["make", "-C", "bench", "test", "BACKENDS=jasmin",
                                               f"VECTORS=vectors/{v.name}"])
        for v in sorted(unused):
            rc |= fail(out, "kat", v.stem, f"bench/vectors/{v.name}: no implementation "
                                           "claims kat for it")
    impls = plan(out, "memcheck")
    if impls is None:
        return 1
    for i in impls:
        scheme = f"{i['primitive']}-{i['parameter_set']}"
        rc |= run(out, "memcheck", i["name"], ["make", "-C", "bench", "memcheck",
                                               f"ALL_SCHEMES={scheme}"])
    return rc


def git(*args):
    try:
        return subprocess.run(["git", *args], capture_output=True, text=True,
                              check=True).stdout.strip()
    except (OSError, subprocess.CalledProcessError):
        return None


def log_tail(text, n=30):
    """the last n lines of a job log up to its last error, without the
    timestamps GitHub puts in front of every line"""
    lines = [re.sub(r"^\d{4}-\d\d-\d\dT[\d:.]+Z ", "", l) for l in text.splitlines()]
    errors = [i for i, l in enumerate(lines) if "##[error]" in l]
    end = errors[-1] + 1 if errors else len(lines)
    return lines[max(0, end - n):end]


def merge(out, fragments):
    tools, results, data = {}, [], {}
    for path in fragments:
        for line in open(path):
            if line.strip():
                d = json.loads(line)
                tools.update(d.get("tool", {}))
                data.update(d.get("data", {}))
                if "result" in d:
                    results.append(d["result"])
    jobs = {name: v.get("result")
            for name, v in json.loads(os.environ.get("JOBS") or "{}").items()}
    logs = {}
    if os.environ.get("JOB_LOGS"):
        for job, conclusion in jobs.items():
            path = os.path.join(os.environ["JOB_LOGS"], f"{job}.log")
            if conclusion != "success" and os.path.exists(path):
                logs[job] = log_tail(open(path, errors="replace").read())
    commit = git("rev-parse", "HEAD") or os.environ.get("GITHUB_SHA")
    env = os.environ.get
    run_url = (f"{env('GITHUB_SERVER_URL')}/{env('GITHUB_REPOSITORY')}"
               f"/actions/runs/{env('GITHUB_RUN_ID')}") if env("GITHUB_RUN_ID") else None
    meta = {
        "repo": env("GITHUB_REPOSITORY"),
        "branch": env("GITHUB_REF_NAME"),
        "event": env("GITHUB_EVENT_NAME"),
        "commit": commit,
        "commit_date": git("show", "-s", "--format=%cI", "HEAD"),
        "subject": git("show", "-s", "--format=%s", "HEAD"),
        "run_id": int(env("GITHUB_RUN_ID")) if env("GITHUB_RUN_ID") else None,
        "run_url": run_url,
        "date": datetime.datetime.now(datetime.timezone.utc)
                .isoformat(timespec="seconds"),
        "tools": tools,
        "jobs": jobs,
        "job_logs": logs,
        "ok": all(r["ok"] for r in results)
              and all(v == "success" for v in jobs.values()),
    }
    results.sort(key=lambda r: (r["check"], r["target"]))
    json.dump({"meta": meta, "results": results, "data": data}, open(out, "w"), indent=1)
    failed = [f"{r['check']}/{r['target']}" for r in results if not r["ok"]]
    print(f"{out}: {len(results)} results, {len(failed)} failed"
          + (f" ({', '.join(failed)})" if failed else ""))
    return 0


JOBS = {"ct": ct, "extraction": extraction, "kat-memcheck": kat_memcheck}


def main():
    args = sys.argv[1:]
    if len(args) >= 2 and args[0] == "merge":
        return merge(args[1], args[2:])
    if len(args) != 2 or args[0] not in JOBS:
        sys.exit(__doc__)
    out = Path(args[1]).resolve()
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text("")
    return JOBS[args[0]](out)


if __name__ == "__main__":
    sys.exit(main())
