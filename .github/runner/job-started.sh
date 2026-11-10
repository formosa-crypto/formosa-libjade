#!/usr/bin/env bash
# Runs before every job on this runner (ACTIONS_RUNNER_HOOK_JOB_STARTED, set in the
# Dockerfile). A non-zero exit fails the job before its first step, whatever the
# workflow, including a workflow that a pull request adds or edits.
#
# Accepted: pushes and manual runs (both need write access to the repository), pull
# requests whose branch is in this repository, and a fork's pull request at the moment a
# maintainer labels it "safe to test" (pull_request_target, whose workflows are the base
# branch's; see .github/workflows/safe-to-test.yml). Refused: every other job of a fork's
# pull request, in particular a workflow that the pull request adds (pull_request), and
# every other event.
set -euo pipefail

refuse() {
  echo "job refused on this self-hosted runner: $*" >&2
  exit 1
}

event="${GITHUB_EVENT_NAME:?}"
repo="${GITHUB_REPOSITORY:?}"

case "$event" in
  push | workflow_dispatch)
    ;;
  pull_request | pull_request_target)
    payload="${GITHUB_EVENT_PATH:?}"
    head=$(jq -r '.pull_request.head.repo.full_name // ""' "$payload")
    [ "$head" = "$repo" ] && exit 0
    [ "$event" = pull_request_target ] \
      && [ "$(jq -r '.action // ""' "$payload")" = labeled ] \
      && [ "$(jq -r '.label.name // ""' "$payload")" = "safe to test" ] \
      || refuse "pull request from ${head:-a deleted repository}; a fork's code runs only" \
                "in the pull_request_target run started by the label \"safe to test\""
    ;;
  *)
    refuse "event $event"
    ;;
esac
