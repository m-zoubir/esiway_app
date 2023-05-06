import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esiway/widgets/accept_notif.dart';
import 'package:esiway/widgets/constant.dart';
import 'package:esiway/widgets/login_text.dart';
import 'package:esiway/widgets/notif.dart';
import 'package:esiway/widgets/notif_list.dart';
import 'package:esiway/widgets/our_prefixeIconButton.dart';
import 'package:flutter/material.dart';

class Notifpage extends StatefulWidget {
  const Notifpage({super.key});

  @override
  State<Notifpage> createState() => _NotifpageState();
}

/* void getDocumentsFromTwoCollections(String collection1, String collection2) {
  final CollectionReference collectionRef1 = firestore.collection(collection1);
  final CollectionReference collectionRef2 = firestore.collection(collection2);

  final List<Future<QuerySnapshot>> futures = [
    collectionRef1.get(),
    collectionRef2.get(),
  ];

  Future.wait(futures).then((snapshots) {
    final List<DocumentSnapshot> documents1 = snapshots[0].docs;
    final List<DocumentSnapshot> documents2 = snapshots[1].docs;

    // Do something with the documents from both collections
  }).catchError((error) {
    print('Failed to get documents from collections: $error');
  });
} */

final FirebaseFirestore firestore = FirebaseFirestore.instance;

// stocker les notifications du conducteur
/* void addToEndOfArray(dynamic newElement) {
  final auth = FirebaseAuth.instance;
  final DocumentReference docRef = firestore
      .collection('Notifications')
      .doc('${firestore.collection('Users').doc('${auth.currentUser?.uid}')}');

  final Timestamp now = Timestamp.now();
  docRef.update({
    'n': FieldValue.arrayUnion([newElement]),
    'last_modified': now,
  }).then((value) {
    print('New element added to the end of array successfully');
  }).catchError((error) {
    print('Failed to add new element to the end of array: $error');
  });
}
 */
class _NotifpageState extends State<Notifpage> {
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
              MyWidget(
                notiflist: notifList,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
