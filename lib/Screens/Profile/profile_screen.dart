import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esiway/Screens/Profile/history.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';
import '../../widgets/bottom_navbar.dart';
import '../../widgets/button.dart';
import '../../widgets/constant.dart';
import '../../widgets/icons_ESIWay.dart';
import '../../widgets/text_validation.dart';
import '../../widgets/tile_list.dart';
import '../SignIn_Up/login_page.dart';
import 'car_information_screen.dart';
import 'edit_profile_screen.dart';
import 'settings_screen.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with UserValidation {
  String user_picture = "Assets/Images/photo_profile.png";

  @override
  void initState() {
    super.initState();

    _reference = FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid);
    _futureData = _reference.get();
  }

  late DocumentReference _reference;

  //_reference.get()  --> returns Future<DocumentSnapshot>
  //_reference.snapshots() --> Stream<DocumentSnapshot>
  late Future<DocumentSnapshot> _futureData;
  late Map data;

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color3,
      bottomNavigationBar: BottomNavBar(currentindex: 3),
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        leading: Container(
          padding: EdgeInsets.only(left: 8),
          child: Center(
            child: Image.asset(app),
          ),
        ),
        title: Text(
          "Profile",
          style: TextStyle(
            color: bleu_bg,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Transform.scale(
              scale: 0.8,
              child: Icons_ESIWay(icon: "help", largeur: 35, hauteur: 35),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _futureData,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData) {
            //Get the data
            DocumentSnapshot documentSnapshot = snapshot.data;
            String name;
            String familyName;
            double rating;
            try {
              data = documentSnapshot.data() as Map;
              name = data["Name"];
              familyName = data["FamilyName"];
              rating = data.containsKey('Rate') ? data["Rate"] : 2.5;
            } catch (e) {
              name = "Name";
              familyName = "FamilyName";
              rating = 0;
            }

            //display the data
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 18.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 90,
                      width: 90,
                      decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                          shape: BoxShape.circle,
                          image: data.containsKey("ProfilePicture") == false
                              ? DecorationImage(
                                  image: AssetImage(user_picture),
                                  fit: BoxFit.cover,
                                )
                              : DecorationImage(
                                  image: NetworkImage(data["ProfilePicture"]),
                                  fit: BoxFit.cover,
                                )),
                    ),
                    const SizedBox(
                      height: 12.0,
                    ),
                    Container(
                      child: Text(
                        "${name} ${familyName}",
                        style: TextStyle(
                          color: bleu_bg,
                          fontFamily: "Montserrat",
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 2.0,
                    ),
                    Container(
                      child: Text(
                        "${FirebaseAuth.instance.currentUser!.email}",
                        style: TextStyle(
                          color: bleu_bg,
                          fontFamily: "Montserrat",
                          fontSize: 12.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 4.0,
                    ),
                    data["hasCar"] == true
                        ? RatingBarIndicator(
                            rating: rating,
                            itemCount: 5,
                            itemSize: 15.0,
                            unratedColor: orange.withOpacity(0.25),
                            itemBuilder: (context, _) => SvgPicture.asset(
                              'Assets/Icons/starFilled.svg',
                              width: 8,
                              height: 8,
                            ),
                          )
                        : const SizedBox(
                            height: 1.0,
                          ),
                    const SizedBox(
                      height: 21.0,
                    ),
                    Listbox(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return EditProfileInfo();
                            },
                          ),
                        );
                      },
                      title: "Edit my profile",
                      iconName: "user",
                      scale: 0.7,
                    ),
                    Listbox(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => HistoryScreen()));
                      },
                      title: "History",
                      iconleading: const Icon(
                        Icons.history,
                        color: vert,
                      ),
                    ),
                    Listbox(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return CarInfo();
                            },
                          ),
                        );
                      },
                      title: "My car",
                      iconName: "car",
                      scale: 0.7,
                    ),
                    Listbox(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return SettingsScreen();
                            },
                          ),
                        );
                      },
                      title: "Settings",
                      iconleading: const Icon(
                        Icons.settings,
                        color: vert,
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 40),
                      child: Button(
                        color: orange,
                        title: "Log out",
                        onPressed: () {
                          FirebaseAuth.instance
                              .signOut()
                              .then((value) => Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) {
                                      return LogInPage();
                                    }),
                                  ));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
