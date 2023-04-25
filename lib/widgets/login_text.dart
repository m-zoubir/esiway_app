import 'package:flutter/material.dart';

class MyText extends StatelessWidget {
  final double largeur;
  final String text;
  final FontWeight weight;
  final double fontsize;
  final Color color;
  const MyText({
    super.key,
    required this.largeur,
    required this.text,
    required this.weight,
    required this.fontsize,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: largeur,
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: weight,
          fontSize: fontsize,
          color: color,
        ),
        maxLines: 2,
      ),
    );
  }
}
