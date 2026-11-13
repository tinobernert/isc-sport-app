import 'package:flutter_test/flutter_test.dart';
import 'package:sport_point/core/models/student_result_model.dart';

void main() {
  group('StudentResultModel Tests', () {
    test('Erstellt ein StudentResultModel und prüft die Eigenschaften', () {
      const result = StudentResultModel(
        rank: 1,
        studentName: 'Max Mustermann',
        className: 'ITF24B1',
        disciplineName: '100m Sprint',
        performance: '11.50 s',
        points: 900,
      );

      expect(result.rank, equals(1));
      expect(result.studentName, equals('Max Mustermann'));
      expect(result.className, equals('ITF24B1'));
      expect(result.disciplineName, equals('100m Sprint'));
      expect(result.performance, equals('11.50 s'));
      expect(result.points, equals(900));
    });

    test('sampleResults liefert eine gültige und nicht leere Liste von Ergebnissen', () {
      final samples = StudentResultModel.sampleResults();

      expect(samples, isNotEmpty);
      expect(samples.first.rank, equals(1));
      expect(samples.first.studentName, equals('Maximilian Weber'));
      expect(samples.first.points, equals(940));
    });
  });
}
