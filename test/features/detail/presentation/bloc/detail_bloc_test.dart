import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_learning_project_2/core/domain/entities/album.dart';
import 'package:flutter_learning_project_2/core/domain/entities/track.dart';
import 'package:flutter_learning_project_2/core/domain/failure/failure.dart';
import 'package:flutter_learning_project_2/features/detail/domain/usecases/get_album_tracks.dart';
import 'package:flutter_learning_project_2/features/detail/presentation/bloc/detail_bloc.dart';
import 'package:flutter_learning_project_2/features/detail/presentation/bloc/detail_event.dart';
import 'package:flutter_learning_project_2/features/detail/presentation/bloc/detail_state.dart';
import 'package:flutter_learning_project_2/features/favorites/domain/usecases/check_is_favorite.dart';
import 'package:flutter_learning_project_2/features/favorites/domain/usecases/remove_favorite.dart';
import 'package:flutter_learning_project_2/features/favorites/domain/usecases/save_favorite.dart';

class MockGetAlbumTracks extends Mock implements GetAlbumTracks {}

class MockCheckIsFavorite extends Mock implements CheckIsFavorite {}

class MockSaveFavorite extends Mock implements SaveFavorite {}

class MockRemoveFavorite extends Mock implements RemoveFavorite {}

void main() {
  late MockGetAlbumTracks mockGetAlbumTracks;
  late MockCheckIsFavorite mockCheckIsFavorite;
  late MockSaveFavorite mockSaveFavorite;
  late MockRemoveFavorite mockRemoveFavorite;

  const tAlbum = Album(
    id: '123',
    name: 'Test Album',
    artistName: 'Test Artist',
    imageUrl: 'https://example.com/img.jpg',
    releaseDate: '2026-01-01',
  );

  final tTracks = [
    const Track(id: '1', name: 'Song A', durationMs: 200000, trackNumber: 1),
    const Track(id: '2', name: 'Song B', durationMs: 180000, trackNumber: 2),
  ];

  setUpAll(() {
    registerFallbackValue(const AlbumIdParam(''));
    registerFallbackValue(const CheckIsFavoriteParam(''));
    registerFallbackValue(const RemoveFavoriteParam(''));
    registerFallbackValue(tAlbum);
  });

  setUp(() {
    mockGetAlbumTracks = MockGetAlbumTracks();
    mockCheckIsFavorite = MockCheckIsFavorite();
    mockSaveFavorite = MockSaveFavorite();
    mockRemoveFavorite = MockRemoveFavorite();
  });

  DetailBloc buildBloc() => DetailBloc(
    mockGetAlbumTracks,
    mockCheckIsFavorite,
    mockSaveFavorite,
    mockRemoveFavorite,
  );

  group('initial state', () {
    test('is DetailInitial', () {
      final bloc = buildBloc();
      expect(bloc.state, isA<DetailInitial>());
      bloc.close();
    });
  });

  group('DetailLoadRequested', () {
    blocTest<DetailBloc, DetailState>(
      'emits [DetailLoading, DetailLoaded] on success with isFavorite=false',
      build: () {
        when(
          () => mockGetAlbumTracks(any()),
        ).thenAnswer((_) async => Right(tTracks));
        when(
          () => mockCheckIsFavorite(any()),
        ).thenAnswer((_) async => const Right(false));
        return buildBloc();
      },
      act: (bloc) => bloc.add(const DetailLoadRequested(tAlbum)),
      expect: () => [
        isA<DetailLoading>(),
        isA<DetailLoaded>()
            .having((s) => s.tracks.length, 'tracks count', 2)
            .having((s) => s.isFavorite, 'isFavorite', false),
      ],
    );

    blocTest<DetailBloc, DetailState>(
      'emits [DetailLoading, DetailLoaded] with isFavorite=true',
      build: () {
        when(
          () => mockGetAlbumTracks(any()),
        ).thenAnswer((_) async => Right(tTracks));
        when(
          () => mockCheckIsFavorite(any()),
        ).thenAnswer((_) async => const Right(true));
        return buildBloc();
      },
      act: (bloc) => bloc.add(const DetailLoadRequested(tAlbum)),
      expect: () => [
        isA<DetailLoading>(),
        isA<DetailLoaded>().having((s) => s.isFavorite, 'isFavorite', true),
      ],
    );

    blocTest<DetailBloc, DetailState>(
      'emits [DetailLoading, DetailError] when tracks fail',
      build: () {
        when(
          () => mockGetAlbumTracks(any()),
        ).thenAnswer((_) async => const Left(NetworkFailure('No connection')));
        when(
          () => mockCheckIsFavorite(any()),
        ).thenAnswer((_) async => const Right(false));
        return buildBloc();
      },
      act: (bloc) => bloc.add(const DetailLoadRequested(tAlbum)),
      expect: () => [
        isA<DetailLoading>(),
        isA<DetailError>().having((s) => s.message, 'message', 'No connection'),
      ],
    );

    blocTest<DetailBloc, DetailState>(
      'defaults isFavorite to false when favorite check fails',
      build: () {
        when(
          () => mockGetAlbumTracks(any()),
        ).thenAnswer((_) async => Right(tTracks));
        when(
          () => mockCheckIsFavorite(any()),
        ).thenAnswer((_) async => const Left(CacheFailure('db error')));
        return buildBloc();
      },
      act: (bloc) => bloc.add(const DetailLoadRequested(tAlbum)),
      expect: () => [
        isA<DetailLoading>(),
        isA<DetailLoaded>().having((s) => s.isFavorite, 'isFavorite', false),
      ],
    );
  });

  group('DetailToggleFavorite', () {
    blocTest<DetailBloc, DetailState>(
      'flips isFavorite from false to true (save)',
      build: () {
        when(
          () => mockSaveFavorite(any()),
        ).thenAnswer((_) async => const Right(unit));
        return buildBloc();
      },
      seed: () =>
          DetailLoaded(album: tAlbum, tracks: tTracks, isFavorite: false),
      act: (bloc) => bloc.add(const DetailToggleFavorite(tAlbum)),
      expect: () => [
        isA<DetailLoaded>().having((s) => s.isFavorite, 'isFavorite', true),
      ],
    );

    blocTest<DetailBloc, DetailState>(
      'flips isFavorite from true to false (remove)',
      build: () {
        when(
          () => mockRemoveFavorite(any()),
        ).thenAnswer((_) async => const Right(unit));
        return buildBloc();
      },
      seed: () =>
          DetailLoaded(album: tAlbum, tracks: tTracks, isFavorite: true),
      act: (bloc) => bloc.add(const DetailToggleFavorite(tAlbum)),
      expect: () => [
        isA<DetailLoaded>().having((s) => s.isFavorite, 'isFavorite', false),
      ],
    );

    blocTest<DetailBloc, DetailState>(
      'does not emit when saveFavorite fails',
      build: () {
        when(
          () => mockSaveFavorite(any()),
        ).thenAnswer((_) async => const Left(CacheFailure('write error')));
        return buildBloc();
      },
      seed: () =>
          DetailLoaded(album: tAlbum, tracks: tTracks, isFavorite: false),
      act: (bloc) => bloc.add(const DetailToggleFavorite(tAlbum)),
      expect: () => <DetailState>[],
    );

    blocTest<DetailBloc, DetailState>(
      'is no-op when state is not DetailLoaded',
      build: () => buildBloc(),
      seed: () => DetailError(album: tAlbum, message: 'error'),
      act: (bloc) => bloc.add(const DetailToggleFavorite(tAlbum)),
      expect: () => <DetailState>[],
    );
  });
}
