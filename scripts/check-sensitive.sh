#!/usr/bin/env bash
# PreToolUse hook: blocks access to sensitive files (.env*, keys, secrets, credentials).
# Checks both file tools (tool_input.file_path) and shell commands (tool_input.command),
# so the agent can't read a secret with `cat .env` instead of the Read tool.
# Exits 2 to block (message on stderr), 0 to allow.

input=$(cat)
file_path=$(printf '%s' "$input" | jq -r '.tool_input.file_path // empty')
command=$(printf '%s' "$input" | jq -r '.tool_input.command // empty')

# Sensitive patterns: any .env variant, private keys/certs, secrets/ and credentials/ folders
pattern='(^|[/[:space:]"'"'"'])\.env[^/[:space:]]*|\.(key|pem)([[:space:]"'"'"']|$)|(^|[/[:space:]])(secrets|credentials)/'

for target in "$file_path" "$command"; do
  if [[ -n "$target" ]] && printf '%s' "$target" | grep -Eq "$pattern"; then
    echo "BLOCKED: '$target' touches a sensitive file (.env*, *.key, *.pem, secrets/, credentials/)" >&2
    exit 2
  fi
done

exit 0
