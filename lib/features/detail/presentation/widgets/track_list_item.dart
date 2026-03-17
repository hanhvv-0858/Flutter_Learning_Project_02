import 'package:flutter/material.dart';

import 'package:flutter_learning_project_2/core/domain/entities/track.dart';

/// A single row in the detail track listing.
/// Shows track number, name, and formatted duration (mm:ss).
class TrackListItem extends StatelessWidget {
  const TrackListItem({required this.track, super.key});

  final Track track;

  /// Formats milliseconds into "m:ss" (e.g., 207959 → "3:27").
  static String _formatDuration(int ms) {
    final totalSeconds = ms ~/ 1000;
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            child: Text(
              '${track.trackNumber}',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              track.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodyLarge,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            _formatDuration(track.durationMs),
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
