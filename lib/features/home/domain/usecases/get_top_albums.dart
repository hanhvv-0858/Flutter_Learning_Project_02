import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:flutter_learning_project_2/core/domain/entities/album.dart';
import 'package:flutter_learning_project_2/core/domain/failure/failure.dart';
import 'package:flutter_learning_project_2/core/domain/usecase/usecase.dart';
import 'package:flutter_learning_project_2/features/home/domain/repositories/home_repository.dart';

/// Fetches the top albums list from the iTunes RSS Feed.
@lazySingleton
class GetTopAlbums extends UseCase<List<Album>, NoParams> {
  GetTopAlbums(this._repository);

  final HomeRepository _repository;

  @override
  Future<Either<Failure, List<Album>>> call(NoParams params) =>
      _repository.getTopAlbums();
}
