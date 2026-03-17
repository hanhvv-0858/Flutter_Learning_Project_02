import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import 'package:flutter_learning_project_2/core/domain/entities/track.dart';
import 'package:flutter_learning_project_2/core/domain/failure/failure.dart';
import 'package:flutter_learning_project_2/core/domain/usecase/usecase.dart';
import 'package:flutter_learning_project_2/features/detail/domain/repositories/detail_repository.dart';

/// Fetches the track listing for a single album via iTunes Lookup API.
@lazySingleton
class GetAlbumTracks extends UseCase<List<Track>, AlbumIdParam> {
  GetAlbumTracks(this._repository);

  final DetailRepository _repository;

  @override
  Future<Either<Failure, List<Track>>> call(AlbumIdParam params) =>
      _repository.getAlbumTracks(params.albumId);
}

/// Input parameter carrying the album's iTunes collection ID.
class AlbumIdParam extends Equatable {
  const AlbumIdParam(this.albumId);

  final String albumId;

  @override
  List<Object?> get props => [albumId];
}
