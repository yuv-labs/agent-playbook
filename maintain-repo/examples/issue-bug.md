# Example Issue: Bug Report

> Reference example. Load from `examples/` only when writing your first few issues.

---

## Summary

The `calculate_discount()` function in the pricing module raises a
`ZeroDivisionError` when the product quantity is zero, causing the
checkout process to crash.

---

## Observation

### What Was Observed

Exception raised during checkout when cart contains an item with
quantity = 0 (edge case from cart editing).

### Where

| Location | Description |
|----------|-------------|
| File(s) | `src/pricing/discount.py` |
| Function/Class | `calculate_discount()` |
| Line(s) | L45 |

### When/How Discovered

CI test failure in `test_checkout_edge_cases` on main branch.

---

## Reproduction

### Steps

1. Add item to cart
2. Edit cart, set quantity to 0 (instead of removing)
3. Proceed to checkout

### Commands

```bash
pytest tests/test_checkout.py::test_checkout_edge_cases -v
```

### Environment

- **Branch**: `main`
- **Commit**: `a1b2c3d`

---

## Expected vs Actual

- **Expected**: Handle zero quantity gracefully (return 0 or skip item)
- **Actual**: `ZeroDivisionError: division by zero`

---

## Evidence

```
ZeroDivisionError: division by zero
  File "src/pricing/discount.py", line 45, in calculate_discount
    unit_discount = total_discount / quantity
```

---

## Impact Assessment

**Severity**: High — checkout crashes
**Scope**: Isolated — single function

---

## Analysis

### Root Cause (Suspected)

Missing guard clause for zero quantity before division.

### Related Issues/PRs

None.

---

## Proposed Solution

### Approach

Add `if quantity == 0: return 0.0` before division.

### Alternatives

| Approach | Pros | Cons |
|----------|------|------|
| Guard clause | Simple, safe | — |
| Custom exception | More explicit | Callers must handle |

### Risks

- Low: behavior change for zero-quantity edge case only.

---

## Definition of Done

- [ ] Zero quantity no longer raises exception
- [ ] Returns 0.0 for zero quantity
- [ ] Test case added
- [ ] All existing tests pass

---

## Labels

- `agent:triage`
- `bug`
- `P1`
- `pricing`

---

*Issue created by Agent*
