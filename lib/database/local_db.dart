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
      onConfigure: (db) async {
      // anscheinend sind sqlite standartmäßig FK aus.
      await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE Block (
          BID  TEXT PRIMARY KEY,
          Name TEXT NOT NULL UNIQUE
          )
        ''');

        await db.execute('''
          CREATE TABLE Sportevent (
          SEID       TEXT PRIMARY KEY,
          BID        TEXT NOT NULL,
          Name       TEXT NOT NULL,
          Startdatum TEXT NOT NULL,
          FOREIGN KEY (BID) REFERENCES Block (BID)
          )
        ''');

        await db.execute('''
          CREATE TABLE Klasse (
          KID  TEXT PRIMARY KEY,
          BID  TEXT NOT NULL,
          Name TEXT NOT NULL,
          FOREIGN KEY (BID) REFERENCES Block (BID)
          )
        ''');

        await db.execute('''
          CREATE TABLE Schueler (
          SID      TEXT PRIMARY KEY,
          KID      TEXT NOT NULL,
          Vorname  TEXT NOT NULL,
          Nachname TEXT NOT NULL,
          FOREIGN KEY (KID) REFERENCES Klasse (KID)
          )
        ''');

        await db.execute('''
          CREATE TABLE Gruppe (
          GID  TEXT PRIMARY KEY,
          SEID TEXT NOT NULL,
          Name TEXT NOT NULL,
          FOREIGN KEY (SEID) REFERENCES Sportevent (SEID) ON DELETE CASCADE
          )
        ''');

        await db.execute('''
          CREATE TABLE Schueler_Gruppe (
          SGID TEXT PRIMARY KEY,
          SID  TEXT NOT NULL,
          GID  TEXT NOT NULL,
          UNIQUE (SID, GID),
          FOREIGN KEY (SID) REFERENCES Schueler (SID) ON DELETE CASCADE,
          FOREIGN KEY (GID) REFERENCES Gruppe (GID) ON DELETE CASCADE
          )
        ''');

        await db.execute('''
          CREATE TABLE Disziplin (
          DID                TEXT PRIMARY KEY,
          Name               TEXT NOT NULL,
          Einheit            TEXT NOT NULL,
          Richtung           TEXT NOT NULL
          Gewicht            REAL NOT NULL,
          NurKlassenwertung  INTEGER NOT NULL
          )
        ''');

       await db.execute('''
        CREATE TABLE Sportevent_Disziplin (
          SEID    TEXT NOT NULL,
          DID     TEXT NOT NULL,          
          PRIMARY KEY (SEID, DID),
          FOREIGN KEY (SEID) REFERENCES Sportevent (SEID) ON DELETE CASCADE,
          FOREIGN KEY (DID)  REFERENCES Disziplin (DID)
          )
      '''); 

        await db.execute('''
          CREATE TABLE Ergebnis (
          EID         TEXT PRIMARY KEY,
          SEID        TEXT NOT NULL,
          DID         TEXT NOT NULL,
          SID         TEXT,
          KID         TEXT,
          GID         TEXT,
          Wert        REAL,
          Status      TEXT NOT NULL,
          GeaendertAm TEXT NOT NULL,

 
          UNIQUE (SEID, DID, SID),
          UNIQUE (SEID, DID, KID),
 
          FOREIGN KEY (SEID, DID) REFERENCES Sportevent_Disziplin (SEID, DID),
          FOREIGN KEY (SID) REFERENCES Schueler (SID),
          FOREIGN KEY (KID) REFERENCES Klasse (KID),
          FOREIGN KEY (GID) REFERENCES Gruppe (GID) ON DELETE SET NULL
          )
        ''');

        await db.execute('CREATE INDEX idx_schueler_klasse ON Schueler (KID)');
        await db.execute('CREATE INDEX idx_ergebnis_disziplin ON Ergebnis (SEID, DID)');
        
        await db.insert('Block', {'BID': 'A', 'Name': 'A'});
        await db.insert('Block', {'BID': 'B', 'Name': 'B'});
        await db.insert('Block', {'BID': 'C', 'Name': 'C'});

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

    debugPrint('Lokale Datenbank gelöscht: $dbPath');

  }
}