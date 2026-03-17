import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:stream_transform/stream_transform.dart';

import 'package:flutter_learning_project_2/features/search/domain/usecases/search_albums.dart';
import 'search_event.dart';
import 'search_state.dart';

/// Debounce duration for live-search keystrokes.
const _debounceDuration = Duration(milliseconds: 300);

/// Applies a debounce to the event stream so rapid keystrokes don't
/// trigger redundant API calls.
EventTransformer<E> _debounce<E>() {
  return (events, mapper) =>
      events.debounce(_debounceDuration).switchMap(mapper);
}

/// BLoC that manages album search lifecycle.
///
/// [SearchQueryChanged] is debounced (300 ms); [SearchSubmitted] fires
/// immediately. Both call the [SearchAlbums] use case and fold the result.
@injectable
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc(this._searchAlbums) : super(const SearchInitial()) {
    on<SearchQueryChanged>(_onQueryChanged, transformer: _debounce());
    on<SearchSubmitted>(_onSubmitted);
  }

  final SearchAlbums _searchAlbums;

  Future<void> _onQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    final query = event.query.trim();
    if (query.isEmpty) {
      emit(const SearchInitial());
      return;
    }
    await _performSearch(query, emit);
  }

  Future<void> _onSubmitted(
    SearchSubmitted event,
    Emitter<SearchState> emit,
  ) async {
    final query = event.query.trim();
    if (query.isEmpty) return;
    await _performSearch(query, emit);
  }

  Future<void> _performSearch(String query, Emitter<SearchState> emit) async {
    emit(const SearchLoading());

    final result = await _searchAlbums(SearchAlbumsParam(query));

    result.fold(
      (failure) => emit(SearchError(failure.message)),
      (albums) => albums.isEmpty
          ? emit(const SearchEmpty())
          : emit(SearchLoaded(albums)),
    );
  }
}
