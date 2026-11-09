import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/models/discipline_model.dart';
import '../controllers/disziplin_form_controller.dart';
import 'icon_picker_dialog.dart';

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextField(
                  label: 'Name',
                  controller: _formular.nameController,
                  validator: _formular.pruefeName,
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
                const SizedBox(height: 20),
                const Text(
                  'Icon',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () async {
                    final chosenIcon = await showDialog<IconData>(
                      context: context,
                      builder: (context) => IconPickerDialog(selectedIcon: _formular.icon),
                    );
                    if (chosenIcon != null) {
                      setState(() {
                        _formular.icon = chosenIcon;
                      });
                    }
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(_formular.icon, color: AppColors.primary, size: 24),
                        ),
                        const SizedBox(width: 16),
                        const Text(
                          'Icon ändern',
                          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black87),
                        ),
                        const Spacer(),
                        const Icon(Icons.chevron_right, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Einheit',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _formular.verfuegbareEinheiten.map((einheit) {
                    final isSelected = _formular.einheit == einheit;
                    return ChoiceChip(
                      showCheckmark: false,
                      label: Text(einheit),
                      selected: isSelected,
                      selectedColor: AppColors.primaryLight,
                      backgroundColor: Colors.grey.shade100,
                      labelStyle: TextStyle(
                        color: isSelected ? AppColors.primary : Colors.black87,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _formular.einheit = einheit;
                          });
                        }
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                SwitchListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    _formular.higherIsBetter ? 'Mehr ist besser' : 'Weniger ist besser',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    _formular.higherIsBetter
                        ? 'Z. B. Weitsprung, Kugelstoßen (höherer Wert = mehr Punkte)'
                        : 'Z. B. 100m Sprint (niedrigere Zeit = mehr Punkte)',
                  ),
                  value: _formular.higherIsBetter,
                  activeThumbColor: AppColors.primary,
                  inactiveThumbColor: Colors.grey.shade400,
                  inactiveTrackColor: Colors.grey.shade200,
                  onChanged: (val) {
                    setState(() {
                      _formular.higherIsBetter = val;
                    });
                  },
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
