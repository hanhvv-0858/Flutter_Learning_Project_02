import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:example_flutter_02/core/domain/entities/album.dart';
import 'package:example_flutter_02/core/l10n/app_localizations.dart';
import 'package:example_flutter_02/core/widgets/cached_image.dart';
import 'package:example_flutter_02/core/widgets/error_view.dart';
import 'package:example_flutter_02/core/widgets/loading_view.dart';
import 'package:example_flutter_02/features/detail/presentation/bloc/detail_bloc.dart';
import 'package:example_flutter_02/features/detail/presentation/bloc/detail_event.dart';
import 'package:example_flutter_02/features/detail/presentation/bloc/detail_state.dart';
import 'package:example_flutter_02/features/detail/presentation/widgets/favorite_button.dart';
import 'package:example_flutter_02/features/detail/presentation/widgets/track_list_item.dart';

/// Album detail screen showing large artwork, metadata, favorite toggle,
/// and the track listing from the iTunes Lookup API.
class DetailPage extends StatelessWidget {
  const DetailPage({required this.album, super.key});

  final Album album;

  /// Formats an ISO-8601 date into "Month DD, YYYY".
  static String _formatDate(String? iso) {
    if (iso == null || iso.isEmpty) return '';
    try {
      final dt = DateTime.parse(iso);
      const months = [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December',
      ];
      return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
    } catch (_) {
      return iso;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: BlocBuilder<DetailBloc, DetailState>(
        builder: (context, state) => switch (state) {
          DetailInitial() || DetailLoading() => CustomScrollView(
            slivers: [
              _buildSliverAppBar(
                context,
                state is DetailLoading ? state.album : album,
                null,
              ),
              const SliverFillRemaining(child: LoadingView()),
            ],
          ),
          DetailLoaded(:final album, :final tracks, :final isFavorite) =>
            CustomScrollView(
              slivers: [
                _buildSliverAppBar(context, album, isFavorite),
                SliverToBoxAdapter(child: _buildAlbumInfo(context, album)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                    child: Text(
                      l10n.detailTracksHeader,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                if (tracks.isEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Center(
                        child: Text(
                          l10n.detailNoTracks,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ),
                    ),
                  )
                else
                  SliverList.builder(
                    itemCount: tracks.length,
                    itemBuilder: (context, index) =>
                        TrackListItem(track: tracks[index]),
                  ),
                const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
              ],
            ),
          DetailError(:final album, :final message) => CustomScrollView(
            slivers: [
              _buildSliverAppBar(context, album, null),
              SliverFillRemaining(
                child: ErrorView(
                  message: message,
                  onRetry: () => context.read<DetailBloc>().add(
                    DetailLoadRequested(album),
                  ),
                ),
              ),
            ],
          ),
        },
      ),
    );
  }

  Widget _buildSliverAppBar(
    BuildContext context,
    Album album,
    bool? isFavorite,
  ) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: CachedImage(
          imageUrl: album.imageUrl,
          width: double.infinity,
          height: 300,
        ),
      ),
      actions: [
        if (isFavorite != null)
          FavoriteButton(
            isFavorite: isFavorite,
            onTap: () =>
                context.read<DetailBloc>().add(DetailToggleFavorite(album)),
          ),
      ],
    );
  }

  Widget _buildAlbumInfo(BuildContext context, Album album) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final formattedDate = _formatDate(album.releaseDate);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            album.name,
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            album.artistName,
            style: textTheme.titleMedium?.copyWith(color: colorScheme.primary),
          ),
          if (formattedDate.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              formattedDate,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
