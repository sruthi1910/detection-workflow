#!/usr/bin/env bash
# Shows a macOS notification when Claude finishes responding (Stop hook).
# Always exits 0 so a notification failure never blocks Claude.

osascript -e 'display notification "Claude finished" with title "Claude Code"'
exit 0
