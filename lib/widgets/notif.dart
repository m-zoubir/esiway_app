import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esiway/Auth.dart';
import 'package:esiway/Screens/Chat/ChatServices.dart';
import 'package:esiway/widgets/constant.dart';
import 'package:flutter/material.dart';

class Notif extends StatefulWidget {
  final String user_name;
  final String doc;
  final String passengerUid;
  final String tripUid;
  //final String path;

  const Notif({
    required this.user_name, //
    required this.doc, // uid du document dans la collection Notifications
    required this.passengerUid, // le uid du passager
    required this.tripUid, // le uid du document de la collection Trips
    //required this.path
  });

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
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Container(
          width: largeur * 0.925,
          height: hauteur * 0.0975,
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
          margin: EdgeInsets.fromLTRB(12, 14, 12, 20),
          child: Row(children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(13, 16, 5, 16),
              child: CircleAvatar(
                //backgroundImage: AssetImage(path),
                radius: largeur * 0.06,
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 12, 0, 12),
              constraints: const BoxConstraints(
                maxWidth: 200,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.user_name,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: bleu_bg,
                      fontFamily: 'Montserrat',
                    ),
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
                  ),
                ],
              ),
            ),
            if (!requestAccepted && !requestRefused)
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
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
                      },
                      child: Text(
                        "Refuse",
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: bleu_bg,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: vert.withOpacity(0.19),
                        minimumSize: Size(largeur * 0.1833,
                            hauteur * 0.035), // Set width and height here
                        // Background color
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(4, 0, 12, 0),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            requestAccepted = true;
                            _handleAcceptButton();

                            addFieldToDocument(
                                widget.doc); // this notif wont be shown anymore
                            // the trip will be written dans la bdd du passager

                            DocumentReference docRefUser = firestore
                                .collection('Users')
                                .doc('${widget.passengerUid}');

                            // Update the array field with the new element
                            docRefUser.update({
                              'Trip':
                                  FieldValue.arrayUnion(['${widget.tripUid}']),
                            }).then((value) {
                              print('Element added successfully!');
                            }).catchError((error) {
                              print('Failed to add element: $error');
                            });
                          });
                        },
                        child: Text(
                          "Accept",
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: bleu_bg,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: orange, // Background color
                          minimumSize: Size(66, 28),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ]),
        ),
      ],
    )
        ////add here an element for list view
        );
  }
}
