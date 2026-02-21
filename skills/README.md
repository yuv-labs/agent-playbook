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
  repo-plan (plan 코멘트)     │ 유저: 재논의 필요
    │                         │
유저: agent:wip 부여          │
    │                         │
agent:wip ────────────────────┘
    │
  repo-execute (구현/PR/리뷰반영)
    │
유저: merge + agent:done 부여
    │
agent:done
```

All label changes are done by the user. The agent never modifies labels.
