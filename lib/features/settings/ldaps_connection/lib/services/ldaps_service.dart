
import 'package:dartdap/dartdap.dart';

import '../models/block.dart';
import '../models/klasse.dart';
import '../models/schueler.dart';

// --------------------------------------------------
// ERGEBNIS DES LDAP-IMPORTS
// --------------------------------------------------

class LdapsImportResult {
  final List<Block> blocks;
  final List<Klasse> klassen;
  final List<Schueler> schueler;

  LdapsImportResult({
    required this.blocks,
    required this.klassen,
    required this.schueler,
  });
}

class LdapsService {

  // --------------------------------------------------
  // 1. SCHÜLER AUS DEM LDAP AUSLESEN
  // --------------------------------------------------

  Future<List<Map<String, dynamic>>> getStudents({
    required String host,
    required String bindDn,
    required String password,
    required String searchBase,
  }) async {

    final connection = LdapConnection(
      host: host,
      ssl: true,
      port: 636,
      bindDN: DN(bindDn),
      password: password,
    );

    final List<Map<String, dynamic>> students = [];

    try {
      print('Verbinde mit LDAPS-Server ...');

      await connection.open();
      print('TLS-Verbindung erfolgreich.');

      await connection.bind();
      print('LDAP-Anmeldung erfolgreich!');

      final attributes = [
        'cn',
        'displayName',
        'givenName',
        'sn',
        'sAMAccountName',
        'sophomorixAdminClass',
      ];

      final filter = Filter.and([
        Filter.equals('objectClass', 'user'),
        Filter.present('displayName'),
      ]);

      final searchResult = await connection.search(
        DN(searchBase),
        filter,
        attributes,
        scope: SearchScope.SUB_LEVEL,
      );

      print('LDAP-Suche gestartet...');

      await for (final entry in searchResult.stream) {

        final dn = entry.dn.toString();

        // Klasse anhand der OU ermitteln
        final ouMatches = RegExp(
          r'(?:^|,)OU=([^,]+)',
          caseSensitive: false,
        ).allMatches(dn).toList();

        if (ouMatches.isEmpty) {
          continue;
        }

        final klasse = ouMatches.first.group(1)!.trim();

        final Map<String, dynamic> student = {};

        student['dn'] = dn;
        student['klasse'] = klasse;

        // LDAP-Attribute übernehmen
        for (final attribute in entry.attributes.values) {

          final values = attribute.values
              .map((value) => value.toString())
              .toList();

          student[attribute.name] = values.length == 1
              ? values.first
              : values;
        }

        // Benutzername bestimmen
        student['username'] =
            student['sAMAccountName'] ??
            student['displayName'] ??
            student['cn'];

        students.add(student);
      }

      print('-------------------------');
      print('LDAP-Export abgeschlossen.');
      print('Gefundene Schüler: ${students.length}');
      print('-------------------------');

      return students;

    } catch (e) {
      print('LDAPS-Fehler: $e');
      rethrow;

    } finally {
      await connection.close();
      print('Verbindung geschlossen.');
    }
  }


  // --------------------------------------------------
  // 2. KLASSENNAMEN VALIDIEREN
  // --------------------------------------------------

  bool isValidClass(String className) {

    final regex = RegExp(
      r'^[a-zA-Z]{2,3}\d{2}[abc]\d*$',
      caseSensitive: false,
    );

    return regex.hasMatch(className.trim());
  }


  // --------------------------------------------------
  // 3. BLOCK AUS KLASSENNAMEN ERMITTELN
  // --------------------------------------------------

  String? getBlockFromClass(String className) {

    final match = RegExp(
      r'([abc])\d*$',
      caseSensitive: false,
    ).firstMatch(className.trim());

    if (match == null) {
      return null;
    }

    return match.group(1)!.toUpperCase();
  }


  // --------------------------------------------------
  // 4. SCHÜLER NACH BLOCK UND KLASSE GRUPPIEREN
  // --------------------------------------------------

