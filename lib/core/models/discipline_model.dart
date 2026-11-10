import 'package:flutter/material.dart';

/// Repräsentiert eine Sportdisziplin mit Leistungseinheit, Gewichtung und Auswertungsrichtung.
class DisciplineModel {
  /// Eindeutige ID der Disziplin.
  final String id;

  /// Name der Disziplin (z. B. "100m Sprint").
  String name;

  /// Kategorie der Disziplin ('LAUF', 'SPRUNG', 'WURF').
  String category;

  /// Icon der Disziplin.
  IconData icon;

  /// Gibt an, ob die Disziplin im Event aktiviert ist.
  bool isEnabled;

  /// Maßeinheit der Leistung (z. B. "m", "s", "cm").
  String unit;

  /// Gewichtung der Disziplin für die Punkteberechnung.
  double weight;

  /// Gibt an, ob ein höherer Wert besser ist (`true` = z.B. Weitsprung, `false` = z.B. Sprint).
  bool higherIsBetter;

  /// Erstellt eine neue [DisciplineModel]-Instanz.
  DisciplineModel({
    required this.id,
    required this.name,
    required this.category,
    required this.icon,
    this.isEnabled = true,
    this.unit = 'm',
    this.weight = 1.0,
    this.higherIsBetter = true,
  });

  /// Erstellt eine Kopie mit optionalen Änderungen.
  DisciplineModel copyWith({
    String? name,
    String? category,
    IconData? icon,
    bool? isEnabled,
    String? unit,
    double? weight,
    bool? higherIsBetter,
  }) {
    return DisciplineModel(
      id: id,
      name: name ?? this.name,
      category: category ?? this.category,
      icon: icon ?? this.icon,
      isEnabled: isEnabled ?? this.isEnabled,
      unit: unit ?? this.unit,
      weight: weight ?? this.weight,
      higherIsBetter: higherIsBetter ?? this.higherIsBetter,
    );
  }

  /// Konvertiert die Disziplin in ein JSON-Map.
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category,
        'isEnabled': isEnabled,
        'unit': unit,
        'weight': weight,
        'higherIsBetter': higherIsBetter,
      };

  /// Erstellt eine [DisciplineModel]-Instanz aus einem JSON-Map.
  factory DisciplineModel.fromJson(Map<String, dynamic> json) {
    final cat = json['category'] as String? ?? 'LAUF';
    IconData iconData = Icons.directions_run;
    if (cat == 'SPRUNG') iconData = Icons.height;
    if (cat == 'WURF') iconData = Icons.fitness_center;

    return DisciplineModel(
      id: json['id'] as String,
      name: json['name'] as String,
      category: cat,
      icon: iconData,
      isEnabled: json['isEnabled'] as bool? ?? true,
      unit: json['unit'] as String? ?? json['einheit'] as String? ?? (cat == 'LAUF' ? 's' : 'm'),
      weight: (json['weight'] as num?)?.toDouble() ?? (json['gewichtung'] as num?)?.toDouble() ?? 1.0,
      higherIsBetter: json['higherIsBetter'] as bool? ?? (cat != 'LAUF'),
    );
  }

  /// Gibt eine Standardliste von Disziplinen zurück.
  static List<DisciplineModel> defaultDisciplines() => [
        DisciplineModel(
          id: 'd1',
          name: '100m Sprint',
          category: 'LAUF',
          icon: Icons.directions_run,
          isEnabled: true,
          unit: 's',
          weight: 1.0,
          higherIsBetter: false,
        ),
        DisciplineModel(
          id: 'd2',
          name: 'Weitsprung',
          category: 'SPRUNG',
          icon: Icons.height,
          isEnabled: true,
          unit: 'm',
          weight: 1.0,
          higherIsBetter: true,
        ),
        DisciplineModel(
          id: 'd3',
          name: 'Kugelstoßen',
          category: 'WURF',
          icon: Icons.fitness_center,
          isEnabled: true,
          unit: 'm',
          weight: 1.5,
          higherIsBetter: true,
        ),
        DisciplineModel(
          id: 'd4',
          name: '3.000m Ausdauerlauf',
          category: 'LAUF',
          icon: Icons.timer,
          isEnabled: true,
          unit: 'min',
          weight: 1.0,
          higherIsBetter: false,
        ),
        DisciplineModel(
          id: 'd5',
          name: 'Hochsprung',
          category: 'SPRUNG',
          icon: Icons.airline_seat_legroom_extra,
          isEnabled: true,
          unit: 'cm',
          weight: 1.0,
          higherIsBetter: true,
        ),
        DisciplineModel(
          id: 'd6',
          name: 'Speerwurf',
          category: 'WURF',
          icon: Icons.sports_kabaddi,
          isEnabled: true,
          unit: 'm',
          weight: 1.0,
          higherIsBetter: true,
        ),
        DisciplineModel(
          id: 'd7',
          name: '400m Staffellauf',
          category: 'LAUF',
          icon: Icons.speed,
          isEnabled: false,
          unit: 's',
          weight: 2.0,
          higherIsBetter: false,
        ),
        DisciplineModel(
          id: 'd8',
          name: 'Schlauchballwurf',
          category: 'WURF',
          icon: Icons.sports_baseball,
          isEnabled: true,
          unit: 'm',
          weight: 1.0,
          higherIsBetter: true,
        ),
      ];
}
