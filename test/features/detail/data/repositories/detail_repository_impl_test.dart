import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_learning_project_2/core/data/models/track_model.dart';
import 'package:flutter_learning_project_2/core/domain/entities/track.dart';
import 'package:flutter_learning_project_2/core/domain/failure/failure.dart';
import 'package:flutter_learning_project_2/features/detail/data/datasources/detail_remote_datasource.dart';
import 'package:flutter_learning_project_2/features/detail/data/repositories/detail_repository_impl.dart';

class MockDetailRemoteDatasource extends Mock
    implements DetailRemoteDatasource {}

/// Helper: build a minimal [DioException] with the given [type].
DioException _dioException(DioExceptionType type) => DioException(
  requestOptions: RequestOptions(path: '/lookup'),
  type: type,
);

void main() {
  late MockDetailRemoteDatasource mockDatasource;
  late DetailRepositoryImpl repository;

  setUp(() {
    mockDatasource = MockDetailRemoteDatasource();
    repository = DetailRepositoryImpl(mockDatasource);
  });

  final tTracks = [
    const TrackModel(
      id: '101',
      name: 'Song One',
      durationMs: 200000,
      trackNumber: 1,
    ),
    const TrackModel(
      id: '102',
      name: 'Song Two',
      durationMs: 180000,
      trackNumber: 2,
    ),
  ];

  group('getAlbumTracks() — success', () {
    test('returns Right(List<Track>) when datasource succeeds', () async {
      when(
        () => mockDatasource.fetchAlbumTracks('123'),
      ).thenAnswer((_) async => tTracks);

      final result = await repository.getAlbumTracks('123');

      expect(result, isA<Right<Failure, List<Track>>>());
      result.fold(
        (_) => fail('Expected Right'),
        (tracks) => expect(tracks.length, 2),
      );
    });

    test('returns Right with empty list when no tracks found', () async {
      when(
        () => mockDatasource.fetchAlbumTracks('456'),
      ).thenAnswer((_) async => []);

      final result = await repository.getAlbumTracks('456');

      result.fold(
        (_) => fail('Expected Right'),
        (tracks) => expect(tracks, isEmpty),
      );
    });
  });

  group('getAlbumTracks() — network failures', () {
    test('returns Left(NetworkFailure) on connectionTimeout', () async {
      when(
        () => mockDatasource.fetchAlbumTracks('123'),
      ).thenThrow(_dioException(DioExceptionType.connectionTimeout));

      final result = await repository.getAlbumTracks('123');

      expect(result.isLeft(), isTrue);
      result.fold(
        (f) => expect(f, isA<NetworkFailure>()),
        (_) => fail('Expected Left'),
      );
    });

    test('returns Left(NetworkFailure) on sendTimeout', () async {
      when(
        () => mockDatasource.fetchAlbumTracks('123'),
      ).thenThrow(_dioException(DioExceptionType.sendTimeout));

      final result = await repository.getAlbumTracks('123');

      result.fold(
        (f) => expect(f, isA<NetworkFailure>()),
        (_) => fail('Expected Left'),
      );
    });

    test('returns Left(NetworkFailure) on receiveTimeout', () async {
      when(
        () => mockDatasource.fetchAlbumTracks('123'),
      ).thenThrow(_dioException(DioExceptionType.receiveTimeout));

      final result = await repository.getAlbumTracks('123');

      result.fold(
        (f) => expect(f, isA<NetworkFailure>()),
        (_) => fail('Expected Left'),
      );
    });

    test('returns Left(NetworkFailure) on connectionError', () async {
      when(
        () => mockDatasource.fetchAlbumTracks('123'),
      ).thenThrow(_dioException(DioExceptionType.connectionError));

      final result = await repository.getAlbumTracks('123');

      result.fold(
        (f) => expect(f, isA<NetworkFailure>()),
        (_) => fail('Expected Left'),
      );
    });

    test(
      'returns Left(NetworkFailure) on unknown with null response',
      () async {
        when(
          () => mockDatasource.fetchAlbumTracks('123'),
        ).thenThrow(_dioException(DioExceptionType.unknown));

        final result = await repository.getAlbumTracks('123');

        result.fold(
          (f) => expect(f, isA<NetworkFailure>()),
          (_) => fail('Expected Left'),
        );
      },
    );
  });

  group('getAlbumTracks() — server failure', () {
    test('returns Left(ServerFailure) on badResponse', () async {
      when(
        () => mockDatasource.fetchAlbumTracks('123'),
      ).thenThrow(_dioException(DioExceptionType.badResponse));

      final result = await repository.getAlbumTracks('123');

      result.fold(
        (f) => expect(f, isA<ServerFailure>()),
        (_) => fail('Expected Left'),
      );
    });
  });

  group('getAlbumTracks() — unexpected error', () {
    test('returns Left(UnknownFailure) on generic Exception', () async {
      when(
        () => mockDatasource.fetchAlbumTracks('123'),
      ).thenThrow(Exception('parse error'));

      final result = await repository.getAlbumTracks('123');

      result.fold(
        (f) => expect(f, isA<UnknownFailure>()),
        (_) => fail('Expected Left'),
      );
    });
  });
}
