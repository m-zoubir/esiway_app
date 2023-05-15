import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esiway/Auth.dart';
import 'package:esiway/Screens/Chat/ChatServices.dart';
import 'package:esiway/Screens/Home/liste.dart';
import 'package:esiway/widgets/icons_ESIWay.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:esiway/widgets/prefixe_icon_button.dart';
import 'package:esiway/widgets/simple_button.dart';
import 'package:esiway/widgets/trip_resume.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import '../../../widgets/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'home_page.dart';
import 'tripUser.dart';
import 'variables.dart';

class TripSuggestPage extends StatefulWidget {
  Set<Marker> markers = Set(); //markers for google map
  GoogleMapController? mapController; //controller for Google map
  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {}; //polylines to show direction
  double distance = 0.0;

  TripSuggestPage({
    super.key,
    required this.markers,
    required this.mapController,
    required this.polylinePoints,
    required this.polylines,
    required this.distance,
  });

  @override
  State<TripSuggestPage> createState() => _TripSuggestPageState();
}

class _TripSuggestPageState extends State<TripSuggestPage> {
  var trips;

  int i = 2;

  void initState() {
    // TODO: implement initState
    print("in find Trip notre liste equal = ");
    // print(ListeTrip.liste[0].name);
    print('lenth = ${ListeTrip.liste.length}');
    print('in findtrip mor lprint de notre liste');
    Variables.locationName = "Search places";
    Variables.locationNamea = "Search places";
    Variables.debut = const PointLatLng(36.72376684085901, 2.991892973393687);
    Variables.fin = const PointLatLng(36.72376684085901, 2.991892973393687);
    Variables.created = false;
    List<TripUser> users = [];
    /*   users.add(user1);
    users.add(user2); */

    super.initState();
  }

//======================================================================================================//
//=========================================| Variables |================================================//
//======================================================================================================//

  /// +Firebase (pour stocker dans firebase on choisit la collection Trips)
  final docTrips = FirebaseFirestore.instance.collection("Trips");
  // pour stocker les notifications
  final docNotif = FirebaseFirestore.instance.collection("Notifications");

  final auth = FirebaseAuth.instance; // pour l'utilisateur
  DocumentReference DocRef =
      FirebaseFirestore.instance.collection("Trips").doc("Prefrences");

  /// +Map variables
  Set<Marker> markers = Set(); //markers for google map
  GoogleMapController? mapController; //controller for Google map
  PolylinePoints polylinePoints = PolylinePoints();
  PointLatLng debut = const PointLatLng(36.72376684085901, 2.991892973393687);
  PointLatLng fin = const PointLatLng(36.64364699576445, 2.9943386163692787);
  Map<PolylineId, Polyline> polylines = {}; //polylines to show direction
  double distance = 0.0;
  static LatLng startLocation =
      const LatLng(36.705219106281575, 3.173786850126649);
  LatLng? location;
  String? locationName;
  String? locationNamea;
  List<Placemark>? placemarks;

  List<TripUser> users = [];

  final List<LatLng> _markers = [
    const LatLng(37.42796133580664, -122.085749655962),
    const LatLng(37.42496133180663, -122.081740655962),
    const LatLng(37.42996133180662, -122.082740655962),
  ];
  int _selectedIndex = 0;

//======================================================================================================//
//=========================================| Functions |================================================//
//======================================================================================================//

  ///=============================| Map Functions|===================================//

