# Phase: Scan

> Understand the repo and select the issue to work on.

---

## Step 1: Read Repo

Read the repository's documentation to understand conventions:

1. `README.md` → purpose, install commands
2. `CONTRIBUTING.md` → contribution guidelines (if exists)
3. Package manifest (`pyproject.toml`, `package.json`, `go.mod`, etc.)
4. CI config → test/lint/build commands, required checks
5. `.github/CODEOWNERS` → ownership rules (if exists)
6. Existing PRs/commits → infer conventions in use

Record for this run:

```yaml
commands:
  test: [e.g., "pytest"]
  lint: [e.g., "pylint src/"]
  format: [e.g., "yapf -i -r ."]

conventions:
  branch_pattern: [e.g., "agent/{issue}-{desc}"]
  commit_format: [e.g., "[type] description (#issue)"]
```

---

## Step 2: Check Open Issues

List all open issues in the target repo. Focus on:

- Issues assigned to the agent
- Issues labeled `agent:ready`
- Issues with open PRs that have review feedback
- Issues labeled `agent:in-progress`, `agent:blocked`, `agent:needs-user`

---

## Step 3: Select Issue

Pick **1 issue** to work on:

```
1. Filter: only issues the agent is allowed to act on
   - assigned to agent, OR
   - labeled agent:ready, OR
   - has open PR with pending review feedback

2. Sort by: updated_at ascending (oldest first)

3. Pick the first one.

4. If no actionable issue exists → report "nothing to do" and end run.
```

---

## Step 4: Assess State

Determine what action is needed for the selected issue:

| State | Indicators | Next Phase |
|-------|-----------|------------|
| **Ready to implement** | `agent:ready` or assigned, no PR exists | → PLAN |
| **PR needs fixup** | Open PR with unaddressed review comments | → REVIEW |
| **Blocked** | `agent:blocked` or `agent:needs-user` | → Report and end |
| **Already in progress** | `agent:in-progress`, PR open, no feedback | → Check CI status, continue or wait |

---

## Output

After scanning, the agent should know:
- Target issue (number, title, state)
- What action to take next (plan, fixup, skip)
- Repo conventions (test/lint/format commands, branch pattern)
