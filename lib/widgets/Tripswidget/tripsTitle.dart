import 'package:auto_size_text/auto_size_text.dart';

import '../constant.dart';

import 'package:flutter/material.dart';

class CustomTitle extends StatelessWidget {
  const CustomTitle({super.key, required this.title, required this.titleSize});
  final String title;
  final double titleSize;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final screenWidth = size.width;
    final screenHeight = size.height;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        AutoSizeText(
          title,
          style: TextStyle(
            fontSize: titleSize,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w700,
            color: bleu_bg,
          ),
          maxLines: 1,
          overflow: TextOverflow.fade,
        ),
      ],
    );
  }
}
