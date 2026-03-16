---
title: Pubspec dependencies should be reviewed regularly
impact: MEDIUM
impactDescription: Ensure dependencies are kept up-to-date for security and stability
tags: maintenance, security, dependencies
---

## Pubspec dependencies should be reviewed regularly

Dependencies in `pubspec.yaml` should be reviewed and updated regularly (at least every 4 months). Outdated dependencies may contain security vulnerabilities or miss critical performance improvements.

**Incorrect (old lock file):**

```text
# pubspec.lock last modified: 6 months ago
```

**Correct (regularly updated):**

```text
# run 'flutter pub upgrade' and review dependencies regularly
```

**Tools:** Custom analyzer (D017)
