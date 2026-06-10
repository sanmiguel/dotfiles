#!/bin/bash
# Claude Code `Notification` hook: post a macOS banner ONLY when iTerm2 is not
# the frontmost app, so the session you're actively watching never pings you.
# The built-in every-turn notifier (preferredNotifChannel) is disabled, so this
# is the sole banner source; it fires on Claude's own Notification events
# (permission needed / ~60s idle), not on every turn.
#
# Frontmost app is read via lsappinfo, which (unlike `System Events`) does not
# trigger a macOS Automation permission prompt.

input=$(cat)

front=$(lsappinfo info -only name "$(lsappinfo front)" 2>/dev/null | awk -F'"' '{print $4}')
case "$front" in
  *iTerm*) exit 0 ;;  # you're already looking at the terminal — stay silent
esac

# Pull "message" and "cwd" out of the hook JSON without a JSON dependency
# (same lightweight approach as statusline-command.sh).
field() { printf '%s' "$input" | sed -n "s/.*\"$1\"[[:space:]]*:[[:space:]]*\"\([^\"]*\)\".*/\1/p"; }
message=$(field message)
[ -z "$message" ] && message="Claude is waiting for your input"
dir=$(basename "$(field cwd)" 2>/dev/null)

osascript -e "display notification \"$message\" with title \"Claude Code\" subtitle \"$dir\"" >/dev/null 2>&1
exit 0
