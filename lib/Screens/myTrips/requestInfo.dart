import 'package:auto_size_text/auto_size_text.dart';
import 'package:esiway/Screens/Profile/car_information_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../widgets/alertdialog.dart';
import '../../widgets/constant.dart';
import '../../widgets/myTripsWidgets/infoTrip.dart';
import '../../widgets/myTripsWidgets/profileTripCard.dart';
import '../../widgets/myTripsWidgets/tripsComments.dart';
import '../../widgets/myTripsWidgets/tripsTitle.dart';
import '../../widgets/simple_button.dart';

class RequestInfo extends StatelessWidget {
  final List<Comment> comments = [
    Comment(
        text:
            'Thanks for being a great driver!jdngkjdsb gjadsbgk ajdbgkjasd bgsdnbgvd sjbgjk sdgb',
        name: 'Zaidi Yasmine',
        timestamp: DateTime.now(),
        photoProfile: 'profile'),
    Comment(
        text: 'Thanks for being a great driver!  ',
        name: 'Zaidi Yasmine',
        timestamp: DateTime.now(),
        photoProfile: 'profile'),
    Comment(
        text: 'Thanks for being a great driver! ',
        name: 'Zaidi Yasmine',
        timestamp: DateTime.now(),
        photoProfile: 'profile'),
  ];
  ProfileTripCard profileInfo = new ProfileTripCard(
      name: 'Sisaber Rania',
      staff: 'Student',
      rating: 4.0,
      profileImage: 'profile1',
      color: Colors.white);

  InfoTripBox2 tripInfo = new InfoTripBox2(
      price: 150, departure: 'Bab Ezzour', arrival: 'Oued Semar');
  RequestInfo({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final screenWidth = size.width;
    final screenHeight = size.height;
    return Scaffold(
      bottomNavigationBar: NavShape(
        buttonText: 'Cancel',
        buttonColor: bleu_ciel,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              child: Stack(
                children: [
                  Container(
                    width: screenWidth,
                    height: screenHeight * 0.13,
                    padding: EdgeInsets.only(
                        left: screenWidth * 0.03, right: screenWidth * 0.03),
                    decoration: BoxDecoration(
                      color: bleu_bg,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 0),
                          blurRadius: 4,
                          color: bleu_bg.withOpacity(0.15),
                        ),
                      ],
                    ),
                    child: ProfileTripCard(
                      name: profileInfo.name,
                      profileImage: profileInfo.profileImage,
                      rating: profileInfo.rating,
                      staff: profileInfo.staff,
                      color: profileInfo.color,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  Container(
                    color: bleu_bg,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: color3,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(screenWidth * 0.06),
                          topLeft: Radius.circular(screenWidth * 0.06)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InfoTripBox2(
                            price: tripInfo.price,
                            departure: tripInfo.departure,
                            arrival: tripInfo.arrival),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TitleMyTrips(title: 'Preferences', titleSize: 16.0),
                            Preferences(
                              preference1: 'Bag',
                              preference2: 'Talking',
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TitleMyTrips(
                                title: 'Your Co-passenger for Today',
                                titleSize: 16.0),
                            SizedBox(
                              height: screenHeight * 0.01,
                            ),
                            CoPassenger(
                              namePassenger: 'Zaidi',
                              lastnamePassenger: 'Yasmine',
                              imagePassenger: 'profile',
                            ),
                          ],
                        ),
                        Container(
                          height: screenHeight * 0.05,
                          child: SimpleButton(
                              backgroundcolor: orange,
                              size:
                                  Size(screenWidth * 0.90, screenHeight * 0.05),
                              radius: 8,
                              text: 'Car information',
                              textcolor: bleu_bg,
                              fontsize: 16,
                              fct: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CarInfo()));
                              }),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TitleMyTrips(
                                title: 'Rider\'s Review ', titleSize: 16.0),
                            CommentsBloc(comments: comments),
                          ],
                        ),
                      ],
                    ),
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

