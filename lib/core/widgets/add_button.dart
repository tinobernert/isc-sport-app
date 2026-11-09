import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Ein wiederverwendbarer Button zum Hinzufügen von Elementen in der App.
class AddButton extends StatelessWidget {
  /// Callback, der beim Tippen auf den Button ausgeführt wird.
  final VoidCallback? onPressed;

  /// Erstellt einen neuen [AddButton].
  const AddButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text('Hinzufügen +'),
      ),
    );
  }
}
