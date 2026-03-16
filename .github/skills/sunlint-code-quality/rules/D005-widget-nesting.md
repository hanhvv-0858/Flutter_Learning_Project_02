---
title: Limit Widget Nesting Depth to 6
impact: LOW
impactDescription: Maintain code readability and prevent performance issues caused by deeply nested widgets
tags: readability, maintainability, performance, nesting
---

## Limit Widget Nesting Depth to 6

Widget nesting should not exceed 6 levels in the build method. Deeply nested widgets make code harder to understand, maintain, and can impact performance. When nesting exceeds this limit, extract nested widgets into separate StatelessWidget or StatefulWidget classes.

**Incorrect (deeply nested):**

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Center(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text("Too deep!"), // Level 11
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
```

**Correct (extracted widget):**

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Center(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: const MyCustomHeader(), // Extracted at level 4
      ),
    ),
  );
}
```

**Tools:** Custom analyzer (D005)
