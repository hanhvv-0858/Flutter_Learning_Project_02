import 'package:equatable/equatable.dart';

/// Events dispatched to [SearchBloc].
sealed class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

/// Fired on every keystroke in the search field; debounced by the Bloc.
class SearchQueryChanged extends SearchEvent {
  const SearchQueryChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

/// Fired when the user explicitly submits the search (keyboard done/enter).
class SearchSubmitted extends SearchEvent {
  const SearchSubmitted(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}
