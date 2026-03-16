import 'package:example_flutter_02/core/domain/entities/album.dart';

/// Events consumed by [DetailBloc] to load tracks and toggle favorites.
sealed class DetailEvent {
  const DetailEvent();
}

/// Dispatched when the detail screen opens with the selected [album].
class DetailLoadRequested extends DetailEvent {
  const DetailLoadRequested(this.album);

  final Album album;
}

/// Dispatched when the user taps the favorite heart button.
class DetailToggleFavorite extends DetailEvent {
  const DetailToggleFavorite(this.album);

  final Album album;
}
