# Containerized self-hosted GitHub Actions runner (bench and proofs workflows).
#
# The image carries only the runner agent and basic system tooling (git,
# curl/jq for the entrypoint, taskset). The build toolchain is NOT in the
# image: jobs get it from the repo's flake.nix via `nix develop`, served by
# the host's nix store shared into the container (MOUNT_NIX=1 in
# run-runner.sh) -- so a toolchain bump changes flake.lock, never the image.
#
# No Docker-in-Docker is needed (the workflow is plain make/cc). Run WITHOUT
# --privileged and WITHOUT mounting the docker socket.
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
# git for actions/checkout (submodules), curl/jq for the entrypoint and the
# agent download below, util-linux for taskset (bench core pinning),
# openssh-client for git-over-ssh pushes (the proofs sunburst publish step).
RUN apt-get update && apt-get install -y --no-install-recommends \
        git curl jq ca-certificates util-linux openssh-client \
    && rm -rf /var/lib/apt/lists/*

# The runner agent must not run as root; use a dedicated unprivileged user.
RUN useradd -m runner
WORKDIR /home/runner

# Fetch the latest runner agent for the build machine's architecture (x64 on
# the bench hosts, arm64 in an Apple-silicon VM; it self-updates on connect
# anyway), install its OS dependencies, then hand ownership to the runner user.
RUN set -eux; \
    case "$(uname -m)" in \
      x86_64)  arch=x64 ;; \
      aarch64) arch=arm64 ;; \
      *) echo "unsupported architecture: $(uname -m)" >&2; exit 1 ;; \
    esac; \
    ver="$(curl -fsSL https://api.github.com/repos/actions/runner/releases/latest \
           | jq -r .tag_name | sed 's/^v//')"; \
    curl -fsSL -o runner.tar.gz \
      "https://github.com/actions/runner/releases/download/v${ver}/actions-runner-linux-${arch}-${ver}.tar.gz"; \
    tar xzf runner.tar.gz && rm runner.tar.gz; \
    ./bin/installdependencies.sh; \
    chown -R runner:runner /home/runner

# Pre-job check: no job of a fork's pull request runs here (see job-started.sh). Owned
# by root and outside the agent's directory, so the jobs cannot modify it.
COPY job-started.sh /opt/runner-hooks/job-started.sh
RUN chmod 0755 /opt/runner-hooks/job-started.sh
ENV ACTIONS_RUNNER_HOOK_JOB_STARTED=/opt/runner-hooks/job-started.sh

USER runner
COPY --chown=runner:runner entrypoint.sh /home/runner/entrypoint.sh
ENTRYPOINT ["/home/runner/entrypoint.sh"]
