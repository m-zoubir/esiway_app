import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esiway/Screens/Profile/admin.dart';
import 'package:esiway/Screens/Profile/user_profile.dart';
import 'package:esiway/Screens/SignIn_Up/login_page.dart';
import 'package:esiway/widgets/rich_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../widgets/bottom_navbar.dart';
import '../../widgets/constant.dart';
import '../../widgets/icons_ESIWay.dart';

class AdminInfoUsers extends StatelessWidget {
  AdminInfoUsers({super.key}) {
    _reference = FirebaseFirestore.instance.collection('Users').doc(adminuid);
    _futureData = _reference.get();
  }

  late DocumentReference _reference;

  late Future<DocumentSnapshot> _futureData;
  late Map data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
        future: _futureData,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData) {
            //Get the data
            DocumentSnapshot documentSnapshot = snapshot.data;
            try {
              data = documentSnapshot.data() as Map;
              if (FirebaseAuth.instance.currentUser!.uid != adminuid) {
                FirebaseAuth.instance.signOut();
                FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: data["Email"], password: data["Password"]);
              }
              return AdminScreenUsers();
            } catch (e) {
              print(e);
              FirebaseAuth.instance.signOut();
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AdminInfoUsers()));
            }
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class AdminScreenUsers extends StatefulWidget {
  AdminScreenUsers({super.key});

  @override
  State<AdminScreenUsers> createState() {
    return _AdminScreenUsersState();
  }
}

class _AdminScreenUsersState extends State<AdminScreenUsers> {
  @override
  List searchResult = [];
  List idresult = [];

  void searchFromFirebase(String query) async {
    final result = await FirebaseFirestore.instance
        .collection('Users')
        .where(
          'Email',
          isEqualTo: query.toLowerCase() + "@esi.dz",
        )
        .get();
    setState(() {
      searchResult = result.docs.map((e) {
        idresult.add(e.id);
        return e.data();
      }).toList();
    });
  }

  bool search = false;

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color3,
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
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => AdminScreen()));
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
              scale: search ? 1.5 : 0.8,
              child: Icons_ESIWay(
                  icon: search ? "close" : "search", largeur: 35, hauteur: 35),
            ),
            onPressed: () {
              setState(() {
                search = !search;
              });
            },
          ),
        ],
      ),
      body: search
          ? Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height < 700
                        ? MediaQuery.of(context).size.height * 0.07
                        : null,
                    child: TextField(
                      keyboardType: TextInputType.emailAddress,
                      textAlignVertical: TextAlignVertical.center,
                      style: TextStyle(
                        color: bleu_bg,
                        fontFamily: "Montserrat",
                        fontSize: MediaQuery.of(context).size.height < 700
                            ? MediaQuery.of(context).size.height * 0.021
                            : 12.5,
                      ),
                      decoration: InputDecoration(
                        prefixIcon: Transform.scale(
                          scale: 0.6,
                          child: Icons_ESIWay(
                            hauteur: 35,
                            largeur: 35,
                            icon: "search",
                          ),
                        ),
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
                        hintStyle:
                            TextStyle(fontFamily: 'Montserrat', fontSize: 13),
                        hintText: "Search here an email ...",
                      ),
                      onChanged: (query) {
                        searchFromFirebase(query);
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: searchResult.length,
                    itemBuilder: (context, index) {
                      if (idresult[index] == adminuid)
                        return SizedBox();
                      else
                        return GestureDetector(
                            child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                margin: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                height: 120,
                                decoration: BoxDecoration(
                                    color: searchResult[index]['hasCar'] == null
                                        ? Colors.red
                                        : searchResult[index]['hasCar'] == false
                                            ? bleu_ciel.withOpacity(0.4)
                                            : orange.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(6)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        ProfileTripCard(
                                          familyname: searchResult[index]
                                              ['FamilyName'],
                                          name: searchResult[index]['Name'],
                                          profileImage: searchResult[index]
                                                      ["ProfilePicture"] ==
                                                  null
                                              ? null
                                              : searchResult[index]
                                                  ["ProfilePicture"],
                                          color: bleu_bg,
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.15,
                                        ),
                                        CustomRichText(
                                          title: "Status",
                                          value: searchResult[index]["Status"],
                                          titlesize: 12,
                                          valuesize: 10,
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, top: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          CustomRichText(
                                            title: "Phone Number",
                                            value: searchResult[index]["Phone"],
                                            titlesize: 12,
                                            valuesize: 10,
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.08,
                                          ),
                                          CustomRichText(
                                            title: "Email",
                                            value: searchResult[index]["Email"],
                                            titlesize: 12,
                                            valuesize: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )),
                            onTap: () {
                              FirebaseAuth.instance.signOut();
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => UserProfile(
                                        uid: idresult[index],
                                        email: searchResult[index]["Email"],
                                        password: searchResult[index]
                                            ["Password"],
                                      )));
                            });
                    },
                  ),
                ),
              ],
            )
          : FutureBuilder(
              future:
                  FirebaseFirestore.instance.collection("Users").get(), //  ***
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return snapshot.data?.docs[index].id != adminuid
                            ? GestureDetector(
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
                                                false
                                            ? Colors.red
                                            : snapshot.data?.docs[index]
                                                        .data()["hasCar"] ==
                                                    false
                                                ? bleu_ciel.withOpacity(0.4)
                                                : orange.withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(6)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            ProfileTripCard(
                                              familyname: snapshot
                                                  .data?.docs[index]
                                                  .data()['FamilyName'],
                                              name: snapshot.data?.docs[index]
                                                  .data()['Name'],
                                              profileImage: snapshot
                                                          .data?.docs[index]
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
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.15,
                                            ),
                                            CustomRichText(
                                              title: "Status",
                                              value: snapshot.data?.docs[index]
                                                  .data()["Status"],
                                              titlesize: 12,
                                              valuesize: 10,
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 45, top: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              CustomRichText(
                                                title: "Phone Number",
                                                value: snapshot
                                                    .data?.docs[index]
                                                    .data()["Phone"],
                                                titlesize: 12,
                                                valuesize: 10,
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.1,
                                              ),
                                              CustomRichText(
                                                title: "Email",
                                                value: snapshot
                                                    .data?.docs[index]
                                                    .data()["Email"],
                                                titlesize: 12,
                                                valuesize: 10,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )),
                                onTap: () {
                                  FirebaseAuth.instance.signOut();
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => UserProfile(
                                            uid: snapshot
                                                .data?.docs[index].reference.id,
                                            email: snapshot.data?.docs[index]
                                                .data()["Email"],
                                            password: snapshot.data?.docs[index]
                                                .data()["Password"],
                                          )));
                                })
                            : SizedBox();
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
  String familyname;
  String? profileImage;
  Color color;

  ProfileTripCard({
    Key? key,
    required this.name,
    required this.familyname,
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
                text: "$familyname\n",
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
