import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:example_flutter_02/core/l10n/app_localizations.dart';
import 'package:example_flutter_02/core/router/route_constants.dart';
import 'package:example_flutter_02/core/widgets/error_view.dart';
import 'package:example_flutter_02/core/widgets/loading_view.dart';
import 'package:example_flutter_02/features/home/presentation/bloc/home_bloc.dart';
import 'package:example_flutter_02/features/home/presentation/bloc/home_event.dart';
import 'package:example_flutter_02/features/home/presentation/bloc/home_state.dart';
import 'package:example_flutter_02/features/home/presentation/widgets/album_list_item.dart';

/// Home screen displaying the top albums from the iTunes RSS Feed.
///
/// Dispatches [HomeFetchRequested] on first build and renders a
/// loading / loaded / error state via [BlocBuilder].
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.homeTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.push(RouteConstants.search),
          ),
        ],
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) => switch (state) {
          HomeInitial() || HomeLoading() => const LoadingView(),
          HomeLoaded(:final albums) => RefreshIndicator(
            onRefresh: () async {
              context.read<HomeBloc>().add(const HomeFetchRequested());
            },
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: albums.length,
              itemBuilder: (context, index) {
                final album = albums[index];
                return AlbumListItem(
                  album: album,
                  onTap: () => context.push(
                    RouteConstants.detailRoute(album.id),
                    extra: album,
                  ),
                );
              },
            ),
          ),
          HomeError(:final message) => ErrorView(
            message: message,
            onRetry: () =>
                context.read<HomeBloc>().add(const HomeFetchRequested()),
          ),
        },
      ),
    );
  }
}
