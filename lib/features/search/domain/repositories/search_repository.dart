import 'package:dartz/dartz.dart';

import 'package:flutter_learning_project_2/core/domain/entities/album.dart';
import 'package:flutter_learning_project_2/core/domain/failure/failure.dart';

/// Contract for searching albums from the iTunes Search API.
abstract class SearchRepository {
  /// Searches albums matching [query].
  Future<Either<Failure, List<Album>>> searchAlbums(String query);
}
