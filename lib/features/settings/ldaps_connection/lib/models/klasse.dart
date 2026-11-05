
class Klasse {
  final String kid;
  final String bid;
  final String name;

  Klasse({
    required this.kid,
    required this.bid,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'KID': kid,
      'BID': bid,
      'Name': name,
    };
  }

  factory Klasse.fromMap(Map<String, dynamic> map) {
    return Klasse(
      kid: map['KID'],
      bid: map['BID'],
      name: map['Name'],
    );
  }
}
