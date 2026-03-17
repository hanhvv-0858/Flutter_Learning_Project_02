import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_learning_project_2/core/domain/entities/album.dart';
import 'package:flutter_learning_project_2/core/domain/failure/failure.dart';
import 'package:flutter_learning_project_2/core/domain/usecase/usecase.dart';
import 'package:flutter_learning_project_2/features/favorites/domain/usecases/get_all_favorites.dart';
import 'package:flutter_learning_project_2/features/favorites/domain/usecases/remove_favorite.dart';
import 'package:flutter_learning_project_2/features/favorites/presentation/bloc/favorites_bloc.dart';
import 'package:flutter_learning_project_2/features/favorites/presentation/bloc/favorites_event.dart';
import 'package:flutter_learning_project_2/features/favorites/presentation/bloc/favorites_state.dart';

class MockGetAllFavorites extends Mock implements GetAllFavorites {}

class MockRemoveFavorite extends Mock implements RemoveFavorite {}

void main() {
  late MockGetAllFavorites mockGetAllFavorites;
  late MockRemoveFavorite mockRemoveFavorite;

  const tAlbums = [
    Album(
      id: '1',
      name: 'Album A',
      artistName: 'Artist A',
      imageUrl: 'https://example.com/a.jpg',
      releaseDate: '2026-01-01',
    ),
    Album(
      id: '2',
      name: 'Album B',
      artistName: 'Artist B',
      imageUrl: 'https://example.com/b.jpg',
      releaseDate: '2026-02-01',
    ),
  ];

  setUpAll(() {
    registerFallbackValue(NoParams());
    registerFallbackValue(const RemoveFavoriteParam(''));
  });

  setUp(() {
    mockGetAllFavorites = MockGetAllFavorites();
    mockRemoveFavorite = MockRemoveFavorite();
  });

  FavoritesBloc buildBloc() =>
      FavoritesBloc(mockGetAllFavorites, mockRemoveFavorite);

  group('initial state', () {
    test('is FavoritesInitial', () {
      final bloc = buildBloc();
      expect(bloc.state, isA<FavoritesInitial>());
      bloc.close();
    });
  });

  group('FavoritesLoadRequested', () {
    blocTest<FavoritesBloc, FavoritesState>(
      'emits [FavoritesLoading, FavoritesLoaded] when favorites exist',
      build: () {
        when(
          () => mockGetAllFavorites(any()),
        ).thenAnswer((_) async => const Right(tAlbums));
        return buildBloc();
      },
      act: (bloc) => bloc.add(const FavoritesLoadRequested()),
      expect: () => [
        isA<FavoritesLoading>(),
        isA<FavoritesLoaded>().having(
          (s) => s.albums.length,
          'albums count',
          2,
        ),
      ],
    );

    blocTest<FavoritesBloc, FavoritesState>(
      'emits [FavoritesLoading, FavoritesEmpty] when list is empty',
      build: () {
        when(
          () => mockGetAllFavorites(any()),
        ).thenAnswer((_) async => const Right([]));
        return buildBloc();
      },
      act: (bloc) => bloc.add(const FavoritesLoadRequested()),
      expect: () => [isA<FavoritesLoading>(), isA<FavoritesEmpty>()],
    );

    blocTest<FavoritesBloc, FavoritesState>(
      'emits [FavoritesLoading, FavoritesError] on failure',
      build: () {
        when(
          () => mockGetAllFavorites(any()),
        ).thenAnswer((_) async => const Left(CacheFailure('db error')));
        return buildBloc();
      },
      act: (bloc) => bloc.add(const FavoritesLoadRequested()),
      expect: () => [
        isA<FavoritesLoading>(),
        isA<FavoritesError>().having((s) => s.message, 'message', 'db error'),
      ],
    );
  });

  group('FavoritesRemoveRequested', () {
    blocTest<FavoritesBloc, FavoritesState>(
      'removes then reloads on success — emits Loaded with remaining items',
      build: () {
        when(
          () => mockRemoveFavorite(any()),
        ).thenAnswer((_) async => const Right(unit));
        // After removal, reload returns only the second album.
        when(
          () => mockGetAllFavorites(any()),
        ).thenAnswer((_) async => Right([tAlbums[1]]));
        return buildBloc();
      },
      seed: () => const FavoritesLoaded(tAlbums),
      act: (bloc) => bloc.add(const FavoritesRemoveRequested('1')),
      expect: () => [
        isA<FavoritesLoading>(),
        isA<FavoritesLoaded>().having(
          (s) => s.albums.length,
          'albums count',
          1,
        ),
      ],
    );

    blocTest<FavoritesBloc, FavoritesState>(
      'does not reload when remove fails',
      build: () {
        when(
          () => mockRemoveFavorite(any()),
        ).thenAnswer((_) async => const Left(CacheFailure('fail')));
        return buildBloc();
      },
      seed: () => const FavoritesLoaded(tAlbums),
      act: (bloc) => bloc.add(const FavoritesRemoveRequested('1')),
      expect: () => <FavoritesState>[],
    );
  });
}
