import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('sportpoint.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  // Hier definieren wir unsere Tabellen für den Offline-Betrieb
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE results (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        student_name TEXT NOT NULL,
        discipline TEXT NOT NULL,
        score REAL NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');
  }

  // Beispiel-Methode: Ergebnis speichern
  Future<int> insertResult(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('results', row);
  }

  // Beispiel-Methode: Alle Ergebnisse auslesen
  Future<List<Map<String, dynamic>>> fetchResults() async {
    final db = await instance.database;
    return await db.query('results', orderBy: 'id DESC');
  }
}