import 'package:dartdap/dartdap.dart';

class LdapsService {
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

        final ouMatches = RegExp(
          r'(?:^|,)OU=([^,]+)',
          caseSensitive: false,
        ).allMatches(dn).toList();

        if (ouMatches.isEmpty) {
          print('Kein Klassen-OU gefunden: $dn');
          continue;
        }

        final klasse = ouMatches.first.group(1)!.trim();

        final Map<String, dynamic> student = {};

        student['dn'] = dn;
        student['klasse'] = klasse;

        for (final attribute in entry.attributes.values) {

          final values = attribute.values
            .map((value) => value.toString())
            .toList();

          student[attribute.name] = values.length == 1
            ? values.first
            : values;
        }

        student['username'] = student['displayName'] ?? student['cn'];

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

  Map<String, List<Map<String, dynamic>>> groupByClass(
    List<Map<String, dynamic>> students,
  ) {

    final Map<String, List<Map<String, dynamic>>> groupedStudents = {};

    for (final student in students) {

      final klasse = student['klasse']?.toString() ?? 'Unbekannt';

      groupedStudents.putIfAbsent(klasse, () => []);

      groupedStudents[klasse]!.add(student);
    }

    final sortedClasses = groupedStudents.keys.toList()..sort();

    final Map<String, List<Map<String, dynamic>>> sortedResult = {};

    for (final klasse in sortedClasses) {

      final classStudents = groupedStudents[klasse]!;

      classStudents.sort((a, b) {
        final nameA = a['username']?.toString() ?? '';
        final nameB = b['username']?.toString() ?? '';

        return nameA.toLowerCase().compareTo(nameB.toLowerCase());
      });

      sortedResult[klasse] = classStudents;
    }

    return sortedResult;
  }
}

Future<void> main() async {
  final ldapService = LdapsService();

  try {

    final List<Map<String, dynamic>> students = await ldapService.getStudents(
      host: 'iss.industrieschule.de',
      bindDn: 'CN=gr3-itf24b1-binduser,OU=Management,OU=default-school,OU=SCHOOLS,DC=industrieschule,DC=de',
      password: '&HFMbAyB)R5Cp2C2uY?',
      searchBase: 'OU=Students,OU=default-school,OU=SCHOOLS,DC=industrieschule,DC=de',
    );
    print('\nGefundene Schüler: ${students.length}\n');

    // Schüler gruppieren
    final groupedStudents = ldapService.groupByClass(students);

    print('\n======================================');
    print('SCHÜLERÜBERSICHT NACH KLASSEN');
    print('======================================');

    // Gruppierte Schüler ausgeben
    for (final klasse in groupedStudents.keys) {

      final classStudents = groupedStudents[klasse]!;

      print('\n========== $klasse ==========');

      for (final student in classStudents) {

        print('Benutzer: ${student['username']}');
      }

      print('Schüleranzahl: ${classStudents.length}');
    }

    // Gesamtübersicht
    print('\n======================================');
    print('GESAMTÜBERSICHT');
    print('======================================');

    print('Anzahl Klassen: ${groupedStudents.length}');
    print('Anzahl Schüler: ${students.length}');

  } catch (e) {

    print('Verbindungstest fehlgeschlagen: $e');
  }
}