import 'package:auto_size_text/auto_size_text.dart';

import '../constant.dart';

import 'package:flutter/material.dart';

class TitleMyTrips extends StatelessWidget {
  const TitleMyTrips({super.key, required this.title, required this.titleSize});
  final String title;
  final double titleSize;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final screenWidth = size.width;
    final screenHeight = size.height;
    return SizedBox(
      width: screenWidth * 0.6,
      child: Container(
        margin: EdgeInsets.only(left: screenWidth * 0.04),
        child: AutoSizeText(
          title,
          style: TextStyle(
            fontSize: titleSize,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w700,
            color: bleu_bg,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
