// ignore_for_file: file_names

import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:iconsax/iconsax.dart';
//import 'package:flutter_iconsax/flutter_iconsax.dart';
// ignore: unused_import
import 'package:cached_network_image/cached_network_image.dart';

import 'icons_ESIWay.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatAppBar({
    Key? key,
    required this.backgroundImage,
    required this.onBackButtonPressed,
    required this.context,
    required this.UserPic,
  }) : super(key: key);

  final String backgroundImage;
  final BuildContext context; // Store the context in a member variable
  final VoidCallback onBackButtonPressed;
  final String UserPic;
  @override
  Size get preferredSize =>
      Size.fromHeight(MediaQuery.of(context).size.height * 0.19); //0.298

  @override
  Widget build(BuildContext context) {
    var largeur = MediaQuery.of(context).size.width;
    var hauteur = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        SizedBox(
          height: hauteur * 0.19, //0.25
          width: largeur,
          child: SvgPicture.asset(
            backgroundImage,
            fit: BoxFit.fill,
          ),
        ),
        // Row(
        //  children: [
        Positioned(
          top: hauteur * 0.03, // 0.027,
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
                color: Color(0xFF99CFD7).withOpacity(0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  Padding(
                      padding: EdgeInsets.only(
                        left: largeur * 0.021,
                        right: hauteur * 0.0034,
                      ),
                      child: Icons_ESIWay(
                          icon: "arrow_left", largeur: 20, hauteur: 20)),
                  const SizedBox(
                    width: 3,
                  ),
                  const Text(
                    'Back',
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
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
        // SizedBox(width: 100),
        Positioned(
          top: hauteur * 0.05,
          left: largeur * 0.67,
          child: SizedBox(
            width: largeur * 0.28, //98,
            height: hauteur * 0.12, //9,
            child: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(UserPic),
            ),
          ),
        ),
      ],
    );
  }
}
