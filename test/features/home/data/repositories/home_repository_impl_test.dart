import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_learning_project_2/core/data/models/album_model.dart';
import 'package:flutter_learning_project_2/core/domain/entities/album.dart';
import 'package:flutter_learning_project_2/core/domain/failure/failure.dart';
import 'package:flutter_learning_project_2/features/home/data/datasources/home_remote_datasource.dart';
import 'package:flutter_learning_project_2/features/home/data/repositories/home_repository_impl.dart';

class MockHomeRemoteDatasource extends Mock implements HomeRemoteDatasource {}

/// Helper: build a minimal [DioException] with the given [type].
DioException _dioException(DioExceptionType type) => DioException(
  requestOptions: RequestOptions(path: '/test'),
  type: type,
);

void main() {
  late MockHomeRemoteDatasource mockDatasource;
  late HomeRepositoryImpl repository;

  setUp(() {
    mockDatasource = MockHomeRemoteDatasource();
    repository = HomeRepositoryImpl(mockDatasource);
  });

  final tAlbums = [
    const AlbumModel(
      id: '1',
      name: 'Album A',
      artistName: 'Artist A',
      imageUrl: 'https://example.com/a.jpg',
    ),
    const AlbumModel(
      id: '2',
      name: 'Album B',
      artistName: 'Artist B',
      imageUrl: 'https://example.com/b.jpg',
    ),
  ];

  group('getTopAlbums() — success', () {
    test('returns Right(List<Album>) when datasource succeeds', () async {
      when(
        () => mockDatasource.fetchTopAlbums(),
      ).thenAnswer((_) async => tAlbums);

      final result = await repository.getTopAlbums();

      expect(result, isA<Right<Failure, List<Album>>>());
      result.fold(
        (_) => fail('Expected Right'),
        (albums) => expect(albums.length, 2),
      );
    });

    test('returns empty list when datasource returns empty', () async {
      when(() => mockDatasource.fetchTopAlbums()).thenAnswer((_) async => []);

      final result = await repository.getTopAlbums();

      result.fold(
        (_) => fail('Expected Right'),
        (albums) => expect(albums, isEmpty),
      );
    });
  });

  group('getTopAlbums() — network failures', () {
    test('returns Left(NetworkFailure) on connectionTimeout', () async {
      when(
        () => mockDatasource.fetchTopAlbums(),
      ).thenThrow(_dioException(DioExceptionType.connectionTimeout));

      final result = await repository.getTopAlbums();

      expect(result.isLeft(), isTrue);
      result.fold(
        (f) => expect(f, isA<NetworkFailure>()),
        (_) => fail('Expected Left'),
      );
    });

    test('returns Left(NetworkFailure) on receiveTimeout', () async {
      when(
        () => mockDatasource.fetchTopAlbums(),
      ).thenThrow(_dioException(DioExceptionType.receiveTimeout));

      final result = await repository.getTopAlbums();

      result.fold(
        (f) => expect(f, isA<NetworkFailure>()),
        (_) => fail('Expected Left'),
      );
    });

    test('returns Left(NetworkFailure) on connectionError', () async {
      when(
        () => mockDatasource.fetchTopAlbums(),
      ).thenThrow(_dioException(DioExceptionType.connectionError));

      final result = await repository.getTopAlbums();

      result.fold(
        (f) => expect(f, isA<NetworkFailure>()),
        (_) => fail('Expected Left'),
      );
    });
  });

  group('getTopAlbums() — server failure', () {
    test('returns Left(ServerFailure) on non-timeout DioException', () async {
      when(
        () => mockDatasource.fetchTopAlbums(),
      ).thenThrow(_dioException(DioExceptionType.badResponse));

      final result = await repository.getTopAlbums();

      result.fold(
        (f) => expect(f, isA<ServerFailure>()),
        (_) => fail('Expected Left'),
      );
    });
  });

  group('getTopAlbums() — unknown failure', () {
    test('returns Left(UnknownFailure) on unexpected exception', () async {
      when(
        () => mockDatasource.fetchTopAlbums(),
      ).thenThrow(Exception('Completely unexpected'));

      final result = await repository.getTopAlbums();

      result.fold(
        (f) => expect(f, isA<UnknownFailure>()),
        (_) => fail('Expected Left'),
      );
    });
  });
}
