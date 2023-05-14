import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esiway/Screens/Chat/ChatServices.dart';
import 'package:esiway/widgets/prefixe_icon_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import '../../../widgets/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import '../../../widgets/icons_ESIWay.dart';
import '../../../widgets/login_text.dart';
import '../../../widgets/simple_button.dart';
import 'home_page.dart';
import 'variables.dart';

class CreateTripPage extends StatefulWidget {
  Set<Marker> markers = Set(); //markers for google map
  GoogleMapController? mapController; //controller for Google map
  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {}; //polylines to show direction
  double distance = 0.0;

  CreateTripPage({
    super.key,
    required this.markers,
    required this.mapController,
    required this.polylinePoints,
    required this.polylines,
    required this.distance,
  });

  @override
  State<CreateTripPage> createState() => _CreateTripPageState();
}

class _CreateTripPageState extends State<CreateTripPage> {
  List<String> addPolylineCoordinates(List<LatLng> polylineCoordinates) {
    List<String> /*  List<Map<String, dynamic>>  */ serializedCoordinates =
        polylineCoordinates.map((coordinate) {
      return '${coordinate.latitude},${coordinate.longitude}';
      /*  {
          'latitude': coordinate.latitude,
          'longitude': coordinate.longitude
        }; */
    }).toList();

    return serializedCoordinates;
  }

  void initState() {
    // TODO: implement initState

    minute = TimeNow.minute >= 10 ? "${TimeNow.minute}" : "0${TimeNow.minute}";
    hour = TimeNow.hour >= 10 ? "${TimeNow.hour}" : "0${TimeNow.hour}";
    time = hour! + " : " + minute!;

    Variables.locationName = "Search places";
    Variables.locationNamea = "Search places";
    Variables.debut = const PointLatLng(36.72376684085901, 2.991892973393687);
    Variables.fin = const PointLatLng(36.72376684085901, 2.991892973393687);
    Variables.polylineCoordinates = [];
    Variables.created = false;
    super.initState();
  }

//======================================================================================================//
//=========================================| Variables |================================================//
//======================================================================================================//

  /// +Fire base (pour stocker dans firebase on choisit la collection Trips)
  final docTrips = FirebaseFirestore.instance.collection("Trips");
  final docUsers = FirebaseFirestore.instance.collection("Users");
  final auth = FirebaseAuth.instance; // pour l'utilisateur
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String prefrence = "";

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
  LatLng endLocation = const LatLng(36.687677024859354, 2.9965016961469324);
  LatLng? location;
  String? locationName;
  String? locationNamea;
  List<Placemark>? placemarks;

  String paimentMethode = "";
  String methode = "";
  DateTime selectedDate = DateTime.now();
  static bool bags = false;
  static bool talking = false;
  static bool animals = false;
  static bool smoking = false;
  static bool others = false;
  String? seats = "4";
  int i = 0;

  String? date =
      "${DateTime.now().day} - ${DateTime.now().month} - ${DateTime.now().year}";

  String? time = "00:00";
  String? minute;
  String? hour;
  TimeOfDay TimeNow =
      TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);
  TextEditingController pricecontroller = TextEditingController();

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
  getDirection(
      String conducteur,
      PointLatLng one,
      PointLatLng two,
      String depart,
      String arrivee,
      String date,
      String heure,
      String price,
      String places,
      String methode,
      String prefrence) async {
    markers.clear();
    Variables.polylineCoordinates.clear();
    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      APIKEY,
      one,
      two,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) async {
        Variables.polylineCoordinates
            .add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }

    //polulineCoordinates is the List of longitute and latidtude.
    double totalDistance = 0;
    for (var i = 0; i < Variables.polylineCoordinates.length - 1; i++) {
      totalDistance += calculateDistance(
          Variables.polylineCoordinates[i].latitude,
          Variables.polylineCoordinates[i].longitude,
          Variables.polylineCoordinates[i + 1].latitude,
          Variables.polylineCoordinates[i + 1].longitude);
    }

    addPolylineCoordinates(Variables.polylineCoordinates);

    final json = {
      "Conducteur": conducteur,
      "Depart_LatLng": GeoPoint(one.latitude, one.longitude),
      "Arrivee_LatLng": GeoPoint(two.latitude, two.longitude),
      "Depart": depart,
      "Arrivee": arrivee,
      "Date": "$date",
      "Heure": "$heure",
      "Price": price,
      "Places": places,
      "methode": methode,
      "polyline": addPolylineCoordinates(Variables.polylineCoordinates),
      "prefrences": prefrence,
    };

    await docTrips.doc("${auth.currentUser?.uid}_$date-$heure").set(json);
    DocumentReference docRefUser =
        firestore.collection('Users').doc("${auth.currentUser?.uid}");

