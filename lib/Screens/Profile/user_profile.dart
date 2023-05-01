import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esiway/Screens/Profile/admin.dart';
import 'package:esiway/Screens/Profile/user_car_info.dart';
import 'package:esiway/widgets/alertdialog.dart';
import 'package:esiway/widgets/icons_ESIWay.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:iconsax/iconsax.dart';
import '../../widgets/button.dart';
import '../../widgets/constant.dart';
import '../../widgets/prefixe_icon_button.dart';
import '../../widgets/title_text_field.dart';

class UserProfile extends StatefulWidget {
  UserProfile({Key? key, required this.uid}) : super(key: key);
  String? uid;

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  void back() {
    Navigator.of(context).pop();
  }

  void initState() {
    super.initState();

    _reference = FirebaseFirestore.instance.collection('Users').doc(widget.uid);
    _futureData = _reference.get();
  }

  late DocumentReference _reference;

  //_reference.get()  --> returns Future<DocumentSnapshot>
  //_reference.snapshots() --> Stream<DocumentSnapshot>
  late Future<DocumentSnapshot> _futureData;
  late Map data;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: color3,
        body: FutureBuilder<DocumentSnapshot>(
          future: _futureData,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasData) {
              //Get the data
              DocumentSnapshot documentSnapshot = snapshot.data;
              data = documentSnapshot.data() as Map;

              //display the data
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
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 20, left: 20),
                            width: 80,
                            height: 30,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                PrefixeIconButton(
                                    size: const Size(73, 34),
                                    color: Colors.white,
                                    radius: 8,
                                    text: "Back",
                                    textcolor: Color(0xFF20236C),
                                    weight: FontWeight.w600,
                                    fontsize: 14,
                                    icon: const Icon(
                                      Icons.arrow_back_ios_new_rounded,
                                      color: Color(0xFF72D2C2),
                                      size: 18,
                                    ),
                                    espaceicontext: 5.0,
                                    fct: back),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.183,
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
                                            rating: //data["Rating"],
                                                2.5,
                                            itemBuilder: (context, index) =>
                                                Icon(
                                              Iconsax.star1,
                                              color: orange,
                                            ),
                                            itemCount: 5,
                                            itemSize: 15.0,
                                            direction: Axis.horizontal,
                                          ),
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
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection("Users")
                                                          .doc("${widget.uid}")
                                                          .delete();
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
                                                          .collection("Cars")
                                                          .doc("${widget.uid}")
                                                          .delete();
                                                    } catch (e) {
                                                      print(
                                                          "The file doesn't exists");
                                                    }
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                AdminScreen()));
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
                          TitleTextFeild(title: "Email"),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "${data["Email"]}",
                            style: TextStyle(
                                color: bleu_bg,
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                                fontFamily: "Montserat"),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TitleTextFeild(title: "Phone"),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "${data["Phone"]}",
                            style: TextStyle(
                                color: bleu_bg,
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                                fontFamily: "Montserat"),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TitleTextFeild(title: "Password"),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "${data["Password"]}",
                            style: TextStyle(
                                color: bleu_bg,
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                                fontFamily: "Montserat"),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TitleTextFeild(title: "Created at"),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "${data["CreatedAt"]}",
                            style: TextStyle(
                                color: bleu_bg,
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                                fontFamily: "Montserat"),
                          ),
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
                          TitleTextFeild(title: "Review"),
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
