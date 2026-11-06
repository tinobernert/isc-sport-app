
import 'package:ldaps_connection/services/ldaps_service.dart';

Future<void> main() async {
  final ldapService = LdapsService();

  try {
    final result = await ldapService.importData(
      host: 'iss.industrieschule.de',
      bindDn: 'CN=gr3-itf24b1-binduser,OU=Management,OU=default-school,OU=SCHOOLS,DC=industrieschule,DC=de ',
      password: '&HFMbAyB)R5Cp2C2uY?',
      searchBase:
          'OU=Students,OU=default-school,OU=SCHOOLS,DC=industrieschule,DC=de',
    );

    print('\n========== BLÖCKE ==========');

    print(
      '${'BID'.padRight(20)}'
      '${'Name'}',
    );

    print('-' * 40);

    for (final block in result.blocks) {
      print(
        '${block.bid.padRight(20)}'
        '${block.name}',
      );
    }

    print('\n========== KLASSEN ==========');
    
    print(
      '${'KID'.padRight(20)}'
      '${'BID'.padRight(15)}'
      '${'Name'}',
    );
    
    print('-' * 55);
    
    for (final klasse in result.klassen) {
      print(
        '${klasse.kid.padRight(20)}'
        '${klasse.bid.padRight(15)}'
        '${klasse.name}',
      );
    }

    print('\n========== SCHÜLER ==========');

    print(
      '${'SID'.padRight(20)}'
      '${'KID'.padRight(15)}'
      '${'Vorname'.padRight(20)}'
      '${'Nachname'}',
    );

    print('-' * 75);

    for (final student in result.schueler.take(5)) {
      print(
        'SID: ${student.sid} | '
        'KID: ${student.kid} | '
        '${student.vorname} ${student.nachname}',
      );
    }

    print('\n========== GESAMTÜBERSICHT ==========');

    print('Blöcke: ${result.blocks.length}');
    print('Klassen: ${result.klassen.length}');
    print('Schüler: ${result.schueler.length}');

  } catch (e) {
    print('Import fehlgeschlagen: $e');
  }
}
