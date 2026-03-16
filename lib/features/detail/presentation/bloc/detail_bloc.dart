import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:example_flutter_02/core/domain/entities/track.dart';
import 'package:example_flutter_02/features/detail/domain/usecases/get_album_tracks.dart';
import 'package:example_flutter_02/features/favorites/domain/usecases/check_is_favorite.dart';
import 'package:example_flutter_02/features/favorites/domain/usecases/remove_favorite.dart';
import 'package:example_flutter_02/features/favorites/domain/usecases/save_favorite.dart';
import 'detail_event.dart';
import 'detail_state.dart';

/// BLoC that manages album detail screen: track loading + favorite toggle.
///
/// Registered as a factory so each Detail screen gets a fresh instance.
@injectable
class DetailBloc extends Bloc<DetailEvent, DetailState> {
  DetailBloc(
    this._getAlbumTracks,
    this._checkIsFavorite,
    this._saveFavorite,
    this._removeFavorite,
  ) : super(const DetailInitial()) {
    on<DetailLoadRequested>(_onLoadRequested);
    on<DetailToggleFavorite>(_onToggleFavorite);
  }

  final GetAlbumTracks _getAlbumTracks;
  final CheckIsFavorite _checkIsFavorite;
  final SaveFavorite _saveFavorite;
  final RemoveFavorite _removeFavorite;

  Future<void> _onLoadRequested(
    DetailLoadRequested event,
    Emitter<DetailState> emit,
  ) async {
    emit(DetailLoading(event.album));

    // Fetch tracks and check favorite status in parallel.
    final results = await Future.wait([
      _getAlbumTracks(AlbumIdParam(event.album.id)),
      _checkIsFavorite(CheckIsFavoriteParam(event.album.id)),
    ]);

    final tracksResult = results[0];
    final favoriteResult = results[1];

    // Default to false if the favorite check fails.
    final isFavorite = favoriteResult.fold((_) => false, (val) => val as bool);

    tracksResult.fold(
      (failure) =>
          emit(DetailError(album: event.album, message: failure.message)),
      (tracks) => emit(
        DetailLoaded(
          album: event.album,
          tracks: List<Track>.from(tracks as List),
          isFavorite: isFavorite,
        ),
      ),
    );
  }

  Future<void> _onToggleFavorite(
    DetailToggleFavorite event,
    Emitter<DetailState> emit,
  ) async {
    final current = state;
    if (current is! DetailLoaded) return;

    if (current.isFavorite) {
      final result = await _removeFavorite(RemoveFavoriteParam(event.album.id));
      result.fold(
        (failure) => log(
          'removeFavorite failed: ${failure.message}',
          name: 'DetailBloc',
        ),
        (_) => emit(current.copyWith(isFavorite: false)),
      );
    } else {
      final result = await _saveFavorite(event.album);
      result.fold(
        (failure) =>
            log('saveFavorite failed: ${failure.message}', name: 'DetailBloc'),
        (_) => emit(current.copyWith(isFavorite: true)),
      );
    }
  }
}
