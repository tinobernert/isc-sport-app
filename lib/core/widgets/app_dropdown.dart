
import 'package:flutter/material.dart';

class AppDropdown<T> extends StatelessWidget {
  final String label;
  final T? value;
  final String? Function(T?)? validator;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

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
      dropdownColor: Colors.white,
      initialValue: value,
      isExpanded: true,
      items: items,
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,

        labelStyle: const TextStyle(
          color: Color(0xFF475569), // Normal
        ),

        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFF475569),
            width: 1,
          ),
        ),

        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFFFF8134),
            width: 2,
          ),
        ),
      ),
    );
  }
}
