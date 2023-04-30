import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esiway/Screens/Profile/settings_screen.dart';
import 'package:esiway/Screens/Profile/user_profile.dart';
import 'package:flutter/material.dart';
import '../../widgets/bottom_navbar.dart';
import '../../widgets/constant.dart';
import '../../widgets/icons_ESIWay.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color3,
      bottomNavigationBar: BottomNavBar(currentindex: 3),
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        leading: IconButton(
          icon: Transform.scale(
            scale: 0.9,
            child: Icons_ESIWay(icon: "arrow_left", largeur: 50, hauteur: 50),
          ),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return SettingsScreen();
                },
              ),
            );
          },
          color: vert,
        ),
        title: Text(
          "Administrator",
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
      body: FutureBuilder(
          future: FirebaseFirestore.instance.collection("Users").get(), //  ***
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          margin: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          height: 120,
                          decoration: BoxDecoration(
                              color: snapshot.data?.docs[index]
                                              .data()
                                              .containsKey("hasCar") ==
                                          false ||
                                      snapshot.data?.docs[index]
                                              .data()["hasCar"] ==
                                          false
                                  ? bleu_ciel
                                  : orange,
                              borderRadius: BorderRadius.circular(6)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  ProfileTripCard(
                                    name: //snapshot.data?.docs[index].data()['Name'],
                                        "Name",
                                    profileImage: snapshot.data?.docs[index]
                                                .data()
                                                .containsKey(
                                                    "ProfilePicture") ==
                                            false
                                        ? null
                                        : snapshot.data?.docs[index]
                                            .data()["ProfilePicture"],
                                    color: bleu_bg,
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.15,
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "Status\n",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w700,
                                            color: bleu_bg,
                                          ),
                                        ),
                                        TextSpan(
                                          text: snapshot.data?.docs[index]
                                              .data()["Status"],
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w500,
                                            color: bleu_bg,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 45, top: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: "Phone Number\n",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w700,
                                              color: bleu_bg,
                                            ),
                                          ),
                                          TextSpan(
                                            text: snapshot.data?.docs[index]
                                                .data()["Phone"],
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w500,
                                              color: bleu_bg,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.1,
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: "Email\n",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w700,
                                              color: bleu_bg,
                                            ),
                                          ),
                                          TextSpan(
                                            text: snapshot.data?.docs[index]
                                                .data()["Email"],
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w500,
                                              color: bleu_bg,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )),
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => UserProfile(
                                uid: snapshot.data?.docs[index].reference.id,
                              ))),
                    );
                  });
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}

class ProfileTripCard extends StatelessWidget {
  String name;
  String? profileImage;
  Color color;

  ProfileTripCard({
    Key? key,
    required this.name,
    this.profileImage,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final screenWidth = size.width;
    final screenHeight = size.height;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
              border: Border.all(
                width: 0,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              shape: BoxShape.circle,
              image: profileImage == null
                  ? DecorationImage(
                      image: AssetImage("Assets/Images/photo_profile.png"),
                      fit: BoxFit.cover,
                    )
                  : DecorationImage(
                      image: NetworkImage(profileImage!),
                      fit: BoxFit.cover,
                    )),
        ),
        SizedBox(
          width: screenWidth * 0.02,
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "$name\n",
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                  color: bleu_bg,
                ),
              ),
              TextSpan(
                text: '$name',
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
    );
  }
}
