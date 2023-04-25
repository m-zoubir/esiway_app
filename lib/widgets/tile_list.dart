import 'package:flutter/material.dart';

import 'constant.dart';
import 'icons_ESIWay.dart';

class Listbox extends StatelessWidget {
  Listbox(
      {super.key,
      required this.title,
      this.iconleading,
      this.subtitle,
      this.color,
      this.shadow,
      this.heigh,
      this.inCenter,
      this.iconName,
      this.scale,
      required this.onPressed});

  String? iconName;
  String? subtitle;
  String title;
  double? scale;
  Icon? iconleading;
  VoidCallback onPressed;
  Color? color;
  Color? shadow;
  double? heigh;
  bool? inCenter;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          elevation: 3,
          shadowColor: shadow == null ? Colors.grey.withOpacity(0.3) : shadow,
          child: ListTile(
            tileColor: color == null ? Colors.white : color,
            dense: true,
            onTap: onPressed,
            leading: iconleading != null
                ? Padding(
                    padding: EdgeInsets.only(left: 5), child: iconleading!)
                : iconName == null
                    ? null
                    : Container(
                        child: Transform.scale(
                          scale: scale!,
                          child: Icons_ESIWay(
                              icon: iconName!, largeur: 35, hauteur: 35),
                        ),
                      ),
            subtitle: subtitle != null
                ? Text(
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 10.0,
                      color: bleu_bg,
                      fontWeight: FontWeight.normal,
                    ),
                    subtitle!,
                  )
                : null,
            title: inCenter != null
                ? Center(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 15.0,
                        color: bleu_bg,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : Text(
                    title,
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 15.0,
                      color: bleu_bg,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
        SizedBox(
          height: heigh != null ? heigh : 10,
        ),
      ],
    );
  }
}
