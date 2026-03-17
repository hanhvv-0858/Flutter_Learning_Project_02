import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'package:example_flutter_02/core/domain/entities/album.dart';
import 'package:example_flutter_02/core/domain/failure/failure.dart';
import 'package:example_flutter_02/features/search/data/datasources/search_remote_datasource.dart';
import 'package:example_flutter_02/features/search/domain/repositories/search_repository.dart';

/// Concrete implementation of [SearchRepository].
///
/// Maps datasource exceptions to domain [Failure] types (per C029, C030).
@LazySingleton(as: SearchRepository)
class SearchRepositoryImpl implements SearchRepository {
  SearchRepositoryImpl(this._remoteDatasource);

  final SearchRemoteDatasource _remoteDatasource;

  @override
  Future<Either<Failure, List<Album>>> searchAlbums(String query) async {
    try {
      final albums = await _remoteDatasource.searchAlbums(query);
      return Right(albums);
    } on DioException catch (e, st) {
      log(
        'searchAlbums DioException — type: ${e.type.name} | msg: ${e.message}',
        error: e.error,
        stackTrace: st,
        name: 'SearchRepositoryImpl',
      );

      final isNetworkError =
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError ||
          (e.type == DioExceptionType.unknown && e.response == null);

      if (isNetworkError) {
        return const Left(
          NetworkFailure(
            'Unable to reach iTunes. Please check your connection.',
          ),
        );
      }
      return Left(
        ServerFailure('Server error: ${e.response?.statusCode ?? e.type.name}'),
      );
    } catch (e, st) {
      log(
        'searchAlbums unexpected error',
        error: e,
        stackTrace: st,
        name: 'SearchRepositoryImpl',
      );
      return const Left(UnknownFailure('An unexpected error occurred.'));
    }
  }
}
