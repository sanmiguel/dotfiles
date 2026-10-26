#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Assigned to Me
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon 🐙
# @raycast.packageName GitHub
# @raycast.description Open issues and PRs assigned to me, grouped by repo

# Environment overrides:
#   GH_HOST            target host (default below)
#   NO_COLOR=1         disable ANSI colours
#   GH_ASSIGNED_MODE   "count" prints a one-line summary (used by the inline script)

set -u -o pipefail

export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
export GH_HOST="${GH_HOST:-hopper-healthcare.ghe.com}"

MODE="${GH_ASSIGNED_MODE:-list}"

if ! command -v gh >/dev/null 2>&1; then
  [ "$MODE" = "count" ] && echo "gh not found" || echo "gh not found on PATH ($PATH)"
  exit 1
fi

# One GraphQL request, two aliased searches:
#   issues: every open issue assigned to me
#   prs:    every open PR assigned to me, plus author and assignment history,
#           so PRs I authored can be filtered client-side
QUERY=$(cat <<'EOF'
query {
  viewer { login }
  issues: search(query: "is:issue is:open archived:false assignee:@me", type: ISSUE, first: 100) {
    issueCount
    nodes {
      ... on Issue {
        number title updatedAt
        repository { nameWithOwner }
        labels(first: 5) { nodes { name } }
      }
    }
  }
  prs: search(query: "is:pr is:open archived:false assignee:@me", type: ISSUE, first: 100) {
    issueCount
    nodes {
      ... on PullRequest {
        number title updatedAt isDraft
        author { login }
        repository { nameWithOwner }
        labels(first: 5) { nodes { name } }
        timelineItems(itemTypes: [ASSIGNED_EVENT], last: 20) {
          nodes {
            ... on AssignedEvent {
              actor { __typename login }
              assignee { ... on User { login } }
            }
          }
        }
      }
    }
  }
}
EOF
)

JQ=$(cat <<'EOF'
def c($code): if ($ENV.NO_COLOR // "") != "" then . else "\u001b[\($code)m\(.)\u001b[0m" end;
def ago:
  ([now - fromdateiso8601, 0] | max) as $s
  | if   $s < 60      then "now"
    elif $s < 3600    then "\($s / 60      | floor)m"
    elif $s < 86400   then "\($s / 3600    | floor)h"
    elif $s < 2592000 then "\($s / 86400   | floor)d"
    else                   "\($s / 2592000 | floor)mo" end;
# Hide an authored PR only when the latest assignment of $me is positively
# known to be by $me or by a bot. Missing events (outside the 20-event window)
# or unresolvable actors (deleted accounts) fail open: the PR is shown.
def self_or_bot_assigned($me):
  [.timelineItems.nodes[] | select(.assignee.login == $me)] | last
  | (. != null and .actor != null
     and (.actor.login == $me or .actor.__typename == "Bot"));

.data as $d
| $d.viewer.login as $me
| ($d.issues.nodes | map(select(.number != null) | . + {kind: "issue"})) as $issues
| ($d.prs.nodes
    | map(select(.number != null)
          | select(.author.login != $me or (self_or_bot_assigned($me) | not))
          | . + {kind: "pr"})) as $prs
| $d.issues.issueCount as $ni
| ($prs | length) as $np
| ($d.issues.issueCount > ($d.issues.nodes | length)) as $issues_trunc
| ($d.prs.issueCount > ($d.prs.nodes | length)) as $prs_trunc
| if ($ENV.GH_ASSIGNED_MODE // "") == "count" then
    if $ni + $np == 0 and ($prs_trunc | not) then "Nothing assigned"
    else "\($ni) issues · \($np)\(if $prs_trunc then "+" else "" end) PRs" end
  else
    ($issues + $prs) as $all
    | if ($all | length) == 0 then "No open issues or PRs assigned to you."
      else
        ("\($ni) issues · \($np) PRs" | c("1")),
        ( $all
          | group_by(.repository.nameWithOwner)
          | map(sort_by(.updatedAt) | reverse)
          | sort_by(.[0].updatedAt) | reverse
          | .[]
          | ([.[] | "#\(.number)" | length] | max) as $w
          | "",
            (.[0].repository.nameWithOwner | c("1;34")),
            ( .[]
              | ("#\(.number)" | . + (" " * ($w - length + 1))) as $num
              | "  " + ($num | c("33"))
                + (if .kind == "pr" then ("PR" | c("35")) else "  " end)
                + "  " + .title
                + (if .kind == "pr" and .isDraft then (" (draft)" | c("2")) else "" end)
                + (if (.labels.nodes | length) > 0
                   then "  " + ("[" + (.labels.nodes | map(.name) | join(", ")) + "]" | c("36"))
                   else "" end)
                + "  " + (.updatedAt | ago | c("2"))
            )
        ),
        (if $issues_trunc then "", ("Showing 100 of \($ni) issues" | c("31")) else empty end),
        (if $prs_trunc then "", ("PR search truncated at 100 before author filtering" | c("31")) else empty end)
      end
  end
EOF
)

errfile=$(mktemp)
trap 'rm -f "$errfile"' EXIT

if ! out=$(gh api graphql -f query="$QUERY" --jq "$JQ" 2>"$errfile"); then
  msg=$(head -n 3 "$errfile")
  if [ "$MODE" = "count" ]; then
    echo "gh error"
  else
    echo "Failed to query $GH_HOST:"
    echo "$msg"
    echo
    echo "If authentication has expired: gh auth login --hostname $GH_HOST"
  fi
  exit 1
fi

printf '%s\n' "$out"
