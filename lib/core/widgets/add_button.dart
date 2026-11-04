import 'package:flutter/material.dart';

class AddButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const AddButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor:const Color(0xFFFF8134) ,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text('Hinzufügen +'),
      ),
    );
  }
}
