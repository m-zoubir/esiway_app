import 'package:auto_size_text/auto_size_text.dart';
import '../../../widgets/icons_ESIWay.dart';
import 'package:flutter/material.dart';

class OurPrefixeIconButton extends StatelessWidget {
  final Size size;
  final Color color;
  final double radius;
  final String text;
  final Color textcolor;
  final FontWeight weight;
  final double fontsize;
  final String iconName;
  final double espaceicontext;
  final Function fct;
  final double sizebutton;

  const OurPrefixeIconButton({
    super.key,
    required this.size,
    required this.color,
    required this.radius,
    required this.text,
    required this.textcolor,
    required this.weight,
    required this.fontsize,
    required this.iconName,
    required this.espaceicontext,
    required this.fct,
    this.sizebutton = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        fct();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.zero,
        elevation: 0.0,
        fixedSize: size,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Transform.scale(
              scale: sizebutton, // to make the icon smaller or larger
              child: Icons_ESIWay(icon: "help", largeur: 20, hauteur: 20)),
          //  SizedBox(width: espaceicontext,),
          AutoSizeText(
            text,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: weight,
              color: textcolor,
              fontSize: fontsize,
            ),
          ),
        ],
      ),
    );
  }
}
