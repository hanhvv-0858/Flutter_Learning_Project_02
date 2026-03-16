import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:example_flutter_02/core/domain/entities/album.dart';
import 'package:example_flutter_02/core/domain/failure/failure.dart';
import 'package:example_flutter_02/features/favorites/data/datasources/favorites_local_datasource.dart';
import 'package:example_flutter_02/features/favorites/data/models/favorite_model.dart';
import 'package:example_flutter_02/features/favorites/data/repositories/favorites_repository_impl.dart';

class MockFavoritesLocalDatasource extends Mock
    implements FavoritesLocalDatasource {}

void main() {
  late MockFavoritesLocalDatasource mockDatasource;
  late FavoritesRepositoryImpl repository;

  setUp(() {
    mockDatasource = MockFavoritesLocalDatasource();
    repository = FavoritesRepositoryImpl(mockDatasource);
  });

  const tAlbum = Album(
    id: '1',
    name: 'Test Album',
    artistName: 'Artist',
    imageUrl: 'https://example.com/img.jpg',
    releaseDate: '2026-01-01',
  );

  final tFavoriteModels = [FavoriteModel.fromAlbum(tAlbum)];

  setUpAll(() {
    registerFallbackValue(FavoriteModel.fromAlbum(tAlbum));
  });

  group('getAllFavorites()', () {
    test('returns Right(List<Album>) on success', () async {
      when(
        () => mockDatasource.getAllFavorites(),
      ).thenAnswer((_) async => tFavoriteModels);

      final result = await repository.getAllFavorites();

      expect(result.isRight(), isTrue);
      result.fold((_) => fail('Expected Right'), (albums) {
        expect(albums.length, 1);
        expect(albums.first.id, '1');
      });
    });

    test('returns Right with empty list when no favorites', () async {
      when(() => mockDatasource.getAllFavorites()).thenAnswer((_) async => []);

      final result = await repository.getAllFavorites();

      result.fold(
        (_) => fail('Expected Right'),
        (albums) => expect(albums, isEmpty),
      );
    });

    test('returns Left(CacheFailure) on exception', () async {
      when(
        () => mockDatasource.getAllFavorites(),
      ).thenThrow(Exception('db read error'));

      final result = await repository.getAllFavorites();

      result.fold(
        (f) => expect(f, isA<CacheFailure>()),
        (_) => fail('Expected Left'),
      );
    });
  });

  group('saveFavorite()', () {
    test('returns Right(unit) on success', () async {
      when(() => mockDatasource.insertFavorite(any())).thenAnswer((_) async {});

      final result = await repository.saveFavorite(tAlbum);

      expect(result, const Right<Failure, Unit>(unit));
      verify(() => mockDatasource.insertFavorite(any())).called(1);
    });

    test('returns Left(CacheFailure) on exception', () async {
      when(
        () => mockDatasource.insertFavorite(any()),
      ).thenThrow(Exception('db write error'));

      final result = await repository.saveFavorite(tAlbum);

      result.fold(
        (f) => expect(f, isA<CacheFailure>()),
        (_) => fail('Expected Left'),
      );
    });
  });

  group('removeFavorite()', () {
    test('returns Right(unit) on success', () async {
      when(() => mockDatasource.deleteFavorite('1')).thenAnswer((_) async {});

      final result = await repository.removeFavorite('1');

      expect(result, const Right<Failure, Unit>(unit));
    });

    test('returns Left(CacheFailure) on exception', () async {
      when(
        () => mockDatasource.deleteFavorite('1'),
      ).thenThrow(Exception('db delete error'));

      final result = await repository.removeFavorite('1');

      result.fold(
        (f) => expect(f, isA<CacheFailure>()),
        (_) => fail('Expected Left'),
      );
    });
  });

  group('isFavorite()', () {
    test('returns Right(true) when album exists', () async {
      when(() => mockDatasource.isFavorite('1')).thenAnswer((_) async => true);

      final result = await repository.isFavorite('1');

      result.fold((_) => fail('Expected Right'), (val) => expect(val, isTrue));
    });

    test('returns Right(false) when album not found', () async {
      when(
        () => mockDatasource.isFavorite('999'),
      ).thenAnswer((_) async => false);

      final result = await repository.isFavorite('999');

      result.fold((_) => fail('Expected Right'), (val) => expect(val, isFalse));
    });

    test('returns Left(CacheFailure) on exception', () async {
      when(
        () => mockDatasource.isFavorite('1'),
      ).thenThrow(Exception('db query error'));

      final result = await repository.isFavorite('1');

      result.fold(
        (f) => expect(f, isA<CacheFailure>()),
        (_) => fail('Expected Left'),
      );
    });
  });
}
