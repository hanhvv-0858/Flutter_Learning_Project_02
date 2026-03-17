import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_learning_project_2/core/domain/entities/album.dart';
import 'package:flutter_learning_project_2/core/domain/failure/failure.dart';
import 'package:flutter_learning_project_2/core/domain/usecase/usecase.dart';
import 'package:flutter_learning_project_2/features/home/domain/usecases/get_top_albums.dart';
import 'package:flutter_learning_project_2/features/home/presentation/bloc/home_bloc.dart';
import 'package:flutter_learning_project_2/features/home/presentation/bloc/home_event.dart';
import 'package:flutter_learning_project_2/features/home/presentation/bloc/home_state.dart';

class MockGetTopAlbums extends Mock implements GetTopAlbums {}

void main() {
  late MockGetTopAlbums mockGetTopAlbums;

  setUpAll(() => registerFallbackValue(NoParams()));

  setUp(() => mockGetTopAlbums = MockGetTopAlbums());

  final tAlbums = [
    const Album(
      id: '1',
      name: 'Album A',
      artistName: 'Artist A',
      imageUrl: 'https://example.com/a.jpg',
    ),
  ];

  group('initial state', () {
    test('is HomeInitial', () {
      final bloc = HomeBloc(mockGetTopAlbums);
      expect(bloc.state, isA<HomeInitial>());
      bloc.close();
    });
  });

  group('HomeFetchRequested', () {
    blocTest<HomeBloc, HomeState>(
      'emits [HomeLoading, HomeLoaded] when use case returns Right',
      build: () {
        when(
          () => mockGetTopAlbums(NoParams()),
        ).thenAnswer((_) async => Right(tAlbums));
        return HomeBloc(mockGetTopAlbums);
      },
      act: (bloc) => bloc.add(const HomeFetchRequested()),
      expect: () => [isA<HomeLoading>(), isA<HomeLoaded>()],
    );

    blocTest<HomeBloc, HomeState>(
      'HomeLoaded contains the correct albums list',
      build: () {
        when(
          () => mockGetTopAlbums(NoParams()),
        ).thenAnswer((_) async => Right(tAlbums));
        return HomeBloc(mockGetTopAlbums);
      },
      act: (bloc) => bloc.add(const HomeFetchRequested()),
      expect: () => [isA<HomeLoading>(), HomeLoaded(tAlbums)],
    );

    blocTest<HomeBloc, HomeState>(
      'emits [HomeLoading, HomeError] when use case returns Left(NetworkFailure)',
      build: () {
        when(
          () => mockGetTopAlbums(NoParams()),
        ).thenAnswer((_) async => const Left(NetworkFailure('No connection')));
        return HomeBloc(mockGetTopAlbums);
      },
      act: (bloc) => bloc.add(const HomeFetchRequested()),
      expect: () => [isA<HomeLoading>(), isA<HomeError>()],
    );

    blocTest<HomeBloc, HomeState>(
      'HomeError message matches failure message',
      build: () {
        when(() => mockGetTopAlbums(NoParams())).thenAnswer(
          (_) async => const Left(ServerFailure('Server error: 503')),
        );
        return HomeBloc(mockGetTopAlbums);
      },
      act: (bloc) => bloc.add(const HomeFetchRequested()),
      expect: () => [isA<HomeLoading>(), const HomeError('Server error: 503')],
    );

    blocTest<HomeBloc, HomeState>(
      'emits [HomeLoading, HomeLoaded([])] when use case returns empty list',
      build: () {
        when(
          () => mockGetTopAlbums(NoParams()),
        ).thenAnswer((_) async => const Right([]));
        return HomeBloc(mockGetTopAlbums);
      },
      act: (bloc) => bloc.add(const HomeFetchRequested()),
      expect: () => [isA<HomeLoading>(), const HomeLoaded([])],
    );
  });
}
