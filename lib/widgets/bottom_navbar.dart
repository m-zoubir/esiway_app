import 'package:esiway/Screens/Profile/profile_screen.dart';
import 'package:esiway/Screens/home/home_page.dart';
import 'package:esiway/Screens/home/rating.dart';
import 'package:flutter/material.dart';
import '../Screens/SignIn_Up/myTrips.dart';
import '../Screens/SignIn_Up/notification_page.dart';
import 'constant.dart';
import 'icons_ESIWay.dart';

class BottomNavBar extends StatefulWidget {
  BottomNavBar({super.key, required this.currentindex});
  int currentindex;

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  final tab = [
    Home(),
    MyTrips(),
    NotificationPage(),
    Profile(),
  ];

  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 4,
      shadowColor: Colors.grey.withOpacity(0.3),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,

          //  color: Color.fromARGB(0xFF, 0xF9, 0xF8, 0xFF),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(23),
            topRight: Radius.circular(23),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              enableFeedback: false,
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => HomePage()));
              },
              icon: Transform.scale(
                scale: 1,
                child: Icons_ESIWay(
                    icon: widget.currentindex == 0 ? "home" : "home_bleu",
                    largeur: 26,
                    hauteur: 26),
              ),
            ),
            IconButton(
              enableFeedback: false,
              onPressed: () {},
              icon: Transform.scale(
                scale: 1,
                child: Icons_ESIWay(
                    icon: widget.currentindex == 1 ? "routing_vert" : "routing",
                    largeur: 26,
                    hauteur: 26),
              ),
            ),
            IconButton(
              enableFeedback: false,
              onPressed: () {},
              icon: Transform.scale(
                scale: 1,
                child: Icons_ESIWay(
                    icon:
                        widget.currentindex == 2 ? "messages_vert" : "messages",
                    largeur: 26,
                    hauteur: 26),
              ),
            ),
            IconButton(
              enableFeedback: false,
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Profile()));
              },
              icon: Transform.scale(
                scale: 1,
                child: Icons_ESIWay(
                    icon: widget.currentindex == 3 ? "user" : "user_bleu",
                    largeur: 26,
                    hauteur: 26),
              ),
            ),
          ],
        ),
      ),
    );
  }

/*
    Widget build(BuildContext context) {
    int _selectedindex = widget.currentindex;
    return BottomNavigationBar(
      fixedColor: Theme.of(context).scaffoldBackgroundColor,
      type: BottomNavigationBarType.fixed,
      currentIndex: widget.currentindex,
      items: [
        BottomNavigationBarItem(
          label: "",
          icon: Transform.scale(
            scale: 1,
            child: Icons_ESIWay(
              hauteur: 24,
              largeur: 24,
              icon: widget.currentindex == 0 ? "home" : "home_bleu",
            ),
          ),
        ),
        BottomNavigationBarItem(
          label: "",
          icon: Transform.scale(
            scale: 1,
            child: Icons_ESIWay(
              hauteur: 24,
              largeur: 24,
              icon: widget.currentindex == 1 ? "routing_vert" : "routing",
            ),
          ),
        ),
        BottomNavigationBarItem(
          label: "",
          icon: Transform.scale(
            scale: 1,
            child: Icons_ESIWay(
              hauteur: 24,
              largeur: 24,
              icon:widget.currentindex == 2 ? "messages_vert" : "messages",
            ),
          ),
        ),
        BottomNavigationBarItem(
          label: "",
          icon: Icons_ESIWay(
            hauteur: 24,
            largeur: 24,
            icon:  widget.currentindex == 3 ? "user" : "user_bleu",
          ),
        ),
      ],
      onTap: (index) {
        setState(() {
          _selectedindex = index;
        });

        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) {
            return tab[_selectedindex];
          }),
        );
      },
    );
  }*/
}
