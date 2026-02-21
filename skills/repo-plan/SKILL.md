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
4. **Decide**: Is everything clear enough to make a plan?
   - **If unclear** → Post questions on the issue and stop. Do NOT post a plan yet.
   - **If clear** → Post a plan comment on the issue:

```
## Plan

**Problem**: [1-2 sentences]

**Approach**: [what you'll do]

**Files**: [list of files to change]

**Risks/questions**: [if any]
```

5. If a linked PR exists (re-plan after `agent:wip` → `agent:plan`), also post on the Issue: 
 - what went wrong with the current approach 
 - ask for clarification on what the new plan changes OR just post the new plan (if everything is clear).

## Rules

- Do NOT change any labels. Only the user changes labels.
- Do NOT write code or create branches.
- Do NOT create a PR.
- Ask first, plan second. Never assume when multiple valid approaches exist.
- Keep plan concise. No more than 20 lines.
