import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:esiway/Screens/home/variables.dart';
import 'package:esiway/widgets/our_prefixeIconButton.dart';
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
import 'createTrip_Page.dart';
import 'searchTrip_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  String? date;
  void initState() {
    // TODO: implement initState
   // date = "${selectedDate.day} - ${selectedDate.month} - ${selectedDate.year}";
    if(Variables.created == true){
    if((Variables.locationName != "Search places")&& (Variables.locationNamea !="Search places")){
      getDirection(Variables.debut, Variables.fin);
      distance = Variables.distance;
      mapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(debut.latitude,debut.longitude), zoom: 17)));

    }else{markers.clear();}
    }
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

  static LatLng startLocation = const LatLng(36.705219106281575, 3.173786850126649);

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
  getDirections() async {
    List<LatLng> polylineCoordinates = [];
    List<String> cities = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPiKey,
      PointLatLng(startLocation.latitude, startLocation.longitude),
      PointLatLng(endLocation.latitude, endLocation.longitude),
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) async {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        List<Placemark> placemarks =
            await placemarkFromCoordinates(point.latitude, point.longitude);
        String? city = placemarks[0].locality;
        cities.add(city!);
      });
    } else {
      print(result.errorMessage);
    }

    //polulineCoordinates is the List of longitute and latidtude.
    double totalDistance = 0;
    for (var i = 0; i < polylineCoordinates.length - 1; i++) {
      totalDistance += calculateDistance(
          polylineCoordinates[i].latitude,
          polylineCoordinates[i].longitude,
          polylineCoordinates[i + 1].latitude,
          polylineCoordinates[i + 1].longitude);
    }
    print(totalDistance);

    setState(() {
      distance = totalDistance;
    });

    addPolyLine(polylineCoordinates);
  }

  PointLatLng debut = Variables.debut;
  PointLatLng fin =  Variables.fin;

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
    List<String> latLngStrings = polylineCoordinates.map((latLng) => '${latLng.latitude},${latLng.longitude}').toList();

    PolylineResult result = await  polylinePoints.getRouteBetweenCoordinates(APIKEY, depart, arrival,);
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

    setState(() {Variables.distance = totalDistance;});
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

  void depart(String? value, PointLatLng position, String name) async {
    print(startLocation.toString());
    if (value == "1") {
      Position positione = await determinePosition();
      position = PointLatLng(positione.latitude, positione.longitude);
      markers.add(Marker(
          markerId: const MarkerId("current location"),
          position: LatLng(position.latitude, position.longitude)));
      mapController?.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 14)));
      setState(() {});
    }
    ;

    if (value == "2") {
      position = PointLatLng(LocationEsi.latitude, LocationEsi.longitude);
      markers.add(Marker(
        //add start location marker
        markerId: MarkerId(endLocation.toString()),
        position: LocationEsi, //position of marker
        infoWindow: const InfoWindow(
          //popup info
          title: 'Arrival Point ',
          snippet: 'ESI',
        ),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));
      mapController?.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 14)));
    }
    ;

    if (value == "3") {
      LatLng point = LatLng(position.latitude, position.longitude);
      mapController?.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: point, zoom: 17)));
      markers.add(Marker(
        //add start location marker
        markerId: MarkerId(point.toString()),
        position: point, //position of marker
        infoWindow: InfoWindow(
          //popup info
          title: 'Starting Point ',
          snippet: name,
        ),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));
    }
    ;

    setState(() {});
  }

  void arrival(String? value, PointLatLng position, String name) async {
    if (value == "1") {
      Position positione = await determinePosition();
      position = PointLatLng(positione.latitude, positione.longitude);
      markers.add(Marker(
          markerId: const MarkerId("current location"),
          position: LatLng(position.latitude, position.longitude)));
      mapController?.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 14)));
      setState(() {});
    }
    ;

    if (value == "2") {
      position = PointLatLng(LocationEsi.latitude, LocationEsi.longitude);
      markers.add(Marker(
        //add start location marker
        markerId: MarkerId(endLocation.toString()),
        position: LocationEsi, //position of marker
        infoWindow: const InfoWindow(
          //popup info
          title: 'Arrival Point ',
          snippet: 'ESI',
        ),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));
      mapController?.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 14)));
    }
    ;

    if (value == "3") {
      LatLng point = LatLng(position.latitude, position.longitude);
      mapController?.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: point, zoom: 17)));
      markers.add(Marker(
        //add start location marker
        markerId: MarkerId(point.toString()),
        position: point, //position of marker
        infoWindow: InfoWindow(
          //popup info
          title: 'Destination Point ',
          snippet: name,
        ),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));
    }
    ;
    //setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var largeur = MediaQuery.of(context).size.width;
    var hauteur = MediaQuery.of(context).size.height;
    var dropdownValue = "-1"; // drop down value

    searchTrip() {
      return showModalBottomSheet(
          context: context,
          builder: (context) {
            return Scaffold(
              bottomNavigationBar: BottomNavBar(currentindex: 3),
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      color: const Color(0xFFF9F8FF),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: largeur * 0.075),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: hauteur * 0.03),

                            /// "Depature"
                            SizedBox(
                                width: largeur * 0.55,
                                height: hauteur * 0.025,
                                child: MyText(
                                  text: "Departure",
                                  weight: FontWeight.w700,
                                  fontsize: 14,
                                  color: Color(0xff20236C),
                                  largeur: largeur * 0.55,
                                )),

                            SizedBox(height: hauteur * 0.005),

                            /// +Departure Filed
                            Container(
                              width: largeur * 0.9,
                              height: hauteur * 0.0625,
                              decoration: const BoxDecoration(boxShadow: [
                                BoxShadow(
                                    blurRadius: 18,
                                    color: Color.fromRGBO(32, 35, 108, 0.15),
                                    spreadRadius: 10)
                              ]),
                              child: DropdownButtonFormField(
                                value: dropdownValue,
                                decoration: const InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white)),
                                  focusedBorder: InputBorder.none,
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                items: [
                                  const DropdownMenuItem(
                                    value: "-1",
                                    child: AutoSizeText(
                                      " select your address of departure ",
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xff20236C),
                                          fontSize: 12),
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: "1",
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: const [
                                        AutoSizeText(
                                          " Your current location",
                                          style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xff20236C),
                                              fontSize: 12),
                                        ),
                                        Icon(Icons.my_location_outlined,
                                            color: Color(0xFF72D2C2)),
                                      ],
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: "2",
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: const [
                                          AutoSizeText(
                                            " ESI ",
                                            style: TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xff20236C),
                                                fontSize: 12),
                                          ),
                                          Icon(Icons.account_circle,
                                              color: Color(0xFF72D2C2)),
                                        ]),
                                  ),
                                  DropdownMenuItem(
                                    value: "3",
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          locationName ?? "search places",
                                          style: const TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xff20236C),
                                              fontSize: 12),
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            var place =
                                                await PlacesAutocomplete.show(
                                                    context: context,
                                                    apiKey: googleAPiKey,
                                                    mode: Mode.overlay,
                                                    types: [],
                                                    strictbounds: false,
                                                    components: [
                                                      Component(
                                                          Component.country,
                                                          'dz')
                                                    ],
                                                    //google_map_webservice package
                                                    onError: (err) {
                                                      print(err);
                                                    });
                                            if (place != null) {
                                              setState(() {
                                                locationName = place.description
                                                    .toString();
                                                print(locationName);
                                              });

                                              //form google_maps_webservice package
                                              final plist = GoogleMapsPlaces(
                                                  apiKey: googleAPiKey,
                                                  apiHeaders:
                                                      await const GoogleApiHeaders()
                                                          .getHeaders());
                                              String placeid =
                                                  place.placeId ?? "0";
                                              final detail = await plist
                                                  .getDetailsByPlaceId(placeid);
                                              final geometry =
                                                  detail.result.geometry!;
                                              final lat = geometry.location.lat;
                                              final lang =
                                                  geometry.location.lng;
                                              var newlatlang =
                                                  LatLng(lat, lang);
                                              location = newlatlang;
                                              debut = PointLatLng(
                                                  newlatlang.latitude,
                                                  newlatlang.longitude);
                                              //move map camera to selected place with animation
                                              mapController?.animateCamera(
                                                  CameraUpdate
                                                      .newCameraPosition(
                                                          CameraPosition(
                                                              target:
                                                                  newlatlang,
                                                              zoom: 17)));
                                            }
                                            ;
                                            setState(() {});
                                          },
                                          child: const Icon(
                                              Icons.search_rounded,
                                              color: Color(0xFF72D2C2)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                                onChanged: (value) =>
                                    depart(value, debut, locationName!),
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
                                  color: Color(0xff20236C),
                                  largeur: largeur * 0.139,
                                )),

                            SizedBox(height: hauteur * 0.005),

                            /// +Arrival Filed
                            Container(
                              width: largeur * 0.9,
                              height: hauteur * 0.0625,
                              decoration: const BoxDecoration(boxShadow: [
                                BoxShadow(
                                    blurRadius: 18,
                                    color: Color.fromRGBO(32, 35, 108, 0.15),
                                    spreadRadius: 10)
                              ]),
                              child: DropdownButtonFormField(
                                value: dropdownValue,
                                decoration: const InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white)),
                                  focusedBorder: InputBorder.none,
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                items: [
                                  const DropdownMenuItem(
                                    value: "-1",
                                    child: Text(
                                      "select your address of Arrival ",
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xff20236C),
                                          fontSize: 12),
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: "1",
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: const [
                                        AutoSizeText(
                                          " Your current location",
                                          style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xff20236C),
                                              fontSize: 12),
                                        ),
                                        Icon(Icons.my_location_outlined,
                                            color: Color(0xFF72D2C2)),
                                      ],
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: "2",
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: const [
                                          AutoSizeText(
                                            " ESI ",
                                            style: TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xff20236C),
                                                fontSize: 12),
                                          ),
                                          Icon(Icons.account_circle,
                                              color: Color(0xFF72D2C2)),
                                        ]),
                                  ),
                                  DropdownMenuItem(
                                    value: "3",
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          locationNamea ?? "search places",
                                          style: const TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xff20236C),
                                              fontSize: 12),
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            var place =
                                                await PlacesAutocomplete.show(
                                                    context: context,
                                                    apiKey: googleAPiKey,
                                                    mode: Mode.overlay,
                                                    types: [],
                                                    strictbounds: false,
                                                    components: [
                                                      Component(
                                                          Component.country,
                                                          'dz')
                                                    ],
                                                    //google_map_webservice package
                                                    onError: (err) {
                                                      print(err);
                                                    });
                                            if (place != null) {
                                              setState(() {
                                                locationNamea = place
                                                    .description
                                                    .toString();
                                                print(locationNamea);
                                              });

                                              //form google_maps_webservice package
                                              final plist = GoogleMapsPlaces(
                                                  apiKey: googleAPiKey,
                                                  apiHeaders:
                                                      await const GoogleApiHeaders()
                                                          .getHeaders());
                                              String placeid =
                                                  place.placeId ?? "0";
                                              final detail = await plist
                                                  .getDetailsByPlaceId(placeid);
                                              final geometry =
                                                  detail.result.geometry!;
                                              final lat = geometry.location.lat;
                                              final lang =
                                                  geometry.location.lng;
                                              var newlatlang =
                                                  LatLng(lat, lang);
                                              location = newlatlang;
                                              fin = PointLatLng(
                                                  newlatlang.latitude,
                                                  newlatlang.longitude);
                                              //move map camera to selected place with animation
                                              mapController?.animateCamera(
                                                  CameraUpdate
                                                      .newCameraPosition(
                                                          CameraPosition(
                                                              target:
                                                                  newlatlang,
                                                              zoom: 17)));
                                            }
                                            ;
                                          },
                                          child: const Icon(
                                              Icons.search_rounded,
                                              color: Color(0xFF72D2C2)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                                onChanged: (value) =>
                                    arrival(value, fin, locationNamea!),
                              ),
                            ),

                            SizedBox(height: hauteur * 0.02),

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
                                          color: Color(0xff20236C),
                                          largeur: largeur * 0.11),
                                    ),
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
                                                SizedBox(
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
                                                SizedBox(
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
                                          color: Color(0xff20236C),
                                          largeur: largeur * 0.13,
                                        )),

                                    SizedBox(height: hauteur * 0.005),

                                    /// +Heure Filed
                                    SizedBox(
                                        height: hauteur * 0.0625,
                                        width: largeur * 0.3,
                                        child: OurTextField(
                                          controller: heurecontroller,
                                          text: "HH:MM",
                                          iconName: "email",
                                          borderColor: Colors.white,
                                          size: 0.7,
                                        )),
                                  ],
                                ),
                                SizedBox(height: hauteur * 0.02),
                              ],
                            ),

                            SizedBox(height: hauteur * 0.05),

                            SimpleButton(
                                backgroundcolor: const Color(0xffFFA18E),
                                size: Size(largeur, hauteur * 0.06),
                                radius: 10,
                                text: "Search",
                                textcolor: const Color(0xFF20236C),
                                fontsize: 20,
                                fct: () {
                                  next(debut, fin);
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
            );
          });
    };


    return Scaffold(
      bottomNavigationBar: BottomNavBar(currentindex: 3),
      body: Stack(
        children: [
          GoogleMap(
            //Map widget from google_maps_flutter package
            zoomGesturesEnabled: true, //enable Zoom in, out on map
            zoomControlsEnabled: false,
            initialCameraPosition:
            CameraPosition(//innital position in map
              target: Variables.created  ?LatLng(Variables.debut.latitude,Variables.debut.longitude) :startLocation , //initial position
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
                              fct: (){ Navigator.push(context, MaterialPageRoute(builder: (context) => SearchTripPage(markers: markers,mapController: mapController,polylinePoints: polylinePoints,polylines: polylines,distance: distance,)));}
                              ),

                          ///Notification Button
                          ElevatedButton(
                            onPressed: () {},
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CreateTripPage(markers: markers,mapController: mapController,polylinePoints: polylinePoints,polylines: polylines,distance: distance,)));
              }, // createTrip,


                            /// +Departure Filed
                            Container(
                              width: largeur * 0.9,
                              height: hauteur * 0.0625,
                              decoration: const BoxDecoration(boxShadow: [
                                BoxShadow(
                                    blurRadius: 18,
                                    color: Color.fromRGBO(32, 35, 108, 0.15),
                                    spreadRadius: 10)
                              ]),
                              child: DropdownButtonFormField(
                                value: dropdownValue,
                                icon: const Icon(Icons.arrow_drop_down_rounded,
                                    color: Color(0xFF72D2C2)),
                                decoration: const InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white)),
                                  focusedBorder: InputBorder.none,
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                items: [
                                  const DropdownMenuItem(
                                    value: "-1",
                                    child: AutoSizeText(
                                      " select your address of departure ",
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xff20236C),
                                          fontSize: 12),
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: "1",
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: const [
                                        AutoSizeText(
                                          " Your current location",
                                          style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xff20236C),
                                              fontSize: 12),
                                        ),
                                        Icon(Icons.my_location_outlined,
                                            color: Color(0xFF72D2C2)),
                                      ],
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: "2",
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: const [
                                          AutoSizeText(
                                            " ESI ",
                                            style: TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xff20236C),
                                                fontSize: 12),
                                          ),
                                          Icon(Icons.account_circle,
                                              color: Color(0xFF72D2C2)),
                                        ]),
                                  ),
                                  DropdownMenuItem(
                                    value: "3",
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          locationName ?? "search places",
                                          style: const TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xff20236C),
                                              fontSize: 12),
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            var place =
                                                await PlacesAutocomplete.show(
                                                    context: context,
                                                    apiKey: googleAPiKey,
                                                    mode: Mode.overlay,
                                                    types: [],
                                                    strictbounds: false,
                                                    components: [
                                                      Component(
                                                          Component.country,
                                                          'dz')
                                                    ],
                                                    //google_map_webservice package
                                                    onError: (err) {
                                                      print(err);
                                                    });
                                            if (place != null) {
                                              setState(() {
                                                locationName = place.description
                                                    .toString();
                                                print(locationName);
                                              });

                                              //form google_maps_webservice package
                                              final plist = GoogleMapsPlaces(
                                                  apiKey: googleAPiKey,
                                                  apiHeaders:
                                                      await const GoogleApiHeaders()
                                                          .getHeaders());
                                              String placeid =
                                                  place.placeId ?? "0";
                                              final detail = await plist
                                                  .getDetailsByPlaceId(placeid);
                                              final geometry =
                                                  detail.result.geometry!;
                                              final lat = geometry.location.lat;
                                              final lang =
                                                  geometry.location.lng;
                                              var newlatlang =
                                                  LatLng(lat, lang);
                                              location = newlatlang;
                                              debut = PointLatLng(
                                                  newlatlang.latitude,
                                                  newlatlang.longitude);
                                              //move map camera to selected place with animation
                                              mapController?.animateCamera(
                                                  CameraUpdate
                                                      .newCameraPosition(
                                                          CameraPosition(
                                                              target:
                                                                  newlatlang,
                                                              zoom: 17)));
                                            }
                                            ;
                                            setState(() {});
                                          },
                                          child: const Icon(
                                              Icons.search_rounded,
                                              color: Color(0xFF72D2C2)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                                onChanged: (value) =>
                                    depart(value, debut, locationName!),
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
                                  color: Color(0xff20236C),
                                  largeur: largeur * 0.139,
                                )),

                            SizedBox(height: hauteur * 0.005),

                            /// +Arrival Filed
                            Container(
                              width: largeur * 0.9,
                              height: hauteur * 0.0625,
                              decoration: const BoxDecoration(boxShadow: [
                                BoxShadow(
                                    blurRadius: 18,
                                    color: Color.fromRGBO(32, 35, 108, 0.15),
                                    spreadRadius: 10)
                              ]),
                              child: DropdownButtonFormField(
                                icon: const Icon(Icons.arrow_drop_down_rounded,
                                    color: Color(0xFF72D2C2)),
                                value: dropdownValue,
                                decoration: const InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white)),
                                  focusedBorder: InputBorder.none,
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                items: [
                                  const DropdownMenuItem(
                                    value: "-1",
                                    child: Text(
                                      "select your address of Arrival ",
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xff20236C),
                                          fontSize: 12),
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: "1",
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: const [
                                        AutoSizeText(
                                          " Your current location",
                                          style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xff20236C),
                                              fontSize: 12),
                                        ),
                                        Icon(Icons.my_location_outlined,
                                            color: Color(0xFF72D2C2)),
                                      ],
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: "2",
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: const [
                                          AutoSizeText(
                                            " ESI ",
                                            style: TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xff20236C),
                                                fontSize: 12),
                                          ),
                                          Icon(Icons.account_circle,
                                              color: Color(0xFF72D2C2)),
                                        ]),
                                  ),
                                  DropdownMenuItem(
                                    value: "3",
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          locationNamea ?? "search places",
                                          style: const TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xff20236C),
                                              fontSize: 12),
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            var place =
                                                await PlacesAutocomplete.show(
                                                    context: context,
                                                    apiKey: googleAPiKey,
                                                    mode: Mode.overlay,
                                                    types: [],
                                                    strictbounds: false,
                                                    components: [
                                                      Component(
                                                          Component.country,
                                                          'dz')
                                                    ],
                                                    //google_map_webservice package
                                                    onError: (err) {
                                                      print(err);
                                                    });
                                            if (place != null) {
                                              setState(() {
                                                locationNamea = place
                                                    .description
                                                    .toString();
                                                print(locationNamea);
                                              });

                                              //form google_maps_webservice package
                                              final plist = GoogleMapsPlaces(
                                                  apiKey: googleAPiKey,
                                                  apiHeaders:
                                                      await const GoogleApiHeaders()
                                                          .getHeaders());
                                              String placeid =
                                                  place.placeId ?? "0";
                                              final detail = await plist
                                                  .getDetailsByPlaceId(placeid);
                                              final geometry =
                                                  detail.result.geometry!;
                                              final lat = geometry.location.lat;
                                              final lang =
                                                  geometry.location.lng;
                                              var newlatlang =
                                                  LatLng(lat, lang);
                                              location = newlatlang;
                                              fin = PointLatLng(
                                                  newlatlang.latitude,
                                                  newlatlang.longitude);
                                              //move map camera to selected place with animation
                                              mapController?.animateCamera(
                                                  CameraUpdate
                                                      .newCameraPosition(
                                                          CameraPosition(
                                                              target:
                                                                  newlatlang,
                                                              zoom: 17)));
                                            }
                                            ;
                                            setState(() {});
                                          },
                                          child: const Icon(
                                              Icons.search_rounded,
                                              color: Color(0xFF72D2C2)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                                onChanged: (value) =>
                                    arrival(value, fin, locationNamea!),
                              ),
                            ),

                            SizedBox(height: hauteur * 0.02),

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
                                          color: Color(0xff20236C),
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
                                                SizedBox(
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
                                                SizedBox(
                                                  width: 5,
                                                ),
                                              ],
                                            )),

                                        /* SizedBox(
                                      height: hauteur * 0.0625,
                                      width: largeur * 0.5,
                                      child: OurTextField(controller: datecontroller, text: "DD/MM/YY", iconName: "calendar", borderColor: Colors.white, size: 0.7,),
                                    ),*/
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
                                          color: Color(0xff20236C),
                                          largeur: largeur * 0.13,
                                        )),

                                    SizedBox(height: hauteur * 0.005),

                                    /// +Heure Filed
                                    SizedBox(
                                        height: hauteur * 0.0625,
                                        width: largeur * 0.3,
                                        child: OurTextField(
                                          controller: heurecontroller,
                                          text: "HH:MM",
                                          iconName: "email",
                                          borderColor: Colors.white,
                                          size: 0.7,
                                        )),
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
                                  color: Color(0xff20236C),
                                  largeur: largeur * 0.2,
                                )),

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
                                      DropdownMenuItem(
                                        value: "3",
                                        child: AutoSizeText(
                                          "Rien",
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
                                      if (value == "3") {
                                        methode = "Rien";
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
                                  color: Color(0xff20236C),
                                  largeur: largeur * 0.266,
                                )),

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
                                      (smoking = !smoking);
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

                            ///Places
                            Row(
                              children: [
                                SizedBox(
                                    width: largeur * 0.2,
                                    height: hauteur * 0.025,
                                    child: MyText(
                                        text: "Places",
                                        weight: FontWeight.w700,
                                        fontsize: 14,
                                        color: Color(0xff20236C),
                                        largeur: largeur * 0.2)),
                                SizedBox(width: 10),
                                Container(
                                  width: largeur * 0.4,
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

                            SizedBox(height: hauteur * 0.05),

                            SimpleButton(
                                backgroundcolor: const Color(0xffFFA18E),
                                size: Size(largeur, hauteur * 0.06),
                                radius: 10,
                                text: "Create",
                                textcolor: const Color(0xFF20236C),
                                fontsize: 20,
                                fct: () {
                                  next(debut, fin);
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
            );
          });
      setState(() {});
    }

    ;

    return Scaffold(
      bottomNavigationBar: BottomNavBar(currentindex: 3),
      body: Stack(
        children: [
          GoogleMap(
            //Map widget from google_maps_flutter package
            zoomGesturesEnabled: true, //enable Zoom in, out on map
            zoomControlsEnabled: false,
            initialCameraPosition: CameraPosition(
              //innital position in map
              target: startLocation, //initial position
              zoom: 14.0, //initial zoom level
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
                              fct: searchTrip),

                          ///Notification Button
                          ElevatedButton(
                            onPressed: () {},
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
          Positioned(
            bottom: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () async {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CreateTripPage()));
              }, // createTrip,
              /*onPressed: (){     Navigator.push(
                  context, MaterialPageRoute(builder: (context) => CreateTripPage()));},*/

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
