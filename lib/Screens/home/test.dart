import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
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

class Mapy extends StatefulWidget {
  const Mapy({super.key});

  @override
  State<Mapy> createState() => _MapyState();
}

class _MapyState extends State<Mapy> {
  static GoogleMapController? mapController; //controller for Google map

  PolylinePoints polylinePoints = PolylinePoints();

  static String googleAPiKey = "AIzaSyDHViWe1GaVUfN-w6tcCbdGFsPuHSiNwfw";

  static Set<Marker> markers = Set(); //markers for google map

  static LatLng startLocation =
      const LatLng(36.705219106281575, 3.173786850126649);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        //Map widget from google_maps_flutter package
        zoomGesturesEnabled: false, //enable Zoom in, out on map
        initialCameraPosition: CameraPosition(
          //innital position in map
          target: startLocation, //initial position
          zoom: 16.0, //initial zoom level
        ),
        markers: markers, //markers to show on map
        //  polylines: Set<Polyline>.of(polylines.values), //polylines
        mapType: MapType.normal, //map type
        onMapCreated: (controller) {
          //method called when map is created
          setState(() {
            mapController = controller;
          });
        },
      ),
    );
  }
}
