import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:flutter_learning_project_2/core/domain/entities/album.dart';
import 'package:flutter_learning_project_2/core/domain/failure/failure.dart';
import 'package:flutter_learning_project_2/core/domain/usecase/usecase.dart';
import 'package:flutter_learning_project_2/features/favorites/domain/repositories/favorites_repository.dart';

/// Retrieves all favorite albums from local storage.
@lazySingleton
class GetAllFavorites extends UseCase<List<Album>, NoParams> {
  GetAllFavorites(this._repository);

  final FavoritesRepository _repository;

  @override
  Future<Either<Failure, List<Album>>> call(NoParams params) =>
      _repository.getAllFavorites();
}
