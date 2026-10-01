#!/usr/bin/env bash
# PreToolUse hook: blocks edits to sensitive files (.env, keys, secrets, credentials).
# Exits 2 to block (message on stderr), 0 to allow.

input=$(cat)
file_path=$(printf '%s' "$input" | jq -r '.tool_input.file_path // empty')

if [[ -z "$file_path" ]]; then
  exit 0
fi

# file_path is absolute, so anchor on path segments rather than ^
if [[ "$file_path" =~ (^|/)\.env$ \
   || "$file_path" =~ \.key$ \
   || "$file_path" =~ \.pem$ \
   || "$file_path" =~ (^|/)secrets/ \
   || "$file_path" =~ (^|/)credentials/ ]]; then
  echo "BLOCKED $file_path: matches a sensitive file pattern (.env, *.key, *.pem, secrets/, credentials/)" >&2
  exit 2
fi

exit 0
