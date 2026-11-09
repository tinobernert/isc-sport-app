import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_dropdown.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/models/discipline_model.dart';
import '../controllers/disziplin_form_controller.dart';

/// Dialog-Widget zum Anlegen oder Bearbeiten einer Disziplin.
class DisziplinDialog extends StatefulWidget {
  /// Die zu bearbeitende [DisciplineModel] oder `null`, falls eine neue Disziplin angelegt wird.
  final DisciplineModel? discipline;

  /// Erstellt einen neuen [DisziplinDialog].
  const DisziplinDialog({super.key, this.discipline});

  @override
  State<DisziplinDialog> createState() => _DisziplinDialogState();
}

class _DisziplinDialogState extends State<DisziplinDialog> {
  late final DisziplinFormController _formular;

  @override
  void initState() {
    super.initState();
    _formular = DisziplinFormController(discipline: widget.discipline);
  }

  @override
  void dispose() {
    _formular.dispose();
    super.dispose();
  }

  void _speichern() {
    final discipline = _formular.erstelleDisziplin(
      id: widget.discipline?.id ?? 'd_${DateTime.now().millisecondsSinceEpoch}',
      category: widget.discipline?.category ?? 'LAUF',
      icon: widget.discipline?.icon ?? Icons.sports,
    );
    if (discipline != null) {
      Navigator.pop(context, discipline);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text(
        widget.discipline == null
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
                    setState(() {
                      _formular.einheit = wert;
                    });
                  },
                ),
                const SizedBox(height: 20),
                SwitchListTile(
                  title: const Text('Höher ist besser'),
                  subtitle: Text(
                    _formular.higherIsBetter
                        ? 'Mehr Leistung = mehr Punkte (z. B. Weitsprung)'
                        : 'Weniger Zeit/Wert = mehr Punkte (z. B. Sprint)',
                  ),
                  value: _formular.higherIsBetter,
                  activeThumbColor: AppColors.primary,
                  onChanged: (val) {
                    setState(() {
                      _formular.higherIsBetter = val;
                    });
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
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
          ),
          onPressed: () => Navigator.pop(context),
          child: const Text('Abbrechen'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
          ),
          onPressed: _speichern,
          child: const Text('Speichern'),
        ),
      ],
    );
  }
}
