import 'package:flutter/material.dart';

import 'constant.dart';

class CustomRichText extends StatelessWidget {
  CustomRichText(
      {super.key,
      required this.title,
      required this.value,
      this.titlesize,
      this.valuesize});
  String value;
  String title;
  double? valuesize = 12;
  double? titlesize = 18;
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "$title\n",
            style: TextStyle(
              fontSize: titlesize,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              color: bleu_bg,
            ),
          ),
          TextSpan(
            text: value,
            style: TextStyle(
              fontSize: valuesize,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w500,
              color: bleu_bg,
            ),
          ),
        ],
      ),
    );
  }
}
