import 'package:flutter/material.dart';

import '../models/disziplinen.dart';

class DisziplinFormController {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final gewichtungController = TextEditingController();

  String? einheit;
  Richtung? richtung;

  DisziplinFormController({Disziplinen? disziplin}) {
    if (disziplin != null) {
      nameController.text = disziplin.name;
      gewichtungController.text = disziplin.gewichtung.toString();
      einheit = disziplin.einheit;
      richtung = disziplin.richtung;
    }
  }

  List<String> get verfuegbareEinheiten {
    final einheiten = ['m', 'cm', 's', 'min', 'kg', 'Punkte'];
    final aktuelleEinheit = einheit;
    if (aktuelleEinheit != null && !einheiten.contains(aktuelleEinheit)) {
      einheiten.add(aktuelleEinheit);
    }
    return einheiten;
  }

  String? pruefeName(String? wert) {
    if (wert == null || wert.trim().isEmpty) {
      return 'Bitte einen Namen eingeben.';
    }
    return null;
  }

  String? pruefeEinheit(String? wert) {
    if (wert == null) return 'Bitte eine Einheit auswählen.';
    return null;
  }

  String? pruefeRichtung(Richtung? wert) {
    if (wert == null) return 'Bitte eine Richtung auswählen.';
    return null;
  }

  String? pruefeGewichtung(String? wert) {
    final zahl = double.tryParse((wert ?? '').trim().replaceAll(',', '.'));
    if (zahl == null || !zahl.isFinite || zahl <= 0) {
      return 'Bitte eine Zahl größer als 0 eingeben.';
    }
    return null;
  }

  Disziplinen? erstelleDisziplin() {
    if (!formKey.currentState!.validate()) return null;

    return Disziplinen(
      name: nameController.text.trim(),
      einheit: einheit!,
      richtung: richtung!,
      gewichtung: double.parse(
        gewichtungController.text.trim().replaceAll(',', '.'),
      ),
    );
  }

  void dispose() {
    nameController.dispose();
    gewichtungController.dispose();
  }
}
