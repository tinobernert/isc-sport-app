import 'package:flutter_test/flutter_test.dart';

import 'package:flutter/material.dart';
import 'package:sport_point/core/models/discipline_model.dart';

void main(){
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
  });
}