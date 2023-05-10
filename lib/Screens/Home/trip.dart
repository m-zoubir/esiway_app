import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Trip{
  static String? depart;
  static String? arrivee;
  static PointLatLng? departLatLng;
  static PointLatLng? arriveeLatLng;
  static String? date;
  static String? time;
  static String? seats;
  static String? price;
  static String? methode;
  static List<LatLng> polylineCoordinates = [];

}