import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';

import 'package:example_flutter_02/core/data/datasources/database_helper.dart';
import 'package:example_flutter_02/features/favorites/data/models/favorite_model.dart';

/// Sqflite data source for the `favorites` table.
///
/// Provides low-level CRUD operations. The repository layer wraps these
/// calls with domain-level error handling (per C033: separate data access).
@lazySingleton
class FavoritesLocalDatasource {
  FavoritesLocalDatasource(this._dbHelper);

  final DatabaseHelper _dbHelper;

  static const _table = 'favorites';

  /// Inserts [model] using INSERT OR REPLACE to handle duplicates.
  Future<void> insertFavorite(FavoriteModel model) async {
    final db = await _dbHelper.database;
    await db.insert(
      _table,
      model.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Deletes the favorite with the given [albumId].
  Future<void> deleteFavorite(String albumId) async {
    final db = await _dbHelper.database;
    await db.delete(_table, where: 'id = ?', whereArgs: [albumId]);
  }

  /// Returns all favorites ordered by most recently saved.
  Future<List<FavoriteModel>> getAllFavorites() async {
    final db = await _dbHelper.database;
    final rows = await db.query(_table, orderBy: 'saved_at DESC');
    return rows.map(FavoriteModel.fromMap).toList();
  }

  /// Returns `true` if an album with [albumId] exists in favorites.
  Future<bool> isFavorite(String albumId) async {
    final db = await _dbHelper.database;
    final rows = await db.query(
      _table,
      where: 'id = ?',
      whereArgs: [albumId],
      limit: 1,
    );
    return rows.isNotEmpty;
  }
}
