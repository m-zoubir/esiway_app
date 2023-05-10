import 'package:esiway/Screens/Chat/Chat_screen.dart';
import 'package:esiway/Screens/Profile/profile_screen.dart';
import 'package:esiway/Screens/Home/home_page.dart';
import 'package:flutter/material.dart';
import '../Screens/Trips/mytrips.dart';
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
    HomePage(),
    MyTrips(),
    Chat_secreen(),
    Profile(),
  ];
  Widget build(BuildContext context) {
    // int _selectedindex = widget.currentindex;
    // return Container(
    //   decoration: BoxDecoration(
    //     borderRadius: BorderRadius.only(
    //         topRight: Radius.circular(30), topLeft: Radius.circular(30)),
    //     boxShadow: [
    //       BoxShadow(
    //           color: bleu_bg.withOpacity(0.15),
    //           spreadRadius: 0,
    //           blurRadius: 10),
    //     ],
    //   ),
    //   child: ClipRRect(
    //     borderRadius: BorderRadius.only(
    //       topLeft: Radius.circular(23.0),
    //       topRight: Radius.circular(23.0),
    //     ),
    //     child: BottomNavigationBar(
    //       showSelectedLabels: false,
    //       showUnselectedLabels: false,
    //       fixedColor: Theme.of(context).scaffoldBackgroundColor,
    //       type: BottomNavigationBarType.fixed,
    //       currentIndex: widget.currentindex,
    //       items: [
    //         BottomNavigationBarItem(
    //           label: "",
    //           icon: Transform.scale(
    //             scale: 1,
    //             child: Icons_ESIWay(
    //               hauteur: 24,
    //               largeur: 24,
    //               icon: widget.currentindex == 0 ? "home" : "home_bleu",
    //             ),
    //           ),
    //         ),
    //         BottomNavigationBarItem(
    //           label: "",
    //           icon: Transform.scale(
    //             scale: 1,
    //             child: Icons_ESIWay(
    //               hauteur: 25,
    //               largeur: 25,
    //               icon: widget.currentindex == 1 ? "routing_vert" : "routing",
    //             ),
    //           ),
    //         ),
    //         BottomNavigationBarItem(
    //           label: "",
    //           icon: Transform.scale(
    //             scale: 1,
    //             child: Icons_ESIWay(
    //               hauteur: 26,
    //               largeur: 26,
    //               icon: widget.currentindex == 2 ? "messages_vert" : "messages",
    //             ),
    //           ),
    //         ),
    //         BottomNavigationBarItem(
    //           label: "",
    //           icon: Icons_ESIWay(
    //             hauteur: 26,
    //             largeur: 26,
    //             icon: widget.currentindex == 3 ? "user" : "user_bleu",
    //           ),
    //         ),
    //       ],
    //       onTap: (index) {
    //         setState(() {
    //           _selectedindex = index;
    //         });

    //         Navigator.of(context).push(
    //           MaterialPageRoute(builder: (context) {
    //             return tab[_selectedindex];
    //           }),
    //         );
    //       },
    //     ),
    //   ),
    // );

    return Material(
      color: Colors.transparent,
      elevation: 4,
      shadowColor: bleu_bg.withOpacity(0.15),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
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
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => MyTrips()));
              },
              icon: Transform.scale(
                scale: 1,
                child: Icons_ESIWay(
                    icon: widget.currentindex == 1 ? "routing_vert" : "routing",
                    largeur: 27,
                    hauteur: 27),
              ),
            ),
            IconButton(
              enableFeedback: false,
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => Chat_secreen()));
              },
              icon: Transform.scale(
                scale: 1,
                child: Icons_ESIWay(
                    icon:
                        widget.currentindex == 2 ? "messages_vert" : "messages",
                    largeur: 27,
                    hauteur: 27),
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
                    largeur: 27,
                    hauteur: 27),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
