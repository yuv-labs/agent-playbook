## Comments should explain "why", not "what"

Comments that merely restate what the code does are redundant and can drift out of sync with the implementation.
Instead, use comments to explain **why** a non-obvious approach was taken, or to document constraints and side effects.

**Bad:**

```typescript
// increment i by 1
i++;

// set the user active
user.active = true;
```

**Good:**

```typescript
// increment to skip the header row
i++;

// activate immediately to prevent race condition in subsequent login check
user.active = true;
```
