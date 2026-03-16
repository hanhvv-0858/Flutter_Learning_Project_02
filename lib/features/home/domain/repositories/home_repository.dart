import 'package:dartz/dartz.dart';

import 'package:example_flutter_02/core/domain/entities/album.dart';
import 'package:example_flutter_02/core/domain/failure/failure.dart';

/// Contract for fetching the home screen's album list.
///
/// The domain layer depends only on this abstraction — the concrete
/// implementation lives in the data layer ([HomeRepositoryImpl]).
abstract class HomeRepository {
  /// Fetches the current top albums from the iTunes RSS Feed.
  Future<Either<Failure, List<Album>>> getTopAlbums();
}
