import 'dart:async';
import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esiway/widgets/alertdialog.dart';
import 'package:esiway/widgets/our_prefixeIconButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_webservice/places.dart';
import '../../../widgets/icons_ESIWay.dart';
import '../../../widgets/login_text.dart';
import '../../../widgets/login_text_field.dart';
import '../../../widgets/prefixe_icon_button.dart';
import '../../../widgets/simple_button.dart';
import '../../../widgets/constant.dart';

import '../../widgets/bottom_navbar.dart';
import '../../widgets/our_text_field.dart';
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
  String? date;
  void initState() {
    // TODO: implement initState
    // date = "${selectedDate.day} - ${selectedDate.month} - ${selectedDate.year}";
    if (Variables.created == true) {
      if ((Variables.locationName != "Search places") &&
          (Variables.locationNamea != "Search places")) {
        getDirection(Variables.debut, Variables.fin);
        ajouterMarkers(Variables.debut);
        ajouterMarkers(Variables.fin);
        distance = Variables.distance;
        mapController?.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(
                target: LatLng(debut.latitude, debut.longitude), zoom: 17)));
      } else {
        markers.clear();
      }
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

  static String googleAPiKey = "AIzaSyDHViWe1GaVUfN-w6tcCbdGFsPuHSiNwfw";

  static Set<Marker> markers = Set(); //markers for google map

  Map<PolylineId, Polyline> polylines = {}; //polylines to show direction

  static LatLng startLocation =
      const LatLng(36.705219106281575, 3.173786850126649);

  LatLng endLocation = const LatLng(36.687677024859354, 2.9965016961469324);

  double distance = 0.0;

  String methode = "";

  LatLng? location;

  String? locationName;

  String? locationNamea;

  LatLng LocationEsi = const LatLng(36.705219106281575, 3.173786850126649);

  String paimentMethode = "";

  DateTime selectedDate = DateTime.now();

  static bool bags = false;
  static bool talking = false;
  static bool animals = false;
  static bool smoking = false;
  static bool others = false;

//======================================================================================================//
//=========================================| Functions |================================================//
//======================================================================================================//

  ///=============================| Map Functions|===================================//

  ///++++++++++++++++++++++++< get Direction(draw polylines) >++++++++++++++++++///
  PointLatLng debut = Variables.debut;
  PointLatLng fin = Variables.fin;

  ///+++++++++++++++++++++++++++++< ajouter Markers >+++++++++++++++++++++++++++///

  ajouterMarkers(PointLatLng point) async {
    markers.add(Marker(
      //add start location marker
      markerId: MarkerId(LatLng(point.latitude, point.longitude).toString()),
      position: LatLng(point.latitude, point.longitude), //position of marker
      infoWindow: const InfoWindow(
        //popup info
        title: 'Starting Point ',
        snippet: 'Staaaaaaaaaaaaaaaaaaaart Marker',
      ),
      icon: BitmapDescriptor.defaultMarker, //Icon for Marker
    ));
  }

  ///-----------------------------< get Direction 2 >---------------------------///

  getDirection(PointLatLng depart, PointLatLng arrival) async {
    List<LatLng> polylineCoordinates = [];
    List<String> cities = [];
    markers.clear();

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

    /*for (LatLng coordinate in polylineCoordinates) {
      List<Placemark> placemarks = await placemarkFromCoordinates(coordinate.latitude, coordinate.longitude);
      if (placemarks.isNotEmpty) {
        String? locality = placemarks![0].locality;
        print(locality);
      }
    }*/

    double totalDistance = 0;
    for (var i = 0; i < polylineCoordinates.length - 1; i++) {
      totalDistance += calculateDistance(
          polylineCoordinates[i].latitude,
          polylineCoordinates[i].longitude,
          polylineCoordinates[i + 1].latitude,
          polylineCoordinates[i + 1].longitude);
    }

    /* for (var i = 0; i < polylineCoordinates.length - 1; i++) {
      print("points : ${i} = ${polylineCoordinates[i]}");
    }*/

    setState(() {
      Variables.distance = totalDistance;
    });
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

  ///+++++++++++++++++++++++< Position actuel >+++++++++++++++++++++++++++++++++///

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error("location services are disabled");
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error("location permission denied");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error("Location permission are permently denied");
    }
    Position position = await Geolocator.getCurrentPosition();

    return position;
  }

  /// test

//==============================| Controllers |=============================//
  TextEditingController arrivalcontroller = TextEditingController();

  TextEditingController heurecontroller = TextEditingController();

  TextEditingController datecontroller = TextEditingController();

  TextEditingController departcontroller = TextEditingController();

  TextEditingController controller = TextEditingController();

  TextEditingController pricecontroller = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
        ),
        lastDate: DateTime(2101));
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        date =
            "${selectedDate.day} - ${selectedDate.month} - ${selectedDate.year}";
      });
    }
  }

  void next(PointLatLng one, PointLatLng two) {
    getDirection(one, two); //fetch direction polylines from Google API
    mapController?.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(one.latitude, one.longitude), zoom: 17)));
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
                  : startLocation, //initial position
              zoom: 10.0, //initial zoom level
            ),
            markers: markers, //markers to show on map
            polylines: Set<Polyline>.of(polylines.values), //polylines
            mapType: MapType.normal, //map type
            onMapCreated: (controller) {
              //method called when map is created
              setState(() {
                mapController = controller;
              });
            },
          ),

          ///Total Distance
          Positioned(
            bottom: 25,
            left: 10,
            child: Container(
                decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                          blurRadius: 18,
                          color: Color.fromRGBO(32, 35, 108, 0.15),
                          spreadRadius: 10)
                    ],
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.all(20),
                child: Text(
                  "Total Distance: ${distance.toStringAsFixed(2)} KM",
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF20236C),
                    fontSize: 18,
                  ),
                )),
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
                                              distance: distance,
                                            )));
                              }),

                          ///Notification Button
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NotifPage()));
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
                                distance: distance,
                              )));
                } else {
                  //********************************************************************* */
                  // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  //     backgroundColor: Colors.white,
                  //     duration: Duration(
                  //       seconds: 3,
                  //     ),
                  //     margin:
                  //         EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                  //     padding: EdgeInsets.all(12),
                  //     behavior: SnackBarBehavior.floating,
                  //     elevation: 2,
                  //     content: Center(
                  //       child: Text(
                  //         "You must have a car!",
                  //         style: TextStyle(
                  //           color: Colors.red,
                  //           fontSize: 12,
                  //           fontFamily: "Montserrat",
                  //         ),
                  //       ),
                  //     )));

                  //********************************************************************* */

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

                /* showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text(
                          'You must have a car!',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: bleu_bg,
                          ),
                        ),
                        content: const Text(
                          'Do you want to add a car?',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: bleu_bg,
                          ),
                        ),
                        backgroundColor:
                            const Color.fromARGB(0xFF, 0xB0, 0xD3, 0xD7),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('No',
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: bleu_bg,
                                )),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                // hasCar = true;
                              });
                              Navigator.pop(context);
                            },
                            child: const Text('Add Car',
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: bleu_bg,
                                )),
                          ),
                        ],
                      );
                    });*/
              }, // createTrip,

              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
                backgroundColor: const Color(0xffFFA18E),
                elevation: 0.0,
                fixedSize: Size(largeur * 0.183, largeur * 0.183),
              ),
              child: const Icons_ESIWay(
                  icon: "add_trip", largeur: 100, hauteur: 100),
            ),
          ),
        ],
      ),
    );
  }
}