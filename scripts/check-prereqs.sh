#!/usr/bin/env bash
# Warns on stderr if required tools (jq, python3) are not installed.
# Always exits 0: missing tools are reported, not treated as fatal.

for cmd in jq python3; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "WARNING: $cmd is not installed or not on PATH" >&2
  fi
done

exit 0
