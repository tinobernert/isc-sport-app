import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Ein wiederverwendbares Texteingabefeld mit einheitlichem Styling.
class AppTextField extends StatelessWidget {
  /// Die Beschriftung des Eingabefelds.
  final String label;

  /// Controller zur Steuerung des eingegebenen Textes.
  final TextEditingController controller;

  /// Optionale Tastaturart (z. B. Zahlen, Text).
  final TextInputType? keyboardType;

  /// Optionale Validierungsfunktion für Formulare.
  final String? Function(String?)? validator;

  /// Erstellt ein neues [AppTextField].
  const AppTextField({
    super.key,
    required this.label,
    required this.controller,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
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
