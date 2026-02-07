# Example PR: Refactoring (Exceeding Size Limit With Rationale)

> Reference example. Load from `examples/` only when creating your first few PRs.

---

## What

Extract AuthService from UserService to improve separation of concerns.

## Why

UserService had grown to 800+ lines handling multiple responsibilities.
This is part 1 of 3 to refactor into focused services.

Closes #87

## How

Extracted all authentication-related methods into new `AuthService` class.
Updated all imports and usages throughout the codebase.

### Changes Made

| File | Change Type | Description |
|------|-------------|-------------|
| `src/services/auth_service.py` | Added | New AuthService class |
| `src/services/user_service.py` | Modified | Remove auth methods |
| `src/api/auth_routes.py` | Modified | Use AuthService |
| `src/api/user_routes.py` | Modified | Update imports |
| `tests/services/test_auth_service.py` | Added | AuthService tests |
| `tests/services/test_user_service.py` | Modified | Remove auth tests |
| `tests/api/test_auth_routes.py` | Modified | Mock AuthService |

### Key Decisions

- Kept method signatures identical for backward compatibility
- AuthService is injected where needed (dependency injection)
- Shared utilities remain in base class

---

## Small PR Checklist

- [x] **Single Purpose**: exactly one issue/feature
- [x] **Focused Changes**: no unrelated modifications
- [x] **Minimal Footprint**: only necessary files changed

| Metric | This PR | Guideline |
|--------|---------|-----------|
| Lines changed | 420 | ≤ 300 |
| Files changed | 7 | ≤ 15 |

**Rationale for exceeding limits:**
> Atomic refactoring: extracting a complete service. Splitting would leave
> the codebase in an inconsistent state where AuthService methods exist in
> two places. Line count is high due to moving ~200 lines to new file,
> updating imports, and comprehensive tests.

---

## Testing

- [x] New tests added for new functionality
- [x] Existing tests updated for changed behavior
- [x] All tests pass locally

```bash
pytest tests/services/ -v
pytest tests/api/ -v
pytest tests/ -v
```

```
================================ 127 passed in 8.42s ================================
```

---

## Risks

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Missed import update | Low | Medium | Full test suite run |
| Circular dependency | Low | High | Careful module structure |

Rollback: revert entire PR. No database or config changes.

- [x] No breaking changes

---

## Checklist

- [x] Code follows project style guide
- [x] No new linter warnings
- [x] Type hints added/updated
- [x] CI checks pass
- [x] No new dependencies
- [x] README updated (architecture section)

---

## Related

- Issue: #87
- Part of: #85 (parent refactoring issue)
- Next: #88 (NotificationService extraction)

---

*PR created by Agent*
