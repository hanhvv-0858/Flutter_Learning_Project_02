import 'package:dartz/dartz.dart';

import 'package:flutter_learning_project_2/core/domain/entities/track.dart';
import 'package:flutter_learning_project_2/core/domain/failure/failure.dart';

/// Contract for fetching album track listings from the iTunes Lookup API.
///
/// The domain layer depends only on this abstraction — the concrete
/// implementation lives in the data layer ([DetailRepositoryImpl]).
abstract class DetailRepository {
  /// Fetches all tracks for the given [albumId] from iTunes Lookup.
  Future<Either<Failure, List<Track>>> getAlbumTracks(String albumId);
}