  ///+++++++++++++++++++++++++++++< ajouter Markers >+++++++++++++++++++++++++++///
  ajouterMarkers(PointLatLng point, String title, String snippet) async {
    widget.markers.add(Marker(
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

  ///-----------------------------< get Direction (draw polyline between two point and put markers) >---------------------------///
  getDirection(PointLatLng depart, PointLatLng arrival) async {
    Variables.polylineCoordinates.clear();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      APIKEY,
      depart,
      arrival,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) async {
        Variables.polylineCoordinates
            .add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    print("Varibales polyline ${Variables.polylineCoordinates}");

    //polulineCoordinates is the List of longitute and latidtude.
    double totalDistance = 0;
    for (var i = 0; i < Variables.polylineCoordinates.length - 1; i++) {
      totalDistance += calculateDistance(
          Variables.polylineCoordinates[i].latitude,
          Variables.polylineCoordinates[i].longitude,
          Variables.polylineCoordinates[i + 1].latitude,
          Variables.polylineCoordinates[i + 1].longitude);
    }

    for (var i = 0; i < Variables.polylineCoordinates.length - 1; i++) {
      print("points : ${i} = ${Variables.polylineCoordinates[i]}");
    }
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

  Future<void> currentLocation(PointLatLng point) async {
    Position positione = await determinePosition();
    point = PointLatLng(positione.latitude, positione.longitude);
  }

/*   final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> readDocument(String documentId) async {
    try {
      DocumentSnapshot snapshot =
          await firestore.collection('Trips').doc(documentId).get();

      if (snapshot.exists) {
        return snapshot.data() as Map<String, dynamic>?;
      } else {
        return null;
      }
    } catch (e) {
      print('Error reading document: $e');
      return null;
    }
  } */
  void toHome() {
    setState(() {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    var largeur = MediaQuery.of(context).size.width;
    var hauteur = MediaQuery.of(context).size.height;
    /*   users.add(user1);
    users.add(user2); */
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            //Map widget from google_maps_flutter package
            zoomGesturesEnabled: true, //enable Zoom in, out on map
            initialCameraPosition: CameraPosition(
              //innital position in map
              target: startLocation, //initial position
              zoom: 12.0, //initial zoom level
            ),

            markers: widget.markers, //markers to show on map
            polylines: Set<Polyline>.of(polylines.values), //polylines
            mapType: MapType.normal, //map type
            onMapCreated: (controller) {
              //method called when map is created
              setState(() {
                mapController = controller;
              });
            },
          ),
          Positioned(
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                  ),
                  color: Color(0xFFF9F8FF)),
              width: largeur,
              height: hauteur * 0.8,
              child: SingleChildScrollView(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: hauteur * 0.02),

                        /// Hello
                        SizedBox(
                          width: largeur * 0.17,
                          child: const AutoSizeText(
                            "Hello",
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w700,
                              fontSize: 22,
                              color: bleu_bg,
                            ),
                            maxLines: 1,
                          ),
                        ),

                        ///We found drivers for your request"
                        SizedBox(
                          width: largeur * 0.71,
                          child: const AutoSizeText(
                            "We found drivers for your request", //nombre de drivers mazal
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: bleu_bg,
                            ),
                            maxLines: 1,
                          ),
                        ),
                        SizedBox(
                          height: hauteur * 0.02,
                        ),

                        ///Sugestion trips box
                        SizedBox(
                          width: largeur * 0.9,
                          height: hauteur * 0.7,
                          child: PageView.builder(
                            itemCount: ListeTrip
                                .liste.length, //ListeTrip.liste.length,
                            onPageChanged: (int index) {
                              setState(() {
                                _selectedIndex = index;
                                widget.markers.clear();
                                mapController?.animateCamera(
                                    CameraUpdate.newCameraPosition(
                                        CameraPosition(
                                            target: LatLng(
                                                ListeTrip.liste[index]
                                                    .departLatLng!.latitude,
                                                ListeTrip.liste[index]
                                                    .departLatLng!.longitude),
                                            zoom: 12)));
                                ajouterMarkers(
                                    ListeTrip.liste[index].departLatLng!,
                                    "Departure",
                                    ListeTrip.liste[index].depart!);

                                /*   ajouterMarkers(users[index].arriveeLatLng!,
                                    "Arrival", "${users[index].arrivee}"); */
                                /* getDirection(users[index].departLatLng!,
                                    users[index].arriveeLatLng!); */
                              });
                            },
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: const Color(0x30AED6DC),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      /// pdp name statut row
                                      Row(
                                        children: [
                                          const CircleAvatar(
                                            backgroundImage: AssetImage(
                                                "Assets/Images/logo_background.png"),
                                            radius: 40,
                                          ),
                                          const SizedBox(width: 8),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: largeur * 0.30,
                                                child: AutoSizeText(
                                                  "${ListeTrip.liste[index].familyName} ${ListeTrip.liste[index].name}",
                                                  style: const TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 14,
                                                    color: bleu_bg,
                                                  ),
                                                  maxLines: 1,
                                                ),
                                              ),
                                              SizedBox(
                                                width: largeur * 0.14,
                                                child: AutoSizeText(
                                                  "${ListeTrip.liste[index].statu}",
                                                  style: const TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12,
                                                    color: bleu_bg,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(width: largeur * 0.15),
                                          RatingBarIndicator(
                                            rating:
                                                ListeTrip.liste[index].prcnt!,
                                            itemCount: 5,
                                            itemSize: 12.0,
                                            unratedColor:
                                                orange.withOpacity(0.25),
                                            itemBuilder: (context, _) =>
                                                SvgPicture.asset(
                                              'Assets/Icons/starFilled.svg',
                                              width: 8,
                                              height: 8,
                                            ),
                                          )
                                        ],
                                      ),

                                      ///BOX TRIP
                                      SizedBox(
                                        width: double
                                            .infinity, // Provide width constraints

                                        child: Row(
                                          children: [
                                            SizedBox(width: largeur * 0.2),
                                            Expanded(
                                              child: InfoTripBox(
                                                arrival:
                                                    '${ListeTrip.liste[0].arrivee}',
                                                departure:
                                                    '${ListeTrip.liste[0].depart}',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: hauteur * 0.03),

                                      /// Row DATE TIME SEATS CAR
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width: largeur * 0.25,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const AutoSizeText(
                                                  "Date",
                                                  style: TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12,
                                                    color: bleu_bg,
                                                  ),
                                                ),
                                                AutoSizeText(
                                                  '${ListeTrip.liste[index].date}', // users[index].date!,
                                                  style: const TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 10,
                                                    color: bleu_bg,
                                                  ),
                                                  maxLines: 1,
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: largeur * 0.15,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const AutoSizeText(
                                                  "Time",
                                                  style: TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12,
                                                    color: bleu_bg,
                                                  ),
                                                ),
                                                AutoSizeText(
                                                  '${ListeTrip.liste[index].time}', //      "${users[index].time}",
                                                  style: const TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 10,
                                                    color: bleu_bg,
                                                  ),
                                                  maxLines: 1,
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: largeur * 0.1,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const AutoSizeText(
                                                  "Seats",
                                                  style: TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12,
                                                    color: bleu_bg,
                                                  ),
                                                ),
                                                AutoSizeText(
                                                  '${ListeTrip.liste[index].seats}', //  "${i}/${users[index].seats}",
                                                  style: const TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 10,
                                                    color: bleu_bg,
                                                  ),
                                                  maxLines: 1,
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: largeur * 0.15,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: const [
                                                AutoSizeText(
                                                  "Car",
                                                  style: TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12,
                                                    color: bleu_bg,
                                                  ),
                                                ),
                                                AutoSizeText(
                                                  "Porche",
                                                  style: TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 10,
                                                    color: bleu_bg,
                                                  ),
                                                  maxLines: 1,
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: hauteur * 0.01),

                                      ///Preferences
                                      Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                  width: largeur * 0.21,
                                                  child: const AutoSizeText(
                                                    "Preferences",
                                                    style: TextStyle(
                                                      fontFamily: 'Montserrat',
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 12,
                                                      color: bleu_bg,
                                                    ),
                                                  )),
                                              SizedBox(height: hauteur * 0.005),
                                              AutoSizeText(
                                                "${ListeTrip.liste[index].preferences}",
                                                style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 10,
                                                  color: bleu_bg,
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                      SizedBox(height: hauteur * 0.01),

                                      /// Price
                                      Container(
                                        height: hauteur * 0.03,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(2),
                                          color: const Color(0x77FFA18E),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                SizedBox(width: largeur * 0.03),
                                                const AutoSizeText(
                                                  "Price",
                                                  style: TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 10,
                                                    color: bleu_bg,
                                                  ),
                                                  maxLines: 1,
                                                ),
                                                SizedBox(width: largeur * 0.01),
                                                AutoSizeText(
                                                  '${ListeTrip.liste[0].methode}',
                                                  style: const TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 10,
                                                    color: bleu_bg,
                                                  ),
                                                  maxLines: 1,
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                                width: largeur * 0.14,
                                                child: AutoSizeText(
                                                  '${ListeTrip.liste[0].price} Da',
                                                  style: const TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 10,
                                                    color: bleu_bg,
                                                  ),
                                                  maxLines: 1,
                                                )),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: hauteur * 0.01),

                                      /// Request & message Buttons
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SimpleButton(
                                              backgroundcolor: orange,
                                              size: Size(largeur * 0.67,
                                                  hauteur * 0.07),
                                              radius: 10,
                                              text: "Request",
                                              textcolor: bleu_bg,
                                              fontsize: 16,
                                              fct: () async {
                                                // une notification sera envoyé au conducteur de type 2
                                                if (ListeTrip
                                                    .liste.isNotEmpty) {
                                                  final json = {
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
                                                    "tripUid":
                                                        '${ListeTrip.liste[index].tripUid}',

                                                    //prefrences
                                                  };

                                                  await docNotif.add(json);
                                                }
                                              }),
                                          ElevatedButton(
                                            onPressed: () {
                                              /*    Navigator.push(context,MaterialPageRoute(builder: (context) => Notifpage())); */
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: orange,
                                              elevation: 0.0,
                                              fixedSize: Size(largeur * 0.07,
                                                  hauteur * 0.07),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            child: const Icons_ESIWay(
                                                icon: "add_message",
                                                largeur: 100,
                                                hauteur: 100),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          ///Back Button
          Positioned(
            top: hauteur * 0.05,
            left: largeur * 0.05,
            child: SizedBox(
              height: 35,
              width: 80,
              child: PrefixeIconButton(
                  size: const Size(73, 34),
                  color: Colors.white,
                  radius: 10,
                  text: "Back",
                  textcolor: const Color(0xFF20236C),
                  weight: FontWeight.w600,
                  fontsize: 14,
                  icon: Transform.scale(
                    scale: 0.75,
                    child: const Icons_ESIWay(
                        icon: "arrow_left", largeur: 30, hauteur: 30),
                  ),
                  espaceicontext: 5.0,
                  fct: () {
                    toHome();
                  }),
            ),
          )
        ],
      ),
    );
  }
}
