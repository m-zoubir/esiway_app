// ignore_for_file: file_names

import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';

import 'icons_ESIWay.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({
    Key? key,
    required this.backgroundImage,
    required this.onBackButtonPressed,
    required this.context, // Pass the context as a parameter to the constructor
  }) : super(key: key);

  final String backgroundImage;
  final BuildContext context; // Store the context in a member variable
  final VoidCallback onBackButtonPressed;

  @override
  Size get preferredSize =>
      Size.fromHeight(MediaQuery.of(context).size.height * 0.22); //0.298

  @override
  Widget build(BuildContext context) {
    var largeur = MediaQuery.of(context).size.width;
    var hauteur = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        SizedBox(
          height: hauteur * 0.25, //0.25
          width: largeur,
          child: SvgPicture.asset(
            backgroundImage,
            fit: BoxFit.fill,
          ),
        ),
        Positioned(
          top: hauteur * 0.05, // 0.027,
          //right: MediaQuery.of(context).size.width * 0.75,
          left: largeur * 0.02,
          child: GestureDetector(
            onTap: onBackButtonPressed,
            child: Container(
              width: largeur * 0.20,
              height: hauteur * 0.04,
              margin: EdgeInsets.only(
                left: largeur * 0.086,
                top: hauteur * 0.033,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: largeur * 0.011,
                      right: hauteur * 0.0024,
                    ),
                    child: const Icons_ESIWay(
                        icon: "arrow_left", largeur: 18, hauteur: 18),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  const Text(
                    'Back',
                    style: TextStyle(
                      color: Color(0xff20236C),
                      fontFamily: 'Montserrat-Bold',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
