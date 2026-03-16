import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'package:example_flutter_02/core/domain/entities/track.dart';
import 'package:example_flutter_02/core/domain/failure/failure.dart';
import 'package:example_flutter_02/features/detail/data/datasources/detail_remote_datasource.dart';
import 'package:example_flutter_02/features/detail/domain/repositories/detail_repository.dart';

/// Concrete implementation of [DetailRepository].
///
/// Maps datasource exceptions to domain [Failure] types so the domain
/// and presentation layers never see Dio-specific errors (per C029, C030).
@LazySingleton(as: DetailRepository)
class DetailRepositoryImpl implements DetailRepository {
  DetailRepositoryImpl(this._remoteDatasource);

  final DetailRemoteDatasource _remoteDatasource;

  @override
  Future<Either<Failure, List<Track>>> getAlbumTracks(String albumId) async {
    try {
      final tracks = await _remoteDatasource.fetchAlbumTracks(albumId);
      return Right(tracks);
    } on DioException catch (e, st) {
      log(
        'getAlbumTracks DioException — type: ${e.type.name} | msg: ${e.message}',
        error: e.error,
        stackTrace: st,
        name: 'DetailRepositoryImpl',
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
        'getAlbumTracks unexpected error',
        error: e,
        stackTrace: st,
        name: 'DetailRepositoryImpl',
      );
      return const Left(UnknownFailure('An unexpected error occurred.'));
    }
  }
}
