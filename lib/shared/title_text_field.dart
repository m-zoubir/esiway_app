import 'package:flutter/material.dart';

import 'constant.dart';

class TitleTextFeild extends StatelessWidget {
  TitleTextFeild({super.key, required this.title});
  String title;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.values.first,
      children: [
        Text(
          title,
          style: TextStyle(
            color: bleu_bg,
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
