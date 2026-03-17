import 'package:flutter/material.dart';

import 'package:flutter_learning_project_2/core/domain/entities/album.dart';
import 'package:flutter_learning_project_2/core/widgets/cached_image.dart';

/// A single row in the favorites list, wrapped in [Dismissible] for
/// swipe-to-delete functionality.
class FavoriteListItem extends StatelessWidget {
  const FavoriteListItem({
    required this.album,
    required this.onTap,
    required this.onDismissed,
    super.key,
  });

  final Album album;
  final VoidCallback onTap;
  final VoidCallback onDismissed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dismissible(
      key: ValueKey(album.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismissed(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        color: theme.colorScheme.error,
        child: Icon(Icons.delete, color: theme.colorScheme.onError),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                _FavoriteArtwork(imageUrl: album.imageUrl),
                const SizedBox(width: 12),
                Expanded(
                  child: _FavoriteInfo(
                    name: album.name,
                    artistName: album.artistName,
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Rounded album cover art — extracted to keep [FavoriteListItem] nesting ≤ 4.
class _FavoriteArtwork extends StatelessWidget {
  const _FavoriteArtwork({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CachedImage(imageUrl: imageUrl, width: 64, height: 64),
    );
  }
}

/// Album name and artist text column.
class _FavoriteInfo extends StatelessWidget {
  const _FavoriteInfo({required this.name, required this.artistName});

  final String name;
  final String artistName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleSmall,
        ),
        const SizedBox(height: 4),
        Text(
          artistName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
