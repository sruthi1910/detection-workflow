#!/usr/bin/env bash
# PostToolUse hook: validates detection rule YAML files under rules/.
# Exits 2 in both the valid and invalid case so Claude sees the feedback on stderr.

input=$(cat)
file_path=$(printf '%s' "$input" | jq -r '.tool_input.file_path // empty')

# Only check YAML files under a rules/ directory (file_path is absolute)
if [[ -z "$file_path" || ! "$file_path" =~ (^|/)rules/.*\.ya?ml$ ]]; then
  exit 0
fi

python3 - "$file_path" <<'EOF'
import sys
import yaml

path = sys.argv[1]
errors = []

try:
    with open(path) as f:
        rule = yaml.safe_load(f)
except Exception as e:
    print(f"INVALID {path}: could not parse YAML: {e}", file=sys.stderr)
    sys.exit(2)

if not isinstance(rule, dict):
    print(f"INVALID {path}: top level must be a mapping", file=sys.stderr)
    sys.exit(2)

if not rule.get("title"):
    errors.append("missing 'title' field")
if not rule.get("description"):
    errors.append("missing 'description' field")

tags = rule.get("tags")
if not isinstance(tags, list) or not any(
    isinstance(t, str) and t.lower().startswith("attack.t") for t in tags
):
    errors.append("'tags' must contain at least one 'attack.t' entry (e.g. attack.t1059)")

if errors:
    print(f"INVALID {path}:", file=sys.stderr)
    for e in errors:
        print(f"  - {e}", file=sys.stderr)
else:
    print(f"VALID {path}: title, description and ATT&CK technique tag present", file=sys.stderr)

sys.exit(2)
EOF
exit 2
