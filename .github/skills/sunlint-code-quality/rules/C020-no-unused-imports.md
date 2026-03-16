---
title: Do Not Import Unused Modules
impact: LOW
impactDescription: reduces app size and improves clarity
tags: imports, cleanup, bundle-size, quality
---

## Do Not Import Unused Modules

Unused imports add noise and may increase app size.

**Incorrect (unused imports):**

```dart
import 'package:app/models/user.dart';
import 'package:app/models/order.dart'; // Never used
import 'package:app/utils/date_utils.dart'; // Never used
import 'package:intl/intl.dart'; // Never used

// Only User is actually used
User getUser(String id) {
  return userRepository.findById(id);
}
```

**Correct (only needed imports):**

```dart
import 'package:app/models/user.dart';

User getUser(String id) {
  return userRepository.findById(id);
}
```

**Enable via analysis_options.yaml:**

```yaml
# analysis_options.yaml
linter:
  rules:
    - unused_import
    - avoid_unused_constructor_parameters
```

**Tools:** dart analyze, IDE auto-organize imports (Cmd/Ctrl+Shift+O)
