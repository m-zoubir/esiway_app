import 'package:esiway/widgets/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../trip_resume.dart';

class InfoTripBox1 extends StatelessWidget {
  final String price;
  final String departure, arrival;
  const InfoTripBox1({
    super.key,
    required this.price,
    required this.departure,
    required this.arrival,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final screenWidth = size.width;
    final screenHeight = size.height;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          width: screenWidth * 0.14,
        ),
        SvgPicture.asset(
          'Assets/Icons/tripshape.svg',
          semanticsLabel: 'My SVG Image',
          width: 2, // Set the size of the SVG image
          height: 42,
        ),
        SizedBox(width: 2),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$departure",
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                  color: bleu_bg,
                ),
                softWrap: false,
                maxLines: 1,
                overflow: TextOverflow.fade,
              ),
              SizedBox(
                height: 17,
              ),
              Text(
                '$arrival',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                  color: bleu_bg,
                ),
                softWrap: false,
                maxLines: 1,
                overflow: TextOverflow.fade,
              ),
            ],
          ),
        ),
        SizedBox(
          width: screenWidth * 0.16,
        ),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: bleu_ciel,
            minimumSize: Size(screenWidth * 0.08, screenHeight * 0.03),
            padding: EdgeInsets.symmetric(horizontal: 8),
            elevation: 1,
            shadowColor: bleu_bg.withOpacity(0.15),
          ),
          child: Text(
            '$price DA',
            style: TextStyle(
              fontSize: 12,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              color: bleu_bg,
            ),
          ),
        )
      ],
    );
  }
}

class InfoTripBox2 extends StatelessWidget {
  final String price;
  final String departure, arrival;
  const InfoTripBox2({
    super.key,
    required this.price,
    required this.departure,
    required this.arrival,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final screenWidth = size.width;
    final screenHeight = size.height;
    return Container(
      height: screenHeight * 0.1,
      width: screenWidth * 0.9,
      margin: EdgeInsets.only(
          top: screenHeight * 0.02, bottom: screenHeight * 0.02),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SvgPicture.asset(
            'Assets/Icons/tripshape.svg',
            semanticsLabel: 'My SVG Image',
            width: 3, // Set the size of the SVG image
            height: 65,
          ),
          SizedBox(width: 3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "$departure",
                  style: TextStyle(
                    fontSize: 14.5,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    color: bleu_bg,
                  ),
                  softWrap: false,
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  '$arrival',
                  style: TextStyle(
                    fontSize: 14.5,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    color: bleu_bg,
                  ),
                  softWrap: false,
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                ),
              ],
            ),
          ),
          SizedBox(
            width: screenWidth * 0.34,
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: bleu_bg,
              minimumSize: Size(screenWidth * 0.08, screenHeight * 0.04),
              padding: EdgeInsets.symmetric(horizontal: 8),
              elevation: 1,
              shadowColor: bleu_bg.withOpacity(0.15),
            ),
            child: Text(
              '$price DA',
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
                color: orange,
              ),
            ),
          )
        ],
      ),
    );
  }
}
