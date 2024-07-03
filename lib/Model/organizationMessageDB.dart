import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'organization_chat.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE organizations (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE messages (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        organizationId INTEGER,
        sender TEXT,
        message TEXT,
        timestamp TEXT,
        FOREIGN KEY (organizationId) REFERENCES organizations (id)
      )
    ''');
  }

  Future<void> insertOrganization(Map<String, dynamic> organization) async {
    final db = await database;
    await db.insert('organizations', organization);
  }

  Future<void> insertMessage(Map<String, dynamic> message) async {
    final db = await database;
    await db.insert('messages', message);
  }

  Future<List<Map<String, dynamic>>> getOrganizations() async {
    final db = await database;
    return await db.query('organizations');
  }

  Future<List<Map<String, dynamic>>> getMessages(int organizationId) async {
    final db = await database;
    return await db.query('messages',
        where: 'organizationId = ?',
        whereArgs: [organizationId],
        orderBy: 'timestamp DESC');
  }
}
