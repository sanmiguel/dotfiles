#!/usr/bin/env bash
# Persist / restore a worktree's context doc (decisions, dead-ends, open
# threads) as a git note on the branch's FIRST commit, in a dedicated notes
# ref. The first commit is a stable, branch-unique anchor: it doesn't move as
# feedback commits land, and `notes.rewriteRef` keeps the note attached across
# amend/rebase. Notes are local to this machine (never pushed).
#
#   save <file>   store <file> as the note for the current branch's first commit
#   resume        write the note (if any) to the doc file; print its path
#   hook          SessionStart hook: if a note exists for cwd's branch, emit
#                 additionalContext offering resume. Always exits 0.
set -euo pipefail

NOTES_REF="refs/notes/wt-context"
DOC_FILE=".worktree-context.md"

die() { echo "worktree-context: $*" >&2; exit 1; }

# Minimal JSON string encoder (message is plain ASCII).
json_str() { printf '"%s"' "$(printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g')"; }

# Base ref used to find the first commit unique to this branch.
# Override with `git config wt-context.base <ref>` or WT_BASE=<ref>.
detect_base() {
  local b c
  b="${WT_BASE:-$(git config wt-context.base 2>/dev/null || true)}"
  if [ -n "$b" ] && git rev-parse --verify -q "$b" >/dev/null; then echo "$b"; return; fi
  b="$(git rev-parse --abbrev-ref origin/HEAD 2>/dev/null || true)"
  if [ -n "$b" ] && git rev-parse --verify -q "$b" >/dev/null; then echo "$b"; return; fi
  for c in main master develop trunk; do
    if git rev-parse --verify -q "origin/$c" >/dev/null; then echo "origin/$c"; return; fi
    if git rev-parse --verify -q "$c" >/dev/null; then echo "$c"; return; fi
  done
  return 1
}

# Oldest commit reachable from HEAD but not the base = first commit on branch.
# `| tail -1` (not `head`) so the pipeline reads all input and never SIGPIPEs
# git under `pipefail`.
first_commit() {
  local base; base="$(detect_base)" || return 1
  git rev-list "$base"..HEAD | tail -1
}

cmd_save() {
  local file="${1:?usage: worktree-context.sh save <file>}"
  [ -f "$file" ] || die "no such file: $file"
  local anchor; anchor="$(first_commit)" || \
    die "can't determine branch base; set 'git config wt-context.base <ref>'"
  [ -n "$anchor" ] || die "no commits on this branch yet — commit before saving context"
  git notes --ref="$NOTES_REF" add -f -F "$file" "$anchor"
  echo "saved context note on $anchor ($(git log -1 --format=%s "$anchor"))"
}

cmd_resume() {
  local anchor; anchor="$(first_commit)" || die "can't determine branch base"
  [ -n "$anchor" ] || die "no commits on this branch yet"
  if git notes --ref="$NOTES_REF" show "$anchor" >"$DOC_FILE" 2>/dev/null; then
    echo "$DOC_FILE"
  else
    rm -f "$DOC_FILE"
    echo "no saved context for this branch"
  fi
}

cmd_hook() {
  local input cwd anchor branch msg
  input="$(cat || true)"
  cwd="$(printf '%s' "$input" | sed -n 's/.*"cwd"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')"
  [ -n "$cwd" ] || cwd="${CLAUDE_PROJECT_DIR:-$PWD}"
  cd "$cwd" 2>/dev/null || exit 0
  git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0
  anchor="$(first_commit 2>/dev/null || true)"
  [ -n "$anchor" ] || exit 0
  git notes --ref="$NOTES_REF" show "$anchor" >/dev/null 2>&1 || exit 0
  branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo '?')"
  msg="A saved worktree-context doc exists for branch '$branch' (git note on its first commit). If continuing prior work here — e.g. acting on PR feedback — offer to load it by running the worktree-context skill in resume mode before proceeding."
  printf '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":%s}}\n' "$(json_str "$msg")"
}

case "${1:-}" in
  save)   shift; cmd_save "$@" ;;
  resume) shift; cmd_resume ;;
  hook)   shift; cmd_hook ;;
  *)      die "usage: worktree-context.sh {save <file>|resume|hook}" ;;
esac
