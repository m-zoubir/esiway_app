import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esiway/Auth.dart';
import 'package:esiway/widgets/accept_notif.dart';
import 'package:esiway/widgets/notif.dart';
import 'package:esiway/widgets/refuse_notif.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../widgets/bottom_navbar.dart';
import '../../widgets/icons_ESIWay.dart';
import '../../widgets/prefixe_icon_button.dart';
import 'home_page.dart';

class NotifPage extends StatefulWidget {
  NotifPage({Key? key, required this.imageUrl});
  String? imageUrl;
  @override
  State<NotifPage> createState() => _NotifPageState();
}

class _NotifPageState extends State<NotifPage> {
  void back() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    var largeur = MediaQuery.of(context).size.width;
    var hauteur = MediaQuery.of(context).size.height;
    final currentUserUID = AuthService()
        .auth
        .currentUser!
        .uid; // Replace with your logic to get the current user's UID
    return Scaffold(
      backgroundColor: const Color(0xFFF9F8FF),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            children: [
              SizedBox(
                height: hauteur * 0.03,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, right: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      width: 80,
                      height: 35,
                      child: PrefixeIconButton(
                          size: const Size(73, 34),
                          color: Colors.white,
                          radius: 8,
                          text: "Back",
                          textcolor: Color(0xFF20236C),
                          weight: FontWeight.w600,
                          fontsize: 14,
                          icon: Transform.scale(
                            scale: 0.75,
                            child: Icons_ESIWay(
                                icon: "arrow_left", largeur: 30, hauteur: 30),
                          ),
                          espaceicontext: 5.0,
                          fct: back),
                    ),
                    SizedBox(width: largeur * 0.47),
                    Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                          shape: BoxShape.circle,
                          image: widget.imageUrl == null
                              ? DecorationImage(
                                  image: AssetImage(
                                      "Assets/Images/photo_profile.png"),
                                  fit: BoxFit.cover,
                                )
                              : DecorationImage(
                                  image: NetworkImage(widget.imageUrl!),
                                  fit: BoxFit.cover,
                                )),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: hauteur * 0.03,
              ),

              //the Title

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Notifications",
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Color(0xFF20236C),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: hauteur * 0.02,
              ),

              Container(
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                margin: EdgeInsets.only(
                  left: largeur * 0.05,
                  right: largeur * 0.05,
                ),
                height: hauteur * 0.65,
                child: NotifList(),
              ),
            ],
          ),
        ],
      ),
      //just to test how it will look
      bottomNavigationBar: BottomNavBar(currentindex: 0),
    );
  }
}

class NotifList extends StatefulWidget {
  NotifList({
    super.key,
  });

  @override
  State<NotifList> createState() => _NotifListState();
}

class _NotifListState extends State<NotifList> {
  User? currentuser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Notifications')
            .orderBy('date', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            print('Error: ${snapshot.error}');
          }

          if (snapshot.hasData) {
            final List<DocumentSnapshot> documents = snapshot.data!.docs;

            return ListView.builder(
                itemCount: documents.length,
                itemBuilder: (BuildContext context, int index) {
                  final document = documents[index];
                  if ((document['uid'] != currentuser!.uid) ||
                      (document['show'] == false)) {
                    return Container(); // Return an empty widget to skip rendering
                  }
                  return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('Users')
                          .doc(document['conducteur'])
                          .get(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                        if (userSnapshot.hasError) {
                          return Text('Error: ${userSnapshot.error}');
                        }

                        if (userSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Text('Loading...');
                        }

                        DocumentSnapshot userDocument = userSnapshot.data!;
                        Map data = userDocument.data() as Map;

                        print(document.id);
                        return document['type'] ==
                                0 // pour les notification "X person accepted your ride request"
                            ? AcceptB(
                                user_name: data["Name"],
                                path: data.containsKey("ProfilePicture")
                                    ? data["ProfilePicture"]
                                    : null,
                              )
                            : (document['type'] ==
                                    1 // pour les notification "X person refused your ride request"
                                ? RefuseB(
                                    user_name: data["Name"],
                                    path: data.containsKey("ProfilePicture")
                                        ? data["ProfilePicture"]
                                        : null,
                                  )
                                : Notif(
                                    // pour les notification "X person wants to go with you "
                                    user_name: data["Name"],
                                    path: data.containsKey("ProfilePicture")
                                        ? data["ProfilePicture"]
                                        : null,
                                    doc: document.id.toString(),
                                    passengerUid: userDocument.id.toString(),
                                    tripUid: document['tripUid'],
                                  ));
                      });
                });
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
