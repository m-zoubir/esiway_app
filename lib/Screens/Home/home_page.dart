import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esiway/widgets/alertdialog.dart';
import 'package:esiway/widgets/our_prefixeIconButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../widgets/icons_ESIWay.dart';
import '../../../widgets/constant.dart';
import '../../widgets/bottom_navbar.dart';
import '../Profile/car_information_screen.dart';
import 'createTrip_Page.dart';
import 'notif_page.dart';
import 'searchTrip_page.dart';
import 'variables.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  bool? hascar;
  String? imageUrl;
  String? date;
  void initState() {
    // TODO: implement initState

      if ((Variables.locationName != "Search places") &&
          (Variables.locationNamea != "Search places")) {
        markers.clear();

        getDirection(Variables.debut, Variables.fin);

        mapController?.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(
                target: LatLng(Variables.debut.latitude, Variables.debut.longitude), zoom: 17)));
      } else {
        Variables.distance = 0.0;
        markers.clear();
      }


//user information to know if he has a car
    User? currentuser = FirebaseAuth.instance.currentUser!;

    FirebaseFirestore.instance
        .collection('Users')
        .doc(currentuser.uid)
        .get()
        .then((DocumentSnapshot<Map<String, dynamic>> snapshot) {
      if (snapshot.exists) {
        hascar = snapshot.data()!['hasCar'];
        imageUrl = snapshot.data()!.containsKey("ProfilePicture") == true
            ? snapshot.data()!["ProfilePicture"]
            : null;
      } else {
        print('Document does not exist!');
      }
    }).catchError((error) {
      hascar = false;
      print('Error getting document: $error');
    });

    super.initState();
  }
//======================================================================================================//
//=========================================| Variables |================================================//
//======================================================================================================//

  static GoogleMapController? mapController; //controller for Google map

  PolylinePoints polylinePoints = PolylinePoints();


  static Set<Marker> markers = Set(); //markers for google map

  Map<PolylineId, Polyline> polylines = {}; //polylines to show direction


  LatLng endLocation = const LatLng(36.687677024859354, 2.9965016961469324);




  LatLng LocationEsi = const LatLng(36.705219106281575, 3.173786850126649);


  DateTime selectedDate = DateTime.now();


