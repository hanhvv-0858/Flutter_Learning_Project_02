import 'package:flutter_learning_project_2/core/domain/entities/album.dart';

/// Data transfer object for persisting [Album] favorites in Sqflite.
///
/// Maps between the domain entity and the flat column structure of the
/// `favorites` table defined in [DatabaseHelper].
class FavoriteModel {
  const FavoriteModel({
    required this.id,
    required this.name,
    required this.artistName,
    required this.imageUrl,
    this.releaseDate,
    required this.albumType,
    required this.savedAt,
  });

  final String id;
  final String name;
  final String artistName;
  final String imageUrl;
  final String? releaseDate;
  final String albumType;
  final String savedAt;

  /// Converts a Sqflite row into a [FavoriteModel].
  factory FavoriteModel.fromMap(Map<String, dynamic> map) {
    return FavoriteModel(
      id: map['id'] as String,
      name: map['name'] as String,
      artistName: map['artist_name'] as String,
      imageUrl: map['image_url'] as String,
      releaseDate: map['release_date'] as String?,
      albumType: map['album_type'] as String,
      savedAt: map['saved_at'] as String,
    );
  }

  /// Converts from a domain [Album] when saving a new favorite.
  factory FavoriteModel.fromAlbum(Album album) {
    return FavoriteModel(
      id: album.id,
      name: album.name,
      artistName: album.artistName,
      imageUrl: album.imageUrl,
      releaseDate: album.releaseDate,
      albumType: album.albumType,
      savedAt: DateTime.now().toUtc().toIso8601String(),
    );
  }

  /// Serializes to a Sqflite-compatible map for INSERT.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'artist_name': artistName,
      'image_url': imageUrl,
      'release_date': releaseDate,
      'album_type': albumType,
      'saved_at': savedAt,
    };
  }

  /// Converts back to a domain [Album] entity.
  Album toAlbum() {
    return Album(
      id: id,
      name: name,
      artistName: artistName,
      imageUrl: imageUrl,
      releaseDate: releaseDate,
      albumType: albumType,
    );
  }
}
