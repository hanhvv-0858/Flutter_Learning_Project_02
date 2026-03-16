import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import 'package:example_flutter_02/core/domain/failure/failure.dart';
import 'package:example_flutter_02/core/domain/usecase/usecase.dart';
import 'package:example_flutter_02/features/favorites/domain/repositories/favorites_repository.dart';

/// Checks whether a specific album is saved as a favorite.
@lazySingleton
class CheckIsFavorite extends UseCase<bool, CheckIsFavoriteParam> {
  CheckIsFavorite(this._repository);

  final FavoritesRepository _repository;

  @override
  Future<Either<Failure, bool>> call(CheckIsFavoriteParam params) =>
      _repository.isFavorite(params.albumId);
}

/// Input parameter carrying the album ID to check.
class CheckIsFavoriteParam extends Equatable {
  const CheckIsFavoriteParam(this.albumId);

  final String albumId;

  @override
  List<Object?> get props => [albumId];
}
