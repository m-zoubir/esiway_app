import 'package:flutter/material.dart';

import 'constant.dart';

class Listbox extends StatelessWidget {
  Listbox(
      {super.key,
        required this.title,
         this.iconleading,
        this.subtitle,
        this.color ,
        this.shadow ,
        this.heigh ,
        this.inCenter ,
        required this.onPressed});

  String? subtitle;
  String title;
  Icon? iconleading;
  VoidCallback onPressed;
  Color? color ;
  Color? shadow ;
  double? heigh ;
  bool? inCenter ;


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          elevation: 3 ,
          shadowColor: shadow == null ? Colors.grey.withOpacity(0.3)
              : shadow,
          child: ListTile(

            tileColor: color == null ? Colors.white : color,
            dense: true,
            onTap: onPressed,
            leading: iconleading,
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
            title:  inCenter != null ?Center(
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: "Montserrat",
                  fontSize: 15.0,
                  color: bleu_bg,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ):Text(
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
          height: heigh != null ? heigh : 10 ,
        ),
      ],
    );
  }
}