import 'package:flutter/material.dart';

import 'button.dart';
import 'constant.dart';

class CustomAlertDialog extends StatelessWidget {
  CustomAlertDialog(
      {super.key,
      required this.greentext,
      required this.question,
      required this.redtext,
      required this.greenfct,
      required this.redfct});

  String greentext;
  String redtext;
  String question;
  VoidCallback redfct;
  VoidCallback greenfct;
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25))),
      contentPadding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
      children: [
        Text(
          question,
          style: TextStyle(
              color: bleu_bg,
              fontFamily: 'Montserrat',
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 40,
              width: MediaQuery.of(context).size.width * 0.3,
              child: Button(
                color: vert,
                title: greentext,
                onPressed: greenfct,
              ),
            ),
            Container(
              height: 40,
              width: MediaQuery.of(context).size.width * 0.3,
              child: Button(color: orange, title: redtext, onPressed: redfct),
            ),
          ],
        ),
      ],
    );
  }
}
