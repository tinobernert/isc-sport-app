enum AttendanceStatus { present, excused, unexcused }

class Student {
  final String id;
  final String firstName;
  final String lastName;
  AttendanceStatus status;
  String score;
  final bool isLocalOnly;
  bool isModified;

  Student({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.status = AttendanceStatus.present,
    this.score = '',
    this.isLocalOnly = false,
    this.isModified = false,
  });
}
