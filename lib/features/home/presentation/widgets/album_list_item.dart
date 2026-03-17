import 'package:flutter/material.dart';

import 'package:flutter_learning_project_2/core/domain/entities/album.dart';
import 'package:flutter_learning_project_2/core/widgets/cached_image.dart';

/// A card row in the home album list showing cover art, title, artist and date.
class AlbumListItem extends StatelessWidget {
  const AlbumListItem({required this.album, required this.onTap, super.key});

  final Album album;
  final VoidCallback onTap;

  /// Formats an ISO-8601 date string (e.g. "2026-02-27T00:00:00-07:00")
  /// into a human-readable form like "February 27, 2026".
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
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              _AlbumArtwork(imageUrl: album.imageUrl),
              const SizedBox(width: 12),
              Expanded(
                child: _AlbumInfo(
                  name: album.name,
                  artistName: album.artistName,
                  formattedDate: _formatDate(album.releaseDate),
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}

/// Rounded album cover art — extracted to keep [AlbumListItem] nesting ≤ 4.
class _AlbumArtwork extends StatelessWidget {
  const _AlbumArtwork({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CachedImage(imageUrl: imageUrl, width: 80, height: 80),
    );
  }
}

/// Text column showing album name, artist, and release date.
class _AlbumInfo extends StatelessWidget {
  const _AlbumInfo({
    required this.name,
    required this.artistName,
    required this.formattedDate,
  });

  final String name;
  final String artistName;
  final String formattedDate;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          artistName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        if (formattedDate.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            formattedDate,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}
