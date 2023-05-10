import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esiway/Screens/Profile/user_car_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../widgets/Tripswidget/infoTrip.dart';
import '../../widgets/Tripswidget/profileTripCard.dart';
import '../../widgets/Tripswidget/tripsComments.dart';
import '../../widgets/Tripswidget/tripsTitle.dart';
import '../../widgets/alertdialog.dart';
import '../../widgets/constant.dart';
import '../../widgets/simple_button.dart';

class RequestInfo extends StatefulWidget {
  String uid;
  List<dynamic>? copassager;
  String preferences;
  String price;
  String departure;
  String arrival;
  RequestInfo({
    required this.arrival,
    required this.departure,
    required this.price,
    required this.copassager,
    required this.uid,
    required this.preferences,
    super.key,
  });

  @override
  State<RequestInfo> createState() => _RequestInfoState();
}

class _RequestInfoState extends State<RequestInfo> {
  List<Comment> comments = [];
  late ProfileTripCard profileInfo;
  late InfoTripBox2 tripInfo;
  late Map<String, dynamic> passenger;
  late Map data;
  List<Co_passenger> coPassengers = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;
    if (widget.copassager != null)
      for (var element in widget.copassager!) {
        passenger = element as Map<String, dynamic>;
        coPassengers.add(Co_passenger(
            FamilyName: passenger["Name"]!,
            Name: passenger["Name"]!,
            imageProfile: null));
      }
    else {
      coPassengers = [];
    }

    tripInfo = InfoTripBox2(
        price: widget.price,
        departure: widget.departure,
        arrival: widget.arrival);
    return Scaffold(
      bottomNavigationBar: NavShape(
        buttonText: 'Cancel',
        buttonColor: bleu_ciel,
      ),
      body: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection("Users")
              .doc(widget.uid)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              DocumentSnapshot documentSnapshot = snapshot.data!;
              try {
                data = documentSnapshot.data() as Map;
                print("comments");
                if (data.containsKey("Comments") && data["Comments"] != [])
                  for (var element in data["Comments"]) {
                    print(element);
                    passenger = element as Map<String, dynamic>;
                    comments.add(Comment(
                        text: passenger["Comment"],
                        name: "${passenger["Name"]} ${passenger["FamilyName"]}",
                        timestamp: DateTime.now(),
                        photoProfile: null));
                  }

                profileInfo = ProfileTripCard(
                    name: "${data['Name']} ${data["FamilyName"]}",
                    staff: data["Status"],
                    rating: 2.5,
                    profileImage: data["ProfilePicture"],
                    color: Colors.white);
                return SafeArea(
                  child: Column(
                    children: [
                      Container(
                        child: Stack(
                          children: [
                            Container(
                              width: screenWidth,
                              height: screenHeight * 0.13,
                              padding: EdgeInsets.only(
                                  left: screenWidth * 0.03,
                                  right: screenWidth * 0.03),
                              decoration: BoxDecoration(
                                color: bleu_bg,
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(0, 0),
                                    blurRadius: 4,
                                    color: bleu_bg.withOpacity(0.15),
                                  ),
                                ],
                              ),
                              child: ProfileTripCard(
                                name: profileInfo.name,
                                profileImage: profileInfo.profileImage,
                                rating: profileInfo.rating,
                                staff: profileInfo.staff,
                                color: profileInfo.color,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Stack(
                          children: [
                            Container(
                              color: bleu_bg,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: color3,
                                borderRadius: BorderRadius.only(
                                    topRight:
                                        Radius.circular(screenWidth * 0.06),
                                    topLeft:
                                        Radius.circular(screenWidth * 0.06)),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  InfoTripBox2(
                                      price: tripInfo.price,
                                      departure: tripInfo.departure,
                                      arrival: tripInfo.arrival),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: screenWidth * 0.04),
                                        child: CustomTitle(
                                            title: 'Preferences',
                                            titleSize: 16.0),
                                      ),
                                      Preferences(
                                        preference1: widget.preferences,
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: screenWidth * 0.04),
                                        child: CustomTitle(
                                            title:
                                                'Your Co-passenger for Today',
                                            titleSize: 16.0),
                                      ),
                                      SizedBox(
                                        height: screenHeight * 0.01,
                                      ),
                                      CoPassenger(
                                        Passengers: coPassengers,
                                      ),
                                    ],
                                  ),
                                  Container(
                                    height: screenHeight * 0.05,
                                    child: SimpleButton(
                                        backgroundcolor: orange,
                                        size: Size(screenWidth * 0.90,
                                            screenHeight * 0.05),
                                        radius: 8,
                                        text: 'Car information',
                                        textcolor: bleu_bg,
                                        weight: FontWeight.w700,
                                        fontsize: 16,
                                        blur: null,
                                        fct: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      UserCarInfo(
                                                        uid: widget.uid,
                                                      )));
                                        }),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: screenWidth * 0.04),
                                        child: CustomTitle(
                                            title: 'Rider\'s Review ',
                                            titleSize: 16.0),
                                      ),
                                      CommentsBloc(comments: comments),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              } catch (e) {
                print(e);
              }
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}

class CommentsBloc extends StatelessWidget {
  const CommentsBloc({
    super.key,
    required this.comments,
  });

