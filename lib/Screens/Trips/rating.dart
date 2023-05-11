import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esiway/widgets/icons_ESIWay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import '../../widgets/constant.dart';
import '../../widgets/prefixe_icon_button.dart';
import '../Home/home_page.dart';

class Home extends StatefulWidget {
  Home(
      {super.key,
      required this.uid,
      required this.imageUrl,
      required this.rating,
      required this.name});
  String uid;
  String name;
  String? imageUrl;
  double rating;
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double rating = 2.5;
  Future<void> back() async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(widget.uid)
        .update({
      "Rate": (rating + widget.rating) / 2,
    }).then((value) => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => HomePage())));
  }

  late String Name;
  String? imageUrl;
  @override
  void initState() {
    super.initState();
  }

  TextEditingController feedbackcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: color3,
        body: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LocationEsi,
                zoom: 10.0,
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height <= 700
                        ? MediaQuery.of(context).size.height * 0.44
                        : MediaQuery.of(context).size.height * 0.5),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(23),
                      topRight: Radius.circular(23),
                    ),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 25,
                        left: 20,
                        right: 20,
                        bottom: MediaQuery.of(context).size.height * 0.08),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Rate tour trip",
                          style: TextStyle(
                              color: bleu_bg,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                              border: Border.all(
                                width: 0,
                                color: Colors.white,
                              ),
                              shape: BoxShape.circle,
                              image: widget.imageUrl == null
                                  ? DecorationImage(
                                      image: AssetImage(
                                          "Assets/Images/photo_profile.png"),
                                      fit: BoxFit.cover,
                                    )
                                  : DecorationImage(
                                      image: NetworkImage(widget.imageUrl!),
                                      fit: BoxFit.cover,
                                    )),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          widget.name,
                          style: TextStyle(
                              color: bleu_bg,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        RatingBar.builder(
                          initialRating: 2.5,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 35.0,
                          unratedColor: orange.withOpacity(0.25),
                          itemBuilder: (context, _) => SvgPicture.asset(
                            'Assets/Icons/starFilled.svg',
                            width: 8,
                            height: 8,
                          ),
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 4.0),
                          onRatingUpdate: (rating) {
                            this.rating = rating;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.95,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            color: Color.fromARGB(255, 255, 255, 255),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromARGB(156, 32, 35, 108)
                                    .withOpacity(0.05),
                                spreadRadius: 3,
                                blurRadius: 5,
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(32, 35, 108, 0.15),
                                  spreadRadius: 2,
                                  blurRadius: 18,
                                  offset: const Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Container(
                              height: MediaQuery.of(context).size.height < 700
                                  ? MediaQuery.of(context).size.height * 0.07
                                  : null,
                              child: TextField(
                                controller: feedbackcontroller,
                                textAlignVertical: TextAlignVertical.center,
                                style: TextStyle(
                                  color: bleu_bg,
                                  fontFamily: "Montserrat",
                                  fontSize:
                                      MediaQuery.of(context).size.height < 700
                                          ? MediaQuery.of(context).size.height *
                                              0.021
                                          : 12.5,
                                ),
                                decoration: InputDecoration(
                                  suffixIcon: GestureDetector(
                                    onTap: () async {
                                      if (feedbackcontroller.text
                                          .trim()
                                          .isNotEmpty) {
                                        Map comment = {
                                          "Name": "zoubir",
                                          "Comment": feedbackcontroller.text,
                                          "Date": DateFormat("dd-MM-yyyy")
                                              .format(DateTime.now())
                                        };
                                        await FirebaseFirestore.instance
                                            .collection("Users")
                                            .doc(widget.uid)
                                            .update({
                                          "Rate": (rating + widget.rating) / 2,
                                          "Comments":
                                              FieldValue.arrayUnion([comment]),
                                        });
                                      } else {
                                        await FirebaseFirestore.instance
                                            .collection("Users")
                                            .doc(widget.uid)
                                            .update({
                                          "Rate": (rating + widget.rating) / 2,
                                        });
                                      }
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  HomePage()));
                                    },
                                    child: Transform.scale(
                                      scale: 0.5,
                                      child: Icons_ESIWay(
                                        hauteur: 25,
                                        largeur: 25,
                                        icon: "send",
                                      ),
                                    ),
                                  ),
                                  hintText: "Write your comment here  ...",
                                  hintStyle: TextStyle(
                                      fontFamily: 'Montserrat', fontSize: 12),
                                  filled: true,
                                  fillColor: Colors.white,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                      color: vert,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20, left: 20),
              width: 80,
              height: 35,
              child: PrefixeIconButton(
                  size: const Size(73, 34),
                  color: Colors.white,
                  radius: 8,
                  text: "Back",
                  textcolor: Color(0xFF20236C),
                  weight: FontWeight.w600,
                  fontsize: 14,
                  icon: Transform.scale(
                    scale: 0.75,
                    child: Icons_ESIWay(
                        icon: "arrow_left", largeur: 30, hauteur: 30),
                  ),
                  espaceicontext: 5.0,
                  fct: back),
            ),
          ],
        ),
      ),
    );
  }
}
