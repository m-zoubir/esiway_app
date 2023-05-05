import 'package:auto_size_text/auto_size_text.dart';

import 'package:esiway/widgets/constant.dart';
import 'package:flutter/material.dart';

import '../../Screens/myTrips/onGoingtrip.dart';
import '../../Screens/myTrips/requestInfo.dart';
import '../simple_button.dart';

// type one of cards , these cards are for the reserved  trips
class MyTripsReserved extends StatelessWidget {
  MyTripsReserved({
    super.key,
    required this.departure,
    required this.arrival,
    required this.date,
    required this.text,
    required this.buttonText,
    required this.press,
  });

  final String departure, arrival, date, text, buttonText;
  final Function press;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final screenWidth = size.width;
    final screenHeight = size.height;
    return GestureDetector(
      onTap: press(),
      child: Container(
        margin: EdgeInsets.only(
            left: screenWidth * 0.02,
            top: screenHeight * 0.01,
            bottom: screenHeight * 0.01,
            right: screenWidth * 0.02),
        width: screenWidth * 0.89,
        height: screenHeight * 0.18,
        padding: EdgeInsets.all(screenWidth * 0.03),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: screenWidth * 0.5,
                  child: AutoSizeText(
                    "$departure - $arrival",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      color: bleu_bg,
                    ),
                    maxLines: 1,
                  ),
                ),
                SizedBox(
                  width: screenWidth * 0.2,
                  child: AutoSizeText(
                    '$date',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      color: bleu_bg,
                    ),
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            SizedBox(
              width: screenWidth * 0.8,
              child: AutoSizeText(
                '$text',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w500,
                  color: bleu_bg,
                ),
                maxLines: 1,
              ),
            ),
            SimpleButton(
              backgroundcolor: orange,
              size: Size(screenWidth * 0.8, screenHeight * 0.055),
              radius: 7,
              text: 'View Trip',
              textcolor: bleu_bg,
              fontsize: 14,
              fct: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RequestInfo()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

//for the suggested trips
class MyTripsSuggested extends StatelessWidget {
  MyTripsSuggested({
    super.key,
    required this.departure,
    required this.arrival,
    required this.date,
    required this.text,
    required this.buttonText,
    required this.press,
  });

  final String departure, arrival, date, text, buttonText;
  final Function press;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final screenWidth = size.width;
    final screenHeight = size.height;
    return GestureDetector(
      onTap: press(),
      child: Container(
        margin: EdgeInsets.only(
            left: screenWidth * 0.02,
            top: screenHeight * 0.01,
            bottom: screenHeight * 0.01,
            right: screenWidth * 0.02),
        width: screenWidth * 0.89,
        height: screenHeight * 0.18,
        padding: EdgeInsets.all(screenWidth * 0.03),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: screenWidth * 0.6,
                  child: AutoSizeText(
                    "$departure - $arrival",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      color: bleu_bg,
                    ),
                    maxLines: 1,
                  ),
                ),
                SizedBox(
                  width: screenWidth * 0.2,
                  child: AutoSizeText(
                    '$date',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      color: bleu_bg,
                    ),
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            SizedBox(
              width: screenWidth * 0.8,
              child: AutoSizeText(
                '$text',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w500,
                  color: bleu_bg,
                ),
                maxLines: 1,
              ),
            ),
            SimpleButton(
              backgroundcolor: orange,
              size: Size(screenWidth * 0.8, screenHeight * 0.055),
              radius: 7,
              text: 'View Trip',
              textcolor: bleu_bg,
              fontsize: 14,
              fct: () {
                ///change iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiit later with the modified trips
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RequestInfo()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// type two of cards , this card is for the ongoing trip
class OngoingTrips {
  final String departure;
  final String arrival;

  OngoingTrips({
    required this.departure,
    required this.arrival,
  });

  bool isEmpty() {
    bool empty = false;
    if (departure == '' && arrival == '') {
      empty = true;
      return (empty);
    } else {
      return (empty);
    }
  }
}

class MyTripsCard2 extends StatelessWidget {
  final OngoingTrips trip;
  const MyTripsCard2({
    super.key,
    required this.trip,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final screenWidth = size.width;
    final screenHeight = size.height;
    if (trip.isEmpty()) {
      return DefaultCard(
        defaultText:
            'No Ongoing trips at the moment. Start planning your next adventure and search for a new trip',
        buttonText: 'Search',
      );
    } else {
      return Container(
        margin: EdgeInsets.only(
            left: screenWidth * 0.02,
            top: screenHeight * 0.01,
            bottom: screenHeight * 0.01,
            right: screenWidth * 0.02),
        width: screenWidth * 0.98,
        height: screenHeight * 0.2,
        padding: EdgeInsets.fromLTRB(screenWidth * 0.03, screenWidth * 0.03,
            screenWidth * 0.03, screenWidth * 0.02),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: screenWidth * 0.8,
              child: AutoSizeText(
                "${trip.departure} - ${trip.arrival}",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                  color: bleu_bg,
                ),
                maxLines: 1,
              ),
            ),
            SizedBox(
              width: screenWidth * 0.8,
              child: AutoSizeText(
                'You are on Trip Now !',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600,
                  color: bleu_bg,
                ),
                maxLines: 1,
              ),
            ),
            SizedBox(
              width: screenWidth * 0.8,
              child: AutoSizeText(
                'you can open and see more information',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w500,
                  color: bleu_bg,
                ),
                maxLines: 1,
              ),
            ),
            SimpleButton(
                backgroundcolor: orange,
                size: Size(screenWidth * 0.8, screenHeight * 0.055),
                radius: 10,
                text: 'Open',
                textcolor: bleu_bg,
                fontsize: 18,
                fct: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OngoingTrip(),
                      ));
                }),
          ],
        ),
      );
    }
  }
}

// type three of cards , this type is for the default "no trip"

class DefaultCard extends StatelessWidget {
  final String defaultText, buttonText;

  const DefaultCard({
    super.key,
    required this.defaultText,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final screenWidth = size.width;
    final screenHeight = size.height;
    return Container(
      margin: EdgeInsets.only(
          left: screenWidth * 0.03,
          top: screenHeight * 0.01,
          bottom: screenHeight * 0.01,
          right: screenWidth * 0.02),
      width: screenWidth * 0.96,
      height: screenHeight * 0.18,
      padding: EdgeInsets.all(screenWidth * 0.03),
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
        image: DecorationImage(
          image: AssetImage('Assets/Images/logobg.png'),
          fit: BoxFit.contain,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: screenWidth * 0.9,
            height: screenHeight * 0.04,
            child: AutoSizeText(
              defaultText,
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w500,
                color: bleu_bg,
              ),
              maxLines: 4,
            ),
          ),
          SimpleButton(
              backgroundcolor: orange,
              size: Size(screenWidth * 0.8, screenHeight * 0.055),
              radius: 10,
              text: buttonText,
              textcolor: bleu_bg,
              fontsize: 18,
              fct: () {
                /// channnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnge it
                /*Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Home(),
                      ));*/
              }),
        ],
      ),
    );
  }
}
