class Schueler {
  final int? sid;
  final String kid;
  final String vorname;
  final String nachname;

  Schueler({
    this.sid,
    required this.kid,
    required this.vorname,
    required this.nachname,
  });

  Map<String, dynamic> toMap() {
    return {
      if (sid != null) 'SID': sid,
      'KID': kid,
      'Vorname': vorname,
      'Nachname': nachname,
    };
  }

  factory Schueler.fromMap(Map<String, dynamic> map) {
    return Schueler(
      sid: map['SID'] == null
          ? null
          : (map['SID'] as num).toInt(),
      kid: map['KID'],
      vorname: map['Vorname'],
      nachname: map['Nachname'],
    );
  }
}