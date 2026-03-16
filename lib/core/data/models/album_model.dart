import 'package:json_annotation/json_annotation.dart';

import 'package:example_flutter_02/core/domain/entities/album.dart';

part 'album_model.g.dart';

/// Data transfer object for [Album], adding JSON serialization
/// for iTunes RSS Feed and Search API response formats.
@JsonSerializable()
class AlbumModel extends Album {
  const AlbumModel({
    required super.id,
    required super.name,
    required super.artistName,
    required super.imageUrl,
    super.releaseDate,
    super.albumType,
  });

  /// Parses an entry from the iTunes RSS Feed JSON.
  ///
  /// RSS uses a nested structure with keys like "im:name", "im:artist", etc.
  /// See contracts/itunes-api.md for the full response schema.
  factory AlbumModel.fromItunesRss(Map<String, dynamic> json) {
    final imImages = json['im:image'] as List<dynamic>?;
    final rawImageUrl = imImages != null && imImages.isNotEmpty
        ? (imImages.last as Map<String, dynamic>)['label'] as String? ?? ''
        : '';

    return AlbumModel(
      id:
          ((json['id'] as Map<String, dynamic>?)?['attributes']
                  as Map<String, dynamic>?)?['im:id']
              as String? ??
          '',
      name:
          (json['im:name'] as Map<String, dynamic>?)?['label'] as String? ?? '',
      artistName:
          (json['im:artist'] as Map<String, dynamic>?)?['label'] as String? ??
          '',
      imageUrl: getUpscaledImageUrl(rawImageUrl),
      releaseDate:
          (json['im:releaseDate'] as Map<String, dynamic>?)?['label']
              as String?,
      albumType: 'album',
    );
  }

  /// Parses a result from the iTunes Search API JSON.
  ///
  /// Search uses a flat structure with keys like "collectionId", "collectionName".
  factory AlbumModel.fromItunesSearch(Map<String, dynamic> json) {
    final rawImageUrl = json['artworkUrl100'] as String? ?? '';

    return AlbumModel(
      id: (json['collectionId'] as num?)?.toString() ?? '',
      name: json['collectionName'] as String? ?? '',
      artistName: json['artistName'] as String? ?? '',
      imageUrl: getUpscaledImageUrl(rawImageUrl),
      releaseDate: json['releaseDate'] as String?,
      albumType: 'album',
    );
  }

  /// Standard fromJson for internal caching / serialization.
  factory AlbumModel.fromJson(Map<String, dynamic> json) =>
      _$AlbumModelFromJson(json);

  Map<String, dynamic> toJson() => _$AlbumModelToJson(this);

  /// Replaces small image dimensions (55x55, 60x60, 100x100, 170x170)
  /// with 600x600 for high-resolution artwork display.
  static String getUpscaledImageUrl(String url) {
    if (url.isEmpty) return url;
    return url
        .replaceAll('170x170bb', '600x600bb')
        .replaceAll('100x100bb', '600x600bb')
        .replaceAll('60x60bb', '600x600bb')
        .replaceAll('55x55bb', '600x600bb');
  }
}
