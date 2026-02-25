#!/bin/bash
# dispatch.sh - Check issues with agent labels and determine which skills to run.
# Usage: dispatch.sh <owner/repo1,owner/repo2...> <agent-username>
#
# Examples:
#   dispatch.sh yuv-labs/baduk oclaw97-gif
#   dispatch.sh yuv-labs/baduk,yuv-labs/agent-playbook oclaw97-gif

set -euo pipefail

REPOS_INPUT="${1:?Usage: dispatch.sh <owner/repo1,owner/repo2...> <agent-username>}"
AGENT="${2:?Usage: dispatch.sh <owner/repo1,owner/repo2...> <agent-username>}"

# Global arrays
tasks=()
waits=()

# Find the most recent human actor on an issue (and its linked PR).
last_actor() {
  local repo="$1"
  local number="$2"
  local latest=""

  # Issue: comments (exclude bots)
  local comment
  comment=$(gh api "repos/$repo/issues/$number/comments" \
    --jq '[.[] | select(.user.type != "Bot")] |
      if length > 0 then .[-1] | "\(.created_at) \(.user.login)" else empty end' 2>/dev/null || true)
  [[ -n "$comment" && "$comment" > "$latest" ]] && latest="$comment"

  # Issue: label events
  local label_event
  label_event=$(gh api "repos/$repo/issues/$number/events" \
    --jq '[.[] | select(.event == "labeled" or .event == "unlabeled")] |
      if length > 0 then .[-1] | "\(.created_at) \(.actor.login)" else empty end' 2>/dev/null || true)
  [[ -n "$label_event" && "$label_event" > "$latest" ]] && latest="$label_event"

  # Find linked PR (agent branch pattern: agent/{number}-*)
  local pr_number
  pr_number=$(gh pr list --repo "$repo" --state open --json number,headRefName \
    --jq ".[] | select(.headRefName | startswith(\"agent/$number-\")) | .number" 2>/dev/null | head -1)

  if [[ -n "$pr_number" ]]; then
    # PR: review comments (exclude bots)
    local pr_comment
    pr_comment=$(gh api "repos/$repo/pulls/$pr_number/comments" \
      --jq '[.[] | select(.user.type != "Bot")] |
        if length > 0 then .[-1] | "\(.created_at) \(.user.login)" else empty end' 2>/dev/null || true)
    [[ -n "$pr_comment" && "$pr_comment" > "$latest" ]] && latest="$pr_comment"

    # PR: reviews (exclude bots)
    local review
    review=$(gh api "repos/$repo/pulls/$pr_number/reviews" \
      --jq '[.[] | select(.user.type != "Bot")] |
        if length > 0 then .[-1] | "\(.submitted_at) \(.user.login)" else empty end' 2>/dev/null || true)
    [[ -n "$review" && "$review" > "$latest" ]] && latest="$review"

    # PR: issue-style comments (exclude bots)
    local pr_issue_comment
    pr_issue_comment=$(gh api "repos/$repo/issues/$pr_number/comments" \
      --jq '[.[] | select(.user.type != "Bot")] |
        if length > 0 then .[-1] | "\(.created_at) \(.user.login)" else empty end' 2>/dev/null || true)
    [[ -n "$pr_issue_comment" && "$pr_issue_comment" > "$latest" ]] && latest="$pr_issue_comment"
  fi

  echo "$latest"
}

check_repo() {
  local repo="$1"
  echo "=== $repo ==="

  # agent:plan issues
  while IFS=$'\t' read -r number title; do
    [[ -z "$number" ]] && continue
    result=$(last_actor "$repo" "$number")
    ts=$(echo "$result" | awk '{print $1}')
    actor=$(echo "$result" | awk '{print $2}')
    if [[ "$actor" != "$AGENT" ]]; then
      tasks+=("$ts	RUN   repo-plan   $repo #$number  $title")
    else
      waits+=("WAIT  repo-plan   $repo #$number  $title  (user turn)")
    fi
  done <<< "$(gh issue list --repo "$repo" --label "agent:plan" --state open --json number,title --jq '.[] | "\(.number)\t\(.title)"' 2>/dev/null)"

  # agent:wip issues
  while IFS=$'\t' read -r number title; do
    [[ -z "$number" ]] && continue
    result=$(last_actor "$repo" "$number")
    ts=$(echo "$result" | awk '{print $1}')
    actor=$(echo "$result" | awk '{print $2}')
    if [[ "$actor" != "$AGENT" ]]; then
      tasks+=("$ts	RUN   repo-execute $repo #$number  $title")
    else
      waits+=("WAIT  repo-execute $repo #$number  $title  (user turn)")
    fi
  done <<< "$(gh issue list --repo "$repo" --label "agent:wip" --state open --json number,title --jq '.[] | "\(.number)\t\(.title)"' 2>/dev/null)"
}

IFS=',' read -ra REPO_LIST <<< "$REPOS_INPUT"
for repo in "${REPO_LIST[@]}"; do
  # Trim whitespace
  repo=$(echo "$repo" | xargs)
  if [[ -n "$repo" ]]; then
    check_repo "$repo"
  fi
done

# Print RUN items sorted by timestamp (oldest user action first)
if [[ ${#tasks[@]} -gt 0 ]]; then
  printf '%s\n' "${tasks[@]}" | sort | cut -f2-
fi

# Print WAIT items after
if [[ ${#waits[@]} -gt 0 ]]; then
  printf '%s\n' "${waits[@]}"
fi

if [[ ${#tasks[@]} -eq 0 && ${#waits[@]} -eq 0 ]]; then
  echo "Nothing to do."
fi
