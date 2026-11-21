#!/bin/bash
# CI helper: install a pinned dtctl (checksum-verified) and configure the rha75589 context
# from the DT_ENVIRONMENT / DT_PLATFORM_TOKEN environment variables (GitHub secrets).
set -euo pipefail
DTCTL_VERSION="${DTCTL_VERSION:-0.46.0}"
: "${DT_ENVIRONMENT:?DT_ENVIRONMENT secret is not set}"
: "${DT_PLATFORM_TOKEN:?DT_PLATFORM_TOKEN secret is not set}"

if ! command -v dtctl >/dev/null || ! dtctl version 2>/dev/null | grep -q "$DTCTL_VERSION"; then
  tmp=$(mktemp -d)
  base="https://github.com/dynatrace/dtctl/releases/download/v${DTCTL_VERSION}"
  asset="dtctl_${DTCTL_VERSION}_linux_amd64.tar.gz"
  curl -fsSL "$base/$asset" -o "$tmp/$asset"
  curl -fsSL "$base/checksums.txt" -o "$tmp/checksums.txt"
  (cd "$tmp" && grep " ${asset}\$" checksums.txt | sha256sum -c -)
  tar -xzf "$tmp/$asset" -C "$tmp" dtctl
  sudo install "$tmp/dtctl" /usr/local/bin/dtctl
fi

dtctl config set-credentials rha-token --global --token "$DT_PLATFORM_TOKEN" >/dev/null
dtctl config set-context rha75589 --global --environment "$DT_ENVIRONMENT" \
  --token-ref rha-token --safety-level readwrite-all >/dev/null
dtctl config use-context rha75589 >/dev/null
dtctl doctor --no-agent | grep -E 'Authentication|Connectivity'
