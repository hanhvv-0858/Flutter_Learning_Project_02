import 'package:equatable/equatable.dart';
import 'package:example_flutter_02/core/domain/entities/album.dart';

/// States emitted by [HomeBloc] representing the album list lifecycle.
sealed class HomeState {
  const HomeState();
}

/// Initial state before any fetch has been triggered.
class HomeInitial extends HomeState {
  const HomeInitial();
}

/// A fetch is in progress.
class HomeLoading extends HomeState {
  const HomeLoading();
}

/// Albums have been successfully loaded.
final class HomeLoaded extends HomeState with EquatableMixin {
  const HomeLoaded(this.albums);

  final List<Album> albums;

  @override
  List<Object?> get props => [albums];
}

/// An error occurred during fetching.
final class HomeError extends HomeState with EquatableMixin {
  const HomeError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
