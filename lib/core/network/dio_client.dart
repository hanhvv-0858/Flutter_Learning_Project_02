import 'package:dio/dio.dart';

import 'package:flutter_learning_project_2/core/network/api_constants.dart';

/// Creates and configures the singleton [Dio] instance for the app.
///
/// Includes connect/receive timeouts and a [LogInterceptor] for debugging.
/// Registered as a lazy singleton via GetIt (see [RegisterModule]).
class DioClient {
  DioClient._();

  static Dio createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.rssBaseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        headers: {'Accept': 'application/json'},
      ),
    );

    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (object) {
          // Uses assert so logs only appear in debug mode — not in release builds.
          assert(() {
            // ignore: avoid_print
            print(object);
            return true;
          }());
        },
      ),
    );

    return dio;
  }
}
