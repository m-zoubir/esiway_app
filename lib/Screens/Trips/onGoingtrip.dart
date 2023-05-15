import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esiway/Screens/Chat/Chatting.dart';
import 'package:esiway/Screens/Trips/rating.dart';
import 'package:esiway/Screens/Profile/user_car_info.dart';
import 'package:esiway/widgets/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../widgets/Tripswidget/infoTrip.dart';
import '../../widgets/Tripswidget/onGoingBox.dart';
import '../../widgets/Tripswidget/profileTripCard.dart';
import '../../widgets/icons_ESIWay.dart';
import '../../widgets/simple_button.dart';

class OngoingTrip extends StatelessWidget {
  OngoingTrip({Key? key, required this.uid, required this.Conducteur})
      : super(key: key);
  String Conducteur;
  String uid;
  List<LatLng> coordonates = [];
  List coordonatesString = [];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final screenWidth = size.width;
    final screenHeight = size.height;
    return FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection("Users")
            .doc(Conducteur)
            .get(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
          }
          if (snapshot.hasData) {
            DocumentSnapshot documentSnapshot = snapshot.data!;
            try {
              Map data = documentSnapshot.data() as Map;
              return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection("Trips")
                      .doc(uid)
                      .get(),
                  builder: (BuildContext context, AsyncSnapshot snapshot1) {
                    if (snapshot1.hasError) print(snapshot1.error);
                    if (snapshot1.hasData) {
                      try {
                        DocumentSnapshot documentSnapshot1 = snapshot1.data!;
                        Map data1 = documentSnapshot1.data() as Map;
                        GeoPoint depart = data1["Depart_LatLng"];
                        GeoPoint arrivee = data1["Arrivee_LatLng"];
                        double lat;
                        double lng;
                        coordonatesString = data1["polyline"];
                        coordonatesString.forEach((element) {
                          lat = double.parse(
                              element.substring(0, element.indexOf(",")));
                          lng = double.parse(
                              element.substring(element.indexOf(",") + 1));
                          print(lat);
                          print(lng);
                          print("----");
                          coordonates.add(LatLng(lat, lng));
                        });

                        return Scaffold(
                          body: SafeArea(
                            child: Stack(
                              children: [
                                GoogleMap(
                                  initialCameraPosition: CameraPosition(
                                    target: LatLng(
                                        depart.latitude, depart.longitude),
                                    zoom: 14.0,
                                  ),
                                  markers: {
                                    Marker(
                                        markerId:
                                            MarkerId("${data1["Depart"]}"),
                                        position: LatLng(
                                            depart.latitude, depart.longitude)),
                                    Marker(
                                        markerId:
                                            MarkerId("${data1["Arrivee"]}"),
                                        position: LatLng(arrivee.latitude,
                                            arrivee.longitude)),
                                  },
                                  polylines: {
                                    Polyline(
                                      polylineId: PolylineId("Route"),
                                      color: bleu_bg.withOpacity(0.9),
                                      points: coordonates,
                                      width: 5,
                                    ),
                                  },
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    OngoingBox(),
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: screenWidth * 0.02,
                                          top: screenHeight * 0.01,
                                          bottom: screenHeight * 0.02,
                                          right: screenWidth * 0.01),
                                      width: screenWidth * 0.89,
                                      height: screenHeight * 0.25,
                                      padding: EdgeInsets.only(
                                          left: screenWidth * 0.03,
                                          top: screenHeight * 0.01,
                                          right: screenWidth * 0.02),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        boxShadow: [
                                          BoxShadow(
                                            offset: Offset(0, 0),
                                            blurRadius: 4,
                                            color: bleu_bg.withOpacity(0.15),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          ProfileTripCard(
                                            name:
                                                "${data["Name"]} ${data["FamilyName"]}",
                                            staff: data["Status"],
                                            rating: data["Rate"],
                                            profileImage: data.containsKey(
                                                    "ProfilePicture")
                                                ? data["ProfilePicture"]
                                                : null,
                                            color: bleu_bg,
                                          ),
                                          SizedBox(
                                            width: screenWidth * 0.2,
                                          ),
                                          InfoTripBox1(
                                            arrival: '${data1["Arrivee"]}',
                                            departure: '${data1["Depart"]}',
                                            price: data1["Price"],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            //crossAxisAlignment: ,
                                            children: [
                                              Expanded(
                                                child: SimpleButton(
                                                    backgroundcolor: orange,
                                                    size: Size(
                                                        screenWidth * 0.68,
                                                        screenHeight * 0.05),
                                                    radius: 8,
                                                    text: 'Car information',
                                                    textcolor: bleu_bg,
                                                    fontsize: 14,
                                                    blur: null,
                                                    fct: () {
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      UserCarInfo(
                                                                        uid:
                                                                            Conducteur,
                                                                      )));
                                                    }),
                                              ),
                                              SizedBox(
                                                width: 3,
                                              ),
                                              Container(
                                                width: screenWidth * 0.11,
                                                height: screenHeight * 0.05,
                                                margin:
                                                    EdgeInsets.only(right: 2),
                                                decoration: BoxDecoration(
                                                  color: orange,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(6)),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      offset: Offset(0, 0),
                                                      blurRadius: 4,
                                                      color: bleu_bg
                                                          .withOpacity(0.15),
                                                    ),
                                                  ],
                                                ),
                                                child: IconButton(
                                                  onPressed: () {
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                Groupe_Chat(
                                                                    chatId: uid,
                                                                    ChatName:
                                                                        '${data1["Depart"]}-${data1["Arrivee"]}')));
                                                  },
                                                  color: orange,
                                                  iconSize: 30,
                                                  // alignment: AlignmentGeometry(),
                                                  icon: Icons_ESIWay(
                                                      icon: 'add_message',
                                                      largeur: 18,
                                                      hauteur: 18),
                                                ),
                                              ),
                                              FirebaseAuth.instance.currentUser!
                                                          .uid ==
                                                      Conducteur
                                                  ? Container()
                                                  : Container(
                                                      width: screenWidth * 0.11,
                                                      height:
                                                          screenHeight * 0.05,
                                                      margin: EdgeInsets.only(
                                                          right: 2),
                                                      decoration: BoxDecoration(
                                                        color: orange,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    6)),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            offset:
                                                                Offset(0, 0),
                                                            blurRadius: 4,
                                                            color: bleu_bg
                                                                .withOpacity(
                                                                    0.15),
                                                          ),
                                                        ],
                                                      ),
                                                      child: IconButton(
                                                        onPressed: () {
                                                          Navigator.of(context).push(
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          Home(
                                                                            uid:
                                                                                Conducteur,
                                                                            name:
                                                                                "${data["Name"]} ${data["FamilyName"]}",
                                                                            rating:
                                                                                data["Rate"],
                                                                            imageUrl: data.containsKey("ProfilePicture")
                                                                                ? data["ProfilePicture"]
                                                                                : null,
                                                                          )));
                                                        },
                                                        color: orange,
                                                        iconSize: 30,
                                                        icon: Icons_ESIWay(
                                                            icon: 'star',
                                                            largeur: 18,
                                                            hauteur: 18),
                                                      ),
                                                    ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      } catch (e) {
                        print(e);
                      }
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  });
            } catch (e) {
              print(e);
            }
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
