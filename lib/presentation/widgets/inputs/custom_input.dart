import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  const CustomInput({
    super.key,
    required this.controller,
    required this.validator,
    required this.hint,
    required this.icon,
    required this.focus,
    this.onFieldSubmitted,
    this.isPassword = false,
    this.textInputAction,
    this.onEditingComplete,
  });

  final TextEditingController controller;
  final String? Function(String?) validator;
  final String hint;
  final IconData icon;
  final FocusNode focus;
  final void Function(String)? onFieldSubmitted;
  final bool isPassword;
  final TextInputAction? textInputAction;
  final VoidCallback? onEditingComplete;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focus,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      validator: validator,
      obscureText: isPassword,
      onFieldSubmitted: onFieldSubmitted,
      textInputAction: textInputAction,
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xff3f49e0)),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.redAccent),
        ),
        prefixIcon: Icon(icon),
        hintText: hint,
        filled: true,
        fillColor: Color(0xffe0e0ff),
      ),
    );
  }
}
