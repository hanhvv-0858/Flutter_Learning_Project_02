import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:example_flutter_02/core/domain/entities/album.dart';
import 'package:example_flutter_02/core/domain/failure/failure.dart';
import 'package:example_flutter_02/core/domain/usecase/usecase.dart';
import 'package:example_flutter_02/features/favorites/domain/repositories/favorites_repository.dart';

/// Saves an album to the local favorites database.
@lazySingleton
class SaveFavorite extends UseCase<Unit, Album> {
  SaveFavorite(this._repository);

  final FavoritesRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(Album params) =>
      _repository.saveFavorite(params);
}
