import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:example_flutter_02/core/domain/entities/album.dart';
import 'package:example_flutter_02/core/domain/failure/failure.dart';
import 'package:example_flutter_02/features/search/domain/usecases/search_albums.dart';
import 'package:example_flutter_02/features/search/presentation/bloc/search_bloc.dart';
import 'package:example_flutter_02/features/search/presentation/bloc/search_event.dart';
import 'package:example_flutter_02/features/search/presentation/bloc/search_state.dart';

class MockSearchAlbums extends Mock implements SearchAlbums {}

void main() {
  late MockSearchAlbums mockSearchAlbums;

  const tAlbums = [
    Album(
      id: '1',
      name: 'Album A',
      artistName: 'Artist A',
      imageUrl: 'https://example.com/a.jpg',
      releaseDate: '2026-01-01',
    ),
  ];

  setUpAll(() {
    registerFallbackValue(const SearchAlbumsParam(''));
  });

  setUp(() {
    mockSearchAlbums = MockSearchAlbums();
  });

  SearchBloc buildBloc() => SearchBloc(mockSearchAlbums);

  group('initial state', () {
    test('is SearchInitial', () {
      final bloc = buildBloc();
      expect(bloc.state, isA<SearchInitial>());
      bloc.close();
    });
  });

  group('SearchSubmitted', () {
    blocTest<SearchBloc, SearchState>(
      'emits [SearchLoading, SearchLoaded] on success with results',
      build: () {
        when(
          () => mockSearchAlbums(any()),
        ).thenAnswer((_) async => const Right(tAlbums));
        return buildBloc();
      },
      act: (bloc) => bloc.add(const SearchSubmitted('rock')),
      expect: () => [
        isA<SearchLoading>(),
        isA<SearchLoaded>().having((s) => s.albums.length, 'albums count', 1),
      ],
    );

    blocTest<SearchBloc, SearchState>(
      'emits [SearchLoading, SearchEmpty] when no results',
      build: () {
        when(
          () => mockSearchAlbums(any()),
        ).thenAnswer((_) async => const Right([]));
        return buildBloc();
      },
      act: (bloc) => bloc.add(const SearchSubmitted('xyznonexistent')),
      expect: () => [isA<SearchLoading>(), isA<SearchEmpty>()],
    );

    blocTest<SearchBloc, SearchState>(
      'emits [SearchLoading, SearchError] on failure',
      build: () {
        when(
          () => mockSearchAlbums(any()),
        ).thenAnswer((_) async => const Left(NetworkFailure('No connection')));
        return buildBloc();
      },
      act: (bloc) => bloc.add(const SearchSubmitted('rock')),
      expect: () => [
        isA<SearchLoading>(),
        isA<SearchError>().having((s) => s.message, 'message', 'No connection'),
      ],
    );

    blocTest<SearchBloc, SearchState>(
      'does nothing when query is empty',
      build: () => buildBloc(),
      act: (bloc) => bloc.add(const SearchSubmitted('  ')),
      expect: () => <SearchState>[],
    );
  });

  group('SearchQueryChanged', () {
    blocTest<SearchBloc, SearchState>(
      'emits SearchInitial when query is cleared',
      build: () => buildBloc(),
      act: (bloc) => bloc.add(const SearchQueryChanged('')),
      wait: const Duration(milliseconds: 400),
      expect: () => [isA<SearchInitial>()],
    );

    blocTest<SearchBloc, SearchState>(
      'debounces then emits [SearchLoading, SearchLoaded]',
      build: () {
        when(
          () => mockSearchAlbums(any()),
        ).thenAnswer((_) async => const Right(tAlbums));
        return buildBloc();
      },
      act: (bloc) => bloc.add(const SearchQueryChanged('rock')),
      wait: const Duration(milliseconds: 400),
      expect: () => [isA<SearchLoading>(), isA<SearchLoaded>()],
    );
  });
}
