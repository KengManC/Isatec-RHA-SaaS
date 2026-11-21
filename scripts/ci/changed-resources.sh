#!/bin/bash
# Print dashboard/notebook/workflow definition files added or modified between two commits.
# Usage: changed-resources.sh <base-sha> <head-sha>
set -euo pipefail
git diff --name-only --diff-filter=ACMR "$1" "$2" -- dashboards notebooks workflows \
  | grep -E '\.(json|ya?ml)$' || true
