import 'dart:core';
import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esiway/Screens/Home/liste.dart';
import 'package:esiway/Screens/Home/tripSuggestions.dart';
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
import 'findingTrip_page.dart';
import 'home_page.dart';
import 'tripUser.dart';
import 'variables.dart';

class SearchTripPage extends StatefulWidget {
  Set<Marker> markers = Set(); //markers for google map
  GoogleMapController? mapController; //controller for Google map
  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {}; //polylines to show direction
  double distance = 0.0;

  SearchTripPage({
    super.key,
    required this.markers,
    required this.mapController,
    required this.polylinePoints,
    required this.polylines,
    required this.distance,
  });

  @override
  State<SearchTripPage> createState() => _SearchTripPageState();
}

class _SearchTripPageState extends State<SearchTripPage> {
  void initState() {
    // TODO: implement initState
    count = 0;
    minute = TimeNow.minute >= 10 ? "${TimeNow.minute}" : "0${TimeNow.minute}";
    hour = TimeNow.hour >= 10 ? "${TimeNow.hour}" : "0${TimeNow.hour}";
    time = hour! + " : " + minute!;

    Variables.locationName = "Search places";
    Variables.locationNamea = "Search places";
    Variables.debut = const PointLatLng(36.72376684085901, 2.991892973393687);
    Variables.fin = const PointLatLng(36.72376684085901, 2.991892973393687);
    Variables.polylineCoordinates.clear();
    Variables.created = false;
    super.initState();
  }

//======================================================================================================//
//=========================================| Variables |================================================//
//======================================================================================================//

  /// +Fire base (pour stocker dans firebase on choisit la collection Trips)
  final docTrips = FirebaseFirestore.instance.collection("Trips");
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
  late int count;
  DateTime selectedDate = DateTime.now();

  int i = 0;

  //String? date = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,).toString();
  String? date =
      "${DateTime.now().day} - ${DateTime.now().month} - ${DateTime.now().year}";

  String? time = "00:00";
  String? minute;
  String? hour;
  TimeOfDay TimeNow =
      TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);

