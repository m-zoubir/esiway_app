import 'dart:async';

import 'package:esiway/Screens/home/tripSuggestions.dart';
import 'package:esiway/Screens/home/variables.dart';
import 'package:esiway/widgets/icons_ESIWay.dart';
import 'package:esiway/widgets/myTripsWidgets/suggestedTrips.dart';
import 'package:esiway/widgets/prefixe_icon_button.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../widgets/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FindTripPage extends StatefulWidget {
  Set<Marker> markers = Set(); //markers for google map
  GoogleMapController? mapController; //controller for Google map
  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {}; //polylines to show direction
  double distance = 0.0;

  FindTripPage({
    super.key,
    required this.markers,
    required this.mapController,
    required this.polylinePoints,
    required this.polylines,
    required this.distance,
  });

  @override
  State<FindTripPage> createState() => _FindTripPageState();
}

class _FindTripPageState extends State<FindTripPage> {
  void initState() {
    // TODO: implement initState
    Variables.locationName = "Search places";
    Variables.locationNamea = "Search places";
    Variables.debut = const PointLatLng(36.72376684085901, 2.991892973393687);
    Variables.fin = const PointLatLng(36.72376684085901, 2.991892973393687);
    Variables.polylineCoordinates = [];
    Variables.created = false;
    super.initState();
    Timer(Duration(seconds: 8), () {
      /*   Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TripSuggestPage(
                    markers: widget.markers,
                    mapController: widget.mapController,
                    polylinePoints: widget.polylinePoints,
                    polylines: widget.polylines,
                    distance: widget.distance,
                  ))); */
    });
  }

//======================================================================================================//
//=========================================| Variables |================================================//
//======================================================================================================//

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
            initialCameraPosition: const CameraPosition(
              //innital position in map
              target: LocationEsi, //initial position
              zoom: 12.0, //initial zoom level
            ),
            markers: widget.markers, //markers to show on map
            polylines: Set<Polyline>.of(widget.polylines.values), //polylines
            mapType: MapType.normal, //map type
            onMapCreated: (controller) {
              //method called when map is created
              setState(() {
                widget.mapController = controller;
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
              height: hauteur * 0.545,
              child: SingleChildScrollView(
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
                          // mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: hauteur * 0.1),
                            Center(
                              child: Stack(
                                children: [
                                  LoadingAnimationWidget.beat(
                                    color: color6.withOpacity(0.2),
                                    size: hauteur * 0.35,
                                  ),
                                  Positioned(
                                    top: hauteur * 0.12,
                                    left: largeur * 0.24,
                                    child: const CircleAvatar(
                                      backgroundImage: AssetImage(
                                          "Assets/Images/logo_background.png"),
                                      radius:
                                          50, // adjust the radius to the size you want
                                    ),
                                  )
                                ],
                              ),
                            ),
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
                    Navigator.pop(context);
                  }),
            ),
          )
        ],
      ),
    );
  }
}
