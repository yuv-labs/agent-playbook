# Agent Runbook

> Troubleshooting and recovery procedures. Load this file only when a failure
> or blocker is encountered.

---

## Guiding Principles

- **Never guess**: uncertain → `agent:needs-user`
- **Preserve state**: document before attempting recovery
- **Minimal intervention**: fix only what is broken
- **Max 3 retries**: then escalate

---

## Failure Quick Reference

| Symptom | First Action | If Fails |
|---------|--------------|----------|
| Test failed | Read error, fix code | Escalate after 3 tries |
| Lint/format failed | Run formatter | Check config, escalate |
| Type error | Fix types | Escalate if unclear |
| Build failed | Check syntax | Read full log, escalate |
| Merge conflict (simple) | Rebase | Escalate if complex |
| CI timeout | Check for loops | Escalate |
| Rate limit | Wait for reset | Resume next cycle |
| Permission denied | Escalate immediately | — |

---

## Test Failures

**Classify first**:

| Type | Description | Action |
|------|-------------|--------|
| Agent-caused | Agent's change broke test | Fix the code, not the test |
| Pre-existing | Already failing on main | Document in PR, skip |
| Flaky | Fails intermittently | Retry once, then document |
| Environment | Needs specific setup | Escalate |

**Agent-caused**: identify breaking change → fix → run locally → push.

**Pre-existing**: note in PR "test_xyz was already failing on main" → continue.

**Flaky**: retry CI once. If passes, note it. If fails again, escalate.

---

## CI / Build Failures

1. Read full log. Find **first** error (later errors often cascade).
2. Is error in agent's changed files?
   - Yes → fix syntax/import/logic, push.
   - No → infrastructure or pre-existing → escalate.

**Dependency conflicts**: if agent changed deps, try resolution. Otherwise
escalate — not agent's change to make.

**Infrastructure**: wait 5 min, retry. Still failing → `agent:blocked`.

---

## Merge Conflicts

**Simple** (formatting, adjacent lines): rebase, resolve, test, push.

**Complex** (overlapping logic): do NOT auto-resolve. Escalate with:
- List of conflicting files and areas
- Options for the user to choose from

---

## Lint / Format / Type Failures

1. Run project's lint and format commands locally.
2. Fix issues. Do NOT disable lint rules.
3. If rule is unclear or seems wrong → `agent:needs-user`.

---

## Timeout / Hanging

- Check which step timed out. Check for infinite loops in agent's code.
- Agent's code → fix. Infrastructure → `agent:blocked`. Unclear → escalate.

---

## Rate Limits / Permission Errors

- `agent:blocked` + note error and time.
- Rate limits: wait for reset, resume next cycle.
- Permissions: escalate immediately.

---

## Recovery Flow

```
FAILURE → Classify → Fixable?
                      ├─ Yes → Fix → Retry → Pass? → Continue
                      │                       └─ No (3x) → Escalate
                      ├─ Retryable → Wait → Retry → Pass? → Continue
                      │                              └─ No → Escalate
                      └─ Blocked → Escalate immediately
```

---

## Retry Policy

| Type | Max Retries | Wait Between |
|------|-------------|--------------|
| Agent fix | 3 | Immediate |
| CI flaky | 2 | 1 minute |
| Rate limit | 1 | Wait for reset |
| Infrastructure | 2 | 5 minutes |

---

## Escalation: `agent:needs-user`

Always include:

```markdown
**Blocked on**: [brief description]
**Error**: `[error message]`
**Tried**: [what was attempted]
**Need**: [specific question or decision needed]
```

For complex escalations, expand to:

```markdown
## Agent Needs Assistance

### Issue
[One-line description]

### Context
- **Doing**: [action]
- **Happened**: [failure]
- **Expected**: [expected outcome]

### What I Tried
1. [Attempt and result]
2. [Attempt and result]

### Options
1. [Option A]: [pros/cons]
2. [Option B]: [pros/cons]

### What I Need
[Specific question or decision]
```

---

## Rollback

- Do NOT force push or delete commits.
- Comment on PR: "Pausing pending investigation."
- Add `agent:blocked`. List what went wrong.
- Wait for human guidance.

---

## Post-Incident

- Document what happened and root cause.
- Note the fix that worked.
- If same failure occurs twice → update this runbook.
