---
title: Do Not Hardcode Configuration
impact: HIGH
impactDescription: enables environment-specific deployments
tags: configuration, environment, deployment, quality
---

## Do Not Hardcode Configuration

Hardcoded config requires code changes to deploy to different environments.

**Incorrect (hardcoded config):**

```dart
const apiUrl = 'https://api.production.example.com';
const timeout = 5000;
const maxFileSize = 10485760;
const enableAnalytics = true;
```

**Correct (externalized config via dart-define):**

```dart
// lib/config/app_config.dart
class AppConfig {
  AppConfig._();

  static const String apiUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'https://api.dev.example.com',
  );

  static const int timeoutMs = int.fromEnvironment(
    'TIMEOUT_MS',
    defaultValue: 5000,
  );

  static const int maxFileSizeBytes = int.fromEnvironment(
    'MAX_FILE_SIZE',
    defaultValue: 10 * 1024 * 1024, // 10MB
  );

  static const bool enableAnalytics = bool.fromEnvironment(
    'ENABLE_ANALYTICS',
    defaultValue: false,
  );
}

// Usage
final client = HttpClient(baseUrl: AppConfig.apiUrl, timeout: Duration(milliseconds: AppConfig.timeoutMs));
```

**Build with environment config:**

```bash
# Development
flutter run --dart-define=API_URL=https://api.dev.example.com --dart-define=ENABLE_ANALYTICS=false

# Production
flutter build apk --dart-define=API_URL=https://api.production.example.com --dart-define=ENABLE_ANALYTICS=true

# Using a JSON config file (flutter_launcher_icons approach)
flutter run --dart-define-from-file=config/dev.json
flutter build apk --dart-define-from-file=config/prod.json
```

**Example config files:**

```json
// config/dev.json
{
  "API_URL": "https://api.dev.example.com",
  "ENABLE_ANALYTICS": "false",
  "TIMEOUT_MS": "10000"
}
```

```json
// config/prod.json
{
  "API_URL": "https://api.production.example.com",
  "ENABLE_ANALYTICS": "true",
  "TIMEOUT_MS": "5000"
}
```

**For flavor-based config:**

```dart
// lib/config/flavors.dart
enum Flavor { dev, staging, production }

class FlavorConfig {
  static Flavor? _flavor;

  static void initialize(Flavor flavor) {
    _flavor = flavor;
  }

  static String get apiUrl => switch (_flavor!) {
    Flavor.dev => 'https://api.dev.example.com',
    Flavor.staging => 'https://api.staging.example.com',
    Flavor.production => 'https://api.example.com',
  };
}
```

**Tools:** dart-define, envied, flutter_flavor, Code Review
