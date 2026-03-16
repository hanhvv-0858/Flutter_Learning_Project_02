import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import 'package:example_flutter_02/core/domain/failure/failure.dart';
import 'package:example_flutter_02/core/domain/usecase/usecase.dart';
import 'package:example_flutter_02/features/favorites/domain/repositories/favorites_repository.dart';

/// Removes a favorite album by its ID from local storage.
@lazySingleton
class RemoveFavorite extends UseCase<Unit, RemoveFavoriteParam> {
  RemoveFavorite(this._repository);

  final FavoritesRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(RemoveFavoriteParam params) =>
      _repository.removeFavorite(params.albumId);
}

/// Input parameter carrying the album ID to remove.
class RemoveFavoriteParam extends Equatable {
  const RemoveFavoriteParam(this.albumId);

  final String albumId;

  @override
  List<Object?> get props => [albumId];
}
