import 'package:esiway/widgets/constant.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Variables{
  static double distance= 0.00;
  static String locationName="Search places";
  static String locationNamea="Search places";
  static PointLatLng debut = PointLatLng(LocationEsi.latitude,LocationEsi.longitude);
  static PointLatLng fin = PointLatLng(LocationEsi.latitude,LocationEsi.longitude);
  static bool created = false;
  static List<LatLng> polylineCoordinates = [];
}
