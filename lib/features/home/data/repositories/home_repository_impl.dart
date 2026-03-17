import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'package:example_flutter_02/core/domain/entities/album.dart';
import 'package:example_flutter_02/core/domain/failure/failure.dart';
import 'package:example_flutter_02/features/home/data/datasources/home_remote_datasource.dart';
import 'package:example_flutter_02/features/home/domain/repositories/home_repository.dart';

/// Concrete implementation of [HomeRepository].
///
/// 📚 CLEAN ARCHITECTURE — REPOSITORY IMPLEMENTATION
/// This class lives in the DATA layer and implements the abstract
/// repository interface from the DOMAIN layer. It is the single place
/// where raw datasource exceptions (DioException, DatabaseException, etc.)
/// are caught and translated into domain Failure types.
///
/// Key principles:
/// 1. The domain layer never imports Dio, Sqflite, or any data library.
/// 2. Error mapping happens here — the BLoC only sees `Either<Failure, T>`.
/// 3. Registered as @LazySingleton(as: HomeRepository) so GetIt can
///    inject the abstract type anywhere it's needed.
///
/// Maps datasource exceptions to domain [Failure] types so the domain
/// and presentation layers never see Dio-specific errors.
@LazySingleton(as: HomeRepository)
class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl(this._remoteDatasource);

  final HomeRemoteDatasource _remoteDatasource;

  @override
  Future<Either<Failure, List<Album>>> getTopAlbums() async {
    try {
      final albums = await _remoteDatasource.fetchTopAlbums();
      return Right(albums);
    } on DioException catch (e, st) {
      // Log type + underlying error to identify the exact root cause.
      log(
        'getTopAlbums DioException — type: ${e.type.name} | msg: ${e.message}',
        error:
            e.error, // underlying exception (SocketException, FormatException…)
        stackTrace: st,
        name: 'HomeRepositoryImpl',
      );

      final isNetworkError =
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout || // previously missing
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError ||
          // unknown with no HTTP response means a transport-level failure
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
        'getTopAlbums unexpected error',
        error: e,
        stackTrace: st,
        name: 'HomeRepositoryImpl',
      );
      return const Left(UnknownFailure('An unexpected error occurred.'));
    }
  }
}
