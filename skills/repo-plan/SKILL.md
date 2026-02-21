---
name: repo-plan
description: Analyze an issue and post a plan comment. Requires agent:plan label.
user-invocable: true
---

# repo-plan

Analyze an issue and discuss the approach. Post a plan as a comment on the issue (and linked PR if one exists).

## Input

Repo + issue number.

## Precondition

- Issue has `agent:plan` label.
- If not → stop, report "issue is not in agent:plan state".

## Steps

1. **Repo context check**: Do you have enough context about this repo's conventions and tooling? If not → report to user: "Need to run repo-scan first" and stop.
2. Read the issue description, all comments, and linked PR (if any).
3. Analyze the affected code — read relevant files.
4. Post a comment on the issue:

```
## Plan

**Problem**: [1-2 sentences]

**Approach**: [what you'll do]

**Files**: [list of files to change]

**Risks/questions**: [if any]
```

5. If a linked PR exists, post the same plan there too.

## Rules

- Do NOT change any labels. Only the user changes labels.
- Do NOT write code or create branches.
- Do NOT create a PR.
- If uncertain about the approach, say so in the plan and ask the user.
- Keep plan concise. No more than 20 lines.
