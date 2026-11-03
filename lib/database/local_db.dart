import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabase {
  LocalDatabase._();

  static final LocalDatabase instance = LocalDatabase._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    //Brauch man damit die App auf Web und Desktop funktioniert -> kann dann später entfernt werden
    final dbPath = kIsWeb
        ? 'sportpoint_local.db'
        : join(
            await getDatabasesPath(),
            'sportpoint_local.db',
          );

    _database = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE disziplin (
            DID INTEGER PRIMARY KEY,
            Name TEXT NOT NULL,
            Einheit TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE Block (
            BID INTEGER PRIMARY KEY,
            Name TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE Klasse (
            KID INTEGER PRIMARY KEY,
            FID INTEGER NOT NULL,
            Name TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE Schueler (
            SID INTEGER PRIMARY KEY,
            KID INTEGER NOT NULL,
            Vorname TEXT NOT NULL,
            Nachname TEXT NOT NULL
          )
        ''');
      },
    );

    return _database!;
  }

  Future<void> deleteDatabaseFile() async {

    //Kann dann ebenso später entfernt werden
    final dbPath = kIsWeb
        ? 'sportpoint_local.db'
        : join(
            await getDatabasesPath(),
            'sportpoint_local.db',
          );

    final db = _database;

    if (db != null) {
      await db.close();
      _database = null;
    }

    await deleteDatabase(dbPath);

    if (kDebugMode) {
      debugPrint('Lokale Datenbank gelöscht: $dbPath');
    }
  }
}