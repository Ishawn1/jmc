import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/offline_download_item.dart';

/// A service class for managing the local SQLite database.
///
/// This class provides a singleton instance to interact with the database,
/// handling operations such as initialization, creation, and CRUD operations
/// for offline download items.
class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();

  /// The singleton instance of [DatabaseService].
  static DatabaseService get instance => _instance;

  static Database? _database;

  DatabaseService._internal();

  /// Returns the singleton instance of the [Database].
  ///
  /// If the database has not been initialized, this method will call
  /// `_initDatabase` to create and open it.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Initializes the database by opening it and creating the necessary tables.
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'offline_downloads.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE offline_downloads(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        category TEXT NOT NULL,
        url TEXT NOT NULL,
        fileType TEXT,
        localFilePath TEXT,
        status INTEGER NOT NULL,
        progress REAL,
        downloadDate INTEGER
      )
    ''');
  }

  /// Inserts or updates an offline download item in the database.
  Future<void> saveOfflineDownload(OfflineDownloadItem item) async {
    final db = await database;
    await db.insert(
      'offline_downloads',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Retrieves all offline download items from the database.
  Future<List<OfflineDownloadItem>> getAllOfflineDownloads() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('offline_downloads');

    return List.generate(maps.length, (i) {
      return OfflineDownloadItem.fromMap(maps[i]);
    });
  }

  /// Retrieves a specific offline download item by its ID.
  Future<OfflineDownloadItem?> getOfflineDownload(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'offline_downloads',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return OfflineDownloadItem.fromMap(maps.first);
    }
    return null;
  }

  /// Deletes an offline download item from the database.
  Future<void> deleteOfflineDownload(String id) async {
    final db = await database;
    await db.delete(
      'offline_downloads',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Updates the status and other details of an offline download item.
  Future<void> updateOfflineDownloadStatus(String id, DownloadStatus status,
      {String? localFilePath, double? progress, DateTime? downloadDate}) async {
    final db = await database;
    final Map<String, dynamic> values = {
      'status': status.index,
    };

    if (localFilePath != null) values['localFilePath'] = localFilePath;
    if (progress != null) values['progress'] = progress;
    if (downloadDate != null)
      values['downloadDate'] = downloadDate.millisecondsSinceEpoch;

    await db.update(
      'offline_downloads',
      values,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
