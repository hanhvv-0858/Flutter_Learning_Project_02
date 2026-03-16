---
title: No Business Logic In Constructors
impact: HIGH
impactDescription: ensures predictable object initialization
tags: constructor, initialization, side-effects, patterns, quality
---

## No Business Logic In Constructors

Constructors should only initialize state. Side effects in constructors are unexpected and make testing difficult.

**Incorrect (logic in constructor):**

```dart
class UserRepository {
  UserRepository(String configPath) {
    // BAD: File I/O in constructor
    final file = File(configPath).readAsStringSync();
    final config = jsonDecode(file) as Map<String, dynamic>;

    // BAD: Network call in constructor
    _client = HttpClient()..open('GET', config['apiUrl'] as String, 80, '/init');

    // BAD: Mutation side-effects
    _cache.clear();

    // BAD: Logging with side effects
    print('UserRepository initialized');
  }
}
```

**Correct (factory method for async / complex init):**

```dart
class UserRepository {
  UserRepository({
    required HttpClient client,
    required AppConfig config,
  }) : _client = client,    // Only assignments
       _config = config;

  final HttpClient _client;
  final AppConfig _config;

  // Factory method for complex initialization
  static Future<UserRepository> create(String configPath) async {
    final file = await File(configPath).readAsString();
    final config = AppConfig.fromJson(jsonDecode(file) as Map<String, dynamic>);

    final client = HttpClient();
    await client.initialize(config.apiUrl);

    return UserRepository(client: client, config: config);
  }
}

// Usage
final repo = await UserRepository.create('./config.json');
```

**Tools:** Code Review, dart_analyzer
