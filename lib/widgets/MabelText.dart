// ignore_for_file: file_names

import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:iconsax/iconsax.dart';
//import 'package:flutter_iconsax/flutter_iconsax.dart';
// ignore: unused_import

class LabelText extends StatelessWidget {
  const LabelText({
    Key? key,
    required this.text,
    this.color = const Color(0xFF20236C),
    required this.paddingValue,
  }) : super(key: key);

  final Color color;
  final double paddingValue;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * paddingValue),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
