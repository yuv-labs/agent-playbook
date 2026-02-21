# Agent Playbook

Operational playbooks and skills for autonomous AI agents working on continuous and delicate tasks.

Each playbook is a self-contained guide that an agent reads and follows.
Clone this repo into the agent's workspace and point it to the relevant
playbook.

## Agent Behavior Principles

- **Don't repeat yourself**: If something failed, try a different approach or escalate. Never retry the same action.
- **Escalate fast**: Being stuck is worse than asking for help.
- **Don't guess tooling**: If you don't know the exact CLI flags, run `--help` first.

## Skills

See [`skills/README.md`](skills/README.md).

## Playbooks

| Playbook | Purpose |
|----------|---------|
| [`maintain-repo/`](maintain-repo/PLAYBOOK.md) | Maintain a repo by working on open GitHub issues. Periodic runs.|

## Usage

1. Clone this repo where your agent can access it.
2. Tell the agent to read `maintain-repo/PLAYBOOK.md` and follow it.
3. The playbook will guide the agent through the rest (which phase files to
   load, how to select issues, how to report).

### Example (OpenClaw via Discord)

```
Clone github.com/dbqls9713/agent-playbook (if not already cloned), then read
maintain-repo/PLAYBOOK.md and follow it to maintain
github.com/dbqls9713/valuation. Report results here.
```

## Structure

Each playbook follows a modular structure to minimize agent context usage:

```
[playbook-name]/
├── PLAYBOOK.md       ← Entry point (always loaded, small)
├── RUNBOOK.md        ← Failure/recovery (loaded on error)
├── phases/           ← Loaded per-phase, only when needed
├── templates/        ← Issue/PR body templates
└── examples/         ← Reference examples (first-time only)
```

The agent loads `PLAYBOOK.md` first, which tells it exactly which other
files to load depending on the current task.
