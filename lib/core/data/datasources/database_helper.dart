import 'dart:developer';

import 'package:sqflite/sqflite.dart';

/// Manages the Sqflite database lifecycle: open, create tables, upgrade.
///
/// Registered as a lazy singleton in GetIt via [RegisterModule].
class DatabaseHelper {
  static const String _databaseName = 'music_discovery.db';
  static const int _databaseVersion = 1;

  Database? _database;

  /// Returns the database instance, opening it lazily on first access.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _openDatabase();
    return _database!;
  }

  Future<Database> _openDatabase() async {
    final dbPath = await getDatabasesPath();
    final fullPath = '$dbPath/$_databaseName';

    return openDatabase(
      fullPath,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE favorites (
        id           TEXT PRIMARY KEY,
        name         TEXT NOT NULL,
        artist_name  TEXT NOT NULL,
        image_url    TEXT NOT NULL,
        release_date TEXT,
        album_type   TEXT NOT NULL,
        saved_at     TEXT NOT NULL
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    log(
      'Database upgrade from v$oldVersion to v$newVersion',
      name: 'DatabaseHelper',
    );
  }
}
