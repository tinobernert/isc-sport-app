import 'package:flutter/material.dart';

import '../../../core/models/discipline_model.dart';

/// Controller zur Verwaltung der Formularlogik und Validierung beim Anlegen oder Bearbeiten einer Disziplin.
class DisziplinFormController {
  /// GlobalKey für die Formular-Validierung.
  final formKey = GlobalKey<FormState>();

  /// Controller für das Namensfeld.
  final nameController = TextEditingController();

  /// Controller für das Gewichtungsfeld.
  final gewichtungController = TextEditingController();

  /// Die aktuell ausgewählte Einheit.
  String? einheit;

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

  /// Erstellt einen [DisziplinFormController] und befüllt optional die Felder, falls eine bestehende [discipline] übergeben wird.
  DisziplinFormController({DisciplineModel? discipline}) {
    if (discipline != null) {
      nameController.text = discipline.name;
      gewichtungController.text = discipline.gewichtung.toString();
      einheit = discipline.einheit;
      higherIsBetter = discipline.higherIsBetter;
      icon = discipline.icon;
    } else {
      einheit = 'm';
      gewichtungController.text = '1.0';
      icon = Icons.directions_run;
    }
  }

  /// Gibt die Liste der verfügbaren Standard-Einheiten zurück.
  List<String> get verfuegbareEinheiten => ['m', 'cm', 's', 'min', 'kg', 'Punkte'];

  /// Validiert die Namenseingabe.
  String? pruefeName(String? wert) {
    if (wert == null || wert.trim().isEmpty) {
      return 'Bitte einen Namen eingeben.';
    }
    return null;
  }

  /// Validiert die Einheitsauswahl.
  String? pruefeEinheit(String? wert) {
    if (wert == null || wert.trim().isEmpty) return 'Bitte eine Einheit auswählen.';
    return null;
  }

  /// Validiert die Gewichtungseingabe (muss eine Zahl > 0 sein).
  String? pruefeGewichtung(String? wert) {
    final zahl = double.tryParse((wert ?? '').trim().replaceAll(',', '.'));
    if (zahl == null || !zahl.isFinite || zahl <= 0) {
      return 'Bitte eine Zahl größer als 0 eingeben.';
    }
    return null;
  }

  /// Validiert das Formular und erstellt ein neues [DisciplineModel] oder gibt `null` zurück bei Fehlern.
  DisciplineModel? erstelleDisziplin({required String id, required String category}) {
    if (!formKey.currentState!.validate()) return null;

    return DisciplineModel(
      id: id,
      name: nameController.text.trim(),
      category: category,
      icon: icon,
      einheit: einheit ?? 'm',
      gewichtung: double.parse(
        gewichtungController.text.trim().replaceAll(',', '.'),
      ),
      higherIsBetter: higherIsBetter,
    );
  }

  /// Gibt die verwendeten Text-Controller frei.
  void dispose() {
    nameController.dispose();
    gewichtungController.dispose();
  }
}
