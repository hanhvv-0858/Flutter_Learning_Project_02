---
title: Prefer Extracting Large Callbacks from Build
impact: LOW
impactDescription: Improve code readability and testability by extracting large callback functions
tags: readability, maintainability, testability, callback
---

## Prefer Extracting Large Callbacks from Build

Callback functions (onTap, onPressed, onChanged, etc.) in widget builders should not exceed 5 lines. Large inline callbacks make the build method harder to read and maintain. Extract callbacks that exceed this limit to separate methods or functions.

**Incorrect (large inline callback):**

```dart
@override
Widget build(BuildContext context) {
  return ElevatedButton(
    onPressed: () {
      final data = _formKey.currentState?.value;
      if (data != null && data.isNotEmpty) {
        _logger.info('Submitting data: $data');
        _repository.save(data).then((_) {
          Navigator.pop(context);
        });
      }
    },
    child: Text('Submit'),
  );
}
```

**Correct (extracted callback method):**

```dart
void _handleSubmit() {
  final data = _formKey.currentState?.value;
  if (data != null && data.isNotEmpty) {
    _logger.info('Submitting data: $data');
    _repository.save(data).then((_) {
      Navigator.pop(context);
    });
  }
}

@override
Widget build(BuildContext context) {
  return ElevatedButton(
    onPressed: _handleSubmit,
    child: Text('Submit'),
  );
}
```

**Tools:** Custom analyzer (D006)
