
class Block {
  final String bid;
  final String name;

  Block({
    required this.bid,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'BID': bid,
      'Name': name,
    };
  }

  factory Block.fromMap(Map<String, dynamic> map) {
    return Block(
      bid: map['BID'],
      name: map['Name'],
    );
  }
}
