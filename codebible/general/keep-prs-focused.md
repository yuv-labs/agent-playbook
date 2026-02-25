## Keep PRs focused

A Pull Request should address a single issue or feature. Avoid bundling unrelated refactors, formatting changes, or fixes that are outside the scope of the PR's objective.

**Bad:**
A PR titled "fix: login bug" that also reformats the entire `User` class and upgrades dependencies.

**Good:**
A PR titled "fix: login bug" that only touches the login logic. Separate refactors into a "refactor: ..." PR.
