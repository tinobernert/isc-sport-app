import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/models/discipline_model.dart';
import '../controllers/discipline_form_controller.dart';
import 'icon_picker_dialog.dart';

/// Dialog-Widget zum Anlegen oder Bearbeiten einer Disziplin.
class DisciplineDialog extends StatefulWidget {
  /// Die zu bearbeitende [DisciplineModel] oder `null`, falls eine neue Disziplin angelegt wird.
  final DisciplineModel? discipline;

  /// Erstellt einen neuen [DisciplineDialog].
  const DisciplineDialog({super.key, this.discipline});

  @override
  State<DisciplineDialog> createState() => _DisciplineDialogState();
}

class _DisciplineDialogState extends State<DisciplineDialog> {
  late final DisciplineFormController _form;

  @override
  void initState() {
    super.initState();
    _form = DisciplineFormController(discipline: widget.discipline);
  }

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  void _save() {
    final discipline = _form.createDiscipline(
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
      backgroundColor: AppColors.background,
      title: Text(
        widget.discipline == null
            ? AppStrings.addDisciplineTitle
            : AppStrings.editDisciplineTitle,
      ),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: Form(
            key: _form.formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextField(
                  label: AppStrings.disciplineNameLabel,
                  controller: _form.nameController,
                  validator: _form.validateName,
                ),
                const SizedBox(height: 20),
                AppTextField(
                  label: AppStrings.disciplineWeightLabel,
                  controller: _form.weightController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  validator: _form.validateWeight,
                ),
                const SizedBox(height: 20),
                const Text(
                  AppStrings.iconLabel,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.grey800),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () async {
                    final chosenIcon = await showDialog<IconData>(
                      context: context,
                      builder: (context) => IconPickerDialog(selectedIcon: _form.icon),
                    );
                    if (chosenIcon != null) {
                      setState(() {
                        _form.icon = chosenIcon;
                      });
                    }
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.grey50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.grey300),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(_form.icon, color: AppColors.primary, size: 24),
                        ),
                        const SizedBox(width: 16),
                        const Text(
                          AppStrings.changeIconLabel,
                          style: TextStyle(fontWeight: FontWeight.w500, color: AppColors.grey800),
                        ),
                        const Spacer(),
                        const Icon(Icons.chevron_right, color: AppColors.grey500),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  AppStrings.unitLabel,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.grey800),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _form.availableUnits.map((unit) {
                    final isSelected = _form.unit == unit;
                    return ChoiceChip(
                      showCheckmark: false,
                      label: Text(unit),
                      selected: isSelected,
                      selectedColor: AppColors.primaryLight,
                      backgroundColor: AppColors.grey100,
                      labelStyle: TextStyle(
                        color: isSelected ? AppColors.primary : AppColors.grey800,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _form.unit = unit;
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
                    _form.higherIsBetter ? AppStrings.moreIsBetter : AppStrings.lessIsBetter,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    _form.higherIsBetter
                        ? 'Z. B. Weitsprung, Kugelstoßen (höherer Wert = mehr Punkte)'
                        : 'Z. B. 100m Sprint (niedrigere Zeit = mehr Punkte)',
                  ),
                  value: _form.higherIsBetter,
                  activeThumbColor: AppColors.primary,
                  inactiveThumbColor: AppColors.grey400,
                  inactiveTrackColor: AppColors.grey200,
                  onChanged: (val) {
                    setState(() {
                      _form.higherIsBetter = val;
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
          child: const Text(AppStrings.cancelButton),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
          ),
          onPressed: _save,
          child: const Text(AppStrings.saveButton),
        ),
      ],
    );
  }
}
