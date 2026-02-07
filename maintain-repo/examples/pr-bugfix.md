# Example PR: Bug Fix

> Reference example. Load from `examples/` only when creating your first few PRs.

---

## What

Fix ZeroDivisionError in discount calculation when quantity is zero.

## Why

Users editing their cart to zero quantity before checkout causes a crash.

Closes #42

## How

Added early return when quantity is zero, returning 0.0 as the discount.

### Changes Made

| File | Change Type | Description |
|------|-------------|-------------|
| `src/pricing/discount.py` | Modified | Add zero-quantity guard |
| `tests/test_discount.py` | Modified | Add zero-quantity test |

### Key Decisions

Chose to return 0.0 rather than raise a custom exception because:
- Zero quantity is a valid (if unusual) cart state
- Returning 0 maintains backward compatibility

---

## Small PR Checklist

- [x] **Single Purpose**: exactly one issue/feature
- [x] **Focused Changes**: no unrelated modifications
- [x] **Minimal Footprint**: only necessary files changed

| Metric | This PR | Guideline |
|--------|---------|-----------|
| Lines changed | 12 | ≤ 300 |
| Files changed | 2 | ≤ 15 |

---

## Testing

- [x] New tests added for new functionality
- [x] All tests pass locally

```bash
pytest tests/test_discount.py -v
pytest tests/ -v
```

```
tests/test_discount.py::test_zero_quantity_returns_zero PASSED
================================ 47 passed in 2.31s ================================
```

---

## Risks

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Different expected behavior | Low | Low | Documented in code comment |

- [x] No breaking changes

---

## Checklist

- [x] Code follows project style guide
- [x] No new linter warnings
- [x] Type hints added/updated
- [x] CI checks pass
- [x] No new dependencies

---

## Related

- Issue: #42

---

*PR created by Agent*
