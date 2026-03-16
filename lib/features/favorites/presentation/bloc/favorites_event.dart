import 'package:equatable/equatable.dart';

/// Events dispatched to [FavoritesBloc].
sealed class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object?> get props => [];
}

/// Requests loading all favorite albums from local storage.
class FavoritesLoadRequested extends FavoritesEvent {
  const FavoritesLoadRequested();
}

/// Requests removal of a favorite by its album ID.
class FavoritesRemoveRequested extends FavoritesEvent {
  const FavoritesRemoveRequested(this.albumId);

  final String albumId;

  @override
  List<Object?> get props => [albumId];
}
