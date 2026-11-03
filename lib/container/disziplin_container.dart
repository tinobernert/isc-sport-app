
import '../database/local_db.dart';
import '../models/disziplin.dart';

class DisziplinContainer {
  final LocalDatabase _localDatabase =
      LocalDatabase.instance;

  Future<List<Disziplin>> getAll() async {
    final db = await _localDatabase.database;

    final rows = await db.query('disziplin');

    return rows
        .map((row) => Disziplin.fromMap(row))
        .toList();
  }

  Future<void> insert(Disziplin disziplin) async {
    final db = await _localDatabase.database;

    await db.insert(
      'disziplin',
      disziplin.toMap(),    
      );
  }

  // Future<bool> hasData() async {
  //   final db = await _localDatabase.database;

  //   final rows = await db.query(
  //     'disziplin',
  //     limit: 1,
  //   );

  //   return rows.isNotEmpty;
  // }

  // Future<void> insertTestData() async {
  //   if (await hasData()) {
  //     return;
  //   }

  //   await insert(
  //     const Disziplin(
  //       did: 1,
  //       name: '100-Meter-Lauf',
  //       einheit: 'Sekunden',
  //     ),
  //   );
  // }
}