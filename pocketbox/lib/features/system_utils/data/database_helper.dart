import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'pocketbox.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE clipboard_history(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        content TEXT NOT NULL,
        timestamp INTEGER NOT NULL,
        is_favorite INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  Future<int> insertClip(String content) async {
    final db = await database;
    return await db.insert(
      'clipboard_history',
      {
        'content': content,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'is_favorite': 0,
      },
    );
  }

  Future<List<Map<String, dynamic>>> getClips() async {
    final db = await database;
    return await db.query(
      'clipboard_history',
      orderBy: 'timestamp DESC',
    );
  }

  Future<void> toggleFavorite(int id) async {
    final db = await database;
    await db.rawUpdate('''
      UPDATE clipboard_history
      SET is_favorite = CASE WHEN is_favorite = 0 THEN 1 ELSE 0 END
      WHERE id = ?
    ''', [id]);
  }

  Future<void> deleteClip(int id) async {
    final db = await database;
    await db.delete(
      'clipboard_history',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
} 