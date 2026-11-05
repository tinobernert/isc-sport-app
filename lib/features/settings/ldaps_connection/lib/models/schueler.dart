
class Schueler {
  final String sid;
  final String kid;
  final String vorname;
  final String nachname;

  Schueler({
    required this.sid,
    required this.kid,
    required this.vorname,
    required this.nachname,
  });

  Map<String, dynamic> toMap() {
    return {
      'SID': sid,
      'KID': kid,
      'Vorname': vorname,
      'Nachname': nachname,
    };
  }

  factory Schueler.fromMap(Map<String, dynamic> map) {
    return Schueler(
      sid: map['SID'],
      kid: map['KID'],
      vorname: map['Vorname'],
      nachname: map['Nachname'],
    );
  }
}
