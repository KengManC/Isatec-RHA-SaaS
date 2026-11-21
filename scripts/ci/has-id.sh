#!/bin/bash
# Exit 0 if a resource file already carries a top-level Dynatrace "id" (i.e. it was applied before).
f="$1"
case "$f" in
  *.json)
    if command -v jq >/dev/null; then jq -e '(.id // "") | length > 0' "$f" >/dev/null 2>&1
    else grep -qE '^\s{0,2}"id"\s*:\s*"[^"]+"' "$f"; fi ;;
  *)
    if command -v yq >/dev/null; then [ -n "$(yq -r '.id // ""' "$f" 2>/dev/null)" ]
    else grep -qE '^id:\s*\S+' "$f"; fi ;;
esac
