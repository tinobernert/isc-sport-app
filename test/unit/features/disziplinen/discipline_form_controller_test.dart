import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sport_point/core/models/discipline_model.dart';
import 'package:sport_point/features/disziplinen/presentation/controllers/discipline_form_controller.dart';

void main() {
  group('DisciplineFormController Tests', () {
    test('Validierung des Namens schlägt bei leeren Eingaben fehl', () {
      final controller = DisciplineFormController();

      expect(controller.validateName(null), isNotNull);
      expect(controller.validateName(''), isNotNull);
      expect(controller.validateName('   '), isNotNull);
      expect(controller.validateName('Sprint'), isNull);

      controller.dispose();
    });

    test('Validierung der Gewichtung prüft auf positive Zahlen', () {
      final controller = DisciplineFormController();

      expect(controller.validateWeight(null), isNotNull);
      expect(controller.validateWeight('abc'), isNotNull);
      expect(controller.validateWeight('0'), isNotNull);
      expect(controller.validateWeight('-5'), isNotNull);
      expect(controller.validateWeight('2.5'), isNull);
      expect(controller.validateWeight('1,5'), isNull); // Komma wird zu Punkt konvertiert

      controller.dispose();
    });

    test('Initialisierung mit einer bestehenden Disziplin füllt die Controller', () {
      // Wir erstellen eine Test-Disziplin
      final discipline = DisciplineModel(
        id: 'test_1',
        name: 'Hürdenlauf',
        icon: Icons.bolt,
        unit: 's',
        weight: 1.5,
        higherIsBetter: false,
        description: 'Test Hürdenlauf',
      );

      final controller = DisciplineFormController(discipline: discipline);

      expect(controller.nameController.text, equals('Hürdenlauf'));
      expect(controller.weightController.text, equals('1.5'));
      expect(controller.unit, equals('s'));
      expect(controller.higherIsBetter, isFalse);
      expect(controller.icon, equals(Icons.bolt));

      controller.dispose();
    });
  });
}
