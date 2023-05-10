import 'package:esiway/Screens/Profile/admin_trips.dart';
import 'package:flutter/material.dart';

import '../../widgets/bottom_navbar.dart';
import '../../widgets/constant.dart';
import '../../widgets/icons_ESIWay.dart';
import '../../widgets/tile_list.dart';
import 'admin_users.dart';
import 'settings_screen.dart';

class AdminScreen extends StatefulWidget {
  AdminScreen({Key? key}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color3,
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
                  return SettingsScreen();
                },
              ),
            );
          },
          color: vert,
        ),
        title: Text(
          "Administrator",
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
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(children: [
          Listbox(
            title: "Users",
            iconName: "user",
            scale: 0.7,
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AdminInfoUsers()));
            },
          ),
          Listbox(
            title: "Trips",
            iconName: "routing_vert",
            scale: 0.7,
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => AdminTrips()));
            },
          ),
        ]),
      ),
    );
  }
}
