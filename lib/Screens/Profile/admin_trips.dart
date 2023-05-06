import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esiway/Screens/Profile/admin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../widgets/constant.dart';
import '../../widgets/icons_ESIWay.dart';
import '../../widgets/trip_resume.dart';

class AdminTrips extends StatefulWidget {
  const AdminTrips({super.key});

  @override
  State<AdminTrips> createState() => _AdminTripsState();
}

class _AdminTripsState extends State<AdminTrips> {
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
                  return AdminScreen();
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
      body: FutureBuilder(
          future: FirebaseFirestore.instance.collection("Trips").get(), //  ***
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            if (snapshot.hasData) {
              late Map data;
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection("Users")
                            .doc(
                                snapshot.data?.docs[index].data()["Conducteur"])
                            .get(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot1) {
                          if (snapshot1.hasError) {
                            print(snapshot1.error);
                            return Center(child: CircularProgressIndicator());
                          }

                          if (snapshot1.hasData) {
                            DocumentSnapshot documentSnapshot = snapshot1.data;
                            try {
                              if (documentSnapshot.data() != null)
                                data = documentSnapshot.data() as Map;
                              return GestureDetector(
                                  child: TripInfoResume(
                                    familyName: documentSnapshot.data() == null
                                        ? "Null"
                                        : data["FamilyName"],
                                    arrival: snapshot.data?.docs[index]
                                        .data()["Arrivee"],
                                    departure: snapshot.data?.docs[index]
                                        .data()["Depart"], //*** */
                                    color: documentSnapshot.data() == null
                                        ? Colors.red.withOpacity(0.6)
                                        : FirebaseAuth.instance.currentUser!
                                                    .uid ==
                                                snapshot.data?.docs[index]
                                                    .data()["Conducteur"]
                                            ? orange.withOpacity(0.5)
                                            : bleu_ciel.withOpacity(0.4),
                                    date: snapshot.data?.docs[index]
                                        .data()["Date"], //** */
                                    name: documentSnapshot.data() == null
                                        ? "Null"
                                        : data["Name"], //** */
                                    price: snapshot.data?.docs[index]
                                        .data()["Price"], //** */
                                    time: snapshot.data?.docs[index]
                                        .data()["Heure"], //** */
                                  ),
                                  onTap: () {});
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
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
