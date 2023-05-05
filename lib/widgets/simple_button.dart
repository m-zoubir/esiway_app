import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class SimpleButton extends StatelessWidget {
  final Color backgroundcolor;
  final Size size;
  final double radius;
  final String text;
  final FontWeight weight;
  final Color textcolor;
  final double fontsize;
  final Function fct;
  final double blur;
  const SimpleButton({
    required this.backgroundcolor,
    required this.size,
    required this.radius,
    required this.text,
    required this.textcolor,
    this.weight = FontWeight.w600,
    required this.fontsize,
    required this.fct,
    this.blur = 0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ElevatedButton(
        onPressed: () async {
          fct();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundcolor,
          elevation: 0.0,
          fixedSize: size,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
        child: AutoSizeText(
          text,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: weight,
            color: textcolor,
            fontSize: fontsize,
          ),
        ),
      ),
    );
  }
}
