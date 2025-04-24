import 'package:flutter/material.dart';
import 'package:vms/common/colors.dart';

class InputField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final Widget suffixIcon;
  final TextEditingController controller;
  final FocusNode? focusNode; // Add focusNode parameter
  final TextInputAction? textInputAction; // Add textInputAction parameter
  final Function(String)? onFieldSubmitted; // Add onFieldSubmitted parameter
  final TextInputType keyboardType; // Add keyboard type parameter
  final List<String>? autofillHints; // Add autofillHints parameter

  const InputField({
    super.key,
    required this.hintText,
    this.obscureText = false,
    required this.suffixIcon,
    required this.controller,
    this.focusNode, // Initialize focusNode
    this.textInputAction, // Initialize textInputAction
    this.onFieldSubmitted, // Initialize onFieldSubmitted
    this.keyboardType = TextInputType.text, // Default to normal text
    this.autofillHints, // Initialize autofillHints
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: textWhiteGrey,
        borderRadius: BorderRadius.circular(14.0),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        focusNode: focusNode, // Set focusNode
        textInputAction: textInputAction, // Set textInputAction
        onFieldSubmitted: onFieldSubmitted, // Set onFieldSubmitted
        keyboardType: keyboardType, // Add keyboard type
        autofillHints: autofillHints, // Set autofillHints
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: heading6.copyWith(color: textGrey),
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}