//======================================================================================================//
//=========================================| Functions |================================================//
//======================================================================================================//

  ///=============================| Map Functions|===================================//

  ///+++++++++++++++++++++++++++++< ajouter Markers >+++++++++++++++++++++++++++///

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  void getAllDocs() {}

  List<String> polylineCoordinatesToString(List<LatLng> polylineCoordinates) {
    return polylineCoordinates
        .map((LatLng latLng) => '${latLng.latitude},${latLng.longitude}')
        .toList();
  }

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
    print(
        '***********************************************************************************************\n inside debut get direction    ----- ');

    List<LatLng> polylineCoordinates = [];

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
    print(
        '/////////////////////////////////////\n dakhel getdirection  variables polyloinecoord ${Variables.polylineCoordinates} \n\n\n');
    //polylineCoordinates is the List of longitute and latidtude.
    double totalDistance = 0;
    for (var i = 0; i < Variables.polylineCoordinates.length - 1; i++) {
      totalDistance += calculateDistance(
          Variables.polylineCoordinates[i].latitude,
          Variables.polylineCoordinates[i].longitude,
          Variables.polylineCoordinates[i + 1].latitude,
          Variables.polylineCoordinates[i + 1].longitude);
    }

    setState(() {
      Variables.distance = totalDistance;
    });
    addPolyLine(Variables.polylineCoordinates);
    print(
        '***********************************************************************************************\n inside fin get direction    ----- ');
  }

  ///+++++++++++++++++++++++++++++< Add Polyline >++++++++++++++++++++++++++++++///
  addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Color.fromRGBO(81, 34, 209, 1),
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

  List<TripUser> liste = [];
  TripUser trip = TripUser();

  Future<void> searchTrip(String conducteur, PointLatLng one, PointLatLng two,
      String depart, String arrivee, String date, String heure) async {
    ListeTrip.liste.clear();
    Variables.polylineCoordinates.clear();
    print(
        '================ Debut de fonction searchTrip ======================');

    await getDirection(one, two); //fetch direction polylines from Google API

    ajouterMarkers(one, "Starting Location", depart);

    ajouterMarkers(two, "Arrival Location", arrivee);

    mapController?.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(one.latitude, one.longitude), zoom: 17)));

    firestore.collection('Trips').get().then((QuerySnapshot querySnapshot) {
      int index = 0;
      int v = 0;
      querySnapshot.docs.forEach((DocumentSnapshot documentSnapshot) async {
        print('index = $index');
        print('v = $v');

        if (date == documentSnapshot.get('Date')) {
          print('date equals and v == $v');

          var polylineCoordinate = documentSnapshot.get('polyline');

          print(
              "length de polylines deéfire base ===  ${polylineCoordinate.length} \n");

          count = 0;

          List<String> rechercheArray =
              polylineCoordinatesToString(Variables.polylineCoordinates);

          for (String point1 in rechercheArray) {
            if (polylineCoordinate.contains(point1)) {
              count++;
            }
          }

          print('+Count $count');

          double percent = count / Variables.polylineCoordinates.length;
          print("+ percent = $percent");
          if (percent >= 0.4) {
            print('prcnt > 40 and v == $v');

            v++;

            GeoPoint geoPointData = documentSnapshot.get("Depart_LatLng");
            GeoPoint geoPoint = geoPointData;
            trip.departLatLng =
                (PointLatLng(geoPoint.latitude, geoPoint.longitude));
            geoPoint = documentSnapshot.get("Arrivee_LatLng");
            trip.arriveeLatLng =
                (PointLatLng(geoPoint.latitude, geoPoint.longitude));

            trip.arrivee = documentSnapshot.get('Arrivee').toString();
            trip.depart = documentSnapshot.get('Depart').toString();
            trip.price = documentSnapshot.get('Price').toString();
            trip.methode = documentSnapshot.get('methode').toString();
            trip.seats = documentSnapshot.get('Places').toString();
            trip.time = documentSnapshot.get('Heure').toString();
            trip.date = documentSnapshot.get('Date').toString();

            String uid = documentSnapshot.get('Conducteur').toString();
            trip.conducteur = uid;
            try {
              DocumentSnapshot documentSnapshot = await FirebaseFirestore
                  .instance
                  .collection('Users')
                  .doc(uid)
                  .get();

              if (documentSnapshot.exists) {
                var userData = documentSnapshot.data() as Map<String,
                    dynamic>; // Explicitly cast to the appropriate type
                // Do something with the user data
                trip.name = userData['Name'].toString();
                trip.familyName = userData['FamilyName'].toString();
                trip.statu = userData['Status'].toString();
                trip.carName = userData['hasCar'].toString();

                print(userData);
              } else {
                print('User not found');
              }
            } catch (e) {
              print('Error getting user information: $e');
            }

            print(
                '*****************************************************************************************************\n\n');
            print(
                'avant linsertion dans la list trip = ${trip.date}${trip.time}${trip.seats}${trip.methode}${trip.arrivee}${trip.depart}${trip.price}');
            print(
                '*****************************************************************************************************\n\n');

            TripUser test;
            ListeTrip.liste.add(trip);
            print('Trip attribu avant l\'affectation  ${trip.name}');
            // ListeTrip.liste[index] = trip;

            print(
                "List ======================== \n\n${ListeTrip.liste[index].depart} ,${ListeTrip.liste[index].arrivee} ,${ListeTrip.liste[index].departLatLng} ${ListeTrip.liste[index].methode} ,${ListeTrip.liste[index].time} \n\nFin list======================");
            index++;
            print('index ==           $index');
          } else {
            v++;

            print('--------- No prcnt < 40% = $percent =====================');
          }
        }

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => /*SearchResult() */
                    TripSuggestPage(
                      markers: markers,
                      mapController: mapController,
                      polylinePoints: polylinePoints,
                      polylines: polylines,
                      distance: distance,
                    )));
      });
    }).catchError((error) {
      print('Failed to retrieve documents: $error');
    });

    print('***************** Aftert fire base *****************');
    // print('================ Fin de fonction searchTrip et list == ${ListeTrip.liste[0].depart} ======================');
  }

  @override
  Widget build(BuildContext context) {
    var largeur = MediaQuery.of(context).size.width;
    var hauteur = MediaQuery.of(context).size.height;

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
              width: largeur,
              height: hauteur * 0.5,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                  ),
                  color: Color(0xFFF9F8FF)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    color: const Color(0xFFF9F8FF),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: largeur * 0.075),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: hauteur * 0.02),

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
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(4))),
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
                                      final geometry = detail.result.geometry!;
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
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(4))),
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
                                      final geometry = detail.result.geometry!;
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
                                        fin = PointLatLng(LocationEsi.latitude,
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
                                                color: const Color(0xFF20236C),
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
                          SizedBox(height: hauteur * 0.03),

                          /// search Button
                          SimpleButton(
                              backgroundcolor: const Color(0xffFFA18E),
                              size: Size(largeur, hauteur * 0.06),
                              radius: 10,
                              text: "Search",
                              textcolor: const Color(0xFF20236C),
                              fontsize: 20,
                              fct: () async {
                                // if((locationName == "Search places") || (locationNamea == "Search places")) {
                                //Variables.created = true;
                                // search trip
                                print(
                                    '---- Button search inn search pag clicked --------');
                                await searchTrip(
                                    auth.currentUser!.uid,
                                    debut,
                                    fin,
                                    Variables.locationName,
                                    Variables.locationNamea,
                                    date!,
                                    time!);

                                /*     }else
                                  { 
                                    
                                    showDialog(
                                   context: context,
                                   builder: (context) {
                                     return AlertDialog(
                                       title: const Text('Alert!',style:TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w700, fontSize: 16, color: bleu_bg,),),
                                       content: const Text('You must entre a car?',style:TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w500, fontSize: 14, color: bleu_bg,),),
                                       backgroundColor: const Color.fromARGB(0xFF, 0xB0, 0xD3, 0xD7),
                                       actions: [
                                         TextButton(
                                           onPressed: () {Navigator.pop(context);},
                                           child: const Text('OK',style:TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w700, fontSize: 14, color: bleu_bg,)),
                                         ),

                                       ],
                                     );
                                   });} */
                                /*  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder:
                                            (context) => /*SearchResult() */
                                                TripSuggestPage(
                                                  markers: markers,
                                                  mapController: mapController,
                                                  polylinePoints:
                                                      polylinePoints,
                                                  polylines: polylines,
                                                  distance: distance,
                                                )));
                                */
                              },
                              weight: FontWeight.w700),
                          SizedBox(height: hauteur * 0.05),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          ///Back Button
          Positioned(
            top: hauteur * 0.05,
            left: largeur * 0.05,
            right: largeur * 0.05,
            child: SizedBox(
              height: hauteur * 0.07,
              width: largeur * 0.8,
              child: PrefixeIconButton(
                  size: const Size(73, 34),
                  color: Colors.white,
                  radius: 10,
                  text: "Ecole Nationale superieure d’informatique  ",
                  textcolor: const Color(0xFF20236C),
                  weight: FontWeight.w600,
                  fontsize: 12,
                  icon: Transform.scale(
                    scale: 0.75,
                    child: const Icons_ESIWay(
                        icon: "arrow_left", largeur: 30, hauteur: 30),
                  ),
                  espaceicontext: 5.0,
                  fct: () {
                    Navigator.pop(context);
                  }),
            ),
          )
        ],
      ),
    );
  }
}
