import 'package:flutter/material.dart';
import '../theme/theme.dart';

class NotchedTextField extends StatelessWidget {
  final String labelText;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final bool readOnly;
  final VoidCallback? onTap;
  final Widget? suffixIcon;

  const NotchedTextField({
    super.key,
    required this.labelText,
    this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.validator,
    this.readOnly = false,
    this.onTap,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      onChanged: onChanged,
      validator: validator,
      readOnly: readOnly,
      onTap: onTap,
      style: Theme.of(context).textTheme.bodyLarge,
      cursorColor: KalyaThiruTheme.primaryMaroon,
      decoration: InputDecoration(
        labelText: labelText,
        suffixIcon: suffixIcon,
        alignLabelWithHint: true,
      ),
    );
  }
}
