# Phase: Execute

> Implement the planned solution, commit, and create a PR.

---

## Preconditions

- [ ] Issue has `agent:ready` label OR agent is assigned
- [ ] Implementation plan is posted on the issue
- [ ] No unresolved questions

---

## Step 1: Prepare

- [ ] Create feature branch: `agent/{issue-number}-{brief-description}`
- [ ] Update label: `agent:in-progress`

## Step 2: Implement

- [ ] Make code changes following the plan
- [ ] Follow project coding conventions (from Scan phase)
- [ ] Write/update tests for changed code
- [ ] Run test suite locally
- [ ] Run lint/format tools
- [ ] Fix any issues before committing

## Step 3: Commit

Format (adapt to project conventions if different):

```
[type] Brief description (#issue-number)

- Detailed change 1
- Detailed change 2

Rationale: [Why this approach was chosen]
```

Types: `fix`, `feat`, `refactor`, `test`, `docs`, `chore`

## Step 4: Create PR

- [ ] Push branch to remote
- [ ] Create PR using `templates/PR.md`
- [ ] Link issue with closing keyword: `Closes #N`
- [ ] Request review from appropriate owners
- [ ] Update label: `agent:review`

---

## CI Failure Handling

If CI fails after PR creation:

1. **Read** CI logs fully. Identify root cause.

2. **Categorize and act**:

   | Category | Action |
   |----------|--------|
   | Agent's code caused failure | Fix immediately, push |
   | Pre-existing flaky test | Document in PR, may ignore |
   | Environment/infra issue | `agent:blocked`, comment |
   | Unclear cause | `agent:needs-user`, request help |

3. **Retry policy**: max 3 attempts. After 3 failures → `agent:needs-user`.

---

## Execution Constraints

| Constraint | Value |
|------------|-------|
| Max CI retry | 3 |
| Max files per PR | 15 |
| Max lines per PR | 300 (soft, rationale if exceeded) |
