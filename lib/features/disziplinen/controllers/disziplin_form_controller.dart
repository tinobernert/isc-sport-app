import 'package:material_ui/material_ui.dart';

import '../models/disziplin.dart';

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

  /// Die aktuell ausgewählte Wertungsrichtung.
  Richtung? richtung;

  /// Erstellt einen [DisziplinFormController] und befüllt optional die Felder, falls eine bestehende [disziplin] übergeben wird.
  DisziplinFormController({Disziplin? disziplin}) {
    if (disziplin != null) {
      nameController.text = disziplin.name;
      gewichtungController.text = disziplin.gewichtung.toString();
      einheit = disziplin.einheit;
      richtung = disziplin.richtung;
    }
  }

  /// Gibt die Liste der verfügbaren Standard-Einheiten zurück inkl. benutzerdefinierter Einheiten.
  List<String> get verfuegbareEinheiten {
    final einheiten = ['m', 'cm', 's', 'min', 'kg', 'Punkte'];
    final aktuelleEinheit = einheit;
    if (aktuelleEinheit != null && !einheiten.contains(aktuelleEinheit)) {
      einheiten.add(aktuelleEinheit);
    }
    return einheiten;
  }

  /// Validiert die Namenseingabe.
  String? pruefeName(String? wert) {
    if (wert == null || wert.trim().isEmpty) {
      return 'Bitte einen Namen eingeben.';
    }
    return null;
  }

  /// Validiert die Einheitsauswahl.
  String? pruefeEinheit(String? wert) {
    if (wert == null) return 'Bitte eine Einheit auswählen.';
    return null;
  }

  /// Validiert die Richtungsauswahl.
  String? pruefeRichtung(Richtung? wert) {
    if (wert == null) return 'Bitte eine Richtung auswählen.';
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

  /// Validiert das Formular und erstellt eine neue [Disziplin] oder gibt `null` zurück bei Fehlern.
  Disziplin? erstelleDisziplin() {
    if (!formKey.currentState!.validate()) return null;

    return Disziplin(
      name: nameController.text.trim(),
      einheit: einheit!,
      richtung: richtung!,
      gewichtung: double.parse(
        gewichtungController.text.trim().replaceAll(',', '.'),
      ),
    );
  }

  /// Gibt die verwendeten Text-Controller frei.
  void dispose() {
    nameController.dispose();
    gewichtungController.dispose();
  }
}
