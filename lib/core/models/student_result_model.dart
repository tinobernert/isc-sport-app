class StudentResultModel {
  final int rank;
  final String studentName;
  final String className; // e.g. ITF24B1, ITF24B2
  final String disciplineName;
  final String performance; // e.g. "11.2 s", "6.45 m"
  final int points;

  const StudentResultModel({
    required this.rank,
    required this.studentName,
    required this.className,
    required this.disciplineName,
    required this.performance,
    required this.points,
  });

  static List<StudentResultModel> sampleResults() => const [
        StudentResultModel(
          rank: 1,
          studentName: 'Maximilian Weber',
          className: 'ITF24B1',
          disciplineName: '100m Sprint',
          performance: '11.12 s',
          points: 940,
        ),
        StudentResultModel(
          rank: 2,
          studentName: 'Sarah Wagner',
          className: 'ITF24B2',
          disciplineName: 'Weitsprung',
          performance: '5.82 m',
          points: 915,
        ),
        StudentResultModel(
          rank: 3,
          studentName: 'Lukas Becker',
          className: 'ITF24B1',
          disciplineName: 'Kugelstoßen',
          performance: '14.50 m',
          points: 890,
        ),
        StudentResultModel(
          rank: 4,
          studentName: 'Anna Schmidt',
          className: 'ITF24B2',
          disciplineName: '3.000m Ausdauerlauf',
          performance: '10:15 min',
          points: 870,
        ),
        StudentResultModel(
          rank: 5,
          studentName: 'Jan Fischer',
          className: 'WIM23A',
          disciplineName: 'Hochsprung',
          performance: '1.85 m',
          points: 855,
        ),
        StudentResultModel(
          rank: 6,
          studentName: 'Lena Hoffmann',
          className: 'ITF24B1',
          disciplineName: '100m Sprint',
          performance: '12.80 s',
          points: 840,
        ),
        StudentResultModel(
          rank: 7,
          studentName: 'Timon Meyer',
          className: 'ITF24B2',
          disciplineName: 'Speerwurf',
          performance: '48.20 m',
          points: 825,
        ),
        StudentResultModel(
          rank: 8,
          studentName: 'Laura Klein',
          className: 'WIM23A',
          disciplineName: 'Weitsprung',
          performance: '5.10 m',
          points: 810,
        ),
      ];
}
