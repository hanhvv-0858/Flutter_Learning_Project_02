import 'package:flutter/material.dart';

import 'package:flutter_learning_project_2/core/domain/entities/album.dart';
import 'package:flutter_learning_project_2/core/widgets/cached_image.dart';

/// A single album row in the search results list.
class SearchResultItem extends StatelessWidget {
  const SearchResultItem({required this.album, required this.onTap, super.key});

  final Album album;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: _SearchResultContent(album: album),
      ),
    );
  }
}

/// Row content — extracted to keep [SearchResultItem] nesting ≤ 4.
class _SearchResultContent extends StatelessWidget {
  const _SearchResultContent({required this.album});

  final Album album;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          _SearchResultArtwork(imageUrl: album.imageUrl),
          const SizedBox(width: 12),
          Expanded(
            child: _SearchResultInfo(
              name: album.name,
              artistName: album.artistName,
            ),
          ),
          Icon(Icons.chevron_right, color: theme.colorScheme.onSurfaceVariant),
        ],
      ),
    );
  }
}

/// Rounded album cover art.
class _SearchResultArtwork extends StatelessWidget {
  const _SearchResultArtwork({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CachedImage(imageUrl: imageUrl, width: 56, height: 56),
    );
  }
}

/// Album name and artist text column.
class _SearchResultInfo extends StatelessWidget {
  const _SearchResultInfo({required this.name, required this.artistName});

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
