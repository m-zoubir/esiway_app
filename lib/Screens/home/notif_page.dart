import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esiway/widgets/accept_notif.dart';
import 'package:esiway/widgets/constant.dart';
import 'package:esiway/widgets/login_text.dart';
import 'package:esiway/widgets/notif.dart';
import 'package:esiway/widgets/notif_list.dart';
import 'package:esiway/widgets/our_prefixeIconButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Notifpage extends StatefulWidget {
  const Notifpage({super.key});

  @override
  State<Notifpage> createState() => _NotifpageState();
}

class _NotifpageState extends State<Notifpage> {
/*   Future<List<Map<String, String>>> getStackItems() async {
    List<Map<String, String>> stackItems = [];

    // Get a reference to your document
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('Notifications')
        .doc(FirebaseAuth.instance.currentUser!.uid);

    // Get the 'stack' array field and reverse it

    List<dynamic> stack = (await documentReference.get()).data()!["array"];
    stack = stack.reversed.toList();

    // Add each item in the 'stack' array to the list of stack items
    stack.forEach((item) {
      stackItems.add({
        'title': item[0],
        'description': item[1],
        'author': item[2],
        'date': item[3],
      });
    });

    return stackItems;
  } */

  initState() {
    super.initState();

    // await docTrips.doc("${auth.currentUser?.uid}").set(json);
  }

  void login() {}
  final String today = 'Today';
  final String month = 'This month';
  final String notif = 'Notifications';

  List<dynamic> notifList = [
    StreamBuilder(
      stream: FirebaseFirestore.instance.collection('Users').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          return AcceptB();
        } else {
          return Notif();
        }
      },
    ),
    Notif(),

    /*   Container(
      margin: EdgeInsets.only(left: 32),
      child: Text(
        'Today',
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: bleu_bg,
            fontFamily: 'mont'),
      ),
    ), */
  ];
  @override
  Widget build(BuildContext context) {
    var largeur = MediaQuery.of(context).size.width;
    var hauteur = MediaQuery.of(context).size.height;
    //   addToEndOfArray('newElemen 1');
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Padding(
                padding:
                    EdgeInsets.only(left: largeur * 0.05, top: hauteur * 0.04),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    OurPrefixeIconButton(
                        size: const Size(73, 34),
                        color: Colors.white,
                        radius: 10,
                        text: "Back",
                        textcolor: const Color(0xFF20236C),
                        weight: FontWeight.w600,
                        fontsize: 14,
                        iconName: "arrow_left",
                        espaceicontext: 0.0,
                        fct: login),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 32, top: 20),
                child: Row(
                  children: [
                    MyText(
                      text: notif,
                      weight: FontWeight.bold,
                      fontsize: 24,
                      color: bleu_bg,
                      largeur: 0.5 * largeur,
                    )
                  ],
                ),
                //   ),

                // Text(
                //   textAlign: TextAlign.start,
                //   'Notifcations',
                //   style: TextStyle(
                //       fontSize: 24,
                //       fontWeight: FontWeight.bold,
                //       color: BLUE,
                //       fontFamily: 'mont'),
              ),

              /////////////////////////////////////////////////////////////////
            ],
          ),
        ),
      ),
    );
  }
}
