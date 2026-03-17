import 'package:dartz/dartz.dart';

import 'package:example_flutter_02/core/domain/entities/album.dart';
import 'package:example_flutter_02/core/domain/failure/failure.dart';

/// Contract for searching albums from the iTunes Search API.
abstract class SearchRepository {
  /// Searches albums matching [query].
  Future<Either<Failure, List<Album>>> searchAlbums(String query);
}
