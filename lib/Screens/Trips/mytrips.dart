import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esiway/Screens/Trips/onGoingtrip.dart';
import 'package:esiway/widgets/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../widgets/Tripswidget/trips.dart';
import '../../widgets/Tripswidget/tripsCards.dart';
import '../../widgets/Tripswidget/tripsTitle.dart';
import '../../widgets/bottom_navbar.dart';
import '../../widgets/icons_ESIWay.dart';
import '../../widgets/prefixe_icon_button.dart';
import '../Home/home_page.dart';

class MyTrips extends StatelessWidget {
  MyTrips({super.key});

  late Map data;

  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData) {
            //Get the data
            DocumentSnapshot documentSnapshot = snapshot.data;
            try {
              data = documentSnapshot.data() as Map;
              //display the data

              return FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('Trips')
                      .where('time',
                          isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime(
                              DateTime.now().year,
                              DateTime.now().month,
                              DateTime.now().day,
                              DateTime.now().hour - 3)))
                      .get(),
                  builder: (context, snapshot1) {
                    if (snapshot1.hasError)
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    if (snapshot1.hasData) {
                      try {
                        List searchResult = snapshot1.data!.docs;
                        Map searchresultfiltred = {};
                        for (var element in searchResult)
                          if (data["Trip"].contains(element.id)) {
                            searchresultfiltred[element.data()] = element.id;
                          }

                        return MyTripsScreen(trips: searchresultfiltred);
                      } catch (e) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => HomePage()));
                      }
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  });
            } catch (e) {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => HomePage()));
            }
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
    ;
  }
}

class MyTripsScreen extends StatefulWidget {
  @override
  MyTripsScreen({super.key, required this.trips});

  Map? trips;
  State<MyTripsScreen> createState() => _MyTripsScreenState();
}

class _MyTripsScreenState extends State<MyTripsScreen> {
  @override
  void back() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => HomePage()));
  }

  List<Trip> reservedTrips = [];
  List<Trip> suggestedtrip = [];
  OngoingTrips trip = OngoingTrips(
      Conducteur: null, uid: null, departure: "departure", arrival: "arrival");
  @override
  void initState() {
    super.initState();
    if (widget.trips != null) {
      widget.trips!.forEach((element, id) {
        if (element["time"].toDate().isBefore(DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day,
                DateTime.now().hour + 3)) &&
            element["time"].toDate().isAfter(DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day,
                DateTime.now().hour - 3))) {
          trip.arrival = element["Arrivee"];
          trip.departure = element['Depart'];
          trip.Conducteur = element["Conducteur"];
          trip.uid = id;
        } else {
          if (element["Conducteur"] ==
              "${FirebaseAuth.instance.currentUser!.uid}")
            suggestedtrip.add(Trip(
              passager:
                  element["Passenger"] == null ? [] : element["Passenger"],
              departure: element["Depart"],
              arrival: element["Arrivee"],
              date: element["Date"],
              price: element["Price"],
              preferences: "          ",
              uid: element["Conducteur"],
            ));
          else
            reservedTrips.add(Trip(
              passager:
                  element["Passenger"] == null ? [] : element["Passenger"],
              uid: element["Conducteur"],
              departure: element["Depart"],
              arrival: element["Arrivee"],
              date: element["Date"],
              price: element["Price"],
              preferences: "    ",
            ));
        }
      });
    }
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final screenWidth = size.width;
    final screenHeight = size.height;
    return Scaffold(
      bottomNavigationBar: BottomNavBar(
        currentindex: 1,
      ),
      backgroundColor: color3,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 20, left: 20),
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
              Container(
                  // width: screenWidth * 0.4,
                  margin: EdgeInsets.only(left: screenWidth * 0.04),
                  child: CustomTitle(title: 'My Trips', titleSize: 40.0)),
              SizedBox(
                height: screenHeight * 0.01,
              ),
              Container(
                  width: screenWidth * 0.3,
                  margin: EdgeInsets.only(left: screenWidth * 0.04),
                  child: CustomTitle(title: 'Ongoing', titleSize: 20.0)),
              SizedBox(
                width: screenWidth * 0.99,
                child: MyTripsCard2(trip: trip),
              ),
              Container(
                width: screenWidth * 0.3,
                margin: EdgeInsets.only(left: screenWidth * 0.04),
                child: CustomTitle(
                  title: 'Reserved',
                  titleSize: 20.0,
                ),
              ),
              MyTripsCard(
                trips: reservedTrips,
                reserved: true,
              ),
              Container(
                width: screenWidth * 0.3,
                margin: EdgeInsets.only(left: screenWidth * 0.04),
                child: CustomTitle(
                  title: 'Proposed',
                  titleSize: 20.0,
                ),
              ),
              MyTripsCard(
                trips: suggestedtrip,
                reserved: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
