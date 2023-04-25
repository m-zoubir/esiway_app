import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Icons_ESIWay extends StatelessWidget {
  final String icon;
  final double largeur;
  final double hauteur;
  final double rotation;

  const Icons_ESIWay({
    super.key,
    required this.icon,
    required this.largeur,
    required this.hauteur,
    this.rotation = 0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Transform.rotate(
        angle: rotation,
        child: SvgPicture.asset(
          "${icon}",
          //  color: ,
          height: hauteur, width: largeur,
        ),
      ),
    );
  }
}