  Map<String, Map<String, List<Map<String, dynamic>>>>
      groupByBlockAndClass(
    List<Map<String, dynamic>> students,
  ) {

    final Map<String, Map<String, List<Map<String, dynamic>>>> result = {
      'A': {},
      'B': {},
      'C': {},
    };

    int skippedStudents = 0;

    for (final student in students) {

      final klasse = student['klasse']?.toString() ?? '';

      // Ungültige Klassen überspringen
      if (!isValidClass(klasse)) {
        skippedStudents++;
        continue;
      }

      final block = getBlockFromClass(klasse);

      if (block == null) {
        skippedStudents++;
        continue;
      }

      result[block]!.putIfAbsent(klasse, () => []);

      result[block]![klasse]!.add(student);
    }

    // Klassen und Schüler sortieren
    for (final block in result.keys.toList()) {

      final classes = result[block]!;

      final sortedClassNames = classes.keys.toList()..sort();

      final sortedClasses =
          <String, List<Map<String, dynamic>>>{};

      for (final klasse in sortedClassNames) {

        final classStudents = classes[klasse]!;

        classStudents.sort((a, b) {

          final nameA = a['username']?.toString() ?? '';
          final nameB = b['username']?.toString() ?? '';

          return nameA.toLowerCase().compareTo(
            nameB.toLowerCase(),
          );
        });

        sortedClasses[klasse] = classStudents;
      }

      result[block] = sortedClasses;
    }

    print('-------------------------');
    print('Gruppierung abgeschlossen.');
    print('Übersprungene Benutzer: $skippedStudents');
    print('Block A: ${result['A']!.length} Klassen');
    print('Block B: ${result['B']!.length} Klassen');
    print('Block C: ${result['C']!.length} Klassen');
    print('-------------------------');

    return result;
  }


  // --------------------------------------------------
  // 5. DATENBANKOBJEKTE ERSTELLEN
  // --------------------------------------------------

  LdapsImportResult createDatabaseObjects(
    List<Map<String, dynamic>> students,
  ) {

    final groupedStudents = groupByBlockAndClass(students);

    final List<Block> blocks = [];
    final List<Klasse> klassen = [];
    final List<Schueler> schueler = [];

    // Blöcke erstellen
    blocks.addAll([
      Block(bid: 'A', name: 'A'),
      Block(bid: 'B', name: 'B'),
      Block(bid: 'C', name: 'C'),
    ]);

    // Klassen und Schüler erstellen
    for (final block in ['A', 'B', 'C']) {

      final classes = groupedStudents[block]!;

      for (final klasse in classes.keys) {

        // Klasse erstellen
        klassen.add(
          Klasse(
            kid: klasse,
            bid: block,
            name: klasse,
          ),
        );

        // Schüler erstellen
        for (final student in classes[klasse]!) {

          schueler.add(
            Schueler(
              kid: klasse,
              vorname: student['givenName']?.toString() ?? '',
              nachname: student['sn']?.toString() ?? '',
            ),
          );
        }
      }
    }

    return LdapsImportResult(
      blocks: blocks,
      klassen: klassen,
      schueler: schueler,
    );
  }


  // --------------------------------------------------
  // 6. KOMPLETTEN IMPORT DURCHFÜHREN
  // --------------------------------------------------

  Future<LdapsImportResult> importData({
    required String host,
    required String bindDn,
    required String password,
    required String searchBase,
  }) async {

    // LDAP-Daten abrufen
    final students = await getStudents(
      host: host,
      bindDn: bindDn,
      password: password,
      searchBase: searchBase,
    );

    // Datenbankobjekte erstellen
    final result = createDatabaseObjects(students);

    print('\n================================');
    print('IMPORT ERFOLGREICH');
    print('================================');

    print('Blöcke: ${result.blocks.length}');
    print('Klassen: ${result.klassen.length}');
    print('Schüler: ${result.schueler.length}');

    return result;
  }
}
