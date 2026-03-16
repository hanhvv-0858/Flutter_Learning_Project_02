import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:example_flutter_02/core/data/datasources/database_helper.dart';
import 'package:example_flutter_02/core/network/dio_client.dart';

/// Registers third-party dependencies that cannot be annotated directly.
///
/// Per C014: all external dependencies injected via GetIt for testability.
@module
abstract class RegisterModule {
  @lazySingleton
  Dio get dio => DioClient.createDio();

  @lazySingleton
  DatabaseHelper get databaseHelper => DatabaseHelper();

  @preResolve
  @lazySingleton
  Future<SharedPreferences> get sharedPreferences =>
      SharedPreferences.getInstance();
}
