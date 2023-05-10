import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esiway/Screens/Chat/Chat_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import '../../widgets/icons_ESIWay.dart';
import '../../widgets/prefixe_icon_button.dart';
import 'GroupeImage.dart';

class GettingTripLocations extends StatelessWidget {
  final String startField;
  final String arrivalField;

  GettingTripLocations({required this.startField, required this.arrivalField});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Trips').snapshots(),
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

  void back() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => Chat_secreen()));
  }

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
          child: Container(
            margin: EdgeInsets.only(top: 20, left: 20),
            width: 80,
            height: 35,
            child: PrefixeIconButton(
                size: const Size(73, 34),
                color: const Color(0xFF99CFD7).withOpacity(0.2),
                radius: 8,
                text: "Back",
                textcolor: Color.fromARGB(255, 255, 255, 255),
                weight: FontWeight.w600,
                fontsize: 14,
                icon: Transform.scale(
                  scale: 0.75,
                  child: Icons_ESIWay(
                      icon: "arrow_left_white", largeur: 30, hauteur: 30),
                ),
                espaceicontext: 5.0,
                fct: back),
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
      child: GettingTripLocations(startField: 'start', arrivalField: 'arrival'),
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
      overflow: TextOverflow.fade,
    );
  }
}
