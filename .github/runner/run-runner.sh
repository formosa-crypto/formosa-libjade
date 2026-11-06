#!/usr/bin/env bash
# Build the image and supervise a truly ephemeral runner instance: one fresh
# container per job. One supervisor per runner instance (bench-skylake on
# each bench machine, proofs on the proofs hosts, ...).
# Each iteration runs `docker run --rm`, and the in-container agent
# registers as `--ephemeral`, so it serves exactly one job and exits; the
# container is then removed and the loop starts a brand-new one. Nothing
# survives between jobs (fresh _work *and* fresh $HOME). This runs in the
# foreground and loops forever -- supervise it with the runner@.service
# template unit so it starts on boot and restarts if the loop itself dies.
#
# All configuration comes from the environment (the systemd units load it
# from ~/.config/<instance>/env). This is the ONLY place these variables are
# documented:
#
#   REPO         (required)  owner/name of the GitHub repository
#   ACCESS_TOKEN (required)  PAT able to create runner registration tokens
#                            (classic `repo` scope, or fine-grained with
#                            repository "Administration: write"). Only minted
#                            into short-lived registration tokens; never
#                            handed to the runner agent itself.
#   LABELS       (required)  runner label(s) this instance advertises
#                            (e.g. bench-skylake)
#   NAME         (required)  instance name: container name and runner-name
#                            prefix. MUST be unique per host -- the loop
#                            starts with `docker rm -f $NAME`, so two
#                            supervisors sharing a name kill each other's
#                            containers.
#   CPUSET       (optional)  pin the container to these cpu(s), forwarded as
#                            CPU= so taskset targets the same core(s)
#                            (recommended for stable bench cycles; the CPU
#                            governor is a host setting, see README.md)
#   MOUNT_NIX    (optional)  =1 shares the host's nix store with the job
#                            containers: /nix is bind-mounted read-only and
#                            builds go through the host's nix-daemon (its
#                            socket is re-mounted read-write over the ro
#                            store mount), so the store stays root-owned and
#                            immutable from the job's point of view and jobs
#                            cannot poison the toolchain for later jobs.
#                            Requires a multi-user nix install on the host
#                            (see README.md).
#   IMAGE        (optional)  docker image tag to build and run
#                            (default: formosa-libjade-runner)
#
# Example (foreground test):
#
#   REPO=<owner>/<repo> ACCESS_TOKEN=<PAT> \
#   LABELS=bench-skylake NAME=bench-runner CPUSET=7 MOUNT_NIX=1 ./run-runner.sh
set -euo pipefail
cd "$(dirname "$0")"

REPO="${REPO:?set REPO=owner/name}"
ACCESS_TOKEN="${ACCESS_TOKEN:?set ACCESS_TOKEN=<PAT that can create runner registration tokens>}"
LABELS="${LABELS:?set LABELS=<runner label(s)>}"
NAME="${NAME:?set NAME=<unique instance name>}"
CPUSET="${CPUSET:-}"
MOUNT_NIX="${MOUNT_NIX:-}"
IMAGE="${IMAGE:-formosa-libjade-runner}"

docker build -t "$IMAGE" .

# Clean exit: on SIGINT/SIGTERM stop looping and remove any in-flight container.
running=1
trap 'running=0; docker rm -f "$NAME" >/dev/null 2>&1 || true' INT TERM

echo "supervising ephemeral runner '$NAME' (fresh container per job)${CPUSET:+, pinned to cpu(s) $CPUSET}"
while [ "$running" = 1 ]; do
  # A leftover container from a hard kill would clash with --name; clear it.
  docker rm -f "$NAME" >/dev/null 2>&1 || true
  # No --privileged, no docker socket: the workflow needs neither, and granting
  # them would defeat the container's isolation. --rm discards the container
  # the moment the one-shot ephemeral job finishes.
  #
  # Run in the background and `wait`: bash only handles signals between
  # foreground commands, so a foreground `docker run` would defer the TERM
  # trap until the job ends and make `systemctl stop` hang until its kill
  # timeout. In `wait` the trap fires immediately, and its `docker rm -f`
  # tears the container down (the container lives under dockerd, outside the
  # unit's cgroup, so systemd cannot kill it directly).
  docker run --rm --name "$NAME" \
      ${CPUSET:+--cpuset-cpus="$CPUSET" -e CPU="$CPUSET"} \
      ${MOUNT_NIX:+-v /nix:/nix:ro \
        -v /nix/var/nix/daemon-socket:/nix/var/nix/daemon-socket \
        -e NIX_REMOTE=daemon} \
      -e REPO="$REPO" \
      -e ACCESS_TOKEN="$ACCESS_TOKEN" \
      -e LABELS="$LABELS" \
      -e RUNNER_NAME="$NAME-$(hostname)-$$" \
      "$IMAGE" &
  wait $! || true
  # Brief backoff so a registration failure can't spin the loop hot.
  [ "$running" = 1 ] && sleep 2
done
