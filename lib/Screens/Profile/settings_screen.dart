import 'package:esiway/Screens/Profile/admin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../widgets/bottom_navbar.dart';
import '../../widgets/constant.dart';
import '../../widgets/icons_ESIWay.dart';
import '../../widgets/tile_list.dart';
import 'change_password.dart';
import 'delete_account.dart';
import 'profile_screen.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _currentindex = 3;
  int _selectedindex = 3;

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
                  return Profile();
                },
              ),
            );
          },
          color: vert,
        ),
        title: Text(
          "Settings",
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
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Listbox(
              title: "Write to us",
              iconName: "email",
              scale: 0.7,
              onPressed: () async {
                String emailUrl =
                    'mailto:lm_zoubir@esi.dz?subject=This is Subject Title&body=This is Body of Email';
                if (await canLaunchUrlString(emailUrl)) {
                  await launchUrlString(emailUrl);
                } else {
                  throw 'Could not launch $emailUrl';
                }
              },
            ),
            Listbox(
              title: "Call us",
              iconleading: Icon(
                Icons.call,
                color: vert,
              ),
              onPressed: () async {
                final Uri url = Uri(
                  scheme: 'tel',
                  path: "+213796902422",
                );
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
            ),
            Listbox(
              title: "Language",
              iconleading: Icon(
                Iconsax.language_square,
                color: vert,
              ),
              onPressed: () {},
            ),
            Listbox(
                title: "Change my password",
                iconleading: Icon(
                  Iconsax.key,
                  color: vert,
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ChangePasswordInfo()));
                }),
            FirebaseAuth.instance.currentUser!.uid == adminuid
                ? Listbox(
                    title: "Adminstrator",
                    iconleading: Icon(
                      Icons.admin_panel_settings,
                      color: vert,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AdminScreen()));
                      /*
                      TextEditingController password = TextEditingController();
                      bool validate = true;
                      late Map data;
                      showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              SimpleDialog(children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(50)),
                                  height: 260,
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 20),
                                  child: Center(
                                    child: Column(children: [
                                      Text(
                                        "Please , enter your password to get administrator's permissions",
                                        style: TextStyle(
                                            color: bleu_bg,
                                            fontFamily: 'Montserrat',
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      MyPasswordField(
                                        controller: password,
                                        validate: validate,
                                        title: " ",
                                        error: "Password incorrect",
                                      ),
                                      FutureBuilder(
                                          future: FirebaseFirestore.instance
                                              .collection("Users")
                                              .doc(FirebaseAuth
                                                  .instance.currentUser!.uid)
                                              .get(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasError) {
                                              return Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            }
                                            if (snapshot.hasData) {
                                              //Get the data
                                              DocumentSnapshot<
                                                      Map<String, dynamic>>?
                                                  documentSnapshot =
                                                  snapshot.data;
                                              String confirm;
                                              try {
                                                data = documentSnapshot!.data()
                                                    as Map;
                                                confirm = data["Password"];
                                              } catch (e) {
                                                return Center(
                                                    child:
                                                        CircularProgressIndicator());
                                              }

                                              //display the data
                                              return Container(
                                                height: 40,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.3,
                                                child: Button(
                                                  color: orange,
                                                  title: "Continue",
                                                  onPressed: () {
                                                    print(confirm);
                                                    if (confirm == password) {
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  AdminScreen()));
                                                    }
                                                  },
                                                ),
                                              );
                                            }
                                            return Center(
                                                child:
                                                    CircularProgressIndicator());
                                          }),
                                    ]),
                                  ),
                                ),
                              ]));*/
                    })
                : Listbox(
                    title: "Delete my account",
                    iconleading: Icon(
                      Iconsax.trush_square,
                      color: vert,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => DeleteAccountPassword()));
                    }),
          ],
        ),
      ),
    );
  }
}
