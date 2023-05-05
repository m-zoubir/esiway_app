import 'package:esiway/widgets/constant.dart';
import 'package:flutter/material.dart';
import '../../widgets/icons_ESIWay.dart';
import '../../widgets/myTripsWidgets/infoTrip.dart';
import '../../widgets/myTripsWidgets/onGoingBox.dart';
import '../../widgets/myTripsWidgets/profileTripCard.dart';
import '../../widgets/simple_button.dart';

class OngoingTrip extends StatelessWidget {
  OngoingTrip({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final screenWidth = size.width;
    final screenHeight = size.height;
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OngoingBox(),
            Container(
              margin: EdgeInsets.only(
                  left: screenWidth * 0.02,
                  top: screenHeight * 0.01,
                  bottom: screenHeight * 0.02,
                  right: screenWidth * 0.01),
              width: screenWidth * 0.89,
              height: screenHeight * 0.25,
              padding: EdgeInsets.only(
                  left: screenWidth * 0.03,
                  top: screenHeight * 0.01,
                  right: screenWidth * 0.02),
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
                  ProfileTripCard(
                    name: 'Sisaber',
                    staff: 'Student',
                    rating: 4.0,
                    profileImage: 'profile1',
                    color: bleu_bg,
                  ),
                  SizedBox(
                    width: screenWidth * 0.2,
                    child: InfoTripBox(
                      arrival: 'OUED SEMAR',
                      departure: 'EL HARRACH',
                      price: 150.0,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //crossAxisAlignment: ,
                    children: [
                      SizedBox(
                        width: screenWidth * 0.68,
                        child: SimpleButton(
                            backgroundcolor: orange,
                            size: Size(screenWidth * 0.68, screenHeight * 0.05),
                            radius: 8,
                            text: 'Car information',
                            textcolor: bleu_bg,
                            fontsize: 14,
                            fct: () {}),
                      ),
                      Container(
                        width: screenWidth * 0.11,
                        height: screenHeight * 0.05,
                        margin: EdgeInsets.only(right: 2),
                        decoration: BoxDecoration(
                          color: orange,
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 0),
                              blurRadius: 4,
                              color: bleu_bg.withOpacity(0.15),
                            ),
                          ],
                        ),
                        child: IconButton(
                          onPressed: () {},
                          color: orange,
                          iconSize: 30,
                          // alignment: AlignmentGeometry(),
                          icon: Icons_ESIWay(
                              icon: 'add_message', largeur: 18, hauteur: 18),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
