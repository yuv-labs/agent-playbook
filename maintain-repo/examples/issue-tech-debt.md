# Example Issue: Tech Debt

> Reference example. Load from `examples/` only when writing your first few issues.

---

## Summary

The `UserService` class has grown to 800+ lines with multiple responsibilities
(authentication, profile management, notifications), violating single
responsibility principle and making the code difficult to test and maintain.

---

## Observation

### What Was Observed

Single class handling authentication, user profiles, and notification
preferences. High cyclomatic complexity, low test coverage (42%).

### Where

| Location | Description |
|----------|-------------|
| File(s) | `src/services/user_service.py` |
| Function/Class | `UserService` |
| Line(s) | L1-L847 |

### When/How Discovered

Code analysis during related bug fix review.

---

## Impact Assessment

**Severity**: Medium — functional but hard to maintain
**Scope**: Module — one service class

---

## Analysis

### Root Cause (Suspected)

Organic growth without periodic refactoring.

---

## Proposed Solution

### Approach

Extract into three focused services: `AuthService`, `ProfileService`,
`NotificationService`.

### Alternatives

| Approach | Pros | Cons |
|----------|------|------|
| Extract classes | Clear separation | Multiple PRs |
| Extract methods only | Smaller change | Still one large class |

---

## Definition of Done

- [ ] Each new service < 300 lines
- [ ] Single responsibility per service
- [ ] Test coverage > 80% per service
- [ ] No breaking changes to API
- [ ] All existing tests pass

---

## Decomposition

- [ ] **Subtask 1**: Extract `AuthService`
- [ ] **Subtask 2**: Extract `NotificationService`
- [ ] **Subtask 3**: Rename remaining to `ProfileService`

Order: AuthService (most isolated) → NotificationService → ProfileService

---

## Labels

- `agent:triage`
- `tech-debt`
- `P3`
- `services`

---

*Issue created by Agent*
