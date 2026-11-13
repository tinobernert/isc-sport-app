import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sport_point/core/models/discipline_model.dart';

void main() {
  group('Discipline Search & Filter Comprehensive Tests', () {
    final disciplines = [
      DisciplineModel(id: '1', name: '100m Sprint', icon: Icons.directions_run),
      DisciplineModel(id: '2', name: 'Weitsprung', icon: Icons.height),
      DisciplineModel(id: '3', name: 'Kugelstoßen', icon: Icons.fitness_center),
    ];

    test('Filtert Disziplinen exakt nach vollständigem Suchbegriff', () {
      const searchQuery = 'sprint';
      final filtered = disciplines
          .where((d) => d.name.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();

      expect(filtered.length, equals(1));
      expect(filtered.first.name, equals('100m Sprint'));
    });

    test('Filtert Disziplinen auch bei partiellen Suchbegriffen', () {
      const searchQuery = 'weits';
      final filtered = disciplines
          .where((d) => d.name.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();

      expect(filtered.length, equals(1));
      expect(filtered.first.name, equals('Weitsprung'));
    });

    test('Findet mehrere Disziplinen bei übergreifendem Teilstring', () {
      const searchQuery = 'spr'; // Kommt in "Sprint" und "Weitsprung" vor
      final filtered = disciplines
          .where((d) => d.name.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();

      expect(filtered.length, equals(2));
    });

    test('Liefert leere Liste bei nicht vorhandenem Suchbegriff', () {
      const searchQuery = 'Marathon';
      final filtered = disciplines
          .where((d) => d.name.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();

      expect(filtered, isEmpty);
    });

    test('Leere Suche gibt alle Disziplinen zurück', () {
      const searchQuery = '';
      final filtered = disciplines
          .where((d) => d.name.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();

      expect(filtered.length, equals(3));
    });
  });
}
