---
title: No Hardcoded Secrets
impact: HIGH
impactDescription: prevents credential leakage from source code
tags: security, secrets, credentials, api-keys, quality
---

## No Hardcoded Secrets

Secrets hardcoded in source code will be exposed in version control, app binaries, and decompilation.

**Incorrect (hardcoded secrets):**

```dart
// BAD: Hardcoded API key in source code
const apiKey = 'sk_live_abc123xyz456';
const dbPassword = 'MySecretP@ss!';
const jwtSecret = 'super-secret-jwt-key';
const stripeKey = 'pk_live_51Abc...';
```

**Correct (externalized secrets - Flutter):**

```dart
// Option 1: dart-define at build time (recommended for CI/CD)
// Run: flutter build apk --dart-define=API_KEY=sk_live_xxx
const apiKey = String.fromEnvironment('API_KEY');
const apiUrl = String.fromEnvironment('API_URL', defaultValue: 'https://api.dev.example.com');

// Option 2: flutter_secure_storage for runtime secrets
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecretRepository {
  final _storage = const FlutterSecureStorage();

  Future<String?> getApiKey() => _storage.read(key: 'api_key');
  Future<void> saveApiKey(String key) => _storage.write(key: 'api_key', value: key);
}

// Option 3: Remote config (Firebase Remote Config)
final remoteConfig = FirebaseRemoteConfig.instance;
final featureFlag = remoteConfig.getBool('new_feature_enabled');
```

**For .env files (development only):**

```dart
// pubspec.yaml - add envied package
// dev_dependencies:
//   envied_generator: ^0.5.0

// lib/config/env.dart
import 'package:envied/envied.dart';
part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'API_KEY', obfuscate: true)
  static final String apiKey = _Env.apiKey;
}
```

**Never commit:**

```gitignore
# .gitignore
.env
.env.*
*.keystore
*.jks
google-services.json    # Contains API keys
GoogleService-Info.plist
```

**Tools:** GitLeaks, git-secrets, flutter_secure_storage, envied