// Update the array field with the new element
    docRefUser.update({
      'Trip': FieldValue.arrayUnion(['${auth.currentUser?.uid}_$date-$heure']),
    }).then((value) {
      print('Element added successfully!');
    }).catchError((error) {
      print('Failed to add element: $error');
    });

    /// ***************************** Creer CHAT ********************************************
    /// *************************************************************************************
    try {
      String departArrivee =
          await getDepartArriveeString('${auth.currentUser?.uid}_$date-$heure');
      createChatRoomFirestore(
          departArrivee,
          FirebaseAuth.instance.currentUser!.uid,
          '${auth.currentUser?.uid}_$date-$heure');
    } catch (e) {
      print(e.toString());
    }

    /// *****************************************************************************************
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

  ///+++++++++++++++++++++++< Time Picker >+++++++++++++++++++++++++++++++++///
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      initialTime: TimeNow,
      context: context,
    );
    if (picked != null) {
      setState(() {
        TimeNow = picked;
        minute =
            TimeNow.minute >= 10 ? "${TimeNow.minute}" : "0${TimeNow.minute}";
        hour = TimeNow.hour >= 10 ? "${TimeNow.hour}" : "0${TimeNow.hour}";
        time = hour! + " : " + minute!;
      });
    }
  }

  ///+++++++++++++++++++++++< Date Picker >+++++++++++++++++++++++++++++++++///
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

  void toHome() {
    setState(() {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
    });
  }

  Future<void> createTrip(
      String conducteur,
      PointLatLng one,
      PointLatLng two,
      String depart,
      String arrivee,
      String date,
      String heure,
      String price,
      String places,
      String methode,
      prefrence) async {
    if (depart == "Current Location") {
      Position positione = await determinePosition();
      Variables.fin = PointLatLng(positione.latitude, positione.longitude);
    }
    ;

    if (arrivee == "Current Location") {
      Position positione = await determinePosition();
      Variables.debut = PointLatLng(positione.latitude, positione.longitude);
    }
    ;

    setState(() {});
    getDirection(conducteur, one, two, depart, arrivee, date, heure, price,
        places, methode, prefrence); //fetch direction polylines from Google API
    ajouterMarkers(one, "Starting Location", depart);
    ajouterMarkers(two, "Arrival Location", arrivee);
    mapController?.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(one.latitude, one.longitude), zoom: 17)));
  }

  @override
  Widget build(BuildContext context) {
    var largeur = MediaQuery.of(context).size.width;
    var hauteur = MediaQuery.of(context).size.height;
    var dropdownValue = "-1"; // drop down value

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            //Map widget from google_maps_flutter package
            zoomGesturesEnabled: true, //enable Zoom in, out on map
            initialCameraPosition: CameraPosition(
              //innital position in map
              target: startLocation, //initial position
              zoom: 14.0, //initial zoom level
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
            child: SizedBox(
              width: largeur,
              height: hauteur * 0.7125,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(23),
                            topRight: Radius.circular(23),
                          ),
                          color: Color(0xFFF9F8FF)),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: largeur * 0.075),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: hauteur * 0.01),

                            /// "Depature"
                            SizedBox(
                                width: largeur * 0.55,
                                height: hauteur * 0.025,
                                child: MyText(
                                    text: "Departure",
                                    weight: FontWeight.w700,
                                    fontsize: 14,
                                    color: const Color(0xff20236C),
                                    largeur: largeur * 0.55)),
                            SizedBox(height: hauteur * 0.005),

                            /// +Departure Filed
                            Container(
                              width: largeur * 0.9,
                              height: hauteur * 0.0625,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 20,
                                        color: bleu_bg.withOpacity(0.15),
                                        offset: const Offset(0, 0),
                                        spreadRadius: 10)
                                  ],
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(4))),
                              child: Row(
                                children: [
                                  ///Search places
                                  InkWell(
                                    onTap: () async {
                                      var place = await PlacesAutocomplete.show(
                                          context: context,
                                          apiKey: APIKEY,
                                          mode: Mode.overlay,
                                          types: [],
                                          strictbounds: false,
                                          components: [
                                            Component(Component.country, 'dz')
                                          ],
                                          //google_map_webservice package
                                          onError: (err) {
                                            print(err);
                                          });
                                      if (place != null) {
                                        setState(() {
                                          Variables.locationName =
                                              place.description.toString();
                                          print(Variables.locationName);
                                        });

                                        //form google_maps_webservice package
                                        final plist = GoogleMapsPlaces(
                                            apiKey: APIKEY,
                                            apiHeaders:
                                                await const GoogleApiHeaders()
                                                    .getHeaders());
                                        String placeid = place.placeId ?? "0";
                                        final detail = await plist
                                            .getDetailsByPlaceId(placeid);
                                        final geometry =
                                            detail.result.geometry!;
                                        final lat = geometry.location.lat;
                                        final lang = geometry.location.lng;
                                        var newlatlang = LatLng(lat, lang);
                                        location = newlatlang;
                                        debut = PointLatLng(newlatlang.latitude,
                                            newlatlang.longitude);
                                        //move map camera to selected place with animation
                                        mapController?.animateCamera(
                                            CameraUpdate.newCameraPosition(
                                                CameraPosition(
                                                    target: newlatlang,
                                                    zoom: 17)));
                                      }
                                      ;
                                    },
                                    child: Row(
                                      children: [
                                        SizedBox(width: largeur * 0.02),
                                        Icons_ESIWay(
                                            icon: 'search',
                                            largeur: largeur * 0.08,
                                            hauteur: largeur * 0.08),
                                        SizedBox(width: largeur * 0.02),
                                        SizedBox(
                                            width: largeur * 0.57,
                                            child: AutoSizeText(
                                              Variables.locationName,
                                              style: const TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w500,
                                                color: bleu_bg,
                                                fontSize: 12,
                                              ),
                                              maxLines: 2,
                                            )),
                                      ],
                                    ),
                                  ),

                                  /// ESI
                                  InkWell(
                                      onTap: () {
                                        setState(() {
                                          Variables.locationName =
                                              "Ecole Nationale Supérieure d'Informatique (Ex. INI)";
                                          debut = PointLatLng(
                                              LocationEsi.latitude,
                                              LocationEsi.longitude);
                                        });
                                      },
                                      child: Image(
                                          image: const AssetImage(
                                              "Assets/Images/esi_logo.png"),
                                          width: largeur * 0.06,
                                          height: hauteur * 0.06)),
                                  // Icon(Icons.my_location,color:bleu_bg,size: largeur*0.06,),
                                  SizedBox(
                                    width: largeur * 0.015,
                                  ),

                                  ///Current location
                                  InkWell(
                                      onTap: () {
                                        setState(() {
                                          Variables.locationName =
                                              "Current Location";
                                        });
                                      },
                                      child: Icon(
                                        Icons.my_location,
                                        color: bleu_bg,
                                        size: largeur * 0.06,
                                      )),
                                ],
                              ),
                            ),
                            SizedBox(height: hauteur * 0.02),

                            ///  "Arival"
                            SizedBox(
                                width: largeur * 0.139,
                                height: hauteur * 0.025,
                                child: MyText(
                                  text: "Arrival",
                                  weight: FontWeight.w700,
                                  fontsize: 14,
                                  color: const Color(0xff20236C),
                                  largeur: largeur * 0.139,
                                )),
                            SizedBox(height: hauteur * 0.005),

                            /// +Arrival Filed
                            Container(
                              width: largeur * 0.9,
                              height: hauteur * 0.0625,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 20,
                                        color: bleu_bg.withOpacity(0.15),
                                        offset: const Offset(0, 0),
                                        spreadRadius: 10)
                                  ],
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(4))),
                              child: Row(
                                children: [
                                  ///Search places
                                  InkWell(
                                    onTap: () async {
                                      var place = await PlacesAutocomplete.show(
                                          context: context,
                                          apiKey: APIKEY,
                                          mode: Mode.overlay,
                                          types: [],
                                          strictbounds: false,
                                          components: [
                                            Component(Component.country, 'dz')
                                          ],
                                          //google_map_webservice package
                                          onError: (err) {
                                            print(err);
                                          });
                                      if (place != null) {
                                        setState(() {
                                          Variables.locationNamea =
                                              place.description.toString();
                                          print(Variables.locationNamea);
                                        });

                                        //form google_maps_webservice package
                                        final plist = GoogleMapsPlaces(
                                            apiKey: APIKEY,
                                            apiHeaders:
                                                await const GoogleApiHeaders()
                                                    .getHeaders());
                                        String placeid = place.placeId ?? "0";
                                        final detail = await plist
                                            .getDetailsByPlaceId(placeid);
                                        final geometry =
                                            detail.result.geometry!;
                                        final lat = geometry.location.lat;
                                        final lang = geometry.location.lng;
                                        var newlatlang = LatLng(lat, lang);
                                        location = newlatlang;
                                        fin = PointLatLng(newlatlang.latitude,
                                            newlatlang.longitude);
                                        //move map camera to selected place with animation
                                        mapController?.animateCamera(
                                            CameraUpdate.newCameraPosition(
                                                CameraPosition(
                                                    target: newlatlang,
                                                    zoom: 17)));
                                      }
                                      ;
                                      setState(() {});
                                    },
                                    child: Row(
                                      children: [
                                        SizedBox(width: largeur * 0.02),
                                        Icons_ESIWay(
                                            icon: 'search',
                                            largeur: largeur * 0.08,
                                            hauteur: largeur * 0.08),
                                        SizedBox(width: largeur * 0.02),
                                        SizedBox(
                                            width: largeur * 0.57,
                                            child: AutoSizeText(
                                              Variables.locationNamea,
                                              style: const TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w500,
                                                color: bleu_bg,
                                                fontSize: 12,
                                              ),
                                              maxLines: 2,
                                            )),
                                      ],
                                    ),
                                  ),

                                  /// ESI
                                  InkWell(
                                      onTap: () {
                                        setState(() {
                                          Variables.locationNamea =
                                              "Ecole Nationale Supérieure d'Informatique (Ex. INI)";
                                          fin = PointLatLng(
                                              LocationEsi.latitude,
                                              LocationEsi.longitude);
                                        });
                                      },
                                      child: Image(
                                          image: const AssetImage(
                                              "Assets/Images/esi_logo.png"),
                                          width: largeur * 0.06,
                                          height: hauteur * 0.06)),
                                  SizedBox(
                                    width: largeur * 0.015,
                                  ),

                                  ///Current location
                                  InkWell(
                                      onTap: () {
                                        setState(() {
                                          Variables.locationNamea =
                                              "Current Location";
                                        });
                                      },
                                      child: Icon(
                                        Icons.my_location,
                                        color: bleu_bg,
                                        size: largeur * 0.06,
                                      )),
                                ],
                              ),
                            ),

                            SizedBox(height: hauteur * 0.02),

                            /// +Date & Hour
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    /// "Date"
                                    SizedBox(
                                        width: largeur * 0.11,
                                        height: hauteur * 0.025,
                                        child: MyText(
                                          text: "Date",
                                          weight: FontWeight.w700,
                                          fontsize: 14,
                                          color: const Color(0xff20236C),
                                          largeur: largeur * 0.11,
                                        )),
                                    SizedBox(height: hauteur * 0.005),

                                    /// +Date Filed
                                    GestureDetector(
                                      onTap: () async {
                                        _selectDate(context);
                                      },
                                      child: SizedBox(
                                        height: hauteur * 0.0625,
                                        width: largeur * 0.5,
                                        child: Container(
                                            decoration: BoxDecoration(
                                                boxShadow: const [
                                                  BoxShadow(
                                                      blurRadius: 18,
                                                      color: Color.fromRGBO(
                                                          32, 35, 108, 0.15))
                                                ],
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Transform.scale(
                                                  scale:
                                                      1.5, // to make the icon smaller or larger
                                                  child: const Icons_ESIWay(
                                                      icon: "calendar",
                                                      largeur: 20,
                                                      hauteur: 20),
                                                ),
                                                MyText(
                                                  text: date!,
                                                  weight: FontWeight.w500,
                                                  fontsize: 14,
                                                  color:
                                                      const Color(0xFF20236C),
                                                  largeur: largeur * 0.2,
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                              ],
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    /// "Heure"
                                    SizedBox(
                                        width: largeur * 0.13,
                                        height: hauteur * 0.025,
                                        child: MyText(
                                          text: "Heure",
                                          weight: FontWeight.w700,
                                          fontsize: 14,
                                          color: const Color(0xff20236C),
                                          largeur: largeur * 0.13,
                                        )),
                                    SizedBox(height: hauteur * 0.005),

                                    /// +Heure Filed
                                    GestureDetector(
                                      onTap: () async {
                                        _selectTime(context);
                                      },
                                      child: SizedBox(
                                        height: hauteur * 0.0625,
                                        width: largeur * 0.3,
                                        child: Container(
                                            decoration: BoxDecoration(
                                                boxShadow: const [
                                                  BoxShadow(
                                                      blurRadius: 18,
                                                      color: Color.fromRGBO(
                                                          32, 35, 108, 0.15))
                                                ],
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Transform.scale(
                                                  scale:
                                                      1.5, // to make the icon smaller or larger
                                                  child: const Icons_ESIWay(
                                                      icon: "timer",
                                                      largeur: 20,
                                                      hauteur: 20),
                                                ),
                                                MyText(
                                                    text: time!,
                                                    weight: FontWeight.w500,
                                                    fontsize: 14,
                                                    color:
                                                        const Color(0xFF20236C),
                                                    largeur: largeur * 0.15),
                                              ],
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: hauteur * 0.02),
                              ],
                            ),
                            SizedBox(height: hauteur * 0.02),

                            ///  "Paiment"
                            SizedBox(
                                width: largeur * 0.2,
                                height: hauteur * 0.025,
                                child: MyText(
                                  text: "Paiment",
                                  weight: FontWeight.w700,
                                  fontsize: 14,
                                  color: const Color(0xff20236C),
                                  largeur: largeur * 0.2,
                                )),
                            SizedBox(height: hauteur * 0.005),

                            /// +Paiment Field
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: largeur * 0.3,
                                  height: hauteur * 0.0625,
                                  decoration: BoxDecoration(
                                      boxShadow: const [
                                        BoxShadow(
                                            blurRadius: 18,
                                            color: Color.fromRGBO(
                                                32, 35, 108, 0.15))
                                      ],
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: TextField(
                                          controller: pricecontroller,
                                          decoration: const InputDecoration(
                                            hintText: "Price",
                                            hintStyle: TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xff20236C),
                                                fontSize: 14),
                                            focusedBorder: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            disabledBorder: InputBorder.none,
                                            filled: false,
                                          ),
                                        ),
                                      ),
                                      const AutoSizeText("Da",
                                          style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w500,
                                              color: const Color(0xff20236C),
                                              fontSize: 14)),
                                      const SizedBox(width: 10),
                                    ],
                                  ),
                                ),

                                /// methode
                                Container(
                                  width: largeur * 0.51,
                                  height: hauteur * 0.0625,
                                  decoration: BoxDecoration(
                                      boxShadow: const [
                                        BoxShadow(
                                            blurRadius: 18,
                                            color: Color.fromRGBO(
                                                32, 35, 108, 0.15))
                                      ],
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: DropdownButtonFormField(
                                    value: dropdownValue,
                                    icon: const Icon(
                                        Icons.arrow_drop_down_rounded,
                                        color: Color(0xFF72D2C2)),
                                    decoration: const InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white)),
                                      focusedBorder: InputBorder.none,
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                    items: const [
                                      DropdownMenuItem(
                                        value: "-1",
                                        child: Text(
                                          "choose a method ",
                                          style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xff20236C),
                                              fontSize: 12),
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: "1",
                                        child: AutoSizeText(
                                          "Negociable",
                                          style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xff20236C),
                                              fontSize: 12),
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: "2",
                                        child: AutoSizeText(
                                          "Service",
                                          style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xff20236C),
                                              fontSize: 12),
                                        ),
                                      ),
                                    ],
                                    onChanged: (value) {
                                      if (value == "1") {
                                        methode = "Negociable";
                                      }
                                      ;
                                      if (value == "2") {
                                        methode = "Service";
                                      }
                                      ;
                                      print(methode);
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: hauteur * 0.02),

                            ///Preferences
                            SizedBox(
                                width: largeur * 0.266,
                                height: hauteur * 0.025,
                                child: MyText(
                                    text: "Preferences",
                                    weight: FontWeight.w700,
                                    fontsize: 14,
                                    color: const Color(0xff20236C),
                                    largeur: largeur * 0.266)),
                            SizedBox(height: hauteur * 0.005),

                            /// +Preferences Field
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SimpleButton(
                                    backgroundcolor:
                                        bags ? bleu_ciel : Colors.white,
                                    size:
                                        Size(largeur * 0.2, hauteur * 0.00875),
                                    radius: 3,
                                    text: "Bags",
                                    textcolor: bleu_bg,
                                    fontsize: 12,
                                    fct: () {
                                      bags = !bags;
                                      setState(() {});
                                    },
                                    blur: 18),
                                SimpleButton(
                                    backgroundcolor:
                                        talking ? bleu_ciel : Colors.white,
                                    size: Size(
                                        largeur * 0.277, hauteur * 0.00875),
                                    radius: 3,
                                    text: "Talking",
                                    textcolor: bleu_bg,
                                    fontsize: 12,
                                    fct: () {
                                      (talking = !talking);
                                      setState(() {});
                                    },
                                    blur: 18),
                                SimpleButton(
                                    backgroundcolor:
                                        animals ? bleu_ciel : Colors.white,
                                    size: Size(
                                        largeur * 0.277, hauteur * 0.00875),
                                    radius: 3,
                                    text: "Animals",
                                    textcolor: bleu_bg,
                                    fontsize: 12,
                                    fct: () {
                                      (animals = !animals);
                                      setState(() {});
                                    },
                                    blur: 18),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SimpleButton(
                                    backgroundcolor:
                                        smoking ? bleu_ciel : Colors.white,
                                    size: Size(
                                        largeur * 0.277, hauteur * 0.00875),
                                    radius: 3,
                                    text: "Smoking",
                                    textcolor: bleu_bg,
                                    fontsize: 12,
                                    fct: () {
                                      smoking = !smoking;
                                      setState(() {});
                                    },
                                    blur: 18),
                                SizedBox(width: largeur * 0.07),
                                SimpleButton(
                                    backgroundcolor:
                                        others ? bleu_ciel : Colors.white,
                                    size: Size(
                                        largeur * 0.277, hauteur * 0.00875),
                                    radius: 3,
                                    text: "Other",
                                    textcolor: bleu_bg,
                                    fontsize: 12,
                                    fct: () {
                                      (others = !others);
                                      setState(() {});
                                    },
                                    blur: 18),
                              ],
                            ),
                            SizedBox(height: hauteur * 0.01),

                            ///Seats
                            Row(
                              children: [
                                SizedBox(
                                    width: largeur * 0.2,
                                    height: hauteur * 0.025,
                                    child: MyText(
                                        text: "Seats",
                                        weight: FontWeight.w700,
                                        fontsize: 14,
                                        color: const Color(0xff20236C),
                                        largeur: largeur * 0.2)),
                                Container(
                                  width: largeur * 0.3,
                                  height: hauteur * 0.05,
                                  decoration: BoxDecoration(
                                      boxShadow: const [
                                        BoxShadow(
                                            blurRadius: 18,
                                            color: Color.fromRGBO(
                                                32, 35, 108, 0.15))
                                      ],
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: DropdownButtonFormField(
                                    borderRadius: BorderRadius.circular(10),
                                    value: dropdownValue,
                                    icon: const Icon(
                                        Icons.arrow_drop_down_rounded,
                                        color: Color(0xFF72D2C2)),
                                    decoration: const InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white)),
                                      focusedBorder: InputBorder.none,
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                    items: const [
                                      DropdownMenuItem(
                                        value: "-1",
                                        child: Text(
                                          "4",
                                          style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xff20236C),
                                              fontSize: 12),
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: "1",
                                        child: AutoSizeText(
                                          "3",
                                          style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xff20236C),
                                              fontSize: 12),
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: "2",
                                        child: AutoSizeText(
                                          "2",
                                          style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xff20236C),
                                              fontSize: 12),
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: "3",
                                        child: AutoSizeText(
                                          "1",
                                          style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xff20236C),
                                              fontSize: 12),
                                        ),
                                      ),
                                    ],
                                    onChanged: (value) {
                                      if (value == "-1") {
                                        seats = "4";
                                      }
                                      ;
                                      if (value == "1") {
                                        seats = "3";
                                      }
                                      ;
                                      if (value == "2") {
                                        seats = "2";
                                      }
                                      ;
                                      if (value == "3") {
                                        seats = "1";
                                      }
                                      ;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: hauteur * 0.03),

                            /// Create Button
                            SimpleButton(
                                backgroundcolor: const Color(0xffFFA18E),
                                size: Size(largeur, hauteur * 0.06),
                                radius: 10,
                                text: "Create",
                                textcolor: const Color(0xFF20236C),
                                fontsize: 20,
                                weight: FontWeight.w700,
                                fct: () async {
                                  if (talking == true) {
                                    prefrence = prefrence + "Talking";
                                  }
                                  if (bags == true) {
                                    prefrence = prefrence + " Bags";
                                  }
                                  if (smoking == true) {
                                    prefrence = prefrence + " Smoking";
                                  }
                                  if (animals == true) {
                                    prefrence = prefrence + " Animals";
                                  }
                                  print(prefrence);
                                  //if ((locationName == "Search places") || (locationNamea == "Search places")) {
                                  Variables.created = true;
                                  print("date is :   $date");
                                  createTrip(
                                      auth.currentUser!.uid,
                                      debut,
                                      fin,
                                      Variables.locationName,
                                      Variables.locationNamea,
                                      date!,
                                      time!,
                                      pricecontroller.text.trim(),
                                      seats!,
                                      methode,
                                      prefrence);

                                  final FirebaseFirestore firestore =
                                      FirebaseFirestore.instance;
                                  // }
                                  /*else {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text(
                                              'Alert!',
                                              style: TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w700,
                                                fontSize: 16,
                                                color: bleu_bg,
                                              ),
                                            ),
                                            content: const Text(
                                              'You must entre an adress?',
                                              style: TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                                color: bleu_bg,
                                              ),
                                            ),
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    0xFF, 0xB0, 0xD3, 0xD7),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('OK',
                                                    style: TextStyle(
                                                      fontFamily: 'Montserrat',
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 14,
                                                      color: bleu_bg,
                                                    )),
                                              ),
                                            ],
                                          );
                                        });
                                  };*/
                                }),

                            SizedBox(height: hauteur * 0.05),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// Back Button
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
                    if (Variables.created == false)
                      markers.clear();
                    else
                      (print('test'));
                    toHome();
                  }),
            ),
          )
        ],
      ),
    );
  }
}
