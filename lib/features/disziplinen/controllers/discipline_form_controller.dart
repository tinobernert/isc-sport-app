import 'package:flutter/material.dart';

import '../../../core/models/discipline_model.dart';

/// Controller zur Verwaltung der Formularlogik und Validierung beim Anlegen oder Bearbeiten einer Disziplin.
class DisciplineFormController {
  /// GlobalKey für die Formular-Validierung.
  final formKey = GlobalKey<FormState>();

  /// Controller für das Namensfeld.
  final nameController = TextEditingController();

  /// Controller für das Gewichtungsfeld.
  final weightController = TextEditingController();

  /// Die aktuell ausgewählte Einheit.
  String? unit;

  /// Gibt an, ob ein höherer Wert besser ist (`true` = höher ist besser, `false` = niedriger ist besser).
  bool higherIsBetter = true;

  /// Das aktuell ausgewählte Icon.
  IconData icon = Icons.directions_run;

  /// Verfügbare Icons zur Auswahl.
  final List<IconData> availableIcons = [
    Icons.directions_run,
    Icons.height,
    Icons.fitness_center,
    Icons.timer,
    Icons.airline_seat_legroom_extra,
    Icons.sports_kabaddi,
    Icons.speed,
    Icons.sports_baseball,
    Icons.sports,
    Icons.sports_basketball,
    Icons.sports_soccer,
    Icons.sports_tennis,
    Icons.sports_volleyball,
    Icons.pool,
    Icons.bolt,
    Icons.military_tech,
    Icons.emoji_events,
    Icons.flag,
  ];

  /// Erstellt einen [DisciplineFormController] und befüllt optional die Felder, falls eine bestehende [discipline] übergeben wird.
  DisciplineFormController({DisciplineModel? discipline}) {
    if (discipline != null) {
      nameController.text = discipline.name;
      weightController.text = discipline.weight.toString();
      unit = discipline.unit;
      higherIsBetter = discipline.higherIsBetter;
      icon = discipline.icon;
    } else {
      unit = 'm';
      weightController.text = '1.0';
      icon = Icons.directions_run;
    }
  }

  /// Gibt die Liste der verfügbaren Standard-Einheiten zurück.
  List<String> get availableUnits => ['m', 'cm', 's', 'min', 'kg', 'Punkte'];

  /// Validiert die Namenseingabe.
  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Bitte einen Namen eingeben.';
    }
    return null;
  }

  /// Validiert die Einheitsauswahl.
  String? validateUnit(String? value) {
    if (value == null || value.trim().isEmpty) return 'Bitte eine Einheit auswählen.';
    return null;
  }

  /// Validiert die Gewichtungseingabe (muss eine Zahl > 0 sein).
  String? validateWeight(String? value) {
    final number = double.tryParse((value ?? '').trim().replaceAll(',', '.'));
    if (number == null || !number.isFinite || number <= 0) {
      return 'Bitte eine Zahl größer als 0 eingeben.';
    }
    return null;
  }

  /// Validiert das Formular und erstellt ein neues [DisciplineModel] oder gibt `null` zurück bei Fehlern.
  DisciplineModel? createDiscipline({required String id, required String category}) {
    if (!formKey.currentState!.validate()) return null;

    return DisciplineModel(
      id: id,
      name: nameController.text.trim(),
      category: category,
      icon: icon,
      unit: unit ?? 'm',
      weight: double.parse(
        weightController.text.trim().replaceAll(',', '.'),
      ),
      higherIsBetter: higherIsBetter,
    );
  }

  /// Gibt die verwendeten Text-Controller frei.
  void dispose() {
    nameController.dispose();
    weightController.dispose();
  }
}
