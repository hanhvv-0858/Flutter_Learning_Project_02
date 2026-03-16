import 'package:equatable/equatable.dart';

/// Pure domain entity representing a single track within an album.
///
/// Used by Presentation and Domain layers. Contains no serialization logic —
/// that responsibility belongs to [TrackModel] in the data layer.
class Track extends Equatable {
  final String id;
  final String name;
  final int durationMs;
  final int trackNumber;

  const Track({
    required this.id,
    required this.name,
    required this.durationMs,
    required this.trackNumber,
  });

  @override
  List<Object?> get props => [id, name, durationMs, trackNumber];
}
