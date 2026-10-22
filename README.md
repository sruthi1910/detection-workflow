# detection-workflow

Module 7 (Hooks): a prerequisite check (SessionStart), a sensitive-file guard (PreToolUse), a detection-rule validator (PostToolUse) and a completion notification (Stop).

## Notes for course readers

**The completion notification lives in `scripts/notify-complete.sh`.**
On macOS, `osascript` notifications only appear if notifications are allowed for the app that sends them, so the inline command was moved into a script that can be tested on its own. *If you're following the course:* if no banner appears, check System Settings → Notifications.

**The rule validator exits 2 on success as well as on failure.**
This matches the course: for a PostToolUse hook, exit 2 is what sends the hook's output back to Claude. `/doctor` counts these as "blocking errors"; that's expected.

**There is no `costThreshold` setting.**
Section 7.7 mentions it, but Claude Code has no such setting, so nothing was configured. *If you're following the course:* use `/cost` and `/context` to watch usage instead.

**Fixed: shell-command bypass of the sensitive-file guard.**
The original hook only checked `tool_input.file_path`, so the agent could still read a secret with a Bash command such as `cat .env`, and the pattern missed variants like `.env.local`. The hook now also inspects `tool_input.command` and matches `.env*`, `*.key`, `*.pem`, `secrets/` and `credentials/`.
