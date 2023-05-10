import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esiway/Screens/Profile/admin_usertrip.dart';
import 'package:esiway/Screens/Profile/user_car_info.dart';
import 'package:esiway/widgets/alertdialog.dart';
import 'package:esiway/widgets/icons_ESIWay.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconsax/iconsax.dart';
import '../../widgets/Tripswidget/tripsComments.dart';
import '../../widgets/Tripswidget/tripsTitle.dart';
import '../../widgets/button.dart';
import '../../widgets/constant.dart';
import '../../widgets/prefixe_icon_button.dart';
import '../../widgets/rich_text.dart';
import '../Trips/request_info.dart';
import 'admin_users.dart';

class UserProfile extends StatefulWidget {
  UserProfile(
      {Key? key,
      required this.uid,
      required this.email,
      required this.password})
      : super(key: key);
  String? uid;
  String? email;
  String? password;

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  void back() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => AdminInfoUsers()));
  }

  List<Comment> comments = [];

  void initState() {
    super.initState();
    _reference = FirebaseFirestore.instance.collection('Users').doc(widget.uid);
    _futureData = _reference.get();
    FirebaseAuth.instance.signInWithEmailAndPassword(
        email: widget.email!, password: widget.password!);
  }

  late DocumentReference _reference;

  late Future<DocumentSnapshot> _futureData;
  late Map data;
  Timestamp? createdAt;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: color3,
        body: FutureBuilder<DocumentSnapshot>(
          future: _futureData,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            Map<String, dynamic> passenger;
            if (snapshot.hasError) {
              print('Error ${snapshot.error}');
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasData) {
              //Get the data
              DocumentSnapshot documentSnapshot = snapshot.data;
              data = documentSnapshot.data() as Map;
              if (data["Comments"] != null)
                for (var element in data["Comments"]) {
                  passenger = element as Map<String, dynamic>;
                  comments.add(Comment(
                      text: passenger["Comment"],
                      name: "${passenger["Name"]} ${passenger["FamilyName"]}",
                      timestamp: DateTime.now(),
                      photoProfile: null));
                }
              createdAt = data["CreatedAt"];
              return SafeArea(
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.33,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          image: data.containsKey("ProfilePicture") == false
                              ? DecorationImage(
                                  image: AssetImage(
                                      "Assets/Images/photo_profile.png"),
                                  fit: BoxFit.cover,
                                )
                              : DecorationImage(
                                  image: NetworkImage(data["ProfilePicture"]),
                                  fit: BoxFit.cover,
                                )),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
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
                                      icon: "arrow_left",
                                      largeur: 30,
                                      hauteur: 30),
                                ),
                                espaceicontext: 5.0,
                                fct: back),
                          ),
                          Container(
                            height: 50,
                            color: Colors.black.withOpacity(0.66),
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(
                              horizontal: 25,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text:
                                                "${data["FamilyName"]} ${data["Name"]}\n",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          ),
                                          TextSpan(
                                            text: "${data["Status"]}",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    data.containsKey("hasCar") == false ||
                                            data["hasCar"] == false
                                        ? SizedBox()
                                        : RatingBarIndicator(
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
                                IconButton(
                                  icon: Transform.scale(
                                    scale: 0.7,
                                    child: Icons_ESIWay(
                                        icon: "more", largeur: 50, hauteur: 50),
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          SimpleDialog(
                                        backgroundColor:
                                            bleu_bg.withOpacity(0.8),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(4))),
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 20),
                                        children: [
                                          TextButton(
                                            child: Text(
                                              "Send notification",
                                              style: TextStyle(
                                                  color: orange,
                                                  fontWeight: FontWeight.normal,
                                                  fontFamily: "Montserrat"),
                                            ),
                                            onPressed: () {},
                                          ),
                                          Divider(
                                            color: Colors.white,
                                            height: 1,
                                          ),
                                          TextButton(
                                            child: Text(
                                              "Delete",
                                              style: TextStyle(
                                                  color: orange,
                                                  fontWeight: FontWeight.normal,
                                                  fontFamily: "Montserrat"),
                                            ),
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        CustomAlertDialog(
                                                  greentext: "Cancel",
                                                  question:
                                                      "Are you sure you want to delete this user",
                                                  redtext: "Delete",
                                                  greenfct: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  redfct: () async {
                                                    final Profile = FirebaseStorage
                                                        .instance
                                                        .ref()
                                                        .child(
                                                            "images/${widget.uid}");
                                                    final Car = FirebaseStorage
                                                        .instance
                                                        .ref()
                                                        .child(
                                                            "Cars/${widget.uid}");
                                                    final Policy = FirebaseStorage
                                                        .instance
                                                        .ref()
                                                        .child(
                                                            "Policy/${widget.uid}");
                                                    try {
                                                      await Car.delete();
                                                      await Policy.delete();
                                                    } catch (e) {
                                                      print(
                                                          "The fle doesn't exists");
                                                    }
                                                    try {
                                                      await Profile.delete();
                                                    } catch (e) {
                                                      print(
                                                          "The fle doesn't exists");
                                                    }
                                                    try {
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection("Users")
                                                          .doc("${widget.uid}")
                                                          .delete();
                                                    } catch (e) {
                                                      print(e);
                                                    }

                                                    try {
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection("Cars")
                                                          .doc("${widget.uid}")
                                                          .delete();
                                                    } catch (e) {
                                                      print(
                                                          "The file doesn't exists");
                                                    }
                                                    try {
                                                      FirebaseAuth
                                                          .instance.currentUser!
                                                          .delete();
                                                    } catch (e) {
                                                      print(e);
                                                    }

                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                AdminInfoUsers()));
                                                  },
                                                ),
                                              );
                                            },
                                          ),
                                          Divider(
                                            color: Colors.white,
                                            height: 1,
                                          ),
                                          TextButton(
                                            child: Text(
                                              "Disable",
                                              style: TextStyle(
                                                  color: orange,
                                                  fontWeight: FontWeight.normal,
                                                  fontFamily: "Montserrat"),
                                            ),
                                            onPressed: () {},
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomRichText(
                                  title: "Email", value: "${data["Email"]}"),
                              CustomRichText(
                                  title: "Phone", value: "${data["Phone"]}"),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomRichText(
                                  title: "Password",
                                  value: "${data["Password"]}"),
                              CustomRichText(
                                  title: "Gender        ",
                                  value: "${data["Gender"]}"),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          CustomRichText(
                              title: "Member since",
                              value: "${createdAt!.toDate()}"),
                          SizedBox(
                            height: 25,
                          ),
                          data.containsKey("hasCar") == false ||
                                  data["hasCar"] == false
                              ? SizedBox()
                              : Container(
                                  child: Button(
                                      color: orange,
                                      title: "Car information",
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    UserCarInfo()));
                                      }),
                                  height: 34,
                                  width: double.infinity,
                                ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            child: Button(
                                color: orange,
                                title: "Trips",
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => UserTrips()));
                                }),
                            height: 37,
                            width: double.infinity,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        0.04),
                                child: CustomTitle(
                                    title: 'Rider\'s Review ', titleSize: 16.0),
                              ),
                              CommentsBloc(comments: comments),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }

            return Container();
          },
        ));
  }
}