  final List<Comment>? comments;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;
    return SingleChildScrollView(
        child: Container(
            decoration: BoxDecoration(
              color: bleu_ciel.withOpacity(0.15),
              borderRadius: BorderRadius.circular(screenWidth * 0.04),
            ),
            margin: EdgeInsets.only(
                left: screenWidth * 0.06, right: screenWidth * 0.03),
            padding: EdgeInsets.all(screenWidth * 0.02),
            height: screenHeight * 0.16,
            child: CommentsList(comments: comments)));
  }
}

class Co_passenger {
  final String FamilyName;
  final String Name;
  final String? imageProfile;

  Co_passenger(
      {required this.FamilyName,
      required this.Name,
      required this.imageProfile});
}

class CoPassenger extends StatelessWidget {
  CoPassenger({
    super.key,
    required this.Passengers,
  });

  List<Co_passenger>? Passengers;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;
    if (Passengers != null) {
      return Row(
        children: Passengers!
            .map(
              (e) => Container(
                margin: EdgeInsets.only(left: screenWidth * 0.05),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 55,
                      width: 55,
                      decoration: BoxDecoration(
                          border: Border.all(
                            width: 0,
                            color: Colors.white,
                          ),
                          shape: BoxShape.circle,
                          image: e.imageProfile == null
                              ? DecorationImage(
                                  image: AssetImage(
                                      "Assets/Images/photo_profile.png"),
                                  fit: BoxFit.cover,
                                )
                              : DecorationImage(
                                  image: NetworkImage(e.imageProfile!),
                                  fit: BoxFit.cover,
                                )),
                    ),
                    SizedBox(
                      height: screenHeight * 0.01,
                    ),
                    SizedBox(
                      width: screenWidth * 0.4,
                      child: AutoSizeText(
                        '${e.Name}' '\n' '${e.FamilyName}',
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                          color: bleu_bg,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      );
    }
    return Container();
  }
}

class Preferences extends StatelessWidget {
  final String preference1;

  const Preferences({
    super.key,
    required this.preference1,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;
    return Container(
      width: screenWidth,
      padding: EdgeInsets.only(
          left: screenWidth * 0.05,
          top: screenHeight * 0.01,
          bottom: screenHeight * 0.02),
      child: Text(
        preference1,
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: bleu_bg,
        ),
      ),
    );
  }
}

class NavShape extends StatelessWidget {
  NavShape({super.key, required this.buttonText, required this.buttonColor});
  final String buttonText;
  final Color buttonColor;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;
    return Stack(
      children: [
        SizedBox(
          width: screenWidth, // Set the size of the SVG image
          height: screenHeight * 0.13,
          child: SvgPicture.asset(
            'Assets/Images/vector1.svg',
            semanticsLabel: 'My SVG Image',
            fit: BoxFit.fill,
          ),
        ),
        Positioned(
          left: screenWidth * 0.08,
          top: screenHeight * 0.055,
          child: SimpleButton(
              backgroundcolor: buttonColor,
              size: Size(screenWidth * 0.86, screenHeight * 0.04),
              radius: 8,
              text: buttonText,
              blur: null,
              weight: FontWeight.w700,
              textcolor: bleu_bg,
              fontsize: 16,
              fct: () {
                showDialog(
                  context: context,
                  builder: (context) => CustomAlertDialog(
                    question: 'Are you sure you want to cancel the trip',
                    greentext: 'Back',
                    redfct: () {},
                    greenfct: () {
                      Navigator.of(context).pop();
                    },
                    redtext: 'Yes',
                  ),
                );
              }),
        ),
      ],
    );
  }
}
