---
name: codebible-collect
description: Scrape PR review comments from target repos and propose new codebible rules via PR.
user-invocable: true
---

# codebible-collect

Collect coding feedback from closed PR review comments and propose new rules to the codebible.

## Input

None. Target repos are defined in `codebible/_last_collected.yaml`.

## Steps

1. Pull latest: `git -C agent-playbook pull origin main`
2. Run `bash agent-playbook/scripts/collect-comments.sh` — outputs comments from the oldest unprocessed merged PR.
3. For each comment, decide: does this teach a **reusable coding rule** (HOW to code)?
   - **Yes** → candidate. Continue to step 4.
   - **No** → skip. (Approvals, LGTMs, project-specific logic, questions — all skip.)
4. Check if this candidate is already covered:
   - Existing rules in `codebible/general/` and `codebible/{language}/` — skip if covered.
   - Open PRs on agent-playbook with `codebible:` title prefix — skip if already proposed.
   - If the candidate **improves** an existing rule (better example, clearer explanation) → treat as an update, not a duplicate.
5. For **each** uncovered candidate, write the rule to a temp file and run:
   `bash agent-playbook/scripts/propose-rule.sh <language> <filename> <rule-file> <source-url> <source-comment>`

   **Filename convention**: Use a specific, descriptive kebab-case filename (e.g., `use-full-words-for-variables.md`) that summarizes the rule. Do NOT use generic category names like `naming.md` or `naming-conventions.md`.
6. After processing all comments from this PR, update `codebible/_last_collected.yaml` with the PR's merged date.

## Scope per run

One PR per run, all rules from that PR. The script fetches the oldest unprocessed merged PR, so each run progresses through PRs chronologically.

## Rules

- Do NOT merge the PRs — only the user merges or closes.
- If you notice yourself repeating the same text or action, stop immediately and report failure.
