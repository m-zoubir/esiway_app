import 'package:flutter/material.dart';

import 'constant.dart';

class Button extends StatelessWidget {
  Button(
      {required this.color, required this.title, required this.onPressed , this.icon});

  final Color color;
  final String title;
  final VoidCallback onPressed;
  Icon? icon;
  @override
  Widget build(BuildContext context) {
    if (icon == null)
    return Material(
        elevation: 5,
        color: color,
        borderRadius: BorderRadius.circular(10),
        child:  MaterialButton(
                onPressed: onPressed,
                child: Center(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: bleu_bg,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),);
        else
         return ElevatedButton.icon(
                 style: ButtonStyle(
                   shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                     RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(5),
                     ),
                   ),
                   elevation: MaterialStateProperty.all(3),

                   backgroundColor:  MaterialStateColor.resolveWith((states) =>color),
                 ),
                onPressed: onPressed,
                label: Center(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: bleu_bg,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                icon: icon!,
              );
  }
}
