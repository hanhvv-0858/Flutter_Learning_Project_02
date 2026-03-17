import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'package:flutter_learning_project_2/core/data/models/track_model.dart';
import 'package:flutter_learning_project_2/core/network/api_constants.dart';

/// Fetches album tracks from the iTunes Lookup API via [Dio].
@lazySingleton
class DetailRemoteDatasource {
  DetailRemoteDatasource(this._dio);

  final Dio _dio;

  /// Calls the iTunes Lookup API for [albumId] and returns only track entries.
  ///
  /// The first result in the response is always the collection (album) itself
  /// with `wrapperType: "collection"` — it is filtered out automatically.
  ///
  /// Throws [DioException] on network/server errors.
  Future<List<TrackModel>> fetchAlbumTracks(String albumId) async {
    final response = await _dio.get<dynamic>(
      ApiConstants.lookupPath,
      queryParameters: {'id': albumId, 'entity': 'song'},
    );

    final dynamic rawData = response.data is String
        ? jsonDecode(response.data as String)
        : response.data;

    final results =
        (rawData as Map<String, dynamic>?)?['results'] as List<dynamic>?;

    if (results == null || results.isEmpty) {
      log(
        'Lookup returned empty results for albumId=$albumId',
        name: 'DetailRemoteDatasource',
      );
      return [];
    }

    return results
        .cast<Map<String, dynamic>>()
        .where((item) => item['wrapperType'] == 'track')
        .map(TrackModel.fromItunesLookup)
        .toList();
  }
}
