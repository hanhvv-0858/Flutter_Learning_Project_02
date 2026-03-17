import 'package:equatable/equatable.dart';

import 'package:example_flutter_02/core/domain/entities/album.dart';

/// States emitted by [SearchBloc].
sealed class SearchState {
  const SearchState();
}

/// Initial state — search bar is empty, no results shown.
class SearchInitial extends SearchState {
  const SearchInitial();
}

/// A search request is in flight.
class SearchLoading extends SearchState {
  const SearchLoading();
}

/// Search returned results.
final class SearchLoaded extends SearchState with EquatableMixin {
  const SearchLoaded(this.albums);

  final List<Album> albums;

  @override
  List<Object?> get props => [albums];
}

/// Search returned zero results.
class SearchEmpty extends SearchState {
  const SearchEmpty();
}

/// Search failed with an error.
final class SearchError extends SearchState with EquatableMixin {
  const SearchError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
