import 'package:flutter/material.dart';

class AppTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool readOnly;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;

  const AppTextFormField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.readOnly = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      autocorrect: false,
      readOnly: readOnly,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon,
      ),
      validator: validator,
    );
  }
}
