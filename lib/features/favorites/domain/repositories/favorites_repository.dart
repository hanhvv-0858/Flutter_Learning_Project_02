import 'package:dartz/dartz.dart';

import 'package:example_flutter_02/core/domain/entities/album.dart';
import 'package:example_flutter_02/core/domain/failure/failure.dart';

/// Contract for managing the user's favorite albums (local Sqflite storage).
///
/// The domain layer depends only on this abstraction — the concrete
/// implementation lives in the data layer ([FavoritesRepositoryImpl]).
abstract class FavoritesRepository {
  /// Returns all saved favorite albums.
  Future<Either<Failure, List<Album>>> getAllFavorites();

  /// Persists [album] to local favorites.
  Future<Either<Failure, Unit>> saveFavorite(Album album);

  /// Removes the favorite with the given [albumId].
  Future<Either<Failure, Unit>> removeFavorite(String albumId);

  /// Checks whether the album with [albumId] is already a favorite.
  Future<Either<Failure, bool>> isFavorite(String albumId);
}
