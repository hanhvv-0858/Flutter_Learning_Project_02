import 'package:equatable/equatable.dart';

import 'package:flutter_learning_project_2/core/domain/entities/album.dart';

/// States emitted by [FavoritesBloc].
sealed class FavoritesState {
  const FavoritesState();
}

/// Initial state before any load has been triggered.
class FavoritesInitial extends FavoritesState {
  const FavoritesInitial();
}

/// Favorites are being loaded from local storage.
class FavoritesLoading extends FavoritesState {
  const FavoritesLoading();
}

/// Favorites loaded successfully with a non-empty list.
final class FavoritesLoaded extends FavoritesState with EquatableMixin {
  const FavoritesLoaded(this.albums);

  final List<Album> albums;

  @override
  List<Object?> get props => [albums];
}

/// No favorites found — the list is empty.
class FavoritesEmpty extends FavoritesState {
  const FavoritesEmpty();
}

/// An error occurred while loading favorites.
final class FavoritesError extends FavoritesState with EquatableMixin {
  const FavoritesError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
