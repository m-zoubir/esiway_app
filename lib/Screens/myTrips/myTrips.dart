import 'package:esiway/widgets/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../widgets/bottom_navbar.dart';
import '../../widgets/icons_ESIWay.dart';
import '../../widgets/myTripsWidgets/reservedTrips.dart';
import '../../widgets/myTripsWidgets/suggestedTrips.dart';
import '../../widgets/myTripsWidgets/tripsCards.dart';
import '../../widgets/myTripsWidgets/tripsTitle.dart';
import '../../widgets/prefixe_icon_button.dart';

class MyTrips extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final screenWidth = size.width;
    final screenHeight = size.height;
    return Scaffold(
      bottomNavigationBar: BottomNavBar(currentindex: 3,),
      backgroundColor: color3,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(
                    left: screenWidth * 0.04, top: screenHeight * 0.01),
                child: PrefixeIconButton(
                  size: const Size(73, 34),
                  color: Colors.white,
                  espaceicontext: screenWidth * 0.01,
                  fct: () {
                    // add this later when the home page is done
                    /* Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Home()));*/
                  },
                  fontsize: 14,
                  icon: Icons_ESIWay(
                      icon: 'arrow_left', largeur: 18.0, hauteur: 18.0),
                  radius: 6,
                  text: 'Back',
                  textcolor: bleu_bg,
                  weight: FontWeight.w600,
                ),
              ),
              SizedBox(
                  width: screenWidth * 0.4,
                  child: TitleMyTrips(title: 'My Trips', titleSize: 40.0)),
              SizedBox(
                height: screenHeight * 0.01,
              ),
              SizedBox(
                  width: screenWidth * 0.3,
                  child: TitleMyTrips(title: 'Ongoing', titleSize: 20.0)),
              SizedBox(
                width: screenWidth * 0.99,
                child: MyTripsCard2(
                  trip: OngoingTrips(
                      departure: 'EL HARRACH', arrival: 'OUED SEMAR'),
                ),
              ),
              SizedBox(
                width: screenWidth * 0.3,
                child: TitleMyTrips(
                  title: 'Reserved',
                  titleSize: 20.0,
                ),
              ),
              SizedBox(
                width: screenWidth * 0.95,
                child: MyTripsReservedCard(trips: [
                  ReservedTrip(
                    departure: 'BAB EZZOUR',
                    arrival: 'OUED SEMAR',
                    date: '2023/03/19',
                  ),
                  ReservedTrip(
                    departure: 'KOUBA ',
                    arrival: 'OUED SEMAR',
                    date: '2023/04/12',
                  ),
                  ReservedTrip(
                    departure: 'CHERGA',
                    arrival: 'ZERALDA',
                    date: '2023/06/20',
                  ),
                ]),
              ),
              SizedBox(
                width: screenWidth * 0.3,
                child: TitleMyTrips(
                  title: 'Suggested',
                  titleSize: 20.0,
                ),
              ),
              MyTripsSuggeestedCard(
                trips: [
                  SuggestedTrip(
                    departure: 'TAFOURA',
                    arrival: 'OUED SEMAR',
                    date: '2023/03/19',
                  ),
                  SuggestedTrip(
                    departure: 'KOUBA ',
                    arrival: 'OUED SEMAR',
                    date: '2023/04/12',
                  ),
                  SuggestedTrip(
                    departure: 'CHERGA',
                    arrival: 'ZERALDA',
                    date: '2023/06/20',
                  ),
                ],
              ),
              // navbar(screenHeight, screenWidth),
            ],
          ),
        ),
      ),
    );
  }

// it just an essay i will change it
  Container navbar(double screenHeight, double screenWidth) {
    return Container(
      margin: EdgeInsets.only(
        top: screenHeight * 0.02,
      ),
      width: screenWidth,
      height: screenHeight * 0.0875,
      padding: EdgeInsets.all(screenWidth * 0.01),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(23), topRight: Radius.circular(23)),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 4,
            color: bleu_bg.withOpacity(0.30),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SvgPicture.asset(
            'assets/icons/Vector.svg',
            semanticsLabel: 'My SVG Image',
            width: 24, // Set the size of the SVG image
            height: 24,
          ),
          SvgPicture.asset(
            'assets/icons/routing.svg',
            semanticsLabel: 'My SVG Image',
            width: 24, // Set the size of the SVG image
            height: 24,
          ),
          SvgPicture.asset(
            'assets/icons/messages.svg',
            semanticsLabel: 'My SVG Image',
            width: 24, // Set the size of the SVG image
            height: 24,
          ),
          SvgPicture.asset(
            'assets/icons/Icon.svg',
            semanticsLabel: 'My SVG Image',
            width: 24, // Set the size of the SVG image
            height: 24,
          ),
        ],
      ),
    );
  }
}
