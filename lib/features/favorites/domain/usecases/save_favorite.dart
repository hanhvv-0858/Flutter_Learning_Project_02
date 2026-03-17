import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:flutter_learning_project_2/core/domain/entities/album.dart';
import 'package:flutter_learning_project_2/core/domain/failure/failure.dart';
import 'package:flutter_learning_project_2/core/domain/usecase/usecase.dart';
import 'package:flutter_learning_project_2/features/favorites/domain/repositories/favorites_repository.dart';

/// Saves an album to the local favorites database.
@lazySingleton
class SaveFavorite extends UseCase<Unit, Album> {
  SaveFavorite(this._repository);

  final FavoritesRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(Album params) =>
      _repository.saveFavorite(params);
}
