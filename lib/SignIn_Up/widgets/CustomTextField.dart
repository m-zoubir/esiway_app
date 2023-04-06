// ignore_for_file: file_names

import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:iconsax/iconsax.dart';
//import 'package:flutter_iconsax/flutter_iconsax.dart';
// ignore: unused_import

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    this.hintText,
    required this.labelText,
    required this.prefixIcon,
    this.hintTextColor,
    this.labelTextColor,
    this.iconColor,
    this.width,
    this.keyboardType,
    required this.controller,
    this.obscureText = false,
    this.validator,
  }) : super(key: key);

  final TextEditingController controller;
  final String? hintText;
  final Color? hintTextColor;
  final Color? iconColor;
  final String labelText;
  final Color? labelTextColor;
  final Icon prefixIcon;
  final double? width;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;
  final bool obscureText;
  //final _fieldfocus = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF20236C).withOpacity(0.12),
                blurRadius: 10.0,
                spreadRadius: 2.0,
              ),
            ],
          ),
          child: SizedBox(
            width: width,
            height: 50.0,
            child: TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              obscureText: obscureText,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: hintText,
                hintStyle: TextStyle(color: hintTextColor),
                labelText: labelText,
                labelStyle: TextStyle(color: labelTextColor),
                prefixIcon: prefixIcon,
                prefixIconColor: iconColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(3.0),
                  borderSide: BorderSide.none,
                ),
              ),
              validator: validator ?? _defaultValidator,
            ),
          ),
        ),
      ),
    );
  }

  String? _defaultValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter some text';
    }
    return null;
  }
}
