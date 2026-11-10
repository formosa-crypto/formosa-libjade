# Self-hosted runners

Host-side provisioning for the machines behind the self-hosted workflows:

- [`bench.yml`](../workflows/bench.yml) (cycle benchmarks): one **matrix job
  per bench machine**, each machine's runner advertising a
  `bench-<microarchitecture>` label (e.g. `bench-skylake`);
- [`proofs.yml`](../workflows/proofs.yml) (EasyCrypt proof check): any
  runner advertising the `proofs` label, including a Linux VM on a Mac
  (see [macOS host](#macos-host-linux-vm)).

Every runner instance uses the same image and supervisor, and runs one
ephemeral container per job.

The workflows build their toolchain from the repo's `flake.nix` (derived
from `formosa-libjade.opam` via opam-nix) with `nix develop`; nothing is cached
on the GitHub side.

## Security model (designed for a public repo)

A self-hosted runner executes job code on your machine, so on a **public**
repo it is an RCE vector. The bench, proofs and checks workflows are built to
contain that:

- **No unreviewed fork code runs** (the primary defense). A PR from a branch
  of this repo runs on every push, with its own version of the workflows
  (`pull_request`, gated on `head.repo == this repo`): a change to the CI
  tests itself, and its author, a collaborator, can push code to these
  runners anyway. A fork's PR runs only when a maintainer, once the PR is
  reviewed, adds the label `safe to test` (only members with triage or write
  access can label): the `labeled` event runs the workflows as they are on
  main (`pull_request_target`) at the commit the PR had then. A push to the
  fork removes the label ([safe-to-test.yml](../workflows/safe-to-test.yml)),
  so new commits wait for a new review and a new label. Before labelling,
  check that the PR's head is the commit you reviewed.
- **The runner refuses forks too.** A fork's PR can add or edit a workflow
  (`on: pull_request`) that targets these runners; GitHub only asks a
  maintainer to approve it. The image's pre-job script,
  [job-started.sh](job-started.sh), fails every job of a fork's pull request
  except the `pull_request_target` runs started by the `safe to test` label,
  and every event other than a push, a manual run or a pull request, before
  the job's first step.
- **A fork can't weaken the gate.** The labelled runs use the workflow files of
  **main** (`pull_request_target`), not the PR's copy, so a fork's PR cannot
  edit the gate or steps to bypass these checks. (It can still change the
  `src/`/`bench/` code we build and run — that is what the label and the
  review above contain.) Its own `pull_request` runs may drop the gate, but
  they get no secrets and a read-only token, and these runners refuse them.
- **Nothing to exfiltrate.** A `pull_request_target` job runs in the trusted base
  context and *could* read `secrets.*` by default, but the jobs that run the
  checked code reference **no secrets** and have a read-only `GITHUB_TOKEN`
  (`contents: read`, plus `actions: read` to fetch artifacts), so checked-out
  code has nothing sensitive to steal. The one secret, the deploy key of the
  results repo, is only used by the publish jobs, on GitHub-hosted runners,
  which run no checked code.
- **No forged reuse.** A run reuses the results of an earlier run on the same
  tree through marker artifacts; only the markers of runs on this repo's own
  branches count, since a fork's PR can upload an artifact of any name.

Operational rules:

- Only collaborators push branches to the repo: review who has write access.
- Run the agent as a **dedicated unprivileged user** (the container path below
  does this for you), and restrict its network egress.
- Add `safe to test` to a fork's PR only after reading all of its changes: the
  label lets that code run on these hosts.
- Do **not** relax the `head.repo == this repo` gate or the label check
  further unless you fully accept arbitrary-code execution on this host.

## Linux host — containerized runner

This directory builds a small image with the runner agent and basic system
tooling. `run-runner.sh` then supervises a loop that starts **one fresh
container per job**: each iteration is `docker run --rm` with the in-container
agent registered `--ephemeral`, so it serves a single job and exits, the
container (and its whole filesystem) is removed, and the next job gets a
brand-new one. Job code never touches the host filesystem and nothing in
`$HOME` or `_work` persists between jobs.

The toolchain (jasminc + the pinned C compiler from `devShells.bench`) is
**not** in the image: jobs get it via `nix develop`, served by the host's nix
store shared into the container (`MOUNT_NIX=1`, below) — so a jasmin or
compiler bump changes `flake.lock`, never the image.

For a quick manual test you can run the loop in the foreground:

```
cd .github/runner
REPO=<owner>/<repo> ACCESS_TOKEN=<PAT> LABELS=bench-skylake NAME=bench-runner MOUNT_NIX=1 ./run-runner.sh   # Ctrl-C to stop
```

All instance variables (required and optional) are documented in one place:
**the header of [`run-runner.sh`](run-runner.sh)**.

For a persistent runner, supervise it with the provided systemd **user**
template unit so it starts on boot and restarts if the loop dies (this
replaces docker's `--restart=always`, which cannot give a fresh container
per job). The instance name selects the env file, `~/.config/<instance>/env`,
so one host can serve several instances (each with a distinct `NAME`):

```
loginctl enable-linger "$USER"
mkdir -p ~/.config/systemd/user ~/.config/bench-runner
cp runner@.service ~/.config/systemd/user/
printf 'REPO=<owner>/<repo>\nACCESS_TOKEN=<PAT>\nLABELS=bench-skylake\nNAME=bench-runner\nCPUSET=7\nMOUNT_NIX=1\n' > ~/.config/bench-runner/env
chmod 600 ~/.config/bench-runner/env
# edit ExecStart in the unit to point at this checkout, then:
systemctl --user daemon-reload
systemctl --user enable --now runner@bench-runner   # logs: journalctl --user -u runner@bench-runner -f
```

(Hosts set up with the former `bench-runner.service` unit migrate with
`systemctl --user disable --now bench-runner`, installing the template as
above, and enabling `runner@bench-runner`; the env file is unchanged.)

Operational notes:

- The PAT goes in the unit's `EnvironmentFile` (as above) — do not commit it.
- Under rootless Docker `--cpuset-cpus` needs a `Delegate=cpuset` drop-in, so
  leaving `CPUSET` unset is simplest (the in-container `taskset` still pins).
- The container needs **no `--privileged`** and **no docker socket**;
  `run-runner.sh` grants neither.
- Do **not** reintroduce a persisted `$HOME` in the runner (a persisted
  `$HOME` is exactly what made the opam-era toolchain silently survive
  between jobs); the nix store sharing below is the supported way to carry
  the toolchain.

## Sharing the host nix store with job containers (`MOUNT_NIX=1`)

On an ephemeral-container runner the job needs a nix store that survives
between jobs; share the **host's** store instead of caching.

One-time host setup (multi-user nix, daemon mode — run as a sudo-capable
user; the Debian `nix-bin` package does *not* fit here, its nix lives outside
`/nix` and its socket is group-gated):

```
sh <(curl -L https://nixos.org/nix/install) --daemon
```

Then set `MOUNT_NIX=1` in the instance env (e.g. `~/.config/bench-runner/env`)
and restart the unit (what the flag mounts, and why this preserves the
isolation model, is documented with the variable in `run-runner.sh`).
Occasional `nix-collect-garbage --delete-older-than 30d` on the host keeps
the store bounded.

## macOS host (Linux VM)

The proofs and constant-time checks do not depend on the OS, so an
Apple-silicon Mac serves them from a **long-lived Linux VM** that plays the
part of the Linux host above: the VM runs Docker, the multi-user nix daemon,
and the same `run-runner.sh` loop, and each job still gets a fresh container.
Only the VM and its nix store persist; the store is read-only to jobs
(`MOUNT_NIX=1`). Use [Lima](https://lima-vm.io) (one VM shared by all job
containers), not Apple's `container` tool, which boots one VM per container
and so has no host to share the nix store from.

Install Lima system-wide (admin), either from the machine's Homebrew
(`brew install lima && brew pin lima`, so that an unrelated `brew upgrade`
cannot swap it under the VM; `limactl` is then `/opt/homebrew/bin/limactl`)
or from the release tarball, which unpacks into `bin/` and `share/`:

```
v=2.2.1   # https://github.com/lima-vm/lima/releases
curl -fsSL "https://github.com/lima-vm/lima/releases/download/v$v/lima-$v-Darwin-arm64.tar.gz" \
  | sudo tar xz -C /usr/local
```

Then, as a dedicated non-admin user (e.g. `ghrunner`) that owns the VM:

```
limactl create --name=ci --vm-type=vz --cpus=16 --memory=48 --disk=200 \
  --mount-none --containerd=none template:ubuntu-26.04
limactl start ci
```

`--mount-none` matters: by default Lima mounts the Mac user's home into the
VM. Size `--cpus`/`--memory` to the Mac (`sysctl -n hw.ncpu hw.memsize`),
leaving headroom for the host.

Start the VM at boot with a LaunchDaemon (admin; `limactl start-at-login`
installs a LaunchAgent, which only runs while the user is logged in), e.g.
`/Library/LaunchDaemons/io.lima.ci.plist`:

```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
  <key>Label</key><string>io.lima.ci</string>
  <key>UserName</key><string>ghrunner</string>
  <key>EnvironmentVariables</key><dict><key>HOME</key><string>/Users/ghrunner</string></dict>
  <key>ProgramArguments</key><array>
    <!-- /opt/homebrew/bin/limactl for a Homebrew install -->
    <string>/usr/local/bin/limactl</string><string>start</string><string>--foreground</string><string>ci</string>
  </array>
  <key>RunAtLoad</key><true/>
  <key>KeepAlive</key><true/>
</dict></plist>
```

```
sudo launchctl bootstrap system /Library/LaunchDaemons/io.lima.ci.plist
```

Inside the VM (`limactl shell ci`), follow the Linux host setup: rootless
Docker, multi-user nix (see below), then the systemd unit above with
several `proofs` instances, each pinned to its own CPUs (`CPUSET`; the
proofs job runs one EasyCrypt job per two CPUs it sees). On a 16-CPU VM, three
5-CPU instances leave one CPU for the docker and nix daemons:

```
i=1; for cpus in 0-4 5-9 10-14; do
  mkdir -p ~/.config/proofs-runner-$i
  printf 'REPO=<owner>/<repo>\nACCESS_TOKEN=<PAT>\nLABELS=proofs\nNAME=proofs-runner-%s\nCPUSET=%s\nMOUNT_NIX=1\n' $i $cpus \
    > ~/.config/proofs-runner-$i/env
  chmod 600 ~/.config/proofs-runner-$i/env
  systemctl --user enable --now runner@proofs-runner-$i
  i=$((i+1))
done
```

(Ubuntu's systemd already delegates the `cpuset` controller to user
services, so rootless Docker honours `--cpuset-cpus` without a drop-in.)

The image builds for the VM's architecture (`linux-arm64` agent), and the
toolchain is built for `aarch64-linux` on the first job (z3 from source, so
expect a slow first run); later jobs reuse the VM's store.

## Frequency (stable cycle counts) — host setting

The workflow does not change CPU frequency (no sudo in CI); it relies on the
core-pinning + warm-up in the Makefile. For stable numbers, pin the governor
**once, out of band** (root):

```
cpupower frequency-set -g performance
echo 1 > /sys/devices/system/cpu/intel_pstate/no_turbo   # lock to base clock
```

Make it persistent with a `systemd` unit or `tuned` so the report's Environment
block reads `freq governor: performance` across reboots.

## What the bench workflow runs

Per matrix job (one per `bench-*` machine): `checkout` (with submodules — the
`third_party` reference implementations) → **toolchain** (`nix develop .#bench`
against the shared host store; seconds when warm) → `make -C src` +
`make -C bench libs` → `make -C bench test` (KAT gate) → `make -C bench report`
→ append `bench.md` to that job's `$GITHUB_STEP_SUMMARY`. The core to pin is
auto-selected (highest-max-MHz core); override per run with the Makefile's
`CPU=` if needed.
