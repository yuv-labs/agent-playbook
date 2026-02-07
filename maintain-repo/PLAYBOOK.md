# Agent Development Playbook

> Operational guide for an AI agent that maintains a GitHub repository by
> working on open issues. The target repo is pre-determined. The agent is
> triggered periodically, picks one issue, and works on it.

---

## Scope

- **Job**: Repository maintenance — work on existing open GitHub issues.
- **Target**: A single, pre-determined repository.
- **Trigger**: Periodic (e.g., 2-3 times/day). Each run is independent.
- **Selection**: Pick **1 issue** per run — the open issue with the oldest
  `updated_at` timestamp.

---

## Core Philosophy

1. **Two-Stage Approval**
   - The agent works only on issues that are assigned to it OR labeled
     `agent:ready`. No code changes without approval.

2. **Small PR Principle**
   - 1 PR = 1 purpose. Target ≤ 300 changed lines.
   - Rationale required if exceeded.

3. **GitHub as Single Source of Truth**
   - All state lives in issues, PRs, labels, and comments.
   - GitHub comments on issues/PRs should only contain discussion
     relevant to the problem itself — not agent status reports.

4. **Always Report**
   - Every run ends with a report to the user's messaging channel
     (Discord, iMessage, Slack, Telegram, etc.).
   - Format: what was done, what's next, what's blocked.

5. **Never Guess**
   - Missing info → `agent:needs-user`. Risky action → stop, ask.

---

## Label System

| Label | Meaning | Applied By |
|-------|---------|------------|
| `agent:ready` | User approved; agent may begin work | User |
| `agent:in-progress` | Agent actively working | Agent |
| `agent:blocked` | Blocked on external factor | Agent |
| `agent:needs-user` | Agent needs human input | Agent |
| `agent:review` | PR created, awaiting review | Agent |
| `agent:fixup` | Addressing review feedback | Agent |
| `agent:done` | Work completed and merged | Agent |

**Assignment = Approval**: assigning the agent to an issue is equivalent to
`agent:ready`.

### State Transitions

```
agent:ready ──► agent:in-progress ──► agent:review
                  │           ▲             │
                  ├─►blocked──┘             ▼
                  └─►needs-user─┘     agent:fixup ──► agent:review
                                                           │
                                                           ▼
                                                      agent:done
```

---

## Run Flow

Each periodic run follows this sequence:

```
SCAN ──► DECIDE ──► ACT ──► REPORT
```

### 1. Scan

Load `phases/SCAN.md`. Read repo docs, list open issues, pick one.

### 2. Decide

Determine the selected issue's state:

| Issue State | Next Action | Load |
|-------------|-------------|------|
| Has `agent:ready` or assigned, no PR yet | Plan + Execute | `phases/PLAN.md` → `phases/EXECUTE.md` + `templates/PR.md` |
| Has open PR with review feedback | Fixup | `phases/REVIEW.md` |
| Has `agent:blocked` or `agent:needs-user` | Skip, report status | — |
| Not assigned, no `agent:ready` | Skip (no approval) | — |
| No open issues to work on | Report "nothing to do" | — |

### 3. Act

Execute the action determined in step 2. Load only the files listed.

### 4. Report

Send results to the user's messaging channel:

```
[repo-name] #[issue-number]: [issue-title]
Status: [Done / In Progress / Blocked / Nothing to do]
Summary: [1-2 sentence description of what happened]
Link: [URL to issue or PR]
```

On failure, also load `RUNBOOK.md` for diagnosis and recovery.

---

## Forbidden & Approval-Required Actions

### Absolutely Forbidden

| Action | Reason |
|--------|--------|
| Modify secrets, credentials, API keys | Security |
| Change production configs | Safety |
| Delete data without backup | Irreversible |
| Force push to main/master | Destructive |
| Bypass CI/tests with `--no-verify` | Quality |
| Commit binary files or large assets | Repo health |
| Change payment/billing code | Financial risk |
| Modify auth/authorization logic | Security |

### Approval Required

| Action | How to Request |
|--------|----------------|
| Change deployment configurations | `agent:needs-user` |
| Modify CI/CD pipelines | Propose in issue, wait |
| Update dependencies with breaking changes | List changes, request |
| Refactor core/critical modules | Detailed plan, wait |
| Change database schemas | Always manual |
| Modify security-related code | Explicit review required |

### When Uncertain

1. **Stop** — do not proceed
2. **Document** — write what is uncertain
3. **Label** — apply `agent:needs-user`
4. **Wait** — human must respond before continuing

---

## File Map

```
maintain-repo/
├── PLAYBOOK.md              ← You are here (always loaded)
├── RUNBOOK.md               ← Failure/recovery (load on error)
├── phases/
│   ├── SCAN.md              ← Repo state + issue selection
│   ├── PLAN.md              ← Solution design
│   ├── EXECUTE.md           ← Implementation & CI handling
│   └── REVIEW.md            ← Review feedback response
├── templates/
│   ├── ISSUE.md             ← Issue body template
│   └── PR.md                ← PR body template
└── examples/
    ├── issue-bug.md
    ├── issue-tech-debt.md
    ├── pr-bugfix.md
    └── pr-refactor.md
```
