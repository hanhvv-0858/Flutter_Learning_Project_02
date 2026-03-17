import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import 'package:example_flutter_02/core/domain/entities/album.dart';
import 'package:example_flutter_02/core/domain/failure/failure.dart';
import 'package:example_flutter_02/core/domain/usecase/usecase.dart';
import 'package:example_flutter_02/features/search/domain/repositories/search_repository.dart';

/// Searches albums from the iTunes Search API.
@lazySingleton
class SearchAlbums extends UseCase<List<Album>, SearchAlbumsParam> {
  SearchAlbums(this._repository);

  final SearchRepository _repository;

  @override
  Future<Either<Failure, List<Album>>> call(SearchAlbumsParam params) =>
      _repository.searchAlbums(params.query);
}

/// Input parameter carrying the search query string.
class SearchAlbumsParam extends Equatable {
  const SearchAlbumsParam(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}
