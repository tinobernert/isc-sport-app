import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Ein wiederverwendbares Dropdown-Formularfeld mit einheitlichem Styling.
class AppDropdown<T> extends StatelessWidget {
  /// Die Beschriftung des Dropdown-Felds.
  final String label;

  /// Der aktuell ausgewählte Wert des Dropdowns.
  final T? value;

  /// Optionale Validierungsfunktion für Formulare.
  final String? Function(T?)? validator;

  /// Liste aller auswählbaren Elemente.
  final List<DropdownMenuItem<T>> items;

  /// Callback, der bei Wertänderung aufgerufen wird.
  final ValueChanged<T?> onChanged;

  /// Erstellt ein neues [AppDropdown].
  const AppDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      key: ValueKey(value),
      dropdownColor: Colors.white,
      initialValue: value,
      isExpanded: true,
      items: items,
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: AppColors.inputBorder,
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.inputBorder,
            width: 1,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),
      ),
    );
  }
}
