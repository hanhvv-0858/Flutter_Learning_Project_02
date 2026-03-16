---
title: Function Names Verb-Noun
impact: LOW
impactDescription: makes code self-documenting
tags: naming, functions, readability, conventions, quality
---

## Function Names Verb-Noun

Functions do things. Action verbs make purpose clear.

**Incorrect (vague names):**

```dart
User user() { }           // Noun only
void userData() { }       // Noun only
void doSomething() { }    // Vague
void handleStuff() { }    // Vague
void manager() { }        // Noun only
```

**Correct (action verbs):**

```dart
Future<User> getUser() async { }
void createUserAccount() { }
bool validateEmailFormat(String email) { }
double calculateTotalPrice(List<Item> items) { }
Future<void> sendConfirmationEmail(String email) async { }
String convertCurrencyToVnd(double amount) { }
```

**Verb categories:**

| Category | Verbs |
|----------|-------|
| Retrieval | `get`, `fetch`, `find`, `load`, `query` |
| Creation | `create`, `build`, `make`, `generate` |
| Modification | `set`, `update`, `modify`, `change` |
| Deletion | `delete`, `remove`, `destroy`, `clear` |
| Validation | `validate`, `verify`, `check`, `ensure` |
| Computation | `calculate`, `compute`, `parse`, `format` |
| Boolean | `is`, `has`, `can`, `should`, `will` |

**Tools:** PR review, dart_analyzer
