class EventItem {
  final int id;
  String title;
  String description;
  String block;
  final DateTime date;
  final bool isLocalOnly;

  EventItem({
    required this.id,
    required this.title,
    required this.description,
    required this.block,
    required this.date,
    this.isLocalOnly = false,
  });
}
