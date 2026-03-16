import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:example_flutter_02/core/domain/usecase/usecase.dart';
import 'package:example_flutter_02/features/favorites/domain/usecases/get_all_favorites.dart';
import 'package:example_flutter_02/features/favorites/domain/usecases/remove_favorite.dart';
import 'favorites_event.dart';
import 'favorites_state.dart';

/// BLoC that manages the favorites screen lifecycle.
///
/// Loads all favorites on [FavoritesLoadRequested] and removes + reloads
/// on [FavoritesRemoveRequested].
@injectable
class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc(this._getAllFavorites, this._removeFavorite)
    : super(const FavoritesInitial()) {
    on<FavoritesLoadRequested>(_onLoadRequested);
    on<FavoritesRemoveRequested>(_onRemoveRequested);
  }

  final GetAllFavorites _getAllFavorites;
  final RemoveFavorite _removeFavorite;

  Future<void> _onLoadRequested(
    FavoritesLoadRequested event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(const FavoritesLoading());

    final result = await _getAllFavorites(NoParams());

    result.fold(
      (failure) => emit(FavoritesError(failure.message)),
      (albums) => albums.isEmpty
          ? emit(const FavoritesEmpty())
          : emit(FavoritesLoaded(albums)),
    );
  }

  Future<void> _onRemoveRequested(
    FavoritesRemoveRequested event,
    Emitter<FavoritesState> emit,
  ) async {
    final removeResult = await _removeFavorite(
      RemoveFavoriteParam(event.albumId),
    );

    removeResult.fold(
      (failure) => log(
        'removeFavorite failed: ${failure.message}',
        name: 'FavoritesBloc',
      ),
      (_) {
        // Reload the list after successful removal.
        add(const FavoritesLoadRequested());
      },
    );
  }
}
