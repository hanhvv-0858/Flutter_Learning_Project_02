import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:flutter_learning_project_2/core/domain/failure/failure.dart';
import 'package:flutter_learning_project_2/core/domain/usecase/usecase.dart';
import 'package:flutter_learning_project_2/features/settings/domain/repositories/settings_repository.dart';

/// Retrieves the currently persisted locale code.
@lazySingleton
class GetCurrentLocale extends UseCase<String?, NoParams> {
  GetCurrentLocale(this._repository);

  final SettingsRepository _repository;

  @override
  Future<Either<Failure, String?>> call(NoParams params) =>
      _repository.getCurrentLocale();
}
