---
title: Limit Cyclomatic Complexity
impact: MEDIUM
impactDescription: Improve code readability and maintainability by limiting cyclomatic complexity
tags: complexity, maintainability, clean-code
---

## Limit Cyclomatic Complexity

Functions, methods, and constructors should not have cyclomatic complexity exceeding 10. High cyclomatic complexity indicates that the code has too many independent paths, making it harder to understand, test, and maintain. Use early returns or extract complex logic into sub-functions.

**Incorrect (high complexity):**

```dart
String getStatusDescription(int status, bool isUrgent, bool isAdmin) {
  if (status == 1) {
    if (isUrgent) return "Urgent Pending";
    return "Pending";
  } else if (status == 2) {
    if (isAdmin) return "Admin Approved";
    return "Approved";
  } else if (status == 3) {
    return "Rejected";
  } else {
    return "Unknown";
  }
}
```

**Correct (reduced complexity with Map or early returns):**

```dart
static const statusMap = {
  1: "Pending",
  2: "Approved",
  3: "Rejected",
};

String getStatusDescription(int status, bool isUrgent, bool isAdmin) {
  if (status == 1 && isUrgent) return "Urgent Pending";
  if (status == 2 && isAdmin) return "Admin Approved";
  return statusMap[status] ?? "Unknown";
}
```

**Tools:** Custom analyzer (D010)
