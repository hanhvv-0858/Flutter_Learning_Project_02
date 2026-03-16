import 'package:flutter_test/flutter_test.dart';

import 'package:example_flutter_02/core/data/models/album_model.dart';

void main() {
  group('AlbumModel.fromItunesRss()', () {
    // Fixture mirrors the real iTunes RSS API structure exactly:
    // - im:artist has attributes.href (extra field that must be ignored)
    // - im:image URLs use the real mzstatic.com format: .../file.jpg/170x170bb.png
    // - id has both label (full URL) and attributes.im:id (numeric ID)
    // - im:releaseDate has both label (ISO) and attributes.label (human-readable)
    // - category, im:contentType, im:price, im:itemCount are present but not mapped
    const baseImageUrl =
        'https://is1-ssl.mzstatic.com/image/thumb/Music211/v4/ab/cd/ef/abcdef.jpg';

    final rssEntry = {
      'im:name': {'label': 'Radical Optimism'},
      'im:artist': {
        'label': 'Dua Lipa',
        'attributes': {
          'href': 'https://music.apple.com/us/artist/dua-lipa/1031397873?uo=2',
        },
      },
      'im:image': [
        {
          'label': '$baseImageUrl/55x55bb.png',
          'attributes': {'height': '55'},
        },
        {
          'label': '$baseImageUrl/60x60bb.png',
          'attributes': {'height': '60'},
        },
        {
          'label': '$baseImageUrl/170x170bb.png',
          'attributes': {'height': '170'},
        },
      ],
      'id': {
        'label':
            'https://music.apple.com/us/album/radical-optimism/9876543210?uo=2',
        'attributes': {'im:id': '9876543210'},
      },
      'im:releaseDate': {
        'label': '2026-03-01T00:00:00-07:00',
        'attributes': {'label': 'March 1, 2026'},
      },
      'category': {
        'attributes': {'im:id': '14', 'term': 'Pop', 'label': 'Pop'},
      },
      'im:contentType': {
        'im:contentType': {
          'attributes': {'term': 'Album', 'label': 'Album'},
        },
        'attributes': {'term': 'Music', 'label': 'Music'},
      },
      'im:itemCount': {'label': '11'},
      'im:price': {
        'label': r'$9.99',
        'attributes': {'amount': '9.99', 'currency': 'USD'},
      },
      'rights': {'label': '℗ 2026 Some Records'},
      'title': {'label': 'Radical Optimism - Dua Lipa'},
      'link': {
        'attributes': {
          'rel': 'alternate',
          'type': 'text/html',
          'href':
              'https://music.apple.com/us/album/radical-optimism/9876543210?uo=2',
        },
      },
    };

    test('parses id from id.attributes.im:id (not id.label)', () {
      final model = AlbumModel.fromItunesRss(rssEntry);
      expect(model.id, '9876543210');
      // Must NOT use the full URL from id.label
      expect(model.id, isNot(contains('music.apple.com')));
    });

    test('parses name correctly', () {
      final model = AlbumModel.fromItunesRss(rssEntry);
      expect(model.name, 'Radical Optimism');
    });

    test(
      'parses artistName from im:artist.label, ignoring attributes.href',
      () {
        final model = AlbumModel.fromItunesRss(rssEntry);
        expect(model.artistName, 'Dua Lipa');
      },
    );

    test('upscales 170x170bb.png image URL to 600x600bb.png', () {
      final model = AlbumModel.fromItunesRss(rssEntry);
      expect(model.imageUrl, '$baseImageUrl/600x600bb.png');
    });

    test('parses releaseDate from im:releaseDate.label (ISO format)', () {
      final model = AlbumModel.fromItunesRss(rssEntry);
      expect(model.releaseDate, '2026-03-01T00:00:00-07:00');
      // Must NOT use attributes.label ("March 1, 2026")
      expect(model.releaseDate, isNot('March 1, 2026'));
    });

    test('albumType is hardcoded to "album" regardless of im:contentType', () {
      final model = AlbumModel.fromItunesRss(rssEntry);
      expect(model.albumType, 'album');
    });

    test(
      'ignores extra fields (category, im:contentType, im:price, im:itemCount)',
      () {
        // Just verifying the parse succeeds without throwing
        expect(() => AlbumModel.fromItunesRss(rssEntry), returnsNormally);
      },
    );

    test('returns empty strings when fields are missing', () {
      final model = AlbumModel.fromItunesRss({});
      expect(model.id, '');
      expect(model.name, '');
      expect(model.artistName, '');
      expect(model.imageUrl, '');
      expect(model.releaseDate, isNull);
    });

    test('returns empty imageUrl when im:image is empty list', () {
      final model = AlbumModel.fromItunesRss({'im:image': <dynamic>[]});
      expect(model.imageUrl, '');
    });

    test('returns empty id when id.attributes has no im:id key', () {
      final model = AlbumModel.fromItunesRss({
        'id': {
          'label': 'https://music.apple.com/us/album/foo/123',
          'attributes': <String, dynamic>{},
        },
      });
      expect(model.id, '');
    });
  });

  group('AlbumModel.fromItunesSearch()', () {
    final searchResult = {
      'collectionId': 1234567890,
      'collectionName': 'Future Nostalgia',
      'artistName': 'Dua Lipa',
      'artworkUrl100': 'https://example.com/100x100bb.jpg',
      'releaseDate': '2020-03-27T07:00:00Z',
      'collectionType': 'Album',
    };

    test('parses id from collectionId as String', () {
      final model = AlbumModel.fromItunesSearch(searchResult);
      expect(model.id, '1234567890');
    });

    test('parses name from collectionName', () {
      final model = AlbumModel.fromItunesSearch(searchResult);
      expect(model.name, 'Future Nostalgia');
    });

    test('parses artistName correctly', () {
      final model = AlbumModel.fromItunesSearch(searchResult);
      expect(model.artistName, 'Dua Lipa');
    });

    test('upscales 100x100bb artworkUrl to 600x600bb', () {
      final model = AlbumModel.fromItunesSearch(searchResult);
      expect(model.imageUrl, contains('600x600bb'));
      expect(model.imageUrl, isNot(contains('100x100bb')));
    });

    test('returns empty values on missing fields', () {
      final model = AlbumModel.fromItunesSearch({});
      expect(model.id, '');
      expect(model.name, '');
      expect(model.artistName, '');
    });
  });

  group('Image URL upscaling', () {
    // Real mzstatic.com URL format: the size suffix is the last path segment
    // with .png extension (e.g., .../file.jpg/170x170bb.png)
    const originalFile =
        'https://is1-ssl.mzstatic.com/image/thumb/Music211/v4/ab/cd/ef/source.jpg';

    final cases = [
      ('55x55bb', '$originalFile/55x55bb.png'),
      ('60x60bb', '$originalFile/60x60bb.png'),
      ('100x100bb', '$originalFile/100x100bb.png'),
      ('170x170bb', '$originalFile/170x170bb.png'),
    ];

    for (final (dim, imageUrl) in cases) {
      test('replaces $dim.png with 600x600bb.png', () {
        final rss = {
          'im:image': [
            {
              'label': imageUrl,
              'attributes': {'height': '170'},
            },
          ],
        };
        final model = AlbumModel.fromItunesRss(rss);
        expect(model.imageUrl, '$originalFile/600x600bb.png');
        expect(model.imageUrl, isNot(contains(dim)));
      });
    }
  });
}
