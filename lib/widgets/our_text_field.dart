import '../../../widgets/icons_ESIWay.dart';

import 'package:flutter/material.dart';

class OurTextField extends StatefulWidget {
  final TextEditingController controller;
  final double size;
  final String iconName;
  final String text;
  final Color borderColor;




  const OurTextField({
    super.key,
    required this.controller,
    required this.text,
    required this.iconName,
    required this.size,
    required this.borderColor,

  });


  @override
  State<OurTextField> createState() => _OurTextFieldState();
}

class _OurTextFieldState extends State<OurTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(boxShadow: [
        BoxShadow(blurRadius: 18, color: Color.fromRGBO(32, 35, 108, 0.15))
      ]),
      child: TextField(

        controller: widget.controller,
        decoration: InputDecoration(
          prefixIcon: Container(
            child: Transform.scale(
              scale: widget.size, // to make the icon smaller or larger
              child: Icons_ESIWay(icon: widget.iconName, largeur: 20, hauteur: 20),
            ),
          ),
          hintText: widget.text,
          hintStyle: const TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w500,
              color: Color(0xff20236C),
              fontSize: 12),
          errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white)),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white)),
          enabledBorder:
          OutlineInputBorder(borderSide: BorderSide(color: widget.borderColor)),
          disabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white)),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}
