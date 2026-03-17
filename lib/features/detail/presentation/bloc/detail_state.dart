import 'package:equatable/equatable.dart';

import 'package:flutter_learning_project_2/core/domain/entities/album.dart';
import 'package:flutter_learning_project_2/core/domain/entities/track.dart';

/// States emitted by [DetailBloc] representing the detail screen lifecycle.
sealed class DetailState {
  const DetailState();
}

/// Initial state before any load has been triggered.
class DetailInitial extends DetailState {
  const DetailInitial();
}

/// Tracks are being fetched; the [album] header info is already available.
class DetailLoading extends DetailState {
  const DetailLoading(this.album);

  final Album album;
}

/// Album tracks and favorite status have been successfully loaded.
final class DetailLoaded extends DetailState with EquatableMixin {
  const DetailLoaded({
    required this.album,
    required this.tracks,
    required this.isFavorite,
  });

  final Album album;
  final List<Track> tracks;
  final bool isFavorite;

  DetailLoaded copyWith({Album? album, List<Track>? tracks, bool? isFavorite}) {
    return DetailLoaded(
      album: album ?? this.album,
      tracks: tracks ?? this.tracks,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object?> get props => [album, tracks, isFavorite];
}

/// An error occurred during fetching; [album] is kept for retry purposes.
final class DetailError extends DetailState with EquatableMixin {
  const DetailError({required this.album, required this.message});

  final Album album;
  final String message;

  @override
  List<Object?> get props => [album, message];
}
