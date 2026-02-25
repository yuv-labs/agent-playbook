#!/bin/bash
# collect-comments.sh - Fetch PR review comments from target repos.
# Usage: collect-comments.sh [config-path]
#
# Reads repos from codebible/_last_collected.yaml (or provided path).
# Fetches comments from the OLDEST unprocessed merged PR (one PR per run).
# Outputs JSON to stdout: one object per comment with context.
#
# Output format (one JSON object per line):
#   { "repo": "owner/repo", "pr_number": 33, "pr_title": "...",
#     "author": "reviewer", "body": "comment text",
#     "path": "src/file.ts", "line": 42,
#     "created_at": "2026-02-25T...", "url": "https://..." }

set -euo pipefail

CONFIG="${1:-agent-playbook/codebible/_last_collected.yaml}"

# Parse repos and their last-collected dates from YAML.
# Output: "owner/repo<tab>date-or-null" per line.
parse_repos() {
  # Simple YAML parsing — handles "  owner/repo: date" or "  owner/repo: null"
  grep -E '^\s+\S+/\S+:' "$CONFIG" | while IFS=: read -r repo date; do
    repo=$(echo "$repo" | xargs)
    date=$(echo "$date" | xargs | sed 's/#.*//' | xargs)
    [[ "$date" == "null" || -z "$date" ]] && date=""
    echo -e "$repo\t$date"
  done
}

# Default: 30 days ago
default_since() {
  if [[ "$(uname)" == "Darwin" ]]; then
    date -v-30d -u +"%Y-%m-%dT%H:%M:%SZ"
  else
    date -u -d "30 days ago" +"%Y-%m-%dT%H:%M:%SZ"
  fi
}

while IFS=$'\t' read -r repo since; do
  [[ -z "$repo" ]] && continue

  if [[ -z "$since" ]]; then
    since=$(default_since)
  else
    since="${since}T00:00:00Z"
  fi

  # Fetch oldest unprocessed merged PR (one PR per run)
  pr=$(gh api "repos/$repo/pulls?state=closed&sort=updated&direction=asc&per_page=100" \
    --jq "[.[] | select(.merged_at != null and .merged_at >= \"$since\")] | .[0].number" 2>/dev/null || true)

  [[ -z "$pr" || "$pr" == "null" ]] && continue

  pr_title=$(gh api "repos/$repo/pulls/$pr" --jq '.title' 2>/dev/null || true)

  # Review comments (inline code comments)
  gh api "repos/$repo/pulls/$pr/comments" --paginate \
    --jq ".[] | select(.created_at >= \"$since\" and .user.type != \"Bot\") |
      {repo: \"$repo\", pr_number: $pr, pr_title: \"$pr_title\",
       author: .user.login, body: .body,
       path: .path, line: (.original_line // .line),
       created_at: .created_at, url: .html_url}" 2>/dev/null || true

  # Review bodies (top-level review comments, not just approvals)
  gh api "repos/$repo/pulls/$pr/reviews" --paginate \
    --jq ".[] | select(.state != \"APPROVED\" and .state != \"DISMISSED\"
      and .body != \"\" and .body != null
      and .submitted_at >= \"$since\" and .user.type != \"Bot\") |
      {repo: \"$repo\", pr_number: $pr, pr_title: \"$pr_title\",
       author: .user.login, body: .body,
       path: null, line: null,
       created_at: .submitted_at, url: .html_url}" 2>/dev/null || true
done <<< "$(parse_repos)"
