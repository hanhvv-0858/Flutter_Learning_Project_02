import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:flutter_learning_project_2/core/domain/failure/failure.dart';
import 'package:flutter_learning_project_2/features/settings/data/datasources/settings_local_datasource.dart';
import 'package:flutter_learning_project_2/features/settings/domain/repositories/settings_repository.dart';

/// Concrete implementation of [SettingsRepository].
///
/// Wraps [SettingsLocalDatasource] and maps exceptions to [CacheFailure]
/// so the domain layer never sees SharedPreferences errors (per C029, C030).
@LazySingleton(as: SettingsRepository)
class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl(this._localDatasource);

  final SettingsLocalDatasource _localDatasource;

  @override
  Future<Either<Failure, String?>> getCurrentLocale() async {
    try {
      final code = _localDatasource.getLocaleCode();
      return Right(code);
    } catch (e, st) {
      log(
        'getCurrentLocale failed',
        error: e,
        stackTrace: st,
        name: 'SettingsRepositoryImpl',
      );
      return Left(CacheFailure('Failed to read locale: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> changeLocale(String localeCode) async {
    try {
      await _localDatasource.saveLocaleCode(localeCode);
      return const Right(unit);
    } catch (e, st) {
      log(
        'changeLocale failed for localeCode=$localeCode',
        error: e,
        stackTrace: st,
        name: 'SettingsRepositoryImpl',
      );
      return Left(CacheFailure('Failed to save locale: $e'));
    }
  }
}