/*888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
class RequestInfo extends StatelessWidget {

  RequestInfo({
    super.key,
  });

  final List<Comment> comments = [
    Comment(
        text: 'Thanks for being a great driver!',
        name: 'Zaidi Yasmine',
        timestamp: DateTime.now(),
        photoProfile: 'profile'),
    Comment(
        text: 'Thanks for being a great driver!  ',
        name: 'Zaidi Yasmine',
        timestamp: DateTime.now(),
        photoProfile: 'profile'),
    Comment(
        text: 'Thanks for being a great driver! ',
        name: 'Zaidi Yasmine',
        timestamp: DateTime.now(),
        photoProfile: 'profile'),
  ];

  ProfileTripCard profileInfo = new ProfileTripCard(
      name: 'Sisaber Rania',
      staff: 'Student',
      rating: 4.0,
      profileImage: 'profile1',
      color: Colors.white);

  InfoTripBox2 tripInfo = new InfoTripBox2(
      price: 150, departure: 'Bab Ezzour', arrival: 'Oued Semar');

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;

    return Scaffold(
      bottomNavigationBar: NavShape(
        buttonText: 'Cancel',
        buttonColor: Couleur().BLUE_CIEL,
      ),
      body: SafeArea(
        child: GestureDetector(
          onVerticalDragUpdate: (details) {
        

            if (details.primaryDelta! > 0) {
              // Dragged downwards
              Navigator.of(context).pop();
            }
          },
          child: Column(
            children: [
              Container(
                child: Stack(
                  children: [
                    Container(
                      width: screenWidth,
                      height: screenHeight * 0.13,
                      padding: EdgeInsets.only(
                          left: screenWidth * 0.03,
                          right: screenWidth * 0.03),
                      decoration: BoxDecoration(
                        color: Couleur().BLUE,
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 0),
                            blurRadius: 4,
                            color: Couleur().BLUE.withOpacity(0.15),
                          ),
                        ],
                      ),
                      child: ProfileTripCard(
                        name: profileInfo.name,
                        profileImage: profileInfo.profileImage,
                        rating: profileInfo.rating,
                        staff: profileInfo.staff,
                        color: profileInfo.color,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      color: Couleur().BLUE,
                    ),
                    Container(
                      width: screenWidth,
                      height: screenHeight * 0.8,
                      decoration: BoxDecoration(
                        color: Couleur().BLANC,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(screenWidth * 0.06),
                            topLeft: Radius.circular(screenWidth * 0.06)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InfoTripBox2(
                              price: tripInfo.price,
                              departure: tripInfo.departure,
                              arrival: tripInfo.arrival),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              TitleMyTrips(
                                  title: 'Preferences', titleSize: 16.0),
                              Preferences(
                                preference1: 'Bag',
                                preference2: 'Talking',
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TitleMyTrips(
                                  title: 'Your Co-passenger for Today',
                                  titleSize: 16.0),
                              SizedBox(
                                height: screenHeight * 0.01,
                              ),
                              CoPassenger(
                                namePassenger: 'Zaidi',
                                lastnamePassenger: 'Yasmine',
                                imagePassenger: 'profile',
                              ),
                            ],
                          ),
                          SizedBox(
                            height: screenHeight * 0.009,
                          ),
                          Container(
                            height: screenHeight * 0.05,
                            child: SimpleButton(
                                backgroundcolor: Couleur().ORANGE,
                                size: Size(
                                    screenWidth * 0.90, screenHeight * 0.05),
                                radius: 8,
                                text: 'Car information',
                                textcolor: Couleur().BLUE,
                                fontsize: 16,
                                fct: () {}),
                          ),
                          SizedBox(
                            height: screenHeight * 0.009,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              TitleMyTrips(
                                  title: 'Rider\'s Review ', titleSize: 16.0),
                              SizedBox(
                                height: screenHeight * 0.01,
                              ),
                              CommentsBloc(comments: comments),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
        ),
      ),
    );
  }
}

88888888888888888888888888888888888888888888888888888888888888888888888888888888888888*/
class CommentsBloc extends StatelessWidget {
  const CommentsBloc({
    super.key,
    required this.comments,
  });

  final List<Comment> comments;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;
    return SingleChildScrollView(
        child: Container(
            decoration: BoxDecoration(
              color: bleu_ciel.withOpacity(0.15),
              borderRadius: BorderRadius.circular(screenWidth * 0.04),
            ),
            margin: EdgeInsets.only(
                left: screenWidth * 0.06, right: screenWidth * 0.03),
            padding: EdgeInsets.all(screenWidth * 0.02),
            height: screenHeight * 0.16,
            child: CommentsList(comments: comments)));
  }
}

class CoPassenger extends StatelessWidget {
  const CoPassenger({
    super.key,
    required this.namePassenger,
    required this.lastnamePassenger,
    required this.imagePassenger,
  });

  final String namePassenger;
  final String lastnamePassenger;
  final String imagePassenger;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(left: screenWidth * 0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage:
                    AssetImage('Assets/Images/${imagePassenger}.jpg'),
                radius: 30.0,
              ),
              SizedBox(
                height: screenHeight * 0.01,
              ),
              SizedBox(
                width: screenWidth * 0.4,
                child: AutoSizeText(
                  '${namePassenger}' '\n' '${lastnamePassenger}',
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600,
                    color: bleu_bg,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class Preferences extends StatelessWidget {
  final String preference1, preference2;

  const Preferences({
    super.key,
    required this.preference1,
    required this.preference2,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;
    return Container(
      width: screenWidth,
      padding: EdgeInsets.only(
          left: screenWidth * 0.05,
          top: screenHeight * 0.01,
          bottom: screenHeight * 0.02),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: preference1,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: bleu_bg,
              ),
            ),
            WidgetSpan(
              child: SizedBox(width: 10),
            ),
            TextSpan(
              text: preference2,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: bleu_bg,
              ),
            ),
            WidgetSpan(
              child: SizedBox(width: 10),
            ),
          ],
        ),
      ),
    );
  }
}

class NavShape extends StatelessWidget {
  NavShape({super.key, required this.buttonText, required this.buttonColor});
  final String buttonText;
  final Color buttonColor;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;
    return Stack(
      children: [
        SizedBox(
          width: screenWidth, // Set the size of the SVG image
          height: screenHeight * 0.13,
          child: SvgPicture.asset(
            'Assets/Images/vector1.svg',
            semanticsLabel: 'My SVG Image',
            fit: BoxFit.fill,
          ),
        ),
        Positioned(
          left: screenWidth * 0.08,
          top: screenHeight * 0.055,
          child: SimpleButton(
              backgroundcolor: buttonColor,
              size: Size(screenWidth * 0.86, screenHeight * 0.04),
              radius: 8,
              text: buttonText,
              textcolor: bleu_bg,
              fontsize: 16,
              fct: () {
                showDialog(
                  context: context,
                  builder: (context) => CustomAlertDialog(
                    question: 'Are you sure you want to cancel the trip',
                    greentext: 'Yes',
                    greenfct: () {},
                    redfct: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RequestInfo(),
                        ),
                      );
                    },
                    redtext: 'Back',
                  ),
                );
              }),
        ),
      ],
    );
  }
}
