import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const String _databaseName = 'user_database.db';
  static const int _databaseVersion = 1;

  static const String tableUsernames = 'usernames';
  static const String columnId = 'id';
  static const String columnUsername = 'username';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    print('Database path: $path');
    return openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableUsernames (
        $columnId INTEGER PRIMARY KEY,
        $columnUsername TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertUsername(String username) async {
    Database db = await database;
    print('Inserting username: $username');
    return await db.insert(
      tableUsernames,
      {columnUsername: username},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<String>> getUsernames() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableUsernames);
    print('Retrieved usernames: $maps');
    return maps.map((e) => e[columnUsername] as String).toList();
  }

  Future<void> clearAllUsernames() async {
    Database db = await database;
    await db.delete(tableUsernames);
  }

  Future<void> updateUsername(String oldUsername, String newUsername) async {
    final db = await database;
    await db.update(
      tableUsernames,
      {columnUsername: newUsername},
      where: '$columnUsername = ?',
      whereArgs: [oldUsername],
    );
  }

  Future<void> deleteUsername(String username) async {
    final db = await database;
    await db.delete(
      tableUsernames,
      where: '$columnUsername = ?',
      whereArgs: [username],
    );
  }
}
