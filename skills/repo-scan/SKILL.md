---
name: repo-scan
description: Read a repo's docs and conventions. Run this when you lack context about a repo.
user-invocable: true
---

# repo-scan

Read the target repo and report its conventions. No code changes. No label changes.

## Input

Repo name or path.

## Steps

1. Read `README.md` of the target repo — purpose, setup, dev commands
2. Read package manifest (`package.json`, `pyproject.toml`, `go.mod`, etc.) — deps, scripts
3. Read linter/formatter config (biome.json, .eslintrc, pyproject.toml, etc.) — verify exact CLI flags
4. Read CI config (`.github/workflows/`, etc.) — required checks
5. Skim recent commits (`git log --oneline -10`) — infer conventions

## Output

Report to user:

```
[repo-name] scan 결과
- Language/framework: ...
- Build: [command]
- Test: [command]
- Lint: [command]
- Format: [command]
- CI checks: ...
- Conventions: [branch pattern, commit format, etc.]
```

## Rules

- Do NOT modify any files or labels.
- If a command or tool version is unclear, run `--help` or `--version` to confirm — do not guess.
