import 'package:flutter_test/flutter_test.dart';

import 'package:flutter/material.dart';
import 'package:sport_point/core/models/discipline_model.dart';

void main() {
  group('DisciplineModel Tests', () {
    test('Erstellt ein DisciplineModel und prüft die Eigenschaften', () {
      final discipline = DisciplineModel(
        id: 'd1',
        name: '100m Sprint',
        icon: Icons.directions_run,
        unit: 's',
        weight: 1.0,
        higherIsBetter: false,
      );

      expect(discipline.name, equals('100m Sprint'));
      expect(discipline.unit, equals('s'));
      expect(discipline.higherIsBetter, isFalse);
    });

    test('toJson und fromJson konvertieren Disziplinen fehlerfrei', () {
      final original = DisciplineModel(
        id: 'd2',
        name: 'Weitsprung',
        icon: Icons.height,
        unit: 'm',
        weight: 1.2,
        higherIsBetter: true,
        description: 'Test Beschreibung',
      );

      final json = original.toJson();
      final reconstructed = DisciplineModel.fromJson(json);

      expect(reconstructed.id, equals(original.id));
      expect(reconstructed.name, equals(original.name));
      expect(reconstructed.unit, equals(original.unit));
      expect(reconstructed.weight, equals(original.weight));
      expect(reconstructed.higherIsBetter, equals(original.higherIsBetter));
      expect(reconstructed.description, equals(original.description));
    });

    test('copyWith erstellt eine korrekte Kopie mit geänderten Werten', () {
      final original = DisciplineModel(
        id: 'd3',
        name: 'Kugelstoßen',
        icon: Icons.fitness_center,
      );

      final copied = original.copyWith(name: 'Kugelstoß geupdated', weight: 2.0);

      expect(copied.id, equals(original.id));
      expect(copied.name, equals('Kugelstoß geupdated'));
      expect(copied.weight, equals(2.0));
      expect(copied.unit, equals(original.unit)); // unverändert
    });
  });
}
