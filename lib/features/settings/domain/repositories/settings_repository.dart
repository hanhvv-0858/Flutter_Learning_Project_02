import 'package:dartz/dartz.dart';

import 'package:flutter_learning_project_2/core/domain/failure/failure.dart';

/// Contract for reading and persisting the user's locale preference.
abstract class SettingsRepository {
  /// Returns the persisted locale code (e.g. 'en', 'vi'), or null if unset.
  Future<Either<Failure, String?>> getCurrentLocale();

  /// Persists the given [localeCode] for future app launches.
  Future<Either<Failure, Unit>> changeLocale(String localeCode);
}
