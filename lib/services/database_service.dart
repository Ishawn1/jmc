import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/offline_download_item.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static DatabaseService get instance => _instance;

  static Database? _database;

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

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

  // Insert or update an offline download item
  Future<void> saveOfflineDownload(OfflineDownloadItem item) async {
    final db = await database;
    await db.insert(
      'offline_downloads',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get all offline downloads
  Future<List<OfflineDownloadItem>> getAllOfflineDownloads() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('offline_downloads');

    return List.generate(maps.length, (i) {
      return OfflineDownloadItem.fromMap(maps[i]);
    });
  }

  // Get a specific offline download by id
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

  // Delete an offline download
  Future<void> deleteOfflineDownload(String id) async {
    final db = await database;
    await db.delete(
      'offline_downloads',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Update an offline download
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
