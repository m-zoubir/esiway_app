import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final Icon icon;
  final String text;
  const MyTextField({
    super.key,
    required this.controller,
    required this.text,
    required this.icon,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(boxShadow: [
        BoxShadow(blurRadius: 18, color: Color.fromRGBO(32, 35, 108, 0.15))
      ]),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: icon,
          hintText: text,
          hintStyle: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w500,
              color: Color(0xff20236C),
              fontSize: 12),
          errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white)),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white)),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white)),
          disabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white)),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}
