class Disziplin {
  final int did;
  final String name;
  final String einheit;

  const Disziplin({
    required this.did,
    required this.name,
    required this.einheit,
  });

  Map<String, Object?> toMap() {
    return {
      'DID': did,
      'Name': name,
      'Einheit': einheit,
    };
  }

  factory Disziplin.fromMap(Map<String, Object?> map) {
    return Disziplin(
      did: map['DID'] as int,
      name: map['Name'] as String,
      einheit: map['Einheit'] as String,
    );
  }
}