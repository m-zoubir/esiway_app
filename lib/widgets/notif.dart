import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esiway/Screens/Chat/ChatServices.dart';
import 'package:esiway/widgets/constant.dart';
import 'package:esiway/widgets/simple_button.dart';
import 'package:flutter/material.dart';

import '../Auth.dart';

class Notif extends StatefulWidget {
  final String user_name;
  final String doc;
  final String passengerUid;
  final String tripUid;
  final String? path;

  Notif(
      {required this.user_name,
      required this.doc, // uid du document dans la collection Notifications
      required this.passengerUid, // le uid du passager
      required this.tripUid, // le uid du document de la collection Trips
      required this.path});

  @override
  State<Notif> createState() => _NotifState();
}

class _NotifState extends State<Notif> {
  bool requestAccepted = false;
  bool requestRefused = false;
  void _handleRefuseButton() async {
    // une notification sera envoyé au passager de type 1
    final json = {
      "uid": widget.passengerUid,
      "type": 1,
      "date": DateTime.now(),
      "show": true,
      "conducteur": "${AuthService().auth.currentUser!.uid}",
    };

    await FirebaseFirestore.instance.collection("Notifications").add(json);
  }

  void _handleAcceptButton() async {
    // une notification sera envoyé au passager de type 1
    final json = {
      "uid": widget.passengerUid,
      "type": 0,
      "date": DateTime.now(),
      "show": true,
      "conducteur": "${AuthService().auth.currentUser!.uid}",
    };

    await FirebaseFirestore.instance.collection("Notifications").add(json);
  }

  Future<void> addFieldToDocument(String documentPath) async {
    print("id =======  $documentPath");

    try {
      // Get a reference to the document
      DocumentReference documentRef = FirebaseFirestore.instance
          .collection('Notifications')
          .doc(documentPath);

      // Update the document with the new field
      await documentRef.update({'show': false});
    } catch (e) {
      print('Error adding field to document: $e');
      // Handle any errors that occur
    }
  }

  @override
  Widget build(BuildContext context) {
    var largeur = MediaQuery.of(context).size.width;
    var hauteur = MediaQuery.of(context).size.height;
    return Container(
      height: 82,
      margin: EdgeInsets.only(bottom: 14, left: 5, right: 5, top: 5),
      padding: EdgeInsets.only(bottom: 5, left: 10, right: 10, top: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: bleu_bg.withOpacity(0.15),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Row(children: <Widget>[
        Container(
          height: 55,
          width: 55,
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.white),
              shape: BoxShape.circle,
              image: widget.path == null
                  ? DecorationImage(
                      image: AssetImage("Assets/Images/photo_profile.png"),
                      fit: BoxFit.cover,
                    )
                  : DecorationImage(
                      image: NetworkImage(widget.path!),
                      fit: BoxFit.cover,
                    )),
        ),
        SizedBox(
          width: 10,
        ),
        Container(
          width: largeur * 0.25,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.user_name,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: bleu_bg,
                  fontFamily: 'Montserrat',
                ),
                overflow: TextOverflow.fade,
              ),
              Text(
                requestRefused
                    ? 'Request refused'
                    : (requestAccepted
                        ? 'Request accepted'
                        : 'Requested to go with you'),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: bleu_bg.withOpacity(0.8),
                  fontFamily: 'Montserrat',
                ),
                overflow: TextOverflow.fade,
              ),
            ],
          ),
        ),
        if (!requestAccepted)
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                    color: bleu_bg.withOpacity(0.2),
                  ),
                ]),
            width: 77,
            height: 30,
            child: SimpleButton(
                backgroundcolor: vert.withOpacity(0.3),
                size: Size(75, 30),
                radius: 5,
                text: "Accept",
                textcolor: bleu_bg,
                fontsize: 10,
                fct: () async {
                  setState(() {
                    requestAccepted = true;
                    _handleAcceptButton();

                    addFieldToDocument(
                        widget.doc); // this notif wont be shown anymore
                    // the trip will be written dans la bdd du passager

                    FirebaseFirestore.instance
                        .collection('Users')
                        .doc('${widget.passengerUid}')
                        .update({
                      'Trip': FieldValue.arrayUnion(['${widget.tripUid}']),
                    }).then((value) {
                      print('Element added successfully!');
                    }).catchError((error) {
                      print('Failed to add element: $error');
                    });
                  });
                  Map data = {};
                  // add passsenger to the chat
                  joinChatRoomFirestore(widget.tripUid, widget.passengerUid);
                  // fech user data
                  FirebaseFirestore.instance
                      .collection('Users')
                      .doc(widget.passengerUid)
                      .get()
                      .then((DocumentSnapshot<Map<String, dynamic>> snapshot) {
                    if (snapshot.exists) {
                      data["Name"] = snapshot.data()!['Name'];
                      data["FamilyName"] = snapshot.data()!['FamilyName'];

                      data["ProfilePicture"] =
                          snapshot.data()!.containsKey('ProfilePicture')
                              ? snapshot.data()!["ProfilePicture"]
                              : null;
                    } else {
                      print('Document does not exist!');
                    }
                  }).catchError((error) {
                    print('Error getting document: $error');
                  });
                  // add the passenger info to Passengerarray
                  FirebaseFirestore.instance
                      .collection('Trips')
                      .doc('${widget.tripUid}')
                      .update({
                    'Passenger': FieldValue.arrayUnion([data]),
                  }).then((value) {
                    print('Element added successfully!');
                  }).catchError((error) {
                    print('Failed to add element: $error');
                  });
                }),
          ),
        SizedBox(
          width: 5,
        ),
        if (!requestRefused)
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                    color: bleu_bg.withOpacity(0.2),
                  ),
                ]),
            width: 75,
            height: 30,
            child: SimpleButton(
                backgroundcolor: orange,
                size: Size(75, 30),
                radius: 5,
                text: "Refuse",
                textcolor: bleu_bg,
                fontsize: 12,
                fct: () {
                  setState(() {
                    requestRefused = true;
                    _handleRefuseButton();

                    addFieldToDocument(widget.doc);
                  });
                  /*    // une notification sera envoyé au passager de type 1
                        final json = {
                          "uid": widget.passengerUid,
                          "type": 1,
                          "date": DateTime.now(),
                          "show": true,
                          "conducteur":
                              "${AuthService().auth.currentUser!.uid}",
                        };
                        await FirebaseFirestore.instance
                            .collection("Notifications")
                            .add(json);
                        setState(() async {
                          requestRefused = true;
                          addFieldToDocument(
                              widget.doc); // this notif wont be shown anymore
                        }); */
                }),
          ),
      ]),
    );
  }
}
