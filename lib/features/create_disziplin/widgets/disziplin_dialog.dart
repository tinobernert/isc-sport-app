import 'package:flutter/material.dart';

import '../../../core/widgets/app_dropdown.dart';
import '../../../core/widgets/app_text_field.dart';
import '../controllers/disziplin_form_controller.dart';
import '../models/disziplinen.dart';

class DisziplinDialog extends StatefulWidget {
  // null bedeutet: neue Disziplin anlegen.
  final Disziplinen? disziplin;

  const DisziplinDialog({super.key, this.disziplin});

  @override
  State<DisziplinDialog> createState() => _DisziplinDialogState();
}

class _DisziplinDialogState extends State<DisziplinDialog> {
  late final DisziplinFormController _formular;

  @override
  void initState() {
    super.initState();
    _formular = DisziplinFormController(disziplin: widget.disziplin);
  }

  @override
  void dispose() {
    _formular.dispose();
    super.dispose();
  }

  void _speichern() {
    final disziplin = _formular.erstelleDisziplin();
    if (disziplin != null) {
      // Dialog schließen und das fertige Objekt an die Seite zurückgeben.
      Navigator.pop(context, disziplin);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.disziplin == null
            ? 'Disziplin hinzufügen'
            : 'Disziplin bearbeiten',
      ),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: Form(
            key: _formular.formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppTextField(
                  label: 'Name',
                  controller: _formular.nameController,
                  validator: _formular.pruefeName,
                ),
                const SizedBox(height: 20),
                AppDropdown<String>(
                  label: 'Einheit',
                  value: _formular.einheit,
                  validator: _formular.pruefeEinheit,
                  items: _formular.verfuegbareEinheiten.map((einheit) {
                    return DropdownMenuItem(
                      value: einheit,
                      child: Text(einheit),
                    );
                  }).toList(),
                  onChanged: (wert) {
                    _formular.einheit = wert;
                  },
                ),
                const SizedBox(height: 20),
                AppDropdown<Richtung>(
                  label: 'Richtung',
                  value: _formular.richtung,
                  validator: _formular.pruefeRichtung,
                  items: const [
                    DropdownMenuItem(
                      value: Richtung.hochGut,
                      child: Text('Hoch gut'),
                    ),
                    DropdownMenuItem(
                      value: Richtung.niedrigGut,
                      child: Text('Niedrig gut'),
                    ),
                  ],
                  onChanged: (wert) {
                    _formular.richtung = wert;
                  },
                ),
                const SizedBox(height: 20),
                AppTextField(
                  label: 'Gewichtung',
                  controller: _formular.gewichtungController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  validator: _formular.pruefeGewichtung,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Abbrechen'),
        ),
        FilledButton(onPressed: _speichern, child: const Text('Speichern')),
      ],
    );
  }
}
