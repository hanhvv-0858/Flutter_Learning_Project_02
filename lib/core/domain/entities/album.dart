import 'package:equatable/equatable.dart';

/// Pure domain entity representing a music album.
///
/// Used by Presentation and Domain layers. Contains no serialization logic —
/// that responsibility belongs to [AlbumModel] in the data layer.
class Album extends Equatable {
  final String id;
  final String name;
  final String artistName;
  final String imageUrl;
  final String? releaseDate;
  final String albumType;

  const Album({
    required this.id,
    required this.name,
    required this.artistName,
    required this.imageUrl,
    this.releaseDate,
    this.albumType = 'album',
  });

  @override
  List<Object?> get props => [
    id,
    name,
    artistName,
    imageUrl,
    releaseDate,
    albumType,
  ];
}
