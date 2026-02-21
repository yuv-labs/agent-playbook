---
name: repo-execute
description: Implement a plan or address PR feedback. Requires agent:wip label and user's last action.
user-invocable: true
---

# repo-execute

Implement the agreed plan, create/update a PR, or address review feedback.

## Input

Repo + issue number.

## Precondition

ALL of these must be true:

1. Issue has `agent:wip` label.
2. The last action on the issue/PR was by the user — check via:
   - `gh api repos/{owner}/{repo}/issues/{issue_number}/events` → latest `labeled` event actor
   - `gh api repos/{owner}/{repo}/issues/{issue_number}/comments` → latest comment author
   - If a linked PR exists, also check PR review comments
   - At least one of these must show the user as the most recent actor (more recent than any agent action).
3. A plan comment exists on the issue (posted by repo-plan).

If any condition fails → stop, report which condition failed.

## Steps

### Case A: No PR yet (first execution)

1. Repo context check: do you know the build/test/lint commands? If not → report "Need repo-scan" and stop.
2. Create branch: `agent/{issue-number}-{brief-description}`
3. Implement changes per the plan.
4. Run test, lint, build — fix issues. If stuck after 1 retry → stop, report failure.
5. Commit: `[type] description (#issue-number)`
6. Push and create PR linking the issue (`Closes #N`).
7. Post a summary comment on the issue.

### Case B: PR exists with review feedback

1. Read all unaddressed review comments on the PR.
2. Implement requested changes.
3. Run test, lint, build.
4. Push fixup commits.
5. Reply to each review comment **on the PR itself** (not Discord/Slack) with what was done.

## Rules

- Do NOT change any labels. Only the user changes labels.
- Do NOT merge the PR.
- If a command fails, try ONE alternative. If that also fails → stop and report.
- Max 300 lines changed, 15 files per PR. If exceeding, stop and report.
- Follow the repo's conventions (branch pattern, commit format, linter config). If unknown, stop and request repo-scan.
