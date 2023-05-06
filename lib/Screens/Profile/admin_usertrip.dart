import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../widgets/constant.dart';
import '../../widgets/icons_ESIWay.dart';
import '../../widgets/trip_resume.dart';

class UserTrips extends StatefulWidget {
  const UserTrips({super.key});

  @override
  State<UserTrips> createState() => _UserTripsState();
}

class _UserTripsState extends State<UserTrips> {
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
              Navigator.of(context).pop();
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
        body: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('Users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .get(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            late Map data;
            List trips = [];
            if (snapshot.hasError) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasData) {
              DocumentSnapshot documentSnapshot = snapshot.data;
              data = documentSnapshot.data() as Map;
              if (data != null && data["Trip"] != null) {
                trips = data['Trip'];
                return ListView.builder(
                    itemCount: trips.length,
                    itemBuilder: (context, index) {
                      return FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection("Trips")
                              .doc(trips[index])
                              .get(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot1) {
                            if (snapshot1.hasError) {
                              print(snapshot1.error);
                              return Center(child: CircularProgressIndicator());
                            }

                            if (snapshot1.hasData) {
                              DocumentSnapshot documentSnapshot =
                                  snapshot1.data;
                              try {
                                if (documentSnapshot.data() != null)
                                  data = documentSnapshot.data() as Map;

                                late Map data2;
                                return FutureBuilder<DocumentSnapshot>(
                                    future: FirebaseFirestore.instance
                                        .collection("Users")
                                        .doc(data["Conducteur"])
                                        .get(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot snapshot2) {
                                      if (snapshot2.hasError) {
                                        print(snapshot2.error);
                                        return Center(
                                            child: CircularProgressIndicator());
                                      }

                                      if (snapshot2.hasData) {
                                        DocumentSnapshot documentSnapshot2 =
                                            snapshot2.data;

                                        try {
                                          if (documentSnapshot2.data() != null)
                                            data2 =
                                                documentSnapshot2.data() as Map;
                                          return GestureDetector(
                                              child: TripInfoResume(
                                                familyName:
                                                    documentSnapshot2.data() ==
                                                            null
                                                        ? "Null"
                                                        : data2["FamilyName"],
                                                arrival: data["Arrivee"],
                                                departure:
                                                    data["Arrivee"], //*** */
                                                color: documentSnapshot2
                                                            .data() ==
                                                        null
                                                    ? Colors.red
                                                        .withOpacity(0.6)
                                                    : FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .uid ==
                                                            data["Conducteur"]
                                                        ? orange
                                                            .withOpacity(0.5)
                                                        : bleu_ciel
                                                            .withOpacity(0.4),
                                                date: data["Arrivee"], //** */
                                                name:
                                                    documentSnapshot2.data() ==
                                                            null
                                                        ? "Null"
                                                        : data2["Name"], //** */
                                                price: data["Arrivee"], //** */
                                                time: data["Arrivee"], //** */
                                              ),
                                              onTap: () {});
                                        } catch (e) {
                                          print(e);
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                      } else {
                                        print(snapshot2.error.toString());
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                    });
                              } catch (e) {
                                print(e);
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            } else {
                              print(snapshot1.error.toString());
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          });
                    });
              } else {
                return Center(
                  child: Text(
                    "There is no trips for this user",
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w500),
                  ),
                );
              }
            } else {
              print(snapshot.error.toString());
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }
}
