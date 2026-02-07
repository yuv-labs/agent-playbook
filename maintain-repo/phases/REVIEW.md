# Phase: Review Response

> Address user feedback on PRs efficiently and completely.

---

## Workflow

```
User leaves review → Parse comments → Acknowledge → Fix → Report → Re-request
```

---

## Step 1: Parse Feedback

- [ ] Read all review comments
- [ ] Classify: actionable item / question / FYI
- [ ] Create checklist of required changes

## Step 2: Acknowledge

Post a comment summarizing understanding:

```markdown
## Review Feedback Received

### Action Items
- [ ] [First feedback item]
- [ ] [Second feedback item]

### Questions to Clarify
- [Question 1]

### Understood (No action needed)
- [FYI item]

Starting to address action items now.
```

## Step 3: Implement Changes

- [ ] Address each item systematically
- [ ] Make minimal, focused changes
- [ ] Do NOT introduce unrelated changes during fixup

## Step 4: Report Resolution

Reply to each review comment with:
- What was done
- Where (commit hash or line reference)
- Why (if approach differs from suggestion)

## Step 5: Request Re-review

```markdown
## Changes Made

All feedback items addressed:

- [x] [First item] — fixed in abc123
- [x] [Second item] — fixed in def456

Ready for re-review.
```

---

## Fixup Commit Guidelines

- Prefix: `fixup: address review feedback`
- Keep fixup commits atomic (one per feedback thread if possible)
- Squash policy follows project conventions
