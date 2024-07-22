import 'package:b2b_connect/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart' as sql;

class DatabaseHelper {
  static const tblSavedArticles = 'savedArticles';
  static const colId = 'id';
  static const colResults = 'results';
  static const colCreatedAt = 'createdAt';

  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE $tblSavedArticles(
        $colId INTEGER PRIMARY KEY NOT NULL,
        $colResults TEXT,
        $colCreatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);

    await database.execute("CREATE TABLE notifications ("
        "id TEXT,"
        "title TEXT,"
        "tag TEXT,"
        "value TEXT,"
        "body TEXT,"
        "big_picture TEXT,"
        "color TEXT,"
        "time TEXT,"
        "read INTEGER"
        ")");
  }

  static Future<sql.Database> db() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String dbName = appName + preferences.getInt("id")!.toString();
    return sql.openDatabase(
      '$dbName.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  /// Add article
  static Future<int> addArticle(
      {required int? id, required String? result}) async {
    final db = await DatabaseHelper.db();
    final data = {colId: id, colResults: result};
    final value = await db.insert(tblSavedArticles, data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return value;
  }

  /// Get all articles
  static Future<List<Map<String, dynamic>>> getArticles() async {
    final db = await DatabaseHelper.db();
    return db.rawQuery(
        " select * from $tblSavedArticles order by $colCreatedAt desc;");
  }

  /// Get article
  static Future<List<Map<String, dynamic>>> getArticle(int id) async {
    final db = await DatabaseHelper.db();
    return db.query(tblSavedArticles,
        where: "$colId = ?", whereArgs: [id], limit: 1);
  }

  /// Update an article by id
  static Future<int> updateArticle(int id, String? result) async {
    final db = await DatabaseHelper.db();
    final data = {
      colId: id,
      colResults: result,
    };
    final value = await db
        .update(tblSavedArticles, data, where: "$colId = ?", whereArgs: [id]);
    return value;
  }

  /// Delete article
  static Future<void> deleteArticle({required int? id}) async {
    final db = await DatabaseHelper.db();
    try {
      await db.delete(tblSavedArticles, where: "$colId = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an article: $err");
    }
  }
}
