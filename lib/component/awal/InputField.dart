import 'package:flutter/material.dart';
import '../../utils/Colors.dart';
import '../../utils/Constant.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? errorText;
  final FocusNode focusNode;
  final VoidCallback onSubmit;

  CustomTextField({
    required this.controller,
    required this.hintText,
    this.errorText,
    required this.focusNode,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textAlign: TextAlign.left,
      maxLines: 1,
      focusNode: focusNode,
      style: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 14,
      ),
      decoration: CustomInputDecoration.getDecoration(
        hintText: hintText,
      ).copyWith(
        errorText: errorText,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: TextThirdColor),
        ),
        hintStyle: TextStyle(color: TextThirdColor),
      ),
      onSubmitted: (value) => onSubmit(),
    );
  }
}


class PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? errorText;
  final bool obscureText;
  final FocusNode focusNode;
  final VoidCallback onSubmit;
  final bool isPasswordVisible;
  final VoidCallback onPasswordToggle;

  PasswordField({
    required this.controller,
    required this.hintText,
    this.errorText,
    required this.obscureText,
    required this.focusNode,
    required this.onSubmit,
    required this.isPasswordVisible,
    required this.onPasswordToggle,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      textAlign: TextAlign.left,
      maxLines: 1,
      focusNode: focusNode,
      style: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 14,
      ),
      decoration: CustomInputDecoration.getDecoration(
        hintText: hintText,
      ).copyWith(
        errorText: errorText,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: TextThirdColor),
        ),
        hintStyle: TextStyle(color: TextThirdColor),
        suffixIcon: IconButton(
          icon: Icon(
            isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: TextPrimaryColor,
          ),
          onPressed: onPasswordToggle,
        ),
      ),
      onSubmitted: (value) => onSubmit(),
    );
  }
}