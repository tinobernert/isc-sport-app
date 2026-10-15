enum AttendanceStatus { present, excused, unexcused }

class Student {
  final String id;
  final String firstName;
  final String lastName;
  AttendanceStatus status;
  String score;

  Student({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.status = AttendanceStatus.present,
    this.score = '',
  });
}
