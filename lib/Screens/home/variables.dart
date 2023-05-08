import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Variables{
  static double distance= 0.00;
  static String locationName="Search places";
  static String locationNamea="Search places";
  static PointLatLng debut =const PointLatLng(36.72376684085901,2.991892973393687);
  static PointLatLng fin =const PointLatLng(36.64364699576445, 2.9943386163692787);
  static bool created = false;
  static List<LatLng> polylineCoordinates = [];
}
