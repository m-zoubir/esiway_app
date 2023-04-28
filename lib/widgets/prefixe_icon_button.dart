import 'package:flutter/material.dart';

class PrefixeIconButton extends StatelessWidget {
  final Size size;
  final Color color;
  final double radius;
  final String text;
  final Color textcolor;
  final FontWeight weight;
  final double fontsize;
  final Widget icon;
  final double espaceicontext;
  final Function fct;

  const PrefixeIconButton({
    super.key,
    required this.size,
    required this.color,
    required this.radius,
    required this.text,
    required this.textcolor,
    required this.weight,
    required this.fontsize,
    required this.icon,
    required this.espaceicontext,
    required this.fct,
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
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            icon,
            SizedBox(
              width: espaceicontext,
            ),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: weight,
                color: textcolor,
                fontSize: fontsize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
