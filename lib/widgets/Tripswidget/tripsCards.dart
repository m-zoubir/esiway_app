import 'package:auto_size_text/auto_size_text.dart';
import 'package:esiway/Screens/Home/home_page.dart';

import 'package:esiway/widgets/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../Screens/Trips/onGoingtrip.dart';
import '../../Screens/Trips/request_info.dart';
import '../simple_button.dart';

// type one of cards , these cards are for the reserved  trips
class AllMyTrips extends StatelessWidget {
  AllMyTrips(
      {super.key,
      required this.departure,
      required this.arrival,
      required this.date,
      required this.text,
      required this.buttonText,
      required this.press,
      required this.passager,
      required this.preferences,
      required this.price,
      required this.tripuid,
      required this.uid});

  String uid;
  String tripuid;
  String price;
  List<dynamic>? passager;
  String preferences;
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
              weight: FontWeight.w700,
              textcolor: bleu_bg,
              fontsize: 14,
              blur: null,
              fct: () {
                if (uid == FirebaseAuth.instance.currentUser!.uid) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RequestInfo(
                              price: price,
                              uid: uid,
                              departure: departure,
                              tripuid: tripuid,
                              arrival: arrival,
                              preferences: preferences,
                              copassager: passager,
                            )),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RequestInfo(
                              price: price,
                              tripuid: tripuid,
                              uid: uid,
                              departure: departure,
                              arrival: arrival,
                              preferences: preferences,
                              copassager: passager,
                            )),
                  );
                }
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
  String departure;
  String arrival;
  String? uid;
  String? Conducteur;
  // final String uid;

  OngoingTrips({
    required this.Conducteur,
    required this.uid,
    required this.departure,
    required this.arrival,
    //required this.uid ,
  });

  bool isEmpty() {
    bool empty = false;
    if (uid == null) {
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
                weight: FontWeight.w700,
                blur: null,
                text: 'Open',
                textcolor: bleu_bg,
                fontsize: 18,
                fct: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OngoingTrip(
                          uid: trip.uid!,
                          Conducteur: trip.Conducteur!,
                        ),
                      ));
                }),
          ],
        ),
      );
    }
  }
}

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
            fit: BoxFit.fitHeight),
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
              weight: FontWeight.w700,
              textcolor: bleu_bg,
              fontsize: 18,
              blur: null,
              fct: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ));
              }),
        ],
      ),
    );
  }
}
