import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esiway/Auth.dart';
import 'package:esiway/widgets/constant.dart';
import 'package:flutter/material.dart';

class Notif extends StatefulWidget {
  final String user_name;
  final String doc;
  final String passengerUid;
  //final String path;

  const Notif({
    required this.user_name,
    required this.doc,
    required this.passengerUid,
    //required this.path
  });

  @override
  State<Notif> createState() => _NotifState();
}

class _NotifState extends State<Notif> {
  bool requestAccepted = false;
  bool requestRefused = false;
  Future<void> addFieldToDocument(String documentPath) async {
    print("id =======  $documentPath");
    print("user uid =======  ${widget.passengerUid}");

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
                          addFieldToDocument(
                              widget.doc); // this notif wont be shown anymore

                          {
                            // une notification sera envoyé au conducteur de type 2

                            /*     final json = {
                                                    "uid": AuthService() 
                                                        .auth
                                                        .currentUser!
                                                        .uid,
                                                    "type": 2,
                                                    "date": DateTime.now(),
                                                    "conducteur": ListeTrip
                                                        .liste[index]
                                                        .conducteur,
                                                    "show": true,
                                                  };

                                                  await docNotif.add(json); */
                          }
                        });
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
                          print("accept");
                          setState(() {
                            requestAccepted = true;
                            addFieldToDocument(
                                widget.doc); // this notif wont be shown anymore
                            // the trip will be written dans la bdd du passager
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








/* import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Notif extends StatelessWidget {
  const Notif({Key? key}) : super(key: key);
  static const bleu = Color(0xff20236C);
  static const blanc = Color(0xffF9F8FF);
  static const vert = Color(0xffAED6DC);
  static const rose = Color(0xffFFA18E);
  final String user_name = 'Yasmine Zaidi';
  final String path = "Assets/Images/slider1.png";
  final String accept = 'Accept';
  final String request = 'requested to go with youuuu';
  final String refuse = 'Refuse';
  final String refused = '';
  final String acceptes = '';
  final String more = 'See more';
  final String search = 'Search';

  @override
  Widget build(BuildContext context) {
    var largeur = MediaQuery.of(context).size.width;
    var hauteur = MediaQuery.of(context).size.height;
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        // Container(
        //     child: Text(
        //       'Notifcations',
        //       style: TextStyle(
        //           fontSize: 24,
        //           fontWeight: FontWeight.bold,
        //           color: bleu,
        //           fontFamily: 'mont'),
        //     ),
        //     margin: EdgeInsets.fromLTRB(23, 85, 0, 0)),
        // Container(
        //   child: Text(
        //     'Today',
        //     style: TextStyle(
        //         fontSize: 20,
        //         fontWeight: FontWeight.bold,
        //         color: bleu,
        //         fontFamily: 'mont'),
        //   ),
        //   padding: EdgeInsets.fromLTRB(23, 12, 0, 0),
        // ),
        Container(
          width: largeur * 0.925,
          height: hauteur * 0.0975,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: bleu.withOpacity(0.15),
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
                  backgroundImage: AssetImage(path),
                  radius: largeur * 0.06,
                )),
            Container(
              margin: EdgeInsets.fromLTRB(0, 12, 0, 12),
              constraints: const BoxConstraints(
                maxWidth: 100,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user_name,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: bleu,
                        fontFamily: 'Montserrat'),
                  ),
                  Text(
                    request,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: bleu.withOpacity(0.8),
                      fontFamily: 'Montserrat',
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        refuse,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: bleu,
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
                        onPressed: () {},
                        child: Text(
                          accept,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: bleu,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: rose, // Background color
                          minimumSize: Size(66, 28),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ]),
        ),
      ],
    )
        ////add here an element for list view
        );
  }
}
 */