//======================================================================================================//
//=========================================| Functions |================================================//
//======================================================================================================//

  ///=============================| Map Functions|===================================//

  ///++++++++++++++++++++++++< get Direction(draw polylines) >++++++++++++++++++///
  PointLatLng debut = Variables.debut;
  PointLatLng fin = Variables.fin;

  ///+++++++++++++++++++++++++++++< ajouter Markers >+++++++++++++++++++++++++++///


  ajouterMarkers(PointLatLng point, String title, String snippet) async {
    markers.add(Marker(
      //add start location marker
      markerId: MarkerId(LatLng(point.latitude, point.longitude).toString()),
      position: LatLng(point.latitude, point.longitude), //position of marker
      infoWindow: InfoWindow(
        //popup info
        title: title,
        snippet: snippet,
      ),
      icon: BitmapDescriptor.defaultMarker, //Icon for Marker
    ));
  }

  ///-----------------------------< get Direction 2 >---------------------------///

  getDirection(PointLatLng depart, PointLatLng arrival) async {
    List<LatLng> polylineCoordinates = [];
    markers.clear();

     ajouterMarkers(Variables.debut,'Starting Point',Variables.locationName);
     ajouterMarkers(Variables.fin,'Arrival Point',Variables.locationNamea);
    List<String> latLngStrings = polylineCoordinates
        .map((latLng) => '${latLng.latitude},${latLng.longitude}')
        .toList();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      APIKEY,
      depart,
      arrival,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) async {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }

    double totalDistance = 0;
    for (var i = 0; i < polylineCoordinates.length - 1; i++) {
      totalDistance += calculateDistance(
          polylineCoordinates[i].latitude,
          polylineCoordinates[i].longitude,
          polylineCoordinates[i + 1].latitude,
          polylineCoordinates[i + 1].longitude);
    }


    setState(() {
      Variables.distance = totalDistance;
    });
    markers.add(Marker(
      //add start location marker
      markerId: MarkerId(LatLng(Variables.debut.latitude, Variables.debut.latitude).toString()),
      position: LatLng(Variables.debut.latitude, Variables.debut.latitude), //position of marker
      infoWindow: InfoWindow(
        //popup info
        title: "TEST",
        snippet: "TEST",
      ),
      icon: BitmapDescriptor.defaultMarker, //Icon for Marker
    ));

    addPolyLine(Variables.polylineCoordinates);
  }

  ///+++++++++++++++++++++++++++++< Add Polyline >++++++++++++++++++++++++++++++///

  addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.deepPurpleAccent,
      points: polylineCoordinates,
      width: 8,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  ///++++++++++++++++< Calculer la distance entre deux point >++++++++++++++++++///

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }


  @override
  Widget build(BuildContext context) {
    var largeur = MediaQuery.of(context).size.width;
    var hauteur = MediaQuery.of(context).size.height;
    var dropdownValue = "-1"; // drop down value
    return Scaffold(
      bottomNavigationBar: BottomNavBar(currentindex: 0),
      body: Stack(
        children: [
          GoogleMap(
            //Map widget from google_maps_flutter package
            zoomGesturesEnabled: true, //enable Zoom in, out on map
            zoomControlsEnabled: false,
            initialCameraPosition: CameraPosition(
              //innital position in map
              target: Variables.created
                  ? LatLng(Variables.debut.latitude, Variables.debut.longitude)
                  : LocationEsi, //initial position
              zoom: 10.0, //initial zoom level
            ),
            markers: markers, //markers to show on map
            polylines: Set<Polyline>.of(polylines.values), //polylines
            mapType: MapType.normal, //map type
            onMapCreated: (controller) {
              //method called when map is created
              setState(() {mapController = controller;});
            },
          ),

          ///Total Distance
          Positioned(
            bottom: 25,
            left: 10,
            child: Container(
                width: largeur*0.7,
                height: hauteur*0.08,
                decoration:  BoxDecoration(
                    boxShadow: [const BoxShadow(blurRadius: 18, color: Color.fromRGBO(32, 35, 108, 0.15),spreadRadius: 10,),],
                    color: color3,
                    borderRadius: BorderRadius.circular(10)
                ),

                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(3),
                    child: AutoSizeText(
                      "Total Distance: ${Variables.distance.toStringAsFixed(2)} KM",
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF20236C),
                        fontSize: 18,
                      ),
                    ),
                  ),
                )
            ),
          ),
          Column(
            children: [
              Container(
                  height: hauteur * 0.035,
                  width: largeur,
                  color: Colors.transparent), // pour laisser l'espace ctt
              SizedBox(
                width: largeur,
                height: hauteur * 0.5,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    children: [
                      /// Search and notification Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          OurPrefixeIconButton(
                              sizebutton: 2,
                              size: Size(largeur * 0.723, hauteur * 0.0625),
                              color: Colors.white,
                              radius: 10,
                              text: "Search a trip",
                              textcolor: const Color(0xff20236C),
                              weight: FontWeight.w500,
                              fontsize: 12,
                              iconName: "search",
                              espaceicontext: largeur * 0.05,
                              fct: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SearchTripPage(
                                              markers: markers,
                                              mapController: mapController,
                                              polylinePoints: polylinePoints,
                                              polylines: polylines,
                                              distance: Variables.distance,
                                            )));
                              }),

                          ///Notification Button
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NotifPage(
                                            imageUrl: imageUrl,
                                          )));
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                elevation: 0.0,
                                fixedSize:
                                    Size(largeur * 0.13, hauteur * 0.0625)),
                            child: const Icons_ESIWay(
                                icon: "notification_on",
                                largeur: 100,
                                hauteur: 100),
                          ), // child: const Icons_ESIWay(icon: "notification_off", largeur: 100, hauteur: 100),),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          ///Create Trip Button
          Positioned(
            bottom: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () async {
                if (hascar == true) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateTripPage(
                                markers: markers,
                                mapController: mapController,
                                polylinePoints: polylinePoints,
                                polylines: polylines,
                                distance: Variables.distance,
                              )));
                } else {
                  showDialog(
                      context: context,
                      builder: (context) => CustomAlertDialog(
                          greentext: "Add",
                          question:
                              "You must have a car!\nDo you want to add a car?",
                          redtext: "Back",
                          greenfct: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return CarInfo();
                                },
                              ),
                            );
                          },
                          redfct: () {
                            Navigator.pop(context);
                          }));
                  //********************************************************************* */
                }

              }, // createTrip,

              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
                backgroundColor: const Color(0xffFFA18E),
                elevation: 0.0,
                fixedSize: Size(largeur * 0.183, largeur * 0.183),
              ),
              child: const Icons_ESIWay(icon: "add_trip", largeur: 100, hauteur: 100),
            ),
          ),
        ],
      ),
    );
  }
}
