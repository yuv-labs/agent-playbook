# Skills

Small, focused tasks. Each skill has a clear precondition and output.

| Skill | Precondition | Does |
|-------|-------------|------|
| `repo-scan` | None | Read repo docs/conventions, report to user |
| `repo-plan` | `agent:plan` label | Analyze issue, post plan comment |
| `repo-execute` | `agent:wip` label + user acted last | Implement plan or address PR feedback |

## Labels (user-managed only)

```
agent:plan ◄──────────────────┐
    │                         │
  repo-plan (plan comment)    │ user: need to re-discuss
    |                         │
user: apply agent:wip         │
    ↓                         │
agent:wip ────────────────────┘
    |
  repo-execute (implement/PR/review feedback)
    |
user: merge + apply agent:done
    ↓
agent:done
```

All label changes are done by the user. The agent never modifies labels.

## Automation Roadmap

Currently all skills are triggered manually via Discord. Build trust over ~10 issues first, then consider:

- **GitHub webhook**: Label change or user comment triggers skill via webhook → middleware (e.g. Cloudflare Worker) → OpenClaw.
- **Periodic polling**: OpenClaw periodically fetches issue/PR changes and runs matching skills on its own.
