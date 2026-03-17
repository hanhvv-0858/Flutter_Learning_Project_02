import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:example_flutter_02/core/data/models/album_model.dart';
import 'package:example_flutter_02/core/domain/entities/album.dart';
import 'package:example_flutter_02/core/domain/failure/failure.dart';
import 'package:example_flutter_02/features/search/data/datasources/search_remote_datasource.dart';
import 'package:example_flutter_02/features/search/data/repositories/search_repository_impl.dart';

class MockSearchRemoteDatasource extends Mock
    implements SearchRemoteDatasource {}

DioException _dioException(DioExceptionType type) => DioException(
  requestOptions: RequestOptions(path: '/search'),
  type: type,
);

void main() {
  late MockSearchRemoteDatasource mockDatasource;
  late SearchRepositoryImpl repository;

  setUp(() {
    mockDatasource = MockSearchRemoteDatasource();
    repository = SearchRepositoryImpl(mockDatasource);
  });

  final tAlbums = [
    const AlbumModel(
      id: '1',
      name: 'Found Album',
      artistName: 'Artist',
      imageUrl: 'https://example.com/img.jpg',
    ),
  ];

  group('searchAlbums() — success', () {
    test('returns Right(List<Album>) when datasource succeeds', () async {
      when(
        () => mockDatasource.searchAlbums('test'),
      ).thenAnswer((_) async => tAlbums);

      final result = await repository.searchAlbums('test');

      expect(result, isA<Right<Failure, List<Album>>>());
      result.fold(
        (_) => fail('Expected Right'),
        (albums) => expect(albums.length, 1),
      );
    });

    test('returns Right with empty list when no results', () async {
      when(
        () => mockDatasource.searchAlbums('xyz'),
      ).thenAnswer((_) async => []);

      final result = await repository.searchAlbums('xyz');

      result.fold(
        (_) => fail('Expected Right'),
        (albums) => expect(albums, isEmpty),
      );
    });
  });

  group('searchAlbums() — network failures', () {
    test('returns Left(NetworkFailure) on connectionTimeout', () async {
      when(
        () => mockDatasource.searchAlbums('test'),
      ).thenThrow(_dioException(DioExceptionType.connectionTimeout));

      final result = await repository.searchAlbums('test');

      result.fold(
        (f) => expect(f, isA<NetworkFailure>()),
        (_) => fail('Expected Left'),
      );
    });

    test('returns Left(NetworkFailure) on sendTimeout', () async {
      when(
        () => mockDatasource.searchAlbums('test'),
      ).thenThrow(_dioException(DioExceptionType.sendTimeout));

      final result = await repository.searchAlbums('test');

      result.fold(
        (f) => expect(f, isA<NetworkFailure>()),
        (_) => fail('Expected Left'),
      );
    });

    test('returns Left(NetworkFailure) on receiveTimeout', () async {
      when(
        () => mockDatasource.searchAlbums('test'),
      ).thenThrow(_dioException(DioExceptionType.receiveTimeout));

      final result = await repository.searchAlbums('test');

      result.fold(
        (f) => expect(f, isA<NetworkFailure>()),
        (_) => fail('Expected Left'),
      );
    });

    test('returns Left(NetworkFailure) on connectionError', () async {
      when(
        () => mockDatasource.searchAlbums('test'),
      ).thenThrow(_dioException(DioExceptionType.connectionError));

      final result = await repository.searchAlbums('test');

      result.fold(
        (f) => expect(f, isA<NetworkFailure>()),
        (_) => fail('Expected Left'),
      );
    });

    test(
      'returns Left(NetworkFailure) on unknown with null response',
      () async {
        when(
          () => mockDatasource.searchAlbums('test'),
        ).thenThrow(_dioException(DioExceptionType.unknown));

        final result = await repository.searchAlbums('test');

        result.fold(
          (f) => expect(f, isA<NetworkFailure>()),
          (_) => fail('Expected Left'),
        );
      },
    );
  });

  group('searchAlbums() — server failure', () {
    test('returns Left(ServerFailure) on badResponse', () async {
      when(
        () => mockDatasource.searchAlbums('test'),
      ).thenThrow(_dioException(DioExceptionType.badResponse));

      final result = await repository.searchAlbums('test');

      result.fold(
        (f) => expect(f, isA<ServerFailure>()),
        (_) => fail('Expected Left'),
      );
    });
  });

  group('searchAlbums() — unexpected error', () {
    test('returns Left(UnknownFailure) on generic Exception', () async {
      when(
        () => mockDatasource.searchAlbums('test'),
      ).thenThrow(Exception('parse error'));

      final result = await repository.searchAlbums('test');

      result.fold(
        (f) => expect(f, isA<UnknownFailure>()),
        (_) => fail('Expected Left'),
      );
    });
  });
}
