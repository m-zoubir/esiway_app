import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esiway/Screens/Profile/settings_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../widgets/button.dart';
import '../../widgets/constant.dart';
import '../../widgets/password_field.dart';
import '../../widgets/text_validation.dart';

class ChangePasswordInfo extends StatelessWidget {
  ChangePasswordInfo({super.key}) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            return ChangePassword(password: data["Password"]);
          }

          return Container();
        },
      ),
    );
  }
}

class ChangePassword extends StatefulWidget {
  ChangePassword({Key? key, required this.password}) : super(key: key);

  String password;

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> with UserValidation {
  TextEditingController currentpassword = TextEditingController();
  TextEditingController newpassword = TextEditingController();
  TextEditingController confirmpassword = TextEditingController();

  bool currentpasswordvalidate = true;
  bool newpassordvalidate = true;
  bool confirmpasswordvalidate = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color3,
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: vert,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          color: vert,
        ),
        title: Text(
          "Change password",
          style: TextStyle(
            color: bleu_bg,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
          child: Column(
            children: [
              Text(
                "Create a password with at least 6 letters and \nshould include numbers. You will need this \npassword to log into your account ",
                style: TextStyle(
                  color: bleu_bg,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w400,
                  fontSize: 13,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              MyPasswordField(
                controller: currentpassword,
                bottomheigh: 14,
                title: "Current password",
                validate: currentpasswordvalidate,
                error: "Password incorrect",
                hinttext: "Current password",
              ),
              MyPasswordField(
                controller: newpassword,
                bottomheigh: 14,
                title: "New password",
                error: "At least 6 characters",
                validate: newpassordvalidate,
                hinttext: "New password",
              ),
              MyPasswordField(
                controller: confirmpassword,
                bottomheigh: 14,
                title: "New password Confirmation",
                error: "Re-confirm your password",
                hinttext: "Re-type new  password",
                validate: confirmpasswordvalidate,
              ),
              SizedBox(
                height: 30,
              ),
              Button(
                  color: orange,
                  title: "Confirm",
                  onPressed: () async {
                    User? user = await FirebaseAuth.instance.currentUser;

                    if (widget.password == currentpassword.text) {
                      setState(() {
                        currentpasswordvalidate = true;
                      });
                    } else {
                      setState(() {
                        currentpasswordvalidate = false;
                      });
                    }
                    if (isPassword(newpassword.text)) {
                      setState(() {
                        newpassordvalidate = true;
                      });
                    } else {
                      setState(() {
                        confirmpasswordvalidate = false;
                      });
                    }

                    if (confirmpassword.text == newpassword.text &&
                        confirmpassword.text.isNotEmpty) {
                      setState(() {
                        confirmpasswordvalidate = true;
                      });
                    } else {
                      setState(() {
                        confirmpasswordvalidate = false;
                      });
                    }

                    if (confirmpasswordvalidate &&
                        newpassordvalidate &&
                        currentpasswordvalidate) {
                      user!.updatePassword(newpassword.text);
                      await FirebaseFirestore.instance
                          .collection("Users")
                          .doc(user.uid)
                          .update({
                        "Password": newpassword.text,
                      }).then((value) => Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) {
                                  return SettingsScreen();
                                }),
                              ));
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
