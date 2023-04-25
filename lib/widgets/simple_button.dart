import 'package:flutter/material.dart';

class SimpleButton extends StatelessWidget {
  final Color backgroundcolor;
  final Size size;
  final double radius;
  final String text;
  final FontWeight weight;
  final Color textcolor;
  final double fontsize;
  final VoidCallback fct;
  const SimpleButton({
    required this.backgroundcolor,
    required this.size,
    required this.radius,
    required this.text,
    required this.textcolor,
    this.weight = FontWeight.w500,
    required this.fontsize,
    required this.fct,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: fct ,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundcolor,
        elevation: 0.0,
        fixedSize: size,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: weight,
          color: textcolor,
          fontSize: fontsize,
        ),
      ),
    );
  }
}
