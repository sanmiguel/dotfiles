#!/usr/bin/env bash
# Snapshot / restore Claude Code settings files (auto-mode config lives here).
#
#   settings-snapshot.sh backup [label]     take a snapshot (optionally labelled)
#   settings-snapshot.sh list               list snapshots
#   settings-snapshot.sh show <name>        print a snapshot's files
#   settings-snapshot.sh diff <name>        diff snapshot -> current (what changed since)
#   settings-snapshot.sh restore <name> [-y]  restore a snapshot (auto-backs up current first)
#
# Snapshots live in ~/.claude/backups/settings/<UTC-timestamp>[-label]/ with a
# manifest.tsv mapping each stored file back to its absolute original path.
# Project-level files are included when run from inside a project (cwd/.claude).
set -euo pipefail

BACKUP_ROOT="${CLAUDE_SETTINGS_BACKUP_ROOT:-$HOME/.claude/backups/settings}"

# name-in-snapshot<TAB>absolute-source-path
candidate_files() {
  printf 'user__settings.json\t%s\n' "$HOME/.claude/settings.json"
  printf 'user__settings.local.json\t%s\n' "$HOME/.claude/settings.local.json"
  if [ -d "$PWD/.claude" ]; then
    printf 'project__settings.json\t%s\n' "$PWD/.claude/settings.json"
    printf 'project__settings.local.json\t%s\n' "$PWD/.claude/settings.local.json"
  fi
}

die() { echo "error: $*" >&2; exit 1; }

snapshot_dir() {
  local name="$1"
  [ -n "$name" ] || die "snapshot name required (see: $0 list)"
  local dir="$BACKUP_ROOT/$name"
  [ -d "$dir" ] || die "no such snapshot: $name"
  echo "$dir"
}

cmd_backup() {
  local label="${1:-}"
  local stamp
  stamp="$(date -u +%Y%m%dT%H%M%SZ)"
  local name="$stamp${label:+-$label}"
  local dir="$BACKUP_ROOT/$name"
  mkdir -p "$dir"
  : > "$dir/manifest.tsv"
  local n=0
  while IFS=$'\t' read -r stored src; do
    [ -f "$src" ] || continue
    cp -p "$src" "$dir/$stored"
    printf '%s\t%s\n' "$stored" "$src" >> "$dir/manifest.tsv"
    n=$((n + 1))
  done < <(candidate_files)
  [ "$n" -gt 0 ] || { rm -rf "$dir"; die "no settings files found to back up"; }
  echo "snapshot: $name"
  awk -F'\t' '{printf "  %-30s <- %s\n", $1, $2}' "$dir/manifest.tsv"
}

cmd_list() {
  [ -d "$BACKUP_ROOT" ] || { echo "no snapshots yet"; return; }
  local d
  for d in "$BACKUP_ROOT"/*/; do
    [ -f "$d/manifest.tsv" ] || continue
    printf '%s  (%s files)\n' "$(basename "$d")" "$(wc -l < "$d/manifest.tsv" | tr -d ' ')"
  done
}

cmd_show() {
  local dir
  dir="$(snapshot_dir "${1:-}")"
  while IFS=$'\t' read -r stored src; do
    echo "===== $src ====="
    cat "$dir/$stored"
    echo
  done < "$dir/manifest.tsv"
}

cmd_diff() {
  local dir
  dir="$(snapshot_dir "${1:-}")"
  local changed=0
  while IFS=$'\t' read -r stored src; do
    if [ ! -f "$src" ]; then
      echo "MISSING now (was in snapshot): $src"; changed=1; continue
    fi
    if ! diff -u --label "snapshot/$stored" --label "current/$src" "$dir/$stored" "$src"; then
      changed=1
    fi
  done < "$dir/manifest.tsv"
  [ "$changed" -eq 0 ] && echo "no differences from snapshot $(basename "$dir")"
  return 0
}

cmd_restore() {
  local name="${1:-}"; shift || true
  local yes=0
  [ "${1:-}" = "-y" ] && yes=1
  local dir
  dir="$(snapshot_dir "$name")"

  # validate every stored file parses before touching anything
  while IFS=$'\t' read -r stored _; do
    jq empty "$dir/$stored" >/dev/null 2>&1 || die "snapshot file is not valid JSON: $dir/$stored"
  done < "$dir/manifest.tsv"

  echo "Restoring snapshot $name will overwrite:"
  awk -F'\t' '{printf "  %s\n", $2}' "$dir/manifest.tsv"
  echo
  echo "Changes that restore will UNDO (current -> snapshot):"
  cmd_diff "$name" | sed 's/^/  /'
  echo
  if [ "$yes" -ne 1 ]; then
    read -r -p "Proceed? [y/N] " ans
    case "$ans" in y|Y|yes|YES) ;; *) echo "aborted"; return 1 ;; esac
  fi

  echo "-- taking safety snapshot of current state first"
  cmd_backup "pre-restore"

  while IFS=$'\t' read -r stored src; do
    mkdir -p "$(dirname "$src")"
    cp -p "$dir/$stored" "$src"
    echo "restored: $src"
  done < "$dir/manifest.tsv"
  echo "done. Restart Claude Code sessions so they pick up the restored settings."
}

case "${1:-}" in
  backup)  shift; cmd_backup "$@" ;;
  list)    cmd_list ;;
  show)    shift; cmd_show "$@" ;;
  diff)    shift; cmd_diff "$@" ;;
  restore) shift; cmd_restore "$@" ;;
  *) sed -n '2,12p' "$0" | sed 's/^# \{0,1\}//'; exit 1 ;;
esac
