import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:example_flutter_02/core/domain/failure/failure.dart';
import 'package:example_flutter_02/core/domain/usecase/usecase.dart';
import 'package:example_flutter_02/features/settings/domain/repositories/settings_repository.dart';

/// Retrieves the currently persisted locale code.
@lazySingleton
class GetCurrentLocale extends UseCase<String?, NoParams> {
  GetCurrentLocale(this._repository);

  final SettingsRepository _repository;

  @override
  Future<Either<Failure, String?>> call(NoParams params) =>
      _repository.getCurrentLocale();
}
