import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:example_flutter_02/core/domain/usecase/usecase.dart';
import 'package:example_flutter_02/features/home/domain/usecases/get_top_albums.dart';
import 'home_event.dart';
import 'home_state.dart';

/// BLoC that manages the home screen's album list lifecycle.
///
/// 📚 CLEAN ARCHITECTURE — PRESENTATION LAYER (BLoC)
/// The BLoC receives UI events (e.g. HomeFetchRequested) and calls
/// use cases from the domain layer. It never directly touches datasources
/// or repositories — only the abstract UseCase interface.
///
/// State flow: Event → BLoC → UseCase → Repository → Datasource
///                               ↓
///                          `Either<Failure, T>`
///                               ↓
///                     BLoC emits new State
///
/// Registered as a factory — a fresh instance per [BlocProvider] so
/// each screen mount starts with a clean [HomeInitial] state.
@injectable
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(this._getTopAlbums) : super(const HomeInitial()) {
    on<HomeFetchRequested>(_onFetchRequested);
  }

  final GetTopAlbums _getTopAlbums;

  Future<void> _onFetchRequested(
    HomeFetchRequested event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeLoading());

    final result = await _getTopAlbums(NoParams());

    result.fold(
      (failure) => emit(HomeError(failure.message)),
      (albums) => emit(HomeLoaded(albums)),
    );
  }
}
