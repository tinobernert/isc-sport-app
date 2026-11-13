import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sport_point/core/models/discipline_model.dart';
import 'package:sport_point/features/disziplinen/presentation/controllers/discipline_form_controller.dart';

void main() {
  group('DisciplineFormController 100% Coverage Tests', () {
    test('Standardwerte bei Erstellung einer neuen Disziplin sind korrekt', () {
      final controller = DisciplineFormController();

      expect(controller.nameController.text, isEmpty);
      expect(controller.weightController.text, equals('1.0'));
      expect(controller.unit, equals('m'));
      expect(controller.higherIsBetter, isTrue);
      expect(controller.icon, equals(Icons.directions_run));
      expect(controller.availableUnits, contains('m'));
      expect(controller.availableIcons, isNotEmpty);

      controller.dispose();
    });

    test('Validierung des Namens schlägt bei leeren Eingaben fehl', () {
      final controller = DisciplineFormController();

      expect(controller.validateName(null), isNotNull);
      expect(controller.validateName(''), isNotNull);
      expect(controller.validateName('   '), isNotNull);
      expect(controller.validateName('Sprint'), isNull);

      controller.dispose();
    });

    test('Validierung der Einheit prüft auf Auswahl', () {
      final controller = DisciplineFormController();

      expect(controller.validateUnit(null), isNotNull);
      expect(controller.validateUnit(''), isNotNull);
      expect(controller.validateUnit('m'), isNull);

      controller.dispose();
    });

    test('Validierung der Gewichtung prüft auf positive Zahlen und Komma-Konvertierung', () {
      final controller = DisciplineFormController();

      expect(controller.validateWeight(null), isNotNull);
      expect(controller.validateWeight('abc'), isNotNull);
      expect(controller.validateWeight('0'), isNotNull);
      expect(controller.validateWeight('-5'), isNotNull);
      expect(controller.validateWeight('2.5'), isNull);
      expect(controller.validateWeight('1,5'), isNull); // Komma wird zu Punkt konvertiert

      controller.dispose();
    });

    test('Initialisierung mit einer bestehenden Disziplin füllt alle Controller korrekt', () {
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
