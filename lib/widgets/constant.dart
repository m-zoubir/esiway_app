import 'package:flutter/material.dart';

import '../Screens/Profile/profile_screen.dart';
import '../Screens/SignIn_Up/myTrips.dart';
import '../Screens/SignIn_Up/notification_page.dart';
import '../Screens/home/rating.dart';
import '../Screens/home/home_page.dart';


const Color bleu_bg = Color.fromARGB(0xFF, 0x20, 0x23, 0x6C);
const Color bleu_ciel = Color.fromARGB(0xFF, 0xAE, 0xD6, 0xDC);
const Color color3 = Color.fromARGB(0xFF, 0xF5, 0xF5, 0xF5);
const Color orange = Color.fromARGB(0xFF, 0xFF, 0xA1, 0x8E);
const Color vert = Color.fromARGB(0xFF, 0x72, 0xD2, 0xC2);
const Color color6 = Color.fromARGB(0xFF, 0x99, 0xCF, 0xD7);
const Color color1_disable = Color.fromARGB(0xFF, 0x70, 0x80, 0x90);
const Color color4_disable = Color.fromARGB(0xFF, 0xFF, 0xA1, 0x8E);

const String LOGO = "Assets/Images/LOGO.png";

final isphone = RegExp(r'^(0|\+213)[5-7]( */d{2}){4}$');

final tab = [
  HomePage(),
  MyTrips(),
  NotificationPage(),
  Profile(),
];


//Rating
/*
 RatingBar.builder(
            initialRating: 3,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              print(rating);
            },
          ),
 */
