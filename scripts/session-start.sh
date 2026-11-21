#!/bin/bash
# Runs at the start of every Claude session (via the SessionStart hook in .claude/settings.json).
# Only acts in Claude cloud sessions; on a local PC it exits immediately.
[ "$CLAUDE_CODE_REMOTE" = "true" ] || exit 0
: "${DT_PLATFORM_TOKEN:?DT_PLATFORM_TOKEN not set in the cloud environment}"
: "${DT_ENVIRONMENT:?DT_ENVIRONMENT not set in the cloud environment}"

# Point dtctl at rha75589 using the token from the cloud environment variables (never printed)
dtctl config set-credentials rha-token --global --token "$DT_PLATFORM_TOKEN" >/dev/null
dtctl config set-context rha75589 --global --environment "$DT_ENVIRONMENT" \
  --token-ref rha-token --safety-level readwrite-all >/dev/null
dtctl config use-context rha75589 >/dev/null

# Install npm packages for any custom apps
for d in apps/*/; do
  [ -f "$d/package.json" ] && (cd "$d" && npm ci --silent)
done

# One-line health check so the session shows whether sign-in worked
dtctl doctor | grep -E 'Authentication|Connectivity'
exit 0
