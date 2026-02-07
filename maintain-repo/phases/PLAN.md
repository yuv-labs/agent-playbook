# Phase: Plan

> Design the implementation approach for the selected issue.

---

## Preconditions

- [ ] Issue has `agent:ready` label OR agent is assigned
- [ ] Issue scope is clear (ask if not)
- [ ] No blocking dependencies

---

## Planning Checklist

- [ ] **Understand the problem**
  - [ ] Read issue description and all comments
  - [ ] Identify acceptance criteria (DoD)

- [ ] **Analyze affected code**
  - [ ] Identify files to modify
  - [ ] Understand dependencies and side effects
  - [ ] Check existing tests for affected areas

- [ ] **Design solution**
  - [ ] Outline approach in issue comment
  - [ ] List files to create/modify/delete
  - [ ] Identify new tests needed
  - [ ] Estimate change size (lines, files)

- [ ] **Validate scope**
  - [ ] Fits within 300-line guideline?
  - [ ] Single purpose?
  - [ ] If not → note in plan, explain rationale for larger PR

---

## Planning Comment

Post on the issue before starting implementation:

```markdown
## Implementation Plan

### Approach
[Brief description of the solution approach]

### Changes
| File | Action | Description |
|------|--------|-------------|
| `path/to/file.py` | Modify | [What changes] |
| `path/to/new.py` | Create | [Purpose] |
| `tests/test_file.py` | Modify | [New test cases] |

### Estimated Size
- Lines changed: ~[N]
- Files affected: [N]

### Risks
- [Potential risk and mitigation]
```

Then proceed to Execute.
