import 'package:json_annotation/json_annotation.dart';

import 'package:example_flutter_02/core/domain/entities/track.dart';

part 'track_model.g.dart';

/// Data transfer object for [Track], adding JSON serialization
/// for the iTunes Lookup API response format.
@JsonSerializable()
class TrackModel extends Track {
  const TrackModel({
    required super.id,
    required super.name,
    required super.durationMs,
    required super.trackNumber,
  });

  /// Parses a single track entry from the iTunes Lookup API.
  ///
  /// Only call this on items where `wrapperType == "track"`.
  /// The first result in Lookup responses is always the "collection" (album)
  /// and must be filtered out before calling this factory.
  factory TrackModel.fromItunesLookup(Map<String, dynamic> json) {
    return TrackModel(
      id: (json['trackId'] as num?)?.toString() ?? '',
      name: json['trackName'] as String? ?? '',
      durationMs: (json['trackTimeMillis'] as num?)?.toInt() ?? 0,
      trackNumber: (json['trackNumber'] as num?)?.toInt() ?? 0,
    );
  }

  /// Standard fromJson for internal caching / serialization.
  factory TrackModel.fromJson(Map<String, dynamic> json) =>
      _$TrackModelFromJson(json);

  Map<String, dynamic> toJson() => _$TrackModelToJson(this);
}
