import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import 'package:example_flutter_02/core/domain/failure/failure.dart';
import 'package:example_flutter_02/core/domain/usecase/usecase.dart';
import 'package:example_flutter_02/features/settings/domain/repositories/settings_repository.dart';

/// Persists a new locale preference.
@lazySingleton
class ChangeLocale extends UseCase<Unit, ChangeLocaleParam> {
  ChangeLocale(this._repository);

  final SettingsRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(ChangeLocaleParam params) =>
      _repository.changeLocale(params.localeCode);
}

/// Input parameter carrying the locale code to persist.
class ChangeLocaleParam extends Equatable {
  const ChangeLocaleParam(this.localeCode);

  final String localeCode;

  @override
  List<Object?> get props => [localeCode];
}
