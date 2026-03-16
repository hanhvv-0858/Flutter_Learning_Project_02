import 'package:flutter_test/flutter_test.dart';

import 'package:example_flutter_02/core/data/models/track_model.dart';

void main() {
  group('TrackModel.fromItunesLookup()', () {
    final trackJson = {
      'wrapperType': 'track',
      'trackId': 111222333,
      'trackName': 'Levitating',
      'trackTimeMillis': 203064,
      'trackNumber': 5,
    };

    test('parses trackId as String id', () {
      final model = TrackModel.fromItunesLookup(trackJson);
      expect(model.id, '111222333');
    });

    test('parses trackName correctly', () {
      final model = TrackModel.fromItunesLookup(trackJson);
      expect(model.name, 'Levitating');
    });

    test('parses trackTimeMillis as durationMs', () {
      final model = TrackModel.fromItunesLookup(trackJson);
      expect(model.durationMs, 203064);
    });

    test('parses trackNumber correctly', () {
      final model = TrackModel.fromItunesLookup(trackJson);
      expect(model.trackNumber, 5);
    });

    test('returns 0 for missing numeric fields', () {
      final model = TrackModel.fromItunesLookup({'wrapperType': 'track'});
      expect(model.durationMs, 0);
      expect(model.trackNumber, 0);
    });

    test('returns empty string for missing trackId and trackName', () {
      final model = TrackModel.fromItunesLookup({'wrapperType': 'track'});
      expect(model.id, '');
      expect(model.name, '');
    });

    test('handles double trackTimeMillis (toInt truncation)', () {
      final model = TrackModel.fromItunesLookup({
        'wrapperType': 'track',
        'trackId': 1,
        'trackName': 'X',
        'trackTimeMillis': 203064.9,
        'trackNumber': 1,
      });
      expect(model.durationMs, 203064);
    });
  });
}
