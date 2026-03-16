---
title: Recommended Lint Rules Should Be Enabled
impact: MEDIUM
impactDescription: Ensure code quality through standard lint configurations
tags: lint, quality, static-analysis
---

## Recommended Lint Rules Should Be Enabled

The `analysis_options.yaml` file should include recommended lint packages (flutter_lints, very_good_analysis, or lints) and critical lint rules should not be disabled. This ensures consistent code quality standards across the project.

**Incorrect (minimal components):**

```yaml
analyzer:
  exclude:
    - build/**
```

**Correct (recommended setup):**

```yaml
include: package:flutter_lints/flutter.yaml

analyzer:
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"

linter:
  rules:
    - avoid_print
    - prefer_const_constructors
```

**Tools:** Custom analyzer (D001)
