// ignore_for_file: file_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/MabelText.dart';
import 'Chat2.dart';
import '/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'GettingTripLocation.dart';

// ignore: unused_import
import 'package:iconsax/iconsax.dart';
//import 'package:flutter_iconsax/flutter_iconsax.dart';
// ignore: unused_import
// ignore: unused_import, depend_on_referenced_packages

import 'GettingTripLocation.dart';
import 'GroupeImage.dart';

class GettingTripLocations extends StatelessWidget {
  final String startField;
  final String arrivalField;

  GettingTripLocations({required this.startField, required this.arrivalField});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('trip').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();

        final List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

        final List<String> tripLocations = [];

        for (var document in documents) {
          final String startLocation = document.get(startField);
          final String arrivalLocation = document.get(arrivalField);
          tripLocations.add('$startLocation-$arrivalLocation');
        }

        return ListView(
          children: tripLocations.map((String tripLocation) {
            return ListTile(
              title: ResponsiveText(
                text: tripLocation,
                minFontSize: 15,
                maxFontSize: 25,
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

//the idea is to create an app bar for the char that changes from user to user and that contains the wave the group name and the pople in the chat
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
        Positioned(
          top: hauteur * 0.03, // 0.027,
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
                color: const Color(0xFF99CFD7).withOpacity(0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: largeur * 0.021,
                      right: hauteur * 0.0034,
                    ),
                    child: SvgPicture.asset(
                      'Assets/arrow.svg',
                      width: 18,
                      height: 18,
                    ),
                  ),
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
        Positioned(
          top: hauteur * 0.067,
          left: largeur * 0.70,
          child: //9,

              SizedBox(
            child: GroupChatImage(
              chatId: UserPic,
              height: hauteur * 0.125,
              width: largeur * 0.27,
              n: 2.7,
            ),
          ),
        ),
      ],
    );
  }
}

/*
class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final height = mediaQuery.size.height;
    final width = mediaQuery.size.width;
    return Scaffold(
      backgroundColor: const Color(0xFFF9F8FF),
      appBar: ChatAppBar(
        context: context,
        backgroundImage: 'assets/BG2.svg',
        onBackButtonPressed: () {
          Navigator.pop(context);
        },

        ///TO GET THE USER IMAGE FROM FIRESTORE
        ///final ref = firebase_storage.FirebaseStorage.instance.ref().child('users/${userId}/avatar.jpg');
        ///final url = await ref.getDownloadURL();
        UserPic: currentUser.imageURl,
      ),
      // 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTuosO-qLiP-ewzt11bdowVVr_vzoDp8TWIFw&usqp=CAU'),
      body: Column(
        children: [
          // PileofMsgs(),
        ],
      ),
    );
  }
}*/

class DisplayGroupeName extends StatelessWidget {
  const DisplayGroupeName({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final height = mediaQuery.size.height;
    final width = mediaQuery.size.width;
    return Container(
      width: width,
      height: 35,
      child: Expanded(
        child:
            GettingTripLocations(startField: 'start', arrivalField: 'arrival'),
      ),
    );
  }
}

//GettingTripLocations(startField: 'start', arrivalField: 'arrival'), the call
class ResponsiveText extends StatelessWidget {
  final String text;
  final double minFontSize;
  final double maxFontSize;

  ResponsiveText({
    required this.text,
    required this.minFontSize,
    required this.maxFontSize,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth / 10; // adjust this value as needed

    // limit the font size to a specific range
    if (fontSize < minFontSize) {
      fontSize = minFontSize;
    } else if (fontSize > maxFontSize) {
      fontSize = maxFontSize;
    }

    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.bold,
        fontSize: fontSize,
        color: const Color(0xFF20236C),
      ),
      overflow: TextOverflow.ellipsis,
    );
  }
}
