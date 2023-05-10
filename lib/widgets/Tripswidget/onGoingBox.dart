import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../Screens/Trips/mytrips.dart';
import '../constant.dart';

class OngoingBox extends StatelessWidget {
  const OngoingBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final screenWidth = size.width;
    final screenHeight = size.height;
    return Container(
      margin: EdgeInsets.only(
          left: screenWidth * 0.10,
          top: screenHeight * 0.02,
          bottom: screenHeight * 0.01,
          right: screenWidth * 0.10),
      width: screenWidth * 0.80,
      height: screenHeight * 0.06,
      padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04, vertical: screenHeight * 0.01),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 4,
            color: bleu_bg.withOpacity(0.15),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyTrips(),
              ));
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SvgPicture.asset(
              'Assets/Icons/arrow_left.svg',
              semanticsLabel: 'My SVG Image',
              width: 24,
              height: 24,
            ),
            SizedBox(
              width: screenWidth * 0.2,
            ),
            AutoSizeText(
              'Ongoing',
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
                color: bleu_bg,
              ),
            )
          ],
        ),
      ),
    );
  }
}
