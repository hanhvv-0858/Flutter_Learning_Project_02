import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_learning_project_2/core/l10n/app_localizations.dart';
import 'package:flutter_learning_project_2/core/router/route_constants.dart';
import 'package:flutter_learning_project_2/core/widgets/error_view.dart';
import 'package:flutter_learning_project_2/core/widgets/loading_view.dart';
import 'package:flutter_learning_project_2/features/favorites/presentation/bloc/favorites_bloc.dart';
import 'package:flutter_learning_project_2/features/favorites/presentation/bloc/favorites_event.dart';
import 'package:flutter_learning_project_2/features/favorites/presentation/bloc/favorites_state.dart';
import 'package:flutter_learning_project_2/features/favorites/presentation/widgets/favorite_list_item.dart';

/// Favorites screen listing all saved albums from Sqflite.
///
/// Dispatches [FavoritesLoadRequested] on init and supports
/// swipe-to-delete via [FavoritesRemoveRequested].
///
/// Extends [StatefulWidget] so it can listen to GoRouter navigation events
/// and reload the list whenever the tab becomes visible again — e.g. after
/// the user toggles a favorite in [DetailPage] and returns here.
class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  // go_router 14+: GoRouter itself is not a ChangeNotifier;
  // the delegate is, so we listen there instead.
  ChangeNotifier? _routerDelegate;
  GoRouter? _goRouter;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final router = GoRouter.of(context);
    final delegate = router.routerDelegate as ChangeNotifier;
    if (_routerDelegate != delegate) {
      _routerDelegate?.removeListener(_onRouteChanged);
      _goRouter = router;
      _routerDelegate = delegate;
      delegate.addListener(_onRouteChanged);
    }
  }

  /// Called whenever GoRouter's route configuration changes.
  /// Reloads favorites when this tab is the active route.
  void _onRouteChanged() {
    if (!mounted) return;
    final path = _goRouter?.routerDelegate.currentConfiguration.uri.path;
    if (path == RouteConstants.favorites) {
      context.read<FavoritesBloc>().add(const FavoritesLoadRequested());
    }
  }

  @override
  void dispose() {
    _routerDelegate?.removeListener(_onRouteChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.favoritesTitle)),
      body: BlocBuilder<FavoritesBloc, FavoritesState>(
        builder: (context, state) => switch (state) {
          FavoritesInitial() || FavoritesLoading() => const LoadingView(),
          FavoritesLoaded(:final albums) => RefreshIndicator(
            onRefresh: () async {
              context.read<FavoritesBloc>().add(const FavoritesLoadRequested());
            },
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: albums.length,
              itemBuilder: (context, index) {
                final album = albums[index];
                return FavoriteListItem(
                  album: album,
                  onTap: () => context.push(
                    RouteConstants.detailRoute(album.id),
                    extra: album,
                  ),
                  onDismissed: () {
                    context.read<FavoritesBloc>().add(
                      FavoritesRemoveRequested(album.id),
                    );
                  },
                );
              },
            ),
          ),
          FavoritesEmpty() => Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 64,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.favoritesEmpty,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ),
          FavoritesError(:final message) => ErrorView(
            message: message,
            onRetry: () => context.read<FavoritesBloc>().add(
              const FavoritesLoadRequested(),
            ),
          ),
        },
      ),
    );
  }
}
