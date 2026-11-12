import 'package:material_ui/material_ui.dart';

/// Repräsentiert eine Sportdisziplin mit Leistungseinheit, Gewichtung und Auswertungsrichtung.
class DisciplineModel {
  /// Eindeutige ID der Disziplin.
  final String id;

  /// Name der Disziplin (z. B. "100m Sprint").
  String name;

  /// Kategorie der Disziplin.
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

  /// Beschreibung der Disziplin.
  String description;

  /// Erstellt eine neue [DisciplineModel]-Instanz.
  DisciplineModel({
    required this.id,
    required this.name,
    this.category = '',
    required this.icon,
    this.isEnabled = true,
    this.unit = 'm',
    this.weight = 1.0,
    this.higherIsBetter = true,
    this.description = 'Klassische Durchführung dieser Disziplin gemäß den regulären Vorgaben.',
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
    String? description,
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
      description: description ?? this.description,
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
        'description': description,
      };

  /// Erstellt eine [DisciplineModel]-Instanz aus einem JSON-Map.
  factory DisciplineModel.fromJson(Map<String, dynamic> json) {
    return DisciplineModel(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String? ?? '',
      icon: Icons.directions_run,
      isEnabled: json['isEnabled'] as bool? ?? true,
      unit: json['unit'] as String? ?? 'm',
      weight: (json['weight'] as num?)?.toDouble() ?? 1.0,
      higherIsBetter: json['higherIsBetter'] as bool? ?? true,
      description: json['description'] as String? ?? 'Klassische Durchführung dieser Disziplin gemäß den regulären Vorgaben.',
    );
  }

  /// Gibt eine Standardliste von Disziplinen mit spezifischen Beschreibungen zurück.
  static List<DisciplineModel> defaultDisciplines() => [
        DisciplineModel(
          id: 'd1',
          name: '100m Sprint',
          icon: Icons.directions_run,
          isEnabled: true,
          unit: 's',
          weight: 1.0,
          higherIsBetter: false,
          description: 'Sprint über die klassische 100-Meter-Distanz mit fliegendem oder Tiefstart.',
        ),
        DisciplineModel(
          id: 'd2',
          name: 'Weitsprung',
          icon: Icons.height,
          isEnabled: true,
          unit: 'm',
          weight: 1.0,
          higherIsBetter: true,
          description: 'Weitsprung in die Sandgrube mit Anlauf und Absprung vom Balken.',
        ),
        DisciplineModel(
          id: 'd3',
          name: 'Kugelstoßen',
          icon: Icons.fitness_center,
          isEnabled: true,
          unit: 'm',
          weight: 1.5,
          higherIsBetter: true,
          description: 'Kugelstoßen aus dem Abstoßring mit Stemmschritt oder Drehstoßtechnik.',
        ),
        DisciplineModel(
          id: 'd4',
          name: '3.000m Ausdauerlauf',
          icon: Icons.timer,
          isEnabled: true,
          unit: 'min',
          weight: 1.0,
          higherIsBetter: false,
          description: 'Langstreckenlauf über 3.000 Meter zur Prüfung der aeroben Ausdauer.',
        ),
        DisciplineModel(
          id: 'd5',
          name: 'Hochsprung',
          icon: Icons.airline_seat_legroom_extra,
          isEnabled: true,
          unit: 'cm',
          weight: 1.0,
          higherIsBetter: true,
          description: 'Hochsprung über die Latte im Fosbury-Flop oder Schersprung.',
        ),
        DisciplineModel(
          id: 'd6',
          name: 'Speerwurf',
          icon: Icons.sports_kabaddi,
          isEnabled: true,
          unit: 'm',
          weight: 1.0,
          higherIsBetter: true,
          description: 'Weitwurf mit dem Speer nach reglementiertem Anlauf.',
        ),
        DisciplineModel(
          id: 'd7',
          name: '400m Staffellauf',
          icon: Icons.speed,
          isEnabled: false,
          unit: 's',
          weight: 2.0,
          higherIsBetter: false,
          description: 'Staffelsprint über eine Stadionrunde mit präziser Stabübergabe.',
        ),
        DisciplineModel(
          id: 'd8',
          name: 'Schlauchballwurf',
          icon: Icons.sports_baseball,
          isEnabled: true,
          unit: 'm',
          weight: 1.0,
          higherIsBetter: true,
          description: 'Kraftvoller Wurf eines genormten Schlauchballs für Schulwettbewerbe.',
        ),
      ];
}
