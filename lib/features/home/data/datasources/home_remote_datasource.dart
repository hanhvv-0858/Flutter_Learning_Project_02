import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'package:flutter_learning_project_2/core/data/models/album_model.dart';
import 'package:flutter_learning_project_2/core/network/api_constants.dart';

/// Fetches top albums from the iTunes RSS Feed via [Dio].
@lazySingleton
class HomeRemoteDatasource {
  HomeRemoteDatasource(this._dio);

  final Dio _dio;

  /// Calls the iTunes RSS Feed and parses the response into [AlbumModel] list.
  ///
  /// Throws [DioException] on network/server errors — the repository layer
  /// is responsible for mapping these into domain [Failure] types.
  Future<List<AlbumModel>> fetchTopAlbums({
    String country = 'us',
    int limit = 50,
  }) async {
    final path = ApiConstants.getTopAlbumsPath(country: country, limit: limit);

    // Use get<dynamic> because the iTunes RSS endpoint returns
    // Content-Type: text/javascript, which Dio does not auto-decode to Map.
    final response = await _dio.get<dynamic>(path);

    // Explicitly JSON-decode when Dio hands back a raw String.
    final dynamic rawData = response.data is String
        ? jsonDecode(response.data as String)
        : response.data;

    final feed =
        (rawData as Map<String, dynamic>?)?['feed'] as Map<String, dynamic>?;
    final entries = feed?['entry'] as List<dynamic>?;

    if (entries == null || entries.isEmpty) {
      log('RSS feed returned empty entries', name: 'HomeRemoteDatasource');
      return [];
    }

    return entries
        .cast<Map<String, dynamic>>()
        .map(AlbumModel.fromItunesRss)
        .toList();
  }
}
