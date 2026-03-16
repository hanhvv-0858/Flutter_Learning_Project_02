---
title: Prefer Widgets Over Methods Returning Widgets
impact: LOW
impactDescription: Improve performance and maintainability by extracting widget-returning methods into widget classes
tags: performance, maintainability, widgets, extraction
---

## Prefer Widgets Over Methods Returning Widgets

Methods that return widgets should be extracted into separate StatelessWidget or StatefulWidget classes. This improves performance as Flutter can optimize widget rebuilds, makes code more reusable, and follows Flutter best practices. Only the build() method and lifecycle methods are exempt from this rule.

**Incorrect (method returning widget):**

```dart
Widget _buildHeader() {
  return Text("Title", style: TextStyle(fontSize: 24));
}

@override
Widget build(BuildContext context) {
  return Column(
    children: [
      _buildHeader(),
      Text("Content"),
    ],
  );
}
```

**Correct (extracted widget class):**

```dart
class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Text("Title", style: TextStyle(fontSize: 24));
  }
}

@override
Widget build(BuildContext context) {
  return Column(
    children: [
      const HeaderWidget(),
      Text("Content"),
    ],
  );
}
```

**Tools:** Custom analyzer (D003)
