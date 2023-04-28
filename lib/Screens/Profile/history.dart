import 'package:esiway/Screens/Profile/profile_screen.dart';
import 'package:esiway/widgets/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';

import '../../widgets/constant.dart';
import '../../widgets/icons_ESIWay.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color3,
      bottomNavigationBar: BottomNavBar(currentindex: 3),
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        leading: IconButton(
          icon: Transform.scale(
            scale: 0.9,
            child: Icons_ESIWay(icon: "arrow_left", largeur: 50, hauteur: 50),
          ),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return Profile();
                },
              ),
            );
          },
          color: vert,
        ),
        title: Text(
          "History",
          style: TextStyle(
            color: bleu_bg,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Transform.scale(
              scale: 0.8,
              child: Icons_ESIWay(icon: "help", largeur: 35, hauteur: 35),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: TripInfoResume(
              arrival: "arrival",
              departure: "departure",
              color: orange.withOpacity(0.5),
              date: "23-14-2022",
              name: "name",
              price: "150",
              time: "2:30"),
        ),
      ),
    );
  }
}

class TripInfoResume extends StatelessWidget {
  TripInfoResume({
    super.key,
    this.profile_picture,
    required this.arrival,
    required this.departure,
    required this.color,
    required this.date,
    required this.name,
    required this.price,
    required this.time,
  });
  String price;
  String time;
  String date;
  String departure;
  String arrival;
  String name;
  Color color;
  String? profile_picture;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      height: 120,
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ProfileTripCard(
                name: name,
                profileImage: profile_picture,
                color: bleu_bg,
              ),
              InfoTripBox(
                price: 15,
                departure: departure,
                arrival: arrival,
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 65),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "date\n",
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w700,
                          color: bleu_bg,
                        ),
                      ),
                      TextSpan(
                        text: date,
                        style: TextStyle(
                          fontSize: 10,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w500,
                          color: bleu_bg,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "time\n",
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w700,
                          color: bleu_bg,
                        ),
                      ),
                      TextSpan(
                        text: time,
                        style: TextStyle(
                          fontSize: 10,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w500,
                          color: bleu_bg,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "price\n",
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w700,
                          color: bleu_bg,
                        ),
                      ),
                      TextSpan(
                        text: price,
                        style: TextStyle(
                          fontSize: 10,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w500,
                          color: bleu_bg,
                        ),
                      ),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w700,
                          color: bleu_bg,
                        ),
                      ),
                      TextSpan(
                        text: '',
                        style: TextStyle(
                          fontSize: 10,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w500,
                          color: bleu_bg,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileTripCard extends StatelessWidget {
  String name;
  String? profileImage;
  Color color;

  ProfileTripCard({
    Key? key,
    required this.name,
    this.profileImage,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final screenWidth = size.width;
    final screenHeight = size.height;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
              border: Border.all(
                width: 0,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              shape: BoxShape.circle,
              image: profileImage == null
                  ? DecorationImage(
                      image: AssetImage("Assets/Images/photo_profile.png"),
                      fit: BoxFit.cover,
                    )
                  : DecorationImage(
                      image: NetworkImage(profileImage!),
                      fit: BoxFit.cover,
                    )),
        ),
        SizedBox(
          width: screenWidth * 0.02,
        ),
        Text(
          "$name",
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }
}

class InfoTripBox extends StatelessWidget {
  final double price;
  final String departure, arrival;
  const InfoTripBox({
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
          width: 42, // Set the size of the SVG image
          height: 42,
        ),
        SizedBox(
          width: screenWidth * 0.01,
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "$departure\n\n",
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                  color: bleu_bg,
                ),
              ),
              TextSpan(
                text: '$arrival',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                  color: bleu_bg,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
