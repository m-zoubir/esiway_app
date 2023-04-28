import 'package:flutter/material.dart';

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
              icon: "home_bleu",
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
              icon: "routing",
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
              icon: "messages",
            ),
          ),
        ),
        BottomNavigationBarItem(
          label: "",
          icon: Icons_ESIWay(
            hauteur: 24,
            largeur: 24,
            icon: "user",
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
  }
}
