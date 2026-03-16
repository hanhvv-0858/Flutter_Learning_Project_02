import 'package:flutter_test/flutter_test.dart';

import 'package:example_flutter_02/core/domain/entities/album.dart';
import 'package:example_flutter_02/core/domain/entities/track.dart';

void main() {
  group('Album entity', () {
    const album1 = Album(
      id: '1',
      name: 'Test Album',
      artistName: 'Test Artist',
      imageUrl: 'https://example.com/image.jpg',
      releaseDate: '2026-01-01',
      albumType: 'album',
    );

    const album2 = Album(
      id: '1',
      name: 'Test Album',
      artistName: 'Test Artist',
      imageUrl: 'https://example.com/image.jpg',
      releaseDate: '2026-01-01',
      albumType: 'album',
    );

    const albumDifferent = Album(
      id: '2',
      name: 'Other Album',
      artistName: 'Other Artist',
      imageUrl: 'https://example.com/other.jpg',
    );

    test('two instances with same fields are equal', () {
      expect(album1, equals(album2));
    });

    test('two instances with different fields are not equal', () {
      expect(album1, isNot(equals(albumDifferent)));
    });

    test('props includes all fields', () {
      expect(album1.props, [
        '1',
        'Test Album',
        'Test Artist',
        'https://example.com/image.jpg',
        '2026-01-01',
        'album',
      ]);
    });

    test('albumType defaults to "album"', () {
      const a = Album(
        id: '3',
        name: 'X',
        artistName: 'Y',
        imageUrl: 'https://example.com/x.jpg',
      );
      expect(a.albumType, 'album');
    });

    test('releaseDate is nullable', () {
      const a = Album(
        id: '4',
        name: 'X',
        artistName: 'Y',
        imageUrl: 'https://example.com/x.jpg',
      );
      expect(a.releaseDate, isNull);
    });
  });

  group('Track entity', () {
    const track1 = Track(
      id: '101',
      name: 'Song One',
      durationMs: 210000,
      trackNumber: 1,
    );

    const track2 = Track(
      id: '101',
      name: 'Song One',
      durationMs: 210000,
      trackNumber: 1,
    );

    const trackDifferent = Track(
      id: '102',
      name: 'Song Two',
      durationMs: 180000,
      trackNumber: 2,
    );

    test('two instances with same fields are equal', () {
      expect(track1, equals(track2));
    });

    test('two instances with different fields are not equal', () {
      expect(track1, isNot(equals(trackDifferent)));
    });

    test('props includes all fields', () {
      expect(track1.props, ['101', 'Song One', 210000, 1]);
    });
  });
}
