/// Events consumed by [HomeBloc] to trigger album fetching.
sealed class HomeEvent {
  const HomeEvent();
}

/// Dispatched when the home screen needs to load (or reload) the album list.
class HomeFetchRequested extends HomeEvent {
  const HomeFetchRequested();
}
