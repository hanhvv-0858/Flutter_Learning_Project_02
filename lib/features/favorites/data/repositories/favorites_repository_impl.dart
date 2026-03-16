import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:example_flutter_02/core/domain/entities/album.dart';
import 'package:example_flutter_02/core/domain/failure/failure.dart';
import 'package:example_flutter_02/features/favorites/data/datasources/favorites_local_datasource.dart';
import 'package:example_flutter_02/features/favorites/data/models/favorite_model.dart';
import 'package:example_flutter_02/features/favorites/domain/repositories/favorites_repository.dart';

/// Concrete implementation of [FavoritesRepository].
///
/// Wraps [FavoritesLocalDatasource] and maps exceptions to [CacheFailure]
/// so the domain layer never sees raw database errors (per C029, C030).
@LazySingleton(as: FavoritesRepository)
class FavoritesRepositoryImpl implements FavoritesRepository {
  FavoritesRepositoryImpl(this._localDatasource);

  final FavoritesLocalDatasource _localDatasource;

  @override
  Future<Either<Failure, List<Album>>> getAllFavorites() async {
    try {
      final models = await _localDatasource.getAllFavorites();
      return Right(models.map((m) => m.toAlbum()).toList());
    } catch (e, st) {
      log(
        'getAllFavorites failed',
        error: e,
        stackTrace: st,
        name: 'FavoritesRepositoryImpl',
      );
      return Left(CacheFailure('Failed to load favorites: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveFavorite(Album album) async {
    try {
      await _localDatasource.insertFavorite(FavoriteModel.fromAlbum(album));
      return const Right(unit);
    } catch (e, st) {
      log(
        'saveFavorite failed for albumId=${album.id}',
        error: e,
        stackTrace: st,
        name: 'FavoritesRepositoryImpl',
      );
      return Left(CacheFailure('Failed to save favorite: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> removeFavorite(String albumId) async {
    try {
      await _localDatasource.deleteFavorite(albumId);
      return const Right(unit);
    } catch (e, st) {
      log(
        'removeFavorite failed for albumId=$albumId',
        error: e,
        stackTrace: st,
        name: 'FavoritesRepositoryImpl',
      );
      return Left(CacheFailure('Failed to remove favorite: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> isFavorite(String albumId) async {
    try {
      final result = await _localDatasource.isFavorite(albumId);
      return Right(result);
    } catch (e, st) {
      log(
        'isFavorite check failed for albumId=$albumId',
        error: e,
        stackTrace: st,
        name: 'FavoritesRepositoryImpl',
      );
      return Left(CacheFailure('Failed to check favorite status: $e'));
    }
  }
}
