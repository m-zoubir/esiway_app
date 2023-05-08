import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esiway/Screens/Profile/admin_users.dart';
import 'package:esiway/Screens/home/home_page.dart';
import 'package:esiway/widgets/icons_ESIWay.dart';
import 'package:esiway/widgets/rich_text.dart';
import 'package:esiway/widgets/simple_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../widgets/constant.dart';
import '../../widgets/prefixe_icon_button.dart';

class SearchResult extends StatefulWidget {
  @override
  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {

  @override
  LatLng arrivee = const LatLng(36.705219106281575, 3.273786850126649);
  List<LatLng> PolyLinesCoordinates = [];
  List<LatLng> polyLinesCoordinates = [];

  Set<Polyline> polylines = {};
  Set<Marker> markers = {};
  List searchResult = [];
  List idresult = [];


  ///+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++///

  void back() {Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomePage()));}


  Future<void> getPolylinePoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      APIKEY,

      PointLatLng(polyLinesCoordinates[0].latitude, polyLinesCoordinates[0].longitude,),
      PointLatLng(polyLinesCoordinates[1].latitude, polyLinesCoordinates[1].longitude,

      ),
    );

    if (result.points.isNotEmpty) {
      PolyLinesCoordinates = [];
      result.points.forEach((PointLatLng point) {
        return PolyLinesCoordinates.add(
            LatLng(point.latitude, point.longitude));
      });
    }
  }


  Set<Marker> markers = {};

  List searchResult = [];
  List idresult = [];

  void searchFromFirebase(String query) async {
    final result = await FirebaseFirestore.instance
        .collection('Trips')
        .where(
          'Date',
          isEqualTo: query,
        )
        .get();
    setState(() {
      searchResult = result.docs.map((e) {
        idresult.add(e.id);
        return e.data();
      }).toList();

    });
  }

  @override
  void initState() {
    // searchFromFirebase(DateTime.now().toString());
    super.initState();
  }

  Widget build(BuildContext context) {
    Marker newMarker1;
    Marker newMarker2;
    Future.delayed(Duration.zero, () {
      getPolylinePoints();
      setState(() {});
    });


    return SafeArea(
      child: Scaffold(
        body: Stack(children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LocationEsi,
              zoom: 10.0,
            ),
            polylines: polylines.map((e) => e).toSet(),
            markers: markers.map((e) => e).toSet(),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height <= 700
                    ? MediaQuery.of(context).size.height * 0.44
                    : MediaQuery.of(context).size.height * 0.5),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                ),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 15, left: 20, right: 20, bottom: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: CustomRichText(
                        title: "Hello, Nesrine",
                        value: "We found 2 drivers for your request",
                        valuesize: MediaQuery.of(context).size.height < 700
                            ? MediaQuery.of(context).size.height * 0.02
                            : 13,
                        titlesize: MediaQuery.of(context).size.height < 700
                            ? MediaQuery.of(context).size.height * 0.035
                            : 25,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: PageView.builder(
                          itemCount: 2,
                          pageSnapping: true,
                          itemBuilder: (context, pagePosition) {
                            newMarker1 = Marker(
                              markerId: MarkerId('$pagePosition departure'),
                              position: LatLng(LocationEsi.latitude,
                                  LocationEsi.longitude + pagePosition),
                            );
                            newMarker2 = Marker(
                              markerId: MarkerId('$pagePosition arrival'),
                              position: LatLng(arrivee.latitude,
                                  arrivee.longitude + pagePosition),
                            );
                            markers.clear();
                            markers.add(newMarker1);
                            markers.add(newMarker2);
                            polyLinesCoordinates = [
                              LatLng(LocationEsi.latitude,
                                  LocationEsi.longitude + pagePosition),
                              LatLng(arrivee.latitude,
                                  arrivee.longitude + pagePosition),
                            ];
                            polylines.clear();
                            polylines.add(
                              Polyline(
                                polylineId:
                                    const PolylineId("departure - arrival"),
                                geodesic: false,
                                points: PolyLinesCoordinates,
                                color: bleu_bg.withOpacity(0.9),
                                width: 5,
                              ),
                            );
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 10),
                              decoration: BoxDecoration(
                                  color: bleu_ciel.withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        ProfileTripCard(
                                          name: "name",
                                          familyname: "familyname",
                                          color: bleu_bg,
                                        ),
                                        RatingBarIndicator(
                                          rating: 2.5,
                                          itemCount: 5,
                                          itemSize: 15.0,
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
                                    Padding(
                                      padding: const EdgeInsets.only(left: 65),
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                            'Assets/Icons/tripshape.svg',
                                            semanticsLabel: 'My SVG Image',
                                            width: 2,
                                            // Set the size of the SVG image
                                            height: 42,
                                          ),
                                          const SizedBox(width: 2),
                                          RichText(
                                            text: const TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: "Depart\n\n",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontFamily: 'Montserrat',
                                                    fontWeight: FontWeight.w700,
                                                    color: bleu_bg,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: 'arrival',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontFamily: 'Montserrat',
                                                    fontWeight: FontWeight.w700,
                                                    color: bleu_bg,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        CustomRichText(
                                          title: "date",
                                          value: "12-12-2023",
                                          titlesize: 12,
                                          valuesize: 10,
                                        ),
                                        CustomRichText(
                                          title: 'time',
                                          value: "value",
                                          titlesize: 12,
                                          valuesize: 10,
                                        ),
                                        CustomRichText(
                                          title: "seats",
                                          value: "value",
                                          titlesize: 12,
                                          valuesize: 10,
                                        ),
                                      ],
                                    ),
                                    CustomRichText(
                                      title: "Preferences",
                                      titlesize: 12,
                                      value: "value",
                                      valuesize: 10,
                                    ),
                                    Column(
                                      children: [
                                        Container(
                                          color: orange.withOpacity(0.5),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 5),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    const Text(
                                                      "data ",
                                                      style: TextStyle(
                                                          color: bleu_bg,
                                                          fontFamily:
                                                              "Montserrat",
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    const Text(
                                                      "data ",
                                                      style: TextStyle(
                                                          color: bleu_bg,
                                                          fontFamily:
                                                              "Montserrat",
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ],
                                                ),
                                                const Text(
                                                  "data ",
                                                  style: TextStyle(
                                                      color: bleu_bg,
                                                      fontFamily: "Montserrat",
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 17,
                                              child: SimpleButton(
                                                  backgroundcolor:
                                                      const Color(0xFFFFA18E),
                                                  size: Size(
                                                      MediaQuery.of(context)
                                                          .size
                                                          .width,
                                                      45),
                                                  radius: 10,
                                                  text: 'Request',
                                                  textcolor:
                                                      const Color(0xFF20236C),
                                                  weight: FontWeight.w700,
                                                  fontsize: 18,
                                                  blur: null,
                                                  fct: searchFromFirebase),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                                flex: 3,
                                                child: Container(
                                                  height: 45,
                                                  decoration: BoxDecoration(
                                                    color: orange,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: IconButton(
                                                      onPressed: () {},
                                                      icon: Transform.scale(
                                                        scale: 1,
                                                        child: const Icons_ESIWay(
                                                            icon: "add_message",
                                                            largeur: 24,
                                                            hauteur: 24),
                                                      )),
                                                )),
                                          ],
                                        ),
                                      ],
                                    )
                                  ]),
                            );
                          }),
                    ),
                    const SizedBox(
                      height: 15,
                    )
                  ],
                ),
              ),
            ),
          ),
        ]),

    var largeur = MediaQuery.of(context).size.width;
    var hauteur = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: Stack(
            children: [
              GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: LocationEsi,
                  zoom: 10.0,
                ),
                polylines: polylines.map((e) => e).toSet(),
                markers: markers.map((e) => e).toSet(),
              ),
              Padding(
                padding: EdgeInsets.only(top: hauteur <= 700 ? hauteur * 0.44 : hauteur * 0.5),
                child: Container(
                  width: largeur,
                  decoration: const BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(23), topRight: Radius.circular(23),), color: Colors.white,),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15, left: 20, right: 20, bottom: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// the first and second lines
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: CustomRichText(
                            title: "Hello,",
                            value: "This is what we found for you:",
                            valuesize: hauteur < 700
                                ? hauteur * 0.02
                                : 13,
                            titlesize: hauteur < 700
                                ? hauteur * 0.035
                                : 25,
                          ),
                        ),
                        const SizedBox(height: 10),
                        /// Trips inforamations Box
                        Expanded(
                          child: PageView.builder(
                              itemCount: 2,
                              pageSnapping: true,
                              itemBuilder: (context, pagePosition) {
                                newMarker1 = Marker(
                                  markerId: MarkerId('$pagePosition departure'),
                                  position: LatLng(LocationEsi.latitude, LocationEsi.longitude + pagePosition),
                                );
                                newMarker2 = Marker(
                                  markerId: MarkerId('$pagePosition arrival'),
                                  position: LatLng(arrivee.latitude, arrivee.longitude + pagePosition),
                                );
                                markers.clear();
                                markers.add(newMarker1);
                                markers.add(newMarker2);
                                polyLinesCoordinates = [
                                  LatLng(LocationEsi.latitude, LocationEsi.longitude + pagePosition),
                                  LatLng(arrivee.latitude, arrivee.longitude + pagePosition),
                                ];
                                polylines.clear();
                                polylines.add(
                                  Polyline(
                                    polylineId: const PolylineId("departure - arrival"),
                                    geodesic: false,
                                    points: PolyLinesCoordinates,
                                    color: bleu_bg.withOpacity(0.9),
                                    width: 5,
                                  ),
                                );
                                return Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 5),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18, vertical: 10),
                                  decoration: BoxDecoration(color: bleu_ciel.withOpacity(0.4), borderRadius: BorderRadius.circular(5)),
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            ProfileTripCard(
                                              name: "Student",
                                              familyname: "Yasmine Zaidi",
                                              color: bleu_bg,
                                            ),
                                            RatingBarIndicator(
                                              rating: 2.5,
                                              itemCount: 5,
                                              itemSize: 15.0,
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
                                        ///Box of daprt arrival
                                        Padding(
                                          padding:
                                          const EdgeInsets.only(left: 65),
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(
                                                'Assets/Icons/tripshape.svg',
                                                semanticsLabel: 'My SVG Image',
                                                width: 2,
                                                // Set the size of the SVG image
                                                height: 42,
                                              ),
                                              const SizedBox(width: 2),
                                              RichText(
                                                text: const TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: "Depart\n\n",
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontFamily:
                                                        'Montserrat',
                                                        fontWeight:
                                                        FontWeight.w700,
                                                        color: bleu_bg,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: 'arrival',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontFamily:
                                                        'Montserrat',
                                                        fontWeight:
                                                        FontWeight.w700,
                                                        color: bleu_bg,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        /// Row of Date time seats car
                                        Row(

                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                          children: [
                                            CustomRichText(
                                              title: "date",
                                              value: "12-12-2023",
                                              titlesize: 12,
                                              valuesize: 10,
                                            ),
                                            CustomRichText(
                                              title: 'time',
                                              value: "value",
                                              titlesize: 12,
                                              valuesize: 10,
                                            ),
                                            CustomRichText(
                                              title: "seats",
                                              value: "value",
                                              titlesize: 12,
                                              valuesize: 10,
                                            ),
                                            CustomRichText(
                                              title: "Car",
                                              value: "Megane",
                                              titlesize: 12,
                                              valuesize: 10,
                                            ),
                                          ],
                                        ),
                                        ///Prefernces
                                        CustomRichText(
                                          title: "Preferences",
                                          titlesize: 12,
                                          value: "value",
                                          valuesize: 10,
                                        ),
                                        Column(
                                          children: [
                                            /// Row of price
                                            Container(
                                              color: orange.withOpacity(0.5),
                                              child: Padding(
                                                padding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 5),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: const [
                                                        Text(
                                                          "Price",
                                                          style: TextStyle(
                                                              color: bleu_bg,
                                                              fontFamily:
                                                              "Montserrat",
                                                              fontSize: 10,
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold),
                                                        ),
                                                        Text(
                                                          "(negosiable)",
                                                          style: TextStyle(
                                                              color: bleu_bg,
                                                              fontFamily:
                                                              "Montserrat",
                                                              fontSize: 10,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w500),
                                                        ),
                                                      ],
                                                    ),
                                                    const Text(
                                                      "500Da",
                                                      style: TextStyle(
                                                          color: bleu_bg,
                                                          fontFamily:
                                                          "Montserrat",
                                                          fontSize: 10,
                                                          fontWeight:
                                                          FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 8,),
                                            /// Request Button & message Button
                                            Row(
                                              children: [
                                                Expanded(
                                                  flex: 17,
                                                  child: SimpleButton(
                                                      backgroundcolor:
                                                      const Color(0xFFFFA18E),
                                                      size: Size(largeur, 45),
                                                      radius: 10,
                                                      text: 'Request',
                                                      textcolor: const Color(0xFF20236C),
                                                      weight: FontWeight.w700,
                                                      fontsize: 18,
                                                      blur: null,
                                                      fct: searchFromFirebase),
                                                ),
                                                const SizedBox(width: 5,),
                                                Expanded(
                                                    flex: 3,
                                                    child: Container(
                                                      height: 45,
                                                      decoration: BoxDecoration(
                                                        color: orange,
                                                        borderRadius:
                                                        BorderRadius.circular(10),
                                                      ),
                                                      child: IconButton(
                                                          onPressed: () {},
                                                          icon: Transform.scale(
                                                            scale: 1,
                                                            child: const Icons_ESIWay(
                                                                icon: "add_message",
                                                                largeur: 24,
                                                                hauteur: 24),
                                                          )),
                                                    )),
                                              ],
                                            ),
                                          ],
                                        )
                                      ]),
                                );
                              }),
                        ),
                        const SizedBox(height: 15,)
                      ],
                    ),
                  ),
                ),
              ),
            ]),

      ),
    );
  }
}
