import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'package:flutter_learning_project_2/core/data/models/album_model.dart';
import 'package:flutter_learning_project_2/core/network/api_constants.dart';

/// Searches albums from the iTunes Search API via [Dio].
@lazySingleton
class SearchRemoteDatasource {
  SearchRemoteDatasource(this._dio);

  final Dio _dio;

  /// Calls the iTunes Search API with [query] and returns album results.
  ///
  /// Throws [DioException] on network/server errors.
  Future<List<AlbumModel>> searchAlbums(String query) async {
    final response = await _dio.get<dynamic>(
      ApiConstants.searchPath,
      queryParameters: {'term': query, 'entity': 'album', 'limit': 30},
    );

    final dynamic rawData = response.data is String
        ? jsonDecode(response.data as String)
        : response.data;

    final results =
        (rawData as Map<String, dynamic>?)?['results'] as List<dynamic>?;

    if (results == null || results.isEmpty) {
      log(
        'Search returned no results for query="$query"',
        name: 'SearchRemoteDatasource',
      );
      return [];
    }

    return results
        .cast<Map<String, dynamic>>()
        .map(AlbumModel.fromItunesSearch)
        .toList();
  }
}
